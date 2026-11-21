import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole, validateCsrf } from "@/lib/auth";
import { sanitizePlainText } from "@/lib/sanitize/content";
import {
  getStudentEnrolledSubjectIds,
  loadSafeMediaMap,
} from "@/app/api/collab/_helpers";

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const patchDoubtSchema = z.object({
  isPinned: z.boolean().optional(),
  status: z.enum(["OPEN", "ANSWERED", "RESOLVED"]).optional(),
  isHidden: z.boolean().optional(),
  reason: z.string().trim().max(300).optional(),
});

export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const auth = await requireRole(["student", "teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
  }

  const { id } = await context.params;
  if (!UUID_RE.test(id)) {
    return jsonNoStore({ error: "Invalid doubt identifier." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();
  const { data: doubt } = await supabase
    .from("open_doubts")
    .select(
      "id, school_udise, academic_year, student_id, subject_id, chapter_id, class_num, question_text, media_object_id, status, is_pinned, is_hidden, upvote_count, created_at, updated_at"
    )
    .eq("id", id)
    .eq("school_udise", session.schoolUdise)
    .maybeSingle();

  if (!doubt || (doubt.is_hidden && session.role === "student")) {
    return jsonNoStore({ error: "Doubt not found." }, { status: 404 });
  }

  if (session.role === "student" && session.student) {
    const enrolled = await getStudentEnrolledSubjectIds(
      session.principalId,
      session.student.academicYear
    );
    if (
      doubt.class_num !== session.student.classNum ||
      !enrolled.includes(doubt.subject_id)
    ) {
      return jsonNoStore({ error: "Access denied for this class or subject." }, { status: 403 });
    }
  }

  const [answersRes, studentRes, subjectRes, chapterRes] = await Promise.all([
    supabase
      .from("doubt_answers")
      .select("id, teacher_id, answer_text, media_object_id, created_at")
      .eq("doubt_id", doubt.id)
      .eq("is_hidden", false)
      .order("created_at", { ascending: true }),
    supabase
      .from("students")
      .select("id, student_name, class_num, roll_no, section")
      .eq("id", doubt.student_id)
      .maybeSingle(),
    supabase
      .from("subjects")
      .select("id, class_num, name_hi, name_en")
      .eq("id", doubt.subject_id)
      .maybeSingle(),
    doubt.chapter_id
      ? supabase
          .from("chapters")
          .select("id, chapter_no, title_hi, title_en")
          .eq("id", doubt.chapter_id)
          .maybeSingle()
      : Promise.resolve({ data: null }),
  ]);

  const answerRows = answersRes.data ?? [];
  const teacherIds = Array.from(new Set(answerRows.map((a) => a.teacher_id)));
  const mediaIds = [
    ...(doubt.media_object_id ? [doubt.media_object_id] : []),
    ...answerRows.map((a) => a.media_object_id).filter((v): v is string => Boolean(v)),
  ];

  const [teachersRes, mediaMap] = await Promise.all([
    teacherIds.length > 0
      ? supabase
          .from("teachers")
          .select("id, full_name, teacher_title")
          .in("id", teacherIds)
      : Promise.resolve({ data: [] }),
    loadSafeMediaMap(mediaIds, session.schoolUdise),
  ]);

  const teacherMap = new Map((teachersRes.data ?? []).map((t) => [t.id, t]));

  return jsonNoStore({
    ok: true,
    doubt: {
      id: doubt.id,
      classNum: doubt.class_num,
      subjectId: doubt.subject_id,
      subject: subjectRes.data ?? null,
      chapterId: doubt.chapter_id,
      chapter: chapterRes.data ?? null,
      student: {
        name: studentRes.data?.student_name ?? "Student",
        classNum: studentRes.data?.class_num ?? doubt.class_num,
        rollNo: studentRes.data?.roll_no ?? null,
        section: studentRes.data?.section ?? "A",
      },
      questionText: doubt.question_text,
      media: doubt.media_object_id ? mediaMap.get(doubt.media_object_id) ?? null : null,
      status: doubt.status,
      isPinned: doubt.is_pinned,
      isHidden: doubt.is_hidden,
      upvoteCount: doubt.upvote_count,
      answers: answerRows.map((a) => {
        const t = teacherMap.get(a.teacher_id);
        return {
          id: a.id,
          answerText: a.answer_text,
          createdAt: a.created_at,
          teacher: {
            id: a.teacher_id,
            fullName: t?.full_name ?? "Verified Teacher",
            teacherTitle: t?.teacher_title ?? null,
          },
          media: a.media_object_id ? mediaMap.get(a.media_object_id) ?? null : null,
        };
      }),
      createdAt: doubt.created_at,
      updatedAt: doubt.updated_at,
    },
  });
}

export async function PATCH(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
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

  const parsed = patchDoubtSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: "Invalid update fields." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();
  const { data: existing } = await supabase
    .from("open_doubts")
    .select("id, school_udise, status, is_pinned, is_hidden")
    .eq("id", id)
    .eq("school_udise", session.schoolUdise)
    .maybeSingle();

  if (!existing) {
    return jsonNoStore({ error: "Doubt not found in your school." }, { status: 404 });
  }

  const updates: {
    is_pinned?: boolean;
    status?: "OPEN" | "ANSWERED" | "RESOLVED";
    is_hidden?: boolean;
    hidden_by?: string | null;
  } = {};

  if (parsed.data.isPinned !== undefined) {
    updates.is_pinned = parsed.data.isPinned;
  }
  if (parsed.data.status !== undefined) {
    updates.status = parsed.data.status;
  }
  if (parsed.data.isHidden !== undefined) {
    updates.is_hidden = parsed.data.isHidden;
    updates.hidden_by = parsed.data.isHidden ? session.principalId : null;
    if (parsed.data.isHidden) {
      updates.is_pinned = false;
    }
  }

  if (Object.keys(updates).length === 0) {
    return jsonNoStore({ error: "No changes requested." }, { status: 400 });
  }

  const { data: updated, error: updateErr } = await supabase
    .from("open_doubts")
    .update(updates)
    .eq("id", existing.id)
    .eq("school_udise", session.schoolUdise)
    .select("id, status, is_pinned, is_hidden, updated_at")
    .single();

  if (updateErr || !updated) {
    return jsonNoStore({ error: "Could not update doubt." }, { status: 500 });
  }

  const cleanReason = parsed.data.reason
    ? sanitizePlainText(parsed.data.reason, 300)
    : undefined;

  await supabase.from("audit_logs").insert({
    school_udise: session.schoolUdise,
    actor_role: session.role,
    actor_id: session.principalId,
    action:
      parsed.data.isHidden === true
        ? "DOUBT_HIDDEN"
        : parsed.data.isHidden === false
        ? "DOUBT_RESTORED"
        : "DOUBT_UPDATED",
    target_type: "open_doubt",
    target_id: existing.id,
    meta_json: {
      previous: {
        status: existing.status,
        isPinned: existing.is_pinned,
        isHidden: existing.is_hidden,
      },
      updated: {
        status: updated.status,
        isPinned: updated.is_pinned,
        isHidden: updated.is_hidden,
      },
      ...(cleanReason ? { reason: cleanReason } : {}),
    },
  });

  return jsonNoStore({ ok: true, doubt: updated });
}
