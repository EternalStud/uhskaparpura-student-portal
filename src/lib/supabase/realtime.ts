import crypto from 'node:crypto';

/**
 * Mints short-lived HS256 scoped Supabase Realtime JWTs strictly restricted to
 * `{ role: 'authenticated', school_udise, exam_id }` for Teacher Live Exam
 * Projector monitors (`live_exam_roster` RLS policy).
 *
 * Server-only: relies on `SUPABASE_JWT_SECRET`.
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/supabase/realtime.ts is strictly server-only.');
}

const UDISE_REGEX = /^\d{11}$/;
const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const DEFAULT_TTL_SECONDS = 2 * 60 * 60; // 2 hours (covers full BSEB live exam)
const MIN_TTL_SECONDS = 60;
const MAX_TTL_SECONDS = 4 * 60 * 60; // hard cap: 4 hours

export interface RealtimeExamJwtClaims {
  role: 'authenticated';
  aud: 'authenticated';
  sub: string;
  school_udise: string;
  exam_id: string;
  iat: number;
  exp: number;
}

export interface MintRealtimeExamJwtInput {
  schoolUdise: string;
  examId: string;
  teacherId?: string;
  ttlSeconds?: number;
}

export interface MintedRealtimeExamJwt {
  token: string;
  expiresAt: string;
  claims: RealtimeExamJwtClaims;
}

function base64UrlEncode(input: Buffer | string): string {
  const buf = typeof input === 'string' ? Buffer.from(input, 'utf8') : input;
  return buf.toString('base64url');
}

function getSupabaseJwtSecret(): string {
  // Supabase Realtime strictly validates JWTs against SUPABASE_JWT_SECRET.
  // In production, fail closed if SUPABASE_JWT_SECRET is unset (never fall back to SESSION_HMAC_SECRET).
  const primary = (process.env.SUPABASE_JWT_SECRET || '').trim();
  if (primary.length >= 16) {
    return primary;
  }
  if (process.env.NODE_ENV !== 'production') {
    const devFallback = (process.env.SESSION_HMAC_SECRET || '').trim();
    if (devFallback.length >= 16) {
      return devFallback;
    }
  }
  throw new Error(
    'SUPABASE_JWT_SECRET is not configured. Required to mint scoped Live Exam Realtime tokens.'
  );
}

/**
 * Returns true if the server has a valid Realtime JWT signing secret configured.
 */
export function isRealtimeJwtConfigured(): boolean {
  const primary = (process.env.SUPABASE_JWT_SECRET || '').trim();
  if (primary.length >= 16) return true;
  if (process.env.NODE_ENV !== 'production') {
    return (process.env.SESSION_HMAC_SECRET || '').trim().length >= 16;
  }
  return false;
}

/**
 * Mints a short-lived HS256 JWT scoped ONLY to one school + one live exam.
 * Used exclusively by authenticated teachers monitoring `live_exam_roster`.
 */
export function mintRealtimeExamJwt(input: MintRealtimeExamJwtInput): MintedRealtimeExamJwt {
  const schoolUdise = input.schoolUdise.trim();
  const examId = input.examId.trim();

  if (!UDISE_REGEX.test(schoolUdise)) {
    throw new Error('Invalid 11-digit school UDISE code for Realtime token.');
  }
  if (!UUID_REGEX.test(examId)) {
    throw new Error('Invalid UUID exam_id for Realtime token.');
  }
  if (input.teacherId && !UUID_REGEX.test(input.teacherId.trim())) {
    throw new Error('Invalid UUID teacherId for Realtime token.');
  }

  const rawTtl = input.ttlSeconds ?? DEFAULT_TTL_SECONDS;
  const ttlSeconds = Math.max(MIN_TTL_SECONDS, Math.min(MAX_TTL_SECONDS, Math.floor(rawTtl)));

  const nowSec = Math.floor(Date.now() / 1000);
  const expSec = nowSec + ttlSeconds;

  const header = { alg: 'HS256', typ: 'JWT' };
  const claims: RealtimeExamJwtClaims = {
    role: 'authenticated',
    aud: 'authenticated',
    sub: input.teacherId ? `teacher:${input.teacherId.trim()}` : `exam-monitor:${examId}`,
    school_udise: schoolUdise,
    exam_id: examId,
    iat: nowSec,
    exp: expSec,
  };

  const encodedHeader = base64UrlEncode(JSON.stringify(header));
  const encodedPayload = base64UrlEncode(JSON.stringify(claims));
  const signingInput = `${encodedHeader}.${encodedPayload}`;

  const signature = crypto
    .createHmac('sha256', getSupabaseJwtSecret())
    .update(signingInput)
    .digest('base64url');

  return {
    token: `${signingInput}.${signature}`,
    expiresAt: new Date(expSec * 1000).toISOString(),
    claims,
  };
}

/**
 * Verifies a previously minted Realtime Exam JWT (useful for tests & server-side checks).
 */
export function verifyRealtimeExamJwt(token: string): RealtimeExamJwtClaims | null {
  if (!token || typeof token !== 'string') return null;
  const parts = token.split('.');
  if (parts.length !== 3) return null;

  const [encodedHeader, encodedPayload, encodedSig] = parts;
  if (!encodedHeader || !encodedPayload || !encodedSig) return null;

  try {
    const header = JSON.parse(Buffer.from(encodedHeader, 'base64url').toString('utf8')) as {
      alg?: string;
      typ?: string;
    };
    if (header.alg !== 'HS256') return null;

    const expectedSig = crypto
      .createHmac('sha256', getSupabaseJwtSecret())
      .update(`${encodedHeader}.${encodedPayload}`)
      .digest();
    const actualSig = Buffer.from(encodedSig, 'base64url');

    if (expectedSig.length !== actualSig.length) return null;
    if (!crypto.timingSafeEqual(expectedSig, actualSig)) return null;

    const claims = JSON.parse(
      Buffer.from(encodedPayload, 'base64url').toString('utf8')
    ) as Partial<RealtimeExamJwtClaims>;

    const nowSec = Math.floor(Date.now() / 1000);
    if (
      claims.role !== 'authenticated' ||
      claims.aud !== 'authenticated' ||
      typeof claims.school_udise !== 'string' ||
      !UDISE_REGEX.test(claims.school_udise) ||
      typeof claims.exam_id !== 'string' ||
      !UUID_REGEX.test(claims.exam_id) ||
      typeof claims.exp !== 'number' ||
      claims.exp <= nowSec
    ) {
      return null;
    }

    return claims as RealtimeExamJwtClaims;
  } catch {
    return null;
  }
}
