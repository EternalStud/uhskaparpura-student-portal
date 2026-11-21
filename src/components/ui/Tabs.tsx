"use client";

import React from "react";
import { cn } from "./cn";

export interface TabItem<T extends string = string> {
  id: T;
  label: React.ReactNode;
  icon?: React.ReactNode;
  count?: number;
  disabled?: boolean;
}

export interface TabsProps<T extends string = string> {
  items: TabItem<T>[];
  value: T;
  onChange: (value: T) => void;
  variant?: "underline" | "pills";
  className?: string;
  ariaLabel?: string;
}

export function Tabs<T extends string = string>({
  items,
  value,
  onChange,
  variant = "underline",
  className,
  ariaLabel = "Section tabs",
}: TabsProps<T>) {
  return (
    <div
      role="tablist"
      aria-label={ariaLabel}
      className={cn(
        "flex items-center overflow-x-auto no-scrollbar",
        variant === "underline"
          ? "border-b border-hairline gap-1"
          : "bg-surface-subtle p-1 rounded-paper border border-hairline gap-1 w-fit max-w-full",
        className
      )}
    >
      {items.map((item) => {
        const active = item.id === value;

        return (
          <button
            key={item.id}
            type="button"
            role="tab"
            aria-selected={active}
            disabled={item.disabled}
            onClick={() => onChange(item.id)}
            className={cn(
              "inline-flex items-center justify-center gap-2 whitespace-nowrap font-semibold transition-all duration-150 shrink-0",
              "min-h-[44px] px-3.5 sm:px-4 text-sm",
              "disabled:opacity-45 disabled:cursor-not-allowed",
              variant === "underline"
                ? cn(
                    "border-b-2 -mb-px rounded-t-md",
                    active
                      ? "border-indigo-academic text-indigo-ink"
                      : "border-transparent text-ink-secondary hover:text-ink hover:border-hairline-strong"
                  )
                : cn(
                    "rounded-lg min-h-[38px]",
                    active
                      ? "bg-surface text-ink shadow-paper border border-hairline"
                      : "text-ink-secondary hover:text-ink border border-transparent"
                  )
            )}
          >
            {item.icon && <span className="shrink-0 inline-flex">{item.icon}</span>}
            <span>{item.label}</span>
            {typeof item.count === "number" && (
              <span
                className={cn(
                  "rounded-full px-1.5 py-0.5 text-[11px] font-bold leading-none",
                  active
                    ? "bg-indigo-soft text-indigo-ink"
                    : "bg-surface-subtle text-ink-muted"
                )}
              >
                {item.count}
              </span>
            )}
          </button>
        );
      })}
    </div>
  );
}
