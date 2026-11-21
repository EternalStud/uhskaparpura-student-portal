import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import {
  jsonNoStore,
  requireRole,
  revokeAllPrincipalSessions,
  validateCsrf,
} from '@/lib/auth';
import { sanitizePlainText } from '@/lib/sanitize/content';
import type { SchoolRow } from '@/types/database';

/**
 * GET / PATCH /api/super-admin/schools/[udise]
 * Super-Admin-only school status management (ACTIVE / SUSPENDED / ONBOARDING),
 * Hindi name updates, and School Admin role assignment.
 */

const UDISE_REGEX = /^\d{11}$/;

const patchSchoolSchema = z.object({
  status: z.enum(['ONBOARDING', 'ACTIVE', 'SUSPENDED']).optional(),
  schoolNameHi: z.string().trim().max(200).nullable().optional(),
  toggleAdminTeacherId: z.string().uuid().optional(),
  isSchoolAdmin: z.boolean().optional(),
});

export async function GET(
  request: Request,
  context: { params: Promise<{ udise: string }> }
) {
  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  const { udise } = await context.params;
  if (!UDISE_REGEX.test(udise)) {
    return jsonNoStore({ error: 'Invalid 11-digit UDISE code.' }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();
  const [{ data: school }, { data: postings }, { data: syncLogs }] = await Promise.all([
    supabase.from('schools').select('*').eq('udise_code', udise).maybeSingle(),
    supabase
      .from('school_teachers')
      .select('teacher_id, is_school_admin, is_active, joined_at')
      .eq('school_udise', udise),
    supabase
      .from('sync_logs')
      .select('id, sync_type, added_count, updated_count, deactivated_count, skipped_count, created_at')
      .eq('school_udise', udise)
      .order('created_at', { ascending: false })
      .limit(10),
  ]);

  if (!school) {
    return jsonNoStore({ error: 'School not found.' }, { status: 404 });
  }

  const teacherIds = (postings ?? []).map((p) => p.teacher_id);
  const { data: teacherRows } =
    teacherIds.length > 0
      ? await supabase
          .from('teachers')
          .select('id, teacher_code, full_name, teacher_title, mobile_last4')
          .in('id', teacherIds)
      : { data: [] };

  const teacherMap = new Map((teacherRows ?? []).map((t) => [t.id, t]));
  const teachers = (postings ?? [])
    .map((p) => {
      const t = teacherMap.get(p.teacher_id);
      if (!t) return null;
      return {
        teacherId: t.id,
        teacherCode: t.teacher_code,
        fullName: t.full_name,
        teacherTitle: t.teacher_title,
        maskedMobile: t.mobile_last4 ? `XXXXXX${t.mobile_last4}` : null,
        isSchoolAdmin: p.is_school_admin,
        isActive: p.is_active,
        joinedAt: p.joined_at,
      };
    })
    .filter((x): x is NonNullable<typeof x> => x !== null);

  return jsonNoStore({
    school,
    teachers,
    syncLogs: syncLogs ?? [],
  });
}

export async function PATCH(
  request: Request,
  context: { params: Promise<{ udise: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  const { udise } = await context.params;
  if (!UDISE_REGEX.test(udise)) {
    return jsonNoStore({ error: 'Invalid 11-digit UDISE code.' }, { status: 400 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON body.' }, { status: 400 });
  }

  const parsed = patchSchoolSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: 'Invalid update parameters.' }, { status: 400 });
  }

  const input = parsed.data;
  const supabase = getSupabaseAdmin();

  const { data: school } = await supabase
    .from('schools')
    .select('udise_code, status')
    .eq('udise_code', udise)
    .maybeSingle();

  if (!school) {
    return jsonNoStore({ error: 'School not found.' }, { status: 404 });
  }

  // Toggle School Admin assignment for a teacher
  if (input.toggleAdminTeacherId && typeof input.isSchoolAdmin === 'boolean') {
    if (!input.isSchoolAdmin) {
      const { count: otherAdmins } = await supabase
        .from('school_teachers')
        .select('id', { count: 'exact', head: true })
        .eq('school_udise', udise)
        .eq('is_active', true)
        .eq('is_school_admin', true)
        .neq('teacher_id', input.toggleAdminTeacherId);

      if ((otherAdmins ?? 0) === 0 && school.status === 'ACTIVE') {
        return jsonNoStore(
          { error: 'Active school must retain at least one School Admin.' },
          { status: 400 }
        );
      }
    }

    const { error: adminErr } = await supabase
      .from('school_teachers')
      .update({ is_school_admin: input.isSchoolAdmin })
      .eq('school_udise', udise)
      .eq('teacher_id', input.toggleAdminTeacherId);

    if (adminErr) {
      return jsonNoStore({ error: 'Failed to update School Admin assignment.' }, { status: 500 });
    }

    if (!input.isSchoolAdmin) {
      await revokeAllPrincipalSessions(input.toggleAdminTeacherId, 'teacher');
    }

    await supabase.from('audit_logs').insert({
      school_udise: udise,
      actor_role: 'super_admin',
      actor_id: session.principalId,
      action: input.isSchoolAdmin
        ? 'SUPER_ADMIN_GRANTED_SCHOOL_ADMIN'
        : 'SUPER_ADMIN_REVOKED_SCHOOL_ADMIN',
      target_type: 'teacher',
      target_id: input.toggleAdminTeacherId,
      meta_json: {},
    });
  }

  const schoolPatch: Partial<SchoolRow> = {};
  if (input.status !== undefined) schoolPatch.status = input.status;
  if (input.schoolNameHi !== undefined) {
    schoolPatch.school_name_hi = input.schoolNameHi
      ? sanitizePlainText(input.schoolNameHi, 200)
      : null;
  }

  if (Object.keys(schoolPatch).length > 0) {
    const { error: updErr } = await supabase
      .from('schools')
      .update(schoolPatch)
      .eq('udise_code', udise);
    if (updErr) {
      return jsonNoStore({ error: 'Failed to update school.' }, { status: 500 });
    }

    // Revoke all active sessions for this school immediately upon suspension
    if (input.status === 'SUSPENDED') {
      await supabase
        .from('user_sessions')
        .update({ revoked_at: new Date().toISOString() })
        .eq('school_udise', udise)
        .is('revoked_at', null);
    }

    await supabase.from('audit_logs').insert({
      school_udise: udise,
      actor_role: 'super_admin',
      actor_id: session.principalId,
      action: 'SUPER_ADMIN_SCHOOL_UPDATED',
      target_type: 'school',
      target_id: udise,
      meta_json: schoolPatch,
    });
  }

  return jsonNoStore({ ok: true });
}
