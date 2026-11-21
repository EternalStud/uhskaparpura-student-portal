"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  AlertCircle,
  ArrowLeft,
  Calendar,
  GraduationCap,
  Hash,
  KeyRound,
  Lock,
  User,
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
import { Select } from "@/components/ui/Select";
import { Button } from "@/components/ui/Button";
import { DobDropdownPicker } from "@/components/ui/DobDropdownPicker";
import { SchoolSearchSelect } from "@/components/auth/SchoolSearchSelect";
import { TurnstileWidget } from "@/components/auth/TurnstileWidget";

type LoginMode = "CODE" | "DETAILS";
type AuthMethod = "DOB" | "PIN";

interface StudentAuthResponse {
  ok?: boolean;
  redirectTo?: string;
  disambiguationRequired?: boolean;
  requiresTurnstile?: boolean;
  error?: string;
  errorHi?: string;
}

export default function StudentLoginPage() {
  const { t, lang } = useLanguage();

  const [mode, setMode] = useState<LoginMode>("CODE");
  const [authMethod, setAuthMethod] = useState<AuthMethod>("DOB");

  // Mode 1: Student Code
  const [studentCode, setStudentCode] = useState("");

  // Mode 2: School + Class + Roll No
  const [schoolUdise, setSchoolUdise] = useState("");
  const [classNum, setClassNum] = useState("");
  const [rollNo, setRollNo] = useState("");
  const [fatherName, setFatherName] = useState("");
  const [needsFatherConfirm, setNeedsFatherConfirm] = useState(false);

  // Shared verification credential
  const [dob, setDob] = useState("");
  const [pin, setPin] = useState("");

  // Adaptive anti-bot challenge (shown only if triggered)
  const [showTurnstile, setShowTurnstile] = useState(false);
  const [turnstileToken, setTurnstileToken] = useState("");
  const [turnstileResetKey, setTurnstileResetKey] = useState(0);

  const [submitting, setSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const classOptions = [
    { value: "9", label: t("कक्षा 9 (Class 9)", "Class 9") },
    { value: "10", label: t("कक्षा 10 (Class 10)", "Class 10") },
    { value: "11", label: t("कक्षा 11 (Class 11)", "Class 11") },
    { value: "12", label: t("कक्षा 12 (Class 12)", "Class 12") },
  ];

  const handleModeChange = (nextMode: LoginMode) => {
    setMode(nextMode);
    setErrorMessage(null);
    setNeedsFatherConfirm(false);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);

    if (mode === "CODE" && studentCode.trim().length < 4) {
      setErrorMessage(
        t("कृपया अपना छात्र कोड सही से दर्ज करें।", "Please enter your Student Code.")
      );
      return;
    }

    if (mode === "DETAILS") {
      if (!schoolUdise) {
        setErrorMessage(
          t("कृपया पहले अपना विद्यालय चुनें।", "Please select your school first.")
        );
        return;
      }
      if (!classNum) {
        setErrorMessage(t("कृपया अपनी कक्षा चुनें।", "Please select your class."));
        return;
      }
      if (!rollNo || Number(rollNo) < 1) {
        setErrorMessage(
          t("कृपया अपना सही रोल नंबर लिखें।", "Please enter your valid Roll Number.")
        );
        return;
      }
    }

    if (authMethod === "DOB" && !dob) {
      setErrorMessage(
        t(
          "कृपया जन्म तिथि के दिन, महीना और वर्ष तीनों चुनें।",
          "Please select Day, Month, and Year for your Date of Birth."
        )
      );
      return;
    }

    if (authMethod === "PIN" && !/^\d{4}$/.test(pin.trim())) {
      setErrorMessage(
        t("कृपया अपना 4-अंकों का PIN दर्ज करें।", "Please enter your 4-digit PIN.")
      );
      return;
    }

    setSubmitting(true);
    try {
      const payload =
        mode === "CODE"
          ? {
              mode: "CODE" as const,
              studentCode: studentCode.trim(),
              authMethod,
              ...(authMethod === "DOB" ? { dob } : { pin: pin.trim() }),
              ...(showTurnstile && turnstileToken ? { turnstileToken } : {}),
            }
          : {
              mode: "DETAILS" as const,
              schoolUdise,
              classNum: Number(classNum),
              rollNo: Number(rollNo),
              authMethod,
              ...(authMethod === "DOB" ? { dob } : { pin: pin.trim() }),
              ...(needsFatherConfirm && fatherName.trim()
                ? { fatherName: fatherName.trim() }
                : {}),
              ...(showTurnstile && turnstileToken ? { turnstileToken } : {}),
            };

      const res = await fetch("/api/auth/student", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify(payload),
      });

      const data = (await res.json()) as StudentAuthResponse;

      if (data.requiresTurnstile) {
        setShowTurnstile(true);
        setTurnstileToken("");
        setTurnstileResetKey((k) => k + 1);
      }

      if (data.disambiguationRequired) {
        setNeedsFatherConfirm(true);
        setErrorMessage(
          lang === "EN"
            ? data.error || "Please enter your Father's Name to confirm your account."
            : data.errorHi ||
                "कृपया पुष्टि के लिए अपने पिता का नाम दर्ज करें।"
        );
        return;
      }

      if (!res.ok || !data.ok) {
        setErrorMessage(
          lang === "EN"
            ? data.error || "Could not sign in. Please check your details."
            : data.errorHi ||
                data.error ||
                "लॉगिन नहीं हो सका। कृपया अपना विवरण दोबारा जांचें।"
        );
        return;
      }

      // Clear any previous student's drafts on shared school ICT Lab PCs and notify other open tabs
      clearUserScopedBrowserState();
      broadcastAuthEvent("USER_SWITCH", "/login/student");
      window.location.assign(data.redirectTo || "/student");
    } catch {
      setErrorMessage(
        t(
          "नेटवर्क समस्या है। कृपया इंटरनेट जांचकर दोबारा प्रयास करें।",
          "Network error. Please check your connection and try again."
        )
      );
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="min-h-dvh flex flex-col bg-canvas text-ink">
      {/* Clean Top Header */}
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
              <GraduationCap className="h-6 w-6" aria-hidden="true" />
            </div>
            <div>
              <h1 className="text-xl font-extrabold text-ink leading-snug">
                {t("विद्यार्थी लॉगिन", "Student Login")}
              </h1>
              <p className="mt-1 text-sm text-ink-secondary leading-relaxed">
                {t(
                  "अपने नोट्स, अभ्यास और परीक्षा कक्ष तक पहुँचने के लिए लॉगिन करें।",
                  "Sign in to access your visual chapter notes, practice studio, and exams."
                )}
              </p>
            </div>
          </div>

          <div className="mt-5">
            <Tabs<LoginMode>
              variant="pills"
              value={mode}
              onChange={handleModeChange}
              ariaLabel={t("छात्र लॉगिन विकल्प", "Student sign-in method")}
              className="w-full"
              items={[
                {
                  id: "CODE",
                  label: t("छात्र कोड से", "With Student Code"),
                  icon: <KeyRound className="h-4 w-4" aria-hidden="true" />,
                },
                {
                  id: "DETAILS",
                  label: t("कोड याद नहीं?", "Forgot Code?"),
                  icon: <Hash className="h-4 w-4" aria-hidden="true" />,
                },
              ]}
            />
          </div>

          <form onSubmit={handleSubmit} className="mt-5 space-y-5" noValidate>
            {mode === "CODE" ? (
              <Input
                label={t("छात्र कोड (Student Code)", "Student Code")}
                value={studentCode}
                onChange={(e) => setStudentCode(e.target.value)}
                placeholder={t(
                  "अपना 15-अंकीय छात्र कोड लिखें",
                  "Enter your Student Code"
                )}
                hint={t(
                  "यदि आपको अपना छात्र कोड याद नहीं है, तो ऊपर 'कोड याद नहीं?' चुनें।",
                  "Do not remember your code? Switch to the 'Forgot Code?' tab above."
                )}
                leftIcon={<KeyRound className="h-4 w-4" />}
                inputMode="numeric"
                autoComplete="username"
                required
              />
            ) : (
              <div className="space-y-4">
                <SchoolSearchSelect
                  value={schoolUdise}
                  onChange={(udise) => {
                    setSchoolUdise(udise);
                    setNeedsFatherConfirm(false);
                  }}
                />

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
                  <Select
                    label={t("कक्षा (Class)", "Class")}
                    value={classNum}
                    onChange={(e) => {
                      setClassNum(e.target.value);
                      setNeedsFatherConfirm(false);
                    }}
                    placeholder={t("कक्षा चुनें", "Select Class")}
                    options={classOptions}
                    required
                  />

                  <Input
                    label={t("रोल नंबर (Roll No)", "Roll Number")}
                    value={rollNo}
                    onChange={(e) => {
                      setRollNo(e.target.value.replace(/\D/g, "").slice(0, 5));
                      setNeedsFatherConfirm(false);
                    }}
                    placeholder={t("जैसे: 14", "e.g., 14")}
                    leftIcon={<Hash className="h-4 w-4" />}
                    inputMode="numeric"
                    required
                  />
                </div>
              </div>
            )}

            {/* DOB vs Optional 4-Digit PIN Switcher */}
            <div className="space-y-3 pt-1">
              <div className="flex flex-wrap items-center justify-between gap-2">
                <span className="text-xs font-semibold uppercase tracking-wider text-ink-muted">
                  {t("पहचान सत्यापन", "Verification")}
                </span>
                <button
                  type="button"
                  onClick={() => {
                    setAuthMethod((prev) => (prev === "DOB" ? "PIN" : "DOB"));
                    setErrorMessage(null);
                  }}
                  className="inline-flex items-center gap-1.5 text-xs font-semibold text-indigo-ink hover:underline"
                >
                  {authMethod === "DOB" ? (
                    <>
                      <Lock className="h-3.5 w-3.5" aria-hidden="true" />
                      <span>
                        {t(
                          "4-अंकों के PIN से लॉगिन करें",
                          "Use 4-digit PIN instead"
                        )}
                      </span>
                    </>
                  ) : (
                    <>
                      <Calendar className="h-3.5 w-3.5" aria-hidden="true" />
                      <span>
                        {t(
                          "जन्म तिथि (DOB) से लॉगिन करें",
                          "Use Date of Birth instead"
                        )}
                      </span>
                    </>
                  )}
                </button>
              </div>

              {authMethod === "DOB" ? (
                <DobDropdownPicker value={dob} onChange={setDob} required />
              ) : (
                <Input
                  label={t("4-अंकों का PIN", "4-Digit PIN")}
                  type="password"
                  value={pin}
                  onChange={(e) =>
                    setPin(e.target.value.replace(/\D/g, "").slice(0, 4))
                  }
                  placeholder="••••"
                  hint={t(
                    "यदि आपने अभी तक PIN नहीं बनाया है, तो जन्म तिथि से लॉगिन करें।",
                    "If you have not set a PIN in your profile yet, switch back to Date of Birth."
                  )}
                  leftIcon={<Lock className="h-4 w-4" />}
                  inputMode="numeric"
                  maxLength={4}
                  autoComplete="current-password"
                  required
                />
              )}
            </div>

            {/* Rare Tie-Breaker: Father's Name Confirmation */}
            {needsFatherConfirm && mode === "DETAILS" && (
              <div className="rounded-paper border border-amber-warm/35 bg-surface-warm p-4 space-y-2.5">
                <p className="text-xs font-semibold text-amber-ink">
                  {t(
                    "एक ही कक्षा, रोल नंबर और जन्म तिथि वाले एक से अधिक छात्र हैं। कृपया अपने पिता का नाम लिखकर पुष्टि करें:",
                    "Multiple students share this Class, Roll Number, and Date of Birth. Please enter your Father's Name to confirm:"
                  )}
                </p>
                <Input
                  label={t("पिता का नाम (Father's Name)", "Father's Name")}
                  value={fatherName}
                  onChange={(e) => setFatherName(e.target.value)}
                  placeholder={t(
                    "स्कूल रजिस्टर के अनुसार पिता का नाम",
                    "Father's Name as per school register"
                  )}
                  leftIcon={<User className="h-4 w-4" />}
                  required
                />
              </div>
            )}

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
                <AlertCircle
                  className="h-4 w-4 shrink-0 mt-0.5"
                  aria-hidden="true"
                />
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
              {t("अध्ययन पोर्टल में प्रवेश करें", "Sign In to Study Portal")}
            </Button>
          </form>

          <div className="mt-6 pt-4 border-t border-hairline flex flex-wrap items-center justify-between gap-2 text-xs text-ink-muted">
            <span>
              {t("क्या आप शिक्षक हैं?", "Are you a teacher?")}
            </span>
            <Link
              href="/login/teacher"
              className="font-semibold text-indigo-ink hover:underline"
            >
              {t("शिक्षक लॉगिन पर जाएं", "Go to Teacher Login")}
            </Link>
          </div>
        </Card>
      </main>
    </div>
  );
}
