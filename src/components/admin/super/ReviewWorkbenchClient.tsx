"use client";

import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  AlertTriangle,
  CheckCircle2,
  Copy,
  FileSearch,
  Sparkles,
  Trash2,
  XCircle,
} from "lucide-react";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
  Input,
  Select,
  useToast,
} from "@/components/ui";
import type { AiExtractedQuestionDraft, AiExtractionProgress } from "@/types/database";

interface SubmissionItem {
  id: string;
  schoolUdise: string;
  schoolName: string;
  districtName: string;
  teacherName: string;
  teacherCode: string;
  subjectId: string;
  subjectNameEn: string;
  subjectNameHi: string;
  classNum: number | null;
  chapterId: string | null;
  chapterTitleEn: string | null;
  topicHint: string | null;
  sourceType: "SCANNED_PDF" | "EXCEL" | "WORD" | "IMAGE";
  mediaObjectId: string;
  mediaFilename: string;
  mediaMimeType: string;
  status: "PENDING" | "AI_PARSING" | "AI_READY" | "APPROVED" | "REJECTED";
  aiExtractedJson: AiExtractedQuestionDraft[];
  aiProgressJson: AiExtractionProgress | null;
  aiModelUsed: string | null;
  reviewFeedback: string | null;
  approvedCount: number;
  createdAt: string;
}

interface ChapterOption {
  id: string;
  subject_id: string;
  chapter_no: number;
  title_en: string;
  title_hi: string;
}

export function ReviewWorkbenchClient() {
  const toast = useToast();

  const [submissions, setSubmissions] = useState<SubmissionItem[]>([]);
  const [chapters, setChapters] = useState<ChapterOption[]>([]);
  const [loading, setLoading] = useState(true);
  const [statusFilter, setStatusFilter] = useState("");

  const [activeId, setActiveId] = useState<string | null>(null);
  const [drafts, setDrafts] = useState<AiExtractedQuestionDraft[]>([]);
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [targetChapterId, setTargetChapterId] = useState("");
  const [bankPool, setBankPool] = useState<"PRACTICE" | "EXAM_ONLY">("PRACTICE");
  const [rejectFeedback, setRejectFeedback] = useState("");
  const [fromPage, setFromPage] = useState(1);
  const [toPage, setToPage] = useState(5);

  const [extracting, setExtracting] = useState(false);
  const [publishing, setPublishing] = useState(false);

  const loadQueue = useCallback(async () => {
    setLoading(true);
    try {
      const qs = statusFilter ? `?status=${statusFilter}` : "";
      const res = await fetch(`/api/super-admin/submissions${qs}`, { cache: "no-store" });
      if (!res.ok) throw new Error();
      const json = (await res.json()) as {
        submissions: SubmissionItem[];
        chapters: ChapterOption[];
      };
      setSubmissions(json.submissions);
      setChapters(json.chapters);
    } catch {
      toast.error("Failed to load submission review queue");
    } finally {
      setLoading(false);
    }
  }, [statusFilter, toast]);

  useEffect(() => {
    void loadQueue();
  }, [loadQueue]);

  const activeSub = useMemo(
    () => submissions.find((s) => s.id === activeId) ?? null,
    [submissions, activeId]
  );

  const openSubmission = (sub: SubmissionItem) => {
    setActiveId(sub.id);
    setDrafts(sub.aiExtractedJson ?? []);
    setSelectedIds(new Set((sub.aiExtractedJson ?? []).map((q) => q.temp_id)));
    setTargetChapterId(sub.chapterId ?? "");
    setRejectFeedback(sub.reviewFeedback ?? "");
    const nextStart = (sub.aiProgressJson?.processed_pages ?? 0) + 1;
    setFromPage(nextStart);
    setToPage(nextStart + 4);
  };

  const subjectChapters = useMemo(() => {
    if (!activeSub) return [];
    return chapters.filter((c) => c.subject_id === activeSub.subjectId);
  }, [activeSub, chapters]);

  const runExtractionChunk = async () => {
    if (!activeSub) return;
    setExtracting(true);
    try {
      const res = await fetch(
        `/api/super-admin/submissions/${activeSub.id}/extract?fromPage=${fromPage}&toPage=${toPage}`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
          },
          body: JSON.stringify({ fromPage, toPage }),
        }
      );
      const json = (await res.json()) as {
        ok?: boolean;
        chunkExtractedCount?: number;
        questions?: AiExtractedQuestionDraft[];
        nextFromPage?: number | null;
        error?: string;
      };
      if (!res.ok || !json.ok) {
        toast.error("Extraction failed", json.error);
        return;
      }
      const nextList = json.questions ?? [];
      setDrafts(nextList);
      setSelectedIds(new Set(nextList.map((q) => q.temp_id)));
      if (json.nextFromPage) {
        setFromPage(json.nextFromPage);
        setToPage(json.nextFromPage + 4);
      }
      toast.success(
        `Extracted ${json.chunkExtractedCount ?? 0} questions cleanly`,
        `Total staged drafts: ${nextList.length}`
      );
      await loadQueue();
    } catch {
      toast.error("Network error during Gemini chunk extraction");
    } finally {
      setExtracting(false);
    }
  };

  const updateDraftField = (
    tempId: string,
    field: keyof AiExtractedQuestionDraft,
    value: unknown
  ) => {
    setDrafts((prev) =>
      prev.map((q) => (q.temp_id === tempId ? { ...q, [field]: value } : q))
    );
  };

  const removeDraft = (tempId: string) => {
    setDrafts((prev) => prev.filter((q) => q.temp_id !== tempId));
    setSelectedIds((prev) => {
      const next = new Set(prev);
      next.delete(tempId);
      return next;
    });
  };

  const toggleSelect = (tempId: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(tempId)) next.delete(tempId);
      else next.add(tempId);
      return next;
    });
  };

  const handlePublish = async () => {
    if (!activeSub) return;
    if (!targetChapterId) {
      toast.warning("Select a target BSEB chapter before publishing.");
      return;
    }
    const chosen = drafts.filter((d) => selectedIds.has(d.temp_id));
    if (chosen.length === 0) {
      toast.warning("Select at least one question to publish.");
      return;
    }

    setPublishing(true);
    try {
      const res = await fetch(`/api/super-admin/submissions/${activeSub.id}/publish`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          action: "APPROVE",
          chapterId: targetChapterId,
          defaultBankPool: bankPool,
          questions: chosen.map((q) => ({
            question_type: q.question_type,
            difficulty_tier: q.difficulty_tier,
            topic_tag: q.topic_tag ?? null,
            exam_year_tag: q.exam_year_tag ?? null,
            q_hi: q.q_hi,
            q_en: q.q_en,
            options_json: q.options_json ?? null,
            correct_option: q.correct_option ?? null,
            clue_hi: q.clue_hi ?? null,
            clue_en: q.clue_en ?? null,
            explanation_hi: q.explanation_hi ?? null,
            explanation_en: q.explanation_en ?? null,
            model_answer_hi: q.model_answer_hi ?? null,
            model_answer_en: q.model_answer_en ?? null,
            marking_scheme_json: q.marking_scheme_json ?? [],
          })),
        }),
      });
      const json = (await res.json()) as {
        ok?: boolean;
        publishedCount?: number;
        error?: string;
      };
      if (!res.ok || !json.ok) {
        toast.error("Publish failed", json.error);
        return;
      }
      toast.success(`Published ${json.publishedCount ?? chosen.length} questions into ${bankPool}`);
      setActiveId(null);
      await loadQueue();
    } finally {
      setPublishing(false);
    }
  };

  const handleReject = async () => {
    if (!activeSub) return;
    if (rejectFeedback.trim().length < 5) {
      toast.warning("Enter constructive feedback for the teacher before rejecting.");
      return;
    }
    setPublishing(true);
    try {
      const res = await fetch(`/api/super-admin/submissions/${activeSub.id}/publish`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          action: "REJECT",
          reviewFeedback: rejectFeedback.trim(),
        }),
      });
      if (!res.ok) {
        toast.error("Failed to reject submission");
        return;
      }
      toast.success("Submission marked rejected with feedback");
      setActiveId(null);
      await loadQueue();
    } finally {
      setPublishing(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <Badge variant="indigo">Private Editorial AI Workbench (Gemini 2.5 Flash)</Badge>
          <h1 className="mt-2 text-2xl font-bold text-ink">
            Side-by-Side Question Extraction & Review
          </h1>
          <p className="mt-1 text-sm text-ink-secondary">
            Process scanned PDFs in 5-page chunks, verify OCR/duplicate warnings, edit bilingual wording, and publish into Practice or Exam-Only pools.
          </p>
        </div>
        <Select
          containerClassName="w-full sm:w-52"
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          options={[
            { value: "", label: "All Statuses" },
            { value: "PENDING", label: "Pending Extraction" },
            { value: "AI_READY", label: "Ready for Review" },
            { value: "APPROVED", label: "Published" },
            { value: "REJECTED", label: "Rejected" },
          ]}
        />
      </div>

      {/* Queue List when no item opened */}
      {!activeSub ? (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileSearch className="h-5 w-5 text-indigo-ink" />
              Teacher Question Paper Queue ({submissions.length})
            </CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-28 rounded-lg bg-surface-subtle animate-pulse" />
            ) : submissions.length === 0 ? (
              <p className="py-10 text-center text-sm text-ink-muted">
                No teacher submissions match this filter.
              </p>
            ) : (
              <div className="divide-y divide-hairline">
                {submissions.map((sub) => (
                  <div
                    key={sub.id}
                    className="py-4 flex flex-col md:flex-row md:items-center justify-between gap-3"
                  >
                    <div className="space-y-1">
                      <div className="flex flex-wrap items-center gap-2">
                        <span className="font-bold text-ink">{sub.mediaFilename}</span>
                        <Badge variant="outline">{sub.sourceType}</Badge>
                        <Badge
                          variant={
                            sub.status === "APPROVED"
                              ? "emerald"
                              : sub.status === "AI_READY"
                              ? "indigo"
                              : sub.status === "REJECTED"
                              ? "crimson"
                              : "amber"
                          }
                        >
                          {sub.status}
                        </Badge>
                      </div>
                      <p className="text-xs text-ink-secondary">
                        {sub.subjectNameEn} {sub.classNum ? `(Class ${sub.classNum})` : ""} ·{" "}
                        {sub.teacherName} — {sub.schoolName}
                      </p>
                    </div>
                    <Button
                      variant="primary"
                      size="sm"
                      onClick={() => openSubmission(sub)}
                    >
                      Open Side-by-Side Workbench
                    </Button>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      ) : (
        /* Side-by-Side Split Workbench */
        <div className="space-y-4">
          <div className="flex flex-wrap items-center justify-between gap-3 rounded-paper border border-hairline bg-surface p-4">
            <div>
              <p className="text-sm font-bold text-ink">{activeSub.mediaFilename}</p>
              <p className="text-xs text-ink-secondary">
                {activeSub.subjectNameEn} · Submitted by {activeSub.teacherName} ({activeSub.schoolName})
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              {activeSub.sourceType === "SCANNED_PDF" && (
                <>
                  <Input
                    type="number"
                    min={1}
                    containerClassName="w-20"
                    value={String(fromPage)}
                    onChange={(e) => setFromPage(Math.max(1, Number(e.target.value) || 1))}
                    aria-label="From page"
                  />
                  <span className="text-xs text-ink-muted">to</span>
                  <Input
                    type="number"
                    min={fromPage}
                    containerClassName="w-20"
                    value={String(toPage)}
                    onChange={(e) =>
                      setToPage(Math.max(fromPage, Math.min(fromPage + 4, Number(e.target.value) || fromPage)))
                    }
                    aria-label="To page"
                  />
                </>
              )}
              <Button
                variant="primary"
                size="sm"
                loading={extracting}
                leftIcon={<Sparkles className="h-4 w-4" />}
                onClick={runExtractionChunk}
              >
                {activeSub.sourceType === "SCANNED_PDF"
                  ? `Extract Pages ${fromPage}–${toPage}`
                  : "Run Gemini Structuring"}
              </Button>
              <Button variant="secondary" size="sm" onClick={() => setActiveId(null)}>
                Back to Queue
              </Button>
            </div>
          </div>

          <div className="grid grid-cols-1 xl:grid-cols-12 gap-5">
            {/* LEFT: Source Document Preview via private /api/admin-media/[id] */}
            <Card className="xl:col-span-5" padding="sm">
              <CardHeader className="pb-2">
                <CardTitle className="text-sm">Original Source Document</CardTitle>
                <CardDescription className="text-xs">
                  Private Super-Admin stream (`no-store`)
                  {activeSub.aiProgressJson?.total_pages
                    ? ` · Processed ${activeSub.aiProgressJson.processed_pages}/${activeSub.aiProgressJson.total_pages} pages`
                    : ""}
                </CardDescription>
              </CardHeader>
              <CardContent className="pt-3">
                {activeSub.mediaMimeType === "application/pdf" ? (
                  <iframe
                    src={`/api/admin-media/${activeSub.mediaObjectId}`}
                    title="Submitted PDF Preview"
                    className="w-full h-[640px] rounded-lg border border-hairline bg-surface-subtle"
                  />
                ) : activeSub.mediaMimeType.startsWith("image/") ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={`/api/admin-media/${activeSub.mediaObjectId}`}
                    alt={activeSub.mediaFilename}
                    className="w-full max-h-[640px] object-contain rounded-lg border border-hairline"
                  />
                ) : (
                  <div className="py-12 text-center space-y-3">
                    <p className="text-sm text-ink-secondary">
                      Office file ({activeSub.sourceType}) — click &quot;Run Gemini Structuring&quot; above or download to inspect locally.
                    </p>
                    <a
                      href={`/api/admin-media/${activeSub.mediaObjectId}?download=1`}
                      className="inline-flex items-center gap-2 text-sm font-semibold text-indigo-ink underline"
                    >
                      Download Source File
                    </a>
                  </div>
                )}
              </CardContent>
            </Card>

            {/* RIGHT: Editable Bilingual Drafts & Publish Controls */}
            <div className="xl:col-span-7 space-y-4">
              <Card padding="sm">
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  <Select
                    label="Target BSEB Chapter *"
                    value={targetChapterId}
                    onChange={(e) => setTargetChapterId(e.target.value)}
                    placeholder="Select chapter..."
                    options={subjectChapters.map((c) => ({
                      value: c.id,
                      label: `Ch ${c.chapter_no}: ${c.title_en}`,
                    }))}
                  />
                  <Select
                    label="Destination Pool"
                    value={bankPool}
                    onChange={(e) => setBankPool(e.target.value as "PRACTICE" | "EXAM_ONLY")}
                    options={[
                      { value: "PRACTICE", label: "Student Practice Bank" },
                      { value: "EXAM_ONLY", label: "Teacher Exam-Only Pool" },
                    ]}
                  />
                  <div className="flex items-end">
                    <Button
                      variant="emerald"
                      fullWidth
                      loading={publishing}
                      disabled={selectedIds.size === 0 || !targetChapterId}
                      leftIcon={<CheckCircle2 className="h-4 w-4" />}
                      onClick={handlePublish}
                    >
                      Publish ({selectedIds.size})
                    </Button>
                  </div>
                </div>
              </Card>

              <div className="space-y-3 max-h-[560px] overflow-y-auto pr-1">
                {drafts.length === 0 ? (
                  <Card>
                    <p className="py-10 text-center text-sm text-ink-muted">
                      No structured questions yet. Click &quot;Extract&quot; above to run Gemini 2.5 Flash on this submission.
                    </p>
                  </Card>
                ) : (
                  drafts.map((q, idx) => {
                    const isSelected = selectedIds.has(q.temp_id);
                    return (
                      <Card
                        key={q.temp_id}
                        padding="sm"
                        variant={q.confidence === "LOW" || q.ocr_warning ? "warm" : "default"}
                      >
                        <div className="space-y-3">
                          <div className="flex flex-wrap items-center justify-between gap-2">
                            <label className="flex items-center gap-2 text-xs font-bold text-ink cursor-pointer">
                              <input
                                type="checkbox"
                                checked={isSelected}
                                onChange={() => toggleSelect(q.temp_id)}
                                className="h-4 w-4"
                              />
                              <span>Q#{idx + 1}</span>
                              <Badge variant="outline">{q.question_type}</Badge>
                              <Badge variant="indigo">{q.difficulty_tier}</Badge>
                              <Badge
                                variant={
                                  q.confidence === "HIGH"
                                    ? "emerald"
                                    : q.confidence === "MEDIUM"
                                    ? "amber"
                                    : "crimson"
                                }
                              >
                                {q.confidence}
                              </Badge>
                              {q.duplicate_question_id && (
                                <Badge variant="crimson" icon={<Copy className="h-3 w-3" />}>
                                  Possible Duplicate (
                                  {Math.round((q.duplicate_similarity ?? 0) * 100)}%)
                                </Badge>
                              )}
                            </label>
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={() => removeDraft(q.temp_id)}
                              leftIcon={<Trash2 className="h-3.5 w-3.5" />}
                            >
                              Drop
                            </Button>
                          </div>

                          {q.ocr_warning && (
                            <div className="flex items-start gap-2 rounded-md bg-amber-soft px-2.5 py-1.5 text-xs text-amber-ink">
                              <AlertTriangle className="h-4 w-4 shrink-0 mt-0.5" />
                              <span>{q.ocr_warning}</span>
                            </div>
                          )}

                          <div className="grid grid-cols-1 md:grid-cols-2 gap-2.5">
                            <div>
                              <label className="text-[11px] font-semibold text-ink-secondary">
                                Hindi Question
                              </label>
                              <textarea
                                rows={2}
                                value={q.q_hi}
                                onChange={(e) => updateDraftField(q.temp_id, "q_hi", e.target.value)}
                                className="mt-1 w-full rounded-md border border-hairline-strong bg-surface p-2 text-xs text-ink"
                              />
                            </div>
                            <div>
                              <label className="text-[11px] font-semibold text-ink-secondary">
                                English Question
                              </label>
                              <textarea
                                rows={2}
                                value={q.q_en}
                                onChange={(e) => updateDraftField(q.temp_id, "q_en", e.target.value)}
                                className="mt-1 w-full rounded-md border border-hairline-strong bg-surface p-2 text-xs text-ink"
                              />
                            </div>
                          </div>

                          {q.question_type === "MCQ" && q.options_json && (
                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-1.5 text-xs">
                              {q.options_json.map((opt) => (
                                <div
                                  key={opt.key}
                                  className={`rounded-md border px-2.5 py-1.5 ${
                                    q.correct_option === opt.key
                                      ? "border-emerald-mastery bg-emerald-soft font-semibold text-emerald-ink"
                                      : "border-hairline bg-surface-subtle text-ink-secondary"
                                  }`}
                                >
                                  ({opt.key}) {opt.text_hi} / {opt.text_en}
                                </div>
                              ))}
                            </div>
                          )}
                        </div>
                      </Card>
                    );
                  })
                )}
              </div>

              {/* Reject Section */}
              <Card padding="sm" variant="subtle">
                <div className="flex flex-col sm:flex-row gap-2.5">
                  <Input
                    placeholder="Optional polite feedback if rejecting submission..."
                    value={rejectFeedback}
                    onChange={(e) => setRejectFeedback(e.target.value)}
                  />
                  <Button
                    variant="danger"
                    size="sm"
                    loading={publishing}
                    leftIcon={<XCircle className="h-4 w-4" />}
                    onClick={handleReject}
                    className="shrink-0"
                  >
                    Reject with Feedback
                  </Button>
                </div>
              </Card>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
