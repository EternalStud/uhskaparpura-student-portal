import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole, validateCsrf } from "@/lib/auth";
import {
  extractYoutubeVideoId,
  sanitizeMarkdownSource,
  sanitizePlainText,
} from "@/lib/sanitize/content";
import {
  getStudentEnrolledSubjectIds,
  loadSafeMediaMap,
} from "@/app/api/collab/_helpers";

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const patchMaterialSchema = z.object({
  title: z.string().trim().min(2).max(200).optional(),
  description: z.string().trim().max(1000).nullable().optional(),
  bodyMarkdown: z.string().max(25000).nullable().optional(),
  isPinned: z.boolean().optional(),
  chapterId: z.string().trim().min(2).max(100).nullable().optional(),
  youtubeUrl: z.string().trim().max(300).optional(),
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
    return jsonNoStore({ error: "Invalid material identifier." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();
  const { data: row, error } = await supabase
    .from("teacher_materials")
    .select(
      "id, school_udise, teacher_id, subject_id, chapter_id, class_num, title, description, material_type, body_markdown, media_object_id, youtube_video_id, is_pinned, is_deleted, created_at, updated_at"
    )
    .eq("id", id)
    .eq("school_udise", session.schoolUdise)
    .eq("is_deleted", false)
    .maybeSingle();

  if (error || !row) {
    return jsonNoStore({ error: "Study material not found." }, { status: 404 });
  }

  if (session.role === "student" && session.student) {
    const enrolled = await getStudentEnrolledSubjectIds(
      session.principalId,
      session.student.academicYear
    );
    if (
      row.class_num !== session.student.classNum ||
      !enrolled.includes(row.subject_id)
    ) {
      return jsonNoStore({ error: "Access denied for this class or subject." }, { status: 403 });
    }
  }

  const [teacherRes, subjectRes, chapterRes, mediaMap] = await Promise.all([
    supabase
      .from("teachers")
      .select("id, full_name, teacher_title")
      .eq("id", row.teacher_id)
      .maybeSingle(),
    supabase
      .from("subjects")
      .select("id, class_num, name_hi, name_en")
      .eq("id", row.subject_id)
      .maybeSingle(),
    row.chapter_id
      ? supabase
          .from("chapters")
          .select("id, chapter_no, title_hi, title_en")
          .eq("id", row.chapter_id)
          .maybeSingle()
      : Promise.resolve({ data: null }),
    row.media_object_id
      ? loadSafeMediaMap([row.media_object_id], session.schoolUdise)
      : Promise.resolve(new Map()),
  ]);

  return jsonNoStore({
    ok: true,
    material: {
      id: row.id,
      classNum: row.class_num,
      subjectId: row.subject_id,
      subject: subjectRes.data ?? null,
      chapterId: row.chapter_id,
      chapter: chapterRes.data ?? null,
      title: row.title,
      description: row.description,
      materialType: row.material_type,
      bodyMarkdown: row.body_markdown,
      media: row.media_object_id ? mediaMap.get(row.media_object_id) ?? null : null,
      youtubeVideoId: row.youtube_video_id,
      isPinned: row.is_pinned,
      teacher: teacherRes.data
        ? {
            id: teacherRes.data.id,
            fullName: teacherRes.data.full_name,
            teacherTitle: teacherRes.data.teacher_title,
          }
        : null,
      createdAt: row.created_at,
      updatedAt: row.updated_at,
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
    return jsonNoStore({ error: "Invalid material identifier." }, { status: 400 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid JSON payload." }, { status: 400 });
  }

  const parsed = patchMaterialSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: "Invalid update parameters." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();
  const { data: existing } = await supabase
    .from("teacher_materials")
    .select("id, school_udise, teacher_id, subject_id, material_type, is_deleted")
    .eq("id", id)
    .eq("school_udise", session.schoolUdise)
    .eq("is_deleted", false)
    .maybeSingle();

  if (!existing) {
    return jsonNoStore({ error: "Study material not found." }, { status: 404 });
  }

  const isOwner = existing.teacher_id === session.principalId;
  const isSchoolAdmin = session.teacher?.isSchoolAdmin === true;
  if (!isOwner && !isSchoolAdmin) {
    return jsonNoStore(
      { error: "Only the authoring teacher or school admin can modify this material." },
      { status: 403 }
    );
  }

  const updates: {
    title?: string;
    description?: string | null;
    body_markdown?: string | null;
    is_pinned?: boolean;
    chapter_id?: string | null;
    youtube_video_id?: string | null;
  } = {};

  if (parsed.data.title !== undefined) {
    const clean = sanitizePlainText(parsed.data.title, 200);
    if (clean.length < 2) {
      return jsonNoStore({ error: "Title must be at least 2 characters." }, { status: 400 });
    }
    updates.title = clean;
  }
  if (parsed.data.description !== undefined) {
    updates.description = parsed.data.description
      ? sanitizePlainText(parsed.data.description, 1000)
      : null;
  }
  if (parsed.data.bodyMarkdown !== undefined) {
    updates.body_markdown = parsed.data.bodyMarkdown
      ? sanitizeMarkdownSource(parsed.data.bodyMarkdown, 25000)
      : null;
  }
  if (parsed.data.isPinned !== undefined) {
    updates.is_pinned = parsed.data.isPinned;
  }
  if (parsed.data.chapterId !== undefined) {
    if (parsed.data.chapterId === null) {
      updates.chapter_id = null;
    } else {
      const { data: chap } = await supabase
        .from("chapters")
        .select("id, subject_id")
        .eq("id", parsed.data.chapterId)
        .maybeSingle();
      if (!chap || chap.subject_id !== existing.subject_id) {
        return jsonNoStore(
          { error: "Chapter does not belong to this subject." },
          { status: 400 }
        );
      }
      updates.chapter_id = chap.id;
    }
  }
  if (parsed.data.youtubeUrl !== undefined && existing.material_type === "VIDEO_YOUTUBE") {
    const ytId = extractYoutubeVideoId(parsed.data.youtubeUrl);
    if (!ytId) {
      return jsonNoStore({ error: "Invalid YouTube link." }, { status: 400 });
    }
    updates.youtube_video_id = ytId;
  }

  if (Object.keys(updates).length === 0) {
    return jsonNoStore({ error: "No valid changes provided." }, { status: 400 });
  }

  const { data: updated, error: updateErr } = await supabase
    .from("teacher_materials")
    .update(updates)
    .eq("id", existing.id)
    .eq("school_udise", session.schoolUdise)
    .select("id, title, description, body_markdown, is_pinned, chapter_id, youtube_video_id, updated_at")
    .single();

  if (updateErr || !updated) {
    return jsonNoStore({ error: "Unable to update material." }, { status: 500 });
  }

  if (!isOwner) {
    await supabase.from("audit_logs").insert({
      school_udise: session.schoolUdise,
      actor_role: session.role,
      actor_id: session.principalId,
      action: "MATERIAL_MODERATED",
      target_type: "teacher_material",
      target_id: existing.id,
      meta_json: { updatedFields: Object.keys(updates) },
    });
  }

  return jsonNoStore({ ok: true, material: updated });
}

export async function DELETE(
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
    return jsonNoStore({ error: "Invalid material identifier." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();
  const { data: existing } = await supabase
    .from("teacher_materials")
    .select("id, school_udise, teacher_id, title, media_object_id, is_deleted")
    .eq("id", id)
    .eq("school_udise", session.schoolUdise)
    .eq("is_deleted", false)
    .maybeSingle();

  if (!existing) {
    return jsonNoStore({ error: "Study material not found." }, { status: 404 });
  }

  const isOwner = existing.teacher_id === session.principalId;
  const isSchoolAdmin = session.teacher?.isSchoolAdmin === true;
  if (!isOwner && !isSchoolAdmin) {
    return jsonNoStore(
      { error: "Only the authoring teacher or school admin can delete this material." },
      { status: 403 }
    );
  }

  const { error: delErr } = await supabase
    .from("teacher_materials")
    .update({ is_deleted: true, is_pinned: false })
    .eq("id", existing.id)
    .eq("school_udise", session.schoolUdise);

  if (delErr) {
    return jsonNoStore({ error: "Could not delete study material." }, { status: 500 });
  }

  // Queue orphaned school-private media object for background garbage collection
  if (existing.media_object_id) {
    await supabase
      .from("media_objects")
      .update({ status: "DELETE_QUEUED" })
      .eq("id", existing.media_object_id)
      .eq("school_udise", session.schoolUdise)
      .eq("status", "ACTIVE");
  }

  await supabase.from("audit_logs").insert({
    school_udise: session.schoolUdise,
    actor_role: session.role,
    actor_id: session.principalId,
    action: "MATERIAL_DELETED",
    target_type: "teacher_material",
    target_id: existing.id,
    meta_json: {
      title: existing.title,
      queuedMediaCleanup: Boolean(existing.media_object_id),
    },
  });

  return jsonNoStore({ ok: true, deletedId: existing.id });
}
