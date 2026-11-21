import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, revokeAllPrincipalSessions, validateCsrf } from '@/lib/auth';
import { requireSchoolAdmin } from '@/lib/auth/school-admin-guard';
import { sanitizePlainText } from '@/lib/sanitize/content';
import type { StudentRow, StudentStream } from '@/types/database';

/**
 * PATCH /api/school/students/[id]
 * Edits student details, activates/deactivates enrollment, or clears forgotten 4-digit PIN.
 * Strictly isolated to `session.schoolUdise`.
 */

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const updateStudentSchema = z.object({
  studentName: z.string().trim().min(2).max(120).optional(),
  fatherName: z.string().trim().max(120).nullable().optional(),
  dob: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  gender: z.enum(['Male', 'Female', 'Other']).nullable().optional(),
  classNum: z.union([z.literal(9), z.literal(10), z.literal(11), z.literal(12)]).optional(),
  stream: z.enum(['UNSET', 'NA', 'Arts', 'Science', 'Commerce']).optional(),
  section: z.string().trim().min(1).max(8).optional(),
  rollNo: z.number().int().min(1).max(99999).optional(),
  isActive: z.boolean().optional(),
  resetPin: z.boolean().optional(),
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

  const { id } = await context.params;
  if (!UUID_REGEX.test(id)) {
    return jsonNoStore({ error: 'Invalid student ID.' }, { status: 400 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON body.' }, { status: 400 });
  }

  const parsed = updateStudentSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Invalid update values.', details: parsed.error.flatten().fieldErrors },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();
  const { data: existing, error: fetchErr } = await supabase
    .from('students')
    .select('id, school_udise, class_num, is_active')
    .eq('id', id)
    .eq('school_udise', udise)
    .maybeSingle();

  if (fetchErr || !existing) {
    return jsonNoStore({ error: 'Student not found in your school.' }, { status: 404 });
  }

  const input = parsed.data;
  const nextClass = input.classNum ?? existing.class_num;
  const updatePayload: Partial<StudentRow> = {};

  if (input.studentName !== undefined) {
    updatePayload.student_name = sanitizePlainText(input.studentName, 120);
  }
  if (input.fatherName !== undefined) {
    updatePayload.father_name = input.fatherName
      ? sanitizePlainText(input.fatherName, 120)
      : null;
  }
  if (input.dob !== undefined) updatePayload.dob = input.dob;
  if (input.gender !== undefined) updatePayload.gender = input.gender;
  if (input.classNum !== undefined) {
    updatePayload.class_num = input.classNum;
    if (input.classNum === 9 || input.classNum === 10) {
      updatePayload.stream = 'NA';
    }
  }
  if (input.stream !== undefined) {
    const resolvedStream: StudentStream =
      nextClass === 9 || nextClass === 10 ? 'NA' : input.stream === 'NA' ? 'UNSET' : input.stream;
    updatePayload.stream = resolvedStream;
  }
  if (input.section !== undefined) updatePayload.section = input.section.toUpperCase();
  if (input.rollNo !== undefined) updatePayload.roll_no = input.rollNo;
  if (input.isActive !== undefined) updatePayload.is_active = input.isActive;
  if (input.resetPin === true) updatePayload.pin_hash = null;

  if (Object.keys(updatePayload).length === 0) {
    return jsonNoStore({ error: 'No changes provided.' }, { status: 400 });
  }

  const { error: updateErr } = await supabase
    .from('students')
    .update(updatePayload)
    .eq('id', id)
    .eq('school_udise', udise);

  if (updateErr) {
    return jsonNoStore({ error: 'Failed to update student record.' }, { status: 500 });
  }

  // Revoke active sessions & bump token_version on deactivation or PIN reset
  if (input.isActive === false || input.resetPin === true) {
    await revokeAllPrincipalSessions(id, 'student');
  }

  await supabase.from('audit_logs').insert({
    school_udise: udise,
    actor_role: session.role,
    actor_id: session.principalId,
    action: input.resetPin
      ? 'SCHOOL_STUDENT_PIN_RESET'
      : input.isActive === false
        ? 'SCHOOL_STUDENT_DEACTIVATED'
        : 'SCHOOL_STUDENT_UPDATED',
    target_type: 'student',
    target_id: id,
    meta_json: { updatedFields: Object.keys(updatePayload) },
  });

  return jsonNoStore({ ok: true });
}
