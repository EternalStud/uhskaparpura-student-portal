import { getSupabaseAdmin } from '@/lib/supabase/server';
import {
  generateSessionToken,
  hashPassword,
  jsonNoStore,
  revokeAllPrincipalSessions,
  validateCsrf,
} from '@/lib/auth';
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
import { getCurrentAcademicYear } from '@/lib/time/ist';
import type { TeacherRow } from '@/types/database';

/**
 * POST /api/school/sync/commit
 * Re-parses the uploaded `.xlsx` file server-side (never trusting client diff JSON)
 * and commits validated Student or Teacher updates cleanly:
 * - Preserves student learning data (`stream`, `subjects_configured`, `pin_hash`, XP, streaks, revision queue)
 * - Blocks cross-school hijack of active students & teachers
 * - Blocks deactivating the last active School Admin or the calling admin
 * - Writes sanitized `sync_logs` & `audit_logs` (NEVER stores raw student Excel files!)
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
    return jsonNoStore({ error: 'Expected multipart form upload.' }, { status: 400 });
  }

  const syncType = String(formData.get('syncType') || '').trim().toUpperCase();
  const deactivateMissing = String(formData.get('deactivateMissing') || 'false') === 'true';
  const confirmSchoolMismatch =
    String(formData.get('confirmSchoolNameMismatch') || 'false') === 'true';
  const file = formData.get('file');

  if (syncType !== 'STUDENTS' && syncType !== 'TEACHERS') {
    return jsonNoStore({ error: 'syncType must be "STUDENTS" or "TEACHERS".' }, { status: 400 });
  }
  if (!(file instanceof File) || file.size === 0 || !file.name.toLowerCase().endsWith('.xlsx')) {
    return jsonNoStore({ error: 'Please upload a valid .xlsx file.' }, { status: 400 });
  }

  const buffer = Buffer.from(await file.arrayBuffer());
  const supabase = getSupabaseAdmin();
  const academicYear = getCurrentAcademicYear();

  const { data: school } = await supabase
    .from('schools')
    .select('udise_code, school_name')
    .eq('udise_code', udise)
    .single();
  const targetSchoolName = school?.school_name ?? session.schoolName ?? '';

  // =========================================================================
  // COMMIT STUDENT ROSTER SYNC
  // =========================================================================
  if (syncType === 'STUDENTS') {
    const parsed = parseStudentExcel(buffer);
    if (!parsed.ok) {
      return jsonNoStore(
        { error: 'Student roster file failed validation.', errors: parsed.errors },
        { status: 422 }
      );
    }

    if (
      parsed.banner.schoolName &&
      !matchSchoolNames(parsed.banner.schoolName, targetSchoolName).matched &&
      !confirmSchoolMismatch
    ) {
      return jsonNoStore(
        {
          error:
            'The school name in the uploaded file does not match your school. Please verify the file or confirm explicitly.',
        },
        { status: 409 }
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

    let addedCount = 0;
    let updatedCount = 0;
    let deactivatedCount = 0;

    // 1. Batch insert new students (ZERO Aadhaar or Social Category!)
    if (diff.toAdd.length > 0) {
      const insertRows = diff.toAdd.map((s) => ({
        student_code: s.studentCode,
        school_udise: udise,
        student_name: s.studentName,
        father_name: s.fatherName,
        dob: s.dob,
        gender: s.gender,
        class_num: s.classNum,
        stream: s.stream,
        section: s.section,
        roll_no: s.rollNo,
        academic_year: academicYear,
        is_active: true,
      }));

      // Insert in safe chunks of 100
      for (let i = 0; i < insertRows.length; i += 100) {
        const chunk = insertRows.slice(i, i + 100);
        const { error: insErr } = await supabase.from('students').insert(chunk);
        if (insErr) {
          return jsonNoStore(
            { error: `Failed to insert new students batch (${insErr.message}).` },
            { status: 500 }
          );
        }
        addedCount += chunk.length;
      }
    }

    // 2. Update changed roster fields ONLY (preserves stream, subjects, PIN, XP, streaks!)
    for (const candidate of diff.toUpdate) {
      const { error: updErr } = await supabase
        .from('students')
        .update({
          student_name: candidate.row.studentName,
          father_name: candidate.row.fatherName,
          dob: candidate.row.dob,
          gender: candidate.row.gender,
          class_num: candidate.row.classNum,
          roll_no: candidate.row.rollNo,
          is_active: true,
        })
        .eq('id', candidate.existingId)
        .eq('school_udise', udise);

      if (!updErr) updatedCount++;
    }

    // 3. Optionally deactivate missing active students & revoke their sessions
    if (deactivateMissing && diff.missingActive.length > 0) {
      const missingIds = diff.missingActive.map((m) => m.id);
      const { error: deactErr } = await supabase
        .from('students')
        .update({ is_active: false })
        .in('id', missingIds)
        .eq('school_udise', udise);

      if (!deactErr) {
        deactivatedCount = missingIds.length;
        await Promise.all(
          missingIds.map((studentId) => revokeAllPrincipalSessions(studentId, 'student'))
        );
      }
    }

    await Promise.all([
      supabase.from('sync_logs').insert({
        school_udise: udise,
        sync_type: 'STUDENTS',
        performed_by_role: session.role,
        performed_by_id: session.principalId,
        added_count: addedCount,
        updated_count: updatedCount,
        deactivated_count: deactivatedCount,
        skipped_count: diff.skippedRows.length,
        conflicts_json: diff.crossSchoolConflicts,
      }),
      supabase.from('audit_logs').insert({
        school_udise: udise,
        actor_role: session.role,
        actor_id: session.principalId,
        action: 'SCHOOL_STUDENT_ROSTER_SYNCED',
        target_type: 'school',
        target_id: udise,
        meta_json: {
          addedCount,
          updatedCount,
          deactivatedCount,
          skippedCount: diff.skippedRows.length,
          conflictsCount: diff.crossSchoolConflicts.length,
        },
      }),
    ]);

    return jsonNoStore({
      ok: true,
      syncType: 'STUDENTS',
      addedCount,
      updatedCount,
      unchangedCount: diff.unchangedCount,
      deactivatedCount,
      skippedCount: diff.skippedRows.length,
      conflictsCount: diff.crossSchoolConflicts.length,
    });
  }

  // =========================================================================
  // COMMIT TEACHER ROSTER SYNC
  // =========================================================================
  const parsed = parseTeacherExcel(buffer);
  if (!parsed.ok) {
    return jsonNoStore(
      { error: 'Teacher roster file failed validation.', errors: parsed.errors },
      { status: 422 }
    );
  }
  if (parsed.schoolMeta.udiseCode && parsed.schoolMeta.udiseCode !== udise) {
    return jsonNoStore(
      { error: 'Uploaded Teacher file UDISE code does not match your school.' },
      { status: 403 }
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
  const uploadedByCode = new Map((allUploadedTeachers ?? []).map((t) => [t.teacher_code, t]));
  const uploadedById = new Map((allUploadedTeachers ?? []).map((t) => [t.id, t]));

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
      const t = uploadedById.get(cp.teacher_id);
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

  let addedCount = 0;
  let updatedCount = 0;
  let deactivatedCount = 0;

  // 1. Add new teachers (or link inactive previously transferred teachers)
  for (const row of diff.toAdd) {
    let teacherId = uploadedByCode.get(row.teacherCode)?.id;

    if (!teacherId) {
      const placeholderHash = await hashPassword(generateSessionToken().slice(0, 32));
      const { data: created, error: createErr } = await supabase
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

      if (createErr || !created) continue;
      teacherId = created.id;
    }

    const { error: postErr } = await supabase.from('school_teachers').upsert(
      {
        school_udise: udise,
        teacher_id: teacherId,
        is_school_admin: false,
        is_active: true,
        deactivated_at: null,
      },
      { onConflict: 'school_udise,teacher_id' }
    );
    if (!postErr) addedCount++;
  }

  // 2. Update existing teachers
  for (const candidate of diff.toUpdate) {
    const teacherPatch: Partial<TeacherRow> = {
      full_name: candidate.row.fullName,
      teacher_title: candidate.row.teacherTitle,
    };
    if (candidate.row.mobileLast4 && candidate.row.mobileHash) {
      teacherPatch.mobile_last4 = candidate.row.mobileLast4;
      teacherPatch.mobile_hash = candidate.row.mobileHash;
    }

    await supabase.from('teachers').update(teacherPatch).eq('id', candidate.existingTeacherId);

    if (candidate.reactivating) {
      await supabase
        .from('school_teachers')
        .update({ is_active: true, deactivated_at: null })
        .eq('school_udise', udise)
        .eq('teacher_id', candidate.existingTeacherId);
    }
    updatedCount++;
  }

  // 3. Optionally deactivate missing teachers — strictly excluding last active School Admin & self!
  if (deactivateMissing && diff.missingActive.length > 0) {
    const blockedIds = new Set(diff.blockedAdminDeactivations.map((b) => b.teacher_id));
    blockedIds.add(session.principalId); // Never self-deactivate via sync!

    const safeToDeactivate = diff.missingActive.filter((m) => !blockedIds.has(m.teacher_id));
    const nowIso = new Date().toISOString();

    for (const m of safeToDeactivate) {
      const { error: deactErr } = await supabase
        .from('school_teachers')
        .update({ is_active: false, deactivated_at: nowIso })
        .eq('school_udise', udise)
        .eq('teacher_id', m.teacher_id);

      if (!deactErr) {
        deactivatedCount++;
        await revokeAllPrincipalSessions(m.teacher_id, 'teacher');
      }
    }
  }

  await Promise.all([
    supabase.from('sync_logs').insert({
      school_udise: udise,
      sync_type: 'TEACHERS',
      performed_by_role: session.role,
      performed_by_id: session.principalId,
      added_count: addedCount,
      updated_count: updatedCount,
      deactivated_count: deactivatedCount,
      skipped_count: diff.skippedRows.length,
      conflicts_json: diff.crossSchoolConflicts,
    }),
    supabase.from('audit_logs').insert({
      school_udise: udise,
      actor_role: session.role,
      actor_id: session.principalId,
      action: 'SCHOOL_TEACHER_ROSTER_SYNCED',
      target_type: 'school',
      target_id: udise,
      meta_json: {
        addedCount,
        updatedCount,
        deactivatedCount,
        conflictsCount: diff.crossSchoolConflicts.length,
        blockedAdminDeactivations: diff.blockedAdminDeactivations.length,
      },
    }),
  ]);

  return jsonNoStore({
    ok: true,
    syncType: 'TEACHERS',
    addedCount,
    updatedCount,
    unchangedCount: diff.unchangedCount,
    deactivatedCount,
    conflictsCount: diff.crossSchoolConflicts.length,
    blockedAdminDeactivations: diff.blockedAdminDeactivations.length,
  });
}
