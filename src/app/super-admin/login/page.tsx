"use client";

import React, { useState } from "react";
import {
  AlertCircle,
  Eye,
  EyeOff,
  KeyRound,
  Lock,
  Mail,
  Shield,
} from "lucide-react";
import {
  broadcastAuthEvent,
  clearUserScopedBrowserState,
} from "@/components/providers/SessionSyncListener";
import { BrandMark } from "@/components/ui/BrandMark";
import { ThemeToggle } from "@/components/ui/LanguageToggle";
import { Card } from "@/components/ui/Card";
import { Input } from "@/components/ui/Input";
import { Button } from "@/components/ui/Button";
import { TurnstileWidget } from "@/components/auth/TurnstileWidget";

interface ExecutiveAuthResponse {
  ok?: boolean;
  requiresTotp?: boolean;
  redirectTo?: string;
  error?: string;
  message?: string;
}

export default function SuperAdminLoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  const [requiresTotp, setRequiresTotp] = useState(false);
  const [totpCode, setTotpCode] = useState("");

  const [turnstileToken, setTurnstileToken] = useState("");
  const [turnstileResetKey, setTurnstileResetKey] = useState(0);

  const [submitting, setSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);

    if (!email.trim() || !password) {
      setErrorMessage("Please enter both email and password.");
      return;
    }

    if (requiresTotp && totpCode.trim().length < 6) {
      setErrorMessage("Please enter your 6-digit authenticator code or recovery code.");
      return;
    }

    setSubmitting(true);
    try {
      const res = await fetch("/api/auth/super-admin", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          email: email.trim().toLowerCase(),
          password,
          turnstileToken,
          ...(requiresTotp && totpCode.trim()
            ? { totpCode: totpCode.trim() }
            : {}),
        }),
      });

      const data = (await res.json()) as ExecutiveAuthResponse;

      if (data.requiresTotp && !data.ok) {
        setRequiresTotp(true);
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
        if (data.error) {
          setErrorMessage(data.error);
        }
        return;
      }

      if (!res.ok || !data.ok) {
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
        setErrorMessage(data.error || "Sign-in failed. Check your credentials.");
        return;
      }

      clearUserScopedBrowserState();
      broadcastAuthEvent("USER_SWITCH", "/super-admin/login");
      window.location.assign(data.redirectTo || "/super-admin");
    } catch {
      setErrorMessage("Network error. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="min-h-dvh flex flex-col bg-canvas text-ink">
      <header className="border-b border-hairline bg-surface">
        <div className="mx-auto flex h-16 max-w-5xl items-center justify-between gap-3 px-4 sm:px-6">
          <BrandMark size="sm" showTagline={false} />
          <ThemeToggle />
        </div>
      </header>

      <main className="mx-auto flex w-full max-w-md flex-1 flex-col justify-center px-4 py-10 sm:px-6">
        <Card variant="default" padding="lg">
          <div className="flex items-start gap-3.5 pb-5 border-b border-hairline">
            <div className="inline-flex h-11 w-11 shrink-0 items-center justify-center rounded-paper bg-surface-subtle text-indigo-ink border border-hairline-strong">
              <Shield className="h-5 w-5" aria-hidden="true" />
            </div>
            <div>
              <h1 className="text-lg font-extrabold text-ink leading-snug">
                Central Editorial & Governance Sign In
              </h1>
              <p className="mt-1 text-xs text-ink-secondary leading-relaxed">
                Restricted administrative access. All sessions are time-limited and audited.
              </p>
            </div>
          </div>

          <form onSubmit={handleSubmit} className="mt-5 space-y-4" noValidate>
            <Input
              label="Administrator Email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@domain.org"
              leftIcon={<Mail className="h-4 w-4" />}
              autoComplete="username"
              required
            />

            <Input
              label="Password"
              type={showPassword ? "text" : "password"}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Enter password"
              leftIcon={<Lock className="h-4 w-4" />}
              rightElement={
                <button
                  type="button"
                  onClick={() => setShowPassword((prev) => !prev)}
                  aria-label={showPassword ? "Hide password" : "Show password"}
                  className="inline-flex h-8 w-8 items-center justify-center rounded-md text-ink-muted hover:text-ink"
                >
                  {showPassword ? (
                    <EyeOff className="h-4 w-4" />
                  ) : (
                    <Eye className="h-4 w-4" />
                  )}
                </button>
              }
              autoComplete="current-password"
              required
            />

            {requiresTotp && (
              <div className="rounded-paper border border-indigo-academic/25 bg-indigo-soft p-4 space-y-2.5">
                <p className="text-xs font-semibold text-indigo-ink">
                  Two-factor verification required. Enter the 6-digit code from your authenticator app or a recovery code.
                </p>
                <Input
                  label="Authenticator / Recovery Code"
                  value={totpCode}
                  onChange={(e) => setTotpCode(e.target.value)}
                  placeholder="123456"
                  leftIcon={<KeyRound className="h-4 w-4" />}
                  autoComplete="one-time-code"
                  required
                />
              </div>
            )}

            <TurnstileWidget
              onVerify={setTurnstileToken}
              resetKey={turnstileResetKey}
            />

            {errorMessage && (
              <div
                role="alert"
                className="flex items-start gap-2.5 rounded-lg border border-crimson-alert/25 bg-crimson-soft px-3.5 py-3 text-sm text-crimson-ink"
              >
                <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" aria-hidden="true" />
                <span>{errorMessage}</span>
              </div>
            )}

            <Button
              type="submit"
              variant="primary"
              size="lg"
              fullWidth
              loading={submitting}
            >
              {requiresTotp ? "Verify & Sign In" : "Continue"}
            </Button>
          </form>
        </Card>
      </main>
    </div>
  );
}
