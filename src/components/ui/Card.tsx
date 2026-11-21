import React from "react";
import { cn } from "./cn";

export type CardVariant = "default" | "interactive" | "subtle" | "warm" | "indigo";
export type CardPadding = "none" | "sm" | "md" | "lg";

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: CardVariant;
  padding?: CardPadding;
}

const variantClasses: Record<CardVariant, string> = {
  default: "bg-surface border border-hairline shadow-paper",
  interactive:
    "bg-surface border border-hairline shadow-paper transition-all duration-150 hover:shadow-paper-hover hover:border-hairline-strong",
  subtle: "bg-surface-subtle border border-hairline",
  warm: "bg-surface-warm border border-amber-warm/30",
  indigo: "bg-indigo-soft border border-indigo-academic/25",
};

const paddingClasses: Record<CardPadding, string> = {
  none: "",
  sm: "p-4",
  md: "p-5 sm:p-6",
  lg: "p-6 sm:p-8",
};

export const Card = React.forwardRef<HTMLDivElement, CardProps>(function Card(
  { className, variant = "default", padding = "md", ...props },
  ref
) {
  return (
    <div
      ref={ref}
      className={cn(
        "rounded-paper",
        variantClasses[variant],
        paddingClasses[padding],
        className
      )}
      {...props}
    />
  );
});

export function CardHeader({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn("flex flex-col gap-1.5 pb-4 border-b border-hairline", className)}
      {...props}
    />
  );
}

export function CardTitle({
  className,
  ...props
}: React.HTMLAttributes<HTMLHeadingElement>) {
  return (
    <h3
      className={cn(
        "text-lg font-bold tracking-tight text-ink leading-snug",
        className
      )}
      {...props}
    />
  );
}

export function CardDescription({
  className,
  ...props
}: React.HTMLAttributes<HTMLParagraphElement>) {
  return (
    <p
      className={cn("text-sm text-ink-secondary leading-relaxed", className)}
      {...props}
    />
  );
}

export function CardContent({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("pt-4", className)} {...props} />;
}

export function CardFooter({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        "flex flex-wrap items-center justify-between gap-3 pt-4 mt-4 border-t border-hairline",
        className
      )}
      {...props}
    />
  );
}
