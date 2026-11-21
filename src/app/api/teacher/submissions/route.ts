import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole, validateCsrf } from "@/lib/auth";
import { sanitizePlainText } from "@/lib/sanitize/content";
import type { SubmissionSourceType, SubmissionStatus } from "@/types/database";

/**
 * GET / POST /api/teacher/submissions
 * Clean editorial contribution desk for Bihar teachers.
 * STRICT HYGIENE: Never exposes internal review tooling, AI extraction JSON,
 * model names, or Super Admin references.
 */

const createSubmissionSchema = z.object({
  subjectId: z.string().trim().min(2).max(80),
  chapterId: z.string().trim().min(2).max(100).nullable().optional(),
  topicHint: z.string().trim().max(240).nullable().optional(),
  sourceType: z.enum(["SCANNED_PDF", "EXCEL", "WORD", "IMAGE"]),
  mediaObjectId: z.string().uuid(),
});

const SOURCE_TYPE_MIME_MAP: Record<SubmissionSourceType, ReadonlyArray<string>> = {
  SCANNED_PDF: ["application/pdf"],
  IMAGE: ["image/jpeg", "image/png", "image/webp"],
  WORD: [
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  ],
  EXCEL: [
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  ],
};

function mapEditorialStatus(
  status: SubmissionStatus,
  approvedCount: number
): {
  code: "SUBMITTED" | "UNDER_REVIEW" | "PUBLISHED" | "FEEDBACK_RECEIVED";
  labelEn: string;
  labelHi: string;
} {
  switch (status) {
    case "PENDING":
      return {
        code: "SUBMITTED",
        labelEn: "Submitted",
        labelHi: "प्रस्तुत किया गया",
      };
    case "AI_PARSING":
    case "AI_READY":
      return {
        code: "UNDER_REVIEW",
        labelEn: "Under Review",
        labelHi: "समीक्षाधीन",
      };
    case "APPROVED":
      return {
        code: "PUBLISHED",
        labelEn:
          approvedCount > 0
            ? `Published (+${approvedCount} questions)`
            : "Published",
        labelHi:
          approvedCount > 0
            ? `प्रकाशित (+${approvedCount} प्रश्न)`
            : "प्रकाशित",
      };
    case "REJECTED":
      return {
        code: "FEEDBACK_RECEIVED",
        labelEn: "Feedback Received",
        labelHi: "सुझाव प्राप्त",
      };
  }
}

export async function GET(request: Request) {
  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
  }

  const supabase = getSupabaseAdmin();

  // Strictly select ONLY teacher-safe editorial fields (zero AI/internal columns)
  const { data: rows, error } = await supabase
    .from("question_submissions")
    .select(
      "id, subject_id, chapter_id, topic_hint, source_type, media_object_id, status, review_feedback, approved_count, created_at, reviewed_at"
    )
    .eq("school_udise", session.schoolUdise)
    .eq("teacher_id", session.principalId)
    .order("created_at", { ascending: false })
    .limit(100);

  if (error) {
    return jsonNoStore(
      { error: "Unable to load your submitted question papers." },
      { status: 500 }
    );
  }

  const submissions = rows ?? [];
  const subjectIds = Array.from(new Set(submissions.map((s) => s.subject_id)));
  const chapterIds = Array.from(
    new Set(submissions.map((s) => s.chapter_id).filter((v): v is string => Boolean(v)))
  );
  const mediaIds = Array.from(new Set(submissions.map((s) => s.media_object_id)));

  const [subjRes, chapRes, mediaRes] = await Promise.all([
    subjectIds.length > 0
      ? supabase
          .from("subjects")
          .select("id, class_num, name_hi, name_en")
          .in("id", subjectIds)
      : Promise.resolve({ data: [] }),
    chapterIds.length > 0
      ? supabase
          .from("chapters")
          .select("id, chapter_no, title_hi, title_en")
          .in("id", chapterIds)
      : Promise.resolve({ data: [] }),
    mediaIds.length > 0
      ? supabase
          .from("media_objects")
          .select("id, original_filename, mime_type, size_bytes")
          .in("id", mediaIds)
      : Promise.resolve({ data: [] }),
  ]);

  const subjectMap = new Map((subjRes.data ?? []).map((s) => [s.id, s]));
  const chapterMap = new Map((chapRes.data ?? []).map((c) => [c.id, c]));
  const mediaMap = new Map((mediaRes.data ?? []).map((m) => [m.id, m]));

  const items = submissions.map((row) => {
    const editorialStatus = mapEditorialStatus(row.status, row.approved_count);
    const subj = subjectMap.get(row.subject_id);
    const chap = row.chapter_id ? chapterMap.get(row.chapter_id) : null;
    const media = mediaMap.get(row.media_object_id);

    return {
      id: row.id,
      subjectId: row.subject_id,
      subject: subj
        ? {
            id: subj.id,
            classNum: subj.class_num,
            nameHi: subj.name_hi,
            nameEn: subj.name_en,
          }
        : null,
      chapterId: row.chapter_id,
      chapter: chap
        ? {
            id: chap.id,
            chapterNo: chap.chapter_no,
            titleHi: chap.title_hi,
            titleEn: chap.title_en,
          }
        : null,
      topicHint: row.topic_hint,
      sourceType: row.source_type,
      editorialStatus: editorialStatus.code,
      statusLabelEn: editorialStatus.labelEn,
      statusLabelHi: editorialStatus.labelHi,
      approvedCount: row.approved_count,
      reviewFeedback: row.review_feedback,
      fileName: media?.original_filename ?? null,
      fileSizeBytes: media?.size_bytes ?? null,
      createdAt: row.created_at,
      reviewedAt: row.reviewed_at,
    };
  });

  const totalPublishedQuestions = items.reduce((sum, i) => sum + i.approvedCount, 0);

  return jsonNoStore({
    ok: true,
    submissions: items,
    stats: {
      totalSubmitted: items.length,
      underReview: items.filter(
        (i) => i.editorialStatus === "SUBMITTED" || i.editorialStatus === "UNDER_REVIEW"
      ).length,
      publishedPapers: items.filter((i) => i.editorialStatus === "PUBLISHED").length,
      totalPublishedQuestions,
    },
  });
}

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid request payload." }, { status: 400 });
  }

  const parsed = createSubmissionSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please select a subject, file type, and upload a valid file first.",
        errorHi: "कृपया विषय, फ़ाइल प्रकार चुनें और पहले फ़ाइल अपलोड करें।",
      },
      { status: 400 }
    );
  }

  const { subjectId, chapterId, topicHint, sourceType, mediaObjectId } = parsed.data;
  const supabase = getSupabaseAdmin();

  // Verify subject, optional chapter, and finalized ACTIVE media object ownership
  const [{ data: subject }, { data: mediaObj }, chapterRes] = await Promise.all([
    supabase
      .from("subjects")
      .select("id, class_num, name_hi, name_en")
      .eq("id", subjectId)
      .maybeSingle(),
    supabase
      .from("media_objects")
      .select("id, school_udise, scope, owner_id, mime_type, status, original_filename")
      .eq("id", mediaObjectId)
      .maybeSingle(),
    chapterId
      ? supabase
          .from("chapters")
          .select("id, subject_id")
          .eq("id", chapterId)
          .maybeSingle()
      : Promise.resolve({ data: null }),
  ]);

  if (!subject) {
    return jsonNoStore({ error: "Selected subject was not found." }, { status: 400 });
  }
  if (chapterId && (!chapterRes.data || chapterRes.data.subject_id !== subjectId)) {
    return jsonNoStore(
      { error: "Selected chapter does not belong to the chosen subject." },
      { status: 400 }
    );
  }

  if (
    !mediaObj ||
    mediaObj.status !== "ACTIVE" ||
    mediaObj.owner_id !== session.principalId ||
    mediaObj.school_udise !== session.schoolUdise ||
    mediaObj.scope !== "EDITORIAL_SUBMISSION"
  ) {
    return jsonNoStore(
      {
        error: "Uploaded file is not verified or ready. Please re-upload and try again.",
        errorHi: "अपलोड की गई फ़ाइल सत्यापित नहीं है। कृपया पुनः अपलोड करें।",
      },
      { status: 400 }
    );
  }

  const allowedMimes = SOURCE_TYPE_MIME_MAP[sourceType];
  if (!allowedMimes.includes(mediaObj.mime_type.toLowerCase())) {
    return jsonNoStore(
      {
        error: "Uploaded file format does not match the selected source type.",
        errorHi: "अपलोड की गई फ़ाइल का प्रारूप चुने गए प्रकार से मेल नहीं खाता।",
      },
      { status: 400 }
    );
  }

  // Prevent linking the same media_object_id twice
  const { data: existingSub } = await supabase
    .from("question_submissions")
    .select("id")
    .eq("media_object_id", mediaObjectId)
    .maybeSingle();

  if (existingSub) {
    return jsonNoStore(
      { error: "This uploaded file has already been submitted." },
      { status: 409 }
    );
  }

  const cleanTopic = topicHint ? sanitizePlainText(topicHint, 240) : null;

  const { data: created, error: insertErr } = await supabase
    .from("question_submissions")
    .insert({
      school_udise: session.schoolUdise,
      teacher_id: session.principalId,
      subject_id: subjectId,
      chapter_id: chapterId ?? null,
      topic_hint: cleanTopic || null,
      source_type: sourceType,
      media_object_id: mediaObjectId,
      status: "PENDING",
    })
    .select("id, status, created_at")
    .single();

  if (insertErr || !created) {
    return jsonNoStore(
      {
        error: "Unable to record your question paper submission.",
        errorHi: "प्रश्न पत्र जमा नहीं हो सका। कृपया पुनः प्रयास करें।",
      },
      { status: 500 }
    );
  }

  const editorialStatus = mapEditorialStatus(created.status, 0);

  return jsonNoStore(
    {
      ok: true,
      submission: {
        id: created.id,
        subjectId,
        chapterId: chapterId ?? null,
        topicHint: cleanTopic,
        sourceType,
        editorialStatus: editorialStatus.code,
        statusLabelEn: editorialStatus.labelEn,
        statusLabelHi: editorialStatus.labelHi,
        fileName: mediaObj.original_filename,
        createdAt: created.created_at,
      },
    },
    { status: 201 }
  );
}
