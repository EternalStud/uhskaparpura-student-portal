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

const schoolAdminLoginSchema = z.object({
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

  const parsed = schoolAdminLoginSchema.safeParse(body);
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

  // School Admin login ALWAYS requires Cloudflare Turnstile verification
  const turnstile = await verifyTurnstileToken(turnstileToken, clientIp);
  if (!turnstile.ok) {
    return jsonNoStore(
      {
        requiresTurnstile: true,
        error: "Security verification failed. Please complete the check and try again.",
        errorHi: "सुरक्षा सत्यापन पूरा नहीं हुआ। कृपया सत्यापन पूरा करके दोबारा प्रयास करें।",
      },
      { status: 403 }
    );
  }

  const rl = await checkAuthRateLimit({
    scope: "school-admin-login",
    accountKey,
    clientIp,
  });

  if (!rl.allowed) {
    return jsonNoStore(
      {
        error: `Too many failed attempts. Please try again in ${Math.ceil(rl.retryAfterSec / 60)} minutes.`,
        errorHi: `कई गलत प्रयास हुए हैं। कृपया ${Math.ceil(rl.retryAfterSec / 60)} मिनट बाद प्रयास करें।`,
        retryAfterSec: rl.retryAfterSec,
      },
      { status: 429 }
    );
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
        "id, teacher_code, full_name, teacher_title, mobile_last4, password_hash, must_change_password, reset_code_hash, reset_code_expires_at, token_version"
      )
      .eq("teacher_code", teacherCode)
      .maybeSingle(),
  ]);

  if (!school || school.status !== "ACTIVE" || !teacher) {
    await recordAuthFailure({
      scope: "school-admin-login",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        error: "Invalid School Admin credentials.",
        errorHi: "विद्यालय व्यवस्थापक (School Admin) का विवरण सही नहीं है।",
      },
      { status: 401 }
    );
  }

  const { data: posting } = await supabase
    .from("school_teachers")
    .select("is_school_admin, is_active")
    .eq("school_udise", school.udise_code)
    .eq("teacher_id", teacher.id)
    .eq("is_active", true)
    .eq("is_school_admin", true)
    .maybeSingle();

  if (!posting) {
    await recordAuthFailure({
      scope: "school-admin-login",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        error: "Invalid School Admin credentials.",
        errorHi: "विद्यालय व्यवस्थापक (School Admin) का विवरण सही नहीं है।",
      },
      { status: 401 }
    );
  }

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

  if (
    teacher.must_change_password &&
    !verifiedViaResetCode &&
    (password.trim() === teacher.teacher_code || verifiedViaPassword)
  ) {
    await recordIpAttempt("school-admin-login", clientIp);
    return jsonNoStore(
      {
        ok: false,
        requiresActivation: true,
        hasMobileLast4: Boolean(teacher.mobile_last4),
        error:
          "Please activate your School Admin account first using the last 4 digits of your registered mobile number or your activation code.",
        errorHi:
          "कृपया पहली बार लॉगिन से पहले अपने पंजीकृत मोबाइल के अंतिम 4 अंक या एक्टिवेशन कोड से खाता सक्रिय करें।",
      },
      { status: 200 }
    );
  }

  if (!verifiedViaResetCode && !verifiedViaPassword) {
    await recordAuthFailure({
      scope: "school-admin-login",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        error: "Invalid School Admin credentials.",
        errorHi: "विद्यालय व्यवस्थापक (School Admin) का विवरण सही नहीं है।",
      },
      { status: 401 }
    );
  }

  await clearAccountRateLimit("school-admin-login", accountKey);

  const session = await createSession({
    role: "school_admin",
    principalId: teacher.id,
    schoolUdise: school.udise_code,
    activeWorkspace: "SCHOOL_ADMIN",
    tokenVersion: teacher.token_version,
    userAgent: request.headers.get("user-agent"),
  });

  await supabase.from("audit_logs").insert({
    school_udise: school.udise_code,
    actor_role: "school_admin",
    actor_id: teacher.id,
    action: "SCHOOL_ADMIN_LOGIN",
    target_type: "school",
    target_id: school.udise_code,
    meta_json: { viaResetCode: verifiedViaResetCode },
  });

  const mustChangePassword = verifiedViaResetCode || teacher.must_change_password;

  const response = jsonNoStore({
    ok: true,
    mustChangePassword,
    redirectTo: "/school",
    teacher: {
      id: teacher.id,
      teacherCode: teacher.teacher_code,
      fullName: teacher.full_name,
      teacherTitle: teacher.teacher_title,
      isSchoolAdmin: true,
      schoolUdise: school.udise_code,
      schoolName: school.school_name,
    },
  });

  return applySessionCookie(response, session.rawToken, session.expiresAt);
}
