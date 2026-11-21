import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { OnboardWizardClient } from "@/components/admin/super/OnboardWizardClient";

export const dynamic = "force-dynamic";

export default async function SuperAdminOnboardPage() {
  const session = await getSession();
  if (!session || session.role !== "super_admin") {
    redirect("/super-admin/login");
  }
  return <OnboardWizardClient />;
}
