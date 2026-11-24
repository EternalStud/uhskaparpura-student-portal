"use client";

import React, { useMemo, useState } from "react";
import {
  CheckCircle2,
  Lightbulb,
  RotateCcw,
  Sparkles,
  Volume2,
} from "lucide-react";
import type { QuestionRow, SentenceBuilderAsset } from "@/types/database";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Button, Card, ReadAloudButton } from "@/components/ui";
import { cn } from "@/components/ui/cn";

interface WordTile {
  id: string;
  word: string;
  isDistractor: boolean;
}

function normalizeSentenceForCheck(raw: string): string {
  return raw
    .trim()
    .replace(/\s+/g, " ")
    .replace(/\s+([.,!?;:])/g, "$1")
    .replace(/[.!?]+$/g, "")
    .toLowerCase();
}

function deterministicShuffleTiles(tiles: WordTile[], seedStr: string): WordTile[] {
  const arr = [...tiles];
  let hash = 2166136261;
  for (let i = 0; i < seedStr.length; i++) {
    hash ^= seedStr.charCodeAt(i);
    hash = Math.imul(hash, 16777619);
  }
  for (let i = arr.length - 1; i > 0; i--) {
    hash ^= hash << 13;
    hash ^= hash >>> 17;
    hash ^= hash << 5;
    const j = Math.abs(hash) % (i + 1);
    const tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
  // Avoid starting in the exact already-solved order when there are >= 2 tokens
  const originalWords = tiles.filter((t) => !t.isDistractor).map((t) => t.word).join(" ");
  const shuffledWords = arr.filter((t) => !t.isDistractor).map((t) => t.word).join(" ");
  if (arr.length >= 2 && originalWords === shuffledWords) {
    const first = arr.shift()!;
    arr.push(first);
  }
  return arr;
}

function deriveOrderedExpectedWords(
  correctSentence: string,
  tokens: string[]
): string[] {
  const remaining = correctSentence.trim().replace(/[.!?]+$/g, "").trim();
  if (!remaining) return [...tokens];

  // Greedily match available tokens left-to-right against correct_sentence so both
  // pre-scrambled single words AND multi-word tiles align strictly with true sentence order.
  const pool = [...tokens];
  const matched: string[] = [];
  let cursor = remaining;

  while (cursor.length > 0 && pool.length > 0) {
    cursor = cursor.trimStart();
    if (!cursor) break;
    const cursorLower = cursor.toLowerCase();

    // Prefer longest matching token at start of cursor (boundary-aware)
    let bestIdx = -1;
    let bestLen = 0;
    for (let i = 0; i < pool.length; i++) {
      const candidate = pool[i].trim().replace(/[.!?]+$/g, "");
      if (!candidate) continue;
      const candLower = candidate.toLowerCase();
      if (cursorLower.startsWith(candLower)) {
        const nextChar = cursor[candLower.length];
        const atBoundary =
          nextChar === undefined || /[\s.,!?;:]/.test(nextChar);
        if (atBoundary && candLower.length > bestLen) {
          bestIdx = i;
          bestLen = candLower.length;
        }
      }
    }

    if (bestIdx === -1) {
      break;
    }

    matched.push(pool[bestIdx]);
    pool.splice(bestIdx, 1);
    cursor = cursor.slice(bestLen).replace(/^[\s.,!?;:]+/, "");
  }

  if (matched.length === tokens.length && cursor.length === 0) {
    return matched;
  }

  return remaining.split(/\s+/).filter(Boolean);
}

export interface SentenceBuilderLabProps {
  question: QuestionRow;
  asset: SentenceBuilderAsset;
  index: number;
  initiallyMastered?: boolean;
  onComplete: (result: {
    questionId: string;
    submittedSentence: string;
    isCorrect: boolean;
  }) => Promise<void> | void;
}

export function SentenceBuilderLab({
  question,
  asset,
  index,
  initiallyMastered = false,
  onComplete,
}: SentenceBuilderLabProps) {
  const { lang, t } = useLanguage();

  // Assign unique index-based IDs so duplicate words (e.g. two "a" or "the" tiles) work cleanly!
  const allTiles = useMemo<WordTile[]>(() => {
    const base: WordTile[] = asset.tokens.map((word, idx) => ({
      id: `tok-${idx}`,
      word,
      isDistractor: false,
    }));
    const extras: WordTile[] = (asset.distractors ?? []).map((word, idx) => ({
      id: `dist-${idx}`,
      word,
      isDistractor: true,
    }));
    return deterministicShuffleTiles([...base, ...extras], question.id);
  }, [asset.tokens, asset.distractors, question.id]);

  const tileById = useMemo(
    () => new Map(allTiles.map((tile) => [tile.id, tile])),
    [allTiles]
  );

  // Derive true target sequence from correct_sentence so hints work even if asset.tokens is pre-scrambled
  const expectedWords = useMemo(
    () => deriveOrderedExpectedWords(asset.correct_sentence, asset.tokens),
    [asset.correct_sentence, asset.tokens]
  );

  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const [solved, setSolved] = useState<boolean>(initiallyMastered);
  const [feedback, setFeedback] = useState<{
    type: "error" | "hint";
    hi: string;
    en: string;
  } | null>(null);
  const [submitting, setSubmitting] = useState(false);

  const selectedSet = useMemo(() => new Set(selectedIds), [selectedIds]);
  const assembledSentence = selectedIds
    .map((id) => tileById.get(id)?.word ?? "")
    .filter(Boolean)
    .join(" ");

  const handleTapBankTile = (tileId: string) => {
    if (solved || selectedSet.has(tileId)) return;
    setSelectedIds((prev) => [...prev, tileId]);
    setFeedback(null);
  };

  const handleRemoveTrayTile = (tileId: string) => {
    if (solved) return;
    setSelectedIds((prev) => prev.filter((id) => id !== tileId));
    setFeedback(null);
  };

  const handleReset = () => {
    setSelectedIds([]);
    setFeedback(null);
  };

  const handleNextWordHint = () => {
    if (solved) return;
    // Find first mismatch index in selectedIds against true sentence order
    let matchCount = 0;
    while (
      matchCount < selectedIds.length &&
      matchCount < expectedWords.length &&
      normalizeSentenceForCheck(tileById.get(selectedIds[matchCount])?.word ?? "") ===
        normalizeSentenceForCheck(expectedWords[matchCount] ?? "")
    ) {
      matchCount += 1;
    }
    const nextWord = expectedWords[matchCount];
    if (!nextWord) return;
    setFeedback({
      type: "hint",
      hi: `संकेत: स्थान ${matchCount + 1} पर सही शब्द "${nextWord}" होना चाहिए।`,
      en: `Hint: Word #${matchCount + 1} should be "${nextWord}".`,
    });
  };

  const handleCheck = async () => {
    if (selectedIds.length === 0 || solved) return;

    const isMatch =
      normalizeSentenceForCheck(assembledSentence) ===
      normalizeSentenceForCheck(asset.correct_sentence);

    if (isMatch) {
      setSolved(true);
      setFeedback(null);
      setSubmitting(true);
      try {
        await onComplete({
          questionId: question.id,
          submittedSentence: assembledSentence,
          isCorrect: true,
        });
      } finally {
        setSubmitting(false);
      }
      return;
    }

    // Gentle diagnostic hint without shaming the student
    const pickedDistractor = selectedIds.some((id) => tileById.get(id)?.isDistractor);
    if (pickedDistractor) {
      setFeedback({
        type: "error",
        hi: "ध्यान दें: आपने एक अतिरिक्त (गलत) शब्द चुन लिया है। ऊपर दिए गए नियम (Formula) को देखकर दुबारा प्रयास करें!",
        en: "Almost! One word you picked is an extra distractor. Check the formula badge above and try again.",
      });
      return;
    }

    if (selectedIds.length < expectedWords.length) {
      setFeedback({
        type: "error",
        hi: `वाक्य अभी अधूरा है — अभी ${expectedWords.length - selectedIds.length} शब्द और जुड़ेंगे।`,
        en: `Sentence isn't finished yet — add ${expectedWords.length - selectedIds.length} more word(s).`,
      });
      return;
    }

    // Count prefix matches against true sentence order to encourage the student
    let prefixCorrect = 0;
    while (
      prefixCorrect < expectedWords.length &&
      normalizeSentenceForCheck(tileById.get(selectedIds[prefixCorrect])?.word ?? "") ===
        normalizeSentenceForCheck(expectedWords[prefixCorrect] ?? "")
    ) {
      prefixCorrect += 1;
    }

    setFeedback({
      type: "error",
      hi:
        prefixCorrect > 0
          ? `अच्छी कोशिश! पहले ${prefixCorrect} शब्द बिल्कुल सही जगह पर हैं। उसके बाद के शब्दों का क्रम बदलकर देखें।`
          : "शब्दों का क्रम थोड़ा बदला हुआ है। अंग्रेज़ी में पहले कर्ता (Subject), फिर क्रिया (Verb), फिर कर्म (Object) रखें।",
      en:
        prefixCorrect > 0
          ? `Good try! The first ${prefixCorrect} word(s) are in the exact right spot. Reorder the next word(s).`
          : "Word order needs a quick tweak. Remember English follows Subject + Verb + Object.",
    });
  };

  return (
    <Card
      padding="lg"
      className={cn(
        "space-y-4 transition-colors",
        solved && "border-emerald-mastery/40"
      )}
    >
      {/* Header Badges */}
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant={solved ? "emerald" : "indigo"} icon={<Sparkles className="h-3.5 w-3.5" />}>
            {t(`वाक्य निर्माण #${index + 1}`, `Sentence Builder #${index + 1}`)}
          </Badge>
          {asset.grammar_formula && (
            <Badge variant="amber">
              {asset.grammar_formula}
            </Badge>
          )}
          {solved && (
            <Badge variant="emerald" icon={<CheckCircle2 className="h-3.5 w-3.5" />}>
              {t("हल किया गया", "Solved")}
            </Badge>
          )}
        </div>

        <div className="flex items-center gap-1.5">
          {!solved && (
            <Button
              size="sm"
              variant="ghost"
              onClick={handleNextWordHint}
              leftIcon={<Lightbulb className="h-3.5 w-3.5 text-amber-ink" />}
            >
              {t("संकेत", "Hint")}
            </Button>
          )}
          {!solved && selectedIds.length > 0 && (
            <Button
              size="sm"
              variant="ghost"
              onClick={handleReset}
              leftIcon={<RotateCcw className="h-3.5 w-3.5" />}
            >
              {t("साफ़ करें", "Clear")}
            </Button>
          )}
        </div>
      </div>

      {/* Hindi-to-English Prompt Box */}
      <div className="rounded-paper border border-amber-warm/30 bg-surface-warm px-4 py-3.5 space-y-1">
        <div className="text-xs font-bold uppercase tracking-wider text-amber-ink">
          {t("इस वाक्य को अंग्रेज़ी में बनाएँ", "Build this sentence in English")}
        </div>
        <div className="text-base sm:text-lg font-bold text-ink leading-snug">
          {asset.prompt_hi}
        </div>
        {asset.prompt_en && (
          <p className="text-xs sm:text-sm text-ink-secondary">{asset.prompt_en}</p>
        )}
      </div>

      {/* Sentence Construction Tray */}
      <div className="space-y-1.5">
        <div className="text-xs font-semibold text-ink-muted">
          {t(
            "नीचे से शब्दों पर टैप कर सही क्रम में सजाएँ (हटाने के लिए शब्द पर दुबारा टैप करें):",
            "Tap word tiles below in the right order (tap any placed tile to remove it):"
          )}
        </div>
        <div
          className={cn(
            "min-h-[64px] rounded-paper border-2 border-dashed p-3 flex flex-wrap items-center gap-2 transition-colors",
            solved
              ? "border-emerald-mastery bg-emerald-soft"
              : selectedIds.length > 0
              ? "border-indigo-academic/40 bg-canvas"
              : "border-hairline-strong bg-surface-subtle/50"
          )}
        >
          {solved ? (
            <span className="text-base sm:text-lg font-bold text-emerald-ink px-1">
              {asset.correct_sentence}
            </span>
          ) : selectedIds.length === 0 ? (
            <span className="text-sm text-ink-muted italic px-1">
              {t("आपका अंग्रेज़ी वाक्य यहाँ बनेगा...", "Your English sentence will appear here...")}
            </span>
          ) : (
            selectedIds.map((tileId) => {
              const tile = tileById.get(tileId);
              if (!tile) return null;
              return (
                <button
                  key={tileId}
                  type="button"
                  onClick={() => handleRemoveTrayTile(tileId)}
                  className="min-h-[42px] rounded-lg border border-indigo-academic bg-indigo-academic text-white px-3.5 py-2 text-sm font-bold shadow-paper hover:bg-indigo-academic-hover transition-all active:scale-95"
                >
                  {tile.word}
                </button>
              );
            })
          )}
        </div>
      </div>

      {/* Word Tile Bank */}
      {!solved && (
        <div className="flex flex-wrap gap-2 pt-1">
          {allTiles.map((tile) => {
            const isUsed = selectedSet.has(tile.id);
            return (
              <button
                key={tile.id}
                type="button"
                disabled={isUsed}
                onClick={() => handleTapBankTile(tile.id)}
                className={cn(
                  "min-h-[44px] rounded-lg border px-3.5 py-2 text-sm font-semibold transition-all",
                  isUsed
                    ? "border-hairline bg-surface-subtle text-ink-muted opacity-35 cursor-not-allowed"
                    : "border-hairline-strong border-b-2 bg-surface text-ink hover:border-indigo-academic hover:bg-indigo-soft active:translate-y-0.5 shadow-paper"
                )}
              >
                {tile.word}
              </button>
            );
          })}
        </div>
      )}

      {/* Gentle Feedback Banner */}
      {feedback && !solved && (
        <div
          className={cn(
            "rounded-lg border px-3.5 py-2.5 text-xs sm:text-sm flex items-start gap-2",
            feedback.type === "hint"
              ? "border-indigo-academic/30 bg-indigo-soft text-indigo-ink"
              : "border-amber-warm/35 bg-surface-warm text-amber-ink"
          )}
        >
          <Lightbulb className="h-4 w-4 shrink-0 mt-0.5" />
          <span>{t(feedback.hi, feedback.en)}</span>
        </div>
      )}

      {/* Action Footer or Celebration Box */}
      {!solved ? (
        <div className="flex flex-wrap items-center justify-between gap-2 pt-2 border-t border-hairline">
          <span className="text-xs text-ink-muted">
            {selectedIds.length} / {asset.tokens.length} {t("शब्द चुने गए", "words placed")}
          </span>
          <Button
            variant="primary"
            disabled={selectedIds.length === 0 || submitting}
            loading={submitting}
            onClick={handleCheck}
            leftIcon={<CheckCircle2 className="h-4 w-4" />}
          >
            {t("वाक्य जाँचें", "Check Sentence")}
          </Button>
        </div>
      ) : (
        <div className="rounded-paper border border-emerald-mastery/30 bg-emerald-soft p-4 space-y-3">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <div className="flex items-center gap-2 font-bold text-sm text-emerald-ink">
              <CheckCircle2 className="h-4 w-4 shrink-0" />
              <span>
                {t("शाबाश! बिल्कुल सही अंग्रेज़ी वाक्य बना!", "Well done! Perfect English sentence!")}
              </span>
            </div>
            <ReadAloudButton
              text={asset.correct_sentence}
              locale="en-IN"
              rate={0.88}
              size="sm"
              label={t("उच्चारण सुनें", "Listen (en-IN)")}
            />
          </div>

          {asset.pronunciation_hi && (
            <div className="inline-flex items-center gap-1.5 rounded-md bg-surface border border-emerald-mastery/25 px-3 py-1.5 text-xs sm:text-sm font-semibold text-ink">
              <Volume2 className="h-3.5 w-3.5 text-indigo-ink shrink-0" />
              <span className="text-ink-muted">{t("उच्चारण:", "Pronunciation:")}</span>
              <span>{asset.pronunciation_hi}</span>
            </div>
          )}

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
