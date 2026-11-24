"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import {
  ArrowRight,
  BookMarked,
  Clock,
  FileCheck2,
  Loader2,
  Search,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/Card";
import { Input } from "@/components/ui/Input";
import { Select } from "@/components/ui/Select";
import { Tabs } from "@/components/ui/Tabs";

interface LessonPlanSubject {
  id: string;
  bseb_code: string;
  class_num: number;
  stream: string;
  name_hi: string;
  name_en: string;
  isAssigned: boolean;
  lessonPlansCount: number;
  chapters: Array<{
    id: string;
    chapter_no: number;
    title_hi: string;
    title_en: string;
    summary_hi: string | null;
    summary_en: string | null;
    bseb_weightage_marks: number;
    hasLessonPlan: boolean;
    lessonPlanSummary: {
      id: string;
      durationPeriods: number;
      objectivesHi: string;
      objectivesEn: string;
    } | null;
  }>;
}

export function LessonPlansClient() {
  const { t } = useLanguage();

  const [scope, setScope] = useState<"my" | "all">("my");
  const [classNum, setClassNum] = useState<string>("");
  const [search, setSearch] = useState("");
  const [onlyReady, setOnlyReady] = useState(false);
  const [subjects, setSubjects] = useState<LessonPlanSubject[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    setLoading(true);
    const params = new URLSearchParams({ scope });
    if (classNum) params.set("classNum", classNum);

    (async () => {
      try {
        const res = await fetch(`/api/teacher/lesson-plans?${params.toString()}`, {
          cache: "no-store",
        });
        const json = (await res.json()) as {
          ok?: boolean;
          subjects?: LessonPlanSubject[];
        };
        if (active && res.ok && json.ok) {
          setSubjects(json.subjects ?? []);
        }
      } finally {
        if (active) setLoading(false);
      }
    })();

    return () => {
      active = false;
    };
  }, [scope, classNum]);

  const q = search.trim().toLowerCase();

  const filteredSubjects = subjects
    .map((subj) => {
      const chapters = subj.chapters.filter((ch) => {
        if (onlyReady && !ch.hasLessonPlan) return false;
        if (!q) return true;
        return (
          ch.title_hi.toLowerCase().includes(q) ||
          ch.title_en.toLowerCase().includes(q) ||
          subj.name_hi.toLowerCase().includes(q) ||
          subj.name_en.toLowerCase().includes(q)
        );
      });
      return { ...subj, chapters };
    })
    .filter((subj) => subj.chapters.length > 0);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="space-y-1.5 border-b border-hairline pb-5">
        <Badge variant="indigo" icon={<BookMarked className="h-3.5 w-3.5" />}>
          {t("केवल शिक्षकों के लिए · आधिकारिक BSEB", "Educator Exclusive · Official BSEB")}
        </Badge>
        <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
          {t("विषय एवं अध्याय पाठ योजनाएँ", "BSEB Subject & Chapter Lesson Plans")}
        </h1>
        <p className="text-sm text-ink-secondary max-w-2xl">
          {t(
            "पीरियड-वार शिक्षण प्रवाह, ब्लैकबोर्ड मुख्य बिंदु, विद्यार्थियों की सामान्य भ्रांतियाँ, कक्षा गतिविधियाँ और प्रिंट-रेडी गृहकार्य।",
            "Period-by-period teaching flow, blackboard summaries, common student misconceptions, classroom activities, and printable homework."
          )}
        </p>
      </div>

      {/* Filters */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <Tabs
          variant="pills"
          value={scope}
          onChange={setScope}
          items={[
            { id: "my", label: t("मेरे विषय", "My Subjects") },
            { id: "all", label: t("सभी BSEB विषय", "All BSEB Subjects") },
          ]}
        />

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 w-full md:w-auto md:min-w-[480px]">
          <Input
            placeholder={t("अध्याय या विषय खोजें...", "Search chapter or subject...")}
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            leftIcon={<Search className="h-4 w-4" />}
          />
          <Select
            value={classNum}
            onChange={(e) => setClassNum(e.target.value)}
            options={[
              { value: "", label: t("सभी कक्षाएँ (9–12 व कौशल लैब)", "All Classes (9–12 & Skill Labs)") },
              { value: "0", label: t("कौशल एवं नींव लैब (9–12)", "Skill & Foundation Labs (9–12)") },
              { value: "9", label: t("कक्षा 9", "Class 9") },
              { value: "10", label: t("कक्षा 10", "Class 10") },
              { value: "11", label: t("कक्षा 11", "Class 11") },
              { value: "12", label: t("कक्षा 12", "Class 12") },
            ]}
          />
          <button
            type="button"
            onClick={() => setOnlyReady((v) => !v)}
            className={`min-h-[44px] rounded-lg border px-3.5 text-sm font-semibold transition-colors ${
              onlyReady
                ? "border-emerald-mastery bg-emerald-soft text-emerald-ink"
                : "border-hairline-strong bg-surface text-ink-secondary hover:text-ink"
            }`}
          >
            {onlyReady
              ? t("तैयार योजनाएँ: चालू", "Ready Plans Only: On")
              : t("केवल तैयार योजनाएँ", "Ready Plans Only")}
          </button>
        </div>
      </div>

      {loading ? (
        <div className="flex min-h-[35vh] items-center justify-center">
          <div className="flex items-center gap-2 text-sm text-ink-secondary">
            <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
            <span>{t("पाठ योजनाएँ लोड हो रही हैं...", "Loading lesson plans...")}</span>
          </div>
        </div>
      ) : filteredSubjects.length === 0 ? (
        <Card variant="subtle" className="text-center py-10 space-y-2">
          <BookMarked className="mx-auto h-8 w-8 text-ink-muted" />
          <p className="text-base font-bold text-ink">
            {t("कोई पाठ योजना नहीं मिली", "No matching chapters found")}
          </p>
          <p className="text-sm text-ink-secondary">
            {scope === "my"
              ? t(
                  "सभी BSEB विषयों को देखने के लिए 'सभी BSEB विषय' टैब चुनें।",
                  "Switch to 'All BSEB Subjects' to browse all available lesson plans."
                )
              : t("कृपया खोज शब्द या कक्षा फ़िल्टर बदलें।", "Try adjusting your search or class filter.")}
          </p>
        </Card>
      ) : (
        <div className="space-y-6">
          {filteredSubjects.map((subj) => (
            <Card key={subj.id}>
              <CardHeader className="flex-row items-center justify-between gap-3">
                <div>
                  <div className="flex items-center gap-2">
                    <Badge variant={subj.class_num === 0 ? "emerald" : "indigo"}>
                      {subj.class_num === 0
                        ? t("कक्षा 9–12 · कौशल लैब", "Classes 9–12 · Skill Lab")
                        : t(`कक्षा ${subj.class_num}`, `Class ${subj.class_num}`)}
                    </Badge>
                    {subj.stream !== "NA" && subj.stream !== "ALL" && (
                      <Badge variant="neutral">{subj.stream}</Badge>
                    )}
                    <span className="text-xs text-ink-muted">
                      {t("कोड", "Code")} {subj.bseb_code}
                    </span>
                  </div>
                  <CardTitle className="mt-1.5 text-lg">
                    {t(subj.name_hi, subj.name_en)}
                  </CardTitle>
                </div>
                <Badge variant={subj.lessonPlansCount > 0 ? "emerald" : "neutral"}>
                  {subj.lessonPlansCount}/{subj.chapters.length}{" "}
                  {t("पाठ योजना तैयार", "plans ready")}
                </Badge>
              </CardHeader>

              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  {subj.chapters.map((ch) => (
                    <Link
                      key={ch.id}
                      href={`/teacher/lesson-plans/${ch.id}`}
                      className="group flex flex-col justify-between rounded-lg border border-hairline bg-surface-subtle/40 p-4 hover:border-indigo-academic/45 hover:bg-indigo-soft transition-colors"
                    >
                      <div className="space-y-2">
                        <div className="flex items-center justify-between gap-2">
                          <span className="text-xs font-bold text-indigo-ink">
                            {t(`अध्याय ${ch.chapter_no}`, `Chapter ${ch.chapter_no}`)}
                          </span>
                          {ch.hasLessonPlan ? (
                            <Badge
                              variant="emerald"
                              icon={<FileCheck2 className="h-3 w-3" />}
                            >
                              {ch.lessonPlanSummary?.durationPeriods}{" "}
                              {t("पीरियड", "Periods")}
                            </Badge>
                          ) : (
                            <Badge variant="outline">
                              {t("शीघ्र उपलब्ध", "Coming Soon")}
                            </Badge>
                          )}
                        </div>
                        <h3 className="text-sm font-bold text-ink group-hover:text-indigo-ink transition-colors">
                          {t(ch.title_hi, ch.title_en)}
                        </h3>
                        {ch.lessonPlanSummary && (
                          <p className="text-xs text-ink-secondary line-clamp-2 leading-relaxed">
                            {t(
                              ch.lessonPlanSummary.objectivesHi,
                              ch.lessonPlanSummary.objectivesEn
                            )}
                          </p>
                        )}
                      </div>

                      <div className="mt-3 pt-2.5 border-t border-hairline flex items-center justify-between text-xs text-ink-muted">
                        <span className="inline-flex items-center gap-1">
                          <Clock className="h-3.5 w-3.5" />
                          {t(`बोर्ड भारांक: ${ch.bseb_weightage_marks} अंक`, `BSEB Weightage: ${ch.bseb_weightage_marks} marks`)}
                        </span>
                        <span className="inline-flex items-center gap-1 font-semibold text-indigo-ink">
                          {t("खोलें", "Open")}
                          <ArrowRight className="h-3.5 w-3.5" />
                        </span>
                      </div>
                    </Link>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
