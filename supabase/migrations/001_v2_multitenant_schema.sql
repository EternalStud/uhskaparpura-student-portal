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
