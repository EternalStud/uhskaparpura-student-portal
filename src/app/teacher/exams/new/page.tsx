import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { NewExamBuilderClient } from "@/components/teacher/NewExamBuilderClient";

export const dynamic = "force-dynamic";

export default async function TeacherNewExamPage() {
  await requireConfiguredTeacher();
  return <NewExamBuilderClient />;
}
