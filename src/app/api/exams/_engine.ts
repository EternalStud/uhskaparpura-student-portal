import crypto from "node:crypto";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { sanitizeMarkdownSource, sanitizePlainText } from "@/lib/sanitize/content";
import type {
  DifficultyTier,
  ExamAttemptRow,
  ExamRow,
  ExamSnapshotQuestion,
  ExamSolutionPolicy,
  QuestionOption,
} from "@/types/database";

if (typeof window !== "undefined") {
  throw new Error("SECURITY: src/app/api/exams/_engine.ts is strictly server-only.");
}

export const EXAM_GRACE_SECONDS = 30;
const VALID_OPTIONS = new Set<"A" | "B" | "C" | "D">(["A", "B", "C", "D"]);

export interface QuestionOrderEntry {
  question_id: string;
  option_order: Array<"A" | "B" | "C" | "D">;
}

export interface StudentSanitizedQuestion {
  questionId: string;
  questionType: ExamSnapshotQuestion["question_type"];
  difficultyTier: DifficultyTier;
  examYearTag: string | null;
  qHi: string;
  qEn: string;
  options: QuestionOption[];
  visualAsset: ExamSnapshotQuestion["visual_asset_json"];
  marks: number;
}

export interface GradedQuestionSolution {
  questionId: string;
  qHi: string;
  qEn: string;
  options: QuestionOption[];
  selectedOption: string | null;
  correctOption: string | null;
  isCorrect: boolean;
  marks: number;
  marksAwarded: number;
  explanationHi: string | null;
  explanationEn: string | null;
}

export interface GradingResult {
  score: number;
  maxMarks: number;
  correctCount: number;
  totalQuestions: number;
  answeredCount: number;
  accuracy: number;
  solutions: GradedQuestionSolution[];
}

export interface CustomExamQuestionInput {
  qHi: string;
  qEn?: string;
  options: Array<{
    key: "A" | "B" | "C" | "D";
    textHi: string;
    textEn?: string;
  }>;
  correctOption: "A" | "B" | "C" | "D";
  explanationHi?: string;
  explanationEn?: string;
  difficultyTier?: DifficultyTier;
  marks?: number;
}

/**
 * Deterministic PRNG byte stream from SHA-256(seed:counter) for reproducible
 * per-student question and option shuffling (100% page-refresh safe).
 */
function deterministicUint32(seed: string, counter: number): number {
  const hash = crypto
    .createHash("sha256")
    .update(`${seed}:${counter}`, "utf8")
    .digest();
  return hash.readUInt32BE(0);
}

function deterministicShuffle<T>(items: ReadonlyArray<T>, seed: string): T[] {
  const arr = [...items];
  for (let i = arr.length - 1; i > 0; i--) {
    const rand = deterministicUint32(seed, i);
    const j = rand % (i + 1);
    const tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
  return arr;
}

export function buildQuestionOrderForAttempt(
  snapshot: ReadonlyArray<ExamSnapshotQuestion>,
  shuffleSeed: string,
  shuffleQuestions: boolean,
  shuffleOptions: boolean
): QuestionOrderEntry[] {
  const orderedQuestions = shuffleQuestions
    ? deterministicShuffle(snapshot, `${shuffleSeed}:questions`)
    : [...snapshot];

  return orderedQuestions.map((q, idx) => {
    const baseKeys = (q.options_json ?? [])
      .map((opt) => opt.key)
      .filter((k): k is "A" | "B" | "C" | "D" => VALID_OPTIONS.has(k));

    const keys: Array<"A" | "B" | "C" | "D"> =
      baseKeys.length > 0 ? baseKeys : ["A", "B", "C", "D"];

    const optionOrder = shuffleOptions
      ? deterministicShuffle(keys, `${shuffleSeed}:opts:${q.question_id}:${idx}`)
      : keys;

    return {
      question_id: q.question_id,
      option_order: optionOrder,
    };
  });
}

/**
 * Strips `correct_option` and explanations strictly before sending paper to a student.
 */
export function sanitizePaperForStudent(
  snapshot: ReadonlyArray<ExamSnapshotQuestion>,
  order: ReadonlyArray<QuestionOrderEntry>
): StudentSanitizedQuestion[] {
  const byId = new Map(snapshot.map((q) => [q.question_id, q]));
  const effectiveOrder =
    order.length > 0
      ? order
      : snapshot.map((q) => ({
          question_id: q.question_id,
          option_order: (q.options_json ?? []).map((o) => o.key),
        }));

  const out: StudentSanitizedQuestion[] = [];
  for (const entry of effectiveOrder) {
    const q = byId.get(entry.question_id);
    if (!q) continue;
    const optMap = new Map((q.options_json ?? []).map((o) => [o.key, o]));
    const orderedOptions: QuestionOption[] = [];
    for (const k of entry.option_order) {
      const found = optMap.get(k);
      if (found) orderedOptions.push(found);
    }
    // Append any option missing from order defensively
    for (const opt of q.options_json ?? []) {
      if (!orderedOptions.some((o) => o.key === opt.key)) {
        orderedOptions.push(opt);
      }
    }

    out.push({
      questionId: q.question_id,
      questionType: q.question_type,
      difficultyTier: q.difficulty_tier,
      examYearTag: q.exam_year_tag,
      qHi: q.q_hi,
      qEn: q.q_en,
      options: orderedOptions,
      visualAsset: q.visual_asset_json,
      marks: q.marks > 0 ? q.marks : 1,
    });
  }

  return out;
}

/**
 * Normalizes student answers strictly against the exam snapshot question IDs & A/B/C/D keys.
 */
export function sanitizeStudentAnswers(
  rawAnswers: Record<string, string | null | undefined>,
  snapshot: ReadonlyArray<ExamSnapshotQuestion>,
  existingAnswers: Record<string, string> = {}
): Record<string, string> {
  const validQuestionIds = new Set(snapshot.map((q) => q.question_id));
  const merged: Record<string, string> = {};

  for (const [k, v] of Object.entries(existingAnswers)) {
    if (validQuestionIds.has(k) && VALID_OPTIONS.has(v as "A" | "B" | "C" | "D")) {
      merged[k] = v;
    }
  }

  for (const [k, rawVal] of Object.entries(rawAnswers)) {
    if (!validQuestionIds.has(k)) continue;
    if (rawVal === null || rawVal === "") {
      delete merged[k];
      continue;
    }
    if (typeof rawVal === "string") {
      const upper = rawVal.trim().toUpperCase();
      if (VALID_OPTIONS.has(upper as "A" | "B" | "C" | "D")) {
        merged[k] = upper;
      }
    }
  }

  return merged;
}

/**
 * Strictly server-side grading against immutable `exams.questions_snapshot`.
 */
export function gradeAttemptAgainstSnapshot(
  snapshot: ReadonlyArray<ExamSnapshotQuestion>,
  answers: Record<string, string>
): GradingResult {
  let score = 0;
  let maxMarks = 0;
  let correctCount = 0;
  let answeredCount = 0;
  const solutions: GradedQuestionSolution[] = [];

  for (const q of snapshot) {
    const marks = Number.isFinite(q.marks) && q.marks > 0 ? Math.floor(q.marks) : 1;
    maxMarks += marks;
    const selectedRaw = answers[q.question_id];
    const selectedOption =
      selectedRaw && VALID_OPTIONS.has(selectedRaw as "A" | "B" | "C" | "D")
        ? selectedRaw
        : null;

    if (selectedOption) {
      answeredCount += 1;
    }

    const correctOption = q.correct_option ? q.correct_option.trim().toUpperCase() : null;
    const isCorrect = Boolean(selectedOption && correctOption && selectedOption === correctOption);
    const marksAwarded = isCorrect ? marks : 0;

    if (isCorrect) {
      correctCount += 1;
      score += marksAwarded;
    }

    solutions.push({
      questionId: q.question_id,
      qHi: q.q_hi,
      qEn: q.q_en,
      options: q.options_json ?? [],
      selectedOption,
      correctOption,
      isCorrect,
      marks,
      marksAwarded,
      explanationHi: q.explanation_hi,
      explanationEn: q.explanation_en,
    });
  }

  const totalQuestions = snapshot.length;
  const rawAccuracy = maxMarks > 0 ? (score / maxMarks) * 100 : 0;
  const accuracy = Math.min(100, Math.max(0, Math.round(rawAccuracy * 100) / 100));

  return {
    score,
    maxMarks,
    correctCount,
    totalQuestions,
    answeredCount,
    accuracy,
    solutions,
  };
}

/**
 * Checks whether solutions may be revealed to a student after submission,
 * strictly honoring `TEACHER_ONLY`, `IMMEDIATE_ON_SUBMIT`, and `AFTER_EXAM_ENDS`.
 */
export function areSolutionsUnlockedForStudent(
  exam: Pick<ExamRow, "show_solutions_policy" | "status" | "ends_at">,
  nowMs: number = Date.now()
): boolean {
  const policy: ExamSolutionPolicy | string = exam.show_solutions_policy;
  if (policy === "TEACHER_ONLY") return false;
  if (policy === "IMMEDIATE_ON_SUBMIT" || policy === "IMMEDIATE") return true;

  // AFTER_EXAM_ENDS
  if (exam.status === "ENDED") return true;
  if (exam.ends_at) {
    const endsMs = new Date(exam.ends_at).getTime();
    if (!Number.isNaN(endsMs) && nowMs > endsMs) {
      return true;
    }
  }
  return false;
}

/**
 * Computes server-authoritative countdown & strict deadline with 30-second grace:
 * `LEAST(started_at + duration_mins + 30s grace, ends_at)`
 */
export function computeExamTiming(params: {
  exam: Pick<ExamRow, "status" | "duration_mins" | "ends_at">;
  startedAtIso: string | null;
  nowMs?: number;
}): {
  remainingSeconds: number;
  hardDeadlineMs: number | null;
  isPastDeadline: boolean;
  elapsedSeconds: number;
} {
  const nowMs = params.nowMs ?? Date.now();
  const durationMs = params.exam.duration_mins * 60_000;

  if (params.exam.status === "LOBBY" || !params.startedAtIso) {
    return {
      remainingSeconds: params.exam.duration_mins * 60,
      hardDeadlineMs: null,
      isPastDeadline: false,
      elapsedSeconds: 0,
    };
  }

  const startedMs = new Date(params.startedAtIso).getTime();
  if (Number.isNaN(startedMs)) {
    return {
      remainingSeconds: 0,
      hardDeadlineMs: nowMs,
      isPastDeadline: true,
      elapsedSeconds: 0,
    };
  }

  const endsAtMs = params.exam.ends_at ? new Date(params.exam.ends_at).getTime() : null;
  const validEndsAtMs = endsAtMs !== null && !Number.isNaN(endsAtMs) ? endsAtMs : null;

  // Display countdown (without grace)
  const displayEndMs =
    validEndsAtMs !== null
      ? Math.min(startedMs + durationMs, validEndsAtMs)
      : startedMs + durationMs;

  // Strict server enforcement deadline: LEAST(started_at + duration_mins + 30s grace, ends_at)
  const graceEndMs = startedMs + durationMs + EXAM_GRACE_SECONDS * 1000;
  const hardDeadlineMs =
    validEndsAtMs !== null ? Math.min(graceEndMs, validEndsAtMs) : graceEndMs;

  const remainingSeconds = Math.max(0, Math.floor((displayEndMs - nowMs) / 1000));
  const elapsedSeconds = Math.max(0, Math.floor((nowMs - startedMs) / 1000));
  const isPastDeadline = params.exam.status === "ENDED" || nowMs > hardDeadlineMs;

  return {
    remainingSeconds,
    hardDeadlineMs,
    isPastDeadline,
    elapsedSeconds,
  };
}

/**
 * Builds an immutable `ExamSnapshotQuestion[]` array from bank question IDs (both PRACTICE & EXAM_ONLY)
 * and teacher-authored custom MCQ questions.
 */
export async function buildExamQuestionsSnapshot(params: {
  subjectId: string;
  questionIds: string[];
  customQuestions?: CustomExamQuestionInput[];
  existingCustomSnapshots?: ExamSnapshotQuestion[];
}): Promise<
  | { ok: true; validBankIds: string[]; snapshot: ExamSnapshotQuestion[] }
  | { ok: false; error: string }
> {
  const supabase = getSupabaseAdmin();
  const uniqueBankIds = Array.from(new Set(params.questionIds));
  const snapshot: ExamSnapshotQuestion[] = [];
  const validBankIds: string[] = [];

  if (uniqueBankIds.length > 0) {
    const { data: rows, error } = await supabase
      .from("questions")
      .select(
        "id, subject_id, question_type, difficulty_tier, exam_year_tag, q_hi, q_en, options_json, correct_option, explanation_hi, explanation_en, visual_asset_json, is_published"
      )
      .in("id", uniqueBankIds)
      .eq("subject_id", params.subjectId)
      .eq("question_type", "MCQ")
      .eq("is_published", true);

    if (error) {
      return { ok: false, error: "Could not load selected bank questions." };
    }

    const rowMap = new Map((rows ?? []).map((r) => [r.id, r]));
    for (const qid of uniqueBankIds) {
      const q = rowMap.get(qid);
      if (!q || !q.correct_option || !Array.isArray(q.options_json) || q.options_json.length < 2) {
        continue;
      }
      validBankIds.push(q.id);
      snapshot.push({
        question_id: q.id,
        question_type: q.question_type,
        difficulty_tier: q.difficulty_tier,
        exam_year_tag: q.exam_year_tag,
        q_hi: q.q_hi,
        q_en: q.q_en,
        options_json: q.options_json,
        correct_option: q.correct_option.trim().toUpperCase(),
        explanation_hi: q.explanation_hi,
        explanation_en: q.explanation_en,
        visual_asset_json: q.visual_asset_json,
        marks: 1,
      });
    }
  }

  if (params.customQuestions && params.customQuestions.length > 0) {
    for (const cq of params.customQuestions) {
      const cleanHi = sanitizeMarkdownSource(cq.qHi, 2000);
      const cleanEn = sanitizeMarkdownSource(cq.qEn || cq.qHi, 2000);
      if (cleanHi.length < 3) continue;

      const options: QuestionOption[] = cq.options.map((opt) => ({
        key: opt.key,
        text_hi: sanitizePlainText(opt.textHi, 400),
        text_en: sanitizePlainText(opt.textEn || opt.textHi, 400),
      }));

      if (options.length < 2 || options.some((o) => !o.text_hi)) continue;

      snapshot.push({
        question_id: `custom-${crypto.randomUUID()}`,
        question_type: "MCQ",
        difficulty_tier: cq.difficultyTier ?? "BOARD",
        exam_year_tag: null,
        q_hi: cleanHi,
        q_en: cleanEn,
        options_json: options,
        correct_option: cq.correctOption,
        explanation_hi: cq.explanationHi ? sanitizeMarkdownSource(cq.explanationHi, 2000) : null,
        explanation_en: cq.explanationEn ? sanitizeMarkdownSource(cq.explanationEn, 2000) : null,
        visual_asset_json: null,
        marks: cq.marks && cq.marks >= 1 && cq.marks <= 10 ? Math.floor(cq.marks) : 1,
      });
    }
  } else if (params.existingCustomSnapshots && params.existingCustomSnapshots.length > 0) {
    for (const item of params.existingCustomSnapshots) {
      if (item.question_id.startsWith("custom-")) {
        snapshot.push(item);
      }
    }
  }

  if (snapshot.length === 0) {
    return {
      ok: false,
      error: "Please include at least 1 valid MCQ question in the exam.",
    };
  }
  if (snapshot.length > 100) {
    return {
      ok: false,
      error: "An exam can contain at most 100 questions.",
    };
  }

  return { ok: true, validBankIds, snapshot };
}

/**
 * Helper to auto-grade and finalize an in-progress attempt (used on deadline expiry or teacher End Exam).
 */
export async function finalizeExamAttempt(params: {
  exam: ExamRow;
  attempt: ExamAttemptRow;
  studentName: string;
  rollNo: number;
  answersOverride?: Record<string, string>;
  tabSwitchesOverride?: number;
}): Promise<GradingResult & { submittedAt: string; timeTakenSeconds: number }> {
  const supabase = getSupabaseAdmin();
  const snapshot = Array.isArray(params.exam.questions_snapshot)
    ? params.exam.questions_snapshot
    : [];
  const finalAnswers = params.answersOverride ?? params.attempt.answers_json ?? {};
  const grading = gradeAttemptAgainstSnapshot(snapshot, finalAnswers);

  const now = new Date();
  const submittedAt = now.toISOString();
  const startedMs = params.attempt.started_at
    ? new Date(params.attempt.started_at).getTime()
    : now.getTime();
  const timeTakenSeconds = Number.isNaN(startedMs)
    ? params.attempt.time_taken_seconds
    : Math.max(
        params.attempt.time_taken_seconds,
        Math.min(
          params.exam.duration_mins * 60 + EXAM_GRACE_SECONDS,
          Math.floor((now.getTime() - startedMs) / 1000)
        )
      );

  const tabSwitches =
    typeof params.tabSwitchesOverride === "number"
      ? Math.max(params.attempt.tab_switches, Math.min(999, Math.floor(params.tabSwitchesOverride)))
      : params.attempt.tab_switches;

  await Promise.all([
    supabase
      .from("exam_attempts")
      .update({
        answers_json: finalAnswers,
        status: "SUBMITTED",
        answered_count: grading.answeredCount,
        score: grading.score,
        total_questions: grading.totalQuestions,
        accuracy: grading.accuracy,
        tab_switches: tabSwitches,
        time_taken_seconds: timeTakenSeconds,
        submitted_at: submittedAt,
      })
      .eq("id", params.attempt.id)
      .eq("school_udise", params.exam.school_udise),
    supabase.from("live_exam_roster").upsert(
      {
        exam_id: params.exam.id,
        student_id: params.attempt.student_id,
        school_udise: params.exam.school_udise,
        student_name: params.studentName,
        roll_no: params.rollNo,
        status: "SUBMITTED",
        answered_count: grading.answeredCount,
        total_questions: grading.totalQuestions,
        score: grading.score,
        accuracy: grading.accuracy,
        tab_switches: tabSwitches,
      },
      { onConflict: "exam_id,student_id" }
    ),
  ]);

  return { ...grading, submittedAt, timeTakenSeconds };
}
