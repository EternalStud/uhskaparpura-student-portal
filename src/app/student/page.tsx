import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { StudentHomeClient } from "@/components/student/StudentHomeClient";

export const dynamic = "force-dynamic";

export default async function StudentHomePage() {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }

  if (!session.student.subjectsConfigured) {
    redirect("/student/onboarding");
  }

  return <StudentHomeClient />;
}
