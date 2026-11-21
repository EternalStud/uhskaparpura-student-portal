import { getSupabaseAdmin } from '@/lib/supabase/server';
import { constantTimeEqual, jsonNoStore } from '@/lib/auth';
import { deleteDriveFile } from '@/lib/drive/google-one';

/**
 * GET / POST /api/cron/media-gc
 * Vercel Cron daily garbage collector (02:30 IST).
 * - Authenticated strictly via `Authorization: Bearer ${CRON_SECRET}` (constant-time compare).
 * - Deletes orphaned Drive files for `PENDING` > 2 hours old and `DELETE_QUEUED` media objects,
 *   then marks them `DELETED`.
 * - Also prunes expired sessions (> 7 days old) and stale rate-limit windows (> 24 hours old).
 */

const STALE_PENDING_MS = 2 * 60 * 60 * 1000; // 2 hours
const MAX_BATCH_SIZE = 50;

function authorizeCronRequest(request: Request): { ok: true } | { ok: false; status: number; error: string } {
  const cronSecret = (process.env.CRON_SECRET || '').trim();
  if (!cronSecret || cronSecret.length < 16) {
    return { ok: false, status: 500, error: 'CRON_SECRET is not configured.' };
  }
  const authHeader = (request.headers.get('authorization') || '').trim();
  const expected = `Bearer ${cronSecret}`;
  if (!constantTimeEqual(authHeader, expected)) {
    return { ok: false, status: 401, error: 'Unauthorized.' };
  }
  return { ok: true };
}

async function runMediaGarbageCollection(request: Request) {
  const auth = authorizeCronRequest(request);
  if (!auth.ok) {
    return jsonNoStore({ error: auth.error }, { status: auth.status });
  }

  const supabase = getSupabaseAdmin();
  const staleCutoffIso = new Date(Date.now() - STALE_PENDING_MS).toISOString();

  const [{ data: queuedRows }, { data: stalePendingRows }] = await Promise.all([
    supabase
      .from('media_objects')
      .select('id, drive_file_id, status')
      .eq('status', 'DELETE_QUEUED')
      .order('created_at', { ascending: true })
      .limit(MAX_BATCH_SIZE),
    supabase
      .from('media_objects')
      .select('id, drive_file_id, status')
      .eq('status', 'PENDING')
      .lt('created_at', staleCutoffIso)
      .order('created_at', { ascending: true })
      .limit(MAX_BATCH_SIZE),
  ]);

  const candidates = [...(queuedRows ?? []), ...(stalePendingRows ?? [])].slice(0, MAX_BATCH_SIZE);
  let deletedCount = 0;
  let failedCount = 0;

  for (const row of candidates) {
    try {
      if (row.drive_file_id) {
        await deleteDriveFile(row.drive_file_id);
      }
      await supabase
        .from('media_objects')
        .update({ status: 'DELETED' })
        .eq('id', row.id);
      deletedCount++;
    } catch {
      failedCount++;
    }
  }

  // Secondary housekeeping: prune expired sessions (> 7d) and stale rate-limit buckets (> 24h)
  const sessionCutoffIso = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
  const rateLimitCutoffIso = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();

  const [{ count: prunedSessions }, { count: prunedRateLimits }] = await Promise.all([
    supabase
      .from('user_sessions')
      .delete({ count: 'exact' })
      .lt('expires_at', sessionCutoffIso),
    supabase
      .from('auth_rate_limits')
      .delete({ count: 'exact' })
      .lt('window_start', rateLimitCutoffIso)
      .is('blocked_until', null),
  ]);

  return jsonNoStore({
    ok: true,
    scannedMedia: candidates.length,
    deletedMedia: deletedCount,
    failedMedia: failedCount,
    prunedSessions: prunedSessions ?? 0,
    prunedRateLimits: prunedRateLimits ?? 0,
    ranAt: new Date().toISOString(),
  });
}

export async function GET(request: Request) {
  return runMediaGarbageCollection(request);
}

export async function POST(request: Request) {
  return runMediaGarbageCollection(request);
}
