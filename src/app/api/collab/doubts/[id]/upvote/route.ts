import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole, validateCsrf } from "@/lib/auth";
import { getStudentEnrolledSubjectIds } from "@/app/api/collab/_helpers";

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * POST /api/collab/doubts/[id]/upvote
 * Student-only toggle for "Same Doubt (+1)" on an open class+subject doubt.
 */
export async function POST(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise || !session.student) {
    return jsonNoStore({ error: "Student session required." }, { status: 403 });
  }

  const { id } = await context.params;
  if (!UUID_RE.test(id)) {
    return jsonNoStore({ error: "Invalid doubt identifier." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();

  const [{ data: doubt }, enrolledIds] = await Promise.all([
    supabase
      .from("open_doubts")
      .select("id, school_udise, academic_year, class_num, subject_id, is_hidden")
      .eq("id", id)
      .eq("school_udise", session.schoolUdise)
      .eq("is_hidden", false)
      .maybeSingle(),
    getStudentEnrolledSubjectIds(session.principalId, session.student.academicYear),
  ]);

  if (!doubt) {
    return jsonNoStore({ error: "Doubt not found." }, { status: 404 });
  }

  if (
    doubt.class_num !== session.student.classNum ||
    doubt.academic_year !== session.student.academicYear ||
    !enrolledIds.includes(doubt.subject_id)
  ) {
    return jsonNoStore(
      { error: "You can only upvote doubts in your class and enrolled subjects." },
      { status: 403 }
    );
  }

  const { data: existingVote } = await supabase
    .from("doubt_upvotes")
    .select("doubt_id")
    .eq("doubt_id", doubt.id)
    .eq("student_id", session.principalId)
    .maybeSingle();

  let upvoted: boolean;
  if (existingVote) {
    await supabase
      .from("doubt_upvotes")
      .delete()
      .eq("doubt_id", doubt.id)
      .eq("student_id", session.principalId);
    upvoted = false;
  } else {
    await supabase.from("doubt_upvotes").insert({
      doubt_id: doubt.id,
      student_id: session.principalId,
    });
    upvoted = true;
  }

  // Recompute authoritative upvote_count from doubt_upvotes table
  const { count } = await supabase
    .from("doubt_upvotes")
    .select("doubt_id", { count: "exact", head: true })
    .eq("doubt_id", doubt.id);

  const upvoteCount = count ?? 0;

  await supabase
    .from("open_doubts")
    .update({ upvote_count: upvoteCount })
    .eq("id", doubt.id)
    .eq("school_udise", session.schoolUdise);

  return jsonNoStore({
    ok: true,
    doubtId: doubt.id,
    upvoted,
    upvoteCount,
  });
}
