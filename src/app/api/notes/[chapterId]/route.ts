import { z } from "zod";
import { requireRole, jsonNoStore } from "@/lib/auth/session";
import { validateCsrf } from "@/lib/auth/csrf";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  awardStudentStudyProgress,
  checkActiveLivePinExamLock,
  computeChapterMedal,
  getStudentEnrolledSubjectIds,
} from "@/app/api/student/_helpers";

const markNotesSchema = z.object({
  notesCompleted: z.boolean().optional().default(true),
  notesProgressPct: z.number().int().min(0).max(100).optional(),
});

export async function GET(
  request: Request,
  context: { params: Promise<{ chapterId: string }> }
) {
  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;

  const { session } = auth;
  const studentInfo = session.student!;
  const { chapterId } = await context.params;

  // Anti-cheat lock during active LIVE_PIN classroom exam
  const lock = await checkActiveLivePinExamLock(session.principalId);
  if (lock.locked) {
    return jsonNoStore(
      {
        locked: true,
        examId: lock.examId,
        examTitle: lock.examTitle,
        error: "लाइव परीक्षा चल रही है — परीक्षा जमा करने तक अध्याय नोट्स अस्थायी रूप से लॉक हैं।",
        errorEn: "A live classroom exam is currently active — Chapter Notes are temporarily locked until you submit.",
      },
      { status: 423 }
    );
  }

  const supabase = getSupabaseAdmin();
  const [chapterRes, enrolledIds] = await Promise.all([
    supabase
      .from("chapters")
      .select("*")
      .eq("id", chapterId)
      .eq("is_published", true)
      .maybeSingle(),
    getStudentEnrolledSubjectIds(session.principalId, studentInfo.academicYear),
  ]);

  if (chapterRes.error || !chapterRes.data) {
    return jsonNoStore(
      { error: "यह अध्याय उपलब्ध नहीं है।", errorEn: "Chapter not found." },
      { status: 404 }
    );
  }

  const chapter = chapterRes.data;
  if (enrolledIds.length > 0 && !enrolledIds.includes(chapter.subject_id)) {
    return jsonNoStore(
      {
        error: "यह अध्याय आपके चुने गए विषयों में शामिल नहीं है।",
        errorEn: "This chapter does not belong to your selected subjects.",
      },
      { status: 403 }
    );
  }

  const [subjectRes, noteRes, progressRes, practiceCountRes, siblingChaptersRes] =
    await Promise.all([
      supabase.from("subjects").select("*").eq("id", chapter.subject_id).single(),
      supabase
        .from("chapter_notes")
        .select("*")
        .eq("chapter_id", chapter.id)
        .eq("status", "PUBLISHED")
        .maybeSingle(),
      supabase
        .from("student_chapter_progress")
        .select("*")
        .eq("student_id", session.principalId)
        .eq("chapter_id", chapter.id)
        .maybeSingle(),
      supabase
        .from("questions")
        .select("question_type")
        .eq("chapter_id", chapter.id)
        .eq("bank_pool", "PRACTICE")
        .eq("is_published", true),
      supabase
        .from("chapters")
        .select("id, chapter_no, title_hi, title_en")
        .eq("subject_id", chapter.subject_id)
        .eq("is_published", true)
        .order("chapter_no", { ascending: true }),
    ]);

  const practiceTypes = practiceCountRes.data ?? [];
  const practiceCounts = {
    total: practiceTypes.length,
    mcq: practiceTypes.filter((q) => q.question_type === "MCQ").length,
    visual: practiceTypes.filter((q) =>
      ["FLASHCARD", "MATCH_PAIRS", "DIAGRAM_LABEL"].includes(q.question_type)
    ).length,
    subjective: practiceTypes.filter((q) =>
      ["SHORT_2M", "LONG_5M"].includes(q.question_type)
    ).length,
  };

  const siblings = siblingChaptersRes.data ?? [];
  const currentIdx = siblings.findIndex((c) => c.id === chapter.id);
  const prevChapter = currentIdx > 0 ? siblings[currentIdx - 1] : null;
  const nextChapter =
    currentIdx >= 0 && currentIdx < siblings.length - 1 ? siblings[currentIdx + 1] : null;

  return jsonNoStore({
    chapter,
    subject: subjectRes.data ?? null,
    note: noteRes.data ?? null,
    progress: progressRes.data ?? {
      student_id: session.principalId,
      chapter_id: chapter.id,
      notes_completed: false,
      notes_progress_pct: 0,
      flashcards_mastered: 0,
      practice_attempted: 0,
      practice_correct: 0,
      mastery_pct: 0,
      last_studied_at: null,
    },
    practiceCounts,
    navigation: {
      prevChapter,
      nextChapter,
    },
  });
}

export async function POST(
  request: Request,
  context: { params: Promise<{ chapterId: string }> }
) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;

  const { session } = auth;
  const studentInfo = session.student!;
  const { chapterId } = await context.params;

  const lock = await checkActiveLivePinExamLock(session.principalId);
  if (lock.locked) {
    return jsonNoStore(
      {
        locked: true,
        examId: lock.examId,
        error: "लाइव परीक्षा चल रही है।",
        errorEn: "Live exam is in progress.",
      },
      { status: 423 }
    );
  }

  let body: unknown = {};
  try {
    body = await request.json();
  } catch {
    // Allow empty body defaulting to notesCompleted: true
  }

  const parsed = markNotesSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore({ error: "अमान्य अनुरोध।", errorEn: "Invalid payload." }, { status: 400 });
  }

  const supabase = getSupabaseAdmin();
  const [chapterRes, enrolledIds, existingProgRes] = await Promise.all([
    supabase
      .from("chapters")
      .select("id, subject_id")
      .eq("id", chapterId)
      .eq("is_published", true)
      .maybeSingle(),
    getStudentEnrolledSubjectIds(session.principalId, studentInfo.academicYear),
    supabase
      .from("student_chapter_progress")
      .select("*")
      .eq("student_id", session.principalId)
      .eq("chapter_id", chapterId)
      .maybeSingle(),
  ]);

  if (!chapterRes.data) {
    return jsonNoStore({ error: "अध्याय नहीं मिला।", errorEn: "Chapter not found." }, { status: 404 });
  }
  if (enrolledIds.length > 0 && !enrolledIds.includes(chapterRes.data.subject_id)) {
    return jsonNoStore({ error: "अनुमति नहीं है।", errorEn: "Not enrolled in this subject." }, { status: 403 });
  }

  const existing = existingProgRes.data;
  const wasCompleted = Boolean(existing?.notes_completed);
  const nextCompleted = parsed.data.notesCompleted || wasCompleted;
  const nextNotesPct = nextCompleted
    ? 100
    : Math.max(existing?.notes_progress_pct ?? 0, parsed.data.notesProgressPct ?? 0);

  const practiceAttempted = existing?.practice_attempted ?? 0;
  const practiceCorrect = existing?.practice_correct ?? 0;
  const practiceAccuracyPct =
    practiceAttempted > 0 ? Math.round((practiceCorrect / practiceAttempted) * 100) : 0;
  const nextMasteryPct = Math.min(
    100,
    Math.round(nextNotesPct * 0.35 + practiceAccuracyPct * 0.65)
  );

  await supabase.from("student_chapter_progress").upsert(
    {
      student_id: session.principalId,
      chapter_id: chapterId,
      notes_completed: nextCompleted,
      notes_progress_pct: nextNotesPct,
      flashcards_mastered: existing?.flashcards_mastered ?? 0,
      practice_attempted: practiceAttempted,
      practice_correct: practiceCorrect,
      mastery_pct: Math.max(existing?.mastery_pct ?? 0, nextMasteryPct),
      last_studied_at: new Date().toISOString(),
    },
    { onConflict: "student_id,chapter_id" }
  );

  // Award one-time +20 mastery points when notes are completed for the very first time
  let reward: Awaited<ReturnType<typeof awardStudentStudyProgress>> | null = null;
  const pointsAwarded = !wasCompleted && nextCompleted ? 20 : 0;
  if (pointsAwarded > 0) {
    reward = await awardStudentStudyProgress({
      studentId: session.principalId,
      pointsDelta: pointsAwarded,
    });
  }

  return jsonNoStore({
    ok: true,
    notesCompleted: nextCompleted,
    notesProgressPct: nextNotesPct,
    masteryPct: Math.max(existing?.mastery_pct ?? 0, nextMasteryPct),
    medal: computeChapterMedal(Math.max(existing?.mastery_pct ?? 0, nextMasteryPct)),
    pointsAwarded,
    reward,
  });
}
