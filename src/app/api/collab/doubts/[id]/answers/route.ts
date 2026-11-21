import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole, validateCsrf } from "@/lib/auth";
import { sanitizeMarkdownSource } from "@/lib/sanitize/content";
import { verifyOwnedSchoolMedia } from "@/app/api/collab/_helpers";

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const createAnswerSchema = z.object({
  answerText: z.string().trim().min(2).max(10000),
  mediaObjectId: z.string().uuid().nullable().optional(),
  markResolved: z.boolean().optional(),
});

/**
 * POST /api/collab/doubts/[id]/answers
 * STRICTLY Verified Teacher / School Admin ONLY — NEVER accessible to students!
 * Posts an official teacher explanation (+ optional solution image/PDF) to the open board.
 */
export async function POST(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise || !session.teacher) {
    return jsonNoStore({ error: "Verified teacher session required." }, { status: 403 });
  }

  const { id } = await context.params;
  if (!UUID_RE.test(id)) {
    return jsonNoStore({ error: "Invalid doubt identifier." }, { status: 400 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid JSON payload." }, { status: 400 });
  }

  const parsed = createAnswerSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please write a clear answer (at least 2 characters).",
        errorHi: "कृपया स्पष्ट उत्तर लिखें (कम से कम 2 अक्षर)।",
      },
      { status: 400 }
    );
  }

  const cleanAnswer = sanitizeMarkdownSource(parsed.data.answerText, 10000);
  if (cleanAnswer.length < 2) {
    return jsonNoStore(
      {
        error: "Answer cannot be empty after formatting.",
        errorHi: "उत्तर खाली नहीं हो सकता।",
      },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();

  const { data: doubt } = await supabase
    .from("open_doubts")
    .select("id, school_udise, status, is_hidden")
    .eq("id", id)
    .eq("school_udise", session.schoolUdise)
    .maybeSingle();

  if (!doubt || doubt.is_hidden) {
    return jsonNoStore({ error: "Doubt not found in your school." }, { status: 404 });
  }

  let verifiedMedia: {
    id: string;
    url: string;
    fileName: string;
    mimeType: string;
    sizeBytes: number;
  } | null = null;

  if (parsed.data.mediaObjectId) {
    const check = await verifyOwnedSchoolMedia({
      mediaObjectId: parsed.data.mediaObjectId,
      schoolUdise: session.schoolUdise,
      ownerId: session.principalId,
      expectedScope: "SCHOOL_PRIVATE",
      allowedKind: "IMAGE_OR_PDF",
    });
    if (!check.ok) {
      return jsonNoStore({ error: check.error, errorHi: check.errorHi }, { status: 400 });
    }
    verifiedMedia = check.media;
  }

  const { data: createdAnswer, error: insertErr } = await supabase
    .from("doubt_answers")
    .insert({
      doubt_id: doubt.id,
      teacher_id: session.principalId,
      answer_text: cleanAnswer,
      media_object_id: verifiedMedia?.id ?? null,
    })
    .select("id, doubt_id, teacher_id, answer_text, media_object_id, created_at")
    .single();

  if (insertErr || !createdAnswer) {
    return jsonNoStore(
      {
        error: "Unable to publish answer right now.",
        errorHi: "उत्तर प्रकाशित नहीं हो सका। कृपया पुनः प्रयास करें।",
      },
      { status: 500 }
    );
  }

  const nextStatus = parsed.data.markResolved
    ? "RESOLVED"
    : doubt.status === "OPEN"
    ? "ANSWERED"
    : doubt.status;

  if (nextStatus !== doubt.status) {
    await supabase
      .from("open_doubts")
      .update({ status: nextStatus })
      .eq("id", doubt.id)
      .eq("school_udise", session.schoolUdise);
  }

  return jsonNoStore(
    {
      ok: true,
      doubtStatus: nextStatus,
      answer: {
        id: createdAnswer.id,
        doubtId: createdAnswer.doubt_id,
        answerText: createdAnswer.answer_text,
        createdAt: createdAnswer.created_at,
        teacher: {
          id: session.principalId,
          fullName: session.teacher.fullName,
          teacherTitle: session.teacher.teacherTitle,
        },
        media: verifiedMedia,
      },
    },
    { status: 201 }
  );
}
