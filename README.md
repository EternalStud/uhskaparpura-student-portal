# Students of Bihar (Class 9–12)

A bilingual (Hindi-first, English, and Dual mode) academic learning, visual study-notes, live examination, and school management platform built for **Bihar School Examination Board (BSEB)** Class 9–12 students, teachers, and government schools — launching with **Uchch Madhyamik Vidyalaya, Kaparpura (Kanti, Muzaffarpur)** as School #1.

---

## Highlights

- **Built for Bihar Board (BSEB) Class 9–12:** Official subject rules for Class 9–10 (Mandatory + MIL + SIL) and Class 11–12 (Arts, Science, Commerce streams), chapter weightage, and BSEB marking schemes.
- **Visual, Simple-to-Deep Chapter Notes:** 30-second bilingual mindmaps, relatable everyday analogies, declarative bilingual SVG diagrams, KaTeX equations, printable sheets, and Hindi/English Web Speech Read-Aloud.
- **One-Stop Practice Studio:** Flashcards, Match-the-Pairs, Diagram Labeling, tiered MCQs (Foundation / Board / Topper), and 2-Mark / 5-Mark model answers with memory cues.
- **Live PIN & Scheduled Classroom Exams:** Immutable exam snapshots, deterministic per-student question/option shuffling, classroom Projector Monitor via scoped Realtime, and formula-safe Excel marksheet export.
- **Open Class & Subject Doubt Boards:** Zero private messaging; transparent school-scoped boards answered exclusively by verified school teachers.
- **e-Shikshakosh Ready:** Privacy-first student and teacher roster sync (automatically discards Aadhaar and Social Category in memory; stores only hashed/last-4 teacher mobile digits).

---

## Tech Stack

- **Framework:** Next.js 15 (App Router), React 19, TypeScript (strict)
- **Styling & Typography:** Tailwind CSS v3.4, Plus Jakarta Sans, Noto Sans Devanagari, Lucide React icons, KaTeX
- **Database & Scoped Realtime:** Supabase PostgreSQL with strict default-deny RLS
- **Media Vault:** Private Google Drive (5 TB Google One) via server-side OAuth2 resumable uploads & streaming proxy
- **Validation & Security:** Zod, bcryptjs, otplib (TOTP 2FA), Cloudflare Turnstile, `sanitize-html`

---

## Local Development Setup

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env.local
   ```
   Fill in your Supabase, cryptographic secrets (`openssl rand -hex 32`), Google OAuth, and optional Turnstile keys in `.env.local`. Never commit `.env.local`.

3. **Apply database migrations**
   Run the SQL migrations in `supabase/migrations/` in order (`001_v2_multitenant_schema.sql`, `002_bseb_seed_catalog.sql`, `003_gold_curriculum_seed.sql`) against your Supabase project.

4. **Start the development server**
   ```bash
   npm run dev
   ```
   Open [http://localhost:3000](http://localhost:3000).

---

## Scripts

| Command | Purpose |
| :--- | :--- |
| `npm run dev` | Start Next.js development server |
| `npm run build` | Build production bundle |
| `npm run start` | Start production server |
| `npm run typecheck` | Run strict TypeScript checking (`tsc --noEmit`) |
| `npm run lint` | Run ESLint checks |

---

## Documentation

- Architecture, security model, and multi-tenant data design: [SYSTEM_DESIGN.md](./SYSTEM_DESIGN.md)
- Previous legacy v1 static prototype is preserved in Git under tag `legacy-v1-archive`.
