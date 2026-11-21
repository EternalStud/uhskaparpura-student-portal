import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { VisualNotesReader } from "@/components/student/VisualNotesReader";

export const dynamic = "force-dynamic";

export default async function StudentChapterNotesPage({
  params,
}: {
  params: Promise<{ chapterId: string }>;
}) {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }
  if (!session.student.subjectsConfigured) {
    redirect("/student/onboarding");
  }

  const { chapterId } = await params;
  return <VisualNotesReader chapterId={chapterId} />;
}
