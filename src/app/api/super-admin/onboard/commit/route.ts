import { getSupabaseAdmin } from '@/lib/supabase/server';
import {
  generateSessionToken,
  hashPassword,
  jsonNoStore,
  requireRole,
  validateCsrf,
} from '@/lib/auth';
import {
  matchSchoolNames,
  parseStudentExcel,
  parseTeacherExcel,
} from '@/lib/excel/eshikshakosh';
import { ensureSchoolVaultFolders } from '@/lib/drive/google-one';
import { getCurrentAcademicYear } from '@/lib/time/ist';
import { sanitizePlainText } from '@/lib/sanitize/content';
import type { SyncConflictItem } from '@/types/database';

/**
 * POST /api/super-admin/onboard/commit
 * Step 3 of the 3-Step School Onboarding Wizard:
 * - Re-parses Teacher List & Student List `.xlsx` files strictly server-side.
 * - Creates/updates `schools` row with authoritative 11-digit UDISE + District/Block/Cluster.
 * - Optionally provisions private Google One vault folder hierarchy (`schools/{udise}/...`).
 * - Upserts teachers (marking chosen `adminTeacherCodes` as `is_school_admin = true`, zero plaintext mobile).
 * - Upserts Class 9–12 students (zero Aadhaar / Social Category persisted).
 * - Blocks cross-school hijack of active students or teachers.
 * - Writes `sync_logs` (`ONBOARDING`) & `audit_logs`.
 */

export async function POST(request: Request) {
  const csrf = validateCsrf(request, { allowMultipart: true });
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  let formData: FormData;
  try {
    formData = await request.formData();
  } catch {
    return jsonNoStore({ error: 'Expected multipart upload.' }, { status: 400 });
  }

  const teacherFile = formData.get('teacherFile');
  const studentFile = formData.get('studentFile');
  const adminCodesRaw = String(formData.get('adminTeacherCodes') || '[]');
  const schoolNameHiRaw = String(formData.get('schoolNameHi') || '').trim();
  const activateImmediately = String(formData.get('activateImmediately') || 'true') === 'true';
  const confirmSchoolMismatch =
    String(formData.get('confirmSchoolNameMismatch') || 'false') === 'true';

  if (!(teacherFile instanceof File) || !(studentFile instanceof File)) {
    return jsonNoStore({ error: 'Both Teacher List and Student List .xlsx files are required.' }, { status: 400 });
  }

  let adminTeacherCodes: string[] = [];
  try {
    const parsedCodes = JSON.parse(adminCodesRaw) as unknown;
    if (Array.isArray(parsedCodes)) {
      adminTeacherCodes = parsedCodes.filter((c): c is string => typeof c === 'string' && c.trim().length > 0);
    }
  } catch {
    return jsonNoStore({ error: 'Invalid adminTeacherCodes JSON array.' }, { status: 400 });
  }

  if (adminTeacherCodes.length === 0) {
    return jsonNoStore(
      { error: 'Select at least one teacher as the initial School Administrator.' },
      { status: 400 }
    );
  }

  const [teacherBuf, studentBuf] = await Promise.all([
    teacherFile.arrayBuffer().then((b) => Buffer.from(b)),
    studentFile.arrayBuffer().then((b) => Buffer.from(b)),
  ]);

  const teacherParsed = parseTeacherExcel(teacherBuf);
  const studentParsed = parseStudentExcel(studentBuf);

  if (!teacherParsed.ok || !teacherParsed.schoolMeta.udiseCode) {
    return jsonNoStore(
      { error: 'Teacher Excel failed validation.', errors: teacherParsed.errors },
      { status: 422 }
    );
  }
  if (!studentParsed.ok) {
    return jsonNoStore(
      { error: 'Student Excel failed validation.', errors: studentParsed.errors },
      { status: 422 }
    );
  }

  const udise = teacherParsed.schoolMeta.udiseCode;
  const schoolName =
    teacherParsed.schoolMeta.schoolName ||
    studentParsed.banner.schoolName ||
    teacherParsed.teachers[0]?.schoolName ||
    `School ${udise}`;

  const studentSchoolSample =
    studentParsed.banner.schoolName || studentParsed.students[0]?.schoolName || '';
  if (
    studentSchoolSample &&
    !matchSchoolNames(studentSchoolSample, schoolName).matched &&
    !confirmSchoolMismatch
  ) {
    return jsonNoStore(
      {
        error:
          'School name in Student List does not match Teacher List. Confirm explicitly if you verified both files.',
      },
      { status: 409 }
    );
  }

  const adminCodeSet = new Set(adminTeacherCodes.map((c) => c.trim()));
  const validAdminInFile = teacherParsed.teachers.some((t) => adminCodeSet.has(t.teacherCode));
  if (!validAdminInFile) {
    return jsonNoStore(
      { error: 'At least one selected School Admin must exist in the Teacher List.' },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();
  const academicYear = getCurrentAcademicYear();

  // Attempt Google One private vault folder creation (non-fatal if Drive env not configured yet)
  let driveFolderId: string | null = null;
  try {
    const folders = await ensureSchoolVaultFolders(udise);
    driveFolderId = folders.schoolRootId;
  } catch {
    driveFolderId = null;
  }

  // 1. Upsert School record
  const { error: schoolErr } = await supabase.from('schools').upsert(
    {
      udise_code: udise,
      school_name: sanitizePlainText(schoolName, 200),
      school_name_hi: schoolNameHiRaw ? sanitizePlainText(schoolNameHiRaw, 200) : null,
      district_code: teacherParsed.schoolMeta.districtCode,
      district_name: sanitizePlainText(teacherParsed.schoolMeta.districtName || 'Bihar', 120),
      block_code: teacherParsed.schoolMeta.blockCode,
      block_name: teacherParsed.schoolMeta.blockName
        ? sanitizePlainText(teacherParsed.schoolMeta.blockName, 120)
        : null,
      cluster_code: teacherParsed.schoolMeta.clusterCode,
      cluster_name: teacherParsed.schoolMeta.clusterName
        ? sanitizePlainText(teacherParsed.schoolMeta.clusterName, 160)
        : null,
      board: 'BSEB',
      status: activateImmediately ? 'ACTIVE' : 'ONBOARDING',
      drive_folder_id: driveFolderId,
      onboarded_by: session.principalId,
    },
    { onConflict: 'udise_code' }
  );

  if (schoolErr) {
    return jsonNoStore({ error: `Failed to save school record: ${schoolErr.message}` }, { status: 500 });
  }

  // 2. Upsert Teachers (blocking cross-school active conflicts)
  const conflicts: SyncConflictItem[] = [];
  let teachersAdded = 0;
  let teachersUpdated = 0;

  const { data: existingTeachersGlobal } = await supabase
    .from('teachers')
    .select('id, teacher_code')
    .in(
      'teacher_code',
      teacherParsed.teachers.map((t) => t.teacherCode)
    );

  const teacherIdByCode = new Map((existingTeachersGlobal ?? []).map((t) => [t.teacher_code, t.id]));
  const existingGlobalIds = Array.from(teacherIdByCode.values());

  const { data: activeOtherTeacherPostings } =
    existingGlobalIds.length > 0
      ? await supabase
          .from('school_teachers')
          .select('teacher_id, school_udise')
          .in('teacher_id', existingGlobalIds)
          .eq('is_active', true)
          .neq('school_udise', udise)
      : { data: [] };

  const activeOtherTeacherMap = new Map(
    (activeOtherTeacherPostings ?? []).map((p) => [p.teacher_id, p.school_udise])
  );

  for (const row of teacherParsed.teachers) {
    let teacherId = teacherIdByCode.get(row.teacherCode);
    if (teacherId && activeOtherTeacherMap.has(teacherId)) {
      conflicts.push({
        row_number: row.rowNumber,
        code: row.teacherCode,
        name: row.fullName,
        reason: 'TEACHER_ACTIVE_IN_ANOTHER_SCHOOL',
        existing_school_udise: activeOtherTeacherMap.get(teacherId),
      });
      continue;
    }

    if (!teacherId) {
      const placeholderHash = await hashPassword(generateSessionToken().slice(0, 32));
      const { data: created, error: tErr } = await supabase
        .from('teachers')
        .insert({
          teacher_code: row.teacherCode,
          full_name: row.fullName,
          teacher_title: row.teacherTitle,
          mobile_last4: row.mobileLast4,
          mobile_hash: row.mobileHash,
          password_hash: placeholderHash,
          must_change_password: true,
        })
        .select('id')
        .single();

      if (tErr || !created) continue;
      teacherId = created.id;
      teachersAdded++;
    } else {
      await supabase
        .from('teachers')
        .update({
          full_name: row.fullName,
          teacher_title: row.teacherTitle,
          ...(row.mobileLast4 && row.mobileHash
            ? { mobile_last4: row.mobileLast4, mobile_hash: row.mobileHash }
            : {}),
        })
        .eq('id', teacherId);
      teachersUpdated++;
    }

    await supabase.from('school_teachers').upsert(
      {
        school_udise: udise,
        teacher_id: teacherId,
        is_school_admin: adminCodeSet.has(row.teacherCode),
        is_active: true,
        deactivated_at: null,
      },
      { onConflict: 'school_udise,teacher_id' }
    );
  }

  // 3. Upsert Class 9–12 Students (blocking cross-school active conflicts; ZERO Aadhaar/Category!)
  const { data: existingStudentsGlobal } = await supabase
    .from('students')
    .select('id, student_code, school_udise, is_active')
    .in(
      'student_code',
      studentParsed.students.map((s) => s.studentCode)
    );

  const studentByCode = new Map(
    (existingStudentsGlobal ?? [])
      .filter((s): s is typeof s & { student_code: string } => Boolean(s.student_code))
      .map((s) => [s.student_code, s])
  );

  let studentsAdded = 0;
  let studentsUpdated = 0;
  const studentsToInsert: Array<{
    student_code: string;
    school_udise: string;
    student_name: string;
    father_name: string | null;
    dob: string;
    gender: string | null;
    class_num: 9 | 10 | 11 | 12;
    stream: 'UNSET' | 'NA' | 'Arts' | 'Science' | 'Commerce';
    section: string;
    roll_no: number;
    academic_year: string;
    is_active: boolean;
  }> = [];

  for (const row of studentParsed.students) {
    const existing = studentByCode.get(row.studentCode);
    if (existing) {
      if (existing.school_udise !== udise && existing.is_active) {
        conflicts.push({
          row_number: row.rowNumber,
          code: row.studentCode,
          name: row.studentName,
          reason: 'STUDENT_ACTIVE_IN_ANOTHER_SCHOOL',
          existing_school_udise: existing.school_udise,
        });
        continue;
      }

      const { error: uErr } = await supabase
        .from('students')
        .update({
          school_udise: udise,
          student_name: row.studentName,
          father_name: row.fatherName,
          dob: row.dob,
          gender: row.gender,
          class_num: row.classNum,
          roll_no: row.rollNo,
          is_active: true,
        })
        .eq('id', existing.id);
      if (!uErr) studentsUpdated++;
    } else {
      studentsToInsert.push({
        student_code: row.studentCode,
        school_udise: udise,
        student_name: row.studentName,
        father_name: row.fatherName,
        dob: row.dob,
        gender: row.gender,
        class_num: row.classNum,
        stream: row.stream,
        section: row.section,
        roll_no: row.rollNo,
        academic_year: academicYear,
        is_active: true,
      });
    }
  }

  for (let i = 0; i < studentsToInsert.length; i += 100) {
    const chunk = studentsToInsert.slice(i, i + 100);
    const { error: insErr } = await supabase.from('students').insert(chunk);
    if (!insErr) studentsAdded += chunk.length;
  }

  // 4. Write sync_logs & audit_logs
  await Promise.all([
    supabase.from('sync_logs').insert({
      school_udise: udise,
      sync_type: 'ONBOARDING',
      performed_by_role: 'super_admin',
      performed_by_id: session.principalId,
      added_count: teachersAdded + studentsAdded,
      updated_count: teachersUpdated + studentsUpdated,
      deactivated_count: 0,
      skipped_count: teacherParsed.skippedRows.length + studentParsed.skippedRows.length,
      conflicts_json: conflicts,
    }),
    supabase.from('audit_logs').insert({
      school_udise: udise,
      actor_role: 'super_admin',
      actor_id: session.principalId,
      action: 'SUPER_ADMIN_SCHOOL_ONBOARDED',
      target_type: 'school',
      target_id: udise,
      meta_json: {
        status: activateImmediately ? 'ACTIVE' : 'ONBOARDING',
        teachersAdded,
        teachersUpdated,
        studentsAdded,
        studentsUpdated,
        adminCount: adminCodeSet.size,
        vaultProvisioned: Boolean(driveFolderId),
        conflictsCount: conflicts.length,
      },
    }),
  ]);

  return jsonNoStore(
    {
      ok: true,
      school: {
        udiseCode: udise,
        schoolName,
        status: activateImmediately ? 'ACTIVE' : 'ONBOARDING',
        vaultProvisioned: Boolean(driveFolderId),
      },
      summary: {
        teachersAdded,
        teachersUpdated,
        studentsAdded,
        studentsUpdated,
        skippedClass1To8: studentParsed.stats.skippedClass1To8,
        conflictsCount: conflicts.length,
      },
    },
    { status: 201 }
  );
}
