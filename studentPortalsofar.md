# 📊 U.H.S. Kaparpura — Student Portal Progress Tracker (`studentPortalsofar.md`)

> **Last Updated**: 2026-10-28 (Connected to Live Supabase PostgreSQL & Synced to Standalone GitHub Repo)
> **GitHub Repository**: [`https://github.com/EternalStud/uhskaparpura-student-portal`](https://github.com/EternalStud/uhskaparpura-student-portal)
> **Local Workspace Path**: `F:\School Web\uhskaparpura-student-portal`
> **Supabase Project ID**: `lvrsanukztinwqrgivth` (`https://lvrsanukztinwqrgivth.supabase.co`)
> **Isolation Status**:
> - `uhskaparpurakanti-website` reverted cleanly to `ac0a30f` (0 portal files mixed in).
> - `uhskaparpura-admin-api` reverted cleanly to `298e5dc` & Clasp `@149` (0 portal files mixed in).

---

## ✅ Completed & Live-Verified Milestones

### 1. Standalone GitHub Repository (`uhskaparpura-student-portal`)
- Dedicated repository initialized, committed, and pushed to `origin/main` at `https://github.com/EternalStud/uhskaparpura-student-portal.git`.
- Can be hosted directly via **GitHub Pages** (*Settings → Pages → Deploy from branch `main` / `/ (root)`*) or opened locally.

### 2. Live Supabase PostgreSQL + Realtime Backend (`lvrsanukztinwqrgivth`)
- **[`supabase/schema.sql`](./supabase/schema.sql)** executed and verified on live Supabase PostgreSQL:
  - `public.portal_students`: Stores student profiles, enrolled subjects, optional 4-digit PIN hashes, Total XP, Weekly XP, ICT Lab XP, Streaks, Mastered Questions JSONB, Mistake Bank JSONB, and Badges.
  - `public.portal_live_exams`: Stores Teacher On-Demand Live Exams (4-digit Room PIN, questions JSONB, duration, status).
  - `public.portal_live_participants`: Stores live student scores, progress, and anti-cheat tab-switch counters with **Supabase Realtime WebSocket** broadcast enabled.
- **[`config.js`](./config.js)**: Pre-configured with `https://lvrsanukztinwqrgivth.supabase.co` and the project `anon` key so students and teachers do not need to enter any database credentials manually.

### 3. Student Portal (`index.html`, `portal.js`, `portal.css`, `data/curriculum.js`)
- **Hybrid Zero-Maintenance Login**:
  - Primary lookup in Supabase PostgreSQL (`portal_students`) in <50ms.
  - Automatic read-only fallback to `SchoolDB` (`public.registration.getStudent`) for first-time student logins, followed by automatic `UPSERT` into Supabase PostgreSQL.
  - Supports **Student Code** (`202410141306317`) OR **Class + Stream + Roll No + DOB** (`Class 11, Arts, Roll 2, DOB 2011-01-01`).
- **5 Interactive Learning & Simulator Modes**:
  1. Bilingual Flashcards (`हिन्दी` | `English` | `Both द्विभाषी`)
  2. KBC Speed Quiz (50:50 & Hint lifelines + anti-farming XP)
  3. Shortcut Ninja (Physical Keyboard + Virtual Keys for MS Word & Excel)
  4. Mini Excel Formula Sandbox (`=SUM`, `=AVERAGE`, `=MAX`, `=COUNT`)
  5. BSEB 50% Objective Pink OMR Sheet Simulator
- **Personal Mistake Notebook (`गलती सुधार बैंक`)**, **3-Tier PostgreSQL Leaderboard**, and **Printable A4 Certificate**.

### 4. Teacher Live Exam Host (`teacher-host.html`)
- Instant 4-digit Room PIN generation for live classroom evaluations.
- Real-time student progress, score, and tab-switch (`visibilitychange`) anti-cheat monitor via **Supabase Realtime WebSockets**.
- 1-Click CSV/Excel export of live exam results.
- 1-Click Student Security PIN Reset & Bulk `SchoolDB.csv` to Supabase PostgreSQL Importer.

---

## 🔄 How to Continue Between School & Home

```powershell
# 1. At Home (First time only): Clone the standalone repository
git clone https://github.com/EternalStud/uhskaparpura-student-portal.git

# 2. Before starting work at School or Home:
cd uhskaparpura-student-portal
git pull origin main

# 3. After making changes:
git add .
git commit -m "Update student portal"
git push origin main
```
