import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  generateExamRoomPin,
  jsonNoStore,
  requireRole,
  validateCsrf,
} from "@/lib/auth";
import { sanitizePlainText } from "@/lib/sanitize/content";
import {
  getStudentAccessibleSubjectIds,
  resolveCanonicalSubjectId,
} from "@/app/api/student/_helpers";
import {
  areSolutionsUnlockedForStudent,
  buildExamQuestionsSnapshot,
  finalizeExamAttempt,
  gradeAttemptAgainstSnapshot,
} from "@/app/api/exams/_engine";

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const patchExamSchema = z.object({
  action: z
    .enum(["OPEN_LOBBY", "START_EXAM", "END_EXAM", "UPDATE_DRAFT", "UPDATE_POLICY"])
    .optional(),
  title: z.string().trim().min(2).max(160).optional(),
  durationMins: z.number().int().min(5).max(180).optional(),
  startsAt: z.string().datetime({ offset: true }).nullable().optional(),
  endsAt: z.string().datetime({ offset: true }).nullable().optional(),
  showSolutionsPolicy: z
    .enum(["AFTER_EXAM_ENDS", "IMMEDIATE_ON_SUBMIT", "TEACHER_ONLY"])
    .optional(),
  shuffleQuestions: z.boolean().optional(),
  shuffleOptions: z.boolean().optional(),
  questionIds: z.array(z.string().uuid()).max(100).optional(),
});

export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const auth = await requireRole(["student", "teacher", "school_admin"], request);
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
    return jsonNoStore({ error: "Exam not found." }, { status: 404 });
  }

  const { data: subject } = await supabase
    .from("subjects")
    .select("id, class_num, name_hi, name_en, accent_color")
    .eq("id", exam.subject_id)
    .maybeSingle();

  // STUDENT VIEW — STRICT ANTI-CHEAT
  if (session.role === "student" && session.student) {
    if (exam.status === "DRAFT") {
      return jsonNoStore({ error: "Exam is not available." }, { status: 404 });
    }
    const [accessible, examCanonical] = await Promise.all([
      getStudentAccessibleSubjectIds(session.principalId, session.student.academicYear),
      resolveCanonicalSubjectId(exam.subject_id),
    ]);
    const streamOk =
      exam.stream === "ALL" ||
      exam.stream === "NA" ||
      exam.stream === session.student.stream;

    const subjectOk =
      accessible.includes(exam.subject_id) || accessible.includes(examCanonical);

    if (
      exam.class_num !== session.student.classNum ||
      !streamOk ||
      !subjectOk
    ) {
      return jsonNoStore({ error: "You are not enrolled in this exam's class/subject." }, { status: 403 });
    }

    const { data: attempt } = await supabase
      .from("exam_attempts")
      .select("*")
      .eq("exam_id", exam.id)
      .eq("student_id", session.principalId)
      .maybeSingle();

    const solutionsUnlocked =
      attempt?.status === "SUBMITTED" && areSolutionsUnlockedForStudent(exam);
    const gradedSolutions =
      solutionsUnlocked && attempt
        ? gradeAttemptAgainstSnapshot(exam.questions_snapshot ?? [], attempt.answers_json ?? {})
            .solutions
        : null;

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
        durationMins: exam.duration_mins,
        startsAt: exam.starts_at,
        endsAt: exam.ends_at,
        endedAt: exam.ended_at,
        status: exam.status,
        showSolutionsPolicy: exam.show_solutions_policy,
        solutionsUnlocked,
        questionCount: Array.isArray(exam.questions_snapshot)
          ? exam.questions_snapshot.length
          : 0,
      },
      myAttempt: attempt
        ? {
            id: attempt.id,
            status: attempt.status,
            answeredCount: attempt.answered_count,
            score: attempt.score,
            totalQuestions: attempt.total_questions,
            accuracy: Number(attempt.accuracy),
            timeTakenSeconds: attempt.time_taken_seconds,
            startedAt: attempt.started_at,
            submittedAt: attempt.submitted_at,
          }
        : null,
      solutions: gradedSolutions,
    });
  }

  // TEACHER / SCHOOL ADMIN VIEW
  return jsonNoStore({
    ok: true,
    exam: {
      ...exam,
      subject: subject ?? null,
      questionCount: Array.isArray(exam.questions_snapshot)
        ? exam.questions_snapshot.length
        : 0,
    },
  });
}

export async function PATCH(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

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

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid JSON payload." }, { status: 400 });
  }

  const parsed = patchExamSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: "Invalid exam update request." }, { status: 400 });
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

  const isOwner = exam.created_by_teacher === session.principalId;
  const isSchoolAdmin = session.teacher?.isSchoolAdmin === true;
  if (!isOwner && !isSchoolAdmin) {
    return jsonNoStore(
      { error: "Only the creating teacher or school admin can manage this exam." },
      { status: 403 }
    );
  }

  const input = parsed.data;
  const action = input.action;

  // 1. Update solution policy (permitted in ANY status)
  if (action === "UPDATE_POLICY" || (!action && input.showSolutionsPolicy && exam.status !== "DRAFT")) {
    if (!input.showSolutionsPolicy) {
      return jsonNoStore({ error: "showSolutionsPolicy is required." }, { status: 400 });
    }
    const { data: updated, error } = await supabase
      .from("exams")
      .update({ show_solutions_policy: input.showSolutionsPolicy })
      .eq("id", exam.id)
      .eq("school_udise", session.schoolUdise)
      .select("id, status, show_solutions_policy")
      .single();

    if (error || !updated) {
      return jsonNoStore({ error: "Could not update solutions policy." }, { status: 500 });
    }
    return jsonNoStore({ ok: true, exam: updated });
  }

  // 2. Edit draft properties
  if (action === "UPDATE_DRAFT" || (!action && exam.status === "DRAFT")) {
    if (exam.status !== "DRAFT") {
      return jsonNoStore(
        { error: "Only DRAFT exams can be edited after creation." },
        { status: 409 }
      );
    }

    const updates: Partial<typeof exam> = {};
    if (input.title !== undefined) {
      const clean = sanitizePlainText(input.title, 160);
      if (clean.length < 2) {
        return jsonNoStore({ error: "Title must be at least 2 characters." }, { status: 400 });
      }
      updates.title = clean;
    }
    if (input.durationMins !== undefined) updates.duration_mins = input.durationMins;
    if (input.startsAt !== undefined) updates.starts_at = input.startsAt;
    if (input.endsAt !== undefined) updates.ends_at = input.endsAt;

    const effectiveStartsAt =
      input.startsAt !== undefined ? input.startsAt : exam.starts_at;
    const effectiveEndsAt = input.endsAt !== undefined ? input.endsAt : exam.ends_at;
    if (exam.exam_mode === "SCHEDULED" && effectiveStartsAt && effectiveEndsAt) {
      const sMs = new Date(effectiveStartsAt).getTime();
      const eMs = new Date(effectiveEndsAt).getTime();
      if (Number.isNaN(sMs) || Number.isNaN(eMs) || eMs <= sMs) {
        return jsonNoStore(
          { error: "End Time must be strictly after Start Time." },
          { status: 400 }
        );
      }
    }
    if (input.showSolutionsPolicy !== undefined) {
      updates.show_solutions_policy = input.showSolutionsPolicy;
    }
    if (input.shuffleQuestions !== undefined) updates.shuffle_questions = input.shuffleQuestions;
    if (input.shuffleOptions !== undefined) updates.shuffle_options = input.shuffleOptions;

    if (input.questionIds !== undefined) {
      const built = await buildExamQuestionsSnapshot({
        subjectId: exam.subject_id,
        questionIds: input.questionIds,
        existingCustomSnapshots: Array.isArray(exam.questions_snapshot)
          ? exam.questions_snapshot
          : [],
      });
      if (!built.ok) {
        return jsonNoStore({ error: built.error }, { status: 400 });
      }
      updates.question_ids = built.validBankIds;
      updates.questions_snapshot = built.snapshot;
    }

    const { data: updated, error } = await supabase
      .from("exams")
      .update(updates)
      .eq("id", exam.id)
      .eq("school_udise", session.schoolUdise)
      .select("*")
      .single();

    if (error || !updated) {
      return jsonNoStore({ error: "Could not update draft exam." }, { status: 500 });
    }
    return jsonNoStore({ ok: true, exam: updated });
  }

  // 3. Activate DRAFT -> LOBBY (for LIVE_PIN) or DRAFT -> ACTIVE (for SCHEDULED/LIVE_PIN)
  if (action === "OPEN_LOBBY" || (action === "START_EXAM" && exam.status === "DRAFT")) {
    if (exam.status !== "DRAFT") {
      return jsonNoStore(
        { error: `Exam is already in "${exam.status}" state.` },
        { status: 409 }
      );
    }

    // Freeze immutable snapshot fresh from bank + existing custom questions
    const built = await buildExamQuestionsSnapshot({
      subjectId: exam.subject_id,
      questionIds: exam.question_ids ?? [],
      existingCustomSnapshots: Array.isArray(exam.questions_snapshot)
        ? exam.questions_snapshot
        : [],
    });

    if (!built.ok) {
      return jsonNoStore({ error: built.error }, { status: 400 });
    }

    const targetStatus =
      action === "OPEN_LOBBY" && exam.exam_mode === "LIVE_PIN" ? "LOBBY" : "ACTIVE";
    const nowIso = new Date().toISOString();

    const maxPinRetries = exam.exam_mode === "LIVE_PIN" ? 12 : 1;
    for (let attempt = 0; attempt < maxPinRetries; attempt++) {
      const roomPin =
        exam.exam_mode === "LIVE_PIN"
          ? exam.room_pin || generateExamRoomPin()
          : null;

      const { data: activated, error } = await supabase
        .from("exams")
        .update({
          status: targetStatus,
          room_pin: roomPin,
          question_ids: built.validBankIds,
          questions_snapshot: built.snapshot,
          starts_at:
            targetStatus === "ACTIVE" && exam.exam_mode === "LIVE_PIN"
              ? nowIso
              : exam.starts_at,
        })
        .eq("id", exam.id)
        .eq("school_udise", session.schoolUdise)
        .eq("status", "DRAFT")
        .select("*")
        .single();

      if (!error && activated) {
        await supabase.from("audit_logs").insert({
          school_udise: session.schoolUdise,
          actor_role: session.role,
          actor_id: session.principalId,
          action: targetStatus === "LOBBY" ? "EXAM_LOBBY_OPENED" : "EXAM_ACTIVATED",
          target_type: "exam",
          target_id: exam.id,
          meta_json: {
            questionCount: built.snapshot.length,
            hasRoomPin: Boolean(roomPin),
          },
        });
        return jsonNoStore({ ok: true, exam: activated });
      }

      if (error?.code === "23505" && exam.exam_mode === "LIVE_PIN") {
        // Clear any stale pin and retry with fresh 6-digit PIN
        exam.room_pin = null;
        continue;
      }

      return jsonNoStore({ error: "Could not activate exam." }, { status: 500 });
    }

    return jsonNoStore(
      { error: "Unable to generate a unique 6-digit Room Code. Please retry." },
      { status: 503 }
    );
  }

  // 4. Transition LOBBY -> ACTIVE (starts timer simultaneously for all waiting students!)
  if (action === "START_EXAM") {
    if (exam.status !== "LOBBY") {
      return jsonNoStore(
        { error: `Cannot start exam from "${exam.status}" status.` },
        { status: 409 }
      );
    }

    const nowIso = new Date().toISOString();
    const { data: started, error } = await supabase
      .from("exams")
      .update({
        status: "ACTIVE",
        starts_at: nowIso,
      })
      .eq("id", exam.id)
      .eq("school_udise", session.schoolUdise)
      .eq("status", "LOBBY")
      .select("*")
      .single();

    if (error || !started) {
      return jsonNoStore({ error: "Could not start live exam." }, { status: 500 });
    }

    // Simultaneously move all waiting LOBBY students to IN_PROGRESS with server started_at
    await Promise.all([
      supabase
        .from("exam_attempts")
        .update({ status: "IN_PROGRESS", started_at: nowIso })
        .eq("exam_id", exam.id)
        .eq("school_udise", session.schoolUdise)
        .eq("status", "JOINED"),
      supabase
        .from("live_exam_roster")
        .update({ status: "IN_PROGRESS" })
        .eq("exam_id", exam.id)
        .eq("school_udise", session.schoolUdise)
        .eq("status", "JOINED"),
    ]);

    await supabase.from("audit_logs").insert({
      school_udise: session.schoolUdise,
      actor_role: session.role,
      actor_id: session.principalId,
      action: "EXAM_STARTED",
      target_type: "exam",
      target_id: exam.id,
      meta_json: { startedAt: nowIso },
    });

    return jsonNoStore({ ok: true, exam: started });
  }

  // 5. Transition LOBBY | ACTIVE -> ENDED (auto-grades all remaining in-progress attempts!)
  if (action === "END_EXAM") {
    if (exam.status === "ENDED") {
      return jsonNoStore({ ok: true, exam, alreadyEnded: true });
    }
    if (exam.status !== "LOBBY" && exam.status !== "ACTIVE") {
      return jsonNoStore(
        { error: "Only active or lobby exams can be ended." },
        { status: 409 }
      );
    }

    const endedAt = new Date().toISOString();
    const { data: endedExam, error } = await supabase
      .from("exams")
      .update({ status: "ENDED", ended_at: endedAt })
      .eq("id", exam.id)
      .eq("school_udise", session.schoolUdise)
      .select("*")
      .single();

    if (error || !endedExam) {
      return jsonNoStore({ error: "Could not end exam." }, { status: 500 });
    }

    // Auto-grade any remaining JOINED / IN_PROGRESS attempts from saved answers
    const { data: openAttempts } = await supabase
      .from("exam_attempts")
      .select("*")
      .eq("exam_id", exam.id)
      .eq("school_udise", session.schoolUdise)
      .in("status", ["JOINED", "IN_PROGRESS"]);

    if (openAttempts && openAttempts.length > 0) {
      const studentIds = openAttempts.map((a) => a.student_id);
      const { data: students } = await supabase
        .from("students")
        .select("id, student_name, roll_no")
        .in("id", studentIds);
      const stuMap = new Map((students ?? []).map((s) => [s.id, s]));

      await Promise.all(
        openAttempts.map((att) => {
          const stu = stuMap.get(att.student_id);
          return finalizeExamAttempt({
            exam: endedExam,
            attempt: att,
            studentName: stu?.student_name ?? "Student",
            rollNo: stu?.roll_no ?? 0,
          });
        })
      );
    }

    await supabase.from("audit_logs").insert({
      school_udise: session.schoolUdise,
      actor_role: session.role,
      actor_id: session.principalId,
      action: "EXAM_ENDED",
      target_type: "exam",
      target_id: exam.id,
      meta_json: {
        endedAt,
        autoFinalizedAttempts: openAttempts?.length ?? 0,
      },
    });

    return jsonNoStore({
      ok: true,
      exam: endedExam,
      autoFinalizedCount: openAttempts?.length ?? 0,
    });
  }

  return jsonNoStore({ error: "Unsupported exam action." }, { status: 400 });
}
