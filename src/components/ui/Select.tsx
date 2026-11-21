"use client";

import React, { useId } from "react";
import { ChevronDown } from "lucide-react";
import { cn } from "./cn";

export interface SelectOption {
  value: string;
  label: string;
  disabled?: boolean;
}

export interface SelectProps
  extends React.SelectHTMLAttributes<HTMLSelectElement> {
  label?: React.ReactNode;
  hint?: React.ReactNode;
  error?: React.ReactNode;
  placeholder?: string;
  options?: SelectOption[];
  containerClassName?: string;
}

export const Select = React.forwardRef<HTMLSelectElement, SelectProps>(
  function Select(
    {
      id,
      label,
      hint,
      error,
      placeholder,
      options,
      children,
      className,
      containerClassName,
      required,
      ...props
    },
    ref
  ) {
    const generatedId = useId();
    const selectId = id ?? generatedId;
    const errorId = `${selectId}-error`;
    const hintId = `${selectId}-hint`;

    return (
      <div className={cn("flex flex-col gap-1.5 w-full", containerClassName)}>
        {label && (
          <label
            htmlFor={selectId}
            className="text-sm font-semibold text-ink leading-snug"
          >
            {label}
            {required && (
              <span className="text-crimson-ink ml-1" aria-hidden="true">
                *
              </span>
            )}
          </label>
        )}

        <div className="relative flex items-center">
          <select
            ref={ref}
            id={selectId}
            required={required}
            aria-invalid={error ? true : undefined}
            aria-describedby={error ? errorId : hint ? hintId : undefined}
            className={cn(
              "w-full min-h-[44px] appearance-none rounded-lg bg-surface pl-3.5 pr-10 py-2.5 text-ink",
              "border border-hairline-strong transition-colors duration-150 cursor-pointer",
              "hover:border-ink-muted focus:border-indigo-academic focus:ring-2 focus:ring-indigo-academic/20 focus:outline-none",
              "disabled:bg-surface-subtle disabled:text-ink-muted disabled:cursor-not-allowed",
              error &&
                "border-crimson-alert focus:border-crimson-alert focus:ring-crimson-alert/20",
              className
            )}
            {...props}
          >
            {placeholder !== undefined && (
              <option value="" disabled={required}>
                {placeholder}
              </option>
            )}
            {options
              ? options.map((opt) => (
                  <option
                    key={opt.value}
                    value={opt.value}
                    disabled={opt.disabled}
                  >
                    {opt.label}
                  </option>
                ))
              : children}
          </select>

          <ChevronDown
            className="pointer-events-none absolute right-3 h-4 w-4 text-ink-muted"
            aria-hidden="true"
          />
        </div>

        {error ? (
          <p id={errorId} role="alert" className="text-xs font-medium text-crimson-ink">
            {error}
          </p>
        ) : hint ? (
          <p id={hintId} className="text-xs text-ink-muted leading-relaxed">
            {hint}
          </p>
        ) : null}
      </div>
    );
  }
);
