/**
 * U.H.S. Kaparpura — Student Portal & Live Exam Host Configuration
 * Connected to Supabase PostgreSQL Project: lvrsanukztinwqrgivth
 */
window.PORTAL_CONFIG = {
  // Supabase Project URL
  SUPABASE_URL: localStorage.getItem("UHS_SUPABASE_URL") || "https://lvrsanukztinwqrgivth.supabase.co",

  // Supabase anon public key
  SUPABASE_ANON_KEY: localStorage.getItem("UHS_SUPABASE_ANON_KEY") || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2cnNhbnVrenRpbndxcmdpdnRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxODAzODUsImV4cCI6MjEwODc1NjM4NX0.PwB8t5kqdla0oHsAcR2ptZO3g4Ajw78QJOBNUnNQzzw",

  // Read-only SchoolDB verification endpoint (Hybrid Zero-Maintenance auto-upsert)
  SCHOOL_DB_API_URL: "https://script.google.com/macros/s/AKfycbwQtEdZ-Y-NIgFFoWCmqQap-hCdfHk6lTFjSqswH-bOS75MkPr4PFz31S-TuFea9KE/exec",

  SCHOOL_NAME: "उत्क्रमित उच्च माध्यमिक विद्यालय कपरपुरा, काँटी (मुजफ्फरपुर)",
  SCHOOL_NAME_EN: "Upgraded Senior Secondary School Kaparpura, Kanti (Muzaffarpur)"
};
