"use client";

import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  AlertTriangle,
  BookOpen,
  CheckCircle2,
  ClipboardList,
  Save,
  ShieldCheck,
} from "lucide-react";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
  Select,
  Tabs,
  useToast,
} from "@/components/ui";

interface SubjectEntry {
  id: string;
  class_num: number;
  stream: string;
  name_en: string;
  name_hi: string;
}

interface ChapterCatalogItem {
  id: string;
  subject_id: string;
  chapter_no: number;
  title_en: string;
  title_hi: string;
  noteStatus: "MISSING" | "DRAFT" | "PUBLISHED";
  noteVersion: number;
  hasLessonPlan: boolean;
  lessonPeriods: number | null;
  practiceQuestionsCount: number;
  examOnlyQuestionsCount: number;
}

export function CurriculumCmsClient() {
  const toast = useToast();

  const [subjects, setSubjects] = useState<SubjectEntry[]>([]);
  const [chapters, setChapters] = useState<ChapterCatalogItem[]>([]);
  const [loading, setLoading] = useState(true);

  const [selectedSubjectId, setSelectedSubjectId] = useState("");
  const [selectedChapterId, setSelectedChapterId] = useState("");
  const [editorTab, setEditorTab] = useState<"NOTES" | "LESSON_PLAN">("NOTES");

  // Note editor state
  const [mindmapText, setMindmapText] = useState("");
  const [sectionsText, setSectionsText] = useState("");
  const [capsuleText, setCapsuleText] = useState("");
  const [readiness, setReadiness] = useState<{
    hasLessonPlan: boolean;
    publishedPracticeQuestions: number;
  } | null>(null);
  const [failedGates, setFailedGates] = useState<string[]>([]);

  // Lesson Plan editor state
  const [periods, setPeriods] = useState(4);
  const [objHi, setObjHi] = useState("");
  const [objEn, setObjEn] = useState("");
  const [stepsText, setStepsText] = useState("[]");
  const [blackboardText, setBlackboardText] = useState("[]");
  const [activitiesText, setActivitiesText] = useState("[]");
  const [homeworkText, setHomeworkText] = useState("[]");
  const [misconceptionsText, setMisconceptionsText] = useState("[]");

  const [loadingEditor, setLoadingEditor] = useState(false);
  const [saving, setSaving] = useState(false);

  const loadCatalog = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/super-admin/cms/chapters", { cache: "no-store" });
      if (!res.ok) throw new Error();
      const json = (await res.json()) as {
        subjects: SubjectEntry[];
        chapters: ChapterCatalogItem[];
      };
      setSubjects(json.subjects);
      setChapters(json.chapters);
    } catch {
      toast.error("Failed to load BSEB curriculum catalog");
    } finally {
      setLoading(false);
    }
  }, [toast]);

  useEffect(() => {
    void loadCatalog();
  }, [loadCatalog]);

  const filteredChapters = useMemo(() => {
    if (!selectedSubjectId) return chapters;
    return chapters.filter((c) => c.subject_id === selectedSubjectId);
  }, [chapters, selectedSubjectId]);

  const openChapter = async (chapterId: string) => {
    setSelectedChapterId(chapterId);
    setFailedGates([]);
    setLoadingEditor(true);
    try {
      const [noteRes, planRes] = await Promise.all([
        fetch(`/api/super-admin/cms/notes/${chapterId}`, { cache: "no-store" }),
        fetch(`/api/super-admin/cms/lesson-plans/${chapterId}`, { cache: "no-store" }),
      ]);

      if (noteRes.ok) {
        const noteJson = (await noteRes.json()) as {
          note: {
            mindmap_json: unknown;
            sections_json: unknown;
            board_capsule_json: unknown;
          } | null;
          readiness: { hasLessonPlan: boolean; publishedPracticeQuestions: number };
        };
        setReadiness(noteJson.readiness);
        if (noteJson.note) {
          setMindmapText(JSON.stringify(noteJson.note.mindmap_json, null, 2));
          setSectionsText(JSON.stringify(noteJson.note.sections_json, null, 2));
          setCapsuleText(JSON.stringify(noteJson.note.board_capsule_json, null, 2));
        } else {
          setMindmapText(
            JSON.stringify(
              {
                title_hi: "30 सेकंड सारांश मानचित्र",
                title_en: "30-Second Mind Map",
                read_time_seconds: 30,
                central_node: {
                  id: "root",
                  label_hi: "मुख्य अध्याय",
                  label_en: "Core Chapter",
                },
                branches: [
                  { id: "b1", label_hi: "मुख्य अवधारणा 1", label_en: "Core Concept 1" },
                ],
              },
              null,
              2
            )
          );
          setSectionsText(
            JSON.stringify(
              [
                {
                  id: "sec-1",
                  order: 1,
                  heading_hi: "प्रमुख सिद्धांत",
                  heading_en: "Key Concept",
                  analogy_hi: "दैनिक बिहार जीवन से सरल उदाहरण यहाँ लिखें...",
                  analogy_en: "Write a simple everyday Bihar analogy here...",
                  concept_md_hi: "सरल से गहन हिंदी अवधारणा और सूत्र...",
                  concept_md_en: "Simple-to-deep English concept explanation...",
                  exam_tip_hi: "बिहार बोर्ड परीक्षा के लिए विशेष सुझाव...",
                  exam_tip_en: "BSEB board exam tip...",
                  glossary_terms: [],
                },
              ],
              null,
              2
            )
          );
          setCapsuleText(
            JSON.stringify(
              {
                important_formulas: [],
                key_dates_or_facts: [],
                common_bseb_mistakes: [],
                high_yield_pyq_topics: [],
              },
              null,
              2
            )
          );
        }
      }

      if (planRes.ok) {
        const planJson = (await planRes.json()) as {
          lessonPlan: {
            duration_periods: number;
            objectives_hi: string;
            objectives_en: string;
            teaching_steps_json: unknown;
            blackboard_points_json: unknown;
            classroom_activities_json: unknown;
            homework_json: unknown;
            common_student_misconceptions_json: unknown;
          } | null;
        };
        if (planJson.lessonPlan) {
          setPeriods(planJson.lessonPlan.duration_periods);
          setObjHi(planJson.lessonPlan.objectives_hi);
          setObjEn(planJson.lessonPlan.objectives_en);
          setStepsText(JSON.stringify(planJson.lessonPlan.teaching_steps_json, null, 2));
          setBlackboardText(JSON.stringify(planJson.lessonPlan.blackboard_points_json, null, 2));
          setActivitiesText(JSON.stringify(planJson.lessonPlan.classroom_activities_json, null, 2));
          setHomeworkText(JSON.stringify(planJson.lessonPlan.homework_json, null, 2));
          setMisconceptionsText(
            JSON.stringify(planJson.lessonPlan.common_student_misconceptions_json, null, 2)
          );
        } else {
          setPeriods(4);
          setObjHi("");
          setObjEn("");
          setStepsText("[]");
          setBlackboardText("[]");
          setActivitiesText("[]");
          setHomeworkText("[]");
          setMisconceptionsText("[]");
        }
      }
    } finally {
      setLoadingEditor(false);
    }
  };

  const saveNotes = async (status: "DRAFT" | "PUBLISHED") => {
    if (!selectedChapterId) return;
    setFailedGates([]);
    let mindmap_json: unknown;
    let sections_json: unknown;
    let board_capsule_json: unknown;

    try {
      mindmap_json = JSON.parse(mindmapText);
      sections_json = JSON.parse(sectionsText);
      board_capsule_json = JSON.parse(capsuleText || "{}");
    } catch {
      toast.error("Invalid JSON syntax in Mindmap, Sections, or Board Capsule editor");
      return;
    }

    setSaving(true);
    try {
      const res = await fetch(`/api/super-admin/cms/notes/${selectedChapterId}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          status,
          mindmap_json,
          sections_json,
          board_capsule_json,
        }),
      });
      const json = (await res.json()) as {
        ok?: boolean;
        error?: string;
        failedGates?: string[];
        diagramErrors?: string[];
      };

      if (!res.ok || !json.ok) {
        if (json.failedGates) setFailedGates(json.failedGates);
        if (json.diagramErrors) setFailedGates(json.diagramErrors);
        toast.error(json.error || "Could not save chapter notes");
        return;
      }

      toast.success(
        status === "PUBLISHED"
          ? "Gold Chapter Notes published!"
          : "Draft saved cleanly"
      );
      await loadCatalog();
    } finally {
      setSaving(false);
    }
  };

  const saveLessonPlan = async () => {
    if (!selectedChapterId) return;
    let teaching_steps_json: unknown;
    let blackboard_points_json: unknown;
    let classroom_activities_json: unknown;
    let homework_json: unknown;
    let common_student_misconceptions_json: unknown;

    try {
      teaching_steps_json = JSON.parse(stepsText);
      blackboard_points_json = JSON.parse(blackboardText);
      classroom_activities_json = JSON.parse(activitiesText);
      homework_json = JSON.parse(homeworkText);
      common_student_misconceptions_json = JSON.parse(misconceptionsText);
    } catch {
      toast.error("Invalid JSON syntax in Lesson Plan fields");
      return;
    }

    setSaving(true);
    try {
      const res = await fetch(`/api/super-admin/cms/lesson-plans/${selectedChapterId}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          duration_periods: periods,
          objectives_hi: objHi,
          objectives_en: objEn,
          teaching_steps_json,
          blackboard_points_json,
          classroom_activities_json,
          homework_json,
          common_student_misconceptions_json,
        }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string };
      if (!res.ok || !json.ok) {
        toast.error("Failed to save Lesson Plan", json.error);
        return;
      }
      toast.success("Teacher Lesson Plan saved!");
      await loadCatalog();
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <Badge variant="indigo">Gold Curriculum Quality Gate</Badge>
        <h1 className="mt-2 text-2xl font-bold text-ink">
          Visual Bilingual Notes & Teacher Lesson Plan CMS
        </h1>
        <p className="mt-1 text-sm text-ink-secondary">
          Every published chapter must pass strict Hindi/English parity, validated declarative bilingual SVG/table diagrams, Bihar everyday analogies, practice questions, and a Teacher Lesson Plan.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Chapter Browser */}
        <Card className="lg:col-span-4" padding="sm">
          <CardHeader className="pb-3">
            <CardTitle className="text-base">BSEB Chapters ({filteredChapters.length})</CardTitle>
            <Select
              value={selectedSubjectId}
              onChange={(e) => setSelectedSubjectId(e.target.value)}
              options={[
                { value: "", label: "All Subjects (Class 9–12)" },
                ...subjects.map((s) => ({
                  value: s.id,
                  label: `C${s.class_num} ${s.name_en}${s.stream !== "NA" && s.stream !== "ALL" ? ` (${s.stream})` : ""}`,
                })),
              ]}
            />
          </CardHeader>
          <CardContent className="pt-2 space-y-1.5 max-h-[620px] overflow-y-auto">
            {loading ? (
              <div className="h-24 rounded-lg bg-surface-subtle animate-pulse" />
            ) : (
              filteredChapters.map((ch) => {
                const active = ch.id === selectedChapterId;
                return (
                  <button
                    key={ch.id}
                    type="button"
                    onClick={() => void openChapter(ch.id)}
                    className={`w-full text-left rounded-lg border p-3 transition-colors ${
                      active
                        ? "border-indigo-academic bg-indigo-soft"
                        : "border-hairline bg-surface hover:bg-surface-subtle"
                    }`}
                  >
                    <p className="text-xs font-bold text-ink leading-snug">
                      Ch {ch.chapter_no}: {ch.title_en}
                    </p>
                    <p className="text-[11px] text-ink-secondary truncate mt-0.5">{ch.title_hi}</p>
                    <div className="mt-2 flex flex-wrap gap-1">
                      <Badge
                        variant={
                          ch.noteStatus === "PUBLISHED"
                            ? "emerald"
                            : ch.noteStatus === "DRAFT"
                            ? "amber"
                            : "neutral"
                        }
                      >
                        Notes: {ch.noteStatus}
                      </Badge>
                      <Badge variant={ch.hasLessonPlan ? "indigo" : "outline"}>
                        LP: {ch.hasLessonPlan ? "Yes" : "No"}
                      </Badge>
                      <Badge variant="outline">Q: {ch.practiceQuestionsCount}</Badge>
                    </div>
                  </button>
                );
              })
            )}
          </CardContent>
        </Card>

        {/* Editor Area */}
        <div className="lg:col-span-8 space-y-4">
          {!selectedChapterId ? (
            <Card>
              <CardContent className="py-16 text-center space-y-2">
                <BookOpen className="h-8 w-8 text-ink-muted mx-auto" />
                <p className="text-sm text-ink-secondary">
                  Select a BSEB chapter on the left to inspect or edit its Visual Bilingual Notes and Teacher Lesson Plan.
                </p>
              </CardContent>
            </Card>
          ) : loadingEditor ? (
            <div className="h-64 rounded-paper bg-surface-subtle animate-pulse" />
          ) : (
            <>
              <div className="flex flex-wrap items-center justify-between gap-3">
                <Tabs<"NOTES" | "LESSON_PLAN">
                  value={editorTab}
                  onChange={setEditorTab}
                  variant="pills"
                  items={[
                    {
                      id: "NOTES",
                      label: "Visual Chapter Notes",
                      icon: <BookOpen className="h-4 w-4" />,
                    },
                    {
                      id: "LESSON_PLAN",
                      label: "Teacher Lesson Plan",
                      icon: <ClipboardList className="h-4 w-4" />,
                    },
                  ]}
                />

                {readiness && (
                  <div className="flex flex-wrap gap-1.5">
                    <Badge variant={readiness.hasLessonPlan ? "emerald" : "amber"}>
                      Lesson Plan: {readiness.hasLessonPlan ? "Ready" : "Missing"}
                    </Badge>
                    <Badge variant={readiness.publishedPracticeQuestions > 0 ? "emerald" : "amber"}>
                      Practice Qs: {readiness.publishedPracticeQuestions}
                    </Badge>
                  </div>
                )}
              </div>

              {failedGates.length > 0 && (
                <Card variant="warm" padding="sm">
                  <div className="flex items-start gap-2.5 text-xs text-amber-ink">
                    <AlertTriangle className="h-4 w-4 shrink-0 mt-0.5" />
                    <div className="space-y-1">
                      <p className="font-bold">Gold Quality Checklist Gate Blocked Publish:</p>
                      <ul className="list-disc pl-4 space-y-0.5">
                        {failedGates.map((g, idx) => (
                          <li key={idx}>{g}</li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </Card>
              )}

              {editorTab === "NOTES" ? (
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2 text-base">
                      <ShieldCheck className="h-5 w-5 text-emerald-ink" />
                      Structured Visual Chapter Notes (`chapter_notes`)
                    </CardTitle>
                    <CardDescription>
                      All `visual_diagram` specs are strictly verified via `validateBilingualDiagramSpec` on save.
                    </CardDescription>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div>
                      <label className="text-xs font-bold text-ink">
                        30-Second Mindmap Spec (`mindmap_json`)
                      </label>
                      <textarea
                        rows={7}
                        value={mindmapText}
                        onChange={(e) => setMindmapText(e.target.value)}
                        className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface-subtle p-3 font-mono text-xs text-ink"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-bold text-ink">
                        Simple-to-Deep Sections & Bilingual Diagrams (`sections_json`)
                      </label>
                      <textarea
                        rows={12}
                        value={sectionsText}
                        onChange={(e) => setSectionsText(e.target.value)}
                        className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface-subtle p-3 font-mono text-xs text-ink"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-bold text-ink">
                        Board Exam Capsule (`board_capsule_json`)
                      </label>
                      <textarea
                        rows={6}
                        value={capsuleText}
                        onChange={(e) => setCapsuleText(e.target.value)}
                        className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface-subtle p-3 font-mono text-xs text-ink"
                      />
                    </div>

                    <div className="flex flex-wrap justify-end gap-2.5 pt-2">
                      <Button
                        variant="secondary"
                        loading={saving}
                        leftIcon={<Save className="h-4 w-4" />}
                        onClick={() => void saveNotes("DRAFT")}
                      >
                        Save Draft
                      </Button>
                      <Button
                        variant="emerald"
                        loading={saving}
                        leftIcon={<CheckCircle2 className="h-4 w-4" />}
                        onClick={() => void saveNotes("PUBLISHED")}
                      >
                        Run Quality Gate & Publish
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              ) : (
                <Card>
                  <CardHeader>
                    <CardTitle className="text-base">
                      Teacher-Only Classroom Lesson Plan (`lesson_plans`)
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                      <div>
                        <label className="text-xs font-bold text-ink">Duration (Periods)</label>
                        <input
                          type="number"
                          min={1}
                          max={30}
                          value={periods}
                          onChange={(e) => setPeriods(Math.max(1, Number(e.target.value) || 4))}
                          className="mt-1 w-full min-h-[42px] rounded-lg border border-hairline-strong bg-surface px-3 text-sm text-ink"
                        />
                      </div>
                      <div className="sm:col-span-2" />
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                      <div>
                        <label className="text-xs font-bold text-ink">Learning Objectives (Hindi)</label>
                        <textarea
                          rows={3}
                          value={objHi}
                          onChange={(e) => setObjHi(e.target.value)}
                          className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface p-2.5 text-xs text-ink"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-bold text-ink">Learning Objectives (English)</label>
                        <textarea
                          rows={3}
                          value={objEn}
                          onChange={(e) => setObjEn(e.target.value)}
                          className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface p-2.5 text-xs text-ink"
                        />
                      </div>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                      <div>
                        <label className="text-xs font-bold text-ink">Teaching Steps JSON</label>
                        <textarea
                          rows={5}
                          value={stepsText}
                          onChange={(e) => setStepsText(e.target.value)}
                          className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface-subtle p-2.5 font-mono text-xs text-ink"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-bold text-ink">Blackboard Points JSON</label>
                        <textarea
                          rows={5}
                          value={blackboardText}
                          onChange={(e) => setBlackboardText(e.target.value)}
                          className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface-subtle p-2.5 font-mono text-xs text-ink"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-bold text-ink">Classroom Activities JSON</label>
                        <textarea
                          rows={4}
                          value={activitiesText}
                          onChange={(e) => setActivitiesText(e.target.value)}
                          className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface-subtle p-2.5 font-mono text-xs text-ink"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-bold text-ink">Homework & Misconceptions JSON</label>
                        <textarea
                          rows={4}
                          value={homeworkText}
                          onChange={(e) => setHomeworkText(e.target.value)}
                          className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface-subtle p-2.5 font-mono text-xs text-ink"
                        />
                      </div>
                    </div>
                    <div>
                      <label className="text-xs font-bold text-ink">Common Student Misconceptions JSON</label>
                      <textarea
                        rows={4}
                        value={misconceptionsText}
                        onChange={(e) => setMisconceptionsText(e.target.value)}
                        className="mt-1 w-full rounded-lg border border-hairline-strong bg-surface-subtle p-2.5 font-mono text-xs text-ink"
                      />
                    </div>
                    <div className="flex justify-end">
                      <Button
                        variant="primary"
                        loading={saving}
                        leftIcon={<Save className="h-4 w-4" />}
                        onClick={saveLessonPlan}
                      >
                        Save Lesson Plan
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}
