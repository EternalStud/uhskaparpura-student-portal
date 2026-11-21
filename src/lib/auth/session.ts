import { cookies } from 'next/headers';
import { NextResponse } from 'next/server';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { generateSessionToken, hmacSha256Hex, sha256Hex } from '@/lib/auth/password';
import type {
  ClassNum,
  LanguageMode,
  SchoolStatus,
  StudentStream,
  UserRole,
} from '@/types/database';

/**
 * DB-backed opaque session management (`user_sessions` table).
 *
 * Security invariants:
 * - High-entropy 256-bit opaque session token stored in DB ONLY as SHA-256 hex digest.
 * - Cookie name: `__Host-sob_session` in production HTTPS, `sob_session` in localhost dev.
 * - Cookie flags: `HttpOnly; SameSite=Strict; Path=/` (and `Secure` in prod HTTPS, NEVER `Domain`!).
 * - `getSession()` enforces: `revoked_at IS NULL`, `expires_at > NOW()`, active principal,
 *   live `token_version` match, and school not `SUSPENDED`.
 * - `noStoreHeaders()` sets `Cache-Control: no-store, no-cache, must-revalidate, private`
 *   to block `bfcache` leakage on shared Bihar school ICT Lab PCs.
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/auth/session.ts is strictly server-only.');
}

export const PROD_SESSION_COOKIE_NAME = '__Host-sob_session';
export const DEV_SESSION_COOKIE_NAME = 'sob_session';

const ROLE_TTL_SECONDS: Record<UserRole, number> = {
  student: 12 * 60 * 60, // 12 hours (shared ICT Lab PC safety)
  teacher: 12 * 60 * 60,
  school_admin: 12 * 60 * 60,
  super_admin: 4 * 60 * 60, // 4 hours strict privileged TTL
};

export interface CreateSessionInput {
  role: UserRole;
  principalId: string;
  schoolUdise?: string | null;
  activeWorkspace?: string | null;
  tokenVersion: number;
  userAgent?: string | null;
  ttlSeconds?: number;
}

export interface CreatedSession {
  sessionId: string;
  rawToken: string;
  expiresAt: Date;
  cookieName: string;
}

export interface StudentPrincipalInfo {
  studentName: string;
  studentCode: string | null;
  classNum: ClassNum;
  stream: StudentStream;
  section: string;
  rollNo: number;
  academicYear: string;
  preferredLang: LanguageMode;
  subjectsConfigured: boolean;
  hasPin: boolean;
}

export interface TeacherPrincipalInfo {
  teacherCode: string;
  fullName: string;
  teacherTitle: string | null;
  mustChangePassword: boolean;
  isSchoolAdmin: boolean;
  subjectsConfigured: boolean;
  assignedClasses: ClassNum[];
  assignedSubjectIds: string[];
}

export interface SuperAdminPrincipalInfo {
  email: string;
  fullName: string;
  totpEnabled: boolean;
}

export interface SessionContext {
  sessionId: string;
  role: UserRole;
  principalId: string;
  schoolUdise: string | null;
  schoolName: string | null;
  schoolStatus: SchoolStatus | null;
  activeWorkspace: string | null;
  tokenVersion: number;
  expiresAt: string;
  student?: StudentPrincipalInfo;
  teacher?: TeacherPrincipalInfo;
  superAdmin?: SuperAdminPrincipalInfo;
}

export type RequireRoleResult =
  | { ok: true; session: SessionContext }
  | { ok: false; response: NextResponse };

/**
 * Returns true when running over production HTTPS (`__Host-` cookie prefix required).
 */
export function isProductionHttps(): boolean {
  if (process.env.NODE_ENV === 'production') {
    return true;
  }
  const appUrl = (process.env.NEXT_PUBLIC_APP_URL || '').trim().toLowerCase();
  return appUrl.startsWith('https://');
}

/**
 * Returns `__Host-sob_session` in production HTTPS and `sob_session` in local dev.
 */
export function getSessionCookieName(): string {
  return isProductionHttps() ? PROD_SESSION_COOKIE_NAME : DEV_SESSION_COOKIE_NAME;
}

/**
 * Builds strict anti-bfcache headers for all authenticated routes & shared ICT Lab PCs.
 */
export function noStoreHeaders(extra?: HeadersInit): Headers {
  const headers = new Headers(extra);
  headers.set('Cache-Control', 'no-store, no-cache, must-revalidate, private');
  headers.set('Pragma', 'no-cache');
  headers.set('Expires', '0');
  headers.set('Vary', 'Cookie');
  return headers;
}

/**
 * Helper to return a JSON `NextResponse` with `noStoreHeaders()` applied automatically.
 */
export function jsonNoStore<T>(data: T, init?: ResponseInit): NextResponse<T> {
  const headers = noStoreHeaders(init?.headers);
  return NextResponse.json(data, {
    ...init,
    headers,
  });
}

/**
 * Applies the session cookie onto a `NextResponse` without setting a `Domain` attribute
 * (mandatory for `__Host-` browser compliance).
 */
export function applySessionCookie(
  response: NextResponse,
  rawToken: string,
  expiresAt: Date
): NextResponse {
  const secure = isProductionHttps();
  const cookieName = getSessionCookieName();
  const maxAge = Math.max(0, Math.floor((expiresAt.getTime() - Date.now()) / 1000));

  response.cookies.set({
    name: cookieName,
    value: rawToken,
    httpOnly: true,
    sameSite: 'strict',
    secure,
    path: '/',
    maxAge,
    expires: expiresAt,
    // Intentionally NO `domain` property (required for `__Host-` cookie prefix)
  });

  return response;
}

/**
 * Clears both production and development session cookies on logout/invalid session.
 */
export function clearSessionCookie(response: NextResponse): NextResponse {
  const secure = isProductionHttps();
  const expiredDate = new Date(0);

  response.cookies.set({
    name: getSessionCookieName(),
    value: '',
    httpOnly: true,
    sameSite: 'strict',
    secure,
    path: '/',
    maxAge: 0,
    expires: expiredDate,
  });

  // Also clear production cookie if running in non-prod mode
  if (!secure) {
    response.cookies.set({
      name: PROD_SESSION_COOKIE_NAME,
      value: '',
      httpOnly: true,
      sameSite: 'strict',
      secure: true,
      path: '/',
      maxAge: 0,
      expires: expiredDate,
    });
  }

  return response;
}

function parseCookieFromHeader(cookieHeader: string | null, name: string): string | null {
  if (!cookieHeader) return null;
  const pairs = cookieHeader.split(';');
  for (const pair of pairs) {
    const eqIdx = pair.indexOf('=');
    if (eqIdx === -1) continue;
    const key = pair.slice(0, eqIdx).trim();
    if (key === name) {
      const rawVal = pair.slice(eqIdx + 1).trim();
      if (!rawVal) return null;
      try {
        return decodeURIComponent(rawVal);
      } catch {
        return rawVal;
      }
    }
  }
  return null;
}

async function readSessionTokenFromRequest(request?: Request): Promise<string | null> {
  const expectedName = getSessionCookieName();

  if (request) {
    const header = request.headers.get('cookie');
    const primary = parseCookieFromHeader(header, expectedName);
    if (primary) return primary;
    if (!isProductionHttps()) {
      return parseCookieFromHeader(header, PROD_SESSION_COOKIE_NAME);
    }
    return null;
  }

  const cookieStore = await cookies();
  const primary = cookieStore.get(expectedName)?.value;
  if (primary) return primary;
  if (!isProductionHttps()) {
    return cookieStore.get(PROD_SESSION_COOKIE_NAME)?.value ?? null;
  }
  return null;
}

/**
 * Creates a new DB-backed opaque session in `user_sessions` and returns the raw cookie token.
 */
export async function createSession(input: CreateSessionInput): Promise<CreatedSession> {
  const supabase = getSupabaseAdmin();
  const rawToken = generateSessionToken();
  const tokenHash = sha256Hex(rawToken);
  const ttlSeconds = input.ttlSeconds ?? ROLE_TTL_SECONDS[input.role];
  const expiresAt = new Date(Date.now() + ttlSeconds * 1000);
  const userAgentHash = input.userAgent
    ? hmacSha256Hex(`ua:v1:${input.userAgent.slice(0, 512)}`)
    : null;

  const { data, error } = await supabase
    .from('user_sessions')
    .insert({
      token_hash: tokenHash,
      role: input.role,
      principal_id: input.principalId,
      school_udise: input.schoolUdise ?? null,
      active_workspace: input.activeWorkspace ?? null,
      token_version: input.tokenVersion,
      user_agent_hash: userAgentHash,
      expires_at: expiresAt.toISOString(),
    })
    .select('id')
    .single();

  if (error || !data) {
    throw new Error(`Failed to persist user session: ${error?.message ?? 'unknown error'}`);
  }

  return {
    sessionId: data.id,
    rawToken,
    expiresAt,
    cookieName: getSessionCookieName(),
  };
}

/**
 * Resolves and strictly validates the current session from cookies or Request.
 * Verifies:
 *  1. Valid SHA-256 hashed session row in `user_sessions`
 *  2. `revoked_at IS NULL` AND `expires_at > NOW()`
 *  3. Principal exists, is active, and `principal.token_version === session.token_version`
 *  4. For school-scoped roles: school exists and is NOT `SUSPENDED`
 *  5. For `school_admin`: active `school_teachers` row has `is_school_admin === true`
 */
export async function getSession(request?: Request): Promise<SessionContext | null> {
  const rawToken = await readSessionTokenFromRequest(request);
  if (!rawToken || rawToken.length < 32 || rawToken.length > 256) {
    return null;
  }

  const supabase = getSupabaseAdmin();
  const tokenHash = sha256Hex(rawToken);
  const nowIso = new Date().toISOString();

  const { data: sessionRow, error: sessionErr } = await supabase
    .from('user_sessions')
    .select(
      'id, role, principal_id, school_udise, active_workspace, token_version, expires_at, revoked_at'
    )
    .eq('token_hash', tokenHash)
    .is('revoked_at', null)
    .gt('expires_at', nowIso)
    .maybeSingle();

  if (sessionErr || !sessionRow) {
    return null;
  }

  // Super Admin validation
  if (sessionRow.role === 'super_admin') {
    const { data: admin, error: adminErr } = await supabase
      .from('super_admins')
      .select('id, email, full_name, totp_enabled, is_active, token_version')
      .eq('id', sessionRow.principal_id)
      .maybeSingle();

    if (
      adminErr ||
      !admin ||
      !admin.is_active ||
      admin.token_version !== sessionRow.token_version
    ) {
      return null;
    }

    return {
      sessionId: sessionRow.id,
      role: 'super_admin',
      principalId: admin.id,
      schoolUdise: null,
      schoolName: null,
      schoolStatus: null,
      activeWorkspace: sessionRow.active_workspace ?? 'SUPER_ADMIN',
      tokenVersion: admin.token_version,
      expiresAt: sessionRow.expires_at,
      superAdmin: {
        email: admin.email,
        fullName: admin.full_name,
        totpEnabled: admin.totp_enabled,
      },
    };
  }

  // All non-super-admin sessions MUST belong to a valid, non-suspended school
  if (!sessionRow.school_udise) {
    return null;
  }

  const { data: school, error: schoolErr } = await supabase
    .from('schools')
    .select('udise_code, school_name, status')
    .eq('udise_code', sessionRow.school_udise)
    .maybeSingle();

  if (schoolErr || !school || school.status === 'SUSPENDED') {
    return null;
  }

  // Student validation
  if (sessionRow.role === 'student') {
    const { data: student, error: studentErr } = await supabase
      .from('students')
      .select(
        'id, school_udise, student_code, student_name, class_num, stream, section, roll_no, academic_year, preferred_lang, is_active, subjects_configured, pin_hash, token_version'
      )
      .eq('id', sessionRow.principal_id)
      .maybeSingle();

    if (
      studentErr ||
      !student ||
      !student.is_active ||
      student.school_udise !== school.udise_code ||
      student.token_version !== sessionRow.token_version
    ) {
      return null;
    }

    return {
      sessionId: sessionRow.id,
      role: 'student',
      principalId: student.id,
      schoolUdise: school.udise_code,
      schoolName: school.school_name,
      schoolStatus: school.status,
      activeWorkspace: 'STUDENT',
      tokenVersion: student.token_version,
      expiresAt: sessionRow.expires_at,
      student: {
        studentName: student.student_name,
        studentCode: student.student_code,
        classNum: student.class_num,
        stream: student.stream,
        section: student.section,
        rollNo: student.roll_no,
        academicYear: student.academic_year,
        preferredLang: student.preferred_lang,
        subjectsConfigured: student.subjects_configured,
        hasPin: Boolean(student.pin_hash),
      },
    };
  }

  // Teacher & School Admin validation
  const [{ data: teacher, error: teacherErr }, { data: posting, error: postingErr }] =
    await Promise.all([
      supabase
        .from('teachers')
        .select('id, teacher_code, full_name, teacher_title, must_change_password, token_version')
        .eq('id', sessionRow.principal_id)
        .maybeSingle(),
      supabase
        .from('school_teachers')
        .select(
          'is_school_admin, is_active, subjects_configured, assigned_classes, assigned_subject_ids'
        )
        .eq('school_udise', school.udise_code)
        .eq('teacher_id', sessionRow.principal_id)
        .maybeSingle(),
    ]);

  if (
    teacherErr ||
    postingErr ||
    !teacher ||
    !posting ||
    !posting.is_active ||
    teacher.token_version !== sessionRow.token_version
  ) {
    return null;
  }

  if (sessionRow.role === 'school_admin' && !posting.is_school_admin) {
    return null;
  }

  return {
    sessionId: sessionRow.id,
    role: sessionRow.role,
    principalId: teacher.id,
    schoolUdise: school.udise_code,
    schoolName: school.school_name,
    schoolStatus: school.status,
    activeWorkspace:
      sessionRow.active_workspace ??
      (sessionRow.role === 'school_admin' ? 'SCHOOL_ADMIN' : 'TEACHER'),
    tokenVersion: teacher.token_version,
    expiresAt: sessionRow.expires_at,
    teacher: {
      teacherCode: teacher.teacher_code,
      fullName: teacher.full_name,
      teacherTitle: teacher.teacher_title,
      mustChangePassword: teacher.must_change_password,
      isSchoolAdmin: posting.is_school_admin,
      subjectsConfigured: posting.subjects_configured,
      assignedClasses: posting.assigned_classes ?? [],
      assignedSubjectIds: posting.assigned_subject_ids ?? [],
    },
  };
}

/**
 * Revokes the current session (by raw token string, Request, or active cookies).
 */
export async function revokeSession(tokenOrRequest?: string | Request): Promise<void> {
  const rawToken =
    typeof tokenOrRequest === 'string'
      ? tokenOrRequest
      : await readSessionTokenFromRequest(tokenOrRequest);

  if (!rawToken) return;

  const supabase = getSupabaseAdmin();
  const tokenHash = sha256Hex(rawToken);

  await supabase
    .from('user_sessions')
    .update({ revoked_at: new Date().toISOString() })
    .eq('token_hash', tokenHash)
    .is('revoked_at', null);
}

/**
 * Revokes EVERY active session for a principal AND optionally bumps their `token_version`
 * (mandatory on password change, reset, deactivation, school transfer, or admin demotion).
 */
export async function revokeAllPrincipalSessions(
  principalId: string,
  role?: UserRole
): Promise<void> {
  const supabase = getSupabaseAdmin();
  const nowIso = new Date().toISOString();

  const { data: revokedRows } = await supabase
    .from('user_sessions')
    .update({ revoked_at: nowIso })
    .eq('principal_id', principalId)
    .is('revoked_at', null)
    .select('role');

  const resolvedRole: UserRole | undefined = role ?? revokedRows?.[0]?.role;

  const bumpStudent = async () => {
    const { data } = await supabase
      .from('students')
      .select('token_version')
      .eq('id', principalId)
      .maybeSingle();
    if (data) {
      await supabase
        .from('students')
        .update({ token_version: data.token_version + 1 })
        .eq('id', principalId);
      return true;
    }
    return false;
  };

  const bumpTeacher = async () => {
    const { data } = await supabase
      .from('teachers')
      .select('token_version')
      .eq('id', principalId)
      .maybeSingle();
    if (data) {
      await supabase
        .from('teachers')
        .update({ token_version: data.token_version + 1 })
        .eq('id', principalId);
      return true;
    }
    return false;
  };

  const bumpSuperAdmin = async () => {
    const { data } = await supabase
      .from('super_admins')
      .select('token_version')
      .eq('id', principalId)
      .maybeSingle();
    if (data) {
      await supabase
        .from('super_admins')
        .update({ token_version: data.token_version + 1 })
        .eq('id', principalId);
      return true;
    }
    return false;
  };

  if (resolvedRole === 'student') {
    await bumpStudent();
  } else if (resolvedRole === 'teacher' || resolvedRole === 'school_admin') {
    await bumpTeacher();
  } else if (resolvedRole === 'super_admin') {
    await bumpSuperAdmin();
  } else {
    // Role was omitted and no active session row existed: resolve across principal tables so
    // `token_version` ALWAYS bumps unconditionally.
    if (!(await bumpStudent())) {
      if (!(await bumpTeacher())) {
        await bumpSuperAdmin();
      }
    }
  }
}

/**
 * Updates `active_workspace` on a teacher/school_admin session after verifying privileges.
 */
export async function updateSessionWorkspace(
  session: SessionContext,
  targetWorkspace: 'TEACHER' | 'SCHOOL_ADMIN'
): Promise<boolean> {
  if (session.role !== 'teacher' && session.role !== 'school_admin') {
    return false;
  }
  if (targetWorkspace === 'SCHOOL_ADMIN' && !session.teacher?.isSchoolAdmin) {
    return false;
  }

  const nextRole: UserRole = targetWorkspace === 'SCHOOL_ADMIN' ? 'school_admin' : 'teacher';
  const supabase = getSupabaseAdmin();

  const { error } = await supabase
    .from('user_sessions')
    .update({
      active_workspace: targetWorkspace,
      role: nextRole,
    })
    .eq('id', session.sessionId)
    .is('revoked_at', null);

  return !error;
}

/**
 * Guards an API route or server action by allowed role(s).
 * Returns `{ ok: true, session }` or `{ ok: false, response }` with strict `noStoreHeaders()`.
 *
 * Note: A `school_admin` who is also a teacher is allowed on `teacher` routes when
 * `'school_admin'` is included in `roles` (or when checking `session.teacher?.isSchoolAdmin`).
 */
export async function requireRole(
  roles: ReadonlyArray<UserRole>,
  request?: Request
): Promise<RequireRoleResult> {
  const session = await getSession(request);
  if (!session) {
    return {
      ok: false,
      response: jsonNoStore({ error: 'Authentication required.' }, { status: 401 }),
    };
  }

  if (!roles.includes(session.role)) {
    return {
      ok: false,
      response: jsonNoStore({ error: 'Insufficient permissions.' }, { status: 403 }),
    };
  }

  return { ok: true, session };
}
