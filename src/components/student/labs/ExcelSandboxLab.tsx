"use client";

import React, { useMemo, useState } from "react";
import {
  CheckCircle2,
  Delete,
  Lightbulb,
  Play,
  RotateCcw,
  Table2,
} from "lucide-react";
import type { ExcelSandboxAsset, QuestionRow } from "@/types/database";
import {
  colIndexToLetter,
  expandHighlightCells,
  getExcelDataStartRow,
  validateExcelSubmission,
} from "@/lib/labs/excel-evaluator";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Button, Card } from "@/components/ui";
import { cn } from "@/components/ui/cn";

export interface ExcelSandboxLabProps {
  question: QuestionRow;
  asset: ExcelSandboxAsset;
  index: number;
  initiallyMastered?: boolean;
  onComplete: (result: {
    questionId: string;
    submittedFormula: string;
    isCorrect: boolean;
  }) => Promise<void> | void;
}

export function ExcelSandboxLab({
  question,
  asset,
  index,
  initiallyMastered = false,
  onComplete,
}: ExcelSandboxLabProps) {
  const { lang, t } = useLanguage();

  const targetCellUpper = asset.target_cell.trim().toUpperCase();
  const dataStartRow = useMemo(
    () =>
      getExcelDataStartRow({
        columns: asset.columns,
        rows: asset.rows,
        target_cell: asset.target_cell,
      }),
    [asset.columns, asset.rows, asset.target_cell]
  );

  const highlightSet = useMemo(
    () => expandHighlightCells(asset.highlight_range),
    [asset.highlight_range]
  );

  const [formula, setFormula] = useState<string>(
    initiallyMastered ? asset.accepted_formulas[0] ?? "" : ""
  );
  const [solved, setSolved] = useState<boolean>(initiallyMastered);
  const [computedValue, setComputedValue] = useState<string | null>(
    initiallyMastered ? asset.expected_value : null
  );
  const [feedback, setFeedback] = useState<{
    kind: "error" | "hint";
    hi: string;
    en: string;
  } | null>(null);
  const [submitting, setSubmitting] = useState(false);

  const handleChipTap = (chip: string) => {
    if (solved) return;
    setFormula((prev) => `${prev}${chip}`);
    setFeedback(null);
  };

  const handleEvaluate = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (solved || !formula.trim()) return;

    const check = validateExcelSubmission({
      submittedFormula: formula,
      acceptedFormulas: asset.accepted_formulas,
      expectedValue: asset.expected_value,
      spec: {
        columns: asset.columns,
        rows: asset.rows,
        target_cell: asset.target_cell,
      },
    });

    if (check.isCorrect) {
      setSolved(true);
      setComputedValue(check.evaluated.value ?? asset.expected_value);
      setFeedback(null);
      setSubmitting(true);
      try {
        await onComplete({
          questionId: question.id,
          submittedFormula: formula.trim(),
          isCorrect: true,
        });
      } finally {
        setSubmitting(false);
      }
      return;
    }

    if (!check.evaluated.ok) {
      setComputedValue(null);
      setFeedback({
        kind: "error",
        hi:
          check.evaluated.errorHi ??
          "फॉर्मूला सही प्रारूप में नहीं है। नीचे दिए गए चिप्स का उपयोग करें।",
        en:
          check.evaluated.errorEn ??
          "Formula syntax needs a small fix. Try tapping the formula chips below.",
      });
      return;
    }

    // Valid formula, but produced a different number than the target mission
    setComputedValue(check.evaluated.value ?? null);
    setFeedback({
      kind: "error",
      hi: `आपके फॉर्मूला का परिणाम "${check.evaluated.value}" आया, जबकि लक्ष्य मान "${asset.expected_value}" होना चाहिए। नीले रंग से हाइलाइट किए गए सेल और फ़ंक्शन नाम जाँचें!`,
      en: `Your formula calculated "${check.evaluated.value}", while the target answer is "${asset.expected_value}". Check the highlighted range and function name!`,
    });
  };

  const handleShowHint = () => {
    if (solved) return;
    const sample = asset.accepted_formulas[0] ?? "=SUM(...)";
    const prefix = sample.split("(")[0] ?? "=";
    setFeedback({
      kind: "hint",
      hi: `संकेत: फॉर्मूला "${prefix}(" से शुरू होगा और नीले रंग के सेल (${asset.highlight_range.join(", ")}) को उपयोग करेगा।`,
      en: `Hint: Start your formula with "${prefix}(" using the highlighted cells (${asset.highlight_range.join(", ")}).`,
    });
  };

  const colCount = Math.max(
    asset.columns.length,
    ...asset.rows.map((r) => r.length),
    1
  );

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
          <Badge variant={solved ? "emerald" : "indigo"} icon={<Table2 className="h-3.5 w-3.5" />}>
            {t(`एक्सेल सैंडबॉक्स #${index + 1}`, `Excel Sandbox #${index + 1}`)}
          </Badge>
          <Badge variant="amber">
            {t(`लक्ष्य सेल: ${targetCellUpper}`, `Target Cell: ${targetCellUpper}`)}
          </Badge>
          {solved && (
            <Badge variant="emerald" icon={<CheckCircle2 className="h-3.5 w-3.5" />}>
              {t("सही उत्तर", "Solved")}
            </Badge>
          )}
        </div>

        {!solved && (
          <Button
            size="sm"
            variant="ghost"
            onClick={handleShowHint}
            leftIcon={<Lightbulb className="h-3.5 w-3.5 text-amber-ink" />}
          >
            {t("संकेत", "Hint")}
          </Button>
        )}
      </div>

      {/* Task Box */}
      <div className="rounded-paper border border-amber-warm/30 bg-surface-warm px-4 py-3 space-y-1">
        <div className="text-xs font-bold uppercase tracking-wider text-amber-ink">
          {t("स्प्रेडशीट कार्य", "Spreadsheet Mission")}
        </div>
        <div className="text-base font-bold text-ink leading-snug">
          <BiText hi={asset.task_hi} en={asset.task_en} />
        </div>
      </div>

      {/* Formula Bar */}
      <form onSubmit={handleEvaluate} className="space-y-2.5">
        <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-2">
          <div className="flex items-center flex-1 rounded-lg border border-hairline-strong bg-surface overflow-hidden focus-within:ring-2 focus-within:ring-indigo-academic/30 focus-within:border-indigo-academic">
            <span className="px-3 py-2.5 bg-surface-subtle border-r border-hairline text-xs font-bold text-indigo-ink font-mono shrink-0">
              {targetCellUpper}
            </span>
            <span className="px-2.5 py-2.5 text-xs font-bold italic text-ink-muted font-serif border-r border-hairline shrink-0">
              fx
            </span>
            <input
              type="text"
              value={formula}
              disabled={solved}
              onChange={(e) => {
                setFormula(e.target.value);
                setFeedback(null);
              }}
              placeholder={t("जैसे: =SUM(B2:D2) टाइप या टैप करें...", "Type or tap chips e.g. =SUM(B2:D2)")}
              aria-label={t("एक्सेल फॉर्मूला बार", "Excel formula bar")}
              className="flex-1 bg-transparent px-3 py-2.5 text-sm font-mono font-semibold text-ink outline-none min-h-[44px]"
            />
            {!solved && formula.length > 0 && (
              <button
                type="button"
                aria-label={t("एक अक्षर मिटाएँ", "Backspace")}
                onClick={() => setFormula((prev) => prev.slice(0, -1))}
                className="px-2.5 py-2 text-ink-muted hover:text-ink"
              >
                <Delete className="h-4 w-4" />
              </button>
            )}
          </div>

          {!solved && (
            <div className="flex items-center gap-2 shrink-0">
              <Button
                type="submit"
                variant="primary"
                disabled={!formula.trim() || submitting}
                loading={submitting}
                leftIcon={<Play className="h-4 w-4" />}
              >
                {t("चलाएँ", "Evaluate")}
              </Button>
              {formula.length > 0 && (
                <Button
                  type="button"
                  size="sm"
                  variant="ghost"
                  onClick={() => {
                    setFormula("");
                    setComputedValue(null);
                    setFeedback(null);
                  }}
                  leftIcon={<RotateCcw className="h-3.5 w-3.5" />}
                >
                  {t("साफ़", "Clear")}
                </Button>
              )}
            </div>
          )}
        </div>

        {/* Tactile Formula Chips for Budget Android Touchscreens */}
        {!solved && asset.formula_chips.length > 0 && (
          <div className="space-y-1.5">
            <div className="text-xs font-semibold text-ink-muted">
              {t("आसान फॉर्मूला चिप्स (टैप करके जोड़ें):", "Quick Formula Chips (tap to insert):")}
            </div>
            <div className="flex flex-wrap gap-2">
              {asset.formula_chips.map((chip, cIdx) => (
                <button
                  key={`${chip}-${cIdx}`}
                  type="button"
                  onClick={() => handleChipTap(chip)}
                  className="min-h-[40px] rounded-lg border border-indigo-academic/30 bg-indigo-soft px-3 py-1.5 text-xs sm:text-sm font-mono font-bold text-indigo-ink hover:border-indigo-academic active:scale-95 transition-all"
                >
                  {chip}
                </button>
              ))}
            </div>
          </div>
        )}
      </form>

      {/* Interactive Spreadsheet Grid */}
      <div className="w-full overflow-x-auto rounded-paper border border-hairline-strong bg-surface">
        <table className="w-full border-collapse text-xs sm:text-sm">
          <thead>
            <tr className="bg-surface-subtle">
              <th className="w-10 border border-hairline px-2 py-2 text-center font-mono text-xs font-bold text-ink-muted">
                #
              </th>
              {Array.from({ length: colCount }).map((_, cIdx) => (
                <th
                  key={cIdx}
                  className="border border-hairline px-3 py-2 text-center font-mono text-xs font-bold text-ink-secondary"
                >
                  {colIndexToLetter(cIdx)}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {/* Semantic Header Row (Row 1) when columns are header names */}
            {dataStartRow === 2 && (
              <tr className="bg-canvas font-semibold">
                <td className="border border-hairline bg-surface-subtle px-2 py-2 text-center font-mono text-xs font-bold text-ink-muted">
                  1
                </td>
                {Array.from({ length: colCount }).map((_, cIdx) => (
                  <td
                    key={cIdx}
                    className="border border-hairline px-3 py-2 text-ink font-bold whitespace-nowrap"
                  >
                    {asset.columns[cIdx] ?? ""}
                  </td>
                ))}
              </tr>
            )}

            {/* Data Rows */}
            {asset.rows.map((row, rIdx) => {
              const excelRowNum = rIdx + dataStartRow;
              return (
                <tr key={excelRowNum}>
                  <td className="border border-hairline bg-surface-subtle px-2 py-2.5 text-center font-mono text-xs font-bold text-ink-muted">
                    {excelRowNum}
                  </td>
                  {Array.from({ length: colCount }).map((_, cIdx) => {
                    const cellKey = `${colIndexToLetter(cIdx)}${excelRowNum}`;
                    const isTarget = cellKey === targetCellUpper;
                    const isHighlighted = highlightSet.has(cellKey);
                    const cellVal = row[cIdx];

                    return (
                      <td
                        key={cellKey}
                        className={cn(
                          "border px-3 py-2.5 whitespace-nowrap transition-all duration-300",
                          isTarget && solved
                            ? "border-2 border-emerald-mastery bg-emerald-soft text-emerald-ink font-extrabold text-center"
                            : isTarget
                            ? "border-2 border-amber-warm bg-amber-soft text-amber-ink font-bold text-center"
                            : isHighlighted
                            ? "border-indigo-academic/50 bg-indigo-soft text-indigo-ink font-semibold text-center"
                            : "border-hairline text-ink"
                        )}
                      >
                        {isTarget ? (
                          <span className="inline-flex items-center justify-center gap-1 font-mono">
                            {solved ? (
                              <>
                                <CheckCircle2 className="h-3.5 w-3.5 shrink-0" />
                                {computedValue ?? asset.expected_value}
                              </>
                            ) : computedValue !== null ? (
                              computedValue
                            ) : (
                              cellVal !== undefined && String(cellVal).trim() !== ""
                                ? String(cellVal)
                                : "?"
                            )}
                          </span>
                        ) : (
                          <span>{cellVal ?? ""}</span>
                        )}
                      </td>
                    );
                  })}
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Feedback Banner */}
      {feedback && !solved && (
        <div
          className={cn(
            "rounded-lg border px-3.5 py-2.5 text-xs sm:text-sm flex items-start gap-2",
            feedback.kind === "hint"
              ? "border-indigo-academic/30 bg-indigo-soft text-indigo-ink"
              : "border-amber-warm/35 bg-surface-warm text-amber-ink"
          )}
        >
          <Lightbulb className="h-4 w-4 shrink-0 mt-0.5" />
          <span>{t(feedback.hi, feedback.en)}</span>
        </div>
      )}

      {/* Solved Celebration */}
      {solved && (
        <div className="rounded-paper border border-emerald-mastery/30 bg-emerald-soft p-4 space-y-1.5">
          <div className="flex items-center gap-2 font-bold text-sm text-emerald-ink">
            <CheckCircle2 className="h-4 w-4 shrink-0" />
            <span>
              {t(
                `शानदार! सेल ${targetCellUpper} में सही उत्तर ${computedValue ?? asset.expected_value} आ गया! (+10 अंक)`,
                `Awesome! Cell ${targetCellUpper} evaluated accurately to ${computedValue ?? asset.expected_value}! (+10 pts)`
              )}
            </span>
          </div>
          {(question.explanation_hi || question.explanation_en) && (
            <p className="text-xs sm:text-sm text-ink leading-relaxed">
              {lang === "EN"
                ? question.explanation_en ?? question.explanation_hi
                : lang === "HI"
                ? question.explanation_hi ?? question.explanation_en
                : (
                  <BiText
                    hi={question.explanation_hi ?? ""}
                    en={question.explanation_en ?? ""}
                  />
                )}
            </p>
          )}
        </div>
      )}
    </Card>
  );
}
