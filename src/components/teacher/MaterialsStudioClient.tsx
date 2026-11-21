"use client";

import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  Eye,
  FileText,
  Film,
  FolderUp,
  Image as ImageIcon,
  Loader2,
  Pin,
  PinOff,
  Plus,
  Send,
  Trash2,
  Youtube,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/Card";
import { Input } from "@/components/ui/Input";
import { MathMarkdown } from "@/components/ui/MathMarkdown";
import { Modal } from "@/components/ui/Modal";
import { Select } from "@/components/ui/Select";
import { Tabs } from "@/components/ui/Tabs";
import { useToast } from "@/components/ui/Toast";
import { SafeMediaViewer } from "@/components/visual/SafeMediaViewer";
import {
  ResumableFileUploader,
  type UploadedFileResult,
} from "@/components/teacher/ResumableFileUploader";
import type { TeacherMaterialType } from "@/types/database";

interface SubjectWithChapters {
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

interface MaterialItem {
  id: string;
  classNum: number;
  subjectId: string;
  subject: { id: string; classNum: number; nameHi: string; nameEn: string } | null;
  chapter: { id: string; chapterNo: number; titleHi: string; titleEn: string } | null;
  title: string;
  description: string | null;
  materialType: TeacherMaterialType;
  bodyMarkdown: string | null;
  media: {
    id: string;
    url: string;
    fileName: string;
    mimeType: string;
    sizeBytes: number;
  } | null;
  youtubeVideoId: string | null;
  isPinned: boolean;
  teacher: { id: string; fullName: string; teacherTitle: string | null };
  canManage: boolean;
  createdAt: string;
}

const MATERIAL_UPLOAD_CONFIG: Record<
  "PDF" | "IMAGE" | "VIDEO_UPLOAD",
  { accept: string; mimes: string[]; maxMb: number; labelHi: string; labelEn: string; hintHi: string; hintEn: string }
> = {
  PDF: {
    accept: ".pdf,application/pdf",
    mimes: ["application/pdf"],
    maxMb: 20,
    labelHi: "पीडीएफ दस्तावेज़ चुनें (अधिकतम 20 MB)",
    labelEn: "Select PDF document (up to 20 MB)",
    hintHi: "अध्याय नोट्स, कार्यपत्रक या मॉडल पेपर की PDF अपलोड करें",
    hintEn: "Upload chapter handouts, worksheets, or model question PDFs",
  },
  IMAGE: {
    accept: "image/jpeg,image/png,image/webp",
    mimes: ["image/jpeg", "image/png", "image/webp"],
    maxMb: 5,
    labelHi: "चित्र / बोर्ड फ़ोटो चुनें (अधिकतम 5 MB)",
    labelEn: "Select Diagram / Board Photo (up to 5 MB)",
    hintHi: "JPG, PNG या WEBP चित्र समर्थित हैं",
    hintEn: "Supports JPG, PNG, and WEBP images",
  },
  VIDEO_UPLOAD: {
    accept: "video/mp4,video/webm",
    mimes: ["video/mp4", "video/webm"],
    maxMb: 100,
    labelHi: "कक्षा वीडियो चुनें (MP4 / WEBM · अधिकतम 100 MB)",
    labelEn: "Select Lesson Video (MP4 / WEBM · up to 100 MB)",
    hintHi: "सीधे विद्यालय के विद्यार्थियों के लिए सुरक्षित स्ट्रीमिंग",
    hintEn: "Streams smoothly directly to students in your school",
  },
};

export function MaterialsStudioClient() {
  const { t, lang } = useLanguage();
  const toast = useToast();

  const [subjects, setSubjects] = useState<SubjectWithChapters[]>([]);
  const [materials, setMaterials] = useState<MaterialItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [scope, setScope] = useState<"my" | "all">("my");
  const [filterSubject, setFilterSubject] = useState("");

  // Composer modal state
  const [composerOpen, setComposerOpen] = useState(false);
  const [materialType, setMaterialType] = useState<TeacherMaterialType>("NOTE");
  const [subjectId, setSubjectId] = useState("");
  const [chapterId, setChapterId] = useState("");
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [bodyMarkdown, setBodyMarkdown] = useState("");
  const [previewMd, setPreviewMd] = useState(false);
  const [youtubeUrl, setYoutubeUrl] = useState("");
  const [uploadedFile, setUploadedFile] = useState<UploadedFileResult | null>(null);
  const [isPinned, setIsPinned] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [busyId, setBusyId] = useState<string | null>(null);

  const loadMaterials = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({ scope });
      if (filterSubject) params.set("subjectId", filterSubject);
      const res = await fetch(`/api/collab/materials?${params.toString()}`, {
        cache: "no-store",
      });
      const json = (await res.json()) as { ok?: boolean; materials?: MaterialItem[] };
      if (res.ok && json.ok) {
        setMaterials(json.materials ?? []);
      }
    } finally {
      setLoading(false);
    }
  }, [scope, filterSubject]);

  useEffect(() => {
    let active = true;
    (async () => {
      const res = await fetch("/api/teacher/lesson-plans?scope=all", { cache: "no-store" });
      const json = (await res.json()) as { ok?: boolean; subjects?: SubjectWithChapters[] };
      if (active && res.ok && json.ok) {
        const list = json.subjects ?? [];
        setSubjects(list);
        const firstAssigned = list.find((s) => s.isAssigned) ?? list[0];
        if (firstAssigned) setSubjectId(firstAssigned.id);
      }
    })();
    return () => {
      active = false;
    };
  }, []);

  useEffect(() => {
    void loadMaterials();
  }, [loadMaterials]);

  const activeSubjectObj = useMemo(
    () => subjects.find((s) => s.id === subjectId) ?? null,
    [subjects, subjectId]
  );

  const resetComposer = () => {
    setTitle("");
    setDescription("");
    setBodyMarkdown("");
    setYoutubeUrl("");
    setUploadedFile(null);
    setChapterId("");
    setIsPinned(false);
    setPreviewMd(false);
  };

  const handlePublish = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!subjectId || title.trim().length < 2) {
      toast.warning(t("कृपया विषय और शीर्षक दर्ज करें।", "Please enter subject and title."));
      return;
    }

    setSubmitting(true);
    try {
      const res = await fetch("/api/collab/materials", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          subjectId,
          chapterId: chapterId || null,
          title: title.trim(),
          description: description.trim() || null,
          materialType,
          bodyMarkdown: bodyMarkdown.trim() || null,
          mediaObjectId: uploadedFile?.mediaObjectId ?? null,
          youtubeUrl: materialType === "VIDEO_YOUTUBE" ? youtubeUrl.trim() : null,
          isPinned,
        }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string; errorHi?: string };
      if (!res.ok || !json.ok) {
        throw new Error(lang === "EN" ? json.error : json.errorHi || json.error);
      }
      toast.success(
        t("अध्ययन सामग्री विद्यार्थियों के लिए प्रकाशित हो गई!", "Study material published to students!")
      );
      resetComposer();
      setComposerOpen(false);
      await loadMaterials();
    } catch (err) {
      toast.error(
        t("सामग्री प्रकाशित नहीं हो सकी", "Could not publish material"),
        err instanceof Error ? err.message : undefined
      );
    } finally {
      setSubmitting(false);
    }
  };

  const handleTogglePin = async (item: MaterialItem) => {
    setBusyId(item.id);
    try {
      const res = await fetch(`/api/collab/materials/${item.id}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({ isPinned: !item.isPinned }),
      });
      if (!res.ok) throw new Error("Failed");
      toast.success(
        item.isPinned ? t("पिन हटाया गया", "Unpinned") : t("शीर्ष पर पिन किया गया", "Pinned to top")
      );
      await loadMaterials();
    } catch {
      toast.error(t("अपडेट नहीं हो सका", "Update failed"));
    } finally {
      setBusyId(null);
    }
  };

  const handleDelete = async (item: MaterialItem) => {
    setBusyId(item.id);
    try {
      const res = await fetch(`/api/collab/materials/${item.id}`, {
        method: "DELETE",
        headers: {
          "X-Requested-With": "XMLHttpRequest",
        },
      });
      if (!res.ok) throw new Error("Failed");
      toast.success(t("सामग्री हटाई गई", "Study material removed"));
      await loadMaterials();
    } catch {
      toast.error(t("सामग्री हटाई नहीं जा सकी", "Could not remove material"));
    } finally {
      setBusyId(null);
    }
  };

  const typeBadge = (type: TeacherMaterialType) => {
    switch (type) {
      case "NOTE":
        return { label: t("कक्षा नोट्स", "Class Note"), icon: <FileText className="h-3 w-3" /> };
      case "PDF":
        return { label: "PDF", icon: <FileText className="h-3 w-3" /> };
      case "IMAGE":
        return { label: t("चित्र / बोर्ड", "Image"), icon: <ImageIcon className="h-3 w-3" /> };
      case "VIDEO_UPLOAD":
        return { label: t("वीडियो", "Video"), icon: <Film className="h-3 w-3" /> };
      case "VIDEO_YOUTUBE":
        return { label: "YouTube", icon: <Youtube className="h-3 w-3" /> };
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 border-b border-hairline pb-5">
        <div className="space-y-1.5">
          <Badge variant="emerald" icon={<FolderUp className="h-3.5 w-3.5" />}>
            {t("विद्यालय कक्षा संसाधन", "School Classroom Resources")}
          </Badge>
          <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
            {t("अध्ययन सामग्री प्रकाशित करें", "Classroom Study Materials")}
          </h1>
          <p className="text-sm text-ink-secondary">
            {t(
              "अपने विद्यालय के विद्यार्थियों के साथ नोट्स, पीडीएफ, चित्र और वीडियो साझा करें।",
              "Share Markdown/LaTeX notes, PDFs, board photos, or lesson videos directly with your school's students."
            )}
          </p>
        </div>

        <Button
          variant="primary"
          onClick={() => setComposerOpen(true)}
          leftIcon={<Plus className="h-4 w-4" />}
        >
          {t("नई सामग्री प्रकाशित करें", "Publish Material")}
        </Button>
      </div>

      {/* Filters */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <Tabs
          variant="pills"
          value={scope}
          onChange={setScope}
          items={[
            { id: "my", label: t("मेरे विषय", "My Subjects") },
            { id: "all", label: t("पूरे विद्यालय की सामग्री", "All School Materials") },
          ]}
        />

        <div className="w-full sm:w-72">
          <Select
            value={filterSubject}
            onChange={(e) => setFilterSubject(e.target.value)}
            options={[
              { value: "", label: t("सभी विषय", "All Subjects") },
              ...subjects.map((s) => ({
                value: s.id,
                label: `${t(`कक्षा ${s.class_num}`, `Class ${s.class_num}`)} · ${t(
                  s.name_hi,
                  s.name_en
                )}`,
              })),
            ]}
          />
        </div>
      </div>

      {/* Materials Feed */}
      {loading ? (
        <div className="flex min-h-[35vh] items-center justify-center">
          <div className="flex items-center gap-2 text-sm text-ink-secondary">
            <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
            <span>{t("सामग्री लोड हो रही है...", "Loading materials...")}</span>
          </div>
        </div>
      ) : materials.length === 0 ? (
        <Card variant="subtle" className="py-10 text-center space-y-3">
          <FolderUp className="mx-auto h-8 w-8 text-ink-muted" />
          <p className="text-base font-bold text-ink">
            {t("अभी कोई अध्ययन सामग्री प्रकाशित नहीं की गई है", "No study materials published yet")}
          </p>
          <p className="text-sm text-ink-secondary max-w-md mx-auto">
            {t(
              "विद्यार्थियों की सहायता के लिए पहला अध्याय नोट, PDF या वीडियो साझा करें।",
              "Publish your first chapter note, PDF worksheet, or lesson video for students."
            )}
          </p>
          <Button
            size="sm"
            variant="primary"
            onClick={() => setComposerOpen(true)}
            leftIcon={<Plus className="h-4 w-4" />}
          >
            {t("सामग्री प्रकाशित करें", "Publish Material")}
          </Button>
        </Card>
      ) : (
        <div className="space-y-4">
          {materials.map((item) => {
            const tb = typeBadge(item.materialType);
            return (
              <Card key={item.id}>
                <CardHeader className="flex-col sm:flex-row sm:items-start justify-between gap-3">
                  <div className="space-y-1.5 min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      {item.isPinned && (
                        <Badge variant="amber" icon={<Pin className="h-3 w-3" />}>
                          {t("पिन किया गया", "Pinned")}
                        </Badge>
                      )}
                      <Badge variant="indigo">
                        {t(`कक्षा ${item.classNum}`, `Class ${item.classNum}`)}
                        {item.subject
                          ? ` · ${t(item.subject.nameHi, item.subject.nameEn)}`
                          : ""}
                      </Badge>
                      <Badge variant="neutral" icon={tb.icon}>
                        {tb.label}
                      </Badge>
                      {item.chapter && (
                        <span className="text-xs text-ink-muted">
                          {t(`अध्याय ${item.chapter.chapterNo}`, `Ch. ${item.chapter.chapterNo}`)}:{" "}
                          {t(item.chapter.titleHi, item.chapter.titleEn)}
                        </span>
                      )}
                    </div>
                    <CardTitle>{item.title}</CardTitle>
                    {item.description && (
                      <CardDescription>{item.description}</CardDescription>
                    )}
                    <p className="text-xs text-ink-muted">
                      {item.teacher.fullName}
                      {item.teacher.teacherTitle ? ` (${item.teacher.teacherTitle})` : ""} ·{" "}
                      {new Date(item.createdAt).toLocaleDateString(
                        lang === "EN" ? "en-IN" : "hi-IN",
                        { day: "numeric", month: "short", year: "numeric" }
                      )}
                    </p>
                  </div>

                  {item.canManage && (
                    <div className="flex items-center gap-1.5 shrink-0">
                      <Button
                        size="sm"
                        variant="ghost"
                        loading={busyId === item.id}
                        onClick={() => void handleTogglePin(item)}
                        leftIcon={
                          item.isPinned ? (
                            <PinOff className="h-4 w-4" />
                          ) : (
                            <Pin className="h-4 w-4" />
                          )
                        }
                      >
                        {item.isPinned ? t("अनपिन", "Unpin") : t("पिन", "Pin")}
                      </Button>
                      <Button
                        size="sm"
                        variant="ghost"
                        loading={busyId === item.id}
                        onClick={() => void handleDelete(item)}
                        leftIcon={<Trash2 className="h-4 w-4 text-crimson-ink" />}
                      >
                        {t("हटाएँ", "Delete")}
                      </Button>
                    </div>
                  )}
                </CardHeader>

                <CardContent className="space-y-4">
                  {item.bodyMarkdown && <MathMarkdown content={item.bodyMarkdown} />}

                  {item.materialType === "VIDEO_YOUTUBE" && item.youtubeVideoId && (
                    <SafeMediaViewer
                      kind="VIDEO_YOUTUBE"
                      youtubeVideoId={item.youtubeVideoId}
                      title={item.title}
                    />
                  )}

                  {(item.materialType === "PDF" ||
                    item.materialType === "IMAGE" ||
                    item.materialType === "VIDEO_UPLOAD") &&
                    item.media && (
                      <SafeMediaViewer
                        kind={item.materialType}
                        mediaUrl={item.media.url}
                        title={item.title}
                        fileName={item.media.fileName}
                      />
                    )}
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}

      {/* Publish Material Modal */}
      <Modal
        open={composerOpen}
        onClose={() => !submitting && setComposerOpen(false)}
        size="lg"
        title={t("नई अध्ययन सामग्री प्रकाशित करें", "Publish Study Material")}
        description={t(
          "यह सामग्री केवल आपके विद्यालय की चयनित कक्षा और विषय के विद्यार्थियों को दिखेगी।",
          "Visible strictly to students enrolled in the chosen class and subject at your school."
        )}
      >
        <form onSubmit={handlePublish} className="space-y-5">
          {/* Material Format Selector */}
          <div className="grid grid-cols-2 sm:grid-cols-5 gap-2">
            {(
              [
                { id: "NOTE", hi: "नोट्स", en: "Note", Icon: FileText },
                { id: "PDF", hi: "PDF", en: "PDF", Icon: FileText },
                { id: "IMAGE", hi: "चित्र", en: "Image", Icon: ImageIcon },
                { id: "VIDEO_UPLOAD", hi: "वीडियो", en: "Video", Icon: Film },
                { id: "VIDEO_YOUTUBE", hi: "YouTube", en: "YouTube", Icon: Youtube },
              ] as const
            ).map(({ id, hi, en, Icon }) => {
              const active = materialType === id;
              return (
                <button
                  key={id}
                  type="button"
                  onClick={() => {
                    setMaterialType(id);
                    setUploadedFile(null);
                  }}
                  className={`flex flex-col items-center justify-center gap-1 rounded-lg border px-2 py-2.5 text-xs font-semibold transition-colors min-h-[58px] ${
                    active
                      ? "border-indigo-academic bg-indigo-soft text-indigo-ink"
                      : "border-hairline bg-surface text-ink-secondary hover:bg-surface-subtle"
                  }`}
                >
                  <Icon className="h-4 w-4" />
                  <span>{t(hi, en)}</span>
                </button>
              );
            })}
          </div>

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
                { value: "", label: t("सामान्य / पूरा विषय", "General / Full Subject") },
                ...(activeSubjectObj?.chapters ?? []).map((c) => ({
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
            required
            label={t("शीर्षक", "Title")}
            placeholder={t(
              "उदाहरण: अध्याय 10 — दर्पण सूत्र के महत्वपूर्ण आंकिक प्रश्न",
              "e.g., Chapter 10 — Important Mirror Formula Numericals"
            )}
            value={title}
            onChange={(e) => setTitle(e.target.value)}
          />

          <Input
            label={t("संक्षिप्त विवरण (वैकल्पिक)", "Short Description (Optional)")}
            placeholder={t(
              "विद्यार्थियों के लिए संक्षिप्त निर्देश...",
              "Brief guidance for students..."
            )}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
          />

          {materialType === "VIDEO_YOUTUBE" && (
            <Input
              required
              label={t("YouTube वीडियो लिंक", "YouTube Video Link")}
              placeholder="https://www.youtube.com/watch?v=..."
              value={youtubeUrl}
              onChange={(e) => setYoutubeUrl(e.target.value)}
              hint={t(
                "वीडियो बिना किसी विचलन के स्वच्छ शैक्षणिक प्लेयर में चलेगा।",
                "Plays cleanly inside the distraction-free classroom player."
              )}
            />
          )}

          {(materialType === "PDF" ||
            materialType === "IMAGE" ||
            materialType === "VIDEO_UPLOAD") && (
            <ResumableFileUploader
              purpose="MATERIAL"
              accept={MATERIAL_UPLOAD_CONFIG[materialType].accept}
              allowedMimes={MATERIAL_UPLOAD_CONFIG[materialType].mimes}
              maxSizeMb={MATERIAL_UPLOAD_CONFIG[materialType].maxMb}
              labelHi={MATERIAL_UPLOAD_CONFIG[materialType].labelHi}
              labelEn={MATERIAL_UPLOAD_CONFIG[materialType].labelEn}
              hintHi={MATERIAL_UPLOAD_CONFIG[materialType].hintHi}
              hintEn={MATERIAL_UPLOAD_CONFIG[materialType].hintEn}
              value={uploadedFile}
              onUploaded={setUploadedFile}
            />
          )}

          <div className="space-y-1.5">
            <div className="flex items-center justify-between">
              <label className="text-sm font-semibold text-ink">
                {materialType === "NOTE"
                  ? t("अध्ययन नोट्स (Markdown व गणित सूत्र $...$ समर्थित)", "Study Notes (Markdown & $...$ math supported)")
                  : t("अतिरिक्त टिप्पणी / सारांश (वैकल्पिक)", "Additional Notes / Summary (Optional)")}
              </label>
              <Button
                type="button"
                variant="ghost"
                size="sm"
                onClick={() => setPreviewMd((p) => !p)}
                leftIcon={<Eye className="h-3.5 w-3.5" />}
              >
                {previewMd ? t("संपादित करें", "Edit") : t("प्रीव्यू देखें", "Preview")}
              </Button>
            </div>

            {previewMd ? (
              <div className="min-h-[160px] rounded-lg border border-hairline bg-canvas p-4">
                {bodyMarkdown.trim() ? (
                  <MathMarkdown content={bodyMarkdown} />
                ) : (
                  <p className="text-sm text-ink-muted">
                    {t("अभी कोई सामग्री नहीं लिखी गई है।", "Nothing written yet.")}
                  </p>
                )}
              </div>
            ) : (
              <textarea
                rows={materialType === "NOTE" ? 7 : 3}
                required={materialType === "NOTE"}
                value={bodyMarkdown}
                onChange={(e) => setBodyMarkdown(e.target.value)}
                placeholder={t(
                  "यहाँ स्पष्ट बिंदु लिखें। गणितीय सूत्र के लिए $f = R/2$ जैसे लिखें...",
                  "Write clear points here. Use $f = R/2$ for inline math formulas..."
                )}
                className="w-full rounded-lg border border-hairline-strong bg-surface px-3.5 py-2.5 text-sm text-ink placeholder:text-ink-muted focus:border-indigo-academic focus:ring-2 focus:ring-indigo-academic/20 focus:outline-none"
              />
            )}
          </div>

          <label className="flex items-center gap-2.5 text-sm text-ink cursor-pointer">
            <input
              type="checkbox"
              checked={isPinned}
              onChange={(e) => setIsPinned(e.target.checked)}
              className="h-4 w-4 rounded border-hairline-strong accent-indigo-academic"
            />
            <span>{t("इस सामग्री को विद्यार्थियों की सूची में शीर्ष पर पिन करें", "Pin to top of student material list")}</span>
          </label>

          <div className="flex justify-end gap-2.5 pt-2 border-t border-hairline">
            <Button
              type="button"
              variant="secondary"
              disabled={submitting}
              onClick={() => setComposerOpen(false)}
            >
              {t("रद्द करें", "Cancel")}
            </Button>
            <Button
              type="submit"
              variant="primary"
              loading={submitting}
              leftIcon={<Send className="h-4 w-4" />}
            >
              {t("प्रकाशित करें", "Publish Now")}
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
