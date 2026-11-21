import type {
  ClassNum,
  StudentStream,
  SubjectCategory,
  SubjectRow,
} from '@/types/database';

/**
 * Official Bihar School Examination Board (BSEB) Class 9–12 subject selection
 * validator, catalog grouper, MIL/SIL mutual exclusion helper, and class promotion mapper.
 *
 * Pure deterministic library (safe to run on server or client).
 */

export interface BilingualMessage {
  code: string;
  hi: string;
  en: string;
}

export interface ResolvedSubjectSlot {
  subject_id: string;
  slot_type: SubjectCategory;
}

export interface SubjectSelectionInput {
  classNum: ClassNum;
  /** Required for Class 11 & 12 ('Arts' | 'Science' | 'Commerce'); 'NA' for Class 9 & 10. */
  stream?: StudentStream;
  /** Class 9-10: chosen 1 MIL subject ID */
  milSubjectId?: string | null;
  /** Class 9-10: chosen 1 SIL subject ID */
  silSubjectId?: string | null;
  /** Class 9-10: optional ICT / vocational skill subject ID */
  skillSubjectId?: string | null;
  /** Class 11-12: Language 1 subject ID */
  lang1SubjectId?: string | null;
  /** Class 11-12: Language 2 subject ID (must be a distinct language from Lang 1) */
  lang2SubjectId?: string | null;
  /** Class 11-12: 3 distinct Core Stream Elective subject IDs */
  electiveSubjectIds?: string[];
  /** Class 11-12: 0 or 1 distinct Additional subject ID (not overlapping the 5 above) */
  additionalSubjectId?: string | null;
}

export interface SubjectSelectionValidationResult {
  valid: boolean;
  normalizedStream: StudentStream;
  errors: BilingualMessage[];
  warnings: BilingualMessage[];
  resolvedSlots: ResolvedSubjectSlot[];
}

export interface GroupedClass910Subjects {
  mandatory: SubjectRow[];
  mil: SubjectRow[];
  sil: SubjectRow[];
  skill: SubjectRow[];
}

export interface GroupedClass1112Subjects {
  lang1: SubjectRow[];
  lang2: SubjectRow[];
  electives: SubjectRow[];
  additional: SubjectRow[];
}

export interface PromotionMappingResult {
  compatible: boolean;
  requiresStreamSelection: boolean;
  mappedSlots: ResolvedSubjectSlot[];
  unmappedSubjectIds: string[];
  warnings: BilingualMessage[];
}

const VALID_SENIOR_STREAMS = new Set<StudentStream>(['Arts', 'Science', 'Commerce']);

/**
 * Normalizes a subject/language name into a canonical token to detect duplicate
 * language picks across slots (e.g., "Hindi (MIL)" vs "Hindi (Compulsory)" vs "Non-Hindi (Rashtrabhasha)").
 */
export function normalizeSubjectKey(nameEn: string): string {
  const base = nameEn
    .toLowerCase()
    .replace(/\([^)]*\)/g, ' ')
    .replace(/[^a-z0-9\s]/g, ' ')
    .replace(/\b(compulsory|elective|core|paper|part|i|ii|mil|sil|lang|language|1|2|bseb)\b/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
  return base;
}

function isHindiMil(subject: SubjectRow): boolean {
  const key = normalizeSubjectKey(subject.name_en);
  return key === 'hindi' || /\bhindi\b/.test(key);
}

function isNonHindiOrHindiSil(subject: SubjectRow): boolean {
  const raw = subject.name_en.toLowerCase();
  return (
    raw.includes('non-hindi') ||
    raw.includes('non hindi') ||
    raw.includes('rashtrabhasha') ||
    raw.includes('nlh') ||
    normalizeSubjectKey(subject.name_en) === 'hindi'
  );
}

/**
 * Returns true if the given SIL subject is allowed by official BSEB Class 9-10 rules
 * alongside the chosen MIL subject.
 *
 * Official BSEB rule:
 * - If MIL is Hindi -> Student CANNOT choose Hindi or Non-Hindi (Rashtrabhasha) as SIL.
 * - If MIL is Urdu / Maithili / Bangla -> Student CANNOT choose the same language as SIL.
 */
export function isSilCompatibleWithMil(milSubject: SubjectRow, silSubject: SubjectRow): boolean {
  if (milSubject.id === silSubject.id) return false;
  if (isHindiMil(milSubject) && isNonHindiOrHindiSil(silSubject)) {
    return false;
  }
  const milKey = normalizeSubjectKey(milSubject.name_en);
  const silKey = normalizeSubjectKey(silSubject.name_en);
  if (milKey && silKey && milKey === silKey) {
    return false;
  }
  return true;
}

/**
 * Filters Class 9-10 SIL options strictly allowed for the chosen MIL subject.
 */
export function getAllowedSilForMil(
  milSubject: SubjectRow | null | undefined,
  silCatalog: ReadonlyArray<SubjectRow>
): SubjectRow[] {
  if (!milSubject) return [...silCatalog];
  return silCatalog.filter((sil) => isSilCompatibleWithMil(milSubject, sil));
}

/**
 * Auto-recommends the canonical BSEB SIL subject based on MIL:
 * - For Urdu / Maithili / Bangla MIL -> auto-recommends Non-Hindi (Rashtrabhasha Hindi).
 * - For Hindi MIL -> recommends Sanskrit (most common BSEB combination).
 */
export function getRecommendedSil(
  milSubject: SubjectRow | null | undefined,
  silCatalog: ReadonlyArray<SubjectRow>
): SubjectRow | null {
  if (!milSubject) return null;
  const allowed = getAllowedSilForMil(milSubject, silCatalog);
  if (allowed.length === 0) return null;

  if (!isHindiMil(milSubject)) {
    const nonHindi = allowed.find((s) => isNonHindiOrHindiSil(s));
    if (nonHindi) return nonHindi;
  } else {
    const sanskrit = allowed.find((s) => s.name_en.toLowerCase().includes('sanskrit'));
    if (sanskrit) return sanskrit;
  }

  return allowed[0] ?? null;
}

/**
 * Groups catalog subjects for Class 9-10 selection UI.
 */
export function getClass910SubjectGroups(
  classNum: 9 | 10,
  catalog: ReadonlyArray<SubjectRow>
): GroupedClass910Subjects {
  const scoped = catalog
    .filter((s) => s.class_num === classNum && (s.stream === 'NA' || s.stream === 'ALL'))
    .sort((a, b) => a.sort_order - b.sort_order);

  return {
    mandatory: scoped.filter((s) => s.category === 'MANDATORY'),
    mil: scoped.filter((s) => s.category === 'MIL'),
    sil: scoped.filter((s) => s.category === 'SIL'),
    skill: scoped.filter((s) => s.category === 'SKILL'),
  };
}

/**
 * Groups catalog subjects for Class 11-12 selection UI for a specific Stream.
 */
export function getClass1112SubjectGroups(
  classNum: 11 | 12,
  stream: 'Arts' | 'Science' | 'Commerce',
  catalog: ReadonlyArray<SubjectRow>
): GroupedClass1112Subjects {
  const scoped = catalog
    .filter((s) => s.class_num === classNum)
    .sort((a, b) => a.sort_order - b.sort_order);

  const lang1 = scoped.filter(
    (s) => s.category === 'LANG_1' && (s.stream === 'ALL' || s.stream === stream)
  );
  const lang2 = scoped.filter(
    (s) => s.category === 'LANG_2' && (s.stream === 'ALL' || s.stream === stream)
  );
  const electives = scoped.filter(
    (s) => s.category === 'ELECTIVE' && (s.stream === stream || s.stream === 'ALL')
  );
  // Additional slot accepts explicit ADDITIONAL subjects AND stream electives not already picked
  const additional = scoped.filter(
    (s) =>
      (s.category === 'ADDITIONAL' && (s.stream === 'ALL' || s.stream === stream)) ||
      (s.category === 'ELECTIVE' && (s.stream === stream || s.stream === 'ALL'))
  );

  return { lang1, lang2, electives, additional };
}

/**
 * Validates a student's complete BSEB subject selection against official Bihar Board rules.
 */
export function validateSubjectSelection(
  input: SubjectSelectionInput,
  catalog: ReadonlyArray<SubjectRow>
): SubjectSelectionValidationResult {
  const errors: BilingualMessage[] = [];
  const warnings: BilingualMessage[] = [];
  const resolvedSlots: ResolvedSubjectSlot[] = [];

  const byId = new Map<string, SubjectRow>();
  for (const subj of catalog) {
    byId.set(subj.id, subj);
  }

  // =========================================================================
  // CLASS 9 & 10 (BSEB Secondary)
  // =========================================================================
  if (input.classNum === 9 || input.classNum === 10) {
    const groups = getClass910SubjectGroups(input.classNum, catalog);

    // 1. Auto-include all Mandatory subjects (Mathematics, Science, Social Science, English)
    for (const mandatory of groups.mandatory) {
      resolvedSlots.push({ subject_id: mandatory.id, slot_type: 'MANDATORY' });
    }
    if (groups.mandatory.length < 4) {
      warnings.push({
        code: 'INCOMPLETE_MANDATORY_CATALOG',
        hi: 'अनिवार्य विषयों की सूची अपूर्ण है। कृपया विद्यालय प्रशासक से संपर्क करें।',
        en: 'Mandatory subject catalog has fewer than 4 subjects.',
      });
    }

    // 2. Validate exactly 1 MIL
    const mil = input.milSubjectId ? byId.get(input.milSubjectId) : undefined;
    if (!mil || mil.class_num !== input.classNum || mil.category !== 'MIL') {
      errors.push({
        code: 'MIL_REQUIRED',
        hi: 'कृपया 1 मातृभाषा (MIL — जैसे हिंदी, उर्दू, मैथिली या बांग्ला) चुनें।',
        en: 'Please select 1 Mother Tongue / MIL subject (Hindi, Urdu, Maithili, or Bangla).',
      });
    } else {
      resolvedSlots.push({ subject_id: mil.id, slot_type: 'MIL' });
    }

    // 3. Validate exactly 1 SIL + mutual exclusion with MIL
    const sil = input.silSubjectId ? byId.get(input.silSubjectId) : undefined;
    if (!sil || sil.class_num !== input.classNum || sil.category !== 'SIL') {
      errors.push({
        code: 'SIL_REQUIRED',
        hi: 'कृपया 1 द्वितीय भारतीय भाषा (SIL — जैसे संस्कृत या अहिंदी) चुनें।',
        en: 'Please select 1 Second Indian Language (SIL — e.g., Sanskrit or Non-Hindi).',
      });
    } else if (mil && !isSilCompatibleWithMil(mil, sil)) {
      errors.push({
        code: 'MIL_SIL_MUTUAL_EXCLUSION',
        hi: isHindiMil(mil)
          ? 'हिंदी (MIL) चुनने पर अहिंदी/राष्ट्रभाषा हिंदी (SIL) नहीं चुना जा सकता। कृपया संस्कृत या कोई अन्य भाषा चुनें।'
          : 'मातृभाषा (MIL) और द्वितीय भाषा (SIL) एक ही भाषा नहीं हो सकती।',
        en: isHindiMil(mil)
          ? 'Students choosing Hindi as MIL cannot choose Hindi or Non-Hindi as SIL. Please choose Sanskrit or another allowed SIL.'
          : 'MIL and SIL cannot be the same language.',
      });
    } else {
      resolvedSlots.push({ subject_id: sil.id, slot_type: 'SIL' });
      // Friendly BSEB guidance if non-Hindi MIL picked something other than Non-Hindi SIL
      if (mil && !isHindiMil(mil) && !isNonHindiOrHindiSil(sil)) {
        warnings.push({
          code: 'NON_HINDI_SIL_RECOMMENDED',
          hi: 'बिहार बोर्ड के अनुसार उर्दू/मैथिली/बांग्ला (MIL) के साथ सामान्यतः अहिंदी (राष्ट्रभाषा हिंदी) चुना जाता है।',
          en: 'Under BSEB guidelines, Non-Hindi (Rashtrabhasha Hindi) is typically recommended with Urdu/Maithili/Bangla MIL.',
        });
      }
    }

    // 4. Optional ICT / Skill subject
    if (input.skillSubjectId) {
      const skill = byId.get(input.skillSubjectId);
      if (!skill || skill.class_num !== input.classNum || skill.category !== 'SKILL') {
        errors.push({
          code: 'INVALID_SKILL_SUBJECT',
          hi: 'चुना गया ऐच्छिक कौशल विषय (ICT/Skill) इस कक्षा के लिए मान्य नहीं है।',
          en: 'Selected optional skill subject is not valid for this class.',
        });
      } else {
        resolvedSlots.push({ subject_id: skill.id, slot_type: 'SKILL' });
      }
    }

    return {
      valid: errors.length === 0,
      normalizedStream: 'NA',
      errors,
      warnings,
      resolvedSlots: errors.length === 0 ? resolvedSlots : [],
    };
  }

  // =========================================================================
  // CLASS 11 & 12 (BSEB Intermediate)
  // =========================================================================
  const stream = input.stream;
  if (!stream || !VALID_SENIOR_STREAMS.has(stream)) {
    errors.push({
      code: 'STREAM_REQUIRED',
      hi: 'कक्षा 11 और 12 के लिए संकाय (विज्ञान / कला / वाणिज्य) चुनना अनिवार्य है।',
      en: 'Stream selection (Science, Arts, or Commerce) is required for Class 11 and 12.',
    });
    return {
      valid: false,
      normalizedStream: 'UNSET',
      errors,
      warnings,
      resolvedSlots: [],
    };
  }

  const chosenIds = new Set<string>();
  const chosenCanonicalNames = new Set<string>();

  const registerChoice = (subj: SubjectRow, slotType: SubjectCategory): boolean => {
    const canon = normalizeSubjectKey(subj.name_en);
    if (chosenIds.has(subj.id) || (canon && chosenCanonicalNames.has(canon))) {
      return false;
    }
    chosenIds.add(subj.id);
    if (canon) chosenCanonicalNames.add(canon);
    resolvedSlots.push({ subject_id: subj.id, slot_type: slotType });
    return true;
  };

  // 1. Language 1 (Compulsory)
  const lang1 = input.lang1SubjectId ? byId.get(input.lang1SubjectId) : undefined;
  if (
    !lang1 ||
    lang1.class_num !== input.classNum ||
    lang1.category !== 'LANG_1' ||
    (lang1.stream !== 'ALL' && lang1.stream !== stream)
  ) {
    errors.push({
      code: 'LANG_1_REQUIRED',
      hi: 'कृपया अनिवार्य भाषा-1 (जैसे हिंदी या अंग्रेजी) चुनें।',
      en: 'Please select Compulsory Language 1.',
    });
  } else {
    registerChoice(lang1, 'LANG_1');
  }

  // 2. Language 2 (Compulsory, distinct from Language 1)
  const lang2 = input.lang2SubjectId ? byId.get(input.lang2SubjectId) : undefined;
  if (
    !lang2 ||
    lang2.class_num !== input.classNum ||
    lang2.category !== 'LANG_2' ||
    (lang2.stream !== 'ALL' && lang2.stream !== stream)
  ) {
    errors.push({
      code: 'LANG_2_REQUIRED',
      hi: 'कृपया अनिवार्य भाषा-2 चुनें।',
      en: 'Please select Compulsory Language 2.',
    });
  } else if (!registerChoice(lang2, 'LANG_2')) {
    errors.push({
      code: 'DUPLICATE_LANGUAGE',
      hi: 'भाषा-1 और भाषा-2 अलग-अलग भाषाएँ होनी चाहिए।',
      en: 'Language 1 and Language 2 must be two distinct languages.',
    });
  }

  // 3. Exactly 3 distinct Core Stream Electives
  const electiveIds = Array.isArray(input.electiveSubjectIds) ? input.electiveSubjectIds : [];
  if (electiveIds.length !== 3) {
    errors.push({
      code: 'THREE_ELECTIVES_REQUIRED',
      hi: `कृपया ${stream} संकाय से ठीक 3 मुख्य ऐच्छिक विषय चुनें।`,
      en: `Please select exactly 3 core elective subjects for the ${stream} stream.`,
    });
  } else {
    for (const eid of electiveIds) {
      const elective = byId.get(eid);
      if (
        !elective ||
        elective.class_num !== input.classNum ||
        elective.category !== 'ELECTIVE' ||
        (elective.stream !== stream && elective.stream !== 'ALL')
      ) {
        errors.push({
          code: 'INVALID_ELECTIVE',
          hi: `चुना गया विषय ${stream} संकाय के मुख्य विषयों में मान्य नहीं है।`,
          en: `One of the chosen electives is not valid for Class ${input.classNum} ${stream}.`,
        });
        continue;
      }
      if (!registerChoice(elective, 'ELECTIVE')) {
        errors.push({
          code: 'DUPLICATE_ELECTIVE',
          hi: 'तीनों मुख्य ऐच्छिक विषय एक-दूसरे से अलग होने चाहिए।',
          en: 'All 3 core electives must be distinct subjects.',
        });
      }
    }
  }

  // 4. Optional 0 or 1 distinct Additional Subject (not overlapping the 5 chosen above!)
  if (input.additionalSubjectId) {
    const additional = byId.get(input.additionalSubjectId);
    const allowedAdditionalCategory =
      additional &&
      (additional.category === 'ADDITIONAL' || additional.category === 'ELECTIVE') &&
      (additional.stream === 'ALL' || additional.stream === stream);

    if (!additional || additional.class_num !== input.classNum || !allowedAdditionalCategory) {
      errors.push({
        code: 'INVALID_ADDITIONAL',
        hi: 'चुना गया अतिरिक्त (6ठा) विषय इस संकाय के लिए मान्य नहीं है।',
        en: 'Selected additional (6th) subject is not valid for this class and stream.',
      });
    } else if (!registerChoice(additional, 'ADDITIONAL')) {
      errors.push({
        code: 'OVERLAPPING_ADDITIONAL',
        hi: 'अतिरिक्त (6ठा) विषय पहले चुने गए 5 विषयों से अलग होना चाहिए।',
        en: 'Additional subject cannot overlap with your 5 compulsory/elective subjects.',
      });
    }
  }

  return {
    valid: errors.length === 0,
    normalizedStream: stream,
    errors,
    warnings,
    resolvedSlots: errors.length === 0 ? resolvedSlots : [],
  };
}

/**
 * Seamlessly maps a student's chosen subjects on academic year promotion:
 * - Class 9 -> Class 10 (compatible subjects carried forward automatically)
 * - Class 11 -> Class 12 (same stream & subjects carried forward automatically)
 * - Class 10 -> Class 11 (returns `requiresStreamSelection: true` so student picks Science/Arts/Commerce)
 */
export function mapSubjectsForPromotion(params: {
  fromClass: ClassNum;
  toClass: ClassNum;
  currentSlots: ReadonlyArray<ResolvedSubjectSlot>;
  fromCatalog: ReadonlyArray<SubjectRow>;
  toCatalog: ReadonlyArray<SubjectRow>;
}): PromotionMappingResult {
  const { fromClass, toClass, currentSlots, fromCatalog, toCatalog } = params;

  if (fromClass === 10 && toClass === 11) {
    return {
      compatible: false,
      requiresStreamSelection: true,
      mappedSlots: [],
      unmappedSubjectIds: currentSlots.map((s) => s.subject_id),
      warnings: [
        {
          code: 'STREAM_SELECTION_REQUIRED_FOR_11',
          hi: 'कक्षा 11 में प्रोन्नत होने के बाद छात्र को अपना संकाय (विज्ञान/कला/वाणिज्य) और नए विषय चुनने होंगे।',
          en: 'Students promoted from Class 10 to Class 11 must choose their Intermediate stream and subjects.',
        },
      ],
    };
  }

  const isSeamlessJump =
    (fromClass === 9 && toClass === 10) || (fromClass === 11 && toClass === 12);

  if (!isSeamlessJump) {
    return {
      compatible: false,
      requiresStreamSelection: toClass === 11 || toClass === 12,
      mappedSlots: [],
      unmappedSubjectIds: currentSlots.map((s) => s.subject_id),
      warnings: [
        {
          code: 'UNSUPPORTED_PROMOTION_JUMP',
          hi: `कक्षा ${fromClass} से कक्षा ${toClass} में स्वचालित विषय स्थानांतरण संभव नहीं है।`,
          en: `Automatic subject mapping is only supported for 9->10 and 11->12 promotions.`,
        },
      ],
    };
  }

  const fromById = new Map(fromCatalog.map((s) => [s.id, s]));
  const targetCatalog = toCatalog.filter((s) => s.class_num === toClass);

  const mappedSlots: ResolvedSubjectSlot[] = [];
  const unmappedSubjectIds: string[] = [];
  const warnings: BilingualMessage[] = [];
  const usedTargetIds = new Set<string>();

  for (const slot of currentSlots) {
    const oldSubj = fromById.get(slot.subject_id);
    if (!oldSubj) {
      unmappedSubjectIds.push(slot.subject_id);
      continue;
    }

    const oldCanon = normalizeSubjectKey(oldSubj.name_en);

    // Priority 1: Exact same category + stream + canonical English name
    let match = targetCatalog.find(
      (cand) =>
        !usedTargetIds.has(cand.id) &&
        cand.category === oldSubj.category &&
        cand.stream === oldSubj.stream &&
        normalizeSubjectKey(cand.name_en) === oldCanon
    );

    // Priority 2: Same slot_type/category + canonical English name (ignoring stream='ALL' diff)
    if (!match) {
      match = targetCatalog.find(
        (cand) =>
          !usedTargetIds.has(cand.id) &&
          cand.category === oldSubj.category &&
          normalizeSubjectKey(cand.name_en) === oldCanon
      );
    }

    // Priority 3: Matching Hindi name + same category
    if (!match) {
      const oldHi = oldSubj.name_hi.trim().toLowerCase();
      match = targetCatalog.find(
        (cand) =>
          !usedTargetIds.has(cand.id) &&
          cand.category === oldSubj.category &&
          cand.name_hi.trim().toLowerCase() === oldHi
      );
    }

    if (match) {
      usedTargetIds.add(match.id);
      mappedSlots.push({
        subject_id: match.id,
        slot_type: slot.slot_type,
      });
    } else {
      unmappedSubjectIds.push(slot.subject_id);
      warnings.push({
        code: 'SUBJECT_UNMAPPED_ON_PROMOTION',
        hi: `विषय "${oldSubj.name_hi}" का कक्षा ${toClass} में समतुल्य विषय नहीं मिला।`,
        en: `No Class ${toClass} equivalent found for "${oldSubj.name_en}".`,
      });
    }
  }

  return {
    compatible: unmappedSubjectIds.length === 0 && mappedSlots.length > 0,
    requiresStreamSelection: false,
    mappedSlots,
    unmappedSubjectIds,
    warnings,
  };
}
