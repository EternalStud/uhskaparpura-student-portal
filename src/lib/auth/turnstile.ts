/**
 * Server-side Cloudflare Turnstile verification.
 *
 * Security invariant:
 * - Graceful dev bypass ONLY when `NODE_ENV !== 'production'` AND `TURNSTILE_SECRET_KEY` is unset.
 * - Strict FAIL-CLOSED in production: missing secret, missing token, network failure, or hostname mismatch -> rejected.
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/auth/turnstile.ts is strictly server-only.');
}

const TURNSTILE_VERIFY_ENDPOINT = 'https://challenges.cloudflare.com/turnstile/v0/siteverify';
const VERIFY_TIMEOUT_MS = 5000;
const MAX_TOKEN_LENGTH = 2048;

export interface TurnstileVerificationResult {
  ok: boolean;
  bypassed?: boolean;
  hostname?: string;
  errorCodes: string[];
}

interface CloudflareVerifyResponse {
  success?: boolean;
  hostname?: string;
  'error-codes'?: string[];
}

/**
 * Verifies a Cloudflare Turnstile challenge token on the server.
 */
export async function verifyTurnstileToken(
  token: string | null | undefined,
  remoteIp?: string | null
): Promise<TurnstileVerificationResult> {
  const secretKey = (process.env.TURNSTILE_SECRET_KEY || '').trim();
  const isProduction = process.env.NODE_ENV === 'production';

  if (!secretKey) {
    if (!isProduction) {
      return { ok: true, bypassed: true, errorCodes: [] };
    }
    return { ok: false, errorCodes: ['turnstile-secret-not-configured'] };
  }

  const cleanToken = typeof token === 'string' ? token.trim() : '';
  if (!cleanToken || cleanToken.length > MAX_TOKEN_LENGTH) {
    return { ok: false, errorCodes: ['missing-input-response'] };
  }

  try {
    const body = new URLSearchParams();
    body.set('secret', secretKey);
    body.set('response', cleanToken);
    if (remoteIp && remoteIp !== 'unknown') {
      body.set('remoteip', remoteIp);
    }

    const response = await fetch(TURNSTILE_VERIFY_ENDPOINT, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body.toString(),
      signal: AbortSignal.timeout(VERIFY_TIMEOUT_MS),
      cache: 'no-store',
    });

    if (!response.ok) {
      return { ok: false, errorCodes: [`http-${response.status}`] };
    }

    const data = (await response.json()) as CloudflareVerifyResponse;
    if (!data.success) {
      return {
        ok: false,
        hostname: data.hostname,
        errorCodes: Array.isArray(data['error-codes']) ? data['error-codes'] : ['verification-failed'],
      };
    }

    // Verify hostname in production when NEXT_PUBLIC_APP_URL is configured
    if (isProduction && data.hostname && process.env.NEXT_PUBLIC_APP_URL) {
      try {
        const expectedHost = new URL(process.env.NEXT_PUBLIC_APP_URL).hostname.toLowerCase();
        const actualHost = data.hostname.toLowerCase();
        if (actualHost !== expectedHost) {
          return {
            ok: false,
            hostname: data.hostname,
            errorCodes: ['hostname-mismatch'],
          };
        }
      } catch {
        // Ignore malformed app URL parsing error here; CSRF enforces NEXT_PUBLIC_APP_URL strictly.
      }
    }

    return {
      ok: true,
      hostname: data.hostname,
      errorCodes: [],
    };
  } catch {
    // Always fail closed on network/timeout errors
    return { ok: false, errorCodes: ['turnstile-request-error'] };
  }
}
