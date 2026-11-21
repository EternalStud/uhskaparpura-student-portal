import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole, validateCsrf } from '@/lib/auth';
import { sanitizePlainText } from '@/lib/sanitize/content';

/**
 * GET / POST /api/super-admin/cms/chapters
 * Master Visual Curriculum CMS catalog: returns all BSEB subjects & chapters
 * annotated with note status, lesson plan availability, and practice/exam question counts.
 */

const createChapterSchema = z.object({
  id: z
    .string()
    .trim()
    .regex(/^[a-z0-9-]{4,80}$/, 'Chapter ID must be lowercase alphanumeric with hyphens'),
  subjectId: z.string().trim().min(2).max(80),
  chapterNo: z.number().int().min(1).max(40),
  titleEn: z.string().trim().min(2).max(200),
  titleHi: z.string().trim().min(2).max(200),
  summaryEn: z.string().trim().max(1000).nullable().optional(),
  summaryHi: z.string().trim().max(1000).nullable().optional(),
  bsebWeightageMarks: z.number().int().min(0).max(50).default(5),
  estimatedMins: z.number().int().min(5).max(180).default(15),
  isPublished: z.boolean().default(true),
});

export async function GET(request: Request) {
  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  const supabase = getSupabaseAdmin();

  const [{ data: subjects }, { data: chapters }, { data: notes }, { data: plans }, { data: questions }] =
    await Promise.all([
      supabase
        .from('subjects')
        .select('id, bseb_code, class_num, stream, category, name_en, name_hi')
        .order('class_num', { ascending: true })
        .order('sort_order', { ascending: true }),
      supabase
        .from('chapters')
        .select(
          'id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published'
        )
        .order('subject_id', { ascending: true })
        .order('chapter_no', { ascending: true }),
      supabase.from('chapter_notes').select('chapter_id, status, version, updated_at'),
      supabase.from('lesson_plans').select('chapter_id, duration_periods, updated_at'),
      supabase
        .from('questions')
        .select('chapter_id, bank_pool, is_published')
        .eq('is_published', true),
    ]);

  const noteByChapter = new Map((notes ?? []).map((n) => [n.chapter_id, n]));
  const planByChapter = new Map((plans ?? []).map((p) => [p.chapter_id, p]));
  const qCounts = new Map<string, { practice: number; examOnly: number }>();

  for (const q of questions ?? []) {
    const entry = qCounts.get(q.chapter_id) ?? { practice: 0, examOnly: 0 };
    if (q.bank_pool === 'EXAM_ONLY') entry.examOnly++;
    else entry.practice++;
    qCounts.set(q.chapter_id, entry);
  }

  return jsonNoStore({
    subjects: subjects ?? [],
    chapters: (chapters ?? []).map((ch) => {
      const note = noteByChapter.get(ch.id);
      const plan = planByChapter.get(ch.id);
      const counts = qCounts.get(ch.id) ?? { practice: 0, examOnly: 0 };
      return {
        ...ch,
        noteStatus: note?.status ?? 'MISSING',
        noteVersion: note?.version ?? 0,
        noteUpdatedAt: note?.updated_at ?? null,
        hasLessonPlan: Boolean(plan),
        lessonPeriods: plan?.duration_periods ?? null,
        practiceQuestionsCount: counts.practice,
        examOnlyQuestionsCount: counts.examOnly,
      };
    }),
  });
}

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON request body.' }, { status: 400 });
  }

  const parsed = createChapterSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Invalid chapter payload.', details: parsed.error.flatten().fieldErrors },
      { status: 400 }
    );
  }

  const input = parsed.data;
  const supabase = getSupabaseAdmin();

  const { data: created, error } = await supabase
    .from('chapters')
    .insert({
      id: input.id,
      subject_id: input.subjectId,
      chapter_no: input.chapterNo,
      title_en: sanitizePlainText(input.titleEn, 200),
      title_hi: sanitizePlainText(input.titleHi, 200),
      summary_en: input.summaryEn ? sanitizePlainText(input.summaryEn, 1000) : null,
      summary_hi: input.summaryHi ? sanitizePlainText(input.summaryHi, 1000) : null,
      bseb_weightage_marks: input.bsebWeightageMarks,
      estimated_mins: input.estimatedMins,
      is_published: input.isPublished,
    })
    .select('*')
    .single();

  if (error || !created) {
    return jsonNoStore(
      { error: `Failed to create chapter: ${error?.message ?? 'duplicate ID or chapter_no'}` },
      { status: 409 }
    );
  }

  return jsonNoStore({ ok: true, chapter: created }, { status: 201 });
}
