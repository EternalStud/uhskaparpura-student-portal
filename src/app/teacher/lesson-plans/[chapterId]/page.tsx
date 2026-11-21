import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { LessonPlanDetailClient } from "@/components/teacher/LessonPlanDetailClient";

export const dynamic = "force-dynamic";

export default async function TeacherLessonPlanDetailPage({
  params,
}: {
  params: Promise<{ chapterId: string }>;
}) {
  await requireConfiguredTeacher();
  const { chapterId } = await params;
  return <LessonPlanDetailClient chapterId={chapterId} />;
}
