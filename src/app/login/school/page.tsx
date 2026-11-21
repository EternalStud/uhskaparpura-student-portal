"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  AlertCircle,
  ArrowLeft,
  BadgeCheck,
  Building2,
  Eye,
  EyeOff,
  KeyRound,
  Lock,
  Phone,
  ShieldCheck,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import {
  broadcastAuthEvent,
  clearUserScopedBrowserState,
} from "@/components/providers/SessionSyncListener";
import { BrandMark } from "@/components/ui/BrandMark";
import { LanguageToggle, ThemeToggle } from "@/components/ui/LanguageToggle";
import { Card } from "@/components/ui/Card";
import { Tabs } from "@/components/ui/Tabs";
import { Input } from "@/components/ui/Input";
import { Button } from "@/components/ui/Button";
import { Modal } from "@/components/ui/Modal";
import { SchoolSearchSelect } from "@/components/auth/SchoolSearchSelect";
import { TurnstileWidget } from "@/components/auth/TurnstileWidget";

type SchoolTab = "SIGN_IN" | "ACTIVATE";
type VerifyMethod = "MOBILE_LAST4" | "ACTIVATION_CODE";

interface SchoolAdminAuthResponse {
  ok?: boolean;
  requiresActivation?: boolean;
  mustChangePassword?: boolean;
  alreadyActivated?: boolean;
  redirectTo?: string;
  error?: string;
  errorHi?: string;
}

export default function SchoolLoginPage() {
  const { t, lang } = useLanguage();

  const [tab, setTab] = useState<SchoolTab>("SIGN_IN");
  const [schoolUdise, setSchoolUdise] = useState("");
  const [teacherCode, setTeacherCode] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  // First-time activation fields
  const [verifyMethod, setVerifyMethod] = useState<VerifyMethod>("MOBILE_LAST4");
  const [verificationValue, setVerificationValue] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [activationNotice, setActivationNotice] = useState<string | null>(null);

  // Always-on Turnstile for School Admin login & activation
  const [turnstileToken, setTurnstileToken] = useState("");
  const [turnstileResetKey, setTurnstileResetKey] = useState(0);

  // Forced password change modal
  const [forceChangeOpen, setForceChangeOpen] = useState(false);
  const [forcedPassword, setForcedPassword] = useState("");
  const [forcedConfirm, setForcedConfirm] = useState("");
  const [forcedSubmitting, setForcedSubmitting] = useState(false);
  const [forcedError, setForcedError] = useState<string | null>(null);

  const [submitting, setSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSignIn = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);
    setActivationNotice(null);

    if (!/^\d{11}$/.test(schoolUdise)) {
      setErrorMessage(
        t(
          "कृपया अपना विद्यालय चुनें या 11-अंकीय UDISE कोड दर्ज करें।",
          "Please select your school or enter a valid 11-digit UDISE code."
        )
      );
      return;
    }

    if (teacherCode.trim().length < 4 || !password) {
      setErrorMessage(
        t(
          "कृपया अपनी शिक्षक ID और पासवर्ड दर्ज करें।",
          "Please enter your Teacher ID and Password."
        )
      );
      return;
    }

    setSubmitting(true);
    try {
      const res = await fetch("/api/auth/school-admin", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          schoolUdise,
          teacherCode: teacherCode.trim(),
          password,
          turnstileToken,
        }),
      });

      const data = (await res.json()) as SchoolAdminAuthResponse;

      if (data.requiresActivation) {
        setTab("ACTIVATE");
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
        setActivationNotice(
          lang === "EN"
            ? data.error || "Please complete first-time School Admin activation below."
            : data.errorHi ||
                "कृपया नीचे पहली बार विद्यालय व्यवस्थापक खाता सक्रिय करें।"
        );
        return;
      }

      if (!res.ok || !data.ok) {
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
        setErrorMessage(
          lang === "EN"
            ? data.error || "Invalid School Admin credentials."
            : data.errorHi ||
                data.error ||
                "विद्यालय व्यवस्थापक का विवरण सही नहीं है।"
        );
        return;
      }

      clearUserScopedBrowserState();
      broadcastAuthEvent("USER_SWITCH", "/login/school");

      if (data.mustChangePassword) {
        setForceChangeOpen(true);
        return;
      }

      window.location.assign(data.redirectTo || "/school");
    } catch {
      setErrorMessage(
        t("नेटवर्क त्रुटि। कृपया पुनः प्रयास करें।", "Network error. Please try again.")
      );
    } finally {
      setSubmitting(false);
    }
  };

  const handleActivate = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);

    if (!/^\d{11}$/.test(schoolUdise) || teacherCode.trim().length < 4) {
      setErrorMessage(
        t(
          "कृपया विद्यालय UDISE और शिक्षक ID सही से दर्ज करें।",
          "Please enter a valid School UDISE and Teacher ID."
        )
      );
      return;
    }

    if (newPassword.length < 8 || newPassword !== confirmPassword) {
      setErrorMessage(
        t(
          "नया पासवर्ड कम से कम 8 अक्षरों का होना चाहिए और दोनों बार समान होना चाहिए।",
          "New password must be at least 8 characters and match confirmation."
        )
      );
      return;
    }

    setSubmitting(true);
    try {
      const res = await fetch("/api/auth/activate", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          schoolUdise,
          teacherCode: teacherCode.trim(),
          verificationMethod: verifyMethod,
          verificationValue: verificationValue.trim(),
          newPassword,
          portal: "school_admin",
          turnstileToken,
        }),
      });

      const data = (await res.json()) as SchoolAdminAuthResponse;

      if (data.alreadyActivated) {
        setTab("SIGN_IN");
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
        setErrorMessage(
          lang === "EN"
            ? data.error || "Account already activated. Please sign in."
            : data.errorHi ||
                "खाता पहले ही सक्रिय है। कृपया अपने पासवर्ड से लॉगिन करें।"
        );
        return;
      }

      if (!res.ok || !data.ok) {
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
        setErrorMessage(
          lang === "EN"
            ? data.error || "Activation failed."
            : data.errorHi || data.error || "खाता सक्रिय नहीं हो सका।"
        );
        return;
      }

      clearUserScopedBrowserState();
      broadcastAuthEvent("USER_SWITCH", "/login/school");
      window.location.assign(data.redirectTo || "/school");
    } catch {
      setErrorMessage(
        t("नेटवर्क त्रुटि। कृपया पुनः प्रयास करें।", "Network error. Please try again.")
      );
    } finally {
      setSubmitting(false);
    }
  };

  const handleForcedPasswordSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setForcedError(null);

    if (forcedPassword.length < 8 || forcedPassword !== forcedConfirm) {
      setForcedError(
        t(
          "नया पासवर्ड कम से कम 8 अक्षरों का होना चाहिए और दोनों बार समान होना चाहिए।",
          "New password must be at least 8 characters and match confirmation."
        )
      );
      return;
    }

    setForcedSubmitting(true);
    try {
      const res = await fetch("/api/auth/change-password", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          currentPassword: password,
          newPassword: forcedPassword,
        }),
      });
      const data = (await res.json()) as {
        ok?: boolean;
        error?: string;
        errorHi?: string;
      };

      if (!res.ok || !data.ok) {
        setForcedError(
          lang === "EN"
            ? data.error || "Could not update password."
            : data.errorHi || data.error || "पासवर्ड अपडेट नहीं हो सका।"
        );
        return;
      }

      window.location.assign("/school");
    } catch {
      setForcedError(
        t("नेटवर्क त्रुटि। कृपया पुनः प्रयास करें।", "Network error. Please try again.")
      );
    } finally {
      setForcedSubmitting(false);
    }
  };

  return (
    <div className="min-h-dvh flex flex-col bg-canvas text-ink">
      <header className="border-b border-hairline bg-surface">
        <div className="mx-auto flex h-16 max-w-5xl items-center justify-between gap-3 px-4 sm:px-6">
          <Link href="/" className="min-w-0">
            <BrandMark size="sm" showTagline={false} />
          </Link>
          <div className="flex items-center gap-2">
            <LanguageToggle compact className="sm:hidden" />
            <LanguageToggle className="hidden sm:inline-flex" />
            <ThemeToggle />
          </div>
        </div>
      </header>

      <main className="mx-auto flex w-full max-w-xl flex-1 flex-col justify-center px-4 py-8 sm:px-6 sm:py-12">
        <div className="mb-4">
          <Link
            href="/"
            className="inline-flex items-center gap-1.5 text-xs font-semibold text-ink-secondary hover:text-ink transition-colors"
          >
            <ArrowLeft className="h-3.5 w-3.5" aria-hidden="true" />
            <span>{t("मुख्य पृष्ठ पर वापस जाएं", "Back to Home")}</span>
          </Link>
        </div>

        <Card variant="default" padding="lg">
          <div className="flex items-start gap-3.5 pb-5 border-b border-hairline">
            <div className="inline-flex h-11 w-11 shrink-0 items-center justify-center rounded-paper bg-amber-soft text-amber-ink border border-amber-warm/25">
              <Building2 className="h-6 w-6" aria-hidden="true" />
            </div>
            <div>
              <h1 className="text-xl font-extrabold text-ink leading-snug">
                {t("विद्यालय लॉगिन", "School Admin Login")}
              </h1>
              <p className="mt-1 text-sm text-ink-secondary leading-relaxed">
                {t(
                  "अपने विद्यालय के छात्र-शिक्षक रिकॉर्ड, नामांकन और व्यवस्था प्रबंधन के लिए लॉगिन करें।",
                  "Sign in with authorized School Admin credentials to manage your school's student and teacher roster."
                )}
              </p>
            </div>
          </div>

          <div className="mt-5">
            <Tabs<SchoolTab>
              variant="pills"
              value={tab}
              onChange={(next) => {
                setTab(next);
                setErrorMessage(null);
                setActivationNotice(null);
              }}
              ariaLabel={t("विद्यालय लॉगिन विकल्प", "School login mode")}
              className="w-full"
              items={[
                {
                  id: "SIGN_IN",
                  label: t("लॉगिन करें", "Sign In"),
                  icon: <Lock className="h-4 w-4" aria-hidden="true" />,
                },
                {
                  id: "ACTIVATE",
                  label: t("पहली बार खाता सक्रिय करें", "First-Time Activation"),
                  icon: <BadgeCheck className="h-4 w-4" aria-hidden="true" />,
                },
              ]}
            />
          </div>

          {activationNotice && tab === "ACTIVATE" && (
            <div className="mt-4 flex items-start gap-2.5 rounded-lg border border-amber-warm/35 bg-surface-warm px-3.5 py-3 text-xs sm:text-sm text-amber-ink">
              <ShieldCheck className="h-4 w-4 shrink-0 mt-0.5" aria-hidden="true" />
              <span>{activationNotice}</span>
            </div>
          )}

          {tab === "SIGN_IN" ? (
            <form onSubmit={handleSignIn} className="mt-5 space-y-4" noValidate>
              <SchoolSearchSelect
                value={schoolUdise}
                onChange={(udise) => setSchoolUdise(udise)}
                label={t("विद्यालय चुनें या 11-अंकीय UDISE लिखें", "School / 11-Digit UDISE Code")}
                allowManualUdise
              />

              <Input
                label={t("व्यवस्थापक शिक्षक ID (Teacher ID)", "Authorized Teacher ID")}
                value={teacherCode}
                onChange={(e) => setTeacherCode(e.target.value)}
                placeholder={t("अपनी शिक्षक ID लिखें", "Enter your Teacher ID")}
                leftIcon={<KeyRound className="h-4 w-4" />}
                autoComplete="username"
                required
              />

              <Input
                label={t("पासवर्ड", "Password")}
                type={showPassword ? "text" : "password"}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder={t("अपना पासवर्ड दर्ज करें", "Enter your password")}
                leftIcon={<Lock className="h-4 w-4" />}
                rightElement={
                  <button
                    type="button"
                    onClick={() => setShowPassword((prev) => !prev)}
                    aria-label={
                      showPassword
                        ? t("पासवर्ड छिपाएं", "Hide password")
                        : t("पासवर्ड दिखाएं", "Show password")
                    }
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
                {t("विद्यालय प्रबंधन पैनल खोलें", "Open School Administration")}
              </Button>
            </form>
          ) : (
            <form onSubmit={handleActivate} className="mt-5 space-y-4" noValidate>
              <SchoolSearchSelect
                value={schoolUdise}
                onChange={(udise) => setSchoolUdise(udise)}
                label={t("विद्यालय चुनें या 11-अंकीय UDISE लिखें", "School / 11-Digit UDISE Code")}
                allowManualUdise
              />

              <Input
                label={t("व्यवस्थापक शिक्षक ID (Teacher ID)", "Authorized Teacher ID")}
                value={teacherCode}
                onChange={(e) => setTeacherCode(e.target.value)}
                placeholder={t("अपनी शिक्षक ID दर्ज करें", "Enter your Teacher ID")}
                leftIcon={<KeyRound className="h-4 w-4" />}
                required
              />

              <div className="space-y-2.5">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <span className="text-xs font-semibold uppercase tracking-wider text-ink-muted">
                    {t("पहचान सत्यापन", "Verification")}
                  </span>
                  <button
                    type="button"
                    onClick={() => {
                      setVerifyMethod((prev) =>
                        prev === "MOBILE_LAST4"
                          ? "ACTIVATION_CODE"
                          : "MOBILE_LAST4"
                      );
                      setVerificationValue("");
                    }}
                    className="text-xs font-semibold text-indigo-ink hover:underline"
                  >
                    {verifyMethod === "MOBILE_LAST4"
                      ? t("6-अंकीय एक्टिवेशन कोड से", "Use 6-digit Activation Code")
                      : t("मोबाइल के अंतिम 4 अंक से", "Use last 4 digits of Mobile")}
                  </button>
                </div>

                {verifyMethod === "MOBILE_LAST4" ? (
                  <Input
                    label={t(
                      "पंजीकृत मोबाइल नंबर के अंतिम 4 अंक",
                      "Last 4 Digits of Registered Mobile"
                    )}
                    value={verificationValue}
                    onChange={(e) =>
                      setVerificationValue(
                        e.target.value.replace(/\D/g, "").slice(0, 4)
                      )
                    }
                    placeholder="e.g. 4821"
                    leftIcon={<Phone className="h-4 w-4" />}
                    inputMode="numeric"
                    maxLength={4}
                    required
                  />
                ) : (
                  <Input
                    label={t("6-अंकीय एक्टिवेशन कोड", "6-Digit Activation Code")}
                    value={verificationValue}
                    onChange={(e) =>
                      setVerificationValue(
                        e.target.value.replace(/\D/g, "").slice(0, 6)
                      )
                    }
                    placeholder="e.g. 582910"
                    leftIcon={<ShieldCheck className="h-4 w-4" />}
                    inputMode="numeric"
                    maxLength={6}
                    required
                  />
                )}
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
                <Input
                  label={t("नया पासवर्ड", "New Password")}
                  type="password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  placeholder={t("कम से कम 8 अक्षर", "Minimum 8 chars")}
                  leftIcon={<Lock className="h-4 w-4" />}
                  autoComplete="new-password"
                  required
                />
                <Input
                  label={t("पासवर्ड दोहराएं", "Confirm Password")}
                  type="password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  placeholder={t("पासवर्ड दोहराएं", "Confirm password")}
                  leftIcon={<Lock className="h-4 w-4" />}
                  autoComplete="new-password"
                  required
                />
              </div>

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
                variant="emerald"
                size="lg"
                fullWidth
                loading={submitting}
              >
                {t("सक्रिय करें और लॉगिन करें", "Activate & Sign In")}
              </Button>
            </form>
          )}

          <div className="mt-6 pt-4 border-t border-hairline flex flex-wrap items-center justify-between gap-2 text-xs text-ink-muted">
            <Link
              href="/login/teacher"
              className="font-semibold text-indigo-ink hover:underline"
            >
              {t("सामान्य शिक्षक लॉगिन", "Regular Teacher Login")}
            </Link>
            <Link
              href="/login/student"
              className="font-semibold text-ink-secondary hover:text-ink"
            >
              {t("छात्र लॉगिन", "Student Login")}
            </Link>
          </div>
        </Card>
      </main>

      <Modal
        open={forceChangeOpen}
        onClose={() => {}}
        closeOnBackdrop={false}
        showCloseButton={false}
        title={t("नया पासवर्ड सेट करें", "Set Your New Password")}
        description={t(
          "आगे बढ़ने से पहले कृपया अपना नया व्यक्तिगत पासवर्ड चुनें।",
          "Please set a strong personal password before opening School Administration."
        )}
      >
        <form onSubmit={handleForcedPasswordSubmit} className="space-y-4">
          <Input
            label={t("नया पासवर्ड", "New Password")}
            type="password"
            value={forcedPassword}
            onChange={(e) => setForcedPassword(e.target.value)}
            leftIcon={<Lock className="h-4 w-4" />}
            autoComplete="new-password"
            required
          />
          <Input
            label={t("पासवर्ड दोहराएं", "Confirm Password")}
            type="password"
            value={forcedConfirm}
            onChange={(e) => setForcedConfirm(e.target.value)}
            leftIcon={<Lock className="h-4 w-4" />}
            autoComplete="new-password"
            required
          />
          {forcedError && (
            <p role="alert" className="text-xs font-medium text-crimson-ink">
              {forcedError}
            </p>
          )}
          <Button
            type="submit"
            variant="primary"
            size="lg"
            fullWidth
            loading={forcedSubmitting}
          >
            {t("सुरक्षित करें और आगे बढ़ें", "Save & Continue")}
          </Button>
        </form>
      </Modal>
    </div>
  );
}
