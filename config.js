/**
 * U.H.S. Kaparpura — Student Portal & Live Exam Host Configuration
 * ============================================================================
 * HOW TO CONNECT YOUR SUPABASE POSTGRESQL PROJECT:
 * 1. Go to https://supabase.com -> New Project ("uhskaparpura-portal")
 * 2. Go to Project Settings -> Data API (or API)
 * 3. Copy your "Project URL" and "anon public" key and paste them below
 *    (OR click the "⚙️ Connect Supabase" button directly in the Portal UI!)
 */
window.PORTAL_CONFIG = {
  // Paste your Supabase Project URL here (e.g., "https://xyzcompany.supabase.co")
  SUPABASE_URL: localStorage.getItem("UHS_SUPABASE_URL") || "",

  // Paste your Supabase anon public key here (e.g., "eyJhbGciOiJIUzI1NiIsInR5cCI6...")
  SUPABASE_ANON_KEY: localStorage.getItem("UHS_SUPABASE_ANON_KEY") || "",

  // Read-only SchoolDB verification endpoint (Hybrid Zero-Maintenance auto-upsert)
  SCHOOL_DB_API_URL: "https://script.google.com/macros/s/AKfycbwQtEdZ-Y-NIgFFoWCmqQap-hCdfHk6lTFjSqswH-bOS75MkPr4PFz31S-TuFea9KE/exec",

  SCHOOL_NAME: "उत्क्रमित उच्च माध्यमिक विद्यालय कपरपुरा, काँटी (मुजफ्फरपुर)",
  SCHOOL_NAME_EN: "Upgraded Senior Secondary School Kaparpura, Kanti (Muzaffarpur)"
};
