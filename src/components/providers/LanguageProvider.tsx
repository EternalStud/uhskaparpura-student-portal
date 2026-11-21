"use client";

import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";

export type AppLanguage = "HI" | "EN" | "BOTH";

const STORAGE_KEY = "sob_lang";

interface LanguageContextValue {
  lang: AppLanguage;
  setLang: (next: AppLanguage) => void;
  t: (hi: string, en: string) => string;
  isHindi: boolean;
  isEnglish: boolean;
  isDual: boolean;
}

const LanguageContext = createContext<LanguageContextValue | null>(null);

function isValidLang(value: string | null): value is AppLanguage {
  return value === "HI" || value === "EN" || value === "BOTH";
}

export function LanguageProvider({
  children,
  defaultLang = "HI",
}: {
  children: React.ReactNode;
  defaultLang?: AppLanguage;
}) {
  const [lang, setLangState] = useState<AppLanguage>(defaultLang);

  useEffect(() => {
    try {
      const saved = window.localStorage.getItem(STORAGE_KEY);
      if (isValidLang(saved)) {
        setLangState(saved);
      }
    } catch {
      // Ignore storage failures in restricted browsers
    }
  }, []);

  useEffect(() => {
    document.documentElement.lang = lang === "EN" ? "en" : "hi";
    document.documentElement.dataset.lang = lang;
  }, [lang]);

  const setLang = useCallback((next: AppLanguage) => {
    setLangState(next);
    try {
      window.localStorage.setItem(STORAGE_KEY, next);
    } catch {
      // Ignore storage write errors
    }
  }, []);

  const t = useCallback(
    (hi: string, en: string): string => {
      if (lang === "HI") return hi || en;
      if (lang === "EN") return en || hi;
      if (!hi) return en;
      if (!en || hi.trim() === en.trim()) return hi;
      return `${hi} / ${en}`;
    },
    [lang]
  );

  const value = useMemo<LanguageContextValue>(
    () => ({
      lang,
      setLang,
      t,
      isHindi: lang === "HI",
      isEnglish: lang === "EN",
      isDual: lang === "BOTH",
    }),
    [lang, setLang, t]
  );

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage(): LanguageContextValue {
  const ctx = useContext(LanguageContext);
  if (!ctx) {
    throw new Error("useLanguage must be used within a LanguageProvider");
  }
  return ctx;
}

export interface BiTextProps {
  hi: string;
  en: string;
  className?: string;
  hiClassName?: string;
  enClassName?: string;
  inline?: boolean;
  as?: "span" | "p" | "div";
}

/**
 * Renders Hindi, English, or stacked/inline Bilingual text cleanly
 * according to the active LanguageProvider mode.
 */
export function BiText({
  hi,
  en,
  className,
  hiClassName,
  enClassName,
  inline = false,
  as = inline ? "span" : "span",
}: BiTextProps) {
  const { lang } = useLanguage();
  const Tag = as;

  if (lang === "HI") {
    return (
      <Tag className={className ? `${className} ${hiClassName ?? ""}`.trim() : hiClassName}>
        {hi || en}
      </Tag>
    );
  }

  if (lang === "EN") {
    return (
      <Tag className={className ? `${className} ${enClassName ?? ""}`.trim() : enClassName}>
        {en || hi}
      </Tag>
    );
  }

  // Dual (BOTH) mode
  if (!hi || !en || hi.trim() === en.trim()) {
    return <Tag className={className}>{hi || en}</Tag>;
  }

  if (inline) {
    return (
      <Tag className={className}>
        <span className={hiClassName}>{hi}</span>
        <span className="mx-1.5 text-ink-muted font-normal" aria-hidden="true">
          ·
        </span>
        <span className={enClassName ?? "text-ink-secondary font-normal"}>
          {en}
        </span>
      </Tag>
    );
  }

  return (
    <Tag className={className ? `inline-flex flex-col ${className}` : "inline-flex flex-col"}>
      <span className={hiClassName}>{hi}</span>
      <span
        className={
          enClassName ??
          "text-[0.86em] font-normal text-ink-secondary leading-snug mt-0.5"
        }
      >
        {en}
      </span>
    </Tag>
  );
}
