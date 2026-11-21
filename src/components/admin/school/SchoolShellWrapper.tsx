"use client";

import React from "react";
import {
  LayoutDashboard,
  RefreshCw,
  Users,
  GraduationCap,
  ShieldAlert,
} from "lucide-react";
import { RoleShell, type RoleNavItem } from "@/components/layout/RoleShell";

export interface SchoolShellWrapperProps {
  userName: string;
  userSubtitle: string;
  schoolName: string;
  children: React.ReactNode;
}

export function SchoolShellWrapper({
  userName,
  userSubtitle,
  schoolName,
  children,
}: SchoolShellWrapperProps) {
  const navItems: RoleNavItem[] = [
    {
      href: "/school",
      labelHi: "सारांश",
      labelEn: "Overview",
      icon: <LayoutDashboard className="h-4 w-4" />,
      exact: true,
    },
    {
      href: "/school/sync",
      labelHi: "सूची अपडेट",
      labelEn: "Roster Sync",
      icon: <RefreshCw className="h-4 w-4" />,
    },
    {
      href: "/school/teachers",
      labelHi: "शिक्षक एवं विषय",
      labelEn: "Staff & Subjects",
      icon: <Users className="h-4 w-4" />,
    },
    {
      href: "/school/students",
      labelHi: "विद्यार्थी पंजी",
      labelEn: "Students",
      icon: <GraduationCap className="h-4 w-4" />,
    },
    {
      href: "/school/moderation",
      labelHi: "मॉडरेशन",
      labelEn: "Moderation",
      icon: <ShieldAlert className="h-4 w-4" />,
    },
  ];

  return (
    <RoleShell
      role="school_admin"
      userName={userName}
      userSubtitle={userSubtitle}
      schoolName={schoolName}
      navItems={navItems}
      canSwitchWorkspace={true}
      activeWorkspace="SCHOOL_ADMIN"
    >
      {children}
    </RoleShell>
  );
}
