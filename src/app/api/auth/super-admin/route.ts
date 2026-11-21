import { authenticator } from "otplib";
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
  validateCsrf,
  verifyPassword,
  verifyTurnstileToken,
} from "@/lib/auth";

const superAdminLoginSchema = z.object({
  email: z.string().trim().email().max(160),
  password: z.string().min(1).max(72),
  totpCode: z.string().trim().max(32).optional(),
  turnstileToken: z.string().trim().max(2048).optional(),
});

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid request payload." }, { status: 400 });
  }

  const parsed = superAdminLoginSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: "Please enter a valid email and password." },
      { status: 400 }
    );
  }

  const email = parsed.data.email.toLowerCase();
  const { password, totpCode, turnstileToken } = parsed.data;
  const clientIp = extractClientIp(request);

  // Super Admin login ALWAYS requires Cloudflare Turnstile verification
  const turnstile = await verifyTurnstileToken(turnstileToken, clientIp);
  if (!turnstile.ok) {
    return jsonNoStore(
      {
        requiresTurnstile: true,
        error: "Security verification failed. Please complete the check and try again.",
      },
      { status: 403 }
    );
  }

  const rl = await checkAuthRateLimit({
    scope: "super-admin-login",
    accountKey: email,
    clientIp,
  });

  if (!rl.allowed) {
    return jsonNoStore(
      {
        error: `Too many failed attempts. Try again in ${Math.ceil(rl.retryAfterSec / 60)} minutes.`,
        retryAfterSec: rl.retryAfterSec,
      },
      { status: 429 }
    );
  }

  const supabase = getSupabaseAdmin();
  const { data: admin } = await supabase
    .from("super_admins")
    .select(
      "id, email, full_name, password_hash, totp_secret, totp_enabled, recovery_codes_hash, is_active, token_version"
    )
    .eq("email", email)
    .maybeSingle();

  const passwordValid =
    admin && admin.is_active
      ? await verifyPassword(password, admin.password_hash)
      : false;

  if (!admin || !admin.is_active || !passwordValid) {
    await recordAuthFailure({
      scope: "super-admin-login",
      accountKey: email,
      clientIp,
    });
    return jsonNoStore({ error: "Invalid credentials." }, { status: 401 });
  }

  // Optional TOTP 2FA enforcement when enabled on the account
  if (admin.totp_enabled && admin.totp_secret) {
    const cleanCode = (totpCode || "").replace(/\s+/g, "");
    if (!cleanCode) {
      return jsonNoStore(
        {
          ok: false,
          requiresTotp: true,
          message: "Enter the 6-digit authenticator code to continue.",
        },
        { status: 200 }
      );
    }

    let totpOk = false;
    if (/^\d{6}$/.test(cleanCode)) {
      totpOk = authenticator.verify({
        token: cleanCode,
        secret: admin.totp_secret,
      });
    }

    // Fallback: one-time hashed recovery code
    let usedRecoveryIndex = -1;
    if (!totpOk && Array.isArray(admin.recovery_codes_hash)) {
      for (let i = 0; i < admin.recovery_codes_hash.length; i += 1) {
        const hash = admin.recovery_codes_hash[i];
        if (await verifyPassword(cleanCode, hash)) {
          totpOk = true;
          usedRecoveryIndex = i;
          break;
        }
      }
    }

    if (!totpOk) {
      await recordAuthFailure({
        scope: "super-admin-login",
        accountKey: email,
        clientIp,
      });
      return jsonNoStore(
        {
          requiresTotp: true,
          error: "Invalid authenticator or recovery code.",
        },
        { status: 401 }
      );
    }

    // Consume one-time recovery code immediately
    if (usedRecoveryIndex >= 0 && Array.isArray(admin.recovery_codes_hash)) {
      const remaining = admin.recovery_codes_hash.filter(
        (_item, idx) => idx !== usedRecoveryIndex
      );
      await supabase
        .from("super_admins")
        .update({ recovery_codes_hash: remaining })
        .eq("id", admin.id);
    }
  }

  await clearAccountRateLimit("super-admin-login", email);

  const session = await createSession({
    role: "super_admin",
    principalId: admin.id,
    schoolUdise: null,
    activeWorkspace: "SUPER_ADMIN",
    tokenVersion: admin.token_version,
    userAgent: request.headers.get("user-agent"),
  });

  await supabase.from("audit_logs").insert({
    school_udise: null,
    actor_role: "super_admin",
    actor_id: admin.id,
    action: "SUPER_ADMIN_LOGIN",
    target_type: "super_admin",
    target_id: admin.id,
    meta_json: { totpEnabled: admin.totp_enabled },
  });

  const response = jsonNoStore({
    ok: true,
    redirectTo: "/super-admin",
    superAdmin: {
      id: admin.id,
      email: admin.email,
      fullName: admin.full_name,
      totpEnabled: admin.totp_enabled,
    },
  });

  return applySessionCookie(response, session.rawToken, session.expiresAt);
}
