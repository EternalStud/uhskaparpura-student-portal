import React from "react";
import { cn } from "./cn";

export type BadgeVariant =
  | "neutral"
  | "indigo"
  | "amber"
  | "emerald"
  | "crimson"
  | "outline";

export interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?: BadgeVariant;
  icon?: React.ReactNode;
}

const variantClasses: Record<BadgeVariant, string> = {
  neutral: "bg-surface-subtle text-ink-secondary border border-hairline",
  indigo: "bg-indigo-soft text-indigo-ink border border-indigo-academic/20",
  amber: "bg-amber-soft text-amber-ink border border-amber-warm/25",
  emerald: "bg-emerald-soft text-emerald-ink border border-emerald-mastery/25",
  crimson: "bg-crimson-soft text-crimson-ink border border-crimson-alert/25",
  outline: "bg-transparent text-ink-secondary border border-hairline-strong",
};

export function Badge({
  className,
  variant = "neutral",
  icon,
  children,
  ...props
}: BadgeProps) {
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-xs font-semibold tracking-wide leading-5 whitespace-nowrap",
        variantClasses[variant],
        className
      )}
      {...props}
    >
      {icon && <span className="shrink-0 inline-flex">{icon}</span>}
      {children}
    </span>
  );
}
