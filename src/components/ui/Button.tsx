"use client";

import React from "react";
import { Loader2 } from "lucide-react";
import { cn } from "./cn";

export type ButtonVariant =
  | "primary"
  | "secondary"
  | "outline"
  | "ghost"
  | "amber"
  | "emerald"
  | "danger";

export type ButtonSize = "sm" | "md" | "lg" | "icon";

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  loading?: boolean;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
  fullWidth?: boolean;
}

const variantClasses: Record<ButtonVariant, string> = {
  primary:
    "bg-indigo-academic text-white border border-transparent hover:bg-indigo-academic-hover shadow-paper active:scale-[0.99]",
  secondary:
    "bg-surface text-ink border border-hairline hover:bg-surface-subtle hover:border-hairline-strong shadow-paper",
  outline:
    "bg-transparent text-indigo-ink border border-indigo-academic/40 hover:bg-indigo-soft",
  ghost:
    "bg-transparent text-ink-secondary border border-transparent hover:bg-surface-subtle hover:text-ink",
  amber:
    "bg-amber-warm text-white border border-transparent hover:opacity-95 shadow-paper",
  emerald:
    "bg-emerald-mastery text-white border border-transparent hover:opacity-95 shadow-paper",
  danger:
    "bg-crimson-alert text-white border border-transparent hover:opacity-95 shadow-paper",
};

const sizeClasses: Record<ButtonSize, string> = {
  sm: "min-h-[38px] px-3.5 py-1.5 text-sm gap-1.5 rounded-lg",
  md: "min-h-[44px] px-4 py-2.5 text-sm sm:text-[15px] gap-2 rounded-lg",
  lg: "min-h-[48px] px-6 py-3 text-base gap-2.5 rounded-paper",
  icon: "h-11 w-11 p-0 rounded-lg",
};

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  function Button(
    {
      className,
      variant = "primary",
      size = "md",
      loading = false,
      disabled,
      leftIcon,
      rightIcon,
      fullWidth = false,
      type = "button",
      children,
      ...props
    },
    ref
  ) {
    const isDisabled = disabled || loading;

    return (
      <button
        ref={ref}
        type={type}
        disabled={isDisabled}
        aria-busy={loading || undefined}
        className={cn(
          "inline-flex items-center justify-center font-semibold transition-all duration-150 select-none whitespace-nowrap",
          "disabled:opacity-55 disabled:cursor-not-allowed disabled:pointer-events-none",
          variantClasses[variant],
          sizeClasses[size],
          fullWidth && "w-full",
          className
        )}
        {...props}
      >
        {loading ? (
          <Loader2 className="h-4 w-4 animate-spin shrink-0" aria-hidden="true" />
        ) : (
          leftIcon && <span className="shrink-0 inline-flex">{leftIcon}</span>
        )}
        {children}
        {!loading && rightIcon && (
          <span className="shrink-0 inline-flex">{rightIcon}</span>
        )}
      </button>
    );
  }
);
