-- =============================================================================
-- Students of Bihar (9-12) — Sprint 1A Migration:
-- Interactive Learning Labs, Universal Skill/Foundation Tracks & 4-Stage Mastery
-- =============================================================================
-- Fully idempotent: safe to run on both fresh and existing databases.
-- =============================================================================

-- 1. Relax subjects.class_num CHECK to allow 0 = Universal Skill/Foundation track (Classes 9-12)
DO $$
DECLARE
  c RECORD;
BEGIN
  FOR c IN
    SELECT conname
    FROM pg_constraint
    WHERE conrelid = 'public.subjects'::regclass
      AND contype = 'c'
      AND pg_get_constraintdef(oid) ILIKE '%class_num%'
  LOOP
    EXECUTE format('ALTER TABLE public.subjects DROP CONSTRAINT IF EXISTS %I', c.conname);
  END LOOP;
END $$;

ALTER TABLE public.subjects
  ADD CONSTRAINT subjects_class_num_check
  CHECK (class_num IN (0, 9, 10, 11, 12));

-- 2. Add syllabus_alias_of on subjects so overlapping BSEB codes share one canonical syllabus
ALTER TABLE public.subjects
  ADD COLUMN IF NOT EXISTS syllabus_alias_of TEXT REFERENCES public.subjects(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_subjects_alias_of
  ON public.subjects (syllabus_alias_of)
  WHERE syllabus_alias_of IS NOT NULL;

-- 3. Seed 2 canonical universal skill & foundation tracks (accessible to ALL Classes 9-12)
INSERT INTO public.subjects (
  id,
  bseb_code,
  class_num,
  stream,
  category,
  name_en,
  name_hi,
  icon_name,
  accent_color,
  sort_order,
  syllabus_alias_of
) VALUES
  (
    'skill-ict-lab',
    'ICT',
    0,
    'ALL',
    'SKILL',
    'ICT & Digital Skills Lab',
    'कंप्यूटर एवं डिजिटल कौशल लैब (ICT)',
    'Laptop',
    '#1D4ED8',
    1,
    NULL
  ),
  (
    'skill-eng-foundation',
    'ENG-F',
    0,
    'ALL',
    'SKILL',
    'English Foundation & Grammar Lab',
    'अंग्रेज़ी नींव एवं व्याकरण लैब',
    'Sparkles',
    '#4338CA',
    2,
    NULL
  )
ON CONFLICT (id) DO UPDATE SET
  bseb_code         = EXCLUDED.bseb_code,
  class_num         = EXCLUDED.class_num,
  stream            = EXCLUDED.stream,
  category          = EXCLUDED.category,
  name_en           = EXCLUDED.name_en,
  name_hi           = EXCLUDED.name_hi,
  icon_name         = EXCLUDED.icon_name,
  accent_color      = EXCLUDED.accent_color,
  sort_order        = EXCLUDED.sort_order,
  syllabus_alias_of = NULL;

-- 4. Link BSEB syllabus aliases cleanly so students & teachers seamlessly share canonical chapters
UPDATE public.subjects
SET syllabus_alias_of = 'skill-ict-lab'
WHERE id IN (
  'bseb-9-skill-ict',
  'bseb-10-skill-ict',
  'bseb-11-sci-add-cs',
  'bseb-11-arts-add-cs',
  'bseb-11-com-add-cs',
  'bseb-12-sci-add-cs',
  'bseb-12-arts-add-cs',
  'bseb-12-com-add-cs'
)
  AND EXISTS (SELECT 1 FROM public.subjects WHERE id = 'skill-ict-lab');

UPDATE public.subjects
SET syllabus_alias_of = 'bseb-11-lang1-eng'
WHERE id = 'bseb-11-lang2-eng'
  AND EXISTS (SELECT 1 FROM public.subjects WHERE id = 'bseb-11-lang1-eng');

UPDATE public.subjects
SET syllabus_alias_of = 'bseb-12-lang1-eng'
WHERE id = 'bseb-12-lang2-eng'
  AND EXISTS (SELECT 1 FROM public.subjects WHERE id = 'bseb-12-lang1-eng');

-- 5. Expand questions.question_type CHECK to include the 4 tactile Interactive Learning Labs
DO $$
DECLARE
  c RECORD;
BEGIN
  FOR c IN
    SELECT conname
    FROM pg_constraint
    WHERE conrelid = 'public.questions'::regclass
      AND contype = 'c'
      AND pg_get_constraintdef(oid) ILIKE '%question_type%'
  LOOP
    EXECUTE format('ALTER TABLE public.questions DROP CONSTRAINT IF EXISTS %I', c.conname);
  END LOOP;
END $$;

ALTER TABLE public.questions
  ADD CONSTRAINT questions_question_type_check
  CHECK (
    question_type IN (
      'MCQ',
      'SHORT_2M',
      'LONG_5M',
      'MATCH_PAIRS',
      'DIAGRAM_LABEL',
      'FLASHCARD',
      'SENTENCE_BUILDER',
      'SHORTCUT_STUDIO',
      'EXCEL_SANDBOX',
      'SCENARIO_LAB'
    )
  );

-- 6. Expand practice_sessions.mode CHECK so every interactive lab persists authentic practice analytics
DO $$
DECLARE
  c RECORD;
BEGIN
  FOR c IN
    SELECT conname
    FROM pg_constraint
    WHERE conrelid = 'public.practice_sessions'::regclass
      AND contype = 'c'
      AND pg_get_constraintdef(oid) ILIKE '%mode%'
  LOOP
    EXECUTE format('ALTER TABLE public.practice_sessions DROP CONSTRAINT IF EXISTS %I', c.conname);
  END LOOP;
END $$;

ALTER TABLE public.practice_sessions
  ADD CONSTRAINT practice_sessions_mode_check
  CHECK (
    mode IN (
      'FLASHCARD',
      'MATCH_PAIRS',
      'DIAGRAM_LABEL',
      'SENTENCE_BUILDER',
      'SHORTCUT_STUDIO',
      'EXCEL_SANDBOX',
      'SCENARIO_LAB',
      'MCQ_PRACTICE',
      'SUBJECTIVE_SELF_CHECK',
      'REVISION_DRILL',
      'DAILY_CHALLENGE'
    )
  );

-- 7. Add 4-stage mastery completion flags (Understand -> Play Lab -> Guided Quiz -> Board/Viva Mastery)
ALTER TABLE public.student_chapter_progress
  ADD COLUMN IF NOT EXISTS play_completed BOOLEAN NOT NULL DEFAULT false;

ALTER TABLE public.student_chapter_progress
  ADD COLUMN IF NOT EXISTS subjective_completed BOOLEAN NOT NULL DEFAULT false;
