"use client";

import React, { useEffect, useId, useMemo, useState } from "react";
import { Calendar } from "lucide-react";
import { useLanguage } from "../providers/LanguageProvider";
import { Select } from "./Select";
import { cn } from "./cn";

const MONTHS = [
  { num: "01", hi: "जनवरी", en: "January", shortEn: "Jan" },
  { num: "02", hi: "फ़रवरी", en: "February", shortEn: "Feb" },
  { num: "03", hi: "मार्च", en: "March", shortEn: "Mar" },
  { num: "04", hi: "अप्रैल", en: "April", shortEn: "Apr" },
  { num: "05", hi: "मई", en: "May", shortEn: "May" },
  { num: "06", hi: "जून", en: "June", shortEn: "Jun" },
  { num: "07", hi: "जुलाई", en: "July", shortEn: "Jul" },
  { num: "08", hi: "अगस्त", en: "August", shortEn: "Aug" },
  { num: "09", hi: "सितंबर", en: "September", shortEn: "Sep" },
  { num: "10", hi: "अक्टूबर", en: "October", shortEn: "Oct" },
  { num: "11", hi: "नवंबर", en: "November", shortEn: "Nov" },
  { num: "12", hi: "दिसंबर", en: "December", shortEn: "Dec" },
] as const;

function daysInMonth(yearStr: string, monthStr: string): number {
  const month = Number(monthStr);
  if (!month) return 31;
  const year = Number(yearStr) || 2008; // 2008 is leap year so Feb allows 29 before year picked
  return new Date(year, month, 0).getDate();
}

function parseIsoDate(iso?: string): { day: string; month: string; year: string } {
  if (!iso || !/^\d{4}-\d{2}-\d{2}$/.test(iso)) {
    return { day: "", month: "", year: "" };
  }
  const [year, month, day] = iso.split("-");
  return { day, month, year };
}

export interface DobDropdownPickerProps {
  value: string;
  onChange: (isoDate: string) => void;
  label?: React.ReactNode;
  hint?: React.ReactNode;
  error?: React.ReactNode;
  required?: boolean;
  disabled?: boolean;
  minYear?: number;
  maxYear?: number;
  className?: string;
}

/**
 * Student-friendly 3-dropdown Date of Birth picker (Day / Month in Hindi+English / Year 2002-2016)
 * specifically designed for Bihar Class 9-12 students using budget Android phones.
 */
export function DobDropdownPicker({
  value,
  onChange,
  label,
  hint,
  error,
  required = false,
  disabled = false,
  minYear = 2002,
  maxYear = 2016,
  className,
}: DobDropdownPickerProps) {
  const { lang, t } = useLanguage();
  const groupId = useId();
  const parsed = useMemo(() => parseIsoDate(value), [value]);

  const [day, setDay] = useState(parsed.day);
  const [month, setMonth] = useState(parsed.month);
  const [year, setYear] = useState(parsed.year);

  useEffect(() => {
    if (value && /^\d{4}-\d{2}-\d{2}$/.test(value)) {
      const next = parseIsoDate(value);
      setDay(next.day);
      setMonth(next.month);
      setYear(next.year);
    } else if (value === "") {
      // Allow external reset only when all 3 were previously filled
      setDay((prevDay) => (prevDay && month && year ? "" : prevDay));
      setMonth((prevMonth) => (day && prevMonth && year ? "" : prevMonth));
      setYear((prevYear) => (day && month && prevYear ? "" : prevYear));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [value]);

  const maxDays = useMemo(() => daysInMonth(year, month), [year, month]);

  const dayOptions = useMemo(
    () =>
      Array.from({ length: maxDays }, (_, idx) => {
        const dd = String(idx + 1).padStart(2, "0");
        return { value: dd, label: dd };
      }),
    [maxDays]
  );

  const monthOptions = useMemo(
    () =>
      MONTHS.map((m) => ({
        value: m.num,
        label:
          lang === "EN"
            ? `${m.num} - ${m.en}`
            : lang === "HI"
            ? `${m.hi} (${m.shortEn})`
            : `${m.hi} / ${m.en}`,
      })),
    [lang]
  );

  const yearOptions = useMemo(() => {
    const years: Array<{ value: string; label: string }> = [];
    for (let y = maxYear; y >= minYear; y -= 1) {
      years.push({ value: String(y), label: String(y) });
    }
    return years;
  }, [minYear, maxYear]);

  const emitIfComplete = (nextDay: string, nextMonth: string, nextYear: string) => {
    const allowed = daysInMonth(nextYear, nextMonth);
    let safeDay = nextDay;
    if (safeDay && Number(safeDay) > allowed) {
      safeDay = String(allowed).padStart(2, "0");
      setDay(safeDay);
    }

    if (safeDay && nextMonth && nextYear) {
      onChange(`${nextYear}-${nextMonth}-${safeDay}`);
    } else if (value !== "") {
      onChange("");
    }
  };

  const handleDayChange = (nextDay: string) => {
    setDay(nextDay);
    emitIfComplete(nextDay, month, year);
  };

  const handleMonthChange = (nextMonth: string) => {
    setMonth(nextMonth);
    emitIfComplete(day, nextMonth, year);
  };

  const handleYearChange = (nextYear: string) => {
    setYear(nextYear);
    emitIfComplete(day, month, nextYear);
  };

  const selectedMonthMeta = MONTHS.find((m) => m.num === month);
  const formattedPreview =
    day && selectedMonthMeta && year
      ? lang === "EN"
        ? `${Number(day)} ${selectedMonthMeta.en} ${year}`
        : `${Number(day)} ${selectedMonthMeta.hi} ${year}`
      : null;

  return (
    <fieldset
      className={cn("flex flex-col gap-1.5 w-full", className)}
      aria-describedby={error ? `${groupId}-error` : hint ? `${groupId}-hint` : undefined}
    >
      <legend className="text-sm font-semibold text-ink leading-snug mb-1 flex items-center gap-1.5">
        <Calendar className="h-4 w-4 text-indigo-ink shrink-0" aria-hidden="true" />
        <span>{label ?? t("जन्म तिथि (DOB)", "Date of Birth")}</span>
        {required && (
          <span className="text-crimson-ink" aria-hidden="true">
            *
          </span>
        )}
      </legend>

      <div className="grid grid-cols-1 sm:grid-cols-12 gap-2.5">
        <div className="sm:col-span-3">
          <Select
            aria-label={t("जन्म का दिन", "Day of birth")}
            value={day}
            disabled={disabled}
            onChange={(e) => handleDayChange(e.target.value)}
            placeholder={t("दिन (Day)", "Day")}
            options={dayOptions}
            error={error ? " " : undefined}
          />
        </div>

        <div className="sm:col-span-5">
          <Select
            aria-label={t("जन्म का महीना", "Month of birth")}
            value={month}
            disabled={disabled}
            onChange={(e) => handleMonthChange(e.target.value)}
            placeholder={t("महीना (Month)", "Month")}
            options={monthOptions}
            error={error ? " " : undefined}
          />
        </div>

        <div className="sm:col-span-4">
          <Select
            aria-label={t("जन्म का वर्ष", "Year of birth")}
            value={year}
            disabled={disabled}
            onChange={(e) => handleYearChange(e.target.value)}
            placeholder={t("वर्ष (Year)", "Year")}
            options={yearOptions}
            error={error ? " " : undefined}
          />
        </div>
      </div>

      {formattedPreview && !error && (
        <p className="text-xs font-medium text-emerald-ink mt-0.5">
          {t("चयनित जन्म तिथि:", "Selected date of birth:")} {formattedPreview}
        </p>
      )}

      {error ? (
        <p
          id={`${groupId}-error`}
          role="alert"
          className="text-xs font-medium text-crimson-ink"
        >
          {error}
        </p>
      ) : hint ? (
        <p id={`${groupId}-hint`} className="text-xs text-ink-muted leading-relaxed">
          {hint}
        </p>
      ) : (
        <p id={`${groupId}-hint`} className="text-xs text-ink-muted leading-relaxed">
          {t(
            "स्कूल रजिस्टर / प्रवेश पत्र के अनुसार अपना दिन, महीना और वर्ष चुनें।",
            "Choose your Day, Month, and Year exactly as written in your school register."
          )}
        </p>
      )}
    </fieldset>
  );
}
