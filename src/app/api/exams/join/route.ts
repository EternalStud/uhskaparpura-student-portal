import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  consumePrincipalRateLimit,
  generateShuffleSeed,
  jsonNoStore,
  requireRole,
  validateCsrf,
} from "@/lib/auth";
import { isWithinWindow } from "@/lib/time/ist";
import {
  getStudentAccessibleSubjectIds,
  resolveCanonicalSubjectId,
} from "@/app/api/student/_helpers";
import {
  areSolutionsUnlockedForStudent,
  buildQuestionOrderForAttempt,
  computeExamTiming,
  gradeAttemptAgainstSnapshot,
  sanitizePaperForStudent,
} from "@/app/api/exams/_engine";

const joinExamSchema = z
  .object({
    roomPin: z.string().trim().regex(/^\d{6}$/, "Room PIN must be 6 digits.").optional(),
    examId: z.string().uuid().optional(),
  })
  .refine((d) => Boolean(d.roomPin) !== Boolean(d.examId), {
    message: "Provide either a 6-digit roomPin or an examId.",
  });

/**
 * POST /api/exams/join
 * Student joins a Live Classroom exam by school-scoped 6-digit `roomPin` OR a Scheduled exam by `examId`.
 * - Verifies school isolation, class/stream/enrolled subject eligibility, and IST schedule window.
 * - Creates or resumes a page-refresh-safe `exam_attempts` row with deterministic `shuffle_seed`.
 * - Strictly strips `correct_option` and explanations before returning paper.
 * - Upserts `live_exam_roster` summary row for real-time projector monitor.
 */
export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise || !session.student) {
    return jsonNoStore({ error: "Student session required." }, { status: 403 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid JSON payload." }, { status: 400 });
  }

  const parsed = joinExamSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please enter a valid 6-digit Classroom Room Code.",
        errorHi: "कृपया 6 अंकों का सही कक्षा रूम कोड दर्ज करें।",
      },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();

  if (parsed.data.roomPin) {
    const pinRl = await consumePrincipalRateLimit(
      "exam-pin-join",
      session.principalId,
      15,
      10 * 60 * 1000
    );
    if (!pinRl.allowed) {
      return jsonNoStore(
        {
          error: "Too many Room Code attempts. Please wait a few minutes and check the code with your teacher.",
          errorHi: "कई बार गलत रूम कोड प्रयास हुए हैं। कृपया कुछ मिनट रुकें और शिक्षक से सही कोड पूछें।",
        },
        { status: 429 }
      );
    }
  }

  let examQuery = supabase
    .from("exams")
    .select("*")
    .eq("school_udise", session.schoolUdise);

  if (parsed.data.roomPin) {
    examQuery = examQuery
      .eq("room_pin", parsed.data.roomPin)
      .eq("exam_mode", "LIVE_PIN")
      .in("status", ["LOBBY", "ACTIVE"]);
  } else if (parsed.data.examId) {
    examQuery = examQuery.eq("id", parsed.data.examId);
  }

  const { data: exam } = await examQuery.maybeSingle();

  if (!exam || exam.status === "DRAFT") {
    return jsonNoStore(
      {
        error: parsed.data.roomPin
          ? "No active classroom exam found with this 6-digit Room Code in your school."
          : "Exam was not found.",
        errorHi: parsed.data.roomPin
          ? "आपके विद्यालय में इस 6-अंकीय रूम कोड से कोई सक्रिय परीक्षा नहीं मिली।"
          : "यह परीक्षा उपलब्ध नहीं है।",
      },
      { status: 404 }
    );
  }

  // Verify Class, Stream, and Accessible Subject eligibility (including Universal Labs & Aliases)
  const [accessibleSubjectIds, examCanonicalSubjectId] = await Promise.all([
    getStudentAccessibleSubjectIds(session.principalId, session.student.academicYear),
    resolveCanonicalSubjectId(exam.subject_id),
  ]);

  const streamMatches =
    exam.stream === "ALL" ||
    exam.stream === "NA" ||
    exam.stream === session.student.stream;

  const subjectEligible =
    accessibleSubjectIds.includes(exam.subject_id) ||
    accessibleSubjectIds.includes(examCanonicalSubjectId);

  if (
    exam.class_num !== session.student.classNum ||
    !streamMatches ||
    !subjectEligible
  ) {
    return jsonNoStore(
      {
        error: `This exam is for Class ${exam.class_num} students enrolled in this subject.`,
        errorHi: `यह परीक्षा कक्षा ${exam.class_num} के इस विषय के विद्यार्थियों के लिए है।`,
      },
      { status: 403 }
    );
  }

  // Fetch existing attempt first (allows viewing submitted result even if exam ended)
  const [{ data: existingAttempt }, { data: subject }] = await Promise.all([
    supabase
      .from("exam_attempts")
      .select("*")
      .eq("exam_id", exam.id)
      .eq("student_id", session.principalId)
      .maybeSingle(),
    supabase
      .from("subjects")
      .select("id, class_num, name_hi, name_en, accent_color")
      .eq("id", exam.subject_id)
      .maybeSingle(),
  ]);

  const snapshot = Array.isArray(exam.questions_snapshot) ? exam.questions_snapshot : [];
  if (snapshot.length === 0) {
    return jsonNoStore({ error: "Exam paper has no questions configured." }, { status: 409 });
  }

  // If already submitted, return clean result summary without leaking solutions if locked
  if (existingAttempt?.status === "SUBMITTED") {
    const solutionsUnlocked = areSolutionsUnlockedForStudent(exam);
    const graded = gradeAttemptAgainstSnapshot(snapshot, existingAttempt.answers_json ?? {});

    return jsonNoStore({
      ok: true,
      alreadySubmitted: true,
      serverNowIso: new Date().toISOString(),
      exam: {
        id: exam.id,
        title: exam.title,
        examMode: exam.exam_mode,
        classNum: exam.class_num,
        subject: subject
          ? { id: subject.id, nameHi: subject.name_hi, nameEn: subject.name_en }
          : null,
        durationMins: exam.duration_mins,
        status: exam.status,
        showSolutionsPolicy: exam.show_solutions_policy,
        solutionsUnlocked,
        questionCount: snapshot.length,
      },
      attempt: {
        id: existingAttempt.id,
        status: existingAttempt.status,
        score: existingAttempt.score,
        maxMarks: graded.maxMarks,
        correctCount: graded.correctCount,
        totalQuestions: existingAttempt.total_questions,
        answeredCount: existingAttempt.answered_count,
        accuracy: Number(existingAttempt.accuracy),
        timeTakenSeconds: existingAttempt.time_taken_seconds,
        startedAt: existingAttempt.started_at,
        submittedAt: existingAttempt.submitted_at,
      },
      solutions: solutionsUnlocked ? graded.solutions : null,
    });
  }

  if (exam.status === "ENDED") {
    return jsonNoStore(
      {
        error: "This exam has already ended.",
        errorHi: "यह परीक्षा समाप्त हो चुकी है।",
      },
      { status: 410 }
    );
  }

  // Prevent bypassing the 6-digit Classroom Room Code by supplying examId directly on a LIVE_PIN exam
  if (exam.exam_mode === "LIVE_PIN" && !parsed.data.roomPin && !existingAttempt) {
    return jsonNoStore(
      {
        error: "Please enter the 6-digit Classroom Room Code displayed by your teacher to join this live exam.",
        errorHi: "इस लाइव परीक्षा में जुड़ने के लिए कृपया शिक्षक द्वारा दिखाया गया 6 अंकों का रूम कोड दर्ज करें।",
      },
      { status: 403 }
    );
  }

  // Check IST exam window for SCHEDULED exams
  if (exam.exam_mode === "SCHEDULED") {
    const now = new Date();
    if (exam.starts_at && now.getTime() < new Date(exam.starts_at).getTime()) {
      return jsonNoStore(
        {
          error: "This scheduled exam has not started yet.",
          errorHi: "यह निर्धारित परीक्षा अभी शुरू नहीं हुई है।",
          startsAt: exam.starts_at,
        },
        { status: 403 }
      );
    }
    if (!isWithinWindow(exam.starts_at, exam.ends_at, now)) {
      return jsonNoStore(
        {
          error: "The scheduled window for this exam has closed.",
          errorHi: "इस परीक्षा का निर्धारित समय समाप्त हो गया है।",
        },
        { status: 410 }
      );
    }
  }

  const nowIso = new Date().toISOString();
  let activeAttempt = existingAttempt;

  if (!activeAttempt) {
    const shuffleSeed = generateShuffleSeed();
    const questionOrder = buildQuestionOrderForAttempt(
      snapshot,
      shuffleSeed,
      exam.shuffle_questions,
      exam.shuffle_options
    );
    const initialAttemptStatus = exam.status === "LOBBY" ? "JOINED" : "IN_PROGRESS";
    const startedAt = exam.status === "ACTIVE" ? nowIso : null;

    const { data: created, error: createErr } = await supabase
      .from("exam_attempts")
      .insert({
        exam_id: exam.id,
        school_udise: session.schoolUdise,
        academic_year: session.student.academicYear,
        student_id: session.principalId,
        shuffle_seed: shuffleSeed,
        question_order_json: questionOrder,
        answers_json: {},
        status: initialAttemptStatus,
        answered_count: 0,
        score: 0,
        total_questions: snapshot.length,
        accuracy: 0,
        tab_switches: 0,
        time_taken_seconds: 0,
        started_at: startedAt,
      })
      .select("*")
      .single();

    if (createErr || !created) {
      // Handle rare double-click race by re-fetching
      const { data: refetched } = await supabase
        .from("exam_attempts")
        .select("*")
        .eq("exam_id", exam.id)
        .eq("student_id", session.principalId)
        .maybeSingle();
      if (!refetched) {
        return jsonNoStore({ error: "Could not join exam. Please retry." }, { status: 500 });
      }
      activeAttempt = refetched;
    } else {
      activeAttempt = created;
    }
  } else if (exam.status === "ACTIVE" && activeAttempt.status === "JOINED") {
    // Exam started while student was waiting in LOBBY -> start student's timer cleanly
    const { data: transitioned } = await supabase
      .from("exam_attempts")
      .update({
        status: "IN_PROGRESS",
        started_at: activeAttempt.started_at ?? nowIso,
      })
      .eq("id", activeAttempt.id)
      .select("*")
      .single();
    if (transitioned) activeAttempt = transitioned;
  }

  // Upsert live_exam_roster summary row (ZERO answers_json!)
  await supabase.from("live_exam_roster").upsert(
    {
      exam_id: exam.id,
      student_id: session.principalId,
      school_udise: session.schoolUdise,
      student_name: session.student.studentName,
      roll_no: session.student.rollNo,
      status: activeAttempt.status,
      answered_count: activeAttempt.answered_count,
      total_questions: snapshot.length,
      score: activeAttempt.score,
      accuracy: activeAttempt.accuracy,
      tab_switches: activeAttempt.tab_switches,
    },
    { onConflict: "exam_id,student_id" }
  );

  const timing = computeExamTiming({
    exam,
    startedAtIso: activeAttempt.started_at,
  });

  // Return sanitized questions ONLY once exam is ACTIVE (keep paper hidden during LOBBY!)
  const sanitizedQuestions =
    exam.status === "ACTIVE"
      ? sanitizePaperForStudent(snapshot, activeAttempt.question_order_json ?? [])
      : [];

  return jsonNoStore({
    ok: true,
    alreadySubmitted: false,
    serverNowIso: nowIso,
    remainingSeconds: timing.remainingSeconds,
    exam: {
      id: exam.id,
      title: exam.title,
      examMode: exam.exam_mode,
      scopeType: exam.scope_type,
      classNum: exam.class_num,
      subject: subject
        ? { id: subject.id, nameHi: subject.name_hi, nameEn: subject.name_en }
        : null,
      durationMins: exam.duration_mins,
      startsAt: exam.starts_at,
      endsAt: exam.ends_at,
      status: exam.status,
      showSolutionsPolicy: exam.show_solutions_policy,
      questionCount: snapshot.length,
    },
    attempt: {
      id: activeAttempt.id,
      status: activeAttempt.status,
      answers: activeAttempt.answers_json ?? {},
      answeredCount: activeAttempt.answered_count,
      tabSwitches: activeAttempt.tab_switches,
      startedAt: activeAttempt.started_at,
      totalQuestions: snapshot.length,
    },
    questions: sanitizedQuestions,
  });
}
