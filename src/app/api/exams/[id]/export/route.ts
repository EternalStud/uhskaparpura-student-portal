import { NextResponse } from "next/server";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, noStoreHeaders, requireRole } from "@/lib/auth";
import { exportSafeMarksheetXlsx } from "@/lib/excel/eshikshakosh";
import { formatIstDateTime } from "@/lib/time/ist";

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function formatDuration(seconds: number): string {
  const safe = Math.max(0, Math.floor(seconds));
  const mins = Math.floor(safe / 60);
  const secs = safe % 60;
  return `${mins}m ${String(secs).padStart(2, "0")}s`;
}

/**
 * GET /api/exams/[id]/export
 * Exports a formula-injection-safe `.xlsx` exam marksheet for Bihar school records.
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
    .select(
      "id, school_udise, academic_year, created_by_teacher, title, exam_mode, class_num, stream, subject_id, duration_mins, status, questions_snapshot, created_at, ended_at"
    )
    .eq("id", id)
    .eq("school_udise", session.schoolUdise)
    .maybeSingle();

  if (!exam) {
    return jsonNoStore({ error: "Exam not found in your school." }, { status: 404 });
  }

  const canExport =
    exam.created_by_teacher === session.principalId ||
    session.teacher?.isSchoolAdmin === true ||
    (session.teacher?.assignedSubjectIds.includes(exam.subject_id) ?? false);

  if (!canExport) {
    return jsonNoStore(
      { error: "You do not have permission to export this marksheet." },
      { status: 403 }
    );
  }

  const [{ data: subject }, { data: attempts }] = await Promise.all([
    supabase
      .from("subjects")
      .select("name_en, name_hi")
      .eq("id", exam.subject_id)
      .maybeSingle(),
    supabase
      .from("exam_attempts")
      .select(
        "student_id, status, answered_count, score, total_questions, accuracy, tab_switches, time_taken_seconds, submitted_at"
      )
      .eq("exam_id", exam.id)
      .eq("school_udise", session.schoolUdise)
      .order("score", { ascending: false })
      .order("time_taken_seconds", { ascending: true }),
  ]);

  const attemptRows = attempts ?? [];
  const studentIds = attemptRows.map((a) => a.student_id);

  const { data: students } =
    studentIds.length > 0
      ? await supabase
          .from("students")
          .select("id, student_name, roll_no, section, class_num, stream")
          .in("id", studentIds)
      : { data: [] };

  const studentMap = new Map((students ?? []).map((s) => [s.id, s]));
  const snapshot = Array.isArray(exam.questions_snapshot) ? exam.questions_snapshot : [];
  const maxMarks = snapshot.reduce(
    (sum, q) => sum + (Number.isFinite(q.marks) && q.marks > 0 ? Math.floor(q.marks) : 1),
    0
  );

  // Rank submitted students by score DESC, time_taken ASC
  let rankCounter = 0;
  const rows = attemptRows.map((att) => {
    const stu = studentMap.get(att.student_id);
    const rank = att.status === "SUBMITTED" ? ++rankCounter : "-";
    return [
      rank,
      stu?.roll_no ?? "-",
      stu?.student_name ?? "Student",
      `Class ${stu?.class_num ?? exam.class_num}`,
      stu?.section ?? "A",
      att.status === "SUBMITTED"
        ? "Submitted"
        : att.status === "IN_PROGRESS"
        ? "In Progress"
        : "Joined",
      att.answered_count,
      att.total_questions || snapshot.length,
      att.score,
      maxMarks,
      Number(att.accuracy).toFixed(1),
      formatDuration(att.time_taken_seconds),
      att.tab_switches,
      att.submitted_at ? formatIstDateTime(att.submitted_at) : "-",
    ];
  });

  const subtitle = [
    session.schoolName ?? `UDISE ${exam.school_udise}`,
    `Class ${exam.class_num}`,
    subject ? subject.name_en : exam.subject_id,
    `Session ${exam.academic_year}`,
    `Exported ${formatIstDateTime(new Date())}`,
  ].join(" · ");

  const buffer = exportSafeMarksheetXlsx({
    sheetName: `Class ${exam.class_num} Marksheet`,
    title: `${exam.title} — Official Exam Marksheet`,
    subtitle,
    headers: [
      "Rank",
      "Roll No",
      "Student Name",
      "Class",
      "Section",
      "Status",
      "Answered",
      "Total Questions",
      "Score",
      "Max Marks",
      "Accuracy (%)",
      "Time Taken",
      "Focus Switches",
      "Submitted At (IST)",
    ],
    rows,
  });

  const safeSlug = exam.title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 48);
  const fileName = `marksheet-class${exam.class_num}-${safeSlug || exam.id.slice(0, 8)}.xlsx`;

  const headers = noStoreHeaders({
    "Content-Type":
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "Content-Disposition": `attachment; filename="${fileName}"`,
    "X-Content-Type-Options": "nosniff",
  });

  return new NextResponse(new Uint8Array(buffer), {
    status: 200,
    headers,
  });
}
