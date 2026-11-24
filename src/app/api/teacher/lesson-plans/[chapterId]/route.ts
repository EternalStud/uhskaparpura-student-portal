import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole } from "@/lib/auth";

/**
 * GET /api/teacher/lesson-plans/[chapterId]
 * STRICTLY Teacher / School Admin / Super Admin ONLY — NEVER accessible to students.
 */
export async function GET(
  request: Request,
  context: { params: Promise<{ chapterId: string }> }
) {
  const auth = await requireRole(["teacher", "school_admin", "super_admin"], request);
  if (!auth.ok) return auth.response;

  const { chapterId } = await context.params;
  const cleanId = (chapterId ?? "").trim();
  if (!cleanId || cleanId.length > 100 || !/^[a-zA-Z0-9_-]+$/.test(cleanId)) {
    return jsonNoStore({ error: "Invalid chapter identifier." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();

  const { data: chapter, error: chErr } = await supabase
    .from("chapters")
    .select(
      "id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published"
    )
    .eq("id", cleanId)
    .maybeSingle();

  if (chErr) {
    return jsonNoStore({ error: "Could not load chapter details." }, { status: 500 });
  }
  if (!chapter) {
    return jsonNoStore({ error: "Chapter not found." }, { status: 404 });
  }

  const [{ data: subject }, { data: lessonPlan, error: lpErr }, { data: siblingChapters }] =
    await Promise.all([
      supabase
        .from("subjects")
        .select("id, bseb_code, class_num, stream, category, name_en, name_hi, icon_name, accent_color, sort_order, syllabus_alias_of")
        .eq("id", chapter.subject_id)
        .maybeSingle(),
      supabase
        .from("lesson_plans")
        .select(
          "id, chapter_id, duration_periods, objectives_hi, objectives_en, teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json, updated_at"
        )
        .eq("chapter_id", chapter.id)
        .maybeSingle(),
      supabase
        .from("chapters")
        .select("id, chapter_no, title_hi, title_en")
        .eq("subject_id", chapter.subject_id)
        .eq("is_published", true)
        .order("chapter_no", { ascending: true }),
    ]);

  if (lpErr) {
    return jsonNoStore({ error: "Could not load lesson plan." }, { status: 500 });
  }

  return jsonNoStore({
    ok: true,
    chapter,
    subject: subject ?? null,
    lessonPlan: lessonPlan ?? null,
    siblingChapters: siblingChapters ?? [],
  });
}
