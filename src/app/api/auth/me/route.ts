import { getSession, jsonNoStore } from "@/lib/auth";

export async function GET(request: Request) {
  const session = await getSession(request);
  if (!session) {
    return jsonNoStore(
      { authenticated: false, session: null },
      { status: 401 }
    );
  }

  return jsonNoStore({
    authenticated: true,
    session: {
      role: session.role,
      principalId: session.principalId,
      schoolUdise: session.schoolUdise,
      schoolName: session.schoolName,
      schoolStatus: session.schoolStatus,
      activeWorkspace: session.activeWorkspace,
      expiresAt: session.expiresAt,
      student: session.student ?? null,
      teacher: session.teacher ?? null,
      superAdmin: session.superAdmin ?? null,
    },
  });
}
