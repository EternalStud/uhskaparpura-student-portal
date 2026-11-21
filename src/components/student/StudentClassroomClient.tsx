"use client";

import React, { useCallback, useEffect, useState } from "react";
import {
  BookOpen,
  Camera,
  CheckCircle2,
  FileText,
  Film,
  Image as ImageIcon,
  MessageSquare,
  Pin,
  Send,
  ShieldCheck,
  ThumbsUp,
  Trash2,
  Users,
} from "lucide-react";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import {
  Badge,
  Button,
  Card,
  MathMarkdown,
  Select,
  useToast,
} from "@/components/ui";
import { SafeMediaViewer } from "@/components/visual";
import { cn } from "@/components/ui/cn";

interface EnrolledSubjectOption {
  id: string;
  name_hi: string;
  name_en: string;
  accent_color: string;
}

interface SafeMedia {
  id: string;
  url: string;
  fileName: string;
  mimeType: string;
  sizeBytes: number;
}

interface MaterialItem {
  id: string;
  subjectId: string;
  subject: { id: string; nameHi: string; nameEn: string; accentColor: string } | null;
  chapter: { id: string; chapterNo: number; titleHi: string; titleEn: string } | null;
  title: string;
  description: string | null;
  materialType: "NOTE" | "PDF" | "IMAGE" | "VIDEO_UPLOAD" | "VIDEO_YOUTUBE";
  bodyMarkdown: string | null;
  media: SafeMedia | null;
  youtubeVideoId: string | null;
  isPinned: boolean;
  teacher: { fullName: string; teacherTitle: string | null };
  createdAt: string;
}

interface DoubtAnswerItem {
  id: string;
  answerText: string;
  createdAt: string;
  teacher: { id: string; fullName: string; teacherTitle: string | null };
  media: SafeMedia | null;
}

interface DoubtItem {
  id: string;
  subjectId: string;
  subject: { id: string; nameHi: string; nameEn: string; accentColor: string } | null;
  chapter: { id: string; chapterNo: number; titleHi: string; titleEn: string } | null;
  student: { name: string; classNum: number; rollNo: number | null; section: string };
  isOwnDoubt: boolean;
  questionText: string;
  media: SafeMedia | null;
  status: "OPEN" | "ANSWERED" | "RESOLVED";
  isPinned: boolean;
  upvoteCount: number;
  hasUpvoted: boolean;
  answers: DoubtAnswerItem[];
  createdAt: string;
}

/**
 * Compresses a camera/gallery photo on the student's phone via HTML5 Canvas
 * to WebP (or JPEG fallback) <= 2 MB before uploading on rural 4G.
 */
async function compressDoubtImage(file: File): Promise<{ blob: Blob; mimeType: string; fileName: string }> {
  const MAX_BYTES = 2 * 1024 * 1024;
  const MAX_DIM = 1600;

  if (file.size <= MAX_BYTES && ["image/webp", "image/jpeg", "image/png"].includes(file.type)) {
    return { blob: file, mimeType: file.type, fileName: file.name };
  }

  const bitmap = await createImageBitmap(file);
  const scale = Math.min(1, MAX_DIM / Math.max(bitmap.width, bitmap.height));
  const targetW = Math.max(1, Math.round(bitmap.width * scale));
  const targetH = Math.max(1, Math.round(bitmap.height * scale));

  const canvas = document.createElement("canvas");
  canvas.width = targetW;
  canvas.height = targetH;
  const ctx = canvas.getContext("2d");
  if (!ctx) throw new Error("Canvas unavailable");
  ctx.drawImage(bitmap, 0, 0, targetW, targetH);
  bitmap.close();

  const tryEncode = (type: string, quality: number) =>
    new Promise<Blob | null>((resolve) => canvas.toBlob((b) => resolve(b), type, quality));

  let blob = await tryEncode("image/webp", 0.8);
  let mimeType = "image/webp";
  let ext = ".webp";

  if (!blob || blob.type !== "image/webp") {
    blob = await tryEncode("image/jpeg", 0.8);
    mimeType = "image/jpeg";
    ext = ".jpg";
  }
  if (blob && blob.size > MAX_BYTES) {
    blob = await tryEncode("image/jpeg", 0.62);
    mimeType = "image/jpeg";
    ext = ".jpg";
  }
  if (!blob || blob.size > MAX_BYTES) {
    throw new Error("Image remains over 2 MB after compression.");
  }

  const stem = file.name.replace(/\.[^.]+$/, "") || "doubt_photo";
  return { blob, mimeType, fileName: `${stem}${ext}` };
}

function formatShortDate(iso: string): string {
  try {
    return new Intl.DateTimeFormat("en-IN", {
      timeZone: "Asia/Kolkata",
      day: "2-digit",
      month: "short",
      hour: "2-digit",
      minute: "2-digit",
      hour12: true,
    }).format(new Date(iso));
  } catch {
    return "";
  }
}

export function StudentClassroomClient({
  enrolledSubjects,
  classNum,
  schoolName,
}: {
  enrolledSubjects: EnrolledSubjectOption[];
  classNum: number;
  schoolName: string;
}) {
  const { t } = useLanguage();
  const toast = useToast();

  const [activeTab, setActiveTab] = useState<"materials" | "doubts">("doubts");
  const [subjectFilter, setSubjectFilter] = useState<string>("");

  // Materials state
  const [materials, setMaterials] = useState<MaterialItem[]>([]);
  const [loadingMaterials, setLoadingMaterials] = useState(true);

  // Doubts state
  const [doubts, setDoubts] = useState<DoubtItem[]>([]);
  const [loadingDoubts, setLoadingDoubts] = useState(true);
  const [remainingToday, setRemainingToday] = useState<number>(5);
  const [sortBy, setSortBy] = useState<"recent" | "upvotes">("recent");

  // New doubt form
  const [newSubjectId, setNewSubjectId] = useState<string>(enrolledSubjects[0]?.id ?? "");
  const [newQuestion, setNewQuestion] = useState("");
  const [attachedMedia, setAttachedMedia] = useState<{ id: string; name: string } | null>(null);
  const [uploadingPhoto, setUploadingPhoto] = useState(false);
  const [postingDoubt, setPostingDoubt] = useState(false);

  const fetchMaterials = useCallback(async () => {
    setLoadingMaterials(true);
    try {
      const qs = new URLSearchParams();
      if (subjectFilter) qs.set("subjectId", subjectFilter);
      const res = await fetch(`/api/collab/materials?${qs.toString()}`, { cache: "no-store" });
      if (res.ok) {
        const json = (await res.json()) as { materials?: MaterialItem[] };
        setMaterials(json.materials ?? []);
      }
    } finally {
      setLoadingMaterials(false);
    }
  }, [subjectFilter]);

  const fetchDoubts = useCallback(async () => {
    setLoadingDoubts(true);
    try {
      const qs = new URLSearchParams();
      if (subjectFilter) qs.set("subjectId", subjectFilter);
      qs.set("sort", sortBy);
      const res = await fetch(`/api/collab/doubts?${qs.toString()}`, { cache: "no-store" });
      if (res.ok) {
        const json = (await res.json()) as {
          doubts?: DoubtItem[];
          remainingToday?: number;
        };
        setDoubts(json.doubts ?? []);
        if (typeof json.remainingToday === "number") {
          setRemainingToday(json.remainingToday);
        }
      }
    } finally {
      setLoadingDoubts(false);
    }
  }, [subjectFilter, sortBy]);

  useEffect(() => {
    fetchMaterials();
  }, [fetchMaterials]);

  useEffect(() => {
    fetchDoubts();
  }, [fetchDoubts]);

  const handlePhotoPick = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    e.target.value = "";
    if (!file) return;

    if (!file.type.startsWith("image/") || file.type === "image/svg+xml") {
      toast.error(
        t("केवल JPG, PNG या WEBP फ़ोटो चुनें।", "Please choose a JPG, PNG, or WEBP photo.")
      );
      return;
    }

    setUploadingPhoto(true);
    try {
      const compressed = await compressDoubtImage(file);

      // Step 1: Request single-use resumable upload URI
      const sessionRes = await fetch("/api/media/upload-session", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          fileName: compressed.fileName,
          mimeType: compressed.mimeType,
          sizeBytes: compressed.blob.size,
          purpose: "DOUBT",
        }),
      });
      const sessionJson = (await sessionRes.json()) as {
        mediaObjectId?: string;
        uploadUrl?: string;
        mimeType?: string;
        error?: string;
      };
      if (!sessionRes.ok || !sessionJson.uploadUrl || !sessionJson.mediaObjectId) {
        throw new Error(sessionJson.error ?? "Upload session unavailable.");
      }

      // Step 2: Direct PUT upload
      const putRes = await fetch(sessionJson.uploadUrl, {
        method: "PUT",
        headers: { "Content-Type": sessionJson.mimeType ?? compressed.mimeType },
        body: compressed.blob,
      });
      if (!putRes.ok) {
        throw new Error("Could not upload photo.");
      }
      const putJson = (await putRes.json()) as { id?: string };
      if (!putJson.id) {
        throw new Error("Upload confirmation missing.");
      }

      // Step 3: Server-side magic-byte finalization
      const finRes = await fetch("/api/media/finalize", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          mediaObjectId: sessionJson.mediaObjectId,
          driveFileId: putJson.id,
        }),
      });
      const finJson = (await finRes.json()) as { ok?: boolean; error?: string };
      if (!finRes.ok || !finJson.ok) {
        throw new Error(finJson.error ?? "Photo verification failed.");
      }

      setAttachedMedia({ id: sessionJson.mediaObjectId, name: compressed.fileName });
      toast.success(
        t("कॉपी/प्रश्न की फ़ोटो जुड़ गई!", "Photo attached successfully!")
      );
    } catch (err) {
      toast.error(
        t("फ़ोटो अपलोड नहीं हो सकी", "Photo could not be uploaded"),
        err instanceof Error ? err.message : undefined
      );
    } finally {
      setUploadingPhoto(false);
    }
  };

  const handlePostDoubt = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newSubjectId) {
      toast.error(t("कृपया विषय चुनें।", "Please select a subject."));
      return;
    }
    if (newQuestion.trim().length < 5) {
      toast.error(
        t("कृपया कम से कम 5 अक्षरों में स्पष्ट प्रश्न लिखें।", "Please write your question clearly (at least 5 characters).")
      );
      return;
    }

    setPostingDoubt(true);
    try {
      const res = await fetch("/api/collab/doubts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          subjectId: newSubjectId,
          questionText: newQuestion.trim(),
          mediaObjectId: attachedMedia?.id ?? null,
        }),
      });
      const json = (await res.json()) as {
        ok?: boolean;
        remainingToday?: number;
        error?: string;
        errorHi?: string;
      };
      if (!res.ok || !json.ok) {
        toast.error(t(json.errorHi ?? "प्रश्न पोस्ट नहीं हो सका।", json.error ?? "Could not post question."));
        return;
      }

      setNewQuestion("");
      setAttachedMedia(null);
      if (typeof json.remainingToday === "number") setRemainingToday(json.remainingToday);
      toast.success(
        t("आपका प्रश्न कक्षा मंच पर साझा हो गया!", "Your question is now posted on the class board!"),
        t("आपकी कक्षा के शिक्षक जल्द उत्तर देंगे।", "Your school teachers will answer it here.")
      );
      fetchDoubts();
    } finally {
      setPostingDoubt(false);
    }
  };

  const handleToggleUpvote = async (doubtId: string) => {
    const res = await fetch(`/api/collab/doubts/${encodeURIComponent(doubtId)}/upvote`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({}),
    });
    if (!res.ok) return;
    const json = (await res.json()) as {
      ok?: boolean;
      upvoted?: boolean;
      upvoteCount?: number;
    };
    if (json.ok) {
      setDoubts((prev) =>
        prev.map((d) =>
          d.id === doubtId
            ? {
                ...d,
                hasUpvoted: Boolean(json.upvoted),
                upvoteCount: json.upvoteCount ?? d.upvoteCount,
              }
            : d
        )
      );
    }
  };

  return (
    <div className="max-w-5xl mx-auto space-y-6 pb-12">
      {/* Header */}
      <div className="space-y-1.5">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant="indigo" icon={<Users className="h-3.5 w-3.5" />}>
            {t(`कक्षा ${classNum} · खुला विद्यालय मंच`, `Class ${classNum} · Open School Classroom`)}
          </Badge>
          {schoolName && <Badge variant="neutral">{schoolName}</Badge>}
        </div>
        <h1 className="text-2xl sm:text-3xl font-bold text-ink">
          <BiText hi="मेरी कक्षा व खुला प्रश्न मंच" en="My School Class & Open Doubt Board" />
        </h1>
        <p className="text-xs sm:text-sm text-ink-secondary">
          {t(
            "यहाँ अपने विद्यालय के शिक्षकों के नोट्स, वीडियो और खुला प्रश्न-उत्तर मंच मिलेगा। सभी प्रश्न व उत्तर पूरी कक्षा के लिए खुले और सुरक्षित हैं।",
            "View study notes and videos shared by your school teachers, and ask doubts on the 100% open Class+Subject Doubt Board."
          )}
        </p>
      </div>

      {/* Mode Switch + Subject Filter */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div className="inline-flex rounded-paper border border-hairline bg-surface p-1 gap-1">
          <button
            type="button"
            onClick={() => setActiveTab("doubts")}
            className={cn(
              "inline-flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-semibold transition-all",
              activeTab === "doubts"
                ? "bg-indigo-academic text-white shadow-paper"
                : "text-ink-secondary hover:text-ink"
            )}
          >
            <MessageSquare className="h-4 w-4" />
            {t("खुला प्रश्न मंच", "Open Doubt Board")}
          </button>
          <button
            type="button"
            onClick={() => setActiveTab("materials")}
            className={cn(
              "inline-flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-semibold transition-all",
              activeTab === "materials"
                ? "bg-indigo-academic text-white shadow-paper"
                : "text-ink-secondary hover:text-ink"
            )}
          >
            <BookOpen className="h-4 w-4" />
            {t("शिक्षक सामग्री", "Teacher Materials")}
            <span
              className={cn(
                "rounded-full px-1.5 py-0.5 text-[11px] font-bold",
                activeTab === "materials" ? "bg-white/20 text-white" : "bg-surface-subtle text-ink-secondary"
              )}
            >
              {materials.length}
            </span>
          </button>
        </div>

        <div className="w-full sm:w-64">
          <Select
            aria-label={t("विषय चुनें", "Filter by subject")}
            value={subjectFilter}
            onChange={(e) => setSubjectFilter(e.target.value)}
            options={[
              { value: "", label: t("सभी चुने गए विषय", "All Enrolled Subjects") },
              ...enrolledSubjects.map((s) => ({
                value: s.id,
                label: t(s.name_hi, s.name_en),
              })),
            ]}
          />
        </div>
      </div>

      {/* ==================== TAB 1: OPEN DOUBT BOARD ==================== */}
      {activeTab === "doubts" && (
        <div className="space-y-6">
          {/* Ask Open Doubt Composer */}
          <Card padding="lg" className="space-y-4">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <h2 className="text-base font-bold text-ink flex items-center gap-2">
                <MessageSquare className="h-4 w-4 text-indigo-ink" />
                {t("अपना प्रश्न कक्षा मंच पर पूछें", "Ask a Question on the Open Class Board")}
              </h2>
              <Badge variant={remainingToday > 0 ? "indigo" : "amber"}>
                {t(`आज शेष: ${remainingToday}/5 प्रश्न`, `Remaining today: ${remainingToday}/5`)}
              </Badge>
            </div>

            <form onSubmit={handlePostDoubt} className="space-y-3.5">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <Select
                  label={t("विषय चुनें", "Subject")}
                  value={newSubjectId}
                  onChange={(e) => setNewSubjectId(e.target.value)}
                  options={enrolledSubjects.map((s) => ({
                    value: s.id,
                    label: t(s.name_hi, s.name_en),
                  }))}
                />
                <div className="flex flex-col justify-end">
                  <div className="rounded-lg border border-hairline bg-surface-subtle px-3 py-2.5 text-xs text-ink-secondary flex items-center gap-2">
                    <ShieldCheck className="h-4 w-4 text-emerald-ink shrink-0" />
                    <span>
                      {t(
                        "केवल विद्यालय के सत्यापित शिक्षक ही उत्तर देते हैं (कोई निजी संदेश नहीं)।",
                        "Only verified school teachers post answers (zero private messaging)."
                      )}
                    </span>
                  </div>
                </div>
              </div>

              <div>
                <label className="block text-sm font-semibold text-ink mb-1.5">
                  {t("अपना प्रश्न स्पष्ट लिखें (हिन्दी या English में)", "Write Your Question Clearly (Hindi or English)")}
                </label>
                <textarea
                  rows={3}
                  maxLength={2000}
                  value={newQuestion}
                  onChange={(e) => setNewQuestion(e.target.value)}
                  placeholder={t(
                    "उदाहरण: अवतल दर्पण में फोकस दूरी ऋणात्मक क्यों होती है?",
                    "Example: Why is the focal length of a concave mirror always negative?"
                  )}
                  className="w-full rounded-lg border border-hairline bg-surface px-3.5 py-2.5 text-sm text-ink placeholder:text-ink-muted focus:border-indigo-academic focus:outline-none focus:ring-2 focus:ring-indigo-academic/20"
                />
              </div>

              <div className="flex flex-wrap items-center justify-between gap-3">
                <div className="flex flex-wrap items-center gap-2">
                  <label className="inline-flex items-center gap-2 rounded-lg border border-hairline bg-surface px-3 py-2 text-xs sm:text-sm font-semibold text-ink-secondary hover:bg-surface-subtle cursor-pointer">
                    <Camera className="h-4 w-4 text-indigo-ink" />
                    <span>
                      {uploadingPhoto
                        ? t("फ़ोटो अपलोड हो रही है...", "Uploading photo...")
                        : t("कॉपी की फ़ोटो जोड़ें (वैकल्पिक)", "Attach Notebook Photo (Optional)")}
                    </span>
                    <input
                      type="file"
                      accept="image/jpeg,image/png,image/webp"
                      className="sr-only"
                      disabled={uploadingPhoto}
                      onChange={handlePhotoPick}
                    />
                  </label>
                  {attachedMedia && (
                    <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-soft text-emerald-ink px-3 py-1 text-xs font-semibold">
                      <ImageIcon className="h-3.5 w-3.5" />
                      <span className="max-w-[160px] truncate">{attachedMedia.name}</span>
                      <button
                        type="button"
                        onClick={() => setAttachedMedia(null)}
                        aria-label="Remove attachment"
                        className="hover:text-crimson-ink"
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </button>
                    </span>
                  )}
                </div>

                <Button
                  type="submit"
                  variant="primary"
                  loading={postingDoubt}
                  disabled={remainingToday <= 0 || uploadingPhoto}
                  leftIcon={<Send className="h-4 w-4" />}
                >
                  {t("प्रश्न पूछें", "Post Open Question")}
                </Button>
              </div>
            </form>
          </Card>

          {/* Sort Bar */}
          <div className="flex items-center justify-between gap-2">
            <h2 className="text-base font-bold text-ink">
              {t(`कक्षा के प्रश्न (${doubts.length})`, `Class Questions (${doubts.length})`)}
            </h2>
            <div className="flex items-center gap-1.5">
              <Button
                size="sm"
                variant={sortBy === "recent" ? "primary" : "secondary"}
                onClick={() => setSortBy("recent")}
              >
                {t("नवीनतम", "Newest")}
              </Button>
              <Button
                size="sm"
                variant={sortBy === "upvotes" ? "primary" : "secondary"}
                onClick={() => setSortBy("upvotes")}
              >
                {t("सबसे ज़्यादा पूछे गए", "Most Asked")}
              </Button>
            </div>
          </div>

          {loadingDoubts ? (
            <div className="space-y-3 animate-pulse">
              <div className="h-36 rounded-paper bg-surface-subtle" />
              <div className="h-36 rounded-paper bg-surface-subtle" />
            </div>
          ) : doubts.length === 0 ? (
            <Card className="text-center py-10 space-y-2">
              <MessageSquare className="h-9 w-9 text-indigo-ink mx-auto opacity-75" />
              <p className="text-sm font-semibold text-ink">
                {t("अभी इस विषय में कोई प्रश्न नहीं पूछा गया है।", "No questions posted in this subject yet.")}
              </p>
              <p className="text-xs text-ink-secondary">
                {t("ऊपर से अपना पहला प्रश्न पूछकर पूरी कक्षा की मदद करें!", "Be the first to ask above and help your entire class!")}
              </p>
            </Card>
          ) : (
            <div className="space-y-4">
              {doubts.map((doubt) => (
                <Card key={doubt.id} className="space-y-4">
                  <div className="flex flex-wrap items-start justify-between gap-2">
                    <div className="flex flex-wrap items-center gap-1.5">
                      {doubt.isPinned && (
                        <Badge variant="amber" icon={<Pin className="h-3 w-3" />}>
                          {t("पिन किया गया", "Pinned")}
                        </Badge>
                      )}
                      {doubt.subject && (
                        <Badge variant="indigo">
                          <BiText hi={doubt.subject.nameHi} en={doubt.subject.nameEn} inline />
                        </Badge>
                      )}
                      <Badge
                        variant={
                          doubt.status === "RESOLVED"
                            ? "emerald"
                            : doubt.status === "ANSWERED"
                            ? "indigo"
                            : "amber"
                        }
                      >
                        {doubt.status === "RESOLVED"
                          ? t("हल हुआ", "Resolved")
                          : doubt.status === "ANSWERED"
                          ? t("शिक्षक उत्तर प्राप्त", "Teacher Answered")
                          : t("उत्तर प्रतीक्षित", "Open")}
                      </Badge>
                    </div>

                    <span className="text-xs text-ink-muted">
                      {formatShortDate(doubt.createdAt)}
                    </span>
                  </div>

                  {/* Question Body */}
                  <div className="space-y-2">
                    <p className="text-sm sm:text-base font-semibold text-ink whitespace-pre-wrap leading-relaxed">
                      {doubt.questionText}
                    </p>
                    <p className="text-xs text-ink-secondary">
                      {t("पूछा गया:", "Asked by:")}{" "}
                      <strong className="text-ink">{doubt.student.name}</strong>
                      {doubt.student.rollNo ? ` · Roll ${doubt.student.rollNo}` : ""}
                      {doubt.isOwnDoubt && ` (${t("आप", "You")})`}
                    </p>
                  </div>

                  {doubt.media && (
                    <SafeMediaViewer
                      kind="IMAGE"
                      mediaUrl={doubt.media.url}
                      fileName={doubt.media.fileName}
                      title={t("प्रश्न की संलग्न फ़ोटो", "Attached Question Photo")}
                    />
                  )}

                  {/* Same Doubt (+1) Bar */}
                  <div className="flex items-center justify-between gap-2 pt-2 border-t border-hairline">
                    <Button
                      size="sm"
                      variant={doubt.hasUpvoted ? "primary" : "secondary"}
                      onClick={() => handleToggleUpvote(doubt.id)}
                      leftIcon={<ThumbsUp className="h-3.5 w-3.5" />}
                    >
                      {t("मेरा भी यही प्रश्न", "Same Doubt")} ({doubt.upvoteCount})
                    </Button>
                    <span className="text-xs text-ink-muted">
                      {t(`${doubt.answers.length} शिक्षक उत्तर`, `${doubt.answers.length} teacher answer(s)`)}
                    </span>
                  </div>

                  {/* Verified Teacher Answers */}
                  {doubt.answers.length > 0 && (
                    <div className="space-y-3 pt-2">
                      {doubt.answers.map((ans) => (
                        <div
                          key={ans.id}
                          className="rounded-paper border border-emerald-mastery/30 bg-emerald-soft p-4 space-y-2.5"
                        >
                          <div className="flex flex-wrap items-center justify-between gap-2 text-xs">
                            <span className="inline-flex items-center gap-1.5 font-bold text-emerald-ink">
                              <CheckCircle2 className="h-4 w-4 shrink-0" />
                              <span>{ans.teacher.fullName}</span>
                              {ans.teacher.teacherTitle && (
                                <span className="font-normal opacity-80">
                                  ({ans.teacher.teacherTitle})
                                </span>
                              )}
                            </span>
                            <span className="text-ink-muted">{formatShortDate(ans.createdAt)}</span>
                          </div>
                          <div className="text-sm text-ink leading-relaxed">
                            <MathMarkdown content={ans.answerText} />
                          </div>
                          {ans.media && (
                            <SafeMediaViewer
                              kind={ans.media.mimeType === "application/pdf" ? "PDF" : "IMAGE"}
                              mediaUrl={ans.media.url}
                              fileName={ans.media.fileName}
                              title={t("शिक्षक द्वारा हल फ़ाइल", "Teacher Solution Attachment")}
                            />
                          )}
                        </div>
                      ))}
                    </div>
                  )}
                </Card>
              ))}
            </div>
          )}
        </div>
      )}

      {/* ==================== TAB 2: TEACHER STUDY MATERIALS ==================== */}
      {activeTab === "materials" && (
        <div className="space-y-4">
          {loadingMaterials ? (
            <div className="space-y-3 animate-pulse">
              <div className="h-40 rounded-paper bg-surface-subtle" />
              <div className="h-40 rounded-paper bg-surface-subtle" />
            </div>
          ) : materials.length === 0 ? (
            <Card className="text-center py-10 space-y-2">
              <BookOpen className="h-9 w-9 text-indigo-ink mx-auto opacity-75" />
              <p className="text-sm font-semibold text-ink">
                {t(
                  "आपके विद्यालय के शिक्षकों द्वारा इस विषय में अभी कोई सामग्री प्रकाशित नहीं की गई है।",
                  "Your school teachers haven't published study materials in this subject yet."
                )}
              </p>
            </Card>
          ) : (
            materials.map((mat) => (
              <Card key={mat.id} padding="lg" className="space-y-4">
                <div className="flex flex-wrap items-start justify-between gap-2">
                  <div className="flex flex-wrap items-center gap-1.5">
                    {mat.isPinned && (
                      <Badge variant="amber" icon={<Pin className="h-3 w-3" />}>
                        {t("महत्वपूर्ण", "Pinned")}
                      </Badge>
                    )}
                    {mat.subject && (
                      <Badge variant="indigo">
                        <BiText hi={mat.subject.nameHi} en={mat.subject.nameEn} inline />
                      </Badge>
                    )}
                    <Badge
                      variant="neutral"
                      icon={
                        mat.materialType === "PDF" ? (
                          <FileText className="h-3 w-3" />
                        ) : mat.materialType === "IMAGE" ? (
                          <ImageIcon className="h-3 w-3" />
                        ) : mat.materialType === "NOTE" ? (
                          <BookOpen className="h-3 w-3" />
                        ) : (
                          <Film className="h-3 w-3" />
                        )
                      }
                    >
                      {mat.materialType === "NOTE"
                        ? t("नोट्स", "Note")
                        : mat.materialType === "PDF"
                        ? "PDF"
                        : mat.materialType === "IMAGE"
                        ? t("चित्र", "Image")
                        : t("वीडियो", "Video")}
                    </Badge>
                  </div>
                  <span className="text-xs text-ink-muted">{formatShortDate(mat.createdAt)}</span>
                </div>

                <div className="space-y-1">
                  <h3 className="text-lg font-bold text-ink">{mat.title}</h3>
                  {mat.description && (
                    <p className="text-sm text-ink-secondary">{mat.description}</p>
                  )}
                  <p className="text-xs text-ink-muted">
                    {t("शिक्षक:", "Teacher:")}{" "}
                    <strong className="text-ink">{mat.teacher.fullName}</strong>
                  </p>
                </div>

                {mat.bodyMarkdown && (
                  <div className="rounded-lg border border-hairline bg-canvas p-4">
                    <MathMarkdown content={mat.bodyMarkdown} />
                  </div>
                )}

                {mat.materialType === "VIDEO_YOUTUBE" && mat.youtubeVideoId && (
                  <SafeMediaViewer
                    kind="VIDEO_YOUTUBE"
                    youtubeVideoId={mat.youtubeVideoId}
                    title={mat.title}
                  />
                )}

                {mat.media &&
                  (mat.materialType === "PDF" ||
                    mat.materialType === "IMAGE" ||
                    mat.materialType === "VIDEO_UPLOAD") && (
                    <SafeMediaViewer
                      kind={mat.materialType}
                      mediaUrl={mat.media.url}
                      fileName={mat.media.fileName}
                      title={mat.title}
                    />
                  )}
              </Card>
            ))
          )}
        </div>
      )}
    </div>
  );
}
