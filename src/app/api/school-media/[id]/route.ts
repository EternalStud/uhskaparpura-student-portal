import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole } from '@/lib/auth';
import { streamDriveFile } from '@/lib/drive/google-one';

/**
 * GET /api/school-media/[id]
 * Authenticated, strictly school-isolated private media stream (v2.4 Cache-Deception-Proof).
 *
 * Security invariants:
 * - Authenticated principal ONLY (`media.school_udise === session.schoolUdise`).
 * - Editorial submissions visible ONLY to submitting teacher, their School Admin, or Super Admin.
 * - Mandatory anti-CDN-cache headers: `Cache-Control: private, no-store`,
 *   `CDN-Cache-Control: no-store`, `Cloudflare-CDN-Cache-Control: no-store`,
 *   `X-Content-Type-Options: nosniff`.
 */

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const ATTACHMENT_MIMES = new Set([
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation',
]);

function safeFilename(name: string): string {
  return name.replace(/[^A-Za-z0-9._-]/g, '_').slice(0, 100) || 'document';
}

export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const auth = await requireRole(
    ['student', 'teacher', 'school_admin', 'super_admin'],
    request
  );
  if (!auth.ok) return auth.response;
  const { session } = auth;

  const { id } = await context.params;
  if (!UUID_REGEX.test(id)) {
    return jsonNoStore({ error: 'Not found.' }, { status: 404 });
  }

  const supabase = getSupabaseAdmin();
  const { data: media, error } = await supabase
    .from('media_objects')
    .select('id, drive_file_id, school_udise, scope, owner_id, mime_type, original_filename, status')
    .eq('id', id)
    .eq('status', 'ACTIVE')
    .maybeSingle();

  if (error || !media || !media.drive_file_id) {
    return jsonNoStore({ error: 'Resource not found.' }, { status: 404 });
  }

  // Strict multi-tenant isolation
  if (session.role !== 'super_admin') {
    if (!media.school_udise || media.school_udise !== session.schoolUdise) {
      return jsonNoStore({ error: 'Resource not found.' }, { status: 404 });
    }
    if (media.scope === 'EDITORIAL_SUBMISSION') {
      const canSeeSubmission =
        session.role === 'school_admin' ||
        (session.role === 'teacher' && media.owner_id === session.principalId);
      if (!canSeeSubmission) {
        return jsonNoStore({ error: 'Forbidden.' }, { status: 403 });
      }
    }
  }

  try {
    const streamed = await streamDriveFile(
      media.drive_file_id,
      request.headers.get('range')
    );

    const url = new URL(request.url);
    const forceDownload =
      url.searchParams.get('download') === '1' || ATTACHMENT_MIMES.has(media.mime_type);
    const disposition = forceDownload ? 'attachment' : 'inline';

    const headers = new Headers();
    headers.set('Content-Type', media.mime_type);
    headers.set('Cache-Control', 'private, no-store, no-cache, must-revalidate');
    headers.set('CDN-Cache-Control', 'no-store');
    headers.set('Cloudflare-CDN-Cache-Control', 'no-store');
    headers.set('Pragma', 'no-cache');
    headers.set('Expires', '0');
    headers.set('Vary', 'Cookie');
    headers.set('X-Content-Type-Options', 'nosniff');
    headers.set('Accept-Ranges', streamed.acceptRanges);
    headers.set(
      'Content-Disposition',
      `${disposition}; filename="${safeFilename(media.original_filename)}"`
    );
    if (streamed.contentLength) headers.set('Content-Length', streamed.contentLength);
    if (streamed.contentRange) headers.set('Content-Range', streamed.contentRange);

    return new Response(streamed.stream, {
      status: streamed.status,
      headers,
    });
  } catch {
    return jsonNoStore({ error: 'Unable to load file right now.' }, { status: 502 });
  }
}
