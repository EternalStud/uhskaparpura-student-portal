import React from "react";
import { requireConfiguredTeacher } from "@/app/teacher/_guard";
import { MaterialsStudioClient } from "@/components/teacher/MaterialsStudioClient";

export const dynamic = "force-dynamic";

export default async function TeacherMaterialsPage() {
  await requireConfiguredTeacher();
  return <MaterialsStudioClient />;
}
