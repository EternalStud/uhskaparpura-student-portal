import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole } from "@/lib/auth";
import type { ChapterRow, ClassNum, SubjectRow } from "@/types/database";

/**
 * GET /api/teacher/lesson-plans
 * STRICTLY Teacher / School Admin / Super Admin ONLY — NEVER accessible to students.
 * Lists BSEB subjects and chapters with official pedagogical lesson plan status.
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

  let subjectsQuery = supabase
    .from("subjects")
    .select(
      "id, bseb_code, class_num, stream, category, name_en, name_hi, icon_name, accent_color, sort_order"
    )
    .order("class_num", { ascending: true })
    .order("sort_order", { ascending: true });

  if (classNumParam && ["9", "10", "11", "12"].includes(classNumParam)) {
    subjectsQuery = subjectsQuery.eq("class_num", Number(classNumParam) as ClassNum);
  }
  if (subjectIdParam) {
    subjectsQuery = subjectsQuery.eq("id", subjectIdParam);
  }
  if (scope === "my" && session.teacher) {
    const assigned = session.teacher.assignedSubjectIds;
    if (assigned.length === 0) {
      return jsonNoStore({
        ok: true,
        scope,
        assignedSubjectIds: [],
        subjects: [],
        totalPlansAvailable: 0,
      });
    }
    subjectsQuery = subjectsQuery.in("id", assigned);
  }

  const { data: subjects, error: subjErr } = await subjectsQuery;
  if (subjErr) {
    return jsonNoStore({ error: "Unable to load subjects for lesson plans." }, { status: 500 });
  }

  const subjectRows: SubjectRow[] = subjects ?? [];
  if (subjectRows.length === 0) {
    return jsonNoStore({
      ok: true,
      scope,
      assignedSubjectIds: session.teacher?.assignedSubjectIds ?? [],
      subjects: [],
      totalPlansAvailable: 0,
    });
  }

  const subjectIds = subjectRows.map((s) => s.id);

  const [{ data: chapters, error: chErr }, { data: planMeta, error: lpErr }] =
    await Promise.all([
      supabase
        .from("chapters")
        .select(
          "id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published"
        )
        .in("subject_id", subjectIds)
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

  let totalPlansAvailable = 0;

  const enrichedSubjects = subjectRows.map((subj) => {
    const subjChapters = (chaptersBySubject.get(subj.id) ?? []).map((ch) => {
      const lp = planByChapter.get(ch.id) ?? null;
      if (lp) totalPlansAvailable += 1;
      return {
        ...ch,
        hasLessonPlan: Boolean(lp),
        lessonPlanSummary: lp,
      };
    });

    return {
      ...subj,
      isAssigned: session.teacher?.assignedSubjectIds.includes(subj.id) ?? false,
      lessonPlansCount: subjChapters.filter((c) => c.hasLessonPlan).length,
      chapters: subjChapters,
    };
  });

  return jsonNoStore({
    ok: true,
    scope,
    assignedSubjectIds: session.teacher?.assignedSubjectIds ?? [],
    subjects: enrichedSubjects,
    totalPlansAvailable,
  });
}
