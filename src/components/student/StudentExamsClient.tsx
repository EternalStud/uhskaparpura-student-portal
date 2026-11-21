"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  ArrowRight,
  CalendarClock,
  CheckCircle2,
  ClipboardCheck,
  Clock,
  KeyRound,
  Play,
  Radio,
} from "lucide-react";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Button, Card, Input, useToast } from "@/components/ui";

interface StudentExamListItem {
  id: string;
  title: string;
  examMode: "LIVE_PIN" | "SCHEDULED";
  scopeType: "TOPIC" | "CHAPTER" | "SUBJECT";
  classNum: number;
  subject: { id: string; nameHi: string; nameEn: string; accentColor: string } | null;
  durationMins: number;
  startsAt: string | null;
  endsAt: string | null;
  status: "LOBBY" | "ACTIVE" | "ENDED";
  solutionsUnlocked: boolean;
  questionCount: number;
  myAttempt: {
    id: string;
    status: "JOINED" | "IN_PROGRESS" | "SUBMITTED";
    answeredCount: number;
    score: number;
    totalQuestions: number;
    accuracy: number;
    submittedAt: string | null;
  } | null;
}

function formatIstWindow(iso: string | null): string {
  if (!iso) return "";
  try {
    return new Intl.DateTimeFormat("en-IN", {
      timeZone: "Asia/Kolkata",
      day: "2-digit",
      month: "short",
      hour: "2-digit",
      minute: "2-digit",
      hour12: true,
    }).format(new Date(iso));
  } catch {
    return iso;
  }
}

export function StudentExamsClient() {
  const router = useRouter();
  const { t } = useLanguage();
  const toast = useToast();

  const [loading, setLoading] = useState(true);
  const [exams, setExams] = useState<StudentExamListItem[]>([]);
  const [roomPin, setRoomPin] = useState("");
  const [joining, setJoining] = useState(false);

  useEffect(() => {
    let active = true;
    fetch("/api/exams", { cache: "no-store" })
      .then((r) => r.json())
      .then((json: { exams?: StudentExamListItem[] }) => {
        if (active) setExams(json.exams ?? []);
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
  }, []);

  const handleJoinByPin = async (e: React.FormEvent) => {
    e.preventDefault();
    const cleaned = roomPin.replace(/\D/g, "");
    if (cleaned.length !== 6) {
      toast.error(
        t("कृपया शिक्षक द्वारा दिया गया 6-अंकीय रूम कोड दर्ज करें।", "Please enter the exact 6-digit Classroom Room Code.")
      );
      return;
    }

    setJoining(true);
    try {
      const res = await fetch("/api/exams/join", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ roomPin: cleaned }),
      });
      const json = (await res.json()) as {
        ok?: boolean;
        exam?: { id: string };
        error?: string;
        errorHi?: string;
      };
      if (!res.ok || !json.ok || !json.exam?.id) {
        toast.error(
          t(json.errorHi ?? "रूम कोड नहीं मिला।", json.error ?? "Room code not found.")
        );
        return;
      }
      router.push(`/student/exams/${json.exam.id}`);
    } finally {
      setJoining(false);
    }
  };

  const activeAndUpcoming = exams.filter(
    (ex) => ex.status !== "ENDED" && ex.myAttempt?.status !== "SUBMITTED"
  );
  const completedExams = exams.filter(
    (ex) => ex.myAttempt?.status === "SUBMITTED" || ex.status === "ENDED"
  );

  return (
    <div className="max-w-5xl mx-auto space-y-6 pb-12">
      <div className="space-y-1">
        <Badge variant="indigo" icon={<ClipboardCheck className="h-3.5 w-3.5" />}>
          {t("विद्यालय परीक्षा केंद्र", "School Exam Center")}
        </Badge>
        <h1 className="text-2xl sm:text-3xl font-bold text-ink">
          <BiText hi="लाइव कक्षा टेस्ट व निर्धारित परीक्षाएँ" en="Live Classroom Tests & Scheduled Exams" />
        </h1>
      </div>

      {/* 6-Digit Room Code Join Card */}
      <Card variant="indigo" padding="lg" className="space-y-4">
        <div className="flex items-start gap-3">
          <span className="inline-flex h-11 w-11 items-center justify-center rounded-paper bg-indigo-academic text-white shrink-0">
            <Radio className="h-5 w-5" />
          </span>
          <div>
            <h2 className="text-lg font-bold text-ink">
              <BiText
                hi="लाइव कक्षा परीक्षा में जुड़ें (6-अंकीय रूम कोड)"
                en="Join a Live Classroom Exam (6-Digit Room Code)"
              />
            </h2>
            <p className="text-xs sm:text-sm text-ink-secondary mt-0.5">
              {t(
                "आपके शिक्षक द्वारा ब्लैकबोर्ड या प्रोजेक्टर पर लिखा 6 अंकों का रूम कोड नीचे दर्ज करें।",
                "Enter the 6-digit room code displayed by your teacher on the classroom board or projector."
              )}
            </p>
          </div>
        </div>

        <form onSubmit={handleJoinByPin} className="flex flex-col sm:flex-row gap-3 max-w-lg">
          <div className="flex-1">
            <Input
              aria-label={t("6-अंकीय रूम कोड", "6-Digit Room Code")}
              inputMode="numeric"
              maxLength={6}
              placeholder="000000"
              value={roomPin}
              onChange={(e) => setRoomPin(e.target.value.replace(/\D/g, "").slice(0, 6))}
              leftIcon={<KeyRound className="h-4 w-4 text-indigo-ink" />}
              className="font-mono text-lg tracking-[0.25em] font-bold"
            />
          </div>
          <Button
            type="submit"
            variant="primary"
            size="lg"
            loading={joining}
            rightIcon={<ArrowRight className="h-4 w-4" />}
          >
            {t("परीक्षा में जुड़ें", "Join Exam")}
          </Button>
        </form>
      </Card>

      {/* Active & Scheduled Exams */}
      <section className="space-y-3">
        <h2 className="text-lg font-bold text-ink flex items-center gap-2">
          <CalendarClock className="h-5 w-5 text-indigo-ink" />
          {t("सक्रिय एवं निर्धारित परीक्षाएँ", "Active & Scheduled Exams")}
        </h2>

        {loading ? (
          <div className="space-y-3 animate-pulse">
            <div className="h-28 rounded-paper bg-surface-subtle" />
          </div>
        ) : activeAndUpcoming.length === 0 ? (
          <Card className="text-center py-8 text-sm text-ink-secondary">
            {t(
              "इस समय कोई निर्धारित परीक्षा सक्रिय नहीं है। लाइव परीक्षा के लिए ऊपर 6-अंकीय कोड दर्ज करें।",
              "No scheduled exams are open right now. Use the 6-digit Room Code above for live classroom tests."
            )}
          </Card>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {activeAndUpcoming.map((ex) => (
              <Card key={ex.id} variant="interactive" className="flex flex-col justify-between gap-4">
                <div className="space-y-2">
                  <div className="flex flex-wrap items-center gap-1.5">
                    <Badge variant={ex.examMode === "LIVE_PIN" ? "amber" : "indigo"}>
                      {ex.examMode === "LIVE_PIN"
                        ? t("लाइव कक्षा टेस्ट", "Live Classroom")
                        : t("निर्धारित परीक्षा", "Scheduled Exam")}
                    </Badge>
                    {ex.subject && (
                      <Badge variant="neutral">
                        <BiText hi={ex.subject.nameHi} en={ex.subject.nameEn} inline />
                      </Badge>
                    )}
                    <Badge variant="emerald">
                      {ex.status === "LOBBY" ? t("लॉबी खुली", "Lobby Open") : t("चालू", "Active")}
                    </Badge>
                  </div>

                  <h3 className="text-base font-bold text-ink leading-snug">{ex.title}</h3>

                  <div className="flex flex-wrap items-center gap-3 text-xs text-ink-secondary">
                    <span className="inline-flex items-center gap-1">
                      <Clock className="h-3.5 w-3.5" />
                      {t(`${ex.durationMins} मिनट`, `${ex.durationMins} mins`)}
                    </span>
                    <span>{t(`${ex.questionCount} प्रश्न`, `${ex.questionCount} Questions`)}</span>
                  </div>

                  {ex.startsAt && ex.endsAt && (
                    <p className="text-xs text-ink-muted">
                      {formatIstWindow(ex.startsAt)} — {formatIstWindow(ex.endsAt)} IST
                    </p>
                  )}
                </div>

                <Link href={`/student/exams/${ex.id}`}>
                  <Button variant="primary" fullWidth leftIcon={<Play className="h-4 w-4" />}>
                    {ex.myAttempt?.status === "IN_PROGRESS"
                      ? t("परीक्षा जारी रखें", "Resume Exam")
                      : t("परीक्षा खोलें", "Enter Exam")}
                  </Button>
                </Link>
              </Card>
            ))}
          </div>
        )}
      </section>

      {/* Past & Submitted Exams */}
      {completedExams.length > 0 && (
        <section className="space-y-3">
          <h2 className="text-lg font-bold text-ink flex items-center gap-2">
            <CheckCircle2 className="h-5 w-5 text-emerald-ink" />
            {t("पूर्ण परीक्षाएँ व परिणाम", "Completed Exams & Results")}
          </h2>

          <div className="space-y-3">
            {completedExams.map((ex) => (
              <Card
                key={ex.id}
                padding="sm"
                className="flex flex-wrap items-center justify-between gap-3"
              >
                <div className="space-y-1 min-w-0">
                  <div className="flex flex-wrap items-center gap-1.5">
                    {ex.subject && (
                      <Badge variant="neutral">
                        <BiText hi={ex.subject.nameHi} en={ex.subject.nameEn} inline />
                      </Badge>
                    )}
                    {ex.myAttempt?.status === "SUBMITTED" ? (
                      <Badge variant="emerald">
                        {t(
                          `अंक: ${ex.myAttempt.score} (${ex.myAttempt.accuracy}%)`,
                          `Score: ${ex.myAttempt.score} (${ex.myAttempt.accuracy}%)`
                        )}
                      </Badge>
                    ) : (
                      <Badge variant="outline">{t("समाप्त", "Ended")}</Badge>
                    )}
                  </div>
                  <div className="font-bold text-sm sm:text-base text-ink truncate">
                    {ex.title}
                  </div>
                </div>

                {ex.myAttempt?.status === "SUBMITTED" && (
                  <Link href={`/student/exams/${ex.id}`}>
                    <Button size="sm" variant="secondary" rightIcon={<ArrowRight className="h-4 w-4" />}>
                      {ex.solutionsUnlocked
                        ? t("परिणाम व हल देखें", "View Result & Solutions")
                        : t("परिणाम देखें", "View Score")}
                    </Button>
                  </Link>
                )}
              </Card>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}
