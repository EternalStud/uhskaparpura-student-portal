import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { DoubtDeskClient } from "@/components/teacher/DoubtDeskClient";

export const dynamic = "force-dynamic";

export default async function TeacherDoubtsPage() {
  await requireConfiguredTeacher();
  return <DoubtDeskClient />;
}
