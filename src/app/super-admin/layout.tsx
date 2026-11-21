import React from "react";
import { getSession } from "@/lib/auth/session";
import { SuperAdminShellWrapper } from "@/components/admin/super/SuperAdminShellWrapper";

export const dynamic = "force-dynamic";

/**
 * Shared layout for `/super-admin/*`.
 * Individual protected pages enforce `getSession()` + `role === 'super_admin'` redirects
 * on the server so `/super-admin/login` never triggers a redirect loop.
 */
export default async function SuperAdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await getSession();
  const isSuperAdmin = Boolean(session && session.role === "super_admin");

  return (
    <SuperAdminShellWrapper
      isAuthenticated={isSuperAdmin}
      userName={session?.superAdmin?.fullName || "Super Admin"}
      userEmail={session?.superAdmin?.email || ""}
    >
      {children}
    </SuperAdminShellWrapper>
  );
}
