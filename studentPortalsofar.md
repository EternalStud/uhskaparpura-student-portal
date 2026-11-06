# 📊 U.H.S. Kaparpura — Student Portal Progress & Cross-Device Continuity (`studentPortalsofar.md`)

> **Last Updated**: 2026-10-28
> **Purpose**: Single source of truth for seamless development across **School Windows PC** and **Home Mac Mini (macOS)**. Any developer or AI coding agent reading this file + [`studentportal.md`](./studentportal.md) has 100% context to continue immediately.

---

## 🍎 Quick-Start on Your Mac Mini (macOS Terminal)

### 1. First-Time Setup on Mac Mini
Open **Terminal** on your Mac Mini and run:

```bash
# Create a workspace folder on your Mac Mini
mkdir -p ~/Projects/SchoolWeb
cd ~/Projects/SchoolWeb

# Clone the standalone Student Portal repository
git clone https://github.com/EternalStud/uhskaparpura-student-portal.git

# (Optional) Clone the other 3 school repositories if needed on Mac Mini:
git clone https://github.com/EternalStud/uhskaparpurakanti-website.git
git clone https://github.com/EternalStud/uhskaparpura-admin-web.git
git clone https://github.com/EternalStud/uhskaparpura-admin-api.git

# Launch local web server on Mac Mini (macOS comes with python3 pre-installed)
cd ~/Projects/SchoolWeb/uhskaparpura-student-portal
python3 -m http.server 8080
```
Then open in Safari / Chrome on your Mac Mini:
- **Student Portal**: `http://localhost:8080/index.html`
- **Teacher Live Exam Host**: `http://localhost:8080/teacher-host.html`

### 2. Daily Sync Routine (School Windows PC ↔ Home Mac Mini)
- **Before starting work (on Mac Mini or School PC)**:
  ```bash
  git pull origin main
  ```
- **Before leaving (on Mac Mini or School PC)**:
  ```bash
  git add .
  git commit -m "Describe what you built or updated"
  git push origin main
  ```
- **Line Endings Note (Windows CRLF vs macOS LF)**:
  On Mac Mini, run `git config --global core.autocrlf input` once so Git handles Windows/macOS line endings cleanly without diff noise.

---

## 🗺️ Complete U.H.S. Kaparpura Ecosystem Map

| # | Repository | GitHub URL | Tech Stack & Live Backend | Current Status |
|---|---|---|---|---|
| **1** | **`uhskaparpura-student-portal`** *(This Repo)* | [`EternalStud/uhskaparpura-student-portal`](https://github.com/EternalStud/uhskaparpura-student-portal) | Vanilla SPA + **Supabase PostgreSQL & Realtime** (`lvrsanukztinwqrgivth`) + Read-only `SchoolDB` fallback | **Phase 1 Live & Verified** |
| **2** | **`uhskaparpurakanti-website`** | [`EternalStud/uhskaparpurakanti-website`](https://github.com/EternalStud/uhskaparpurakanti-website) | Public School Website (`uhskaparpurakanti.in`) — Admission, Registration, Results | Clean (`ac0a30f`) — Untouched by Portal |
| **3** | **`uhskaparpura-admin-web`** | [`EternalStud/uhskaparpura-admin-web`](https://github.com/EternalStud/uhskaparpura-admin-web) | Admin & Teacher Marks Entry Portal | Clean (`0bc40b4`) — Untouched by Portal |
| **4** | **`uhskaparpura-admin-api`** | [`EternalStud/uhskaparpura-admin-api`](https://github.com/EternalStud/uhskaparpura-admin-api) | Google Apps Script API (Clasp `@149`, Deployment `AKfycbwQtEdZ-Y-NIgFFoWCmqQap-hCdfHk6lTFjSqswH-bOS75MkPr4PFz31S-TuFea9KE`) | Clean (`298e5dc`) — Untouched by Portal |

---

## 🔑 Live Credentials & Endpoints Reference

### 1. Supabase PostgreSQL Database (`uhskaparpura-student-portal`)
- **Project ID**: `lvrsanukztinwqrgivth`
- **Project URL**: `https://lvrsanukztinwqrgivth.supabase.co`
- **Anon Public Key** (Configured in [`config.js`](./config.js)):
  ```text
  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2cnNhbnVrenRpbndxcmdpdnRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxODAzODUsImV4cCI6MjEwODc1NjM4NX0.PwB8t5kqdla0oHsAcR2ptZO3g4Ajw78QJOBNUnNQzzw
  ```
- **Tables Created & Active (via [`supabase/schema.sql`](./supabase/schema.sql))**:
  1. `public.portal_students` — Stores student identity, enrolled BSEB subjects, optional 4-digit PIN SHA-256 hash, `total_xp`, `weekly_xp`, `ict_xp`, `streak`, `mastered_map` (JSONB), `mistake_bank` (JSONB), and `badges` (JSONB).
  2. `public.portal_live_exams` — Stores Teacher On-Demand Live Exam sessions (`pin`, `exam_id`, `title`, `chapter_id`, `class_name`, `duration_mins`, `questions` JSONB, `status`).
  3. `public.portal_live_participants` — Stores live student progress, score, accuracy, and `tab_switches` anti-cheat counter, published to `supabase_realtime`.

### 2. Read-Only `SchoolDB` Verification Bridge
- **URL**: `https://script.google.com/macros/s/AKfycbwQtEdZ-Y-NIgFFoWCmqQap-hCdfHk6lTFjSqswH-bOS75MkPr4PFz31S-TuFea9KE/exec`
- **How Hybrid Login Works ([`supabase-client.js`](./supabase-client.js))**:
  1. When a student logs in via **Student Code** OR **Class + Stream + Roll No + DOB**, `PortalDB.loginStudent()` queries `public.portal_students` in Supabase PostgreSQL first (<50ms response).
  2. If the student is not yet in `public.portal_students` (first-time login), it automatically calls `?action=public.registration.getStudent` on the live `SchoolDB` API in read-only mode, verifies the student, resolves their default BSEB + ICT subjects, and `UPSERT`s their record into Supabase PostgreSQL `public.portal_students`.
- **Demo Test Student**:
  - **Student Code**: `DEMO_2026_001` (Class `11`, Stream `Arts`, Roll `1`, DOB `2011-01-01`).

---

## ✅ What Has Been Built in Phase 1 (File-by-File)

| File | Description & Implemented Features |
|---|---|
| [`index.html`](./index.html) | Standalone Student Portal SPA with Topbar status pill (`🟢 Supabase PostgreSQL Connected`), 3-way language switcher (`हिन्दी` \| `English` \| `Both द्विभाषी`), 1-click "Switch Student" button, Login view, and 5-tab Dashboard. |
| [`config.js`](./config.js) | Pre-configured with Supabase Project `lvrsanukztinwqrgivth` URL, Anon Key, and read-only `SchoolDB` API URL. |
| [`supabase-client.js`](./supabase-client.js) | Complete `window.PortalDB` service layer using `@supabase/supabase-js@2`: `loginStudent`, `syncProgress`, `getLeaderboards`, `createLiveExam`, `joinLiveExam`, `updateLiveParticipant`, `getLiveExamStatus`, `endLiveExam`, `subscribeToLiveExam` (Realtime WebSockets), `resetStudentPin`, and `bulkImportStudents`. |
| [`portal.js`](./portal.js) | Full frontend controller for all 5 interactive modes: **Flashcards**, **KBC Speed Quiz** (50:50 & Hint lifelines + anti-farming XP: `+10 XP` first mastery, `+2 XP` revision, `+15 XP` clearing mistake), **Shortcut Ninja** (physical keyboard `keydown` listener + virtual keys), **Mini Excel Formula Sandbox** (`=SUM`, `=AVERAGE`, `=MAX`, `=COUNT`), **BSEB Pink OMR Simulator**, **Mistake Notebook (`गलती सुधार बैंक`)**, **3-Tier Leaderboard**, and **Printable A4 Certificate**. |
| [`portal.css`](./portal.css) | Responsive dark-mode glassmorphic UI, virtual keyboard deck, spreadsheet table, BSEB Pink/Magenta OMR bubble sheet, and `@media print` certificate styles. |
| [`teacher-host.html`](./teacher-host.html) | Teacher Live Exam Host & Projector Monitor: 4-digit Room PIN generator, live WebSocket participant table with `⚠️ Tab Switches` anti-cheat alerts, 1-click CSV/Excel result export, 1-click Student PIN Reset, and **Bulk `SchoolDB.csv` to Supabase PostgreSQL Importer**. |
| [`data/curriculum.js`](./data/curriculum.js) | Bilingual (Hindi + English) curriculum modules: `ICT_01` (Computer Fundamentals & OS), `ICT_02` (MS Word Mastery), `ICT_03` (MS Excel & Formulas), `ICT_04` (Artificial Intelligence & Cyber Safety), `BSEB_SCI_01` (BSEB Science/Physics PYQs), and `BSEB_GK_01` (BSEB History/Polity/Hindi Grammar PYQs). |
| [`supabase/schema.sql`](./supabase/schema.sql) | Idempotent PostgreSQL DDL + Indexes + RLS Policies + Realtime Publication + Seed Demo Student. |

---

## 🎯 Next Planned Milestones (Phase 2 — Ready to Pick Up from Mac Mini or School PC)

1. **Expand Phase 2 Curriculum in [`data/curriculum.js`](./data/curriculum.js)**:
   - Add **MS PowerPoint (`ICT_05`)**, **Internet, Email & Digital Bihar Services (`ICT_06`)**, and **Python / Coding Basics (`ICT_07`)**.
   - Expand **Class 9, 10, 11, and 12 Chapter-Wise BSEB Question Banks** (50+ PYQs per subject: Physics, Chemistry, Biology, Mathematics, History, Political Science, Geography, Sociology, Economics, Hindi, English).
2. **Teacher Custom Question Builder in [`teacher-host.html`](./teacher-host.html)**:
   - Allow teachers to type or paste custom bilingual MCQs (or upload a CSV of questions) directly into `public.portal_live_exams` when hosting an on-demand test.
3. **Full 50-of-100 BSEB Model Paper Mode**:
   - Add full-length timed BSEB Board Exam Mock Papers where students see 100 objective questions and the OMR evaluator automatically scores their first 50 shaded bubbles (authentic Bihar Board rule).
4. **Student Progress Analytics for Principal / Teachers**:
   - Add a Class-wise & Subject-wise analytics tab in `teacher-host.html` querying `public.portal_students` to show weak topics across the school.
