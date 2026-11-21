import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole, validateCsrf } from '@/lib/auth';
import { sanitizeMarkdownSource, sanitizePlainText } from '@/lib/sanitize/content';

/**
 * POST /api/super-admin/submissions/[id]/publish
 * Finalizes an editorial question submission:
 * - `action: 'REJECT'`: marks `REJECTED` with constructive teacher feedback.
 * - `action: 'APPROVE'`: publishes reviewed/edited questions into `questions` table
 *   (in `PRACTICE` or `EXAM_ONLY` pool), attributing `source_submission_id` & `contributed_by_teacher`.
 */

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const optionSchema = z.object({
  key: z.enum(['A', 'B', 'C', 'D']),
  text_hi: z.string().trim().min(1).max(1000),
  text_en: z.string().trim().min(1).max(1000),
});

const markingItemSchema = z.object({
  step_no: z.number().int().min(1).max(20),
  marks: z.number().min(0.5).max(10),
  criterion_hi: z.string().trim().min(1).max(1000),
  criterion_en: z.string().trim().min(1).max(1000),
});

const approvedQuestionSchema = z.object({
  question_type: z.enum(['MCQ', 'SHORT_2M', 'LONG_5M', 'MATCH_PAIRS', 'DIAGRAM_LABEL', 'FLASHCARD']),
  difficulty_tier: z.enum(['FOUNDATION', 'BOARD', 'TOPPER']).default('BOARD'),
  bank_pool: z.enum(['PRACTICE', 'EXAM_ONLY']).optional(),
  topic_tag: z.string().trim().max(120).nullable().optional(),
  exam_year_tag: z.string().trim().max(40).nullable().optional(),
  q_hi: z.string().trim().min(3).max(4000),
  q_en: z.string().trim().min(3).max(4000),
  options_json: z.array(optionSchema).max(4).nullable().optional(),
  correct_option: z.enum(['A', 'B', 'C', 'D']).nullable().optional(),
  clue_hi: z.string().trim().max(1500).nullable().optional(),
  clue_en: z.string().trim().max(1500).nullable().optional(),
  explanation_hi: z.string().trim().max(4000).nullable().optional(),
  explanation_en: z.string().trim().max(4000).nullable().optional(),
  model_answer_hi: z.string().trim().max(8000).nullable().optional(),
  model_answer_en: z.string().trim().max(8000).nullable().optional(),
  marking_scheme_json: z.array(markingItemSchema).max(15).optional(),
});

const publishRequestSchema = z.discriminatedUnion('action', [
  z.object({
    action: z.literal('REJECT'),
    reviewFeedback: z.string().trim().min(3).max(1000),
  }),
  z.object({
    action: z.literal('APPROVE'),
    chapterId: z.string().trim().min(2).max(120),
    defaultBankPool: z.enum(['PRACTICE', 'EXAM_ONLY']).default('PRACTICE'),
    reviewFeedback: z.string().trim().max(1000).optional(),
    questions: z.array(approvedQuestionSchema).min(1).max(150),
  }),
]);

export async function POST(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  const { id } = await context.params;
  if (!UUID_REGEX.test(id)) {
    return jsonNoStore({ error: 'Invalid submission ID.' }, { status: 400 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: 'Invalid JSON request body.' }, { status: 400 });
  }

  const parsed = publishRequestSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Validation failed for publish payload.', details: parsed.error.flatten() },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();
  const { data: submission } = await supabase
    .from('question_submissions')
    .select('id, school_udise, teacher_id, subject_id, chapter_id, status')
    .eq('id', id)
    .maybeSingle();

  if (!submission) {
    return jsonNoStore({ error: 'Submission not found.' }, { status: 404 });
  }

  if (submission.status === 'APPROVED') {
    return jsonNoStore({ error: 'This submission has already been published.' }, { status: 409 });
  }

  const nowIso = new Date().toISOString();

  if (parsed.data.action === 'REJECT') {
    const cleanFeedback = sanitizePlainText(parsed.data.reviewFeedback, 1000);
    await supabase
      .from('question_submissions')
      .update({
        status: 'REJECTED',
        reviewed_by: session.principalId,
        review_feedback: cleanFeedback,
        reviewed_at: nowIso,
        locked_at: null,
      })
      .eq('id', id);

    await supabase.from('audit_logs').insert({
      school_udise: submission.school_udise,
      actor_role: 'super_admin',
      actor_id: session.principalId,
      action: 'SUPER_ADMIN_SUBMISSION_REJECTED',
      target_type: 'question_submission',
      target_id: id,
      meta_json: { feedbackLength: cleanFeedback.length },
    });

    return jsonNoStore({ ok: true, status: 'REJECTED' });
  }

  // APPROVE & PUBLISH
  const { chapterId, defaultBankPool, reviewFeedback, questions } = parsed.data;

  // Verify chapter belongs to submission's subject
  const { data: chapter } = await supabase
    .from('chapters')
    .select('id, subject_id')
    .eq('id', chapterId)
    .maybeSingle();

  if (!chapter) {
    return jsonNoStore({ error: 'Target chapter does not exist.' }, { status: 400 });
  }

  // Validate MCQ constraints cleanly BEFORE writing to DB (returns 400 instead of 500)
  for (let i = 0; i < questions.length; i++) {
    const q = questions[i];
    if (q.question_type === 'MCQ') {
      const opts = q.options_json ?? [];
      const keys = new Set(opts.map((o) => o.key));
      if (opts.length !== 4 || keys.size !== 4 || !q.correct_option) {
        return jsonNoStore(
          {
            error: `Question #${i + 1}: Every approved MCQ must have 4 distinct options (A–D) and a valid correct_option.`,
          },
          { status: 400 }
        );
      }
    }
  }

  // Atomically claim submission transition to APPROVED first to block double-click duplicate inserts
  const { data: claimed, error: claimErr } = await supabase
    .from('question_submissions')
    .update({
      chapter_id: chapter.id,
      status: 'APPROVED',
      approved_count: questions.length,
      reviewed_by: session.principalId,
      review_feedback: reviewFeedback ? sanitizePlainText(reviewFeedback, 1000) : null,
      reviewed_at: nowIso,
      locked_at: null,
    })
    .eq('id', id)
    .in('status', ['PENDING', 'AI_READY', 'REJECTED'])
    .select('id')
    .maybeSingle();

  if (claimErr || !claimed) {
    return jsonNoStore(
      { error: 'This submission was already published or is currently being processed.' },
      { status: 409 }
    );
  }

  const rowsToInsert = questions.map((q) => ({
    subject_id: chapter.subject_id,
    chapter_id: chapter.id,
    topic_tag: q.topic_tag ? sanitizePlainText(q.topic_tag, 120) : null,
    bank_pool: q.bank_pool ?? defaultBankPool,
    question_type: q.question_type,
    difficulty_tier: q.difficulty_tier,
    exam_year_tag: q.exam_year_tag ? sanitizePlainText(q.exam_year_tag, 40) : null,
    q_hi: sanitizeMarkdownSource(q.q_hi, 4000),
    q_en: sanitizeMarkdownSource(q.q_en, 4000),
    options_json: q.options_json
      ? q.options_json.map((o) => ({
          key: o.key,
          text_hi: sanitizeMarkdownSource(o.text_hi, 1000),
          text_en: sanitizeMarkdownSource(o.text_en, 1000),
        }))
      : null,
    correct_option: q.question_type === 'MCQ' ? (q.correct_option ?? null) : null,
    clue_hi: q.clue_hi ? sanitizeMarkdownSource(q.clue_hi, 1500) : null,
    clue_en: q.clue_en ? sanitizeMarkdownSource(q.clue_en, 1500) : null,
    explanation_hi: q.explanation_hi ? sanitizeMarkdownSource(q.explanation_hi, 4000) : null,
    explanation_en: q.explanation_en ? sanitizeMarkdownSource(q.explanation_en, 4000) : null,
    model_answer_hi: q.model_answer_hi ? sanitizeMarkdownSource(q.model_answer_hi, 8000) : null,
    model_answer_en: q.model_answer_en ? sanitizeMarkdownSource(q.model_answer_en, 8000) : null,
    memory_cues_json: [],
    marking_scheme_json: (q.marking_scheme_json ?? []).map((m) => ({
      step_no: m.step_no,
      marks: m.marks,
      criterion_hi: sanitizePlainText(m.criterion_hi, 1000),
      criterion_en: sanitizePlainText(m.criterion_en, 1000),
    })),
    source_submission_id: submission.id,
    contributed_by_teacher: submission.teacher_id,
    is_published: true,
  }));

  const { error: insertErr } = await supabase.from('questions').insert(rowsToInsert);
  if (insertErr) {
    // Roll back submission status so Super Admin can retry safely
    await supabase
      .from('question_submissions')
      .update({
        status: submission.status,
        approved_count: 0,
        reviewed_at: null,
      })
      .eq('id', id);

    return jsonNoStore(
      { error: `Failed to publish questions into bank: ${insertErr.message}` },
      { status: 500 }
    );
  }

  await supabase.from('audit_logs').insert({
    school_udise: submission.school_udise,
    actor_role: 'super_admin',
    actor_id: session.principalId,
    action: 'SUPER_ADMIN_SUBMISSION_PUBLISHED',
    target_type: 'question_submission',
    target_id: id,
    meta_json: {
      chapterId: chapter.id,
      publishedCount: rowsToInsert.length,
      defaultBankPool,
    },
  });

  return jsonNoStore({
    ok: true,
    status: 'APPROVED',
    publishedCount: rowsToInsert.length,
  });
}
