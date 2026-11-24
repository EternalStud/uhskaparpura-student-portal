// =============================================================================
// Genuine 4-Stage Chapter Progress Engine (Pure, Shared Server & Client Helper)
// Stage 1 (25%): Understand (Visual Notes)
// Stage 2 (25%): Play Lab (Interactive Learning Labs / Flashcards / Match / Diagram)
// Stage 3 (25%): Guided Quiz (Objective Ladder / Practice Accuracy)
// Stage 4 (25%): Board / Viva Mastery (Subjective Self-Check or 80%+ Quiz Mastery)
// =============================================================================

export type ChapterMedal = "GOLD" | "SILVER" | "BRONZE" | "NONE";

export function computeChapterMedal(masteryPct: number): ChapterMedal {
  if (masteryPct >= 85) return "GOLD";
  if (masteryPct >= 60) return "SILVER";
  if (masteryPct >= 30) return "BRONZE";
  return "NONE";
}

export interface FourStageProgressInput {
  notesCompleted: boolean;
  notesProgressPct?: number;
  playCompleted: boolean;
  quizMasteryPct: number;
  subjectiveCompleted: boolean;
  hasSubjective?: boolean;
}

export interface FourStageItem {
  key: "understand" | "play" | "quiz" | "mastery";
  label_hi: string;
  label_en: string;
  short_hi: string;
  short_en: string;
  completed: boolean;
  points: number; // 0..25 contribution toward 100%
  stagePct: number; // 0..100 fill of this stage
}

export interface FourStageProgressResult {
  totalPct: number; // 0..100
  completedStages: number; // 0..4
  stages: FourStageItem[];
  medal: ChapterMedal;
  milestone_hi: string;
  milestone_en: string;
}

export function computeFourStageProgress(
  input: FourStageProgressInput
): FourStageProgressResult {
  const clampedNotesPct = input.notesCompleted
    ? 100
    : Math.max(0, Math.min(90, Math.round(input.notesProgressPct ?? 0)));
  const understandPoints = input.notesCompleted
    ? 25
    : Math.round(clampedNotesPct * 0.25);

  const playStagePct = input.playCompleted ? 100 : 0;
  const playPoints = input.playCompleted ? 25 : 0;

  const clampedQuizPct = Math.max(
    0,
    Math.min(100, Math.round(input.quizMasteryPct || 0))
  );
  const quizPoints = Math.round(clampedQuizPct * 0.25);
  const quizCompleted = clampedQuizPct >= 60;

  const hasSubjective = input.hasSubjective ?? true;
  const masteryCompleted = hasSubjective
    ? Boolean(input.subjectiveCompleted)
    : Boolean(input.subjectiveCompleted) ||
      (input.playCompleted && clampedQuizPct >= 80);
  const masteryStagePct = masteryCompleted ? 100 : 0;
  const masteryPoints = masteryCompleted ? 25 : 0;

  const stages: FourStageItem[] = [
    {
      key: "understand",
      label_hi: "1. विज़ुअल समझ",
      label_en: "1. Understand",
      short_hi: "समझें",
      short_en: "Understand",
      completed: Boolean(input.notesCompleted),
      points: understandPoints,
      stagePct: clampedNotesPct,
    },
    {
      key: "play",
      label_hi: "2. खेल-खेल लैब",
      label_en: "2. Play Lab",
      short_hi: "खेल लैब",
      short_en: "Play Lab",
      completed: Boolean(input.playCompleted),
      points: playPoints,
      stagePct: playStagePct,
    },
    {
      key: "quiz",
      label_hi: "3. गाइडेड क्विज़",
      label_en: "3. Guided Quiz",
      short_hi: "क्विज़",
      short_en: "Quiz",
      completed: quizCompleted,
      points: quizPoints,
      stagePct: clampedQuizPct,
    },
    {
      key: "mastery",
      label_hi: "4. बोर्ड / वाइवा दक्षता",
      label_en: "4. Board Mastery",
      short_hi: "दक्षता",
      short_en: "Mastery",
      completed: masteryCompleted,
      points: masteryPoints,
      stagePct: masteryStagePct,
    },
  ];

  const totalPct = Math.min(
    100,
    understandPoints + playPoints + quizPoints + masteryPoints
  );
  const completedStages = stages.filter((s) => s.completed).length;
  const medal = computeChapterMedal(totalPct);

  let milestone_hi = "शुरू करने के लिए तैयार";
  let milestone_en = "Ready to begin";

  if (totalPct >= 85 || completedStages === 4) {
    milestone_hi = "अध्याय पूर्णतः तैयार (स्वर्ण दक्षता)";
    milestone_en = "Chapter mastered (Gold Ready)";
  } else if (completedStages >= 3 || totalPct >= 60) {
    milestone_hi = "बोर्ड परीक्षा स्तर पर मज़बूत पकड़";
    milestone_en = "Strong board-exam readiness";
  } else if (completedStages >= 2 || totalPct >= 40) {
    milestone_hi = "अच्छी समझ बन रही है";
    milestone_en = "Building solid confidence";
  } else if (completedStages >= 1 || totalPct > 0) {
    milestone_hi = "अच्छी शुरुआत हो चुकी है";
    milestone_en = "Off to a great start";
  }

  return {
    totalPct,
    completedStages,
    stages,
    medal,
    milestone_hi,
    milestone_en,
  };
}
