import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  applySessionCookie,
  createSession,
  hashPassword,
  jsonNoStore,
  requireRole,
  revokeAllPrincipalSessions,
  validateCsrf,
  verifyPassword,
} from "@/lib/auth";

const changePasswordSchema = z.object({
  currentPassword: z.string().max(72).optional(),
  newPassword: z.string().min(8).max(72),
});

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(
    ["teacher", "school_admin", "super_admin"],
    request
  );
  if (!auth.ok) return auth.response;

  const { session } = auth;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore(
      {
        error: "Invalid request payload.",
        errorHi: "अनुरोध सही नहीं है।",
      },
      { status: 400 }
    );
  }

  const parsed = changePasswordSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "New password must be at least 8 characters long.",
        errorHi: "नया पासवर्ड कम से कम 8 अक्षरों का होना चाहिए।",
      },
      { status: 400 }
    );
  }

  const { currentPassword, newPassword } = parsed.data;
  if (Buffer.byteLength(newPassword, "utf8") > 72) {
    return jsonNoStore(
      {
        error: "Password is too long (maximum 72 bytes).",
        errorHi: "पासवर्ड बहुत लंबा है।",
      },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();

  if (session.role === "super_admin") {
    if (!currentPassword) {
      return jsonNoStore(
        { error: "Current password is required." },
        { status: 400 }
      );
    }

    const { data: admin } = await supabase
      .from("super_admins")
      .select("id, password_hash")
      .eq("id", session.principalId)
      .maybeSingle();

    if (!admin || !(await verifyPassword(currentPassword, admin.password_hash))) {
      return jsonNoStore(
        { error: "Current password is incorrect." },
        { status: 401 }
      );
    }

    const nextHash = await hashPassword(newPassword);
    await revokeAllPrincipalSessions(admin.id, "super_admin");

    const { data: updatedAdmin, error: updateErr } = await supabase
      .from("super_admins")
      .update({ password_hash: nextHash })
      .eq("id", admin.id)
      .select("token_version")
      .single();

    if (updateErr || !updatedAdmin) {
      return jsonNoStore(
        { error: "Unable to update password right now." },
        { status: 500 }
      );
    }

    await supabase.from("audit_logs").insert({
      school_udise: null,
      actor_role: "super_admin",
      actor_id: admin.id,
      action: "PASSWORD_CHANGED",
      target_type: "super_admin",
      target_id: admin.id,
      meta_json: {},
    });

    const freshSession = await createSession({
      role: "super_admin",
      principalId: admin.id,
      schoolUdise: null,
      activeWorkspace: session.activeWorkspace ?? "SUPER_ADMIN",
      tokenVersion: updatedAdmin.token_version,
      userAgent: request.headers.get("user-agent"),
    });

    return applySessionCookie(
      jsonNoStore({ ok: true }),
      freshSession.rawToken,
      freshSession.expiresAt
    );
  }

  // Teacher or School Admin password change
  const { data: teacher } = await supabase
    .from("teachers")
    .select(
      "id, teacher_code, password_hash, must_change_password, reset_code_hash, reset_code_expires_at"
    )
    .eq("id", session.principalId)
    .maybeSingle();

  if (!teacher) {
    return jsonNoStore({ error: "Account not found." }, { status: 404 });
  }

  if (
    newPassword.trim().toLowerCase() === teacher.teacher_code.trim().toLowerCase()
  ) {
    return jsonNoStore(
      {
        error: "New password cannot be identical to your Teacher ID.",
        errorHi: "नया पासवर्ड आपकी शिक्षक ID जैसा नहीं हो सकता।",
      },
      { status: 400 }
    );
  }

  // Require current password verification unless this is an authenticated forced reset session
  if (!teacher.must_change_password || currentPassword) {
    if (!currentPassword) {
      return jsonNoStore(
        {
          error: "Please enter your current password.",
          errorHi: "कृपया अपना वर्तमान पासवर्ड दर्ज करें।",
        },
        { status: 400 }
      );
    }

    let currentValid = await verifyPassword(currentPassword, teacher.password_hash);
    if (
      !currentValid &&
      teacher.reset_code_hash &&
      teacher.reset_code_expires_at &&
      new Date(teacher.reset_code_expires_at).getTime() > Date.now()
    ) {
      currentValid = await verifyPassword(
        currentPassword.trim().toUpperCase(),
        teacher.reset_code_hash
      );
    }

    if (!currentValid) {
      return jsonNoStore(
        {
          error: "Current password is incorrect.",
          errorHi: "वर्तमान पासवर्ड सही नहीं है।",
        },
        { status: 401 }
      );
    }
  }

  const nextHash = await hashPassword(newPassword);
  await revokeAllPrincipalSessions(teacher.id, session.role);

  const { data: updatedTeacher, error: updateErr } = await supabase
    .from("teachers")
    .update({
      password_hash: nextHash,
      must_change_password: false,
      reset_code_hash: null,
      reset_code_expires_at: null,
    })
    .eq("id", teacher.id)
    .select("token_version")
    .single();

  if (updateErr || !updatedTeacher) {
    return jsonNoStore(
      {
        error: "Unable to update password right now.",
        errorHi: "अभी पासवर्ड अपडेट नहीं हो सका। कृपया पुनः प्रयास करें।",
      },
      { status: 500 }
    );
  }

  await supabase.from("audit_logs").insert({
    school_udise: session.schoolUdise,
    actor_role: session.role,
    actor_id: teacher.id,
    action: "PASSWORD_CHANGED",
    target_type: "teacher",
    target_id: teacher.id,
    meta_json: { wasForced: teacher.must_change_password },
  });

  const freshSession = await createSession({
    role: session.role,
    principalId: teacher.id,
    schoolUdise: session.schoolUdise,
    activeWorkspace: session.activeWorkspace,
    tokenVersion: updatedTeacher.token_version,
    userAgent: request.headers.get("user-agent"),
  });

  const teacherRedirect =
    session.role === "school_admin"
      ? "/school"
      : session.teacher?.subjectsConfigured
      ? "/teacher"
      : "/teacher/onboarding";

  return applySessionCookie(
    jsonNoStore({
      ok: true,
      redirectTo: teacherRedirect,
    }),
    freshSession.rawToken,
    freshSession.expiresAt
  );
}
