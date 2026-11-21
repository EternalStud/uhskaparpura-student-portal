"use client";

import React, { useState } from "react";
import {
  AlertTriangle,
  CheckCircle2,
  FileSpreadsheet,
  Lock,
  RefreshCw,
  ShieldCheck,
  Upload,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
  Tabs,
  useToast,
} from "@/components/ui";

type SyncMode = "STUDENTS" | "TEACHERS";

interface SyncPreviewResponse {
  ok: boolean;
  syncType: SyncMode;
  targetSchoolName?: string;
  schoolNameMatched?: boolean;
  udiseMatched?: boolean;
  discardedSensitiveColumns?: string[];
  summary?: {
    toAdd: number;
    toUpdate: number;
    unchanged: number;
    missingActive: number;
    crossSchoolConflicts: number;
    skippedClass1To8?: number;
    skippedInvalid?: number;
    blockedAdminDeactivations?: number;
    canDeactivateAllMissing?: boolean;
  };
  preview?: {
    toAdd: Array<Record<string, unknown>>;
    toUpdate: Array<Record<string, unknown>>;
    missingActive: Array<Record<string, unknown>>;
    crossSchoolConflicts: Array<{
      row_number: number;
      code: string;
      name: string;
      reason: string;
      existing_school_udise?: string;
    }>;
  };
  errors?: string[];
  warnings?: string[];
}

export default function SchoolSyncPage() {
  const { t } = useLanguage();
  const toast = useToast();

  const [mode, setMode] = useState<SyncMode>("STUDENTS");
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<SyncPreviewResponse | null>(null);
  const [previewing, setPreviewing] = useState(false);
  const [committing, setCommitting] = useState(false);
  const [deactivateMissing, setDeactivateMissing] = useState(false);
  const [confirmMismatch, setConfirmMismatch] = useState(false);

  const handleModeChange = (next: SyncMode) => {
    setMode(next);
    setFile(null);
    setPreview(null);
    setDeactivateMissing(false);
    setConfirmMismatch(false);
  };

  const handlePreview = async () => {
    if (!file) {
      toast.warning(t("कृपया .xlsx फ़ाइल चुनें।", "Please choose an .xlsx file first."));
      return;
    }

    setPreviewing(true);
    setPreview(null);
    try {
      const formData = new FormData();
      formData.append("syncType", mode);
      formData.append("file", file);

      const res = await fetch("/api/school/sync/preview", {
        method: "POST",
        headers: { "X-Requested-With": "XMLHttpRequest" },
        body: formData,
      });

      const data = (await res.json()) as SyncPreviewResponse & { error?: string };
      if (!res.ok && !data.errors) {
        toast.error(
          t("फ़ाइल की जांच विफल रही", "File check failed"),
          data.error
        );
        return;
      }
      setPreview(data);
    } catch {
      toast.error(t("नेटवर्क त्रुटि हुई", "Network error occurred"));
    } finally {
      setPreviewing(false);
    }
  };

  const handleCommit = async () => {
    if (!file || !preview?.ok) return;
    setCommitting(true);
    try {
      const formData = new FormData();
      formData.append("syncType", mode);
      formData.append("file", file);
      formData.append("deactivateMissing", String(deactivateMissing));
      formData.append("confirmSchoolNameMismatch", String(confirmMismatch));

      const res = await fetch("/api/school/sync/commit", {
        method: "POST",
        headers: { "X-Requested-With": "XMLHttpRequest" },
        body: formData,
      });

      const data = (await res.json()) as {
        ok?: boolean;
        addedCount?: number;
        updatedCount?: number;
        deactivatedCount?: number;
        error?: string;
      };

      if (!res.ok || !data.ok) {
        toast.error(
          t("अपडेट सहेजा नहीं जा सका", "Could not apply update"),
          data.error
        );
        return;
      }

      toast.success(
        t("सूची सफलतापूर्वक अपडेट हो गई", "Roster updated successfully"),
        t(
          `${data.addedCount ?? 0} नए जोड़े गए, ${data.updatedCount ?? 0} अपडेट हुए, ${data.deactivatedCount ?? 0} निष्क्रिय किए गए।`,
          `Added ${data.addedCount ?? 0}, updated ${data.updatedCount ?? 0}, deactivated ${data.deactivatedCount ?? 0}.`
        )
      );
      setPreview(null);
      setFile(null);
      setDeactivateMissing(false);
      setConfirmMismatch(false);
    } catch {
      toast.error(t("नेटवर्क त्रुटि हुई", "Network error occurred"));
    } finally {
      setCommitting(false);
    }
  };

  const needsMismatchConfirm =
    mode === "STUDENTS" && preview?.schoolNameMatched === false;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-ink">
          {t("विद्यालय सूची अपडेट (सुरक्षित पूर्वावलोकन)", "School Roster Update (Safe Dry-Run)")}
        </h1>
        <p className="mt-1 text-sm text-ink-secondary">
          {t(
            "आधिकारिक विद्यालय स्प्रेडशीट (.xlsx) अपलोड करके पहले सभी बदलाव जांचें, फिर पुष्टि करें। छात्रों की पढ़ाई की प्रगति और विषय सुरक्षित रहते हैं।",
            "Upload your official school roster spreadsheet (.xlsx) to review every change before applying. Existing student progress and subjects are preserved."
          )}
        </p>
      </div>

      <Tabs<SyncMode>
        value={mode}
        onChange={handleModeChange}
        variant="pills"
        items={[
          {
            id: "STUDENTS",
            label: t("विद्यार्थी सूची (कक्षा 9–12)", "Student Roster (Class 9–12)"),
          },
          {
            id: "TEACHERS",
            label: t("शिक्षक सूची", "Staff Roster"),
          },
        ]}
      />

      {/* Privacy & Security Guarantee Banner */}
      <Card variant="subtle" padding="sm">
        <div className="flex items-start gap-3 text-xs sm:text-sm text-ink-secondary">
          <Lock className="h-4 w-4 text-emerald-ink shrink-0 mt-0.5" />
          <p>
            {mode === "STUDENTS"
              ? t(
                  "गोपनीयता सुरक्षा: आधार संख्या और सामाजिक श्रेणी जैसे संवेदनशील कॉलम तुरंत मेमोरी में हटा दिए जाते हैं — इन्हें कभी संग्रहीत नहीं किया जाता। कक्षा 1–8 की पंक्तियाँ स्वतः छोड़ दी जाती हैं।",
                  "Privacy safeguard: sensitive columns such as Aadhaar Number and Social Category are discarded immediately and never stored. Class 1–8 rows are skipped cleanly."
                )
              : t(
                  "गोपनीयता सुरक्षा: शिक्षकों का पूरा मोबाइल नंबर कभी सहेजा नहीं जाता; केवल प्रथम लॉगिन सत्यापन हेतु अंतिम 4 अंक सुरक्षित रूप से उपयोग होते हैं।",
                  "Privacy safeguard: full teacher mobile numbers are never stored in plaintext; only masked last-4 verification digits are retained."
                )}
          </p>
        </div>
      </Card>

      {/* File Upload Card */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <FileSpreadsheet className="h-5 w-5 text-indigo-ink" />
            {mode === "STUDENTS"
              ? t("आधिकारिक विद्यार्थी फ़ाइल (.xlsx) चुनें", "Select Official Student Roster (.xlsx)")
              : t("आधिकारिक शिक्षक फ़ाइल (.xlsx) चुनें", "Select Official Staff Roster (.xlsx)")}
          </CardTitle>
          <CardDescription>
            {t(
              "कृपया मूल .xlsx फ़ाइल ही अपलोड करें (बिना संपादित किए) ताकि छात्र/शिक्षक कोड खराब न हों।",
              "Upload the original unmodified .xlsx file so student/teacher identification codes stay intact."
            )}
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:items-center gap-3">
            <label className="flex-1 flex items-center gap-3 rounded-lg border border-dashed border-hairline-strong bg-surface-subtle px-4 py-3 cursor-pointer hover:border-indigo-academic transition-colors">
              <Upload className="h-5 w-5 text-indigo-ink shrink-0" />
              <span className="text-sm text-ink truncate">
                {file
                  ? `${file.name} (${Math.max(1, Math.round(file.size / 1024))} KB)`
                  : t("यहाँ क्लिक करके .xlsx फ़ाइल चुनें...", "Click here to choose an .xlsx file...")}
              </span>
              <input
                type="file"
                accept=".xlsx,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                className="sr-only"
                onChange={(e) => {
                  const chosen = e.target.files?.[0] ?? null;
                  setFile(chosen);
                  setPreview(null);
                }}
              />
            </label>
            <Button
              variant="primary"
              loading={previewing}
              disabled={!file}
              onClick={handlePreview}
              leftIcon={<RefreshCw className="h-4 w-4" />}
            >
              {t("बदलाव जांचें (Dry-Run)", "Preview Changes")}
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Dry-Run Preview Results */}
      {preview && (
        <Card>
          <CardHeader>
            <div className="flex flex-wrap items-center justify-between gap-2">
              <CardTitle>
                {t("पूर्वावलोकन परिणाम (अभी कोई बदलाव सहेजा नहीं गया)", "Dry-Run Preview (No Changes Applied Yet)")}
              </CardTitle>
              {preview.ok ? (
                <Badge variant="emerald" icon={<CheckCircle2 className="h-3.5 w-3.5" />}>
                  {t("सत्यापन सफल", "Validation Passed")}
                </Badge>
              ) : (
                <Badge variant="crimson" icon={<AlertTriangle className="h-3.5 w-3.5" />}>
                  {t("सुधार आवश्यक", "Action Required")}
                </Badge>
              )}
            </div>
          </CardHeader>

          <CardContent className="space-y-5">
            {/* Errors */}
            {preview.errors && preview.errors.length > 0 && (
              <div className="rounded-lg border border-crimson-alert/30 bg-crimson-soft p-4 space-y-1.5">
                <p className="text-sm font-bold text-crimson-ink">
                  {t("फ़ाइल में त्रुटियाँ मिलीं:", "Validation Errors Found:")}
                </p>
                <ul className="list-disc pl-5 text-xs text-crimson-ink space-y-1">
                  {preview.errors.map((err, idx) => (
                    <li key={idx}>{err}</li>
                  ))}
                </ul>
              </div>
            )}

            {/* Warnings */}
            {preview.warnings && preview.warnings.length > 0 && (
              <div className="rounded-lg border border-amber-warm/30 bg-amber-soft p-4 space-y-1.5">
                <p className="text-sm font-bold text-amber-ink">
                  {t("ध्यान दें:", "Notices & Warnings:")}
                </p>
                <ul className="list-disc pl-5 text-xs text-amber-ink space-y-1">
                  {preview.warnings.map((w, idx) => (
                    <li key={idx}>{w}</li>
                  ))}
                </ul>
              </div>
            )}

            {/* Diff Summary Tiles */}
            {preview.summary && (
              <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
                <div className="rounded-lg border border-emerald-mastery/30 bg-emerald-soft p-3">
                  <p className="text-xs font-semibold text-emerald-ink">{t("नए जोड़ें", "To Add")}</p>
                  <p className="mt-1 text-2xl font-bold text-ink">+{preview.summary.toAdd}</p>
                </div>
                <div className="rounded-lg border border-indigo-academic/25 bg-indigo-soft p-3">
                  <p className="text-xs font-semibold text-indigo-ink">{t("अपडेट होंगे", "To Update")}</p>
                  <p className="mt-1 text-2xl font-bold text-ink">~{preview.summary.toUpdate}</p>
                </div>
                <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                  <p className="text-xs font-semibold text-ink-secondary">{t("अपरिवर्तित", "Unchanged")}</p>
                  <p className="mt-1 text-2xl font-bold text-ink">{preview.summary.unchanged}</p>
                </div>
                <div className="rounded-lg border border-amber-warm/30 bg-amber-soft p-3">
                  <p className="text-xs font-semibold text-amber-ink">{t("सूची में नहीं", "Missing Active")}</p>
                  <p className="mt-1 text-2xl font-bold text-ink">{preview.summary.missingActive}</p>
                </div>
                <div className="rounded-lg border border-crimson-alert/30 bg-crimson-soft p-3">
                  <p className="text-xs font-semibold text-crimson-ink">{t("अन्य विद्यालय संघर्ष", "Conflicts")}</p>
                  <p className="mt-1 text-2xl font-bold text-ink">
                    {preview.summary.crossSchoolConflicts}
                  </p>
                </div>
                {mode === "STUDENTS" && (
                  <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                    <p className="text-xs font-semibold text-ink-secondary">{t("कक्षा 1–8 छोड़े", "Class 1–8 Skipped")}</p>
                    <p className="mt-1 text-2xl font-bold text-ink">
                      {preview.summary.skippedClass1To8 ?? 0}
                    </p>
                  </div>
                )}
              </div>
            )}

            {/* Discarded Sensitive Columns Notice */}
            {preview.discardedSensitiveColumns && preview.discardedSensitiveColumns.length > 0 && (
              <div className="flex items-center gap-2 text-xs text-emerald-ink">
                <ShieldCheck className="h-4 w-4 shrink-0" />
                <span>
                  {t("गोपनीय कॉलम सुरक्षित रूप से हटाए गए:", "Sensitive columns excluded automatically:")}{" "}
                  {preview.discardedSensitiveColumns.join(", ")}
                </span>
              </div>
            )}

            {/* Conflicts Table */}
            {preview.preview && preview.preview.crossSchoolConflicts.length > 0 && (
              <div className="space-y-2">
                <h3 className="text-sm font-bold text-crimson-ink">
                  {t(
                    "अन्य विद्यालय में सक्रिय खाते (स्वतः छोड़े जाएंगे)",
                    "Active Accounts at Another School (Automatically Skipped)"
                  )}
                </h3>
                <div className="overflow-x-auto rounded-lg border border-hairline">
                  <table className="w-full text-left text-xs">
                    <thead className="bg-surface-subtle text-ink-secondary border-b border-hairline">
                      <tr>
                        <th className="px-3 py-2">{t("पंक्ति", "Row")}</th>
                        <th className="px-3 py-2">{t("कोड", "Code")}</th>
                        <th className="px-3 py-2">{t("नाम", "Name")}</th>
                        <th className="px-3 py-2">{t("कारण", "Reason")}</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-hairline">
                      {preview.preview.crossSchoolConflicts.map((c, i) => (
                        <tr key={i}>
                          <td className="px-3 py-2">{c.row_number}</td>
                          <td className="px-3 py-2 font-mono">{c.code}</td>
                          <td className="px-3 py-2">{c.name}</td>
                          <td className="px-3 py-2 text-crimson-ink">{c.reason}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* Explicit Confirmations & Commit Action */}
            {preview.ok && preview.summary && (
              <div className="space-y-3 pt-4 border-t border-hairline">
                {preview.summary.missingActive > 0 && (
                  <label className="flex items-start gap-2.5 text-sm text-ink cursor-pointer">
                    <input
                      type="checkbox"
                      checked={deactivateMissing}
                      onChange={(e) => setDeactivateMissing(e.target.checked)}
                      className="mt-1 h-4 w-4 rounded border-hairline-strong text-indigo-academic"
                    />
                    <span>
                      {t(
                        `नई सूची में अनुपस्थित ${preview.summary.missingActive} सक्रिय खातों को निष्क्रिय करें (अंतिम सक्रिय विद्यालय व्यवस्थापक सुरक्षित रहेंगे)।`,
                        `Deactivate ${preview.summary.missingActive} active accounts absent from this file (last active School Admin is always protected).`
                      )}
                    </span>
                  </label>
                )}

                {needsMismatchConfirm && (
                  <label className="flex items-start gap-2.5 text-sm text-amber-ink cursor-pointer">
                    <input
                      type="checkbox"
                      checked={confirmMismatch}
                      onChange={(e) => setConfirmMismatch(e.target.checked)}
                      className="mt-1 h-4 w-4 rounded border-hairline-strong"
                    />
                    <span>
                      {t(
                        "मैं पुष्टि करता/करती हूँ कि यह फ़ाइल इसी विद्यालय की है।",
                        "I confirm that this uploaded roster belongs to this school."
                      )}
                    </span>
                  </label>
                )}

                <div className="flex flex-wrap items-center justify-end gap-3 pt-2">
                  <Button
                    variant="secondary"
                    onClick={() => setPreview(null)}
                    disabled={committing}
                  >
                    {t("रद्द करें", "Cancel")}
                  </Button>
                  <Button
                    variant="emerald"
                    loading={committing}
                    disabled={needsMismatchConfirm && !confirmMismatch}
                    onClick={handleCommit}
                    leftIcon={<CheckCircle2 className="h-4 w-4" />}
                  >
                    {t("पुष्टि करें और अपडेट सहेजें", "Confirm & Apply Update")}
                  </Button>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  );
}
