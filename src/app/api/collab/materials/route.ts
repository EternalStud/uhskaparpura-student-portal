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
  verifyOwnedSchoolMedia,
} from "@/app/api/collab/_helpers";
import type { ClassNum, TeacherMaterialType } from "@/types/database";

const createMaterialSchema = z.object({
  subjectId: z.string().trim().min(2).max(80),
  chapterId: z.string().trim().min(2).max(100).nullable().optional(),
  title: z.string().trim().min(2).max(200),
  description: z.string().trim().max(1000).nullable().optional(),
  materialType: z.enum(["NOTE", "PDF", "IMAGE", "VIDEO_UPLOAD", "VIDEO_YOUTUBE"]),
  bodyMarkdown: z.string().max(25000).nullable().optional(),
  mediaObjectId: z.string().uuid().nullable().optional(),
  youtubeUrl: z.string().trim().max(300).nullable().optional(),
  youtubeVideoId: z.string().trim().max(300).nullable().optional(),
  isPinned: z.boolean().optional(),
});

export async function GET(request: Request) {
  const auth = await requireRole(["student", "teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise) {
    return jsonNoStore({ error: "School context required." }, { status: 403 });
  }

  const url = new URL(request.url);
  const subjectIdFilter = url.searchParams.get("subjectId")?.trim() || null;
  const chapterIdFilter = url.searchParams.get("chapterId")?.trim() || null;
  const materialTypeFilter = url.searchParams.get("materialType")?.trim() || null;
  const classNumParam = url.searchParams.get("classNum");
  const scope = url.searchParams.get("scope") === "my" ? "my" : "all";

  const supabase = getSupabaseAdmin();

  let query = supabase
    .from("teacher_materials")
    .select(
      "id, school_udise, teacher_id, subject_id, chapter_id, class_num, title, description, material_type, body_markdown, media_object_id, youtube_video_id, is_pinned, created_at, updated_at"
    )
    .eq("school_udise", session.schoolUdise)
    .eq("is_deleted", false)
    .order("is_pinned", { ascending: false })
    .order("created_at", { ascending: false })
    .limit(100);

  if (session.role === "student" && session.student) {
    const enrolledIds = await getStudentEnrolledSubjectIds(
      session.principalId,
      session.student.academicYear
    );
    if (enrolledIds.length === 0) {
      return jsonNoStore({ ok: true, materials: [] });
    }
    if (subjectIdFilter && !enrolledIds.includes(subjectIdFilter)) {
      return jsonNoStore({ ok: true, materials: [] });
    }
    query = query
      .eq("class_num", session.student.classNum)
      .in("subject_id", subjectIdFilter ? [subjectIdFilter] : enrolledIds);
  } else {
    // Teacher / School Admin view
    if (scope === "my" && session.teacher) {
      const assigned = session.teacher.assignedSubjectIds;
      if (assigned.length === 0) {
        return jsonNoStore({ ok: true, materials: [] });
      }
      query = query.in("subject_id", assigned);
    }
    if (subjectIdFilter) {
      query = query.eq("subject_id", subjectIdFilter);
    }
    if (classNumParam && ["9", "10", "11", "12"].includes(classNumParam)) {
      query = query.eq("class_num", Number(classNumParam) as ClassNum);
    }
  }

  if (chapterIdFilter) {
    query = query.eq("chapter_id", chapterIdFilter);
  }
  if (
    materialTypeFilter &&
    ["NOTE", "PDF", "IMAGE", "VIDEO_UPLOAD", "VIDEO_YOUTUBE"].includes(materialTypeFilter)
  ) {
    query = query.eq("material_type", materialTypeFilter as TeacherMaterialType);
  }

  const { data: rows, error } = await query;
  if (error) {
    return jsonNoStore({ error: "Unable to load study materials." }, { status: 500 });
  }

  const materials = rows ?? [];
  const teacherIds = Array.from(new Set(materials.map((m) => m.teacher_id)));
  const subjectIds = Array.from(new Set(materials.map((m) => m.subject_id)));
  const chapterIds = Array.from(
    new Set(materials.map((m) => m.chapter_id).filter((v): v is string => Boolean(v)))
  );
  const mediaIds = materials
    .map((m) => m.media_object_id)
    .filter((v): v is string => Boolean(v));

  const [teachersRes, subjectsRes, chaptersRes, mediaMap] = await Promise.all([
    teacherIds.length > 0
      ? supabase
          .from("teachers")
          .select("id, full_name, teacher_title")
          .in("id", teacherIds)
      : Promise.resolve({ data: [] }),
    subjectIds.length > 0
      ? supabase
          .from("subjects")
          .select("id, class_num, name_hi, name_en, accent_color")
          .in("id", subjectIds)
      : Promise.resolve({ data: [] }),
    chapterIds.length > 0
      ? supabase
          .from("chapters")
          .select("id, chapter_no, title_hi, title_en")
          .in("id", chapterIds)
      : Promise.resolve({ data: [] }),
    loadSafeMediaMap(mediaIds, session.schoolUdise),
  ]);

  const teacherMap = new Map((teachersRes.data ?? []).map((t) => [t.id, t]));
  const subjectMap = new Map((subjectsRes.data ?? []).map((s) => [s.id, s]));
  const chapterMap = new Map((chaptersRes.data ?? []).map((c) => [c.id, c]));

  const isSchoolAdmin = session.teacher?.isSchoolAdmin === true;

  return jsonNoStore({
    ok: true,
    materials: materials.map((row) => {
      const teacher = teacherMap.get(row.teacher_id);
      const subject = subjectMap.get(row.subject_id);
      const chapter = row.chapter_id ? chapterMap.get(row.chapter_id) : null;
      const media = row.media_object_id ? mediaMap.get(row.media_object_id) ?? null : null;

      return {
        id: row.id,
        classNum: row.class_num,
        subjectId: row.subject_id,
        subject: subject
          ? {
              id: subject.id,
              classNum: subject.class_num,
              nameHi: subject.name_hi,
              nameEn: subject.name_en,
              accentColor: subject.accent_color,
            }
          : null,
        chapterId: row.chapter_id,
        chapter: chapter
          ? {
              id: chapter.id,
              chapterNo: chapter.chapter_no,
              titleHi: chapter.title_hi,
              titleEn: chapter.title_en,
            }
          : null,
        title: row.title,
        description: row.description,
        materialType: row.material_type,
        bodyMarkdown: row.body_markdown,
        media,
        youtubeVideoId: row.youtube_video_id,
        isPinned: row.is_pinned,
        teacher: {
          id: row.teacher_id,
          fullName: teacher?.full_name ?? "Teacher",
          teacherTitle: teacher?.teacher_title ?? null,
        },
        canManage:
          session.role !== "student" &&
          (row.teacher_id === session.principalId || isSchoolAdmin),
        createdAt: row.created_at,
        updatedAt: row.updated_at,
      };
    }),
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
    return jsonNoStore({ error: "Invalid JSON payload." }, { status: 400 });
  }

  const parsed = createMaterialSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please fill in the title, subject, and material content.",
        errorHi: "कृपया शीर्षक, विषय और सामग्री का विवरण सही से भरें।",
      },
      { status: 400 }
    );
  }

  const input = parsed.data;
  const cleanTitle = sanitizePlainText(input.title, 200);
  const cleanDescription = input.description
    ? sanitizePlainText(input.description, 1000)
    : null;
  const cleanMarkdown = input.bodyMarkdown
    ? sanitizeMarkdownSource(input.bodyMarkdown, 25000)
    : null;

  if (cleanTitle.length < 2) {
    return jsonNoStore(
      {
        error: "Title must be at least 2 characters long.",
        errorHi: "शीर्षक कम से कम 2 अक्षरों का होना चाहिए।",
      },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();

  const [{ data: subject }, chapterRes] = await Promise.all([
    supabase
      .from("subjects")
      .select("id, class_num, name_hi, name_en")
      .eq("id", input.subjectId)
      .maybeSingle(),
    input.chapterId
      ? supabase
          .from("chapters")
          .select("id, subject_id")
          .eq("id", input.chapterId)
          .maybeSingle()
      : Promise.resolve({ data: null }),
  ]);

  if (!subject) {
    return jsonNoStore({ error: "Selected subject does not exist." }, { status: 400 });
  }
  if (input.chapterId && (!chapterRes.data || chapterRes.data.subject_id !== subject.id)) {
    return jsonNoStore(
      { error: "Selected chapter does not belong to the chosen subject." },
      { status: 400 }
    );
  }

  let verifiedMediaId: string | null = null;
  let verifiedYoutubeId: string | null = null;

  if (input.materialType === "NOTE") {
    if (!cleanMarkdown || cleanMarkdown.length < 10) {
      return jsonNoStore(
        {
          error: "Please write at least 10 characters of study note content.",
          errorHi: "कृपया अध्ययन नोट में कम से कम 10 अक्षर लिखें।",
        },
        { status: 400 }
      );
    }
  } else if (input.materialType === "VIDEO_YOUTUBE") {
    const rawYoutube = input.youtubeUrl || input.youtubeVideoId || "";
    const extracted = extractYoutubeVideoId(rawYoutube);
    if (!extracted) {
      return jsonNoStore(
        {
          error: "Please enter a valid YouTube video URL or 11-character video ID.",
          errorHi: "कृपया मान्य YouTube वीडियो लिंक दर्ज करें।",
        },
        { status: 400 }
      );
    }
    verifiedYoutubeId = extracted;
  } else {
    // PDF, IMAGE, VIDEO_UPLOAD require a finalized SCHOOL_PRIVATE media object
    if (!input.mediaObjectId) {
      return jsonNoStore(
        {
          error: "Please upload and verify the file before publishing.",
          errorHi: "प्रकाशित करने से पहले कृपया फ़ाइल अपलोड करें।",
        },
        { status: 400 }
      );
    }

    const allowedKind =
      input.materialType === "PDF"
        ? "PDF"
        : input.materialType === "IMAGE"
        ? "IMAGE"
        : "VIDEO";

    const verified = await verifyOwnedSchoolMedia({
      mediaObjectId: input.mediaObjectId,
      schoolUdise: session.schoolUdise,
      ownerId: session.principalId,
      expectedScope: "SCHOOL_PRIVATE",
      allowedKind,
    });

    if (!verified.ok) {
      return jsonNoStore(
        { error: verified.error, errorHi: verified.errorHi },
        { status: 400 }
      );
    }

    verifiedMediaId = verified.media.id;
  }

  const { data: created, error: insertErr } = await supabase
    .from("teacher_materials")
    .insert({
      school_udise: session.schoolUdise,
      teacher_id: session.principalId,
      subject_id: subject.id,
      chapter_id: input.chapterId ?? null,
      class_num: subject.class_num,
      title: cleanTitle,
      description: cleanDescription || null,
      material_type: input.materialType,
      body_markdown: cleanMarkdown || null,
      media_object_id: verifiedMediaId,
      youtube_video_id: verifiedYoutubeId,
      is_pinned: Boolean(input.isPinned),
    })
    .select(
      "id, school_udise, teacher_id, subject_id, chapter_id, class_num, title, description, material_type, body_markdown, media_object_id, youtube_video_id, is_pinned, created_at"
    )
    .single();

  if (insertErr || !created) {
    return jsonNoStore(
      {
        error: "Unable to publish study material. Please try again.",
        errorHi: "अध्ययन सामग्री प्रकाशित नहीं हो सकी। कृपया पुनः प्रयास करें।",
      },
      { status: 500 }
    );
  }

  return jsonNoStore({ ok: true, material: created }, { status: 201 });
}
