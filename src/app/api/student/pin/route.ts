import { z } from "zod";
import { requireRole, jsonNoStore } from "@/lib/auth/session";
import { validateCsrf } from "@/lib/auth/csrf";
import { hashPin } from "@/lib/auth/password";
import { getSupabaseAdmin } from "@/lib/supabase/server";

const pinActionSchema = z.discriminatedUnion("action", [
  z.object({
    action: z.literal("SET"),
    pin: z.string().regex(/^\d{4}$/, "PIN must be exactly 4 digits."),
    currentDob: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "Valid Date of Birth is required."),
  }),
  z.object({
    action: z.literal("REMOVE"),
    currentDob: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "Valid Date of Birth is required."),
  }),
]);

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "अमान्य अनुरोध।", errorEn: "Invalid request." }, { status: 400 });
  }

  const parsed = pinActionSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "कृपया 4 अंकों का पिन और सही जन्म तिथि दर्ज करें।",
        errorEn: "Please enter a valid 4-digit PIN and your Date of Birth.",
      },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();
  const { data: student, error } = await supabase
    .from("students")
    .select("id, dob")
    .eq("id", auth.session.principalId)
    .single();

  if (error || !student) {
    return jsonNoStore({ error: "छात्र खाता नहीं मिला।", errorEn: "Student not found." }, { status: 404 });
  }

  if (student.dob !== parsed.data.currentDob) {
    return jsonNoStore(
      {
        error: "जन्म तिथि हमारे रिकॉर्ड से मेल नहीं खाती।",
        errorEn: "Date of Birth does not match your school record.",
      },
      { status: 403 }
    );
  }

  if (parsed.data.action === "SET") {
    const pinHash = await hashPin(parsed.data.pin);
    const { error: updateErr } = await supabase
      .from("students")
      .update({ pin_hash: pinHash })
      .eq("id", student.id);

    if (updateErr) {
      return jsonNoStore(
        { error: "पिन सहेजा नहीं जा सका।", errorEn: "Could not save PIN." },
        { status: 500 }
      );
    }

    await supabase.from("audit_logs").insert({
      school_udise: auth.session.schoolUdise,
      actor_role: "student",
      actor_id: student.id,
      action: "STUDENT_PIN_SET",
      target_type: "student",
      target_id: student.id,
      meta_json: {},
    });

    return jsonNoStore({
      ok: true,
      hasPin: true,
      messageHi: "आपका 4-अंकों का लैब सुरक्षा पिन सुरक्षित रूप से सेट हो गया है।",
      messageEn: "Your 4-digit Lab Security PIN has been saved safely.",
    });
  }

  // REMOVE PIN
  const { error: clearErr } = await supabase
    .from("students")
    .update({ pin_hash: null })
    .eq("id", student.id);

  if (clearErr) {
    return jsonNoStore(
      { error: "पिन हटाया नहीं जा सका।", errorEn: "Could not remove PIN." },
      { status: 500 }
    );
  }

  await supabase.from("audit_logs").insert({
    school_udise: auth.session.schoolUdise,
    actor_role: "student",
    actor_id: student.id,
    action: "STUDENT_PIN_REMOVED",
    target_type: "student",
    target_id: student.id,
    meta_json: {},
  });

  return jsonNoStore({
    ok: true,
    hasPin: false,
    messageHi: "आपका सुरक्षा पिन हटा दिया गया है। अब आप जन्म तिथि से लॉगिन कर सकते हैं।",
    messageEn: "Your security PIN has been removed. You can sign in using Date of Birth.",
  });
}
