import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole, validateCsrf } from "@/lib/auth";
import { sanitizePlainText } from "@/lib/sanitize/content";
import { getIstDayBoundsUtc } from "@/lib/time/ist";
import {
  expandSubjectIdsWithAliases,
  getStudentAccessibleSubjectIds,
  resolveCanonicalSubjectId,
} from "@/app/api/student/_helpers";
import {
  loadSafeMediaMap,
  verifyOwnedSchoolMedia,
} from "@/app/api/collab/_helpers";
import type { ClassNum, DoubtStatus } from "@/types/database";

/**
 * GET / POST /api/collab/doubts
 * 100% Open School + Class + Subject Doubt Board (STRICTLY ZERO private DMs).
 * - Students see all non-hidden doubts in their school + class + enrolled subjects.
 * - Teachers see `scope=my` (their assigned subjects) OR `scope=all` ("All School Doubts — Help Out").
 * - POST (Student only): rate-limited 5 doubts/IST day, validates subject enrollment.
 */

const STUDENT_DAILY_DOUBT_LIMIT = 5;

const createDoubtSchema = z.object({
  subjectId: z.string().trim().min(2).max(80),
  chapterId: z.string().trim().min(2).max(100).nullable().optional(),
  questionText: z.string().trim().min(5).max(2000),
  mediaObjectId: z.string().uuid().nullable().optional(),
});

export async function GET(request: Request) {
  const auth = await requireRole(["student", "teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
  }

  const url = new URL(request.url);
  const scope = url.searchParams.get("scope") === "all" ? "all" : "my";
  const subjectIdFilter = url.searchParams.get("subjectId")?.trim() || null;
  const chapterIdFilter = url.searchParams.get("chapterId")?.trim() || null;
  const statusFilter = url.searchParams.get("status")?.trim() || null;
  const classNumParam = url.searchParams.get("classNum");
  const sortMode = url.searchParams.get("sort") || "priority";

  const supabase = getSupabaseAdmin();
  const schoolUdise = session.schoolUdise;

  let myUnansweredCount = 0;
  let allUnansweredCount = 0;

  let query = supabase
    .from("open_doubts")
    .select(
      "id, school_udise, academic_year, student_id, subject_id, chapter_id, class_num, question_text, media_object_id, status, is_pinned, upvote_count, created_at, updated_at"
    )
    .eq("school_udise", schoolUdise)
    .eq("is_hidden", false)
    .limit(120);

  let expandedAssignedSet = new Set<string>();

  if (session.role === "student" && session.student) {
    const accessibleIds = await getStudentAccessibleSubjectIds(
      session.principalId,
      session.student.academicYear
    );
    if (accessibleIds.length === 0) {
      return jsonNoStore({ ok: true, doubts: [], remainingToday: STUDENT_DAILY_DOUBT_LIMIT });
    }
    const expandedFilter = subjectIdFilter
      ? await expandSubjectIdsWithAliases([subjectIdFilter])
      : [];
    if (
      subjectIdFilter &&
      !expandedFilter.some((id) => accessibleIds.includes(id))
    ) {
      return jsonNoStore({ ok: true, doubts: [], remainingToday: STUDENT_DAILY_DOUBT_LIMIT });
    }
    query = query
      .eq("academic_year", session.student.academicYear)
      .eq("class_num", session.student.classNum)
      .in("subject_id", subjectIdFilter ? expandedFilter : accessibleIds);
  } else {
    // Teacher / School Admin: also compute open counts for My Subjects vs All School Doubts tabs
    const assignedIds = session.teacher?.assignedSubjectIds ?? [];
    const [expandedAssigned, { data: openSummary }] = await Promise.all([
      expandSubjectIdsWithAliases(assignedIds),
      supabase
        .from("open_doubts")
        .select("subject_id")
        .eq("school_udise", schoolUdise)
        .eq("is_hidden", false)
        .eq("status", "OPEN"),
    ]);

    expandedAssignedSet = new Set(expandedAssigned);
    allUnansweredCount = (openSummary ?? []).length;
    myUnansweredCount = (openSummary ?? []).filter((r) =>
      expandedAssignedSet.has(r.subject_id)
    ).length;

    if (scope === "my") {
      if (expandedAssigned.length === 0) {
        return jsonNoStore({
          ok: true,
          scope,
          doubts: [],
          counts: { myUnansweredCount, allUnansweredCount },
        });
      }
      query = query.in("subject_id", expandedAssigned);
    }

    if (subjectIdFilter) {
      const expandedFilter = await expandSubjectIdsWithAliases([subjectIdFilter]);
      query = query.in("subject_id", expandedFilter);
    }
    if (classNumParam && ["9", "10", "11", "12"].includes(classNumParam)) {
      query = query.eq("class_num", Number(classNumParam) as ClassNum);
    }
  }

  if (chapterIdFilter) {
    query = query.eq("chapter_id", chapterIdFilter);
  }
  if (statusFilter && ["OPEN", "ANSWERED", "RESOLVED"].includes(statusFilter)) {
    query = query.eq("status", statusFilter as DoubtStatus);
  }

  const { data: rows, error } = await query
    .order("is_pinned", { ascending: false })
    .order("created_at", { ascending: false });

  if (error) {
    return jsonNoStore({ error: "Unable to load open doubts." }, { status: 500 });
  }

  const doubts = [...(rows ?? [])];

  // Apply intelligent classroom sorting
  if (session.role !== "student" && sortMode === "priority") {
    // Teacher priority: pinned -> OPEN first -> highest Same Doubt (+1) -> oldest unanswered
    const statusWeight = (s: string) => (s === "OPEN" ? 0 : s === "ANSWERED" ? 1 : 2);
    doubts.sort((a, b) => {
      if (a.is_pinned !== b.is_pinned) return a.is_pinned ? -1 : 1;
      const sw = statusWeight(a.status) - statusWeight(b.status);
      if (sw !== 0) return sw;
      if (b.upvote_count !== a.upvote_count) return b.upvote_count - a.upvote_count;
      return new Date(a.created_at).getTime() - new Date(b.created_at).getTime();
    });
  } else if (sortMode === "upvotes") {
    doubts.sort((a, b) => {
      if (a.is_pinned !== b.is_pinned) return a.is_pinned ? -1 : 1;
      if (b.upvote_count !== a.upvote_count) return b.upvote_count - a.upvote_count;
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
    });
  } else {
    doubts.sort((a, b) => {
      if (a.is_pinned !== b.is_pinned) return a.is_pinned ? -1 : 1;
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
    });
  }

  const doubtIds = doubts.map((d) => d.id);
  const studentIds = Array.from(new Set(doubts.map((d) => d.student_id)));
  const subjectIds = Array.from(new Set(doubts.map((d) => d.subject_id)));
  const chapterIds = Array.from(
    new Set(doubts.map((d) => d.chapter_id).filter((v): v is string => Boolean(v)))
  );

  // Load answers, students, subjects, chapters, and student's own upvotes
  const [answersRes, studentsRes, subjectsRes, chaptersRes, myUpvotesRes, todayCountRes] =
    await Promise.all([
      doubtIds.length > 0
        ? supabase
            .from("doubt_answers")
            .select("id, doubt_id, teacher_id, answer_text, media_object_id, created_at")
            .in("doubt_id", doubtIds)
            .eq("is_hidden", false)
            .order("created_at", { ascending: true })
        : Promise.resolve({ data: [] }),
      studentIds.length > 0
        ? supabase
            .from("students")
            .select("id, student_name, class_num, roll_no, section")
            .in("id", studentIds)
        : Promise.resolve({ data: [] }),
      subjectIds.length > 0
        ? supabase
            .from("subjects")
            .select("id, class_num, name_hi, name_en, accent_color")
            .in("id", subjectIds)
        : Promise.resolve({ data: [] }),
      chapterIds.length > 0
        ? supabase
            .from("chapters")
            .select("id, chapter_no, title_hi, title_en")
            .in("id", chapterIds)
        : Promise.resolve({ data: [] }),
      session.role === "student" && doubtIds.length > 0
        ? supabase
            .from("doubt_upvotes")
            .select("doubt_id")
            .eq("student_id", session.principalId)
            .in("doubt_id", doubtIds)
        : Promise.resolve({ data: [] }),
      session.role === "student"
        ? (() => {
            const { startIso, endIso } = getIstDayBoundsUtc();
            return supabase
              .from("open_doubts")
              .select("id", { count: "exact", head: true })
              .eq("student_id", session.principalId)
              .gte("created_at", startIso)
              .lte("created_at", endIso);
          })()
        : Promise.resolve({ count: 0 }),
    ]);

  const answerRows = answersRes.data ?? [];
  const answerTeacherIds = Array.from(new Set(answerRows.map((a) => a.teacher_id)));
  const allMediaIds = [
    ...doubts.map((d) => d.media_object_id).filter((v): v is string => Boolean(v)),
    ...answerRows.map((a) => a.media_object_id).filter((v): v is string => Boolean(v)),
  ];

  const [teachersRes, mediaMap] = await Promise.all([
    answerTeacherIds.length > 0
      ? supabase
          .from("teachers")
          .select("id, full_name, teacher_title")
          .in("id", answerTeacherIds)
      : Promise.resolve({ data: [] }),
    loadSafeMediaMap(allMediaIds, schoolUdise),
  ]);

  const studentMap = new Map((studentsRes.data ?? []).map((s) => [s.id, s]));
  const subjectMap = new Map((subjectsRes.data ?? []).map((s) => [s.id, s]));
  const chapterMap = new Map((chaptersRes.data ?? []).map((c) => [c.id, c]));
  const teacherMap = new Map((teachersRes.data ?? []).map((t) => [t.id, t]));
  const upvotedSet = new Set((myUpvotesRes.data ?? []).map((u) => u.doubt_id));

  const answersByDoubt = new Map<
    string,
    Array<{
      id: string;
      answerText: string;
      createdAt: string;
      teacher: { id: string; fullName: string; teacherTitle: string | null };
      media: ReturnType<typeof mediaMap.get> | null;
    }>
  >();

  for (const ans of answerRows) {
    const teacher = teacherMap.get(ans.teacher_id);
    const list = answersByDoubt.get(ans.doubt_id) ?? [];
    list.push({
      id: ans.id,
      answerText: ans.answer_text,
      createdAt: ans.created_at,
      teacher: {
        id: ans.teacher_id,
        fullName: teacher?.full_name ?? "Verified Teacher",
        teacherTitle: teacher?.teacher_title ?? null,
      },
      media: ans.media_object_id ? mediaMap.get(ans.media_object_id) ?? null : null,
    });
    answersByDoubt.set(ans.doubt_id, list);
  }

  const assignedSubjectSet =
    expandedAssignedSet.size > 0
      ? expandedAssignedSet
      : new Set(session.teacher?.assignedSubjectIds ?? []);

  return jsonNoStore({
    ok: true,
    scope: session.role === "student" ? "student" : scope,
    ...(session.role === "student"
      ? {
          remainingToday: Math.max(
            0,
            STUDENT_DAILY_DOUBT_LIMIT - (todayCountRes.count ?? 0)
          ),
          dailyLimit: STUDENT_DAILY_DOUBT_LIMIT,
        }
      : {
          counts: { myUnansweredCount, allUnansweredCount },
        }),
    doubts: doubts.map((d) => {
      const stu = studentMap.get(d.student_id);
      const subj = subjectMap.get(d.subject_id);
      const chap = d.chapter_id ? chapterMap.get(d.chapter_id) : null;
      return {
        id: d.id,
        classNum: d.class_num,
        subjectId: d.subject_id,
        subject: subj
          ? {
              id: subj.id,
              classNum: subj.class_num,
              nameHi: subj.name_hi,
              nameEn: subj.name_en,
              accentColor: subj.accent_color,
            }
          : null,
        chapterId: d.chapter_id,
        chapter: chap
          ? {
              id: chap.id,
              chapterNo: chap.chapter_no,
              titleHi: chap.title_hi,
              titleEn: chap.title_en,
            }
          : null,
        student: {
          name: stu?.student_name ?? "Student",
          classNum: stu?.class_num ?? d.class_num,
          rollNo: stu?.roll_no ?? null,
          section: stu?.section ?? "A",
        },
        isOwnDoubt: session.role === "student" && d.student_id === session.principalId,
        inMySubjects:
          session.role !== "student" ? assignedSubjectSet.has(d.subject_id) : undefined,
        questionText: d.question_text,
        media: d.media_object_id ? mediaMap.get(d.media_object_id) ?? null : null,
        status: d.status,
        isPinned: d.is_pinned,
        upvoteCount: d.upvote_count,
        hasUpvoted: session.role === "student" ? upvotedSet.has(d.id) : false,
        answers: answersByDoubt.get(d.id) ?? [],
        createdAt: d.created_at,
        updatedAt: d.updated_at,
      };
    }),
  });
}

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  // Strictly Students ONLY ask doubts on the Open Doubt Board
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

  const parsed = createDoubtSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please select a subject and write your question (at least 5 characters).",
        errorHi: "कृपया विषय चुनें और अपना प्रश्न कम से कम 5 अक्षरों में लिखें।",
      },
      { status: 400 }
    );
  }

  const cleanQuestion = sanitizePlainText(parsed.data.questionText, 2000);
  if (cleanQuestion.length < 5) {
    return jsonNoStore(
      {
        error: "Please write a clearer question (at least 5 characters).",
        errorHi: "कृपया कम से कम 5 अक्षरों में स्पष्ट प्रश्न लिखें।",
      },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();
  const { startIso, endIso } = getIstDayBoundsUtc();

  // Check IST daily rate limit (max 5 doubts/day/student) + accessible subjects in parallel
  const [{ count: askedToday, error: limitErr }, accessibleSubjectIds] = await Promise.all([
    supabase
      .from("open_doubts")
      .select("id", { count: "exact", head: true })
      .eq("student_id", session.principalId)
      .gte("created_at", startIso)
      .lte("created_at", endIso),
    getStudentAccessibleSubjectIds(session.principalId, session.student.academicYear),
  ]);

  if (limitErr) {
    return jsonNoStore({ error: "Could not verify daily question quota." }, { status: 500 });
  }

  if ((askedToday ?? 0) >= STUDENT_DAILY_DOUBT_LIMIT) {
    return jsonNoStore(
      {
        error: `You can post up to ${STUDENT_DAILY_DOUBT_LIMIT} questions per day. Check similar questions or tap "Same Doubt (+1)".`,
        errorHi: `आप एक दिन में अधिकतम ${STUDENT_DAILY_DOUBT_LIMIT} प्रश्न पूछ सकते हैं। कृपया पहले से पूछे गए प्रश्नों पर "मेरा भी यही प्रश्न (+1)" दबाएँ।`,
      },
      { status: 429 }
    );
  }

  if (!accessibleSubjectIds.includes(parsed.data.subjectId)) {
    return jsonNoStore(
      {
        error: "You can only post questions in your enrolled subjects.",
        errorHi: "आप केवल अपने चुने हुए विषयों में ही प्रश्न पूछ सकते हैं।",
      },
      { status: 403 }
    );
  }

  if (parsed.data.chapterId) {
    const [{ data: chap }, canonicalSubjectId] = await Promise.all([
      supabase
        .from("chapters")
        .select("id, subject_id")
        .eq("id", parsed.data.chapterId)
        .maybeSingle(),
      resolveCanonicalSubjectId(parsed.data.subjectId),
    ]);
    if (
      !chap ||
      (chap.subject_id !== parsed.data.subjectId && chap.subject_id !== canonicalSubjectId)
    ) {
      return jsonNoStore(
        { error: "Selected chapter does not belong to this subject." },
        { status: 400 }
      );
    }
  }

  let verifiedMediaId: string | null = null;
  if (parsed.data.mediaObjectId) {
    const mediaCheck = await verifyOwnedSchoolMedia({
      mediaObjectId: parsed.data.mediaObjectId,
      schoolUdise: session.schoolUdise,
      ownerId: session.principalId,
      expectedScope: "SCHOOL_PRIVATE",
      allowedKind: "IMAGE",
    });
    if (!mediaCheck.ok) {
      return jsonNoStore(
        { error: mediaCheck.error, errorHi: mediaCheck.errorHi },
        { status: 400 }
      );
    }
    verifiedMediaId = mediaCheck.media.id;
  }

  const { data: created, error: insertErr } = await supabase
    .from("open_doubts")
    .insert({
      school_udise: session.schoolUdise,
      academic_year: session.student.academicYear,
      student_id: session.principalId,
      subject_id: parsed.data.subjectId,
      chapter_id: parsed.data.chapterId ?? null,
      class_num: session.student.classNum,
      question_text: cleanQuestion,
      media_object_id: verifiedMediaId,
      status: "OPEN",
      upvote_count: 1,
    })
    .select("id, subject_id, chapter_id, class_num, question_text, status, upvote_count, created_at")
    .single();

  if (insertErr || !created) {
    return jsonNoStore(
      {
        error: "Unable to post your question right now.",
        errorHi: "आपका प्रश्न पोस्ट नहीं हो सका। कृपया पुनः प्रयास करें।",
      },
      { status: 500 }
    );
  }

  // Record initial upvote from asking student so doubt_upvotes count stays authoritative
  await supabase.from("doubt_upvotes").insert({
    doubt_id: created.id,
    student_id: session.principalId,
  });

  return jsonNoStore(
    {
      ok: true,
      doubt: created,
      remainingToday: Math.max(0, STUDENT_DAILY_DOUBT_LIMIT - ((askedToday ?? 0) + 1)),
    },
    { status: 201 }
  );
}
