#!/usr/bin/env node
/**
 * Students of Bihar (9-12) — Automated CLI-Only Supabase SQL Migration Runner
 *
 * SECURITY INVARIANT:
 *   Strictly local CLI tool (zero extra npm dependencies, Node 18+ built-ins only).
 *   NEVER prints secret values (SUPABASE_ACCESS_TOKEN, SUPABASE_DB_URL, etc.)
 *   to stdout or stderr. NEVER add SUPABASE_ACCESS_TOKEN or SUPABASE_DB_URL to Vercel.
 *
 * TRANSPORT MODES (checked in order):
 *   Mode A (Preferred — HTTPS):
 *     SUPABASE_ACCESS_TOKEN -> POST https://api.supabase.com/v1/projects/<ref>/database/query
 *   Mode B (Direct Postgres):
 *     SUPABASE_DB_URL       -> psql "$SUPABASE_DB_URL" -v ON_ERROR_STOP=1 -f <file>
 *
 * USAGE:
 *   node scripts/apply-migrations.mjs                         # apply all pending migrations
 *   node scripts/apply-migrations.mjs --from 004              # apply pending >= 004
 *   node scripts/apply-migrations.mjs --dry-run --from 004    # preview without executing
 *   node scripts/apply-migrations.mjs --file <path>           # apply one specific SQL file
 *   node scripts/apply-migrations.mjs --from 004 --force      # re-apply even if recorded
 */

import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(SCRIPT_DIR, '..');
const MIGRATIONS_DIR = path.join(REPO_ROOT, 'supabase', 'migrations');
const MANAGEMENT_API_BASE = 'https://api.supabase.com/v1';
const QUERY_TIMEOUT_MS = 180_000;
const SUMMARY_TABLES = ['subjects', 'chapters', 'chapter_notes', 'lesson_plans', 'questions'];

// =============================================================================
// ENVIRONMENT LOADING (ZERO SECRET ECHO)
// =============================================================================

function loadEnvFiles() {
  const candidates = Array.from(
    new Set([
      path.resolve(process.cwd(), '.env.local'),
      path.resolve(REPO_ROOT, '.env.local'),
      path.resolve(process.cwd(), '.env'),
      path.resolve(REPO_ROOT, '.env'),
    ])
  );

  const loadedFiles = [];
  for (const filePath of candidates) {
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
  return Array.from(new Set(loadedFiles));
}

function getEnv(name) {
  return (process.env[name] || '').trim();
}

function extractProjectRef(supabaseUrl) {
  if (!supabaseUrl) return { projectRef: null, host: null };
  try {
    const parsed = new URL(supabaseUrl);
    const match = parsed.hostname.match(/^([a-z0-9-]+)\.supabase\.(?:co|in|red)$/i);
    if (match && /^[a-z0-9-]+$/i.test(match[1])) {
      return { projectRef: match[1], host: parsed.host };
    }
    return { projectRef: null, host: parsed.host };
  } catch {
    return { projectRef: null, host: null };
  }
}

function sanitizeErrorText(text, secrets) {
  let out = String(text || '');
  for (const secret of secrets) {
    if (secret && secret.length >= 4) {
      out = out.split(secret).join('[REDACTED]');
    }
  }
  out = out.replace(/(postgres(?:ql)?:\/\/)[^@\s]+@/gi, '$1[REDACTED]@');
  out = out.replace(/(Bearer\s+)[A-Za-z0-9._-]+/gi, '$1[REDACTED]');
  return out.trim();
}

// =============================================================================
// CLI ARGUMENT PARSING
// =============================================================================

function printUsage() {
  console.log(`
Students of Bihar (9-12) — Automated Supabase SQL Migration Runner

Usage:
  node scripts/apply-migrations.mjs [options]

Options:
  --from <prefix>   Apply migrations >= <prefix> lexicographically (e.g. --from 004)
  --file <path>     Apply a single specific SQL file
  --force           Re-apply even if already recorded in public._applied_migrations
  --dry-run         List migrations that would run without executing any SQL
  -h, --help        Show this help message

Examples:
  node scripts/apply-migrations.mjs --dry-run --from 004
  node scripts/apply-migrations.mjs --from 004
  node scripts/apply-migrations.mjs --file supabase/migrations/004_interactive_labs_and_universal_skills.sql
  node scripts/apply-migrations.mjs --from 004 --force
`);
}

function parseArgs(argv) {
  const opts = {
    from: null,
    file: null,
    force: false,
    dryRun: false,
    help: false,
  };

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '-h' || arg === '--help') {
      opts.help = true;
    } else if (arg === '--force') {
      opts.force = true;
    } else if (arg === '--dry-run') {
      opts.dryRun = true;
    } else if (arg === '--from') {
      const next = argv[i + 1];
      if (!next || next.startsWith('-')) {
        throw new Error('Missing value for --from (example: --from 004).');
      }
      opts.from = next;
      i += 1;
    } else if (arg.startsWith('--from=')) {
      const val = arg.slice('--from='.length).trim();
      if (!val) throw new Error('Missing value for --from= (example: --from=004).');
      opts.from = val;
    } else if (arg === '--file') {
      const next = argv[i + 1];
      if (!next || next.startsWith('-')) {
        throw new Error('Missing value for --file (example: --file supabase/migrations/004_...sql).');
      }
      opts.file = next;
      i += 1;
    } else if (arg.startsWith('--file=')) {
      const val = arg.slice('--file='.length).trim();
      if (!val) throw new Error('Missing value for --file= (example: --file=supabase/migrations/004_...sql).');
      opts.file = val;
    } else {
      throw new Error(`Unknown argument "${arg}". Run with --help for usage.`);
    }
  }

  if (opts.from && opts.file) {
    throw new Error('Cannot combine --from and --file. Choose one.');
  }

  return opts;
}

// =============================================================================
// TRANSPORT RESOLUTION & SETUP INSTRUCTIONS
// =============================================================================

function printSetupInstructions() {
  console.log('Setup required (strictly local CLI-only — NEVER add to Vercel!):');
  console.log('  1. Create a Personal Access Token at https://supabase.com/dashboard/account/tokens');
  console.log('  2. Add SUPABASE_ACCESS_TOKEN=<your-token> to local .env.local (or set SUPABASE_DB_URL= for Mode B psql)');
}

function resolveTransport(projectRef) {
  const accessToken = getEnv('SUPABASE_ACCESS_TOKEN');
  if (accessToken) {
    if (!projectRef) {
      throw new Error(
        'SUPABASE_ACCESS_TOKEN is set, but could not extract projectRef from NEXT_PUBLIC_SUPABASE_URL (expected https://<ref>.supabase.co).'
      );
    }
    return {
      mode: 'management-api',
      label: 'Mode A — Supabase Management API (HTTPS)',
      projectRef,
      token: accessToken,
      secrets: [accessToken],
    };
  }

  const dbUrl = getEnv('SUPABASE_DB_URL');
  if (dbUrl) {
    return {
      mode: 'psql',
      label: 'Mode B — Direct PostgreSQL (psql)',
      dbUrl,
      secrets: [dbUrl],
    };
  }

  return null;
}

// =============================================================================
// SQL EXECUTION ADAPTERS (MODE A: HTTPS MANAGEMENT API | MODE B: PSQL)
// =============================================================================

async function runSqlManagementApi(transport, sql) {
  const endpoint = `${MANAGEMENT_API_BASE}/projects/${encodeURIComponent(transport.projectRef)}/database/query`;
  let resp;
  try {
    resp = await fetch(endpoint, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${transport.token}`,
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({ query: sql }),
      signal: AbortSignal.timeout(QUERY_TIMEOUT_MS),
    });
  } catch (err) {
    const msg = sanitizeErrorText(err instanceof Error ? err.message : String(err), transport.secrets);
    throw new Error(`Supabase Management API request failed: ${msg}`);
  }

  const rawText = await resp.text();
  let parsed = null;
  if (rawText.trim()) {
    try {
      parsed = JSON.parse(rawText);
    } catch {
      parsed = null;
    }
  }

  if (!resp.ok) {
    const detail =
      (parsed && typeof parsed === 'object' && (parsed.message || parsed.error || parsed.msg)) ||
      rawText.slice(0, 400) ||
      `HTTP ${resp.status}`;
    const safeDetail = sanitizeErrorText(detail, transport.secrets);
    const authHint =
      resp.status === 401 || resp.status === 403
        ? ' Verify SUPABASE_ACCESS_TOKEN at https://supabase.com/dashboard/account/tokens.'
        : '';
    throw new Error(`Supabase Management API HTTP ${resp.status}: ${safeDetail}${authHint}`);
  }

  return Array.isArray(parsed) ? parsed : [];
}

function runPsqlArgs(transport, args) {
  try {
    return execFileSync('psql', args, {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'pipe'],
      maxBuffer: 64 * 1024 * 1024,
      timeout: QUERY_TIMEOUT_MS,
    });
  } catch (err) {
    if (err && typeof err === 'object' && err.code === 'ENOENT') {
      throw new Error(
        'psql binary not found in PATH. Install PostgreSQL client tools or use Mode A (SUPABASE_ACCESS_TOKEN).'
      );
    }
    const stderr = err && typeof err === 'object' && err.stderr ? String(err.stderr) : '';
    const msg = stderr || (err instanceof Error ? err.message : String(err));
    throw new Error(`psql execution failed: ${sanitizeErrorText(msg, transport.secrets)}`);
  }
}

async function runSqlStatement(transport, sql) {
  if (transport.mode === 'management-api') {
    return runSqlManagementApi(transport, sql);
  }
  runPsqlArgs(transport, [transport.dbUrl, '-X', '-v', 'ON_ERROR_STOP=1', '-c', sql]);
  return [];
}

async function runSqlQueryRows(transport, selectSql) {
  if (transport.mode === 'management-api') {
    return runSqlManagementApi(transport, selectSql);
  }
  const wrappedSql = `SELECT COALESCE(json_agg(row_to_json(t)), '[]'::json) FROM (${selectSql.replace(/;\s*$/, '')}) AS t;`;
  const stdout = runPsqlArgs(transport, [
    transport.dbUrl,
    '-X',
    '-v',
    'ON_ERROR_STOP=1',
    '-t',
    '-A',
    '-c',
    wrappedSql,
  ]);
  const line = stdout.trim();
  if (!line) return [];
  const parsed = JSON.parse(line);
  return Array.isArray(parsed) ? parsed : [];
}

async function runSqlFile(transport, filePath) {
  if (transport.mode === 'management-api') {
    const sql = fs.readFileSync(filePath, 'utf8');
    await runSqlManagementApi(transport, sql);
    return;
  }
  // Safe argv array via execFileSync — zero shell invocation or injection risk.
  runPsqlArgs(transport, [transport.dbUrl, '-v', 'ON_ERROR_STOP=1', '-f', filePath]);
}

// =============================================================================
// TRACKING TABLE & POST-APPLY SUMMARY
// =============================================================================

function escapeSqlLiteral(value) {
  if (value.includes('\0')) {
    throw new Error('Invalid NUL byte in migration filename.');
  }
  return `'${value.replaceAll("'", "''")}'`;
}

async function ensureTrackingTable(transport) {
  const ddl = `
CREATE TABLE IF NOT EXISTS public._applied_migrations (
  filename TEXT PRIMARY KEY,
  sha256 TEXT NOT NULL,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE public._applied_migrations ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public._applied_migrations FROM PUBLIC;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    REVOKE ALL ON TABLE public._applied_migrations FROM anon;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    REVOKE ALL ON TABLE public._applied_migrations FROM authenticated;
  END IF;
END $$;
`;
  await runSqlStatement(transport, ddl);
}

async function fetchAppliedMigrations(transport, { readOnly = false } = {}) {
  const applied = new Map();
  if (readOnly) {
    const existsRows = await runSqlQueryRows(
      transport,
      `SELECT to_regclass('public._applied_migrations') IS NOT NULL AS exists`
    );
    const exists = Boolean(existsRows[0]?.exists);
    if (!exists) return applied;
  }

  const rows = await runSqlQueryRows(
    transport,
    `SELECT filename, sha256, applied_at::text AS applied_at FROM public._applied_migrations ORDER BY filename ASC`
  );
  for (const row of rows) {
    if (row && typeof row.filename === 'string') {
      applied.set(row.filename, {
        sha256: String(row.sha256 || ''),
        appliedAt: String(row.applied_at || ''),
      });
    }
  }
  return applied;
}

async function recordAppliedMigration(transport, filename, sha256) {
  if (!/^[0-9a-f]{64}$/.test(sha256)) {
    throw new Error(`Invalid sha256 digest for ${filename}`);
  }
  const sql = `
INSERT INTO public._applied_migrations (filename, sha256, applied_at)
VALUES (${escapeSqlLiteral(filename)}, ${escapeSqlLiteral(sha256)}, NOW())
ON CONFLICT (filename) DO UPDATE SET
  sha256 = EXCLUDED.sha256,
  applied_at = NOW();
`;
  await runSqlStatement(transport, sql);
}

async function fetchLiveCounts(transport) {
  const unionSql = SUMMARY_TABLES.map(
    (tbl) => `SELECT '${tbl}' AS table_name, COUNT(*)::bigint AS row_count FROM public.${tbl}`
  ).join('\nUNION ALL\n');

  const rows = await runSqlQueryRows(transport, unionSql);
  const counts = new Map();
  for (const row of rows) {
    if (row && typeof row.table_name === 'string') {
      counts.set(row.table_name, Number(row.row_count));
    }
  }
  return counts;
}

// =============================================================================
// FILE DISCOVERY & FORMATTING
// =============================================================================

function inspectMigrationFile(fullPath) {
  const buf = fs.readFileSync(fullPath);
  const sha256 = crypto.createHash('sha256').update(buf).digest('hex');
  return {
    filename: path.basename(fullPath),
    fullPath,
    sizeBytes: buf.byteLength,
    sha256,
  };
}

function resolveSingleFile(rawFileArg) {
  const candidates = [
    path.resolve(process.cwd(), rawFileArg),
    path.resolve(REPO_ROOT, rawFileArg),
    path.resolve(MIGRATIONS_DIR, rawFileArg),
  ];
  for (const candidate of candidates) {
    if (fs.existsSync(candidate) && fs.statSync(candidate).isFile()) {
      return inspectMigrationFile(candidate);
    }
  }
  throw new Error(`SQL file not found: "${rawFileArg}"`);
}

function discoverMigrations(opts) {
  if (opts.file) {
    return {
      targets: [resolveSingleFile(opts.file)],
      skippedByPrefix: [],
    };
  }

  if (!fs.existsSync(MIGRATIONS_DIR)) {
    throw new Error(`Migrations directory not found: ${MIGRATIONS_DIR}`);
  }

  const allFiles = fs
    .readdirSync(MIGRATIONS_DIR)
    .filter((name) => !name.startsWith('.') && name.endsWith('.sql'))
    .sort((a, b) => (a < b ? -1 : a > b ? 1 : 0));

  const skippedByPrefix = [];
  const targets = [];

  for (const name of allFiles) {
    if (opts.from && name < opts.from) {
      skippedByPrefix.push(name);
      continue;
    }
    targets.push(inspectMigrationFile(path.join(MIGRATIONS_DIR, name)));
  }

  return { targets, skippedByPrefix };
}

function formatKb(bytes) {
  return `${(bytes / 1024).toFixed(1)} KB`;
}

// =============================================================================
// MAIN RUNNER
// =============================================================================

async function main() {
  const opts = parseArgs(process.argv.slice(2));
  if (opts.help) {
    printUsage();
    process.exit(0);
  }

  const loadedFiles = loadEnvFiles();
  const supabaseUrl = getEnv('NEXT_PUBLIC_SUPABASE_URL');
  const { projectRef } = extractProjectRef(supabaseUrl);
  const transport = resolveTransport(projectRef);
  const { targets, skippedByPrefix } = discoverMigrations(opts);

  console.log('\n======================================================================');
  console.log(' Students of Bihar (9-12) — Automated Supabase SQL Migration Runner');
  console.log('======================================================================');
  console.log(
    ` Env files loaded : ${loadedFiles.length > 0 ? loadedFiles.join(', ') : '(none — shell env only)'}`
  );
  console.log(` Project ref      : ${projectRef || '(not detected from NEXT_PUBLIC_SUPABASE_URL)'}`);
  console.log(
    ` Transport        : ${transport ? transport.label : '(not configured — set SUPABASE_ACCESS_TOKEN or SUPABASE_DB_URL)'}`
  );
  console.log(
    ` Target scope     : ${
      opts.file
        ? `--file ${path.relative(REPO_ROOT, targets[0].fullPath)}`
        : `supabase/migrations/*.sql${opts.from ? ` (from prefix "${opts.from}")` : ' (all)'}`
    }`
  );
  console.log(
    ` Mode             : ${opts.dryRun ? 'DRY RUN (no SQL executed)' : 'LIVE APPLY'}${opts.force ? ' + --force' : ''}`
  );

  if (skippedByPrefix.length > 0) {
    console.log(` Skipped (< ${opts.from}) : ${skippedByPrefix.length} file(s) (${skippedByPrefix.join(', ')})`);
  }

  if (targets.length === 0) {
    console.log('\n No matching .sql migration files found.\n');
    process.exit(0);
  }

  // DRY-RUN MODE: preview files without executing any writes
  if (opts.dryRun) {
    let appliedMap = null;
    if (transport) {
      try {
        appliedMap = await fetchAppliedMigrations(transport, { readOnly: true });
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        console.log(`\n [WARN] Could not query public._applied_migrations (${msg}); listing all matched files.`);
      }
    }

    console.log('\n[ Dry-Run Migration Plan ]');
    let wouldRunCount = 0;
    let skippedAppliedCount = 0;

    for (const file of targets) {
      const recorded = appliedMap?.get(file.filename);
      if (recorded && !opts.force) {
        skippedAppliedCount += 1;
        const drift = recorded.sha256 && recorded.sha256 !== file.sha256 ? ' [local sha256 changed]' : '';
        console.log(
          `  [SKIP]       ${file.filename}  (${formatKb(file.sizeBytes)}, already applied${drift})`
        );
      } else {
        wouldRunCount += 1;
        const actionTag = recorded && opts.force ? '[RE-APPLY]  ' : '[WOULD RUN] ';
        console.log(
          `  ${actionTag} ${file.filename}  (${formatKb(file.sizeBytes)}, sha256:${file.sha256.slice(0, 12)})`
        );
      }
    }

    console.log('\n----------------------------------------------------------------------');
    console.log(
      ` DRY-RUN SUMMARY: ${wouldRunCount} file(s) would run | ${skippedAppliedCount} already applied | ${skippedByPrefix.length} before --from`
    );
    console.log('----------------------------------------------------------------------');

    if (!transport) {
      console.log('');
      printSetupInstructions();
    }
    console.log('');
    process.exit(0);
  }

  // LIVE APPLY MODE: require a valid transport
  if (!transport) {
    console.log('');
    printSetupInstructions();
    console.log('');
    process.exit(1);
  }

  const totalStart = performance.now();
  await ensureTrackingTable(transport);
  const appliedMap = await fetchAppliedMigrations(transport);

  console.log('\n[ Applying Migrations ]');
  let appliedCount = 0;
  let skippedCount = 0;

  for (const file of targets) {
    const recorded = appliedMap.get(file.filename);
    if (recorded && !opts.force) {
      skippedCount += 1;
      const driftNote =
        recorded.sha256 && recorded.sha256 !== file.sha256
          ? ' — local sha256 changed, pass --force to re-apply'
          : '';
      console.log(`  [SKIP]       ${file.filename} (already applied${driftNote})`);
      continue;
    }

    const fileStart = performance.now();
    await runSqlFile(transport, file.fullPath);
    await recordAppliedMigration(transport, file.filename, file.sha256);
    const elapsedMs = Math.round(performance.now() - fileStart);
    appliedCount += 1;

    const tag = recorded ? '[RE-APPLIED]' : '[APPLIED]   ';
    console.log(
      `  ${tag} ${file.filename}  (${elapsedMs} ms, ${formatKb(file.sizeBytes)}, sha256:${file.sha256.slice(0, 12)})`
    );
  }

  const totalElapsedMs = Math.round(performance.now() - totalStart);

  console.log('\n[ Live Post-Apply Row Counts ]');
  try {
    const counts = await fetchLiveCounts(transport);
    for (const tbl of SUMMARY_TABLES) {
      const val = counts.has(tbl) ? counts.get(tbl) : 'n/a';
      console.log(`  public.${tbl.padEnd(16)} : ${val}`);
    }
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.log(`  [WARN] Post-apply count summary skipped (${msg}).`);
  }

  console.log('\n----------------------------------------------------------------------');
  console.log(
    ` SUMMARY: ${appliedCount} applied | ${skippedCount} skipped | ${totalElapsedMs} ms total`
  );
  console.log('----------------------------------------------------------------------\n');
}

main().catch((err) => {
  const secrets = [getEnv('SUPABASE_ACCESS_TOKEN'), getEnv('SUPABASE_DB_URL')];
  const msg = sanitizeErrorText(err instanceof Error ? err.message : String(err), secrets);
  console.error(`\n[apply-migrations] ERROR: ${msg}\n`);
  process.exit(1);
});
