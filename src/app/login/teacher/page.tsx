"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  AlertCircle,
  ArrowLeft,
  BadgeCheck,
  Eye,
  EyeOff,
  KeyRound,
  Lock,
  Phone,
  ShieldCheck,
  UserCheck,
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

type TeacherTab = "SIGN_IN" | "ACTIVATE";
type VerifyMethod = "MOBILE_LAST4" | "ACTIVATION_CODE";

interface TeacherAuthResponse {
  ok?: boolean;
  requiresActivation?: boolean;
  mustChangePassword?: boolean;
  requiresTurnstile?: boolean;
  alreadyActivated?: boolean;
  redirectTo?: string;
  error?: string;
  errorHi?: string;
}

export default function TeacherLoginPage() {
  const { t, lang } = useLanguage();

  const [tab, setTab] = useState<TeacherTab>("SIGN_IN");
  const [schoolUdise, setSchoolUdise] = useState("");
  const [teacherCode, setTeacherCode] = useState("");

  // Sign-In state
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  // First-Time Activation state
  const [verifyMethod, setVerifyMethod] = useState<VerifyMethod>("MOBILE_LAST4");
  const [verificationValue, setVerificationValue] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [activationNotice, setActivationNotice] = useState<string | null>(null);

  // Forced password change modal (after signing in with admin reset code)
  const [forceChangeOpen, setForceChangeOpen] = useState(false);
  const [forcedPassword, setForcedPassword] = useState("");
  const [forcedConfirm, setForcedConfirm] = useState("");
  const [forcedSubmitting, setForcedSubmitting] = useState(false);
  const [forcedError, setForcedError] = useState<string | null>(null);
  const [postLoginTarget, setPostLoginTarget] = useState("/teacher");

  // Adaptive Turnstile
  const [showTurnstile, setShowTurnstile] = useState(false);
  const [turnstileToken, setTurnstileToken] = useState("");
  const [turnstileResetKey, setTurnstileResetKey] = useState(0);

  const [submitting, setSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSignIn = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);
    setActivationNotice(null);

    if (!/^\d{11}$/.test(schoolUdise)) {
      setErrorMessage(
        t(
          "कृपया अपना विद्यालय चुनें या सही 11-अंकीय UDISE कोड दर्ज करें।",
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
      const res = await fetch("/api/auth/teacher", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          schoolUdise,
          teacherCode: teacherCode.trim(),
          password,
          ...(showTurnstile && turnstileToken ? { turnstileToken } : {}),
        }),
      });

      const data = (await res.json()) as TeacherAuthResponse;

      if (data.requiresTurnstile) {
        setShowTurnstile(true);
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
      }

      if (data.requiresActivation) {
        setTab("ACTIVATE");
        setActivationNotice(
          lang === "EN"
            ? data.error || "Please complete first-time account activation below."
            : data.errorHi ||
                "कृपया नीचे पहली बार अपना खाता सक्रिय (Activate) करें।"
        );
        return;
      }

      if (!res.ok || !data.ok) {
        setErrorMessage(
          lang === "EN"
            ? data.error || "Invalid Teacher ID or Password."
            : data.errorHi || data.error || "शिक्षक ID या पासवर्ड सही नहीं है।"
        );
        return;
      }

      clearUserScopedBrowserState();
      broadcastAuthEvent("USER_SWITCH", "/login/teacher");

      if (data.mustChangePassword) {
        setPostLoginTarget(data.redirectTo || "/teacher");
        setForceChangeOpen(true);
        return;
      }

      window.location.assign(data.redirectTo || "/teacher");
    } catch {
      setErrorMessage(
        t(
          "नेटवर्क त्रुटि। कृपया पुनः प्रयास करें।",
          "Network error. Please try again."
        )
      );
    } finally {
      setSubmitting(false);
    }
  };

  const handleActivate = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);

    if (!/^\d{11}$/.test(schoolUdise)) {
      setErrorMessage(
        t(
          "कृपया अपना विद्यालय चुनें या 11-अंकीय UDISE दर्ज करें।",
          "Please select your school or enter a valid 11-digit UDISE code."
        )
      );
      return;
    }

    if (teacherCode.trim().length < 4) {
      setErrorMessage(
        t("कृपया अपनी शिक्षक ID दर्ज करें।", "Please enter your Teacher ID.")
      );
      return;
    }

    if (
      verifyMethod === "MOBILE_LAST4" &&
      !/^\d{4}$/.test(verificationValue.trim())
    ) {
      setErrorMessage(
        t(
          "कृपया पंजीकृत मोबाइल नंबर के अंतिम 4 अंक लिखें।",
          "Please enter the exact last 4 digits of your registered mobile number."
        )
      );
      return;
    }

    if (
      verifyMethod === "ACTIVATION_CODE" &&
      verificationValue.trim().length < 6
    ) {
      setErrorMessage(
        t(
          "कृपया विद्यालय से प्राप्त 6-अंकीय एक्टिवेशन कोड दर्ज करें।",
          "Please enter the 6-digit activation code provided by your school."
        )
      );
      return;
    }

    if (newPassword.length < 8) {
      setErrorMessage(
        t(
          "नया पासवर्ड कम से कम 8 अक्षरों का होना चाहिए।",
          "New password must be at least 8 characters long."
        )
      );
      return;
    }

    if (newPassword !== confirmPassword) {
      setErrorMessage(
        t(
          "दोनों पासवर्ड मेल नहीं खा रहे हैं।",
          "Both password fields must match."
        )
      );
      return;
    }

    if (newPassword.trim().toLowerCase() === teacherCode.trim().toLowerCase()) {
      setErrorMessage(
        t(
          "नया पासवर्ड आपकी शिक्षक ID जैसा नहीं हो सकता।",
          "Your new password cannot be identical to your Teacher ID."
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
          portal: "teacher",
          ...(showTurnstile && turnstileToken ? { turnstileToken } : {}),
        }),
      });

      const data = (await res.json()) as TeacherAuthResponse;

      if (data.requiresTurnstile) {
        setShowTurnstile(true);
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
      }

      if (data.alreadyActivated) {
        setTab("SIGN_IN");
        setErrorMessage(
          lang === "EN"
            ? data.error || "Account is already activated. Please sign in."
            : data.errorHi ||
                "खाता पहले ही सक्रिय है। कृपया पासवर्ड से लॉगिन करें।"
        );
        return;
      }

      if (!res.ok || !data.ok) {
        setErrorMessage(
          lang === "EN"
            ? data.error || "Account activation failed."
            : data.errorHi || data.error || "खाता सक्रिय नहीं हो सका।"
        );
        return;
      }

      clearUserScopedBrowserState();
      broadcastAuthEvent("USER_SWITCH", "/login/teacher");
      window.location.assign(data.redirectTo || "/teacher");
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

    if (forcedPassword.length < 8) {
      setForcedError(
        t(
          "नया पासवर्ड कम से कम 8 अक्षरों का होना चाहिए।",
          "New password must be at least 8 characters long."
        )
      );
      return;
    }

    if (forcedPassword !== forcedConfirm) {
      setForcedError(
        t("दोनों पासवर्ड मेल नहीं खा रहे हैं।", "Passwords do not match.")
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
        redirectTo?: string;
      };

      if (!res.ok || !data.ok) {
        setForcedError(
          lang === "EN"
            ? data.error || "Could not update password."
            : data.errorHi || data.error || "पासवर्ड अपडेट नहीं हो सका।"
        );
        return;
      }

      window.location.assign(data.redirectTo || postLoginTarget);
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
            <div className="inline-flex h-11 w-11 shrink-0 items-center justify-center rounded-paper bg-indigo-soft text-indigo-ink border border-indigo-academic/20">
              <UserCheck className="h-6 w-6" aria-hidden="true" />
            </div>
            <div>
              <h1 className="text-xl font-extrabold text-ink leading-snug">
                {t("शिक्षक लॉगिन", "Teacher Login")}
              </h1>
              <p className="mt-1 text-sm text-ink-secondary leading-relaxed">
                {t(
                  "पाठ योजना, अध्ययन सामग्री, शंका समाधान और कक्षा परीक्षा के लिए प्रवेश करें।",
                  "Sign in to access lesson plans, classroom materials, open doubts, and assessments."
                )}
              </p>
            </div>
          </div>

          <div className="mt-5">
            <Tabs<TeacherTab>
              variant="pills"
              value={tab}
              onChange={(next) => {
                setTab(next);
                setErrorMessage(null);
                setActivationNotice(null);
              }}
              ariaLabel={t("शिक्षक लॉगिन प्रकार", "Teacher sign-in mode")}
              className="w-full"
              items={[
                {
                  id: "SIGN_IN",
                  label: t("पासवर्ड से लॉगिन", "Sign In"),
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
                allowManualUdise
              />

              <Input
                label={t("शिक्षक ID (Teacher ID)", "Teacher ID")}
                value={teacherCode}
                onChange={(e) => setTeacherCode(e.target.value)}
                placeholder={t(
                  "अपनी 8 या 13-अंकीय शिक्षक ID दर्ज करें",
                  "Enter your 8- or 13-digit Teacher ID"
                )}
                leftIcon={<KeyRound className="h-4 w-4" />}
                autoComplete="username"
                required
              />

              <Input
                label={t("पासवर्ड या रीसेट कोड", "Password or Reset Code")}
                type={showPassword ? "text" : "password"}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder={t("अपना पासवर्ड दर्ज करें", "Enter your password")}
                hint={t(
                  "पहली बार लॉगिन कर रहे हैं? ऊपर 'पहली बार खाता सक्रिय करें' टैब चुनें।",
                  "Signing in for the first time? Use the 'First-Time Activation' tab above."
                )}
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

              {showTurnstile && (
                <TurnstileWidget
                  onVerify={setTurnstileToken}
                  resetKey={turnstileResetKey}
                />
              )}

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
                {t("शिक्षक पोर्टल में प्रवेश करें", "Sign In to Teacher Desk")}
              </Button>
            </form>
          ) : (
            <form onSubmit={handleActivate} className="mt-5 space-y-4" noValidate>
              <SchoolSearchSelect
                value={schoolUdise}
                onChange={(udise) => setSchoolUdise(udise)}
                allowManualUdise
              />

              <Input
                label={t("शिक्षक ID (Teacher ID)", "Teacher ID")}
                value={teacherCode}
                onChange={(e) => setTeacherCode(e.target.value)}
                placeholder={t(
                  "अपनी शिक्षक ID दर्ज करें",
                  "Enter your Teacher ID"
                )}
                leftIcon={<KeyRound className="h-4 w-4" />}
                required
              />

              <div className="space-y-2.5">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <span className="text-xs font-semibold uppercase tracking-wider text-ink-muted">
                    {t("सत्यापन का माध्यम", "Verification Method")}
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
                      setErrorMessage(null);
                    }}
                    className="text-xs font-semibold text-indigo-ink hover:underline"
                  >
                    {verifyMethod === "MOBILE_LAST4"
                      ? t(
                          "6-अंकीय एक्टिवेशन कोड का उपयोग करें",
                          "Use 6-digit Activation Code instead"
                        )
                      : t(
                          "मोबाइल के अंतिम 4 अंकों का उपयोग करें",
                          "Use last 4 digits of Mobile instead"
                        )}
                  </button>
                </div>

                {verifyMethod === "MOBILE_LAST4" ? (
                  <Input
                    label={t(
                      "पंजीकृत मोबाइल नंबर के अंतिम 4 अंक",
                      "Last 4 Digits of Registered Mobile Number"
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
                    label={t(
                      "6-अंकीय एक्टिवेशन कोड",
                      "6-Digit School Activation Code"
                    )}
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
                  label={t("नया पासवर्ड बनाएं", "Create New Password")}
                  type="password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  placeholder={t("कम से कम 8 अक्षर", "Minimum 8 characters")}
                  leftIcon={<Lock className="h-4 w-4" />}
                  autoComplete="new-password"
                  required
                />
                <Input
                  label={t("पासवर्ड दोहराएं", "Confirm Password")}
                  type="password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  placeholder={t("वही पासवर्ड लिखें", "Re-enter password")}
                  leftIcon={<Lock className="h-4 w-4" />}
                  autoComplete="new-password"
                  required
                />
              </div>

              {showTurnstile && (
                <TurnstileWidget
                  onVerify={setTurnstileToken}
                  resetKey={turnstileResetKey}
                />
              )}

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
                {t(
                  "खाता सक्रिय करें और लॉगिन करें",
                  "Activate Account & Sign In"
                )}
              </Button>
            </form>
          )}

          <div className="mt-6 pt-4 border-t border-hairline flex flex-wrap items-center justify-between gap-2 text-xs text-ink-muted">
            <Link
              href="/login/student"
              className="font-semibold text-ink-secondary hover:text-ink"
            >
              {t("छात्र लॉगिन", "Student Login")}
            </Link>
            <Link
              href="/login/school"
              className="font-semibold text-indigo-ink hover:underline"
            >
              {t("विद्यालय व्यवस्थापक लॉगिन", "School Admin Login")}
            </Link>
          </div>
        </Card>
      </main>

      {/* Forced Password Change Modal after admin-issued reset code login */}
      <Modal
        open={forceChangeOpen}
        onClose={() => {}}
        closeOnBackdrop={false}
        showCloseButton={false}
        title={t("कृपया अपना नया पासवर्ड सेट करें", "Set Your New Personal Password")}
        description={t(
          "सुरक्षा के लिए आगे बढ़ने से पहले अपना नया व्यक्तिगत पासवर्ड चुनें।",
          "For account security, please choose a new personal password before entering your workspace."
        )}
      >
        <form onSubmit={handleForcedPasswordSubmit} className="space-y-4">
          <Input
            label={t("नया पासवर्ड (कम से कम 8 अक्षर)", "New Password (min 8 chars)")}
            type="password"
            value={forcedPassword}
            onChange={(e) => setForcedPassword(e.target.value)}
            leftIcon={<Lock className="h-4 w-4" />}
            autoComplete="new-password"
            required
          />
          <Input
            label={t("नया पासवर्ड दोहराएं", "Confirm New Password")}
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
            {t("पासवर्ड सुरक्षित करें और आगे बढ़ें", "Save Password & Continue")}
          </Button>
        </form>
      </Modal>
    </div>
  );
}
