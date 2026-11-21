import { getSupabaseAdmin } from '@/lib/supabase/server';
import { jsonNoStore, requireRole } from '@/lib/auth';

/**
 * GET /api/super-admin/submissions
 * Lists teacher-contributed question papers (Scanned PDF / Image / Word / Excel)
 * awaiting editorial structuring & review, with school, teacher, subject, chapter, and media metadata.
 */
export async function GET(request: Request) {
  const auth = await requireRole(['super_admin'], request);
  if (!auth.ok) return auth.response;

  const url = new URL(request.url);
  const statusFilter = (url.searchParams.get('status') || '').trim().toUpperCase();
  const supabase = getSupabaseAdmin();

  let query = supabase
    .from('question_submissions')
    .select(
      'id, school_udise, teacher_id, subject_id, chapter_id, topic_hint, source_type, media_object_id, status, ai_extracted_json, ai_progress_json, ai_model_used, review_feedback, approved_count, locked_at, created_at, reviewed_at'
    )
    .order('created_at', { ascending: false })
    .limit(100);

  if (
    statusFilter &&
    ['PENDING', 'AI_PARSING', 'AI_READY', 'APPROVED', 'REJECTED'].includes(statusFilter)
  ) {
    query = query.eq('status', statusFilter as 'PENDING' | 'AI_PARSING' | 'AI_READY' | 'APPROVED' | 'REJECTED');
  }

  const { data: submissions, error } = await query;
  if (error) {
    return jsonNoStore({ error: 'Failed to load submission queue.' }, { status: 500 });
  }

  const schoolUdises = Array.from(new Set((submissions ?? []).map((s) => s.school_udise)));
  const teacherIds = Array.from(new Set((submissions ?? []).map((s) => s.teacher_id)));
  const mediaIds = Array.from(new Set((submissions ?? []).map((s) => s.media_object_id)));

  const [{ data: schools }, { data: teachers }, { data: subjects }, { data: chapters }, { data: mediaRows }] =
    await Promise.all([
      schoolUdises.length > 0
        ? supabase.from('schools').select('udise_code, school_name, district_name').in('udise_code', schoolUdises)
        : Promise.resolve({ data: [] }),
      teacherIds.length > 0
        ? supabase.from('teachers').select('id, full_name, teacher_code').in('id', teacherIds)
        : Promise.resolve({ data: [] }),
      supabase.from('subjects').select('id, class_num, stream, name_en, name_hi'),
      supabase.from('chapters').select('id, subject_id, chapter_no, title_en, title_hi').order('chapter_no'),
      mediaIds.length > 0
        ? supabase.from('media_objects').select('id, original_filename, mime_type, size_bytes').in('id', mediaIds)
        : Promise.resolve({ data: [] }),
    ]);

  const schoolMap = new Map((schools ?? []).map((s) => [s.udise_code, s]));
  const teacherMap = new Map((teachers ?? []).map((t) => [t.id, t]));
  const subjectMap = new Map((subjects ?? []).map((s) => [s.id, s]));
  const chapterMap = new Map((chapters ?? []).map((c) => [c.id, c]));
  const mediaMap = new Map((mediaRows ?? []).map((m) => [m.id, m]));

  return jsonNoStore({
    submissions: (submissions ?? []).map((sub) => {
      const sch = schoolMap.get(sub.school_udise);
      const tch = teacherMap.get(sub.teacher_id);
      const subj = subjectMap.get(sub.subject_id);
      const chap = sub.chapter_id ? chapterMap.get(sub.chapter_id) : null;
      const media = mediaMap.get(sub.media_object_id);
      return {
        id: sub.id,
        schoolUdise: sub.school_udise,
        schoolName: sch?.school_name ?? sub.school_udise,
        districtName: sch?.district_name ?? '',
        teacherId: sub.teacher_id,
        teacherName: tch?.full_name ?? 'Teacher',
        teacherCode: tch?.teacher_code ?? '',
        subjectId: sub.subject_id,
        subjectNameEn: subj?.name_en ?? sub.subject_id,
        subjectNameHi: subj?.name_hi ?? sub.subject_id,
        classNum: subj?.class_num ?? null,
        chapterId: sub.chapter_id,
        chapterTitleEn: chap?.title_en ?? null,
        chapterTitleHi: chap?.title_hi ?? null,
        topicHint: sub.topic_hint,
        sourceType: sub.source_type,
        mediaObjectId: sub.media_object_id,
        mediaFilename: media?.original_filename ?? 'document',
        mediaMimeType: media?.mime_type ?? 'application/octet-stream',
        mediaSizeBytes: media?.size_bytes ?? 0,
        status: sub.status,
        aiExtractedJson: sub.ai_extracted_json ?? [],
        aiProgressJson: sub.ai_progress_json,
        aiModelUsed: sub.ai_model_used,
        reviewFeedback: sub.review_feedback,
        approvedCount: sub.approved_count,
        lockedAt: sub.locked_at,
        createdAt: sub.created_at,
        reviewedAt: sub.reviewed_at,
      };
    }),
    chapters: chapters ?? [],
  });
}
