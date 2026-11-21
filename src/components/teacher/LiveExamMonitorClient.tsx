"use client";

import React, { useCallback, useEffect, useRef, useState } from "react";
import Link from "next/link";
import { createClient } from "@supabase/supabase-js";
import {
  AlertTriangle,
  ArrowLeft,
  BarChart3,
  CheckCircle2,
  Clock,
  Copy,
  Download,
  Eye,
  Loader2,
  Maximize2,
  Minimize2,
  Play,
  Radio,
  RefreshCw,
  Square,
  Users,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { MathMarkdown } from "@/components/ui/MathMarkdown";
import { Select } from "@/components/ui/Select";
import { Tabs } from "@/components/ui/Tabs";
import { useToast } from "@/components/ui/Toast";
import type { ExamSolutionPolicy, ExamStatus } from "@/types/database";

interface RosterItem {
  studentId: string;
  studentName: string;
  rollNo: number;
  status: "JOINED" | "IN_PROGRESS" | "SUBMITTED";
  answeredCount: number;
  totalQuestions: number;
  score: number;
  accuracy: number;
  tabSwitches: number;
  updatedAt: string;
}

interface QuestionAnalyticItem {
  index: number;
  questionId: string;
  difficultyTier: string;
  examYearTag: string | null;
  qHi: string;
  qEn: string;
  correctOption: string | null;
  marks: number;
  attemptedCount: number;
  correctCount: number;
  accuracyPct: number;
  optionDistribution: Record<"A" | "B" | "C" | "D", number>;
}

interface MonitorPayload {
  ok: boolean;
  exam: {
    id: string;
    title: string;
    examMode: "LIVE_PIN" | "SCHEDULED";
    scopeType: string;
    classNum: number;
    stream: string;
    subject: {
      id: string;
      nameHi: string;
      nameEn: string;
      accentColor: string;
    } | null;
    roomPin: string | null;
    durationMins: number;
    startsAt: string | null;
    endsAt: string | null;
    endedAt: string | null;
    showSolutionsPolicy: ExamSolutionPolicy;
    status: ExamStatus;
    questionCount: number;
    maxMarks: number;
    schoolUdise: string;
    schoolName: string | null;
  };
  summary: {
    joinedCount: number;
    waitingCount: number;
    inProgressCount: number;
    submittedCount: number;
    avgScore: number;
    avgAccuracy: number;
    topScore: number;
    maxMarks: number;
    focusAlertsCount: number;
  };
  roster: RosterItem[];
  questionAnalytics: QuestionAnalyticItem[];
  realtime: {
    token: string;
    expiresAt: string;
    enabled: boolean;
  };
}

function formatPinSpaced(pin: string): string {
  return pin.length === 6 ? `${pin.slice(0, 3)} ${pin.slice(3)}` : pin;
}

export function LiveExamMonitorClient({ examId }: { examId: string }) {
  const { t, lang } = useLanguage();
  const toast = useToast();

  const [data, setData] = useState<MonitorPayload | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<"roster" | "analytics">("roster");
  const [projectorMode, setProjectorMode] = useState(false);
  const [liveConnected, setLiveConnected] = useState(false);
  const [mutating, setMutating] = useState(false);
  const [confirmEndOpen, setConfirmEndOpen] = useState(false);

  const realtimeTokenRef = useRef<string | null>(null);

  const fetchMonitor = useCallback(async (silent = false) => {
    if (!silent) setLoading(true);
    try {
      const res = await fetch(`/api/exams/${examId}/monitor`, { cache: "no-store" });
      const json = (await res.json()) as MonitorPayload & { error?: string };
      if (!res.ok || !json.ok) {
        throw new Error(json.error || "Unable to load exam monitor.");
      }
      setData(json);
      setError(null);
    } catch (err) {
      if (!silent) {
        setError(
          err instanceof Error
            ? err.message
            : t("परीक्षा विवरण लोड नहीं हो सका।", "Could not load exam monitor.")
        );
      }
    } finally {
      if (!silent) setLoading(false);
    }
  }, [examId, t]);

  useEffect(() => {
    fetchMonitor(false);
  }, [fetchMonitor]);

  // Scoped WebSocket live updates on live_exam_roster + resilient periodic refresh
  const realtimeToken = data?.realtime.enabled ? data.realtime.token : null;
  const examStatus = data?.exam.status;

  useEffect(() => {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

    if (!realtimeToken || !supabaseUrl || !supabaseAnonKey || examStatus === "ENDED") {
      setLiveConnected(false);
      return;
    }

    if (realtimeTokenRef.current === realtimeToken) {
      return;
    }
    realtimeTokenRef.current = realtimeToken;

    const client = createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
        detectSessionInUrl: false,
      },
      global: {
        headers: {
          Authorization: `Bearer ${realtimeToken}`,
        },
      },
    });

    client.realtime.setAuth(realtimeToken);

    const channel = client
      .channel(`live-exam-roster-${examId}`)
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "live_exam_roster",
          filter: `exam_id=eq.${examId}`,
        },
        (payload) => {
          const row = payload.new as {
            student_id?: string;
            student_name?: string;
            roll_no?: number;
            status?: "JOINED" | "IN_PROGRESS" | "SUBMITTED";
            answered_count?: number;
            total_questions?: number;
            score?: number;
            accuracy?: number;
            tab_switches?: number;
            updated_at?: string;
          } | null;

          if (!row?.student_id) return;

          setData((prev) => {
            if (!prev) return prev;
            const mapped: RosterItem = {
              studentId: row.student_id!,
              studentName: row.student_name ?? "Student",
              rollNo: row.roll_no ?? 0,
              status: row.status ?? "JOINED",
              answeredCount: row.answered_count ?? 0,
              totalQuestions: row.total_questions ?? prev.exam.questionCount,
              score: row.score ?? 0,
              accuracy: Number(row.accuracy ?? 0),
              tabSwitches: row.tab_switches ?? 0,
              updatedAt: row.updated_at ?? new Date().toISOString(),
            };

            const existingIdx = prev.roster.findIndex((r) => r.studentId === mapped.studentId);
            const nextRoster =
              existingIdx >= 0
                ? prev.roster.map((r, i) => (i === existingIdx ? mapped : r))
                : [...prev.roster, mapped];

            nextRoster.sort((a, b) => {
              if (b.score !== a.score) return b.score - a.score;
              if (b.answeredCount !== a.answeredCount) return b.answeredCount - a.answeredCount;
              return a.rollNo - b.rollNo;
            });

            const submitted = nextRoster.filter((r) => r.status === "SUBMITTED");
            const avgScore =
              submitted.length > 0
                ? Math.round((submitted.reduce((s, r) => s + r.score, 0) / submitted.length) * 10) /
                  10
                : 0;
            const avgAccuracy =
              submitted.length > 0
                ? Math.round(
                    (submitted.reduce((s, r) => s + r.accuracy, 0) / submitted.length) * 10
                  ) / 10
                : 0;

            return {
              ...prev,
              roster: nextRoster,
              summary: {
                ...prev.summary,
                joinedCount: nextRoster.length,
                waitingCount: nextRoster.filter((r) => r.status === "JOINED").length,
                inProgressCount: nextRoster.filter((r) => r.status === "IN_PROGRESS").length,
                submittedCount: submitted.length,
                avgScore,
                avgAccuracy,
                topScore: submitted.length > 0 ? Math.max(...submitted.map((r) => r.score)) : 0,
                focusAlertsCount: nextRoster.filter((r) => r.tabSwitches > 0).length,
              },
            };
          });
        }
      )
      .subscribe((status) => {
        setLiveConnected(status === "SUBSCRIBED");
      });

    return () => {
      realtimeTokenRef.current = null;
      setLiveConnected(false);
      void client.removeChannel(channel);
    };
  }, [examId, realtimeToken, examStatus]);

  // Resilient rural-network sync fallback (refreshes analytics + roster smoothly)
  useEffect(() => {
    if (examStatus === "ENDED" || !examStatus) return;
    const intervalMs = liveConnected ? 15000 : 6000;
    const timer = setInterval(() => {
      void fetchMonitor(true);
    }, intervalMs);
    return () => clearInterval(timer);
  }, [examStatus, liveConnected, fetchMonitor]);

  const runExamAction = async (
    action: "OPEN_LOBBY" | "START_EXAM" | "END_EXAM",
    extra?: Record<string, unknown>
  ) => {
    setMutating(true);
    try {
      const res = await fetch(`/api/exams/${examId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({ action, ...extra }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string };
      if (!res.ok || !json.ok) {
        throw new Error(json.error || "Action failed.");
      }
      setConfirmEndOpen(false);
      toast.success(
        action === "OPEN_LOBBY"
          ? t("कक्षा रूम कोड तैयार है", "Classroom Room Code generated")
          : action === "START_EXAM"
          ? t("परीक्षा शुरू हो गई है", "Exam is now live")
          : t("परीक्षा समाप्त और परिणाम तैयार", "Exam ended & all attempts graded")
      );
      await fetchMonitor(false);
    } catch (err) {
      toast.error(
        t("कार्रवाई पूरी नहीं हो सकी", "Could not update exam"),
        err instanceof Error ? err.message : undefined
      );
    } finally {
      setMutating(false);
    }
  };

  const handlePolicyChange = async (nextPolicy: ExamSolutionPolicy) => {
    setMutating(true);
    try {
      const res = await fetch(`/api/exams/${examId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          action: "UPDATE_POLICY",
          showSolutionsPolicy: nextPolicy,
        }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string };
      if (!res.ok || !json.ok) throw new Error(json.error || "Update failed");
      toast.success(t("उत्तर-कुंजी नीति अद्यतन हुई", "Solution visibility updated"));
      await fetchMonitor(true);
    } catch (err) {
      toast.error(
        t("नीति बदली नहीं जा सकी", "Could not update solution policy"),
        err instanceof Error ? err.message : undefined
      );
    } finally {
      setMutating(false);
    }
  };

  const copyPin = async (pin: string) => {
    try {
      await navigator.clipboard.writeText(pin);
      toast.success(t("रूम कोड कॉपी हो गया", "Room Code copied"));
    } catch {
      toast.info(pin);
    }
  };

  if (loading && !data) {
    return (
      <div className="flex min-h-[45vh] items-center justify-center">
        <div className="flex items-center gap-2.5 text-sm text-ink-secondary">
          <Loader2 className="h-5 w-5 animate-spin text-indigo-ink" />
          <span>{t("परीक्षा मॉनिटर लोड हो रहा है...", "Loading Exam Monitor...")}</span>
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <div className="space-y-4">
        <Link href="/teacher/exams">
          <Button variant="ghost" size="sm" leftIcon={<ArrowLeft className="h-4 w-4" />}>
            {t("परीक्षा सूची पर लौटें", "Back to Exams")}
          </Button>
        </Link>
        <Card variant="warm">
          <p className="text-sm font-medium text-amber-ink">
            {error ?? t("परीक्षा नहीं मिली।", "Exam not found.")}
          </p>
        </Card>
      </div>
    );
  }

  const { exam, summary, roster, questionAnalytics } = data;

  return (
    <div
      className={
        projectorMode
          ? "fixed inset-0 z-50 overflow-y-auto bg-canvas p-6 sm:p-10 space-y-6"
          : "space-y-6"
      }
    >
      {/* Top Action Bar */}
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-3 min-w-0">
          {!projectorMode && (
            <Link href="/teacher/exams">
              <Button variant="ghost" size="sm" leftIcon={<ArrowLeft className="h-4 w-4" />}>
                {t("सभी परीक्षाएँ", "Exams")}
              </Button>
            </Link>
          )}
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
                ? t("परीक्षा चालू है", "Live Now")
                : exam.status === "LOBBY"
                ? t("प्रतीक्षालय खुला", "Lobby Open")
                : exam.status === "ENDED"
                ? t("समाप्त", "Completed")
                : t("ड्राफ्ट", "Draft")}
            </Badge>
            <Badge variant="indigo">
              {t(`कक्षा ${exam.classNum}`, `Class ${exam.classNum}`)}
              {exam.subject ? ` · ${t(exam.subject.nameHi, exam.subject.nameEn)}` : ""}
            </Badge>
            {exam.status !== "ENDED" && (
              <span className="inline-flex items-center gap-1.5 text-xs font-medium text-ink-secondary">
                <span
                  className={`h-2 w-2 rounded-full ${
                    liveConnected ? "bg-emerald-mastery" : "bg-amber-warm"
                  }`}
                />
                {liveConnected
                  ? t("लाइव जुड़ा हुआ", "Live feed connected")
                  : t("स्वतः सिंक सक्रिय", "Auto-sync active")}
              </span>
            )}
          </div>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <Button
            variant="secondary"
            size="sm"
            onClick={() => void fetchMonitor(false)}
            leftIcon={<RefreshCw className="h-4 w-4" />}
          >
            {t("रिफ्रेश", "Refresh")}
          </Button>
          <Button
            variant="secondary"
            size="sm"
            onClick={() => setProjectorMode((p) => !p)}
            leftIcon={
              projectorMode ? (
                <Minimize2 className="h-4 w-4" />
              ) : (
                <Maximize2 className="h-4 w-4" />
              )
            }
          >
            {projectorMode
              ? t("प्रोजेक्टर बंद करें", "Exit Projector")
              : t("प्रोजेक्टर व्यू", "Projector View")}
          </Button>
          <a href={`/api/exams/${exam.id}/export`}>
            <Button
              variant="emerald"
              size="sm"
              leftIcon={<Download className="h-4 w-4" />}
            >
              {t("अंकतालिका (.xlsx)", "Download Marksheet (.xlsx)")}
            </Button>
          </a>
        </div>
      </div>

      {/* Hero Classroom Banner + Giant Room PIN for Projector */}
      <Card variant={exam.status === "LOBBY" || exam.status === "ACTIVE" ? "indigo" : "default"}>
        <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-6">
          <div className="space-y-2 min-w-0">
            <p className="text-xs font-semibold uppercase tracking-wider text-indigo-ink">
              {exam.examMode === "LIVE_PIN"
                ? t("लाइव कक्षा परीक्षा (रूम कोड)", "Live Classroom Exam")
                : t("निर्धारित समय परीक्षा", "Scheduled Exam")}
              {exam.schoolName ? ` · ${exam.schoolName}` : ""}
            </p>
            <h1 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
              {exam.title}
            </h1>
            <div className="flex flex-wrap items-center gap-4 text-sm text-ink-secondary">
              <span className="inline-flex items-center gap-1.5">
                <Clock className="h-4 w-4 text-indigo-ink" />
                {exam.durationMins} {t("मिनट", "minutes")}
              </span>
              <span>
                {exam.questionCount} {t("प्रश्न", "questions")} · {exam.maxMarks}{" "}
                {t("अंक", "marks")}
              </span>
            </div>

            {/* Teacher Lifecycle Controls */}
            <div className="pt-2 flex flex-wrap items-center gap-2.5">
              {exam.status === "DRAFT" && exam.examMode === "LIVE_PIN" && (
                <Button
                  variant="primary"
                  loading={mutating}
                  onClick={() => void runExamAction("OPEN_LOBBY")}
                  leftIcon={<Radio className="h-4 w-4" />}
                >
                  {t("रूम कोड बनाएँ और प्रतीक्षालय खोलें", "Open Lobby & Generate Room Code")}
                </Button>
              )}

              {exam.status === "DRAFT" && exam.examMode === "SCHEDULED" && (
                <Button
                  variant="primary"
                  loading={mutating}
                  onClick={() => void runExamAction("START_EXAM")}
                  leftIcon={<Play className="h-4 w-4" />}
                >
                  {t("निर्धारित परीक्षा सक्रिय करें", "Activate Scheduled Exam")}
                </Button>
              )}

              {exam.status === "LOBBY" && (
                <Button
                  variant="emerald"
                  size="lg"
                  loading={mutating}
                  onClick={() => void runExamAction("START_EXAM")}
                  leftIcon={<Play className="h-5 w-5" />}
                >
                  {t("सभी के लिए परीक्षा शुरू करें", "Start Exam for Classroom")}
                </Button>
              )}

              {(exam.status === "LOBBY" || exam.status === "ACTIVE") && (
                <>
                  {!confirmEndOpen ? (
                    <Button
                      variant="danger"
                      size={exam.status === "ACTIVE" ? "md" : "sm"}
                      onClick={() => setConfirmEndOpen(true)}
                      leftIcon={<Square className="h-4 w-4" />}
                    >
                      {t("परीक्षा समाप्त करें", "End Exam")}
                    </Button>
                  ) : (
                    <div className="inline-flex items-center gap-2 rounded-lg border border-crimson-alert/35 bg-surface px-3 py-1.5">
                      <span className="text-xs font-semibold text-crimson-ink">
                        {t("निश्चित रूप से समाप्त करें?", "Confirm end & auto-grade?")}
                      </span>
                      <Button
                        size="sm"
                        variant="danger"
                        loading={mutating}
                        onClick={() => void runExamAction("END_EXAM")}
                      >
                        {t("हाँ, समाप्त करें", "Yes, End Now")}
                      </Button>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => setConfirmEndOpen(false)}
                      >
                        {t("रद्द करें", "Cancel")}
                      </Button>
                    </div>
                  )}
                </>
              )}
            </div>
          </div>

          {/* Big Crisp Projector Room PIN Card */}
          {exam.examMode === "LIVE_PIN" && exam.roomPin && exam.status !== "ENDED" && (
            <div className="shrink-0 rounded-sheet border-2 border-indigo-academic/30 bg-surface px-6 py-5 text-center shadow-paper min-w-[260px]">
              <p className="text-xs font-bold uppercase tracking-widest text-ink-muted">
                {t("कक्षा रूम कोड", "CLASSROOM ROOM CODE")}
              </p>
              <p
                className={`mt-2 font-mono font-extrabold tracking-[0.22em] text-indigo-academic tabular-nums ${
                  projectorMode ? "text-5xl sm:text-6xl" : "text-4xl sm:text-5xl"
                }`}
              >
                {formatPinSpaced(exam.roomPin)}
              </p>
              <div className="mt-3 flex items-center justify-center gap-2">
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => void copyPin(exam.roomPin!)}
                  leftIcon={<Copy className="h-3.5 w-3.5" />}
                >
                  {t("कोड कॉपी करें", "Copy Code")}
                </Button>
              </div>
              <p className="mt-2 text-xs text-ink-secondary">
                {t(
                  "विद्यार्थी अपने 'परीक्षा' टैब में यह 6 अंकों का कोड डालें",
                  "Students enter this 6-digit code in their Exams tab"
                )}
              </p>
            </div>
          )}
        </div>
      </Card>

      {/* Live Summary KPIs */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <Card padding="sm">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-ink-muted">
              {t("जुड़े विद्यार्थी", "Students Joined")}
            </span>
            <Users className="h-4 w-4 text-indigo-ink" />
          </div>
          <p className="mt-1.5 text-2xl sm:text-3xl font-bold text-ink">{summary.joinedCount}</p>
          <p className="text-xs text-ink-secondary">
            {t(
              `${summary.inProgressCount} लिख रहे हैं · ${summary.waitingCount} प्रतीक्षा में`,
              `${summary.inProgressCount} writing · ${summary.waitingCount} waiting`
            )}
          </p>
        </Card>

        <Card padding="sm">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-ink-muted">
              {t("जमा किए गए", "Submitted")}
            </span>
            <CheckCircle2 className="h-4 w-4 text-emerald-ink" />
          </div>
          <p className="mt-1.5 text-2xl sm:text-3xl font-bold text-emerald-ink">
            {summary.submittedCount}
          </p>
          <p className="text-xs text-ink-secondary">
            {summary.joinedCount > 0
              ? `${Math.round((summary.submittedCount / summary.joinedCount) * 100)}% ${t(
                  "पूर्ण",
                  "completed"
                )}`
              : t("प्रतीक्षा में", "Waiting for students")}
          </p>
        </Card>

        <Card padding="sm">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-ink-muted">
              {t("औसत अंक / सटीकता", "Average Score")}
            </span>
            <BarChart3 className="h-4 w-4 text-indigo-ink" />
          </div>
          <p className="mt-1.5 text-2xl sm:text-3xl font-bold text-ink">
            {summary.avgScore}
            <span className="text-sm font-semibold text-ink-muted">/{summary.maxMarks}</span>
          </p>
          <p className="text-xs text-ink-secondary">
            {summary.avgAccuracy}% {t("औसत सटीकता", "avg accuracy")} · {t("सर्वोच्च", "Top")}:{" "}
            {summary.topScore}
          </p>
        </Card>

        <Card padding="sm">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-ink-muted">
              {t("ध्यान संकेतक", "Focus Notices")}
            </span>
            <Eye className="h-4 w-4 text-amber-ink" />
          </div>
          <p className="mt-1.5 text-2xl sm:text-3xl font-bold text-ink">
            {summary.focusAlertsCount}
          </p>
          <p className="text-xs text-ink-secondary">
            {t("टैब बदलने वाले विद्यार्थी (मौन)", "Students with tab switches")}
          </p>
        </Card>
      </div>

      {/* Solution Visibility Policy Control (non-projector view) */}
      {!projectorMode && (
        <Card padding="sm" variant="subtle">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
            <div>
              <p className="text-sm font-bold text-ink">
                {t("विद्यार्थियों के लिए उत्तर व व्याख्या नीति", "Student Solutions Policy")}
              </p>
              <p className="text-xs text-ink-secondary">
                {t(
                  "तय करें कि जमा करने के बाद विद्यार्थी सही उत्तर कब देख सकें",
                  "Control when students can inspect correct answers & explanations"
                )}
              </p>
            </div>
            <div className="w-full sm:w-72">
              <Select
                value={exam.showSolutionsPolicy}
                disabled={mutating}
                onChange={(e) =>
                  void handlePolicyChange(e.target.value as ExamSolutionPolicy)
                }
                options={[
                  {
                    value: "AFTER_EXAM_ENDS",
                    label: t("परीक्षा समाप्त होने के बाद", "After Exam Ends"),
                  },
                  {
                    value: "IMMEDIATE_ON_SUBMIT",
                    label: t("जमा करते ही तुरंत", "Immediately on Submit"),
                  },
                  {
                    value: "TEACHER_ONLY",
                    label: t("केवल शिक्षक देखें", "Teacher Only (Hidden)"),
                  },
                ]}
              />
            </div>
          </div>
        </Card>
      )}

      {/* Tabs: Live Student Roster vs Question-Wise Accuracy Analytics */}
      <Tabs
        value={activeTab}
        onChange={setActiveTab}
        items={[
          {
            id: "roster",
            label: t("लाइव विद्यार्थी प्रगति", "Live Student Progress"),
            icon: <Users className="h-4 w-4" />,
            count: roster.length,
          },
          {
            id: "analytics",
            label: t("प्रश्न-वार विश्लेषण", "Question Analytics"),
            icon: <BarChart3 className="h-4 w-4" />,
            count: questionAnalytics.length,
          },
        ]}
      />

      {activeTab === "roster" ? (
        <Card padding="none" className="overflow-hidden">
          {roster.length === 0 ? (
            <div className="p-10 text-center space-y-2">
              <Users className="mx-auto h-8 w-8 text-ink-muted" />
              <p className="text-base font-bold text-ink">
                {t("विद्यार्थियों के जुड़ने की प्रतीक्षा है", "Waiting for students to join")}
              </p>
              <p className="text-sm text-ink-secondary max-w-md mx-auto">
                {exam.roomPin
                  ? t(
                      `कक्षा में रूम कोड ${formatPinSpaced(exam.roomPin)} दिखाएँ। जैसे ही विद्यार्थी जुड़ेंगे, उनका नाम और प्रगति यहाँ तुरंत दिखेगी।`,
                      `Display Room Code ${formatPinSpaced(exam.roomPin)} in class. Student progress updates automatically as they join.`
                    )
                  : t(
                      "जैसे ही विद्यार्थी परीक्षा शुरू करेंगे, उनकी प्रगति यहाँ दिखाई देगी।",
                      "Student progress will appear live here as soon as students begin."
                    )}
              </p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="border-b border-hairline bg-surface-subtle text-xs font-bold uppercase tracking-wide text-ink-secondary">
                    <th className="px-4 py-3">{t("रोल नं.", "Roll")}</th>
                    <th className="px-4 py-3">{t("विद्यार्थी का नाम", "Student Name")}</th>
                    <th className="px-4 py-3">{t("स्थिति", "Status")}</th>
                    <th className="px-4 py-3">{t("प्रगति", "Progress")}</th>
                    <th className="px-4 py-3">{t("अंक", "Score")}</th>
                    <th className="px-4 py-3">{t("ध्यान", "Focus")}</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-hairline text-sm">
                  {roster.map((student) => {
                    const pct =
                      student.totalQuestions > 0
                        ? Math.round((student.answeredCount / student.totalQuestions) * 100)
                        : 0;
                    return (
                      <tr
                        key={student.studentId}
                        className="hover:bg-surface-subtle/50 transition-colors"
                      >
                        <td className="px-4 py-3 font-mono font-bold text-ink">
                          {student.rollNo}
                        </td>
                        <td className="px-4 py-3 font-semibold text-ink">
                          {student.studentName}
                        </td>
                        <td className="px-4 py-3">
                          <Badge
                            variant={
                              student.status === "SUBMITTED"
                                ? "emerald"
                                : student.status === "IN_PROGRESS"
                                ? "indigo"
                                : "amber"
                            }
                          >
                            {student.status === "SUBMITTED"
                              ? t("जमा", "Submitted")
                              : student.status === "IN_PROGRESS"
                              ? t("लिख रहे हैं", "Writing")
                              : t("प्रतीक्षालय", "Joined")}
                          </Badge>
                        </td>
                        <td className="px-4 py-3 min-w-[160px]">
                          <div className="flex items-center gap-2.5">
                            <div className="h-2 flex-1 overflow-hidden rounded-full bg-surface-subtle border border-hairline">
                              <div
                                className={`h-full transition-all duration-300 ${
                                  student.status === "SUBMITTED"
                                    ? "bg-emerald-mastery"
                                    : "bg-indigo-academic"
                                }`}
                                style={{ width: `${pct}%` }}
                              />
                            </div>
                            <span className="text-xs font-semibold text-ink-secondary tabular-nums">
                              {student.answeredCount}/{student.totalQuestions}
                            </span>
                          </div>
                        </td>
                        <td className="px-4 py-3 font-bold tabular-nums text-ink">
                          {student.status === "SUBMITTED" ? (
                            <span>
                              {student.score}/{summary.maxMarks}{" "}
                              <span className="text-xs font-medium text-ink-secondary">
                                ({student.accuracy.toFixed(0)}%)
                              </span>
                            </span>
                          ) : (
                            <span className="text-ink-muted">—</span>
                          )}
                        </td>
                        <td className="px-4 py-3">
                          {student.tabSwitches > 0 ? (
                            <span
                              title={t(
                                `विद्यार्थी ने ${student.tabSwitches} बार स्क्रीन/टैब बदला`,
                                `Student switched tabs ${student.tabSwitches} time(s)`
                              )}
                              className="inline-flex items-center gap-1 rounded-full bg-amber-soft px-2.5 py-0.5 text-xs font-semibold text-amber-ink"
                            >
                              <AlertTriangle className="h-3 w-3" />
                              {student.tabSwitches}
                            </span>
                          ) : (
                            <span className="text-xs text-emerald-ink font-medium">
                              {t("स्थिर", "Focused")}
                            </span>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
        </Card>
      ) : (
        <div className="space-y-4">
          {questionAnalytics.map((qa) => {
            const barColor =
              qa.accuracyPct >= 70
                ? "bg-emerald-mastery"
                : qa.accuracyPct >= 40
                ? "bg-amber-warm"
                : "bg-crimson-alert";

            return (
              <Card key={qa.questionId} padding="sm">
                <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                  <div className="space-y-2 flex-1 min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <Badge variant="indigo">Q{qa.index}</Badge>
                      <Badge variant="neutral">{qa.difficultyTier}</Badge>
                      {qa.examYearTag && <Badge variant="amber">{qa.examYearTag}</Badge>}
                      {qa.correctOption && (
                        <Badge variant="emerald">
                          {t("सही उत्तर", "Correct")}: {qa.correctOption}
                        </Badge>
                      )}
                    </div>
                    <MathMarkdown
                      content={lang === "EN" ? qa.qEn || qa.qHi : qa.qHi || qa.qEn}
                      className="text-sm font-medium text-ink"
                    />
                  </div>

                  <div className="sm:w-56 shrink-0 space-y-2">
                    <div className="flex items-center justify-between text-xs font-semibold">
                      <span className="text-ink-secondary">
                        {t("सही उत्तर दर", "Class Accuracy")}
                      </span>
                      <span className="text-ink tabular-nums">
                        {qa.accuracyPct}% ({qa.correctCount}/{qa.attemptedCount})
                      </span>
                    </div>
                    <div className="h-2.5 w-full overflow-hidden rounded-full bg-surface-subtle border border-hairline">
                      <div
                        className={`h-full ${barColor}`}
                        style={{ width: `${qa.accuracyPct}%` }}
                      />
                    </div>
                    <div className="grid grid-cols-4 gap-1.5 pt-1 text-center text-[11px]">
                      {(["A", "B", "C", "D"] as const).map((opt) => (
                        <div
                          key={opt}
                          className={`rounded-md border px-1.5 py-1 ${
                            qa.correctOption === opt
                              ? "border-emerald-mastery/40 bg-emerald-soft text-emerald-ink font-bold"
                              : "border-hairline bg-surface-subtle text-ink-secondary"
                          }`}
                        >
                          {opt}: {qa.optionDistribution[opt]}
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
