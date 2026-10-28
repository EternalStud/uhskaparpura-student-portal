# 🎓 U.H.S. Kaparpura — Gamified Student Learning Portal & Live Exam Host

Standalone repository (`uhskaparpura-student-portal`) powered by **Supabase PostgreSQL + Supabase Realtime WebSockets**, completely isolated from the public website (`uhskaparpurakanti-website`) and admin API (`uhskaparpura-admin-api`).

---

## 🚀 First-Time Setup Guide (Step-by-Step in 3 Minutes)

### Step 1: Create Your Free Supabase PostgreSQL Database
1. Go to **[https://supabase.com](https://supabase.com)** and click **Start your project** (Sign in with your GitHub account).
2. Click **New Project**:
   - **Name**: `uhskaparpura-student-portal`
   - **Database Password**: Create any strong password
   - **Region**: `South Asia (Mumbai)` (`ap-south-1`)
   - **Plan**: Free ($0/month)
3. Once the project finishes provisioning (~60 seconds), click **SQL Editor** in the left sidebar.
4. Open [`supabase/schema.sql`](./supabase/schema.sql) from this repository, **copy the entire SQL script**, paste it into the Supabase SQL Editor, and click **Run**.
   - This creates `portal_students`, `portal_live_exams`, and `portal_live_participants`, enables **Supabase Realtime WebSockets**, and seeds a sample student (`202410141306317` — Ankit Kumar, Class 11 Arts, Roll 2).

### Step 2: Copy Your Supabase Project URL & Anon Public Key
1. In your Supabase Dashboard, click **Project Settings (⚙️ gear icon at bottom left) → API (or Data API)**.
2. Copy two values:
   - **Project URL**: Looks like `https://xxxxxxxxxxxx.supabase.co`
   - **Project API Keys → `anon` `public` key**: Starts with `eyJhbGciOiJIUzI1NiIsInR5cCI6...`
3. Connect them in either of two ways:
   - **Option A (In-Browser 1-Click)**: Open `index.html` or `teacher-host.html`, click the **`🟠 Connect Supabase DB`** button in the top-right corner, paste your URL & Anon Key, and click **Save & Test Connection**.
   - **Option B (Permanent in Code)**: Paste them into [`config.js`](./config.js) under `SUPABASE_URL` and `SUPABASE_ANON_KEY`, commit, and push to GitHub.

---

## 📦 Repository Structure

```text
uhskaparpura-student-portal/
├── index.html              # Gamified Student Portal SPA
├── teacher-host.html       # Teacher Live Exam Host, Projector Monitor & CSV Bulk Importer
├── config.js               # Supabase URL, Anon Key & Read-Only SchoolDB Bridge URL
├── supabase-client.js      # Supabase PostgreSQL + Realtime WebSocket Data Layer
├── portal.js               # Student Portal UI & 5 Interactive Game/Simulator Controllers
├── portal.css              # Glassmorphic Dark UI, Pink BSEB OMR Sheet & Print Certificate CSS
├── data/
│   └── curriculum.js       # Bilingual (Hindi + English) ICT Lab & BSEB Curriculum Bank
├── supabase/
│   └── schema.sql          # Ready-to-run PostgreSQL DDL + RLS + Realtime Publication
├── studentportal.md        # Master Architecture & Product Blueprint
└── studentPortalsofar.md   # Implementation Progress Tracker (School <-> Home Sync)
```
