import { jsonNoStore, getSession, type SessionContext } from '@/lib/auth/session';
import type { NextResponse } from 'next/server';

/**
 * Authorizes School Admin endpoints for BOTH `role === 'school_admin'` AND
 * dual-role teachers whose active posting has `isSchoolAdmin === true`,
 * guaranteeing a valid non-null `schoolUdise`.
 */
export async function requireSchoolAdmin(
  request?: Request
): Promise<
  | { ok: true; session: SessionContext & { schoolUdise: string } }
  | { ok: false; response: NextResponse }
> {
  const session = await getSession(request);
  if (!session) {
    return {
      ok: false,
      response: jsonNoStore({ error: 'Authentication required.' }, { status: 401 }),
    };
  }

  const isAuthorized =
    (session.role === 'school_admin' ||
      (session.role === 'teacher' && session.teacher?.isSchoolAdmin === true)) &&
    Boolean(session.schoolUdise);

  if (!isAuthorized || !session.schoolUdise) {
    return {
      ok: false,
      response: jsonNoStore(
        { error: 'School Administrator permissions required.' },
        { status: 403 }
      ),
    };
  }

  return {
    ok: true,
    session: session as SessionContext & { schoolUdise: string },
  };
}
