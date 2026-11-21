import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole, validateCsrf } from "@/lib/auth";
import {
  areSolutionsUnlockedForStudent,
  computeExamTiming,
  finalizeExamAttempt,
  gradeAttemptAgainstSnapshot,
  sanitizeStudentAnswers,
} from "@/app/api/exams/_engine";

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const attemptPayloadSchema = z.object({
  answers: z.record(z.string(), z.string().nullable()).optional(),
  tabSwitches: z.number().int().min(0).max(999).optional(),
  submit: z.boolean().optional(),
});

/**
 * POST /api/exams/[id]/attempt
 * Student incremental auto-save AND final submission endpoint.
 * - Enforces strict server deadline: `NOW() <= LEAST(started_at + duration_mins + 30s grace, ends_at)`.
 * - Grades strictly SERVER-SIDE against `exams.questions_snapshot`.
 * - Updates `exam_attempts` and `live_exam_roster` summary row.
 * - Releases solutions ONLY when `show_solutions_policy === 'IMMEDIATE_ON_SUBMIT'` OR
 *   (`show_solutions_policy === 'AFTER_EXAM_ENDS'` AND (`exam.status === 'ENDED'` OR `NOW() > exam.ends_at`)).
 */
export async function POST(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise || !session.student) {
    return jsonNoStore({ error: "Student session required." }, { status: 403 });
  }

  const { id } = await context.params;
  if (!UUID_RE.test(id)) {
    return jsonNoStore({ error: "Invalid exam identifier." }, { status: 400 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid JSON payload." }, { status: 400 });
  }

  const parsed = attemptPayloadSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: "Invalid attempt payload." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();

  const [{ data: exam }, { data: attempt }] = await Promise.all([
    supabase
      .from("exams")
      .select("*")
      .eq("id", id)
      .eq("school_udise", session.schoolUdise)
      .maybeSingle(),
    supabase
      .from("exam_attempts")
      .select("*")
      .eq("exam_id", id)
      .eq("student_id", session.principalId)
      .maybeSingle(),
  ]);

  if (!exam || !attempt) {
    return jsonNoStore(
      { error: "Exam attempt not found. Please join the exam first." },
      { status: 404 }
    );
  }

  const snapshot = Array.isArray(exam.questions_snapshot) ? exam.questions_snapshot : [];

  // Idempotent return if already submitted
  if (attempt.status === "SUBMITTED") {
    const solutionsUnlocked = areSolutionsUnlockedForStudent(exam);
    const graded = gradeAttemptAgainstSnapshot(snapshot, attempt.answers_json ?? {});

    return jsonNoStore({
      ok: true,
      submitted: true,
      alreadySubmitted: true,
      score: attempt.score,
      maxMarks: graded.maxMarks,
      correctCount: graded.correctCount,
      totalQuestions: attempt.total_questions,
      answeredCount: attempt.answered_count,
      accuracy: Number(attempt.accuracy),
      timeTakenSeconds: attempt.time_taken_seconds,
      submittedAt: attempt.submitted_at,
      solutionsUnlocked,
      showSolutionsPolicy: exam.show_solutions_policy,
      solutions: solutionsUnlocked ? graded.solutions : null,
    });
  }

  if (exam.status === "LOBBY" || !attempt.started_at) {
    return jsonNoStore(
      {
        error: "Waiting for your teacher to start the exam.",
        errorHi: "कृपया शिक्षक द्वारा परीक्षा शुरू करने की प्रतीक्षा करें।",
      },
      { status: 409 }
    );
  }

  const timing = computeExamTiming({
    exam,
    startedAtIso: attempt.started_at,
  });

  // Strict server deadline guard: past deadline, ignore newly supplied answers and auto-finalize saved answers
  if (timing.isPastDeadline) {
    const finalized = await finalizeExamAttempt({
      exam,
      attempt,
      studentName: session.student.studentName,
      rollNo: session.student.rollNo,
      tabSwitchesOverride: parsed.data.tabSwitches,
    });

    const solutionsUnlocked = areSolutionsUnlockedForStudent(exam);

    return jsonNoStore(
      {
        ok: true,
        submitted: true,
        timeExpired: true,
        autoSubmittedOnDeadline: true,
        score: finalized.score,
        maxMarks: finalized.maxMarks,
        correctCount: finalized.correctCount,
        totalQuestions: finalized.totalQuestions,
        answeredCount: finalized.answeredCount,
        accuracy: finalized.accuracy,
        timeTakenSeconds: finalized.timeTakenSeconds,
        submittedAt: finalized.submittedAt,
        solutionsUnlocked,
        showSolutionsPolicy: exam.show_solutions_policy,
        solutions: solutionsUnlocked ? finalized.solutions : null,
      },
      { status: 200 }
    );
  }

  const mergedAnswers = sanitizeStudentAnswers(
    parsed.data.answers ?? {},
    snapshot,
    attempt.answers_json ?? {}
  );
  const answeredCount = Object.keys(mergedAnswers).length;
  const monotonicTabSwitches =
    typeof parsed.data.tabSwitches === "number"
      ? Math.max(attempt.tab_switches, Math.min(999, parsed.data.tabSwitches))
      : attempt.tab_switches;

  // Final Submit path (strictly server-graded)
  if (parsed.data.submit) {
    const finalized = await finalizeExamAttempt({
      exam,
      attempt,
      studentName: session.student.studentName,
      rollNo: session.student.rollNo,
      answersOverride: mergedAnswers,
      tabSwitchesOverride: monotonicTabSwitches,
    });

    const solutionsUnlocked = areSolutionsUnlockedForStudent(exam);

    return jsonNoStore({
      ok: true,
      submitted: true,
      score: finalized.score,
      maxMarks: finalized.maxMarks,
      correctCount: finalized.correctCount,
      totalQuestions: finalized.totalQuestions,
      answeredCount: finalized.answeredCount,
      accuracy: finalized.accuracy,
      timeTakenSeconds: finalized.timeTakenSeconds,
      submittedAt: finalized.submittedAt,
      solutionsUnlocked,
      showSolutionsPolicy: exam.show_solutions_policy,
      solutions: solutionsUnlocked ? finalized.solutions : null,
    });
  }

  // Incremental Auto-Save path
  await Promise.all([
    supabase
      .from("exam_attempts")
      .update({
        answers_json: mergedAnswers,
        answered_count: answeredCount,
        tab_switches: monotonicTabSwitches,
        status: "IN_PROGRESS",
        time_taken_seconds: timing.elapsedSeconds,
      })
      .eq("id", attempt.id)
      .eq("school_udise", session.schoolUdise),
    supabase.from("live_exam_roster").upsert(
      {
        exam_id: exam.id,
        student_id: session.principalId,
        school_udise: session.schoolUdise,
        student_name: session.student.studentName,
        roll_no: session.student.rollNo,
        status: "IN_PROGRESS",
        answered_count: answeredCount,
        total_questions: snapshot.length,
        score: 0,
        accuracy: 0,
        tab_switches: monotonicTabSwitches,
      },
      { onConflict: "exam_id,student_id" }
    ),
  ]);

  return jsonNoStore({
    ok: true,
    saved: true,
    answeredCount,
    tabSwitches: monotonicTabSwitches,
    remainingSeconds: timing.remainingSeconds,
    serverNowIso: new Date().toISOString(),
  });
}
