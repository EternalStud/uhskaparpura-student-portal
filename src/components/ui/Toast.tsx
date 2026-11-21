"use client";

import React, {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useRef,
  useState,
} from "react";
import {
  AlertCircle,
  AlertTriangle,
  CheckCircle2,
  Info,
  X,
} from "lucide-react";
import { cn } from "./cn";

export type ToastVariant = "success" | "error" | "info" | "warning";

export interface ToastInput {
  title: string;
  description?: string;
  variant?: ToastVariant;
  durationMs?: number;
}

interface ToastItem extends ToastInput {
  id: string;
  variant: ToastVariant;
}

interface ToastContextValue {
  addToast: (input: ToastInput) => string;
  dismissToast: (id: string) => void;
  success: (title: string, description?: string) => string;
  error: (title: string, description?: string) => string;
  info: (title: string, description?: string) => string;
  warning: (title: string, description?: string) => string;
}

const ToastContext = createContext<ToastContextValue | null>(null);

const variantStyles: Record<
  ToastVariant,
  { border: string; iconColor: string; Icon: React.ComponentType<{ className?: string }> }
> = {
  success: {
    border: "border-l-emerald-mastery",
    iconColor: "text-emerald-ink",
    Icon: CheckCircle2,
  },
  error: {
    border: "border-l-crimson-alert",
    iconColor: "text-crimson-ink",
    Icon: AlertCircle,
  },
  warning: {
    border: "border-l-amber-warm",
    iconColor: "text-amber-ink",
    Icon: AlertTriangle,
  },
  info: {
    border: "border-l-indigo-academic",
    iconColor: "text-indigo-ink",
    Icon: Info,
  },
};

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [toasts, setToasts] = useState<ToastItem[]>([]);
  const timersRef = useRef<Map<string, ReturnType<typeof setTimeout>>>(new Map());

  const dismissToast = useCallback((id: string) => {
    const timer = timersRef.current.get(id);
    if (timer) {
      clearTimeout(timer);
      timersRef.current.delete(id);
    }
    setToasts((prev) => prev.filter((item) => item.id !== id));
  }, []);

  const addToast = useCallback(
    ({ title, description, variant = "info", durationMs = 4500 }: ToastInput) => {
      const id = `toast-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
      const entry: ToastItem = { id, title, description, variant, durationMs };

      setToasts((prev) => [...prev.slice(-3), entry]);

      if (durationMs > 0) {
        const timer = setTimeout(() => {
          dismissToast(id);
        }, durationMs);
        timersRef.current.set(id, timer);
      }

      return id;
    },
    [dismissToast]
  );

  const value = useMemo<ToastContextValue>(
    () => ({
      addToast,
      dismissToast,
      success: (title, description) =>
        addToast({ title, description, variant: "success" }),
      error: (title, description) =>
        addToast({ title, description, variant: "error", durationMs: 6000 }),
      info: (title, description) =>
        addToast({ title, description, variant: "info" }),
      warning: (title, description) =>
        addToast({ title, description, variant: "warning", durationMs: 5500 }),
    }),
    [addToast, dismissToast]
  );

  return (
    <ToastContext.Provider value={value}>
      {children}
      <div
        data-toast-container="true"
        aria-live="polite"
        aria-atomic="false"
        className="fixed bottom-4 right-4 left-4 sm:left-auto z-50 flex flex-col gap-2.5 sm:w-full sm:max-w-sm pointer-events-none no-print"
      >
        {toasts.map((item) => {
          const { border, iconColor, Icon } = variantStyles[item.variant];
          return (
            <div
              key={item.id}
              role={item.variant === "error" ? "alert" : "status"}
              className={cn(
                "pointer-events-auto flex items-start gap-3 rounded-paper bg-surface p-4",
                "border border-hairline border-l-4 shadow-modal",
                border
              )}
            >
              <Icon className={cn("h-5 w-5 shrink-0 mt-0.5", iconColor)} />
              <div className="min-w-0 flex-1">
                <p className="text-sm font-semibold text-ink leading-snug">
                  {item.title}
                </p>
                {item.description && (
                  <p className="mt-1 text-xs text-ink-secondary leading-relaxed">
                    {item.description}
                  </p>
                )}
              </div>
              <button
                type="button"
                onClick={() => dismissToast(item.id)}
                aria-label="Dismiss notification"
                className="inline-flex h-8 w-8 shrink-0 items-center justify-center rounded-md text-ink-muted hover:bg-surface-subtle hover:text-ink transition-colors"
              >
                <X className="h-4 w-4" aria-hidden="true" />
              </button>
            </div>
          );
        })}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast(): ToastContextValue {
  const ctx = useContext(ToastContext);
  if (!ctx) {
    throw new Error("useToast must be used within a ToastProvider");
  }
  return ctx;
}
