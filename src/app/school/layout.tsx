import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { SchoolShellWrapper } from "@/components/admin/school/SchoolShellWrapper";

export const dynamic = "force-dynamic";

export default async function SchoolAdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await getSession();
  if (!session) {
    redirect("/login/school");
  }

  const isSchoolAdmin =
    (session.role === "school_admin" ||
      (session.role === "teacher" && session.teacher?.isSchoolAdmin)) &&
    Boolean(session.schoolUdise);

  if (!isSchoolAdmin) {
    if (session.role === "teacher") redirect("/teacher");
    if (session.role === "student") redirect("/student");
    redirect("/login/school");
  }

  const userName = session.teacher?.fullName || "School Administrator";
  const userSubtitle = `UDISE: ${session.schoolUdise}`;
  const schoolName = session.schoolName || `School ${session.schoolUdise}`;

  return (
    <SchoolShellWrapper
      userName={userName}
      userSubtitle={userSubtitle}
      schoolName={schoolName}
    >
      {children}
    </SchoolShellWrapper>
  );
}
