# Students of Bihar (Class 9–12) — System Design (v2.5 Architecture)

> **Philosophy:** Quality over quantity. Warm, distraction-free editorial academic design tailored for Bihar Board (BSEB) government school students, teachers, and school administrators — launched in production with **Uchch Madhyamik Vidyalaya, Kaparpura (Kanti, Muzaffarpur)** as School #1 (`https://students.uhskaparpurakanti.in`) and architected cleanly for statewide multi-tenant onboarding.

---

## 1. Product Principles & Design Language

- **Warm Editorial Paper-First Aesthetic:** Inspired by Apple Education, Khan Academy, Notion, and Brilliant.org.
  - Light Canvas: `#FAFAF9` warm ivory paper, `#FFFFFF` crisp cards, `#E5E7EB` hairlines, `#0F172A` slate ink.
  - Academic Accents: `#1E3A8A` academic indigo (primary actions), `#D97706` warm amber (exam tips, highlights, streaks), `#059669` emerald mastery (correctness, progress, verification).
  - Optional **Calm Night Study** dark mode (`#0F141E` slate canvas, `#161E2E` surface) designed for eye comfort during evening revision.
  - Zero neon glassmorphism, zero raw emojis in interface controls (Lucide stroke icons only), and zero backend/infrastructure jargon in user-facing copy.
- **Hindi-First Bilingual Learning (`HI` | `EN` | `BOTH`):**
  - Default language is **Hindi (`HI`)** with one-tap switching to English (`EN`) or Dual (`BOTH`) across navigation, notes, interactive labs, practice questions, diagrams, lesson plans, and exams.
  - Typography pairs **Noto Sans Devanagari** (generous `1.8` line-height so matras never clip) with **Plus Jakarta Sans** and **KaTeX** mathematical typesetting.
  - **Hindi Pronunciation Vocabulary Cards (`pronunciation_hi`):** Bilingual glossary terms, flashcards, and English sentence-builder cards include Devanagari pronunciation guidance (e.g., *अम्ब्रेला*, *पार्लियामेंट*) paired with **Web Speech API Read-Aloud (`hi-IN` / `en-IN`)** to empower first-generation English learners in rural Bihar schools.
  - 3-dropdown Date of Birth picker (`Day / Month / Year`) for effortless sign-in on budget Android phones and shared school ICT lab PCs.

---

## 2. Multi-Tenant & Role Architecture

Four strictly isolated roles operate on top of a single multi-tenant PostgreSQL database (Supabase):

| Role | Primary Login Method | Scope | Key Capabilities |
| :--- | :--- | :--- | :--- |
| **Student (Class 9–12)** | School + Class + Roll No + DOB (3 dropdowns) or 15-digit e-Shikshakosh Student Code + optional 4-digit PIN | Single active school (`school_udise`) & own class/subjects + Universal Skill Labs | Visual bilingual Chapter Notes, Mindmaps, Hindi Pronunciation Cards & Read-Aloud, 4 Interactive Play-Labs (`SENTENCE_BUILDER`, `SHORTCUT_STUDIO`, `EXCEL_SANDBOX`, `SCENARIO_LAB`), 4-Stage Guided Mastery (`25% -> 50% -> 75% -> 100%`), Guided Foundation→Board→Topper Objective Ladder, BSEB 50% OMR Simulator, 2M/5M Model Answers, Live PIN & Scheduled Exams, Open Class+Subject Doubt Board, Mistake Vault & Concrete Progress |
| **Teacher** | Teacher ID (8-digit or 13-digit e-Shikshakosh ID) + Password (first-time activation via last-4 mobile verification) | Single active posted school (`school_teachers` partial unique active constraint) | Teacher-only BSEB & Skill Lab Lesson Plans (31 ready plans with period-wise flow, blackboard notes, misconceptions, activities & tiered homework + PDF print), School Material Publishing (Notes/PDF/Image/Video/YouTube), Open Doubt Answering & Moderation, Live PIN & Scheduled Exam Hosting with Projector Monitor, Marksheet `.xlsx` Export, Editorial Question Contribution |
| **School Admin** | Teacher credentials with `is_school_admin = true` | Own school (`school_udise`) | Student & Teacher e-Shikshakosh Excel Dry-Run Diff & Sync, Staff Subject & Class Mapping (auto-deriving `assigned_classes` from `assigned_subject_ids`), Activation & Password Reset Codes, School Academic Year Promotion, Audit Logs |
| **Super Admin** | Email + Password + TOTP 2FA (recovery via CLI script only) | Platform-wide (hidden private route) | Multi-school Onboarding, Global BSEB Curriculum & Gold Notes Editorial Desk, Private Question Submission Review & Structuring Pipeline, Storage Health Monitor |

### Zero Private Messaging Guarantee
- The database schema and API layer intentionally contain **zero** direct-message / 1-to-1 chat tables between students or between teachers and students.
- All doubt resolution happens exclusively on transparent, school-scoped, class-and-subject **Open Doubt Boards** (`open_doubts`, `doubt_answers`), where only verified teachers post official answers.

---

## 3. Universal Skill Labs, Syllabus Aliasing & 4-Stage Guided Mastery (v2.5)

### 3.1 Universal Skill/Foundation Subjects (`class_num = 0`) & `syllabus_alias_of`
- **`subjects.class_num` (`CHECK (class_num IN (0, 9, 10, 11, 12))`):**
  - `class_num = 0` designates platform-wide **Universal Skill & Foundation Labs** automatically unlocked for every Class 9–12 student and visible to every teacher:
    1. `skill-ict-lab` — **ICT & Digital Skills Lab** (*कंप्यूटर एवं डिजिटल कौशल लैब*): 6 interactive chapters covering Hardware/OS, MS Word & Formatting, MS Excel Formulas & Tables, Internet & Cyber Safety, Digital India/e-Services, and AI Prompting Basics.
    2. `skill-eng-foundation` — **English Foundation & Grammar Lab** (*अंग्रेज़ी नींव एवं व्याकरण लैब*): 5 zero-to-board units covering Phonics & Daily Vocabulary, Parts of Speech & Core Sentence Patterns, Tenses & Active-Passive Voice, Reading Comprehension, and Board Letters/Essays/Precis.
- **Canonical Syllabus Aliasing (`subjects.syllabus_alias_of`):**
  - Eliminates content duplication across overlapping BSEB subject codes by pointing alias rows to one canonical content subject:
    - `bseb-9-skill-ict`, `bseb-10-skill-ict`, `bseb-11-sci-add-cs`, `bseb-11-arts-add-cs`, `bseb-11-com-add-cs`, `bseb-12-sci-add-cs`, `bseb-12-arts-add-cs`, `bseb-12-com-add-cs` → `skill-ict-lab`
    - `bseb-11-lang2-eng` → `bseb-11-lang1-eng`
    - `bseb-12-lang2-eng` → `bseb-12-lang1-eng`
  - Student access helpers (`getStudentAccessibleSubjectIds`), teacher lesson plan listings (deduplicated per canonical `contentId` preferring the canonical row), exam builder/join flows, question bank lookups, study materials, and open doubts resolve canonical aliases automatically.
- **Zero-Downtime Schema Compatibility (`src/lib/supabase/schema-compat.ts`):**
  - All subject alias queries and 4-stage chapter progress upserts detect PostgreSQL `42703` (`undefined_column`) and PostgREST `PGRST204` errors and fall back cleanly to legacy columns so live production never experiences HTTP 500 outages during the window between Vercel deploys and Supabase SQL migration runs.

### 3.2 Four Tactile Interactive Play-Labs
Stored in `questions` (`question_type` + typed `visual_asset_json`) and graded strictly server-side in `POST /api/practice/submit`:

| Question Type | Pedagogical Purpose | Interactive Mechanics & Grading |
| :--- | :--- | :--- |
| **`SENTENCE_BUILDER`** | Zero-to-Board English syntax, tenses, voice & translation | Tap word tokens (with distractors & grammar formula hints) into correct English sentence order; normalized server-side verification + Devanagari pronunciation cues |
| **`SHORTCUT_STUDIO`** | Practical Windows, MS Word & MS Excel fluency for school ICT Labs | Interactive virtual keyboard + live document before/after preview; order-independent normalized key-combo grading (`Ctrl`/`Alt`/`Shift`/key) |
| **`EXCEL_SANDBOX`** | Real spreadsheet formula mastery (`SUM`, `AVERAGE`, `MAX`, `MIN`, `COUNT`, `IF`) | Interactive mini spreadsheet grid with highlighted target cell, formula chips, and deterministic safe formula evaluator (`src/lib/labs/excel-evaluator.ts`) |
| **`SCENARIO_LAB`** | Applied decision-making across 6 visual variants (`RIBBON_DETECTIVE`, `CYBER_SAFETY`, `PICTURE_GRAMMAR`, `EMAIL_COMPOSER`, `PROMPT_BUILDER`, `WRITING_TEMPLATE`) | Scene-based bilingual prompts with optional declarative SVG/comparison diagrams and server-verified choice grading |

*(Alongside existing visual practice modes: `FLASHCARD`, `MATCH_PAIRS`, `DIAGRAM_LABEL`, `MCQ`, `SHORT_2M`, and `LONG_5M` — 10 total question types.)*

### 3.3 4-Stage Guided Mastery Progress (`25% -> 50% -> 75% -> 100%`)
Computed consistently on server and client via `src/lib/progress/four-stage.ts` and persisted in `student_chapter_progress` (`notes_completed`, `notes_progress_pct`, `play_completed`, `practice_attempted`, `practice_correct`, `subjective_completed`, `mastery_pct`):

1. **Stage 1 — Understand (`0–25%`):** Complete the chapter's Visual Notes (`notes_completed = true`).
2. **Stage 2 — Play Lab (`+25%` → `50%`):** Successfully solve at least one interactive Play-Lab (`SENTENCE_BUILDER`, `SHORTCUT_STUDIO`, `EXCEL_SANDBOX`, `SCENARIO_LAB`, `FLASHCARD`, `MATCH_PAIRS`, or `DIAGRAM_LABEL`), setting `play_completed = true`.
3. **Stage 3 — Guided Quiz (`+25%` → `75%`):** Objective MCQ Ladder with **Guided Tier Unlocking (`FOUNDATION` → `BOARD` → `TOPPER`)** — mastering `FOUNDATION` unlocks `BOARD` questions and mastering `BOARD` unlocks `TOPPER` challenges (`>= 60%` MCQ accuracy completes Stage 3; strictly tracks MCQ accuracy so play labs never falsely inflate quiz mastery).
4. **Stage 4 — Board / Viva Mastery (`+25%` → `100%`):** Complete `SHORT_2M`/`LONG_5M` self-check coach (`subjective_completed = true`), or achieve `play_completed && quizMastery >= 80%` on skill chapters without subjective items.

Medals are awarded transparently (`BRONZE >= 30%`, `SILVER >= 60%`, `GOLD >= 85%`) alongside genuine learning metrics ("मेरी वास्तविक प्रगति": Chapters Mastered, Play Labs Completed, Words & Concepts Learned, Questions Mastered).

---

## 4. Data Privacy, Security & Shared ICT Lab Hardening

1. **Zero Sensitive Government PII Stored:**
   - Bihar e-Shikshakosh Student Excel exports contain `Aadhaar No` and `Social Category`. The parser **discards both columns immediately in memory** — they are never written to PostgreSQL, logs, or API responses.
   - Teacher mobile numbers are never persisted in plaintext; only a salted/keyed hash (`mobile_hash`) and `mobile_last4` are stored for first-time activation verification.
   - `.gitignore` strictly blocks `design/*.xlsx`, `design/*.xls`, `design/*.csv`, `design/._*`, and `.env*` from version control.
2. **Opaque DB-Backed Sessions & ICT Lab Tab Sync:**
   - Sessions use 256-bit cryptographically random tokens stored as SHA-256 hashes in `user_sessions`, delivered via `HttpOnly; SameSite=Strict; Path=/` cookies (`__Host-sob_session` in HTTPS production).
   - Protected routes return `Cache-Control: no-store, no-cache, must-revalidate` to prevent browser `bfcache` leakage on shared 40-PC school ICT Labs.
   - `SessionSyncListener` (`BroadcastChannel('sob-auth')` + `storage` fallback) instantaneously wipes `sessionStorage` and user drafts across all open tabs and redirects to `/login/student` upon logout or student switch.
3. **ICT-Lab-NAT-Safe Defense-in-Depth:**
   - Two-tier rate limiting in PostgreSQL (`auth_rate_limits`): tight per-account throttling paired with a high per-IP soft-challenge threshold (Cloudflare Turnstile) so a shared school router NAT IP is never hard-banned.
   - Strict CSRF `Origin` validation on all state-changing mutations and strict CSP/security headers via `next.config.ts` and `vercel.json`.
   - Formula-injection neutralization on all exported marksheet `.xlsx` files; ZIP-bomb bounds verification before parsing uploaded spreadsheets; strict XSS HTML sanitization + safe KaTeX rendering (`MathMarkdown`) and declarative SVG allowlist validation.
4. **PostgreSQL Row-Level Security (RLS):**
   - Public `anon` table access is denied by default across all 29 tables.
   - Server API routes access PostgreSQL through a server-only `service_role` client.
   - Real-time exam monitoring publishes **only** `live_exam_roster` (summary counts/status — never `exam_attempts.answers_json`) using short-lived HS256 JWTs scoped strictly to `{ school_udise, exam_id }`.

---

## 5. Storage, Editorial Pipeline & Complete Migration Chain (`001`–`007`)

### 5.1 Private 5 TB Media Vault (Google One OAuth2)
- Server-side OAuth2 refresh flow caches AES-256-GCM encrypted access tokens in `system_oauth_tokens` with PostgreSQL advisory locking (`acquire_oauth_refresh_lease` / `release_oauth_refresh_lease`, PgBouncer-safe) to prevent concurrent refresh stampedes.
- Uploads use single-use direct resumable upload URIs (OAuth tokens never reach the browser) followed by server-side size and magic-byte verification (PDF `%PDF`, PNG/JPEG/WEBP, OOXML `PK`, MP4 `ftyp`), automatically deleting invalid uploads.
- Media downloads use split delivery routes with HTTP `Range` streaming for >4.5 MB files on Vercel serverless: `/api/public-assets/[id]` for published global curriculum assets (cacheable) and `/api/school-media/[id]` for authenticated school-private materials and doubts (`Cache-Control: private, no-store`).
- Daily Vercel Cron (`/api/cron/media-gc`, 02:30 IST) cleans abandoned `PENDING` and `DELETE_QUEUED` media objects.

### 5.2 Complete Idempotent Migration Chain (`001`–`007`)
All migrations live under `supabase/migrations/` and are packaged into two convenience runners:
- **`supabase/ALL_MIGRATIONS_COMBINED.sql`** — Fresh full setup (`001`–`007` + verification query).
- **`supabase/SPRINT_ICT_ENGLISH_UPGRADE.sql`** — Incremental upgrade for databases already running `001`–`003` (`004`–`007` + verification query).

| Migration | Contents & Seeded Totals |
| :--- | :--- |
| **`001_v2_multitenant_schema.sql`** | 29 multi-tenant tables, default-deny RLS, triggers, PgBouncer-safe OAuth lease RPCs, `live_exam_roster` Realtime publication, `pg_trgm` duplicate-check indexes |
| **`002_bseb_seed_catalog.sql`** | Official BSEB catalog: 102 Class 9–12 subjects (Secondary + Arts/Science/Commerce streams) + 77 syllabus chapters |
| **`003_gold_curriculum_seed.sql`** | 6 flagship Gold Visual Chapters (Math, Science, Physics, Chemistry, Social Science, Biology), 6 Teacher Lesson Plans, 46 multi-mode questions |
| **`004_interactive_labs_and_universal_skills.sql`** | Relaxes `subjects.class_num` for `0`, adds `subjects.syllabus_alias_of`, seeds `skill-ict-lab` & `skill-eng-foundation`, aliases BSEB ICT/CS (Class 9–12) & Lang-2 English (Class 11–12), expands `questions.question_type` & `practice_sessions.mode` for the 4 Interactive Labs, adds `play_completed` & `subjective_completed` on `student_chapter_progress` |
| **`005_seed_ict_curriculum.sql`** | 6 ICT & Digital Skills Lab chapters (`skill-ict-lab`), 6 Gold Visual Notes, 6 Teacher Lesson Plans, 130 questions (incl. `SHORTCUT_STUDIO`, `EXCEL_SANDBOX`, `SCENARIO_LAB`) |
| **`006_seed_english_foundation.sql`** | 5 English Zero-to-Board Foundation units (`skill-eng-foundation`), 5 Gold Visual Notes with Hindi pronunciation cards, 5 Teacher Lesson Plans, 134 questions (incl. `SENTENCE_BUILDER`, `SCENARIO_LAB`) |
| **`007_seed_english_textbooks.sql`** | 14 BSEB Panorama (Class 9–10) & Rainbow (Class 11–12) textbook chapters, 14 Gold Visual Notes, 14 Teacher Lesson Plans, 196 questions |

**Cumulative Verified Curriculum Totals (after `001`–`007`):**
- **104 Subjects** (102 official BSEB Class 9–12 subjects + 2 Universal Skill Labs)
- **100 Published Chapters** (incl. **31 Gold Visual Chapters** with bilingual mindmaps, analogies, diagrams & board capsules)
- **31 Official Teacher Lesson Plans** (period-wise teaching steps, blackboard summaries, misconceptions, classroom activities & tiered homework)
- **506 Multi-Mode Questions** (`437 PRACTICE` + `69 EXAM_ONLY` across 10 types: 243 MCQ, 65 Flashcard, 53 Sentence Builder, 38 Match Pairs, 34 Short 2M, 32 Long 5M, 22 Scenario Lab, 9 Shortcut Studio, 6 Excel Sandbox, 4 Diagram Label)
- Separate `PRACTICE` and `EXAM_ONLY` question pools ensure exam fairness, while `exams.questions_snapshot` freezes active assessments immutably and all streak/leaderboard/exam timings use `Asia/Kolkata` (IST).
