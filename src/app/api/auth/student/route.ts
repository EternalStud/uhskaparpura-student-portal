import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  applySessionCookie,
  checkAuthRateLimit,
  clearAccountRateLimit,
  constantTimeEqual,
  createSession,
  extractClientIp,
  jsonNoStore,
  recordAuthFailure,
  validateCsrf,
  verifyPin,
  verifyTurnstileToken,
} from "@/lib/auth";
import type { ClassNum, StudentRow } from "@/types/database";

const isoDobRegex = /^\d{4}-\d{2}-\d{2}$/;
const pinRegex = /^\d{4}$/;

const studentLoginSchema = z
  .discriminatedUnion("mode", [
    z.object({
      mode: z.literal("CODE"),
      studentCode: z.string().trim().min(4).max(32),
      authMethod: z.enum(["DOB", "PIN"]).optional(),
      dob: z.string().trim().regex(isoDobRegex).optional(),
      pin: z.string().trim().regex(pinRegex).optional(),
      turnstileToken: z.string().trim().max(2048).optional(),
    }),
    z.object({
      mode: z.literal("DETAILS"),
      schoolUdise: z.string().trim().regex(/^\d{11}$/),
      classNum: z.coerce.number().int().min(9).max(12),
      rollNo: z.coerce.number().int().min(1).max(99999),
      authMethod: z.enum(["DOB", "PIN"]).optional(),
      dob: z.string().trim().regex(isoDobRegex).optional(),
      pin: z.string().trim().regex(pinRegex).optional(),
      fatherName: z.string().trim().max(120).optional(),
      turnstileToken: z.string().trim().max(2048).optional(),
    }),
  ])
  .superRefine((data, ctx) => {
    const method = data.authMethod ?? (data.pin ? "PIN" : "DOB");
    if (method === "DOB" && !data.dob) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["dob"],
        message: "Date of birth is required.",
      });
    }
    if (method === "PIN" && !data.pin) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["pin"],
        message: "4-digit PIN is required.",
      });
    }
  });

function normalizePersonName(name: string | null | undefined): string {
  if (!name) return "";
  return name
    .toLowerCase()
    .replace(/\b(mr|mrs|ms|shri|sri|late|md|mohd|dr)\.?\b/g, " ")
    .replace(/[^a-z0-9\u0900-\u097f]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function fatherNameMatches(
  candidateFather: string | null,
  providedFather: string
): boolean {
  const normStored = normalizePersonName(candidateFather);
  const normInput = normalizePersonName(providedFather);
  if (!normStored || !normInput || normInput.length < 2) return false;
  if (normStored === normInput) return true;
  const storedTokens = normStored.split(" ");
  const inputTokens = normInput.split(" ");
  return inputTokens.every((tok) => storedTokens.includes(tok));
}

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

  const parsed = studentLoginSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please enter all required student details.",
        errorHi: "कृपया सभी आवश्यक जानकारी सही से भरें।",
      },
      { status: 400 }
    );
  }

  const input = parsed.data;
  const authMethod = input.authMethod ?? (input.pin ? "PIN" : "DOB");
  const clientIp = extractClientIp(request);
  const accountKey =
    input.mode === "CODE"
      ? `code:${input.studentCode}`
      : `details:${input.schoolUdise}:${input.classNum}:${input.rollNo}`;

  const rl = await checkAuthRateLimit({
    scope: "student-login",
    accountKey,
    clientIp,
  });

  if (!rl.allowed) {
    return jsonNoStore(
      {
        error: `Too many incorrect attempts. Please try again in ${Math.ceil(rl.retryAfterSec / 60)} minutes.`,
        errorHi: `कई गलत प्रयास हुए हैं। कृपया ${Math.ceil(rl.retryAfterSec / 60)} मिनट बाद दोबारा प्रयास करें।`,
        retryAfterSec: rl.retryAfterSec,
      },
      { status: 429 }
    );
  }

  if (rl.requiresTurnstile) {
    const turnstile = await verifyTurnstileToken(input.turnstileToken, clientIp);
    if (!turnstile.ok) {
      return jsonNoStore(
        {
          requiresTurnstile: true,
          error: "Please complete the quick security check below.",
          errorHi: "कृपया नीचे दिया गया सुरक्षा सत्यापन पूरा करें।",
        },
        { status: 403 }
      );
    }
  }

  const supabase = getSupabaseAdmin();
  let candidates: StudentRow[] = [];

  if (input.mode === "CODE") {
    const { data, error } = await supabase
      .from("students")
      .select("*")
      .eq("student_code", input.studentCode)
      .eq("is_active", true)
      .limit(5);

    if (error) {
      return jsonNoStore(
        {
          error: "Unable to sign in right now. Please try again.",
          errorHi: "अभी लॉगिन नहीं हो सका। कृपया थोड़ी देर बाद प्रयास करें।",
        },
        { status: 500 }
      );
    }
    candidates = (data ?? []) as StudentRow[];
  } else {
    const { data, error } = await supabase
      .from("students")
      .select("*")
      .eq("school_udise", input.schoolUdise)
      .eq("class_num", input.classNum as ClassNum)
      .eq("roll_no", input.rollNo)
      .eq("is_active", true)
      .limit(10);

    if (error) {
      return jsonNoStore(
        {
          error: "Unable to sign in right now. Please try again.",
          errorHi: "अभी लॉगिन नहीं हो सका। कृपया थोड़ी देर बाद प्रयास करें।",
        },
        { status: 500 }
      );
    }
    candidates = (data ?? []) as StudentRow[];
  }

  // Filter candidates by verified DOB or 4-digit PIN
  const matched: StudentRow[] = [];
  let pinNotConfiguredCount = 0;

  for (const student of candidates) {
    if (authMethod === "DOB" && input.dob) {
      if (constantTimeEqual(student.dob, input.dob)) {
        matched.push(student);
      }
    } else if (authMethod === "PIN" && input.pin) {
      if (!student.pin_hash) {
        pinNotConfiguredCount += 1;
        continue;
      }
      const pinOk = await verifyPin(input.pin, student.pin_hash);
      if (pinOk) {
        matched.push(student);
      }
    }
  }

  if (matched.length === 0) {
    const fail = await recordAuthFailure({
      scope: "student-login",
      accountKey,
      clientIp,
    });

    if (
      authMethod === "PIN" &&
      candidates.length > 0 &&
      pinNotConfiguredCount === candidates.length
    ) {
      return jsonNoStore(
        {
          requiresTurnstile: fail.requiresTurnstile,
          error:
            "You have not set a 4-digit PIN yet. Please sign in using your Date of Birth first.",
          errorHi:
            "आपने अभी तक 4-अंकों का PIN सेट नहीं किया है। कृपया अपनी जन्म तिथि से लॉगिन करें।",
        },
        { status: 401 }
      );
    }

    return jsonNoStore(
      {
        requiresTurnstile: fail.requiresTurnstile,
        error:
          "Student record not matched. Please check your details and try again.",
        errorHi:
          "छात्र विवरण मेल नहीं खाया। कृपया अपना कोड/रोल नंबर और जन्म तिथि दोबारा जांचें।",
      },
      { status: 401 }
    );
  }

  // Rare tie-breaker when two active students in the same school share Class + Roll + DOB
  let selectedStudent: StudentRow | null = null;
  if (matched.length === 1) {
    selectedStudent = matched[0];
  } else {
    const providedFather =
      input.mode === "DETAILS" ? (input.fatherName ?? "").trim() : "";

    if (!providedFather) {
      return jsonNoStore(
        {
          ok: false,
          disambiguationRequired: true,
          error:
            "More than one student matched this Roll No and Date of Birth. Please enter your Father's Name to continue.",
          errorHi:
            "इस रोल नंबर और जन्म तिथि से एक से अधिक छात्र मिले हैं। कृपया आगे बढ़ने के लिए अपने पिता का नाम दर्ज करें।",
        },
        { status: 200 }
      );
    }

    const fatherMatches = matched.filter((s) =>
      fatherNameMatches(s.father_name, providedFather)
    );

    if (fatherMatches.length !== 1) {
      const fail = await recordAuthFailure({
        scope: "student-login",
        accountKey,
        clientIp,
      });
      return jsonNoStore(
        {
          disambiguationRequired: true,
          requiresTurnstile: fail.requiresTurnstile,
          error:
            "Father's Name did not match a unique student record. Please enter the full name from your school register.",
          errorHi:
            "पिता का नाम स्कूल रिकॉर्ड से मेल नहीं खाया। कृपया रजिस्टर के अनुसार पूरा नाम लिखें।",
        },
        { status: 401 }
      );
    }

    selectedStudent = fatherMatches[0];
  }

  // Verify school is active & not suspended
  const { data: school, error: schoolErr } = await supabase
    .from("schools")
    .select("udise_code, school_name, school_name_hi, status")
    .eq("udise_code", selectedStudent.school_udise)
    .maybeSingle();

  if (schoolErr || !school || school.status !== "ACTIVE") {
    return jsonNoStore(
      {
        error: "This school portal is currently unavailable.",
        errorHi: "यह विद्यालय पोर्टल अभी उपलब्ध नहीं है। कृपया अपने शिक्षक से संपर्क करें।",
      },
      { status: 403 }
    );
  }

  await clearAccountRateLimit("student-login", accountKey);

  const session = await createSession({
    role: "student",
    principalId: selectedStudent.id,
    schoolUdise: school.udise_code,
    activeWorkspace: "STUDENT",
    tokenVersion: selectedStudent.token_version,
    userAgent: request.headers.get("user-agent"),
  });

  const redirectTo = selectedStudent.subjects_configured
    ? "/student"
    : "/student/onboarding";

  const response = jsonNoStore({
    ok: true,
    redirectTo,
    student: {
      id: selectedStudent.id,
      studentName: selectedStudent.student_name,
      classNum: selectedStudent.class_num,
      stream: selectedStudent.stream,
      section: selectedStudent.section,
      rollNo: selectedStudent.roll_no,
      subjectsConfigured: selectedStudent.subjects_configured,
      preferredLang: selectedStudent.preferred_lang,
      schoolUdise: school.udise_code,
      schoolName: school.school_name,
    },
  });

  return applySessionCookie(response, session.rawToken, session.expiresAt);
}
