import { requireRole, jsonNoStore } from "@/lib/auth/session";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { getTodayIst } from "@/lib/time/ist";
import {
  checkActiveLivePinExamLock,
  computeFourStageProgress,
  getStudentAccessibleSubjectIds,
} from "@/app/api/student/_helpers";
import type { DifficultyTier, QuestionRow } from "@/types/database";

const VALID_TIERS = new Set<DifficultyTier>(["FOUNDATION", "BOARD", "TOPPER"]);

export async function GET(
  request: Request,
  context: { params: Promise<{ chapterId: string }> }
) {
  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;

  const { session } = auth;
  const studentInfo = session.student!;
  const { chapterId } = await context.params;
  const url = new URL(request.url);
  const mode = (url.searchParams.get("mode") ?? "all").toLowerCase();
  const tierParam = (url.searchParams.get("tier") ?? "").toUpperCase();
  const pyqOnly = url.searchParams.get("pyqOnly") === "true";

  // Anti-cheat lock during active LIVE_PIN classroom exam
  const lock = await checkActiveLivePinExamLock(session.principalId);
  if (lock.locked) {
    return jsonNoStore(
      {
        locked: true,
        examId: lock.examId,
        examTitle: lock.examTitle,
        error: "लाइव परीक्षा चल रही है — परीक्षा पूरी होने तक अभ्यास अस्थायी रूप से लॉक है।",
        errorEn: "A live classroom exam is active — Practice is temporarily locked until you submit.",
      },
      { status: 423 }
    );
  }

  const supabase = getSupabaseAdmin();
  const accessibleIds = await getStudentAccessibleSubjectIds(
    session.principalId,
    studentInfo.academicYear
  );
  const todayIst = getTodayIst();

  // Special cross-chapter Revision Queue feed (when chapterId === 'revision-all')
  if (mode === "revision" && chapterId === "revision-all") {
    const { data: revRows } = await supabase
      .from("student_revision_queue")
      .select("question_id, chapter_id, wrong_count, next_review_ist, resolved")
      .eq("student_id", session.principalId)
      .eq("resolved", false)
      .order("next_review_ist", { ascending: true })
      .limit(50);

    const revList = revRows ?? [];
    const qIds = revList.map((r) => r.question_id);
    let questions: QuestionRow[] = [];

    if (qIds.length > 0) {
      const { data: qData } = await supabase
        .from("questions")
        .select("*")
        .in("id", qIds)
        .eq("bank_pool", "PRACTICE")
        .eq("is_published", true);
      questions = (qData ?? []) as QuestionRow[];
    }

    const revMeta = new Map(revList.map((r) => [r.question_id, r]));
    return jsonNoStore({
      mode: "revision",
      todayIst,
      questions: questions.map((q) => ({
        ...q,
        revision: revMeta.get(q.id) ?? null,
      })),
    });
  }

  // Standard chapter-scoped Practice Hub
  const { data: chapter, error: chErr } = await supabase
    .from("chapters")
    .select("*")
    .eq("id", chapterId)
    .eq("is_published", true)
    .maybeSingle();

  if (chErr || !chapter) {
    return jsonNoStore(
      { error: "यह अध्याय उपलब्ध नहीं है।", errorEn: "Chapter not found." },
      { status: 404 }
    );
  }

  if (accessibleIds.length > 0 && !accessibleIds.includes(chapter.subject_id)) {
    return jsonNoStore(
      {
        error: "यह अध्याय आपके चुने गए विषयों में शामिल नहीं है।",
        errorEn: "This chapter does not belong to your selected subjects.",
      },
      { status: 403 }
    );
  }

  // STRICTLY bank_pool = 'PRACTICE' — NEVER exposes EXAM_ONLY questions!
  let query = supabase
    .from("questions")
    .select("*")
    .eq("chapter_id", chapter.id)
    .eq("bank_pool", "PRACTICE")
    .eq("is_published", true)
    .order("created_at", { ascending: true });

  if (tierParam && VALID_TIERS.has(tierParam as DifficultyTier)) {
    query = query.eq("difficulty_tier", tierParam as DifficultyTier);
  }
  if (pyqOnly) {
    query = query.not("exam_year_tag", "is", null);
  }

  const [subjectRes, questionsRes, masteryRes, revisionRes, progressRes] = await Promise.all([
    supabase.from("subjects").select("*").eq("id", chapter.subject_id).single(),
    query,
    supabase
      .from("student_question_mastery")
      .select("question_id, attempts_count, correct_count, streak_correct, is_bookmarked")
      .eq("student_id", session.principalId),
    supabase
      .from("student_revision_queue")
      .select("question_id, wrong_count, next_review_ist, resolved")
      .eq("student_id", session.principalId)
      .eq("chapter_id", chapter.id)
      .eq("resolved", false),
    supabase
      .from("student_chapter_progress")
      .select("*")
      .eq("student_id", session.principalId)
      .eq("chapter_id", chapter.id)
      .maybeSingle(),
  ]);

  const rawQuestions = (questionsRes.data ?? []) as QuestionRow[];
  const masteryMap = new Map((masteryRes.data ?? []).map((m) => [m.question_id, m]));
  const revisionMap = new Map((revisionRes.data ?? []).map((r) => [r.question_id, r]));

  const enriched = rawQuestions.map((q) => ({
    ...q,
    mastery: masteryMap.get(q.id) ?? null,
    inRevisionQueue: revisionMap.has(q.id),
    revisionMeta: revisionMap.get(q.id) ?? null,
  }));

  // Mode: BSEB 50% Objective OMR Board Simulator (pulls practice MCQs from this chapter,
  // and pads with same-subject practice MCQs if chapter has < 6 MCQs for an authentic 50% choice sheet)
  if (mode === "omr") {
    const omrPool = enriched.filter((q) => q.question_type === "MCQ");
    if (omrPool.length < 6) {
      const { data: subjectMcqs } = await supabase
        .from("questions")
        .select("*")
        .eq("subject_id", chapter.subject_id)
        .eq("bank_pool", "PRACTICE")
        .eq("question_type", "MCQ")
        .eq("is_published", true)
        .limit(20);
      const seen = new Set(omrPool.map((q) => q.id));
      for (const extra of (subjectMcqs ?? []) as QuestionRow[]) {
        if (!seen.has(extra.id)) {
          seen.add(extra.id);
          omrPool.push({
            ...extra,
            mastery: masteryMap.get(extra.id) ?? null,
            inRevisionQueue: revisionMap.has(extra.id),
            revisionMeta: revisionMap.get(extra.id) ?? null,
          });
        }
      }
    }

    // Authentic BSEB rule: student gets 2N objective options and must attempt strictly at most N (50%)
    const evenPool =
      omrPool.length >= 2 && omrPool.length % 2 === 1 ? omrPool.slice(0, -1) : omrPool;
    const attemptLimit = Math.max(1, Math.floor(evenPool.length / 2));

    return jsonNoStore({
      mode: "omr",
      chapter,
      subject: subjectRes.data ?? null,
      omr: {
        totalQuestions: evenPool.length,
        attemptLimit,
        questions: evenPool,
      },
    });
  }

  // Mode: Chapter Revision Queue only
  if (mode === "revision") {
    const revQuestions = enriched.filter((q) => q.inRevisionQueue);
    return jsonNoStore({
      mode: "revision",
      todayIst,
      chapter,
      subject: subjectRes.data ?? null,
      questions: revQuestions,
    });
  }

  // Default: Complete Interactive Labs + 6-Mode Bucketed Practice Hub payload
  const sentenceBuilders = enriched.filter((q) => q.question_type === "SENTENCE_BUILDER");
  const shortcutStudios = enriched.filter((q) => q.question_type === "SHORTCUT_STUDIO");
  const excelSandboxes = enriched.filter((q) => q.question_type === "EXCEL_SANDBOX");
  const scenarioLabs = enriched.filter((q) => q.question_type === "SCENARIO_LAB");
  const flashcards = enriched.filter((q) => q.question_type === "FLASHCARD");
  const matchPairs = enriched.filter((q) => q.question_type === "MATCH_PAIRS");
  const diagramLabels = enriched.filter((q) => q.question_type === "DIAGRAM_LABEL");
  const mcqs = enriched.filter((q) => q.question_type === "MCQ");
  const shortAnswers = enriched.filter((q) => q.question_type === "SHORT_2M");
  const longAnswers = enriched.filter((q) => q.question_type === "LONG_5M");
  const pyqQuestions = enriched.filter((q) => Boolean(q.exam_year_tag));
  const revisionQuestions = enriched.filter((q) => q.inRevisionQueue);

  const prog = progressRes.data;
  const quizMasteryPct =
    prog && prog.practice_attempted > 0
      ? Math.round((prog.practice_correct / prog.practice_attempted) * 100)
      : 0;
  const hasSubjective = shortAnswers.length + longAnswers.length > 0;
  const fourStage = computeFourStageProgress({
    notesCompleted: Boolean(prog?.notes_completed),
    notesProgressPct: prog?.notes_progress_pct ?? 0,
    playCompleted: Boolean(prog?.play_completed),
    quizMasteryPct,
    subjectiveCompleted: Boolean(prog?.subjective_completed),
    hasSubjective,
  });

  const visualPlayTotal =
    sentenceBuilders.length +
    shortcutStudios.length +
    excelSandboxes.length +
    scenarioLabs.length +
    flashcards.length +
    matchPairs.length +
    diagramLabels.length;

  return jsonNoStore({
    mode: "all",
    todayIst,
    chapter,
    subject: subjectRes.data ?? null,
    progress: prog
      ? {
          ...prog,
          play_completed: Boolean(prog.play_completed),
          subjective_completed: Boolean(prog.subjective_completed),
        }
      : null,
    fourStage,
    buckets: {
      sentenceBuilders,
      shortcutStudios,
      excelSandboxes,
      scenarioLabs,
      flashcards,
      matchPairs,
      diagramLabels,
      mcqs,
      shortAnswers,
      longAnswers,
      pyqQuestions,
      revisionQuestions,
    },
    counts: {
      total: enriched.length,
      visualPlay: visualPlayTotal,
      sentenceBuilders: sentenceBuilders.length,
      shortcutStudios: shortcutStudios.length,
      excelSandboxes: excelSandboxes.length,
      scenarioLabs: scenarioLabs.length,
      flashcards: flashcards.length,
      matchPairs: matchPairs.length,
      diagramLabels: diagramLabels.length,
      mcqs: mcqs.length,
      subjective: shortAnswers.length + longAnswers.length,
      pyq: pyqQuestions.length,
      revision: revisionQuestions.length,
    },
  });
}
