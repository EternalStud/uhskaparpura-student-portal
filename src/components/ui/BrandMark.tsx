"use client";

import React from "react";
import { useLanguage } from "../providers/LanguageProvider";
import { cn } from "./cn";

export interface BrandMarkProps {
  size?: "sm" | "md" | "lg";
  showTagline?: boolean;
  schoolName?: string;
  className?: string;
}

const iconSizes = {
  sm: "h-8 w-8",
  md: "h-10 w-10",
  lg: "h-12 w-12",
};

const titleSizes = {
  sm: "text-sm sm:text-base",
  md: "text-base sm:text-lg",
  lg: "text-xl sm:text-2xl",
};

/**
 * Editorial crest for "Students of Bihar (9-12)" — calm open-book + academic leaf emblem.
 */
export function BrandMark({
  size = "md",
  showTagline = true,
  schoolName,
  className,
}: BrandMarkProps) {
  const { t } = useLanguage();

  return (
    <div className={cn("inline-flex items-center gap-3 select-none", className)}>
      <div
        className={cn(
          "relative shrink-0 rounded-paper bg-indigo-academic text-white flex items-center justify-center shadow-paper",
          iconSizes[size]
        )}
        aria-hidden="true"
      >
        <svg
          viewBox="0 0 36 36"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          className="h-[68%] w-[68%]"
        >
          {/* Open textbook pages */}
          <path
            d="M5 10.5C5 9.39543 5.89543 8.5 7 8.5H13.5C15.9853 8.5 18 10.5147 18 13V27.5C18 25.8431 16.6569 24.5 15 24.5H7C5.89543 24.5 5 23.6046 5 22.5V10.5Z"
            stroke="currentColor"
            strokeWidth="2.1"
            strokeLinejoin="round"
          />
          <path
            d="M31 10.5C31 9.39543 30.1046 8.5 29 8.5H22.5C20.0147 8.5 18 10.5147 18 13V27.5C18 25.8431 19.3431 24.5 21 24.5H29C30.1046 24.5 31 23.6046 31 22.5V10.5Z"
            stroke="currentColor"
            strokeWidth="2.1"
            strokeLinejoin="round"
          />
          {/* Warm amber flame / Bodhi-leaf spark above spine */}
          <path
            d="M18 4.2C18 4.2 20.8 6.9 20.8 9C20.8 10.5464 19.5464 11.8 18 11.8C16.4536 11.8 15.2 10.5464 15.2 9C15.2 6.9 18 4.2 18 4.2Z"
            fill="#F59E0B"
          />
        </svg>
      </div>

      <div className="min-w-0 leading-tight">
        <div
          className={cn(
            "font-bold tracking-tight text-ink truncate",
            titleSizes[size]
          )}
        >
          {t("बिहार के विद्यार्थी", "Students of Bihar")}
          <span className="ml-1.5 font-semibold text-indigo-ink text-[0.82em]">
            (9–12)
          </span>
        </div>

        {schoolName ? (
          <p className="text-xs text-ink-secondary truncate mt-0.5">
            {schoolName}
          </p>
        ) : showTagline ? (
          <p className="text-xs text-ink-muted truncate mt-0.5">
            {t(
              "बिहार बोर्ड (BSEB) अध्ययन एवं परीक्षा पोर्टल",
              "Bihar Board (BSEB) Academic & Assessment Portal"
            )}
          </p>
        ) : null}
      </div>
    </div>
  );
}
