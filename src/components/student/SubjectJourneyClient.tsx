"use client";

import React from "react";
import Link from "next/link";
import {
  ArrowLeft,
  Award,
  BookOpen,
  CheckCircle2,
  Clock,
  Dumbbell,
  Medal,
  Sparkles,
} from "lucide-react";
import type { ChapterRow, SubjectRow } from "@/types/database";
import type { ChapterMedal } from "@/app/api/student/_helpers";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Button, Card } from "@/components/ui";
import { SubjectIcon } from "./SubjectIcon";
import { cn } from "@/components/ui/cn";

export interface JourneyChapterItem extends ChapterRow {
  hasRichNotes: boolean;
  practiceCount: number;
  notesCompleted: boolean;
  masteryPct: number;
  medal: ChapterMedal;
}

export function SubjectJourneyClient({
  subject,
  chapters,
}: {
  subject: SubjectRow;
  chapters: JourneyChapterItem[];
}) {
  const { t } = useLanguage();

  const completedCount = chapters.filter((c) => c.notesCompleted && c.masteryPct >= 60).length;
  const avgMastery =
    chapters.length > 0
      ? Math.round(chapters.reduce((acc, c) => acc + c.masteryPct, 0) / chapters.length)
      : 0;

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <Link
        href="/student"
        className="inline-flex items-center gap-1.5 text-sm font-semibold text-indigo-ink hover:underline"
      >
        <ArrowLeft className="h-4 w-4" />
        <span>{t("पढ़ाई होम पर वापस", "Back to Study Home")}</span>
      </Link>

      {/* Subject Banner */}
      <Card variant="indigo" padding="lg" className="space-y-4">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div className="flex items-start gap-3.5">
            <span
              className="inline-flex h-12 w-12 items-center justify-center rounded-paper text-white shrink-0 shadow-paper"
              style={{ backgroundColor: subject.accent_color }}
            >
              <SubjectIcon name={subject.icon_name} className="h-6 w-6" />
            </span>
            <div>
              <div className="flex flex-wrap items-center gap-2 mb-1">
                <Badge variant="indigo">
                  {t(`कक्षा ${subject.class_num}`, `Class ${subject.class_num}`)}
                </Badge>
                <Badge variant="neutral">
                  {t("कोड", "Code")}: {subject.bseb_code}
                </Badge>
              </div>
              <h1 className="text-2xl sm:text-3xl font-bold text-ink leading-tight">
                <BiText hi={subject.name_hi} en={subject.name_en} />
              </h1>
            </div>
          </div>

          <div className="rounded-lg bg-surface border border-hairline px-4 py-2.5 text-right">
            <div className="text-xl font-bold text-indigo-ink">{avgMastery}%</div>
            <div className="text-xs text-ink-secondary">
              {t(`${completedCount}/${chapters.length} अध्याय पूर्ण`, `${completedCount}/${chapters.length} completed`)}
            </div>
          </div>
        </div>
      </Card>

      {/* Calm Vertical Skill Journey Path */}
      {chapters.length === 0 ? (
        <Card className="text-center py-10 space-y-2">
          <BookOpen className="h-8 w-8 text-indigo-ink mx-auto opacity-80" />
          <p className="text-sm font-semibold text-ink">
            {t("इस विषय के अध्याय जल्द जोड़े जा रहे हैं।", "Chapters for this subject are being published soon.")}
          </p>
        </Card>
      ) : (
        <div className="relative pl-6 sm:pl-9 space-y-4">
          {/* Vertical Spine */}
          <div
            className="absolute left-3 sm:left-4 top-6 bottom-6 w-0.5 bg-hairline-strong"
            aria-hidden="true"
          />

          {chapters.map((ch) => {
            const medalBadge =
              ch.medal === "GOLD"
                ? { labelHi: "स्वर्ण पदक", labelEn: "Gold Medal", variant: "amber" as const }
                : ch.medal === "SILVER"
                ? { labelHi: "रजत पदक", labelEn: "Silver Medal", variant: "indigo" as const }
                : ch.medal === "BRONZE"
                ? { labelHi: "कांस्य पदक", labelEn: "Bronze Medal", variant: "emerald" as const }
                : null;

            return (
              <div key={ch.id} className="relative">
                {/* Circular Progress Milestone Node */}
                <span
                  aria-hidden="true"
                  className={cn(
                    "absolute -left-6 sm:-left-9 top-6 h-7 w-7 rounded-full border-2 flex items-center justify-center text-xs font-bold shadow-paper",
                    ch.masteryPct >= 85
                      ? "bg-amber-warm border-surface text-white"
                      : ch.notesCompleted
                      ? "bg-emerald-mastery border-surface text-white"
                      : ch.hasRichNotes
                      ? "bg-indigo-academic border-surface text-white"
                      : "bg-surface border-hairline-strong text-ink-secondary"
                  )}
                >
                  {ch.notesCompleted ? (
                    <CheckCircle2 className="h-4 w-4" />
                  ) : (
                    ch.chapter_no
                  )}
                </span>

                <Card
                  variant={ch.hasRichNotes ? "interactive" : "default"}
                  className={cn(
                    "space-y-3.5",
                    ch.hasRichNotes && "border-indigo-academic/25"
                  )}
                >
                  <div className="flex flex-wrap items-start justify-between gap-3">
                    <div className="space-y-1 min-w-0 flex-1">
                      <div className="flex flex-wrap items-center gap-1.5">
                        <Badge variant="neutral">
                          {t(`अध्याय ${ch.chapter_no}`, `Ch ${ch.chapter_no}`)}
                        </Badge>
                        {ch.hasRichNotes && (
                          <Badge variant="emerald" icon={<Sparkles className="h-3 w-3" />}>
                            {t("विज़ुअल नोट्स तैयार", "Visual Notes Ready")}
                          </Badge>
                        )}
                        <Badge variant="amber" icon={<Award className="h-3 w-3" />}>
                          {t(`${ch.bseb_weightage_marks} अंक`, `${ch.bseb_weightage_marks} Marks`)}
                        </Badge>
                        <Badge variant="outline" icon={<Clock className="h-3 w-3" />}>
                          {t(`${ch.estimated_mins} मि.`, `${ch.estimated_mins}m`)}
                        </Badge>
                        {medalBadge && (
                          <Badge variant={medalBadge.variant} icon={<Medal className="h-3 w-3" />}>
                            {t(medalBadge.labelHi, medalBadge.labelEn)}
                          </Badge>
                        )}
                      </div>

                      <h2 className="text-base sm:text-lg font-bold text-ink leading-snug pt-0.5">
                        <BiText hi={ch.title_hi} en={ch.title_en} />
                      </h2>

                      {(ch.summary_hi || ch.summary_en) && (
                        <p className="text-xs sm:text-sm text-ink-secondary leading-relaxed">
                          <BiText hi={ch.summary_hi ?? ""} en={ch.summary_en ?? ""} />
                        </p>
                      )}
                    </div>

                    <div className="text-right shrink-0">
                      <div className="text-sm font-bold text-indigo-ink">{ch.masteryPct}%</div>
                      <div className="text-[11px] text-ink-muted">{t("दक्षता", "Mastery")}</div>
                    </div>
                  </div>

                  {/* Progress Bar */}
                  <div className="h-1.5 w-full rounded-full bg-surface-subtle overflow-hidden">
                    <div
                      className={cn(
                        "h-full rounded-full transition-all",
                        ch.masteryPct >= 85
                          ? "bg-amber-warm"
                          : ch.masteryPct >= 40
                          ? "bg-emerald-mastery"
                          : "bg-indigo-academic"
                      )}
                      style={{ width: `${ch.masteryPct}%` }}
                    />
                  </div>

                  {/* Notes & Practice Action Buttons */}
                  <div className="flex flex-wrap items-center justify-between gap-2 pt-1">
                    <span className="text-xs text-ink-muted">
                      {ch.practiceCount > 0
                        ? t(`${ch.practiceCount} अभ्यास प्रश्न उपलब्ध`, `${ch.practiceCount} practice items ready`)
                        : t("अध्याय पाठ्यक्रम सूचीबद्ध", "Chapter indexed in syllabus")}
                    </span>

                    <div className="flex flex-wrap items-center gap-2">
                      <Link href={`/student/chapter/${ch.id}/notes`}>
                        <Button
                          size="sm"
                          variant={ch.hasRichNotes ? "primary" : "secondary"}
                          leftIcon={<BookOpen className="h-4 w-4" />}
                        >
                          {t("नोट्स पढ़ें", "Visual Notes")}
                        </Button>
                      </Link>
                      <Link href={`/student/chapter/${ch.id}/practice`}>
                        <Button
                          size="sm"
                          variant={ch.practiceCount > 0 ? "outline" : "ghost"}
                          leftIcon={<Dumbbell className="h-4 w-4" />}
                        >
                          {t("अभ्यास करें", "Practice")}
                        </Button>
                      </Link>
                    </div>
                  </div>
                </Card>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
