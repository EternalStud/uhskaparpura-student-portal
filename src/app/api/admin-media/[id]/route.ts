import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole } from '@/lib/auth';
import { streamDriveFile } from '@/lib/drive/google-one';

/**
 * GET /api/admin-media/[id]
 * Strictly Super-Admin-only private media stream for side-by-side editorial
 * review of submitted scanned PDFs, images, Word, and Excel question papers.
 */

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function safeFilename(name: string): string {
  return name.replace(/[^A-Za-z0-9._-]/g, '_').slice(0, 100) || 'submission';
}

export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  const { id } = await context.params;
  if (!UUID_REGEX.test(id)) {
    return jsonNoStore({ error: 'Not found.' }, { status: 404 });
  }

  const supabase = getSupabaseAdmin();
  const { data: media, error } = await supabase
    .from('media_objects')
    .select('id, drive_file_id, mime_type, original_filename, status')
    .eq('id', id)
    .in('status', ['ACTIVE', 'PENDING'])
    .maybeSingle();

  if (error || !media || !media.drive_file_id) {
    return jsonNoStore({ error: 'Media object not found.' }, { status: 404 });
  }

  try {
    const streamed = await streamDriveFile(
      media.drive_file_id,
      request.headers.get('range')
    );

    const url = new URL(request.url);
    const forceDownload = url.searchParams.get('download') === '1';
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
    return jsonNoStore({ error: 'Failed to stream media file.' }, { status: 502 });
  }
}
