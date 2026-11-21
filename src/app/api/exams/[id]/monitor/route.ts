import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole } from "@/lib/auth";
import {
  isRealtimeJwtConfigured,
  mintRealtimeExamJwt,
} from "@/lib/supabase/realtime";

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * GET /api/exams/[id]/monitor
 * Teacher-only Live Classroom Projector Monitor & Scheduled Exam Analytics endpoint.
 * Returns:
 * - Exam details & 6-digit Room PIN
 * - Live student roster (`live_exam_roster`)
 * - Question-wise accuracy & option distribution analytics
 * - Short-lived scoped Supabase Realtime JWT restricted to `{ school_udise, exam_id }`
 */
export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
  }

  const { id } = await context.params;
  if (!UUID_RE.test(id)) {
    return jsonNoStore({ error: "Invalid exam identifier." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();

  const { data: exam } = await supabase
    .from("exams")
    .select("*")
    .eq("id", id)
    .eq("school_udise", session.schoolUdise)
    .maybeSingle();

  if (!exam) {
    return jsonNoStore({ error: "Exam not found in your school." }, { status: 404 });
  }

  const canViewMonitor =
    exam.created_by_teacher === session.principalId ||
    session.teacher?.isSchoolAdmin === true ||
    (session.teacher?.assignedSubjectIds.includes(exam.subject_id) ?? false);

  if (!canViewMonitor) {
    return jsonNoStore(
      { error: "You do not have permission to monitor this exam." },
      { status: 403 }
    );
  }

  const [{ data: subject }, { data: rosterRows }, { data: attempts }] = await Promise.all([
    supabase
      .from("subjects")
      .select("id, class_num, name_hi, name_en, accent_color")
      .eq("id", exam.subject_id)
      .maybeSingle(),
    supabase
      .from("live_exam_roster")
      .select(
        "exam_id, student_id, student_name, roll_no, status, answered_count, total_questions, score, accuracy, tab_switches, updated_at"
      )
      .eq("exam_id", exam.id)
      .eq("school_udise", session.schoolUdise)
      .order("score", { ascending: false })
      .order("answered_count", { ascending: false })
      .order("roll_no", { ascending: true }),
    supabase
      .from("exam_attempts")
      .select("id, student_id, status, answers_json, score, accuracy, time_taken_seconds, tab_switches, submitted_at")
      .eq("exam_id", exam.id)
      .eq("school_udise", session.schoolUdise),
  ]);

  const roster = rosterRows ?? [];
  const allAttempts = attempts ?? [];
  const snapshot = Array.isArray(exam.questions_snapshot) ? exam.questions_snapshot : [];

  const maxMarks = snapshot.reduce(
    (sum, q) => sum + (Number.isFinite(q.marks) && q.marks > 0 ? Math.floor(q.marks) : 1),
    0
  );

  // Compute Question-Wise Accuracy Analytics across submitted (or in-progress) attempts
  const submittedAttempts = allAttempts.filter((a) => a.status === "SUBMITTED");
  const analyticsBase = submittedAttempts.length > 0 ? submittedAttempts : allAttempts;

  const questionAnalytics = snapshot.map((q, index) => {
    let attemptedCount = 0;
    let correctCount = 0;
    const optionDistribution: Record<"A" | "B" | "C" | "D", number> = {
      A: 0,
      B: 0,
      C: 0,
      D: 0,
    };

    const correctOpt = q.correct_option?.trim().toUpperCase() ?? null;

    for (const att of analyticsBase) {
      const ans = att.answers_json?.[q.question_id];
      if (!ans) continue;
      const upper = ans.toUpperCase() as "A" | "B" | "C" | "D";
      if (upper in optionDistribution) {
        attemptedCount += 1;
        optionDistribution[upper] += 1;
        if (correctOpt && upper === correctOpt) {
          correctCount += 1;
        }
      }
    }

    const accuracyPct =
      attemptedCount > 0 ? Math.round((correctCount / attemptedCount) * 1000) / 10 : 0;

    return {
      index: index + 1,
      questionId: q.question_id,
      difficultyTier: q.difficulty_tier,
      examYearTag: q.exam_year_tag,
      qHi: q.q_hi,
      qEn: q.q_en,
      correctOption: correctOpt,
      marks: q.marks > 0 ? q.marks : 1,
      attemptedCount,
      correctCount,
      accuracyPct,
      optionDistribution,
    };
  });

  // Summary metrics
  const joinedCount = roster.length;
  const inProgressCount = roster.filter((r) => r.status === "IN_PROGRESS").length;
  const submittedCount = roster.filter((r) => r.status === "SUBMITTED").length;
  const waitingCount = roster.filter((r) => r.status === "JOINED").length;
  const submittedRoster = roster.filter((r) => r.status === "SUBMITTED");
  const avgScore =
    submittedRoster.length > 0
      ? Math.round(
          (submittedRoster.reduce((s, r) => s + r.score, 0) / submittedRoster.length) * 10
        ) / 10
      : 0;
  const avgAccuracy =
    submittedRoster.length > 0
      ? Math.round(
          (submittedRoster.reduce((s, r) => s + Number(r.accuracy), 0) /
            submittedRoster.length) *
            10
        ) / 10
      : 0;
  const topScore =
    submittedRoster.length > 0
      ? Math.max(...submittedRoster.map((r) => r.score))
      : 0;
  const focusAlertsCount = roster.filter((r) => r.tab_switches > 0).length;

  // Mint scoped HS256 Realtime JWT (strictly restricted to school_udise + exam_id)
  let realtime: { token: string; expiresAt: string; enabled: boolean } = {
    token: "",
    expiresAt: "",
    enabled: false,
  };

  if (isRealtimeJwtConfigured()) {
    try {
      const minted = mintRealtimeExamJwt({
        schoolUdise: session.schoolUdise,
        examId: exam.id,
        teacherId: session.principalId,
      });
      realtime = {
        token: minted.token,
        expiresAt: minted.expiresAt,
        enabled: true,
      };
    } catch {
      realtime = { token: "", expiresAt: "", enabled: false };
    }
  }

  return jsonNoStore({
    ok: true,
    serverNowIso: new Date().toISOString(),
    exam: {
      id: exam.id,
      title: exam.title,
      examMode: exam.exam_mode,
      scopeType: exam.scope_type,
      classNum: exam.class_num,
      stream: exam.stream,
      subjectId: exam.subject_id,
      subject: subject
        ? {
            id: subject.id,
            nameHi: subject.name_hi,
            nameEn: subject.name_en,
            accentColor: subject.accent_color,
          }
        : null,
      roomPin: exam.room_pin,
      durationMins: exam.duration_mins,
      startsAt: exam.starts_at,
      endsAt: exam.ends_at,
      endedAt: exam.ended_at,
      showSolutionsPolicy: exam.show_solutions_policy,
      status: exam.status,
      questionCount: snapshot.length,
      maxMarks,
      schoolUdise: exam.school_udise,
      schoolName: session.schoolName,
    },
    summary: {
      joinedCount,
      waitingCount,
      inProgressCount,
      submittedCount,
      avgScore,
      avgAccuracy,
      topScore,
      maxMarks,
      focusAlertsCount,
    },
    roster: roster.map((r) => ({
      studentId: r.student_id,
      studentName: r.student_name,
      rollNo: r.roll_no,
      status: r.status,
      answeredCount: r.answered_count,
      totalQuestions: r.total_questions,
      score: r.score,
      accuracy: Number(r.accuracy),
      tabSwitches: r.tab_switches,
      updatedAt: r.updated_at,
    })),
    questionAnalytics,
    realtime,
  });
}
