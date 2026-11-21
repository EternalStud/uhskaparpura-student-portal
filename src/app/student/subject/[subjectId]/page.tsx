import React from "react";
import { redirect, notFound } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { computeChapterMedal } from "@/app/api/student/_helpers";
import { SubjectJourneyClient } from "@/components/student/SubjectJourneyClient";

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

  const [subjectRes, enrolledRes, chaptersRes, progressRes] = await Promise.all([
    supabase.from("subjects").select("*").eq("id", subjectId).maybeSingle(),
    supabase
      .from("student_subjects")
      .select("subject_id")
      .eq("student_id", session.principalId)
      .eq("academic_year", session.student.academicYear)
      .eq("subject_id", subjectId)
      .maybeSingle(),
    supabase
      .from("chapters")
      .select("*")
      .eq("subject_id", subjectId)
      .eq("is_published", true)
      .order("chapter_no", { ascending: true }),
    supabase
      .from("student_chapter_progress")
      .select("*")
      .eq("student_id", session.principalId),
  ]);

  if (!subjectRes.data || !enrolledRes.data) {
    notFound();
  }

  const chapters = chaptersRes.data ?? [];
  const chapterIds = chapters.map((c) => c.id);

  let publishedNoteSet = new Set<string>();
  const questionCountByChapter = new Map<string, number>();

  if (chapterIds.length > 0) {
    const [notesRes, qRes] = await Promise.all([
      supabase
        .from("chapter_notes")
        .select("chapter_id")
        .in("chapter_id", chapterIds)
        .eq("status", "PUBLISHED"),
      supabase
        .from("questions")
        .select("chapter_id")
        .in("chapter_id", chapterIds)
        .eq("bank_pool", "PRACTICE")
        .eq("is_published", true),
    ]);
    publishedNoteSet = new Set((notesRes.data ?? []).map((n) => n.chapter_id));
    for (const q of qRes.data ?? []) {
      questionCountByChapter.set(
        q.chapter_id,
        (questionCountByChapter.get(q.chapter_id) ?? 0) + 1
      );
    }
  }

  const progressMap = new Map((progressRes.data ?? []).map((p) => [p.chapter_id, p]));

  const journeyChapters = chapters.map((ch) => {
    const prog = progressMap.get(ch.id);
    const masteryPct = prog?.mastery_pct ?? 0;
    return {
      ...ch,
      hasRichNotes: publishedNoteSet.has(ch.id),
      practiceCount: questionCountByChapter.get(ch.id) ?? 0,
      notesCompleted: Boolean(prog?.notes_completed),
      masteryPct,
      medal: computeChapterMedal(masteryPct),
    };
  });

  return (
    <SubjectJourneyClient
      subject={subjectRes.data}
      chapters={journeyChapters}
    />
  );
}
