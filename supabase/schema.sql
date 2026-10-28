-- ============================================================================
-- U.H.S. KAPARPURA — GAMIFIED STUDENT PORTAL & LIVE EXAM HOST
-- SUPABASE POSTGRESQL SCHEMA + REALTIME SETUP (RUN IN SUPABASE SQL EDITOR)
-- ============================================================================

-- 1. STUDENTS & GAMIFICATION TABLE
CREATE TABLE IF NOT EXISTS public.portal_students (
  student_id TEXT PRIMARY KEY,
  student_code TEXT,
  student_name TEXT NOT NULL,
  father_name TEXT DEFAULT '',
  mother_name TEXT DEFAULT '',
  dob TEXT DEFAULT '',
  gender TEXT DEFAULT '',
  class_name TEXT NOT NULL,
  stream TEXT DEFAULT 'NA',
  roll_no INTEGER NOT NULL DEFAULT 0,
  academic_year TEXT DEFAULT '2026-27',
  medium TEXT DEFAULT 'Hindi',
  subjects JSONB DEFAULT '[]'::jsonb,
  pin_hash TEXT DEFAULT '',
  total_xp INTEGER NOT NULL DEFAULT 25,
  weekly_xp INTEGER NOT NULL DEFAULT 25,
  ict_xp INTEGER NOT NULL DEFAULT 0,
  streak INTEGER NOT NULL DEFAULT 1,
  last_active_date TEXT DEFAULT '',
  week_start_key TEXT DEFAULT '',
  mastered_map JSONB DEFAULT '{}'::jsonb,
  mistake_bank JSONB DEFAULT '{}'::jsonb,
  badges JSONB DEFAULT '["WELCOME_SCHOLAR"]'::jsonb,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_portal_students_code ON public.portal_students (student_code);
CREATE INDEX IF NOT EXISTS idx_portal_students_lookup ON public.portal_students (class_name, roll_no);
CREATE INDEX IF NOT EXISTS idx_portal_students_total_xp ON public.portal_students (total_xp DESC);
CREATE INDEX IF NOT EXISTS idx_portal_students_ict_xp ON public.portal_students (ict_xp DESC);
CREATE INDEX IF NOT EXISTS idx_portal_students_weekly_xp ON public.portal_students (weekly_xp DESC);

-- 2. TEACHER ON-DEMAND LIVE EXAMS TABLE
CREATE TABLE IF NOT EXISTS public.portal_live_exams (
  pin TEXT PRIMARY KEY,
  exam_id TEXT NOT NULL,
  title TEXT NOT NULL,
  teacher_name TEXT DEFAULT 'ICT Teacher',
  chapter_id TEXT NOT NULL,
  class_name TEXT DEFAULT 'ALL',
  stream TEXT DEFAULT 'ALL',
  duration_mins INTEGER NOT NULL DEFAULT 10,
  question_count INTEGER NOT NULL DEFAULT 10,
  questions JSONB DEFAULT '[]'::jsonb,
  status TEXT NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_portal_live_exams_status ON public.portal_live_exams (status, created_at DESC);

-- 3. LIVE EXAM PARTICIPANTS & ANTI-CHEAT MONITOR TABLE
CREATE TABLE IF NOT EXISTS public.portal_live_participants (
  id TEXT PRIMARY KEY,
  pin TEXT NOT NULL REFERENCES public.portal_live_exams(pin) ON DELETE CASCADE,
  student_id TEXT NOT NULL,
  student_name TEXT NOT NULL,
  roll_no INTEGER DEFAULT 0,
  class_name TEXT DEFAULT '',
  stream TEXT DEFAULT '',
  status TEXT NOT NULL DEFAULT 'JOINED',
  answered_count INTEGER NOT NULL DEFAULT 0,
  total_questions INTEGER NOT NULL DEFAULT 10,
  score INTEGER NOT NULL DEFAULT 0,
  accuracy INTEGER NOT NULL DEFAULT 0,
  tab_switches INTEGER NOT NULL DEFAULT 0,
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  submitted_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_portal_live_participants_pin ON public.portal_live_participants (pin);

-- 4. ROW LEVEL SECURITY (RLS) POLICIES FOR ANON CLIENT
ALTER TABLE public.portal_students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.portal_live_exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.portal_live_participants ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read/write on portal_students" ON public.portal_students;
CREATE POLICY "Allow public read/write on portal_students"
  ON public.portal_students FOR ALL
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public read/write on portal_live_exams" ON public.portal_live_exams;
CREATE POLICY "Allow public read/write on portal_live_exams"
  ON public.portal_live_exams FOR ALL
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public read/write on portal_live_participants" ON public.portal_live_participants;
CREATE POLICY "Allow public read/write on portal_live_participants"
  ON public.portal_live_participants FOR ALL
  USING (true)
  WITH CHECK (true);

-- 5. ENABLE SUPABASE REALTIME ON LIVE EXAM TABLES
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND tablename = 'portal_live_exams'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.portal_live_exams;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND tablename = 'portal_live_participants'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.portal_live_participants;
  END IF;
END $$;

-- 6. SEED VERIFIED SAMPLE STUDENT FROM SCHOOLDB FOR IMMEDIATE TESTING
INSERT INTO public.portal_students (
  student_id, student_code, student_name, father_name, dob, gender,
  class_name, stream, roll_no, academic_year, medium, subjects,
  total_xp, weekly_xp, ict_xp, streak, badges
) VALUES (
  '202410141306317',
  '202410141306317',
  'ANKIT KUMAR',
  'MANOJ THAKUR',
  '2011-01-01',
  'Male',
  '11',
  'Arts',
  2,
  '2026-27',
  'Hindi',
  '[
    {"id":"ICT_LAB","code":"ICT","name":"ICT Lab, MS Office & AI","hiName":"कंप्यूटर लैब, एमएस ऑफिस एवं AI","group":"Skill"},
    {"id":"11_ART_L1_HIN","code":"306","name":"Hindi","hiName":"हिन्दी","group":"Language 1"},
    {"id":"11_ART_L2_ENG","code":"305","name":"English","hiName":"अंग्रेज़ी","group":"Language 2"},
    {"id":"11_ART_ELE_HIS","code":"327","name":"History","hiName":"इतिहास","group":"Elective 1"},
    {"id":"11_ART_ELE_POL","code":"322","name":"Political Science","hiName":"राजनीति विज्ञान","group":"Elective 2"},
    {"id":"11_ART_ELE_SOC","code":"329","name":"Sociology","hiName":"समाजशास्त्र","group":"Elective 3"}
  ]'::jsonb,
  25, 25, 0, 1, '["WELCOME_SCHOLAR"]'::jsonb
) ON CONFLICT (student_id) DO NOTHING;
