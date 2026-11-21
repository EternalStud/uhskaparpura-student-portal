import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { ContributePaperClient } from "@/components/teacher/ContributePaperClient";

export const dynamic = "force-dynamic";

export default async function TeacherContributePage() {
  await requireConfiguredTeacher();
  return <ContributePaperClient />;
}
