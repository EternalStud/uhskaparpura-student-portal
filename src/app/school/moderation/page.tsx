"use client";

import React, { useCallback, useEffect, useState } from "react";
import { Eye, EyeOff, FileText, MessageSquare } from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import {
  Badge,
  Button,
  Card,
  Tabs,
  useToast,
} from "@/components/ui";

interface ModerationDoubt {
  id: string;
  classNum: number;
  subjectNameEn: string;
  subjectNameHi: string;
  studentName: string;
  rollNo: number | null;
  questionText: string;
  status: string;
  isPinned: boolean;
  isHidden: boolean;
  upvoteCount: number;
  createdAt: string;
  answers: Array<{
    id: string;
    answerText: string;
    isHidden: boolean;
    createdAt: string;
  }>;
}

interface ModerationMaterial {
  id: string;
  classNum: number;
  subjectNameEn: string;
  subjectNameHi: string;
  teacherName: string;
  title: string;
  materialType: string;
  isPinned: boolean;
  isHidden: boolean;
  createdAt: string;
}

export default function SchoolModerationPage() {
  const { t } = useLanguage();
  const toast = useToast();

  const [tab, setTab] = useState<"DOUBTS" | "MATERIALS">("DOUBTS");
  const [doubts, setDoubts] = useState<ModerationDoubt[]>([]);
  const [materials, setMaterials] = useState<ModerationMaterial[]>([]);
  const [loading, setLoading] = useState(true);

  const loadModeration = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/school/moderation", { cache: "no-store" });
      if (!res.ok) throw new Error();
      const json = (await res.json()) as {
        doubts: ModerationDoubt[];
        materials: ModerationMaterial[];
      };
      setDoubts(json.doubts);
      setMaterials(json.materials);
    } catch {
      toast.error(t("मॉडरेशन सूची लोड नहीं हो सकी", "Could not load moderation queue"));
    } finally {
      setLoading(false);
    }
  }, [t, toast]);

  useEffect(() => {
    void loadModeration();
  }, [loadModeration]);

  const toggleVisibility = async (
    targetType: "DOUBT" | "DOUBT_ANSWER" | "MATERIAL",
    targetId: string,
    hidden: boolean
  ) => {
    const res = await fetch("/api/school/moderation", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: JSON.stringify({ targetType, targetId, hidden }),
    });
    if (!res.ok) {
      toast.error(t("अपडेट विफल रहा", "Moderation update failed"));
      return;
    }
    toast.success(
      hidden
        ? t("सामग्री छिपाई गई", "Item hidden from students")
        : t("सामग्री पुनः दिखाई गई", "Item restored")
    );
    await loadModeration();
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-ink">
          {t("खुला संदेह बोर्ड एवं कक्षा सामग्री मॉडरेशन", "Open Doubt Board & Material Moderation")}
        </h1>
        <p className="mt-1 text-sm text-ink-secondary">
          {t(
            "असंगत या विषय से बाहर की पोस्ट को सुरक्षित रूप से छिपाएँ या पुनर्स्थापित करें। सभी कार्रवाई लॉग की जाती हैं।",
            "Hide or restore off-topic posts across your school's open doubt board and classroom materials. Every action is audit-logged."
          )}
        </p>
      </div>

      <Tabs<"DOUBTS" | "MATERIALS">
        value={tab}
        onChange={setTab}
        variant="pills"
        items={[
          {
            id: "DOUBTS",
            label: t("खुले संदेह प्रश्न", "Open Doubts"),
            icon: <MessageSquare className="h-4 w-4" />,
            count: doubts.length,
          },
          {
            id: "MATERIALS",
            label: t("शिक्षक अध्ययन सामग्री", "Classroom Materials"),
            icon: <FileText className="h-4 w-4" />,
            count: materials.length,
          },
        ]}
      />

      {loading ? (
        <div className="h-32 rounded-paper bg-surface-subtle animate-pulse" />
      ) : tab === "DOUBTS" ? (
        <div className="space-y-3">
          {doubts.length === 0 ? (
            <Card>
              <p className="py-8 text-center text-sm text-ink-muted">
                {t("अभी कोई संदेह पोस्ट नहीं है।", "No student doubts posted yet.")}
              </p>
            </Card>
          ) : (
            doubts.map((d) => (
              <Card key={d.id} padding="md" variant={d.isHidden ? "subtle" : "default"}>
                <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-3">
                  <div className="space-y-1.5 min-w-0">
                    <div className="flex flex-wrap items-center gap-1.5">
                      <Badge variant="indigo">
                        {t(`कक्षा ${d.classNum}`, `Class ${d.classNum}`)} ·{" "}
                        {t(d.subjectNameHi, d.subjectNameEn)}
                      </Badge>
                      <Badge variant={d.isHidden ? "crimson" : "emerald"}>
                        {d.isHidden ? t("छिपाया गया", "Hidden") : d.status}
                      </Badge>
                      <span className="text-xs text-ink-muted">
                        {d.studentName} {d.rollNo ? `(#${d.rollNo})` : ""}
                      </span>
                    </div>
                    <p className="text-sm text-ink whitespace-pre-wrap">{d.questionText}</p>
                    {d.answers.length > 0 && (
                      <div className="mt-2 pl-3 border-l-2 border-hairline space-y-2">
                        {d.answers.map((ans) => (
                          <div
                            key={ans.id}
                            className="flex items-start justify-between gap-2 text-xs text-ink-secondary"
                          >
                            <p className={ans.isHidden ? "line-through opacity-60" : ""}>
                              {ans.answerText}
                            </p>
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={() =>
                                void toggleVisibility("DOUBT_ANSWER", ans.id, !ans.isHidden)
                              }
                            >
                              {ans.isHidden ? t("दिखाएँ", "Restore") : t("छिपाएँ", "Hide")}
                            </Button>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                  <Button
                    variant={d.isHidden ? "emerald" : "secondary"}
                    size="sm"
                    leftIcon={
                      d.isHidden ? <Eye className="h-4 w-4" /> : <EyeOff className="h-4 w-4" />
                    }
                    onClick={() => void toggleVisibility("DOUBT", d.id, !d.isHidden)}
                  >
                    {d.isHidden ? t("पुनः दिखाएँ", "Restore") : t("छिपाएँ", "Hide Post")}
                  </Button>
                </div>
              </Card>
            ))
          )}
        </div>
      ) : (
        <div className="space-y-3">
          {materials.length === 0 ? (
            <Card>
              <p className="py-8 text-center text-sm text-ink-muted">
                {t("अभी कोई अध्ययन सामग्री प्रकाशित नहीं है।", "No classroom materials posted yet.")}
              </p>
            </Card>
          ) : (
            materials.map((m) => (
              <Card key={m.id} padding="md" variant={m.isHidden ? "subtle" : "default"}>
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                  <div className="space-y-1">
                    <div className="flex flex-wrap items-center gap-1.5">
                      <Badge variant="indigo">
                        {t(`कक्षा ${m.classNum}`, `Class ${m.classNum}`)} ·{" "}
                        {t(m.subjectNameHi, m.subjectNameEn)}
                      </Badge>
                      <Badge variant="outline">{m.materialType}</Badge>
                      {m.isHidden && <Badge variant="crimson">{t("छिपाया गया", "Hidden")}</Badge>}
                    </div>
                    <p className="text-sm font-semibold text-ink">{m.title}</p>
                    <p className="text-xs text-ink-muted">{m.teacherName}</p>
                  </div>
                  <Button
                    variant={m.isHidden ? "emerald" : "secondary"}
                    size="sm"
                    leftIcon={
                      m.isHidden ? <Eye className="h-4 w-4" /> : <EyeOff className="h-4 w-4" />
                    }
                    onClick={() => void toggleVisibility("MATERIAL", m.id, !m.isHidden)}
                  >
                    {m.isHidden ? t("पुनः दिखाएँ", "Restore") : t("छिपाएँ", "Hide Material")}
                  </Button>
                </div>
              </Card>
            ))
          )}
        </div>
      )}
    </div>
  );
}
