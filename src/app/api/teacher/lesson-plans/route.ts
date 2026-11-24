import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole } from "@/lib/auth";
import { UNIVERSAL_SKILL_SUBJECT_IDS } from "@/app/api/student/_helpers";
import type { ChapterRow, SubjectClassNum, SubjectRow } from "@/types/database";

/**
 * GET /api/teacher/lesson-plans
 * STRICTLY Teacher / School Admin / Super Admin ONLY — NEVER accessible to students.
 * Lists BSEB subjects AND Universal ICT / English Foundation Labs with official lesson plans.
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
      "id, bseb_code, class_num, stream, category, name_en, name_hi, icon_name, accent_color, sort_order, syllabus_alias_of"
    )
    .order("class_num", { ascending: true })
    .order("sort_order", { ascending: true });

  if (classNumParam && ["0", "9", "10", "11", "12"].includes(classNumParam)) {
    subjectsQuery = subjectsQuery.eq("class_num", Number(classNumParam) as SubjectClassNum);
  }
  if (subjectIdParam) {
    subjectsQuery = subjectsQuery.eq("id", subjectIdParam);
  }
  if (scope === "my" && session.teacher) {
    const assigned = session.teacher.assignedSubjectIds;
    // Always surface Universal ICT & English Foundation Labs for every teacher alongside their assigned BSEB subjects
    const myIds = Array.from(new Set([...UNIVERSAL_SKILL_SUBJECT_IDS, ...assigned]));
    subjectsQuery = subjectsQuery.in("id", myIds);
  }

  const { data: subjects, error: subjErr } = await subjectsQuery;
  if (subjErr) {
    return jsonNoStore({ error: "Unable to load subjects for lesson plans." }, { status: 500 });
  }

  const subjectRows: SubjectRow[] = (subjects ?? []) as SubjectRow[];
  if (subjectRows.length === 0) {
    return jsonNoStore({
      ok: true,
      scope,
      assignedSubjectIds: session.teacher?.assignedSubjectIds ?? [],
      subjects: [],
      totalPlansAvailable: 0,
    });
  }

  // Include canonical alias targets when loading chapters so aliased English/ICT subjects
  // seamlessly expose their full chapter list & teacher lesson plans
  const contentSubjectIds = Array.from(
    new Set(subjectRows.map((s) => s.syllabus_alias_of ?? s.id))
  );

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
  const assignedSet = new Set(session.teacher?.assignedSubjectIds ?? []);

  const enrichedSubjects = subjectRows.map((subj) => {
    const contentId = subj.syllabus_alias_of ?? subj.id;
    const subjChapters = (chaptersBySubject.get(contentId) ?? []).map((ch) => {
      const lp = planByChapter.get(ch.id) ?? null;
      if (lp) uniqueReadyChapterIds.add(ch.id);
      return {
        ...ch,
        hasLessonPlan: Boolean(lp),
        lessonPlanSummary: lp,
      };
    });

    const isUniversal = (UNIVERSAL_SKILL_SUBJECT_IDS as readonly string[]).includes(subj.id);

    return {
      ...subj,
      isAssigned: assignedSet.has(subj.id) || isUniversal,
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
