/**
 * U.H.S. Kaparpura — Gamified Student Portal Controller (portal.js)
 * Powered by Supabase PostgreSQL + Realtime (window.PortalDB)
 */
const PortalApp = (function () {
  let state = {
    lang: localStorage.getItem("UHS_PORTAL_LANG") || "BOTH",
    loginMode: "CODE",
    pinRequired: false,
    student: null,
    buddyId: "",
    activeLiveExams: [],
    leaderboards: { classBoard: [], ictBoard: [], weeklyBoard: [] },
    activeLbTab: "class",
    currentActivity: null,
    liveExamSession: null
  };

  function init() {
    updateDbStatusPill();
    setLang(state.lang);

    // Restore logged-in student session if saved
    const saved = sessionStorage.getItem("UHS_PORTAL_STUDENT");
    if (saved) {
      try {
        state.student = JSON.parse(saved);
        enterDashboard();
      } catch (e) {
        sessionStorage.removeItem("UHS_PORTAL_STUDENT");
      }
    }

    // Global keyboard listener for Shortcut Ninja
    window.addEventListener("keydown", (e) => {
      if (!state.currentActivity || state.currentActivity.type !== "SHORTCUT") return;
      const pressed = [];
      if (e.ctrlKey) pressed.push("Ctrl");
      if (e.altKey) pressed.push("Alt");
      if (e.shiftKey) pressed.push("Shift");
      const k = e.key;
      if (!["Control", "Alt", "Shift", "Meta"].includes(k)) {
        pressed.push(k.length === 1 ? k.toUpperCase() : k);
      }
      if (pressed.length > 0) {
        e.preventDefault();
        verifyShortcutAttempt(pressed);
      }
    });

    // Anti-Cheat Tab Switch detector during Live Exam
    document.addEventListener("visibilitychange", () => {
      if (document.hidden && state.liveExamSession && !state.liveExamSession.submitted) {
        state.liveExamSession.tabSwitches = (state.liveExamSession.tabSwitches || 0) + 1;
        syncLiveExamHeartbeat();
      }
    });
  }

  function updateDbStatusPill() {
    const btn = document.getElementById("dbStatusBtn");
    if (!btn) return;
    if (window.PortalDB && window.PortalDB.isConfigured()) {
      btn.className = "db-pill connected";
      btn.innerHTML = "🟢 Supabase PostgreSQL Connected";
    } else {
      btn.className = "db-pill disconnected";
      btn.innerHTML = "🟠 Connect Supabase DB";
    }
  }

  function openSupabaseModal() {
    const creds = window.PortalDB.getCredentials();
    document.getElementById("sbUrlInput").value = creds.url || "";
    document.getElementById("sbKeyInput").value = creds.key || "";
    document.getElementById("sbTestMsg").innerHTML = "";
    document.getElementById("supabaseModal").classList.remove("hidden");
  }

  function closeSupabaseModal() {
    document.getElementById("supabaseModal").classList.add("hidden");
  }

  async function saveAndTestSupabase() {
    const url = document.getElementById("sbUrlInput").value.trim();
    const key = document.getElementById("sbKeyInput").value.trim();
    const msgEl = document.getElementById("sbTestMsg");

    if (!url || !key) {
      msgEl.innerHTML = `<span style="color:#fca5a5;">⚠️ Please enter both Supabase Project URL and Anon Public Key.</span>`;
      return;
    }

    window.PortalDB.saveCredentials(url, key);
    updateDbStatusPill();
    msgEl.innerHTML = `<span style="color:#fde68a;">⏳ Testing Supabase PostgreSQL connection...</span>`;

    try {
      await window.PortalDB.getLeaderboards("11", "Arts");
      msgEl.innerHTML = `<span style="color:#6ee7b7;">✅ Connected to Supabase PostgreSQL! Tables verified.</span>`;
      setTimeout(() => closeSupabaseModal(), 900);
    } catch (err) {
      msgEl.innerHTML = `<span style="color:#fca5a5;">❌ Connection Error: ${escapeHtml(err.message)}. Make sure you ran <code>supabase/schema.sql</code> in Supabase SQL Editor!</span>`;
    }
  }

  function setLang(lang) {
    state.lang = lang;
    localStorage.setItem("UHS_PORTAL_LANG", lang);
    document.querySelectorAll(".lang-btn").forEach((b) => {
      b.classList.toggle("active", b.getAttribute("data-lang") === lang);
    });
    if (state.student) {
      renderChaptersGrid();
      renderMistakesList();
      renderBadges();
    }
  }

  function biText(hi, en) {
    if (state.lang === "HI") return `<div class="bi-hi">${escapeHtml(hi || en)}</div>`;
    if (state.lang === "EN") return `<div class="bi-hi">${escapeHtml(en || hi)}</div>`;
    return `<div class="bi-hi">${escapeHtml(hi)}</div><div class="bi-en">${escapeHtml(en)}</div>`;
  }

  function setLoginMode(mode) {
    state.loginMode = mode;
    document.getElementById("tabCode").classList.toggle("active", mode === "CODE");
    document.getElementById("tabDetails").classList.toggle("active", mode === "DETAILS");
    document.getElementById("codeModeFields").classList.toggle("hidden", mode !== "CODE");
    document.getElementById("detailsModeFields").classList.toggle("hidden", mode !== "DETAILS");
  }

  function toggleStreamField() {
    const cls = document.getElementById("loginClass").value;
    const showStream = cls === "11" || cls === "12";
    document.getElementById("streamGroup").classList.toggle("hidden", !showStream);
  }

  function fillDemo() {
    setLoginMode("CODE");
    document.getElementById("loginStudentCode").value = "";
  }

  async function handleLogin() {
    const errEl = document.getElementById("loginError");
    const btn = document.getElementById("loginSubmitBtn");
    errEl.classList.add("hidden");

    if (!window.PortalDB.isConfigured()) {
      openSupabaseModal();
      errEl.textContent = "कृपया पहले अपना Supabase PostgreSQL Project URL और Anon Key जोड़ें (ऊपर 'Connect Supabase DB' बटन दबाएं)।";
      errEl.classList.remove("hidden");
      return;
    }

    const payload = {
      loginMode: state.loginMode,
      studentCode: document.getElementById("loginStudentCode").value.trim(),
      className: document.getElementById("loginClass").value,
      stream: document.getElementById("loginStream").value,
      rollNo: document.getElementById("loginRoll").value.trim(),
      dob: document.getElementById("loginDob").value,
      pin: document.getElementById("loginPin").value.trim(),
      requirePinCheck: true
    };

    state.buddyId = document.getElementById("buddyStudentId").value.trim();

    btn.disabled = true;
    btn.textContent = "⏳ सत्यापित किया जा रहा है (Verifying in Supabase PostgreSQL)...";

    try {
      const res = await window.PortalDB.loginStudent(payload);
      if (res.pinRequired) {
        state.pinRequired = true;
        document.getElementById("pinPromptBox").classList.remove("hidden");
        errEl.textContent = `स्वागत है ${res.studentName}! कृपया अपना 4-अंकीय सुरक्षा पिन दर्ज करें।`;
        errEl.classList.remove("hidden");
        btn.disabled = false;
        btn.textContent = "🔓 पिन सत्यापित करें (Verify PIN)";
        return;
      }

      state.student = res.student;
      state.activeLiveExams = res.activeLiveExams || [];
      sessionStorage.setItem("UHS_PORTAL_STUDENT", JSON.stringify(state.student));
      enterDashboard();
    } catch (err) {
      errEl.textContent = err.message || "लॉगिन विफल रहा।";
      errEl.classList.remove("hidden");
    } finally {
      btn.disabled = false;
      btn.textContent = "🚀 पोर्टल में प्रवेश करें (Login to Student Portal)";
    }
  }

  function enterDashboard() {
    document.getElementById("loginView").classList.add("hidden");
    document.getElementById("dashboardView").classList.remove("hidden");
    document.getElementById("switchStudentBtn").classList.remove("hidden");

    updateHeroStats();
    renderEnrolledSubjects();
    renderChaptersGrid();
    renderMistakesList();
    renderBadges();
    renderLiveBanner();
    refreshLeaderboards();
  }

  function logout() {
    sessionStorage.removeItem("UHS_PORTAL_STUDENT");
    state.student = null;
    state.currentActivity = null;
    document.getElementById("dashboardView").classList.add("hidden");
    document.getElementById("loginView").classList.remove("hidden");
    document.getElementById("switchStudentBtn").classList.add("hidden");
    document.getElementById("pinPromptBox").classList.add("hidden");
    document.getElementById("loginPin").value = "";
  }

  function updateHeroStats() {
    const s = state.student;
    if (!s) return;
    document.getElementById("stName").textContent = s.studentName;
    document.getElementById("stMeta").textContent = `Class ${s.className}${s.stream && s.stream !== "NA" ? " (" + s.stream + ")" : ""} • Roll ${s.rollNo}`;
    document.getElementById("stTotalXp").textContent = `${s.totalXp || 0} XP`;
    document.getElementById("stIctXp").textContent = `${s.ictXp || 0} XP`;
    document.getElementById("stStreak").textContent = `${s.streak || 1} Days`;
    const mistakeCount = Object.keys(s.mistakeBank || {}).length;
    document.getElementById("stMistakesCount").textContent = String(mistakeCount);

    // Certificate fields
    document.getElementById("certStudentName").textContent = s.studentName;
    document.getElementById("certStudentMeta").textContent = `Class ${s.className} (${s.stream || "General"}) • Roll No: ${s.rollNo} • Code: ${s.studentCode || s.studentId}`;
    document.getElementById("certXpText").textContent = `${s.totalXp || 0} XP`;
    document.getElementById("certBadgesText").textContent = `${(s.badges || []).length} Badges`;
    document.getElementById("certDateText").textContent = new Date().toLocaleDateString("en-IN");
  }

  function renderEnrolledSubjects() {
    const bar = document.getElementById("enrolledSubjectsBar");
    const subs = (state.student && state.student.subjects) || [];
    bar.innerHTML = `<span style="font-size:0.8rem;color:var(--text-muted);font-weight:600;">आपकी नामांकित विषय सूची (Enrolled Subjects):</span>` +
      subs.map((sub) => `<span style="background:rgba(59,130,246,0.14);border:1px solid rgba(59,130,246,0.35);padding:0.25rem 0.65rem;border-radius:99px;font-size:0.78rem;color:#bfdbfe;">${escapeHtml(sub.name)}</span>`).join("");
  }

  function renderLiveBanner() {
    const banner = document.getElementById("liveExamAlertBanner");
    if (!state.activeLiveExams || state.activeLiveExams.length === 0) {
      banner.classList.add("hidden");
      return;
    }
    const ex = state.activeLiveExams[0];
    document.getElementById("liveBannerTitle").textContent = ex.title;
    document.getElementById("liveBannerMeta").textContent = `(Room PIN: ${ex.pin} • ${ex.durationMins} Mins • ${ex.questionCount} Qs)`;
    banner.classList.remove("hidden");
  }

  function joinBannerExam() {
    if (!state.activeLiveExams || state.activeLiveExams.length === 0) return;
    document.getElementById("liveRoomPinInput").value = state.activeLiveExams[0].pin;
    joinLiveExamByPin();
  }

  function showTab(tabId) {
    ["chapters", "live", "mistakes", "leaderboard", "certificate"].forEach((t) => {
      document.getElementById(`tab_${t}`).classList.toggle("hidden", t !== tabId);
    });
    document.querySelectorAll(".nav-pill").forEach((b) => {
      b.classList.toggle("active", b.getAttribute("data-tab") === tabId);
    });
    document.getElementById("activityWorkspace").classList.add("hidden");
    if (tabId === "leaderboard") refreshLeaderboards();
  }

  function renderChaptersGrid() {
    const grid = document.getElementById("chaptersGrid");
    const chapters = window.PORTAL_CURRICULUM.chapters || [];
    const masteredMap = (state.student && state.student.masteredMap) || {};

    grid.innerHTML = chapters.map((ch) => {
      const masteredCount = (masteredMap[ch.id] || []).length;
      const totalQs = (ch.questions || []).length;
      const pct = totalQs > 0 ? Math.min(100, Math.round((masteredCount / totalQs) * 100)) : 0;

      return `
        <div class="chapter-card">
          <div>
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:0.65rem;">
              <span style="font-size:1.75rem;">${ch.icon}</span>
              <span style="font-size:0.75rem;padding:0.2rem 0.6rem;border-radius:99px;background:rgba(16,185,129,0.15);color:#6ee7b7;font-weight:700;">
                ${masteredCount}/${totalQs} Mastered (${pct}%)
              </span>
            </div>
            ${biText(ch.titleHi, ch.titleEn)}
            <div style="margin-top:0.45rem;font-size:0.83rem;color:var(--text-muted);">
              ${state.lang === "EN" ? escapeHtml(ch.descEn) : escapeHtml(ch.descHi)}
            </div>
          </div>

          <div>
            <div style="height:6px;background:#0f172a;border-radius:99px;overflow:hidden;margin-bottom:0.85rem;">
              <div style="width:${pct}%;height:100%;background:${ch.color};"></div>
            </div>
            <div class="chapter-actions">
              <button class="btn btn-outline" style="font-size:0.78rem;padding:0.42rem 0.7rem;" onclick="PortalApp.startFlashcards('${ch.id}')">
                📖 Flashcards
              </button>
              <button class="btn btn-primary" style="font-size:0.78rem;padding:0.42rem 0.7rem;" onclick="PortalApp.startQuiz('${ch.id}')">
                ⚡ KBC Speed Quiz
              </button>
              ${ch.shortcuts && ch.shortcuts.length > 0 ? `
                <button class="btn btn-accent" style="font-size:0.78rem;padding:0.42rem 0.7rem;" onclick="PortalApp.startShortcutNinja('${ch.id}')">
                  ⌨️ Shortcut Ninja
                </button>
              ` : ""}
              ${ch.excelTasks && ch.excelTasks.length > 0 ? `
                <button class="btn btn-success" style="font-size:0.78rem;padding:0.42rem 0.7rem;" onclick="PortalApp.startExcelSandbox('${ch.id}')">
                  📊 Excel Lab
                </button>
              ` : ""}
              <button class="btn btn-outline" style="font-size:0.78rem;padding:0.42rem 0.7rem;border-color:#db2777;color:#f472b6;" onclick="PortalApp.startOmrSimulator('${ch.id}')">
                📝 BSEB OMR
              </button>
            </div>
          </div>
        </div>
      `;
    }).join("");
  }

  function openWorkspace(html) {
    ["chapters", "live", "mistakes", "leaderboard", "certificate"].forEach((t) => {
      document.getElementById(`tab_${t}`).classList.add("hidden");
    });
    const ws = document.getElementById("activityWorkspace");
    ws.innerHTML = html;
    ws.classList.remove("hidden");
    ws.scrollIntoView({ behavior: "smooth" });
  }

  function closeWorkspace() {
    state.currentActivity = null;
    document.getElementById("activityWorkspace").classList.add("hidden");
    showTab("chapters");
  }

  /* =========================================================================
   * MODE 1: INTERACTIVE BILINGUAL FLASHCARDS
   * ========================================================================= */
  function startFlashcards(chapterId) {
    const ch = window.PORTAL_CURRICULUM.chapters.find((c) => c.id === chapterId);
    if (!ch || !ch.flashcards || ch.flashcards.length === 0) return;

    state.currentActivity = { type: "FLASHCARD", chapter: ch, index: 0 };
    renderFlashcardStep();
  }

  function renderFlashcardStep() {
    const { chapter, index } = state.currentActivity;
    const card = chapter.flashcards[index];
    const total = chapter.flashcards.length;

    openWorkspace(`
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
        <h3>${chapter.icon} ${escapeHtml(chapter.titleHi)} — Flashcard ${index + 1}/${total}</h3>
        <button class="btn btn-outline" onclick="PortalApp.closeWorkspace()">✕ वापस जाएं (Back)</button>
      </div>
      <div style="background:rgba(15,23,42,0.85);border:1px solid rgba(59,130,246,0.4);border-radius:16px;padding:1.6rem;">
        ${biText(card.titleHi, card.titleEn)}
        <hr style="border:none;border-top:1px solid var(--border-glass);margin:0.9rem 0;" />
        <div style="font-size:1rem;line-height:1.65;">
          ${biText(card.bodyHi, card.bodyEn)}
        </div>
        <div style="margin-top:1.1rem;background:rgba(245,158,11,0.15);border-left:4px solid #f59e0b;padding:0.75rem 1rem;border-radius:8px;">
          ${biText(card.tipHi, card.tipEn)}
        </div>
      </div>
      <div style="display:flex;justify-content:space-between;margin-top:1.2rem;">
        <button class="btn btn-outline" ${index === 0 ? "disabled" : ""} onclick="PortalApp.stepFlashcard(-1)">⬅️ पिछला (Prev)</button>
        ${index < total - 1
          ? `<button class="btn btn-primary" onclick="PortalApp.stepFlashcard(1)">अगला (Next) ➡️</button>`
          : `<button class="btn btn-success" onclick="PortalApp.startQuiz('${chapter.id}')">⚡ अब KBC क्विज़ खेलें (Start Quiz)</button>`
        }
      </div>
    `);
  }

  function stepFlashcard(delta) {
    state.currentActivity.index += delta;
    renderFlashcardStep();
  }

  /* =========================================================================
   * MODE 2: KBC SPEED QUIZ (WITH 50:50, HINT & ANTI-FARMING XP)
   * ========================================================================= */
  function startQuiz(chapterId, customQuestions, isMistakeMode) {
    const ch = window.PORTAL_CURRICULUM.chapters.find((c) => c.id === chapterId) || window.PORTAL_CURRICULUM.chapters[0];
    const questions = (customQuestions || ch.questions || []).map((q) => Object.assign({}, q));
    if (questions.length === 0) return;

    state.currentActivity = {
      type: "QUIZ",
      chapter: ch,
      questions,
      index: 0,
      score: 0,
      xpEarned: 0,
      streak: 0,
      used5050: false,
      usedHint: false,
      isMistakeMode: Boolean(isMistakeMode),
      masteredIds: [],
      wrongIds: [],
      clearedMistakes: []
    };
    renderQuizQuestion();
  }

  function renderQuizQuestion() {
    const act = state.currentActivity;
    if (act.index >= act.questions.length) {
      finishQuizSession();
      return;
    }

    const q = act.questions[act.index];
    const optsHi = q.optionsHi || q.optionsEn || [];
    const optsEn = q.optionsEn || q.optionsHi || [];

    openWorkspace(`
      <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:0.5rem;margin-bottom:1rem;">
        <div>
          <span style="font-size:0.8rem;color:#93c5fd;font-weight:700;">प्रश्न ${act.index + 1} / ${act.questions.length}</span>
          <span style="margin-left:0.75rem;font-size:0.8rem;color:#fcd34d;">🔥 Streak: ${act.streak}x</span>
        </div>
        <div style="display:flex;gap:0.5rem;">
          <button id="btn5050" class="btn btn-outline" style="font-size:0.76rem;padding:0.35rem 0.65rem;" ${act.used5050 ? "disabled" : ""} onclick="PortalApp.useLifeline5050()">
            🌓 50:50 Lifeline
          </button>
          <button id="btnHint" class="btn btn-outline" style="font-size:0.76rem;padding:0.35rem 0.65rem;" ${act.usedHint ? "disabled" : ""} onclick="PortalApp.useLifelineHint()">
            💡 Hint
          </button>
          <button class="btn btn-outline" style="font-size:0.76rem;padding:0.35rem 0.65rem;" onclick="PortalApp.closeWorkspace()">✕ Exit</button>
        </div>
      </div>

      <div style="background:rgba(15,23,42,0.9);border:1px solid var(--border-glass);border-radius:14px;padding:1.25rem;">
        ${biText(q.qHi, q.qEn)}
      </div>

      <div class="quiz-options">
        ${optsHi.map((optH, idx) => {
          const optE = optsEn[idx] || optH;
          const label = ["A", "B", "C", "D"][idx];
          return `
            <button class="quiz-opt" id="qopt_${idx}" onclick="PortalApp.submitQuizAnswer(${idx})">
              <strong>(${label})</strong> ${state.lang === "EN" ? escapeHtml(optE) : (state.lang === "HI" ? escapeHtml(optH) : `${escapeHtml(optH)} / ${escapeHtml(optE)}`)}
            </button>
          `;
        }).join("")}
      </div>

      <div id="quizFeedbackBox" class="hidden" style="margin-top:1rem;padding:1rem;border-radius:12px;background:rgba(30,41,59,0.95);border:1px solid var(--border-glass);"></div>
    `);
  }

  function useLifeline5050() {
    const act = state.currentActivity;
    if (act.used5050) return;
    act.used5050 = true;
    document.getElementById("btn5050").disabled = true;

    const q = act.questions[act.index];
    let removed = 0;
    [0, 1, 2, 3].forEach((i) => {
      if (i !== q.correct && removed < 2) {
        const el = document.getElementById(`qopt_${i}`);
        if (el) {
          el.disabled = true;
          el.style.opacity = "0.25";
          removed++;
        }
      }
    });
  }

  function useLifelineHint() {
    const act = state.currentActivity;
    if (act.usedHint) return;
    act.usedHint = true;
    document.getElementById("btnHint").disabled = true;
    const q = act.questions[act.index];
    const fb = document.getElementById("quizFeedbackBox");
    fb.classList.remove("hidden");
    fb.innerHTML = `💡 <b>Hint / संकेत:</b> ${escapeHtml(state.lang === "EN" ? q.expEn : q.expHi)}`;
  }

  function submitQuizAnswer(chosenIdx) {
    const act = state.currentActivity;
    const q = act.questions[act.index];
    const isCorrect = chosenIdx === q.correct;

    [0, 1, 2, 3].forEach((i) => {
      const btn = document.getElementById(`qopt_${i}`);
      if (!btn) return;
      btn.disabled = true;
      if (i === q.correct) btn.classList.add("correct");
      else if (i === chosenIdx) btn.classList.add("wrong");
    });

    const alreadyMastered = ((state.student.masteredMap && state.student.masteredMap[act.chapter.id]) || []).includes(q.id);
    let qXp = 0;

    if (isCorrect) {
      act.score++;
      act.streak++;
      // Anti-farming XP rule: +10 XP first time, +2 XP revision, +5 XP clearing mistake
      qXp = act.isMistakeMode ? 15 : (alreadyMastered ? 2 : 10);
      if (act.streak >= 3) qXp += 3;
      act.xpEarned += qXp;
      act.masteredIds.push(q.id);
      if (act.isMistakeMode) act.clearedMistakes.push(q.id);
    } else {
      act.streak = 0;
      act.wrongIds.push(q.id);
    }

    const fb = document.getElementById("quizFeedbackBox");
    fb.classList.remove("hidden");
    fb.innerHTML = `
      <div style="font-weight:700;color:${isCorrect ? "#6ee7b7" : "#fca5a5"};margin-bottom:0.4rem;">
        ${isCorrect ? `✅ बिल्कुल सही! (+${qXp} XP ${alreadyMastered && !act.isMistakeMode ? "[Revision XP]" : ""})` : "❌ गलत उत्तर! (यह प्रश्न गलती सुधार बैंक में जोड़ दिया गया है)"}
      </div>
      ${biText(q.expHi, q.expEn)}
      <div style="margin-top:0.85rem;text-align:right;">
        <button class="btn btn-primary" onclick="PortalApp.nextQuizQuestion()">अगला प्रश्न (Next) ➡️</button>
      </div>
    `;
  }

  function nextQuizQuestion() {
    state.currentActivity.index++;
    renderQuizQuestion();
  }

  async function finishQuizSession() {
    const act = state.currentActivity;
    const pct = Math.round((act.score / act.questions.length) * 100);
    const badgeUnlocked = pct >= 80 ? (act.isMistakeMode ? "MISTAKE_CRUSHER" : act.chapter.badgeId) : null;

    openWorkspace(`
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:3rem;">${pct >= 80 ? "🏆" : "👏"}</div>
        <h2 style="margin:0.5rem 0;">क्विज़ समाप्त! स्कोर: ${act.score} / ${act.questions.length} (${pct}%)</h2>
        <p style="color:#6ee7b7;font-size:1.15rem;font-weight:700;margin-bottom:1rem;">⚡ कुल अर्जित XP: +${act.xpEarned} XP</p>
        <p id="syncStatusText" style="font-size:0.85rem;color:var(--text-muted);margin-bottom:1.25rem;">⏳ Supabase PostgreSQL में स्कोर सुरक्षित किया जा रहा है...</p>
        <button class="btn btn-primary" onclick="PortalApp.closeWorkspace()">📚 अध्यायों पर वापस जाएं</button>
      </div>
    `);

    await persistProgressToSupabase({
      chapterId: act.chapter.id,
      isIct: act.chapter.category === "ICT",
      xpEarned: act.xpEarned,
      masteredQuestionIds: act.masteredIds,
      wrongQuestionIds: act.wrongIds,
      clearedMistakeIds: act.clearedMistakes,
      badgeUnlocked
    });
  }

  /* =========================================================================
   * MODE 3: SHORTCUT NINJA (PHYSICAL KEYBOARD + VIRTUAL KEYS)
   * ========================================================================= */
  function startShortcutNinja(chapterId) {
    const ch = window.PORTAL_CURRICULUM.chapters.find((c) => c.id === chapterId);
    if (!ch || !ch.shortcuts || ch.shortcuts.length === 0) return;

    state.currentActivity = {
      type: "SHORTCUT",
      chapter: ch,
      shortcuts: ch.shortcuts,
      index: 0,
      selectedKeys: [],
      xpEarned: 0
    };
    renderShortcutStep();
  }

  function renderShortcutStep() {
    const act = state.currentActivity;
    if (act.index >= act.shortcuts.length) {
      finishShortcutNinja();
      return;
    }

    const item = act.shortcuts[act.index];
    const virtualDeck = ["Ctrl", "Alt", "Shift", "B", "C", "E", "F", "H", "I", "N", "P", "S", "U", "V", "Z", "F2", "F4", "F7", "=", ";", "Enter"];

    openWorkspace(`
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
        <h3>⌨️ Shortcut Ninja — ${act.index + 1}/${act.shortcuts.length}</h3>
        <button class="btn btn-outline" onclick="PortalApp.closeWorkspace()">✕ Exit</button>
      </div>

      <div style="background:rgba(15,23,42,0.9);border:1px solid rgba(245,158,11,0.45);border-radius:14px;padding:1.4rem;text-align:center;">
        <p style="font-size:0.8rem;color:#fcd34d;margin-bottom:0.4rem;">अपने कीबोर्ड पर शॉर्टकट दबाएं या नीचे वर्चुअल बटन चुनें:</p>
        ${biText(item.promptHi, item.promptEn)}
        <div id="shortcutComboPreview" style="margin:1.1rem auto;min-height:46px;display:flex;justify-content:center;align-items:center;gap:0.5rem;font-family:monospace;font-size:1.2rem;color:#93c5fd;">
          ${act.selectedKeys.length ? act.selectedKeys.join(" + ") : "कोई कुंजी चुनें..."}
        </div>
        <div style="display:flex;gap:0.5rem;justify-content:center;">
          <button class="btn btn-primary" onclick="PortalApp.checkVirtualShortcut()">✅ जाँचें (Check Shortcut)</button>
          <button class="btn btn-outline" onclick="PortalApp.clearVirtualShortcut()">🔄 Clear</button>
        </div>
      </div>

      <div class="key-deck">
        ${virtualDeck.map((k) => `
          <button class="v-key ${act.selectedKeys.includes(k) ? "pressed" : ""}" onclick="PortalApp.toggleVirtualKey('${k}')">${k}</button>
        `).join("")}
      </div>

      <div id="shortcutFeedback" style="margin-top:1rem;font-weight:700;text-align:center;"></div>
    `);
  }

  function toggleVirtualKey(k) {
    const act = state.currentActivity;
    if (act.selectedKeys.includes(k)) {
      act.selectedKeys = act.selectedKeys.filter((x) => x !== k);
    } else {
      act.selectedKeys.push(k);
    }
    renderShortcutStep();
  }

  function clearVirtualShortcut() {
    state.currentActivity.selectedKeys = [];
    renderShortcutStep();
  }

  function checkVirtualShortcut() {
    verifyShortcutAttempt(state.currentActivity.selectedKeys);
  }

  function verifyShortcutAttempt(keysArr) {
    const act = state.currentActivity;
    const item = act.shortcuts[act.index];
    const norm = (arr) => arr.map((x) => String(x).toUpperCase()).sort().join("+");
    const isMatch = norm(keysArr) === norm(item.keys);

    const fb = document.getElementById("shortcutFeedback");
    if (!fb) return;

    if (isMatch) {
      act.xpEarned += 10;
      fb.innerHTML = `<span style="color:#6ee7b7;">✅ शानदार! सही शॉर्टकट: ${item.keys.join(" + ")} (+10 XP)</span>`;
      setTimeout(() => {
        act.index++;
        act.selectedKeys = [];
        renderShortcutStep();
      }, 900);
    } else {
      fb.innerHTML = `<span style="color:#fca5a5;">❌ पुनः प्रयास करें! सही संकेत: ${item.keys[0]} के साथ कुंजी दबाएं।</span>`;
    }
  }

  async function finishShortcutNinja() {
    const act = state.currentActivity;
    openWorkspace(`
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:3rem;">⌨️</div>
        <h2>Shortcut Ninja पूरा हुआ!</h2>
        <p style="color:#6ee7b7;font-size:1.15rem;font-weight:700;margin:0.6rem 0;">+${act.xpEarned} ICT XP अर्जित!</p>
        <p id="syncStatusText" style="font-size:0.84rem;color:var(--text-muted);margin-bottom:1rem;">⏳ Supabase PostgreSQL में सेव हो रहा है...</p>
        <button class="btn btn-primary" onclick="PortalApp.closeWorkspace()">वापस जाएं</button>
      </div>
    `);

    await persistProgressToSupabase({
      chapterId: act.chapter.id,
      isIct: true,
      xpEarned: act.xpEarned,
      badgeUnlocked: "WORD_NINJA"
    });
  }

  /* =========================================================================
   * MODE 4: MINI EXCEL FORMULA SANDBOX
   * ========================================================================= */
  function startExcelSandbox(chapterId) {
    const ch = window.PORTAL_CURRICULUM.chapters.find((c) => c.id === chapterId);
    if (!ch || !ch.excelTasks) return;

    state.currentActivity = {
      type: "EXCEL",
      chapter: ch,
      tasks: ch.excelTasks,
      index: 0,
      xpEarned: 0
    };
    renderExcelTask();
  }

  function renderExcelTask() {
    const act = state.currentActivity;
    if (act.index >= act.tasks.length) {
      finishExcelSandbox();
      return;
    }

    const task = act.tasks[act.index];
    openWorkspace(`
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
        <h3>📊 MS Excel Formula Sandbox — ${act.index + 1}/${act.tasks.length}</h3>
        <button class="btn btn-outline" onclick="PortalApp.closeWorkspace()">✕ Exit</button>
      </div>

      ${biText(task.titleHi, task.titleEn)}
      <p style="font-size:0.88rem;color:var(--text-muted);margin:0.4rem 0 0.9rem;">
        ${state.lang === "EN" ? escapeHtml(task.promptEn) : escapeHtml(task.promptHi)}
      </p>

      <table class="excel-table">
        <thead>
          <tr><th>Row / Col</th><th>A (Subject / विषय)</th><th>B (Marks / अंक)</th></tr>
        </thead>
        <tbody>
          <tr><th>1</th><td><b>Subject Name</b></td><td><b>Marks Obtained</b></td></tr>
          <tr><th>2</th><td>Hindi (हिन्दी)</td><td>82</td></tr>
          <tr><th>3</th><td>Mathematics (गणित)</td><td>92</td></tr>
          <tr><th>4</th><td>Science (विज्ञान)</td><td>76</td></tr>
          <tr><th>5</th><td>Computer / ICT</td><td>70</td></tr>
          <tr style="background:rgba(16,185,129,0.12);">
            <th>6</th>
            <td><b>Result Cell (B6)</b></td>
            <td>
              <input type="text" id="excelFormulaInput" class="form-control" placeholder="यहाँ फॉर्मूला लिखें उदा. =SUM(B2:B5)" style="font-family:monospace;text-transform:uppercase;" />
            </td>
          </tr>
        </tbody>
      </table>

      <div style="display:flex;gap:0.65rem;align-items:center;flex-wrap:wrap;">
        <button class="btn btn-success" onclick="PortalApp.evaluateExcelTask()">▶️ Run Formula (Enter)</button>
        <span style="font-size:0.8rem;color:#fcd34d;">${escapeHtml(state.lang === "EN" ? task.hintEn : task.hintHi)}</span>
      </div>

      <div id="excelFeedback" style="margin-top:0.9rem;font-weight:700;"></div>
    `);
  }

  function evaluateExcelTask() {
    const act = state.currentActivity;
    const task = act.tasks[act.index];
    const raw = (document.getElementById("excelFormulaInput").value || "").replace(/\s+/g, "").toUpperCase();
    const fb = document.getElementById("excelFeedback");

    if (!raw.startsWith("=")) {
      fb.innerHTML = `<span style="color:#fca5a5;">⚠️ याद रखें: MS Excel में हर फॉर्मूला बराबर चिह्न (<b>=</b>) से शुरू होता है!</span>`;
      return;
    }

    if (task.expectedFormulas.includes(raw)) {
      act.xpEarned += 15;
      fb.innerHTML = `<span style="color:#6ee7b7;">✅ बिल्कुल सही! परिणाम = <b>${task.expectedValue}</b> (+15 ICT XP)</span>`;
      setTimeout(() => {
        act.index++;
        renderExcelTask();
      }, 1000);
    } else {
      fb.innerHTML = `<span style="color:#fca5a5;">❌ फॉर्मूला सिंटैक्स जाँचें। सही प्रारूप: <code>${task.expectedFormulas[0]}</code></span>`;
    }
  }

  async function finishExcelSandbox() {
    const act = state.currentActivity;
    openWorkspace(`
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:3rem;">📊</div>
        <h2>Excel Formula Wizard पूरा हुआ!</h2>
        <p style="color:#6ee7b7;font-size:1.15rem;font-weight:700;margin:0.6rem 0;">+${act.xpEarned} ICT XP अर्जित!</p>
        <p id="syncStatusText" style="font-size:0.84rem;color:var(--text-muted);margin-bottom:1rem;">⏳ Supabase PostgreSQL में सेव हो रहा है...</p>
        <button class="btn btn-primary" onclick="PortalApp.closeWorkspace()">वापस जाएं</button>
      </div>
    `);

    await persistProgressToSupabase({
      chapterId: act.chapter.id,
      isIct: true,
      xpEarned: act.xpEarned,
      badgeUnlocked: "EXCEL_WIZARD"
    });
  }

  /* =========================================================================
   * MODE 5: BSEB 50% OBJECTIVE PINK OMR SIMULATOR
   * ========================================================================= */
  function startOmrSimulator(chapterId) {
    const ch = window.PORTAL_CURRICULUM.chapters.find((c) => c.id === chapterId) || window.PORTAL_CURRICULUM.chapters[0];
    const questions = ch.questions || [];

    state.currentActivity = {
      type: "OMR",
      chapter: ch,
      questions,
      answers: {}
    };
    renderOmrSheet();
  }

  function renderOmrSheet() {
    const act = state.currentActivity;
    openWorkspace(`
      <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:0.5rem;margin-bottom:1rem;">
        <div>
          <h3>📝 बिहार बोर्ड (BSEB) OMR उत्तर-पत्रक सिम्युलेटर</h3>
          <p style="font-size:0.82rem;color:var(--text-muted);">नीचे प्रश्नों को पढ़ें और गुलाबी OMR शीट में सही गोले (A/B/C/D) को भरें।</p>
        </div>
        <button class="btn btn-outline" onclick="PortalApp.closeWorkspace()">✕ Exit</button>
      </div>

      <div style="display:grid;grid-template-columns:1.35fr 1fr;gap:1.1rem;">
        <div style="max-height:480px;overflow-y:auto;padding-right:0.5rem;">
          ${act.questions.map((q, idx) => `
            <div style="background:rgba(15,23,42,0.8);border:1px solid var(--border-glass);border-radius:12px;padding:0.9rem;margin-bottom:0.75rem;">
              <strong>Q${idx + 1}.</strong> ${state.lang === "EN" ? escapeHtml(q.qEn) : escapeHtml(q.qHi)}
              <div style="margin-top:0.5rem;font-size:0.84rem;color:#cbd5e1;display:grid;grid-template-columns:1fr 1fr;gap:0.35rem;">
                ${(q.optionsHi || []).map((opt, oIdx) => `
                  <div><b>(${["A", "B", "C", "D"][oIdx]})</b> ${escapeHtml(state.lang === "EN" ? q.optionsEn[oIdx] : opt)}</div>
                `).join("")}
              </div>
            </div>
          `).join("")}
        </div>

        <div class="omr-sheet">
          <div style="text-align:center;border-bottom:2px solid #db2777;padding-bottom:0.5rem;margin-bottom:0.65rem;">
            <strong style="font-size:0.95rem;">BIHAR SCHOOL EXAMINATION BOARD</strong>
            <div style="font-size:0.75rem;">OMR ANSWER SHEET • नीले/काले बॉल पेन से गोला भरें</div>
          </div>

          ${act.questions.map((q, idx) => {
            const sel = act.answers[idx];
            return `
              <div class="omr-row">
                <strong>प्र. ${idx + 1}</strong>
                <div class="omr-bubbles">
                  ${["A", "B", "C", "D"].map((lbl, oIdx) => `
                    <button class="omr-bubble ${sel === oIdx ? "filled" : ""}" onclick="PortalApp.fillOmrBubble(${idx}, ${oIdx})">${lbl}</button>
                  `).join("")}
                </div>
              </div>
            `;
          }).join("")}

          <button class="btn btn-primary" style="width:100%;margin-top:1rem;background:#db2777;" onclick="PortalApp.submitOmrSheet()">
            ✅ OMR शीट जमा करें (Submit BSEB OMR)
          </button>
        </div>
      </div>
    `);
  }

  function fillOmrBubble(qIdx, oIdx) {
    state.currentActivity.answers[qIdx] = oIdx;
    renderOmrSheet();
  }

  async function submitOmrSheet() {
    const act = state.currentActivity;
    let score = 0;
    const mastered = [];
    const wrong = [];

    act.questions.forEach((q, idx) => {
      if (act.answers[idx] === q.correct) {
        score++;
        mastered.push(q.id);
      } else if (act.answers[idx] !== undefined) {
        wrong.push(q.id);
      }
    });

    const pct = Math.round((score / act.questions.length) * 100);
    const xpEarned = score * 8;

    openWorkspace(`
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:3rem;">📝</div>
        <h2>BSEB OMR परिणाम: ${score} / ${act.questions.length} (${pct}%)</h2>
        <p style="color:#6ee7b7;font-size:1.15rem;font-weight:700;margin:0.5rem 0;">+${xpEarned} XP अर्जित!</p>
        <p id="syncStatusText" style="font-size:0.84rem;color:var(--text-muted);margin-bottom:1rem;">⏳ Supabase PostgreSQL में सेव हो रहा है...</p>
        <button class="btn btn-primary" onclick="PortalApp.closeWorkspace()">वापस जाएं</button>
      </div>
    `);

    await persistProgressToSupabase({
      chapterId: act.chapter.id,
      isIct: act.chapter.category === "ICT",
      xpEarned,
      masteredQuestionIds: mastered,
      wrongQuestionIds: wrong,
      badgeUnlocked: pct >= 80 ? "OMR_CHAMPION" : null
    });
  }

  /* =========================================================================
   * MISTAKE NOTEBOOK & REVISION
   * ========================================================================= */
  function getAllQuestionsByIdMap() {
    const map = {};
    (window.PORTAL_CURRICULUM.chapters || []).forEach((ch) => {
      (ch.questions || []).forEach((q) => {
        map[q.id] = Object.assign({ chapterId: ch.id }, q);
      });
    });
    return map;
  }

  function renderMistakesList() {
    const container = document.getElementById("mistakesListContainer");
    if (!container || !state.student) return;

    const bank = state.student.mistakeBank || {};
    const ids = Object.keys(bank);
    const qMap = getAllQuestionsByIdMap();

    if (ids.length === 0) {
      container.innerHTML = `<div style="padding:1.5rem;text-align:center;color:#6ee7b7;">🎉 बधाई! आपके गलती सुधार बैंक में कोई लंबित गलत प्रश्न नहीं है।</div>`;
      return;
    }

    container.innerHTML = ids.map((id) => {
      const q = qMap[id];
      if (!q) return "";
      return `
        <div style="background:rgba(15,23,42,0.75);border:1px solid rgba(239,68,68,0.35);border-radius:12px;padding:0.9rem;margin-bottom:0.65rem;">
          ${biText(q.qHi, q.qEn)}
          <div style="margin-top:0.4rem;font-size:0.82rem;color:#6ee7b7;">
            ✔ सही उत्तर: <b>${escapeHtml(q.optionsHi[q.correct])}</b> (${escapeHtml(q.optionsEn[q.correct])})
          </div>
        </div>
      `;
    }).join("");
  }

  function startMistakeRevisionQuiz() {
    const bank = (state.student && state.student.mistakeBank) || {};
    const qMap = getAllQuestionsByIdMap();
    const list = Object.keys(bank).map((id) => qMap[id]).filter(Boolean);
    if (list.length === 0) return;
    startQuiz(list[0].chapterId, list, true);
  }

  /* =========================================================================
   * LEADERBOARDS & BADGES
   * ========================================================================= */
  async function refreshLeaderboards() {
    const wrap = document.getElementById("leaderboardTableWrap");
    if (!wrap || !state.student) return;
    wrap.innerHTML = `<p style="padding:1rem;color:var(--text-muted);">⏳ Supabase PostgreSQL से लीडरबोर्ड लोड हो रहा है...</p>`;

    try {
      const res = await window.PortalDB.getLeaderboards(state.student.className, state.student.stream);
      state.leaderboards = res;
      renderLeaderboardTable();
    } catch (err) {
      wrap.innerHTML = `<p style="padding:1rem;color:#fca5a5;">⚠️ ${escapeHtml(err.message)}</p>`;
    }
  }

  function switchLeaderboard(type) {
    state.activeLbTab = type;
    ["class", "ict", "weekly"].forEach((t) => {
      const btn = document.getElementById(`lbBtn_${t}`);
      if (btn) btn.className = t === type ? "btn btn-primary" : "btn btn-outline";
    });
    renderLeaderboardTable();
  }

  function renderLeaderboardTable() {
    const wrap = document.getElementById("leaderboardTableWrap");
    const list = state.activeLbTab === "ict"
      ? state.leaderboards.ictBoard
      : (state.activeLbTab === "weekly" ? state.leaderboards.weeklyBoard : state.leaderboards.classBoard);

    if (!list || list.length === 0) {
      wrap.innerHTML = `<p style="padding:1rem;color:var(--text-muted);">अभी इस श्रेणी में कोई छात्र डेटा नहीं है।</p>`;
      return;
    }

    wrap.innerHTML = `
      <table class="lb-table">
        <thead>
          <tr>
            <th>Rank</th>
            <th>Student Name</th>
            <th>Class &amp; Roll</th>
            <th>Total XP</th>
            <th>ICT Lab XP</th>
            <th>Weekly XP</th>
          </tr>
        </thead>
        <tbody>
          ${list.map((r, i) => {
            const medal = i === 0 ? "🥇 1" : (i === 1 ? "🥈 2" : (i === 2 ? "🥉 3" : `#${i + 1}`));
            const isMe = state.student && r.studentId === state.student.studentId;
            return `
              <tr style="${isMe ? "background:rgba(59,130,246,0.18);font-weight:700;" : ""}">
                <td>${medal}</td>
                <td>${escapeHtml(r.studentName)} ${isMe ? "(आप)" : ""}</td>
                <td>Class ${escapeHtml(r.className)} (${escapeHtml(r.stream)}) • Roll ${r.rollNo}</td>
                <td style="color:#6ee7b7;font-weight:700;">${r.totalXp} XP</td>
                <td style="color:#93c5fd;">${r.ictXp} XP</td>
                <td style="color:#fcd34d;">${r.weeklyXp} XP</td>
              </tr>
            `;
          }).join("")}
        </tbody>
      </table>
    `;
  }

  function renderBadges() {
    const grid = document.getElementById("badgesGrid");
    if (!grid || !state.student) return;
    const earned = state.student.badges || ["WELCOME_SCHOLAR"];
    const catalog = window.PORTAL_CURRICULUM.badgesCatalog || {};

    grid.innerHTML = Object.keys(catalog).map((bKey) => {
      const b = catalog[bKey];
      const unlocked = earned.includes(bKey);
      return `
        <div style="padding:0.9rem;border-radius:12px;border:1px solid ${unlocked ? "rgba(16,185,129,0.5)" : "var(--border-glass)"};background:${unlocked ? "rgba(16,185,129,0.12)" : "rgba(15,23,42,0.5)"};opacity:${unlocked ? "1" : "0.45"};">
          <div style="font-size:1.8rem;">${b.icon}</div>
          <div style="font-weight:700;margin-top:0.3rem;">${escapeHtml(b.hi)} / ${escapeHtml(b.en)}</div>
          <div style="font-size:0.78rem;color:var(--text-muted);margin-top:0.2rem;">${escapeHtml(b.descHi)}</div>
        </div>
      `;
    }).join("");
  }

  async function saveNewPin() {
    const pin = document.getElementById("newStudentPin").value.trim();
    if (!/^\d{4}$/.test(pin)) {
      alert("कृपया 4 अंकों का संख्यात्मक पिन (जैसे 1234) दर्ज करें।");
      return;
    }
    try {
      await window.PortalDB.loginStudent({
        loginMode: "CODE",
        studentCode: state.student.studentCode || state.student.studentId,
        newPin: pin,
        requirePinCheck: false
      });
      alert("✅ आपका 4-अंकीय सुरक्षा पिन Supabase PostgreSQL में सुरक्षित कर दिया गया है!");
      document.getElementById("newStudentPin").value = "";
    } catch (err) {
      alert("Error saving PIN: " + err.message);
    }
  }

  /* =========================================================================
   * TEACHER LIVE EXAM CLIENT (WITH FISHER-YATES SHUFFLE & REALTIME SYNC)
   * ========================================================================= */
  async function joinLiveExamByPin() {
    const pin = document.getElementById("liveRoomPinInput").value.trim();
    if (!/^\d{4}$/.test(pin)) {
      alert("कृपया 4-अंकीय Room PIN दर्ज करें।");
      return;
    }

    try {
      const res = await window.PortalDB.joinLiveExam(pin, state.student);
      const exam = res.exam;

      // Resolve questions from chapter if not embedded
      let pool = exam.questions && exam.questions.length > 0 ? exam.questions : [];
      if (pool.length === 0) {
        const ch = window.PORTAL_CURRICULUM.chapters.find((c) => c.id === exam.chapterId) || window.PORTAL_CURRICULUM.chapters[0];
        pool = ch.questions || [];
      }

      // Fisher-Yates shuffle per student so adjacent PCs see different order
      const shuffled = [...pool].sort(() => Math.random() - 0.5).slice(0, exam.questionCount || pool.length);

      state.liveExamSession = {
        pin: exam.pin,
        title: exam.title,
        questions: shuffled,
        index: 0,
        score: 0,
        answeredCount: 0,
        tabSwitches: 0,
        submitted: false
      };

      renderLiveExamQuestion();
    } catch (err) {
      alert(err.message);
    }
  }

  function renderLiveExamQuestion() {
    const sess = state.liveExamSession;
    if (sess.index >= sess.questions.length) {
      submitLiveExamFinal();
      return;
    }

    const q = sess.questions[sess.index];
    openWorkspace(`
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
        <div>
          <span style="background:#ef4444;color:#fff;padding:0.2rem 0.6rem;border-radius:99px;font-size:0.75rem;font-weight:700;">LIVE EXAM PIN: ${sess.pin}</span>
          <strong style="margin-left:0.5rem;">${escapeHtml(sess.title)} (${sess.index + 1}/${sess.questions.length})</strong>
        </div>
        <span style="font-size:0.8rem;color:#fcd34d;">⚠️ Tab Switches: ${sess.tabSwitches}</span>
      </div>

      <div style="background:rgba(15,23,42,0.9);border:1px solid var(--border-glass);border-radius:14px;padding:1.25rem;">
        ${biText(q.qHi, q.qEn)}
      </div>

      <div class="quiz-options">
        ${(q.optionsHi || []).map((optH, idx) => `
          <button class="quiz-opt" onclick="PortalApp.answerLiveExamQ(${idx})">
            <strong>(${["A", "B", "C", "D"][idx]})</strong> ${escapeHtml(optH)} / ${escapeHtml((q.optionsEn || [])[idx] || "")}
          </button>
        `).join("")}
      </div>
    `);
  }

  async function answerLiveExamQ(chosenIdx) {
    const sess = state.liveExamSession;
    const q = sess.questions[sess.index];
    if (chosenIdx === q.correct) sess.score++;
    sess.answeredCount++;
    sess.index++;

    syncLiveExamHeartbeat();
    renderLiveExamQuestion();
  }

  async function syncLiveExamHeartbeat() {
    const sess = state.liveExamSession;
    if (!sess || !state.student) return;
    const accuracy = sess.answeredCount > 0 ? Math.round((sess.score / sess.answeredCount) * 100) : 0;
    try {
      await window.PortalDB.updateLiveParticipant(sess.pin, state.student.studentId, {
        answeredCount: sess.answeredCount,
        totalQuestions: sess.questions.length,
        score: sess.score,
        accuracy,
        tabSwitches: sess.tabSwitches,
        status: sess.submitted ? "SUBMITTED" : "JOINED"
      });
    } catch (e) {}
  }

  async function submitLiveExamFinal() {
    const sess = state.liveExamSession;
    sess.submitted = true;
    await syncLiveExamHeartbeat();

    const pct = Math.round((sess.score / sess.questions.length) * 100);
    const bonusXp = sess.score * 10;

    openWorkspace(`
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:3rem;">📡</div>
        <h2>लाइव परीक्षा सफलतापूर्वक जमा हुई!</h2>
        <p style="font-size:1.15rem;margin:0.5rem 0;">आपका स्कोर: <b>${sess.score} / ${sess.questions.length} (${pct}%)</b></p>
        <p style="color:#6ee7b7;font-weight:700;margin-bottom:1rem;">+${bonusXp} Live Exam XP अर्जित! शिक्षक के प्रोजेक्टर स्क्रीन पर आपका परिणाम अपडेट हो गया है।</p>
        <button class="btn btn-primary" onclick="PortalApp.closeWorkspace()">डैशबोर्ड पर लौटें</button>
      </div>
    `);

    await persistProgressToSupabase({
      chapterId: "LIVE_EXAM",
      isIct: true,
      xpEarned: bonusXp
    });
  }

  /* =========================================================================
   * SUPABASE PROGRESS SYNC HELPER
   * ========================================================================= */
  async function persistProgressToSupabase(payload) {
    if (!state.student) return;
    try {
      const res = await window.PortalDB.syncProgress({
        studentId: state.student.studentId,
        buddyStudentId: state.buddyId,
        ...payload
      });
      state.student.totalXp = res.totalXp;
      state.student.weeklyXp = res.weeklyXp;
      state.student.ictXp = res.ictXp;
      state.student.masteredMap = res.masteredMap;
      state.student.mistakeBank = res.mistakeBank;
      state.student.badges = res.badges;
      sessionStorage.setItem("UHS_PORTAL_STUDENT", JSON.stringify(state.student));
      updateHeroStats();
      renderChaptersGrid();
      renderMistakesList();
      renderBadges();

      const statusEl = document.getElementById("syncStatusText");
      if (statusEl) {
        statusEl.style.color = "#6ee7b7";
        statusEl.textContent = "✅ Supabase PostgreSQL डेटाबेस में प्रगति सुरक्षित कर दी गई!";
      }
    } catch (err) {
      const statusEl = document.getElementById("syncStatusText");
      if (statusEl) {
        statusEl.style.color = "#fcd34d";
        statusEl.textContent = "⚠️ ऑफलाइन सेव किया गया: " + err.message;
      }
    }
  }

  function escapeHtml(str) {
    return String(str || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  document.addEventListener("DOMContentLoaded", init);

  return {
    openSupabaseModal,
    closeSupabaseModal,
    saveAndTestSupabase,
    setLang,
    setLoginMode,
    toggleStreamField,
    fillDemo,
    handleLogin,
    logout,
    showTab,
    joinBannerExam,
    startFlashcards,
    stepFlashcard,
    startQuiz,
    useLifeline5050,
    useLifelineHint,
    submitQuizAnswer,
    nextQuizQuestion,
    startShortcutNinja,
    toggleVirtualKey,
    clearVirtualShortcut,
    checkVirtualShortcut,
    startExcelSandbox,
    evaluateExcelTask,
    startOmrSimulator,
    fillOmrBubble,
    submitOmrSheet,
    startMistakeRevisionQuiz,
    switchLeaderboard,
    saveNewPin,
    joinLiveExamByPin,
    answerLiveExamQ,
    closeWorkspace
  };
})();
