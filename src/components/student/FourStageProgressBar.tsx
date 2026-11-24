"use client";

import React from "react";
import Link from "next/link";
import { Award, BookOpen, CheckCircle2, Layers, Target } from "lucide-react";
import type { FourStageProgressResult } from "@/lib/progress/four-stage";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui";
import { cn } from "@/components/ui/cn";

export interface FourStageProgressBarProps {
  fourStage: FourStageProgressResult;
  chapterId?: string;
  activeStage?: "understand" | "play" | "quiz" | "mastery";
  onStageClick?: (stageKey: "understand" | "play" | "quiz" | "mastery") => void;
  compact?: boolean;
  className?: string;
}

const STAGE_ICON: Record<"understand" | "play" | "quiz" | "mastery", React.ReactNode> = {
  understand: <BookOpen className="h-3.5 w-3.5" />,
  play: <Layers className="h-3.5 w-3.5" />,
  quiz: <Target className="h-3.5 w-3.5" />,
  mastery: <Award className="h-3.5 w-3.5" />,
};

export function FourStageProgressBar({
  fourStage,
  chapterId,
  activeStage,
  onStageClick,
  compact = false,
  className,
}: FourStageProgressBarProps) {
  const { t } = useLanguage();

  if (compact) {
    return (
      <div className={cn("space-y-2", className)}>
        <div className="grid grid-cols-4 gap-1.5">
          {fourStage.stages.map((st) => (
            <div
              key={st.key}
              className={cn(
                "flex items-center gap-1 rounded-md border px-2 py-1 text-[11px] font-semibold truncate",
                st.completed
                  ? "border-emerald-mastery/35 bg-emerald-soft text-emerald-ink"
                  : st.stagePct > 0
                  ? "border-indigo-academic/30 bg-indigo-soft text-indigo-ink"
                  : "border-hairline bg-surface-subtle/60 text-ink-muted"
              )}
            >
              {st.completed ? (
                <CheckCircle2 className="h-3 w-3 shrink-0" />
              ) : (
                <span className="shrink-0 opacity-75">{STAGE_ICON[st.key]}</span>
              )}
              <span className="truncate">{t(st.short_hi, st.short_en)}</span>
            </div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div
      className={cn(
        "rounded-paper border border-hairline bg-surface p-4 shadow-paper space-y-3 no-print",
        className
      )}
    >
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="space-y-0.5">
          <div className="text-xs font-bold uppercase tracking-wider text-indigo-ink">
            {t("4-चरणीय अध्याय दक्षता यात्रा", "4-Stage Chapter Mastery Path")}
          </div>
          <p className="text-xs sm:text-sm font-semibold text-ink">
            {t(fourStage.milestone_hi, fourStage.milestone_en)}
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Badge variant={fourStage.totalPct >= 75 ? "emerald" : "indigo"}>
            {fourStage.completedStages}/4 {t("चरण पूर्ण", "Stages Done")}
          </Badge>
          <span className="text-sm font-extrabold text-indigo-ink">
            {fourStage.totalPct}%
          </span>
        </div>
      </div>

      {/* Segmented Bar */}
      <div className="h-2 w-full rounded-full bg-surface-subtle overflow-hidden">
        <div
          className={cn(
            "h-full rounded-full transition-all duration-500",
            fourStage.totalPct >= 85
              ? "bg-amber-warm"
              : fourStage.totalPct >= 50
              ? "bg-emerald-mastery"
              : "bg-indigo-academic"
          )}
          style={{ width: `${fourStage.totalPct}%` }}
        />
      </div>

      {/* 4 Interactive Stage Pills */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
        {fourStage.stages.map((st) => {
          const isCurrent = activeStage === st.key;
          const content = (
            <div
              className={cn(
                "flex items-center justify-between gap-2 rounded-lg border px-3 py-2 text-xs font-semibold transition-all",
                st.completed
                  ? "border-emerald-mastery/40 bg-emerald-soft text-emerald-ink"
                  : isCurrent
                  ? "border-indigo-academic bg-indigo-soft text-indigo-ink ring-1 ring-indigo-academic/25"
                  : "border-hairline bg-canvas text-ink-secondary hover:bg-surface-subtle"
              )}
            >
              <span className="inline-flex items-center gap-1.5 min-w-0">
                {st.completed ? (
                  <CheckCircle2 className="h-3.5 w-3.5 shrink-0 text-emerald-ink" />
                ) : (
                  <span className="shrink-0">{STAGE_ICON[st.key]}</span>
                )}
                <span className="truncate">{t(st.label_hi, st.label_en)}</span>
              </span>
              <span className="text-[11px] font-bold opacity-80 shrink-0">
                {st.points}/25
              </span>
            </div>
          );

          if (onStageClick) {
            return (
              <button
                key={st.key}
                type="button"
                onClick={() => onStageClick(st.key)}
                className="text-left"
              >
                {content}
              </button>
            );
          }

          if (chapterId) {
            const href =
              st.key === "understand"
                ? `/student/chapter/${chapterId}/notes`
                : st.key === "play"
                ? `/student/chapter/${chapterId}/practice?tab=visual`
                : st.key === "quiz"
                ? `/student/chapter/${chapterId}/practice?tab=mcq`
                : `/student/chapter/${chapterId}/practice?tab=subjective`;
            return (
              <Link key={st.key} href={href} className="block">
                {content}
              </Link>
            );
          }

          return <div key={st.key}>{content}</div>;
        })}
      </div>
    </div>
  );
}
