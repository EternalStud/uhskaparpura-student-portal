import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { StudentExamRunnerClient } from "@/components/student/StudentExamRunnerClient";

export const dynamic = "force-dynamic";

export default async function StudentExamRunnerPage({
  params,
}: {
  params: Promise<{ examId: string }>;
}) {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }
  if (!session.student.subjectsConfigured) {
    redirect("/student/onboarding");
  }

  const { examId } = await params;
  return <StudentExamRunnerClient examId={examId} />;
}
