import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import { jsonNoStore, requireRole, validateCsrf } from "@/lib/auth";
import type { ClassNum, SubjectRow } from "@/types/database";

const saveTeacherSubjectsSchema = z.object({
  assignedClasses: z
    .array(z.union([z.literal(9), z.literal(10), z.literal(11), z.literal(12)]))
    .min(1, "Select at least one class (9–12).")
    .max(4),
  assignedSubjectIds: z
    .array(z.string().trim().min(2).max(80))
    .min(1, "Select at least one BSEB subject.")
    .max(40),
});

export async function GET(request: Request) {
  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise || !session.teacher) {
    return jsonNoStore({ error: "School teacher profile not found." }, { status: 403 });
  }

  const supabase = getSupabaseAdmin();

  const { data: subjects, error } = await supabase
    .from("subjects")
    .select(
      "id, bseb_code, class_num, stream, category, name_en, name_hi, icon_name, accent_color, sort_order"
    )
    .order("class_num", { ascending: true })
    .order("sort_order", { ascending: true });

  if (error) {
    return jsonNoStore({ error: "Unable to load BSEB subject catalog." }, { status: 500 });
  }

  const allSubjects: SubjectRow[] = subjects ?? [];

  const grouped = {
    secondary: {
      class9: allSubjects.filter((s) => s.class_num === 9),
      class10: allSubjects.filter((s) => s.class_num === 10),
    },
    seniorSecondary: {
      class11: allSubjects.filter((s) => s.class_num === 11),
      class12: allSubjects.filter((s) => s.class_num === 12),
    },
  };

  return jsonNoStore({
    ok: true,
    teacher: {
      fullName: session.teacher.fullName,
      teacherTitle: session.teacher.teacherTitle,
      subjectsConfigured: session.teacher.subjectsConfigured,
      assignedClasses: session.teacher.assignedClasses,
      assignedSubjectIds: session.teacher.assignedSubjectIds,
    },
    subjects: allSubjects,
    grouped,
  });
}

export async function POST(request: Request) {
  const csrf = validateCsrf(request);
  if (!csrf.ok) return csrf.response;

  const auth = await requireRole(["teacher", "school_admin"], request);
  if (!auth.ok) return auth.response;
  const { session } = auth;

  if (!session.schoolUdise || !session.teacher) {
    return jsonNoStore({ error: "School teacher profile not found." }, { status: 403 });
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return jsonNoStore({ error: "Invalid request payload." }, { status: 400 });
  }

  const parsed = saveTeacherSubjectsSchema.safeParse(body);
  if (!parsed.success) {
    return jsonNoStore(
      {
        error: "Please select at least one class and one subject.",
        errorHi: "कृपया कम से कम एक कक्षा और एक विषय चुनें।",
      },
      { status: 400 }
    );
  }

  const uniqueClasses = Array.from(new Set(parsed.data.assignedClasses)).sort(
    (a, b) => a - b
  ) as ClassNum[];
  const uniqueSubjectIds = Array.from(new Set(parsed.data.assignedSubjectIds));

  const supabase = getSupabaseAdmin();

  // Verify every subject ID exists in official BSEB catalog
  const { data: validSubjects, error: subjErr } = await supabase
    .from("subjects")
    .select("id, class_num")
    .in("id", uniqueSubjectIds);

  if (subjErr) {
    return jsonNoStore({ error: "Could not verify selected subjects." }, { status: 500 });
  }

  const validMap = new Map((validSubjects ?? []).map((s) => [s.id, s.class_num]));
  const invalidIds = uniqueSubjectIds.filter((id) => !validMap.has(id));
  if (invalidIds.length > 0) {
    return jsonNoStore(
      {
        error: "One or more selected subjects are not recognized.",
        errorHi: "चुने गए विषयों में से कुछ मान्य नहीं हैं।",
      },
      { status: 400 }
    );
  }

  // Ensure assignedClasses covers every selected subject's class_num
  const mergedClassesSet = new Set<ClassNum>(uniqueClasses);
  for (const classNum of validMap.values()) {
    mergedClassesSet.add(classNum);
  }
  const finalClasses = Array.from(mergedClassesSet).sort((a, b) => a - b);

  const { error: updateErr } = await supabase
    .from("school_teachers")
    .update({
      assigned_classes: finalClasses,
      assigned_subject_ids: uniqueSubjectIds,
      subjects_configured: true,
    })
    .eq("school_udise", session.schoolUdise)
    .eq("teacher_id", session.principalId)
    .eq("is_active", true);

  if (updateErr) {
    return jsonNoStore(
      {
        error: "Could not save your teaching subjects. Please try again.",
        errorHi: "आपके विषय सहेजे नहीं जा सके। कृपया पुनः प्रयास करें।",
      },
      { status: 500 }
    );
  }

  await supabase.from("audit_logs").insert({
    school_udise: session.schoolUdise,
    actor_role: session.role,
    actor_id: session.principalId,
    action: "TEACHER_SUBJECTS_UPDATED",
    target_type: "school_teacher",
    target_id: session.principalId,
    meta_json: {
      assignedClasses: finalClasses,
      subjectCount: uniqueSubjectIds.length,
    },
  });

  return jsonNoStore({
    ok: true,
    subjectsConfigured: true,
    assignedClasses: finalClasses,
    assignedSubjectIds: uniqueSubjectIds,
  });
}
