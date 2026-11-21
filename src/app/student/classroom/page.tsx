import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { StudentClassroomClient } from "@/components/student/StudentClassroomClient";

export const dynamic = "force-dynamic";

export default async function StudentClassroomPage() {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }
  if (!session.student.subjectsConfigured) {
    redirect("/student/onboarding");
  }

  const supabase = getSupabaseAdmin();
  const { data: enrolled } = await supabase
    .from("student_subjects")
    .select("subject_id")
    .eq("student_id", session.principalId)
    .eq("academic_year", session.student.academicYear);

  const ids = (enrolled ?? []).map((e) => e.subject_id);
  const { data: subjects } =
    ids.length > 0
      ? await supabase
          .from("subjects")
          .select("id, name_hi, name_en, accent_color")
          .in("id", ids)
          .order("sort_order", { ascending: true })
      : { data: [] };

  return (
    <StudentClassroomClient
      enrolledSubjects={subjects ?? []}
      classNum={session.student.classNum}
      schoolName={session.schoolName ?? ""}
    />
  );
}
