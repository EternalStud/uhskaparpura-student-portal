-- =============================================================================
-- Students of Bihar (9-12) — ALL-IN-ONE IDEMPOTENT SUPABASE MIGRATION SCRIPT
-- Target Project: lvrsanukztinwqrgivth (https://lvrsanukztinwqrgivth.supabase.co)
-- =============================================================================
-- Paste this ENTIRE file into Supabase -> SQL Editor -> New Query -> Run.
-- 100% Idempotent: Safe to run once or re-run safely at any time.
--
-- Includes:
--   PART 1: 001_v2_multitenant_schema.sql  (29 tables, RLS, triggers, RPCs, Realtime)
--   PART 2: 002_bseb_seed_catalog.sql      (102 BSEB Class 9-12 subjects + 77 chapters)
--   PART 3: 003_gold_curriculum_seed.sql   (6 gold visual chapters, lesson plans, 46 questions)
--   PART 4: Read-only verification summary query
-- =============================================================================


-- #############################################################################
-- PART 1 / 3: 001_v2_multitenant_schema.sql
-- #############################################################################

-- =============================================================================
-- Students of Bihar (9-12) — Clean-Slate Multi-Tenant PostgreSQL v2.4 Schema
-- Target: Supabase PostgreSQL 15+ (Project: lvrsanukztinwqrgivth)
--
-- Security & Architecture Invariants:
--   1. Multi-tenant strict isolation by school_udise (11-digit Bihar UDISE code).
--   2. Zero Aadhaar numbers, zero Social Category/Caste columns anywhere.
--   3. Zero private messaging / DM tables anywhere (open class+subject doubts only).
--   4. Default-DENY RLS on ALL tables (zero public anon reads/writes).
--   5. Server uses service_role; ONLY live_exam_roster permits scoped Realtime
--      SELECT via short-lived JWT containing BOTH exam_id AND school_udise.
--   6. Single-active-school teacher posting invariant via partial unique index.
--   7. Active school-scoped Live Exam Room PIN uniqueness via partial unique index.
--   8. pg_trgm GIN indexes on questions(q_en, q_hi) for duplicate detection.
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- -----------------------------------------------------------------------------
-- Shared trigger helper: maintain updated_at automatically
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- =============================================================================
-- 1. CORE IDENTITY, MULTI-TENANCY & AUTHENTICATION
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.super_admins (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email               TEXT UNIQUE NOT NULL CHECK (email = lower(btrim(email)) AND position('@' IN email) > 1),
  full_name           TEXT NOT NULL CHECK (char_length(btrim(full_name)) >= 2),
  password_hash       TEXT NOT NULL,
  totp_secret         TEXT,
  totp_enabled        BOOLEAN NOT NULL DEFAULT false,
  recovery_codes_hash JSONB NOT NULL DEFAULT '[]'::jsonb,
  is_active           BOOLEAN NOT NULL DEFAULT true,
  token_version       INT NOT NULL DEFAULT 1 CHECK (token_version > 0),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.schools (
  udise_code      TEXT PRIMARY KEY CHECK (udise_code ~ '^[0-9]{11}$'),
  school_name     TEXT NOT NULL CHECK (char_length(btrim(school_name)) >= 2),
  school_name_hi  TEXT,
  district_code   TEXT,
  district_name   TEXT NOT NULL CHECK (char_length(btrim(district_name)) >= 2),
  block_code      TEXT,
  block_name      TEXT,
  cluster_code    TEXT,
  cluster_name    TEXT,
  board           TEXT NOT NULL DEFAULT 'BSEB',
  status          TEXT NOT NULL DEFAULT 'ONBOARDING'
                    CHECK (status IN ('ONBOARDING', 'ACTIVE', 'SUSPENDED')),
  drive_folder_id TEXT,
  onboarded_by    UUID REFERENCES public.super_admins(id) ON DELETE SET NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_schools_status_district
  ON public.schools (status, district_name, school_name);

CREATE TABLE IF NOT EXISTS public.teachers (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  teacher_code          TEXT UNIQUE NOT NULL
                          CHECK (char_length(btrim(teacher_code)) >= 4 AND teacher_code = btrim(teacher_code)),
  full_name             TEXT NOT NULL CHECK (char_length(btrim(full_name)) >= 2),
  teacher_title         TEXT,
  mobile_hash           TEXT,
  mobile_last4          TEXT CHECK (mobile_last4 IS NULL OR mobile_last4 ~ '^[0-9]{4}$'),
  password_hash         TEXT NOT NULL,
  must_change_password  BOOLEAN NOT NULL DEFAULT true,
  activation_code_hash  TEXT,
  reset_code_hash       TEXT,
  reset_code_expires_at TIMESTAMPTZ,
  token_version         INT NOT NULL DEFAULT 1 CHECK (token_version > 0),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_teachers_mobile_hash
  ON public.teachers (mobile_hash)
  WHERE mobile_hash IS NOT NULL;

CREATE TABLE IF NOT EXISTS public.school_teachers (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_udise         TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  teacher_id           UUID NOT NULL REFERENCES public.teachers(id) ON DELETE CASCADE,
  is_school_admin      BOOLEAN NOT NULL DEFAULT false,
  is_active            BOOLEAN NOT NULL DEFAULT true,
  subjects_configured  BOOLEAN NOT NULL DEFAULT false,
  assigned_classes     SMALLINT[] NOT NULL DEFAULT '{}',
  assigned_subject_ids TEXT[] NOT NULL DEFAULT '{}',
  joined_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deactivated_at       TIMESTAMPTZ,
  CONSTRAINT uq_school_teachers_pair UNIQUE (school_udise, teacher_id)
);

-- Bihar e-Shikshakosh single-active-school posting invariant:
-- Prevents cross-school password-reset privilege escalation by ensuring a
-- teacher can have at most ONE active school posting at any time.
CREATE UNIQUE INDEX IF NOT EXISTS uq_school_teachers_single_active
  ON public.school_teachers (teacher_id)
  WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_school_teachers_roster
  ON public.school_teachers (school_udise, is_active, is_school_admin);

CREATE TABLE IF NOT EXISTS public.students (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- 15-digit e-Shikshakosh code as exact trimmed TEXT; nullable only for new admissions
  student_code          TEXT UNIQUE
                          CHECK (
                            student_code IS NULL
                            OR (
                              char_length(btrim(student_code)) >= 6
                              AND student_code = btrim(student_code)
                              AND student_code !~* 'e[+-]?[0-9]'
                            )
                          ),
  school_udise          TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  student_name          TEXT NOT NULL CHECK (char_length(btrim(student_name)) >= 1),
  father_name           TEXT,
  dob                   DATE NOT NULL,
  gender                TEXT,
  class_num             SMALLINT NOT NULL CHECK (class_num IN (9, 10, 11, 12)),
  -- Real e-Shikshakosh Excel has no Stream/Section column; Class 11-12 pick stream on first login
  stream                TEXT NOT NULL DEFAULT 'UNSET'
                          CHECK (stream IN ('UNSET', 'NA', 'Arts', 'Science', 'Commerce')),
  section               TEXT NOT NULL DEFAULT 'A',
  roll_no               INT NOT NULL CHECK (roll_no > 0),
  academic_year         TEXT NOT NULL DEFAULT '2026-27',
  preferred_lang        TEXT NOT NULL DEFAULT 'HI' CHECK (preferred_lang IN ('HI', 'EN', 'BOTH')),
  is_active             BOOLEAN NOT NULL DEFAULT true,
  subjects_configured   BOOLEAN NOT NULL DEFAULT false,
  subject_changes_count INT NOT NULL DEFAULT 0 CHECK (subject_changes_count >= 0),
  pin_hash              TEXT,
  mastery_points        INT NOT NULL DEFAULT 0 CHECK (mastery_points >= 0),
  weekly_points         INT NOT NULL DEFAULT 0 CHECK (weekly_points >= 0),
  streak_days           INT NOT NULL DEFAULT 0 CHECK (streak_days >= 0),
  last_active_ist       DATE,
  week_start_ist        DATE,
  badges                JSONB NOT NULL DEFAULT '[]'::jsonb,
  token_version         INT NOT NULL DEFAULT 1 CHECK (token_version > 0),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_students_login_lookup
  ON public.students (school_udise, class_num, roll_no, dob);

CREATE INDEX IF NOT EXISTS idx_students_weekly_leaderboard
  ON public.students (school_udise, class_num, weekly_points DESC, mastery_points DESC)
  WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_students_school_class_active
  ON public.students (school_udise, academic_year, class_num, is_active);

CREATE TABLE IF NOT EXISTS public.user_sessions (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token_hash       TEXT UNIQUE NOT NULL,
  role             TEXT NOT NULL CHECK (role IN ('student', 'teacher', 'school_admin', 'super_admin')),
  principal_id     UUID NOT NULL,
  school_udise     TEXT REFERENCES public.schools(udise_code) ON DELETE SET NULL,
  active_workspace TEXT,
  token_version    INT NOT NULL DEFAULT 1 CHECK (token_version > 0),
  user_agent_hash  TEXT,
  expires_at       TIMESTAMPTZ NOT NULL,
  revoked_at       TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_sessions_principal_active
  ON public.user_sessions (principal_id, role)
  WHERE revoked_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_user_sessions_expires_at
  ON public.user_sessions (expires_at);

CREATE TABLE IF NOT EXISTS public.auth_rate_limits (
  bucket_key    TEXT PRIMARY KEY,
  attempts      INT NOT NULL DEFAULT 0 CHECK (attempts >= 0),
  window_start  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  blocked_until TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_auth_rate_limits_blocked
  ON public.auth_rate_limits (blocked_until)
  WHERE blocked_until IS NOT NULL;

CREATE TABLE IF NOT EXISTS public.sync_logs (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_udise      TEXT REFERENCES public.schools(udise_code) ON DELETE SET NULL,
  sync_type         TEXT NOT NULL CHECK (sync_type IN ('ONBOARDING', 'STUDENTS', 'TEACHERS')),
  performed_by_role TEXT NOT NULL,
  performed_by_id   UUID NOT NULL,
  added_count       INT NOT NULL DEFAULT 0 CHECK (added_count >= 0),
  updated_count     INT NOT NULL DEFAULT 0 CHECK (updated_count >= 0),
  deactivated_count INT NOT NULL DEFAULT 0 CHECK (deactivated_count >= 0),
  skipped_count     INT NOT NULL DEFAULT 0 CHECK (skipped_count >= 0),
  conflicts_json    JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sync_logs_school_time
  ON public.sync_logs (school_udise, created_at DESC);

CREATE TABLE IF NOT EXISTS public.audit_logs (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_udise TEXT REFERENCES public.schools(udise_code) ON DELETE SET NULL,
  actor_role   TEXT NOT NULL,
  actor_id     UUID,
  action       TEXT NOT NULL,
  target_type  TEXT,
  target_id    TEXT,
  meta_json    JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_school_time
  ON public.audit_logs (school_udise, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_audit_logs_actor_time
  ON public.audit_logs (actor_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_audit_logs_action_time
  ON public.audit_logs (action, created_at DESC);

-- =============================================================================
-- 2. BSEB CURRICULUM CATALOG, NOTES & TEACHER LESSON PLANS
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.subjects (
  id           TEXT PRIMARY KEY,
  bseb_code    TEXT NOT NULL,
  class_num    SMALLINT NOT NULL CHECK (class_num IN (9, 10, 11, 12)),
  stream       TEXT NOT NULL CHECK (stream IN ('NA', 'Arts', 'Science', 'Commerce', 'ALL')),
  category     TEXT NOT NULL
                 CHECK (category IN ('MANDATORY', 'MIL', 'SIL', 'LANG_1', 'LANG_2', 'ELECTIVE', 'ADDITIONAL', 'SKILL')),
  name_en      TEXT NOT NULL,
  name_hi      TEXT NOT NULL,
  icon_name    TEXT NOT NULL DEFAULT 'BookOpen',
  accent_color TEXT NOT NULL DEFAULT '#1E3A8A',
  sort_order   INT NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_subjects_class_stream_cat
  ON public.subjects (class_num, stream, category, sort_order);

CREATE TABLE IF NOT EXISTS public.student_subjects (
  student_id    UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  academic_year TEXT NOT NULL DEFAULT '2026-27',
  subject_id    TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE RESTRICT,
  slot_type     TEXT NOT NULL
                  CHECK (slot_type IN ('MANDATORY', 'MIL', 'SIL', 'LANG_1', 'LANG_2', 'ELECTIVE', 'ADDITIONAL', 'SKILL')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (student_id, academic_year, subject_id)
);

CREATE INDEX IF NOT EXISTS idx_student_subjects_subject_year
  ON public.student_subjects (subject_id, academic_year);

CREATE TABLE IF NOT EXISTS public.chapters (
  id                   TEXT PRIMARY KEY,
  subject_id           TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  chapter_no           SMALLINT NOT NULL CHECK (chapter_no > 0),
  title_en             TEXT NOT NULL,
  title_hi             TEXT NOT NULL,
  summary_en           TEXT,
  summary_hi           TEXT,
  bseb_weightage_marks SMALLINT NOT NULL DEFAULT 5 CHECK (bseb_weightage_marks >= 0),
  estimated_mins       SMALLINT NOT NULL DEFAULT 15 CHECK (estimated_mins > 0),
  is_published         BOOLEAN NOT NULL DEFAULT true,
  CONSTRAINT uq_chapters_subject_no UNIQUE (subject_id, chapter_no)
);

CREATE INDEX IF NOT EXISTS idx_chapters_subject_published
  ON public.chapters (subject_id, is_published, chapter_no);

CREATE TABLE IF NOT EXISTS public.chapter_notes (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapter_id          TEXT UNIQUE NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  mindmap_json        JSONB NOT NULL,
  sections_json       JSONB NOT NULL,
  board_capsule_json  JSONB NOT NULL DEFAULT '{}'::jsonb,
  quality_checks_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  status              TEXT NOT NULL DEFAULT 'PUBLISHED' CHECK (status IN ('DRAFT', 'PUBLISHED')),
  version             INT NOT NULL DEFAULT 1 CHECK (version > 0),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Teacher-only pedagogical lesson plans
CREATE TABLE IF NOT EXISTS public.lesson_plans (
  id                               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapter_id                       TEXT UNIQUE NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  duration_periods                 SMALLINT NOT NULL DEFAULT 4 CHECK (duration_periods > 0),
  objectives_hi                    TEXT NOT NULL,
  objectives_en                    TEXT NOT NULL,
  teaching_steps_json              JSONB NOT NULL DEFAULT '[]'::jsonb,
  blackboard_points_json           JSONB NOT NULL DEFAULT '[]'::jsonb,
  classroom_activities_json        JSONB NOT NULL DEFAULT '[]'::jsonb,
  homework_json                    JSONB NOT NULL DEFAULT '[]'::jsonb,
  common_student_misconceptions_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  updated_at                       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- 3. MEDIA VAULT & OAUTH TOKEN CACHE
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.media_objects (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  drive_file_id     TEXT UNIQUE,
  school_udise      TEXT REFERENCES public.schools(udise_code) ON DELETE SET NULL,
  scope             TEXT NOT NULL CHECK (scope IN ('GLOBAL', 'SCHOOL_PRIVATE', 'EDITORIAL_SUBMISSION')),
  owner_role        TEXT NOT NULL,
  owner_id          UUID NOT NULL,
  original_filename TEXT NOT NULL,
  mime_type         TEXT NOT NULL,
  size_bytes        BIGINT NOT NULL DEFAULT 0 CHECK (size_bytes >= 0),
  status            TEXT NOT NULL DEFAULT 'PENDING'
                      CHECK (status IN ('PENDING', 'ACTIVE', 'DELETE_QUEUED', 'DELETED')),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_media_objects_gc
  ON public.media_objects (status, created_at);

CREATE INDEX IF NOT EXISTS idx_media_objects_school_scope
  ON public.media_objects (school_udise, scope, status);

CREATE TABLE IF NOT EXISTS public.system_oauth_tokens (
  provider               TEXT PRIMARY KEY,
  encrypted_access_token TEXT NOT NULL DEFAULT '',
  expires_at             TIMESTAMPTZ NOT NULL DEFAULT to_timestamp(0),
  refresh_locked_until   TIMESTAMPTZ,
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- 4. QUESTION SUBMISSIONS (EDITORIAL PIPELINE) & QUESTION BANK
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.question_submissions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_udise      TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  teacher_id        UUID NOT NULL REFERENCES public.teachers(id) ON DELETE CASCADE,
  subject_id        TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE RESTRICT,
  chapter_id        TEXT REFERENCES public.chapters(id) ON DELETE SET NULL,
  topic_hint        TEXT,
  source_type       TEXT NOT NULL CHECK (source_type IN ('SCANNED_PDF', 'EXCEL', 'WORD', 'IMAGE')),
  media_object_id   UUID NOT NULL REFERENCES public.media_objects(id) ON DELETE RESTRICT,
  status            TEXT NOT NULL DEFAULT 'PENDING'
                      CHECK (status IN ('PENDING', 'AI_PARSING', 'AI_READY', 'APPROVED', 'REJECTED')),
  ai_extracted_json JSONB,
  ai_progress_json  JSONB,
  ai_model_used     TEXT,
  reviewed_by       UUID REFERENCES public.super_admins(id) ON DELETE SET NULL,
  review_feedback   TEXT,
  approved_count    INT NOT NULL DEFAULT 0 CHECK (approved_count >= 0),
  locked_at         TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  reviewed_at       TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_question_submissions_queue
  ON public.question_submissions (status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_question_submissions_teacher
  ON public.question_submissions (school_udise, teacher_id, created_at DESC);

CREATE TABLE IF NOT EXISTS public.questions (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id             TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  chapter_id             TEXT NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  topic_tag              TEXT,
  bank_pool              TEXT NOT NULL DEFAULT 'PRACTICE'
                           CHECK (bank_pool IN ('PRACTICE', 'EXAM_ONLY')),
  question_type          TEXT NOT NULL
                           CHECK (question_type IN ('MCQ', 'SHORT_2M', 'LONG_5M', 'MATCH_PAIRS', 'DIAGRAM_LABEL', 'FLASHCARD')),
  difficulty_tier        TEXT NOT NULL DEFAULT 'BOARD'
                           CHECK (difficulty_tier IN ('FOUNDATION', 'BOARD', 'TOPPER')),
  exam_year_tag          TEXT,
  q_hi                   TEXT NOT NULL,
  q_en                   TEXT NOT NULL,
  options_json           JSONB,
  correct_option         TEXT,
  clue_hi                TEXT,
  clue_en                TEXT,
  explanation_hi         TEXT,
  explanation_en         TEXT,
  model_answer_hi        TEXT,
  model_answer_en        TEXT,
  memory_cues_json       JSONB NOT NULL DEFAULT '[]'::jsonb,
  marking_scheme_json    JSONB NOT NULL DEFAULT '[]'::jsonb,
  visual_asset_json      JSONB,
  source_submission_id   UUID REFERENCES public.question_submissions(id) ON DELETE SET NULL,
  contributed_by_teacher UUID REFERENCES public.teachers(id) ON DELETE SET NULL,
  is_published           BOOLEAN NOT NULL DEFAULT true,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_questions_chapter_filter
  ON public.questions (chapter_id, bank_pool, question_type, difficulty_tier, is_published);

CREATE INDEX IF NOT EXISTS idx_questions_subject_pool
  ON public.questions (subject_id, bank_pool, is_published);

-- Trigram GIN indexes for duplicate question detection across English & Hindi stems
CREATE INDEX IF NOT EXISTS idx_questions_q_en_trgm
  ON public.questions USING GIN (q_en gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_questions_q_hi_trgm
  ON public.questions USING GIN (q_hi gin_trgm_ops);

-- =============================================================================
-- 5. STUDENT MASTERY, SPACED REVISION & IDEMPOTENT PRACTICE SESSIONS
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.student_chapter_progress (
  student_id          UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  chapter_id          TEXT NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  notes_completed     BOOLEAN NOT NULL DEFAULT false,
  notes_progress_pct  SMALLINT NOT NULL DEFAULT 0 CHECK (notes_progress_pct BETWEEN 0 AND 100),
  flashcards_mastered INT NOT NULL DEFAULT 0 CHECK (flashcards_mastered >= 0),
  practice_attempted  INT NOT NULL DEFAULT 0 CHECK (practice_attempted >= 0),
  practice_correct    INT NOT NULL DEFAULT 0 CHECK (practice_correct >= 0),
  mastery_pct         SMALLINT NOT NULL DEFAULT 0 CHECK (mastery_pct BETWEEN 0 AND 100),
  last_studied_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (student_id, chapter_id)
);

CREATE INDEX IF NOT EXISTS idx_student_chapter_progress_recent
  ON public.student_chapter_progress (student_id, last_studied_at DESC);

CREATE TABLE IF NOT EXISTS public.student_question_mastery (
  student_id       UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  question_id      UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  attempts_count   INT NOT NULL DEFAULT 0 CHECK (attempts_count >= 0),
  correct_count    INT NOT NULL DEFAULT 0 CHECK (correct_count >= 0),
  streak_correct   SMALLINT NOT NULL DEFAULT 0 CHECK (streak_correct >= 0),
  is_bookmarked    BOOLEAN NOT NULL DEFAULT false,
  last_answered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (student_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_student_question_mastery_bookmarks
  ON public.student_question_mastery (student_id, is_bookmarked)
  WHERE is_bookmarked = true;

CREATE TABLE IF NOT EXISTS public.student_revision_queue (
  student_id      UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  question_id     UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  chapter_id      TEXT NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  wrong_count     INT NOT NULL DEFAULT 1 CHECK (wrong_count >= 1),
  ease_factor     NUMERIC(4, 2) NOT NULL DEFAULT 2.50 CHECK (ease_factor >= 1.30),
  interval_days   INT NOT NULL DEFAULT 1 CHECK (interval_days >= 1),
  next_review_ist DATE NOT NULL,
  resolved        BOOLEAN NOT NULL DEFAULT false,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (student_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_student_revision_queue_due
  ON public.student_revision_queue (student_id, resolved, next_review_ist);

-- Idempotent attempt_id PK prevents double-submit XP farming on flaky rural 4G
CREATE TABLE IF NOT EXISTS public.practice_sessions (
  attempt_id         UUID PRIMARY KEY,
  student_id         UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  school_udise       TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  subject_id         TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  chapter_id         TEXT REFERENCES public.chapters(id) ON DELETE SET NULL,
  mode               TEXT NOT NULL
                       CHECK (mode IN (
                         'FLASHCARD',
                         'MATCH_PAIRS',
                         'DIAGRAM_LABEL',
                         'MCQ_PRACTICE',
                         'SUBJECTIVE_SELF_CHECK',
                         'REVISION_DRILL',
                         'DAILY_CHALLENGE'
                       )),
  total_questions    INT NOT NULL DEFAULT 0 CHECK (total_questions >= 0),
  correct_count      INT NOT NULL DEFAULT 0 CHECK (correct_count >= 0),
  points_awarded     INT NOT NULL DEFAULT 0 CHECK (points_awarded >= 0),
  time_spent_seconds INT NOT NULL DEFAULT 0 CHECK (time_spent_seconds >= 0),
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_practice_sessions_student_time
  ON public.practice_sessions (student_id, created_at DESC);

-- =============================================================================
-- 6. TEACHER STUDY MATERIALS & OPEN SCHOOL DOUBT BOARDS (ZERO PRIVATE DMs!)
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.teacher_materials (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_udise     TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  teacher_id       UUID NOT NULL REFERENCES public.teachers(id) ON DELETE CASCADE,
  subject_id       TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE RESTRICT,
  chapter_id       TEXT REFERENCES public.chapters(id) ON DELETE SET NULL,
  class_num        SMALLINT NOT NULL CHECK (class_num IN (9, 10, 11, 12)),
  title            TEXT NOT NULL CHECK (char_length(btrim(title)) >= 2),
  description      TEXT,
  material_type    TEXT NOT NULL
                     CHECK (material_type IN ('NOTE', 'PDF', 'IMAGE', 'VIDEO_UPLOAD', 'VIDEO_YOUTUBE')),
  body_markdown    TEXT,
  media_object_id  UUID REFERENCES public.media_objects(id) ON DELETE SET NULL,
  youtube_video_id TEXT CHECK (youtube_video_id IS NULL OR youtube_video_id ~ '^[A-Za-z0-9_-]{11}$'),
  is_pinned        BOOLEAN NOT NULL DEFAULT false,
  is_deleted       BOOLEAN NOT NULL DEFAULT false,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_teacher_materials_feed
  ON public.teacher_materials (school_udise, class_num, subject_id, is_deleted, is_pinned DESC, created_at DESC);

-- Public School + Class + Subject Doubt Board ONLY (strictly no 1-to-1 DMs)
CREATE TABLE IF NOT EXISTS public.open_doubts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_udise    TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  academic_year   TEXT NOT NULL DEFAULT '2026-27',
  student_id      UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  subject_id      TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE RESTRICT,
  chapter_id      TEXT REFERENCES public.chapters(id) ON DELETE SET NULL,
  class_num       SMALLINT NOT NULL CHECK (class_num IN (9, 10, 11, 12)),
  question_text   TEXT NOT NULL CHECK (char_length(btrim(question_text)) >= 5),
  media_object_id UUID REFERENCES public.media_objects(id) ON DELETE SET NULL,
  status          TEXT NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'ANSWERED', 'RESOLVED')),
  is_pinned       BOOLEAN NOT NULL DEFAULT false,
  is_hidden       BOOLEAN NOT NULL DEFAULT false,
  hidden_by       UUID REFERENCES public.teachers(id) ON DELETE SET NULL,
  upvote_count    INT NOT NULL DEFAULT 1 CHECK (upvote_count >= 0),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_open_doubts_board
  ON public.open_doubts (school_udise, class_num, subject_id, is_hidden, is_pinned DESC, created_at DESC);

CREATE TABLE IF NOT EXISTS public.doubt_upvotes (
  doubt_id   UUID NOT NULL REFERENCES public.open_doubts(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (doubt_id, student_id)
);

-- ONLY verified school teachers can post answers (student-to-student messaging disallowed)
CREATE TABLE IF NOT EXISTS public.doubt_answers (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  doubt_id        UUID NOT NULL REFERENCES public.open_doubts(id) ON DELETE CASCADE,
  teacher_id      UUID NOT NULL REFERENCES public.teachers(id) ON DELETE CASCADE,
  answer_text     TEXT NOT NULL CHECK (char_length(btrim(answer_text)) >= 2),
  media_object_id UUID REFERENCES public.media_objects(id) ON DELETE SET NULL,
  is_hidden       BOOLEAN NOT NULL DEFAULT false,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_doubt_answers_doubt
  ON public.doubt_answers (doubt_id, is_hidden, created_at ASC);

-- =============================================================================
-- 7. EXAMS, PRIVATE ATTEMPTS & REALTIME LIVE EXAM ROSTER
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.exams (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_udise          TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  academic_year         TEXT NOT NULL DEFAULT '2026-27',
  created_by_teacher    UUID NOT NULL REFERENCES public.teachers(id) ON DELETE RESTRICT,
  title                 TEXT NOT NULL CHECK (char_length(btrim(title)) >= 2),
  exam_mode             TEXT NOT NULL CHECK (exam_mode IN ('LIVE_PIN', 'SCHEDULED')),
  scope_type            TEXT NOT NULL CHECK (scope_type IN ('TOPIC', 'CHAPTER', 'SUBJECT')),
  class_num             SMALLINT NOT NULL CHECK (class_num IN (9, 10, 11, 12)),
  stream                TEXT NOT NULL DEFAULT 'ALL'
                          CHECK (stream IN ('ALL', 'NA', 'Arts', 'Science', 'Commerce')),
  subject_id            TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE RESTRICT,
  chapter_ids           TEXT[] NOT NULL DEFAULT '{}',
  room_pin              TEXT CHECK (room_pin IS NULL OR room_pin ~ '^[0-9]{6}$'),
  duration_mins         SMALLINT NOT NULL CHECK (duration_mins BETWEEN 5 AND 180),
  starts_at             TIMESTAMPTZ,
  ends_at               TIMESTAMPTZ,
  show_solutions_policy TEXT NOT NULL DEFAULT 'AFTER_EXAM_ENDS'
                          CHECK (show_solutions_policy IN ('AFTER_EXAM_ENDS', 'IMMEDIATE_ON_SUBMIT', 'TEACHER_ONLY')),
  question_ids          UUID[] NOT NULL DEFAULT '{}',
  -- Immutable frozen question payload captured upon exam activation
  questions_snapshot    JSONB NOT NULL DEFAULT '[]'::jsonb,
  shuffle_questions     BOOLEAN NOT NULL DEFAULT true,
  shuffle_options       BOOLEAN NOT NULL DEFAULT true,
  status                TEXT NOT NULL DEFAULT 'DRAFT'
                          CHECK (status IN ('DRAFT', 'LOBBY', 'ACTIVE', 'ENDED')),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at              TIMESTAMPTZ
);

-- School-scoped active Live Exam Room PIN uniqueness
CREATE UNIQUE INDEX IF NOT EXISTS uq_exams_school_active_pin
  ON public.exams (school_udise, room_pin)
  WHERE status IN ('LOBBY', 'ACTIVE') AND room_pin IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_exams_school_status
  ON public.exams (school_udise, class_num, status, starts_at DESC);

-- Strictly private per-student exam attempt (NEVER published to Realtime)
CREATE TABLE IF NOT EXISTS public.exam_attempts (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id            UUID NOT NULL REFERENCES public.exams(id) ON DELETE CASCADE,
  school_udise       TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  academic_year      TEXT NOT NULL DEFAULT '2026-27',
  student_id         UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  shuffle_seed       TEXT NOT NULL,
  question_order_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  answers_json       JSONB NOT NULL DEFAULT '{}'::jsonb,
  status             TEXT NOT NULL DEFAULT 'JOINED'
                       CHECK (status IN ('JOINED', 'IN_PROGRESS', 'SUBMITTED')),
  answered_count     INT NOT NULL DEFAULT 0 CHECK (answered_count >= 0),
  score              INT NOT NULL DEFAULT 0 CHECK (score >= 0),
  total_questions    INT NOT NULL DEFAULT 0 CHECK (total_questions >= 0),
  accuracy           NUMERIC(5, 2) NOT NULL DEFAULT 0 CHECK (accuracy BETWEEN 0 AND 100),
  tab_switches       INT NOT NULL DEFAULT 0 CHECK (tab_switches >= 0),
  time_taken_seconds INT NOT NULL DEFAULT 0 CHECK (time_taken_seconds >= 0),
  started_at         TIMESTAMPTZ,
  submitted_at       TIMESTAMPTZ,
  CONSTRAINT uq_exam_attempts_exam_student UNIQUE (exam_id, student_id)
);

CREATE INDEX IF NOT EXISTS idx_exam_attempts_exam_score
  ON public.exam_attempts (exam_id, status, score DESC, time_taken_seconds ASC);

CREATE INDEX IF NOT EXISTS idx_exam_attempts_student_history
  ON public.exam_attempts (student_id, submitted_at DESC);

-- Realtime-published projector summary ONLY (zero answers_json, zero PII beyond classroom name/roll)
CREATE TABLE IF NOT EXISTS public.live_exam_roster (
  exam_id         UUID NOT NULL REFERENCES public.exams(id) ON DELETE CASCADE,
  student_id      UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  school_udise    TEXT NOT NULL REFERENCES public.schools(udise_code) ON DELETE CASCADE,
  student_name    TEXT NOT NULL,
  roll_no         INT NOT NULL,
  status          TEXT NOT NULL DEFAULT 'JOINED'
                    CHECK (status IN ('JOINED', 'IN_PROGRESS', 'SUBMITTED')),
  answered_count  INT NOT NULL DEFAULT 0 CHECK (answered_count >= 0),
  total_questions INT NOT NULL DEFAULT 0 CHECK (total_questions >= 0),
  score           INT NOT NULL DEFAULT 0 CHECK (score >= 0),
  accuracy        NUMERIC(5, 2) NOT NULL DEFAULT 0 CHECK (accuracy BETWEEN 0 AND 100),
  tab_switches    INT NOT NULL DEFAULT 0 CHECK (tab_switches >= 0),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (exam_id, student_id)
);

CREATE INDEX IF NOT EXISTS idx_live_exam_roster_school_exam
  ON public.live_exam_roster (school_udise, exam_id, status);

ALTER TABLE public.live_exam_roster REPLICA IDENTITY FULL;

-- =============================================================================
-- 8. UPDATED_AT TRIGGERS
-- =============================================================================

DO $$
DECLARE
  tbl TEXT;
  trigger_tables TEXT[] := ARRAY[
    'super_admins',
    'schools',
    'teachers',
    'students',
    'chapter_notes',
    'lesson_plans',
    'media_objects',
    'system_oauth_tokens',
    'student_revision_queue',
    'teacher_materials',
    'open_doubts',
    'live_exam_roster'
  ];
BEGIN
  FOREACH tbl IN ARRAY trigger_tables LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS trg_%I_updated_at ON public.%I;', tbl, tbl);
    EXECUTE format(
      'CREATE TRIGGER trg_%I_updated_at BEFORE UPDATE ON public.%I FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();',
      tbl,
      tbl
    );
  END LOOP;
END
$$;

-- =============================================================================
-- 9. SERVER-ONLY RPC HELPERS (LOCKING, TRIGRAM DEDUP, SAFE UPVOTES)
-- =============================================================================

-- Transaction-scoped PgBouncer/Supavisor-safe OAuth refresh lease coordination.
-- Uses pg_try_advisory_xact_lock (auto-released at transaction end) plus an
-- atomic refresh_locked_until lease column so locks can NEVER leak across pooled connections.
DROP FUNCTION IF EXISTS public.try_oauth_advisory_lock(BIGINT);
DROP FUNCTION IF EXISTS public.release_oauth_advisory_lock(BIGINT);

CREATE OR REPLACE FUNCTION public.acquire_oauth_refresh_lease(
  p_provider TEXT,
  p_lock_key BIGINT,
  p_lease_seconds INT DEFAULT 15
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_lease_secs INT := GREATEST(5, LEAST(COALESCE(p_lease_seconds, 15), 60));
  v_row_count  INT := 0;
BEGIN
  IF NOT pg_try_advisory_xact_lock(p_lock_key) THEN
    RETURN false;
  END IF;

  INSERT INTO public.system_oauth_tokens (
    provider,
    encrypted_access_token,
    expires_at,
    refresh_locked_until
  )
  VALUES (
    p_provider,
    '',
    to_timestamp(0),
    NOW() + make_interval(secs => v_lease_secs)
  )
  ON CONFLICT (provider) DO UPDATE
    SET refresh_locked_until = NOW() + make_interval(secs => v_lease_secs)
    WHERE public.system_oauth_tokens.refresh_locked_until IS NULL
       OR public.system_oauth_tokens.refresh_locked_until <= NOW();

  GET DIAGNOSTICS v_row_count = ROW_COUNT;
  RETURN v_row_count > 0;
END;
$$;

CREATE OR REPLACE FUNCTION public.release_oauth_refresh_lease(p_provider TEXT)
RETURNS VOID
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  UPDATE public.system_oauth_tokens
  SET refresh_locked_until = NULL
  WHERE provider = p_provider;
$$;

-- Trigram duplicate question search across English & Hindi stems
CREATE OR REPLACE FUNCTION public.find_similar_questions(
  p_subject_id TEXT,
  p_q_en TEXT,
  p_q_hi TEXT,
  p_threshold REAL DEFAULT 0.62,
  p_limit INT DEFAULT 5
)
RETURNS TABLE (
  id UUID,
  chapter_id TEXT,
  question_type TEXT,
  q_hi TEXT,
  q_en TEXT,
  sim_score REAL
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    q.id,
    q.chapter_id,
    q.question_type,
    q.q_hi,
    q.q_en,
    GREATEST(
      COALESCE(similarity(q.q_en, COALESCE(p_q_en, '')), 0),
      COALESCE(similarity(q.q_hi, COALESCE(p_q_hi, '')), 0)
    )::REAL AS sim_score
  FROM public.questions q
  WHERE q.subject_id = p_subject_id
    AND (
      (COALESCE(p_q_en, '') <> '' AND similarity(q.q_en, p_q_en) >= p_threshold)
      OR (COALESCE(p_q_hi, '') <> '' AND similarity(q.q_hi, p_q_hi) >= p_threshold)
    )
  ORDER BY sim_score DESC
  LIMIT GREATEST(1, LEAST(p_limit, 25));
$$;

-- Restrict RPC execution strictly to service_role
REVOKE ALL ON FUNCTION public.acquire_oauth_refresh_lease(TEXT, BIGINT, INT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.release_oauth_refresh_lease(TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.find_similar_questions(TEXT, TEXT, TEXT, REAL, INT) FROM PUBLIC, anon, authenticated;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
    GRANT EXECUTE ON FUNCTION public.acquire_oauth_refresh_lease(TEXT, BIGINT, INT) TO service_role;
    GRANT EXECUTE ON FUNCTION public.release_oauth_refresh_lease(TEXT) TO service_role;
    GRANT EXECUTE ON FUNCTION public.find_similar_questions(TEXT, TEXT, TEXT, REAL, INT) TO service_role;
  END IF;
END
$$;

-- =============================================================================
-- 10. STRICT DEFAULT-DENY RLS & SCOPED REALTIME PUBLICATION
-- =============================================================================

DO $$
DECLARE
  tbl TEXT;
  all_tables TEXT[] := ARRAY[
    'super_admins',
    'schools',
    'teachers',
    'school_teachers',
    'students',
    'user_sessions',
    'auth_rate_limits',
    'sync_logs',
    'audit_logs',
    'subjects',
    'student_subjects',
    'chapters',
    'chapter_notes',
    'lesson_plans',
    'media_objects',
    'system_oauth_tokens',
    'question_submissions',
    'questions',
    'student_chapter_progress',
    'student_question_mastery',
    'student_revision_queue',
    'practice_sessions',
    'teacher_materials',
    'open_doubts',
    'doubt_upvotes',
    'doubt_answers',
    'exams',
    'exam_attempts',
    'live_exam_roster'
  ];
BEGIN
  FOREACH tbl IN ARRAY all_tables LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', tbl);
    -- Defense-in-depth privilege revocation from client-facing roles
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
      EXECUTE format('REVOKE ALL ON TABLE public.%I FROM anon;', tbl);
    END IF;
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
      EXECUTE format('REVOKE ALL ON TABLE public.%I FROM authenticated;', tbl);
    END IF;
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
      EXECUTE format('GRANT ALL ON TABLE public.%I TO service_role;', tbl);
    END IF;
  END LOOP;
END
$$;

-- ONLY live_exam_roster allows scoped Realtime SELECT using custom JWT claims:
-- { role: 'authenticated', exam_id: '<uuid>', school_udise: '<11-digit>' }
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    GRANT SELECT ON TABLE public.live_exam_roster TO authenticated;
  END IF;
END
$$;

DROP POLICY IF EXISTS live_exam_roster_scoped_monitor_read ON public.live_exam_roster;
CREATE POLICY live_exam_roster_scoped_monitor_read
  ON public.live_exam_roster
  FOR SELECT
  TO authenticated
  USING (
    COALESCE(NULLIF(current_setting('request.jwt.claims', true), '')::jsonb ->> 'exam_id', '') <> ''
    AND COALESCE(NULLIF(current_setting('request.jwt.claims', true), '')::jsonb ->> 'school_udise', '') <> ''
    AND exam_id::text = (NULLIF(current_setting('request.jwt.claims', true), '')::jsonb ->> 'exam_id')
    AND school_udise = (NULLIF(current_setting('request.jwt.claims', true), '')::jsonb ->> 'school_udise')
  );

-- Publish ONLY live_exam_roster to Supabase Realtime (idempotent)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_publication_tables
      WHERE pubname = 'supabase_realtime'
        AND schemaname = 'public'
        AND tablename = 'live_exam_roster'
    ) THEN
      ALTER PUBLICATION supabase_realtime ADD TABLE public.live_exam_roster;
    END IF;
  END IF;
END
$$;

-- #############################################################################
-- PART 2 / 3: 002_bseb_seed_catalog.sql
-- #############################################################################

-- =============================================================================
-- Students of Bihar (9-12) — Official BSEB Class 9-12 Subject & Chapter Catalog
-- Idempotent seed migration (ON CONFLICT DO UPDATE).
-- Follows authentic Bihar School Examination Board (BSEB) subject codes,
-- Class 9-10 (Mandatory + MIL + SIL + Optional Skill/Add) and
-- Class 11-12 (Arts / Science / Commerce: Lang 1 + Lang 2 + 3 Electives + Add).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. SUBJECTS CATALOG (Class 9, 10, 11, 12)
-- -----------------------------------------------------------------------------

INSERT INTO public.subjects (
  id, bseb_code, class_num, stream, category, name_en, name_hi, icon_name, accent_color, sort_order
) VALUES
  -- ========================= CLASS 9 (BSEB SECONDARY) =========================
  ('bseb-9-math',       '110', 9,  'NA', 'MANDATORY',  'Mathematics',                                   'गणित',                                    'Calculator',     '#1E3A8A', 10),
  ('bseb-9-sci',        '112', 9,  'NA', 'MANDATORY',  'Science',                                       'विज्ञान',                                  'FlaskConical',   '#059669', 20),
  ('bseb-9-sst',        '111', 9,  'NA', 'MANDATORY',  'Social Science',                                'सामाजिक विज्ञान',                          'Landmark',       '#B45309', 30),
  ('bseb-9-eng',        '113', 9,  'NA', 'MANDATORY',  'English (Compulsory)',                          'अंग्रेज़ी (अनिवार्य)',                     'BookOpen',       '#4338CA', 40),
  -- Class 9 MIL (Mother Tongue)
  ('bseb-9-mil-hi',     '101', 9,  'NA', 'MIL',        'Hindi (MIL)',                                   'हिन्दी (मातृभाषा)',                        'BookText',       '#C2410C', 50),
  ('bseb-9-mil-bn',     '102', 9,  'NA', 'MIL',        'Bangla (MIL)',                                  'बांग्ला (मातृभाषा)',                       'BookText',       '#9A3412', 51),
  ('bseb-9-mil-ur',     '103', 9,  'NA', 'MIL',        'Urdu (MIL)',                                    'उर्दू (मातृभाषा)',                         'BookText',       '#0F766E', 52),
  ('bseb-9-mil-mai',    '104', 9,  'NA', 'MIL',        'Maithili (MIL)',                                'मैथिली (मातृभाषा)',                        'BookText',       '#7C2D12', 53),
  -- Class 9 SIL (Second Indian Language)
  ('bseb-9-sil-san',    '105', 9,  'NA', 'SIL',        'Sanskrit (SIL)',                                'संस्कृत (द्वितीय भारतीय भाषा)',            'ScrollText',     '#92400E', 60),
  ('bseb-9-sil-nhi',    '106', 9,  'NA', 'SIL',        'Non-Hindi / Rashtrabhasha Hindi (SIL)',         'अहिन्दी / राष्ट्रभाषा हिन्दी (द्वितीय भाषा)', 'ScrollText',   '#B45309', 61),
  ('bseb-9-sil-ar',     '107', 9,  'NA', 'SIL',        'Arabic (SIL)',                                  'अरबी (द्वितीय भारतीय भाषा)',               'ScrollText',     '#115E59', 62),
  ('bseb-9-sil-fa',     '108', 9,  'NA', 'SIL',        'Persian (SIL)',                                 'फारसी (द्वितीय भारतीय भाषा)',              'ScrollText',     '#155E75', 63),
  ('bseb-9-sil-bho',    '109', 9,  'NA', 'SIL',        'Bhojpuri (SIL)',                                'भोजपुरी (द्वितीय भारतीय भाषा)',            'ScrollText',     '#9A3412', 64),
  -- Class 9 Optional Skill / Additional
  ('bseb-9-skill-ict',  '125', 9,  'NA', 'SKILL',      'Information & Communication Technology (ICT)',  'सूचना एवं संचार प्रौद्योगिकी (ICT)',        'Laptop',         '#1D4ED8', 70),
  ('bseb-9-add-hmath',  '114', 9,  'NA', 'ADDITIONAL', 'Higher Mathematics (Optional)',                 'उच्च गणित (ऐच्छिक)',                       'Sigma',          '#1E40AF', 71),
  ('bseb-9-add-eco',    '115', 9,  'NA', 'ADDITIONAL', 'Economics (Optional)',                          'अर्थशास्त्र (ऐच्छिक)',                     'TrendingUp',     '#047857', 72),
  ('bseb-9-add-hsci',   '120', 9,  'NA', 'ADDITIONAL', 'Home Science (Optional)',                       'गृह विज्ञान (ऐच्छिक)',                     'Home',           '#BE185D', 73),

  -- ========================= CLASS 10 (BSEB MATRIC) =========================
  ('bseb-10-math',      '110', 10, 'NA', 'MANDATORY',  'Mathematics',                                   'गणित',                                    'Calculator',     '#1E3A8A', 10),
  ('bseb-10-sci',       '112', 10, 'NA', 'MANDATORY',  'Science',                                       'विज्ञान',                                  'FlaskConical',   '#059669', 20),
  ('bseb-10-sst',       '111', 10, 'NA', 'MANDATORY',  'Social Science',                                'सामाजिक विज्ञान',                          'Landmark',       '#B45309', 30),
  ('bseb-10-eng',       '113', 10, 'NA', 'MANDATORY',  'English (Compulsory)',                          'अंग्रेज़ी (अनिवार्य)',                     'BookOpen',       '#4338CA', 40),
  -- Class 10 MIL
  ('bseb-10-mil-hi',    '101', 10, 'NA', 'MIL',        'Hindi (MIL)',                                   'हिन्दी (मातृभाषा)',                        'BookText',       '#C2410C', 50),
  ('bseb-10-mil-bn',    '102', 10, 'NA', 'MIL',        'Bangla (MIL)',                                  'बांग्ला (मातृभाषा)',                       'BookText',       '#9A3412', 51),
  ('bseb-10-mil-ur',    '103', 10, 'NA', 'MIL',        'Urdu (MIL)',                                    'उर्दू (मातृभाषा)',                         'BookText',       '#0F766E', 52),
  ('bseb-10-mil-mai',   '104', 10, 'NA', 'MIL',        'Maithili (MIL)',                                'मैथिली (मातृभाषा)',                        'BookText',       '#7C2D12', 53),
  -- Class 10 SIL
  ('bseb-10-sil-san',   '105', 10, 'NA', 'SIL',        'Sanskrit (SIL)',                                'संस्कृत (द्वितीय भारतीय भाषा)',            'ScrollText',     '#92400E', 60),
  ('bseb-10-sil-nhi',   '106', 10, 'NA', 'SIL',        'Non-Hindi / Rashtrabhasha Hindi (SIL)',         'अहिन्दी / राष्ट्रभाषा हिन्दी (द्वितीय भाषा)', 'ScrollText',   '#B45309', 61),
  ('bseb-10-sil-ar',    '107', 10, 'NA', 'SIL',        'Arabic (SIL)',                                  'अरबी (द्वितीय भारतीय भाषा)',               'ScrollText',     '#115E59', 62),
  ('bseb-10-sil-fa',    '108', 10, 'NA', 'SIL',        'Persian (SIL)',                                 'फारसी (द्वितीय भारतीय भाषा)',              'ScrollText',     '#155E75', 63),
  ('bseb-10-sil-bho',   '109', 10, 'NA', 'SIL',        'Bhojpuri (SIL)',                                'भोजपुरी (द्वितीय भारतीय भाषा)',            'ScrollText',     '#9A3412', 64),
  -- Class 10 Optional Skill / Additional
  ('bseb-10-skill-ict', '125', 10, 'NA', 'SKILL',      'Information & Communication Technology (ICT)',  'सूचना एवं संचार प्रौद्योगिकी (ICT)',        'Laptop',         '#1D4ED8', 70),
  ('bseb-10-add-hmath', '114', 10, 'NA', 'ADDITIONAL', 'Higher Mathematics (Optional)',                 'उच्च गणित (ऐच्छिक)',                       'Sigma',          '#1E40AF', 71),
  ('bseb-10-add-eco',   '115', 10, 'NA', 'ADDITIONAL', 'Economics (Optional)',                          'अर्थशास्त्र (ऐच्छिक)',                     'TrendingUp',     '#047857', 72),
  ('bseb-10-add-hsci',  '120', 10, 'NA', 'ADDITIONAL', 'Home Science (Optional)',                       'गृह विज्ञान (ऐच्छिक)',                     'Home',           '#BE185D', 73),

  -- ========================= CLASS 11 (BSEB INTERMEDIATE) =========================
  -- Compulsory Language 1 (Pick 1: English or Hindi)
  ('bseb-11-lang1-eng',     '105/205/305', 11, 'ALL',      'LANG_1',     'English (Compulsory Lang-1)',       'अंग्रेज़ी (प्रथम भाषा)',              'BookOpen',     '#4338CA', 10),
  ('bseb-11-lang1-hi',      '106/206/306', 11, 'ALL',      'LANG_1',     'Hindi (Compulsory Lang-1)',         'हिन्दी (प्रथम भाषा)',                 'BookText',     '#C2410C', 11),
  -- Compulsory Language 2 (Pick 1 distinct from Lang-1)
  ('bseb-11-lang2-eng',     '124/224/324', 11, 'ALL',      'LANG_2',     'English (Compulsory Lang-2)',       'अंग्रेज़ी (द्वितीय भाषा)',            'BookOpen',     '#3730A3', 20),
  ('bseb-11-lang2-hi',      '125/225/325', 11, 'ALL',      'LANG_2',     'Hindi (Compulsory Lang-2)',         'हिन्दी (द्वितीय भाषा)',               'BookText',     '#9A3412', 21),
  ('bseb-11-lang2-ur',      '107/207/307', 11, 'ALL',      'LANG_2',     'Urdu (Compulsory Lang-2)',          'उर्दू (द्वितीय भाषा)',                'ScrollText',   '#0F766E', 22),
  ('bseb-11-lang2-mai',     '108/208/308', 11, 'ALL',      'LANG_2',     'Maithili (Compulsory Lang-2)',      'मैथिली (द्वितीय भाषा)',               'ScrollText',   '#7C2D12', 23),
  ('bseb-11-lang2-san',     '109/209/309', 11, 'ALL',      'LANG_2',     'Sanskrit (Compulsory Lang-2)',      'संस्कृत (द्वितीय भाषा)',              'ScrollText',   '#92400E', 24),
  ('bseb-11-lang2-bn',      '115/215/315', 11, 'ALL',      'LANG_2',     'Bangla (Compulsory Lang-2)',        'बांग्ला (द्वितीय भाषा)',              'ScrollText',   '#854D0E', 25),
  ('bseb-11-lang2-bho',     '116/216/316', 11, 'ALL',      'LANG_2',     'Bhojpuri (Compulsory Lang-2)',      'भोजपुरी (द्वितीय भाषा)',              'ScrollText',   '#9A3412', 26),
  -- Class 11 Science Electives & Additional
  ('bseb-11-sci-phy',       '117',         11, 'Science',  'ELECTIVE',   'Physics',                           'भौतिकी',                              'Atom',         '#1E3A8A', 30),
  ('bseb-11-sci-chem',      '118',         11, 'Science',  'ELECTIVE',   'Chemistry',                         'रसायन विज्ञान',                       'FlaskConical', '#059669', 31),
  ('bseb-11-sci-math',      '121',         11, 'Science',  'ELECTIVE',   'Mathematics',                       'गणित',                                'Calculator',   '#2563EB', 32),
  ('bseb-11-sci-bio',       '119',         11, 'Science',  'ELECTIVE',   'Biology',                           'जीव विज्ञान',                         'Dna',          '#15803D', 33),
  ('bseb-11-sci-agri',      '120',         11, 'Science',  'ELECTIVE',   'Agriculture',                       'कृषि विज्ञान',                        'Sprout',       '#65A30D', 34),
  ('bseb-11-sci-add-math',  '121',         11, 'Science',  'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 40),
  ('bseb-11-sci-add-bio',   '119',         11, 'Science',  'ADDITIONAL', 'Biology (Additional)',              'जीव विज्ञान (अतिरिक्त)',              'Dna',          '#166534', 41),
  ('bseb-11-sci-add-cs',    '122',         11, 'Science',  'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 42),
  -- Class 11 Arts Electives & Additional
  ('bseb-11-arts-hist',     '321',         11, 'Arts',     'ELECTIVE',   'History',                           'इतिहास',                              'Landmark',     '#B45309', 30),
  ('bseb-11-arts-pol',      '322',         11, 'Arts',     'ELECTIVE',   'Political Science',                 'राजनीति विज्ञान',                     'Scale',        '#1E3A8A', 31),
  ('bseb-11-arts-geo',      '323',         11, 'Arts',     'ELECTIVE',   'Geography',                         'भूगोल',                               'Globe',        '#047857', 32),
  ('bseb-11-arts-eco',      '326',         11, 'Arts',     'ELECTIVE',   'Economics',                         'अर्थशास्त्र',                         'TrendingUp',   '#0F766E', 33),
  ('bseb-11-arts-psy',      '324',         11, 'Arts',     'ELECTIVE',   'Psychology',                        'मनोविज्ञान',                          'Brain',        '#7C3AED', 34),
  ('bseb-11-arts-soc',      '325',         11, 'Arts',     'ELECTIVE',   'Sociology',                         'समाजशास्त्र',                         'Users',        '#0369A1', 35),
  ('bseb-11-arts-phil',     '320',         11, 'Arts',     'ELECTIVE',   'Philosophy',                        'दर्शनशास्त्र',                        'Compass',      '#475569', 36),
  ('bseb-11-arts-hsci',     '319',         11, 'Arts',     'ELECTIVE',   'Home Science',                      'गृह विज्ञान',                         'Home',         '#BE185D', 37),
  ('bseb-11-arts-mus',      '318',         11, 'Arts',     'ELECTIVE',   'Music',                             'संगीत',                               'Music',        '#9333EA', 38),
  ('bseb-11-arts-add-cs',   '328',         11, 'Arts',     'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 40),
  ('bseb-11-arts-add-math', '327',         11, 'Arts',     'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 41),
  -- Class 11 Commerce Electives & Additional
  ('bseb-11-com-acc',       '220',         11, 'Commerce', 'ELECTIVE',   'Accountancy',                       'लेखाशास्त्र',                         'FileSpreadsheet', '#1E3A8A', 30),
  ('bseb-11-com-bst',       '217',         11, 'Commerce', 'ELECTIVE',   'Business Studies',                  'व्यावसायिक अध्ययन',                   'Briefcase',    '#0369A1', 31),
  ('bseb-11-com-eps',       '218',         11, 'Commerce', 'ELECTIVE',   'Entrepreneurship',                  'उद्यमिता',                            'Lightbulb',    '#D97706', 32),
  ('bseb-11-com-eco',       '219',         11, 'Commerce', 'ELECTIVE',   'Economics',                         'अर्थशास्त्र',                         'TrendingUp',   '#047857', 33),
  ('bseb-11-com-add-cs',    '221',         11, 'Commerce', 'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 40),
  ('bseb-11-com-add-math',  '222',         11, 'Commerce', 'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 41),

  -- ========================= CLASS 12 (BSEB INTERMEDIATE BOARD) =========================
  -- Compulsory Language 1
  ('bseb-12-lang1-eng',     '105/205/305', 12, 'ALL',      'LANG_1',     'English (Compulsory Lang-1)',       'अंग्रेज़ी (प्रथम भाषा)',              'BookOpen',     '#4338CA', 10),
  ('bseb-12-lang1-hi',      '106/206/306', 12, 'ALL',      'LANG_1',     'Hindi (Compulsory Lang-1)',         'हिन्दी (प्रथम भाषा)',                 'BookText',     '#C2410C', 11),
  -- Compulsory Language 2
  ('bseb-12-lang2-eng',     '124/224/324', 12, 'ALL',      'LANG_2',     'English (Compulsory Lang-2)',       'अंग्रेज़ी (द्वितीय भाषा)',            'BookOpen',     '#3730A3', 20),
  ('bseb-12-lang2-hi',      '125/225/325', 12, 'ALL',      'LANG_2',     'Hindi (Compulsory Lang-2)',         'हिन्दी (द्वितीय भाषा)',               'BookText',     '#9A3412', 21),
  ('bseb-12-lang2-ur',      '107/207/307', 12, 'ALL',      'LANG_2',     'Urdu (Compulsory Lang-2)',          'उर्दू (द्वितीय भाषा)',                'ScrollText',   '#0F766E', 22),
  ('bseb-12-lang2-mai',     '108/208/308', 12, 'ALL',      'LANG_2',     'Maithili (Compulsory Lang-2)',      'मैथिली (द्वितीय भाषा)',               'ScrollText',   '#7C2D12', 23),
  ('bseb-12-lang2-san',     '109/209/309', 12, 'ALL',      'LANG_2',     'Sanskrit (Compulsory Lang-2)',      'संस्कृत (द्वितीय भाषा)',              'ScrollText',   '#92400E', 24),
  ('bseb-12-lang2-bn',      '115/215/315', 12, 'ALL',      'LANG_2',     'Bangla (Compulsory Lang-2)',        'बांग्ला (द्वितीय भाषा)',              'ScrollText',   '#854D0E', 25),
  ('bseb-12-lang2-bho',     '116/216/316', 12, 'ALL',      'LANG_2',     'Bhojpuri (Compulsory Lang-2)',      'भोजपुरी (द्वितीय भाषा)',              'ScrollText',   '#9A3412', 26),
  -- Class 12 Science Electives & Additional
  ('bseb-12-sci-phy',       '117',         12, 'Science',  'ELECTIVE',   'Physics',                           'भौतिकी',                              'Atom',         '#1E3A8A', 30),
  ('bseb-12-sci-chem',      '118',         12, 'Science',  'ELECTIVE',   'Chemistry',                         'रसायन विज्ञान',                       'FlaskConical', '#059669', 31),
  ('bseb-12-sci-math',      '121',         12, 'Science',  'ELECTIVE',   'Mathematics',                       'गणित',                                'Calculator',   '#2563EB', 32),
  ('bseb-12-sci-bio',       '119',         12, 'Science',  'ELECTIVE',   'Biology',                           'जीव विज्ञान',                         'Dna',          '#15803D', 33),
  ('bseb-12-sci-agri',      '120',         12, 'Science',  'ELECTIVE',   'Agriculture',                       'कृषि विज्ञान',                        'Sprout',       '#65A30D', 34),
  ('bseb-12-sci-add-math',  '121',         12, 'Science',  'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 40),
  ('bseb-12-sci-add-bio',   '119',         12, 'Science',  'ADDITIONAL', 'Biology (Additional)',              'जीव विज्ञान (अतिरिक्त)',              'Dna',          '#166534', 41),
  ('bseb-12-sci-add-cs',    '122',         12, 'Science',  'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 42),
  -- Class 12 Arts Electives & Additional
  ('bseb-12-arts-hist',     '321',         12, 'Arts',     'ELECTIVE',   'History',                           'इतिहास',                              'Landmark',     '#B45309', 30),
  ('bseb-12-arts-pol',      '322',         12, 'Arts',     'ELECTIVE',   'Political Science',                 'राजनीति विज्ञान',                     'Scale',        '#1E3A8A', 31),
  ('bseb-12-arts-geo',      '323',         12, 'Arts',     'ELECTIVE',   'Geography',                         'भूगोल',                               'Globe',        '#047857', 32),
  ('bseb-12-arts-eco',      '326',         12, 'Arts',     'ELECTIVE',   'Economics',                         'अर्थशास्त्र',                         'TrendingUp',   '#0F766E', 33),
  ('bseb-12-arts-psy',      '324',         12, 'Arts',     'ELECTIVE',   'Psychology',                        'मनोविज्ञान',                          'Brain',        '#7C3AED', 34),
  ('bseb-12-arts-soc',      '325',         12, 'Arts',     'ELECTIVE',   'Sociology',                         'समाजशास्त्र',                         'Users',        '#0369A1', 35),
  ('bseb-12-arts-phil',     '320',         12, 'Arts',     'ELECTIVE',   'Philosophy',                        'दर्शनशास्त्र',                        'Compass',      '#475569', 36),
  ('bseb-12-arts-hsci',     '319',         12, 'Arts',     'ELECTIVE',   'Home Science',                      'गृह विज्ञान',                         'Home',         '#BE185D', 37),
  ('bseb-12-arts-mus',      '318',         12, 'Arts',     'ELECTIVE',   'Music',                             'संगीत',                               'Music',        '#9333EA', 38),
  ('bseb-12-arts-add-cs',   '328',         12, 'Arts',     'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 40),
  ('bseb-12-arts-add-math', '327',         12, 'Arts',     'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 41),
  -- Class 12 Commerce Electives & Additional
  ('bseb-12-com-acc',       '220',         12, 'Commerce', 'ELECTIVE',   'Accountancy',                       'लेखाशास्त्र',                         'FileSpreadsheet', '#1E3A8A', 30),
  ('bseb-12-com-bst',       '217',         12, 'Commerce', 'ELECTIVE',   'Business Studies',                  'व्यावसायिक अध्ययन',                   'Briefcase',    '#0369A1', 31),
  ('bseb-12-com-eps',       '218',         12, 'Commerce', 'ELECTIVE',   'Entrepreneurship',                  'उद्यमिता',                            'Lightbulb',    '#D97706', 32),
  ('bseb-12-com-eco',       '219',         12, 'Commerce', 'ELECTIVE',   'Economics',                         'अर्थशास्त्र',                         'TrendingUp',   '#047857', 33),
  ('bseb-12-com-add-cs',    '221',         12, 'Commerce', 'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 40),
  ('bseb-12-com-add-math',  '222',         12, 'Commerce', 'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 41)
ON CONFLICT (id) DO UPDATE SET
  bseb_code    = EXCLUDED.bseb_code,
  class_num    = EXCLUDED.class_num,
  stream       = EXCLUDED.stream,
  category     = EXCLUDED.category,
  name_en      = EXCLUDED.name_en,
  name_hi      = EXCLUDED.name_hi,
  icon_name    = EXCLUDED.icon_name,
  accent_color = EXCLUDED.accent_color,
  sort_order   = EXCLUDED.sort_order;

-- -----------------------------------------------------------------------------
-- 2. OFFICIAL BSEB CHAPTERS CATALOG (Class 9, 10, 11, 12 Flagship Subjects)
-- -----------------------------------------------------------------------------

INSERT INTO public.chapters (
  id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published
) VALUES
  -- ==================== CLASS 9 SCIENCE ====================
  ('bseb-9-sci-ch1',  'bseb-9-sci', 1,  'Matter in Our Surroundings',          'हमारे आस-पास के पदार्थ',           'States of matter, particles, evaporation, and latent heat.', 'पदार्थ की अवस्थाएँ, कणों के गुण, वाष्पीकरण और गुप्त ऊष्मा।', 7, 18, true),
  ('bseb-9-sci-ch2',  'bseb-9-sci', 2,  'Is Matter Around Us Pure?',           'क्या हमारे आस-पास के पदार्थ शुद्ध हैं?', 'Mixtures, solutions, suspensions, colloids, and separation methods.', 'मिश्रण, विलयन, निलंबन, कोलाइड तथा पृथक्करण विधियाँ।', 7, 16, true),
  ('bseb-9-sci-ch3',  'bseb-9-sci', 3,  'Atoms and Molecules',                 'परमाणु एवं अणु',                    'Laws of chemical combination, Dalton atomic theory, and mole concept.', 'रासायनिक संयोजन के नियम, डाल्टन का सिद्धांत और मोल अवधारणा।', 8, 20, true),
  ('bseb-9-sci-ch4',  'bseb-9-sci', 4,  'Structure of the Atom',               'परमाणु की संरचना',                  'Electrons, protons, neutrons, Bohr model, valency, and isotopes.', 'इलेक्ट्रॉन, प्रोटॉन, न्यूट्रॉन, बोर मॉडल, संयोजकता और समस्थानिक।', 7, 18, true),
  ('bseb-9-sci-ch5',  'bseb-9-sci', 5,  'The Fundamental Unit of Life',        'जीवन की मौलिक इकाई',                'Cell structure, plasma membrane, nucleus, and cell organelles.', 'कोशिका की संरचना, प्लाज्मा झिल्ली, केन्द्रक और कोशिकांग।', 7, 16, true),
  ('bseb-9-sci-ch6',  'bseb-9-sci', 6,  'Tissues',                             'ऊतक',                               'Plant and animal tissues with diagrams and functions.', 'पादप एवं जन्तु ऊतकों की संरचना और कार्य।', 6, 15, true),
  ('bseb-9-sci-ch7',  'bseb-9-sci', 7,  'Motion',                              'गति',                               'Distance vs displacement, velocity, acceleration, graphs, and three equations of motion.', 'दूरी और विस्थापन, वेग, त्वरण, ग्राफ तथा गति के तीनों समीकरण।', 9, 22, true),
  ('bseb-9-sci-ch8',  'bseb-9-sci', 8,  'Force and Laws of Motion',            'बल तथा गति के नियम',                'Newton three laws of motion, inertia, and conservation of momentum.', 'न्यूटन के गति के तीन नियम, जड़त्व और संवेग संरक्षण।', 8, 20, true),
  ('bseb-9-sci-ch9',  'bseb-9-sci', 9,  'Gravitation',                         'गुरुत्वाकर्षण',                     'Universal law of gravitation, free fall, mass, weight, and buoyancy.', 'सार्वत्रिक गुरुत्वाकर्षण नियम, मुक्त पतन, द्रव्यमान, भार और उत्प्लावकता।', 7, 18, true),
  ('bseb-9-sci-ch10', 'bseb-9-sci', 10, 'Work and Energy',                     'कार्य तथा ऊर्जा',                   'Scientific work, kinetic & potential energy, power, and energy conservation.', 'कार्य, गतिज व स्थितिज ऊर्जा, शक्ति और ऊर्जा संरक्षण।', 7, 16, true),
  ('bseb-9-sci-ch11', 'bseb-9-sci', 11, 'Sound',                               'ध्वनि',                             'Sound waves, frequency, echo, ultrasound, and human ear.', 'ध्वनि तरंगें, आवृत्ति, प्रतिध्वनि, पराध्वनि और मानव कर्ण।', 6, 15, true),
  ('bseb-9-sci-ch12', 'bseb-9-sci', 12, 'Improvement in Food Resources',       'खाद्य संसाधनों में सुधार',           'Crop production, irrigation, fertilizers, and animal husbandry.', 'फसल उत्पादन, सिंचाई, खाद-उर्वरक और पशुपालन।', 5, 14, true),

  -- ==================== CLASS 9 MATHEMATICS ====================
  ('bseb-9-math-ch1', 'bseb-9-math', 1, 'Number Systems',                      'संख्या पद्धति',                     'Rational, irrational numbers, laws of exponents for real numbers.', 'परिमेय, अपरिमेय संख्याएँ तथा वास्तविक संख्याओं के घातांक नियम।', 10, 18, true),
  ('bseb-9-math-ch2', 'bseb-9-math', 2, 'Polynomials',                         'बहुपद',                             'Degree, zeroes, remainder theorem, factorisation, and algebraic identities.', 'बहुपद की घात, शून्यक, गुणनखंड और बीजीय सर्वसमिकाएँ।', 12, 20, true),
  ('bseb-9-math-ch3', 'bseb-9-math', 3, 'Coordinate Geometry',                 'निर्देशांक ज्यामिति',               'Cartesian plane, quadrants, abscissa, and ordinate.', 'कार्तीय तल, चतुर्थांश, भुज और कोटि।', 6, 14, true),
  ('bseb-9-math-ch4', 'bseb-9-math', 4, 'Linear Equations in Two Variables',   'दो चरों वाले रैखिक समीकरण',         'Standard form ax + by + c = 0 and graph plotting.', 'मानक रूप ax + by + c = 0 और आलेख निर्माण।', 8, 16, true),
  ('bseb-9-math-ch6', 'bseb-9-math', 6, 'Lines and Angles',                    'रेखाएँ और कोण',                     'Parallel lines, transversal angles, and angle sum property of triangles.', 'समांतर रेखाएँ, तिर्यक रेखा के कोण और त्रिभुज कोण योग।', 8, 16, true),
  ('bseb-9-math-ch7', 'bseb-9-math', 7, 'Triangles',                           'त्रिभुज',                           'Congruence rules (SAS, ASA, SSS, RHS) and properties.', 'सर्वांगसमता के नियम (SAS, ASA, SSS, RHS) और प्रमेय।', 10, 18, true),
  ('bseb-9-math-ch12','bseb-9-math', 12,'Heron''s Formula',                    'हीरोन का सूत्र',                    'Area of triangles using semi-perimeter s and Heron formula.', 'अर्धपरिमाप s और हीरोन के सूत्र से त्रिभुज का क्षेत्रफल।', 8, 15, true),

  -- ==================== CLASS 10 SCIENCE (AUTHENTIC BSEB 16-CHAPTER SYLLABUS) ====================
  ('bseb-10-sci-ch1',  'bseb-10-sci', 1,  'Chemical Reactions and Equations',     'रासायनिक अभिक्रियाएँ एवं समीकरण',    'Balancing equations, combination, decomposition, displacement, and redox.', 'समीकरण संतुलन, संयोजन, वियोजन, विस्थापन और उपचयन-अपचयन।', 6, 18, true),
  ('bseb-10-sci-ch2',  'bseb-10-sci', 2,  'Acids, Bases and Salts',               'अम्ल, क्षारक एवं लवण',                'pH scale, indicators, bleaching powder, baking soda, and Plaster of Paris.', 'pH स्केल, सूचक, विरंजक चूर्ण, बेकिंग सोडा और प्लास्टर ऑफ पेरिस।', 7, 18, true),
  ('bseb-10-sci-ch3',  'bseb-10-sci', 3,  'Metals and Non-metals',                'धातु एवं अधातु',                      'Reactivity series, ionic compounds, extraction of metals, and corrosion.', 'सक्रियता श्रेणी, आयनिक यौगिक, धातु निष्कर्षण और संक्षारण।', 7, 18, true),
  ('bseb-10-sci-ch4',  'bseb-10-sci', 4,  'Carbon and its Compounds',             'कार्बन एवं उसके यौगिक',               'Covalent bonding, homologous series, IUPAC naming, ethanol, and soaps.', 'सहसंयोजी आबंध, समजातीय श्रेणी, नामकरण, एथेनॉल और साबुन।', 8, 22, true),
  ('bseb-10-sci-ch5',  'bseb-10-sci', 5,  'Periodic Classification of Elements',  'तत्वों का आवर्त वर्गीकरण',            'Dobereiner triads, Mendeleev and Modern Periodic Table trends.', 'डॉबेराइनर त्रिक, मेंडेलीफ और आधुनिक आवर्त सारणी की प्रवृत्तियाँ।', 5, 16, true),
  ('bseb-10-sci-ch6',  'bseb-10-sci', 6,  'Life Processes',                       'जैव प्रक्रम',                         'Nutrition, photosynthesis, respiration, human heart, and nephron excretion.', 'पोषण, प्रकाश संश्लेषण, श्वसन, मानव हृदय और नेफ्रॉन उत्सर्जन।', 9, 24, true),
  ('bseb-10-sci-ch7',  'bseb-10-sci', 7,  'Control and Coordination',             'नियंत्रण एवं समन्वय',                 'Neuron, reflex arc, human brain, plant and endocrine hormones.', 'तंत्रिका कोशिका, प्रतिवर्ती चाप, मानव मस्तिष्क और हार्मोन।', 6, 18, true),
  ('bseb-10-sci-ch8',  'bseb-10-sci', 8,  'How do Organisms Reproduce?',          'जीव जनन कैसे करते हैं?',              'Asexual modes, flower pollination, human reproduction, and health.', 'अलैंगिक जनन, पुष्प परागण, मानव प्रजनन और जनन स्वास्थ्य।', 6, 18, true),
  ('bseb-10-sci-ch9',  'bseb-10-sci', 9,  'Heredity and Evolution',               'आनुवंशिकता एवं जैव विकास',            'Mendel laws of inheritance, sex determination, and speciation.', 'मेंडल के आनुवंशिकता नियम, लिंग निर्धारण और जैव विकास।', 5, 16, true),
  ('bseb-10-sci-ch10', 'bseb-10-sci', 10, 'Light — Reflection and Refraction',    'प्रकाश — परावर्तन तथा अपवर्तन',       'Spherical mirrors, ray diagrams, mirror & lens formulas, magnification, and power of lens.', 'गोलीय दर्पण, किरण आरेख, दर्पण व लेंस सूत्र, आवर्धन और लेंस की क्षमता।', 12, 25, true),
  ('bseb-10-sci-ch11', 'bseb-10-sci', 11, 'The Human Eye and the Colourful World','मानव नेत्र तथा रंगबिरंगा संसार',      'Myopia, hypermetropia, prism dispersion, rainbow, and Tyndall scattering.', 'निकट व दूर दृष्टि दोष, प्रिज्म वर्ण विक्षेपण और प्रकाश का प्रकीर्णन।', 7, 18, true),
  ('bseb-10-sci-ch12', 'bseb-10-sci', 12, 'Electricity',                          'विद्युत',                             'Ohm law, series & parallel resistance, Joule heating, and electric power.', 'ओम का नियम, श्रेणी व पार्श्वक्रम प्रतिरोध, ऊष्मीय प्रभाव और विद्युत शक्ति।', 10, 22, true),
  ('bseb-10-sci-ch13', 'bseb-10-sci', 13, 'Magnetic Effects of Electric Current', 'विद्युत धारा के चुंबकीय प्रभाव',       'Right-hand thumb rule, Fleming rules, solenoid, and domestic electric circuits.', 'दक्षिण-हस्त अंगुष्ठ नियम, फ्लेमिंग नियम, परिनालिका और घरेलू परिपथ।', 7, 18, true),
  ('bseb-10-sci-ch14', 'bseb-10-sci', 14, 'Sources of Energy',                    'ऊर्जा के स्रोत',                      'Conventional vs renewable energy, biogas, solar, and nuclear energy.', 'पारंपरिक व नवीकरणीय ऊर्जा, बायोगैस, सौर और नाभिकीय ऊर्जा।', 4, 14, true),
  ('bseb-10-sci-ch15', 'bseb-10-sci', 15, 'Our Environment',                      'हमारा पर्यावरण',                      'Ecosystem, food chains, 10% energy law, and ozone layer depletion.', 'पारितंत्र, आहार श्रृंखला, 10% ऊर्जा नियम और ओजोन परत अपक्षय।', 4, 12, true),

  -- ==================== CLASS 10 MATHEMATICS (AUTHENTIC BSEB 15 CHAPTERS) ====================
  ('bseb-10-math-ch1',  'bseb-10-math', 1,  'Real Numbers',                       'वास्तविक संख्याएँ',                   'Euclid division lemma, HCF & LCM by prime factorisation, irrationality proofs.', 'यूक्लिड विभाजन प्रमेयिका, अभाज्य गुणनखंड द्वारा HCF/LCM और अपरिमेयता सिद्ध करना।', 10, 18, true),
  ('bseb-10-math-ch2',  'bseb-10-math', 2,  'Polynomials',                        'बहुपद',                              'Zeroes of quadratic polynomials and relationship with coefficients.', 'द्विघात बहुपद के शून्यक तथा गुणांकों के बीच संबंध।', 8, 16, true),
  ('bseb-10-math-ch3',  'bseb-10-math', 3,  'Pair of Linear Equations in Two Variables', 'दो चर वाले रैखिक समीकरण युग्म', 'Graphical, substitution, elimination, and cross-multiplication methods.', 'ग्राफीय, प्रतिस्थापन, विलोपन और वज्र-गुणन विधियाँ।', 10, 20, true),
  ('bseb-10-math-ch4',  'bseb-10-math', 4,  'Quadratic Equations',                'द्विघात समीकरण',                      'Standard form, factorisation, Shridharacharya formula, discriminant & nature of roots.', 'मानक रूप, गुणनखंड विधि, श्रीधराचार्य सूत्र, विविक्तकर और मूलों की प्रकृति।', 12, 24, true),
  ('bseb-10-math-ch5',  'bseb-10-math', 5,  'Arithmetic Progressions',            'समांतर श्रेढ़ियाँ',                   'nth term an and sum of n terms Sn with word problems.', 'nवाँ पद (an) और प्रथम n पदों का योगफल (Sn)।', 8, 18, true),
  ('bseb-10-math-ch6',  'bseb-10-math', 6,  'Triangles',                          'त्रिभुज',                            'Thales theorem (BPT), similarity criteria, and Pythagoras theorem.', 'थेल्स प्रमेय, समरूपता की कसौटियाँ और पाइथागोरस प्रमेय।', 10, 22, true),
  ('bseb-10-math-ch7',  'bseb-10-math', 7,  'Coordinate Geometry',                'निर्देशांक ज्यामिति',                 'Distance formula, section formula, midpoint, and area of triangle.', 'दूरी सूत्र, विभाजन सूत्र, मध्यबिंदु और त्रिभुज का क्षेत्रफल।', 10, 18, true),
  ('bseb-10-math-ch8',  'bseb-10-math', 8,  'Introduction to Trigonometry',       'त्रिकोणमिति का परिचय',                 'Trigonometric ratios, standard angles 0°-90°, and fundamental identities.', 'त्रिकोणमितीय अनुपात, मानक कोण सारणी और सर्वसमिकाएँ।', 14, 24, true),
  ('bseb-10-math-ch9',  'bseb-10-math', 9,  'Some Applications of Trigonometry',  'त्रिकोणमिति के कुछ अनुप्रयोग',         'Heights and distances using angles of elevation and depression.', 'उन्नयन और अवनमन कोण द्वारा ऊँचाई एवं दूरी के प्रश्न।', 8, 18, true),
  ('bseb-10-math-ch10', 'bseb-10-math', 10, 'Circles',                            'वृत्त',                              'Tangent to a circle and equal tangents from an external point.', 'वृत्त की स्पर्श रेखा और बाह्य बिंदु से खींची गई स्पर्श रेखाएँ।', 6, 15, true),
  ('bseb-10-math-ch12', 'bseb-10-math', 12, 'Areas Related to Circles',           'वृत्तों से संबंधित क्षेत्रफल',         'Perimeter, area of sector and segment of a circle.', 'त्रिज्यखंड और वृत्तखंड का क्षेत्रफल।', 6, 16, true),
  ('bseb-10-math-ch13', 'bseb-10-math', 13, 'Surface Areas and Volumes',          'पृष्ठीय क्षेत्रफल और आयतन',           'Combination of solids: cylinder, cone, sphere, hemisphere, and frustum.', 'ठोस आकृतियों के संयोजन का क्षेत्रफल और आयतन।', 8, 18, true),
  ('bseb-10-math-ch14', 'bseb-10-math', 14, 'Statistics',                         'सांख्यिकी',                          'Mean, median, and mode of grouped data.', 'वर्गीकृत आँकड़ों का माध्य, माध्यक और बहुलक।', 10, 18, true),
  ('bseb-10-math-ch15', 'bseb-10-math', 15, 'Probability',                        'प्रायिकता',                          'Classical probability of coins, dice, and playing cards.', 'सिक्का, पासा और ताश के पत्तों पर आधारित प्रायिकता।', 6, 14, true),

  -- ==================== CLASS 10 SOCIAL SCIENCE (BSEB HISTORY + CIVICS + GEO + ECO) ====================
  ('bseb-10-sst-ch1', 'bseb-10-sst', 1, 'Nationalism in India & Champaran Satyagraha', 'भारत में राष्ट्रवाद एवं चम्पारण सत्याग्रह', 'Champaran 1917 indigo movement in Bihar, Non-Cooperation, Dandi March, and Quit India.', 'बिहार का चम्पारण सत्याग्रह (1917), असहयोग, सविनय अवज्ञा और भारत छोड़ो आंदोलन।', 12, 22, true),
  ('bseb-10-sst-ch2', 'bseb-10-sst', 2, 'Rise of Nationalism in Europe',               'यूरोप में राष्ट्रवाद का उदय',               'French Revolution, Mazzini, Garibaldi, unification of Italy and Germany.', 'फ्रांसीसी क्रांति, मेजिनी, गैरीबाल्डी, इटली और जर्मनी का एकीकरण।', 8, 18, true),
  ('bseb-10-sst-ch3', 'bseb-10-sst', 3, 'Resources and Bihar Geography',               'संसाधन एवं बिहार का भूगोल',                 'Soil, water, agriculture, river valley projects, and Bihar minerals.', 'मृदा, जल, कृषि, नदी घाटी परियोजनाएँ और बिहार के संसाधन।', 10, 18, true),
  ('bseb-10-sst-ch4', 'bseb-10-sst', 4, 'Power Sharing & Panchayati Raj in Bihar',     'सत्ता में साझेदारी और बिहार में पंचायती राज', 'Federalism, Gram Panchayat, Nagar Nigam, and democratic decentralization.', 'संघवाद, ग्राम पंचायत, नगर निगम और लोकतांत्रिक विकेंद्रीकरण।', 8, 16, true),
  ('bseb-10-sst-ch5', 'bseb-10-sst', 5, 'Economy and Bihar Development',               'अर्थव्यवस्था और बिहार के विकास का इतिहास',  'Primary/Secondary/Tertiary sectors, GDP, banking, and self-help groups.', 'प्राथमिक-द्वितीयक-तृतीयक क्षेत्र, सकल घरेलू उत्पाद, बैंकिंग और स्वयं सहायता समूह।', 8, 16, true),

  -- ==================== CLASS 10 ENGLISH & HINDI MIL ====================
  ('bseb-10-eng-ch1',    'bseb-10-eng',    1, 'The Pace for Living',               'द पेस फॉर लिविंग (आधुनिक जीवन की गति)',    'R.C. Hutchinson essay on modern fast-paced life and human adaptability.', 'आधुनिक तेज़ रफ़्तार जीवन पर आर.सी. हचिंसन का निबंध।', 8, 14, true),
  ('bseb-10-eng-ch2',    'bseb-10-eng',    2, 'Me and the Ecology Bit',            'मैं और पारिस्थितिकी',                       'Environmental responsibility and everyday conservation habits.', 'पर्यावरण संरक्षण और दैनिक आदतों की जिम्मेदारी।', 7, 14, true),
  ('bseb-10-mil-hi-ch1', 'bseb-10-mil-hi', 1, 'Shram Vibhajan aur Jati Pratha',    'श्रम विभाजन और जाति प्रथा',                 'Dr. B.R. Ambedkar essay on social equality and ideal democratic society.', 'डॉ. भीमराव अंबेडकर का निबंध — सामाजिक समता और आदर्श लोकतांत्रिक समाज।', 10, 16, true),
  ('bseb-10-mil-hi-ch2', 'bseb-10-mil-hi', 2, 'Vish ke Daant',                     'विष के दाँत',                               'Nalin Vilochan Sharma story highlighting class contrast in Bihar society.', 'नलिन विलोचन शर्मा की कहानी — सामाजिक असमानता का यथार्थ चित्रण।', 8, 15, true),

  -- ==================== CLASS 11 SCIENCE (PHYSICS & MATH) ====================
  ('bseb-11-sci-phy-ch1',  'bseb-11-sci-phy',  1, 'Units and Measurements',        'मात्रक और मापन',                            'SI units, dimensional analysis, and significant figures.', 'SI मात्रक, विमीय विश्लेषण और सार्थक अंक।', 8, 18, true),
  ('bseb-11-sci-phy-ch2',  'bseb-11-sci-phy',  2, 'Motion in a Straight Line',     'सरल रेखा में गति',                          'Instantaneous velocity, calculus-based kinematic equations, and graphs.', 'तात्क्षणिक वेग, कलन द्वारा गति समीकरण और ग्राफ।', 10, 20, true),
  ('bseb-11-sci-phy-ch3',  'bseb-11-sci-phy',  3, 'Laws of Motion',                'गति के नियम',                               'Free body diagrams, friction, banking of roads, and impulse.', 'मुक्त पिंड आरेख, घर्षण, सड़कों का बंकन और आवेग।', 10, 20, true),
  ('bseb-11-sci-math-ch1', 'bseb-11-sci-math', 1, 'Sets',                          'समुच्चय',                                   'Roster & set-builder form, Venn diagrams, union, intersection, and De Morgan laws.', 'रोस्टर व समुच्चय निर्माण रूप, वेन आरेख और संक्रियाएँ।', 8, 16, true),
  ('bseb-11-sci-math-ch3', 'bseb-11-sci-math', 3, 'Trigonometric Functions',       'त्रिकोणमितीय फलन',                          'Radians, compound angle formulas, and trigonometric equations.', 'रेडियन माप, संयुक्त कोण सूत्र और त्रिकोणमितीय समीकरण।', 12, 22, true),

  -- ==================== CLASS 12 SCIENCE (PHYSICS, CHEMISTRY, MATH) ====================
  ('bseb-12-sci-phy-ch1',  'bseb-12-sci-phy',  1, 'Electric Charges and Fields',         'वैद्युत आवेश तथा क्षेत्र',            'Quantisation, Coulomb law, electric field lines, dipole, and Gauss theorem.', 'आवेश का क्वांटमीकरण, कूलॉम नियम, विद्युत क्षेत्र, द्विध्रुव और गॉस प्रमेय।', 12, 26, true),
  ('bseb-12-sci-phy-ch2',  'bseb-12-sci-phy',  2, 'Electrostatic Potential and Capacitance', 'स्थिरवैद्युत विभव तथा धारिता',    'Electric potential, equipotential surfaces, parallel plate capacitor & dielectrics.', 'विद्युत विभव, समविभव पृष्ठ, समांतर पट्टिका संधारित्र और परावैद्युत।', 10, 22, true),
  ('bseb-12-sci-phy-ch3',  'bseb-12-sci-phy',  3, 'Current Electricity',                 'विद्युत धारा',                        'Drift velocity, Kirchhoff laws, Wheatstone bridge, and potentiometer.', 'अपवाह वेग, किरचॉफ के नियम, व्हीटस्टोन सेतु और विभवमापी।', 10, 22, true),
  ('bseb-12-sci-phy-ch9',  'bseb-12-sci-phy',  9, 'Ray Optics and Optical Instruments',  'किरण प्रकाशिकी एवं प्रकाशिक यंत्र',    'Total internal reflection, lens maker formula, microscope, and telescope.', 'पूर्ण आंतरिक परावर्तन, लेंस निर्माता सूत्र, सूक्ष्मदर्शी और दूरदर्शी।', 14, 26, true),
  ('bseb-12-sci-phy-ch14', 'bseb-12-sci-phy',  14,'Semiconductor Electronics',           'अर्धचालक इलेक्ट्रॉनिकी',              'p-n junction diode, rectifiers, LED, and logic gates (AND, OR, NOT, NAND, NOR).', 'p-n संधि डायोड, दिष्टकारी और लॉजिक गेट।', 8, 20, true),
  ('bseb-12-sci-chem-ch1', 'bseb-12-sci-chem', 1, 'Solutions',                           'विलयन',                               'Molarity, molality, Raoult law, and colligative properties.', 'मोलरता, मोललता, राउल्ट का नियम और अणुसंख्य गुणधर्म।', 8, 20, true),
  ('bseb-12-sci-chem-ch2', 'bseb-12-sci-chem', 2, 'Electrochemistry',                    'वैद्युतरसायन',                         'Galvanic cell, Nernst equation, Kohlrausch law, and Faraday electrolysis.', 'गैल्वैनी सेल, नर्न्स्ट समीकरण, कोलराउश नियम और फैराडे नियम।', 9, 20, true),
  ('bseb-12-sci-math-ch3', 'bseb-12-sci-math', 3, 'Matrices',                            'आव्यूह',                              'Matrix algebra, transpose, symmetric & skew-symmetric matrices.', 'आव्यूह संक्रियाएँ, परिवर्त, सममित व विषम सममित आव्यूह।', 10, 20, true),
  ('bseb-12-sci-math-ch5', 'bseb-12-sci-math', 5, 'Continuity and Differentiability',    'सांतत्य तथा अवकलनीयता',               'Chain rule, logarithmic differentiation, and parametric derivatives.', 'शृंखला नियम, लघुगणकीय और प्राचलिक अवकलन।', 14, 24, true),
  ('bseb-12-sci-math-ch7', 'bseb-12-sci-math', 7, 'Integrals',                           'समाकलन',                              'Indefinite & definite integrals, substitution, parts, and properties.', 'अनिश्चित एवं निश्चित समाकलन और उनके गुणधर्म।', 16, 26, true),

  -- ==================== CLASS 12 ARTS (HISTORY) ====================
  ('bseb-12-arts-hist-ch1',  'bseb-12-arts-hist', 1,  'Bricks, Beads and Bones: The Harappan Civilisation', 'ईंटें, मनके तथा अस्थियाँ: हड़प्पा सभ्यता', 'Town planning of Mohenjodaro, drainage, craft production, trade, and decline.', 'मोहनजोदड़ो का नगर नियोजन, जल-निकास, शिल्प, व्यापार और पतन।', 12, 22, true),
  ('bseb-12-arts-hist-ch2',  'bseb-12-arts-hist', 2,  'Kings, Farmers and Towns (Magadha & Mauryas)',       'राजा, किसान और नगर (मगध एवं मौर्य साम्राज्य)', 'Rise of Magadha in Bihar, Pataliputra, Ashoka Dhamma, and Gupta inscriptions.', 'बिहार में मगध का उत्कर्ष, पाटलिपुत्र, अशोक का धम्म और अभिलेख।', 12, 22, true),
  ('bseb-12-arts-hist-ch11', 'bseb-12-arts-hist', 11, 'Rebels and the Raj: 1857 Revolt & Veer Kunwar Singh','विद्रोही और राज: 1857 का विद्रोह एवं वीर कुँवर सिंह', 'Causes of 1857 uprising, Bihar role of Veer Kunwar Singh of Jagdishpur.', '1857 की क्रांति के कारण और बिहार के जगदीशपुर से वीर कुँवर सिंह का नेतृत्व।', 10, 20, true),

  -- ==================== CLASS 12 COMMERCE (ACCOUNTANCY) ====================
  ('bseb-12-com-acc-ch1', 'bseb-12-com-acc', 1, 'Accounting for Partnership: Basic Concepts', 'साझेदारी लेखांकन: आधारभूत अवधारणाएँ', 'Partnership deed, P&L appropriation account, and capital accounts.', 'साझेदारी संलेख, लाभ-हानि विनियोजन खाता और पूँजी खाते।', 12, 20, true),
  ('bseb-12-com-acc-ch2', 'bseb-12-com-acc', 2, 'Reconstitution of Partnership: Admission',   'साझेदारी का पुनर्गठन: नए साझेदार का प्रवेश', 'Sacrificing ratio, goodwill valuation, and revaluation account.', 'त्याग अनुपात, ख्याति का मूल्यांकन और पुनर्मूल्यांकन खाता।', 12, 22, true)
ON CONFLICT (id) DO UPDATE SET
  subject_id           = EXCLUDED.subject_id,
  chapter_no           = EXCLUDED.chapter_no,
  title_en             = EXCLUDED.title_en,
  title_hi             = EXCLUDED.title_hi,
  summary_en           = EXCLUDED.summary_en,
  summary_hi           = EXCLUDED.summary_hi,
  bseb_weightage_marks = EXCLUDED.bseb_weightage_marks,
  estimated_mins       = EXCLUDED.estimated_mins,
  is_published         = EXCLUDED.is_published;

-- #############################################################################
-- PART 3 / 3: 003_gold_curriculum_seed.sql
-- #############################################################################

-- =============================================================================
-- Students of Bihar (9-12) — Gold-Standard Visual Bilingual Curriculum Seed
-- Philosophy: QUALITY OVER QUANTITY — Zero-Compromise Academic Depth
--
-- Covers 6 flagship BSEB chapters spanning Class 9, Class 10, Class 12 Science
-- & Class 12 Arts:
--   1. Class 10 Science  Ch 10: Light — Reflection and Refraction
--   2. Class 10 Math     Ch 4 : Quadratic Equations
--   3. Class 10 SST      Ch 1 : Nationalism in India & Champaran Satyagraha
--   4. Class 9  Science  Ch 7 : Motion
--   5. Class 12 Physics  Ch 1 : Electric Charges and Fields
--   6. Class 12 History  Ch 1 : Bricks, Beads and Bones (Harappan Civilisation)
--
-- 100% Idempotent (ON CONFLICT DO UPDATE with deterministic UUIDs).
-- =============================================================================

-- #############################################################################
-- CHAPTER 1 OF 6: CLASS 10 SCIENCE CH 10 — LIGHT: REFLECTION AND REFRACTION
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-10-sci-ch10',
  $json${
    "title_hi": "30-सेकंड माइंडमैप: प्रकाश — परावर्तन तथा अपवर्तन",
    "title_en": "30-Second Mindmap: Light — Reflection and Refraction",
    "read_time_seconds": 30,
    "central_node": {
      "id": "light-root",
      "label_hi": "प्रकाश (Light)",
      "label_en": "Light",
      "subtitle_hi": "सीधी रेखा में चलती है · निर्वात में चाल c = 3 × 10⁸ m/s",
      "subtitle_en": "Travels in straight line · Speed in vacuum c = 3 × 10⁸ m/s"
    },
    "branches": [
      {
        "id": "b-reflection",
        "label_hi": "1. परावर्तन (Reflection)",
        "label_en": "1. Reflection",
        "color": "#1E3A8A",
        "children": [
          {
            "id": "b-ref-laws",
            "label_hi": "नियम: ∠i = ∠r",
            "label_en": "Law: ∠i = ∠r",
            "detail_hi": "आपतित किरण, परावर्तित किरण और अभिलंब एक ही तल में होते हैं।",
            "detail_en": "Incident ray, reflected ray, and normal lie in the same plane."
          },
          {
            "id": "b-ref-concave",
            "label_hi": "अवतल दर्पण (Concave)",
            "label_en": "Concave Mirror",
            "detail_hi": "किरणों को मिलाता है (अभिसारी) — टॉर्च, गाड़ी की हेडलाइट, दंत चिकित्सक।",
            "detail_en": "Converging mirror — torch, headlight, dentist mirror."
          },
          {
            "id": "b-ref-convex",
            "label_hi": "उत्तल दर्पण (Convex)",
            "label_en": "Convex Mirror",
            "detail_hi": "हमेशा सीधा व छोटा प्रतिबिंब — मोटरसाइकिल/कार का साइड मिरर।",
            "detail_en": "Always erect & diminished image — bike/car rear-view mirror."
          }
        ]
      },
      {
        "id": "b-mirror-formula",
        "label_hi": "2. दर्पण सूत्र व आवर्धन",
        "label_en": "2. Mirror Formula & Magnification",
        "color": "#059669",
        "formula_latex": "\\frac{1}{v} + \\frac{1}{u} = \\frac{1}{f},\\quad m = -\\frac{v}{u}",
        "children": [
          {
            "id": "b-f-r",
            "label_hi": "फोकस दूरी: f = R / 2",
            "label_en": "Focal length: f = R / 2"
          },
          {
            "id": "b-sign",
            "label_hi": "चिह्न परिपाटी: u हमेशा ऋणात्मक (−)",
            "label_en": "Sign convention: u is always negative (−)"
          }
        ]
      },
      {
        "id": "b-refraction",
        "label_hi": "3. अपवर्तन (Refraction)",
        "label_en": "3. Refraction",
        "color": "#D97706",
        "formula_latex": "\\frac{\\sin i}{\\sin r} = n_{21} = \\frac{v_1}{v_2}",
        "children": [
          {
            "id": "b-rare-dense",
            "label_hi": "विरल → सघन: अभिलंब की ओर मुड़ती है",
            "label_en": "Rarer → Denser: bends towards normal"
          },
          {
            "id": "b-dense-rare",
            "label_hi": "सघन → विरल: अभिलंब से दूर हटती है",
            "label_en": "Denser → Rarer: bends away from normal"
          }
        ]
      },
      {
        "id": "b-lens",
        "label_hi": "4. लेंस व क्षमता (Power)",
        "label_en": "4. Lens & Power (Dioptre)",
        "color": "#7C3AED",
        "formula_latex": "\\frac{1}{v} - \\frac{1}{u} = \\frac{1}{f},\\quad P = \\frac{1}{f(\\text{m})}",
        "children": [
          {
            "id": "b-lens-conv",
            "label_hi": "उत्तल लेंस: +f, +P (अभिसारी)",
            "label_en": "Convex lens: +f, +P (Converging)"
          },
          {
            "id": "b-lens-conc",
            "label_hi": "अवतल लेंस: −f, −P (अपसारी)",
            "label_en": "Concave lens: −f, −P (Diverging)"
          }
        ]
      }
    ]
  }$json$::jsonb,
  $json$[
    {
      "id": "sec-1-spoon-mirrors",
      "order": 1,
      "heading_hi": "1. गोलीय दर्पण को स्टील के चम्मच से समझें",
      "heading_en": "1. Understand Spherical Mirrors with a Steel Spoon",
      "analogy_hi": "अपने घर का एक चमकता हुआ नया स्टील का चम्मच उठाइए। चम्मच का अंदर की ओर धँसा हुआ चमकदार भाग **अवतल दर्पण (Concave Mirror)** है — इसमें पास से देखने पर आपका चेहरा बड़ा दिखता है। चम्मच का बाहर की ओर उभरा हुआ पिछला भाग **उत्तल दर्पण (Convex Mirror)** है — इसमें आपका चेहरा छोटा पर पूरा कमरा एक साथ दिखता है!",
      "analogy_en": "Pick up a shiny steel spoon from your kitchen. The inward-curved hollow side is a **Concave Mirror** — bring it close and your face looks bigger. The outward-bulging back side is a **Convex Mirror** — your face looks smaller, yet you can see the whole room behind you!",
      "visual_diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "अवतल दर्पण द्वारा प्रतिबिंब निर्माण (जब वस्तु C के परे हो)",
        "title_en": "Image Formation by a Concave Mirror (Object beyond C)",
        "caption_hi": "किरण 1 मुख्य अक्ष के समांतर चलकर फोकस (F) से गुजरती है। किरण 2 वक्रता केंद्र (C) से जाकर उसी पथ पर लौटती है। दोनों के कटान बिंदु पर वास्तविक, उल्टा और छोटा प्रतिबिंब A'B' बनता है।",
        "caption_en": "Ray 1 travels parallel to the principal axis and reflects through Focus (F). Ray 2 passes through Centre of Curvature (C) and retraces its path. Where they meet, a real, inverted, diminished image A'B' forms between F and C.",
        "viewBox": "0 0 640 280",
        "elements": [
          { "kind": "line", "x1": 30, "y1": 160, "x2": 590, "y2": 160, "stroke": "#64748B", "strokeWidth": 1.5, "dashed": true },
          { "kind": "path", "d": "M 510 50 Q 560 160 510 270", "fill": "none", "stroke": "#1E3A8A", "strokeWidth": 4 },
          { "kind": "line", "x1": 524, "y1": 65, "x2": 536, "y2": 58, "stroke": "#94A3B8", "strokeWidth": 1.5 },
          { "kind": "line", "x1": 536, "y1": 115, "x2": 548, "y2": 108, "stroke": "#94A3B8", "strokeWidth": 1.5 },
          { "kind": "line", "x1": 540, "y1": 160, "x2": 554, "y2": 154, "stroke": "#94A3B8", "strokeWidth": 1.5 },
          { "kind": "line", "x1": 536, "y1": 205, "x2": 548, "y2": 200, "stroke": "#94A3B8", "strokeWidth": 1.5 },
          { "kind": "line", "x1": 524, "y1": 250, "x2": 536, "y2": 244, "stroke": "#94A3B8", "strokeWidth": 1.5 },
          { "kind": "circle", "cx": 535, "cy": 160, "r": 4, "fill": "#1E3A8A" },
          { "kind": "circle", "cx": 415, "cy": 160, "r": 4, "fill": "#D97706" },
          { "kind": "circle", "cx": 295, "cy": 160, "r": 4, "fill": "#059669" },
          { "kind": "arrow", "x1": 160, "y1": 160, "x2": 160, "y2": 80, "stroke": "#0F172A", "strokeWidth": 3 },
          { "kind": "arrow", "x1": 160, "y1": 80, "x2": 522, "y2": 80, "stroke": "#2563EB", "strokeWidth": 2.2 },
          { "kind": "arrow", "x1": 522, "y1": 80, "x2": 325, "y2": 227, "stroke": "#2563EB", "strokeWidth": 2.2 },
          { "kind": "arrow", "x1": 160, "y1": 80, "x2": 518, "y2": 248, "stroke": "#059669", "strokeWidth": 2 },
          { "kind": "arrow", "x1": 368, "y1": 160, "x2": 368, "y2": 195, "stroke": "#DC2626", "strokeWidth": 3 },
          { "kind": "label", "x": 160, "y": 68, "text_hi": "वस्तु (AB)", "text_en": "Object (AB)", "fill": "#0F172A", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 295, "y": 146, "text_hi": "C (वक्रता केंद्र)", "text_en": "C (Centre)", "fill": "#059669", "fontSize": 12, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 415, "y": 146, "text_hi": "F (फोकस)", "text_en": "F (Focus)", "fill": "#D97706", "fontSize": 12, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 552, "y": 178, "text_hi": "P (ध्रुव)", "text_en": "P (Pole)", "fill": "#1E3A8A", "fontSize": 12, "anchor": "start", "bold": true },
          { "kind": "label", "x": 368, "y": 216, "text_hi": "प्रतिबिंब (A'B')", "text_en": "Image (A'B')", "fill": "#DC2626", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 515, "y": 36, "text_hi": "अवतल दर्पण", "text_en": "Concave Mirror", "fill": "#1E3A8A", "fontSize": 13, "anchor": "middle", "bold": true }
        ]
      },
      "concept_md_hi": "### गोलीय दर्पण के 4 सबसे ज़रूरी शब्द (हर साल बोर्ड में आते हैं)\n1. **ध्रुव (Pole, $P$):** दर्पण के परावर्तक पृष्ठ के बिल्कुल बीच का बिंदु।\n2. **वक्रता केंद्र (Centre of Curvature, $C$):** दर्पण जिस काँच के खोखले गोले का हिस्सा है, उसका केंद्र।\n3. **मुख्य फोकस (Principal Focus, $F$):** मुख्य अक्ष के समांतर आने वाली किरणें परावर्तन के बाद जिस बिंदु पर मिलती हैं (अवतल) या मिलती हुई प्रतीत होती हैं (उत्तल)।\n4. **फोकस दूरी ($f$) और वक्रता त्रिज्या ($R$) का संबंध:**\n$$f = \\frac{R}{2} \\quad \\text{अर्थात्} \\quad R = 2f$$\n\n**ध्यान दें:** परावर्तन के दोनों नियम ($\\angle i = \\angle r$ तथा एक ही तल का नियम) **सभी प्रकार के दर्पणों** (समतल, अवतल, उत्तल) पर लागू होते हैं।",
      "concept_md_en": "### 4 Must-Know Terms of a Spherical Mirror\n1. **Pole ($P$):** The exact geometric centre of the reflecting surface of the mirror.\n2. **Centre of Curvature ($C$):** The centre of the hollow glass sphere of which the mirror is a part.\n3. **Principal Focus ($F$):** The point on the principal axis where parallel rays actually meet after reflection (concave) or appear to diverge from (convex).\n4. **Relation between Focal Length ($f$) and Radius of Curvature ($R$):**\n$$f = \\frac{R}{2} \\quad \\text{or} \\quad R = 2f$$\n\n**Remember:** Both laws of reflection ($\\angle i = \\angle r$, and coplanarity) hold true for **all mirrors** — plane, concave, and convex.",
      "exam_tip_hi": "BSEB ट्रिक: यदि सवाल में $R = 32\\text{ cm}$ दिया हो, तो तुरंत 2 से भाग दें: $f = 32 / 2 = 16\\text{ cm}$। अवतल हो तो $-16\\text{ cm}$, उत्तल हो तो $+16\\text{ cm}$ लिखें!",
      "exam_tip_en": "BSEB Shortcut: If $R = 32\\text{ cm}$, divide by 2 immediately to get $f = 16\\text{ cm}$. Put minus ($-16\\text{ cm}$) for concave and plus ($+16\\text{ cm}$) for convex!",
      "glossary_terms": [
        {
          "term_hi": "वास्तविक प्रतिबिंब (Real Image)",
          "term_en": "Real Image",
          "definition_hi": "जिसे पर्दे पर प्राप्त किया जा सकता है। यह हमेशा उल्टा (Inverted) होता है।",
          "definition_en": "Can be caught on a screen because light rays actually meet; always inverted."
        },
        {
          "term_hi": "आभासी प्रतिबिंब (Virtual Image)",
          "term_en": "Virtual Image",
          "definition_hi": "जिसे पर्दे पर नहीं प्राप्त किया जा सकता (जैसे घर के आईने में)। यह हमेशा सीधा (Erect) होता है।",
          "definition_en": "Cannot be caught on a screen (like a bathroom mirror); always upright/erect."
        }
      ],
      "quick_check": {
        "q_hi": "यदि किसी गोलीय दर्पण की वक्रता त्रिज्या $20\\text{ cm}$ है, तो इसकी फोकस दूरी क्या होगी?",
        "q_en": "If the radius of curvature of a spherical mirror is $20\\text{ cm}$, what is its focal length?",
        "answer_hi": "$f = R/2 = 20/2 = 10\\text{ cm}$।",
        "answer_en": "$f = R/2 = 20/2 = 10\\text{ cm}$."
      }
    },
    {
      "id": "sec-2-six-cases-table",
      "order": 2,
      "heading_hi": "2. अवतल दर्पण की सभी 6 स्थितियाँ — एक नज़र में याद करें",
      "heading_en": "2. All 6 Image Cases of Concave Mirror — Master in 1 Table",
      "analogy_hi": "इसे एक झूले (See-Saw) की तरह याद करें: जैसे-जैसे वस्तु दूर से दर्पण के पास आती है, प्रतिबिंब दर्पण के पास ($F$) से दूर भागता है और **बड़ा होता जाता है**! केवल आख़िरी स्थिति ($P$ और $F$ के बीच) में जादू होता है — प्रतिबिंब सीधा और आभासी बन जाता है (इसीलिए दाढ़ी बनाने और दाँत देखने में यही काम आता है)।",
      "analogy_en": "Think of a see-saw: as the object walks closer to the mirror, the image moves farther away from $F$ and **grows larger**! Only in the final case (object between $P$ and $F$) does it flip into an erect, magnified virtual image — that is why shaving mirrors and dentists use it!",
      "visual_diagram": {
        "type": "COMPARISON_TABLE",
        "title_hi": "अवतल दर्पण द्वारा प्रतिबिंब की 6 स्थितियाँ (BSEB मोस्ट इम्पोर्टेन्ट)",
        "title_en": "All 6 Cases of Image Formation by a Concave Mirror (High-Yield BSEB)",
        "headers_hi": ["वस्तु की स्थिति", "प्रतिबिंब की स्थिति", "आकार (Size)", "प्रकृति (Nature)"],
        "headers_en": ["Object Position", "Image Position", "Size", "Nature"],
        "rows": [
          {
            "cells_hi": ["1. अनंत पर (At ∞)", "फोकस F पर", "अत्यधिक छोटा (बिंदुवत)", "वास्तविक और उल्टा"],
            "cells_en": ["1. At infinity (∞)", "At focus F", "Highly diminished (point)", "Real and inverted"]
          },
          {
            "cells_hi": ["2. C से परे (Beyond C)", "F और C के बीच", "छोटा (Diminished)", "वास्तविक और उल्टा"],
            "cells_en": ["2. Beyond C", "Between F and C", "Diminished", "Real and inverted"]
          },
          {
            "cells_hi": ["3. C पर (At C)", "C पर ही", "समान आकार (Same size)", "वास्तविक और उल्टा"],
            "cells_en": ["3. At C", "At C", "Same size as object", "Real and inverted"]
          },
          {
            "cells_hi": ["4. C और F के बीच", "C से परे (Beyond C)", "बड़ा (Enlarged)", "वास्तविक और उल्टा"],
            "cells_en": ["4. Between C and F", "Beyond C", "Enlarged", "Real and inverted"]
          },
          {
            "cells_hi": ["5. फोकस F पर (At F)", "अनंत पर (At ∞)", "अत्यधिक बड़ा", "वास्तविक और उल्टा"],
            "cells_en": ["5. At focus F", "At infinity (∞)", "Highly enlarged", "Real and inverted"]
          },
          {
            "cells_hi": ["6. P और F के बीच (विशेष!)", "दर्पण के पीछे", "बड़ा (Magnified)", "आभासी और सीधा"],
            "cells_en": ["6. Between P and F (Special!)", "Behind the mirror", "Magnified", "Virtual and erect"]
          }
        ]
      },
      "concept_md_hi": "### नई कार्तीय चिह्न परिपाटी (Sign Convention) — न्यूमेरिकल में गलती कभी नहीं होगी!\nदर्पण के ध्रुव $P$ को ग्राफ़ का मूलबिंदु $(0,0)$ मान लें और वस्तु को हमेशा **बाईं ओर** रखें:\n- वस्तु की दूरी $u$: **हमेशा ऋणात्मक ($-$)**।\n- अवतल दर्पण की फोकस दूरी $f$: **ऋणात्मक ($-$)** (क्योंकि फोकस बाईं ओर है)।\n- उत्तल दर्पण की फोकस दूरी $f$: **धनात्मक ($+$)** (क्योंकि फोकस दाईं ओर है)।\n- मुख्य अक्ष के ऊपर ऊँचाई: **धनात्मक ($+$)**; नीचे (उल्टा प्रतिबिंब): **ऋणात्मक ($-$)**।\n\n**आवर्धन ($m$) का अर्थ:**\n$$m = \\frac{h'}{h} = -\\frac{v}{u}$$\n- यदि $m$ **ऋणात्मक** है $\\Rightarrow$ प्रतिबिंब **वास्तविक और उल्टा** है।\n- यदि $m$ **धनात्मक** है $\\Rightarrow$ प्रतिबिंब **आभासी और सीधा** है।",
      "concept_md_en": "### New Cartesian Sign Convention — Never Miss a Numerical!\nTreat the pole $P$ as origin $(0,0)$ of a graph and always place the object on the **left**:\n- Object distance $u$: **Always negative ($-$)**.\n- Concave mirror focal length $f$: **Negative ($-$)** (focus lies on the left).\n- Convex mirror focal length $f$: **Positive ($+$)** (focus lies on the right).\n- Heights above principal axis: **Positive ($+$)**; inverted below axis: **Negative ($-$)**.\n\n**Meaning of Magnification ($m$):**\n$$m = \\frac{h'}{h} = -\\frac{v}{u}$$\n- Negative $m$ $\\Rightarrow$ **Real and inverted** image.\n- Positive $m$ $\\Rightarrow$ **Virtual and erect** image.",
      "exam_tip_hi": "बार-बार पूछा गया प्रश्न: 'उत्तल दर्पण का उपयोग मोटरगाड़ी के साइड मिरर में क्यों करते हैं?' उत्तर में 2 बातें जरूर लिखें: (1) यह हमेशा **सीधा और छोटा** प्रतिबिंब बनाता है, (2) इसका **दृष्टि-क्षेत्र (Field of View) बहुत बड़ा** होता है।",
      "exam_tip_en": "Repeated BSEB Question: 'Why is a convex mirror used as a rear-view mirror?' Always write 2 points: (1) It always forms an **erect and diminished** image, (2) It gives a **much wider field of view**.",
      "glossary_terms": [
        {
          "term_hi": "आवर्धन (Magnification, m)",
          "term_en": "Magnification (m)",
          "definition_hi": "प्रतिबिंब की ऊँचाई और वस्तु की ऊँचाई का अनुपात। इसका कोई मात्रक (Unit) नहीं होता।",
          "definition_en": "Ratio of image height to object height; it is a pure dimensionless number."
        }
      ]
    },
    {
      "id": "sec-3-refraction-lens",
      "order": 3,
      "heading_hi": "3. प्रकाश का अपवर्तन, स्नेल का नियम और लेंस की क्षमता",
      "heading_en": "3. Refraction of Light, Snell's Law & Power of a Lens",
      "analogy_hi": "सोचिए आप पानी से भरी बाल्टी में एक सिक्का डालते हैं — सिक्का ऊपर उठा हुआ दिखता है! या पानी के गिलास में पेंसिल टेढ़ी दिखती है। क्यों? क्योंकि जब साइकिल पक्की सड़क (विरल माध्यम) से अचानक कीचड़ (सघन माध्यम) में जाती है, तो उसकी रफ़्तार धीमी होकर पहिया मुड़ जाता है। ठीक वैसे ही प्रकाश एक माध्यम से दूसरे माध्यम में जाते समय **चाल बदलने के कारण मुड़ जाता है** — यही अपवर्तन है!",
      "analogy_en": "Drop a coin into a bucket of water — it looks raised! Put a pencil in a glass of water — it looks bent! Why? Just like a bicycle slows down and steers slightly when moving from a smooth road (rarer medium) into mud (denser medium), light **changes speed and bends** when crossing between transparent media — that is Refraction!",
      "visual_diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "काँच की सिल्ली (Glass Slab) से प्रकाश का अपवर्तन",
        "title_en": "Refraction of Light Through a Rectangular Glass Slab",
        "caption_hi": "हवा (विरल) से काँच (सघन) में प्रवेश करने पर किरण अभिलंब की ओर मुड़ती है (∠r < ∠i)। बाहर निकलते समय अभिलंब से दूर हटती है और आपतित किरण के समांतर निकलती है।",
        "caption_en": "Entering glass (denser) from air (rarer), light bends towards the normal (∠r < ∠i). Exiting back into air, it bends away from the normal, emerging parallel to the original ray.",
        "viewBox": "0 0 640 280",
        "elements": [
          { "kind": "rect", "x": 110, "y": 90, "width": 420, "height": 100, "rx": 6, "fill": "#DBEAFE", "stroke": "#1E3A8A", "strokeWidth": 2.5 },
          { "kind": "line", "x1": 240, "y1": 35, "x2": 240, "y2": 155, "stroke": "#64748B", "strokeWidth": 1.5, "dashed": true },
          { "kind": "line", "x1": 300, "y1": 125, "x2": 300, "y2": 245, "stroke": "#64748B", "strokeWidth": 1.5, "dashed": true },
          { "kind": "arrow", "x1": 150, "y1": 25, "x2": 240, "y2": 90, "stroke": "#D97706", "strokeWidth": 3 },
          { "kind": "arrow", "x1": 240, "y1": 90, "x2": 300, "y2": 190, "stroke": "#1E3A8A", "strokeWidth": 3 },
          { "kind": "arrow", "x1": 300, "y1": 190, "x2": 390, "y2": 255, "stroke": "#059669", "strokeWidth": 3 },
          { "kind": "line", "x1": 240, "y1": 90, "x2": 450, "y2": 242, "stroke": "#D97706", "strokeWidth": 1.5, "dashed": true },
          { "kind": "label", "x": 85, "y": 55, "text_hi": "हवा (विरल माध्यम)", "text_en": "Air (Rarer)", "fill": "#475569", "fontSize": 13, "anchor": "start", "bold": true },
          { "kind": "label", "x": 455, "y": 145, "text_hi": "काँच की सिल्ली (सघन)", "text_en": "Glass Slab (Denser)", "fill": "#1E3A8A", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 225, "y": 65, "text_hi": "∠i", "text_en": "∠i", "fill": "#D97706", "fontSize": 14, "anchor": "end", "bold": true },
          { "kind": "label", "x": 255, "y": 140, "text_hi": "∠r", "text_en": "∠r", "fill": "#1E3A8A", "fontSize": 14, "anchor": "start", "bold": true },
          { "kind": "label", "x": 318, "y": 230, "text_hi": "∠e (= ∠i)", "text_en": "∠e (= ∠i)", "fill": "#059669", "fontSize": 13, "anchor": "start", "bold": true },
          { "kind": "label", "x": 148, "y": 20, "text_hi": "आपतित किरण", "text_en": "Incident Ray", "fill": "#D97706", "fontSize": 12, "anchor": "start", "bold": true },
          { "kind": "label", "x": 415, "y": 265, "text_hi": "निर्गत किरण (समांतर)", "text_en": "Emergent Ray (Parallel)", "fill": "#059669", "fontSize": 12, "anchor": "start", "bold": true }
        ]
      },
      "concept_md_hi": "### स्नेल का नियम (Snell's Law) व अपवर्तनांक\n$$\\frac{\\sin i}{\\sin r} = \\text{नियतांक} = n_{21}$$\n**निरपेक्ष अपवर्तनांक (Absolute Refractive Index):**\n$$n = \\frac{c}{v} = \\frac{3 \\times 10^8\\text{ m/s}}{\\text{माध्यम में प्रकाश की चाल}}$$\nहीरे का अपवर्तनांक सर्वाधिक ($n = 2.42$) होता है, अर्थात् हीरे में प्रकाश की चाल सबसे कम होती है।\n\n### लेंस सूत्र व लेंस की क्षमता (Power of a Lens)\n- **लेंस सूत्र:** $\\frac{1}{v} - \\frac{1}{u} = \\frac{1}{f}$ (ध्यान दें: दर्पण में $+$ है, लेंस में $-$ है!)\n- **लेंस आवर्धन:** $m = \\frac{h'}{h} = +\\frac{v}{u}$\n- **लेंस की क्षमता ($P$):** फोकस दूरी के व्युत्क्रम को क्षमता कहते हैं। इसका SI मात्रक **डायोप्टर ($D$)** है।\n$$P = \\frac{1}{f\\text{ (मीटर में)}} = \\frac{100}{f\\text{ (सेमी में)}}$$",
      "concept_md_en": "### Snell's Law & Refractive Index\n$$\\frac{\\sin i}{\\sin r} = \\text{constant} = n_{21}$$\n**Absolute Refractive Index:**\n$$n = \\frac{c}{v} = \\frac{3 \\times 10^8\\text{ m/s}}{\\text{Speed of light in medium}}$$\nDiamond has the highest refractive index ($n = 2.42$), meaning light slows down the most inside diamond.\n\n### Lens Formula & Power of a Lens\n- **Lens Formula:** $\\frac{1}{v} - \\frac{1}{u} = \\frac{1}{f}$ (Notice: Mirror has $+$, Lens has $-$!)\n- **Lens Magnification:** $m = \\frac{h'}{h} = +\\frac{v}{u}$\n- **Power of a Lens ($P$):** Reciprocal of focal length in metres. SI unit is **Dioptre ($D$)**.\n$$P = \\frac{1}{f\\text{ (in metres)}} = \\frac{100}{f\\text{ (in cm)}}$$",
      "exam_tip_hi": "सुपर-हॉट BSEB MCQ: 'लेंस की क्षमता का SI मात्रक क्या है?' → **डायोप्टर ($D$ या $\\text{m}^{-1}$)**। यदि चश्मे का पावर $+2.0\\text{ D}$ है, तो लेंस **उत्तल** है और $f = 100/2 = +50\\text{ cm}$!",
      "exam_tip_en": "Guaranteed BSEB MCQ: 'SI unit of Power of a Lens?' → **Dioptre ($D$ or $\\text{m}^{-1}$)**. If power is $+2.0\\text{ D}$, the lens is **Convex** and $f = 100/2 = +50\\text{ cm}$!",
      "glossary_terms": [
        {
          "term_hi": "1 डायोप्टर (1 Dioptre)",
          "term_en": "1 Dioptre",
          "definition_hi": "1 मीटर फोकस दूरी वाले लेंस की क्षमता 1 डायोप्टर ($1\\text{ D} = 1\\text{ m}^{-1}$) कहलाती है।",
          "definition_en": "Power of a lens whose focal length is 1 metre ($1\\text{ D} = 1\\text{ m}^{-1}$)."
        }
      ]
    },
    {
      "id": "sec-4-formula-sheet",
      "order": 4,
      "heading_hi": "4. परीक्षा से 5 मिनट पहले — संपूर्ण सूत्र कार्ड",
      "heading_en": "4. 5-Minute Exam Revision — Complete Formula Card",
      "analogy_hi": "दर्पण और लेंस के सूत्र जुड़वाँ भाई जैसे हैं — बस बीच के एक चिह्न ($+$ बनाम $-$) का फर्क याद रखिए और सारे न्यूमेरिकल मक्खन की तरह बन जाएँगे!",
      "analogy_en": "Mirror and Lens formulas are near-twins — just remember the single sign flip ($+$ vs $-$) and every numerical becomes effortless!",
      "visual_diagram": {
        "type": "FORMULA_CARD",
        "title_hi": "अध्याय 10 के सभी मुख्य सूत्र",
        "title_en": "All Master Formulas of Chapter 10",
        "formulas": [
          {
            "latex": "f = \\frac{R}{2}",
            "meaning_hi": "फोकस दूरी = वक्रता त्रिज्या / 2",
            "meaning_en": "Focal length = Radius of curvature / 2",
            "unit": "cm / m"
          },
          {
            "latex": "\\frac{1}{v} + \\frac{1}{u} = \\frac{1}{f}",
            "meaning_hi": "दर्पण सूत्र (Mirror Formula)",
            "meaning_en": "Mirror Formula (plus sign between 1/v and 1/u)"
          },
          {
            "latex": "\\frac{1}{v} - \\frac{1}{u} = \\frac{1}{f}",
            "meaning_hi": "लेंस सूत्र (Lens Formula)",
            "meaning_en": "Lens Formula (minus sign between 1/v and 1/u)"
          },
          {
            "latex": "m_{\\text{mirror}} = -\\frac{v}{u},\\quad m_{\\text{lens}} = +\\frac{v}{u}",
            "meaning_hi": "आवर्धन (दर्पण में ऋण, लेंस में धन)",
            "meaning_en": "Magnification (minus for mirror, plus for lens)",
            "unit": "Unitless"
          },
          {
            "latex": "P = \\frac{1}{f(\\text{m})} = \\frac{100}{f(\\text{cm})}",
            "meaning_hi": "लेंस की क्षमता (Power)",
            "meaning_en": "Power of a Lens",
            "unit": "Dioptre (D)"
          }
        ]
      },
      "concept_md_hi": "**याद रखने की सुनहरी चाबी:**\n- **अवतल दर्पण** और **अवतल लेंस** दोनों की फोकस दूरी $f$ हमेशा **ऋणात्मक ($-$)** होती है।\n- **उत्तल दर्पण** और **उत्तल लेंस** दोनों की फोकस दूरी $f$ हमेशा **धनात्मक ($+$)** होती है।",
      "concept_md_en": "**Golden Memory Key:**\n- Both **Concave Mirror** and **Concave Lens** have **negative ($-$)** focal length $f$.\n- Both **Convex Mirror** and **Convex Lens** have **positive ($+$)** focal length $f$.",
      "exam_tip_hi": "न्यूमेरिकल हल करते समय हमेशा सबसे ऊपर 'दिया है (Given): u = ..., f = ...' लिखकर सही चिह्न लगाएँ — बिहार बोर्ड में सही सूत्र और चिह्न लिखने पर भी आधे अंक पक्के मिलते हैं!",
      "exam_tip_en": "Always write 'Given: u = ..., f = ...' with proper signs at the top of a numerical — BSEB awards step marks even for correct sign convention and formula!",
      "glossary_terms": []
    }
  ]$json$::jsonb,
  $json${
    "important_formulas": [
      { "latex": "f = R / 2", "label_hi": "फोकस दूरी व वक्रता त्रिज्या संबंध", "label_en": "Focal length & Radius relation" },
      { "latex": "\\frac{1}{v} + \\frac{1}{u} = \\frac{1}{f}", "label_hi": "दर्पण सूत्र", "label_en": "Mirror Formula" },
      { "latex": "\\frac{1}{v} - \\frac{1}{u} = \\frac{1}{f}", "label_hi": "लेंस सूत्र", "label_en": "Lens Formula" },
      { "latex": "P = \\frac{100}{f(\\text{cm})}", "label_hi": "लेंस की क्षमता (डायोप्टर)", "label_en": "Power of Lens (Dioptre)" }
    ],
    "key_dates_or_facts": [
      { "tag": "c", "fact_hi": "निर्वात में प्रकाश की चाल = 3 × 10⁸ m/s", "fact_en": "Speed of light in vacuum = 3 × 10⁸ m/s" },
      { "tag": "n = 2.42", "fact_hi": "हीरे का अपवर्तनांक सर्वाधिक (2.42) होता है।", "fact_en": "Diamond has the highest refractive index (2.42)." },
      { "tag": "m = +1", "fact_hi": "समतल दर्पण का आवर्धन हमेशा +1 होता है (सीधा और बराबर आकार)।", "fact_en": "Magnification of a plane mirror is always +1 (erect and same size)." }
    ],
    "common_bseb_mistakes": [
      {
        "mistake_hi": "अवतल दर्पण की फोकस दूरी f को धनात्मक (+) रख देना।",
        "mistake_en": "Substituting positive (+) focal length for a concave mirror.",
        "fix_hi": "हमेशा याद रखें: अवतल (Concave) = 'कमी / ऋण (−)', उत्तल (Convex) = 'धन (+)'।",
        "fix_en": "Always remember: Concave = Negative (−), Convex = Positive (+)."
      },
      {
        "mistake_hi": "लेंस की क्षमता निकालते समय f को सेंटीमीटर में रखकर 1/f कर देना।",
        "mistake_en": "Computing P = 1/f using centimetres instead of metres.",
        "fix_hi": "यदि f सेमी में हो तो P = 100 / f का उपयोग करें।",
        "fix_en": "When f is in cm, always use P = 100 / f."
      }
    ],
    "high_yield_pyq_topics": [
      { "topic_hi": "अवतल व उत्तल दर्पण के उपयोग", "topic_en": "Uses of Concave & Convex Mirrors", "years": ["2021", "2023", "2024"], "expected_marks": 2 },
      { "topic_hi": "किरण आरेख व दर्पण/लेंस न्यूमेरिकल", "topic_en": "Ray Diagrams & Mirror/Lens Numericals", "years": ["2022", "2023", "2024"], "expected_marks": 5 },
      { "topic_hi": "स्नेल का नियम व लेंस की क्षमता (D)", "topic_en": "Snell's Law & Power of Lens", "years": ["2022", "2024"], "expected_marks": 3 }
    ]
  }$json$::jsonb,
  $json${
    "hindi_reviewed": true,
    "english_reviewed": true,
    "visuals_count": 4,
    "analogy_count": 4,
    "bseb_pyq_mapped": true,
    "syllabus_year": "2026-27"
  }$json$::jsonb,
  'PUBLISHED',
  1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json        = EXCLUDED.mindmap_json,
  sections_json       = EXCLUDED.sections_json,
  board_capsule_json  = EXCLUDED.board_capsule_json,
  quality_checks_json = EXCLUDED.quality_checks_json,
  status              = EXCLUDED.status,
  version             = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'bseb-10-sci-ch10',
  6,
  'विद्यार्थी अवतल व उत्तल दर्पण की पहचान कर सकेंगे, 6 प्रमुख किरण आरेख बिना रटे बना सकेंगे, स्नेल का नियम समझ सकेंगे तथा चिह्न परिपाटी के साथ दर्पण व लेंस के आंकिक प्रश्न हल कर सकेंगे।',
  'Students will identify concave and convex mirrors, draw all 6 ray diagrams logically without rote memorization, explain Snell''s law, and solve mirror/lens numericals with accurate Cartesian sign conventions.',
  $json$[
    {
      "period_no": 1,
      "duration_mins": 40,
      "phase_hi": "परिचय व परावर्तन के नियम",
      "phase_en": "Introduction & Laws of Reflection",
      "teacher_action_hi": "कक्षा में एक बड़ा स्टील का चम्मच और समतल दर्पण दिखाकर परावर्तन व गोलीय पृष्ठ का अंतर समझाएँ।",
      "teacher_action_en": "Demonstrate reflection using a shiny steel spoon and a plane mirror to introduce curved surfaces.",
      "student_check_hi": "पूछें: चम्मच के किस भाग में चेहरा उल्टा दिखता है जब उसे दूर ले जाते हैं?",
      "student_check_en": "Ask: On which side of the spoon does your face flip upside-down as you move it away?"
    },
    {
      "period_no": 2,
      "duration_mins": 40,
      "phase_hi": "गोलीय दर्पण के पद (P, F, C) व किरण नियम",
      "phase_en": "Mirror Anatomy (P, F, C) & 3 Ray Rules",
      "teacher_action_hi": "ब्लैकबोर्ड पर परकार से चाप खींचकर P, F, C की सही दूरी (PF = FC) नापकर दिखाएँ।",
      "teacher_action_en": "Draw a neat arc with a compass on the board, ensuring PF = FC exactly.",
      "student_check_hi": "दो छात्रों को बोर्ड पर बुलाकर F और C चिह्नित करवाएँ।",
      "student_check_en": "Invite two students to mark F and C accurately on a blank mirror sketch."
    },
    {
      "period_no": 3,
      "duration_mins": 40,
      "phase_hi": "अवतल दर्पण की 6 स्थितियाँ (सी-सॉ विधि)",
      "phase_en": "6 Concave Mirror Cases (See-Saw Method)",
      "teacher_action_hi": "रटवाने के बजाय तालिका के पैटर्न (1↔5, 2↔4, 3↔3) से सभी 6 स्थितियाँ सिखाएँ।",
      "teacher_action_en": "Teach the symmetry pairs (1↔5, 2↔4, 3↔3) instead of rote memorization.",
      "student_check_hi": "जल्दी पूछें: यदि वस्तु C पर है तो प्रतिबिंब कहाँ और कैसा बनेगा?",
      "student_check_en": "Quick oral check: Where does the image form when the object is placed at C?"
    },
    {
      "period_no": 4,
      "duration_mins": 40,
      "phase_hi": "चिह्न परिपाटी व दर्पण सूत्र न्यूमेरिकल",
      "phase_en": "Sign Convention & Mirror Numericals",
      "teacher_action_hi": "X-Y अक्ष बनाकर u, v, f के चिह्न समझाएँ और 2 बोर्ड-स्तरीय आंकिक प्रश्न हल कराएँ।",
      "teacher_action_en": "Overlay X-Y axes on pole P to prove sign conventions and solve 2 BSEB numericals step-by-step.",
      "student_check_hi": "कॉपी में जांचें कि सभी छात्रों ने u को ऋणात्मक लिखा है या नहीं।",
      "student_check_en": "Walk the rows to check every student wrote a minus sign for u."
    },
    {
      "period_no": 5,
      "duration_mins": 40,
      "phase_hi": "अपवर्तन, स्नेल का नियम व काँच की सिल्ली",
      "phase_en": "Refraction, Snell's Law & Glass Slab",
      "teacher_action_hi": "पारदर्शी गिलास में पानी और पेंसिल डालकर अपवर्तन दिखाएँ; विरल-सघन मुड़ाव नियम बोर्ड पर बनाएँ।",
      "teacher_action_en": "Show pencil-in-water refraction live; draw rarer-to-denser bending rule clearly.",
      "student_check_hi": "पूछें: हीरे का अपवर्तनांक 2.42 होने का क्या अर्थ है?",
      "student_check_en": "Ask: What does it mean physically that diamond has n = 2.42?"
    },
    {
      "period_no": 6,
      "duration_mins": 40,
      "phase_hi": "लेंस सूत्र, लेंस क्षमता (D) व बोर्ड क्विज़",
      "phase_en": "Lens Formula, Power (D) & Board Revision Quiz",
      "teacher_action_hi": "चश्मे के नंबर (+2D / -1.5D) से डायोप्टर जोड़कर पढ़ाएँ और 10 मिनट का लाइव टेस्ट लें।",
      "teacher_action_en": "Connect eyeglass prescriptions (+2D / -1.5D) to power formula and host a 10-minute Live Exam.",
      "student_check_hi": "छात्रों से P = -2.5 D वाले लेंस की फोकस दूरी और प्रकृति निकलवाएँ।",
      "student_check_en": "Have students compute focal length and lens type for P = -2.5 D."
    }
  ]$json$::jsonb,
  $json$[
    {
      "heading_hi": "ब्लैकबोर्ड सूत्र बॉक्स (दर्पण बनाम लेंस)",
      "heading_en": "Blackboard Formula Box (Mirror vs Lens)",
      "points_hi": [
        "दर्पण सूत्र: 1/v + 1/u = 1/f  |  लेंस सूत्र: 1/v - 1/u = 1/f",
        "दर्पण आवर्धन: m = -v/u  |  लेंस आवर्धन: m = +v/u",
        "अवतल (दोनों) → f ऋणात्मक (-)  |  उत्तल (दोनों) → f धनात्मक (+)",
        "क्षमता P = 100 / f (cm में), मात्रक = डायोप्टर (D)"
      ],
      "points_en": [
        "Mirror: 1/v + 1/u = 1/f  |  Lens: 1/v - 1/u = 1/f",
        "Mirror m = -v/u  |  Lens m = +v/u",
        "Concave (both) → f is (-)  |  Convex (both) → f is (+)",
        "Power P = 100 / f (in cm), SI unit = Dioptre (D)"
      ]
    }
  ]$json$::jsonb,
  $json$[
    {
      "title_hi": "धूप में अवतल दर्पण से कागज़ जलाना (फोकस की प्रत्यक्ष पहचान)",
      "title_en": "Finding Focal Length in Sunlight (Hands-on Activity)",
      "materials_hi": "अवतल दर्पण, सफेद कागज़, 30 सेमी स्केल",
      "materials_en": "Concave mirror, white sheet of paper, 30 cm ruler",
      "steps_hi": "स्कूल प्रांगण में सूर्य की किरणों को कागज़ पर सबसे चमकीले बिंदु पर केंद्रित करें। दर्पण और कागज़ की दूरी नापें — यही फोकस दूरी f है!",
      "steps_en": "In the school courtyard, focus sunlight onto a crisp bright dot on paper. Measure the distance between mirror and paper — that is focal length f!"
    }
  ]$json$::jsonb,
  $json$[
    {
      "level": "FOUNDATION",
      "task_hi": "अवतल और उत्तल दर्पण के 3-3 दैनिक उपयोग अपनी कॉपी में लिखें।",
      "task_en": "Write 3 everyday uses each of concave and convex mirrors in your notebook."
    },
    {
      "level": "BOARD",
      "task_hi": "15 cm फोकस दूरी वाले अवतल दर्पण के सामने 30 cm पर रखी वस्तु का प्रतिबिंब कहाँ बनेगा? किरण आरेख सहित हल करें।",
      "task_en": "Find the image position for an object placed 30 cm in front of a concave mirror of focal length 15 cm, with a neat ray diagram."
    },
    {
      "level": "CHALLENGE",
      "task_hi": "यदि किसी लेंस की क्षमता -2.5 D है, तो उसकी फोकस दूरी और प्रकार ज्ञात करें तथा 40 cm दूर रखी वस्तु का प्रतिबिंब निकालें।",
      "task_en": "A lens has power -2.5 D. Find its focal length, type, and image distance for an object placed at 40 cm."
    }
  ]$json$::jsonb,
  $json$[
    {
      "misconception_hi": "छात्र समझते हैं कि अवतल दर्पण हमेशा उल्टा प्रतिबिंब ही बनाता है।",
      "misconception_en": "Students assume concave mirrors ONLY form inverted images.",
      "correction_hi": "चम्मच को नाक के बिल्कुल पास लाकर दिखाएँ कि P और F के बीच रखने पर सीधा व बड़ा प्रतिबिंब बनता है।",
      "correction_en": "Hold a spoon very close to the nose to prove that between P and F, the image flips upright and enlarged."
    },
    {
      "misconception_hi": "छात्र दर्पण सूत्र (1/v + 1/u) और लेंस सूत्र (1/v - 1/u) के चिह्न आपस में बदल देते हैं।",
      "misconception_en": "Students swap the + and - signs between mirror and lens formulas.",
      "correction_hi": "ट्रिक सिखाएँ: 'दर्पण में जोड़ (+), लेंस में घटाव (−)' — और आवर्धन में इसका उल्टा!",
      "correction_en": "Teach the mnemonic: 'Mirror Adds (+), Lens Subtracts (−)' — and magnification flips the sign!"
    }
  ]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods                   = EXCLUDED.duration_periods,
  objectives_hi                      = EXCLUDED.objectives_hi,
  objectives_en                      = EXCLUDED.objectives_en,
  teaching_steps_json                = EXCLUDED.teaching_steps_json,
  blackboard_points_json             = EXCLUDED.blackboard_points_json,
  classroom_activities_json          = EXCLUDED.classroom_activities_json,
  homework_json                      = EXCLUDED.homework_json,
  common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

-- Questions for Class 10 Science Ch 10 (Flashcards, Match Pairs, Diagram Label, MCQs [PRACTICE + EXAM_ONLY], 2M, 5M)
INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- Flashcard 1
  (
    '10000000-0010-4000-8000-000000000001', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Sign Convention', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'अवतल व उत्तल दर्पण/लेंस की फोकस दूरी का चिह्न क्या होता है?',
    'What is the sign of focal length for concave vs convex mirrors and lenses?',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "FLASHCARD",
      "front_hi": "अवतल (Concave) और उत्तल (Convex) की फोकस दूरी (f) का चिह्न क्या होता है?",
      "front_en": "What is the sign of focal length (f) for Concave vs Convex mirrors & lenses?",
      "back_hi": "अवतल दर्पण व अवतल लेंस दोनों में f हमेशा ऋणात्मक (−) होता है। उत्तल दर्पण व उत्तल लेंस दोनों में f हमेशा धनात्मक (+) होता है।",
      "back_en": "Concave mirror & concave lens BOTH have negative (−) focal length f. Convex mirror & convex lens BOTH have positive (+) focal length f.",
      "mnemonic_hi": "याद रखें: अवतल = 'अंदर/ऋण (−)', उत्तल = 'उभरा/धन (+)'",
      "mnemonic_en": "Memory hook: conCAVE = Cave/Negative (−), conVEX = Positive (+)"
    }$json$::jsonb, true
  ),
  -- Flashcard 2
  (
    '10000000-0010-4000-8000-000000000002', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Power of Lens', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'लेंस की क्षमता (Power) का सूत्र व SI मात्रक क्या है?',
    'What is the formula and SI unit of Power of a Lens?',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "FLASHCARD",
      "front_hi": "लेंस की क्षमता (P) का सूत्र और SI मात्रक बताएँ।",
      "front_en": "State the formula and SI unit of Power of a Lens (P).",
      "back_hi": "P = 1 / f (मीटर में) = 100 / f (सेमी में)। SI मात्रक = डायोप्टर (D या m⁻¹)।",
      "back_en": "P = 1 / f (in metres) = 100 / f (in cm). SI unit = Dioptre (D or m⁻¹).",
      "formula_latex": "P = \\frac{1}{f(\\text{m})} = \\frac{100}{f(\\text{cm})}"
    }$json$::jsonb, true
  ),
  -- Match Pairs
  (
    '10000000-0010-4000-8000-000000000003', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Mirror & Lens Uses', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'स्तंभ A के प्रकाशिक यंत्रों को स्तंभ B के सही उपयोग से मिलाएँ:',
    'Match the optical devices in Column A with their exact everyday use in Column B:',
    NULL, NULL,
    'सोचिए किसमें बड़ा प्रतिबिंब चाहिए और किसमें पीछे की पूरी सड़क देखनी है!',
    'Think about where you need a magnified view vs a wide rear road view!',
    'अवतल दर्पण किरणों को केंद्रित या बड़ा करता है (हेडलाइट/दाँत), जबकि उत्तल दर्पण व्यापक दृष्टि-क्षेत्र देता है (साइड मिरर)।',
    'Concave mirrors focus beams or magnify close objects (headlight/dentist), while convex mirrors give a wide rear view.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "MATCH_PAIRS",
      "instruction_hi": "सही जोड़े मिलाएँ",
      "instruction_en": "Match each device with its correct use",
      "pairs": [
        { "id": "p1", "left_hi": "अवतल दर्पण (Concave Mirror)", "left_en": "Concave Mirror", "right_hi": "मोटरसाइकिल की हेडलाइट व दंत चिकित्सक", "right_en": "Bike headlight & dentist mirror" },
        { "id": "p2", "left_hi": "उत्तल दर्पण (Convex Mirror)", "left_en": "Convex Mirror", "right_hi": "वाहन का पश्च-दृश्य (Side Mirror)", "right_en": "Vehicle rear-view side mirror" },
        { "id": "p3", "left_hi": "उत्तल लेंस (Convex Lens)", "left_en": "Convex Lens", "right_hi": "आवर्धक शीशा व दूर-दृष्टि का चश्मा", "right_en": "Magnifying glass & hypermetropia spectacles" },
        { "id": "p4", "left_hi": "अवतल लेंस (Concave Lens)", "left_en": "Concave Lens", "right_hi": "निकट-दृष्टि दोष (Myopia) का निवारण", "right_en": "Correction of short-sightedness (Myopia)" }
      ]
    }$json$::jsonb, true
  ),
  -- Diagram Label
  (
    '10000000-0010-4000-8000-000000000004', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Spherical Mirror Anatomy', 'PRACTICE', 'DIAGRAM_LABEL', 'FOUNDATION', NULL,
    'अवतल दर्पण के चित्र में अंकित बिंदु (1), (2) और (3) को सही नाम से पहचानें:',
    'Identify the labeled points (1), (2), and (3) on the concave mirror diagram:',
    NULL, NULL,
    'ध्रुव दर्पण की सतह पर होता है और फोकस हमेशा ध्रुव व वक्रता केंद्र के ठीक बीच में होता है।',
    'Pole lies on the mirror surface, and Focus sits midway between Pole and Centre of Curvature.',
    'ध्रुव (P) दर्पण के केंद्र पर, मुख्य फोकस (F) बीच में (PF = f), और वक्रता केंद्र (C) दूरी 2f पर होता है।',
    'Pole (P) is on the mirror surface, Focus (F) is at distance f, and Centre of Curvature (C) is at distance R = 2f.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "DIAGRAM_LABEL",
      "instruction_hi": "चित्र में 1, 2 और 3 के सही नाम चुनें",
      "instruction_en": "Select the correct label for points 1, 2, and 3",
      "diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "अवतल दर्पण के मुख्य बिंदु पहचानें",
        "title_en": "Identify Key Points of a Concave Mirror",
        "caption_hi": "मुख्य अक्ष पर तीन प्रमुख बिंदु चिह्नित हैं।",
        "caption_en": "Three key points are marked along the principal axis.",
        "viewBox": "0 0 560 220",
        "elements": [
          { "kind": "line", "x1": 40, "y1": 110, "x2": 510, "y2": 110, "stroke": "#64748B", "strokeWidth": 2, "dashed": true },
          { "kind": "path", "d": "M 430 25 Q 485 110 430 195", "fill": "none", "stroke": "#1E3A8A", "strokeWidth": 4 },
          { "kind": "circle", "cx": 458, "cy": 110, "r": 7, "fill": "#1E3A8A" },
          { "kind": "circle", "cx": 330, "cy": 110, "r": 7, "fill": "#D97706" },
          { "kind": "circle", "cx": 202, "cy": 110, "r": 7, "fill": "#059669" },
          { "kind": "label", "x": 458, "y": 92, "text_hi": "(1)", "text_en": "(1)", "fill": "#1E3A8A", "fontSize": 15, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 330, "y": 92, "text_hi": "(2)", "text_en": "(2)", "fill": "#D97706", "fontSize": 15, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 202, "y": 92, "text_hi": "(3)", "text_en": "(3)", "fill": "#059669", "fontSize": 15, "anchor": "middle", "bold": true }
        ]
      },
      "hotspots": [
        {
          "id": "h1", "x": 458, "y": 110, "label_code": "1",
          "answer_hi": "ध्रुव (Pole, P)", "answer_en": "Pole (P)",
          "options_hi": ["ध्रुव (Pole, P)", "मुख्य फोकस (F)", "वक्रता केंद्र (C)"],
          "options_en": ["Pole (P)", "Principal Focus (F)", "Centre of Curvature (C)"]
        },
        {
          "id": "h2", "x": 330, "y": 110, "label_code": "2",
          "answer_hi": "मुख्य फोकस (F)", "answer_en": "Principal Focus (F)",
          "options_hi": ["ध्रुव (Pole, P)", "मुख्य फोकस (F)", "वक्रता केंद्र (C)"],
          "options_en": ["Pole (P)", "Principal Focus (F)", "Centre of Curvature (C)"]
        },
        {
          "id": "h3", "x": 202, "y": 110, "label_code": "3",
          "answer_hi": "वक्रता केंद्र (C)", "answer_en": "Centre of Curvature (C)",
          "options_hi": ["ध्रुव (Pole, P)", "मुख्य फोकस (F)", "वक्रता केंद्र (C)"],
          "options_en": ["Pole (P)", "Principal Focus (F)", "Centre of Curvature (C)"]
        }
      ]
    }$json$::jsonb, true
  ),
  -- MCQ 1 (FOUNDATION, PRACTICE)
  (
    '10000000-0010-4000-8000-000000000005', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Reflection Basics', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'प्रकाश के परावर्तन के कितने नियम हैं?',
    'How many laws of reflection of light are there?',
    '[{"key":"A","text_hi":"1","text_en":"1"},{"key":"B","text_hi":"2","text_en":"2"},{"key":"C","text_hi":"3","text_en":"3"},{"key":"D","text_hi":"4","text_en":"4"}]'::jsonb,
    'B',
    'एक नियम कोण (∠i = ∠r) के बारे में है और दूसरा एक ही तल के बारे में।',
    'One law relates angles (∠i = ∠r) and the second states they lie in the same plane.',
    'प्रकाश के परावर्तन के 2 नियम हैं: (1) आपतन कोण बराबर परावर्तन कोण (∠i = ∠r), (2) आपतित किरण, परावर्तित किरण और अभिलंब एक ही तल में होते हैं।',
    'There are 2 laws of reflection: (1) Angle of incidence equals angle of reflection (∠i = ∠r), and (2) Incident ray, reflected ray, and normal lie in the same plane.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  -- MCQ 2 (BOARD, PRACTICE)
  (
    '10000000-0010-4000-8000-000000000006', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Concave Mirror Image', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'अवतल दर्पण में किसी वस्तु का वास्तविक तथा वस्तु के बराबर आकार का प्रतिबिंब प्राप्त करने के लिए वस्तु को कहाँ रखना चाहिए?',
    'Where should an object be placed in front of a concave mirror to obtain a real image of the exact same size?',
    '[{"key":"A","text_hi":"फोकस (F) पर","text_en":"At focus (F)"},{"key":"B","text_hi":"वक्रता केंद्र (C) पर","text_en":"At centre of curvature (C)"},{"key":"C","text_hi":"ध्रुव (P) और फोकस (F) के बीच","text_en":"Between pole (P) and focus (F)"},{"key":"D","text_hi":"अनंत पर","text_en":"At infinity"}]'::jsonb,
    'B',
    'अवतल दर्पण तालिका की तीसरी (बिल्कुल बीच वाली) स्थिति याद करें!',
    'Recall the symmetric middle case (Case 3) of the concave mirror table!',
    'जब वस्तु को वक्रता केंद्र (C) पर रखा जाता है, तो प्रतिबिंब C पर ही, वास्तविक, उल्टा और ठीक वस्तु के समान आकार का बनता है।',
    'When the object is at C, the image forms at C itself — real, inverted, and of the exact same size.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  -- MCQ 3 (BOARD, PRACTICE)
  (
    '10000000-0010-4000-8000-000000000007', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Power of Lens', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'यदि किसी उत्तल लेंस की फोकस दूरी $50\\text{ cm}$ है, तो उसकी क्षमता (Power) क्या होगी?',
    'If the focal length of a convex lens is $50\\text{ cm}$, what is its power?',
    '[{"key":"A","text_hi":"+5 D","text_en":"+5 D"},{"key":"B","text_hi":"-5 D","text_en":"-5 D"},{"key":"C","text_hi":"+2 D","text_en":"+2 D"},{"key":"D","text_hi":"-2 D","text_en":"-2 D"}]'::jsonb,
    'C',
    'सूत्र P = 100 / f (cm में) लगाएँ और उत्तल लेंस का धनात्मक चिह्न याद रखें।',
    'Use P = 100 / f (in cm) and remember convex lenses have positive focal length.',
    'उत्तल लेंस के लिए $f = +50\\text{ cm} = +0.5\\text{ m}$। अतः $P = \\frac{100}{+50} = +2\\text{ D}$।',
    'For a convex lens, $f = +50\\text{ cm} = +0.5\\text{ m}$. Hence $P = \\frac{100}{+50} = +2\\text{ D}$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  -- MCQ 4 (TOPPER, EXAM_ONLY — held back strictly for teacher-hosted exams!)
  (
    '10000000-0010-4000-8000-000000000008', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Mirror Formula Numerical', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'एक अवतल दर्पण की फोकस दूरी $10\\text{ cm}$ है। यदि वस्तु को दर्पण के सामने $20\\text{ cm}$ पर रखा जाए, तो प्रतिबिंब की दूरी $v$ क्या होगी?',
    'The focal length of a concave mirror is $10\\text{ cm}$. If an object is placed $20\\text{ cm}$ in front of it, what is the image distance $v$?',
    '[{"key":"A","text_hi":"-10 cm","text_en":"-10 cm"},{"key":"B","text_hi":"-20 cm","text_en":"-20 cm"},{"key":"C","text_hi":"+20 cm","text_en":"+20 cm"},{"key":"D","text_hi":"-30 cm","text_en":"-30 cm"}]'::jsonb,
    'B',
    'देखें कि $20\\text{ cm} = 2f = R$ है, अर्थात् वस्तु वक्रता केंद्र $C$ पर है!',
    'Notice that $20\\text{ cm} = 2f = R$, so the object is placed right at C!',
    '$f = -10\\text{ cm}, u = -20\\text{ cm}$। सूत्र $\\frac{1}{v} = \\frac{1}{f} - \\frac{1}{u} = \\frac{1}{-10} - \\frac{1}{-20} = -\\frac{1}{20} \\Rightarrow v = -20\\text{ cm}$।',
    '$f = -10\\text{ cm}, u = -20\\text{ cm}$. Using $\\frac{1}{v} = \\frac{1}{f} - \\frac{1}{u} = -\\frac{1}{10} + \\frac{1}{20} = -\\frac{1}{20} \\Rightarrow v = -20\\text{ cm}$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  -- MCQ 5 (BOARD, EXAM_ONLY)
  (
    '10000000-0010-4000-8000-000000000009', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Refractive Index', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2023',
    'प्रकाश हवा से काँच ($n = 1.50$) में प्रवेश करता है। काँच में प्रकाश की चाल कितनी होगी? ($c = 3 \\times 10^8\\text{ m/s}$)',
    'Light enters from air into glass of refractive index $n = 1.50$. What is the speed of light in glass? ($c = 3 \\times 10^8\\text{ m/s}$)',
    '[{"key":"A","text_hi":"1.5 × 10⁸ m/s","text_en":"1.5 × 10⁸ m/s"},{"key":"B","text_hi":"2.0 × 10⁸ m/s","text_en":"2.0 × 10⁸ m/s"},{"key":"C","text_hi":"3.0 × 10⁸ m/s","text_en":"3.0 × 10⁸ m/s"},{"key":"D","text_hi":"4.5 × 10⁸ m/s","text_en":"4.5 × 10⁸ m/s"}]'::jsonb,
    'B',
    'सूत्र $v = c / n$ का उपयोग करें।',
    'Use the formula $v = c / n$.',
    '$v = \\frac{c}{n} = \\frac{3 \\times 10^8}{1.50} = 2.0 \\times 10^8\\text{ m/s}$।',
    '$v = \\frac{c}{n} = \\frac{3 \\times 10^8}{1.50} = 2.0 \\times 10^8\\text{ m/s}$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  -- SHORT_2M
  (
    '10000000-0010-4000-8000-000000000010', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Uses of Convex Mirror', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'हम वाहनों में उत्तल दर्पण को पश्च-दृश्य (Side Mirror) दर्पण के रूप में वरीयता क्यों देते हैं?',
    'Why do we prefer a convex mirror as a rear-view mirror in vehicles?',
    NULL, NULL,
    'दो कारण लिखें: प्रतिबिंब की प्रकृति और दृष्टि-क्षेत्र।',
    'Write two crisp reasons: nature of image and field of view.',
    NULL, NULL,
    'वाहनों में उत्तल दर्पण को पश्च-दृश्य दर्पण के रूप में निम्नलिखित दो कारणों से वरीयता दी जाती है:\n1. यह हमेशा **सीधा (Erect)** तथा वस्तु से **छोटा (Diminished)** प्रतिबिंब बनाता है।\n2. बाहर की ओर वक्रित होने के कारण इसका **दृष्टि-क्षेत्र (Field of View) बहुत अधिक** होता है, जिससे चालक पीछे की पूरी सड़क और दूर से आते वाहनों को सुरक्षित रूप से देख पाता है।',
    'A convex mirror is preferred as a rear-view mirror in vehicles for two reasons:\n1. It always forms an **erect** and **diminished** image of vehicles behind.\n2. Being curved outwards, it provides a **much wider field of view**, allowing the driver to view a large area of traffic safely.',
    '[{"cue_hi":"सीधा और छोटा प्रतिबिंब","cue_en":"Always erect & diminished"},{"cue_hi":"विस्तृत दृष्टि-क्षेत्र (Wide field of view)","cue_en":"Wide field of view"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"सीधा व छोटा प्रतिबिंब बनने का उल्लेख","criterion_en":"Mentions erect and diminished image"},{"step_no":2,"marks":1,"criterion_hi":"बड़े दृष्टि-क्षेत्र (Wide field of view) का उल्लेख","criterion_en":"Mentions wide field of view due to outward curve"}]'::jsonb,
    NULL, true
  ),
  -- LONG_5M
  (
    '10000000-0010-4000-8000-000000000011', 'bseb-10-sci', 'bseb-10-sci-ch10', 'Mirror Formula 5M Numerical', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '$4.0\\text{ cm}$ ऊँचाई की कोई वस्तु $15.0\\text{ cm}$ फोकस दूरी वाले अवतल दर्पण से $25.0\\text{ cm}$ की दूरी पर रखी है। दर्पण से कितनी दूरी पर किसी पर्दे को रखा जाए कि स्पष्ट प्रतिबिंब प्राप्त हो? प्रतिबिंब की प्रकृति तथा ऊँचाई ज्ञात करें।',
    'An object $4.0\\text{ cm}$ in size is placed at $25.0\\text{ cm}$ in front of a concave mirror of focal length $15.0\\text{ cm}$. At what distance from the mirror should a screen be placed to obtain a sharp image? Find the nature and height of the image.',
    NULL, NULL,
    'पहले चिह्न परिपाटी के साथ $h, u, f$ लिखें, फिर दर्पण सूत्र से $v$ और आवर्धन सूत्र से $h''$ निकालें।',
    'List $h, u, f$ with signs first, then compute $v$ via mirror formula and $h''$ via magnification.',
    NULL, NULL,
    '**दिया है (चिह्न परिपाटी सहित):**\n- वस्तु की ऊँचाई $h = +4.0\\text{ cm}$\n- वस्तु की दूरी $u = -25.0\\text{ cm}$\n- अवतल दर्पण की फोकस दूरी $f = -15.0\\text{ cm}$\n\n**चरण 1: दर्पण सूत्र से $v$ की गणना**\n$$\\frac{1}{v} + \\frac{1}{u} = \\frac{1}{f} \\implies \\frac{1}{v} = \\frac{1}{f} - \\frac{1}{u}$$\n$$\\frac{1}{v} = \\frac{1}{-15} - \\frac{1}{-25} = -\\frac{1}{15} + \\frac{1}{25} = \\frac{-5 + 3}{75} = -\\frac{2}{75}$$\n$$v = -37.5\\text{ cm}$$\nअतः पर्दे को दर्पण के सामने **$37.5\\text{ cm}$** की दूरी पर रखना चाहिए।\n\n**चरण 2: प्रतिबिंब की ऊँचाई $h''$ तथा प्रकृति**\n$$m = \\frac{h''}{h} = -\\frac{v}{u} \\implies h'' = -\\frac{v \\cdot h}{u} = -\\frac{(-37.5)(+4.0)}{-25.0} = -6.0\\text{ cm}$$\n\n**निष्कर्ष:** प्रतिबिंब **वास्तविक, उल्टा** तथा **$6.0\\text{ cm}$** ऊँचा (वस्तु से बड़ा) बनेगा।',
    '**Given (with Cartesian signs):**\n- Object height $h = +4.0\\text{ cm}$\n- Object distance $u = -25.0\\text{ cm}$\n- Focal length of concave mirror $f = -15.0\\text{ cm}$\n\n**Step 1: Find image distance $v$ using Mirror Formula**\n$$\\frac{1}{v} = \\frac{1}{f} - \\frac{1}{u} = \\frac{1}{-15} - \\frac{1}{-25} = \\frac{-5 + 3}{75} = -\\frac{2}{75} \\implies v = -37.5\\text{ cm}$$\nTherefore, the screen must be placed **$37.5\\text{ cm}$ in front** of the mirror.\n\n**Step 2: Find image height $h''$ and nature**\n$$h'' = -\\frac{v \\cdot h}{u} = -\\frac{(-37.5)(4.0)}{-25.0} = -6.0\\text{ cm}$$\n\n**Conclusion:** The image is **real, inverted**, and **enlarged ($6.0\\text{ cm}$ tall)**.',
    '[{"cue_hi":"Given में u = -25, f = -15 लिखें","cue_en":"Write u = -25, f = -15 with minus signs"},{"cue_hi":"15 और 25 का LCM = 75","cue_en":"LCM of 15 and 25 is 75"},{"cue_hi":"ऋणात्मक h'' = वास्तविक व उल्टा","cue_en":"Negative h'' confirms real & inverted"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"सही चिह्न परिपाटी सहित Given मान लिखना","criterion_en":"Correct Given values with Cartesian signs"},{"step_no":2,"marks":1,"criterion_hi":"सही दर्पण सूत्र लिखना","criterion_en":"States mirror formula correctly"},{"step_no":3,"marks":1.5,"criterion_hi":"v = -37.5 cm की सटीक गणना","criterion_en":"Accurate calculation of v = -37.5 cm"},{"step_no":4,"marks":1,"criterion_hi":"आवर्धन सूत्र से h'' = -6.0 cm निकालना","criterion_en":"Computes image height h'' = -6.0 cm"},{"step_no":5,"marks":0.5,"criterion_hi":"प्रकृति (वास्तविक, उल्टा, बड़ा) लिखना","criterion_en":"Correctly states real, inverted, enlarged nature"}]'::jsonb,
    NULL, true
  )
ON CONFLICT (id) DO UPDATE SET
  q_hi = EXCLUDED.q_hi, q_en = EXCLUDED.q_en, options_json = EXCLUDED.options_json,
  correct_option = EXCLUDED.correct_option, explanation_hi = EXCLUDED.explanation_hi,
  explanation_en = EXCLUDED.explanation_en, model_answer_hi = EXCLUDED.model_answer_hi,
  model_answer_en = EXCLUDED.model_answer_en, marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json = EXCLUDED.visual_asset_json, bank_pool = EXCLUDED.bank_pool;

-- #############################################################################
-- CHAPTER 2 OF 6: CLASS 10 MATHEMATICS CH 4 — QUADRATIC EQUATIONS (द्विघात समीकरण)
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-10-math-ch4',
  $json${
    "title_hi": "30-सेकंड माइंडमैप: द्विघात समीकरण (Quadratic Equations)",
    "title_en": "30-Second Mindmap: Quadratic Equations",
    "read_time_seconds": 30,
    "central_node": {
      "id": "quad-root",
      "label_hi": "ax² + bx + c = 0 (a ≠ 0)",
      "label_en": "ax² + bx + c = 0 (a ≠ 0)",
      "subtitle_hi": "चर की अधिकतम घात = 2 · अधिकतम 2 मूल (α, β)",
      "subtitle_en": "Highest power = 2 · At most 2 roots (α, β)"
    },
    "branches": [
      {
        "id": "q-methods",
        "label_hi": "1. हल करने की विधियाँ",
        "label_en": "1. Solving Methods",
        "color": "#1E3A8A",
        "children": [
          { "id": "qm1", "label_hi": "गुणनखंड विधि (मध्य पद तोड़कर)", "label_en": "Factorisation (Splitting middle term)" },
          { "id": "qm2", "label_hi": "द्विघाती / श्रीधराचार्य सूत्र", "label_en": "Quadratic / Shridharacharya Formula", "formula_latex": "x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}" }
        ]
      },
      {
        "id": "q-discriminant",
        "label_hi": "2. विविक्तकर (D = b² − 4ac)",
        "label_en": "2. Discriminant (D = b² − 4ac)",
        "color": "#D97706",
        "children": [
          { "id": "qd1", "label_hi": "D > 0: दो भिन्न वास्तविक मूल", "label_en": "D > 0: Two distinct real roots" },
          { "id": "qd2", "label_hi": "D = 0: दो बराबर वास्तविक मूल (x = -b/2a)", "label_en": "D = 0: Two equal real roots (x = -b/2a)" },
          { "id": "qd3", "label_hi": "D < 0: कोई वास्तविक मूल नहीं", "label_en": "D < 0: No real roots" }
        ]
      },
      {
        "id": "q-relations",
        "label_hi": "3. मूलों का योग व गुणनफल",
        "label_en": "3. Sum & Product of Roots",
        "color": "#059669",
        "formula_latex": "\\alpha + \\beta = -\\frac{b}{a},\\quad \\alpha\\beta = \\frac{c}{a}"
      }
    ]
  }$json$::jsonb,
  $json$[
    {
      "id": "math-sec-1-parabola",
      "order": 1,
      "heading_hi": "1. द्विघात समीकरण और 'मूल (Roots)' को ग्राफ़ से आँखों से देखें",
      "heading_en": "1. Visually See What a Quadratic Equation & Its 'Roots' Mean",
      "analogy_hi": "मान लीजिए आपके गाँव में एक आयताकार धान का खेत है जिसका क्षेत्रफल $80\\text{ m}^2$ है और लंबाई, चौड़ाई से $2\\text{ m}$ अधिक है। यदि चौड़ाई $= x$, तो लंबाई $= x + 2$। क्षेत्रफल होगा $x(x+2) = 80 \\Rightarrow x^2 + 2x - 80 = 0$। यही है **द्विघात समीकरण** — इसमें $x^2$ आना ज़रूरी है ($a \\neq 0$)! ग्राफ़ पर इसका आकार हवा में फेंकी गई क्रिकेट गेंद जैसा (परवलय / Parabola) बनता है, और यह X-अक्ष को जहाँ काटता है वही इसके **मूल (Roots)** हैं!",
      "analogy_en": "Suppose your family has a rectangular paddy field of area $80\\text{ m}^2$ whose length is $2\\text{ m}$ more than its breadth. If breadth $= x$, length $= x+2$, so $x(x+2)=80 \\Rightarrow x^2 + 2x - 80 = 0$. That is a **Quadratic Equation**! On a graph it curves like a cricket ball thrown in the sky (a parabola), and the exact points where it crosses the X-axis are its **roots**!",
      "visual_diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "परवलय ग्राफ़: y = x² − 5x + 6 के मूल (x = 2 तथा x = 3)",
        "title_en": "Parabola Graph: Roots of y = x² − 5x + 6 at x = 2 and x = 3",
        "caption_hi": "वक्र X-अक्ष को x = 2 और x = 3 पर काटता है — इसलिए x = 2 और x = 3 इस समीकरण के वास्तविक मूल (Roots) हैं।",
        "caption_en": "The curve crosses the X-axis at x = 2 and x = 3 — proving visually why x = 2 and x = 3 are the two real roots.",
        "viewBox": "0 0 600 280",
        "elements": [
          { "kind": "arrow", "x1": 60, "y1": 200, "x2": 540, "y2": 200, "stroke": "#334155", "strokeWidth": 2 },
          { "kind": "arrow", "x1": 150, "y1": 260, "x2": 150, "y2": 25, "stroke": "#334155", "strokeWidth": 2 },
          { "kind": "line", "x1": 350, "y1": 40, "x2": 350, "y2": 240, "stroke": "#94A3B8", "strokeWidth": 1.5, "dashed": true },
          { "kind": "path", "d": "M 210 40 Q 350 385 490 40", "fill": "none", "stroke": "#1E3A8A", "strokeWidth": 3.5 },
          { "kind": "circle", "cx": 292, "cy": 200, "r": 6, "fill": "#059669" },
          { "kind": "circle", "cx": 408, "cy": 200, "r": 6, "fill": "#059669" },
          { "kind": "circle", "cx": 350, "cy": 212, "r": 5, "fill": "#D97706" },
          { "kind": "label", "x": 545, "y": 205, "text_hi": "X-अक्ष", "text_en": "X-axis", "fill": "#334155", "fontSize": 12, "anchor": "start", "bold": true },
          { "kind": "label", "x": 160, "y": 34, "text_hi": "Y-अक्ष", "text_en": "Y-axis", "fill": "#334155", "fontSize": 12, "anchor": "start", "bold": true },
          { "kind": "label", "x": 275, "y": 186, "text_hi": "मूल α = 2", "text_en": "Root α = 2", "fill": "#059669", "fontSize": 13, "anchor": "end", "bold": true },
          { "kind": "label", "x": 422, "y": 186, "text_hi": "मूल β = 3", "text_en": "Root β = 3", "fill": "#059669", "fontSize": 13, "anchor": "start", "bold": true },
          { "kind": "label", "x": 350, "y": 236, "text_hi": "शीर्ष (Vertex: x = 2.5)", "text_en": "Vertex (x = 2.5)", "fill": "#D97706", "fontSize": 12, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 465, "y": 60, "text_hi": "y = x² − 5x + 6", "text_en": "y = x² − 5x + 6", "fill": "#1E3A8A", "fontSize": 14, "anchor": "start", "bold": true }
        ]
      },
      "concept_md_hi": "### मानक रूप (Standard Form)\n$$ax^2 + bx + c = 0, \\quad \\text{जहाँ } a, b, c \\in \\mathbb{R} \\text{ और } a \\neq 0$$\n- **$a$:** $x^2$ का गुणांक (यह कभी $0$ नहीं हो सकता, वरना समीकरण रैखिक बन जाएगा!)\n- **$b$:** $x$ का गुणांक\n- **$c$:** अचर पद (Constant term)\n\n**गुणनखंड विधि (3 आसान चरण):** उदाहरण $x^2 - 5x + 6 = 0$\n1. $a \\times c = 1 \\times 6 = +6$ निकालें।\n2. दो ऐसी संख्याएँ खोजें जिनका **गुणा $+6$** और **जोड़ $-5$** हो $\\rightarrow$ **$-2$ और $-3$**।\n3. लिखें: $x^2 - 2x - 3x + 6 = 0 \\Rightarrow (x-2)(x-3)=0 \\Rightarrow x = 2, 3$।",
      "concept_md_en": "### Standard Form\n$$ax^2 + bx + c = 0, \\quad \\text{where } a, b, c \\in \\mathbb{R} \\text{ and } a \\neq 0$$\n- **$a$:** Coefficient of $x^2$ (must never be $0$, otherwise it becomes linear!)\n- **$b$:** Coefficient of $x$\n- **$c$:** Constant term\n\n**Factorisation in 3 Easy Steps:** Example $x^2 - 5x + 6 = 0$\n1. Compute $a \\times c = 1 \\times 6 = +6$.\n2. Find two numbers whose **product is $+6$** and **sum is $-5$** $\\rightarrow$ **$-2$ and $-3$**.\n3. Split & factor: $(x-2)(x-3) = 0 \\Rightarrow x = 2, 3$.",
      "exam_tip_hi": "ध्यान दें: यदि प्रश्न में $x + \\frac{1}{x} = 3$ हो तो पहले $x$ से गुणा कर मानक रूप ($x^2 - 3x + 1 = 0$) बनाएँ, तभी $a, b, c$ पहचानें!",
      "exam_tip_en": "Tip: If given $x + \\frac{1}{x} = 3$, multiply through by $x$ to get standard form $x^2 - 3x + 1 = 0$ before reading $a, b, c$!",
      "glossary_terms": [
        {
          "term_hi": "द्विघात समीकरण के मूल (Roots)",
          "term_en": "Roots of a Quadratic Equation",
          "definition_hi": "चर $x$ के वे मान जो समीकरण $ax^2 + bx + c = 0$ को संतुष्ट (LHS = 0) करते हैं।",
          "definition_en": "Values of $x$ that satisfy $ax^2 + bx + c = 0$ (making LHS = 0)."
        }
      ]
    },
    {
      "id": "math-sec-2-discriminant",
      "order": 2,
      "heading_hi": "2. श्रीधराचार्य सूत्र और विविक्तकर (Discriminant D) का जादू",
      "heading_en": "2. Shridharacharya Formula & The Power of Discriminant (D)",
      "analogy_hi": "विविक्तकर $D = b^2 - 4ac$ एक **एक्स-रे मशीन** जैसा है! बिना पूरा समीकरण हल किए, सिर्फ $D$ का चिह्न ($+$, $0$, या $-$) देखकर आप 5 सेकंड में बता सकते हैं कि उत्तर वास्तविक आएँगे, बराबर आएँगे या निकलेंगे ही नहीं!",
      "analogy_en": "The Discriminant $D = b^2 - 4ac$ works like an **X-ray machine**! Without even solving the equation, just checking whether $D$ is positive, zero, or negative tells you the exact nature of the roots in 5 seconds!",
      "visual_diagram": {
        "type": "COMPARISON_TABLE",
        "title_hi": "विविक्तकर D = b² − 4ac और मूलों की प्रकृति (हर वर्ष BSEB में 3-4 अंक पक्के!)",
        "title_en": "Discriminant D = b² − 4ac & Nature of Roots (Guaranteed 3-4 Marks in BSEB!)",
        "headers_hi": ["D का मान", "मूलों की प्रकृति", "X-अक्ष से ग्राफ़ का संबंध", "मूल का सूत्र"],
        "headers_en": ["Value of D", "Nature of Roots", "Graph vs X-Axis", "Root Formula"],
        "rows": [
          {
            "cells_hi": ["D > 0 (धनात्मक)", "दो भिन्न वास्तविक मूल", "X-अक्ष को 2 बिंदुओं पर काटता है", "x = (−b ± √D) / 2a"],
            "cells_en": ["D > 0 (Positive)", "Two distinct real roots", "Cuts X-axis at 2 points", "x = (−b ± √D) / 2a"]
          },
          {
            "cells_hi": ["D = 0 (शून्य)", "दो बराबर वास्तविक मूल", "X-अक्ष को 1 बिंदु पर स्पर्श करता है", "x = −b / 2a, −b / 2a"],
            "cells_en": ["D = 0 (Zero)", "Two equal real roots", "Touches X-axis at 1 point", "x = −b / 2a, −b / 2a"]
          },
          {
            "cells_hi": ["D < 0 (ऋणात्मक)", "कोई वास्तविक मूल नहीं", "X-अक्ष को कभी नहीं छूता", "वास्तविक हल संभव नहीं"],
            "cells_en": ["D < 0 (Negative)", "No real roots (imaginary)", "Never touches X-axis", "No real solution"]
          }
        ]
      },
      "concept_md_hi": "### द्विघाती सूत्र (भारत के महान गणितज्ञ श्रीधराचार्य का सूत्र)\nजब गुणनखंड आसानी से न टूटे, तो यह ब्रह्मास्त्र हमेशा काम करता है:\n$$D = b^2 - 4ac, \\qquad x = \\frac{-b \\pm \\sqrt{D}}{2a}$$\n\n**उदाहरण ($k$ का मान ज्ञात करना — BSEB का सबसे पसंदीदा प्रश्न):**\nयदि $2x^2 + kx + 3 = 0$ के दोनों मूल बराबर हैं, तो $k$ ज्ञात करें।\n- यहाँ $a = 2, b = k, c = 3$।\n- बराबर मूलों के लिए $D = 0 \\implies b^2 - 4ac = 0$\n- $k^2 - 4(2)(3) = 0 \\implies k^2 = 24 \\implies k = \\pm \\sqrt{24} = \\pm 2\\sqrt{6}$।",
      "concept_md_en": "### Quadratic Formula (Shridharacharya's Formula)\nWhenever splitting the middle term feels tricky, this universal formula ALWAYS works:\n$$D = b^2 - 4ac, \\qquad x = \\frac{-b \\pm \\sqrt{D}}{2a}$$\n\n**Classic BSEB Example (Find $k$ for equal roots):**\nIf $2x^2 + kx + 3 = 0$ has two equal roots, find $k$.\n- Here $a = 2, b = k, c = 3$.\n- Equal roots $\\implies D = 0 \\implies k^2 - 4(2)(3) = 0 \\implies k^2 = 24 \\implies k = \\pm 2\\sqrt{6}$.",
      "exam_tip_hi": "सावधानी: $k^2 = 24$ का वर्गमूल निकालते समय हमेशा **$\\pm$ (प्लस-माइनस दोनों)** लिखें — सिर्फ $+2\\sqrt{6}$ लिखने पर आधा अंक कट सकता है!",
      "exam_tip_en": "Watch out: When taking the square root of $k^2 = 24$, always include **both $\\pm$ signs** ($\\pm 2\\sqrt{6}$) to get full credit!",
      "glossary_terms": [
        {
          "term_hi": "विविक्तकर (Discriminant, D)",
          "term_en": "Discriminant (D)",
          "definition_hi": "व्यंजक $b^2 - 4ac$ जो द्विघात समीकरण के मूलों की प्रकृति बताता है।",
          "definition_en": "The expression $b^2 - 4ac$ that determines the nature of roots."
        }
      ]
    },
    {
      "id": "math-sec-3-flowchart",
      "order": 3,
      "heading_hi": "3. परीक्षा में कौन-सी विधि चुनें? (स्मार्ट निर्णय चार्ट)",
      "heading_en": "3. Which Method Should You Choose in the Exam? (Decision Flowchart)",
      "analogy_hi": "हर ताले की एक सबसे तेज़ चाबी होती है — सवाल देखते ही 3 सेकंड में सही विधि चुनिए और 2 मिनट बचाइए!",
      "analogy_en": "Every lock has a fastest key — pick the right method in 3 seconds and save precious exam minutes!",
      "visual_diagram": {
        "type": "FLOWCHART",
        "title_hi": "द्विघात समीकरण हल करने का 3-चरण फ्लोचार्ट",
        "title_en": "3-Step Decision Flowchart for Solving Quadratic Equations",
        "direction": "TB",
        "steps": [
          { "id": "s1", "label_hi": "चरण 1: मानक रूप ax² + bx + c = 0 में लिखें", "label_en": "Step 1: Rewrite in standard form ax² + bx + c = 0", "accent": "indigo" },
          { "id": "s2", "label_hi": "चरण 2: D = b² − 4ac निकालें", "label_en": "Step 2: Compute D = b² − 4ac", "accent": "amber" },
          { "id": "s3", "label_hi": "यदि D < 0 → रुकें! 'कोई वास्तविक मूल नहीं' लिखें", "label_en": "If D < 0 → Stop! Write 'No real roots'", "accent": "slate" },
          { "id": "s4", "label_hi": "यदि D ≥ 0 → गुणनखंड या x = (−b ± √D)/2a से मूल निकालें", "label_en": "If D ≥ 0 → Factorise or apply x = (−b ± √D)/2a", "accent": "emerald" }
        ],
        "edges": [
          { "from": "s1", "to": "s2" },
          { "from": "s2", "to": "s3", "label_hi": "D < 0", "label_en": "D < 0" },
          { "from": "s2", "to": "s4", "label_hi": "D ≥ 0", "label_en": "D ≥ 0" }
        ]
      },
      "concept_md_hi": "### मूलों से वापस द्विघात समीकरण बनाना\nयदि किसी द्विघात समीकरण के दो मूल $\\alpha$ और $\\beta$ दिए गए हों, तो समीकरण होगा:\n$$x^2 - (\\alpha + \\beta)x + \\alpha\\beta = 0$$",
      "concept_md_en": "### Forming a Quadratic Equation from Given Roots\nIf the two roots $\\alpha$ and $\\beta$ are given, the quadratic equation is:\n$$x^2 - (\\alpha + \\beta)x + \\alpha\\beta = 0$$",
      "exam_tip_hi": "आयु, रेलगाड़ी या आयत वाले 5-अंक के प्रश्नों में अंतिम उत्तर में **ऋणात्मक समय/दूरी/आयु को अमान्य (Rejected)** लिखना न भूलें!",
      "exam_tip_en": "In 5-mark word problems (age, train speed, field sides), always reject negative values of speed, length, or age explicitly!",
      "glossary_terms": []
    }
  ]$json$::jsonb,
  $json${
    "important_formulas": [
      { "latex": "D = b^2 - 4ac", "label_hi": "विविक्तकर (Discriminant)", "label_en": "Discriminant" },
      { "latex": "x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}", "label_hi": "द्विघाती (श्रीधराचार्य) सूत्र", "label_en": "Quadratic Formula" },
      { "latex": "\\alpha + \\beta = -\\frac{b}{a},\\quad \\alpha\\beta = \\frac{c}{a}", "label_hi": "मूलों का योग व गुणनफल", "label_en": "Sum & Product of Roots" }
    ],
    "key_dates_or_facts": [
      { "tag": "a ≠ 0", "fact_hi": "द्विघात समीकरण के लिए x² का गुणांक a कभी शून्य नहीं हो सकता।", "fact_en": "Coefficient a of x² can never be zero." },
      { "tag": "D = 0", "fact_hi": "बराबर मूलों की शर्त: b² = 4ac, और प्रत्येक मूल = −b / 2a।", "fact_en": "Condition for equal roots: b² = 4ac, and each root = −b / 2a." }
    ],
    "common_bseb_mistakes": [
      {
        "mistake_hi": "यदि b ऋणात्मक (जैसे b = -5) हो, तो b² को -25 लिख देना।",
        "mistake_en": "Writing (-5)² as -25 instead of +25.",
        "fix_hi": "किसी भी ऋणात्मक संख्या का वर्ग हमेशा धनात्मक होता है: (-5)² = +25।",
        "fix_en": "Always wrap negative b in brackets: (-5)² = +25."
      }
    ],
    "high_yield_pyq_topics": [
      { "topic_hi": "विविक्तकर D निकालना व मूलों की प्रकृति", "topic_en": "Discriminant & Nature of Roots", "years": ["2022", "2023", "2024"], "expected_marks": 4 },
      { "topic_hi": "बराबर मूलों के लिए k का मान", "topic_en": "Finding k for Equal Roots", "years": ["2021", "2023", "2024"], "expected_marks": 2 },
      { "topic_hi": "रेलगाड़ी / आयु / संख्या पर इबारती प्रश्न", "topic_en": "Word Problems (Train / Age / Numbers)", "years": ["2022", "2024"], "expected_marks": 5 }
    ]
  }$json$::jsonb,
  $json${
    "hindi_reviewed": true,
    "english_reviewed": true,
    "visuals_count": 3,
    "analogy_count": 3,
    "bseb_pyq_mapped": true,
    "syllabus_year": "2026-27"
  }$json$::jsonb,
  'PUBLISHED',
  1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json = EXCLUDED.mindmap_json, sections_json = EXCLUDED.sections_json,
  board_capsule_json = EXCLUDED.board_capsule_json, quality_checks_json = EXCLUDED.quality_checks_json,
  status = EXCLUDED.status, version = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'bseb-10-math-ch4',
  5,
  'छात्र द्विघात समीकरण की पहचान कर सकेंगे, गुणनखंड व श्रीधराचार्य सूत्र से मूल निकाल सकेंगे, विविक्तकर D से मूलों की प्रकृति बता सकेंगे तथा दैनिक जीवन के इबारती प्रश्न हल कर सकेंगे।',
  'Students will identify quadratic equations, compute roots via factorisation and Shridharacharya formula, classify roots using discriminant D, and formulate equations for real-life word problems.',
  $json$[
    {
      "period_no": 1, "duration_mins": 40,
      "phase_hi": "खेत के क्षेत्रफल से द्विघात समीकरण की अवधारणा", "phase_en": "Motivating Quadratics via Field Area",
      "teacher_action_hi": "बोर्ड पर एक आयताकार खेत बनाकर x(x+2) = 80 से मानक रूप ax² + bx + c = 0 समझाएँ।",
      "teacher_action_en": "Sketch a rectangular field to derive x(x+2)=80 and introduce ax²+bx+c=0.",
      "student_check_hi": "पूछें: क्या (x+1)² = x² + 3x + 5 द्विघात समीकरण है? (नहीं, x² कट जाता है!)",
      "student_check_en": "Check: Is (x+1)² = x² + 3x + 5 quadratic? (No — x² cancels out!)"
    },
    {
      "period_no": 2, "duration_mins": 40,
      "phase_hi": "मध्य पद विभाजन (गुणनखंड विधि)", "phase_en": "Factorisation by Splitting Middle Term",
      "teacher_action_hi": "गुणा-जोड़ तालिका (Product = ac, Sum = b) से 4 क्रमिक प्रश्न कराएँ (धन और ऋण चिह्नों सहित)।",
      "teacher_action_en": "Use the Product=ac, Sum=b box across 4 sign combinations.",
      "student_check_hi": "कमज़ोर छात्रों से चिह्न नियम (+ × − = −, − × − = +) दोहरवाएँ।",
      "student_check_en": "Drill sign rules with weaker learners before independent practice."
    },
    {
      "period_no": 3, "duration_mins": 40,
      "phase_hi": "विविक्तकर D व श्रीधराचार्य सूत्र", "phase_en": "Discriminant D & Quadratic Formula",
      "teacher_action_hi": "परवलय के 3 चित्र (2 कटान, 1 स्पर्श, 0 कटान) बनाकर D>0, D=0, D<0 समझाएँ।",
      "teacher_action_en": "Draw the 3 parabola sketches (2 cuts, 1 touch, 0 cuts) to explain D>0, D=0, D<0 visually.",
      "student_check_hi": "सभी छात्रों से 2x² - 4x + 3 = 0 का D निकलवाएँ।",
      "student_check_en": "Have every student compute D for 2x² - 4x + 3 = 0."
    },
    {
      "period_no": 4, "duration_mins": 40,
      "phase_hi": "इबारती प्रश्न (रेलगाड़ी, आयु, संख्याएँ)", "phase_en": "Word Problems (Train, Age, Numbers)",
      "teacher_action_hi": "समय = दूरी / चाल से रेलगाड़ी वाले बोर्ड प्रश्न को 4 सरल चरणों में तोड़कर हल कराएँ।",
      "teacher_action_en": "Break the classic BSEB train-speed problem into 4 clean algebraic steps.",
      "student_check_hi": "पूछें: यदि चाल का मान x = 40 और x = -45 आए, तो कौन-सा मान्य है?",
      "student_check_en": "Ask: Between speed x = 40 and x = -45, which must be rejected and why?"
    },
    {
      "period_no": 5, "duration_mins": 40,
      "phase_hi": "बोर्ड अभ्यास व लाइव टेस्ट", "phase_en": "Board Practice & Live Quiz",
      "teacher_action_hi": "विगत 5 वर्षों के BSEB ऑब्जेक्टिव व k-मान वाले प्रश्नों का लाइव अभ्यास कराएँ।",
      "teacher_action_en": "Run a 15-minute live MCQ & short-answer revision on past 5-year BSEB questions.",
      "student_check_hi": "सबसे अधिक गलतियों वाले प्रश्न को तुरंत बोर्ड पर स्पष्ट करें।",
      "student_check_en": "Debrief the top-missed question live on the blackboard."
    }
  ]$json$::jsonb,
  $json$[
    {
      "heading_hi": "ब्लैकबोर्ड कुंजी (द्विघात समीकरण)",
      "heading_en": "Blackboard Key (Quadratic Equations)",
      "points_hi": [
        "मानक रूप: ax² + bx + c = 0 (a ≠ 0)",
        "विविक्तकर: D = b² − 4ac",
        "श्रीधराचार्य सूत्र: x = (−b ± √D) / 2a",
        "D > 0 (दो भिन्न वास्तविक) | D = 0 (दो बराबर) | D < 0 (कोई वास्तविक मूल नहीं)"
      ],
      "points_en": [
        "Standard form: ax² + bx + c = 0 (a ≠ 0)",
        "Discriminant: D = b² − 4ac",
        "Quadratic formula: x = (−b ± √D) / 2a",
        "D > 0 (2 distinct real) | D = 0 (2 equal real) | D < 0 (no real roots)"
      ]
    }
  ]$json$::jsonb,
  $json$[
    {
      "title_hi": "गुणनखंड जोड़ी कार्ड खेल",
      "title_en": "Factor-Pair Card Match",
      "materials_hi": "कागज़ की पर्चियाँ जिन पर ac और b के मान लिखे हों",
      "materials_en": "Paper slips showing target product (ac) and sum (b)",
      "steps_hi": "छात्रों को 2-2 की जोड़ी में बाँटें; एक पर्ची पर लिखा होगा 'गुणा = 12, जोड़ = -7' और छात्रों को 15 सेकंड में (-3, -4) बताना होगा।",
      "steps_en": "Pair up students; each card shows e.g. 'Product = 12, Sum = -7' and pairs race to call out (-3, -4) in 15 seconds."
    }
  ]$json$::jsonb,
  $json$[
    { "level": "FOUNDATION", "task_hi": "समीकरण x² − 7x + 12 = 0 और x² + 5x + 6 = 0 को गुणनखंड विधि से हल करें।", "task_en": "Solve x² − 7x + 12 = 0 and x² + 5x + 6 = 0 by factorisation." },
    { "level": "BOARD", "task_hi": "k का मान ज्ञात करें यदि kx(x − 2) + 6 = 0 के दो बराबर मूल हों।", "task_en": "Find the value of k if kx(x − 2) + 6 = 0 has two equal roots." },
    { "level": "CHALLENGE", "task_hi": "दो क्रमागत धनात्मक पूर्णांक ज्ञात करें जिनके वर्गों का योग 365 हो।", "task_en": "Find two consecutive positive integers whose sum of squares is 365." }
  ]$json$::jsonb,
  $json$[
    {
      "misconception_hi": "छात्र x² = 16 से केवल x = 4 लिखते हैं, x = -4 भूल जाते हैं।",
      "misconception_en": "Students write only x = 4 from x² = 16 and forget x = -4.",
      "correction_hi": "दिखाएँ कि (−4) × (−4) भी +16 होता है, इसलिए द्विघात समीकरण के हमेशा 2 मूल होते हैं।",
      "correction_en": "Demonstrate (−4)×(−4) = +16 too, so quadratics always carry two roots."
    }
  ]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods = EXCLUDED.duration_periods, objectives_hi = EXCLUDED.objectives_hi,
  objectives_en = EXCLUDED.objectives_en, teaching_steps_json = EXCLUDED.teaching_steps_json,
  blackboard_points_json = EXCLUDED.blackboard_points_json, classroom_activities_json = EXCLUDED.classroom_activities_json,
  homework_json = EXCLUDED.homework_json, common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  (
    '10000000-0020-4000-8000-000000000001', 'bseb-10-math', 'bseb-10-math-ch4', 'Quadratic Formula', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'श्रीधराचार्य सूत्र और विविक्तकर क्या है?',
    'What is the Shridharacharya Quadratic Formula and Discriminant?',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "FLASHCARD",
      "front_hi": "द्विघात समीकरण ax² + bx + c = 0 के लिए विविक्तकर (D) और मूल (x) का सूत्र क्या है?",
      "front_en": "State the Discriminant (D) and Quadratic Formula for ax² + bx + c = 0.",
      "back_hi": "D = b² − 4ac तथा x = (−b ± √D) / 2a। यदि D = 0 हो तो दोनों बराबर मूल x = −b / 2a होते हैं।",
      "back_en": "D = b² − 4ac and x = (−b ± √D) / 2a. When D = 0, both equal roots equal −b / 2a.",
      "formula_latex": "x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}"
    }$json$::jsonb, true
  ),
  (
    '10000000-0020-4000-8000-000000000002', 'bseb-10-math', 'bseb-10-math-ch4', 'Discriminant Cases', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'विविक्तकर (D) की स्थिति को मूलों की सही प्रकृति से मिलाएँ:',
    'Match each Discriminant condition with the correct nature of roots:',
    NULL, NULL,
    'D का चिह्न देखें: +, 0 या −।',
    'Check the sign of D: positive, zero, or negative.',
    'D > 0 पर दो अलग वास्तविक मूल, D = 0 पर दो समान वास्तविक मूल और D < 0 पर कोई वास्तविक मूल नहीं होता।',
    'D > 0 yields two distinct real roots, D = 0 gives equal real roots, and D < 0 means no real roots.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "MATCH_PAIRS",
      "instruction_hi": "सही जोड़े मिलाएँ",
      "instruction_en": "Match each condition to its outcome",
      "pairs": [
        { "id": "q1", "left_hi": "D > 0 (b² > 4ac)", "left_en": "D > 0 (b² > 4ac)", "right_hi": "दो भिन्न वास्तविक मूल", "right_en": "Two distinct real roots" },
        { "id": "q2", "left_hi": "D = 0 (b² = 4ac)", "left_en": "D = 0 (b² = 4ac)", "right_hi": "दो समान वास्तविक मूल (−b/2a)", "right_en": "Two equal real roots (−b/2a)" },
        { "id": "q3", "left_hi": "D < 0 (b² < 4ac)", "left_en": "D < 0 (b² < 4ac)", "right_hi": "कोई वास्तविक मूल नहीं", "right_en": "No real roots" },
        { "id": "q4", "left_hi": "मूलों का योग (α + β)", "left_en": "Sum of roots (α + β)", "right_hi": "−b / a", "right_en": "−b / a" }
      ]
    }$json$::jsonb, true
  ),
  (
    '10000000-0020-4000-8000-000000000003', 'bseb-10-math', 'bseb-10-math-ch4', 'Discriminant Value', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    'द्विघात समीकरण $2x^2 - 4x + 3 = 0$ का विविक्तकर (Discriminant) क्या होगा?',
    'What is the discriminant of the quadratic equation $2x^2 - 4x + 3 = 0$?',
    '[{"key":"A","text_hi":"-4","text_en":"-4"},{"key":"B","text_hi":"0","text_en":"0"},{"key":"C","text_hi":"-8","text_en":"-8"},{"key":"D","text_hi":"40","text_en":"40"}]'::jsonb,
    'C',
    'यहाँ $a=2, b=-4, c=3$ है। $D = b^2 - 4ac$ में मान रखें।',
    'Identify $a=2, b=-4, c=3$ and plug into $D = b^2 - 4ac$.',
    '$D = (-4)^2 - 4(2)(3) = 16 - 24 = -8$। चूँकि $D < 0$, इसके कोई वास्तविक मूल नहीं हैं।',
    '$D = (-4)^2 - 4(2)(3) = 16 - 24 = -8$. Since $D < 0$, it has no real roots.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0020-4000-8000-000000000004', 'bseb-10-math', 'bseb-10-math-ch4', 'Equal Roots k', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'यदि द्विघात समीकरण $x^2 - 4x + k = 0$ के मूल समान हों, तो $k$ का मान क्या होगा?',
    'If the roots of $x^2 - 4x + k = 0$ are equal, what is the value of $k$?',
    '[{"key":"A","text_hi":"2","text_en":"2"},{"key":"B","text_hi":"4","text_en":"4"},{"key":"C","text_hi":"-4","text_en":"-4"},{"key":"D","text_hi":"16","text_en":"16"}]'::jsonb,
    'B',
    'समान मूल के लिए $D = b^2 - 4ac = 0$ रखें।',
    'Set $D = b^2 - 4ac = 0$ for equal roots.',
    '$a = 1, b = -4, c = k$। $(-4)^2 - 4(1)(k) = 0 \\Rightarrow 16 = 4k \\Rightarrow k = 4$।',
    '$a = 1, b = -4, c = k$. $(-4)^2 - 4(1)(k) = 0 \\Rightarrow 16 = 4k \\Rightarrow k = 4$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0020-4000-8000-000000000005', 'bseb-10-math', 'bseb-10-math-ch4', 'Sum of Roots', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'द्विघात समीकरण $3x^2 - 12x + 5 = 0$ के मूलों का योगफल कितना होगा?',
    'What is the sum of the roots of the quadratic equation $3x^2 - 12x + 5 = 0$?',
    '[{"key":"A","text_hi":"-4","text_en":"-4"},{"key":"B","text_hi":"4","text_en":"4"},{"key":"C","text_hi":"5/3","text_en":"5/3"},{"key":"D","text_hi":"-5/3","text_en":"-5/3"}]'::jsonb,
    'B',
    'मूलों का योग $= -b / a$ होता है; $b = -12$ का ऋण चिह्न ध्यान रखें।',
    'Sum of roots $= -b / a$; watch the minus sign of $b = -12$.',
    '$\\alpha + \\beta = -\\frac{b}{a} = -\\frac{-12}{3} = +4$।',
    '$\\alpha + \\beta = -\\frac{b}{a} = -\\frac{-12}{3} = +4$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0020-4000-8000-000000000006', 'bseb-10-math', 'bseb-10-math-ch4', 'Factorisation', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2022',
    'समीकरण $6x^2 - x - 2 = 0$ के दोनों मूल क्या हैं?',
    'What are the two roots of $6x^2 - x - 2 = 0$?',
    '[{"key":"A","text_hi":"2/3 और -1/2","text_en":"2/3 and -1/2"},{"key":"B","text_hi":"-2/3 और 1/2","text_en":"-2/3 and 1/2"},{"key":"C","text_hi":"3/2 और -2","text_en":"3/2 and -2"},{"key":"D","text_hi":"1/3 और -2","text_en":"1/3 and -2"}]'::jsonb,
    'A',
    '$ac = -12$, मध्य पद $-x$ को $-4x + 3x$ में तोड़ें।',
    '$ac = -12$; split $-x$ as $-4x + 3x$.',
    '$6x^2 - 4x + 3x - 2 = 0 \\Rightarrow 2x(3x-2) + 1(3x-2) = 0 \\Rightarrow (3x-2)(2x+1) = 0 \\Rightarrow x = \\frac{2}{3}, -\\frac{1}{2}$।',
    '$6x^2 - 4x + 3x - 2 = 0 \\Rightarrow (3x-2)(2x+1) = 0 \\Rightarrow x = \\frac{2}{3}, -\\frac{1}{2}$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0020-4000-8000-000000000007', 'bseb-10-math', 'bseb-10-math-ch4', 'Equal Roots 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'समीकरण $2x^2 + kx + 3 = 0$ में $k$ का ऐसा मान ज्ञात करें जिसके लिए समीकरण के दो बराबर मूल हों।',
    'Find the values of $k$ for which the quadratic equation $2x^2 + kx + 3 = 0$ has two equal roots.',
    NULL, NULL,
    '$a=2, b=k, c=3$ लेकर $D = b^2 - 4ac = 0$ हल करें।',
    'Put $a=2, b=k, c=3$ into $D = b^2 - 4ac = 0$.',
    NULL, NULL,
    'दिए गए समीकरण $2x^2 + kx + 3 = 0$ की तुलना $ax^2 + bx + c = 0$ से करने पर:\n$a = 2,\\ b = k,\\ c = 3$\n\nचूँकि दोनों मूल बराबर हैं, अतः विविक्तकर $D = 0$:\n$$b^2 - 4ac = 0 \\implies k^2 - 4(2)(3) = 0$$\n$$k^2 - 24 = 0 \\implies k^2 = 24 \\implies k = \\pm\\sqrt{24} = \\pm 2\\sqrt{6}$$',
    'Comparing $2x^2 + kx + 3 = 0$ with $ax^2 + bx + c = 0$: $a = 2, b = k, c = 3$.\nFor two equal roots, $D = 0$:\n$$k^2 - 4(2)(3) = 0 \\implies k^2 = 24 \\implies k = \\pm 2\\sqrt{6}$$',
    '[{"cue_hi":"समान मूल ⇒ D = 0","cue_en":"Equal roots ⇒ D = 0"},{"cue_hi":"उत्तर में ± दोनों चिह्न लिखें","cue_en":"Include ± sign in square root"}]'::jsonb,
    '[{"step_no":1,"marks":0.5,"criterion_hi":"a, b, c का सही मान पहचानना","criterion_en":"Identifies a=2, b=k, c=3"},{"step_no":2,"marks":0.5,"criterion_hi":"D = b² - 4ac = 0 की शर्त लिखना","criterion_en":"States condition b² - 4ac = 0"},{"step_no":3,"marks":1,"criterion_hi":"k = ±2√6 की सही गणना","criterion_en":"Solves accurately for k = ±2√6"}]'::jsonb,
    NULL, true
  ),
  (
    '10000000-0020-4000-8000-000000000008', 'bseb-10-math', 'bseb-10-math-ch4', 'Train Speed Word Problem 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    'एक रेलगाड़ी एकसमान चाल से $360\\text{ km}$ की दूरी तय करती है। यदि यह चाल $5\\text{ km/h}$ अधिक होती, तो वह उसी यात्रा में $1\\text{ घंटा}$ कम समय लेती। रेलगाड़ी की चाल ज्ञात करें।',
    'A train travels $360\\text{ km}$ at a uniform speed. If the speed had been $5\\text{ km/h}$ more, it would have taken $1\\text{ hour}$ less for the same journey. Find the speed of the train.',
    NULL, NULL,
    'माना चाल $= x\\text{ km/h}$। तब $\\frac{360}{x} - \\frac{360}{x+5} = 1$।',
    'Let speed $= x\\text{ km/h}$. Form $\\frac{360}{x} - \\frac{360}{x+5} = 1$.',
    NULL, NULL,
    'माना रेलगाड़ी की सामान्य चाल $= x\\text{ km/h}$।\n- सामान्य समय $t_1 = \\frac{360}{x}\\text{ घंटे}$\n- चाल $5\\text{ km/h}$ बढ़ाने पर नई चाल $= (x + 5)\\text{ km/h}$, नया समय $t_2 = \\frac{360}{x + 5}\\text{ घंटे}$\n\n**प्रश्नानुसार:**\n$$\\frac{360}{x} - \\frac{360}{x+5} = 1$$\n$$360\\left[\\frac{(x+5) - x}{x(x+5)}\\right] = 1 \\implies \\frac{1800}{x^2 + 5x} = 1$$\n$$x^2 + 5x - 1800 = 0$$\n\n**गुणनखंड द्वारा हल ($45 \\times 40 = 1800$ तथा $45 - 40 = 5$):**\n$$x^2 + 45x - 40x - 1800 = 0 \\implies (x + 45)(x - 40) = 0$$\n$$x = -45 \\quad \\text{या} \\quad x = 40$$\nचूँकि चाल ऋणात्मक नहीं हो सकती, अतः $x = -45$ अमान्य है।\n\n**उत्तर:** रेलगाड़ी की चाल **$40\\text{ km/h}$** है।',
    'Let the uniform speed of the train be $x\\text{ km/h}$.\n- Usual time $= \\frac{360}{x}$ hours; faster time $= \\frac{360}{x+5}$ hours.\n\n**According to the problem:**\n$$\\frac{360}{x} - \\frac{360}{x+5} = 1 \\implies \\frac{360 \\times 5}{x(x+5)} = 1 \\implies x^2 + 5x - 1800 = 0$$\n\n**Factorising ($45 \\times 40 = 1800$ and $45 - 40 = 5$):**\n$$(x + 45)(x - 40) = 0 \\implies x = -45 \\text{ or } x = 40$$\nSince speed cannot be negative, reject $x = -45$.\n\n**Answer:** Speed of the train is **$40\\text{ km/h}$**.',
    '[{"cue_hi":"समय = दूरी / चाल","cue_en":"Time = Distance / Speed"},{"cue_hi":"1800 = 45 × 40 (अंतर = 5)","cue_en":"1800 = 45 × 40 (diff = 5)"},{"cue_hi":"ऋणात्मक चाल अमान्य लिखें","cue_en":"Reject negative speed explicitly"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"चर x मानकर दोनों समय व्यंजक लिखना","criterion_en":"Defines x and writes both time expressions"},{"step_no":2,"marks":1.5,"criterion_hi":"द्विघात समीकरण x² + 5x - 1800 = 0 बनाना","criterion_en":"Derives x² + 5x - 1800 = 0 accurately"},{"step_no":3,"marks":1.5,"criterion_hi":"गुणनखंड या सूत्र से x = 40, -45 निकालना","criterion_en":"Solves roots x = 40 and x = -45"},{"step_no":4,"marks":1,"criterion_hi":"ऋणात्मक मान अस्वीकार कर अंतिम उत्तर 40 km/h लिखना","criterion_en":"Rejects negative root and states 40 km/h with units"}]'::jsonb,
    NULL, true
  )
ON CONFLICT (id) DO UPDATE SET
  q_hi = EXCLUDED.q_hi, q_en = EXCLUDED.q_en, options_json = EXCLUDED.options_json,
  correct_option = EXCLUDED.correct_option, explanation_hi = EXCLUDED.explanation_hi,
  explanation_en = EXCLUDED.explanation_en, model_answer_hi = EXCLUDED.model_answer_hi,
  model_answer_en = EXCLUDED.model_answer_en, marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json = EXCLUDED.visual_asset_json, bank_pool = EXCLUDED.bank_pool;

-- #############################################################################
-- CHAPTER 3 OF 6: CLASS 10 SST CH 1 — NATIONALISM IN INDIA & CHAMPARAN (बिहार)
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-10-sst-ch1',
  $json${
    "title_hi": "30-सेकंड माइंडमैप: भारत में राष्ट्रवाद एवं बिहार का चम्पारण सत्याग्रह",
    "title_en": "30-Second Mindmap: Nationalism in India & Bihar's Champaran Satyagraha",
    "read_time_seconds": 30,
    "central_node": {
      "id": "nat-root",
      "label_hi": "भारत में राष्ट्रवाद (1915–1942)",
      "label_en": "Indian Nationalism (1915–1942)",
      "subtitle_hi": "सत्य और अहिंसा से आज़ादी की जन-क्रांति",
      "subtitle_en": "Mass freedom movement through Truth & Non-violence"
    },
    "branches": [
      {
        "id": "n-champaran",
        "label_hi": "1. चम्पारण सत्याग्रह (1917 — बिहार!)",
        "label_en": "1. Champaran Satyagraha (1917 — Bihar!)",
        "color": "#B45309",
        "children": [
          { "id": "nc1", "label_hi": "तिनकठिया प्रथा: 3/20 हिस्से पर नील की जबरन खेती", "label_en": "Tinkathia System: Forced indigo on 3/20 of land" },
          { "id": "nc2", "label_hi": "राजकुमार शुक्ल ने गांधीजी को चम्पारण बुलाया", "label_en": "Raj Kumar Shukla invited Mahatma Gandhi to Bihar" },
          { "id": "nc3", "label_hi": "भारत में गांधीजी का पहला सफल सत्याग्रह", "label_en": "Gandhi's first successful Satyagraha in India" }
        ]
      },
      {
        "id": "n-1919",
        "label_hi": "2. 1919 का मोड़",
        "label_en": "2. Turning Point of 1919",
        "color": "#DC2626",
        "children": [
          { "id": "n19a", "label_hi": "रॉलेट एक्ट (काला कानून): बिना मुकदमे 2 साल जेल", "label_en": "Rowlatt Act: 2-year jail without trial" },
          { "id": "n19b", "label_hi": "जलियांवाला बाग (13 अप्रैल 1919): जनरल डायर", "label_en": "Jallianwala Bagh (13 Apr 1919): General Dyer" }
        ]
      },
      {
        "id": "n-ncm",
        "label_hi": "3. असहयोग आंदोलन (1920–1922)",
        "label_en": "3. Non-Cooperation Movement (1920–1922)",
        "color": "#1E3A8A",
        "children": [
          { "id": "nnc1", "label_hi": "विदेशी वस्त्र बहिष्कार, खादी व राष्ट्रीय विद्यालय", "label_en": "Boycott of foreign cloth, Khadi & national schools" },
          { "id": "nnc2", "label_hi": "चौरी-चौरा कांड (5 फ़रवरी 1922) के बाद स्थगित", "label_en": "Called off after Chauri Chaura (5 Feb 1922)" }
        ]
      },
      {
        "id": "n-cdm",
        "label_hi": "4. सविनय अवज्ञा व भारत छोड़ो",
        "label_en": "4. Civil Disobedience & Quit India",
        "color": "#059669",
        "children": [
          { "id": "ncd1", "label_hi": "दांडी मार्च (12 मार्च – 6 अप्रैल 1930): नमक कानून तोड़ा", "label_en": "Dandi March (12 Mar – 6 Apr 1930): Broke Salt Law" },
          { "id": "ncd2", "label_hi": "भारत छोड़ो (अगस्त 1942): 'करो या मरो' व पटना सचिवालय शहीद", "label_en": "Quit India (Aug 1942): 'Do or Die' & Patna Martyrs" }
        ]
      }
    ]
  }$json$::jsonb,
  $json$[
    {
      "id": "sst-sec-1-champaran",
      "order": 1,
      "heading_hi": "1. बिहार की धरती से स्वतंत्रता संग्राम की चिंगारी: चम्पारण सत्याग्रह (1917)",
      "heading_en": "1. The Spark from Bihar's Soil: Champaran Satyagraha (1917)",
      "analogy_hi": "कल्पना कीजिए कि किसी किसान के पास 1 बीघा (20 कट्ठा) खेत है और अंग्रेज़ मालिक ज़बरदस्ती कहें — 'अपनी सबसे उपजाऊ **3 कट्ठा** ज़मीन पर सिर्फ़ नील (Indigo) उगाओ, जबकि नील उगाने से खेत बंजर हो जाता है और दाम भी कौड़ियों के मिलते हैं!' यही थी **तिनकठिया प्रथा (3/20 भाग)**। चम्पारण के साहसी किसान **राजकुमार शुक्ल** लखनऊ अधिवेशन (1916) तक गए और महात्मा गांधी को बिहार की पीड़ा दिखाने चम्पारण ले आए!",
      "analogy_en": "Imagine owning 1 bigha (20 kathas) of fertile land and British planters forcing you to grow indigo on the best **3 kathas (3/20)** — exhausting the soil while paying almost nothing! That was the **Tinkathia System**. Determined Bihar peasant **Raj Kumar Shukla** followed Mahatma Gandhi from the 1916 Lucknow Congress session until Gandhi came to Champaran in April 1917!",
      "visual_diagram": {
        "type": "FLOWCHART",
        "title_hi": "चम्पारण सत्याग्रह (1917) — कारण से विजय तक",
        "title_en": "Champaran Satyagraha (1917) — From Cause to Victory",
        "direction": "LR",
        "steps": [
          { "id": "c1", "label_hi": "तिनकठिया प्रथा", "label_en": "Tinkathia System", "detail_hi": "20 कट्ठे में 3 कट्ठे पर जबरन नील की खेती", "detail_en": "Forced indigo on 3/20 of land", "accent": "slate" },
          { "id": "c2", "label_hi": "राजकुमार शुक्ल का निमंत्रण", "label_en": "Raj Kumar Shukla's Plea", "detail_hi": "लखनऊ अधिवेशन (1916) में गांधीजी से मिले", "detail_en": "Met Gandhi at Lucknow (1916)", "accent": "amber" },
          { "id": "c3", "label_hi": "अप्रैल 1917: मोतिहारी-बेतिया", "label_en": "Apr 1917: Motihari & Bettiah", "detail_hi": "डॉ. राजेंद्र प्रसाद, अनुग्रह बाबू साथ जुड़े", "detail_en": "Dr. Rajendra Prasad & Anugrah Narayan joined", "accent": "indigo" },
          { "id": "c4", "label_hi": "चम्पारण कृषि अधिनियम (1918)", "label_en": "Champaran Agrarian Act (1918)", "detail_hi": "तिनकठिया समाप्त, 25% लगान वापस!", "detail_en": "Tinkathia abolished, 25% refund!", "accent": "emerald" }
        ],
        "edges": [
          { "from": "c1", "to": "c2" },
          { "from": "c2", "to": "c3" },
          { "from": "c3", "to": "c4" }
        ]
      },
      "concept_md_hi": "### चम्पारण सत्याग्रह क्यों ऐतिहासिक है?\n- **पहली प्रयोगशाला:** दक्षिण अफ्रीका से 1915 में लौटने के बाद यह भारत में गांधीजी का **पहला सफल सत्याग्रह** था।\n- **बिहार के प्रमुख सहयोगी:** डॉ. राजेंद्र प्रसाद (भारत के प्रथम राष्ट्रपति), ब्रजकिशोर प्रसाद, अनुग्रह नारायण सिन्हा और आचार्य जे.बी. कृपलानी।\n- **परिणाम:** अंग्रेज़ सरकार को झुककर **चम्पारण एग्रेरियन कमिटी** बनानी पड़ी और **1918 में तिनकठिया प्रथा कानूनन समाप्त** कर दी गई।",
      "concept_md_en": "### Why Champaran Satyagraha Is Historic\n- **First Mass Test in India:** After returning from South Africa in 1915, this was Mahatma Gandhi's **first successful Satyagraha** on Indian soil.\n- **Key Bihar Leaders:** Dr. Rajendra Prasad (India's first President), Brajkishore Prasad, Anugrah Narayan Sinha, and Acharya J.B. Kripalani.\n- **Outcome:** The British had to form the Champaran Agrarian Committee and passed the **Champaran Agrarian Act (1918)** abolishing Tinkathia.",
      "exam_tip_hi": "BSEB में हर दूसरे साल पूछा जाता है: 'तिनकठिया प्रणाली किन पर लागू थी?' → **किसानों (चम्पारण के नील किसानों) पर**। 'गांधीजी को चम्पारण किसने बुलाया?' → **राजकुमार शुक्ल**।",
      "exam_tip_en": "Repeated BSEB MCQs: 'Who was Tinkathia imposed on?' → **Peasants (Champaran indigo farmers)**. 'Who invited Gandhi to Champaran?' → **Raj Kumar Shukla**.",
      "glossary_terms": [
        {
          "term_hi": "सत्याग्रह (Satyagraha)",
          "term_en": "Satyagraha",
          "definition_hi": "सत्य की शक्ति और अहिंसा के मार्ग से अन्याय के विरुद्ध शांतिपूर्ण संघर्ष।",
          "definition_en": "Peaceful resistance against injustice grounded in truth and non-violence."
        }
      ]
    },
    {
      "id": "sst-sec-2-timeline",
      "order": 2,
      "heading_hi": "2. स्वतंत्रता संग्राम की मास्टर समय-रेखा (1915–1942)",
      "heading_en": "2. Master Freedom Struggle Timeline (1915–1942)",
      "analogy_hi": "इतिहास की तारीखें अलग-अलग रटने पर भूल जाती हैं, लेकिन यदि उन्हें एक **फिल्म की कहानी** की तरह क्रम में देखें तो 10 सबसे ज़रूरी वर्ष हमेशा के लिए दिमाग में छप जाते हैं!",
      "analogy_en": "Isolated history dates are easy to forget, but when you read them in sequence like a **movie storyline**, all 10 board-exam years lock into memory forever!",
      "visual_diagram": {
        "type": "TIMELINE",
        "title_hi": "भारतीय राष्ट्रीय आंदोलन की प्रमुख तिथियाँ (BSEB सुपर-हिट)",
        "title_en": "Key Milestones of the Indian National Movement (BSEB High-Yield)",
        "events": [
          { "year": "1915", "title_hi": "गांधीजी का भारत आगमन", "title_en": "Gandhi returns to India", "detail_hi": "9 जनवरी 1915 को दक्षिण अफ्रीका से भारत लौटे।", "detail_en": "Returned from South Africa on 9 January 1915." },
          { "year": "1917", "title_hi": "चम्पारण सत्याग्रह (बिहार)", "title_en": "Champaran Satyagraha (Bihar)", "detail_hi": "तिनकठिया नील प्रथा के विरुद्ध पहला सफल सत्याग्रह।", "detail_en": "First successful Satyagraha in India against Tinkathia.", "highlight": true },
          { "year": "1919", "title_hi": "रॉलेट एक्ट व जलियांवाला बाग", "title_en": "Rowlatt Act & Jallianwala Bagh", "detail_hi": "13 अप्रैल 1919 को अमृतसर में जनरल डायर ने गोली चलवाई; रवींद्रनाथ टैगोर ने 'नाइटहुड' लौटाई।", "detail_en": "13 April 1919 Amritsar massacre by Gen. Dyer; Tagore renounced Knighthood.", "highlight": true },
          { "year": "1920", "title_hi": "असहयोग आंदोलन की शुरुआत", "title_en": "Launch of Non-Cooperation", "detail_hi": "नागपुर कांग्रेस अधिवेशन में स्वीकृति; खिलाफत आंदोलन के साथ संयुक्त संघर्ष।", "detail_en": "Adopted at Nagpur Congress; united with Khilafat Movement." },
          { "year": "1922", "title_hi": "चौरी-चौरा कांड (5 फ़रवरी)", "title_en": "Chauri Chaura Incident (5 Feb)", "detail_hi": "गोरखपुर में थाने में आग लगने पर गांधीजी ने अहिंसा भंग होने से असहयोग आंदोलन वापस लिया।", "detail_en": "Police station burnt in Gorakhpur; Gandhi withdrew Non-Cooperation." },
          { "year": "1929", "title_hi": "लाहौर अधिवेशन — पूर्ण स्वराज", "title_en": "Lahore Congress — Purna Swaraj", "detail_hi": "जवाहरलाल नेहरू की अध्यक्षता में 26 जनवरी 1930 को स्वतंत्रता दिवस मनाने का संकल्प।", "detail_en": "Presided by J.L. Nehru; pledged Complete Independence." },
          { "year": "1930", "title_hi": "दांडी मार्च व सविनय अवज्ञा", "title_en": "Dandi March & Civil Disobedience", "detail_hi": "12 मार्च को साबरमती से 78 अनुयायियों के साथ 240 मील पैदल चलकर 6 अप्रैल को नमक बनाया।", "detail_en": "240-mile march with 78 volunteers; broke British Salt Law on 6 April.", "highlight": true },
          { "year": "1942", "title_hi": "भारत छोड़ो आंदोलन (अगस्त)", "title_en": "Quit India Movement (August)", "detail_hi": "'करो या मरो' का नारा; 11 अगस्त 1942 को पटना सचिवालय पर बिहार के 7 छात्र शहीद हुए!", "detail_en": "'Do or Die' call; 7 Bihar students martyred hoisting Tricolour at Patna Secretariat!", "highlight": true }
        ]
      },
      "concept_md_hi": "### असहयोग (1920) बनाम सविनय अवज्ञा (1930) — स्पष्ट अंतर समझें\nबहुत से छात्र इन दोनों आंदोलनों को आपस में मिला देते हैं। बस इतना याद रखें:\n- **असहयोग (Non-Cooperation):** अंग्रेज़ों का **सहयोग बंद करना** (स्कूल, अदालत, सरकारी नौकरी, विदेशी कपड़ों का बहिष्कार)।\n- **सविनय अवज्ञा (Civil Disobedience):** सहयोग बंद करने के साथ-साथ **अन्यायपूर्ण अंग्रेज़ी कानूनों को शांतिपूर्वक तोड़ना** (जैसे नमक कानून तोड़ना, चौकीदारी कर न देना — बिहार में चौकीदारी कर विरोधी आंदोलन बहुत प्रसिद्ध था!)।",
      "concept_md_en": "### Non-Cooperation (1920) vs Civil Disobedience (1930)\nStudents often mix up these two movements. Keep this crystal-clear difference in mind:\n- **Non-Cooperation:** Refusing to **cooperate** with British institutions (boycott of courts, schools, titles, foreign cloth).\n- **Civil Disobedience:** Not only refusing cooperation, but also **peacefully breaking unjust British laws** (breaking the Salt Law, refusing Chowkidari tax in Bihar!).",
      "exam_tip_hi": "बिहार-विशेष तथ्य: समुद्र न होने के कारण बिहार में सविनय अवज्ञा के दौरान **चौकीदारी कर (Chowkidari Tax)** के विरुद्ध ऐतिहासिक आंदोलन चला था!",
      "exam_tip_en": "Bihar-Specific Fact: Being landlocked, Bihar participated fiercely in Civil Disobedience through the **Anti-Chowkidari Tax** movement!",
      "glossary_terms": []
    },
    {
      "id": "sst-sec-3-comparison",
      "order": 3,
      "heading_hi": "3. तुलनात्मक तालिका: असहयोग बनाम सविनय अवज्ञा आंदोलन",
      "heading_en": "3. Comparison Table: Non-Cooperation vs Civil Disobedience",
      "analogy_hi": "परीक्षा में अंतर वाले प्रश्न को हमेशा **तालिका (Table)** बनाकर लिखें — परीक्षक को 2 सेकंड में पूरे बिंदु दिखते हैं और पूरे अंक मिलते हैं!",
      "analogy_en": "Always write 'Distinguish between' answers as a clean **2-column comparison table** — BSEB examiners award full marks quickly!",
      "visual_diagram": {
        "type": "COMPARISON_TABLE",
        "title_hi": "असहयोग आंदोलन (1920) बनाम सविनय अवज्ञा आंदोलन (1930)",
        "title_en": "Non-Cooperation Movement (1920) vs Civil Disobedience Movement (1930)",
        "headers_hi": ["आधार", "असहयोग आंदोलन (1920–22)", "सविनय अवज्ञा आंदोलन (1930–34)"],
        "headers_en": ["Basis", "Non-Cooperation (1920–22)", "Civil Disobedience (1930–34)"],
        "rows": [
          { "cells_hi": ["प्रमुख लक्ष्य", "स्वराज की प्राप्ति व खिलाफत समर्थन", "पूर्ण स्वराज (लाहौर संकल्प 1929)"], "cells_en": ["Main Goal", "Swaraj & Khilafat support", "Purna Swaraj (Complete Independence)"] },
          { "cells_hi": ["कार्यक्रम", "सरकारी उपाधि, स्कूल, कोर्ट व विदेशी वस्त्र बहिष्कार", "अंग्रेज़ी कानून (नमक कानून, लगान/चौकीदारी कर) तोड़ना"], "cells_en": ["Method", "Boycott of titles, schools, courts & foreign goods", "Peacefully breaking British laws (Salt & Chowkidari tax)"] },
          { "cells_hi": ["महिलाओं की भागीदारी", "सीमित स्तर पर", "अत्यधिक बड़े पैमाने पर महिलाओं ने भाग लिया"], "cells_en": ["Women's Role", "Limited participation", "Massive nationwide participation of women"] },
          { "cells_hi": ["समाप्ति का कारण", "चौरी-चौरा की हिंसक घटना (1922)", "गांधी-इरविन समझौता (1931) व बाद में 1934 में स्थगन"], "cells_en": ["End Reason", "Chauri Chaura violence (Feb 1922)", "Gandhi-Irwin Pact (1931) & suspension in 1934"] }
        ]
      },
      "concept_md_hi": "### याद रखें — 1931 का गांधी-इरविन समझौता व गोलमेज सम्मेलन\n5 मार्च 1931 को गांधीजी और वायसराय लॉर्ड इरविन के बीच समझौता हुआ, जिसके बाद गांधीजी **द्वितीय गोलमेज सम्मेलन (लंदन)** में शामिल हुए। 1932 में गांधीजी और डॉ. बी.आर. अंबेडकर के बीच **पूना पैक्ट (Poona Pact)** हुआ।",
      "concept_md_en": "### Key 1931–32 Pacts\nOn 5 March 1931, the **Gandhi-Irwin Pact** was signed, leading Gandhi to attend the **Second Round Table Conference** in London. In September 1932, the **Poona Pact** was signed between Mahatma Gandhi and Dr. B.R. Ambedkar.",
      "exam_tip_hi": "2-अंक का सीधा प्रश्न: 'पूना पैक्ट किनके बीच हुआ?' → **सितंबर 1932 में महात्मा गांधी और डॉ. भीमराव अंबेडकर के बीच**।",
      "exam_tip_en": "Direct BSEB question: 'Between whom was the Poona Pact signed?' → **Mahatma Gandhi and Dr. B.R. Ambedkar (September 1932)**.",
      "glossary_terms": []
    }
  ]$json$::jsonb,
  $json${
    "important_formulas": [],
    "key_dates_or_facts": [
      { "tag": "1917", "fact_hi": "चम्पारण सत्याग्रह — राजकुमार शुक्ल के निमंत्रण पर गांधीजी बिहार आए।", "fact_en": "Champaran Satyagraha — Gandhi came to Bihar on Raj Kumar Shukla's invitation." },
      { "tag": "13 Apr 1919", "fact_hi": "जलियांवाला बाग हत्याकांड (अमृतसर) — जनरल डायर ने गोली चलवाई।", "fact_en": "Jallianwala Bagh Massacre (Amritsar) ordered by General Dyer." },
      { "tag": "5 Feb 1922", "fact_hi": "चौरी-चौरा कांड — असहयोग आंदोलन स्थगित हुआ।", "fact_en": "Chauri Chaura incident — Non-Cooperation withdrawn." },
      { "tag": "12 Mar 1930", "fact_hi": "दांडी यात्रा प्रारंभ (6 अप्रैल 1930 को नमक कानून तोड़ा)।", "fact_en": "Dandi March began (Salt Law broken on 6 April 1930)." }
    ],
    "common_bseb_mistakes": [
      {
        "mistake_hi": "दांडी यात्रा शुरू होने (12 मार्च) और नमक कानून टूटने (6 अप्रैल) की तारीखें उलट देना।",
        "mistake_en": "Mixing up Dandi March start date (12 March) with Salt Law breaking date (6 April).",
        "fix_hi": "याद रखें: मार्च पहले आता है (12 मार्च को चले), 24 दिन पैदल चलकर अप्रैल में पहुँचे (6 अप्रैल को नमक बनाया)।",
        "fix_en": "March comes first (started 12 March); walked 24 days to reach Dandi on 6 April."
      }
    ],
    "high_yield_pyq_topics": [
      { "topic_hi": "चम्पारण सत्याग्रह व तिनकठिया प्रथा", "topic_en": "Champaran Satyagraha & Tinkathia", "years": ["2021", "2023", "2024"], "expected_marks": 5 },
      { "topic_hi": "रॉलेट एक्ट व जलियांवाला बाग", "topic_en": "Rowlatt Act & Jallianwala Bagh", "years": ["2022", "2023"], "expected_marks": 2 },
      { "topic_hi": "दांडी यात्रा व सविनय अवज्ञा आंदोलन", "topic_en": "Dandi March & Civil Disobedience", "years": ["2022", "2024"], "expected_marks": 5 }
    ]
  }$json$::jsonb,
  $json${
    "hindi_reviewed": true, "english_reviewed": true, "visuals_count": 3, "analogy_count": 3, "bseb_pyq_mapped": true, "syllabus_year": "2026-27"
  }$json$::jsonb,
  'PUBLISHED', 1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json = EXCLUDED.mindmap_json, sections_json = EXCLUDED.sections_json,
  board_capsule_json = EXCLUDED.board_capsule_json, quality_checks_json = EXCLUDED.quality_checks_json,
  status = EXCLUDED.status, version = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'bseb-10-sst-ch1',
  5,
  'विद्यार्थी बिहार के चम्पारण सत्याग्रह की ऐतिहासिक भूमिका समझेंगे, 1915–1942 की प्रमुख घटनाओं को क्रमानुसार याद रखेंगे तथा असहयोग व सविनय अवज्ञा आंदोलन का तुलनात्मक विश्लेषण कर सकेंगे।',
  'Students will appreciate Bihar''s Champaran Satyagraha, sequence major 1915–1942 freedom milestones accurately, and compare Non-Cooperation with Civil Disobedience.',
  $json$[
    { "period_no": 1, "duration_mins": 40, "phase_hi": "चम्पारण सत्याग्रह व बिहार का गौरव", "phase_en": "Champaran Satyagraha & Bihar's Heritage", "teacher_action_hi": "बिहार के नक्शे पर चम्पारण (मोतिहारी/बेतिया) दिखाकर तिनकठिया प्रथा (3/20) और राजकुमार शुक्ल की कहानी सुनाएँ।", "teacher_action_en": "Point out Champaran on the Bihar map and narrate Raj Kumar Shukla and the 3/20 Tinkathia story.", "student_check_hi": "पूछें: 1 बीघा = 20 कट्ठे में कितने कट्ठे पर नील बोना अनिवार्य था?", "student_check_en": "Ask: Out of 20 kathas, how many had to be planted with indigo?" },
    { "period_no": 2, "duration_mins": 40, "phase_hi": "रॉलेट एक्ट (1919) व जलियांवाला बाग", "phase_en": "Rowlatt Act & Jallianwala Bagh (1919)", "teacher_action_hi": "बिना अपील-बिना दलील कानून और 13 अप्रैल 1919 की घटना को कारण-परिणाम श्रृंखला में पढ़ाएँ।", "teacher_action_en": "Teach the 'no appeal, no lawyer' Rowlatt Act leading into 13 April 1919.", "student_check_hi": "पूछें: जलियांवाला बाग के विरोध में रवींद्रनाथ टैगोर ने कौन-सी उपाधि लौटाई?", "student_check_en": "Ask: Which British title did Rabindranath Tagore return in protest?" },
    { "period_no": 3, "duration_mins": 40, "phase_hi": "असहयोग आंदोलन व चौरी-चौरा (1920–22)", "phase_en": "Non-Cooperation & Chauri Chaura", "teacher_action_hi": "असहयोग के रचनात्मक व बहिष्कार कार्यक्रम बोर्ड पर लिखें और 5 फरवरी 1922 के मोड़ की चर्चा करें।", "teacher_action_en": "Contrast constructive programmes vs boycott, then explain the 5 Feb 1922 suspension.", "student_check_hi": "पूछें: गांधीजी ने चरमोत्कर्ष पर पहुँच चुका आंदोलन क्यों वापस लिया?", "student_check_en": "Ask: Why did Gandhi halt Non-Cooperation at its peak?" },
    { "period_no": 4, "duration_mins": 40, "phase_hi": "दांडी मार्च, सविनय अवज्ञा व बिहार का चौकीदारी कर आंदोलन", "phase_en": "Dandi March & Bihar's Anti-Chowkidari Movement", "teacher_action_hi": "अंग्रेज़ी नमक कानून और बिहार में चौकीदारी कर के विरोध को जोड़कर समझाएँ।", "teacher_action_en": "Connect the national Salt March with Bihar's iconic Anti-Chowkidari Tax agitation.", "student_check_hi": "दो छात्रों से असहयोग और सविनय अवज्ञा का एक-एक मुख्य अंतर पूछें।", "student_check_en": "Ask two students to state one key difference between NCM and CDM." },
    { "period_no": 5, "duration_mins": 40, "phase_hi": "समय-रेखा कार्ड खेल व 5-अंक उत्तर लेखन", "phase_en": "Timeline Drill & 5-Mark Answer Writing", "teacher_action_hi": "बोर्ड पर 5-अंक के उत्तर के लिए शीर्षक-वार (बुलेट पॉइंट) प्रारूप का अभ्यास कराएँ।", "teacher_action_en": "Model structured bullet-point headings for a 5-mark BSEB History answer.", "student_check_hi": "छात्रों से 1917, 1919, 1922, 1930, 1942 को क्रम में बोलवाएँ।", "student_check_en": "Have the class recite 1917, 1919, 1922, 1930, 1942 in sequence." }
  ]$json$::jsonb,
  $json$[
    {
      "heading_hi": "ब्लैकबोर्ड तिथियाँ (1915–1942)", "heading_en": "Blackboard Master Dates",
      "points_hi": ["1917 — चम्पारण सत्याग्रह (तिनकठिया)", "13 अप्रैल 1919 — जलियांवाला बाग", "1920 — असहयोग | 1922 — चौरी-चौरा", "1930 — दांडी मार्च | 1942 — भारत छोड़ो (पटना सचिवालय शहीद)"],
      "points_en": ["1917 — Champaran (Tinkathia)", "13 Apr 1919 — Jallianwala Bagh", "1920 — Non-Cooperation | 1922 — Chauri Chaura", "1930 — Dandi March | 1942 — Quit India"]
    }
  ]$json$::jsonb,
  $json$[
    {
      "title_hi": "मानव समय-रेखा (Human Timeline)", "title_en": "Human Timeline Activity",
      "materials_hi": "6 कागज़ जिन पर 1917, 1919, 1920, 1922, 1930, 1942 लिखा हो", "materials_en": "6 slips marked 1917, 1919, 1920, 1922, 1930, 1942",
      "steps_hi": "6 छात्र कक्षा के सामने क्रम से खड़े होकर अपने वर्ष की घटना 1 वाक्य में सुनाएँ।", "steps_en": "6 students line up chronologically and narrate their year's milestone in 1 clear sentence."
    }
  ]$json$::jsonb,
  $json$[
    { "level": "FOUNDATION", "task_hi": "तिनकठिया प्रथा और रॉलेट एक्ट पर 3-3 पंक्तियाँ लिखें।", "task_en": "Write 3 sentences each on Tinkathia System and Rowlatt Act." },
    { "level": "BOARD", "task_hi": "असहयोग आंदोलन और सविनय अवज्ञा आंदोलन में 4 प्रमुख अंतर तालिका बनाकर लिखें।", "task_en": "Write 4 key differences between Non-Cooperation and Civil Disobedience in table format." },
    { "level": "CHALLENGE", "task_hi": "भारत के स्वतंत्रता संग्राम में बिहार के चम्पारण सत्याग्रह (1917) के महत्व पर 150 शब्दों का उत्तर लिखें।", "task_en": "Write a 150-word structured answer on the significance of Champaran Satyagraha (1917)." }
  ]$json$::jsonb,
  $json$[
    {
      "misconception_hi": "छात्र समझते हैं कि चम्पारण सत्याग्रह 1919 या 1920 में हुआ था।",
      "misconception_en": "Students confuse Champaran year (1917) with 1919 or 1920.",
      "correction_hi": "क्रम याद कराएँ: 1915 (वापसी) → 1917 (चम्पारण) → 1919 (जलियांवाला) → 1920 (असहयोग)।",
      "correction_en": "Anchor the odd-year ladder: 1915 (return) → 1917 (Champaran) → 1919 (Jallianwala) → 1920 (NCM)."
    }
  ]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods = EXCLUDED.duration_periods, objectives_hi = EXCLUDED.objectives_hi,
  objectives_en = EXCLUDED.objectives_en, teaching_steps_json = EXCLUDED.teaching_steps_json,
  blackboard_points_json = EXCLUDED.blackboard_points_json, classroom_activities_json = EXCLUDED.classroom_activities_json,
  homework_json = EXCLUDED.homework_json, common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  (
    '10000000-0030-4000-8000-000000000001', 'bseb-10-sst', 'bseb-10-sst-ch1', 'Champaran 1917', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'तिनकठिया प्रथा क्या थी और गांधीजी को चम्पारण किसने बुलाया?',
    'What was Tinkathia System and who invited Gandhi to Champaran?',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "FLASHCARD",
      "front_hi": "चम्पारण में 'तिनकठिया प्रथा' क्या थी और गांधीजी को बिहार किसने बुलाया?",
      "front_en": "What was the Tinkathia system in Champaran and who invited Mahatma Gandhi?",
      "back_hi": "प्रत्येक बीघे (20 कट्ठे) के 3 कट्ठे (3/20 भाग) पर जबरन नील की खेती। किसान नेता राजकुमार शुक्ल ने गांधीजी को 1917 में चम्पारण बुलाया।",
      "back_en": "Forced indigo cultivation on 3/20 (3 kathas per bigha) of peasant land. Bihar peasant Raj Kumar Shukla invited Mahatma Gandhi in 1917."
    }$json$::jsonb, true
  ),
  (
    '10000000-0030-4000-8000-000000000002', 'bseb-10-sst', 'bseb-10-sst-ch1', 'Timeline Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'निम्नलिखित ऐतिहासिक वर्षों को उनकी सही घटना से मिलाएँ:',
    'Match the historical years in Column A with the correct event in Column B:',
    NULL, NULL, '1917 बिहार से, 1919 अमृतसर से, 1922 गोरखपुर से और 1930 गुजरात से जुड़ा है।',
    '1917 is Bihar, 1919 is Amritsar, 1922 is Gorakhpur, and 1930 is Gujarat.',
    'चम्पारण (1917), जलियांवाला बाग (1919), चौरी-चौरा (1922), दांडी मार्च (1930)।',
    'Champaran (1917), Jallianwala Bagh (1919), Chauri Chaura (1922), Dandi March (1930).',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "MATCH_PAIRS",
      "instruction_hi": "सही वर्ष और घटना मिलाएँ",
      "instruction_en": "Match each year with its event",
      "pairs": [
        { "id": "s1", "left_hi": "1917", "left_en": "1917", "right_hi": "चम्पारण सत्याग्रह (बिहार)", "right_en": "Champaran Satyagraha (Bihar)" },
        { "id": "s2", "left_hi": "13 अप्रैल 1919", "left_en": "13 April 1919", "right_hi": "जलियांवाला बाग हत्याकांड", "right_en": "Jallianwala Bagh Massacre" },
        { "id": "s3", "left_hi": "5 फ़रवरी 1922", "left_en": "5 February 1922", "right_hi": "चौरी-चौरा कांड", "right_en": "Chauri Chaura Incident" },
        { "id": "s4", "left_hi": "12 मार्च 1930", "left_en": "12 March 1930", "right_hi": "दांडी यात्रा की शुरुआत", "right_en": "Start of Dandi March" }
      ]
    }$json$::jsonb, true
  ),
  (
    '10000000-0030-4000-8000-000000000003', 'bseb-10-sst', 'bseb-10-sst-ch1', 'Tinkathia', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    'तिनकठिया प्रणाली किन पर लागू थी?',
    'Upon whom was the Tinkathia system imposed?',
    '[{"key":"A","text_hi":"उद्योगपतियों पर","text_en":"Industrialists"},{"key":"B","text_hi":"व्यापारियों पर","text_en":"Merchants"},{"key":"C","text_hi":"श्रमिकों पर","text_en":"Factory workers"},{"key":"D","text_hi":"किसानों पर","text_en":"Peasants / Farmers"}]'::jsonb,
    'D',
    'चम्पारण के नील की खेती करने वाले लोगों को याद करें।',
    'Recall the indigo cultivators of Champaran, Bihar.',
    'तिनकठिया प्रणाली बिहार के चम्पारण के नील किसानों पर लागू थी, जिसमें 20 कट्ठे में 3 कट्ठे पर नील उगाना अनिवार्य था।',
    'The Tinkathia system was imposed on indigo peasants of Champaran, forcing indigo on 3/20 of their land.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0030-4000-8000-000000000004', 'bseb-10-sst', 'bseb-10-sst-ch1', 'Jallianwala Bagh', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'जलियांवाला बाग हत्याकांड के विरोध में किसने अपनी ''नाइटहुड (Knighthood)'' की उपाधि त्याग दी थी?',
    'Who renounced his ''Knighthood'' title in protest against the Jallianwala Bagh Massacre?',
    '[{"key":"A","text_hi":"महात्मा गांधी","text_en":"Mahatma Gandhi"},{"key":"B","text_hi":"रवींद्रनाथ टैगोर","text_en":"Rabindranath Tagore"},{"key":"C","text_hi":"जवाहरलाल नेहरू","text_en":"Jawaharlal Nehru"},{"key":"D","text_hi":"डॉ. राजेंद्र प्रसाद","text_en":"Dr. Rajendra Prasad"}]'::jsonb,
    'B',
    'गांधीजी ने ''कैसर-ए-हिंद'' लौटाई थी, जबकि ''नाइटहुड'' राष्ट्रगान के रचयिता ने लौटाई थी।',
    'Gandhi returned Kaiser-i-Hind; the author of India''s National Anthem returned Knighthood.',
    'रवींद्रनाथ टैगोर ने 13 अप्रैल 1919 के जलियांवाला बाग नरसंहार के विरोध में ब्रिटिश ''नाइटहुड'' उपाधि वापस कर दी।',
    'Rabindranath Tagore renounced his British Knighthood in protest against the 13 April 1919 Jallianwala Bagh massacre.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0030-4000-8000-000000000005', 'bseb-10-sst', 'bseb-10-sst-ch1', 'Purna Swaraj', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'भारतीय राष्ट्रीय कांग्रेस के किस अधिवेशन में ''पूर्ण स्वराज'' का प्रस्ताव पारित किया गया था?',
    'At which session of the Indian National Congress was the ''Purna Swaraj'' resolution passed?',
    '[{"key":"A","text_hi":"1920 नागपुर अधिवेशन","text_en":"1920 Nagpur Session"},{"key":"B","text_hi":"1929 लाहौर अधिवेशन","text_en":"1929 Lahore Session"},{"key":"C","text_hi":"1916 लखनऊ अधिवेशन","text_en":"1916 Lucknow Session"},{"key":"D","text_hi":"1931 कराची अधिवेशन","text_en":"1931 Karachi Session"}]'::jsonb,
    'B',
    'जवाहरलाल नेहरू की अध्यक्षता में रावी नदी के तट पर 1929 में यह प्रस्ताव पारित हुआ।',
    'Passed in 1929 on the banks of River Ravi under Jawaharlal Nehru.',
    'दिसंबर 1929 के लाहौर अधिवेशन में पूर्ण स्वराज का प्रस्ताव पारित हुआ और 26 जनवरी 1930 को प्रथम स्वतंत्रता दिवस मनाने का निर्णय लिया गया।',
    'The Purna Swaraj resolution was passed at the December 1929 Lahore Session under Jawaharlal Nehru.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0030-4000-8000-000000000006', 'bseb-10-sst', 'bseb-10-sst-ch1', 'Rowlatt Act 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2022',
    'रॉलेट एक्ट (1919) क्या था? भारतीयों ने इसे ''काला कानून'' क्यों कहा?',
    'What was the Rowlatt Act (1919)? Why did Indians call it a ''Black Law''?',
    NULL, NULL, 'बिना मुकदमे 2 वर्ष कारावास का प्रावधान लिखें।', 'Mention detention for 2 years without trial.',
    NULL, NULL,
    'मार्च 1919 में ब्रिटिश सरकार ने क्रांतिकारी गतिविधियों को कुचलने के लिए **रॉलेट एक्ट** पारित किया। इसके अनुसार सरकार किसी भी भारतीय को **केवल संदेह के आधार पर बिना मुकदमा चलाए 2 वर्ष तक जेल** में बंद रख सकती थी। इसमें न अपील, न वकील और न दलील की अनुमति थी — इसलिए भारतीयों ने इसे **काला कानून** कहा।',
    'Passed in March 1919 by the British, the **Rowlatt Act** empowered the government to imprison any Indian political activist for **up to 2 years without trial** on mere suspicion. Because it stripped citizens of appeal, legal defence, and fair hearing, Indians condemned it as a **Black Law**.',
    '[{"cue_hi":"मार्च 1919 में पारित","cue_en":"Passed in March 1919"},{"cue_hi":"बिना मुकदमे 2 वर्ष कैद (न अपील, न वकील, न दलील)","cue_en":"2-year detention without trial"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"1919 के रॉलेट एक्ट का प्रावधान (बिना मुकदमे 2 साल जेल)","criterion_en":"States 1919 Act provision: 2 years jail without trial"},{"step_no":2,"marks":1,"criterion_hi":"नागरिक अधिकार हनन के कारण काला कानून कहे जाने का तर्क","criterion_en":"Explains why it was opposed as a Black Law"}]'::jsonb,
    NULL, true
  ),
  (
    '10000000-0030-4000-8000-000000000007', 'bseb-10-sst', 'bseb-10-sst-ch1', 'Champaran 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    'चम्पारण सत्याग्रह (1917) के कारणों, घटनाक्रम एवं भारतीय राष्ट्रीय आंदोलन में इसके महत्व का वर्णन करें।',
    'Describe the causes, course, and significance of the Champaran Satyagraha (1917) in India''s freedom struggle.',
    NULL, NULL, '4 स्पष्ट शीर्षकों में लिखें: (1) कारण/तिनकठिया, (2) राजकुमार शुक्ल व गांधीजी का आगमन, (3) परिणाम, (4) राष्ट्रीय महत्व।',
    'Structure into 4 crisp headings: Causes (Tinkathia), Gandhi''s Arrival, Result (1918 Act), and National Significance.',
    NULL, NULL,
    '**1. कारण (तिनकठिया प्रणाली):** बिहार के चम्पारण में अंग्रेज़ नीलहे बागान मालिक किसानों से उनकी भूमि के 3/20 भाग (प्रति बीघा 3 कट्ठा) पर जबरन नील की खेती कराते थे। इससे मिट्टी की उर्वरता नष्ट होती थी और कृत्रिम रंग आने के बाद किसानों से भारी मुआवज़ा (तवान) वसूला जाने लगा।\n\n**2. गांधीजी का आगमन (अप्रैल 1917):** चम्पारण के किसान **राजकुमार शुक्ल** के अनुरोध पर गांधीजी मोतिहारी व बेतिया पहुँचे। **डॉ. राजेंद्र प्रसाद**, ब्रजकिशोर प्रसाद व अनुग्रह नारायण सिन्हा ने उनके साथ हज़ारों किसानों के बयान दर्ज किए।\n\n**3. तात्कालिक परिणाम:** जन-दबाव में ब्रिटिश सरकार ने चम्पारण एग्रेरियन कमिटी बनाई और **चम्पारण कृषि अधिनियम (1918)** पारित कर तिनकठिया प्रथा समाप्त कर दी तथा अवैध वसूली का 25% लौटाया गया।\n\n**4. ऐतिहासिक महत्व:** यह भारत में गांधीजी के **सत्याग्रह का प्रथम सफल प्रयोग** था। इसने भारतीय स्वतंत्रता संग्राम को शहरों से निकालकर गाँवों और किसानों तक पहुँचाया।',
    '**1. Causes (Tinkathia System):** European indigo planters in Champaran (Bihar) forced peasants to grow indigo on 3/20 of their land, exhausting soil fertility and later demanding heavy illegal dues.\n\n**2. Arrival of Gandhi (April 1917):** Invited persistently by peasant **Raj Kumar Shukla**, Mahatma Gandhi reached Motihari and Bettiah, joined by **Dr. Rajendra Prasad**, Brajkishore Prasad, and Anugrah Narayan Sinha to record thousands of peasant testimonies.\n\n**3. Immediate Result:** Bowing to peaceful mass resolve, the British appointed the Champaran Agrarian Committee and enacted the **Champaran Agrarian Act (1918)**, abolishing Tinkathia and refunding 25% of illegal exactions.\n\n**4. Historical Significance:** It was Gandhi''s **first triumphant Satyagraha in India**, transforming the freedom movement from an elite urban debate into a mass peasant revolution.',
    '[{"cue_hi":"तिनकठिया = 3/20 भूमि पर नील","cue_en":"Tinkathia = indigo on 3/20 land"},{"cue_hi":"राजकुमार शुक्ल + डॉ. राजेंद्र प्रसाद","cue_en":"Raj Kumar Shukla + Dr. Rajendra Prasad"},{"cue_hi":"1918 अधिनियम = प्रथा समाप्त + 25% वापसी","cue_en":"1918 Act = abolished + 25% refund"}]'::jsonb,
    '[{"step_no":1,"marks":1.5,"criterion_hi":"तिनकठिया प्रथा व किसानों के शोषण का सटीक विवरण","criterion_en":"Explains Tinkathia system and peasant exploitation"},{"step_no":2,"marks":1.5,"criterion_hi":"राजकुमार शुक्ल, गांधीजी व बिहार के नेताओं की भूमिका","criterion_en":"Covers Raj Kumar Shukla, Gandhi, and Bihar leaders"},{"step_no":3,"marks":1,"criterion_hi":"चम्पारण कृषि अधिनियम 1918 व 25% वापसी का उल्लेख","criterion_en":"States 1918 Agrarian Act & 25% refund"},{"step_no":4,"marks":1,"criterion_hi":"भारत में प्रथम सफल सत्याग्रह के रूप में महत्व","criterion_en":"Highlights national significance as first Satyagraha"}]'::jsonb,
    NULL, true
  )
ON CONFLICT (id) DO UPDATE SET
  q_hi = EXCLUDED.q_hi, q_en = EXCLUDED.q_en, options_json = EXCLUDED.options_json,
  correct_option = EXCLUDED.correct_option, explanation_hi = EXCLUDED.explanation_hi,
  explanation_en = EXCLUDED.explanation_en, model_answer_hi = EXCLUDED.model_answer_hi,
  model_answer_en = EXCLUDED.model_answer_en, marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json = EXCLUDED.visual_asset_json, bank_pool = EXCLUDED.bank_pool;

-- #############################################################################
-- CHAPTER 4 OF 6: CLASS 9 SCIENCE CH 7 — MOTION (गति)
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-9-sci-ch7',
  $json${
    "title_hi": "30-सेकंड माइंडमैप: गति (Motion — कक्षा 9)",
    "title_en": "30-Second Mindmap: Motion (Class 9)",
    "read_time_seconds": 30,
    "central_node": {
      "id": "mot-root",
      "label_hi": "गति (Motion)",
      "label_en": "Motion",
      "subtitle_hi": "समय के साथ वस्तु की स्थिति में परिवर्तन",
      "subtitle_en": "Change in position of an object with time"
    },
    "branches": [
      {
        "id": "m-dist",
        "label_hi": "1. दूरी बनाम विस्थापन",
        "label_en": "1. Distance vs Displacement",
        "color": "#1E3A8A",
        "children": [
          { "id": "md1", "label_hi": "दूरी: कुल पथ की लंबाई (अदिश, हमेशा +)", "label_en": "Distance: Total path length (Scalar, always +)" },
          { "id": "md2", "label_hi": "विस्थापन: न्यूनतम सीधी दूरी (सदिश, 0 भी संभव)", "label_en": "Displacement: Shortest straight path (Vector, can be 0)" }
        ]
      },
      {
        "id": "m-acc",
        "label_hi": "2. वेग व त्वरण (Acceleration)",
        "label_en": "2. Velocity & Acceleration",
        "color": "#059669",
        "formula_latex": "a = \\frac{v - u}{t}\\ (\\text{m/s}^2)"
      },
      {
        "id": "m-eq",
        "label_hi": "3. गति के 3 समीकरण",
        "label_en": "3. Three Equations of Motion",
        "color": "#D97706",
        "children": [
          { "id": "me1", "label_hi": "v = u + at", "label_en": "v = u + at" },
          { "id": "me2", "label_hi": "s = ut + ½at²", "label_en": "s = ut + ½at²" },
          { "id": "me3", "label_hi": "v² − u² = 2as", "label_en": "v² − u² = 2as" }
        ]
      }
    ]
  }$json$::jsonb,
  $json$[
    {
      "id": "c9-mot-sec1",
      "order": 1,
      "heading_hi": "1. दूरी और विस्थापन — घर से स्कूल के रास्ते से समझें",
      "heading_en": "1. Distance vs Displacement — Your Walk from Home to School",
      "analogy_hi": "सोचिए आप सुबह अपने घर से साइकिल चलाकर घुमावदार गाँव की सड़क (400 m पूर्व + 300 m उत्तर = **700 m**) से स्कूल पहुँचते हैं — यह आपकी **दूरी (Distance)** है। लेकिन यदि कोई चिड़िया आपके घर की छत से सीधे स्कूल की छत तक उड़े, तो वह केवल **500 m** (पाइथागोरस: $\\sqrt{400^2+300^2}$) तय करेगी — यही **विस्थापन (Displacement)** है! और शाम को जब आप वापस घर लौट आते हैं, तो दूरी $1400\\text{ m}$ हो जाती है पर विस्थापन **शून्य (0)** हो जाता है!",
      "analogy_en": "Suppose you cycle to school along village roads — 400 m East then 300 m North = **700 m** total path (**Distance**). A bird flying straight from your house roof to the school roof covers only **500 m** ($\\sqrt{400^2+300^2}$) — that straight-line arrow is **Displacement**! And when you return home in the evening, total distance is $1400\\text{ m}$, yet net displacement becomes **ZERO**!",
      "visual_diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "दूरी (700 m) बनाम विस्थापन (500 m)",
        "title_en": "Distance (700 m) vs Displacement (500 m)",
        "caption_hi": "नीली रेखा वास्तविक सड़क (दूरी = 400 + 300 = 700 m) और हरी सीधी रेखा न्यूनतम पथ (विस्थापन = 500 m) दर्शाती है।",
        "caption_en": "Blue path shows actual road (Distance = 400 + 300 = 700 m); green straight arrow shows shortest line (Displacement = 500 m).",
        "viewBox": "0 0 580 250",
        "elements": [
          { "kind": "arrow", "x1": 90, "y1": 195, "x2": 430, "y2": 195, "stroke": "#1E3A8A", "strokeWidth": 3.5 },
          { "kind": "arrow", "x1": 430, "y1": 195, "x2": 430, "y2": 55, "stroke": "#1E3A8A", "strokeWidth": 3.5 },
          { "kind": "arrow", "x1": 90, "y1": 195, "x2": 424, "y2": 58, "stroke": "#059669", "strokeWidth": 3.5, "dashed": true },
          { "kind": "circle", "cx": 90, "cy": 195, "r": 7, "fill": "#D97706" },
          { "kind": "circle", "cx": 430, "cy": 55, "r": 7, "fill": "#059669" },
          { "kind": "label", "x": 85, "y": 220, "text_hi": "घर (प्रारंभ)", "text_en": "Home (Start)", "fill": "#0F172A", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 445, "y": 48, "text_hi": "स्कूल (अंत)", "text_en": "School (End)", "fill": "#059669", "fontSize": 13, "anchor": "start", "bold": true },
          { "kind": "label", "x": 260, "y": 218, "text_hi": "400 m (पूर्व)", "text_en": "400 m (East)", "fill": "#1E3A8A", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 445, "y": 130, "text_hi": "300 m (उत्तर)", "text_en": "300 m (North)", "fill": "#1E3A8A", "fontSize": 13, "anchor": "start", "bold": true },
          { "kind": "label", "x": 230, "y": 115, "text_hi": "विस्थापन = 500 m", "text_en": "Displacement = 500 m", "fill": "#059669", "fontSize": 14, "anchor": "end", "bold": true }
        ]
      },
      "concept_md_hi": "### चाल (Speed), वेग (Velocity) और त्वरण (Acceleration)\n- **चाल:** $\\text{चाल} = \\frac{\\text{दूरी}}{\\text{समय}}$ (अदिश राशि, SI मात्रक $\\text{m/s}$)\n- **वेग:** $\\text{वेग} = \\frac{\\text{विस्थापन}}{\\text{समय}}$ (सदिश राशि — इसमें दिशा ज़रूरी है!)\n- **त्वरण ($a$):** वेग में परिवर्तन की दर:\n$$a = \\frac{v - u}{t} \\quad (\\text{SI मात्रक: } \\text{m/s}^2)$$\nजब ब्रेक लगाने पर गाड़ी धीमी होती है, तो $a$ ऋणात्मक होता है — इसे **मंदन (Retardation)** कहते हैं।",
      "concept_md_en": "### Speed, Velocity & Acceleration\n- **Speed:** $\\text{Speed} = \\frac{\\text{Distance}}{\\text{Time}}$ (Scalar, SI unit $\\text{m/s}$)\n- **Velocity:** $\\text{Velocity} = \\frac{\\text{Displacement}}{\\text{Time}}$ (Vector — includes direction!)\n- **Acceleration ($a$):** Rate of change of velocity:\n$$a = \\frac{v - u}{t} \\quad (\\text{SI unit: } \\text{m/s}^2)$$\nNegative acceleration (when braking) is called **Retardation / Deceleration**.",
      "exam_tip_hi": "यूनिट बदलने की तेज़ ट्रिक: $\\text{km/h}$ को $\\text{m/s}$ में बदलने के लिए $\\frac{5}{18}$ से गुणा करें! जैसे $72\\text{ km/h} = 72 \\times \\frac{5}{18} = 20\\text{ m/s}$।",
      "exam_tip_en": "Quick Unit Trick: Multiply $\\text{km/h}$ by $\\frac{5}{18}$ to get $\\text{m/s}$! Example: $72\\text{ km/h} = 72 \\times \\frac{5}{18} = 20\\text{ m/s}$.",
      "glossary_terms": [
        { "term_hi": "एकसमान वृत्तीय गति", "term_en": "Uniform Circular Motion", "definition_hi": "वृत्ताकार पथ पर नियत चाल से गति — दिशा लगातार बदलने से यह एक त्वरित गति है ($v = \\frac{2\\pi r}{t}$)।", "definition_en": "Constant-speed motion in a circle; accelerated because direction changes continuously ($v = \\frac{2\\pi r}{t}$)." }
      ]
    },
    {
      "id": "c9-mot-sec2",
      "order": 2,
      "heading_hi": "2. वेग-समय (v–t) ग्राफ़ से गति के तीनों समीकरण",
      "heading_en": "2. Velocity–Time (v–t) Graph & The 3 Equations of Motion",
      "analogy_hi": "वेग-समय ग्राफ़ में सिर्फ़ दो बातें याद रखिए: **रेखा की ढाल (Slope) = त्वरण ($a$)**, और **रेखा के नीचे का क्षेत्रफल (Area) = तय दूरी ($s$)**! आयत + त्रिभुज का क्षेत्रफल जोड़ते ही दूसरा समीकरण $s = ut + \\frac{1}{2}at^2$ खुद बन जाता है!",
      "analogy_en": "On a velocity–time graph, remember just two superpowers: **Slope = Acceleration ($a$)**, and **Area under the line = Displacement ($s$)**! Adding the rectangle + triangle area immediately proves $s = ut + \\frac{1}{2}at^2$!",
      "visual_diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "वेग-समय (v–t) ग्राफ़: नीचे का क्षेत्रफल = विस्थापन s",
        "title_en": "Velocity–Time (v–t) Graph: Area Under Curve = Displacement s",
        "caption_hi": "नीला आयत (क्षेत्रफल = u × t) + सुनहरा त्रिभुज (क्षेत्रफल = ½ × t × (v − u) = ½at²) मिलकर s = ut + ½at² बनाते हैं।",
        "caption_en": "Blue rectangle (area = u × t) + Amber triangle (area = ½ × t × at = ½at²) give s = ut + ½at².",
        "viewBox": "0 0 580 260",
        "elements": [
          { "kind": "polygon", "points": "100,145 440,145 440,210 100,210", "fill": "#DBEAFE", "stroke": "#1E3A8A", "strokeWidth": 1.5 },
          { "kind": "polygon", "points": "100,145 440,55 440,145", "fill": "#FEF3C7", "stroke": "#D97706", "strokeWidth": 1.5 },
          { "kind": "arrow", "x1": 100, "y1": 210, "x2": 510, "y2": 210, "stroke": "#0F172A", "strokeWidth": 2.5 },
          { "kind": "arrow", "x1": 100, "y1": 210, "x2": 100, "y2": 25, "stroke": "#0F172A", "strokeWidth": 2.5 },
          { "kind": "line", "x1": 100, "y1": 145, "x2": 440, "y2": 55, "stroke": "#DC2626", "strokeWidth": 3.5 },
          { "kind": "label", "x": 85, "y": 149, "text_hi": "u", "text_en": "u", "fill": "#1E3A8A", "fontSize": 14, "anchor": "end", "bold": true },
          { "kind": "label", "x": 85, "y": 59, "text_hi": "v", "text_en": "v", "fill": "#DC2626", "fontSize": 14, "anchor": "end", "bold": true },
          { "kind": "label", "x": 440, "y": 232, "text_hi": "समय (t)", "text_en": "Time (t)", "fill": "#0F172A", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 270, "y": 182, "text_hi": "आयत का क्षेत्रफल = u × t", "text_en": "Rectangle Area = u × t", "fill": "#1E3A8A", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 345, "y": 118, "text_hi": "त्रिभुज = ½at²", "text_en": "Triangle = ½at²", "fill": "#B45309", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 255, "y": 78, "text_hi": "ढाल (Slope) = त्वरण a", "text_en": "Slope = Acceleration a", "fill": "#DC2626", "fontSize": 13, "anchor": "end", "bold": true }
        ]
      },
      "concept_md_hi": "### गति के तीनों समीकरण (केवल एकसमान त्वरण $a$ के लिए)\n1. **वेग-समय संबंध:** $v = u + at$\n2. **स्थिति-समय संबंध:** $s = ut + \\frac{1}{2}at^2$\n3. **स्थिति-वेग संबंध:** $v^2 - u^2 = 2as$\n\nजहाँ $u =$ प्रारंभिक वेग, $v =$ अंतिम वेग, $a =$ एकसमान त्वरण, $t =$ समय, $s =$ विस्थापन।",
      "concept_md_en": "### The Three Equations of Motion (for Uniform Acceleration $a$)\n1. **Velocity–Time:** $v = u + at$\n2. **Position–Time:** $s = ut + \\frac{1}{2}at^2$\n3. **Position–Velocity:** $v^2 - u^2 = 2as$\n\nWhere $u =$ initial velocity, $v =$ final velocity, $a =$ uniform acceleration, $t =$ time, $s =$ displacement.",
      "exam_tip_hi": "न्यूमेरिकल कुंजी: यदि सवाल कहे 'विरामावस्था से चलना शुरू करती है (starts from rest)' तो $u = 0$ लें; और 'ब्रेक लगाकर रुक जाती है (comes to rest)' तो $v = 0$ लें!",
      "exam_tip_en": "Numerical Key: 'Starts from rest' $\\Rightarrow u = 0$; 'Comes to rest after braking' $\\Rightarrow v = 0$!",
      "glossary_terms": []
    }
  ]$json$::jsonb,
  $json${
    "important_formulas": [
      { "latex": "a = \\frac{v - u}{t}", "label_hi": "त्वरण (Acceleration)", "label_en": "Acceleration" },
      { "latex": "v = u + at", "label_hi": "गति का प्रथम समीकरण", "label_en": "1st Equation of Motion" },
      { "latex": "s = ut + \\frac{1}{2}at^2", "label_hi": "गति का द्वितीय समीकरण", "label_en": "2nd Equation of Motion" },
      { "latex": "v^2 - u^2 = 2as", "label_hi": "गति का तृतीय समीकरण", "label_en": "3rd Equation of Motion" }
    ],
    "key_dates_or_facts": [
      { "tag": "Odometer", "fact_hi": "वाहनों का ओडोमीटर तय की गई दूरी (Distance) मापता है, स्पीडोमीटर तात्क्षणिक चाल मापता है।", "fact_en": "Odometer measures distance; Speedometer measures instantaneous speed." },
      { "tag": "5/18", "fact_hi": "1 km/h = 5/18 m/s (जैसे 36 km/h = 10 m/s)।", "fact_en": "1 km/h = 5/18 m/s (e.g., 36 km/h = 10 m/s)." }
    ],
    "common_bseb_mistakes": [
      { "mistake_hi": "km/h में वेग और सेकंड (s) में समय को सीधे एक साथ सूत्र में रख देना।", "mistake_en": "Mixing km/h velocity directly with seconds in formulas.", "fix_hi": "हमेशा पहले km/h को 5/18 से गुणा कर m/s में बदलें।", "fix_en": "Always convert km/h to m/s first by multiplying by 5/18." }
    ],
    "high_yield_pyq_topics": [
      { "topic_hi": "दूरी और विस्थापन में अंतर", "topic_en": "Distance vs Displacement", "years": ["2022", "2023", "2024"], "expected_marks": 2 },
      { "topic_hi": "ग्राफीय विधि से s = ut + ½at² का निगमन", "topic_en": "Graphical Derivation of s = ut + ½at²", "years": ["2023", "2024"], "expected_marks": 5 }
    ]
  }$json$::jsonb,
  $json${
    "hindi_reviewed": true, "english_reviewed": true, "visuals_count": 2, "analogy_count": 2, "bseb_pyq_mapped": true, "syllabus_year": "2026-27"
  }$json$::jsonb,
  'PUBLISHED', 1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json = EXCLUDED.mindmap_json, sections_json = EXCLUDED.sections_json,
  board_capsule_json = EXCLUDED.board_capsule_json, quality_checks_json = EXCLUDED.quality_checks_json,
  status = EXCLUDED.status, version = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'bseb-9-sci-ch7',
  5,
  'छात्र दूरी-विस्थापन और चाल-वेग का अंतर स्पष्ट कर सकेंगे, km/h से m/s परिवर्तन कर सकेंगे और v–t ग्राफ़ द्वारा गति के तीनों समीकरण सिद्ध कर सकेंगे।',
  'Students will distinguish distance from displacement, convert km/h to m/s accurately, and derive all 3 kinematic equations from a v–t graph.',
  $json$[
    { "period_no": 1, "duration_mins": 40, "phase_hi": "दूरी बनाम विस्थापन (कक्षा प्रयोग)", "phase_en": "Distance vs Displacement Demo", "teacher_action_hi": "एक छात्र को कक्षा के चारों कोनों पर चलाकर प्रारंभिक बिंदु पर वापस लाएँ और दूरी बनाम शून्य विस्थापन समझाएँ।", "teacher_action_en": "Have a student walk around the room perimeter back to start to demonstrate non-zero distance vs zero displacement.", "student_check_hi": "पूछें: वृत्ताकार मैदान का 1 पूरा चक्कर लगाने पर विस्थापन कितना होगा?", "student_check_en": "Ask: What is the displacement after 1 complete lap of a circular track?" },
    { "period_no": 2, "duration_mins": 40, "phase_hi": "चाल, वेग, त्वरण व 5/18 ट्रिक", "phase_en": "Speed, Velocity, Acceleration & 5/18 Rule", "teacher_action_hi": "1000m/3600s = 5/18 सिद्ध करके 36, 54, 72 km/h को m/s में बदलवाएँ।", "teacher_action_en": "Derive 1000/3600 = 5/18 and drill converting 36, 54, 72 km/h.", "student_check_hi": "पूछें: 54 km/h कितने m/s के बराबर है? (15 m/s)", "student_check_en": "Quick check: 54 km/h equals how many m/s? (15 m/s)" },
    { "period_no": 3, "duration_mins": 40, "phase_hi": "दूरी-समय व वेग-समय ग्राफ़", "phase_en": "s–t and v–t Graphs", "teacher_action_hi": "ग्राफ़ पर ढाल (slope) और क्षेत्रफल (area) को अलग-अलग रंग के चॉक से दिखाएँ।", "teacher_action_en": "Use two chalk colours to highlight slope vs shaded area under v–t graph.", "student_check_hi": "पूछें: वेग-समय ग्राफ़ के नीचे का क्षेत्रफल किस भौतिक राशि को दर्शाता है?", "student_check_en": "Ask: What physical quantity does the area under a v–t graph represent?" },
    { "period_no": 4, "duration_mins": 40, "phase_hi": "ग्राफ़ से गति के 3 समीकरणों का निगमन", "phase_en": "Graphical Derivation of 3 Equations", "teacher_action_hi": "आयत + त्रिभुज के क्षेत्रफल से s = ut + ½at² और समलंब (Trapezium) से v² - u² = 2as सिद्ध कराएँ।", "teacher_action_en": "Derive s = ut + ½at² via rectangle+triangle and v² - u² = 2as via trapezium area.", "student_check_hi": "छात्रों से तीनों समीकरण बिना देखे लिखवाएँ।", "student_check_en": "Have students recall all 3 equations from memory." },
    { "period_no": 5, "duration_mins": 40, "phase_hi": "आंकिक प्रश्न अभ्यास व लाइव मूल्यांकन", "phase_en": "Numericals & Live Quiz", "teacher_action_hi": "ब्रेक लगाने वाले और विरामावस्था से चलने वाले 3 सरल न्यूमेरिकल हल कराएँ।", "teacher_action_en": "Solve 3 core numericals involving starts-from-rest and braking.", "student_check_hi": "क्विज़ में 80%+ सटीकता की जाँच करें।", "student_check_en": "Check class mastery via a 5-question live quiz." }
  ]$json$::jsonb,
  $json$[
    {
      "heading_hi": "ब्लैकबोर्ड सूत्र (गति)", "heading_en": "Blackboard Motion Equations",
      "points_hi": ["1 km/h = 5/18 m/s", "a = (v − u) / t (m/s²)", "v = u + at  |  s = ut + ½at²  |  v² − u² = 2as", "v–t ग्राफ़ का क्षेत्रफल = विस्थापन (s)"],
      "points_en": ["1 km/h = 5/18 m/s", "a = (v − u) / t (m/s²)", "v = u + at  |  s = ut + ½at²  |  v² − u² = 2as", "Area under v–t graph = Displacement (s)"]
    }
  ]$json$::jsonb,
  $json$[
    {
      "title_hi": "प्रांगण कदम मापन गतिविधि", "title_en": "Courtyard Pace Measurement",
      "materials_hi": "चॉक, स्टॉपवॉच या मोबाइल टाइमर", "materials_en": "Chalk, stopwatch",
      "steps_hi": "आयताकार प्रांगण की 2 भुजाओं पर चलकर दूरी व विकर्ण नापकर विस्थापन की तुलना करें।", "steps_en": "Walk two edges of a rectangle and measure the diagonal to compare distance vs displacement."
    }
  ]$json$::jsonb,
  $json$[
    { "level": "FOUNDATION", "task_hi": "दूरी और विस्थापन में 3 अंतर लिखें।", "task_en": "Write 3 differences between distance and displacement." },
    { "level": "BOARD", "task_hi": "एक बस की गति 5 सेकंड में 80 km/h से घटकर 60 km/h हो जाती है। बस का त्वरण ज्ञात करें।", "task_en": "A bus slows down from 80 km/h to 60 km/h in 5 s. Find its acceleration." }
  ]$json$::jsonb,
  $json$[
    { "misconception_hi": "छात्र समझते हैं कि नियत चाल से वृत्त में घूमने पर त्वरण शून्य होता है।", "misconception_en": "Students think constant speed in a circle has zero acceleration.", "correction_hi": "याद दिलाएँ: वेग में दिशा भी होती है; वृत्त में हर पल दिशा बदलती है, अतः त्वरण शून्य नहीं होता!", "correction_en": "Velocity includes direction; since direction changes constantly on a circle, it is accelerated!" }
  ]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods = EXCLUDED.duration_periods, objectives_hi = EXCLUDED.objectives_hi,
  objectives_en = EXCLUDED.objectives_en, teaching_steps_json = EXCLUDED.teaching_steps_json,
  blackboard_points_json = EXCLUDED.blackboard_points_json, classroom_activities_json = EXCLUDED.classroom_activities_json,
  homework_json = EXCLUDED.homework_json, common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  (
    '10000000-0040-4000-8000-000000000001', 'bseb-9-sci', 'bseb-9-sci-ch7', 'SI Units', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', NULL,
    'भौतिक राशियों को उनके सही SI मात्रक से मिलाएँ:',
    'Match each physical quantity in Column A with its SI unit in Column B:',
    NULL, NULL, 'त्वरण में समय का वर्ग (s²) आता है।', 'Acceleration has seconds squared (s²).',
    'दूरी/विस्थापन (m), चाल/वेग (m/s), त्वरण (m/s²), समय (s)।', 'Distance (m), Velocity (m/s), Acceleration (m/s²), Time (s).',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "MATCH_PAIRS",
      "instruction_hi": "राशि को सही SI मात्रक से मिलाएँ",
      "instruction_en": "Match each quantity to its SI unit",
      "pairs": [
        { "id": "m1", "left_hi": "विस्थापन (Displacement)", "left_en": "Displacement", "right_hi": "मीटर (m)", "right_en": "metre (m)" },
        { "id": "m2", "left_hi": "वेग (Velocity)", "left_en": "Velocity", "right_hi": "m/s", "right_en": "m/s" },
        { "id": "m3", "left_hi": "त्वरण (Acceleration)", "left_en": "Acceleration", "right_hi": "m/s²", "right_en": "m/s²" },
        { "id": "m4", "left_hi": "वाहन का ओडोमीटर मापता है", "left_en": "Vehicle Odometer measures", "right_hi": "तय की गई दूरी", "right_en": "Distance travelled" }
      ]
    }$json$::jsonb, true
  ),
  (
    '10000000-0040-4000-8000-000000000002', 'bseb-9-sci', 'bseb-9-sci-ch7', 'Circular Track', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 9',
    'यदि कोई धावक $R$ त्रिज्या वाले वृत्ताकार पथ का 1 पूरा चक्कर लगाता है, तो उसका विस्थापन कितना होगा?',
    'If an athlete completes 1 full round of a circular track of radius $R$, what is the displacement?',
    '[{"key":"A","text_hi":"2πR","text_en":"2πR"},{"key":"B","text_hi":"πR","text_en":"πR"},{"key":"C","text_hi":"2R","text_en":"2R"},{"key":"D","text_hi":"शून्य (0)","text_en":"Zero (0)"}]'::jsonb,
    'D',
    'पूरे चक्कर के बाद प्रारंभिक और अंतिम बिंदु एक ही हो जाते हैं!',
    'After one full lap, the starting and ending points coincide!',
    'प्रारंभिक और अंतिम स्थिति समान होने के कारण विस्थापन $= 0$, जबकि तय दूरी $= 2\\pi R$ होगी।',
    'Since start and end points are identical, displacement $= 0$ (while distance $= 2\\pi R$).',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0040-4000-8000-000000000003', 'bseb-9-sci', 'bseb-9-sci-ch7', 'Unit Conversion & Acceleration', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB Class 9',
    'एक कार विरामावस्था से चलकर $10\\text{ s}$ में $72\\text{ km/h}$ का वेग प्राप्त करती है। कार का एकसमान त्वरण क्या है?',
    'Starting from rest, a car attains a velocity of $72\\text{ km/h}$ in $10\\text{ s}$. What is its uniform acceleration?',
    '[{"key":"A","text_hi":"7.2 m/s²","text_en":"7.2 m/s²"},{"key":"B","text_hi":"2 m/s²","text_en":"2 m/s²"},{"key":"C","text_hi":"20 m/s²","text_en":"20 m/s²"},{"key":"D","text_hi":"0.5 m/s²","text_en":"0.5 m/s²"}]'::jsonb,
    'B',
    'पहले $72\\text{ km/h}$ को $\\frac{5}{18}$ से गुणा कर $\\text{m/s}$ में बदलें।',
    'First convert $72\\text{ km/h}$ to $\\text{m/s}$ by multiplying by $\\frac{5}{18}$.',
    '$u = 0$, $v = 72 \\times \\frac{5}{18} = 20\\text{ m/s}$, $t = 10\\text{ s}$। अतः $a = \\frac{v - u}{t} = \\frac{20 - 0}{10} = 2\\text{ m/s}^2$।',
    '$u = 0$, $v = 72 \\times \\frac{5}{18} = 20\\text{ m/s}$, $t = 10\\text{ s}$. So $a = \\frac{20 - 0}{10} = 2\\text{ m/s}^2$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0040-4000-8000-000000000004', 'bseb-9-sci', 'bseb-9-sci-ch7', 'Graphical Derivation 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB Class 9',
    'वेग-समय (v–t) ग्राफ़ की सहायता से गति का दूसरा समीकरण $s = ut + \\frac{1}{2}at^2$ सिद्ध करें।',
    'Derive the second equation of motion $s = ut + \\frac{1}{2}at^2$ using a velocity–time (v–t) graph.',
    NULL, NULL, 'वेग-समय ग्राफ़ के नीचे के क्षेत्रफल को एक आयत और एक त्रिभुज के योग के रूप में लिखें।',
    'Split the area under the v–t line into a rectangle plus a right triangle.',
    NULL, NULL,
    'मान लीजिए कोई वस्तु एकसमान त्वरण $a$ से प्रारंभिक वेग $u$ से चलकर समय $t$ में अंतिम वेग $v$ प्राप्त करती है।\n\nवेग-समय ग्राफ़ के नीचे घिरा कुल क्षेत्रफल तय विस्थापन $s$ के बराबर होता है:\n$$s = \\text{आयत का क्षेत्रफल} + \\text{त्रिभुज का क्षेत्रफल}$$\n- आयत का क्षेत्रफल $= u \\times t = ut$\n- त्रिभुज का क्षेत्रफल $= \\frac{1}{2} \\times \\text{आधार} \\times \\text{ऊँचाई} = \\frac{1}{2} \\times t \\times (v - u)$\n\nचूँकि प्रथम समीकरण से $v - u = at$, इसे रखने पर:\n$$s = ut + \\frac{1}{2} \\times t \\times (at) = ut + \\frac{1}{2}at^2 \\quad (\\text{सिद्ध हुआ})$$',
    'Suppose an object moves with uniform acceleration $a$ from initial velocity $u$ to final velocity $v$ in time $t$.\n\nDisplacement $s =$ Total area under the v–t graph:\n$$s = \\text{Area of rectangle} + \\text{Area of triangle}$$\n$$s = (u \\times t) + \\frac{1}{2} \\times t \\times (v - u)$$\nSubstituting $v - u = at$ from the first equation of motion:\n$$s = ut + \\frac{1}{2}at^2 \\quad (\\text{Proved})$$',
    '[{"cue_hi":"विस्थापन = आयत + त्रिभुज का क्षेत्रफल","cue_en":"Displacement = Rectangle + Triangle area"},{"cue_hi":"अंत में v - u = at रखें","cue_en":"Substitute v - u = at"}]'::jsonb,
    '[{"step_no":1,"marks":1.5,"criterion_hi":"स्वच्छ नामांकित वेग-समय ग्राफ़ बनाना","criterion_en":"Draws neat labeled v–t graph"},{"step_no":2,"marks":1,"criterion_hi":"विस्थापन = ग्राफ़ के नीचे का क्षेत्रफल लिखना","criterion_en":"States displacement = area under v–t curve"},{"step_no":3,"marks":1.5,"criterion_hi":"आयत (ut) व त्रिभुज (½t(v-u)) का क्षेत्रफल निकालना","criterion_en":"Writes rectangle and triangle areas accurately"},{"step_no":4,"marks":1,"criterion_hi":"v - u = at रखकर s = ut + ½at² सिद्ध करना","criterion_en":"Substitutes v - u = at to prove s = ut + ½at²"}]'::jsonb,
    NULL, true
  )
ON CONFLICT (id) DO UPDATE SET
  q_hi = EXCLUDED.q_hi, q_en = EXCLUDED.q_en, options_json = EXCLUDED.options_json,
  correct_option = EXCLUDED.correct_option, explanation_hi = EXCLUDED.explanation_hi,
  explanation_en = EXCLUDED.explanation_en, model_answer_hi = EXCLUDED.model_answer_hi,
  model_answer_en = EXCLUDED.model_answer_en, marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json = EXCLUDED.visual_asset_json, bank_pool = EXCLUDED.bank_pool;

-- #############################################################################
-- CHAPTER 5 OF 6: CLASS 12 PHYSICS CH 1 — ELECTRIC CHARGES AND FIELDS
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-12-sci-phy-ch1',
  $json${
    "title_hi": "30-सेकंड माइंडमैप: वैद्युत आवेश तथा क्षेत्र (कक्षा 12 भौतिकी)",
    "title_en": "30-Second Mindmap: Electric Charges and Fields (Class 12 Physics)",
    "read_time_seconds": 30,
    "central_node": {
      "id": "elec-root",
      "label_hi": "वैद्युत आवेश व क्षेत्र",
      "label_en": "Electric Charges & Fields",
      "subtitle_hi": "क्वांटमीकरण q = ±ne · SI मात्रक: कूलॉम (C)",
      "subtitle_en": "Quantisation q = ±ne · SI unit: Coulomb (C)"
    },
    "branches": [
      {
        "id": "e-coulomb",
        "label_hi": "1. कूलॉम का नियम",
        "label_en": "1. Coulomb's Law",
        "color": "#1E3A8A",
        "formula_latex": "F = \\frac{1}{4\\pi\\varepsilon_0}\\frac{q_1 q_2}{r^2}",
        "children": [
          { "id": "ec1", "label_hi": "1/(4πε₀) = 9 × 10⁹ N·m²/C²", "label_en": "1/(4πε₀) = 9 × 10⁹ N·m²/C²" },
          { "id": "ec2", "label_hi": "ε₀ = 8.854 × 10⁻¹² C²/(N·m²)", "label_en": "ε₀ = 8.854 × 10⁻¹² C²/(N·m²)" }
        ]
      },
      {
        "id": "e-dipole",
        "label_hi": "2. वैद्युत द्विध्रुव (Dipole)",
        "label_en": "2. Electric Dipole",
        "color": "#D97706",
        "formula_latex": "p = q \\cdot 2a,\\quad \\vec{\\tau} = \\vec{p} \\times \\vec{E}",
        "children": [
          { "id": "ed1", "label_hi": "अक्षीय (Axial): E = 2kp / r³", "label_en": "Axial line: E = 2kp / r³" },
          { "id": "ed2", "label_hi": "निरक्षीय (Equatorial): E = kp / r³", "label_en": "Equatorial line: E = kp / r³" }
        ]
      },
      {
        "id": "e-gauss",
        "label_hi": "3. गॉस का प्रमेय (Gauss's Law)",
        "label_en": "3. Gauss's Law",
        "color": "#059669",
        "formula_latex": "\\Phi_E = \\oint \\vec{E}\\cdot d\\vec{A} = \\frac{q_{\\text{in}}}{\\varepsilon_0}"
      }
    ]
  }$json$::jsonb,
  $json$[
    {
      "id": "phy12-sec1-charge-coulomb",
      "order": 1,
      "heading_hi": "1. आवेश का क्वांटमीकरण और कूलॉम का नियम — बिल्कुल सरल भाषा में",
      "heading_en": "1. Quantisation of Charge & Coulomb's Law Made Simple",
      "analogy_hi": "सर्दियों में सूखे बालों में प्लास्टिक की कंघी फेरने पर वह कागज़ के छोटे टुकड़ों को खींच लेती है — यही **स्थिरवैद्युत आवेश** है! और **क्वांटमीकरण ($q = \\pm ne$)** को ऐसे समझें: जैसे दुकान पर आप 1, 2 या 5 रुपये के सिक्के दे सकते हैं, कभी $1.5$ या $2.3$ सिक्के नहीं — ठीक वैसे ही किसी वस्तु पर आवेश हमेशा इलेक्ट्रॉन ($e = 1.6 \\times 10^{-19}\\text{ C}$) के **पूर्ण गुणज** में ही हो सकता है!",
      "analogy_en": "In winter, rubbing a dry plastic comb through hair lets it pick up tiny bits of paper — that is **static electric charge**! Think of **quantisation ($q = \\pm ne$)** like coins: you can hold 1, 2, or 5 coins, never $1.5$ coins! Likewise, total charge on any body is always an **integer multiple** of the elementary charge $e = 1.6 \\times 10^{-19}\\text{ C}$!",
      "visual_diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "वैद्युत द्विध्रुव (Electric Dipole) की क्षेत्र रेखाएँ तथा द्विध्रुव आघूर्ण p",
        "title_en": "Electric Field Lines of a Dipole & Dipole Moment Vector p",
        "caption_hi": "वैद्युत क्षेत्र रेखाएँ धनावेश (+q) से निकलकर ऋणावेश (−q) पर समाप्त होती हैं और कभी एक-दूसरे को काटती नहीं। द्विध्रुव आघूर्ण p की दिशा हमेशा −q से +q की ओर होती है!",
        "caption_en": "Electric field lines originate on +q, terminate on −q, and NEVER intersect. Note: Dipole moment vector p points from −q towards +q!",
        "viewBox": "0 0 620 260",
        "elements": [
          { "kind": "path", "d": "M 210 130 Q 310 35 410 130", "fill": "none", "stroke": "#1E3A8A", "strokeWidth": 2.2 },
          { "kind": "path", "d": "M 210 130 Q 310 75 410 130", "fill": "none", "stroke": "#1E3A8A", "strokeWidth": 2.2 },
          { "kind": "path", "d": "M 210 130 Q 310 225 410 130", "fill": "none", "stroke": "#1E3A8A", "strokeWidth": 2.2 },
          { "kind": "path", "d": "M 210 130 Q 310 185 410 130", "fill": "none", "stroke": "#1E3A8A", "strokeWidth": 2.2 },
          { "kind": "arrow", "x1": 210, "y1": 130, "x2": 390, "y2": 130, "stroke": "#1E3A8A", "strokeWidth": 2.2 },
          { "kind": "arrow", "x1": 400, "y1": 225, "x2": 220, "y2": 225, "stroke": "#D97706", "strokeWidth": 3 },
          { "kind": "circle", "cx": 210, "cy": 130, "r": 22, "fill": "#DC2626", "stroke": "#991B1B", "strokeWidth": 2 },
          { "kind": "circle", "cx": 410, "cy": 130, "r": 22, "fill": "#1E3A8A", "stroke": "#1E40AF", "strokeWidth": 2 },
          { "kind": "label", "x": 210, "y": 136, "text_hi": "+q", "text_en": "+q", "fill": "#FFFFFF", "fontSize": 16, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 410, "y": 136, "text_hi": "−q", "text_en": "−q", "fill": "#FFFFFF", "fontSize": 16, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 310, "y": 32, "text_hi": "वैद्युत क्षेत्र रेखाएँ (+q से −q की ओर)", "text_en": "Electric Field Lines (+q to −q)", "fill": "#1E3A8A", "fontSize": 13, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 310, "y": 248, "text_hi": "द्विध्रुव आघूर्ण p (दिशा: −q से +q की ओर, p = q·2a)", "text_en": "Dipole Moment p (Direction: −q to +q, p = q·2a)", "fill": "#B45309", "fontSize": 13, "anchor": "middle", "bold": true }
        ]
      },
      "concept_md_hi": "### कूलॉम का नियम (Coulomb's Law)\nदो स्थिर बिंदु आवेशों $q_1$ और $q_2$ के बीच लगने वाला बल आवेशों के गुणनफल के अनुक्रमानुपाती तथा दूरी के वर्ग के व्युत्क्रमानुपाती होता है:\n$$F = \\frac{1}{4\\pi\\varepsilon_0} \\frac{|q_1 q_2|}{r^2}, \\qquad \\frac{1}{4\\pi\\varepsilon_0} = 9 \\times 10^9\\text{ N}\\cdot\\text{m}^2/\\text{C}^2$$\n- निर्वात की विद्युतशीलता $\\varepsilon_0 = 8.854 \\times 10^{-12}\\text{ C}^2\\text{N}^{-1}\\text{m}^{-2}$ (अथवा $\\text{F/m}$)।\n- किसी परावैद्युत माध्यम ($K$) में बल घटकर $F_m = \\frac{F_{\\text{air}}}{K}$ हो जाता है। जल के लिए $K \\approx 80$ तथा धातु के लिए $K = \\infty$।\n\n### वैद्युत क्षेत्र रेखाओं के 3 अनिवार्य गुण (2-अंक बोर्ड प्रश्न)\n1. ये धनावेश से आरंभ होकर ऋणावेश पर समाप्त होती हैं (बंद लूप नहीं बनातीं)।\n2. **दो वैद्युत क्षेत्र रेखाएँ एक-दूसरे को कभी नहीं काट सकतीं** — क्योंकि कटान बिंदु पर दो स्पर्श रेखाएँ खिंचेंगी, जिसका अर्थ एक ही बिंदु पर वैद्युत क्षेत्र की दो दिशाएँ होंगी जो असंभव है!\n3. जहाँ रेखाएँ सघन (पास-पास) होती हैं वहाँ क्षेत्र प्रबल होता है।",
      "concept_md_en": "### Coulomb's Law\nThe electrostatic force between two stationary point charges $q_1$ and $q_2$ separated by distance $r$ is:\n$$F = \\frac{1}{4\\pi\\varepsilon_0} \\frac{|q_1 q_2|}{r^2}, \\qquad \\frac{1}{4\\pi\\varepsilon_0} = 9 \\times 10^9\\text{ N}\\cdot\\text{m}^2/\\text{C}^2$$\n- Permittivity of free space $\\varepsilon_0 = 8.854 \\times 10^{-12}\\text{ C}^2\\text{N}^{-1}\\text{m}^{-2}$ (or $\\text{F/m}$).\n- In a dielectric medium of constant $K$, force reduces to $F_m = \\frac{F_{\\text{air}}}{K}$ (for metals, $K = \\infty$).\n\n### 3 Core Properties of Electric Field Lines (2-Mark Board Classic)\n1. Start on $+q$ and end on $-q$ (never form closed loops).\n2. **Two electric field lines NEVER intersect** — at an intersection point, two tangents would imply two directions of electric field simultaneously, which is impossible!\n3. Closer lines represent a stronger electric field.",
      "exam_tip_hi": "BSEB Inter सुपर-हॉट ऑब्जेक्टिव: (1) $\\varepsilon_0$ का मात्रक = $\\text{F/m}$ या $\\text{C}^2\\text{N}^{-1}\\text{m}^{-2}$; (2) वैद्युत द्विध्रुव आघूर्ण ($p$) का मात्रक = **कूलॉम-मीटर ($\\text{C}\\cdot\\text{m}$)** (अथवा डेबाई); (3) वैद्युत क्षेत्र ($E$) का मात्रक = $\\text{N/C}$ या $\\text{V/m}$!",
      "exam_tip_en": "BSEB Inter Guaranteed MCQs: (1) Unit of $\\varepsilon_0$ = $\\text{F/m}$; (2) Unit of dipole moment $p$ = **$\\text{C}\\cdot\\text{m}$**; (3) Unit of Electric Field $E$ = $\\text{N/C}$ or $\\text{V/m}$!",
      "glossary_terms": [
        { "term_hi": "वैद्युत द्विध्रुव (Electric Dipole)", "term_en": "Electric Dipole", "definition_hi": "समान परिमाण व विपरीत प्रकृति के दो बिंदु आवेश ($+q$ तथा $-q$) जो अल्प दूरी $2a$ पर रखे हों।", "definition_en": "A pair of equal and opposite point charges ($+q$ and $-q$) separated by a small distance $2a$." }
      ]
    },
    {
      "id": "phy12-sec2-gauss",
      "order": 2,
      "heading_hi": "2. वैद्युत फ्लक्स और गॉस का प्रमेय (हर साल 5-अंक का महा-प्रश्न!)",
      "heading_en": "2. Electric Flux & Gauss's Law (Guaranteed 5-Mark Board Derivation)",
      "analogy_hi": "कल्पना कीजिए किसी गाँव के चापाकल (हैंडपंप) के पाइप से पानी की धारें बाहर निकल रही हैं। पाइप के मुँह के ठीक सामने एक जाली (क्षेत्रफल $A$) रखें — जितनी धारें जाली को लंबवत पार करेंगी वही **फ्लक्स ($\\Phi = E A \\cos\\theta$)** है! अब यदि आप किसी बल्ब ($+q$ आवेश) को एक बड़े गुब्बारे (बंद गॉसीय पृष्ठ) के अंदर बंद कर दें, तो गुब्बारे का आकार छोटा हो या बड़ा — बाहर निकलने वाली कुल रोशनी (फ्लक्स) सिर्फ़ अंदर रखे आवेश $q_{\\text{in}}$ पर निर्भर करेगी: $\\Phi = \\frac{q_{\\text{in}}}{\\varepsilon_0}$!",
      "analogy_en": "Imagine water jets streaming out of a village handpump nozzle through a wire net of area $A$ — the total flow crossing the net perpendicularly is **Flux ($\\Phi = EA\\cos\\theta$)**! Now enclose a glowing bulb ($+q$) inside a closed balloon (Gaussian surface): whether the balloon is small or huge, total flux escaping depends ONLY on enclosed charge: $\\Phi = \\frac{q_{\\text{in}}}{\\varepsilon_0}$!",
      "visual_diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "गॉस का प्रमेय: गोलीय गॉसीय पृष्ठ के अंदर आवेश +q",
        "title_en": "Gauss's Law: Point Charge +q Inside a Spherical Gaussian Surface",
        "caption_hi": "गोलीय पृष्ठ के हर बिंदु पर वैद्युत क्षेत्र E और क्षेत्रफल सदिश dA दोनों त्रिज्यतः बाहर की ओर (θ = 0°, cos 0° = 1) होते हैं।",
        "caption_en": "At every point on the spherical Gaussian surface, E and area vector dA both point radially outward (θ = 0°, cos 0° = 1).",
        "viewBox": "0 0 580 250",
        "elements": [
          { "kind": "circle", "cx": 290, "cy": 125, "r": 85, "fill": "#EFF6FF", "stroke": "#1E3A8A", "strokeWidth": 2.5 },
          { "kind": "circle", "cx": 290, "cy": 125, "r": 16, "fill": "#DC2626" },
          { "kind": "arrow", "x1": 290, "y1": 125, "x2": 430, "y2": 125, "stroke": "#059669", "strokeWidth": 3 },
          { "kind": "arrow", "x1": 375, "y1": 125, "x2": 415, "y2": 125, "stroke": "#D97706", "strokeWidth": 4 },
          { "kind": "arrow", "x1": 290, "y1": 109, "x2": 290, "y2": 20, "stroke": "#059669", "strokeWidth": 2 },
          { "kind": "arrow", "x1": 274, "y1": 125, "x2": 175, "y2": 125, "stroke": "#059669", "strokeWidth": 2 },
          { "kind": "arrow", "x1": 290, "y1": 141, "x2": 290, "y2": 230, "stroke": "#059669", "strokeWidth": 2 },
          { "kind": "label", "x": 290, "y": 130, "text_hi": "+q", "text_en": "+q", "fill": "#FFFFFF", "fontSize": 14, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 330, "y": 115, "text_hi": "त्रिज्या r", "text_en": "Radius r", "fill": "#1E3A8A", "fontSize": 12, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 442, "y": 122, "text_hi": "E व dA (θ = 0°)", "text_en": "E & dA (θ = 0°)", "fill": "#059669", "fontSize": 13, "anchor": "start", "bold": true },
          { "kind": "label", "x": 115, "y": 55, "text_hi": "गॉसीय पृष्ठ (बंद गोला)", "text_en": "Gaussian Sphere", "fill": "#1E3A8A", "fontSize": 13, "anchor": "middle", "bold": true }
        ]
      },
      "concept_md_hi": "### गॉस का प्रमेय (Gauss's Theorem)\nकिसी बंद पृष्ठ से गुजरने वाला कुल वैद्युत फ्लक्स $\\Phi_E$ उस पृष्ठ के भीतर परिबद्ध कुल आवेश $q_{\\text{in}}$ के $\\frac{1}{\\varepsilon_0}$ गुना होता है:\n$$\\Phi_E = \\oint \\vec{E}\\cdot d\\vec{A} = \\frac{q_{\\text{in}}}{\\varepsilon_0}$$\n- वैद्युत फ्लक्स का SI मात्रक: **$\\text{N}\\cdot\\text{m}^2/\\text{C}$** या **$\\text{V}\\cdot\\text{m}$** (अदिश राशि)।\n- **एकसमान आवेशित गोलीय कोश (Spherical Shell) के कारण क्षेत्र:**\n  1. बाहर ($r > R$): $E = \\frac{1}{4\\pi\\varepsilon_0}\\frac{Q}{r^2}$\n  2. पृष्ठ पर ($r = R$): $E = \\frac{1}{4\\pi\\varepsilon_0}\\frac{Q}{R^2}$\n  3. भीतर ($r < R$): **$E = 0$** (क्योंकि भीतर $q_{\\text{in}} = 0$ है — यही **स्थिरवैद्युत परिरक्षण** है; आकाशीय बिजली गिरने पर बंद कार के अंदर बैठना सुरक्षित होता है!)",
      "concept_md_en": "### Gauss's Theorem\nTotal electric flux through any closed surface equals $\\frac{1}{\\varepsilon_0}$ times the net charge enclosed inside it:\n$$\\Phi_E = \\oint \\vec{E}\\cdot d\\vec{A} = \\frac{q_{\\text{in}}}{\\varepsilon_0}$$\n- SI unit of Electric Flux: **$\\text{N}\\cdot\\text{m}^2/\\text{C}$** or **$\\text{V}\\cdot\\text{m}$** (scalar quantity).\n- **Field due to a uniformly charged thin spherical shell:**\n  1. Outside ($r > R$): $E = \\frac{1}{4\\pi\\varepsilon_0}\\frac{Q}{r^2}$\n  2. On surface ($r = R$): $E = \\frac{1}{4\\pi\\varepsilon_0}\\frac{Q}{R^2}$\n  3. Inside ($r < R$): **$E = 0$** (since $q_{\\text{in}} = 0$ — electrostatic shielding!).",
      "exam_tip_hi": "ध्यान दें: यदि किसी बंद पृष्ठ के अंदर एक **वैद्युत द्विध्रुव** ($+q$ और $-q$) रखा हो, तो कुल आवेश $q_{\\text{in}} = +q - q = 0$, इसलिए कुल फ्लक्स **$\\Phi = 0$** होगा! यह BSEB का सबसे फेवरेट ट्रिकी MCQ है!",
      "exam_tip_en": "Favourite BSEB Trick MCQ: If an **electric dipole** ($+q, -q$) sits inside a closed sphere, net enclosed charge is $0$, so total flux is **$\\Phi = 0$**!",
      "glossary_terms": []
    }
  ]$json$::jsonb,
  $json${
    "important_formulas": [
      { "latex": "q = \\pm ne", "label_hi": "आवेश का क्वांटमीकरण", "label_en": "Quantisation of Charge" },
      { "latex": "F = \\frac{1}{4\\pi\\varepsilon_0}\\frac{q_1 q_2}{r^2}", "label_hi": "कूलॉम का नियम", "label_en": "Coulomb's Law" },
      { "latex": "\\tau = pE\\sin\\theta", "label_hi": "द्विध्रुव पर बल-आघूर्ण", "label_en": "Torque on a Dipole" },
      { "latex": "\\Phi_E = \\frac{q_{\\text{in}}}{\\varepsilon_0}", "label_hi": "गॉस का प्रमेय", "label_en": "Gauss's Law" }
    ],
    "key_dates_or_facts": [
      { "tag": "e", "fact_hi": "1 इलेक्ट्रॉन पर आवेश = 1.6 × 10⁻¹⁹ C; 1 C में 6.25 × 10¹⁸ इलेक्ट्रॉन होते हैं।", "fact_en": "Charge of 1 electron = 1.6 × 10⁻¹⁹ C; 1 C contains 6.25 × 10¹⁸ electrons." },
      { "tag": "E_inside", "fact_hi": "आवेशित खोखले चालक गोले के भीतर वैद्युत क्षेत्र हमेशा शून्य (0) होता है।", "fact_en": "Electric field inside a charged hollow conducting sphere is always zero." }
    ],
    "common_bseb_mistakes": [
      { "mistake_hi": "द्विध्रुव आघूर्ण p की दिशा +q से -q लिख देना।", "mistake_en": "Writing dipole moment p direction from +q to -q.", "fix_hi": "क्षेत्र रेखाएँ +q → -q जाती हैं, लेकिन द्विध्रुव आघूर्ण p हमेशा -q से +q की ओर होता है!", "fix_en": "Field lines go +q → -q, whereas dipole moment p ALWAYS points from -q to +q!" }
    ],
    "high_yield_pyq_topics": [
      { "topic_hi": "गॉस का प्रमेय लिखें व सिद्ध करें (अनुप्रयोग सहित)", "topic_en": "State & Prove Gauss's Law with Application", "years": ["2021", "2023", "2024"], "expected_marks": 5 },
      { "topic_hi": "द्विध्रुव के कारण अक्षीय/निरक्षीय वैद्युत क्षेत्र", "topic_en": "Axial & Equatorial Field of a Dipole", "years": ["2022", "2024"], "expected_marks": 5 }
    ]
  }$json$::jsonb,
  $json${
    "hindi_reviewed": true, "english_reviewed": true, "visuals_count": 2, "analogy_count": 2, "bseb_pyq_mapped": true, "syllabus_year": "2026-27"
  }$json$::jsonb,
  'PUBLISHED', 1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json = EXCLUDED.mindmap_json, sections_json = EXCLUDED.sections_json,
  board_capsule_json = EXCLUDED.board_capsule_json, quality_checks_json = EXCLUDED.quality_checks_json,
  status = EXCLUDED.status, version = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'bseb-12-sci-phy-ch1',
  6,
  'विद्यार्थी आवेश के क्वांटमीकरण, कूलॉम के नियम, वैद्युत क्षेत्र रेखाओं, द्विध्रुव बल-आघूर्ण तथा गॉस के प्रमेय का कथन, उपपत्ति व अनुप्रयोग आत्मविश्वास से हल कर सकेंगे।',
  'Students will master charge quantisation, Coulomb''s law, field line properties, dipole torque, and state/prove/apply Gauss''s theorem confidently for BSEB Inter exams.',
  $json$[
    { "period_no": 1, "duration_mins": 45, "phase_hi": "आवेश के गुणधर्म व क्वांटमीकरण (q = ±ne)", "phase_en": "Properties of Charge & Quantisation", "teacher_action_hi": "कंघी-कागज़ प्रयोग से प्रेरण व क्वांटमीकरण समझाएँ; 1 C में इलेक्ट्रॉनों की संख्या (6.25×10¹⁸) हल कराएँ।", "teacher_action_en": "Show comb-paper attraction; compute number of electrons in 1 C (6.25×10¹⁸).", "student_check_hi": "पूछें: क्या किसी वस्तु पर 3.2 × 10⁻²⁰ C आवेश संभव है? (नहीं, n = 0.2 पूर्णांक नहीं!)", "student_check_en": "Ask: Is 3.2 × 10⁻²⁰ C possible? (No, n = 0.2 is not an integer!)" },
    { "period_no": 2, "duration_mins": 45, "phase_hi": "कूलॉम का नियम व परावैद्युतांक K", "phase_en": "Coulomb's Law & Dielectric Constant K", "teacher_action_hi": "ε₀ का मान, SI मात्रक और विमीय सूत्र [M⁻¹L⁻³T⁴A²] बोर्ड पर व्युत्पन्न कराएँ।", "teacher_action_en": "Derive SI unit and dimensional formula [M⁻¹L⁻³T⁴A²] of ε₀ on the blackboard.", "student_check_hi": "पूछें: दूरी दोगुनी करने पर कूलॉम बल कितना रह जाता है? (1/4 गुना)", "student_check_en": "Ask: If distance doubles, what happens to Coulomb force? (Becomes 1/4)" },
    { "period_no": 3, "duration_mins": 45, "phase_hi": "वैद्युत क्षेत्र, क्षेत्र रेखाएँ व द्विध्रुव", "phase_en": "Electric Field, Field Lines & Dipole", "teacher_action_hi": "बोर्ड पर +q और -q की क्षेत्र रेखाएँ बनाकर उनके कभी न काटने का कारण स्पष्ट करें।", "teacher_action_en": "Sketch dipole field lines and prove why two field lines can never cross.", "student_check_hi": "द्विध्रुव आघूर्ण p की दिशा पूछें (−q से +q)।", "student_check_en": "Verify every student knows p points from −q to +q." },
    { "period_no": 4, "duration_mins": 45, "phase_hi": "द्विध्रुव पर बल-आघूर्ण व अक्षीय/निरक्षीय क्षेत्र", "phase_en": "Torque on Dipole & Axial/Equatorial Field", "teacher_action_hi": "τ = pE sinθ व E_axial = 2 E_eq सिद्ध कराएँ।", "teacher_action_en": "Derive τ = pE sinθ and E_axial = 2 E_eq cleanly.", "student_check_hi": "पूछें: किस कोण θ पर बल-आघूर्ण अधिकतम होता है? (θ = 90°)", "student_check_en": "Ask: At what angle θ is dipole torque maximum? (90°)" },
    { "period_no": 5, "duration_mins": 45, "phase_hi": "वैद्युत फ्लक्स व गॉस का प्रमेय (5-अंक निगमन)", "phase_en": "Electric Flux & Gauss's Theorem (5-Mark Proof)", "teacher_action_hi": "गोलीय गॉसीय पृष्ठ बनाकर E·4πr² = q/ε₀ की 4-पंक्ति उपपत्ति कराएँ।", "teacher_action_en": "Walk through the 4-line spherical symmetry proof of Gauss's Law.", "student_check_hi": "पूछें: बंद घन के अंदर एक द्विध्रुव रखा हो तो फ्लक्स कितना होगा? (0)", "student_check_en": "Ask: Flux through a cube enclosing an electric dipole? (Zero)" },
    { "period_no": 6, "duration_mins": 45, "phase_hi": "गोलीय कोश का अनुप्रयोग व इंटर मॉडल टेस्ट", "phase_en": "Spherical Shell Application & Inter Quiz", "teacher_action_hi": "आवेशित चालक गोले के बाहर, सतह पर व भीतर (E=0) क्षेत्र सिद्ध कर लाइव टेस्ट लें।", "teacher_action_en": "Derive E outside, on surface, and inside (E=0) a charged shell, then run a live quiz.", "student_check_hi": "सभी मात्रक व विमाओं का त्वरित मौखिक रिवीजन लें।", "student_check_en": "Rapid-fire oral drill on SI units and dimensions." }
  ]$json$::jsonb,
  $json$[
    {
      "heading_hi": "ब्लैकबोर्ड मात्रक व विमा सारणी (BSEB Inter में 3-4 अंक पक्के)", "heading_en": "Blackboard SI Units Table (3-4 Guaranteed Inter Marks)",
      "points_hi": ["आवेश (q): कूलॉम (C), [AT]", "वैद्युत क्षेत्र (E): N/C या V/m", "द्विध्रुव आघूर्ण (p): C·m, [LTA]", "फ्लक्स (Φ): N·m²/C या V·m  |  ε₀: F/m या C²N⁻¹m⁻²"],
      "points_en": ["Charge (q): C, [AT]", "Electric Field (E): N/C or V/m", "Dipole Moment (p): C·m, [LTA]", "Flux (Φ): N·m²/C or V·m  |  ε₀: F/m"]
    }
  ]$json$::jsonb,
  $json$[
    {
      "title_hi": "स्थिरवैद्युत प्रेरण प्रदर्शन", "title_en": "Electrostatic Induction Demo",
      "materials_hi": "प्लास्टिक पेन/कंघी, सूखे कागज़ के बारीक टुकड़े", "materials_en": "Plastic pen/comb, tiny dry paper bits",
      "steps_hi": "पेन को सूखे बालों पर 10 सेकंड रगड़कर कागज़ के टुकड़ों के पास ले जाएँ और प्रेरण द्वारा आकर्षण दिखाएँ।", "steps_en": "Rub a plastic pen on dry hair for 10s and lift paper bits to visualize induced opposite charge."
    }
  ]$json$::jsonb,
  $json$[
    { "level": "FOUNDATION", "task_hi": "q, E, p, Φ तथा ε₀ के SI मात्रक लिखें और याद करें।", "task_en": "Write and memorize SI units of q, E, p, Φ, and ε₀." },
    { "level": "BOARD", "task_hi": "गॉस का प्रमेय लिखें और एकसमान आवेशित गोलीय कोश के बाहर व भीतर वैद्युत क्षेत्र का व्यंजक प्राप्त करें।", "task_en": "State Gauss's theorem and derive E outside and inside a uniformly charged spherical shell." }
  ]$json$::jsonb,
  $json$[
    { "misconception_hi": "छात्र समझते हैं कि खोखले आवेशित चालक गोले के भीतर वैद्युत विभव भी शून्य होता है।", "misconception_en": "Students think electric potential is also zero inside a hollow charged sphere.", "correction_hi": "स्पष्ट करें: भीतर वैद्युत क्षेत्र E = 0 है, पर विभव V शून्य नहीं बल्कि सतह के बराबर (नियत) होता है!", "correction_en": "Clarify: Inside a conducting shell E = 0, while potential V is constant (equal to surface potential), NOT zero!" }
  ]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods = EXCLUDED.duration_periods, objectives_hi = EXCLUDED.objectives_hi,
  objectives_en = EXCLUDED.objectives_en, teaching_steps_json = EXCLUDED.teaching_steps_json,
  blackboard_points_json = EXCLUDED.blackboard_points_json, classroom_activities_json = EXCLUDED.classroom_activities_json,
  homework_json = EXCLUDED.homework_json, common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  (
    '10000000-0050-4000-8000-000000000001', 'bseb-12-sci-phy', 'bseb-12-sci-phy-ch1', 'SI Units Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB Inter 2024',
    'स्थिरवैद्युतिकी की राशियों को उनके सही SI मात्रक से मिलाएँ:',
    'Match each electrostatic quantity in Column A with its correct SI unit in Column B:',
    NULL, NULL, 'सूत्र याद करें: E = F/q, p = q·2a, Φ = E·A।', 'Use E = F/q, p = q·2a, Φ = E·A.',
    'E (N/C या V/m), p (C·m), Φ (V·m या N·m²/C), ε₀ (F/m)।', 'E (N/C or V/m), p (C·m), Φ (V·m), ε₀ (F/m).',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "MATCH_PAIRS",
      "instruction_hi": "सही SI मात्रक मिलाएँ",
      "instruction_en": "Match each quantity to its SI unit",
      "pairs": [
        { "id": "e1", "left_hi": "वैद्युत क्षेत्र की तीव्रता (E)", "left_en": "Electric Field (E)", "right_hi": "N/C या V/m", "right_en": "N/C or V/m" },
        { "id": "e2", "left_hi": "वैद्युत द्विध्रुव आघूर्ण (p)", "left_en": "Electric Dipole Moment (p)", "right_hi": "कूलॉम-मीटर (C·m)", "right_en": "Coulomb-metre (C·m)" },
        { "id": "e3", "left_hi": "वैद्युत फ्लक्स (Φ)", "left_en": "Electric Flux (Φ)", "right_hi": "V·m या N·m²/C", "right_en": "V·m or N·m²/C" },
        { "id": "e4", "left_hi": "निर्वात की विद्युतशीलता (ε₀)", "left_en": "Permittivity of free space (ε₀)", "right_hi": "फैरड/मीटर (F/m)", "right_en": "Farad/metre (F/m)" }
      ]
    }$json$::jsonb, true
  ),
  (
    '10000000-0050-4000-8000-000000000002', 'bseb-12-sci-phy', 'bseb-12-sci-phy-ch1', 'Gauss Law Trick', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Inter 2024',
    'यदि किसी बंद गोलीय पृष्ठ के भीतर एक वैद्युत द्विध्रुव ($+q$ तथा $-q$) स्थित हो, तो संपूर्ण पृष्ठ से गुजरने वाला कुल वैद्युत फ्लक्स कितना होगा?',
    'An electric dipole ($+q$ and $-q$) is enclosed inside a closed spherical surface. What is the net electric flux through the surface?',
    '[{"key":"A","text_hi":"q / ε₀","text_en":"q / ε₀"},{"key":"B","text_hi":"2q / ε₀","text_en":"2q / ε₀"},{"key":"C","text_hi":"शून्य (0)","text_en":"Zero (0)"},{"key":"D","text_hi":"अनंत (∞)","text_en":"Infinity (∞)"}]'::jsonb,
    'C',
    'गॉस के प्रमेय में $q_{\\text{in}} = +q + (-q)$ का योग निकालें!',
    'Compute net enclosed charge $q_{\\text{in}} = +q + (-q)$ in Gauss''s Law!',
    'द्विध्रुव पर कुल आवेश $q_{\\text{in}} = +q - q = 0$। अतः गॉस प्रमेय से $\\Phi = \\frac{q_{\\text{in}}}{\\varepsilon_0} = 0$।',
    'Net enclosed charge of a dipole is $+q - q = 0$, so by Gauss''s Law $\\Phi = 0 / \\varepsilon_0 = 0$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0050-4000-8000-000000000003', 'bseb-12-sci-phy', 'bseb-12-sci-phy-ch1', 'Dielectric Metal', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB Inter 2023',
    'हवा में निर्वात के सापेक्ष किसी धातु (Metal) का परावैद्युतांक ($K$) कितना होता है?',
    'What is the dielectric constant ($K$) of a metal?',
    '[{"key":"A","text_hi":"0","text_en":"0"},{"key":"B","text_hi":"1","text_en":"1"},{"key":"C","text_hi":"80","text_en":"80"},{"key":"D","text_hi":"अनंत (∞)","text_en":"Infinity (∞)"}]'::jsonb,
    'D',
    'चालक/धातु के भीतर स्थिरवैद्युत क्षेत्र शून्य होता है, $E_{\\text{in}} = E_0 / K = 0$!',
    'Inside a metal, static field is zero: $E_{\\text{in}} = E_0 / K = 0$!',
    'धातु (सुचालक) के भीतर स्थिरवैद्युत क्षेत्र शून्य होने के कारण उसका परावैद्युतांक $K = \\infty$ (अनंत) होता है।',
    'Since electrostatic field inside a conductor vanishes, $K = E_0 / E_{\\text{in}} = \\infty$.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0050-4000-8000-000000000004', 'bseb-12-sci-phy', 'bseb-12-sci-phy-ch1', 'Field Lines 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB Inter 2023',
    'दो वैद्युत क्षेत्र रेखाएँ एक-दूसरे को कभी क्यों नहीं काटतीं?',
    'Why do two electric field lines never intersect each other?',
    NULL, NULL, 'कटान बिंदु पर स्पर्श रेखाओं (दिशाओं) की संख्या सोचें।', 'Think about how many tangents can be drawn at an intersection point.',
    NULL, NULL,
    'किसी वैद्युत क्षेत्र रेखा के किसी बिंदु पर खींची गई स्पर्श रेखा उस बिंदु पर वैद्युत क्षेत्र $\\vec{E}$ की दिशा बताती है। यदि दो क्षेत्र रेखाएँ एक-दूसरे को काटें, तो कटान बिंदु पर **दो स्पर्श रेखाएँ** खींची जा सकेंगी — अर्थात् एक ही बिंदु पर वैद्युत क्षेत्र की **दो अलग-अलग दिशाएँ** होंगी, जो भौतिक रूप से असंभव है। अतः दो क्षेत्र रेखाएँ कभी नहीं काटतीं।',
    'The tangent drawn at any point on an electric field line gives the direction of $\\vec{E}$ at that point. If two field lines intersected, **two tangents** could be drawn at the intersection point, implying **two simultaneous directions of the electric field** at a single point, which is physically impossible.',
    '[{"cue_hi":"स्पर्श रेखा = E की दिशा","cue_en":"Tangent = direction of E"},{"cue_hi":"कटान बिंदु पर दो दिशाएँ = असंभव","cue_en":"Two directions at 1 point = impossible"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"स्पर्श रेखा द्वारा वैद्युत क्षेत्र की दिशा का उल्लेख","criterion_en":"States tangent gives direction of E"},{"step_no":2,"marks":1,"criterion_hi":"कटान बिंदु पर दो दिशाओं के असंभव होने का तर्क","criterion_en":"Explains impossibility of two directions at one point"}]'::jsonb,
    NULL, true
  ),
  (
    '10000000-0050-4000-8000-000000000005', 'bseb-12-sci-phy', 'bseb-12-sci-phy-ch1', 'Gauss Law 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB Inter 2024',
    'गॉस का प्रमेय लिखें एवं इसे सिद्ध करें। इसकी सहायता से एकसमान आवेशित पतले गोलीय कोश के बाहर तथा भीतर वैद्युत क्षेत्र की तीव्रता ज्ञात करें।',
    'State and prove Gauss''s Theorem. Using it, derive the electric field intensity outside and inside a uniformly charged thin spherical shell.',
    NULL, NULL, 'भाग 1: कथन; भाग 2: गोलीय पृष्ठ से उपपत्ति; भाग 3: r > R और r < R के लिए E का सूत्र।',
    'Part 1: Statement; Part 2: Spherical proof; Part 3: E for r > R and r < R.',
    NULL, NULL,
    '**1. गॉस का प्रमेय (कथन):** किसी बंद पृष्ठ से गुजरने वाला कुल वैद्युत फ्लक्स उस पृष्ठ के अंदर परिबद्ध कुल आवेश $q$ के $\\frac{1}{\\varepsilon_0}$ गुना होता है:\n$$\\Phi_E = \\oint \\vec{E}\\cdot d\\vec{A} = \\frac{q}{\\varepsilon_0}$$\n\n**2. उपपत्ति:** माना एक बिंदु आवेश $+q$ त्रिज्या $r$ के गोलीय गॉसीय पृष्ठ के केंद्र पर है। पृष्ठ के प्रत्येक बिंदु पर $E = \\frac{1}{4\\pi\\varepsilon_0}\\frac{q}{r^2}$ तथा $\\vec{E} \\parallel d\\vec{A}$ ($\\theta = 0^\\circ$) है।\n$$\\Phi_E = \\oint E\\,dA\\cos 0^\\circ = E \\oint dA = \\left(\\frac{1}{4\\pi\\varepsilon_0}\\frac{q}{r^2}\\right)(4\\pi r^2) = \\frac{q}{\\varepsilon_0}$$\n\n**3. एकसमान आवेशित गोलीय कोश (त्रिज्या $R$, आवेश $Q$) का अनुप्रयोग:**\n- **बाहर ($r > R$):** त्रिज्या $r$ का संकेंद्री गॉसीय गोला लेने पर $E(4\\pi r^2) = \\frac{Q}{\\varepsilon_0} \\implies E = \\frac{1}{4\\pi\\varepsilon_0}\\frac{Q}{r^2}$।\n- **भीतर ($r < R$):** गॉसीय गोले के अंदर कोई आवेश नहीं है ($q_{\\text{in}} = 0$), अतः $E(4\\pi r^2) = 0 \\implies E = 0$।',
    '**1. Statement:** Total electric flux through any closed surface is $\\frac{1}{\\varepsilon_0}$ times the net enclosed charge $q$: $\\Phi_E = \\oint \\vec{E}\\cdot d\\vec{A} = \\frac{q}{\\varepsilon_0}$.\n\n**2. Proof:** Place $+q$ at the centre of a spherical Gaussian surface of radius $r$. Everywhere on the surface, $\\vec{E} \\parallel d\\vec{A}$ ($\\theta=0^\\circ$) and $E = \\frac{1}{4\\pi\\varepsilon_0}\\frac{q}{r^2}$.\n$$\\Phi_E = E \\oint dA = \\left(\\frac{1}{4\\pi\\varepsilon_0}\\frac{q}{r^2}\\right)(4\\pi r^2) = \\frac{q}{\\varepsilon_0}$$\n\n**3. Application (Thin Spherical Shell of radius $R$, charge $Q$):**\n- **Outside ($r > R$):** $E(4\\pi r^2) = \\frac{Q}{\\varepsilon_0} \\implies E = \\frac{1}{4\\pi\\varepsilon_0}\\frac{Q}{r^2}$.\n- **Inside ($r < R$):** Enclosed charge $q_{\\text{in}} = 0 \\implies E = 0$.',
    '[{"cue_hi":"θ = 0° और गोले का क्षेत्रफल 4πr²","cue_en":"θ = 0° and sphere area = 4πr²"},{"cue_hi":"भीतर q_in = 0 ⇒ E = 0","cue_en":"Inside q_in = 0 ⇒ E = 0"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"गॉस प्रमेय का शुद्ध कथन व सूत्र","criterion_en":"Accurate statement & formula of Gauss law"},{"step_no":2,"marks":1.5,"criterion_hi":"चित्र सहित गोलीय पृष्ठ पर उपपत्ति","criterion_en":"Proof on spherical Gaussian surface with diagram"},{"step_no":3,"marks":1.5,"criterion_hi":"गोलीय कोश के बाहर E = kQ/r² का निगमन","criterion_en":"Derives E = kQ/r² outside the shell"},{"step_no":4,"marks":1,"criterion_hi":"कोश के भीतर q_in = 0 दिखाकर E = 0 सिद्ध करना","criterion_en":"Proves E = 0 inside since q_in = 0"}]'::jsonb,
    NULL, true
  )
ON CONFLICT (id) DO UPDATE SET
  q_hi = EXCLUDED.q_hi, q_en = EXCLUDED.q_en, options_json = EXCLUDED.options_json,
  correct_option = EXCLUDED.correct_option, explanation_hi = EXCLUDED.explanation_hi,
  explanation_en = EXCLUDED.explanation_en, model_answer_hi = EXCLUDED.model_answer_hi,
  model_answer_en = EXCLUDED.model_answer_en, marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json = EXCLUDED.visual_asset_json, bank_pool = EXCLUDED.bank_pool;

-- #############################################################################
-- CHAPTER 6 OF 6: CLASS 12 HISTORY CH 1 — BRICKS, BEADS AND BONES (HARAPPA)
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-12-arts-hist-ch1',
  $json${
    "title_hi": "30-सेकंड माइंडमैप: ईंटें, मनके तथा अस्थियाँ (हड़प्पा सभ्यता)",
    "title_en": "30-Second Mindmap: Bricks, Beads and Bones (Harappan Civilisation)",
    "read_time_seconds": 30,
    "central_node": {
      "id": "har-root",
      "label_hi": "हड़प्पा / सिंधु घाटी सभ्यता",
      "label_en": "Harappan / Indus Civilisation",
      "subtitle_hi": "काल: 2600–1900 ई.पू. · कांस्य युगीन नगरीय सभ्यता",
      "subtitle_en": "Mature Period: 2600–1900 BCE · Bronze Age Urban Culture"
    },
    "branches": [
      {
        "id": "h-town",
        "label_hi": "1. नगर नियोजन (मोहनजोदड़ो)",
        "label_en": "1. Town Planning (Mohenjodaro)",
        "color": "#B45309",
        "children": [
          { "id": "ht1", "label_hi": "दो भाग: दुर्ग (ऊँचा, छोटा) + निचला शहर (बड़ा)", "label_en": "Two parts: Citadel (higher) + Lower Town (larger)" },
          { "id": "ht2", "label_hi": "ग्रिड पद्धति सड़कें (90° समकोण) व ढकी नालियाँ", "label_en": "Grid streets (90° right angles) & covered drains" },
          { "id": "ht3", "label_hi": "पक्की ईंटों का मानक अनुपात = 4 : 2 : 1", "label_en": "Standardized brick ratio = 4 : 2 : 1" }
        ]
      },
      {
        "id": "h-sites",
        "label_hi": "2. प्रमुख स्थल व खोज",
        "label_en": "2. Key Sites & Discoveries",
        "color": "#1E3A8A",
        "children": [
          { "id": "hs1", "label_hi": "हड़प्पा (1921, दयाराम साहनी — रावी नदी)", "label_en": "Harappa (1921, Daya Ram Sahni — Ravi River)" },
          { "id": "hs2", "label_hi": "मोहनजोदड़ो (1922, आर.डी. बनर्जी — सिंधु नदी, विशाल स्नानागार)", "label_en": "Mohenjodaro (1922, R.D. Banerji — Indus, Great Bath)" },
          { "id": "hs3", "label_hi": "लोथल (गुजरात — गोदीवाड़ा/बंदरगाह) · कालीबंगा (जुते हुए खेत)", "label_en": "Lothal (Dockyard) · Kalibangan (Ploughed field)" }
        ]
      },
      {
        "id": "h-craft",
        "label_hi": "3. शिल्प, मुहरें व व्यापार",
        "label_en": "3. Crafts, Seals & Trade",
        "color": "#059669",
        "children": [
          { "id": "hc1", "label_hi": "सेलखड़ी (Steatite) की मुहरें · चन्हुदड़ो मनका केंद्र", "label_en": "Steatite seals · Chanhudaro bead-making hub" },
          { "id": "hc2", "label_hi": "मेसोपोटामिया में हड़प्पा को 'मेलुहा (Meluhha)' कहा गया", "label_en": "Called 'Meluhha' in Mesopotamian texts" }
        ]
      }
    ]
  }$json$::jsonb,
  $json$[
    {
      "id": "hist12-sec1-town",
      "order": 1,
      "heading_hi": "1. दुनिया का पहला स्मार्ट शहर: मोहनजोदड़ो का नगर नियोजन",
      "heading_en": "1. The World's First Planned City: Mohenjodaro's Town Planning",
      "analogy_hi": "4,500 साल पहले जब दुनिया के ज़्यादातर लोग झोपड़ियों में रहते थे, तब हड़प्पा के इंजीनियरों ने **पटना या चंडीगढ़ के आधुनिक सेक्टर** की तरह शहर बसाए थे — हर घर में स्नानघर, सड़कें एक-दूसरे को ठीक $90^\\circ$ पर काटती थीं, और पक्की ईंटों से ढकी हुई नालियाँ (Drainage) पहले बनाई जाती थीं, घर बाद में!",
      "analogy_en": "4,500 years ago, Harappan engineers planned cities like modern smart-city sectors — every home had a paved bathroom connected to covered street drains, roads intersected at exact $90^\\circ$ right angles, and drains were laid out BEFORE houses were built!",
      "visual_diagram": {
        "type": "COMPARISON_TABLE",
        "title_hi": "हड़प्पा सभ्यता के 5 सबसे प्रमुख स्थल (BSEB इंटर इतिहास में हर साल 4-5 MCQ!)",
        "title_en": "5 Most Important Harappan Sites (4-5 Guaranteed BSEB Inter MCQs!)",
        "headers_hi": ["स्थल (Site)", "नदी / वर्तमान स्थान", "प्रमुख खोज व विशेषता"],
        "headers_en": ["Site", "River / Location", "Signature Archaeological Find"],
        "rows": [
          { "cells_hi": ["हड़प्पा (1921)", "रावी नदी (पंजाब, पाक)", "दयाराम साहनी द्वारा खोजा गया पहला स्थल; अन्नागार"], "cells_en": ["Harappa (1921)", "Ravi River (Punjab)", "First site discovered by Daya Ram Sahni; Granaries"] },
          { "cells_hi": ["मोहनजोदड़ो (1922)", "सिंधु नदी (सिंध, पाक)", "आर.डी. बनर्जी; विशाल स्नानागार (Great Bath), काँस्य नर्तकी, 'मृतकों का टीला'"], "cells_en": ["Mohenjodaro (1922)", "Indus River (Sindh)", "R.D. Banerji; Great Bath, Bronze Dancing Girl, 'Mound of the Dead'"] },
          { "cells_hi": ["लोथल", "भोगवा नदी (गुजरात)", "विश्व का प्राचीनतम गोदीवाड़ा (Dockyard / बंदरगाह), चावल के साक्ष्य"], "cells_en": ["Lothal", "Bhogava River (Gujarat)", "Ancient tidal Dockyard (port), bead workshop"] },
          { "cells_hi": ["कालीबंगा", "घग्घर नदी (राजस्थान)", "जुते हुए खेत के प्रमाण, अग्निवेदियाँ, मिट्टी की चूड़ियाँ"], "cells_en": ["Kalibangan", "Ghaggar River (Rajasthan)", "Ploughed field evidence, fire altars"] },
          { "cells_hi": ["चन्हुदड़ो व धोलावीरा", "सिंध / कच्छ (गुजरात)", "चन्हुदड़ो: मनका शिल्प केंद्र · धोलावीरा: अद्भुत जल-जलाशय (Reservoirs)"], "cells_en": ["Chanhudaro & Dholavira", "Sindh / Kutch (Gujarat)", "Chanhudaro: Bead factory · Dholavira: Giant water reservoirs"] }
        ]
      },
      "concept_md_hi": "### मोहनजोदड़ो की 4 अद्भुत विशेषताएँ (5-अंक बोर्ड उत्तर की रीढ़)\n1. **दुर्ग (Citadel) व निचला शहर (Lower Town):** शहर दो भागों में बँटा था। पश्चिम में ऊँचे चबूतरे पर छोटा **दुर्ग** (सार्वजनिक भवन) और पूर्व में बड़ा **निचला शहर** (आवासीय घर)।\n2. **विशाल स्नानागार (Great Bath):** दुर्ग में स्थित आयताकार जलाशय, जिसे जिप्सम के गारे से जलबद्ध (watertight) किया गया था; संभवतः विशेष आनुष्ठानिक स्नान के लिए प्रयुक्त होता था।\n3. **जल निकास प्रणाली (Drainage):** प्रत्येक घर की नाली सड़क की मुख्य ढकी नाली से जुड़ती थी। सफाई के लिए बीच-बीच में मैनहोल (हौदियाँ) बने थे।\n4. **मानकीकृत ईंटें:** पूरे हड़प्पा क्षेत्र में ईंटों की लंबाई : चौड़ाई : मोटाई का अनुपात ठीक **$4 : 2 : 1$** था।",
      "concept_md_en": "### 4 Defining Features of Mohenjodaro (5-Mark Answer Backbone)\n1. **Citadel & Lower Town:** Divided into a higher, walled western **Citadel** (public structures) and a larger eastern **Lower Town** (residential quarters).\n2. **The Great Bath:** A rectangular tank in the Citadel made watertight with gypsum mortar, likely used for ritual bathing.\n3. **Covered Drainage System:** Every house bathroom drained into covered brick street channels with inspection sumps for cleaning.\n4. **Standardized Bricks:** Across the entire civilisation, bricks followed a uniform **$4 : 2 : 1$** (length : breadth : thickness) ratio.",
      "exam_tip_hi": "सुपर-हॉट BSEB Inter MCQ: 'हड़प्पा सभ्यता किस युग की सभ्यता थी?' → **कांस्य युग (Bronze Age)** (लोहे का ज्ञान हड़प्पावासियों को नहीं था!)। 'मोहनजोदड़ो का शाब्दिक अर्थ?' → **मृतकों का टीला (Mound of the Dead)**।",
      "exam_tip_en": "Classic BSEB Inter MCQs: 'Harappan Civilisation belongs to which age?' → **Bronze Age** (they did NOT know iron!). 'Meaning of Mohenjodaro?' → **Mound of the Dead**.",
      "glossary_terms": [
        { "term_hi": "सेलखड़ी (Steatite)", "term_en": "Steatite", "definition_hi": "एक मुलायम पत्थर जिससे हड़प्पा की अधिकांश मुहरें (Seals) और मनके बनाए जाते थे।", "definition_en": "A soft soapstone used to carve most Harappan seals and beads." }
      ]
    }
  ]$json$::jsonb,
  $json${
    "important_formulas": [],
    "key_dates_or_facts": [
      { "tag": "1921", "fact_hi": "दयाराम साहनी ने हड़प्पा (रावी नदी) की खोज की।", "fact_en": "Daya Ram Sahni excavated Harappa (Ravi River)." },
      { "tag": "1922", "fact_hi": "राखालदास बनर्जी ने मोहनजोदड़ो (सिंधु नदी) की खोज की।", "fact_en": "R.D. Banerji excavated Mohenjodaro (Indus River)." },
      { "tag": "1924", "fact_hi": "जॉन मार्शल (ASI महानिदेशक) ने विश्व के सामने सिंधु घाटी सभ्यता की घोषणा की।", "fact_en": "John Marshall (ASI DG) announced the Indus Civilisation to the world." },
      { "tag": "4:2:1", "fact_hi": "हड़प्पा की मानक पक्की ईंट का अनुपात (लंबाई : चौड़ाई : ऊँचाई)।", "fact_en": "Standard Harappan brick ratio (L : B : H)." }
    ],
    "common_bseb_mistakes": [
      { "mistake_hi": "हड़प्पा की नदी 'सिंधु' और मोहनजोदड़ो की नदी 'रावी' उलट देना।", "mistake_en": "Swapping the rivers of Harappa and Mohenjodaro.", "fix_hi": "याद रखें: ह-रा (हड़प्पा = रावी), मो-सिं (मोहनजोदड़ो = सिंधु)!", "fix_en": "Hook: Ha-Ra (Harappa = Ravi), Mo-In (Mohenjodaro = Indus)!" }
    ],
    "high_yield_pyq_topics": [
      { "topic_hi": "हड़प्पा सभ्यता का नगर नियोजन व जल-निकास प्रणाली", "topic_en": "Harappan Town Planning & Drainage", "years": ["2021", "2023", "2024"], "expected_marks": 5 },
      { "topic_hi": "हड़प्पा के स्थल, नदियाँ और खोजकर्ता", "topic_en": "Harappan Sites, Rivers & Excavators", "years": ["2022", "2023", "2024"], "expected_marks": 4 }
    ]
  }$json$::jsonb,
  $json${
    "hindi_reviewed": true, "english_reviewed": true, "visuals_count": 1, "analogy_count": 1, "bseb_pyq_mapped": true, "syllabus_year": "2026-27"
  }$json$::jsonb,
  'PUBLISHED', 1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json = EXCLUDED.mindmap_json, sections_json = EXCLUDED.sections_json,
  board_capsule_json = EXCLUDED.board_capsule_json, quality_checks_json = EXCLUDED.quality_checks_json,
  status = EXCLUDED.status, version = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'bseb-12-arts-hist-ch1',
  5,
  'छात्र हड़प्पा सभ्यता के कालक्रम, प्रमुख स्थलों (हड़प्पा, मोहनजोदड़ो, लोथल, कालीबंगा), नगर नियोजन, जल निकास व्यवस्था, व्यापार और पतन के कारणों का समालोचनात्मक विश्लेषण कर सकेंगे।',
  'Students will locate major Harappan sites, explain town planning and covered drainage, identify trade links with Mesopotamia, and evaluate causes of Harappan decline.',
  $json$[
    { "period_no": 1, "duration_mins": 45, "phase_hi": "खोज की कहानी (1921–24) व मानचित्र परिचय", "phase_en": "Discovery (1921–24) & Map Orientation", "teacher_action_hi": "मानचित्र पर रावी (हड़प्पा), सिंधु (मोहनजोदड़ो), गुजरात (लोथल, धोलावीरा) और राजस्थान (कालीबंगा) दिखाएँ।", "teacher_action_en": "Locate Harappa, Mohenjodaro, Lothal, Dholavira, and Kalibangan on the Indian subcontinent map.", "student_check_hi": "ह-रा (हड़प्पा-रावी) व मो-सिं (मोहनजोदड़ो-सिंधु) ट्रिक से 3 छात्रों से प्रश्न पूछें।", "student_check_en": "Quiz 3 students on site-river pairs." },
    { "period_no": 2, "duration_mins": 45, "phase_hi": "मोहनजोदड़ो: दुर्ग, विशाल स्नानागार व जल निकास", "phase_en": "Mohenjodaro: Citadel, Great Bath & Drainage", "teacher_action_hi": "ब्लैकबोर्ड पर समकोण ग्रिड सड़क और ढकी नाली का नक्शा बनाकर वर्तमान शहर से तुलना कराएँ।", "teacher_action_en": "Sketch a 90° grid street & drainage plan and compare it with modern towns.", "student_check_hi": "पूछें: हड़प्पा ईंटों का मानक अनुपात क्या था? (4:2:1)", "student_check_en": "Ask: What was the standardized Harappan brick ratio? (4:2:1)" },
    { "period_no": 3, "duration_mins": 45, "phase_hi": "शिल्प उत्पादन, मुहरें, लिपि व बाट", "phase_en": "Crafts, Steatite Seals, Script & Weights", "teacher_action_hi": "सेलखड़ी मुहर, एकश्रृंगी पशु, चन्हुदड़ो मनका उद्योग और अब तक न पढ़ी जा सकी लिपि समझाएँ।", "teacher_action_en": "Explain steatite unicorn seals, Chanhudaro beads, and the undeciphered right-to-left script.", "student_check_hi": "पूछें: हड़प्पा की लिपि किस दिशा से किस दिशा में लिखी जाती थी? (दाएँ से बाएँ)", "student_check_en": "Ask: In which direction was Harappan script written? (Right to left)" },
    { "period_no": 4, "duration_mins": 45, "phase_hi": "विदेशी व्यापार (मेलुहा) व पतन के कारण", "phase_en": "Foreign Trade (Meluhha) & Decline Theories", "teacher_action_hi": "ओमान (मगन) से ताँबा, अफगानिस्तान से लाजवर्द मणि और जलवायु/बाढ़/नदी सूखने जैसे पतन के कारण समझाएँ।", "teacher_action_en": "Cover copper from Oman (Magan), lapis lazuli from Afghanistan, and ecological decline causes.", "student_check_hi": "पूछें: मेसोपोटामिया लेखों में हड़प्पा क्षेत्र को क्या कहा गया? (मेलुहा)", "student_check_en": "Ask: What name did Mesopotamian texts use for Harappa? (Meluhha)" },
    { "period_no": 5, "duration_mins": 45, "phase_hi": "इंटरमीडिएट 5-अंक उत्तर लेखन व लाइव क्विज़", "phase_en": "Inter 5-Mark Writing & Live Quiz", "teacher_action_hi": "नगर नियोजन पर 5-शीर्षक उत्तर प्रारूप का अभ्यास और 10 ऑब्जेक्टिव का लाइव टेस्ट कराएँ।", "teacher_action_en": "Model a 5-heading essay on town planning and host a 10-MCQ live quiz.", "student_check_hi": "गलत उत्तरों की तुरंत समीक्षा करें।", "student_check_en": "Review commonly missed MCQs immediately." }
  ]$json$::jsonb,
  $json$[
    {
      "heading_hi": "ब्लैकबोर्ड रिवीजन (हड़प्पा सभ्यता)", "heading_en": "Blackboard Key Facts",
      "points_hi": ["हड़प्पा (1921, दयाराम साहनी, रावी) | मोहनजोदड़ो (1922, आर.डी. बनर्जी, सिंधु)", "लोथल = गोदीवाड़ा (गुजरात) | कालीबंगा = जुते हुए खेत (राजस्थान)", "ईंट अनुपात = 4:2:1 | युग = कांस्य युग (लोहा अज्ञात था)", "मुहर = सेलखड़ी (Steatite) | लिपि = दाएँ से बाएँ (अपरिचित)"],
      "points_en": ["Harappa (1921, Sahni, Ravi) | Mohenjodaro (1922, Banerji, Indus)", "Lothal = Dockyard | Kalibangan = Ploughed field", "Brick ratio = 4:2:1 | Bronze Age (Iron unknown)", "Seals = Steatite | Script = Right-to-left (undeciphered)"]
    }
  ]$json$::jsonb,
  $json$[
    {
      "title_hi": "पुरातत्वविद् बनें (स्रोत विश्लेषण)", "title_en": "Be an Archaeologist",
      "materials_hi": "ब्लैकबोर्ड पर मुहर, बाट (चर्ट पत्थर) और ईंट का रेखाचित्र", "materials_en": "Blackboard sketch of seal, chert weights, and brick",
      "steps_hi": "छात्रों से पूछें: बिना पढ़ी गई लिपि के हम कैसे जान पाए कि हड़प्पा के लोग व्यापार करते थे? (बाट, मुहरें, लोथल बंदरगाह!)", "steps_en": "Ask: Without deciphering the script, how do archaeologists prove Harappans traded widely?"
    }
  ]$json$::jsonb,
  $json$[
    { "level": "FOUNDATION", "task_hi": "हड़प्पा, मोहनजोदड़ो, लोथल व कालीबंगा की स्थिति और 1-1 विशेषता लिखें।", "task_en": "Write location and 1 key discovery each for Harappa, Mohenjodaro, Lothal, and Kalibangan." },
    { "level": "BOARD", "task_hi": "हड़प्पा सभ्यता के नगर नियोजन और जल-निकास प्रणाली की मुख्य विशेषताओं का वर्णन करें।", "task_en": "Describe the major features of Harappan town planning and drainage system." }
  ]$json$::jsonb,
  $json$[
    { "misconception_hi": "छात्र सोचते हैं कि हड़प्पा के लोग लोहे के औज़ार इस्तेमाल करते थे।", "misconception_en": "Students assume Harappans used iron tools.", "correction_hi": "स्पष्ट करें: हड़प्पा **कांस्य युगीन** (ताँबा + टिन) सभ्यता थी; लोहा बहुत बाद में (उत्तर वैदिक काल) आया!", "correction_en": "Clarify: Harappa was a **Bronze Age** (copper + tin) civilisation; iron appeared centuries later!" }
  ]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods = EXCLUDED.duration_periods, objectives_hi = EXCLUDED.objectives_hi,
  objectives_en = EXCLUDED.objectives_en, teaching_steps_json = EXCLUDED.teaching_steps_json,
  blackboard_points_json = EXCLUDED.blackboard_points_json, classroom_activities_json = EXCLUDED.classroom_activities_json,
  homework_json = EXCLUDED.homework_json, common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  (
    '10000000-0060-4000-8000-000000000001', 'bseb-12-arts-hist', 'bseb-12-arts-hist-ch1', 'Harappan Sites Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB Inter 2024',
    'हड़प्पा स्थलों को उनकी प्रमुख खोज से मिलाएँ:',
    'Match each Harappan site with its iconic archaeological discovery:',
    NULL, NULL, 'लोथल गुजरात का समुद्री बंदरगाह था और कालीबंगा राजस्थान में है।',
    'Lothal was the Gujarat sea port and Kalibangan is in Rajasthan.',
    'मोहनजोदड़ो (विशाल स्नानागार), लोथल (गोदीवाड़ा), कालीबंगा (जुते हुए खेत), चन्हुदड़ो (मनका केंद्र)।',
    'Mohenjodaro (Great Bath), Lothal (Dockyard), Kalibangan (Ploughed field), Chanhudaro (Bead centre).',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "MATCH_PAIRS",
      "instruction_hi": "स्थल को सही खोज से मिलाएँ",
      "instruction_en": "Match each site to its discovery",
      "pairs": [
        { "id": "h1", "left_hi": "मोहनजोदड़ो", "left_en": "Mohenjodaro", "right_hi": "विशाल स्नानागार (Great Bath)", "right_en": "The Great Bath" },
        { "id": "h2", "left_hi": "लोथल (गुजरात)", "left_en": "Lothal (Gujarat)", "right_hi": "प्राचीन गोदीवाड़ा (Dockyard)", "right_en": "Ancient Dockyard (Port)" },
        { "id": "h3", "left_hi": "कालीबंगा (राजस्थान)", "left_en": "Kalibangan (Rajasthan)", "right_hi": "जुते हुए खेत के साक्ष्य", "right_en": "Evidence of ploughed field" },
        { "id": "h4", "left_hi": "चन्हुदड़ो", "left_en": "Chanhudaro", "right_hi": "मनका बनाने का शिल्प केंद्र", "right_en": "Bead-making craft hub" }
      ]
    }$json$::jsonb, true
  ),
  (
    '10000000-0060-4000-8000-000000000002', 'bseb-12-arts-hist', 'bseb-12-arts-hist-ch1', 'Harappa River', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Inter 2024',
    'हड़प्पा किस नदी के किनारे स्थित है?',
    'On the bank of which river is the ancient site of Harappa located?',
    '[{"key":"A","text_hi":"सिंधु (Indus)","text_en":"Indus"},{"key":"B","text_hi":"रावी (Ravi)","text_en":"Ravi"},{"key":"C","text_hi":"सतलज (Sutlej)","text_en":"Sutlej"},{"key":"D","text_hi":"व्यास (Beas)","text_en":"Beas"}]'::jsonb,
    'B',
    'ट्रिक याद करें: ह-रा (हड़प्पा = रावी) और मो-सिं (मोहनजोदड़ो = सिंधु)!',
    'Recall the hook: Ha-Ra (Harappa = Ravi) and Mo-In (Mohenjodaro = Indus)!',
    'हड़प्पा रावी नदी के तट पर स्थित है, जिसकी खोज 1921 में दयाराम साहनी ने की थी।',
    'Harappa sits on the bank of the Ravi River and was excavated in 1921 by Daya Ram Sahni.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0060-4000-8000-000000000003', 'bseb-12-arts-hist', 'bseb-12-arts-hist-ch1', 'Metals Known', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB Inter 2023',
    'सिंधु घाटी के निवासियों को निम्नलिखित में से किस धातु का ज्ञान नहीं था?',
    'Which of the following metals was NOT known to the people of the Indus Valley Civilisation?',
    '[{"key":"A","text_hi":"सोना (Gold)","text_en":"Gold"},{"key":"B","text_hi":"चाँदी (Silver)","text_en":"Silver"},{"key":"C","text_hi":"लोहा (Iron)","text_en":"Iron"},{"key":"D","text_hi":"ताँबा (Copper)","text_en":"Copper"}]'::jsonb,
    'C',
    'हड़प्पा एक कांस्य युगीन (ताँबा + टिन) सभ्यता थी!',
    'Harappa was a Bronze Age (copper + tin) civilisation!',
    'हड़प्पावासी सोना, चाँदी, ताँबा और काँसा जानते थे, लेकिन उन्हें **लोहे (Iron)** का ज्ञान नहीं था।',
    'Harappans used gold, silver, copper, and bronze, but had NO knowledge of **iron**.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  (
    '10000000-0060-4000-8000-000000000004', 'bseb-12-arts-hist', 'bseb-12-arts-hist-ch1', 'Town Planning 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB Inter 2024',
    'हड़प्पा सभ्यता के नगर नियोजन तथा जल-निकास प्रणाली की प्रमुख विशेषताओं का वर्णन करें।',
    'Describe the key features of town planning and the drainage system of the Harappan Civilisation.',
    NULL, NULL, '5 स्पष्ट बिंदुओं में लिखें: दो भाग (दुर्ग/निचला शहर), समकोण ग्रिड सड़कें, ढकी नालियाँ, पक्की ईंटें (4:2:1) और विशाल स्नानागार।',
    'Write 5 clear headings: Citadel & Lower Town, Grid Streets, Covered Drainage, 4:2:1 Bricks, and Great Bath.',
    NULL, NULL,
    'हड़प्पा सभ्यता अपनी उन्नत नगरीय योजना के लिए विश्व प्रसिद्ध है:\n\n**1. नगर का दो भागों में विभाजन:** शहर पश्चिम में ऊँचे **दुर्ग (Citadel)** और पूर्व में बड़े **निचले शहर (Lower Town)** में विभाजित था।\n**2. ग्रिड पद्धति पर सड़कें:** चौड़ी सड़कें और गलियाँ एक-दूसरे को ठीक $90^\\circ$ (समकोण) पर काटती थीं।\n**3. अद्वितीय जल-निकास प्रणाली (Drainage):** प्रत्येक घर के स्नानघर की नाली बाहर सड़क की मुख्य ढकी हुई पक्की नाली से जुड़ती थी। सफाई हेतु बीच-बीच में मैनहोल (हौदियाँ) बने थे।\n**4. मानकीकृत पक्की ईंटें:** संपूर्ण सभ्यता में $4 : 2 : 1$ अनुपात की पक्की ईंटों का उपयोग हुआ।\n**5. विशाल स्नानागार व अन्नागार:** मोहनजोदड़ो के दुर्ग में जिप्सम से जलबद्ध विशाल स्नानागार और विशाल अन्नागार उत्कृष्ट अभियांत्रिकी के प्रमाण हैं।',
    'The Harappan Civilisation is renowned worldwide for its scientific urban planning:\n\n**1. Dual City Layout:** Divided into an elevated western **Citadel** (public structures) and a sprawling eastern **Lower Town** (residential).\n**2. Grid-Pattern Roads:** Broad streets and lanes intersected neatly at $90^\\circ$ right angles.\n**3. Covered Drainage Network:** Every house bathroom drained into covered brick street drains equipped with removable slabs and sumps for periodic cleaning.\n**4. Standardized Bricks:** Kiln-baked bricks across regions adhered strictly to the $4 : 2 : 1$ ratio.\n**5. Great Bath & Granaries:** Mohenjodaro''s gypsum-sealed Great Bath and large granaries reflect extraordinary civic engineering.',
    '[{"cue_hi":"दुर्ग + निचला शहर","cue_en":"Citadel + Lower Town"},{"cue_hi":"90° ग्रिड सड़कें व ढकी नालियाँ","cue_en":"90° grid streets & covered drains"},{"cue_hi":"ईंट अनुपात 4:2:1 + विशाल स्नानागार","cue_en":"4:2:1 bricks + Great Bath"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"दुर्ग व निचले शहर का विभाजन","criterion_en":"Explains Citadel & Lower Town division"},{"step_no":2,"marks":1,"criterion_hi":"समकोण ग्रिड सड़क व्यवस्था","criterion_en":"Mentions 90° grid street layout"},{"step_no":3,"marks":1.5,"criterion_hi":"ढकी जल-निकास प्रणाली व मैनहोल का विवरण","criterion_en":"Details covered drains & cleaning sumps"},{"step_no":4,"marks":1.5,"criterion_hi":"4:2:1 मानक ईंट व विशाल स्नानागार का उल्लेख","criterion_en":"Includes 4:2:1 brick standard & Great Bath"}]'::jsonb,
    NULL, true
  )
ON CONFLICT (id) DO UPDATE SET
  q_hi = EXCLUDED.q_hi, q_en = EXCLUDED.q_en, options_json = EXCLUDED.options_json,
  correct_option = EXCLUDED.correct_option, explanation_hi = EXCLUDED.explanation_hi,
  explanation_en = EXCLUDED.explanation_en, model_answer_hi = EXCLUDED.model_answer_hi,
  model_answer_en = EXCLUDED.model_answer_en, marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json = EXCLUDED.visual_asset_json, bank_pool = EXCLUDED.bank_pool;

-- #############################################################################
-- SUPPLEMENTAL GOLD PRACTICE QUESTIONS (Ensuring Full One-Stop Coverage Across
-- All 6 Flagship Chapters: Flashcards, Diagram Labels, Short 2M & Exam-Only MCQs)
-- #############################################################################

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- Ch 2 (Class 10 Math Ch 4): Interactive Parabola Diagram Label
  (
    '10000000-0020-4000-8000-000000000009', 'bseb-10-math', 'bseb-10-math-ch4', 'Parabola Roots Diagram', 'PRACTICE', 'DIAGRAM_LABEL', 'BOARD', NULL,
    'द्विघात समीकरण $y = x^2 - 5x + 6$ के ग्राफ़ पर बिंदु (1), (2) और (3) को पहचानें:',
    'Identify the labeled points (1), (2), and (3) on the parabola graph of $y = x^2 - 5x + 6$:',
    NULL, NULL,
    'जहाँ वक्र X-अक्ष को काटता है वे दोनों मूल (Roots) हैं और सबसे निचला बिंदु शीर्ष (Vertex) है।',
    'Where the curve crosses the X-axis are its roots, and its lowest turning point is the vertex.',
    'परवलय X-अक्ष को x = 2 और x = 3 पर काटता है (दो वास्तविक मूल) और x = 2.5 पर न्यूनतम बिंदु (शीर्ष) है।',
    'The parabola crosses the X-axis at roots x = 2 and x = 3, with its vertex at x = 2.5.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "DIAGRAM_LABEL",
      "instruction_hi": "ग्राफ़ के बिंदु (1), (2) और (3) का सही नाम चुनें",
      "instruction_en": "Choose the right label for points (1), (2), and (3)",
      "diagram": {
        "type": "SVG_DIAGRAM",
        "title_hi": "परवलय के मुख्य बिंदु पहचानें",
        "title_en": "Identify Key Features of the Parabola",
        "caption_hi": "y = x² − 5x + 6 का आलेख",
        "caption_en": "Graph of y = x² − 5x + 6",
        "viewBox": "0 0 560 240",
        "elements": [
          { "kind": "arrow", "x1": 50, "y1": 170, "x2": 510, "y2": 170, "stroke": "#334155", "strokeWidth": 2 },
          { "kind": "arrow", "x1": 120, "y1": 225, "x2": 120, "y2": 20, "stroke": "#334155", "strokeWidth": 2 },
          { "kind": "path", "d": "M 180 30 Q 320 345 460 30", "fill": "none", "stroke": "#1E3A8A", "strokeWidth": 3.5 },
          { "kind": "circle", "cx": 265, "cy": 170, "r": 7, "fill": "#059669" },
          { "kind": "circle", "cx": 375, "cy": 170, "r": 7, "fill": "#059669" },
          { "kind": "circle", "cx": 320, "cy": 188, "r": 7, "fill": "#D97706" },
          { "kind": "label", "x": 250, "y": 154, "text_hi": "(1)", "text_en": "(1)", "fill": "#059669", "fontSize": 15, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 390, "y": 154, "text_hi": "(2)", "text_en": "(2)", "fill": "#059669", "fontSize": 15, "anchor": "middle", "bold": true },
          { "kind": "label", "x": 320, "y": 212, "text_hi": "(3)", "text_en": "(3)", "fill": "#D97706", "fontSize": 15, "anchor": "middle", "bold": true }
        ]
      },
      "hotspots": [
        { "id": "m1", "x": 265, "y": 170, "label_code": "1", "answer_hi": "पहला मूल (x = 2)", "answer_en": "First Root (x = 2)", "options_hi": ["पहला मूल (x = 2)", "दूसरा मूल (x = 3)", "शीर्ष (Vertex)"], "options_en": ["First Root (x = 2)", "Second Root (x = 3)", "Vertex"] },
        { "id": "m2", "x": 375, "y": 170, "label_code": "2", "answer_hi": "दूसरा मूल (x = 3)", "answer_en": "Second Root (x = 3)", "options_hi": ["पहला मूल (x = 2)", "दूसरा मूल (x = 3)", "शीर्ष (Vertex)"], "options_en": ["First Root (x = 2)", "Second Root (x = 3)", "Vertex"] },
        { "id": "m3", "x": 320, "y": 188, "label_code": "3", "answer_hi": "शीर्ष (Vertex)", "answer_en": "Vertex", "options_hi": ["पहला मूल (x = 2)", "दूसरा मूल (x = 3)", "शीर्ष (Vertex)"], "options_en": ["First Root (x = 2)", "Second Root (x = 3)", "Vertex"] }
      ]
    }$json$::jsonb, true
  ),
  -- Ch 4 (Class 9 Science Ch 7): Flashcard & Short 2M
  (
    '10000000-0040-4000-8000-000000000005', 'bseb-9-sci', 'bseb-9-sci-ch7', 'Motion Equations Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'गति के तीनों समीकरण क्या हैं?',
    'What are the three equations of uniformly accelerated motion?',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "FLASHCARD",
      "front_hi": "एकसमान त्वरण (a) के लिए गति के तीनों समीकरण और km/h → m/s नियम बताएँ।",
      "front_en": "State all three equations of motion and the km/h to m/s conversion factor.",
      "back_hi": "1) v = u + at  |  2) s = ut + ½at²  |  3) v² − u² = 2as। km/h से m/s बदलने के लिए 5/18 से गुणा करें।",
      "back_en": "1) v = u + at  |  2) s = ut + ½at²  |  3) v² − u² = 2as. Multiply km/h by 5/18 to get m/s.",
      "formula_latex": "v = u + at,\\quad s = ut + \\frac{1}{2}at^2,\\quad v^2 - u^2 = 2as"
    }$json$::jsonb, true
  ),
  (
    '10000000-0040-4000-8000-000000000006', 'bseb-9-sci', 'bseb-9-sci-ch7', 'Distance vs Displacement 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB Class 9',
    'दूरी (Distance) और विस्थापन (Displacement) में दो प्रमुख अंतर लिखें।',
    'Write two key differences between Distance and Displacement.',
    NULL, NULL, 'अदिश बनाम सदिश तथा शून्य होने की संभावना लिखें।', 'Contrast scalar vs vector and whether each can be zero.',
    NULL, NULL,
    '1. **परिभाषा व राशि:** दूरी तय किए गए कुल पथ की लंबाई है (अदिश राशि), जबकि विस्थापन प्रारंभिक व अंतिम बिंदु के बीच की न्यूनतम सीधी दूरी है (सदिश राशि)।\n2. **मान:** गतिशील वस्तु की दूरी कभी शून्य या ऋणात्मक नहीं होती, जबकि विस्थापन शून्य, धनात्मक या ऋणात्मक हो सकता है।',
    '1. **Nature:** Distance is total path length (scalar), whereas displacement is the shortest straight-line distance from start to end (vector).\n2. **Zero/Sign:** Distance for a moving body is always positive, whereas displacement can be positive, negative, or zero.',
    '[{"cue_hi":"दूरी = अदिश, हमेशा धनात्मक","cue_en":"Distance = scalar, always positive"},{"cue_hi":"विस्थापन = सदिश, 0 भी संभव","cue_en":"Displacement = vector, can be 0"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"अदिश/सदिश व परिभाषा का अंतर","criterion_en":"Distinguishes scalar path length vs vector shortest path"},{"step_no":2,"marks":1,"criterion_hi":"शून्य व चिह्न का अंतर","criterion_en":"Notes distance > 0 while displacement can be 0 or negative"}]'::jsonb,
    NULL, true
  ),
  -- Ch 5 (Class 12 Physics Ch 1): Flashcard + Interactive Dipole Diagram Label
  (
    '10000000-0050-4000-8000-000000000006', 'bseb-12-sci-phy', 'bseb-12-sci-phy-ch1', 'Dipole & Gauss Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB Inter 2024',
    'वैद्युत द्विध्रुव आघूर्ण (p) की दिशा, सूत्र और SI मात्रक क्या हैं?',
    'What are the direction, formula, and SI unit of Electric Dipole Moment (p)?',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "FLASHCARD",
      "front_hi": "वैद्युत द्विध्रुव आघूर्ण (p) का सूत्र, SI मात्रक और दिशा बताएँ।",
      "front_en": "State the formula, SI unit, and direction of Electric Dipole Moment (p).",
      "back_hi": "सूत्र: p = q · 2a | SI मात्रक: कूलॉम-मीटर (C·m) | दिशा: हमेशा ऋणावेश (−q) से धनावेश (+q) की ओर!",
      "back_en": "Formula: p = q · 2a | SI unit: Coulomb-metre (C·m) | Direction: Always from −q to +q!",
      "formula_latex": "\\vec{p} = q \\cdot 2\\vec{a}"
    }$json$::jsonb, true
  ),
  (
    '10000000-0050-4000-8000-000000000007', 'bseb-12-sci-phy', 'bseb-12-sci-phy-ch1', 'Quantisation MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Inter 2022',
    '1 कूलॉम (1 C) आवेश में कितने इलेक्ट्रॉन होते हैं?',
    'How many electrons constitute $1\\text{ Coulomb}$ ($1\\text{ C}$) of electric charge?',
    '[{"key":"A","text_hi":"1.6 × 10⁻¹⁹","text_en":"1.6 × 10⁻¹⁹"},{"key":"B","text_hi":"6.25 × 10¹⁸","text_en":"6.25 × 10¹⁸"},{"key":"C","text_hi":"6.25 × 10¹⁹","text_en":"6.25 × 10¹⁹"},{"key":"D","text_hi":"9 × 10⁹","text_en":"9 × 10⁹"}]'::jsonb,
    'B',
    'क्वांटमीकरण सूत्र $n = q / e$ में $q = 1\\text{ C}$ और $e = 1.6 \\times 10^{-19}\\text{ C}$ रखें।',
    'Use $n = q / e$ with $q = 1\\text{ C}$ and $e = 1.6 \\times 10^{-19}\\text{ C}$.',
    '$n = \\frac{1}{1.6 \\times 10^{-19}} = 6.25 \\times 10^{18}$ इलेक्ट्रॉन।',
    '$n = \\frac{1}{1.6 \\times 10^{-19}} = 6.25 \\times 10^{18}$ electrons.',
    NULL, NULL, '[]'::jsonb, '[]'::jsonb, NULL, true
  ),
  -- Ch 6 (Class 12 History Ch 1): Flashcard + Short 2M
  (
    '10000000-0060-4000-8000-000000000005', 'bseb-12-arts-hist', 'bseb-12-arts-hist-ch1', 'Harappa Discovery Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB Inter 2024',
    'हड़प्पा व मोहनजोदड़ो की खोज किसने, कब और किस नदी के किनारे की?',
    'Who discovered Harappa and Mohenjodaro, when, and on which rivers?',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]'::jsonb, '[]'::jsonb,
    $json${
      "kind": "FLASHCARD",
      "front_hi": "हड़प्पा और मोहनजोदड़ो के खोजकर्ता, वर्ष और नदियों के नाम बताएँ।",
      "front_en": "Name the excavators, years, and rivers of Harappa and Mohenjodaro.",
      "back_hi": "हड़प्पा: 1921, दयाराम साहनी, रावी नदी | मोहनजोदड़ो: 1922, राखालदास (आर.डी.) बनर्जी, सिंधु नदी।",
      "back_en": "Harappa: 1921, Daya Ram Sahni, Ravi River | Mohenjodaro: 1922, R.D. Banerji, Indus River.",
      "mnemonic_hi": "ह-रा (हड़प्पा = रावी) और मो-सिं (मोहनजोदड़ो = सिंधु)",
      "mnemonic_en": "Ha-Ra (Harappa = Ravi) and Mo-In (Mohenjodaro = Indus)"
    }$json$::jsonb, true
  ),
  (
    '10000000-0060-4000-8000-000000000006', 'bseb-12-arts-hist', 'bseb-12-arts-hist-ch1', 'Carbon 14 & Great Bath 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB Inter 2023',
    'मोहनजोदड़ो के विशाल स्नानागार (Great Bath) की दो प्रमुख विशेषताएँ लिखें।',
    'Write two major features of the Great Bath of Mohenjodaro.',
    NULL, NULL, 'स्थान (दुर्ग), सीढ़ियाँ व जिप्सम जलबद्ध ईंटों का उल्लेख करें।', 'Mention Citadel location, north-south steps, and gypsum watertight mortar.',
    NULL, NULL,
    '1. यह मोहनजोदड़ो के **दुर्ग (Citadel)** में स्थित एक विशाल आयताकार जलाशय था जिसके उत्तरी व दक्षिणी सिरों पर नीचे उतरने के लिए सीढ़ियाँ बनी थीं।\n2. पानी के रिसाव को रोकने के लिए इसके फर्श व दीवारों को **पक्की ईंटों और जिप्सम के गारे** से जलबद्ध (Watertight) किया गया था; संभवतः इसका उपयोग विशेष आनुष्ठानिक स्नान के लिए होता था।',
    '1. Located in Mohenjodaro''s **Citadel**, it was a large rectangular tank with flights of steps leading down from both the north and south ends.\n2. Its bricks were set on edge and sealed with **gypsum mortar** to make it watertight, suggesting use for special ritual bathing.',
    '[{"cue_hi":"दुर्ग में स्थित + उत्तर-दक्षिण सीढ़ियाँ","cue_en":"In Citadel + north-south steps"},{"cue_hi":"जिप्सम गारे से जलबद्ध + आनुष्ठानिक स्नान","cue_en":"Gypsum watertight mortar + ritual bath"}]'::jsonb,
    '[{"step_no":1,"marks":1,"criterion_hi":"दुर्ग में स्थिति व सीढ़ियों का उल्लेख","criterion_en":"Mentions Citadel location and steps"},{"step_no":2,"marks":1,"criterion_hi":"जिप्सम से जलबद्ध संरचना व आनुष्ठानिक महत्व","criterion_en":"Mentions gypsum watertight construction & ritual purpose"}]'::jsonb,
    NULL, true
  )
ON CONFLICT (id) DO UPDATE SET
  q_hi = EXCLUDED.q_hi, q_en = EXCLUDED.q_en, options_json = EXCLUDED.options_json,
  correct_option = EXCLUDED.correct_option, explanation_hi = EXCLUDED.explanation_hi,
  explanation_en = EXCLUDED.explanation_en, model_answer_hi = EXCLUDED.model_answer_hi,
  model_answer_en = EXCLUDED.model_answer_en, marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json = EXCLUDED.visual_asset_json, bank_pool = EXCLUDED.bank_pool;

-- #############################################################################
-- PART 4 / 4: POST-MIGRATION VERIFICATION SUMMARY (READ-ONLY)
-- #############################################################################

SELECT table_name, row_count
FROM (
  SELECT 1 AS sort_id, 'subjects'      AS table_name, COUNT(*)::bigint AS row_count FROM public.subjects
  UNION ALL
  SELECT 2,            'chapters',                    COUNT(*)::bigint              FROM public.chapters
  UNION ALL
  SELECT 3,            'chapter_notes',               COUNT(*)::bigint              FROM public.chapter_notes
  UNION ALL
  SELECT 4,            'lesson_plans',                COUNT(*)::bigint              FROM public.lesson_plans
  UNION ALL
  SELECT 5,            'questions',                   COUNT(*)::bigint              FROM public.questions
  UNION ALL
  SELECT 6,            'schools',                     COUNT(*)::bigint              FROM public.schools
  UNION ALL
  SELECT 7,            'super_admins',                COUNT(*)::bigint              FROM public.super_admins
) AS summary
ORDER BY sort_id;
