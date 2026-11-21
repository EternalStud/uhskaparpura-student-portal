import { redirect } from "next/navigation";
import { getSession, type SessionContext } from "@/lib/auth/session";

export interface TeacherPageSession extends SessionContext {
  schoolUdise: string;
  teacher: NonNullable<SessionContext["teacher"]>;
}

/**
 * Validates that the current request has an active teacher or school_admin session.
 * Redirects unauthenticated or wrong-role users cleanly.
 */
export async function requireTeacherSession(): Promise<TeacherPageSession> {
  const session = await getSession();
  if (!session) {
    redirect("/login/teacher");
  }
  if (session.role === "student") {
    redirect("/student");
  }
  if (session.role === "super_admin") {
    redirect("/super-admin");
  }
  if (!session.schoolUdise || !session.teacher) {
    redirect("/login/teacher");
  }
  return session as TeacherPageSession;
}

/**
 * Enforces that the teacher has completed their 15-second Class & Subject onboarding.
 * Redirects to `/teacher/onboarding` on first login before showing studio screens.
 */
export async function requireConfiguredTeacher(): Promise<TeacherPageSession> {
  const session = await requireTeacherSession();
  if (!session.teacher.subjectsConfigured) {
    redirect("/teacher/onboarding");
  }
  return session;
}
