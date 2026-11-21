import { getSupabaseAdmin } from "@/lib/supabase/server";
import type { MediaScope, TeacherMaterialType } from "@/types/database";

if (typeof window !== "undefined") {
  throw new Error("SECURITY: src/app/api/collab/_helpers.ts is strictly server-only.");
}

export interface SafeMediaSummary {
  id: string;
  url: string;
  fileName: string;
  mimeType: string;
  sizeBytes: number;
}

const IMAGE_MIMES = new Set(["image/jpeg", "image/png", "image/webp"]);
const PDF_MIMES = new Set(["application/pdf"]);
const VIDEO_MIMES = new Set(["video/mp4", "video/webm"]);

export function isImageMime(mime: string): boolean {
  return IMAGE_MIMES.has(mime.toLowerCase().split(";")[0] ?? "");
}

export function isPdfMime(mime: string): boolean {
  return PDF_MIMES.has(mime.toLowerCase().split(";")[0] ?? "");
}

export function isVideoMime(mime: string): boolean {
  return VIDEO_MIMES.has(mime.toLowerCase().split(";")[0] ?? "");
}

export function isMimeValidForMaterialType(
  materialType: TeacherMaterialType,
  mimeType: string
): boolean {
  if (materialType === "PDF") return isPdfMime(mimeType);
  if (materialType === "IMAGE") return isImageMime(mimeType);
  if (materialType === "VIDEO_UPLOAD") return isVideoMime(mimeType);
  return false;
}

/**
 * Verifies an uploaded media object is ACTIVE, belongs to the current user & school,
 * and matches the expected storage scope and MIME rules.
 */
export async function verifyOwnedSchoolMedia(params: {
  mediaObjectId: string;
  schoolUdise: string;
  ownerId: string;
  expectedScope?: MediaScope;
  allowedKind: "IMAGE" | "PDF" | "VIDEO" | "IMAGE_OR_PDF";
}): Promise<
  | { ok: true; media: SafeMediaSummary }
  | { ok: false; error: string; errorHi: string }
> {
  const supabase = getSupabaseAdmin();
  const { data: row, error } = await supabase
    .from("media_objects")
    .select(
      "id, school_udise, scope, owner_id, original_filename, mime_type, size_bytes, status"
    )
    .eq("id", params.mediaObjectId)
    .maybeSingle();

  if (error || !row) {
    return {
      ok: false,
      error: "Attached file was not found.",
      errorHi: "संलग्न फ़ाइल नहीं मिली।",
    };
  }

  if (
    row.status !== "ACTIVE" ||
    row.owner_id !== params.ownerId ||
    row.school_udise !== params.schoolUdise ||
    row.scope !== (params.expectedScope ?? "SCHOOL_PRIVATE")
  ) {
    return {
      ok: false,
      error: "Attached file is not verified for your school account.",
      errorHi: "संलग्न फ़ाइल आपके खाते के लिए सत्यापित नहीं है।",
    };
  }

  const mime = row.mime_type.toLowerCase();
  const mimeOk =
    (params.allowedKind === "IMAGE" && isImageMime(mime)) ||
    (params.allowedKind === "PDF" && isPdfMime(mime)) ||
    (params.allowedKind === "VIDEO" && isVideoMime(mime)) ||
    (params.allowedKind === "IMAGE_OR_PDF" && (isImageMime(mime) || isPdfMime(mime)));

  if (!mimeOk) {
    return {
      ok: false,
      error: "Attached file type is not allowed for this action.",
      errorHi: "इस फ़ाइल का प्रकार यहाँ मान्य नहीं है।",
    };
  }

  return {
    ok: true,
    media: {
      id: row.id,
      url: `/api/school-media/${row.id}`,
      fileName: row.original_filename,
      mimeType: row.mime_type,
      sizeBytes: row.size_bytes,
    },
  };
}

/**
 * Returns the student's enrolled subject IDs for the given academic year.
 */
export async function getStudentEnrolledSubjectIds(
  studentId: string,
  academicYear: string
): Promise<string[]> {
  const supabase = getSupabaseAdmin();
  const { data, error } = await supabase
    .from("student_subjects")
    .select("subject_id")
    .eq("student_id", studentId)
    .eq("academic_year", academicYear);

  if (error || !data) return [];
  return data.map((r) => r.subject_id);
}

/**
 * Hydrates active school media summaries (stripping drive_file_id strictly).
 */
export async function loadSafeMediaMap(
  mediaIds: string[],
  schoolUdise: string
): Promise<Map<string, SafeMediaSummary>> {
  const uniqueIds = Array.from(new Set(mediaIds.filter(Boolean)));
  const result = new Map<string, SafeMediaSummary>();
  if (uniqueIds.length === 0) return result;

  const supabase = getSupabaseAdmin();
  const { data } = await supabase
    .from("media_objects")
    .select("id, original_filename, mime_type, size_bytes, status, school_udise")
    .in("id", uniqueIds)
    .eq("school_udise", schoolUdise)
    .eq("status", "ACTIVE");

  for (const row of data ?? []) {
    result.set(row.id, {
      id: row.id,
      url: `/api/school-media/${row.id}`,
      fileName: row.original_filename,
      mimeType: row.mime_type,
      sizeBytes: row.size_bytes,
    });
  }

  return result;
}
