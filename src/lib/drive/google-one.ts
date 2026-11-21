import crypto from 'node:crypto';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { getAllowedOrigins } from '@/lib/auth/csrf';
import { getTodayIst } from '@/lib/time/ist';

/**
 * Production-safe 5 TB Personal Google One Storage Client.
 *
 * Security & scalability invariants:
 * 1. OAuth2 Refresh Token lives strictly on server (`GOOGLE_OAUTH_*`), NEVER exposed to browsers.
 * 2. Short-lived access token is encrypted at rest in `system_oauth_tokens` using AES-256-GCM
 *    (`OAUTH_TOKEN_ENCRYPTION_KEY`) and coordinated via PostgreSQL advisory lock
 *    (`try_oauth_advisory_lock` / `release_oauth_advisory_lock`) to prevent refresh stampedes.
 * 3. Direct browser uploads receive ONLY a single-use resumable upload URI with validated `Origin`
 *    header for CORS — zero bearer tokens leave the server.
 * 4. Strict MIME allowlist (NO `.svg`, NO `.html`, NO executables) and strict per-category size caps.
 * 5. Post-upload verification inspects Drive metadata AND reads first 16 bytes for magic-byte
 *    validation; malicious or oversized files are immediately deleted from Google One.
 * 6. Downloads stream directly as Web `ReadableStream` with `Range` / `206 Partial Content` support,
 *    bypassing Vercel's 4.5 MB serverless body limit cleanly.
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/drive/google-one.ts is strictly server-only.');
}

const OAUTH_PROVIDER_KEY = 'google_one_drive';
const OAUTH_REFRESH_LOCK_KEY = 910_202_601; // Deterministic BIGINT advisory lock key
const TOKEN_REFRESH_BUFFER_MS = 5 * 60 * 1000; // Refresh 5 minutes before expiry

const GOOGLE_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token';
const DRIVE_API_BASE = 'https://www.googleapis.com/drive/v3';
const DRIVE_UPLOAD_BASE = 'https://www.googleapis.com/upload/drive/v3';

const DRIVE_FILE_ID_REGEX = /^[A-Za-z0-9_-]{10,128}$/;
const UDISE_REGEX = /^\d{11}$/;
const RANGE_HEADER_REGEX = /^bytes=(?:\d+-\d*|-\d+)$/;

// =============================================================================
// STRICT ALLOWLIST MIME POLICIES & SIZE CAPS
// =============================================================================

export interface UploadMimePolicy {
  category: 'IMAGE' | 'PDF' | 'OFFICE' | 'VIDEO';
  maxBytes: number;
  safeExtension: string;
}

export const ALLOWED_UPLOAD_POLICIES: Readonly<Record<string, UploadMimePolicy>> = {
  // Images <= 5 MB (STRICTLY NO image/svg+xml!)
  'image/jpeg': { category: 'IMAGE', maxBytes: 5 * 1024 * 1024, safeExtension: '.jpg' },
  'image/png': { category: 'IMAGE', maxBytes: 5 * 1024 * 1024, safeExtension: '.png' },
  'image/webp': { category: 'IMAGE', maxBytes: 5 * 1024 * 1024, safeExtension: '.webp' },
  // PDF <= 20 MB
  'application/pdf': { category: 'PDF', maxBytes: 20 * 1024 * 1024, safeExtension: '.pdf' },
  // Office OOXML <= 10 MB
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document': {
    category: 'OFFICE',
    maxBytes: 10 * 1024 * 1024,
    safeExtension: '.docx',
  },
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': {
    category: 'OFFICE',
    maxBytes: 10 * 1024 * 1024,
    safeExtension: '.xlsx',
  },
  'application/vnd.openxmlformats-officedocument.presentationml.presentation': {
    category: 'OFFICE',
    maxBytes: 10 * 1024 * 1024,
    safeExtension: '.pptx',
  },
  // Video <= 100 MB
  'video/mp4': { category: 'VIDEO', maxBytes: 100 * 1024 * 1024, safeExtension: '.mp4' },
  'video/webm': { category: 'VIDEO', maxBytes: 100 * 1024 * 1024, safeExtension: '.webm' },
};

export function getUploadPolicyForMime(mimeType: string): UploadMimePolicy | null {
  const normalized = mimeType.trim().toLowerCase().split(';')[0] ?? '';
  return ALLOWED_UPLOAD_POLICIES[normalized] ?? null;
}

// =============================================================================
// AES-256-GCM ENCRYPTION FOR CACHED OAUTH ACCESS TOKEN
// =============================================================================

function getTokenEncryptionKey(): Buffer {
  const raw = (process.env.OAUTH_TOKEN_ENCRYPTION_KEY || '').trim();
  if (!raw) {
    throw new Error('SECURITY: Missing OAUTH_TOKEN_ENCRYPTION_KEY environment variable.');
  }

  // Accept 64-char hex (32 bytes)
  if (/^[0-9a-fA-F]{64}$/.test(raw)) {
    return Buffer.from(raw, 'hex');
  }

  // Or standard base64 decoding to exactly 32 bytes
  const decoded = Buffer.from(raw, 'base64');
  if (decoded.length === 32) {
    return decoded;
  }

  throw new Error(
    'SECURITY: OAUTH_TOKEN_ENCRYPTION_KEY must be a 32-byte key (64 hex chars or 44-char base64).'
  );
}

export function encryptOAuthToken(plaintext: string): string {
  const key = getTokenEncryptionKey();
  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv('aes-256-gcm', key, iv);
  const encrypted = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
  const authTag = cipher.getAuthTag();
  return `v1:${iv.toString('base64')}:${authTag.toString('base64')}:${encrypted.toString('base64')}`;
}

export function decryptOAuthToken(payload: string): string {
  const parts = payload.split(':');
  if (parts.length !== 4 || parts[0] !== 'v1') {
    throw new Error('Invalid encrypted OAuth token format.');
  }
  const key = getTokenEncryptionKey();
  const iv = Buffer.from(parts[1], 'base64');
  const authTag = Buffer.from(parts[2], 'base64');
  const ciphertext = Buffer.from(parts[3], 'base64');

  const decipher = crypto.createDecipheriv('aes-256-gcm', key, iv);
  decipher.setAuthTag(authTag);
  const decrypted = Buffer.concat([decipher.update(ciphertext), decipher.final()]);
  return decrypted.toString('utf8');
}

// =============================================================================
// OAUTH ACCESS TOKEN MANAGER WITH POSTGRESQL ADVISORY LOCK
// =============================================================================

let inMemoryTokenCache: { accessToken: string; expiresAtMs: number } | null = null;
const folderIdCache = new Map<string, string>();

function requireGoogleOAuthConfig(): {
  clientId: string;
  clientSecret: string;
  refreshToken: string;
  rootFolderId: string;
} {
  const clientId = (process.env.GOOGLE_OAUTH_CLIENT_ID || '').trim();
  const clientSecret = (process.env.GOOGLE_OAUTH_CLIENT_SECRET || '').trim();
  const refreshToken = (process.env.GOOGLE_OAUTH_REFRESH_TOKEN || '').trim();
  const rootFolderId = (process.env.GOOGLE_DRIVE_ROOT_FOLDER_ID || '').trim();

  if (!clientId || !clientSecret || !refreshToken) {
    throw new Error('Missing Google One OAuth2 credentials in server environment.');
  }
  if (!rootFolderId || !DRIVE_FILE_ID_REGEX.test(rootFolderId)) {
    throw new Error('Missing or invalid GOOGLE_DRIVE_ROOT_FOLDER_ID in server environment.');
  }
  return { clientId, clientSecret, refreshToken, rootFolderId };
}

async function readCachedDbToken(): Promise<{ accessToken: string; expiresAtMs: number } | null> {
  const supabase = getSupabaseAdmin();
  const { data, error } = await supabase
    .from('system_oauth_tokens')
    .select('encrypted_access_token, expires_at')
    .eq('provider', OAUTH_PROVIDER_KEY)
    .maybeSingle();

  if (error || !data) return null;

  const expiresAtMs = new Date(data.expires_at).getTime();
  if (Number.isNaN(expiresAtMs) || expiresAtMs <= Date.now() + TOKEN_REFRESH_BUFFER_MS) {
    return null;
  }

  try {
    const accessToken = decryptOAuthToken(data.encrypted_access_token);
    return { accessToken, expiresAtMs };
  } catch {
    return null;
  }
}

async function sleepMs(ms: number): Promise<void> {
  await new Promise((resolve) => setTimeout(resolve, ms));
}

async function refreshAccessTokenFromGoogle(): Promise<{
  accessToken: string;
  expiresAtMs: number;
}> {
  const { clientId, clientSecret, refreshToken } = requireGoogleOAuthConfig();

  const body = new URLSearchParams({
    client_id: clientId,
    client_secret: clientSecret,
    refresh_token: refreshToken,
    grant_type: 'refresh_token',
  });

  const resp = await fetch(GOOGLE_TOKEN_ENDPOINT, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: body.toString(),
    signal: AbortSignal.timeout(10_000),
    cache: 'no-store',
  });

  if (!resp.ok) {
    const errText = await resp.text().catch(() => '');
    throw new Error(`Google OAuth token refresh failed (${resp.status}): ${errText.slice(0, 200)}`);
  }

  const json = (await resp.json()) as { access_token?: string; expires_in?: number };
  if (!json.access_token) {
    throw new Error('Google OAuth token response missing access_token.');
  }

  const expiresInSec = typeof json.expires_in === 'number' && json.expires_in > 60 ? json.expires_in : 3600;
  const expiresAtMs = Date.now() + expiresInSec * 1000;

  return { accessToken: json.access_token, expiresAtMs };
}

/**
 * Returns a valid Google OAuth2 access token using:
 *  1. Fast warm-lambda memory cache
 *  2. Encrypted DB cache (`system_oauth_tokens`)
 *  3. PgBouncer/Supavisor-safe stampede-protected refresh coordinated via transaction-scoped
 *     `acquire_oauth_refresh_lease` (`pg_try_advisory_xact_lock` + atomic `refresh_locked_until`)
 *     and `release_oauth_refresh_lease`.
 */
async function getValidAccessToken(): Promise<string> {
  if (inMemoryTokenCache && inMemoryTokenCache.expiresAtMs > Date.now() + TOKEN_REFRESH_BUFFER_MS) {
    return inMemoryTokenCache.accessToken;
  }

  const dbCached = await readCachedDbToken();
  if (dbCached) {
    inMemoryTokenCache = dbCached;
    return dbCached.accessToken;
  }

  const supabase = getSupabaseAdmin();
  let leaseAcquired = false;

  try {
    const { data: leased, error: leaseErr } = await supabase.rpc('acquire_oauth_refresh_lease', {
      p_provider: OAUTH_PROVIDER_KEY,
      p_lock_key: OAUTH_REFRESH_LOCK_KEY,
      p_lease_seconds: 15,
    });
    if (!leaseErr) {
      leaseAcquired = Boolean(leased);
    }

    // If another serverless instance holds the active lease, wait briefly & re-read DB cache
    if (!leaseErr && !leaseAcquired) {
      for (let attempt = 0; attempt < 5; attempt++) {
        await sleepMs(400);
        const refreshedByPeer = await readCachedDbToken();
        if (refreshedByPeer) {
          inMemoryTokenCache = refreshedByPeer;
          return refreshedByPeer.accessToken;
        }
      }
    }

    // Double-check cache once lease is acquired (or peer lease timed out)
    const secondCheck = await readCachedDbToken();
    if (secondCheck) {
      inMemoryTokenCache = secondCheck;
      return secondCheck.accessToken;
    }

    const fresh = await refreshAccessTokenFromGoogle();
    const encrypted = encryptOAuthToken(fresh.accessToken);

    await supabase.from('system_oauth_tokens').upsert(
      {
        provider: OAUTH_PROVIDER_KEY,
        encrypted_access_token: encrypted,
        expires_at: new Date(fresh.expiresAtMs).toISOString(),
        refresh_locked_until: null,
      },
      { onConflict: 'provider' }
    );

    inMemoryTokenCache = fresh;
    return fresh.accessToken;
  } finally {
    if (leaseAcquired) {
      await supabase
        .rpc('release_oauth_refresh_lease', { p_provider: OAUTH_PROVIDER_KEY })
        .then(
          () => undefined,
          () => undefined
        );
    }
  }
}

// =============================================================================
// FOLDER HIERARCHY MANAGEMENT
// =============================================================================

function escapeDriveQueryLiteral(value: string): string {
  return value.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
}

async function findOrCreateDriveFolder(parentId: string, folderName: string): Promise<string> {
  const cacheKey = `${parentId}/${folderName}`;
  const cached = folderIdCache.get(cacheKey);
  if (cached) return cached;

  const token = await getValidAccessToken();
  const safeName = escapeDriveQueryLiteral(folderName);
  const safeParent = escapeDriveQueryLiteral(parentId);
  const query = `name = '${safeName}' and '${safeParent}' in parents and mimeType = 'application/vnd.google-apps.folder' and trashed = false`;

  const searchUrl = `${DRIVE_API_BASE}/files?q=${encodeURIComponent(query)}&fields=files(id,name)&pageSize=1`;
  const searchResp = await fetch(searchUrl, {
    headers: { Authorization: `Bearer ${token}` },
    signal: AbortSignal.timeout(10_000),
    cache: 'no-store',
  });

  if (!searchResp.ok) {
    throw new Error(`Google Drive folder lookup failed (${searchResp.status}).`);
  }

  const searchJson = (await searchResp.json()) as { files?: Array<{ id: string }> };
  const existingId = searchJson.files?.[0]?.id;
  if (existingId) {
    folderIdCache.set(cacheKey, existingId);
    return existingId;
  }

  const createResp = await fetch(`${DRIVE_API_BASE}/files?fields=id`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name: folderName,
      mimeType: 'application/vnd.google-apps.folder',
      parents: [parentId],
    }),
    signal: AbortSignal.timeout(10_000),
    cache: 'no-store',
  });

  if (!createResp.ok) {
    throw new Error(`Google Drive folder creation failed (${createResp.status}).`);
  }

  const created = (await createResp.json()) as { id?: string };
  if (!created.id) {
    throw new Error('Google Drive folder creation returned no folder ID.');
  }

  folderIdCache.set(cacheKey, created.id);
  return created.id;
}

export type VaultFolderTarget =
  | { kind: 'global-curriculum' }
  | { kind: 'school-materials'; schoolUdise: string }
  | { kind: 'school-doubts'; schoolUdise: string }
  | { kind: 'editorial-submissions'; schoolUdise: string };

/**
 * Auto-creates and caches the canonical folder hierarchy under `GOOGLE_DRIVE_ROOT_FOLDER_ID`:
 * - `global-curriculum/`
 * - `schools/{udise}/materials/`
 * - `schools/{udise}/doubts/`
 * - `editorial-submissions/{udise}/`
 */
export async function resolveVaultFolderId(target: VaultFolderTarget): Promise<string> {
  const { rootFolderId } = requireGoogleOAuthConfig();

  if (target.kind === 'global-curriculum') {
    return findOrCreateDriveFolder(rootFolderId, 'global-curriculum');
  }

  if (!UDISE_REGEX.test(target.schoolUdise)) {
    throw new Error('Invalid 11-digit school UDISE code for vault folder resolution.');
  }

  if (target.kind === 'editorial-submissions') {
    const editorialRoot = await findOrCreateDriveFolder(rootFolderId, 'editorial-submissions');
    return findOrCreateDriveFolder(editorialRoot, target.schoolUdise);
  }

  const schoolsRoot = await findOrCreateDriveFolder(rootFolderId, 'schools');
  const schoolFolder = await findOrCreateDriveFolder(schoolsRoot, target.schoolUdise);
  const leafName = target.kind === 'school-materials' ? 'materials' : 'doubts';
  return findOrCreateDriveFolder(schoolFolder, leafName);
}

/**
 * Ensures all private school vault subfolders exist and returns the school root folder ID.
 */
export async function ensureSchoolVaultFolders(schoolUdise: string): Promise<{
  schoolRootId: string;
  materialsFolderId: string;
  doubtsFolderId: string;
  editorialFolderId: string;
}> {
  if (!UDISE_REGEX.test(schoolUdise)) {
    throw new Error('Invalid 11-digit school UDISE code.');
  }
  const { rootFolderId } = requireGoogleOAuthConfig();
  const schoolsRoot = await findOrCreateDriveFolder(rootFolderId, 'schools');
  const schoolRootId = await findOrCreateDriveFolder(schoolsRoot, schoolUdise);
  const [materialsFolderId, doubtsFolderId, editorialFolderId] = await Promise.all([
    findOrCreateDriveFolder(schoolRootId, 'materials'),
    findOrCreateDriveFolder(schoolRootId, 'doubts'),
    resolveVaultFolderId({ kind: 'editorial-submissions', schoolUdise }),
  ]);
  return { schoolRootId, materialsFolderId, doubtsFolderId, editorialFolderId };
}

// =============================================================================
// RESUMABLE UPLOAD SESSION CREATION
// =============================================================================

export interface CreateResumableUploadInput {
  folderId: string;
  fileName: string;
  mimeType: string;
  expectedSizeBytes: number;
  origin: string;
}

export interface ResumableUploadSessionResult {
  uploadUrl: string;
  sanitizedFileName: string;
  mimeType: string;
  maxBytes: number;
}

function sanitizeUploadFileName(rawName: string, forcedExtension: string): string {
  const base = rawName
    .replace(/[/\\]/g, '_')
    .replace(/\.[^.]+$/, '') // strip original extension; force safe extension from verified MIME
    .replace(/[^A-Za-z0-9._\-\u0900-\u097F\s]/g, '')
    .replace(/\s+/g, '_')
    .trim()
    .slice(0, 80);

  const safeStem = base || `upload_${Date.now()}`;
  return `${safeStem}${forcedExtension}`;
}

/**
 * Initiates a single-use Google Drive resumable upload session.
 * - Strictly enforces MIME allowlist (NO `.svg`, NO `.html`, NO executables) and size caps.
 * - Validates `origin` against `NEXT_PUBLIC_APP_URL` before forwarding `Origin` header for CORS.
 * - Returns ONLY the single-use resumable upload URI (never leaks OAuth credentials).
 */
export async function createResumableUploadSession(
  input: CreateResumableUploadInput
): Promise<ResumableUploadSessionResult> {
  if (!DRIVE_FILE_ID_REGEX.test(input.folderId)) {
    throw new Error('Invalid target folder ID.');
  }

  const normalizedMime = input.mimeType.trim().toLowerCase().split(';')[0] ?? '';
  const policy = getUploadPolicyForMime(normalizedMime);
  if (!policy) {
    throw new Error(`Disallowed file type "${normalizedMime}". Only approved PDF, Image, Office, or Video formats are accepted.`);
  }

  if (
    !Number.isFinite(input.expectedSizeBytes) ||
    input.expectedSizeBytes <= 0 ||
    input.expectedSizeBytes > policy.maxBytes
  ) {
    const maxMb = Math.round(policy.maxBytes / (1024 * 1024));
    throw new Error(`File size must be between 1 byte and ${maxMb} MB for ${policy.category}.`);
  }

  // Validate Origin before forwarding to Google Drive resumable upload CORS check
  let parsedOrigin: string;
  try {
    parsedOrigin = new URL(input.origin).origin;
  } catch {
    throw new Error('Invalid upload Origin header.');
  }
  const allowedOrigins = getAllowedOrigins();
  if (allowedOrigins.size === 0 || !allowedOrigins.has(parsedOrigin)) {
    throw new Error('Upload Origin is not in allowed application origins.');
  }

  const sanitizedFileName = sanitizeUploadFileName(input.fileName, policy.safeExtension);
  const accessToken = await getValidAccessToken();

  const resp = await fetch(`${DRIVE_UPLOAD_BASE}/files?uploadType=resumable&fields=id,name,mimeType,size`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Upload-Content-Type': normalizedMime,
      'X-Upload-Content-Length': String(Math.floor(input.expectedSizeBytes)),
      Origin: parsedOrigin,
    },
    body: JSON.stringify({
      name: sanitizedFileName,
      parents: [input.folderId],
    }),
    signal: AbortSignal.timeout(12_000),
    cache: 'no-store',
  });

  if (!resp.ok) {
    throw new Error(`Failed to initiate upload session (${resp.status}).`);
  }

  const uploadUrl = resp.headers.get('location');
  if (!uploadUrl || !uploadUrl.startsWith('https://www.googleapis.com/upload/drive/v3/files')) {
    throw new Error('Storage provider did not return a valid resumable upload URI.');
  }

  return {
    uploadUrl,
    sanitizedFileName,
    mimeType: normalizedMime,
    maxBytes: policy.maxBytes,
  };
}

// =============================================================================
// POST-UPLOAD MAGIC-BYTE VERIFICATION & AUTO-PURGE
// =============================================================================

const DANGEROUS_TEXT_PREFIXES = ['<svg', '<?xml', '<!doc', '<html', '<scr', '<ifra'];

/**
 * Checks first 16 bytes against strict magic signatures for each allowed MIME type.
 */
export function verifyMagicBytes(headerBytes: Uint8Array, expectedMime: string): boolean {
  if (headerBytes.length < 4) return false;

  // Reject HTML / XML / SVG masquerading regardless of MIME
  const asciiProbe = Buffer.from(headerBytes)
    .toString('ascii')
    .trimStart()
    .toLowerCase();
  for (const dangerous of DANGEROUS_TEXT_PREFIXES) {
    if (asciiProbe.startsWith(dangerous)) {
      return false;
    }
  }

  const mime = expectedMime.trim().toLowerCase().split(';')[0] ?? '';

  if (mime === 'application/pdf') {
    // %PDF-
    return (
      headerBytes.length >= 5 &&
      headerBytes[0] === 0x25 &&
      headerBytes[1] === 0x50 &&
      headerBytes[2] === 0x44 &&
      headerBytes[3] === 0x46 &&
      headerBytes[4] === 0x2d
    );
  }

  if (mime === 'image/png') {
    // 89 50 4E 47 0D 0A 1A 0A
    return (
      headerBytes.length >= 8 &&
      headerBytes[0] === 0x89 &&
      headerBytes[1] === 0x50 &&
      headerBytes[2] === 0x4e &&
      headerBytes[3] === 0x47 &&
      headerBytes[4] === 0x0d &&
      headerBytes[5] === 0x0a &&
      headerBytes[6] === 0x1a &&
      headerBytes[7] === 0x0a
    );
  }

  if (mime === 'image/jpeg') {
    // FF D8 FF
    return headerBytes[0] === 0xff && headerBytes[1] === 0xd8 && headerBytes[2] === 0xff;
  }

  if (mime === 'image/webp') {
    // RIFF....WEBP
    return (
      headerBytes.length >= 12 &&
      headerBytes[0] === 0x52 &&
      headerBytes[1] === 0x49 &&
      headerBytes[2] === 0x46 &&
      headerBytes[3] === 0x46 &&
      headerBytes[8] === 0x57 &&
      headerBytes[9] === 0x45 &&
      headerBytes[10] === 0x42 &&
      headerBytes[11] === 0x50
    );
  }

  if (
    mime === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ||
    mime === 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ||
    mime === 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  ) {
    // PK\x03\x04 (ZIP / OOXML)
    return (
      headerBytes[0] === 0x50 &&
      headerBytes[1] === 0x4b &&
      headerBytes[2] === 0x03 &&
      headerBytes[3] === 0x04
    );
  }

  if (mime === 'video/mp4') {
    // Bytes 4..7 = 'ftyp'
    return (
      headerBytes.length >= 8 &&
      headerBytes[4] === 0x66 &&
      headerBytes[5] === 0x74 &&
      headerBytes[6] === 0x79 &&
      headerBytes[7] === 0x70
    );
  }

  if (mime === 'video/webm') {
    // EBML header 1A 45 DF A3
    return (
      headerBytes[0] === 0x1a &&
      headerBytes[1] === 0x45 &&
      headerBytes[2] === 0xdf &&
      headerBytes[3] === 0xa3
    );
  }

  return false;
}

export type VerifyUploadResult =
  | {
      ok: true;
      driveFileId: string;
      name: string;
      mimeType: string;
      sizeBytes: number;
    }
  | {
      ok: false;
      deleted: boolean;
      reason: string;
    };

/**
 * Verifies an uploaded file's Drive metadata, parent folder ownership (when provided),
 * size limit, and first-16-byte magic signature.
 * Immediately deletes malicious, disguised, or oversized files belonging to the caller's
 * upload folder — while NEVER deleting a foreign file outside `allowedParentFolderIds`!
 */
export async function verifyAndFinalizeUpload(
  driveFileId: string,
  expectedMime: string,
  maxBytes?: number,
  allowedParentFolderIds?: ReadonlyArray<string>
): Promise<VerifyUploadResult> {
  if (!DRIVE_FILE_ID_REGEX.test(driveFileId)) {
    return { ok: false, deleted: false, reason: 'Invalid storage file identifier.' };
  }

  const normalizedMime = expectedMime.trim().toLowerCase().split(';')[0] ?? '';
  const policy = getUploadPolicyForMime(normalizedMime);
  if (!policy) {
    return { ok: false, deleted: false, reason: 'Disallowed MIME type.' };
  }

  const effectiveMaxBytes =
    typeof maxBytes === 'number' && maxBytes > 0
      ? Math.min(maxBytes, policy.maxBytes)
      : policy.maxBytes;

  const accessToken = await getValidAccessToken();

  // 1. Verify Drive file metadata (including `parents` BEFORE any destructive delete!)
  const metaResp = await fetch(
    `${DRIVE_API_BASE}/files/${encodeURIComponent(driveFileId)}?fields=id,name,mimeType,size,parents,trashed`,
    {
      headers: { Authorization: `Bearer ${accessToken}` },
      signal: AbortSignal.timeout(10_000),
      cache: 'no-store',
    }
  );

  if (!metaResp.ok) {
    return { ok: false, deleted: false, reason: `Uploaded file not found (${metaResp.status}).` };
  }

  const meta = (await metaResp.json()) as {
    id?: string;
    name?: string;
    mimeType?: string;
    size?: string;
    parents?: string[];
    trashed?: boolean;
  };

  // Anti-IDOR-delete guard: refuse without deleting if file does not sit inside caller's authorized folder(s)
  if (allowedParentFolderIds && allowedParentFolderIds.length > 0) {
    const fileParents = new Set(meta.parents ?? []);
    const matchesAllowedParent = allowedParentFolderIds.some((pid) => fileParents.has(pid));
    if (!matchesAllowedParent) {
      return {
        ok: false,
        deleted: false,
        reason: 'Uploaded file does not belong to the expected tenant folder.',
      };
    }
  }

  const sizeBytes = Number.parseInt(meta.size ?? '0', 10);
  if (meta.trashed || !Number.isFinite(sizeBytes) || sizeBytes <= 0 || sizeBytes > effectiveMaxBytes) {
    await deleteDriveFile(driveFileId).catch(() => undefined);
    return {
      ok: false,
      deleted: true,
      reason:
        sizeBytes > effectiveMaxBytes
          ? `Uploaded file (${sizeBytes} bytes) exceeds maximum allowed limit (${effectiveMaxBytes} bytes) and was purged.`
          : 'Uploaded file is empty or trashed and was purged.',
    };
  }

  // 2. Fetch ONLY first 16 bytes for magic-byte verification
  const probeResp = await fetch(
    `${DRIVE_API_BASE}/files/${encodeURIComponent(driveFileId)}?alt=media`,
    {
      headers: {
        Authorization: `Bearer ${accessToken}`,
        Range: 'bytes=0-15',
      },
      signal: AbortSignal.timeout(10_000),
      cache: 'no-store',
    }
  );

  if (!probeResp.ok && probeResp.status !== 206) {
    await deleteDriveFile(driveFileId).catch(() => undefined);
    return {
      ok: false,
      deleted: true,
      reason: 'Could not read file header bytes for security verification; upload purged.',
    };
  }

  const headerBytes = new Uint8Array(await probeResp.arrayBuffer());
  if (!verifyMagicBytes(headerBytes, normalizedMime)) {
    await deleteDriveFile(driveFileId).catch(() => undefined);
    return {
      ok: false,
      deleted: true,
      reason: `File magic-byte signature does not match declared type "${normalizedMime}". Malicious or mismatched file was deleted immediately.`,
    };
  }

  return {
    ok: true,
    driveFileId,
    name: meta.name ?? 'file',
    mimeType: normalizedMime,
    sizeBytes,
  };
}

// =============================================================================
// STREAMING DOWNLOAD, BUFFER READ (FOR AI), DELETE & HEALTH CHECK
// =============================================================================

export interface StreamDriveFileResult {
  status: number;
  stream: ReadableStream<Uint8Array>;
  contentType: string;
  contentLength: string | null;
  contentRange: string | null;
  acceptRanges: string;
}

/**
 * Streams a file directly from Google One as a Web `ReadableStream` without buffering
 * in Node memory, supporting HTTP `Range` requests for video seeking & >4.5 MB PDFs on Vercel.
 */
export async function streamDriveFile(
  driveFileId: string,
  rangeHeader?: string | null
): Promise<StreamDriveFileResult> {
  if (!DRIVE_FILE_ID_REGEX.test(driveFileId)) {
    throw new Error('Invalid storage file ID.');
  }

  const accessToken = await getValidAccessToken();
  const headers: Record<string, string> = {
    Authorization: `Bearer ${accessToken}`,
  };

  if (rangeHeader && RANGE_HEADER_REGEX.test(rangeHeader.trim())) {
    headers.Range = rangeHeader.trim();
  }

  const resp = await fetch(`${DRIVE_API_BASE}/files/${encodeURIComponent(driveFileId)}?alt=media`, {
    headers,
    cache: 'no-store',
  });

  if (!resp.ok && resp.status !== 206) {
    throw new Error(`Storage file stream failed (${resp.status}).`);
  }
  if (!resp.body) {
    throw new Error('Storage file stream returned an empty body.');
  }

  return {
    status: resp.status,
    stream: resp.body,
    contentType: resp.headers.get('content-type') || 'application/octet-stream',
    contentLength: resp.headers.get('content-length'),
    contentRange: resp.headers.get('content-range'),
    acceptRanges: resp.headers.get('accept-ranges') || 'bytes',
  };
}

/**
 * Downloads a bounded file into a Buffer (strictly for server-side Super Admin Gemini PDF/DOCX extraction).
 */
export async function downloadDriveFileBuffer(
  driveFileId: string,
  maxBytes: number = 25 * 1024 * 1024
): Promise<Buffer> {
  const { stream, contentLength } = await streamDriveFile(driveFileId);
  if (contentLength && Number.parseInt(contentLength, 10) > maxBytes) {
    throw new Error(`File exceeds maximum processing buffer limit (${maxBytes} bytes).`);
  }

  const reader = stream.getReader();
  const chunks: Uint8Array[] = [];
  let total = 0;

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    if (value) {
      total += value.byteLength;
      if (total > maxBytes) {
        await reader.cancel().catch(() => undefined);
        throw new Error(`Streamed file exceeded maximum processing limit (${maxBytes} bytes).`);
      }
      chunks.push(value);
    }
  }

  return Buffer.concat(chunks.map((c) => Buffer.from(c.buffer, c.byteOffset, c.byteLength)));
}

/**
 * Permanently deletes a file from Google One. Treats 404 as already deleted.
 */
export async function deleteDriveFile(
  driveFileId: string
): Promise<{ ok: boolean; alreadyGone?: boolean }> {
  if (!DRIVE_FILE_ID_REGEX.test(driveFileId)) {
    return { ok: false };
  }

  const accessToken = await getValidAccessToken();
  const resp = await fetch(`${DRIVE_API_BASE}/files/${encodeURIComponent(driveFileId)}`, {
    method: 'DELETE',
    headers: { Authorization: `Bearer ${accessToken}` },
    signal: AbortSignal.timeout(10_000),
    cache: 'no-store',
  });

  if (resp.status === 404) {
    return { ok: true, alreadyGone: true };
  }
  if (!resp.ok && resp.status !== 204) {
    throw new Error(`Failed to delete file from storage (${resp.status}).`);
  }
  return { ok: true };
}

export interface VaultHealthReport {
  healthy: boolean;
  rootFolderAccessible: boolean;
  totalBytes: number | null;
  usedBytes: number | null;
  availableBytes: number | null;
  percentUsed: number | null;
  checkedDateIst: string;
  error?: string;
}

/**
 * Super-Admin-only health check for the 5 TB Personal Google One storage vault.
 */
export async function checkVaultHealth(): Promise<VaultHealthReport> {
  const checkedDateIst = getTodayIst();
  try {
    const { rootFolderId } = requireGoogleOAuthConfig();
    const accessToken = await getValidAccessToken();

    const [aboutResp, rootResp] = await Promise.all([
      fetch(`${DRIVE_API_BASE}/about?fields=storageQuota`, {
        headers: { Authorization: `Bearer ${accessToken}` },
        signal: AbortSignal.timeout(10_000),
        cache: 'no-store',
      }),
      fetch(
        `${DRIVE_API_BASE}/files/${encodeURIComponent(rootFolderId)}?fields=id,name,mimeType,trashed`,
        {
          headers: { Authorization: `Bearer ${accessToken}` },
          signal: AbortSignal.timeout(10_000),
          cache: 'no-store',
        }
      ),
    ]);

    if (!aboutResp.ok) {
      return {
        healthy: false,
        rootFolderAccessible: false,
        totalBytes: null,
        usedBytes: null,
        availableBytes: null,
        percentUsed: null,
        checkedDateIst,
        error: `Drive quota check returned HTTP ${aboutResp.status}`,
      };
    }

    const aboutJson = (await aboutResp.json()) as {
      storageQuota?: { limit?: string; usage?: string };
    };
    const rootJson = rootResp.ok
      ? ((await rootResp.json()) as { id?: string; mimeType?: string; trashed?: boolean })
      : null;

    const rootFolderAccessible = Boolean(
      rootResp.ok &&
        rootJson?.id === rootFolderId &&
        rootJson.mimeType === 'application/vnd.google-apps.folder' &&
        !rootJson.trashed
    );

    const totalBytes = aboutJson.storageQuota?.limit
      ? Number.parseInt(aboutJson.storageQuota.limit, 10)
      : null;
    const usedBytes = aboutJson.storageQuota?.usage
      ? Number.parseInt(aboutJson.storageQuota.usage, 10)
      : null;
    const availableBytes =
      totalBytes !== null && usedBytes !== null ? Math.max(0, totalBytes - usedBytes) : null;
    const percentUsed =
      totalBytes && usedBytes !== null
        ? Number(((usedBytes / totalBytes) * 100).toFixed(2))
        : null;

    return {
      healthy: rootFolderAccessible,
      rootFolderAccessible,
      totalBytes,
      usedBytes,
      availableBytes,
      percentUsed,
      checkedDateIst,
      ...(rootFolderAccessible ? {} : { error: 'Configured root Drive folder is inaccessible or trashed.' }),
    };
  } catch (err) {
    return {
      healthy: false,
      rootFolderAccessible: false,
      totalBytes: null,
      usedBytes: null,
      availableBytes: null,
      percentUsed: null,
      checkedDateIst,
      error: err instanceof Error ? err.message : 'Storage health check failed.',
    };
  }
}
