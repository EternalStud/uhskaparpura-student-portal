/**
 * U.H.S. Kaparpura — Supabase PostgreSQL + Realtime Service Layer
 * Connects directly to Supabase PostgreSQL for sub-50ms student login, XP sync,
 * 3-tier leaderboards, and Realtime WebSocket live classroom exams.
 * Includes Hybrid Zero-Maintenance fallback to read-only SchoolDB on first login.
 */
(function () {
  let sbClient = null;
  let realtimeChannel = null;

  function getCredentials() {
    const url = (window.PORTAL_CONFIG && window.PORTAL_CONFIG.SUPABASE_URL) || localStorage.getItem("UHS_SUPABASE_URL") || "";
    const key = (window.PORTAL_CONFIG && window.PORTAL_CONFIG.SUPABASE_ANON_KEY) || localStorage.getItem("UHS_SUPABASE_ANON_KEY") || "";
    return { url: url.trim().replace(/\/+$/, ""), key: key.trim() };
  }

  function isConfigured() {
    const { url, key } = getCredentials();
    return Boolean(url && url.startsWith("https://") && key && key.length > 20);
  }

  function getClient() {
    const { url, key } = getCredentials();
    if (!url || !key) {
      throw new Error("Supabase PostgreSQL is not connected yet. Click '⚙️ Connect Supabase' at the top right to paste your Project URL & Anon Key.");
    }
    if (!sbClient || sbClient._uhsUrl !== url || sbClient._uhsKey !== key) {
      if (!window.supabase || !window.supabase.createClient) {
        throw new Error("Supabase SDK failed to load. Please check your internet connection.");
      }
      sbClient = window.supabase.createClient(url, key, {
        auth: { persistSession: false }
      });
      sbClient._uhsUrl = url;
      sbClient._uhsKey = key;
    }
    return sbClient;
  }

  function saveCredentials(url, key) {
    const cleanUrl = String(url || "").trim().replace(/\/+$/, "");
    const cleanKey = String(key || "").trim();
    localStorage.setItem("UHS_SUPABASE_URL", cleanUrl);
    localStorage.setItem("UHS_SUPABASE_ANON_KEY", cleanKey);
    if (window.PORTAL_CONFIG) {
      window.PORTAL_CONFIG.SUPABASE_URL = cleanUrl;
      window.PORTAL_CONFIG.SUPABASE_ANON_KEY = cleanKey;
    }
    sbClient = null;
  }

  async function hashPin(pin, studentId) {
    const raw = `UHS_PORTAL_PIN_2026_${studentId}_${String(pin).trim()}`;
    if (window.crypto && window.crypto.subtle) {
      const buf = new TextEncoder().encode(raw);
      const digest = await window.crypto.subtle.digest("SHA-256", buf);
      return Array.from(new Uint8Array(digest)).map((b) => b.toString(16).padStart(2, "0")).join("");
    }
    let h = 0;
    for (let i = 0; i < raw.length; i++) {
      h = (h << 5) - h + raw.charCodeAt(i);
      h |= 0;
    }
    return String(Math.abs(h));
  }

  function normalizeDateStr(dInput) {
    if (!dInput) return "";
    const s = String(dInput).trim();
    if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;
    if (s.includes("/") || s.includes("-")) {
      const parts = s.split(/[\/\-]/);
      if (parts.length === 3) {
        if (parts[2].length === 4) {
          return `${parts[2]}-${parts[1].padStart(2, "0")}-${parts[0].padStart(2, "0")}`;
        }
        if (parts[0].length === 4) {
          return `${parts[0]}-${parts[1].padStart(2, "0")}-${parts[2].padStart(2, "0")}`;
        }
      }
    }
    return s;
  }

  function getIstWeekStartKey() {
    const now = new Date();
    const day = now.getDay(); // 0=Sun, 1=Mon
    const diff = now.getDate() - day + (day === 0 ? -6 : 1);
    const mon = new Date(now);
    mon.setDate(diff);
    return mon.toISOString().slice(0, 10);
  }

  function getDefaultSubjects(className, stream) {
    const cls = String(className || "").replace(/[^\d]/g, "");
    const st = String(stream || "").toLowerCase();
    const list = [
      { id: "ICT_LAB", code: "ICT", name: "ICT Lab, MS Office & AI", hiName: "कंप्यूटर लैब, एमएस ऑफिस एवं AI", group: "Skill" }
    ];
    if (cls === "9" || cls === "10") {
      list.push(
        { id: "BSEB_SCI", code: "112", name: "Science (विज्ञान)", hiName: "विज्ञान (Science)", group: "Core" },
        { id: "BSEB_MAT", code: "110", name: "Mathematics (गणित)", hiName: "गणित (Mathematics)", group: "Core" },
        { id: "BSEB_SST", code: "111", name: "Social Science (सामाजिक विज्ञान)", hiName: "सामाजिक विज्ञान", group: "Core" },
        { id: "BSEB_HIN", code: "101", name: "Hindi (हिन्दी)", hiName: "हिन्दी (Hindi)", group: "Language" },
        { id: "BSEB_ENG", code: "105", name: "English (अंग्रेज़ी)", hiName: "अंग्रेज़ी (English)", group: "Language" }
      );
    } else if (st.startsWith("sci")) {
      list.push(
        { id: "11_SCI_PHY", code: "117", name: "Physics (भौतिकी)", hiName: "भौतिकी (Physics)", group: "Elective" },
        { id: "11_SCI_CHE", code: "118", name: "Chemistry (रसायन शास्त्र)", hiName: "रसायन शास्त्र (Chemistry)", group: "Elective" },
        { id: "11_SCI_BIO", code: "119", name: "Biology / Maths", hiName: "जीव विज्ञान / गणित", group: "Elective" },
        { id: "11_SCI_HIN", code: "106", name: "Hindi (हिन्दी)", hiName: "हिन्दी (Hindi)", group: "Language" },
        { id: "11_SCI_ENG", code: "105", name: "English (अंग्रेज़ी)", hiName: "अंग्रेज़ी (English)", group: "Language" }
      );
    } else {
      list.push(
        { id: "11_ART_HIS", code: "327", name: "History (इतिहास)", hiName: "इतिहास (History)", group: "Elective" },
        { id: "11_ART_POL", code: "322", name: "Political Science (राजनीति विज्ञान)", hiName: "राजनीति विज्ञान", group: "Elective" },
        { id: "11_ART_GEO", code: "323", name: "Geography / Sociology", hiName: "भूगोल / समाजशास्त्र", group: "Elective" },
        { id: "11_ART_HIN", code: "306", name: "Hindi (हिन्दी)", hiName: "हिन्दी (Hindi)", group: "Language" },
        { id: "11_ART_ENG", code: "305", name: "English (अंग्रेज़ी)", hiName: "अंग्रेज़ी (English)", group: "Language" }
      );
    }
    return list;
  }

  /**
   * Read-only verification against live SchoolDB (uhskaparpura-admin-api public.registration.getStudent)
   * Used automatically when a student logs in for the very first time and is not yet in Supabase.
   */
  async function verifyFromLiveSchoolDB(payload) {
    const baseUrl = window.PORTAL_CONFIG && window.PORTAL_CONFIG.SCHOOL_DB_API_URL;
    if (!baseUrl) return null;

    const loginMode = String(payload.loginMode || "CODE").toUpperCase();
    const classesToSearch = loginMode === "CODE" ? ["11", "12", "10", "9"] : [String(payload.className || "").replace(/[^\d]/g, "")];

    for (const cls of classesToSearch) {
      if (!cls) continue;
      const params = new URLSearchParams({
        action: "public.registration.getStudent",
        className: cls
      });
      if (loginMode === "CODE") {
        params.set("studentCode", String(payload.studentCode || "").trim());
      } else {
        params.set("rollNo", String(payload.rollNo || "").trim());
        params.set("dob", normalizeDateStr(payload.dob));
        if (payload.stream && payload.stream !== "NA") {
          params.set("stream", String(payload.stream).trim());
        }
      }

      try {
        const res = await fetch(`${baseUrl}?${params.toString()}`, { method: "GET" });
        const data = await res.json();
        const st = data && (data.student || (data.data && data.data.student));
        if (st && st.studentName) {
          const cleanClass = String(st.className || cls).replace(/[^\d]/g, "");
          const cleanStream = st.stream || payload.stream || (cleanClass === "9" || cleanClass === "10" ? "NA" : "Arts");
          const cleanRoll = parseInt(st.rollNo || payload.rollNo || "0", 10) || 0;
          const cleanDob = normalizeDateStr(st.dob || payload.dob);
          const cleanCode = String(st.studentCode || payload.studentCode || "").trim();
          const studentId = cleanCode || `${cleanClass}_${cleanStream}_${cleanRoll}_${cleanDob}`;

          return {
            student_id: studentId,
            student_code: cleanCode || null,
            student_name: String(st.studentName).trim(),
            father_name: String(st.fatherName || "").trim(),
            mother_name: String(st.motherName || "").trim(),
            dob: cleanDob,
            gender: String(st.gender || "").trim(),
            class_name: cleanClass,
            stream: cleanStream,
            roll_no: cleanRoll,
            academic_year: String(st.academicYear || "2026-27"),
            medium: String(st.medium || "Hindi"),
            subjects: getDefaultSubjects(cleanClass, cleanStream)
          };
        }
      } catch (e) {
        // Continue trying next class if CODE mode
      }
    }
    return null;
  }

  function mapDbRowToStudent(row) {
    const subjects = Array.isArray(row.subjects) && row.subjects.length > 0
      ? row.subjects
      : getDefaultSubjects(row.class_name, row.stream);

    return {
      studentId: row.student_id,
      studentCode: row.student_code || "",
      studentName: row.student_name,
      fatherName: row.father_name || "",
      motherName: row.mother_name || "",
      dob: row.dob || "",
      gender: row.gender || "",
      rollNo: row.roll_no,
      className: row.class_name,
      stream: row.stream || "NA",
      academicYear: row.academic_year || "2026-27",
      medium: row.medium || "Hindi",
      subjects,
      hasPin: Boolean(row.pin_hash),
      totalXp: Number(row.total_xp || 0),
      weeklyXp: Number(row.weekly_xp || 0),
      ictXp: Number(row.ict_xp || 0),
      streak: Number(row.streak || 1),
      lastActiveDate: row.last_active_date || "",
      masteredMap: row.mastered_map || {},
      mistakeBank: row.mistake_bank || {},
      badges: Array.isArray(row.badges) ? row.badges : ["WELCOME_SCHOLAR"]
    };
  }

  /**
   * 1. STUDENT LOGIN (Supabase PostgreSQL Primary + Hybrid SchoolDB Auto-Upsert)
   */
  async function loginStudent(payload) {
    const sb = getClient();
    const loginMode = String(payload.loginMode || "CODE").toUpperCase();
    let row = null;

    if (loginMode === "CODE") {
      const code = String(payload.studentCode || "").trim();
      if (!code) throw new Error("कृपया छात्र कोड दर्ज करें (Please enter Student Code).");

      const { data, error } = await sb
        .from("portal_students")
        .select("*")
        .or(`student_code.eq.${code},student_id.eq.${code}`)
        .limit(1);

      if (error) throw new Error("Supabase Query Error: " + error.message);
      if (data && data.length > 0) row = data[0];
    } else {
      const cls = String(payload.className || "").replace(/[^\d]/g, "");
      const roll = parseInt(String(payload.rollNo || "").trim(), 10);
      const dob = normalizeDateStr(payload.dob);
      const stream = String(payload.stream || "").trim();

      if (!cls || isNaN(roll) || !dob) {
        throw new Error("कृपया कक्षा, रोल नंबर और जन्म तिथि सही से भरें।");
      }

      let query = sb
        .from("portal_students")
        .select("*")
        .eq("class_name", cls)
        .eq("roll_no", roll)
        .eq("dob", dob);

      if ((cls === "11" || cls === "12") && stream && stream !== "NA") {
        query = query.ilike("stream", `${stream.slice(0, 3)}%`);
      }

      const { data, error } = await query.limit(1);
      if (error) throw new Error("Supabase Query Error: " + error.message);
      if (data && data.length > 0) row = data[0];
    }

    // Hybrid Zero-Maintenance Fallback: Verify against live SchoolDB and auto-insert into Supabase!
    if (!row) {
      const verifiedFromSchoolDb = await verifyFromLiveSchoolDB(payload);
      if (!verifiedFromSchoolDb) {
        throw new Error("विद्यार्थी का विवरण नहीं मिला। कृपया अपना छात्र कोड या कक्षा/रोल नंबर/जन्म तिथि जाँचें। (Student not found in Supabase or SchoolDB).");
      }

      const todayStr = new Date().toISOString().slice(0, 10);
      const newRecord = {
        ...verifiedFromSchoolDb,
        total_xp: 25,
        weekly_xp: 25,
        ict_xp: 0,
        streak: 1,
        last_active_date: todayStr,
        week_start_key: getIstWeekStartKey(),
        mastered_map: {},
        mistake_bank: {},
        badges: ["WELCOME_SCHOLAR"],
        updated_at: new Date().toISOString()
      };

      const { data: inserted, error: insertErr } = await sb
        .from("portal_students")
        .upsert(newRecord, { onConflict: "student_id" })
        .select("*")
        .single();

      if (insertErr) throw new Error("Failed to save student to Supabase: " + insertErr.message);
      row = inserted;
    }

    // Optional 4-digit PIN Check / Setup
    const existingPinHash = String(row.pin_hash || "").trim();
    const inputPin = String(payload.pin || "").trim();
    const newPin = String(payload.newPin || "").trim();

    if (existingPinHash && payload.requirePinCheck) {
      if (!inputPin) {
        return {
          success: true,
          pinRequired: true,
          studentName: row.student_name,
          className: row.class_name,
          rollNo: row.roll_no
        };
      }
      const computed = await hashPin(inputPin, row.student_id);
      if (computed !== existingPinHash) {
        throw new Error("गलत 4-अंकीय पिन! कृपया पुनः प्रयास करें या शिक्षक से पिन रीसेट करवाएं। (Incorrect 4-digit PIN)");
      }
    }

    // Update Streak, Monday IST Weekly XP Reset, or New PIN
    const todayStr = new Date().toISOString().slice(0, 10);
    const currentWeekKey = getIstWeekStartKey();
    const updates = {};

    if (newPin && /^\d{4}$/.test(newPin)) {
      updates.pin_hash = await hashPin(newPin, row.student_id);
      row.pin_hash = updates.pin_hash;
    }

    if (row.week_start_key !== currentWeekKey) {
      updates.weekly_xp = 0;
      updates.week_start_key = currentWeekKey;
      row.weekly_xp = 0;
    }

    if (row.last_active_date !== todayStr) {
      const yest = new Date();
      yest.setDate(yest.getDate() - 1);
      const yestStr = yest.toISOString().slice(0, 10);
      updates.streak = row.last_active_date === yestStr ? (Number(row.streak || 1) + 1) : 1;
      updates.last_active_date = todayStr;
      updates.total_xp = Number(row.total_xp || 0) + 5; // Daily login bonus
      updates.weekly_xp = Number(row.weekly_xp || 0) + 5;
      row.streak = updates.streak;
      row.last_active_date = todayStr;
      row.total_xp = updates.total_xp;
      row.weekly_xp = updates.weekly_xp;
    }

    if (Object.keys(updates).length > 0) {
      updates.updated_at = new Date().toISOString();
      await sb.from("portal_students").update(updates).eq("student_id", row.student_id);
    }

    // Fetch active Live Exams for this student's class
    const activeLiveExams = await getActiveExamsForClass(row.class_name, row.stream);

    return {
      success: true,
      student: mapDbRowToStudent(row),
      activeLiveExams
    };
  }

  /**
   * 2. SYNC STUDENT PROGRESS, XP, MISTAKES & BADGES TO SUPABASE POSTGRESQL
   */
  async function syncProgress(payload) {
    const sb = getClient();
    const studentId = String(payload.studentId || "").trim();
    if (!studentId) throw new Error("Missing studentId");

    const { data: row, error: fetchErr } = await sb
      .from("portal_students")
      .select("*")
      .eq("student_id", studentId)
      .single();

    if (fetchErr || !row) throw new Error("Student record not found in Supabase.");

    const xpEarned = Math.max(0, Math.min(500, parseInt(payload.xpEarned || 0, 10) || 0));
    const isIct = Boolean(payload.isIct);
    const currentWeekKey = getIstWeekStartKey();

    let totalXp = Number(row.total_xp || 0) + xpEarned;
    let weeklyXp = (row.week_start_key === currentWeekKey ? Number(row.weekly_xp || 0) : 0) + xpEarned;
    let ictXp = Number(row.ict_xp || 0) + (isIct ? xpEarned : 0);

    const masteredMap = Object.assign({}, row.mastered_map || {});
    if (payload.chapterId && Array.isArray(payload.masteredQuestionIds)) {
      const existing = Array.isArray(masteredMap[payload.chapterId]) ? masteredMap[payload.chapterId] : [];
      masteredMap[payload.chapterId] = Array.from(new Set(existing.concat(payload.masteredQuestionIds))).slice(0, 300);
    }

    const mistakeBank = Object.assign({}, row.mistake_bank || {});
    if (Array.isArray(payload.wrongQuestionIds)) {
      payload.wrongQuestionIds.forEach((qId) => {
        if (qId) mistakeBank[qId] = (mistakeBank[qId] || 0) + 1;
      });
    }
    if (Array.isArray(payload.clearedMistakeIds)) {
      payload.clearedMistakeIds.forEach((qId) => {
        delete mistakeBank[qId];
      });
    }

    const badges = Array.isArray(row.badges) ? [...row.badges] : ["WELCOME_SCHOLAR"];
    const addBadge = (b) => { if (!badges.includes(b)) badges.push(b); };
    if (totalXp >= 100) addBadge("CENTURY_SCORER");
    if (totalXp >= 500) addBadge("BSEB_STAR");
    if (ictXp >= 150) addBadge("ICT_CHAMPION");
    if (payload.badgeUnlocked) addBadge(String(payload.badgeUnlocked));

    const updates = {
      total_xp: totalXp,
      weekly_xp: weeklyXp,
      ict_xp: ictXp,
      week_start_key: currentWeekKey,
      mastered_map: masteredMap,
      mistake_bank: mistakeBank,
      badges,
      updated_at: new Date().toISOString()
    };

    const { error: updateErr } = await sb
      .from("portal_students")
      .update(updates)
      .eq("student_id", studentId);

    if (updateErr) throw new Error("Failed to sync progress: " + updateErr.message);

    // Optional Co-Learner / Buddy XP split (+50% XP to partner on shared ICT Lab PC)
    if (payload.buddyStudentId && xpEarned > 0) {
      const buddyXp = Math.round(xpEarned * 0.5);
      const { data: buddyRow } = await sb
        .from("portal_students")
        .select("total_xp, weekly_xp, ict_xp")
        .eq("student_id", String(payload.buddyStudentId))
        .single();
      if (buddyRow) {
        await sb.from("portal_students").update({
          total_xp: Number(buddyRow.total_xp || 0) + buddyXp,
          weekly_xp: Number(buddyRow.weekly_xp || 0) + buddyXp,
          ict_xp: Number(buddyRow.ict_xp || 0) + (isIct ? buddyXp : 0),
          updated_at: new Date().toISOString()
        }).eq("student_id", String(payload.buddyStudentId));
      }
    }

    return {
      success: true,
      totalXp,
      weeklyXp,
      ictXp,
      masteredMap,
      mistakeBank,
      badges
    };
  }

  /**
   * 3. THREE-TIER LEADERBOARDS DIRECTLY FROM SUPABASE POSTGRESQL
   */
  async function getLeaderboards(className, stream) {
    const sb = getClient();
    const { data, error } = await sb
      .from("portal_students")
      .select("student_id, student_name, class_name, stream, roll_no, total_xp, weekly_xp, ict_xp, streak, badges")
      .order("total_xp", { ascending: false })
      .limit(200);

    if (error) throw new Error("Leaderboard fetch failed: " + error.message);

    const rows = (data || []).map((r) => ({
      studentId: r.student_id,
      studentName: r.student_name,
      className: r.class_name,
      stream: r.stream || "NA",
      rollNo: r.roll_no,
      totalXp: Number(r.total_xp || 0),
      weeklyXp: Number(r.weekly_xp || 0),
      ictXp: Number(r.ict_xp || 0),
      streak: Number(r.streak || 1),
      badgeCount: Array.isArray(r.badges) ? r.badges.length : 1
    }));

    const clsFilter = String(className || "").replace(/[^\d]/g, "");
    const streamFilter = String(stream || "").trim().toLowerCase();

    const classBoard = rows
      .filter((s) => {
        if (clsFilter && s.className !== clsFilter) return false;
        if (streamFilter && streamFilter !== "na" && streamFilter !== "all") {
          if (!String(s.stream || "").toLowerCase().startsWith(streamFilter.slice(0, 3))) return false;
        }
        return true;
      })
      .sort((a, b) => b.totalXp - a.totalXp)
      .slice(0, 15);

    const ictBoard = [...rows].sort((a, b) => b.ictXp - a.ictXp || b.totalXp - a.totalXp).slice(0, 15);
    const weeklyBoard = [...rows].sort((a, b) => b.weeklyXp - a.weeklyXp || b.totalXp - a.totalXp).slice(0, 15);

    return {
      success: true,
      classBoard,
      ictBoard,
      weeklyBoard
    };
  }

  /**
   * 4. TEACHER ON-DEMAND LIVE EXAMS (SUPABASE POSTGRESQL + REALTIME WEBSOCKETS)
   */
  async function getActiveExamsForClass(className, stream) {
    try {
      const sb = getClient();
      const { data } = await sb
        .from("portal_live_exams")
        .select("*")
        .eq("status", "ACTIVE")
        .order("created_at", { ascending: false })
        .limit(5);

      if (!data) return [];
      const cls = String(className || "").replace(/[^\d]/g, "");
      const st = String(stream || "").trim().toLowerCase();

      return data
        .filter((ex) => {
          const exCls = String(ex.class_name || "ALL");
          const exSt = String(ex.stream || "ALL").toLowerCase();
          if (exCls !== "ALL" && cls && exCls !== cls) return false;
          if (exSt !== "all" && exSt !== "na" && st && !st.startsWith(exSt.slice(0, 3))) return false;
          return true;
        })
        .map((ex) => ({
          pin: ex.pin,
          examId: ex.exam_id,
          title: ex.title,
          teacherName: ex.teacher_name,
          chapterId: ex.chapter_id,
          className: ex.class_name,
          stream: ex.stream,
          durationMins: ex.duration_mins,
          questionCount: ex.question_count
        }));
    } catch (e) {
      return [];
    }
  }

  async function createLiveExam(payload) {
    const sb = getClient();
    const pin = String(Math.floor(1000 + Math.random() * 9000));
    const examId = "LIVE_" + Date.now();

    const record = {
      pin,
      exam_id: examId,
      title: String(payload.title || "ICT Lab Live Evaluation"),
      teacher_name: String(payload.teacherName || "ICT Teacher"),
      chapter_id: String(payload.chapterId || "ICT_01"),
      class_name: String(payload.className || "ALL"),
      stream: String(payload.stream || "ALL"),
      duration_mins: Math.max(2, Math.min(60, parseInt(payload.durationMins || 10, 10) || 10)),
      question_count: Math.max(5, Math.min(50, parseInt(payload.questionCount || 10, 10) || 10)),
      questions: Array.isArray(payload.questions) ? payload.questions : [],
      status: "ACTIVE",
      created_at: new Date().toISOString()
    };

    // Delete any stale exam with the same 4-digit PIN first
    await sb.from("portal_live_exams").delete().eq("pin", pin);

    const { data, error } = await sb
      .from("portal_live_exams")
      .insert(record)
      .select("*")
      .single();

    if (error) throw new Error("Failed to create live exam: " + error.message);

    return {
      success: true,
      exam: {
        pin: data.pin,
        examId: data.exam_id,
        title: data.title,
        teacherName: data.teacher_name,
        chapterId: data.chapter_id,
        className: data.class_name,
        stream: data.stream,
        durationMins: data.duration_mins,
        questionCount: data.question_count,
        status: data.status,
        participants: {}
      }
    };
  }

  async function joinLiveExam(pin, student) {
    const sb = getClient();
    const cleanPin = String(pin || "").trim();

    const { data: exam, error: exErr } = await sb
      .from("portal_live_exams")
      .select("*")
      .eq("pin", cleanPin)
      .single();

    if (exErr || !exam) throw new Error("लाइव टेस्ट रूम पिन अमान्य है या समाप्त हो चुका है (Invalid Room PIN).");
    if (exam.status !== "ACTIVE") throw new Error("यह लाइव टेस्ट समाप्त हो चुका है (This Live Exam has ended).");

    const participantId = `${cleanPin}_${student.studentId}`;
    const { data: existing } = await sb
      .from("portal_live_participants")
      .select("*")
      .eq("id", participantId)
      .maybeSingle();

    if (!existing) {
      await sb.from("portal_live_participants").insert({
        id: participantId,
        pin: cleanPin,
        student_id: student.studentId,
        student_name: student.studentName,
        roll_no: parseInt(student.rollNo || 0, 10) || 0,
        class_name: String(student.className || ""),
        stream: String(student.stream || ""),
        status: "JOINED",
        answered_count: 0,
        total_questions: exam.question_count,
        score: 0,
        accuracy: 0,
        tab_switches: 0
      });
    }

    return {
      success: true,
      exam: {
        pin: exam.pin,
        examId: exam.exam_id,
        title: exam.title,
        teacherName: exam.teacher_name,
        chapterId: exam.chapter_id,
        durationMins: exam.duration_mins,
        questionCount: exam.question_count,
        questions: exam.questions || [],
        status: exam.status
      }
    };
  }

  async function updateLiveParticipant(pin, studentId, updates) {
    const sb = getClient();
    const participantId = `${String(pin).trim()}_${studentId}`;
    const patch = {
      updated_at: new Date().toISOString()
    };
    if (updates.answeredCount !== undefined) patch.answered_count = updates.answeredCount;
    if (updates.totalQuestions !== undefined) patch.total_questions = updates.totalQuestions;
    if (updates.score !== undefined) patch.score = updates.score;
    if (updates.accuracy !== undefined) patch.accuracy = updates.accuracy;
    if (updates.tabSwitches !== undefined) patch.tab_switches = updates.tabSwitches;
    if (updates.status !== undefined) {
      patch.status = updates.status;
      if (updates.status === "SUBMITTED") patch.submitted_at = new Date().toISOString();
    }

    const { error } = await sb
      .from("portal_live_participants")
      .update(patch)
      .eq("id", participantId);

    if (error) throw new Error(error.message);
    return { success: true };
  }

  async function getLiveExamStatus(pin) {
    const sb = getClient();
    const cleanPin = String(pin || "").trim();

    const { data: exam, error: exErr } = await sb
      .from("portal_live_exams")
      .select("*")
      .eq("pin", cleanPin)
      .single();

    if (exErr || !exam) throw new Error("Live exam not found.");

    const { data: parts } = await sb
      .from("portal_live_participants")
      .select("*")
      .eq("pin", cleanPin);

    const participants = {};
    (parts || []).forEach((p) => {
      participants[p.student_id] = {
        studentId: p.student_id,
        studentName: p.student_name,
        rollNo: p.roll_no,
        className: p.class_name,
        stream: p.stream,
        status: p.status,
        answeredCount: p.answered_count,
        totalQuestions: p.total_questions,
        score: p.score,
        accuracy: p.accuracy,
        tabSwitches: p.tab_switches,
        joinedAt: p.joined_at,
        submittedAt: p.submitted_at
      };
    });

    return {
      success: true,
      exam: {
        pin: exam.pin,
        examId: exam.exam_id,
        title: exam.title,
        teacherName: exam.teacher_name,
        chapterId: exam.chapter_id,
        className: exam.class_name,
        stream: exam.stream,
        durationMins: exam.duration_mins,
        questionCount: exam.question_count,
        status: exam.status,
        participants
      }
    };
  }

  async function endLiveExam(pin) {
    const sb = getClient();
    const cleanPin = String(pin || "").trim();
    await sb
      .from("portal_live_exams")
      .update({ status: "ENDED", ended_at: new Date().toISOString() })
      .eq("pin", cleanPin);

    return getLiveExamStatus(cleanPin);
  }

  /**
   * Subscribe to Supabase Realtime WebSocket changes for a Live Exam Room PIN
   */
  function subscribeToLiveExam(pin, onUpdateCallback) {
    try {
      const sb = getClient();
      if (realtimeChannel) {
        sb.removeChannel(realtimeChannel);
        realtimeChannel = null;
      }
      realtimeChannel = sb
        .channel(`room_${pin}`)
        .on(
          "postgres_changes",
          { event: "*", schema: "public", table: "portal_live_participants", filter: `pin=eq.${pin}` },
          () => {
            if (typeof onUpdateCallback === "function") onUpdateCallback();
          }
        )
        .on(
          "postgres_changes",
          { event: "*", schema: "public", table: "portal_live_exams", filter: `pin=eq.${pin}` },
          () => {
            if (typeof onUpdateCallback === "function") onUpdateCallback();
          }
        )
        .subscribe();
      return realtimeChannel;
    } catch (e) {
      return null;
    }
  }

  /**
   * 5. TEACHER / ADMIN UTILITIES: 1-Click Student PIN Reset & Bulk SchoolDB CSV Sync
   */
  async function resetStudentPin(targetStudentId) {
    const sb = getClient();
    const clean = String(targetStudentId || "").trim();
    if (!clean) throw new Error("Please enter Student Code or Student ID.");

    const { data, error } = await sb
      .from("portal_students")
      .update({ pin_hash: "", updated_at: new Date().toISOString() })
      .or(`student_id.eq.${clean},student_code.eq.${clean}`)
      .select("student_name");

    if (error) throw new Error(error.message);
    if (!data || data.length === 0) throw new Error("Student not found in Supabase.");
    return {
      success: true,
      message: `PIN reset successful for ${data[0].student_name}`
    };
  }

  async function bulkImportStudents(studentRows) {
    const sb = getClient();
    if (!Array.isArray(studentRows) || studentRows.length === 0) {
      throw new Error("No valid student rows found to import.");
    }

    const batchSize = 200;
    let importedCount = 0;

    for (let i = 0; i < studentRows.length; i += batchSize) {
      const chunk = studentRows.slice(i, i + batchSize);
      const { error } = await sb
        .from("portal_students")
        .upsert(chunk, { onConflict: "student_id" });
      if (error) throw new Error("Bulk upsert error: " + error.message);
      importedCount += chunk.length;
    }

    return {
      success: true,
      importedCount
    };
  }

  window.PortalDB = {
    isConfigured,
    getCredentials,
    saveCredentials,
    loginStudent,
    syncProgress,
    getLeaderboards,
    getActiveExamsForClass,
    createLiveExam,
    joinLiveExam,
    updateLiveParticipant,
    getLiveExamStatus,
    endLiveExam,
    subscribeToLiveExam,
    resetStudentPin,
    bulkImportStudents,
    getDefaultSubjects,
    normalizeDateStr
  };
})();
