import { requireRole, jsonNoStore } from "@/lib/auth/session";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { getIstDayBoundsUtc, getIstWeekStart, getTodayIst } from "@/lib/time/ist";
import {
  checkActiveLivePinExamLock,
  computeChapterMedal,
  computeFourStageProgress,
  getScholarlyRank,
  isUniversalSkillSubject,
  PLAY_LAB_QUESTION_TYPES,
  UNIVERSAL_SKILL_SUBJECT_IDS,
  type FourStageProgressResult,
} from "@/app/api/student/_helpers";
import type { QuestionType, SubjectRow } from "@/types/database";

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
    questionMasteryRes,
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
    supabase
      .from("student_question_mastery")
      .select("question_id, correct_count, attempts_count")
      .eq("student_id", session.principalId)
      .gt("correct_count", 0),
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

  // Always load universal skill labs alongside the student's enrolled BSEB subjects
  const fetchSubjectIds = Array.from(
    new Set<string>([...UNIVERSAL_SKILL_SUBJECT_IDS, ...enrolledIds])
  );

  const { data: rawSubjectsData } = await supabase
    .from("subjects")
    .select("*")
    .in("id", fetchSubjectIds)
    .order("sort_order", { ascending: true });

  const allFetchedSubjects: SubjectRow[] = (rawSubjectsData ?? []) as SubjectRow[];

  // Resolve syllabus aliases so e.g. bseb-12-lang2-eng seamlessly shows bseb-12-lang1-eng chapters
  // and bseb-9/10-skill-ict is deduped against universal 'skill-ict-lab'
  const canonicalSubjectIds = new Set<string>(UNIVERSAL_SKILL_SUBJECT_IDS);
  const accessibleSubjectIdSet = new Set<string>(UNIVERSAL_SKILL_SUBJECT_IDS);

  for (const s of allFetchedSubjects) {
    accessibleSubjectIdSet.add(s.id);
    if (s.syllabus_alias_of) {
      canonicalSubjectIds.add(s.syllabus_alias_of);
      accessibleSubjectIdSet.add(s.syllabus_alias_of);
    } else {
      canonicalSubjectIds.add(s.id);
    }
  }

  const canonicalIdList = Array.from(canonicalSubjectIds);

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
  const chapterHasSubjective = new Set<string>();
  const chapterPlayCountMap = new Map<string, number>();

  if (canonicalIdList.length > 0) {
    const { data: chData } = await supabase
      .from("chapters")
      .select(
        "id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins"
      )
      .in("subject_id", canonicalIdList)
      .eq("is_published", true)
      .order("chapter_no", { ascending: true });

    chaptersData = chData ?? [];
    const chIds = chaptersData.map((c) => c.id);

    if (chIds.length > 0) {
      const [noteRowsRes, qRowsRes] = await Promise.all([
        supabase
          .from("chapter_notes")
          .select("chapter_id")
          .in("chapter_id", chIds)
          .eq("status", "PUBLISHED"),
        supabase
          .from("questions")
          .select("chapter_id, question_type")
          .in("chapter_id", chIds)
          .eq("bank_pool", "PRACTICE")
          .eq("is_published", true),
      ]);

      publishedNoteChapterIds = new Set((noteRowsRes.data ?? []).map((n) => n.chapter_id));
      for (const q of qRowsRes.data ?? []) {
        const qType = q.question_type as QuestionType;
        if (qType === "SHORT_2M" || qType === "LONG_5M") {
          chapterHasSubjective.add(q.chapter_id);
        }
        if (PLAY_LAB_QUESTION_TYPES.has(qType)) {
          chapterPlayCountMap.set(
            q.chapter_id,
            (chapterPlayCountMap.get(q.chapter_id) ?? 0) + 1
          );
        }
      }
    }
  }

  const progressRows = progressRes.data ?? [];
  const progressByChapter = new Map(progressRows.map((p) => [p.chapter_id, p]));
  const slotBySubject = new Map(enrolledSlots.map((s) => [s.subject_id, s.slot_type]));
  const chapterById = new Map(chaptersData.map((c) => [c.id, c]));

  // Partition into Universal Skills (featured at top for every Class 9-12 student)
  // and Student's BSEB Subjects (deduping any subject aliased to a universal skill like bseb-9/10-skill-ict)
  const universalOrder = new Map<string, number>(
    UNIVERSAL_SKILL_SUBJECT_IDS.map((id, idx) => [id, idx])
  );
  const universalSubjects = allFetchedSubjects
    .filter((s) => isUniversalSkillSubject(s.id))
    .sort((a, b) => (universalOrder.get(a.id) ?? 99) - (universalOrder.get(b.id) ?? 99));

  const seenCanonicalBseb = new Set<string>();
  const bsebSubjects = allFetchedSubjects.filter((s) => {
    if (isUniversalSkillSubject(s.id)) return false;
    // Dedupe bseb-9-skill-ict & bseb-10-skill-ict cleanly since skill-ict-lab is featured prominently
    if (s.syllabus_alias_of && isUniversalSkillSubject(s.syllabus_alias_of)) {
      return false;
    }
    const canonical = s.syllabus_alias_of ?? s.id;
    if (seenCanonicalBseb.has(canonical)) return false;
    seenCanonicalBseb.add(canonical);
    return enrolledIds.includes(s.id);
  });

  // Helper to compute 4-stage progress for any chapter row
  const getChapterFourStage = (chapterId: string): FourStageProgressResult => {
    const prog = progressByChapter.get(chapterId);
    const quizMasteryPct =
      prog && prog.practice_attempted > 0
        ? Math.round((prog.practice_correct / prog.practice_attempted) * 100)
        : 0;
    return computeFourStageProgress({
      notesCompleted: Boolean(prog?.notes_completed),
      notesProgressPct: prog?.notes_progress_pct ?? 0,
      playCompleted: Boolean(prog?.play_completed),
      quizMasteryPct,
      subjectiveCompleted: Boolean(prog?.subjective_completed),
      hasSubjective: chapterHasSubjective.has(chapterId),
    });
  };

  // Build per-subject journey summaries (used for both universalSkills & BSEB subjects)
  const buildSubjectSummary = (subj: SubjectRow) => {
    const contentSubjectId = subj.syllabus_alias_of ?? subj.id;
    const subjChapters = chaptersData.filter((c) => c.subject_id === contentSubjectId);
    let completedChapters = 0;
    let totalMastery = 0;
    let goldCount = 0;
    let silverCount = 0;
    let bronzeCount = 0;
    let richNotesCount = 0;
    let playLabsCompleted = 0;
    let totalInteractiveLabs = 0;

    for (const ch of subjChapters) {
      if (publishedNoteChapterIds.has(ch.id)) richNotesCount += 1;
      totalInteractiveLabs += chapterPlayCountMap.get(ch.id) ?? 0;

      const prog = progressByChapter.get(ch.id);
      const fourStage = getChapterFourStage(ch.id);
      const effectivePct = Math.max(prog?.mastery_pct ?? 0, fourStage.totalPct);

      totalMastery += effectivePct;
      if (prog?.play_completed) playLabsCompleted += 1;
      if (fourStage.completedStages >= 3 || (prog?.notes_completed && effectivePct >= 60)) {
        completedChapters += 1;
      }

      const medal = computeChapterMedal(effectivePct);
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
      playLabsCompleted,
      totalInteractiveLabs,
      avgMasteryPct,
      medals: { gold: goldCount, silver: silverCount, bronze: bronzeCount },
    };
  };

  const universalSkillsSummary = universalSubjects.map(buildSubjectSummary);
  const subjectsSummary = bsebSubjects.map(buildSubjectSummary);

  // Map canonical subject ID -> displayed subject card for Continue Card labeling
  const displaySubjectByCanonical = new Map<string, SubjectRow>();
  for (const s of universalSubjects) {
    displaySubjectByCanonical.set(s.id, s);
  }
  for (const s of bsebSubjects) {
    displaySubjectByCanonical.set(s.syllabus_alias_of ?? s.id, s);
  }

  // Determine "Continue Where You Left Off" card (across both BSEB & Universal Skill Labs)
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
    playCompleted: boolean;
    subjectiveCompleted: boolean;
    fourStage: FourStageProgressResult;
    hasRichNotes: boolean;
    estimatedMins: number;
  } | null = null;

  for (const prog of progressRows) {
    const ch = chapterById.get(prog.chapter_id);
    if (!ch) continue;
    const subj = displaySubjectByCanonical.get(ch.subject_id);
    if (!subj) continue;
    const fourStage = getChapterFourStage(ch.id);
    const effectivePct = Math.max(prog.mastery_pct, fourStage.totalPct);
    continueChapter = {
      chapterId: ch.id,
      chapterNo: ch.chapter_no,
      titleHi: ch.title_hi,
      titleEn: ch.title_en,
      subjectId: subj.id,
      subjectNameHi: subj.name_hi,
      subjectNameEn: subj.name_en,
      masteryPct: effectivePct,
      notesCompleted: prog.notes_completed,
      playCompleted: Boolean(prog.play_completed),
      subjectiveCompleted: Boolean(prog.subjective_completed),
      fourStage,
      hasRichNotes: publishedNoteChapterIds.has(ch.id),
      estimatedMins: ch.estimated_mins,
    };
    break;
  }

  // Fallback to first flagship chapter that has published gold visual notes
  if (!continueChapter && chaptersData.length > 0) {
    const firstGold =
      chaptersData.find((c) => publishedNoteChapterIds.has(c.id)) ?? chaptersData[0];
    const subj = displaySubjectByCanonical.get(firstGold.subject_id);
    if (subj) {
      const fourStage = getChapterFourStage(firstGold.id);
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
        playCompleted: false,
        subjectiveCompleted: false,
        fourStage,
        hasRichNotes: publishedNoteChapterIds.has(firstGold.id),
        estimatedMins: firstGold.estimated_mins,
      };
    }
  }

  // Concrete, genuine skill progress milestones ("मेरी वास्तविक प्रगति")
  const masteredQuestionRows = questionMasteryRes.data ?? [];
  const questionsMastered = masteredQuestionRows.length;
  let chaptersMastered = 0;
  let playLabsCompleted = 0;
  let notesCompletedCount = 0;
  let flashcardsMasteredTotal = 0;

  for (const prog of progressRows) {
    const fourStage = getChapterFourStage(prog.chapter_id);
    const effectivePct = Math.max(prog.mastery_pct ?? 0, fourStage.totalPct);
    if (fourStage.completedStages >= 3 || effectivePct >= 75) {
      chaptersMastered += 1;
    }
    if (prog.play_completed) playLabsCompleted += 1;
    if (prog.notes_completed) notesCompletedCount += 1;
    flashcardsMasteredTotal += prog.flashcards_mastered ?? 0;
  }

  // Count distinct play-lab/vocabulary items mastered alongside notes & flashcards
  let labItemsMastered = flashcardsMasteredTotal;
  if (masteredQuestionRows.length > 0) {
    const qIds = masteredQuestionRows.map((m) => m.question_id).slice(0, 500);
    const { data: masteredQTypes } = await supabase
      .from("questions")
      .select("id, question_type")
      .in("id", qIds);
    const distinctPlayMastered = (masteredQTypes ?? []).filter((q) =>
      PLAY_LAB_QUESTION_TYPES.has(q.question_type as QuestionType)
    ).length;
    labItemsMastered = Math.max(distinctPlayMastered, flashcardsMasteredTotal);
  }
  const wordsAndConceptsLearned = labItemsMastered + notesCompletedCount * 3;

  const todaySessions = todayPracticeRes.data ?? [];
  const todayQuestionsCount = todaySessions.reduce((acc, r) => acc + (r.total_questions ?? 0), 0);
  const todayPoints = todaySessions.reduce((acc, r) => acc + (r.points_awarded ?? 0), 0);
  const dailyGoalTarget = 5; // Friendly 5-question / 5-minute daily habit

  const revisionItems = revisionRes.data ?? [];
  const revisionDueCount = revisionItems.filter(
    (r) => !r.next_review_ist || r.next_review_ist <= todayIst
  ).length;

  const activeExams = (examsRes.data ?? []).filter((ex) =>
    accessibleSubjectIdSet.size === 0 ? true : accessibleSubjectIdSet.has(ex.subject_id)
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

  const allSummariesForMedals = [...universalSkillsSummary, ...subjectsSummary];
  const totalMedals = allSummariesForMedals.reduce(
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
    concreteStats: {
      chaptersMastered,
      playLabsCompleted,
      wordsAndConceptsLearned,
      questionsMastered,
      notesCompletedCount,
    },
    continueChapter,
    universalSkills: universalSkillsSummary,
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
