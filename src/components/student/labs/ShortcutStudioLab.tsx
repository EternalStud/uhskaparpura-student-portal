"use client";

import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  AlignCenter,
  Bold,
  CheckCircle2,
  ClipboardCopy,
  ClipboardPaste,
  FilePlus,
  FileText,
  Italic,
  Keyboard,
  Lightbulb,
  Monitor,
  Printer,
  RotateCcw,
  Save,
  Search,
  Table2,
  Underline,
  Undo2,
} from "lucide-react";
import type { QuestionRow, ShortcutStudioAsset } from "@/types/database";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Button, Card } from "@/components/ui";
import { cn } from "@/components/ui/cn";

const MODIFIER_KEYS = new Set(["ctrl", "alt", "shift", "win"]);

function normalizeKeyLabel(raw: string): string {
  const clean = raw.trim().toLowerCase();
  if (clean === "control" || clean === "ctrl" || clean === "meta" || clean === "cmd") {
    return "ctrl";
  }
  if (clean === "alt" || clean === "option") return "alt";
  if (clean === "shift") return "shift";
  if (clean === "win" || clean === "windows") return "win";
  if (clean === "escape" || clean === "esc") return "esc";
  if (clean === "delete" || clean === "del") return "del";
  if (clean === "enter" || clean === "return") return "enter";
  if (clean === " " || clean === "space" || clean === "spacebar") return "space";
  if (clean === "tab") return "tab";
  if (clean === "backspace") return "backspace";
  return clean;
}

function prettyKeyLabel(norm: string): string {
  if (norm === "ctrl") return "Ctrl";
  if (norm === "alt") return "Alt";
  if (norm === "shift") return "Shift";
  if (norm === "win") return "Win";
  if (norm === "esc") return "Esc";
  if (norm === "del") return "Del";
  if (norm === "enter") return "Enter";
  if (norm === "space") return "Space";
  if (norm === "tab") return "Tab";
  return norm.toUpperCase();
}

export interface ShortcutStudioLabProps {
  question: QuestionRow;
  asset: ShortcutStudioAsset;
  index: number;
  initiallyMastered?: boolean;
  onComplete: (result: {
    questionId: string;
    submittedKeys: string[];
    isCorrect: boolean;
  }) => Promise<void> | void;
}

export function ShortcutStudioLab({
  question,
  asset,
  index,
  initiallyMastered = false,
  onComplete,
}: ShortcutStudioLabProps) {
  const { lang, t } = useLanguage();

  const expectedNormSet = useMemo(
    () => new Set(asset.expected_keys.map(normalizeKeyLabel)),
    [asset.expected_keys]
  );

  // Merge available_keys with expected_keys defensively so expected keys are always tappable
  const touchKeys = useMemo(() => {
    const seen = new Set<string>();
    const list: string[] = [];
    for (const k of [...asset.available_keys, ...asset.expected_keys]) {
      const norm = normalizeKeyLabel(k);
      if (!seen.has(norm)) {
        seen.add(norm);
        list.push(k);
      }
    }
    return list;
  }, [asset.available_keys, asset.expected_keys]);

  const [latchedKeys, setLatchedKeys] = useState<string[]>([]);
  const [lastAttemptKeys, setLastAttemptKeys] = useState<string[]>([]);
  const [keyboardCapture, setKeyboardCapture] = useState(false);
  const [solved, setSolved] = useState(initiallyMastered);
  const [wrongMsg, setWrongMsg] = useState<{ hi: string; en: string } | null>(null);
  const [showHint, setShowHint] = useState(false);

  const evaluateCombo = useCallback(
    async (keys: string[]) => {
      if (solved || keys.length === 0) return;
      const submittedNorm = Array.from(new Set(keys.map(normalizeKeyLabel)));
      setLastAttemptKeys(submittedNorm);

      const isMatch =
        submittedNorm.length === expectedNormSet.size &&
        submittedNorm.every((k) => expectedNormSet.has(k));

      if (isMatch) {
        setSolved(true);
        setWrongMsg(null);
        setKeyboardCapture(false);
        setLatchedKeys([]);
        await onComplete({
          questionId: question.id,
          submittedKeys: submittedNorm.map(prettyKeyLabel),
          isCorrect: true,
        });
      } else {
        setWrongMsg({
          hi: `आपने ${submittedNorm.map(prettyKeyLabel).join(" + ")} दबाया — यह कार्य के लिए सही शॉर्टकट नहीं है। दुबारा प्रयास करें!`,
          en: `You pressed ${submittedNorm.map(prettyKeyLabel).join(" + ")} — that isn't the right shortcut for this task. Try again!`,
        });
        setLatchedKeys([]);
      }
    },
    [expectedNormSet, onComplete, question.id, solved]
  );

  // Real physical keyboard listener for Bihar School ICT Lab PCs!
  useEffect(() => {
    if (!keyboardCapture || solved) return;

    const handleKeyDown = (e: KeyboardEvent) => {
      const keyNorm = normalizeKeyLabel(e.key);
      // Ignore bare modifier presses until an action key is pressed (unless expected is single key)
      if (MODIFIER_KEYS.has(keyNorm) && expectedNormSet.size > 1) {
        return;
      }

      e.preventDefault();
      e.stopPropagation();

      const combo: string[] = [];
      if (
        e.metaKey &&
        !e.ctrlKey &&
        expectedNormSet.has("win") &&
        !expectedNormSet.has("ctrl")
      ) {
        combo.push("win");
      } else if (e.ctrlKey || e.metaKey) {
        combo.push("ctrl");
      }
      if (e.altKey) combo.push("alt");
      if (e.shiftKey) combo.push("shift");
      if (!MODIFIER_KEYS.has(keyNorm)) {
        combo.push(keyNorm);
      }

      if (combo.length > 0) {
        void evaluateCombo(combo);
      }
    };

    window.addEventListener("keydown", handleKeyDown, { capture: true });
    return () => {
      window.removeEventListener("keydown", handleKeyDown, { capture: true });
    };
  }, [evaluateCombo, expectedNormSet, keyboardCapture, solved]);

  const handleTouchKeyPress = (rawKey: string) => {
    if (solved) return;
    const norm = normalizeKeyLabel(rawKey);
    setWrongMsg(null);

    // Modifier keys latch ON/OFF; pressing a non-modifier key fires the combo immediately!
    if (MODIFIER_KEYS.has(norm) && expectedNormSet.size > 1) {
      setLatchedKeys((prev) =>
        prev.includes(norm) ? prev.filter((k) => k !== norm) : [...prev, norm]
      );
      return;
    }

    const combo = Array.from(new Set([...latchedKeys, norm]));
    void evaluateCombo(combo);
  };

  const effect = asset.preview_effect.toUpperCase();
  const appMeta =
    asset.app_context === "MS_WORD"
      ? {
          titleHi: "MS Word — अभ्यास दस्तावेज़",
          titleEn: "MS Word — Practice Document",
          icon: <FileText className="h-4 w-4 text-indigo-ink" />,
        }
      : asset.app_context === "MS_EXCEL"
      ? {
          titleHi: "MS Excel — स्प्रेडशीट शीट",
          titleEn: "MS Excel — Worksheet",
          icon: <Table2 className="h-4 w-4 text-emerald-ink" />,
        }
      : {
          titleHi: "Windows — फ़ाइल एवं डेस्कटॉप",
          titleEn: "Windows — Desktop & Files",
          icon: <Monitor className="h-4 w-4 text-indigo-ink" />,
        };

  return (
    <Card
      padding="lg"
      className={cn(
        "space-y-4 transition-colors",
        solved && "border-emerald-mastery/40"
      )}
    >
      {/* Top Bar */}
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant={solved ? "emerald" : "indigo"} icon={<Keyboard className="h-3.5 w-3.5" />}>
            {t(`शॉर्टकट स्टूडियो #${index + 1}`, `Shortcut Studio #${index + 1}`)}
          </Badge>
          <Badge variant="neutral">{asset.app_context.replace("_", " ")}</Badge>
          {solved && (
            <Badge variant="emerald" icon={<CheckCircle2 className="h-3.5 w-3.5" />}>
              {t("सफल", "Mastered")}
            </Badge>
          )}
        </div>

        <div className="flex items-center gap-1.5">
          {!solved && (
            <Button
              size="sm"
              variant={keyboardCapture ? "primary" : "secondary"}
              onClick={() => setKeyboardCapture((v) => !v)}
              leftIcon={<Keyboard className="h-3.5 w-3.5" />}
            >
              {keyboardCapture
                ? t("कीबोर्ड चालू (अब दबाएँ)", "PC Keyboard Listening...")
                : t("PC कीबोर्ड से दबाएँ", "Use PC Keyboard")}
            </Button>
          )}
          {!solved && (
            <Button
              size="sm"
              variant="ghost"
              onClick={() => setShowHint((v) => !v)}
              leftIcon={<Lightbulb className="h-3.5 w-3.5 text-amber-ink" />}
            >
              {t("संकेत", "Hint")}
            </Button>
          )}
        </div>
      </div>

      {/* Mission Prompt */}
      <div className="rounded-paper border border-amber-warm/30 bg-surface-warm px-4 py-3 space-y-1">
        <div className="text-xs font-bold uppercase tracking-wider text-amber-ink">
          {t("लैब कार्य (Task)", "Practical Task")}
        </div>
        <div className="text-base font-bold text-ink leading-snug">
          <BiText hi={asset.task_hi} en={asset.task_en} />
        </div>
      </div>

      {/* Live Interactive Mini Application Window */}
      <div className="rounded-paper border border-hairline-strong bg-surface overflow-hidden shadow-paper">
        {/* Window Title Bar */}
        <div className="flex items-center justify-between gap-2 bg-surface-subtle border-b border-hairline px-3.5 py-2 text-xs font-semibold text-ink-secondary">
          <div className="flex items-center gap-2">
            {appMeta.icon}
            <span>{t(appMeta.titleHi, appMeta.titleEn)}</span>
          </div>
          <div className="flex items-center gap-1.5">
            {solved && effect === "SAVE" && (
              <Badge variant="emerald" icon={<Save className="h-3 w-3" />}>
                {t("सहेजा गया (Saved)", "Saved")}
              </Badge>
            )}
            {solved && effect === "COPY" && (
              <Badge variant="indigo" icon={<ClipboardCopy className="h-3 w-3" />}>
                {t("क्लिपबोर्ड में कॉपी हुआ", "Copied to Clipboard")}
              </Badge>
            )}
            {solved && effect === "PRINT" && (
              <Badge variant="indigo" icon={<Printer className="h-3 w-3" />}>
                {t("प्रिंट प्रीव्यू खुला", "Print Preview Open")}
              </Badge>
            )}
            {solved && effect === "NEW_DOC" && (
              <Badge variant="emerald" icon={<FilePlus className="h-3 w-3" />}>
                Document2.docx
              </Badge>
            )}
          </div>
        </div>

        {/* Miniature Ribbon Indicators (for MS Word / MS Excel) */}
        {asset.app_context !== "WINDOWS" && (
          <div className="flex flex-wrap items-center gap-1.5 px-3.5 py-1.5 bg-canvas border-b border-hairline text-ink-muted">
            {[
              { key: "BOLD", icon: <Bold className="h-3.5 w-3.5" />, label: "Bold" },
              { key: "ITALIC", icon: <Italic className="h-3.5 w-3.5" />, label: "Italic" },
              { key: "UNDERLINE", icon: <Underline className="h-3.5 w-3.5" />, label: "Underline" },
              { key: "ALIGN_CENTER", icon: <AlignCenter className="h-3.5 w-3.5" />, label: "Center" },
              { key: "COPY", icon: <ClipboardCopy className="h-3.5 w-3.5" />, label: "Copy" },
              { key: "PASTE", icon: <ClipboardPaste className="h-3.5 w-3.5" />, label: "Paste" },
              { key: "UNDO", icon: <Undo2 className="h-3.5 w-3.5" />, label: "Undo" },
              { key: "FIND", icon: <Search className="h-3.5 w-3.5" />, label: "Find" },
              { key: "SAVE", icon: <Save className="h-3.5 w-3.5" />, label: "Save" },
            ].map((btn) => {
              const active = solved && effect === btn.key;
              return (
                <span
                  key={btn.key}
                  aria-label={btn.label}
                  className={cn(
                    "inline-flex h-7 w-7 items-center justify-center rounded border text-xs transition-all",
                    active
                      ? "bg-indigo-academic text-white border-indigo-academic shadow-paper scale-105"
                      : "bg-surface border-hairline text-ink-secondary"
                  )}
                >
                  {btn.icon}
                </span>
              );
            })}
          </div>
        )}

        {/* Live Document Surface */}
        <div className="p-4 sm:p-5 bg-surface min-h-[96px] space-y-2.5">
          {solved && effect === "FIND" && (
            <div className="flex items-center gap-2 rounded-md border border-indigo-academic/35 bg-indigo-soft px-3 py-1.5 text-xs font-semibold text-indigo-ink">
              <Search className="h-3.5 w-3.5" />
              <span>{t("Find बॉक्स सक्रिय — शब्द खोजा गया!", "Find bar open — word highlighted!")}</span>
            </div>
          )}

          {solved && effect === "NEW_DOC" ? (
            <div className="rounded-md border border-dashed border-emerald-mastery/40 bg-emerald-soft p-3 text-sm text-emerald-ink font-medium">
              {t("नया खाली दस्तावेज़ (Document2.docx) खुल गया है।", "Fresh blank document (Document2.docx) opened!")}
            </div>
          ) : (
            <div
              className={cn(
                "rounded-md border px-3.5 py-3 text-sm sm:text-base text-ink transition-all duration-300",
                solved && effect === "SELECT_ALL"
                  ? "bg-indigo-soft border-indigo-academic text-indigo-ink"
                  : solved && effect === "PRINT"
                  ? "border-indigo-academic/40 shadow-paper-hover max-w-md mx-auto bg-canvas"
                  : "border-hairline bg-canvas/50",
                solved && effect === "BOLD" && "font-extrabold tracking-tight",
                solved && effect === "ITALIC" && "italic",
                solved && effect === "UNDERLINE" && "underline decoration-2 underline-offset-4 decoration-indigo-academic",
                solved && effect === "ALIGN_CENTER" && "text-center font-semibold"
              )}
            >
              {solved && effect === "UNDO" ? (
                <div className="flex items-center gap-2 text-emerald-ink font-semibold">
                  <Undo2 className="h-4 w-4 shrink-0" />
                  <span>
                    {t(
                      `अंतिम गलती वापस सुधर गई: ${asset.sample_doc_before}`,
                      `Last change undone cleanly: ${asset.sample_doc_before}`
                    )}
                  </span>
                </div>
              ) : (
                <span>{asset.sample_doc_before}</span>
              )}

              {solved && effect === "PASTE" && (
                <div className="mt-2 pt-2 border-t border-emerald-mastery/30 text-emerald-ink font-semibold">
                  {asset.sample_doc_before}
                </div>
              )}
            </div>
          )}

          {solved && (
            <div className="flex items-center gap-2 text-xs font-bold text-emerald-ink">
              <CheckCircle2 className="h-4 w-4 shrink-0" />
              <span>
                {t(
                  `शॉर्टकट ${asset.expected_keys.join(" + ")} लागू हुआ!`,
                  `Shortcut ${asset.expected_keys.join(" + ")} applied live!`
                )}
              </span>
            </div>
          )}
        </div>
      </div>

      {/* Responsive Touch Keyboard Deck (Mobile + Mouse + Active Combo Indicator) */}
      {!solved && (
        <div className="space-y-3 rounded-paper border border-hairline bg-surface-subtle/60 p-3.5">
          <div className="flex flex-wrap items-center justify-between gap-2 text-xs">
            <span className="font-semibold text-ink-secondary">
              {t(
                "टच कीबोर्ड (पहले Ctrl/Alt/Shift टैप करें, फिर अक्षर दबाएँ) या PC कीबोर्ड इस्तेमाल करें:",
                "Touch Deck (tap Ctrl/Alt/Shift first, then the letter key) or use your PC keyboard:"
              )}
            </span>
            {latchedKeys.length > 0 && (
              <div className="flex items-center gap-1.5">
                <Badge variant="indigo">
                  {latchedKeys.map(prettyKeyLabel).join(" + ")} + ...
                </Badge>
                <button
                  type="button"
                  onClick={() => setLatchedKeys([])}
                  className="text-ink-muted hover:text-ink inline-flex items-center gap-1 font-semibold"
                >
                  <RotateCcw className="h-3 w-3" />
                  {t("रीसेट", "Reset")}
                </button>
              </div>
            )}
          </div>

          <div className="flex flex-wrap gap-2">
            {touchKeys.map((rawKey) => {
              const norm = normalizeKeyLabel(rawKey);
              const isLatched = latchedKeys.includes(norm);
              const isModifier = MODIFIER_KEYS.has(norm);
              return (
                <button
                  key={norm}
                  type="button"
                  onClick={() => handleTouchKeyPress(rawKey)}
                  aria-pressed={isLatched}
                  className={cn(
                    "min-h-[46px] min-w-[54px] rounded-lg border px-3.5 py-2 text-sm font-bold transition-all select-none",
                    isLatched
                      ? "bg-indigo-academic text-white border-indigo-academic border-b-2 translate-y-0.5 shadow-inner"
                      : isModifier
                      ? "bg-surface-warm border-amber-warm/50 border-b-4 text-amber-ink hover:bg-amber-soft active:translate-y-0.5"
                      : "bg-surface border-hairline-strong border-b-4 text-ink hover:border-indigo-academic hover:bg-indigo-soft active:translate-y-0.5"
                  )}
                >
                  {rawKey}
                </button>
              );
            })}
          </div>
        </div>
      )}

      {/* Hint Box */}
      {showHint && !solved && (
        <div className="rounded-lg border border-indigo-academic/30 bg-indigo-soft px-3.5 py-2.5 text-xs sm:text-sm text-indigo-ink flex items-start gap-2">
          <Lightbulb className="h-4 w-4 shrink-0 mt-0.5" />
          <span>
            {question.clue_hi || question.clue_en ? (
              <BiText
                hi={question.clue_hi ?? ""}
                en={question.clue_en ?? ""}
                inline
              />
            ) : (
              t(
                `संकेत: यह शॉर्टकट "${asset.expected_keys[0]}" कुंजी से शुरू होता है (${asset.expected_keys.length} कुंजियाँ)।`,
                `Hint: This shortcut starts with "${asset.expected_keys[0]}" (${asset.expected_keys.length} keys).`
              )
            )}
          </span>
        </div>
      )}

      {/* Gentle Retry Message */}
      {wrongMsg && !solved && (
        <div className="rounded-lg border border-amber-warm/35 bg-surface-warm px-3.5 py-2.5 text-xs sm:text-sm text-amber-ink">
          {t(wrongMsg.hi, wrongMsg.en)}
          {lastAttemptKeys.length > 0 && (
            <span className="ml-1 font-semibold">
              ({lastAttemptKeys.map(prettyKeyLabel).join(" + ")})
            </span>
          )}
        </div>
      )}

      {/* Solved Explanation */}
      {solved && (question.explanation_hi || question.explanation_en) && (
        <div className="rounded-paper border border-emerald-mastery/30 bg-emerald-soft p-4 text-xs sm:text-sm text-ink leading-relaxed">
          <div className="font-bold text-emerald-ink mb-1">
            {t("शाबाश! शॉर्टकट याद हो गया (+10 अंक)", "Well done! Shortcut mastered (+10 pts)")}
          </div>
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
        </div>
      )}
    </Card>
  );
}
