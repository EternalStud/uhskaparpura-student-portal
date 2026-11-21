"use client";

import React from "react";
import { BookOpen, ClipboardCheck, UserCircle2, Users } from "lucide-react";
import { RoleShell, type RoleNavItem } from "@/components/layout/RoleShell";

export interface StudentShellProps {
  studentName: string;
  classNum: number;
  rollNo: number;
  stream?: string;
  schoolName?: string | null;
  children: React.ReactNode;
}

export function StudentShell({
  studentName,
  classNum,
  rollNo,
  stream,
  schoolName,
  children,
}: StudentShellProps) {
  const navItems: RoleNavItem[] = [
    {
      href: "/student",
      labelHi: "पढ़ाई",
      labelEn: "Study",
      icon: <BookOpen className="h-5 w-5" aria-hidden="true" />,
      exact: true,
    },
    {
      href: "/student/classroom",
      labelHi: "कक्षा",
      labelEn: "Class",
      icon: <Users className="h-5 w-5" aria-hidden="true" />,
    },
    {
      href: "/student/exams",
      labelHi: "परीक्षा",
      labelEn: "Exams",
      icon: <ClipboardCheck className="h-5 w-5" aria-hidden="true" />,
    },
    {
      href: "/student/profile",
      labelHi: "प्रोफ़ाइल",
      labelEn: "Me",
      icon: <UserCircle2 className="h-5 w-5" aria-hidden="true" />,
    },
  ];

  const streamLabel =
    stream && stream !== "NA" && stream !== "UNSET" ? ` · ${stream}` : "";

  return (
    <RoleShell
      role="student"
      userName={studentName}
      userSubtitle={`Class ${classNum}${streamLabel} · Roll ${rollNo}`}
      schoolName={schoolName}
      navItems={navItems}
    >
      {children}
    </RoleShell>
  );
}
