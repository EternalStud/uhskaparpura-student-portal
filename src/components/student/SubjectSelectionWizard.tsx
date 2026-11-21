"use client";

import React, { useEffect, useMemo, useState } from "react";
import {
  AlertCircle,
  BookOpen,
  Check,
  CheckCircle2,
  FlaskConical,
  Landmark,
  Lock,
  Sparkles,
  TrendingUp,
} from "lucide-react";
import type {
  ClassNum,
  StudentStream,
  SubjectRow,
} from "@/types/database";
import {
  getAllowedSilForMil,
  getRecommendedSil,
  normalizeSubjectKey,
  type GroupedClass910Subjects,
  type GroupedClass1112Subjects,
} from "@/lib/bseb/rules";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Button, Card, useToast } from "@/components/ui";
import { SubjectIcon } from "./SubjectIcon";
import { cn } from "@/components/ui/cn";

interface SubjectsApiResponse {
  classNum: ClassNum;
  stream: StudentStream;
  subjectsConfigured: boolean;
  inGraceWindow: boolean;
  monthlyChangesUsed: number;
  monthlyChangesLimit: number;
  selectedSlots: Array<{ subject_id: string; slot_type: string }>;
  groups910?: GroupedClass910Subjects;
  groups1112ByStream?: Record<"Science" | "Arts" | "Commerce", GroupedClass1112Subjects>;
  catalog: SubjectRow[];
}

export interface SubjectSelectionWizardProps {
  mode: "onboarding" | "edit";
  onComplete?: () => void;
}

export function SubjectSelectionWizard({
  mode,
  onComplete,
}: SubjectSelectionWizardProps) {
  const { t } = useLanguage();
  const toast = useToast();

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [data, setData] = useState<SubjectsApiResponse | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  // Class 9-10 state
  const [milId, setMilId] = useState<string>("");
  const [silId, setSilId] = useState<string>("");
  const [skillId, setSkillId] = useState<string>("");

  // Class 11-12 state
  const [stream, setStream] = useState<"Science" | "Arts" | "Commerce" | "">("");
  const [lang1Id, setLang1Id] = useState<string>("");
  const [lang2Id, setLang2Id] = useState<string>("");
  const [electiveIds, setElectiveIds] = useState<string[]>([]);
  const [additionalId, setAdditionalId] = useState<string>("");

  useEffect(() => {
    let active = true;
    async function load() {
      setLoading(true);
      try {
        const res = await fetch("/api/student/subjects", { cache: "no-store" });
        if (!res.ok) throw new Error("load failed");
        const json = (await res.json()) as SubjectsApiResponse;
        if (!active) return;
        setData(json);

        // Pre-populate existing selections if already configured
        const slots = json.selectedSlots ?? [];
        if (json.classNum === 9 || json.classNum === 10) {
          const existingMil = slots.find((s) => s.slot_type === "MIL")?.subject_id ?? "";
          const existingSil = slots.find((s) => s.slot_type === "SIL")?.subject_id ?? "";
          const existingSkill = slots.find((s) => s.slot_type === "SKILL")?.subject_id ?? "";
          setMilId(existingMil);
          setSilId(existingSil);
          setSkillId(existingSkill);
        } else {
          if (json.stream === "Science" || json.stream === "Arts" || json.stream === "Commerce") {
            setStream(json.stream);
          }
          setLang1Id(slots.find((s) => s.slot_type === "LANG_1")?.subject_id ?? "");
          setLang2Id(slots.find((s) => s.slot_type === "LANG_2")?.subject_id ?? "");
          setElectiveIds(
            slots.filter((s) => s.slot_type === "ELECTIVE").map((s) => s.subject_id)
          );
          setAdditionalId(slots.find((s) => s.slot_type === "ADDITIONAL")?.subject_id ?? "");
        }
      } catch {
        if (active) {
          setErrorMsg(
            t("विषय सूची लोड नहीं हो सकी। कृपया पृष्ठ रीफ्रेश करें।", "Could not load subject list. Please refresh.")
          );
        }
      } finally {
        if (active) setLoading(false);
      }
    }
    load();
    return () => {
      active = false;
    };
  }, [t]);

  const selectedMilSubject = useMemo(() => {
    if (!data?.groups910 || !milId) return null;
    return data.groups910.mil.find((m) => m.id === milId) ?? null;
  }, [data, milId]);

  const allowedSils = useMemo(() => {
    if (!data?.groups910) return [];
    return getAllowedSilForMil(selectedMilSubject, data.groups910.sil);
  }, [data, selectedMilSubject]);

  const handleSelectMil = (subject: SubjectRow) => {
    setMilId(subject.id);
    setErrorMsg(null);
    if (!data?.groups910) return;
    const allowed = getAllowedSilForMil(subject, data.groups910.sil);
    // Auto-select recommended SIL (Non-Hindi for Urdu/Maithili/Bangla; Sanskrit for Hindi)
    const currentStillAllowed = allowed.some((s) => s.id === silId);
    if (!currentStillAllowed || !silId) {
      const rec = getRecommendedSil(subject, data.groups910.sil);
      setSilId(rec?.id ?? allowed[0]?.id ?? "");
    }
  };

  const handleSelectStream = (nextStream: "Science" | "Arts" | "Commerce") => {
    if (nextStream !== stream) {
      setStream(nextStream);
      setElectiveIds([]);
      setAdditionalId("");
      setErrorMsg(null);
    }
  };

  const active1112Group = useMemo(() => {
    if (!data?.groups1112ByStream || !stream) return null;
    return data.groups1112ByStream[stream];
  }, [data, stream]);

  const lang1Canonical = useMemo(() => {
    if (!active1112Group || !lang1Id) return "";
    const found = active1112Group.lang1.find((l) => l.id === lang1Id);
    return found ? normalizeSubjectKey(found.name_en) : "";
  }, [active1112Group, lang1Id]);

  const toggleElective = (subjId: string) => {
    setErrorMsg(null);
    setElectiveIds((prev) => {
      if (prev.includes(subjId)) {
        return prev.filter((id) => id !== subjId);
      }
      if (prev.length >= 3) {
        return [...prev.slice(1), subjId];
      }
      return [...prev, subjId];
    });
    // Clear additional if it collides with newly selected elective
    if (additionalId && data) {
      const targetSubj = data.catalog.find((s) => s.id === subjId);
      const addSubj = data.catalog.find((s) => s.id === additionalId);
      if (
        targetSubj &&
        addSubj &&
        (targetSubj.id === addSubj.id ||
          normalizeSubjectKey(targetSubj.name_en) === normalizeSubjectKey(addSubj.name_en))
      ) {
        setAdditionalId("");
      }
    }
  };

  const chosenCanonKeysForAdditional = useMemo(() => {
    if (!data) return new Set<string>();
    const picked = [lang1Id, lang2Id, ...electiveIds].filter(Boolean);
    const set = new Set<string>();
    for (const id of picked) {
      const s = data.catalog.find((c) => c.id === id);
      if (s) set.add(normalizeSubjectKey(s.name_en));
    }
    return set;
  }, [data, lang1Id, lang2Id, electiveIds]);

  const handleSubmit = async () => {
    if (!data) return;
    setSaving(true);
    setErrorMsg(null);

    try {
      const payload =
        data.classNum === 9 || data.classNum === 10
          ? {
              stream: "NA" as const,
              milSubjectId: milId || null,
              silSubjectId: silId || null,
              skillSubjectId: skillId || null,
            }
          : {
              stream: stream || "UNSET",
              lang1SubjectId: lang1Id || null,
              lang2SubjectId: lang2Id || null,
              electiveSubjectIds: electiveIds,
              additionalSubjectId: additionalId || null,
            };

      const res = await fetch("/api/student/subjects", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      const json = (await res.json()) as {
        ok?: boolean;
        error?: string;
        errorEn?: string;
      };

      if (!res.ok || !json.ok) {
        setErrorMsg(t(json.error ?? "विषय सहेजे नहीं जा सके।", json.errorEn ?? "Could not save subjects."));
        return;
      }

      toast.success(
        t("विषय सुरक्षित रूप से सहेजे गए!", "Subjects saved successfully!"),
        t(
          "अब आपके डैशबोर्ड पर केवल आपके चुने गए विषय दिखेंगे।",
          "Your study dashboard is now tailored to your chosen subjects."
        )
      );

      onComplete?.();
    } catch {
      setErrorMsg(t("नेटवर्क त्रुटि। कृपया पुनः प्रयास करें।", "Network error. Please try again."));
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <Card className="animate-pulse space-y-4">
        <div className="h-6 w-2/3 rounded bg-surface-subtle" />
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div className="h-16 rounded-lg bg-surface-subtle" />
          <div className="h-16 rounded-lg bg-surface-subtle" />
        </div>
      </Card>
    );
  }

  if (!data) {
    return (
      <Card variant="warm">
        <p className="text-sm text-crimson-ink">{errorMsg}</p>
      </Card>
    );
  }

  const isSecondary = data.classNum === 9 || data.classNum === 10;

  return (
    <div className="space-y-6">
      {mode === "edit" && !data.inGraceWindow && (
        <div className="rounded-lg border border-amber-warm/30 bg-amber-soft px-4 py-3 text-xs sm:text-sm text-amber-ink flex items-start gap-2.5">
          <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" />
          <span>
            {t(
              `इस महीने विषय परिवर्तन: ${data.monthlyChangesUsed}/${data.monthlyChangesLimit} उपयोग हो चुका है।`,
              `Subject changes used this month: ${data.monthlyChangesUsed}/${data.monthlyChangesLimit}.`
            )}
          </span>
        </div>
      )}

      {/* ==================== CLASS 9 & 10 WIZARD ==================== */}
      {isSecondary && data.groups910 && (
        <>
          {/* Mandatory Core Subjects (Locked) */}
          <Card>
            <div className="flex items-center justify-between gap-2 mb-3">
              <div>
                <h2 className="text-base font-bold text-ink">
                  <BiText
                    hi="1. अनिवार्य मुख्य विषय (अपने आप शामिल)"
                    en="1. Mandatory Core Subjects (Auto-Included)"
                  />
                </h2>
                <p className="text-xs sm:text-sm text-ink-secondary mt-0.5">
                  {t(
                    "बिहार बोर्ड कक्षा 9-10 के सभी विद्यार्थियों के लिए ये 4 विषय अनिवार्य हैं।",
                    "These 4 core subjects are mandatory for all Bihar Board Class 9–10 students."
                  )}
                </p>
              </div>
              <Badge variant="indigo" icon={<Lock className="h-3 w-3" />}>
                {t("अनिवार्य", "Mandatory")}
              </Badge>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {data.groups910.mandatory.map((sub) => (
                <div
                  key={sub.id}
                  className="flex items-center gap-3 rounded-lg border border-indigo-academic/20 bg-indigo-soft px-3.5 py-3"
                >
                  <span
                    className="inline-flex h-9 w-9 items-center justify-center rounded-lg text-white shrink-0"
                    style={{ backgroundColor: sub.accent_color }}
                  >
                    <SubjectIcon name={sub.icon_name} className="h-4 w-4" />
                  </span>
                  <div className="min-w-0 flex-1">
                    <div className="font-semibold text-sm text-ink truncate">
                      <BiText hi={sub.name_hi} en={sub.name_en} inline />
                    </div>
                    <div className="text-xs text-ink-muted">
                      {t("कोड", "Code")}: {sub.bseb_code}
                    </div>
                  </div>
                  <CheckCircle2 className="h-4 w-4 text-emerald-ink shrink-0" />
                </div>
              ))}
            </div>
          </Card>

          {/* MIL Selection */}
          <Card>
            <h2 className="text-base font-bold text-ink mb-1">
              <BiText hi="2. अपनी मातृभाषा (MIL) चुनें — कोई 1" en="2. Choose Your Mother Tongue (MIL) — Pick 1" />
            </h2>
            <p className="text-xs sm:text-sm text-ink-secondary mb-3.5">
              {t(
                "अधिकांश छात्र हिन्दी चुनते हैं। उर्दू/मैथिली/बांग्ला चुनने पर अहिन्दी (SIL) अपने आप सुझाया जाएगा।",
                "Most students pick Hindi. Choosing Urdu/Maithili/Bangla automatically recommends Non-Hindi as SIL."
              )}
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
              {data.groups910.mil.map((sub) => {
                const selected = milId === sub.id;
                return (
                  <button
                    key={sub.id}
                    type="button"
                    onClick={() => handleSelectMil(sub)}
                    className={cn(
                      "flex items-center justify-between gap-3 rounded-lg border px-4 py-3 text-left transition-all min-h-[54px]",
                      selected
                        ? "border-indigo-academic bg-indigo-soft ring-2 ring-indigo-academic/20"
                        : "border-hairline bg-surface hover:bg-surface-subtle"
                    )}
                  >
                    <div className="min-w-0">
                      <div className="font-semibold text-sm text-ink">
                        <BiText hi={sub.name_hi} en={sub.name_en} />
                      </div>
                      <div className="text-xs text-ink-muted">{t("कोड", "Code")}: {sub.bseb_code}</div>
                    </div>
                    <span
                      className={cn(
                        "h-5 w-5 rounded-full border flex items-center justify-center shrink-0",
                        selected
                          ? "bg-indigo-academic border-indigo-academic text-white"
                          : "border-hairline-strong"
                      )}
                    >
                      {selected && <Check className="h-3.5 w-3.5" />}
                    </span>
                  </button>
                );
              })}
            </div>
          </Card>

          {/* SIL Selection */}
          <Card>
            <h2 className="text-base font-bold text-ink mb-1">
              <BiText
                hi="3. द्वितीय भारतीय भाषा (SIL) चुनें — कोई 1"
                en="3. Choose Second Indian Language (SIL) — Pick 1"
              />
            </h2>
            <p className="text-xs sm:text-sm text-ink-secondary mb-3.5">
              {t(
                "केवल आपकी मातृभाषा के साथ बिहार बोर्ड द्वारा मान्य भाषाएँ दिखाई जा रही हैं।",
                "Only official Bihar Board combinations compatible with your MIL are shown."
              )}
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
              {allowedSils.map((sub) => {
                const selected = silId === sub.id;
                return (
                  <button
                    key={sub.id}
                    type="button"
                    onClick={() => {
                      setSilId(sub.id);
                      setErrorMsg(null);
                    }}
                    className={cn(
                      "flex items-center justify-between gap-3 rounded-lg border px-4 py-3 text-left transition-all min-h-[54px]",
                      selected
                        ? "border-indigo-academic bg-indigo-soft ring-2 ring-indigo-academic/20"
                        : "border-hairline bg-surface hover:bg-surface-subtle"
                    )}
                  >
                    <div className="min-w-0">
                      <div className="font-semibold text-sm text-ink">
                        <BiText hi={sub.name_hi} en={sub.name_en} />
                      </div>
                      <div className="text-xs text-ink-muted">{t("कोड", "Code")}: {sub.bseb_code}</div>
                    </div>
                    <span
                      className={cn(
                        "h-5 w-5 rounded-full border flex items-center justify-center shrink-0",
                        selected
                          ? "bg-indigo-academic border-indigo-academic text-white"
                          : "border-hairline-strong"
                      )}
                    >
                      {selected && <Check className="h-3.5 w-3.5" />}
                    </span>
                  </button>
                );
              })}
            </div>
          </Card>

          {/* Optional Skill / ICT */}
          {data.groups910.skill.length > 0 && (
            <Card variant="subtle">
              <h2 className="text-sm font-bold text-ink mb-2">
                <BiText
                  hi="4. ऐच्छिक कौशल विषय (वैकल्पिक — यदि स्कूल में हो)"
                  en="4. Optional Vocational / ICT Subject (Optional)"
                />
              </h2>
              <div className="flex flex-wrap gap-2.5">
                {data.groups910.skill.map((sub) => {
                  const selected = skillId === sub.id;
                  return (
                    <button
                      key={sub.id}
                      type="button"
                      onClick={() => setSkillId(selected ? "" : sub.id)}
                      className={cn(
                        "inline-flex items-center gap-2 rounded-lg border px-3.5 py-2.5 text-sm font-medium transition-all",
                        selected
                          ? "border-emerald-mastery bg-emerald-soft text-emerald-ink"
                          : "border-hairline bg-surface text-ink-secondary hover:text-ink"
                      )}
                    >
                      <SubjectIcon name={sub.icon_name} className="h-4 w-4" />
                      <BiText hi={sub.name_hi} en={sub.name_en} inline />
                      {selected && <Check className="h-4 w-4" />}
                    </button>
                  );
                })}
              </div>
            </Card>
          )}
        </>
      )}

      {/* ==================== CLASS 11 & 12 WIZARD ==================== */}
      {!isSecondary && data.groups1112ByStream && (
        <>
          {/* Step 1: Stream */}
          <Card>
            <h2 className="text-base font-bold text-ink mb-1">
              <BiText
                hi="चरण 1: अपना संकाय (Stream) चुनें"
                en="Step 1: Choose Your Intermediate Stream"
              />
            </h2>
            <p className="text-xs sm:text-sm text-ink-secondary mb-4">
              {t(
                "अपना संकाय चुनते ही बिहार बोर्ड के संबंधित विषय नीचे दिखाई देंगे।",
                "Select your stream to view matching Bihar Board Intermediate subjects."
              )}
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
              {(
                [
                  {
                    key: "Science" as const,
                    hi: "विज्ञान (Science)",
                    en: "Science",
                    descHi: "भौतिकी, रसायन, गणित / जीव विज्ञान",
                    descEn: "Physics, Chemistry, Math / Biology",
                    icon: FlaskConical,
                  },
                  {
                    key: "Arts" as const,
                    hi: "कला (Arts)",
                    en: "Arts",
                    descHi: "इतिहास, भूगोल, राजनीति, अर्थशास्त्र",
                    descEn: "History, Geography, Pol. Sci., Economics",
                    icon: Landmark,
                  },
                  {
                    key: "Commerce" as const,
                    hi: "वाणिज्य (Commerce)",
                    en: "Commerce",
                    descHi: "लेखाशास्त्र, व्यवसाय, उद्यमिता, अर्थशास्त्र",
                    descEn: "Accountancy, Business, Entrepreneurship",
                    icon: TrendingUp,
                  },
                ] as const
              ).map((item) => {
                const Icon = item.icon;
                const active = stream === item.key;
                return (
                  <button
                    key={item.key}
                    type="button"
                    onClick={() => handleSelectStream(item.key)}
                    className={cn(
                      "rounded-paper border p-4 text-left transition-all flex flex-col gap-2",
                      active
                        ? "border-indigo-academic bg-indigo-soft ring-2 ring-indigo-academic/20"
                        : "border-hairline bg-surface hover:bg-surface-subtle"
                    )}
                  >
                    <div className="flex items-center justify-between">
                      <span className="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-surface border border-hairline text-indigo-ink">
                        <Icon className="h-5 w-5" />
                      </span>
                      {active && <CheckCircle2 className="h-5 w-5 text-indigo-ink" />}
                    </div>
                    <div className="font-bold text-sm text-ink">
                      <BiText hi={item.hi} en={item.en} />
                    </div>
                    <div className="text-xs text-ink-secondary">
                      <BiText hi={item.descHi} en={item.descEn} />
                    </div>
                  </button>
                );
              })}
            </div>
          </Card>

          {/* Step 2: Languages + 3 Electives + 1 Optional Additional */}
          {active1112Group && (
            <>
              <Card>
                <h2 className="text-base font-bold text-ink mb-3">
                  <BiText
                    hi="चरण 2: दो अनिवार्य भाषाएँ चुनें (भाषा-1 और भाषा-2 अलग हों)"
                    en="Step 2: Choose 2 Distinct Compulsory Languages"
                  />
                </h2>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                  <div>
                    <div className="text-xs font-bold uppercase tracking-wider text-ink-muted mb-2">
                      {t("प्रथम भाषा (Language 1)", "Compulsory Language 1")}
                    </div>
                    <div className="space-y-2">
                      {active1112Group.lang1.map((sub) => {
                        const selected = lang1Id === sub.id;
                        return (
                          <button
                            key={sub.id}
                            type="button"
                            onClick={() => {
                              setLang1Id(sub.id);
                              if (
                                lang2Id &&
                                normalizeSubjectKey(sub.name_en) ===
                                  normalizeSubjectKey(
                                    active1112Group.lang2.find((l) => l.id === lang2Id)?.name_en ?? ""
                                  )
                              ) {
                                setLang2Id("");
                              }
                            }}
                            className={cn(
                              "w-full flex items-center justify-between rounded-lg border px-3.5 py-2.5 text-sm font-semibold transition-all",
                              selected
                                ? "border-indigo-academic bg-indigo-soft text-indigo-ink"
                                : "border-hairline bg-surface text-ink hover:bg-surface-subtle"
                            )}
                          >
                            <BiText hi={sub.name_hi} en={sub.name_en} inline />
                            {selected && <Check className="h-4 w-4" />}
                          </button>
                        );
                      })}
                    </div>
                  </div>

                  <div>
                    <div className="text-xs font-bold uppercase tracking-wider text-ink-muted mb-2">
                      {t("द्वितीय भाषा (Language 2)", "Compulsory Language 2")}
                    </div>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                      {active1112Group.lang2.map((sub) => {
                        const sameAsLang1 =
                          Boolean(lang1Canonical) &&
                          normalizeSubjectKey(sub.name_en) === lang1Canonical;
                        const selected = lang2Id === sub.id;
                        return (
                          <button
                            key={sub.id}
                            type="button"
                            disabled={sameAsLang1}
                            onClick={() => setLang2Id(sub.id)}
                            className={cn(
                              "flex items-center justify-between rounded-lg border px-3 py-2.5 text-xs sm:text-sm font-medium text-left transition-all",
                              sameAsLang1 && "opacity-40 cursor-not-allowed bg-surface-subtle",
                              selected
                                ? "border-indigo-academic bg-indigo-soft text-indigo-ink font-semibold"
                                : "border-hairline bg-surface text-ink hover:bg-surface-subtle"
                            )}
                          >
                            <BiText hi={sub.name_hi} en={sub.name_en} />
                            {selected && <Check className="h-4 w-4 shrink-0" />}
                          </button>
                        );
                      })}
                    </div>
                  </div>
                </div>
              </Card>

              <Card>
                <div className="flex flex-wrap items-center justify-between gap-2 mb-3">
                  <div>
                    <h2 className="text-base font-bold text-ink">
                      <BiText
                        hi="चरण 3: अपने 3 मुख्य ऐच्छिक विषय चुनें"
                        en="Step 3: Choose Exactly 3 Core Stream Electives"
                      />
                    </h2>
                  </div>
                  <Badge variant={electiveIds.length === 3 ? "emerald" : "amber"}>
                    {electiveIds.length} / 3 {t("चुने गए", "Selected")}
                  </Badge>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2.5">
                  {active1112Group.electives.map((sub) => {
                    const selected = electiveIds.includes(sub.id);
                    return (
                      <button
                        key={sub.id}
                        type="button"
                        onClick={() => toggleElective(sub.id)}
                        className={cn(
                          "flex items-center justify-between gap-2.5 rounded-lg border px-3.5 py-3 text-left transition-all",
                          selected
                            ? "border-indigo-academic bg-indigo-soft ring-2 ring-indigo-academic/20"
                            : "border-hairline bg-surface hover:bg-surface-subtle"
                        )}
                      >
                        <div className="flex items-center gap-2.5 min-w-0">
                          <span
                            className="inline-flex h-8 w-8 items-center justify-center rounded-lg text-white shrink-0"
                            style={{ backgroundColor: sub.accent_color }}
                          >
                            <SubjectIcon name={sub.icon_name} className="h-4 w-4" />
                          </span>
                          <div className="min-w-0">
                            <div className="font-semibold text-sm text-ink truncate">
                              <BiText hi={sub.name_hi} en={sub.name_en} />
                            </div>
                            <div className="text-[11px] text-ink-muted">
                              {t("कोड", "Code")}: {sub.bseb_code}
                            </div>
                          </div>
                        </div>
                        {selected && <CheckCircle2 className="h-4 w-4 text-indigo-ink shrink-0" />}
                      </button>
                    );
                  })}
                </div>
              </Card>

              <Card variant="subtle">
                <h2 className="text-sm font-bold text-ink mb-1">
                  <BiText
                    hi="चरण 4: अतिरिक्त 6ठा विषय (वैकल्पिक — 0 या 1)"
                    en="Step 4: Optional 6th Additional Subject (0 or 1)"
                  />
                </h2>
                <p className="text-xs text-ink-secondary mb-3">
                  {t(
                    "यह पहले चुने गए 5 विषयों से अलग होना चाहिए। चाहें तो इसे खाली छोड़ सकते हैं।",
                    "Must not overlap with your 5 subjects above. Leave unselected if you do not take a 6th subject."
                  )}
                </p>
                <div className="flex flex-wrap gap-2">
                  {active1112Group.additional
                    .filter((sub) => !chosenCanonKeysForAdditional.has(normalizeSubjectKey(sub.name_en)))
                    .map((sub) => {
                      const selected = additionalId === sub.id;
                      return (
                        <button
                          key={sub.id}
                          type="button"
                          onClick={() => setAdditionalId(selected ? "" : sub.id)}
                          className={cn(
                            "inline-flex items-center gap-2 rounded-lg border px-3 py-2 text-xs sm:text-sm font-medium transition-all",
                            selected
                              ? "border-emerald-mastery bg-emerald-soft text-emerald-ink font-semibold"
                              : "border-hairline bg-surface text-ink-secondary hover:text-ink"
                          )}
                        >
                          <BookOpen className="h-3.5 w-3.5" />
                          <BiText hi={sub.name_hi} en={sub.name_en} inline />
                          {selected && <Check className="h-3.5 w-3.5" />}
                        </button>
                      );
                    })}
                </div>
              </Card>
            </>
          )}
        </>
      )}

      {/* Error & Submit Bar */}
      {errorMsg && (
        <div
          role="alert"
          className="rounded-lg border border-crimson-alert/30 bg-crimson-soft px-4 py-3 text-sm font-medium text-crimson-ink flex items-start gap-2.5"
        >
          <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" />
          <span>{errorMsg}</span>
        </div>
      )}

      <div className="flex flex-wrap items-center justify-end gap-3 pt-2">
        <Button
          size="lg"
          variant="primary"
          loading={saving}
          onClick={handleSubmit}
          leftIcon={<Sparkles className="h-4 w-4" />}
        >
          {mode === "onboarding"
            ? t("मेरे विषय सहेजें और पढ़ाई शुरू करें", "Save My Subjects & Start Studying")
            : t("विषय बदलाव सुरक्षित करें", "Save Subject Changes")}
        </Button>
      </div>
    </div>
  );
}
