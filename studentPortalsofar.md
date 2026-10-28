# 📊 U.H.S. Kaparpura — Student Portal Progress Tracker (`studentPortalsofar.md`)

> **Last Updated**: 2026-10-28 (Migrated to Standalone Repo + Supabase PostgreSQL & Realtime)
> **Repository**: `F:\School Web\uhskaparpura-student-portal` (`https://github.com/EternalStud/uhskaparpura-student-portal.git`)
> **Isolation Status**:
> - `uhskaparpurakanti-website` reverted cleanly to `ac0a30f` (0 portal files mixed in).
> - `uhskaparpura-admin-api` reverted cleanly to `298e5dc` & Clasp `@149` (0 portal files mixed in).

---

## ✅ Completed Milestones

### 1. Complete Isolation into Separate Repository (`uhskaparpura-student-portal`)
- Removed all Student Portal files from `uhskaparpurakanti-website` and `uhskaparpura-admin-api` so the live registration/admission/result repositories remain 100% untouched.
- Created a dedicated Git repository at `F:\School Web\uhskaparpura-student-portal`.

### 2. Full Supabase PostgreSQL + Realtime Migration
- **[`supabase/schema.sql`](./supabase/schema.sql)**:
  - Creates `public.portal_students` (with indexes on `student_code`, `(class_name, roll_no)`, `total_xp DESC`, `ict_xp DESC`, `weekly_xp DESC`).
  - Creates `public.portal_live_exams` and `public.portal_live_participants` with `ON DELETE CASCADE`.
  - Enables Row Level Security (RLS) policies and adds `portal_live_exams` + `portal_live_participants` to `supabase_realtime` publication for instant WebSocket updates.
  - Seeds verified sample student (`202410141306317` — Ankit Kumar, Class 11 Arts, Roll 2).
- **[`supabase-client.js`](./supabase-client.js)**:
  - **Hybrid Zero-Maintenance Login**: Queries `portal_students` in Supabase PostgreSQL first; if a student logs in for the very first time and isn't in Supabase yet, verifies them in read-only mode against `SchoolDB` (`public.registration.getStudent`) and automatically `UPSERT`s their profile + enrolled subjects into Supabase PostgreSQL.
  - **Direct PostgreSQL XP, Streak, Mistake Bank & Badge Sync**: Updates `portal_students` in milliseconds, including +50% Co-Learner Buddy XP for shared ICT Lab PCs.
  - **Real-Time 3-Tier Leaderboards**: Queries Class/Stream Toppers, ICT Lab Champions, and Weekly Rising Stars directly from Supabase PostgreSQL.
  - **Supabase Realtime WebSocket Live Exams**: Subscribes to `postgres_changes` on `portal_live_participants` and `portal_live_exams` so the teacher's projector screen updates live as students join, answer, or switch tabs.
  - **Bulk `SchoolDB.csv` Importer**: Built into `teacher-host.html` for 1-click bulk upsert of 500–5,000 students into Supabase PostgreSQL.

### 3. Student Portal (`index.html`, `portal.js`, `portal.css`, `data/curriculum.js`)
- Dual login (`Student Code` OR `Class + Stream + Roll No + DOB`) + optional 4-digit PIN + 1-click "Switch Student" button.
- 3-Way Language Switcher (`हिन्दी` | `English` | `Both द्विभाषी`).
- 5 Game & Simulator Modes:
  1. Bilingual Flashcards
  2. KBC Speed Quiz (50:50 & Hint lifelines + anti-farming XP)
  3. Shortcut Ninja (Physical Keyboard + Virtual Keys)
  4. MS Excel Formula Sandbox (`=SUM`, `=AVERAGE`, `=MAX`, `=COUNT`)
  5. BSEB Pink OMR Sheet Simulator
- Personal Mistake Notebook (`गलती सुधार बैंक`) & Printable A4 Certificate.
