"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import {
  AlertTriangle,
  ArrowRight,
  BookMarked,
  Clock,
  FileCheck2,
  Loader2,
  RefreshCw,
  Search,
  Sparkles,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
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
  isUniversal?: boolean;
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
  const [totalPlansAvailable, setTotalPlansAvailable] = useState<number>(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [reloadTick, setReloadTick] = useState(0);

  useEffect(() => {
    let active = true;
    setLoading(true);
    setError(null);
    const params = new URLSearchParams({ scope });
    if (classNum) params.set("classNum", classNum);

    (async () => {
      try {
        const res = await fetch(`/api/teacher/lesson-plans?${params.toString()}`, {
          cache: "no-store",
        });
        const json = (await res.json().catch(() => ({}))) as {
          ok?: boolean;
          subjects?: LessonPlanSubject[];
          totalPlansAvailable?: number;
          error?: string;
        };
        if (!res.ok || !json.ok) {
          throw new Error(
            json.error || `Unable to load lesson plans (HTTP ${res.status}).`
          );
        }
        if (active) {
          setSubjects(Array.isArray(json.subjects) ? json.subjects : []);
          setTotalPlansAvailable(
            typeof json.totalPlansAvailable === "number" ? json.totalPlansAvailable : 0
          );
        }
      } catch (err) {
        if (active) {
          setSubjects([]);
          setTotalPlansAvailable(0);
          setError(
            err instanceof Error
              ? err.message
              : "Unable to load lesson plans right now."
          );
        }
      } finally {
        if (active) setLoading(false);
      }
    })();

    return () => {
      active = false;
    };
  }, [scope, classNum, reloadTick]);

  const q = search.trim().toLowerCase();

  const filteredSubjects = subjects
    .map((subj) => {
      const chapters = (Array.isArray(subj.chapters) ? subj.chapters : []).filter((ch) => {
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

  const nonUniversalSubjects = subjects.filter((s) => !s.isUniversal && s.class_num !== 0);
  const nonUniversalReadyCount = nonUniversalSubjects.reduce(
    (sum, s) => sum + s.lessonPlansCount,
    0
  );
  const universalReadyCount = subjects
    .filter((s) => s.isUniversal || s.class_num === 0)
    .reduce((sum, s) => sum + s.lessonPlansCount, 0);
  const showNarrowMySubjectHint =
    !loading &&
    !error &&
    scope === "my" &&
    !classNum &&
    !q &&
    nonUniversalReadyCount === 0 &&
    universalReadyCount > 0;

  const hasActiveFilters = Boolean(q || classNum || onlyReady);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 border-b border-hairline pb-5">
        <div className="space-y-1.5">
          <div className="flex flex-wrap items-center gap-2">
            <Badge variant="indigo" icon={<BookMarked className="h-3.5 w-3.5" />}>
              {t("केवल शिक्षकों के लिए · आधिकारिक BSEB", "Educator Exclusive · Official BSEB")}
            </Badge>
            {!loading && !error && (
              <Badge variant="emerald" icon={<FileCheck2 className="h-3.5 w-3.5" />}>
                {totalPlansAvailable}{" "}
                {t("तैयार पाठ योजनाएँ", "Ready Lesson Plans")}
              </Badge>
            )}
          </div>
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

      {showNarrowMySubjectHint && (
        <Card variant="subtle" padding="sm">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
            <div className="flex items-start gap-2.5">
              <Sparkles className="h-4 w-4 text-indigo-ink shrink-0 mt-0.5" />
              <p className="text-xs sm:text-sm text-ink-secondary leading-relaxed">
                {t(
                  `सभी शिक्षकों के लिए ${universalReadyCount} ICT और English Foundation पाठ योजनाएँ नीचे तैयार हैं। अन्य BSEB विषयों की सभी पाठ योजनाएँ देखने के लिए 'सभी BSEB विषय' खोलें।`,
                  `${universalReadyCount} universal ICT & English Foundation lesson plans are ready below for all teachers. Switch to All BSEB Subjects to browse every subject's ready plans.`
                )}
              </p>
            </div>
            <Button
              size="sm"
              variant="secondary"
              onClick={() => setScope("all")}
              className="shrink-0"
            >
              {t("सभी BSEB विषय देखें", "Browse All BSEB Subjects")}
            </Button>
          </div>
        </Card>
      )}

      {loading ? (
        <div className="flex min-h-[35vh] items-center justify-center">
          <div className="flex items-center gap-2 text-sm text-ink-secondary">
            <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
            <span>{t("पाठ योजनाएँ लोड हो रही हैं...", "Loading lesson plans...")}</span>
          </div>
        </div>
      ) : error ? (
        <Card variant="warm" className="py-8 px-6 text-center space-y-3">
          <AlertTriangle className="mx-auto h-8 w-8 text-amber-ink" />
          <p className="text-base font-bold text-ink">
            {t("पाठ योजनाएँ लोड नहीं हो सकीं", "Could not load lesson plans")}
          </p>
          <p className="text-sm text-amber-ink max-w-md mx-auto">
            {t(
              "सर्वर से पाठ योजनाएँ प्राप्त करते समय अस्थायी समस्या आई। कृपया पुनः प्रयास करें।",
              error
            )}
          </p>
          <div className="pt-1 flex justify-center">
            <Button
              variant="primary"
              size="sm"
              leftIcon={<RefreshCw className="h-4 w-4" />}
              onClick={() => setReloadTick((n) => n + 1)}
            >
              {t("पुनः प्रयास करें", "Retry")}
            </Button>
          </div>
        </Card>
      ) : filteredSubjects.length === 0 ? (
        <Card variant="subtle" className="text-center py-10 px-6 space-y-3">
          <BookMarked className="mx-auto h-8 w-8 text-ink-muted" />
          <p className="text-base font-bold text-ink">
            {t("इस फ़िल्टर में कोई पाठ योजना नहीं मिली", "No matching chapters found")}
          </p>
          <p className="text-sm text-ink-secondary max-w-md mx-auto">
            {scope === "my"
              ? t(
                  "आपके चुने गए विषयों में अभी विस्तृत पाठ योजनाएँ जोड़ी जा रही हैं। सभी तैयार BSEB पाठ योजनाएँ तुरंत देखने के लिए नीचे बटन दबाएँ।",
                  "Detailed lesson plans for your assigned subject are being expanded. Switch to All BSEB Subjects to browse all ready lesson plans right away."
                )
              : t(
                  "कृपया खोज शब्द या कक्षा फ़िल्टर बदलकर पुनः देखें।",
                  "Try clearing your search or adjusting the class filter."
                )}
          </p>
          <div className="flex flex-wrap items-center justify-center gap-2.5 pt-1">
            {scope === "my" && (
              <Button
                size="sm"
                variant="primary"
                onClick={() => {
                  setScope("all");
                  setClassNum("");
                  setSearch("");
                  setOnlyReady(false);
                }}
              >
                {t("सभी BSEB विषय देखें", "View All BSEB Subjects")}
              </Button>
            )}
            {hasActiveFilters && (
              <Button
                size="sm"
                variant="secondary"
                onClick={() => {
                  setClassNum("");
                  setSearch("");
                  setOnlyReady(false);
                }}
              >
                {t("फ़िल्टर साफ़ करें", "Clear Filters")}
              </Button>
            )}
          </div>
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
