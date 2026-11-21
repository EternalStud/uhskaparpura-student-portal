import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, validateCsrf } from '@/lib/auth';
import { requireSchoolAdmin } from '@/lib/auth/school-admin-guard';
import { sanitizePlainText } from '@/lib/sanitize/content';

/**
 * GET / PATCH /api/school/moderation
 * School Admin moderation console for open school doubts and teacher materials.
 * Strictly isolated to `session.schoolUdise`; every hide/restore logs to `audit_logs`.
 */

const moderationPatchSchema = z.object({
  targetType: z.enum(['DOUBT', 'DOUBT_ANSWER', 'MATERIAL']),
  targetId: z.string().uuid(),
  hidden: z.boolean(),
  reason: z.string().trim().max(300).optional(),
});

export async function GET(request: Request) {
  const auth = await requireSchoolAdmin(request);
  if (!auth.ok) return auth.response;
  const udise = auth.session.schoolUdise;
  const supabase = getSupabaseAdmin();

  const [{ data: doubts }, { data: materials }, { data: subjects }] = await Promise.all([
    supabase
      .from('open_doubts')
      .select(
        'id, student_id, subject_id, class_num, question_text, status, is_pinned, is_hidden, upvote_count, created_at'
      )
      .eq('school_udise', udise)
      .order('created_at', { ascending: false })
      .limit(100),
    supabase
      .from('teacher_materials')
      .select(
        'id, teacher_id, subject_id, class_num, title, material_type, is_pinned, is_deleted, created_at'
      )
      .eq('school_udise', udise)
      .order('created_at', { ascending: false })
      .limit(100),
    supabase.from('subjects').select('id, name_en, name_hi'),
  ]);

  const studentIds = Array.from(new Set((doubts ?? []).map((d) => d.student_id)));
  const teacherIds = Array.from(new Set((materials ?? []).map((m) => m.teacher_id)));
  const doubtIds = (doubts ?? []).map((d) => d.id);

  const [{ data: students }, { data: teachers }, { data: answers }] = await Promise.all([
    studentIds.length > 0
      ? supabase
          .from('students')
          .select('id, student_name, class_num, roll_no')
          .in('id', studentIds)
      : Promise.resolve({ data: [] as Array<{ id: string; student_name: string; class_num: number; roll_no: number }> }),
    teacherIds.length > 0
      ? supabase.from('teachers').select('id, full_name').in('id', teacherIds)
      : Promise.resolve({ data: [] as Array<{ id: string; full_name: string }> }),
    doubtIds.length > 0
      ? supabase
          .from('doubt_answers')
          .select('id, doubt_id, teacher_id, answer_text, is_hidden, created_at')
          .in('doubt_id', doubtIds)
      : Promise.resolve({
          data: [] as Array<{
            id: string;
            doubt_id: string;
            teacher_id: string;
            answer_text: string;
            is_hidden: boolean;
            created_at: string;
          }>,
        }),
  ]);

  const subjectMap = new Map((subjects ?? []).map((s) => [s.id, s]));
  const studentMap = new Map((students ?? []).map((s) => [s.id, s]));
  const teacherMap = new Map((teachers ?? []).map((t) => [t.id, t]));
  const answersByDoubt = new Map<string, typeof answers>();

  for (const ans of answers ?? []) {
    const list = answersByDoubt.get(ans.doubt_id) ?? [];
    list.push(ans);
    answersByDoubt.set(ans.doubt_id, list);
  }

  return jsonNoStore({
    doubts: (doubts ?? []).map((d) => {
      const stu = studentMap.get(d.student_id);
      const subj = subjectMap.get(d.subject_id);
      return {
        id: d.id,
        classNum: d.class_num,
        subjectNameEn: subj?.name_en ?? d.subject_id,
        subjectNameHi: subj?.name_hi ?? d.subject_id,
        studentName: stu?.student_name ?? 'Student',
        rollNo: stu?.roll_no ?? null,
        questionText: d.question_text,
        status: d.status,
        isPinned: d.is_pinned,
        isHidden: d.is_hidden,
        upvoteCount: d.upvote_count,
        createdAt: d.created_at,
        answers: (answersByDoubt.get(d.id) ?? []).map((a) => ({
          id: a.id,
          answerText: a.answer_text,
          isHidden: a.is_hidden,
          createdAt: a.created_at,
        })),
      };
    }),
    materials: (materials ?? []).map((m) => {
      const tch = teacherMap.get(m.teacher_id);
      const subj = subjectMap.get(m.subject_id);
      return {
        id: m.id,
        classNum: m.class_num,
        subjectNameEn: subj?.name_en ?? m.subject_id,
        subjectNameHi: subj?.name_hi ?? m.subject_id,
        teacherName: tch?.full_name ?? 'Teacher',
        title: m.title,
        materialType: m.material_type,
        isPinned: m.is_pinned,
        isHidden: m.is_deleted,
        createdAt: m.created_at,
      };
    }),
  });
}

export async function PATCH(request: Request) {
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

  const parsed = moderationPatchSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: 'Invalid moderation payload.' }, { status: 400 });
  }

  const { targetType, targetId, hidden, reason } = parsed.data;
  const cleanReason = reason ? sanitizePlainText(reason, 300) : null;
  const supabase = getSupabaseAdmin();

  if (targetType === 'DOUBT') {
    const { data: existing } = await supabase
      .from('open_doubts')
      .select('id')
      .eq('id', targetId)
      .eq('school_udise', udise)
      .maybeSingle();

    if (!existing) {
      return jsonNoStore({ error: 'Doubt not found in your school.' }, { status: 404 });
    }

    await supabase
      .from('open_doubts')
      .update({
        is_hidden: hidden,
        hidden_by: hidden ? session.principalId : null,
      })
      .eq('id', targetId)
      .eq('school_udise', udise);
  } else if (targetType === 'DOUBT_ANSWER') {
    // Verify parent doubt belongs to this school!
    const { data: answer } = await supabase
      .from('doubt_answers')
      .select('id, doubt_id')
      .eq('id', targetId)
      .maybeSingle();

    if (!answer) {
      return jsonNoStore({ error: 'Answer not found.' }, { status: 404 });
    }

    const { data: parentDoubt } = await supabase
      .from('open_doubts')
      .select('id')
      .eq('id', answer.doubt_id)
      .eq('school_udise', udise)
      .maybeSingle();

    if (!parentDoubt) {
      return jsonNoStore({ error: 'Cross-school moderation denied.' }, { status: 403 });
    }

    await supabase
      .from('doubt_answers')
      .update({ is_hidden: hidden })
      .eq('id', targetId);
  } else {
    const { data: material } = await supabase
      .from('teacher_materials')
      .select('id')
      .eq('id', targetId)
      .eq('school_udise', udise)
      .maybeSingle();

    if (!material) {
      return jsonNoStore({ error: 'Material not found in your school.' }, { status: 404 });
    }

    await supabase
      .from('teacher_materials')
      .update({ is_deleted: hidden })
      .eq('id', targetId)
      .eq('school_udise', udise);
  }

  await supabase.from('audit_logs').insert({
    school_udise: udise,
    actor_role: session.role,
    actor_id: session.principalId,
    action: hidden ? `SCHOOL_MODERATION_HIDE_${targetType}` : `SCHOOL_MODERATION_RESTORE_${targetType}`,
    target_type: targetType.toLowerCase(),
    target_id: targetId,
    meta_json: { reason: cleanReason },
  });

  return jsonNoStore({ ok: true });
}
