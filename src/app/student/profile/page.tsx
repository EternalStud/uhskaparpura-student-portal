import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { StudentProfileClient } from "@/components/student/StudentProfileClient";

export const dynamic = "force-dynamic";

export default async function StudentProfilePage() {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }
  if (!session.student.subjectsConfigured) {
    redirect("/student/onboarding");
  }

  return <StudentProfileClient />;
}
