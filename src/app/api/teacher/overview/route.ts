import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole } from "@/lib/auth";

/**
 * GET /api/teacher/overview
 * Executive overview metrics for the Teacher Educator Studio home page.
 */
export async function GET(request: Request) {
  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise || !session.teacher) {
    return jsonNoStore({ error: "School teacher context required." }, { status: 403 });
  }

  const supabase = getSupabaseAdmin();
  const schoolUdise = session.schoolUdise;
  const assignedSubjectIds = session.teacher.assignedSubjectIds;

  const [
    allOpenDoubtsRes,
    examsRes,
    materialsCountRes,
    submissionsCountRes,
    assignedSubjectsRes,
  ] = await Promise.all([
    supabase
      .from("open_doubts")
      .select("id, student_id, subject_id, class_num, question_text, upvote_count, created_at, status")
      .eq("school_udise", schoolUdise)
      .eq("is_hidden", false)
      .eq("status", "OPEN")
      .order("upvote_count", { ascending: false })
      .order("created_at", { ascending: true })
      .limit(50),
    supabase
      .from("exams")
      .select(
        "id, title, exam_mode, scope_type, class_num, subject_id, room_pin, duration_mins, starts_at, ends_at, status, created_at, questions_snapshot"
      )
      .eq("school_udise", schoolUdise)
      .in("status", ["LOBBY", "ACTIVE", "DRAFT"])
      .order("created_at", { ascending: false })
      .limit(8),
    supabase
      .from("teacher_materials")
      .select("id", { count: "exact", head: true })
      .eq("school_udise", schoolUdise)
      .eq("teacher_id", session.principalId)
      .eq("is_deleted", false),
    supabase
      .from("question_submissions")
      .select("id", { count: "exact", head: true })
      .eq("school_udise", schoolUdise)
      .eq("teacher_id", session.principalId),
    assignedSubjectIds.length > 0
      ? supabase
          .from("subjects")
          .select("id, class_num, name_hi, name_en, accent_color")
          .in("id", assignedSubjectIds)
          .order("class_num", { ascending: true })
          .order("sort_order", { ascending: true })
      : Promise.resolve({ data: [] }),
  ]);

  const openDoubts = allOpenDoubtsRes.data ?? [];
  const assignedSet = new Set(assignedSubjectIds);
  const myOpenDoubts = openDoubts.filter((d) => assignedSet.has(d.subject_id));
  const priorityDoubts = (myOpenDoubts.length > 0 ? myOpenDoubts : openDoubts).slice(0, 5);

  // Hydrate student names & subject titles for priority doubts and exams
  const studentIds = Array.from(new Set(priorityDoubts.map((d) => d.student_id)));
  const subjectIdsToFetch = Array.from(
    new Set([
      ...priorityDoubts.map((d) => d.subject_id),
      ...(examsRes.data ?? []).map((e) => e.subject_id),
    ])
  );

  const [studentsRes, subjectsRes, lessonPlanCountRes] = await Promise.all([
    studentIds.length > 0
      ? supabase
          .from("students")
          .select("id, student_name, roll_no, class_num")
          .in("id", studentIds)
      : Promise.resolve({ data: [] }),
    subjectIdsToFetch.length > 0
      ? supabase
          .from("subjects")
          .select("id, class_num, name_hi, name_en")
          .in("id", subjectIdsToFetch)
      : Promise.resolve({ data: [] }),
    supabase.from("lesson_plans").select("id", { count: "exact", head: true }),
  ]);

  const studentMap = new Map((studentsRes.data ?? []).map((s) => [s.id, s]));
  const subjectMap = new Map((subjectsRes.data ?? []).map((s) => [s.id, s]));

  return jsonNoStore({
    ok: true,
    teacher: {
      fullName: session.teacher.fullName,
      teacherTitle: session.teacher.teacherTitle,
      schoolName: session.schoolName,
      assignedClasses: session.teacher.assignedClasses,
      assignedSubjects: assignedSubjectsRes.data ?? [],
    },
    stats: {
      myOpenDoubtsCount: myOpenDoubts.length,
      allSchoolOpenDoubtsCount: openDoubts.length,
      activeExamsCount: (examsRes.data ?? []).filter(
        (e) => e.status === "ACTIVE" || e.status === "LOBBY"
      ).length,
      publishedMaterialsCount: materialsCountRes.count ?? 0,
      submittedPapersCount: submissionsCountRes.count ?? 0,
      availableLessonPlansCount: lessonPlanCountRes.count ?? 0,
    },
    priorityDoubts: priorityDoubts.map((d) => {
      const stu = studentMap.get(d.student_id);
      const subj = subjectMap.get(d.subject_id);
      return {
        id: d.id,
        classNum: d.class_num,
        questionText: d.question_text,
        upvoteCount: d.upvote_count,
        createdAt: d.created_at,
        inMySubjects: assignedSet.has(d.subject_id),
        studentName: stu?.student_name ?? "Student",
        studentRollNo: stu?.roll_no ?? null,
        subjectNameHi: subj?.name_hi ?? "",
        subjectNameEn: subj?.name_en ?? "",
      };
    }),
    recentExams: (examsRes.data ?? []).map((e) => {
      const subj = subjectMap.get(e.subject_id);
      return {
        id: e.id,
        title: e.title,
        examMode: e.exam_mode,
        scopeType: e.scope_type,
        classNum: e.class_num,
        roomPin: e.room_pin,
        durationMins: e.duration_mins,
        startsAt: e.starts_at,
        endsAt: e.ends_at,
        status: e.status,
        questionCount: Array.isArray(e.questions_snapshot) ? e.questions_snapshot.length : 0,
        subjectNameHi: subj?.name_hi ?? "",
        subjectNameEn: subj?.name_en ?? "",
      };
    }),
  });
}
