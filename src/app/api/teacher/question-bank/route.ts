import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole } from "@/lib/auth";
import { resolveCanonicalSubjectId } from "@/app/api/student/_helpers";

/**
 * GET /api/teacher/question-bank
 * Teacher-ONLY endpoint exposing BOTH `PRACTICE` and `EXAM_ONLY` MCQ question pools
 * for building Live Classroom & Scheduled Exams (including Universal ICT & English
 * Foundation Labs and resolved `syllabus_alias_of` subjects!). Strictly blocked for students.
 */
export async function GET(request: Request) {
  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;

  const url = new URL(request.url);
  const subjectId = url.searchParams.get("subjectId")?.trim();
  const chapterId = url.searchParams.get("chapterId")?.trim() || null;
  const pool = url.searchParams.get("pool") || "ALL";
  const difficulty = url.searchParams.get("difficulty") || "ALL";
  const search = (url.searchParams.get("q") || "").trim().toLowerCase();

  if (!subjectId) {
    return jsonNoStore({ error: "subjectId query parameter is required." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();
  const canonicalSubjectId = await resolveCanonicalSubjectId(subjectId);

  let query = supabase
    .from("questions")
    .select(
      "id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag, q_hi, q_en, options_json, correct_option, explanation_hi, explanation_en"
    )
    .eq("subject_id", canonicalSubjectId)
    .eq("question_type", "MCQ")
    .eq("is_published", true)
    .order("created_at", { ascending: false })
    .limit(200);

  if (chapterId) {
    query = query.eq("chapter_id", chapterId);
  }
  if (pool === "PRACTICE" || pool === "EXAM_ONLY") {
    query = query.eq("bank_pool", pool);
  }
  if (
    difficulty === "FOUNDATION" ||
    difficulty === "BOARD" ||
    difficulty === "TOPPER"
  ) {
    query = query.eq("difficulty_tier", difficulty);
  }

  const [{ data: questions, error }, { data: chapters }] = await Promise.all([
    query,
    supabase
      .from("chapters")
      .select("id, chapter_no, title_hi, title_en")
      .eq("subject_id", canonicalSubjectId)
      .eq("is_published", true)
      .order("chapter_no", { ascending: true }),
  ]);

  if (error) {
    return jsonNoStore({ error: "Unable to load question bank." }, { status: 500 });
  }

  const chapterMap = new Map((chapters ?? []).map((c) => [c.id, c]));

  let filtered = questions ?? [];
  if (search) {
    filtered = filtered.filter(
      (q) =>
        q.q_hi.toLowerCase().includes(search) ||
        q.q_en.toLowerCase().includes(search) ||
        (q.topic_tag ?? "").toLowerCase().includes(search) ||
        (q.exam_year_tag ?? "").toLowerCase().includes(search)
    );
  }

  return jsonNoStore({
    ok: true,
    canonicalSubjectId,
    chapters: chapters ?? [],
    questions: filtered.map((q) => {
      const ch = chapterMap.get(q.chapter_id);
      return {
        id: q.id,
        subjectId: q.subject_id,
        chapterId: q.chapter_id,
        chapterNo: ch?.chapter_no ?? null,
        chapterTitleHi: ch?.title_hi ?? null,
        chapterTitleEn: ch?.title_en ?? null,
        topicTag: q.topic_tag,
        bankPool: q.bank_pool,
        difficultyTier: q.difficulty_tier,
        examYearTag: q.exam_year_tag,
        qHi: q.q_hi,
        qEn: q.q_en,
        options: q.options_json ?? [],
        correctOption: q.correct_option,
        explanationHi: q.explanation_hi,
        explanationEn: q.explanation_en,
      };
    }),
  });
}
