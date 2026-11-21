"use client";

import React, { useCallback, useEffect, useState } from "react";
import {
  KeyRound,
  Pencil,
  Plus,
  Search,
  UserCheck,
  UserX,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import {
  Badge,
  Button,
  Card,
  CardContent,
  DobDropdownPicker,
  Input,
  Modal,
  Select,
  useToast,
} from "@/components/ui";
import type { ClassNum, StudentStream } from "@/types/database";

interface StudentListItem {
  id: string;
  studentCode: string | null;
  studentName: string;
  fatherName: string | null;
  dob: string;
  gender: string | null;
  classNum: ClassNum;
  stream: StudentStream;
  section: string;
  rollNo: number;
  isActive: boolean;
  subjectsConfigured: boolean;
  hasPin: boolean;
}

export default function SchoolStudentsPage() {
  const { t } = useLanguage();
  const toast = useToast();

  const [students, setStudents] = useState<StudentListItem[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [q, setQ] = useState("");
  const [classFilter, setClassFilter] = useState("");
  const [activeFilter, setActiveFilter] = useState("true");
  const [page, setPage] = useState(1);

  // Add/Edit modal
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<StudentListItem | null>(null);
  const [studentName, setStudentName] = useState("");
  const [studentCode, setStudentCode] = useState("");
  const [fatherName, setFatherName] = useState("");
  const [dob, setDob] = useState("");
  const [classNum, setClassNum] = useState<string>("10");
  const [stream, setStream] = useState<string>("NA");
  const [rollNo, setRollNo] = useState("");
  const [saving, setSaving] = useState(false);

  const loadStudents = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({
        page: String(page),
        limit: "50",
        active: activeFilter,
      });
      if (q.trim()) params.set("q", q.trim());
      if (classFilter) params.set("classNum", classFilter);

      const res = await fetch(`/api/school/students?${params.toString()}`, {
        cache: "no-store",
      });
      if (!res.ok) throw new Error();
      const json = (await res.json()) as {
        students: StudentListItem[];
        total: number;
      };
      setStudents(json.students);
      setTotal(json.total);
    } catch {
      toast.error(t("विद्यार्थी सूची लोड नहीं हो सकी", "Could not load students"));
    } finally {
      setLoading(false);
    }
  }, [page, activeFilter, q, classFilter, t, toast]);

  useEffect(() => {
    void loadStudents();
  }, [loadStudents]);

  const openAdd = () => {
    setEditing(null);
    setStudentName("");
    setStudentCode("");
    setFatherName("");
    setDob("");
    setClassNum("10");
    setStream("NA");
    setRollNo("");
    setModalOpen(true);
  };

  const openEdit = (stu: StudentListItem) => {
    setEditing(stu);
    setStudentName(stu.studentName);
    setStudentCode(stu.studentCode || "");
    setFatherName(stu.fatherName || "");
    setDob(stu.dob);
    setClassNum(String(stu.classNum));
    setStream(stu.stream);
    setRollNo(String(stu.rollNo));
    setModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!dob) {
      toast.warning(t("कृपया जन्म तिथि चुनें।", "Please select Date of Birth."));
      return;
    }
    setSaving(true);
    try {
      const parsedClass = Number(classNum) as ClassNum;
      const payload = {
        studentName,
        ...(editing ? {} : { studentCode: studentCode.trim() || null }),
        fatherName: fatherName.trim() || null,
        dob,
        classNum: parsedClass,
        stream: parsedClass <= 10 ? "NA" : (stream as StudentStream),
        rollNo: Number.parseInt(rollNo, 10),
      };

      const url = editing
        ? `/api/school/students/${editing.id}`
        : "/api/school/students";
      const res = await fetch(url, {
        method: editing ? "PATCH" : "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify(payload),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string };
      if (!res.ok || !json.ok) {
        toast.error(t("सहेजा नहीं जा सका", "Failed to save student"), json.error);
        return;
      }
      toast.success(
        editing
          ? t("विद्यार्थी विवरण अपडेट हुआ", "Student updated")
          : t("नया विद्यार्थी जोड़ा गया", "Student added")
      );
      setModalOpen(false);
      await loadStudents();
    } finally {
      setSaving(false);
    }
  };

  const handleResetPin = async (stu: StudentListItem) => {
    const res = await fetch(`/api/school/students/${stu.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: JSON.stringify({ resetPin: true }),
    });
    if (res.ok) {
      toast.success(t("छात्र का 4-अंकीय पिन हटाया गया", "4-digit PIN cleared"));
      await loadStudents();
    }
  };

  const handleToggleActive = async (stu: StudentListItem) => {
    const res = await fetch(`/api/school/students/${stu.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: JSON.stringify({ isActive: !stu.isActive }),
    });
    if (res.ok) {
      toast.success(
        stu.isActive
          ? t("विद्यार्थी निष्क्रिय किया गया", "Student deactivated")
          : t("विद्यार्थी सक्रिय किया गया", "Student reactivated")
      );
      await loadStudents();
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-ink">
            {t("विद्यार्थी पंजी (कक्षा 9–12)", "Student Directory (Class 9–12)")}
          </h1>
          <p className="mt-1 text-sm text-ink-secondary">
            {t(
              `कुल ${total} रिकॉर्ड मिले।`,
              `Showing ${students.length} of ${total} matching student records.`
            )}
          </p>
        </div>
        <Button variant="primary" leftIcon={<Plus className="h-4 w-4" />} onClick={openAdd}>
          {t("नया विद्यार्थी जोड़ें", "Add Student")}
        </Button>
      </div>

      {/* Filters */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
        <Input
          leftIcon={<Search className="h-4 w-4" />}
          placeholder={t("नाम, रोल नंबर या छात्र कोड खोजें...", "Search by name, roll no, or code...")}
          value={q}
          onChange={(e) => {
            setPage(1);
            setQ(e.target.value);
          }}
        />
        <Select
          value={classFilter}
          onChange={(e) => {
            setPage(1);
            setClassFilter(e.target.value);
          }}
          options={[
            { value: "", label: t("सभी कक्षाएँ (9–12)", "All Classes (9–12)") },
            { value: "9", label: t("कक्षा 9", "Class 9") },
            { value: "10", label: t("कक्षा 10", "Class 10") },
            { value: "11", label: t("कक्षा 11", "Class 11") },
            { value: "12", label: t("कक्षा 12", "Class 12") },
          ]}
        />
        <Select
          value={activeFilter}
          onChange={(e) => {
            setPage(1);
            setActiveFilter(e.target.value);
          }}
          options={[
            { value: "true", label: t("केवल सक्रिय", "Active Only") },
            { value: "false", label: t("निष्क्रिय", "Inactive Only") },
            { value: "all", label: t("सभी", "All Records") },
          ]}
        />
      </div>

      {/* Table */}
      <Card padding="none">
        <CardContent className="pt-0 overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-surface-subtle text-xs font-semibold uppercase tracking-wider text-ink-secondary border-b border-hairline">
              <tr>
                <th className="px-4 py-3">{t("कक्षा / रोल", "Class / Roll")}</th>
                <th className="px-4 py-3">{t("विद्यार्थी एवं पिता का नाम", "Student & Father")}</th>
                <th className="px-4 py-3">{t("छात्र कोड", "Student Code")}</th>
                <th className="px-4 py-3">{t("जन्म तिथि", "DOB")}</th>
                <th className="px-4 py-3">{t("स्थिति", "Status")}</th>
                <th className="px-4 py-3 text-right">{t("कार्य", "Actions")}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-hairline">
              {loading ? (
                <tr>
                  <td colSpan={6} className="px-4 py-8 text-center text-ink-muted">
                    {t("लोड हो रहा है...", "Loading students...")}
                  </td>
                </tr>
              ) : students.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-4 py-8 text-center text-ink-muted">
                    {t("कोई विद्यार्थी रिकॉर्ड नहीं मिला।", "No matching student records found.")}
                  </td>
                </tr>
              ) : (
                students.map((stu) => (
                  <tr key={stu.id} className="hover:bg-surface-subtle/50">
                    <td className="px-4 py-3 whitespace-nowrap">
                      <Badge variant="indigo">
                        {t(`कक्षा ${stu.classNum}`, `C${stu.classNum}`)} · #{stu.rollNo}
                      </Badge>
                      {stu.classNum >= 11 && (
                        <p className="mt-1 text-xs text-ink-muted">{stu.stream}</p>
                      )}
                    </td>
                    <td className="px-4 py-3">
                      <p className="font-semibold text-ink">{stu.studentName}</p>
                      {stu.fatherName && (
                        <p className="text-xs text-ink-secondary">{stu.fatherName}</p>
                      )}
                    </td>
                    <td className="px-4 py-3 font-mono text-xs text-ink-secondary">
                      {stu.studentCode || "—"}
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap text-xs text-ink-secondary">
                      {stu.dob}
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap">
                      <div className="flex flex-wrap gap-1">
                        <Badge variant={stu.isActive ? "emerald" : "crimson"}>
                          {stu.isActive ? t("सक्रिय", "Active") : t("निष्क्रिय", "Inactive")}
                        </Badge>
                        {stu.hasPin && <Badge variant="amber">PIN</Badge>}
                      </div>
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap text-right">
                      <div className="inline-flex items-center gap-1.5">
                        <Button
                          variant="ghost"
                          size="sm"
                          leftIcon={<Pencil className="h-3.5 w-3.5" />}
                          onClick={() => openEdit(stu)}
                        >
                          {t("संपादित", "Edit")}
                        </Button>
                        {stu.hasPin && (
                          <Button
                            variant="ghost"
                            size="sm"
                            leftIcon={<KeyRound className="h-3.5 w-3.5" />}
                            onClick={() => void handleResetPin(stu)}
                          >
                            {t("पिन रीसेट", "Clear PIN")}
                          </Button>
                        )}
                        <Button
                          variant="ghost"
                          size="sm"
                          leftIcon={
                            stu.isActive ? (
                              <UserX className="h-3.5 w-3.5" />
                            ) : (
                              <UserCheck className="h-3.5 w-3.5" />
                            )
                          }
                          onClick={() => void handleToggleActive(stu)}
                        >
                          {stu.isActive ? t("हटाएँ", "Deactivate") : t("सक्रिय", "Activate")}
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </CardContent>
      </Card>

      {/* Pagination */}
      {total > 50 && (
        <div className="flex items-center justify-between">
          <Button
            variant="secondary"
            size="sm"
            disabled={page <= 1}
            onClick={() => setPage((p) => Math.max(1, p - 1))}
          >
            {t("पिछला", "Previous")}
          </Button>
          <span className="text-xs text-ink-secondary">
            {t(`पृष्ठ ${page}`, `Page ${page} of ${Math.ceil(total / 50)}`)}
          </span>
          <Button
            variant="secondary"
            size="sm"
            disabled={page * 50 >= total}
            onClick={() => setPage((p) => p + 1)}
          >
            {t("अगला", "Next")}
          </Button>
        </div>
      )}

      {/* Add / Edit Student Modal */}
      <Modal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        title={
          editing
            ? t("विद्यार्थी विवरण संपादित करें", "Edit Student Details")
            : t("नया विद्यार्थी जोड़ें", "Add Student")
        }
      >
        <form onSubmit={handleSave} className="space-y-4">
          <Input
            label={t("विद्यार्थी का नाम", "Student Name")}
            required
            value={studentName}
            onChange={(e) => setStudentName(e.target.value)}
          />
          {!editing && (
            <Input
              label={t("छात्र कोड (वैकल्पिक — 15 अंक)", "Student Code (Optional)")}
              value={studentCode}
              onChange={(e) => setStudentCode(e.target.value)}
            />
          )}
          <Input
            label={t("पिता का नाम", "Father's Name")}
            value={fatherName}
            onChange={(e) => setFatherName(e.target.value)}
          />
          <DobDropdownPicker
            value={dob}
            onChange={setDob}
            label={t("जन्म तिथि", "Date of Birth")}
            required
          />
          <div className="grid grid-cols-2 gap-3">
            <Select
              label={t("कक्षा", "Class")}
              value={classNum}
              onChange={(e) => setClassNum(e.target.value)}
              options={[
                { value: "9", label: t("कक्षा 9", "Class 9") },
                { value: "10", label: t("कक्षा 10", "Class 10") },
                { value: "11", label: t("कक्षा 11", "Class 11") },
                { value: "12", label: t("कक्षा 12", "Class 12") },
              ]}
            />
            <Input
              label={t("रोल नंबर", "Roll Number")}
              type="number"
              min={1}
              required
              value={rollNo}
              onChange={(e) => setRollNo(e.target.value)}
            />
          </div>
          {Number(classNum) >= 11 && (
            <Select
              label={t("संकाय", "Stream")}
              value={stream}
              onChange={(e) => setStream(e.target.value)}
              options={[
                { value: "UNSET", label: t("चयन शेष", "Student will choose on login") },
                { value: "Science", label: t("विज्ञान (Science)", "Science") },
                { value: "Arts", label: t("कला (Arts)", "Arts") },
                { value: "Commerce", label: t("वाणिज्य (Commerce)", "Commerce") },
              ]}
            />
          )}
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="secondary" onClick={() => setModalOpen(false)}>
              {t("रद्द करें", "Cancel")}
            </Button>
            <Button type="submit" variant="primary" loading={saving}>
              {t("सहेजें", "Save")}
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
