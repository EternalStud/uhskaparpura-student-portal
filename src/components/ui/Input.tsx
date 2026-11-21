"use client";

import React, { useId } from "react";
import { cn } from "./cn";

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: React.ReactNode;
  hint?: React.ReactNode;
  error?: React.ReactNode;
  leftIcon?: React.ReactNode;
  rightElement?: React.ReactNode;
  containerClassName?: string;
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  function Input(
    {
      id,
      label,
      hint,
      error,
      leftIcon,
      rightElement,
      className,
      containerClassName,
      required,
      ...props
    },
    ref
  ) {
    const generatedId = useId();
    const inputId = id ?? generatedId;
    const errorId = `${inputId}-error`;
    const hintId = `${inputId}-hint`;

    return (
      <div className={cn("flex flex-col gap-1.5 w-full", containerClassName)}>
        {label && (
          <label
            htmlFor={inputId}
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
          {leftIcon && (
            <span
              className="pointer-events-none absolute left-3.5 text-ink-muted inline-flex items-center"
              aria-hidden="true"
            >
              {leftIcon}
            </span>
          )}

          <input
            ref={ref}
            id={inputId}
            required={required}
            aria-invalid={error ? true : undefined}
            aria-describedby={
              error ? errorId : hint ? hintId : undefined
            }
            className={cn(
              "w-full min-h-[44px] rounded-lg bg-surface px-3.5 py-2.5 text-ink placeholder:text-ink-muted",
              "border border-hairline-strong transition-colors duration-150",
              "hover:border-ink-muted focus:border-indigo-academic focus:ring-2 focus:ring-indigo-academic/20 focus:outline-none",
              "disabled:bg-surface-subtle disabled:text-ink-muted disabled:cursor-not-allowed",
              leftIcon && "pl-10",
              rightElement && "pr-11",
              error &&
                "border-crimson-alert focus:border-crimson-alert focus:ring-crimson-alert/20",
              className
            )}
            {...props}
          />

          {rightElement && (
            <div className="absolute right-2 flex items-center">
              {rightElement}
            </div>
          )}
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
