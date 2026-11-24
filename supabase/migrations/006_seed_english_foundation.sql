-- =============================================================================
-- Students of Bihar (9-12) — English Zero-to-Board Foundation & Grammar Lab
-- Migration: 006_seed_english_foundation.sql
-- Subject  : skill-eng-foundation (Universal Track for Classes 9, 10, 11 & 12)
--
-- 5 Complete Zero-Fear Foundational Units + 5 40-Min Teacher Lesson Plans +
-- 134 Multi-Mode Questions (25 Sentence Builders, 13 Visual Scenario Labs,
-- 15 Flashcards with Hindi Pronunciation, 10 Match Pairs, 45 Practice MCQs,
-- 15 Unseen Exam-Only MCQs, 5 Short 2M & 6 Long 5M BSEB Model Answers).
--
-- 100% Idempotent (ON CONFLICT DO UPDATE with deterministic UUIDs in namespace
-- 10000006-0001..0005-4000-8000-0000000000XX — zero collisions with 003/005/007).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CHAPTERS CATALOG (5 Zero-to-Board Units under skill-eng-foundation)
-- -----------------------------------------------------------------------------

INSERT INTO public.chapters (
  id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published
) VALUES
  ('skill-eng-f-ch1', 'skill-eng-foundation', 1, 'Sentence Building From Zero (S + V + O & is / am / are / was / were)', 'शून्य से अंग्रेज़ी वाक्य बनाना सीखें (S + V + O और is / am / are / was / were)', 'Remove fear of English in 3 minutes! Bridge Hindi S-O-V to English S-V-O visually, master all 7 pronouns, and build confident sentences with is/am/are, was/were, and has/have/had.', 'पहले 3 मिनट में अंग्रेज़ी का डर भगाएँ! हिंदी के S-O-V से अंग्रेज़ी के S-V-O का सरल चित्र पुल समझें, सातों सर्वनाम (Pronouns) और is/am/are, was/were, has/have/had से सही वाक्य बनाना सीखें।', 8, 25, true),
  ('skill-eng-f-ch2', 'skill-eng-foundation', 2, 'Tenses Visual Timeline Method', 'काल (Tenses) — सबसे आसान चित्र विधि', 'Master Past, Present, and Future on ONE visual timeline! Learn Simple, Continuous, and Perfect rules at a glance and fix the top Bihar tense errors ("He go", "I am knowing", "Did he went?").', 'केवल एक सरल समय-रेखा (Visual Timeline) से भूत, वर्तमान और भविष्य काल हमेशा के लिए समझें! Simple, Continuous और Perfect नियम एक नज़र में याद करें और बिहार बोर्ड की सबसे आम गलतियाँ सुधारें।', 10, 30, true),
  ('skill-eng-f-ch3', 'skill-eng-foundation', 3, 'Articles (a, an, the) & Prepositions Visual Picture Map', 'आर्टिकल्स (a, an, the) और प्रीपोज़िशन — चित्र विधि', 'Solve a/an/the in 2 seconds using the Hindi vowel-sound (अ–अः) ear test (an hour, a university, an MLA) and visually master in, on, under, into, between, behind, and at on a room picture map!', 'हिंदी स्वर-ध्वनि (अ–अः) के 2-सेकंड नियम से a/an/the (an hour, a university, an MLA) हमेशा के लिए पक्का करें, और मेज़-गेंद के सजीव चित्र से in, on, under, into, between, behind और at आसानी से सीखें!', 8, 25, true),
  ('skill-eng-f-ch4', 'skill-eng-foundation', 4, 'Active–Passive Voice, Narration & Modals (BSEB High-Score Grammar)', 'वाच्य (Voice), कथन (Narration) और मॉडल्स — 15+ पक्के बोर्ड अंक', 'Score 15+ guaranteed BSEB objective marks with the visual Active–Passive X-swap method, 1-glance Narration tense-backshift & SON/123 table, and crystal-clear Modals (can, could, may, must, should).', 'Active–Passive की X-क्रॉस चित्र विधि, Narration की 1-नज़र बैकशिफ्ट व SON/123 तालिका और Modals (can/could/may/must/should) से बिहार बोर्ड में 15+ पक्के अंक प्राप्त करें!', 15, 30, true),
  ('skill-eng-f-ch5', 'skill-eng-foundation', 5, 'Board Writing Mastery: Applications, Letters, Essays & Unseen Passages', 'आवेदन पत्र, निबंध और अपठित गद्यांश — 20 पक्के अंक', 'Master ONE clean Principal Application skeleton that solves 10 BSEB exam topics (Sick Leave, Fee Concession, TC, Library, Character Certificate), the 3-Box Easy Essay method, and the 3-Step Unseen Passage keyword-match trick for 20 guaranteed board marks!', 'केवल एक जादुई प्रधानाचार्य आवेदन ढाँचे से 10 अलग-अलग बोर्ड प्रश्न हल करें (बीमारी छुट्टी, शुल्क माफ़ी, TC, पुस्तकालय, चरित्र प्रमाणपत्र), 3-बॉक्स आसान निबंध विधि और 3-कदम अपठित गद्यांश ट्रिक से 20 पक्के अंक पाएँ!', 20, 30, true)
ON CONFLICT (id) DO UPDATE SET
  subject_id           = EXCLUDED.subject_id,
  chapter_no           = EXCLUDED.chapter_no,
  title_en             = EXCLUDED.title_en,
  title_hi             = EXCLUDED.title_hi,
  summary_en           = EXCLUDED.summary_en,
  summary_hi           = EXCLUDED.summary_hi,
  bseb_weightage_marks = EXCLUDED.bseb_weightage_marks,
  estimated_mins       = EXCLUDED.estimated_mins,
  is_published         = EXCLUDED.is_published;

-- #############################################################################
-- UNIT 1 OF 5: skill-eng-f-ch1 — SENTENCE BUILDING FROM ZERO (S + V + O & IS / AM / ARE / WAS / WERE)
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-eng-f-ch1',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: शून्य से अंग्रेज़ी वाक्य निर्माण",
  "title_en": "30-Second Mindmap: Sentence Building From Zero",
  "read_time_seconds": 30,
  "central_node": {
    "id": "u1-root",
    "label_hi": "अंग्रेज़ी वाक्य (S + V + O)",
    "label_en": "English Sentence (S + V + O)",
    "subtitle_hi": "हिंदी में क्रिया अंत में · अंग्रेज़ी में क्रिया दूसरे स्थान पर!",
    "subtitle_en": "Hindi puts Verb at the end · English puts Verb in seat #2!"
  },
  "branches": [
    {
      "id": "u1-b1",
      "label_hi": "1. हिंदी बनाम अंग्रेज़ी क्रम",
      "label_en": "1. Hindi vs English Order",
      "color": "#1E3A8A",
      "formula_latex": "\\text{Subject} + \\text{Verb} + \\text{Object}",
      "children": [
        {
          "id": "u1-b1-c1",
          "label_hi": "हिंदी (S + O + V): मैं आम खाता हूँ।",
          "label_en": "Hindi (S + O + V): Main aam khata hoon."
        },
        {
          "id": "u1-b1-c2",
          "label_hi": "अंग्रेज़ी (S + V + O): I eat a mango.",
          "label_en": "English (S + V + O): I eat a mango."
        }
      ]
    },
    {
      "id": "u1-b2",
      "label_hi": "2. सात सर्वनाम (7 Pronouns)",
      "label_en": "2. Seven Super Pronouns",
      "color": "#059669",
      "children": [
        {
          "id": "u1-b2-c1",
          "label_hi": "I (मैं), We (हम), You (तुम/आप)",
          "label_en": "I, We, You (1st & 2nd Person)"
        },
        {
          "id": "u1-b2-c2",
          "label_hi": "He (वह-पुरुष), She (वह-स्त्री), It (यह), They (वे)",
          "label_en": "He, She, It, They (3rd Person)"
        }
      ]
    },
    {
      "id": "u1-b3",
      "label_hi": "3. होना (is/am/are · was/were)",
      "label_en": "3. Being Verbs (is/am/are · was/were)",
      "color": "#D97706",
      "children": [
        {
          "id": "u1-b3-c1",
          "label_hi": "I → am / was · He, She, It → is / was",
          "label_en": "I → am / was · He, She, It → is / was"
        },
        {
          "id": "u1-b3-c2",
          "label_hi": "We, You, They → are / were",
          "label_en": "We, You, They → are / were"
        }
      ]
    },
    {
      "id": "u1-b4",
      "label_hi": "4. पास होना (has/have/had) व प्रश्न",
      "label_en": "4. Ownership (has/have/had) & Questions",
      "color": "#7C3AED",
      "children": [
        {
          "id": "u1-b4-c1",
          "label_hi": "He/She/It → has · I/We/You/They → have · भूतकाल → had",
          "label_en": "He/She/It → has · I/We/You/They → have · Past → had"
        },
        {
          "id": "u1-b4-c2",
          "label_hi": "Negative में not जोड़ें · Question में सहायक क्रिया आगे लाएँ",
          "label_en": "Add not for Negative · Move Helping Verb to front for Question"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "u1-sec-1-sov-svo",
    "order": 1,
    "heading_hi": "1. पहले 3 मिनट में डर भगाएँ: हिंदी (S-O-V) से अंग्रेज़ी (S-V-O) का पुल",
    "heading_en": "1. Remove Fear in 3 Minutes: The Hindi (S-O-V) to English (S-V-O) Bridge",
    "analogy_hi": "मान लीजिए एक रेलगाड़ी के तीन डिब्बे हैं: **इंजन = Subject (कर्ता/काम करने वाला)**, **बीच का काम = Verb (क्रिया)**, और **सामान = Object (कर्म)**। हिंदी की गाड़ी में हम बोलते हैं — *\"मैं (S) + आम (O) + खाता हूँ (V)\"*। अंग्रेज़ी में कुछ भी कठिन नहीं है — बस **आख़िरी दो डिब्बों की सीट बदल दीजिए**: *\"I (S) + eat (V) + a mango (O)\"*! बस यही पूरी अंग्रेज़ी की बुनियाद है!",
    "analogy_en": "Imagine a 3-coach train: **Engine = Subject (doer)**, **Action = Verb**, and **Cargo = Object**. In Hindi, the verb sits in the last coach: *\"Main (S) + aam (O) + khata hoon (V)\"*. English simply swaps seats #2 and #3 so the verb sits right behind the engine: *\"I (S) + eat (V) + a mango (O)\"*! That single swap unlocks English!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "हिंदी (S-O-V) से अंग्रेज़ी (S-V-O) वाक्य परिवर्तन चित्र",
      "title_en": "Hindi (S-O-V) to English (S-V-O) Seat-Swap Diagram",
      "caption_hi": "Subject (कर्ता) हमेशा सीट 1 पर ही रहता है। अंग्रेज़ी बनाते समय बस Verb (क्रिया) को खींचकर सीट 2 पर ले आइए और Object (कर्म) सीट 3 पर चला जाएगा!",
      "caption_en": "The Subject always stays in Seat 1. To form an English sentence, simply pull the Verb into Seat 2 and move the Object to Seat 3!",
      "viewBox": "0 0 680 280",
      "elements": [
        {
          "kind": "label",
          "x": 30,
          "y": 26,
          "text_hi": "हिंदी क्रम (S + O + V):",
          "text_en": "Hindi Order (S + O + V):",
          "fill": "#475569",
          "fontSize": 13,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 42,
          "width": 175,
          "height": 64,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 117,
          "y": 66,
          "text_hi": "मैं (Subject)",
          "text_en": "Main (Subject)",
          "fill": "#1E3A8A",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 252,
          "y": 42,
          "width": 175,
          "height": 64,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 339,
          "y": 66,
          "text_hi": "आम (Object)",
          "text_en": "Aam (Object)",
          "fill": "#059669",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 474,
          "y": 42,
          "width": 175,
          "height": 64,
          "rx": 10,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 561,
          "y": 66,
          "text_hi": "खाता हूँ (Verb)",
          "text_en": "Khata hoon (Verb)",
          "fill": "#B45309",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 117,
          "y1": 108,
          "x2": 117,
          "y2": 180,
          "stroke": "#1E3A8A",
          "strokeWidth": 2.5
        },
        {
          "kind": "arrow",
          "x1": 545,
          "y1": 108,
          "x2": 355,
          "y2": 180,
          "stroke": "#D97706",
          "strokeWidth": 3
        },
        {
          "kind": "arrow",
          "x1": 355,
          "y1": 108,
          "x2": 545,
          "y2": 180,
          "stroke": "#059669",
          "strokeWidth": 2.5,
          "dashed": true
        },
        {
          "kind": "rect",
          "x": 266,
          "y": 126,
          "width": 150,
          "height": 34,
          "rx": 14,
          "fill": "#FFFFFF",
          "stroke": "#D97706",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 341,
          "y": 145,
          "text_hi": "सीट 2 व 3 बदलें!",
          "text_en": "Swap Seat 2 & 3!",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 30,
          "y": 176,
          "text_hi": "अंग्रेज़ी क्रम (S + V + O):",
          "text_en": "English Order (S + V + O):",
          "fill": "#0F172A",
          "fontSize": 13,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 186,
          "width": 175,
          "height": 68,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 117,
          "y": 212,
          "text_hi": "I (Subject)",
          "text_en": "I (Subject)",
          "fill": "#1E3A8A",
          "fontSize": 15,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 252,
          "y": 186,
          "width": 175,
          "height": 68,
          "rx": 10,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 339,
          "y": 212,
          "text_hi": "eat (Verb)",
          "text_en": "eat (Verb)",
          "fill": "#B45309",
          "fontSize": 15,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 474,
          "y": 186,
          "width": 175,
          "height": 68,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 561,
          "y": 212,
          "text_hi": "a mango (Object)",
          "text_en": "a mango (Object)",
          "fill": "#059669",
          "fontSize": 15,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### किसी भी सरल वाक्य के 3 हिस्से पहचानें\n1. **Subject (कर्ता — काम करने वाला):** सवाल पूछें **\"कौन?\"** → *मैं (I), सीता (Sita), हम (We)*।\n2. **Verb (क्रिया — काम या अवस्था):** वाक्य में क्या काम हो रहा है? → *eat (खाना), play (खेलना), read (पढ़ना), is (है)*।\n3. **Object (कर्म — जिस पर काम हो):** सवाल पूछें **\"क्या?\"** → *a mango (आम), cricket (क्रिकेट), a book (किताब)*।\n\n### 3 आसान अभ्यास उदाहरण (बोलकर पढ़ें!)\n- हम क्रिकेट खेलते हैं। → **We play cricket.** *(वी प्ले क्रिकेट)*\n- वे दूध पीते हैं। → **They drink milk.** *(दे ड्रिंक मिल्क)*\n- तुम अंग्रेज़ी सीखते हो। → **You learn English.** *(यू लर्न इंग्लिश)*\n\n**याद रखें:** अंग्रेज़ी वाक्य का पहला अक्षर हमेशा **Capital Letter (बड़ा अक्षर)** होता है और अंत में **Full Stop (.)** लगता है।",
    "concept_md_en": "### Identify the 3 Building Blocks of Any Sentence\n1. **Subject (Doer):** Ask **\"Who?\"** → *I, Sita, We, The boys*.\n2. **Verb (Action or State):** Ask **\"What action?\"** → *eat, play, read, is*.\n3. **Object (Receiver):** Ask **\"What?\"** → *a mango, cricket, a book*.\n\n### 3 Instant Warm-Up Examples (Read Aloud!)\n- We play cricket. *(हम क्रिकेट खेलते हैं।)*\n- They drink milk. *(वे दूध पीते हैं।)*\n- You learn English. *(तुम अंग्रेज़ी सीखते हो।)*\n\n**Remember:** Always start an English sentence with a **Capital Letter** and end with a **Full Stop (.)** (or `?` for questions).",
    "exam_tip_hi": "बिहार बोर्ड अनुवाद (Translation) में कभी भी हिंदी के शब्दों को उसी क्रम में मत लिखें (\"I mango eat\" गलत है!)। पहले कर्ता (S), फिर तुरंत क्रिया (V), फिर कर्म (O) लिखें — हर वाक्य सही होगा!",
    "exam_tip_en": "In BSEB translation questions, NEVER translate word-by-word in Hindi order (\"I mango eat\" is wrong!). Always write Subject first, Verb second, and Object third!",
    "glossary_terms": [
      {
        "term_hi": "कर्ता (Subject)",
        "term_en": "Subject",
        "pronunciation_hi": "सब्जेक्ट",
        "definition_hi": "वाक्य में काम करने वाला व्यक्ति या वस्तु। उदाहरण: Ravi, I, She।",
        "definition_en": "The person or thing doing the action in a sentence. Example: Ravi, I, She."
      },
      {
        "term_hi": "क्रिया (Verb)",
        "term_en": "Verb",
        "pronunciation_hi": "वर्ब",
        "definition_hi": "वाक्य में होने वाला काम (eat, go, write) या अवस्था (is, am, are)।",
        "definition_en": "The action word (eat, go, write) or state-of-being word (is, am, are)."
      },
      {
        "term_hi": "कर्म (Object)",
        "term_en": "Object",
        "pronunciation_hi": "ऑब्जेक्ट",
        "definition_hi": "जिस वस्तु या व्यक्ति पर क्रिया का फल पड़ता है। उदाहरण: a book, tea।",
        "definition_en": "The person or thing that receives the action of the verb. Example: a book, tea."
      }
    ],
    "quick_check": {
      "q_hi": "हिंदी वाक्य \"हम पानी पीते हैं।\" को सही S + V + O क्रम में अंग्रेज़ी में बदलें।",
      "q_en": "Arrange \"water / we / drink\" into the correct English S + V + O sentence.",
      "answer_hi": "**We drink water.** (Subject = We, Verb = drink, Object = water)",
      "answer_en": "**We drink water.** (Subject = We, Verb = drink, Object = water)"
    }
  },
  {
    "id": "u1-sec-2-pronouns-be",
    "order": 2,
    "heading_hi": "2. सात जादुई सर्वनाम (Pronouns) और is / am / are की पक्की दोस्ती",
    "heading_en": "2. Seven Super Pronouns & Their Exact is / am / are Partners",
    "analogy_hi": "क्रिकेट की टीम की तरह हर सर्वनाम (Pronoun) की अपनी पक्की जोड़ी है! **`I` (मैं)** बहुत खास है — उसका अपना निजी साथी **`am`** है (किसी और के साथ `am` कभी नहीं आता!)। **अकेले एक व्यक्ति (`He, She, It, Ram`)** के साथ हमेशा **`is`** आता है। और **एक से ज़्यादा या सम्मान वाले (`We, You, They, Boys`)** के साथ हमेशा **`are`** आता है!",
    "analogy_en": "Think of pronouns as team partners! **`I`** is special — it has its own exclusive partner **`am`** (no other word ever uses `am`!). **Any single person/thing (`He, She, It, Ram`)** pairs with **`is`**. **Plural groups and `You` (`We, You, They, Boys`)** always pair with **`are`**!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "सभी 7 Pronouns के साथ is / am / are और was / were की मास्टर तालिका",
      "title_en": "Master Partner Table: 7 Pronouns with is / am / are & was / were",
      "caption_hi": "ध्यान दें: You चाहे एक व्यक्ति के लिए हो या दस के लिए, इसके साथ हमेशा are और were ही लगता है!",
      "caption_en": "Notice: Even when You refers to one person, it ALWAYS takes are (present) and were (past)!",
      "headers_hi": [
        "Pronoun (उच्चारण)",
        "हिंदी अर्थ",
        "वर्तमान (है/हूँ/हैं)",
        "भूतकाल (था/थी/थे)",
        "सरल उदाहरण"
      ],
      "headers_en": [
        "Pronoun",
        "Meaning",
        "Present (Be)",
        "Past (Be)",
        "Simple Example"
      ],
      "rows": [
        {
          "cells_hi": [
            "I (आई)",
            "मैं",
            "am",
            "was",
            "I am a student. (मैं छात्र हूँ।)"
          ],
          "cells_en": [
            "I",
            "Self (1st Sing.)",
            "am",
            "was",
            "I am a student."
          ]
        },
        {
          "cells_hi": [
            "We (वी)",
            "हम / हम लोग",
            "are",
            "were",
            "We are happy. (हम खुश हैं।)"
          ],
          "cells_en": [
            "We",
            "1st Plural",
            "are",
            "were",
            "We are happy."
          ]
        },
        {
          "cells_hi": [
            "You (यू)",
            "तुम / आप",
            "are",
            "were",
            "You are honest. (आप ईमानदार हैं।)"
          ],
          "cells_en": [
            "You",
            "2nd Sing./Pl.",
            "are",
            "were",
            "You are honest."
          ]
        },
        {
          "cells_hi": [
            "He (ही)",
            "वह (लड़का/पुरुष)",
            "is",
            "was",
            "He is my brother. (वह मेरा भाई है।)"
          ],
          "cells_en": [
            "He",
            "3rd Male Sing.",
            "is",
            "was",
            "He is my brother."
          ]
        },
        {
          "cells_hi": [
            "She (शी)",
            "वह (लड़की/महिला)",
            "is",
            "was",
            "She is a doctor. (वह डॉक्टर है।)"
          ],
          "cells_en": [
            "She",
            "3rd Female Sing.",
            "is",
            "was",
            "She is a doctor."
          ]
        },
        {
          "cells_hi": [
            "It (इट)",
            "यह (वस्तु/पशु/मौसम)",
            "is",
            "was",
            "It is hot today. (आज गर्मी है।)"
          ],
          "cells_en": [
            "It",
            "Thing/Animal/Time",
            "is",
            "was",
            "It is hot today."
          ]
        },
        {
          "cells_hi": [
            "They (दे)",
            "वे / वे लोग",
            "are",
            "were",
            "They are farmers. (वे किसान हैं।)"
          ],
          "cells_en": [
            "They",
            "3rd Plural",
            "are",
            "were",
            "They are farmers."
          ]
        }
      ]
    },
    "concept_md_hi": "### `is / am / are` कब लगाएँ — और कब बिलकुल न लगाएँ!\n- **कब लगाएँ (अवस्था या परिचय बताने के लिए):** जब वाक्य में कोई मुख्य काम (खाना, जाना, खेलना) न हो, सिर्फ परिचय, गुण या स्थान हो:\n  - मैं बिहार से हूँ। → **I am from Bihar.** *(आई ऐम फ़्रॉम बिहार)*\n  - पटना एक बड़ा शहर है। → **Patna is a big city.** *(पटना इज़ अ बिग सिटी)*\n  - वे मेरे दोस्त हैं। → **They are my friends.** *(दे आर माई फ़्रेंड्स)*\n- **सबसे बड़ी गलती से बचें:** जब वाक्य में *\"मैं आम खाता हूँ\"* जैसा सीधा काम हो, तो **`am` मत लगाइए!**\n  - गलत: ~~I am eat a mango.~~\n  - सही: **I eat a mango.** (क्योंकि `am` के साथ या तो नाम/गुण आता है, या फिर `V-ing` आता है!) ",
    "concept_md_en": "### When to Use `is / am / are` — And When NOT To!\n- **Use `is / am / are` to describe identity, quality, or location** (no main action verb):\n  - **I am from Bihar.** (Identity / Origin)\n  - **Patna is a big city.** (Quality)\n  - **They are my friends.** (Relation)\n- **Avoid the #1 Bihar Student Trap:** Do NOT put `am/is/are` in front of a plain V1 verb!\n  - Wrong: ~~I am eat a mango.~~\n  - Right: **I eat a mango.** (`is/am/are` is followed by a noun/adjective OR an `-ing` verb, never plain V1!)",
    "exam_tip_hi": "एकवचन नाम (Ravi, Sita, The cow, Patna) हमेशा `is / was` लेते हैं। जब दो नाम `and` से जुड़ जाएँ (Ram and Shyam), तो वे बहुवचन बन जाते हैं और हमेशा **`are / were`** लेते हैं!",
    "exam_tip_en": "Any single name (Ravi, Sita, Patna) takes `is / was`. When two names are joined by `and` (Ram and Shyam), they become plural and ALWAYS take **`are / were`**!",
    "glossary_terms": [
      {
        "term_hi": "सर्वनाम (Pronoun)",
        "term_en": "Pronoun",
        "pronunciation_hi": "प्रोनाउन",
        "definition_hi": "संज्ञा (नाम) की जगह इस्तेमाल होने वाला शब्द, जैसे I, We, You, He, She, It, They।",
        "definition_en": "A word used in place of a noun/name, such as I, We, You, He, She, It, They."
      },
      {
        "term_hi": "एकवचन (Singular)",
        "term_en": "Singular",
        "pronunciation_hi": "सिंग्युलर",
        "definition_hi": "केवल एक व्यक्ति, वस्तु या स्थान (He, She, It, a boy, a pen)।",
        "definition_en": "Exactly one person, place, or thing (He, She, It, a boy, a pen)."
      },
      {
        "term_hi": "बहुवचन (Plural)",
        "term_en": "Plural",
        "pronunciation_hi": "प्लूरल",
        "definition_hi": "एक से अधिक व्यक्ति या वस्तुएँ (We, They, boys, pens)।",
        "definition_en": "More than one person, place, or thing (We, They, boys, pens)."
      }
    ],
    "quick_check": {
      "q_hi": "रिक्त स्थान भरें: \"Ravi and Aman ___ good players.\" (is / am / are)",
      "q_en": "Fill in the blank: \"Ravi and Aman ___ good players.\" (is / am / are)",
      "answer_hi": "**are** — क्योंकि Ravi and Aman दो लोग (बहुवचन) हैं!",
      "answer_en": "**are** — because Ravi and Aman make a plural subject (two people)!"
    }
  },
  {
    "id": "u1-sec-3-was-were-has-have",
    "order": 3,
    "heading_hi": "3. भूतकाल (was / were) और \"पास होना\" (has / have / had)",
    "heading_en": "3. Past State (was / were) & Showing Ownership (has / have / had)",
    "analogy_hi": "अपने स्कूल बैग में झाँकिए! आपके पास जो चीज़ें अभी हैं (पेन, किताब, साइकिल) उनके लिए **`has / have`** बोलिए — *\"मेरे पास एक पेन है → I have a pen\"*। और जो चीज़ पहले थी या कल की बात है, उसके लिए सबके साथ बिना झंझट **`had`** बोलिए — *\"मेरे पास एक साइकिल थी → I had a bicycle\"*!",
    "analogy_en": "Look inside your school bag! To say what someone owns right now, use **`has / have`**: *\"I have a pen\"*, *\"She has a book\"*. For the past (\"had\"), life is super easy — EVERY pronoun uses **`had`** without exception!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "was / were और has / have / had का सरल परिवार मानचित्र",
      "title_en": "Simple Partner Map for was / were and has / have / had",
      "caption_hi": "ध्यान से देखें: I के साथ was आता है लेकिन ownership में I के साथ have आता है (\"I have a book\", कभी \"I has\" नहीं!)। भूतकाल में सबके साथ had आता है!",
      "caption_en": "Look closely: I takes \"was\" in past being, but \"have\" for ownership (\"I have a book\", NEVER \"I has\"!). In past ownership, everyone shares \"had\"!",
      "viewBox": "0 0 680 265",
      "elements": [
        {
          "kind": "rect",
          "x": 24,
          "y": 18,
          "width": 300,
          "height": 228,
          "rx": 12,
          "fill": "#F8FAFC",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 174,
          "y": 44,
          "text_hi": "था / थी / थे (Past: was / were)",
          "text_en": "Past State (was / were)",
          "fill": "#1E3A8A",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 44,
          "y": 66,
          "width": 145,
          "height": 68,
          "rx": 8,
          "fill": "#EFF6FF",
          "stroke": "#2563EB",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 116,
          "y": 92,
          "text_hi": "I, He, She, It, Ram",
          "text_en": "I, He, She, It, Ram",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 192,
          "y1": 100,
          "x2": 230,
          "y2": 100,
          "stroke": "#2563EB",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 234,
          "y": 74,
          "width": 72,
          "height": 52,
          "rx": 8,
          "fill": "#1E3A8A",
          "stroke": "#1E3A8A",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 270,
          "y": 105,
          "text_hi": "was",
          "text_en": "was",
          "fill": "#FFFFFF",
          "fontSize": 15,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 44,
          "y": 154,
          "width": 145,
          "height": 68,
          "rx": 8,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 116,
          "y": 180,
          "text_hi": "We, You, They, Boys",
          "text_en": "We, You, They, Boys",
          "fill": "#059669",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 192,
          "y1": 188,
          "x2": 230,
          "y2": 188,
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 234,
          "y": 162,
          "width": 72,
          "height": 52,
          "rx": 8,
          "fill": "#059669",
          "stroke": "#059669",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 270,
          "y": 193,
          "text_hi": "were",
          "text_en": "were",
          "fill": "#FFFFFF",
          "fontSize": 15,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 356,
          "y": 18,
          "width": 300,
          "height": 228,
          "rx": 12,
          "fill": "#F8FAFC",
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 506,
          "y": 44,
          "text_hi": "पास होना (has / have / had)",
          "text_en": "Ownership (has / have / had)",
          "fill": "#B45309",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 374,
          "y": 64,
          "width": 148,
          "height": 52,
          "rx": 8,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 448,
          "y": 94,
          "text_hi": "He, She, It, Sita",
          "text_en": "He, She, It, Sita",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 525,
          "y1": 90,
          "x2": 560,
          "y2": 90,
          "stroke": "#D97706",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 564,
          "y": 66,
          "width": 74,
          "height": 48,
          "rx": 8,
          "fill": "#D97706",
          "stroke": "#D97706",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 601,
          "y": 95,
          "text_hi": "has",
          "text_en": "has",
          "fill": "#FFFFFF",
          "fontSize": 15,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 374,
          "y": 128,
          "width": 148,
          "height": 52,
          "rx": 8,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 448,
          "y": 158,
          "text_hi": "I, We, You, They",
          "text_en": "I, We, You, They",
          "fill": "#059669",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 525,
          "y1": 154,
          "x2": 560,
          "y2": 154,
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 564,
          "y": 130,
          "width": 74,
          "height": 48,
          "rx": 8,
          "fill": "#059669",
          "stroke": "#059669",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 601,
          "y": 159,
          "text_hi": "have",
          "text_en": "have",
          "fill": "#FFFFFF",
          "fontSize": 15,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 374,
          "y": 192,
          "width": 264,
          "height": 42,
          "rx": 8,
          "fill": "#F3E8FF",
          "stroke": "#7C3AED",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 506,
          "y": 215,
          "text_hi": "भूतकाल (सभी कर्ता) → had",
          "text_en": "Past (ALL subjects) → had",
          "fill": "#6D28D9",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### दो बहुत उपयोगी वाक्य पैटर्न\n1. **`was / were` (था / थी / थे):**\n   - कल मैं घर पर था। → **I was at home yesterday.** *(आई वॉज़ ऐट होम यस्टरडे)*\n   - वे अच्छे खिलाड़ी थे। → **They were good players.** *(दे वर गुड प्लेयर्स)*\n2. **`has / have / had` (पास होना / रखना):**\n   - मेरे पास दो किताबें हैं। → **I have two books.** *(आई हैव टू बुक्स)*\n   - उसके (लड़की) पास एक नई घड़ी है। → **She has a new watch.** *(शी हैज़ अ न्यू वॉच)*\n   - किसान के पास एक गाय थी। → **The farmer had a cow.** *(द फ़ार्मर हैड अ काउ)*",
    "concept_md_en": "### Two Super-Useful Everyday Patterns\n1. **`was / were` (Past State):**\n   - **I was at home yesterday.** *(Singular subject + `I` → `was`)*\n   - **They were good players.** *(Plural subject + `You` → `were`)*\n2. **`has / have / had` (Possession / Ownership):**\n   - **I have two books.** *(`I, We, You, They` → `have`)*\n   - **She has a new watch.** *(`He, She, It, Singular Noun` → `has`)*\n   - **The farmer had a cow.** *(All subjects in past → `had`)*",
    "exam_tip_hi": "BSEB बोर्ड का प्यारा सवाल: `I` एकवचन होने के बावजूद हमेशा **`have`** लेता है (*\"I have a pen\"*), जबकि भूतकाल में `I` के साथ **`was`** लगता है (*\"I was late\"*)!",
    "exam_tip_en": "BSEB Favourite Trap: Even though `I` is singular, it ALWAYS takes **`have`** (*\"I have a pen\"*), while in the past state it takes **`was`** (*\"I was late\"*)!",
    "glossary_terms": [
      {
        "term_hi": "अधिकार / स्वामित्व (Possession)",
        "term_en": "Possession",
        "pronunciation_hi": "पज़ेशन",
        "definition_hi": "किसी वस्तु का आपके पास होना — इसे दिखाने के लिए has, have या had लगाते हैं।",
        "definition_en": "Owning or having something — expressed using has, have, or had."
      },
      {
        "term_hi": "सहायक क्रिया (Helping Verb)",
        "term_en": "Helping Verb",
        "pronunciation_hi": "हेल्पिंग वर्ब",
        "definition_hi": "वे क्रियाएँ जो समय या प्रश्न/नकारात्मक रूप बनाने में मदद करती हैं (is, am, are, was, were, has, have)।",
        "definition_en": "Verbs that express tense/state and help form negatives and questions (is, am, are, was, were, has, have)."
      }
    ],
    "quick_check": {
      "q_hi": "\"उसके पास एक साइकिल है।\" का सही अंग्रेज़ी अनुवाद क्या होगा? (He have / He has)",
      "q_en": "Choose the right form: \"He ___ a bicycle.\" (have / has)",
      "answer_hi": "**He has a bicycle.** (क्योंकि `He` एकवचन Third Person है, इसलिए `has` लगेगा।)",
      "answer_en": "**He has a bicycle.** (`He` is third-person singular, so it takes `has`.)"
    }
  },
  {
    "id": "u1-sec-4-neg-question",
    "order": 4,
    "heading_hi": "4. \"नहीं\" (Negative) और \"क्या...?\" (Question) बनाना — बस 1 कदम का खेल!",
    "heading_en": "4. Making Negatives (\"not\") & Questions — Just One Simple Move!",
    "analogy_hi": "जैसे कमरे का बल्ब बंद करने के लिए बस एक स्विच दबाते हैं, वैसे ही किसी भी `is / am / are / was / were` वाले वाक्य को **नकारात्मक (Negative)** बनाने के लिए बस उनके ठीक बाद **`not`** चिपका दीजिए! और **प्रश्न (Question)** बनाने के लिए उन्हें उठाकर वाक्य की **सबसे आगे वाली सीट** पर बैठा दीजिए — पीछे `?` लगाइए, हो गया!",
    "analogy_en": "Just like flipping a light switch: to make any `is / am / are / was / were` sentence **Negative**, simply drop **`not`** right after it! To turn it into a **Yes/No Question**, simply move `Is / Am / Are / Was / Were` to the very front and add `?`!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "1 वाक्य से 3 वाक्य बनाने की जादुई मशीन",
      "title_en": "1-to-3 Sentence Transformer Machine",
      "caption_hi": "एक ही नियम is, am, are, was और were — पाँचों पर 100% काम करता है!",
      "caption_en": "The exact same 1-step move works for all five: is, am, are, was, and were!",
      "direction": "LR",
      "steps": [
        {
          "id": "st-aff",
          "label_hi": "1. साधारण वाक्य (Affirmative)",
          "label_en": "1. Positive Statement",
          "detail_hi": "He is a clever boy. (वह एक चतुर लड़का है।)",
          "detail_en": "He is a clever boy.",
          "accent": "indigo"
        },
        {
          "id": "st-neg",
          "label_hi": "2. नकारात्मक (+ not जोड़ें)",
          "label_en": "2. Negative (Add not)",
          "detail_hi": "He is NOT a clever boy. (वह चतुर लड़का नहीं है।)",
          "detail_en": "He is NOT a clever boy.",
          "accent": "amber"
        },
        {
          "id": "st-int",
          "label_hi": "3. प्रश्नवाचक (Is आगे लाएँ + ?)",
          "label_en": "3. Question (Move Is to front + ?)",
          "detail_hi": "IS he a clever boy? (क्या वह चतुर लड़का है?)",
          "detail_en": "IS he a clever boy?",
          "accent": "emerald"
        }
      ],
      "edges": [
        {
          "from": "st-aff",
          "to": "st-neg",
          "label_hi": "+ not",
          "label_en": "+ not"
        },
        {
          "from": "st-neg",
          "to": "st-int",
          "label_hi": "Is को आगे लाएँ",
          "label_en": "Move Is first"
        }
      ]
    },
    "concept_md_hi": "### एक नज़र में 3 और अभ्यास उदाहरण\n1. **Statement:** You are ready. *(तुम तैयार हो।)*\n   - **Negative:** You are **not** ready. *(तुम तैयार नहीं हो।)*\n   - **Question:** **Are** you ready? *(क्या तुम तैयार हो?)*\n2. **Statement:** She was absent yesterday. *(वह कल अनुपस्थित थी।)*\n   - **Negative:** She was **not** absent yesterday.\n   - **Question:** **Was** she absent yesterday?\n\n### \"क्या\" से शुरू होने वाले हिंदी प्रश्नों का बड़ा राज़!\nजब हिंदी प्रश्न **\"क्या\"** से शुरू हो (जिसका जवाब हाँ/ना में हो), तो कभी **`What`** से शुरू मत करें! सीधे `Is / Am / Are / Was / Were` को आगे रखें:\n- गलत: ~~What you are a student?~~\n- सही: **Are you a student?** *(आर यू अ स्टूडेंट?)*",
    "concept_md_en": "### 2 More Examples to Practice Aloud\n1. **Statement:** You are ready.\n   - **Negative:** You are **not** ready.\n   - **Question:** **Are** you ready?\n2. **Statement:** She was absent yesterday.\n   - **Negative:** She was **not** absent yesterday.\n   - **Question:** **Was** she absent yesterday?\n\n### Crucial Bihar Rule for \"Kya...?\" Yes/No Questions!\nWhen a Hindi question begins with **\"क्या\"** (answerable in Yes or No), NEVER start with **`What`**! Start directly with the helping verb (`Is / Am / Are / Was / Were`):\n- Wrong: ~~What you are a student?~~\n- Right: **Are you a student?**",
    "exam_tip_hi": "बोर्ड में Yes/No प्रश्न बनाते समय वाक्य के अंत में प्रश्नवाचक चिह्न (`?`) लगाना न भूलें — कई छात्र सही शब्द लिखकर भी `?` छूटने पर आधा अंक गँवा देते हैं!",
    "exam_tip_en": "Never forget the question mark (`?`) at the end of an interrogative sentence — omitting punctuation can cost half a mark in BSEB exams!",
    "glossary_terms": [
      {
        "term_hi": "नकारात्मक वाक्य (Negative)",
        "term_en": "Negative Sentence",
        "pronunciation_hi": "नेगेटिव सेंटेंस",
        "definition_hi": "जिस वाक्य में \"नहीं\" (not / no) का भाव हो। उदाहरण: He is not lazy.",
        "definition_en": "A sentence expressing denial using \"not\" or \"no\". Example: He is not lazy."
      },
      {
        "term_hi": "प्रश्नवाचक वाक्य (Interrogative)",
        "term_en": "Interrogative Sentence",
        "pronunciation_hi": "इंटरोगेटिव सेंटेंस",
        "definition_hi": "जिस वाक्य में कोई सवाल पूछा जाए और अंत में \"?\" लगे। उदाहरण: Are you happy?",
        "definition_en": "A sentence that asks a question and ends with \"?\". Example: Are you happy?"
      }
    ],
    "quick_check": {
      "q_hi": "\"क्या वह तुम्हारा मित्र है?\" का सही अंग्रेज़ी प्रश्न बनाएँ।",
      "q_en": "Turn \"He is your friend.\" into a Yes/No Question.",
      "answer_hi": "**Is he your friend?** (What नहीं लगाना है, बस `Is` को आगे लाना है!)",
      "answer_en": "**Is he your friend?** (Move `Is` to the front and add `?`!)"
    }
  },
  {
    "id": "u1-sec-5-formula-sheet",
    "order": 5,
    "heading_hi": "5. परीक्षा से पहले 1-नज़र वाक्य निर्माण सूत्र कार्ड",
    "heading_en": "5. 1-Glance Sentence Building Formula Card",
    "analogy_hi": "ये 6 छोटे सूत्र आपकी अंग्रेज़ी की \"मास्टर चाबी\" हैं — इन्हें एक बार ज़ोर से पढ़ लीजिए और आप बिना रुके सैकड़ों सही वाक्य खुद बनाने लगेंगे!",
    "analogy_en": "These 6 pocket formulas are your English master key — read them aloud once and you can build hundreds of clean sentences on your own!",
    "visual_diagram": {
      "type": "FORMULA_CARD",
      "title_hi": "इकाई 1 के 6 सुनहरे वाक्य सूत्र",
      "title_en": "6 Golden Sentence Formulas of Unit 1",
      "formulas": [
        {
          "latex": "\\text{Subject} + \\text{Verb} + \\text{Object}",
          "meaning_hi": "साधारण अंग्रेज़ी वाक्य क्रम (हिंदी S-O-V से अलग)",
          "meaning_en": "Core English word order (unlike Hindi S-O-V)",
          "example_hi": "I eat a mango. (मैं आम खाता हूँ।)",
          "example_en": "I eat a mango."
        },
        {
          "latex": "\\text{I} + \\text{am / was / have}",
          "meaning_hi": "I (मैं) के तीनों पक्के साथी",
          "meaning_en": "The 3 exact partners of I",
          "example_hi": "I am happy. / I was late. / I have a pen.",
          "example_en": "I am happy. / I was late. / I have a pen."
        },
        {
          "latex": "\\text{He / She / It / Name} + \\text{is / was / has}",
          "meaning_hi": "एकवचन (Singular) के तीनों साथी",
          "meaning_en": "The 3 exact partners of Singular subjects",
          "example_hi": "She is kind. / Ravi was here. / He has a book.",
          "example_en": "She is kind. / Ravi was here. / He has a book."
        },
        {
          "latex": "\\text{We / You / They} + \\text{are / were / have}",
          "meaning_hi": "बहुवचन और You के तीनों साथी",
          "meaning_en": "The 3 exact partners of Plural subjects & You",
          "example_hi": "You are smart. / They were ready. / We have time.",
          "example_en": "You are smart. / They were ready. / We have time."
        },
        {
          "latex": "\\text{Sub} + \\text{is/am/are/was/were} + \\text{not}",
          "meaning_hi": "नकारात्मक (Negative) वाक्य सूत्र",
          "meaning_en": "Negative sentence formula",
          "example_hi": "He is not tired. (वह थका नहीं है।)",
          "example_en": "He is not tired."
        },
        {
          "latex": "\\text{Is/Am/Are/Was/Were} + \\text{Sub} + \\dots\\, ?",
          "meaning_hi": "हाँ/ना प्रश्न (Yes/No Question) सूत्र",
          "meaning_en": "Yes/No Question formula (no \"What\" at front!)",
          "example_hi": "Are you a student? (क्या तुम छात्र हो?)",
          "example_en": "Are you a student?"
        }
      ]
    },
    "concept_md_hi": "### आज का आत्मविश्वास मंत्र\nअब आप शून्य से आगे निकल चुके हैं! नीचे दिए 4 वाक्य खुद के बारे में अंग्रेज़ी में बोलकर अभ्यास करें:\n1. **My name is [आपका नाम].** *(मेरा नाम ... है।)*\n2. **I am a student of Class [9/10/11/12].** *(मैं कक्षा ... का छात्र/छात्रा हूँ।)*\n3. **I am from Bihar.** *(मैं बिहार से हूँ।)*\n4. **I have big dreams.** *(मेरे बड़े सपने हैं।)*",
    "concept_md_en": "### Your Daily Confidence Mantra\nYou have already left zero behind! Say these 4 lines about yourself out loud right now:\n1. **My name is [Your Name].**\n2. **I am a student of Class [9/10/11/12].**\n3. **I am from Bihar.**\n4. **I have big dreams.**",
    "exam_tip_hi": "परीक्षा में जब भी कोई सरल वाक्य लिखें, बस 2 सेकंड रुककर जाँचें: (1) क्या Verb दूसरे स्थान पर है? (2) क्या Singular/Plural के साथ सही is/am/are/was/were लगा है?",
    "exam_tip_en": "Before moving past any sentence in the exam, do a 2-second check: (1) Is the Verb in seat #2? (2) Does is/am/are/was/were match the Subject?",
    "glossary_terms": []
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{Subject} + \\text{Verb} + \\text{Object}",
      "label_hi": "अंग्रेज़ी वाक्य का मुख्य क्रम (S + V + O)",
      "label_en": "Core English Sentence Structure (S + V + O)"
    },
    {
      "latex": "\\text{He/She/It} \\rightarrow \\text{is / was / has}",
      "label_hi": "एकवचन कर्ता के सहायक शब्द",
      "label_en": "Singular Subject Partners"
    },
    {
      "latex": "\\text{We/You/They} \\rightarrow \\text{are / were / have}",
      "label_hi": "बहुवचन व You के सहायक शब्द",
      "label_en": "Plural & You Partners"
    },
    {
      "latex": "\\text{Helping Verb} + \\text{Subject} + \\dots\\, ?",
      "label_hi": "क्या से शुरू होने वाले प्रश्न का सूत्र",
      "label_en": "Yes/No Question Formula"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "RULE 1",
      "fact_hi": "`am` केवल और केवल `I` के साथ आता है — किसी और शब्द के साथ कभी नहीं।",
      "fact_en": "`am` ONLY pairs with `I` — never with any other pronoun or noun."
    },
    {
      "tag": "RULE 2",
      "fact_hi": "`You` चाहे एक व्यक्ति हो या अनेक, इसके साथ हमेशा `are`, `were` और `have` आता है।",
      "fact_en": "`You` ALWAYS takes `are`, `were`, and `have`, even when speaking to one person."
    },
    {
      "tag": "RULE 3",
      "fact_hi": "भूतकाल में पास होना बताने के लिए हर कर्ता (I/He/They) के साथ केवल `had` लगता है।",
      "fact_en": "For past ownership, ALL subjects (I/He/She/We/They) simply take `had`."
    },
    {
      "tag": "RULE 4",
      "fact_hi": "`My name is...` सही है; कभी `Myself Ravi` बोलना या लिखना व्याकरण में सही नहीं है।",
      "fact_en": "`My name is...` or `I am...` is grammatically correct; avoid `Myself Ravi`."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "हिंदी क्रम में लिख देना: \"I mango eat.\" या \"I am eat mango.\"",
      "mistake_en": "Writing in Hindi order (\"I mango eat\") or adding extra \"am\" (\"I am eat mango\").",
      "fix_hi": "हमेशा S + V + O क्रम रखें और साधारण काम के साथ अतिरिक्त `am` न लगाएँ: **\"I eat a mango.\"**",
      "fix_en": "Always follow S + V + O and drop the extra `am` before plain V1: **\"I eat a mango.\"**"
    },
    {
      "mistake_hi": "\"क्या तुम छात्र हो?\" का अनुवाद \"What you are a student?\" लिखना।",
      "mistake_en": "Translating Yes/No \"Kya\" questions with \"What you are a student?\"",
      "fix_hi": "हाँ/ना वाले प्रश्न में `What` न लगाएँ — बस सहायक क्रिया आगे लाएँ: **\"Are you a student?\"**",
      "fix_en": "Drop `What` for Yes/No questions — pull the helping verb to the front: **\"Are you a student?\"**"
    },
    {
      "mistake_hi": "`I` के साथ `has` लगा देना: \"I has a pen.\"",
      "mistake_en": "Using `has` with `I`: \"I has a pen.\"",
      "fix_hi": "`I` हमेशा `have` लेता है: **\"I have a pen.\"** (`has` केवल He/She/It/एकवचन नाम के लिए है।)",
      "fix_en": "`I` ALWAYS takes `have`: **\"I have a pen.\"** (`has` is strictly for He/She/It/singular nouns.)"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "हिंदी से अंग्रेज़ी सरल अनुवाद (Translation)",
      "topic_en": "Simple Hindi-to-English Translation",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "is / am / are / was / were / has / have आधारित MCQ",
      "topic_en": "Subject-Verb Agreement MCQs (be & have)",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 3
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 5,
  "analogy_count": 5,
  "bseb_pyq_mapped": true,
  "syllabus_year": "2026-27"
}$json$::jsonb,
  'PUBLISHED',
  1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json        = EXCLUDED.mindmap_json,
  sections_json       = EXCLUDED.sections_json,
  board_capsule_json  = EXCLUDED.board_capsule_json,
  quality_checks_json = EXCLUDED.quality_checks_json,
  status              = EXCLUDED.status,
  version             = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'skill-eng-f-ch1',
  3,
  'कक्षा के सबसे संकोची विद्यार्थी के मन से अंग्रेज़ी का डर पहले 10 मिनट में समाप्त करना; हिंदी (S-O-V) व अंग्रेज़ी (S-V-O) के अंतर को खेल द्वारा समझाना; तथा सभी विद्यार्थियों से बिना झिझक is/am/are, was/were व has/have के कम से कम 5 शुद्ध वाक्य बुलवाना व लिखवाना।',
  'Eliminate fear of English in shy rural learners within the first 10 minutes; demonstrate Hindi S-O-V to English S-V-O visually through kinesthetic seat-swapping; and get every student speaking and writing at least 5 accurate sentences using is/am/are, was/were, and has/have.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "डर भगाओ कोरस (5 मि.) + 3-छात्र S-V-O रेलगाड़ी खेल (25 मि.) + अभ्यास (10 मि.)",
    "phase_en": "5-Min Fear-Free Spoken Chorus + 3-Student S-V-O Human Train + Practice",
    "teacher_action_hi": "मिनट 0–5: पूरी कक्षा एक साथ ताली बजाकर ज़ोर से बोले — \"I am ready! We are smart! English is easy!\" (एक साथ बोलने से संकोची बच्चों की झिझक टूटती है)। मिनट 5–20: 3 छात्रों को आगे बुलाकर हाथ में कागज़ दें — [मैं / I], [आम / a mango], [खाता हूँ / eat]। पहले हिंदी क्रम में खड़ा करें, फिर छात्र 2 और 3 की जगह बदलकर अंग्रेज़ी वाक्य \"I eat a mango\" बनवाएँ! मिनट 20–35: 5 नए हिंदी वाक्यों पर यही सीट-बदलाव बोर्ड पर करवाएँ। मिनट 35–40: हर छात्र अपने साथी से 1 वाक्य बोले।",
    "teacher_action_en": "Mins 0–5: Lead a joyful full-class chorus with claps — \"I am ready! We are smart! English is easy!\" (choral speaking removes individual shyness). Mins 5–20: Call 3 students holding paper placards [I], [a mango], [eat]. Line them up in Hindi order first, then physically swap students #2 and #3 to reveal \"I eat a mango\"! Mins 20–35: Practice 5 everyday sentences on the board. Mins 35–40: Pair-share 1 sentence each.",
    "student_check_hi": "पीछे की बेंच के किसी छात्र से मुस्कुराते हुए पूछें: \"हम दूध पीते हैं\" में पहले कौन आएगा, बीच में कौन और अंत में कौन? पूरी कक्षा ताली बजाकर उत्साह बढ़ाए।",
    "student_check_en": "Gently ask a back-bench student: In \"We drink milk\", which word takes seat 1, seat 2, and seat 3? Have the class clap for every attempt."
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "7 सर्वनाम व is / am / are / was / were का जोड़ी खेल",
    "phase_en": "7 Pronouns & is / am / are / was / were Partner Game",
    "teacher_action_hi": "मिनट 0–5: कोरस अभ्यास (\"I am! He is! She is! We are! They are!\"). मिनट 5–20: ब्लैकबोर्ड पर 3 घर बनाएँ — [am का घर: केवल I], [is का घर: He/She/It/एक नाम], [are का घर: We/You/They/अनेक]। मिनट 20–30: भूतकाल (was/were) जोड़ें और \"कल मैं स्कूल में था\" जैसे वाक्य बनवाएँ। मिनट 30–40: शिक्षक केवल कर्ता बोलें (जैसे \"She\", \"You\", \"Ram and Shyam\") और पूरी कक्षा तुरंत सही साथी (is/are) चिल्लाकर बताए।",
    "teacher_action_en": "Mins 0–5: Rapid chorus warm-up (\"I am! He is! She is! We are! They are!\"). Mins 5–20: Draw 3 houses on the blackboard — [am house: only I], [is house: He/She/It/1 name], [are house: We/You/They/2+ names]. Mins 20–30: Extend to was/were with yesterday examples. Mins 30–40: Rapid-fire call-and-response where teacher shouts a subject and class shouts is/am/are.",
    "student_check_hi": "बोर्ड पर लिखें \"I am eat mango\" और पूछें इसमें कौन-सा शब्द फालतू घुस आया है?",
    "student_check_en": "Write \"I am eat mango\" on the board and ask the class to spot the extra intruder word!"
  },
  {
    "period_no": 3,
    "duration_mins": 40,
    "phase_hi": "has / have / had + Negative व Yes/No Question स्विच अभ्यास",
    "phase_en": "has / have / had + Negative & Question Switch Practice",
    "teacher_action_hi": "मिनट 0–5: \"मेरा बैग\" बोलचाल अभ्यास — हर छात्र अपना पेन या कॉपी उठाकर बोले \"I have a pen / I have a notebook!\"। मिनट 5–20: He/She के साथ `has` और भूतकाल में `had` का अंतर दिखाएँ। मिनट 20–35: लाइट-स्विच ट्रिक से 5 वाक्यों को Negative (+not) और Question (Helping Verb आगे) में बदलवाएँ; \"What you are...\" वाली गलती सुधारें। मिनट 35–40: 5-प्रश्न मिनी क्विज़।",
    "teacher_action_en": "Mins 0–5: \"My Bag\" chorus — every student holds up a pen or notebook and says \"I have a pen!\" Mins 5–20: Contrast `has` (He/She/It) and universal past `had`. Mins 20–35: Practice the light-switch Negative (+not) and Question (front-shift) rule on 5 sentences, explicitly fixing the \"What you are\" error. Mins 35–40: 5-item exit quiz.",
    "student_check_hi": "पूछें: \"क्या आप खुश हैं?\" को अंग्रेज़ी में \"What\" से शुरू करेंगे या \"Are\" से?",
    "student_check_en": "Ask: Does \"Kya aap khush hain?\" start with \"What\" or \"Are\" in English?"
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड चित्र 1: हिंदी से अंग्रेज़ी सीट-बदलाव",
    "heading_en": "Blackboard Drawing 1: Hindi-to-English Seat Swap",
    "points_hi": [
      "हिंदी:   [ मैं (S) ]  +  [ आम (O) ]  +  [ खाता हूँ (V) ]",
      "अंग्रेज़ी: [ I (S) ]    +  [ eat (V) ]  +  [ a mango (O) ]",
      "नियम: कर्ता वही रहेगा, बस क्रिया को बीच (सीट 2) में ले आएँ!"
    ],
    "points_en": [
      "Hindi:   [ Main (S) ] + [ aam (O) ] + [ khata hoon (V) ]",
      "English: [ I (S) ]    + [ eat (V) ] + [ a mango (O) ]",
      "Rule: Keep Subject in seat 1; pull Verb into seat 2!"
    ]
  },
  {
    "heading_hi": "ब्लैकबोर्ड बॉक्स 2: तीन घर (am / is / are) और (has / have / had)",
    "heading_en": "Blackboard Box 2: The 3 Houses (am/is/are & has/have/had)",
    "points_hi": [
      "I → am | was | have",
      "He / She / It / एक नाम → is | was | has",
      "We / You / They / अनेक नाम → are | were | have",
      "नकारात्मक = Helping Verb के बाद not | प्रश्न = Helping Verb सबसे आगे + ?"
    ],
    "points_en": [
      "I → am | was | have",
      "He / She / It / 1 Name → is | was | has",
      "We / You / They / 2+ Names → are | were | have",
      "Negative = add not after HV | Question = move HV to front + ?"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"डर भगाओ\" सामूहिक बोलचाल कोरस (Shy-Student Friendly)",
    "title_en": "5-Minute Fear-Free Spoken English Chorus Warm-Up",
    "materials_hi": "कुछ नहीं — केवल शिक्षक की मुस्कान और बच्चों की ताली!",
    "materials_en": "None — just teacher encouragement and rhythmic clapping!",
    "steps_hi": "शिक्षक पहले एक छोटा वाक्य बोलें और पूरी कक्षा एक साथ दोहराए: (1) \"I am a student.\" (2) \"I am from Bihar.\" (3) \"I have a dream.\" (4) \"English is easy.\" फिर 3-3 की पंक्ति में दोहराएँ ताकि सबसे संकोची विद्यार्थी भी बिना डर आवाज़ निकाले।",
    "steps_en": "Teacher chants short empowering sentences and the whole class echoes together: (1) \"I am a student.\" (2) \"I am from Bihar.\" (3) \"I have a dream.\" (4) \"English is easy.\" Then repeat row-by-row so even the shyest student speaks comfortably."
  },
  {
    "title_hi": "जीती-जागती S-V-O रेलगाड़ी (Human Sentence Train)",
    "title_en": "Living S-V-O Human Sentence Train",
    "materials_hi": "चाक और 6 कागज़ की पर्चियाँ (I, We, eat, play, mango, cricket)",
    "materials_en": "Chalk and 6 paper slips (I, We, eat, play, mango, cricket)",
    "steps_hi": "3 छात्रों को 3 पर्चियाँ देकर बोर्ड के सामने खड़ा करें। बाकी कक्षा निर्देश दे कि कौन सीट 1, 2 और 3 पर खड़ा होगा। हर सही वाक्य पर पूरा वर्ग ज़ोर से उसे पढ़े।",
    "steps_en": "Hand 3 students 3 word slips in front of the class. The rest of the class directs who stands in seat 1, seat 2, and seat 3, then reads the finished sentence aloud together."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "अपने और अपने परिवार के बारे में is/am/are और has/have से 5 सरल अंग्रेज़ी वाक्य लिखें (जैसे: I am..., My father is..., I have...) और घर पर ज़ोर से पढ़ें।",
    "task_en": "Write 5 simple English sentences about yourself and your family using is/am/are and has/have, and read them aloud at home."
  },
  {
    "level": "BOARD",
    "task_hi": "नीचे दिए 5 हिंदी वाक्यों का अंग्रेज़ी अनुवाद करें तथा प्रत्येक का Negative व Question रूप भी लिखें: (1) वह मेरा मित्र है। (2) वे किसान हैं। (3) कल मैं बीमार था। (4) मेरे पास दो कलम हैं। (5) क्या तुम तैयार हो?",
    "task_en": "Translate 5 given Hindi sentences into English and write both Negative and Interrogative forms for each."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "अपने स्कूल और गाँव का परिचय देते हुए 8 शुद्ध अंग्रेज़ी वाक्यों का एक छोटा अनुच्छेद लिखें (is/am/are, was/were, has/have सभी का कम से कम एक बार उपयोग करें)।",
    "task_en": "Write an 8-sentence introduction to your school and village using is/am/are, was/were, and has/have at least once each."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र हर हिंदी \"हूँ / है\" के लिए वाक्य में `am / is` जोड़ देते हैं, जैसे \"I am play cricket\" या \"He is go\".",
    "misconception_en": "Students insert `am / is` before every action verb because of Hindi \"hoon / hai\" (e.g., \"I am play cricket\").",
    "correction_hi": "बताएँ कि `play / eat / go` खुद पूरी क्रिया हैं — उनके साथ `am / is` तभी आता है जब काम अभी चल रहा हो (`playing`)। साधारण आदत में सीधे `I play cricket` लिखें।",
    "correction_en": "Explain that `play / eat / go` are complete verbs on their own; `am/is/are` only joins action verbs in `-ing` continuous form. Use plain `I play cricket`."
  },
  {
    "misconception_hi": "छात्र \"क्या तुम खुश हो?\" में \"क्या\" देखकर वाक्य `What` से शुरू कर देते हैं (\"What are you happy?\").",
    "misconception_en": "Students translate Yes/No Hindi \"Kya\" questions literally using \"What\".",
    "correction_hi": "सरल नियम सिखाएँ: जिस प्रश्न का उत्तर केवल \"हाँ\" या \"ना\" में हो, वहाँ `What` नहीं आता — सीधे `Is / Am / Are / Was / Were` आगे आता है!",
    "correction_en": "Teach the golden check: if the answer is simply \"Yes\" or \"No\", never start with `What` — pull `Is/Am/Are/Was/Were` to the front!"
  },
  {
    "misconception_hi": "छात्र \"तुम\" एक व्यक्ति के लिए होने पर `You is` या `You was` लिख देते हैं।",
    "misconception_en": "Students write `You is` or `You was` when addressing a single person.",
    "correction_hi": "सिखाएँ कि अंग्रेज़ी में `You` हमेशा सम्मानजनक बहुवचन की तरह चलता है (जैसे हिंदी में \"आप हैं\") — इसलिए हमेशा `You are` और `You were`!",
    "correction_en": "Compare `You` to respectful Hindi \"Aap hain\" — it ALWAYS pairs with plural `are`, `were`, and `have`!"
  }
]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods                   = EXCLUDED.duration_periods,
  objectives_hi                      = EXCLUDED.objectives_hi,
  objectives_en                      = EXCLUDED.objectives_en,
  teaching_steps_json                = EXCLUDED.teaching_steps_json,
  blackboard_points_json             = EXCLUDED.blackboard_points_json,
  classroom_activities_json          = EXCLUDED.classroom_activities_json,
  homework_json                      = EXCLUDED.homework_json,
  common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — S-V-O Basic Order
  (
    '10000006-0001-4000-8000-000000000001', 'skill-eng-foundation', 'skill-eng-f-ch1', 'S-V-O Basic Order', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही अंग्रेज़ी वाक्य बनाएँ: "मैं आम खाता हूँ।"',
    'Build the correct English sentence: "I eat a mango."',
    NULL, NULL,
    'अंग्रेज़ी क्रम याद करें: Subject (I) + Verb (eat) + Object (a mango)। अतिरिक्त "am" नहीं लगेगा!',
    'Follow English order: Subject (I) + Verb (eat) + Object (a mango). Do not add "am"!',
    'सही वाक्य है **"I eat a mango"**। हिंदी S-O-V ("मैं आम खाता हूँ") अंग्रेज़ी में S-V-O बन जाता है।',
    'The correct sentence is **"I eat a mango"** — Subject first, Verb second, Object third.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मैं आम खाता हूँ।",
  "prompt_en": "Build the correct S + V + O English sentence",
  "grammar_formula": "Subject (I) + Verb (eat) + Object (a mango)",
  "tokens": [
    "I",
    "eat",
    "a",
    "mango"
  ],
  "distractors": [
    "am",
    "eats"
  ],
  "correct_sentence": "I eat a mango",
  "pronunciation_hi": "आई ईट अ मैंगो"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Pronoun + is/am/are
  (
    '10000006-0001-4000-8000-000000000002', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Pronoun + is/am/are', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही अंग्रेज़ी वाक्य बनाएँ: "मैं बिहार से एक छात्र हूँ।"',
    'Build the correct English sentence: "I am a student from Bihar."',
    NULL, NULL,
    '`I` का पक्का साथी हमेशा `am` होता है।',
    '`I` always partners with `am`.',
    '**"I am a student from Bihar"** — यहाँ परिचय दिया जा रहा है और `I` के साथ `am` लगता है।',
    '**"I am a student from Bihar"** — `I` exclusively takes `am` to state identity.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मैं बिहार से एक छात्र हूँ।",
  "prompt_en": "Introduce yourself cleanly in English",
  "grammar_formula": "I + am + Noun + from + Place",
  "tokens": [
    "I",
    "am",
    "a",
    "student",
    "from",
    "Bihar"
  ],
  "distractors": [
    "is",
    "are"
  ],
  "correct_sentence": "I am a student from Bihar",
  "pronunciation_hi": "आई ऐम अ स्टूडेंट फ़्रॉम बिहार"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Past was/were
  (
    '10000006-0001-4000-8000-000000000003', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Past was/were', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', 'BSEB Model',
    'सही अंग्रेज़ी वाक्य बनाएँ: "वे कल स्कूल में थे।"',
    'Build the correct English sentence: "They were at school yesterday."',
    NULL, NULL,
    '`They` बहुवचन है — भूतकाल (थे) के लिए `were` चुनें!',
    '`They` is plural — choose `were` for past state!',
    '**"They were at school yesterday"** — बहुवचन कर्ता `They` के साथ भूतकाल में `were` लगता है।',
    '**"They were at school yesterday"** — Plural subject `They` pairs with `were`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "वे कल स्कूल में थे।",
  "prompt_en": "Build the past-state sentence with were",
  "grammar_formula": "They + were + Place + Time",
  "tokens": [
    "They",
    "were",
    "at",
    "school",
    "yesterday"
  ],
  "distractors": [
    "was",
    "are"
  ],
  "correct_sentence": "They were at school yesterday",
  "pronunciation_hi": "दे वर ऐट स्कूल यस्टरडे"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Ownership has/have
  (
    '10000006-0001-4000-8000-000000000004', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Ownership has/have', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही अंग्रेज़ी वाक्य बनाएँ: "उसके पास एक नई किताब है।"',
    'Build the correct English sentence: "She has a new book."',
    NULL, NULL,
    '`She` एकवचन है, इसलिए पास होने के लिए `has` लगेगा (`have` नहीं)।',
    '`She` is third-person singular, so use `has` (not `have`).',
    '**"She has a new book"** — `He, She, It` और एकवचन नाम के साथ `has` आता है।',
    '**"She has a new book"** — Singular `She` takes `has` for possession.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "उसके (लड़की के) पास एक नई किताब है।",
  "prompt_en": "Build the ownership sentence using has",
  "grammar_formula": "She + has + a + Adjective + Noun",
  "tokens": [
    "She",
    "has",
    "a",
    "new",
    "book"
  ],
  "distractors": [
    "have",
    "is"
  ],
  "correct_sentence": "She has a new book",
  "pronunciation_hi": "शी हैज़ अ न्यू बुक"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (TOPPER, PRACTICE) — Yes/No Question Flip
  (
    '10000006-0001-4000-8000-000000000005', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Yes/No Question Flip', 'PRACTICE', 'SENTENCE_BUILDER', 'TOPPER', 'BSEB 2023',
    'सही प्रश्नवाचक वाक्य बनाएँ: "क्या तुम मेरे मित्र हो?"',
    'Build the Yes/No question: "Are you my friend?"',
    NULL, NULL,
    '"क्या" के लिए `What` मत लगाएँ — सीधे `Are` को सबसे आगे लाएँ!',
    'Do NOT use `What` for a Yes/No question — put `Are` first!',
    '**"Are you my friend?"** — Yes/No प्रश्नों में सहायक क्रिया (`Are`) कर्ता (`you`) से पहले आती है।',
    '**"Are you my friend?"** — Move the helping verb `Are` before `you` to form a Yes/No question.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "क्या तुम मेरे मित्र हो?",
  "prompt_en": "Form the Yes/No question without using What",
  "grammar_formula": "Are + you + Noun?",
  "tokens": [
    "Are",
    "you",
    "my",
    "friend?"
  ],
  "distractors": [
    "What",
    "Is"
  ],
  "correct_sentence": "Are you my friend?",
  "pronunciation_hi": "आर यू माई फ़्रेंड?"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (FOUNDATION, PRACTICE) — S-V-O Visual Bridge
  (
    '10000006-0001-4000-8000-000000000006', 'skill-eng-foundation', 'skill-eng-f-ch1', 'S-V-O Visual Bridge', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', NULL,
    'चित्र देखकर सही अंग्रेज़ी वाक्य चुनें:',
    'Look at the visual cue and choose the correct English sentence:',
    NULL, NULL,
    'ध्यान दें: पहले कर्ता (Ravi), दूसरे स्थान पर क्रिया (reads), तीसरे स्थान पर कर्म (a book) — बीच में अतिरिक्त `is` न लगाएँ!',
    'Check S + V + O: Ravi + reads + a book (no extra `is` before reads!).',
    'सही वाक्य **"Ravi reads a book."** है। "Ravi a book reads" हिंदी क्रम है और "Ravi is read a book" में `is` गलत लगा है।',
    '**"Ravi reads a book."** follows pure English S + V + O without Hindi word-order interference.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "चित्र देखकर वाक्य बनाएँ: रवि किताब पढ़ता है",
  "scene_title_en": "Picture Grammar: Ravi Reads a Book",
  "prompt_hi": "नीचे दिए चित्र में S + V + O के 3 डिब्बे देखें। इनमें से कौन-सा वाक्य 100% शुद्ध अंग्रेज़ी है?",
  "prompt_en": "Look at the 3 S + V + O blocks below. Which sentence is 100% grammatically right?",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "तीन डिब्बों का सही क्रम पहचानें",
    "title_en": "Spot the Exact 3-Block English Order",
    "caption_hi": "सीट 1 = कर्ता, सीट 2 = क्रिया, सीट 3 = कर्म",
    "caption_en": "Seat 1 = Subject, Seat 2 = Verb, Seat 3 = Object",
    "viewBox": "0 0 600 130",
    "elements": [
      {
        "kind": "rect",
        "x": 24,
        "y": 24,
        "width": 155,
        "height": 76,
        "rx": 10,
        "fill": "#EFF6FF",
        "stroke": "#1E3A8A",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 101,
        "y": 54,
        "text_hi": "1. रवि (Ravi)",
        "text_en": "1. Ravi (S)",
        "fill": "#1E3A8A",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "arrow",
        "x1": 184,
        "y1": 62,
        "x2": 214,
        "y2": 62,
        "stroke": "#64748B",
        "strokeWidth": 2.2
      },
      {
        "kind": "rect",
        "x": 220,
        "y": 24,
        "width": 155,
        "height": 76,
        "rx": 10,
        "fill": "#FEF3C7",
        "stroke": "#D97706",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 297,
        "y": 54,
        "text_hi": "2. पढ़ता है (reads)",
        "text_en": "2. reads (V)",
        "fill": "#B45309",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "arrow",
        "x1": 380,
        "y1": 62,
        "x2": 410,
        "y2": 62,
        "stroke": "#64748B",
        "strokeWidth": 2.2
      },
      {
        "kind": "rect",
        "x": 416,
        "y": 24,
        "width": 160,
        "height": 76,
        "rx": 10,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 496,
        "y": 54,
        "text_hi": "3. किताब (a book)",
        "text_en": "3. a book (O)",
        "fill": "#059669",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "MessageSquare",
      "label_hi": "Ravi reads a book.",
      "label_en": "Ravi reads a book."
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "Ravi a book reads.",
      "label_en": "Ravi a book reads."
    },
    {
      "id": "c3",
      "icon": "MessageSquare",
      "label_hi": "Ravi is read a book.",
      "label_en": "Ravi is read a book."
    },
    {
      "id": "c4",
      "icon": "MessageSquare",
      "label_hi": "Reads Ravi a book.",
      "label_en": "Reads Ravi a book."
    }
  ],
  "correct_choice_id": "c1"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (BOARD, PRACTICE) — Subject-Verb Agreement Scene
  (
    '10000006-0001-4000-8000-000000000007', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Subject-Verb Agreement Scene', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'BSEB 2024',
    'कक्षा में दो छात्रों के लिए सही वाक्य चुनें:',
    'Choose the right sentence for two students in the scene:',
    NULL, NULL,
    'चित्र में एक छात्र नहीं, बल्कि **दो** छात्र (Aman and Puja) हैं — बहुवचन क्रिया चुनें!',
    'Count the people in the scene: Aman and Puja are TWO (plural)!',
    '**"Aman and Puja are good friends."** — जब दो नाम `and` से जुड़ते हैं, तो वे बहुवचन बनते हैं और `are` लेते हैं।',
    '**"Aman and Puja are good friends."** — Two subjects joined by `and` form a plural subject taking `are`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "दो दोस्त: अमन और पूजा",
  "scene_title_en": "Two Friends: Aman and Puja",
  "prompt_hi": "अमन और पूजा (2 लोग) एक साथ हैं। सही अंग्रेज़ी वाक्य चुनें:",
  "prompt_en": "Aman and Puja (2 people together). Pick the exact grammatical sentence:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "एकवचन बनाम बहुवचन कर्ता पहचान",
    "title_en": "Singular vs Plural Subject Check",
    "caption_hi": "1 + 1 = 2 लोग (बहुवचन कर्ता)",
    "caption_en": "1 + 1 = 2 people (Plural Subject)",
    "viewBox": "0 0 560 150",
    "elements": [
      {
        "kind": "circle",
        "cx": 150,
        "cy": 56,
        "r": 24,
        "fill": "#EFF6FF",
        "stroke": "#1E3A8A",
        "strokeWidth": 2.2
      },
      {
        "kind": "label",
        "x": 150,
        "y": 61,
        "text_hi": "अमन",
        "text_en": "Aman",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 280,
        "y": 62,
        "text_hi": "+ (and)",
        "text_en": "+ (and)",
        "fill": "#D97706",
        "fontSize": 16,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "circle",
        "cx": 410,
        "cy": 56,
        "r": 24,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2.2
      },
      {
        "kind": "label",
        "x": 410,
        "y": 61,
        "text_hi": "पूजा",
        "text_en": "Puja",
        "fill": "#059669",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 145,
        "y": 100,
        "width": 270,
        "height": 38,
        "rx": 8,
        "fill": "#FEF3C7",
        "stroke": "#D97706",
        "strokeWidth": 1.8
      },
      {
        "kind": "label",
        "x": 280,
        "y": 122,
        "text_hi": "2 लोग = बहुवचन (Plural)",
        "text_en": "2 People = Plural Subject",
        "fill": "#B45309",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "PenTool",
      "label_hi": "Aman and Puja is good friends.",
      "label_en": "Aman and Puja is good friends."
    },
    {
      "id": "c2",
      "icon": "PenTool",
      "label_hi": "Aman and Puja was good friends.",
      "label_en": "Aman and Puja was good friends."
    },
    {
      "id": "c3",
      "icon": "PenTool",
      "label_hi": "Aman and Puja am good friends.",
      "label_en": "Aman and Puja am good friends."
    },
    {
      "id": "c4",
      "icon": "PenTool",
      "label_hi": "Aman and Puja are good friends.",
      "label_en": "Aman and Puja are good friends."
    }
  ],
  "correct_choice_id": "c4"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (FOUNDATION, PRACTICE) — S-V-O Core Rule
  (
    '10000006-0001-4000-8000-000000000008', 'skill-eng-foundation', 'skill-eng-f-ch1', 'S-V-O Core Rule', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'हिंदी और अंग्रेज़ी वाक्य के शब्द-क्रम में मुख्य अंतर क्या है?',
    'What is the main word-order difference between Hindi and English sentences?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "हिंदी (S-O-V) से अंग्रेज़ी (S-V-O) बनाने की 1-सेकंड ट्रिक क्या है?",
  "front_en": "What is the 1-second trick to switch from Hindi (S-O-V) to English (S-V-O)?",
  "back_hi": "कर्ता (Subject) को सीट 1 पर रखें और क्रिया (Verb) को अंत से उठाकर सीट 2 पर ले आएँ! जैसे: मैं आम खाता हूँ → I eat a mango.",
  "back_en": "Keep Subject in Seat 1 and pull the Verb from the end into Seat 2! Example: Main aam khata hoon → I eat a mango.",
  "mnemonic_hi": "ट्रिक: अंग्रेज़ी में \"काम (Verb) हमेशा बीच में!\"",
  "mnemonic_en": "Trick: In English, \"Action sits right in the middle!\"",
  "pronunciation_hi": "सब्जेक्ट + वर्ब + ऑब्जेक्ट"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (FOUNDATION, PRACTICE) — has vs have
  (
    '10000006-0001-4000-8000-000000000009', 'skill-eng-foundation', 'skill-eng-f-ch1', 'has vs have', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    '`has` और `have` का प्रयोग किन सर्वनामों के साथ होता है?',
    'Which pronouns take `has` and which take `have`?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "has और have में कब कौन-सा लगता है? (खासकर I के साथ!)",
  "front_en": "When do we use `has` vs `have`? (Especially with `I`!)",
  "back_hi": "He, She, It और एकवचन नाम → has। I, We, You, They और बहुवचन → have। (भूतकाल में सबके साथ → had!)",
  "back_en": "He, She, It & Singular noun → has. I, We, You, They & Plural → have. (Past for ALL → had!)",
  "mnemonic_hi": "याद रखें: \"अकेला तीसरा (He/She/It) लेगा S वाला शब्द — is, was, has!\"",
  "mnemonic_en": "Memory hook: \"3rd-person singular loves the letter S — is, was, has!\"",
  "pronunciation_hi": "हैज़ (has) · हैव (have) · हैड (had)"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (BOARD, PRACTICE) — Yes/No Questions
  (
    '10000006-0001-4000-8000-000000000010', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Yes/No Questions', 'PRACTICE', 'FLASHCARD', 'BOARD', NULL,
    '"क्या" से शुरू होने वाले हाँ/ना प्रश्नों को अंग्रेज़ी में कैसे शुरू करते हैं?',
    'How do you start a Hindi "Kya...?" Yes/No question in English?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"क्या वह बीमार है?\" का अनुवाद What से क्यों नहीं शुरू होता?",
  "front_en": "Why does \"Kya wah bimar hai?\" NOT begin with \"What\"?",
  "back_hi": "क्योंकि इसका उत्तर हाँ या ना में है! इसलिए सीधे सहायक क्रिया आगे लाते हैं: \"Is he ill?\"",
  "back_en": "Because it is a Yes/No question! Put the helping verb right at the start: \"Is he ill?\"",
  "mnemonic_hi": "ट्रिक: जवाब हाँ/ना हो → What को कहो \"ना\"!",
  "mnemonic_en": "Trick: If answer is Yes/No, say NO to \"What\"!",
  "pronunciation_hi": "इज़ ही इल?"
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (FOUNDATION, PRACTICE) — Pronoun-Verb Pairing
  (
    '10000006-0001-4000-8000-000000000011', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Pronoun-Verb Pairing', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', NULL,
    'प्रत्येक सर्वनाम (Pronoun) को उसकी सही वर्तमान सहायक क्रिया से मिलाएँ:',
    'Match each pronoun with its exact present-tense partner:',
    NULL, NULL,
    '`I` के लिए `am`, अकेले के लिए `is`, और समूह/सम्मान (`You/They`) के लिए `are`!',
    '`I` takes `am`, singular takes `is`, and `You/They` take `are`!',
    'I → am, She → is, They → are, और Ravi & Sita (2 लोग) → are।',
    'I → am, She → is, They → are, and Ravi & Sita (plural) → are.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "कर्ता को उसकी सही क्रिया से मिलाएँ",
  "instruction_en": "Match each subject with its correct verb",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "I (मैं)",
      "left_en": "I",
      "right_hi": "am a brave student",
      "right_en": "am a brave student"
    },
    {
      "id": "p2",
      "left_hi": "She (वह - लड़की)",
      "left_en": "She",
      "right_hi": "is a kind teacher",
      "right_en": "is a kind teacher"
    },
    {
      "id": "p3",
      "left_hi": "You (तुम / आप)",
      "left_en": "You",
      "right_hi": "are very honest",
      "right_en": "are very honest"
    },
    {
      "id": "p4",
      "left_hi": "He (वह - लड़का)",
      "left_en": "He",
      "right_hi": "has a blue bicycle",
      "right_en": "has a blue bicycle"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (BOARD, PRACTICE) — Hindi-English Sentences
  (
    '10000006-0001-4000-8000-000000000012', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Hindi-English Sentences', 'PRACTICE', 'MATCH_PAIRS', 'BOARD', 'BSEB Model',
    'हिंदी वाक्यों को उनके शुद्ध अंग्रेज़ी अनुवाद से मिलाएँ:',
    'Match each Hindi sentence with its exact English translation:',
    NULL, NULL,
    'वर्तमान (है/हैं) बनाम भूतकाल (था/थे) और प्रश्नवाचक रूप पर ध्यान दें!',
    'Watch present (is/are) vs past (was/were) and question form!',
    'प्रत्येक वाक्य में सही समय (Present/Past) और कर्ता-क्रिया मिलान किया गया है।',
    'Each pair matches the exact tense (present/past) and subject-verb agreement.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही अनुवाद जोड़ी मिलाएँ",
  "instruction_en": "Match the Hindi sentence to its English partner",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "मेरे पास एक घड़ी है।",
      "left_en": "Mere paas ek ghadi hai.",
      "right_hi": "I have a watch.",
      "right_en": "I have a watch."
    },
    {
      "id": "p2",
      "left_hi": "वह कल पटना में था।",
      "left_en": "Wah kal Patna mein tha.",
      "right_hi": "He was in Patna yesterday.",
      "right_en": "He was in Patna yesterday."
    },
    {
      "id": "p3",
      "left_hi": "क्या वे किसान हैं?",
      "left_en": "Kya we kisan hain?",
      "right_hi": "Are they farmers?",
      "right_en": "Are they farmers?"
    },
    {
      "id": "p4",
      "left_hi": "वह थकी हुई नहीं है।",
      "left_en": "Wah thaki hui nahin hai.",
      "right_hi": "She is not tired.",
      "right_en": "She is not tired."
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — am with I
  (
    '10000006-0001-4000-8000-000000000013', 'skill-eng-foundation', 'skill-eng-f-ch1', 'am with I', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'सही शब्द चुनकर वाक्य पूरा करें: I ___ a student of Class 10.',
    'Choose the correct word: I ___ a student of Class 10.',
    $json$[{"key":"A","text_hi":"am","text_en":"am"},{"key":"B","text_hi":"is","text_en":"is"},{"key":"C","text_hi":"are","text_en":"are"},{"key":"D","text_hi":"were","text_en":"were"}]$json$::jsonb, 'A',
    '`I` (मैं) का अपना विशेष वर्तमान साथी कौन है?',
    'Which present-tense verb belongs exclusively to `I`?',
    'वर्तमान काल में `I` के साथ हमेशा **`am`** लगता है: *"I am a student of Class 10."*।',
    'In the present tense, `I` always takes **`am`**: *"I am a student of Class 10."*',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — S-V-O Order
  (
    '10000006-0001-4000-8000-000000000014', 'skill-eng-foundation', 'skill-eng-f-ch1', 'S-V-O Order', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'इनमें से कौन-सा वाक्य सही अंग्रेज़ी (S + V + O) क्रम में है?',
    'Which of the following sentences is in the correct English (S + V + O) order?',
    $json$[{"key":"A","text_hi":"We cricket play.","text_en":"We cricket play."},{"key":"B","text_hi":"Play we cricket.","text_en":"Play we cricket."},{"key":"C","text_hi":"We play cricket.","text_en":"We play cricket."},{"key":"D","text_hi":"We are play cricket.","text_en":"We are play cricket."}]$json$::jsonb, 'C',
    'सीट 1 = Subject (We), सीट 2 = Verb (play), सीट 3 = Object (cricket)।',
    'Seat 1 = Subject (We), Seat 2 = Verb (play), Seat 3 = Object (cricket).',
    '**"We play cricket."** सही S + V + O वाक्य है। `We are play` गलत है क्योंकि साधारण V1 से पहले `are` नहीं आता।',
    '**"We play cricket."** is pure S + V + O. Never place `are` before plain V1 `play`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — You + are
  (
    '10000006-0001-4000-8000-000000000015', 'skill-eng-foundation', 'skill-eng-f-ch1', 'You + are', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'रिक्त स्थान भरें: You ___ my best friend.',
    'Fill in the blank: You ___ my best friend.',
    $json$[{"key":"A","text_hi":"is","text_en":"is"},{"key":"B","text_hi":"am","text_en":"am"},{"key":"C","text_hi":"has","text_en":"has"},{"key":"D","text_hi":"are","text_en":"are"}]$json$::jsonb, 'D',
    '`You` के साथ हमेशा बहुवचन सहायक क्रिया लगती है।',
    '`You` always pairs with the plural verb form.',
    '`You` चाहे एक मित्र के लिए हो या अनेक के लिए, इसके साथ हमेशा **`are`** आता है: *"You are my best friend."*',
    '`You` ALWAYS takes **`are`** even when speaking to one friend.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — has vs have
  (
    '10000006-0001-4000-8000-000000000016', 'skill-eng-foundation', 'skill-eng-f-ch1', 'has vs have', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'सही विकल्प चुनें: My brother ___ a red bicycle.',
    'Choose the correct option: My brother ___ a red bicycle.',
    $json$[{"key":"A","text_hi":"have","text_en":"have"},{"key":"B","text_hi":"has","text_en":"has"},{"key":"C","text_hi":"are","text_en":"are"},{"key":"D","text_hi":"were","text_en":"were"}]$json$::jsonb, 'B',
    '`My brother` एकवचन (अकेला 1 व्यक्ति = He) है!',
    '`My brother` is singular (= He)!',
    '`My brother` एकवचन कर्ता है, इसलिए अधिकार (पास होना) बताने के लिए **`has`** लगेगा।',
    '`My brother` is a singular third-person subject, so it takes **`has`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Plural Past were
  (
    '10000006-0001-4000-8000-000000000017', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Plural Past were', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'सही विकल्प चुनें: The boys ___ very happy yesterday.',
    'Choose the correct option: The boys ___ very happy yesterday.',
    $json$[{"key":"A","text_hi":"was","text_en":"was"},{"key":"B","text_hi":"is","text_en":"is"},{"key":"C","text_hi":"am","text_en":"am"},{"key":"D","text_hi":"were","text_en":"were"}]$json$::jsonb, 'D',
    'दो संकेत देखें: `The boys` (बहुवचन) और `yesterday` (बीता हुआ कल)!',
    'Spot two clues: `The boys` (plural) and `yesterday` (past)!',
    '`yesterday` भूतकाल बताता है और `The boys` बहुवचन है, इसलिए **`were`** 100% सही है।',
    '`yesterday` signals past tense and `The boys` is plural, so **`were`** is required.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Yes/No Question Translation
  (
    '10000006-0001-4000-8000-000000000018', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Yes/No Question Translation', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    '"क्या वह एक डॉक्टर है?" का सही अंग्रेज़ी अनुवाद चुनें:',
    'Choose the correct English translation of "क्या वह एक डॉक्टर है?":',
    $json$[{"key":"A","text_hi":"Is he a doctor?","text_en":"Is he a doctor?"},{"key":"B","text_hi":"He is a doctor?","text_en":"He is a doctor?"},{"key":"C","text_hi":"What he is a doctor?","text_en":"What he is a doctor?"},{"key":"D","text_hi":"Are he a doctor?","text_en":"Are he a doctor?"}]$json$::jsonb, 'A',
    'हाँ/ना प्रश्न में `What` नहीं लगाते; सीधे `Is` को आगे लाते हैं।',
    'Never use `What` for Yes/No questions; move `Is` before `he`.',
    '**"Is he a doctor?"** सही प्रश्नवाचक संरचना है (`Helping Verb + Subject + Complement?`)।',
    '**"Is he a doctor?"** follows the exact Yes/No question structure (`Is + Subject + ...?`).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — I + have rule
  (
    '10000006-0001-4000-8000-000000000019', 'skill-eng-foundation', 'skill-eng-f-ch1', 'I + have rule', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Model Paper',
    'सही वाक्य पहचानें:',
    'Identify the grammatically correct sentence:',
    $json$[{"key":"A","text_hi":"I has two notebooks.","text_en":"I has two notebooks."},{"key":"B","text_hi":"I am have two notebooks.","text_en":"I am have two notebooks."},{"key":"C","text_hi":"I have two notebooks.","text_en":"I have two notebooks."},{"key":"D","text_hi":"I having two notebooks.","text_en":"I having two notebooks."}]$json$::jsonb, 'C',
    '`I` के साथ स्वामित्व दिखाने के लिए कौन-सा शब्द आता है?',
    'Which ownership verb pairs with `I`?',
    '**"I have two notebooks."** — `I` के साथ कभी `has` या `am have` नहीं लगता; हमेशा `have` लगता है।',
    '**"I have two notebooks."** — `I` strictly pairs with `have`, never `has` or `am have`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Compound Subject Agreement
  (
    '10000006-0001-4000-8000-000000000020', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Compound Subject Agreement', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'सही विकल्प चुनें: Patna and Gaya ___ famous cities of Bihar.',
    'Choose the correct option: Patna and Gaya ___ famous cities of Bihar.',
    $json$[{"key":"A","text_hi":"is","text_en":"is"},{"key":"B","text_hi":"are","text_en":"are"},{"key":"C","text_hi":"was","text_en":"was"},{"key":"D","text_hi":"has","text_en":"has"}]$json$::jsonb, 'B',
    'दो अलग शहरों के नाम `and` से जुड़े हैं और आगे `cities` (बहुवचन) लिखा है!',
    'Two distinct cities joined by `and` plus plural `cities`!',
    'Patna and Gaya मिलकर बहुवचन कर्ता बनाते हैं और यह वर्तमान का स्थायी तथ्य है, इसलिए **`are`** सही है।',
    'Patna and Gaya form a plural subject stating a present fact, so **`are`** is correct.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Negative Past Ownership
  (
    '10000006-0001-4000-8000-000000000021', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Negative Past Ownership', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    '"उसके पास कल पैसे नहीं थे।" का सबसे सही अंग्रेज़ी रूप चुनें:',
    'Choose the best English sentence for "उसके पास कल पैसे नहीं थे।":',
    $json$[{"key":"A","text_hi":"He was no money yesterday.","text_en":"He was no money yesterday."},{"key":"B","text_hi":"He is no money yesterday.","text_en":"He is no money yesterday."},{"key":"C","text_hi":"He have no money yesterday.","text_en":"He have no money yesterday."},{"key":"D","text_hi":"He had no money yesterday.","text_en":"He had no money yesterday."}]$json$::jsonb, 'D',
    '"पास थे" = भूतकाल का स्वामित्व → `had`!',
    'Past ownership ("did not have / had no") uses `had`!',
    '**"He had no money yesterday."** (या *He did not have money yesterday.*) भूतकाल का स्वामित्व दिखाता है। `was` स्वामित्व नहीं बताता।',
    '**"He had no money yesterday."** correctly expresses past possession (`had`, not `was`).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, EXAM_ONLY) — Pronoun Agreement
  (
    '10000006-0001-4000-8000-000000000022', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Pronoun Agreement', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'BSEB Model',
    'रिक्त स्थान भरें: Sita ___ an intelligent girl.',
    'Fill in the blank: Sita ___ an intelligent girl.',
    $json$[{"key":"A","text_hi":"is","text_en":"is"},{"key":"B","text_hi":"are","text_en":"are"},{"key":"C","text_hi":"am","text_en":"am"},{"key":"D","text_hi":"were","text_en":"were"}]$json$::jsonb, 'A',
    '`Sita` एकवचन नाम है।',
    '`Sita` is a singular name.',
    'एकवचन कर्ता `Sita` के साथ वर्तमान में **`is`** लगता है।',
    'Singular subject `Sita` takes **`is`** in the present tense.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, EXAM_ONLY) — Past Singular was
  (
    '10000006-0001-4000-8000-000000000023', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Past Singular was', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2023',
    'सही विकल्प चुनें: I ___ absent from school last Monday.',
    'Choose the correct option: I ___ absent from school last Monday.',
    $json$[{"key":"A","text_hi":"were","text_en":"were"},{"key":"B","text_hi":"was","text_en":"was"},{"key":"C","text_hi":"am","text_en":"am"},{"key":"D","text_hi":"are","text_en":"are"}]$json$::jsonb, 'B',
    '`last Monday` भूतकाल बताता है, और `I` के साथ भूतकाल में क्या लगता है?',
    '`last Monday` indicates past time — what does `I` pair with in the past?',
    '`I` के साथ भूतकाल में **`was`** लगता है: *"I was absent from school last Monday."*।',
    '`I` pairs with **`was`** for past state: *"I was absent from school last Monday."*',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, EXAM_ONLY) — Error Detection
  (
    '10000006-0001-4000-8000-000000000024', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Error Detection', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'नीचे दिए गए वाक्यों में से पूर्णतः शुद्ध वाक्य पहचानें:',
    'Spot the completely error-free sentence:',
    $json$[{"key":"A","text_hi":"My friends is waiting outside.","text_en":"My friends is waiting outside."},{"key":"B","text_hi":"You was late today.","text_en":"You was late today."},{"key":"C","text_hi":"We have a big library in our school.","text_en":"We have a big library in our school."},{"key":"D","text_hi":"He am a honest boy.","text_en":"He am a honest boy."}]$json$::jsonb, 'C',
    'हर विकल्प में कर्ता और क्रिया की जोड़ी जाँचें।',
    'Check the subject-verb pairing in every option carefully.',
    '**"We have a big library in our school."** 100% शुद्ध है। अन्य विकल्पों में `friends is`, `You was`, `He am` अशुद्ध हैं।',
    '**"We have a big library in our school."** is 100% accurate; all other options break subject-verb agreement.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- SHORT_2M (BOARD, PRACTICE) — Sentence Transformation
  (
    '10000006-0001-4000-8000-000000000025', 'skill-eng-foundation', 'skill-eng-f-ch1', 'Sentence Transformation', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'दिए गए वाक्य को (a) Negative और (b) Interrogative (प्रश्नवाचक) में बदलें: "Rohan is an honest boy."',
    'Change the sentence into (a) Negative and (b) Interrogative: "Rohan is an honest boy."',
    NULL, NULL,
    'Negative के लिए `is` के बाद `not` जोड़ें; Question के लिए `Is` को सबसे आगे लाकर `?` लगाएँ।',
    'Add `not` right after `is` for Negative; move `Is` to the front and add `?` for Interrogative.',
    NULL,
    NULL,
    '**(a) Negative (नकारात्मक):** Rohan is **not** an honest boy.
**(b) Interrogative (प्रश्नवाचक):** **Is** Rohan an honest boy**?**',
    '**(a) Negative:** Rohan is **not** an honest boy.
**(b) Interrogative:** **Is** Rohan an honest boy**?**',
    $json$[{"cue_hi":"Negative = Helping Verb + not","cue_en":"Negative = Helping Verb + not"},{"cue_hi":"Interrogative = Helping Verb सबसे आगे + ?","cue_en":"Interrogative = Helping Verb first + ?"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"सही स्थान पर not लगाकर शुद्ध Negative वाक्य लिखना","criterion_en":"Correct Negative with `not` after `is`"},{"step_no":2,"marks":1,"criterion_hi":"Is को आगे लाकर प्रश्नवाचक चिह्न (?) सहित शुद्ध Interrogative लिखना","criterion_en":"Correct Interrogative with `Is` fronted and `?` at end"}]$json$::jsonb,
    NULL,
    true
  ),
  -- LONG_5M (BOARD, PRACTICE) — BSEB 5M Translation
  (
    '10000006-0001-4000-8000-000000000026', 'skill-eng-foundation', 'skill-eng-f-ch1', 'BSEB 5M Translation', 'PRACTICE', 'LONG_5M', 'BOARD', 'BSEB 2024',
    'निम्नलिखित 5 हिंदी वाक्यों का शुद्ध अंग्रेज़ी में अनुवाद करें (प्रत्येक 1 अंक = 5 अंक):
1. मैं बिहार का एक छात्र हूँ।
2. मेरे गाँव में एक अच्छा विद्यालय है।
3. मेरे पास एक अंग्रेज़ी की किताब है।
4. कल वे बहुत खुश थे।
5. क्या तुम रोज़ पढ़ते हो?',
    'Translate the following 5 Hindi sentences into clean English (1 mark each = 5 marks):
1. Main Bihar ka ek chhatra hoon.
2. Mere gaanv mein ek accha vidyalaya hai.
3. Mere paas ek Angrezi ki kitab hai.
4. Kal we bahut khush the.
5. Kya tum roz padhte ho?',
    NULL, NULL,
    'प्रत्येक वाक्य में S + V + O क्रम, सही सहायक क्रिया (`am/is/have/were`) और अंत में सही विराम चिह्न (`.` या `?`) जाँचें।',
    'Verify S + V + O word order, subject-verb agreement (`am/is/have/were`), and end punctuation (`.` or `?`).',
    NULL,
    NULL,
    '1. **I am a student of Bihar.** *(आई ऐम अ स्टूडेंट ऑफ़ बिहार।)*
2. **There is a good school in my village.** *(देयर इज़ अ गुड स्कूल इन माई विलेज।)*
3. **I have an English book.** *(आई हैव ऐन इंग्लिश बुक।)*
4. **They were very happy yesterday.** *(दे वर वेरी हैप्पी यस्टरडे।)*
5. **Do you study daily?** *(डू यू स्टडी डेली?)*',
    '1. **I am a student of Bihar.**
2. **There is a good school in my village.**
3. **I have an English book.**
4. **They were very happy yesterday.**
5. **Do you study daily?**',
    $json$[{"cue_hi":"वाक्य 1: I + am (परिचय)","cue_en":"Sentence 1: I + am (Identity)"},{"cue_hi":"वाक्य 2: किसी जगह कुछ होना → There is...","cue_en":"Sentence 2: Existence in a place → There is..."},{"cue_hi":"वाक्य 3: I + have + an English book","cue_en":"Sentence 3: I + have + an English book"},{"cue_hi":"वाक्य 4–5: They + were (भूतकाल) और Do you...? (प्रश्न)","cue_en":"Sentences 4–5: They + were (past) & Do you...? (question)"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"वाक्य 1 का शुद्ध अनुवाद (I am...)","criterion_en":"Accurate Sentence 1 (I am...)"},{"step_no":2,"marks":1,"criterion_hi":"वाक्य 2 का शुद्ध अनुवाद (There is...)","criterion_en":"Accurate Sentence 2 (There is...)"},{"step_no":3,"marks":1,"criterion_hi":"वाक्य 3 में I have और an English book का सही उपयोग","criterion_en":"Accurate Sentence 3 with I have & an English book"},{"step_no":4,"marks":1,"criterion_hi":"वाक्य 4 में They were और yesterday का सही उपयोग","criterion_en":"Accurate Sentence 4 with They were & yesterday"},{"step_no":5,"marks":1,"criterion_hi":"वाक्य 5 का शुद्ध प्रश्नवाचक रूप व ? चिह्न","criterion_en":"Accurate Sentence 5 question structure + ?"}]$json$::jsonb,
    NULL,
    true
  )
ON CONFLICT (id) DO UPDATE SET
  subject_id          = EXCLUDED.subject_id,
  chapter_id          = EXCLUDED.chapter_id,
  topic_tag           = EXCLUDED.topic_tag,
  bank_pool           = EXCLUDED.bank_pool,
  question_type       = EXCLUDED.question_type,
  difficulty_tier     = EXCLUDED.difficulty_tier,
  exam_year_tag       = EXCLUDED.exam_year_tag,
  q_hi                = EXCLUDED.q_hi,
  q_en                = EXCLUDED.q_en,
  options_json        = EXCLUDED.options_json,
  correct_option      = EXCLUDED.correct_option,
  clue_hi             = EXCLUDED.clue_hi,
  clue_en             = EXCLUDED.clue_en,
  explanation_hi      = EXCLUDED.explanation_hi,
  explanation_en      = EXCLUDED.explanation_en,
  model_answer_hi     = EXCLUDED.model_answer_hi,
  model_answer_en     = EXCLUDED.model_answer_en,
  memory_cues_json    = EXCLUDED.memory_cues_json,
  marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json   = EXCLUDED.visual_asset_json,
  is_published        = EXCLUDED.is_published;

-- #############################################################################
-- UNIT 2 OF 5: skill-eng-f-ch2 — TENSES VISUAL TIMELINE METHOD
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-eng-f-ch2',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: काल (Tenses) — चित्र विधि",
  "title_en": "30-Second Mindmap: Tenses Visual Timeline",
  "read_time_seconds": 30,
  "central_node": {
    "id": "u2-root",
    "label_hi": "काल = समय × काम (3 × 4 = 12)",
    "label_en": "Tense = Time × Work (3 × 4 = 12)",
    "subtitle_hi": "3 समय (Past · Present · Future) × 4 अवस्थाएँ (Simple · Continuous · Perfect · Perf. Cont.)",
    "subtitle_en": "3 Times (Past · Present · Future) × 4 Aspects (Simple · Continuous · Perfect · Perf. Cont.)"
  },
  "branches": [
    {
      "id": "u2-b1",
      "label_hi": "1. Simple (आदत / तथ्य / बीती घटना)",
      "label_en": "1. Simple (Habit / Fact / Past Event)",
      "color": "#1E3A8A",
      "formula_latex": "\\text{Present: } V_1(s/es) \\quad|\\quad \\text{Past: } V_2 \\quad|\\quad \\text{Future: } \\text{will} + V_1",
      "children": [
        {
          "id": "u2-b1-c1",
          "label_hi": "He/She/It → V1 में s/es जोड़ें (He goes)",
          "label_en": "He/She/It → add s/es to V1 (He goes)"
        },
        {
          "id": "u2-b1-c2",
          "label_hi": "Did / Does के बाद हमेशा V1 (Did he go?)",
          "label_en": "After Did / Does, ALWAYS use base V1 (Did he go?)"
        }
      ]
    },
    {
      "id": "u2-b2",
      "label_hi": "2. Continuous (चल रहा काम: V1+ing)",
      "label_en": "2. Continuous (Ongoing Action: V1+ing)",
      "color": "#059669",
      "formula_latex": "\\text{is/am/are / was/were / will be} + V_1\\text{-ing}",
      "children": [
        {
          "id": "u2-b2-c1",
          "label_hi": "अभी हो रहा: She is reading now.",
          "label_en": "Happening now: She is reading now."
        },
        {
          "id": "u2-b2-c2",
          "label_hi": "सावधान! know/love/like में -ing नहीं (I know!)",
          "label_en": "Trap! No -ing on know/love/like (Say \"I know!\")"
        }
      ]
    },
    {
      "id": "u2-b3",
      "label_hi": "3. Perfect (पूरा हो चुका काम: V3)",
      "label_en": "3. Perfect (Completed Action: V3)",
      "color": "#D97706",
      "formula_latex": "\\text{has/have / had / will have} + V_3",
      "children": [
        {
          "id": "u2-b3-c1",
          "label_hi": "just / already / yet → has/have + V3",
          "label_en": "just / already / yet → has/have + V3"
        },
        {
          "id": "u2-b3-c2",
          "label_hi": "भूतकाल के 2 काम: पहला काम had + V3, दूसरा V2",
          "label_en": "2 past events: Earlier = had + V3, Later = V2"
        }
      ]
    },
    {
      "id": "u2-b4",
      "label_hi": "4. Perfect Continuous (Since बनाम For)",
      "label_en": "4. Perfect Continuous (Since vs For)",
      "color": "#7C3AED",
      "formula_latex": "\\text{has/have been} + V_1\\text{-ing} + \\text{since / for}",
      "children": [
        {
          "id": "u2-b4-c1",
          "label_hi": "Since = शुरुआती बिंदु (since morning, since 2020)",
          "label_en": "Since = Starting point (since morning, since 2020)"
        },
        {
          "id": "u2-b4-c2",
          "label_hi": "For = कुल अवधि (for 2 hours, for 5 days)",
          "label_en": "For = Total duration (for 2 hours, for 5 days)"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "u2-sec-1-timeline",
    "order": 1,
    "heading_hi": "1. समय की रेलगाड़ी: एक चित्र में तीनों काल देखें",
    "heading_en": "1. The Time Train: See Past, Present & Future on One Visual Line",
    "analogy_hi": "मान लीजिए आप पटना जंक्शन पर खड़े हैं! जो ट्रेन **कल गुज़र चुकी** है वह **Past (भूतकाल)** है, जो ट्रेन **अभी प्लेटफ़ॉर्म पर** है वह **Present (वर्तमान)** है, और जो ट्रेन **कल आएगी** वह **Future (भविष्य)** है। अब बस यह देखें कि काम **रोज़ होता है (Simple)**, **अभी चल रहा है (Continuous)**, या **पूरा हो चुका है (Perfect)** — 12 के 12 Tense अपने आप स्पष्ट हो जाते हैं!",
    "analogy_en": "Imagine standing at Patna Junction! The train that **left yesterday** is **Past**, the train **at the platform right now** is **Present**, and the train **arriving tomorrow** is **Future**. Now just check the work status — **Routine (Simple)**, **In Progress (Continuous)**, or **Done (Perfect)** — and all 12 tenses click instantly!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "काल (Tenses) की 3-ट्रैक विज़ुअल समय-रेखा",
      "title_en": "The 3-Zone Visual Tense Timeline",
      "caption_hi": "बाईं ओर बीता कल (Past: V2 / was-were / had), बीच में आज (Present: V1 / is-am-are / has-have), और दाईं ओर आने वाला कल (Future: will + V1)।",
      "caption_en": "Left = Past (V2 / was-were / had), Centre = Present NOW (V1 / is-am-are / has-have), Right = Future (will + V1).",
      "viewBox": "0 0 680 280",
      "elements": [
        {
          "kind": "arrow",
          "x1": 30,
          "y1": 145,
          "x2": 650,
          "y2": 145,
          "stroke": "#0F172A",
          "strokeWidth": 3
        },
        {
          "kind": "circle",
          "cx": 130,
          "cy": 145,
          "r": 9,
          "fill": "#D97706",
          "stroke": "#FFFFFF",
          "strokeWidth": 2
        },
        {
          "kind": "circle",
          "cx": 340,
          "cy": 145,
          "r": 11,
          "fill": "#1E3A8A",
          "stroke": "#FFFFFF",
          "strokeWidth": 2.5
        },
        {
          "kind": "circle",
          "cx": 550,
          "cy": 145,
          "r": 9,
          "fill": "#059669",
          "stroke": "#FFFFFF",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 32,
          "y": 24,
          "width": 196,
          "height": 92,
          "rx": 10,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 130,
          "y": 48,
          "text_hi": "PAST (बीता कल)",
          "text_en": "PAST (Yesterday)",
          "fill": "#B45309",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 130,
          "y": 80,
          "text_hi": "V2 · did · was/were · had",
          "text_en": "V2 · did · was/were · had",
          "fill": "#78350F",
          "fontSize": 12,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "label",
          "x": 130,
          "y": 102,
          "text_hi": "He played. (वह खेला)",
          "text_en": "He played.",
          "fill": "#92400E",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 242,
          "y": 16,
          "width": 196,
          "height": 100,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 340,
          "y": 42,
          "text_hi": "PRESENT (आज / NOW)",
          "text_en": "PRESENT (Today / NOW)",
          "fill": "#1E3A8A",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 340,
          "y": 74,
          "text_hi": "V1(s/es) · is/am/are · has/have",
          "text_en": "V1(s/es) · is/am/are · has/have",
          "fill": "#1E40AF",
          "fontSize": 11,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "label",
          "x": 340,
          "y": 100,
          "text_hi": "He plays. (वह खेलता है)",
          "text_en": "He plays.",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 452,
          "y": 24,
          "width": 196,
          "height": 92,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 550,
          "y": 48,
          "text_hi": "FUTURE (आने वाला कल)",
          "text_en": "FUTURE (Tomorrow)",
          "fill": "#059669",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 550,
          "y": 80,
          "text_hi": "will / shall + V1",
          "text_en": "will / shall + V1",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "label",
          "x": 550,
          "y": 102,
          "text_hi": "He will play. (वह खेलेगा)",
          "text_en": "He will play.",
          "fill": "#047857",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 38,
          "y": 180,
          "width": 186,
          "height": 76,
          "rx": 8,
          "fill": "#F8FAFC",
          "stroke": "#64748B",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 131,
          "y": 206,
          "text_hi": "Simple: रोज़ की आदत",
          "text_en": "Simple: Habit / Fact",
          "fill": "#0F172A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 131,
          "y": 238,
          "text_hi": "V1(s/es) / V2 / will+V1",
          "text_en": "V1(s/es) / V2 / will+V1",
          "fill": "#475569",
          "fontSize": 11,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "rect",
          "x": 247,
          "y": 180,
          "width": 186,
          "height": 76,
          "rx": 8,
          "fill": "#F8FAFC",
          "stroke": "#2563EB",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 340,
          "y": 206,
          "text_hi": "Continuous: चल रहा है",
          "text_en": "Continuous: Ongoing",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 340,
          "y": 238,
          "text_hi": "be + V1-ing",
          "text_en": "be + V1-ing",
          "fill": "#475569",
          "fontSize": 11,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "rect",
          "x": 456,
          "y": 180,
          "width": 186,
          "height": 76,
          "rx": 8,
          "fill": "#F8FAFC",
          "stroke": "#7C3AED",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 549,
          "y": 206,
          "text_hi": "Perfect: पूरा हो चुका",
          "text_en": "Perfect: Completed",
          "fill": "#6D28D9",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 549,
          "y": 238,
          "text_hi": "has/have/had + V3",
          "text_en": "has/have/had + V3",
          "fill": "#475569",
          "fontSize": 11,
          "anchor": "middle",
          "bold": false
        }
      ]
    },
    "concept_md_hi": "### क्रिया के 3 मुख्य रूप (Verb Forms — बस ये समझ लें!)\nअंग्रेज़ी में हर क्रिया के तीन रूप होते हैं जिन्हें हम **V1, V2, V3** कहते हैं:\n- **V1 (Base Form — वर्तमान/भविष्य):** go (जाना), eat (खाना), write (लिखना), play (खेलना)\n- **V2 (Past Form — केवल Simple Past में):** went (गया), ate (खाया), wrote (लिखा), played (खेला)\n- **V3 (Past Participle — Perfect व Passive में):** gone (जा चुका), eaten (खा चुका), written (लिख चुका), played (खेल चुका)\n- **V-ing (Continuous रूप):** going, eating, writing, playing",
    "concept_md_en": "### The 3 Essential Verb Forms (V1, V2, V3)\nEvery English action verb has three core forms plus `-ing`:\n- **V1 (Base Form — Present / Future / after do, does, did):** go, eat, write, play\n- **V2 (Past Form — ONLY Simple Past positive):** went, ate, wrote, played\n- **V3 (Past Participle — Perfect & Passive Voice):** gone, eaten, written, played\n- **V-ing (Continuous Form):** going, eating, writing, playing",
    "exam_tip_hi": "पूरे अंग्रेज़ी व्याकरण में **V2** का इस्तेमाल केवल **Simple Past के साधारण वाक्य** (`He went`) में होता है! जैसे ही `did` आए, V2 तुरंत वापस **V1 (`go`)** बन जाता है!",
    "exam_tip_en": "In ALL of English grammar, **V2** is ONLY used in Simple Past positive sentences (`He went`). The moment `did` enters, V2 snaps right back to **V1 (`go`)**!",
    "glossary_terms": [
      {
        "term_hi": "काल (Tense)",
        "term_en": "Tense",
        "pronunciation_hi": "टेंस",
        "definition_hi": "क्रिया का वह रूप जो बताता है कि काम कब (Past/Present/Future) और कितना हुआ।",
        "definition_en": "The form of a verb that shows the time (Past/Present/Future) and completion state of an action."
      },
      {
        "term_hi": "मूल क्रिया (Base Verb — V1)",
        "term_en": "Base Verb (V1)",
        "pronunciation_hi": "बेस वर्ब",
        "definition_hi": "क्रिया का सबसे पहला शुद्ध रूप (go, eat, read, come) बिना s/es, ed या ing के।",
        "definition_en": "The plain dictionary form of a verb (go, eat, read, come) without s/es, ed, or ing."
      }
    ],
    "quick_check": {
      "q_hi": "क्रिया `write` के V1, V2 और V3 रूप क्या होते हैं?",
      "q_en": "What are the V1, V2, and V3 forms of the verb `write`?",
      "answer_hi": "V1 = **write**, V2 = **wrote**, V3 = **written**।",
      "answer_en": "V1 = **write**, V2 = **wrote**, V3 = **written**."
    }
  },
  {
    "id": "u2-sec-2-simple-tenses",
    "order": 2,
    "heading_hi": "2. Simple Tense (आदत, सच्चाई और कल की बात) + 2 सबसे बड़े बिहार बोर्ड ट्रैप!",
    "heading_en": "2. Simple Tenses (Habits, Truths & Past Events) + Top 2 Bihar Traps!",
    "analogy_hi": "सुबह सूरज पूरब से उगता है, आप रोज़ स्कूल जाते हैं, और कल आपने आम खाया — रोज़ की आदतों व सच्चाई के लिए **Simple Present**, और बीती घटना के लिए **Simple Past**। बस **2 सुनहरे नियम** याद रख लें तो 80% टेंस गलतियाँ आज ही खत्म हो जाएँगी!",
    "analogy_en": "The sun rises every morning, you go to school daily, and you ate a mango yesterday — daily habits and universal facts use **Simple Present**, while finished past events use **Simple Past**. Master just **2 golden rules** below to eliminate 80% of common errors!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "Simple Present, Simple Past और Simple Future की 1-नज़र तालिका",
      "title_en": "1-Glance Simple Tenses Table (Affirmative, Negative & Question)",
      "caption_hi": "ध्यान दें: Negative और Question में does या did आने पर मुख्य क्रिया से s/es और V2 हटकर शुद्ध V1 रह जाता है!",
      "caption_en": "Watch closely: Whenever `does` or `did` appears in Negative/Question, the main verb returns to pure V1!",
      "headers_hi": [
        "काल (Tense)",
        "पहचान शब्द",
        "साधारण (Positive)",
        "नकारात्मक (Negative)",
        "प्रश्नवाचक (Question)"
      ],
      "headers_en": [
        "Tense",
        "Signal Words",
        "Positive",
        "Negative",
        "Question"
      ],
      "rows": [
        {
          "cells_hi": [
            "Simple Present (ता है / ती है)",
            "daily, always, every day, usually",
            "I play. / He plays.",
            "I do not play. / He does not play.",
            "Do you play? / Does he play?"
          ],
          "cells_en": [
            "Simple Present",
            "daily, always, every day, usually",
            "I play. / He plays.",
            "I do not play. / He does not play.",
            "Do you play? / Does he play?"
          ]
        },
        {
          "cells_hi": [
            "Simple Past (आ / या / था)",
            "yesterday, ago, last night, in 2020",
            "He went to Patna.",
            "He did not go to Patna.",
            "Did he go to Patna?"
          ],
          "cells_en": [
            "Simple Past",
            "yesterday, ago, last night, in 2020",
            "He went to Patna.",
            "He did not go to Patna.",
            "Did he go to Patna?"
          ]
        },
        {
          "cells_hi": [
            "Simple Future (गा / गे / गी)",
            "tomorrow, next week, soon",
            "She will win.",
            "She will not win.",
            "Will she win?"
          ],
          "cells_en": [
            "Simple Future",
            "tomorrow, next week, soon",
            "She will win.",
            "She will not win.",
            "Will she win?"
          ]
        }
      ]
    },
    "concept_md_hi": "### 2 सबसे बड़ी बिहार बोर्ड गलतियाँ — आज ही हमेशा के लिए सुधारें!\n1. **ट्रैप #1 (`He / She / It` के साथ `s / es` भूल जाना):**\n   - गलत: ~~He go to school daily.~~\n   - सही: **He goes to school daily.** *(ही गोज़ टू स्कूल डेली)*\n   - नियम: Simple Present में कर्ता अकेला तीसरा (`He, She, It, Ram, The sun`) हो तो V1 में `s` या `es` ज़रूर लगाएँ! (`The sun rises in the east.`)\n2. **ट्रैप #2 (`Did` के साथ `V2` लगा देना):**\n   - गलत: ~~Did he went to market?~~ / ~~I did not ate food.~~\n   - सही: **Did he go to market?** / **I did not eat food.**\n   - नियम: **`Did` खुद `do` का V2 रूप है!** एक ही वाक्य में दो बार V2 कभी नहीं आता — `did` के बाद हमेशा **V1** आएगा!",
    "concept_md_en": "### Fix the Top 2 BSEB Tense Errors Forever!\n1. **Trap #1 (Forgetting `s / es` with `He / She / It`):**\n   - Wrong: ~~He go to school daily.~~\n   - Right: **He goes to school daily.**\n   - Rule: In Simple Present positive, 3rd-person singular (`He, She, It, Ravi, The sun`) ALWAYS adds `s` or `es` to V1! (`The sun rises in the east.`)\n2. **Trap #2 (Using `V2` after `Did`):**\n   - Wrong: ~~Did he went to market?~~ / ~~I did not ate food.~~\n   - Right: **Did he go to market?** / **I did not eat food.**\n   - Rule: **`Did` is already V2!** Never put two past forms together — ALWAYS use **V1** right after `did`!",
    "exam_tip_hi": "BSEB पेपर में जैसे ही **`yesterday`, `ago`, `last year`** दिखे → आँख बंद करके **Simple Past (`V2` या `did + V1`)** चुनें! और **`daily`, `always`, `every morning`** दिखे → **Simple Present (`V1` या `V1+s/es`)** चुनें!",
    "exam_tip_en": "In BSEB MCQs: spot **`yesterday`, `ago`, `last year`** → pick **Simple Past (`V2` or `did + V1`)**! Spot **`daily`, `always`, `every morning`** → pick **Simple Present (`V1` or `V1+s/es`)**!",
    "glossary_terms": [
      {
        "term_hi": "सार्वभौमिक सत्य (Universal Truth)",
        "term_en": "Universal Truth",
        "pronunciation_hi": "यूनिवर्सल ट्रुथ",
        "definition_hi": "ऐसी सच्चाई जो कभी नहीं बदलती (जैसे सूरज पूरब में उगता है) — यह हमेशा Simple Present में रहती है।",
        "definition_en": "A scientific or permanent fact (e.g., The earth moves round the sun) — ALWAYS written in Simple Present."
      }
    ],
    "quick_check": {
      "q_hi": "इस गलत वाक्य को शुद्ध करें: \"Did she wrote a letter yesterday?\"",
      "q_en": "Fix the error in: \"Did she wrote a letter yesterday?\"",
      "answer_hi": "**Did she write a letter yesterday?** (`Did` के बाद हमेशा V1 `write` लगता है, `wrote` नहीं!)",
      "answer_en": "**Did she write a letter yesterday?** (After `Did`, always use base V1 `write`, not `wrote`!)"
    }
  },
  {
    "id": "u2-sec-3-continuous-stative",
    "order": 3,
    "heading_hi": "3. Continuous Tense (अभी चल रहा काम) और Stative Verb ट्रैप!",
    "heading_en": "3. Continuous Tenses (Action in Progress) & The Stative Verb Trap!",
    "analogy_hi": "क्रिकेट की लाइव कमेंट्री सोचिए — *\"रोहित अभी खेल रहा है → Rohit is playing right now!\"* या *\"कल शाम 5 बजे बारिश हो रही थी → It was raining at 5 PM yesterday!\"*। जहाँ काम आँखों के सामने **चलता हुआ** दिखे, वहाँ **`be + V1-ing`** लगाइए। पर एक खास सावधानी: दिमाग की भावनाओं (`know, love, want`) में `-ing` कभी मत लगाइए!",
    "analogy_en": "Think of live cricket commentary: *\"Rohit is playing right now!\"* or *\"It was raining at 5 PM yesterday!\"* Whenever an action is **in motion**, use **`be + V1-ing`**. One crucial warning: feeling/mind verbs (`know, love, want, believe`) NEVER take `-ing`!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "Continuous Tense इंजन + \"No -ing\" चेतावनी बॉक्स",
      "title_en": "Continuous Tense Engine + \"No -ing\" Stative Verb Warning",
      "caption_hi": "चलते हुए काम में is/am/are (अभी), was/were (तब), will be (आगे) + V1-ing लगाएँ। लेकिन know, love, like, want, believe में -ing न लगाएँ!",
      "caption_en": "Use is/am/are (now), was/were (then), will be (later) + V1-ing for live actions. NEVER add -ing to know, love, like, want, or believe!",
      "viewBox": "0 0 660 245",
      "elements": [
        {
          "kind": "rect",
          "x": 24,
          "y": 20,
          "width": 380,
          "height": 205,
          "rx": 12,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 214,
          "y": 46,
          "text_hi": "चलता हुआ काम (be + V1-ing)",
          "text_en": "Action in Progress (be + V1-ing)",
          "fill": "#1E3A8A",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 42,
          "y": 66,
          "width": 344,
          "height": 42,
          "rx": 8,
          "fill": "#FFFFFF",
          "stroke": "#2563EB",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 214,
          "y": 88,
          "text_hi": "अभी (Now): is / am / are + V-ing",
          "text_en": "Present: She is studying now.",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 42,
          "y": 118,
          "width": 344,
          "height": 42,
          "rx": 8,
          "fill": "#FFFFFF",
          "stroke": "#D97706",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 214,
          "y": 140,
          "text_hi": "उस समय (Past): was / were + V-ing",
          "text_en": "Past: It was raining at 5 PM.",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 42,
          "y": 170,
          "width": 344,
          "height": 42,
          "rx": 8,
          "fill": "#FFFFFF",
          "stroke": "#059669",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 214,
          "y": 192,
          "text_hi": "कल उस समय (Future): will be + V-ing",
          "text_en": "Future: We will be travelling.",
          "fill": "#059669",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 424,
          "y": 20,
          "width": 212,
          "height": 205,
          "rx": 12,
          "fill": "#FEF2F2",
          "stroke": "#DC2626",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 530,
          "y": 48,
          "text_hi": "सावधान! No -ing!",
          "text_en": "STOP! No -ing!",
          "fill": "#DC2626",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 530,
          "y": 84,
          "text_hi": "know · love · like",
          "text_en": "know · love · like",
          "fill": "#7F1D1D",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 530,
          "y": 108,
          "text_hi": "want · believe · see",
          "text_en": "want · believe · see",
          "fill": "#7F1D1D",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "line",
          "x1": 444,
          "y1": 130,
          "x2": 616,
          "y2": 130,
          "stroke": "#FCA5A5",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 530,
          "y": 156,
          "text_hi": "गलत: I am knowing.",
          "text_en": "Wrong: I am knowing.",
          "fill": "#DC2626",
          "fontSize": 12,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "label",
          "x": 530,
          "y": 192,
          "text_hi": "सही: I know him.",
          "text_en": "Right: I know him.",
          "fill": "#059669",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### Continuous पहचानने के जादुई संकेत शब्द\n- **Present Continuous (`is/am/are + V-ing`):** `now`, `at present`, `Look!`, `Listen!`, `at this moment`।\n  - उदाहरण: **Listen! Someone is knocking at the door.** *(सुनो! कोई दरवाज़ा खटखटा रहा है।)*\n- **Past Continuous (`was/were + V-ing`):** जब भूतकाल में कोई काम चल रहा था और बीच में दूसरा काम हुआ:\n  - उदाहरण: **I was reading when the lights went out.** *(जब बिजली गई, मैं पढ़ रहा था।)*\n\n### Stative Verbs (मन/भावना की क्रियाएँ)\nहिंदी में हम बोलते हैं *\"मैं उसे जान रहा हूँ\"* या *\"मुझे यह पसंद आ रहा है\"*, इसलिए छात्र गलती से `\"I am knowing him\"` लिख देते हैं। अंग्रेज़ी में हमेशा Simple Present लिखें: **\"I know him.\"**",
    "concept_md_en": "### Magic Signal Words for Continuous Tenses\n- **Present Continuous (`is/am/are + V-ing`):** `now`, `at present`, `Look!`, `Listen!`, `at this moment`.\n  - Example: **Listen! Someone is knocking at the door.**\n- **Past Continuous (`was/were + V-ing`):** An ongoing past background action interrupted by a short event (`V2`):\n  - Example: **I was reading when the lights went out.**\n\n### Stative Verbs (Mind & Feeling Verbs)\nNever write `\"I am knowing him\"` or `\"She is loving music\"`. Always use Simple Present: **\"I know him.\"**, **\"She loves music.\"**",
    "exam_tip_hi": "BSEB 2022–2024 का बार-बार पूछा सवाल: `\"Look! It ___ outside.\"` → `Look!` या `Listen!` देखते ही **Present Continuous (`is raining`)** चुनें!",
    "exam_tip_en": "Repeated BSEB MCQ: `\"Look! It ___ outside.\"` → Whenever a sentence starts with `Look!` or `Listen!`, pick **Present Continuous (`is raining`)**!",
    "glossary_terms": [
      {
        "term_hi": "अपूर्ण काल (Continuous Tense)",
        "term_en": "Continuous Tense",
        "pronunciation_hi": "कॉन्टिनुअस टेंस",
        "definition_hi": "वह काल जो बताता है कि कोई काम उस क्षण जारी है (be + V1-ing)।",
        "definition_en": "The tense showing an action currently in progress (be + V1-ing)."
      },
      {
        "term_hi": "भाववाचक क्रिया (Stative Verb)",
        "term_en": "Stative Verb",
        "pronunciation_hi": "स्टेटिव वर्ब",
        "definition_hi": "मन की स्थिति या भावना बताने वाली क्रियाएँ (know, love, want, believe) जो -ing नहीं लेतीं।",
        "definition_en": "Verbs expressing mental state or emotion (know, love, want, believe) that do not take -ing."
      }
    ],
    "quick_check": {
      "q_hi": "सही विकल्प चुनें: \"I ___ your father very well.\" (am knowing / know)",
      "q_en": "Pick the right verb: \"I ___ your father very well.\" (am knowing / know)",
      "answer_hi": "**know** — क्योंकि `know` एक Stative Verb है, इसमें `-ing` नहीं लगता!",
      "answer_en": "**know** — because `know` is a Stative Verb and never takes `-ing`!"
    }
  },
  {
    "id": "u2-sec-4-perfect-since-for",
    "order": 4,
    "heading_hi": "4. Perfect Tense (V3), प्रसिद्ध \"Doctor-Patient\" नियम और Since बनाम For",
    "heading_en": "4. Perfect Tenses (V3), The Famous BSEB Two-Action Rule & Since vs For",
    "analogy_hi": "मान लीजिए आप सुबह 8 बजे बस में बैठे और अभी 10 बजे हैं। कोई पूछे **\"कब से बैठे हो?\"** तो आप दो तरह से जवाब दे सकते हैं: (1) शुरुआती समय बताकर — **सुबह 8 बजे से (`since 8 AM`)**, या (2) कुल घंटे गिनकर — **2 घंटे से (`for 2 hours`)**! बस यही **`since` बनाम `for`** का पूरा रहस्य है!",
    "analogy_en": "Suppose you boarded a bus at 8 AM and it is 10 AM now. You can state the time in two ways: (1) Starting point — **`since 8 AM`**, or (2) Counted total duration — **`for 2 hours`**! That single distinction solves EVERY `since` vs `for` board question!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "Since बनाम For और Perfect Tense के BSEB पक्के नियम",
      "title_en": "Since vs For & High-Yield BSEB Perfect Tense Rules",
      "caption_hi": "यदि वाक्य में since या for लगा हो, तो Present Continuous (\"is living\") गलत होगा — हमेशा Perfect Continuous (\"has been living\") चुनें!",
      "caption_en": "Whenever `since` or `for` shows ongoing duration from the past, NEVER use `is living` — always use `has/have been living`!",
      "headers_hi": [
        "नियम / शब्द",
        "कब प्रयोग करें",
        "बिहार बोर्ड उदाहरण"
      ],
      "headers_en": [
        "Rule / Keyword",
        "When to Use",
        "BSEB Exam Example"
      ],
      "rows": [
        {
          "cells_hi": [
            "Present Perfect (has/have + V3)",
            "काम अभी-अभी पूरा हुआ (just, already, yet)",
            "He has just arrived. (वह अभी-अभी पहुँचा है।)"
          ],
          "cells_en": [
            "Present Perfect (has/have + V3)",
            "Just completed action (just, already, yet)",
            "He has just arrived."
          ]
        },
        {
          "cells_hi": [
            "Past Perfect + Simple Past",
            "भूतकाल के 2 काम: पहला had + V3, दूसरा V2",
            "The patient had died before the doctor came."
          ],
          "cells_en": [
            "Past Perfect + Simple Past",
            "2 past actions: 1st = had + V3, 2nd = V2",
            "The patient had died before the doctor came."
          ]
        },
        {
          "cells_hi": [
            "Since (निश्चित शुरुआती बिंदु)",
            "morning, Monday, July, 2020, childhood, 8 AM",
            "It has been raining since morning."
          ],
          "cells_en": [
            "Since (Exact Starting Point)",
            "morning, Monday, July, 2020, childhood, 8 AM",
            "It has been raining since morning."
          ]
        },
        {
          "cells_hi": [
            "For (कुल समय की गिनती)",
            "2 hours, 5 days, 3 weeks, 10 years, a long time",
            "She has been studying for two hours."
          ],
          "cells_en": [
            "For (Total Duration Count)",
            "2 hours, 5 days, 3 weeks, 10 years, a long time",
            "She has been studying for two hours."
          ]
        }
      ]
    },
    "concept_md_hi": "### बिहार बोर्ड का सबसे प्रसिद्ध Past Perfect नियम (लगभग हर साल आता है!)\nजब भूतकाल में **दो घटनाएँ** एक के बाद एक हों:\n- **जो काम पहले पूरा हुआ** → `had + V3` (Past Perfect)\n- **जो काम बाद में हुआ** → `V2` (Simple Past)\n- उदाहरण 1: **The patient had died before the doctor came.** *(डॉक्टर के आने से पहले रोगी मर चुका था।)*\n- उदाहरण 2: **The train had left before we reached the station.** *(हमारे स्टेशन पहुँचने से पहले ट्रेन जा चुकी थी।)*\n\n### \"मैं 2020 से पटना में रह रहा हूँ\" — सही अंग्रेज़ी क्या है?\n- गलत: ~~I am living in Patna since 2020.~~\n- सही: **I have been living in Patna since 2020.** *(आई हैव बीन लिविंग इन पटना सिंस 2020।)*",
    "concept_md_en": "### BSEB's Most Repeated Past Perfect Pattern!\nWhen **two actions** happen one after another in the past:\n- **Earlier action (happened 1st)** → `had + V3` (Past Perfect)\n- **Later action (happened 2nd)** → `V2` (Simple Past)\n- Example 1: **The patient had died before the doctor came.**\n- Example 2: **The train had left before we reached the station.**\n\n### Fixing the Classic Since/For Error\n- Wrong: ~~I am living in Patna since 2020.~~\n- Right: **I have been living in Patna since 2020.**",
    "exam_tip_hi": "ट्रिक: `before` से पहले `had + V3` और `before` के बाद `V2`! (`The train had left BEFORE we reached.`)। और संख्या (2 hours, 3 days, 5 years) दिखे → **`for`**, नाम या सन् (Monday, morning, 2019) दिखे → **`since`**!",
    "exam_tip_en": "Shortcut: `had + V3` comes BEFORE `before`, and `V2` comes AFTER `before`! Number of units (2 hours, 5 years) → **`for`**; named start point (Monday, 2019, morning) → **`since`**!",
    "glossary_terms": [
      {
        "term_hi": "पूर्ण काल (Perfect Tense)",
        "term_en": "Perfect Tense",
        "pronunciation_hi": "परफ़ेक्ट टेंस",
        "definition_hi": "वह काल जो किसी काम के पूरा हो चुके होने को दर्शाता है (has / have / had + V3)।",
        "definition_en": "The tense expressing a completed action using has / have / had + V3."
      },
      {
        "term_hi": "अवधि (Duration)",
        "term_en": "Duration",
        "pronunciation_hi": "ड्यूरेशन",
        "definition_hi": "काम कितने समय तक चला (2 घंटे, 5 दिन) — इसके साथ हमेशा `for` लगता है।",
        "definition_en": "Total length of time an action lasts (2 hours, 5 days) — always takes `for`."
      }
    ],
    "quick_check": {
      "q_hi": "रिक्त स्थान भरें: \"He ___ in this school since 2021.\" (is teaching / has been teaching)",
      "q_en": "Fill in the blank: \"He ___ in this school since 2021.\" (is teaching / has been teaching)",
      "answer_hi": "**has been teaching** — क्योंकि वाक्य में `since 2021` दिया है!",
      "answer_en": "**has been teaching** — because `since 2021` requires Present Perfect Continuous!"
    }
  },
  {
    "id": "u2-sec-5-formula-card",
    "order": 5,
    "heading_hi": "5. परीक्षा से 5 मिनट पहले — Tenses मास्टर सूत्र कार्ड",
    "heading_en": "5. 5-Minute Revision — Master Tenses Formula Card",
    "analogy_hi": "बोर्ड परीक्षा में 95% Tense के प्रश्न इन्हीं 6 सूत्रों से पूछे जाते हैं। बस संकेत शब्द पहचानिए और सही सूत्र लगा दीजिए!",
    "analogy_en": "Over 95% of BSEB Tense questions come straight from these 6 formulas. Spot the time clue and plug in the formula!",
    "visual_diagram": {
      "type": "FORMULA_CARD",
      "title_hi": "बिहार बोर्ड के 6 सबसे महत्वपूर्ण Tense सूत्र",
      "title_en": "6 Highest-Yield BSEB Tense Formulas",
      "formulas": [
        {
          "latex": "\\text{Sub} + V_1(s/es) + \\text{Obj}",
          "meaning_hi": "Simple Present (daily, always, universal truth)",
          "meaning_en": "Simple Present (daily, always, universal truth)",
          "example_hi": "The earth moves round the sun.",
          "example_en": "The earth moves round the sun."
        },
        {
          "latex": "\\text{Sub} + V_2 \\quad|\\quad \\text{did} + V_1",
          "meaning_hi": "Simple Past (yesterday, ago, last night)",
          "meaning_en": "Simple Past (yesterday, ago, last night)",
          "example_hi": "He came yesterday. / Did he come?",
          "example_en": "He came yesterday. / Did he come?"
        },
        {
          "latex": "\\text{Sub} + \\text{is/am/are} + V_1\\text{-ing}",
          "meaning_hi": "Present Continuous (now, Look!, Listen!)",
          "meaning_en": "Present Continuous (now, Look!, Listen!)",
          "example_hi": "Look! Birds are flying.",
          "example_en": "Look! Birds are flying."
        },
        {
          "latex": "\\text{Sub} + \\text{has/have} + V_3",
          "meaning_hi": "Present Perfect (just, already, yet)",
          "meaning_en": "Present Perfect (just, already, yet)",
          "example_hi": "I have just finished my work.",
          "example_en": "I have just finished my work."
        },
        {
          "latex": "\\text{had} + V_3 + \\text{before} + V_2",
          "meaning_hi": "Past Perfect (भूतकाल के 2 काम)",
          "meaning_en": "Past Perfect + Simple Past (2 past actions)",
          "example_hi": "The train had left before I arrived.",
          "example_en": "The train had left before I arrived."
        },
        {
          "latex": "\\text{has/have been} + V_1\\text{-ing} + \\text{since / for}",
          "meaning_hi": "Present Perfect Continuous (समय के साथ जारी काम)",
          "meaning_en": "Present Perfect Continuous (ongoing with time)",
          "example_hi": "It has been raining for two hours.",
          "example_en": "It has been raining for two hours."
        }
      ]
    },
    "concept_md_hi": "### Conditional का 1 बोनस बोर्ड सूत्र (अक्सर 1 अंक पक्का देता है!)\n- **If + Simple Present (`V1/V1+s`), Subject + `will + V1`:**\n  - उदाहरण: **If it rains, we will stay at home.** *(यदि बारिश होगी, तो हम घर पर रहेंगे।)*\n  - ध्यान दें: `If` वाले हिस्से में कभी `will` नहीं लगाते (`If it will rain` गलत है!)।",
    "concept_md_en": "### 1 Bonus BSEB Conditional Formula (Often Worth 1 Free Mark!)\n- **If + Simple Present (`V1/V1+s`), Subject + `will + V1`:**\n  - Example: **If it rains, we will stay at home.**\n  - Never put `will` inside the `If` clause (`If it will rain` is wrong!).",
    "exam_tip_hi": "परीक्षा में किसी वाक्य का Tense पहचानते समय हमेशा वाक्य के **अंत या शुरुआत के समय-शब्द** (`yesterday`, `now`, `daily`, `since`, `before`, `tomorrow`) पर सबसे पहले गोला लगाएँ!",
    "exam_tip_en": "In the exam, always circle the **time-clue word** (`yesterday`, `now`, `daily`, `since`, `before`, `tomorrow`) first — it gives away the answer immediately!",
    "glossary_terms": []
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{He/She/It} + V_1(s/es)",
      "label_hi": "Simple Present एकवचन नियम",
      "label_en": "Simple Present 3rd-Person Singular Rule"
    },
    {
      "latex": "\\text{Did / Does} + \\text{Sub} + V_1\\, ?",
      "label_hi": "Did/Does के बाद हमेशा मूल क्रिया V1",
      "label_en": "Always Base V1 after Did/Does"
    },
    {
      "latex": "\\text{had} + V_3 + \\text{before} + V_2",
      "label_hi": "भूतकाल की 2 घटनाओं का BSEB नियम",
      "label_en": "BSEB Two-Past-Events Rule"
    },
    {
      "latex": "\\text{has/have been} + V_1\\text{-ing} + \\text{since / for}",
      "label_hi": "Since (बिंदु) व For (अवधि) सूत्र",
      "label_en": "Present Perfect Continuous Formula"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "SIGNAL 1",
      "fact_hi": "`daily, always, every day, usually` → हमेशा Simple Present (`V1 / V1+s/es`)।",
      "fact_en": "`daily, always, every day, usually` → ALWAYS Simple Present (`V1 / V1+s/es`)."
    },
    {
      "tag": "SIGNAL 2",
      "fact_hi": "`yesterday, ago, last night/week` → हमेशा Simple Past (`V2` या `did + V1`)।",
      "fact_en": "`yesterday, ago, last night/week` → ALWAYS Simple Past (`V2` or `did + V1`)."
    },
    {
      "tag": "SIGNAL 3",
      "fact_hi": "`Look!, Listen!, now, at present` → Present Continuous (`is/am/are + V-ing`)।",
      "fact_en": "`Look!, Listen!, now, at present` → Present Continuous (`is/am/are + V-ing`)."
    },
    {
      "tag": "SIGNAL 4",
      "fact_hi": "`If + Simple Present`, अगला भाग `will + V1` (If के साथ `will` कभी नहीं!)।",
      "fact_en": "`If + Simple Present`, main clause `will + V1` (NEVER `will` inside `If`!)."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "\"He go to school daily.\" (He/She/It के साथ s/es छोड़ देना)",
      "mistake_en": "Writing \"He go to school daily\" without -s/-es.",
      "fix_hi": "सही रूप: **\"He goes to school daily.\"** (अकेला तीसरा कर्ता = `s/es` पक्का!)",
      "fix_en": "Correct: **\"He goes to school daily.\"** (He/She/It always takes `s/es` in Simple Present!)"
    },
    {
      "mistake_hi": "\"Did he went to Patna?\" (Did के साथ V2 लगा देना)",
      "mistake_en": "Writing \"Did he went to Patna?\" with double past tense.",
      "fix_hi": "सही रूप: **\"Did he go to Patna?\"** (`Did` के बाद हमेशा V1 आता है!)",
      "fix_en": "Correct: **\"Did he go to Patna?\"** (Base V1 always follows `Did`!)"
    },
    {
      "mistake_hi": "\"I am knowing him.\" (Stative verb में -ing जोड़ना)",
      "mistake_en": "Writing \"I am knowing him\" with -ing on a stative verb.",
      "fix_hi": "सही रूप: **\"I know him.\"** (`know, love, want, believe` में `-ing` नहीं लगता!)",
      "fix_en": "Correct: **\"I know him.\"** (`know, love, want, believe` never take `-ing`!)"
    },
    {
      "mistake_hi": "\"It is raining since morning.\" (since/for के साथ Present Continuous)",
      "mistake_en": "Using Present Continuous with `since/for`: \"It is raining since morning.\"",
      "fix_hi": "सही रूप: **\"It has been raining since morning.\"**",
      "fix_en": "Correct: **\"It has been raining since morning.\"**"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "सही Tense / Verb Form चुनें (BSEB Objective MCQs)",
      "topic_en": "Choose Correct Tense / Verb Form MCQs",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 6
    },
    {
      "topic_hi": "Since बनाम For एवं Past Perfect (Doctor-Patient नियम)",
      "topic_en": "Since vs For & Past Perfect Two-Action Rule",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 4
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 5,
  "analogy_count": 5,
  "bseb_pyq_mapped": true,
  "syllabus_year": "2026-27"
}$json$::jsonb,
  'PUBLISHED',
  1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json        = EXCLUDED.mindmap_json,
  sections_json       = EXCLUDED.sections_json,
  board_capsule_json  = EXCLUDED.board_capsule_json,
  quality_checks_json = EXCLUDED.quality_checks_json,
  status              = EXCLUDED.status,
  version             = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'skill-eng-f-ch2',
  4,
  'विद्यार्थियों को रटने के बजाय एक विज़ुअल समय-रेखा (Past-Present-Future) से सभी प्रमुख Tenses समझाना; बिहार के विद्यार्थियों की 4 सबसे आम व्याकरण त्रुटियों (He go, Did he went, I am knowing, is living since) को जड़ से समाप्त करना।',
  'Teach core tenses logically on a single Past-Present-Future visual timeline without rote tables; permanently cure the 4 highest-frequency Bihar tense errors (He go, Did he went, I am knowing, is living since).',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "5-मिनट स्टेप-टाइमलाइन कोरस + Simple Present व Simple Past की जड़",
    "phase_en": "5-Min Step-Timeline Chorus + Simple Present & Simple Past Core",
    "teacher_action_hi": "मिनट 0–5: पूरी कक्षा खड़ी हो — एक कदम पीछे लेकर बोलें \"Yesterday I played!\", बीच में खड़े होकर \"Today I play!\", एक कदम आगे लेकर \"Tomorrow I will play!\"। मिनट 5–25: बोर्ड पर 3-ज़ोन समय-रेखा खींचें और V1, V2, V3 समझाएँ। मिनट 25–35: \"He goes\" में s/es और \"Did he go?\" का जादुई नियम समझाएँ। मिनट 35–40: 5 वाक्य त्रुटि-सुधार खेल।",
    "teacher_action_en": "Mins 0–5: Physical chorus — students step back and chant \"Yesterday I played!\", stand centre for \"Today I play!\", step forward for \"Tomorrow I will play!\" Mins 5–25: Draw the 3-zone timeline on the board and introduce V1/V2/V3. Mins 25–35: Teach the He/She/It + s/es and Did + V1 rules. Mins 35–40: 5-sentence Error-Hunter game.",
    "student_check_hi": "बोर्ड पर लिखें \"Did Ravi went home?\" और पूछें इसमें पुलिस किसे पकड़ेगी? (उत्तर: went को पकड़कर go बनाएँगे!)",
    "student_check_en": "Write \"Did Ravi went home?\" on the board and ask the class which word is breaking the law! (Fix `went` → `go`!)"
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "Continuous Tense (लाइव एक्शन) और Stative Verb ट्रैप",
    "phase_en": "Continuous Tenses (Live Action) & Stative Verb Trap",
    "teacher_action_hi": "मिनट 0–5: शिक्षक कक्षा में चलने, लिखने और पानी पीने का अभिनय करें और छात्र बोलें — \"Sir is walking! Sir is writing!\"। मिनट 5–20: Present/Past/Future Continuous (`be + V-ing`) की तुलना दिखाएँ। मिनट 20–32: \"No -ing लाल बॉक्स\" (`know, love, like, want`) समझाएँ। मिनट 32–40: Look!/Listen! आधारित 5 बोर्ड MCQ।",
    "teacher_action_en": "Mins 0–5: Mime walking, writing, and reading while students call out live commentary — \"Sir is walking! Sir is writing!\" Mins 5–20: Contrast Present, Past, and Future Continuous. Mins 20–32: Highlight the red \"No -ing\" Stative Verb box (`know, love, want`). Mins 32–40: Solve 5 Look!/Listen! BSEB MCQs.",
    "student_check_hi": "छात्रों से पूछें: \"मैं तुम्हें जानता हूँ\" के लिए \"I am knowing you\" क्यों गलत है?",
    "student_check_en": "Ask students: Why is \"I am knowing you\" wrong, and what is the clean fix?"
  },
  {
    "period_no": 3,
    "duration_mins": 40,
    "phase_hi": "Perfect Tense, Doctor-Patient नियम और Since बनाम For",
    "phase_en": "Perfect Tenses, Two-Action Past Rule & Since vs For",
    "teacher_action_hi": "मिनट 0–5: टाइम-वर्ड रैपिड फ़ायर — शिक्षक बोलें \"Monday\", छात्र बोलें \"Since!\"; शिक्षक बोलें \"3 hours\", छात्र बोलें \"For!\"। मिनट 5–22: बोर्ड पर घड़ी और कैलेंडर बनाकर `since` (शुरुआत) बनाम `for` (गिनती) स्पष्ट करें। मिनट 22–35: 2-घटना तीर चित्र से \"The patient had died before the doctor came\" सिखाएँ। मिनट 35–40: कॉपी जाँच।",
    "teacher_action_en": "Mins 0–5: Rapid-fire chorus — teacher calls \"Monday\" → class shouts \"Since!\"; teacher calls \"3 hours\" → class shouts \"For!\" Mins 5–22: Draw a clock + calendar on the board to contrast `since` (start) vs `for` (count). Mins 22–35: Draw a 2-stop past arrow for the Doctor-Patient rule. Mins 35–40: Quick notebook check.",
    "student_check_hi": "पूछें: \"2018\" के साथ `since` आएगा या `for`? और \"5 years\" के साथ?",
    "student_check_en": "Ask: Does \"2018\" take `since` or `for`? What about \"5 years\"?"
  },
  {
    "period_no": 4,
    "duration_mins": 40,
    "phase_hi": "संकेत-शब्द बोर्ड मैराथन व लाइव क्विज़",
    "phase_en": "Signal-Word Board Marathon & Live Quiz",
    "teacher_action_hi": "मिनट 0–15: बोर्ड पर Signal-Word चार्ट (daily / yesterday / now / just / since / before / if) का रिवीजन। मिनट 15–30: पिछले 4 वर्षों के 10 BSEB Tense प्रश्न हल कराएँ। मिनट 30–40: कमज़ोर छात्रों को जोड़ियों में 5 आसान वाक्य बनाने में मदद करें।",
    "teacher_action_en": "Mins 0–15: Revise the Signal-Word cheat chart on the board. Mins 15–30: Solve 10 authentic BSEB Tense PYQs together. Mins 30–40: Peer-buddy exercise where stronger and shy students co-build 5 sentences.",
    "student_check_hi": "वाक्य \"If it ___ (rain), I will not go.\" में सही verb भरवाएँ।",
    "student_check_en": "Have the class complete \"If it ___ (rain), I will not go.\" and explain why `will rain` is wrong."
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड 1: समय-रेखा (Past ← NOW → Future)",
    "heading_en": "Blackboard 1: Visual Tense Line (Past ← NOW → Future)",
    "points_hi": [
      "PAST (कल): V2 | did + V1 | was/were + V-ing | had + V3",
      "PRESENT (आज): V1(s/es) | do/does + V1 | is/am/are + V-ing | has/have + V3",
      "FUTURE (आगे): will/shall + V1 | will be + V-ing"
    ],
    "points_en": [
      "PAST: V2 | did + V1 | was/were + V-ing | had + V3",
      "PRESENT: V1(s/es) | do/does + V1 | is/am/are + V-ing | has/have + V3",
      "FUTURE: will/shall + V1 | will be + V-ing"
    ]
  },
  {
    "heading_hi": "ब्लैकबोर्ड 2: 4 बिहार बोर्ड क्रॉस-आउट बॉक्स (यह कभी न लिखें!)",
    "heading_en": "Blackboard 2: 4 Bihar Board Fix-It Rules",
    "points_hi": [
      "He go (गलत) → He goes (सही)",
      "Did he went? (गलत) → Did he go? (सही)",
      "I am knowing (गलत) → I know (सही)",
      "He is living here since 2020 (गलत) → He has been living here since 2020 (सही)"
    ],
    "points_en": [
      "He go (Wrong) → He goes (Right)",
      "Did he went? (Wrong) → Did he go? (Right)",
      "I am knowing (Wrong) → I know (Right)",
      "is living since 2020 (Wrong) → has been living since 2020 (Right)"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "समय-कदम खेल (Step-Back Past, Stand Present, Step-Forward Future)",
    "title_en": "Physical Time-Step Game",
    "materials_hi": "केवल कक्षा की जगह (कोई सामग्री आवश्यक नहीं)",
    "materials_en": "Just classroom floor space (zero materials needed)",
    "steps_hi": "शिक्षक कोई समय-संकेत बोलें (जैसे \"yesterday\", \"tomorrow\", \"daily\", \"now\")। छात्र तुरंत सही दिशा में कदम बढ़ाकर वाक्य बोलें — इससे मस्तिष्क समय और क्रिया को सीधे जोड़ लेता है।",
    "steps_en": "Teacher calls a time cue (\"yesterday\", \"tomorrow\", \"daily\", \"now\"). Students step back/centre/forward and chant a matching verb form."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "अपनी कॉपी में 10 दैनिक क्रियाओं (go, eat, read, write, play, come, see, drink, take, give) के V1, V2, V3 और V-ing रूप लिखकर याद करें।",
    "task_en": "Write and memorize V1, V2, V3, and V-ing forms of 10 everyday verbs (go, eat, read, write, play, come, see, drink, take, give)."
  },
  {
    "level": "BOARD",
    "task_hi": "अपनी दैनिक दिनचर्या पर Simple Present में 5 वाक्य और कल किए गए कामों पर Simple Past में 5 वाक्य लिखें।",
    "task_en": "Write 5 Simple Present sentences about your daily routine and 5 Simple Past sentences about what you did yesterday."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "Since से 3 वाक्य, For से 3 वाक्य, और `had + V3 ... before ... V2` पैटर्न पर 2 वाक्य खुद बनाकर लिखें।",
    "task_en": "Create 3 sentences with `since`, 3 with `for`, and 2 original sentences using the `had + V3 ... before ... V2` pattern."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र सोचते हैं कि भूतकाल के हर वाक्य में `went / ate / played` (V2) आएगा, चाहे `did` भी लगा हो।",
    "misconception_en": "Students keep V2 even after `did` (e.g., \"I did not went\", \"Did she ate?\").",
    "correction_hi": "कहानी सुनाएँ: `Did` भूतकाल का पूरा बोझ अपने कंधे पर उठा लेता है, इसलिए मुख्य क्रिया हल्की होकर V1 (`go, eat`) बन जाती है!",
    "correction_en": "Use the helper-load metaphor: `Did` already carries the past-tense weight, so the main verb stays light in base V1!"
  },
  {
    "misconception_hi": "छात्र \"सुबह से बारिश हो रही है\" में \"रही है\" देखकर `It is raining since morning` लिख देते हैं।",
    "misconception_en": "Students translate \"raha hai + time\" directly into Present Continuous (`is raining since morning`).",
    "correction_hi": "नियम स्पष्ट करें: केवल \"रही है\" = `is raining`, लेकिन जैसे ही \"सुबह से / 2 घंटे से\" जुड़ जाए = **`has been raining`**!",
    "correction_en": "Contrast clearly: plain \"is happening\" = `is raining`, but the second a duration (`since/for`) appears, upgrade to **`has been raining`**!"
  }
]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods                   = EXCLUDED.duration_periods,
  objectives_hi                      = EXCLUDED.objectives_hi,
  objectives_en                      = EXCLUDED.objectives_en,
  teaching_steps_json                = EXCLUDED.teaching_steps_json,
  blackboard_points_json             = EXCLUDED.blackboard_points_json,
  classroom_activities_json          = EXCLUDED.classroom_activities_json,
  homework_json                      = EXCLUDED.homework_json,
  common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Simple Present s/es
  (
    '10000006-0002-4000-8000-000000000001', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Simple Present s/es', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', 'BSEB 2023',
    'सही अंग्रेज़ी वाक्य बनाएँ: "वह रोज़ एक किताब पढ़ती है।"',
    'Build the correct English sentence: "She reads a book daily."',
    NULL, NULL,
    '`She` (अकेली एक) के साथ Simple Present में क्रिया में `s` लगेगा — `reads`, न कि `read`!',
    'With `She` in Simple Present, add `-s` to the verb (`reads`, not `read`)!',
    '**"She reads a book daily"** — `He/She/It` + `V1(s/es)` + `Object`।',
    '**"She reads a book daily"** — follows `He/She/It + V1(s/es) + Object`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "वह रोज़ एक किताब पढ़ती है।",
  "prompt_en": "Build the correct Simple Present sentence",
  "grammar_formula": "He/She/It + V1(s/es) + Object",
  "tokens": [
    "She",
    "reads",
    "a",
    "book",
    "daily"
  ],
  "distractors": [
    "read",
    "is"
  ],
  "correct_sentence": "She reads a book daily",
  "pronunciation_hi": "शी रीड्स अ बुक डेली"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Did + V1 Rule
  (
    '10000006-0002-4000-8000-000000000002', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Did + V1 Rule', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', 'BSEB 2024',
    'सही प्रश्न बनाएँ: "क्या वह कल स्कूल गया?"',
    'Build the correct Simple Past question: "Did he go to school?"',
    NULL, NULL,
    '`Did` के बाद हमेशा **V1 (`go`)** लगता है — `went` कभी नहीं!',
    'Always use base V1 (`go`) after `Did` — never `went`!',
    '**"Did he go to school?"** — `Did` पहले ही भूतकाल दिखाता है, इसलिए मुख्य क्रिया `go` (V1) रहेगी।',
    '**"Did he go to school?"** — `Did` carries past tense, keeping `go` in base V1.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "क्या वह स्कूल गया?",
  "prompt_en": "Build the Simple Past question without the double-past trap",
  "grammar_formula": "Did + Subject + V1 + Place?",
  "tokens": [
    "Did",
    "he",
    "go",
    "to",
    "school?"
  ],
  "distractors": [
    "went",
    "goes"
  ],
  "correct_sentence": "Did he go to school?",
  "pronunciation_hi": "डिड ही गो टू स्कूल?"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Present Continuous
  (
    '10000006-0002-4000-8000-000000000003', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Present Continuous', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "लड़के अभी क्रिकेट खेल रहे हैं।"',
    'Build the Present Continuous sentence: "The boys are playing cricket now."',
    NULL, NULL,
    '`The boys` बहुवचन है + `now` (अभी चल रहा काम) → `are playing`!',
    '`The boys` is plural + `now` (ongoing) → `are playing`!',
    '**"The boys are playing cricket now"** — बहुवचन कर्ता के साथ `are + V1-ing`।',
    '**"The boys are playing cricket now"** — plural subject + `are + V-ing`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "लड़के अभी क्रिकेट खेल रहे हैं।",
  "prompt_en": "Build the live ongoing Present Continuous sentence",
  "grammar_formula": "Plural Subject + are + V1-ing + Object + now",
  "tokens": [
    "The",
    "boys",
    "are",
    "playing",
    "cricket",
    "now"
  ],
  "distractors": [
    "is",
    "played"
  ],
  "correct_sentence": "The boys are playing cricket now",
  "pronunciation_hi": "द बॉयज़ आर प्लेइंग क्रिकेट नाउ"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Perfect Continuous Since
  (
    '10000006-0002-4000-8000-000000000004', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Perfect Continuous Since', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', 'BSEB 2023',
    'सही वाक्य बनाएँ: "सुबह से बारिश हो रही है।"',
    'Build the sentence: "It has been raining since morning."',
    NULL, NULL,
    '`since morning` के साथ `is raining` गलत है — **`has been raining`** चुनें!',
    'With `since morning`, choose **`has been raining`** (never `is raining`)!',
    '**"It has been raining since morning"** — निश्चित शुरुआती समय (`morning`) के साथ `since` और `has been + V-ing` आता है।',
    '**"It has been raining since morning"** — exact start time (`morning`) takes `since` + `has been + V-ing`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "सुबह से बारिश हो रही है।",
  "prompt_en": "Build the Present Perfect Continuous sentence with since",
  "grammar_formula": "It + has been + V1-ing + since + Start Time",
  "tokens": [
    "It",
    "has",
    "been",
    "raining",
    "since",
    "morning"
  ],
  "distractors": [
    "is",
    "for"
  ],
  "correct_sentence": "It has been raining since morning",
  "pronunciation_hi": "इट हैज़ बीन रेनिंग सिंस मॉर्निंग"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (TOPPER, PRACTICE) — Past Perfect Two Actions
  (
    '10000006-0002-4000-8000-000000000005', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Past Perfect Two Actions', 'PRACTICE', 'SENTENCE_BUILDER', 'TOPPER', 'BSEB 2024',
    'प्रसिद्ध बोर्ड वाक्य बनाएँ: "डॉक्टर के आने से पहले रोगी मर चुका था।"',
    'Build the classic BSEB sentence: "The patient had died before the doctor came."',
    NULL, NULL,
    'पहले होने वाला काम = `had died`, बाद वाला काम = `came` (V2)!',
    'Earlier event = `had died`; later event = `came` (V2)!',
    '**"The patient had died before the doctor came"** — यह बिहार बोर्ड के सबसे लोकप्रिय Past Perfect वाक्यों में से एक है।',
    '**"The patient had died before the doctor came"** — classic `had + V3` before `V2`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "डॉक्टर के आने से पहले रोगी मर चुका था।",
  "prompt_en": "Build the two-event Past Perfect sentence",
  "grammar_formula": "Sub1 + had + V3 + before + Sub2 + V2",
  "tokens": [
    "The",
    "patient",
    "had",
    "died",
    "before",
    "the",
    "doctor",
    "came"
  ],
  "distractors": [
    "has",
    "come"
  ],
  "correct_sentence": "The patient had died before the doctor came",
  "pronunciation_hi": "द पेशेंट हैड डाइड बिफ़ोर द डॉक्टर केम"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (FOUNDATION, PRACTICE) — Timeline Visual Match
  (
    '10000006-0002-4000-8000-000000000006', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Timeline Visual Match', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', NULL,
    'समय-रेखा पर लाल बिंदु देखकर सही वाक्य चुनें:',
    'Spot the red dot on the timeline and choose the matching sentence:',
    NULL, NULL,
    'लाल बिंदु `YESTERDAY` (बीते कल) पर है — Simple Past (`V2`) चुनें!',
    'The red dot sits on `YESTERDAY` — pick Simple Past (`V2`)!',
    'बीते हुए कल (`yesterday`) के लिए Simple Past `V2` लगता है: **"Ravi went to Gaya yesterday."**',
    '`yesterday` strictly calls for Simple Past `V2`: **"Ravi went to Gaya yesterday."**',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "समय-रेखा जाँच: कल की घटना (Yesterday)",
  "scene_title_en": "Timeline Check: Yesterday Event",
  "prompt_hi": "नीचे समय-रेखा पर हाइलाइट किया गया समय देखें और सही वाक्य चुनें:",
  "prompt_en": "Check the highlighted point on the timeline and pick the right sentence:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "घटना कब हुई?",
    "title_en": "When Did the Action Happen?",
    "caption_hi": "हाइलाइट किया गया समय = बीता हुआ कल (Past)",
    "caption_en": "Highlighted point = Yesterday (Past)",
    "viewBox": "0 0 580 120",
    "elements": [
      {
        "kind": "arrow",
        "x1": 40,
        "y1": 66,
        "x2": 540,
        "y2": 66,
        "stroke": "#334155",
        "strokeWidth": 2.5
      },
      {
        "kind": "circle",
        "cx": 130,
        "cy": 66,
        "r": 16,
        "fill": "#FEF3C7",
        "stroke": "#DC2626",
        "strokeWidth": 3
      },
      {
        "kind": "circle",
        "cx": 130,
        "cy": 66,
        "r": 6,
        "fill": "#DC2626"
      },
      {
        "kind": "circle",
        "cx": 290,
        "cy": 66,
        "r": 7,
        "fill": "#94A3B8"
      },
      {
        "kind": "circle",
        "cx": 450,
        "cy": 66,
        "r": 7,
        "fill": "#94A3B8"
      },
      {
        "kind": "label",
        "x": 130,
        "y": 34,
        "text_hi": "कल (YESTERDAY)",
        "text_en": "YESTERDAY",
        "fill": "#DC2626",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 290,
        "y": 34,
        "text_hi": "आज (NOW)",
        "text_en": "NOW",
        "fill": "#64748B",
        "fontSize": 12,
        "anchor": "middle",
        "bold": false
      },
      {
        "kind": "label",
        "x": 450,
        "y": 34,
        "text_hi": "आने वाला कल",
        "text_en": "TOMORROW",
        "fill": "#64748B",
        "fontSize": 12,
        "anchor": "middle",
        "bold": false
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "MessageSquare",
      "label_hi": "Ravi goes to Gaya yesterday.",
      "label_en": "Ravi goes to Gaya yesterday."
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "Ravi will go to Gaya yesterday.",
      "label_en": "Ravi will go to Gaya yesterday."
    },
    {
      "id": "c3",
      "icon": "MessageSquare",
      "label_hi": "Ravi went to Gaya yesterday.",
      "label_en": "Ravi went to Gaya yesterday."
    },
    {
      "id": "c4",
      "icon": "MessageSquare",
      "label_hi": "Ravi is going to Gaya yesterday.",
      "label_en": "Ravi is going to Gaya yesterday."
    }
  ],
  "correct_choice_id": "c3"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (BOARD, PRACTICE) — Since vs For Visual
  (
    '10000006-0002-4000-8000-000000000007', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Since vs For Visual', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'BSEB 2023',
    'घड़ी के चित्र को देखकर `since` या `for` वाला सही वाक्य चुनें:',
    'Read the clock visual and pick the right `since` / `for` sentence:',
    NULL, NULL,
    'चित्र में कुल गिनती **"2 HOURS"** दिखाई गई है — कुल अवधि के लिए `for` और `has been studying` चुनें!',
    'The clock shows a counted duration of **"2 HOURS"** — use `for` + `has been studying`!',
    '**"Anjali has been studying for two hours."** — कुल अवधि (2 घंटे) के लिए `for` और जारी कार्य के लिए `has been + V-ing` लगता है।',
    '**"Anjali has been studying for two hours."** — Total duration takes `for` with Present Perfect Continuous.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "घड़ी का समय: 2 घंटे की कुल अवधि",
  "scene_title_en": "Clock Check: 2 Hours Total Duration",
  "prompt_hi": "अंजलि पिछले 2 घंटे से लगातार पढ़ रही है। सही वाक्य चुनें:",
  "prompt_en": "Anjali started 2 hours ago and is STILL studying right now. Pick the right sentence:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "2 घंटे से पढ़ाई जारी है",
    "title_en": "Studying Continuously for 2 Hours",
    "caption_hi": "शुरू: 6 PM → अभी: 8 PM (कुल गिनती = 2 घंटे)",
    "caption_en": "Start: 6 PM → Now: 8 PM (Total Count = 2 Hours)",
    "viewBox": "0 0 580 125",
    "elements": [
      {
        "kind": "rect",
        "x": 70,
        "y": 42,
        "width": 440,
        "height": 34,
        "rx": 17,
        "fill": "#EFF6FF",
        "stroke": "#1E3A8A",
        "strokeWidth": 2
      },
      {
        "kind": "arrow",
        "x1": 95,
        "y1": 59,
        "x2": 485,
        "y2": 59,
        "stroke": "#059669",
        "strokeWidth": 3
      },
      {
        "kind": "label",
        "x": 70,
        "y": 30,
        "text_hi": "6:00 PM",
        "text_en": "6:00 PM",
        "fill": "#475569",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 510,
        "y": 30,
        "text_hi": "8:00 PM (NOW)",
        "text_en": "8:00 PM (NOW)",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 290,
        "y": 102,
        "text_hi": "कुल अवधि = 2 घंटे (2 hours)",
        "text_en": "Total Duration = 2 hours",
        "fill": "#059669",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "PenTool",
      "label_hi": "Anjali has been studying for two hours.",
      "label_en": "Anjali has been studying for two hours."
    },
    {
      "id": "c2",
      "icon": "PenTool",
      "label_hi": "Anjali has been studying since two hours.",
      "label_en": "Anjali has been studying since two hours."
    },
    {
      "id": "c3",
      "icon": "PenTool",
      "label_hi": "Anjali is studying for two hours.",
      "label_en": "Anjali is studying for two hours."
    },
    {
      "id": "c4",
      "icon": "PenTool",
      "label_hi": "Anjali studied for two hours now.",
      "label_en": "Anjali studied for two hours now."
    }
  ],
  "correct_choice_id": "c1"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (TOPPER, PRACTICE) — Stative Verb Fix
  (
    '10000006-0002-4000-8000-000000000008', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Stative Verb Fix', 'PRACTICE', 'SCENARIO_LAB', 'TOPPER', 'BSEB 2024',
    'बिहार बोर्ड के सबसे बड़े Stative Verb ट्रैप को पहचानें:',
    'Beat the classic Stative Verb trap in this scene:',
    NULL, NULL,
    '`know` (जानना) में कभी `-ing` नहीं लगता!',
    '`know` is a stative verb — NEVER add `-ing`!',
    '**"I know the answer."** सही है। `"I am knowing"` और `"I knowing"` दोनों अशुद्ध हैं।',
    '**"I know the answer."** is clean standard English; `know` does not take progressive `-ing`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "कक्षा में उत्तर जानते समय क्या बोलें?",
  "scene_title_en": "Raising Your Hand in Class",
  "prompt_hi": "आप शिक्षक से कहना चाहते हैं — \"सर, मैं इसका उत्तर जानता हूँ।\" कौन-सा वाक्य 100% सही है?",
  "prompt_en": "You want to tell your teacher you know the answer. Which English sentence is 100% right?",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "Stative Verb जाँच: know",
    "title_en": "Stative Verb Check: know",
    "caption_hi": "मानसिक अवस्था बताने वाली क्रियाएँ Simple Present लेती हैं",
    "caption_en": "Mental-state verbs stay in Simple Present",
    "viewBox": "0 0 540 115",
    "elements": [
      {
        "kind": "rect",
        "x": 30,
        "y": 20,
        "width": 220,
        "height": 70,
        "rx": 10,
        "fill": "#FEF2F2",
        "stroke": "#DC2626",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 140,
        "y": 50,
        "text_hi": "am knowing (गलत!)",
        "text_en": "am knowing (WRONG!)",
        "fill": "#DC2626",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "arrow",
        "x1": 256,
        "y1": 55,
        "x2": 288,
        "y2": 55,
        "stroke": "#059669",
        "strokeWidth": 2.5
      },
      {
        "kind": "rect",
        "x": 294,
        "y": 20,
        "width": 216,
        "height": 70,
        "rx": 10,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 402,
        "y": 50,
        "text_hi": "Simple Present चुनें!",
        "text_en": "Choose Simple Present!",
        "fill": "#059669",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "MessageSquare",
      "label_hi": "Sir, I am knowing the answer.",
      "label_en": "Sir, I am knowing the answer."
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "Sir, I know the answer.",
      "label_en": "Sir, I know the answer."
    },
    {
      "id": "c3",
      "icon": "MessageSquare",
      "label_hi": "Sir, I knows the answer.",
      "label_en": "Sir, I knows the answer."
    },
    {
      "id": "c4",
      "icon": "MessageSquare",
      "label_hi": "Sir, I knowing the answer.",
      "label_en": "Sir, I knowing the answer."
    }
  ],
  "correct_choice_id": "c2"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (FOUNDATION, PRACTICE) — Did + V1 Rule
  (
    '10000006-0002-4000-8000-000000000009', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Did + V1 Rule', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    '`did` या `does` आने पर मुख्य क्रिया किस रूप में बदल जाती है?',
    'What verb form ALWAYS follows `did` or `does`?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Did और Does के बाद मुख्य क्रिया का कौन-सा रूप लगता है?",
  "front_en": "Which verb form ALWAYS follows `did` or `does`?",
  "back_hi": "हमेशा शुद्ध V1 (Base Form)! उदाहरण: Does he play? (plays नहीं!), Did he go? (went नहीं!)।",
  "back_en": "ALWAYS pure V1 (Base Form)! Example: Does he play? (not plays!), Did he go? (not went!).",
  "mnemonic_hi": "ट्रिक: \"Do / Does / Did जहाँ आए, वहाँ V1 ही मुस्कुराए!\"",
  "mnemonic_en": "Memory hook: \"After Do, Does, Did — always keep base V1!\"",
  "pronunciation_hi": "डिड ही गो? · डज़ ही प्ले?"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (BOARD, PRACTICE) — Since vs For
  (
    '10000006-0002-4000-8000-000000000010', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Since vs For', 'PRACTICE', 'FLASHCARD', 'BOARD', 'BSEB 2023',
    '`since` और `for` के बीच 2-सेकंड का अंतर क्या है?',
    'What is the 2-second difference between `since` and `for`?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Since कब लगाएँ और For कब लगाएँ?",
  "front_en": "When do we use `since` vs `for`?",
  "back_hi": "Since = शुरुआती बिंदु (since morning, since Monday, since 2020)। For = कुल गिनती/अवधि (for 2 hours, for 5 days, for 3 years)।",
  "back_en": "Since = exact starting point (since morning, since Monday, since 2020). For = counted duration (for 2 hours, for 5 days, for 3 years).",
  "mnemonic_hi": "ट्रिक: \"नाम/सन् → Since, गिनती (1, 2, 3...) → For!\"",
  "mnemonic_en": "Trick: \"Start Point/Name → Since; Number Count → For!\"",
  "pronunciation_hi": "सिंस (since) · फ़ॉर (for)"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (BOARD, PRACTICE) — Past Perfect Rule
  (
    '10000006-0002-4000-8000-000000000011', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Past Perfect Rule', 'PRACTICE', 'FLASHCARD', 'BOARD', 'BSEB 2022',
    'भूतकाल की दो घटनाओं में `had + V3` और `V2` कहाँ लगते हैं?',
    'In two past actions, where do `had + V3` and `V2` go?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "भूतकाल में 2 काम एक के बाद एक हों तो कौन-सा टेंस कहाँ लगेगा?",
  "front_en": "When 2 actions happen in the past, which gets `had + V3` and which gets `V2`?",
  "back_hi": "पहला पूरा काम = Past Perfect (had + V3)। दूसरा बाद वाला काम = Simple Past (V2)। जैसे: The train had left before I reached.",
  "back_en": "1st (earlier) action = Past Perfect (`had + V3`). 2nd (later) action = Simple Past (`V2`). Example: The train had left before I reached.",
  "mnemonic_hi": "ट्रिक: \"पहले पूरा = had + V3, बाद में आया = V2!\"",
  "mnemonic_en": "Trick: \"First finished = had + V3; Second arrived = V2!\"",
  "pronunciation_hi": "द ट्रेन हैड लेफ़्ट बिफ़ोर आई रीच्ड",
  "formula_latex": "\\text{had} + V_3 + \\text{before} + V_2"
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (FOUNDATION, PRACTICE) — Signal Words to Tense
  (
    '10000006-0002-4000-8000-000000000012', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Signal Words to Tense', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2024',
    'प्रत्येक समय-संकेत शब्द को उसके सही Tense से मिलाएँ:',
    'Match each time signal word with its exact Tense:',
    NULL, NULL,
    'सोचें कौन-सा शब्द रोज़ की आदत, अभी का काम, बीता कल या आने वाला कल दिखाता है!',
    'Link each cue to Habit, Happening Now, Yesterday, or Tomorrow!',
    'daily → Simple Present, now → Present Continuous, yesterday → Simple Past, tomorrow → Simple Future।',
    'daily → Simple Present, now → Present Continuous, yesterday → Simple Past, tomorrow → Simple Future.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "संकेत शब्द को सही काल (Tense) से मिलाएँ",
  "instruction_en": "Match each signal word to the correct tense",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "daily / every morning",
      "left_en": "daily / every morning",
      "right_hi": "Simple Present (V1 / V1+s/es)",
      "right_en": "Simple Present (V1 / V1+s/es)"
    },
    {
      "id": "p2",
      "left_hi": "Look! / now",
      "left_en": "Look! / now",
      "right_hi": "Present Continuous (is/am/are + V-ing)",
      "right_en": "Present Continuous (is/am/are + V-ing)"
    },
    {
      "id": "p3",
      "left_hi": "yesterday / ago",
      "left_en": "yesterday / ago",
      "right_hi": "Simple Past (V2)",
      "right_en": "Simple Past (V2)"
    },
    {
      "id": "p4",
      "left_hi": "tomorrow / next week",
      "left_en": "tomorrow / next week",
      "right_hi": "Simple Future (will + V1)",
      "right_en": "Simple Future (will + V1)"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (BOARD, PRACTICE) — Tense to Helping Verb
  (
    '10000006-0002-4000-8000-000000000013', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Tense to Helping Verb', 'PRACTICE', 'MATCH_PAIRS', 'BOARD', NULL,
    'प्रत्येक काल (Tense) को उसके सही सहायक क्रिया सूत्र से मिलाएँ:',
    'Match each Tense name with its exact helping-verb formula:',
    NULL, NULL,
    'Continuous में हमेशा `-ing` और Perfect में हमेशा `V3` होता है!',
    'Continuous always has `-ing`, and Perfect always has `V3`!',
    'हर काल की अपनी अद्वितीय सहायक क्रिया पहचान होती है।',
    'Each tense carries a unique helping-verb signature.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "काल को उसके सूत्र से मिलाएँ",
  "instruction_en": "Match each tense to its verb formula",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "Present Perfect",
      "left_en": "Present Perfect",
      "right_hi": "has / have + V3",
      "right_en": "has / have + V3"
    },
    {
      "id": "p2",
      "left_hi": "Past Continuous",
      "left_en": "Past Continuous",
      "right_hi": "was / were + V1-ing",
      "right_en": "was / were + V1-ing"
    },
    {
      "id": "p3",
      "left_hi": "Past Perfect",
      "left_en": "Past Perfect",
      "right_hi": "had + V3",
      "right_en": "had + V3"
    },
    {
      "id": "p4",
      "left_hi": "Present Perfect Continuous",
      "left_en": "Present Perfect Continuous",
      "right_hi": "has/have been + V1-ing",
      "right_en": "has/have been + V1-ing"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Universal Truth Simple Present
  (
    '10000006-0002-4000-8000-000000000014', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Universal Truth Simple Present', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2022',
    'सही विकल्प चुनें: The sun ___ in the east.',
    'Choose the correct verb form: The sun ___ in the east.',
    $json$[{"key":"A","text_hi":"rise","text_en":"rise"},{"key":"B","text_hi":"rises","text_en":"rises"},{"key":"C","text_hi":"rose","text_en":"rose"},{"key":"D","text_hi":"rising","text_en":"rising"}]$json$::jsonb, 'B',
    'यह सार्वभौमिक सत्य है और `The sun` एकवचन है!',
    'Universal truth + singular subject `The sun`!',
    'सार्वभौमिक सत्य हमेशा Simple Present में होता है और `The sun` एकवचन होने से **`rises`** लगेगा।',
    'Universal truths always use Simple Present; singular `The sun` takes **`rises`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Simple Past yesterday
  (
    '10000006-0002-4000-8000-000000000015', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Simple Past yesterday', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'सही विकल्प चुनें: He ___ to Patna yesterday.',
    'Choose the correct option: He ___ to Patna yesterday.',
    $json$[{"key":"A","text_hi":"go","text_en":"go"},{"key":"B","text_hi":"goes","text_en":"goes"},{"key":"C","text_hi":"gone","text_en":"gone"},{"key":"D","text_hi":"went","text_en":"went"}]$json$::jsonb, 'D',
    'वाक्य में `yesterday` (बीता कल) दिया गया है — V2 चुनें!',
    '`yesterday` signals Simple Past — choose V2!',
    '`yesterday` होने से Simple Past (`V2`) लगेगा, और `go` का V2 **`went`** है।',
    '`yesterday` requires Simple Past (`V2`), which is **`went`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Present Continuous Look!
  (
    '10000006-0002-4000-8000-000000000016', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Present Continuous Look!', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'सही विकल्प चुनें: Look! It ___ outside.',
    'Choose the correct option: Look! It ___ outside.',
    $json$[{"key":"A","text_hi":"is raining","text_en":"is raining"},{"key":"B","text_hi":"rains","text_en":"rains"},{"key":"C","text_hi":"rain","text_en":"rain"},{"key":"D","text_hi":"rained","text_en":"rained"}]$json$::jsonb, 'A',
    '`Look!` बताता है कि काम अभी आँखों के सामने हो रहा है!',
    '`Look!` shows the action is happening right now!',
    '`Look!` के कारण Present Continuous लगेगा: **"Look! It is raining outside."**',
    '`Look!` cues Present Continuous: **"Look! It is raining outside."**',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Did + V1 Trap
  (
    '10000006-0002-4000-8000-000000000017', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Did + V1 Trap', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'सही विकल्प चुनें: Did you ___ him at the station?',
    'Choose the correct option: Did you ___ him at the station?',
    $json$[{"key":"A","text_hi":"saw","text_en":"saw"},{"key":"B","text_hi":"seen","text_en":"seen"},{"key":"C","text_hi":"see","text_en":"see"},{"key":"D","text_hi":"seeing","text_en":"seeing"}]$json$::jsonb, 'C',
    'याद रखें: `Did` के बाद हमेशा शुद्ध **V1** लगता है!',
    'Remember: ALWAYS use base **V1** after `Did`!',
    '`Did` के साथ हमेशा V1 (`see`) लगता है, `saw` या `seen` कभी नहीं।',
    'Base form **`see`** (V1) always follows `Did`, never `saw` or `seen`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Present Perfect Continuous
  (
    '10000006-0002-4000-8000-000000000018', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Present Perfect Continuous', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'सही विकल्प चुनें: She ___ in Muzaffarpur since 2019.',
    'Choose the correct option: She ___ in Muzaffarpur since 2019.',
    $json$[{"key":"A","text_hi":"has been living","text_en":"has been living"},{"key":"B","text_hi":"lives","text_en":"lives"},{"key":"C","text_hi":"is living","text_en":"is living"},{"key":"D","text_hi":"have been living","text_en":"have been living"}]$json$::jsonb, 'A',
    '`since 2019` है और कर्ता `She` (एकवचन) है!',
    '`since 2019` + singular subject `She`!',
    '`since 2019` के लिए Present Perfect Continuous और `She` एकवचन होने से **`has been living`** सही है।',
    '`since 2019` requires Present Perfect Continuous, and singular `She` takes **`has been living`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Present Perfect just
  (
    '10000006-0002-4000-8000-000000000019', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Present Perfect just', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'सही विकल्प चुनें: The train has just ___.',
    'Choose the correct option: The train has just ___.',
    $json$[{"key":"A","text_hi":"leave","text_en":"leave"},{"key":"B","text_hi":"leaves","text_en":"leaves"},{"key":"C","text_hi":"leaving","text_en":"leaving"},{"key":"D","text_hi":"left","text_en":"left"}]$json$::jsonb, 'D',
    '`has / have` के बाद मुख्य क्रिया का **V3** रूप लगता है!',
    'After `has / have`, always choose **V3** (Past Participle)!',
    '`leave` का V3 रूप **`left`** है: *"The train has just left."*।',
    'The V3 form of `leave` is **`left`**: *"The train has just left."*',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Since vs For MCQ
  (
    '10000006-0002-4000-8000-000000000020', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Since vs For MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Model Paper',
    'सही शब्द भरें: I have been waiting for you ___ three hours.',
    'Fill in the blank: I have been waiting for you ___ three hours.',
    $json$[{"key":"A","text_hi":"since","text_en":"since"},{"key":"B","text_hi":"for","text_en":"for"},{"key":"C","text_hi":"from","text_en":"from"},{"key":"D","text_hi":"at","text_en":"at"}]$json$::jsonb, 'B',
    '`three hours` एक कुल गिनती (अवधि) है, शुरुआती बिंदु नहीं!',
    '`three hours` is a counted duration, not a starting point!',
    'कुल समय की गिनती (`three hours`) के साथ हमेशा **`for`** लगता है।',
    'Counted length of time (`three hours`) always takes **`for`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Past Perfect Two Events
  (
    '10000006-0002-4000-8000-000000000021', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Past Perfect Two Events', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'सही विकल्प चुनें: The bell ___ before I reached the school.',
    'Choose the correct option: The bell ___ before I reached the school.',
    $json$[{"key":"A","text_hi":"rang","text_en":"rang"},{"key":"B","text_hi":"has rung","text_en":"has rung"},{"key":"C","text_hi":"had rung","text_en":"had rung"},{"key":"D","text_hi":"was ringing","text_en":"was ringing"}]$json$::jsonb, 'C',
    'घंटी मेरे पहुँचने (`reached` = V2) से **पहले** बज चुकी थी — पहला काम `had + V3`!',
    'The bell rang BEFORE I reached (`V2`) — earlier past action = `had + V3`!',
    'दो भूतकालीन घटनाओं में पहले पूर्ण हुई घटना के लिए **`had rung`** (`had + V3`) लगता है।',
    'For the earlier of two past events, use Past Perfect **`had rung`** (`had + V3`).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — First Conditional
  (
    '10000006-0002-4000-8000-000000000022', 'skill-eng-foundation', 'skill-eng-f-ch2', 'First Conditional', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    'सही विकल्प चुनें: If he ___ hard, he will pass the board exam.',
    'Choose the correct option: If he ___ hard, he will pass the board exam.',
    $json$[{"key":"A","text_hi":"works","text_en":"works"},{"key":"B","text_hi":"work","text_en":"work"},{"key":"C","text_hi":"will work","text_en":"will work"},{"key":"D","text_hi":"worked","text_en":"worked"}]$json$::jsonb, 'A',
    '`If` वाले भाग में कभी `will` नहीं लगता — Simple Present (`V1+s`) चुनें!',
    'NEVER use `will` inside the `If` clause — use Simple Present (`V1+s`)!',
    'Conditional सूत्र: `If + Simple Present`, `will + V1`। कर्ता `he` एकवचन होने से **`works`** सही है।',
    'First Conditional: `If + Simple Present`, `will + V1`. Singular `he` takes **`works`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, EXAM_ONLY) — Simple Present Negative
  (
    '10000006-0002-4000-8000-000000000023', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Simple Present Negative', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'BSEB Model',
    'सही विकल्प चुनें: She does not ___ tea.',
    'Choose the correct option: She does not ___ tea.',
    $json$[{"key":"A","text_hi":"drinks","text_en":"drinks"},{"key":"B","text_hi":"drank","text_en":"drank"},{"key":"C","text_hi":"drinking","text_en":"drinking"},{"key":"D","text_hi":"drink","text_en":"drink"}]$json$::jsonb, 'D',
    '`does not` के बाद मुख्य क्रिया हमेशा शुद्ध V1 रहती है।',
    'Base V1 always follows `does not`.',
    '`does` पहले ही `-es` ले चुका है, इसलिए मुख्य क्रिया **`drink`** (V1) होगी।',
    '`does` already carries singular agreement, so the main verb stays **`drink`** (V1).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, EXAM_ONLY) — Interrupted Past Action
  (
    '10000006-0002-4000-8000-000000000024', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Interrupted Past Action', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'सही विकल्प चुनें: I ___ a book when the phone rang.',
    'Choose the correct option: I ___ a book when the phone rang.',
    $json$[{"key":"A","text_hi":"am reading","text_en":"am reading"},{"key":"B","text_hi":"was reading","text_en":"was reading"},{"key":"C","text_hi":"read","text_en":"read"},{"key":"D","text_hi":"have read","text_en":"have read"}]$json$::jsonb, 'B',
    'जब फ़ोन बजा (`rang` = भूतकाल), तब पढ़ने का काम चल रहा था!',
    'When the phone rang (past), the reading action was in progress!',
    'भूतकाल में जारी पृष्ठभूमि कार्य के लिए Past Continuous (**`was reading`**) लगता है।',
    'An ongoing past action interrupted by a short event (`rang`) uses Past Continuous **`was reading`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, EXAM_ONLY) — Stative Verb Exam Check
  (
    '10000006-0002-4000-8000-000000000025', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Stative Verb Exam Check', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2023',
    'सही वाक्य चुनें:',
    'Choose the grammatically correct sentence:',
    $json$[{"key":"A","text_hi":"She is believing in God.","text_en":"She is believing in God."},{"key":"B","text_hi":"She believe in God.","text_en":"She believe in God."},{"key":"C","text_hi":"She believes in God.","text_en":"She believes in God."},{"key":"D","text_hi":"She was believing in God daily.","text_en":"She was believing in God daily."}]$json$::jsonb, 'C',
    '`believe` (विश्वास करना) एक Stative Verb है और `She` एकवचन है!',
    '`believe` is a Stative Verb and `She` is singular!',
    '`believe` में `-ing` नहीं लगता और `She` के साथ `-s` जुड़ता है → **"She believes in God."**',
    'Stative `believe` stays in Simple Present with `-s` for `She` → **"She believes in God."**',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- SHORT_2M (BOARD, PRACTICE) — Since vs For Distinction
  (
    '10000006-0002-4000-8000-000000000026', 'skill-eng-foundation', 'skill-eng-f-ch2', 'Since vs For Distinction', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    '`since` और `for` के प्रयोग में अंतर स्पष्ट करें तथा प्रत्येक का एक-एक उदाहरण लिखें।',
    'Explain the difference between `since` and `for` with one clear example each.',
    NULL, NULL,
    '1 अंक सही नियम (शुरुआती बिंदु बनाम कुल अवधि) + 1 अंक दोनों के शुद्ध उदाहरण।',
    '1 mark for the exact rule (starting point vs total duration) + 1 mark for one example each.',
    NULL,
    NULL,
    '1. **`since` (निश्चित शुरुआती बिंदु — Point of Time):** जब काम शुरू होने का ठीक समय, दिन, महीना या वर्ष दिया हो (`morning, Monday, 2020`)।
   - उदाहरण: *It has been raining **since** morning.*
2. **`for` (कुल समय अवधि — Period of Time):** जब समय की कुल गिनती दी हो (`2 hours, 5 days, 3 years`)।
   - उदाहरण: *She has been reading **for** two hours.*',
    '1. **`since` (Point of Time):** Used when the exact starting point of an action is given (`morning, Monday, 2020`).
   - Example: *It has been raining **since** morning.*
2. **`for` (Period of Time):** Used when the total duration/length of time is counted (`2 hours, 5 days, 3 years`).
   - Example: *She has been reading **for** two hours.*',
    $json$[{"cue_hi":"Since = Point of time (morning, Monday, 2020)","cue_en":"Since = Point of time (morning, Monday, 2020)"},{"cue_hi":"For = Period of time (2 hours, 5 days)","cue_en":"For = Period of time (2 hours, 5 days)"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"since (Point of time) और उदाहरण का सही लेखन","criterion_en":"Correct rule + example for `since`"},{"step_no":2,"marks":1,"criterion_hi":"for (Period of time) और उदाहरण का सही लेखन","criterion_en":"Correct rule + example for `for`"}]$json$::jsonb,
    NULL,
    true
  ),
  -- LONG_5M (TOPPER, PRACTICE) — BSEB 5M Error Correction
  (
    '10000006-0002-4000-8000-000000000027', 'skill-eng-foundation', 'skill-eng-f-ch2', 'BSEB 5M Error Correction', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    'नीचे दिए गए 5 अशुद्ध वाक्यों की Tense संबंधी गलती पहचानकर उन्हें शुद्ध रूप में लिखें तथा प्रत्येक का कारण बताएँ (5 अंक):
1. He go to school every day.
2. Did you went to the market?
3. I am knowing your brother.
4. She is living in Patna since 2018.
5. If it will rain, we will stay inside.',
    'Correct the tense errors in the following 5 sentences and briefly state the rule for each (5 marks):
1. He go to school every day.
2. Did you went to the market?
3. I am knowing your brother.
4. She is living in Patna since 2018.
5. If it will rain, we will stay inside.',
    NULL, NULL,
    'यह सभी 5 बिहार बोर्ड के सबसे प्रसिद्ध Tense ट्रैप हैं — हर वाक्य में ठीक 1 सुधार करें!',
    'These are the top 5 BSEB tense traps — apply the exact fix to each!',
    NULL,
    NULL,
    '1. **He goes to school every day.** *(नियम: Simple Present में He/She/It के साथ V1 में s/es लगता है।)*
2. **Did you go to the market?** *(नियम: Did के बाद हमेशा मूल क्रिया V1 आती है।)*
3. **I know your brother.** *(नियम: know एक Stative Verb है, इसमें -ing नहीं लगता।)*
4. **She has been living in Patna since 2018.** *(नियम: since/for के साथ जारी काम में Present Perfect Continuous लगता है।)*
5. **If it rains, we will stay inside.** *(नियम: If वाले भाग में will नहीं, बल्कि Simple Present लगता है।)*',
    '1. **He goes to school every day.** *(Rule: 3rd-person singular takes V1+s/es in Simple Present.)*
2. **Did you go to the market?** *(Rule: Base V1 always follows `Did`.)*
3. **I know your brother.** *(Rule: Stative verb `know` does not take `-ing`.)*
4. **She has been living in Patna since 2018.** *(Rule: Duration with `since` requires Present Perfect Continuous.)*
5. **If it rains, we will stay inside.** *(Rule: Use Simple Present, never `will`, inside the `If` clause.)*',
    $json$[{"cue_hi":"He/She/It → goes","cue_en":"He/She/It → goes"},{"cue_hi":"Did → V1 (go)","cue_en":"Did → V1 (go)"},{"cue_hi":"know → no -ing","cue_en":"know → no -ing"},{"cue_hi":"since/for → has/have been + V-ing","cue_en":"since/for → has/have been + V-ing"},{"cue_hi":"If + Simple Present, will + V1","cue_en":"If + Simple Present, will + V1"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"वाक्य 1 का शुद्ध रूप (goes)","criterion_en":"Sentence 1 corrected to `goes`"},{"step_no":2,"marks":1,"criterion_hi":"वाक्य 2 का शुद्ध रूप (Did you go)","criterion_en":"Sentence 2 corrected to `Did you go`"},{"step_no":3,"marks":1,"criterion_hi":"वाक्य 3 का शुद्ध रूप (I know)","criterion_en":"Sentence 3 corrected to `I know`"},{"step_no":4,"marks":1,"criterion_hi":"वाक्य 4 का शुद्ध रूप (has been living)","criterion_en":"Sentence 4 corrected to `has been living`"},{"step_no":5,"marks":1,"criterion_hi":"वाक्य 5 का शुद्ध रूप (If it rains)","criterion_en":"Sentence 5 corrected to `If it rains`"}]$json$::jsonb,
    NULL,
    true
  )
ON CONFLICT (id) DO UPDATE SET
  subject_id          = EXCLUDED.subject_id,
  chapter_id          = EXCLUDED.chapter_id,
  topic_tag           = EXCLUDED.topic_tag,
  bank_pool           = EXCLUDED.bank_pool,
  question_type       = EXCLUDED.question_type,
  difficulty_tier     = EXCLUDED.difficulty_tier,
  exam_year_tag       = EXCLUDED.exam_year_tag,
  q_hi                = EXCLUDED.q_hi,
  q_en                = EXCLUDED.q_en,
  options_json        = EXCLUDED.options_json,
  correct_option      = EXCLUDED.correct_option,
  clue_hi             = EXCLUDED.clue_hi,
  clue_en             = EXCLUDED.clue_en,
  explanation_hi      = EXCLUDED.explanation_hi,
  explanation_en      = EXCLUDED.explanation_en,
  model_answer_hi     = EXCLUDED.model_answer_hi,
  model_answer_en     = EXCLUDED.model_answer_en,
  memory_cues_json    = EXCLUDED.memory_cues_json,
  marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json   = EXCLUDED.visual_asset_json,
  is_published        = EXCLUDED.is_published;

-- #############################################################################
-- UNIT 3 OF 5: skill-eng-f-ch3 — ARTICLES (A, AN, THE) & PREPOSITIONS VISUAL PICTURE MAP
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-eng-f-ch3',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: आर्टिकल्स व प्रीपोज़िशन (चित्र विधि)",
  "title_en": "30-Second Mindmap: Articles & Prepositions Picture Map",
  "read_time_seconds": 30,
  "central_node": {
    "id": "u3-root",
    "label_hi": "Articles (a, an, the) + Prepositions",
    "label_en": "Articles (a, an, the) + Prepositions",
    "subtitle_hi": "आवाज़ से a/an चुनें · चित्र से Preposition पहचानें!",
    "subtitle_en": "Pick a/an by Sound · Pick Prepositions by Picture!"
  },
  "branches": [
    {
      "id": "u3-b1",
      "label_hi": "1. a बनाम an — हिंदी आवाज़ नियम (अ–अः)",
      "label_en": "1. a vs an — Hindi Sound Rule (अ–अः)",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "u3-b1-c1",
          "label_hi": "अ–अः की आवाज़ → an (an hour, an honest man, an MLA)",
          "label_en": "Vowel sound → an (an hour, an honest man, an MLA)"
        },
        {
          "id": "u3-b1-c2",
          "label_hi": "क–ज्ञ की आवाज़ → a (a university, a one-rupee note)",
          "label_en": "Consonant sound → a (a university, a one-rupee note)"
        }
      ]
    },
    {
      "id": "u3-b2",
      "label_hi": "2. The बनाम Zero Article (×)",
      "label_en": "2. Definite \"the\" vs Zero Article",
      "color": "#059669",
      "children": [
        {
          "id": "u3-b2-c1",
          "label_hi": "The = नदियाँ (the Ganga), ग्रंथ (the Gita), Superlative (the best)",
          "label_en": "The = Rivers, Holy books, Superlatives, Unique things (the sun)"
        },
        {
          "id": "u3-b2-c2",
          "label_hi": "कोई Article नहीं: शहर (Patna), भाषा (Hindi), खेल (cricket)",
          "label_en": "Zero Article: Cities (Patna), Languages (Hindi), Sports (cricket)"
        }
      ]
    },
    {
      "id": "u3-b3",
      "label_hi": "3. स्थान के Prepositions (गेंद और मेज़ चित्र)",
      "label_en": "3. Place Prepositions (Ball & Table Map)",
      "color": "#D97706",
      "children": [
        {
          "id": "u3-b3-c1",
          "label_hi": "on (ऊपर सटा), under (नीचे), in (अंदर स्थिर), into (गति से अंदर)",
          "label_en": "on (touching top), under (below), in (static inside), into (moving in)"
        },
        {
          "id": "u3-b3-c2",
          "label_hi": "between (2 के बीच) बनाम among (2 से अधिक के बीच)",
          "label_en": "between (2 items) vs among (3+ items)"
        }
      ]
    },
    {
      "id": "u3-b4",
      "label_hi": "4. समय त्रिकोण (IN → ON → AT) व Fixed Prepositions",
      "label_en": "4. Time Triangle (IN → ON → AT) & Fixed Pairs",
      "color": "#7C3AED",
      "children": [
        {
          "id": "u3-b4-c1",
          "label_hi": "AT 7 AM · ON Monday · IN July / 2026",
          "label_en": "AT 7 AM · ON Monday · IN July / 2026"
        },
        {
          "id": "u3-b4-c2",
          "label_hi": "fond of · afraid of · good at · died of · senior to",
          "label_en": "fond of · afraid of · good at · died of · senior to"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "u3-sec-1-hindi-sound-articles",
    "order": 1,
    "heading_hi": "1. a या an? स्पेलिंग नहीं, हिंदी की आवाज़ (अ–अः) सुनें!",
    "heading_en": "1. a or an? Trust Your Ears (Hindi अ–अः Sound), Not Spelling!",
    "analogy_hi": "बचपन में हमें सिखाया जाता है कि `a, e, i, o, u` देखकर `an` लगा दो — और यही सबसे बड़ा बोर्ड परीक्षा का जाल है! **अंग्रेज़ी अक्षर मत देखिए, शब्द को मन में हिंदी में बोलकर पहली आवाज़ सुनिए!** यदि पहली आवाज़ हिंदी के **स्वर (अ, आ, इ, ई, उ, ऊ, ए, ऐ, ओ, औ)** से निकले → **`an`** लगाएँ। यदि **व्यंजन (क से ज्ञ)** से निकले → **`a`** लगाएँ! अब देखिए जादू: `hour` को हम **\"आवर\"** बोलते हैं (आ = स्वर → **`an hour`**), और `university` को **\"यूनिवर्सिटी\"** बोलते हैं (य = व्यंजन → **`a university`**)!",
    "analogy_en": "Checking letters `a, e, i, o, u` blindly is the #1 BSEB exam trap! Instead, **say the word aloud and listen to its FIRST Hindi sound!** If it begins with a Hindi vowel sound (**अ, आ, इ, ई, उ, ऊ, ए, ऐ, ओ, औ**) → use **`an`**. If it begins with a consonant sound (**क–ज्ञ**) → use **`a`**. Watch how effortlessly this solves BSEB favourites: `hour` sounds like **\"आवर\"** → **`an hour`**, while `university` sounds like **\"यूनिवर्सिटी\"** (starts with य) → **`a university`**!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "a बनाम an चुनने का हिंदी ध्वनि फ़िल्टर (अ–अः नियम)",
      "title_en": "The Hindi Sound Filter for a vs an (Zero Mistakes!)",
      "caption_hi": "शब्द की पहली आवाज़ सुनें: अ–अः (स्वर ध्वनि) → an की टोकरी में; क–ज्ञ (व्यंजन ध्वनि) → a की टोकरी में!",
      "caption_en": "Listen to the first spoken sound: Vowel sound (अ–अः) → \"an\" basket; Consonant sound (क–ज्ञ) → \"a\" basket!",
      "viewBox": "0 0 680 265",
      "elements": [
        {
          "kind": "rect",
          "x": 205,
          "y": 14,
          "width": 270,
          "height": 50,
          "rx": 10,
          "fill": "#1E3A8A",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 340,
          "y": 36,
          "text_hi": "शब्द को हिंदी में बोलें — पहली आवाज़ सुनें!",
          "text_en": "Say the Word — Hear the 1st Sound!",
          "fill": "#FFFFFF",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 270,
          "y1": 66,
          "x2": 185,
          "y2": 108,
          "stroke": "#059669",
          "strokeWidth": 2.5
        },
        {
          "kind": "arrow",
          "x1": 410,
          "y1": 66,
          "x2": 495,
          "y2": 108,
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "rect",
          "x": 24,
          "y": 112,
          "width": 300,
          "height": 138,
          "rx": 12,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 174,
          "y": 138,
          "text_hi": "स्वर ध्वनि (अ, आ, इ, उ, ए, ऑ) → AN",
          "text_en": "Vowel Sound → Use AN",
          "fill": "#065F46",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 174,
          "y": 170,
          "text_hi": "an hour (आवर) · an honest man (ऑनेस्ट)",
          "text_en": "an hour · an honest man",
          "fill": "#047857",
          "fontSize": 12,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "label",
          "x": 174,
          "y": 198,
          "text_hi": "an MLA (एम) · an SDO (एस) · an FIR (एफ)",
          "text_en": "an MLA · an SDO · an FIR",
          "fill": "#047857",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 174,
          "y": 226,
          "text_hi": "an umbrella (अम्ब्रेला) · an apple (ऐपल)",
          "text_en": "an umbrella · an apple",
          "fill": "#047857",
          "fontSize": 12,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "rect",
          "x": 356,
          "y": 112,
          "width": 300,
          "height": 138,
          "rx": 12,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 506,
          "y": 138,
          "text_hi": "व्यंजन ध्वनि (क, ख ... य, व, ह) → A",
          "text_en": "Consonant Sound → Use A",
          "fill": "#92400E",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 506,
          "y": 170,
          "text_hi": "a university (यूनिवर्सिटी) · a uniform (यूनिफ़ॉर्म)",
          "text_en": "a university · a uniform",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 506,
          "y": 198,
          "text_hi": "a one-rupee note (वन) · a European (यूरोपियन)",
          "text_en": "a one-rupee note · a European",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 506,
          "y": 226,
          "text_hi": "a useful book (यूज़फ़ुल) · a boy (बॉय)",
          "text_en": "a useful book · a boy",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": false
        }
      ]
    },
    "concept_md_hi": "### बिहार बोर्ड के 6 सबसे ज़्यादा पूछे जाने वाले `a / an` शब्द (रटें नहीं, बोलकर जाँचें!)\n1. **an hour** *(ऐन आवर)* — `h` साइलेंट है, पहली आवाज़ **\"आ\"** है।\n2. **an honest man** *(ऐन ऑनेस्ट मैन)* — `h` साइलेंट है, पहली आवाज़ **\"ऑ\"** है।\n3. **an MLA / an MP / an SDO** *(ऐन एम-एल-ए)* — `M` बोलने पर पहली आवाज़ **\"ए\"** निकलती है!\n4. **a university / a union / a useful book** *(अ यूनिवर्सिटी)* — `u` की आवाज़ यहाँ **\"य\"** है!\n5. **a European** *(अ यूरोपियन)* — `Eu` की आवाज़ **\"यू (य)\"** है!\n6. **a one-rupee coin / a one-eyed man** *(अ वन-रुपी कॉइन)* — `one` की आवाज़ **\"व\"** है!",
    "concept_md_en": "### Top 6 Repeated BSEB `a / an` Exam Traps (Test by Ear!)\n1. **an hour** — silent `h`, starts with vowel sound *\"our\"* (आ)।\n2. **an honest man** — silent `h`, starts with vowel sound *\"onest\"* (ऑ)।\n3. **an MLA / an MP / an SDO / an FIR** — starts with vowel sound *\"em / es / ef\"* (ए)!\n4. **a university / a union / a useful book** — starts with consonant *\"yoo\"* sound (य)!\n5. **a European** — starts with consonant *\"yoo\"* sound (य)!\n6. **a one-rupee note / a one-eyed man** — starts with consonant *\"w\"* sound (व)!",
    "exam_tip_hi": "यदि वाक्य में केवल विशेषण (Adjective) हो और पीछे कोई संज्ञा (Noun) न हो, जैसे `\"He is ___ honest.\"` → **कोई Article (×) नहीं लगेगा!** लेकिन `\"He is ___ honest man.\"` में संज्ञा `man` है → **`an`** लगेगा!",
    "exam_tip_en": "Watch this BSEB trick: `\"He is ___ honest.\"` (no noun after adjective) → **No article!** `\"He is ___ honest man.\"` (singular noun `man` present) → **`an`**!",
    "glossary_terms": [
      {
        "term_hi": "आर्टिकल (Article)",
        "term_en": "Article",
        "pronunciation_hi": "आर्टिकल",
        "definition_hi": "संज्ञा (Noun) से पहले लगने वाले तीन शब्द — a, an (अनिश्चित) और the (निश्चित)।",
        "definition_en": "The three words placed before nouns — a, an (indefinite) and the (definite)."
      },
      {
        "term_hi": "स्वर ध्वनि (Vowel Sound)",
        "term_en": "Vowel Sound",
        "pronunciation_hi": "वाउल साउंड",
        "definition_hi": "हिंदी के अ, आ, इ, ई, उ, ऊ, ए, ऐ, ओ, औ जैसी खुली आवाज़ — इससे पहले हमेशा an लगता है।",
        "definition_en": "An open vocal sound (like Hindi अ–अः) — singular nouns starting with it take `an`."
      }
    ],
    "quick_check": {
      "q_hi": "सही Article भरें: \"My uncle is ___ MLA and my sister studies in ___ university.\"",
      "q_en": "Fill in a/an: \"My uncle is ___ MLA and my sister studies in ___ university.\"",
      "answer_hi": "पहला **`an`** (एम-एल-ए → ए) और दूसरा **`a`** (यूनिवर्सिटी → य)!",
      "answer_en": "First **`an`** (MLA → \"em\" vowel sound), second **`a`** (university → \"yoo\" consonant sound)!"
    }
  },
  {
    "id": "u3-sec-2-the-vs-zero",
    "order": 2,
    "heading_hi": "2. \"The\" का सही प्रयोग — और कहाँ कोई Article नहीं लगता (Zero Article)?",
    "heading_en": "2. Mastering \"The\" — And Where Zero Article (×) Is Required!",
    "analogy_hi": "जब आप कहते हैं *\"Give me **a** pen\"* तो कोई भी पेन चलेगा। लेकिन जब आप कहते हैं *\"Give me **the** pen on that table\"* तो आप उसी एक **खास (Specific)** पेन की बात कर रहे हैं! दुनिया में जो चीज़ें **अद्वितीय (एक ही)** हैं — जैसे *the Ganga, the Himalayas, the sun, the Gita* — उनके आगे सम्मान से **`the`** लगाते हैं।",
    "analogy_en": "*\"Give me **a** pen\"* means any pen at all. *\"Give me **the** pen on that desk\"* points to one **specific** pen! Unique landmarks, rivers, holy books, and superlatives proudly wear **`the`** — while everyday languages, cities, and sports take **no article**!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "कहाँ \"The\" लगाएँ बनाम कहाँ कोई Article (×) न लगाएँ",
      "title_en": "Where to Use \"The\" vs Where to Use Zero Article (×)",
      "caption_hi": "बिहार बोर्ड में लगभग हर साल \"the Ganga\", \"the best\", और \"Zero Article before gold/water/Hindi/Patna\" से 1–2 MCQ आते हैं!",
      "caption_en": "BSEB regularly asks MCQs on \"the Ganga\", superlatives (\"the best\"), and Zero Article before cities, languages, and uncountable materials!",
      "headers_hi": [
        "\"The\" ज़रूर लगाएँ",
        "उदाहरण",
        "कोई Article (×) नहीं लगता",
        "सही उदाहरण"
      ],
      "headers_en": [
        "Always Use \"The\"",
        "Examples",
        "Use Zero Article (×)",
        "Correct Examples"
      ],
      "rows": [
        {
          "cells_hi": [
            "नदियाँ, समुद्र, पर्वत श्रेणियाँ",
            "the Ganga, the Himalayas, the Bay of Bengal",
            "व्यक्ति, शहर, राज्य, देश के नाम",
            "Patna, Bihar, India, Ravi (not the India)"
          ],
          "cells_en": [
            "Rivers, Seas, Mountain ranges",
            "the Ganga, the Himalayas",
            "People, Cities, States, Countries",
            "Patna, Bihar, India, Ravi"
          ]
        },
        {
          "cells_hi": [
            "पवित्र ग्रंथ व समाचार पत्र",
            "the Gita, the Ramayana, the Quran, the Bible",
            "भाषाएँ और विषय (Subjects)",
            "Hindi, English, Mathematics (not the English)"
          ],
          "cells_en": [
            "Holy books & Newspapers",
            "the Gita, the Quran, the Bible",
            "Languages & School Subjects",
            "Hindi, English, Mathematics"
          ]
        },
        {
          "cells_hi": [
            "दुनिया की अनोखी वस्तुएँ व दिशाएँ",
            "the sun, the moon, the earth, the east",
            "खेल (Games) और भोजन (Meals)",
            "play cricket, eat breakfast / lunch"
          ],
          "cells_en": [
            "Unique natural objects & Directions",
            "the sun, the moon, the east",
            "Sports & Daily Meals",
            "play cricket, eat breakfast"
          ]
        },
        {
          "cells_hi": [
            "Superlative डिग्री (-est / most)",
            "the best boy, the tallest building, the most useful",
            "सामान्य पदार्थ (Uncountable) व गुण",
            "Gold is precious. Honesty is the best policy."
          ],
          "cells_en": [
            "Superlative degrees (-est / most)",
            "the best boy, the tallest tree",
            "General Materials & Abstract Nouns",
            "Gold is precious. Honesty is the best policy."
          ]
        }
      ]
    },
    "concept_md_hi": "### 3 सुपर-हॉट BSEB \"The\" नियम\n1. **वाद्य यंत्र (Musical Instruments):** `play` के साथ संगीत यंत्र आए तो `the` लगाएँ — **She plays the harmonium / the guitar.**\n2. **कहावतें (Proverbs):** **Honesty is the best policy.** *(ईमानदारी सबसे अच्छी नीति है — `Honesty` से पहले कोई Article नहीं, `best` से पहले `the`!)*\n3. **ख़ास बनाया गया पदार्थ (Specific Material):** सामान्य पानी के लिए × (*Water is essential*), लेकिन किसी खास जगह के पानी के लिए **`the`** (*The water of the Ganga is sacred.*)।",
    "concept_md_en": "### 3 High-Yield BSEB \"The\" Rules\n1. **Musical Instruments:** Always use `the` after `play` — **She plays the harmonium / the tabla.**\n2. **Famous Proverb:** **Honesty is the best policy.** *(No article before `Honesty`, definite `the` before superlative `best`!)*\n3. **General vs Specific Uncountable:** General = no article (*Water is essential*), Specific = `the` (*The water of this well is sweet.*).",
    "exam_tip_hi": "BSEB का पसंदीदा प्रश्न: `\"___ Ganga is ___ sacred river.\"` → नदी के नाम से पहले **`The`**, और `sacred river` (व्यंजन ध्वनि स) से पहले **`a`** → **\"The Ganga is a sacred river.\"**",
    "exam_tip_en": "BSEB Classic: `\"___ Ganga is ___ sacred river.\"` → **`The`** before river name, **`a`** before `sacred river` → **\"The Ganga is a sacred river.\"**",
    "glossary_terms": [
      {
        "term_hi": "निश्चित आर्टिकल (Definite Article)",
        "term_en": "Definite Article",
        "pronunciation_hi": "डेफ़िनिट आर्टिकल",
        "definition_hi": "शब्द \"the\", जो किसी विशेष या अद्वितीय व्यक्ति, स्थान या वस्तु की ओर संकेत करता है।",
        "definition_en": "The word \"the\", pointing to a specific or unique noun known to both speaker and listener."
      },
      {
        "term_hi": "शून्य आर्टिकल (Zero Article)",
        "term_en": "Zero Article",
        "pronunciation_hi": "ज़ीरो आर्टिकल",
        "definition_hi": "ऐसी स्थिति जहाँ a, an या the में से कुछ भी नहीं लगाया जाता (जैसे Patna, Hindi, cricket, gold)।",
        "definition_en": "Cases where no article (a/an/the) is used, e.g., before cities, languages, sports, or general materials."
      }
    ],
    "quick_check": {
      "q_hi": "सही विकल्प चुनें: \"___ honesty is ___ best policy.\"",
      "q_en": "Fill in the blanks: \"___ honesty is ___ best policy.\"",
      "answer_hi": "पहला **कोई Article नहीं (×)** और दूसरा **`the`** → **\"Honesty is the best policy.\"**",
      "answer_en": "First **Zero Article (×)**, second **`the`** → **\"Honesty is the best policy.\"**"
    }
  },
  {
    "id": "u3-sec-3-room-picture-map",
    "order": 3,
    "heading_hi": "3. प्रीपोज़िशन चित्र मानचित्र: गेंद, डिब्बे और मेज़ से 8 Prepositions 30 सेकंड में!",
    "heading_en": "3. Prepositions Visual Picture Map: Master 8 Prepositions in 30 Seconds!",
    "analogy_hi": "प्रीपोज़िशन को कभी रटिए मत — बस अपनी आँखों के सामने **एक लाल गेंद (Ball)**, **एक मेज़ (Table)** और **एक डिब्बा (Box)** देखिए! गेंद कहाँ रखी है या किधर जा रही है, यही देखकर आपको तुरंत पता चल जाएगा कि `on, under, in, into, between, behind, over` या `beside` लगेगा!",
    "analogy_en": "Never memorize prepositions from boring lists — just picture **one red ball**, **a table**, and **a box**! Looking at where the ball sits or moves instantly reveals whether to use `on, under, in, into, between, behind, over`, or `beside`!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "गेंद, मेज़ और डिब्बे का 8-पैनल प्रीपोज़िशन चित्र मानचित्र",
      "title_en": "8-Panel Visual Preposition Picture Map (Ball, Box & Table)",
      "caption_hi": "ध्यान से देखें: ON में गेंद सतह को छू रही है, OVER में बिना छुए ऊपर से उछल रही है; IN में गेंद अंदर स्थिर है, INTO में बाहर से अंदर गति कर रही है!",
      "caption_en": "Compare carefully: ON touches the surface while OVER arcs above without touching; IN is resting inside while INTO shows motion entering inside!",
      "viewBox": "0 0 680 300",
      "elements": [
        {
          "kind": "rect",
          "x": 14,
          "y": 12,
          "width": 152,
          "height": 130,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 42,
          "y": 74,
          "width": 96,
          "height": 10,
          "rx": 2,
          "fill": "#92400E",
          "stroke": "#78350F",
          "strokeWidth": 1.5
        },
        {
          "kind": "line",
          "x1": 52,
          "y1": 84,
          "x2": 52,
          "y2": 112,
          "stroke": "#78350F",
          "strokeWidth": 3
        },
        {
          "kind": "line",
          "x1": 128,
          "y1": 84,
          "x2": 128,
          "y2": 112,
          "stroke": "#78350F",
          "strokeWidth": 3
        },
        {
          "kind": "circle",
          "cx": 90,
          "cy": 61,
          "r": 12,
          "fill": "#DC2626",
          "stroke": "#991B1B",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 90,
          "y": 32,
          "text_hi": "ON (ऊपर सटा)",
          "text_en": "ON (touching top)",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 180,
          "y": 12,
          "width": 152,
          "height": 130,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 208,
          "y": 66,
          "width": 96,
          "height": 10,
          "rx": 2,
          "fill": "#92400E",
          "stroke": "#78350F",
          "strokeWidth": 1.5
        },
        {
          "kind": "line",
          "x1": 218,
          "y1": 76,
          "x2": 218,
          "y2": 114,
          "stroke": "#78350F",
          "strokeWidth": 3
        },
        {
          "kind": "line",
          "x1": 294,
          "y1": 76,
          "x2": 294,
          "y2": 114,
          "stroke": "#78350F",
          "strokeWidth": 3
        },
        {
          "kind": "circle",
          "cx": 256,
          "cy": 102,
          "r": 12,
          "fill": "#DC2626",
          "stroke": "#991B1B",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 256,
          "y": 32,
          "text_hi": "UNDER (नीचे)",
          "text_en": "UNDER (below)",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 346,
          "y": 12,
          "width": 152,
          "height": 130,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 386,
          "y": 66,
          "width": 72,
          "height": 52,
          "rx": 4,
          "fill": "#DBEAFE",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "circle",
          "cx": 422,
          "cy": 96,
          "r": 12,
          "fill": "#DC2626",
          "stroke": "#991B1B",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 422,
          "y": 32,
          "text_hi": "IN (अंदर स्थिर)",
          "text_en": "IN (inside, rest)",
          "fill": "#059669",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 512,
          "y": 12,
          "width": 154,
          "height": 130,
          "rx": 10,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.8
        },
        {
          "kind": "rect",
          "x": 562,
          "y": 74,
          "width": 72,
          "height": 48,
          "rx": 4,
          "fill": "#DBEAFE",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "circle",
          "cx": 540,
          "cy": 58,
          "r": 10,
          "fill": "#DC2626",
          "stroke": "#991B1B",
          "strokeWidth": 1.5
        },
        {
          "kind": "arrow",
          "x1": 552,
          "y1": 62,
          "x2": 594,
          "y2": 94,
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 589,
          "y": 32,
          "text_hi": "INTO (गति से अंदर)",
          "text_en": "INTO (moving in)",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 14,
          "y": 156,
          "width": 152,
          "height": 130,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 26,
          "y": 214,
          "width": 38,
          "height": 48,
          "rx": 4,
          "fill": "#DBEAFE",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "circle",
          "cx": 90,
          "cy": 242,
          "r": 12,
          "fill": "#DC2626",
          "stroke": "#991B1B",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 116,
          "y": 214,
          "width": 38,
          "height": 48,
          "rx": 4,
          "fill": "#DBEAFE",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 90,
          "y": 176,
          "text_hi": "BETWEEN (2 के बीच)",
          "text_en": "BETWEEN (2 items)",
          "fill": "#7C3AED",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 180,
          "y": 156,
          "width": 152,
          "height": 130,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.5
        },
        {
          "kind": "circle",
          "cx": 234,
          "cy": 222,
          "r": 12,
          "fill": "#DC2626",
          "stroke": "#991B1B",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 234,
          "y": 214,
          "width": 62,
          "height": 50,
          "rx": 4,
          "fill": "#DBEAFE",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 256,
          "y": 176,
          "text_hi": "BEHIND (पीछे छिपा)",
          "text_en": "BEHIND (at back)",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 346,
          "y": 156,
          "width": 152,
          "height": 130,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 396,
          "y": 230,
          "width": 52,
          "height": 34,
          "rx": 4,
          "fill": "#DBEAFE",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "path",
          "d": "M 366 254 Q 422 186 476 254",
          "fill": "none",
          "stroke": "#059669",
          "strokeWidth": 2.2,
          "dashed": true
        },
        {
          "kind": "circle",
          "cx": 422,
          "cy": 204,
          "r": 10,
          "fill": "#DC2626",
          "stroke": "#991B1B",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 422,
          "y": 176,
          "text_hi": "OVER (ऊपर से कूदकर)",
          "text_en": "OVER (arcing above)",
          "fill": "#059669",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 512,
          "y": 156,
          "width": 154,
          "height": 130,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 534,
          "y": 216,
          "width": 58,
          "height": 48,
          "rx": 4,
          "fill": "#DBEAFE",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "circle",
          "cx": 616,
          "cy": 250,
          "r": 12,
          "fill": "#DC2626",
          "stroke": "#991B1B",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 589,
          "y": 176,
          "text_hi": "BESIDE (बगल में)",
          "text_en": "BESIDE (next to)",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### 4 सबसे ज़्यादा भ्रमित करने वाले जोड़े — 10 सेकंड में साफ!\n1. **`in` बनाम `into`:**\n   - मछली पानी के अंदर पहले से है (स्थिर) → The fish is **in** the water.\n   - मेंढक कुएँ में कूदा (बाहर से अंदर गति!) → The frog jumped **into** the well.\n2. **`on` बनाम `upon / onto`:**\n   - किताब मेज़ पर रखी है (स्थिर) → The book is **on** the table.\n   - बिल्ली मेज़ पर कूदी (गति!) → The cat jumped **upon / onto** the table.\n3. **`between` बनाम `among`:**\n   - **2** लोगों के बीच मिठाई बाँटें → Distribute sweets **between** Ram and Shyam.\n   - **2 से अधिक** बच्चों के बीच बाँटें → Distribute sweets **among** the children.\n4. **`beside` बनाम `besides`:**\n   - `beside` = बगल में (*Sit **beside** me.*)\n   - `besides` = के अलावा (*I know Hindi **besides** English.*)",
    "concept_md_en": "### 4 Classic Confusing Pairs — Cleared in 10 Seconds!\n1. **`in` vs `into`:**\n   - Static inside → The fish is **in** the water.\n   - Motion from outside to inside → The frog jumped **into** the well.\n2. **`on` vs `upon / onto`:**\n   - Resting on top → The book is **on** the table.\n   - Leaping onto top → The cat jumped **upon / onto** the table.\n3. **`between` vs `among`:**\n   - Strictly **2** → Distribute sweets **between** Ram and Shyam.\n   - **3 or more** → Distribute sweets **among** the children.\n4. **`beside` vs `besides`:**\n   - `beside` = next to (*Sit **beside** me.*)\n   - `besides` = in addition to (*I know Hindi **besides** English.*)",
    "exam_tip_hi": "बिहार बोर्ड का सुपर-रिपीट सवाल: `\"He jumped ___ the river.\"` या `\"The cat jumped ___ the table.\"` — जब भी `jumped / fell / poured` जैसी गति वाली क्रिया दिखे, `in` की जगह **`into`** और `on` की जगह **`upon/onto`** चुनें!",
    "exam_tip_en": "Super-Repeated BSEB Question: `\"He jumped ___ the river.\"` Whenever motion verbs (`jumped, fell, dived`) move into a container, choose **`into`** instead of `in`!",
    "glossary_terms": [
      {
        "term_hi": "संबंधबोधक (Preposition)",
        "term_en": "Preposition",
        "pronunciation_hi": "प्रीपोज़िशन",
        "definition_hi": "संज्ञा या सर्वनाम से पहले आकर स्थान, समय या दिशा का संबंध बताने वाला शब्द (in, on, at, under, into)।",
        "definition_en": "A word placed before a noun/pronoun to show position, direction, or time (in, on, at, under, into)."
      }
    ],
    "quick_check": {
      "q_hi": "सही Preposition चुनें: \"Divide these mangoes ___ the five boys.\" (between / among)",
      "q_en": "Choose the right preposition: \"Divide these mangoes ___ the five boys.\" (between / among)",
      "answer_hi": "**among** — क्योंकि 5 लड़के (2 से अधिक) हैं!",
      "answer_en": "**among** — because there are five boys (more than two)!"
    }
  },
  {
    "id": "u3-sec-4-time-and-fixed",
    "order": 4,
    "heading_hi": "4. समय का उल्टा त्रिकोण (IN → ON → AT) और BSEB के 12 पक्के Fixed Prepositions",
    "heading_en": "4. The Inverted Time Pyramid (IN → ON → AT) & Top 12 BSEB Fixed Prepositions",
    "analogy_hi": "समय के तीन सबसे बड़े प्रीपोज़िशन को एक **उल्टे त्रिकोण (कीप / Funnel)** की तरह याद करें! सबसे चौड़ा ऊपर का हिस्सा = **बड़ा समय (`IN`: महीना, साल, मौसम — IN July, IN 2026, IN winter)**। बीच का हिस्सा = **एक दिन या तारीख (`ON`: ON Monday, ON 15 August)**। और सबसे नीचे की नुकीली नोक = **घड़ी का ठीक समय (`AT`: AT 7 AM, AT night, AT noon)**!",
    "analogy_en": "Picture an **Inverted Funnel (Pyramid)** for Time Prepositions! Wide top = **Big blocks (`IN`: months, years, seasons — IN July, IN 2026, IN winter)**. Middle = **1 Day or Date (`ON`: ON Monday, ON 15 August)**. Sharp bottom tip = **Exact clock pinpoint (`AT`: AT 7 AM, AT noon, AT night)**!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "समय का उल्टा त्रिकोण: IN (बड़ा) → ON (दिन) → AT (ठीक समय)",
      "title_en": "Inverted Time Pyramid: IN (Big) → ON (Day/Date) → AT (Exact Time)",
      "caption_hi": "यह एक ही चित्र समय और स्थान दोनों में काम करता है: बड़ा शहर/राज्य (IN Bihar, IN Patna), सड़क (ON Bailey Road), छोटा गाँव/ठीक बिंदु (AT Kaparpura, AT the door)!",
      "caption_en": "The same funnel works for Place too: Big state/city (IN Bihar), Street (ON Main Road), Small village/exact spot (AT the gate, AT Kaparpura)!",
      "viewBox": "0 0 640 250",
      "elements": [
        {
          "kind": "polygon",
          "points": "80,22 560,22 490,94 150,94",
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 320,
          "y": 50,
          "text_hi": "IN — महीना · साल · मौसम · बड़ा राज्य",
          "text_en": "IN — Months · Years · Seasons · Big Cities",
          "fill": "#1E3A8A",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 320,
          "y": 80,
          "text_hi": "in July · in 2026 · in winter · in Bihar",
          "text_en": "in July · in 2026 · in winter · in Bihar",
          "fill": "#1E40AF",
          "fontSize": 12,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "polygon",
          "points": "150,100 490,100 420,168 220,168",
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 320,
          "y": 126,
          "text_hi": "ON — दिन और तारीख",
          "text_en": "ON — Days & Exact Dates",
          "fill": "#92400E",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 320,
          "y": 154,
          "text_hi": "on Monday · on 26 January · on Sunday",
          "text_en": "on Monday · on 26 January · on Sunday",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": false
        },
        {
          "kind": "polygon",
          "points": "220,174 420,174 320,238",
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 320,
          "y": 196,
          "text_hi": "AT — घड़ी का ठीक समय",
          "text_en": "AT — Exact Clock Time",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 320,
          "y": 218,
          "text_hi": "at 7 AM · at night",
          "text_en": "at 7 AM · at night",
          "fill": "#047857",
          "fontSize": 11,
          "anchor": "middle",
          "bold": false
        }
      ]
    },
    "concept_md_hi": "### BSEB के 12 सबसे पक्के Fixed Prepositions (सीधे बोर्ड में आते हैं!)\n- **afraid of** (से डरना): *He is afraid **of** snakes.*\n- **fond of** (शौकीन होना): *She is fond **of** music.*\n- **proud of** (गर्व होना): *We are proud **of** Bihar.*\n- **died of** (बीमारी से मृत्यु): *He died **of** malaria.* *(ध्यान दें: बीमारी के लिए `from` नहीं, **`of`** लगता है!)*\n- **suffer from** (बीमारी से पीड़ित): *I am suffering **from** fever.*\n- **good at** (किसी विषय/खेल में अच्छा): *Ravi is good **at** Mathematics.* *(`in` नहीं, **`at`**!)*\n- **senior to / junior to / prefer to**: *He is senior **to** me.* *(`than` नहीं, **`to`**!)*\n- **listen to** (सुनना): *Listen **to** your teacher.*\n- **look at** (देखना) / **look after** (देखभाल करना): *Look **at** the blackboard.*\n- **agree with** (व्यक्ति से सहमत): *I agree **with** you.*\n- **wait for** (इंतज़ार करना): *Wait **for** me.*\n- **by** (वाहन से यात्रा) बनाम **with** (औज़ार से काम): *I go **by** bus. / I write **with** a pen.*",
    "concept_md_en": "### Top 12 Fixed Prepositions Repeated Every Year in BSEB!\n- **afraid of**: *He is afraid **of** snakes.*\n- **fond of**: *She is fond **of** music.*\n- **proud of**: *We are proud **of** Bihar.*\n- **died of** (disease): *He died **of** malaria.* *(Always **`of`**, not `from`, for diseases!)*\n- **suffer from**: *I am suffering **from** fever.*\n- **good at** (skill/subject): *Ravi is good **at** Mathematics.* *(Not `in`!)*\n- **senior to / junior to / prefer to**: *He is senior **to** me.* *(NEVER `than`!)*\n- **listen to**: *Listen **to** your teacher.*\n- **look at** / **look after**: *Look **at** the blackboard.*\n- **agree with** (a person): *I agree **with** you.*\n- **wait for**: *Wait **for** me.*\n- **by** (transport/agent) vs **with** (instrument): *go **by** train; write **with** a pen; cut **with** a knife.*",
    "exam_tip_hi": "3 गोल्डन BSEB ट्रैप: (1) बीमारी से मृत्यु → **`died of`**, (2) विषय में तेज़ → **`good at`**, (3) कलम/चाकू (औज़ार) से काम → **`with a pen / with a knife`** (`by` नहीं!)।",
    "exam_tip_en": "3 Golden BSEB Traps: (1) Disease death → **`died of`**, (2) Skilled in a subject → **`good at`**, (3) Tool/instrument → **`with a pen / with a knife`** (NOT `by`!).",
    "glossary_terms": [
      {
        "term_hi": "निश्चित प्रीपोज़िशन (Fixed Preposition)",
        "term_en": "Fixed Preposition",
        "pronunciation_hi": "फ़िक्स्ड प्रीपोज़िशन",
        "definition_hi": "कुछ विशेष शब्दों के साथ हमेशा जुड़ने वाला एक तय प्रीपोज़िशन, जैसे fond of, good at, senior to।",
        "definition_en": "A specific preposition permanently paired with a verb or adjective, e.g., fond of, good at, senior to."
      }
    ],
    "quick_check": {
      "q_hi": "सही शब्द चुनें: \"She cut the apple ___ a knife.\" (by / with / from)",
      "q_en": "Pick the exact preposition: \"She cut the apple ___ a knife.\" (by / with / from)",
      "answer_hi": "**with** — क्योंकि चाकू एक औज़ार (instrument) है!",
      "answer_en": "**with** — because a knife is an instrument/tool!"
    }
  },
  {
    "id": "u3-sec-5-formula-card",
    "order": 5,
    "heading_hi": "5. परीक्षा से पहले 1-नज़र आर्टिकल्स व प्रीपोज़िशन सूत्र कार्ड",
    "heading_en": "5. 1-Glance Articles & Prepositions Exam Formula Card",
    "analogy_hi": "इन 6 छोटे नियमों को जेब में रखिए — बिहार बोर्ड के 8 से ज़्यादा ऑब्जेक्टिव प्रश्न 30 सेकंड में हल हो जाएँगे!",
    "analogy_en": "Keep these 6 pocket formulas handy — they unlock 8+ BSEB objective marks in under 30 seconds!",
    "visual_diagram": {
      "type": "FORMULA_CARD",
      "title_hi": "इकाई 3 के 6 पक्के बोर्ड सूत्र",
      "title_en": "6 Guaranteed Board Rules of Unit 3",
      "formulas": [
        {
          "latex": "\\text{Vowel Sound} \\rightarrow \\text{an} \\quad|\\quad \\text{Consonant Sound} \\rightarrow \\text{a}",
          "meaning_hi": "स्पेलिंग नहीं, पहली आवाज़ से a/an चुनें",
          "meaning_en": "Pick a/an strictly by spoken sound, not letter",
          "example_hi": "an hour, an MLA | a university, a one-rupee note",
          "example_en": "an hour, an MLA | a university, a one-rupee note"
        },
        {
          "latex": "\\text{The} + \\text{River / Holy Book / Superlative}",
          "meaning_hi": "खास व अनोखी चीज़ों के आगे The",
          "meaning_en": "Definite \"the\" for unique items & superlatives",
          "example_hi": "the Ganga, the Gita, the best student",
          "example_en": "the Ganga, the Gita, the best student"
        },
        {
          "latex": "\\text{in (rest)} \\quad\\text{vs}\\quad \\text{into (motion)}",
          "meaning_hi": "अंदर स्थिर = in, बाहर से अंदर गति = into",
          "meaning_en": "Static inside = in; moving inside = into",
          "example_hi": "in the room | jumped into the river",
          "example_en": "in the room | jumped into the river"
        },
        {
          "latex": "\\text{between (2)} \\quad\\text{vs}\\quad \\text{among (3+)}",
          "meaning_hi": "2 के लिए between, 2 से अधिक के लिए among",
          "meaning_en": "between for 2; among for 3 or more",
          "example_hi": "between Ram & Shyam | among the boys",
          "example_en": "between Ram & Shyam | among the boys"
        },
        {
          "latex": "\\text{IN (month/year)} \\rightarrow \\text{ON (day/date)} \\rightarrow \\text{AT (clock time)}",
          "meaning_hi": "समय का उल्टा त्रिकोण नियम",
          "meaning_en": "Inverted Time Pyramid Rule",
          "example_hi": "in 2026 | on Monday | at 7 AM",
          "example_en": "in 2026 | on Monday | at 7 AM"
        },
        {
          "latex": "\\text{by (person/vehicle)} \\quad\\text{vs}\\quad \\text{with (tool)}",
          "meaning_hi": "व्यक्ति/वाहन = by, औज़ार = with",
          "meaning_en": "Agent/vehicle = by; instrument/tool = with",
          "example_hi": "by bus | write with a pen",
          "example_en": "by bus | write with a pen"
        }
      ]
    },
    "concept_md_hi": "### त्वरित याददाश्त जाँच\n- क्या `hour` में `h` बोला जाता है? **नहीं!** (\"आवर\" → `an hour`)\n- क्या `university` में `u` की आवाज़ \"अ\" है? **नहीं!** (\"यूनिवर्सिटी\" → `a university`)\n- क्या `senior` के बाद `than` आता है? **नहीं!** (हमेशा `senior to`)",
    "concept_md_en": "### Quick Memory Check\n- Is `h` pronounced in `hour`? **No!** → `an hour`\n- Does `university` start with a vowel sound? **No!** (\"yoo\") → `a university`\n- Does `senior` take `than`? **Never!** → `senior to`",
    "exam_tip_hi": "प्रीपोज़िशन चुनते समय हमेशा पहले पूरे वाक्य का दृश्य अपने दिमाग में बनाएँ — चित्र देखते ही 90% उत्तर अपने आप सही हो जाते हैं!",
    "exam_tip_en": "Always visualize the physical scene in your mind before choosing a preposition — mental pictures solve 90% of questions accurately!",
    "glossary_terms": []
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{Vowel Sound} \\rightarrow \\text{an},\\quad \\text{Consonant Sound} \\rightarrow \\text{a}",
      "label_hi": "हिंदी स्वर-ध्वनि नियम (a बनाम an)",
      "label_en": "Sound-First Article Rule (a vs an)"
    },
    {
      "latex": "\\text{IN (Year/Month)} \\rightarrow \\text{ON (Day/Date)} \\rightarrow \\text{AT (Time)}",
      "label_hi": "समय प्रीपोज़िशन त्रिकोण",
      "label_en": "Time Preposition Pyramid"
    },
    {
      "latex": "\\text{died of (disease)},\\quad \\text{good at},\\quad \\text{senior to}",
      "label_hi": "BSEB के 3 सबसे प्रसिद्ध Fixed Prepositions",
      "label_en": "Top 3 BSEB Fixed Prepositions"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "SOUND",
      "fact_hi": "an hour, an honest man, an heir, an MLA, an MP, an SDO — सबमें स्वर ध्वनि है!",
      "fact_en": "an hour, an honest man, an heir, an MLA, an MP, an SDO — all start with vowel sounds!"
    },
    {
      "tag": "TRAP",
      "fact_hi": "a university, a union, a useful book, a European, a one-rupee note — सबमें व्यंजन ध्वनि (य/व) है!",
      "fact_en": "a university, a union, a useful book, a European, a one-rupee note — all start with consonant sounds!"
    },
    {
      "tag": "TIME",
      "fact_hi": "in the morning / in the evening, पर रात व दोपहर के लिए हमेशा `at night / at noon`!",
      "fact_en": "Use `in the morning/evening`, but strictly `at night / at noon`!"
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "\"He is a honest boy\" या \"She reads in an university.\" लिखना।",
      "mistake_en": "Writing \"a honest boy\" or \"an university\" based on spelling instead of sound.",
      "fix_hi": "सही: **\"He is an honest boy.\"** और **\"She reads in a university.\"**",
      "fix_en": "Correct: **\"He is an honest boy.\"** and **\"She reads in a university.\"**"
    },
    {
      "mistake_hi": "\"He jumped in the river.\" (गति होने पर भी `in` लगा देना)",
      "mistake_en": "Writing \"He jumped in the river\" for inward motion.",
      "fix_hi": "बाहर से अंदर कूदने की गति में हमेशा **`into`** लगाएँ: **\"He jumped into the river.\"**",
      "fix_en": "Use **`into`** for movement from outside to inside: **\"He jumped into the river.\"**"
    },
    {
      "mistake_hi": "\"He is senior than me\" या \"He died from cholera.\" लिखना।",
      "mistake_en": "Writing \"senior than me\" or \"died from cholera\".",
      "fix_hi": "हमेशा **`senior to`** और बीमारी के लिए **`died of`**: **\"He is senior to me.\" / \"He died of cholera.\"**",
      "fix_en": "Always **`senior to`** and **`died of`** (disease): **\"He is senior to me.\" / \"He died of cholera.\"**"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "Articles (a, an, the, Zero Article) — BSEB Objective",
      "topic_en": "Articles (a, an, the & Zero Article) MCQs",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 4
    },
    {
      "topic_hi": "Place, Time & Fixed Prepositions — BSEB Objective",
      "topic_en": "Place, Time & Fixed Prepositions MCQs",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 4
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 5,
  "analogy_count": 5,
  "bseb_pyq_mapped": true,
  "syllabus_year": "2026-27"
}$json$::jsonb,
  'PUBLISHED',
  1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json        = EXCLUDED.mindmap_json,
  sections_json       = EXCLUDED.sections_json,
  board_capsule_json  = EXCLUDED.board_capsule_json,
  quality_checks_json = EXCLUDED.quality_checks_json,
  status              = EXCLUDED.status,
  version             = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'skill-eng-f-ch3',
  3,
  'विद्यार्थियों को हिंदी स्वर-ध्वनि (अ–अः) द्वारा a/an चुनने की अचूक तकनीक सिखाना, कक्षा में चाक-डस्टर के प्रत्यक्ष प्रयोग से सभी प्रमुख प्रीपोज़िशन दिखाना, तथा समय त्रिकोण व Fixed Prepositions पर 100% सटीकता दिलाना।',
  'Equip students with the foolproof Hindi vowel-sound test for a/an, physically demonstrate place prepositions with chalk and a duster, and build 100% accuracy on the Time Pyramid and BSEB Fixed Prepositions.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "5-मिनट \"कान खोलो\" स्वर-ध्वनि खेल + a / an / the नियम",
    "phase_en": "5-Min Ear-Test Sound Game + a / an / the Rules",
    "teacher_action_hi": "मिनट 0–5: शिक्षक 10 शब्द ज़ोर से बोलें (`apple, hour, university, MLA, boy, honest, one-rupee, umbrella, European, SDO`) — स्वर (अ–अः) सुनाई देने पर छात्र 2 उँगली (\"an\") और व्यंजन (क–ज्ञ) पर 1 उँगली (\"a\") उठाएँ! मिनट 5–22: बोर्ड पर स्वर-ध्वनि फ़िल्टर बनाएँ। मिनट 22–34: `The` बनाम Zero Article (Patna, Hindi, cricket) की तालिका समझाएँ। मिनट 34–40: 5 BSEB PYQ।",
    "teacher_action_en": "Mins 0–5: Call out 10 words (`apple, hour, university, MLA, boy, honest, one-rupee, umbrella, European, SDO`) — students hold up 2 fingers (\"an\") for vowel sounds and 1 finger (\"a\") for consonant sounds! Mins 5–22: Draw the sound filter on the board. Mins 22–34: Contrast `the` vs Zero Article. Mins 34–40: 5 quick BSEB PYQs.",
    "student_check_hi": "पूछें: \"University\" U से शुरू होता है, फिर भी इसके आगे `an` क्यों नहीं लगता?",
    "student_check_en": "Ask: \"University\" starts with the letter U — why do we still say \"a university\"?"
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "चाक और डस्टर लाइव प्रीपोज़िशन शो (ON / UNDER / IN / INTO / BETWEEN / BEHIND)",
    "phase_en": "Live Chalk-and-Duster Preposition Show",
    "teacher_action_hi": "मिनट 0–5: बोलचाल कोरस — शिक्षक चाक को मेज़ के ऊपर/नीचे/डिब्बे में रखें और पूरी कक्षा ज़ोर से बोले: \"The chalk is ON the table! UNDER the table! IN the box!\"। मिनट 5–20: चाक को बाहर से डिब्बे में उछालकर `in` बनाम `into` का अंतर प्रत्यक्ष दिखाएँ; 2 बच्चों बनाम 4 बच्चों के बीच किताब रखकर `between` बनाम `among` दिखाएँ। मिनट 20–35: बोर्ड पर 8-पैनल गेंद-मेज़ चित्र बनवाएँ। मिनट 35–40: छात्र खुद एक-दूसरे को आदेश दें (\"Put the pen UNDER the book!\")।",
    "teacher_action_en": "Mins 0–5: Spoken chorus — place chalk on/under the table and inside the box while the class chants \"The chalk is ON the table! UNDER the table! IN the box!\" Mins 5–20: Drop chalk into the box to show `in` vs `into`; use 2 vs 4 students for `between` vs `among`. Mins 20–35: Draw the 8-panel Ball-and-Table map. Mins 35–40: Pair command game.",
    "student_check_hi": "चाक को हवा से डब्बे में डालते हुए पूछें: अभी `in` बोलेंगे या `into`?",
    "student_check_en": "Drop a chalk piece from mid-air into the box and ask: `in` or `into` right now?"
  },
  {
    "period_no": 3,
    "duration_mins": 40,
    "phase_hi": "समय का उल्टा त्रिकोण (IN → ON → AT) और 12 Fixed Prepositions",
    "phase_en": "Inverted Time Pyramid (IN → ON → AT) & Top 12 Fixed Prepositions",
    "teacher_action_hi": "मिनट 0–5: रैपिड-फ़ायर कोरस — शिक्षक बोलें \"Monday\" → कक्षा बोले \"ON!\", \"2025\" → \"IN!\", \"6 PM\" → \"AT!\"। मिनट 5–20: बोर्ड पर बड़ा उल्टा त्रिकोण खींचें। मिनट 20–32: 12 Fixed Prepositions (`died of, good at, senior to, fond of, afraid of`) की जोड़ियाँ बुलवाएँ। मिनट 32–40: 8-अंक मिनी टेस्ट।",
    "teacher_action_en": "Mins 0–5: Rapid chorus — teacher calls \"Monday\" → class shouts \"ON!\", \"2025\" → \"IN!\", \"6 PM\" → \"AT!\" Mins 5–20: Draw the big Inverted Time Pyramid on the board. Mins 20–32: Drill the 12 Fixed Preposition pairs aloud. Mins 32–40: 8-mark quick quiz.",
    "student_check_hi": "पूछें: \"वह गणित में अच्छा है\" — `good in Maths` या `good at Maths`?",
    "student_check_en": "Ask: For \"good in/at Maths\", which preposition wins full marks in BSEB?"
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड 1: a/an ध्वनि नियम + The बनाम ×",
    "heading_en": "Blackboard 1: Sound Rule for a/an + The vs Zero Article",
    "points_hi": [
      "अ–अः ध्वनि → an (an hour, an honest man, an MLA, an SDO)",
      "क–ज्ञ ध्वनि → a (a university, a European, a one-rupee note)",
      "The = the Ganga, the Gita, the sun, the best | × = Patna, Hindi, cricket, gold"
    ],
    "points_en": [
      "Vowel sound → an (an hour, an honest man, an MLA, an SDO)",
      "Consonant sound → a (a university, a European, a one-rupee note)",
      "The = the Ganga, the Gita, the sun, the best | × = Patna, Hindi, cricket, gold"
    ]
  },
  {
    "heading_hi": "ब्लैकबोर्ड 2: उल्टा समय त्रिकोण और BSEB पक्की जोड़ियाँ",
    "heading_en": "Blackboard 2: Time Pyramid & Fixed Prepositions",
    "points_hi": [
      "IN (महीना/साल/मौसम) → ON (दिन/तारीख) → AT (घड़ी का समय/night)",
      "in (स्थिर) बनाम into (गति) | between (2) बनाम among (3+)",
      "died of (बीमारी) | good at (विषय) | senior to | write with a pen | go by bus"
    ],
    "points_en": [
      "IN (month/year/season) → ON (day/date) → AT (clock time/night)",
      "in (rest) vs into (motion) | between (2) vs among (3+)",
      "died of (disease) | good at (subject) | senior to | write with a pen | go by bus"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "1-उँगली / 2-उँगली \"अ–अः\" ध्वनि दौड़",
    "title_en": "1-Finger vs 2-Finger Vowel-Sound Sprint",
    "materials_hi": "कुछ नहीं — केवल शिक्षक की 15 शब्दों की सूची",
    "materials_en": "None — just teacher calling out 15 mixed words",
    "steps_hi": "शिक्षक शब्द बोलें, छात्र बिना लिखे केवल उँगली उठाकर `a` (1 उँगली) या `an` (2 उँगली) बताएँ। इससे संकोची छात्र भी खेल-खेल में 100% सटीक ध्वनि-पहचान सीख लेते हैं।",
    "steps_en": "Teacher calls words aloud; students flash 1 finger for `a` or 2 fingers for `an`. Even shy students master sound-based articles joyfully."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "अपनी कॉपी में 8-पैनल गेंद-मेज़ प्रीपोज़िशन चित्र बनाकर हर चित्र के नीचे 1 सरल अंग्रेज़ी वाक्य लिखें (जैसे: The ball is on the table.)।",
    "task_en": "Sketch the 8-panel Ball-and-Table preposition chart in your notebook and write 1 simple English sentence beneath each."
  },
  {
    "level": "BOARD",
    "task_hi": "इन 10 शब्दों से पहले सही a/an लगाएँ: hour, university, MLA, honest girl, one-eyed man, umbrella, European, SDO, useful book, apple।",
    "task_en": "Put the exact article (a or an) before these 10 BSEB words: hour, university, MLA, honest girl, one-eyed man, umbrella, European, SDO, useful book, apple."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "अपनी कक्षा के कमरे का वर्णन करते हुए 6 वाक्य लिखें जिनमें `on, under, in, behind, between, beside` सभी 6 प्रीपोज़िशन का प्रयोग हो।",
    "task_en": "Describe your classroom in 6 English sentences using all 6 prepositions: `on, under, in, behind, between, beside`."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र `a, e, i, o, u` अक्षर देखकर आँख बंद करके `an university` या `an one-rupee note` लिख देते हैं।",
    "misconception_en": "Students check spelling letters instead of sound, writing \"an university\" or \"an one-rupee note\".",
    "correction_hi": "हमेशा शब्द को हिंदी में लिखकर पहला अक्षर देखने को कहें — यूनिवर्सिटी (य) और वन (व) व्यंजन हैं, इसलिए `a` लगेगा!",
    "correction_en": "Have students write the first sound in Hindi — \"य\" (university) and \"व\" (one) are consonants, so they take `a`!"
  },
  {
    "misconception_hi": "छात्र हिंदी \"से\" देखकर `cut by a knife`, `died from fever`, और `senior than me` लिख देते हैं।",
    "misconception_en": "Students translate Hindi \"se\" literally into `by a knife`, `died from fever`, or `senior than me`.",
    "correction_hi": "बोर्ड पर तीन पक्की जोड़ियाँ लाल चाक से घेरें: **with a knife / pen**, **died of (disease)**, **senior to**।",
    "correction_en": "Box these 3 non-negotiable English idioms on the board: **with a knife/pen**, **died of (disease)**, and **senior to**."
  }
]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods                   = EXCLUDED.duration_periods,
  objectives_hi                      = EXCLUDED.objectives_hi,
  objectives_en                      = EXCLUDED.objectives_en,
  teaching_steps_json                = EXCLUDED.teaching_steps_json,
  blackboard_points_json             = EXCLUDED.blackboard_points_json,
  classroom_activities_json          = EXCLUDED.classroom_activities_json,
  homework_json                      = EXCLUDED.homework_json,
  common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Sound Rule an honest
  (
    '10000006-0003-4000-8000-000000000001', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Sound Rule an honest', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', 'BSEB 2023',
    'सही वाक्य बनाएँ: "वह एक ईमानदार व्यक्ति है।"',
    'Build the correct sentence: "He is an honest man."',
    NULL, NULL,
    '`honest` को "ऑनेस्ट" बोलते हैं (`h` साइलेंट है, आवाज़ "ऑ") → **`an`** चुनें!',
    '`honest` has a silent `h` (starts with vowel sound) → pick **`an`**!',
    '**"He is an honest man"** — `honest` की पहली ध्वनि स्वर ("ऑ") है, इसलिए `an` लगेगा।',
    '**"He is an honest man"** — `honest` begins with a vowel sound, so it takes `an`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "वह एक ईमानदार व्यक्ति है।",
  "prompt_en": "Build the sentence using the Hindi vowel-sound article rule",
  "grammar_formula": "He + is + an + honest + man",
  "tokens": [
    "He",
    "is",
    "an",
    "honest",
    "man"
  ],
  "distractors": [
    "a",
    "the"
  ],
  "correct_sentence": "He is an honest man",
  "pronunciation_hi": "ही इज़ ऐन ऑनेस्ट मैन"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Definite Article River
  (
    '10000006-0003-4000-8000-000000000002', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Definite Article River', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', 'BSEB 2024',
    'सही वाक्य बनाएँ: "गंगा एक पवित्र नदी है।"',
    'Build the classic BSEB sentence: "The Ganga is a holy river."',
    NULL, NULL,
    'नदी के नाम से पहले **`The`** और `holy river` (ह = व्यंजन) से पहले **`a`**!',
    'River names take **`The`**; consonant-sound `holy river` takes **`a`**!',
    '**"The Ganga is a holy river"** — नदियों के नाम से पहले हमेशा `The` आता है।',
    '**"The Ganga is a holy river"** — Rivers always take definite article `The`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "गंगा एक पवित्र नदी है।",
  "prompt_en": "Build the classic river sentence with The and a",
  "grammar_formula": "The + River Name + is + a + Adjective + Noun",
  "tokens": [
    "The",
    "Ganga",
    "is",
    "a",
    "holy",
    "river"
  ],
  "distractors": [
    "an",
    "are"
  ],
  "correct_sentence": "The Ganga is a holy river",
  "pronunciation_hi": "द गंगा इज़ अ होली रिवर"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Preposition into (Motion)
  (
    '10000006-0003-4000-8000-000000000003', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Preposition into (Motion)', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', 'BSEB 2022',
    'सही वाक्य बनाएँ: "मेंढक कुएँ में कूद गया।"',
    'Build the motion-preposition sentence: "The frog jumped into the well."',
    NULL, NULL,
    'बाहर से अंदर कूदने में गति है — `in` नहीं, **`into`** चुनें!',
    'Jumping from outside to inside shows motion — choose **`into`** (not `in`)!',
    '**"The frog jumped into the well"** — बाहर से अंदर गति के लिए हमेशा `into` आता है।',
    '**"The frog jumped into the well"** — `into` expresses inward movement.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मेंढक कुएँ में कूद गया।",
  "prompt_en": "Use the motion preposition into accurately",
  "grammar_formula": "Subject + jumped + into + Container",
  "tokens": [
    "The",
    "frog",
    "jumped",
    "into",
    "the",
    "well"
  ],
  "distractors": [
    "in",
    "on"
  ],
  "correct_sentence": "The frog jumped into the well",
  "pronunciation_hi": "द फ़्रॉग जम्प्ड इन्टू द वेल"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Place Preposition under
  (
    '10000006-0003-4000-8000-000000000004', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Place Preposition under', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "बिल्ली मेज़ के नीचे सो रही है।"',
    'Build the sentence: "The cat is sleeping under the table."',
    NULL, NULL,
    'मेज़ के नीचे के लिए **`under`** चुनें!',
    'Directly below the table takes **`under`**!',
    '**"The cat is sleeping under the table"** — ठीक नीचे की स्थिति के लिए `under` लगता है।',
    '**"The cat is sleeping under the table"** — `under` indicates directly beneath.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "बिल्ली मेज़ के नीचे सो रही है।",
  "prompt_en": "Build the visual place-preposition sentence",
  "grammar_formula": "Subject + is + V-ing + under + Object",
  "tokens": [
    "The",
    "cat",
    "is",
    "sleeping",
    "under",
    "the",
    "table"
  ],
  "distractors": [
    "on",
    "into"
  ],
  "correct_sentence": "The cat is sleeping under the table",
  "pronunciation_hi": "द कैट इज़ स्लीपिंग अंडर द टेबल"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (TOPPER, PRACTICE) — Fixed Preposition good at
  (
    '10000006-0003-4000-8000-000000000005', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Fixed Preposition good at', 'PRACTICE', 'SENTENCE_BUILDER', 'TOPPER', 'BSEB 2024',
    'सही वाक्य बनाएँ: "वह अंग्रेज़ी में बहुत अच्छी है।"',
    'Build the fixed-preposition sentence: "She is very good at English."',
    NULL, NULL,
    'किसी विषय या कौशल में अच्छा होने के लिए `good in` नहीं, **`good at`** लगता है!',
    'Skill in a subject uses **`good at`**, NOT `good in`!',
    '**"She is very good at English"** — अंग्रेज़ी में हमेशा `good at + subject/skill` होता है।',
    '**"She is very good at English"** — standard idiomatic pairing is `good at`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "वह अंग्रेज़ी में बहुत अच्छी है।",
  "prompt_en": "Use the exact BSEB fixed preposition with good",
  "grammar_formula": "Subject + is + very good + at + Subject/Skill",
  "tokens": [
    "She",
    "is",
    "very",
    "good",
    "at",
    "English"
  ],
  "distractors": [
    "in",
    "on"
  ],
  "correct_sentence": "She is very good at English",
  "pronunciation_hi": "शी इज़ वेरी गुड ऐट इंग्लिश"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (FOUNDATION, PRACTICE) — Room Picture Preposition
  (
    '10000006-0003-4000-8000-000000000006', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Room Picture Preposition', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', NULL,
    'कमरे के चित्र में लाल गेंद की स्थिति देखकर सही वाक्य चुनें:',
    'Look at the red ball in the room picture and choose the right sentence:',
    NULL, NULL,
    'लाल गेंद दो डिब्बों के ठीक बीच में रखी है — 2 वस्तुओं के बीच के लिए कौन-सा शब्द आता है?',
    'The red ball sits right in the middle of TWO boxes — which preposition means middle of 2?',
    '**"The ball is between the two boxes."** — दो वस्तुओं के बीच की स्थिति के लिए `between` लगता है।',
    '**"The ball is between the two boxes."** — `between` is used for a position separating two objects.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "चित्र मानचित्र: लाल गेंद कहाँ है?",
  "scene_title_en": "Picture Map: Where Is the Red Ball?",
  "prompt_hi": "नीचे दिए चित्र को ध्यान से देखें और गेंद की सटीक स्थिति बताने वाला वाक्य चुनें:",
  "prompt_en": "Look at the scene below and select the exact preposition sentence:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "दो डिब्बों और लाल गेंद की स्थिति",
    "title_en": "Position of the Red Ball & Two Boxes",
    "caption_hi": "गेंद बाएँ डिब्बे और दाएँ डिब्बे के ठीक बीच में है",
    "caption_en": "The red ball sits right in the middle of Box 1 and Box 2",
    "viewBox": "0 0 540 140",
    "elements": [
      {
        "kind": "line",
        "x1": 40,
        "y1": 112,
        "x2": 500,
        "y2": 112,
        "stroke": "#94A3B8",
        "strokeWidth": 2
      },
      {
        "kind": "rect",
        "x": 110,
        "y": 42,
        "width": 90,
        "height": 70,
        "rx": 6,
        "fill": "#DBEAFE",
        "stroke": "#1E3A8A",
        "strokeWidth": 2.2
      },
      {
        "kind": "label",
        "x": 155,
        "y": 80,
        "text_hi": "डिब्बा 1",
        "text_en": "Box 1",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "circle",
        "cx": 270,
        "cy": 92,
        "r": 19,
        "fill": "#DC2626",
        "stroke": "#991B1B",
        "strokeWidth": 2
      },
      {
        "kind": "rect",
        "x": 340,
        "y": 42,
        "width": 90,
        "height": 70,
        "rx": 6,
        "fill": "#DBEAFE",
        "stroke": "#1E3A8A",
        "strokeWidth": 2.2
      },
      {
        "kind": "label",
        "x": 385,
        "y": 80,
        "text_hi": "डिब्बा 2",
        "text_en": "Box 2",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "MessageSquare",
      "label_hi": "The ball is on the two boxes.",
      "label_en": "The ball is on the two boxes."
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "The ball is among the two boxes.",
      "label_en": "The ball is among the two boxes."
    },
    {
      "id": "c3",
      "icon": "MessageSquare",
      "label_hi": "The ball is inside the box.",
      "label_en": "The ball is inside the box."
    },
    {
      "id": "c4",
      "icon": "MessageSquare",
      "label_hi": "The ball is between the two boxes.",
      "label_en": "The ball is between the two boxes."
    }
  ],
  "correct_choice_id": "c4"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (BOARD, PRACTICE) — Motion into Picture
  (
    '10000006-0003-4000-8000-000000000007', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Motion into Picture', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'BSEB 2023',
    'गति का तीर देखकर सही प्रीपोज़िशन वाला वाक्य चुनें:',
    'Follow the motion arrow in the scene and select the right sentence:',
    NULL, NULL,
    'तीर बाहर से पानी के अंदर की ओर गति दिखा रहा है — स्थिर `in` नहीं, गति वाला **`into`** चुनें!',
    'The arrow shows movement from outside INTO the water — choose motion **`into`**!',
    '**"The boy dived into the river."** — बाहर से अंदर प्रवेश करने की गति हमेशा `into` लेती है।',
    '**"The boy dived into the river."** — Movement entering a space always takes `into`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "गति चित्र: बाहर से नदी के अंदर छलाँग",
  "scene_title_en": "Motion Scene: Diving From Bank Into River",
  "prompt_hi": "चित्र में लड़का किनारे से नदी में कूद रहा है। सही वाक्य चुनें:",
  "prompt_en": "The boy is diving from the bank into the water. Pick the exact sentence:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "बाहर से अंदर की ओर गति (Motion)",
    "title_en": "Movement From Outside to Inside",
    "caption_hi": "किनारे (बाहर) से नदी (अंदर) की ओर तीर",
    "caption_en": "Arrow moves from river bank into the water",
    "viewBox": "0 0 560 150",
    "elements": [
      {
        "kind": "rect",
        "x": 24,
        "y": 80,
        "width": 170,
        "height": 55,
        "rx": 4,
        "fill": "#FEF3C7",
        "stroke": "#B45309",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 109,
        "y": 112,
        "text_hi": "नदी का किनारा",
        "text_en": "River Bank",
        "fill": "#92400E",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 194,
        "y": 92,
        "width": 342,
        "height": 43,
        "rx": 4,
        "fill": "#DBEAFE",
        "stroke": "#2563EB",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 380,
        "y": 118,
        "text_hi": "नदी का पानी (River)",
        "text_en": "River Water",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "circle",
        "cx": 165,
        "cy": 56,
        "r": 12,
        "fill": "#059669",
        "stroke": "#065F46",
        "strokeWidth": 2
      },
      {
        "kind": "path",
        "d": "M 180 54 Q 255 18 295 102",
        "fill": "none",
        "stroke": "#DC2626",
        "strokeWidth": 3,
        "dashed": true
      },
      {
        "kind": "arrow",
        "x1": 280,
        "y1": 76,
        "x2": 300,
        "y2": 106,
        "stroke": "#DC2626",
        "strokeWidth": 3
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "PenTool",
      "label_hi": "The boy dived in the river.",
      "label_en": "The boy dived in the river."
    },
    {
      "id": "c2",
      "icon": "PenTool",
      "label_hi": "The boy dived into the river.",
      "label_en": "The boy dived into the river."
    },
    {
      "id": "c3",
      "icon": "PenTool",
      "label_hi": "The boy dived on the river.",
      "label_en": "The boy dived on the river."
    },
    {
      "id": "c4",
      "icon": "PenTool",
      "label_hi": "The boy dived under the river.",
      "label_en": "The boy dived under the river."
    }
  ],
  "correct_choice_id": "c2"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (TOPPER, PRACTICE) — Sound Ear-Test Lab
  (
    '10000006-0003-4000-8000-000000000008', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Sound Ear-Test Lab', 'PRACTICE', 'SCENARIO_LAB', 'TOPPER', 'BSEB 2024',
    'हिंदी ध्वनि नियम लगाकर दोनों रिक्त स्थान एक साथ भरें:',
    'Use the Hindi sound filter to pick the exact pair of articles:',
    NULL, NULL,
    '`hour` = "आवर" (स्वर ध्वनि → `an`), `university` = "यूनिवर्सिटी" (व्यंजन ध्वनि → `a`)!',
    '`hour` = vowel sound ("our") → `an`; `university` = consonant sound ("yoo") → `a`!',
    '**"I waited an hour near a university."** — दोनों शब्द स्पेलिंग के विपरीत ध्वनि से तय होते हैं!',
    '**"I waited an hour near a university."** — Both prove why sound always beats spelling!',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "दोहरा ध्वनि परीक्षण: hour + university",
  "scene_title_en": "Double Ear Test: hour + university",
  "prompt_hi": "\"I waited ___ hour near ___ university.\" — सही जोड़ी चुनें:",
  "prompt_en": "\"I waited ___ hour near ___ university.\" — Choose the 100% accurate pair:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "पहली आवाज़ सुनकर चुनें",
    "title_en": "Decide Strictly by First Spoken Sound",
    "caption_hi": "hour = आवर (स्वर) | university = यूनिवर्सिटी (व्यंजन)",
    "caption_en": "hour = \"our\" (vowel sound) | university = \"yoo\" (consonant sound)",
    "viewBox": "0 0 560 120",
    "elements": [
      {
        "kind": "rect",
        "x": 26,
        "y": 20,
        "width": 240,
        "height": 78,
        "rx": 10,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 146,
        "y": 48,
        "text_hi": "1. hour → \"आवर\" (अ–अः)",
        "text_en": "1. hour → \"our\" (Vowel)",
        "fill": "#065F46",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 294,
        "y": 20,
        "width": 240,
        "height": 78,
        "rx": 10,
        "fill": "#FEF3C7",
        "stroke": "#D97706",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 414,
        "y": 48,
        "text_hi": "2. university → \"यूनि...\" (य)",
        "text_en": "2. university → \"yoo\" (Cons.)",
        "fill": "#92400E",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "Sparkles",
      "label_hi": "a ... an",
      "label_en": "a ... an"
    },
    {
      "id": "c2",
      "icon": "Sparkles",
      "label_hi": "an ... an",
      "label_en": "an ... an"
    },
    {
      "id": "c3",
      "icon": "Sparkles",
      "label_hi": "an ... a",
      "label_en": "an ... a"
    },
    {
      "id": "c4",
      "icon": "Sparkles",
      "label_hi": "a ... a",
      "label_en": "a ... a"
    }
  ],
  "correct_choice_id": "c3"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (FOUNDATION, PRACTICE) — Hindi Vowel Sound Rule
  (
    '10000006-0003-4000-8000-000000000009', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Hindi Vowel Sound Rule', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    '`an MLA` और `a university` में ऐसा उल्टा क्यों होता है?',
    'Why do we write `an MLA` yet `a university`?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "MLA (M व्यंजन है) के आगे an और University (U स्वर है) के आगे a क्यों लगता है?",
  "front_en": "Why do we say \"an MLA\" yet \"a university\"?",
  "back_hi": "क्योंकि a/an स्पेलिंग नहीं, उच्चारण की पहली आवाज़ से तय होता है! MLA = \"एम\" (ए = स्वर → an), University = \"यूनिवर्सिटी\" (य = व्यंजन → a)।",
  "back_en": "Because a/an depends on the FIRST SPOKEN SOUND, not spelling! MLA starts with \"em\" (vowel → an), while university starts with \"yoo\" (consonant → a).",
  "mnemonic_hi": "ट्रिक: \"आँख से नहीं, कान से चुनें — अ–अः तो an!\"",
  "mnemonic_en": "Trick: \"Trust your ear, not your eye — vowel sound = an!\"",
  "pronunciation_hi": "ऐन एम-एल-ए · अ यूनिवर्सिटी"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (FOUNDATION, PRACTICE) — Time Triangle
  (
    '10000006-0003-4000-8000-000000000010', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Time Triangle', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2023',
    'समय के लिए `in`, `on` और `at` में क्या अंतर है?',
    'How do `in`, `on`, and `at` divide time?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "समय के लिए IN, ON और AT का उल्टा त्रिकोण नियम क्या है?",
  "front_en": "State the Inverted Pyramid rule for IN, ON, and AT in time.",
  "back_hi": "IN = बड़ा समय (महीना, साल, मौसम: in July, in 2026); ON = दिन व तारीख (on Monday, on 15 Aug); AT = घड़ी का ठीक समय व रात (at 7 AM, at night)।",
  "back_en": "IN = months/years/seasons (in July, in 2026); ON = days/dates (on Monday, on 15 Aug); AT = exact clock times & night (at 7 AM, at night).",
  "mnemonic_hi": "ट्रिक: \"बड़ा साल IN, एक दिन ON, ठीक घड़ी AT!\"",
  "mnemonic_en": "Trick: \"Big Year IN, Single Day ON, Exact Clock AT!\"",
  "pronunciation_hi": "इन जुलाई · ऑन मंडे · ऐट 7 एएम"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (BOARD, PRACTICE) — Top Fixed Prepositions
  (
    '10000006-0003-4000-8000-000000000011', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Top Fixed Prepositions', 'PRACTICE', 'FLASHCARD', 'BOARD', 'BSEB 2024',
    '`died`, `good`, और `senior` के साथ कौन-से पक्के प्रीपोज़िशन लगते हैं?',
    'Which fixed prepositions pair with `died` (disease), `good` (skill), and `senior`?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "BSEB के 3 सुपर-ट्रैप: died ___ fever, good ___ Maths, senior ___ me?",
  "front_en": "Top 3 BSEB traps: died ___ malaria, good ___ Maths, senior ___ me?",
  "back_hi": "died OF (बीमारी से मृत्यु), good AT (विषय/खेल में तेज़), senior TO (कभी than नहीं!)।",
  "back_en": "died OF (disease), good AT (subject/skill), senior TO (never `than`!).",
  "mnemonic_hi": "ट्रिक: \"बीमारी OF, विषय AT, सीनियर TO!\"",
  "mnemonic_en": "Trick: \"Disease OF, Skill AT, Senior/Junior/Prefer TO!\"",
  "pronunciation_hi": "डाइड ऑफ़ · गुड ऐट · सीनियर टू"
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (FOUNDATION, PRACTICE) — Article Sound Matching
  (
    '10000006-0003-4000-8000-000000000012', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Article Sound Matching', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'प्रत्येक संज्ञा को उसके सही Article (`a`, `an`, `the`, या `Zero Article`) से मिलाएँ:',
    'Match each noun phrase with its exact Article:',
    NULL, NULL,
    'आवाज़ सुनें (`hour`, `one-rupee`) और खास बनाम सामान्य (`Himalayas`, `cricket`) पहचानें!',
    'Test spoken sound (`hour`, `one-rupee`) and unique vs sports (`Himalayas`, `cricket`)!',
    'an hour (आवर), a one-rupee note (वन), the Himalayas (पर्वत श्रेणी), × cricket (खेल = Zero Article)।',
    'an hour (vowel sound), a one-rupee note ("w" sound), the Himalayas (mountain range), × cricket (sport = zero article).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "प्रत्येक शब्द को सही आर्टिकल से मिलाएँ",
  "instruction_en": "Match each phrase to its correct article",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "___ hour ago",
      "left_en": "___ hour ago",
      "right_hi": "an (स्वर ध्वनि \"आ\")",
      "right_en": "an (vowel sound)"
    },
    {
      "id": "p2",
      "left_hi": "___ one-rupee note",
      "left_en": "___ one-rupee note",
      "right_hi": "a (व्यंजन ध्वनि \"व\")",
      "right_en": "a (consonant \"w\" sound)"
    },
    {
      "id": "p3",
      "left_hi": "___ Himalayas",
      "left_en": "___ Himalayas",
      "right_hi": "the (पर्वत श्रेणी)",
      "right_en": "the (mountain range)"
    },
    {
      "id": "p4",
      "left_hi": "play ___ cricket",
      "left_en": "play ___ cricket",
      "right_hi": "कोई Article नहीं (×)",
      "right_en": "Zero Article (×)"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (BOARD, PRACTICE) — Fixed Prepositions Match
  (
    '10000006-0003-4000-8000-000000000013', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Fixed Prepositions Match', 'PRACTICE', 'MATCH_PAIRS', 'BOARD', 'BSEB 2024',
    'प्रत्येक शब्द को उसके पक्के (Fixed) प्रीपोज़िशन से मिलाएँ:',
    'Match each word with its exact Fixed Preposition:',
    NULL, NULL,
    'अक्सर बोर्ड परीक्षा में आने वाली 4 जोड़ियाँ हैं — ध्यान से मिलाएँ!',
    'These 4 exact pairs appear repeatedly in BSEB exams!',
    'afraid of, suffer from, listen to, और good at — चारों बिहार बोर्ड की पक्की जोड़ियाँ हैं।',
    'afraid of, suffer from, listen to, and good at are standard BSEB fixed pairs.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही Fixed Preposition जोड़ी मिलाएँ",
  "instruction_en": "Match each word with its fixed preposition",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "afraid (डरना)",
      "left_en": "afraid",
      "right_hi": "of (afraid of dogs)",
      "right_en": "of (afraid of dogs)"
    },
    {
      "id": "p2",
      "left_hi": "suffer (पीड़ित होना)",
      "left_en": "suffer",
      "right_hi": "from (suffer from fever)",
      "right_en": "from (suffer from fever)"
    },
    {
      "id": "p3",
      "left_hi": "listen (ध्यान से सुनना)",
      "left_en": "listen",
      "right_hi": "to (listen to me)",
      "right_en": "to (listen to me)"
    },
    {
      "id": "p4",
      "left_hi": "good (विषय में दक्ष)",
      "left_en": "good (at skill)",
      "right_hi": "at (good at Science)",
      "right_en": "at (good at Science)"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Article an hour
  (
    '10000006-0003-4000-8000-000000000014', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Article an hour', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2022',
    'सही Article चुनें: He will return in ___ hour.',
    'Choose the correct article: He will return in ___ hour.',
    $json$[{"key":"A","text_hi":"a","text_en":"a"},{"key":"B","text_hi":"an","text_en":"an"},{"key":"C","text_hi":"the","text_en":"the"},{"key":"D","text_hi":"No article","text_en":"No article"}]$json$::jsonb, 'B',
    '`hour` में `h` साइलेंट है — उच्चारण "आवर" होता है!',
    'The `h` in `hour` is silent — it sounds like "our"!',
    '`hour` की पहली ध्वनि हिंदी स्वर "आ" है, इसलिए **`an`** लगेगा।',
    '`hour` starts with a vowel sound ("our"), so it takes **`an`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Place Preposition on
  (
    '10000006-0003-4000-8000-000000000015', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Place Preposition on', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'सही Preposition चुनें: The book is lying ___ the table.',
    'Choose the correct preposition: The book is lying ___ the table.',
    $json$[{"key":"A","text_hi":"in","text_en":"in"},{"key":"B","text_hi":"between","text_en":"between"},{"key":"C","text_hi":"into","text_en":"into"},{"key":"D","text_hi":"on","text_en":"on"}]$json$::jsonb, 'D',
    'किताब मेज़ की ऊपरी सतह से सटकर रखी है!',
    'The book is resting directly on top of the surface!',
    'किसी सतह के ऊपर सटी स्थिति के लिए **`on`** लगता है।',
    'Resting directly touching a top surface takes **`on`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Time Preposition on day
  (
    '10000006-0003-4000-8000-000000000016', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Time Preposition on day', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'सही Preposition चुनें: Our school reopens ___ Monday.',
    'Choose the correct preposition: Our school reopens ___ Monday.',
    $json$[{"key":"A","text_hi":"on","text_en":"on"},{"key":"B","text_hi":"at","text_en":"at"},{"key":"C","text_hi":"in","text_en":"in"},{"key":"D","text_hi":"by","text_en":"by"}]$json$::jsonb, 'A',
    'समय त्रिकोण याद करें: दिन व तारीख के आगे क्या आता है?',
    'Check the Time Pyramid: what goes before days and dates?',
    'सप्ताह के दिनों (`Monday, Sunday`) और तारीखों से पहले हमेशा **`on`** लगता है।',
    'Days of the week (`Monday`) and exact dates always take **`on`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Article a university
  (
    '10000006-0003-4000-8000-000000000017', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Article a university', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'सही Article चुनें: She wants to study at ___ university in Bihar.',
    'Choose the correct article: She wants to study at ___ university in Bihar.',
    $json$[{"key":"A","text_hi":"a","text_en":"a"},{"key":"B","text_hi":"an","text_en":"an"},{"key":"C","text_hi":"the","text_en":"the"},{"key":"D","text_hi":"No article","text_en":"No article"}]$json$::jsonb, 'A',
    '`university` बोलकर देखें — पहली आवाज़ "य" (व्यंजन) है!',
    'Say `university` aloud — it starts with consonant "yoo"!',
    '`university` की पहली ध्वनि व्यंजन ("य") है, इसलिए **`a`** सही है (`an university` गलत है)।',
    '`university` starts with the consonant sound /j/ ("yoo"), so it takes **`a`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Article an MLA
  (
    '10000006-0003-4000-8000-000000000018', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Article an MLA', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'सही Article चुनें: His father is ___ SDO in Muzaffarpur.',
    'Choose the correct article: His father is ___ SDO in Muzaffarpur.',
    $json$[{"key":"A","text_hi":"a","text_en":"a"},{"key":"B","text_hi":"an","text_en":"an"},{"key":"C","text_hi":"the","text_en":"the"},{"key":"D","text_hi":"No article","text_en":"No article"}]$json$::jsonb, 'B',
    '`SDO` का पहला अक्षर `S` बोलने पर "एस" (ए = स्वर ध्वनि) निकलती है!',
    'Say `S` aloud: "es" begins with a vowel sound!',
    '`SDO` का उच्चारण "एस-डी-ओ" है (पहली ध्वनि "ए" = स्वर), इसलिए **`an SDO`** सही है।',
    '`SDO` begins with the vowel sound "es", so it strictly takes **`an`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Fixed Preposition died of
  (
    '10000006-0003-4000-8000-000000000019', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Fixed Preposition died of', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'सही Preposition चुनें: The old man died ___ cholera.',
    'Choose the correct preposition: The old man died ___ cholera.',
    $json$[{"key":"A","text_hi":"from","text_en":"from"},{"key":"B","text_hi":"by","text_en":"by"},{"key":"C","text_hi":"of","text_en":"of"},{"key":"D","text_hi":"with","text_en":"with"}]$json$::jsonb, 'C',
    'किसी बीमारी (disease) से मृत्यु होने पर कौन-सा पक्का प्रीपोज़िशन आता है?',
    'Which fixed preposition is used when someone dies from a disease?',
    'किसी रोग/बीमारी से मृत्यु होने पर हमेशा **`died of`** लगता है (`died from` नहीं)।',
    'Death caused by a disease ALWAYS uses **`died of`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — between vs among
  (
    '10000006-0003-4000-8000-000000000020', 'skill-eng-foundation', 'skill-eng-f-ch3', 'between vs among', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Model Paper',
    'सही Preposition चुनें: Distribute these notebooks ___ all the students.',
    'Choose the correct preposition: Distribute these notebooks ___ all the students.',
    $json$[{"key":"A","text_hi":"between","text_en":"between"},{"key":"B","text_hi":"at","text_en":"at"},{"key":"C","text_hi":"into","text_en":"into"},{"key":"D","text_hi":"among","text_en":"among"}]$json$::jsonb, 'D',
    '`all the students` दो से अधिक हैं!',
    '`all the students` means more than two!',
    'दो से अधिक लोगों के बीच बाँटने के लिए **`among`** लगता है (`between` केवल 2 के लिए)।',
    'For a group of more than two, always use **`among`** (`between` is for two).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Zero Article vs Specific
  (
    '10000006-0003-4000-8000-000000000021', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Zero Article vs Specific', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'सही विकल्प चुनें: ___ gold is a precious metal.',
    'Choose the correct article: ___ gold is a precious metal.',
    $json$[{"key":"A","text_hi":"A","text_en":"A"},{"key":"B","text_hi":"An","text_en":"An"},{"key":"C","text_hi":"The","text_en":"The"},{"key":"D","text_hi":"कोई Article नहीं (No article)","text_en":"No article"}]$json$::jsonb, 'D',
    'यहाँ सामान्य रूप से पूरे सोने (Material Noun) की बात हो रही है, किसी खास अंगूठी की नहीं!',
    'General material nouns (`gold, water, milk`) take what article?',
    'सामान्य अर्थ में पदार्थवाचक संज्ञा (`gold, silver, water`) से पहले **कोई Article नहीं** लगता।',
    'Material nouns used in a general sense take **Zero Article (No article)**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Fixed Preposition senior to
  (
    '10000006-0003-4000-8000-000000000022', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Fixed Preposition senior to', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    'सही Preposition चुनें: Ramesh is senior ___ me by two years.',
    'Choose the correct preposition: Ramesh is senior ___ me by two years.',
    $json$[{"key":"A","text_hi":"than","text_en":"than"},{"key":"B","text_hi":"from","text_en":"from"},{"key":"C","text_hi":"to","text_en":"to"},{"key":"D","text_hi":"with","text_en":"with"}]$json$::jsonb, 'C',
    '`senior, junior, superior, inferior, prefer` के साथ `than` कभी नहीं आता!',
    '`senior, junior, superior, prefer` NEVER take `than`!',
    'लैटिन तुलनात्मक शब्दों (`senior, junior, superior, inferior`) के साथ हमेशा **`to`** लगता है।',
    'Words like `senior, junior, superior, inferior` strictly take **`to`**, never `than`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, EXAM_ONLY) — Article a European
  (
    '10000006-0003-4000-8000-000000000023', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Article a European', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'सही Article चुनें: Mr. Smith is ___ European.',
    'Choose the correct article: Mr. Smith is ___ European.',
    $json$[{"key":"A","text_hi":"a","text_en":"a"},{"key":"B","text_hi":"an","text_en":"an"},{"key":"C","text_hi":"the","text_en":"the"},{"key":"D","text_hi":"No article","text_en":"No article"}]$json$::jsonb, 'A',
    '`European` की पहली आवाज़ "यू (य)" है!',
    'Listen to `European`: it starts with consonant sound "yoo"!',
    '`European` का उच्चारण "यूनिवर्सिटी" की तरह व्यंजन ध्वनि "य" से शुरू होता है, इसलिए **`a`** लगेगा।',
    '`European` starts with the consonant "yoo" sound, so it takes **`a`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, EXAM_ONLY) — Instrument with vs by
  (
    '10000006-0003-4000-8000-000000000024', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Instrument with vs by', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'सही Preposition चुनें: He wrote the letter ___ a blue pen.',
    'Choose the correct preposition: He wrote the letter ___ a blue pen.',
    $json$[{"key":"A","text_hi":"by","text_en":"by"},{"key":"B","text_hi":"with","text_en":"with"},{"key":"C","text_hi":"from","text_en":"from"},{"key":"D","text_hi":"on","text_en":"on"}]$json$::jsonb, 'B',
    'कलम (`a blue pen`) एक औज़ार (instrument) है!',
    '`a blue pen` is an instrument/tool used to write!',
    'औज़ार या उपकरण (`a pen, a knife, a stick`) के साथ हमेशा **`with`** लगता है (`by` नहीं)।',
    'Instruments/tools (`a pen, a knife`) always take **`with`** (not `by`).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, EXAM_ONLY) — Superlative Article + Musical Instrument
  (
    '10000006-0003-4000-8000-000000000025', 'skill-eng-foundation', 'skill-eng-f-ch3', 'Superlative Article + Musical Instrument', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'सही विकल्प चुनें: She plays ___ harmonium very well.',
    'Choose the correct article: She plays ___ harmonium very well.',
    $json$[{"key":"A","text_hi":"a","text_en":"a"},{"key":"B","text_hi":"an","text_en":"an"},{"key":"C","text_hi":"the","text_en":"the"},{"key":"D","text_hi":"No article","text_en":"No article"}]$json$::jsonb, 'C',
    'वाद्य यंत्र (Musical Instrument) बजाने के साथ कौन-सा Article आता है?',
    'Which article always precedes a musical instrument after `play`?',
    'संगीत वाद्य यंत्रों (`the harmonium, the tabla, the flute`) के नाम से पहले हमेशा **`the`** लगता है।',
    'Musical instruments played as an activity always take **`the`** (`play the harmonium`).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- SHORT_2M (BOARD, PRACTICE) — in vs into and between vs among
  (
    '10000006-0003-4000-8000-000000000026', 'skill-eng-foundation', 'skill-eng-f-ch3', 'in vs into and between vs among', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    '`in` बनाम `into` तथा `between` बनाम `among` का अंतर एक-एक उदाहरण सहित स्पष्ट करें।',
    'Differentiate between `in` vs `into` and `between` vs `among` with one example each.',
    NULL, NULL,
    'स्थिर बनाम गति (`in/into`) और 2 बनाम 3+ (`between/among`) स्पष्ट लिखें।',
    'State rest vs motion (`in/into`) and two vs 3+ (`between/among`) with crisp examples.',
    NULL,
    NULL,
    '1. **`in` बनाम `into`:** `in` अंदर की स्थिर अवस्था बताता है (*The water is **in** the glass.*), जबकि `into` बाहर से अंदर की ओर गति बताता है (*He jumped **into** the river.*)।
2. **`between` बनाम `among`:** `between` का प्रयोग ठीक **दो** के बीच होता है (*Divide it **between** Ram and Mohan.*), जबकि `among` का प्रयोग **दो से अधिक** के बीच होता है (*Distribute sweets **among** the children.*)।',
    '1. **`in` vs `into`:** `in` shows static rest inside (*The water is **in** the glass.*), whereas `into` shows motion entering from outside (*He jumped **into** the river.*).
2. **`between` vs `among`:** `between` is used for **two** items/people (*Divide it **between** Ram and Mohan.*), whereas `among` is used for **three or more** (*Distribute sweets **among** the children.*).',
    $json$[{"cue_hi":"in = अंदर स्थिर · into = बाहर से अंदर गति","cue_en":"in = static inside · into = motion inside"},{"cue_hi":"between = 2 · among = 3 या अधिक","cue_en":"between = 2 · among = 3+"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"in बनाम into का सटीक अंतर व उदाहरण","criterion_en":"Accurate distinction + examples for `in` vs `into`"},{"step_no":2,"marks":1,"criterion_hi":"between बनाम among का सटीक अंतर व उदाहरण","criterion_en":"Accurate distinction + examples for `between` vs `among`"}]$json$::jsonb,
    NULL,
    true
  ),
  -- LONG_5M (BOARD, PRACTICE) — BSEB 5M Articles & Prepositions Drill
  (
    '10000006-0003-4000-8000-000000000027', 'skill-eng-foundation', 'skill-eng-f-ch3', 'BSEB 5M Articles & Prepositions Drill', 'PRACTICE', 'LONG_5M', 'BOARD', 'BSEB 2024',
    'नीचे दिए गए 5 बोर्ड-स्तरीय रिक्त स्थानों को उपयुक्त Article या Preposition से भरें और कारण लिखें (5 अंक):
1. He is ___ honest officer, not ___ ordinary clerk.
2. ___ Ramayana is ___ sacred epic of India.
3. The train arrives ___ 6 AM ___ Monday.
4. She is proud ___ her school and good ___ English.
5. I found ___ one-rupee coin ___ the table.',
    'Fill in all 5 board-level pairs with the exact Article or Preposition and state the short reason (5 marks):
1. He is ___ honest officer, not ___ ordinary clerk.
2. ___ Ramayana is ___ sacred epic of India.
3. The train arrives ___ 6 AM ___ Monday.
4. She is proud ___ her school and good ___ English.
5. I found ___ one-rupee coin ___ the table.',
    NULL, NULL,
    'हर वाक्य में 2 रिक्त स्थान (0.5 + 0.5 = 1 अंक) हैं — ध्वनि नियम, समय त्रिकोण और Fixed Prepositions लगाएँ!',
    'Each sentence has 2 blanks (0.5 + 0.5 = 1 mark) — apply the sound rule, time pyramid, and fixed prepositions!',
    NULL,
    NULL,
    '1. **an, an** — *He is **an** honest officer, not **an** ordinary clerk.* *(दोनों में हिंदी स्वर ध्वनि "ऑ" है।)*
2. **The, a** — ***The** Ramayana is **a** sacred epic of India.* *(पवित्र ग्रंथ के आगे The; sacred व्यंजन ध्वनि "स" है।)*
3. **at, on** — *The train arrives **at** 6 AM **on** Monday.* *(घड़ी का ठीक समय = at; सप्ताह का दिन = on।)*
4. **of, at** — *She is proud **of** her school and good **at** English.* *(दोनों Fixed Prepositions हैं।)*
5. **a, on** — *I found **a** one-rupee coin **on** the table.* *(one की ध्वनि "व" = व्यंजन → a; मेज़ की सतह पर = on।)*',
    '1. **an, an** — *He is **an** honest officer, not **an** ordinary clerk.* *(Both begin with vowel sounds.)*
2. **The, a** — ***The** Ramayana is **a** sacred epic of India.* *(Holy book takes `The`; consonant sound `sacred` takes `a`.)*
3. **at, on** — *The train arrives **at** 6 AM **on** Monday.* *(Exact clock time = `at`; day of week = `on`.)*
4. **of, at** — *She is proud **of** her school and good **at** English.* *(Standard fixed prepositions.)*
5. **a, on** — *I found **a** one-rupee coin **on** the table.* *(Consonant "w" sound in `one` → `a`; top surface → `on`.)*',
    $json$[{"cue_hi":"honest / ordinary → an","cue_en":"honest / ordinary → an"},{"cue_hi":"पवित्र ग्रंथ → The","cue_en":"Holy epics → The"},{"cue_hi":"6 AM → at · Monday → on","cue_en":"6 AM → at · Monday → on"},{"cue_hi":"proud of · good at · a one-rupee coin","cue_en":"proud of · good at · a one-rupee coin"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"वाक्य 1 के दोनों सही उत्तर (an, an)","criterion_en":"Both blanks correct in #1 (an, an)"},{"step_no":2,"marks":1,"criterion_hi":"वाक्य 2 के दोनों सही उत्तर (The, a)","criterion_en":"Both blanks correct in #2 (The, a)"},{"step_no":3,"marks":1,"criterion_hi":"वाक्य 3 के दोनों सही उत्तर (at, on)","criterion_en":"Both blanks correct in #3 (at, on)"},{"step_no":4,"marks":1,"criterion_hi":"वाक्य 4 के दोनों सही उत्तर (of, at)","criterion_en":"Both blanks correct in #4 (of, at)"},{"step_no":5,"marks":1,"criterion_hi":"वाक्य 5 के दोनों सही उत्तर (a, on)","criterion_en":"Both blanks correct in #5 (a, on)"}]$json$::jsonb,
    NULL,
    true
  )
ON CONFLICT (id) DO UPDATE SET
  subject_id          = EXCLUDED.subject_id,
  chapter_id          = EXCLUDED.chapter_id,
  topic_tag           = EXCLUDED.topic_tag,
  bank_pool           = EXCLUDED.bank_pool,
  question_type       = EXCLUDED.question_type,
  difficulty_tier     = EXCLUDED.difficulty_tier,
  exam_year_tag       = EXCLUDED.exam_year_tag,
  q_hi                = EXCLUDED.q_hi,
  q_en                = EXCLUDED.q_en,
  options_json        = EXCLUDED.options_json,
  correct_option      = EXCLUDED.correct_option,
  clue_hi             = EXCLUDED.clue_hi,
  clue_en             = EXCLUDED.clue_en,
  explanation_hi      = EXCLUDED.explanation_hi,
  explanation_en      = EXCLUDED.explanation_en,
  model_answer_hi     = EXCLUDED.model_answer_hi,
  model_answer_en     = EXCLUDED.model_answer_en,
  memory_cues_json    = EXCLUDED.memory_cues_json,
  marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json   = EXCLUDED.visual_asset_json,
  is_published        = EXCLUDED.is_published;

-- #############################################################################
-- UNIT 4 OF 5: skill-eng-f-ch4 — ACTIVE–PASSIVE VOICE, NARRATION & MODALS (BSEB HIGH-SCORE GRAMMAR)
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-eng-f-ch4',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: Voice + Narration + Modals (15+ पक्के अंक)",
  "title_en": "30-Second Mindmap: Voice, Narration & Modals (15+ BSEB Marks)",
  "read_time_seconds": 30,
  "central_node": {
    "id": "u4-root",
    "label_hi": "15+ पक्के अंक: Voice · Narration · Modals",
    "label_en": "15+ Guaranteed Marks: Voice · Narration · Modals",
    "subtitle_hi": "Passive = हमेशा V3 · Narration = 1 कदम पीछे (Backshift) · Modal = हमेशा V1!",
    "subtitle_en": "Passive = Always V3 · Narration = 1 Step Back · Modal = Always V1!"
  },
  "branches": [
    {
      "id": "u4-b1",
      "label_hi": "1. Active – Passive (3-कदम X-क्रॉस)",
      "label_en": "1. Active – Passive (3-Step X-Swap)",
      "color": "#1E3A8A",
      "formula_latex": "\\text{Object} + \\text{be / being / been} + V_3 + \\text{by} + \\text{Agent}",
      "children": [
        {
          "id": "u4-b1-c1",
          "label_hi": "कदम 1: Object को आगे लाएँ · कदम 2: Helper + V3 · कदम 3: by + Subject",
          "label_en": "Step 1: Front Object · Step 2: Helper + V3 · Step 3: by + Subject"
        },
        {
          "id": "u4-b1-c2",
          "label_hi": "आदेश वाक्य (Open the door) → Let the door be opened.",
          "label_en": "Imperative (Open the door) → Let the door be opened."
        }
      ]
    },
    {
      "id": "u4-b2",
      "label_hi": "2. Narration (Direct → Indirect)",
      "label_en": "2. Narration (Direct → Indirect Speech)",
      "color": "#059669",
      "children": [
        {
          "id": "u4-b2-c1",
          "label_hi": "said to → told (told के बाद to कभी नहीं!) · जोड़ने को that / if",
          "label_en": "said to → told (NEVER \"told to\"!) · Join with that / if"
        },
        {
          "id": "u4-b2-c2",
          "label_hi": "Present → Past (is→was, V1→V2, will→would) · Universal Truth न बदलें!",
          "label_en": "Backshift (is→was, V1→V2, will→would) · Keep Universal Truth unchanged!"
        }
      ]
    },
    {
      "id": "u4-b3",
      "label_hi": "3. Pronoun बदलने का SON / 123 नियम",
      "label_en": "3. SON / 123 Pronoun Shift Rule",
      "color": "#D97706",
      "children": [
        {
          "id": "u4-b3-c1",
          "label_hi": "1st (I, We) → Subject · 2nd (You) → Object · 3rd (He/She/They) → No Change",
          "label_en": "1st (I, We) → Subject · 2nd (You) → Object · 3rd (He/She/They) → No Change"
        }
      ]
    },
    {
      "id": "u4-b4",
      "label_hi": "4. Modals (हमेशा शुद्ध V1 के साथ!)",
      "label_en": "4. Modals (ALWAYS + Base V1!)",
      "color": "#7C3AED",
      "formula_latex": "\\text{Modal (can/may/must/should)} + V_1",
      "children": [
        {
          "id": "u4-b4-c1",
          "label_hi": "can (क्षमता) · may (अनुमति/आशीर्वाद) · should (सलाह) · must (अनिवार्य कर्तव्य)",
          "label_en": "can (ability) · may (permission/wish) · should (advice) · must (duty)"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "u4-sec-1-voice-x-swap",
    "order": 1,
    "heading_hi": "1. Active से Passive Voice — बस 3 कदम और \"X-क्रॉस\" चित्र विधि!",
    "heading_en": "1. Active to Passive Voice — The 3-Step Visual \"X-Swap\" Method!",
    "analogy_hi": "मान लीजिए क्रिकेट में पारी बदल रही है! **Active Voice** में काम करने वाला (Subject) सामने खड़ा है: *\"Ram eats a mango.\"* **Passive Voice** में हम कर्म (Object) को सामने ले आते हैं: *\"A mango is eaten by Ram.\"* बस 1 नियम गाँठ बाँध लीजिए — **Passive Voice के हर वाक्य में मुख्य क्रिया हमेशा `V3` (तीसरा रूप — eaten, written, played) पहनकर आती है!**",
    "analogy_en": "Picture swapping ends in cricket! In **Active Voice**, the doer bats first: *\"Ram eats a mango.\"* In **Passive Voice**, the receiver (Object) steps to the front: *\"A mango is eaten by Ram.\"* Memorize ONE unbreakable law: **Every Passive Voice sentence ALWAYS uses `V3` (eaten, written, played)!**",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "Active → Passive का \"X-क्रॉस\" रूपांतरण चित्र",
      "title_en": "Active → Passive Visual \"X-Swap\" Diagram",
      "caption_hi": "Object (a mango) तिरछा चलकर नया Subject बन जाता है, Verb (eats) नीचे उतरकर Helper + V3 (is eaten) बन जाता है, और Subject (Ram) अंत में \"by Ram\" बन जाता है!",
      "caption_en": "Object (a mango) crosses to become the new Subject, Verb (eats) drops straight into Helper + V3 (is eaten), and Subject (Ram) crosses to \"by Ram\"!",
      "viewBox": "0 0 680 265",
      "elements": [
        {
          "kind": "label",
          "x": 26,
          "y": 24,
          "text_hi": "ACTIVE VOICE:",
          "text_en": "ACTIVE VOICE:",
          "fill": "#475569",
          "fontSize": 12,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 26,
          "y": 36,
          "width": 170,
          "height": 60,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 111,
          "y": 60,
          "text_hi": "Ram (Subject)",
          "text_en": "Ram (Subject)",
          "fill": "#1E3A8A",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 255,
          "y": 36,
          "width": 170,
          "height": 60,
          "rx": 10,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 340,
          "y": 60,
          "text_hi": "eats (V1+s)",
          "text_en": "eats (V1+s)",
          "fill": "#B45309",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 484,
          "y": 36,
          "width": 170,
          "height": 60,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 569,
          "y": 60,
          "text_hi": "a mango (Object)",
          "text_en": "a mango (Object)",
          "fill": "#059669",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 550,
          "y1": 98,
          "x2": 130,
          "y2": 172,
          "stroke": "#059669",
          "strokeWidth": 2.8
        },
        {
          "kind": "arrow",
          "x1": 340,
          "y1": 98,
          "x2": 340,
          "y2": 172,
          "stroke": "#D97706",
          "strokeWidth": 2.8
        },
        {
          "kind": "arrow",
          "x1": 130,
          "y1": 98,
          "x2": 550,
          "y2": 172,
          "stroke": "#1E3A8A",
          "strokeWidth": 2.5,
          "dashed": true
        },
        {
          "kind": "rect",
          "x": 235,
          "y": 116,
          "width": 210,
          "height": 34,
          "rx": 14,
          "fill": "#FFFFFF",
          "stroke": "#DC2626",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 340,
          "y": 137,
          "text_hi": "स्वर्ण नियम: Passive = हमेशा V3!",
          "text_en": "Golden Rule: Always V3!",
          "fill": "#DC2626",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 26,
          "y": 170,
          "text_hi": "PASSIVE VOICE:",
          "text_en": "PASSIVE VOICE:",
          "fill": "#0F172A",
          "fontSize": 12,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 26,
          "y": 180,
          "width": 175,
          "height": 64,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 113,
          "y": 206,
          "text_hi": "A mango (New S)",
          "text_en": "A mango (New S)",
          "fill": "#059669",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 248,
          "y": 180,
          "width": 184,
          "height": 64,
          "rx": 10,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 340,
          "y": 206,
          "text_hi": "is eaten (be + V3)",
          "text_en": "is eaten (be + V3)",
          "fill": "#B45309",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 478,
          "y": 180,
          "width": 176,
          "height": 64,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 566,
          "y": 206,
          "text_hi": "by Ram (by + Agent)",
          "text_en": "by Ram (by + Agent)",
          "fill": "#1E3A8A",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### Pronoun परिवर्तन (Passive में `by` के बाद कैसे बदलता है)\n- **I → by me** · **We → by us** · **You → by you** · **He → by him** · **She → by her** · **They → by them**\n- उदाहरण: *She writes a letter.* → **A letter is written by her.** *(अ लेटर इज़ रिटन बाई हर।)*\n\n### आदेश वाक्य (Imperative Sentence) का 2-सेकंड Passive!\nजब वाक्य सीधे क्रिया से शुरू हो (*Open the door*, *Help the poor*):\n- सूत्र: **`Let + Object + be + V3`**\n- *Open the door.* → **Let the door be opened.**\n- *Post this letter.* → **Let this letter be posted.**",
    "concept_md_en": "### Pronoun Shifts After `by` in Passive Voice\n- **I → by me** · **We → by us** · **You → by you** · **He → by him** · **She → by her** · **They → by them**\n- Example: *She writes a letter.* → **A letter is written by her.**\n\n### 2-Second Passive for Imperative (Command) Sentences!\nWhen a sentence starts directly with a verb (*Open the door*, *Post this letter*):\n- Formula: **`Let + Object + be + V3`**\n- *Open the door.* → **Let the door be opened.**\n- *Post this letter.* → **Let this letter be posted.**",
    "exam_tip_hi": "BSEB का 1-सेकंड एलिमिनेशन हैक: Passive MCQ के 4 विकल्पों में पहले देखो किनमें **V3** नहीं है या **Continuous में `being`** छूट गया है — 2–3 गलत विकल्प तुरंत कट जाएँगे!",
    "exam_tip_en": "1-Second BSEB Elimination Hack: Check if the option has **V3** (and **`being`** for `-ing` tenses, **`been`** for `has/have/had`). You can eliminate 2–3 wrong choices instantly!",
    "glossary_terms": [
      {
        "term_hi": "कर्तृवाच्य (Active Voice)",
        "term_en": "Active Voice",
        "pronunciation_hi": "ऐक्टिव वॉइस",
        "definition_hi": "जिस वाक्य में कर्ता (Subject) मुख्य हो और काम खुद करे। जैसे: Ravi plays cricket.",
        "definition_en": "Sentence where the subject performs the action directly, e.g., Ravi plays cricket."
      },
      {
        "term_hi": "कर्मवाच्य (Passive Voice)",
        "term_en": "Passive Voice",
        "pronunciation_hi": "पैसिव वॉइस",
        "definition_hi": "जिस वाक्य में कर्म (Object) आगे आ जाए और क्रिया be + V3 हो। जैसे: Cricket is played by Ravi.",
        "definition_en": "Sentence where the object takes subject position and the verb becomes be + V3."
      }
    ],
    "quick_check": {
      "q_hi": "Passive Voice में बदलें: \"He wrote a poem.\"",
      "q_en": "Convert to Passive Voice: \"He wrote a poem.\"",
      "answer_hi": "**A poem was written by him.** (`wrote` = V2, इसलिए `was + V3` और `He → by him`!)",
      "answer_en": "**A poem was written by him.** (`wrote` is Simple Past, so `was + written` + `by him`!)"
    }
  },
  {
    "id": "u4-sec-2-passive-table",
    "order": 2,
    "heading_hi": "2. Passive Voice की सुपर-चीट तालिका (1 नज़र = सभी 8 Tense + Modals!)",
    "heading_en": "2. Master Passive Helper Cheat Table (All 8 Tenses + Modals in 1 Glance!)",
    "analogy_hi": "बस Active वाक्य की क्रिया को ट्रैफ़िक सिग्नल की तरह देखिए: `-ing` दिखा → **`being`** जोड़ो; `has/have/had` दिखा → **`been`** जोड़ो; `will/can/must` (Modal) दिखा → **`be`** जोड़ो; और हर जगह अंत में **`V3`**!",
    "analogy_en": "Read the Active verb like a traffic sign: see **`-ing`** → insert **`being`**; see **`has/have/had`** → insert **`been`**; see **`will/can/must`** → insert **`be`**; and finish with **`V3`** every time!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "Active से Passive बदलने की पूर्ण चीट तालिका",
      "title_en": "Complete Active-to-Passive Conversion Cheat Table",
      "caption_hi": "ध्यान दें: Present/Past/Future Perfect Continuous और Future Continuous का Passive सामान्यतः नहीं बनता।",
      "caption_en": "Note: Perfect Continuous tenses and Future Continuous are not normally converted into Passive Voice.",
      "headers_hi": [
        "Active में क्या दिखे?",
        "Passive में क्या लगाएँ?",
        "उदाहरण (Active → Passive)"
      ],
      "headers_en": [
        "Active Verb Form",
        "Passive Formula",
        "Example (Active → Passive)"
      ],
      "rows": [
        {
          "cells_hi": [
            "V1 / V1+s/es (Simple Present)",
            "is / am / are + V3",
            "He helps me. → I am helped by him."
          ],
          "cells_en": [
            "V1 / V1+s/es (Simple Present)",
            "is / am / are + V3",
            "He helps me. → I am helped by him."
          ]
        },
        {
          "cells_hi": [
            "V2 (Simple Past)",
            "was / were + V3",
            "She sang a song. → A song was sung by her."
          ],
          "cells_en": [
            "V2 (Simple Past)",
            "was / were + V3",
            "She sang a song. → A song was sung by her."
          ]
        },
        {
          "cells_hi": [
            "is/am/are + V-ing",
            "is/am/are + being + V3",
            "They are reading a book. → A book is being read by them."
          ],
          "cells_en": [
            "is/am/are + V-ing",
            "is/am/are + being + V3",
            "They are reading a book. → A book is being read by them."
          ]
        },
        {
          "cells_hi": [
            "was/were + V-ing",
            "was/were + being + V3",
            "He was flying a kite. → A kite was being flown by him."
          ],
          "cells_en": [
            "was/were + V-ing",
            "was/were + being + V3",
            "He was flying a kite. → A kite was being flown by him."
          ]
        },
        {
          "cells_hi": [
            "has / have / had + V3",
            "has/have/had + been + V3",
            "I have done the work. → The work has been done by me."
          ],
          "cells_en": [
            "has / have / had + V3",
            "has/have/had + been + V3",
            "I have done the work. → The work has been done by me."
          ]
        },
        {
          "cells_hi": [
            "will / can / must / should + V1",
            "Modal + be + V3",
            "She can win the prize. → The prize can be won by her."
          ],
          "cells_en": [
            "will / can / must / should + V1",
            "Modal + be + V3",
            "She can win the prize. → The prize can be won by her."
          ]
        }
      ]
    },
    "concept_md_hi": "### BSEB के 2 स्पेशल Passive नियम (सीधे टॉपर्स अंक!)\n1. **प्रश्नवाचक वाक्य (`Who ...?`):** `Who` हमेशा **`By whom`** में बदलता है!\n   - *Who wrote the Ramayana?* → **By whom was the Ramayana written?**\n2. **`know` के साथ `by` नहीं, `to` लगता है!** (बिहार बोर्ड का प्रसिद्ध सवाल!)\n   - *I know him.* → **He is known to me.** *(न कि `by me`!)*",
    "concept_md_en": "### 2 Special Topper BSEB Passive Rules!\n1. **`Who ...?` Questions:** `Who` converts to **`By whom`**!\n   - *Who wrote the Ramayana?* → **By whom was the Ramayana written?**\n2. **`know` takes `to`, NOT `by`!** (Classic BSEB PYQ!)\n   - *I know him.* → **He is known to me.** *(NEVER `by me`!)*",
    "exam_tip_hi": "हमेशा याद रखें: **\"I know him\" का Passive = \"He is known to me\"** (`known to`, न कि `known by`) — यह सवाल बिहार बोर्ड में कई बार आ चुका है!",
    "exam_tip_en": "Remember this BSEB gem: **\"I know him\" → \"He is known to me\"** (`known to`, never `known by`)!",
    "glossary_terms": [
      {
        "term_hi": "आदेशवाचक वाक्य (Imperative Sentence)",
        "term_en": "Imperative Sentence",
        "pronunciation_hi": "इम्परेटिव सेंटेंस",
        "definition_hi": "आदेश, अनुरोध या सलाह देने वाला वाक्य (Open the door, Please sit down)।",
        "definition_en": "A sentence giving a command, request, or advice (Open the door, Please help him)."
      }
    ],
    "quick_check": {
      "q_hi": "सही Passive चुनें: \"She is cooking food.\" → \"Food ___ cooked by her.\"",
      "q_en": "Complete the Passive: \"She is cooking food.\" → \"Food ___ cooked by her.\"",
      "answer_hi": "**is being** — क्योंकि Active में `-ing` (Continuous) है, इसलिए `is being + V3` लगेगा!",
      "answer_en": "**is being** — Continuous `-ing` always adds **`being`** before V3!"
    }
  },
  {
    "id": "u4-sec-3-narration",
    "order": 3,
    "heading_hi": "3. Narration (Direct → Indirect Speech): किसी की बात को रिपोर्ट करना!",
    "heading_en": "3. Narration (Direct → Indirect Speech): Reporting Someone's Words!",
    "analogy_hi": "सोचिए आपके दोस्त रवि ने आपसे कहा — *\"मैं बीमार हूँ (I am ill).\"* अब आप टीचर के पास जाकर वह बात बताते हैं — *\"रवि ने कहा कि वह बीमार था (Ravi said that he was ill).\"* बस यही **Indirect Speech (Narration)** है! जब रिपोर्टिंग वर्ब भूतकाल (`said`) में हो, तो अंदर के वाक्य का समय **1 कदम पीछे (Backshift)** चला जाता है!",
    "analogy_en": "Suppose Ravi tells you: *\"I am ill.\"* You walk to your teacher and report it: *\"Ravi said that he was ill.\"* That is **Indirect Speech**! Whenever the reporting verb is past (`said`), the quoted tense shifts **1 step back into the past (Backshift)**!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "Narration बैकशिफ्ट तालिका (जब Reporting Verb \"said\" हो)",
      "title_en": "Master Narration Backshift Cheat Sheet (When Reporting Verb Is \"said\")",
      "caption_hi": "ध्यान दें: यदि बाहर `says` या `will say` हो, या अंदर कोई सार्वभौमिक सत्य (Universal Truth) हो, तो अंदर का Tense कभी नहीं बदलता!",
      "caption_en": "Crucial Exception: If outside is `says / will say`, OR inside is a Universal Truth, NEVER change the tense!",
      "headers_hi": [
        "Direct Speech में (\"...\")",
        "Indirect Speech में",
        "उदाहरण परिवर्तन"
      ],
      "headers_en": [
        "In Direct Speech (\"...\")",
        "In Indirect Speech",
        "Example Conversion"
      ],
      "rows": [
        {
          "cells_hi": [
            "said to + Object",
            "told + Object (to हट जाएगा!)",
            "He said to me → He told me"
          ],
          "cells_en": [
            "said to + Object",
            "told + Object (drop \"to\"!)",
            "He said to me → He told me"
          ]
        },
        {
          "cells_hi": [
            "is / am / are · V1 / V1+s",
            "was / were · V2",
            "\"I am busy\" → that he was busy"
          ],
          "cells_en": [
            "is / am / are · V1 / V1+s",
            "was / were · V2",
            "\"I am busy\" → that he was busy"
          ]
        },
        {
          "cells_hi": [
            "has / have · V2 (Simple Past)",
            "had · had + V3",
            "\"I went\" → that he had gone"
          ],
          "cells_en": [
            "has / have · V2 (Simple Past)",
            "had · had + V3",
            "\"I went\" → that he had gone"
          ]
        },
        {
          "cells_hi": [
            "will · can · may",
            "would · could · might",
            "\"I will help\" → that he would help"
          ],
          "cells_en": [
            "will · can · may",
            "would · could · might",
            "\"I will help\" → that he would help"
          ]
        },
        {
          "cells_hi": [
            "today · tomorrow · yesterday · now",
            "that day · the next day · the previous day · then",
            "\"today\" → that day · \"here\" → there"
          ],
          "cells_en": [
            "today · tomorrow · yesterday · now",
            "that day · the next day · the previous day · then",
            "\"today\" → that day · \"here\" → there"
          ]
        },
        {
          "cells_hi": [
            "Yes/No प्रश्न (\"Are you...?\")",
            "asked + if / whether (सीधा वाक्य, ? हटेगा)",
            "He said to me, \"Are you ready?\" → He asked me if I was ready."
          ],
          "cells_en": [
            "Yes/No Question (\"Are you...?\")",
            "asked + if / whether (statement order, no ?)",
            "He asked me if I was ready."
          ]
        }
      ]
    },
    "concept_md_hi": "### Pronoun बदलने का सुपर-आसान **SON / 123** फॉर्मूला\n- **1st Person (`I, me, my, we, our`)** → बाहर के **S (Subject)** के अनुसार बदलें!\n- **2nd Person (`You, your`)** → बाहर के **O (Object)** के अनुसार बदलें!\n- **3rd Person (`He, She, It, They`)** → **N (No Change — कोई बदलाव नहीं!)**\n\n### सार्वभौमिक सत्य अपवाद (BSEB का पसंदीदा!)\n- Direct: *The teacher said, \"The earth moves round the sun.\"*\n- Indirect: **The teacher said that the earth moves round the sun.** *(यहाँ `moves` को `moved` बिलकुल नहीं बनाएँगे क्योंकि यह आज भी सच है!)*",
    "concept_md_en": "### The Easy **SON / 123** Pronoun Formula\n- **1st Person (`I, me, my, we, our`)** → changes according to **S (Subject)** outside.\n- **2nd Person (`You, your`)** → changes according to **O (Object)** outside.\n- **3rd Person (`He, She, It, They`)** → **N (No Change!)**\n\n### Universal Truth Exception (BSEB Favourite!)\n- Direct: *The teacher said, \"The earth moves round the sun.\"*\n- Indirect: **The teacher said that the earth moves round the sun.** *(Keep `moves` in Present Tense — universal facts never backshift!)*",
    "exam_tip_hi": "Indirect प्रश्नवाचक वाक्य में दो बातें ज़रूर जाँचें: (1) `that` नहीं, **`if/whether`** या वही `wh-word` लगेगा; (2) अंत में `?` हटकर **`.` (Full Stop)** लगेगा और कर्ता क्रिया से पहले आएगा (*if I was ready*, न कि *if was I ready*)!",
    "exam_tip_en": "In Indirect Questions, check 2 things: (1) Use **`if/whether`** (never `that if`!), and (2) switch to statement order ending with a full stop (`if I was ready`, NOT `if was I ready?`)!",
    "glossary_terms": [
      {
        "term_hi": "प्रत्यक्ष कथन (Direct Speech)",
        "term_en": "Direct Speech",
        "pronunciation_hi": "डायरेक्ट स्पीच",
        "definition_hi": "वक्ता के ठीक उन्हीं शब्दों को उद्धरण चिह्न (\"...\") के अंदर लिखना।",
        "definition_en": "Quoting the exact words of the speaker inside quotation marks (\"...\")."
      },
      {
        "term_hi": "अप्रत्यक्ष कथन (Indirect Speech)",
        "term_en": "Indirect Speech",
        "pronunciation_hi": "इनडायरेक्ट स्पीच",
        "definition_hi": "उद्धरण चिह्न हटाकर किसी की बात को अपने शब्दों में that/if लगाकर रिपोर्ट करना।",
        "definition_en": "Reporting what someone said without quotation marks using that/if and tense backshift."
      }
    ],
    "quick_check": {
      "q_hi": "Indirect Speech में बदलें: He said to me, \"I am happy today.\"",
      "q_en": "Change to Indirect Speech: He said to me, \"I am happy today.\"",
      "answer_hi": "**He told me that he was happy that day.** (`said to → told`, `I → he`, `am → was`, `today → that day`!)",
      "answer_en": "**He told me that he was happy that day.** (`said to → told`, `I → he`, `am → was`, `today → that day`!)"
    }
  },
  {
    "id": "u4-sec-4-modals",
    "order": 4,
    "heading_hi": "4. Modals (can, could, may, might, must, should) — व्यवहार के 6 जादुई शब्द!",
    "heading_en": "4. Modals (can, could, may, might, must, should) — 6 Power Words!",
    "analogy_hi": "क्लास में घुसने से पहले आप सर से क्या पूछते हैं? **\"May I come in, Sir?\"** (विनम्र अनुमति)। दोस्त से अपनी ताकत बताते समय: **\"I can solve this sum!\"** (क्षमता)। बड़े भाई की सलाह: **\"You should study daily.\"** (सलाह)। और सड़क के नियम: **\"We must obey traffic rules.\"** (अनिवार्य कर्तव्य)। बस यही Modals हैं — और सबसे अच्छी बात: **हर Modal के बाद हमेशा शुद्ध `V1` आता है!**",
    "analogy_en": "At the classroom door you ask politely: **\"May I come in, Sir?\"** Showing ability: **\"I can solve this sum!\"** Giving friendly advice: **\"You should study daily.\"** Strict duty: **\"We must obey traffic rules.\"** Best part: **EVERY Modal is ALWAYS followed by pure base `V1`!**",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "सही Modal चुनने का 1-सेकंड निर्णय पथ",
      "title_en": "1-Second Modal Choice Decision Map",
      "caption_hi": "अटल नियम: Modal + V1 (कभी to, s/es, ed या ing सीधे Modal के बाद न लगाएँ — जैसे \"She can swim\", न कि \"She can swims\")!",
      "caption_en": "Unbreakable Rule: Modal + pure V1 (NEVER add to, s/es, or ed right after a modal — say \"She can swim\", NOT \"She can swims\")!",
      "direction": "TB",
      "steps": [
        {
          "id": "m-can",
          "label_hi": "CAN / COULD — योग्यता, क्षमता और भूतकाल की ताकत",
          "label_en": "CAN / COULD — Ability, Power & Polite Request",
          "detail_hi": "I can swim. (मैं तैर सकता हूँ) | Could you please help me? (विनम्र अनुरोध)",
          "detail_en": "I can swim. (Present ability) | Could you please help me? (Very polite request)",
          "accent": "indigo"
        },
        {
          "id": "m-may",
          "label_hi": "MAY / MIGHT — अनुमति, संभावना और आशीर्वाद (Blessing)",
          "label_en": "MAY / MIGHT — Formal Permission, Possibility & Blessings",
          "detail_hi": "May I come in, Sir? | May God bless you! | It may rain today. (might = कम संभावना)",
          "detail_en": "May I come in, Sir? | May God bless you! | It may rain today. (might = weak possibility)",
          "accent": "emerald"
        },
        {
          "id": "m-should",
          "label_hi": "SHOULD / OUGHT TO — अच्छी सलाह और नैतिक कर्तव्य",
          "label_en": "SHOULD / OUGHT TO — Advice & Moral Duty",
          "detail_hi": "You should respect your parents. | We ought to help the poor. (ध्यान दें: ought के साथ to आता है!)",
          "detail_en": "You should respect your parents. | We ought to help the poor. (Note: ought takes \"to\"!)",
          "accent": "amber"
        },
        {
          "id": "m-must",
          "label_hi": "MUST — अनिवार्य नियम, पक्की ज़रूरत और सख्त कर्तव्य",
          "label_en": "MUST — Strong Obligation, Law & Necessity",
          "detail_hi": "We must obey traffic rules. | You must take your medicine on time.",
          "detail_en": "We must obey traffic rules. | You must work hard to top the board.",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "m-can",
          "to": "m-may",
          "label_hi": "अनुमति / दुआ?",
          "label_en": "Permission / Wish?"
        },
        {
          "from": "m-may",
          "to": "m-should",
          "label_hi": "सलाह / कर्तव्य?",
          "label_en": "Advice / Moral?"
        },
        {
          "from": "m-should",
          "to": "m-must",
          "label_hi": "अति आवश्यक नियम?",
          "label_en": "Strict Rule?"
        }
      ]
    },
    "concept_md_hi": "### BSEB परीक्षा में Modals के 3 पक्के संकेत!\n1. **वाक्य के अंत में `!` (आशीर्वाद/प्रार्थना):** `\"___ God bless you!\"` / `\"___ you live long!\"` → आँख बंद करके **`May`** चुनें!\n2. **वाक्य में `lest` (कहीं ऐसा न हो कि):** `\"Walk carefully lest you ___ fall.\"` → `lest` के साथ हमेशा **`should`** लगता है! (बिहार बोर्ड का प्रसिद्ध सवाल!)\n3. **वाक्य में `to` पहले से दिया हो:** `\"We ___ to respect our elders.\"` → जब खाली जगह के बाद `to` लिखा हो, तो **`ought`** या **`used`** चुनें (`should to` और `must to` गलत हैं!)।",
    "concept_md_en": "### 3 Instant BSEB Modal Clue Hacks!\n1. **Blessings/Wishes ending with `!`:** `\"___ God bless you!\"` / `\"___ you live long!\"` → ALWAYS **`May`**!\n2. **The word `lest`:** `\"Walk carefully lest you ___ fall.\"` → `lest` ALWAYS pairs with **`should`** (favourite BSEB PYQ!).\n3. **`to` already printed after the blank:** `\"We ___ to respect our elders.\"` → Pick **`ought`** (NEVER `should to` or `must to`!).",
    "exam_tip_hi": "याद रखें: `\"___ I come in, Sir?\"` में `Can` से बेहतर और बोर्ड-मान्य उत्तर हमेशा **`May`** है। और `lest` के बाद हमेशा **`should`**!",
    "exam_tip_en": "For classroom permission (`\"___ I come in, Sir?\"`), always pick **`May`** over `Can`. And after `lest`, ALWAYS choose **`should`**!",
    "glossary_terms": [
      {
        "term_hi": "मॉडल क्रिया (Modal Verb)",
        "term_en": "Modal Verb",
        "pronunciation_hi": "मॉडल वर्ब",
        "definition_hi": "वे सहायक क्रियाएँ जो क्षमता, अनुमति, सलाह या अनिवार्यता बताती हैं (can, could, may, might, should, must) और हमेशा V1 लेती हैं।",
        "definition_en": "Auxiliary verbs expressing ability, permission, advice, or necessity (can, could, may, might, should, must) followed by base V1."
      }
    ],
    "quick_check": {
      "q_hi": "सही Modal चुनें: \"Work hard lest you ___ fail.\" (may / should / can / must)",
      "q_en": "Choose the exact modal: \"Work hard lest you ___ fail.\" (may / should / can / must)",
      "answer_hi": "**should** — क्योंकि `lest` के साथ हमेशा `should` आता है!",
      "answer_en": "**should** — because `lest` ALWAYS pairs with `should`!"
    }
  },
  {
    "id": "u4-sec-5-formula-card",
    "order": 5,
    "heading_hi": "5. 15-अंक व्याकरण मास्टर सूत्र कार्ड (Voice · Narration · Modals)",
    "heading_en": "5. 15-Mark Grammar Master Formula Card (Voice · Narration · Modals)",
    "analogy_hi": "परीक्षा कक्ष में जाने से पहले बस इन 6 सूत्रों पर एक नज़र डालें — Voice, Narration और Modals के सारे प्रश्न चुटकियों में हल हो जाएँगे!",
    "analogy_en": "Review these 6 high-yield formulas right before the exam — Voice, Narration, and Modals become guaranteed marks!",
    "visual_diagram": {
      "type": "FORMULA_CARD",
      "title_hi": "इकाई 4 के 6 सुपर-स्कोरिंग व्याकरण सूत्र",
      "title_en": "6 High-Score Grammar Formulas of Unit 4",
      "formulas": [
        {
          "latex": "\\text{Passive} = \\text{New Sub} + \\text{be / being / been} + V_3 + \\text{by Agent}",
          "meaning_hi": "साधारण Passive Voice सूत्र (हमेशा V3)",
          "meaning_en": "Core Passive Voice Formula (Always V3)",
          "example_hi": "A letter is written by her.",
          "example_en": "A letter is written by her."
        },
        {
          "latex": "\\text{Imperative Passive} = \\text{Let} + \\text{Object} + \\text{be} + V_3",
          "meaning_hi": "आदेश वाक्य का Passive सूत्र",
          "meaning_en": "Imperative Passive Formula",
          "example_hi": "Open the door. → Let the door be opened.",
          "example_en": "Open the door. → Let the door be opened."
        },
        {
          "latex": "\\text{said to} \\rightarrow \\text{told} \\quad(\\text{NO } \\text{\"to\"})",
          "meaning_hi": "Narration में said to बदलकर told बनता है",
          "meaning_en": "In Indirect Speech, said to becomes told (no \"to\")",
          "example_hi": "He told me that he was ready.",
          "example_en": "He told me that he was ready."
        },
        {
          "latex": "1\\text{st} \\rightarrow S,\\quad 2\\text{nd} \\rightarrow O,\\quad 3\\text{rd} \\rightarrow N",
          "meaning_hi": "Narration Pronoun बदलने का SON/123 नियम",
          "meaning_en": "SON/123 Rule for Narration Pronouns",
          "example_hi": "I/We → Subject | You → Object | He/She → No Change",
          "example_en": "I/We → Subject | You → Object | He/She → No Change"
        },
        {
          "latex": "\\text{Modal} + V_1 \\quad(\\text{Base Form Only})",
          "meaning_hi": "हर Modal के बाद केवल शुद्ध V1",
          "meaning_en": "Every Modal strictly takes bare V1",
          "example_hi": "She can sing. / We must obey laws.",
          "example_en": "She can sing. / We must obey laws."
        },
        {
          "latex": "\\text{lest} + \\text{Sub} + \\text{should} + V_1",
          "meaning_hi": "lest के साथ हमेशा should",
          "meaning_en": "`lest` always pairs with `should`",
          "example_hi": "Walk carefully lest you should fall.",
          "example_en": "Walk carefully lest you should fall."
        }
      ]
    },
    "concept_md_hi": "### 3-सेकंड परीक्षा चेकलिस्ट\n- **Voice:** क्या उत्तर में `V3` है? क्या Continuous में `being` और Perfect में `been` है?\n- **Narration:** क्या `told` के बाद `to` हटा दिया गया है? क्या Universal Truth का Tense अपरिवर्तित है?\n- **Modals:** क्या Modal के बाद शुद्ध `V1` है?",
    "concept_md_en": "### 3-Second Exam Checklist\n- **Voice:** Is `V3` present? Did Continuous keep `being` and Perfect keep `been`?\n- **Narration:** Did you drop `to` after `told`? Did Universal Truth stay in Present Tense?\n- **Modals:** Is bare `V1` placed after the modal?",
    "exam_tip_hi": "इन तीन अध्यायों (Voice + Narration + Modals) से BSEB Class 10 और Class 12 दोनों में मिलाकर लगभग **12 से 18 अंकों** के सीधे ऑब्जेक्टिव प्रश्न आते हैं — यह पूरा सेक्शन बोनस अंक है!",
    "exam_tip_en": "Voice, Narration, and Modals together contribute **12–18 direct objective marks** across BSEB Class 10 & 12 — master this unit to jump straight to distinction!",
    "glossary_terms": []
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{Obj} + \\text{be / being / been} + V_3 + \\text{by Sub}",
      "label_hi": "Active → Passive मास्टर सूत्र",
      "label_en": "Master Active → Passive Formula"
    },
    {
      "latex": "\\text{Let} + \\text{Object} + \\text{be} + V_3",
      "label_hi": "आदेश वाक्य (Imperative) का Passive",
      "label_en": "Imperative Passive Formula"
    },
    {
      "latex": "\\text{SON / 123: } 1\\rightarrow S,\\; 2\\rightarrow O,\\; 3\\rightarrow N",
      "label_hi": "Narration Pronoun परिवर्तन नियम",
      "label_en": "Narration Pronoun Shift Rule"
    },
    {
      "latex": "\\text{Modal} + V_1 \\quad|\\quad \\text{lest} \\rightarrow \\text{should}",
      "label_hi": "Modals व lest का पक्का नियम",
      "label_en": "Modal + V1 & `lest → should` Rule"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "VOICE",
      "fact_hi": "I know him → He is known TO me (known के साथ by नहीं, to लगता है!)।",
      "fact_en": "I know him → He is known TO me (`known to`, never `known by`!)."
    },
    {
      "tag": "NARRATION",
      "fact_hi": "Universal Truth (\"The sun rises in the east\") का Tense Indirect Speech में भी कभी नहीं बदलता।",
      "fact_en": "Universal truths NEVER change tense in Indirect Speech."
    },
    {
      "tag": "MODAL",
      "fact_hi": "आशीर्वाद/दुआ (\"___ God bless you!\") में हमेशा `May` और `lest` के साथ हमेशा `should` आता है।",
      "fact_en": "Blessings always take `May` and `lest` always takes `should`."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "Passive में V3 भूल जाना या Continuous में `being` छोड़ देना (\"A book is read by him\" जब Active \"is reading\" हो)।",
      "mistake_en": "Dropping `being` in Continuous Passive or forgetting `V3`.",
      "fix_hi": "Active में `-ing` देखते ही Passive में **`being + V3`** लगाएँ: **\"A book is being read by him.\"**",
      "fix_en": "Whenever Active has `-ing`, insert **`being + V3`**: **\"A book is being read by him.\"**"
    },
    {
      "mistake_hi": "Indirect Speech में \"He told to me that...\" लिखना।",
      "mistake_en": "Writing \"He told to me that...\" in Indirect Speech.",
      "fix_hi": "`said to` बदलकर केवल **`told`** बनता है — `told` के बाद `to` कभी नहीं आता: **\"He told me that...\"**",
      "fix_en": "`said to` becomes plain **`told`** — NEVER write `told to`: **\"He told me that...\"**"
    },
    {
      "mistake_hi": "Modal के बाद `s/es` या `to` लगा देना (\"She can swims\" / \"You must to go\")।",
      "mistake_en": "Adding `-s` or `to` after modals (\"She can swims\", \"You must to go\").",
      "fix_hi": "Modal के बाद हमेशा शुद्ध V1: **\"She can swim.\" / \"You must go.\"** (केवल `ought to` अपवाद है)।",
      "fix_en": "Use bare V1 after modals: **\"She can swim.\" / \"You must go.\"** (Only `ought` takes `to`)."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "Active – Passive Voice (BSEB Objective)",
      "topic_en": "Active – Passive Voice MCQs",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "Direct – Indirect Narration (BSEB Objective)",
      "topic_en": "Direct – Indirect Narration MCQs",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "Modals (can/may/must/should/ought to)",
      "topic_en": "Modals Objective Questions",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 4
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 5,
  "analogy_count": 5,
  "bseb_pyq_mapped": true,
  "syllabus_year": "2026-27"
}$json$::jsonb,
  'PUBLISHED',
  1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json        = EXCLUDED.mindmap_json,
  sections_json       = EXCLUDED.sections_json,
  board_capsule_json  = EXCLUDED.board_capsule_json,
  quality_checks_json = EXCLUDED.quality_checks_json,
  status              = EXCLUDED.status,
  version             = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'skill-eng-f-ch4',
  4,
  'विद्यार्थियों को X-क्रॉस चित्र से Active–Passive Voice का भय दूर कराना, "संदेशवाहक खेल" से Direct–Indirect Speech सिखाना, तथा दैनिक कक्षा-संवाद से Modals में 100% दक्षता दिलाकर 15+ पक्के बोर्ड अंक सुनिश्चित करना।',
  'Demystify Active–Passive Voice through the visual X-swap diagram, teach Narration naturally via a 2-student "Message Reporter" game, and drill Modals through real classroom dialogue for 15+ guaranteed BSEB marks.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "5-मिनट मॉडल्स कोरस + Active→Passive X-क्रॉस खेल",
    "phase_en": "5-Min Modals Chorus + Active→Passive X-Swap Method",
    "teacher_action_hi": "मिनट 0–5: पूरी कक्षा एक साथ बोले — \"May I come in? Yes, you may! I can speak English! We must work hard!\"। मिनट 5–22: बोर्ड पर बड़ा X-क्रॉस बनाकर \"Ram eats a mango → A mango is eaten by Ram\" दिखाएँ; 3 छात्रों को आगे बुलाकर Subject और Object की जगह अदल-बदल करवाएँ। मिनट 22–34: Continuous (`being`), Perfect (`been`) और Imperative (`Let...be+V3`) नियम समझाएँ। मिनट 34–40: 5 वाक्य अभ्यास।",
    "teacher_action_en": "Mins 0–5: Full-class spoken chorus — \"May I come in? Yes, you may! I can speak English! We must work hard!\" Mins 5–22: Draw the big X-Swap on the board and have 3 students physically swap Subject & Object positions. Mins 22–34: Add `being`, `been`, and Imperative `Let...be+V3`. Mins 34–40: 5-sentence practice.",
    "student_check_hi": "बोर्ड पर लिखें \"Open the window\" और छात्रों से `Let` से शुरू करके Passive बनवाएँ।",
    "student_check_en": "Write \"Open the window\" on the board and ask the class to convert it using `Let`."
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "\"संदेशवाहक (Message Reporter)\" खेल द्वारा Narration (Direct → Indirect)",
    "phase_en": "Teaching Narration via the \"Message Reporter\" Classroom Game",
    "teacher_action_hi": "मिनट 0–10: दो छात्रों को आगे बुलाएँ। छात्र A धीरे से कहे \"I like mangoes.\" छात्र B पूरी कक्षा को रिपोर्ट करे — \"He said that he liked mangoes!\"। मिनट 10–25: बोर्ड पर Backshift तालिका (is→was, V1→V2, will→would, today→that day) और SON/123 नियम लिखें। मिनट 25–35: Universal Truth अपवाद और Yes/No प्रश्नों में `if` का प्रयोग समझाएँ। मिनट 35–40: \"told to\" गलती काटने का अभ्यास।",
    "teacher_action_en": "Mins 0–10: Call 2 students up. Student A whispers \"I like mangoes.\" Student B reports to the class: \"He said that he liked mangoes!\" Mins 10–25: Present the Backshift table and SON/123 pronoun rule on the board. Mins 25–35: Teach Universal Truth exception and `if` for Yes/No questions. Mins 35–40: Drill fixing the \"told to\" error.",
    "student_check_hi": "पूछें: यदि टीचर कहें The teacher said, \"Honesty is the best policy\" तो क्या `is` बदलकर `was` बनेगा?",
    "student_check_en": "Ask: In `The teacher said, \"Honesty is the best policy\"`, does `is` change to `was`? Why not?"
  },
  {
    "period_no": 3,
    "duration_mins": 40,
    "phase_hi": "Modals (can, could, may, might, should, must, ought to) + lest ट्रिक",
    "phase_en": "Modals in Real Life + `lest → should` Board Hack",
    "teacher_action_hi": "मिनट 0–10: कक्षा की वास्तविक परिस्थितियों पर अभिनय — दरवाज़े पर प्रवेश (`May I come in?`), भारी बैग उठाना (`I can lift it`), दोस्त को सलाह (`You should revise`), सड़क नियम (`We must wear a helmet`)। मिनट 10–25: Modal + शुद्ध V1 का अटल नियम और `May` (आशीर्वाद) + `lest...should` + `ought to` बोर्ड पर समझाएँ। मिनट 25–40: 10 BSEB Modal MCQs।",
    "teacher_action_en": "Mins 0–10: Act out 4 everyday scenes — classroom door (`May`), lifting a bag (`can`), friendly advice (`should`), traffic safety (`must`). Mins 10–25: Drill Modal + bare V1, blessing `May`, `lest + should`, and `ought to`. Mins 25–40: Solve 10 BSEB Modal MCQs.",
    "student_check_hi": "पूछें: \"He can swims\" में क्या गलती है और सही वाक्य क्या होगा?",
    "student_check_en": "Ask: Spot and fix the error in \"He can swims.\""
  },
  {
    "period_no": 4,
    "duration_mins": 40,
    "phase_hi": "15-अंक BSEB ऑब्जेक्टिव सुपर-प्रैक्टिस मैराथन",
    "phase_en": "15-Mark BSEB Objective Super-Practice Marathon",
    "teacher_action_hi": "मिनट 0–15: Voice, Narration और Modals के 1-सेकंड एलिमिनेशन हैक का रिवीजन। मिनट 15–35: 15 मिश्रित BSEB PYQ प्रश्न (5 Voice + 5 Narration + 5 Modals) हल करवाएँ। मिनट 35–40: हर छात्र अपना स्कोर गिने और तालियों से उत्साह बढ़ाएँ।",
    "teacher_action_en": "Mins 0–15: Review 1-second elimination hacks across Voice, Narration, and Modals. Mins 15–35: Run a 15-question mixed BSEB PYQ drill (5 Voice + 5 Narration + 5 Modals). Mins 35–40: Self-scoring celebration.",
    "student_check_hi": "तेज़ी से पूछें: \"I know him\" का Passive क्या होगा — `known by` या `known to`?",
    "student_check_en": "Quick check: Does \"I know him\" become `known by me` or `known to me`?"
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड 1: Passive X-क्रॉस + 3 जादुई शब्द (being / been / be)",
    "heading_en": "Blackboard 1: Passive X-Swap + 3 Magic Words",
    "points_hi": [
      "Simple Present → is/am/are + V3 | Simple Past → was/were + V3",
      "Continuous (-ing) → + being + V3 | Perfect (has/have/had) → + been + V3",
      "Modal (can/will/must) → + be + V3 | आदेश वाक्य → Let + Obj + be + V3",
      "खास अपवाद: I know him → He is known TO me."
    ],
    "points_en": [
      "Simple Present → is/am/are + V3 | Simple Past → was/were + V3",
      "Continuous (-ing) → + being + V3 | Perfect → + been + V3",
      "Modal → + be + V3 | Imperative → Let + Obj + be + V3",
      "Special PYQ: I know him → He is known TO me."
    ]
  },
  {
    "heading_hi": "ब्लैकबोर्ड 2: Narration SON/123 + Modals ट्रिक",
    "heading_en": "Blackboard 2: Narration SON/123 & Modals Cheat Box",
    "points_hi": [
      "said to → told (to गायब!) | is/am/are → was/were | V1 → V2 | will → would",
      "SON/123: 1st (I/We) → Subject | 2nd (You) → Object | 3rd → No Change",
      "Universal Truth का Tense कभी न बदलें!",
      "Modal + हमेशा V1 | lest → should | आशीर्वाद → May | ought + to"
    ],
    "points_en": [
      "said to → told (no \"to\"!) | is/am/are → was/were | V1 → V2 | will → would",
      "SON/123: 1st → Subject | 2nd → Object | 3rd → No Change",
      "NEVER backshift a Universal Truth!",
      "Modal + V1 | lest → should | Blessings → May | ought + to"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "संदेशवाहक खेल (Classroom Whisper Reporter)",
    "title_en": "Classroom Message Reporter Game",
    "materials_hi": "कोई सामग्री नहीं — केवल 3 छात्रों का समूह",
    "materials_en": "None — groups of 3 students",
    "steps_hi": "छात्र 1 एक छोटा वाक्य बोले (\"I am ready / I can run fast\"), छात्र 2 सुनकर छात्र 3 को Indirect Speech में बताए (\"Ravi said that he was ready\")। हर सही रिपोर्ट पर 1 अंक!",
    "steps_en": "Student 1 says a short line (\"I am ready / I can run fast\"); Student 2 reports it to Student 3 in Indirect Speech (\"Ravi said that he was ready\")."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "5 सरल Active वाक्यों को Passive में बदलें (Ram eats a mango, She writes a letter, Open the door, He helped me, I can do it)।",
    "task_en": "Convert 5 core Active sentences into Passive Voice (Ram eats a mango, She writes a letter, Open the door, He helped me, I can do it)."
  },
  {
    "level": "BOARD",
    "task_hi": "5 Direct Speech वाक्यों को Indirect Speech में बदलें (1 सामान्य, 1 प्रश्नवाचक, 1 Universal Truth, 1 will वाला, 1 today वाला)।",
    "task_en": "Convert 5 Direct Speech sentences into Indirect Speech covering statements, Yes/No questions, universal truth, `will`, and `today`."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "can, could, may, might, should, must और ought to — सभी 7 Modals से अपने विद्यालय और समाज पर 1-1 प्रेरक वाक्य लिखें।",
    "task_en": "Write 7 original sentences about your school and community using each modal once: can, could, may, might, should, must, ought to."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र Indirect Speech में `said to` को `told to` लिख देते हैं (\"He told to me that...\").",
    "misconception_en": "Students write \"He told to me that...\" instead of dropping `to`.",
    "correction_hi": "सीधा सूत्र याद कराएँ: `said` अकेला नहीं चल सकता इसलिए `to` लेता है; `told` ताकतवर है, उसे `to` की बैसाखी नहीं चाहिए → केवल **\"He told me\"**!",
    "correction_en": "Teach the crutch rule: `said` needs `to` before a listener, whereas `told` is strong and NEVER takes `to` → **\"He told me\"**!"
  },
  {
    "misconception_hi": "छात्र Indirect Question में भी प्रश्न वाला क्रम छोड़ देते हैं (\"He asked me where was I going?\").",
    "misconception_en": "Students keep question word order and `?` in Indirect Questions (\"He asked me where was I going?\").",
    "correction_hi": "सिखाएँ कि Indirect Speech हमेशा साधारण बयान बन जाता है — इसलिए कर्ता पहले, क्रिया बाद में, और अंत में Full Stop: **\"He asked me where I was going.\"**",
    "correction_en": "Show that Indirect Speech turns a question into a statement: Subject BEFORE verb, ending with a full stop — **\"He asked me where I was going.\"**"
  }
]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods                   = EXCLUDED.duration_periods,
  objectives_hi                      = EXCLUDED.objectives_hi,
  objectives_en                      = EXCLUDED.objectives_en,
  teaching_steps_json                = EXCLUDED.teaching_steps_json,
  blackboard_points_json             = EXCLUDED.blackboard_points_json,
  classroom_activities_json          = EXCLUDED.classroom_activities_json,
  homework_json                      = EXCLUDED.homework_json,
  common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Simple Present Passive
  (
    '10000006-0004-4000-8000-000000000001', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Simple Present Passive', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', 'BSEB 2023',
    'Passive Voice वाक्य बनाएँ: "Ram eats a mango." →',
    'Build the Passive Voice of: "Ram eats a mango."',
    NULL, NULL,
    'X-क्रॉस याद करें: `A mango` आगे + `is eaten` (V3!) + `by Ram`!',
    'Use the X-swap: `A mango` + `is eaten` (V3!) + `by Ram`!',
    '**"A mango is eaten by Ram"** — Simple Present Passive में `is/am/are + V3` लगता है।',
    '**"A mango is eaten by Ram"** — Simple Present Passive uses `is/am/are + V3`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "Passive बनाएँ: Ram eats a mango. (राम द्वारा एक आम खाया जाता है।)",
  "prompt_en": "Build the Passive Voice of \"Ram eats a mango.\"",
  "grammar_formula": "New Subject + is + V3 (eaten) + by + Agent",
  "tokens": [
    "A",
    "mango",
    "is",
    "eaten",
    "by",
    "Ram"
  ],
  "distractors": [
    "eat",
    "was"
  ],
  "correct_sentence": "A mango is eaten by Ram",
  "pronunciation_hi": "अ मैंगो इज़ ईटन बाई राम"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Imperative Passive Let
  (
    '10000006-0004-4000-8000-000000000002', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Imperative Passive Let', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', 'BSEB 2024',
    'आदेश वाक्य का Passive बनाएँ: "Open the door." →',
    'Build the Passive Voice of: "Open the door."',
    NULL, NULL,
    'आदेश वाक्य का सूत्र: `Let + Object + be + V3`!',
    'Imperative Passive formula: `Let + Object + be + V3`!',
    '**"Let the door be opened"** — आदेश वाक्यों का Passive हमेशा `Let + Object + be + V3` बनता है।',
    '**"Let the door be opened"** — follows `Let + Object + be + V3`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "Passive बनाएँ: Open the door. (दरवाज़ा खोला जाए।)",
  "prompt_en": "Build the Imperative Passive using Let",
  "grammar_formula": "Let + Object + be + V3",
  "tokens": [
    "Let",
    "the",
    "door",
    "be",
    "opened"
  ],
  "distractors": [
    "is",
    "open"
  ],
  "correct_sentence": "Let the door be opened",
  "pronunciation_hi": "लेट द डोर बी ओपन्ड"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Indirect Speech Statement
  (
    '10000006-0004-4000-8000-000000000003', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Indirect Speech Statement', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', 'BSEB 2023',
    'Indirect Speech बनाएँ: He said to me, "I am busy." →',
    'Build the Indirect Speech of: He said to me, "I am busy."',
    NULL, NULL,
    '`said to → told` (to हटाएँ!), `I → he`, और `am → was`!',
    '`said to → told` (drop `to`!), `I → he`, and `am → was`!',
    '**"He told me that he was busy"** — Reporting verb भूतकाल में होने से `am` बदलकर `was` बन गया।',
    '**"He told me that he was busy"** — `said to` becomes `told` and `am` backshifts to `was`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "Indirect बनाएँ: He said to me, \"I am busy.\"",
  "prompt_en": "Build the Indirect Speech without the \"told to\" error",
  "grammar_formula": "He + told + me + that + he + was + busy",
  "tokens": [
    "He",
    "told",
    "me",
    "that",
    "he",
    "was",
    "busy"
  ],
  "distractors": [
    "to",
    "is"
  ],
  "correct_sentence": "He told me that he was busy",
  "pronunciation_hi": "ही टोल्ड मी दैट ही वॉज़ बिज़ी"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Modal Duty must
  (
    '10000006-0004-4000-8000-000000000004', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Modal Duty must', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', 'BSEB 2022',
    'सही Modal वाक्य बनाएँ: "हमें यातायात के नियमों का अवश्य पालन करना चाहिए।"',
    'Build the sentence: "We must obey traffic rules."',
    NULL, NULL,
    'अनिवार्य नियम के लिए `must` और उसके तुरंत बाद शुद्ध V1 (`obey`, न कि `to obey`)!',
    'Strict rule takes `must` + bare V1 (`obey`, NO `to`!)!',
    '**"We must obey traffic rules"** — Modal (`must`) के बाद सीधे V1 (`obey`) आता है।',
    '**"We must obey traffic rules"** — Modal `must` takes bare V1 `obey` directly.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "हमें यातायात के नियमों का अवश्य पालन करना चाहिए।",
  "prompt_en": "Build the strong-obligation sentence with must + V1",
  "grammar_formula": "Subject + must + V1 + Object",
  "tokens": [
    "We",
    "must",
    "obey",
    "traffic",
    "rules"
  ],
  "distractors": [
    "to",
    "obeys"
  ],
  "correct_sentence": "We must obey traffic rules",
  "pronunciation_hi": "वी मस्ट ओबे ट्रैफ़िक रूल्स"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (TOPPER, PRACTICE) — Continuous Passive being
  (
    '10000006-0004-4000-8000-000000000005', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Continuous Passive being', 'PRACTICE', 'SENTENCE_BUILDER', 'TOPPER', 'BSEB 2024',
    'Passive Voice बनाएँ: "She is writing a letter." →',
    'Build the Continuous Passive of: "She is writing a letter."',
    NULL, NULL,
    'Active में `-ing` (`writing`) है → Passive में **`is being written`** + `by her`!',
    'Active `-ing` requires **`is being written`** + `by her`!',
    '**"A letter is being written by her"** — Present Continuous Passive = `is/am/are + being + V3`।',
    '**"A letter is being written by her"** — Present Continuous Passive uses `is being + V3`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "Passive बनाएँ: She is writing a letter.",
  "prompt_en": "Build the Present Continuous Passive with being + V3",
  "grammar_formula": "New Subject + is + being + V3 + by + her",
  "tokens": [
    "A",
    "letter",
    "is",
    "being",
    "written",
    "by",
    "her"
  ],
  "distractors": [
    "been",
    "writing"
  ],
  "correct_sentence": "A letter is being written by her",
  "pronunciation_hi": "अ लेटर इज़ बीइंग रिटन बाई हर"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (FOUNDATION, PRACTICE) — Classroom Door Modal Permission
  (
    '10000006-0004-4000-8000-000000000006', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Classroom Door Modal Permission', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', 'BSEB 2023',
    'कक्षा के दरवाज़े पर खड़े होकर शिक्षक से अंदर आने की विनम्र अनुमति कैसे माँगेंगे?',
    'You are standing at the classroom door. Which polite Modal sentence asks permission from your teacher?',
    NULL, NULL,
    'शिक्षक या बड़ों से औपचारिक अनुमति माँगने के लिए कौन-सा Modal सर्वोत्तम है?',
    'Which modal is best for formal, respectful permission?',
    '**"May I come in, Sir?"** — बड़ों व शिक्षकों से विनम्र अनुमति माँगने के लिए हमेशा **`May`** प्रयोग होता है।',
    '**"May I come in, Sir?"** — `May` is the standard polite modal for formal permission.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "कक्षा के दरवाज़े पर विनम्र अनुमति (Polite Permission)",
  "scene_title_en": "At the Classroom Door: Asking Polite Permission",
  "prompt_hi": "शिक्षक कक्षा के अंदर पढ़ा रहे हैं। अंदर प्रवेश के लिए सबसे शुद्ध और विनम्र वाक्य चुनें:",
  "prompt_en": "Your teacher is inside the classroom. Choose the most polite, board-approved question:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "दरवाज़े पर अनुमति का दृश्य",
    "title_en": "Classroom Entrance Permission Scene",
    "caption_hi": "शिक्षक से औपचारिक अनुमति → कौन-सा Modal?",
    "caption_en": "Formal respectful permission from a teacher → Which modal?",
    "viewBox": "0 0 540 150",
    "elements": [
      {
        "kind": "rect",
        "x": 180,
        "y": 20,
        "width": 84,
        "height": 112,
        "rx": 4,
        "fill": "#FEF3C7",
        "stroke": "#92400E",
        "strokeWidth": 2.2
      },
      {
        "kind": "circle",
        "cx": 248,
        "cy": 78,
        "r": 4,
        "fill": "#92400E"
      },
      {
        "kind": "label",
        "x": 222,
        "y": 60,
        "text_hi": "दरवाज़ा",
        "text_en": "Door",
        "fill": "#92400E",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "circle",
        "cx": 110,
        "cy": 62,
        "r": 18,
        "fill": "#EFF6FF",
        "stroke": "#1E3A8A",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 110,
        "y": 108,
        "text_hi": "छात्र (बाहर)",
        "text_en": "Student",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "arrow",
        "x1": 134,
        "y1": 72,
        "x2": 174,
        "y2": 72,
        "stroke": "#059669",
        "strokeWidth": 2.5
      },
      {
        "kind": "rect",
        "x": 300,
        "y": 30,
        "width": 210,
        "height": 84,
        "rx": 10,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 405,
        "y": 60,
        "text_hi": "\"___ I come in, Sir?\"",
        "text_en": "\"___ I come in, Sir?\"",
        "fill": "#065F46",
        "fontSize": 14,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "MessageSquare",
      "label_hi": "Must I come in, Sir?",
      "label_en": "Must I come in, Sir?"
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "May I come in, Sir?",
      "label_en": "May I come in, Sir?"
    },
    {
      "id": "c3",
      "icon": "MessageSquare",
      "label_hi": "Should I come in, Sir?",
      "label_en": "Should I come in, Sir?"
    },
    {
      "id": "c4",
      "icon": "MessageSquare",
      "label_hi": "May I comes in, Sir?",
      "label_en": "May I comes in, Sir?"
    }
  ],
  "correct_choice_id": "c2"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (BOARD, PRACTICE) — Passive X-Swap Scene
  (
    '10000006-0004-4000-8000-000000000007', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Passive X-Swap Scene', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'BSEB 2024',
    'X-क्रॉस चित्र देखकर सही Simple Past Passive वाक्य चुनें:',
    'Follow the X-Swap arrows to pick the exact Simple Past Passive sentence:',
    NULL, NULL,
    '`wrote` भूतकाल (V2) है → Passive में **`was + written (V3)`** और `Premchand` अंत में `by Premchand`!',
    '`wrote` is Simple Past (V2) → Passive needs **`was + written (V3)`** + `by Premchand`!',
    '**"Godaan was written by Premchand."** — V2 का Passive हमेशा `was/were + V3` बनता है।',
    '**"Godaan was written by Premchand."** — Simple Past Passive strictly uses `was/were + V3`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PICTURE_GRAMMAR",
  "scene_title_hi": "भूतकाल Passive X-क्रॉस: Premchand wrote Godaan",
  "scene_title_en": "Past Passive X-Swap: Premchand wrote Godaan",
  "prompt_hi": "\"Premchand wrote Godaan.\" का सही Passive Voice चुनें:",
  "prompt_en": "Select the 100% accurate Passive Voice of \"Premchand wrote Godaan.\":",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "V2 (wrote) का Passive रूपांतरण",
    "title_en": "Passive Conversion of V2 (wrote)",
    "caption_hi": "Godaan (एकवचन Object) + भूतकाल (V2) → was + V3!",
    "caption_en": "Singular Object (Godaan) + Past V2 → was + V3!",
    "viewBox": "0 0 560 120",
    "elements": [
      {
        "kind": "rect",
        "x": 20,
        "y": 24,
        "width": 155,
        "height": 68,
        "rx": 8,
        "fill": "#EFF6FF",
        "stroke": "#1E3A8A",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 97,
        "y": 54,
        "text_hi": "Premchand (S)",
        "text_en": "Premchand (S)",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 202,
        "y": 24,
        "width": 155,
        "height": 68,
        "rx": 8,
        "fill": "#FEF3C7",
        "stroke": "#D97706",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 279,
        "y": 54,
        "text_hi": "wrote (V2)",
        "text_en": "wrote (V2)",
        "fill": "#B45309",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 384,
        "y": 24,
        "width": 155,
        "height": 68,
        "rx": 8,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 461,
        "y": 54,
        "text_hi": "Godaan (O)",
        "text_en": "Godaan (O)",
        "fill": "#059669",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "PenTool",
      "label_hi": "Godaan was written by Premchand.",
      "label_en": "Godaan was written by Premchand."
    },
    {
      "id": "c2",
      "icon": "PenTool",
      "label_hi": "Godaan is written by Premchand.",
      "label_en": "Godaan is written by Premchand."
    },
    {
      "id": "c3",
      "icon": "PenTool",
      "label_hi": "Godaan was wrote by Premchand.",
      "label_en": "Godaan was wrote by Premchand."
    },
    {
      "id": "c4",
      "icon": "PenTool",
      "label_hi": "Godaan has written by Premchand.",
      "label_en": "Godaan has written by Premchand."
    }
  ],
  "correct_choice_id": "c1"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (FOUNDATION, PRACTICE) — Passive Golden Rule
  (
    '10000006-0004-4000-8000-000000000008', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Passive Golden Rule', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'Passive Voice में Continuous, Perfect और Modal के साथ कौन-से 3 जादुई शब्द जुड़ते हैं?',
    'Which 3 magic helpers join V3 in Continuous, Perfect, and Modal Passive Voice?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Continuous, Perfect और Modal के Passive में V3 से पहले क्या जुड़ता है?",
  "front_en": "What word sits right before V3 in Continuous, Perfect, and Modal Passive?",
  "back_hi": "Continuous (-ing) → BEING + V3; Perfect (has/have/had) → BEEN + V3; Modal (will/can/must) → BE + V3।",
  "back_en": "Continuous (-ing) → BEING + V3; Perfect (has/have/had) → BEEN + V3; Modal (will/can/must) → BE + V3.",
  "mnemonic_hi": "ट्रिक: \"ing = being, has/have/had = been, Modal = be — और अंत में हमेशा V3!\"",
  "mnemonic_en": "Trick: \"-ing → being, Perfect → been, Modal → be — always ending with V3!\"",
  "pronunciation_hi": "बीइंग (being) · बीन (been) · बी (be)"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (BOARD, PRACTICE) — SON 123 Rule
  (
    '10000006-0004-4000-8000-000000000009', 'skill-eng-foundation', 'skill-eng-f-ch4', 'SON 123 Rule', 'PRACTICE', 'FLASHCARD', 'BOARD', 'BSEB 2023',
    'Narration में Pronoun बदलने का SON / 123 नियम क्या है?',
    'What is the SON / 123 Pronoun rule in Narration?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Narration में SON / 123 फॉर्मूला कैसे काम करता है?",
  "front_en": "How does the SON / 123 rule change pronouns in Indirect Speech?",
  "back_hi": "1st Person (I, We) → Subject के अनुसार; 2nd Person (You) → Object के अनुसार; 3rd Person (He, She, It, They) → No Change (कोई बदलाव नहीं)।",
  "back_en": "1st Person (I, We) → follows Subject; 2nd Person (You) → follows Object; 3rd Person (He, She, It, They) → No Change.",
  "mnemonic_hi": "ट्रिक: \"S-O-N ऊपर, 1-2-3 नीचे — 1→S, 2→O, 3→N!\"",
  "mnemonic_en": "Trick: \"Stack S-O-N over 1-2-3: 1→S, 2→O, 3→N!\"",
  "pronunciation_hi": "सब्जेक्ट · ऑब्जेक्ट · नो चेंज"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (BOARD, PRACTICE) — Lest + Should & Known To
  (
    '10000006-0004-4000-8000-000000000010', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Lest + Should & Known To', 'PRACTICE', 'FLASHCARD', 'BOARD', 'BSEB 2024',
    '`lest` और `known` से जुड़े 2 सबसे प्रसिद्ध BSEB अपवाद कौन-से हैं?',
    'What are the 2 famous BSEB grammar rules for `lest` and Passive `known`?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "बिहार बोर्ड के 2 सबसे चतुर नियम: `lest` के साथ क्या, और `known` के साथ क्या?",
  "front_en": "2 clever BSEB exam rules: what pairs with `lest` and Passive `known`?",
  "back_hi": "1. `lest` के साथ हमेशा `should` (Walk carefully lest you should fall)। 2. `know` के Passive में `by` नहीं, `to` (He is known to me)।",
  "back_en": "1. `lest` ALWAYS takes `should` (Walk carefully lest you should fall). 2. Passive `known` takes `to`, never `by` (He is known to me).",
  "mnemonic_hi": "ट्रिक: \"Lest = Should | Known = To!\"",
  "mnemonic_en": "Trick: \"Lest → Should | Known → To!\"",
  "pronunciation_hi": "लेस्ट शुड · नोन टू मी"
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (FOUNDATION, PRACTICE) — Active to Passive Match
  (
    '10000006-0004-4000-8000-000000000011', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Active to Passive Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2024',
    'प्रत्येक Active रूप को उसके सही Passive सहायक रूप से मिलाएँ:',
    'Match each Active verb structure with its exact Passive form:',
    NULL, NULL,
    'V1 → is/are+V3, V2 → was/were+V3, -ing → being+V3, has/have → been+V3!',
    'V1 → is/are+V3, V2 → was/were+V3, -ing → being+V3, has/have → been+V3!',
    'चारों रूप Active से Passive परिवर्तन की रीढ़ हैं।',
    'These four conversions form the backbone of Active-to-Passive Voice.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "Active रूप को सही Passive रूप से मिलाएँ",
  "instruction_en": "Match each Active form with its exact Passive partner",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "eats (Simple Present)",
      "left_en": "eats (Simple Present)",
      "right_hi": "is eaten",
      "right_en": "is eaten"
    },
    {
      "id": "p2",
      "left_hi": "ate (Simple Past)",
      "left_en": "ate (Simple Past)",
      "right_hi": "was eaten",
      "right_en": "was eaten"
    },
    {
      "id": "p3",
      "left_hi": "is eating (Continuous)",
      "left_en": "is eating (Continuous)",
      "right_hi": "is being eaten",
      "right_en": "is being eaten"
    },
    {
      "id": "p4",
      "left_hi": "has eaten (Perfect)",
      "left_en": "has eaten (Perfect)",
      "right_hi": "has been eaten",
      "right_en": "has been eaten"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (BOARD, PRACTICE) — Direct to Indirect Time Words
  (
    '10000006-0004-4000-8000-000000000012', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Direct to Indirect Time Words', 'PRACTICE', 'MATCH_PAIRS', 'BOARD', 'BSEB 2023',
    'Direct Speech के समय-शब्दों को उनके Indirect Speech रूप से मिलाएँ:',
    'Match Direct Speech time/place words with their Indirect Speech equivalents:',
    NULL, NULL,
    'Indirect में पास के शब्द दूर बन जाते हैं (`today → that day`, `now → then`)!',
    'In Indirect Speech, near words shift to distant words!',
    'today → that day, tomorrow → the next day, yesterday → the previous day, now → then।',
    'today → that day, tomorrow → the next day, yesterday → the previous day, now → then.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "Direct से Indirect समय-शब्द मिलाएँ",
  "instruction_en": "Match Direct words to Indirect words",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "today",
      "left_en": "today",
      "right_hi": "that day",
      "right_en": "that day"
    },
    {
      "id": "p2",
      "left_hi": "tomorrow",
      "left_en": "tomorrow",
      "right_hi": "the next day",
      "right_en": "the next day"
    },
    {
      "id": "p3",
      "left_hi": "yesterday",
      "left_en": "yesterday",
      "right_hi": "the previous day",
      "right_en": "the previous day"
    },
    {
      "id": "p4",
      "left_hi": "now",
      "left_en": "now",
      "right_hi": "then",
      "right_en": "then"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Modal Ability can
  (
    '10000006-0004-4000-8000-000000000013', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Modal Ability can', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'सही Modal चुनें: Ravi ___ speak both Hindi and English fluently.',
    'Choose the right modal: Ravi ___ speak both Hindi and English fluently.',
    $json$[{"key":"A","text_hi":"can","text_en":"can"},{"key":"B","text_hi":"must","text_en":"must"},{"key":"C","text_hi":"ought","text_en":"ought"},{"key":"D","text_hi":"should","text_en":"should"}]$json$::jsonb, 'A',
    'वाक्य में रवि की बोलने की **क्षमता (Ability)** बताई जा रही है!',
    'The sentence expresses Ravi''s **ability** to speak two languages!',
    'वर्तमान योग्यता या क्षमता (ability) के लिए **`can`** का प्रयोग होता है।',
    'Present ability is expressed with **`can`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Modal Blessing May
  (
    '10000006-0004-4000-8000-000000000014', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Modal Blessing May', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2022',
    'सही Modal चुनें: ___ God bless you with success!',
    'Choose the exact modal: ___ God bless you with success!',
    $json$[{"key":"A","text_hi":"Can","text_en":"Can"},{"key":"B","text_hi":"Must","text_en":"Must"},{"key":"C","text_hi":"May","text_en":"May"},{"key":"D","text_hi":"Should","text_en":"Should"}]$json$::jsonb, 'C',
    'आशीर्वाद या दुआ (Wish/Prayer) के वाक्यों की शुरुआत किस शब्द से होती है?',
    'Which modal opens a blessing or prayer ending with `!`?',
    'आशीर्वाद व शुभकामना (Optative sentences) हमेशा **`May`** से शुरू होते हैं: *"May God bless you!"*',
    'Optative wishes and blessings ALWAYS start with **`May`**: *"May God bless you!"*',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Simple Present Passive MCQ
  (
    '10000006-0004-4000-8000-000000000015', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Simple Present Passive MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'सही Passive Voice चुनें: "They play football."',
    'Choose the correct Passive Voice of: "They play football."',
    $json$[{"key":"A","text_hi":"Football was played by them.","text_en":"Football was played by them."},{"key":"B","text_hi":"Football played by them.","text_en":"Football played by them."},{"key":"C","text_hi":"Football is playing by them.","text_en":"Football is playing by them."},{"key":"D","text_hi":"Football is played by them.","text_en":"Football is played by them."}]$json$::jsonb, 'D',
    '`play` वर्तमान काल (V1) है → Passive में `is + V3` और `They → by them`!',
    '`play` is Simple Present → Passive uses `is + V3` + `by them`!',
    '**"Football is played by them."** — Simple Present (`play`) का Passive `is played` बनता है।',
    '**"Football is played by them."** — Simple Present Passive = `is + played` + `by them`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Passive known to
  (
    '10000006-0004-4000-8000-000000000016', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Passive known to', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'सही Passive Voice चुनें: "I know him."',
    'Choose the exact Passive Voice of: "I know him."',
    $json$[{"key":"A","text_hi":"He is known by me.","text_en":"He is known by me."},{"key":"B","text_hi":"He is known to me.","text_en":"He is known to me."},{"key":"C","text_hi":"He was known to me.","text_en":"He was known to me."},{"key":"D","text_hi":"He is knowing to me.","text_en":"He is knowing to me."}]$json$::jsonb, 'B',
    'याद रखें: `known` के साथ `by` नहीं लगता!',
    'Remember the classic BSEB exception: `known` does NOT take `by`!',
    '**"He is known to me."** — `know` का Passive हमेशा **`known to`** लेता है (`known by` गलत है)।',
    '**"He is known to me."** — Passive `known` strictly takes **`to`**, never `by`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Narration Universal Truth
  (
    '10000006-0004-4000-8000-000000000017', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Narration Universal Truth', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'सही Indirect Speech चुनें: The teacher said, "The sun rises in the east."',
    'Choose the correct Indirect Speech: The teacher said, "The sun rises in the east."',
    $json$[{"key":"A","text_hi":"The teacher said that the sun rises in the east.","text_en":"The teacher said that the sun rises in the east."},{"key":"B","text_hi":"The teacher said that the sun rose in the east.","text_en":"The teacher said that the sun rose in the east."},{"key":"C","text_hi":"The teacher told that the sun rises in the east.","text_en":"The teacher told that the sun rises in the east."},{"key":"D","text_hi":"The teacher asked that the sun rises in the east.","text_en":"The teacher asked that the sun rises in the east."}]$json$::jsonb, 'A',
    'सूरज पूरब में उगता है — यह एक सार्वभौमिक सत्य (Universal Truth) है!',
    'The sun rising in the east is a Universal Truth — never backshift its tense!',
    'Universal Truth का Tense कभी नहीं बदलता, और बिना Object के `said` ही रहता है: **"The teacher said that the sun rises in the east."**',
    'Universal truths remain in Simple Present, and `said` without an object stays `said`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Narration Yes/No Question
  (
    '10000006-0004-4000-8000-000000000018', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Narration Yes/No Question', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'सही Indirect Speech चुनें: He said to me, "Are you ill?"',
    'Choose the exact Indirect Speech: He said to me, "Are you ill?"',
    $json$[{"key":"A","text_hi":"He asked me that I was ill.","text_en":"He asked me that I was ill."},{"key":"B","text_hi":"He asked me if was I ill.","text_en":"He asked me if was I ill."},{"key":"C","text_hi":"He told me if I am ill.","text_en":"He told me if I am ill."},{"key":"D","text_hi":"He asked me if I was ill.","text_en":"He asked me if I was ill."}]$json$::jsonb, 'D',
    'Yes/No प्रश्न में `asked + if` और सीधा क्रम (`I was`, न कि `was I`) लगता है!',
    'Yes/No Indirect Question uses `asked + if` + statement order (`I was`, NOT `was I`)!',
    '**"He asked me if I was ill."** — `you` (2nd Person) Object `me` के अनुसार `I` बना और `are → was` हुआ।',
    '**"He asked me if I was ill."** — `you` shifts to `I`, `are` shifts to `was`, and statement order is used.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Modal lest + should
  (
    '10000006-0004-4000-8000-000000000019', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Modal lest + should', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Model Paper',
    'सही Modal चुनें: Walk carefully lest you ___ fall.',
    'Choose the exact modal: Walk carefully lest you ___ fall.',
    $json$[{"key":"A","text_hi":"may","text_en":"may"},{"key":"B","text_hi":"will","text_en":"will"},{"key":"C","text_hi":"should","text_en":"should"},{"key":"D","text_hi":"can","text_en":"can"}]$json$::jsonb, 'C',
    '`lest` (कहीं ऐसा न हो कि) के साथ हमेशा एक ही पक्का Modal आता है!',
    '`lest` has one fixed modal partner in English grammar!',
    '`lest` के बाद हमेशा **`should`** लगता है: *"Walk carefully lest you should fall."*।',
    '`lest` is ALWAYS followed by **`should`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Who Passive By whom
  (
    '10000006-0004-4000-8000-000000000020', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Who Passive By whom', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'सही Passive Voice चुनें: "Who broke this glass?"',
    'Choose the exact Passive Voice of: "Who broke this glass?"',
    $json$[{"key":"A","text_hi":"By whom this glass was broken?","text_en":"By whom this glass was broken?"},{"key":"B","text_hi":"By whom was this glass broken?","text_en":"By whom was this glass broken?"},{"key":"C","text_hi":"Who was broken this glass?","text_en":"Who was broken this glass?"},{"key":"D","text_hi":"By whom is this glass broken?","text_en":"By whom is this glass broken?"}]$json$::jsonb, 'B',
    '`Who → By whom`, भूतकाल (`broke` = V2) → `was ... broken`, और प्रश्न होने से `was` कर्ता से पहले!',
    '`Who → By whom`, Simple Past → `was ... broken`, and keep question order (`was` before `this glass`)!',
    '**"By whom was this glass broken?"** — प्रश्नवाचक क्रम में `was` हमेशा `this glass` से पहले आएगा।',
    '**"By whom was this glass broken?"** — keeps interrogative word order (`was` before subject) and V3 `broken`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Narration Past-to-Past-Perfect
  (
    '10000006-0004-4000-8000-000000000021', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Narration Past-to-Past-Perfect', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    'सही Indirect Speech चुनें: Sita said, "I bought a book yesterday."',
    'Choose the exact Indirect Speech: Sita said, "I bought a book yesterday."',
    $json$[{"key":"A","text_hi":"Sita said that she bought a book yesterday.","text_en":"Sita said that she bought a book yesterday."},{"key":"B","text_hi":"Sita told that she had bought a book yesterday.","text_en":"Sita told that she had bought a book yesterday."},{"key":"C","text_hi":"Sita said that she has bought a book the next day.","text_en":"Sita said that she has bought a book the next day."},{"key":"D","text_hi":"Sita said that she had bought a book the previous day.","text_en":"Sita said that she had bought a book the previous day."}]$json$::jsonb, 'D',
    'दो बदलाव जाँचें: `bought` (V2) → **`had bought`** (Past Perfect), और `yesterday` → **`the previous day`**!',
    'Check 2 shifts: `bought` (V2) → **`had bought`** and `yesterday` → **`the previous day`**!',
    'Simple Past (`V2`) Indirect में Past Perfect (`had + V3`) बनता है और `yesterday` बदलकर `the previous day` हो जाता है।',
    'Simple Past (`bought`) backshifts to Past Perfect (`had bought`), and `yesterday` shifts to `the previous day`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, EXAM_ONLY) — Modal ought to
  (
    '10000006-0004-4000-8000-000000000022', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Modal ought to', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'सही Modal चुनें: We ___ to respect our teachers.',
    'Choose the exact modal: We ___ to respect our teachers.',
    $json$[{"key":"A","text_hi":"should","text_en":"should"},{"key":"B","text_hi":"must","text_en":"must"},{"key":"C","text_hi":"ought","text_en":"ought"},{"key":"D","text_hi":"can","text_en":"can"}]$json$::jsonb, 'C',
    'खाली जगह के ठीक बाद `to` लिखा हुआ है!',
    'Notice the word `to` right after the blank!',
    'इन विकल्पों में केवल **`ought`** अपने साथ `to` लेता है (*We ought to respect our teachers.*)।',
    'Among these modals, only **`ought`** pairs with `to` (`ought to`).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, EXAM_ONLY) — Present Perfect Passive
  (
    '10000006-0004-4000-8000-000000000023', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Present Perfect Passive', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'सही Passive Voice चुनें: "He has completed the homework."',
    'Choose the exact Passive Voice of: "He has completed the homework."',
    $json$[{"key":"A","text_hi":"The homework has been completed by him.","text_en":"The homework has been completed by him."},{"key":"B","text_hi":"The homework has completed by him.","text_en":"The homework has completed by him."},{"key":"C","text_hi":"The homework was completed by him.","text_en":"The homework was completed by him."},{"key":"D","text_hi":"The homework is being completed by him.","text_en":"The homework is being completed by him."}]$json$::jsonb, 'A',
    'Active में `has + V3` (Perfect) है → Passive में **`has been + V3`**!',
    'Perfect tense (`has + V3`) inserts **`been`** in Passive!',
    '**"The homework has been completed by him."** — Present Perfect Passive = `has/have + been + V3`।',
    '**"The homework has been completed by him."** — Present Perfect Passive uses `has been + V3`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, EXAM_ONLY) — Narration Wh-Question
  (
    '10000006-0004-4000-8000-000000000024', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Narration Wh-Question', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'सही Indirect Speech चुनें: The teacher said to Ravi, "Where do you live?"',
    'Choose the exact Indirect Speech: The teacher said to Ravi, "Where do you live?"',
    $json$[{"key":"A","text_hi":"The teacher asked Ravi where did he live.","text_en":"The teacher asked Ravi where did he live."},{"key":"B","text_hi":"The teacher asked Ravi where he lived.","text_en":"The teacher asked Ravi where he lived."},{"key":"C","text_hi":"The teacher asked Ravi that where he lived.","text_en":"The teacher asked Ravi that where he lived."},{"key":"D","text_hi":"The teacher told Ravi where he lives.","text_en":"The teacher told Ravi where he lives."}]$json$::jsonb, 'B',
    'Wh-प्रश्न के Indirect में `that` नहीं लगता, `do/did` हटता है, और सीधा बयान क्रम (`where he lived`) आता है!',
    'In Indirect Wh-questions, drop `that` and `do/did`, and use statement order (`where he lived`)!',
    '**"The teacher asked Ravi where he lived."** — सीधा बयान क्रम (`he lived`) और `that` का लोप।',
    '**"The teacher asked Ravi where he lived."** — statement order (`he lived`), no `that` or `did`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- SHORT_2M (BOARD, PRACTICE) — Modal Distinction may vs must
  (
    '10000006-0004-4000-8000-000000000025', 'skill-eng-foundation', 'skill-eng-f-ch4', 'Modal Distinction may vs must', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    '`should` और `must` के प्रयोग में अंतर एक-एक उदाहरण सहित समझाएँ।',
    'Explain the difference between `should` and `must` with one clear example each.',
    NULL, NULL,
    'सलाह/नैतिक सुझाव (`should`) बनाम अनिवार्य नियम/बाध्यता (`must`) स्पष्ट लिखें।',
    'Contrast gentle advice (`should`) against strict necessity/law (`must`) with one example each.',
    NULL,
    NULL,
    '1. **`should` (सलाह / नैतिक सुझाव):** जब किसी को अच्छी सलाह या सामान्य कर्तव्य बताया जाए।
   - उदाहरण: *You **should** wake up early and revise daily.*
2. **`must` (अनिवार्य नियम / सख्त ज़रूरत):** जब काम करना कानूनन या अत्यंत आवश्यक हो।
   - उदाहरण: *We **must** obey traffic rules.*',
    '1. **`should` (Advice / Moral Suggestion):** Used to give helpful advice or gentle duty.
   - Example: *You **should** wake up early and revise daily.*
2. **`must` (Strong Obligation / Law):** Used when an action is strictly necessary or mandatory.
   - Example: *We **must** obey traffic rules.*',
    $json$[{"cue_hi":"should = अच्छी सलाह","cue_en":"should = friendly advice"},{"cue_hi":"must = सख्त नियम / अनिवार्यता","cue_en":"must = strict duty / law"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"should का अर्थ व शुद्ध उदाहरण","criterion_en":"Accurate meaning + example for `should`"},{"step_no":2,"marks":1,"criterion_hi":"must का अर्थ व शुद्ध उदाहरण","criterion_en":"Accurate meaning + example for `must`"}]$json$::jsonb,
    NULL,
    true
  ),
  -- LONG_5M (BOARD, PRACTICE) — BSEB 5M Voice & Narration Conversion
  (
    '10000006-0004-4000-8000-000000000026', 'skill-eng-foundation', 'skill-eng-f-ch4', 'BSEB 5M Voice & Narration Conversion', 'PRACTICE', 'LONG_5M', 'BOARD', 'BSEB 2024',
    'निर्देशानुसार निम्नलिखित 5 वाक्यों को बदलें (5 अंक):
1. (Passive में बदलें) She is singing a song.
2. (Passive में बदलें) Help the poor.
3. (Passive में बदलें) I know him well.
4. (Indirect Speech में बदलें) Mohan said to me, "I will go to Patna tomorrow."
5. (Indirect Speech में बदलें) He said to her, "Do you like tea?"',
    'Transform the following 5 sentences as directed (5 marks):
1. (Change to Passive) She is singing a song.
2. (Change to Passive) Help the poor.
3. (Change to Passive) I know him well.
4. (Change to Indirect Speech) Mohan said to me, "I will go to Patna tomorrow."
5. (Change to Indirect Speech) He said to her, "Do you like tea?"',
    NULL, NULL,
    'Voice में `being / Let / known to` और Narration में `told / would / the next day / asked ... if` जाँचें!',
    'Check `being / Let / known to` for Voice and `told / would / the next day / asked ... if` for Narration!',
    NULL,
    NULL,
    '1. **A song is being sung by her.** *(Present Continuous Passive: `is being + V3`)*
2. **Let the poor be helped.** *(या: The poor should be helped.)*
3. **He is known well to me.** *(ध्यान दें: `known to`, न कि `known by`!)*
4. **Mohan told me that he would go to Patna the next day.** *(`said to → told`, `will → would`, `tomorrow → the next day`)*
5. **He asked her if she liked tea.** *(`asked + if`, `you → she`, `like → liked`, अंत में `.`!)*',
    '1. **A song is being sung by her.** *(Present Continuous Passive: `is being + V3`)*
2. **Let the poor be helped.** *(Or: The poor should be helped.)*
3. **He is known well to me.** *(`known to`, never `known by`!)*
4. **Mohan told me that he would go to Patna the next day.**
5. **He asked her if she liked tea.**',
    $json$[{"cue_hi":"singing → is being sung","cue_en":"singing → is being sung"},{"cue_hi":"Imperative → Let ... be + V3","cue_en":"Imperative → Let ... be + V3"},{"cue_hi":"know → known to","cue_en":"know → known to"},{"cue_hi":"will → would · tomorrow → the next day · Do you → if she + V2","cue_en":"will → would · tomorrow → the next day · Do you → if she + V2"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"वाक्य 1: is being sung by her","criterion_en":"Sentence 1: is being sung by her"},{"step_no":2,"marks":1,"criterion_hi":"वाक्य 2: Let the poor be helped","criterion_en":"Sentence 2: Let the poor be helped"},{"step_no":3,"marks":1,"criterion_hi":"वाक्य 3: known to me का सही प्रयोग","criterion_en":"Sentence 3: accurate `known to me`"},{"step_no":4,"marks":1,"criterion_hi":"वाक्य 4: told + would + the next day","criterion_en":"Sentence 4: told + would + the next day"},{"step_no":5,"marks":1,"criterion_hi":"वाक्य 5: asked her if she liked tea.","criterion_en":"Sentence 5: asked her if she liked tea."}]$json$::jsonb,
    NULL,
    true
  )
ON CONFLICT (id) DO UPDATE SET
  subject_id          = EXCLUDED.subject_id,
  chapter_id          = EXCLUDED.chapter_id,
  topic_tag           = EXCLUDED.topic_tag,
  bank_pool           = EXCLUDED.bank_pool,
  question_type       = EXCLUDED.question_type,
  difficulty_tier     = EXCLUDED.difficulty_tier,
  exam_year_tag       = EXCLUDED.exam_year_tag,
  q_hi                = EXCLUDED.q_hi,
  q_en                = EXCLUDED.q_en,
  options_json        = EXCLUDED.options_json,
  correct_option      = EXCLUDED.correct_option,
  clue_hi             = EXCLUDED.clue_hi,
  clue_en             = EXCLUDED.clue_en,
  explanation_hi      = EXCLUDED.explanation_hi,
  explanation_en      = EXCLUDED.explanation_en,
  model_answer_hi     = EXCLUDED.model_answer_hi,
  model_answer_en     = EXCLUDED.model_answer_en,
  memory_cues_json    = EXCLUDED.memory_cues_json,
  marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json   = EXCLUDED.visual_asset_json,
  is_published        = EXCLUDED.is_published;

-- #############################################################################
-- UNIT 5 OF 5: skill-eng-f-ch5 — BOARD WRITING MASTERY: APPLICATIONS, LETTERS, ESSAYS & UNSEEN PASSAGES
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-eng-f-ch5',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: बोर्ड लेखन महारत (20 पक्के अंक)",
  "title_en": "30-Second Mindmap: Board Writing Mastery (20 Guaranteed Marks)",
  "read_time_seconds": 30,
  "central_node": {
    "id": "u5-root",
    "label_hi": "बोर्ड लेखन = 20 पक्के अंक",
    "label_en": "Board Writing = 20 Guaranteed Marks",
    "subtitle_hi": "आवेदन (5M) + निबंध (5–8M) + अपठित गद्यांश (7–12M) = आसान जीत!",
    "subtitle_en": "Application (5M) + Essay (5–8M) + Unseen Passage (7–12M) = Guaranteed Score!"
  },
  "branches": [
    {
      "id": "u5-b1",
      "label_hi": "1. एक आवेदन ढाँचा = 10 सवाल हल! (5 अंक)",
      "label_en": "1. One Application Skeleton = 10 Questions Solved! (5M)",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "u5-b1-c1",
          "label_hi": "To, The Principal + Date + Subject (1 अंक)",
          "label_en": "To, The Principal + Date + Subject (1 Mark)"
        },
        {
          "id": "u5-b1-c2",
          "label_hi": "Respected Sir + केवल 2-लाइन कारण बदलें! (2.5 अंक)",
          "label_en": "Respected Sir + Swap ONLY 2 middle lines! (2.5 Marks)"
        },
        {
          "id": "u5-b1-c3",
          "label_hi": "Yours obediently (बिना apostrophe!) + Name/Class/Roll (1.5 अंक)",
          "label_en": "Yours obediently (NO apostrophe!) + Name/Class/Roll (1.5 Marks)"
        }
      ]
    },
    {
      "id": "u5-b2",
      "label_hi": "2. अनौपचारिक पत्र (पिताजी / मित्र को)",
      "label_en": "2. Informal Letter (Father / Friend)",
      "color": "#059669",
      "children": [
        {
          "id": "u5-b2-c1",
          "label_hi": "Examination Hall + Date → Dear Father → \"I am fine here...\" → Yours affectionately",
          "label_en": "Examination Hall + Date → Dear Father → \"I am fine here...\" → Yours affectionately"
        }
      ]
    },
    {
      "id": "u5-b3",
      "label_hi": "3. 3-बॉक्स आसान निबंध (5–8 अंक)",
      "label_en": "3. 3-Box Easy Essay Blueprint (5–8M)",
      "color": "#D97706",
      "children": [
        {
          "id": "u5-b3-c1",
          "label_hi": "Box 1: Introduction (2–3 वाक्य) → Box 2: 3 आसान बिंदु → Box 3: Conclusion (2 वाक्य)",
          "label_en": "Box 1: Intro (2–3 lines) → Box 2: 3 Key Points → Box 3: Conclusion (2 lines)"
        }
      ]
    },
    {
      "id": "u5-b4",
      "label_hi": "4. 3-कदम अपठित गद्यांश (Unseen Passage)",
      "label_en": "4. 3-Step Unseen Passage Keyword Match",
      "color": "#7C3AED",
      "children": [
        {
          "id": "u5-b4-c1",
          "label_hi": "पहले प्रश्न पढ़ें → कीवर्ड पर गोला → गद्यांश में वही शब्द ढूँढ़कर सही Tense में लिखें!",
          "label_en": "Read Questions First → Circle Keyword → Match Line & Write in Same Tense!"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "u5-sec-1-application-skeleton",
    "order": 1,
    "heading_hi": "1. एक जादुई प्रधानाचार्य आवेदन ढाँचा — जो बिहार बोर्ड के 10 सवाल हल करता है!",
    "heading_en": "1. ONE Master Principal Application Skeleton — Solves 10 BSEB Questions!",
    "analogy_hi": "सोचिए आपके पास एक ऐसी **मास्टर चाबी** है जिससे 10 ताले खुल जाते हैं! बिहार बोर्ड में हर साल प्रधानाचार्य को आवेदन पत्र (5 अंक) आता है — कभी बीमारी की छुट्टी, कभी फ़ीस माफ़ी, कभी TC, कभी पुस्तकालय की किताबें! आपको 10 अलग पत्र रटने की कोई ज़रूरत नहीं है — बस **नीचे दिया गया 1 साफ ढाँचा याद कर लीजिए और बीच की केवल 2 पंक्तियाँ बदल दीजिए!**",
    "analogy_en": "Imagine owning ONE master key that unlocks 10 doors! Every year, BSEB awards 5 easy marks for a Principal Application — Sick Leave, Fee Concession, TC, Character Certificate, or Library Books. Never memorize 10 separate letters: memorize **ONE crisp skeleton below and swap ONLY the 2 middle lines!**",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "5-अंक प्रधानाचार्य आवेदन पत्र का सटीक बिहार बोर्ड लेआउट बॉक्स",
      "title_en": "Exact BSEB 5-Mark Principal Application Layout Box (With Marking Scheme)",
      "caption_hi": "बिहार बोर्ड परीक्षक इसी 3-भाग अंक-योजना से नंबर देते हैं: Format व Subject (1 अंक) + मुख्य भाग Body (2.5 अंक) + समापन Subscription (1.5 अंक) = पूरे 5/5 अंक!",
      "caption_en": "BSEB examiners grade strictly on this 3-part rubric: Format & Subject (1M) + Body (2.5M) + Closing Subscription (1.5M) = Full 5/5 Marks!",
      "viewBox": "0 0 680 345",
      "elements": [
        {
          "kind": "rect",
          "x": 24,
          "y": 14,
          "width": 440,
          "height": 316,
          "rx": 10,
          "fill": "#FFFFFF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 38,
          "y": 26,
          "width": 412,
          "height": 84,
          "rx": 6,
          "fill": "#EFF6FF",
          "stroke": "#2563EB",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 50,
          "y": 46,
          "text_hi": "To, The Principal, [School Name], [District]",
          "text_en": "To, The Principal, [School Name], [District]",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "label",
          "x": 50,
          "y": 74,
          "text_hi": "Date: 15 February 2026",
          "text_en": "Date: 15 February 2026",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "start",
          "bold": false
        },
        {
          "kind": "label",
          "x": 50,
          "y": 98,
          "text_hi": "Subject: Application for [___Swap Topic___].",
          "text_en": "Subject: Application for [___Swap Topic___].",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 38,
          "y": 120,
          "width": 412,
          "height": 114,
          "rx": 6,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 50,
          "y": 140,
          "text_hi": "Respected Sir / Madam,",
          "text_en": "Respected Sir / Madam,",
          "fill": "#92400E",
          "fontSize": 12,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "label",
          "x": 50,
          "y": 166,
          "text_hi": "Most humbly I beg to state that I am a student of Class X.",
          "text_en": "Most humbly I beg to state that I am a student of Class X.",
          "fill": "#78350F",
          "fontSize": 11,
          "anchor": "start",
          "bold": false
        },
        {
          "kind": "label",
          "x": 50,
          "y": 192,
          "text_hi": "[2-LINE REASON SWAP SLOT — Sick / Fee / TC / Library]",
          "text_en": "[2-LINE REASON SWAP SLOT — Sick / Fee / TC / Library]",
          "fill": "#DC2626",
          "fontSize": 11,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "label",
          "x": 50,
          "y": 218,
          "text_hi": "Therefore, kindly grant my request. I shall be grateful to you.",
          "text_en": "Therefore, kindly grant my request. I shall be grateful to you.",
          "fill": "#78350F",
          "fontSize": 11,
          "anchor": "start",
          "bold": false
        },
        {
          "kind": "rect",
          "x": 38,
          "y": 244,
          "width": 412,
          "height": 74,
          "rx": 6,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 50,
          "y": 264,
          "text_hi": "Thanking you,",
          "text_en": "Thanking you,",
          "fill": "#065F46",
          "fontSize": 11,
          "anchor": "start",
          "bold": false
        },
        {
          "kind": "label",
          "x": 50,
          "y": 286,
          "text_hi": "Yours obediently,  (No apostrophe in Yours!)",
          "text_en": "Yours obediently,  (No apostrophe in Yours!)",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "label",
          "x": 50,
          "y": 308,
          "text_hi": "Name: X.Y.Z.  |  Class: X  |  Roll No.: 12",
          "text_en": "Name: X.Y.Z.  |  Class: X  |  Roll No.: 12",
          "fill": "#047857",
          "fontSize": 11,
          "anchor": "start",
          "bold": false
        },
        {
          "kind": "arrow",
          "x1": 454,
          "y1": 68,
          "x2": 492,
          "y2": 68,
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 496,
          "y": 40,
          "width": 162,
          "height": 56,
          "rx": 8,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 577,
          "y": 64,
          "text_hi": "1 अंक: पता व विषय",
          "text_en": "1 Mark: Format/Sub",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 454,
          "y1": 176,
          "x2": 492,
          "y2": 176,
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 496,
          "y": 148,
          "width": 162,
          "height": 56,
          "rx": 8,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 577,
          "y": 172,
          "text_hi": "2.5 अंक: मुख्य भाग",
          "text_en": "2.5 Marks: Body",
          "fill": "#92400E",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 454,
          "y1": 280,
          "x2": 492,
          "y2": 280,
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 496,
          "y": 252,
          "width": 162,
          "height": 56,
          "rx": 8,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 577,
          "y": 276,
          "text_hi": "1.5 अंक: समापन",
          "text_en": "1.5 Marks: Closing",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### पूरा मास्टर ढाँचा (केवल 1 बार याद करें — 10 सवाल पक्के!)\n```text\nTo,\nThe Principal,\nU.H.S. Kaparpura,\nMuzaffarpur (Bihar)\n\nDate: 15 February 2026\n\nSubject: Application for [विषय यहाँ लिखें]\n\nRespected Sir,\nMost humbly and respectfully I beg to state that I am a regular student of Class X in your school. [यहाँ नीचे तालिका से केवल 2 पंक्तियाँ डालें!] Therefore, I kindly request you to grant my prayer.\n\nI shall remain ever grateful to you for this act of kindness.\n\nThanking you,\nYours obediently,\nName: Ravi Kumar (या परीक्षा में X.Y.Z.)\nClass: X, Roll No.: 12\n```",
    "concept_md_en": "### Complete Master Skeleton (Memorize Once — Solve 10 Questions!)\n```text\nTo,\nThe Principal,\nU.H.S. Kaparpura,\nMuzaffarpur (Bihar)\n\nDate: 15 February 2026\n\nSubject: Application for [Insert Topic Here]\n\nRespected Sir,\nMost humbly and respectfully I beg to state that I am a regular student of Class X in your school. [Insert ONLY the 2-line Reason Slot from the table below!] Therefore, I kindly request you to grant my request.\n\nI shall remain ever grateful to you for this act of kindness.\n\nThanking you,\nYours obediently,\nName: X.Y.Z.\nClass: X, Roll No.: 12\n```",
    "exam_tip_hi": "सबसे बड़ी गलती जिससे पूरे 1 अंक कटते हैं: कभी भी **`Your's`** (apostrophe लगाकर) मत लिखिए! सही स्पेलिंग हमेशा **`Yours obediently`** है — बिना किसी कॉमा/अपॉस्ट्रॉफी के!",
    "exam_tip_en": "Never lose an easy mark on spelling: ALWAYS write **`Yours obediently`** WITHOUT an apostrophe (NEVER `Your's`)!",
    "glossary_terms": [
      {
        "term_hi": "अभिवादन (Salutation)",
        "term_en": "Salutation",
        "pronunciation_hi": "सैल्यूटेशन",
        "definition_hi": "पत्र की सम्मानजनक शुरुआत, जैसे प्रधानाचार्य के लिए \"Respected Sir / Madam,\" और मित्र/पिता के लिए \"Dear Father,\"।",
        "definition_en": "The polite opening greeting of a letter, e.g., \"Respected Sir,\" (formal) or \"Dear Father,\" (informal)."
      },
      {
        "term_hi": "समापन / हस्ताक्षर (Subscription)",
        "term_en": "Subscription",
        "pronunciation_hi": "सब्सक्रिप्शन",
        "definition_hi": "पत्र के अंत का विनम्र समापन, जैसे \"Yours obediently,\" (आवेदन) या \"Yours affectionately,\" (परिवार)।",
        "definition_en": "The polite closing sign-off at the bottom of a letter, e.g., \"Yours obediently,\" or \"Yours affectionately,\"."
      }
    ],
    "quick_check": {
      "q_hi": "प्रधानाचार्य को आवेदन के अंत में इनमें से कौन-सा समापन 100% शुद्ध है? (Your's obediently / Yours obediently / Yours lovingly)",
      "q_en": "Which closing is 100% right for a Principal Application? (Your's obediently / Yours obediently / Yours lovingly)",
      "answer_hi": "**Yours obediently** (बिना apostrophe के; `Yours lovingly` केवल परिवार/मित्रों के लिए है!)",
      "answer_en": "**Yours obediently** (NO apostrophe; `Yours lovingly` is strictly for family/friends!)"
    }
  },
  {
    "id": "u5-sec-2-ten-swap-bank",
    "order": 2,
    "heading_hi": "2. 10 बिहार बोर्ड आवेदन विषयों का \"2-लाइन स्वैप बैंक\" + पिताजी/मित्र को पत्र",
    "heading_en": "2. The \"2-Line Swap Bank\" for Top BSEB Applications + Informal Letters",
    "analogy_hi": "जैसे एक ही मोबाइल में बस SIM कार्ड बदलने से नया नंबर चालू हो जाता है, ठीक वैसे ही हमारे ऊपर वाले मास्टर आवेदन में नीचे दी गई तालिका की **सिर्फ 2 पंक्तियाँ** डालते ही नया आवेदन 30 सेकंड में तैयार हो जाता है!",
    "analogy_en": "Just like swapping a SIM card in the same phone, simply drop ONE 2-line slot from the table below into the master skeleton above and any BSEB application is ready in 30 seconds!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "6 सबसे अधिक पूछे जाने वाले BSEB आवेदन — Subject व 2-लाइन स्वैप बैंक",
      "title_en": "Top 6 BSEB Applications — Ready Subject & 2-Line Body Swap Bank",
      "caption_hi": "यही ट्रिक खेल सामग्री (Sports), साइकिल स्टैंड, जल-व्यवस्था या बहन की शादी की छुट्टी पर भी हूबहू लागू होती है!",
      "caption_en": "The exact same 2-line swap works for Sports Equipment, Sister's Marriage Leave, Drinking Water, or Extra Classes!",
      "headers_hi": [
        "बोर्ड प्रश्न विषय",
        "Subject पंक्ति",
        "केवल ये 2 पंक्तियाँ बीच में डालें"
      ],
      "headers_en": [
        "BSEB Exam Topic",
        "Exact Subject Line",
        "Swap ONLY These 2 Body Lines"
      ],
      "rows": [
        {
          "cells_hi": [
            "1. बीमारी की छुट्टी (Sick Leave)",
            "Application for three days' sick leave.",
            "I have been suffering from high fever since last night. The doctor has advised me complete rest for three days (15 to 17 Feb)."
          ],
          "cells_en": [
            "1. Sick Leave",
            "Application for three days' sick leave.",
            "I have been suffering from high fever since last night. The doctor has advised me complete rest for three days."
          ]
        },
        {
          "cells_hi": [
            "2. शुल्क माफ़ी (Fee Concession)",
            "Application for full fee concession.",
            "My father is a poor farmer with a large family to support. He cannot pay my school fees, though I am a hardworking student."
          ],
          "cells_en": [
            "2. Fee Concession",
            "Application for full fee concession.",
            "My father is a poor farmer with a large family to support. He cannot pay my school fees, though I study very sincerely."
          ]
        },
        {
          "cells_hi": [
            "3. स्थानांतरण प्रमाणपत्र (TC / SLC)",
            "Application for Transfer Certificate (TC).",
            "My father has been transferred to Patna this month. Therefore, I need my School Leaving Certificate to take admission there."
          ],
          "cells_en": [
            "3. Transfer Certificate (TC)",
            "Application for Transfer Certificate (TC).",
            "My father has been transferred to Patna this month. Therefore, I need my Transfer Certificate to join a new school there."
          ]
        },
        {
          "cells_hi": [
            "4. पुस्तकालय से किताबें (Library Books)",
            "Application for issuing library books.",
            "I am preparing sincerely for the upcoming board examination. Kindly issue me two English and Science reference books from the school library."
          ],
          "cells_en": [
            "4. Library Book Issue",
            "Application for issuing library books.",
            "I am preparing sincerely for the upcoming board examination. Kindly issue me two reference books from the school library."
          ]
        },
        {
          "cells_hi": [
            "5. चरित्र प्रमाणपत्र (Character Cert.)",
            "Application for Character Certificate.",
            "I have passed my Class 10 board examination from your school with good marks. I urgently need a Character Certificate for college admission."
          ],
          "cells_en": [
            "5. Character Certificate",
            "Application for Character Certificate.",
            "I have passed my Class 10 examination from your school. I urgently need a Character Certificate for higher admission."
          ]
        },
        {
          "cells_hi": [
            "6. बहन की शादी / ज़रूरी काम की छुट्टी",
            "Application for four days' leave.",
            "My elder sister's marriage is fixed for 20 February. As I have to help my parents at home, I cannot attend school for four days."
          ],
          "cells_en": [
            "6. Sister's Marriage / Urgent Leave",
            "Application for four days' leave.",
            "My elder sister's marriage is fixed for 20 February. I have to help my family at home, so kindly grant me four days' leave."
          ]
        }
      ]
    },
    "concept_md_hi": "### पिताजी या मित्र को अनौपचारिक पत्र (Informal Letter — 5 अंक) का आसान ढाँचा\n- **दाएँ/बाएँ ऊपर:** `Examination Hall, Patna` + `Date: 15 February 2026`\n- **संबोधन:** `My dear Father,` या `My dear Friend Ravi,`\n- **शुरुआती जादुई पंक्ति (हर अनौपचारिक पत्र में चलती है!):** *\"I am quite well here and hope you are also fine by the grace of God. I am writing this letter to tell you that...\"*\n- **मुख्य विषय (3–4 सरल वाक्य):** (जैसे किताबों के लिए ₹500 मँगाना / परीक्षा की तैयारी बताना / छुट्टियों में गाँव बुलाना)\n- **समापन:** `Convey my regards to Mother and love to younger ones.` → **`Yours affectionately,`** (पिताजी के लिए) या **`Yours sincerely,`** (मित्र के लिए) + नाम।",
    "concept_md_en": "### Easy Informal Letter Blueprint (To Father or Friend — 5 Marks)\n- **Top Corner:** `Examination Hall, Patna` + `Date: 15 February 2026`\n- **Salutation:** `My dear Father,` or `My dear Friend Ravi,`\n- **Universal Opening Line:** *\"I am quite well here and hope you are also fine. I am writing this letter to inform you that...\"*\n- **Body (3–4 short clear sentences):** Request money for books / Share exam preparation / Invite to village festival.\n- **Closing:** `Convey my regards to elders.` → **`Yours affectionately,`** (family) or **`Yours sincerely,`** (friend) + Name.",
    "exam_tip_hi": "अनौपचारिक पत्र (पिताजी/मित्र) में **`Subject:` कभी नहीं लिखा जाता!** `Subject:` केवल औपचारिक आवेदन पत्र (Principal / Editor / Officer) में लिखा जाता है।",
    "exam_tip_en": "NEVER write a **`Subject:`** line in an Informal Letter (to Father/Friend)! `Subject:` is strictly for Formal Applications and Official Letters.",
    "glossary_terms": [
      {
        "term_hi": "अनौपचारिक पत्र (Informal Letter)",
        "term_en": "Informal Letter",
        "pronunciation_hi": "इनफ़ॉर्मल लेटर",
        "definition_hi": "माता-पिता, भाई-बहन या मित्रों को लिखा जाने वाला व्यक्तिगत पत्र (इसमें Subject नहीं होता)।",
        "definition_en": "A personal letter written to family or friends (has NO Subject line)."
      }
    ],
    "quick_check": {
      "q_hi": "क्या पिताजी को किताबों के लिए पैसे मँगाने वाले पत्र में `Subject:` लिखना चाहिए?",
      "q_en": "Should you write a `Subject:` line in a letter to your father asking for book money?",
      "answer_hi": "**नहीं!** पिताजी को लिखा पत्र Informal Letter है — इसमें `Subject:` नहीं लिखा जाता।",
      "answer_en": "**No!** A letter to your father is an Informal Letter and does not include a `Subject:` line."
    }
  },
  {
    "id": "u5-sec-3-easy-essay",
    "order": 3,
    "heading_hi": "3. 3-बॉक्स आसान निबंध (Easy Essay) फॉर्मूला — बिना रटे 5/5 अंक!",
    "heading_en": "3. The 3-Box Easy Essay Formula — Score Full Marks Without Rote!",
    "analogy_hi": "एक लंबा अंग्रेज़ी निबंध देखकर कभी मत घबराइए! उसे बिहार की एक **साफ़-सुथरी थाली के 3 खानों** में बाँट दीजिए: **खाना 1 (Introduction — 2–3 छोटे वाक्य):** विषय क्या है? **खाना 2 (Body — 3 सरल विचार):** इसके लाभ, दैनिक जीवन में भूमिका और समाज पर प्रभाव (6–7 वाक्य)। **खाना 3 (Conclusion — 2 प्रेरक वाक्य):** सकारात्मक संदेश!",
    "analogy_en": "Never fear a 150-word English essay! Divide it into **3 clean boxes**: **Box 1 (Introduction — 2–3 short sentences)** defining the topic; **Box 2 (Body — 3 simple bullet ideas expanded into 6–7 clean sentences)** covering benefits, impact, and duties; **Box 3 (Conclusion — 2 positive closing lines)**!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "3-बॉक्स आसान निबंध निर्माण विधि (120–150 शब्द)",
      "title_en": "3-Box Easy Essay Blueprint (120–150 Words)",
      "caption_hi": "हर पैराग्राफ के बीच 1 खाली पंक्ति छोड़ें और छोटे, शुद्ध S+V+O वाक्य लिखें — परीक्षक साफ-सुथरे 3 पैराग्राफ देखकर तुरंत पूरे अंक देते हैं!",
      "caption_en": "Leave 1 clean line between the 3 paragraphs and write short, accurate S+V+O sentences — examiners reward clear structure immediately!",
      "direction": "TB",
      "steps": [
        {
          "id": "es-1",
          "label_hi": "बॉक्स 1: परिचय (Introduction — 1 अंक · 2–3 वाक्य)",
          "label_en": "Box 1: Introduction (1 Mark · 2–3 Simple Sentences)",
          "detail_hi": "जादुई शुरुआत: \"[Topic] plays a very important role in our daily life. Every student should understand its true value.\"",
          "detail_en": "Reusable opener: \"[Topic] plays a very important role in our daily life. Every student should understand its true value.\"",
          "accent": "indigo"
        },
        {
          "id": "es-2",
          "label_hi": "बॉक्स 2: मुख्य विचार — 3 आसान बिंदु (Body — 3 अंक · 6–8 वाक्य)",
          "label_en": "Box 2: Body — 3 Bullet Ideas Expanded (3 Marks · 6–8 Sentences)",
          "detail_hi": "बिंदु 1: क्यों ज़रूरी है? · बिंदु 2: विद्यार्थी/देश को क्या लाभ? · बिंदु 3: हमारा कर्तव्य क्या है?",
          "detail_en": "Point 1: Why it matters · Point 2: Benefits to students & society · Point 3: Our duty & action",
          "accent": "amber"
        },
        {
          "id": "es-3",
          "label_hi": "बॉक्स 3: निष्कर्ष (Conclusion — 1 अंक · 2 वाक्य)",
          "label_en": "Box 3: Conclusion (1 Mark · 2 Strong Closing Sentences)",
          "detail_hi": "जादुई अंत: \"In short, [Topic] is the key to a bright and peaceful future. We must always respect and practise it.\"",
          "detail_en": "Reusable closer: \"In short, [Topic] is the key to a bright and peaceful future. We must always practise it.\"",
          "accent": "emerald"
        }
      ],
      "edges": [
        {
          "from": "es-1",
          "to": "es-2",
          "label_hi": "1 लाइन छोड़ें",
          "label_en": "Leave 1 blank line"
        },
        {
          "from": "es-2",
          "to": "es-3",
          "label_hi": "1 लाइन छोड़ें",
          "label_en": "Leave 1 blank line"
        }
      ]
    },
    "concept_md_hi": "### अच्छे बनाम समस्या वाले निबंध के लिए 2 जादुई वाक्य पैक\n1. **सकारात्मक विषयों के लिए (*Discipline, Education, Importance of Trees, My Aim in Life, Sports*):**\n   - *\"[Topic] is a priceless gift for human life.\"* (अनमोल उपहार)\n   - *\"It makes us strong, confident, and successful.\"* (मज़बूत और सफल बनाता है)\n2. **समस्या वाले विषयों के लिए (*Pollution, Unemployment, Terrorism, Corruption*):**\n   - *\"[Topic] is one of the biggest problems in the modern world.\"* (सबसे बड़ी समस्या)\n   - *\"The government and citizens must work together to solve it.\"* (सरकार और नागरिकों को मिलकर हल निकालना होगा)",
    "concept_md_en": "### 2 Ready-Made Sentence Packs for Positive vs Problem Essays\n1. **For Positive Topics (*Discipline, Education, Trees, Sports, My Aim in Life*):**\n   - *\"[Topic] is a priceless gift for human life.\"*\n   - *\"It builds character and leads a nation toward progress.\"*\n2. **For Problem Topics (*Pollution, Unemployment, Corruption*):**\n   - *\"[Topic] is one of the most serious problems in the modern world.\"*\n   - *\"Both the government and responsible citizens must unite to solve it.\"*",
    "exam_tip_hi": "लंबे-लंबे जटिल वाक्य लिखने के चक्कर में व्याकरण की गलतियाँ मत करें! **छोटे, सरल, शुद्ध वाक्य (8–12 शब्द प्रति वाक्य)** लिखना बिहार बोर्ड में सबसे ज़्यादा अंक दिलाता है!",
    "exam_tip_en": "Never write risky 30-word tangled sentences! Short, crystal-clear 8–12 word sentences with zero grammar mistakes score the highest marks in BSEB!",
    "glossary_terms": [
      {
        "term_hi": "परिचय (Introduction)",
        "term_en": "Introduction",
        "pronunciation_hi": "इंट्रोडक्शन",
        "definition_hi": "निबंध का पहला छोटा पैराग्राफ जो विषय का सीधा अर्थ व महत्व बताता है।",
        "definition_en": "The opening paragraph of an essay that defines the topic and its importance."
      },
      {
        "term_hi": "निष्कर्ष (Conclusion)",
        "term_en": "Conclusion",
        "pronunciation_hi": "कन्क्लूज़न",
        "definition_hi": "निबंध का अंतिम छोटा पैराग्राफ जो मुख्य संदेश को सकारात्मक रूप से समेटता है।",
        "definition_en": "The final closing paragraph that summarizes the main takeaway positively."
      }
    ],
    "quick_check": {
      "q_hi": "निबंध को एक ही बड़े पैराग्राफ में लिखना बेहतर है या 3 छोटे साफ पैराग्राफ (Intro + Body + Conclusion) में?",
      "q_en": "Should an essay be written as one giant block or 3 clear paragraphs (Intro + Body + Conclusion)?",
      "answer_hi": "**3 साफ पैराग्राफ (Introduction → Body → Conclusion)** — इससे प्रस्तुति और अंक दोनों बढ़ते हैं!",
      "answer_en": "**3 clear paragraphs (Introduction → Body → Conclusion)** — examiners award higher marks for clear organization!"
    }
  },
  {
    "id": "u5-sec-4-unseen-passage",
    "order": 4,
    "heading_hi": "4. अपठित गद्यांश (Unseen Passage) — 3-कदम कीवर्ड मिलान विधि (100% सटीक अंक!)",
    "heading_en": "4. Unseen Passage — The 3-Step Keyword-Match Method (Full Marks!)",
    "analogy_hi": "अपठित गद्यांश को **जासूस (Detective) के खज़ाना-खोज खेल** की तरह हल कीजिए! अगर गद्यांश में 5 कठिन अंग्रेज़ी शब्द नहीं भी आते तो ज़रा भी मत घबराइए — पहले **सवाल (Questions)** पढ़िए, मुख्य शब्द (**Keyword**) पर गोला लगाइए, और गद्यांश में ठीक वही शब्द ढूँढ़कर उत्तर की पंक्ति निकाल लीजिए!",
    "analogy_en": "Treat an Unseen Passage like a **Detective Keyword Hunt**! Even if 5 difficult vocabulary words are unfamiliar, NEVER panic — read the **Questions FIRST**, circle the **Keyword**, scan the passage for that exact clue, and write a crisp answer in the same tense!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "अपठित गद्यांश में 100% अंक पाने की 3-कदम जासूसी विधि",
      "title_en": "3-Step Detective Method to Score 100% in Unseen Passages",
      "caption_hi": "सबसे अहम नियम: प्रश्न में जो Tense है (is/was/did), उत्तर उसी Tense में लिखें — और कभी प्रश्न के शब्द जैसे \"did\" को उत्तर में न उतारें!",
      "caption_en": "Crucial Rule: Match the tense of the question (`did + V1` in question → `V2` in answer) — NEVER copy `did` into a positive answer!",
      "direction": "LR",
      "steps": [
        {
          "id": "up-1",
          "label_hi": "कदम 1: पहले प्रश्न पढ़ें व Keyword पहचानें",
          "label_en": "Step 1: Read Questions First & Circle Keywords",
          "detail_hi": "Who (व्यक्ति), When (समय), Where (स्थान), Why (कारण — because) पर ध्यान दें।",
          "detail_en": "Spot question type: Who (person), When (time), Where (place), Why (reason).",
          "accent": "indigo"
        },
        {
          "id": "up-2",
          "label_hi": "कदम 2: गद्यांश में वही Keyword ढूँढ़ें",
          "label_en": "Step 2: Scan Passage for the Matching Keyword Line",
          "detail_hi": "पूरी कहानी का अनुवाद करने में समय न गँवाएँ — सीधे मिलती हुई पंक्ति पर निशान लगाएँ।",
          "detail_en": "Do not panic over unknown words — locate the exact matching sentence line.",
          "accent": "amber"
        },
        {
          "id": "up-3",
          "label_hi": "कदम 3: सही Tense में सटीक उत्तर लिखें",
          "label_en": "Step 3: Write Clean Answer in Matching Tense",
          "detail_hi": "प्रश्न \"Where did Gandhi go?\" → उत्तर \"Gandhi went to Champaran.\" (did हटेगा, go → went!)",
          "detail_en": "Q: \"Where did Gandhi go?\" → A: \"Gandhi went to Champaran.\" (Drop `did`, use V2!)",
          "accent": "emerald"
        }
      ],
      "edges": [
        {
          "from": "up-1",
          "to": "up-2",
          "label_hi": "खोजें",
          "label_en": "Scan"
        },
        {
          "from": "up-2",
          "to": "up-3",
          "label_hi": "साफ लिखें",
          "label_en": "Write cleanly"
        }
      ]
    },
    "concept_md_hi": "### Wh-शब्दों का 1-सेकंड उत्तर सूत्र\n- **Who** (कौन) → व्यक्ति/संस्था का नाम लिखें।\n- **When** (कब) → तारीख, साल या समय लिखें।\n- **Where** (कहाँ) → स्थान का नाम लिखें।\n- **Why** (क्यों) → उत्तर में **`because`** लगाकर कारण लिखें।\n- **Give a suitable title (शीर्षक बताएँ):** जो शब्द गद्यांश में सबसे ज़्यादा बार आया है (2–4 शब्दों में), वही सबसे बढ़िया Title होता है!",
    "concept_md_en": "### 1-Second Wh-Word Answer Guide\n- **Who** → Write the person or group name.\n- **When** → Write the date, year, or time.\n- **Where** → Write the exact place.\n- **Why** → Give the reason using **`because`**.\n- **Suitable Title:** Pick the central repeated idea in 2–4 crisp capitalized words (e.g., *Importance of Trees*).",
    "exam_tip_hi": "अपठित गद्यांश के उत्तर में कभी प्रश्न से पूरा पैराग्राफ अंधाधुंध मत उतारें — केवल **1–2 सटीक पंक्तियाँ** लिखें जो सीधे प्रश्न का जवाब दें!",
    "exam_tip_en": "Never copy an entire 6-line paragraph blindly! Lift ONLY the **1–2 exact sentences** that directly answer the question.",
    "glossary_terms": [
      {
        "term_hi": "अपठित गद्यांश (Unseen Passage)",
        "term_en": "Unseen Passage",
        "pronunciation_hi": "अनसीन पैसेज",
        "definition_hi": "परीक्षा में दिया जाने वाला एक छोटा अनुच्छेद, जिसे पढ़कर उसके नीचे दिए गए प्रश्नों के उत्तर उसी में से लिखने होते हैं।",
        "definition_en": "A short comprehension paragraph given in the exam whose questions are answered directly from its text."
      },
      {
        "term_hi": "मुख्य संकेत शब्द (Keyword)",
        "term_en": "Keyword",
        "pronunciation_hi": "कीवर्ड",
        "definition_hi": "प्रश्न का वह सबसे खास नाम, वर्ष या क्रिया शब्द जो गद्यांश में सही उत्तर की पंक्ति तक तुरंत पहुँचाता है।",
        "definition_en": "The key name, date, or action word in a question that leads you straight to the answer line in the passage."
      }
    ],
    "quick_check": {
      "q_hi": "यदि गद्यांश में प्रश्न हो: \"When did India become independent?\" और गद्यांश में लिखा हो \"India became free on 15 August 1947.\" तो शुद्ध उत्तर क्या लिखेंगे?",
      "q_en": "Question: \"When did India become independent?\" Passage: \"India became free on 15 August 1947.\" Write the crisp answer.",
      "answer_hi": "**India became independent on 15 August 1947.** (`did` हटाकर `become` को V2 `became` किया!)",
      "answer_en": "**India became independent on 15 August 1947.** (Dropped `did` and switched `become` → `became`!)"
    }
  },
  {
    "id": "u5-sec-5-marking-formula",
    "order": 5,
    "heading_hi": "5. 20-अंक बोर्ड लेखन चेकलिस्ट व अंक-वितरण कार्ड",
    "heading_en": "5. 20-Mark Board Writing Checklist & Rubric Card",
    "analogy_hi": "जानना कि परीक्षक किस हिस्से पर कितने अंक देते हैं, आपकी आधी जीत पक्की कर देता है! नीचे पूरा बिहार बोर्ड अंक-वितरण सूत्र एक साथ देखें:",
    "analogy_en": "Knowing the exact examiner marking scheme guarantees step marks even under exam pressure! Review the complete BSEB rubric below:",
    "visual_diagram": {
      "type": "FORMULA_CARD",
      "title_hi": "बिहार बोर्ड लेखन खंड (20 अंक) का सटीक अंक-सूत्र",
      "title_en": "Exact BSEB Writing Section Marking Formulas (20 Marks)",
      "formulas": [
        {
          "latex": "\\text{Application (5M)} = 1\\text{M Format/Sub} + 2.5\\text{M Body} + 1.5\\text{M Closing}",
          "meaning_hi": "प्रधानाचार्य आवेदन पत्र अंक-योजना",
          "meaning_en": "Principal Application Marking Scheme",
          "example_hi": "To + Date + Subject (1M) · 2-line reason (2.5M) · Yours obediently (1.5M)",
          "example_en": "To + Date + Subject (1M) · 2-line reason (2.5M) · Yours obediently (1.5M)"
        },
        {
          "latex": "\\text{Essay (5M)} = 1\\text{M Intro} + 3\\text{M Body (3 Points)} + 1\\text{M Conclusion}",
          "meaning_hi": "आसान 3-बॉक्स निबंध अंक-योजना",
          "meaning_en": "3-Box Easy Essay Marking Scheme",
          "example_hi": "3 साफ पैराग्राफ · छोटे शुद्ध वाक्य · 120–150 शब्द",
          "example_en": "3 clean paragraphs · Short error-free sentences · 120–150 words"
        },
        {
          "latex": "\\text{Passage Answer} = \\text{Keyword Match} + \\text{Same Tense (Drop \"did\")}",
          "meaning_hi": "अपठित गद्यांश का 100% सटीक उत्तर सूत्र",
          "meaning_en": "Full-Mark Unseen Passage Answer Formula",
          "example_hi": "Why → because · When → date/year · Who → name",
          "example_en": "Why → because · When → date/year · Who → name"
        },
        {
          "latex": "\\text{Yours obediently} \\quad(\\text{NO apostrophe!})",
          "meaning_hi": "आवेदन समापन का अटल नियम",
          "meaning_en": "Golden Subscription Spelling Rule",
          "example_hi": "कभी \"Your's\" न लिखें — हमेशा \"Yours\" लिखें!",
          "example_en": "Never write \"Your's\" — ALWAYS write \"Yours\"!"
        }
      ]
    },
    "concept_md_hi": "### परीक्षा हॉल में अंतिम 2-मिनट चेकलिस्ट\n1. क्या आवेदन में **Date** और **Subject** स्पष्ट लिखा है?\n2. क्या समापन में **`Yours obediently`** बिना apostrophe के लिखा है?\n3. क्या निबंध कम से कम **3 अलग पैराग्राफ** में बँटा है?\n4. क्या अपठित गद्यांश के हर उत्तर में सही **Tense** और **Full Stop (.)** लगा है?",
    "concept_md_en": "### Final 2-Minute Exam Hall Checklist\n1. Did you include **Date** and **Subject** clearly in the Formal Application?\n2. Did you spell **`Yours obediently`** WITHOUT an apostrophe?\n3. Is your Essay neatly divided into **3 paragraphs**?\n4. Does every Unseen Passage answer match the question's tense and end with a full stop?",
    "exam_tip_hi": "चाहे आपकी अंग्रेज़ी पहले कितनी भी कमज़ोर रही हो — केवल यह एक इकाई (आवेदन ढाँचा + 3-बॉक्स निबंध + कीवर्ड गद्यांश) आपको बिहार बोर्ड में **16 से 20 पक्के अंक** दिलवा सकती है!",
    "exam_tip_en": "Even if you started English from zero, mastering this single unit hands you **16 to 20 guaranteed marks** in the BSEB board examination!",
    "glossary_terms": []
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{Application (5M)} = 1\\text{M Format} + 2.5\\text{M Body} + 1.5\\text{M Subscription}",
      "label_hi": "आवेदन पत्र की सटीक BSEB अंक-योजना",
      "label_en": "Exact BSEB Application Marking Scheme"
    },
    {
      "latex": "\\text{Essay (5M)} = \\text{Intro (1M)} + \\text{3 Body Ideas (3M)} + \\text{Conclusion (1M)}",
      "label_hi": "3-बॉक्स निबंध अंक-योजना",
      "label_en": "3-Box Essay Marking Scheme"
    },
    {
      "latex": "\\text{Passage} = \\text{Question First} \\rightarrow \\text{Keyword} \\rightarrow \\text{Same Tense}",
      "label_hi": "3-कदम अपठित गद्यांश विधि",
      "label_en": "3-Step Unseen Passage Formula"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "FORMAT",
      "fact_hi": "Formal Application (Principal) में Subject ज़रूरी है; Informal Letter (Father/Friend) में Subject नहीं होता।",
      "fact_en": "Formal Applications require a Subject line; Informal Letters to family/friends do NOT."
    },
    {
      "tag": "CLOSING",
      "fact_hi": "Principal → `Yours obediently` | Father/Mother → `Yours affectionately` | Friend → `Yours sincerely`।",
      "fact_en": "Principal → `Yours obediently` | Parents → `Yours affectionately` | Friend → `Yours sincerely`."
    },
    {
      "tag": "PASSAGE",
      "fact_hi": "अपठित गद्यांश में प्रश्न `did + V1` से हो तो उत्तर में `did` हटाकर `V2` लिखते हैं।",
      "fact_en": "When a passage question asks with `did + V1`, drop `did` and answer using `V2`."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "आवेदन के अंत में \"Your's obediently\" लिख देना।",
      "mistake_en": "Writing \"Your's obediently\" with an apostrophe.",
      "fix_hi": "कभी apostrophe न लगाएँ — शुद्ध शब्द है: **\"Yours obediently,\"**",
      "fix_en": "NEVER put an apostrophe in `Yours` — write **\"Yours obediently,\"**"
    },
    {
      "mistake_hi": "आवेदन में Subject पंक्ति लिखना भूल जाना या बिना खाली जगह के एक ही पैराग्राफ में पूरा पत्र चिपका देना।",
      "mistake_en": "Omitting the `Subject:` line or crowding the whole application into one solid block.",
      "fix_hi": "पता, Date, Subject, Salutation, Body और Subscription — हर हिस्से के बाद साफ़ नई पंक्ति छोड़ें!",
      "fix_en": "Give clear line spacing between Address, Date, Subject, Salutation, Body, and Subscription!"
    },
    {
      "mistake_hi": "अपठित गद्यांश के उत्तर में प्रश्न का पूरा वाक्य ज्यों-का-त्यों उतार देना (\"Did he went...\").",
      "mistake_en": "Copying question words (`did`) blindly or dumping half the paragraph into one answer.",
      "fix_hi": "कीवर्ड वाली 1–2 सटीक पंक्तियाँ चुनें और सही Tense में साफ-सुथरा उत्तर लिखें।",
      "fix_en": "Locate the exact 1–2 keyword lines and write a concise answer in the matching tense."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "Principal Application (Sick Leave / Fee Concession / TC / Library)",
      "topic_en": "Principal Application (5 Marks Guaranteed)",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "Easy Essay / Paragraph Writing (Discipline / Aim / Pollution / Trees)",
      "topic_en": "Essay / Paragraph Writing (5–8 Marks)",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "Unseen Comprehension Passage",
      "topic_en": "Unseen Comprehension Passage (7–12 Marks)",
      "years": [
        "2021",
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 10
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 5,
  "analogy_count": 5,
  "bseb_pyq_mapped": true,
  "syllabus_year": "2026-27"
}$json$::jsonb,
  'PUBLISHED',
  1
) ON CONFLICT (chapter_id) DO UPDATE SET
  mindmap_json        = EXCLUDED.mindmap_json,
  sections_json       = EXCLUDED.sections_json,
  board_capsule_json  = EXCLUDED.board_capsule_json,
  quality_checks_json = EXCLUDED.quality_checks_json,
  status              = EXCLUDED.status,
  version             = EXCLUDED.version;

INSERT INTO public.lesson_plans (
  chapter_id, duration_periods, objectives_hi, objectives_en,
  teaching_steps_json, blackboard_points_json, classroom_activities_json, homework_json, common_student_misconceptions_json
) VALUES (
  'skill-eng-f-ch5',
  4,
  'कमज़ोर से कमज़ोर विद्यार्थी को 1 मास्टर प्रधानाचार्य आवेदन ढाँचा कंठस्थ कराकर 10 बोर्ड प्रश्न हल करने योग्य बनाना, 3-बॉक्स निबंध तकनीक से बिना रटे लिखने का आत्मविश्वास जगाना, तथा 3-कदम कीवर्ड विधि से अपठित गद्यांश में 100% अंक दिलाना।',
  'Equip even struggling learners with ONE reusable Principal Application skeleton that solves 10 BSEB questions, build fearless essay-writing confidence via the 3-Box method, and train rapid 3-step keyword scanning for Unseen Passages.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "5-मिनट ढाँचा कोरस + \"2-लाइन बदलो, 10 आवेदन पाओ\" लाइव ब्लैकबोर्ड जादू",
    "phase_en": "5-Min Format Chorus + Live \"Swap 2 Lines, Solve 10 Apps\" Blackboard Demo",
    "teacher_action_hi": "मिनट 0–5: पूरी कक्षा लय में आवेदन के 6 हिस्से बोले — \"To The Principal! Date! Subject! Respected Sir! Body! Yours obediently!\"। मिनट 5–22: बोर्ड पर पूरा Sick Leave आवेदन लिखें और दाईं ओर 1M + 2.5M + 1.5M अंक-योजना लिखें। मिनट 22–32: डस्टर से केवल `Subject` और बीच की 2 पंक्तियाँ मिटाकर उसी ढाँचे को 60 सेकंड में Fee Concession और फिर Transfer Certificate (TC) में बदलकर दिखाएँ — बच्चों का डर उसी क्षण छूमंतर हो जाएगा! मिनट 32–40: छात्र खुद Library Book का 2-लाइन स्वैप लिखें।",
    "teacher_action_en": "Mins 0–5: Whole-class rhythmic chant of the 6 application parts (\"To The Principal! Date! Subject! Respected Sir! Body! Yours obediently!\"). Mins 5–22: Write the complete Sick Leave application on the board with the 1M + 2.5M + 1.5M rubric beside it. Mins 22–32: Erase ONLY the Subject and 2 middle lines to turn it live into Fee Concession and TC in 60 seconds — students immediately see how easy 5/5 marks are! Mins 32–40: Students draft the Library Books swap.",
    "student_check_hi": "बोर्ड पर `Your's obediently` लिखें और छात्रों से पूछें इसमें कौन-सा छोटा चिह्न हमारे 1 अंक काट सकता है?",
    "student_check_en": "Write `Your's obediently` on the board and challenge students to spot the tiny mark that loses marks!"
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "अनौपचारिक पत्र (पिताजी / मित्र को) + Formal बनाम Informal अंतर",
    "phase_en": "Informal Letters (Father / Friend) + Formal vs Informal Comparison",
    "teacher_action_hi": "मिनट 0–10: बोर्ड को 2 हिस्सों में बाँटें — बाएँ Principal Application (`Subject` + `Yours obediently`), दाएँ Father Letter (कोई `Subject` नहीं + `Yours affectionately`)। मिनट 10–28: किताबों के लिए पैसे मँगाने का सरल 10-पंक्ति पत्र साथ-साथ लिखवाएँ। मिनट 28–40: छात्र उसी ढाँचे से मित्र को परीक्षा की तैयारी पर पत्र शुरू करें।",
    "teacher_action_en": "Mins 0–10: Split the board — Left: Formal Application (`Subject` + `Yours obediently`), Right: Informal Letter (NO `Subject` + `Yours affectionately`). Mins 10–28: Co-write a clean 10-line letter to Father asking for money for books. Mins 28–40: Students adapt it into a letter to a friend.",
    "student_check_hi": "पूछें: पिताजी को पत्र के अंत में `Yours obediently` लिखेंगे या `Yours affectionately`?",
    "student_check_en": "Ask: Should a letter to Father end with `Yours obediently` or `Yours affectionately`?"
  },
  {
    "period_no": 3,
    "duration_mins": 40,
    "phase_hi": "3-बॉक्स आसान निबंध कार्यशाला (Discipline / My Village / Importance of Trees)",
    "phase_en": "3-Box Easy Essay Workshop",
    "teacher_action_hi": "मिनट 0–5: \"निबंध से डरना मना है!\" प्रेरणा संवाद — बताएँ कि 10 छोटे शुद्ध वाक्य ही 5/5 अंक दिलाते हैं। मिनट 5–22: बोर्ड पर 3 बड़े डिब्बे (Box 1: Intro, Box 2: 3 Ideas, Box 3: Conclusion) बनाकर \"Importance of Discipline\" पर 12 सरल वाक्य बनवाएँ। मिनट 22–38: बच्चों से \"Importance of Trees\" के लिए 3 बुलेट बिंदु (Oxygen, Rain/Shade, Plant more trees) हिंदी से सरल अंग्रेज़ी में बनवाएँ। मिनट 38–40: 2 संकोची छात्रों से उनके 2 वाक्य पढ़वाकर ताली बजवाएँ।",
    "teacher_action_en": "Mins 0–5: Reassure shy students that 10–12 short clean sentences win full marks! Mins 5–22: Draw the 3 boxes on the board and co-build a 12-sentence essay on \"Importance of Discipline\". Mins 22–38: Brainstorm 3 simple points for \"Importance of Trees\" in Hindi and convert them into simple S+V+O sentences. Mins 38–40: Celebrate 2 shy students reading their lines.",
    "student_check_hi": "पूछें: निबंध लिखते समय लंबा 25-शब्दों का उलझा वाक्य अच्छा है या 2 छोटे 8-शब्दों के शुद्ध वाक्य?",
    "student_check_en": "Ask: Which scores better in BSEB — one tangled 25-word sentence or two crisp 8-word sentences?"
  },
  {
    "period_no": 4,
    "duration_mins": 40,
    "phase_hi": "जासूस कीवर्ड दौड़: अपठित गद्यांश (Unseen Passage) लाइव अभ्यास",
    "phase_en": "Detective Keyword Race: Live Unseen Passage Practice",
    "teacher_action_hi": "मिनट 0–10: 3-कदम जासूसी विधि (पहले सवाल → कीवर्ड गोला → सही Tense उत्तर) समझाएँ और \"did + V1 → V2\" नियम बोर्ड पर दिखाएँ। मिनट 10–30: बोर्ड पर 6-पंक्ति का एक आसान बिहार-आधारित गद्यांश (जैसे डॉ. राजेंद्र प्रसाद या नालंदा) लिखें और 4 प्रश्नों के कीवर्ड छात्रों से खोजवाएँ। मिनट 30–40: शीर्षक (Title) चुनने का अभ्यास।",
    "teacher_action_en": "Mins 0–10: Teach the 3-step Detective Method and the `did + V1 → V2` answer rule. Mins 10–30: Write a 6-line Bihar-themed passage (e.g., Dr. Rajendra Prasad or Nalanda) on the board and let teams race to underline keywords for 4 questions. Mins 30–40: Practice picking a crisp 3-word Title.",
    "student_check_hi": "यदि प्रश्न में \"Why did...\" हो तो उत्तर में कौन-सा जोड़ने वाला शब्द (`because`) लगाना चाहिए?",
    "student_check_en": "If a passage question starts with \"Why did...\", which connector word should introduce the reason?"
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड 1: 1-ढाँचा 10-सवाल प्रधानाचार्य आवेदन चेकलिस्ट",
    "heading_en": "Blackboard 1: 1-Skeleton 10-Topics Principal Application Box",
    "points_hi": [
      "भाग 1 (1 अंक): To, The Principal, [School] + Date + Subject: Application for ...",
      "भाग 2 (2.5 अंक): Respected Sir, + Most humbly I beg to state... + [2-लाइन कारण]",
      "भाग 3 (1.5 अंक): Thanking you, + Yours obediently (बिना apostrophe!), + Name/Class/Roll"
    ],
    "points_en": [
      "Part 1 (1M): To, The Principal, [School] + Date + Subject: Application for ...",
      "Part 2 (2.5M): Respected Sir, + Most humbly I beg to state... + [2-line reason slot]",
      "Part 3 (1.5M): Thanking you, + Yours obediently (NO apostrophe!), + Name/Class/Roll"
    ]
  },
  {
    "heading_hi": "ब्लैकबोर्ड 2: 3-बॉक्स निबंध और 3-कदम अपठित गद्यांश",
    "heading_en": "Blackboard 2: 3-Box Essay & 3-Step Passage Formula",
    "points_hi": [
      "निबंध: Box 1 Intro (2–3 वाक्य) → Box 2 Body (3 बिंदु) → Box 3 Conclusion (2 वाक्य)",
      "गद्यांश: 1. पहले प्रश्न पढ़ें → 2. Keyword गद्यांश में मिलाएँ → 3. सही Tense में लिखें",
      "Informal Letter (Father/Friend): NO Subject! Closing = Yours affectionately / sincerely"
    ],
    "points_en": [
      "Essay: Box 1 Intro (2–3 lines) → Box 2 Body (3 ideas) → Box 3 Conclusion (2 lines)",
      "Passage: 1. Read Questions First → 2. Scan Keyword → 3. Write in Matching Tense",
      "Informal Letter (Father/Friend): NO Subject! Closing = Yours affectionately / sincerely"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "60-सेकंड \"2-लाइन स्वैप\" आवेदन चुनौती",
    "title_en": "60-Second \"Swap 2 Lines\" Application Challenge",
    "materials_hi": "ब्लैकबोर्ड, चाक और डस्टर",
    "materials_en": "Blackboard, chalk, and duster",
    "steps_hi": "एक बार Sick Leave का आवेदन लिखने के बाद 3 अलग-अलग छात्रों को बुलाएँ और केवल Subject व 2 मध्य पंक्तियाँ बदलकर Fee Concession, TC और Library Book आवेदन बनवाएँ। पूरी कक्षा देख लेगी कि 80% ढाँचा कभी नहीं बदलता!",
    "steps_en": "After writing Sick Leave once on the board, invite 3 students to erase ONLY Subject + 2 middle lines to convert it into Fee Concession, TC, and Library Books — proving 80% of the skeleton never changes!"
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "अपनी कॉपी में एक ही मास्टर ढाँचे का उपयोग करके (1) Sick Leave और (2) Fee Concession के दो साफ आवेदन पत्र लिखें और सही अंक-भागों को अंडरलाइन करें।",
    "task_en": "Write two clean applications in your notebook using the same master skeleton: (1) Sick Leave and (2) Fee Concession."
  },
  {
    "level": "BOARD",
    "task_hi": "3-बॉक्स विधि (Introduction → 3 Points Body → Conclusion) का उपयोग करके \"Importance of Trees\" या \"My Aim in Life\" पर 120 शब्दों का निबंध लिखें।",
    "task_en": "Write a 120-word 3-paragraph essay on \"Importance of Trees\" or \"My Aim in Life\" using the 3-Box Blueprint."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "अपने पिताजी को बोर्ड परीक्षा की तैयारी बताते हुए और ₹500 किताबों के लिए मँगवाते हुए एक सुंदर Informal Letter लिखें (बिना Subject के और शुद्ध समापन के साथ)।",
    "task_en": "Write a neat Informal Letter to your father sharing your board exam preparation and requesting Rs. 500 for reference books."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "अधिकतर छात्र आवेदन के अंत में `Your's obediently` (apostrophe के साथ) लिखते हैं।",
    "misconception_en": "Most students mistakenly write `Your's obediently` with an apostrophe.",
    "correction_hi": "स्पष्ट करें कि `Yours, Ours, Hers, Theirs` जैसे possessive pronouns में कभी apostrophe नहीं लगता — हमेशा **`Yours obediently`**!",
    "correction_en": "Explain that possessive pronouns (`Yours, Ours, Hers, Theirs`) NEVER take an apostrophe — always **`Yours obediently`**!"
  },
  {
    "misconception_hi": "छात्र अपठित गद्यांश के कठिन शब्द देखकर घबरा जाते हैं और पूरा प्रश्न छोड़ देते हैं या पूरा गद्यांश उतार देते हैं।",
    "misconception_en": "Students freeze when they see 4–5 unfamiliar words in an Unseen Passage, or copy the whole paragraph blindly.",
    "correction_hi": "जासूसी कीवर्ड मिलान का लाइव अभ्यास कराएँ ताकि उन्हें विश्वास हो कि बिना हर शब्द का अर्थ जाने भी 90–100% सटीक उत्तर मिल जाता है!",
    "correction_en": "Run live Keyword-Match drills so they experience scoring 90–100% accurately without needing to translate every single difficult word!"
  }
]$json$::jsonb
) ON CONFLICT (chapter_id) DO UPDATE SET
  duration_periods                   = EXCLUDED.duration_periods,
  objectives_hi                      = EXCLUDED.objectives_hi,
  objectives_en                      = EXCLUDED.objectives_en,
  teaching_steps_json                = EXCLUDED.teaching_steps_json,
  blackboard_points_json             = EXCLUDED.blackboard_points_json,
  classroom_activities_json          = EXCLUDED.classroom_activities_json,
  homework_json                      = EXCLUDED.homework_json,
  common_student_misconceptions_json = EXCLUDED.common_student_misconceptions_json;

INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Application Opening Line
  (
    '10000006-0005-4000-8000-000000000001', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Application Opening Line', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', 'BSEB 2024',
    'प्रधानाचार्य आवेदन की जादुई शुरुआती पंक्ति बनाएँ:',
    'Build the polite opening sentence of a Principal Application:',
    NULL, NULL,
    'सही क्रम: `Most humbly I beg to state that I am ill`!',
    'Order: `Most humbly I beg to state that I am ill`!',
    '**"Most humbly I beg to state that I am ill"** — यह पंक्ति हर प्रधानाचार्य आवेदन में विनम्र और प्रभावशाली शुरुआत देती है।',
    '**"Most humbly I beg to state that I am ill"** is a respectful, board-ready application opener.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "आवेदन की शुरुआत: विनम्र निवेदन है कि मैं बीमार हूँ।",
  "prompt_en": "Build the standard polite Principal Application opener",
  "grammar_formula": "Most humbly + I beg to state that + Reason",
  "tokens": [
    "Most",
    "humbly",
    "I",
    "beg",
    "to",
    "state",
    "that",
    "I",
    "am",
    "ill"
  ],
  "distractors": [
    "is",
    "stating"
  ],
  "correct_sentence": "Most humbly I beg to state that I am ill",
  "pronunciation_hi": "मोस्ट हम्बली आई बेग टू स्टेट दैट आई ऐम इल"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (FOUNDATION, PRACTICE) — Sick Leave Reason Line
  (
    '10000006-0005-4000-8000-000000000002', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Sick Leave Reason Line', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', 'BSEB 2023',
    'बीमारी छुट्टी आवेदन की मुख्य पंक्ति बनाएँ: "मैं कल रात से बुखार से पीड़ित हूँ।"',
    'Build the Sick Leave body line: "I have been suffering from fever."',
    NULL, NULL,
    '`suffering` के साथ हमेशा **`from`** लगता है (`of` या `by` नहीं!)।',
    '`suffering` ALWAYS takes **`from`** (never `of` or `by`)!',
    '**"I have been suffering from fever"** — Sick Leave आवेदन का सबसे विश्वसनीय वाक्य।',
    '**"I have been suffering from fever"** uses accurate Present Perfect Continuous + `from`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मैं बुखार से पीड़ित हूँ। (Sick Leave मुख्य पंक्ति)",
  "prompt_en": "Build the core Sick Leave body sentence",
  "grammar_formula": "I + have been suffering + from + fever",
  "tokens": [
    "I",
    "have",
    "been",
    "suffering",
    "from",
    "fever"
  ],
  "distractors": [
    "of",
    "am"
  ],
  "correct_sentence": "I have been suffering from fever",
  "pronunciation_hi": "आई हैव बीन सफ़रिंग फ़्रॉम फ़ीवर"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Application Request Line
  (
    '10000006-0005-4000-8000-000000000003', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Application Request Line', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', 'BSEB 2024',
    'छुट्टी माँगने की विनम्र पंक्ति बनाएँ: "कृपया मुझे दो दिन की छुट्टी प्रदान करें।"',
    'Build the polite leave-request line: "Kindly grant me two days leave."',
    NULL, NULL,
    'विनम्र अनुरोध: `Kindly grant me leave for two days`!',
    'Polite request order: `Kindly grant me leave for two days`!',
    '**"Kindly grant me leave for two days"** — ध्यान दें: `Kindly` और `Please` एक साथ कभी न लिखें!',
    '**"Kindly grant me leave for two days"** — never pair `Please` and `Kindly` together!',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "कृपया मुझे दो दिन की छुट्टी प्रदान करें।",
  "prompt_en": "Build the polite leave-request sentence for your application",
  "grammar_formula": "Kindly + grant + me + leave + for + duration",
  "tokens": [
    "Kindly",
    "grant",
    "me",
    "leave",
    "for",
    "two",
    "days"
  ],
  "distractors": [
    "please",
    "since"
  ],
  "correct_sentence": "Kindly grant me leave for two days",
  "pronunciation_hi": "काइंडली ग्रांट मी लीव फ़ॉर टू डेज़"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (BOARD, PRACTICE) — Essay Universal Opener
  (
    '10000006-0005-4000-8000-000000000004', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Essay Universal Opener', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'आसान निबंध की शानदार पहली पंक्ति बनाएँ: "अनुशासन सफलता की कुंजी है।"',
    'Build the strong Essay opener: "Discipline is the key to success."',
    NULL, NULL,
    '`key` के साथ हमेशा **`to`** लगता है (`key to success`, `of` नहीं!)।',
    'The idiom is **`the key to success`** (`to`, not `of`)!',
    '**"Discipline is the key to success"** — किसी भी सकारात्मक निबंध के लिए चमकदार शुरुआत!',
    '**"Discipline is the key to success"** — crisp idiom (`key to`) ideal for any board essay!',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "अनुशासन सफलता की कुंजी है। (निबंध परिचय पंक्ति)",
  "prompt_en": "Build the classic Essay introduction sentence",
  "grammar_formula": "Topic + is + the key to + success",
  "tokens": [
    "Discipline",
    "is",
    "the",
    "key",
    "to",
    "success"
  ],
  "distractors": [
    "of",
    "are"
  ],
  "correct_sentence": "Discipline is the key to success",
  "pronunciation_hi": "डिसिप्लिन इज़ द की टू सक्सेस"
}$json$::jsonb,
    true
  ),
  -- SENTENCE_BUILDER (TOPPER, PRACTICE) — Application Gratitude Closing
  (
    '10000006-0005-4000-8000-000000000005', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Application Gratitude Closing', 'PRACTICE', 'SENTENCE_BUILDER', 'TOPPER', 'BSEB Model Paper',
    'आवेदन की आभार पंक्ति बनाएँ: "मैं इसके लिए आपका सदा आभारी रहूँगा।"',
    'Build the formal closing line: "I shall be ever grateful to you."',
    NULL, NULL,
    '`grateful` के साथ हमेशा **`to`** लगता है (`grateful to you`)!',
    '`grateful` ALWAYS takes **`to`** (`grateful to you`)!',
    '**"I shall be ever grateful to you"** — हर प्रधानाचार्य आवेदन का शानदार समापन वाक्य!',
    '**"I shall be ever grateful to you"** works at the end of every single formal application!',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मैं आपका सदा आभारी रहूँगा। (आवेदन समापन पंक्ति)",
  "prompt_en": "Build the formal gratitude line for any Principal Application",
  "grammar_formula": "I + shall be + ever grateful + to you",
  "tokens": [
    "I",
    "shall",
    "be",
    "ever",
    "grateful",
    "to",
    "you"
  ],
  "distractors": [
    "for",
    "am"
  ],
  "correct_sentence": "I shall be ever grateful to you",
  "pronunciation_hi": "आई शैल बी एवर ग्रेटफ़ुल टू यू"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (FOUNDATION, PRACTICE) — Application Subject & Salutation Slot
  (
    '10000006-0005-4000-8000-000000000006', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Application Subject & Salutation Slot', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', 'BSEB 2024',
    'प्रधानाचार्य को शुल्क माफ़ी (Fee Concession) आवेदन के लिए सही Subject और Salutation स्लॉट चुनें:',
    'Pick the exact Subject & Salutation slot for a Fee Concession application to the Principal:',
    NULL, NULL,
    'प्रधानाचार्य के लिए औपचारिक अभिवादन (`Respected Sir/Madam`) और संक्षिप्त स्पष्ट `Subject` चाहिए!',
    'Formal Principal application needs a crisp `Subject:` and `Respected Sir / Madam,`!',
    '**Subject: Application for full fee concession. / Respected Sir,** — यह बिहार बोर्ड के 1 अंक वाले Format स्लॉट के लिए 100% आदर्श है।',
    '**Subject: Application for full fee concession. / Respected Sir,** earns full format marks in BSEB.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "WRITING_TEMPLATE",
  "scene_title_hi": "आवेदन स्लॉट चुनें: शुल्क माफ़ी (Fee Concession)",
  "scene_title_en": "Application Slot Picker: Fee Concession",
  "prompt_hi": "नीचे आवेदन के ऊपरी बॉक्स में [SLOT ?] की जगह सबसे शुद्ध और अंक-दिलाने वाला विकल्प चुनें:",
  "prompt_en": "Pick the highest-scoring Subject & Salutation block to fill [SLOT ?] below:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "आवेदन का शीर्ष बॉक्स — स्लॉट भरें",
    "title_en": "Application Header Box — Fill the Missing Slot",
    "caption_hi": "To, The Principal के ठीक नीचे Date, Subject और Salutation आता है",
    "caption_en": "Date, Subject, and Salutation sit right below To, The Principal",
    "viewBox": "0 0 540 160",
    "elements": [
      {
        "kind": "rect",
        "x": 30,
        "y": 14,
        "width": 480,
        "height": 132,
        "rx": 10,
        "fill": "#FFFFFF",
        "stroke": "#1E3A8A",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 48,
        "y": 38,
        "text_hi": "To, The Principal, U.H.S. Kaparpura, Muzaffarpur",
        "text_en": "To, The Principal, U.H.S. Kaparpura, Muzaffarpur",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "start",
        "bold": true
      },
      {
        "kind": "label",
        "x": 48,
        "y": 62,
        "text_hi": "Date: 15 February 2026",
        "text_en": "Date: 15 February 2026",
        "fill": "#475569",
        "fontSize": 11,
        "anchor": "start",
        "bold": false
      },
      {
        "kind": "rect",
        "x": 46,
        "y": 76,
        "width": 448,
        "height": 56,
        "rx": 8,
        "fill": "#FEF3C7",
        "stroke": "#D97706",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 270,
        "y": 100,
        "text_hi": "[SLOT ?] — सही Subject व Salutation चुनें",
        "text_en": "[SLOT ?] — Choose Exact Subject & Salutation",
        "fill": "#92400E",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "Mail",
      "label_hi": "Hi Principal Sir, please forgive my school fee.",
      "label_en": "Hi Principal Sir, please forgive my school fee."
    },
    {
      "id": "c2",
      "icon": "Mail",
      "label_hi": "My dear Principal, (बिना Subject के)",
      "label_en": "My dear Principal, (without Subject line)"
    },
    {
      "id": "c3",
      "icon": "Mail",
      "label_hi": "Subject: Application for full fee concession. — Respected Sir,",
      "label_en": "Subject: Application for full fee concession. — Respected Sir,"
    },
    {
      "id": "c4",
      "icon": "Mail",
      "label_hi": "Subject: I am poor farmer son — Dear Friend,",
      "label_en": "Subject: I am poor farmer son — Dear Friend,"
    }
  ],
  "correct_choice_id": "c3"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (BOARD, PRACTICE) — Application Subscription Slot
  (
    '10000006-0005-4000-8000-000000000007', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Application Subscription Slot', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'BSEB 2023',
    'प्रधानाचार्य आवेदन के अंत (1.5 अंक Subscription स्लॉट) के लिए 100% त्रुटिरहित समापन चुनें:',
    'Choose the 100% error-free Closing Subscription (1.5 Marks) for a Principal Application:',
    NULL, NULL,
    '`Yours` में कभी apostrophe (`''`) नहीं लगता और प्रधानाचार्य के लिए `obediently` सबसे उपयुक्त है!',
    '`Yours` NEVER takes an apostrophe, and students close to a Principal with `obediently`!',
    '**"Thanking you, / Yours obediently, / Name, Class & Roll No."** — एक भी स्पेलिंग या अपॉस्ट्रॉफी त्रुटि नहीं!',
    '**"Thanking you, / Yours obediently, / Name, Class & Roll No."** wins the full 1.5 subscription marks.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "WRITING_TEMPLATE",
  "scene_title_hi": "आवेदन समापन स्लॉट (1.5 पक्के अंक)",
  "scene_title_en": "Application Closing Slot (1.5 Guaranteed Marks)",
  "prompt_hi": "आवेदन के निचले हिस्से में [CLOSING SLOT] के लिए बिल्कुल शुद्ध विकल्प चुनें:",
  "prompt_en": "Select the error-free closing block to complete [CLOSING SLOT]:",
  "scene_diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "आवेदन का अंतिम भाग — सही समापन चुनें",
    "title_en": "Bottom of Application — Choose Error-Free Closing",
    "caption_hi": "सावधान! एक छोटा apostrophe भी अंक कटवा सकता है",
    "caption_en": "Careful! Even one misplaced apostrophe loses marks",
    "viewBox": "0 0 540 120",
    "elements": [
      {
        "kind": "rect",
        "x": 30,
        "y": 14,
        "width": 480,
        "height": 92,
        "rx": 10,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 270,
        "y": 46,
        "text_hi": "[CLOSING SLOT — 1.5 Marks]",
        "text_en": "[CLOSING SLOT — 1.5 Marks]",
        "fill": "#065F46",
        "fontSize": 14,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 270,
        "y": 80,
        "text_hi": "Thanking you + Subscription + Name / Class / Roll",
        "text_en": "Thanking you + Subscription + Name / Class / Roll",
        "fill": "#047857",
        "fontSize": 12,
        "anchor": "middle",
        "bold": false
      }
    ]
  },
  "choices": [
    {
      "id": "c1",
      "icon": "PenTool",
      "label_hi": "Your's obediently, Ravi Kumar",
      "label_en": "Your's obediently, Ravi Kumar"
    },
    {
      "id": "c2",
      "icon": "PenTool",
      "label_hi": "Yours lovingly, Ravi Kumar",
      "label_en": "Yours lovingly, Ravi Kumar"
    },
    {
      "id": "c3",
      "icon": "PenTool",
      "label_hi": "Your obedient student's, Ravi",
      "label_en": "Your obedient student's, Ravi"
    },
    {
      "id": "c4",
      "icon": "PenTool",
      "label_hi": "Thanking you, Yours obediently, Ravi Kumar (Class X, Roll 12)",
      "label_en": "Thanking you, Yours obediently, Ravi Kumar (Class X, Roll 12)"
    }
  ],
  "correct_choice_id": "c4"
}$json$::jsonb,
    true
  ),
  -- SCENARIO_LAB (TOPPER, PRACTICE) — Unseen Passage Keyword Detective
  (
    '10000006-0005-4000-8000-000000000008', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Unseen Passage Keyword Detective', 'PRACTICE', 'SCENARIO_LAB', 'TOPPER', 'BSEB 2024',
    'नीचे दिए छोटे गद्यांश को पढ़कर 3-कदम कीवर्ड विधि से सबसे शुद्ध उत्तर चुनें:',
    'Read the mini unseen passage below and pick the exact tense-matched answer:',
    NULL, NULL,
    'प्रश्न में `did` + `start` है → उत्तर में `did` हटाकर **`started`** (V2) और सटीक वर्ष **1917** लिखें!',
    'The question uses `did ... start` → drop `did`, use V2 **`started`** + exact year **1917**!',
    '**"Mahatma Gandhi started the Champaran Satyagraha in 1917."** — सही कीवर्ड और सही भूतकाल (V2)!',
    '**"Mahatma Gandhi started the Champaran Satyagraha in 1917."** — crisp keyword match in Past Tense.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "WRITING_TEMPLATE",
  "scene_title_hi": "अपठित गद्यांश जासूस: चम्पारण सत्याग्रह",
  "scene_title_en": "Unseen Passage Detective: Champaran Satyagraha",
  "prompt_hi": "गद्यांश: \"In 1917, Mahatma Gandhi came to Bihar and started the Champaran Satyagraha to help indigo farmers.\" — प्रश्न: When did Mahatma Gandhi start the Champaran Satyagraha?",
  "prompt_en": "Passage: \"In 1917, Mahatma Gandhi came to Bihar and started the Champaran Satyagraha to help indigo farmers.\" — Q: When did Mahatma Gandhi start the Champaran Satyagraha?",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "FileText",
      "label_hi": "Mahatma Gandhi did started the Champaran Satyagraha in 1917.",
      "label_en": "Mahatma Gandhi did started the Champaran Satyagraha in 1917."
    },
    {
      "id": "c2",
      "icon": "FileText",
      "label_hi": "Mahatma Gandhi started the Champaran Satyagraha in 1917.",
      "label_en": "Mahatma Gandhi started the Champaran Satyagraha in 1917."
    },
    {
      "id": "c3",
      "icon": "FileText",
      "label_hi": "Mahatma Gandhi start the Champaran Satyagraha to help farmers.",
      "label_en": "Mahatma Gandhi start the Champaran Satyagraha to help farmers."
    },
    {
      "id": "c4",
      "icon": "FileText",
      "label_hi": "Because he came to Bihar in 1917.",
      "label_en": "Because he came to Bihar in 1917."
    }
  ],
  "correct_choice_id": "c2"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (FOUNDATION, PRACTICE) — Application Rubric Memory
  (
    '10000006-0005-4000-8000-000000000009', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Application Rubric Memory', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'बिहार बोर्ड में 5-अंक के प्रधानाचार्य आवेदन पत्र में अंक कैसे बँटते हैं?',
    'How are the 5 marks split in a BSEB Principal Application?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "BSEB में 5-अंक Application का अंक-विभाजन (Marking Scheme) क्या है?",
  "front_en": "What is the exact 5-mark BSEB rubric for a Principal Application?",
  "back_hi": "Format + Date + Subject + Salutation = 1 अंक | मुख्य विषय (Body) = 2.5 अंक | समापन (Yours obediently + Name/Class/Roll) = 1.5 अंक। कुल = 5 अंक!",
  "back_en": "Format + Date + Subject + Salutation = 1M | Main Body = 2.5M | Subscription (`Yours obediently` + Name/Class/Roll) = 1.5M. Total = 5 Marks!",
  "mnemonic_hi": "ट्रिक: \"1 + 2.5 + 1.5 = 5 पक्के अंक — पहले और आखिरी हिस्से से ही 2.5 अंक मुफ़्त!\"",
  "mnemonic_en": "Trick: \"1 + 2.5 + 1.5 = 5 — crisp Format & Closing alone secure 2.5 marks!\"",
  "pronunciation_hi": "फ़ॉर्मेट · बॉडी · सब्सक्रिप्शन"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (FOUNDATION, PRACTICE) — Formal vs Informal Closings
  (
    '10000006-0005-4000-8000-000000000010', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Formal vs Informal Closings', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2023',
    'प्रधानाचार्य, पिताजी और मित्र के पत्र के अंत में क्या लिखा जाता है?',
    'What is the exact closing subscription for Principal, Father, and Friend?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "किसे क्या समापन लिखें: Principal, Father, Friend?",
  "front_en": "Match the right closing subscription: Principal, Father, Friend?",
  "back_hi": "Principal → Yours obediently, | Father/Mother → Yours affectionately, | Friend → Yours sincerely, (तीनों में \"Yours\" बिना apostrophe के!)।",
  "back_en": "Principal → Yours obediently, | Parents → Yours affectionately, | Friend → Yours sincerely, (NEVER put an apostrophe in \"Yours\"!).",
  "mnemonic_hi": "ट्रिक: \"गुरु = obediently, परिवार = affectionately, दोस्त = sincerely!\"",
  "mnemonic_en": "Trick: \"Principal = obediently, Parents = affectionately, Friend = sincerely!\"",
  "pronunciation_hi": "योर्स ओबीडिएंटली · योर्स अफ़ेक्शनेटली"
}$json$::jsonb,
    true
  ),
  -- FLASHCARD (BOARD, PRACTICE) — Unseen Passage 3 Steps
  (
    '10000006-0005-4000-8000-000000000011', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Unseen Passage 3 Steps', 'PRACTICE', 'FLASHCARD', 'BOARD', NULL,
    'अपठित गद्यांश (Unseen Passage) को तेज़ और 100% शुद्ध हल करने के 3 कदम क्या हैं?',
    'What are the 3 steps to solve any Unseen Passage accurately?',
    NULL, NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "अपठित गद्यांश हल करने की 3-कदम कीवर्ड विधि क्या है?",
  "front_en": "State the 3-step Keyword-Match method for Unseen Passages.",
  "back_hi": "कदम 1: पहले प्रश्न पढ़ें और Keyword पहचानें। कदम 2: गद्यांश में वही Keyword वाली पंक्ति ढूँढ़ें। कदम 3: प्रश्न के ही Tense में (`did` हटाकर) 1–2 सटीक पंक्तियाँ लिखें।",
  "back_en": "Step 1: Read questions first & circle keywords. Step 2: Scan passage for the matching line. Step 3: Write 1–2 crisp lines in the matching tense (drop `did`).",
  "mnemonic_hi": "ट्रिक: \"पहले सवाल → फिर कीवर्ड खोज → फिर सटीक Tense में उत्तर!\"",
  "mnemonic_en": "Trick: \"Questions First → Keyword Scan → Same-Tense Answer!\"",
  "pronunciation_hi": "कीवर्ड मैच मेथड"
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (FOUNDATION, PRACTICE) — Letter Parts Match
  (
    '10000006-0005-4000-8000-000000000012', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Letter Parts Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'पत्र के प्रकार को उसके सही अभिवादन / समापन से मिलाएँ:',
    'Match each letter recipient with the exact correct greeting or closing:',
    NULL, NULL,
    'औपचारिक (Principal / Editor) और अनौपचारिक (Father / Friend) का अंतर ध्यान रखें!',
    'Distinguish Formal (Principal/Editor) from Informal (Father/Friend)!',
    'हर प्राप्तकर्ता के अनुसार सम्मानजनक अभिवादन और समापन तय होता है।',
    'Formal vs Informal recipients require specific salutations and sign-offs.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "प्राप्तकर्ता को सही समापन / अभिवादन से मिलाएँ",
  "instruction_en": "Match each letter type with its exact closing",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "प्रधानाचार्य को आवेदन (Principal)",
      "left_en": "Application to Principal",
      "right_hi": "Yours obediently,",
      "right_en": "Yours obediently,"
    },
    {
      "id": "p2",
      "left_hi": "पिताजी को पत्र (Father)",
      "left_en": "Letter to Father",
      "right_hi": "Yours affectionately,",
      "right_en": "Yours affectionately,"
    },
    {
      "id": "p3",
      "left_hi": "मित्र को पत्र (Friend)",
      "left_en": "Letter to Friend",
      "right_hi": "Yours sincerely,",
      "right_en": "Yours sincerely,"
    },
    {
      "id": "p4",
      "left_hi": "समाचार-पत्र संपादक (Editor)",
      "left_en": "Letter to Editor",
      "right_hi": "Yours truly,",
      "right_en": "Yours truly,"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MATCH_PAIRS (BOARD, PRACTICE) — Wh-Word Passage Guide
  (
    '10000006-0005-4000-8000-000000000013', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Wh-Word Passage Guide', 'PRACTICE', 'MATCH_PAIRS', 'BOARD', NULL,
    'अपठित गद्यांश के प्रत्येक प्रश्न-शब्द को उसके सही उत्तर-प्रकार से मिलाएँ:',
    'Match each Unseen Passage question word with what your answer must provide:',
    NULL, NULL,
    'Who = व्यक्ति, When = समय, Where = स्थान, Why = कारण!',
    'Who = Person, When = Time, Where = Place, Why = Reason!',
    'सही प्रश्न-शब्द पहचानने से आप कभी गलत पंक्ति नहीं उतारते।',
    'Matching the Wh-word ensures you lift the exact right information from the passage.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "प्रश्न-शब्द को उत्तर-संकेत से मिलाएँ",
  "instruction_en": "Match each Wh-word to the exact answer type",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "Who ...?",
      "left_en": "Who ...?",
      "right_hi": "व्यक्ति या संस्था का नाम",
      "right_en": "Name of a person or group"
    },
    {
      "id": "p2",
      "left_hi": "When ...?",
      "left_en": "When ...?",
      "right_hi": "वर्ष, तारीख या समय",
      "right_en": "Year, date, or time"
    },
    {
      "id": "p3",
      "left_hi": "Where ...?",
      "left_en": "Where ...?",
      "right_hi": "स्थान / शहर / देश का नाम",
      "right_en": "Place, city, or location"
    },
    {
      "id": "p4",
      "left_hi": "Why ...?",
      "left_en": "Why ...?",
      "right_hi": "कारण (because लगाकर)",
      "right_en": "Reason (using because)"
    }
  ]
}$json$::jsonb,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Correct Subscription Spelling
  (
    '10000006-0005-4000-8000-000000000014', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Correct Subscription Spelling', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'प्रधानाचार्य को आवेदन के अंत में इनमें से कौन-सी वर्तनी (Spelling) 100% शुद्ध है?',
    'Which closing spelling is 100% correct at the end of a Principal Application?',
    $json$[{"key":"A","text_hi":"Your's obediently,","text_en":"Your's obediently,"},{"key":"B","text_hi":"Your obediently,","text_en":"Your obediently,"},{"key":"C","text_hi":"Yours obediently,","text_en":"Yours obediently,"},{"key":"D","text_hi":"Yours' obediently,","text_en":"Yours' obediently,"}]$json$::jsonb, 'C',
    '`Yours` में कभी भी apostrophe (`''`) नहीं लगता!',
    '`Yours` NEVER takes an apostrophe!',
    '**"Yours obediently,"** 100% शुद्ध है। `Your''s` और `Yours''` दोनों अशुद्ध हैं।',
    '**"Yours obediently,"** is the only grammatically valid spelling (zero apostrophe!).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Subject Line Rule
  (
    '10000006-0005-4000-8000-000000000015', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Subject Line Rule', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'इनमें से किस प्रकार के पत्र में `Subject:` (विषय) पंक्ति लिखना आवश्यक होता है?',
    'In which type of letter is a `Subject:` line mandatory?',
    $json$[{"key":"A","text_hi":"प्रधानाचार्य को आवेदन पत्र (Formal Application)","text_en":"Formal Application to the Principal"},{"key":"B","text_hi":"मित्र को जन्मदिन का पत्र","text_en":"Birthday letter to a friend"},{"key":"C","text_hi":"पिताजी को पत्र","text_en":"Letter to your father"},{"key":"D","text_hi":"छोटे भाई को पत्र","text_en":"Letter to your younger brother"}]$json$::jsonb, 'A',
    '`Subject:` केवल औपचारिक (Formal) पत्रों और आवेदनों में लिखा जाता है!',
    '`Subject:` belongs ONLY in Formal Applications and official letters!',
    'औपचारिक आवेदन पत्र (**Principal / Officer / Editor**) में `Subject:` लिखना अनिवार्य है ताकि अधिकारी तुरंत उद्देश्य समझ सकें।',
    'Formal Applications require a `Subject:` line; Informal letters to family/friends omit it.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, PRACTICE) — Essay 3-Box Structure
  (
    '10000006-0005-4000-8000-000000000016', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Essay 3-Box Structure', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'एक अच्छे और उच्च-अंक वाले निबंध (Essay) के 3 मुख्य भाग सही क्रम में कौन-से हैं?',
    'What are the 3 core parts of a high-scoring Essay in exact order?',
    $json$[{"key":"A","text_hi":"Conclusion → Body → Introduction","text_en":"Conclusion → Body → Introduction"},{"key":"B","text_hi":"Body → Title → Date","text_en":"Body → Title → Date"},{"key":"C","text_hi":"Subject → Salutation → Signature","text_en":"Subject → Salutation → Signature"},{"key":"D","text_hi":"Introduction → Body → Conclusion","text_en":"Introduction → Body → Conclusion"}]$json$::jsonb, 'D',
    'पहले परिचय, फिर मुख्य विचार, और अंत में निष्कर्ष!',
    'First introduce, then explain key points, then conclude!',
    'हर अच्छे निबंध का सही क्रम **Introduction → Body (3 Ideas) → Conclusion** होता है।',
    'Every well-structured essay follows **Introduction → Body → Conclusion**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Application Grammar Trap
  (
    '10000006-0005-4000-8000-000000000017', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Application Grammar Trap', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'बीमारी की छुट्टी के आवेदन में सही वाक्य चुनें:',
    'Choose the grammatically accurate sentence for a Sick Leave application:',
    $json$[{"key":"A","text_hi":"I am suffering with fever from yesterday.","text_en":"I am suffering with fever from yesterday."},{"key":"B","text_hi":"I have been suffering from fever since last night.","text_en":"I have been suffering from fever since last night."},{"key":"C","text_hi":"I suffering from fever since last night.","text_en":"I suffering from fever since last night."},{"key":"D","text_hi":"I have suffered of fever since last night.","text_en":"I have suffered of fever since last night."}]$json$::jsonb, 'B',
    'दो नियम जाँचें: `suffer FROM` और `since last night` के साथ `have been suffering`!',
    'Check 2 rules: `suffer FROM` + `have been suffering` with `since last night`!',
    '**"I have been suffering from fever since last night."** — इसमें Tense (`have been + V-ing`) और Preposition (`from` + `since`) दोनों 100% शुद्ध हैं।',
    '**"I have been suffering from fever since last night."** nails both Present Perfect Continuous and `suffer from`.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Informal Letter Salutation
  (
    '10000006-0005-4000-8000-000000000018', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Informal Letter Salutation', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'पिताजी को लिखे पत्र के लिए सही अभिवादन (Salutation) और समापन (Closing) की जोड़ी चुनें:',
    'Select the right Salutation & Closing pair for a letter to your father:',
    $json$[{"key":"A","text_hi":"Respected Sir, ... Yours obediently,","text_en":"Respected Sir, ... Yours obediently,"},{"key":"B","text_hi":"Hello Father, ... Your's faithfully,","text_en":"Hello Father, ... Your's faithfully,"},{"key":"C","text_hi":"Dear Sir, ... Yours truly,","text_en":"Dear Sir, ... Yours truly,"},{"key":"D","text_hi":"My dear Father, ... Yours affectionately,","text_en":"My dear Father, ... Yours affectionately,"}]$json$::jsonb, 'D',
    'माता-पिता के लिए स्नेहपूर्ण (`My dear Father` / `Yours affectionately`) रूप चुनें!',
    'Parents take warm family forms (`My dear Father` + `Yours affectionately`)!',
    'पिताजी को पत्र में **`My dear Father,`** और अंत में **`Yours affectionately,`** सबसे उपयुक्त है।',
    'Letters to parents use **`My dear Father,`** and close with **`Yours affectionately,`**.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Polite Request Redundancy
  (
    '10000006-0005-4000-8000-000000000019', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Polite Request Redundancy', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'आवेदन पत्र में अनुरोध करने का सबसे शुद्ध वाक्य पहचानें:',
    'Choose the cleanest request sentence for an application:',
    $json$[{"key":"A","text_hi":"Kindly grant me two days' leave.","text_en":"Kindly grant me two days' leave."},{"key":"B","text_hi":"Please kindly grant me leave.","text_en":"Please kindly grant me leave."},{"key":"C","text_hi":"Grant me leave quickly right now.","text_en":"Grant me leave quickly right now."},{"key":"D","text_hi":"I order you to grant me leave.","text_en":"I order you to grant me leave."}]$json$::jsonb, 'A',
    '`Please` और `Kindly` का अर्थ एक ही है — दोनों एक साथ कभी नहीं लिखते!',
    '`Please` and `Kindly` mean the same thing — never write both together!',
    '**"Kindly grant me two days'' leave."** विनम्र और शुद्ध है। `Please kindly` दोहराव (redundancy) की गलती है।',
    '**"Kindly grant me two days'' leave."** avoids the `Please kindly` redundancy error.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, PRACTICE) — Unseen Passage Strategy
  (
    '10000006-0005-4000-8000-000000000020', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Unseen Passage Strategy', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Model Paper',
    'अपठित गद्यांश (Unseen Passage) में सही उत्तर खोजने का सबसे स्मार्ट पहला कदम क्या है?',
    'What is the smartest first step when solving an Unseen Passage in the exam?',
    $json$[{"key":"A","text_hi":"हर कठिन शब्द का अर्थ सोचकर घबरा जाना","text_en":"Panic over every difficult vocabulary word"},{"key":"B","text_hi":"पूरा गद्यांश कॉपी में ज्यों-का-त्यों उतार देना","text_en":"Copy the entire passage into every answer"},{"key":"C","text_hi":"पहले प्रश्नों को पढ़ना और उनके मुख्य Keywords पहचानना","text_en":"Read the questions first and underline key words"},{"key":"D","text_hi":"गद्यांश बिना पढ़े मन से कहानी लिखना","text_en":"Invent your own story without reading"}]$json$::jsonb, 'C',
    '3-कदम जासूसी विधि का कदम #1 याद करें!',
    'Recall Step 1 of the 3-Step Detective Method!',
    'पहले प्रश्न पढ़कर Keywords पहचानने से आपका समय बचता है और गद्यांश में सही पंक्ति तुरंत चमकती है!',
    'Reading the questions first focuses your eyes immediately on the exact matching lines in the passage!',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Passage Tense Conversion
  (
    '10000006-0005-4000-8000-000000000021', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Passage Tense Conversion', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'यदि अपठित गद्यांश का प्रश्न है: "Why did Nalanda become famous?" तो इनमें से कौन-सा उत्तर व्याकरण की दृष्टि से सबसे शुद्ध है?',
    'If an Unseen Passage asks: "Why did Nalanda become famous?", which answer is grammatically best?',
    $json$[{"key":"A","text_hi":"Nalanda did become famous because it was a great university.","text_en":"Nalanda did become famous because it was a great university."},{"key":"B","text_hi":"Nalanda became famous because it was a great centre of learning.","text_en":"Nalanda became famous because it was a great centre of learning."},{"key":"C","text_hi":"Nalanda become famous because it is a great university.","text_en":"Nalanda become famous because it is a great university."},{"key":"D","text_hi":"Why did Nalanda became famous for learning.","text_en":"Why did Nalanda became famous for learning."}]$json$::jsonb, 'B',
    'प्रश्न में `did + become` है → उत्तर में `did` हटेगा और `became` (V2) आएगा, साथ में `because`!',
    'Drop `did` from the question, convert `become` → `became` (V2), and answer `Why` with `because`!',
    '**"Nalanda became famous because it was a great centre of learning."** — सटीक भूतकाल (V2) और सटीक कारण (`because`)!',
    '**"Nalanda became famous because it was a great centre of learning."** matches Simple Past cleanly.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, PRACTICE) — Passage Title Selection
  (
    '10000006-0005-4000-8000-000000000022', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Passage Title Selection', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    'यदि एक गद्यांश पेड़ों से मिलने वाली ऑक्सीजन, छाया, वर्षा और पेड़ लगाने की आवश्यकता के बारे में है, तो उसका सबसे उपयुक्त शीर्षक (Title) क्या होगा?',
    'If a passage explains how trees give us oxygen, shade, and rain, and why we must plant them, what is the best Title?',
    $json$[{"key":"A","text_hi":"Importance of Trees","text_en":"Importance of Trees"},{"key":"B","text_hi":"Trees give us oxygen and rain and shade so we must plant many trees every year","text_en":"Trees give us oxygen and rain and shade so we must plant many trees every year"},{"key":"C","text_hi":"Oxygen Only","text_en":"Oxygen Only"},{"key":"D","text_hi":"My School Garden","text_en":"My School Garden"}]$json$::jsonb, 'A',
    'अच्छा Title हमेशा छोटा (2–4 शब्द) होता है और पूरे गद्यांश के मुख्य भाव को समेटता है!',
    'A great title is short (2–4 words) and captures the whole central theme!',
    '**"Importance of Trees"** संक्षिप्त (3 शब्द) और पूरे गद्यांश के केंद्रीय विचार को पूरी तरह दर्शाता है।',
    '**"Importance of Trees"** is concise (3 words) and captures the full passage theme.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (FOUNDATION, EXAM_ONLY) — Exam Application Preposition
  (
    '10000006-0005-4000-8000-000000000023', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Exam Application Preposition', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'BSEB Model',
    'सही शब्द चुनें: I shall be ever grateful ___ you for this kindness.',
    'Choose the right preposition: I shall be ever grateful ___ you for this kindness.',
    $json$[{"key":"A","text_hi":"for","text_en":"for"},{"key":"B","text_hi":"at","text_en":"at"},{"key":"C","text_hi":"with","text_en":"with"},{"key":"D","text_hi":"to","text_en":"to"}]$json$::jsonb, 'D',
    '`grateful` किसी व्यक्ति के प्रति हो तो कौन-सा प्रीपोज़िशन आता है?',
    'Which preposition follows `grateful` before a person (`you`)?',
    'व्यक्ति के प्रति आभार के लिए हमेशा **`grateful to`** लगता है (*grateful to you*)।',
    'We are always **`grateful to`** a person (`grateful to you`).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (BOARD, EXAM_ONLY) — Formal Letter to Editor Closing
  (
    '10000006-0005-4000-8000-000000000024', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Formal Letter to Editor Closing', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'किसी समाचार-पत्र के संपादक (The Editor) को लिखे गए पत्र के अंत में क्या लिखना सबसे सही है?',
    'What is the most appropriate closing for a Formal Letter to the Editor of a newspaper?',
    $json$[{"key":"A","text_hi":"Yours affectionately,","text_en":"Yours affectionately,"},{"key":"B","text_hi":"Yours truly,","text_en":"Yours truly,"},{"key":"C","text_hi":"Your loving friend,","text_en":"Your loving friend,"},{"key":"D","text_hi":"Your's obediently,","text_en":"Your's obediently,"}]$json$::jsonb, 'B',
    'संपादक (Editor) के लिए औपचारिक समापन चुनें (`obediently` केवल प्रधानाचार्य के लिए होता है)।',
    'Choose the standard formal sign-off for an Editor (`obediently` is for a Principal).',
    'संपादक या अधिकारी को पत्र में **`Yours truly,`** (या `Yours faithfully,`) लिखा जाता है।',
    'Letters to an Editor formally close with **`Yours truly,`** (or `Yours faithfully,`).',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- MCQ (TOPPER, EXAM_ONLY) — Exam Essay Concluding Connector
  (
    '10000006-0005-4000-8000-000000000025', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Exam Essay Concluding Connector', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2023',
    'निबंध के तीसरे पैराग्राफ (Conclusion) की शुरुआत करने के लिए सबसे उपयुक्त शब्द-समूह कौन-सा है?',
    'Which phrase is best for opening the final Conclusion paragraph of an essay?',
    $json$[{"key":"A","text_hi":"Once upon a time,","text_en":"Once upon a time,"},{"key":"B","text_hi":"To, The Principal,","text_en":"To, The Principal,"},{"key":"C","text_hi":"In short, / To sum up,","text_en":"In short, / To sum up,"},{"key":"D","text_hi":"Thanking you,","text_en":"Thanking you,"}]$json$::jsonb, 'C',
    'निष्कर्ष (Conclusion) पूरे निबंध का सार समेटता है!',
    'A conclusion summarizes the essay''s final takeaway!',
    '**"In short,"** या **"To sum up,"** निबंध के निष्कर्ष पैराग्राफ की स्पष्ट व प्रभावशाली शुरुआत करते हैं।',
    '**"In short,"** or **"To sum up,"** neatly signals the concluding summary of an essay.',
    NULL,
    NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  -- SHORT_2M (BOARD, PRACTICE) — Unseen Passage 2M Practice
  (
    '10000006-0005-4000-8000-000000000026', 'skill-eng-foundation', 'skill-eng-f-ch5', 'Unseen Passage 2M Practice', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'निम्नलिखित छोटा गद्यांश पढ़कर दोनों प्रश्नों के उत्तर लिखें (2 अंक):
"Trees are our best friends. They give us fresh oxygen, cool shade, fruits, and wood. They also help bring rain and stop soil erosion. Every student should plant at least one tree every year."
(a) What do trees give us?
(b) What should every student do every year?',
    'Read the short unseen passage and answer both questions cleanly (2 marks):
"Trees are our best friends. They give us fresh oxygen, cool shade, fruits, and wood. They also help bring rain and stop soil erosion. Every student should plant at least one tree every year."
(a) What do trees give us?
(b) What should every student do every year?',
    NULL, NULL,
    'कीवर्ड मिलाएँ: (a) "give us" → पंक्ति 2; (b) "every student should" → अंतिम पंक्ति!',
    'Match keywords: (a) "give us" → line 2; (b) "every student should" → final line!',
    NULL,
    NULL,
    '**(a)** Trees give us fresh oxygen, cool shade, fruits, and wood.
**(b)** Every student should plant at least one tree every year.',
    '**(a)** Trees give us fresh oxygen, cool shade, fruits, and wood.
**(b)** Every student should plant at least one tree every year.',
    $json$[{"cue_hi":"Keyword 1: \"give us\" → fresh oxygen, cool shade, fruits, wood","cue_en":"Keyword 1: \"give us\" → line 2"},{"cue_hi":"Keyword 2: \"every student should\" → plant at least one tree","cue_en":"Keyword 2: \"every student should\" → last line"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"प्रश्न (a) का सटीक और पूर्ण वाक्य में उत्तर","criterion_en":"Complete, accurate answer to (a)"},{"step_no":2,"marks":1,"criterion_hi":"प्रश्न (b) का सटीक और पूर्ण वाक्य में उत्तर","criterion_en":"Complete, accurate answer to (b)"}]$json$::jsonb,
    NULL,
    true
  ),
  -- LONG_5M (BOARD, PRACTICE) — BSEB 5M Principal Application
  (
    '10000006-0005-4000-8000-000000000027', 'skill-eng-foundation', 'skill-eng-f-ch5', 'BSEB 5M Principal Application', 'PRACTICE', 'LONG_5M', 'BOARD', 'BSEB 2024',
    'अपने विद्यालय के प्रधानाचार्य (Principal) को बीमारी के कारण तीन दिन की छुट्टी (Sick Leave) अथवा पूर्ण शुल्क माफ़ी (Fee Concession) हेतु एक आदर्श अंग्रेज़ी आवेदन पत्र लिखें। (5 अंक — सटीक BSEB अंक-योजना सहित)',
    'Write a model formal application to the Principal of your school requesting three days'' sick leave. (5 Marks — with exact BSEB Marking Scheme)',
    NULL, NULL,
    'मास्टर ढाँचा अपनाएँ: To, The Principal + Date + Subject (1M) → Respected Sir + Body (2.5M) → Thanking you + Yours obediently + Name/Class/Roll (1.5M)।',
    'Follow the Master Skeleton: Format/Salutation (1M) + Body (2.5M) + Subscription without apostrophe (1.5M).',
    NULL,
    NULL,
    '```text
To,
The Principal,
U.H.S. Kaparpura,
Muzaffarpur (Bihar)

Date: 15 February 2026

Subject: Application for three days'' sick leave.

Respected Sir,

Most humbly and respectfully I beg to state that I am a regular student of Class X in your school. I have been suffering from high fever since last night. The doctor has advised me complete rest for three days, from 15 February to 17 February 2026. Therefore, I am unable to attend my classes during these days.

Kindly grant me leave for three days. I shall remain ever grateful to you for this act of kindness.

Thanking you,

Yours obediently,
Name: X.Y.Z.
Class: X, Section: A
Roll No.: 12
```
**स्वर्ण टिप:** यदि परीक्षा में **Fee Concession** पूछे, तो बस `Subject` को *"Application for full fee concession"* और बीच की 2 पंक्तियों को *"My father is a poor farmer. He cannot pay my school fees, though I am a hardworking student."* से बदल दें — पूरे 5/5 अंक पक्के!',
    '```text
To,
The Principal,
U.H.S. Kaparpura,
Muzaffarpur (Bihar)

Date: 15 February 2026

Subject: Application for three days'' sick leave.

Respected Sir,

Most humbly and respectfully I beg to state that I am a regular student of Class X in your school. I have been suffering from high fever since last night. The doctor has advised me complete rest for three days, from 15 February to 17 February 2026. Therefore, I am unable to attend my classes during these days.

Kindly grant me leave for three days. I shall remain ever grateful to you for this act of kindness.

Thanking you,

Yours obediently,
Name: X.Y.Z.
Class: X, Section: A
Roll No.: 12
```
**Master Swap Tip:** For **Fee Concession**, swap ONLY the Subject and 2 middle lines (*"My father is a poor farmer who cannot afford my school fees..."*) — instant 5/5 marks!',
    $json$[{"cue_hi":"Salutation & Format (1 अंक): To, The Principal + Date + Subject + Respected Sir","cue_en":"Format & Salutation (1M): To, The Principal + Date + Subject + Respected Sir"},{"cue_hi":"Body (2.5 अंक): Most humbly... + suffering from fever + Kindly grant me leave","cue_en":"Body (2.5M): Polite opener + exact reason + clear request"},{"cue_hi":"Subscription (1.5 अंक): Thanking you + Yours obediently (बिना apostrophe!) + Name/Class/Roll","cue_en":"Subscription (1.5M): Thanking you + Yours obediently (NO apostrophe!) + Name/Class/Roll"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"सही Address, Date, Subject तथा Salutation (Respected Sir,) लिखना","criterion_en":"Salutation & Format (To, The Principal, Date, Subject, Respected Sir,)"},{"step_no":2,"marks":2.5,"criterion_hi":"स्पष्ट, विनम्र और व्याकरण-शुद्ध मुख्य विषय (Body: कारण + छुट्टी की अवधि + अनुरोध)","criterion_en":"Body: polite opening, accurate reason/dates, and clear request"},{"step_no":3,"marks":1.5,"criterion_hi":"सही Subscription (Thanking you, Yours obediently बिना apostrophe के + Name/Class/Roll)","criterion_en":"Subscription: Thanking you, Yours obediently (no apostrophe) + student details"}]$json$::jsonb,
    NULL,
    true
  ),
  -- LONG_5M (BOARD, PRACTICE) — BSEB 5M Easy Essay
  (
    '10000006-0005-4000-8000-000000000028', 'skill-eng-foundation', 'skill-eng-f-ch5', 'BSEB 5M Easy Essay', 'PRACTICE', 'LONG_5M', 'BOARD', 'BSEB 2024',
    '3-बॉक्स आसान विधि (Introduction → 3 Ideas Body → Conclusion) का उपयोग करते हुए **"Importance of Discipline" (अनुशासन का महत्व)** पर लगभग 120–150 शब्दों का एक सरल और उच्च-अंक वाला अंग्रेज़ी निबंध लिखें। (5 अंक)',
    'Write a clean, high-scoring 120–150 word essay on **"Importance of Discipline"** using the 3-Box Blueprint (Introduction → 3 Ideas Body → Conclusion). (5 Marks)',
    NULL, NULL,
    '3 अलग पैराग्राफ बनाएँ और छोटे, शुद्ध S+V+O वाक्य लिखें (परिचय 1M + मुख्य विचार 3M + निष्कर्ष 1M)।',
    'Organize neatly into 3 clear paragraphs with crisp S+V+O sentences (Intro 1M + Body 3M + Conclusion 1M).',
    NULL,
    NULL,
    '### Importance of Discipline

**Introduction:**
Discipline means following good rules in our daily life. It is the true key to success and peace. Without discipline, a person cannot achieve big goals in life.

**Body (3 Simple Ideas):**
First, discipline is very important for students. A disciplined student wakes up early, attends school regularly, respects teachers, and revises lessons daily. Second, nature itself teaches us discipline. The sun rises on time, seasons change in order, and rivers flow steadily. Third, discipline makes a society and nation strong. Soldiers on the border, players on the field, and citizens on the road succeed only when they obey rules.

**Conclusion:**
In short, discipline builds good character and leads us to a bright future. Every student of Bihar and India must practise discipline from childhood.

*(हिंदी सार: अनुशासन जीवन में अच्छे नियमों का पालन है। यह विद्यार्थी को सफल बनाता है, प्रकृति भी हमें अनुशासन सिखाती है, और यही देश को महान बनाता है।)*',
    '### Importance of Discipline

**Introduction:**
Discipline means following good rules in our daily life. It is the true key to success and peace. Without discipline, a person cannot achieve big goals in life.

**Body (3 Simple Ideas):**
First, discipline is very important for students. A disciplined student wakes up early, attends school regularly, respects teachers, and revises lessons daily. Second, nature itself teaches us discipline. The sun rises on time, seasons change in order, and rivers flow steadily. Third, discipline makes a society and nation strong. Soldiers on the border, players on the field, and citizens on the road succeed only when they obey rules.

**Conclusion:**
In short, discipline builds good character and leads us to a bright future. Every student of Bihar and India must practise discipline from childhood.',
    $json$[{"cue_hi":"Box 1 (Intro): Discipline = following rules + key to success","cue_en":"Box 1 (Intro): Define discipline + key to success"},{"cue_hi":"Box 2 (3 Points): 1. Student life · 2. Nature (sun/seasons) · 3. Nation/Soldiers","cue_en":"Box 2 (3 Points): 1. Student life · 2. Nature · 3. Society & Nation"},{"cue_hi":"Box 3 (Conclusion): In short, builds character + bright future","cue_en":"Box 3 (Conclusion): In short, builds character & bright future"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"सटीक शीर्षक व स्पष्ट 2–3 वाक्यों का परिचय (Introduction)","criterion_en":"Clear title & crisp 2–3 sentence Introduction"},{"step_no":2,"marks":3,"criterion_hi":"मुख्य भाग (Body) में 3 तार्किक बिंदु, शुद्ध सरल अंग्रेज़ी व स्पष्ट पैराग्राफ","criterion_en":"Body covering 3 clear ideas in accurate, simple English"},{"step_no":3,"marks":1,"criterion_hi":"सकारात्मक और संक्षिप्त निष्कर्ष (Conclusion)","criterion_en":"Concise, positive Conclusion"}]$json$::jsonb,
    NULL,
    true
  )
ON CONFLICT (id) DO UPDATE SET
  subject_id          = EXCLUDED.subject_id,
  chapter_id          = EXCLUDED.chapter_id,
  topic_tag           = EXCLUDED.topic_tag,
  bank_pool           = EXCLUDED.bank_pool,
  question_type       = EXCLUDED.question_type,
  difficulty_tier     = EXCLUDED.difficulty_tier,
  exam_year_tag       = EXCLUDED.exam_year_tag,
  q_hi                = EXCLUDED.q_hi,
  q_en                = EXCLUDED.q_en,
  options_json        = EXCLUDED.options_json,
  correct_option      = EXCLUDED.correct_option,
  clue_hi             = EXCLUDED.clue_hi,
  clue_en             = EXCLUDED.clue_en,
  explanation_hi      = EXCLUDED.explanation_hi,
  explanation_en      = EXCLUDED.explanation_en,
  model_answer_hi     = EXCLUDED.model_answer_hi,
  model_answer_en     = EXCLUDED.model_answer_en,
  memory_cues_json    = EXCLUDED.memory_cues_json,
  marking_scheme_json = EXCLUDED.marking_scheme_json,
  visual_asset_json   = EXCLUDED.visual_asset_json,
  is_published        = EXCLUDED.is_published;
