"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import {
  AlertTriangle,
  ArrowLeft,
  BookOpen,
  CheckCircle2,
  ClipboardList,
  Clock,
  Lightbulb,
  Loader2,
  PenTool,
  Printer,
  Target,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/Card";
import type { ChapterRow, LessonPlanRow, SubjectRow } from "@/types/database";

interface LessonPlanDetailResponse {
  ok: boolean;
  chapter: ChapterRow;
  subject: SubjectRow | null;
  lessonPlan: LessonPlanRow | null;
  siblingChapters: Array<{
    id: string;
    chapter_no: number;
    title_hi: string;
    title_en: string;
  }>;
}

export function LessonPlanDetailClient({ chapterId }: { chapterId: string }) {
  const { t } = useLanguage();
  const [data, setData] = useState<LessonPlanDetailResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    (async () => {
      try {
        const res = await fetch(`/api/teacher/lesson-plans/${chapterId}`, {
          cache: "no-store",
        });
        const json = (await res.json()) as LessonPlanDetailResponse & { error?: string };
        if (!res.ok || !json.ok) {
          throw new Error(json.error || "Unable to load lesson plan.");
        }
        if (active) setData(json);
      } catch (err) {
        if (active) {
          setError(
            err instanceof Error
              ? err.message
              : t("पाठ योजना लोड नहीं हो सकी।", "Could not load lesson plan.")
          );
        }
      } finally {
        if (active) setLoading(false);
      }
    })();
    return () => {
      active = false;
    };
  }, [chapterId, t]);

  if (loading) {
    return (
      <div className="flex min-h-[45vh] items-center justify-center">
        <div className="flex items-center gap-2 text-sm text-ink-secondary">
          <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
          <span>{t("पाठ योजना खुल रही है...", "Loading Lesson Plan...")}</span>
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <div className="space-y-4">
        <Link href="/teacher/lesson-plans">
          <Button variant="ghost" size="sm" leftIcon={<ArrowLeft className="h-4 w-4" />}>
            {t("सभी पाठ योजनाएँ", "All Lesson Plans")}
          </Button>
        </Link>
        <Card variant="warm">
          <p className="text-sm font-medium text-amber-ink">
            {error ?? t("अध्याय नहीं मिला।", "Chapter not found.")}
          </p>
        </Card>
      </div>
    );
  }

  const { chapter, subject, lessonPlan } = data;

  return (
    <article className="max-w-4xl mx-auto space-y-6 print-sheet">
      {/* Top Controls (hidden when printing) */}
      <div className="flex flex-wrap items-center justify-between gap-3 no-print">
        <Link href="/teacher/lesson-plans">
          <Button variant="ghost" size="sm" leftIcon={<ArrowLeft className="h-4 w-4" />}>
            {t("पाठ योजना सूची", "All Lesson Plans")}
          </Button>
        </Link>
        {lessonPlan && (
          <Button
            variant="primary"
            size="sm"
            onClick={() => window.print()}
            leftIcon={<Printer className="h-4 w-4" />}
          >
            {t("पाठ योजना प्रिंट / PDF करें", "Print / Save Lesson Plan PDF")}
          </Button>
        )}
      </div>

      {/* Editorial Header */}
      <Card variant="indigo" className="print-avoid-break">
        <div className="space-y-2.5">
          <div className="flex flex-wrap items-center gap-2">
            {subject && (
              <Badge variant="indigo">
                {t(`कक्षा ${subject.class_num}`, `Class ${subject.class_num}`)} ·{" "}
                {t(subject.name_hi, subject.name_en)}
              </Badge>
            )}
            <Badge variant="neutral">
              {t(`अध्याय ${chapter.chapter_no}`, `Chapter ${chapter.chapter_no}`)}
            </Badge>
            <Badge variant="amber">
              {t(
                `बोर्ड भारांक: ${chapter.bseb_weightage_marks} अंक`,
                `BSEB Weightage: ${chapter.bseb_weightage_marks} marks`
              )}
            </Badge>
            {lessonPlan && (
              <Badge variant="emerald" icon={<Clock className="h-3 w-3" />}>
                {lessonPlan.duration_periods} {t("पीरियड (40 मिनट)", "Periods (40 mins)")}
              </Badge>
            )}
          </div>

          <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
            {t(chapter.title_hi, chapter.title_en)}
          </h1>

          {(chapter.summary_hi || chapter.summary_en) && (
            <p className="text-sm text-ink-secondary leading-relaxed">
              {t(chapter.summary_hi ?? "", chapter.summary_en ?? "")}
            </p>
          )}
        </div>
      </Card>

      {!lessonPlan ? (
        <Card variant="subtle" className="py-10 text-center space-y-2">
          <BookOpen className="mx-auto h-8 w-8 text-ink-muted" />
          <h2 className="text-base font-bold text-ink">
            {t(
              "इस अध्याय की विस्तृत पाठ योजना अभी संपादकीय तैयारी में है",
              "Detailed lesson plan for this chapter is being prepared"
            )}
          </h2>
          <p className="text-sm text-ink-secondary max-w-md mx-auto">
            {t(
              "इस बीच आप विद्यार्थियों के लिए अपने कक्षा नोट्स और अध्ययन सामग्री 'अध्ययन सामग्री' अनुभाग से साझा कर सकते हैं।",
              "Meanwhile, you can publish your own classroom notes and PDFs via the Materials section."
            )}
          </p>
        </Card>
      ) : (
        <>
          {/* Learning Objectives */}
          <Card className="print-avoid-break">
            <CardHeader>
              <CardTitle className="text-base flex items-center gap-2">
                <Target className="h-4 w-4 text-indigo-ink" />
                {t("शिक्षण उद्देश्य (Learning Objectives)", "Learning Objectives")}
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-sm sm:text-[15px] text-ink leading-[1.85]">
                {t(lessonPlan.objectives_hi, lessonPlan.objectives_en)}
              </p>
            </CardContent>
          </Card>

          {/* Period-by-Period Teaching Flow */}
          {lessonPlan.teaching_steps_json.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle className="text-base flex items-center gap-2">
                  <ClipboardList className="h-4 w-4 text-indigo-ink" />
                  {t(
                    "पीरियड-वार कक्षा शिक्षण प्रवाह",
                    "Period-by-Period Classroom Teaching Flow"
                  )}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {lessonPlan.teaching_steps_json.map((step) => (
                  <div
                    key={step.period_no}
                    className="rounded-lg border border-hairline bg-surface-subtle/40 p-4 space-y-2.5 print-avoid-break"
                  >
                    <div className="flex flex-wrap items-center justify-between gap-2">
                      <div className="flex items-center gap-2">
                        <Badge variant="indigo">
                          {t(`पीरियड ${step.period_no}`, `Period ${step.period_no}`)}
                        </Badge>
                        <h3 className="text-sm font-bold text-ink">
                          {t(step.phase_hi, step.phase_en)}
                        </h3>
                      </div>
                      <span className="text-xs font-semibold text-ink-muted">
                        {step.duration_mins} {t("मिनट", "mins")}
                      </span>
                    </div>

                    <div className="text-sm text-ink leading-relaxed">
                      <span className="font-semibold text-ink-secondary">
                        {t("शिक्षक गतिविधि: ", "Teaching Flow: ")}
                      </span>
                      {t(step.teacher_action_hi, step.teacher_action_en)}
                    </div>

                    <div className="rounded-md border border-emerald-mastery/25 bg-emerald-soft px-3 py-2 text-xs sm:text-sm text-emerald-ink">
                      <span className="font-bold">
                        {t("कक्षा जाँच प्रश्न: ", "Quick Student Check: ")}
                      </span>
                      {t(step.student_check_hi, step.student_check_en)}
                    </div>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}

          {/* Blackboard Key Points */}
          {lessonPlan.blackboard_points_json.length > 0 && (
            <Card className="print-avoid-break">
              <CardHeader>
                <CardTitle className="text-base flex items-center gap-2">
                  <PenTool className="h-4 w-4 text-indigo-ink" />
                  {t("ब्लैकबोर्ड मुख्य बिंदु व सूत्र", "Blackboard Key Points & Formulas")}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {lessonPlan.blackboard_points_json.map((box, idx) => (
                  <div
                    key={idx}
                    className="rounded-paper border border-slate-700/40 bg-slate-900 text-slate-50 p-4 sm:p-5 space-y-2.5"
                  >
                    <h3 className="text-sm font-bold text-amber-300">
                      {t(box.heading_hi, box.heading_en)}
                    </h3>
                    <ul className="space-y-1.5 text-sm leading-relaxed list-disc pl-5">
                      {box.points_hi.map((ptHi, ptIdx) => (
                        <li key={ptIdx}>
                          {t(ptHi, box.points_en[ptIdx] ?? ptHi)}
                        </li>
                      ))}
                    </ul>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}

          {/* Common Student Misconceptions */}
          {lessonPlan.common_student_misconceptions_json.length > 0 && (
            <Card variant="warm" className="print-avoid-break">
              <CardHeader>
                <CardTitle className="text-base flex items-center gap-2">
                  <AlertTriangle className="h-4 w-4 text-amber-ink" />
                  {t(
                    "विद्यार्थियों की सामान्य भ्रांतियाँ और सुधार",
                    "Common Student Misconceptions & How to Fix"
                  )}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                {lessonPlan.common_student_misconceptions_json.map((item, idx) => (
                  <div
                    key={idx}
                    className="rounded-lg border border-amber-warm/25 bg-surface p-3.5 space-y-2"
                  >
                    <p className="text-sm font-semibold text-crimson-ink">
                      {t("सामान्य त्रुटि: ", "Misconception: ")}
                      {t(item.misconception_hi, item.misconception_en)}
                    </p>
                    <p className="text-sm text-emerald-ink flex items-start gap-1.5">
                      <CheckCircle2 className="h-4 w-4 shrink-0 mt-0.5" />
                      <span>
                        <strong>{t("सही समझ: ", "Correction: ")}</strong>
                        {t(item.correction_hi, item.correction_en)}
                      </span>
                    </p>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}

          {/* Hands-on Classroom Activities */}
          {lessonPlan.classroom_activities_json.length > 0 && (
            <Card className="print-avoid-break">
              <CardHeader>
                <CardTitle className="text-base flex items-center gap-2">
                  <Lightbulb className="h-4 w-4 text-amber-ink" />
                  {t("कक्षा गतिविधि / प्रयोग", "Classroom Activities & Demonstrations")}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                {lessonPlan.classroom_activities_json.map((act, idx) => (
                  <div
                    key={idx}
                    className="rounded-lg border border-hairline bg-surface-subtle/50 p-4 space-y-2"
                  >
                    <h3 className="text-sm font-bold text-ink">
                      {t(act.title_hi, act.title_en)}
                    </h3>
                    <p className="text-xs text-ink-secondary">
                      <strong>{t("आवश्यक सामग्री: ", "Materials: ")}</strong>
                      {t(act.materials_hi, act.materials_en)}
                    </p>
                    <p className="text-sm text-ink leading-relaxed">
                      {t(act.steps_hi, act.steps_en)}
                    </p>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}

          {/* Differentiated Homework */}
          {lessonPlan.homework_json.length > 0 && (
            <Card className="print-avoid-break">
              <CardHeader>
                <CardTitle className="text-base flex items-center gap-2">
                  <BookOpen className="h-4 w-4 text-indigo-ink" />
                  {t("स्तरीय गृहकार्य (Homework)", "Tiered Homework Assignments")}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-2.5">
                {lessonPlan.homework_json.map((hw, idx) => (
                  <div
                    key={idx}
                    className="flex flex-col sm:flex-row sm:items-start gap-2.5 rounded-lg border border-hairline p-3.5"
                  >
                    <Badge
                      variant={
                        hw.level === "FOUNDATION"
                          ? "emerald"
                          : hw.level === "BOARD"
                          ? "indigo"
                          : "amber"
                      }
                    >
                      {hw.level === "FOUNDATION"
                        ? t("बुनियादी", "Foundation")
                        : hw.level === "BOARD"
                        ? t("बोर्ड स्तर", "Board Level")
                        : t("चुनौती", "Challenge")}
                    </Badge>
                    <p className="text-sm text-ink leading-relaxed">
                      {t(hw.task_hi, hw.task_en)}
                    </p>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}
        </>
      )}
    </article>
  );
}
