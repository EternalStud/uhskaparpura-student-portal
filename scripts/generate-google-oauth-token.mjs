#!/usr/bin/env node
/**
 * Students of Bihar (9-12) — CLI-Only Google One (5 TB) OAuth2 Token & Root Vault Bootstrapper
 *
 * SECURITY INVARIANT:
 *   Strictly local CLI-only script (zero external dependencies).
 *   Exchanges a one-time OAuth2 authorization code on http://localhost:3891/oauth2callback
 *   for a permanent server-side Refresh Token and ensures the `StudentsOfBihar_Vault`
 *   root folder exists in your 5 TB Google One Drive.
 *
 * PREREQUISITES (Google Cloud Console):
 *   1. Enable "Google Drive API".
 *   2. Configure OAuth Consent Screen -> Publishing status MUST be set to "In Production"
 *      (otherwise Google revokes refresh tokens after 7 days!).
 *   3. Create an OAuth 2.0 Client ID (Application type: "Web application") with
 *      Authorized redirect URI: http://localhost:3891/oauth2callback
 *
 * USAGE:
 *   node scripts/generate-google-oauth-token.mjs
 *   node scripts/generate-google-oauth-token.mjs --folder StudentsOfBihar_Vault
 */

import crypto from 'node:crypto';
import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';
import readline from 'node:readline';

const CALLBACK_HOST = '127.0.0.1';
const CALLBACK_PORT = 3891;
const CALLBACK_PATH = '/oauth2callback';
const REDIRECT_URI = `http://localhost:${CALLBACK_PORT}${CALLBACK_PATH}`;

const GOOGLE_AUTH_ENDPOINT = 'https://accounts.google.com/o/oauth2/v2/auth';
const GOOGLE_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token';
const DRIVE_API_BASE = 'https://www.googleapis.com/drive/v3';
// Matches server-side Drive operations in src/lib/drive/google-one.ts
const DRIVE_SCOPE = 'https://www.googleapis.com/auth/drive';
const DEFAULT_VAULT_FOLDER_NAME = 'StudentsOfBihar_Vault';
const CALLBACK_TIMEOUT_MS = 10 * 60 * 1000; // 10 minutes

function loadEnvFallback() {
  const candidates = ['.env.local', '.env'];
  for (const filename of candidates) {
    const filePath = path.resolve(process.cwd(), filename);
    if (!fs.existsSync(filePath)) continue;
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
}

function parseArgs(argv) {
  const flags = {};
  const args = argv.slice(2);
  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i];
    if (arg === '--help' || arg === '-h') {
      flags.help = true;
    } else if (arg.startsWith('--')) {
      const key = arg.slice(2);
      const next = args[i + 1];
      if (next && !next.startsWith('--')) {
        flags[key] = next;
        i += 1;
      } else {
        flags[key] = 'true';
      }
    }
  }
  return flags;
}

function promptLine(promptText) {
  return new Promise((resolve) => {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
    rl.question(promptText, (answer) => {
      rl.close();
      resolve(answer.trim());
    });
  });
}

function promptSecret(promptText) {
  return new Promise((resolve, reject) => {
    if (!process.stdin.isTTY) {
      promptLine(promptText).then(resolve, reject);
      return;
    }

    process.stdout.write(promptText);
    const stdin = process.stdin;
    stdin.setRawMode(true);
    stdin.resume();
    stdin.setEncoding('utf8');

    let value = '';
    const onData = (ch) => {
      if (ch === '\u0003') {
        stdin.setRawMode(false);
        stdin.pause();
        stdin.removeListener('data', onData);
        process.stdout.write('\n');
        reject(new Error('Aborted by operator (Ctrl+C).'));
        return;
      }
      if (ch === '\r' || ch === '\n') {
        stdin.setRawMode(false);
        stdin.pause();
        stdin.removeListener('data', onData);
        process.stdout.write('\n');
        resolve(value.trim());
        return;
      }
      if (ch === '\u007f' || ch === '\b') {
        if (value.length > 0) {
          value = value.slice(0, -1);
          process.stdout.write('\b \b');
        }
        return;
      }
      value += ch;
      process.stdout.write('*');
    };

    stdin.on('data', onData);
  });
}

function escapeDriveQueryLiteral(value) {
  return value.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
}

function formatBytesToGb(bytesStr) {
  const num = Number.parseInt(bytesStr || '', 10);
  if (!Number.isFinite(num) || num <= 0) return 'unknown';
  const gb = num / (1024 ** 3);
  if (gb >= 1024) {
    return `${(gb / 1024).toFixed(2)} TB (${gb.toFixed(0)} GB)`;
  }
  return `${gb.toFixed(2)} GB`;
}

function buildAuthUrl(clientId, state) {
  const params = new URLSearchParams({
    client_id: clientId,
    redirect_uri: REDIRECT_URI,
    response_type: 'code',
    access_type: 'offline',
    prompt: 'consent',
    include_granted_scopes: 'true',
    scope: DRIVE_SCOPE,
    state,
  });
  return `${GOOGLE_AUTH_ENDPOINT}?${params.toString()}`;
}

async function exchangeCodeForTokens({ code, clientId, clientSecret }) {
  const body = new URLSearchParams({
    code,
    client_id: clientId,
    client_secret: clientSecret,
    redirect_uri: REDIRECT_URI,
    grant_type: 'authorization_code',
  });

  const resp = await fetch(GOOGLE_TOKEN_ENDPOINT, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: body.toString(),
    signal: AbortSignal.timeout(15_000),
  });

  const json = await resp.json().catch(() => ({}));
  if (!resp.ok) {
    const desc = json.error_description || json.error || `HTTP ${resp.status}`;
    throw new Error(`Token exchange failed: ${desc}`);
  }
  return json;
}

async function fetchDriveAbout(accessToken) {
  const resp = await fetch(
    `${DRIVE_API_BASE}/about?fields=user(emailAddress,displayName),storageQuota(limit,usage)`,
    {
      headers: { Authorization: `Bearer ${accessToken}` },
      signal: AbortSignal.timeout(15_000),
    }
  );
  if (!resp.ok) {
    return null;
  }
  return resp.json().catch(() => null);
}

async function findOrCreateRootVaultFolder(accessToken, folderName) {
  const safeName = escapeDriveQueryLiteral(folderName);
  const query = `name = '${safeName}' and 'root' in parents and mimeType = 'application/vnd.google-apps.folder' and trashed = false`;
  const searchUrl = `${DRIVE_API_BASE}/files?q=${encodeURIComponent(query)}&fields=files(id,name)&pageSize=1`;

  const searchResp = await fetch(searchUrl, {
    headers: { Authorization: `Bearer ${accessToken}` },
    signal: AbortSignal.timeout(15_000),
  });
  if (!searchResp.ok) {
    const errText = await searchResp.text().catch(() => '');
    throw new Error(`Google Drive folder lookup failed (${searchResp.status}): ${errText.slice(0, 200)}`);
  }

  const searchJson = await searchResp.json();
  if (searchJson.files && searchJson.files.length > 0 && searchJson.files[0].id) {
    return {
      id: searchJson.files[0].id,
      name: searchJson.files[0].name || folderName,
      created: false,
    };
  }

  const createResp = await fetch(`${DRIVE_API_BASE}/files?fields=id,name`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name: folderName,
      mimeType: 'application/vnd.google-apps.folder',
      parents: ['root'],
    }),
    signal: AbortSignal.timeout(15_000),
  });

  if (!createResp.ok) {
    const errText = await createResp.text().catch(() => '');
    throw new Error(`Google Drive folder creation failed (${createResp.status}): ${errText.slice(0, 200)}`);
  }

  const created = await createResp.json();
  if (!created.id) {
    throw new Error('Google Drive API did not return a folder ID.');
  }

  return {
    id: created.id,
    name: created.name || folderName,
    created: true,
  };
}

function renderHtmlPage(title, heading, bodyText, isError = false) {
  const accent = isError ? '#b91c1c' : '#047857';
  const bg = isError ? '#fef2f2' : '#ecfdf5';
  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>${title}</title>
  <style>
    body { font-family: system-ui, -apple-system, sans-serif; background: #f8fafc; color: #0f172a; display: grid; place-items: center; min-height: 100vh; margin: 0; padding: 24px; }
    .card { max-width: 520px; width: 100%; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 14px; padding: 28px; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08); }
    .badge { display: inline-block; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; color: ${accent}; background: ${bg}; margin-bottom: 12px; }
    h1 { font-size: 20px; margin: 0 0 10px; color: #0f172a; }
    p { font-size: 14px; line-height: 1.6; color: #334155; margin: 0; }
  </style>
</head>
<body>
  <div class="card">
    <span class="badge">${isError ? 'ACTION REQUIRED' : 'CONNECTED'}</span>
    <h1>${heading}</h1>
    <p>${bodyText}</p>
  </div>
</body>
</html>`;
}

function waitForOAuthCallback(expectedState) {
  return new Promise((resolve, reject) => {
    let settled = false;

    const server = http.createServer((req, res) => {
      if (!req.url) {
        res.writeHead(400, { 'Content-Type': 'text/plain; charset=utf-8' });
        res.end('Bad Request');
        return;
      }

      const parsed = new URL(req.url, `http://localhost:${CALLBACK_PORT}`);
      if (parsed.pathname !== CALLBACK_PATH) {
        res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
        res.end('Not Found. Waiting for /oauth2callback.');
        return;
      }

      const errorParam = parsed.searchParams.get('error');
      const code = parsed.searchParams.get('code');
      const state = parsed.searchParams.get('state');

      if (errorParam) {
        res.writeHead(400, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(
          renderHtmlPage(
            'Google OAuth Cancelled',
            'Authorization was cancelled or denied',
            `Google returned error: ${errorParam}. Close this tab and re-run the CLI script.`,
            true
          )
        );
        if (!settled) {
          settled = true;
          cleanup();
          reject(new Error(`Google OAuth returned error: ${errorParam}`));
        }
        return;
      }

      if (!state || state !== expectedState) {
        res.writeHead(400, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(
          renderHtmlPage(
            'State Mismatch',
            'OAuth state verification failed',
            'Security check failed (CSRF state mismatch). Please close this tab and restart the script.',
            true
          )
        );
        if (!settled) {
          settled = true;
          cleanup();
          reject(new Error('OAuth state parameter mismatch. Aborting for security.'));
        }
        return;
      }

      if (!code) {
        res.writeHead(400, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(
          renderHtmlPage(
            'Missing Code',
            'No authorization code received',
            'Google did not include a code parameter. Close this tab and try again.',
            true
          )
        );
        if (!settled) {
          settled = true;
          cleanup();
          reject(new Error('No authorization code returned in OAuth callback.'));
        }
        return;
      }

      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      res.end(
        renderHtmlPage(
          'Google One Connected',
          'Authorization received successfully',
          'You may close this browser tab now and return to your terminal to copy GOOGLE_OAUTH_REFRESH_TOKEN and GOOGLE_DRIVE_ROOT_FOLDER_ID.'
        )
      );

      if (!settled) {
        settled = true;
        cleanup();
        resolve(code);
      }
    });

    const timer = setTimeout(() => {
      if (!settled) {
        settled = true;
        cleanup();
        reject(new Error('Timed out after 10 minutes waiting for Google OAuth callback.'));
      }
    }, CALLBACK_TIMEOUT_MS);

    const onSigInt = () => {
      if (!settled) {
        settled = true;
        cleanup();
        reject(new Error('Aborted by operator (Ctrl+C).'));
      }
    };

    function cleanup() {
      clearTimeout(timer);
      process.removeListener('SIGINT', onSigInt);
      server.close();
    }

    process.once('SIGINT', onSigInt);

    server.on('error', (err) => {
      if (!settled) {
        settled = true;
        cleanup();
        if (err && err.code === 'EADDRINUSE') {
          reject(
            new Error(
              `Port ${CALLBACK_PORT} is already in use. Stop the process using port ${CALLBACK_PORT} and re-run.`
            )
          );
        } else {
          reject(err);
        }
      }
    });

    server.listen(CALLBACK_PORT, CALLBACK_HOST);
  });
}

function printHelp() {
  console.log(`
Students of Bihar (9-12) — Google One (5 TB) OAuth2 Token & Vault Setup

Usage:
  node scripts/generate-google-oauth-token.mjs [--folder StudentsOfBihar_Vault]

Reads GOOGLE_OAUTH_CLIENT_ID and GOOGLE_OAUTH_CLIENT_SECRET from .env.local
(or prompts interactively if not set), listens on:
  ${REDIRECT_URI}
exchanges the OAuth2 callback code for a permanent refresh token, and creates
(or finds) the root Drive vault folder.
`);
}

async function main() {
  loadEnvFallback();
  const flags = parseArgs(process.argv);
  if (flags.help) {
    printHelp();
    process.exit(0);
  }

  const folderName = (flags.folder || DEFAULT_VAULT_FOLDER_NAME).trim() || DEFAULT_VAULT_FOLDER_NAME;

  console.log('\n======================================================================');
  console.log(' Students of Bihar (9-12) — 5 TB Google One Vault OAuth2 Setup');
  console.log('======================================================================\n');

  let clientId = (flags['client-id'] || process.env.GOOGLE_OAUTH_CLIENT_ID || '').trim();
  let clientSecret = (flags['client-secret'] || process.env.GOOGLE_OAUTH_CLIENT_SECRET || '').trim();

  if (!clientId) {
    clientId = await promptLine('Enter GOOGLE_OAUTH_CLIENT_ID: ');
  } else {
    console.log(`Loaded GOOGLE_OAUTH_CLIENT_ID from environment (${clientId.slice(0, 12)}...${clientId.slice(-8)}).`);
  }

  if (!clientSecret) {
    clientSecret = await promptSecret('Enter GOOGLE_OAUTH_CLIENT_SECRET: ');
  } else {
    console.log('Loaded GOOGLE_OAUTH_CLIENT_SECRET from environment (hidden).');
  }

  if (!clientId || !clientSecret) {
    throw new Error('Both GOOGLE_OAUTH_CLIENT_ID and GOOGLE_OAUTH_CLIENT_SECRET are required.');
  }

  const state = crypto.randomBytes(24).toString('hex');
  const authUrl = buildAuthUrl(clientId, state);

  console.log('\nBefore opening the link, verify in Google Cloud Console:');
  console.log(`  1. Authorized redirect URI includes EXACTLY: ${REDIRECT_URI}`);
  console.log('  2. Google Drive API is enabled for the project.');
  console.log('  3. Sign in with the Google account that owns your 5 TB Google One plan.\n');
  console.log('Open this URL in your browser:\n');
  console.log(authUrl);
  console.log(`\nListening locally on ${REDIRECT_URI} (waiting up to 10 minutes)...\n`);

  const code = await waitForOAuthCallback(state);
  console.log('Authorization code received. Exchanging for OAuth2 tokens...');

  const tokens = await exchangeCodeForTokens({ code, clientId, clientSecret });
  const accessToken = tokens.access_token;
  const refreshToken = tokens.refresh_token;

  if (!accessToken) {
    throw new Error('Google OAuth token response did not contain an access_token.');
  }
  if (!refreshToken) {
    throw new Error(
      'Google did not return a refresh_token. Visit https://myaccount.google.com/permissions, revoke this app, and re-run this script.'
    );
  }

  console.log('Checking Google One account quota & vault root folder...');
  const [about, folder] = await Promise.all([
    fetchDriveAbout(accessToken),
    findOrCreateRootVaultFolder(accessToken, folderName),
  ]);

  console.log('\n----------------------------------------------------------------------');
  console.log(' CONNECTED GOOGLE ONE VAULT SUMMARY');
  console.log('----------------------------------------------------------------------');
  if (about?.user?.emailAddress) {
    console.log(`  Google Account : ${about.user.emailAddress}`);
  }
  if (about?.storageQuota) {
    console.log(
      `  Storage Quota  : ${formatBytesToGb(about.storageQuota.usage)} used of ${formatBytesToGb(about.storageQuota.limit)}`
    );
  }
  console.log(
    `  Root Folder    : ${folder.name} (${folder.created ? 'created new' : 'reused existing'})`
  );
  console.log('----------------------------------------------------------------------\n');

  console.log('Paste these lines into `.env.local` AND Vercel -> Project Settings -> Environment Variables:\n');
  console.log(`GOOGLE_OAUTH_CLIENT_ID=${clientId}`);
  console.log(`GOOGLE_OAUTH_CLIENT_SECRET=${clientSecret}`);
  console.log(`GOOGLE_OAUTH_REFRESH_TOKEN=${refreshToken}`);
  console.log(`GOOGLE_DRIVE_ROOT_FOLDER_ID=${folder.id}`);

  console.log('\n======================================================================');
  console.log(' CRITICAL PRODUCTION REMINDER (DO NOT SKIP!)');
  console.log('======================================================================');
  console.log(' In Google Cloud Console -> APIs & Services -> OAuth consent screen:');
  console.log('   Set Publishing status to "In Production" (click "PUBLISH APP").');
  console.log(' If left in "Testing" mode, Google AUTOMATICALLY REVOKES refresh tokens');
  console.log(' every 7 days and all uploads/downloads will stop working!');
  console.log(' (You do NOT need Google verification for a personal single-account vault —');
  console.log('  clicking "Advanced -> Go to <App>" once during consent is completely fine.)');
  console.log('======================================================================\n');
}

main().catch((err) => {
  console.error(`\n[generate-google-oauth-token] ERROR: ${err.message}\n`);
  process.exit(1);
});
