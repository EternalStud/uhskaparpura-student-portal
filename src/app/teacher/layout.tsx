import React from "react";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { requireTeacherSession } from "@/app/teacher/_guard";
import { TeacherShell } from "@/components/teacher/TeacherShell";

export const dynamic = "force-dynamic";

export default async function TeacherLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await requireTeacherSession();

  let openDoubtsBadge = 0;
  try {
    const supabase = getSupabaseAdmin();
    let query = supabase
      .from("open_doubts")
      .select("id", { count: "exact", head: true })
      .eq("school_udise", session.schoolUdise)
      .eq("is_hidden", false)
      .eq("status", "OPEN");

    if (session.teacher.assignedSubjectIds.length > 0) {
      query = query.in("subject_id", session.teacher.assignedSubjectIds);
    }

    const { count } = await query;
    openDoubtsBadge = count ?? 0;
  } catch {
    openDoubtsBadge = 0;
  }

  return (
    <TeacherShell
      role={session.role}
      userName={session.teacher.fullName}
      userSubtitle={session.teacher.teacherTitle ?? session.teacher.teacherCode}
      schoolName={session.schoolName}
      canSwitchWorkspace={session.teacher.isSchoolAdmin}
      subjectsConfigured={session.teacher.subjectsConfigured}
      openDoubtsBadge={openDoubtsBadge}
    >
      {children}
    </TeacherShell>
  );
}
