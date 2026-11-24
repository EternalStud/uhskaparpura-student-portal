"use client";

import React, { useState } from "react";
import {
  AlignCenter,
  AlignJustify,
  AlignLeft,
  AlignRight,
  BarChart3,
  Bold,
  CheckCircle2,
  Clipboard,
  Copy,
  FilePlus,
  FileSpreadsheet,
  FileText,
  Filter,
  FolderOpen,
  Image as ImageIcon,
  Italic,
  Lightbulb,
  Link2,
  List,
  ListOrdered,
  Lock,
  Mail,
  MessageSquare,
  PaintBucket,
  PenTool,
  Printer,
  Redo2,
  RotateCcw,
  Save,
  Scissors,
  Search,
  ShieldAlert,
  ShieldCheck,
  Sigma,
  SortAsc,
  Sparkles,
  Table2,
  Type,
  Underline,
  Undo2,
  XCircle,
} from "lucide-react";
import type { QuestionRow, ScenarioLabAsset } from "@/types/database";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Button, Card } from "@/components/ui";
import { BilingualDiagramRenderer } from "@/components/visual";
import { cn } from "@/components/ui/cn";

const CHOICE_ICON_MAP: Record<string, React.ComponentType<{ className?: string }>> = {
  Bold,
  Italic,
  Underline,
  AlignLeft,
  AlignCenter,
  AlignRight,
  AlignJustify,
  Save,
  Printer,
  Copy,
  Scissors,
  Clipboard,
  Undo2,
  Undo: Undo2,
  Redo2,
  Redo: Redo2,
  Search,
  Sigma,
  Table: Table2,
  Table2,
  BarChart3,
  BarChart: BarChart3,
  Filter,
  SortAsc,
  PaintBucket,
  Type,
  List,
  ListOrdered,
  Link2,
  Link: Link2,
  Image: ImageIcon,
  FilePlus,
  FolderOpen,
  FileText,
  FileSpreadsheet,
  Mail,
  ShieldAlert,
  ShieldCheck,
  Lock,
  Sparkles,
  MessageSquare,
  PenTool,
  CheckCircle2,
};

function ChoiceIcon({ name, className }: { name?: string; className?: string }) {
  if (!name) return null;
  const Comp = CHOICE_ICON_MAP[name];
  if (!Comp) return null;
  return <Comp className={className ?? "h-4 w-4 shrink-0"} aria-hidden="true" />;
}

export interface ScenarioLabProps {
  question: QuestionRow;
  asset: ScenarioLabAsset;
  index: number;
  initiallyMastered?: boolean;
  onComplete: (result: {
    questionId: string;
    selectedChoiceId: string;
    isCorrect: boolean;
  }) => Promise<void> | void;
}

export function ScenarioLab({
  question,
  asset,
  index,
  initiallyMastered = false,
  onComplete,
}: ScenarioLabProps) {
  const { lang, t } = useLanguage();

  const [selectedId, setSelectedId] = useState<string | null>(
    initiallyMastered ? asset.correct_choice_id : null
  );
  const [solved, setSolved] = useState<boolean>(initiallyMastered);
  const [wrongPicks, setWrongPicks] = useState<string[]>([]);
  const [submitting, setSubmitting] = useState(false);

  const variantMeta = (() => {
    switch (asset.variant) {
      case "RIBBON_DETECTIVE":
        return {
          badgeHi: "टूलबार पहचान लैब",
          badgeEn: "Ribbon Detective",
          icon: <PenTool className="h-3.5 w-3.5" />,
          cardTone: "border-indigo-academic/25 bg-indigo-soft",
          headerColor: "text-indigo-ink",
        };
      case "CYBER_SAFETY":
        return {
          badgeHi: "साइबर सुरक्षा चुनौती",
          badgeEn: "Cyber Safety Lab",
          icon: <ShieldAlert className="h-3.5 w-3.5" />,
          cardTone: "border-amber-warm/35 bg-surface-warm",
          headerColor: "text-amber-ink",
        };
      case "PICTURE_GRAMMAR":
        return {
          badgeHi: "चित्र व्याकरण लैब",
          badgeEn: "Picture Grammar Lab",
          icon: <Sparkles className="h-3.5 w-3.5" />,
          cardTone: "border-indigo-academic/25 bg-indigo-soft",
          headerColor: "text-indigo-ink",
        };
      case "EMAIL_COMPOSER":
        return {
          badgeHi: "ईमेल अभ्यास लैब",
          badgeEn: "Email Composer Lab",
          icon: <Mail className="h-3.5 w-3.5" />,
          cardTone: "border-indigo-academic/25 bg-indigo-soft",
          headerColor: "text-indigo-ink",
        };
      case "PROMPT_BUILDER":
        return {
          badgeHi: "स्मार्ट प्रॉम्प्ट लैब",
          badgeEn: "Smart Study Prompt Lab",
          icon: <MessageSquare className="h-3.5 w-3.5" />,
          cardTone: "border-indigo-academic/25 bg-indigo-soft",
          headerColor: "text-indigo-ink",
        };
      case "WRITING_TEMPLATE":
        return {
          badgeHi: "लेखन प्रारूप लैब",
          badgeEn: "Writing Template Lab",
          icon: <FileText className="h-3.5 w-3.5" />,
          cardTone: "border-amber-warm/30 bg-surface-warm",
          headerColor: "text-amber-ink",
        };
    }
  })();

  const handleChoose = async (choiceId: string) => {
    if (solved || submitting) return;
    setSelectedId(choiceId);

    const isCorrect = choiceId === asset.correct_choice_id;
    if (isCorrect) {
      setSolved(true);
      setSubmitting(true);
      try {
        await onComplete({
          questionId: question.id,
          selectedChoiceId: choiceId,
          isCorrect: true,
        });
      } finally {
        setSubmitting(false);
      }
    } else {
      setWrongPicks((prev) => (prev.includes(choiceId) ? prev : [...prev, choiceId]));
    }
  };

  const isRibbonLayout = asset.variant === "RIBBON_DETECTIVE";

  return (
    <Card
      padding="lg"
      className={cn(
        "space-y-4 transition-colors",
        solved && "border-emerald-mastery/40"
      )}
    >
      {/* Header */}
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant={solved ? "emerald" : "indigo"} icon={variantMeta.icon}>
            {t(`${variantMeta.badgeHi} #${index + 1}`, `${variantMeta.badgeEn} #${index + 1}`)}
          </Badge>
          {solved && (
            <Badge variant="emerald" icon={<CheckCircle2 className="h-3.5 w-3.5" />}>
              {t("सही निर्णय", "Solved")}
            </Badge>
          )}
        </div>

        {!solved && wrongPicks.length > 0 && (
          <Button
            size="sm"
            variant="ghost"
            onClick={() => {
              setWrongPicks([]);
              setSelectedId(null);
            }}
            leftIcon={<RotateCcw className="h-3.5 w-3.5" />}
          >
            {t("पुनः प्रयास", "Reset")}
          </Button>
        )}
      </div>

      {/* Scene Card */}
      <div className={cn("rounded-paper border p-4 space-y-2", variantMeta.cardTone)}>
        <div className={cn("text-xs font-bold uppercase tracking-wider flex items-center gap-1.5", variantMeta.headerColor)}>
          {variantMeta.icon}
          <BiText hi={asset.scene_title_hi} en={asset.scene_title_en} inline />
        </div>
        <div className="text-sm sm:text-base font-bold text-ink leading-relaxed">
          <BiText hi={asset.prompt_hi} en={asset.prompt_en} />
        </div>
      </div>

      {/* Optional Embedded Declarative Bilingual Visual Diagram (Picture Grammar / Visual Scene) */}
      {asset.scene_diagram && (
        <BilingualDiagramRenderer spec={asset.scene_diagram} compact />
      )}

      {/* Choices — Ribbon Toolbar Grid or Tactile Decision Cards */}
      <div
        className={cn(
          isRibbonLayout
            ? "grid grid-cols-2 sm:grid-cols-4 gap-2.5 rounded-paper border border-hairline-strong bg-surface-subtle/60 p-3"
            : "grid grid-cols-1 sm:grid-cols-2 gap-2.5"
        )}
      >
        {asset.choices.map((choice) => {
          const isRightChoice = solved && choice.id === asset.correct_choice_id;
          const isWrongChoice = wrongPicks.includes(choice.id);
          const isSelected = selectedId === choice.id;

          return (
            <button
              key={choice.id}
              type="button"
              disabled={solved || isWrongChoice}
              onClick={() => void handleChoose(choice.id)}
              className={cn(
                "rounded-lg border transition-all text-left min-h-[52px]",
                isRibbonLayout
                  ? "flex flex-col items-center justify-center gap-2 p-3 text-center"
                  : "flex items-start gap-3 px-3.5 py-3",
                isRightChoice
                  ? "border-emerald-mastery bg-emerald-soft text-emerald-ink ring-2 ring-emerald-mastery/20 font-bold"
                  : isWrongChoice
                  ? "border-crimson-alert/40 bg-crimson-soft text-crimson-ink opacity-70 cursor-not-allowed"
                  : isSelected
                  ? "border-indigo-academic bg-indigo-soft text-indigo-ink"
                  : "border-hairline bg-surface hover:border-indigo-academic/50 hover:bg-indigo-soft"
              )}
            >
              {choice.icon && (
                <span
                  className={cn(
                    "inline-flex items-center justify-center rounded-md border shrink-0",
                    isRibbonLayout ? "h-10 w-10" : "h-8 w-8 mt-0.5",
                    isRightChoice
                      ? "bg-emerald-mastery border-emerald-mastery text-white"
                      : isWrongChoice
                      ? "bg-crimson-alert border-crimson-alert text-white"
                      : "bg-surface-subtle border-hairline text-indigo-ink"
                  )}
                >
                  <ChoiceIcon
                    name={choice.icon}
                    className={isRibbonLayout ? "h-5 w-5" : "h-4 w-4"}
                  />
                </span>
              )}

              <span className="text-xs sm:text-sm font-semibold leading-snug">
                <BiText hi={choice.label_hi} en={choice.label_en} />
              </span>
            </button>
          );
        })}
      </div>

      {/* Gentle Wrong Pick Guidance */}
      {!solved && wrongPicks.length > 0 && (
        <div className="rounded-lg border border-amber-warm/35 bg-surface-warm px-3.5 py-2.5 text-xs sm:text-sm text-amber-ink flex items-start gap-2">
          <XCircle className="h-4 w-4 shrink-0 mt-0.5 text-crimson-ink" />
          <span>
            {question.clue_hi || question.clue_en ? (
              <>
                <strong className="mr-1">{t("फिर से सोचें — संकेत:", "Try again — Hint:")}</strong>
                <BiText hi={question.clue_hi ?? ""} en={question.clue_en ?? ""} inline />
              </>
            ) : (
              t(
                "यह सबसे सही विकल्प नहीं है — परिस्थिति को ध्यान से पढ़कर दूसरा विकल्प चुनें!",
                "That isn't the safest or best choice — read the scene carefully and try another option!"
              )
            )}
          </span>
        </div>
      )}

      {/* Solved Feedback */}
      {solved && (
        <div className="rounded-paper border border-emerald-mastery/30 bg-emerald-soft p-4 space-y-1.5">
          <div className="flex items-center gap-2 font-bold text-sm text-emerald-ink">
            <CheckCircle2 className="h-4 w-4 shrink-0" />
            <span>
              {t("बिल्कुल सही निर्णय! (+10 अंक)", "Spot-on choice! (+10 pts)")}
            </span>
          </div>
          {(question.explanation_hi || question.explanation_en) && (
            <p className="text-xs sm:text-sm text-ink leading-relaxed flex items-start gap-1.5">
              <Lightbulb className="h-4 w-4 text-amber-ink shrink-0 mt-0.5" />
              <span>
                {lang === "EN"
                  ? question.explanation_en ?? question.explanation_hi
                  : lang === "HI"
                  ? question.explanation_hi ?? question.explanation_en
                  : (
                    <BiText
                      hi={question.explanation_hi ?? ""}
                      en={question.explanation_en ?? ""}
                      inline
                    />
                  )}
              </span>
            </p>
          )}
        </div>
      )}
    </Card>
  );
}
