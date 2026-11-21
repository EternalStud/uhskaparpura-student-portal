import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import {
  generateActivationCode,
  generateSessionToken,
  hashIndianMobile,
  hashPassword,
  jsonNoStore,
  validateCsrf,
} from '@/lib/auth';
import { requireSchoolAdmin } from '@/lib/auth/school-admin-guard';
import { sanitizePlainText } from '@/lib/sanitize/content';
import type { ClassNum } from '@/types/database';

/**
 * GET / POST /api/school/teachers
 * School-scoped teacher roster & subject assignment management.
 * Privacy invariant: exposes ONLY masked mobile (`XXXXXX1234`), NEVER hashes or plaintext mobiles.
 */

const createTeacherSchema = z.object({
  teacherCode: z
    .string()
    .trim()
    .min(4)
    .max(24)
    .regex(/^[A-Za-z0-9_-]+$/, 'Teacher ID must be alphanumeric'),
  fullName: z.string().trim().min(2).max(120),
  teacherTitle: z.string().trim().max(100).nullable().optional(),
  mobileNo: z.string().trim().max(20).nullable().optional(),
  isSchoolAdmin: z.boolean().optional(),
  assignedClasses: z
    .array(z.union([z.literal(9), z.literal(10), z.literal(11), z.literal(12)]))
    .optional(),
  assignedSubjectIds: z.array(z.string().trim().min(1).max(80)).optional(),
});

export async function GET(request: Request) {
  const auth = await requireSchoolAdmin(request);
  if (!auth.ok) return auth.response;
  const udise = auth.session.schoolUdise;
  const supabase = getSupabaseAdmin();

  const [{ data: postings, error: postErr }, { data: subjects, error: subjErr }] =
    await Promise.all([
      supabase
        .from('school_teachers')
        .select(
          'id, teacher_id, is_school_admin, is_active, subjects_configured, assigned_classes, assigned_subject_ids, joined_at, deactivated_at'
        )
        .eq('school_udise', udise)
        .order('is_active', { ascending: false })
        .order('is_school_admin', { ascending: false }),
      supabase
        .from('subjects')
        .select('id, bseb_code, class_num, stream, category, name_en, name_hi')
        .order('class_num', { ascending: true })
        .order('sort_order', { ascending: true }),
    ]);

  if (postErr || subjErr) {
    return jsonNoStore({ error: 'Failed to load staff roster.' }, { status: 500 });
  }

  const teacherIds = (postings ?? []).map((p) => p.teacher_id);
  const teacherMap = new Map<
    string,
    {
      id: string;
      teacher_code: string;
      full_name: string;
      teacher_title: string | null;
      mobile_last4: string | null;
      must_change_password: boolean;
    }
  >();

  if (teacherIds.length > 0) {
    const { data: teacherRows } = await supabase
      .from('teachers')
      .select('id, teacher_code, full_name, teacher_title, mobile_last4, must_change_password')
      .in('id', teacherIds);

    for (const row of teacherRows ?? []) {
      teacherMap.set(row.id, row);
    }
  }

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
        mustChangePassword: t.must_change_password,
        isSchoolAdmin: p.is_school_admin,
        isActive: p.is_active,
        subjectsConfigured: p.subjects_configured,
        assignedClasses: p.assigned_classes ?? [],
        assignedSubjectIds: p.assigned_subject_ids ?? [],
        joinedAt: p.joined_at,
        deactivatedAt: p.deactivated_at,
      };
    })
    .filter((x): x is NonNullable<typeof x> => x !== null)
    .sort((a, b) => a.fullName.localeCompare(b.fullName));

  return jsonNoStore({
    teachers,
    subjects: subjects ?? [],
    currentTeacherId: auth.session.principalId,
  });
}

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireSchoolAdmin(request);
  if (!auth.ok) return auth.response;
  const { session } = auth;
  const udise = session.schoolUdise;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON request body.' }, { status: 400 });
  }

  const parsed = createTeacherSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Please check teacher details.', details: parsed.error.flatten().fieldErrors },
      { status: 400 }
    );
  }

  const input = parsed.data;
  const supabase = getSupabaseAdmin();

  const mobileInfo = input.mobileNo ? hashIndianMobile(input.mobileNo) : null;
  if (input.mobileNo && !mobileInfo) {
    return jsonNoStore(
      { error: 'Mobile number must be a valid 10-digit Indian mobile number.' },
      { status: 400 }
    );
  }

  // Check whether teacher already exists globally
  const { data: existingTeacher } = await supabase
    .from('teachers')
    .select('id, teacher_code')
    .eq('teacher_code', input.teacherCode)
    .maybeSingle();

  let teacherId: string;
  let oneTimeActivationCode: string | null = null;

  if (existingTeacher) {
    // Enforce single-active-school invariant: block hijack if active at another school!
    const { data: activeOther } = await supabase
      .from('school_teachers')
      .select('school_udise')
      .eq('teacher_id', existingTeacher.id)
      .eq('is_active', true)
      .neq('school_udise', udise)
      .maybeSingle();

    if (activeOther) {
      return jsonNoStore(
        {
          error:
            'This Teacher ID is currently active at another school. Previous school must deactivate their posting before joining here.',
        },
        { status: 409 }
      );
    }

    teacherId = existingTeacher.id;
  } else {
    oneTimeActivationCode = generateActivationCode();
    const [activationCodeHash, placeholderPasswordHash] = await Promise.all([
      hashPassword(oneTimeActivationCode),
      hashPassword(generateSessionToken().slice(0, 32)),
    ]);

    const { data: created, error: createErr } = await supabase
      .from('teachers')
      .insert({
        teacher_code: input.teacherCode,
        full_name: sanitizePlainText(input.fullName, 120),
        teacher_title: input.teacherTitle ? sanitizePlainText(input.teacherTitle, 100) : null,
        mobile_last4: mobileInfo?.mobileLast4 ?? null,
        mobile_hash: mobileInfo?.mobileHash ?? null,
        password_hash: placeholderPasswordHash,
        must_change_password: true,
        activation_code_hash: activationCodeHash,
      })
      .select('id')
      .single();

    if (createErr || !created) {
      return jsonNoStore({ error: 'Could not create teacher account.' }, { status: 500 });
    }
    teacherId = created.id;
  }

  const assignedClasses: ClassNum[] = Array.from(new Set(input.assignedClasses ?? []));
  const assignedSubjectIds = Array.from(new Set(input.assignedSubjectIds ?? []));

  const { error: postingErr } = await supabase.from('school_teachers').upsert(
    {
      school_udise: udise,
      teacher_id: teacherId,
      is_school_admin: Boolean(input.isSchoolAdmin),
      is_active: true,
      deactivated_at: null,
      subjects_configured: assignedSubjectIds.length > 0,
      assigned_classes: assignedClasses,
      assigned_subject_ids: assignedSubjectIds,
    },
    { onConflict: 'school_udise,teacher_id' }
  );

  if (postingErr) {
    return jsonNoStore(
      { error: 'Could not assign teacher to this school.' },
      { status: 409 }
    );
  }

  await supabase.from('audit_logs').insert({
    school_udise: udise,
    actor_role: session.role,
    actor_id: session.principalId,
    action: 'SCHOOL_TEACHER_ADDED',
    target_type: 'teacher',
    target_id: teacherId,
    meta_json: { isSchoolAdmin: Boolean(input.isSchoolAdmin) },
  });

  return jsonNoStore(
    {
      ok: true,
      teacherId,
      activationCode: oneTimeActivationCode,
    },
    { status: 201 }
  );
}
