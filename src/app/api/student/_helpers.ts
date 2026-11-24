import { getSupabaseAdmin } from "@/lib/supabase/server";
import { isMissingColumnError } from "@/lib/supabase/schema-compat";
import { diffIstDays, getIstWeekStart, getTodayIst } from "@/lib/time/ist";
import {
  computeChapterMedal,
  computeFourStageProgress,
  type ChapterMedal,
  type FourStageItem,
  type FourStageProgressInput,
  type FourStageProgressResult,
} from "@/lib/progress/four-stage";
import type { QuestionType, StudentBadge } from "@/types/database";

export {
  computeChapterMedal,
  computeFourStageProgress,
  type ChapterMedal,
  type FourStageItem,
  type FourStageProgressInput,
  type FourStageProgressResult,
};

/**
 * Canonical universal skill & foundation tracks automatically unlocked for EVERY
 * Bihar government school student across Classes 9, 10, 11, and 12.
 */
export const UNIVERSAL_SKILL_SUBJECT_IDS = [
  "skill-ict-lab",
  "skill-eng-foundation",
] as const;

export type UniversalSkillSubjectId = (typeof UNIVERSAL_SKILL_SUBJECT_IDS)[number];

export const PLAY_LAB_QUESTION_TYPES: ReadonlySet<QuestionType> = new Set<QuestionType>([
  "FLASHCARD",
  "MATCH_PAIRS",
  "DIAGRAM_LABEL",
  "SENTENCE_BUILDER",
  "SHORTCUT_STUDIO",
  "EXCEL_SANDBOX",
  "SCENARIO_LAB",
]);

export function isUniversalSkillSubject(subjectId: string): boolean {
  return (UNIVERSAL_SKILL_SUBJECT_IDS as readonly string[]).includes(subjectId);
}

export interface LiveExamLockState {
  locked: boolean;
  examId?: string;
  examTitle?: string;
}

/**
 * Checks whether the student currently has an active IN_PROGRESS attempt
 * on a LIVE_PIN exam whose status is ACTIVE. When true, notes & practice
 * routes return HTTP 423 Locked to protect exam integrity.
 */
export async function checkActiveLivePinExamLock(
  studentId: string
): Promise<LiveExamLockState> {
  const supabase = getSupabaseAdmin();
  const { data: attempts, error } = await supabase
    .from("exam_attempts")
    .select("exam_id, status")
    .eq("student_id", studentId)
    .eq("status", "IN_PROGRESS")
    .limit(5);

  if (error || !attempts || attempts.length === 0) {
    return { locked: false };
  }

  const examIds = attempts.map((a) => a.exam_id);
  const { data: activeExams } = await supabase
    .from("exams")
    .select("id, title, exam_mode, status")
    .in("id", examIds)
    .eq("exam_mode", "LIVE_PIN")
    .eq("status", "ACTIVE")
    .limit(1);

  const blocking = activeExams?.[0];
  if (!blocking) {
    return { locked: false };
  }

  return {
    locked: true,
    examId: blocking.id,
    examTitle: blocking.title,
  };
}

/**
 * Resolves a single subject ID through `subjects.syllabus_alias_of` to its canonical
 * syllabus subject ID (e.g. `bseb-12-lang2-eng` -> `bseb-12-lang1-eng`,
 * `bseb-10-skill-ict` -> `skill-ict-lab`).
 * Gracefully falls back to `subjectId` if migration `004` (`syllabus_alias_of`) is not yet applied.
 */
export async function resolveCanonicalSubjectId(subjectId: string): Promise<string> {
  const supabase = getSupabaseAdmin();
  const { data, error } = await supabase
    .from("subjects")
    .select("id, syllabus_alias_of")
    .eq("id", subjectId)
    .maybeSingle();

  if (error) {
    if (isMissingColumnError(error)) return subjectId;
    return subjectId;
  }

  return data?.syllabus_alias_of ?? subjectId;
}

/**
 * Batch resolves a list of subject IDs to a map of `subjectId -> canonicalSubjectId`.
 * Gracefully falls back to identity mapping if migration `004` is not yet applied.
 */
export async function resolveSubjectAliasMap(
  subjectIds: string[]
): Promise<Map<string, string>> {
  const unique = Array.from(new Set(subjectIds.filter(Boolean)));
  const map = new Map<string, string>();
  if (unique.length === 0) return map;

  for (const id of unique) {
    map.set(id, id);
  }

  const supabase = getSupabaseAdmin();
  const { data, error } = await supabase
    .from("subjects")
    .select("id, syllabus_alias_of")
    .in("id", unique);

  if (error) {
    if (isMissingColumnError(error)) return map;
    return map;
  }

  for (const row of data ?? []) {
    map.set(row.id, row.syllabus_alias_of ?? row.id);
  }
  return map;
}

/**
 * Expands a list of subject IDs to include their canonical `syllabus_alias_of` targets
 * AND any sibling alias subject IDs pointing to those same canonical targets.
 * Gracefully returns `subjectIds` unchanged if migration `004` is not yet applied.
 */
export async function expandSubjectIdsWithAliases(
  subjectIds: string[]
): Promise<string[]> {
  const unique = Array.from(new Set(subjectIds.filter(Boolean)));
  if (unique.length === 0) return [];

  const aliasMap = await resolveSubjectAliasMap(unique);
  const canonicalIds = Array.from(new Set([...unique, ...aliasMap.values()]));
  const expanded = new Set<string>(canonicalIds);

  const supabase = getSupabaseAdmin();
  const { data: reverseAliases, error } = await supabase
    .from("subjects")
    .select("id")
    .in("syllabus_alias_of", canonicalIds);

  if (!error) {
    for (const row of reverseAliases ?? []) {
      expanded.add(row.id);
    }
  }

  return Array.from(expanded);
}

/**
 * Returns strictly the raw subject IDs saved in `student_subjects`.
 */
export async function getStudentRawEnrolledSubjectIds(
  studentId: string,
  academicYear: string
): Promise<string[]> {
  const supabase = getSupabaseAdmin();
  const { data } = await supabase
    .from("student_subjects")
    .select("subject_id")
    .eq("student_id", studentId)
    .eq("academic_year", academicYear);

  return (data ?? []).map((row) => row.subject_id);
}

/**
 * Returns ALL subject IDs accessible to a Class 9-12 student:
 * - Their enrolled BSEB subjects
 * - Resolved `syllabus_alias_of` canonical subjects (e.g. `bseb-12-lang2-eng` -> `bseb-12-lang1-eng`)
 * - Universal skill & foundation labs (`skill-ict-lab`, `skill-eng-foundation`)
 */
export async function getStudentAccessibleSubjectIds(
  studentId: string,
  academicYear: string
): Promise<string[]> {
  const rawIds = await getStudentRawEnrolledSubjectIds(studentId, academicYear);
  const accessible = new Set<string>(UNIVERSAL_SKILL_SUBJECT_IDS);

  if (rawIds.length > 0) {
    const aliasMap = await resolveSubjectAliasMap(rawIds);
    for (const id of rawIds) {
      accessible.add(id);
      const canonical = aliasMap.get(id);
      if (canonical) accessible.add(canonical);
    }
  }

  return Array.from(accessible);
}

/**
 * Backwards-compatible alias for `getStudentAccessibleSubjectIds` so every student
 * route automatically unlocks Universal Skill Labs & `syllabus_alias_of` targets.
 */
export async function getStudentEnrolledSubjectIds(
  studentId: string,
  academicYear: string
): Promise<string[]> {
  return getStudentAccessibleSubjectIds(studentId, academicYear);
}

export interface ScholarlyRank {
  level: number;
  title_hi: string;
  title_en: string;
  minPoints: number;
  nextPoints: number | null;
}

export function getScholarlyRank(masteryPoints: number): ScholarlyRank {
  if (masteryPoints >= 1500) {
    return {
      level: 5,
      title_hi: "बिहार मेधा श्री",
      title_en: "Bihar Board Distinction",
      minPoints: 1500,
      nextPoints: null,
    };
  }
  if (masteryPoints >= 700) {
    return {
      level: 4,
      title_hi: "विद्या भूषण",
      title_en: "Honours Scholar",
      minPoints: 700,
      nextPoints: 1500,
    };
  }
  if (masteryPoints >= 300) {
    return {
      level: 3,
      title_hi: "संकल्प रत्न",
      title_en: "Merit Achiever",
      minPoints: 300,
      nextPoints: 700,
    };
  }
  if (masteryPoints >= 100) {
    return {
      level: 2,
      title_hi: "अध्ययन साधक",
      title_en: "Dedicated Scholar",
      minPoints: 100,
      nextPoints: 300,
    };
  }
  return {
    level: 1,
    title_hi: "जिज्ञासु विद्यार्थी",
    title_en: "Curious Learner",
    minPoints: 0,
    nextPoints: 100,
  };
}

/**
 * Adds mastery & weekly points and updates IST daily streak & scholarly badges
 * cleanly for a student.
 */
export async function awardStudentStudyProgress(params: {
  studentId: string;
  pointsDelta: number;
}): Promise<{
  masteryPoints: number;
  weeklyPoints: number;
  streakDays: number;
  newlyEarnedBadges: StudentBadge[];
  rank: ScholarlyRank;
}> {
  const supabase = getSupabaseAdmin();
  const todayIst = getTodayIst();
  const weekStartIst = getIstWeekStart();

  const { data: student, error } = await supabase
    .from("students")
    .select(
      "mastery_points, weekly_points, streak_days, last_active_ist, week_start_ist, badges"
    )
    .eq("id", params.studentId)
    .single();

  if (error || !student) {
    throw new Error("Unable to load student profile for progress update.");
  }

  const prevStreak = student.streak_days ?? 0;
  let nextStreak = prevStreak;

  if (!student.last_active_ist) {
    nextStreak = 1;
  } else {
    const gap = diffIstDays(student.last_active_ist, todayIst);
    if (gap === 0) {
      nextStreak = Math.max(1, prevStreak);
    } else if (gap === 1) {
      nextStreak = prevStreak + 1;
    } else if (gap > 1) {
      nextStreak = 1;
    }
  }

  const sameWeek = student.week_start_ist === weekStartIst;
  const nextMastery = Math.max(0, (student.mastery_points ?? 0) + params.pointsDelta);
  const nextWeekly = sameWeek
    ? Math.max(0, (student.weekly_points ?? 0) + params.pointsDelta)
    : Math.max(0, params.pointsDelta);

  const existingBadges: StudentBadge[] = Array.isArray(student.badges)
    ? (student.badges as StudentBadge[])
    : [];
  const existingCodes = new Set(existingBadges.map((b) => b.code));
  const newlyEarnedBadges: StudentBadge[] = [];
  const nowIso = new Date().toISOString();

  const maybeAward = (code: string, title_hi: string, title_en: string, cond: boolean) => {
    if (cond && !existingCodes.has(code)) {
      const badge: StudentBadge = { code, title_hi, title_en, earned_at: nowIso };
      existingCodes.add(code);
      newlyEarnedBadges.push(badge);
    }
  };

  maybeAward("FIRST_STEP", "प्रथम कदम", "First Milestone", nextMastery >= 10);
  maybeAward("STREAK_3", "3-दिवस नियमितता", "3-Day Study Streak", nextStreak >= 3);
  maybeAward("STREAK_7", "सप्ताह साधक", "7-Day Study Streak", nextStreak >= 7);
  maybeAward("CENTURY_100", "शतक साधक", "100 Mastery Points", nextMastery >= 100);
  maybeAward("MERIT_300", "संकल्प रत्न", "300 Mastery Points", nextMastery >= 300);
  maybeAward("HONOURS_700", "विद्या भूषण", "700 Mastery Points", nextMastery >= 700);

  const mergedBadges = [...existingBadges, ...newlyEarnedBadges];

  await supabase
    .from("students")
    .update({
      mastery_points: nextMastery,
      weekly_points: nextWeekly,
      streak_days: nextStreak,
      last_active_ist: todayIst,
      week_start_ist: weekStartIst,
      badges: mergedBadges,
    })
    .eq("id", params.studentId);

  return {
    masteryPoints: nextMastery,
    weeklyPoints: nextWeekly,
    streakDays: nextStreak,
    newlyEarnedBadges,
    rank: getScholarlyRank(nextMastery),
  };
}
