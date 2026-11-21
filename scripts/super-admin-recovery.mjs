#!/usr/bin/env node
/**
 * Students of Bihar (9-12) — CLI-Only Super Admin Bootstrap & Recovery Tool
 *
 * SECURITY INVARIANT:
 *   This script is STRICTLY CLI-only and NEVER imported or exposed over HTTP.
 *   Requires SUPABASE_SERVICE_ROLE_KEY + NEXT_PUBLIC_SUPABASE_URL (or SUPABASE_URL).
 *
 * USAGE:
 *   node scripts/super-admin-recovery.mjs list
 *   node scripts/super-admin-recovery.mjs bootstrap --email admin@example.com --name "Full Name"
 *   node scripts/super-admin-recovery.mjs reset-password --email admin@example.com
 *   node scripts/super-admin-recovery.mjs reset-totp --email admin@example.com
 */

import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import readline from 'node:readline';
import { createClient } from '@supabase/supabase-js';
import bcrypt from 'bcryptjs';

const BCRYPT_ROUNDS = 12;
const RECOVERY_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // excludes 0/O/1/I

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
      if (!(key in process.env)) {
        process.env[key] = val;
      }
    }
  }
}

function parseArgs(argv) {
  const [command, ...rest] = argv.slice(2);
  const flags = {};
  for (let i = 0; i < rest.length; i += 1) {
    const arg = rest[i];
    if (arg.startsWith('--')) {
      const key = arg.slice(2);
      const next = rest[i + 1];
      if (next && !next.startsWith('--')) {
        flags[key] = next;
        i += 1;
      } else {
        flags[key] = 'true';
      }
    }
  }
  return { command, flags };
}

function validatePasswordStrength(password) {
  if (typeof password !== 'string' || password.length < 12) {
    return 'Password must be at least 12 characters long.';
  }
  if (!/[a-z]/.test(password)) return 'Password must include a lowercase letter.';
  if (!/[A-Z]/.test(password)) return 'Password must include an uppercase letter.';
  if (!/[0-9]/.test(password)) return 'Password must include a digit.';
  if (!/[^A-Za-z0-9]/.test(password)) return 'Password must include a special character.';
  return null;
}

function generateRecoveryCodes(count = 8) {
  const codes = [];
  for (let i = 0; i < count; i += 1) {
    const bytes = crypto.randomBytes(10);
    let raw = '';
    for (let j = 0; j < 10; j += 1) {
      raw += RECOVERY_ALPHABET[bytes[j] % RECOVERY_ALPHABET.length];
    }
    codes.push(`${raw.slice(0, 5)}-${raw.slice(5, 10)}`);
  }
  return codes;
}

function promptSecret(promptText) {
  return new Promise((resolve, reject) => {
    if (!process.stdin.isTTY) {
      const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
      rl.question(promptText, (answer) => {
        rl.close();
        resolve(answer.trim());
      });
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
        // Ctrl+C
        stdin.setRawMode(false);
        stdin.pause();
        stdin.removeListener('data', onData);
        process.stdout.write('\n');
        reject(new Error('Aborted by operator.'));
        return;
      }
      if (ch === '\r' || ch === '\n') {
        stdin.setRawMode(false);
        stdin.pause();
        stdin.removeListener('data', onData);
        process.stdout.write('\n');
        resolve(value);
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

function getSupabaseAdmin() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !serviceRoleKey) {
    throw new Error(
      'Missing NEXT_PUBLIC_SUPABASE_URL (or SUPABASE_URL) or SUPABASE_SERVICE_ROLE_KEY in environment.'
    );
  }
  return createClient(url, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}

async function revokeAllSuperAdminSessions(supabase, adminId) {
  const { error } = await supabase
    .from('user_sessions')
    .update({ revoked_at: new Date().toISOString() })
    .eq('role', 'super_admin')
    .eq('principal_id', adminId)
    .is('revoked_at', null);

  if (error) {
    throw new Error(`Failed revoking existing sessions: ${error.message}`);
  }
}

async function writeAudit(supabase, adminId, action, meta) {
  await supabase.from('audit_logs').insert({
    school_udise: null,
    actor_role: 'cli_operator',
    actor_id: adminId,
    action,
    target_type: 'super_admin',
    target_id: adminId,
    meta_json: meta,
  });
}

async function handleList(supabase) {
  const { data, error } = await supabase
    .from('super_admins')
    .select('id, email, full_name, is_active, totp_enabled, token_version, created_at')
    .order('created_at', { ascending: true });

  if (error) throw new Error(error.message);

  if (!data || data.length === 0) {
    console.log('No Super Admin accounts exist yet. Run `bootstrap` to create one.');
    return;
  }

  console.log('\nRegistered Super Admins:');
  for (const row of data) {
    console.log(
      `  - ${row.email} | ${row.full_name} | active=${row.is_active} | totp=${row.totp_enabled} | tv=${row.token_version} | created=${row.created_at}`
    );
  }
  console.log('');
}

async function resolvePassword(flags) {
  if (flags.password) {
    const err = validatePasswordStrength(flags.password);
    if (err) throw new Error(err);
    return flags.password;
  }
  const first = await promptSecret('Enter new strong password (12+ chars, Aa1!): ');
  const err = validatePasswordStrength(first);
  if (err) throw new Error(err);
  const confirm = await promptSecret('Confirm password: ');
  if (first !== confirm) throw new Error('Passwords do not match.');
  return first;
}

async function handleBootstrap(supabase, flags) {
  const email = String(flags.email || '').trim().toLowerCase();
  const fullName = String(flags.name || '').trim();
  if (!email || !email.includes('@')) {
    throw new Error('Provide a valid --email <email> argument.');
  }
  if (fullName.length < 2) {
    throw new Error('Provide a valid --name "<Full Name>" argument.');
  }

  const password = await resolvePassword(flags);
  const passwordHash = await bcrypt.hash(password, BCRYPT_ROUNDS);
  const recoveryCodes = generateRecoveryCodes(8);
  const recoveryCodesHash = await Promise.all(
    recoveryCodes.map((code) => bcrypt.hash(code, BCRYPT_ROUNDS))
  );

  const { data: existing, error: findErr } = await supabase
    .from('super_admins')
    .select('id, token_version')
    .eq('email', email)
    .maybeSingle();

  if (findErr) throw new Error(findErr.message);

  let adminId;
  if (existing) {
    const nextTv = (existing.token_version || 1) + 1;
    const { data, error } = await supabase
      .from('super_admins')
      .update({
        full_name: fullName,
        password_hash: passwordHash,
        recovery_codes_hash: recoveryCodesHash,
        is_active: true,
        token_version: nextTv,
      })
      .eq('id', existing.id)
      .select('id')
      .single();
    if (error) throw new Error(error.message);
    adminId = data.id;
    await revokeAllSuperAdminSessions(supabase, adminId);
    await writeAudit(supabase, adminId, 'SUPER_ADMIN_CLI_BOOTSTRAP_UPDATED', { email });
    console.log(`\nUpdated Super Admin account: ${email} (sessions revoked, token_version=${nextTv})`);
  } else {
    const { data, error } = await supabase
      .from('super_admins')
      .insert({
        email,
        full_name: fullName,
        password_hash: passwordHash,
        totp_secret: null,
        totp_enabled: false,
        recovery_codes_hash: recoveryCodesHash,
        is_active: true,
        token_version: 1,
      })
      .select('id')
      .single();
    if (error) throw new Error(error.message);
    adminId = data.id;
    await writeAudit(supabase, adminId, 'SUPER_ADMIN_CLI_BOOTSTRAPPED', { email });
    console.log(`\nCreated Super Admin account: ${email} (id=${adminId})`);
  }

  console.log('\nONE-TIME RECOVERY CODES (save in a password manager — never shown again):');
  for (const code of recoveryCodes) {
    console.log(`  ${code}`);
  }
  console.log('\nSign in via the hidden editorial console and enable TOTP MFA immediately.\n');
}

async function handleResetPassword(supabase, flags) {
  const email = String(flags.email || '').trim().toLowerCase();
  if (!email) throw new Error('Provide --email <email>.');

  const { data: existing, error: findErr } = await supabase
    .from('super_admins')
    .select('id, token_version')
    .eq('email', email)
    .maybeSingle();

  if (findErr) throw new Error(findErr.message);
  if (!existing) throw new Error(`No Super Admin found with email ${email}`);

  const password = await resolvePassword(flags);
  const passwordHash = await bcrypt.hash(password, BCRYPT_ROUNDS);
  const nextTv = (existing.token_version || 1) + 1;

  const { error } = await supabase
    .from('super_admins')
    .update({
      password_hash: passwordHash,
      is_active: true,
      token_version: nextTv,
    })
    .eq('id', existing.id);

  if (error) throw new Error(error.message);

  await revokeAllSuperAdminSessions(supabase, existing.id);
  await writeAudit(supabase, existing.id, 'SUPER_ADMIN_CLI_PASSWORD_RESET', { email });
  console.log(`\nPassword reset for ${email}. All active sessions revoked (token_version=${nextTv}).\n`);
}

async function handleResetTotp(supabase, flags) {
  const email = String(flags.email || '').trim().toLowerCase();
  if (!email) throw new Error('Provide --email <email>.');

  const { data: existing, error: findErr } = await supabase
    .from('super_admins')
    .select('id, token_version')
    .eq('email', email)
    .maybeSingle();

  if (findErr) throw new Error(findErr.message);
  if (!existing) throw new Error(`No Super Admin found with email ${email}`);

  const recoveryCodes = generateRecoveryCodes(8);
  const recoveryCodesHash = await Promise.all(
    recoveryCodes.map((code) => bcrypt.hash(code, BCRYPT_ROUNDS))
  );
  const nextTv = (existing.token_version || 1) + 1;

  const { error } = await supabase
    .from('super_admins')
    .update({
      totp_secret: null,
      totp_enabled: false,
      recovery_codes_hash: recoveryCodesHash,
      token_version: nextTv,
    })
    .eq('id', existing.id);

  if (error) throw new Error(error.message);

  await revokeAllSuperAdminSessions(supabase, existing.id);
  await writeAudit(supabase, existing.id, 'SUPER_ADMIN_CLI_TOTP_RESET', { email });

  console.log(`\nTOTP MFA disabled and sessions revoked for ${email} (token_version=${nextTv}).`);
  console.log('Fresh one-time recovery codes (save securely — shown once):');
  for (const code of recoveryCodes) {
    console.log(`  ${code}`);
  }
  console.log('');
}

function printUsage() {
  console.log(`
Students of Bihar (9-12) — CLI-Only Super Admin Recovery Tool

Commands:
  list                                            List Super Admin accounts (no secrets)
  bootstrap --email <e> --name "<Full Name>"      Create or re-bootstrap a Super Admin
  reset-password --email <e>                      Rotate password & revoke all sessions
  reset-totp --email <e>                          Reset TOTP MFA & regenerate recovery codes

Required env vars (from shell or .env.local):
  NEXT_PUBLIC_SUPABASE_URL (or SUPABASE_URL)
  SUPABASE_SERVICE_ROLE_KEY
`);
}

async function main() {
  loadEnvFallback();
  const { command, flags } = parseArgs(process.argv);

  if (!command || command === 'help' || flags.help) {
    printUsage();
    process.exit(0);
  }

  const supabase = getSupabaseAdmin();

  switch (command) {
    case 'list':
      await handleList(supabase);
      break;
    case 'bootstrap':
    case 'create':
      await handleBootstrap(supabase, flags);
      break;
    case 'reset-password':
      await handleResetPassword(supabase, flags);
      break;
    case 'reset-totp':
      await handleResetTotp(supabase, flags);
      break;
    default:
      console.error(`Unknown command: ${command}`);
      printUsage();
      process.exit(1);
  }
}

main().catch((err) => {
  console.error(`\n[super-admin-recovery] ERROR: ${err.message}\n`);
  process.exit(1);
});
