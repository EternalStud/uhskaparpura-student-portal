import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { StudentOnboardingClient } from "@/components/student/StudentOnboardingClient";

export const dynamic = "force-dynamic";

export default async function StudentOnboardingPage() {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }

  return (
    <StudentOnboardingClient
      studentName={session.student.studentName}
      classNum={session.student.classNum}
      schoolName={session.schoolName}
    />
  );
}
