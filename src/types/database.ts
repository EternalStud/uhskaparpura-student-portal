// =============================================================================
// Students of Bihar (9-12) — Complete Database Row & JSONB Domain Types (v2.4)
// Mirrors supabase/migrations/001_v2_multitenant_schema.sql 1:1.
// =============================================================================

export type LanguageMode = 'HI' | 'EN' | 'BOTH';
export type UserRole = 'student' | 'teacher' | 'school_admin' | 'super_admin';
export type ClassNum = 9 | 10 | 11 | 12;

export type SchoolStatus = 'ONBOARDING' | 'ACTIVE' | 'SUSPENDED';
export type StudentStream = 'UNSET' | 'NA' | 'Arts' | 'Science' | 'Commerce';
export type SubjectStream = 'NA' | 'Arts' | 'Science' | 'Commerce' | 'ALL';
export type ExamStream = 'ALL' | 'NA' | 'Arts' | 'Science' | 'Commerce';

export type SubjectCategory =
  | 'MANDATORY'
  | 'MIL'
  | 'SIL'
  | 'LANG_1'
  | 'LANG_2'
  | 'ELECTIVE'
  | 'ADDITIONAL'
  | 'SKILL';

export type SyncType = 'ONBOARDING' | 'STUDENTS' | 'TEACHERS';
export type NoteStatus = 'DRAFT' | 'PUBLISHED';
export type MediaScope = 'GLOBAL' | 'SCHOOL_PRIVATE' | 'EDITORIAL_SUBMISSION';
export type MediaStatus = 'PENDING' | 'ACTIVE' | 'DELETE_QUEUED' | 'DELETED';

export type SubmissionSourceType = 'SCANNED_PDF' | 'EXCEL' | 'WORD' | 'IMAGE';
export type SubmissionStatus =
  | 'PENDING'
  | 'AI_PARSING'
  | 'AI_READY'
  | 'APPROVED'
  | 'REJECTED';

export type QuestionBankPool = 'PRACTICE' | 'EXAM_ONLY';
export type QuestionType =
  | 'MCQ'
  | 'SHORT_2M'
  | 'LONG_5M'
  | 'MATCH_PAIRS'
  | 'DIAGRAM_LABEL'
  | 'FLASHCARD';
export type DifficultyTier = 'FOUNDATION' | 'BOARD' | 'TOPPER';

export type PracticeMode =
  | 'FLASHCARD'
  | 'MATCH_PAIRS'
  | 'DIAGRAM_LABEL'
  | 'MCQ_PRACTICE'
  | 'SUBJECTIVE_SELF_CHECK'
  | 'REVISION_DRILL'
  | 'DAILY_CHALLENGE';

export type TeacherMaterialType =
  | 'NOTE'
  | 'PDF'
  | 'IMAGE'
  | 'VIDEO_UPLOAD'
  | 'VIDEO_YOUTUBE';

export type DoubtStatus = 'OPEN' | 'ANSWERED' | 'RESOLVED';

export type ExamMode = 'LIVE_PIN' | 'SCHEDULED';
export type ExamScopeType = 'TOPIC' | 'CHAPTER' | 'SUBJECT';
export type ExamStatus = 'DRAFT' | 'LOBBY' | 'ACTIVE' | 'ENDED';
export type ExamSolutionPolicy =
  | 'AFTER_EXAM_ENDS'
  | 'IMMEDIATE_ON_SUBMIT'
  | 'TEACHER_ONLY';
export type ExamAttemptStatus = 'JOINED' | 'IN_PROGRESS' | 'SUBMITTED';

// =============================================================================
// JSONB DOMAIN STRUCTURES — CURRICULUM, VISUALS, LESSON PLANS & EXAMS
// =============================================================================

export interface MindmapBranchNode {
  id: string;
  label_hi: string;
  label_en: string;
  detail_hi?: string;
  detail_en?: string;
  formula_latex?: string;
  color?: string;
  children?: MindmapBranchNode[];
}

export interface MindmapSpec {
  title_hi: string;
  title_en: string;
  read_time_seconds: number;
  central_node: {
    id: string;
    label_hi: string;
    label_en: string;
    subtitle_hi?: string;
    subtitle_en?: string;
  };
  branches: MindmapBranchNode[];
}

// Declarative, strictly whitelisted SVG geometric primitives (zero scripts/HTML)
export type SafeSvgElement =
  | {
      kind: 'line';
      x1: number;
      y1: number;
      x2: number;
      y2: number;
      stroke?: string;
      strokeWidth?: number;
      dashed?: boolean;
    }
  | {
      kind: 'arrow';
      x1: number;
      y1: number;
      x2: number;
      y2: number;
      stroke?: string;
      strokeWidth?: number;
      dashed?: boolean;
    }
  | {
      kind: 'rect';
      x: number;
      y: number;
      width: number;
      height: number;
      rx?: number;
      fill?: string;
      stroke?: string;
      strokeWidth?: number;
    }
  | {
      kind: 'circle';
      cx: number;
      cy: number;
      r: number;
      fill?: string;
      stroke?: string;
      strokeWidth?: number;
    }
  | {
      kind: 'ellipse';
      cx: number;
      cy: number;
      rx: number;
      ry: number;
      fill?: string;
      stroke?: string;
      strokeWidth?: number;
    }
  | {
      kind: 'path';
      d: string;
      fill?: string;
      stroke?: string;
      strokeWidth?: number;
      dashed?: boolean;
    }
  | {
      kind: 'polygon';
      points: string;
      fill?: string;
      stroke?: string;
      strokeWidth?: number;
    }
  | {
      kind: 'label';
      x: number;
      y: number;
      text_hi: string;
      text_en: string;
      fill?: string;
      fontSize?: number;
      anchor?: 'start' | 'middle' | 'end';
      bold?: boolean;
    };

export interface SvgDiagramSpec {
  type: 'SVG_DIAGRAM';
  title_hi: string;
  title_en: string;
  caption_hi: string;
  caption_en: string;
  viewBox: string;
  elements: SafeSvgElement[];
}

export interface ComparisonTableSpec {
  type: 'COMPARISON_TABLE';
  title_hi: string;
  title_en: string;
  caption_hi?: string;
  caption_en?: string;
  headers_hi: string[];
  headers_en: string[];
  rows: Array<{
    cells_hi: string[];
    cells_en: string[];
  }>;
}

export interface FlowchartDiagramSpec {
  type: 'FLOWCHART';
  title_hi: string;
  title_en: string;
  caption_hi?: string;
  caption_en?: string;
  direction: 'TB' | 'LR';
  steps: Array<{
    id: string;
    label_hi: string;
    label_en: string;
    detail_hi?: string;
    detail_en?: string;
    accent?: 'indigo' | 'amber' | 'emerald' | 'slate';
  }>;
  edges: Array<{
    from: string;
    to: string;
    label_hi?: string;
    label_en?: string;
  }>;
}

export interface TimelineDiagramSpec {
  type: 'TIMELINE';
  title_hi: string;
  title_en: string;
  caption_hi?: string;
  caption_en?: string;
  events: Array<{
    year: string;
    title_hi: string;
    title_en: string;
    detail_hi: string;
    detail_en: string;
    highlight?: boolean;
  }>;
}

export interface FormulaCardSpec {
  type: 'FORMULA_CARD';
  title_hi: string;
  title_en: string;
  formulas: Array<{
    latex: string;
    meaning_hi: string;
    meaning_en: string;
    unit?: string;
    example_hi?: string;
    example_en?: string;
  }>;
}

export type BilingualDiagramSpec =
  | SvgDiagramSpec
  | ComparisonTableSpec
  | FlowchartDiagramSpec
  | TimelineDiagramSpec
  | FormulaCardSpec;

export interface GlossaryTerm {
  term_hi: string;
  term_en: string;
  definition_hi: string;
  definition_en: string;
}

export interface NoteSection {
  id: string;
  order: number;
  heading_hi: string;
  heading_en: string;
  analogy_hi: string;
  analogy_en: string;
  visual_diagram?: BilingualDiagramSpec;
  concept_md_hi: string;
  concept_md_en: string;
  exam_tip_hi: string;
  exam_tip_en: string;
  glossary_terms: GlossaryTerm[];
  quick_check?: {
    q_hi: string;
    q_en: string;
    answer_hi: string;
    answer_en: string;
  };
}

export interface BoardCapsuleSpec {
  important_formulas: Array<{
    latex: string;
    label_hi: string;
    label_en: string;
    when_to_use_hi?: string;
    when_to_use_en?: string;
  }>;
  key_dates_or_facts: Array<{
    tag: string;
    fact_hi: string;
    fact_en: string;
  }>;
  common_bseb_mistakes: Array<{
    mistake_hi: string;
    mistake_en: string;
    fix_hi: string;
    fix_en: string;
  }>;
  high_yield_pyq_topics: Array<{
    topic_hi: string;
    topic_en: string;
    years: string[];
    expected_marks: number;
  }>;
}

export interface QualityChecksSpec {
  hindi_reviewed: boolean;
  english_reviewed: boolean;
  visuals_count: number;
  analogy_count: number;
  bseb_pyq_mapped: boolean;
  syllabus_year: string;
  reviewer_notes?: string;
}

export interface LessonPlanTeachingStep {
  period_no: number;
  duration_mins: number;
  phase_hi: string;
  phase_en: string;
  teacher_action_hi: string;
  teacher_action_en: string;
  student_check_hi: string;
  student_check_en: string;
}

export interface LessonPlanBlackboardPoint {
  heading_hi: string;
  heading_en: string;
  points_hi: string[];
  points_en: string[];
}

export interface LessonPlanActivity {
  title_hi: string;
  title_en: string;
  materials_hi: string;
  materials_en: string;
  steps_hi: string;
  steps_en: string;
}

export interface LessonPlanHomework {
  level: 'FOUNDATION' | 'BOARD' | 'CHALLENGE';
  task_hi: string;
  task_en: string;
}

export interface StudentMisconception {
  misconception_hi: string;
  misconception_en: string;
  correction_hi: string;
  correction_en: string;
}

export interface QuestionOption {
  key: 'A' | 'B' | 'C' | 'D';
  text_hi: string;
  text_en: string;
}

export interface MarkingSchemeItem {
  step_no: number;
  marks: number;
  criterion_hi: string;
  criterion_en: string;
}

export interface MemoryCueItem {
  cue_hi: string;
  cue_en: string;
}

export type VisualAsset =
  | {
      kind: 'MATCH_PAIRS';
      instruction_hi: string;
      instruction_en: string;
      pairs: Array<{
        id: string;
        left_hi: string;
        left_en: string;
        right_hi: string;
        right_en: string;
      }>;
    }
  | {
      kind: 'DIAGRAM_LABEL';
      instruction_hi: string;
      instruction_en: string;
      diagram: SvgDiagramSpec;
      hotspots: Array<{
        id: string;
        x: number;
        y: number;
        label_code: string;
        answer_hi: string;
        answer_en: string;
        options_hi: string[];
        options_en: string[];
      }>;
    }
  | {
      kind: 'FLASHCARD';
      front_hi: string;
      front_en: string;
      back_hi: string;
      back_en: string;
      mnemonic_hi?: string;
      mnemonic_en?: string;
      formula_latex?: string;
    }
  | {
      kind: 'INLINE_DIAGRAM';
      diagram: BilingualDiagramSpec;
    };

export interface ExamSnapshotQuestion {
  question_id: string;
  question_type: QuestionType;
  difficulty_tier: DifficultyTier;
  exam_year_tag: string | null;
  q_hi: string;
  q_en: string;
  options_json: QuestionOption[] | null;
  correct_option: string | null;
  explanation_hi: string | null;
  explanation_en: string | null;
  visual_asset_json: VisualAsset | null;
  marks: number;
}

export interface StudentBadge {
  code: string;
  title_hi: string;
  title_en: string;
  earned_at: string;
}

export interface SyncConflictItem {
  row_number: number;
  code: string;
  name: string;
  reason: string;
  existing_school_udise?: string;
}

export interface AiExtractedQuestionDraft {
  temp_id: string;
  question_type: QuestionType;
  difficulty_tier: DifficultyTier;
  topic_tag?: string;
  exam_year_tag?: string;
  q_hi: string;
  q_en: string;
  options_json?: QuestionOption[] | null;
  correct_option?: string | null;
  clue_hi?: string | null;
  clue_en?: string | null;
  explanation_hi?: string | null;
  explanation_en?: string | null;
  model_answer_hi?: string | null;
  model_answer_en?: string | null;
  marking_scheme_json?: MarkingSchemeItem[];
  confidence: 'HIGH' | 'MEDIUM' | 'LOW';
  ocr_warning?: string | null;
  duplicate_question_id?: string | null;
  duplicate_similarity?: number | null;
}

export interface AiExtractionProgress {
  total_pages?: number;
  processed_pages: number;
  extracted_count: number;
  last_chunk_at?: string;
  errors?: string[];
}

// =============================================================================
// TABLE ROW INTERFACES (1:1 WITH 001_v2_multitenant_schema.sql)
// =============================================================================

export interface SuperAdminRow {
  id: string;
  email: string;
  full_name: string;
  password_hash: string;
  totp_secret: string | null;
  totp_enabled: boolean;
  recovery_codes_hash: string[];
  is_active: boolean;
  token_version: number;
  created_at: string;
  updated_at: string;
}

export interface SchoolRow {
  udise_code: string;
  school_name: string;
  school_name_hi: string | null;
  district_code: string | null;
  district_name: string;
  block_code: string | null;
  block_name: string | null;
  cluster_code: string | null;
  cluster_name: string | null;
  board: string;
  status: SchoolStatus;
  drive_folder_id: string | null;
  onboarded_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface TeacherRow {
  id: string;
  teacher_code: string;
  full_name: string;
  teacher_title: string | null;
  mobile_hash: string | null;
  mobile_last4: string | null;
  password_hash: string;
  must_change_password: boolean;
  activation_code_hash: string | null;
  reset_code_hash: string | null;
  reset_code_expires_at: string | null;
  token_version: number;
  created_at: string;
  updated_at: string;
}

export interface SchoolTeacherRow {
  id: string;
  school_udise: string;
  teacher_id: string;
  is_school_admin: boolean;
  is_active: boolean;
  subjects_configured: boolean;
  assigned_classes: ClassNum[];
  assigned_subject_ids: string[];
  joined_at: string;
  deactivated_at: string | null;
}

export interface StudentRow {
  id: string;
  student_code: string | null;
  school_udise: string;
  student_name: string;
  father_name: string | null;
  dob: string;
  gender: string | null;
  class_num: ClassNum;
  stream: StudentStream;
  section: string;
  roll_no: number;
  academic_year: string;
  preferred_lang: LanguageMode;
  is_active: boolean;
  subjects_configured: boolean;
  subject_changes_count: number;
  pin_hash: string | null;
  mastery_points: number;
  weekly_points: number;
  streak_days: number;
  last_active_ist: string | null;
  week_start_ist: string | null;
  badges: StudentBadge[];
  token_version: number;
  created_at: string;
  updated_at: string;
}

export interface UserSessionRow {
  id: string;
  token_hash: string;
  role: UserRole;
  principal_id: string;
  school_udise: string | null;
  active_workspace: string | null;
  token_version: number;
  user_agent_hash: string | null;
  expires_at: string;
  revoked_at: string | null;
  created_at: string;
}

export interface AuthRateLimitRow {
  bucket_key: string;
  attempts: number;
  window_start: string;
  blocked_until: string | null;
}

export interface SyncLogRow {
  id: string;
  school_udise: string | null;
  sync_type: SyncType;
  performed_by_role: string;
  performed_by_id: string;
  added_count: number;
  updated_count: number;
  deactivated_count: number;
  skipped_count: number;
  conflicts_json: SyncConflictItem[];
  created_at: string;
}

export interface AuditLogRow {
  id: string;
  school_udise: string | null;
  actor_role: string;
  actor_id: string | null;
  action: string;
  target_type: string | null;
  target_id: string | null;
  meta_json: Record<string, unknown>;
  created_at: string;
}

export interface SubjectRow {
  id: string;
  bseb_code: string;
  class_num: ClassNum;
  stream: SubjectStream;
  category: SubjectCategory;
  name_en: string;
  name_hi: string;
  icon_name: string;
  accent_color: string;
  sort_order: number;
}

export interface StudentSubjectRow {
  student_id: string;
  academic_year: string;
  subject_id: string;
  slot_type: SubjectCategory;
  created_at: string;
}

export interface ChapterRow {
  id: string;
  subject_id: string;
  chapter_no: number;
  title_en: string;
  title_hi: string;
  summary_en: string | null;
  summary_hi: string | null;
  bseb_weightage_marks: number;
  estimated_mins: number;
  is_published: boolean;
}

export interface ChapterNoteRow {
  id: string;
  chapter_id: string;
  mindmap_json: MindmapSpec;
  sections_json: NoteSection[];
  board_capsule_json: BoardCapsuleSpec;
  quality_checks_json: QualityChecksSpec;
  status: NoteStatus;
  version: number;
  updated_at: string;
}

export interface LessonPlanRow {
  id: string;
  chapter_id: string;
  duration_periods: number;
  objectives_hi: string;
  objectives_en: string;
  teaching_steps_json: LessonPlanTeachingStep[];
  blackboard_points_json: LessonPlanBlackboardPoint[];
  classroom_activities_json: LessonPlanActivity[];
  homework_json: LessonPlanHomework[];
  common_student_misconceptions_json: StudentMisconception[];
  updated_at: string;
}

export interface MediaObjectRow {
  id: string;
  drive_file_id: string | null;
  school_udise: string | null;
  scope: MediaScope;
  owner_role: string;
  owner_id: string;
  original_filename: string;
  mime_type: string;
  size_bytes: number;
  status: MediaStatus;
  created_at: string;
  updated_at: string;
}

export interface SystemOAuthTokenRow {
  provider: string;
  encrypted_access_token: string;
  expires_at: string;
  refresh_locked_until: string | null;
  updated_at: string;
}

export interface QuestionSubmissionRow {
  id: string;
  school_udise: string;
  teacher_id: string;
  subject_id: string;
  chapter_id: string | null;
  topic_hint: string | null;
  source_type: SubmissionSourceType;
  media_object_id: string;
  status: SubmissionStatus;
  ai_extracted_json: AiExtractedQuestionDraft[] | null;
  ai_progress_json: AiExtractionProgress | null;
  ai_model_used: string | null;
  reviewed_by: string | null;
  review_feedback: string | null;
  approved_count: number;
  locked_at: string | null;
  created_at: string;
  reviewed_at: string | null;
}

export interface QuestionRow {
  id: string;
  subject_id: string;
  chapter_id: string;
  topic_tag: string | null;
  bank_pool: QuestionBankPool;
  question_type: QuestionType;
  difficulty_tier: DifficultyTier;
  exam_year_tag: string | null;
  q_hi: string;
  q_en: string;
  options_json: QuestionOption[] | null;
  correct_option: string | null;
  clue_hi: string | null;
  clue_en: string | null;
  explanation_hi: string | null;
  explanation_en: string | null;
  model_answer_hi: string | null;
  model_answer_en: string | null;
  memory_cues_json: MemoryCueItem[];
  marking_scheme_json: MarkingSchemeItem[];
  visual_asset_json: VisualAsset | null;
  source_submission_id: string | null;
  contributed_by_teacher: string | null;
  is_published: boolean;
  created_at: string;
}

export interface StudentChapterProgressRow {
  student_id: string;
  chapter_id: string;
  notes_completed: boolean;
  notes_progress_pct: number;
  flashcards_mastered: number;
  practice_attempted: number;
  practice_correct: number;
  mastery_pct: number;
  last_studied_at: string;
}

export interface StudentQuestionMasteryRow {
  student_id: string;
  question_id: string;
  attempts_count: number;
  correct_count: number;
  streak_correct: number;
  is_bookmarked: boolean;
  last_answered_at: string;
}

export interface StudentRevisionQueueRow {
  student_id: string;
  question_id: string;
  chapter_id: string;
  wrong_count: number;
  ease_factor: number;
  interval_days: number;
  next_review_ist: string;
  resolved: boolean;
  updated_at: string;
}

export interface PracticeSessionRow {
  attempt_id: string;
  student_id: string;
  school_udise: string;
  subject_id: string;
  chapter_id: string | null;
  mode: PracticeMode;
  total_questions: number;
  correct_count: number;
  points_awarded: number;
  time_spent_seconds: number;
  created_at: string;
}

export interface TeacherMaterialRow {
  id: string;
  school_udise: string;
  teacher_id: string;
  subject_id: string;
  chapter_id: string | null;
  class_num: ClassNum;
  title: string;
  description: string | null;
  material_type: TeacherMaterialType;
  body_markdown: string | null;
  media_object_id: string | null;
  youtube_video_id: string | null;
  is_pinned: boolean;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
}

export interface OpenDoubtRow {
  id: string;
  school_udise: string;
  academic_year: string;
  student_id: string;
  subject_id: string;
  chapter_id: string | null;
  class_num: ClassNum;
  question_text: string;
  media_object_id: string | null;
  status: DoubtStatus;
  is_pinned: boolean;
  is_hidden: boolean;
  hidden_by: string | null;
  upvote_count: number;
  created_at: string;
  updated_at: string;
}

export interface DoubtUpvoteRow {
  doubt_id: string;
  student_id: string;
  created_at: string;
}

export interface DoubtAnswerRow {
  id: string;
  doubt_id: string;
  teacher_id: string;
  answer_text: string;
  media_object_id: string | null;
  is_hidden: boolean;
  created_at: string;
}

export interface ExamRow {
  id: string;
  school_udise: string;
  academic_year: string;
  created_by_teacher: string;
  title: string;
  exam_mode: ExamMode;
  scope_type: ExamScopeType;
  class_num: ClassNum;
  stream: ExamStream;
  subject_id: string;
  chapter_ids: string[];
  room_pin: string | null;
  duration_mins: number;
  starts_at: string | null;
  ends_at: string | null;
  show_solutions_policy: ExamSolutionPolicy;
  question_ids: string[];
  questions_snapshot: ExamSnapshotQuestion[];
  shuffle_questions: boolean;
  shuffle_options: boolean;
  status: ExamStatus;
  created_at: string;
  ended_at: string | null;
}

export interface ExamAttemptRow {
  id: string;
  exam_id: string;
  school_udise: string;
  academic_year: string;
  student_id: string;
  shuffle_seed: string;
  question_order_json: Array<{
    question_id: string;
    option_order: Array<'A' | 'B' | 'C' | 'D'>;
  }>;
  answers_json: Record<string, string>;
  status: ExamAttemptStatus;
  answered_count: number;
  score: number;
  total_questions: number;
  accuracy: number;
  tab_switches: number;
  time_taken_seconds: number;
  started_at: string | null;
  submitted_at: string | null;
}

export interface LiveExamRosterRow {
  exam_id: string;
  student_id: string;
  school_udise: string;
  student_name: string;
  roll_no: number;
  status: ExamAttemptStatus;
  answered_count: number;
  total_questions: number;
  score: number;
  accuracy: number;
  tab_switches: number;
  updated_at: string;
}

// =============================================================================
// SUPABASE TYPED DATABASE SCHEMA HELPER
// =============================================================================

type TableDef<Row, OptionalInsert extends keyof Row = never> = {
  Row: Row;
  Insert: Omit<Row, OptionalInsert> & Partial<Pick<Row, OptionalInsert>>;
  Update: Partial<Row>;
  Relationships: [];
};

export interface Database {
  public: {
    Tables: {
      super_admins: TableDef<
        SuperAdminRow,
        'id' | 'totp_secret' | 'totp_enabled' | 'recovery_codes_hash' | 'is_active' | 'token_version' | 'created_at' | 'updated_at'
      >;
      schools: TableDef<
        SchoolRow,
        'school_name_hi' | 'district_code' | 'block_code' | 'block_name' | 'cluster_code' | 'cluster_name' | 'board' | 'status' | 'drive_folder_id' | 'onboarded_by' | 'created_at' | 'updated_at'
      >;
      teachers: TableDef<
        TeacherRow,
        'id' | 'teacher_title' | 'mobile_hash' | 'mobile_last4' | 'must_change_password' | 'activation_code_hash' | 'reset_code_hash' | 'reset_code_expires_at' | 'token_version' | 'created_at' | 'updated_at'
      >;
      school_teachers: TableDef<
        SchoolTeacherRow,
        'id' | 'is_school_admin' | 'is_active' | 'subjects_configured' | 'assigned_classes' | 'assigned_subject_ids' | 'joined_at' | 'deactivated_at'
      >;
      students: TableDef<
        StudentRow,
        'id' | 'student_code' | 'father_name' | 'gender' | 'stream' | 'section' | 'academic_year' | 'preferred_lang' | 'is_active' | 'subjects_configured' | 'subject_changes_count' | 'pin_hash' | 'mastery_points' | 'weekly_points' | 'streak_days' | 'last_active_ist' | 'week_start_ist' | 'badges' | 'token_version' | 'created_at' | 'updated_at'
      >;
      user_sessions: TableDef<
        UserSessionRow,
        'id' | 'school_udise' | 'active_workspace' | 'token_version' | 'user_agent_hash' | 'revoked_at' | 'created_at'
      >;
      auth_rate_limits: TableDef<
        AuthRateLimitRow,
        'attempts' | 'window_start' | 'blocked_until'
      >;
      sync_logs: TableDef<
        SyncLogRow,
        'id' | 'school_udise' | 'added_count' | 'updated_count' | 'deactivated_count' | 'skipped_count' | 'conflicts_json' | 'created_at'
      >;
      audit_logs: TableDef<
        AuditLogRow,
        'id' | 'school_udise' | 'actor_id' | 'target_type' | 'target_id' | 'meta_json' | 'created_at'
      >;
      subjects: TableDef<SubjectRow, 'icon_name' | 'accent_color' | 'sort_order'>;
      student_subjects: TableDef<StudentSubjectRow, 'academic_year' | 'created_at'>;
      chapters: TableDef<
        ChapterRow,
        'summary_en' | 'summary_hi' | 'bseb_weightage_marks' | 'estimated_mins' | 'is_published'
      >;
      chapter_notes: TableDef<
        ChapterNoteRow,
        'id' | 'board_capsule_json' | 'quality_checks_json' | 'status' | 'version' | 'updated_at'
      >;
      lesson_plans: TableDef<
        LessonPlanRow,
        'id' | 'duration_periods' | 'teaching_steps_json' | 'blackboard_points_json' | 'classroom_activities_json' | 'homework_json' | 'common_student_misconceptions_json' | 'updated_at'
      >;
      media_objects: TableDef<
        MediaObjectRow,
        'id' | 'drive_file_id' | 'school_udise' | 'size_bytes' | 'status' | 'created_at' | 'updated_at'
      >;
      system_oauth_tokens: TableDef<
        SystemOAuthTokenRow,
        'encrypted_access_token' | 'expires_at' | 'refresh_locked_until' | 'updated_at'
      >;
      question_submissions: TableDef<
        QuestionSubmissionRow,
        'id' | 'chapter_id' | 'topic_hint' | 'status' | 'ai_extracted_json' | 'ai_progress_json' | 'ai_model_used' | 'reviewed_by' | 'review_feedback' | 'approved_count' | 'locked_at' | 'created_at' | 'reviewed_at'
      >;
      questions: TableDef<
        QuestionRow,
        'id' | 'topic_tag' | 'bank_pool' | 'difficulty_tier' | 'exam_year_tag' | 'options_json' | 'correct_option' | 'clue_hi' | 'clue_en' | 'explanation_hi' | 'explanation_en' | 'model_answer_hi' | 'model_answer_en' | 'memory_cues_json' | 'marking_scheme_json' | 'visual_asset_json' | 'source_submission_id' | 'contributed_by_teacher' | 'is_published' | 'created_at'
      >;
      student_chapter_progress: TableDef<
        StudentChapterProgressRow,
        'notes_completed' | 'notes_progress_pct' | 'flashcards_mastered' | 'practice_attempted' | 'practice_correct' | 'mastery_pct' | 'last_studied_at'
      >;
      student_question_mastery: TableDef<
        StudentQuestionMasteryRow,
        'attempts_count' | 'correct_count' | 'streak_correct' | 'is_bookmarked' | 'last_answered_at'
      >;
      student_revision_queue: TableDef<
        StudentRevisionQueueRow,
        'wrong_count' | 'ease_factor' | 'interval_days' | 'resolved' | 'updated_at'
      >;
      practice_sessions: TableDef<
        PracticeSessionRow,
        'chapter_id' | 'total_questions' | 'correct_count' | 'points_awarded' | 'time_spent_seconds' | 'created_at'
      >;
      teacher_materials: TableDef<
        TeacherMaterialRow,
        'id' | 'chapter_id' | 'description' | 'body_markdown' | 'media_object_id' | 'youtube_video_id' | 'is_pinned' | 'is_deleted' | 'created_at' | 'updated_at'
      >;
      open_doubts: TableDef<
        OpenDoubtRow,
        'id' | 'academic_year' | 'chapter_id' | 'media_object_id' | 'status' | 'is_pinned' | 'is_hidden' | 'hidden_by' | 'upvote_count' | 'created_at' | 'updated_at'
      >;
      doubt_upvotes: TableDef<DoubtUpvoteRow, 'created_at'>;
      doubt_answers: TableDef<
        DoubtAnswerRow,
        'id' | 'media_object_id' | 'is_hidden' | 'created_at'
      >;
      exams: TableDef<
        ExamRow,
        'id' | 'academic_year' | 'stream' | 'chapter_ids' | 'room_pin' | 'starts_at' | 'ends_at' | 'show_solutions_policy' | 'question_ids' | 'questions_snapshot' | 'shuffle_questions' | 'shuffle_options' | 'status' | 'created_at' | 'ended_at'
      >;
      exam_attempts: TableDef<
        ExamAttemptRow,
        'id' | 'academic_year' | 'question_order_json' | 'answers_json' | 'status' | 'answered_count' | 'score' | 'total_questions' | 'accuracy' | 'tab_switches' | 'time_taken_seconds' | 'started_at' | 'submitted_at'
      >;
      live_exam_roster: TableDef<
        LiveExamRosterRow,
        'status' | 'answered_count' | 'total_questions' | 'score' | 'accuracy' | 'tab_switches' | 'updated_at'
      >;
    };
    Views: Record<string, never>;
    Functions: {
      acquire_oauth_refresh_lease: {
        Args: { p_provider: string; p_lock_key: number; p_lease_seconds?: number };
        Returns: boolean;
      };
      release_oauth_refresh_lease: {
        Args: { p_provider: string };
        Returns: void;
      };
      find_similar_questions: {
        Args: {
          p_subject_id: string;
          p_q_en: string;
          p_q_hi: string;
          p_threshold?: number;
          p_limit?: number;
        };
        Returns: Array<{
          id: string;
          chapter_id: string;
          question_type: QuestionType;
          q_hi: string;
          q_en: string;
          sim_score: number;
        }>;
      };
    };
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
}
