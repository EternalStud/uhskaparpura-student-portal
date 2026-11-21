import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore } from '@/lib/auth';
import { requireSchoolAdmin } from '@/lib/auth/school-admin-guard';

/**
 * GET /api/school/overview
 * Institutional overview strictly scoped to `session.schoolUdise`:
 * - Active student breakdown by class & stream
 * - Teacher roster & subject-mapping coverage
 * - Open vs answered doubts + unassigned-subject doubt alerts
 * - Recent sync_logs & audit_logs
 */
export async function GET(request: Request) {
  const auth = await requireSchoolAdmin(request);
  if (!auth.ok) return auth.response;
  const { session } = auth;
  const udise = session.schoolUdise;
  const supabase = getSupabaseAdmin();

  const [
    { data: school },
    { data: students },
    { data: schoolTeachers },
    { data: doubts },
    { data: subjects },
    { data: syncLogs },
    { data: auditLogs },
  ] = await Promise.all([
    supabase
      .from('schools')
      .select(
        'udise_code, school_name, school_name_hi, district_name, block_name, cluster_name, status, created_at'
      )
      .eq('udise_code', udise)
      .maybeSingle(),
    supabase
      .from('students')
      .select('class_num, stream, is_active, subjects_configured')
      .eq('school_udise', udise),
    supabase
      .from('school_teachers')
      .select('teacher_id, is_school_admin, is_active, subjects_configured, assigned_classes, assigned_subject_ids')
      .eq('school_udise', udise),
    supabase
      .from('open_doubts')
      .select('id, subject_id, class_num, status, is_hidden')
      .eq('school_udise', udise)
      .eq('is_hidden', false),
    supabase.from('subjects').select('id, class_num, name_en, name_hi'),
    supabase
      .from('sync_logs')
      .select('id, sync_type, added_count, updated_count, deactivated_count, skipped_count, created_at')
      .eq('school_udise', udise)
      .order('created_at', { ascending: false })
      .limit(10),
    supabase
      .from('audit_logs')
      .select('id, actor_role, action, target_type, target_id, created_at')
      .eq('school_udise', udise)
      .order('created_at', { ascending: false })
      .limit(15),
  ]);

  const classCounts: Record<number, number> = { 9: 0, 10: 0, 11: 0, 12: 0 };
  const streamCounts: Record<string, number> = {
    NA: 0,
    UNSET: 0,
    Science: 0,
    Arts: 0,
    Commerce: 0,
  };

  let activeStudents = 0;
  let inactiveStudents = 0;
  let studentsConfiguredSubjects = 0;

  for (const s of students ?? []) {
    if (s.is_active) {
      activeStudents++;
      classCounts[s.class_num] = (classCounts[s.class_num] ?? 0) + 1;
      streamCounts[s.stream] = (streamCounts[s.stream] ?? 0) + 1;
      if (s.subjects_configured) studentsConfiguredSubjects++;
    } else {
      inactiveStudents++;
    }
  }

  const activeTeachers = (schoolTeachers ?? []).filter((t) => t.is_active);
  const configuredTeachers = activeTeachers.filter(
    (t) => t.subjects_configured || (t.assigned_subject_ids?.length ?? 0) > 0
  );
  const coveredSubjectIds = new Set<string>();
  for (const t of activeTeachers) {
    for (const sid of t.assigned_subject_ids ?? []) {
      coveredSubjectIds.add(sid);
    }
  }

  const subjectLookup = new Map((subjects ?? []).map((s) => [s.id, s]));

  let openDoubtsCount = 0;
  let answeredDoubtsCount = 0;
  let resolvedDoubtsCount = 0;
  const unassignedSubjectDoubtMap = new Map<
    string,
    { subjectId: string; nameEn: string; nameHi: string; classNum: number; openCount: number }
  >();

  for (const d of doubts ?? []) {
    if (d.status === 'OPEN') {
      openDoubtsCount++;
      if (!coveredSubjectIds.has(d.subject_id)) {
        const subj = subjectLookup.get(d.subject_id);
        const existing = unassignedSubjectDoubtMap.get(d.subject_id);
        if (existing) {
          existing.openCount++;
        } else {
          unassignedSubjectDoubtMap.set(d.subject_id, {
            subjectId: d.subject_id,
            nameEn: subj?.name_en ?? d.subject_id,
            nameHi: subj?.name_hi ?? d.subject_id,
            classNum: subj?.class_num ?? d.class_num,
            openCount: 1,
          });
        }
      }
    } else if (d.status === 'ANSWERED') {
      answeredDoubtsCount++;
    } else if (d.status === 'RESOLVED') {
      resolvedDoubtsCount++;
    }
  }

  return jsonNoStore({
    school,
    stats: {
      activeStudents,
      inactiveStudents,
      studentsConfiguredSubjects,
      classCounts,
      streamCounts,
      activeTeachers: activeTeachers.length,
      schoolAdminsCount: activeTeachers.filter((t) => t.is_school_admin).length,
      configuredTeachers: configuredTeachers.length,
      coveredSubjectsCount: coveredSubjectIds.size,
      openDoubtsCount,
      answeredDoubtsCount,
      resolvedDoubtsCount,
    },
    unassignedDoubtAlerts: Array.from(unassignedSubjectDoubtMap.values()).sort(
      (a, b) => b.openCount - a.openCount
    ),
    recentSyncLogs: syncLogs ?? [],
    recentAuditLogs: auditLogs ?? [],
  });
}
