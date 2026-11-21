import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  applySessionCookie,
  checkAuthRateLimit,
  clearAccountRateLimit,
  constantTimeEqual,
  createSession,
  extractClientIp,
  hashPassword,
  jsonNoStore,
  recordAuthFailure,
  revokeAllPrincipalSessions,
  validateCsrf,
  verifyPassword,
  verifyTurnstileToken,
} from "@/lib/auth";

const activateSchema = z.object({
  schoolUdise: z.string().trim().regex(/^\d{11}$/),
  teacherCode: z.string().trim().min(4).max(32),
  verificationMethod: z.enum(["MOBILE_LAST4", "ACTIVATION_CODE"]),
  verificationValue: z.string().trim().min(4).max(16),
  newPassword: z.string().min(8).max(72),
  portal: z.enum(["teacher", "school_admin"]).default("teacher"),
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

  const parsed = activateSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error:
          "Please fill all fields. Password must be at least 8 characters long.",
        errorHi:
          "कृपया सभी जानकारी सही से भरें। नया पासवर्ड कम से कम 8 अक्षरों का होना चाहिए।",
      },
      { status: 400 }
    );
  }

  const {
    schoolUdise,
    teacherCode,
    verificationMethod,
    verificationValue,
    newPassword,
    portal,
    turnstileToken,
  } = parsed.data;

  if (Buffer.byteLength(newPassword, "utf8") > 72) {
    return jsonNoStore(
      {
        error: "Password is too long (maximum 72 bytes).",
        errorHi: "पासवर्ड बहुत लंबा है। कृपया छोटा पासवर्ड चुनें।",
      },
      { status: 400 }
    );
  }

  if (newPassword.trim().toLowerCase() === teacherCode.trim().toLowerCase()) {
    return jsonNoStore(
      {
        error: "Your new password cannot be the same as your Teacher ID.",
        errorHi: "नया पासवर्ड आपकी शिक्षक ID जैसा नहीं हो सकता। कोई अलग पासवर्ड चुनें।",
      },
      { status: 400 }
    );
  }

  const clientIp = extractClientIp(request);
  const accountKey = `${schoolUdise}:${teacherCode}`;

  const rl = await checkAuthRateLimit({
    scope: "teacher-activate",
    accountKey,
    clientIp,
  });

  if (!rl.allowed) {
    return jsonNoStore(
      {
        error: `Too many activation attempts. Try again in ${Math.ceil(rl.retryAfterSec / 60)} minutes.`,
        errorHi: `कई गलत प्रयास हुए हैं। कृपया ${Math.ceil(rl.retryAfterSec / 60)} मिनट बाद प्रयास करें।`,
        retryAfterSec: rl.retryAfterSec,
      },
      { status: 429 }
    );
  }

  if (portal === "school_admin" || rl.requiresTurnstile) {
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
        "id, teacher_code, full_name, teacher_title, mobile_last4, must_change_password, activation_code_hash, reset_code_hash, token_version"
      )
      .eq("teacher_code", teacherCode)
      .maybeSingle(),
  ]);

  if (!school || school.status !== "ACTIVE" || !teacher) {
    const fail = await recordAuthFailure({
      scope: "teacher-activate",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        requiresTurnstile: fail.requiresTurnstile,
        error: "Verification failed. Please check your School UDISE, Teacher ID, and code.",
        errorHi: "सत्यापन सफल नहीं हुआ। कृपया UDISE, शिक्षक ID और विवरण दोबारा जांचें।",
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

  if (!posting || (portal === "school_admin" && !posting.is_school_admin)) {
    const fail = await recordAuthFailure({
      scope: "teacher-activate",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        requiresTurnstile: fail.requiresTurnstile,
        error: "Verification failed. Please check your School UDISE, Teacher ID, and code.",
        errorHi: "सत्यापन सफल नहीं हुआ। कृपया UDISE, शिक्षक ID और विवरण दोबारा जांचें।",
      },
      { status: 401 }
    );
  }

  // CRITICAL SECURITY INVARIANT:
  // 1. Block activation once already activated (`must_change_password === false`).
  // 2. Block activation via mobile_last4 / activation code whenever a School Admin has
  //    issued a password reset (`reset_code_hash !== null`), preventing reset-code bypass!
  if (teacher.reset_code_hash !== null) {
    return jsonNoStore(
      {
        alreadyActivated: true,
        error:
          "A password reset code has been issued for this account. Please sign in on the Sign In tab using the 8-character reset code from your School Admin.",
        errorHi:
          "इस खाते के लिए विद्यालय व्यवस्थापक द्वारा रीसेट कोड जारी किया गया है। कृपया लॉगिन टैब में उस 8-अंकीय रीसेट कोड से प्रवेश करें।",
      },
      { status: 409 }
    );
  }

  if (!teacher.must_change_password) {
    return jsonNoStore(
      {
        alreadyActivated: true,
        error:
          "This account is already activated. Please sign in with your password or request a reset code from your School Admin.",
        errorHi:
          "यह खाता पहले ही सक्रिय (Activated) है। कृपया अपने पासवर्ड से लॉगिन करें या विद्यालय व्यवस्थापक से रीसेट कोड प्राप्त करें।",
      },
      { status: 409 }
    );
  }

  const cleanVerification = verificationValue.replace(/\s+/g, "");
  let verified = false;

  if (verificationMethod === "MOBILE_LAST4") {
    if (/^\d{4}$/.test(cleanVerification) && teacher.mobile_last4) {
      verified = constantTimeEqual(cleanVerification, teacher.mobile_last4);
    }
  } else {
    if (teacher.activation_code_hash) {
      verified = await verifyPassword(cleanVerification, teacher.activation_code_hash);
    }
  }

  if (!verified) {
    const fail = await recordAuthFailure({
      scope: "teacher-activate",
      accountKey,
      clientIp,
    });
    return jsonNoStore(
      {
        requiresTurnstile: fail.requiresTurnstile,
        error:
          verificationMethod === "MOBILE_LAST4"
            ? "The last 4 digits of your registered mobile number did not match."
            : "The activation code did not match.",
        errorHi:
          verificationMethod === "MOBILE_LAST4"
            ? "पंजीकृत मोबाइल नंबर के अंतिम 4 अंक मेल नहीं खाए।"
            : "एक्टिवेशन कोड मेल नहीं खाया।",
      },
      { status: 401 }
    );
  }

  const passwordHash = await hashPassword(newPassword);
  const role = portal === "school_admin" ? "school_admin" : "teacher";

  // Atomically claim activation ONLY if still unactivated and not under an admin reset
  const { data: claimedTeacher, error: updateErr } = await supabase
    .from("teachers")
    .update({
      password_hash: passwordHash,
      must_change_password: false,
      activation_code_hash: null,
      reset_code_hash: null,
      reset_code_expires_at: null,
    })
    .eq("id", teacher.id)
    .eq("must_change_password", true)
    .is("reset_code_hash", null)
    .select("id")
    .maybeSingle();

  if (updateErr) {
    return jsonNoStore(
      {
        error: "Unable to complete activation right now. Please try again.",
        errorHi: "अभी खाता सक्रिय नहीं हो सका। कृपया थोड़ी देर बाद प्रयास करें।",
      },
      { status: 500 }
    );
  }

  if (!claimedTeacher) {
    return jsonNoStore(
      {
        alreadyActivated: true,
        error:
          "This account was already activated or reset. Please sign in with your password.",
        errorHi:
          "यह खाता पहले ही सक्रिय या रीसेट हो चुका है। कृपया लॉगिन टैब से प्रवेश करें।",
      },
      { status: 409 }
    );
  }

  // Revoke any prior sessions and bump token_version, then read live token_version
  await revokeAllPrincipalSessions(teacher.id, role);

  const { data: updatedTeacher, error: versionErr } = await supabase
    .from("teachers")
    .select("token_version")
    .eq("id", teacher.id)
    .single();

  if (versionErr || !updatedTeacher) {
    return jsonNoStore(
      {
        error: "Unable to complete activation right now. Please try again.",
        errorHi: "अभी खाता सक्रिय नहीं हो सका। कृपया थोड़ी देर बाद प्रयास करें।",
      },
      { status: 500 }
    );
  }

  await clearAccountRateLimit("teacher-activate", accountKey);

  await supabase.from("audit_logs").insert({
    school_udise: school.udise_code,
    actor_role: role,
    actor_id: teacher.id,
    action: "TEACHER_ACCOUNT_ACTIVATED",
    target_type: "teacher",
    target_id: teacher.id,
    meta_json: { verificationMethod, portal },
  });

  const session = await createSession({
    role,
    principalId: teacher.id,
    schoolUdise: school.udise_code,
    activeWorkspace: role === "school_admin" ? "SCHOOL_ADMIN" : "TEACHER",
    tokenVersion: updatedTeacher.token_version,
    userAgent: request.headers.get("user-agent"),
  });

  const redirectTo =
    role === "school_admin"
      ? "/school"
      : posting.subjects_configured
      ? "/teacher"
      : "/teacher/onboarding";

  const response = jsonNoStore({
    ok: true,
    redirectTo,
    teacher: {
      id: teacher.id,
      teacherCode: teacher.teacher_code,
      fullName: teacher.full_name,
      isSchoolAdmin: posting.is_school_admin,
      schoolUdise: school.udise_code,
      schoolName: school.school_name,
    },
  });

  return applySessionCookie(response, session.rawToken, session.expiresAt);
}
