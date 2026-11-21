"use client";

import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  BookOpen,
  CheckCircle2,
  Copy,
  KeyRound,
  Plus,
  Shield,
  UserCheck,
  UserX,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import {
  Badge,
  Button,
  Card,
  Input,
  Modal,
  useToast,
} from "@/components/ui";
import type { ClassNum } from "@/types/database";

interface TeacherItem {
  teacherId: string;
  teacherCode: string;
  fullName: string;
  teacherTitle: string | null;
  maskedMobile: string | null;
  mustChangePassword: boolean;
  isSchoolAdmin: boolean;
  isActive: boolean;
  subjectsConfigured: boolean;
  assignedClasses: ClassNum[];
  assignedSubjectIds: string[];
}

interface SubjectOption {
  id: string;
  class_num: ClassNum;
  stream: string;
  category: string;
  name_en: string;
  name_hi: string;
}

export default function SchoolTeachersPage() {
  const { t } = useLanguage();
  const toast = useToast();

  const [teachers, setTeachers] = useState<TeacherItem[]>([]);
  const [subjects, setSubjects] = useState<SubjectOption[]>([]);
  const [currentTeacherId, setCurrentTeacherId] = useState<string>("");
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");

  // Subject mapping modal state
  const [mappingTarget, setMappingTarget] = useState<TeacherItem | null>(null);
  const [selectedClasses, setSelectedClasses] = useState<ClassNum[]>([]);
  const [selectedSubjects, setSelectedSubjects] = useState<string[]>([]);
  const [savingMapping, setSavingMapping] = useState(false);

  // Add teacher modal state
  const [addOpen, setAddOpen] = useState(false);
  const [newCode, setNewCode] = useState("");
  const [newName, setNewName] = useState("");
  const [newTitle, setNewTitle] = useState("");
  const [newMobile, setNewMobile] = useState("");
  const [newIsAdmin, setNewIsAdmin] = useState(false);
  const [adding, setAdding] = useState(false);

  // One-time credential display modal
  const [issuedSecret, setIssuedSecret] = useState<{
    teacherName: string;
    kind: "RESET" | "ACTIVATION";
    code: string;
    expiresAt?: string;
  } | null>(null);

  const loadRoster = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/school/teachers", { cache: "no-store" });
      if (!res.ok) throw new Error();
      const json = (await res.json()) as {
        teachers: TeacherItem[];
        subjects: SubjectOption[];
        currentTeacherId: string;
      };
      setTeachers(json.teachers);
      setSubjects(json.subjects);
      setCurrentTeacherId(json.currentTeacherId);
    } catch {
      toast.error(t("शिक्षक सूची लोड नहीं हो सकी", "Could not load staff list"));
    } finally {
      setLoading(false);
    }
  }, [t, toast]);

  useEffect(() => {
    void loadRoster();
  }, [loadRoster]);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return teachers;
    return teachers.filter(
      (item) =>
        item.fullName.toLowerCase().includes(q) ||
        item.teacherCode.toLowerCase().includes(q) ||
        (item.teacherTitle || "").toLowerCase().includes(q)
    );
  }, [teachers, search]);

  const subjectById = useMemo(
    () => new Map(subjects.map((s) => [s.id, s])),
    [subjects]
  );

  const openMappingModal = (teacher: TeacherItem) => {
    setMappingTarget(teacher);
    setSelectedClasses([...teacher.assignedClasses]);
    setSelectedSubjects([...teacher.assignedSubjectIds]);
  };

  const toggleClass = (cls: ClassNum) => {
    setSelectedClasses((prev) =>
      prev.includes(cls) ? prev.filter((c) => c !== cls) : [...prev, cls]
    );
  };

  const toggleSubject = (sid: string) => {
    setSelectedSubjects((prev) =>
      prev.includes(sid) ? prev.filter((s) => s !== sid) : [...prev, sid]
    );
  };

  const saveSubjectMapping = async () => {
    if (!mappingTarget) return;
    setSavingMapping(true);
    try {
      const res = await fetch(`/api/school/teachers/${mappingTarget.teacherId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          action: "UPDATE",
          assignedClasses: selectedClasses,
          assignedSubjectIds: selectedSubjects,
        }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string };
      if (!res.ok || !json.ok) {
        toast.error(t("सहेजा नहीं जा सका", "Failed to save"), json.error);
        return;
      }
      toast.success(t("विषय आवंटन सहेजा गया", "Subject assignments saved"));
      setMappingTarget(null);
      await loadRoster();
    } finally {
      setSavingMapping(false);
    }
  };

  const handleResetPassword = async (teacher: TeacherItem) => {
    const res = await fetch(`/api/school/teachers/${teacher.teacherId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: JSON.stringify({ action: "RESET_PASSWORD" }),
    });
    const json = (await res.json()) as {
      ok?: boolean;
      resetCode?: string;
      expiresAt?: string;
      error?: string;
    };
    if (!res.ok || !json.ok || !json.resetCode) {
      toast.error(t("रीसेट कोड नहीं बन सका", "Could not generate reset code"), json.error);
      return;
    }
    setIssuedSecret({
      teacherName: teacher.fullName,
      kind: "RESET",
      code: json.resetCode,
      expiresAt: json.expiresAt,
    });
    await loadRoster();
  };

  const handleToggleStatus = async (teacher: TeacherItem) => {
    const res = await fetch(`/api/school/teachers/${teacher.teacherId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: JSON.stringify({ action: "UPDATE", isActive: !teacher.isActive }),
    });
    const json = (await res.json()) as { ok?: boolean; error?: string };
    if (!res.ok || !json.ok) {
      toast.error(t("स्थिति बदली नहीं जा सकी", "Could not change status"), json.error);
      return;
    }
    toast.success(
      teacher.isActive
        ? t("शिक्षक खाता निष्क्रिय किया गया", "Teacher deactivated")
        : t("शिक्षक खाता सक्रिय किया गया", "Teacher reactivated")
    );
    await loadRoster();
  };

  const handleToggleAdmin = async (teacher: TeacherItem) => {
    const res = await fetch(`/api/school/teachers/${teacher.teacherId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: JSON.stringify({
        action: "UPDATE",
        isSchoolAdmin: !teacher.isSchoolAdmin,
      }),
    });
    const json = (await res.json()) as { ok?: boolean; error?: string };
    if (!res.ok || !json.ok) {
      toast.error(t("भूमिका बदली नहीं जा सकी", "Could not update role"), json.error);
      return;
    }
    toast.success(t("प्रशासक भूमिका अपडेट हुई", "Administrator role updated"));
    await loadRoster();
  };

  const handleAddTeacher = async (e: React.FormEvent) => {
    e.preventDefault();
    setAdding(true);
    try {
      const res = await fetch("/api/school/teachers", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          teacherCode: newCode,
          fullName: newName,
          teacherTitle: newTitle || null,
          mobileNo: newMobile || null,
          isSchoolAdmin: newIsAdmin,
        }),
      });
      const json = (await res.json()) as {
        ok?: boolean;
        activationCode?: string | null;
        error?: string;
      };
      if (!res.ok || !json.ok) {
        toast.error(t("शिक्षक जोड़े नहीं जा सके", "Could not add teacher"), json.error);
        return;
      }
      setAddOpen(false);
      if (json.activationCode) {
        setIssuedSecret({
          teacherName: newName,
          kind: "ACTIVATION",
          code: json.activationCode,
        });
      } else {
        toast.success(t("शिक्षक जोड़े गए", "Teacher added"));
      }
      setNewCode("");
      setNewName("");
      setNewTitle("");
      setNewMobile("");
      setNewIsAdmin(false);
      await loadRoster();
    } finally {
      setAdding(false);
    }
  };

  const subjectsByClass = useMemo(() => {
    const grouped: Record<ClassNum, SubjectOption[]> = { 9: [], 10: [], 11: [], 12: [] };
    for (const s of subjects) {
      grouped[s.class_num]?.push(s);
    }
    return grouped;
  }, [subjects]);

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-ink">
            {t("शिक्षक प्रबंधन, विषय आवंटन एवं सहायता", "Staff Roster, Subject Mapping & Account Support")}
          </h1>
          <p className="mt-1 text-sm text-ink-secondary">
            {t(
              "शिक्षकों के कक्षा/विषय निर्धारित करें और आवश्यकता होने पर अस्थायी पासवर्ड रीसेट कोड जारी करें।",
              "Assign classes and subjects to teachers, manage School Admin access, and issue one-time password reset codes."
            )}
          </p>
        </div>
        <Button
          variant="primary"
          leftIcon={<Plus className="h-4 w-4" />}
          onClick={() => setAddOpen(true)}
        >
          {t("नए शिक्षक जोड़ें", "Add Teacher")}
        </Button>
      </div>

      <Input
        placeholder={t("नाम, शिक्षक आईडी या पद से खोजें...", "Search by name, Teacher ID, or designation...")}
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />

      {loading ? (
        <div className="space-y-3 animate-pulse">
          {[1, 2, 3].map((i) => (
            <div key={i} className="h-24 rounded-paper bg-surface-subtle border border-hairline" />
          ))}
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map((teacher) => {
            const isSelf = teacher.teacherId === currentTeacherId;
            return (
              <Card key={teacher.teacherId} padding="md">
                <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                  <div className="space-y-1.5 min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <h3 className="text-base font-bold text-ink">{teacher.fullName}</h3>
                      <Badge variant="neutral" className="font-mono">
                        {teacher.teacherCode}
                      </Badge>
                      {teacher.isSchoolAdmin && (
                        <Badge variant="indigo" icon={<Shield className="h-3 w-3" />}>
                          {t("विद्यालय व्यवस्थापक", "School Admin")}
                        </Badge>
                      )}
                      {!teacher.isActive && (
                        <Badge variant="crimson">{t("निष्क्रिय", "Inactive")}</Badge>
                      )}
                      {teacher.mustChangePassword && teacher.isActive && (
                        <Badge variant="amber">
                          {t("प्रथम सक्रियण शेष", "Activation Pending")}
                        </Badge>
                      )}
                    </div>
                    <p className="text-xs text-ink-secondary">
                      {[teacher.teacherTitle, teacher.maskedMobile ? `Mobile: ${teacher.maskedMobile}` : null]
                        .filter(Boolean)
                        .join(" · ")}
                    </p>
                    <div className="flex flex-wrap gap-1.5 pt-1">
                      {teacher.assignedSubjectIds.length === 0 ? (
                        <span className="text-xs text-amber-ink font-medium">
                          {t("कोई विषय आवंटित नहीं है", "No subjects mapped yet")}
                        </span>
                      ) : (
                        teacher.assignedSubjectIds.slice(0, 6).map((sid) => {
                          const s = subjectById.get(sid);
                          return (
                            <Badge key={sid} variant="outline">
                              {s ? `C${s.class_num} ${t(s.name_hi, s.name_en)}` : sid}
                            </Badge>
                          );
                        })
                      )}
                      {teacher.assignedSubjectIds.length > 6 && (
                        <Badge variant="neutral">+{teacher.assignedSubjectIds.length - 6}</Badge>
                      )}
                    </div>
                  </div>

                  <div className="flex flex-wrap items-center gap-2 shrink-0">
                    <Button
                      variant="secondary"
                      size="sm"
                      leftIcon={<BookOpen className="h-4 w-4" />}
                      onClick={() => openMappingModal(teacher)}
                    >
                      {t("विषय चुनें", "Map Subjects")}
                    </Button>
                    {teacher.isActive && (
                      <Button
                        variant="outline"
                        size="sm"
                        leftIcon={<KeyRound className="h-4 w-4" />}
                        onClick={() => void handleResetPassword(teacher)}
                      >
                        {t("पासवर्ड रीसेट", "Reset Password")}
                      </Button>
                    )}
                    {!isSelf && teacher.isActive && (
                      <Button
                        variant="ghost"
                        size="sm"
                        leftIcon={<Shield className="h-4 w-4" />}
                        onClick={() => void handleToggleAdmin(teacher)}
                      >
                        {teacher.isSchoolAdmin
                          ? t("एडमिन हटाएँ", "Remove Admin")
                          : t("एडमिन बनाएँ", "Make Admin")}
                      </Button>
                    )}
                    {!isSelf && (
                      <Button
                        variant={teacher.isActive ? "ghost" : "emerald"}
                        size="sm"
                        leftIcon={
                          teacher.isActive ? (
                            <UserX className="h-4 w-4" />
                          ) : (
                            <UserCheck className="h-4 w-4" />
                          )
                        }
                        onClick={() => void handleToggleStatus(teacher)}
                      >
                        {teacher.isActive ? t("निष्क्रिय", "Deactivate") : t("सक्रिय करें", "Reactivate")}
                      </Button>
                    )}
                  </div>
                </div>
              </Card>
            );
          })}
        </div>
      )}

      {/* Subject Mapping Modal */}
      <Modal
        open={Boolean(mappingTarget)}
        onClose={() => setMappingTarget(null)}
        size="xl"
        title={t(
          `विषय आवंटन — ${mappingTarget?.fullName ?? ""}`,
          `Subject Mapping — ${mappingTarget?.fullName ?? ""}`
        )}
        footer={
          <>
            <Button variant="secondary" onClick={() => setMappingTarget(null)}>
              {t("रद्द करें", "Cancel")}
            </Button>
            <Button
              variant="primary"
              loading={savingMapping}
              onClick={saveSubjectMapping}
              leftIcon={<CheckCircle2 className="h-4 w-4" />}
            >
              {t("आवंटन सहेजें", "Save Mapping")}
            </Button>
          </>
        }
      >
        <div className="space-y-5">
          <div>
            <p className="text-sm font-semibold text-ink mb-2">
              {t("पढ़ाई जाने वाली कक्षाएँ", "Assigned Classes")}
            </p>
            <div className="flex flex-wrap gap-2">
              {([9, 10, 11, 12] as ClassNum[]).map((cls) => {
                const active = selectedClasses.includes(cls);
                return (
                  <button
                    key={cls}
                    type="button"
                    onClick={() => toggleClass(cls)}
                    className={`rounded-lg px-4 py-2 text-sm font-semibold border transition-colors ${
                      active
                        ? "bg-indigo-soft text-indigo-ink border-indigo-academic"
                        : "bg-surface text-ink-secondary border-hairline hover:bg-surface-subtle"
                    }`}
                  >
                    {t(`कक्षा ${cls}`, `Class ${cls}`)}
                  </button>
                );
              })}
            </div>
          </div>

          <div className="space-y-4">
            {([9, 10, 11, 12] as ClassNum[]).map((cls) => (
              <div key={cls} className="rounded-lg border border-hairline p-3.5">
                <p className="text-xs font-bold uppercase tracking-wider text-ink-secondary mb-2.5">
                  {t(`कक्षा ${cls} के विषय`, `Class ${cls} Subjects`)}
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2">
                  {subjectsByClass[cls].map((s) => {
                    const checked = selectedSubjects.includes(s.id);
                    return (
                      <label
                        key={s.id}
                        className={`flex items-center gap-2 rounded-md border px-2.5 py-2 text-xs cursor-pointer transition-colors ${
                          checked
                            ? "border-indigo-academic bg-indigo-soft text-indigo-ink font-semibold"
                            : "border-hairline bg-surface text-ink-secondary hover:bg-surface-subtle"
                        }`}
                      >
                        <input
                          type="checkbox"
                          checked={checked}
                          onChange={() => toggleSubject(s.id)}
                          className="h-3.5 w-3.5"
                        />
                        <span className="truncate">
                          {t(s.name_hi, s.name_en)}
                          {s.stream !== "NA" && s.stream !== "ALL" ? ` (${s.stream})` : ""}
                        </span>
                      </label>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>
        </div>
      </Modal>

      {/* Add Teacher Modal */}
      <Modal
        open={addOpen}
        onClose={() => setAddOpen(false)}
        title={t("नए शिक्षक जोड़ें", "Add Teacher")}
      >
        <form onSubmit={handleAddTeacher} className="space-y-4">
          <Input
            label={t("शिक्षक आईडी (8 या 13 अंक)", "Teacher ID (8 or 13 digits)")}
            required
            value={newCode}
            onChange={(e) => setNewCode(e.target.value)}
          />
          <Input
            label={t("पूरा नाम", "Full Name")}
            required
            value={newName}
            onChange={(e) => setNewName(e.target.value)}
          />
          <Input
            label={t("पद / उपाधि (वैकल्पिक)", "Designation (Optional)")}
            value={newTitle}
            onChange={(e) => setNewTitle(e.target.value)}
          />
          <Input
            label={t("10-अंकीय मोबाइल नंबर (केवल सत्यापन हेतु)", "10-Digit Mobile (Verification Only)")}
            value={newMobile}
            onChange={(e) => setNewMobile(e.target.value)}
            maxLength={14}
          />
          <label className="flex items-center gap-2 text-sm text-ink cursor-pointer">
            <input
              type="checkbox"
              checked={newIsAdmin}
              onChange={(e) => setNewIsAdmin(e.target.checked)}
              className="h-4 w-4"
            />
            <span>{t("विद्यालय व्यवस्थापक अधिकार दें", "Grant School Admin access")}</span>
          </label>
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="secondary" onClick={() => setAddOpen(false)}>
              {t("रद्द करें", "Cancel")}
            </Button>
            <Button type="submit" variant="primary" loading={adding}>
              {t("सहेजें", "Save Teacher")}
            </Button>
          </div>
        </form>
      </Modal>

      {/* One-time Reset / Activation Code Modal */}
      <Modal
        open={Boolean(issuedSecret)}
        onClose={() => setIssuedSecret(null)}
        title={
          issuedSecret?.kind === "RESET"
            ? t("अस्थायी पासवर्ड रीसेट कोड (24 घंटे मान्य)", "One-Time Password Reset Code (Valid 24h)")
            : t("प्रथम सक्रियण कोड", "One-Time Activation Code")
        }
      >
        {issuedSecret && (
          <div className="space-y-4">
            <p className="text-sm text-ink-secondary">
              {t(
                `यह कोड केवल एक बार दिखाई देता है। कृपया इसे सुरक्षित रूप से ${issuedSecret.teacherName} को दें।`,
                `This code is shown only once. Share it securely with ${issuedSecret.teacherName}.`
              )}
            </p>
            <div className="flex items-center justify-between gap-3 rounded-lg border border-indigo-academic/30 bg-indigo-soft p-4">
              <span className="font-mono text-2xl font-bold tracking-widest text-indigo-ink">
                {issuedSecret.code}
              </span>
              <Button
                variant="secondary"
                size="sm"
                leftIcon={<Copy className="h-4 w-4" />}
                onClick={() => {
                  void navigator.clipboard.writeText(issuedSecret.code);
                  toast.success(t("कोड कॉपी हो गया", "Code copied"));
                }}
              >
                {t("कॉपी", "Copy")}
              </Button>
            </div>
            <div className="flex justify-end">
              <Button variant="primary" onClick={() => setIssuedSecret(null)}>
                {t("समझ गया", "Done")}
              </Button>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}
