"use client";

import React from "react";
import { usePathname } from "next/navigation";
import {
  Building2,
  BookOpen,
  FileSearch,
  PlusCircle,
} from "lucide-react";
import { RoleShell, type RoleNavItem } from "@/components/layout/RoleShell";

export interface SuperAdminShellWrapperProps {
  isAuthenticated: boolean;
  userName: string;
  userEmail: string;
  children: React.ReactNode;
}

export function SuperAdminShellWrapper({
  isAuthenticated,
  userName,
  userEmail,
  children,
}: SuperAdminShellWrapperProps) {
  const pathname = usePathname();

  // Never wrap the unlisted login page in the authenticated console shell
  if (pathname === "/super-admin/login" || !isAuthenticated) {
    return <>{children}</>;
  }

  const navItems: RoleNavItem[] = [
    {
      href: "/super-admin",
      labelHi: "कमांड सेंटर",
      labelEn: "Command Center",
      icon: <Building2 className="h-4 w-4" />,
      exact: true,
    },
    {
      href: "/super-admin/onboard",
      labelHi: "विद्यालय ऑनबोर्डिंग",
      labelEn: "Onboard School",
      icon: <PlusCircle className="h-4 w-4" />,
    },
    {
      href: "/super-admin/review",
      labelHi: "प्रश्न समीक्षा डेस्क",
      labelEn: "Editorial Review",
      icon: <FileSearch className="h-4 w-4" />,
    },
    {
      href: "/super-admin/cms",
      labelHi: "पाठ्यक्रम CMS",
      labelEn: "Curriculum CMS",
      icon: <BookOpen className="h-4 w-4" />,
    },
  ];

  return (
    <RoleShell
      role="super_admin"
      userName={userName}
      userSubtitle={userEmail}
      schoolName="Students of Bihar — Executive Desk"
      navItems={navItems}
    >
      {children}
    </RoleShell>
  );
}
