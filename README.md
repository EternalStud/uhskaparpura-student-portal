# Students of Bihar (Class 9–12)

A bilingual (Hindi-first, English, and Dual mode) academic learning, interactive skills lab, visual study-notes, live examination, and multi-tenant school management platform built for **Bihar School Examination Board (BSEB)** Class 9–12 students, teachers, and government schools — live in production with **Uchch Madhyamik Vidyalaya, Kaparpura (Kanti, Muzaffarpur)** as School #1.

- **Live Production URL:** `https://students.uhskaparpurakanti.in`
- **Architecture & Security Design:** [SYSTEM_DESIGN.md](./SYSTEM_DESIGN.md)

---

## Curriculum & Platform Scale (v2.5)

| Asset | Verified Count | Highlights |
| :--- | :---: | :--- |
| **Subjects** | **104** | 102 official BSEB Class 9–12 subjects (Secondary + Arts / Science / Commerce) + **2 Universal Skill Labs** (`skill-ict-lab`, `skill-eng-foundation`) |
| **Published Chapters** | **100** | Official BSEB syllabus chapters + ICT & Digital Skills Lab (6) + English Foundation (5) + Panorama/Rainbow English Textbooks (14) |
| **Gold Visual Chapters** | **31** | Bilingual mindmaps, analogies, declarative SVG diagrams, KaTeX formulas, Hindi pronunciation cards & Web Speech Read-Aloud |
| **Teacher Lesson Plans** | **31** | Period-wise teaching flow, blackboard summaries, common student misconceptions, classroom demonstrations & print-ready tiered homework |
| **Question Bank** | **506** | **437 Practice** + **69 Exam-Only** across 10 modes (`MCQ`, `FLASHCARD`, `SENTENCE_BUILDER`, `MATCH_PAIRS`, `SHORT_2M`, `LONG_5M`, `SCENARIO_LAB`, `SHORTCUT_STUDIO`, `EXCEL_SANDBOX`, `DIAGRAM_LABEL`) |

---

## Highlights

- **Built for Bihar Board (BSEB) Class 9–12:** Official subject rules for Class 9–10 (Mandatory + MIL + SIL + ICT) and Class 11–12 (Arts, Science, Commerce streams), canonical syllabus aliasing (`syllabus_alias_of`) across ICT/CS and Lang-1/Lang-2 English, chapter weightage, and BSEB 50% OMR Board Simulator.
- **Universal ICT & English Foundation Labs (`class_num = 0`):** Automatically unlocked for every Class 9–12 student and teacher across all streams — zero-to-board English grammar with Devanagari pronunciation cues and practical Windows/Word/Excel/Cyber-Safety ICT labs.
- **4 Interactive Play-Labs & 4-Stage Guided Mastery:** Hands-on `SENTENCE_BUILDER`, `SHORTCUT_STUDIO`, `EXCEL_SANDBOX`, and `SCENARIO_LAB` exercises powering transparent **4-Stage Chapter Mastery (`25% -> 50% -> 75% -> 100%`)** and **Guided Foundation → Board → Topper** quiz tier unlocking.
- **Educator Studio & Official Lesson Plans:** Strictly teacher-gated Lesson Plans with canonical alias deduplication, print/PDF sheets, Classroom Study Materials (Notes/PDF/Image/Video/YouTube), Open Doubt Desk, and Editorial Question Paper Contributions.
- **Live PIN & Scheduled Classroom Exams:** Immutable exam snapshots (`EXAM_ONLY` + `PRACTICE` pools + custom MCQs), deterministic per-student question/option shuffling, classroom Projector Monitor via scoped Realtime, and formula-safe Excel marksheet export.
- **Zero-DM Open Doubt Boards & e-Shikshakosh Ready:** Strictly zero private messaging; privacy-first student & teacher roster sync (automatically discards Aadhaar and Social Category in memory; stores only hashed/last-4 teacher mobile digits).

---

## Tech Stack

- **Framework:** Next.js 15 (App Router), React 19, TypeScript (strict)
- **Styling & Typography:** Tailwind CSS v3.4, Plus Jakarta Sans, Noto Sans Devanagari, Lucide React icons, KaTeX
- **Database & Scoped Realtime:** Supabase PostgreSQL with strict default-deny RLS & zero-downtime schema-compatibility fallbacks
- **Media Vault:** Private Google Drive (5 TB Google One) via server-side OAuth2 resumable uploads & streaming proxy
- **Validation & Security:** Zod, bcryptjs, otplib (TOTP 2FA), Cloudflare Turnstile, `sanitize-html`

---

## Local Development & Database Migration Setup

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env.local
   ```
   Fill in all 15 required variables (Supabase keys, `openssl rand -hex 32` secrets, Cloudflare Turnstile, Google One OAuth2, Gemini API key, and `CRON_SECRET`) in `.env.local`. Never commit `.env.local`.

3. **Apply Supabase SQL migrations (`001`–`007`)**
   - **Automated CLI (Recommended):** use `node scripts/apply-migrations.mjs` (see subsection below).
   - **Fresh database (all 7 migrations + verification query):** paste and run [`supabase/ALL_MIGRATIONS_COMBINED.sql`](./supabase/ALL_MIGRATIONS_COMBINED.sql) in **Supabase → SQL Editor → New Query**.
   - **Existing database already on `001`–`003` (incremental Sprint 1–3 ICT & English upgrade):** paste and run [`supabase/SPRINT_ICT_ENGLISH_UPGRADE.sql`](./supabase/SPRINT_ICT_ENGLISH_UPGRADE.sql) in **Supabase → SQL Editor → New Query**.
   - **Individual migration files** (100% idempotent, in order):
     1. `supabase/migrations/001_v2_multitenant_schema.sql`
     2. `supabase/migrations/002_bseb_seed_catalog.sql`
     3. `supabase/migrations/003_gold_curriculum_seed.sql`
     4. `supabase/migrations/004_interactive_labs_and_universal_skills.sql`
     5. `supabase/migrations/005_seed_ict_curriculum.sql`
     6. `supabase/migrations/006_seed_english_foundation.sql`
     7. `supabase/migrations/007_seed_english_textbooks.sql`

4. **Verify live environment & database integrity**
   ```bash
   node scripts/preflight-check.mjs
   ```

5. **Start the development server**
   ```bash
   npm run dev
   ```
   Open [http://localhost:3000](http://localhost:3000).

### Automated CLI Migrations (`node scripts/apply-migrations.mjs`)

Apply `004`–`007` and all future `008`–`099` subject seeds directly from the terminal without manual SQL Editor copy-pasting (zero extra npm dependencies; tracks applied files in RLS-locked `public._applied_migrations` and prints live post-apply row counts):

1. Add a **strictly local CLI-only** credential to `.env.local` (**never** add to Vercel):
   - **Mode A (Preferred — HTTPS):** `SUPABASE_ACCESS_TOKEN=` from [Supabase Account Tokens](https://supabase.com/dashboard/account/tokens)
   - **Mode B (Fallback — Direct Postgres):** `SUPABASE_DB_URL=` (uses local `psql -v ON_ERROR_STOP=1 -f`)
2. Preview or apply migrations:
   ```bash
   # Preview which files would run without executing SQL
   node scripts/apply-migrations.mjs --dry-run --from 004

   # Apply 004–007 (and any future 008+ migrations not yet recorded)
   node scripts/apply-migrations.mjs --from 004

   # Apply one specific file, or force re-apply idempotent migrations
   node scripts/apply-migrations.mjs --file supabase/migrations/004_interactive_labs_and_universal_skills.sql
   node scripts/apply-migrations.mjs --from 004 --force
   ```

---

## App & CLI Scripts

### NPM Scripts

| Command | Purpose |
| :--- | :--- |
| `npm run dev` | Start Next.js development server |
| `npm run build` | Build production bundle |
| `npm run start` | Start production server |
| `npm run typecheck` | Run strict TypeScript checking (`tsc --noEmit`) |
| `npm run lint` | Run ESLint checks |

### Operational CLI Tools (`scripts/` — strictly local, never exposed over HTTP)

| Command | Purpose |
| :--- | :--- |
| `node scripts/apply-migrations.mjs [--from 004] [--file <path>] [--dry-run] [--force]` | Automated idempotent Supabase SQL migration runner (Mode A HTTPS Management API via `SUPABASE_ACCESS_TOKEN` or Mode B `psql` via `SUPABASE_DB_URL`), tracking runs in RLS-locked `public._applied_migrations` with live post-apply table counts |
| `node scripts/preflight-check.mjs` | Zero-secret preflight verifier for all 15 env vars, Supabase `001`–`007` schema & seed integrity (`syllabus_alias_of`, `play_completed`, 104 subjects, 100 chapters, 31 notes/plans, 506 questions), OAuth lease RPC, 5 TB Google One Drive Vault writability, and Gemini API reachability |
| `node scripts/super-admin-recovery.mjs <list\|bootstrap\|reset-password\|reset-totp>` | Bootstrap or recover Super Admin credentials & TOTP 2FA directly against Supabase via `service_role` |
| `node scripts/generate-google-oauth-token.mjs` | Generate a production Google One Drive OAuth2 refresh token and initialize the `StudentsOfBihar_Vault` root folder |

---

## Documentation & History

- Full system architecture, security invariants, interactive lab schemas, and migration guide: [SYSTEM_DESIGN.md](./SYSTEM_DESIGN.md)
- Previous legacy v1 static prototype is preserved in Git under tag `legacy-v1-archive`.
