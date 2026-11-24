import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  isMissingColumnError,
  normalizeSubjectRow,
  SUBJECT_SELECT_FULL,
  SUBJECT_SELECT_LEGACY,
} from "@/lib/supabase/schema-compat";
import { jsonNoStore, requireRole } from "@/lib/auth";
import { UNIVERSAL_SKILL_SUBJECT_IDS } from "@/app/api/student/_helpers";
import type { ChapterRow, SubjectClassNum, SubjectRow } from "@/types/database";

/**
 * GET /api/teacher/lesson-plans
 * STRICTLY Teacher / School Admin / Super Admin ONLY — NEVER accessible to students.
 * Lists BSEB subjects AND Universal ICT / English Foundation Labs with official lesson plans.
 *
 * Resilience & UX guarantees:
 * 1. Schema-graceful fallback if `subjects.syllabus_alias_of` (`004`) is not yet applied in DB.
 * 2. Deduplicates subjects sharing the same canonical `contentId = syllabus_alias_of ?? id`
 *    (preferring the canonical subject row) so teachers assigned multiple aliased variants
 *    (e.g. Lang-1 + Lang-2 English or Class 9-12 ICT/CS) see ONE clean card per curriculum track.
 */
export async function GET(request: Request) {
  const auth = await requireRole(["teacher", "school_admin", "super_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  const url = new URL(request.url);
  const classNumParam = url.searchParams.get("classNum");
  const subjectIdParam = url.searchParams.get("subjectId")?.trim() || null;
  const scope = url.searchParams.get("scope") === "my" ? "my" : "all";

  const supabase = getSupabaseAdmin();

  const buildSubjectsQuery = (selectCols: string) => {
    let q = supabase
      .from("subjects")
      .select(selectCols)
      .order("class_num", { ascending: true })
      .order("sort_order", { ascending: true });

    if (classNumParam && ["0", "9", "10", "11", "12"].includes(classNumParam)) {
      q = q.eq("class_num", Number(classNumParam) as SubjectClassNum);
    }
    if (subjectIdParam) {
      q = q.eq("id", subjectIdParam);
    }
    if (scope === "my" && session.teacher) {
      const assigned = session.teacher.assignedSubjectIds;
      // Always surface Universal ICT & English Foundation Labs alongside assigned BSEB subjects
      const myIds = Array.from(new Set([...UNIVERSAL_SKILL_SUBJECT_IDS, ...assigned]));
      q = q.in("id", myIds);
    }
    return q;
  };

  let subjectRows: SubjectRow[] = [];
  const firstRes = await buildSubjectsQuery(SUBJECT_SELECT_FULL);

  if (firstRes.error) {
    if (isMissingColumnError(firstRes.error)) {
      const fallbackRes = await buildSubjectsQuery(SUBJECT_SELECT_LEGACY);
      if (fallbackRes.error) {
        return jsonNoStore(
          { error: "Unable to load subjects for lesson plans." },
          { status: 500 }
        );
      }
      subjectRows = ((fallbackRes.data ?? []) as unknown as Array<
        Omit<SubjectRow, "syllabus_alias_of">
      >).map(normalizeSubjectRow);
    } else {
      return jsonNoStore(
        { error: "Unable to load subjects for lesson plans." },
        { status: 500 }
      );
    }
  } else {
    subjectRows = ((firstRes.data ?? []) as unknown as SubjectRow[]).map(normalizeSubjectRow);
  }

  if (subjectRows.length === 0) {
    return jsonNoStore({
      ok: true,
      scope,
      assignedSubjectIds: session.teacher?.assignedSubjectIds ?? [],
      subjects: [],
      totalPlansAvailable: 0,
    });
  }

  const assignedSet = new Set(session.teacher?.assignedSubjectIds ?? []);

  // Deduplicate aliased subjects sharing the same canonical contentId (preferring the canonical row)
  // unless an explicit single subjectId was requested.
  const dedupedEntries: Array<{
    row: SubjectRow;
    contentId: string;
    isAssigned: boolean;
    isUniversal: boolean;
  }> = [];

  if (subjectIdParam) {
    for (const subj of subjectRows) {
      const contentId = subj.syllabus_alias_of ?? subj.id;
      const isUniversal = (UNIVERSAL_SKILL_SUBJECT_IDS as readonly string[]).includes(subj.id);
      dedupedEntries.push({
        row: subj,
        contentId,
        isAssigned: assignedSet.has(subj.id) || isUniversal,
        isUniversal,
      });
    }
  } else {
    const byContentId = new Map<
      string,
      {
        row: SubjectRow;
        contentId: string;
        isAssigned: boolean;
        isUniversal: boolean;
      }
    >();

    for (const subj of subjectRows) {
      const contentId = subj.syllabus_alias_of ?? subj.id;
      const isUniversal = (UNIVERSAL_SKILL_SUBJECT_IDS as readonly string[]).includes(subj.id);
      const rowAssigned = assignedSet.has(subj.id) || isUniversal;

      const existing = byContentId.get(contentId);
      if (!existing) {
        const entry = {
          row: subj,
          contentId,
          isAssigned: rowAssigned,
          isUniversal,
        };
        byContentId.set(contentId, entry);
        dedupedEntries.push(entry);
      } else {
        if (rowAssigned) existing.isAssigned = true;
        if (isUniversal) existing.isUniversal = true;
        // Prefer the canonical subject row (e.g. skill-ict-lab or bseb-12-lang1-eng)
        if (subj.id === contentId && existing.row.id !== contentId) {
          existing.row = subj;
        }
      }
    }
  }

  // Include canonical alias targets when loading chapters so aliased English/ICT/CS subjects
  // seamlessly expose their full chapter list & teacher lesson plans
  const contentSubjectIds = Array.from(new Set(dedupedEntries.map((e) => e.contentId)));

  const [{ data: chapters, error: chErr }, { data: planMeta, error: lpErr }] =
    await Promise.all([
      supabase
        .from("chapters")
        .select(
          "id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published"
        )
        .in("subject_id", contentSubjectIds)
        .eq("is_published", true)
        .order("chapter_no", { ascending: true }),
      supabase
        .from("lesson_plans")
        .select("id, chapter_id, duration_periods, objectives_hi, objectives_en, updated_at"),
    ]);

  if (chErr || lpErr) {
    return jsonNoStore({ error: "Unable to load chapter lesson plans." }, { status: 500 });
  }

  const planByChapter = new Map(
    (planMeta ?? []).map((p) => [
      p.chapter_id,
      {
        id: p.id,
        durationPeriods: p.duration_periods,
        objectivesHi: p.objectives_hi,
        objectivesEn: p.objectives_en,
        updatedAt: p.updated_at,
      },
    ])
  );

  const chaptersBySubject = new Map<string, ChapterRow[]>();
  for (const ch of chapters ?? []) {
    const list = chaptersBySubject.get(ch.subject_id) ?? [];
    list.push(ch);
    chaptersBySubject.set(ch.subject_id, list);
  }

  const uniqueReadyChapterIds = new Set<string>();

  const enrichedSubjects = dedupedEntries.map(({ row: subj, contentId, isAssigned, isUniversal }) => {
    const subjChapters = (chaptersBySubject.get(contentId) ?? []).map((ch) => {
      const lp = planByChapter.get(ch.id) ?? null;
      if (lp) uniqueReadyChapterIds.add(ch.id);
      return {
        ...ch,
        hasLessonPlan: Boolean(lp),
        lessonPlanSummary: lp,
      };
    });

    return {
      ...subj,
      isAssigned,
      isUniversal,
      lessonPlansCount: subjChapters.filter((c) => c.hasLessonPlan).length,
      chapters: subjChapters,
    };
  });

  return jsonNoStore({
    ok: true,
    scope,
    assignedSubjectIds: session.teacher?.assignedSubjectIds ?? [],
    subjects: enrichedSubjects,
    totalPlansAvailable: uniqueReadyChapterIds.size,
  });
}
