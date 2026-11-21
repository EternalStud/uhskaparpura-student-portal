import {
  clearSessionCookie,
  jsonNoStore,
  revokeSession,
  validateCsrf,
} from "@/lib/auth";

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  try {
    await revokeSession(request);
  } catch {
    // Always clear cookie even if session row was already revoked/expired
  }

  const response = jsonNoStore({ ok: true });
  return clearSessionCookie(response);
}
