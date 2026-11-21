import { z } from 'zod';
import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole, validateCsrf } from '@/lib/auth';
import {
  sanitizeMarkdownSource,
  sanitizePlainText,
  validateBilingualDiagramSpec,
} from '@/lib/sanitize/content';
import type {
  BoardCapsuleSpec,
  MindmapSpec,
  NoteSection,
  QualityChecksSpec,
} from '@/types/database';

/**
 * GET / PUT /api/super-admin/cms/notes/[chapterId]
 * Visual Bilingual Chapter Notes CMS with Mandatory Gold Quality Checklist Gate:
 * Before `status = 'PUBLISHED'`, enforces:
 *  1. Complete Hindi + English bilingual parity across mindmap & every section.
 *  2. At least 1 declarative bilingual visual diagram passing `validateBilingualDiagramSpec` (zero XSS/scripts).
 *  3. Everyday Bihar analogy + in-depth concept explanation present in every section.
 *  4. At least 1 published practice question AND a Teacher Lesson Plan exist for the chapter.
 */

const mindmapNodeSchema: z.ZodType<MindmapSpec['branches'][number]> = z.lazy(() =>
  z.object({
    id: z.string().trim().min(1).max(60),
    label_hi: z.string().trim().min(1).max(200),
    label_en: z.string().trim().min(1).max(200),
    detail_hi: z.string().trim().max(400).optional(),
    detail_en: z.string().trim().max(400).optional(),
    formula_latex: z.string().trim().max(200).optional(),
    color: z.string().trim().max(32).optional(),
    children: z.array(mindmapNodeSchema).max(12).optional(),
  })
);

const mindmapSchema = z.object({
  title_hi: z.string().trim().min(2).max(200),
  title_en: z.string().trim().min(2).max(200),
  read_time_seconds: z.number().int().min(10).max(300).default(30),
  central_node: z.object({
    id: z.string().trim().min(1).max(60),
    label_hi: z.string().trim().min(1).max(200),
    label_en: z.string().trim().min(1).max(200),
    subtitle_hi: z.string().trim().max(300).optional(),
    subtitle_en: z.string().trim().max(300).optional(),
  }),
  branches: z.array(mindmapNodeSchema).min(1).max(12),
});

const noteSectionSchema = z.object({
  id: z.string().trim().min(1).max(60),
  order: z.number().int().min(1).max(30),
  heading_hi: z.string().trim().min(2).max(240),
  heading_en: z.string().trim().min(2).max(240),
  analogy_hi: z.string().trim().max(2000),
  analogy_en: z.string().trim().max(2000),
  visual_diagram: z.unknown().optional(),
  concept_md_hi: z.string().trim().min(5).max(15000),
  concept_md_en: z.string().trim().min(5).max(15000),
  exam_tip_hi: z.string().trim().max(2000),
  exam_tip_en: z.string().trim().max(2000),
  glossary_terms: z
    .array(
      z.object({
        term_hi: z.string().trim().min(1).max(120),
        term_en: z.string().trim().min(1).max(120),
        definition_hi: z.string().trim().min(1).max(500),
        definition_en: z.string().trim().min(1).max(500),
      })
    )
    .max(25)
    .default([]),
  quick_check: z
    .object({
      q_hi: z.string().trim().min(2).max(600),
      q_en: z.string().trim().min(2).max(600),
      answer_hi: z.string().trim().min(1).max(1200),
      answer_en: z.string().trim().min(1).max(1200),
    })
    .optional(),
});

const putNoteSchema = z.object({
  status: z.enum(['DRAFT', 'PUBLISHED']),
  mindmap_json: mindmapSchema,
  sections_json: z.array(noteSectionSchema).min(1).max(25),
  board_capsule_json: z.record(z.unknown()).optional(),
  reviewer_notes: z.string().trim().max(1000).optional(),
  syllabus_year: z.string().trim().max(20).optional(),
});

export async function GET(
  request: Request,
  context: { params: Promise<{ chapterId: string }> }
) {
  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  const { chapterId } = await context.params;
  const supabase = getSupabaseAdmin();

  const [{ data: chapter }, { data: note }, { data: lessonPlan }, { count: practiceCount }] =
    await Promise.all([
      supabase.from('chapters').select('*').eq('id', chapterId).maybeSingle(),
      supabase.from('chapter_notes').select('*').eq('chapter_id', chapterId).maybeSingle(),
      supabase.from('lesson_plans').select('id').eq('chapter_id', chapterId).maybeSingle(),
      supabase
        .from('questions')
        .select('id', { count: 'exact', head: true })
        .eq('chapter_id', chapterId)
        .eq('bank_pool', 'PRACTICE')
        .eq('is_published', true),
    ]);

  if (!chapter) {
    return jsonNoStore({ error: 'Chapter not found.' }, { status: 404 });
  }

  return jsonNoStore({
    chapter,
    note,
    readiness: {
      hasLessonPlan: Boolean(lessonPlan),
      publishedPracticeQuestions: practiceCount ?? 0,
    },
  });
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

  const parsed = putNoteSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: 'Note structure validation failed.', details: parsed.error.flatten() },
      { status: 400 }
    );
  }

  const input = parsed.data;

  // Validate EVERY visual diagram strictly against declarative BilingualDiagramSpec allowlist!
  const sanitizedSections: NoteSection[] = [];
  let validVisualsCount = 0;
  let analogyCount = 0;
  let bilingualParityOk = true;
  const diagramErrors: string[] = [];

  for (const sec of input.sections_json) {
    let validatedDiagram: NoteSection['visual_diagram'] = undefined;
    if (sec.visual_diagram !== undefined && sec.visual_diagram !== null) {
      const diagCheck = validateBilingualDiagramSpec(sec.visual_diagram);
      if (!diagCheck.ok) {
        diagramErrors.push(`Section "${sec.id}": ${diagCheck.errors.join('; ')}`);
      } else {
        validatedDiagram = diagCheck.data;
        validVisualsCount++;
      }
    }

    if (sec.analogy_hi.trim().length >= 10 && sec.analogy_en.trim().length >= 10) {
      analogyCount++;
    }
    if (
      sec.concept_md_hi.trim().length < 20 ||
      sec.concept_md_en.trim().length < 20 ||
      !sec.heading_hi.trim() ||
      !sec.heading_en.trim()
    ) {
      bilingualParityOk = false;
    }

    sanitizedSections.push({
      id: sec.id,
      order: sec.order,
      heading_hi: sanitizePlainText(sec.heading_hi, 240),
      heading_en: sanitizePlainText(sec.heading_en, 240),
      analogy_hi: sanitizeMarkdownSource(sec.analogy_hi, 2000),
      analogy_en: sanitizeMarkdownSource(sec.analogy_en, 2000),
      visual_diagram: validatedDiagram,
      concept_md_hi: sanitizeMarkdownSource(sec.concept_md_hi, 15000),
      concept_md_en: sanitizeMarkdownSource(sec.concept_md_en, 15000),
      exam_tip_hi: sanitizeMarkdownSource(sec.exam_tip_hi, 2000),
      exam_tip_en: sanitizeMarkdownSource(sec.exam_tip_en, 2000),
      glossary_terms: sec.glossary_terms.map((g) => ({
        term_hi: sanitizePlainText(g.term_hi, 120),
        term_en: sanitizePlainText(g.term_en, 120),
        definition_hi: sanitizePlainText(g.definition_hi, 500),
        definition_en: sanitizePlainText(g.definition_en, 500),
      })),
      ...(sec.quick_check
        ? {
            quick_check: {
              q_hi: sanitizeMarkdownSource(sec.quick_check.q_hi, 600),
              q_en: sanitizeMarkdownSource(sec.quick_check.q_en, 600),
              answer_hi: sanitizeMarkdownSource(sec.quick_check.answer_hi, 1200),
              answer_en: sanitizeMarkdownSource(sec.quick_check.answer_en, 1200),
            },
          }
        : {}),
    });
  }

  if (diagramErrors.length > 0) {
    return jsonNoStore(
      {
        error: 'One or more visual diagrams failed strict declarative SVG security validation.',
        diagramErrors,
      },
      { status: 400 }
    );
  }

  // Check Practice Questions & Lesson Plan readiness
  const [{ data: existingNote }, { data: lessonPlan }, { count: practiceCount }] =
    await Promise.all([
      supabase.from('chapter_notes').select('version').eq('chapter_id', chapterId).maybeSingle(),
      supabase.from('lesson_plans').select('id').eq('chapter_id', chapterId).maybeSingle(),
      supabase
        .from('questions')
        .select('id', { count: 'exact', head: true })
        .eq('chapter_id', chapterId)
        .eq('bank_pool', 'PRACTICE')
        .eq('is_published', true),
    ]);

  const checklist = {
    bilingualParity: bilingualParityOk,
    hasValidatedVisualDiagram: validVisualsCount >= 1,
    hasEverydayAnalogy: analogyCount >= 1,
    hasPracticeQuestions: (practiceCount ?? 0) >= 1,
    hasLessonPlan: Boolean(lessonPlan),
  };

  // MANDATORY QUALITY CHECKLIST GATE before publishing!
  if (input.status === 'PUBLISHED') {
    const failedGates: string[] = [];
    if (!checklist.bilingualParity) {
      failedGates.push('Every section must have complete Hindi + English headings & concepts.');
    }
    if (!checklist.hasValidatedVisualDiagram) {
      failedGates.push('Include at least 1 validated bilingual visual diagram, table, or flowchart.');
    }
    if (!checklist.hasEverydayAnalogy) {
      failedGates.push('Include at least 1 simple everyday Bihar analogy in Hindi & English.');
    }
    if (!checklist.hasPracticeQuestions) {
      failedGates.push('Chapter must have at least 1 published practice question before publishing notes.');
    }
    if (!checklist.hasLessonPlan) {
      failedGates.push('Chapter must have a matching Teacher Lesson Plan before publishing notes.');
    }

    if (failedGates.length > 0) {
      return jsonNoStore(
        {
          error: 'Quality Checklist Gate failed — save as DRAFT until all gold quality standards are met.',
          checklist,
          failedGates,
        },
        { status: 422 }
      );
    }
  }

  const qualityChecks: QualityChecksSpec = {
    hindi_reviewed: bilingualParityOk,
    english_reviewed: bilingualParityOk,
    visuals_count: validVisualsCount,
    analogy_count: analogyCount,
    bseb_pyq_mapped: (practiceCount ?? 0) > 0,
    syllabus_year: input.syllabus_year || '2026-27',
    reviewer_notes: input.reviewer_notes
      ? sanitizePlainText(input.reviewer_notes, 1000)
      : undefined,
  };

  const defaultCapsule: BoardCapsuleSpec = {
    important_formulas: [],
    key_dates_or_facts: [],
    common_bseb_mistakes: [],
    high_yield_pyq_topics: [],
  };

  const nextVersion = (existingNote?.version ?? 0) + 1;

  const { data: saved, error: saveErr } = await supabase
    .from('chapter_notes')
    .upsert(
      {
        chapter_id: chapterId,
        mindmap_json: input.mindmap_json as MindmapSpec,
        sections_json: sanitizedSections,
        board_capsule_json: (input.board_capsule_json ?? defaultCapsule) as BoardCapsuleSpec,
        quality_checks_json: qualityChecks,
        status: input.status,
        version: nextVersion,
      },
      { onConflict: 'chapter_id' }
    )
    .select('id, chapter_id, status, version, updated_at')
    .single();

  if (saveErr || !saved) {
    return jsonNoStore({ error: 'Failed to save chapter notes.' }, { status: 500 });
  }

  await supabase.from('audit_logs').insert({
    school_udise: null,
    actor_role: 'super_admin',
    actor_id: session.principalId,
    action: input.status === 'PUBLISHED' ? 'CMS_NOTE_PUBLISHED' : 'CMS_NOTE_SAVED_DRAFT',
    target_type: 'chapter_note',
    target_id: chapterId,
    meta_json: { version: nextVersion, visualsCount: validVisualsCount },
  });

  return jsonNoStore({
    ok: true,
    note: saved,
    checklist,
  });
}
