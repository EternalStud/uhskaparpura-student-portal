import { z } from "zod";
import { requireRole, jsonNoStore } from "@/lib/auth/session";
import { validateCsrf } from "@/lib/auth/csrf";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { getTodayIst } from "@/lib/time/ist";
import {
  awardStudentStudyProgress,
  checkActiveLivePinExamLock,
  computeChapterMedal,
  getStudentEnrolledSubjectIds,
} from "@/app/api/student/_helpers";
import type { PracticeMode, QuestionRow } from "@/types/database";

const submitPracticeSchema = z.object({
  attemptId: z.string().uuid(),
  chapterId: z.string().min(1).max(100),
  mode: z.enum([
    "FLASHCARD",
    "MATCH_PAIRS",
    "DIAGRAM_LABEL",
    "MCQ_PRACTICE",
    "SUBJECTIVE_SELF_CHECK",
    "REVISION_DRILL",
    "DAILY_CHALLENGE",
  ]),
  timeSpentSeconds: z.number().int().min(0).max(10800).optional().default(0),
  responses: z
    .array(
      z.object({
        questionId: z.string().uuid(),
        selectedOption: z.enum(["A", "B", "C", "D"]).optional(),
        isCorrect: z.boolean().optional(),
      })
    )
    .max(100)
    .optional()
    .default([]),
  selfChecks: z
    .array(
      z.object({
        questionId: z.string().uuid(),
        status: z.enum(["CONFIDENT", "NEEDS_REVIEW"]),
      })
    )
    .max(50)
    .optional()
    .default([]),
});

function addDaysIst(isoDate: string, days: number): string {
  const [y, m, d] = isoDate.split("-").map(Number);
  const dt = new Date(Date.UTC(y, m - 1, d));
  dt.setUTCDate(dt.getUTCDate() + days);
  const yy = dt.getUTCFullYear();
  const mm = String(dt.getUTCMonth() + 1).padStart(2, "0");
  const dd = String(dt.getUTCDate()).padStart(2, "0");
  return `${yy}-${mm}-${dd}`;
}

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;

  const { session } = auth;
  const studentInfo = session.student!;

  // Anti-cheat lock during active LIVE_PIN exam
  const lock = await checkActiveLivePinExamLock(session.principalId);
  if (lock.locked) {
    return jsonNoStore(
      {
        locked: true,
        examId: lock.examId,
        error: "लाइव परीक्षा चल रही है — अभ्यास अभी लॉक है।",
        errorEn: "Live exam in progress — practice submission locked.",
      },
      { status: 423 }
    );
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "अमान्य अनुरोध।", errorEn: "Invalid JSON body." }, { status: 400 });
  }

  const parsed = submitPracticeSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: "अभ्यास डेटा अमान्य है।", errorEn: "Invalid practice submission payload." },
      { status: 400 }
    );
  }

  const { attemptId, chapterId, mode, responses, selfChecks, timeSpentSeconds } = parsed.data;
  if (responses.length === 0 && selfChecks.length === 0) {
    return jsonNoStore(
      { error: "कृपया कम से कम एक प्रश्न हल करें।", errorEn: "Please answer at least one question." },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();

  // 1. Idempotency check (prevents double-submit XP farming on flaky mobile networks)
  const { data: existingSession } = await supabase
    .from("practice_sessions")
    .select("*")
    .eq("attempt_id", attemptId)
    .maybeSingle();

  if (existingSession) {
    if (existingSession.student_id !== session.principalId) {
      return jsonNoStore({ error: "अमान्य प्रयास आईडी।", errorEn: "Invalid attempt ID." }, { status: 409 });
    }
    return jsonNoStore({
      ok: true,
      duplicate: true,
      attemptId,
      totalQuestions: existingSession.total_questions,
      correctCount: existingSession.correct_count,
      pointsAwarded: existingSession.points_awarded,
      results: [],
    });
  }

  // 2. Verify chapter & enrollment
  const [chapterRes, enrolledIds] = await Promise.all([
    supabase
      .from("chapters")
      .select("id, subject_id")
      .eq("id", chapterId)
      .eq("is_published", true)
      .maybeSingle(),
    getStudentEnrolledSubjectIds(session.principalId, studentInfo.academicYear),
  ]);

  if (!chapterRes.data) {
    return jsonNoStore({ error: "अध्याय नहीं मिला।", errorEn: "Chapter not found." }, { status: 404 });
  }
  const chapter = chapterRes.data;
  if (enrolledIds.length > 0 && !enrolledIds.includes(chapter.subject_id)) {
    return jsonNoStore({ error: "अनुमति नहीं है।", errorEn: "Not enrolled in this subject." }, { status: 403 });
  }

  // 3. Load ONLY published PRACTICE questions referenced in submission
  const allQuestionIds = Array.from(
    new Set([...responses.map((r) => r.questionId), ...selfChecks.map((s) => s.questionId)])
  );

  const { data: questionRows } = await supabase
    .from("questions")
    .select("*")
    .in("id", allQuestionIds)
    .eq("bank_pool", "PRACTICE")
    .eq("is_published", true);

  const questionById = new Map<string, QuestionRow>(
    ((questionRows ?? []) as QuestionRow[]).map((q) => [q.id, q])
  );

  // Load existing mastery & revision rows for these questions
  const [existingMasteryRes, existingRevisionRes, existingChapterProgRes] = await Promise.all([
    supabase
      .from("student_question_mastery")
      .select("*")
      .eq("student_id", session.principalId)
      .in("question_id", allQuestionIds),
    supabase
      .from("student_revision_queue")
      .select("*")
      .eq("student_id", session.principalId)
      .in("question_id", allQuestionIds),
    supabase
      .from("student_chapter_progress")
      .select("*")
      .eq("student_id", session.principalId)
      .eq("chapter_id", chapter.id)
      .maybeSingle(),
  ]);

  const masteryMap = new Map((existingMasteryRes.data ?? []).map((m) => [m.question_id, m]));
  const revisionMap = new Map((existingRevisionRes.data ?? []).map((r) => [r.question_id, r]));

  const todayIst = getTodayIst();
  const nowIso = new Date().toISOString();

  let totalEvaluated = 0;
  let correctCount = 0;
  let flashcardsMasteredDelta = 0;
  const gradedResults: Array<{
    questionId: string;
    questionType: string;
    isCorrect: boolean;
    correctOption: string | null;
    explanationHi: string | null;
    explanationEn: string | null;
    resolvedFromRevision: boolean;
  }> = [];

  const masteryUpserts: Array<{
    student_id: string;
    question_id: string;
    attempts_count: number;
    correct_count: number;
    streak_correct: number;
    is_bookmarked: boolean;
    last_answered_at: string;
  }> = [];

  const revisionUpserts: Array<{
    student_id: string;
    question_id: string;
    chapter_id: string;
    wrong_count: number;
    ease_factor: number;
    interval_days: number;
    next_review_ist: string;
    resolved: boolean;
  }> = [];

  // 4. Server-side grading for objective & interactive responses
  for (const resp of responses) {
    const q = questionById.get(resp.questionId);
    if (!q) continue;

    let isCorrect = false;
    if (q.question_type === "MCQ") {
      isCorrect = Boolean(resp.selectedOption && q.correct_option === resp.selectedOption);
    } else if (
      q.question_type === "FLASHCARD" ||
      q.question_type === "MATCH_PAIRS" ||
      q.question_type === "DIAGRAM_LABEL"
    ) {
      isCorrect = Boolean(resp.isCorrect);
      if (q.question_type === "FLASHCARD" && isCorrect) {
        flashcardsMasteredDelta += 1;
      }
    } else {
      continue;
    }

    totalEvaluated += 1;
    if (isCorrect) correctCount += 1;

    const prevM = masteryMap.get(q.id);
    const nextStreak = isCorrect ? (prevM?.streak_correct ?? 0) + 1 : 0;

    masteryUpserts.push({
      student_id: session.principalId,
      question_id: q.id,
      attempts_count: (prevM?.attempts_count ?? 0) + 1,
      correct_count: (prevM?.correct_count ?? 0) + (isCorrect ? 1 : 0),
      streak_correct: nextStreak,
      is_bookmarked: prevM?.is_bookmarked ?? false,
      last_answered_at: nowIso,
    });

    const prevR = revisionMap.get(q.id);
    let resolvedFromRevision = false;

    if (!isCorrect) {
      // Queue or reset in spaced-repetition Mistake Vault
      revisionUpserts.push({
        student_id: session.principalId,
        question_id: q.id,
        chapter_id: q.chapter_id,
        wrong_count: (prevR?.wrong_count ?? 0) + 1,
        ease_factor: Math.max(1.3, Number(((prevR?.ease_factor ?? 2.5) - 0.2).toFixed(2))),
        interval_days: 1,
        next_review_ist: addDaysIst(todayIst, 1),
        resolved: false,
      });
    } else if (prevR && !prevR.resolved) {
      // 2 consecutive correct answers resolves item out of Revision Queue!
      const shouldResolve = nextStreak >= 2;
      resolvedFromRevision = shouldResolve;
      const nextInterval = shouldResolve ? Math.max(4, prevR.interval_days * 2) : 2;
      revisionUpserts.push({
        student_id: session.principalId,
        question_id: q.id,
        chapter_id: q.chapter_id,
        wrong_count: prevR.wrong_count,
        ease_factor: Math.min(3.0, Number(((prevR.ease_factor ?? 2.5) + 0.1).toFixed(2))),
        interval_days: nextInterval,
        next_review_ist: addDaysIst(todayIst, nextInterval),
        resolved: shouldResolve,
      });
    }

    gradedResults.push({
      questionId: q.id,
      questionType: q.question_type,
      isCorrect,
      correctOption: q.correct_option,
      explanationHi: q.explanation_hi,
      explanationEn: q.explanation_en,
      resolvedFromRevision,
    });
  }

  // 5. Subjective 2M / 5M Self-Check Coach ("Needs Review" vs "Confident")
  for (const check of selfChecks) {
    const q = questionById.get(check.questionId);
    if (!q || (q.question_type !== "SHORT_2M" && q.question_type !== "LONG_5M")) continue;

    const confident = check.status === "CONFIDENT";
    totalEvaluated += 1;
    if (confident) correctCount += 1;

    const prevM = masteryMap.get(q.id);
    masteryUpserts.push({
      student_id: session.principalId,
      question_id: q.id,
      attempts_count: (prevM?.attempts_count ?? 0) + 1,
      correct_count: (prevM?.correct_count ?? 0) + (confident ? 1 : 0),
      streak_correct: confident ? (prevM?.streak_correct ?? 0) + 1 : 0,
      is_bookmarked: prevM?.is_bookmarked ?? false,
      last_answered_at: nowIso,
    });

    const prevR = revisionMap.get(q.id);
    if (!confident) {
      revisionUpserts.push({
        student_id: session.principalId,
        question_id: q.id,
        chapter_id: q.chapter_id,
        wrong_count: (prevR?.wrong_count ?? 0) + 1,
        ease_factor: 2.3,
        interval_days: 1,
        next_review_ist: addDaysIst(todayIst, 1),
        resolved: false,
      });
    } else if (prevR && !prevR.resolved) {
      revisionUpserts.push({
        student_id: session.principalId,
        question_id: q.id,
        chapter_id: q.chapter_id,
        wrong_count: prevR.wrong_count,
        ease_factor: 2.6,
        interval_days: 4,
        next_review_ist: addDaysIst(todayIst, 4),
        resolved: true,
      });
    }

    gradedResults.push({
      questionId: q.id,
      questionType: q.question_type,
      isCorrect: confident,
      correctOption: null,
      explanationHi: q.model_answer_hi,
      explanationEn: q.model_answer_en,
      resolvedFromRevision: Boolean(confident && prevR && !prevR.resolved),
    });
  }

  if (totalEvaluated === 0) {
    return jsonNoStore(
      { error: "कोई मान्य अभ्यास प्रश्न नहीं मिला।", errorEn: "No valid practice questions matched." },
      { status: 400 }
    );
  }

  // Cap per-session points cleanly so practice rewards honest effort without farming
  const rawPoints = correctCount * 10 + (totalEvaluated - correctCount) * 2;
  const pointsAwarded = Math.min(120, Math.max(2, rawPoints));

  // 6. Insert idempotent practice_sessions row FIRST (PK guard against concurrent double-clicks!)
  const { error: sessionInsertErr } = await supabase.from("practice_sessions").insert({
    attempt_id: attemptId,
    student_id: session.principalId,
    school_udise: session.schoolUdise!,
    subject_id: chapter.subject_id,
    chapter_id: chapter.id,
    mode: mode as PracticeMode,
    total_questions: totalEvaluated,
    correct_count: correctCount,
    points_awarded: pointsAwarded,
    time_spent_seconds: timeSpentSeconds,
  });

  if (sessionInsertErr) {
    // PostgreSQL unique violation (23505) on concurrent double-click
    if (sessionInsertErr.code === "23505") {
      return jsonNoStore({
        ok: true,
        duplicate: true,
        attemptId,
        totalQuestions: totalEvaluated,
        correctCount,
        pointsAwarded: 0,
        results: gradedResults,
      });
    }
    return jsonNoStore(
      { error: "अभ्यास सहेजने में त्रुटि हुई।", errorEn: "Could not record practice session." },
      { status: 500 }
    );
  }

  // 7. Persist mastery, revision queue, chapter progress, and student points/streak
  const writes: Array<PromiseLike<unknown>> = [];
  if (masteryUpserts.length > 0) {
    writes.push(
      supabase
        .from("student_question_mastery")
        .upsert(masteryUpserts, { onConflict: "student_id,question_id" })
    );
  }
  if (revisionUpserts.length > 0) {
    writes.push(
      supabase
        .from("student_revision_queue")
        .upsert(revisionUpserts, { onConflict: "student_id,question_id" })
    );
  }

  const prevProg = existingChapterProgRes.data;
  const nextAttempted = (prevProg?.practice_attempted ?? 0) + totalEvaluated;
  const nextCorrect = (prevProg?.practice_correct ?? 0) + correctCount;
  const nextFlashcards = (prevProg?.flashcards_mastered ?? 0) + flashcardsMasteredDelta;
  const notesPct = prevProg?.notes_completed ? 100 : prevProg?.notes_progress_pct ?? 0;
  const practiceAccuracy = nextAttempted > 0 ? Math.round((nextCorrect / nextAttempted) * 100) : 0;
  const nextMasteryPct = Math.min(
    100,
    Math.round(notesPct * 0.35 + practiceAccuracy * 0.65)
  );

  writes.push(
    supabase.from("student_chapter_progress").upsert(
      {
        student_id: session.principalId,
        chapter_id: chapter.id,
        notes_completed: prevProg?.notes_completed ?? false,
        notes_progress_pct: notesPct,
        flashcards_mastered: nextFlashcards,
        practice_attempted: nextAttempted,
        practice_correct: nextCorrect,
        mastery_pct: Math.max(prevProg?.mastery_pct ?? 0, nextMasteryPct),
        last_studied_at: nowIso,
      },
      { onConflict: "student_id,chapter_id" }
    )
  );

  await Promise.all(writes);

  const reward = await awardStudentStudyProgress({
    studentId: session.principalId,
    pointsDelta: pointsAwarded,
  });

  const finalMasteryPct = Math.max(prevProg?.mastery_pct ?? 0, nextMasteryPct);

  return jsonNoStore({
    ok: true,
    duplicate: false,
    attemptId,
    totalQuestions: totalEvaluated,
    correctCount,
    accuracyPct: Math.round((correctCount / totalEvaluated) * 100),
    pointsAwarded,
    chapterMasteryPct: finalMasteryPct,
    chapterMedal: computeChapterMedal(finalMasteryPct),
    reward,
    results: gradedResults,
  });
}
