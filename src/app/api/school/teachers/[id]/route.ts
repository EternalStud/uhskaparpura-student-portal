import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import {
  generateActivationCode,
  generateResetCode,
  hashPassword,
  jsonNoStore,
  revokeAllPrincipalSessions,
  validateCsrf,
} from '@/lib/auth';
import { requireSchoolAdmin } from '@/lib/auth/school-admin-guard';
import { sanitizePlainText } from '@/lib/sanitize/content';
import type { ClassNum, SchoolTeacherRow, TeacherRow } from '@/types/database';

/**
 * PATCH /api/school/teachers/[id]
 * Supports:
 * - Updating assigned_classes, assigned_subject_ids, fullName, teacherTitle
 * - Toggling isSchoolAdmin / isActive (STRICTLY blocks self-deactivation & removing last active School Admin!)
 * - Resetting teacher password (STRICTLY blocks cross-school privilege escalation if teacher has active posting/admin role at any other school!)
 * - Generating a fresh 6-digit activation code for unactivated teachers
 */

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const RESET_CODE_TTL_MS = 24 * 60 * 60 * 1000; // 24 hours

const patchTeacherSchema = z.object({
  action: z.enum(['UPDATE', 'RESET_PASSWORD', 'GENERATE_ACTIVATION_CODE']).default('UPDATE'),
  fullName: z.string().trim().min(2).max(120).optional(),
  teacherTitle: z.string().trim().max(100).nullable().optional(),
  assignedClasses: z
    .array(z.union([z.literal(9), z.literal(10), z.literal(11), z.literal(12)]))
    .optional(),
  assignedSubjectIds: z.array(z.string().trim().min(1).max(80)).optional(),
  isSchoolAdmin: z.boolean().optional(),
  isActive: z.boolean().optional(),
});

export async function PATCH(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireSchoolAdmin(request);
  if (!auth.ok) return auth.response;
  const { session } = auth;
  const udise = session.schoolUdise;

  const { id: teacherId } = await context.params;
  if (!UUID_REGEX.test(teacherId)) {
    return jsonNoStore({ error: 'Invalid teacher ID.' }, { status: 400 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON request body.' }, { status: 400 });
  }

  const parsed = patchTeacherSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Invalid staff update payload.', details: parsed.error.flatten().fieldErrors },
      { status: 400 }
    );
  }

  const input = parsed.data;
  const supabase = getSupabaseAdmin();

  const { data: posting, error: postErr } = await supabase
    .from('school_teachers')
    .select('id, school_udise, teacher_id, is_school_admin, is_active')
    .eq('school_udise', udise)
    .eq('teacher_id', teacherId)
    .maybeSingle();

  if (postErr || !posting) {
    return jsonNoStore({ error: 'Teacher not found in your school.' }, { status: 404 });
  }

  // =========================================================================
  // PASSWORD RESET OR ACTIVATION CODE GENERATION (CROSS-SCHOOL GUARDED)
  // =========================================================================
  if (input.action === 'RESET_PASSWORD' || input.action === 'GENERATE_ACTIVATION_CODE') {
    if (!posting.is_active) {
      return jsonNoStore(
        { error: 'Cannot issue credentials for a deactivated teacher.' },
        { status: 400 }
      );
    }

    // Critical security invariant: block if teacher has ANY active posting or admin role at another school!
    const { data: otherSchoolPostings } = await supabase
      .from('school_teachers')
      .select('school_udise, is_active, is_school_admin')
      .eq('teacher_id', teacherId)
      .neq('school_udise', udise);

    const hasConflictingOtherSchool = (otherSchoolPostings ?? []).some(
      (p) => p.is_active || p.is_school_admin
    );
    if (hasConflictingOtherSchool) {
      return jsonNoStore(
        {
          error:
            'Security block: this teacher holds an active posting or administrator role at another school. Password reset cannot be performed from this school.',
        },
        { status: 403 }
      );
    }

    if (input.action === 'RESET_PASSWORD') {
      const resetCode = generateResetCode(8);
      const resetCodeHash = await hashPassword(resetCode);
      const expiresAtIso = new Date(Date.now() + RESET_CODE_TTL_MS).toISOString();

      const { error: updateErr } = await supabase
        .from('teachers')
        .update({
          reset_code_hash: resetCodeHash,
          reset_code_expires_at: expiresAtIso,
          must_change_password: true,
        })
        .eq('id', teacherId);

      if (updateErr) {
        return jsonNoStore({ error: 'Failed to generate password reset code.' }, { status: 500 });
      }

      // Immediately revoke ALL active sessions and bump token_version
      await revokeAllPrincipalSessions(teacherId, 'teacher');

      await supabase.from('audit_logs').insert({
        school_udise: udise,
        actor_role: session.role,
        actor_id: session.principalId,
        action: 'SCHOOL_TEACHER_PASSWORD_RESET_ISSUED',
        target_type: 'teacher',
        target_id: teacherId,
        meta_json: { expiresAt: expiresAtIso },
      });

      return jsonNoStore({
        ok: true,
        resetCode,
        expiresAt: expiresAtIso,
      });
    }

    // GENERATE_ACTIVATION_CODE
    const activationCode = generateActivationCode();
    const activationCodeHash = await hashPassword(activationCode);

    const { error: updateErr } = await supabase
      .from('teachers')
      .update({ activation_code_hash: activationCodeHash })
      .eq('id', teacherId);

    if (updateErr) {
      return jsonNoStore({ error: 'Failed to issue activation code.' }, { status: 500 });
    }

    await supabase.from('audit_logs').insert({
      school_udise: udise,
      actor_role: session.role,
      actor_id: session.principalId,
      action: 'SCHOOL_TEACHER_ACTIVATION_CODE_ISSUED',
      target_type: 'teacher',
      target_id: teacherId,
      meta_json: {},
    });

    return jsonNoStore({
      ok: true,
      activationCode,
    });
  }

  // =========================================================================
  // STANDARD PROFILE / ASSIGNMENT / STATUS / ADMIN ROLE UPDATE
  // =========================================================================

  // Block self-deactivation or self-demotion
  if (teacherId === session.principalId) {
    if (input.isActive === false) {
      return jsonNoStore(
        { error: 'You cannot deactivate your own active administrator account.' },
        { status: 400 }
      );
    }
    if (input.isSchoolAdmin === false) {
      return jsonNoStore(
        { error: 'You cannot remove your own School Admin access directly.' },
        { status: 400 }
      );
    }
  }

  // Block removing or deactivating the LAST active School Admin in the school!
  const removingAdminPrivilege =
    posting.is_school_admin &&
    posting.is_active &&
    (input.isActive === false || input.isSchoolAdmin === false);

  if (removingAdminPrivilege) {
    const { count: otherActiveAdmins } = await supabase
      .from('school_teachers')
      .select('id', { count: 'exact', head: true })
      .eq('school_udise', udise)
      .eq('is_active', true)
      .eq('is_school_admin', true)
      .neq('teacher_id', teacherId);

    if ((otherActiveAdmins ?? 0) === 0) {
      return jsonNoStore(
        {
          error:
            'Cannot deactivate or demote the last active School Administrator. Assign another active teacher as School Admin first.',
        },
        { status: 400 }
      );
    }
  }

  // If reactivating, ensure teacher isn't active at another school!
  if (input.isActive === true && !posting.is_active) {
    const { data: activeElsewhere } = await supabase
      .from('school_teachers')
      .select('school_udise')
      .eq('teacher_id', teacherId)
      .eq('is_active', true)
      .neq('school_udise', udise)
      .maybeSingle();

    if (activeElsewhere) {
      return jsonNoStore(
        {
          error:
            'Cannot reactivate: this teacher is currently active at another school.',
        },
        { status: 409 }
      );
    }
  }

  const teacherUpdate: Partial<TeacherRow> = {};
  if (input.fullName !== undefined) {
    teacherUpdate.full_name = sanitizePlainText(input.fullName, 120);
  }
  if (input.teacherTitle !== undefined) {
    teacherUpdate.teacher_title = input.teacherTitle
      ? sanitizePlainText(input.teacherTitle, 100)
      : null;
  }

  if (Object.keys(teacherUpdate).length > 0) {
    const { error: tErr } = await supabase
      .from('teachers')
      .update(teacherUpdate)
      .eq('id', teacherId);
    if (tErr) {
      return jsonNoStore({ error: 'Failed to update teacher profile.' }, { status: 500 });
    }
  }

  const postingUpdate: Partial<SchoolTeacherRow> = {};
  if (input.assignedClasses !== undefined) {
    postingUpdate.assigned_classes = Array.from(new Set(input.assignedClasses)).sort(
      (a, b) => a - b
    ) as ClassNum[];
  }
  if (input.assignedSubjectIds !== undefined) {
    const uniqueSubjs = Array.from(new Set(input.assignedSubjectIds));
    postingUpdate.assigned_subject_ids = uniqueSubjs;
    postingUpdate.subjects_configured = uniqueSubjs.length > 0;

    // Automatically derive & merge class_num (9–12) from selected subjects so
    // assigned_classes is never left empty when a teacher has subjects assigned.
    const mergedClasses = new Set<ClassNum>(postingUpdate.assigned_classes ?? []);
    if (uniqueSubjs.length > 0) {
      const { data: subjClasses } = await supabase
        .from('subjects')
        .select('class_num')
        .in('id', uniqueSubjs);
      for (const row of subjClasses ?? []) {
        if (
          row.class_num === 9 ||
          row.class_num === 10 ||
          row.class_num === 11 ||
          row.class_num === 12
        ) {
          mergedClasses.add(row.class_num);
        }
      }
    }
    if (input.assignedClasses !== undefined || uniqueSubjs.length > 0) {
      postingUpdate.assigned_classes = Array.from(mergedClasses).sort((a, b) => a - b);
    } else if (uniqueSubjs.length === 0) {
      postingUpdate.assigned_classes = [];
    }
  }
  if (input.isSchoolAdmin !== undefined) {
    postingUpdate.is_school_admin = input.isSchoolAdmin;
  }
  if (input.isActive !== undefined) {
    postingUpdate.is_active = input.isActive;
    postingUpdate.deactivated_at = input.isActive ? null : new Date().toISOString();
  }

  if (Object.keys(postingUpdate).length > 0) {
    const { error: pErr } = await supabase
      .from('school_teachers')
      .update(postingUpdate)
      .eq('id', posting.id);
    if (pErr) {
      return jsonNoStore({ error: 'Failed to update school assignment.' }, { status: 500 });
    }
  }

  // Revoke active sessions immediately on deactivation or School Admin demotion
  if (input.isActive === false || (posting.is_school_admin && input.isSchoolAdmin === false)) {
    await revokeAllPrincipalSessions(teacherId, 'teacher');
  }

  await supabase.from('audit_logs').insert({
    school_udise: udise,
    actor_role: session.role,
    actor_id: session.principalId,
    action:
      input.isActive === false
        ? 'SCHOOL_TEACHER_DEACTIVATED'
        : input.isSchoolAdmin !== undefined
          ? 'SCHOOL_TEACHER_ROLE_UPDATED'
          : 'SCHOOL_TEACHER_UPDATED',
    target_type: 'teacher',
    target_id: teacherId,
    meta_json: {
      updatedFields: [...Object.keys(teacherUpdate), ...Object.keys(postingUpdate)],
    },
  });

  return jsonNoStore({ ok: true });
}
