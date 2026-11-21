import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { StudentExamsClient } from "@/components/student/StudentExamsClient";

export const dynamic = "force-dynamic";

export default async function StudentExamsPage() {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }
  if (!session.student.subjectsConfigured) {
    redirect("/student/onboarding");
  }

  return <StudentExamsClient />;
}
