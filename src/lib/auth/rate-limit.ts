import { getSupabaseAdmin } from '@/lib/supabase/server';
import { hmacSha256Hex } from '@/lib/auth/password';

/**
 * Two-tier Bihar ICT-Lab-NAT-safe rate limiter backed by `auth_rate_limits`.
 *
 * Design rationale:
 * Many rural Bihar government schools share ONE NAT IP across 40+ ICT Lab PCs
 * during exams and login hours. Therefore:
 *  - Tier 1 (Per-Account): Strict limit — 5 failures in 15 min triggers Turnstile;
 *    20 failures in 15 min temporarily locks THAT specific account for 15 min.
 *  - Tier 2 (Per-IP): Generous ceiling — 120 requests/min triggers soft Turnstile,
 *    NEVER hard-bans a shared school router IP!
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/auth/rate-limit.ts is strictly server-only.');
}

export const ACCOUNT_WINDOW_MS = 15 * 60 * 1000; // 15 minutes
export const ACCOUNT_TURNSTILE_THRESHOLD = 5;
export const ACCOUNT_SOFT_LOCK_THRESHOLD = 20;
export const ACCOUNT_LOCK_DURATION_MS = 15 * 60 * 1000; // 15 minutes

export const IP_WINDOW_MS = 60 * 1000; // 1 minute
export const IP_TURNSTILE_THRESHOLD = 120; // soft Turnstile ONLY — never hard-bans!

export interface AuthRateLimitInput {
  /** Login/action scope e.g. 'student-login', 'teacher-login', 'teacher-activate', 'super-admin' */
  scope: string;
  /** Account identifier e.g. `${udise}:${classNum}:${rollNo}` or `teacherCode` or `email` */
  accountKey: string;
  /** Client IP extracted via `extractClientIp(request)` */
  clientIp: string;
}

export interface AuthRateLimitCheck {
  allowed: boolean;
  requiresTurnstile: boolean;
  retryAfterSec: number;
  accountAttempts: number;
  ipAttempts: number;
}

function buildAccountBucket(scope: string, accountKey: string): string {
  const normalized = accountKey.trim().toLowerCase();
  const digest = hmacSha256Hex(`rl:acct:${scope}:${normalized}`).slice(0, 32);
  return `acct:${scope}:${digest}`;
}

function buildIpBucket(scope: string, clientIp: string): string {
  const normalized = (clientIp || 'unknown').trim().toLowerCase();
  const digest = hmacSha256Hex(`rl:ip:${scope}:${normalized}`).slice(0, 32);
  return `ip:${scope}:${digest}`;
}

/**
 * Extracts client IP safely, prioritizing Vercel's unspoofable edge headers
 * (`x-vercel-forwarded-for`, `x-real-ip`) BEFORE proxy-mutable headers so attackers
 * cannot spoof `CF-Connecting-IP` on Vercel deployments.
 */
export function extractClientIp(request: Request): string {
  const candidates = [
    request.headers.get('x-vercel-forwarded-for'),
    request.headers.get('x-real-ip'),
    request.headers.get('x-forwarded-for'),
    request.headers.get('cf-connecting-ip'),
  ];

  for (const raw of candidates) {
    if (!raw) continue;
    const first = raw.split(',')[0]?.trim();
    if (first && first.length <= 64) {
      return first;
    }
  }

  return 'unknown';
}

/**
 * Checks both per-account and per-IP rate limit buckets without mutating failure counters.
 */
export async function checkAuthRateLimit(input: AuthRateLimitInput): Promise<AuthRateLimitCheck> {
  const supabase = getSupabaseAdmin();
  const acctBucket = buildAccountBucket(input.scope, input.accountKey);
  const ipBucket = buildIpBucket(input.scope, input.clientIp);
  const nowMs = Date.now();

  const { data: rows, error } = await supabase
    .from('auth_rate_limits')
    .select('bucket_key, attempts, window_start, blocked_until')
    .in('bucket_key', [acctBucket, ipBucket]);

  if (error || !rows) {
    // Do not hard-lock school logins on transient DB read glitches, but fail-safe by requiring Turnstile
    return {
      allowed: true,
      requiresTurnstile: true,
      retryAfterSec: 0,
      accountAttempts: 0,
      ipAttempts: 0,
    };
  }

  const acctRow = rows.find((r) => r.bucket_key === acctBucket);
  const ipRow = rows.find((r) => r.bucket_key === ipBucket);

  let accountAttempts = 0;
  let retryAfterSec = 0;
  let allowed = true;

  if (acctRow) {
    const windowAgeMs = nowMs - new Date(acctRow.window_start).getTime();
    if (windowAgeMs < ACCOUNT_WINDOW_MS) {
      accountAttempts = acctRow.attempts;
    }
    if (acctRow.blocked_until) {
      const blockedMs = new Date(acctRow.blocked_until).getTime();
      if (blockedMs > nowMs) {
        allowed = false;
        retryAfterSec = Math.max(1, Math.ceil((blockedMs - nowMs) / 1000));
      }
    }
  }

  let ipAttempts = 0;
  if (ipRow) {
    const ipWindowAgeMs = nowMs - new Date(ipRow.window_start).getTime();
    if (ipWindowAgeMs < IP_WINDOW_MS) {
      ipAttempts = ipRow.attempts;
    }
  }

  // Note: Per-IP ceiling ONLY requests soft Turnstile, NEVER sets allowed = false!
  const requiresTurnstile =
    accountAttempts >= ACCOUNT_TURNSTILE_THRESHOLD || ipAttempts >= IP_TURNSTILE_THRESHOLD;

  return {
    allowed,
    requiresTurnstile,
    retryAfterSec,
    accountAttempts,
    ipAttempts,
  };
}

async function incrementBucket(
  bucketKey: string,
  windowMs: number,
  lockThreshold?: number,
  lockDurationMs?: number
): Promise<number> {
  const supabase = getSupabaseAdmin();
  const now = new Date();
  const nowMs = now.getTime();

  const { data: existing } = await supabase
    .from('auth_rate_limits')
    .select('attempts, window_start, blocked_until')
    .eq('bucket_key', bucketKey)
    .maybeSingle();

  let nextAttempts = 1;
  let windowStartIso = now.toISOString();
  let blockedUntilIso: string | null = null;

  if (existing) {
    const ageMs = nowMs - new Date(existing.window_start).getTime();
    if (ageMs < windowMs) {
      nextAttempts = existing.attempts + 1;
      windowStartIso = existing.window_start;
      blockedUntilIso = existing.blocked_until;
    }
  }

  if (lockThreshold && lockDurationMs && nextAttempts >= lockThreshold) {
    blockedUntilIso = new Date(nowMs + lockDurationMs).toISOString();
  }

  await supabase.from('auth_rate_limits').upsert(
    {
      bucket_key: bucketKey,
      attempts: nextAttempts,
      window_start: windowStartIso,
      blocked_until: blockedUntilIso,
    },
    { onConflict: 'bucket_key' }
  );

  return nextAttempts;
}

/**
 * Records a per-IP request against the generous 120/min NAT-safe bucket (never blocks IP).
 */
export async function recordIpAttempt(scope: string, clientIp: string): Promise<number> {
  const ipBucket = buildIpBucket(scope, clientIp);
  return incrementBucket(ipBucket, IP_WINDOW_MS);
}

/**
 * Records a failed authentication attempt for BOTH the specific account bucket
 * (strict 5/15m -> Turnstile, 20/15m -> account lock) and the soft per-IP bucket.
 */
export async function recordAuthFailure(input: AuthRateLimitInput): Promise<{
  accountAttempts: number;
  ipAttempts: number;
  requiresTurnstile: boolean;
}> {
  const acctBucket = buildAccountBucket(input.scope, input.accountKey);
  const ipBucket = buildIpBucket(input.scope, input.clientIp);

  const [accountAttempts, ipAttempts] = await Promise.all([
    incrementBucket(
      acctBucket,
      ACCOUNT_WINDOW_MS,
      ACCOUNT_SOFT_LOCK_THRESHOLD,
      ACCOUNT_LOCK_DURATION_MS
    ),
    incrementBucket(ipBucket, IP_WINDOW_MS),
  ]);

  return {
    accountAttempts,
    ipAttempts,
    requiresTurnstile:
      accountAttempts >= ACCOUNT_TURNSTILE_THRESHOLD || ipAttempts >= IP_TURNSTILE_THRESHOLD,
  };
}

/**
 * Clears the per-account failure bucket after a verified successful login.
 */
export async function clearAccountRateLimit(scope: string, accountKey: string): Promise<void> {
  const supabase = getSupabaseAdmin();
  const acctBucket = buildAccountBucket(scope, accountKey);
  await supabase.from('auth_rate_limits').delete().eq('bucket_key', acctBucket);
}

/**
 * Generic per-principal endpoint throttle (e.g., doubt creation or upload session creation).
 */
export async function consumePrincipalRateLimit(
  scope: string,
  principalId: string,
  maxRequests: number,
  windowMs: number
): Promise<{ allowed: boolean; remaining: number }> {
  const bucketKey = buildAccountBucket(scope, principalId);
  const count = await incrementBucket(bucketKey, windowMs);
  return {
    allowed: count <= maxRequests,
    remaining: Math.max(0, maxRequests - count),
  };
}
