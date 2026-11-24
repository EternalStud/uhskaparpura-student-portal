"use client";

import React, { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  ArrowLeft,
  CalendarClock,
  Check,
  CheckSquare,
  ClipboardCheck,
  Loader2,
  Plus,
  Radio,
  Rocket,
  Save,
  Search,
  Trash2,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/Card";
import { Input } from "@/components/ui/Input";
import { MathMarkdown } from "@/components/ui/MathMarkdown";
import { Select } from "@/components/ui/Select";
import { Tabs } from "@/components/ui/Tabs";
import { useToast } from "@/components/ui/Toast";
import type {
  DifficultyTier,
  ExamMode,
  ExamScopeType,
  ExamSolutionPolicy,
} from "@/types/database";

interface SubjectOptionItem {
  id: string;
  class_num: number;
  stream: string;
  name_hi: string;
  name_en: string;
  isAssigned: boolean;
  chapters: Array<{
    id: string;
    chapter_no: number;
    title_hi: string;
    title_en: string;
  }>;
}

interface BankQuestionItem {
  id: string;
  chapterId: string;
  chapterNo: number | null;
  chapterTitleHi: string | null;
  chapterTitleEn: string | null;
  topicTag: string | null;
  bankPool: "PRACTICE" | "EXAM_ONLY";
  difficultyTier: DifficultyTier;
  examYearTag: string | null;
  qHi: string;
  qEn: string;
  options: Array<{ key: "A" | "B" | "C" | "D"; text_hi: string; text_en: string }>;
  correctOption: string | null;
}

interface CustomQuestionDraft {
  tempId: string;
  qHi: string;
  qEn: string;
  optionAHi: string;
  optionAEn: string;
  optionBHi: string;
  optionBEn: string;
  optionCHi: string;
  optionCEn: string;
  optionDHi: string;
  optionDEn: string;
  correctOption: "A" | "B" | "C" | "D";
  explanationHi: string;
  difficultyTier: DifficultyTier;
  marks: number;
}

function toIstOffsetIso(localDateTime: string): string | null {
  if (!localDateTime) return null;
  // Treat teacher-picked classroom wall-clock time strictly as IST (+05:30)
  const normalized = localDateTime.length === 16 ? `${localDateTime}:00` : localDateTime;
  const iso = `${normalized}+05:30`;
  const d = new Date(iso);
  return Number.isNaN(d.getTime()) ? null : d.toISOString();
}

export function NewExamBuilderClient() {
  const router = useRouter();
  const { t, lang } = useLanguage();
  const toast = useToast();

  // Catalog state
  const [subjects, setSubjects] = useState<SubjectOptionItem[]>([]);
  const [loadingCatalog, setLoadingCatalog] = useState(true);

  // Exam configuration
  const [title, setTitle] = useState("");
  const [examMode, setExamMode] = useState<ExamMode>("LIVE_PIN");
  const [scopeType, setScopeType] = useState<ExamScopeType>("CHAPTER");
  const [subjectId, setSubjectId] = useState("");
  const [targetClassNum, setTargetClassNum] = useState<9 | 10 | 11 | 12>(10);
  const [selectedChapterIds, setSelectedChapterIds] = useState<string[]>([]);
  const [durationMins, setDurationMins] = useState(20);
  const [startsLocal, setStartsLocal] = useState("");
  const [endsLocal, setEndsLocal] = useState("");
  const [showSolutionsPolicy, setShowSolutionsPolicy] =
    useState<ExamSolutionPolicy>("AFTER_EXAM_ENDS");
  const [shuffleQuestions, setShuffleQuestions] = useState(true);
  const [shuffleOptions, setShuffleOptions] = useState(true);

  // Question Bank state
  const [sourceTab, setSourceTab] = useState<"bank" | "custom">("bank");
  const [bankQuestions, setBankQuestions] = useState<BankQuestionItem[]>([]);
  const [loadingBank, setLoadingBank] = useState(false);
  const [poolFilter, setPoolFilter] = useState<"ALL" | "EXAM_ONLY" | "PRACTICE">("ALL");
  const [difficultyFilter, setDifficultyFilter] = useState("ALL");
  const [bankSearch, setBankSearch] = useState("");
  const [selectedBankIds, setSelectedBankIds] = useState<string[]>([]);

  // Custom question composer state
  const [customQuestions, setCustomQuestions] = useState<CustomQuestionDraft[]>([]);
  const [draftQHi, setDraftQHi] = useState("");
  const [draftQEn, setDraftQEn] = useState("");
  const [draftOpts, setDraftOpts] = useState({ A: "", B: "", C: "", D: "" });
  const [draftCorrect, setDraftCorrect] = useState<"A" | "B" | "C" | "D">("A");
  const [draftExp, setDraftExp] = useState("");
  const [draftTier, setDraftTier] = useState<DifficultyTier>("BOARD");

  const [saving, setSaving] = useState(false);

  useEffect(() => {
    let active = true;
    (async () => {
      try {
        const res = await fetch("/api/teacher/lesson-plans?scope=all", { cache: "no-store" });
        const json = (await res.json()) as { ok?: boolean; subjects?: SubjectOptionItem[] };
        if (active && res.ok && json.ok) {
          const list = json.subjects ?? [];
          setSubjects(list);
          const firstAssigned = list.find((s) => s.isAssigned) ?? list[0];
          if (firstAssigned) setSubjectId(firstAssigned.id);
        }
      } finally {
        if (active) setLoadingCatalog(false);
      }
    })();
    return () => {
      active = false;
    };
  }, []);

  // Load official question bank whenever subject/filters change
  useEffect(() => {
    if (!subjectId) return;
    let active = true;
    setLoadingBank(true);
    const params = new URLSearchParams({ subjectId, pool: poolFilter, difficulty: difficultyFilter });
    if (selectedChapterIds.length === 1) {
      params.set("chapterId", selectedChapterIds[0]);
    }

    (async () => {
      try {
        const res = await fetch(`/api/teacher/question-bank?${params.toString()}`, {
          cache: "no-store",
        });
        const json = (await res.json()) as {
          ok?: boolean;
          questions?: BankQuestionItem[];
        };
        if (active && res.ok && json.ok) {
          setBankQuestions(json.questions ?? []);
        }
      } finally {
        if (active) setLoadingBank(false);
      }
    })();

    return () => {
      active = false;
    };
  }, [subjectId, poolFilter, difficultyFilter, selectedChapterIds]);

  const currentSubject = useMemo(
    () => subjects.find((s) => s.id === subjectId) ?? null,
    [subjects, subjectId]
  );

  const visibleBankQuestions = useMemo(() => {
    const q = bankSearch.trim().toLowerCase();
    return bankQuestions.filter((item) => {
      if (selectedChapterIds.length > 1 && !selectedChapterIds.includes(item.chapterId)) {
        return false;
      }
      if (!q) return true;
      return (
        item.qHi.toLowerCase().includes(q) ||
        item.qEn.toLowerCase().includes(q) ||
        (item.topicTag ?? "").toLowerCase().includes(q) ||
        (item.examYearTag ?? "").toLowerCase().includes(q)
      );
    });
  }, [bankQuestions, selectedChapterIds, bankSearch]);

  const toggleBankId = (id: string) => {
    setSelectedBankIds((prev) =>
      prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]
    );
  };

  const toggleChapter = (cid: string) => {
    setSelectedChapterIds((prev) =>
      prev.includes(cid) ? prev.filter((x) => x !== cid) : [...prev, cid]
    );
  };

  const quickPickFromVisible = (count: number) => {
    const ids = visibleBankQuestions.slice(0, count).map((q) => q.id);
    setSelectedBankIds((prev) => Array.from(new Set([...prev, ...ids])).slice(0, 100));
  };

  const handleAddCustomQuestion = () => {
    if (
      draftQHi.trim().length < 3 ||
      !draftOpts.A.trim() ||
      !draftOpts.B.trim() ||
      !draftOpts.C.trim() ||
      !draftOpts.D.trim()
    ) {
      toast.warning(
        t(
          "कृपया प्रश्न और चारों विकल्प (A, B, C, D) भरें।",
          "Please fill in the question and all four options (A, B, C, D)."
        )
      );
      return;
    }

    setCustomQuestions((prev) => [
      ...prev,
      {
        tempId: `cq-${Date.now()}-${Math.random().toString(36).slice(2, 6)}`,
        qHi: draftQHi.trim(),
        qEn: draftQEn.trim() || draftQHi.trim(),
        optionAHi: draftOpts.A.trim(),
        optionAEn: draftOpts.A.trim(),
        optionBHi: draftOpts.B.trim(),
        optionBEn: draftOpts.B.trim(),
        optionCHi: draftOpts.C.trim(),
        optionCEn: draftOpts.C.trim(),
        optionDHi: draftOpts.D.trim(),
        optionDEn: draftOpts.D.trim(),
        correctOption: draftCorrect,
        explanationHi: draftExp.trim(),
        difficultyTier: draftTier,
        marks: 1,
      },
    ]);

    setDraftQHi("");
    setDraftQEn("");
    setDraftOpts({ A: "", B: "", C: "", D: "" });
    setDraftExp("");
    setDraftCorrect("A");
    toast.success(t("कस्टम प्रश्न जोड़ा गया", "Custom MCQ added to exam"));
  };

  const totalSelected = selectedBankIds.length + customQuestions.length;

  const handleCreateExam = async (launchImmediately: boolean) => {
    if (title.trim().length < 2) {
      toast.warning(t("कृपया परीक्षा का शीर्षक दर्ज करें।", "Please enter an exam title."));
      return;
    }
    if (!subjectId) {
      toast.warning(t("कृपया विषय चुनें।", "Please choose a subject."));
      return;
    }
    if (totalSelected === 0) {
      toast.warning(
        t(
          "कृपया प्रश्न बैंक से या कस्टम से कम से कम 1 प्रश्न चुनें।",
          "Please select at least 1 question from the bank or add a custom question."
        )
      );
      return;
    }

    let startsAtIso: string | null = null;
    let endsAtIso: string | null = null;
    if (examMode === "SCHEDULED") {
      startsAtIso = toIstOffsetIso(startsLocal);
      endsAtIso = toIstOffsetIso(endsLocal);
      if (!startsAtIso || !endsAtIso) {
        toast.warning(
          t(
            "निर्धारित परीक्षा के लिए प्रारंभ और समाप्ति समय (IST) चुनें।",
            "Select Start and End Date/Time (IST) for a Scheduled Exam."
          )
        );
        return;
      }
    }

    setSaving(true);
    try {
      const res = await fetch("/api/exams", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          title: title.trim(),
          examMode,
          scopeType,
          subjectId,
          classNum: currentSubject?.class_num === 0 ? targetClassNum : undefined,
          chapterIds: selectedChapterIds,
          durationMins: Number(durationMins),
          startsAt: startsAtIso,
          endsAt: endsAtIso,
          showSolutionsPolicy,
          shuffleQuestions,
          shuffleOptions,
          questionIds: selectedBankIds,
          customQuestions: customQuestions.map((cq) => ({
            qHi: cq.qHi,
            qEn: cq.qEn,
            options: [
              { key: "A", textHi: cq.optionAHi, textEn: cq.optionAEn },
              { key: "B", textHi: cq.optionBHi, textEn: cq.optionBEn },
              { key: "C", textHi: cq.optionCHi, textEn: cq.optionCEn },
              { key: "D", textHi: cq.optionDHi, textEn: cq.optionDEn },
            ],
            correctOption: cq.correctOption,
            explanationHi: cq.explanationHi || undefined,
            difficultyTier: cq.difficultyTier,
            marks: cq.marks,
          })),
          launchImmediately,
        }),
      });

      const json = (await res.json()) as {
        ok?: boolean;
        exam?: { id: string };
        error?: string;
        errorHi?: string;
      };
      if (!res.ok || !json.ok || !json.exam) {
        throw new Error(lang === "EN" ? json.error : json.errorHi || json.error);
      }

      toast.success(
        launchImmediately
          ? t("परीक्षा सक्रिय हो गई है!", "Exam launched successfully!")
          : t("परीक्षा ड्राफ्ट सहेजा गया", "Exam saved as draft")
      );
      router.push(`/teacher/exams/${json.exam.id}/monitor`);
    } catch (err) {
      toast.error(
        t("परीक्षा बनाई नहीं जा सकी", "Could not create exam"),
        err instanceof Error ? err.message : undefined
      );
    } finally {
      setSaving(false);
    }
  };

  if (loadingCatalog) {
    return (
      <div className="flex min-h-[40vh] items-center justify-center">
        <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
      </div>
    );
  }

  return (
    <div className="max-w-5xl mx-auto space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Link href="/teacher/exams">
          <Button variant="ghost" size="sm" leftIcon={<ArrowLeft className="h-4 w-4" />}>
            {t("परीक्षा केंद्र", "Back to Exams")}
          </Button>
        </Link>
        <Badge variant="indigo">
          {totalSelected} {t("प्रश्न चयनित", "questions selected")}
        </Badge>
      </div>

      <div className="space-y-1">
        <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
          {t("नई परीक्षा तैयार करें", "Create New Assessment")}
        </h1>
        <p className="text-sm text-ink-secondary">
          {t(
            "आधिकारिक BSEB प्रश्न बैंक (परीक्षा व अभ्यास दोनों पूल) या अपने कस्टम द्विभाषी प्रश्नों से परीक्षा बनाएँ।",
            "Pick questions from the official BSEB bank (both Exam-Only & Practice pools) or compose custom bilingual MCQs."
          )}
        </p>
      </div>

      {/* Step 1: Mode & Metadata */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">
            {t("1. परीक्षा मोड और विवरण", "1. Exam Mode & Details")}
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-5">
          {/* Dual Mode Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <button
              type="button"
              onClick={() => setExamMode("LIVE_PIN")}
              className={`rounded-paper border p-4 text-left transition-all ${
                examMode === "LIVE_PIN"
                  ? "border-indigo-academic bg-indigo-soft shadow-paper"
                  : "border-hairline bg-surface hover:bg-surface-subtle"
              }`}
            >
              <div className="flex items-center gap-2 font-bold text-ink">
                <Radio className="h-4 w-4 text-indigo-ink" />
                <span>{t("लाइव कक्षा परीक्षा (6-अंकीय रूम कोड)", "Live Classroom Exam (6-Digit Room Code)")}</span>
              </div>
              <p className="mt-1 text-xs text-ink-secondary leading-relaxed">
                {t(
                  "कक्षा या ICT लैब में तुरंत 6 अंकों के कोड से सभी विद्यार्थियों को जोड़ें और प्रोजेक्टर पर लाइव प्रगति देखें।",
                  "Project a 6-digit Room Code in class or ICT Lab and watch live progress in real time."
                )}
              </p>
            </button>

            <button
              type="button"
              onClick={() => setExamMode("SCHEDULED")}
              className={`rounded-paper border p-4 text-left transition-all ${
                examMode === "SCHEDULED"
                  ? "border-indigo-academic bg-indigo-soft shadow-paper"
                  : "border-hairline bg-surface hover:bg-surface-subtle"
              }`}
            >
              <div className="flex items-center gap-2 font-bold text-ink">
                <CalendarClock className="h-4 w-4 text-indigo-ink" />
                <span>{t("निर्धारित समय परीक्षा (Scheduled)", "Scheduled Window Exam")}</span>
              </div>
              <p className="mt-1 text-xs text-ink-secondary leading-relaxed">
                {t(
                  "गृहकार्य या साप्ताहिक जांच परीक्षा के लिए प्रारंभ और समाप्ति समय (IST) तय करें।",
                  "Set a start and end window (IST) for homework tests or weekly assessments."
                )}
              </p>
            </button>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <Input
              required
              label={t("परीक्षा का शीर्षक", "Exam Title")}
              placeholder={t(
                "उदाहरण: कक्षा 10 विज्ञान — प्रकाश (साप्ताहिक जांच)",
                "e.g., Class 10 Science — Light Weekly Assessment"
              )}
              value={title}
              onChange={(e) => setTitle(e.target.value)}
            />

            <Select
              required
              label={t("कक्षा एवं विषय", "Class & Subject")}
              value={subjectId}
              onChange={(e) => {
                setSubjectId(e.target.value);
                setSelectedChapterIds([]);
                setSelectedBankIds([]);
              }}
              options={subjects.map((s) => ({
                value: s.id,
                label: `${
                  s.class_num === 0
                    ? t("कौशल लैब (9–12)", "Skill Lab (9–12)")
                    : t(`कक्षा ${s.class_num}`, `Class ${s.class_num}`)
                } · ${t(
                  s.name_hi,
                  s.name_en
                )}${s.isAssigned ? ` (${t("मेरा विषय", "My Subject")})` : ""}`,
              }))}
            />
          </div>

          {currentSubject?.class_num === 0 && (
            <div className="rounded-lg border border-indigo-academic/25 bg-indigo-soft p-3.5 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div className="text-xs sm:text-sm text-ink">
                <strong className="text-indigo-ink block">
                  {t("लक्ष्य कक्षा चुनें (कौशल लैब परीक्षा)", "Select Target Class (Skill Lab Exam)")}
                </strong>
                <span className="text-ink-secondary">
                  {t(
                    "चुनें कि यह ICT या English Foundation परीक्षा किस कक्षा के विद्यार्थियों के लिए आयोजित की जा रही है।",
                    "Choose which grade (Class 9–12) will take this ICT or English Foundation exam."
                  )}
                </span>
              </div>
              <div className="w-full sm:w-44 shrink-0">
                <Select
                  value={String(targetClassNum)}
                  onChange={(e) =>
                    setTargetClassNum(Number(e.target.value) as 9 | 10 | 11 | 12)
                  }
                  options={[
                    { value: "9", label: t("कक्षा 9", "Class 9") },
                    { value: "10", label: t("कक्षा 10", "Class 10") },
                    { value: "11", label: t("कक्षा 11", "Class 11") },
                    { value: "12", label: t("कक्षा 12", "Class 12") },
                  ]}
                />
              </div>
            </div>
          )}

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <Select
              label={t("परीक्षा का दायरा", "Assessment Scope")}
              value={scopeType}
              onChange={(e) => setScopeType(e.target.value as ExamScopeType)}
              options={[
                { value: "TOPIC", label: t("टॉपिक टेस्ट", "Topic Quiz") },
                { value: "CHAPTER", label: t("अध्याय परीक्षा", "Chapter Exam") },
                { value: "SUBJECT", label: t("संपूर्ण विषय परीक्षा", "Full Subject Exam") },
              ]}
            />

            <Input
              type="number"
              min={5}
              max={180}
              required
              label={t("अवधि (मिनट में)", "Duration (Minutes)")}
              value={durationMins}
              onChange={(e) => setDurationMins(Math.max(5, Math.min(180, Number(e.target.value) || 15)))}
            />

            <Select
              label={t("उत्तर-कुंजी दृश्यता", "Solutions Visibility")}
              value={showSolutionsPolicy}
              onChange={(e) => setShowSolutionsPolicy(e.target.value as ExamSolutionPolicy)}
              options={[
                { value: "AFTER_EXAM_ENDS", label: t("परीक्षा समाप्त होने के बाद", "After Exam Ends") },
                { value: "IMMEDIATE_ON_SUBMIT", label: t("जमा करते ही तुरंत", "Immediately on Submit") },
                { value: "TEACHER_ONLY", label: t("केवल शिक्षक देखें", "Teacher Only") },
              ]}
            />
          </div>

          {examMode === "SCHEDULED" && (
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 rounded-lg border border-hairline bg-surface-subtle/50 p-4">
              <Input
                type="datetime-local"
                required
                label={t("प्रारंभ समय (IST)", "Start Date & Time (IST)")}
                value={startsLocal}
                onChange={(e) => setStartsLocal(e.target.value)}
              />
              <Input
                type="datetime-local"
                required
                label={t("समाप्ति समय (IST)", "End Date & Time (IST)")}
                value={endsLocal}
                onChange={(e) => setEndsLocal(e.target.value)}
              />
            </div>
          )}

          {/* Chapter filter chips */}
          {currentSubject && currentSubject.chapters.length > 0 && (
            <div className="space-y-2">
              <p className="text-xs font-semibold text-ink-secondary">
                {t("अध्याय फ़िल्टर (वैकल्पिक — चुनने पर प्रश्न उसी अध्याय से दिखेंगे)", "Filter Chapters (Optional)")}
              </p>
              <div className="flex flex-wrap gap-2">
                {currentSubject.chapters.map((ch) => {
                  const picked = selectedChapterIds.includes(ch.id);
                  return (
                    <button
                      key={ch.id}
                      type="button"
                      onClick={() => toggleChapter(ch.id)}
                      className={`rounded-full border px-3 py-1.5 text-xs font-semibold transition-colors ${
                        picked
                          ? "border-indigo-academic bg-indigo-soft text-indigo-ink"
                          : "border-hairline bg-surface text-ink-secondary hover:text-ink"
                      }`}
                    >
                      {t(`अध्याय ${ch.chapter_no}`, `Ch ${ch.chapter_no}`)}:{" "}
                      {t(ch.title_hi, ch.title_en)}
                    </button>
                  );
                })}
              </div>
            </div>
          )}

          <div className="flex flex-wrap gap-6 pt-1">
            <label className="flex items-center gap-2 text-sm text-ink cursor-pointer">
              <input
                type="checkbox"
                checked={shuffleQuestions}
                onChange={(e) => setShuffleQuestions(e.target.checked)}
                className="h-4 w-4 accent-indigo-academic"
              />
              <span>{t("हर विद्यार्थी के लिए प्रश्न क्रम बदलें", "Shuffle question order per student")}</span>
            </label>
            <label className="flex items-center gap-2 text-sm text-ink cursor-pointer">
              <input
                type="checkbox"
                checked={shuffleOptions}
                onChange={(e) => setShuffleOptions(e.target.checked)}
                className="h-4 w-4 accent-indigo-academic"
              />
              <span>{t("विकल्पों (A/B/C/D) का क्रम बदलें", "Shuffle option order")}</span>
            </label>
          </div>
        </CardContent>
      </Card>

      {/* Step 2: Question Picker (Official Bank incl. EXAM_ONLY + Custom MCQs) */}
      <Card>
        <CardHeader className="flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div>
            <CardTitle className="text-base">
              {t("2. प्रश्न चुनें या स्वयं जोड़ें", "2. Select Bank Questions or Add Custom MCQs")}
            </CardTitle>
            <CardDescription>
              {t(
                "परीक्षा पूल (Exam-Only) के प्रश्न विद्यार्थियों को अभ्यास में नहीं दिखते — निष्पक्ष मूल्यांकन के लिए सर्वोत्तम।",
                "Exam-Only pool questions are hidden from student self-practice — ideal for fair testing."
              )}
            </CardDescription>
          </div>
          <Badge variant="emerald">
            {selectedBankIds.length} {t("बैंक", "Bank")} + {customQuestions.length}{" "}
            {t("कस्टम", "Custom")}
          </Badge>
        </CardHeader>

        <CardContent className="space-y-4">
          <Tabs
            variant="pills"
            value={sourceTab}
            onChange={setSourceTab}
            items={[
              {
                id: "bank",
                label: t("आधिकारिक प्रश्न बैंक", "Official Question Bank"),
                count: selectedBankIds.length,
              },
              {
                id: "custom",
                label: t("कस्टम प्रश्न जोड़ें", "Custom MCQs"),
                count: customQuestions.length,
              },
            ]}
          />

          {sourceTab === "bank" ? (
            <div className="space-y-4">
              <div className="grid grid-cols-1 sm:grid-cols-4 gap-3">
                <Input
                  placeholder={t("प्रश्न खोजें...", "Search questions...")}
                  value={bankSearch}
                  onChange={(e) => setBankSearch(e.target.value)}
                  leftIcon={<Search className="h-4 w-4" />}
                  containerClassName="sm:col-span-2"
                />
                <Select
                  value={poolFilter}
                  onChange={(e) =>
                    setPoolFilter(e.target.value as "ALL" | "EXAM_ONLY" | "PRACTICE")
                  }
                  options={[
                    { value: "ALL", label: t("सभी पूल (परीक्षा + अभ्यास)", "All Pools") },
                    { value: "EXAM_ONLY", label: t("केवल परीक्षा पूल (Exam-Only)", "Exam-Only Pool") },
                    { value: "PRACTICE", label: t("अभ्यास पूल (Practice)", "Practice Pool") },
                  ]}
                />
                <Select
                  value={difficultyFilter}
                  onChange={(e) => setDifficultyFilter(e.target.value)}
                  options={[
                    { value: "ALL", label: t("सभी स्तर", "All Tiers") },
                    { value: "FOUNDATION", label: t("बुनियादी (Foundation)", "Foundation") },
                    { value: "BOARD", label: t("बोर्ड स्तर (Board)", "Board") },
                    { value: "TOPPER", label: t("टॉपर (Topper)", "Topper") },
                  ]}
                />
              </div>

              {visibleBankQuestions.length > 0 && (
                <div className="flex flex-wrap items-center justify-between gap-2 text-xs">
                  <span className="text-ink-secondary">
                    {visibleBankQuestions.length} {t("प्रश्न उपलब्ध", "questions available")}
                  </span>
                  <div className="flex items-center gap-2">
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => quickPickFromVisible(10)}
                      leftIcon={<CheckSquare className="h-3.5 w-3.5" />}
                    >
                      {t("शीर्ष 10 चुनें", "Select Top 10")}
                    </Button>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => setSelectedBankIds([])}
                    >
                      {t("चयन साफ़ करें", "Clear")}
                    </Button>
                  </div>
                </div>
              )}

              {loadingBank ? (
                <div className="py-8 flex justify-center">
                  <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
                </div>
              ) : visibleBankQuestions.length === 0 ? (
                <div className="rounded-lg border border-hairline bg-surface-subtle/50 p-6 text-center space-y-1.5">
                  <p className="text-sm font-semibold text-ink">
                    {t("इस विषय/फ़िल्टर में अभी बैंक प्रश्न नहीं हैं", "No official bank MCQs match these filters yet")}
                  </p>
                  <p className="text-xs text-ink-secondary">
                    {t(
                      "आप 'कस्टम प्रश्न जोड़ें' टैब से तुरंत अपने प्रश्न जोड़ सकते हैं।",
                      "Switch to the 'Custom MCQs' tab to add your own bilingual questions right away."
                    )}
                  </p>
                </div>
              ) : (
                <div className="space-y-2.5 max-h-[440px] overflow-y-auto pr-1">
                  {visibleBankQuestions.map((q) => {
                    const checked = selectedBankIds.includes(q.id);
                    return (
                      <button
                        key={q.id}
                        type="button"
                        onClick={() => toggleBankId(q.id)}
                        className={`w-full rounded-lg border p-3.5 text-left transition-colors ${
                          checked
                            ? "border-indigo-academic bg-indigo-soft"
                            : "border-hairline bg-surface hover:bg-surface-subtle/50"
                        }`}
                      >
                        <div className="flex items-start gap-3">
                          <span
                            className={`mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded border ${
                              checked
                                ? "border-indigo-academic bg-indigo-academic text-white"
                                : "border-hairline-strong bg-surface"
                            }`}
                          >
                            {checked && <Check className="h-3.5 w-3.5" />}
                          </span>
                          <div className="min-w-0 flex-1 space-y-1.5">
                            <div className="flex flex-wrap items-center gap-1.5">
                              <Badge
                                variant={q.bankPool === "EXAM_ONLY" ? "amber" : "neutral"}
                              >
                                {q.bankPool === "EXAM_ONLY"
                                  ? t("परीक्षा बैंक", "Exam-Only")
                                  : t("अभ्यास बैंक", "Practice")}
                              </Badge>
                              <Badge variant="outline">{q.difficultyTier}</Badge>
                              {q.examYearTag && <Badge variant="indigo">{q.examYearTag}</Badge>}
                              {q.chapterNo && (
                                <span className="text-[11px] text-ink-muted">
                                  {t(`अध्याय ${q.chapterNo}`, `Ch. ${q.chapterNo}`)}
                                </span>
                              )}
                            </div>
                            <MathMarkdown
                              content={lang === "EN" ? q.qEn || q.qHi : q.qHi || q.qEn}
                              className="text-sm text-ink"
                            />
                          </div>
                        </div>
                      </button>
                    );
                  })}
                </div>
              )}
            </div>
          ) : (
            <div className="space-y-5">
              {/* Custom Question Form */}
              <div className="rounded-paper border border-hairline bg-surface-subtle/40 p-4 space-y-4">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-ink">
                      {t("प्रश्न (हिन्दी — अनिवार्य · $...$ सूत्र समर्थित)", "Question in Hindi (Required · $...$ math supported)")}
                    </label>
                    <textarea
                      rows={3}
                      value={draftQHi}
                      onChange={(e) => setDraftQHi(e.target.value)}
                      placeholder={t("उदाहरण: निर्वात में प्रकाश की चाल कितनी होती है?", "Enter question stem...")}
                      className="w-full rounded-lg border border-hairline-strong bg-surface px-3 py-2 text-sm text-ink"
                    />
                  </div>
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-ink">
                      {t("प्रश्न (English — वैकल्पिक)", "Question in English (Optional)")}
                    </label>
                    <textarea
                      rows={3}
                      value={draftQEn}
                      onChange={(e) => setDraftQEn(e.target.value)}
                      placeholder="e.g., What is the speed of light in vacuum?"
                      className="w-full rounded-lg border border-hairline-strong bg-surface px-3 py-2 text-sm text-ink"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {(["A", "B", "C", "D"] as const).map((key) => (
                    <Input
                      key={key}
                      label={`${t("विकल्प", "Option")} ${key}`}
                      value={draftOpts[key]}
                      onChange={(e) =>
                        setDraftOpts((prev) => ({ ...prev, [key]: e.target.value }))
                      }
                      placeholder={`${t("विकल्प", "Option")} ${key}`}
                    />
                  ))}
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  <Select
                    label={t("सही विकल्प", "Correct Option")}
                    value={draftCorrect}
                    onChange={(e) =>
                      setDraftCorrect(e.target.value as "A" | "B" | "C" | "D")
                    }
                    options={[
                      { value: "A", label: "A" },
                      { value: "B", label: "B" },
                      { value: "C", label: "C" },
                      { value: "D", label: "D" },
                    ]}
                  />
                  <Select
                    label={t("कठिनाई स्तर", "Difficulty")}
                    value={draftTier}
                    onChange={(e) => setDraftTier(e.target.value as DifficultyTier)}
                    options={[
                      { value: "FOUNDATION", label: t("बुनियादी", "Foundation") },
                      { value: "BOARD", label: t("बोर्ड स्तर", "Board") },
                      { value: "TOPPER", label: t("टॉपर", "Topper") },
                    ]}
                  />
                  <Input
                    label={t("व्याख्या (वैकल्पिक)", "Explanation (Optional)")}
                    value={draftExp}
                    onChange={(e) => setDraftExp(e.target.value)}
                    placeholder={t("संक्षिप्त हल...", "Brief explanation...")}
                  />
                </div>

                <div className="flex justify-end">
                  <Button
                    type="button"
                    variant="secondary"
                    size="sm"
                    onClick={handleAddCustomQuestion}
                    leftIcon={<Plus className="h-4 w-4" />}
                  >
                    {t("इस प्रश्न को परीक्षा में जोड़ें", "Add Question to Exam")}
                  </Button>
                </div>
              </div>

              {/* List of Added Custom Questions */}
              {customQuestions.length > 0 && (
                <div className="space-y-2.5">
                  {customQuestions.map((cq, idx) => (
                    <div
                      key={cq.tempId}
                      className="flex items-start justify-between gap-3 rounded-lg border border-hairline bg-surface p-3.5"
                    >
                      <div className="space-y-1 min-w-0">
                        <div className="flex items-center gap-2">
                          <Badge variant="indigo">#{idx + 1}</Badge>
                          <Badge variant="emerald">
                            {t("सही", "Ans")}: {cq.correctOption}
                          </Badge>
                        </div>
                        <MathMarkdown content={cq.qHi} className="text-sm text-ink" />
                      </div>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() =>
                          setCustomQuestions((prev) =>
                            prev.filter((x) => x.tempId !== cq.tempId)
                          )
                        }
                        leftIcon={<Trash2 className="h-4 w-4 text-crimson-ink" />}
                      >
                        {t("हटाएँ", "Remove")}
                      </Button>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Sticky Launch Footer */}
      <div className="sticky bottom-16 lg:bottom-4 z-20 flex flex-wrap items-center justify-between gap-3 rounded-paper border border-hairline bg-surface/95 backdrop-blur-sm p-4 shadow-paper-hover">
        <div className="flex items-center gap-2 text-sm text-ink-secondary">
          <ClipboardCheck className="h-4 w-4 text-indigo-ink" />
          <span>
            <strong className="text-ink">{totalSelected}</strong> {t("प्रश्न", "questions")} ·{" "}
            <strong className="text-ink">{durationMins}</strong> {t("मिनट", "mins")}
          </span>
        </div>

        <div className="flex flex-wrap items-center gap-2.5">
          <Button
            variant="secondary"
            loading={saving}
            disabled={totalSelected === 0}
            onClick={() => void handleCreateExam(false)}
            leftIcon={<Save className="h-4 w-4" />}
          >
            {t("ड्राफ्ट सहेजें", "Save Draft")}
          </Button>
          <Button
            variant="primary"
            loading={saving}
            disabled={totalSelected === 0}
            onClick={() => void handleCreateExam(true)}
            leftIcon={<Rocket className="h-4 w-4" />}
          >
            {examMode === "LIVE_PIN"
              ? t("रूम कोड बनाएँ और लॉन्च करें", "Generate Room Code & Launch")
              : t("परीक्षा सक्रिय करें", "Activate Scheduled Exam")}
          </Button>
        </div>
      </div>
    </div>
  );
}
