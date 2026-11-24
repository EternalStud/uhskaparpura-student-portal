import { z } from "zod";
import { getSupabaseAdmin } from "@/lib/supabase/server";
import {
  isMissingColumnError,
  normalizeSubjectRow,
  SUBJECT_SELECT_FULL,
  SUBJECT_SELECT_LEGACY,
} from "@/lib/supabase/schema-compat";
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

  let allSubjects: SubjectRow[] = [];
  const firstRes = await supabase
    .from("subjects")
    .select(SUBJECT_SELECT_FULL)
    .order("class_num", { ascending: true })
    .order("sort_order", { ascending: true });

  if (firstRes.error) {
    if (isMissingColumnError(firstRes.error)) {
      const fallbackRes = await supabase
        .from("subjects")
        .select(SUBJECT_SELECT_LEGACY)
        .order("class_num", { ascending: true })
        .order("sort_order", { ascending: true });
      if (fallbackRes.error) {
        return jsonNoStore({ error: "Unable to load BSEB subject catalog." }, { status: 500 });
      }
      allSubjects = ((fallbackRes.data ?? []) as unknown as Array<
        Omit<SubjectRow, "syllabus_alias_of">
      >).map(normalizeSubjectRow);
    } else {
      return jsonNoStore({ error: "Unable to load BSEB subject catalog." }, { status: 500 });
    }
  } else {
    allSubjects = ((firstRes.data ?? []) as unknown as SubjectRow[]).map(normalizeSubjectRow);
  }

  // Derive effective assignedClasses from assignedSubjectIds if assigned_classes is empty or partial
  const effectiveClassSet = new Set<ClassNum>(session.teacher.assignedClasses);
  const assignedSubjSet = new Set(session.teacher.assignedSubjectIds);
  for (const s of allSubjects) {
    if (
      assignedSubjSet.has(s.id) &&
      (s.class_num === 9 || s.class_num === 10 || s.class_num === 11 || s.class_num === 12)
    ) {
      effectiveClassSet.add(s.class_num);
    }
  }
  const effectiveAssignedClasses = Array.from(effectiveClassSet).sort((a, b) => a - b);

  const grouped = {
    universalSkills: allSubjects.filter((s) => s.class_num === 0),
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
      assignedClasses: effectiveAssignedClasses,
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

  // Ensure assignedClasses covers every selected subject's class_num (ignore universal class_num = 0)
  const mergedClassesSet = new Set<ClassNum>(uniqueClasses);
  for (const classNum of validMap.values()) {
    if (classNum === 9 || classNum === 10 || classNum === 11 || classNum === 12) {
      mergedClassesSet.add(classNum);
    }
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
