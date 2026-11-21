import { NextResponse } from 'next/server';

/**
 * Strict CSRF protection for all state-changing API mutations:
 * 1. Rejects `Sec-Fetch-Site: cross-site`.
 * 2. Requires `Origin` header strictly matching `NEXT_PUBLIC_APP_URL` origin
 *    (plus localhost in non-production development).
 * 3. Requires `Content-Type: application/json` OR custom `X-Requested-With` header
 *    (multipart Excel/file uploads must pass `allowMultipart: true` and send `X-Requested-With`).
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/auth/csrf.ts is strictly server-only.');
}

const SAFE_HTTP_METHODS = new Set(['GET', 'HEAD', 'OPTIONS']);

export interface CsrfValidationOptions {
  /** Allow `multipart/form-data` (requires `X-Requested-With` header for preflight enforcement). */
  allowMultipart?: boolean;
}

export type CsrfValidationResult =
  | { ok: true }
  | { ok: false; reason: string; response: NextResponse };

function parseOriginSafe(value: string | null | undefined): string | null {
  if (!value) return null;
  try {
    const parsed = new URL(value.trim());
    if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
      return null;
    }
    return parsed.origin;
  } catch {
    return null;
  }
}

/**
 * Returns the strict set of allowed origins for CSRF checks.
 */
export function getAllowedOrigins(): Set<string> {
  const origins = new Set<string>();

  const configuredAppUrl = parseOriginSafe(process.env.NEXT_PUBLIC_APP_URL);
  if (configuredAppUrl) {
    origins.add(configuredAppUrl);
  }

  // Vercel preview/production deployment host if provided by platform
  const vercelUrl = process.env.VERCEL_URL?.trim();
  if (vercelUrl) {
    const parsedVercel = parseOriginSafe(
      vercelUrl.startsWith('http') ? vercelUrl : `https://${vercelUrl}`
    );
    if (parsedVercel) {
      origins.add(parsedVercel);
    }
  }

  if (process.env.NODE_ENV !== 'production') {
    origins.add('http://localhost:3000');
    origins.add('http://127.0.0.1:3000');
    origins.add('http://localhost:3001');
  }

  return origins;
}

function forbiddenResponse(reason: string): NextResponse {
  return NextResponse.json(
    { error: 'Forbidden: invalid request origin or headers.' },
    {
      status: 403,
      headers: {
        'Cache-Control': 'no-store, no-cache, must-revalidate, private',
        Pragma: 'no-cache',
        Expires: '0',
        'X-CSRF-Rejection': reason,
      },
    }
  );
}

/**
 * Validates Origin, Sec-Fetch-Site, and Content-Type / X-Requested-With on state-changing requests.
 */
export function validateCsrf(
  request: Request,
  options: CsrfValidationOptions = {}
): CsrfValidationResult {
  const method = request.method.toUpperCase();
  if (SAFE_HTTP_METHODS.has(method)) {
    return { ok: true };
  }

  // Defense-in-depth: modern browsers set Sec-Fetch-Site reliably.
  const secFetchSite = request.headers.get('sec-fetch-site')?.trim().toLowerCase();
  if (secFetchSite && secFetchSite !== 'same-origin' && secFetchSite !== 'none') {
    return {
      ok: false,
      reason: 'cross-site-fetch-metadata',
      response: forbiddenResponse('cross-site-fetch-metadata'),
    };
  }

  // Strict Origin header validation (exact URL.origin equality, never prefix match!)
  const rawOrigin = request.headers.get('origin');
  const parsedOrigin = parseOriginSafe(rawOrigin);
  if (!parsedOrigin) {
    return {
      ok: false,
      reason: 'missing-or-invalid-origin',
      response: forbiddenResponse('missing-or-invalid-origin'),
    };
  }

  const allowedOrigins = getAllowedOrigins();
  if (allowedOrigins.size === 0) {
    // Fail-closed in production if NEXT_PUBLIC_APP_URL is unconfigured
    return {
      ok: false,
      reason: 'no-allowed-origins-configured',
      response: forbiddenResponse('no-allowed-origins-configured'),
    };
  }

  if (!allowedOrigins.has(parsedOrigin)) {
    return {
      ok: false,
      reason: 'origin-mismatch',
      response: forbiddenResponse('origin-mismatch'),
    };
  }

  // Content-Type or custom X-Requested-With guard (blocks HTML form CSRF simple requests)
  const contentType = (request.headers.get('content-type') || '').toLowerCase();
  const requestedWith = (request.headers.get('x-requested-with') || '').trim();
  const isJson = contentType.startsWith('application/json') || contentType.includes('+json');
  const hasCustomHeader = requestedWith.length > 0;

  if (options.allowMultipart) {
    const isMultipart = contentType.startsWith('multipart/form-data');
    if (isJson || (isMultipart && hasCustomHeader) || hasCustomHeader) {
      return { ok: true };
    }
    return {
      ok: false,
      reason: 'missing-csrf-header-for-multipart',
      response: forbiddenResponse('missing-csrf-header-for-multipart'),
    };
  }

  if (!isJson && !hasCustomHeader) {
    return {
      ok: false,
      reason: 'invalid-content-type',
      response: forbiddenResponse('invalid-content-type'),
    };
  }

  return { ok: true };
}
