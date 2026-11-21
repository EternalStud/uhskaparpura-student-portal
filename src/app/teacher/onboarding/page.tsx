"use client";

import React, { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import {
  BookOpen,
  Check,
  CheckCircle2,
  GraduationCap,
  Loader2,
  Save,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/Card";
import { useToast } from "@/components/ui/Toast";
import type { ClassNum, SubjectRow } from "@/types/database";

interface TeacherSubjectsResponse {
  ok: boolean;
  teacher: {
    fullName: string;
    teacherTitle: string | null;
    subjectsConfigured: boolean;
    assignedClasses: ClassNum[];
    assignedSubjectIds: string[];
  };
  subjects: SubjectRow[];
}

const ALL_CLASSES: ClassNum[] = [9, 10, 11, 12];

export default function TeacherOnboardingPage() {
  const router = useRouter();
  const { t, lang } = useLanguage();
  const toast = useToast();

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [subjects, setSubjects] = useState<SubjectRow[]>([]);
  const [selectedClasses, setSelectedClasses] = useState<ClassNum[]>([]);
  const [selectedSubjectIds, setSelectedSubjectIds] = useState<string[]>([]);
  const [alreadyConfigured, setAlreadyConfigured] = useState(false);
  const [teacherName, setTeacherName] = useState("");

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const res = await fetch("/api/teacher/subjects", { cache: "no-store" });
        const json = (await res.json()) as TeacherSubjectsResponse & { error?: string };
        if (!res.ok || !json.ok) {
          throw new Error(json.error || "Unable to load subjects.");
        }
        if (!mounted) return;
        setSubjects(json.subjects);
        setTeacherName(json.teacher.fullName);
        setAlreadyConfigured(json.teacher.subjectsConfigured);
        setSelectedClasses(
          json.teacher.assignedClasses.length > 0
            ? json.teacher.assignedClasses
            : [9, 10]
        );
        setSelectedSubjectIds(json.teacher.assignedSubjectIds);
      } catch (err) {
        if (mounted) {
          toast.error(
            t("विषय सूची लोड नहीं हो सकी", "Could not load subject list"),
            err instanceof Error ? err.message : undefined
          );
        }
      } finally {
        if (mounted) setLoading(false);
      }
    })();
    return () => {
      mounted = false;
    };
  }, [t, toast]);

  const toggleClass = (cls: ClassNum) => {
    setSelectedClasses((prev) => {
      if (prev.includes(cls)) {
        const next = prev.filter((c) => c !== cls);
        // Remove subjects belonging solely to the unchecked class
        const removedSubjIds = new Set(
          subjects.filter((s) => s.class_num === cls).map((s) => s.id)
        );
        setSelectedSubjectIds((cur) => cur.filter((id) => !removedSubjIds.has(id)));
        return next;
      }
      return [...prev, cls].sort((a, b) => a - b) as ClassNum[];
    });
  };

  const toggleSubject = (subjectId: string) => {
    setSelectedSubjectIds((prev) =>
      prev.includes(subjectId)
        ? prev.filter((id) => id !== subjectId)
        : [...prev, subjectId]
    );
  };

  const subjectsByClass = useMemo(() => {
    const map = new Map<ClassNum, SubjectRow[]>();
    for (const cls of ALL_CLASSES) {
      map.set(
        cls,
        subjects.filter((s) => s.class_num === cls)
      );
    }
    return map;
  }, [subjects]);

  const handleSave = async () => {
    if (selectedClasses.length === 0 || selectedSubjectIds.length === 0) {
      toast.warning(
        t("कम से कम एक कक्षा और एक विषय चुनें", "Select at least one class and subject")
      );
      return;
    }

    setSaving(true);
    try {
      const res = await fetch("/api/teacher/subjects", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          assignedClasses: selectedClasses,
          assignedSubjectIds: selectedSubjectIds,
        }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string; errorHi?: string };
      if (!res.ok || !json.ok) {
        throw new Error(lang === "EN" ? json.error : json.errorHi || json.error);
      }
      toast.success(
        t("आपके विषय सहेजे गए!", "Your teaching subjects have been saved!")
      );
      router.push("/teacher");
      router.refresh();
    } catch (err) {
      toast.error(
        t("विषय सहेजे नहीं जा सके", "Could not save teaching subjects"),
        err instanceof Error ? err.message : undefined
      );
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="flex min-h-[45vh] items-center justify-center">
        <div className="flex items-center gap-2.5 text-sm text-ink-secondary">
          <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
          <span>{t("बिहार बोर्ड विषय सूची लोड हो रही है...", "Loading BSEB subjects...")}</span>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="space-y-2">
        <Badge variant="indigo" icon={<GraduationCap className="h-3.5 w-3.5" />}>
          {alreadyConfigured
            ? t("शिक्षण प्रोफ़ाइल सेटिंग्स", "Teaching Profile Setup")
            : t("त्वरित प्रथम सेटअप (15 सेकंड)", "Quick First-Time Setup (15 sec)")}
        </Badge>
        <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
          {t(
            `${teacherName ? `${teacherName} जी, ` : ""}आप कौन-सी कक्षाएँ और विषय पढ़ाते हैं?`,
            `${teacherName ? `${teacherName}, ` : ""}Which Classes & Subjects do you teach?`
          )}
        </h1>
        <p className="text-sm text-ink-secondary leading-relaxed">
          {t(
            "इससे आपके विषयों के विद्यार्थियों की शंकाएँ, पाठ योजनाएँ और परीक्षाएँ सबसे पहले दिखाई देंगी। आप इसे कभी भी बदल सकते हैं।",
            "This personalizes your Doubt Desk, Lesson Plans, and Exam Studio. You can update this anytime."
          )}
        </p>
      </div>

      {/* Step 1: Select Classes */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">
            {t("चरण 1: अपनी कक्षाएँ चुनें", "Step 1: Select Your Classes")}
          </CardTitle>
          <CardDescription>
            {t(
              "माध्यमिक (कक्षा 9–10) और उच्च माध्यमिक (कक्षा 11–12)",
              "Secondary (Class 9–10) and Senior Secondary (Class 11–12)"
            )}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
            {ALL_CLASSES.map((cls) => {
              const active = selectedClasses.includes(cls);
              const countForClass = selectedSubjectIds.filter((id) =>
                subjectsByClass.get(cls)?.some((s) => s.id === id)
              ).length;

              return (
                <button
                  key={cls}
                  type="button"
                  onClick={() => toggleClass(cls)}
                  className={`flex flex-col items-start rounded-paper border p-4 text-left transition-all min-h-[78px] ${
                    active
                      ? "border-indigo-academic bg-indigo-soft shadow-paper"
                      : "border-hairline bg-surface hover:border-hairline-strong hover:bg-surface-subtle/60"
                  }`}
                >
                  <div className="flex w-full items-center justify-between">
                    <span className="text-base font-bold text-ink">
                      {t(`कक्षा ${cls}`, `Class ${cls}`)}
                    </span>
                    <span
                      className={`flex h-5 w-5 items-center justify-center rounded-full border ${
                        active
                          ? "border-indigo-academic bg-indigo-academic text-white"
                          : "border-hairline-strong bg-surface"
                      }`}
                    >
                      {active && <Check className="h-3.5 w-3.5" />}
                    </span>
                  </div>
                  <span className="mt-1 text-xs text-ink-secondary">
                    {cls <= 10 ? t("माध्यमिक (BSEB)", "Secondary") : t("इंटरमीडिएट", "Intermediate")}
                    {countForClass > 0 ? ` · ${countForClass} ${t("चयनित", "picked")}` : ""}
                  </span>
                </button>
              );
            })}
          </div>
        </CardContent>
      </Card>

      {/* Step 2: Select Subjects for each chosen Class */}
      {selectedClasses.length > 0 && (
        <div className="space-y-4">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <div>
              <h2 className="text-base font-bold text-ink">
                {t("चरण 2: अपने विषय चुनें", "Step 2: Select Your Subjects")}
              </h2>
              <p className="text-xs text-ink-secondary">
                {t(
                  `अभी तक ${selectedSubjectIds.length} विषय चुने गए हैं`,
                  `${selectedSubjectIds.length} subject(s) selected`
                )}
              </p>
            </div>
          </div>

          {selectedClasses.map((cls) => {
            const list = subjectsByClass.get(cls) ?? [];
            const streams =
              cls <= 10
                ? [{ key: "ALL_910", labelHi: "सभी विषय", labelEn: "Subjects", items: list }]
                : [
                    {
                      key: "LANG",
                      labelHi: "अनिवार्य भाषाएँ",
                      labelEn: "Compulsory Languages",
                      items: list.filter((s) => s.stream === "ALL"),
                    },
                    {
                      key: "Science",
                      labelHi: "विज्ञान संकाय (Science)",
                      labelEn: "Science Stream",
                      items: list.filter((s) => s.stream === "Science"),
                    },
                    {
                      key: "Arts",
                      labelHi: "कला संकाय (Arts)",
                      labelEn: "Arts Stream",
                      items: list.filter((s) => s.stream === "Arts"),
                    },
                    {
                      key: "Commerce",
                      labelHi: "वाणिज्य संकाय (Commerce)",
                      labelEn: "Commerce Stream",
                      items: list.filter((s) => s.stream === "Commerce"),
                    },
                  ].filter((g) => g.items.length > 0);

            return (
              <Card key={cls}>
                <CardHeader>
                  <CardTitle className="text-base flex items-center gap-2">
                    <BookOpen className="h-4 w-4 text-indigo-ink" />
                    {t(`कक्षा ${cls} के विषय`, `Class ${cls} Subjects`)}
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-5">
                  {streams.map((group) => (
                    <div key={group.key} className="space-y-2.5">
                      {cls >= 11 && (
                        <p className="text-xs font-bold uppercase tracking-wider text-ink-muted">
                          {t(group.labelHi, group.labelEn)}
                        </p>
                      )}
                      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2.5">
                        {group.items.map((subj) => {
                          const checked = selectedSubjectIds.includes(subj.id);
                          return (
                            <button
                              key={subj.id}
                              type="button"
                              onClick={() => toggleSubject(subj.id)}
                              className={`flex items-center justify-between gap-2 rounded-lg border px-3.5 py-2.5 text-left transition-colors min-h-[46px] ${
                                checked
                                  ? "border-indigo-academic bg-indigo-soft text-indigo-ink font-semibold"
                                  : "border-hairline bg-surface text-ink hover:bg-surface-subtle"
                              }`}
                            >
                              <div className="min-w-0">
                                <p className="text-sm leading-snug truncate">
                                  {t(subj.name_hi, subj.name_en)}
                                </p>
                                <p className="text-[11px] text-ink-muted">
                                  {t("कोड", "Code")} {subj.bseb_code}
                                </p>
                              </div>
                              {checked ? (
                                <CheckCircle2 className="h-4 w-4 shrink-0 text-indigo-academic" />
                              ) : (
                                <span className="h-4 w-4 shrink-0 rounded-full border border-hairline-strong" />
                              )}
                            </button>
                          );
                        })}
                      </div>
                    </div>
                  ))}
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}

      {/* Sticky Save Footer */}
      <div className="sticky bottom-16 lg:bottom-4 z-20 flex flex-wrap items-center justify-between gap-3 rounded-paper border border-hairline bg-surface/95 backdrop-blur-sm p-4 shadow-paper-hover">
        <div className="text-sm text-ink-secondary">
          <strong className="text-ink">{selectedClasses.length}</strong>{" "}
          {t("कक्षाएँ", "classes")} ·{" "}
          <strong className="text-ink">{selectedSubjectIds.length}</strong>{" "}
          {t("विषय चयनित", "subjects selected")}
        </div>
        <Button
          variant="primary"
          size="lg"
          loading={saving}
          disabled={selectedClasses.length === 0 || selectedSubjectIds.length === 0}
          onClick={() => void handleSave()}
          leftIcon={<Save className="h-4 w-4" />}
        >
          {t("सहेजें और शिक्षक स्टूडियो खोलें", "Save & Open Educator Studio")}
        </Button>
      </div>
    </div>
  );
}
