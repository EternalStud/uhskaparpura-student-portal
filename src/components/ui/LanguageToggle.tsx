"use client";

import React from "react";
import { Languages, Moon, Sun } from "lucide-react";
import { useLanguage, type AppLanguage } from "../providers/LanguageProvider";
import { useTheme } from "../providers/ThemeProvider";
import { cn } from "./cn";

const OPTIONS: Array<{ code: AppLanguage; label: string; shortLabel: string; title: string }> = [
  { code: "HI", label: "हिंदी", shortLabel: "हिं", title: "Hindi (Default)" },
  { code: "EN", label: "English", shortLabel: "EN", title: "English" },
  { code: "BOTH", label: "दोनों", shortLabel: "हिं+EN", title: "Bilingual (Hindi + English)" },
];

export interface LanguageToggleProps {
  compact?: boolean;
  className?: string;
}

export function LanguageToggle({
  compact = false,
  className,
}: LanguageToggleProps) {
  const { lang, setLang } = useLanguage();

  return (
    <div
      role="group"
      aria-label="Language switcher"
      className={cn(
        "inline-flex items-center rounded-lg bg-surface-subtle p-0.5 border border-hairline no-print",
        className
      )}
    >
      {!compact && (
        <span
          className="hidden sm:inline-flex items-center pl-2 pr-1.5 text-ink-muted"
          aria-hidden="true"
        >
          <Languages className="h-3.5 w-3.5" />
        </span>
      )}
      {OPTIONS.map((opt) => {
        const active = lang === opt.code;
        return (
          <button
            key={opt.code}
            type="button"
            title={opt.title}
            aria-pressed={active}
            onClick={() => setLang(opt.code)}
            className={cn(
              "min-h-[36px] px-2.5 sm:px-3 text-xs font-semibold rounded-md transition-all duration-150 whitespace-nowrap",
              active
                ? "bg-surface text-indigo-ink shadow-paper border border-hairline"
                : "text-ink-secondary hover:text-ink border border-transparent"
            )}
          >
            {compact ? opt.shortLabel : opt.label}
          </button>
        );
      })}
    </div>
  );
}

export interface ThemeToggleProps {
  className?: string;
  showLabel?: boolean;
}

export function ThemeToggle({
  className,
  showLabel = false,
}: ThemeToggleProps) {
  const { isDark, toggleTheme } = useTheme();
  const { t } = useLanguage();

  return (
    <button
      type="button"
      onClick={toggleTheme}
      aria-pressed={isDark}
      aria-label={
        isDark
          ? t("दिन के मोड में बदलें", "Switch to Paper Light Mode")
          : t("नाइट स्टडी मोड चालू करें", "Switch to Night Study Mode")
      }
      title={
        isDark
          ? t("पेपर लाइट मोड", "Paper Light Mode")
          : t("नाइट स्टडी मोड", "Night Study Mode")
      }
      className={cn(
        "inline-flex items-center justify-center gap-2 min-h-[38px] rounded-lg border border-hairline bg-surface px-2.5 text-ink-secondary hover:text-ink hover:bg-surface-subtle transition-colors no-print",
        !showLabel && "w-[38px] px-0",
        className
      )}
    >
      {isDark ? (
        <Sun className="h-4 w-4 text-amber-warm" aria-hidden="true" />
      ) : (
        <Moon className="h-4 w-4 text-indigo-ink" aria-hidden="true" />
      )}
      {showLabel && (
        <span className="text-xs font-semibold">
          {isDark ? t("दिन मोड", "Day Mode") : t("नाइट स्टडी", "Night Study")}
        </span>
      )}
    </button>
  );
}
