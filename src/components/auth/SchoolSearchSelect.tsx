"use client";

import React, { useEffect, useId, useMemo, useState } from "react";
import { Building2, Check, Search } from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { cn } from "@/components/ui/cn";

export interface PublicSchoolOption {
  udise_code: string;
  school_name: string;
  school_name_hi: string | null;
  district_name: string;
  block_name: string | null;
}

export interface SchoolSearchSelectProps {
  value: string;
  onChange: (udiseCode: string, school?: PublicSchoolOption) => void;
  label?: React.ReactNode;
  error?: React.ReactNode;
  allowManualUdise?: boolean;
  required?: boolean;
  className?: string;
}

/**
 * Searchable Bihar School selector backed by GET /api/public/schools.
 * Displays School Name + District + 11-digit UDISE, with clean manual UDISE support
 * for large statewide school lists or direct UDISE entry.
 */
export function SchoolSearchSelect({
  value,
  onChange,
  label,
  error,
  allowManualUdise = false,
  required = true,
  className,
}: SchoolSearchSelectProps) {
  const { lang, t } = useLanguage();
  const inputId = useId();

  const [schools, setSchools] = useState<PublicSchoolOption[]>([]);
  const [loading, setLoading] = useState(true);
  const [query, setQuery] = useState("");
  const [open, setOpen] = useState(false);

  useEffect(() => {
    let active = true;
    fetch("/api/public/schools", { cache: "no-store" })
      .then((res) => (res.ok ? res.json() : { schools: [] }))
      .then((data: { schools?: PublicSchoolOption[] }) => {
        if (!active) return;
        const list = Array.isArray(data.schools) ? data.schools : [];
        setSchools(list);
        // Auto-select cleanly when only 1 school is onboarded and no value is set yet
        if (list.length === 1 && !value) {
          onChange(list[0].udise_code, list[0]);
        }
      })
      .catch(() => {
        if (active) setSchools([]);
      })
      .finally(() => {
        if (active) setLoading(false);
      });

    return () => {
      active = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const selectedSchool = useMemo(
    () => schools.find((s) => s.udise_code === value) ?? null,
    [schools, value]
  );

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return schools;
    return schools.filter((s) => {
      return (
        s.school_name.toLowerCase().includes(q) ||
        (s.school_name_hi ?? "").toLowerCase().includes(q) ||
        s.district_name.toLowerCase().includes(q) ||
        (s.block_name ?? "").toLowerCase().includes(q) ||
        s.udise_code.includes(q)
      );
    });
  }, [schools, query]);

  const handleQueryChange = (next: string) => {
    setQuery(next);
    setOpen(true);

    if (allowManualUdise) {
      const digits = next.replace(/\D/g, "");
      if (digits.length === 11) {
        const match = schools.find((s) => s.udise_code === digits);
        onChange(digits, match);
      } else if (selectedSchool) {
        onChange("");
      }
    }
  };

  const displayName = (school: PublicSchoolOption) => {
    if (lang === "HI" && school.school_name_hi) {
      return school.school_name_hi;
    }
    return school.school_name;
  };

  return (
    <div className={cn("flex flex-col gap-1.5 w-full relative", className)}>
      <label
        htmlFor={inputId}
        className="text-sm font-semibold text-ink leading-snug flex items-center gap-1.5"
      >
        <Building2
          className="h-4 w-4 text-indigo-ink shrink-0"
          aria-hidden="true"
        />
        <span>{label ?? t("अपना विद्यालय चुनें", "Select Your School")}</span>
        {required && (
          <span className="text-crimson-ink" aria-hidden="true">
            *
          </span>
        )}
      </label>

      {selectedSchool && !open ? (
        <div className="flex items-center justify-between gap-3 rounded-lg border border-indigo-academic/40 bg-indigo-soft px-3.5 py-2.5">
          <div className="min-w-0">
            <p className="text-sm font-semibold text-ink truncate">
              {displayName(selectedSchool)}
            </p>
            <p className="text-xs text-ink-secondary truncate mt-0.5">
              {selectedSchool.block_name ? `${selectedSchool.block_name}, ` : ""}
              {selectedSchool.district_name} · UDISE: {selectedSchool.udise_code}
            </p>
          </div>
          <button
            type="button"
            onClick={() => {
              setQuery("");
              setOpen(true);
            }}
            className="shrink-0 min-h-[36px] px-2.5 text-xs font-semibold text-indigo-ink rounded-md border border-indigo-academic/25 bg-surface hover:bg-surface-subtle transition-colors"
          >
            {t("बदलें", "Change")}
          </button>
        </div>
      ) : (
        <div className="relative">
          <Search
            className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-ink-muted"
            aria-hidden="true"
          />
          <input
            id={inputId}
            type="text"
            value={query || (allowManualUdise ? value : "")}
            onFocus={() => setOpen(true)}
            onChange={(e) => handleQueryChange(e.target.value)}
            placeholder={
              allowManualUdise
                ? t(
                    "विद्यालय का नाम, जिला या 11-अंकीय UDISE लिखें...",
                    "Search school name, district, or enter 11-digit UDISE..."
                  )
                : t(
                    "विद्यालय का नाम, जिला या UDISE खोजें...",
                    "Search school name, district, or UDISE..."
                  )
            }
            autoComplete="off"
            className={cn(
              "w-full min-h-[44px] rounded-lg bg-surface pl-10 pr-3.5 py-2.5 text-ink placeholder:text-ink-muted",
              "border border-hairline-strong transition-colors duration-150",
              "hover:border-ink-muted focus:border-indigo-academic focus:ring-2 focus:ring-indigo-academic/20 focus:outline-none",
              error && "border-crimson-alert focus:border-crimson-alert"
            )}
          />

          {open && (
            <div className="mt-1.5 max-h-60 overflow-y-auto rounded-lg border border-hairline bg-surface shadow-modal divide-y divide-hairline">
              {loading ? (
                <div className="px-3.5 py-3 text-xs text-ink-muted">
                  {t("विद्यालय सूची लोड हो रही है...", "Loading schools...")}
                </div>
              ) : filtered.length === 0 ? (
                <div className="px-3.5 py-3 text-xs text-ink-muted">
                  {allowManualUdise && /^\d{11}$/.test(query.trim())
                    ? t(
                        `UDISE ${query.trim()} दर्ज किया गया है।`,
                        `Using UDISE code ${query.trim()}.`
                      )
                    : t(
                        "कोई विद्यालय नहीं मिला। नाम या UDISE दोबारा जांचें।",
                        "No matching school found. Check the name or UDISE code."
                      )}
                </div>
              ) : (
                filtered.map((school) => {
                  const isSelected = school.udise_code === value;
                  return (
                    <button
                      key={school.udise_code}
                      type="button"
                      onClick={() => {
                        onChange(school.udise_code, school);
                        setQuery("");
                        setOpen(false);
                      }}
                      className={cn(
                        "w-full text-left px-3.5 py-2.5 flex items-center justify-between gap-3 hover:bg-surface-subtle transition-colors",
                        isSelected && "bg-indigo-soft"
                      )}
                    >
                      <div className="min-w-0">
                        <p className="text-sm font-semibold text-ink leading-snug">
                          {displayName(school)}
                        </p>
                        <p className="text-xs text-ink-secondary mt-0.5">
                          {school.block_name ? `${school.block_name}, ` : ""}
                          {school.district_name} · UDISE: {school.udise_code}
                        </p>
                      </div>
                      {isSelected && (
                        <Check
                          className="h-4 w-4 text-indigo-ink shrink-0"
                          aria-hidden="true"
                        />
                      )}
                    </button>
                  );
                })
              )}
            </div>
          )}
        </div>
      )}

      {error && (
        <p role="alert" className="text-xs font-medium text-crimson-ink">
          {error}
        </p>
      )}
    </div>
  );
}
