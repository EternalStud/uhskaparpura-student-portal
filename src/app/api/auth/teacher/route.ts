import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  applySessionCookie,
  checkAuthRateLimit,
  clearAccountRateLimit,
  createSession,
  extractClientIp,
  jsonNoStore,
  recordAuthFailure,
  recordIpAttempt,
  validateCsrf,
  verifyPassword,
  verifyTurnstileToken,
} from "@/lib/auth";

const teacherLoginSchema = z.object({
  schoolUdise: z.string().trim().regex(/^\d{11}$/),
  teacherCode: z.string().trim().min(4).max(32),
  password: z.string().min(1).max(72),
  turnstileToken: z.string().trim().max(2048).optional(),
});

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore(
      {
        error: "Invalid request payload.",
        errorHi: "अनुरोध सही नहीं है। कृपया दोबारा प्रयास करें।",
      },
      { status: 400 }
    );
  }

  const parsed = teacherLoginSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please enter a valid 11-digit School UDISE, Teacher ID, and Password.",
        errorHi: "कृपया सही 11-अंकीय UDISE कोड, शिक्षक ID और पासवर्ड दर्ज करें।",
      },
      { status: 400 }
    );
  }

  const { schoolUdise, teacherCode, password, turnstileToken } = parsed.data;
  const clientIp = extractClientIp(request);
  const accountKey = `${schoolUdise}:${teacherCode}`;

  const rl = await checkAuthRateLimit({
    scope: "teacher-login",
    accountKey,
    clientIp,
  });

  if (!rl.allowed) {
    return jsonNoStore(
      {
        error: `Too many failed attempts. Please wait ${Math.ceil(rl.retryAfterSec / 60)} minutes.`,
        errorHi: `कई गलत प्रयास हुए हैं। कृपया ${Math.ceil(rl.retryAfterSec / 60)} मिनट बाद प्रयास करें।`,
        retryAfterSec: rl.retryAfterSec,
      },
      { status: 429 }
    );
  }

  if (rl.requiresTurnstile) {
    const turnstile = await verifyTurnstileToken(turnstileToken, clientIp);
    if (!turnstile.ok) {
      return jsonNoStore(
        {
          requiresTurnstile: true,
          error: "Please complete the security check below.",
          errorHi: "कृपया नीचे दिया गया सुरक्षा सत्यापन पूरा करें।",
        },
        { status: 403 }
      );
    }
  }

  const supabase = getSupabaseAdmin();

  const [{ data: school }, { data: teacher }] = await Promise.all([
    supabase
      .from("schools")
      .select("udise_code, school_name, status")
      .eq("udise_code", schoolUdise)
      .maybeSingle(),
    supabase
      .from("teachers")
      .select(
        "id, teacher_code, full_name, teacher_title, mobile_last4, password_hash, must_change_password, activation_code_hash, reset_code_hash, reset_code_expires_at, token_version"
      )
      .eq("teacher_code", teacherCode)
      .maybeSingle(),
  ]);

  if (!school || school.status !== "ACTIVE" || !teacher) {
    const fail = await recordAuthFailure({
      scope: "teacher-login",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        requiresTurnstile: fail.requiresTurnstile,
        error: "Invalid School UDISE, Teacher ID, or Password.",
        errorHi: "विद्यालय UDISE, शिक्षक ID या पासवर्ड सही नहीं है।",
      },
      { status: 401 }
    );
  }

  const { data: posting } = await supabase
    .from("school_teachers")
    .select("is_school_admin, is_active, subjects_configured")
    .eq("school_udise", school.udise_code)
    .eq("teacher_id", teacher.id)
    .eq("is_active", true)
    .maybeSingle();

  if (!posting) {
    const fail = await recordAuthFailure({
      scope: "teacher-login",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        requiresTurnstile: fail.requiresTurnstile,
        error: "Invalid School UDISE, Teacher ID, or Password.",
        errorHi: "विद्यालय UDISE, शिक्षक ID या पासवर्ड सही नहीं है।",
      },
      { status: 401 }
    );
  }

  // Check if the teacher is using an admin-issued non-expired reset code
  let verifiedViaResetCode = false;
  if (
    teacher.reset_code_hash &&
    teacher.reset_code_expires_at &&
    new Date(teacher.reset_code_expires_at).getTime() > Date.now()
  ) {
    verifiedViaResetCode = await verifyPassword(
      password.trim().toUpperCase(),
      teacher.reset_code_hash
    );
  }

  const verifiedViaPassword = verifiedViaResetCode
    ? false
    : await verifyPassword(password, teacher.password_hash);

  // If teacher has never activated and entered default Teacher ID (or any password while unactivated without reset code),
  // require first-time verification via last-4 mobile digits or 6-digit activation code.
  if (
    teacher.must_change_password &&
    !verifiedViaResetCode &&
    (password.trim() === teacher.teacher_code || verifiedViaPassword)
  ) {
    await recordIpAttempt("teacher-login", clientIp);
    return jsonNoStore(
      {
        ok: false,
        requiresActivation: true,
        hasMobileLast4: Boolean(teacher.mobile_last4),
        error:
          "First-time sign-in requires account activation using the last 4 digits of your registered mobile number or your school activation code.",
        errorHi:
          "पहली बार लॉगिन करने के लिए अपने पंजीकृत मोबाइल नंबर के अंतिम 4 अंक या स्कूल एक्टिवेशन कोड से खाता सक्रिय करें।",
      },
      { status: 200 }
    );
  }

  if (!verifiedViaResetCode && !verifiedViaPassword) {
    const fail = await recordAuthFailure({
      scope: "teacher-login",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        requiresTurnstile: fail.requiresTurnstile,
        error: "Invalid School UDISE, Teacher ID, or Password.",
        errorHi: "विद्यालय UDISE, शिक्षक ID या पासवर्ड सही नहीं है।",
      },
      { status: 401 }
    );
  }

  await clearAccountRateLimit("teacher-login", accountKey);

  const session = await createSession({
    role: "teacher",
    principalId: teacher.id,
    schoolUdise: school.udise_code,
    activeWorkspace: "TEACHER",
    tokenVersion: teacher.token_version,
    userAgent: request.headers.get("user-agent"),
  });

  const mustChangePassword = verifiedViaResetCode || teacher.must_change_password;

  const redirectTo = posting.subjects_configured
    ? "/teacher"
    : "/teacher/onboarding";

  const response = jsonNoStore({
    ok: true,
    mustChangePassword,
    redirectTo,
    teacher: {
      id: teacher.id,
      teacherCode: teacher.teacher_code,
      fullName: teacher.full_name,
      teacherTitle: teacher.teacher_title,
      isSchoolAdmin: posting.is_school_admin,
      subjectsConfigured: posting.subjects_configured,
      schoolUdise: school.udise_code,
      schoolName: school.school_name,
    },
  });

  return applySessionCookie(response, session.rawToken, session.expiresAt);
}
