import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole, validateCsrf } from '@/lib/auth';
import { sanitizeMarkdownSource, sanitizePlainText } from '@/lib/sanitize/content';

/**
 * GET / PUT /api/super-admin/cms/lesson-plans/[chapterId]
 * Super-Admin-only CMS editor for Teacher-Only BSEB Lesson Plans.
 */

const lessonPlanSchema = z.object({
  duration_periods: z.number().int().min(1).max(30).default(4),
  objectives_hi: z.string().trim().min(5).max(3000),
  objectives_en: z.string().trim().min(5).max(3000),
  teaching_steps_json: z
    .array(
      z.object({
        period_no: z.number().int().min(1).max(30),
        duration_mins: z.number().int().min(5).max(120),
        phase_hi: z.string().trim().min(1).max(200),
        phase_en: z.string().trim().min(1).max(200),
        teacher_action_hi: z.string().trim().min(1).max(2000),
        teacher_action_en: z.string().trim().min(1).max(2000),
        student_check_hi: z.string().trim().min(1).max(1000),
        student_check_en: z.string().trim().min(1).max(1000),
      })
    )
    .max(30)
    .default([]),
  blackboard_points_json: z
    .array(
      z.object({
        heading_hi: z.string().trim().min(1).max(200),
        heading_en: z.string().trim().min(1).max(200),
        points_hi: z.array(z.string().trim().min(1).max(600)).max(20),
        points_en: z.array(z.string().trim().min(1).max(600)).max(20),
      })
    )
    .max(15)
    .default([]),
  classroom_activities_json: z
    .array(
      z.object({
        title_hi: z.string().trim().min(1).max(200),
        title_en: z.string().trim().min(1).max(200),
        materials_hi: z.string().trim().max(500),
        materials_en: z.string().trim().max(500),
        steps_hi: z.string().trim().min(1).max(2000),
        steps_en: z.string().trim().min(1).max(2000),
      })
    )
    .max(15)
    .default([]),
  homework_json: z
    .array(
      z.object({
        level: z.enum(['FOUNDATION', 'BOARD', 'CHALLENGE']),
        task_hi: z.string().trim().min(1).max(1500),
        task_en: z.string().trim().min(1).max(1500),
      })
    )
    .max(15)
    .default([]),
  common_student_misconceptions_json: z
    .array(
      z.object({
        misconception_hi: z.string().trim().min(1).max(1000),
        misconception_en: z.string().trim().min(1).max(1000),
        correction_hi: z.string().trim().min(1).max(1500),
        correction_en: z.string().trim().min(1).max(1500),
      })
    )
    .max(15)
    .default([]),
});

export async function GET(
  request: Request,
  context: { params: Promise<{ chapterId: string }> }
) {
  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  const { chapterId } = await context.params;
  const supabase = getSupabaseAdmin();

  const [{ data: chapter }, { data: lessonPlan }] = await Promise.all([
    supabase.from('chapters').select('id, title_en, title_hi').eq('id', chapterId).maybeSingle(),
    supabase.from('lesson_plans').select('*').eq('chapter_id', chapterId).maybeSingle(),
  ]);

  if (!chapter) {
    return jsonNoStore({ error: 'Chapter not found.' }, { status: 404 });
  }

  return jsonNoStore({ chapter, lessonPlan });
}

export async function PUT(
  request: Request,
  context: { params: Promise<{ chapterId: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  const { chapterId } = await context.params;
  const supabase = getSupabaseAdmin();

  const { data: chapter } = await supabase
    .from('chapters')
    .select('id')
    .eq('id', chapterId)
    .maybeSingle();

  if (!chapter) {
    return jsonNoStore({ error: 'Chapter not found.' }, { status: 404 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON request body.' }, { status: 400 });
  }

  const parsed = lessonPlanSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Lesson plan validation failed.', details: parsed.error.flatten() },
      { status: 400 }
    );
  }

  const input = parsed.data;

  const { data: saved, error } = await supabase
    .from('lesson_plans')
    .upsert(
      {
        chapter_id: chapterId,
        duration_periods: input.duration_periods,
        objectives_hi: sanitizeMarkdownSource(input.objectives_hi, 3000),
        objectives_en: sanitizeMarkdownSource(input.objectives_en, 3000),
        teaching_steps_json: input.teaching_steps_json.map((s) => ({
          period_no: s.period_no,
          duration_mins: s.duration_mins,
          phase_hi: sanitizePlainText(s.phase_hi, 200),
          phase_en: sanitizePlainText(s.phase_en, 200),
          teacher_action_hi: sanitizeMarkdownSource(s.teacher_action_hi, 2000),
          teacher_action_en: sanitizeMarkdownSource(s.teacher_action_en, 2000),
          student_check_hi: sanitizeMarkdownSource(s.student_check_hi, 1000),
          student_check_en: sanitizeMarkdownSource(s.student_check_en, 1000),
        })),
        blackboard_points_json: input.blackboard_points_json.map((b) => ({
          heading_hi: sanitizePlainText(b.heading_hi, 200),
          heading_en: sanitizePlainText(b.heading_en, 200),
          points_hi: b.points_hi.map((p) => sanitizeMarkdownSource(p, 600)),
          points_en: b.points_en.map((p) => sanitizeMarkdownSource(p, 600)),
        })),
        classroom_activities_json: input.classroom_activities_json.map((a) => ({
          title_hi: sanitizePlainText(a.title_hi, 200),
          title_en: sanitizePlainText(a.title_en, 200),
          materials_hi: sanitizePlainText(a.materials_hi, 500),
          materials_en: sanitizePlainText(a.materials_en, 500),
          steps_hi: sanitizeMarkdownSource(a.steps_hi, 2000),
          steps_en: sanitizeMarkdownSource(a.steps_en, 2000),
        })),
        homework_json: input.homework_json.map((h) => ({
          level: h.level,
          task_hi: sanitizeMarkdownSource(h.task_hi, 1500),
          task_en: sanitizeMarkdownSource(h.task_en, 1500),
        })),
        common_student_misconceptions_json: input.common_student_misconceptions_json.map((m) => ({
          misconception_hi: sanitizeMarkdownSource(m.misconception_hi, 1000),
          misconception_en: sanitizeMarkdownSource(m.misconception_en, 1000),
          correction_hi: sanitizeMarkdownSource(m.correction_hi, 1500),
          correction_en: sanitizeMarkdownSource(m.correction_en, 1500),
        })),
      },
      { onConflict: 'chapter_id' }
    )
    .select('id, chapter_id, duration_periods, updated_at')
    .single();

  if (error || !saved) {
    return jsonNoStore({ error: 'Failed to save lesson plan.' }, { status: 500 });
  }

  await supabase.from('audit_logs').insert({
    school_udise: null,
    actor_role: 'super_admin',
    actor_id: session.principalId,
    action: 'CMS_LESSON_PLAN_SAVED',
    target_type: 'lesson_plan',
    target_id: chapterId,
    meta_json: { periods: input.duration_periods },
  });

  return jsonNoStore({ ok: true, lessonPlan: saved });
}
