import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, validateCsrf } from '@/lib/auth';
import { requireSchoolAdmin } from '@/lib/auth/school-admin-guard';
import { getCurrentAcademicYear } from '@/lib/time/ist';
import { sanitizePlainText } from '@/lib/sanitize/content';
import type { ClassNum, StudentStream } from '@/types/database';

/**
 * GET / POST /api/school/students
 * School-scoped student roster management.
 * Privacy invariant: NEVER accepts, stores, or returns Aadhaar No, Social Category, or `pin_hash`.
 */

const createStudentSchema = z.object({
  studentCode: z
    .string()
    .trim()
    .regex(/^\d{6,20}$/, 'Student Code must be 6–20 numeric digits')
    .nullable()
    .optional(),
  studentName: z.string().trim().min(2).max(120),
  fatherName: z.string().trim().max(120).nullable().optional(),
  dob: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'DOB must be YYYY-MM-DD'),
  gender: z.enum(['Male', 'Female', 'Other']).nullable().optional(),
  classNum: z.union([z.literal(9), z.literal(10), z.literal(11), z.literal(12)]),
  stream: z.enum(['UNSET', 'NA', 'Arts', 'Science', 'Commerce']).optional(),
  section: z.string().trim().min(1).max(8).optional(),
  rollNo: z.number().int().min(1).max(99999),
});

export async function GET(request: Request) {
  const auth = await requireSchoolAdmin(request);
  if (!auth.ok) return auth.response;
  const udise = auth.session.schoolUdise;

  const url = new URL(request.url);
  const q = (url.searchParams.get('q') || '').trim();
  const classParam = url.searchParams.get('classNum');
  const streamParam = url.searchParams.get('stream');
  const activeParam = url.searchParams.get('active') || 'true';
  const page = Math.max(1, Number.parseInt(url.searchParams.get('page') || '1', 10) || 1);
  const limit = Math.min(100, Math.max(10, Number.parseInt(url.searchParams.get('limit') || '50', 10) || 50));
  const offset = (page - 1) * limit;

  const supabase = getSupabaseAdmin();
  let query = supabase
    .from('students')
    .select(
      'id, student_code, student_name, father_name, dob, gender, class_num, stream, section, roll_no, academic_year, is_active, subjects_configured, mastery_points, weekly_points, streak_days, pin_hash, created_at',
      { count: 'exact' }
    )
    .eq('school_udise', udise);

  if (classParam && ['9', '10', '11', '12'].includes(classParam)) {
    query = query.eq('class_num', Number(classParam) as ClassNum);
  }
  if (
    streamParam &&
    ['UNSET', 'NA', 'Arts', 'Science', 'Commerce'].includes(streamParam)
  ) {
    query = query.eq('stream', streamParam as StudentStream);
  }
  if (activeParam === 'true') {
    query = query.eq('is_active', true);
  } else if (activeParam === 'false') {
    query = query.eq('is_active', false);
  }

  if (q) {
    // Strip PostgREST filter syntax chars to avoid filter injection
    const safeQ = q.replace(/[%(),.*]/g, '').trim();
    if (safeQ) {
      if (/^\d+$/.test(safeQ)) {
        query = query.or(
          `student_code.ilike.%${safeQ}%,roll_no.eq.${Number.parseInt(safeQ, 10)}`
        );
      } else {
        query = query.or(
          `student_name.ilike.%${safeQ}%,father_name.ilike.%${safeQ}%`
        );
      }
    }
  }

  const { data, count, error } = await query
    .order('class_num', { ascending: true })
    .order('roll_no', { ascending: true })
    .range(offset, offset + limit - 1);

  if (error) {
    return jsonNoStore({ error: 'Failed to load student list.' }, { status: 500 });
  }

  // Strip pin_hash -> expose only boolean hasPin
  const students = (data ?? []).map((row) => ({
    id: row.id,
    studentCode: row.student_code,
    studentName: row.student_name,
    fatherName: row.father_name,
    dob: row.dob,
    gender: row.gender,
    classNum: row.class_num,
    stream: row.stream,
    section: row.section,
    rollNo: row.roll_no,
    academicYear: row.academic_year,
    isActive: row.is_active,
    subjectsConfigured: row.subjects_configured,
    masteryPoints: row.mastery_points,
    weeklyPoints: row.weekly_points,
    streakDays: row.streak_days,
    hasPin: Boolean(row.pin_hash),
  }));

  return jsonNoStore({
    students,
    total: count ?? students.length,
    page,
    limit,
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

  const parsed = createStudentSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Please check the student details entered.', details: parsed.error.flatten().fieldErrors },
      { status: 400 }
    );
  }

  const input = parsed.data;
  const supabase = getSupabaseAdmin();

  if (input.studentCode) {
    const { data: existing } = await supabase
      .from('students')
      .select('id, school_udise, is_active')
      .eq('student_code', input.studentCode)
      .maybeSingle();

    if (existing) {
      if (existing.school_udise !== udise) {
        return jsonNoStore(
          {
            error:
              'This Student Code is already registered at another school. Contact support for an official transfer.',
          },
          { status: 409 }
        );
      }
      return jsonNoStore(
        { error: 'A student with this Student Code already exists in your school.' },
        { status: 409 }
      );
    }
  }

  const normalizedStream: StudentStream =
    input.classNum === 9 || input.classNum === 10
      ? 'NA'
      : input.stream && input.stream !== 'NA'
        ? input.stream
        : 'UNSET';

  const { data: created, error } = await supabase
    .from('students')
    .insert({
      student_code: input.studentCode || null,
      school_udise: udise,
      student_name: sanitizePlainText(input.studentName, 120),
      father_name: input.fatherName ? sanitizePlainText(input.fatherName, 120) : null,
      dob: input.dob,
      gender: input.gender ?? null,
      class_num: input.classNum,
      stream: normalizedStream,
      section: (input.section || 'A').toUpperCase(),
      roll_no: input.rollNo,
      academic_year: getCurrentAcademicYear(),
      is_active: true,
    })
    .select('id, student_code, student_name, class_num, roll_no')
    .single();

  if (error || !created) {
    return jsonNoStore({ error: 'Could not add student record.' }, { status: 500 });
  }

  await supabase.from('audit_logs').insert({
    school_udise: udise,
    actor_role: session.role,
    actor_id: session.principalId,
    action: 'SCHOOL_STUDENT_CREATED',
    target_type: 'student',
    target_id: created.id,
    meta_json: { classNum: created.class_num, rollNo: created.roll_no },
  });

  return jsonNoStore({ ok: true, student: created }, { status: 201 });
}
