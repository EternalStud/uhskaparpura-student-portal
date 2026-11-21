"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import {
  AlertTriangle,
  ArrowLeft,
  ArrowRight,
  Award,
  BookOpen,
  CheckCircle2,
  Clock,
  HelpCircle,
  Lightbulb,
  Lock,
  Printer,
  Sparkles,
  Target,
} from "lucide-react";
import type {
  ChapterNoteRow,
  ChapterRow,
  GlossaryTerm,
  SubjectRow,
} from "@/types/database";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import {
  Badge,
  Button,
  Card,
  MathMarkdown,
  ReadAloudButton,
  useToast,
} from "@/components/ui";
import { BilingualDiagramRenderer, MindmapViewer } from "@/components/visual";
import { cn } from "@/components/ui/cn";

interface NotesApiResponse {
  locked?: boolean;
  examId?: string;
  examTitle?: string;
  error?: string;
  errorEn?: string;
  chapter?: ChapterRow;
  subject?: SubjectRow | null;
  note?: ChapterNoteRow | null;
  progress?: {
    notes_completed: boolean;
    notes_progress_pct: number;
    mastery_pct: number;
  };
  practiceCounts?: {
    total: number;
    mcq: number;
    visual: number;
    subjective: number;
  };
  navigation?: {
    prevChapter: { id: string; chapter_no: number; title_hi: string; title_en: string } | null;
    nextChapter: { id: string; chapter_no: number; title_hi: string; title_en: string } | null;
  };
}

export function VisualNotesReader({ chapterId }: { chapterId: string }) {
  const { lang, t } = useLanguage();
  const toast = useToast();

  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<NotesApiResponse | null>(null);
  const [markingDone, setMarkingDone] = useState(false);
  const [notesCompleted, setNotesCompleted] = useState(false);
  const [activeGlossary, setActiveGlossary] = useState<GlossaryTerm | null>(null);
  const [revealedChecks, setRevealedChecks] = useState<Record<string, boolean>>({});

  useEffect(() => {
    let active = true;
    async function load() {
      setLoading(true);
      try {
        const res = await fetch(`/api/notes/${encodeURIComponent(chapterId)}`, {
          cache: "no-store",
        });
        const json = (await res.json()) as NotesApiResponse;
        if (!active) return;
        setData(json);
        setNotesCompleted(Boolean(json.progress?.notes_completed));
      } catch {
        if (active) {
          setData({
            error: "अध्याय नोट्स लोड नहीं हो सके।",
            errorEn: "Unable to load chapter notes.",
          });
        }
      } finally {
        if (active) setLoading(false);
      }
    }
    load();
    return () => {
      active = false;
    };
  }, [chapterId]);

  const handleMarkCompleted = async () => {
    setMarkingDone(true);
    try {
      const res = await fetch(`/api/notes/${encodeURIComponent(chapterId)}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ notesCompleted: true, notesProgressPct: 100 }),
      });
      const json = (await res.json()) as {
        ok?: boolean;
        pointsAwarded?: number;
        error?: string;
      };
      if (!res.ok || !json.ok) {
        toast.error(
          t("सहेजा नहीं जा सका", "Could not save progress"),
          json.error
        );
        return;
      }
      setNotesCompleted(true);
      toast.success(
        t("अध्याय नोट्स पूरे हुए!", "Chapter Notes Completed!"),
        json.pointsAwarded && json.pointsAwarded > 0
          ? t(
              `शाबाश! आपको +${json.pointsAwarded} अध्ययन अंक मिले। अब अभ्यास करें!`,
              `Well done! You earned +${json.pointsAwarded} mastery points. Ready for practice!`
            )
          : t("आपका पुनरावृत्ति रिकॉर्ड सहेजा गया है।", "Your revision record is saved.")
      );
    } finally {
      setMarkingDone(false);
    }
  };

  if (loading) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="h-10 w-2/3 rounded-lg bg-surface-subtle" />
        <div className="h-64 rounded-paper bg-surface-subtle" />
        <div className="h-80 rounded-paper bg-surface-subtle" />
      </div>
    );
  }

  // 423 Locked during Live Classroom Exam
  if (data?.locked) {
    return (
      <Card variant="warm" className="max-w-xl mx-auto text-center py-8 space-y-4">
        <div className="mx-auto inline-flex h-14 w-14 items-center justify-center rounded-full bg-amber-soft text-amber-ink">
          <Lock className="h-7 w-7" />
        </div>
        <h1 className="text-xl font-bold text-ink">
          {t("लाइव परीक्षा चल रही है", "Live Classroom Exam in Progress")}
        </h1>
        <p className="text-sm text-ink-secondary leading-relaxed">
          {t(
            data.error ?? "लाइव परीक्षा के दौरान नोट्स अस्थायी रूप से बंद हैं।",
            data.errorEn ?? "Notes are temporarily paused while your live exam is active."
          )}
        </p>
        {data.examId && (
          <Link href={`/student/exams/${data.examId}`}>
            <Button variant="primary" size="lg">
              {t("लाइव परीक्षा पर वापस जाएँ", "Return to Live Exam")}
            </Button>
          </Link>
        )}
      </Card>
    );
  }

  if (!data?.chapter) {
    return (
      <Card className="max-w-xl mx-auto text-center py-8 space-y-3">
        <p className="text-base font-semibold text-crimson-ink">
          {t(data?.error ?? "अध्याय नहीं मिला।", data?.errorEn ?? "Chapter not found.")}
        </p>
        <Link href="/student">
          <Button variant="secondary" leftIcon={<ArrowLeft className="h-4 w-4" />}>
            {t("पढ़ाई होम पर जाएँ", "Back to Study Home")}
          </Button>
        </Link>
      </Card>
    );
  }

  const { chapter, subject, note, practiceCounts, navigation } = data;

  return (
    <article className="space-y-6 pb-16">
      {/* Breadcrumb & Top Controls */}
      <div className="flex flex-wrap items-center justify-between gap-3 no-print">
        <Link
          href={subject ? `/student/subject/${subject.id}` : "/student"}
          className="inline-flex items-center gap-1.5 text-sm font-semibold text-indigo-ink hover:underline"
        >
          <ArrowLeft className="h-4 w-4" />
          <span>
            {subject ? (
              <BiText hi={subject.name_hi} en={subject.name_en} inline />
            ) : (
              t("मेरे विषय", "My Subjects")
            )}
          </span>
        </Link>

        <div className="flex flex-wrap items-center gap-2">
          <Button
            size="sm"
            variant="secondary"
            onClick={() => window.print()}
            leftIcon={<Printer className="h-4 w-4" />}
          >
            {t("प्रिंट / PDF", "Print Notes")}
          </Button>
          <Link href={`/student/chapter/${chapter.id}/practice`}>
            <Button
              size="sm"
              variant="primary"
              rightIcon={<ArrowRight className="h-4 w-4" />}
            >
              {t("अभ्यास शुरू करें", "Start Practice")}
            </Button>
          </Link>
        </div>
      </div>

      {/* Chapter Title Banner */}
      <Card variant="indigo" padding="lg" className="space-y-3">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant="indigo">
            {t(`अध्याय ${chapter.chapter_no}`, `Chapter ${chapter.chapter_no}`)}
          </Badge>
          <Badge variant="amber" icon={<Award className="h-3.5 w-3.5" />}>
            {t(
              `बिहार बोर्ड भार: ${chapter.bseb_weightage_marks} अंक`,
              `BSEB Weightage: ${chapter.bseb_weightage_marks} Marks`
            )}
          </Badge>
          <Badge variant="neutral" icon={<Clock className="h-3.5 w-3.5" />}>
            {t(`${chapter.estimated_mins} मिनट`, `${chapter.estimated_mins} min read`)}
          </Badge>
          {notesCompleted && (
            <Badge variant="emerald" icon={<CheckCircle2 className="h-3.5 w-3.5" />}>
              {t("पूर्ण", "Completed")}
            </Badge>
          )}
        </div>

        <h1 className="text-2xl sm:text-3xl font-bold text-ink leading-tight">
          <BiText hi={chapter.title_hi} en={chapter.title_en} />
        </h1>

        {(chapter.summary_hi || chapter.summary_en) && (
          <p className="text-sm sm:text-base text-ink-secondary leading-relaxed max-w-3xl">
            <BiText hi={chapter.summary_hi ?? ""} en={chapter.summary_en ?? ""} />
          </p>
        )}

        <div className="pt-1 flex flex-wrap items-center gap-2.5 no-print">
          <ReadAloudButton
            textHi={`${chapter.title_hi}. ${chapter.summary_hi ?? ""}`}
            textEn={`${chapter.title_en}. ${chapter.summary_en ?? ""}`}
            label={t("सारांश सुनें", "Listen to Overview")}
          />
          {practiceCounts && practiceCounts.total > 0 && (
            <span className="text-xs text-ink-secondary font-medium">
              {t(
                `इस अध्याय में ${practiceCounts.total} अभ्यास प्रश्न तैयार हैं`,
                `${practiceCounts.total} practice questions ready in this chapter`
              )}
            </span>
          )}
        </div>
      </Card>

      {/* No Published Visual Note Yet — Dignified Fallback */}
      {!note && (
        <Card className="text-center py-10 space-y-3">
          <BookOpen className="h-10 w-10 text-indigo-ink mx-auto opacity-80" />
          <h2 className="text-lg font-bold text-ink">
            {t(
              "इस अध्याय के विस्तृत विज़ुअल नोट्स तैयार किए जा रहे हैं",
              "Detailed Visual Notes for This Chapter Are Being Prepared"
            )}
          </h2>
          <p className="text-sm text-ink-secondary max-w-md mx-auto">
            {t(
              "हमारे विषय-विशेषज्ञ इस अध्याय के चित्र, उदाहरण और बोर्ड कैप्सूल पर काम कर रहे हैं। तब तक आप उपलब्ध अभ्यास और कक्षा सामग्री देख सकते हैं।",
              "Our academic editors are crafting analogies, diagrams, and board capsules for this chapter. You can explore practice and classroom notes in the meantime."
            )}
          </p>
        </Card>
      )}

      {/* Full Gold Visual Notes */}
      {note && (
        <>
          {/* 1. 30-Second Visual Mindmap */}
          <MindmapViewer spec={note.mindmap_json} />

          {/* 2. Simple-to-Deep Structured Concept Sections */}
          <div className="space-y-6">
            {note.sections_json.map((sec) => {
              const showCheck = Boolean(revealedChecks[sec.id]);
              return (
                <Card key={sec.id} padding="lg" className="space-y-5">
                  <div className="flex flex-wrap items-start justify-between gap-3 border-b border-hairline pb-3.5">
                    <h2 className="text-lg sm:text-xl font-bold text-ink leading-snug">
                      <BiText hi={sec.heading_hi} en={sec.heading_en} />
                    </h2>
                    <ReadAloudButton
                      textHi={`${sec.heading_hi}. ${sec.analogy_hi}. ${sec.concept_md_hi}`}
                      textEn={`${sec.heading_en}. ${sec.analogy_en}. ${sec.concept_md_en}`}
                      size="sm"
                    />
                  </div>

                  {/* Everyday Bihar Analogy Box */}
                  {(sec.analogy_hi || sec.analogy_en) && (
                    <div className="rounded-paper border border-amber-warm/30 bg-surface-warm p-4 space-y-1.5">
                      <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-amber-ink">
                        <Lightbulb className="h-4 w-4 shrink-0" />
                        <span>{t("सरल दैनिक उदाहरण (आसानी से समझें)", "Everyday Analogy (Understand Easily)")}</span>
                      </div>
                      {lang === "BOTH" ? (
                        <div className="space-y-2 text-sm sm:text-[15px] leading-relaxed text-ink">
                          <MathMarkdown content={sec.analogy_hi} />
                          <div className="pt-2 border-t border-amber-warm/20 text-ink-secondary">
                            <MathMarkdown content={sec.analogy_en} />
                          </div>
                        </div>
                      ) : (
                        <MathMarkdown
                          content={lang === "EN" ? sec.analogy_en : sec.analogy_hi}
                          className="text-sm sm:text-[15px]"
                        />
                      )}
                    </div>
                  )}

                  {/* Declarative Live-Translating Visual Diagram / Table / Flowchart / Timeline */}
                  {sec.visual_diagram && (
                    <BilingualDiagramRenderer spec={sec.visual_diagram} />
                  )}

                  {/* In-Depth Bilingual KaTeX Concept Explanation */}
                  <div className="space-y-3">
                    {lang === "BOTH" ? (
                      <>
                        <MathMarkdown content={sec.concept_md_hi} />
                        <div className="pt-3 border-t border-hairline text-ink-secondary">
                          <MathMarkdown content={sec.concept_md_en} />
                        </div>
                      </>
                    ) : (
                      <MathMarkdown
                        content={lang === "EN" ? sec.concept_md_en : sec.concept_md_hi}
                      />
                    )}
                  </div>

                  {/* Interactive Tap-to-Read Glossary Terms */}
                  {sec.glossary_terms && sec.glossary_terms.length > 0 && (
                    <div className="pt-2 space-y-2.5">
                      <div className="text-xs font-bold uppercase tracking-wider text-ink-muted">
                        {t("कठिन शब्द — अर्थ जानने के लिए टैप करें", "Key Glossary Terms — Tap to Read Meaning")}
                      </div>
                      <div className="flex flex-wrap gap-2">
                        {sec.glossary_terms.map((term, idx) => {
                          const isOpen = activeGlossary?.term_en === term.term_en;
                          return (
                            <button
                              key={idx}
                              type="button"
                              onClick={() => setActiveGlossary(isOpen ? null : term)}
                              className={cn(
                                "inline-flex items-center gap-1.5 rounded-full border px-3 py-1.5 text-xs font-semibold transition-all",
                                isOpen
                                  ? "bg-indigo-academic text-white border-indigo-academic"
                                  : "bg-indigo-soft text-indigo-ink border-indigo-academic/25 hover:border-indigo-academic"
                              )}
                            >
                              <HelpCircle className="h-3.5 w-3.5" />
                              <BiText hi={term.term_hi} en={term.term_en} inline />
                            </button>
                          );
                        })}
                      </div>

                      {activeGlossary &&
                        sec.glossary_terms.some((g) => g.term_en === activeGlossary.term_en) && (
                          <div className="rounded-lg border border-indigo-academic/25 bg-indigo-soft p-3.5 text-sm text-ink space-y-1">
                            <div className="font-bold text-indigo-ink">
                              <BiText hi={activeGlossary.term_hi} en={activeGlossary.term_en} inline />
                            </div>
                            <div className="text-ink-secondary leading-relaxed">
                              <MathMarkdown
                                content={
                                  lang === "EN"
                                    ? activeGlossary.definition_en
                                    : lang === "HI"
                                    ? activeGlossary.definition_hi
                                    : `${activeGlossary.definition_hi}\n\n*${activeGlossary.definition_en}*`
                                }
                              />
                            </div>
                          </div>
                        )}
                    </div>
                  )}

                  {/* Board Exam Tip Box */}
                  {(sec.exam_tip_hi || sec.exam_tip_en) && (
                    <div className="rounded-lg border border-indigo-academic/25 bg-indigo-soft px-4 py-3 flex items-start gap-2.5">
                      <Target className="h-4 w-4 text-indigo-ink shrink-0 mt-1" />
                      <div className="text-sm text-ink leading-relaxed">
                        <span className="font-bold text-indigo-ink mr-1.5">
                          {t("बोर्ड परीक्षा टिप:", "BSEB Exam Tip:")}
                        </span>
                        <MathMarkdown
                          inline
                          content={
                            lang === "EN"
                              ? sec.exam_tip_en
                              : lang === "HI"
                              ? sec.exam_tip_hi
                              : `${sec.exam_tip_hi} — ${sec.exam_tip_en}`
                          }
                        />
                      </div>
                    </div>
                  )}

                  {/* Quick Self-Check Toggle */}
                  {sec.quick_check && (
                    <div className="rounded-lg border border-emerald-mastery/30 bg-emerald-soft p-4 space-y-2 no-print">
                      <div className="flex flex-wrap items-center justify-between gap-2">
                        <span className="text-xs font-bold uppercase tracking-wider text-emerald-ink">
                          {t("खुद को जाँचें (Quick Check)", "Quick Self-Check")}
                        </span>
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() =>
                            setRevealedChecks((prev) => ({ ...prev, [sec.id]: !prev[sec.id] }))
                          }
                        >
                          {showCheck
                            ? t("उत्तर छिपाएँ", "Hide Answer")
                            : t("उत्तर देखें", "Show Answer")}
                        </Button>
                      </div>
                      <div className="text-sm font-semibold text-ink">
                        <MathMarkdown
                          inline
                          content={lang === "EN" ? sec.quick_check.q_en : sec.quick_check.q_hi}
                        />
                      </div>
                      {showCheck && (
                        <div className="pt-2 border-t border-emerald-mastery/20 text-sm text-emerald-ink font-medium">
                          <MathMarkdown
                            inline
                            content={
                              lang === "EN"
                                ? sec.quick_check.answer_en
                                : sec.quick_check.answer_hi
                            }
                          />
                        </div>
                      )}
                    </div>
                  )}
                </Card>
              );
            })}
          </div>

          {/* 3. Board Exam Capsule (Formulas, Facts, Common Mistakes, PYQs) */}
          {note.board_capsule_json && (
            <Card variant="subtle" padding="lg" className="space-y-5">
              <div className="flex items-center gap-2.5 border-b border-hairline pb-3">
                <Sparkles className="h-5 w-5 text-amber-ink shrink-0" />
                <h2 className="text-lg font-bold text-ink">
                  <BiText
                    hi="बोर्ड परीक्षा कैप्सूल (अंतिम रिवीजन सार)"
                    en="Board Exam Capsule (Last-Minute Master Summary)"
                  />
                </h2>
              </div>

              {note.board_capsule_json.important_formulas?.length > 0 && (
                <div className="space-y-2.5">
                  <h3 className="text-sm font-bold text-indigo-ink">
                    {t("ज़रूरी सूत्र (Important Formulas)", "Important Formulas")}
                  </h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    {note.board_capsule_json.important_formulas.map((f, idx) => (
                      <div
                        key={idx}
                        className="rounded-lg border border-hairline bg-surface p-3.5 text-center space-y-1.5"
                      >
                        <div className="overflow-x-auto">
                          <MathMarkdown content={`$$${f.latex}$$`} />
                        </div>
                        <div className="text-xs font-semibold text-ink-secondary">
                          <BiText hi={f.label_hi} en={f.label_en} inline />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {note.board_capsule_json.key_dates_or_facts?.length > 0 && (
                <div className="space-y-2">
                  <h3 className="text-sm font-bold text-indigo-ink">
                    {t("मुख्य तथ्य व तिथियाँ", "Key Dates & Facts")}
                  </h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                    {note.board_capsule_json.key_dates_or_facts.map((item, idx) => (
                      <div
                        key={idx}
                        className="rounded-lg border border-hairline bg-surface px-3.5 py-2.5 flex items-start gap-2.5"
                      >
                        <Badge variant="indigo" className="mt-0.5">
                          {item.tag}
                        </Badge>
                        <p className="text-xs sm:text-sm text-ink-secondary leading-relaxed">
                          <BiText hi={item.fact_hi} en={item.fact_en} />
                        </p>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {note.board_capsule_json.common_bseb_mistakes?.length > 0 && (
                <div className="space-y-2.5">
                  <h3 className="text-sm font-bold text-crimson-ink flex items-center gap-1.5">
                    <AlertTriangle className="h-4 w-4" />
                    {t("बोर्ड परीक्षा में ये गलतियाँ न करें", "Common BSEB Mistakes to Avoid")}
                  </h3>
                  <div className="space-y-2.5">
                    {note.board_capsule_json.common_bseb_mistakes.map((m, idx) => (
                      <div
                        key={idx}
                        className="rounded-lg border border-hairline bg-surface p-3.5 grid grid-cols-1 md:grid-cols-2 gap-3 text-xs sm:text-sm"
                      >
                        <div className="text-crimson-ink">
                          <strong className="block mb-0.5">
                            {t("सामान्य गलती:", "Mistake:")}
                          </strong>
                          <BiText hi={m.mistake_hi} en={m.mistake_en} />
                        </div>
                        <div className="text-emerald-ink">
                          <strong className="block mb-0.5">
                            {t("सही तरीका:", "How to Fix:")}
                          </strong>
                          <BiText hi={m.fix_hi} en={m.fix_en} />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </Card>
          )}
        </>
      )}

      {/* Completion & Next Action Bar */}
      <Card className="flex flex-wrap items-center justify-between gap-4 no-print">
        <div className="space-y-1">
          <div className="font-bold text-base text-ink">
            {notesCompleted
              ? t("आपने यह अध्याय पढ़ लिया है — अब अभ्यास पक्का करें!", "Chapter notes completed — lock it in with practice!")
              : t("अध्याय पढ़ लिया? इसे पूरा चिह्नित करें (+20 अंक)", "Finished reading? Mark this chapter complete (+20 pts)")}
          </div>
          <p className="text-xs sm:text-sm text-ink-secondary">
            {t(
              "फ्लैशकार्ड, मिलान, ऑब्जेक्टिव, 2-अंक व 5-अंक उत्तर लेखन और OMR अभ्यास तैयार हैं।",
              "Flashcards, Match-Pairs, 3-Tier MCQs, 2M/5M Answer Coach & OMR Simulator are ready."
            )}
          </p>
        </div>

        <div className="flex flex-wrap items-center gap-2.5">
          {!notesCompleted && (
            <Button
              variant="emerald"
              size="lg"
              loading={markingDone}
              onClick={handleMarkCompleted}
              leftIcon={<CheckCircle2 className="h-4 w-4" />}
            >
              {t("नोट्स पूरे हुए (+20)", "Mark Notes Done (+20)")}
            </Button>
          )}
          <Link href={`/student/chapter/${chapter.id}/practice`}>
            <Button
              variant="primary"
              size="lg"
              rightIcon={<ArrowRight className="h-4 w-4" />}
            >
              {t("6-मोड अभ्यास खोलें", "Open 6-Mode Practice")}
            </Button>
          </Link>
        </div>
      </Card>

      {/* Prev / Next Chapter Navigation */}
      {navigation && (navigation.prevChapter || navigation.nextChapter) && (
        <div className="flex flex-wrap items-center justify-between gap-3 pt-2 no-print">
          {navigation.prevChapter ? (
            <Link href={`/student/chapter/${navigation.prevChapter.id}/notes`}>
              <Button variant="secondary" leftIcon={<ArrowLeft className="h-4 w-4" />}>
                {t(`अध्याय ${navigation.prevChapter.chapter_no}`, `Ch ${navigation.prevChapter.chapter_no}`)}
              </Button>
            </Link>
          ) : (
            <div />
          )}
          {navigation.nextChapter && (
            <Link href={`/student/chapter/${navigation.nextChapter.id}/notes`}>
              <Button variant="secondary" rightIcon={<ArrowRight className="h-4 w-4" />}>
                {t(`अगला: अध्याय ${navigation.nextChapter.chapter_no}`, `Next: Ch ${navigation.nextChapter.chapter_no}`)}
              </Button>
            </Link>
          )}
        </div>
      )}
    </article>
  );
}
