import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { SuperAdminOverviewClient } from "@/components/admin/super/SuperAdminOverviewClient";

export const dynamic = "force-dynamic";

export default async function SuperAdminDashboardPage() {
  const session = await getSession();
  if (!session || session.role !== "super_admin") {
    redirect("/super-admin/login");
  }
  return <SuperAdminOverviewClient />;
}
