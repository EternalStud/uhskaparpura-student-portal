import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import {
  jsonNoStore,
  requireRole,
  validateCsrf,
  consumePrincipalRateLimit,
} from '@/lib/auth';
import {
  createResumableUploadSession,
  getUploadPolicyForMime,
  resolveVaultFolderId,
  type VaultFolderTarget,
} from '@/lib/drive/google-one';
import { getIstDayBoundsUtc } from '@/lib/time/ist';
import type { MediaScope } from '@/types/database';

/**
 * POST /api/media/upload-session
 * Issues a single-use direct resumable upload URI (zero OAuth tokens exposed to client)
 * after enforcing CSRF, role permissions, MIME/size allowlist, and IST daily quotas:
 * - Student: 5 uploads/day (Images <= 5 MB for Open Doubt Board only)
 * - Teacher / School Admin: 20 uploads/day
 * - School total: 500 MB/day across all school uploads
 */

const STUDENT_DAILY_UPLOAD_LIMIT = 5;
const TEACHER_DAILY_UPLOAD_LIMIT = 20;
const SCHOOL_DAILY_BYTES_LIMIT = 500 * 1024 * 1024; // 500 MB / IST day

const uploadSessionRequestSchema = z.object({
  fileName: z.string().trim().min(1).max(200),
  mimeType: z.string().trim().min(3).max(120),
  sizeBytes: z.number().int().positive(),
  purpose: z.enum([
    'MATERIAL',
    'DOUBT',
    'DOUBT_ANSWER',
    'EDITORIAL_SUBMISSION',
    'GLOBAL_CURRICULUM',
  ]),
});

const EDITORIAL_ALLOWED_MIMES = new Set([
  'application/pdf',
  'image/jpeg',
  'image/png',
  'image/webp',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
]);

const DOUBT_ANSWER_ALLOWED_MIMES = new Set([
  'application/pdf',
  'image/jpeg',
  'image/png',
  'image/webp',
]);

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(
    ['student', 'teacher', 'school_admin', 'super_admin'],
    request
  );
  if (!auth.ok) return auth.response;
  const { session } = auth;

  // Anti-burst guard (max 30 session requests per 5 mins per principal)
  const burst = await consumePrincipalRateLimit(
    'media-upload-session',
    session.principalId,
    30,
    5 * 60 * 1000
  );
  if (!burst.allowed) {
    return jsonNoStore(
      { error: 'Too many upload requests. Please wait a few minutes and try again.' },
      { status: 429 }
    );
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON request body.' }, { status: 400 });
  }

  const parsed = uploadSessionRequestSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Invalid upload parameters.', details: parsed.error.flatten().fieldErrors },
      { status: 400 }
    );
  }

  const { fileName, mimeType, sizeBytes, purpose } = parsed.data;
  const normalizedMime = mimeType.toLowerCase().split(';')[0] ?? '';
  const policy = getUploadPolicyForMime(normalizedMime);

  if (!policy) {
    return jsonNoStore(
      {
        error:
          'Unsupported file format. Only approved PDF, JPG/PNG/WEBP images, Office documents, or MP4/WEBM videos are allowed.',
      },
      { status: 400 }
    );
  }

  if (sizeBytes > policy.maxBytes) {
    const maxMb = Math.round(policy.maxBytes / (1024 * 1024));
    return jsonNoStore(
      { error: `File is too large. Maximum allowed size for this format is ${maxMb} MB.` },
      { status: 400 }
    );
  }

  // Enforce role <-> purpose & MIME scope permissions
  let scope: MediaScope;
  let folderTarget: VaultFolderTarget;
  let schoolUdise: string | null = session.schoolUdise;

  if (purpose === 'GLOBAL_CURRICULUM') {
    if (session.role !== 'super_admin') {
      return jsonNoStore({ error: 'Insufficient permissions for global curriculum uploads.' }, { status: 403 });
    }
    scope = 'GLOBAL';
    schoolUdise = null;
    folderTarget = { kind: 'global-curriculum' };
  } else if (purpose === 'DOUBT') {
    if (session.role !== 'student' || !session.schoolUdise) {
      return jsonNoStore({ error: 'Only enrolled students can attach doubt images.' }, { status: 403 });
    }
    if (policy.category !== 'IMAGE') {
      return jsonNoStore(
        { error: 'Only JPG, PNG, or WEBP photos (up to 5 MB) are allowed on the Doubt Board.' },
        { status: 400 }
      );
    }
    scope = 'SCHOOL_PRIVATE';
    folderTarget = { kind: 'school-doubts', schoolUdise: session.schoolUdise };
  } else if (purpose === 'DOUBT_ANSWER') {
    if ((session.role !== 'teacher' && session.role !== 'school_admin') || !session.schoolUdise) {
      return jsonNoStore({ error: 'Only verified teachers can attach solution files.' }, { status: 403 });
    }
    if (!DOUBT_ANSWER_ALLOWED_MIMES.has(normalizedMime)) {
      return jsonNoStore(
        { error: 'Only PDF or JPG/PNG/WEBP images are allowed for doubt answers.' },
        { status: 400 }
      );
    }
    scope = 'SCHOOL_PRIVATE';
    folderTarget = { kind: 'school-doubts', schoolUdise: session.schoolUdise };
  } else if (purpose === 'MATERIAL') {
    if ((session.role !== 'teacher' && session.role !== 'school_admin') || !session.schoolUdise) {
      return jsonNoStore({ error: 'Only verified teachers can upload classroom materials.' }, { status: 403 });
    }
    scope = 'SCHOOL_PRIVATE';
    folderTarget = { kind: 'school-materials', schoolUdise: session.schoolUdise };
  } else {
    // EDITORIAL_SUBMISSION
    if ((session.role !== 'teacher' && session.role !== 'school_admin') || !session.schoolUdise) {
      return jsonNoStore({ error: 'Only verified teachers can submit question papers.' }, { status: 403 });
    }
    if (!EDITORIAL_ALLOWED_MIMES.has(normalizedMime)) {
      return jsonNoStore(
        { error: 'Only PDF, Word (.docx), Excel (.xlsx), or Image files are accepted for question paper submissions.' },
        { status: 400 }
      );
    }
    scope = 'EDITORIAL_SUBMISSION';
    folderTarget = { kind: 'editorial-submissions', schoolUdise: session.schoolUdise };
  }

  const supabase = getSupabaseAdmin();

  // Enforce IST daily quotas for non-super-admin uploads
  if (session.role !== 'super_admin' && schoolUdise) {
    const { startIso, endIso } = getIstDayBoundsUtc();
    const userLimit =
      session.role === 'student' ? STUDENT_DAILY_UPLOAD_LIMIT : TEACHER_DAILY_UPLOAD_LIMIT;

    const [{ count: userCount, error: userQuotaErr }, { data: schoolRows, error: schoolQuotaErr }] =
      await Promise.all([
        supabase
          .from('media_objects')
          .select('id', { count: 'exact', head: true })
          .eq('owner_id', session.principalId)
          .in('status', ['PENDING', 'ACTIVE'])
          .gte('created_at', startIso)
          .lte('created_at', endIso),
        supabase
          .from('media_objects')
          .select('size_bytes')
          .eq('school_udise', schoolUdise)
          .in('status', ['PENDING', 'ACTIVE'])
          .gte('created_at', startIso)
          .lte('created_at', endIso),
      ]);

    if (userQuotaErr || schoolQuotaErr) {
      return jsonNoStore({ error: 'Could not verify daily upload quota.' }, { status: 500 });
    }

    if ((userCount ?? 0) >= userLimit) {
      return jsonNoStore(
        {
          error: `Daily upload limit reached (${userLimit} files per day). Please try again tomorrow.`,
        },
        { status: 429 }
      );
    }

    const usedSchoolBytesToday = (schoolRows ?? []).reduce(
      (sum, r) => sum + (Number(r.size_bytes) || 0),
      0
    );
    if (usedSchoolBytesToday + sizeBytes > SCHOOL_DAILY_BYTES_LIMIT) {
      return jsonNoStore(
        {
          error: 'School daily upload quota (500 MB/day) reached. Please try again tomorrow.',
        },
        { status: 429 }
      );
    }
  }

  const requestOrigin = request.headers.get('origin') || process.env.NEXT_PUBLIC_APP_URL || '';

  try {
    const folderId = await resolveVaultFolderId(folderTarget);
    const uploadSession = await createResumableUploadSession({
      folderId,
      fileName,
      mimeType: normalizedMime,
      expectedSizeBytes: sizeBytes,
      origin: requestOrigin,
    });

    const { data: mediaRow, error: insertErr } = await supabase
      .from('media_objects')
      .insert({
        school_udise: schoolUdise,
        scope,
        owner_role: session.role,
        owner_id: session.principalId,
        original_filename: uploadSession.sanitizedFileName,
        mime_type: uploadSession.mimeType,
        size_bytes: sizeBytes,
        status: 'PENDING',
      })
      .select('id')
      .single();

    if (insertErr || !mediaRow) {
      return jsonNoStore({ error: 'Failed to create upload tracking record.' }, { status: 500 });
    }

    return jsonNoStore({
      mediaObjectId: mediaRow.id,
      uploadUrl: uploadSession.uploadUrl,
      maxBytes: uploadSession.maxBytes,
      mimeType: uploadSession.mimeType,
      sanitizedFileName: uploadSession.sanitizedFileName,
    });
  } catch (err) {
    return jsonNoStore(
      {
        error:
          err instanceof Error
            ? err.message
            : 'File upload service is temporarily unavailable.',
      },
      { status: 502 }
    );
  }
}
