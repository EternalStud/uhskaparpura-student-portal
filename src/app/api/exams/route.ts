import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  generateExamRoomPin,
  jsonNoStore,
  requireRole,
  validateCsrf,
} from "@/lib/auth";
import { sanitizePlainText } from "@/lib/sanitize/content";
import { getCurrentAcademicYear } from "@/lib/time/ist";
import {
  getStudentAccessibleSubjectIds,
  resolveSubjectAliasMap,
} from "@/app/api/student/_helpers";
import {
  areSolutionsUnlockedForStudent,
  buildExamQuestionsSnapshot,
} from "@/app/api/exams/_engine";
import type { ClassNum, ExamMode, ExamStatus, ExamStream } from "@/types/database";

const customQuestionSchema = z.object({
  qHi: z.string().trim().min(3).max(2000),
  qEn: z.string().trim().max(2000).optional(),
  options: z
    .array(
      z.object({
        key: z.enum(["A", "B", "C", "D"]),
        textHi: z.string().trim().min(1).max(400),
        textEn: z.string().trim().max(400).optional(),
      })
    )
    .min(2)
    .max(4),
  correctOption: z.enum(["A", "B", "C", "D"]),
  explanationHi: z.string().trim().max(2000).optional(),
  explanationEn: z.string().trim().max(2000).optional(),
  difficultyTier: z.enum(["FOUNDATION", "BOARD", "TOPPER"]).optional(),
  marks: z.number().int().min(1).max(10).optional(),
});

const createExamSchema = z.object({
  title: z.string().trim().min(2).max(160),
  examMode: z.enum(["LIVE_PIN", "SCHEDULED"]),
  scopeType: z.enum(["TOPIC", "CHAPTER", "SUBJECT"]),
  subjectId: z.string().trim().min(2).max(80),
  classNum: z.union([z.literal(9), z.literal(10), z.literal(11), z.literal(12)]).optional(),
  stream: z.enum(["ALL", "NA", "Arts", "Science", "Commerce"]).optional(),
  chapterIds: z.array(z.string().trim().min(2).max(100)).max(30).default([]),
  durationMins: z.number().int().min(5).max(180),
  startsAt: z.string().datetime({ offset: true }).nullable().optional(),
  endsAt: z.string().datetime({ offset: true }).nullable().optional(),
  showSolutionsPolicy: z
    .enum(["AFTER_EXAM_ENDS", "IMMEDIATE_ON_SUBMIT", "TEACHER_ONLY"])
    .default("AFTER_EXAM_ENDS"),
  shuffleQuestions: z.boolean().default(true),
  shuffleOptions: z.boolean().default(true),
  questionIds: z.array(z.string().uuid()).max(100).default([]),
  customQuestions: z.array(customQuestionSchema).max(50).optional(),
  launchImmediately: z.boolean().optional(),
});

export async function GET(request: Request) {
  const auth = await requireRole(["student", "teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
  }

  const supabase = getSupabaseAdmin();
  const url = new URL(request.url);

  // =========================================================================
  // STUDENT VIEW — STRICTLY SANITIZED (NO answers, NO questions_snapshot, NO room_pin)
  // =========================================================================
  if (session.role === "student" && session.student) {
    const accessibleIds = await getStudentAccessibleSubjectIds(
      session.principalId,
      session.student.academicYear
    );

    if (accessibleIds.length === 0) {
      return jsonNoStore({ ok: true, exams: [] });
    }

    const { data: rawExams, error } = await supabase
      .from("exams")
      .select(
        "id, title, exam_mode, scope_type, class_num, stream, subject_id, chapter_ids, duration_mins, starts_at, ends_at, show_solutions_policy, questions_snapshot, status, created_at, ended_at"
      )
      .eq("school_udise", session.schoolUdise)
      .eq("class_num", session.student.classNum)
      .in("status", ["LOBBY", "ACTIVE", "ENDED"])
      .order("created_at", { ascending: false })
      .limit(60);

    if (error) {
      return jsonNoStore({ error: "Unable to load exams." }, { status: 500 });
    }

    const examSubjectIds = Array.from(new Set((rawExams ?? []).map((e) => e.subject_id)));
    const examAliasMap = await resolveSubjectAliasMap(examSubjectIds);
    const accessibleSet = new Set(accessibleIds);

    const studentStream = session.student.stream;
    const eligibleExams = (rawExams ?? []).filter((e) => {
      const canonical = examAliasMap.get(e.subject_id) ?? e.subject_id;
      if (!accessibleSet.has(e.subject_id) && !accessibleSet.has(canonical)) {
        return false;
      }
      if (e.stream === "ALL" || e.stream === "NA") return true;
      return e.stream === studentStream;
    });

    const examIds = eligibleExams.map((e) => e.id);
    const subjectIds = Array.from(new Set(eligibleExams.map((e) => e.subject_id)));

    const [attemptsRes, subjectsRes] = await Promise.all([
      examIds.length > 0
        ? supabase
            .from("exam_attempts")
            .select(
              "id, exam_id, status, answered_count, score, total_questions, accuracy, time_taken_seconds, started_at, submitted_at"
            )
            .eq("student_id", session.principalId)
            .in("exam_id", examIds)
        : Promise.resolve({ data: [] }),
      subjectIds.length > 0
        ? supabase
            .from("subjects")
            .select("id, class_num, name_hi, name_en, accent_color")
            .in("id", subjectIds)
        : Promise.resolve({ data: [] }),
    ]);

    const attemptByExam = new Map((attemptsRes.data ?? []).map((a) => [a.exam_id, a]));
    const subjectMap = new Map((subjectsRes.data ?? []).map((s) => [s.id, s]));

    return jsonNoStore({
      ok: true,
      serverNowIso: new Date().toISOString(),
      exams: eligibleExams.map((e) => {
        const att = attemptByExam.get(e.id) ?? null;
        const subj = subjectMap.get(e.subject_id);
        const questionCount = Array.isArray(e.questions_snapshot)
          ? e.questions_snapshot.length
          : 0;
        const solutionsUnlocked =
          att?.status === "SUBMITTED" && areSolutionsUnlockedForStudent(e);

        return {
          id: e.id,
          title: e.title,
          examMode: e.exam_mode,
          scopeType: e.scope_type,
          classNum: e.class_num,
          stream: e.stream,
          subjectId: e.subject_id,
          subject: subj
            ? {
                id: subj.id,
                nameHi: subj.name_hi,
                nameEn: subj.name_en,
                accentColor: subj.accent_color,
              }
            : null,
          durationMins: e.duration_mins,
          startsAt: e.starts_at,
          endsAt: e.ends_at,
          endedAt: e.ended_at,
          status: e.status,
          showSolutionsPolicy: e.show_solutions_policy,
          solutionsUnlocked,
          questionCount,
          myAttempt: att
            ? {
                id: att.id,
                status: att.status,
                answeredCount: att.answered_count,
                score: att.score,
                totalQuestions: att.total_questions,
                accuracy: Number(att.accuracy),
                timeTakenSeconds: att.time_taken_seconds,
                startedAt: att.started_at,
                submittedAt: att.submitted_at,
              }
            : null,
        };
      }),
    });
  }

  // =========================================================================
  // TEACHER / SCHOOL ADMIN VIEW
  // =========================================================================
  const statusFilter = url.searchParams.get("status")?.trim() || null;
  const modeFilter = url.searchParams.get("mode")?.trim() || null;
  const subjectFilter = url.searchParams.get("subjectId")?.trim() || null;
  const mineOnly = url.searchParams.get("mine") === "true";

  let query = supabase
    .from("exams")
    .select(
      "id, school_udise, academic_year, created_by_teacher, title, exam_mode, scope_type, class_num, stream, subject_id, chapter_ids, room_pin, duration_mins, starts_at, ends_at, show_solutions_policy, questions_snapshot, shuffle_questions, shuffle_options, status, created_at, ended_at"
    )
    .eq("school_udise", session.schoolUdise)
    .order("created_at", { ascending: false })
    .limit(100);

  if (statusFilter && ["DRAFT", "LOBBY", "ACTIVE", "ENDED"].includes(statusFilter)) {
    query = query.eq("status", statusFilter as ExamStatus);
  }
  if (modeFilter && ["LIVE_PIN", "SCHEDULED"].includes(modeFilter)) {
    query = query.eq("exam_mode", modeFilter as ExamMode);
  }
  if (subjectFilter) {
    query = query.eq("subject_id", subjectFilter);
  }
  if (mineOnly) {
    query = query.eq("created_by_teacher", session.principalId);
  }

  const { data: exams, error } = await query;
  if (error) {
    return jsonNoStore({ error: "Unable to load school exams." }, { status: 500 });
  }

  const examRows = exams ?? [];
  const examIds = examRows.map((e) => e.id);
  const subjectIds = Array.from(new Set(examRows.map((e) => e.subject_id)));
  const teacherIds = Array.from(new Set(examRows.map((e) => e.created_by_teacher)));

  const [subjectsRes, teachersRes, rosterRes] = await Promise.all([
    subjectIds.length > 0
      ? supabase
          .from("subjects")
          .select("id, class_num, name_hi, name_en, accent_color")
          .in("id", subjectIds)
      : Promise.resolve({ data: [] }),
    teacherIds.length > 0
      ? supabase
          .from("teachers")
          .select("id, full_name, teacher_title")
          .in("id", teacherIds)
      : Promise.resolve({ data: [] }),
    examIds.length > 0
      ? supabase
          .from("live_exam_roster")
          .select("exam_id, status, score, accuracy")
          .in("exam_id", examIds)
      : Promise.resolve({ data: [] }),
  ]);

  const subjectMap = new Map((subjectsRes.data ?? []).map((s) => [s.id, s]));
  const teacherMap = new Map((teachersRes.data ?? []).map((t) => [t.id, t]));

  const statsMap = new Map<
    string,
    { joined: number; inProgress: number; submitted: number; totalAccuracy: number }
  >();
  for (const r of rosterRes.data ?? []) {
    const cur = statsMap.get(r.exam_id) ?? {
      joined: 0,
      inProgress: 0,
      submitted: 0,
      totalAccuracy: 0,
    };
    cur.joined += 1;
    if (r.status === "IN_PROGRESS") cur.inProgress += 1;
    if (r.status === "SUBMITTED") {
      cur.submitted += 1;
      cur.totalAccuracy += Number(r.accuracy) || 0;
    }
    statsMap.set(r.exam_id, cur);
  }

  const isSchoolAdmin = session.teacher?.isSchoolAdmin === true;

  return jsonNoStore({
    ok: true,
    exams: examRows.map((e) => {
      const subj = subjectMap.get(e.subject_id);
      const creator = teacherMap.get(e.created_by_teacher);
      const st = statsMap.get(e.id) ?? {
        joined: 0,
        inProgress: 0,
        submitted: 0,
        totalAccuracy: 0,
      };
      return {
        id: e.id,
        title: e.title,
        examMode: e.exam_mode,
        scopeType: e.scope_type,
        classNum: e.class_num,
        stream: e.stream,
        subjectId: e.subject_id,
        subject: subj
          ? {
              id: subj.id,
              nameHi: subj.name_hi,
              nameEn: subj.name_en,
              accentColor: subj.accent_color,
            }
          : null,
        chapterIds: e.chapter_ids,
        roomPin: e.room_pin,
        durationMins: e.duration_mins,
        startsAt: e.starts_at,
        endsAt: e.ends_at,
        endedAt: e.ended_at,
        showSolutionsPolicy: e.show_solutions_policy,
        shuffleQuestions: e.shuffle_questions,
        shuffleOptions: e.shuffle_options,
        status: e.status,
        questionCount: Array.isArray(e.questions_snapshot)
          ? e.questions_snapshot.length
          : 0,
        creatorName: creator?.full_name ?? "Teacher",
        canManage: e.created_by_teacher === session.principalId || isSchoolAdmin,
        stats: {
          joinedCount: st.joined,
          inProgressCount: st.inProgress,
          submittedCount: st.submitted,
          avgAccuracy:
            st.submitted > 0 ? Math.round((st.totalAccuracy / st.submitted) * 10) / 10 : 0,
        },
        createdAt: e.created_at,
      };
    }),
  });
}

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid JSON payload." }, { status: 400 });
  }

  const parsed = createExamSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please check exam title, mode, duration (5–180 mins), and selected questions.",
        errorHi: "कृपया परीक्षा का शीर्षक, अवधि (5–180 मिनट) और प्रश्न सही से जाँचें।",
      },
      { status: 400 }
    );
  }

  const input = parsed.data;
  const cleanTitle = sanitizePlainText(input.title, 160);
  if (cleanTitle.length < 2) {
    return jsonNoStore({ error: "Exam title is too short." }, { status: 400 });
  }

  if (input.examMode === "SCHEDULED") {
    if (!input.startsAt || !input.endsAt) {
      return jsonNoStore(
        {
          error: "Scheduled exams require both Start Time and End Time.",
          errorHi: "निर्धारित परीक्षा के लिए प्रारंभ और समाप्ति समय दोनों आवश्यक हैं।",
        },
        { status: 400 }
      );
    }
    const startMs = new Date(input.startsAt).getTime();
    const endMs = new Date(input.endsAt).getTime();
    if (Number.isNaN(startMs) || Number.isNaN(endMs) || endMs <= startMs) {
      return jsonNoStore(
        {
          error: "End Time must be strictly after Start Time.",
          errorHi: "समाप्ति समय प्रारंभ समय के बाद का होना चाहिए।",
        },
        { status: 400 }
      );
    }
  }

  const supabase = getSupabaseAdmin();

  const { data: subject } = await supabase
    .from("subjects")
    .select("id, class_num, stream, syllabus_alias_of")
    .eq("id", input.subjectId)
    .maybeSingle();

  if (!subject) {
    return jsonNoStore({ error: "Selected subject was not found." }, { status: 400 });
  }

  // Resolve syllabus alias for chapter & question bank lookup (e.g., bseb-12-lang2-eng -> bseb-12-lang1-eng)
  const contentSubjectId = subject.syllabus_alias_of ?? subject.id;

  // Validate optional chapters belong to canonical subject
  let validChapterIds: string[] = [];
  if (input.chapterIds.length > 0) {
    const { data: chaps } = await supabase
      .from("chapters")
      .select("id")
      .eq("subject_id", contentSubjectId)
      .in("id", input.chapterIds);
    validChapterIds = (chaps ?? []).map((c) => c.id);
  }

  // Build snapshot from bank (both PRACTICE & EXAM_ONLY pools!) + custom MCQs
  const built = await buildExamQuestionsSnapshot({
    subjectId: contentSubjectId,
    questionIds: input.questionIds,
    customQuestions: input.customQuestions,
  });

  if (!built.ok) {
    return jsonNoStore({ error: built.error }, { status: 400 });
  }

  // For universal skills (class_num === 0), target the chosen classroom grade (9-12)
  const effectiveClassNum: ClassNum =
    subject.class_num === 0
      ? input.classNum ?? session.teacher?.assignedClasses?.[0] ?? 10
      : (subject.class_num as ClassNum);

  const derivedStream: ExamStream =
    effectiveClassNum === 9 || effectiveClassNum === 10
      ? "NA"
      : subject.stream === "ALL"
      ? input.stream ?? "ALL"
      : (subject.stream as ExamStream);

  const initialStatus = input.launchImmediately
    ? input.examMode === "LIVE_PIN"
      ? "LOBBY"
      : "ACTIVE"
    : "DRAFT";

  const academicYear = getCurrentAcademicYear();

  // Retry loop on unique school-scoped 6-digit Room PIN collision if launching LIVE_PIN immediately
  const maxAttempts = initialStatus === "LOBBY" ? 12 : 1;
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const roomPin =
      initialStatus === "LOBBY" && input.examMode === "LIVE_PIN"
        ? generateExamRoomPin()
        : null;

    const { data: created, error: insertErr } = await supabase
      .from("exams")
      .insert({
        school_udise: session.schoolUdise,
        academic_year: academicYear,
        created_by_teacher: session.principalId,
        title: cleanTitle,
        exam_mode: input.examMode,
        scope_type: input.scopeType,
        class_num: effectiveClassNum,
        stream: derivedStream,
        subject_id: subject.id,
        chapter_ids: validChapterIds,
        room_pin: roomPin,
        duration_mins: input.durationMins,
        starts_at: input.examMode === "SCHEDULED" ? input.startsAt ?? null : null,
        ends_at: input.examMode === "SCHEDULED" ? input.endsAt ?? null : null,
        show_solutions_policy: input.showSolutionsPolicy,
        question_ids: built.validBankIds,
        questions_snapshot: built.snapshot,
        shuffle_questions: input.shuffleQuestions,
        shuffle_options: input.shuffleOptions,
        status: initialStatus,
      })
      .select(
        "id, title, exam_mode, scope_type, class_num, stream, subject_id, room_pin, duration_mins, starts_at, ends_at, show_solutions_policy, status, created_at"
      )
      .single();

    if (!insertErr && created) {
      await supabase.from("audit_logs").insert({
        school_udise: session.schoolUdise,
        actor_role: session.role,
        actor_id: session.principalId,
        action: initialStatus === "DRAFT" ? "EXAM_CREATED_DRAFT" : "EXAM_LAUNCHED",
        target_type: "exam",
        target_id: created.id,
        meta_json: {
          examMode: created.exam_mode,
          status: created.status,
          questionCount: built.snapshot.length,
        },
      });

      return jsonNoStore(
        {
          ok: true,
          exam: {
            ...created,
            questionCount: built.snapshot.length,
          },
        },
        { status: 201 }
      );
    }

    if (insertErr?.code === "23505" && initialStatus === "LOBBY") {
      continue;
    }

    return jsonNoStore(
      {
        error: "Unable to create exam. Please try again.",
        errorHi: "परीक्षा बनाई नहीं जा सकी। कृपया पुनः प्रयास करें।",
      },
      { status: 500 }
    );
  }

  return jsonNoStore(
    { error: "Unable to allocate a unique classroom Room Code right now." },
    { status: 503 }
  );
}
