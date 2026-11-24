import React from "react";
import { redirect, notFound } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { normalizeSubjectRow } from "@/lib/supabase/schema-compat";
import {
  computeChapterMedal,
  computeFourStageProgress,
  getStudentAccessibleSubjectIds,
  isUniversalSkillSubject,
  PLAY_LAB_QUESTION_TYPES,
} from "@/app/api/student/_helpers";
import { SubjectJourneyClient } from "@/components/student/SubjectJourneyClient";
import type { QuestionType, SubjectRow } from "@/types/database";

export const dynamic = "force-dynamic";

export default async function StudentSubjectJourneyPage({
  params,
}: {
  params: Promise<{ subjectId: string }>;
}) {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }
  if (!session.student.subjectsConfigured) {
    redirect("/student/onboarding");
  }

  const { subjectId } = await params;
  const supabase = getSupabaseAdmin();

  const [subjectRes, accessibleIds, progressRes] = await Promise.all([
    supabase.from("subjects").select("*").eq("id", subjectId).maybeSingle(),
    getStudentAccessibleSubjectIds(session.principalId, session.student.academicYear),
    supabase
      .from("student_chapter_progress")
      .select("*")
      .eq("student_id", session.principalId),
  ]);

  const subject = subjectRes.data
    ? normalizeSubjectRow(
        subjectRes.data as Omit<SubjectRow, "syllabus_alias_of"> & {
          syllabus_alias_of?: string | null;
        }
      )
    : null;
  if (!subject) {
    notFound();
  }

  const isAllowed =
    isUniversalSkillSubject(subject.id) ||
    accessibleIds.includes(subject.id) ||
    (subject.syllabus_alias_of ? accessibleIds.includes(subject.syllabus_alias_of) : false);

  if (!isAllowed) {
    notFound();
  }

  // Seamlessly resolve syllabus alias (e.g. bseb-12-lang2-eng -> bseb-12-lang1-eng,
  // bseb-10-skill-ict -> skill-ict-lab) so chapters/notes/practice never duplicate
  const contentSubjectId = subject.syllabus_alias_of ?? subject.id;

  const { data: chaptersData } = await supabase
    .from("chapters")
    .select("*")
    .eq("subject_id", contentSubjectId)
    .eq("is_published", true)
    .order("chapter_no", { ascending: true });

  const chapters = chaptersData ?? [];
  const chapterIds = chapters.map((c) => c.id);

  let publishedNoteSet = new Set<string>();
  const questionCountByChapter = new Map<string, number>();
  const playLabCountByChapter = new Map<string, number>();
  const hasSubjectiveByChapter = new Set<string>();

  if (chapterIds.length > 0) {
    const [notesRes, qRes] = await Promise.all([
      supabase
        .from("chapter_notes")
        .select("chapter_id")
        .in("chapter_id", chapterIds)
        .eq("status", "PUBLISHED"),
      supabase
        .from("questions")
        .select("chapter_id, question_type")
        .in("chapter_id", chapterIds)
        .eq("bank_pool", "PRACTICE")
        .eq("is_published", true),
    ]);
    publishedNoteSet = new Set((notesRes.data ?? []).map((n) => n.chapter_id));
    for (const q of qRes.data ?? []) {
      const qType = q.question_type as QuestionType;
      questionCountByChapter.set(
        q.chapter_id,
        (questionCountByChapter.get(q.chapter_id) ?? 0) + 1
      );
      if (PLAY_LAB_QUESTION_TYPES.has(qType)) {
        playLabCountByChapter.set(
          q.chapter_id,
          (playLabCountByChapter.get(q.chapter_id) ?? 0) + 1
        );
      }
      if (qType === "SHORT_2M" || qType === "LONG_5M") {
        hasSubjectiveByChapter.add(q.chapter_id);
      }
    }
  }

  const progressMap = new Map((progressRes.data ?? []).map((p) => [p.chapter_id, p]));

  const journeyChapters = chapters.map((ch) => {
    const prog = progressMap.get(ch.id);
    const quizMasteryPct =
      prog && prog.practice_attempted > 0
        ? Math.round((prog.practice_correct / prog.practice_attempted) * 100)
        : 0;
    const fourStage = computeFourStageProgress({
      notesCompleted: Boolean(prog?.notes_completed),
      notesProgressPct: prog?.notes_progress_pct ?? 0,
      playCompleted: Boolean(prog?.play_completed),
      quizMasteryPct,
      subjectiveCompleted: Boolean(prog?.subjective_completed),
      hasSubjective: hasSubjectiveByChapter.has(ch.id),
    });
    const masteryPct = Math.max(prog?.mastery_pct ?? 0, fourStage.totalPct);

    return {
      ...ch,
      hasRichNotes: publishedNoteSet.has(ch.id),
      practiceCount: questionCountByChapter.get(ch.id) ?? 0,
      playLabCount: playLabCountByChapter.get(ch.id) ?? 0,
      notesCompleted: Boolean(prog?.notes_completed),
      playCompleted: Boolean(prog?.play_completed),
      subjectiveCompleted: Boolean(prog?.subjective_completed),
      fourStage,
      masteryPct,
      medal: computeChapterMedal(masteryPct),
    };
  });

  return (
    <SubjectJourneyClient
      subject={subject}
      chapters={journeyChapters}
    />
  );
}
