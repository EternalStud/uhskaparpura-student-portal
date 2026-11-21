"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  AlertTriangle,
  ArrowRight,
  Building2,
  CheckCircle2,
  FileSpreadsheet,
  Lock,
  Shield,
  Upload,
} from "lucide-react";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
  Input,
  useToast,
} from "@/components/ui";

interface OnboardPreviewData {
  ok: boolean;
  schoolMeta: {
    udiseCode: string | null;
    schoolName: string;
    districtCode: string | null;
    districtName: string | null;
    blockCode: string | null;
    blockName: string | null;
    clusterCode: string | null;
    clusterName: string | null;
  };
  existingSchool: { udise_code: string; school_name: string; status: string } | null;
  schoolNameMatch: { matched: boolean; tokenOverlap: number };
  teacherStats: {
    parsedTeachers: number;
    withValidMobileLast4: number;
  };
  studentStats: {
    parsedClass9To12: number;
    skippedClass1To8: number;
    classBreakdown: Record<string, number>;
  };
  discardedSensitiveColumns: string[];
  teachers: Array<{
    teacherCode: string;
    fullName: string;
    teacherTitle: string | null;
    maskedMobile: string | null;
    suggestedAdmin: boolean;
  }>;
  errors: string[];
  warnings: string[];
}

export function OnboardWizardClient() {
  const toast = useToast();

  const [step, setStep] = useState<1 | 2 | 3>(1);
  const [teacherFile, setTeacherFile] = useState<File | null>(null);
  const [studentFile, setStudentFile] = useState<File | null>(null);
  const [schoolNameHi, setSchoolNameHi] = useState("");
  const [preview, setPreview] = useState<OnboardPreviewData | null>(null);
  const [selectedAdmins, setSelectedAdmins] = useState<string[]>([]);
  const [activateImmediately, setActivateImmediately] = useState(true);
  const [confirmMismatch, setConfirmMismatch] = useState(false);

  const [loadingPreview, setLoadingPreview] = useState(false);
  const [committing, setCommitting] = useState(false);
  const [commitResult, setCommitResult] = useState<{
    school: { udiseCode: string; schoolName: string; status: string; vaultProvisioned: boolean };
    summary: {
      teachersAdded: number;
      teachersUpdated: number;
      studentsAdded: number;
      studentsUpdated: number;
      skippedClass1To8: number;
      conflictsCount: number;
    };
  } | null>(null);

  const runPreview = async () => {
    if (!teacherFile || !studentFile) {
      toast.warning("Select both Teacher List (.xlsx) and Student List (.xlsx)");
      return;
    }

    setLoadingPreview(true);
    try {
      const formData = new FormData();
      formData.append("teacherFile", teacherFile);
      formData.append("studentFile", studentFile);

      const res = await fetch("/api/super-admin/onboard/preview", {
        method: "POST",
        headers: { "X-Requested-With": "XMLHttpRequest" },
        body: formData,
      });

      const data = (await res.json()) as OnboardPreviewData & { error?: string };
      if (!res.ok && !data.errors) {
        toast.error("Preview failed", data.error);
        return;
      }

      setPreview(data);
      const suggested = (data.teachers ?? [])
        .filter((t) => t.suggestedAdmin)
        .map((t) => t.teacherCode);
      setSelectedAdmins(
        suggested.length > 0
          ? suggested
          : data.teachers?.[0]
          ? [data.teachers[0].teacherCode]
          : []
      );
      setStep(2);
    } catch {
      toast.error("Network error while analyzing Excel files");
    } finally {
      setLoadingPreview(false);
    }
  };

  const toggleAdminCode = (code: string) => {
    setSelectedAdmins((prev) =>
      prev.includes(code) ? prev.filter((c) => c !== code) : [...prev, code]
    );
  };

  const commitOnboarding = async () => {
    if (!teacherFile || !studentFile || selectedAdmins.length === 0) return;

    setCommitting(true);
    try {
      const formData = new FormData();
      formData.append("teacherFile", teacherFile);
      formData.append("studentFile", studentFile);
      formData.append("adminTeacherCodes", JSON.stringify(selectedAdmins));
      formData.append("schoolNameHi", schoolNameHi);
      formData.append("activateImmediately", String(activateImmediately));
      formData.append("confirmSchoolNameMismatch", String(confirmMismatch));

      const res = await fetch("/api/super-admin/onboard/commit", {
        method: "POST",
        headers: { "X-Requested-With": "XMLHttpRequest" },
        body: formData,
      });

      const json = (await res.json()) as typeof commitResult & {
        ok?: boolean;
        error?: string;
      };
      if (!res.ok || !json.ok || !json.school || !json.summary) {
        toast.error("Onboarding commit failed", json.error);
        return;
      }

      setCommitResult({ school: json.school, summary: json.summary });
      setStep(3);
      toast.success("School onboarded successfully!");
    } catch {
      toast.error("Network error during onboarding commit");
    } finally {
      setCommitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-4xl">
      <div>
        <Badge variant="indigo">3-Step School Onboarding Wizard</Badge>
        <h1 className="mt-2 text-2xl font-bold text-ink">
          Onboard a Bihar Government School (Class 9–12)
        </h1>
        <p className="mt-1 text-sm text-ink-secondary">
          Upload e-Shikshakosh Teacher & Student Excels. Authoritative 11-digit UDISE, District, Block, and Cluster are extracted automatically while Aadhaar & Social Category are discarded in memory.
        </p>
      </div>

      {/* Stepper */}
      <div className="grid grid-cols-3 gap-3">
        {[
          { num: 1, label: "1. Upload Excel Files" },
          { num: 2, label: "2. Verify & Pick Admins" },
          { num: 3, label: "3. School Activated" },
        ].map((item) => (
          <div
            key={item.num}
            className={`rounded-lg border px-3.5 py-2.5 text-xs font-semibold ${
              step === item.num
                ? "border-indigo-academic bg-indigo-soft text-indigo-ink"
                : step > item.num
                ? "border-emerald-mastery/40 bg-emerald-soft text-emerald-ink"
                : "border-hairline bg-surface-subtle text-ink-muted"
            }`}
          >
            {item.label}
          </div>
        ))}
      </div>

      {/* STEP 1 */}
      {step === 1 && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileSpreadsheet className="h-5 w-5 text-indigo-ink" />
              Step 1: Select Authoritative e-Shikshakosh Exports
            </CardTitle>
            <CardDescription>
              Teacher List provides the authoritative 11-digit UDISE code. Student List provides Class 9–12 enrollment (Class 1–8 skipped cleanly).
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <label className="flex flex-col gap-2 rounded-paper border border-dashed border-hairline-strong bg-surface-subtle p-4 cursor-pointer hover:border-indigo-academic">
                <span className="text-xs font-bold uppercase tracking-wider text-ink-secondary">
                  Teacher List (.xlsx) *
                </span>
                <div className="flex items-center gap-2 text-sm text-ink">
                  <Upload className="h-4 w-4 text-indigo-ink shrink-0" />
                  <span className="truncate">
                    {teacherFile ? teacherFile.name : "Choose Teacher_List_*.xlsx"}
                  </span>
                </div>
                <input
                  type="file"
                  accept=".xlsx"
                  className="sr-only"
                  onChange={(e) => setTeacherFile(e.target.files?.[0] ?? null)}
                />
              </label>

              <label className="flex flex-col gap-2 rounded-paper border border-dashed border-hairline-strong bg-surface-subtle p-4 cursor-pointer hover:border-indigo-academic">
                <span className="text-xs font-bold uppercase tracking-wider text-ink-secondary">
                  Student List (.xlsx) *
                </span>
                <div className="flex items-center gap-2 text-sm text-ink">
                  <Upload className="h-4 w-4 text-indigo-ink shrink-0" />
                  <span className="truncate">
                    {studentFile ? studentFile.name : "Choose Student_*.xlsx"}
                  </span>
                </div>
                <input
                  type="file"
                  accept=".xlsx"
                  className="sr-only"
                  onChange={(e) => setStudentFile(e.target.files?.[0] ?? null)}
                />
              </label>
            </div>

            <Input
              label="Hindi School Name (Optional Display Override)"
              placeholder="e.g. उच्च माध्यमिक विद्यालय कपरपुरा, कांटी, मुजफ्फरपुर"
              value={schoolNameHi}
              onChange={(e) => setSchoolNameHi(e.target.value)}
            />

            <div className="flex items-center justify-between pt-2">
              <span className="text-xs text-emerald-ink flex items-center gap-1.5">
                <Lock className="h-3.5 w-3.5" />
                Zero Aadhaar, Social Category, or plaintext mobile stored.
              </span>
              <Button
                variant="primary"
                loading={loadingPreview}
                disabled={!teacherFile || !studentFile}
                rightIcon={<ArrowRight className="h-4 w-4" />}
                onClick={runPreview}
              >
                Analyze & Preview
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* STEP 2 */}
      {step === 2 && preview && (
        <div className="space-y-5">
          <Card>
            <CardHeader>
              <div className="flex flex-wrap items-center justify-between gap-2">
                <CardTitle className="flex items-center gap-2">
                  <Building2 className="h-5 w-5 text-indigo-ink" />
                  {preview.schoolMeta.schoolName}
                </CardTitle>
                <Badge variant={preview.ok ? "emerald" : "crimson"}>
                  UDISE: {preview.schoolMeta.udiseCode || "MISSING"}
                </Badge>
              </div>
              <CardDescription>
                {[
                  preview.schoolMeta.blockName && `Block: ${preview.schoolMeta.blockName}`,
                  preview.schoolMeta.districtName && `District: ${preview.schoolMeta.districtName}`,
                  preview.schoolMeta.clusterName && `Cluster: ${preview.schoolMeta.clusterName}`,
                ]
                  .filter(Boolean)
                  .join(" · ")}
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {preview.errors.length > 0 && (
                <div className="rounded-lg border border-crimson-alert/30 bg-crimson-soft p-3 text-xs text-crimson-ink space-y-1">
                  {preview.errors.map((e, i) => (
                    <p key={i}>• {e}</p>
                  ))}
                </div>
              )}

              {preview.warnings.length > 0 && (
                <div className="rounded-lg border border-amber-warm/30 bg-amber-soft p-3 text-xs text-amber-ink space-y-1">
                  {preview.warnings.map((w, i) => (
                    <p key={i}>• {w}</p>
                  ))}
                </div>
              )}

              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-sm">
                <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                  <p className="text-xs text-ink-secondary">Teachers Ready</p>
                  <p className="mt-1 text-xl font-bold text-ink">
                    {preview.teacherStats.parsedTeachers}
                  </p>
                  <p className="text-[11px] text-emerald-ink">
                    {preview.teacherStats.withValidMobileLast4} verified last-4
                  </p>
                </div>
                <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                  <p className="text-xs text-ink-secondary">Students (9–12)</p>
                  <p className="mt-1 text-xl font-bold text-ink">
                    {preview.studentStats.parsedClass9To12}
                  </p>
                  <p className="text-[11px] text-ink-muted">
                    C9:{preview.studentStats.classBreakdown["9"] ?? 0} · C10:
                    {preview.studentStats.classBreakdown["10"] ?? 0} · C11:
                    {preview.studentStats.classBreakdown["11"] ?? 0} · C12:
                    {preview.studentStats.classBreakdown["12"] ?? 0}
                  </p>
                </div>
                <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                  <p className="text-xs text-ink-secondary">Class 1–8 Skipped</p>
                  <p className="mt-1 text-xl font-bold text-ink">
                    {preview.studentStats.skippedClass1To8}
                  </p>
                </div>
                <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                  <p className="text-xs text-ink-secondary">School Name Match</p>
                  <p className="mt-1 text-sm font-bold text-ink">
                    {preview.schoolNameMatch.matched ? (
                      <span className="text-emerald-ink flex items-center gap-1">
                        <CheckCircle2 className="h-4 w-4" /> Exact Match
                      </span>
                    ) : (
                      <span className="text-amber-ink flex items-center gap-1">
                        <AlertTriangle className="h-4 w-4" /> Review Mismatch
                      </span>
                    )}
                  </p>
                </div>
              </div>

              {/* Select initial School Admin(s) */}
              <div className="pt-2 space-y-2">
                <p className="text-sm font-bold text-ink flex items-center gap-1.5">
                  <Shield className="h-4 w-4 text-indigo-ink" />
                  Select Initial School Administrator(s) ({selectedAdmins.length} selected)
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 max-h-64 overflow-y-auto pr-1">
                  {preview.teachers.map((tch) => {
                    const checked = selectedAdmins.includes(tch.teacherCode);
                    return (
                      <label
                        key={tch.teacherCode}
                        className={`flex items-start gap-2.5 rounded-lg border p-3 cursor-pointer text-xs ${
                          checked
                            ? "border-indigo-academic bg-indigo-soft"
                            : "border-hairline bg-surface hover:bg-surface-subtle"
                        }`}
                      >
                        <input
                          type="checkbox"
                          checked={checked}
                          onChange={() => toggleAdminCode(tch.teacherCode)}
                          className="mt-0.5 h-4 w-4"
                        />
                        <div className="min-w-0">
                          <p className="font-semibold text-ink truncate">{tch.fullName}</p>
                          <p className="text-ink-secondary truncate">
                            {tch.teacherCode} · {tch.teacherTitle || "Teacher"} ·{" "}
                            {tch.maskedMobile || "No mobile"}
                          </p>
                        </div>
                      </label>
                    );
                  })}
                </div>
              </div>

              <div className="space-y-2 pt-3 border-t border-hairline">
                <label className="flex items-center gap-2 text-sm text-ink cursor-pointer">
                  <input
                    type="checkbox"
                    checked={activateImmediately}
                    onChange={(e) => setActivateImmediately(e.target.checked)}
                    className="h-4 w-4"
                  />
                  <span>Activate school immediately (students & teachers can log in right away)</span>
                </label>

                {!preview.schoolNameMatch.matched && (
                  <label className="flex items-center gap-2 text-sm text-amber-ink cursor-pointer">
                    <input
                      type="checkbox"
                      checked={confirmMismatch}
                      onChange={(e) => setConfirmMismatch(e.target.checked)}
                      className="h-4 w-4"
                    />
                    <span>I confirm both Excel files belong to this school despite name difference.</span>
                  </label>
                )}
              </div>

              <div className="flex justify-between pt-2">
                <Button variant="secondary" onClick={() => setStep(1)}>
                  Back
                </Button>
                <Button
                  variant="emerald"
                  loading={committing}
                  disabled={
                    !preview.ok ||
                    selectedAdmins.length === 0 ||
                    (!preview.schoolNameMatch.matched && !confirmMismatch)
                  }
                  leftIcon={<CheckCircle2 className="h-4 w-4" />}
                  onClick={commitOnboarding}
                >
                  Commit & Onboard School
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      )}

      {/* STEP 3 */}
      {step === 3 && commitResult && (
        <Card variant="default">
          <CardContent className="py-8 text-center space-y-4">
            <CheckCircle2 className="h-12 w-12 text-emerald-ink mx-auto" />
            <h2 className="text-xl font-bold text-ink">{commitResult.school.schoolName}</h2>
            <div className="flex flex-wrap justify-center gap-2">
              <Badge variant="emerald">Status: {commitResult.school.status}</Badge>
              <Badge variant="neutral" className="font-mono">
                UDISE: {commitResult.school.udiseCode}
              </Badge>
              <Badge variant={commitResult.school.vaultProvisioned ? "indigo" : "amber"}>
                {commitResult.school.vaultProvisioned
                  ? "Private Media Folder Provisioned"
                  : "Vault Folder Auto-Creates on First Upload"}
              </Badge>
            </div>
            <p className="text-sm text-ink-secondary">
              Teachers added/updated: {commitResult.summary.teachersAdded}/
              {commitResult.summary.teachersUpdated} · Students added/updated:{" "}
              {commitResult.summary.studentsAdded}/{commitResult.summary.studentsUpdated} ·
              Conflicts skipped: {commitResult.summary.conflictsCount}
            </p>
            <div className="flex justify-center gap-3 pt-2">
              <Link href="/super-admin">
                <Button variant="primary">Back to Command Center</Button>
              </Link>
              <Button
                variant="secondary"
                onClick={() => {
                  setStep(1);
                  setPreview(null);
                  setCommitResult(null);
                  setTeacherFile(null);
                  setStudentFile(null);
                }}
              >
                Onboard Another School
              </Button>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
