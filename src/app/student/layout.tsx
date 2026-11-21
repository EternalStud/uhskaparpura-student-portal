import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { StudentShell } from "@/components/student/StudentShell";

export const dynamic = "force-dynamic";

export default async function StudentLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await getSession();

  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }

  return (
    <StudentShell
      studentName={session.student.studentName}
      classNum={session.student.classNum}
      rollNo={session.student.rollNo}
      stream={session.student.stream}
      schoolName={session.schoolName}
    >
      {children}
    </StudentShell>
  );
}
