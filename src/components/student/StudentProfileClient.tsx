"use client";

import React, { useEffect, useState } from "react";
import {
  Award,
  BookOpen,
  CheckCircle2,
  KeyRound,
  LogOut,
  Medal,
  Printer,
  ShieldCheck,
  Sparkles,
  UserCircle2,
} from "lucide-react";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import {
  broadcastAuthEvent,
  clearUserScopedBrowserState,
} from "@/components/providers/SessionSyncListener";
import {
  Badge,
  Button,
  Card,
  DobDropdownPicker,
  Input,
  Modal,
  useToast,
} from "@/components/ui";
import { SubjectSelectionWizard } from "./SubjectSelectionWizard";

interface ProfileDashboardData {
  student: {
    id: string;
    studentCode: string | null;
    studentName: string;
    fatherName: string | null;
    dob: string;
    classNum: number;
    stream: string;
    section: string;
    rollNo: number;
    academicYear: string;
    schoolUdise: string | null;
    schoolName: string | null;
    hasPin: boolean;
    masteryPoints: number;
    weeklyPoints: number;
    streakDays: number;
    badges: Array<{ code: string; title_hi: string; title_en: string; earned_at: string }>;
    rank: {
      level: number;
      title_hi: string;
      title_en: string;
      nextPoints: number | null;
    };
    totalMedals: { gold: number; silver: number; bronze: number };
  };
  subjects: Array<{
    id: string;
    bseb_code: string;
    name_hi: string;
    name_en: string;
    slot_type: string;
  }>;
}

export function StudentProfileClient() {
  const { t } = useLanguage();
  const toast = useToast();

  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<ProfileDashboardData | null>(null);
  const [editSubjectsOpen, setEditSubjectsOpen] = useState(false);

  // PIN management state
  const [hasPin, setHasPin] = useState(false);
  const [pinModalOpen, setPinModalOpen] = useState(false);
  const [pinAction, setPinAction] = useState<"SET" | "REMOVE">("SET");
  const [pinValue, setPinValue] = useState("");
  const [pinConfirm, setPinConfirm] = useState("");
  const [verifyDob, setVerifyDob] = useState("");
  const [pinSaving, setPinSaving] = useState(false);
  const [signingOut, setSigningOut] = useState(false);

  const loadProfile = async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/student/dashboard", { cache: "no-store" });
      if (!res.ok) throw new Error("failed");
      const json = (await res.json()) as ProfileDashboardData;
      setData(json);
      setHasPin(Boolean(json.student.hasPin));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadProfile();
  }, []);

  const handleSavePin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!verifyDob) {
      toast.error(t("कृपया अपनी जन्म तिथि चुनें।", "Please select your Date of Birth."));
      return;
    }
    if (pinAction === "SET") {
      if (!/^\d{4}$/.test(pinValue)) {
        toast.error(t("पिन ठीक 4 अंकों का होना चाहिए।", "PIN must be exactly 4 digits."));
        return;
      }
      if (pinValue !== pinConfirm) {
        toast.error(t("दोनों पिन मेल नहीं खाते।", "PIN entries do not match."));
        return;
      }
    }

    setPinSaving(true);
    try {
      const res = await fetch("/api/student/pin", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(
          pinAction === "SET"
            ? { action: "SET", pin: pinValue, currentDob: verifyDob }
            : { action: "REMOVE", currentDob: verifyDob }
        ),
      });
      const json = (await res.json()) as {
        ok?: boolean;
        hasPin?: boolean;
        messageHi?: string;
        messageEn?: string;
        error?: string;
        errorEn?: string;
      };
      if (!res.ok || !json.ok) {
        toast.error(t(json.error ?? "त्रुटि हुई", json.errorEn ?? "Could not update PIN"));
        return;
      }
      setHasPin(Boolean(json.hasPin));
      setPinModalOpen(false);
      setPinValue("");
      setPinConfirm("");
      setVerifyDob("");
      toast.success(t(json.messageHi ?? "सफल!", json.messageEn ?? "Saved!"));
    } finally {
      setPinSaving(false);
    }
  };

  const handleSwitchStudent = async () => {
    setSigningOut(true);
    try {
      await fetch("/api/auth/logout", {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-Requested-With": "XMLHttpRequest" },
        body: JSON.stringify({}),
      });
    } catch {
      // Proceed cleanly
    } finally {
      clearUserScopedBrowserState();
      broadcastAuthEvent("LOGOUT", "/login/student");
      window.location.replace("/login/student");
    }
  };

  if (loading || !data) {
    return (
      <div className="space-y-4 animate-pulse max-w-4xl mx-auto">
        <div className="h-44 rounded-paper bg-surface-subtle" />
        <div className="h-56 rounded-paper bg-surface-subtle" />
      </div>
    );
  }

  const { student, subjects } = data;
  const issueDateStr = new Intl.DateTimeFormat("en-IN", {
    timeZone: "Asia/Kolkata",
    day: "2-digit",
    month: "long",
    year: "numeric",
  }).format(new Date());

  return (
    <div className="max-w-4xl mx-auto space-y-6 pb-12">
      {/* Screen Profile Sections (hidden only when printing Merit Certificate? No — keep Certificate cleanly styled for print!) */}
      <div className="space-y-6 no-print">
        <Card variant="indigo" padding="lg" className="space-y-4">
          <div className="flex flex-wrap items-start justify-between gap-4">
            <div className="flex items-start gap-3.5">
              <span className="inline-flex h-14 w-14 items-center justify-center rounded-paper bg-indigo-academic text-white shrink-0">
                <UserCircle2 className="h-8 w-8" />
              </span>
              <div className="space-y-1">
                <div className="flex flex-wrap items-center gap-2">
                  <Badge variant="indigo">
                    {t(`कक्षा ${student.classNum}`, `Class ${student.classNum}`)}
                  </Badge>
                  {student.stream !== "NA" && student.stream !== "UNSET" && (
                    <Badge variant="amber">{student.stream}</Badge>
                  )}
                  <Badge variant="neutral">
                    {t(`रोल ${student.rollNo}`, `Roll ${student.rollNo}`)}
                  </Badge>
                </div>
                <h1 className="text-2xl font-bold text-ink">{student.studentName}</h1>
                <p className="text-xs sm:text-sm text-ink-secondary">
                  {student.schoolName}
                  {student.schoolUdise ? ` (${student.schoolUdise})` : ""}
                </p>
                {student.studentCode && (
                  <p className="text-xs font-mono text-indigo-ink font-semibold">
                    {t("विद्यार्थी कोड", "Student Code")}: {student.studentCode}
                  </p>
                )}
              </div>
            </div>

            <Button
              variant="secondary"
              loading={signingOut}
              onClick={handleSwitchStudent}
              leftIcon={<LogOut className="h-4 w-4" />}
            >
              {t("विद्यार्थी बदलें / लॉग आउट", "Switch Student / Sign Out")}
            </Button>
          </div>
        </Card>

        {/* Scholarly Rank, Medals & Badges */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <Card className="space-y-1.5">
            <div className="text-xs font-bold uppercase tracking-wider text-ink-muted">
              {t("अकादमिक उपाधि", "Scholarly Title")}
            </div>
            <div className="text-lg font-bold text-indigo-ink flex items-center gap-2">
              <Award className="h-5 w-5 text-amber-ink shrink-0" />
              <BiText hi={student.rank.title_hi} en={student.rank.title_en} />
            </div>
            <p className="text-xs text-ink-secondary">
              {t(`${student.masteryPoints} कुल अध्ययन अंक`, `${student.masteryPoints} total mastery points`)}
            </p>
          </Card>

          <Card className="space-y-1.5">
            <div className="text-xs font-bold uppercase tracking-wider text-ink-muted">
              {t("अध्याय पदक", "Chapter Medals")}
            </div>
            <div className="flex items-center gap-4 pt-1 text-sm font-bold">
              <span className="inline-flex items-center gap-1 text-amber-ink">
                <Medal className="h-4 w-4" /> {student.totalMedals.gold} {t("स्वर्ण", "Gold")}
              </span>
              <span className="inline-flex items-center gap-1 text-indigo-ink">
                <Medal className="h-4 w-4" /> {student.totalMedals.silver} {t("रजत", "Silver")}
              </span>
              <span className="inline-flex items-center gap-1 text-emerald-ink">
                <Medal className="h-4 w-4" /> {student.totalMedals.bronze} {t("कांस्य", "Bronze")}
              </span>
            </div>
          </Card>

          <Card className="space-y-1.5">
            <div className="text-xs font-bold uppercase tracking-wider text-ink-muted">
              {t("अर्जित सम्मान बैज", "Earned Badges")}
            </div>
            <div className="flex flex-wrap gap-1.5 pt-1">
              {student.badges.length === 0 ? (
                <span className="text-xs text-ink-secondary">
                  {t("पहला अभ्यास पूरा कर बैज पाएँ!", "Complete your first drill to unlock a badge!")}
                </span>
              ) : (
                student.badges.map((b) => (
                  <Badge key={b.code} variant="emerald" icon={<Sparkles className="h-3 w-3" />}>
                    <BiText hi={b.title_hi} en={b.title_en} inline />
                  </Badge>
                ))
              )}
            </div>
          </Card>
        </div>

        {/* Selected Subjects + Edit Toggle */}
        <Card className="space-y-4">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <div>
              <h2 className="text-base font-bold text-ink flex items-center gap-2">
                <BookOpen className="h-4 w-4 text-indigo-ink" />
                {t("मेरे चुने गए बिहार बोर्ड विषय", "My Selected Bihar Board Subjects")}
              </h2>
              <p className="text-xs text-ink-secondary">
                {t(
                  `शैक्षणिक सत्र ${student.academicYear}`,
                  `Academic Session ${student.academicYear}`
                )}
              </p>
            </div>
            <Button
              size="sm"
              variant="secondary"
              onClick={() => setEditSubjectsOpen((v) => !v)}
            >
              {editSubjectsOpen
                ? t("बंद करें", "Close Editor")
                : t("विषय बदलें", "Change Selected Subjects")}
            </Button>
          </div>

          <div className="flex flex-wrap gap-2">
            {subjects.map((sub) => (
              <Badge key={sub.id} variant="indigo">
                <BiText hi={sub.name_hi} en={sub.name_en} inline /> ({sub.bseb_code})
              </Badge>
            ))}
          </div>

          {editSubjectsOpen && (
            <div className="pt-4 border-t border-hairline">
              <SubjectSelectionWizard
                mode="edit"
                onComplete={() => {
                  setEditSubjectsOpen(false);
                  loadProfile();
                }}
              />
            </div>
          )}
        </Card>

        {/* Optional 4-Digit Shared ICT Lab Security PIN */}
        <Card className="flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-start gap-3">
            <span className="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-soft text-emerald-ink shrink-0">
              <ShieldCheck className="h-5 w-5" />
            </span>
            <div>
              <h2 className="text-base font-bold text-ink">
                {t("वैकल्पिक 4-अंकों का सुरक्षा पिन (ICT लैब सुरक्षा)", "Optional 4-Digit Lab Security PIN")}
              </h2>
              <p className="text-xs sm:text-sm text-ink-secondary mt-0.5">
                {hasPin
                  ? t(
                      "आपका 4-अंकों का पिन सक्रिय है। स्कूल के साझा कंप्यूटर पर यह आपके खाते को सुरक्षित रखता है।",
                      "Your 4-digit PIN is active to protect your account on shared school computers."
                    )
                  : t(
                      "साझा स्कूल कंप्यूटर पर अतिरिक्त सुरक्षा के लिए 4 अंकों का पिन सेट कर सकते हैं (वैकल्पिक)।",
                      "Set an optional 4-digit PIN for extra privacy when using shared school ICT Lab computers."
                    )}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <Button
              size="sm"
              variant="primary"
              leftIcon={<KeyRound className="h-4 w-4" />}
              onClick={() => {
                setPinAction("SET");
                setPinModalOpen(true);
              }}
            >
              {hasPin ? t("पिन बदलें", "Change PIN") : t("पिन सेट करें", "Set 4-Digit PIN")}
            </Button>
            {hasPin && (
              <Button
                size="sm"
                variant="ghost"
                onClick={() => {
                  setPinAction("REMOVE");
                  setPinModalOpen(true);
                }}
              >
                {t("पिन हटाएँ", "Remove PIN")}
              </Button>
            )}
          </div>
        </Card>
      </div>

      {/* Printable Official Merit Certificate (Visible on Screen + Clean Full A4 on Print!) */}
      <Card
        padding="lg"
        className="border-2 border-indigo-academic/40 bg-[#FDFCF8] dark:bg-surface print:border-4 print:border-indigo-900 print:shadow-none"
      >
        <div className="flex items-center justify-between gap-3 pb-4 border-b border-hairline no-print">
          <div>
            <h2 className="text-base font-bold text-ink">
              {t("आधिकारिक अध्ययन मेधा प्रमाण-पत्र", "Official Academic Merit Certificate")}
            </h2>
            <p className="text-xs text-ink-secondary">
              {t("प्रिंट या PDF के रूप में सहेजें (A4 स्वच्छ प्रारूप)", "Print or Save as clean A4 PDF")}
            </p>
          </div>
          <Button
            variant="amber"
            onClick={() => window.print()}
            leftIcon={<Printer className="h-4 w-4" />}
          >
            {t("प्रमाण-पत्र प्रिंट करें", "Print Certificate")}
          </Button>
        </div>

        <div className="py-8 px-4 sm:px-8 text-center space-y-5">
          <div className="space-y-1">
            <p className="text-xs font-bold uppercase tracking-[0.2em] text-indigo-ink">
              Students of Bihar (Class 9–12) · बिहार विद्यालय अध्ययन मंच
            </p>
            <h3 className="text-2xl sm:text-3xl font-bold text-ink tracking-tight">
              {t("अध्ययन मेधा प्रमाण-पत्र", "Certificate of Academic Merit")}
            </h3>
          </div>

          <p className="text-sm text-ink-secondary">
            {t("यह प्रमाणित किया जाता है कि", "This is proudly presented to")}
          </p>

          <div className="space-y-1">
            <div className="text-2xl sm:text-3xl font-bold text-indigo-ink">
              {student.studentName}
            </div>
            <p className="text-sm font-semibold text-ink-secondary">
              {t(
                `कक्षा ${student.classNum}${student.stream !== "NA" && student.stream !== "UNSET" ? ` (${student.stream})` : ""} · रोल क्र. ${student.rollNo} · ${student.schoolName ?? ""}`,
                `Class ${student.classNum}${student.stream !== "NA" && student.stream !== "UNSET" ? ` (${student.stream})` : ""} · Roll No. ${student.rollNo} · ${student.schoolName ?? ""}`
              )}
            </p>
          </div>

          <p className="text-sm text-ink max-w-xl mx-auto leading-relaxed">
            {t(
              `ने शैक्षणिक सत्र ${student.academicYear} में नियमित अध्ययन एवं अभ्यास के द्वारा ${student.masteryPoints} अध्ययन अंक अर्जित कर "${student.rank.title_hi}" उपाधि प्राप्त की है।`,
              `has demonstrated dedicated academic consistency during session ${student.academicYear}, earning ${student.masteryPoints} mastery points and the title of "${student.rank.title_en}".`
            )}
          </p>

          <div className="flex flex-wrap items-center justify-center gap-6 pt-3 text-xs font-semibold text-ink-secondary">
            <span className="inline-flex items-center gap-1.5">
              <CheckCircle2 className="h-4 w-4 text-emerald-ink" />
              {t(`${student.streakDays} दिन नियमितता`, `${student.streakDays}-Day Streak`)}
            </span>
            <span className="inline-flex items-center gap-1.5">
              <Medal className="h-4 w-4 text-amber-ink" />
              {student.totalMedals.gold}G · {student.totalMedals.silver}S · {student.totalMedals.bronze}B
            </span>
            <span>{t("दिनांक", "Issued")}: {issueDateStr}</span>
          </div>
        </div>
      </Card>

      {/* PIN Modal */}
      <Modal
        open={pinModalOpen}
        onClose={() => setPinModalOpen(false)}
        title={
          pinAction === "SET"
            ? t("4-अंकों का लैब सुरक्षा पिन सेट करें", "Set 4-Digit Lab Security PIN")
            : t("सुरक्षा पिन हटाएँ", "Remove Security PIN")
        }
      >
        <form onSubmit={handleSavePin} className="space-y-4">
          <DobDropdownPicker
            label={t("सत्यापन के लिए अपनी जन्म तिथि चुनें", "Confirm Your Date of Birth")}
            value={verifyDob}
            onChange={setVerifyDob}
          />

          {pinAction === "SET" && (
            <>
              <Input
                label={t("नया 4-अंकों का पिन", "New 4-Digit PIN")}
                type="password"
                inputMode="numeric"
                maxLength={4}
                placeholder="••••"
                value={pinValue}
                onChange={(e) => setPinValue(e.target.value.replace(/\D/g, "").slice(0, 4))}
                required
              />
              <Input
                label={t("पिन की पुष्टि करें", "Confirm 4-Digit PIN")}
                type="password"
                inputMode="numeric"
                maxLength={4}
                placeholder="••••"
                value={pinConfirm}
                onChange={(e) => setPinConfirm(e.target.value.replace(/\D/g, "").slice(0, 4))}
                required
              />
            </>
          )}

          <div className="flex justify-end gap-2 pt-2">
            <Button variant="secondary" onClick={() => setPinModalOpen(false)}>
              {t("रद्द करें", "Cancel")}
            </Button>
            <Button type="submit" variant="primary" loading={pinSaving}>
              {pinAction === "SET"
                ? t("पिन सहेजें", "Save PIN")
                : t("पिन हटाएँ", "Confirm Remove")}
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
