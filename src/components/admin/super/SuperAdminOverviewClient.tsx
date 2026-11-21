"use client";

import React, { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import {
  Activity,
  AlertTriangle,
  BookOpen,
  Building2,
  CheckCircle2,
  FileSearch,
  GraduationCap,
  HardDrive,
  PauseCircle,
  PlayCircle,
  PlusCircle,
  RefreshCw,
  Shield,
  Users,
} from "lucide-react";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
  Modal,
  useToast,
} from "@/components/ui";

interface SchoolSummary {
  udise_code: string;
  school_name: string;
  school_name_hi: string | null;
  district_name: string;
  block_name: string | null;
  status: "ONBOARDING" | "ACTIVE" | "SUSPENDED";
  drive_folder_id: string | null;
  activeStudents: number;
  activeTeachers: number;
  schoolAdmins: number;
  created_at: string;
}

interface VaultHealth {
  healthy: boolean;
  rootFolderAccessible: boolean;
  totalBytes: number | null;
  usedBytes: number | null;
  availableBytes: number | null;
  percentUsed: number | null;
  checkedDateIst: string;
  error?: string;
}

interface PlatformSummary {
  totalSchools: number;
  activeSchools: number;
  totalActiveStudents: number;
  totalActiveTeachers: number;
  pendingSubmissions: number;
  publishedQuestions: number;
  publishedNotes: number;
}

interface SchoolDetailTeacher {
  teacherId: string;
  teacherCode: string;
  fullName: string;
  teacherTitle: string | null;
  maskedMobile: string | null;
  isSchoolAdmin: boolean;
  isActive: boolean;
}

function formatBytes(bytes: number | null): string {
  if (bytes === null || !Number.isFinite(bytes)) return "—";
  const tb = bytes / 1024 ** 4;
  if (tb >= 1) return `${tb.toFixed(2)} TB`;
  const gb = bytes / 1024 ** 3;
  if (gb >= 1) return `${gb.toFixed(2)} GB`;
  const mb = bytes / 1024 ** 2;
  return `${mb.toFixed(1)} MB`;
}

export function SuperAdminOverviewClient() {
  const toast = useToast();

  const [schools, setSchools] = useState<SchoolSummary[]>([]);
  const [summary, setSummary] = useState<PlatformSummary | null>(null);
  const [vaultHealth, setVaultHealth] = useState<VaultHealth | null>(null);
  const [loading, setLoading] = useState(true);
  const [checkingHealth, setCheckingHealth] = useState(false);

  // Manage admins modal
  const [managingSchool, setManagingSchool] = useState<SchoolSummary | null>(null);
  const [schoolTeachers, setSchoolTeachers] = useState<SchoolDetailTeacher[]>([]);
  const [loadingTeachers, setLoadingTeachers] = useState(false);

  const loadData = useCallback(
    async (includeHealth = false) => {
      if (includeHealth) setCheckingHealth(true);
      else setLoading(true);
      try {
        const res = await fetch(
          `/api/super-admin/schools${includeHealth ? "?includeHealth=1" : ""}`,
          { cache: "no-store" }
        );
        if (!res.ok) throw new Error();
        const json = (await res.json()) as {
          schools: SchoolSummary[];
          platformSummary: PlatformSummary;
          vaultHealth: VaultHealth | null;
        };
        setSchools(json.schools);
        setSummary(json.platformSummary);
        if (includeHealth || json.vaultHealth) {
          setVaultHealth(json.vaultHealth);
        }
      } catch {
        toast.error("Failed to load Super Admin overview");
      } finally {
        setLoading(false);
        setCheckingHealth(false);
      }
    },
    [toast]
  );

  useEffect(() => {
    void loadData(false);
  }, [loadData]);

  const handleStatusChange = async (
    school: SchoolSummary,
    nextStatus: "ACTIVE" | "SUSPENDED"
  ) => {
    const res = await fetch(`/api/super-admin/schools/${school.udise_code}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: JSON.stringify({ status: nextStatus }),
    });
    if (!res.ok) {
      toast.error("Failed to update school status");
      return;
    }
    toast.success(`School ${school.udise_code} set to ${nextStatus}`);
    await loadData(false);
  };

  const openAdminModal = async (school: SchoolSummary) => {
    setManagingSchool(school);
    setLoadingTeachers(true);
    try {
      const res = await fetch(`/api/super-admin/schools/${school.udise_code}`, {
        cache: "no-store",
      });
      if (!res.ok) throw new Error();
      const json = (await res.json()) as { teachers: SchoolDetailTeacher[] };
      setSchoolTeachers(json.teachers);
    } catch {
      toast.error("Could not load school staff");
    } finally {
      setLoadingTeachers(false);
    }
  };

  const toggleSchoolAdmin = async (teacher: SchoolDetailTeacher) => {
    if (!managingSchool) return;
    const res = await fetch(`/api/super-admin/schools/${managingSchool.udise_code}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: JSON.stringify({
        toggleAdminTeacherId: teacher.teacherId,
        isSchoolAdmin: !teacher.isSchoolAdmin,
      }),
    });
    const json = (await res.json()) as { ok?: boolean; error?: string };
    if (!res.ok || !json.ok) {
      toast.error("Update blocked", json.error);
      return;
    }
    toast.success("School Admin privilege updated");
    await openAdminModal(managingSchool);
    await loadData(false);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-hairline">
        <div>
          <Badge variant="indigo">Private Super Admin Command Center</Badge>
          <h1 className="mt-2 text-2xl sm:text-3xl font-bold text-ink tracking-tight">
            Platform Governance & Multi-School Operations
          </h1>
          <p className="mt-1 text-sm text-ink-secondary">
            Onboard Bihar schools, review teacher-submitted question papers, curate gold visual BSEB curriculum, and monitor storage vault health.
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Link href="/super-admin/onboard">
            <Button variant="primary" leftIcon={<PlusCircle className="h-4 w-4" />}>
              Onboard School
            </Button>
          </Link>
          <Link href="/super-admin/review">
            <Button variant="secondary" leftIcon={<FileSearch className="h-4 w-4" />}>
              Review Queue ({summary?.pendingSubmissions ?? 0})
            </Button>
          </Link>
        </div>
      </div>

      {/* Platform Metrics */}
      {summary && (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <Card padding="md">
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold uppercase tracking-wider text-ink-secondary">
                Onboarded Schools
              </span>
              <Building2 className="h-5 w-5 text-indigo-ink" />
            </div>
            <p className="mt-2 text-3xl font-bold text-ink">{summary.totalSchools}</p>
            <p className="mt-1 text-xs text-ink-muted">
              {summary.activeSchools} active across Bihar
            </p>
          </Card>

          <Card padding="md">
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold uppercase tracking-wider text-ink-secondary">
                Active Students & Staff
              </span>
              <GraduationCap className="h-5 w-5 text-emerald-ink" />
            </div>
            <p className="mt-2 text-3xl font-bold text-ink">{summary.totalActiveStudents}</p>
            <p className="mt-1 text-xs text-ink-muted">
              {summary.totalActiveTeachers} verified active teachers
            </p>
          </Card>

          <Card padding="md">
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold uppercase tracking-wider text-ink-secondary">
                Editorial Review Queue
              </span>
              <FileSearch className="h-5 w-5 text-amber-ink" />
            </div>
            <p className="mt-2 text-3xl font-bold text-ink">{summary.pendingSubmissions}</p>
            <p className="mt-1 text-xs text-ink-muted">
              {summary.publishedQuestions} published bank questions
            </p>
          </Card>

          <Card padding="md">
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold uppercase tracking-wider text-ink-secondary">
                Gold Visual Chapters
              </span>
              <BookOpen className="h-5 w-5 text-indigo-ink" />
            </div>
            <p className="mt-2 text-3xl font-bold text-ink">{summary.publishedNotes}</p>
            <p className="mt-1 text-xs text-ink-muted">Published chapter note packs</p>
          </Card>
        </div>
      )}

      {/* 5 TB Google One Storage Vault Health Monitor */}
      <Card>
        <CardHeader className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div>
            <CardTitle className="flex items-center gap-2">
              <HardDrive className="h-5 w-5 text-indigo-ink" />
              5 TB Google One Media Vault Health
            </CardTitle>
            <CardDescription>
              Verifies server OAuth2 token refresh, encrypted cache, root folder access, and live storage quota.
            </CardDescription>
          </div>
          <Button
            variant="secondary"
            size="sm"
            loading={checkingHealth}
            leftIcon={<RefreshCw className="h-4 w-4" />}
            onClick={() => void loadData(true)}
          >
            Run Live Health Check
          </Button>
        </CardHeader>
        <CardContent>
          {!vaultHealth ? (
            <div className="flex items-center gap-2 text-sm text-ink-secondary">
              <Activity className="h-4 w-4 text-ink-muted" />
              Click &quot;Run Live Health Check&quot; to probe OAuth2 token lease and 5 TB storage quota.
            </div>
          ) : vaultHealth.healthy ? (
            <div className="space-y-3">
              <div className="flex flex-wrap items-center gap-2">
                <Badge variant="emerald" icon={<CheckCircle2 className="h-3.5 w-3.5" />}>
                  Vault Healthy & Root Folder Accessible
                </Badge>
                <span className="text-xs text-ink-muted">
                  Checked IST: {vaultHealth.checkedDateIst}
                </span>
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-sm">
                <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                  <p className="text-xs text-ink-secondary">Used Storage</p>
                  <p className="mt-1 font-bold text-ink">{formatBytes(vaultHealth.usedBytes)}</p>
                </div>
                <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                  <p className="text-xs text-ink-secondary">Total Capacity</p>
                  <p className="mt-1 font-bold text-ink">{formatBytes(vaultHealth.totalBytes)}</p>
                </div>
                <div className="rounded-lg border border-hairline bg-surface-subtle p-3">
                  <p className="text-xs text-ink-secondary">Available</p>
                  <p className="mt-1 font-bold text-emerald-ink">
                    {formatBytes(vaultHealth.availableBytes)}{" "}
                    {vaultHealth.percentUsed !== null ? `(${vaultHealth.percentUsed}% used)` : ""}
                  </p>
                </div>
              </div>
            </div>
          ) : (
            <div className="rounded-lg border border-amber-warm/30 bg-amber-soft p-3.5 flex items-start gap-2.5 text-sm text-amber-ink">
              <AlertTriangle className="h-5 w-5 shrink-0 mt-0.5" />
              <div>
                <p className="font-semibold">Vault Check Reported Warning / Unconfigured Env</p>
                <p className="text-xs mt-0.5">{vaultHealth.error}</p>
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Multi-School Registry */}
      <Card>
        <CardHeader>
          <CardTitle>Onboarded Bihar Schools Registry</CardTitle>
          <CardDescription>
            Manage school status, inspect active enrollment, and assign or revoke School Admin privileges.
          </CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="h-28 rounded-lg bg-surface-subtle animate-pulse" />
          ) : schools.length === 0 ? (
            <div className="py-10 text-center space-y-3">
              <p className="text-sm text-ink-secondary">
                No schools onboarded yet. Use the 3-Step Onboarding Wizard to onboard School #1.
              </p>
              <Link href="/super-admin/onboard">
                <Button variant="primary" leftIcon={<PlusCircle className="h-4 w-4" />}>
                  Launch Onboarding Wizard
                </Button>
              </Link>
            </div>
          ) : (
            <div className="divide-y divide-hairline">
              {schools.map((sch) => (
                <div
                  key={sch.udise_code}
                  className="py-4 flex flex-col lg:flex-row lg:items-center justify-between gap-4"
                >
                  <div className="space-y-1">
                    <div className="flex flex-wrap items-center gap-2">
                      <span className="font-bold text-ink">{sch.school_name}</span>
                      <Badge variant="neutral" className="font-mono">
                        {sch.udise_code}
                      </Badge>
                      <Badge
                        variant={
                          sch.status === "ACTIVE"
                            ? "emerald"
                            : sch.status === "SUSPENDED"
                            ? "crimson"
                            : "amber"
                        }
                      >
                        {sch.status}
                      </Badge>
                    </div>
                    <p className="text-xs text-ink-secondary">
                      {[sch.block_name, sch.district_name].filter(Boolean).join(", ")} ·{" "}
                      {sch.activeStudents} active students · {sch.activeTeachers} teachers (
                      {sch.schoolAdmins} admins)
                    </p>
                  </div>

                  <div className="flex flex-wrap items-center gap-2 shrink-0">
                    <Button
                      variant="secondary"
                      size="sm"
                      leftIcon={<Users className="h-4 w-4" />}
                      onClick={() => void openAdminModal(sch)}
                    >
                      Manage Admins
                    </Button>
                    {sch.status === "ACTIVE" ? (
                      <Button
                        variant="ghost"
                        size="sm"
                        leftIcon={<PauseCircle className="h-4 w-4" />}
                        onClick={() => void handleStatusChange(sch, "SUSPENDED")}
                      >
                        Suspend
                      </Button>
                    ) : (
                      <Button
                        variant="emerald"
                        size="sm"
                        leftIcon={<PlayCircle className="h-4 w-4" />}
                        onClick={() => void handleStatusChange(sch, "ACTIVE")}
                      >
                        Activate
                      </Button>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Manage School Admins Modal */}
      <Modal
        open={Boolean(managingSchool)}
        onClose={() => setManagingSchool(null)}
        size="lg"
        title={`School Admins — ${managingSchool?.school_name ?? ""}`}
        description={`UDISE ${managingSchool?.udise_code ?? ""}`}
      >
        {loadingTeachers ? (
          <div className="h-24 rounded-lg bg-surface-subtle animate-pulse" />
        ) : (
          <div className="divide-y divide-hairline">
            {schoolTeachers.map((tch) => (
              <div
                key={tch.teacherId}
                className="py-3 flex flex-wrap items-center justify-between gap-3"
              >
                <div>
                  <p className="text-sm font-semibold text-ink">
                    {tch.fullName}{" "}
                    <span className="font-mono text-xs text-ink-muted">({tch.teacherCode})</span>
                  </p>
                  <p className="text-xs text-ink-secondary">
                    {[tch.teacherTitle, tch.maskedMobile].filter(Boolean).join(" · ")}
                  </p>
                </div>
                <Button
                  variant={tch.isSchoolAdmin ? "secondary" : "primary"}
                  size="sm"
                  disabled={!tch.isActive}
                  leftIcon={<Shield className="h-3.5 w-3.5" />}
                  onClick={() => void toggleSchoolAdmin(tch)}
                >
                  {tch.isSchoolAdmin ? "Revoke Admin" : "Assign Admin"}
                </Button>
              </div>
            ))}
          </div>
        )}
      </Modal>
    </div>
  );
}
