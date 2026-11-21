import crypto from 'node:crypto';
import bcrypt from 'bcryptjs';

/**
 * Cryptographic password, 4-digit PIN, token, and code helpers.
 * Uses bcryptjs cost 12 for passwords/PINs and Node crypto for CSPRNG & constant-time comparisons.
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/auth/password.ts is strictly server-only.');
}

export const BCRYPT_ROUNDS = 12;

/**
 * 32-character unambiguous uppercase alphanumeric alphabet.
 * Excludes 0, O, 1, I, l so teachers/admins reading reset codes over phone or paper never confuse chars.
 * Length 32 is an exact power of 2, avoiding modulo bias with `byte & 31`.
 */
const RESET_CODE_ALPHABET = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';

const PIN_4_DIGIT_REGEX = /^\d{4}$/;
const MAX_BCRYPT_BYTES = 72;

/**
 * Hashes a user password with bcrypt (cost 12).
 * Rejects passwords exceeding bcrypt's 72-byte UTF-8 ceiling to prevent silent truncation.
 */
export async function hashPassword(plain: string): Promise<string> {
  if (typeof plain !== 'string' || plain.length === 0) {
    throw new Error('Password must be a non-empty string.');
  }
  if (Buffer.byteLength(plain, 'utf8') > MAX_BCRYPT_BYTES) {
    throw new Error(`Password exceeds maximum length of ${MAX_BCRYPT_BYTES} bytes.`);
  }
  return bcrypt.hash(plain, BCRYPT_ROUNDS);
}

/**
 * Verifies a plaintext password against a stored bcrypt hash.
 * Fails closed (`false`) on empty/malformed inputs without throwing.
 */
export async function verifyPassword(plain: string, hash: string | null | undefined): Promise<boolean> {
  if (
    typeof plain !== 'string' ||
    typeof hash !== 'string' ||
    plain.length === 0 ||
    hash.length < 20 ||
    Buffer.byteLength(plain, 'utf8') > MAX_BCRYPT_BYTES
  ) {
    return false;
  }
  try {
    return await bcrypt.compare(plain, hash);
  } catch {
    return false;
  }
}

/**
 * Hashes a 4-digit numeric student PIN with bcrypt (cost 12).
 */
export async function hashPin(pin: string): Promise<string> {
  const trimmed = typeof pin === 'string' ? pin.trim() : '';
  if (!PIN_4_DIGIT_REGEX.test(trimmed)) {
    throw new Error('Student PIN must be exactly 4 numeric digits.');
  }
  return bcrypt.hash(trimmed, BCRYPT_ROUNDS);
}

/**
 * Verifies a 4-digit student PIN against a stored bcrypt hash.
 */
export async function verifyPin(pin: string, hash: string | null | undefined): Promise<boolean> {
  const trimmed = typeof pin === 'string' ? pin.trim() : '';
  if (!PIN_4_DIGIT_REGEX.test(trimmed) || typeof hash !== 'string' || hash.length < 20) {
    return false;
  }
  try {
    return await bcrypt.compare(trimmed, hash);
  } catch {
    return false;
  }
}

/**
 * Constant-time string comparison safe even when input lengths differ.
 * Compares SHA-256 digests with `crypto.timingSafeEqual` alongside exact byte length equality.
 */
export function constantTimeEqual(a: string, b: string): boolean {
  if (typeof a !== 'string' || typeof b !== 'string') return false;
  const bufA = Buffer.from(a, 'utf8');
  const bufB = Buffer.from(b, 'utf8');
  const digestA = crypto.createHash('sha256').update(bufA).digest();
  const digestB = crypto.createHash('sha256').update(bufB).digest();
  const digestsEqual = crypto.timingSafeEqual(digestA, digestB);
  return digestsEqual && bufA.length === bufB.length;
}

/**
 * Unkeyed SHA-256 hex digest (used for high-entropy opaque session tokens in `user_sessions`).
 */
export function sha256Hex(value: string): string {
  return crypto.createHash('sha256').update(value, 'utf8').digest('hex');
}

function getHmacSecret(): string {
  const configured = (process.env.SESSION_HMAC_SECRET || '').trim();
  if (configured.length >= 16) {
    return configured;
  }
  if (process.env.NODE_ENV === 'production') {
    throw new Error('SECURITY: SESSION_HMAC_SECRET must be configured (>= 16 chars) in production.');
  }
  // Local development fallback only — NEVER reached in production.
  return 'dev-only-insecure-hmac-secret-do-not-use-in-prod';
}

/**
 * Keyed HMAC-SHA256 hex digest (prevents rainbow-table attacks on low-entropy
 * values such as 10-digit Indian mobile numbers or rate-limit keys).
 */
export function hmacSha256Hex(value: string, customSecret?: string): string {
  const secret = customSecret ?? getHmacSecret();
  return crypto.createHmac('sha256', secret).update(value, 'utf8').digest('hex');
}

/**
 * Normalizes a 10-digit Indian mobile number and returns ONLY its last 4 digits
 * and keyed HMAC hash so plaintext mobile numbers are never persisted.
 */
export function hashIndianMobile(rawMobile: string): {
  mobileLast4: string;
  mobileHash: string;
} | null {
  const digitsOnly = rawMobile.replace(/\D/g, '');
  let normalized = digitsOnly;
  if (normalized.length === 12 && normalized.startsWith('91')) {
    normalized = normalized.slice(2);
  } else if (normalized.length === 11 && normalized.startsWith('0')) {
    normalized = normalized.slice(1);
  }
  if (!/^[6-9]\d{9}$/.test(normalized) && !/^\d{10}$/.test(normalized)) {
    return null;
  }
  return {
    mobileLast4: normalized.slice(-4),
    mobileHash: hmacSha256Hex(`mobile:v1:${normalized}`),
  };
}

/**
 * Generates a 256-bit cryptographically secure opaque session token (base64url).
 */
export function generateSessionToken(): string {
  return crypto.randomBytes(32).toString('base64url');
}

/**
 * Generates an unambiguous alphanumeric reset code (default 8 chars, no 0/O/1/I/l).
 */
export function generateResetCode(length: number = 8): string {
  if (!Number.isInteger(length) || length < 6 || length > 32) {
    throw new RangeError('Reset code length must be an integer between 6 and 32.');
  }
  const bytes = crypto.randomBytes(length);
  let out = '';
  for (let i = 0; i < length; i++) {
    out += RESET_CODE_ALPHABET[bytes[i] & 31];
  }
  return out;
}

/**
 * Generates a 6-digit numeric teacher activation code (100000–999999).
 */
export function generateActivationCode(): string {
  return crypto.randomInt(100000, 1000000).toString();
}

/**
 * Generates a 6-digit numeric Live Exam Room PIN (100000–999999).
 */
export function generateExamRoomPin(): string {
  return crypto.randomInt(100000, 1000000).toString();
}

/**
 * Generates a 128-bit hex shuffle seed for deterministic per-student exam ordering.
 */
export function generateShuffleSeed(): string {
  return crypto.randomBytes(16).toString('hex');
}
