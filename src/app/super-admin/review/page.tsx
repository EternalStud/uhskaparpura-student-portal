import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { ReviewWorkbenchClient } from "@/components/admin/super/ReviewWorkbenchClient";

export const dynamic = "force-dynamic";

export default async function SuperAdminReviewPage() {
  const session = await getSession();
  if (!session || session.role !== "super_admin") {
    redirect("/super-admin/login");
  }
  return <ReviewWorkbenchClient />;
}
