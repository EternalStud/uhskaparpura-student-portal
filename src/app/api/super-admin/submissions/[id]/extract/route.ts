import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole, validateCsrf } from '@/lib/auth';
import { downloadDriveFileBuffer } from '@/lib/drive/google-one';
import {
  extractDocxOrExcel,
  extractPdfChunk,
  MAX_PDF_PAGES_PER_CHUNK,
} from '@/lib/gemini/extractor';
import type { AiExtractedQuestionDraft, AiExtractionProgress } from '@/types/database';

/**
 * POST /api/super-admin/submissions/[id]/extract
 * Super-Admin-only 5-page chunked Gemini extraction route:
 * - Supports `?fromPage=1&toPage=5` (or JSON body `{ fromPage, toPage, reset }`).
 * - Atomic lock with >3-minute stale-lock recovery via `question_submissions.locked_at`.
 * - Runs `find_similar_questions` PostgreSQL pg_trgm duplicate check on every extracted question.
 * - Stores bilingual drafts, confidence (`HIGH|MEDIUM|LOW`), OCR warnings, and duplicate hints
 *   into `ai_extracted_json` & `ai_progress_json`.
 */

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const STALE_LOCK_MS = 3 * 60 * 1000; // 3 minutes stale lock recovery

export async function POST(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  const { id } = await context.params;
  if (!UUID_REGEX.test(id)) {
    return jsonNoStore({ error: 'Invalid submission ID.' }, { status: 400 });
  }

  const url = new URL(request.url);
  let body: { fromPage?: number; toPage?: number; reset?: boolean } = {};
  try {
    const text = await request.text();
    if (text.trim()) {
      body = JSON.parse(text) as typeof body;
    }
  } catch {
    return jsonNoStore({ error: 'Invalid JSON body.' }, { status: 400 });
  }

  const fromPageRaw = Number(
    body.fromPage ?? url.searchParams.get('fromPage') ?? 1
  );
  const toPageRaw = Number(
    body.toPage ??
      url.searchParams.get('toPage') ??
      fromPageRaw + MAX_PDF_PAGES_PER_CHUNK - 1
  );
  const fromPage = Number.isFinite(fromPageRaw) && fromPageRaw >= 1 ? Math.floor(fromPageRaw) : 1;
  const toPage =
    Number.isFinite(toPageRaw) && toPageRaw >= fromPage
      ? Math.min(fromPage + MAX_PDF_PAGES_PER_CHUNK - 1, Math.floor(toPageRaw))
      : fromPage + MAX_PDF_PAGES_PER_CHUNK - 1;
  const reset = Boolean(body.reset);

  const supabase = getSupabaseAdmin();

  const { data: submission, error: subErr } = await supabase
    .from('question_submissions')
    .select(
      'id, subject_id, chapter_id, topic_hint, source_type, media_object_id, status, ai_extracted_json, ai_progress_json, locked_at'
    )
    .eq('id', id)
    .maybeSingle();

  if (subErr || !submission) {
    return jsonNoStore({ error: 'Submission not found.' }, { status: 404 });
  }

  if (submission.status === 'APPROVED' || submission.status === 'REJECTED') {
    return jsonNoStore(
      { error: `Submission is already finalized (${submission.status}).` },
      { status: 409 }
    );
  }

  // Atomic lock acquisition with >3-minute stale-lock recovery (prevents TOCTOU race)
  const now = new Date();
  const staleCutoffIso = new Date(now.getTime() - STALE_LOCK_MS).toISOString();

  const { data: lockedRow, error: lockErr } = await supabase
    .from('question_submissions')
    .update({
      status: 'AI_PARSING',
      locked_at: now.toISOString(),
    })
    .eq('id', id)
    .in('status', ['PENDING', 'AI_PARSING', 'AI_READY'])
    .or(`locked_at.is.null,locked_at.lt.${staleCutoffIso}`)
    .select('id')
    .maybeSingle();

  if (lockErr) {
    return jsonNoStore({ error: 'Failed to acquire extraction lock.' }, { status: 500 });
  }
  if (!lockedRow) {
    return jsonNoStore(
      {
        error:
          'Extraction is already running for this submission. Wait a moment or retry after 3 minutes.',
      },
      { status: 409 }
    );
  }

  try {
    const [{ data: media }, { data: subject }, { data: chapter }] = await Promise.all([
      supabase
        .from('media_objects')
        .select('id, drive_file_id, mime_type, original_filename, status')
        .eq('id', submission.media_object_id)
        .maybeSingle(),
      supabase
        .from('subjects')
        .select('id, class_num, name_en, name_hi')
        .eq('id', submission.subject_id)
        .maybeSingle(),
      submission.chapter_id
        ? supabase
            .from('chapters')
            .select('id, title_en, title_hi')
            .eq('id', submission.chapter_id)
            .maybeSingle()
        : Promise.resolve({ data: null }),
    ]);

    if (!media || !media.drive_file_id || media.status !== 'ACTIVE') {
      throw new Error('Submission source file is not available in media vault.');
    }

    const fileBuffer = await downloadDriveFileBuffer(media.drive_file_id, 25 * 1024 * 1024);

    const subjectContext = {
      classNum: subject?.class_num,
      subjectName: subject ? `${subject.name_en} (${subject.name_hi})` : submission.subject_id,
      chapterTitle: chapter ? `${chapter.title_en} (${chapter.title_hi})` : null,
      topicHint: submission.topic_hint,
    };

    let chunkQuestions: AiExtractedQuestionDraft[] = [];
    let modelUsed = 'gemini-2.5-flash';
    let warnings: string[] = [];
    let totalPages: number | undefined;
    let processedPages = 1;
    let hasMorePages = false;
    let nextFromPage: number | null = null;

    if (media.mime_type === 'application/pdf' || submission.source_type === 'SCANNED_PDF') {
      const pdfRes = await extractPdfChunk({
        pdfBuffer: fileBuffer,
        fromPage,
        toPage,
        subjectContext,
        chapterContext: chapter?.title_en ?? null,
      });
      chunkQuestions = pdfRes.questions;
      modelUsed = pdfRes.modelUsed;
      warnings = pdfRes.warnings;
      totalPages = pdfRes.totalPdfPages;
      processedPages = pdfRes.toPage;
      hasMorePages = pdfRes.hasMorePages;
      nextFromPage = pdfRes.nextFromPage;
    } else {
      const docRes = await extractDocxOrExcel({
        buffer: fileBuffer,
        mimeType: media.mime_type,
        subjectContext,
        chapterContext: chapter?.title_en ?? null,
      });
      chunkQuestions = docRes.questions;
      modelUsed = docRes.modelUsed;
      warnings = docRes.warnings;
      totalPages = 1;
      processedPages = 1;
      hasMorePages = false;
      nextFromPage = null;
    }

    // Run PostgreSQL pg_trgm duplicate check (`find_similar_questions`) on each extracted question
    const enrichedChunk: AiExtractedQuestionDraft[] = await Promise.all(
      chunkQuestions.map(async (draft) => {
        try {
          const { data: matches } = await supabase.rpc('find_similar_questions', {
            p_subject_id: submission.subject_id,
            p_q_en: draft.q_en,
            p_q_hi: draft.q_hi,
            p_threshold: 0.62,
            p_limit: 1,
          });
          const top = Array.isArray(matches) ? matches[0] : null;
          if (top) {
            return {
              ...draft,
              duplicate_question_id: top.id,
              duplicate_similarity: Number(top.sim_score),
            };
          }
        } catch {
          // Non-fatal: continue even if similarity search returns empty/errors
        }
        return draft;
      })
    );

    const existingDrafts = reset ? [] : (submission.ai_extracted_json ?? []);
    const mergedDrafts = [...existingDrafts, ...enrichedChunk];
    const prevProgress = submission.ai_progress_json;
    const progress: AiExtractionProgress = {
      total_pages: totalPages ?? prevProgress?.total_pages,
      processed_pages: reset
        ? processedPages
        : Math.max(prevProgress?.processed_pages ?? 0, processedPages),
      extracted_count: mergedDrafts.length,
      last_chunk_at: new Date().toISOString(),
      errors: warnings.length > 0 ? warnings : undefined,
    };

    await supabase
      .from('question_submissions')
      .update({
        status: 'AI_READY',
        ai_extracted_json: mergedDrafts,
        ai_progress_json: progress,
        ai_model_used: modelUsed,
        locked_at: null,
      })
      .eq('id', id);

    return jsonNoStore({
      ok: true,
      chunkExtractedCount: enrichedChunk.length,
      totalExtractedCount: mergedDrafts.length,
      questions: mergedDrafts,
      progress,
      hasMorePages,
      nextFromPage,
      modelUsed,
      warnings,
    });
  } catch (err) {
    // Release lock and restore status cleanly so Super Admin can retry
    const fallbackStatus =
      (submission.ai_extracted_json?.length ?? 0) > 0 ? 'AI_READY' : 'PENDING';
    await supabase
      .from('question_submissions')
      .update({
        status: fallbackStatus,
        locked_at: null,
      })
      .eq('id', id);

    return jsonNoStore(
      {
        error:
          err instanceof Error ? err.message : 'Question extraction failed for this chunk.',
      },
      { status: 502 }
    );
  }
}
