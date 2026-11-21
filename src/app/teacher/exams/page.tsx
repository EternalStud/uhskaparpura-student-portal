import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { ExamsHubClient } from "@/components/teacher/ExamsHubClient";

export const dynamic = "force-dynamic";

export default async function TeacherExamsPage() {
  await requireConfiguredTeacher();
  return <ExamsHubClient />;
}
