"use client";

import React, { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import {
  ArrowLeft,
  Award,
  BookOpen,
  CheckCircle2,
  ClipboardList,
  Flame,
  HelpCircle,
  History,
  Layers,
  Lightbulb,
  Lock,
  PenTool,
  RefreshCw,
  RotateCcw,
  Sparkles,
  Target,
  XCircle,
} from "lucide-react";
import type {
  ChapterRow,
  DifficultyTier,
  QuestionRow,
  SubjectRow,
} from "@/types/database";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import {
  Badge,
  Button,
  Card,
  MathMarkdown,
  ReadAloudButton,
  useToast,
} from "@/components/ui";
import {
  BilingualDiagramRenderer,
  type InteractiveDiagramHotspot,
} from "@/components/visual";
import { cn } from "@/components/ui/cn";

type EnrichedQuestion = QuestionRow & {
  mastery?: {
    attempts_count: number;
    correct_count: number;
    streak_correct: number;
  } | null;
  inRevisionQueue?: boolean;
};

interface PracticeApiResponse {
  locked?: boolean;
  examId?: string;
  examTitle?: string;
  error?: string;
  errorEn?: string;
  chapter?: ChapterRow;
  subject?: SubjectRow | null;
  buckets?: {
    flashcards: EnrichedQuestion[];
    matchPairs: EnrichedQuestion[];
    diagramLabels: EnrichedQuestion[];
    mcqs: EnrichedQuestion[];
    shortAnswers: EnrichedQuestion[];
    longAnswers: EnrichedQuestion[];
    pyqQuestions: EnrichedQuestion[];
    revisionQuestions: EnrichedQuestion[];
  };
  counts?: {
    total: number;
    visualPlay: number;
    mcqs: number;
    subjective: number;
    pyq: number;
    revision: number;
  };
}

interface OmrApiResponse {
  locked?: boolean;
  examId?: string;
  omr?: {
    totalQuestions: number;
    attemptLimit: number;
    questions: EnrichedQuestion[];
  };
}

type PracticeTab = "visual" | "mcq" | "subjective" | "pyq" | "omr" | "revision";

function newAttemptUuid(): string {
  if (typeof crypto !== "undefined" && typeof crypto.randomUUID === "function") {
    return crypto.randomUUID();
  }
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, (ch) => {
    const r = (Math.random() * 16) | 0;
    const v = ch === "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

export function PracticeHubClient({
  chapterId,
  initialTab,
}: {
  chapterId: string;
  initialTab?: string;
}) {
  const { lang, t } = useLanguage();
  const toast = useToast();

  const resolvedInitialTab: PracticeTab =
    initialTab === "visual" ||
    initialTab === "mcq" ||
    initialTab === "subjective" ||
    initialTab === "pyq" ||
    initialTab === "omr" ||
    initialTab === "revision"
      ? initialTab
      : "visual";

  const [tab, setTab] = useState<PracticeTab>(resolvedInitialTab);
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<PracticeApiResponse | null>(null);

  // Visual Play state
  const [flippedCards, setFlippedCards] = useState<Record<string, boolean>>({});
  const [masteredFlashcards, setMasteredFlashcards] = useState<Record<string, boolean>>({});
  const [matchSelectedLeft, setMatchSelectedLeft] = useState<Record<string, string | null>>({});
  const [matchAssignments, setMatchAssignments] = useState<Record<string, Record<string, string>>>({});
  const [matchChecked, setMatchChecked] = useState<Record<string, boolean>>({});
  const [activeHotspot, setActiveHotspot] = useState<Record<string, string | null>>({});
  const [diagramAnswers, setDiagramAnswers] = useState<Record<string, Record<string, string>>>({});
  const [diagramChecked, setDiagramChecked] = useState<Record<string, boolean>>({});

  // 3-Tier Objective Ladder state
  const [tierFilter, setTierFilter] = useState<"ALL" | DifficultyTier>("ALL");
  const [mcqSelected, setMcqSelected] = useState<Record<string, "A" | "B" | "C" | "D">>({});
  const [mcqGraded, setMcqGraded] = useState<
    Record<string, { isCorrect: boolean; correctOption: string | null }>
  >({});
  const [clueOpen, setClueOpen] = useState<Record<string, boolean>>({});
  const [narrowedOptions, setNarrowedOptions] = useState<Record<string, string[]>>({});
  const [focusStreak, setFocusStreak] = useState(0);

  // Subjective Coach state
  const [subjFilter, setSubjFilter] = useState<"ALL" | "SHORT_2M" | "LONG_5M">("ALL");
  const [openAnswers, setOpenAnswers] = useState<Record<string, boolean>>({});
  const [selfCheckState, setSelfCheckState] = useState<
    Record<string, "CONFIDENT" | "NEEDS_REVIEW">
  >({});

  // OMR 50% Simulator state
  const [omrLoading, setOmrLoading] = useState(false);
  const [omrData, setOmrData] = useState<OmrApiResponse["omr"] | null>(null);
  const [omrAnswers, setOmrAnswers] = useState<Record<string, "A" | "B" | "C" | "D">>({});
  const [omrSubmitted, setOmrSubmitted] = useState<{
    correct: number;
    attempted: number;
    attemptLimit: number;
    pointsAwarded: number;
    byQuestion: Record<string, { isCorrect: boolean; correctOption: string | null }>;
  } | null>(null);
  const [omrSubmitting, setOmrSubmitting] = useState(false);

  const loadPractice = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch(`/api/practice/${encodeURIComponent(chapterId)}`, {
        cache: "no-store",
      });
      const json = (await res.json()) as PracticeApiResponse;
      setData(json);
    } catch {
      setData({
        error: "अभ्यास प्रश्न लोड नहीं हो सके।",
        errorEn: "Unable to load practice questions.",
      });
    } finally {
      setLoading(false);
    }
  }, [chapterId]);

  useEffect(() => {
    loadPractice();
  }, [loadPractice]);

  // Lazy-load OMR 50% sheet when user switches to OMR tab
  useEffect(() => {
    if (tab !== "omr" || omrData || omrLoading) return;
    let active = true;
    setOmrLoading(true);
    fetch(`/api/practice/${encodeURIComponent(chapterId)}?mode=omr`, { cache: "no-store" })
      .then((r) => r.json())
      .then((json: OmrApiResponse) => {
        if (active && json.omr) {
          setOmrData(json.omr);
        }
      })
      .finally(() => {
        if (active) setOmrLoading(false);
      });
    return () => {
      active = false;
    };
  }, [tab, omrData, omrLoading, chapterId]);

  const submitSinglePractice = async (payload: {
    mode:
      | "FLASHCARD"
      | "MATCH_PAIRS"
      | "DIAGRAM_LABEL"
      | "MCQ_PRACTICE"
      | "SUBJECTIVE_SELF_CHECK"
      | "REVISION_DRILL";
    responses?: Array<{ questionId: string; selectedOption?: "A" | "B" | "C" | "D"; isCorrect?: boolean }>;
    selfChecks?: Array<{ questionId: string; status: "CONFIDENT" | "NEEDS_REVIEW" }>;
  }) => {
    const res = await fetch("/api/practice/submit", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        attemptId: newAttemptUuid(),
        chapterId,
        mode: payload.mode,
        responses: payload.responses ?? [],
        selfChecks: payload.selfChecks ?? [],
      }),
    });
    return (await res.json()) as {
      ok?: boolean;
      pointsAwarded?: number;
      correctCount?: number;
      results?: Array<{
        questionId: string;
        isCorrect: boolean;
        correctOption: string | null;
        resolvedFromRevision: boolean;
      }>;
      error?: string;
    };
  };

  const handleMcqChoose = async (
    q: EnrichedQuestion,
    optKey: "A" | "B" | "C" | "D",
    isRevision = false
  ) => {
    if (mcqGraded[q.id]) return;
    setMcqSelected((prev) => ({ ...prev, [q.id]: optKey }));

    const result = await submitSinglePractice({
      mode: isRevision ? "REVISION_DRILL" : "MCQ_PRACTICE",
      responses: [{ questionId: q.id, selectedOption: optKey }],
    });

    const graded = result.results?.[0];
    const isCorrect = graded ? graded.isCorrect : q.correct_option === optKey;
    const correctOption = graded ? graded.correctOption : q.correct_option;

    setMcqGraded((prev) => ({
      ...prev,
      [q.id]: { isCorrect, correctOption },
    }));

    if (isCorrect) {
      setFocusStreak((s) => s + 1);
      if (graded?.resolvedFromRevision) {
        toast.success(
          t("दोहराव पूरा हुआ!", "Mastered from Revision Queue!"),
          t("लगातार 2 सही उत्तर — यह प्रश्न अब आपकी दोहराव सूची से हल हो गया।", "2 consecutive correct answers — cleared from your revision queue.")
        );
      }
    } else {
      setFocusStreak(0);
    }
  };

  const handleNarrowChoices = (q: EnrichedQuestion) => {
    if (!q.options_json || !q.correct_option || narrowedOptions[q.id]) return;
    const wrongKeys = q.options_json
      .map((o) => o.key)
      .filter((k) => k !== q.correct_option);
    // Eliminate 2 distractors gently to help struggling students reason clearly
    setNarrowedOptions((prev) => ({
      ...prev,
      [q.id]: wrongKeys.slice(0, 2),
    }));
  };

  const handleSelfCheck = async (q: EnrichedQuestion, status: "CONFIDENT" | "NEEDS_REVIEW") => {
    setSelfCheckState((prev) => ({ ...prev, [q.id]: status }));
    const res = await submitSinglePractice({
      mode: "SUBJECTIVE_SELF_CHECK",
      selfChecks: [{ questionId: q.id, status }],
    });
    if (res.ok) {
      toast.info(
        status === "CONFIDENT"
          ? t("बहुत बढ़िया! तैयार चिह्नित किया गया", "Great! Marked as Confident")
          : t("दोहराव सूची में जोड़ा गया", "Added to Your Revision Queue"),
        status === "CONFIDENT"
          ? t(`+${res.pointsAwarded ?? 10} अध्ययन अंक`, `+${res.pointsAwarded ?? 10} mastery points`)
          : t("हम आपको कल इसे फिर से दोहराने की याद दिलाएँगे।", "We will remind you to revise this tomorrow.")
      );
    }
  };

  const handleOmrBubble = (qId: string, key: "A" | "B" | "C" | "D") => {
    if (omrSubmitted || !omrData) return;
    setOmrAnswers((prev) => {
      // Allow toggling off if tapping same bubble
      if (prev[qId] === key) {
        const copy = { ...prev };
        delete copy[qId];
        return copy;
      }
      // Enforce strict BSEB 50% attempt cap!
      const alreadyAnswered = qId in prev;
      const count = Object.keys(prev).length;
      if (!alreadyAnswered && count >= omrData.attemptLimit) {
        toast.warning(
          t(
            `बिहार बोर्ड 50% नियम: अधिकतम ${omrData.attemptLimit} प्रश्न चुनें`,
            `BSEB 50% Rule: Maximum ${omrData.attemptLimit} questions allowed`
          ),
          t(
            "कोई अन्य प्रश्न चुनने के लिए पहले किसी भरे हुए गोले पर दुबारा टैप कर हटाएँ।",
            "Tap an already filled bubble to unselect it before choosing another question."
          )
        );
        return prev;
      }
      return { ...prev, [qId]: key };
    });
  };

  const handleOmrSubmit = async () => {
    if (!omrData) return;
    const entries = Object.entries(omrAnswers);
    if (entries.length === 0) {
      toast.warning(t("कम से कम 1 गोला भरें", "Fill at least 1 OMR bubble first"));
      return;
    }
    setOmrSubmitting(true);
    try {
      const res = await submitSinglePractice({
        mode: "MCQ_PRACTICE",
        responses: entries.map(([questionId, selectedOption]) => ({
          questionId,
          selectedOption,
        })),
      });
      const byQuestion: Record<string, { isCorrect: boolean; correctOption: string | null }> = {};
      for (const r of res.results ?? []) {
        byQuestion[r.questionId] = { isCorrect: r.isCorrect, correctOption: r.correctOption };
      }
      setOmrSubmitted({
        correct: res.correctCount ?? 0,
        attempted: entries.length,
        attemptLimit: omrData.attemptLimit,
        pointsAwarded: res.pointsAwarded ?? 0,
        byQuestion,
      });
      toast.success(
        t("OMR शीट जाँची गई!", "OMR Sheet Evaluated!"),
        t(
          `आपने ${entries.length} में से ${res.correctCount ?? 0} सही उत्तर दिए (+${res.pointsAwarded ?? 0} अंक)।`,
          `You scored ${res.correctCount ?? 0} out of ${entries.length} attempted (+${res.pointsAwarded ?? 0} pts).`
        )
      );
    } finally {
      setOmrSubmitting(false);
    }
  };

  const filteredMcqs = useMemo(() => {
    const list = data?.buckets?.mcqs ?? [];
    if (tierFilter === "ALL") return list;
    return list.filter((q) => q.difficulty_tier === tierFilter);
  }, [data, tierFilter]);

  const filteredSubjectives = useMemo(() => {
    if (!data?.buckets) return [];
    const shortList = data.buckets.shortAnswers ?? [];
    const longList = data.buckets.longAnswers ?? [];
    if (subjFilter === "SHORT_2M") return shortList;
    if (subjFilter === "LONG_5M") return longList;
    return [...shortList, ...longList];
  }, [data, subjFilter]);

  if (loading) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="h-10 w-1/2 rounded-lg bg-surface-subtle" />
        <div className="h-14 rounded-paper bg-surface-subtle" />
        <div className="h-72 rounded-paper bg-surface-subtle" />
      </div>
    );
  }

  if (data?.locked) {
    return (
      <Card variant="warm" className="max-w-xl mx-auto text-center py-8 space-y-4">
        <div className="mx-auto inline-flex h-14 w-14 items-center justify-center rounded-full bg-amber-soft text-amber-ink">
          <Lock className="h-7 w-7" />
        </div>
        <h1 className="text-xl font-bold text-ink">
          {t("लाइव परीक्षा चल रही है", "Live Classroom Exam Active")}
        </h1>
        <p className="text-sm text-ink-secondary">
          {t(
            data.error ?? "लाइव परीक्षा पूरी होने तक अभ्यास लॉक है।",
            data.errorEn ?? "Practice is temporarily locked until your live exam finishes."
          )}
        </p>
        {data.examId && (
          <Link href={`/student/exams/${data.examId}`}>
            <Button variant="primary" size="lg">
              {t("लाइव परीक्षा पर वापस जाएँ", "Return to Live Exam")}
            </Button>
          </Link>
        )}
      </Card>
    );
  }

  if (!data?.chapter || !data.buckets) {
    return (
      <Card className="max-w-xl mx-auto text-center py-8 space-y-3">
        <p className="text-sm font-semibold text-crimson-ink">
          {t(data?.error ?? "अभ्यास लोड नहीं हो सका।", data?.errorEn ?? "Unable to load practice hub.")}
        </p>
        <Link href="/student">
          <Button variant="secondary" leftIcon={<ArrowLeft className="h-4 w-4" />}>
            {t("पढ़ाई होम पर जाएँ", "Back to Study Home")}
          </Button>
        </Link>
      </Card>
    );
  }

  const { chapter, subject, buckets, counts } = data;

  const tabs: Array<{
    id: PracticeTab;
    hi: string;
    en: string;
    icon: React.ReactNode;
    count?: number;
  }> = [
    { id: "visual", hi: "विज़ुअल लैब", en: "Visual Play", icon: <Layers className="h-4 w-4" />, count: counts?.visualPlay },
    { id: "mcq", hi: "ऑब्जेक्टिव सीढ़ी", en: "3-Tier MCQ", icon: <Target className="h-4 w-4" />, count: counts?.mcqs },
    { id: "subjective", hi: "2M / 5M उत्तर कोच", en: "2M & 5M Coach", icon: <PenTool className="h-4 w-4" />, count: counts?.subjective },
    { id: "pyq", hi: "विगत वर्ष (PYQ)", en: "BSEB PYQs", icon: <History className="h-4 w-4" />, count: counts?.pyq },
    { id: "omr", hi: "OMR 50% बोर्ड", en: "OMR Simulator", icon: <ClipboardList className="h-4 w-4" /> },
    { id: "revision", hi: "दोहराव सूची", en: "Revision Queue", icon: <RefreshCw className="h-4 w-4" />, count: counts?.revision },
  ];

  const renderMcqCard = (q: EnrichedQuestion, index: number, isRevision = false) => {
    const selected = mcqSelected[q.id];
    const graded = mcqGraded[q.id];
    const eliminated = narrowedOptions[q.id] ?? [];

    return (
      <Card key={q.id} className="space-y-4">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <div className="flex flex-wrap items-center gap-1.5">
            <Badge variant="neutral">Q{index + 1}</Badge>
            <Badge
              variant={
                q.difficulty_tier === "FOUNDATION"
                  ? "emerald"
                  : q.difficulty_tier === "BOARD"
                  ? "indigo"
                  : "amber"
              }
            >
              {q.difficulty_tier === "FOUNDATION"
                ? t("बुनियादी समझ", "Foundation")
                : q.difficulty_tier === "BOARD"
                ? t("बोर्ड स्तर", "Board")
                : t("टॉपर", "Topper")}
            </Badge>
            {q.exam_year_tag && <Badge variant="amber">{q.exam_year_tag}</Badge>}
          </div>

          <div className="flex items-center gap-1.5">
            {!graded && (q.clue_hi || q.clue_en) && (
              <Button
                size="sm"
                variant="ghost"
                onClick={() => setClueOpen((p) => ({ ...p, [q.id]: !p[q.id] }))}
                leftIcon={<Lightbulb className="h-3.5 w-3.5 text-amber-ink" />}
              >
                {t("संकेत", "Clue")}
              </Button>
            )}
            {!graded && q.options_json && q.options_json.length === 4 && !narrowedOptions[q.id] && (
              <Button
                size="sm"
                variant="ghost"
                onClick={() => handleNarrowChoices(q)}
                leftIcon={<HelpCircle className="h-3.5 w-3.5 text-indigo-ink" />}
              >
                50-50
              </Button>
            )}
            <ReadAloudButton textHi={q.q_hi} textEn={q.q_en} size="sm" />
          </div>
        </div>

        <div className="text-base font-semibold text-ink leading-relaxed">
          {lang === "BOTH" ? (
            <div className="space-y-1.5">
              <MathMarkdown content={q.q_hi} />
              <div className="text-sm text-ink-secondary font-normal">
                <MathMarkdown content={q.q_en} />
              </div>
            </div>
          ) : (
            <MathMarkdown content={lang === "EN" ? q.q_en : q.q_hi} />
          )}
        </div>

        {clueOpen[q.id] && (q.clue_hi || q.clue_en) && (
          <div className="rounded-lg border border-amber-warm/30 bg-surface-warm px-3.5 py-2.5 text-xs sm:text-sm text-amber-ink">
            <strong className="mr-1.5">{t("संकेत:", "Concept Clue:")}</strong>
            <MathMarkdown
              inline
              content={lang === "EN" ? q.clue_en ?? q.clue_hi ?? "" : q.clue_hi ?? q.clue_en ?? ""}
            />
          </div>
        )}

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
          {(q.options_json ?? []).map((opt) => {
            const isEliminated = eliminated.includes(opt.key) && !graded;
            const isPicked = selected === opt.key;
            const isRight = graded?.correctOption === opt.key;
            const isWrongPick = graded && isPicked && !graded.isCorrect;

            return (
              <button
                key={opt.key}
                type="button"
                disabled={Boolean(graded) || isEliminated}
                onClick={() => handleMcqChoose(q, opt.key, isRevision)}
                className={cn(
                  "flex items-start gap-3 rounded-lg border px-3.5 py-3 text-left transition-all min-h-[52px]",
                  isEliminated && "opacity-30 line-through cursor-not-allowed bg-surface-subtle",
                  !graded && !isEliminated && "border-hairline bg-surface hover:bg-indigo-soft hover:border-indigo-academic/40",
                  isRight && "border-emerald-mastery bg-emerald-soft text-emerald-ink ring-2 ring-emerald-mastery/20",
                  isWrongPick && "border-crimson-alert bg-crimson-soft text-crimson-ink"
                )}
              >
                <span
                  className={cn(
                    "inline-flex h-7 w-7 items-center justify-center rounded-full border text-xs font-bold shrink-0 mt-0.5",
                    isRight
                      ? "bg-emerald-mastery border-emerald-mastery text-white"
                      : isWrongPick
                      ? "bg-crimson-alert border-crimson-alert text-white"
                      : "bg-surface-subtle border-hairline-strong text-ink"
                  )}
                >
                  {opt.key}
                </span>
                <span className="text-sm font-medium leading-snug">
                  <BiText hi={opt.text_hi} en={opt.text_en} />
                </span>
              </button>
            );
          })}
        </div>

        {/* Encouraging Explanation Feedback */}
        {graded && (
          <div
            className={cn(
              "rounded-paper border p-4 space-y-2",
              graded.isCorrect
                ? "border-emerald-mastery/30 bg-emerald-soft"
                : "border-amber-warm/35 bg-surface-warm"
            )}
          >
            <div className="flex items-center gap-2 font-bold text-sm">
              {graded.isCorrect ? (
                <>
                  <CheckCircle2 className="h-4 w-4 text-emerald-ink shrink-0" />
                  <span className="text-emerald-ink">
                    {t("शाबाश! बिल्कुल सही उत्तर (+10 अंक)", "Well done! Correct answer (+10 pts)")}
                  </span>
                </>
              ) : (
                <>
                  <Lightbulb className="h-4 w-4 text-amber-ink shrink-0" />
                  <span className="text-amber-ink">
                    {t(
                      "कोई बात नहीं, आइए इसे सरल तरीके से समझें (दोहराव सूची में जोड़ा गया)",
                      "No worries — let's understand why (added to your revision queue)"
                    )}
                  </span>
                </>
              )}
            </div>
            {(q.explanation_hi || q.explanation_en) && (
              <div className="text-sm text-ink leading-relaxed">
                <MathMarkdown
                  content={
                    lang === "EN"
                      ? q.explanation_en ?? q.explanation_hi ?? ""
                      : lang === "HI"
                      ? q.explanation_hi ?? q.explanation_en ?? ""
                      : `${q.explanation_hi ?? ""}\n\n${q.explanation_en ?? ""}`
                  }
                />
              </div>
            )}
          </div>
        )}
      </Card>
    );
  };

  return (
    <div className="space-y-6 pb-12">
      {/* Header & Navigation */}
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <Link
            href={subject ? `/student/subject/${subject.id}` : "/student"}
            className="inline-flex items-center gap-1.5 text-sm font-semibold text-indigo-ink hover:underline"
          >
            <ArrowLeft className="h-4 w-4" />
            <span>
              {subject ? (
                <BiText hi={subject.name_hi} en={subject.name_en} inline />
              ) : (
                t("विषय", "Subject")
              )}
            </span>
          </Link>
        </div>

        <div className="flex items-center gap-2">
          {focusStreak >= 2 && (
            <Badge variant="amber" icon={<Flame className="h-3.5 w-3.5" />}>
              {t(`${focusStreak} लगातार सही!`, `${focusStreak} in a row!`)}
            </Badge>
          )}
          <Link href={`/student/chapter/${chapter.id}/notes`}>
            <Button size="sm" variant="secondary" leftIcon={<BookOpen className="h-4 w-4" />}>
              {t("विज़ुअल नोट्स देखें", "Read Visual Notes")}
            </Button>
          </Link>
        </div>
      </div>

      {/* Chapter Title */}
      <div className="space-y-1">
        <Badge variant="indigo">
          {t(`अध्याय ${chapter.chapter_no} · 6-मोड वन-स्टॉप अभ्यास`, `Ch ${chapter.chapter_no} · 6-Mode One-Stop Practice`)}
        </Badge>
        <h1 className="text-2xl sm:text-3xl font-bold text-ink leading-tight">
          <BiText hi={chapter.title_hi} en={chapter.title_en} />
        </h1>
      </div>

      {/* 6-Mode Navigation Pills */}
      <div
        role="tablist"
        aria-label="Practice modes"
        className="flex gap-2 overflow-x-auto pb-1 no-scrollbar"
      >
        {tabs.map((item) => {
          const active = tab === item.id;
          return (
            <button
              key={item.id}
              type="button"
              role="tab"
              aria-selected={active}
              onClick={() => setTab(item.id)}
              className={cn(
                "inline-flex items-center gap-2 rounded-paper border px-3.5 py-2.5 text-sm font-semibold whitespace-nowrap transition-all min-h-[44px]",
                active
                  ? "bg-indigo-academic text-white border-indigo-academic shadow-paper"
                  : "bg-surface text-ink-secondary border-hairline hover:bg-surface-subtle hover:text-ink"
              )}
            >
              {item.icon}
              <span>{t(item.hi, item.en)}</span>
              {typeof item.count === "number" && (
                <span
                  className={cn(
                    "rounded-full px-1.5 py-0.5 text-[11px] font-bold",
                    active ? "bg-white/20 text-white" : "bg-surface-subtle text-ink-secondary"
                  )}
                >
                  {item.count}
                </span>
              )}
            </button>
          );
        })}
      </div>

      {/* ==================== TAB 1: VISUAL PLAY LAB ==================== */}
      {tab === "visual" && (
        <div className="space-y-6">
          {/* 1A. 3D Flip Flashcards */}
          {buckets.flashcards.length > 0 && (
            <section className="space-y-3">
              <h2 className="text-lg font-bold text-ink flex items-center gap-2">
                <Sparkles className="h-5 w-5 text-amber-ink" />
                {t("फ्लैशकार्ड (उत्तर देखने के लिए कार्ड पर टैप करें)", "Flip Flashcards (Tap Card to Reveal Answer)")}
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {buckets.flashcards.map((q) => {
                  const asset = q.visual_asset_json;
                  if (!asset || asset.kind !== "FLASHCARD") return null;
                  const flipped = Boolean(flippedCards[q.id]);
                  const mastered = Boolean(masteredFlashcards[q.id]);

                  return (
                    <Card
                      key={q.id}
                      variant={flipped ? "indigo" : "interactive"}
                      className="flex flex-col justify-between gap-4 min-h-[210px]"
                    >
                      <button
                        type="button"
                        onClick={() =>
                          setFlippedCards((p) => ({ ...p, [q.id]: !p[q.id] }))
                        }
                        className="text-left space-y-3 flex-1"
                      >
                        <div className="flex items-center justify-between gap-2">
                          <Badge variant={flipped ? "emerald" : "indigo"}>
                            {flipped ? t("उत्तर / सूत्र", "Answer") : t("प्रश्न (टैप करें)", "Question (Tap to Flip)")}
                          </Badge>
                          {q.exam_year_tag && <Badge variant="amber">{q.exam_year_tag}</Badge>}
                        </div>

                        {!flipped ? (
                          <div className="text-base font-bold text-ink leading-relaxed pt-1">
                            <BiText hi={asset.front_hi} en={asset.front_en} />
                          </div>
                        ) : (
                          <div className="space-y-2.5 pt-1">
                            <div className="text-sm sm:text-[15px] text-ink leading-relaxed font-medium">
                              <BiText hi={asset.back_hi} en={asset.back_en} />
                            </div>
                            {asset.formula_latex && (
                              <div className="rounded-lg bg-surface border border-hairline px-3 py-2 text-center overflow-x-auto">
                                <MathMarkdown content={`$$${asset.formula_latex}$$`} />
                              </div>
                            )}
                            {(asset.mnemonic_hi || asset.mnemonic_en) && (
                              <div className="rounded-lg bg-surface-warm border border-amber-warm/30 px-3 py-2 text-xs text-amber-ink font-semibold">
                                <BiText hi={asset.mnemonic_hi ?? ""} en={asset.mnemonic_en ?? ""} />
                              </div>
                            )}
                          </div>
                        )}
                      </button>

                      <div className="flex items-center justify-between gap-2 pt-2 border-t border-hairline">
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() =>
                            setFlippedCards((p) => ({ ...p, [q.id]: !p[q.id] }))
                          }
                          leftIcon={<RotateCcw className="h-3.5 w-3.5" />}
                        >
                          {flipped ? t("प्रश्न देखें", "Show Front") : t("कार्ड पलटें", "Flip Card")}
                        </Button>
                        <Button
                          size="sm"
                          variant={mastered ? "emerald" : "secondary"}
                          disabled={mastered}
                          onClick={async () => {
                            setMasteredFlashcards((p) => ({ ...p, [q.id]: true }));
                            const res = await submitSinglePractice({
                              mode: "FLASHCARD",
                              responses: [{ questionId: q.id, isCorrect: true }],
                            });
                            if (res.ok) {
                              toast.success(
                                t("याद हो गया!", "Flashcard Mastered!"),
                                t(`+${res.pointsAwarded ?? 10} अध्ययन अंक`, `+${res.pointsAwarded ?? 10} pts`)
                              );
                            }
                          }}
                          leftIcon={<CheckCircle2 className="h-3.5 w-3.5" />}
                        >
                          {mastered ? t("याद हो गया", "Mastered") : t("याद हो गया", "Got It!")}
                        </Button>
                      </div>
                    </Card>
                  );
                })}
              </div>
            </section>
          )}

          {/* 1B. Interactive Tap-to-Match Pairs */}
          {buckets.matchPairs.map((q) => {
            const asset = q.visual_asset_json;
            if (!asset || asset.kind !== "MATCH_PAIRS") return null;

            const currentLeft = matchSelectedLeft[q.id] ?? null;
            const pairsMap = matchAssignments[q.id] ?? {};
            const isChecked = Boolean(matchChecked[q.id]);

            // Stable deterministic shuffle for right column
            const rightItems = [...asset.pairs].reverse();

            const allMatched = Object.keys(pairsMap).length === asset.pairs.length;
            const correctMatches = asset.pairs.filter((p) => pairsMap[p.id] === p.id).length;

            return (
              <Card key={q.id} padding="lg" className="space-y-4">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <div>
                    <Badge variant="amber" className="mb-1">
                      {t("जोड़ी मिलाएँ (Tap to Match)", "Tap-to-Match Pairs")}
                    </Badge>
                    <h3 className="text-base font-bold text-ink">
                      <BiText hi={q.q_hi} en={q.q_en} />
                    </h3>
                  </div>
                  <Button
                    size="sm"
                    variant="ghost"
                    onClick={() => {
                      setMatchAssignments((p) => ({ ...p, [q.id]: {} }));
                      setMatchChecked((p) => ({ ...p, [q.id]: false }));
                      setMatchSelectedLeft((p) => ({ ...p, [q.id]: null }));
                    }}
                    leftIcon={<RotateCcw className="h-3.5 w-3.5" />}
                  >
                    {t("रीसेट", "Reset")}
                  </Button>
                </div>

                <p className="text-xs text-ink-secondary">
                  {t(
                    "पहले बाएँ स्तंभ से एक विकल्प टैप करें, फिर दाएँ स्तंभ से उसका सही मिलान चुनें।",
                    "Tap an item on the left column, then tap its matching partner on the right column."
                  )}
                </p>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  <div className="space-y-2">
                    {asset.pairs.map((pair, idx) => {
                      const assignedRightId = pairsMap[pair.id];
                      const active = currentLeft === pair.id;
                      const correct = isChecked && assignedRightId === pair.id;
                      const wrong = isChecked && assignedRightId !== pair.id;
                      return (
                        <button
                          key={pair.id}
                          type="button"
                          disabled={isChecked}
                          onClick={() =>
                            setMatchSelectedLeft((p) => ({ ...p, [q.id]: pair.id }))
                          }
                          className={cn(
                            "w-full flex items-center justify-between gap-2 rounded-lg border px-3.5 py-3 text-left text-sm font-semibold transition-all",
                            active && "border-indigo-academic bg-indigo-soft ring-2 ring-indigo-academic/25",
                            !active && assignedRightId && !isChecked && "border-amber-warm/50 bg-surface-warm",
                            !active && !assignedRightId && "border-hairline bg-surface hover:bg-surface-subtle",
                            correct && "border-emerald-mastery bg-emerald-soft text-emerald-ink",
                            wrong && "border-crimson-alert bg-crimson-soft text-crimson-ink"
                          )}
                        >
                          <span className="flex items-center gap-2">
                            <span className="inline-flex h-6 w-6 items-center justify-center rounded-full bg-surface-subtle text-xs font-bold text-indigo-ink border border-hairline shrink-0">
                              {idx + 1}
                            </span>
                            <BiText hi={pair.left_hi} en={pair.left_en} />
                          </span>
                          {assignedRightId && (
                            <Badge variant={correct ? "emerald" : wrong ? "crimson" : "amber"}>
                              → {rightItems.findIndex((r) => r.id === assignedRightId) + 1}
                            </Badge>
                          )}
                        </button>
                      );
                    })}
                  </div>

                  <div className="space-y-2">
                    {rightItems.map((pair, rIdx) => {
                      const linkedLeftId = Object.entries(pairsMap).find(
                        ([, rId]) => rId === pair.id
                      )?.[0];
                      return (
                        <button
                          key={pair.id}
                          type="button"
                          disabled={isChecked || !currentLeft}
                          onClick={() => {
                            if (!currentLeft) return;
                            setMatchAssignments((p) => ({
                              ...p,
                              [q.id]: { ...(p[q.id] ?? {}), [currentLeft]: pair.id },
                            }));
                            setMatchSelectedLeft((p) => ({ ...p, [q.id]: null }));
                          }}
                          className={cn(
                            "w-full flex items-center justify-between gap-2 rounded-lg border px-3.5 py-3 text-left text-sm transition-all",
                            linkedLeftId
                              ? "border-indigo-academic/40 bg-indigo-soft font-semibold text-ink"
                              : currentLeft
                              ? "border-indigo-academic/30 bg-surface hover:bg-indigo-soft cursor-pointer"
                              : "border-hairline bg-surface-subtle/60 text-ink-secondary"
                          )}
                        >
                          <span className="flex items-center gap-2">
                            <span className="inline-flex h-6 w-6 items-center justify-center rounded-md bg-surface text-xs font-bold text-ink-secondary border border-hairline shrink-0">
                              {rIdx + 1}
                            </span>
                            <BiText hi={pair.right_hi} en={pair.right_en} />
                          </span>
                        </button>
                      );
                    })}
                  </div>
                </div>

                <div className="flex flex-wrap items-center justify-between gap-3 pt-2 border-t border-hairline">
                  {isChecked ? (
                    <div className="text-sm font-bold text-indigo-ink">
                      {t(
                        `${asset.pairs.length} में से ${correctMatches} जोड़े सही मिले!`,
                        `${correctMatches} of ${asset.pairs.length} pairs matched accurately!`
                      )}
                    </div>
                  ) : (
                    <span className="text-xs text-ink-muted">
                      {Object.keys(pairsMap).length} / {asset.pairs.length} {t("मिलाए गए", "paired")}
                    </span>
                  )}

                  {!isChecked && (
                    <Button
                      variant="primary"
                      disabled={!allMatched}
                      onClick={async () => {
                        setMatchChecked((p) => ({ ...p, [q.id]: true }));
                        const allRight = correctMatches === asset.pairs.length;
                        const res = await submitSinglePractice({
                          mode: "MATCH_PAIRS",
                          responses: [{ questionId: q.id, isCorrect: allRight }],
                        });
                        if (res.ok) {
                          toast.success(
                            allRight
                              ? t("सभी जोड़े बिल्कुल सही!", "All pairs matched perfectly!")
                              : t("मिलान जाँचा गया!", "Matches checked!"),
                            t(`+${res.pointsAwarded ?? 0} अंक`, `+${res.pointsAwarded ?? 0} pts`)
                          );
                        }
                      }}
                    >
                      {t("मिलान जाँचें", "Check Matches")}
                    </Button>
                  )}
                </div>
              </Card>
            );
          })}

          {/* 1C. Interactive Tap-to-Label SVG Diagrams */}
          {buckets.diagramLabels.map((q) => {
            const asset = q.visual_asset_json;
            if (!asset || asset.kind !== "DIAGRAM_LABEL") return null;

            const selectedSpotId = activeHotspot[q.id] ?? asset.hotspots[0]?.id ?? null;
            const picks = diagramAnswers[q.id] ?? {};
            const checked = Boolean(diagramChecked[q.id]);

            const hotspotsForSvg: InteractiveDiagramHotspot[] = asset.hotspots.map((h) => {
              const chosen = picks[h.id];
              const isCorrect =
                chosen === h.answer_hi || chosen === h.answer_en;
              return {
                id: h.id,
                x: h.x,
                y: h.y,
                label_code: h.label_code,
                assignedLabel: chosen,
                state: checked
                  ? isCorrect
                    ? "correct"
                    : "wrong"
                  : selectedSpotId === h.id
                  ? "active"
                  : "idle",
              };
            });

            const activeSpotObj = asset.hotspots.find((h) => h.id === selectedSpotId);
            const allPicked = asset.hotspots.every((h) => Boolean(picks[h.id]));

            return (
              <Card key={q.id} padding="lg" className="space-y-4">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <div>
                    <Badge variant="indigo" className="mb-1">
                      {t("चित्र नामांकन अभ्यास", "Interactive Diagram Labeling")}
                    </Badge>
                    <h3 className="text-base font-bold text-ink">
                      <MathMarkdown
                        inline
                        content={lang === "EN" ? q.q_en : q.q_hi}
                      />
                    </h3>
                  </div>
                  <Button
                    size="sm"
                    variant="ghost"
                    onClick={() => {
                      setDiagramAnswers((p) => ({ ...p, [q.id]: {} }));
                      setDiagramChecked((p) => ({ ...p, [q.id]: false }));
                    }}
                    leftIcon={<RotateCcw className="h-3.5 w-3.5" />}
                  >
                    {t("रीसेट", "Reset")}
                  </Button>
                </div>

                <BilingualDiagramRenderer
                  spec={asset.diagram}
                  hotspots={hotspotsForSvg}
                  onHotspotClick={(spotId) =>
                    setActiveHotspot((p) => ({ ...p, [q.id]: spotId }))
                  }
                  compact
                />

                {/* Numbered Pin Selector & Choices */}
                <div className="space-y-3">
                  <div className="flex flex-wrap gap-2">
                    {asset.hotspots.map((h) => (
                      <button
                        key={h.id}
                        type="button"
                        onClick={() =>
                          setActiveHotspot((p) => ({ ...p, [q.id]: h.id }))
                        }
                        className={cn(
                          "inline-flex items-center gap-1.5 rounded-lg border px-3 py-2 text-xs sm:text-sm font-semibold",
                          selectedSpotId === h.id
                            ? "border-amber-warm bg-amber-soft text-amber-ink"
                            : "border-hairline bg-surface text-ink-secondary"
                        )}
                      >
                        <span>({h.label_code})</span>
                        <span>{picks[h.id] ?? t("चुनें...", "Pick...")}</span>
                      </button>
                    ))}
                  </div>

                  {activeSpotObj && !checked && (
                    <div className="rounded-lg border border-hairline bg-surface-subtle p-3.5 space-y-2">
                      <div className="text-xs font-bold text-ink-secondary">
                        {t(
                          `बिंदु (${activeSpotObj.label_code}) के लिए सही नाम चुनें:`,
                          `Choose the correct label for point (${activeSpotObj.label_code}):`
                        )}
                      </div>
                      <div className="flex flex-wrap gap-2">
                        {activeSpotObj.options_hi.map((optHi, idx) => {
                          const optEn = activeSpotObj.options_en[idx] ?? optHi;
                          const display = lang === "EN" ? optEn : optHi;
                          const isChosen =
                            picks[activeSpotObj.id] === optHi ||
                            picks[activeSpotObj.id] === optEn;
                          return (
                            <button
                              key={idx}
                              type="button"
                              onClick={() =>
                                setDiagramAnswers((p) => ({
                                  ...p,
                                  [q.id]: { ...(p[q.id] ?? {}), [activeSpotObj.id]: optHi },
                                }))
                              }
                              className={cn(
                                "rounded-lg border px-3.5 py-2 text-sm font-semibold transition-all",
                                isChosen
                                  ? "border-indigo-academic bg-indigo-academic text-white"
                                  : "border-hairline bg-surface text-ink hover:bg-indigo-soft"
                              )}
                            >
                              {display}
                            </button>
                          );
                        })}
                      </div>
                    </div>
                  )}

                  {!checked ? (
                    <Button
                      variant="primary"
                      disabled={!allPicked}
                      onClick={async () => {
                        setDiagramChecked((p) => ({ ...p, [q.id]: true }));
                        const allCorrect = asset.hotspots.every(
                          (h) => picks[h.id] === h.answer_hi || picks[h.id] === h.answer_en
                        );
                        const res = await submitSinglePractice({
                          mode: "DIAGRAM_LABEL",
                          responses: [{ questionId: q.id, isCorrect: allCorrect }],
                        });
                        if (res.ok) {
                          toast.success(
                            allCorrect
                              ? t("संपूर्ण चित्र नामांकन बिल्कुल सही!", "Every diagram point labeled accurately!")
                              : t("उत्तर जाँचे गए — नीचे सही नाम देखें", "Checked — review the correct labels below"),
                            t(`+${res.pointsAwarded ?? 0} अंक`, `+${res.pointsAwarded ?? 0} pts`)
                          );
                        }
                      }}
                    >
                      {t("नामांकन जाँचें", "Verify Labels")}
                    </Button>
                  ) : (
                    <div className="rounded-lg border border-emerald-mastery/30 bg-emerald-soft p-3.5 text-sm space-y-1">
                      <div className="font-bold text-emerald-ink">
                        {t("सही उत्तर:", "Correct Labels:")}
                      </div>
                      {asset.hotspots.map((h) => (
                        <div key={h.id} className="text-ink-secondary">
                          <strong>({h.label_code}):</strong>{" "}
                          <BiText hi={h.answer_hi} en={h.answer_en} inline />
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </Card>
            );
          })}

          {buckets.flashcards.length === 0 &&
            buckets.matchPairs.length === 0 &&
            buckets.diagramLabels.length === 0 && (
              <Card className="text-center py-8 text-sm text-ink-secondary">
                {t(
                  "इस अध्याय के विज़ुअल अभ्यास जल्द जोड़े जा रहे हैं। कृपया ऑब्जेक्टिव या उत्तर लेखन टैब देखें।",
                  "Visual play cards for this chapter are coming soon. Explore the MCQ or Subjective tabs!"
                )}
              </Card>
            )}
        </div>
      )}

      {/* ==================== TAB 2: 3-TIER OBJECTIVE LADDER ==================== */}
      {tab === "mcq" && (
        <div className="space-y-4">
          <div className="flex flex-wrap items-center gap-2">
            {(
              [
                { id: "ALL" as const, hi: "सभी स्तर", en: "All Tiers" },
                { id: "FOUNDATION" as const, hi: "बुनियादी समझ", en: "Foundation" },
                { id: "BOARD" as const, hi: "बोर्ड स्तर", en: "Board" },
                { id: "TOPPER" as const, hi: "टॉपर स्तर", en: "Topper" },
              ] as const
            ).map((f) => (
              <Button
                key={f.id}
                size="sm"
                variant={tierFilter === f.id ? "primary" : "secondary"}
                onClick={() => setTierFilter(f.id)}
              >
                {t(f.hi, f.en)}
              </Button>
            ))}
          </div>

          {filteredMcqs.length === 0 ? (
            <Card className="text-center py-8 text-sm text-ink-secondary">
              {t("इस स्तर में अभी कोई प्रश्न नहीं है।", "No MCQs in this difficulty tier yet.")}
            </Card>
          ) : (
            <div className="space-y-4">
              {filteredMcqs.map((q, idx) => renderMcqCard(q, idx))}
            </div>
          )}
        </div>
      )}

      {/* ==================== TAB 3: 2-MARK & 5-MARK SUBJECTIVE COACH ==================== */}
      {tab === "subjective" && (
        <div className="space-y-4">
          <div className="flex flex-wrap items-center gap-2">
            {(
              [
                { id: "ALL" as const, hi: "सभी (2M + 5M)", en: "All (2M + 5M)" },
                { id: "SHORT_2M" as const, hi: "2-अंक लघु उत्तरीय", en: "2-Mark Short" },
                { id: "LONG_5M" as const, hi: "5-अंक दीर्घ उत्तरीय", en: "5-Mark Long" },
              ] as const
            ).map((f) => (
              <Button
                key={f.id}
                size="sm"
                variant={subjFilter === f.id ? "primary" : "secondary"}
                onClick={() => setSubjFilter(f.id)}
              >
                {t(f.hi, f.en)}
              </Button>
            ))}
          </div>

          {filteredSubjectives.length === 0 ? (
            <Card className="text-center py-8 text-sm text-ink-secondary">
              {t("इस अध्याय में लघु/दीर्घ उत्तर प्रश्न जल्द जुड़ेंगे।", "Subjective questions for this chapter are coming soon.")}
            </Card>
          ) : (
            <div className="space-y-4">
              {filteredSubjectives.map((q, idx) => {
                const isOpen = Boolean(openAnswers[q.id]);
                const checkedStatus = selfCheckState[q.id];
                const isFiveMark = q.question_type === "LONG_5M";

                return (
                  <Card key={q.id} padding="lg" className="space-y-4">
                    <div className="flex flex-wrap items-center justify-between gap-2">
                      <div className="flex flex-wrap items-center gap-2">
                        <Badge variant={isFiveMark ? "amber" : "indigo"}>
                          {isFiveMark
                            ? t("5 अंक · दीर्घ उत्तरीय", "5 Marks · Long Answer")
                            : t("2 अंक · लघु उत्तरीय", "2 Marks · Short Answer")}
                        </Badge>
                        {q.exam_year_tag && <Badge variant="emerald">{q.exam_year_tag}</Badge>}
                      </div>
                      <ReadAloudButton
                        textHi={`${q.q_hi}. ${q.model_answer_hi ?? ""}`}
                        textEn={`${q.q_en}. ${q.model_answer_en ?? ""}`}
                        size="sm"
                      />
                    </div>

                    <div className="text-base sm:text-lg font-bold text-ink leading-relaxed">
                      <span className="text-indigo-ink mr-1.5">Q{idx + 1}.</span>
                      <MathMarkdown
                        inline
                        content={lang === "EN" ? q.q_en : q.q_hi}
                      />
                    </div>

                    {/* Memory Cues */}
                    {q.memory_cues_json && q.memory_cues_json.length > 0 && (
                      <div className="space-y-1.5">
                        <div className="text-xs font-bold uppercase tracking-wider text-amber-ink">
                          {t("याद रखने के मुख्य बिंदु (Memory Cues)", "Key Memory Cues")}
                        </div>
                        <div className="flex flex-wrap gap-2">
                          {q.memory_cues_json.map((cue, cIdx) => (
                            <span
                              key={cIdx}
                              className="rounded-full border border-amber-warm/30 bg-surface-warm px-3 py-1 text-xs font-semibold text-amber-ink"
                            >
                              <BiText hi={cue.cue_hi} en={cue.cue_en} inline />
                            </span>
                          ))}
                        </div>
                      </div>
                    )}

                    <Button
                      variant={isOpen ? "secondary" : "primary"}
                      onClick={() =>
                        setOpenAnswers((p) => ({ ...p, [q.id]: !p[q.id] }))
                      }
                    >
                      {isOpen
                        ? t("आदर्श उत्तर छिपाएँ", "Hide Model Answer")
                        : t("आदर्श उत्तर और अंक विभाजन देखें", "Show Model Answer & BSEB Marks Breakdown")}
                    </Button>

                    {isOpen && (
                      <div className="space-y-4 pt-3 border-t border-hairline">
                        <div className="rounded-paper border border-hairline bg-canvas/70 p-4 space-y-2">
                          <div className="text-xs font-bold uppercase tracking-wider text-indigo-ink">
                            {t("बिहार बोर्ड आदर्श उत्तर (Model Answer)", "BSEB Model Answer")}
                          </div>
                          {lang === "BOTH" ? (
                            <div className="space-y-3">
                              <MathMarkdown content={q.model_answer_hi ?? ""} />
                              <div className="pt-3 border-t border-hairline text-ink-secondary">
                                <MathMarkdown content={q.model_answer_en ?? ""} />
                              </div>
                            </div>
                          ) : (
                            <MathMarkdown
                              content={
                                lang === "EN"
                                  ? q.model_answer_en ?? q.model_answer_hi ?? ""
                                  : q.model_answer_hi ?? q.model_answer_en ?? ""
                              }
                            />
                          )}
                        </div>

                        {/* Exact BSEB Marking Scheme */}
                        {q.marking_scheme_json && q.marking_scheme_json.length > 0 && (
                          <div className="rounded-lg border border-indigo-academic/25 bg-indigo-soft p-4 space-y-2">
                            <div className="text-xs font-bold uppercase tracking-wider text-indigo-ink flex items-center gap-1.5">
                              <Award className="h-4 w-4" />
                              {t("बोर्ड अंक विभाजन (Marking Scheme)", "Exact BSEB Step Marking Scheme")}
                            </div>
                            <ul className="space-y-1.5 text-xs sm:text-sm text-ink">
                              {q.marking_scheme_json.map((step) => (
                                <li
                                  key={step.step_no}
                                  className="flex items-start justify-between gap-3"
                                >
                                  <span>
                                    <strong>{step.step_no}.</strong>{" "}
                                    <BiText hi={step.criterion_hi} en={step.criterion_en} inline />
                                  </span>
                                  <Badge variant="indigo">
                                    +{step.marks} {t("अंक", "M")}
                                  </Badge>
                                </li>
                              ))}
                            </ul>
                          </div>
                        )}

                        {/* Self-Check Confidence Toggle */}
                        <div className="flex flex-wrap items-center justify-between gap-3 pt-2">
                          <span className="text-xs font-semibold text-ink-secondary">
                            {t("क्या आप यह उत्तर बिना देखे लिख सकते हैं?", "Can you write this answer confidently?")}
                          </span>
                          <div className="flex items-center gap-2">
                            <Button
                              size="sm"
                              variant={checkedStatus === "NEEDS_REVIEW" ? "amber" : "secondary"}
                              onClick={() => handleSelfCheck(q, "NEEDS_REVIEW")}
                              leftIcon={<RefreshCw className="h-3.5 w-3.5" />}
                            >
                              {t("दोहराना है", "Needs Review")}
                            </Button>
                            <Button
                              size="sm"
                              variant={checkedStatus === "CONFIDENT" ? "emerald" : "secondary"}
                              onClick={() => handleSelfCheck(q, "CONFIDENT")}
                              leftIcon={<CheckCircle2 className="h-3.5 w-3.5" />}
                            >
                              {t("पक्का तैयार है", "Confident")}
                            </Button>
                          </div>
                        </div>
                      </div>
                    )}
                  </Card>
                );
              })}
            </div>
          )}
        </div>
      )}

      {/* ==================== TAB 4: BSEB PYQ VAULT ==================== */}
      {tab === "pyq" && (
        <div className="space-y-4">
          {buckets.pyqQuestions.length === 0 ? (
            <Card className="text-center py-8 text-sm text-ink-secondary">
              {t("इस अध्याय में विगत वर्षों के प्रश्न जल्द जुड़ेंगे।", "Previous-year BSEB questions for this chapter will be added soon.")}
            </Card>
          ) : (
            buckets.pyqQuestions.map((q, idx) =>
              q.question_type === "MCQ" ? (
                renderMcqCard(q, idx)
              ) : (
                <Card key={q.id} className="space-y-2.5">
                  <div className="flex items-center gap-2">
                    <Badge variant="amber">{q.exam_year_tag}</Badge>
                    <Badge variant="indigo">{q.question_type}</Badge>
                  </div>
                  <div className="font-bold text-ink">
                    <MathMarkdown inline content={lang === "EN" ? q.q_en : q.q_hi} />
                  </div>
                  {(q.model_answer_hi || q.model_answer_en) && (
                    <div className="pt-2 border-t border-hairline text-sm text-ink-secondary">
                      <MathMarkdown
                        content={
                          lang === "EN"
                            ? q.model_answer_en ?? q.model_answer_hi ?? ""
                            : q.model_answer_hi ?? q.model_answer_en ?? ""
                        }
                      />
                    </div>
                  )}
                </Card>
              )
            )
          )}
        </div>
      )}

      {/* ==================== TAB 5: AUTHENTIC BSEB 50% OMR BOARD SIMULATOR ==================== */}
      {tab === "omr" && (
        <div className="space-y-5">
          <Card variant="indigo" className="space-y-2">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <h2 className="text-lg font-bold text-ink flex items-center gap-2">
                <ClipboardList className="h-5 w-5 text-indigo-ink" />
                {t("बिहार बोर्ड 50% ऑब्जेक्टिव OMR सिम्युलेटर", "Authentic BSEB 50% Objective OMR Simulator")}
              </h2>
              {omrData && (
                <Badge variant="amber">
                  {Object.keys(omrAnswers).length} / {omrData.attemptLimit}{" "}
                  {t(`चयनित (कुल ${omrData.totalQuestions} में से)`, `Selected (out of ${omrData.totalQuestions})`)}
                </Badge>
              )}
            </div>
            <p className="text-xs sm:text-sm text-ink-secondary leading-relaxed">
              {t(
                "बिहार बोर्ड के असली पैटर्न की तरह आपको दोगुने विकल्प मिलते हैं — आपको सबसे आसान आधे (50%) प्रश्नों के गोले भरने हैं! कठिन प्रश्न छोड़ना भी टॉपर रणनीति है।",
                "Just like the official Bihar Board exam, you receive double options and attempt strictly the best 50%! Choosing smartly is a topper skill."
              )}
            </p>
          </Card>

          {omrLoading ? (
            <Card className="animate-pulse h-48" />
          ) : !omrData || omrData.questions.length === 0 ? (
            <Card className="text-center py-8 text-sm text-ink-secondary">
              {t("इस अध्याय के लिए OMR सेट तैयार किया जा रहा है।", "OMR practice set is being prepared for this chapter.")}
            </Card>
          ) : (
            <>
              {omrSubmitted && (
                <Card variant="warm" padding="lg" className="space-y-2">
                  <div className="flex flex-wrap items-center justify-between gap-2">
                    <h3 className="text-lg font-bold text-ink">
                      {t(
                        `OMR परिणाम: ${omrSubmitted.correct} / ${omrSubmitted.attemptLimit} सही`,
                        `OMR Score: ${omrSubmitted.correct} / ${omrSubmitted.attemptLimit} Correct`
                      )}
                    </h3>
                    <Badge variant="emerald">+{omrSubmitted.pointsAwarded} pts</Badge>
                  </div>
                  <p className="text-sm text-ink-secondary">
                    {t(
                      `आपने ${omrSubmitted.attempted} प्रश्न चुने और ${Math.round((omrSubmitted.correct / Math.max(1, omrSubmitted.attempted)) * 100)}% सटीकता हासिल की।`,
                      `You attempted ${omrSubmitted.attempted} questions with ${Math.round((omrSubmitted.correct / Math.max(1, omrSubmitted.attempted)) * 100)}% smart-selection accuracy.`
                    )}
                  </p>
                  <Button
                    size="sm"
                    variant="secondary"
                    onClick={() => {
                      setOmrAnswers({});
                      setOmrSubmitted(null);
                    }}
                    leftIcon={<RotateCcw className="h-3.5 w-3.5" />}
                  >
                    {t("नया OMR अभ्यास करें", "Retry OMR Sheet")}
                  </Button>
                </Card>
              )}

              <div className="space-y-3">
                {omrData.questions.map((q, idx) => {
                  const chosen = omrAnswers[q.id];
                  const evalRow = omrSubmitted?.byQuestion[q.id];

                  return (
                    <Card key={q.id} padding="sm" className="space-y-3">
                      <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-3">
                        <div className="space-y-1 flex-1 min-w-0">
                          <div className="text-sm font-bold text-ink leading-snug">
                            <span className="text-indigo-ink mr-1.5">Q{idx + 1}.</span>
                            <MathMarkdown
                              inline
                              content={lang === "EN" ? q.q_en : q.q_hi}
                            />
                          </div>
                          <div className="grid grid-cols-1 sm:grid-cols-2 gap-1 text-xs text-ink-secondary pt-1">
                            {(q.options_json ?? []).map((o) => (
                              <div key={o.key}>
                                <strong>({o.key})</strong>{" "}
                                <BiText hi={o.text_hi} en={o.text_en} inline />
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* Tactile OMR Bubbles */}
                        <div className="flex items-center gap-2 shrink-0 self-end sm:self-center">
                          {(["A", "B", "C", "D"] as const).map((bubble) => {
                            const filled = chosen === bubble;
                            const isCorrectAns = evalRow?.correctOption === bubble;
                            const isWrongChosen = evalRow && filled && !evalRow.isCorrect;

                            return (
                              <button
                                key={bubble}
                                type="button"
                                disabled={Boolean(omrSubmitted)}
                                onClick={() => handleOmrBubble(q.id, bubble)}
                                aria-label={`Q${idx + 1} Option ${bubble}`}
                                aria-pressed={filled}
                                className={cn(
                                  "h-10 w-10 rounded-full border-2 text-xs font-bold transition-all flex items-center justify-center",
                                  isCorrectAns && omrSubmitted
                                    ? "bg-emerald-mastery border-emerald-mastery text-white"
                                    : isWrongChosen
                                    ? "bg-crimson-alert border-crimson-alert text-white"
                                    : filled
                                    ? "bg-slate-900 dark:bg-indigo-academic border-slate-900 dark:border-indigo-academic text-white scale-105"
                                    : "bg-surface border-hairline-strong text-ink-secondary hover:border-indigo-academic"
                                )}
                              >
                                {bubble}
                              </button>
                            );
                          })}
                        </div>
                      </div>

                      {evalRow && !evalRow.isCorrect && (q.explanation_hi || q.explanation_en) && (
                        <div className="rounded-lg bg-surface-warm border border-amber-warm/30 px-3 py-2 text-xs text-ink flex items-start gap-2">
                          <XCircle className="h-4 w-4 text-crimson-ink shrink-0 mt-0.5" />
                          <MathMarkdown
                            inline
                            content={lang === "EN" ? q.explanation_en ?? "" : q.explanation_hi ?? ""}
                          />
                        </div>
                      )}
                    </Card>
                  );
                })}
              </div>

              {!omrSubmitted && (
                <div className="flex justify-end">
                  <Button
                    size="lg"
                    variant="primary"
                    loading={omrSubmitting}
                    onClick={handleOmrSubmit}
                    leftIcon={<CheckCircle2 className="h-4 w-4" />}
                  >
                    {t(
                      `OMR शीट जमा करें (${Object.keys(omrAnswers).length}/${omrData.attemptLimit})`,
                      `Submit OMR Sheet (${Object.keys(omrAnswers).length}/${omrData.attemptLimit})`
                    )}
                  </Button>
                </div>
              )}
            </>
          )}
        </div>
      )}

      {/* ==================== TAB 6: PERSONAL REVISION QUEUE ==================== */}
      {tab === "revision" && (
        <div className="space-y-4">
          {buckets.revisionQuestions.length === 0 ? (
            <Card variant="subtle" className="text-center py-10 space-y-2">
              <CheckCircle2 className="h-9 w-9 text-emerald-ink mx-auto" />
              <h3 className="text-base font-bold text-ink">
                {t("आपकी दोहराव सूची बिल्कुल साफ है!", "Your Revision Queue Is All Clear!")}
              </h3>
              <p className="text-xs sm:text-sm text-ink-secondary max-w-md mx-auto">
                {t(
                  "अभ्यास में जो प्रश्न गलत होंगे या जिन्हें आप 'दोहराना है' चिह्नित करेंगे, वे अपने आप यहाँ जुड़ जाएँगे। लगातार 2 सही उत्तर देने पर वे हल हो जाते हैं।",
                  "Any missed MCQs or subjective answers marked 'Needs Review' automatically appear here. Answer correctly twice in a row to master them!"
                )}
              </p>
            </Card>
          ) : (
            <div className="space-y-4">
              {buckets.revisionQuestions.map((q, idx) =>
                q.question_type === "MCQ" ? (
                  renderMcqCard(q, idx, true)
                ) : (
                  <Card key={q.id} className="space-y-3">
                    <Badge variant="amber">{t("दोहराव आवश्यक", "Needs Revision")}</Badge>
                    <div className="font-bold text-ink">
                      <MathMarkdown inline content={lang === "EN" ? q.q_en : q.q_hi} />
                    </div>
                    {(q.model_answer_hi || q.model_answer_en) && (
                      <MathMarkdown
                        content={lang === "EN" ? q.model_answer_en ?? "" : q.model_answer_hi ?? ""}
                      />
                    )}
                    <Button
                      size="sm"
                      variant="emerald"
                      onClick={() => handleSelfCheck(q, "CONFIDENT")}
                      leftIcon={<CheckCircle2 className="h-4 w-4" />}
                    >
                      {t("अब पक्का याद हो गया", "Mark Mastered Now")}
                    </Button>
                  </Card>
                )
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
