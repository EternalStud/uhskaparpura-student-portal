import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole, validateCsrf } from '@/lib/auth';
import {
  matchSchoolNames,
  parseStudentExcel,
  parseTeacherExcel,
} from '@/lib/excel/eshikshakosh';

/**
 * POST /api/super-admin/onboard/preview
 * Step 1–2 of the 3-Step School Onboarding Wizard:
 * - Accepts Teacher List `.xlsx` (authoritative 11-digit UDISE + District/Block/Cluster + School Name)
 *   AND Student List `.xlsx` (Class 9–12 students; discards Aadhaar & Social Category in memory).
 * - Cross-validates school name via punctuation-insensitive matcher.
 * - Flags any existing school or cross-school active user conflicts.
 * - Returns candidate teacher roster so Super Admin selects initial School Admin(s).
 */

export async function POST(request: Request) {
  const csrf = validateCsrf(request, { allowMultipart: true });
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  let formData: FormData;
  try {
    formData = await request.formData();
  } catch {
    return jsonNoStore({ error: 'Expected multipart upload with Excel files.' }, { status: 400 });
  }

  const teacherFile = formData.get('teacherFile');
  const studentFile = formData.get('studentFile');

  if (!(teacherFile instanceof File) || teacherFile.size === 0 || !teacherFile.name.toLowerCase().endsWith('.xlsx')) {
    return jsonNoStore(
      { error: 'Authoritative Teacher List (.xlsx) is required to extract UDISE & school metadata.' },
      { status: 400 }
    );
  }
  if (!(studentFile instanceof File) || studentFile.size === 0 || !studentFile.name.toLowerCase().endsWith('.xlsx')) {
    return jsonNoStore(
      { error: 'Student List (.xlsx) is required for onboarding preview.' },
      { status: 400 }
    );
  }

  const [teacherBuf, studentBuf] = await Promise.all([
    teacherFile.arrayBuffer().then((b) => Buffer.from(b)),
    studentFile.arrayBuffer().then((b) => Buffer.from(b)),
  ]);

  const teacherParsed = parseTeacherExcel(teacherBuf);
  const studentParsed = parseStudentExcel(studentBuf);

  const errors: string[] = [...teacherParsed.errors, ...studentParsed.errors];
  const warnings: string[] = [...teacherParsed.warnings, ...studentParsed.warnings];

  const udiseCode = teacherParsed.schoolMeta.udiseCode;
  const schoolName = teacherParsed.schoolMeta.schoolName || studentParsed.banner.schoolName || '';

  if (!udiseCode) {
    errors.push('Could not extract a valid 11-digit School UDISE Code from Teacher List.');
  }

  // Punctuation-insensitive cross-check between Teacher List & Student List school names
  const studentSchoolSample =
    studentParsed.banner.schoolName || studentParsed.students[0]?.schoolName || '';
  const teacherSchoolSample =
    teacherParsed.teachers[0]?.schoolName || teacherParsed.schoolMeta.schoolName || '';

  const schoolNameMatch =
    studentSchoolSample && teacherSchoolSample
      ? matchSchoolNames(studentSchoolSample, teacherSchoolSample)
      : {
          matched: false,
          exactNormalized: false,
          normalizedA: studentSchoolSample,
          normalizedB: teacherSchoolSample,
          tokenOverlap: 0,
        };

  if (studentSchoolSample && teacherSchoolSample && !schoolNameMatch.matched) {
    warnings.push(
      `School name mismatch between Teacher List ("${teacherSchoolSample}") and Student List ("${studentSchoolSample}"). Verify both files belong to the same school.`
    );
  }

  const supabase = getSupabaseAdmin();
  let existingSchool: { udise_code: string; school_name: string; status: string } | null = null;
  let crossSchoolStudentConflicts = 0;
  let crossSchoolTeacherConflicts = 0;

  if (udiseCode) {
    const [{ data: existing }, { data: stuConflicts }, { data: tchLookup }] = await Promise.all([
      supabase
        .from('schools')
        .select('udise_code, school_name, status')
        .eq('udise_code', udiseCode)
        .maybeSingle(),
      studentParsed.students.length > 0
        ? supabase
            .from('students')
            .select('student_code, school_udise')
            .in(
              'student_code',
              studentParsed.students.map((s) => s.studentCode)
            )
            .eq('is_active', true)
            .neq('school_udise', udiseCode)
        : Promise.resolve({ data: [] }),
      teacherParsed.teachers.length > 0
        ? supabase
            .from('teachers')
            .select('id, teacher_code')
            .in(
              'teacher_code',
              teacherParsed.teachers.map((t) => t.teacherCode)
            )
        : Promise.resolve({ data: [] }),
    ]);

    existingSchool = existing ?? null;
    crossSchoolStudentConflicts = (stuConflicts ?? []).length;

    const existingTeacherIds = (tchLookup ?? []).map((t) => t.id);
    if (existingTeacherIds.length > 0) {
      const { count } = await supabase
        .from('school_teachers')
        .select('id', { count: 'exact', head: true })
        .in('teacher_id', existingTeacherIds)
        .eq('is_active', true)
        .neq('school_udise', udiseCode);
      crossSchoolTeacherConflicts = count ?? 0;
    }
  }

  if (existingSchool) {
    warnings.push(
      `School UDISE ${existingSchool.udise_code} (${existingSchool.school_name}) already exists with status ${existingSchool.status}. Committing will update/merge roster safely.`
    );
  }
  if (crossSchoolStudentConflicts > 0) {
    warnings.push(
      `${crossSchoolStudentConflicts} student(s) are currently active at another school and will be skipped to prevent cross-school hijack.`
    );
  }
  if (crossSchoolTeacherConflicts > 0) {
    warnings.push(
      `${crossSchoolTeacherConflicts} teacher(s) are currently active at another school and will be skipped.`
    );
  }

  return jsonNoStore({
    ok: errors.length === 0 && Boolean(udiseCode) && teacherParsed.teachers.length > 0,
    schoolMeta: {
      ...teacherParsed.schoolMeta,
      schoolName,
    },
    existingSchool,
    schoolNameMatch,
    teacherStats: teacherParsed.stats,
    studentStats: studentParsed.stats,
    discardedSensitiveColumns: studentParsed.discardedSensitiveColumns,
    crossSchoolStudentConflicts,
    crossSchoolTeacherConflicts,
    // Teacher list for Super Admin to select initial School Admin(s)
    teachers: teacherParsed.teachers.map((t) => ({
      teacherCode: t.teacherCode,
      fullName: t.fullName,
      teacherTitle: t.teacherTitle,
      maskedMobile: t.mobileLast4 ? `XXXXXX${t.mobileLast4}` : null,
      suggestedAdmin: Boolean(
        t.teacherTitle && /head|principal|incharge|प्रधानाध्यापक/i.test(t.teacherTitle)
      ),
    })),
    sampleStudents: studentParsed.students.slice(0, 15).map((s) => ({
      studentCode: s.studentCode,
      studentName: s.studentName,
      classNum: s.classNum,
      rollNo: s.rollNo,
      dob: s.dob,
    })),
    errors,
    warnings,
  });
}
