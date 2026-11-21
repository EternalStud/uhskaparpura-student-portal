"use client";

import React, { useEffect, useMemo } from "react";
import { usePathname, useRouter } from "next/navigation";
import {
  BookMarked,
  ClipboardCheck,
  FilePlus2,
  FolderUp,
  LayoutDashboard,
  MessageSquareMore,
  SlidersHorizontal,
} from "lucide-react";
import { RoleShell, type RoleNavItem } from "@/components/layout/RoleShell";
import type { UserRole } from "@/types/database";

export interface TeacherShellProps {
  role: UserRole;
  userName: string;
  userSubtitle?: string;
  schoolName?: string | null;
  canSwitchWorkspace: boolean;
  subjectsConfigured: boolean;
  openDoubtsBadge?: number;
  children: React.ReactNode;
}

export function TeacherShell({
  role,
  userName,
  userSubtitle,
  schoolName,
  canSwitchWorkspace,
  subjectsConfigured,
  openDoubtsBadge,
  children,
}: TeacherShellProps) {
  const pathname = usePathname();
  const router = useRouter();

  // Secondary client guard ensuring teachers configure subjects before exploring studio
  useEffect(() => {
    if (!subjectsConfigured && pathname !== "/teacher/onboarding") {
      router.replace("/teacher/onboarding");
    }
  }, [subjectsConfigured, pathname, router]);

  const navItems = useMemo<RoleNavItem[]>(() => {
    const items: RoleNavItem[] = [
      {
        href: "/teacher",
        labelHi: "सारांश",
        labelEn: "Overview",
        icon: <LayoutDashboard className="h-4 w-4" aria-hidden="true" />,
        exact: true,
      },
      {
        href: "/teacher/lesson-plans",
        labelHi: "पाठ योजना",
        labelEn: "Lesson Plans",
        icon: <BookMarked className="h-4 w-4" aria-hidden="true" />,
      },
      {
        href: "/teacher/materials",
        labelHi: "अध्ययन सामग्री",
        labelEn: "Materials",
        icon: <FolderUp className="h-4 w-4" aria-hidden="true" />,
      },
      {
        href: "/teacher/doubts",
        labelHi: "शंका समाधान",
        labelEn: "Doubt Desk",
        icon: <MessageSquareMore className="h-4 w-4" aria-hidden="true" />,
        badge: openDoubtsBadge && openDoubtsBadge > 0 ? openDoubtsBadge : undefined,
      },
      {
        href: "/teacher/exams",
        labelHi: "परीक्षा केंद्र",
        labelEn: "Exams",
        icon: <ClipboardCheck className="h-4 w-4" aria-hidden="true" />,
      },
      {
        href: "/teacher/contribute",
        labelHi: "प्रश्न पत्र योगदान",
        labelEn: "Contribute",
        icon: <FilePlus2 className="h-4 w-4" aria-hidden="true" />,
      },
      {
        href: "/teacher/onboarding",
        labelHi: "मेरे विषय",
        labelEn: "My Subjects",
        icon: <SlidersHorizontal className="h-4 w-4" aria-hidden="true" />,
      },
    ];
    return items;
  }, [openDoubtsBadge]);

  return (
    <RoleShell
      role={role}
      userName={userName}
      userSubtitle={userSubtitle}
      schoolName={schoolName}
      navItems={navItems}
      canSwitchWorkspace={canSwitchWorkspace}
      activeWorkspace="TEACHER"
    >
      {children}
    </RoleShell>
  );
}
