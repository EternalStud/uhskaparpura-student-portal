"use client";

import React, { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import {
  CalendarClock,
  ClipboardCheck,
  Clock,
  Download,
  Loader2,
  Monitor,
  Plus,
  Radio,
  Users,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { Tabs } from "@/components/ui/Tabs";
import type { ExamMode, ExamStatus } from "@/types/database";

interface ExamListItem {
  id: string;
  title: string;
  examMode: ExamMode;
  scopeType: string;
  classNum: number;
  stream: string;
  subject: { id: string; nameHi: string; nameEn: string } | null;
  roomPin: string | null;
  durationMins: number;
  startsAt: string | null;
  endsAt: string | null;
  status: ExamStatus;
  questionCount: number;
  creatorName: string;
  stats: {
    joinedCount: number;
    inProgressCount: number;
    submittedCount: number;
    avgAccuracy: number;
  };
  createdAt: string;
}

function formatPin(pin: string): string {
  return pin.length === 6 ? `${pin.slice(0, 3)} ${pin.slice(3)}` : pin;
}

export function ExamsHubClient() {
  const { t, lang } = useLanguage();
  const [filterTab, setFilterTab] = useState<"ALL" | "LIVE" | "DRAFT" | "ENDED">("ALL");
  const [exams, setExams] = useState<ExamListItem[]>([]);
  const [loading, setLoading] = useState(true);

  const loadExams = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/exams", { cache: "no-store" });
      const json = (await res.json()) as { ok?: boolean; exams?: ExamListItem[] };
      if (res.ok && json.ok) {
        setExams(json.exams ?? []);
      }
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void loadExams();
  }, [loadExams]);

  const filtered = exams.filter((e) => {
    if (filterTab === "LIVE") return e.status === "LOBBY" || e.status === "ACTIVE";
    if (filterTab === "DRAFT") return e.status === "DRAFT";
    if (filterTab === "ENDED") return e.status === "ENDED";
    return true;
  });

  const liveCount = exams.filter((e) => e.status === "LOBBY" || e.status === "ACTIVE").length;
  const draftCount = exams.filter((e) => e.status === "DRAFT").length;
  const endedCount = exams.filter((e) => e.status === "ENDED").length;

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 border-b border-hairline pb-5">
        <div className="space-y-1.5">
          <Badge variant="indigo" icon={<ClipboardCheck className="h-3.5 w-3.5" />}>
            {t("द्वि-मोड परीक्षा स्टूडियो", "Dual-Mode Exam Studio")}
          </Badge>
          <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
            {t("कक्षा एवं निर्धारित परीक्षाएँ", "Classroom & Scheduled Exams")}
          </h1>
          <p className="text-sm text-ink-secondary">
            {t(
              "लाइव रूम कोड से तुरंत कक्षा टेस्ट लें या निर्धारित समय की परीक्षा आयोजित करें और Excel अंकतालिका डाउनलोड करें।",
              "Host Live Room Code tests with a projector monitor or schedule timed assessments with instant marksheet export."
            )}
          </p>
        </div>

        <Link href="/teacher/exams/new">
          <Button variant="primary" leftIcon={<Plus className="h-4 w-4" />}>
            {t("नई परीक्षा बनाएँ", "Create New Exam")}
          </Button>
        </Link>
      </div>

      <Tabs
        variant="pills"
        value={filterTab}
        onChange={setFilterTab}
        items={[
          { id: "ALL", label: t("सभी", "All"), count: exams.length },
          { id: "LIVE", label: t("सक्रिय / प्रतीक्षालय", "Live & Active"), count: liveCount },
          { id: "DRAFT", label: t("ड्राफ्ट", "Drafts"), count: draftCount },
          { id: "ENDED", label: t("समाप्त", "Completed"), count: endedCount },
        ]}
      />

      {loading ? (
        <div className="flex min-h-[35vh] items-center justify-center">
          <div className="flex items-center gap-2 text-sm text-ink-secondary">
            <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
            <span>{t("परीक्षाएँ लोड हो रही हैं...", "Loading exams...")}</span>
          </div>
        </div>
      ) : filtered.length === 0 ? (
        <Card variant="subtle" className="py-12 text-center space-y-3">
          <ClipboardCheck className="mx-auto h-9 w-9 text-ink-muted" />
          <p className="text-base font-bold text-ink">
            {t("इस श्रेणी में कोई परीक्षा नहीं है", "No exams in this view yet")}
          </p>
          <p className="text-sm text-ink-secondary max-w-md mx-auto">
            {t(
              "आधिकारिक प्रश्न बैंक और अपने कस्टम प्रश्नों से 2 मिनट में परीक्षा तैयार करें।",
              "Build a Topic, Chapter, or Subject exam from the official question bank or your custom MCQs."
            )}
          </p>
          <Link href="/teacher/exams/new" className="inline-block">
            <Button variant="primary" size="sm" leftIcon={<Plus className="h-4 w-4" />}>
              {t("नई परीक्षा बनाएँ", "Create Exam")}
            </Button>
          </Link>
        </Card>
      ) : (
        <div className="grid grid-cols-1 gap-4">
          {filtered.map((exam) => (
            <Card key={exam.id} padding="sm">
              <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                <div className="space-y-2 min-w-0">
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge
                      variant={
                        exam.status === "ACTIVE"
                          ? "emerald"
                          : exam.status === "LOBBY"
                          ? "amber"
                          : exam.status === "ENDED"
                          ? "neutral"
                          : "outline"
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
                        : exam.status === "ENDED"
                        ? t("समाप्त", "Completed")
                        : t("ड्राफ्ट", "Draft")}
                    </Badge>

                    <Badge
                      variant="indigo"
                      icon={
                        exam.examMode === "LIVE_PIN" ? (
                          <Radio className="h-3 w-3" />
                        ) : (
                          <CalendarClock className="h-3 w-3" />
                        )
                      }
                    >
                      {exam.examMode === "LIVE_PIN"
                        ? t("लाइव रूम कोड", "Live Room Code")
                        : t("निर्धारित समय", "Scheduled")}
                    </Badge>

                    <Badge variant="neutral">
                      {t(`कक्षा ${exam.classNum}`, `Class ${exam.classNum}`)}
                      {exam.subject
                        ? ` · ${t(exam.subject.nameHi, exam.subject.nameEn)}`
                        : ""}
                    </Badge>

                    {exam.roomPin && exam.status !== "ENDED" && (
                      <Badge variant="amber">
                        {t("कोड", "PIN")}: <span className="font-mono">{formatPin(exam.roomPin)}</span>
                      </Badge>
                    )}
                  </div>

                  <h2 className="text-base sm:text-lg font-bold text-ink truncate">
                    {exam.title}
                  </h2>

                  <div className="flex flex-wrap items-center gap-4 text-xs text-ink-secondary">
                    <span className="inline-flex items-center gap-1">
                      <Clock className="h-3.5 w-3.5" />
                      {exam.durationMins} {t("मिनट", "mins")} · {exam.questionCount}{" "}
                      {t("प्रश्न", "questions")}
                    </span>
                    <span className="inline-flex items-center gap-1">
                      <Users className="h-3.5 w-3.5" />
                      {exam.stats.joinedCount} {t("जुड़े", "joined")} · {exam.stats.submittedCount}{" "}
                      {t("जमा", "submitted")}
                      {exam.stats.submittedCount > 0
                        ? ` · ${t("औसत", "Avg")} ${exam.stats.avgAccuracy}%`
                        : ""}
                    </span>
                    {exam.startsAt && (
                      <span>
                        {new Date(exam.startsAt).toLocaleString(
                          lang === "EN" ? "en-IN" : "hi-IN",
                          { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" }
                        )}
                      </span>
                    )}
                  </div>
                </div>

                <div className="flex flex-wrap items-center gap-2 shrink-0">
                  <Link href={`/teacher/exams/${exam.id}/monitor`}>
                    <Button
                      size="sm"
                      variant={
                        exam.status === "ACTIVE" || exam.status === "LOBBY"
                          ? "primary"
                          : "secondary"
                      }
                      leftIcon={<Monitor className="h-4 w-4" />}
                    >
                      {exam.status === "DRAFT"
                        ? t("प्रारंभ / प्रबंधित करें", "Launch / Manage")
                        : exam.status === "ENDED"
                        ? t("विश्लेषण देखें", "View Analytics")
                        : t("लाइव मॉनिटर", "Live Monitor")}
                    </Button>
                  </Link>

                  {exam.stats.joinedCount > 0 && (
                    <a href={`/api/exams/${exam.id}/export`}>
                      <Button
                        size="sm"
                        variant="outline"
                        leftIcon={<Download className="h-4 w-4" />}
                      >
                        .xlsx
                      </Button>
                    </a>
                  )}
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
