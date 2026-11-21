import { z } from "zod";
import { requireRole, jsonNoStore } from "@/lib/auth/session";
import { validateCsrf } from "@/lib/auth/csrf";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  getClass910SubjectGroups,
  getClass1112SubjectGroups,
  validateSubjectSelection,
} from "@/lib/bseb/rules";
import type { ClassNum, StudentStream } from "@/types/database";

const postSubjectsSchema = z.object({
  stream: z.enum(["UNSET", "NA", "Arts", "Science", "Commerce"]).optional(),
  milSubjectId: z.string().min(1).max(80).nullable().optional(),
  silSubjectId: z.string().min(1).max(80).nullable().optional(),
  skillSubjectId: z.string().min(1).max(80).nullable().optional(),
  lang1SubjectId: z.string().min(1).max(80).nullable().optional(),
  lang2SubjectId: z.string().min(1).max(80).nullable().optional(),
  electiveSubjectIds: z.array(z.string().min(1).max(80)).max(5).optional(),
  additionalSubjectId: z.string().min(1).max(80).nullable().optional(),
});

export async function GET(request: Request) {
  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;

  const { session } = auth;
  const studentInfo = session.student!;
  const supabase = getSupabaseAdmin();

  const [catalogRes, selectedRes, studentRowRes, recentChangesRes] = await Promise.all([
    supabase
      .from("subjects")
      .select("*")
      .eq("class_num", studentInfo.classNum)
      .order("sort_order", { ascending: true }),
    supabase
      .from("student_subjects")
      .select("subject_id, slot_type")
      .eq("student_id", session.principalId)
      .eq("academic_year", studentInfo.academicYear),
    supabase
      .from("students")
      .select("created_at, subjects_configured, subject_changes_count, stream")
      .eq("id", session.principalId)
      .single(),
    supabase
      .from("audit_logs")
      .select("id", { count: "exact", head: true })
      .eq("actor_id", session.principalId)
      .eq("action", "STUDENT_SUBJECTS_UPDATED")
      .gte("created_at", new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString()),
  ]);

  if (catalogRes.error) {
    return jsonNoStore(
      { error: "विषय सूची लोड नहीं हो सकी।", errorEn: "Could not load subjects catalog." },
      { status: 500 }
    );
  }

  const catalog = catalogRes.data ?? [];
  const selectedSlots = selectedRes.data ?? [];
  const studentRow = studentRowRes.data;

  const createdMs = studentRow?.created_at ? new Date(studentRow.created_at).getTime() : Date.now();
  const inGraceWindow = Date.now() - createdMs <= 7 * 24 * 60 * 60 * 1000;
  const monthlyChangesUsed = recentChangesRes.count ?? 0;

  if (studentInfo.classNum === 9 || studentInfo.classNum === 10) {
    return jsonNoStore({
      classNum: studentInfo.classNum,
      stream: "NA",
      subjectsConfigured: Boolean(studentRow?.subjects_configured),
      inGraceWindow,
      monthlyChangesUsed,
      monthlyChangesLimit: 2,
      selectedSlots,
      groups910: getClass910SubjectGroups(studentInfo.classNum, catalog),
      catalog,
    });
  }

  return jsonNoStore({
    classNum: studentInfo.classNum,
    stream: (studentRow?.stream ?? studentInfo.stream) as StudentStream,
    subjectsConfigured: Boolean(studentRow?.subjects_configured),
    inGraceWindow,
    monthlyChangesUsed,
    monthlyChangesLimit: 2,
    selectedSlots,
    groups1112ByStream: {
      Science: getClass1112SubjectGroups(studentInfo.classNum as 11 | 12, "Science", catalog),
      Arts: getClass1112SubjectGroups(studentInfo.classNum as 11 | 12, "Arts", catalog),
      Commerce: getClass1112SubjectGroups(studentInfo.classNum as 11 | 12, "Commerce", catalog),
    },
    catalog,
  });
}

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["student"], request);
  if (!auth.ok) return auth.response;

  const { session } = auth;
  const studentInfo = session.student!;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "अमान्य अनुरोध।", errorEn: "Invalid request payload." }, { status: 400 });
  }

  const parsed = postSubjectsSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      { error: "कृपया सभी आवश्यक विषय चुनें।", errorEn: "Please select all required subjects." },
      { status: 400 }
    );
  }

  const supabase = getSupabaseAdmin();

  const [catalogRes, studentRes] = await Promise.all([
    supabase
      .from("subjects")
      .select("*")
      .eq("class_num", studentInfo.classNum)
      .order("sort_order", { ascending: true }),
    supabase
      .from("students")
      .select("id, created_at, subjects_configured, subject_changes_count")
      .eq("id", session.principalId)
      .single(),
  ]);

  if (catalogRes.error || studentRes.error || !studentRes.data) {
    return jsonNoStore(
      { error: "छात्र जानकारी सत्यापित नहीं हो सकी।", errorEn: "Unable to verify student record." },
      { status: 500 }
    );
  }

  const studentRow = studentRes.data;
  const catalog = catalogRes.data ?? [];

  // Rate-limit subject changes after the initial 7-day onboarding grace window (max 2/month)
  const createdMs = new Date(studentRow.created_at).getTime();
  const inGraceWindow = Date.now() - createdMs <= 7 * 24 * 60 * 60 * 1000;

  if (studentRow.subjects_configured && !inGraceWindow) {
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString();
    const { count } = await supabase
      .from("audit_logs")
      .select("id", { count: "exact", head: true })
      .eq("actor_id", session.principalId)
      .eq("action", "STUDENT_SUBJECTS_UPDATED")
      .gte("created_at", thirtyDaysAgo);

    if ((count ?? 0) >= 2) {
      return jsonNoStore(
        {
          error: "आप इस महीने पहले ही 2 बार विषय बदल चुके हैं। कृपया अगले महीने प्रयास करें या अपने शिक्षक से संपर्क करें।",
          errorEn: "You have already changed subjects twice this month. Please try next month or ask your school teacher.",
        },
        { status: 429 }
      );
    }
  }

  const validation = validateSubjectSelection(
    {
      classNum: studentInfo.classNum as ClassNum,
      stream: parsed.data.stream,
      milSubjectId: parsed.data.milSubjectId,
      silSubjectId: parsed.data.silSubjectId,
      skillSubjectId: parsed.data.skillSubjectId,
      lang1SubjectId: parsed.data.lang1SubjectId,
      lang2SubjectId: parsed.data.lang2SubjectId,
      electiveSubjectIds: parsed.data.electiveSubjectIds,
      additionalSubjectId: parsed.data.additionalSubjectId,
    },
    catalog
  );

  if (!validation.valid) {
    return jsonNoStore(
      {
        error: validation.errors[0]?.hi ?? "विषय चयन अमान्य है।",
        errorEn: validation.errors[0]?.en ?? "Invalid subject selection.",
        errors: validation.errors,
        warnings: validation.warnings,
      },
      { status: 400 }
    );
  }

  // Replace current academic year's subject selection cleanly
  const { error: deleteErr } = await supabase
    .from("student_subjects")
    .delete()
    .eq("student_id", session.principalId)
    .eq("academic_year", studentInfo.academicYear);

  if (deleteErr) {
    return jsonNoStore(
      { error: "विषय सहेजने में समस्या आई।", errorEn: "Could not save subjects." },
      { status: 500 }
    );
  }

  const rowsToInsert = validation.resolvedSlots.map((slot) => ({
    student_id: session.principalId,
    academic_year: studentInfo.academicYear,
    subject_id: slot.subject_id,
    slot_type: slot.slot_type,
  }));

  const { error: insertErr } = await supabase
    .from("student_subjects")
    .insert(rowsToInsert);

  if (insertErr) {
    return jsonNoStore(
      { error: "नए विषय सहेजे नहीं जा सके।", errorEn: "Failed to persist selected subjects." },
      { status: 500 }
    );
  }

  const wasConfigured = Boolean(studentRow.subjects_configured);
  const nextChangeCount = wasConfigured
    ? (studentRow.subject_changes_count ?? 0) + 1
    : studentRow.subject_changes_count ?? 0;

  await supabase
    .from("students")
    .update({
      stream: validation.normalizedStream,
      subjects_configured: true,
      subject_changes_count: nextChangeCount,
    })
    .eq("id", session.principalId);

  await supabase.from("audit_logs").insert({
    school_udise: session.schoolUdise,
    actor_role: "student",
    actor_id: session.principalId,
    action: wasConfigured ? "STUDENT_SUBJECTS_UPDATED" : "STUDENT_SUBJECTS_CONFIGURED",
    target_type: "student",
    target_id: session.principalId,
    meta_json: {
      class_num: studentInfo.classNum,
      stream: validation.normalizedStream,
      subject_ids: validation.resolvedSlots.map((s) => s.subject_id),
    },
  });

  return jsonNoStore({
    ok: true,
    stream: validation.normalizedStream,
    resolvedSlots: validation.resolvedSlots,
    warnings: validation.warnings,
  });
}
