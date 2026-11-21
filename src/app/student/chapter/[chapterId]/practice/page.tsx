import React from "react";
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth/session";
import { PracticeHubClient } from "@/components/student/PracticeHubClient";

export const dynamic = "force-dynamic";

export default async function StudentChapterPracticePage({
  params,
  searchParams,
}: {
  params: Promise<{ chapterId: string }>;
  searchParams: Promise<{ tab?: string }>;
}) {
  const session = await getSession();
  if (!session || session.role !== "student" || !session.student) {
    redirect("/login/student");
  }
  if (!session.student.subjectsConfigured) {
    redirect("/student/onboarding");
  }

  const { chapterId } = await params;
  const { tab } = await searchParams;

  return <PracticeHubClient chapterId={chapterId} initialTab={tab} />;
}
