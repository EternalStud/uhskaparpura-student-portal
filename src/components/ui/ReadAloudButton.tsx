"use client";

import React, { useCallback, useEffect, useState } from "react";
import { Square, Volume2 } from "lucide-react";
import { useLanguage } from "../providers/LanguageProvider";
import { cn } from "./cn";

export interface ReadAloudButtonProps {
  /** Direct text to speak (if provided, overrides textHi/textEn). */
  text?: string;
  /** Hindi text for automatic language-aware narration. */
  textHi?: string;
  /** English text for automatic language-aware narration. */
  textEn?: string;
  /** Force a specific speech locale; defaults to active app language. */
  locale?: "hi-IN" | "en-IN";
  /** Calm default speech rate suited for school learners. */
  rate?: number;
  size?: "sm" | "md";
  label?: string;
  className?: string;
}

/**
 * Converts Markdown and basic KaTeX math markup into cleaner spoken text
 * so rural students hear natural narration instead of punctuation symbols.
 */
function sanitizeTextForSpeech(raw: string): string {
  return raw
    .replace(/```[\s\S]*?```/g, " ")
    .replace(/\$\$([\s\S]*?)\$\$/g, " $1 ")
    .replace(/\$([^$]+)\$/g, " $1 ")
    .replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, "$1 by $2")
    .replace(/\\times/g, " times ")
    .replace(/\\sqrt\{([^}]+)\}/g, " square root of $1 ")
    .replace(/\\[a-zA-Z]+/g, " ")
    .replace(/[#*_`~>|[\]]+/g, " ")
    .replace(/\((https?:\/\/[^)]+)\)/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

export function ReadAloudButton({
  text,
  textHi,
  textEn,
  locale,
  rate = 0.92,
  size = "sm",
  label,
  className,
}: ReadAloudButtonProps) {
  const { lang, t } = useLanguage();
  const [supported, setSupported] = useState(false);
  const [speaking, setSpeaking] = useState(false);

  useEffect(() => {
    setSupported(
      typeof window !== "undefined" &&
        "speechSynthesis" in window &&
        typeof SpeechSynthesisUtterance !== "undefined"
    );

    return () => {
      if (typeof window !== "undefined" && "speechSynthesis" in window) {
        window.speechSynthesis.cancel();
      }
    };
  }, []);

  const stop = useCallback(() => {
    if (typeof window !== "undefined" && "speechSynthesis" in window) {
      window.speechSynthesis.cancel();
    }
    setSpeaking(false);
  }, []);

  const handleToggle = useCallback(() => {
    if (!supported) return;

    if (speaking) {
      stop();
      return;
    }

    const effectiveLocale: "hi-IN" | "en-IN" =
      locale ?? (lang === "EN" ? "en-IN" : "hi-IN");

    const sourceText =
      text ??
      (lang === "EN"
        ? textEn || textHi || ""
        : lang === "HI"
        ? textHi || textEn || ""
        : [textHi, textEn].filter(Boolean).join(". "));

    const clean = sanitizeTextForSpeech(sourceText);
    if (!clean) return;

    const synth = window.speechSynthesis;
    synth.cancel();

    const utterance = new SpeechSynthesisUtterance(clean);
    utterance.lang = effectiveLocale;
    utterance.rate = rate;
    utterance.pitch = 1.0;

    const voices = synth.getVoices();
    const targetPrefix = effectiveLocale.split("-")[0].toLowerCase();
    const preferredVoice =
      voices.find(
        (v) => v.lang.toLowerCase() === effectiveLocale.toLowerCase()
      ) ??
      voices.find((v) => v.lang.toLowerCase().startsWith(targetPrefix));

    if (preferredVoice) {
      utterance.voice = preferredVoice;
    }

    utterance.onstart = () => setSpeaking(true);
    utterance.onend = () => setSpeaking(false);
    utterance.onerror = () => setSpeaking(false);

    setSpeaking(true);
    synth.speak(utterance);
  }, [lang, locale, rate, speaking, stop, supported, text, textEn, textHi]);

  if (!supported) return null;

  const buttonText = speaking
    ? t("रोकें", "Stop")
    : label ?? t("सुनें", "Listen");

  return (
    <button
      type="button"
      onClick={handleToggle}
      aria-pressed={speaking}
      aria-label={
        speaking
          ? t("पढ़ना बंद करें", "Stop reading aloud")
          : t("बोलकर सुनाएं", "Read aloud")
      }
      className={cn(
        "inline-flex items-center justify-center gap-1.5 rounded-lg border font-semibold transition-all duration-150 no-print select-none",
        size === "sm" ? "min-h-[38px] px-3 text-xs" : "min-h-[44px] px-3.5 text-sm",
        speaking
          ? "bg-amber-soft border-amber-warm/40 text-amber-ink"
          : "bg-surface border-hairline text-ink-secondary hover:bg-surface-subtle hover:text-ink hover:border-hairline-strong",
        className
      )}
    >
      {speaking ? (
        <Square className="h-3.5 w-3.5 fill-current shrink-0" aria-hidden="true" />
      ) : (
        <Volume2 className="h-4 w-4 text-indigo-ink shrink-0" aria-hidden="true" />
      )}
      <span>{buttonText}</span>
    </button>
  );
}
