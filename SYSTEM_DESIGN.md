# Students of Bihar (Class 9–12) — System Design (v2.4 Clean-Slate Architecture)

> **Philosophy:** Quality over quantity. Warm, distraction-free editorial academic design tailored for Bihar Board (BSEB) government school students, teachers, and school administrators — starting with **Uchch Madhyamik Vidyalaya, Kaparpura (Kanti, Muzaffarpur)** as School #1 and architected cleanly for statewide multi-tenant onboarding.

---

## 1. Product Principles & Design Language

- **Warm Editorial Paper-First Aesthetic:** Inspired by Apple Education, Khan Academy, Notion, and Brilliant.org.
  - Light Canvas: `#FAFAF9` warm ivory paper, `#FFFFFF` crisp cards, `#E5E7EB` hairlines, `#0F172A` slate ink.
  - Academic Accents: `#1E3A8A` academic indigo (primary actions), `#D97706` warm amber (exam tips, highlights, streaks), `#059669` emerald mastery (correctness, progress, verification).
  - Optional **Calm Night Study** dark mode (`#0F141E` slate canvas, `#161E2E` surface) designed for eye comfort during evening revision.
  - Zero neon glassmorphism, zero raw emojis in interface controls (Lucide stroke icons only), and zero backend/infrastructure jargon in user-facing copy.
- **Hindi-First Bilingual Learning (`HI` | `EN` | `BOTH`):**
  - Default language is **Hindi (`HI`)** with one-tap switching to English (`EN`) or Dual (`BOTH`) across navigation, notes, practice questions, diagrams, and exams.
  - Typography pairs **Noto Sans Devanagari** (generous `1.8` line-height so matras never clip) with **Plus Jakarta Sans** and **KaTeX** mathematical typesetting.
  - Built-in **Web Speech API Read-Aloud (`hi-IN` / `en-IN`)** and 3-dropdown Date of Birth picker (`Day / Month / Year`) for weak readers and budget Android phones.

---

## 2. Multi-Tenant & Role Architecture

Four strictly isolated roles operate on top of a single multi-tenant PostgreSQL database (Supabase):

| Role | Primary Login Method | Scope | Key Capabilities |
| :--- | :--- | :--- | :--- |
| **Student (Class 9–12)** | School + Class + Roll No + DOB (3 dropdowns) or 15-digit e-Shikshakosh Student Code + optional 4-digit PIN | Single active school (`school_udise`) & own class/subjects | Visual bilingual Chapter Notes, Mindmaps, Read-Aloud, One-Stop Practice Studio (Flashcards, Match Pairs, Diagram Labels, MCQs, 2M/5M), Live PIN & Scheduled Exams, Open Class+Subject Doubt Board, Revision Queue & Progress |
| **Teacher** | Teacher ID (8-digit or 13-digit e-Shikshakosh ID) + Password (first-time activation via last-4 mobile verification) | Single active posted school (`school_teachers` partial unique active constraint) | Teacher-only Lesson Plans, School Material Publishing (Notes/PDF/Image/Video/YouTube), Open Doubt Answering & Moderation, Live PIN & Scheduled Exam Hosting with Projector Monitor, Marksheet `.xlsx` Export, Editorial Question Contribution |
| **School Admin** | Teacher credentials with `is_school_admin = true` | Own school (`school_udise`) | Student & Teacher e-Shikshakosh Excel Dry-Run Diff & Sync, Staff Activation & Password Reset Codes, School Academic Year Promotion, Audit Logs |
| **Super Admin** | Email + Password + TOTP 2FA (recovery via CLI script only) | Platform-wide (hidden private route) | Multi-school Onboarding, Global BSEB Curriculum & Gold Notes Editorial Desk, Private Question Submission Review & Structuring Pipeline, Storage Health Monitor |

### Zero Private Messaging Guarantee
- The database schema and API layer intentionally contain **zero** direct-message / 1-to-1 chat tables between students or between teachers and students.
- All doubt resolution happens exclusively on transparent, school-scoped, class-and-subject **Open Doubt Boards** (`open_doubts`, `doubt_answers`), where only verified teachers post official answers.

---

## 3. Data Privacy, Security & Shared ICT Lab Hardening

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
   - Public `anon` table access is denied by default across all tables.
   - Server API routes access PostgreSQL through a server-only `service_role` client.
   - Real-time exam monitoring publishes **only** `live_exam_roster` (summary counts/status — never `exam_attempts.answers_json`) using short-lived HS256 JWTs scoped strictly to `{ school_udise, exam_id }`.

---

## 4. Storage, Curriculum & Editorial Pipeline

- **Private 5 TB Media Vault (Google One OAuth2):**
  - Server-side OAuth2 refresh flow caches AES-256-GCM encrypted access tokens in `system_oauth_tokens` with PostgreSQL advisory locking (`pg_try_advisory_lock`) to prevent concurrent refresh stampedes.
  - Uploads use single-use direct resumable upload URIs (OAuth tokens never reach the browser) followed by server-side size and magic-byte verification (PDF `%PDF`, PNG/JPEG/WEBP, OOXML `PK`, MP4 `ftyp`), automatically deleting invalid uploads.
  - Media downloads use split delivery routes with HTTP `Range` streaming for >4.5 MB files on Vercel serverless: `/api/public-assets/[id]` for published global curriculum assets (cacheable) and `/api/school-media/[id]` for authenticated school-private materials and doubts (enforcing `Cache-Control: private, no-store`).
  - Daily Vercel Cron (`/api/cron/media-gc`, 02:30 IST) cleans abandoned `PENDING` and `DELETE_QUEUED` media objects.
- **Official BSEB Curriculum & Gold Study Engine:**
  - Supports complete Bihar Board Class 9–10 (Mandatory + MIL + SIL mutual-exclusion rules + ICT) and Class 11–12 (`Arts` / `Science` / `Commerce` Streams + Language 1 & 2 + 3 Core Electives + optional Additional Subject).
  - Separate `PRACTICE` and `EXAM_ONLY` question pools prevent students from seeing teacher exam questions during self-study, while `exams.questions_snapshot` freezes active exams immutably.
  - All streak, weekly leaderboard, and exam window calculations use `Asia/Kolkata` (IST).
