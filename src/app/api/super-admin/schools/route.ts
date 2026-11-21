import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole } from '@/lib/auth';
import { checkVaultHealth } from '@/lib/drive/google-one';

/**
 * GET /api/super-admin/schools
 * Lists all onboarded Bihar schools with live student/teacher/submission counts
 * and optional 5 TB Google One storage vault health (`?includeHealth=1`).
 */
export async function GET(request: Request) {
  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  const url = new URL(request.url);
  const includeHealth = url.searchParams.get('includeHealth') === '1';
  const supabase = getSupabaseAdmin();

  const [
    { data: schools, error: schoolsErr },
    { data: students },
    { data: schoolTeachers },
    { count: pendingSubmissionsCount },
    { count: publishedQuestionsCount },
    { count: publishedNotesCount },
    vaultHealth,
  ] = await Promise.all([
    supabase
      .from('schools')
      .select(
        'udise_code, school_name, school_name_hi, district_code, district_name, block_code, block_name, cluster_name, board, status, drive_folder_id, created_at, updated_at'
      )
      .order('created_at', { ascending: false }),
    supabase.from('students').select('school_udise, is_active'),
    supabase.from('school_teachers').select('school_udise, is_active, is_school_admin'),
    supabase
      .from('question_submissions')
      .select('id', { count: 'exact', head: true })
      .in('status', ['PENDING', 'AI_PARSING', 'AI_READY']),
    supabase
      .from('questions')
      .select('id', { count: 'exact', head: true })
      .eq('is_published', true),
    supabase
      .from('chapter_notes')
      .select('id', { count: 'exact', head: true })
      .eq('status', 'PUBLISHED'),
    includeHealth ? checkVaultHealth() : Promise.resolve(null),
  ]);

  if (schoolsErr) {
    return jsonNoStore({ error: 'Failed to load schools registry.' }, { status: 500 });
  }

  const studentCounts = new Map<string, number>();
  for (const s of students ?? []) {
    if (s.is_active) {
      studentCounts.set(s.school_udise, (studentCounts.get(s.school_udise) ?? 0) + 1);
    }
  }

  const teacherCounts = new Map<string, { active: number; admins: number }>();
  for (const t of schoolTeachers ?? []) {
    if (!t.is_active) continue;
    const entry = teacherCounts.get(t.school_udise) ?? { active: 0, admins: 0 };
    entry.active++;
    if (t.is_school_admin) entry.admins++;
    teacherCounts.set(t.school_udise, entry);
  }

  const enrichedSchools = (schools ?? []).map((school) => {
    const tStats = teacherCounts.get(school.udise_code) ?? { active: 0, admins: 0 };
    return {
      ...school,
      activeStudents: studentCounts.get(school.udise_code) ?? 0,
      activeTeachers: tStats.active,
      schoolAdmins: tStats.admins,
    };
  });

  return jsonNoStore({
    schools: enrichedSchools,
    platformSummary: {
      totalSchools: enrichedSchools.length,
      activeSchools: enrichedSchools.filter((s) => s.status === 'ACTIVE').length,
      totalActiveStudents: Array.from(studentCounts.values()).reduce((a, b) => a + b, 0),
      totalActiveTeachers: Array.from(teacherCounts.values()).reduce((a, b) => a + b.active, 0),
      pendingSubmissions: pendingSubmissionsCount ?? 0,
      publishedQuestions: publishedQuestionsCount ?? 0,
      publishedNotes: publishedNotesCount ?? 0,
    },
    vaultHealth,
  });
}
