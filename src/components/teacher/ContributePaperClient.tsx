"use client";

import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  CheckCircle2,
  Clock,
  FilePlus2,
  FileSpreadsheet,
  FileText,
  Image as ImageIcon,
  Loader2,
  MessageCircle,
  Send,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/Card";
import { Input } from "@/components/ui/Input";
import { Select } from "@/components/ui/Select";
import { useToast } from "@/components/ui/Toast";
import {
  ResumableFileUploader,
  type UploadedFileResult,
} from "@/components/teacher/ResumableFileUploader";
import type { SubmissionSourceType } from "@/types/database";

interface SubjectOptionItem {
  id: string;
  class_num: number;
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

interface SubmissionItem {
  id: string;
  subject: { id: string; classNum: number; nameHi: string; nameEn: string } | null;
  chapter: { id: string; chapterNo: number; titleHi: string; titleEn: string } | null;
  topicHint: string | null;
  sourceType: SubmissionSourceType;
  editorialStatus: "SUBMITTED" | "UNDER_REVIEW" | "PUBLISHED" | "FEEDBACK_RECEIVED";
  statusLabelEn: string;
  statusLabelHi: string;
  approvedCount: number;
  reviewFeedback: string | null;
  fileName: string | null;
  createdAt: string;
  reviewedAt: string | null;
}

const SOURCE_CONFIG: Record<
  SubmissionSourceType,
  {
    accept: string;
    mimes: string[];
    maxMb: number;
    titleHi: string;
    titleEn: string;
    hintHi: string;
    hintEn: string;
  }
> = {
  SCANNED_PDF: {
    accept: ".pdf,application/pdf",
    mimes: ["application/pdf"],
    maxMb: 20,
    titleHi: "स्कैन किया गया PDF प्रश्न पत्र",
    titleEn: "Scanned PDF Question Paper",
    hintHi: "अधिकतम 20 MB · स्पष्ट स्कैन किया हुआ PDF अपलोड करें",
    hintEn: "Up to 20 MB · Upload clear scanned or typed PDF",
  },
  IMAGE: {
    accept: "image/jpeg,image/png,image/webp",
    mimes: ["image/jpeg", "image/png", "image/webp"],
    maxMb: 5,
    titleHi: "प्रश्न पत्र की स्पष्ट फ़ोटो",
    titleEn: "Clear Photo / Image",
    hintHi: "JPG, PNG या WEBP · अधिकतम 5 MB",
    hintEn: "JPG, PNG, or WEBP · up to 5 MB",
  },
  WORD: {
    accept: ".docx,application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    mimes: ["application/vnd.openxmlformats-officedocument.wordprocessingml.document"],
    maxMb: 10,
    titleHi: "Word दस्तावेज़ (.docx)",
    titleEn: "Word Document (.docx)",
    hintHi: "अधिकतम 10 MB · .docx प्रारूप",
    hintEn: "Up to 10 MB · .docx format",
  },
  EXCEL: {
    accept: ".xlsx,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    mimes: ["application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"],
    maxMb: 10,
    titleHi: "Excel शीट (.xlsx)",
    titleEn: "Excel Sheet (.xlsx)",
    hintHi: "अधिकतम 10 MB · .xlsx प्रारूप",
    hintEn: "Up to 10 MB · .xlsx format",
  },
};

export function ContributePaperClient() {
  const { t, lang } = useLanguage();
  const toast = useToast();

  const [subjects, setSubjects] = useState<SubjectOptionItem[]>([]);
  const [submissions, setSubmissions] = useState<SubmissionItem[]>([]);
  const [stats, setStats] = useState({
    totalSubmitted: 0,
    underReview: 0,
    publishedPapers: 0,
    totalPublishedQuestions: 0,
  });
  const [loading, setLoading] = useState(true);

  // Submission form
  const [subjectId, setSubjectId] = useState("");
  const [chapterId, setChapterId] = useState("");
  const [topicHint, setTopicHint] = useState("");
  const [sourceType, setSourceType] = useState<SubmissionSourceType>("SCANNED_PDF");
  const [uploadedFile, setUploadedFile] = useState<UploadedFileResult | null>(null);
  const [submitting, setSubmitting] = useState(false);

  const loadSubmissions = useCallback(async () => {
    const res = await fetch("/api/teacher/submissions", { cache: "no-store" });
    const json = (await res.json()) as {
      ok?: boolean;
      submissions?: SubmissionItem[];
      stats?: typeof stats;
    };
    if (res.ok && json.ok) {
      setSubmissions(json.submissions ?? []);
      if (json.stats) setStats(json.stats);
    }
  }, []);

  useEffect(() => {
    let active = true;
    (async () => {
      try {
        const [subjRes] = await Promise.all([
          fetch("/api/teacher/lesson-plans?scope=all", { cache: "no-store" }),
          loadSubmissions(),
        ]);
        const subjJson = (await subjRes.json()) as {
          ok?: boolean;
          subjects?: SubjectOptionItem[];
        };
        if (active && subjRes.ok && subjJson.ok) {
          const list = subjJson.subjects ?? [];
          setSubjects(list);
          const firstAssigned = list.find((s) => s.isAssigned) ?? list[0];
          if (firstAssigned) setSubjectId(firstAssigned.id);
        }
      } finally {
        if (active) setLoading(false);
      }
    })();
    return () => {
      active = false;
    };
  }, [loadSubmissions]);

  const currentSubject = useMemo(
    () => subjects.find((s) => s.id === subjectId) ?? null,
    [subjects, subjectId]
  );

  const handleSubmitPaper = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!subjectId || !uploadedFile) {
      toast.warning(
        t(
          "कृपया विषय चुनें और प्रश्न पत्र फ़ाइल अपलोड करें।",
          "Please select a subject and upload your question paper first."
        )
      );
      return;
    }

    setSubmitting(true);
    try {
      const res = await fetch("/api/teacher/submissions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          subjectId,
          chapterId: chapterId || null,
          topicHint: topicHint.trim() || null,
          sourceType,
          mediaObjectId: uploadedFile.mediaObjectId,
        }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string; errorHi?: string };
      if (!res.ok || !json.ok) {
        throw new Error(lang === "EN" ? json.error : json.errorHi || json.error);
      }
      toast.success(
        t(
          "आपका प्रश्न पत्र संपादकीय समीक्षा के लिए सफलतापूर्वक जमा हो गया!",
          "Your question paper has been submitted for editorial review!"
        )
      );
      setTopicHint("");
      setChapterId("");
      setUploadedFile(null);
      await loadSubmissions();
    } catch (err) {
      toast.error(
        t("प्रश्न पत्र जमा नहीं हो सका", "Could not submit question paper"),
        err instanceof Error ? err.message : undefined
      );
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="flex min-h-[40vh] items-center justify-center">
        <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Dignified Editorial Header */}
      <div className="space-y-1.5 border-b border-hairline pb-5">
        <Badge variant="indigo" icon={<FilePlus2 className="h-3.5 w-3.5" />}>
          {t("शैक्षणिक संपादकीय योगदान", "Academic Editorial Contribution")}
        </Badge>
        <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
          {t(
            "संपादकीय समीक्षा के लिए प्रश्न पत्र भेजें",
            "Submit Question Paper for Editorial Review"
          )}
        </h1>
        <p className="text-sm text-ink-secondary max-w-2xl leading-relaxed">
          {t(
            "अपने विद्यालय के गुणवत्तापूर्ण प्रश्न पत्र, मॉडल सेट या अध्याय प्रश्न साझा करें। हमारी शैक्षणिक संपादकीय टीम समीक्षा के बाद चयनित प्रश्नों को बिहार के विद्यार्थियों के प्रश्न बैंक में प्रकाशित करेगी।",
            "Share high-quality chapter sets, school test papers, or board-style question sheets. After academic editorial review, approved questions are published to the statewide BSEB question bank."
          )}
        </p>
      </div>

      {/* Contribution Impact Stats */}
      <div className="grid grid-cols-3 gap-3 sm:gap-4">
        <Card padding="sm">
          <p className="text-xs font-semibold text-ink-muted">
            {t("कुल भेजे गए पत्र", "Papers Submitted")}
          </p>
          <p className="mt-1 text-2xl font-bold text-ink">{stats.totalSubmitted}</p>
        </Card>
        <Card padding="sm">
          <p className="text-xs font-semibold text-ink-muted">
            {t("समीक्षाधीन", "In Editorial Review")}
          </p>
          <p className="mt-1 text-2xl font-bold text-amber-ink">{stats.underReview}</p>
        </Card>
        <Card padding="sm">
          <p className="text-xs font-semibold text-ink-muted">
            {t("प्रकाशित प्रश्न", "Published Questions")}
          </p>
          <p className="mt-1 text-2xl font-bold text-emerald-ink">
            +{stats.totalPublishedQuestions}
          </p>
        </Card>
      </div>

      {/* Upload & Submission Form */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">
            {t("नया प्रश्न पत्र अपलोड करें", "Upload a Question Paper")}
          </CardTitle>
          <CardDescription>
            {t(
              "स्कैन किया PDF, फ़ोटो, Word या Excel फ़ाइल चुनें",
              "Choose a scanned PDF, photo, Word (.docx), or Excel (.xlsx) file"
            )}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmitPaper} className="space-y-5">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <Select
                required
                label={t("कक्षा एवं विषय", "Class & Subject")}
                value={subjectId}
                onChange={(e) => {
                  setSubjectId(e.target.value);
                  setChapterId("");
                }}
                options={subjects.map((s) => ({
                  value: s.id,
                  label: `${t(`कक्षा ${s.class_num}`, `Class ${s.class_num}`)} · ${t(
                    s.name_hi,
                    s.name_en
                  )}${s.isAssigned ? ` (${t("मेरा विषय", "My Subject")})` : ""}`,
                }))}
              />

              <Select
                label={t("अध्याय (वैकल्पिक)", "Chapter (Optional)")}
                value={chapterId}
                onChange={(e) => setChapterId(e.target.value)}
                options={[
                  { value: "", label: t("संपूर्ण विषय / एकाधिक अध्याय", "Full Subject / Multiple Chapters") },
                  ...(currentSubject?.chapters ?? []).map((c) => ({
                    value: c.id,
                    label: `${t(`अध्याय ${c.chapter_no}`, `Ch. ${c.chapter_no}`)}: ${t(
                      c.title_hi,
                      c.title_en
                    )}`,
                  })),
                ]}
              />
            </div>

            <Input
              label={t("विषय-वस्तु / परीक्षा वर्ष टिप्पणी (वैकल्पिक)", "Topic or Exam Context (Optional)")}
              placeholder={t(
                "उदाहरण: अर्धवार्षिक परीक्षा 2026 — वस्तुनिष्ठ एवं लघु उत्तरीय प्रश्न",
                "e.g., Half-Yearly Exam 2026 — Objective & Short-Answer Set"
              )}
              value={topicHint}
              onChange={(e) => setTopicHint(e.target.value)}
            />

            {/* Source File Type Picker */}
            <div className="space-y-2">
              <p className="text-sm font-semibold text-ink">
                {t("दस्तावेज़ का प्रकार चुनें", "Select Document Format")}
              </p>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5">
                {(
                  [
                    { id: "SCANNED_PDF", hi: "PDF फ़ाइल", en: "Scanned PDF", Icon: FileText },
                    { id: "IMAGE", hi: "फ़ोटो / चित्र", en: "Photo / Image", Icon: ImageIcon },
                    { id: "WORD", hi: "Word (.docx)", en: "Word (.docx)", Icon: FileText },
                    { id: "EXCEL", hi: "Excel (.xlsx)", en: "Excel (.xlsx)", Icon: FileSpreadsheet },
                  ] as const
                ).map(({ id, hi, en, Icon }) => {
                  const active = sourceType === id;
                  return (
                    <button
                      key={id}
                      type="button"
                      onClick={() => {
                        setSourceType(id);
                        setUploadedFile(null);
                      }}
                      className={`flex items-center justify-center gap-2 rounded-lg border px-3 py-2.5 text-xs sm:text-sm font-semibold transition-colors min-h-[46px] ${
                        active
                          ? "border-indigo-academic bg-indigo-soft text-indigo-ink"
                          : "border-hairline bg-surface text-ink-secondary hover:bg-surface-subtle"
                      }`}
                    >
                      <Icon className="h-4 w-4 shrink-0" />
                      <span>{t(hi, en)}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            <ResumableFileUploader
              purpose="EDITORIAL_SUBMISSION"
              accept={SOURCE_CONFIG[sourceType].accept}
              allowedMimes={SOURCE_CONFIG[sourceType].mimes}
              maxSizeMb={SOURCE_CONFIG[sourceType].maxMb}
              labelHi={SOURCE_CONFIG[sourceType].titleHi}
              labelEn={SOURCE_CONFIG[sourceType].titleEn}
              hintHi={SOURCE_CONFIG[sourceType].hintHi}
              hintEn={SOURCE_CONFIG[sourceType].hintEn}
              value={uploadedFile}
              onUploaded={setUploadedFile}
            />

            <div className="flex justify-end">
              <Button
                type="submit"
                variant="primary"
                size="lg"
                loading={submitting}
                disabled={!uploadedFile}
                leftIcon={<Send className="h-4 w-4" />}
              >
                {t("समीक्षा के लिए भेजें", "Submit for Editorial Review")}
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>

      {/* Clean Editorial Review History */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">
            {t("आपके योगदान का इतिहास", "Your Submission History")}
          </CardTitle>
          <CardDescription>
            {t(
              "संपादकीय समीक्षा स्थिति और प्रकाशित प्रश्नों की जानकारी",
              "Track editorial review status and published question counts"
            )}
          </CardDescription>
        </CardHeader>
        <CardContent>
          {submissions.length === 0 ? (
            <div className="rounded-lg border border-hairline bg-surface-subtle/50 p-8 text-center">
              <p className="text-sm font-semibold text-ink">
                {t("अभी तक कोई प्रश्न पत्र नहीं भेजा गया है", "No question papers submitted yet")}
              </p>
              <p className="mt-1 text-xs text-ink-secondary">
                {t(
                  "ऊपर दिए गए फ़ॉर्म से अपना पहला प्रश्न पत्र योगदान करें।",
                  "Use the form above to submit your first question paper for review."
                )}
              </p>
            </div>
          ) : (
            <div className="space-y-3">
              {submissions.map((sub) => (
                <div
                  key={sub.id}
                  className="rounded-lg border border-hairline bg-surface-subtle/35 p-4 space-y-2"
                >
                  <div className="flex flex-wrap items-center justify-between gap-2">
                    <div className="flex flex-wrap items-center gap-2">
                      {sub.subject && (
                        <Badge variant="indigo">
                          {t(`कक्षा ${sub.subject.classNum}`, `Class ${sub.subject.classNum}`)} ·{" "}
                          {t(sub.subject.nameHi, sub.subject.nameEn)}
                        </Badge>
                      )}
                      {sub.chapter && (
                        <span className="text-xs text-ink-secondary">
                          {t(`अध्याय ${sub.chapter.chapterNo}`, `Ch. ${sub.chapter.chapterNo}`)}
                        </span>
                      )}
                    </div>

                    <Badge
                      variant={
                        sub.editorialStatus === "PUBLISHED"
                          ? "emerald"
                          : sub.editorialStatus === "FEEDBACK_RECEIVED"
                          ? "amber"
                          : sub.editorialStatus === "UNDER_REVIEW"
                          ? "indigo"
                          : "neutral"
                      }
                      icon={
                        sub.editorialStatus === "PUBLISHED" ? (
                          <CheckCircle2 className="h-3 w-3" />
                        ) : (
                          <Clock className="h-3 w-3" />
                        )
                      }
                    >
                      {t(sub.statusLabelHi, sub.statusLabelEn)}
                    </Badge>
                  </div>

                  <p className="text-sm font-semibold text-ink">
                    {sub.topicHint || sub.fileName || t("प्रश्न पत्र", "Question Paper")}
                  </p>

                  <p className="text-xs text-ink-muted">
                    {sub.fileName ? `${sub.fileName} · ` : ""}
                    {t("प्रेषित तिथि", "Submitted")}:{" "}
                    {new Date(sub.createdAt).toLocaleDateString(
                      lang === "EN" ? "en-IN" : "hi-IN",
                      { day: "numeric", month: "short", year: "numeric" }
                    )}
                  </p>

                  {sub.reviewFeedback && (
                    <div className="rounded-md border border-amber-warm/30 bg-surface-warm px-3 py-2 text-xs text-amber-ink flex items-start gap-2">
                      <MessageCircle className="h-4 w-4 shrink-0 mt-0.5" />
                      <div>
                        <strong>{t("संपादकीय टिप्पणी: ", "Editorial Note: ")}</strong>
                        {sub.reviewFeedback}
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
