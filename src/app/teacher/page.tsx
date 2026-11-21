import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { TeacherOverviewClient } from "@/components/teacher/TeacherOverviewClient";

export const dynamic = "force-dynamic";

export default async function TeacherHomePage() {
  await requireConfiguredTeacher();
  return <TeacherOverviewClient />;
}
