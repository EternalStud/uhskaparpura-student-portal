import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { LiveExamMonitorClient } from "@/components/teacher/LiveExamMonitorClient";

export const dynamic = "force-dynamic";

export default async function TeacherExamMonitorPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requireConfiguredTeacher();
  const { id } = await params;
  return <LiveExamMonitorClient examId={id} />;
}
