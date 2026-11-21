import { z } from "zod";
import {
  jsonNoStore,
  requireRole,
  updateSessionWorkspace,
  validateCsrf,
} from "@/lib/auth";

const switchWorkspaceSchema = z.object({
  targetWorkspace: z.enum(["TEACHER", "SCHOOL_ADMIN"]),
});

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid request payload." }, { status: 400 });
  }

  const parsed = switchWorkspaceSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: "Invalid target workspace." }, { status: 400 });
  }

  const { targetWorkspace } = parsed.data;
  if (targetWorkspace === "SCHOOL_ADMIN" && !auth.session.teacher?.isSchoolAdmin) {
    return jsonNoStore(
      { error: "School Admin access is not enabled for this account." },
      { status: 403 }
    );
  }

  const updated = await updateSessionWorkspace(auth.session, targetWorkspace);
  if (!updated) {
    return jsonNoStore(
      { error: "Unable to switch workspace right now." },
      { status: 500 }
    );
  }

  return jsonNoStore({
    ok: true,
    activeWorkspace: targetWorkspace,
    redirectTo: targetWorkspace === "SCHOOL_ADMIN" ? "/school" : "/teacher",
  });
}
