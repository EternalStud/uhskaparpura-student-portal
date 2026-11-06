# 🎓 U.H.S. Kaparpura — Gamified Student Learning Portal & Live Exam Host

Standalone repository ([`EternalStud/uhskaparpura-student-portal`](https://github.com/EternalStud/uhskaparpura-student-portal)) deployed on **Vercel** with custom domain **[`https://students.uhskaparpurakanti.in`](https://students.uhskaparpurakanti.in)** via Cloudflare DNS, backed by **Supabase PostgreSQL (`lvrsanukztinwqrgivth`) + Supabase Realtime WebSockets**.

---

## 🌐 Live Production URLs

* **Student Learning Portal**: [https://students.uhskaparpurakanti.in](https://students.uhskaparpurakanti.in)
* **Vercel Direct URL**: [https://uhskaparpura-student-portal.vercel.app](https://uhskaparpura-student-portal.vercel.app)
* **Teacher Live Exam Host & Projector**: [https://students.uhskaparpurakanti.in/teacher-host](https://students.uhskaparpurakanti.in/teacher-host)

---

## 🍎 Working Across School Windows PC & Home Mac Mini

### 1. First-Time Clone on Mac Mini (macOS)
Open **Terminal** on your Mac Mini and run:

```bash
mkdir -p ~/Projects/SchoolWeb
cd ~/Projects/SchoolWeb
git clone https://github.com/EternalStud/uhskaparpura-student-portal.git
cd uhskaparpura-student-portal

# Recommended once on macOS to prevent Windows CRLF vs macOS LF line-ending warnings:
git config core.autocrlf input

# Start local development server on port 8080:
python3 -m http.server 8080
```
Open in your browser on Mac Mini:
- **Student Portal (Local)**: [http://localhost:8080/index.html](http://localhost:8080/index.html)
- **Teacher Live Exam Host (Local)**: [http://localhost:8080/teacher-host.html](http://localhost:8080/teacher-host.html)

### 2. Switching Between School & Home
- **When starting work (School or Home)**:
  ```bash
  git pull origin main
  ```
- **When finishing work (School or Home)**:
  ```bash
  git add .
  git commit -m "Describe changes"
  git push origin main
  ```
  *(Pushing to GitHub triggers an automatic Vercel deployment to `students.uhskaparpurakanti.in` in ~15 seconds!)*

### 3. Prompt for AI Assistant on Mac Mini
When opening this folder on your Mac Mini, simply tell the AI assistant:
> *"Please read `studentPortalsofar.md` and `studentportal.md` to understand the project architecture, Supabase PostgreSQL setup, and current progress."*

---

## 🗄️ Live Supabase PostgreSQL Details

- **Status**: **Healthy & Active**
- **Project ID**: `lvrsanukztinwqrgivth`
- **Project URL**: `https://lvrsanukztinwqrgivth.supabase.co`
- **Schema File**: [`supabase/schema.sql`](./supabase/schema.sql)
- **Frontend Config**: [`config.js`](./config.js)
- **Demo Student Login**:
  - **Student Code Mode**: `DEMO_2026_001`
  - **Details Mode**: Class `11`, Stream `Arts`, Roll `1`, DOB `2011-01-01`

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
├── vercel.json             # Vercel deployment configuration with clean URLs & security headers
├── data/
│   └── curriculum.js       # Bilingual (Hindi + English) ICT Lab & BSEB Curriculum Bank
├── supabase/
│   └── schema.sql          # PostgreSQL DDL + Hardened RLS + Realtime Publication
├── studentportal.md        # Master Architecture & Product Blueprint
└── studentPortalsofar.md   # Implementation Progress Tracker & Mac Mini / Windows Sync Guide
```
