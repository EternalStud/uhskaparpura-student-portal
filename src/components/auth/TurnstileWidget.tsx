"use client";

import React, { useEffect, useRef, useState } from "react";
import { ShieldCheck } from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { useTheme } from "@/components/providers/ThemeProvider";
import { cn } from "@/components/ui/cn";

declare global {
  interface Window {
    turnstile?: {
      render: (
        container: HTMLElement,
        options: {
          sitekey: string;
          theme?: "light" | "dark" | "auto";
          callback?: (token: string) => void;
          "expired-callback"?: () => void;
          "error-callback"?: () => void;
        }
      ) => string;
      reset: (widgetId?: string) => void;
      remove: (widgetId?: string) => void;
    };
  }
}

const TURNSTILE_SCRIPT_ID = "cf-turnstile-script";
const TURNSTILE_SCRIPT_SRC =
  "https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit";

let scriptPromise: Promise<void> | null = null;

function ensureTurnstileScript(): Promise<void> {
  if (typeof window === "undefined") return Promise.resolve();
  if (window.turnstile) return Promise.resolve();
  if (scriptPromise) return scriptPromise;

  scriptPromise = new Promise<void>((resolve, reject) => {
    const existing = document.getElementById(
      TURNSTILE_SCRIPT_ID
    ) as HTMLScriptElement | null;
    if (existing) {
      existing.addEventListener("load", () => resolve(), { once: true });
      existing.addEventListener(
        "error",
        () => reject(new Error("Turnstile script failed to load")),
        { once: true }
      );
      return;
    }

    const script = document.createElement("script");
    script.id = TURNSTILE_SCRIPT_ID;
    script.src = TURNSTILE_SCRIPT_SRC;
    script.async = true;
    script.defer = true;
    script.onload = () => resolve();
    script.onerror = () => reject(new Error("Turnstile script failed to load"));
    document.head.appendChild(script);
  });

  return scriptPromise;
}

export interface TurnstileWidgetProps {
  onVerify: (token: string) => void;
  onExpire?: () => void;
  onError?: () => void;
  resetKey?: number;
  className?: string;
}

export function TurnstileWidget({
  onVerify,
  onExpire,
  onError,
  resetKey = 0,
  className,
}: TurnstileWidgetProps) {
  const siteKey = (process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY || "").trim();
  const isProd = process.env.NODE_ENV === "production";
  const { t } = useLanguage();
  const { isDark } = useTheme();

  const containerRef = useRef<HTMLDivElement | null>(null);
  const widgetIdRef = useRef<string | null>(null);
  const callbacksRef = useRef({ onVerify, onExpire, onError });
  callbacksRef.current = { onVerify, onExpire, onError };

  const [loadError, setLoadError] = useState(false);

  useEffect(() => {
    if (!siteKey) return;

    let cancelled = false;
    setLoadError(false);

    ensureTurnstileScript()
      .then(() => {
        if (cancelled || !containerRef.current || !window.turnstile) return;

        if (widgetIdRef.current) {
          try {
            window.turnstile.remove(widgetIdRef.current);
          } catch {
            // Ignore stale widget removal errors
          }
          widgetIdRef.current = null;
        }

        widgetIdRef.current = window.turnstile.render(containerRef.current, {
          sitekey: siteKey,
          theme: isDark ? "dark" : "light",
          callback: (token: string) => callbacksRef.current.onVerify(token),
          "expired-callback": () => {
            callbacksRef.current.onVerify("");
            callbacksRef.current.onExpire?.();
          },
          "error-callback": () => {
            callbacksRef.current.onVerify("");
            callbacksRef.current.onError?.();
          },
        });
      })
      .catch(() => {
        if (!cancelled) {
          setLoadError(true);
          callbacksRef.current.onError?.();
        }
      });

    return () => {
      cancelled = true;
      if (widgetIdRef.current && window.turnstile) {
        try {
          window.turnstile.remove(widgetIdRef.current);
        } catch {
          // Ignore cleanup errors
        }
        widgetIdRef.current = null;
      }
    };
  }, [siteKey, isDark]);

  useEffect(() => {
    if (resetKey > 0 && widgetIdRef.current && window.turnstile) {
      try {
        window.turnstile.reset(widgetIdRef.current);
      } catch {
        // Ignore reset failures
      }
    }
  }, [resetKey]);

  if (!siteKey) {
    if (!isProd) {
      return (
        <div
          className={cn(
            "flex items-center gap-2.5 rounded-lg border border-hairline bg-surface-subtle px-3.5 py-2.5 text-xs text-ink-secondary",
            className
          )}
        >
          <ShieldCheck
            className="h-4 w-4 text-emerald-ink shrink-0"
            aria-hidden="true"
          />
          <span>
            {t(
              "सुरक्षा सत्यापन स्थानीय मोड में स्वतः तैयार है।",
              "Security verification is active in local mode."
            )}
          </span>
        </div>
      );
    }

    return (
      <div
        role="alert"
        className={cn(
          "rounded-lg border border-crimson-alert/25 bg-crimson-soft px-3.5 py-2.5 text-xs text-crimson-ink",
          className
        )}
      >
        {t(
          "सुरक्षा सत्यापन लोड नहीं हो सका। कृपया पेज रिफ्रेश करें।",
          "Security check is currently unavailable. Please refresh the page."
        )}
      </div>
    );
  }

  return (
    <div className={cn("flex flex-col gap-1.5", className)}>
      <div ref={containerRef} className="min-h-[65px]" />
      {loadError && (
        <p role="alert" className="text-xs font-medium text-crimson-ink">
          {t(
            "सुरक्षा जाँच लोड करने में दिक्कत आई। कृपया नेटवर्क जांचकर पुनः प्रयास करें।",
            "Could not load the security check. Please check your connection and try again."
          )}
        </p>
      )}
    </div>
  );
}
