"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import {
  AlertTriangle,
  ArrowRight,
  BookOpen,
  CheckCircle2,
  Clock,
  GraduationCap,
  HelpCircle,
  RefreshCw,
  ShieldCheck,
  Users,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui";

interface OverviewData {
  school: {
    udise_code: string;
    school_name: string;
    school_name_hi: string | null;
    district_name: string;
    block_name: string | null;
    cluster_name: string | null;
    status: string;
  } | null;
  stats: {
    activeStudents: number;
    inactiveStudents: number;
    studentsConfiguredSubjects: number;
    classCounts: Record<string, number>;
    streamCounts: Record<string, number>;
    activeTeachers: number;
    schoolAdminsCount: number;
    configuredTeachers: number;
    coveredSubjectsCount: number;
    openDoubtsCount: number;
    answeredDoubtsCount: number;
    resolvedDoubtsCount: number;
  };
  unassignedDoubtAlerts: Array<{
    subjectId: string;
    nameEn: string;
    nameHi: string;
    classNum: number;
    openCount: number;
  }>;
  recentSyncLogs: Array<{
    id: string;
    sync_type: string;
    added_count: number;
    updated_count: number;
    deactivated_count: number;
    skipped_count: number;
    created_at: string;
  }>;
}

export default function SchoolOverviewPage() {
  const { t } = useLanguage();
  const [data, setData] = useState<OverviewData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    fetch("/api/school/overview", { cache: "no-store" })
      .then(async (res) => {
        if (!res.ok) throw new Error("Failed to load overview");
        return (await res.json()) as OverviewData;
      })
      .then((json) => {
        if (active) setData(json);
      })
      .catch(() => {
        if (active)
          setError(
            t("विद्यालय विवरण लोड नहीं हो सका।", "Unable to load school overview.")
          );
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
  }, [t]);

  if (loading) {
    return (
      <div className="space-y-6 animate-pulse">
        <div className="h-24 rounded-paper bg-surface-subtle border border-hairline" />
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {[1, 2, 3, 4].map((i) => (
            <div key={i} className="h-28 rounded-paper bg-surface-subtle border border-hairline" />
          ))}
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <Card>
        <CardContent className="py-10 text-center space-y-3">
          <AlertTriangle className="h-8 w-8 text-amber-ink mx-auto" />
          <p className="text-sm text-ink-secondary">{error}</p>
        </CardContent>
      </Card>
    );
  }

  const { school, stats, unassignedDoubtAlerts, recentSyncLogs } = data;
  const teacherCoveragePct =
    stats.activeTeachers > 0
      ? Math.round((stats.configuredTeachers / stats.activeTeachers) * 100)
      : 0;

  return (
    <div className="space-y-6">
      {/* Institutional Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 pb-4 border-b border-hairline">
        <div>
          <div className="flex flex-wrap items-center gap-2">
            <Badge variant="emerald" icon={<ShieldCheck className="h-3.5 w-3.5" />}>
              {t("सक्रिय विद्यालय", "Active School")}
            </Badge>
            <Badge variant="neutral">UDISE: {school?.udise_code}</Badge>
          </div>
          <h1 className="mt-2 text-2xl sm:text-3xl font-bold text-ink tracking-tight">
            {t(
              school?.school_name_hi || school?.school_name || "विद्यालय डैशबोर्ड",
              school?.school_name || "School Dashboard"
            )}
          </h1>
          <p className="mt-1 text-sm text-ink-secondary">
            {[school?.block_name, school?.district_name].filter(Boolean).join(", ")}
          </p>
        </div>

        <div className="flex flex-wrap gap-2">
          <Link href="/school/sync">
            <Button variant="primary" leftIcon={<RefreshCw className="h-4 w-4" />}>
              {t("सूची अपडेट करें", "Update Roster")}
            </Button>
          </Link>
          <Link href="/school/teachers">
            <Button variant="secondary" leftIcon={<Users className="h-4 w-4" />}>
              {t("शिक्षक एवं विषय", "Staff & Subjects")}
            </Button>
          </Link>
        </div>
      </div>

      {/* Unassigned-Subject Doubt Alert */}
      {unassignedDoubtAlerts.length > 0 && (
        <Card variant="warm" padding="md">
          <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
            <div className="flex items-start gap-3">
              <AlertTriangle className="h-5 w-5 text-amber-ink shrink-0 mt-0.5" />
              <div>
                <h2 className="text-sm font-bold text-ink">
                  {t(
                    "बिना शिक्षक-आवंटित विषयों में छात्रों के प्रश्न प्रतीक्षारत हैं",
                    "Student doubts waiting in subjects without an assigned teacher"
                  )}
                </h2>
                <p className="mt-1 text-xs text-ink-secondary">
                  {t(
                    "कृपया इन विषयों के लिए शिक्षकों को आवंटित करें ताकि छात्रों को समय पर उत्तर मिल सके।",
                    "Assign teachers to these subjects so student questions receive timely answers."
                  )}
                </p>
                <div className="mt-3 flex flex-wrap gap-2">
                  {unassignedDoubtAlerts.map((alert) => (
                    <Badge key={alert.subjectId} variant="amber">
                      {t(`कक्षा ${alert.classNum}`, `Class ${alert.classNum}`)} ·{" "}
                      {t(alert.nameHi, alert.nameEn)} ({alert.openCount})
                    </Badge>
                  ))}
                </div>
              </div>
            </div>
            <Link href="/school/teachers" className="shrink-0">
              <Button variant="amber" size="sm" rightIcon={<ArrowRight className="h-4 w-4" />}>
                {t("विषय आवंटित करें", "Assign Staff")}
              </Button>
            </Link>
          </div>
        </Card>
      )}

      {/* Key Institutional Metrics */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card padding="md">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-ink-secondary uppercase tracking-wider">
              {t("सक्रिय विद्यार्थी (9–12)", "Active Students (9–12)")}
            </span>
            <GraduationCap className="h-5 w-5 text-indigo-ink" />
          </div>
          <p className="mt-2 text-3xl font-bold text-ink">{stats.activeStudents}</p>
          <p className="mt-1 text-xs text-ink-muted">
            {t(
              `${stats.studentsConfiguredSubjects} ने विषय चयन पूर्ण किया`,
              `${stats.studentsConfiguredSubjects} completed subject setup`
            )}
          </p>
        </Card>

        <Card padding="md">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-ink-secondary uppercase tracking-wider">
              {t("सक्रिय शिक्षक", "Active Teachers")}
            </span>
            <Users className="h-5 w-5 text-emerald-ink" />
          </div>
          <p className="mt-2 text-3xl font-bold text-ink">{stats.activeTeachers}</p>
          <p className="mt-1 text-xs text-ink-muted">
            {t(
              `${stats.schoolAdminsCount} व्यवस्थापक · ${teacherCoveragePct}% विषय आवंटित`,
              `${stats.schoolAdminsCount} admins · ${teacherCoveragePct}% subjects mapped`
            )}
          </p>
        </Card>

        <Card padding="md">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-ink-secondary uppercase tracking-wider">
              {t("प्रतीक्षारत प्रश्न", "Open Doubts")}
            </span>
            <HelpCircle className="h-5 w-5 text-amber-ink" />
          </div>
          <p className="mt-2 text-3xl font-bold text-ink">{stats.openDoubtsCount}</p>
          <p className="mt-1 text-xs text-ink-muted">
            {t(
              `${stats.answeredDoubtsCount + stats.resolvedDoubtsCount} का उत्तर दिया गया`,
              `${stats.answeredDoubtsCount + stats.resolvedDoubtsCount} answered or resolved`
            )}
          </p>
        </Card>

        <Card padding="md">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-ink-secondary uppercase tracking-wider">
              {t("आच्छादित विषय", "Covered Subjects")}
            </span>
            <BookOpen className="h-5 w-5 text-indigo-ink" />
          </div>
          <p className="mt-2 text-3xl font-bold text-ink">{stats.coveredSubjectsCount}</p>
          <p className="mt-1 text-xs text-ink-muted">
            {t("कक्षा 9–12 पाठ्यक्रम में", "Across Class 9–12 syllabus")}
          </p>
        </Card>
      </div>

      {/* Class Breakdown & Recent Sync Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>{t("कक्षा एवं संकाय विवरण", "Enrollment by Class & Stream")}</CardTitle>
            <CardDescription>
              {t(
                "वर्तमान शैक्षणिक सत्र में सक्रिय विद्यार्थियों का वितरण",
                "Active student distribution for the current academic year"
              )}
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-5">
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
              {[9, 10, 11, 12].map((cls) => (
                <div
                  key={cls}
                  className="rounded-lg border border-hairline bg-surface-subtle p-3 text-center"
                >
                  <p className="text-xs font-semibold text-ink-secondary">
                    {t(`कक्षा ${cls}`, `Class ${cls}`)}
                  </p>
                  <p className="mt-1 text-2xl font-bold text-ink">
                    {stats.classCounts[String(cls)] ?? 0}
                  </p>
                </div>
              ))}
            </div>

            <div className="pt-2 border-t border-hairline">
              <p className="text-xs font-semibold text-ink-secondary mb-2.5">
                {t("कक्षा 11–12 संकाय चयन", "Class 11–12 Stream Selection")}
              </p>
              <div className="flex flex-wrap gap-2">
                <Badge variant="indigo">
                  {t("विज्ञान", "Science")}: {stats.streamCounts.Science ?? 0}
                </Badge>
                <Badge variant="amber">
                  {t("कला", "Arts")}: {stats.streamCounts.Arts ?? 0}
                </Badge>
                <Badge variant="emerald">
                  {t("वाणिज्य", "Commerce")}: {stats.streamCounts.Commerce ?? 0}
                </Badge>
                <Badge variant="neutral">
                  {t("चयन शेष", "Not Yet Selected")}: {stats.streamCounts.UNSET ?? 0}
                </Badge>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>{t("हाल के सूची अपडेट", "Recent Roster Updates")}</CardTitle>
            <CardDescription>
              {t(
                "विद्यालय विद्यार्थी एवं शिक्षक सूची के अंतिम सिंक रिकॉर्ड",
                "Latest student and staff roster synchronization logs"
              )}
            </CardDescription>
          </CardHeader>
          <CardContent>
            {recentSyncLogs.length === 0 ? (
              <div className="py-8 text-center text-sm text-ink-muted">
                {t("अभी कोई अपडेट रिकॉर्ड नहीं है।", "No roster update records yet.")}
              </div>
            ) : (
              <div className="divide-y divide-hairline">
                {recentSyncLogs.slice(0, 6).map((log) => (
                  <div
                    key={log.id}
                    className="py-3 flex flex-wrap items-center justify-between gap-2 text-sm"
                  >
                    <div className="flex items-center gap-2.5">
                      <CheckCircle2 className="h-4 w-4 text-emerald-ink shrink-0" />
                      <div>
                        <p className="font-semibold text-ink">
                          {log.sync_type === "STUDENTS"
                            ? t("विद्यार्थी सूची अपडेट", "Student Roster Sync")
                            : log.sync_type === "TEACHERS"
                            ? t("शिक्षक सूची अपडेट", "Staff Roster Sync")
                            : t("प्रारंभिक विद्यालय पंजीकरण", "Initial School Setup")}
                        </p>
                        <p className="text-xs text-ink-muted flex items-center gap-1 mt-0.5">
                          <Clock className="h-3 w-3" />
                          {new Date(log.created_at).toLocaleDateString("en-IN", {
                            day: "2-digit",
                            month: "short",
                            year: "numeric",
                          })}
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-1.5 text-xs">
                      <Badge variant="emerald">+{log.added_count}</Badge>
                      <Badge variant="indigo">~{log.updated_count}</Badge>
                      {log.deactivated_count > 0 && (
                        <Badge variant="amber">-{log.deactivated_count}</Badge>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
