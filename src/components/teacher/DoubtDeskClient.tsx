"use client";

import React, { useCallback, useEffect, useState } from "react";
import {
  CheckCircle2,
  EyeOff,
  Loader2,
  MessageSquareMore,
  Pin,
  PinOff,
  Send,
  ShieldCheck,
  ThumbsUp,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card, CardContent, CardHeader } from "@/components/ui/Card";
import { MathMarkdown } from "@/components/ui/MathMarkdown";
import { Select } from "@/components/ui/Select";
import { Tabs } from "@/components/ui/Tabs";
import { useToast } from "@/components/ui/Toast";
import { SafeMediaViewer } from "@/components/visual/SafeMediaViewer";
import {
  ResumableFileUploader,
  type UploadedFileResult,
} from "@/components/teacher/ResumableFileUploader";
import type { DoubtStatus } from "@/types/database";

interface DoubtAnswerItem {
  id: string;
  answerText: string;
  createdAt: string;
  teacher: {
    id: string;
    fullName: string;
    teacherTitle: string | null;
  };
  media: {
    id: string;
    url: string;
    fileName: string;
    mimeType: string;
    sizeBytes: number;
  } | null;
}

interface DoubtItem {
  id: string;
  classNum: number;
  subjectId: string;
  subject: { id: string; classNum: number; nameHi: string; nameEn: string } | null;
  chapter: { id: string; chapterNo: number; titleHi: string; titleEn: string } | null;
  student: {
    name: string;
    classNum: number;
    rollNo: number | null;
    section: string;
  };
  inMySubjects?: boolean;
  questionText: string;
  media: {
    id: string;
    url: string;
    fileName: string;
    mimeType: string;
    sizeBytes: number;
  } | null;
  status: DoubtStatus;
  isPinned: boolean;
  upvoteCount: number;
  answers: DoubtAnswerItem[];
  createdAt: string;
}

export function DoubtDeskClient() {
  const { t, lang } = useLanguage();
  const toast = useToast();

  const [scope, setScope] = useState<"my" | "all">("my");
  const [statusFilter, setStatusFilter] = useState<string>("");
  const [classNum, setClassNum] = useState<string>("");
  const [doubts, setDoubts] = useState<DoubtItem[]>([]);
  const [counts, setCounts] = useState({ myUnansweredCount: 0, allUnansweredCount: 0 });
  const [loading, setLoading] = useState(true);

  // Per-doubt reply composer state
  const [openComposerId, setOpenComposerId] = useState<string | null>(null);
  const [replyText, setReplyText] = useState("");
  const [replyFile, setReplyFile] = useState<UploadedFileResult | null>(null);
  const [markResolved, setMarkResolved] = useState(false);
  const [submittingId, setSubmittingId] = useState<string | null>(null);
  const [moderatingId, setModeratingId] = useState<string | null>(null);

  const loadDoubts = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({ scope, sort: "priority" });
      if (statusFilter) params.set("status", statusFilter);
      if (classNum) params.set("classNum", classNum);

      const res = await fetch(`/api/collab/doubts?${params.toString()}`, {
        cache: "no-store",
      });
      const json = (await res.json()) as {
        ok?: boolean;
        doubts?: DoubtItem[];
        counts?: { myUnansweredCount: number; allUnansweredCount: number };
      };

      if (res.ok && json.ok) {
        setDoubts(json.doubts ?? []);
        if (json.counts) setCounts(json.counts);
      }
    } finally {
      setLoading(false);
    }
  }, [scope, statusFilter, classNum]);

  useEffect(() => {
    void loadDoubts();
  }, [loadDoubts]);

  const handleSubmitAnswer = async (doubtId: string) => {
    if (replyText.trim().length < 2) {
      toast.warning(t("कृपया स्पष्ट उत्तर लिखें।", "Please write a clear answer."));
      return;
    }

    setSubmittingId(doubtId);
    try {
      const res = await fetch(`/api/collab/doubts/${doubtId}/answers`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          answerText: replyText.trim(),
          mediaObjectId: replyFile?.mediaObjectId ?? null,
          markResolved,
        }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string; errorHi?: string };
      if (!res.ok || !json.ok) {
        throw new Error(lang === "EN" ? json.error : json.errorHi || json.error);
      }
      toast.success(
        t("आपका सत्यापित उत्तर पूरी कक्षा के लिए प्रकाशित हो गया!", "Official teacher answer published to the class!")
      );
      setReplyText("");
      setReplyFile(null);
      setMarkResolved(false);
      setOpenComposerId(null);
      await loadDoubts();
    } catch (err) {
      toast.error(
        t("उत्तर प्रकाशित नहीं हो सका", "Could not post answer"),
        err instanceof Error ? err.message : undefined
      );
    } finally {
      setSubmittingId(null);
    }
  };

  const handleModerate = async (
    doubtId: string,
    payload: { isPinned?: boolean; status?: DoubtStatus; isHidden?: boolean }
  ) => {
    setModeratingId(doubtId);
    try {
      const res = await fetch(`/api/collab/doubts/${doubtId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify(payload),
      });
      if (!res.ok) throw new Error("Failed");
      toast.success(
        payload.isHidden
          ? t("प्रश्न मंच से छिपा दिया गया", "Post hidden from board")
          : payload.status === "RESOLVED"
          ? t("प्रश्न समाधानित चिह्नित किया गया", "Marked as resolved")
          : t("परिवर्तन सहेजे गए", "Updated successfully")
      );
      await loadDoubts();
    } catch {
      toast.error(t("कार्रवाई असफल रही", "Action failed"));
    } finally {
      setModeratingId(null);
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="space-y-1.5 border-b border-hairline pb-5">
        <Badge variant="indigo" icon={<MessageSquareMore className="h-3.5 w-3.5" />}>
          {t("100% खुला कक्षा शंका मंच", "100% Open Class + Subject Doubt Board")}
        </Badge>
        <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
          {t("शंका समाधान डेस्क", "Open Classroom Doubt Desk")}
        </h1>
        <p className="text-sm text-ink-secondary max-w-2xl">
          {t(
            "सभी प्रश्न और उत्तर पूरी कक्षा के लिए खुले होते हैं — एक विद्यार्थी को दिया गया उत्तर उसी कक्षा के सभी विद्यार्थियों की मदद करता है।",
            "Every question and verified teacher answer is open to the entire class — answering once helps every student with the same doubt."
          )}
        </p>
      </div>

      {/* Scope Tabs (My Subjects + Zero-Black-Hole All School Doubts) + Filters */}
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        <Tabs
          variant="pills"
          value={scope}
          onChange={setScope}
          items={[
            {
              id: "my",
              label: t("मेरे विषय", "My Subjects"),
              count: counts.myUnansweredCount,
            },
            {
              id: "all",
              label: t("सभी विद्यालय प्रश्न (सहायता करें)", "All School Doubts — Help Out"),
              count: counts.allUnansweredCount,
            },
          ]}
        />

        <div className="grid grid-cols-2 gap-3 w-full lg:w-auto lg:min-w-[340px]">
          <Select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            options={[
              { value: "", label: t("सभी स्थिति", "All Statuses") },
              { value: "OPEN", label: t("अनुत्तरित (Open)", "Unanswered (Open)") },
              { value: "ANSWERED", label: t("उत्तरित", "Answered") },
              { value: "RESOLVED", label: t("समाधानित", "Resolved") },
            ]}
          />
          <Select
            value={classNum}
            onChange={(e) => setClassNum(e.target.value)}
            options={[
              { value: "", label: t("सभी कक्षाएँ", "All Classes") },
              { value: "9", label: t("कक्षा 9", "Class 9") },
              { value: "10", label: t("कक्षा 10", "Class 10") },
              { value: "11", label: t("कक्षा 11", "Class 11") },
              { value: "12", label: t("कक्षा 12", "Class 12") },
            ]}
          />
        </div>
      </div>

      {loading ? (
        <div className="flex min-h-[35vh] items-center justify-center">
          <div className="flex items-center gap-2 text-sm text-ink-secondary">
            <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
            <span>{t("प्रश्न लोड हो रहे हैं...", "Loading classroom doubts...")}</span>
          </div>
        </div>
      ) : doubts.length === 0 ? (
        <Card variant="subtle" className="py-10 text-center space-y-2">
          <CheckCircle2 className="mx-auto h-8 w-8 text-emerald-ink" />
          <p className="text-base font-bold text-ink">
            {t("इस श्रेणी में कोई प्रश्न प्रतीक्षारत नहीं है", "No doubts in this view")}
          </p>
          <p className="text-sm text-ink-secondary max-w-md mx-auto">
            {scope === "my" && counts.allUnansweredCount > 0
              ? t(
                  `अन्य विषयों के ${counts.allUnansweredCount} प्रश्न विद्यालय में प्रतीक्षारत हैं — सहायता के लिए 'सभी विद्यालय प्रश्न' टैब देखें।`,
                  `${counts.allUnansweredCount} open doubts exist in other school subjects — switch to 'All School Doubts' to help out.`
                )
              : t(
                  "विद्यार्थियों द्वारा पूछे जाने पर सभी कक्षा प्रश्न यहाँ प्राथमिकता क्रम में दिखेंगे।",
                  "Student doubts appear here sorted by 'Same Doubt (+1)' votes and oldest unanswered."
                )}
          </p>
        </Card>
      ) : (
        <div className="space-y-4">
          {doubts.map((doubt) => {
            const isReplying = openComposerId === doubt.id;
            return (
              <Card
                key={doubt.id}
                variant={doubt.status === "OPEN" ? "default" : "subtle"}
              >
                <CardHeader className="flex-col sm:flex-row sm:items-start justify-between gap-3">
                  <div className="space-y-2 min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      {doubt.isPinned && (
                        <Badge variant="amber" icon={<Pin className="h-3 w-3" />}>
                          {t("पिन", "Pinned")}
                        </Badge>
                      )}
                      <Badge
                        variant={
                          doubt.status === "OPEN"
                            ? "amber"
                            : doubt.status === "ANSWERED"
                            ? "indigo"
                            : "emerald"
                        }
                      >
                        {doubt.status === "OPEN"
                          ? t("उत्तर प्रतीक्षारत", "Needs Answer")
                          : doubt.status === "ANSWERED"
                          ? t("उत्तरित", "Answered")
                          : t("समाधानित", "Resolved")}
                      </Badge>
                      <Badge variant="indigo">
                        {t(`कक्षा ${doubt.classNum}`, `Class ${doubt.classNum}`)}
                        {doubt.subject
                          ? ` · ${t(doubt.subject.nameHi, doubt.subject.nameEn)}`
                          : ""}
                      </Badge>
                      {doubt.chapter && (
                        <span className="text-xs text-ink-muted">
                          {t(`अध्याय ${doubt.chapter.chapterNo}`, `Ch. ${doubt.chapter.chapterNo}`)}
                        </span>
                      )}
                      <Badge variant="outline" icon={<ThumbsUp className="h-3 w-3" />}>
                        {t("मेरा भी यही प्रश्न", "Same Doubt")}: {doubt.upvoteCount}
                      </Badge>
                    </div>

                    <p className="text-xs text-ink-secondary">
                      <strong className="text-ink">{doubt.student.name}</strong>
                      {doubt.student.rollNo
                        ? ` · ${t("रोल नं.", "Roll")} ${doubt.student.rollNo}`
                        : ""}{" "}
                      ·{" "}
                      {new Date(doubt.createdAt).toLocaleString(
                        lang === "EN" ? "en-IN" : "hi-IN",
                        { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" }
                      )}
                    </p>
                  </div>

                  {/* Moderation Controls */}
                  <div className="flex flex-wrap items-center gap-1.5 shrink-0">
                    <Button
                      size="sm"
                      variant="ghost"
                      disabled={moderatingId === doubt.id}
                      onClick={() =>
                        void handleModerate(doubt.id, { isPinned: !doubt.isPinned })
                      }
                      leftIcon={
                        doubt.isPinned ? (
                          <PinOff className="h-3.5 w-3.5" />
                        ) : (
                          <Pin className="h-3.5 w-3.5" />
                        )
                      }
                    >
                      {doubt.isPinned ? t("अनपिन", "Unpin") : t("पिन", "Pin")}
                    </Button>
                    {doubt.status !== "RESOLVED" && (
                      <Button
                        size="sm"
                        variant="ghost"
                        disabled={moderatingId === doubt.id}
                        onClick={() =>
                          void handleModerate(doubt.id, { status: "RESOLVED" })
                        }
                        leftIcon={<CheckCircle2 className="h-3.5 w-3.5 text-emerald-ink" />}
                      >
                        {t("समाधानित", "Resolve")}
                      </Button>
                    )}
                    <Button
                      size="sm"
                      variant="ghost"
                      disabled={moderatingId === doubt.id}
                      onClick={() =>
                        void handleModerate(doubt.id, { isHidden: true })
                      }
                      leftIcon={<EyeOff className="h-3.5 w-3.5 text-crimson-ink" />}
                    >
                      {t("छिपाएँ", "Hide")}
                    </Button>
                  </div>
                </CardHeader>

                <CardContent className="space-y-4">
                  {/* Student Question */}
                  <p className="text-[15px] text-ink leading-relaxed whitespace-pre-wrap">
                    {doubt.questionText}
                  </p>

                  {doubt.media && (
                    <SafeMediaViewer
                      kind="IMAGE"
                      mediaUrl={doubt.media.url}
                      fileName={doubt.media.fileName}
                      title={t("विद्यार्थी द्वारा संलग्न चित्र", "Student Attached Photo")}
                    />
                  )}

                  {/* Verified Teacher Answers */}
                  {doubt.answers.length > 0 && (
                    <div className="space-y-3 pt-2 border-t border-hairline">
                      {doubt.answers.map((ans) => (
                        <div
                          key={ans.id}
                          className="rounded-paper border border-emerald-mastery/25 bg-emerald-soft p-4 space-y-3"
                        >
                          <div className="flex flex-wrap items-center justify-between gap-2">
                            <span className="inline-flex items-center gap-1.5 text-xs font-bold text-emerald-ink">
                              <ShieldCheck className="h-4 w-4" />
                              {ans.teacher.fullName}
                              {ans.teacher.teacherTitle
                                ? ` · ${ans.teacher.teacherTitle}`
                                : ""}
                            </span>
                            <span className="text-xs text-ink-muted">
                              {new Date(ans.createdAt).toLocaleString(
                                lang === "EN" ? "en-IN" : "hi-IN",
                                {
                                  day: "numeric",
                                  month: "short",
                                  hour: "2-digit",
                                  minute: "2-digit",
                                }
                              )}
                            </span>
                          </div>
                          <MathMarkdown content={ans.answerText} />
                          {ans.media && (
                            <SafeMediaViewer
                              kind={
                                ans.media.mimeType === "application/pdf" ? "PDF" : "IMAGE"
                              }
                              mediaUrl={ans.media.url}
                              fileName={ans.media.fileName}
                              title={t("शिक्षक समाधान फ़ाइल", "Teacher Solution Attachment")}
                            />
                          )}
                        </div>
                      ))}
                    </div>
                  )}

                  {/* Official Teacher Reply Composer */}
                  {!isReplying ? (
                    <div className="pt-1">
                      <Button
                        size="sm"
                        variant={doubt.answers.length === 0 ? "primary" : "secondary"}
                        onClick={() => {
                          setOpenComposerId(doubt.id);
                          setReplyText("");
                          setReplyFile(null);
                          setMarkResolved(false);
                        }}
                        leftIcon={<Send className="h-3.5 w-3.5" />}
                      >
                        {doubt.answers.length === 0
                          ? t("आधिकारिक उत्तर लिखें", "Write Official Answer")
                          : t("अतिरिक्त व्याख्या जोड़ें", "Add Follow-up Explanation")}
                      </Button>
                    </div>
                  ) : (
                    <div className="rounded-paper border border-indigo-academic/30 bg-surface p-4 space-y-4">
                      <div className="space-y-1.5">
                        <label className="text-sm font-semibold text-ink">
                          {t(
                            "आपका सत्यापित उत्तर (सूत्रों के लिए $...$ लिख सकते हैं)",
                            "Your Verified Answer ($...$ math formulas supported)"
                          )}
                        </label>
                        <textarea
                          rows={4}
                          value={replyText}
                          onChange={(e) => setReplyText(e.target.value)}
                          placeholder={t(
                            "सरल और स्पष्ट चरण-दर-चरण उत्तर लिखें ताकि पूरी कक्षा समझ सके...",
                            "Write a clear step-by-step explanation for the whole class..."
                          )}
                          className="w-full rounded-lg border border-hairline-strong bg-surface px-3.5 py-2.5 text-sm text-ink placeholder:text-ink-muted focus:border-indigo-academic focus:ring-2 focus:ring-indigo-academic/20 focus:outline-none"
                        />
                      </div>

                      <ResumableFileUploader
                        purpose="DOUBT_ANSWER"
                        accept="image/jpeg,image/png,image/webp,application/pdf"
                        allowedMimes={[
                          "image/jpeg",
                          "image/png",
                          "image/webp",
                          "application/pdf",
                        ]}
                        maxSizeMb={10}
                        labelHi="समाधान की कॉपी फ़ोटो या PDF संलग्न करें (वैकल्पिक)"
                        labelEn="Attach Solution Photo or PDF (Optional)"
                        hintHi="JPG, PNG, WEBP या PDF"
                        hintEn="JPG, PNG, WEBP, or PDF"
                        value={replyFile}
                        onUploaded={setReplyFile}
                      />

                      <div className="flex flex-wrap items-center justify-between gap-3">
                        <label className="flex items-center gap-2 text-sm text-ink cursor-pointer">
                          <input
                            type="checkbox"
                            checked={markResolved}
                            onChange={(e) => setMarkResolved(e.target.checked)}
                            className="h-4 w-4 rounded accent-indigo-academic"
                          />
                          <span>
                            {t("उत्तर के साथ समाधानित चिह्नित करें", "Mark doubt as Resolved")}
                          </span>
                        </label>

                        <div className="flex items-center gap-2">
                          <Button
                            size="sm"
                            variant="secondary"
                            disabled={submittingId === doubt.id}
                            onClick={() => setOpenComposerId(null)}
                          >
                            {t("रद्द करें", "Cancel")}
                          </Button>
                          <Button
                            size="sm"
                            variant="primary"
                            loading={submittingId === doubt.id}
                            onClick={() => void handleSubmitAnswer(doubt.id)}
                            leftIcon={<Send className="h-4 w-4" />}
                          >
                            {t("उत्तर प्रकाशित करें", "Publish Answer")}
                          </Button>
                        </div>
                      </div>
                    </div>
                  )}
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
