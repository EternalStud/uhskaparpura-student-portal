import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole, validateCsrf } from '@/lib/auth';
import {
  getUploadPolicyForMime,
  resolveVaultFolderId,
  verifyAndFinalizeUpload,
} from '@/lib/drive/google-one';

/**
 * POST /api/media/finalize
 * Verifies ownership of a `PENDING` media object, validates Drive file metadata
 * AND first-16-byte magic signature via `verifyAndFinalizeUpload`, and flips
 * `media_objects.status = 'ACTIVE'` (or immediately deletes malicious/oversized uploads).
 */

const finalizeSchema = z.object({
  mediaObjectId: z.string().uuid(),
  driveFileId: z.string().regex(/^[A-Za-z0-9_-]{10,128}$/),
});

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(
    ['student', 'teacher', 'school_admin', 'super_admin'],
    request
  );
  if (!auth.ok) return auth.response;
  const { session } = auth;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON request body.' }, { status: 400 });
  }

  const parsed = finalizeSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: 'Invalid finalization payload.' }, { status: 400 });
  }

  const { mediaObjectId, driveFileId } = parsed.data;
  const supabase = getSupabaseAdmin();

  const { data: mediaRow, error: fetchErr } = await supabase
    .from('media_objects')
    .select('id, school_udise, scope, owner_id, mime_type, size_bytes, status')
    .eq('id', mediaObjectId)
    .maybeSingle();

  if (fetchErr || !mediaRow) {
    return jsonNoStore({ error: 'Upload record not found.' }, { status: 404 });
  }

  // Strict owner & tenant check
  if (mediaRow.owner_id !== session.principalId) {
    return jsonNoStore({ error: 'You do not own this upload session.' }, { status: 403 });
  }
  if (session.role !== 'super_admin' && mediaRow.school_udise !== session.schoolUdise) {
    return jsonNoStore({ error: 'Cross-school media access denied.' }, { status: 403 });
  }
  if (mediaRow.status !== 'PENDING') {
    return jsonNoStore(
      { error: `Upload session is already in "${mediaRow.status}" state.` },
      { status: 409 }
    );
  }

  const policy = getUploadPolicyForMime(mediaRow.mime_type);
  if (!policy) {
    await supabase
      .from('media_objects')
      .update({ status: 'DELETED' })
      .eq('id', mediaObjectId);
    return jsonNoStore({ error: 'Disallowed file type.' }, { status: 400 });
  }

  // Anti-IDOR-delete guard #1: block if driveFileId is already claimed by ANY media_objects row
  const { data: existingClaim } = await supabase
    .from('media_objects')
    .select('id')
    .eq('drive_file_id', driveFileId)
    .maybeSingle();

  if (existingClaim) {
    return jsonNoStore(
      { error: 'This storage file identifier is already registered.' },
      { status: 409 }
    );
  }

  // Anti-IDOR-delete guard #2: resolve allowed parent folder(s) for this scope & tenant
  const allowedParentFolderIds: string[] = [];
  try {
    if (mediaRow.scope === 'GLOBAL') {
      allowedParentFolderIds.push(await resolveVaultFolderId({ kind: 'global-curriculum' }));
    } else if (mediaRow.scope === 'EDITORIAL_SUBMISSION' && mediaRow.school_udise) {
      allowedParentFolderIds.push(
        await resolveVaultFolderId({
          kind: 'editorial-submissions',
          schoolUdise: mediaRow.school_udise,
        })
      );
    } else if (mediaRow.scope === 'SCHOOL_PRIVATE' && mediaRow.school_udise) {
      if (session.role === 'student') {
        allowedParentFolderIds.push(
          await resolveVaultFolderId({
            kind: 'school-doubts',
            schoolUdise: mediaRow.school_udise,
          })
        );
      } else {
        const [matFolder, doubtFolder] = await Promise.all([
          resolveVaultFolderId({
            kind: 'school-materials',
            schoolUdise: mediaRow.school_udise,
          }),
          resolveVaultFolderId({
            kind: 'school-doubts',
            schoolUdise: mediaRow.school_udise,
          }),
        ]);
        allowedParentFolderIds.push(matFolder, doubtFolder);
      }
    }
  } catch {
    return jsonNoStore(
      { error: 'Could not verify upload vault folder ownership.' },
      { status: 502 }
    );
  }

  // Enforce both policy size cap and declared session cap (with small 2% transport margin capped at policy.maxBytes)
  const declaredUpper =
    mediaRow.size_bytes > 0
      ? Math.min(policy.maxBytes, Math.ceil(mediaRow.size_bytes * 1.02) + 4096)
      : policy.maxBytes;

  const verified = await verifyAndFinalizeUpload(
    driveFileId,
    mediaRow.mime_type,
    declaredUpper,
    allowedParentFolderIds
  );
  if (!verified.ok) {
    if (verified.deleted) {
      await supabase
        .from('media_objects')
        .update({ status: 'DELETED', drive_file_id: null })
        .eq('id', mediaObjectId);
    }

    return jsonNoStore(
      {
        error: verified.deleted
          ? 'Uploaded file failed security format/size verification and was removed automatically.'
          : 'Uploaded file failed ownership verification.',
        reason: verified.reason,
      },
      { status: verified.deleted ? 422 : 403 }
    );
  }

  const { data: finalizedRow, error: updateErr } = await supabase
    .from('media_objects')
    .update({
      drive_file_id: verified.driveFileId,
      size_bytes: verified.sizeBytes,
      status: 'ACTIVE',
    })
    .eq('id', mediaObjectId)
    .eq('status', 'PENDING')
    .select('id')
    .maybeSingle();

  if (updateErr || !finalizedRow) {
    return jsonNoStore(
      { error: 'Failed to finalize uploaded file metadata.' },
      { status: 409 }
    );
  }

  return jsonNoStore({
    ok: true,
    mediaObjectId,
    mimeType: verified.mimeType,
    sizeBytes: verified.sizeBytes,
    scope: mediaRow.scope,
  });
}
