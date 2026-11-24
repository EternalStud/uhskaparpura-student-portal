"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import {
  ArrowRight,
  Award,
  BookCheck,
  BookOpen,
  CheckCircle2,
  ClipboardCheck,
  Clock,
  Flame,
  Layers,
  Lock,
  Medal,
  RefreshCw,
  Sparkles,
  Target,
  TrendingUp,
  Trophy,
} from "lucide-react";
import type { FourStageProgressResult } from "@/lib/progress/four-stage";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Button, Card } from "@/components/ui";
import { FourStageProgressBar } from "./FourStageProgressBar";
import { SubjectIcon } from "./SubjectIcon";
import { cn } from "@/components/ui/cn";

interface SubjectSummaryItem {
  id: string;
  bseb_code: string;
  class_num: number;
  name_hi: string;
  name_en: string;
  icon_name: string;
  accent_color: string;
  slot_type: string;
  totalChapters: number;
  richNotesCount: number;
  completedChapters: number;
  playLabsCompleted?: number;
  totalInteractiveLabs?: number;
  avgMasteryPct: number;
  medals: { gold: number; silver: number; bronze: number };
}

interface DashboardResponse {
  student: {
    studentName: string;
    classNum: number;
    stream: string;
    rollNo: number;
    schoolName: string | null;
    masteryPoints: number;
    weeklyPoints: number;
    streakDays: number;
    rank: {
      level: number;
      title_hi: string;
      title_en: string;
      nextPoints: number | null;
    };
    totalMedals: { gold: number; silver: number; bronze: number };
  };
  dailyGoal: {
    completedQuestions: number;
    targetQuestions: number;
    progressPct: number;
    todayPoints: number;
    completed: boolean;
  };
  concreteStats?: {
    chaptersMastered: number;
    playLabsCompleted: number;
    wordsAndConceptsLearned: number;
    questionsMastered: number;
    notesCompletedCount: number;
  };
  continueChapter: {
    chapterId: string;
    chapterNo: number;
    titleHi: string;
    titleEn: string;
    subjectId: string;
    subjectNameHi: string;
    subjectNameEn: string;
    masteryPct: number;
    notesCompleted: boolean;
    playCompleted?: boolean;
    subjectiveCompleted?: boolean;
    fourStage?: FourStageProgressResult;
    hasRichNotes: boolean;
    estimatedMins: number;
  } | null;
  universalSkills?: SubjectSummaryItem[];
  subjects: SubjectSummaryItem[];
  revision: {
    totalCount: number;
    dueCount: number;
  };
  activeExamsCount: number;
  liveExamLock: {
    locked: boolean;
    examId?: string;
    examTitle?: string;
  };
  weeklySpotlight: Array<{
    rank: number;
    studentName: string;
    rollNo: number;
    weeklyPoints: number;
    streakDays: number;
    isCurrentStudent: boolean;
  }>;
}

export function StudentHomeClient() {
  const { t } = useLanguage();
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<DashboardResponse | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    async function load() {
      try {
        const res = await fetch("/api/student/dashboard", { cache: "no-store" });
        if (!res.ok) throw new Error("failed");
        const json = (await res.json()) as DashboardResponse;
        if (active) setData(json);
      } catch {
        if (active) {
          setError(
            t(
              "डैशबोर्ड लोड नहीं हो सका। कृपया पुनः प्रयास करें।",
              "Could not load your dashboard. Please retry."
            )
          );
        }
      } finally {
        if (active) setLoading(false);
      }
    }
    load();
    return () => {
      active = false;
    };
  }, [t]);

  if (loading) {
    return (
      <div className="space-y-5 animate-pulse">
        <div className="h-36 rounded-paper bg-surface-subtle" />
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="h-36 rounded-paper bg-surface-subtle" />
          <div className="h-36 rounded-paper bg-surface-subtle" />
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <div className="h-44 rounded-paper bg-surface-subtle" />
          <div className="h-44 rounded-paper bg-surface-subtle" />
          <div className="h-44 rounded-paper bg-surface-subtle" />
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <Card variant="warm" className="text-center py-8 space-y-3">
        <p className="text-sm font-semibold text-crimson-ink">{error}</p>
        <Button variant="secondary" onClick={() => window.location.reload()}>
          {t("पुनः प्रयास करें", "Retry")}
        </Button>
      </Card>
    );
  }

  const {
    student,
    dailyGoal,
    concreteStats,
    continueChapter,
    universalSkills = [],
    subjects,
    revision,
    activeExamsCount,
    liveExamLock,
    weeklySpotlight,
  } = data;

  return (
    <div className="space-y-6">
      {/* Live Exam Active Notice */}
      {liveExamLock.locked && liveExamLock.examId && (
        <Card variant="warm" className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-start gap-3">
            <span className="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-amber-soft text-amber-ink shrink-0">
              <Lock className="h-5 w-5" />
            </span>
            <div>
              <div className="font-bold text-sm sm:text-base text-ink">
                {t(
                  "आपकी लाइव कक्षा परीक्षा अभी चल रही है",
                  "Your Live Classroom Exam Is Currently Active"
                )}
              </div>
              <p className="text-xs sm:text-sm text-ink-secondary">
                {liveExamLock.examTitle ??
                  t(
                    "परीक्षा पूरी करने के लिए वापस जाएँ।",
                    "Return to complete and submit your exam."
                  )}
              </p>
            </div>
          </div>
          <Link href={`/student/exams/${liveExamLock.examId}`}>
            <Button variant="amber" rightIcon={<ArrowRight className="h-4 w-4" />}>
              {t("परीक्षा पर जाएँ", "Return to Exam")}
            </Button>
          </Link>
        </Card>
      )}

      {/* Calm Academic Welcome + Daily Habit Strip */}
      <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
        <div>
          <p className="text-xs font-bold uppercase tracking-wider text-indigo-ink">
            {t(
              `कक्षा ${student.classNum}${student.stream !== "NA" && student.stream !== "UNSET" ? ` · ${student.stream}` : ""} · रोल ${student.rollNo}`,
              `Class ${student.classNum}${student.stream !== "NA" && student.stream !== "UNSET" ? ` · ${student.stream}` : ""} · Roll ${student.rollNo}`
            )}
          </p>
          <h1 className="text-2xl sm:text-3xl font-bold text-ink mt-0.5 leading-tight">
            {t(`नमस्ते, ${student.studentName}`, `Namaste, ${student.studentName}`)}
          </h1>
          <div className="mt-2 flex flex-wrap items-center gap-2">
            <Badge variant="indigo" icon={<Award className="h-3.5 w-3.5" />}>
              <BiText hi={student.rank.title_hi} en={student.rank.title_en} inline />
            </Badge>
            <Badge variant="amber" icon={<Flame className="h-3.5 w-3.5" />}>
              {t(`${student.streakDays} दिन नियमितता`, `${student.streakDays}-Day Streak`)}
            </Badge>
            <Badge variant="emerald" icon={<Sparkles className="h-3.5 w-3.5" />}>
              {t(`${student.masteryPoints} अध्ययन अंक`, `${student.masteryPoints} Mastery Pts`)}
            </Badge>
          </div>
        </div>

        {/* Daily 5-Minute Goal Pill Card */}
        <Card padding="sm" className="min-w-[260px] lg:max-w-xs space-y-2">
          <div className="flex items-center justify-between gap-2 text-xs font-bold">
            <span className="text-ink flex items-center gap-1.5">
              <CheckCircle2
                className={cn(
                  "h-4 w-4",
                  dailyGoal.completed ? "text-emerald-ink" : "text-indigo-ink"
                )}
              />
              {t("आज का 5-मिनट लक्ष्य", "Today's 5-Min Goal")}
            </span>
            <span className="text-indigo-ink">
              {dailyGoal.completedQuestions} / {dailyGoal.targetQuestions}{" "}
              {t("प्रश्न", "Qs")}
            </span>
          </div>
          <div className="h-2.5 w-full rounded-full bg-surface-subtle overflow-hidden">
            <div
              className={cn(
                "h-full rounded-full transition-all duration-300",
                dailyGoal.completed ? "bg-emerald-mastery" : "bg-indigo-academic"
              )}
              style={{ width: `${dailyGoal.progressPct}%` }}
            />
          </div>
          <p className="text-xs text-ink-secondary">
            {dailyGoal.completed
              ? t("बहुत बढ़िया! आज का लक्ष्य पूरा हो गया।", "Well done! Daily study goal achieved.")
              : t(
                  "रोज़ सिर्फ़ 5 प्रश्न हल करें और बोर्ड परीक्षा की मजबूत नींव बनाएँ।",
                  "Solve just 5 questions daily to build rock-solid BSEB confidence."
                )}
          </p>
        </Card>
      </div>

      {/* Calm Concrete Progress Strip: "मेरी वास्तविक प्रगति (My Genuine Growth)" */}
      {concreteStats && (
        <Card padding="sm" className="space-y-3">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <div className="flex items-center gap-2">
              <span className="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-emerald-soft text-emerald-ink">
                <TrendingUp className="h-4 w-4" />
              </span>
              <div>
                <h2 className="text-sm font-bold text-ink">
                  <BiText hi="मेरी वास्तविक प्रगति" en="My Genuine Growth" inline />
                </h2>
                <p className="text-xs text-ink-muted">
                  {t(
                    "हर पूरा किया गया अध्याय, लैब और सीखा गया प्रश्न आपकी असली कमाई है",
                    "Every mastered chapter, interactive lab, and solved skill counts"
                  )}
                </p>
              </div>
            </div>
            {(student.totalMedals.gold > 0 ||
              student.totalMedals.silver > 0 ||
              student.totalMedals.bronze > 0) && (
              <div className="flex items-center gap-2 text-xs font-bold">
                <span className="inline-flex items-center gap-1 text-amber-ink">
                  <Medal className="h-3.5 w-3.5" /> {student.totalMedals.gold}
                </span>
                <span className="inline-flex items-center gap-1 text-indigo-ink">
                  <Medal className="h-3.5 w-3.5" /> {student.totalMedals.silver}
                </span>
                <span className="inline-flex items-center gap-1 text-emerald-ink">
                  <Medal className="h-3.5 w-3.5" /> {student.totalMedals.bronze}
                </span>
              </div>
            )}
          </div>

          <div className="grid grid-cols-2 lg:grid-cols-4 gap-2.5">
            <div className="rounded-lg border border-hairline bg-canvas px-3 py-2.5 flex items-center gap-2.5">
              <span className="inline-flex h-9 w-9 items-center justify-center rounded-md bg-indigo-soft text-indigo-ink shrink-0">
                <BookCheck className="h-4 w-4" />
              </span>
              <div className="min-w-0">
                <div className="text-lg font-extrabold text-ink leading-tight">
                  {concreteStats.chaptersMastered}
                </div>
                <div className="text-[11px] text-ink-secondary truncate">
                  {t("तैयार अध्याय", "Chapters Mastered")}
                </div>
              </div>
            </div>

            <div className="rounded-lg border border-hairline bg-canvas px-3 py-2.5 flex items-center gap-2.5">
              <span className="inline-flex h-9 w-9 items-center justify-center rounded-md bg-emerald-soft text-emerald-ink shrink-0">
                <Layers className="h-4 w-4" />
              </span>
              <div className="min-w-0">
                <div className="text-lg font-extrabold text-ink leading-tight">
                  {concreteStats.playLabsCompleted}
                </div>
                <div className="text-[11px] text-ink-secondary truncate">
                  {t("खेल लैब पूर्ण", "Play Labs Done")}
                </div>
              </div>
            </div>

            <div className="rounded-lg border border-hairline bg-canvas px-3 py-2.5 flex items-center gap-2.5">
              <span className="inline-flex h-9 w-9 items-center justify-center rounded-md bg-amber-soft text-amber-ink shrink-0">
                <Sparkles className="h-4 w-4" />
              </span>
              <div className="min-w-0">
                <div className="text-lg font-extrabold text-ink leading-tight">
                  {concreteStats.wordsAndConceptsLearned}
                </div>
                <div className="text-[11px] text-ink-secondary truncate">
                  {t("सीखे शब्द व नियम", "Words & Concepts")}
                </div>
              </div>
            </div>

            <div className="rounded-lg border border-hairline bg-canvas px-3 py-2.5 flex items-center gap-2.5">
              <span className="inline-flex h-9 w-9 items-center justify-center rounded-md bg-indigo-soft text-indigo-ink shrink-0">
                <Target className="h-4 w-4" />
              </span>
              <div className="min-w-0">
                <div className="text-lg font-extrabold text-ink leading-tight">
                  {concreteStats.questionsMastered}
                </div>
                <div className="text-[11px] text-ink-secondary truncate">
                  {t("सही हल प्रश्न", "Questions Mastered")}
                </div>
              </div>
            </div>
          </div>
        </Card>
      )}

      {/* Continue Where You Left Off Hero Card */}
      {continueChapter && (
        <Card
          variant="indigo"
          padding="lg"
          className="flex flex-col md:flex-row md:items-center justify-between gap-5"
        >
          <div className="space-y-2.5 max-w-2xl flex-1">
            <div className="flex flex-wrap items-center gap-2">
              <Badge variant="indigo" icon={<BookOpen className="h-3.5 w-3.5" />}>
                {t("जहाँ छोड़ा था, वहाँ से जारी रखें", "Continue Where You Left Off")}
              </Badge>
              <Badge variant="neutral">
                <BiText
                  hi={continueChapter.subjectNameHi}
                  en={continueChapter.subjectNameEn}
                  inline
                />
              </Badge>
              <Badge variant="amber" icon={<Clock className="h-3 w-3" />}>
                {t(`${continueChapter.estimatedMins} मिनट`, `${continueChapter.estimatedMins} min`)}
              </Badge>
            </div>
            <h2 className="text-xl sm:text-2xl font-bold text-ink leading-snug">
              {t(`अध्याय ${continueChapter.chapterNo}: `, `Ch ${continueChapter.chapterNo}: `)}
              <BiText hi={continueChapter.titleHi} en={continueChapter.titleEn} inline />
            </h2>
            {continueChapter.fourStage ? (
              <div className="max-w-lg pt-0.5">
                <FourStageProgressBar fourStage={continueChapter.fourStage} compact />
              </div>
            ) : (
              <div className="flex items-center gap-3 pt-1">
                <div className="flex-1 max-w-xs h-2 rounded-full bg-surface overflow-hidden border border-indigo-academic/15">
                  <div
                    className="h-full bg-emerald-mastery rounded-full"
                    style={{ width: `${continueChapter.masteryPct}%` }}
                  />
                </div>
                <span className="text-xs font-bold text-indigo-ink">
                  {continueChapter.masteryPct}% {t("तैयारी", "Mastery")}
                </span>
              </div>
            )}
          </div>

          <div className="flex flex-wrap items-center gap-2.5 shrink-0">
            <Link href={`/student/chapter/${continueChapter.chapterId}/notes`}>
              <Button variant="primary" size="lg" leftIcon={<BookOpen className="h-4 w-4" />}>
                {t("विज़ुअल नोट्स पढ़ें", "Read Visual Notes")}
              </Button>
            </Link>
            <Link href={`/student/chapter/${continueChapter.chapterId}/practice`}>
              <Button variant="secondary" size="lg" rightIcon={<ArrowRight className="h-4 w-4" />}>
                {t("खेल व अभ्यास", "Play & Practice")}
              </Button>
            </Link>
          </div>
        </Card>
      )}

      {/* Featured Universal Skill & Foundation Labs (Available to ALL Classes 9-12 on Day 1!) */}
      {universalSkills.length > 0 && (
        <section className="space-y-3.5">
          <div className="flex flex-wrap items-end justify-between gap-2">
            <div>
              <div className="flex items-center gap-2 mb-1">
                <Badge variant="emerald" icon={<Sparkles className="h-3 w-3" />}>
                  {t("कक्षा 9–12 सभी के लिए मुफ़्त व अनिवार्य कौशल", "Open to All Classes 9–12")}
                </Badge>
              </div>
              <h2 className="text-lg sm:text-xl font-bold text-ink">
                <BiText
                  hi="प्रमुख कौशल एवं नींव लैब (खेल-खेल में सीखें)"
                  en="Featured Skill & Foundation Labs (Learn by Playing)"
                />
              </h2>
              <p className="text-xs sm:text-sm text-ink-secondary">
                {t(
                  "कंप्यूटर शॉर्टकट, Excel सैंडबॉक्स, और शून्य से अंग्रेज़ी वाक्य निर्माण — बिना डर के रोज़ अभ्यास करें।",
                  "Master real computer shortcuts, Excel formulas, and fear-free English grammar through tactile play labs."
                )}
              </p>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {universalSkills.map((lab) => {
              const isIct = lab.id === "skill-ict-lab";
              return (
                <Link key={lab.id} href={`/student/subject/${lab.id}`} className="group block">
                  <Card
                    variant="interactive"
                    padding="lg"
                    className="h-full flex flex-col justify-between gap-4 border-indigo-academic/25"
                  >
                    <div className="space-y-3">
                      <div className="flex items-start justify-between gap-3">
                        <span
                          className="inline-flex h-12 w-12 items-center justify-center rounded-paper text-white shrink-0 shadow-paper"
                          style={{ backgroundColor: lab.accent_color }}
                        >
                          <SubjectIcon name={lab.icon_name} className="h-6 w-6" />
                        </span>
                        <div className="flex flex-wrap items-center justify-end gap-1.5">
                          <Badge variant="emerald">
                            {t(`${lab.totalChapters} अध्याय`, `${lab.totalChapters} Units`)}
                          </Badge>
                          {(lab.totalInteractiveLabs ?? 0) > 0 && (
                            <Badge variant="amber">
                              {t(
                                `${lab.totalInteractiveLabs} खेल लैब`,
                                `${lab.totalInteractiveLabs} Play Labs`
                              )}
                            </Badge>
                          )}
                        </div>
                      </div>

                      <div>
                        <h3 className="text-lg font-bold text-ink group-hover:text-indigo-ink transition-colors leading-snug">
                          <BiText hi={lab.name_hi} en={lab.name_en} />
                        </h3>
                        <p className="text-xs sm:text-sm text-ink-secondary mt-1 leading-relaxed">
                          {isIct
                            ? t(
                                "कीबोर्ड शॉर्टकट स्टूडियो, लाइव MS Excel सैंडबॉक्स, Word टूलबार पहचान और साइबर सुरक्षा अभ्यास।",
                                "Interactive Shortcut Studio, live MS Excel Sandbox, Word Ribbon Detective, and Cyber Safety missions."
                              )
                            : t(
                                "हिंदी से अंग्रेज़ी वाक्य निर्माण लैब, उच्चारण सहायता, टेंस टाइमलाइन और 20-अंक बोर्ड लेखन।",
                                "Hindi-to-English Sentence Builder, pronunciation audio guides, visual Tenses, and 20-mark writing templates."
                              )}
                        </p>
                      </div>
                    </div>

                    <div className="space-y-2.5 pt-3 border-t border-hairline">
                      <div className="flex items-center justify-between text-xs font-semibold">
                        <span className="text-ink-secondary">
                          {t(
                            `${lab.completedChapters}/${lab.totalChapters} अध्याय तैयार`,
                            `${lab.completedChapters}/${lab.totalChapters} units mastered`
                          )}
                        </span>
                        <span className="text-indigo-ink">{lab.avgMasteryPct}%</span>
                      </div>
                      <div className="h-2 w-full rounded-full bg-surface-subtle overflow-hidden">
                        <div
                          className="h-full rounded-full bg-emerald-mastery transition-all"
                          style={{ width: `${lab.avgMasteryPct}%` }}
                        />
                      </div>
                      <div className="flex items-center justify-between pt-0.5 text-xs font-bold text-indigo-ink">
                        <span>{t("लैब में प्रवेश करें", "Open Interactive Lab")}</span>
                        <ArrowRight className="h-4 w-4 group-hover:translate-x-0.5 transition-transform" />
                      </div>
                    </div>
                  </Card>
                </Link>
              );
            })}
          </div>
        </section>
      )}

      {/* Quick Action Strip: Revision Queue + Active Exams */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <Card
          variant="interactive"
          padding="sm"
          className="flex items-center justify-between gap-3"
        >
          <div className="flex items-center gap-3 min-w-0">
            <span className="inline-flex h-11 w-11 items-center justify-center rounded-lg bg-amber-soft text-amber-ink shrink-0">
              <RefreshCw className="h-5 w-5" />
            </span>
            <div className="min-w-0">
              <div className="font-bold text-sm text-ink">
                {t("दोहराव सूची (Revision Queue)", "Personal Revision Queue")}
              </div>
              <p className="text-xs text-ink-secondary truncate">
                {revision.totalCount > 0
                  ? t(
                      `${revision.dueCount} प्रश्न आज दोहराने के लिए तैयार (कुल ${revision.totalCount})`,
                      `${revision.dueCount} questions due today (${revision.totalCount} total)`
                    )
                  : t(
                      "अभी कोई छूटा हुआ प्रश्न नहीं — शाबाश!",
                      "No pending mistakes — great consistency!"
                    )}
              </p>
            </div>
          </div>
          {continueChapter && (
            <Link href={`/student/chapter/${continueChapter.chapterId}/practice?tab=revision`}>
              <Button size="sm" variant="secondary">
                {t("देखें", "Review")}
              </Button>
            </Link>
          )}
        </Card>

        <Card
          variant="interactive"
          padding="sm"
          className="flex items-center justify-between gap-3"
        >
          <div className="flex items-center gap-3 min-w-0">
            <span className="inline-flex h-11 w-11 items-center justify-center rounded-lg bg-indigo-soft text-indigo-ink shrink-0">
              <ClipboardCheck className="h-5 w-5" />
            </span>
            <div className="min-w-0">
              <div className="font-bold text-sm text-ink">
                {t("विद्यालय परीक्षा केंद्र", "School Exam Center")}
              </div>
              <p className="text-xs text-ink-secondary truncate">
                {activeExamsCount > 0
                  ? t(
                      `${activeExamsCount} सक्रिय परीक्षा उपलब्ध है`,
                      `${activeExamsCount} active exam(s) available`
                    )
                  : t(
                      "6-अंकों के रूम कोड से लाइव परीक्षा में जुड़ें",
                      "Join a live classroom test with a 6-digit room PIN"
                    )}
              </p>
            </div>
          </div>
          <Link href="/student/exams">
            <Button size="sm" variant="primary">
              {t("खोलें", "Open")}
            </Button>
          </Link>
        </Card>
      </div>

      {/* My BSEB Subjects Visual Journey Grid */}
      <section className="space-y-3.5">
        <div className="flex items-center justify-between gap-2">
          <div>
            <h2 className="text-lg sm:text-xl font-bold text-ink">
              <BiText hi="मेरे बिहार बोर्ड विषय (अध्याय यात्रा)" en="My BSEB Subjects (Chapter Journey)" />
            </h2>
            <p className="text-xs sm:text-sm text-ink-secondary">
              {t(
                "किसी भी विषय पर टैप करें और सरल विज़ुअल नोट्स व खेल-अभ्यास शुरू करें।",
                "Tap any subject to open its 4-stage chapter path, visual notes, and interactive practice."
              )}
            </p>
          </div>
          <Link href="/student/profile" className="text-xs font-semibold text-indigo-ink hover:underline">
            {t("विषय बदलें", "Edit Subjects")}
          </Link>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {subjects.map((sub) => (
            <Link key={sub.id} href={`/student/subject/${sub.id}`} className="group block">
              <Card
                variant="interactive"
                className="h-full flex flex-col justify-between gap-4"
              >
                <div className="space-y-3">
                  <div className="flex items-start justify-between gap-2">
                    <span
                      className="inline-flex h-11 w-11 items-center justify-center rounded-paper text-white shrink-0 shadow-paper"
                      style={{ backgroundColor: sub.accent_color }}
                    >
                      <SubjectIcon name={sub.icon_name} className="h-5 w-5" />
                    </span>
                    <div className="flex items-center gap-1.5">
                      {sub.richNotesCount > 0 && (
                        <Badge variant="emerald">
                          {t(`${sub.richNotesCount} विज़ुअल`, `${sub.richNotesCount} Visual`)}
                        </Badge>
                      )}
                      <Badge variant="neutral">{sub.bseb_code}</Badge>
                    </div>
                  </div>

                  <div>
                    <h3 className="text-base font-bold text-ink group-hover:text-indigo-ink transition-colors leading-snug">
                      <BiText hi={sub.name_hi} en={sub.name_en} />
                    </h3>
                    <p className="text-xs text-ink-secondary mt-1">
                      {t(
                        `${sub.totalChapters} अध्याय · ${sub.completedChapters} पूर्ण`,
                        `${sub.totalChapters} chapters · ${sub.completedChapters} mastered`
                      )}
                    </p>
                  </div>
                </div>

                <div className="space-y-2.5 pt-2 border-t border-hairline">
                  <div className="flex items-center justify-between text-xs font-semibold">
                    <span className="text-ink-secondary">{t("प्रगति", "Progress")}</span>
                    <span className="text-indigo-ink">{sub.avgMasteryPct}%</span>
                  </div>
                  <div className="h-2 w-full rounded-full bg-surface-subtle overflow-hidden">
                    <div
                      className="h-full rounded-full bg-indigo-academic transition-all"
                      style={{ width: `${sub.avgMasteryPct}%` }}
                    />
                  </div>
                  <div className="flex items-center justify-between text-xs text-ink-muted pt-0.5">
                    <span className="inline-flex items-center gap-2">
                      {sub.medals.gold > 0 && (
                        <span className="inline-flex items-center gap-0.5 text-amber-ink font-semibold">
                          <Medal className="h-3.5 w-3.5" /> {sub.medals.gold}
                        </span>
                      )}
                      {sub.medals.silver > 0 && (
                        <span className="inline-flex items-center gap-0.5 text-ink-secondary font-semibold">
                          <Medal className="h-3.5 w-3.5" /> {sub.medals.silver}
                        </span>
                      )}
                      {sub.medals.gold === 0 && sub.medals.silver === 0 && (
                        <span>{t("यात्रा शुरू करें", "Start journey")}</span>
                      )}
                    </span>
                    <ArrowRight className="h-4 w-4 text-ink-muted group-hover:text-indigo-ink group-hover:translate-x-0.5 transition-all" />
                  </div>
                </div>
              </Card>
            </Link>
          ))}
        </div>
      </section>

      {/* Weekly Class Spotlight (Warm, Positive Recognition Only) */}
      {weeklySpotlight.length > 0 && (
        <Card className="space-y-3.5">
          <div className="flex items-center justify-between gap-2">
            <div className="flex items-center gap-2.5">
              <span className="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-amber-soft text-amber-ink">
                <Trophy className="h-5 w-5" />
              </span>
              <div>
                <h2 className="text-base font-bold text-ink">
                  <BiText
                    hi={`साप्ताहिक कक्षा प्रतिभा (कक्षा ${student.classNum})`}
                    en={`Weekly Class Spotlight (Class ${student.classNum})`}
                  />
                </h2>
                <p className="text-xs text-ink-secondary">
                  {t(
                    "इस सप्ताह नियमित अध्ययन करने वाले आपके सहपाठी",
                    "Consistent learners in your school class this week"
                  )}
                </p>
              </div>
            </div>
          </div>

          <div className="divide-y divide-hairline rounded-lg border border-hairline overflow-hidden">
            {weeklySpotlight.map((peer) => (
              <div
                key={`${peer.rollNo}-${peer.rank}`}
                className={cn(
                  "flex items-center justify-between gap-3 px-4 py-2.5 text-sm",
                  peer.isCurrentStudent ? "bg-indigo-soft font-semibold" : "bg-surface"
                )}
              >
                <div className="flex items-center gap-3 min-w-0">
                  <span className="inline-flex h-7 w-7 items-center justify-center rounded-full bg-surface-subtle border border-hairline text-xs font-bold text-indigo-ink shrink-0">
                    #{peer.rank}
                  </span>
                  <div className="min-w-0">
                    <div className="text-ink truncate">
                      {peer.studentName}
                      {peer.isCurrentStudent && (
                        <span className="ml-1.5 text-xs font-bold text-indigo-ink">
                          ({t("आप", "You")})
                        </span>
                      )}
                    </div>
                    <div className="text-xs text-ink-muted">
                      {t(`रोल ${peer.rollNo}`, `Roll ${peer.rollNo}`)}
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-3 shrink-0">
                  <span className="text-xs text-amber-ink font-semibold inline-flex items-center gap-1">
                    <Flame className="h-3.5 w-3.5" /> {peer.streakDays}d
                  </span>
                  <Badge variant="emerald">{peer.weeklyPoints} pts</Badge>
                </div>
              </div>
            ))}
          </div>
        </Card>
      )}
    </div>
  );
}
