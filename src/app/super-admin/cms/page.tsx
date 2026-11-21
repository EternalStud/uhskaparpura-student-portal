import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { CurriculumCmsClient } from "@/components/admin/super/CurriculumCmsClient";

export const dynamic = "force-dynamic";

export default async function SuperAdminCmsPage() {
  const session = await getSession();
  if (!session || session.role !== "super_admin") {
    redirect("/super-admin/login");
  }
  return <CurriculumCmsClient />;
}
