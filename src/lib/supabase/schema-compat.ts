import type { SupabaseClient } from "@supabase/supabase-js";
import type { SupabaseDatabase } from "@/lib/supabase/server";
import type { SubjectRow } from "@/types/database";

if (typeof window !== "undefined") {
  throw new Error(
    "SECURITY: src/lib/supabase/schema-compat.ts is strictly server-only."
  );
}

type AdminClient = SupabaseClient<SupabaseDatabase>;

export const SUBJECT_SELECT_FULL =
  "id, bseb_code, class_num, stream, category, name_en, name_hi, icon_name, accent_color, sort_order, syllabus_alias_of";

export const SUBJECT_SELECT_LEGACY =
  "id, bseb_code, class_num, stream, category, name_en, name_hi, icon_name, accent_color, sort_order";

/**
 * Detects Postgres `42703` (undefined_column) or PostgREST `PGRST204` schema-cache
 * missing-column errors so live production never returns HTTP 500 during the window
 * between a Vercel code deploy and running new SQL migrations in Supabase.
 */
export function isMissingColumnError(
  err: { code?: string | null; message?: string | null; details?: string | null } | null | undefined
): boolean {
  if (!err) return false;
  if (err.code === "42703" || err.code === "PGRST204") return true;
  const msg = `${err.message ?? ""} ${err.details ?? ""}`;
  return (
    /column .* does not exist/i.test(msg) ||
    /Could not find the .* column/i.test(msg)
  );
}

/**
 * Normalizes a subject row returned from either a full (`004+`) or legacy (`001-003`)
 * query so `syllabus_alias_of` is always `string | null`.
 */
export function normalizeSubjectRow(
  row: Omit<SubjectRow, "syllabus_alias_of"> & { syllabus_alias_of?: string | null }
): SubjectRow {
  return {
    ...row,
    syllabus_alias_of: row.syllabus_alias_of ?? null,
  };
}

/**
 * Fetches a single subject row by ID with automatic fallback if `subjects.syllabus_alias_of`
 * has not been added to the live database yet.
 */
export async function fetchSubjectWithAlias(
  supabase: AdminClient,
  subjectId: string
): Promise<{ data: SubjectRow | null; error: { code?: string; message?: string } | null }> {
  const first = await supabase
    .from("subjects")
    .select(SUBJECT_SELECT_FULL)
    .eq("id", subjectId)
    .maybeSingle();

  if (!first.error) {
    return {
      data: first.data ? normalizeSubjectRow(first.data as SubjectRow) : null,
      error: null,
    };
  }

  if (!isMissingColumnError(first.error)) {
    return { data: null, error: first.error };
  }

  const fallback = await supabase
    .from("subjects")
    .select(SUBJECT_SELECT_LEGACY)
    .eq("id", subjectId)
    .maybeSingle();

  return {
    data: fallback.data
      ? normalizeSubjectRow(fallback.data as Omit<SubjectRow, "syllabus_alias_of">)
      : null,
    error: fallback.error,
  };
}

export interface ChapterProgressUpsertPayload {
  student_id: string;
  chapter_id: string;
  notes_completed: boolean;
  notes_progress_pct: number;
  play_completed: boolean;
  subjective_completed: boolean;
  flashcards_mastered: number;
  practice_attempted: number;
  practice_correct: number;
  mastery_pct: number;
  last_studied_at: string;
}

/**
 * Upserts a `student_chapter_progress` row with automatic fallback when `play_completed`
 * or `subjective_completed` columns from migration `004` are not yet present in Supabase.
 */
export async function upsertChapterProgressCompat(
  supabase: AdminClient,
  payload: ChapterProgressUpsertPayload
): Promise<{ error: { code?: string; message?: string } | null }> {
  const first = await supabase
    .from("student_chapter_progress")
    .upsert(payload, { onConflict: "student_id,chapter_id" });

  if (!first.error || !isMissingColumnError(first.error)) {
    return { error: first.error };
  }

  // Strip 004+ columns cleanly and persist all core progress columns
  const {
    play_completed: _play,
    subjective_completed: _subj,
    ...legacyPayload
  } = payload;
  void _play;
  void _subj;

  const fallback = await supabase
    .from("student_chapter_progress")
    .upsert(legacyPayload, { onConflict: "student_id,chapter_id" });

  return { error: fallback.error };
}
