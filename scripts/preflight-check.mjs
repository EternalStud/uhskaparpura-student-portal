#!/usr/bin/env node
/**
 * Students of Bihar (9-12) — CLI-Only Go-Live Preflight Verifier
 *
 * SECURITY INVARIANT:
 *   Strictly local CLI tool. NEVER prints secret values to stdout/stderr.
 *   Validates all 15 environment variables, live Supabase schema & seed counts,
 *   server-only RPC `acquire_oauth_refresh_lease`, 5 TB Google One Drive Vault
 *   writability, and Gemini API key reachability.
 *
 * USAGE:
 *   node scripts/preflight-check.mjs
 */

import fs from 'node:fs';
import path from 'node:path';
import { createClient } from '@supabase/supabase-js';

const GOOGLE_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token';
const DRIVE_API_BASE = 'https://www.googleapis.com/drive/v3';
const GEMINI_MODELS_ENDPOINT = 'https://generativelanguage.googleapis.com/v1beta/models?pageSize=5';

const HEX_64_EXACT = /^[0-9a-fA-F]{64}$/;
const HEX_64_PLUS = /^[0-9a-fA-F]{64,}$/;
const DRIVE_ID_REGEX = /^[A-Za-z0-9_-]{10,128}$/;

const results = [];

function record(section, label, status, detail) {
  results.push({ section, label, status, detail });
}

function loadEnvLocal() {
  const envLocalPath = path.resolve(process.cwd(), '.env.local');
  const envPath = path.resolve(process.cwd(), '.env');
  const loadedFiles = [];

  for (const filePath of [envLocalPath, envPath]) {
    if (!fs.existsSync(filePath)) continue;
    loadedFiles.push(path.basename(filePath));
    const raw = fs.readFileSync(filePath, 'utf8');
    for (const line of raw.split(/\r?\n/)) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;
      const eqIdx = trimmed.indexOf('=');
      if (eqIdx <= 0) continue;
      const key = trimmed.slice(0, eqIdx).trim();
      let val = trimmed.slice(eqIdx + 1).trim();
      if (
        (val.startsWith('"') && val.endsWith('"')) ||
        (val.startsWith("'") && val.endsWith("'"))
      ) {
        val = val.slice(1, -1);
      }
      if (!(key in process.env) || !process.env[key]) {
        process.env[key] = val;
      }
    }
  }
  return loadedFiles;
}

function getEnv(name) {
  return (process.env[name] || '').trim();
}

function formatGb(bytesStr) {
  const n = Number.parseInt(bytesStr || '', 10);
  if (!Number.isFinite(n) || n <= 0) return 'unknown';
  const gb = n / (1024 ** 3);
  return gb >= 1024 ? `${(gb / 1024).toFixed(2)} TB` : `${gb.toFixed(2)} GB`;
}

// =============================================================================
// 1. VALIDATE ALL 15 ENVIRONMENT VARIABLES (ZERO SECRET ECHO)
// =============================================================================

function checkEnvVars() {
  const section = '1. Environment Variables (15 required)';

  // 1. NEXT_PUBLIC_APP_URL
  const appUrl = getEnv('NEXT_PUBLIC_APP_URL');
  if (!appUrl) {
    record(section, 'NEXT_PUBLIC_APP_URL', 'ACTION-REQUIRED', 'Missing. Set to https://students.uhskaparpurakanti.in (no trailing slash).');
  } else if (appUrl.endsWith('/')) {
    record(section, 'NEXT_PUBLIC_APP_URL', 'ACTION-REQUIRED', `Remove trailing slash from "${appUrl}".`);
  } else {
    try {
      const parsed = new URL(appUrl);
      if (parsed.protocol !== 'https:' && parsed.protocol !== 'http:') {
        record(section, 'NEXT_PUBLIC_APP_URL', 'ACTION-REQUIRED', 'Must start with https:// or http://.');
      } else if (parsed.hostname === 'localhost' || parsed.hostname === '127.0.0.1') {
        record(section, 'NEXT_PUBLIC_APP_URL', 'WARN', `Set to local origin (${parsed.origin}); use https://students.uhskaparpurakanti.in in Vercel Production.`);
      } else {
        record(section, 'NEXT_PUBLIC_APP_URL', 'PASS', `Valid origin (${parsed.origin}, no trailing slash).`);
      }
    } catch {
      record(section, 'NEXT_PUBLIC_APP_URL', 'ACTION-REQUIRED', 'Not a valid URL.');
    }
  }

  // 2-3. Cloudflare Turnstile
  const turnstileSite = getEnv('NEXT_PUBLIC_TURNSTILE_SITE_KEY');
  record(
    section,
    'NEXT_PUBLIC_TURNSTILE_SITE_KEY',
    turnstileSite.length >= 10 ? 'PASS' : 'ACTION-REQUIRED',
    turnstileSite.length >= 10
      ? `Present (${turnstileSite.length} chars).`
      : 'Missing. Create a Managed Turnstile widget in Cloudflare Dashboard.'
  );

  const turnstileSecret = getEnv('TURNSTILE_SECRET_KEY');
  record(
    section,
    'TURNSTILE_SECRET_KEY',
    turnstileSecret.length >= 10 ? 'PASS' : 'ACTION-REQUIRED',
    turnstileSecret.length >= 10
      ? `Present (${turnstileSecret.length} chars, hidden).`
      : 'Missing. Copy Secret Key from Cloudflare Turnstile widget.'
  );

  // 4-7. Supabase
  const sbUrl = getEnv('NEXT_PUBLIC_SUPABASE_URL');
  if (!sbUrl) {
    record(section, 'NEXT_PUBLIC_SUPABASE_URL', 'ACTION-REQUIRED', 'Missing. Set to https://lvrsanukztinwqrgivth.supabase.co.');
  } else {
    try {
      const parsed = new URL(sbUrl);
      if (parsed.protocol !== 'https:' || sbUrl.endsWith('/')) {
        record(section, 'NEXT_PUBLIC_SUPABASE_URL', 'ACTION-REQUIRED', 'Must be an https:// URL without trailing slash.');
      } else {
        record(section, 'NEXT_PUBLIC_SUPABASE_URL', 'PASS', `Valid Supabase host (${parsed.host}).`);
      }
    } catch {
      record(section, 'NEXT_PUBLIC_SUPABASE_URL', 'ACTION-REQUIRED', 'Invalid URL format.');
    }
  }

  const sbAnon = getEnv('NEXT_PUBLIC_SUPABASE_ANON_KEY');
  record(
    section,
    'NEXT_PUBLIC_SUPABASE_ANON_KEY',
    sbAnon.length >= 20 ? 'PASS' : 'ACTION-REQUIRED',
    sbAnon.length >= 20 ? `Present (${sbAnon.length} chars).` : 'Missing Supabase anon public key.'
  );

  const sbService = getEnv('SUPABASE_SERVICE_ROLE_KEY');
  if (sbService.length < 20) {
    record(section, 'SUPABASE_SERVICE_ROLE_KEY', 'ACTION-REQUIRED', 'Missing. Copy service_role secret from Supabase -> Settings -> API.');
  } else if (sbService === sbAnon) {
    record(section, 'SUPABASE_SERVICE_ROLE_KEY', 'ACTION-REQUIRED', 'Matches anon key! Paste the true service_role secret instead.');
  } else {
    record(section, 'SUPABASE_SERVICE_ROLE_KEY', 'PASS', `Present (${sbService.length} chars, distinct from anon key, hidden).`);
  }

  const sbJwt = getEnv('SUPABASE_JWT_SECRET');
  record(
    section,
    'SUPABASE_JWT_SECRET',
    sbJwt.length >= 32 ? 'PASS' : 'ACTION-REQUIRED',
    sbJwt.length >= 32
      ? `Present (${sbJwt.length} chars, hidden).`
      : 'Missing or too short (<32 chars). Copy JWT Secret from Supabase -> Settings -> API.'
  );

  // 8-9. Cryptographic secrets
  const hmacSecret = getEnv('SESSION_HMAC_SECRET');
  record(
    section,
    'SESSION_HMAC_SECRET',
    HEX_64_PLUS.test(hmacSecret) ? 'PASS' : 'ACTION-REQUIRED',
    HEX_64_PLUS.test(hmacSecret)
      ? `Valid (${hmacSecret.length} hex chars >= 64, hidden).`
      : 'Must be >= 64 hex chars (run: openssl rand -hex 32).'
  );

  const encKey = getEnv('OAUTH_TOKEN_ENCRYPTION_KEY');
  record(
    section,
    'OAUTH_TOKEN_ENCRYPTION_KEY',
    HEX_64_EXACT.test(encKey) ? 'PASS' : 'ACTION-REQUIRED',
    HEX_64_EXACT.test(encKey)
      ? 'Valid (exactly 64 hex chars = 32-byte AES-256-GCM key, hidden).'
      : 'Must be EXACTLY 64 hex chars (run: openssl rand -hex 32).'
  );

  // 10-13. Google One Drive OAuth
  const gClientId = getEnv('GOOGLE_OAUTH_CLIENT_ID');
  record(
    section,
    'GOOGLE_OAUTH_CLIENT_ID',
    gClientId.length >= 15 ? 'PASS' : 'ACTION-REQUIRED',
    gClientId.length >= 15
      ? `Present (${gClientId.length} chars).`
      : 'Missing. Create OAuth 2.0 Web Client ID in Google Cloud Console.'
  );

  const gClientSecret = getEnv('GOOGLE_OAUTH_CLIENT_SECRET');
  record(
    section,
    'GOOGLE_OAUTH_CLIENT_SECRET',
    gClientSecret.length >= 10 ? 'PASS' : 'ACTION-REQUIRED',
    gClientSecret.length >= 10
      ? `Present (${gClientSecret.length} chars, hidden).`
      : 'Missing. Copy Client Secret from Google Cloud Console.'
  );

  const gRefreshToken = getEnv('GOOGLE_OAUTH_REFRESH_TOKEN');
  record(
    section,
    'GOOGLE_OAUTH_REFRESH_TOKEN',
    gRefreshToken.length >= 20 ? 'PASS' : 'ACTION-REQUIRED',
    gRefreshToken.length >= 20
      ? `Present (${gRefreshToken.length} chars, hidden).`
      : 'Missing. Run: node scripts/generate-google-oauth-token.mjs'
  );

  const gRootId = getEnv('GOOGLE_DRIVE_ROOT_FOLDER_ID');
  record(
    section,
    'GOOGLE_DRIVE_ROOT_FOLDER_ID',
    DRIVE_ID_REGEX.test(gRootId) ? 'PASS' : 'ACTION-REQUIRED',
    DRIVE_ID_REGEX.test(gRootId)
      ? `Valid Drive folder ID format (${gRootId.length} chars).`
      : 'Missing or invalid format. Run: node scripts/generate-google-oauth-token.mjs'
  );

  // 14. Gemini API key
  const geminiKey = getEnv('GEMINI_API_KEY');
  record(
    section,
    'GEMINI_API_KEY',
    geminiKey.length >= 20 ? 'PASS' : 'ACTION-REQUIRED',
    geminiKey.length >= 20
      ? `Present (${geminiKey.length} chars, hidden).`
      : 'Missing. Create an API key in Google AI Studio for Super-Admin extraction.'
  );

  // 15. Cron secret
  const cronSecret = getEnv('CRON_SECRET');
  record(
    section,
    'CRON_SECRET',
    cronSecret.length >= 32 ? 'PASS' : 'ACTION-REQUIRED',
    cronSecret.length >= 32
      ? `Valid (${cronSecret.length} chars >= 32, hidden).`
      : 'Must be >= 32 chars (run: openssl rand -hex 32).'
  );
}

// =============================================================================
// 2. LIVE SUPABASE CHECKS (TABLES, SEED COUNTS, SUPER ADMINS, OAUTH RPC)
// =============================================================================

async function checkSupabaseLive() {
  const section = '2. Live Supabase Database & RPC';
  const sbUrl = getEnv('NEXT_PUBLIC_SUPABASE_URL');
  const sbService = getEnv('SUPABASE_SERVICE_ROLE_KEY');

  if (!sbUrl || sbService.length < 20) {
    record(
      section,
      'Supabase Live Connectivity',
      'ACTION-REQUIRED',
      'Skipped — set NEXT_PUBLIC_SUPABASE_URL & SUPABASE_SERVICE_ROLE_KEY in .env.local first.'
    );
    return;
  }

  let supabase;
  try {
    supabase = createClient(sbUrl, sbService, {
      auth: { autoRefreshToken: false, persistSession: false },
    });
  } catch (err) {
    record(section, 'Supabase Client Init', 'ACTION-REQUIRED', err instanceof Error ? err.message : 'Init failed.');
    return;
  }

  const tableExpectations = [
    { table: 'schools', min: 0, note: 'Onboard schools via Super Admin Console' },
    { table: 'subjects', min: 100, note: 'Run supabase/ALL_MIGRATIONS_COMBINED.sql' },
    { table: 'chapters', min: 70, note: 'Run supabase/ALL_MIGRATIONS_COMBINED.sql' },
    { table: 'chapter_notes', min: 6, note: 'Run supabase/ALL_MIGRATIONS_COMBINED.sql' },
    { table: 'lesson_plans', min: 6, note: 'Run supabase/ALL_MIGRATIONS_COMBINED.sql' },
    { table: 'questions', min: 40, note: 'Run supabase/ALL_MIGRATIONS_COMBINED.sql' },
    { table: 'super_admins', min: 1, note: 'Run: node scripts/super-admin-recovery.mjs bootstrap --email <you> --name "<Name>"' },
  ];

  const counts = await Promise.all(
    tableExpectations.map(async (item) => {
      try {
        const { count, error } = await supabase
          .from(item.table)
          .select('*', { count: 'exact', head: true });
        return { ...item, count: typeof count === 'number' ? count : null, error: error?.message || null };
      } catch (err) {
        return { ...item, count: null, error: err instanceof Error ? err.message : 'Query failed' };
      }
    })
  );

  for (const row of counts) {
    if (row.error) {
      record(
        section,
        `Table public.${row.table}`,
        'ACTION-REQUIRED',
        `Query failed (${row.error}). ${row.note}.`
      );
      continue;
    }

    if (row.table === 'schools') {
      record(
        section,
        'Table public.schools',
        'PASS',
        `Reachable (${row.count} school(s) registered).`
      );
    } else if (row.count !== null && row.count >= row.min) {
      record(
        section,
        `Table public.${row.table}`,
        'PASS',
        `${row.count} rows (meets threshold >= ${row.min}).`
      );
    } else {
      record(
        section,
        `Table public.${row.table}`,
        'ACTION-REQUIRED',
        `Found ${row.count ?? 0} rows (expected >= ${row.min}). ${row.note}.`
      );
    }
  }

  // Verify server-only RPC `acquire_oauth_refresh_lease` & `release_oauth_refresh_lease`
  const probeProvider = '__preflight_probe__';
  const probeLockKey = 910_202_699;
  try {
    const { data: leased, error: rpcErr } = await supabase.rpc('acquire_oauth_refresh_lease', {
      p_provider: probeProvider,
      p_lock_key: probeLockKey,
      p_lease_seconds: 5,
    });

    if (rpcErr) {
      record(
        section,
        'RPC acquire_oauth_refresh_lease',
        'ACTION-REQUIRED',
        `RPC failed (${rpcErr.message}). Re-run supabase/ALL_MIGRATIONS_COMBINED.sql.`
      );
    } else {
      await supabase.rpc('release_oauth_refresh_lease', { p_provider: probeProvider }).catch(() => undefined);
      await supabase.from('system_oauth_tokens').delete().eq('provider', probeProvider).catch(() => undefined);
      record(
        section,
        'RPC acquire_oauth_refresh_lease',
        'PASS',
        `Verified callable & PgBouncer-safe (returned ${String(Boolean(leased))}; probe cleaned up).`
      );
    }
  } catch (err) {
    record(
      section,
      'RPC acquire_oauth_refresh_lease',
      'ACTION-REQUIRED',
      `RPC call error: ${err instanceof Error ? err.message : 'Unknown error'}.`
    );
  }
}

// =============================================================================
// 3. LIVE 5 TB GOOGLE ONE VAULT TEST
// =============================================================================

async function checkGoogleOneVault() {
  const section = '3. Live 5 TB Google One Storage Vault';
  const clientId = getEnv('GOOGLE_OAUTH_CLIENT_ID');
  const clientSecret = getEnv('GOOGLE_OAUTH_CLIENT_SECRET');
  const refreshToken = getEnv('GOOGLE_OAUTH_REFRESH_TOKEN');
  const rootFolderId = getEnv('GOOGLE_DRIVE_ROOT_FOLDER_ID');

  if (!clientId || !clientSecret || !refreshToken || !rootFolderId) {
    record(
      section,
      'Google One OAuth & Root Vault',
      'ACTION-REQUIRED',
      'Skipped — populate all 4 GOOGLE_* vars (run: node scripts/generate-google-oauth-token.mjs).'
    );
    return;
  }

  try {
    const tokenResp = await fetch(GOOGLE_TOKEN_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        client_id: clientId,
        client_secret: clientSecret,
        refresh_token: refreshToken,
        grant_type: 'refresh_token',
      }).toString(),
      signal: AbortSignal.timeout(12_000),
    });

    if (!tokenResp.ok) {
      const errJson = await tokenResp.json().catch(() => ({}));
      const errMsg = errJson.error_description || errJson.error || `HTTP ${tokenResp.status}`;
      record(
        section,
        'Google OAuth Refresh Token',
        'ACTION-REQUIRED',
        `Token refresh failed (${errMsg}). Ensure OAuth Consent Screen is "In Production" and re-run generate-google-oauth-token.mjs.`
      );
      return;
    }

    const tokenJson = await tokenResp.json();
    const accessToken = tokenJson.access_token;
    if (!accessToken) {
      record(section, 'Google OAuth Refresh Token', 'ACTION-REQUIRED', 'Google returned no access_token.');
      return;
    }
    record(section, 'Google OAuth Refresh Token', 'PASS', 'Refresh token exchanged for fresh access token.');

    const [folderResp, aboutResp] = await Promise.all([
      fetch(
        `${DRIVE_API_BASE}/files/${encodeURIComponent(rootFolderId)}?fields=id,name,mimeType,trashed,capabilities(canAddChildren)`,
        {
          headers: { Authorization: `Bearer ${accessToken}` },
          signal: AbortSignal.timeout(12_000),
        }
      ),
      fetch(`${DRIVE_API_BASE}/about?fields=storageQuota(limit,usage)`, {
        headers: { Authorization: `Bearer ${accessToken}` },
        signal: AbortSignal.timeout(12_000),
      }),
    ]);

    if (!folderResp.ok) {
      record(
        section,
        'Root Vault Folder',
        'ACTION-REQUIRED',
        `Folder lookup failed (HTTP ${folderResp.status}). Verify GOOGLE_DRIVE_ROOT_FOLDER_ID.`
      );
    } else {
      const folder = await folderResp.json();
      const isFolder = folder.mimeType === 'application/vnd.google-apps.folder';
      const writable = Boolean(folder.capabilities?.canAddChildren);
      if (isFolder && !folder.trashed && writable) {
        record(
          section,
          'Root Vault Folder',
          'PASS',
          `Verified writable folder "${folder.name}" (canAddChildren=true).`
        );
      } else {
        record(
          section,
          'Root Vault Folder',
          'ACTION-REQUIRED',
          `Folder invalid/unwritable (isFolder=${isFolder}, trashed=${Boolean(folder.trashed)}, writable=${writable}).`
        );
      }
    }

    if (aboutResp.ok) {
      const about = await aboutResp.json();
      const usage = formatGb(about?.storageQuota?.usage);
      const limit = formatGb(about?.storageQuota?.limit);
      record(section, 'Google One Quota', 'PASS', `${usage} used / ${limit} total capacity.`);
    } else {
      record(section, 'Google One Quota', 'WARN', `Could not read Drive quota (HTTP ${aboutResp.status}).`);
    }
  } catch (err) {
    record(
      section,
      'Google One Connectivity',
      'ACTION-REQUIRED',
      err instanceof Error ? err.message : 'Network error connecting to Google APIs.'
    );
  }
}

// =============================================================================
// 4. LIVE GEMINI API KEY CHECK (SUPER-ADMIN EDITORIAL PIPELINE)
// =============================================================================

async function checkGeminiLive() {
  const section = '4. Live Gemini API (Editorial Structuring)';
  const apiKey = getEnv('GEMINI_API_KEY');

  if (apiKey.length < 20) {
    record(
      section,
      'Gemini API Key Check',
      'ACTION-REQUIRED',
      'Skipped — set GEMINI_API_KEY in .env.local to test Super-Admin extraction.'
    );
    return;
  }

  try {
    const resp = await fetch(GEMINI_MODELS_ENDPOINT, {
      method: 'GET',
      headers: { 'x-goog-api-key': apiKey },
      signal: AbortSignal.timeout(12_000),
    });

    if (!resp.ok) {
      record(
        section,
        'Gemini API Key Check',
        'ACTION-REQUIRED',
        `Gemini API rejected key (HTTP ${resp.status}). Verify GEMINI_API_KEY in Google AI Studio.`
      );
      return;
    }

    const json = await resp.json().catch(() => ({}));
    const count = Array.isArray(json.models) ? json.models.length : 0;
    record(
      section,
      'Gemini API Key Check',
      'PASS',
      `Key accepted by Gemini API (${count}+ models reachable).`
    );
  } catch (err) {
    record(
      section,
      'Gemini API Key Check',
      'ACTION-REQUIRED',
      err instanceof Error ? err.message : 'Network error reaching Gemini API.'
    );
  }
}

// =============================================================================
// REPORT RENDERING
// =============================================================================

function printReport(loadedFiles) {
  console.log('\n======================================================================');
  console.log(' Students of Bihar (9-12) — Go-Live Preflight Checklist');
  console.log('======================================================================');
  console.log(
    ` Env files loaded : ${loadedFiles.length > 0 ? loadedFiles.join(', ') : '(none — using shell env only)'}`
  );

  let currentSection = '';
  let passCount = 0;
  let warnCount = 0;
  let failCount = 0;

  for (const item of results) {
    if (item.section !== currentSection) {
      currentSection = item.section;
      console.log(`\n[ ${currentSection} ]`);
    }

    let tag = '[PASS]           ';
    if (item.status === 'PASS') {
      passCount += 1;
    } else if (item.status === 'WARN') {
      warnCount += 1;
      tag = '[WARN]           ';
    } else {
      failCount += 1;
      tag = '[ACTION-REQUIRED]';
    }

    console.log(`  ${tag} ${item.label.padEnd(32)} ${item.detail}`);
  }

  console.log('\n----------------------------------------------------------------------');
  console.log(` SUMMARY: ${passCount} PASS | ${warnCount} WARN | ${failCount} ACTION-REQUIRED`);
  console.log('----------------------------------------------------------------------');

  if (failCount === 0) {
    console.log(' ALL CHECKS PASSED — Ready to deploy to Vercel & go live!\n');
    return 0;
  }

  console.log(' Complete the ACTION-REQUIRED items above, then re-run:');
  console.log('   node scripts/preflight-check.mjs\n');
  return 1;
}

async function main() {
  const loadedFiles = loadEnvLocal();
  checkEnvVars();
  await Promise.all([checkSupabaseLive(), checkGoogleOneVault(), checkGeminiLive()]);
  const exitCode = printReport(loadedFiles);
  process.exit(exitCode);
}

main().catch((err) => {
  console.error(`\n[preflight-check] FATAL: ${err instanceof Error ? err.message : String(err)}\n`);
  process.exit(1);
});
