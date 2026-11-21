import { requireRole, jsonNoStore } from "@/lib/auth/session";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { getIstDayBoundsUtc, getIstWeekStart, getTodayIst } from "@/lib/time/ist";
import {
  checkActiveLivePinExamLock,
  computeChapterMedal,
  getScholarlyRank,
} from "@/app/api/student/_helpers";

export async function GET(request: Request) {
  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;

  const { session } = auth;
  const studentInfo = session.student!;
  const supabase = getSupabaseAdmin();

  const todayIst = getTodayIst();
  const weekStartIst = getIstWeekStart();
  const { startIso: todayStartUtc, endIso: todayEndUtc } = getIstDayBoundsUtc(todayIst);

  const [
    studentRes,
    enrolledRes,
    progressRes,
    revisionRes,
    todayPracticeRes,
    spotlightRes,
    examsRes,
    liveLock,
  ] = await Promise.all([
    supabase
      .from("students")
      .select(
        "id, student_code, student_name, father_name, dob, class_num, stream, section, roll_no, academic_year, preferred_lang, subjects_configured, mastery_points, weekly_points, streak_days, last_active_ist, week_start_ist, badges, pin_hash"
      )
      .eq("id", session.principalId)
      .single(),
    supabase
      .from("student_subjects")
      .select("subject_id, slot_type")
      .eq("student_id", session.principalId)
      .eq("academic_year", studentInfo.academicYear),
    supabase
      .from("student_chapter_progress")
      .select("*")
      .eq("student_id", session.principalId)
      .order("last_studied_at", { ascending: false }),
    supabase
      .from("student_revision_queue")
      .select("question_id, chapter_id, next_review_ist, resolved")
      .eq("student_id", session.principalId)
      .eq("resolved", false),
    supabase
      .from("practice_sessions")
      .select("attempt_id, total_questions, correct_count, points_awarded, time_spent_seconds")
      .eq("student_id", session.principalId)
      .gte("created_at", todayStartUtc)
      .lte("created_at", todayEndUtc),
    supabase
      .from("students")
      .select("id, student_name, roll_no, weekly_points, mastery_points, streak_days, week_start_ist")
      .eq("school_udise", session.schoolUdise!)
      .eq("class_num", studentInfo.classNum)
      .eq("is_active", true)
      .gt("weekly_points", 0)
      .order("weekly_points", { ascending: false })
      .order("mastery_points", { ascending: false })
      .limit(5),
    supabase
      .from("exams")
      .select("id, title, exam_mode, subject_id, status, starts_at, ends_at, duration_mins")
      .eq("school_udise", session.schoolUdise!)
      .eq("class_num", studentInfo.classNum)
      .in("status", ["LOBBY", "ACTIVE"]),
    checkActiveLivePinExamLock(session.principalId),
  ]);

  if (studentRes.error || !studentRes.data) {
    return jsonNoStore(
      { error: "डैशबोर्ड लोड नहीं हो सका।", errorEn: "Unable to load student dashboard." },
      { status: 500 }
    );
  }

  const student = studentRes.data;
  const enrolledSlots = enrolledRes.data ?? [];
  const enrolledIds = enrolledSlots.map((s) => s.subject_id);

  // Load subjects, chapters, and published chapter_notes availability
  let subjectsData: Array<{
    id: string;
    bseb_code: string;
    class_num: number;
    stream: string;
    category: string;
    name_en: string;
    name_hi: string;
    icon_name: string;
    accent_color: string;
    sort_order: number;
  }> = [];
  let chaptersData: Array<{
    id: string;
    subject_id: string;
    chapter_no: number;
    title_en: string;
    title_hi: string;
    summary_en: string | null;
    summary_hi: string | null;
    bseb_weightage_marks: number;
    estimated_mins: number;
  }> = [];
  let publishedNoteChapterIds = new Set<string>();

  if (enrolledIds.length > 0) {
    const [subRes, chRes] = await Promise.all([
      supabase
        .from("subjects")
        .select("*")
        .in("id", enrolledIds)
        .order("sort_order", { ascending: true }),
      supabase
        .from("chapters")
        .select(
          "id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins"
        )
        .in("subject_id", enrolledIds)
        .eq("is_published", true)
        .order("chapter_no", { ascending: true }),
    ]);
    subjectsData = subRes.data ?? [];
    chaptersData = chRes.data ?? [];

    const chIds = chaptersData.map((c) => c.id);
    if (chIds.length > 0) {
      const { data: noteRows } = await supabase
        .from("chapter_notes")
        .select("chapter_id")
        .in("chapter_id", chIds)
        .eq("status", "PUBLISHED");
      publishedNoteChapterIds = new Set((noteRows ?? []).map((n) => n.chapter_id));
    }
  }

  const progressRows = progressRes.data ?? [];
  const progressByChapter = new Map(progressRows.map((p) => [p.chapter_id, p]));
  const slotBySubject = new Map(enrolledSlots.map((s) => [s.subject_id, s.slot_type]));
  const chapterById = new Map(chaptersData.map((c) => [c.id, c]));
  const subjectById = new Map(subjectsData.map((s) => [s.id, s]));

  // Build per-subject journey summaries
  const subjectsSummary = subjectsData.map((subj) => {
    const subjChapters = chaptersData.filter((c) => c.subject_id === subj.id);
    let completedChapters = 0;
    let totalMastery = 0;
    let goldCount = 0;
    let silverCount = 0;
    let bronzeCount = 0;
    let richNotesCount = 0;

    for (const ch of subjChapters) {
      if (publishedNoteChapterIds.has(ch.id)) richNotesCount += 1;
      const prog = progressByChapter.get(ch.id);
      const pct = prog?.mastery_pct ?? 0;
      totalMastery += pct;
      if (prog?.notes_completed && pct >= 60) completedChapters += 1;
      const medal = computeChapterMedal(pct);
      if (medal === "GOLD") goldCount += 1;
      else if (medal === "SILVER") silverCount += 1;
      else if (medal === "BRONZE") bronzeCount += 1;
    }

    const avgMasteryPct =
      subjChapters.length > 0 ? Math.round(totalMastery / subjChapters.length) : 0;

    return {
      ...subj,
      slot_type: slotBySubject.get(subj.id) ?? subj.category,
      totalChapters: subjChapters.length,
      richNotesCount,
      completedChapters,
      avgMasteryPct,
      medals: { gold: goldCount, silver: silverCount, bronze: bronzeCount },
    };
  });

  // Determine "Continue Where You Left Off" card
  let continueChapter: {
    chapterId: string;
    chapterNo: number;
    titleHi: string;
    titleEn: string;
    subjectId: string;
    subjectNameHi: string;
    subjectNameEn: string;
    masteryPct: number;
    notesCompleted: boolean;
    hasRichNotes: boolean;
    estimatedMins: number;
  } | null = null;

  for (const prog of progressRows) {
    const ch = chapterById.get(prog.chapter_id);
    if (!ch) continue;
    const subj = subjectById.get(ch.subject_id);
    if (!subj) continue;
    continueChapter = {
      chapterId: ch.id,
      chapterNo: ch.chapter_no,
      titleHi: ch.title_hi,
      titleEn: ch.title_en,
      subjectId: subj.id,
      subjectNameHi: subj.name_hi,
      subjectNameEn: subj.name_en,
      masteryPct: prog.mastery_pct,
      notesCompleted: prog.notes_completed,
      hasRichNotes: publishedNoteChapterIds.has(ch.id),
      estimatedMins: ch.estimated_mins,
    };
    break;
  }

  // Fallback to first flagship chapter that has published gold visual notes
  if (!continueChapter && chaptersData.length > 0) {
    const firstGold =
      chaptersData.find((c) => publishedNoteChapterIds.has(c.id)) ?? chaptersData[0];
    const subj = subjectById.get(firstGold.subject_id);
    if (subj) {
      continueChapter = {
        chapterId: firstGold.id,
        chapterNo: firstGold.chapter_no,
        titleHi: firstGold.title_hi,
        titleEn: firstGold.title_en,
        subjectId: subj.id,
        subjectNameHi: subj.name_hi,
        subjectNameEn: subj.name_en,
        masteryPct: 0,
        notesCompleted: false,
        hasRichNotes: publishedNoteChapterIds.has(firstGold.id),
        estimatedMins: firstGold.estimated_mins,
      };
    }
  }

  const todaySessions = todayPracticeRes.data ?? [];
  const todayQuestionsCount = todaySessions.reduce((acc, r) => acc + (r.total_questions ?? 0), 0);
  const todayPoints = todaySessions.reduce((acc, r) => acc + (r.points_awarded ?? 0), 0);
  const dailyGoalTarget = 5; // Friendly 5-question / 5-minute daily habit

  const revisionItems = revisionRes.data ?? [];
  const revisionDueCount = revisionItems.filter(
    (r) => !r.next_review_ist || r.next_review_ist <= todayIst
  ).length;

  const enrolledSet = new Set(enrolledIds);
  const activeExams = (examsRes.data ?? []).filter((ex) =>
    enrolledSet.size === 0 ? true : enrolledSet.has(ex.subject_id)
  );

  const spotlight = (spotlightRes.data ?? [])
    .filter((row) => !row.week_start_ist || row.week_start_ist === weekStartIst)
    .map((row, idx) => ({
      rank: idx + 1,
      studentName: row.student_name,
      rollNo: row.roll_no,
      weeklyPoints: row.weekly_points,
      streakDays: row.streak_days,
      isCurrentStudent: row.id === student.id,
    }));

  const totalMedals = subjectsSummary.reduce(
    (acc, s) => ({
      gold: acc.gold + s.medals.gold,
      silver: acc.silver + s.medals.silver,
      bronze: acc.bronze + s.medals.bronze,
    }),
    { gold: 0, silver: 0, bronze: 0 }
  );

  return jsonNoStore({
    student: {
      id: student.id,
      studentCode: student.student_code,
      studentName: student.student_name,
      fatherName: student.father_name,
      dob: student.dob,
      classNum: student.class_num,
      stream: student.stream,
      section: student.section,
      rollNo: student.roll_no,
      academicYear: student.academic_year,
      schoolUdise: session.schoolUdise,
      schoolName: session.schoolName,
      preferredLang: student.preferred_lang,
      subjectsConfigured: student.subjects_configured,
      hasPin: Boolean(student.pin_hash),
      masteryPoints: student.mastery_points,
      weeklyPoints: student.week_start_ist === weekStartIst ? student.weekly_points : 0,
      streakDays: student.streak_days,
      badges: Array.isArray(student.badges) ? student.badges : [],
      rank: getScholarlyRank(student.mastery_points),
      totalMedals,
    },
    dailyGoal: {
      todayIst,
      completedQuestions: todayQuestionsCount,
      targetQuestions: dailyGoalTarget,
      progressPct: Math.min(100, Math.round((todayQuestionsCount / dailyGoalTarget) * 100)),
      todayPoints,
      completed: todayQuestionsCount >= dailyGoalTarget,
    },
    continueChapter,
    subjects: subjectsSummary,
    revision: {
      totalCount: revisionItems.length,
      dueCount: revisionDueCount,
    },
    activeExamsCount: activeExams.length,
    liveExamLock: liveLock,
    weeklySpotlight: spotlight,
  });
}
