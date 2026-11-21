import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { LessonPlansClient } from "@/components/teacher/LessonPlansClient";

export const dynamic = "force-dynamic";

export default async function TeacherLessonPlansPage() {
  await requireConfiguredTeacher();
  return <LessonPlansClient />;
}
