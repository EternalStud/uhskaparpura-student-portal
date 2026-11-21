import { NextResponse } from 'next/server';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { streamDriveFile } from '@/lib/drive/google-one';

/**
 * GET /api/public-assets/[id]
 * Cacheable public curriculum asset stream (v2.4 Cache-Deception-Proof Split Route).
 *
 * Security invariants:
 * - Serves ONLY `scope = 'GLOBAL'` AND `status = 'ACTIVE'` objects.
 * - Strictly refuses school-private or editorial-submission assets (404).
 * - Never reads or sets session cookies.
 * - Sets immutable public CDN caching + `X-Content-Type-Options: nosniff`.
 */

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function safeContentDispositionFilename(name: string): string {
  return name.replace(/[^A-Za-z0-9._-]/g, '_').slice(0, 100) || 'asset';
}

export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const { id } = await context.params;
  if (!UUID_REGEX.test(id)) {
    return NextResponse.json({ error: 'Not found.' }, { status: 404 });
  }

  const supabase = getSupabaseAdmin();
  const { data: media, error } = await supabase
    .from('media_objects')
    .select('id, drive_file_id, mime_type, original_filename, scope, status')
    .eq('id', id)
    .eq('scope', 'GLOBAL')
    .eq('status', 'ACTIVE')
    .maybeSingle();

  if (error || !media || !media.drive_file_id) {
    return NextResponse.json(
      { error: 'Asset not found.' },
      { status: 404, headers: { 'Cache-Control': 'no-store' } }
    );
  }

  try {
    const streamed = await streamDriveFile(
      media.drive_file_id,
      request.headers.get('range')
    );

    const headers = new Headers();
    headers.set('Content-Type', media.mime_type);
    headers.set('Cache-Control', 'public, max-age=86400, s-maxage=604800, immutable');
    headers.set('X-Content-Type-Options', 'nosniff');
    headers.set('Accept-Ranges', streamed.acceptRanges);
    headers.set(
      'Content-Disposition',
      `inline; filename="${safeContentDispositionFilename(media.original_filename)}"`
    );
    if (streamed.contentLength) headers.set('Content-Length', streamed.contentLength);
    if (streamed.contentRange) headers.set('Content-Range', streamed.contentRange);

    return new Response(streamed.stream, {
      status: streamed.status,
      headers,
    });
  } catch {
    return NextResponse.json(
      { error: 'Unable to load asset right now.' },
      { status: 502, headers: { 'Cache-Control': 'no-store' } }
    );
  }
}
