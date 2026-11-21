import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, validateCsrf } from '@/lib/auth';
import { requireSchoolAdmin } from '@/lib/auth/school-admin-guard';
import {
  computeStudentSyncDiff,
  computeTeacherSyncDiff,
  matchSchoolNames,
  parseStudentExcel,
  parseTeacherExcel,
  type ExistingSchoolStudentSnapshot,
  type ExistingSchoolTeacherSnapshot,
} from '@/lib/excel/eshikshakosh';

/**
 * POST /api/school/sync/preview
 * Dry-run preview for Student or Teacher roster Excel uploads (multipart/form-data).
 * - Runs zip-bomb guard + column parser + punctuation-insensitive school name check.
 * - Computes safe diff (`toAdd`, `toUpdate`, `missingActive`, `crossSchoolConflicts`, `skippedRows`).
 * - NEVER persists raw Excel files, Aadhaar numbers, Social Category, or plaintext mobiles.
 */

export async function POST(request: Request) {
  const csrf = validateCsrf(request, { allowMultipart: true });
  if (!csrf.ok) return csrf.response;

  const auth = await requireSchoolAdmin(request);
  if (!auth.ok) return auth.response;
  const { session } = auth;
  const udise = session.schoolUdise;

  let formData: FormData;
  try {
    formData = await request.formData();
  } catch {
    return jsonNoStore({ error: 'Expected multipart form upload with an .xlsx file.' }, { status: 400 });
  }

  const syncType = String(formData.get('syncType') || '').trim().toUpperCase();
  const file = formData.get('file');

  if (syncType !== 'STUDENTS' && syncType !== 'TEACHERS') {
    return jsonNoStore({ error: 'syncType must be "STUDENTS" or "TEACHERS".' }, { status: 400 });
  }
  if (!(file instanceof File) || file.size === 0) {
    return jsonNoStore({ error: 'Please select a valid .xlsx file.' }, { status: 400 });
  }
  if (!file.name.toLowerCase().endsWith('.xlsx')) {
    return jsonNoStore({ error: 'Only standard .xlsx Excel files are supported.' }, { status: 400 });
  }

  const buffer = Buffer.from(await file.arrayBuffer());
  const supabase = getSupabaseAdmin();

  const { data: school } = await supabase
    .from('schools')
    .select('udise_code, school_name')
    .eq('udise_code', udise)
    .single();

  const targetSchoolName = school?.school_name ?? session.schoolName ?? '';

  // =========================================================================
  // STUDENTS DRY-RUN PREVIEW
  // =========================================================================
  if (syncType === 'STUDENTS') {
    const parsed = parseStudentExcel(buffer);
    if (!parsed.ok && parsed.students.length === 0) {
      return jsonNoStore(
        {
          ok: false,
          syncType: 'STUDENTS',
          errors: parsed.errors,
          warnings: parsed.warnings,
          skippedRows: parsed.skippedRows.slice(0, 50),
          stats: parsed.stats,
        },
        { status: 422 }
      );
    }

    const uploadedCodes = parsed.students.map((s) => s.studentCode);

    const [{ data: existingSchoolStudents }, { data: crossRows }] = await Promise.all([
      supabase
        .from('students')
        .select(
          'id, student_code, school_udise, student_name, father_name, dob, gender, class_num, roll_no, is_active'
        )
        .eq('school_udise', udise),
      uploadedCodes.length > 0
        ? supabase
            .from('students')
            .select('student_code, school_udise, student_name')
            .in('student_code', uploadedCodes)
            .eq('is_active', true)
            .neq('school_udise', udise)
        : Promise.resolve({ data: [] as Array<{ student_code: string | null; school_udise: string; student_name: string }> }),
    ]);

    const crossSchoolActive = (crossRows ?? []).filter(
      (r): r is { student_code: string; school_udise: string; student_name: string } =>
        Boolean(r.student_code)
    );

    const diff = computeStudentSyncDiff({
      targetSchoolUdise: udise,
      targetSchoolName,
      parsedResult: parsed,
      existingSchoolStudents: (existingSchoolStudents ?? []) as ExistingSchoolStudentSnapshot[],
      crossSchoolActiveStudents: crossSchoolActive,
    });

    const bannerSchoolMatch = parsed.banner.schoolName
      ? matchSchoolNames(parsed.banner.schoolName, targetSchoolName).matched
      : true;

    return jsonNoStore({
      ok: parsed.errors.length === 0,
      syncType: 'STUDENTS',
      banner: parsed.banner,
      targetSchoolName,
      schoolNameMatched: bannerSchoolMatch && diff.schoolNameMismatchCount === 0,
      stats: parsed.stats,
      discardedSensitiveColumns: parsed.discardedSensitiveColumns,
      summary: {
        toAdd: diff.toAdd.length,
        toUpdate: diff.toUpdate.length,
        unchanged: diff.unchangedCount,
        missingActive: diff.missingActive.length,
        crossSchoolConflicts: diff.crossSchoolConflicts.length,
        skippedClass1To8: parsed.stats.skippedClass1To8,
        skippedInvalid: parsed.stats.skippedInvalid,
        schoolNameMismatches: diff.schoolNameMismatchCount,
      },
      preview: {
        toAdd: diff.toAdd.slice(0, 60).map((s) => ({
          rowNumber: s.rowNumber,
          studentCode: s.studentCode,
          studentName: s.studentName,
          classNum: s.classNum,
          rollNo: s.rollNo,
          dob: s.dob,
        })),
        toUpdate: diff.toUpdate.slice(0, 60).map((u) => ({
          existingId: u.existingId,
          studentCode: u.row.studentCode,
          studentName: u.row.studentName,
          classNum: u.row.classNum,
          rollNo: u.row.rollNo,
          changedFields: u.changedFields,
          reactivating: u.reactivating,
        })),
        missingActive: diff.missingActive.slice(0, 60).map((m) => ({
          id: m.id,
          studentCode: m.student_code,
          studentName: m.student_name,
          classNum: m.class_num,
          rollNo: m.roll_no,
        })),
        crossSchoolConflicts: diff.crossSchoolConflicts.slice(0, 60),
        skippedRows: diff.skippedRows.slice(0, 60),
      },
      errors: parsed.errors,
      warnings: diff.warnings,
    });
  }

  // =========================================================================
  // TEACHERS DRY-RUN PREVIEW
  // =========================================================================
  const parsed = parseTeacherExcel(buffer);
  if (!parsed.ok && parsed.teachers.length === 0) {
    return jsonNoStore(
      {
        ok: false,
        syncType: 'TEACHERS',
        errors: parsed.errors,
        warnings: parsed.warnings,
        skippedRows: parsed.skippedRows.slice(0, 50),
        stats: parsed.stats,
      },
      { status: 422 }
    );
  }

  const [{ data: existingPostings }, { data: allUploadedTeachers }] = await Promise.all([
    supabase
      .from('school_teachers')
      .select('teacher_id, is_school_admin, is_active')
      .eq('school_udise', udise),
    parsed.teachers.length > 0
      ? supabase
          .from('teachers')
          .select('id, teacher_code, full_name, teacher_title, mobile_last4, mobile_hash')
          .in(
            'teacher_code',
            parsed.teachers.map((t) => t.teacherCode)
          )
      : Promise.resolve({
          data: [] as Array<{
            id: string;
            teacher_code: string;
            full_name: string;
            teacher_title: string | null;
            mobile_last4: string | null;
            mobile_hash: string | null;
          }>,
        }),
  ]);

  const existingIds = (existingPostings ?? []).map((p) => p.teacher_id);
  const { data: existingTeacherRows } =
    existingIds.length > 0
      ? await supabase
          .from('teachers')
          .select('id, teacher_code, full_name, teacher_title, mobile_last4, mobile_hash')
          .in('id', existingIds)
      : { data: [] };

  const existingTeacherMap = new Map((existingTeacherRows ?? []).map((t) => [t.id, t]));
  const existingSchoolTeachers: ExistingSchoolTeacherSnapshot[] = (existingPostings ?? [])
    .map((p) => {
      const t = existingTeacherMap.get(p.teacher_id);
      if (!t) return null;
      return {
        teacher_id: t.id,
        teacher_code: t.teacher_code,
        full_name: t.full_name,
        teacher_title: t.teacher_title,
        mobile_last4: t.mobile_last4,
        mobile_hash: t.mobile_hash,
        is_school_admin: p.is_school_admin,
        is_active: p.is_active,
      };
    })
    .filter((x): x is ExistingSchoolTeacherSnapshot => x !== null);

  const uploadedGlobalIds = (allUploadedTeachers ?? []).map((t) => t.id);
  const uploadedCodeById = new Map((allUploadedTeachers ?? []).map((t) => [t.id, t]));
  const { data: crossPostings } =
    uploadedGlobalIds.length > 0
      ? await supabase
          .from('school_teachers')
          .select('teacher_id, school_udise')
          .in('teacher_id', uploadedGlobalIds)
          .eq('is_active', true)
          .neq('school_udise', udise)
      : { data: [] };

  const crossSchoolActiveTeachers = (crossPostings ?? [])
    .map((cp) => {
      const t = uploadedCodeById.get(cp.teacher_id);
      if (!t) return null;
      return {
        teacher_code: t.teacher_code,
        school_udise: cp.school_udise,
        full_name: t.full_name,
      };
    })
    .filter((x): x is NonNullable<typeof x> => x !== null);

  const diff = computeTeacherSyncDiff({
    targetSchoolUdise: udise,
    parsedResult: parsed,
    existingSchoolTeachers,
    crossSchoolActiveTeachers,
  });

  const udiseMatches = !parsed.schoolMeta.udiseCode || parsed.schoolMeta.udiseCode === udise;

  return jsonNoStore({
    ok: parsed.errors.length === 0 && udiseMatches,
    syncType: 'TEACHERS',
    banner: parsed.banner,
    schoolMeta: parsed.schoolMeta,
    targetSchoolName,
    udiseMatched: udiseMatches,
    stats: parsed.stats,
    summary: {
      toAdd: diff.toAdd.length,
      toUpdate: diff.toUpdate.length,
      unchanged: diff.unchangedCount,
      missingActive: diff.missingActive.length,
      crossSchoolConflicts: diff.crossSchoolConflicts.length,
      blockedAdminDeactivations: diff.blockedAdminDeactivations.length,
      canDeactivateAllMissing: diff.canDeactivateAllMissing,
    },
    preview: {
      toAdd: diff.toAdd.slice(0, 60).map((t) => ({
        rowNumber: t.rowNumber,
        teacherCode: t.teacherCode,
        fullName: t.fullName,
        teacherTitle: t.teacherTitle,
        maskedMobile: t.mobileLast4 ? `XXXXXX${t.mobileLast4}` : null,
      })),
      toUpdate: diff.toUpdate.slice(0, 60).map((u) => ({
        existingTeacherId: u.existingTeacherId,
        teacherCode: u.row.teacherCode,
        fullName: u.row.fullName,
        changedFields: u.changedFields,
        reactivating: u.reactivating,
      })),
      missingActive: diff.missingActive.slice(0, 60).map((m) => ({
        teacherId: m.teacher_id,
        teacherCode: m.teacher_code,
        fullName: m.full_name,
        isSchoolAdmin: m.is_school_admin,
      })),
      crossSchoolConflicts: diff.crossSchoolConflicts.slice(0, 60),
      blockedAdminDeactivations: diff.blockedAdminDeactivations.map((b) => ({
        teacherId: b.teacher_id,
        teacherCode: b.teacher_code,
        fullName: b.full_name,
      })),
      skippedRows: diff.skippedRows.slice(0, 60),
    },
    errors: udiseMatches
      ? parsed.errors
      : [
          ...parsed.errors,
          `Uploaded Teacher Excel belongs to UDISE ${parsed.schoolMeta.udiseCode}, which does not match your school (${udise}).`,
        ],
    warnings: diff.warnings,
  });
}
