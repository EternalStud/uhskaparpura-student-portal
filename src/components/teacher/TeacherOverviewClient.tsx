"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import {
  ArrowRight,
  BookMarked,
  ClipboardCheck,
  Clock,
  FilePlus2,
  FolderUp,
  Loader2,
  MessageSquareMore,
  Radio,
  SlidersHorizontal,
  ThumbsUp,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/Card";

interface OverviewData {
  teacher: {
    fullName: string;
    teacherTitle: string | null;
    schoolName: string | null;
    assignedClasses: number[];
    assignedSubjects: Array<{
      id: string;
      class_num: number;
      name_hi: string;
      name_en: string;
      accent_color: string;
    }>;
  };
  stats: {
    myOpenDoubtsCount: number;
    allSchoolOpenDoubtsCount: number;
    activeExamsCount: number;
    publishedMaterialsCount: number;
    submittedPapersCount: number;
    availableLessonPlansCount: number;
  };
  priorityDoubts: Array<{
    id: string;
    classNum: number;
    questionText: string;
    upvoteCount: number;
    createdAt: string;
    inMySubjects: boolean;
    studentName: string;
    studentRollNo: number | null;
    subjectNameHi: string;
    subjectNameEn: string;
  }>;
  recentExams: Array<{
    id: string;
    title: string;
    examMode: "LIVE_PIN" | "SCHEDULED";
    scopeType: string;
    classNum: number;
    roomPin: string | null;
    durationMins: number;
    startsAt: string | null;
    endsAt: string | null;
    status: "DRAFT" | "LOBBY" | "ACTIVE" | "ENDED";
    questionCount: number;
    subjectNameHi: string;
    subjectNameEn: string;
  }>;
}

function formatPin(pin: string): string {
  return pin.length === 6 ? `${pin.slice(0, 3)} ${pin.slice(3)}` : pin;
}

export function TeacherOverviewClient() {
  const { t } = useLanguage();
  const [data, setData] = useState<OverviewData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    (async () => {
      try {
        const res = await fetch("/api/teacher/overview", { cache: "no-store" });
        const json = (await res.json()) as OverviewData & { ok?: boolean; error?: string };
        if (!res.ok || !json.ok) {
          throw new Error(json.error || "Failed to load dashboard.");
        }
        if (active) setData(json);
      } catch (err) {
        if (active) {
          setError(
            err instanceof Error
              ? err.message
              : t("जानकारी लोड नहीं हो सकी।", "Could not load overview.")
          );
        }
      } finally {
        if (active) setLoading(false);
      }
    })();
    return () => {
      active = false;
    };
  }, [t]);

  if (loading) {
    return (
      <div className="flex min-h-[45vh] items-center justify-center">
        <div className="flex items-center gap-2.5 text-sm font-medium text-ink-secondary">
          <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" aria-hidden="true" />
          <span>{t("शिक्षक डेस्क तैयार हो रहा है...", "Loading Educator Studio...")}</span>
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <Card variant="warm">
        <p className="text-sm font-medium text-amber-ink">
          {error ?? t("डेटा लोड नहीं हो सका।", "Unable to load studio overview.")}
        </p>
      </Card>
    );
  }

  const quickActions = [
    {
      href: "/teacher/lesson-plans",
      icon: BookMarked,
      titleHi: "पाठ योजना खोलें",
      titleEn: "Open Lesson Plans",
      descHi: "पीरियड-वार शिक्षण योजना, ब्लैकबोर्ड बिंदु और गृहकार्य देखें",
      descEn: "Period-wise BSEB teaching flow, board notes & homework",
      accent: "text-indigo-ink bg-indigo-soft",
    },
    {
      href: "/teacher/materials",
      icon: FolderUp,
      titleHi: "अध्ययन सामग्री साझा करें",
      titleEn: "Publish Study Material",
      descHi: "कक्षा नोट्स, पीडीएफ, चित्र या वीडियो विद्यार्थियों तक पहुँचाएँ",
      descEn: "Share notes, PDFs, diagrams, or lesson videos with students",
      accent: "text-emerald-ink bg-emerald-soft",
    },
    {
      href: "/teacher/exams/new",
      icon: ClipboardCheck,
      titleHi: "नई परीक्षा शुरू करें",
      titleEn: "Launch Classroom Exam",
      descHi: "लाइव रूम कोड या निर्धारित समय वाली परीक्षा तुरंत बनाएँ",
      descEn: "Create a Live Room Code test or Scheduled assessment",
      accent: "text-amber-ink bg-amber-soft",
    },
    {
      href: "/teacher/contribute",
      icon: FilePlus2,
      titleHi: "प्रश्न पत्र योगदान दें",
      titleEn: "Submit Question Paper",
      descHi: "विद्यालय के प्रश्न पत्र संपादकीय समीक्षा के लिए भेजें",
      descEn: "Submit school question papers for editorial review",
      accent: "text-indigo-ink bg-surface-subtle",
    },
  ];

  return (
    <div className="space-y-8">
      {/* Editorial Header */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between border-b border-hairline pb-6">
        <div className="space-y-1.5">
          <p className="text-xs font-semibold uppercase tracking-wider text-indigo-ink">
            {t("शिक्षक स्टूडियो", "Educator Studio")}
            {data.teacher.schoolName ? ` · ${data.teacher.schoolName}` : ""}
          </p>
          <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-ink">
            {t(`नमस्ते, ${data.teacher.fullName}`, `Welcome, ${data.teacher.fullName}`)}
          </h1>
          <p className="text-sm text-ink-secondary">
            {data.teacher.assignedClasses.length > 0
              ? t(
                  `आपकी कक्षाएँ: कक्षा ${data.teacher.assignedClasses.join(", ")} · ${data.teacher.assignedSubjects.length} विषय चयनित`,
                  `Teaching Classes ${data.teacher.assignedClasses.join(", ")} · ${data.teacher.assignedSubjects.length} subjects configured`
                )
              : t(
                  "अपने विषय और कक्षाएँ चुनें ताकि शंकाएँ और पाठ योजनाएँ व्यवस्थित दिखें।",
                  "Configure your classes and subjects to personalize doubts and lesson plans."
                )}
          </p>
        </div>

        <div className="flex flex-wrap items-center gap-2.5">
          <Link href="/teacher/onboarding">
            <Button
              variant="secondary"
              size="sm"
              leftIcon={<SlidersHorizontal className="h-4 w-4" />}
            >
              {t("विषय बदलें", "Edit Subjects")}
            </Button>
          </Link>
          <Link href="/teacher/exams/new">
            <Button
              variant="primary"
              size="sm"
              leftIcon={<ClipboardCheck className="h-4 w-4" />}
            >
              {t("नई परीक्षा बनाएँ", "New Exam")}
            </Button>
          </Link>
        </div>
      </div>

      {/* Calm Key Metrics */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <Card padding="sm">
          <p className="text-xs font-semibold text-ink-muted">
            {t("मेरे विषयों के अनुत्तरित प्रश्न", "Doubts in My Subjects")}
          </p>
          <div className="mt-2 flex items-baseline justify-between">
            <span className="text-3xl font-bold text-ink">
              {data.stats.myOpenDoubtsCount}
            </span>
            <Badge variant={data.stats.myOpenDoubtsCount > 0 ? "amber" : "emerald"}>
              {data.stats.myOpenDoubtsCount > 0
                ? t("प्रतीक्षारत", "Waiting")
                : t("सभी उत्तरित", "All clear")}
            </Badge>
          </div>
          <p className="mt-1.5 text-xs text-ink-secondary">
            {t(
              `पूरे विद्यालय में कुल ${data.stats.allSchoolOpenDoubtsCount} खुले प्रश्न`,
              `${data.stats.allSchoolOpenDoubtsCount} total open across school`
            )}
          </p>
        </Card>

        <Card padding="sm">
          <p className="text-xs font-semibold text-ink-muted">
            {t("सक्रिय परीक्षाएँ", "Live & Active Exams")}
          </p>
          <div className="mt-2 flex items-baseline justify-between">
            <span className="text-3xl font-bold text-ink">
              {data.stats.activeExamsCount}
            </span>
            <Badge variant={data.stats.activeExamsCount > 0 ? "indigo" : "neutral"}>
              {data.stats.activeExamsCount > 0 ? t("चालू", "Running") : t("तैयार", "Ready")}
            </Badge>
          </div>
          <p className="mt-1.5 text-xs text-ink-secondary">
            {t("लाइव रूम कोड और निर्धारित परीक्षा", "Live Room Code & Scheduled")}
          </p>
        </Card>

        <Card padding="sm">
          <p className="text-xs font-semibold text-ink-muted">
            {t("प्रकाशित अध्ययन सामग्री", "Published Materials")}
          </p>
          <div className="mt-2 flex items-baseline justify-between">
            <span className="text-3xl font-bold text-ink">
              {data.stats.publishedMaterialsCount}
            </span>
            <Badge variant="emerald">{t("विद्यालय", "School")}</Badge>
          </div>
          <p className="mt-1.5 text-xs text-ink-secondary">
            {t("नोट्स, पीडीएफ और वीडियो", "Notes, PDFs & Videos")}
          </p>
        </Card>

        <Card padding="sm">
          <p className="text-xs font-semibold text-ink-muted">
            {t("उपलब्ध पाठ योजनाएँ", "Official Lesson Plans")}
          </p>
          <div className="mt-2 flex items-baseline justify-between">
            <span className="text-3xl font-bold text-ink">
              {data.stats.availableLessonPlansCount}
            </span>
            <Badge variant="neutral">{t("BSEB", "BSEB")}</Badge>
          </div>
          <p className="mt-1.5 text-xs text-ink-secondary">
            {t(
              `${data.stats.submittedPapersCount} प्रश्न पत्र योगदान भेजे गए`,
              `${data.stats.submittedPapersCount} question papers contributed`
            )}
          </p>
        </Card>
      </div>

      {/* Quick Actions Grid */}
      <section aria-labelledby="quick-actions-heading" className="space-y-3">
        <h2
          id="quick-actions-heading"
          className="text-base font-bold text-ink tracking-tight"
        >
          {t("त्वरित कार्य", "Quick Actions")}
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
          {quickActions.map((item) => {
            const Icon = item.icon;
            return (
              <Link key={item.href} href={item.href} className="group block">
                <Card
                  variant="interactive"
                  padding="sm"
                  className="h-full flex flex-col justify-between gap-3"
                >
                  <div>
                    <div
                      className={`inline-flex h-10 w-10 items-center justify-center rounded-lg ${item.accent}`}
                    >
                      <Icon className="h-5 w-5" aria-hidden="true" />
                    </div>
                    <h3 className="mt-3 text-sm font-bold text-ink group-hover:text-indigo-ink transition-colors">
                      {t(item.titleHi, item.titleEn)}
                    </h3>
                    <p className="mt-1 text-xs text-ink-secondary leading-relaxed">
                      {t(item.descHi, item.descEn)}
                    </p>
                  </div>
                  <div className="flex items-center gap-1 text-xs font-semibold text-indigo-ink">
                    <span>{t("खोलें", "Open")}</span>
                    <ArrowRight className="h-3.5 w-3.5 transition-transform group-hover:translate-x-0.5" />
                  </div>
                </Card>
              </Link>
            );
          })}
        </div>
      </section>

      {/* Two-Column Operational View: Waiting Doubts + Active Exams */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Waiting Open Doubts */}
        <Card>
          <CardHeader className="flex-row items-center justify-between gap-3">
            <div>
              <CardTitle className="text-base">
                {t("विद्यार्थियों के प्रतीक्षारत प्रश्न", "Waiting Student Doubts")}
              </CardTitle>
              <CardDescription>
                {t(
                  "सर्वाधिक 'मेरा भी यही प्रश्न' वाले खुले प्रश्न",
                  "Highest-priority open classroom questions"
                )}
              </CardDescription>
            </div>
            <Link href="/teacher/doubts">
              <Button variant="ghost" size="sm" rightIcon={<ArrowRight className="h-3.5 w-3.5" />}>
                {t("सभी देखें", "View all")}
              </Button>
            </Link>
          </CardHeader>
          <CardContent className="space-y-3">
            {data.priorityDoubts.length === 0 ? (
              <div className="rounded-lg border border-hairline bg-surface-subtle/60 p-6 text-center">
                <MessageSquareMore className="mx-auto h-7 w-7 text-ink-muted" aria-hidden="true" />
                <p className="mt-2 text-sm font-semibold text-ink">
                  {t("अभी कोई अनुत्तरित प्रश्न नहीं है", "No unanswered doubts right now")}
                </p>
                <p className="mt-1 text-xs text-ink-secondary">
                  {t(
                    "जब विद्यार्थी कक्षा के खुले मंच पर प्रश्न पूछेंगे, वे यहाँ दिखाई देंगे।",
                    "New open classroom doubts from your students will appear here."
                  )}
                </p>
              </div>
            ) : (
              data.priorityDoubts.map((doubt) => (
                <Link
                  key={doubt.id}
                  href={`/teacher/doubts?focus=${doubt.id}`}
                  className="block rounded-lg border border-hairline bg-surface-subtle/40 p-3.5 hover:border-indigo-academic/40 hover:bg-indigo-soft transition-colors"
                >
                  <div className="flex flex-wrap items-center justify-between gap-2">
                    <div className="flex items-center gap-2">
                      <Badge variant="indigo">
                        {t(`कक्षा ${doubt.classNum}`, `Class ${doubt.classNum}`)} ·{" "}
                        {t(doubt.subjectNameHi, doubt.subjectNameEn)}
                      </Badge>
                      {!doubt.inMySubjects && (
                        <Badge variant="outline">
                          {t("अन्य विषय", "School-wide")}
                        </Badge>
                      )}
                    </div>
                    <span className="inline-flex items-center gap-1 text-xs font-semibold text-amber-ink">
                      <ThumbsUp className="h-3.5 w-3.5" aria-hidden="true" />
                      {doubt.upvoteCount}
                    </span>
                  </div>
                  <p className="mt-2 text-sm text-ink line-clamp-2 leading-relaxed">
                    {doubt.questionText}
                  </p>
                  <p className="mt-1.5 text-xs text-ink-muted">
                    {doubt.studentName}
                    {doubt.studentRollNo ? ` · ${t("रोल", "Roll")} ${doubt.studentRollNo}` : ""}
                  </p>
                </Link>
              ))
            )}
          </CardContent>
        </Card>

        {/* Active & Upcoming Exams */}
        <Card>
          <CardHeader className="flex-row items-center justify-between gap-3">
            <div>
              <CardTitle className="text-base">
                {t("सक्रिय एवं ड्राफ्ट परीक्षाएँ", "Active & Upcoming Exams")}
              </CardTitle>
              <CardDescription>
                {t(
                  "लाइव प्रोजेक्टर मॉनिटर खोलें या परीक्षा प्रारंभ करें",
                  "Open the live projector monitor or launch a draft"
                )}
              </CardDescription>
            </div>
            <Link href="/teacher/exams">
              <Button variant="ghost" size="sm" rightIcon={<ArrowRight className="h-3.5 w-3.5" />}>
                {t("परीक्षा केंद्र", "All Exams")}
              </Button>
            </Link>
          </CardHeader>
          <CardContent className="space-y-3">
            {data.recentExams.length === 0 ? (
              <div className="rounded-lg border border-hairline bg-surface-subtle/60 p-6 text-center">
                <ClipboardCheck className="mx-auto h-7 w-7 text-ink-muted" aria-hidden="true" />
                <p className="mt-2 text-sm font-semibold text-ink">
                  {t("अभी कोई सक्रिय परीक्षा नहीं है", "No active exams yet")}
                </p>
                <p className="mt-1 text-xs text-ink-secondary">
                  {t(
                    "अध्याय या विषय की लाइव परीक्षा कुछ सेकंड में शुरू करें।",
                    "Create a chapter or subject assessment in minutes."
                  )}
                </p>
                <Link href="/teacher/exams/new" className="inline-block mt-3">
                  <Button size="sm" variant="primary">
                    {t("पहली परीक्षा बनाएँ", "Create First Exam")}
                  </Button>
                </Link>
              </div>
            ) : (
              data.recentExams.map((exam) => (
                <div
                  key={exam.id}
                  className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 rounded-lg border border-hairline bg-surface-subtle/40 p-3.5"
                >
                  <div className="min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <Badge
                        variant={
                          exam.status === "ACTIVE"
                            ? "emerald"
                            : exam.status === "LOBBY"
                            ? "amber"
                            : "neutral"
                        }
                        icon={
                          exam.status === "ACTIVE" || exam.status === "LOBBY" ? (
                            <Radio className="h-3 w-3" />
                          ) : undefined
                        }
                      >
                        {exam.status === "ACTIVE"
                          ? t("चालू", "Live")
                          : exam.status === "LOBBY"
                          ? t("प्रतीक्षालय", "Lobby")
                          : t("ड्राफ्ट", "Draft")}
                      </Badge>
                      <span className="text-xs font-medium text-ink-secondary">
                        {t(`कक्षा ${exam.classNum}`, `Class ${exam.classNum}`)} ·{" "}
                        {t(exam.subjectNameHi, exam.subjectNameEn)}
                      </span>
                    </div>
                    <p className="mt-1.5 text-sm font-bold text-ink truncate">{exam.title}</p>
                    <div className="mt-1 flex flex-wrap items-center gap-3 text-xs text-ink-muted">
                      <span className="inline-flex items-center gap-1">
                        <Clock className="h-3.5 w-3.5" />
                        {exam.durationMins} {t("मिनट", "mins")} · {exam.questionCount}{" "}
                        {t("प्रश्न", "Qs")}
                      </span>
                      {exam.roomPin && (
                        <span className="font-mono font-bold text-indigo-ink">
                          {t("कोड", "PIN")}: {formatPin(exam.roomPin)}
                        </span>
                      )}
                    </div>
                  </div>

                  <Link href={`/teacher/exams/${exam.id}/monitor`} className="shrink-0">
                    <Button size="sm" variant={exam.status === "DRAFT" ? "secondary" : "primary"}>
                      {exam.status === "DRAFT"
                        ? t("खोलें", "Open")
                        : t("मॉनिटर", "Monitor")}
                    </Button>
                  </Link>
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
