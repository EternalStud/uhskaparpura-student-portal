-- =============================================================================
-- Students of Bihar (9-12) — ICT & Digital Skills Lab Master Curriculum Seed
-- Subject: skill-ict-lab (Universal Skill Track for Classes 9, 10, 11 & 12)
-- Philosophy: QUALITY 10/10 — Zero-to-Mastery Visual Bilingual ICT Curriculum
--
-- Covers all 6 complete chapters + 6 Teacher Lesson Plans (with Power-Cut Backup)
-- + 130 multi-mode questions (Flashcards, Match Pairs, Diagram Labels,
-- Shortcut Studio, Excel Sandbox, Scenario Labs, 3-Tier MCQs, EXAM_ONLY & 2M/5M):
--   1. skill-ict-ch1 : Computer From Zero: Parts, Input-Output & CPU
--   2. skill-ict-ch2 : Keyboard, Mouse & Windows Files Mastery
--   3. skill-ict-ch3 : Microsoft Word Practical Mastery
--   4. skill-ict-ch4 : Microsoft Excel & Spreadsheet Magic
--   5. skill-ict-ch5 : Internet, Email, Digital Bihar & Cyber Safety
--   6. skill-ict-ch6 : Artificial Intelligence (AI) & Smart Studying
--
-- 100% Idempotent (ON CONFLICT DO UPDATE) with deterministic UUIDs in
-- namespace 10000005-000X-4000-8000-0000000000YY (zero collisions with 003/006/007).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CHAPTERS CATALOG (subject_id = 'skill-ict-lab')
-- -----------------------------------------------------------------------------
INSERT INTO public.chapters (
  id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published
) VALUES
  ('skill-ict-ch1', 'skill-ict-lab', 1, 'Computer From Zero: Parts, Input–Output & CPU', 'कंप्यूटर की शुरुआत: भाग, इनपुट-आउटपुट और कार्यप्रणाली', 'Start from absolute zero: understand how a computer works like the human body (IPO cycle), identify Hardware & Software, explore CPU (ALU, CU), RAM vs Hard Disk, KB–TB data units, and safe Power On/Shut Down.', 'बिल्कुल शून्य से शुरुआत करें: कंप्यूटर की कार्यप्रणाली (IPO चक्र), हार्डवेयर-सॉफ्टवेयर, इनपुट-आउटपुट उपकरण, CPU (ALU व CU), RAM बनाम हार्ड डिस्क, KB से TB तक डेटा माप और सुरक्षित शटडाउन सीखें।', 15, 18, true),
  ('skill-ict-ch2', 'skill-ict-lab', 2, 'Keyboard, Mouse & Windows Files Mastery', 'कीबोर्ड, माउस और विंडोज़ फाइल प्रबंधन', 'Gain effortless confidence with every mouse action, keyboard key group (Shift, Backspace vs Delete, Caps Lock, Enter), Windows Desktop, Folders, File Extensions (.docx, .pdf, .jpg), Clipboard shortcuts (Ctrl+C/X/V/Z), and Recycle Bin recovery.', 'माउस की हर क्रिया, कीबोर्ड के सभी मुख्य बटन (Shift, Backspace बनाम Delete, Caps Lock), विंडोज़ डेस्कटॉप, फोल्डर प्रबंधन, फाइल एक्सटेंशन (.docx, .pdf, .jpg), क्लिपबोर्ड शॉर्टकट (Ctrl+C/X/V/Z) और रीसाइकल बिन से फाइल वापस लाना सीखें।', 15, 18, true),
  ('skill-ict-ch3', 'skill-ict-lab', 3, 'Microsoft Word Practical Mastery', 'एमएस वर्ड: टाइपिंग, फॉर्मेटिंग और आवेदन पत्र', 'Master Microsoft Word from scratch: Ribbon tabs, Bold/Italic/Underline, Fonts & Alignment (Left, Center, Right, Justify), Tables, Bullet lists, Spell-Check lines, A4 Page Setup, Export to PDF, and typing your own official Principal Application!', 'एमएस वर्ड को व्यवहारिक रूप से सीखें: रिबन टैब, Bold/Italic/Underline, फॉन्ट व संरेखण (Alignment), टेबल, बुलेट सूची, वर्तनी जाँच (Red/Blue रेखा), A4 पेज सेटअप, PDF सेव करना और प्रधानाध्यापक को सुंदर आवेदन पत्र बनाना!', 15, 20, true),
  ('skill-ict-ch4', 'skill-ict-lab', 4, 'Microsoft Excel & Spreadsheet Magic', 'एमएस एक्सेल: तालिका, सेल और फॉर्मूला सीखें', 'Turn numbers into magic with MS Excel: master Rows, Columns, Cell Addresses (B2), Ranges (B2:D2), the Golden "=" Rule, top 6 formulas (=SUM, =AVERAGE, =MAX, =MIN, =COUNT, =IF), Fill Handle, Sort/Filter, Charts, and fixing Excel errors!', 'एमएस एक्सेल से गणना का जादू सीखें: पंक्ति, स्तंभ, सेल एड्रेस (B2), रेंज (B2:D2), सुनहरा "=" नियम, 6 मुख्य फॉर्मूले (=SUM, =AVERAGE, =MAX, =MIN, =COUNT, =IF), फिल हैंडल, सॉर्ट-फ़िल्टर, चार्ट और त्रुटि सुधार!', 20, 22, true),
  ('skill-ict-ch5', 'skill-ict-lab', 5, 'Internet, Email, Digital Bihar & Cyber Safety', 'इंटरनेट, ईमेल, डिजिटल बिहार और साइबर सुरक्षा', 'Navigate the digital world safely and smartly: Browser vs Search Engine, safe HTTPS & .gov.in URLs, professional Email (To/CC/BCC/Attachments), Digital Bihar portals (RTPS, DigiLocker, BSEB, Medhasoft), strong passwords, and blocking OTP/UPI/fake scholarship scams (Helpline 1930).', 'डिजिटल दुनिया में सुरक्षित और आत्मनिर्भर बनें: ब्राउज़र बनाम सर्च इंजन, सुरक्षित HTTPS व .gov.in पहचान, ईमेल (To/CC/BCC), डिजिटल बिहार पोर्टल (RTPS, DigiLocker, BSEB), मज़बूत पासवर्ड और OTP/UPI/फर्जी छात्रवृत्ति ठगी से बचाव (हेल्पलाइन 1930)!', 15, 18, true),
  ('skill-ict-ch6', 'skill-ict-lab', 6, 'Artificial Intelligence (AI) & Smart Studying', 'कृत्रिम बुद्धिमत्ता (AI) और स्मार्ट पढ़ाई', 'Discover Artificial Intelligence in simple everyday language: how AI learns patterns, daily AI tools already in your pocket, the R-C-F Prompt Formula for smart board-exam studying (not lazy cheating!), spotting AI Hallucinations, and defending your family against Deepfake scams.', 'सरल भाषा में कृत्रिम बुद्धिमत्ता (AI) को समझें: AI पैटर्न कैसे सीखता है, रोज़मर्रा के AI टूल्स, स्मार्ट पढ़ाई का R-C-F प्रॉम्प्ट फॉर्मूला (नकल नहीं, समझ!), AI भ्रम (Hallucination) की जाँच और डीपफेक (Deepfake) से सुरक्षा!', 15, 18, true)
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
-- CHAPTER 1 OF 6: SKILL-ICT-CH1 — COMPUTER FROM ZERO: PARTS, INPUT–OUTPUT & CPU
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-ict-ch1',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: कंप्यूटर की शुरुआत (भाग, IPO और CPU)",
  "title_en": "30-Second Mindmap: Computer From Zero (Parts, IPO & CPU)",
  "read_time_seconds": 30,
  "central_node": {
    "id": "ict1-root",
    "label_hi": "कंप्यूटर प्रणाली (Computer System)",
    "label_en": "Computer System",
    "subtitle_hi": "Input → Process (CPU) → Output + Storage",
    "subtitle_en": "Input → Process (CPU) → Output + Storage"
  },
  "branches": [
    {
      "id": "ict1-b1",
      "label_hi": "1. IPO कार्य चक्र (कैसे काम करता है?)",
      "label_en": "1. IPO Cycle (How It Works)",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "ict1-b1-1",
          "label_hi": "इनपुट (Input): डेटा अंदर भेजना",
          "label_en": "Input: Entering data & commands",
          "detail_hi": "कीबोर्ड, माउस, माइक्रोफ़ोन, स्कैनर।",
          "detail_en": "Keyboard, Mouse, Microphone, Scanner."
        },
        {
          "id": "ict1-b1-2",
          "label_hi": "प्रोसेसिंग (CPU): कंप्यूटर का दिमाग",
          "label_en": "Processing (CPU): Brain of Computer",
          "detail_hi": "ALU (गणना) + CU (नियंत्रण) + Registers।",
          "detail_en": "ALU (Calculations) + CU (Control) + Registers."
        },
        {
          "id": "ict1-b1-3",
          "label_hi": "आउटपुट (Output): परिणाम दिखाना",
          "label_en": "Output: Showing final result",
          "detail_hi": "मॉनिटर (Soft Copy), प्रिंटर (Hard Copy), स्पीकर।",
          "detail_en": "Monitor (Soft Copy), Printer (Hard Copy), Speaker."
        }
      ]
    },
    {
      "id": "ict1-b2",
      "label_hi": "2. हार्डवेयर बनाम सॉफ्टवेयर",
      "label_en": "2. Hardware vs Software",
      "color": "#059669",
      "children": [
        {
          "id": "ict1-b2-1",
          "label_hi": "हार्डवेयर: जिन्हें छू सकते हैं",
          "label_en": "Hardware: Physical touchable parts",
          "detail_hi": "मॉनिटर, CPU, कीबोर्ड, माउस, प्रिंटर।",
          "detail_en": "Monitor, CPU, Keyboard, Mouse, Printer."
        },
        {
          "id": "ict1-b2-2",
          "label_hi": "सॉफ्टवेयर: प्रोग्राम व ऐप्स",
          "label_en": "Software: Programs & instructions",
          "detail_hi": "System (Windows/Android) और Application (MS Word, Excel)।",
          "detail_en": "System (Windows/Android) and Application (MS Word, Excel)."
        }
      ]
    },
    {
      "id": "ict1-b3",
      "label_hi": "3. मेमोरी (RAM, ROM व स्टोरेज)",
      "label_en": "3. Memory (RAM, ROM & Storage)",
      "color": "#D97706",
      "children": [
        {
          "id": "ict1-b3-1",
          "label_hi": "RAM (अस्थायी / Volatile)",
          "label_en": "RAM (Temporary / Volatile)",
          "detail_hi": "बिजली जाने पर डेटा मिट जाता है — पढ़ाई की मेज़ जैसा।",
          "detail_en": "Clears when power turns off — like your study desk."
        },
        {
          "id": "ict1-b3-2",
          "label_hi": "ROM व Hard Disk / SSD (स्थायी)",
          "label_en": "ROM & Hard Disk / SSD (Permanent)",
          "detail_hi": "बिजली बंद होने पर भी डेटा सुरक्षित — अलमारी जैसा।",
          "detail_en": "Data stays safe without power — like a steel almirah."
        }
      ]
    },
    {
      "id": "ict1-b4",
      "label_hi": "4. डेटा की इकाइयाँ व सुरक्षित शटडाउन",
      "label_en": "4. Data Units & Safe Shut Down",
      "color": "#7C3AED",
      "formula_latex": "1\\text{ Byte} = 8\\text{ Bits},\\quad 1\\text{ KB} = 1024\\text{ Bytes}",
      "children": [
        {
          "id": "ict1-b4-1",
          "label_hi": "क्रम: Bit → Byte → KB → MB → GB → TB",
          "label_en": "Order: Bit → Byte → KB → MB → GB → TB"
        },
        {
          "id": "ict1-b4-2",
          "label_hi": "सही बंद करना: Start → Power → Shut Down",
          "label_en": "Safe Shut Down: Start → Power → Shut Down"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "ict1-sec-1-ipo",
    "order": 1,
    "heading_hi": "1. कंप्यूटर क्या है? मानव शरीर और आटा-चक्की से IPO चक्र समझें",
    "heading_en": "1. What is a Computer? Learn the IPO Cycle via Human Body & Flour Mill",
    "analogy_hi": "कंप्यूटर कोई डरावनी विदेशी मशीन नहीं है — यह बिल्कुल **हमारे शरीर** की तरह काम करता है! जैसे हमारी **आँखें और कान** बाहर से जानकारी अंदर लेते हैं (**Input**), हमारा **दिमाग** उस पर सोचकर उत्तर निकालता है (**Process / CPU**), और हमारा **मुँह या हाथ** उत्तर बताता है (**Output**)। गाँव की **आटा-चक्की** में भी यही नियम है: गेहूँ डालना = **Input**, चक्की का पीसना = **Process**, और ताज़ा आटा निकलना = **Output**!",
    "analogy_en": "A computer is not a scary machine — it works just like **your own body**! Your **eyes and ears** take in information (**Input**), your **brain** thinks and calculates (**Process / CPU**), and your **mouth or hand** gives the answer (**Output**). A village **flour mill (Atta Chakki)** follows the exact same rule: Wheat in = **Input**, Grinding = **Process**, Fresh Flour out = **Output**!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "कंप्यूटर का IPO चक्र और स्टोरेज ब्लॉक आरेख",
      "title_en": "Computer IPO Cycle & Storage Block Diagram",
      "caption_hi": "हर कंप्यूटर इसी चार-भाग प्रणाली पर चलता है: इनपुट से डेटा CPU में जाता है, CPU के ALU व CU उसे प्रोसेस करते हैं, आउटपुट परिणाम दिखाता है और स्टोरेज उसे भविष्य के लिए सहेजता है।",
      "caption_en": "Every computer runs on this 4-part system: Input sends data to CPU, ALU and CU process it, Output displays the result, and Storage saves it for future use.",
      "viewBox": "0 0 660 290",
      "elements": [
        {
          "kind": "rect",
          "x": 20,
          "y": 48,
          "width": 145,
          "height": 112,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 92,
          "y": 78,
          "text_hi": "1. इनपुट (Input)",
          "text_en": "1. Input Unit",
          "fill": "#1E3A8A",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 92,
          "y": 122,
          "text_hi": "कीबोर्ड, माउस, माइक",
          "text_en": "Keyboard, Mouse, Mic",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 165,
          "y1": 104,
          "x2": 208,
          "y2": 104,
          "stroke": "#1E3A8A",
          "strokeWidth": 2.5
        },
        {
          "kind": "rect",
          "x": 212,
          "y": 20,
          "width": 236,
          "height": 168,
          "rx": 12,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 330,
          "y": 44,
          "text_hi": "2. प्रोसेसिंग: CPU (दिमाग)",
          "text_en": "2. Processing: CPU (Brain)",
          "fill": "#92400E",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 228,
          "y": 74,
          "width": 96,
          "height": 48,
          "rx": 7,
          "fill": "#FFFFFF",
          "stroke": "#D97706",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 276,
          "y": 94,
          "text_hi": "ALU (गणना)",
          "text_en": "ALU (Math)",
          "fill": "#92400E",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 336,
          "y": 74,
          "width": 96,
          "height": 48,
          "rx": 7,
          "fill": "#FFFFFF",
          "stroke": "#D97706",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 384,
          "y": 94,
          "text_hi": "CU (नियंत्रण)",
          "text_en": "CU (Control)",
          "fill": "#92400E",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 248,
          "y": 132,
          "width": 164,
          "height": 42,
          "rx": 7,
          "fill": "#FFFBEB",
          "stroke": "#B45309",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 330,
          "y": 150,
          "text_hi": "प्राथमिक मेमोरी (RAM)",
          "text_en": "Primary Memory (RAM)",
          "fill": "#78350F",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 448,
          "y1": 104,
          "x2": 491,
          "y2": 104,
          "stroke": "#059669",
          "strokeWidth": 2.5
        },
        {
          "kind": "rect",
          "x": 495,
          "y": 48,
          "width": 145,
          "height": 112,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 567,
          "y": 78,
          "text_hi": "3. आउटपुट (Output)",
          "text_en": "3. Output Unit",
          "fill": "#065F46",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 567,
          "y": 122,
          "text_hi": "मॉनिटर, प्रिंटर, स्पीकर",
          "text_en": "Monitor, Printer, Speaker",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 315,
          "y1": 188,
          "x2": 315,
          "y2": 220,
          "stroke": "#7C3AED",
          "strokeWidth": 2.2
        },
        {
          "kind": "arrow",
          "x1": 345,
          "y1": 220,
          "x2": 345,
          "y2": 188,
          "stroke": "#7C3AED",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 180,
          "y": 224,
          "width": 300,
          "height": 54,
          "rx": 10,
          "fill": "#F5F3FF",
          "stroke": "#7C3AED",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 330,
          "y": 247,
          "text_hi": "4. स्थायी स्टोरेज (Hard Disk / SSD / Pen Drive)",
          "text_en": "4. Permanent Storage (Hard Disk / SSD / Pen Drive)",
          "fill": "#5B21B6",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### कंप्यूटर के 3 प्रमुख गुण और CPU के 2 मुख्य हिस्से\n- **कंप्यूटर (Computer):** एक इलेक्ट्रॉनिक मशीन जो कच्चा **डेटा (Input)** लेती है, निर्देशों के अनुसार उसे **प्रोसेस** करती है और सटीक **सूचना (Output)** देती है।\n- **CPU (Central Processing Unit)** — कंप्यूटर का दिमाग! इसके दो प्रमुख भाग हैं:\n  1. **ALU (Arithmetic Logic Unit):** सभी गणितीय कार्य ($+, -, \\times, \\div$) और तुलना ($>, <, =$) करता है।\n  2. **CU (Control Unit):** स्कूल के प्रधानाध्यापक जैसा — कीबोर्ड, मॉनिटर, मेमोरी और प्रिंटर के बीच पूरा तालमेल नियंत्रित करता है।\n- **4 बड़ी ताकतें:** अत्यधिक गति (Speed), 100% सटीकता (Accuracy), बिना थके काम (Diligence), और बड़ी भंडारण क्षमता (Storage)।",
    "concept_md_en": "### What Makes a Computer Powerful & Inside the CPU\n- **Computer:** An electronic machine that accepts raw **Data (Input)**, processes it following instructions, and produces meaningful **Information (Output)**.\n- **CPU (Central Processing Unit)** — the Brain of the Computer! It has two core parts:\n  1. **ALU (Arithmetic Logic Unit):** Performs all math ($+, -, \\times, \\div$) and logical comparisons ($>, <, =$).\n  2. **CU (Control Unit):** Works like a school Principal — directs and coordinates data flow between keyboard, memory, ALU, and monitor.\n- **4 Superpowers:** High Speed, Accuracy (zero calculation mistakes if input is right), Diligence (never gets tired), and Massive Storage.",
    "exam_tip_hi": "बोर्ड व लैब वाइवा का सबसे आम सवाल: \"कंप्यूटर का दिमाग किसे कहते हैं?\" उत्तर: **CPU (Central Processing Unit)**। ध्यान रखें — बाहर दिखने वाला बड़ा डिब्बा **CPU Cabinet / System Unit** है, असली CPU चिप (Processor) उसके अंदर मदरबोर्ड पर लगी होती है!",
    "exam_tip_en": "Most asked Lab Viva & Exam question: \"What is the brain of the computer?\" Answer: **CPU (Central Processing Unit)**. Bonus insight: the big outer box is the **System Unit / Cabinet** — the actual CPU chip sits inside on the motherboard!",
    "glossary_terms": [
      {
        "term_hi": "CPU (सेंट्रल प्रोसेसिंग यूनिट)",
        "term_en": "CPU (Central Processing Unit)",
        "pronunciation_hi": "सी-पी-यू (सेंट्रल प्रोसेसिंग यूनिट)",
        "definition_hi": "कंप्यूटर का मुख्य मस्तिष्क चिप जो सभी गणनाएँ (ALU) और नियंत्रण कार्य (CU) करता है।",
        "definition_en": "The main brain chip of a computer that executes calculations (ALU) and controls all parts (CU)."
      },
      {
        "term_hi": "इनपुट और आउटपुट (IPO चक्र)",
        "term_en": "Input & Output (IPO Cycle)",
        "pronunciation_hi": "इनपुट — आउटपुट (आई-पी-ओ साइकिल)",
        "definition_hi": "कंप्यूटर में डेटा भेजना इनपुट कहलाता है और प्रोसेस के बाद मिलने वाला परिणाम आउटपुट कहलाता है।",
        "definition_en": "Sending data into a computer is Input; receiving the processed result is Output."
      }
    ],
    "quick_check": {
      "q_hi": "यदि आप कंप्यूटर में `25 + 15` टाइप करते हैं, तो जोड़ने का काम CPU का कौन-सा भाग करेगा — ALU या CU?",
      "q_en": "When you type `25 + 15` into a computer, which part of the CPU actually adds the numbers — ALU or CU?",
      "answer_hi": "**ALU (Arithmetic Logic Unit)**, क्योंकि सभी गणितीय जोड़-घटाव और तुलना ALU करता है।",
      "answer_en": "**ALU (Arithmetic Logic Unit)**, because the ALU handles every arithmetic calculation and logical comparison."
    }
  },
  {
    "id": "ict1-sec-2-hw-sw",
    "order": 2,
    "heading_hi": "2. हार्डवेयर बनाम सॉफ्टवेयर — और इनपुट-आउटपुट उपकरणों की पहचान",
    "heading_en": "2. Hardware vs Software — & Identifying Input vs Output Devices",
    "analogy_hi": "अपने हाथ में पकड़ा **मोबाइल फोन** देखिए: उसकी स्क्रीन, बैटरी और बॉडी को आप छू सकते हैं — वह **हार्डवेयर (Hardware)** है। लेकिन उसके अंदर चलने वाला **WhatsApp, Calculator या Android** आप हाथ में नहीं पकड़ सकते — वह **सॉफ्टवेयर (Software)** है! बिना सॉफ्टवेयर के हार्डवेयर बिल्कुल एक ऐसे **हारमोनियम** जैसा है जिसे बजाने वाला कोई न हो।",
    "analogy_en": "Look at a **mobile phone**: its screen, body, and battery can be touched — that is **Hardware**. The **WhatsApp, Calculator, or Android** running inside cannot be held in your hand — that is **Software**! Without software, hardware is just like a **harmonium** with no musician to play it.",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "इनपुट, आउटपुट और स्टोरेज उपकरणों की तुरंत पहचान तालिका",
      "title_en": "Quick-ID Table: Input, Output & Storage Devices",
      "caption_hi": "ट्रिक: जो उपकरण जानकारी को इंसान से कंप्यूटर के अंदर भेजे वह Input है; जो कंप्यूटर से बाहर इंसान तक लाए वह Output है!",
      "caption_en": "Simple rule: Devices sending data FROM you INTO the computer are Input; devices bringing results OUT to you are Output!",
      "headers_hi": [
        "श्रेणी",
        "प्रमुख उपकरण",
        "सरल कार्य",
        "स्कूल / दैनिक उदाहरण"
      ],
      "headers_en": [
        "Category",
        "Key Devices",
        "Simple Role",
        "School / Daily Example"
      ],
      "rows": [
        {
          "cells_hi": [
            "इनपुट उपकरण (Input)",
            "कीबोर्ड, माउस, स्कैनर, माइक, वेबकैम",
            "कंप्यूटर को डेटा और आदेश देना",
            "आवेदन टाइप करना, मार्कशीट स्कैन करना"
          ],
          "cells_en": [
            "Input Devices",
            "Keyboard, Mouse, Scanner, Mic, Webcam",
            "Send data & commands into computer",
            "Typing an application, scanning marksheet"
          ]
        },
        {
          "cells_hi": [
            "आउटपुट उपकरण (Output)",
            "मॉनिटर, प्रिंटर, स्पीकर, प्रोजेक्टर",
            "परिणाम स्क्रीन, कागज़ या आवाज़ में देना",
            "स्क्रीन पर रिजल्ट देखना (Soft Copy), प्रिंट निकालना (Hard Copy)"
          ],
          "cells_en": [
            "Output Devices",
            "Monitor, Printer, Speaker, Projector",
            "Show results on screen, paper, or audio",
            "Viewing result on screen (Soft Copy), printing it (Hard Copy)"
          ]
        },
        {
          "cells_hi": [
            "स्टोरेज उपकरण (Storage)",
            "हार्ड डिस्क (HDD), SSD, पेन ड्राइव, मेमोरी कार्ड",
            "फाइलों को लंबे समय तक सुरक्षित रखना",
            "प्रोजेक्ट फाइलें, फोटो और वीडियो सहेजना"
          ],
          "cells_en": [
            "Storage Devices",
            "Hard Disk (HDD), SSD, Pen Drive, SD Card",
            "Keep files saved permanently",
            "Saving project files, photos, and videos"
          ]
        },
        {
          "cells_hi": [
            "दोनों (Input + Output)",
            "टचस्क्रीन (Touchscreen), हेडसेट",
            "छूकर निर्देश देना और स्क्रीन पर देखना दोनों",
            "स्मार्टफोन स्क्रीन, ATM मशीन स्क्रीन"
          ],
          "cells_en": [
            "Both (Input + Output)",
            "Touchscreen, Headset with Mic",
            "Takes touch input and displays output",
            "Smartphone screen, ATM screen"
          ]
        }
      ]
    },
    "concept_md_hi": "### सॉफ्टवेयर के 2 मुख्य प्रकार\n1. **सिस्टम सॉफ्टवेयर (System Software):** कंप्यूटर को चालू करने और चलाने वाला मुख्य मैनेजर। उदाहरण: **Windows 10/11, Linux, Android**। इसके बिना कंप्यूटर शुरू ही नहीं होगा!\n2. **एप्लिकेशन सॉफ्टवेयर (Application Software):** किसी खास काम के लिए बनाए गए प्रोग्राम। उदाहरण: पत्र लिखने के लिए **MS Word**, तालिका व जोड़ के लिए **MS Excel**, चित्र बनाने के लिए **MS Paint**, और इंटरनेट के लिए **Google Chrome**।\n\n**सॉफ्ट कॉपी बनाम हार्ड कॉपी:** मॉनिटर पर दिखने वाला दस्तावेज़ **Soft Copy** है (जिसे बदल सकते हैं); प्रिंटर से कागज़ पर निकला हुआ पन्ना **Hard Copy** है!",
    "concept_md_en": "### 2 Main Types of Software\n1. **System Software:** The core manager that starts and runs the computer hardware. Examples: **Windows 10/11, Linux, Android**. Without it, a computer cannot even boot!\n2. **Application Software:** Tools built for specific tasks. Examples: **MS Word** for letters, **MS Excel** for marksheets, **MS Paint** for drawing, and **Google Chrome** for browsing.\n\n**Soft Copy vs Hard Copy:** A document shown on the monitor is a **Soft Copy** (editable); the printout on physical paper from a printer is a **Hard Copy**!",
    "exam_tip_hi": "परीक्षा का चालाक प्रश्न: \"स्कैनर (Scanner) क्या है और प्रिंटर (Printer) क्या है?\" याद रखें: **स्कैनर** कागज़ को कंप्यूटर के अंदर भेजता है = **Input**; **प्रिंटर** कंप्यूटर से कागज़ बाहर निकालता है = **Output**!",
    "exam_tip_en": "Classic exam trap: \"Is a Scanner Input or Output?\" Remember: a **Scanner** puts paper INTO the computer = **Input**; a **Printer** brings paper OUT of the computer = **Output**!",
    "glossary_terms": [
      {
        "term_hi": "हार्डवेयर (Hardware)",
        "term_en": "Hardware",
        "pronunciation_hi": "हार्ड-वे-यर",
        "definition_hi": "कंप्यूटर के वे सभी भौतिक भाग जिन्हें हम देख और हाथों से छू सकते हैं (जैसे मॉनिटर, माउस, कीबोर्ड)।",
        "definition_en": "All physical parts of a computer that you can see and touch with your hands."
      },
      {
        "term_hi": "ऑपरेटिंग सिस्टम (Operating System)",
        "term_en": "Operating System (OS)",
        "pronunciation_hi": "ऑपरेटिंग सिस्टम",
        "definition_hi": "मुख्य सिस्टम सॉफ्टवेयर (जैसे Windows या Android) जो यूज़र और हार्डवेयर के बीच पुल का काम करता है।",
        "definition_en": "Core system software (like Windows or Android) that acts as a bridge between user and hardware."
      }
    ],
    "quick_check": {
      "q_hi": "क्या **MS Word** हार्डवेयर है या एप्लिकेशन सॉफ्टवेयर?",
      "q_en": "Is **MS Word** hardware or application software?",
      "answer_hi": "**एप्लिकेशन सॉफ्टवेयर (Application Software)**, क्योंकि यह टाइपिंग और डॉक्यूमेंट बनाने का प्रोग्राम है।",
      "answer_en": "**Application Software**, because it is a program designed for typing and creating documents."
    }
  },
  {
    "id": "ict1-sec-3-memory",
    "order": 3,
    "heading_hi": "3. RAM, ROM और Hard Disk/SSD — पढ़ाई की मेज़ बनाम अलमारी!",
    "heading_en": "3. RAM, ROM & Hard Disk/SSD — Study Desk vs Steel Almirah!",
    "analogy_hi": "कल्पना कीजिए आप रात में पढ़ रहे हैं। आपकी **पढ़ाई की मेज़ (Study Desk)** पर वही 2-3 किताबें खुली हैं जो आप अभी पढ़ रहे हैं — यह **RAM** है (बहुत तेज़, पर सीमित जगह, और लाइट बंद होते ही मेज़ खाली!)। कमरे की बड़ी **स्टील अलमारी (Almirah)** में साल भर की सभी किताबें सुरक्षित रखी हैं — यह **Hard Disk / SSD** है (बड़ी जगह, बिजली जाने पर भी सब सुरक्षित!)। और दीवार पर चिपका **स्कूल का स्थायी नियम-चार्ट** जिसे कोई मिटा नहीं सकता — वह **ROM** है!",
    "analogy_en": "Imagine studying at home. Your **Study Desk** holds only the 2–3 open books you are using right now — that is **RAM** (super fast, limited space, cleared when power goes off!). Your big **Steel Almirah** holds all your notebooks safely all year — that is your **Hard Disk / SSD** (huge permanent storage!). And the permanent **printed instruction plate** bolted to the wall is **ROM**!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "मेमोरी तुलना: RAM (मेज़) बनाम ROM बनाम Hard Disk / SSD (अलमारी)",
      "title_en": "Memory Comparison: RAM (Desk) vs ROM vs Hard Disk / SSD (Almirah)",
      "caption_hi": "RAM तेज़ लेकिन अस्थायी (Volatile) होती है। ROM व Hard Disk/SSD स्थायी (Non-Volatile) होते हैं। इसलिए काम करते समय Ctrl + S से फाइल Hard Disk में सेव करना ज़रूरी है!",
      "caption_en": "RAM is fast but temporary (Volatile). ROM and Hard Disk/SSD are permanent (Non-Volatile). That is why pressing Ctrl + S saves your work from RAM onto the Hard Disk!",
      "viewBox": "0 0 660 270",
      "elements": [
        {
          "kind": "rect",
          "x": 20,
          "y": 26,
          "width": 195,
          "height": 215,
          "rx": 12,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 117,
          "y": 54,
          "text_hi": "RAM (पढ़ाई की मेज़)",
          "text_en": "RAM (Study Desk)",
          "fill": "#92400E",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "line",
          "x1": 38,
          "y1": 88,
          "x2": 197,
          "y2": 88,
          "stroke": "#F59E0B",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 117,
          "y": 112,
          "text_hi": "अस्थायी (Volatile)",
          "text_en": "Temporary (Volatile)",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 117,
          "y": 154,
          "text_hi": "बिजली जाने पर डेटा मिटेगा",
          "text_en": "Clears when power is off",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 117,
          "y": 198,
          "text_hi": "क्षमता: 4 GB – 16 GB",
          "text_en": "Size: 4 GB – 16 GB",
          "fill": "#0F172A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 232,
          "y": 26,
          "width": 195,
          "height": 215,
          "rx": 12,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 329,
          "y": 54,
          "text_hi": "ROM (स्थायी नियम)",
          "text_en": "ROM (Built-in Rules)",
          "fill": "#1E3A8A",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "line",
          "x1": 250,
          "y1": 88,
          "x2": 409,
          "y2": 88,
          "stroke": "#60A5FA",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 329,
          "y": 112,
          "text_hi": "स्थायी (Non-Volatile)",
          "text_en": "Permanent (Non-Volatile)",
          "fill": "#1D4ED8",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 329,
          "y": 154,
          "text_hi": "कंप्यूटर बूट (शुरू) करता है",
          "text_en": "Stores startup BIOS code",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 329,
          "y": 198,
          "text_hi": "केवल पढ़ने योग्य (Read Only)",
          "text_en": "Read-Only Memory",
          "fill": "#0F172A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 444,
          "y": 26,
          "width": 195,
          "height": 215,
          "rx": 12,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "label",
          "x": 541,
          "y": 54,
          "text_hi": "Hard Disk / SSD (अलमारी)",
          "text_en": "Hard Disk / SSD (Almirah)",
          "fill": "#065F46",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "line",
          "x1": 462,
          "y1": 88,
          "x2": 621,
          "y2": 88,
          "stroke": "#34D399",
          "strokeWidth": 1.5
        },
        {
          "kind": "label",
          "x": 541,
          "y": 112,
          "text_hi": "स्थायी स्टोरेज",
          "text_en": "Permanent Storage",
          "fill": "#047857",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 541,
          "y": 154,
          "text_hi": "फाइल, फोटो व ऐप सहेजता है",
          "text_en": "Saves files, photos & apps",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 541,
          "y": 198,
          "text_hi": "क्षमता: 256 GB – 2 TB",
          "text_en": "Size: 256 GB – 2 TB",
          "fill": "#0F172A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### प्राथमिक (Primary) बनाम द्वितीयक (Secondary) मेमोरी\n- **RAM (Random Access Memory):** प्राथमिक व **अस्थायी (Volatile)** मेमोरी। जब आप MS Word खोलकर टाइप करते हैं, तो वह पहले RAM में रहता है। यदि बिना Save किए बिजली चली जाए (और UPS न हो), तो RAM का डेटा उड़ जाता है!\n- **ROM (Read Only Memory):** प्राथमिक व **स्थायी (Non-Volatile)** मेमोरी। इसमें कंप्यूटर को चालू करने (Booting) के निर्देश कंपनी द्वारा पहले से डाले जाते हैं।\n- **Secondary Storage (Hard Disk / SSD / Pen Drive):** बड़ी और स्थायी मेमोरी। आजकल **SSD (Solid State Drive)** पुरानी Hard Disk की तुलना में कंप्यूटर को 5 गुना तेज़ चालू करती है।",
    "concept_md_en": "### Primary vs Secondary Memory\n- **RAM (Random Access Memory):** Primary & **Volatile (temporary)** memory. Whatever you currently type in MS Word lives in RAM first. If electricity cuts off without saving (and without a UPS), unsaved data in RAM disappears!\n- **ROM (Read Only Memory):** Primary & **Non-Volatile (permanent)** memory. Holds built-in **Booting** instructions stored by the manufacturer.\n- **Secondary Storage (Hard Disk / SSD / Pen Drive):** Large permanent storage. Modern **SSDs (Solid State Drives)** boot computers up to 5× faster than older mechanical Hard Disks.",
    "exam_tip_hi": "अंग्रेज़ी का शब्द **Volatile (अस्थायी)** बार-बार बोर्ड परीक्षा में आता है! याद रखें: **RAM = Volatile** (बिजली गई तो डेटा गया), जबकि **ROM और Hard Disk = Non-Volatile** (बिजली जाने पर भी डेटा पक्का सुरक्षित)!",
    "exam_tip_en": "The word **Volatile** appears frequently in ICT exams! Lock it in: **RAM = Volatile** (loses data without power), while **ROM & Hard Disk = Non-Volatile** (keeps data safe without power)!",
    "glossary_terms": [
      {
        "term_hi": "वोलाटाइल मेमोरी (Volatile Memory)",
        "term_en": "Volatile Memory",
        "pronunciation_hi": "वोलाटाइल मेमोरी",
        "definition_hi": "ऐसी मेमोरी (जैसे RAM) जिसका सारा डेटा बिजली बंद होते ही स्वतः मिट जाता है।",
        "definition_en": "Memory (like RAM) that loses all stored data the moment electrical power is switched off."
      },
      {
        "term_hi": "बूटिंग (Booting)",
        "term_en": "Booting",
        "pronunciation_hi": "बूटिंग",
        "definition_hi": "पावर बटन दबाने के बाद ऑपरेटिंग सिस्टम (Windows) के लोड होकर डेस्कटॉप दिखने की प्रक्रिया।",
        "definition_en": "The startup process of loading the Operating System (Windows) after pressing the power button."
      }
    ],
    "quick_check": {
      "q_hi": "यदि टाइप करते समय अचानक स्कूल की बिजली चली गई और आपने फाइल Save नहीं की थी, तो डेटा किस मेमोरी से मिट गया?",
      "q_en": "If power suddenly goes out while typing an unsaved file, which memory lost your unsaved work?",
      "answer_hi": "**RAM** से, क्योंकि Save करने से पहले चालू काम अस्थायी RAM में रहता है।",
      "answer_en": "From **RAM**, because active unsaved work stays in temporary volatile RAM until saved to disk."
    }
  },
  {
    "id": "ict1-sec-4-units-shutdown",
    "order": 4,
    "heading_hi": "4. डेटा की इकाइयाँ (Bit से TB) और कंप्यूटर सुरक्षित चालू/बंद करना",
    "heading_en": "4. Data Size Units (Bit to TB) & Safe Computer Start / Shut Down",
    "analogy_hi": "जैसे बिहार की मंडी में अनाज **ग्राम → किलोग्राम → क्विंटल → टन** में तौला जाता है, वैसे ही कंप्यूटर में फाइलें **Bit → Byte → KB → MB → GB → TB** में नापी जाती हैं! आपने मोबाइल में \"1.5 GB रोज़ डेटा\" सुना होगा — 1 GB का मतलब लगभग **1024 MB** होता है! और कंप्यूटर बंद करना बिल्कुल मोटरसाइकिल बंद करने जैसा है — पहले सही बटन (**Start → Shut Down**) से बंद करें, कभी सीधे दीवार का स्विच न खींचें!",
    "analogy_en": "Just as grain in Bihar markets is weighed in **Gram → Kilogram → Quintal → Tonne**, computer files are measured in **Bit → Byte → KB → MB → GB → TB**! You know \"1.5 GB daily mobile data\" — 1 GB equals **1024 MB**! And turning off a PC is like stopping a bike — always use **Start → Shut Down**, never yank the wall switch directly!",
    "visual_diagram": {
      "type": "FORMULA_CARD",
      "title_hi": "कंप्यूटर मेमोरी माप की सुनहरी सीढ़ी (Bit से TB तक)",
      "title_en": "Golden Ladder of Computer Memory Units (Bit to TB)",
      "formulas": [
        {
          "latex": "1\\text{ Bit} = 0\\text{ or }1,\\quad 1\\text{ Nibble} = 4\\text{ Bits}",
          "meaning_hi": "बिट सबसे छोटी इकाई है (बाइनरी 0 या 1)",
          "meaning_en": "Bit is the smallest unit (binary digit 0 or 1)",
          "unit": "Bit",
          "example_hi": "बिजली का स्विच OFF (0) या ON (1)",
          "example_en": "Like a light switch: OFF (0) or ON (1)"
        },
        {
          "latex": "1\\text{ Byte} = 8\\text{ Bits}",
          "meaning_hi": "1 बाइट में एक अक्षर (जैसे A या 5) सहेजा जाता है",
          "meaning_en": "1 Byte stores roughly 1 typed character (like A or 5)",
          "unit": "Byte",
          "example_hi": "शब्द \"BIHAR\" = 5 Bytes",
          "example_en": "Word \"BIHAR\" = 5 Bytes"
        },
        {
          "latex": "1\\text{ KB} = 1024\\text{ Bytes},\\quad 1\\text{ MB} = 1024\\text{ KB}",
          "meaning_hi": "किलोबाइट (KB) और मेगाबाइट (MB)",
          "meaning_en": "Kilobyte (KB) and Megabyte (MB)",
          "unit": "KB / MB",
          "example_hi": "1 आवेदन पत्र ~ 20 KB · 1 मोबाइल फोटो ~ 2 MB",
          "example_en": "1 Word letter ~ 20 KB · 1 phone photo ~ 2 MB"
        },
        {
          "latex": "1\\text{ GB} = 1024\\text{ MB},\\quad 1\\text{ TB} = 1024\\text{ GB}",
          "meaning_hi": "गीगाबाइट (GB) और टेराबाइट (TB)",
          "meaning_en": "Gigabyte (GB) and Terabyte (TB)",
          "unit": "GB / TB",
          "example_hi": "1 पेन ड्राइव = 32 GB · 1 लैपटॉप हार्ड डिस्क = 1 TB",
          "example_en": "1 Pen Drive = 32 GB · 1 Laptop Hard Disk = 1 TB"
        }
      ]
    },
    "concept_md_hi": "### ICT लैब में कंप्यूटर चालू और बंद करने का सही नियम (4 चरण)\n- **कंप्यूटर चालू (Power On) करना:**\n  1. मुख्य बिजली स्विच और **UPS (Uninterruptible Power Supply)** ऑन करें।\n  2. **CPU Cabinet** का पावर बटन एक बार दबाएँ (मॉनिटर की लाइट भी जाँचें)।\n  3. डेस्कटॉप स्क्रीन खुलने तक 15–30 सेकंड धैर्य से प्रतीक्षा करें।\n- **कंप्यूटर सुरक्षित बंद (Shut Down) करना:**\n  1. पहले अपनी खुली फाइलें **Save (`Ctrl + S`)** करके बंद करें।\n  2. नीचे बाईं ओर **Start** बटन → **Power** → **Shut Down** पर क्लिक करें।\n  3. स्क्रीन पूरी तरह काली होने और CPU की लाइट बुझने के बाद ही UPS व मुख्य स्विच बंद करें!",
    "concept_md_en": "### Safe Start & Shut Down Rules in the School ICT Lab\n- **Turning ON Safely:**\n  1. Switch on the main wall socket and the **UPS (Uninterruptible Power Supply)**.\n  2. Press the power button on the **CPU Cabinet** once (check the monitor power light).\n  3. Wait calmly for 15–30 seconds while Windows boots to the Desktop.\n- **Shutting DOWN Safely:**\n  1. Save (`Ctrl + S`) and close all open files first.\n  2. Click **Start** (bottom-left) → **Power** → **Shut Down**.\n  3. Wait until the screen goes completely black and CPU lights turn off before switching off the UPS!",
    "exam_tip_hi": "याद रखें: स्कूल लैब में **UPS** का काम अचानक बिजली कटने पर कंप्यूटर को **10–15 मिनट का बैटरी बैकअप** देना है, ताकि आप अपनी फाइल सेव कर सुरक्षित Shut Down कर सकें!",
    "exam_tip_en": "Remember: In a school ICT Lab, a **UPS** provides **10–15 minutes of emergency battery backup** during sudden power cuts so you can save your file and shut down safely!",
    "glossary_terms": [
      {
        "term_hi": "बाइनरी अंक / बिट (Bit)",
        "term_en": "Binary Digit (Bit)",
        "pronunciation_hi": "बाइनरी डिजिट (बिट)",
        "definition_hi": "कंप्यूटर केवल दो अंक समझता है — 0 और 1। इसी सबसे छोटी इकाई को Bit (Binary Digit) कहते हैं।",
        "definition_en": "Computers only understand 0 and 1; each single 0 or 1 is called a Bit (Binary Digit)."
      },
      {
        "term_hi": "UPS (यूपीएस)",
        "term_en": "UPS (Uninterruptible Power Supply)",
        "pronunciation_hi": "यू-पी-एस",
        "definition_hi": "बैटरी वाला उपकरण जो बिजली जाने पर कंप्यूटर को तुरंत बंद होने से बचाता है।",
        "definition_en": "Battery backup box that keeps a desktop computer running briefly during a power outage."
      }
    ],
    "quick_check": {
      "q_hi": "1 Kilobyte (KB) में कितने Bytes होते हैं — 1000 या 1024?",
      "q_en": "How many Bytes make 1 Kilobyte (KB) — 1000 or 1024?",
      "answer_hi": "**1024 Bytes** (क्योंकि कंप्यूटर बाइनरी घात $2^{10} = 1024$ पर काम करता है)।",
      "answer_en": "**1024 Bytes** (because computers use powers of 2, and $2^{10} = 1024$)."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{Input} \\rightarrow \\text{Process (CPU)} \\rightarrow \\text{Output}",
      "label_hi": "कंप्यूटर का मूल IPO कार्य चक्र",
      "label_en": "Core IPO Working Cycle of a Computer",
      "when_to_use_hi": "कंप्यूटर की कार्यप्रणाली के 5-अंक प्रश्न में ब्लॉक आरेख के साथ लिखें।",
      "when_to_use_en": "Draw with the block diagram in 5-mark working-of-computer questions."
    },
    {
      "latex": "1\\text{ Byte} = 8\\text{ Bits},\\quad 1\\text{ Nibble} = 4\\text{ Bits}",
      "label_hi": "बिट, निबल और बाइट का संबंध",
      "label_en": "Bit, Nibble and Byte Relation"
    },
    {
      "latex": "1\\text{ KB} = 1024\\text{ B},\\quad 1\\text{ MB} = 1024\\text{ KB},\\quad 1\\text{ GB} = 1024\\text{ MB}",
      "label_hi": "मेमोरी इकाइयों की मानक सीढ़ी",
      "label_en": "Standard Memory Size Ladder"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "Father",
      "fact_hi": "चार्ल्स बैबेज (Charles Babbage) को \"कंप्यूटर का जनक\" कहा जाता है।",
      "fact_en": "Charles Babbage is known as the \"Father of the Computer\"."
    },
    {
      "tag": "CPU",
      "fact_hi": "CPU = ALU (गणना व तर्क) + CU (नियंत्रण) + Registers।",
      "fact_en": "CPU = ALU (Arithmetic & Logic) + CU (Control Unit) + Registers."
    },
    {
      "tag": "Memory",
      "fact_hi": "RAM अस्थायी (Volatile) है; ROM और Hard Disk/SSD स्थायी (Non-Volatile) हैं।",
      "fact_en": "RAM is Volatile (temporary); ROM and Hard Disk/SSD are Non-Volatile (permanent)."
    },
    {
      "tag": "Viva Tip",
      "fact_hi": "मॉनिटर पर दिखना = Soft Copy; प्रिंटर से कागज़ पर छपना = Hard Copy।",
      "fact_en": "On Monitor = Soft Copy; Printed on Paper = Hard Copy."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "छात्र मॉनिटर (स्क्रीन) को ही पूरा कंप्यूटर या CPU मान लेते हैं।",
      "mistake_en": "Beginners confuse the Monitor screen with the CPU or entire computer.",
      "fix_hi": "मॉनिटर सिर्फ एक आउटपुट टीवी स्क्रीन है; असली प्रोसेसिंग और स्टोरेज CPU कैबिनेट के अंदर होता है।",
      "fix_en": "The monitor is only an output display; actual processing and storage sit inside the CPU cabinet."
    },
    {
      "mistake_hi": "स्कैनर को आउटपुट उपकरण और स्पीकर को इनपुट उपकरण लिख देना।",
      "mistake_en": "Calling a Scanner an output device or a Speaker an input device.",
      "fix_hi": "दिशा देखें: स्कैनर कागज़ अंदर भेजता है (Input); स्पीकर आवाज़ बाहर निकालता है (Output)।",
      "fix_en": "Check data direction: Scanner sends paper IN (Input); Speaker sends sound OUT (Output)."
    },
    {
      "mistake_hi": "सीधे दीवार का पावर स्विच बंद करके कंप्यूटर बंद करना।",
      "mistake_en": "Switching off the computer directly from the main wall plug.",
      "fix_hi": "हमेशा Start → Power → Shut Down का उपयोग करें, वरना Windows फाइलें खराब हो सकती हैं।",
      "fix_en": "Always use Start → Power → Shut Down so Windows files and storage are never corrupted."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "कंप्यूटर का ब्लॉक आरेख व IPO चक्र (Input, ALU, CU, Output)",
      "topic_en": "Block Diagram of Computer & IPO Cycle (Input, ALU, CU, Output)",
      "years": [
        "BSEB ICT Lab",
        "Model Paper"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "इनपुट बनाम आउटपुट उपकरण तथा RAM बनाम ROM में अंतर",
      "topic_en": "Input vs Output Devices and RAM vs ROM Differences",
      "years": [
        "BSEB ICT Lab",
        "Practical Viva"
      ],
      "expected_marks": 4
    },
    {
      "topic_hi": "मेमोरी इकाइयाँ (Bit, Byte, KB, MB, GB, TB)",
      "topic_en": "Memory Units Ladder (Bit, Byte, KB, MB, GB, TB)",
      "years": [
        "BSEB ICT Lab",
        "Objective"
      ],
      "expected_marks": 3
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 4,
  "analogy_count": 4,
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
  'skill-ict-ch1',
  3,
  'पहली बार कंप्यूटर लैब में आने वाले छात्र बिना किसी डर के कंप्यूटर के मुख्य भागों (मॉनिटर, CPU, कीबोर्ड, माउस, UPS) की पहचान कर सकेंगे, इनपुट-प्रोसेस-आउटपुट (IPO) चक्र समझा सकेंगे, RAM व Hard Disk का अंतर बता सकेंगे और कंप्यूटर को सुरक्षित चालू व बंद (Shut Down) कर सकेंगे।',
  'First-time learners will enter the ICT Lab without fear, identify core parts (Monitor, CPU, Keyboard, Mouse, UPS), explain the IPO cycle, distinguish RAM vs Hard Disk and Hardware vs Software, and safely Power On and Shut Down a desktop PC.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "भय-मुक्त लैब परिचय, मानव शरीर = कंप्यूटर व सुरक्षित बूट/शटडाउन",
    "phase_en": "Fear-Free Lab Welcome, Human Body = Computer & Safe Boot/Shut Down",
    "teacher_action_hi": "पहले 5 मिनट छात्रों का डर निकालें: बोलें \"गलत बटन दबाने से कंप्यूटर नहीं फटता!\" मानव शरीर और गाँव की आटा-चक्की से IPO चक्र समझाएँ। 1 कंप्यूटर पर 2 छात्रों की जोड़ी (मज़बूत + शुरुआती छात्र) बनाएँ और 1 बार UPS → CPU चालू करना और Start → Shut Down करना लाइव करवाएँ।",
    "teacher_action_en": "Spend 5 minutes removing fear: assure students \"pressing a wrong key never breaks a computer!\" Explain IPO via Human Body & Atta Chakki. Pair 1 confident + 1 shy student per PC and guide everyone through 1 safe UPS → CPU boot and Start → Shut Down.",
    "student_check_hi": "कमज़ोर छात्र से पूछें: \"कंप्यूटर बंद करने के लिए क्या सीधे बोर्ड का स्विच गिराना चाहिए या Start → Shut Down दबाना चाहिए?\"",
    "student_check_en": "Ask a shy student: \"To turn off a computer, should we pull the wall switch or click Start → Shut Down?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "हार्डवेयर-सॉफ्टवेयर पहचान और इनपुट-आउटपुट रैपिड फायर",
    "phase_en": "Hardware-Software Identification & Input–Output Rapid Fire",
    "teacher_action_hi": "लैब में हर भाग को छूकर नाम बुलवाएँ (Monitor, CPU Cabinet, Keyboard, Mouse, UPS)। मोबाइल फोन हाथ में दिखाकर हार्डवेयर (बॉडी) बनाम सॉफ्टवेयर (ऐप) का अंतर स्पष्ट करें। फिर 10 वस्तुओं (स्कैनर, प्रिंटर, माइक, स्पीकर, प्रोजेक्टर, कीबोर्ड) पर \"इनपुट या आउटपुट\" हाथ उठाने का खेल खिलाएँ।",
    "teacher_action_en": "Have pairs physically point to and name Monitor, CPU Cabinet, Keyboard, Mouse, and UPS. Hold up a phone to contrast Hardware (body) vs Software (apps). Run a joyful hands-up Rapid Fire on 10 devices (Scanner, Printer, Mic, Speaker, Projector).",
    "student_check_hi": "पूरी कक्षा से पूछें: \"स्कैनर और प्रिंटर में से कौन-सा इनपुट है और क्यों?\"",
    "student_check_en": "Ask the class: \"Between a Scanner and a Printer, which one is Input and why?\""
  },
  {
    "period_no": 3,
    "duration_mins": 40,
    "phase_hi": "RAM बनाम अलमारी (Hard Disk), KB–TB सीढ़ी व 10-मिनट वाइवा",
    "phase_en": "RAM vs Almirah (Hard Disk), KB–TB Ladder & 10-Min Oral Viva",
    "teacher_action_hi": "कक्षा की मेज़ पर 2 किताबें रखकर RAM (सीमित/अस्थायी) और बस्ते/अलमारी में सारी किताबें दिखाकर Hard Disk (स्थायी) का लाइव नाटक करें। मोबाइल डेटा (1.5 GB) से Bit → Byte → KB → MB → GB → TB जोड़कर पढ़ाएँ। अंत में 5 प्रश्नों का लाइव क्विज़ लें।",
    "teacher_action_en": "Demonstrate RAM by placing 2 open books on a desk vs Hard Disk as the school almirah/bag. Connect Bit → Byte → KB → MB → GB → TB to daily 1.5 GB mobile data packs. End with a 5-question oral viva.",
    "student_check_hi": "छात्रों से क्रम में बुलवाएँ: \"सबसे छोटा Bit, फिर Byte, फिर KB, MB, GB और सबसे बड़ा...?\"",
    "student_check_en": "Chant in chorus: \"Smallest is Bit, then Byte, then KB, MB, GB, and biggest is...?\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड मुख्य आरेख (IPO + मेमोरी सीढ़ी)",
    "heading_en": "Blackboard Core Diagram (IPO + Memory Ladder)",
    "points_hi": [
      "[INPUT: कीबोर्ड, माउस] ---> [CPU: ALU (गणना) + CU (नियंत्रण)] ---> [OUTPUT: मॉनिटर, प्रिंटर]",
      "RAM = पढ़ाई की मेज़ (तेज़, अस्थायी / Volatile)  |  Hard Disk / SSD = अलमारी (स्थायी / Non-Volatile)",
      "हार्डवेयर = छू सकते हैं (मॉनिटर, माउस)  |  सॉफ्टवेयर = प्रोग्राम (Windows, MS Word, Excel)",
      "1 Byte = 8 Bits | 1 KB = 1024 B | 1 MB = 1024 KB | 1 GB = 1024 MB | 1 TB = 1024 GB"
    ],
    "points_en": [
      "[INPUT: Keyboard, Mouse] ---> [CPU: ALU (Math) + CU (Control)] ---> [OUTPUT: Monitor, Printer]",
      "RAM = Study Desk (Fast, Volatile)  |  Hard Disk / SSD = Almirah (Permanent, Non-Volatile)",
      "Hardware = Touchable (Monitor, Mouse)  |  Software = Programs (Windows, MS Word, Excel)",
      "1 Byte = 8 Bits | 1 KB = 1024 B | 1 MB = 1024 KB | 1 GB = 1024 MB | 1 TB = 1024 GB"
    ]
  },
  {
    "heading_hi": "बिजली कटने पर ऑफलाइन बैकअप (Power-Cut Blackboard Backup)",
    "heading_en": "Offline / Power-Cut Blackboard Backup Activity",
    "points_hi": [
      "यदि लैब में बिजली चली जाए, तो 4 छात्रों को आगे बुलाकर \"मानव कंप्यूटर (Human Computer)\" खेल कराएँ:",
      "छात्र 1 (Keyboard): कागज़ पर \"12 + 8\" लिखकर छात्र 2 को दे। छात्र 2 (CU) उसे छात्र 3 (ALU) को दे।",
      "छात्र 3 (ALU) उत्तर \"20\" निकालकर छात्र 4 (Monitor) को दे, जो ब्लैकबोर्ड पर बड़ा \"20\" लिखे!",
      "इससे बिना बिजली के भी पूरी कक्षा IPO चक्र और ALU/CU का अंतर जीवन भर के लिए समझ जाएगी।"
    ],
    "points_en": [
      "If school power cuts off, call 4 students forward for the \"Human Computer\" roleplay:",
      "Student 1 (Keyboard) writes \"12 + 8\" on a slip and hands it to Student 2 (CU), who routes it to Student 3 (ALU).",
      "Student 3 (ALU) computes \"20\" and sends it via CU to Student 4 (Monitor), who writes \"20\" boldly on the blackboard!",
      "Zero electricity needed — and even the shyest learner remembers ALU, CU, Input, and Output forever."
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "लैब जोड़ी गतिविधि: सुरक्षित बूट और पार्ट्स टैगिंग (1 PC = 2 छात्र)",
    "title_en": "ICT Lab Pair Activity: Safe Boot & Parts Tagging (1 PC = 2 Students)",
    "materials_hi": "लैब डेस्कटॉप PC (UPS सहित), 5 कागज़ की पर्चियाँ (Monitor, CPU, Keyboard, Mouse, UPS)",
    "materials_en": "Lab Desktop PC with UPS, 5 small paper slips (Monitor, CPU, Keyboard, Mouse, UPS)",
    "steps_hi": "जोड़ी में छात्र A पहले पर्चियों को सही भागों के पास रखे और छात्र B जाँच करे। फिर छात्र A सुरक्षित Start → Shut Down करे और अगली बारी में भूमिका बदल लें ताकि कमज़ोर छात्र भी माउस पकड़कर खुद शटडाउन करे।",
    "steps_en": "In each pair, Student A places all 5 paper labels next to the right hardware parts while Student B verifies. Then Student A performs a safe Start → Shut Down, and partners swap roles so the beginner operates the mouse hands-on."
  },
  {
    "title_hi": "ऑफलाइन गतिविधि (बिना बिजली): \"इनपुट दाएँ — आउटपुट बाएँ\" कक्षा खेल",
    "title_en": "No-Power Classroom Game: \"Input Right — Output Left\"",
    "materials_hi": "केवल ब्लैकबोर्ड और चाक",
    "materials_en": "Blackboard and chalk only",
    "steps_hi": "शिक्षक एक उपकरण का नाम बोलें (जैसे माइक, प्रिंटर, स्कैनर, स्पीकर, वेबकैम, प्रोजेक्टर)। इनपुट होने पर छात्र दायाँ हाथ उठाएँ और आउटपुट होने पर बायाँ हाथ। टचस्क्रीन बोलने पर दोनों हाथ उठाएँ!",
    "steps_en": "Teacher calls out a device name (Mic, Printer, Scanner, Speaker, Webcam, Projector). Students raise their Right hand for Input, Left hand for Output, and BOTH hands when \"Touchscreen\" is called!"
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "(बिना कंप्यूटर गृहकार्य) अपनी कॉपी में कंप्यूटर का सुंदर चित्र बनाएँ और Monitor, CPU, Keyboard, Mouse तथा UPS को हिंदी व अंग्रेज़ी दोनों में नामांकित करें।",
    "task_en": "(Zero-Computer Homework) Draw a neat desktop computer in your notebook and label Monitor, CPU, Keyboard, Mouse, and UPS in both Hindi and English."
  },
  {
    "level": "BOARD",
    "task_hi": "इनपुट व आउटपुट उपकरणों में 3 अंतर लिखें तथा RAM और ROM के बीच 3 मुख्य अंतर तालिका बनाकर लिखें।",
    "task_en": "Write 3 differences between Input and Output devices, and make a 3-point comparison table between RAM and ROM."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "परिवार के किसी मोबाइल फोन की Settings → Storage में देखकर पता लगाएँ कि उसमें कुल कितने GB स्टोरेज है और 1 फोटो लगभग कितने MB की होती है।",
    "task_en": "Check Settings → Storage on any family smartphone and note its total GB capacity and the approximate MB size of one camera photo."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "मॉनिटर की स्क्रीन बंद कर देने से पूरा कंप्यूटर बंद हो जाता है।",
    "misconception_en": "Pressing the monitor power button turns off the whole computer.",
    "correction_hi": "समझाएँ कि मॉनिटर बंद करना सिर्फ टीवी की स्क्रीन बुझाने जैसा है; CPU अंदर चलता रहता है। हमेशा Start → Shut Down से बंद करें।",
    "correction_en": "Clarify that turning off the monitor only darkens the display while the CPU keeps running. Always shut down via Start → Shut Down."
  },
  {
    "misconception_hi": "अधिक RAM का मतलब अधिक फोटो और वीडियो स्थायी रूप से सहेजने की जगह है।",
    "misconception_en": "Higher RAM means more permanent space to save photos and videos.",
    "correction_hi": "मेज़ बनाम अलमारी उदाहरण दोहराएँ: RAM काम करने की रफ़्तार (खुले ऐप्स) बढ़ाती है, जबकि फोटो-वीडियो Hard Disk / SSD स्टोरेज में सेव होते हैं।",
    "correction_en": "Repeat Desk vs Almirah: RAM speeds up active open apps, while photos and videos live permanently on Hard Disk / SSD storage."
  },
  {
    "misconception_hi": "1 KB में 1000 Bytes और 1 MB में 1000 KB होते हैं।",
    "misconception_en": "1 KB equals 1000 Bytes and 1 MB equals 1000 KB.",
    "correction_hi": "बाइनरी प्रणाली के कारण कंप्यूटर में मानक मान 1024 (2 की घात 10) होता है — 1 KB = 1024 Bytes, 1 MB = 1024 KB।",
    "correction_en": "Because computers work in binary ($2^{10}$), the standard exam value is 1024: 1 KB = 1024 Bytes, 1 MB = 1024 KB."
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

-- Questions for skill-ict-ch1 (20 multi-mode items)
INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- #1: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000001', 'skill-ict-lab', 'skill-ict-ch1', 'CPU & IPO Cycle', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'ICT Lab Core',
    'CPU का पूरा नाम क्या है और इसके दो मुख्य भाग कौन-से हैं?',
    'What is the full form of CPU and its two core parts?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "CPU का पूरा नाम और इसके 2 मुख्य भाग (ALU व CU) क्या काम करते हैं?",
  "front_en": "Full form of CPU and what do its 2 core units (ALU & CU) do?",
  "back_hi": "CPU = Central Processing Unit (कंप्यूटर का दिमाग)। ALU (Arithmetic Logic Unit) सभी गणित व तुलना करता है; CU (Control Unit) सभी भागों को नियंत्रित करता है।",
  "back_en": "CPU = Central Processing Unit (Brain of the Computer). ALU does all math & logic comparisons; CU coordinates and controls every component.",
  "pronunciation_hi": "सी-पी-यू (सेंट्रल प्रोसेसिंग यूनिट)",
  "mnemonic_hi": "याद रखें: ALU = अंकगणित (गणना), CU = कंट्रोल (प्रिंसिपल की तरह नियंत्रण)।",
  "mnemonic_en": "Memory cue: ALU = Arithmetic/Math, CU = Control Unit (School Principal)."
}$json$::jsonb, true
  ),
  -- #2: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000002', 'skill-ict-lab', 'skill-ict-ch1', 'RAM vs ROM', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'ICT Lab Core',
    'RAM और ROM में सबसे बड़ा अंतर क्या है?',
    'What is the biggest difference between RAM and ROM?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "RAM और ROM में मुख्य अंतर क्या है?",
  "front_en": "What is the key difference between RAM and ROM?",
  "back_hi": "RAM (Random Access Memory) अस्थायी (Volatile) है — बिजली जाने पर मिट जाती है। ROM (Read Only Memory) स्थायी (Non-Volatile) है — इसमें बूटिंग निर्देश सुरक्षित रहते हैं।",
  "back_en": "RAM (Random Access Memory) is Volatile (temporary — clears on power off). ROM (Read Only Memory) is Non-Volatile (permanent — holds startup boot instructions).",
  "pronunciation_hi": "रैम (RAM) बनाम रोम (ROM)",
  "mnemonic_hi": "RAM = रफ कॉपी / मेज़ (मिट सकती है); ROM = पक्की छपी किताब (स्थायी)।",
  "mnemonic_en": "RAM = Study Desk (temporary); ROM = Permanent Printed Rulebook."
}$json$::jsonb, true
  ),
  -- #3: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000003', 'skill-ict-lab', 'skill-ict-ch1', 'Memory Units', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'कंप्यूटर मेमोरी की सबसे छोटी से सबसे बड़ी इकाइयों का क्रम क्या है?',
    'What is the order of computer memory units from smallest to largest?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "मेमोरी इकाइयों की सीढ़ी (Bit से TB) और मान क्या हैं?",
  "front_en": "State the memory units ladder from Bit to TB with values.",
  "back_hi": "Bit (0 या 1) → 4 Bits = 1 Nibble → 8 Bits = 1 Byte → 1024 Bytes = 1 KB → 1024 KB = 1 MB → 1024 MB = 1 GB → 1024 GB = 1 TB।",
  "back_en": "Bit (0 or 1) → 4 Bits = 1 Nibble → 8 Bits = 1 Byte → 1024 Bytes = 1 KB → 1024 KB = 1 MB → 1024 MB = 1 GB → 1024 GB = 1 TB.",
  "pronunciation_hi": "बिट, बाइट, किलोबाइट, मेगाबाइट, गीगाबाइट, टेराबाइट",
  "formula_latex": "1\\text{ Byte} = 8\\text{ Bits},\\quad 1\\text{ GB} = 1024\\text{ MB}",
  "mnemonic_hi": "ट्रिक: B-B-K-M-G-T (Bit, Byte, KB, MB, GB, TB — हर बड़ा कदम × 1024)।",
  "mnemonic_en": "Shortcut: B-B-K-M-G-T (Bit, Byte, KB, MB, GB, TB — each jump × 1024)."
}$json$::jsonb, true
  ),
  -- #4: MATCH_PAIRS (FOUNDATION, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000004', 'skill-ict-lab', 'skill-ict-ch1', 'Hardware Types', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'ICT Lab Core',
    'स्तंभ A के कंप्यूटर उपकरणों को स्तंभ B की सही श्रेणी से मिलाएँ:',
    'Match each computer device in Column A with its exact category in Column B:',
    NULL, NULL,
    'सोचें कि किससे डेटा कंप्यूटर के अंदर जाता है और किससे बाहर निकलता है!', 'Think about whether data goes INTO the computer or comes OUT to the user!',
    'कीबोर्ड व स्कैनर इनपुट हैं, प्रिंटर आउटपुट है, CPU प्रोसेसिंग करता है और पेन ड्राइव स्थायी स्टोरेज है।', 'Keyboard/Scanner are Input, Printer is Output, CPU does Processing, and Pen Drive is permanent Storage.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "प्रत्येक उपकरण को उसकी सही श्रेणी से मिलाएँ",
  "instruction_en": "Match each hardware device to its correct role",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "स्कैनर और कीबोर्ड (Scanner & Keyboard)",
      "left_en": "Scanner & Keyboard",
      "right_hi": "इनपुट उपकरण (Input Device)",
      "right_en": "Input Device"
    },
    {
      "id": "p2",
      "left_hi": "प्रिंटर और स्पीकर (Printer & Speaker)",
      "left_en": "Printer & Speaker",
      "right_hi": "आउटपुट उपकरण (Output Device)",
      "right_en": "Output Device"
    },
    {
      "id": "p3",
      "left_hi": "CPU (ALU + CU)",
      "left_en": "CPU (ALU + CU)",
      "right_hi": "प्रोसेसिंग इकाई (कंप्यूटर का दिमाग)",
      "right_en": "Processing Unit (Brain of Computer)"
    },
    {
      "id": "p4",
      "left_hi": "पेन ड्राइव व SSD (Pen Drive & SSD)",
      "left_en": "Pen Drive & SSD",
      "right_hi": "स्थायी स्टोरेज (Secondary Storage)",
      "right_en": "Permanent Secondary Storage"
    }
  ]
}$json$::jsonb, true
  ),
  -- #5: MATCH_PAIRS (BOARD, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000005', 'skill-ict-lab', 'skill-ict-ch1', 'Memory & Software', 'PRACTICE', 'MATCH_PAIRS', 'BOARD', NULL,
    'कंप्यूटर शब्दावली को उनके सटीक उदाहरण से मिलाएँ:',
    'Match each computer term with its exact real-world example:',
    NULL, NULL,
    'सिस्टम सॉफ्टवेयर कंप्यूटर चलाता है, जबकि एप्लिकेशन सॉफ्टवेयर खास काम करता है।', 'System software runs the PC, while Application software handles a specific task.',
    'Windows 11 सिस्टम सॉफ्टवेयर है, MS Excel एप्लिकेशन सॉफ्टवेयर, RAM अस्थायी मेमोरी, और 1 Byte = 8 Bits होता है।', 'Windows 11 is System Software, MS Excel is Application Software, RAM is volatile memory, and 1 Byte equals 8 Bits.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही उदाहरण से जोड़ा बनाएँ",
  "instruction_en": "Pair each term with its correct match",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "सिस्टम सॉफ्टवेयर (System Software)",
      "left_en": "System Software",
      "right_hi": "Windows 11 / Linux / Android",
      "right_en": "Windows 11 / Linux / Android"
    },
    {
      "id": "p2",
      "left_hi": "एप्लिकेशन सॉफ्टवेयर (Application Software)",
      "left_en": "Application Software",
      "right_hi": "MS Word / MS Excel / Paint",
      "right_en": "MS Word / MS Excel / Paint"
    },
    {
      "id": "p3",
      "left_hi": "अस्थायी मेमोरी (Volatile Memory)",
      "left_en": "Volatile Memory",
      "right_hi": "RAM (बिजली जाने पर मिटती है)",
      "right_en": "RAM (clears when power goes off)"
    },
    {
      "id": "p4",
      "left_hi": "1 बाइट (1 Byte)",
      "left_en": "1 Byte",
      "right_hi": "8 बिट्स (8 Bits)",
      "right_en": "8 Bits"
    }
  ]
}$json$::jsonb, true
  ),
  -- #6: DIAGRAM_LABEL (FOUNDATION, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000006', 'skill-ict-lab', 'skill-ict-ch1', 'Desktop Computer Parts', 'PRACTICE', 'DIAGRAM_LABEL', 'FOUNDATION', 'ICT Lab Practical',
    'स्कूल ICT लैब के डेस्कटॉप कंप्यूटर चित्र में (1), (2), (3) और (4) भागों को पहचानें:',
    'Identify labeled parts (1), (2), (3), and (4) on this school ICT Lab desktop setup:',
    NULL, NULL,
    'स्क्रीन मॉनिटर है, लंबा खड़ा बॉक्स CPU कैबिनेट है, बटनों वाला बोर्ड कीबोर्ड और दाईं ओर छोटा पॉइंटिंग उपकरण माउस है!', 'The screen is Monitor, the tall box is CPU Cabinet, the keys board is Keyboard, and the hand pointer is Mouse!',
    '(1) मॉनिटर (आउटपुट स्क्रीन), (2) CPU कैबिनेट (सिस्टम यूनिट), (3) कीबोर्ड (टाइपिंग इनपुट) और (4) माउस (पॉइंटिंग इनपुट) हैं।', '(1) Monitor (output display), (2) CPU Cabinet (system unit), (3) Keyboard (typing input), and (4) Mouse (pointing input).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "DIAGRAM_LABEL",
  "instruction_hi": "चित्र के चारों नंबरों पर टैप कर सही कंप्यूटर भाग चुनें",
  "instruction_en": "Tap each numbered pin on the desktop setup and choose the right part",
  "diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "डेस्कटॉप कंप्यूटर के मुख्य भाग पहचानें",
    "title_en": "Identify Core Parts of a Desktop Computer",
    "caption_hi": "बिंदु 1 से 4 पर टैप करके प्रत्येक हार्डवेयर भाग का सही नाम चुनें।",
    "caption_en": "Tap pins 1 to 4 to match each desktop hardware part.",
    "viewBox": "0 0 600 280",
    "elements": [
      {
        "kind": "line",
        "x1": 20,
        "y1": 252,
        "x2": 580,
        "y2": 252,
        "stroke": "#94A3B8",
        "strokeWidth": 3
      },
      {
        "kind": "rect",
        "x": 75,
        "y": 34,
        "width": 220,
        "height": 136,
        "rx": 10,
        "fill": "#EFF6FF",
        "stroke": "#1E3A8A",
        "strokeWidth": 3
      },
      {
        "kind": "rect",
        "x": 90,
        "y": 48,
        "width": 190,
        "height": 108,
        "rx": 4,
        "fill": "#DBEAFE",
        "stroke": "#3B82F6",
        "strokeWidth": 1.5
      },
      {
        "kind": "rect",
        "x": 168,
        "y": 170,
        "width": 34,
        "height": 22,
        "fill": "#64748B",
        "stroke": "#334155",
        "strokeWidth": 1.5
      },
      {
        "kind": "rect",
        "x": 135,
        "y": 190,
        "width": 100,
        "height": 10,
        "rx": 4,
        "fill": "#475569",
        "stroke": "#334155",
        "strokeWidth": 1.5
      },
      {
        "kind": "rect",
        "x": 350,
        "y": 30,
        "width": 110,
        "height": 190,
        "rx": 10,
        "fill": "#FEF3C7",
        "stroke": "#B45309",
        "strokeWidth": 3
      },
      {
        "kind": "rect",
        "x": 368,
        "y": 50,
        "width": 74,
        "height": 18,
        "rx": 3,
        "fill": "#FDE68A",
        "stroke": "#B45309",
        "strokeWidth": 1.5
      },
      {
        "kind": "circle",
        "cx": 405,
        "cy": 112,
        "r": 10,
        "fill": "#059669",
        "stroke": "#065F46",
        "strokeWidth": 1.5
      },
      {
        "kind": "line",
        "x1": 370,
        "y1": 155,
        "x2": 440,
        "y2": 155,
        "stroke": "#B45309",
        "strokeWidth": 2
      },
      {
        "kind": "line",
        "x1": 370,
        "y1": 170,
        "x2": 440,
        "y2": 170,
        "stroke": "#B45309",
        "strokeWidth": 2
      },
      {
        "kind": "rect",
        "x": 65,
        "y": 214,
        "width": 240,
        "height": 34,
        "rx": 6,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2.5
      },
      {
        "kind": "line",
        "x1": 80,
        "y1": 225,
        "x2": 290,
        "y2": 225,
        "stroke": "#10B981",
        "strokeWidth": 2,
        "dashed": true
      },
      {
        "kind": "line",
        "x1": 80,
        "y1": 236,
        "x2": 290,
        "y2": 236,
        "stroke": "#10B981",
        "strokeWidth": 2,
        "dashed": true
      },
      {
        "kind": "ellipse",
        "cx": 520,
        "cy": 224,
        "rx": 24,
        "ry": 22,
        "fill": "#F5F3FF",
        "stroke": "#7C3AED",
        "strokeWidth": 2.5
      }
    ]
  },
  "hotspots": [
    {
      "id": "h1",
      "x": 185,
      "y": 102,
      "label_code": "1",
      "answer_hi": "मॉनिटर (Monitor)",
      "answer_en": "Monitor",
      "options_hi": [
        "मॉनिटर (Monitor)",
        "CPU कैबिनेट (System Unit)",
        "कीबोर्ड (Keyboard)",
        "माउस (Mouse)"
      ],
      "options_en": [
        "Monitor",
        "CPU Cabinet (System Unit)",
        "Keyboard",
        "Mouse"
      ]
    },
    {
      "id": "h2",
      "x": 405,
      "y": 112,
      "label_code": "2",
      "answer_hi": "CPU कैबिनेट (System Unit)",
      "answer_en": "CPU Cabinet (System Unit)",
      "options_hi": [
        "मॉनिटर (Monitor)",
        "CPU कैबिनेट (System Unit)",
        "कीबोर्ड (Keyboard)",
        "माउस (Mouse)"
      ],
      "options_en": [
        "Monitor",
        "CPU Cabinet (System Unit)",
        "Keyboard",
        "Mouse"
      ]
    },
    {
      "id": "h3",
      "x": 185,
      "y": 231,
      "label_code": "3",
      "answer_hi": "कीबोर्ड (Keyboard)",
      "answer_en": "Keyboard",
      "options_hi": [
        "मॉनिटर (Monitor)",
        "CPU कैबिनेट (System Unit)",
        "कीबोर्ड (Keyboard)",
        "माउस (Mouse)"
      ],
      "options_en": [
        "Monitor",
        "CPU Cabinet (System Unit)",
        "Keyboard",
        "Mouse"
      ]
    },
    {
      "id": "h4",
      "x": 520,
      "y": 224,
      "label_code": "4",
      "answer_hi": "माउस (Mouse)",
      "answer_en": "Mouse",
      "options_hi": [
        "मॉनिटर (Monitor)",
        "CPU कैबिनेट (System Unit)",
        "कीबोर्ड (Keyboard)",
        "माउस (Mouse)"
      ],
      "options_en": [
        "Monitor",
        "CPU Cabinet (System Unit)",
        "Keyboard",
        "Mouse"
      ]
    }
  ]
}$json$::jsonb, true
  ),
  -- #7: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000007', 'skill-ict-lab', 'skill-ict-ch1', 'CPU Basics', 'PRACTICE', 'MCQ', 'FOUNDATION', 'ICT Lab Core',
    'निम्नलिखित में से किसे "कंप्यूटर का दिमाग (Brain of Computer)" कहा जाता है?',
    'Which of the following is called the "Brain of the Computer"?',
    $json$[{"key":"A","text_hi":"मॉनिटर (Monitor)","text_en":"Monitor"},{"key":"B","text_hi":"CPU (सेंट्रल प्रोसेसिंग यूनिट)","text_en":"CPU (Central Processing Unit)"},{"key":"C","text_hi":"माउस (Mouse)","text_en":"Mouse"},{"key":"D","text_hi":"प्रिंटर (Printer)","text_en":"Printer"}]$json$::jsonb, 'B',
    'सोचिए — मानव शरीर में सोचने और गणना करने का काम दिमाग करता है; कंप्यूटर में वही काम कौन करता है?', 'Think: which unit performs all thinking, calculations, and control inside the computer?',
    'CPU (Central Processing Unit) कंप्यूटर के सभी निर्देशों को समझता, गणना करता (ALU) और नियंत्रित करता (CU) है, इसलिए इसे कंप्यूटर का दिमाग कहते हैं।', 'CPU (Central Processing Unit) executes all instructions, calculations (ALU), and control tasks (CU), earning it the name "Brain of the Computer".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #8: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000008', 'skill-ict-lab', 'skill-ict-ch1', 'Input Devices', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'कंप्यूटर में अपना नाम टाइप करने के लिए किस इनपुट उपकरण का उपयोग किया जाता है?',
    'Which input device is used to type your name into a computer?',
    $json$[{"key":"A","text_hi":"कीबोर्ड (Keyboard)","text_en":"Keyboard"},{"key":"B","text_hi":"स्पीकर (Speaker)","text_en":"Speaker"},{"key":"C","text_hi":"प्रिंटर (Printer)","text_en":"Printer"},{"key":"D","text_hi":"प्रोजेक्टर (Projector)","text_en":"Projector"}]$json$::jsonb, 'A',
    'अक्षर (A–Z) और अंक (0–9) किस उपकरण पर बने होते हैं?', 'Which device has letter keys (A–Z) and number keys (0–9)?',
    'कीबोर्ड मुख्य इनपुट उपकरण है जिससे अक्षर, संख्याएँ और आदेश कंप्यूटर के अंदर भेजे जाते हैं। स्पीकर, प्रिंटर और प्रोजेक्टर आउटपुट उपकरण हैं।', 'A keyboard is the primary input device for typing letters, numbers, and commands. Speaker, printer, and projector are output devices.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #9: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000009', 'skill-ict-lab', 'skill-ict-ch1', 'Safe Shut Down', 'PRACTICE', 'MCQ', 'FOUNDATION', 'ICT Lab Safety',
    'स्कूल ICT लैब में काम पूरा होने के बाद कंप्यूटर बंद करने का सबसे सुरक्षित तरीका क्या है?',
    'What is the safest way to turn off a computer after finishing work in the ICT Lab?',
    $json$[{"key":"A","text_hi":"सीधे दीवार का बिजली स्विच बंद कर देना","text_en":"Switch off the main wall socket directly"},{"key":"B","text_hi":"कीबोर्ड का तार निकाल देना","text_en":"Unplug the keyboard cable"},{"key":"C","text_hi":"केवल मॉनिटर का बटन बंद कर देना","text_en":"Press only the monitor power button"},{"key":"D","text_hi":"फाइल Save करें → Start → Power → Shut Down पर क्लिक करें","text_en":"Save files → click Start → Power → Shut Down"}]$json$::jsonb, 'D',
    'सॉफ्टवेयर को सही तरीके से बंद होने का समय देना ज़रूरी है!', 'Windows needs to close all open programs cleanly before power is cut!',
    'हमेशा पहले अपनी फाइल सेव करें और फिर Start → Power → Shut Down चुनें। सीधे स्विच काटने से Windows व आपकी फाइलें खराब हो सकती हैं।', 'Always save your work first and choose Start → Power → Shut Down. Cutting main power directly can corrupt Windows and unsaved files.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #10: MCQ (BOARD, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000010', 'skill-ict-lab', 'skill-ict-ch1', 'CPU Units', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'CPU के अंदर सभी गणितीय जोड़-घटाव और तार्किक तुलनाएँ ($>, <, =$) कौन-सी इकाई करती है?',
    'Which unit inside the CPU performs all arithmetic calculations and logical comparisons ($>, <, =$)?',
    $json$[{"key":"A","text_hi":"CU (Control Unit)","text_en":"CU (Control Unit)"},{"key":"B","text_hi":"ROM (Read Only Memory)","text_en":"ROM (Read Only Memory)"},{"key":"C","text_hi":"ALU (Arithmetic Logic Unit)","text_en":"ALU (Arithmetic Logic Unit)"},{"key":"D","text_hi":"UPS (Power Backup)","text_en":"UPS (Power Backup)"}]$json$::jsonb, 'C',
    'नाम में ही "Arithmetic (अंकगणित)" और "Logic (तर्क)" छिपा है!', 'The name itself literally contains "Arithmetic" and "Logic"!',
    'ALU (Arithmetic Logic Unit) सभी गणितीय गणनाएँ ($+, -, \times, \div$) तथा तार्किक तुलनाएँ ($>, <, =$) करता है।', 'The ALU (Arithmetic Logic Unit) executes every arithmetic operation and logical comparison inside the CPU.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #11: MCQ (BOARD, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000011', 'skill-ict-lab', 'skill-ict-ch1', 'RAM vs ROM', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'इनमें से कौन-सी मेमोरी "अस्थायी (Volatile)" होती है, अर्थात् बिजली बंद होते ही इसका डेटा मिट जाता है?',
    'Which of the following is a "Volatile" (temporary) memory that loses data when power turns off?',
    $json$[{"key":"A","text_hi":"RAM (रैम)","text_en":"RAM"},{"key":"B","text_hi":"Hard Disk (हार्ड डिस्क)","text_en":"Hard Disk"},{"key":"C","text_hi":"ROM","text_en":"ROM"},{"key":"D","text_hi":"Pen Drive (पेन ड्राइव)","text_en":"Pen Drive"}]$json$::jsonb, 'A',
    '"पढ़ाई की मेज़" वाला उदाहरण याद करें — बिजली बंद होते ही कौन खाली हो जाती है?', 'Recall the "Study Desk" analogy — which memory clears as soon as power goes out?',
    'RAM (Random Access Memory) एक अस्थायी (Volatile) मेमोरी है। ROM, Hard Disk और Pen Drive स्थायी (Non-Volatile) हैं।', 'RAM (Random Access Memory) is volatile and loses its contents on power loss. ROM, Hard Disk, and Pen Drive are non-volatile.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #12: MCQ (BOARD, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000012', 'skill-ict-lab', 'skill-ict-ch1', 'Software Types', 'PRACTICE', 'MCQ', 'BOARD', NULL,
    'इनमें से कौन-सा एक "ऑपरेटिंग सिस्टम (System Software)" का उदाहरण है?',
    'Which of the following is an example of an Operating System (System Software)?',
    $json$[{"key":"A","text_hi":"MS Word","text_en":"MS Word"},{"key":"B","text_hi":"MS Paint","text_en":"MS Paint"},{"key":"C","text_hi":"कैलकुलेटर (Calculator)","text_en":"Calculator"},{"key":"D","text_hi":"Windows 11","text_en":"Windows 11"}]$json$::jsonb, 'D',
    'कौन-सा सॉफ्टवेयर पूरे कंप्यूटर को चालू करता है और बाकी सभी ऐप्स को चलाता है?', 'Which software boots the entire computer and manages all other apps?',
    'Windows 11 एक ऑपरेटिंग सिस्टम (System Software) है। MS Word, MS Paint और Calculator एप्लिकेशन सॉफ्टवेयर हैं।', 'Windows 11 is an Operating System (System Software), whereas MS Word, MS Paint, and Calculator are Application Software.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #13: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000013', 'skill-ict-lab', 'skill-ict-ch1', 'Memory Units Calculation', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB ICT Model',
    'यदि किसी छात्र के पास 2 GB की खाली पेन ड्राइव है, तो उसमें कुल कितने Megabytes (MB) स्थान उपलब्ध है?',
    'If a student has a blank 2 GB pen drive, how many Megabytes (MB) of space does it equal?',
    $json$[{"key":"A","text_hi":"1024 MB","text_en":"1024 MB"},{"key":"B","text_hi":"2048 MB","text_en":"2048 MB"},{"key":"C","text_hi":"2000 MB","text_en":"2000 MB"},{"key":"D","text_hi":"4096 MB","text_en":"4096 MB"}]$json$::jsonb, 'B',
    '1 GB = 1024 MB होता है — अब इसे 2 से गुणा करें!', '1 GB = 1024 MB — now multiply by 2!',
    'चूँकि $1\text{ GB} = 1024\text{ MB}$, इसलिए $2\text{ GB} = 2 \times 1024 = 2048\text{ MB}$।', 'Since $1\text{ GB} = 1024\text{ MB}$, $2\text{ GB} = 2 \times 1024 = 2048\text{ MB}$.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #14: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000014', 'skill-ict-lab', 'skill-ict-ch1', 'Input vs Output', 'PRACTICE', 'MCQ', 'TOPPER', NULL,
    'निम्नलिखित में से कौन-सा उपकरण इनपुट (Input) और आउटपुट (Output) दोनों की तरह काम करता है?',
    'Which device functions as BOTH an Input device and an Output device?',
    $json$[{"key":"A","text_hi":"स्कैनर (Scanner)","text_en":"Scanner"},{"key":"B","text_hi":"लेज़र प्रिंटर (Laser Printer)","text_en":"Laser Printer"},{"key":"C","text_hi":"टचस्क्रीन (Touchscreen)","text_en":"Touchscreen"},{"key":"D","text_hi":"माइक्रोफ़ोन (Microphone)","text_en":"Microphone"}]$json$::jsonb, 'C',
    'स्मार्टफोन या ATM की स्क्रीन पर हम उंगली से आदेश भी देते हैं और परिणाम भी उसी पर देखते हैं!', 'On a smartphone or ATM screen, you both tap commands in and see results out on the same surface!',
    'टचस्क्रीन (Touchscreen) स्पर्श के ज़रिए इनपुट लेती है और उसी डिस्प्ले पर आउटपुट भी दिखाती है।', 'A Touchscreen takes finger-touch commands as input while displaying visual results on the same screen as output.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #15: MCQ (FOUNDATION, EXAM_ONLY)
  (
    '10000005-0001-4000-8000-000000000015', 'skill-ict-lab', 'skill-ict-ch1', 'Hard Copy vs Soft Copy', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'ICT Live Exam',
    'प्रिंटर द्वारा कागज़ पर छापे गए उत्तर या मार्कशीट को क्या कहा जाता है?',
    'What is a marksheet or document printed on physical paper by a printer called?',
    $json$[{"key":"A","text_hi":"हार्ड कॉपी (Hard Copy)","text_en":"Hard Copy"},{"key":"B","text_hi":"सॉफ्ट कॉपी (Soft Copy)","text_en":"Soft Copy"},{"key":"C","text_hi":"फ्लैश कॉपी (Flash Copy)","text_en":"Flash Copy"},{"key":"D","text_hi":"वर्चुअल कॉपी (Virtual Copy)","text_en":"Virtual Copy"}]$json$::jsonb, 'A',
    'कागज़ को आप हाथ में पकड़कर छू सकते हैं — बिल्कुल हार्डवेयर की तरह!', 'Physical paper can be held in your hand — think "Hard"!',
    'प्रिंटर से कागज़ पर प्राप्त आउटपुट को हार्ड कॉपी (Hard Copy) और मॉनिटर पर दिखने वाले आउटपुट को सॉफ्ट कॉपी (Soft Copy) कहते हैं।', 'Paper printout from a printer is called Hard Copy, whereas display output on a monitor is called Soft Copy.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #16: MCQ (BOARD, EXAM_ONLY)
  (
    '10000005-0001-4000-8000-000000000016', 'skill-ict-lab', 'skill-ict-ch1', 'UPS Purpose', 'EXAM_ONLY', 'MCQ', 'BOARD', 'ICT Live Exam',
    'डेस्कटॉप कंप्यूटर के साथ UPS (Uninterruptible Power Supply) क्यों जोड़ा जाता है?',
    'Why is a UPS (Uninterruptible Power Supply) connected to a desktop computer?',
    $json$[{"key":"A","text_hi":"इंटरनेट की स्पीड बढ़ाने के लिए","text_en":"To increase internet speed"},{"key":"B","text_hi":"प्रिंटर से रंगीन प्रिंट निकालने के लिए","text_en":"To print colour pages"},{"key":"C","text_hi":"अचानक बिजली कटने पर बैटरी बैकअप देकर सुरक्षित शटडाउन कराने के लिए","text_en":"To provide temporary battery backup during power cuts for safe shut down"},{"key":"D","text_hi":"कंप्यूटर की आवाज़ तेज़ करने के लिए","text_en":"To boost speaker volume"}]$json$::jsonb, 'C',
    'नाम में "Uninterruptible Power" (बिना रुकावट बिजली) लिखा है!', 'Notice the phrase "Uninterruptible Power" right inside its full form!',
    'UPS बिजली जाने पर 10–15 मिनट का बैटरी बैकअप देता है जिससे छात्र अपनी फाइल Save कर सुरक्षित Shut Down कर सकें।', 'A UPS provides 10–15 minutes of emergency battery power during blackouts so users can save work and shut down cleanly.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #17: MCQ (TOPPER, EXAM_ONLY)
  (
    '10000005-0001-4000-8000-000000000017', 'skill-ict-lab', 'skill-ict-ch1', 'Binary & Units', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'ICT Live Exam',
    'मेमोरी इकाइयों को छोटे से बड़े के सही बढ़ते क्रम में चुनें:',
    'Select the correct ascending order of memory units from smallest to largest:',
    $json$[{"key":"A","text_hi":"Byte < Bit < KB < MB < GB","text_en":"Byte < Bit < KB < MB < GB"},{"key":"B","text_hi":"Bit < Byte < KB < MB < GB < TB","text_en":"Bit < Byte < KB < MB < GB < TB"},{"key":"C","text_hi":"Bit < KB < Byte < GB < MB < TB","text_en":"Bit < KB < Byte < GB < MB < TB"},{"key":"D","text_hi":"KB < Bit < Byte < MB < TB < GB","text_en":"KB < Bit < Byte < MB < TB < GB"}]$json$::jsonb, 'B',
    'सबसे छोटी इकाई 1 Bit (0 या 1) है और सबसे बड़ी इकाई TB (Terabyte) है!', 'The smallest unit is Bit (0 or 1) and the largest here is TB (Terabyte)!',
    'सही बढ़ता क्रम है: Bit (सबसे छोटा) < Byte (8 Bits) < KB < MB < GB < TB (सबसे बड़ा)।', 'The exact ascending order is: Bit < Byte (8 Bits) < KB < MB < GB < TB.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #18: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000018', 'skill-ict-lab', 'skill-ict-ch1', 'Hardware vs Software', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'हार्डवेयर और सॉफ्टवेयर में दो मुख्य अंतर उदाहरण सहित लिखें।',
    'Write two main differences between Hardware and Software with examples.',
    NULL, NULL,
    'छूने की क्षमता और दोनों के 2-2 उदाहरण लिखें।', 'Compare touchability and give 2 clear examples for each.',
    NULL, NULL,
    '1. **भौतिक रूप:** हार्डवेयर कंप्यूटर के वे भाग हैं जिन्हें हम देख और छू सकते हैं, जबकि सॉफ्टवेयर प्रोग्रामों का समूह है जिसे छू नहीं सकते।
2. **उदाहरण:** हार्डवेयर — मॉनिटर, कीबोर्ड, माउस, CPU। सॉफ्टवेयर — Windows, MS Word, MS Excel। दोनों एक-दूसरे के बिना अधूरे हैं।', '1. **Physical Nature:** Hardware consists of physical parts that we can see and touch, whereas Software is a set of digital instructions/programs that cannot be touched.
2. **Examples:** Hardware — Monitor, Keyboard, Mouse, CPU. Software — Windows, MS Word, MS Excel. Both need each other to work.',
    $json$[{"cue_hi":"हार्डवेयर = छू सकते हैं (मॉनिटर, माउस)","cue_en":"Hardware = Touchable (Monitor, Mouse)"},{"cue_hi":"सॉफ्टवेयर = प्रोग्राम (Windows, MS Word)","cue_en":"Software = Programs (Windows, MS Word)"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"भौतिक बनाम डिजिटल प्रोग्राम का स्पष्ट अंतर","criterion_en":"Clear contrast of physical vs digital programs"},{"step_no":2,"marks":1,"criterion_hi":"दोनों के कम से कम 2 सही उदाहरण","criterion_en":"At least 2 accurate examples for each"}]$json$::jsonb,
    NULL, true
  ),
  -- #19: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000019', 'skill-ict-lab', 'skill-ict-ch1', 'RAM vs ROM', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'RAM और ROM का पूरा नाम तथा इनके बीच दो अंतर लिखें।',
    'Write the full forms of RAM and ROM along with two key differences.',
    NULL, NULL,
    'Full Form + Volatile बनाम Non-Volatile अंतर लिखें।', 'State full forms plus Volatile vs Non-Volatile nature.',
    NULL, NULL,
    '- **पूरा नाम:** RAM = Random Access Memory; ROM = Read Only Memory।
1. **प्रकृति:** RAM अस्थायी (Volatile) होती है — बिजली जाने पर इसका डेटा मिट जाता है। ROM स्थायी (Non-Volatile) होती है — बिजली जाने पर भी डेटा सुरक्षित रहता है।
2. **उपयोग:** RAM वर्तमान में चल रहे ऐप्स को रखती है, जबकि ROM कंप्यूटर शुरू (Boot) करने के स्थायी निर्देश रखती है।', '- **Full Forms:** RAM = Random Access Memory; ROM = Read Only Memory.
1. **Nature:** RAM is Volatile (data erases when power turns off), while ROM is Non-Volatile (data stays permanently).
2. **Use:** RAM holds active running apps and open files; ROM holds permanent startup booting instructions.',
    $json$[{"cue_hi":"RAM = Volatile (अस्थायी मेज़)","cue_en":"RAM = Volatile (temporary desk)"},{"cue_hi":"ROM = Non-Volatile (स्थायी बूट निर्देश)","cue_en":"ROM = Non-Volatile (permanent boot rules)"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"RAM व ROM के सही पूरे नाम","criterion_en":"Exact full forms of RAM and ROM"},{"step_no":2,"marks":1,"criterion_hi":"अस्थायी बनाम स्थायी प्रकृति और उपयोग का अंतर","criterion_en":"Volatile vs non-volatile nature and purpose"}]$json$::jsonb,
    NULL, true
  ),
  -- #20: LONG_5M (TOPPER, PRACTICE)
  (
    '10000005-0001-4000-8000-000000000020', 'skill-ict-lab', 'skill-ict-ch1', 'Computer IPO Architecture', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB ICT Practical',
    'कंप्यूटर की कार्यप्रणाली (IPO चक्र) को चारों मुख्य इकाइयों — इनपुट, CPU (ALU व CU), आउटपुट और स्टोरेज — सहित विस्तार से समझाएँ।',
    'Explain the working of a computer (IPO Cycle) in detail covering all four main units: Input, CPU (ALU & CU), Output, and Storage.',
    NULL, NULL,
    '4 शीर्षक लिखें: (1) Input, (2) CPU [ALU + CU], (3) Output, (4) Memory/Storage — और अंत में एक सरल उदाहरण दें।', 'Write 4 clear headings: Input, CPU (ALU + CU), Output, and Storage, plus 1 concrete example.',
    NULL, NULL,
    'कंप्यूटर **IPO (Input → Process → Output)** सिद्धांत पर कार्य करता है:

**1. इनपुट इकाई (Input Unit):** इसके द्वारा यूज़र डेटा और आदेश कंप्यूटर के अंदर भेजता है। उदाहरण: कीबोर्ड, माउस, स्कैनर, माइक्रोफ़ोन।

**2. सेंट्रल प्रोसेसिंग यूनिट (CPU — कंप्यूटर का दिमाग):** यह डेटा को प्रोसेस करके उपयोगी सूचना में बदलता है। इसके दो मुख्य भाग हैं:
- **ALU (Arithmetic Logic Unit):** सभी गणितीय गणनाएँ ($+, -, \times, \div$) और तुलना ($>, <, =$) करता है।
- **CU (Control Unit):** सभी भागों के बीच डेटा के आवागमन को नियंत्रित करता है।

**3. आउटपुट इकाई (Output Unit):** प्रोसेसिंग के बाद तैयार परिणाम को यूज़र को दिखाती है। उदाहरण: मॉनिटर (Soft Copy), प्रिंटर (Hard Copy), स्पीकर।

**4. मेमोरी एवं स्टोरेज इकाई (Memory & Storage):** वर्तमान कार्य **RAM** (अस्थायी) में रहता है, जबकि फाइलें भविष्य के लिए **Hard Disk / SSD** (स्थायी स्टोरेज) में सुरक्षित रहती हैं।

**उदाहरण:** कीबोर्ड से `40 + 60` टाइप करना (**Input**) → ALU द्वारा जोड़ना (**Process**) → मॉनिटर पर `100` दिखना (**Output**) → फाइल सेव करना (**Storage**)।', 'A computer works on the **IPO (Input → Process → Output)** principle with four core units:

**1. Input Unit:** Accepts raw data and commands from the user into the computer. Examples: Keyboard, Mouse, Scanner, Microphone.

**2. Central Processing Unit (CPU — Brain of the Computer):** Processes raw data into meaningful information via two key sub-units:
- **ALU (Arithmetic Logic Unit):** Performs all mathematical operations ($+, -, \times, \div$) and logical comparisons ($>, <, =$).
- **CU (Control Unit):** Directs and coordinates data flow among all connected parts.

**3. Output Unit:** Presents the final processed result to the user. Examples: Monitor (Soft Copy), Printer (Hard Copy), Speaker.

**4. Memory & Storage Unit:** Active tasks stay temporarily in **RAM** (volatile), while saved files remain safely in permanent storage (**Hard Disk / SSD / Pen Drive**).

**Example:** Typing `40 + 60` on a keyboard (**Input**) → ALU adding them (**Process**) → Monitor displaying `100` (**Output**) → Saving the file (**Storage**).',
    $json$[{"cue_hi":"चार स्तंभ: Input → CPU (ALU+CU) → Output + Storage","cue_en":"Four pillars: Input → CPU (ALU+CU) → Output + Storage"},{"cue_hi":"उदाहरण: 40 + 60 = 100 लिखना न भूलें","cue_en":"Include the 40 + 60 = 100 concrete example"},{"cue_hi":"RAM (अस्थायी) व Hard Disk (स्थायी) का उल्लेख करें","cue_en":"Mention RAM (volatile) vs Hard Disk (permanent)"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"IPO चक्र का परिचय व Input इकाई (उदाहरण सहित)","criterion_en":"Introduces IPO cycle and Input Unit with examples"},{"step_no":2,"marks":1.5,"criterion_hi":"CPU के दोनों भागों (ALU और CU) का सही वर्णन","criterion_en":"Accurately explains both ALU and CU inside CPU"},{"step_no":3,"marks":1,"criterion_hi":"Output इकाई (Soft Copy व Hard Copy सहित)","criterion_en":"Explains Output Unit including Soft & Hard Copy"},{"step_no":4,"marks":1,"criterion_hi":"प्राथमिक (RAM) व स्थायी स्टोरेज का अंतर","criterion_en":"Explains Primary (RAM) and Secondary Storage"},{"step_no":5,"marks":0.5,"criterion_hi":"एक स्पष्ट दैनिक उदाहरण द्वारा समापन","criterion_en":"Concludes with one clear working example"}]$json$::jsonb,
    NULL, true
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
-- CHAPTER 2 OF 6: SKILL-ICT-CH2 — KEYBOARD, MOUSE & WINDOWS FILES MASTERY
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-ict-ch2',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: कीबोर्ड, माउस और विंडोज़ फाइल प्रबंधन",
  "title_en": "30-Second Mindmap: Keyboard, Mouse & Windows Files Mastery",
  "read_time_seconds": 30,
  "central_node": {
    "id": "ict2-root",
    "label_hi": "कीबोर्ड, माउस व विंडोज़ फाइलें",
    "label_en": "Keyboard, Mouse & Windows Files",
    "subtitle_hi": "आत्मविश्वास के साथ टाइप करें, क्लिक करें और फाइलें व्यवस्थित रखें",
    "subtitle_en": "Click, type, organize folders, and master Windows shortcuts effortlessly"
  },
  "branches": [
    {
      "id": "ict2-b1",
      "label_hi": "1. माउस की 5 प्रमुख क्रियाएँ",
      "label_en": "1. 5 Core Mouse Actions",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "ict2-b1-1",
          "label_hi": "Single Left Click: चुनना (Select)",
          "label_en": "Single Left Click: Select item"
        },
        {
          "id": "ict2-b1-2",
          "label_hi": "Double Left Click: खोलना (Open)",
          "label_en": "Double Left Click: Open file/folder"
        },
        {
          "id": "ict2-b1-3",
          "label_hi": "Right Click: विकल्प मेन्यू (Context Menu)",
          "label_en": "Right Click: Open options menu"
        },
        {
          "id": "ict2-b1-4",
          "label_hi": "Drag & Drop + Scroll Wheel",
          "label_en": "Drag & Drop + Scroll Wheel"
        }
      ]
    },
    {
      "id": "ict2-b2",
      "label_hi": "2. कीबोर्ड के ज़रूरी बटन",
      "label_en": "2. Essential Keyboard Keys",
      "color": "#059669",
      "children": [
        {
          "id": "ict2-b2-1",
          "label_hi": "Backspace (बाएँ मिटाए) बनाम Delete (दाएँ मिटाए)",
          "label_en": "Backspace (erase left) vs Delete (erase right)"
        },
        {
          "id": "ict2-b2-2",
          "label_hi": "Caps Lock (सब बड़े अक्षर) व Shift (1 बड़ा अक्षर/चिह्न)",
          "label_en": "Caps Lock (all capitals) & Shift (single capital/symbol)"
        },
        {
          "id": "ict2-b2-3",
          "label_hi": "Enter (नई लाइन / OK) व Spacebar (खाली जगह)",
          "label_en": "Enter (new line / OK) & Spacebar (space)"
        }
      ]
    },
    {
      "id": "ict2-b3",
      "label_hi": "3. फाइल, फोल्डर व एक्सटेंशन",
      "label_en": "3. Files, Folders & Extensions",
      "color": "#D97706",
      "children": [
        {
          "id": "ict2-b3-1",
          "label_hi": "फोल्डर = अलमारी · फाइल = कॉपी/कागज़",
          "label_en": "Folder = Almirah · File = Document"
        },
        {
          "id": "ict2-b3-2",
          "label_hi": ".docx (Word), .xlsx (Excel), .pdf, .jpg (फोटो)",
          "label_en": ".docx (Word), .xlsx (Excel), .pdf, .jpg (Photo)"
        }
      ]
    },
    {
      "id": "ict2-b4",
      "label_hi": "4. विंडोज़ शॉर्टकट व रीसाइकल बिन",
      "label_en": "4. Windows Shortcuts & Recycle Bin",
      "color": "#7C3AED",
      "children": [
        {
          "id": "ict2-b4-1",
          "label_hi": "Ctrl+C (Copy), Ctrl+X (Cut), Ctrl+V (Paste)",
          "label_en": "Ctrl+C (Copy), Ctrl+X (Cut), Ctrl+V (Paste)"
        },
        {
          "id": "ict2-b4-2",
          "label_hi": "Ctrl+Z (Undo / वापस लाएँ) · F2 (Rename)",
          "label_en": "Ctrl+Z (Undo) · F2 (Rename file/folder)"
        },
        {
          "id": "ict2-b4-3",
          "label_hi": "Recycle Bin: हटाई फाइल Restore करें",
          "label_en": "Recycle Bin: Restore accidentally deleted files"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "ict2-sec-1-mouse",
    "order": 1,
    "heading_hi": "1. माउस पकड़ने का सही तरीका और 5 आसान क्रियाएँ",
    "heading_en": "1. Holding the Mouse Right & Mastering All 5 Mouse Actions",
    "analogy_hi": "माउस को बिल्कुल कोमलता से पकड़िए — आपकी **तर्जनी उंगली (Index Finger)** बाएँ बटन पर और **मध्यमा (Middle Finger)** दाएँ बटन पर रहे! **Single Click** किसी मित्र का कंधा थपथपाकर उसे चुनने जैसा है; **Double Click** दरवाज़ा खोलने के लिए दो बार दस्तक देने जैसा है; **Right Click** होटल में **मेन्यू कार्ड** माँगने जैसा है (सारे विकल्प खुल जाते हैं!); और बीच का **Scroll Wheel** किताब के पन्ने ऊपर-नीचे पलटने जैसा है!",
    "analogy_en": "Hold the mouse gently — **Index Finger** on the Left button, **Middle Finger** on the Right button! **Single Click** is like tapping a friend on the shoulder to select them; **Double Click** is knocking twice to open a door; **Right Click** is asking for a **menu card** (shows every action you can take!); and the **Scroll Wheel** flips pages smoothly up and down!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "कंप्यूटर माउस के भाग और प्रत्येक बटन का कार्य",
      "title_en": "Parts of a Computer Mouse & What Each Button Does",
      "caption_hi": "बाएँ बटन से चुनें और खोलें, दाएँ बटन से विकल्प मेन्यू (Rename, Copy, Delete) खोलें और बीच के पहिए से पेज ऊपर-नीचे घुमाएँ।",
      "caption_en": "Use the Left button to select/open, Right button to open the options menu (Rename, Copy, Delete), and Scroll wheel to move up/down pages.",
      "viewBox": "0 0 660 270",
      "elements": [
        {
          "kind": "path",
          "d": "M 330 22 L 330 52",
          "fill": "none",
          "stroke": "#475569",
          "strokeWidth": 3
        },
        {
          "kind": "rect",
          "x": 268,
          "y": 52,
          "width": 124,
          "height": 186,
          "rx": 56,
          "fill": "#F8FAFC",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.8
        },
        {
          "kind": "line",
          "x1": 268,
          "y1": 128,
          "x2": 392,
          "y2": 128,
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "line",
          "x1": 330,
          "y1": 52,
          "x2": 330,
          "y2": 128,
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 322,
          "y": 74,
          "width": 16,
          "height": 34,
          "rx": 7,
          "fill": "#D97706",
          "stroke": "#92400E",
          "strokeWidth": 1.8
        },
        {
          "kind": "arrow",
          "x1": 215,
          "y1": 92,
          "x2": 282,
          "y2": 92,
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 20,
          "y": 54,
          "width": 192,
          "height": 82,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 116,
          "y": 78,
          "text_hi": "बायाँ बटन (Left Button)",
          "text_en": "Left Button (Index Finger)",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 116,
          "y": 114,
          "text_hi": "1 क्लिक = चुनें · 2 क्लिक = खोलें",
          "text_en": "1 Click = Select · 2 = Open",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 445,
          "y1": 92,
          "x2": 378,
          "y2": 92,
          "stroke": "#059669",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 448,
          "y": 54,
          "width": 192,
          "height": 82,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 544,
          "y": 78,
          "text_hi": "दायाँ बटन (Right Button)",
          "text_en": "Right Button (Middle Finger)",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 544,
          "y": 114,
          "text_hi": "विकल्प मेन्यू (Copy/Rename)",
          "text_en": "Context Menu (Copy/Rename)",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 215,
          "y1": 195,
          "x2": 320,
          "y2": 106,
          "stroke": "#D97706",
          "strokeWidth": 2,
          "dashed": true
        },
        {
          "kind": "rect",
          "x": 20,
          "y": 164,
          "width": 192,
          "height": 76,
          "rx": 10,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 116,
          "y": 190,
          "text_hi": "स्क्रॉल व्हील (Scroll Wheel)",
          "text_en": "Scroll Wheel",
          "fill": "#92400E",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 116,
          "y": 222,
          "text_hi": "पेज को ऊपर-नीचे खिसकाएँ",
          "text_en": "Roll page up & down",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "rect",
          "x": 448,
          "y": 164,
          "width": 192,
          "height": 76,
          "rx": 10,
          "fill": "#F5F3FF",
          "stroke": "#7C3AED",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 544,
          "y": 190,
          "text_hi": "ड्रैग एंड ड्रॉप (Drag & Drop)",
          "text_en": "Drag & Drop",
          "fill": "#5B21B6",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 544,
          "y": 222,
          "text_hi": "दबाकर खींचें और छोड़ें",
          "text_en": "Hold Left, move & release",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        }
      ]
    },
    "concept_md_hi": "### माउस पॉइंटर के आकार आपको संकेत देते हैं!\n- **सफेद तीर (Arrow Pointer):** सामान्य चयन (Select) के लिए तैयार।\n- **हाथ का चिह्न (Hand Pointer):** किसी लिंक या बटन पर क्लिक करने के लिए तैयार।\n- **I-बीम (I-Beam Cursor):** यहाँ आप क्लिक करके टाइपिंग शुरू कर सकते हैं।\n- **घूमता गोला (Busy Circle):** कंप्यूटर फाइल खोल रहा है — 2 सेकंड रुकें, बार-बार क्लिक न करें!\n\n**ड्रैग एंड ड्रॉप (Drag & Drop):** किसी फाइल पर बायाँ बटन दबाए रखें, उसे किसी फोल्डर के ऊपर खींचकर ले जाएँ और बटन छोड़ दें — फाइल तुरंत अंदर चली जाएगी!",
    "concept_md_en": "### Watch Your Mouse Pointer Shape — It Talks to You!\n- **Arrow Pointer:** Ready to select items and icons.\n- **Hand Pointer:** Hovering over a clickable link or button.\n- **I-Beam Cursor:** Ready to click and start typing text.\n- **Spinning Circle:** Computer is loading — wait 2 seconds calmly instead of clicking repeatedly!\n\n**Drag & Drop:** Press and hold the Left button on a file, drag it smoothly over a folder, and release — the file moves straight inside!",
    "exam_tip_hi": "प्रैक्टिकल टिप: डबल-क्लिक करते समय माउस को हिलाएँ नहीं — एक ही जगह पर जल्दी-जल्दी दो बार बायाँ बटन (`टिक-टिक`) दबाएँ! यदि दिक्कत हो, तो एक बार क्लिक करके कीबोर्ड का `Enter` बटन दबा दें — वही काम हो जाएगा!",
    "exam_tip_en": "Lab Pro Tip: Keep the mouse still while double-clicking (two quick taps in one spot). If double-clicking feels tricky at first, just single-click the folder and press `Enter` on the keyboard!",
    "glossary_terms": [
      {
        "term_hi": "कॉन्टेक्स्ट मेन्यू (Context Menu)",
        "term_en": "Context Menu (Right-Click Menu)",
        "pronunciation_hi": "कॉन्टेक्स्ट मेन्यू",
        "definition_hi": "किसी फाइल या डेस्कटॉप पर दायाँ क्लिक करने से खुलने वाली सूची (Open, Copy, Rename, Delete आदि)।",
        "definition_en": "The shortcut list of actions (Open, Copy, Rename, Delete) that opens when you Right-Click."
      },
      {
        "term_hi": "ड्रैग एंड ड्रॉप (Drag and Drop)",
        "term_en": "Drag and Drop",
        "pronunciation_hi": "ड्रैग एंड ड्रॉप",
        "definition_hi": "माउस का बायाँ बटन दबाए रखकर किसी आइकन को एक स्थान से दूसरे स्थान तक ले जाकर छोड़ना।",
        "definition_en": "Holding the left mouse button to move an icon or file to a new spot and releasing it."
      }
    ],
    "quick_check": {
      "q_hi": "किसी फोल्डर का नाम बदलने (Rename) या उसकी प्रॉपर्टी देखने के लिए माउस का कौन-सा बटन दबाते हैं?",
      "q_en": "Which mouse button opens options like Rename or Properties on a folder?",
      "answer_hi": "**दायाँ बटन (Right Click)** दबाने से कॉन्टेक्स्ट मेन्यू खुलता है, जहाँ Rename और Properties मिलते हैं।",
      "answer_en": "**Right Click** opens the context menu containing Rename, Copy, Delete, and Properties."
    }
  },
  {
    "id": "ict2-sec-2-keyboard",
    "order": 2,
    "heading_hi": "2. कीबोर्ड का नक्शा — हर बटन को 2 मिनट में दोस्त बनाएँ",
    "heading_en": "2. Keyboard Zone Map — Master Every Key Group in 2 Minutes",
    "analogy_hi": "कीबोर्ड के 104 बटनों को देखकर घबराएँ नहीं! यह एक **5 दुकानों वाले बाज़ार** जैसा है: (1) सबसे ऊपर **Function Keys (`F1–F12`)**, (2) बीच में **अक्षर बाज़ार (`A–Z`, QWERTY)**, (3) चारों तरफ मददगार बटन (**`Enter`, `Spacebar`, `Shift`, `Backspace`, `Delete`**), (4) दाईं ओर **तीर बटन (Arrow Keys)** और (5) कोने में **कैलकुलेटर पैड (`NumPad`)**!",
    "analogy_en": "Never feel intimidated by 104 keys! Think of a keyboard as **5 neat shops**: (1) Top **Function Keys (`F1–F12`)**, (2) Center **Alphabet Zone (`A–Z`, QWERTY)**, (3) Helper Keys (**`Enter`, `Spacebar`, `Shift`, `Backspace`, `Delete`**), (4) **Arrow Keys**, and (5) Calculator **NumPad** on the right!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "मानक QWERTY कीबोर्ड के 5 मुख्य क्षेत्र (Keyboard Zone Map)",
      "title_en": "5 Core Zones of a Standard QWERTY Keyboard",
      "caption_hi": "Backspace कर्सर के बाईं ओर का अक्षर मिटाता है, जबकि Delete कर्सर के दाईं ओर का अक्षर मिटाता है। Spacebar कीबोर्ड का सबसे लंबा बटन है।",
      "caption_en": "Backspace erases the character to the LEFT of the cursor, while Delete erases to the RIGHT. Spacebar is the longest key on the keyboard.",
      "viewBox": "0 0 660 270",
      "elements": [
        {
          "kind": "rect",
          "x": 16,
          "y": 18,
          "width": 628,
          "height": 236,
          "rx": 14,
          "fill": "#F8FAFC",
          "stroke": "#475569",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 32,
          "width": 460,
          "height": 36,
          "rx": 6,
          "fill": "#F5F3FF",
          "stroke": "#7C3AED",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 260,
          "y": 50,
          "text_hi": "1. फ़ंक्शन कुंजियाँ (Esc, F1 – F12)",
          "text_en": "1. Function Keys (Esc, F1 – F12)",
          "fill": "#5B21B6",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 78,
          "width": 356,
          "height": 112,
          "rx": 8,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 208,
          "y": 116,
          "text_hi": "2. टाइपिंग क्षेत्र (A–Z, 0–9, चिह्न)",
          "text_en": "2. Typing Zone (QWERTY A–Z, 0–9)",
          "fill": "#1E3A8A",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 208,
          "y": 158,
          "text_hi": "Shift + अक्षर = 1 बड़ा अक्षर · Caps Lock = सभी बड़े",
          "text_en": "Shift + letter = 1 Capital · Caps Lock = ALL CAPS",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "rect",
          "x": 396,
          "y": 78,
          "width": 94,
          "height": 50,
          "rx": 6,
          "fill": "#FEF2F2",
          "stroke": "#DC2626",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 443,
          "y": 100,
          "text_hi": "Backspace",
          "text_en": "Erase Left",
          "fill": "#991B1B",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 396,
          "y": 138,
          "width": 94,
          "height": 52,
          "rx": 6,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 443,
          "y": 162,
          "text_hi": "Enter",
          "text_en": "New Line / OK",
          "fill": "#065F46",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 200,
          "width": 88,
          "height": 38,
          "rx": 6,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 74,
          "y": 219,
          "text_hi": "Ctrl / Alt",
          "text_en": "Shortcut Keys",
          "fill": "#92400E",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 128,
          "y": 200,
          "width": 258,
          "height": 38,
          "rx": 6,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 257,
          "y": 219,
          "text_hi": "Spacebar (सबसे लंबी कुंजी — खाली जगह)",
          "text_en": "Spacebar (Longest Key — Word Space)",
          "fill": "#92400E",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 396,
          "y": 200,
          "width": 94,
          "height": 38,
          "rx": 6,
          "fill": "#EFF6FF",
          "stroke": "#2563EB",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 443,
          "y": 219,
          "text_hi": "Arrow Keys",
          "text_en": "Up/Down/L/R",
          "fill": "#1D4ED8",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 502,
          "y": 32,
          "width": 128,
          "height": 56,
          "rx": 6,
          "fill": "#FEF2F2",
          "stroke": "#DC2626",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 566,
          "y": 56,
          "text_hi": "Delete कुंजी",
          "text_en": "Delete (Right)",
          "fill": "#991B1B",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 502,
          "y": 98,
          "width": 128,
          "height": 140,
          "rx": 8,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 566,
          "y": 152,
          "text_hi": "5. NumPad",
          "text_en": "Numeric Keypad",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 566,
          "y": 192,
          "text_hi": "0–9 व + − × ÷",
          "text_en": "Num Lock ON",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        }
      ]
    },
    "concept_md_hi": "### शुरुआती छात्रों के 4 सबसे ज़रूरी कीबोर्ड नियम\n1. **Backspace बनाम Delete:** मान लीजिए शब्द `BI|HAR` में कर्सर `|` बीच में है। **`Backspace`** दबाने पर बायाँ अक्षर (`I`) मिटेगा; **`Delete`** दबाने पर दायाँ अक्षर (`H`) मिटेगा!\n2. **Shift बनाम Caps Lock:** सिर्फ पहला अक्षर बड़ा लिखना हो (जैसे `Patna`) या बटन के ऊपर वाला चिह्न (`@`, `#`, `?`, `%`) टाइप करना हो, तो **`Shift`** दबाए रखकर बटन दबाएँ। पूरा शब्द बड़े अक्षरों (`BIHAR`) में लिखने के लिए **`Caps Lock`** ऑन करें।\n3. **Ctrl (Control) और Alt:** ये अकेले कुछ नहीं करते, पर दूसरे बटनों के साथ मिलकर जादुई **शॉर्टकट** बनाते हैं (जैसे `Ctrl + C`)!\n4. **QWERTY नाम क्यों?** कीबोर्ड की ऊपरी अक्षर पंक्ति के पहले 6 अक्षर `Q-W-E-R-T-Y` होते हैं।",
    "concept_md_en": "### 4 Essential Keyboard Rules for Beginners\n1. **Backspace vs Delete:** Imagine the cursor `|` is in the middle of `BI|HAR`. Pressing **`Backspace`** erases the character to the LEFT (`I`); pressing **`Delete`** erases to the RIGHT (`H`)!\n2. **Shift vs Caps Lock:** Hold **`Shift`** to type one capital letter (like `P` in `Patna`) or the top symbol on a key (`@`, `#`, `?`, `%`). Toggle **`Caps Lock`** when typing an entire heading in capitals (`BIHAR`).\n3. **Ctrl & Alt (Modifier Keys):** They do nothing alone, but combine with letters to create fast **Shortcuts** (like `Ctrl + C`)!\n4. **Why \"QWERTY\"?** Named after the first 6 letters `Q-W-E-R-T-Y` on the top letter row.",
    "exam_tip_hi": "बोर्ड परीक्षा का पक्का MCQ: \"कीबोर्ड की सबसे लंबी कुंजी कौन-सी है?\" → **Spacebar**। और \"ईमेल में `@` चिह्न टाइप करने के लिए क्या दबाते हैं?\" → **`Shift + 2`**!",
    "exam_tip_en": "Guaranteed MCQ: \"Which is the longest key on a keyboard?\" → **Spacebar**. And \"How do you type `@` for an email ID?\" → **`Shift + 2`**!",
    "glossary_terms": [
      {
        "term_hi": "कर्सर (Cursor)",
        "term_en": "Cursor",
        "pronunciation_hi": "कर्सर",
        "definition_hi": "स्क्रीन पर टिमटिमाती खड़ी रेखा `|` जो बताती है कि अगला टाइप किया गया अक्षर कहाँ लिखा जाएगा।",
        "definition_en": "The blinking vertical line `|` on screen showing exactly where your next typed letter will appear."
      },
      {
        "term_hi": "मॉडिफ़ायर कुंजियाँ (Modifier Keys)",
        "term_en": "Modifier Keys (Ctrl, Shift, Alt)",
        "pronunciation_hi": "मॉडिफ़ायर कीज़",
        "definition_hi": "Ctrl, Shift और Alt जैसी कुंजियाँ जो अन्य कुंजियों के साथ मिलकर विशेष शॉर्टकट कार्य करती हैं।",
        "definition_en": "Keys like Ctrl, Shift, and Alt that combine with other keys to perform special shortcuts."
      }
    ],
    "quick_check": {
      "q_hi": "यदि स्क्रीन पर `SCHO|OL` लिखा है और आप `Backspace` एक बार दबाते हैं, तो कौन-सा अक्षर मिटेगा?",
      "q_en": "If `SCHO|OL` is on screen and you press `Backspace` once, which letter gets erased?",
      "answer_hi": "कर्सर के ठीक **बाईं ओर वाला `O`** मिटेगा (तब `SCH|OL` बचेगा)।",
      "answer_en": "The **`O` immediately to the LEFT** of the cursor is erased (leaving `SCH|OL`)."
    }
  },
  {
    "id": "ict2-sec-3-files-extensions",
    "order": 3,
    "heading_hi": "3. विंडोज़ डेस्कटॉप, फोल्डर और फाइल एक्सटेंशन (.docx, .pdf, .jpg)",
    "heading_en": "3. Windows Desktop, Folders & File Extensions (.docx, .pdf, .jpg)",
    "analogy_hi": "सोचिए आपका कंप्यूटर एक **स्कूल भवन** है। उसके अंदर **Drive (`D:`)** एक कमरा है, **फोल्डर (Folder)** उस कमरे की **पीली अलमारी** है (जैसे `Class_10_Notes`), और **फाइल (File)** अलमारी के अंदर रखी एक **कॉपी या मार्कशीट** है! हर फाइल के नाम के पीछे बिंदु (`.`) के बाद लगा छोटा कोड — जैसे `Application.docx` या `Photo.jpg` — उसका **फाइल एक्सटेंशन (File Extension)** कहलाता है, बिल्कुल स्कूल यूनिफ़ॉर्म के बैज जैसा जो बताता है कि यह फाइल किस सॉफ्टवेयर में खुलेगी!",
    "analogy_en": "Think of your computer as a **School Building**: a **Drive (`D:`)** is a room, a **Folder** is a yellow **Almirah** (`Class_10_Notes`), and a **File** is a single notebook stored inside! The tiny code after the dot (`.`) — like `Application.docx` or `Photo.jpg` — is the **File Extension**, like a uniform badge telling Windows exactly which program opens it!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "सबसे ज़रूरी फाइल एक्सटेंशन — एक नज़र में पहचानें",
      "title_en": "Must-Know File Extensions — Identify Any File in 1 Second",
      "caption_hi": "फाइल का नाम और एक्सटेंशन हमेशा एक बिंदु (.) से अलग होते हैं — जैसे: Result_2026.pdf",
      "caption_en": "A file name and its extension are always separated by a dot (.) — for example: Result_2026.pdf",
      "headers_hi": [
        "एक्सटेंशन",
        "फाइल का प्रकार",
        "खोलने वाला सॉफ्टवेयर",
        "दैनिक छात्र उदाहरण"
      ],
      "headers_en": [
        "Extension",
        "File Type",
        "Opens With",
        "Everyday Student Example"
      ],
      "rows": [
        {
          "cells_hi": [
            ".docx",
            "वर्ड डॉक्यूमेंट (Document)",
            "Microsoft Word",
            "Leave_Application.docx"
          ],
          "cells_en": [
            ".docx",
            "Word Document",
            "Microsoft Word",
            "Leave_Application.docx"
          ]
        },
        {
          "cells_hi": [
            ".xlsx",
            "एक्सेल स्प्रेडशीट (Spreadsheet)",
            "Microsoft Excel",
            "Class10_Marksheet.xlsx"
          ],
          "cells_en": [
            ".xlsx",
            "Excel Spreadsheet",
            "Microsoft Excel",
            "Class10_Marksheet.xlsx"
          ]
        },
        {
          "cells_hi": [
            ".pptx",
            "प्रेज़ेंटेशन स्लाइड (Slides)",
            "Microsoft PowerPoint",
            "Science_Project.pptx"
          ],
          "cells_en": [
            ".pptx",
            "Presentation Slides",
            "Microsoft PowerPoint",
            "Science_Project.pptx"
          ]
        },
        {
          "cells_hi": [
            ".pdf",
            "पोर्टेबल डॉक्यूमेंट (Locked Page)",
            "PDF Viewer / Chrome",
            "BSEB_Admit_Card.pdf"
          ],
          "cells_en": [
            ".pdf",
            "Portable Document Format",
            "PDF Viewer / Chrome",
            "BSEB_Admit_Card.pdf"
          ]
        },
        {
          "cells_hi": [
            ".jpg / .png",
            "चित्र / फोटो (Image)",
            "Photos / MS Paint",
            "Passport_Photo.jpg"
          ],
          "cells_en": [
            ".jpg / .png",
            "Picture / Image",
            "Photos / MS Paint",
            "Passport_Photo.jpg"
          ]
        },
        {
          "cells_hi": [
            ".mp3 / .mp4",
            "ऑडियो (.mp3) / वीडियो (.mp4)",
            "Media Player",
            "Lecture_Video.mp4"
          ],
          "cells_en": [
            ".mp3 / .mp4",
            "Audio (.mp3) / Video (.mp4)",
            "Media Player",
            "Lecture_Video.mp4"
          ]
        }
      ]
    },
    "concept_md_hi": "### विंडोज़ डेस्कटॉप के 3 मुख्य हिस्से और फोल्डर बनाना\n- **डेस्कटॉप (Desktop):** कंप्यूटर खुलते ही दिखने वाली पहली मुख्य स्क्रीन, जिस पर छोटे-छोटे चित्र (**Icons**) दिखते हैं।\n- **टास्कबार (Taskbar):** स्क्रीन के सबसे नीचे की पट्टी — बाईं ओर **Start बटन**, बीच में खुले हुए ऐप्स, और दाईं ओर **तारीख, समय और वॉल्यूम** दिखता है।\n- **नया फोल्डर कैसे बनाएँ?** खाली जगह पर **Right Click → New → Folder** (या शॉर्टकट **`Ctrl + Shift + N`**) दबाएँ, अपना नाम (`Roll12_Anjali`) लिखें और `Enter` दबा दें!\n- **नाम बदलना (Rename):** फाइल चुनकर कीबोर्ड पर **`F2`** दबाएँ या Right Click → Rename चुनें।",
    "concept_md_en": "### 3 Key Parts of Windows Desktop & Creating Folders\n- **Desktop:** The first main screen after booting, displaying shortcut **Icons** (like This PC, Recycle Bin).\n- **Taskbar:** The bottom horizontal bar — **Start button** on the left, open apps in the middle, and **Clock, Date & Volume** on the right.\n- **Creating a New Folder:** **Right Click** on blank space → **New** → **Folder** (or shortcut **`Ctrl + Shift + N`**), type your name (`Roll12_Anjali`), and press `Enter`!\n- **Renaming (`F2`):** Select any file/folder and press **`F2`** (or Right Click → Rename).",
    "exam_tip_hi": "एक्सटेंशन पर हर साल प्रश्न आता है: MS Word = **`.docx`**, MS Excel = **`.xlsx`**, PowerPoint = **`.pptx`**, और फोटो = **`.jpg` / `.png`**। ध्यान दें: फाइल के नाम में `/`, `\\`, `:`, `*`, `?` जैसे चिह्न नहीं लगा सकते!",
    "exam_tip_en": "High-yield exam fact: MS Word = **`.docx`**, MS Excel = **`.xlsx`**, PowerPoint = **`.pptx`**, Photo = **`.jpg` / `.png`**. Remember: file names cannot contain characters like `/`, `\\`, `:`, `*`, or `?`!",
    "glossary_terms": [
      {
        "term_hi": "फाइल एक्सटेंशन (File Extension)",
        "term_en": "File Extension",
        "pronunciation_hi": "फाइल एक्सटेंशन",
        "definition_hi": "फाइल नाम के अंत में बिंदु के बाद आने वाले 3–4 अक्षर (.pdf, .docx, .jpg) जो फाइल का प्रकार बताते हैं।",
        "definition_en": "The 3–4 letters after the dot at the end of a filename (.pdf, .docx, .jpg) identifying its format."
      },
      {
        "term_hi": "टास्कबार (Taskbar)",
        "term_en": "Taskbar",
        "pronunciation_hi": "टास्कबार",
        "definition_hi": "विंडोज़ स्क्रीन के सबसे नीचे स्थित पट्टी जिसमें Start बटन, खुले प्रोग्राम और घड़ी होती है।",
        "definition_en": "The bar along the bottom of Windows containing the Start button, open apps, and clock."
      }
    ],
    "quick_check": {
      "q_hi": "यदि किसी फाइल का नाम `Bihar_Board_Marks.xlsx` है, तो यह किस सॉफ्टवेयर की फाइल है?",
      "q_en": "If a file is named `Bihar_Board_Marks.xlsx`, which software created it?",
      "answer_hi": "**Microsoft Excel**, क्योंकि `.xlsx` एक्सेल स्प्रेडशीट का एक्सटेंशन है।",
      "answer_en": "**Microsoft Excel**, because `.xlsx` is the standard Excel spreadsheet extension."
    }
  },
  {
    "id": "ict2-sec-4-clipboard-recycle",
    "order": 4,
    "heading_hi": "4. क्लिपबोर्ड का जादू (Copy, Cut, Paste, Undo) और रीसाइकल बिन सुरक्षा",
    "heading_en": "4. Clipboard Magic (Copy, Cut, Paste, Undo) & Recycle Bin Safety",
    "analogy_hi": "**क्लिपबोर्ड (Clipboard)** कंप्यूटर का अदृश्य हाथ है! **`Ctrl + C` (Copy)** किताब के पन्ने की **फोटोकॉपी** करने जैसा है — असली पन्ना अपनी जगह रहता है और नई जगह उसकी नकल चिपक जाती है। **`Ctrl + X` (Cut)** कैंची से पन्ना काटकर दूसरी जगह ले जाने जैसा है — पुरानी जगह से हट जाता है! **`Ctrl + V` (Paste)** गोंद से चिपकाना है। और यदि गलती हो जाए, तो **`Ctrl + Z` (Undo)** टाइम-मशीन बनकर 1 सेकंड में पुरानी स्थिति वापस ले आता है!",
    "analogy_en": "The **Clipboard** is the computer's invisible holding hand! **`Ctrl + C` (Copy)** is like making a **photocopy** — the original stays put! **`Ctrl + X` (Cut)** is like cutting with scissors — it moves the item away from its old place! **`Ctrl + V` (Paste)** glues it into the new spot. Made a mistake? **`Ctrl + Z` (Undo)** acts like a time-machine and reverses your last step in 1 second!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "सुरक्षित फाइल कॉपी, मूव और रीसाइकल बिन रिकवरी प्रक्रिया",
      "title_en": "Safe File Copy, Move & Recycle Bin Recovery Workflow",
      "caption_hi": "सामान्य Delete से हटाई गई फाइल Recycle Bin (कूड़ेदान) में जाती है और वहाँ से Restore हो सकती है। लेकिन Shift + Delete फाइल को हमेशा के लिए मिटा देता है!",
      "caption_en": "Normal Delete sends a file to the Recycle Bin where it can be Restored. Beware: Shift + Delete permanently erases the file without using the Recycle Bin!",
      "direction": "LR",
      "steps": [
        {
          "id": "s1",
          "label_hi": "1. फाइल चुनें",
          "label_en": "1. Select File",
          "detail_hi": "फाइल पर 1 बार बायाँ क्लिक करें।",
          "detail_en": "Single Left-Click on the file.",
          "accent": "indigo"
        },
        {
          "id": "s2",
          "label_hi": "2. कॉपी या कट करें",
          "label_en": "2. Copy or Cut",
          "detail_hi": "Ctrl + C (नकल) या Ctrl + X (स्थान बदलना) → क्लिपबोर्ड में जाता है।",
          "detail_en": "Ctrl + C (Copy) or Ctrl + X (Move) → goes to Clipboard.",
          "accent": "amber"
        },
        {
          "id": "s3",
          "label_hi": "3. नए फोल्डर में पेस्ट",
          "label_en": "3. Paste in Target",
          "detail_hi": "नया फोल्डर खोलकर Ctrl + V दबाएँ।",
          "detail_en": "Open destination folder and press Ctrl + V.",
          "accent": "emerald"
        },
        {
          "id": "s4",
          "label_hi": "4. गलती हुई? Undo / Restore",
          "label_en": "4. Mistake? Undo / Restore",
          "detail_hi": "तुरंत Ctrl + Z दबाएँ या Recycle Bin से Restore करें।",
          "detail_en": "Press Ctrl + Z immediately or Restore from Recycle Bin.",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "s1",
          "to": "s2",
          "label_hi": "क्लिपबोर्ड",
          "label_en": "To Clipboard"
        },
        {
          "from": "s2",
          "to": "s3",
          "label_hi": "Ctrl + V",
          "label_en": "Ctrl + V"
        },
        {
          "from": "s3",
          "to": "s4",
          "label_hi": "सुरक्षा जाल",
          "label_en": "Safety Net"
        }
      ]
    },
    "concept_md_hi": "### 6 गोल्डन विंडोज़ शॉर्टकट (हमेशा काम आते हैं!)\n- **`Ctrl + C`:** Copy (नकल बनाना — मूल फाइल सुरक्षित रहती है)\n- **`Ctrl + X`:** Cut (मूव करना — पुरानी जगह से हटाकर नई जगह ले जाना)\n- **`Ctrl + V`:** Paste (कॉपी या कट की गई चीज़ को चिपकाना)\n- **`Ctrl + Z`:** Undo (आखिरी गलती को तुरंत वापस सुधारना)\n- **`Ctrl + Y`:** Redo (Undo किए गए काम को फिर से लाना)\n- **`F2`:** किसी चुनी हुई फाइल/फोल्डर का नाम बदलना (Rename)\n\n**रीसाइकल बिन (Recycle Bin) से फाइल वापस लाना:** Recycle Bin खोलें → हटाई गई फाइल पर Right Click करें → **Restore** पर क्लिक करें → फाइल ठीक अपने पुराने फोल्डर में लौट आएगी!",
    "concept_md_en": "### 6 Golden Windows Shortcuts You Will Use Every Day\n- **`Ctrl + C`:** Copy (duplicate — original stays untouched)\n- **`Ctrl + X`:** Cut (move — removes from old spot once pasted)\n- **`Ctrl + V`:** Paste (place the copied or cut item)\n- **`Ctrl + Z`:** Undo (instantly reverse your last mistake)\n- **`Ctrl + Y`:** Redo (re-apply an undone action)\n- **`F2`:** Rename the selected file or folder\n\n**Restoring from Recycle Bin:** Open Recycle Bin → Right-Click the deleted file → click **Restore** → the file returns to its exact original folder!",
    "exam_tip_hi": "सबसे लोकप्रिय परीक्षा अंतर: सामान्य **`Delete`** फाइल को **Recycle Bin** में भेजता है (वापस मिल सकती है), जबकि **`Shift + Delete`** फाइल को **स्थायी रूप से (Permanently)** मिटा देता है — वह Recycle Bin में नहीं जाती!",
    "exam_tip_en": "Top exam favourite: Plain **`Delete`** sends a file to the **Recycle Bin** (recoverable), whereas **`Shift + Delete`** deletes it **permanently** (bypassing the Recycle Bin)!",
    "glossary_terms": [
      {
        "term_hi": "क्लिपबोर्ड (Clipboard)",
        "term_en": "Clipboard",
        "pronunciation_hi": "क्लिपबोर्ड",
        "definition_hi": "मेमोरी का अस्थायी स्थान जहाँ Copy या Cut किया गया डेटा Paste होने तक रुका रहता है।",
        "definition_en": "Temporary memory area that holds copied or cut items until you paste them."
      },
      {
        "term_hi": "रीसाइकल बिन (Recycle Bin)",
        "term_en": "Recycle Bin",
        "pronunciation_hi": "रीसाइकल बिन",
        "definition_hi": "विंडोज़ का डिजिटल कूड़ेदान जहाँ सामान्य रूप से Delete की गई फाइलें अस्थायी रूप से रखी जाती हैं।",
        "definition_en": "Windows safety folder that temporarily holds deleted files so you can restore them if needed."
      }
    ],
    "quick_check": {
      "q_hi": "यदि आपने गलती से कोई महत्वपूर्ण पैराग्राफ मिटा दिया, तो उसे 1 सेकंड में वापस लाने का शॉर्टकट क्या है?",
      "q_en": "If you accidentally erase an important paragraph, which shortcut brings it back in 1 second?",
      "answer_hi": "**`Ctrl + Z` (Undo)** — यह आपकी अंतिम क्रिया को तुरंत पलट देता है।",
      "answer_en": "**`Ctrl + Z` (Undo)** — it immediately reverses your last action."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{Ctrl} + \\text{C} \\;(\\text{Copy}),\\quad \\text{Ctrl} + \\text{X} \\;(\\text{Cut}),\\quad \\text{Ctrl} + \\text{V} \\;(\\text{Paste})",
      "label_hi": "क्लिपबोर्ड के 3 मुख्य शॉर्टकट",
      "label_en": "The 3 Core Clipboard Shortcuts"
    },
    {
      "latex": "\\text{Ctrl} + \\text{Z} \\;(\\text{Undo}),\\quad \\text{F2} \\;(\\text{Rename}),\\quad \\text{Shift} + \\text{Delete} \\;(\\text{Permanent})",
      "label_hi": "सुधार, नामकरण व स्थायी डिलीट शॉर्टकट",
      "label_en": "Undo, Rename & Permanent Delete Shortcuts"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "Spacebar",
      "fact_hi": "Spacebar कीबोर्ड की सबसे लंबी कुंजी होती है।",
      "fact_en": "Spacebar is the longest key on a standard keyboard."
    },
    {
      "tag": "Backspace",
      "fact_hi": "Backspace कर्सर के बाईं ओर और Delete कर्सर के दाईं ओर का अक्षर मिटाता है।",
      "fact_en": "Backspace erases left of cursor; Delete erases right of cursor."
    },
    {
      "tag": "Extensions",
      "fact_hi": "Word = .docx · Excel = .xlsx · PowerPoint = .pptx · Photo = .jpg/.png।",
      "fact_en": "Word = .docx · Excel = .xlsx · PowerPoint = .pptx · Image = .jpg/.png."
    },
    {
      "tag": "Recycle Bin",
      "fact_hi": "सामान्य Delete की गई फाइल Recycle Bin से Restore की जा सकती है।",
      "fact_en": "Normally deleted files can be recovered via Restore in Recycle Bin."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "Copy (`Ctrl+C`) और Cut (`Ctrl+X`) को एक ही समझ लेना।",
      "mistake_en": "Treating Copy (`Ctrl+C`) and Cut (`Ctrl+X`) as identical.",
      "fix_hi": "Copy मूल फाइल की दूसरी नकल बनाता है; Cut मूल फाइल को पुरानी जगह से हटाकर नई जगह मूव करता है।",
      "fix_en": "Copy keeps the original and duplicates it; Cut moves the original to the new location."
    },
    {
      "mistake_hi": "एक बड़ा अक्षर लिखने के लिए बार-बार Caps Lock चालू-बंद करना और भूल जाना।",
      "mistake_en": "Toggling Caps Lock on for a single capital letter and forgetting to turn it off.",
      "fix_hi": "सिर्फ एक बड़ा अक्षर लिखने के लिए हमेशा `Shift + अक्षर` दबाएँ — आदत बनते ही टाइपिंग दुगुनी तेज़ होगी!",
      "fix_en": "Always hold `Shift + letter` for a single capital letter so Caps Lock never gets stuck ON."
    },
    {
      "mistake_hi": "किसी फाइल का नाम बदलते समय उसका एक्सटेंशन (`.docx` / `.pdf`) मिटा देना।",
      "mistake_en": "Deleting the file extension (`.docx` / `.pdf`) while renaming.",
      "fix_hi": "केवल बिंदु (.) के पहले वाला नाम बदलें, पीछे का एक्सटेंशन सुरक्षित रहने दें।",
      "fix_en": "Edit only the filename before the dot and leave the extension intact."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "विंडोज़ फाइल एक्सटेंशन (.docx, .xlsx, .pdf, .jpg, .mp4)",
      "topic_en": "Windows File Extensions (.docx, .xlsx, .pdf, .jpg, .mp4)",
      "years": [
        "BSEB ICT Lab",
        "Objective"
      ],
      "expected_marks": 4
    },
    {
      "topic_hi": "Ctrl+C, Ctrl+X, Ctrl+V, Ctrl+Z, F2 व Shift+Delete शॉर्टकट",
      "topic_en": "Clipboard, Rename & Delete Keyboard Shortcuts",
      "years": [
        "BSEB ICT Lab",
        "Practical"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "Backspace बनाम Delete और माउस की 5 क्रियाएँ",
      "topic_en": "Backspace vs Delete & 5 Mouse Actions",
      "years": [
        "BSEB ICT Viva"
      ],
      "expected_marks": 3
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 4,
  "analogy_count": 4,
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
  'skill-ict-ch2',
  2,
  'छात्र सही हाथ रखकर माउस की पाँचों क्रियाएँ कर सकेंगे, कीबोर्ड पर Shift, Backspace, Delete, Spacebar व Enter का सटीक उपयोग कर अपना परिचय टाइप कर सकेंगे, अपना फोल्डर बना सकेंगे, फाइल एक्सटेंशन पहचान सकेंगे तथा Ctrl+C/X/V/Z व Recycle Bin Restore का अभ्यास कर सकेंगे।',
  'Students will hold a mouse ergonomically, execute all 5 mouse actions, type their introduction using Shift/Backspace/Delete/Enter, create and rename personal folders, recognize common file extensions, and apply Ctrl+C/X/V/Z plus Recycle Bin Restore.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "माउस ग्रिप अभ्यास व Notepad पर पहला टाइपिंग परिचय",
    "phase_en": "Mouse Grip Warm-Up & First Typing Practice in Notepad",
    "teacher_action_hi": "पहले 10 मिनट हर जोड़ी को माउस पर सही 2 उंगलियाँ (तर्जनी=Left, मध्यमा=Right) रखवाएँ। Notepad खुलवाएँ और दोनों छात्रों से बारी-बारी 5-5 मिनट में अपना नाम, विद्यालय का नाम और बिहार का ज़िला टाइप करवाएँ — `Shift` से पहला अक्षर बड़ा, `Spacebar` से दूरी और `Backspace` से सुधार सिखाएँ।",
    "teacher_action_en": "Spend 10 minutes checking gentle two-finger mouse posture across all pairs. Open Notepad and give each partner a strict 5-minute turn typing their name, school name, and Bihar district using `Shift` for capitals, `Spacebar`, `Enter`, and `Backspace`.",
    "student_check_hi": "पूछें: \"क्या `Patna` का सिर्फ `P` बड़ा लिखने के लिए Caps Lock दबाना बेहतर है या `Shift + P`?\"",
    "student_check_en": "Ask: \"To type just capital `P` in `Patna`, is `Shift + P` smarter than toggling Caps Lock?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "फोल्डर बनाना, Copy–Paste–Rename (F2) और Recycle Bin Rescue",
    "phase_en": "Create Personal Folder, Copy–Paste–Rename (F2) & Recycle Bin Rescue",
    "teacher_action_hi": "हर जोड़ी से `Documents` के अंदर `RollNo_Name` फोल्डर बनवाएँ (`Ctrl+Shift+N`), उनकी Notepad फाइल को `Ctrl+C` और `Ctrl+V` से उसमें कॉपी करवाएँ, फिर `F2` से नाम बदलवाएँ। अंत में जानबूझकर एक टेस्ट फाइल को सामान्य `Delete` कर Recycle Bin से **Restore** करवाकर डर खत्म करें!",
    "teacher_action_en": "Guide every pair to create `RollNo_Name` inside Documents (`Ctrl+Shift+N`), copy their Notepad file into it using `Ctrl+C` / `Ctrl+V`, and rename it with `F2`. Finally, deliberately delete one dummy file and **Restore** it from Recycle Bin to build total confidence!",
    "student_check_hi": "मौखिक जाँच: \"यदि फाइल को `Shift + Delete` से मिटा दें, तो क्या वह Recycle Bin में मिलेगी?\"",
    "student_check_en": "Oral check: \"If a file is erased with `Shift + Delete`, will it appear in the Recycle Bin?\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड शॉर्टकट व एक्सटेंशन चार्ट",
    "heading_en": "Blackboard Shortcuts & Extensions Chart",
    "points_hi": [
      "Backspace = बाएँ मिटाएँ (←)  |  Delete = दाएँ मिटाएँ (→)",
      "Ctrl + C = Copy (नकल)  |  Ctrl + X = Cut (हटाकर ले जाना)  |  Ctrl + V = Paste (चिपकाना)",
      "Ctrl + Z = Undo (गलती सुधारें)  |  F2 = Rename  |  Shift + Delete = स्थायी डिलीट",
      ".docx = Word  |  .xlsx = Excel  |  .pdf = PDF दस्तावेज़  |  .jpg/.png = फोटो"
    ],
    "points_en": [
      "Backspace = Erase Left (←)  |  Delete = Erase Right (→)",
      "Ctrl + C = Copy  |  Ctrl + X = Cut (Move)  |  Ctrl + V = Paste",
      "Ctrl + Z = Undo  |  F2 = Rename  |  Shift + Delete = Permanent Delete",
      ".docx = Word  |  .xlsx = Excel  |  .pdf = PDF Document  |  .jpg/.png = Photo"
    ]
  },
  {
    "heading_hi": "बिजली कटने पर ऑफलाइन बैकअप (Power-Cut Blackboard Backup)",
    "heading_en": "Offline / Power-Cut Blackboard Backup Activity",
    "points_hi": [
      "ब्लैकबोर्ड पर एक बड़ा फोल्डर-वृक्ष बनाएँ: D: ड्राइव → Class_10 → [Hindi, Math, ICT] → Notes.pdf",
      "छात्रों से अपनी कॉपी में \"मेरा डिजिटल बस्ता\" फोल्डर ट्री बनवाएँ और हर विषय के अंदर 2 सही एक्सटेंशन वाली फाइलों के नाम लिखवाएँ।",
      "ब्लैकबोर्ड पर शब्द `B I | H A R` लिखें और छात्रों से पूछें कि Backspace दबाने पर क्या बचेगा और Delete दबाने पर क्या बचेगा!"
    ],
    "points_en": [
      "Draw a clean Folder Tree on the blackboard: Drive D: → Class_10 → [Hindi, Math, ICT] → Notes.pdf",
      "Have students design their own \"Digital School Bag\" folder tree in notebooks with 2 realistic file names + extensions per subject.",
      "Write `B I | H A R` on the board and quiz students on what remains after pressing Backspace vs Delete!"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "लैब जोड़ी मिशन: \"फाइल रेस्क्यू चैलेंज\" (1 PC = 2 छात्र)",
    "title_en": "ICT Lab Pair Mission: \"File Rescue Challenge\"",
    "materials_hi": "लैब कंप्यूटर, Windows File Explorer और Notepad",
    "materials_en": "Lab PC, Windows File Explorer, and Notepad",
    "steps_hi": "चरण 1: डेस्कटॉप पर `Practice_Pair` फोल्डर बनाएँ। चरण 2: उसमें एक Notepad फाइल सेव करें। चरण 3: `F2` से नाम बदलें। चरण 4: उसे सामान्य `Delete` करें और 30 सेकंड के अंदर Recycle Bin से वापस `Restore` करके शिक्षक को दिखाएँ!",
    "steps_en": "Step 1: Create `Practice_Pair` folder on Desktop. Step 2: Save a Notepad file inside. Step 3: Rename it using `F2`. Step 4: Press normal `Delete`, then `Restore` it from Recycle Bin within 30 seconds and show the teacher!"
  },
  {
    "title_hi": "ऑफलाइन खेल: \"एक्सटेंशन जासूस\" (बिना बिजली)",
    "title_en": "Offline Game: \"File Extension Detective\" (No Power Needed)",
    "materials_hi": "ब्लैकबोर्ड पर लिखे 8 फाइल नाम",
    "materials_en": "8 file names written on the blackboard",
    "steps_hi": "बोर्ड पर `Result.pdf`, `Letter.docx`, `Marks.xlsx`, `Pic.jpg`, `Song.mp3`, `Class.mp4`, `Slides.pptx`, `Notes.txt` लिखें। दो टीमें बारी-बारी सही सॉफ्टवेयर और प्रकार बताकर अंक जीतें।",
    "steps_en": "Write 8 filenames (`Result.pdf`, `Letter.docx`, `Marks.xlsx`, `Pic.jpg`, `Song.mp3`, `Class.mp4`, `Slides.pptx`, `Notes.txt`) on the board. Two teams take turns identifying the software and file type for points."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "(बिना कंप्यूटर गृहकार्य) अपनी कॉपी में 6 मुख्य शॉर्टकट (`Ctrl+C`, `Ctrl+X`, `Ctrl+V`, `Ctrl+Z`, `F2`, `Shift+Delete`) और 5 फाइल एक्सटेंशन (`.docx`, `.xlsx`, `.pdf`, `.jpg`, `.mp4`) की साफ सारणी बनाकर याद करें।",
    "task_en": "(Zero-Computer Homework) Make a neat table in your notebook of 6 shortcuts (`Ctrl+C`, `Ctrl+X`, `Ctrl+V`, `Ctrl+Z`, `F2`, `Shift+Delete`) and 5 extensions (`.docx`, `.xlsx`, `.pdf`, `.jpg`, `.mp4`)."
  },
  {
    "level": "BOARD",
    "task_hi": "`Backspace` बनाम `Delete` तथा `Copy` बनाम `Cut` में स्पष्ट उदाहरण सहित अंतर लिखें।",
    "task_en": "Write clear differences with examples between `Backspace` vs `Delete` and `Copy` vs `Cut`."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "सोचकर एक 3-स्तरीय फोल्डर संरचना कॉपी में बनाएँ जिससे स्कूल के प्रधानाध्यापक कक्षा 9 से 12 के सभी छात्रों की मार्कशीट और फोटो बिना उलझन के रख सकें।",
    "task_en": "Design a 3-level folder structure in your notebook so your school Principal can organize Class 9–12 marksheets and photos cleanly."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "फाइल को Delete करते ही वह हमेशा के लिए गायब हो गई और वापस नहीं आ सकती।",
    "misconception_en": "Deleting a file immediately erases it forever with no way back.",
    "correction_hi": "लैब में लाइव Recycle Bin खोलकर Restore दिखाएँ (साथ ही चेतावनी दें कि केवल Shift+Delete या Empty Recycle Bin स्थायी होता है)।",
    "correction_en": "Demonstrate Recycle Bin Restore live in class (while warning that only Shift+Delete or Emptying the Bin is permanent)."
  },
  {
    "misconception_hi": "Ctrl + C दबाते ही फाइल तुरंत नई जगह अपने आप दिखने लगती है।",
    "misconception_en": "Pressing Ctrl + C immediately places the copied file in the new folder.",
    "correction_hi": "क्लिपबोर्ड समझाएँ: Ctrl + C सिर्फ फाइल को \"अदृश्य हाथ\" में उठाता है; नए फोल्डर में जाकर Ctrl + V दबाने पर ही वह वहाँ आती है।",
    "correction_en": "Explain Clipboard: Ctrl + C only picks the copy up; you must open the target folder and press Ctrl + V to place it."
  },
  {
    "misconception_hi": "डबल-क्लिक धीरे-धीरे दो बार करने से फाइल खुल जाएगी।",
    "misconception_en": "Clicking slowly twice counts as a double-click.",
    "correction_hi": "माउस को स्थिर रखकर तेज़ी से \"टिक-टिक\" दबाने का अभ्यास कराएँ, या 1 क्लिक + Enter विकल्प सिखाएँ।",
    "correction_en": "Practice two rapid clicks without moving the mouse, or teach the easy alternative: Single-Click + Enter."
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

-- Questions for skill-ict-ch2 (20 multi-mode items)
INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- #1: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000001', 'skill-ict-lab', 'skill-ict-ch2', 'Backspace vs Delete', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'ICT Lab Core',
    'Backspace और Delete कुंजियों में क्या अंतर है?',
    'What is the difference between Backspace and Delete keys?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "टाइपिंग करते समय Backspace और Delete में क्या अंतर है?",
  "front_en": "While typing, what is the difference between Backspace and Delete?",
  "back_hi": "Backspace कर्सर के बाईं ओर (पीछे) के अक्षर मिटाता है। Delete कर्सर के दाईं ओर (आगे) के अक्षर मिटाता है।",
  "back_en": "Backspace erases characters to the LEFT of the cursor. Delete erases characters to the RIGHT of the cursor.",
  "pronunciation_hi": "बैकस्पेस (Backspace) बनाम डिलीट (Delete)",
  "mnemonic_hi": "याद रखें: BACK-space = पीछे (बाईं ओर) से मिटाना!",
  "mnemonic_en": "Memory hook: BACK-space = erase backwards (left)!"
}$json$::jsonb, true
  ),
  -- #2: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000002', 'skill-ict-lab', 'skill-ict-ch2', 'Clipboard & Cut vs Copy', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'ICT Lab Core',
    'क्लिपबोर्ड (Clipboard) क्या है और Cut (Ctrl+X) बनाम Copy (Ctrl+C) में क्या अंतर है?',
    'What is the Clipboard, and how does Cut (Ctrl+X) differ from Copy (Ctrl+C)?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "क्लिपबोर्ड क्या है? Cut (Ctrl+X) और Copy (Ctrl+C) में क्या अंतर है?",
  "front_en": "What is the Clipboard? How is Cut (Ctrl+X) different from Copy (Ctrl+C)?",
  "back_hi": "क्लिपबोर्ड अस्थायी मेमोरी है जो कॉपी/कट डेटा को पेस्ट होने तक रोकती है। Copy (Ctrl+C) मूल की नकल बनाता है; Cut (Ctrl+X) मूल को पुरानी जगह से हटाकर नई जगह ले जाता है।",
  "back_en": "Clipboard temporarily holds copied/cut data until pasted. Copy (Ctrl+C) duplicates while keeping the original; Cut (Ctrl+X) moves the item from its old location.",
  "pronunciation_hi": "क्लिपबोर्ड (Clipboard)",
  "mnemonic_hi": "X दिखने में कैंची (Scissors) जैसा है — इसलिए Ctrl + X = Cut!",
  "mnemonic_en": "X looks like a pair of scissors — so Ctrl + X = Cut!"
}$json$::jsonb, true
  ),
  -- #3: MATCH_PAIRS (FOUNDATION, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000003', 'skill-ict-lab', 'skill-ict-ch2', 'Mouse Actions', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', NULL,
    'माउस की क्रियाओं को उनके सही परिणाम से मिलाएँ:',
    'Match each mouse action with its exact result:',
    NULL, NULL,
    'सोचें कि मेन्यू कार्ड किस बटन से खुलता है और दरवाज़ा किससे खुलता है!', 'Think about which click selects, opens, shows the options menu, or moves pages!',
    'Single Left Click चुनता है, Double Left Click खोलता है, Right Click विकल्प मेन्यू दिखाता है और Scroll Wheel पेज घुमाता है।', 'Single Left-Click selects, Double Left-Click opens, Right-Click shows the context menu, and Scroll Wheel scrolls pages.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "माउस क्रिया को उसके सही कार्य से मिलाएँ",
  "instruction_en": "Match each mouse action to its function",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "सिंगल लेफ्ट क्लिक (Single Left Click)",
      "left_en": "Single Left Click",
      "right_hi": "किसी फाइल या आइकन को चुनना (Select)",
      "right_en": "Select a file or icon"
    },
    {
      "id": "p2",
      "left_hi": "डबल लेफ्ट क्लिक (Double Left Click)",
      "left_en": "Double Left Click",
      "right_hi": "फोल्डर या प्रोग्राम को खोलना (Open)",
      "right_en": "Open a folder or app"
    },
    {
      "id": "p3",
      "left_hi": "राइट क्लिक (Right Click)",
      "left_en": "Right Click",
      "right_hi": "विकल्प मेन्यू खोलना (Copy/Rename/Delete)",
      "right_en": "Open Context Menu (Copy/Rename)"
    },
    {
      "id": "p4",
      "left_hi": "स्क्रॉल व्हील (Scroll Wheel)",
      "left_en": "Scroll Wheel",
      "right_hi": "लंबे पेज को ऊपर-नीचे खिसकाना",
      "right_en": "Move a long page up and down"
    }
  ]
}$json$::jsonb, true
  ),
  -- #4: MATCH_PAIRS (BOARD, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000004', 'skill-ict-lab', 'skill-ict-ch2', 'File Extensions', 'PRACTICE', 'MATCH_PAIRS', 'BOARD', 'BSEB ICT Model',
    'फाइल एक्सटेंशन को उनके सही सॉफ्टवेयर / प्रकार से मिलाएँ:',
    'Match each file extension with its exact software or file type:',
    NULL, NULL,
    'doc = Document (Word), xls = Excel Sheet, jpg = Photo, pdf = Portable Document!', 'doc = Word Document, xls = Excel Sheet, jpg = Image, pdf = Portable Document!',
    '.docx वर्ड फाइल है, .xlsx एक्सेल शीट, .jpg फोटो और .pdf लॉक्ड पोर्टेबल दस्तावेज़ (जैसे एडमिट कार्ड) है।', '.docx is MS Word, .xlsx is MS Excel, .jpg is a photo image, and .pdf is a Portable Document Format file.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही एक्सटेंशन और फाइल प्रकार के जोड़े मिलाएँ",
  "instruction_en": "Pair each file extension with its matching software",
  "pairs": [
    {
      "id": "p1",
      "left_hi": ".docx",
      "left_en": ".docx",
      "right_hi": "MS Word डॉक्यूमेंट (आवेदन पत्र)",
      "right_en": "MS Word Document"
    },
    {
      "id": "p2",
      "left_hi": ".xlsx",
      "left_en": ".xlsx",
      "right_hi": "MS Excel स्प्रेडशीट (मार्कशीट)",
      "right_en": "MS Excel Spreadsheet"
    },
    {
      "id": "p3",
      "left_hi": ".jpg / .png",
      "left_en": ".jpg / .png",
      "right_hi": "चित्र / पासपोर्ट फोटो (Image)",
      "right_en": "Picture / Image File"
    },
    {
      "id": "p4",
      "left_hi": ".pdf",
      "left_en": ".pdf",
      "right_hi": "पोर्टेबल डॉक्यूमेंट (एडमिट कार्ड / नोट्स)",
      "right_en": "Portable Document (Admit Card / Notes)"
    }
  ]
}$json$::jsonb, true
  ),
  -- #5: SHORTCUT_STUDIO (FOUNDATION, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000005', 'skill-ict-lab', 'skill-ict-ch2', 'Windows Copy Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'FOUNDATION', 'ICT Lab Hands-On',
    'चुनी हुई फाइल "Science_Notes.pdf" की एक नकल (Copy) बनाने के लिए सही शॉर्टकट दबाएँ:',
    'Press the correct shortcut to Copy the selected file "Science_Notes.pdf" to the Clipboard:',
    NULL, NULL,
    'Copy शब्द अंग्रेजी के अक्षर C से शुरू होता है — इसे Ctrl के साथ दबाएँ!', 'Copy begins with the letter C — combine it with Ctrl!',
    'Ctrl + C चुनी हुई फाइल या टेक्स्ट की नकल क्लिपबोर्ड में बना देता है, जबकि मूल फाइल अपनी जगह सुरक्षित रहती है।', 'Ctrl + C copies the selected file or text into the Clipboard while keeping the original intact.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "WINDOWS",
  "task_hi": "चयनित फाइल \"Science_Notes.pdf\" को क्लिपबोर्ड में कॉपी (Copy) करें",
  "task_en": "Copy the selected file \"Science_Notes.pdf\" to the Clipboard",
  "expected_keys": [
    "Ctrl",
    "C"
  ],
  "sample_doc_before": "Folder: Class_10_Bihar  >  [Selected: Science_Notes.pdf]",
  "preview_effect": "COPY",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "C",
    "X",
    "V",
    "Z",
    "S"
  ]
}$json$::jsonb, true
  ),
  -- #6: SHORTCUT_STUDIO (FOUNDATION, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000006', 'skill-ict-lab', 'skill-ict-ch2', 'Windows Paste Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'FOUNDATION', 'ICT Lab Hands-On',
    'क्लिपबोर्ड में कॉपी की गई फाइल को नए फोल्डर में पेस्ट (Paste) करने का शॉर्टकट दबाएँ:',
    'Press the shortcut to Paste the copied file from the Clipboard into the new folder:',
    NULL, NULL,
    'C के ठीक बगल वाला बटन V पेस्ट (Paste) करता है — Ctrl के साथ दबाएँ!', 'Use the key right next to C — Ctrl + V pastes from the Clipboard!',
    'Ctrl + V क्लिपबोर्ड में रखी कॉपी या कट की गई फाइल को वर्तमान फोल्डर में चिपका देता है। (Ctrl + P तो Print के लिए होता है!)', 'Ctrl + V pastes the copied or cut item into the open folder. (Remember: Ctrl + P is for Print, not Paste!)',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "WINDOWS",
  "task_hi": "क्लिपबोर्ड से \"Science_Notes.pdf\" को \"My_Homework\" फोल्डर में पेस्ट (Paste) करें",
  "task_en": "Paste \"Science_Notes.pdf\" from the Clipboard into \"My_Homework\" folder",
  "expected_keys": [
    "Ctrl",
    "V"
  ],
  "sample_doc_before": "Science_Notes.pdf — Bihar Board Class 10 Notes",
  "preview_effect": "PASTE",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "C",
    "V",
    "P",
    "X",
    "Z"
  ]
}$json$::jsonb, true
  ),
  -- #7: SHORTCUT_STUDIO (BOARD, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000007', 'skill-ict-lab', 'skill-ict-ch2', 'Windows Undo Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'BOARD', 'ICT Lab Hands-On',
    'आपने गलती से एक फाइल का नाम गलत बदल दिया! पिछली स्थिति तुरंत वापस (Undo) लाने का शॉर्टकट दबाएँ:',
    'You accidentally renamed a file wrongly! Press the shortcut to Undo your last action immediately:',
    NULL, NULL,
    'गलती सुधारने वाली टाइम-मशीन कुंजी अंग्रेजी वर्णमाला का आखिरी अक्षर Z है!', 'The undo time-machine uses the very last letter of the alphabet with Ctrl!',
    'Ctrl + Z (Undo) आपकी आखिरी गलती को 1 सेकंड में पलटकर पुरानी स्थिति वापस ले आता है।', 'Ctrl + Z (Undo) immediately reverses your last action in Windows, Word, and Excel.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "WINDOWS",
  "task_hi": "गलत हुए कार्य को तुरंत वापस (Undo) करें",
  "task_en": "Immediately Undo the accidental rename action",
  "expected_keys": [
    "Ctrl",
    "Z"
  ],
  "sample_doc_before": "Admit_Card_2026.pdf",
  "preview_effect": "UNDO",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "Z",
    "Y",
    "U",
    "C",
    "V"
  ]
}$json$::jsonb, true
  ),
  -- #8: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000008', 'skill-ict-lab', 'skill-ict-ch2', 'Keyboard Basics', 'PRACTICE', 'MCQ', 'FOUNDATION', 'ICT Lab Core',
    'मानक कीबोर्ड पर सबसे लंबी कुंजी (Longest Key) कौन-सी होती है?',
    'Which is the longest key on a standard keyboard?',
    $json$[{"key":"A","text_hi":"Enter","text_en":"Enter"},{"key":"B","text_hi":"Shift","text_en":"Shift"},{"key":"C","text_hi":"Spacebar","text_en":"Spacebar"},{"key":"D","text_hi":"Tab","text_en":"Tab"}]$json$::jsonb, 'C',
    'दो शब्दों के बीच खाली जगह देने के लिए सबसे नीचे बीच में कौन-सी लंबी पट्टी होती है?', 'Which long bar at the very bottom puts spaces between words?',
    'Spacebar कीबोर्ड की सबसे लंबी कुंजी है और इसका उपयोग दो शब्दों के बीच एक खाली स्थान देने के लिए होता है।', 'The Spacebar is the longest key on a keyboard and inserts a blank space between words.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #9: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000009', 'skill-ict-lab', 'skill-ict-ch2', 'Mouse Double Click', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'डेस्कटॉप पर बने किसी फोल्डर को खोलने के लिए माउस से क्या किया जाता है?',
    'What mouse action opens a folder on the Windows Desktop?',
    $json$[{"key":"A","text_hi":"बायाँ बटन जल्दी-जल्दी दो बार दबाना (Double Left Click)","text_en":"Quickly press the Left button twice (Double Left Click)"},{"key":"B","text_hi":"स्क्रॉल व्हील घुमाना","text_en":"Roll the scroll wheel"},{"key":"C","text_hi":"दायाँ बटन तीन बार दबाना","text_en":"Press the right button three times"},{"key":"D","text_hi":"माउस को उल्टा रख देना","text_en":"Flip the mouse upside down"}]$json$::jsonb, 'A',
    'दरवाज़ा खोलने के लिए दो बार दस्तक दी जाती है!', 'Like knocking twice to open a door!',
    'फोल्डर या फाइल खोलने के लिए बायाँ बटन जल्दी-जल्दी दो बार (Double Left Click) दबाते हैं, या एक बार क्लिक कर Enter दबाते हैं।', 'Double Left-Clicking opens a folder or file (alternatively, single-click and press Enter).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #10: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000010', 'skill-ict-lab', 'skill-ict-ch2', 'Windows Taskbar', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'विंडोज़ स्क्रीन के सबसे नीचे की पट्टी जहाँ Start बटन और घड़ी दिखती है, क्या कहलाती है?',
    'What is the bottom bar on the Windows screen showing the Start button and clock called?',
    $json$[{"key":"A","text_hi":"मेन्यू बार (Menu Bar)","text_en":"Menu Bar"},{"key":"B","text_hi":"टास्कबार (Taskbar)","text_en":"Taskbar"},{"key":"C","text_hi":"फॉर्मूला बार (Formula Bar)","text_en":"Formula Bar"},{"key":"D","text_hi":"स्टेटस कार्ड (Status Card)","text_en":"Status Card"}]$json$::jsonb, 'B',
    'यह आपके चल रहे सभी काम (Tasks) दिखाती है!', 'It displays all your currently running tasks!',
    'टास्कबार (Taskbar) स्क्रीन के निचले हिस्से में होती है और Start बटन, खुले प्रोग्राम तथा दिनांक-समय दिखाती है।', 'The Taskbar sits at the bottom of the screen and holds the Start button, open apps, and date/time.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #11: MCQ (BOARD, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000011', 'skill-ict-lab', 'skill-ict-ch2', 'Rename Shortcut', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'विंडोज़ में किसी चुनी हुई फाइल या फोल्डर का नाम बदलने (Rename) के लिए किस फंक्शन कुंजी का उपयोग होता है?',
    'Which Function key renames a selected file or folder in Windows?',
    $json$[{"key":"A","text_hi":"F1","text_en":"F1"},{"key":"B","text_hi":"F12","text_en":"F12"},{"key":"C","text_hi":"F5","text_en":"F5"},{"key":"D","text_hi":"F2","text_en":"F2"}]$json$::jsonb, 'D',
    'F1 Help के लिए और F5 Refresh के लिए है — इन दोनों के बीच नाम बदलने की कुंजी है!', 'F1 is Help and F5 is Refresh — the rename key comes right after F1!',
    'विंडोज़ में किसी फाइल या फोल्डर को चुनकर F2 दबाने पर तुरंत उसका नाम बदला (Rename) जा सकता है। (F5 Refresh के लिए है।)', 'Pressing F2 lets you immediately rename any selected file or folder in Windows. (F1 = Help, F5 = Refresh.)',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #12: MCQ (BOARD, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000012', 'skill-ict-lab', 'skill-ict-ch2', 'File Extensions', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'इनमें से कौन-सा एक चित्र / फोटो (Image) फाइल का एक्सटेंशन है?',
    'Which of the following is an Image / Photo file extension?',
    $json$[{"key":"A","text_hi":".docx","text_en":".docx"},{"key":"B","text_hi":".jpg","text_en":".jpg"},{"key":"C","text_hi":".mp3","text_en":".mp3"},{"key":"D","text_hi":".xlsx","text_en":".xlsx"}]$json$::jsonb, 'B',
    '.docx वर्ड है, .mp3 गाना है और .xlsx एक्सेल है!', '.docx is Word, .mp3 is audio, and .xlsx is Excel!',
    '.jpg (या .jpeg / .png) चित्र एवं फोटो फाइलों का मानक एक्सटेंशन है।', '.jpg (as well as .jpeg and .png) is a standard image/photo file extension.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #13: MCQ (BOARD, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000013', 'skill-ict-lab', 'skill-ict-ch2', 'Shift Key Symbols', 'PRACTICE', 'MCQ', 'BOARD', NULL,
    'कीबोर्ड पर `@` (At the rate) चिह्न टाइप करने के लिए किन बटनों को एक साथ दबाना पड़ता है?',
    'Which key combination types the `@` symbol on a standard keyboard?',
    $json$[{"key":"A","text_hi":"Ctrl + 2","text_en":"Ctrl + 2"},{"key":"B","text_hi":"Alt + 2","text_en":"Alt + 2"},{"key":"C","text_hi":"Shift + 2","text_en":"Shift + 2"},{"key":"D","text_hi":"Caps Lock + 2","text_en":"Caps Lock + 2"}]$json$::jsonb, 'C',
    'किसी भी बटन पर ऊपर छपा दूसरा चिह्न टाइप करने के लिए हमेशा Shift दबाया जाता है!', 'To type the upper symbol printed on any number key, always hold Shift!',
    'संख्या `2` की कुंजी के ऊपर `@` बना होता है। `Shift + 2` दबाने पर `@` टाइप होता है।', 'The `@` sign sits above key `2`, so holding `Shift + 2` types `@`.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #14: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000014', 'skill-ict-lab', 'skill-ict-ch2', 'Permanent Delete', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB ICT Model',
    'किस शॉर्टकट से हटाई गई फाइल Recycle Bin में जाए बिना सीधे स्थायी रूप से (Permanently) मिट जाती है?',
    'Which shortcut permanently deletes a file WITHOUT sending it to the Recycle Bin?',
    $json$[{"key":"A","text_hi":"केवल Delete","text_en":"Delete only"},{"key":"B","text_hi":"Ctrl + Delete","text_en":"Ctrl + Delete"},{"key":"C","text_hi":"Alt + F2","text_en":"Alt + F2"},{"key":"D","text_hi":"Shift + Delete","text_en":"Shift + Delete"}]$json$::jsonb, 'D',
    'सामान्य Delete सुरक्षित है; इसके साथ कौन-सी Modifier कुंजी जोड़ने पर यह स्थायी हो जाता है?', 'Plain Delete is recoverable; adding one modifier key makes it permanent!',
    'Shift + Delete दबाने पर विंडोज़ चेतावनी पूछकर फाइल को Recycle Bin में भेजे बिना स्थायी रूप से हटा देता है।', 'Shift + Delete bypasses the Recycle Bin and permanently deletes the selected file after confirmation.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #15: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000015', 'skill-ict-lab', 'skill-ict-ch2', 'Backspace vs Delete Application', 'PRACTICE', 'MCQ', 'TOPPER', NULL,
    'यदि स्क्रीन पर शब्द `PAT|NA` लिखा है (जहाँ `|` कर्सर है) और आप एक बार `Delete` दबाते हैं, तो स्क्रीन पर क्या बचेगा?',
    'If `PAT|NA` is typed on screen (where `|` is the cursor) and you press `Delete` once, what remains?',
    $json$[{"key":"A","text_hi":"PATA","text_en":"PATA"},{"key":"B","text_hi":"PANA","text_en":"PANA"},{"key":"C","text_hi":"PATN","text_en":"PATN"},{"key":"D","text_hi":"ATNA","text_en":"ATNA"}]$json$::jsonb, 'A',
    'Delete कर्सर के ठीक दाईं ओर वाला अक्षर मिटाता है — `|` के ठीक दाएँ कौन-सा अक्षर है?', 'Delete removes the character immediately to the RIGHT of the cursor `|`!',
    '`PAT|NA` में कर्सर के ठीक दाएँ अक्षर `N` है। `Delete` दबाने पर `N` मिटेगा और `PATA` बचेगा! (`Backspace` दबाने पर `T` मिटकर `PANA` बनता।)', 'Immediately to the right of `|` in `PAT|NA` is `N`. Pressing `Delete` removes `N`, leaving `PATA`!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #16: MCQ (FOUNDATION, EXAM_ONLY)
  (
    '10000005-0002-4000-8000-000000000016', 'skill-ict-lab', 'skill-ict-ch2', 'Cut Shortcut', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'ICT Live Exam',
    'किसी फाइल या टेक्स्ट को पुरानी जगह से हटाकर दूसरी जगह ले जाने (Cut) का शॉर्टकट क्या है?',
    'What is the keyboard shortcut to Cut a selected file or text to move it elsewhere?',
    $json$[{"key":"A","text_hi":"Ctrl + C","text_en":"Ctrl + C"},{"key":"B","text_hi":"Ctrl + Z","text_en":"Ctrl + Z"},{"key":"C","text_hi":"Ctrl + V","text_en":"Ctrl + V"},{"key":"D","text_hi":"Ctrl + X","text_en":"Ctrl + X"}]$json$::jsonb, 'D',
    'कैंची (Scissors) के आकार वाला अक्षर याद करें!', 'Remember the letter shaped like open scissors!',
    'Ctrl + X (Cut) चयनित फाइल या टेक्स्ट को क्लिपबोर्ड में मूव करता है, जिसे Ctrl + V से नई जगह पेस्ट किया जाता है।', 'Ctrl + X cuts the selected item so you can move it to a new location with Ctrl + V.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #17: MCQ (BOARD, EXAM_ONLY)
  (
    '10000005-0002-4000-8000-000000000017', 'skill-ict-lab', 'skill-ict-ch2', 'New Folder Shortcut', 'EXAM_ONLY', 'MCQ', 'BOARD', 'ICT Live Exam',
    'विंडोज़ फाइल एक्सप्लोरर में सीधे नया फोल्डर (New Folder) बनाने का कीबोर्ड शॉर्टकट क्या है?',
    'What is the keyboard shortcut to create a New Folder directly in Windows File Explorer?',
    $json$[{"key":"A","text_hi":"Ctrl + Shift + N","text_en":"Ctrl + Shift + N"},{"key":"B","text_hi":"Ctrl + F","text_en":"Ctrl + F"},{"key":"C","text_hi":"Alt + N","text_en":"Alt + N"},{"key":"D","text_hi":"Shift + F2","text_en":"Shift + F2"}]$json$::jsonb, 'A',
    'N = New, और इसे Ctrl + Shift के साथ दबाते हैं!', 'N stands for New, combined with Ctrl + Shift!',
    'विंडोज़ में `Ctrl + Shift + N` दबाने से तुरंत एक नया फोल्डर बन जाता है जिसे आप नाम दे सकते हैं।', 'Pressing `Ctrl + Shift + N` instantly creates a new folder in Windows File Explorer or on the Desktop.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #18: MCQ (TOPPER, EXAM_ONLY)
  (
    '10000005-0002-4000-8000-000000000018', 'skill-ict-lab', 'skill-ict-ch2', 'Invalid Filename Characters', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'ICT Live Exam',
    'विंडोज़ में किसी फाइल का नाम रखते समय निम्नलिखित में से कौन-सा नाम अमान्य (Invalid) होगा?',
    'Which of the following filenames is INVALID in Windows?',
    $json$[{"key":"A","text_hi":"Bihar_Notes_2026.pdf","text_en":"Bihar_Notes_2026.pdf"},{"key":"B","text_hi":"Science/Chapter1?.docx","text_en":"Science/Chapter1?.docx"},{"key":"C","text_hi":"Class-10 Marks.xlsx","text_en":"Class-10 Marks.xlsx"},{"key":"D","text_hi":"Roll15_Anjali.jpg","text_en":"Roll15_Anjali.jpg"}]$json$::jsonb, 'B',
    'विंडोज़ फाइल नामों में `/`, `\`, `:`, `*`, `?` जैसे विशेष चिह्नों की अनुमति नहीं देता!', 'Windows forbids special symbols like `/`, `\`, `:`, `*`, `?` inside file names!',
    'फाइल नाम में `/` और `?` चिह्न निषिद्ध होते हैं (क्योंकि `/` फोल्डर पथ के लिए आरक्षित है)। अंडरस्कोर `_` और डैश `-` बिल्कुल मान्य हैं।', 'Characters like `/` and `?` are forbidden in Windows filenames. Underscores `_`, hyphens `-`, and spaces are completely valid.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #19: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000019', 'skill-ict-lab', 'skill-ict-ch2', 'Copy vs Cut', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'फाइल प्रबंधन में Copy (Ctrl+C) और Cut (Ctrl+X) के बीच दो मुख्य अंतर लिखें।',
    'Write two key differences between Copy (Ctrl+C) and Cut (Ctrl+X) in file management.',
    NULL, NULL,
    'दोनों के शॉर्टकट और मूल फाइल पर पड़ने वाले प्रभाव को स्पष्ट करें।', 'Contrast their shortcuts and what happens to the original file.',
    NULL, NULL,
    '1. **मूल फाइल पर प्रभाव:** **Copy (`Ctrl + C`)** करने पर मूल फाइल अपने पुराने स्थान पर सुरक्षित रहती है और नए स्थान पर उसकी दूसरी प्रति बनती है। **Cut (`Ctrl + X`)** करने पर मूल फाइल पुराने स्थान से हटकर नए स्थान पर चली जाती है।
2. **उपयोग:** किसी फाइल का बैकअप या दूसरी प्रति बनाने के लिए Copy, तथा फाइल को एक फोल्डर से दूसरे फोल्डर में स्थान बदलने (Move) के लिए Cut का प्रयोग होता है।', '1. **Effect on Original:** **Copy (`Ctrl + C`)** leaves the original file intact and creates a duplicate at the new spot. **Cut (`Ctrl + X`)** removes the file from its old spot and moves it to the new destination.
2. **Purpose:** Copy is used for backups or duplicates; Cut is used for moving files between folders.',
    $json$[{"cue_hi":"Copy = फोटोकॉपी (मूल सुरक्षित)","cue_en":"Copy = Photocopy (original stays)"},{"cue_hi":"Cut = कैंची से मूव (पुराने स्थान से हटता है)","cue_en":"Cut = Move (leaves old folder)"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"मूल फाइल पर प्रभाव का सही अंतर","criterion_en":"Correctly contrasts effect on original file"},{"step_no":2,"marks":1,"criterion_hi":"सही शॉर्टकट व व्यावहारिक उपयोग का उल्लेख","criterion_en":"States accurate shortcuts and practical use"}]$json$::jsonb,
    NULL, true
  ),
  -- #20: LONG_5M (TOPPER, PRACTICE)
  (
    '10000005-0002-4000-8000-000000000020', 'skill-ict-lab', 'skill-ict-ch2', 'Windows File Management Practical', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB ICT Practical',
    'विंडोज़ में (क) नया फोल्डर बनाना, (ख) उसका नाम बदलना, (ग) किसी फाइल को उसमें मूव करना, और (घ) गलती से डिलीट हुई फाइल को Recycle Bin से वापस लाने के चरण क्रम से लिखें।',
    'Write step-by-step instructions in Windows to: (a) create a new folder, (b) rename it, (c) move a file into it, and (d) restore an accidentally deleted file from the Recycle Bin.',
    NULL, NULL,
    'चारों भागों के लिए माउस विधि और कीबोर्ड शॉर्टकट दोनों लिखें ताकि पूरे 5/5 अंक मिलें!', 'Mention both mouse steps and keyboard shortcuts for all four tasks to score 5/5!',
    NULL, NULL,
    '**(क) नया फोल्डर बनाना (Create Folder):**
1. डेस्कटॉप या किसी ड्राइव की खाली जगह पर **Right Click** करें → **New** → **Folder** चुनें (या शॉर्टकट **`Ctrl + Shift + N`** दबाएँ)।
2. फोल्डर का नाम (जैसे `Class10_Notes`) लिखकर `Enter` दबाएँ।

**(ख) फोल्डर का नाम बदलना (Rename):**
1. फोल्डर पर 1 बार क्लिक कर चुनें।
2. कीबोर्ड पर **`F2`** दबाएँ (या Right Click → Rename चुनें), नया नाम लिखें और `Enter` दबाएँ।

**(ग) फाइल को नए फोल्डर में मूव करना (Move File):**
1. फाइल चुनें और **`Ctrl + X`** (Cut) दबाएँ।
2. नया फोल्डर डबल-क्लिक कर खोलें और **`Ctrl + V`** (Paste) दबाएँ।

**(घ) डिलीट हुई फाइल को Recycle Bin से वापस लाना (Restore):**
1. डेस्कटॉप पर **Recycle Bin** आइकन पर डबल-क्लिक कर खोलें।
2. हटाई गई फाइल पर **Right Click** करें और **Restore** चुनें।
3. फाइल तुरंत अपने पुराने फोल्डर में लौट आएगी। *(ध्यान दें: `Shift + Delete` से मिटाई फाइल वापस नहीं आती!)*', '**(a) Create a New Folder:**
1. Right-click blank space on the Desktop or inside a drive → select **New** → **Folder** (or press **`Ctrl + Shift + N`**).
2. Type a clear name (e.g., `Class10_Notes`) and press `Enter`.

**(b) Rename the Folder:**
1. Single-click the folder to select it.
2. Press **`F2`** (or Right-click → **Rename**), type the new name, and press `Enter`.

**(c) Move a File into the Folder:**
1. Select the file and press **`Ctrl + X`** (Cut).
2. Double-click to open the target folder and press **`Ctrl + V`** (Paste).

**(d) Restore a Deleted File from Recycle Bin:**
1. Double-click the **Recycle Bin** icon on the Desktop.
2. Right-click the deleted file and click **Restore**.
3. Windows returns the file to its exact original folder. *(Note: `Shift + Delete` permanently deletes files and skips the Recycle Bin.)*',
    $json$[{"cue_hi":"नया फोल्डर = Ctrl + Shift + N","cue_en":"New Folder = Ctrl + Shift + N"},{"cue_hi":"Rename = F2 · Move = Ctrl + X फिर Ctrl + V","cue_en":"Rename = F2 · Move = Ctrl + X then Ctrl + V"},{"cue_hi":"वापस लाना = Recycle Bin → Right Click → Restore","cue_en":"Recover = Recycle Bin → Right Click → Restore"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1.25,"criterion_hi":"नया फोल्डर बनाने के सही चरण / शॉर्टकट","criterion_en":"Accurate steps/shortcut for creating a new folder"},{"step_no":2,"marks":1.25,"criterion_hi":"F2 या Right-Click से Rename विधि","criterion_en":"Rename steps using F2 or Right-Click"},{"step_no":3,"marks":1.25,"criterion_hi":"Cut (Ctrl+X) व Paste (Ctrl+V) से फाइल मूव करना","criterion_en":"Moving file cleanly via Cut and Paste"},{"step_no":4,"marks":1.25,"criterion_hi":"Recycle Bin से Restore व Shift+Delete चेतावनी","criterion_en":"Recycle Bin Restore steps plus Shift+Delete caution"}]$json$::jsonb,
    NULL, true
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
-- CHAPTER 3 OF 6: SKILL-ICT-CH3 — MICROSOFT WORD PRACTICAL MASTERY
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-ict-ch3',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: एमएस वर्ड (टाइपिंग, फॉर्मेटिंग और आवेदन पत्र)",
  "title_en": "30-Second Mindmap: Microsoft Word Practical Mastery",
  "read_time_seconds": 30,
  "central_node": {
    "id": "ict3-root",
    "label_hi": "माइक्रोसॉफ्ट वर्ड (MS Word · .docx)",
    "label_en": "Microsoft Word (.docx)",
    "subtitle_hi": "आवेदन पत्र, नोट्स, टाइम-टेबल और बायोडाटा बनाने का डिजिटल उपकरण",
    "subtitle_en": "Digital word processor for letters, notes, timetables & resumes"
  },
  "branches": [
    {
      "id": "ict3-b1",
      "label_hi": "1. रिबन और मुख्य टैब (Ribbon Tabs)",
      "label_en": "1. Ribbon & Main Tabs",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "ict3-b1-1",
          "label_hi": "Home: फॉन्ट, रंग, Bold/Italic, संरेखण",
          "label_en": "Home: Font, Size, B/I/U, Alignment"
        },
        {
          "id": "ict3-b1-2",
          "label_hi": "Insert: टेबल, चित्र, पेज नंबर, हेडर",
          "label_en": "Insert: Tables, Pictures, Page Numbers"
        },
        {
          "id": "ict3-b1-3",
          "label_hi": "Layout: A4 साइज, मार्जिन, Portrait/Landscape",
          "label_en": "Layout: A4 Size, Margins, Orientation"
        }
      ]
    },
    {
      "id": "ict3-b2",
      "label_hi": "2. टेक्स्ट फॉर्मेटिंग शॉर्टकट",
      "label_en": "2. Formatting Shortcuts",
      "color": "#059669",
      "children": [
        {
          "id": "ict3-b2-1",
          "label_hi": "Ctrl+B (Bold), Ctrl+I (Italic), Ctrl+U (Underline)",
          "label_en": "Ctrl+B (Bold), Ctrl+I (Italic), Ctrl+U (Underline)"
        },
        {
          "id": "ict3-b2-2",
          "label_hi": "Ctrl+L (बाएँ), Ctrl+E (बीच), Ctrl+R (दाएँ), Ctrl+J (Justify)",
          "label_en": "Ctrl+L (Left), Ctrl+E (Center), Ctrl+R (Right), Ctrl+J (Justify)"
        }
      ]
    },
    {
      "id": "ict3-b3",
      "label_hi": "3. स्मार्ट लेखन व जाँच",
      "label_en": "3. Smart Editing & Proofing",
      "color": "#D97706",
      "children": [
        {
          "id": "ict3-b3-1",
          "label_hi": "लाल लहरदार रेखा = Spelling त्रुटि",
          "label_en": "Red wavy line = Spelling error"
        },
        {
          "id": "ict3-b3-2",
          "label_hi": "नीली रेखा = Grammar / व्याकरण त्रुटि",
          "label_en": "Blue line = Grammar / spacing error"
        },
        {
          "id": "ict3-b3-3",
          "label_hi": "F7 = Spell Check · Ctrl+F = Find",
          "label_en": "F7 = Spell Check · Ctrl+F = Find"
        }
      ]
    },
    {
      "id": "ict3-b4",
      "label_hi": "4. सहेजना (Save), PDF और प्रिंट",
      "label_en": "4. Save, Export PDF & Print",
      "color": "#7C3AED",
      "children": [
        {
          "id": "ict3-b4-1",
          "label_hi": "Ctrl+S (Save) · F12 (Save As / PDF)",
          "label_en": "Ctrl+S (Save) · F12 (Save As / PDF)"
        },
        {
          "id": "ict3-b4-2",
          "label_hi": "Ctrl+P (Print Preview व प्रिंट)",
          "label_en": "Ctrl+P (Print Preview & Print)"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "ict3-sec-1-ribbon",
    "order": 1,
    "heading_hi": "1. एमएस वर्ड की स्क्रीन और रिबन (Ribbon) — 3 सेकंड में कोई भी टूल खोजें",
    "heading_en": "1. MS Word Window & Ribbon Tour — Find Any Tool in 3 Seconds",
    "analogy_hi": "MS Word एक **जादुई डिजिटल कॉपी** है — इसमें गलत लिखने पर पन्ना फाड़ना नहीं पड़ता! स्क्रीन के सबसे ऊपर बना **रिबन (Ribbon)** आपके **ज्योमेट्री बॉक्स** जैसा है जिसमें अलग-अलग खाने (Tabs) हैं: **Home** (लिखने की शैली — पेन, मोटा-पतला, रंग), **Insert** (टेबल, फोटो, पेज नंबर जोड़ना), और **Layout** (पन्ने का आकार A4 व हाशिया/Margin तय करना)!",
    "analogy_en": "MS Word is a **magic digital notebook** where mistakes never ruin a page! The **Ribbon** at the top works like a neat **geometry box** divided into tabs: **Home** (writing style — font, Bold, color, alignment), **Insert** (adding tables, pictures, page numbers), and **Layout** (setting A4 paper size and margins)!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "माइक्रोसॉफ्ट वर्ड विंडो और Home रिबन की संरचना",
      "title_en": "Anatomy of the Microsoft Word Window & Home Ribbon",
      "caption_hi": "शीर्ष पर Title Bar फाइल का नाम दिखाता है, उसके नीचे Ribbon Tabs हैं, बीच में सफेद पेज पर Cursor टिमटिमाता है और नीचे Status Bar कुल शब्द व पेज गिनता है।",
      "caption_en": "Title Bar shows the filename at top, Ribbon Tabs hold formatting tools below it, the Cursor blinks on the white page, and the Status Bar counts pages and words at bottom.",
      "viewBox": "0 0 660 280",
      "elements": [
        {
          "kind": "rect",
          "x": 18,
          "y": 14,
          "width": 624,
          "height": 252,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 18,
          "y": 14,
          "width": 624,
          "height": 34,
          "rx": 8,
          "fill": "#1E3A8A",
          "stroke": "#1E3A8A",
          "strokeWidth": 1
        },
        {
          "kind": "label",
          "x": 330,
          "y": 34,
          "text_hi": "शीर्षक पट्टी (Title Bar): Leave_Application.docx — Word",
          "text_en": "Title Bar: Leave_Application.docx — Word",
          "fill": "#FFFFFF",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 26,
          "y": 54,
          "width": 608,
          "height": 24,
          "rx": 4,
          "fill": "#EFF6FF",
          "stroke": "#93C5FD",
          "strokeWidth": 1.2
        },
        {
          "kind": "label",
          "x": 185,
          "y": 70,
          "text_hi": "टैब: File  |  [Home]  |  Insert  |  Layout  |  Review",
          "text_en": "Tabs: File  |  [Home]  |  Insert  |  Layout  |  Review",
          "fill": "#1E3A8A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 26,
          "y": 84,
          "width": 190,
          "height": 56,
          "rx": 6,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.6
        },
        {
          "kind": "label",
          "x": 121,
          "y": 104,
          "text_hi": "फॉन्ट समूह (Font Group)",
          "text_en": "Font Group (B, I, U, Size)",
          "fill": "#92400E",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 226,
          "y": 84,
          "width": 204,
          "height": 56,
          "rx": 6,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.6
        },
        {
          "kind": "label",
          "x": 328,
          "y": 104,
          "text_hi": "पैराग्राफ (Alignment & List)",
          "text_en": "Paragraph (Align & Bullets)",
          "fill": "#065F46",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 440,
          "y": 84,
          "width": 194,
          "height": 56,
          "rx": 6,
          "fill": "#F5F3FF",
          "stroke": "#7C3AED",
          "strokeWidth": 1.6
        },
        {
          "kind": "label",
          "x": 537,
          "y": 104,
          "text_hi": "संपादन (Find / Replace)",
          "text_en": "Editing (Find & Replace)",
          "fill": "#5B21B6",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 110,
          "y": 150,
          "width": 440,
          "height": 82,
          "rx": 4,
          "fill": "#FFFFFF",
          "stroke": "#94A3B8",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 330,
          "y": 182,
          "text_hi": "सफेद दस्तावेज़ पृष्ठ (Document Page) — कर्सर यहाँ टाइप करता है |",
          "text_en": "Document Page Area — Blinking Cursor types here |",
          "fill": "#0F172A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 18,
          "y": 240,
          "width": 624,
          "height": 26,
          "rx": 4,
          "fill": "#E2E8F0",
          "stroke": "#94A3B8",
          "strokeWidth": 1
        },
        {
          "kind": "label",
          "x": 330,
          "y": 256,
          "text_hi": "स्टेटस बार (Status Bar): Page 1 of 1   |   Words: 85   |   Zoom 100%",
          "text_en": "Status Bar: Page 1 of 1   |   Words: 85   |   Zoom 100%",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### एमएस वर्ड शुरू करने का आसान नियम: \"पहले Select, फिर Format!\"\n- बहुत-से नए छात्र `Bold` या `Font Size` दबाते हैं और सोचते हैं पुराना लिखा शब्द क्यों नहीं बदला? याद रखें: **जिस शब्द का रंग, आकार या शैली बदलनी हो, पहले उसे माउस से खींचकर Select (हाइलाइट) करें**, फिर बटन या शॉर्टकट दबाएँ!\n- **फ़ाइल एक्सटेंशन:** MS Word की फाइल हमेशा **`.docx`** के रूप में सहेजी जाती है।\n- **4 प्रमुख टैब:** **Home** (सबसे ज़्यादा इस्तेमाल), **Insert** (टेबल, चित्र, हेडर/फ़ुटर), **Layout** (A4 पेज, मार्जिन), और **Review** (वर्तनी और व्याकरण जाँच)।",
    "concept_md_en": "### The #1 Golden Rule of MS Word: \"Select First, Format Next!\"\n- Many beginners click `Bold` or `Font Size` and wonder why their typed heading didn't change. Always **drag-select (highlight) the text FIRST**, then click the Ribbon button or press the shortcut!\n- **File Extension:** Standard MS Word files save as **`.docx`**.\n- **4 Key Tabs:** **Home** (daily formatting), **Insert** (tables, pictures, headers/footers), **Layout** (A4 paper, margins), and **Review** (spell & grammar check).",
    "exam_tip_hi": "वाइवा व बोर्ड सवाल: \"MS Word में कुल कितने शब्द टाइप हुए हैं, यह स्क्रीन के किस भाग में दिखता है?\" उत्तर: नीचे की **स्टेटस बार (Status Bar)** में!",
    "exam_tip_en": "Viva & Exam Question: \"Which bar in MS Word shows total Page Count and Word Count?\" Answer: The **Status Bar** at the very bottom!",
    "glossary_terms": [
      {
        "term_hi": "रिबन (Ribbon)",
        "term_en": "Ribbon",
        "pronunciation_hi": "रिबन",
        "definition_hi": "MS Office के ऊपर बनी टूल-पट्टी जिसमें Home, Insert, Layout जैसे टैब और सभी बटन व्यवस्थित रहते हैं।",
        "definition_en": "The top command strip in MS Office organizing tools into tabs like Home, Insert, and Layout."
      },
      {
        "term_hi": "फॉर्मेटिंग (Formatting)",
        "term_en": "Formatting",
        "pronunciation_hi": "फॉर्मेटिंग",
        "definition_hi": "टेक्स्ट को साफ, सुंदर और पठनीय बनाने के लिए फॉन्ट, आकार, रंग, Bold/Italic व संरेखण बदलना।",
        "definition_en": "Changing font, size, color, Bold/Italic, and alignment to make a document clean and readable."
      }
    ],
    "quick_check": {
      "q_hi": "यदि आपको अपने वर्ड दस्तावेज़ में एक 4×5 का स्कूल टाइम-टेबल जोड़ना है, तो आप किस टैब पर क्लिक करेंगे — Home या Insert?",
      "q_en": "To add a 4×5 class timetable into your Word document, which tab do you click — Home or Insert?",
      "answer_hi": "**Insert** टैब → **Table** विकल्प।",
      "answer_en": "The **Insert** tab → **Table**."
    }
  },
  {
    "id": "ict3-sec-2-formatting-shortcuts",
    "order": 2,
    "heading_hi": "2. टेक्स्ट फॉर्मेटिंग, संरेखण (Alignment) और टॉप 10 वर्ड शॉर्टकट",
    "heading_en": "2. Text Formatting, Alignment & Top 10 MS Word Shortcuts",
    "analogy_hi": "अच्छी फॉर्मेटिंग बिल्कुल साफ **स्कूल यूनिफ़ॉर्म** पहनने जैसी है! **Bold (`Ctrl+B`)** शीर्षक को गाढ़ा चमकाता है; **Underline (`Ctrl+U`)** विषय (Subject) के नीचे रेखा खींचता है; **Center Align (`Ctrl+E`)** स्कूल का नाम पन्ने के ठीक बीचों-बीच रखता है; और **Justify (`Ctrl+J`)** दोनों किनारों को अख़बार के कॉलम जैसा बिल्कुल सीधा कर देता है!",
    "analogy_en": "Good formatting is like wearing a crisp **school uniform**! **Bold (`Ctrl+B`)** makes headings stand out; **Underline (`Ctrl+U`)** draws attention to the Subject line; **Center Align (`Ctrl+E`)** places your school name right in the middle; and **Justify (`Ctrl+J`)** aligns both left and right edges neatly like a printed newspaper!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "एमएस वर्ड के 10 सबसे ज़रूरी शॉर्टकट (प्रैक्टिकल + बोर्ड परीक्षा के लिए पक्का)",
      "title_en": "Top 10 Must-Know MS Word Shortcuts (Lab Practical + Exam Gold)",
      "caption_hi": "ध्यान दें: Center Align का शॉर्टकट Ctrl + E है (Ctrl + C नहीं — क्योंकि Ctrl + C तो Copy के लिए आरक्षित है)!",
      "caption_en": "Watch out: Center Align is Ctrl + E (NOT Ctrl + C, because Ctrl + C is reserved for Copy)!",
      "headers_hi": [
        "शॉर्टकट",
        "कार्य (Action)",
        "कब उपयोग करें?"
      ],
      "headers_en": [
        "Shortcut",
        "Action",
        "When to Use"
      ],
      "rows": [
        {
          "cells_hi": [
            "Ctrl + B",
            "बोल्ड (Bold — गहरा/मोटा)",
            "शीर्षक और \"Subject:\" लाइन को उभारने के लिए"
          ],
          "cells_en": [
            "Ctrl + B",
            "Bold (Thick/Dark)",
            "Highlighting headings & Subject line"
          ]
        },
        {
          "cells_hi": [
            "Ctrl + I",
            "इटैलिक (Italic — तिरछा)",
            "किताब का नाम या उद्धरण (Quote) लिखने के लिए"
          ],
          "cells_en": [
            "Ctrl + I",
            "Italic (Slanted)",
            "Book titles or quotes"
          ]
        },
        {
          "cells_hi": [
            "Ctrl + U",
            "अंडरलाइन (Underline)",
            "आवेदन के मुख्य विषय के नीचे रेखा खींचने के लिए"
          ],
          "cells_en": [
            "Ctrl + U",
            "Underline",
            "Underlining Subject or headings"
          ]
        },
        {
          "cells_hi": [
            "Ctrl + L / Ctrl + R",
            "बायाँ (Left) / दायाँ (Right) संरेखण",
            "पता बाईं ओर व तारीख/हस्ताक्षर दाईं ओर रखने के लिए"
          ],
          "cells_en": [
            "Ctrl + L / Ctrl + R",
            "Left / Right Align",
            "Address on left, Date/Signature on right"
          ]
        },
        {
          "cells_hi": [
            "Ctrl + E",
            "सेंटर संरेखण (Center Align)",
            "विद्यालय का नाम या निबंध शीर्षक बीच में लाने के लिए"
          ],
          "cells_en": [
            "Ctrl + E",
            "Center Align",
            "Centering School Name or Essay Title"
          ]
        },
        {
          "cells_hi": [
            "Ctrl + J",
            "जस्टिफ़ाई (Justify)",
            "आवेदन के मुख्य पैराग्राफ को दोनों ओर से सीधा रखने के लिए"
          ],
          "cells_en": [
            "Ctrl + J",
            "Justify Align",
            "Making body paragraphs neat on both edges"
          ]
        },
        {
          "cells_hi": [
            "Ctrl + S / Ctrl + P",
            "सेव (Save) / प्रिंट (Print)",
            "काम सुरक्षित करने और प्रिंट निकालने के लिए"
          ],
          "cells_en": [
            "Ctrl + S / Ctrl + P",
            "Save / Print",
            "Saving progress & printing on paper"
          ]
        },
        {
          "cells_hi": [
            "Ctrl + A / Ctrl + F",
            "सब चुनें (Select All) / खोजें (Find)",
            "पूरे पेज का फॉन्ट एक साथ बदलने या शब्द खोजने के लिए"
          ],
          "cells_en": [
            "Ctrl + A / Ctrl + F",
            "Select All / Find",
            "Selecting whole doc or searching a word"
          ]
        }
      ]
    },
    "concept_md_hi": "### फॉन्ट आकार और वर्तनी-व्याकरण जाँच (Red vs Blue Wavy Lines)\n- **आदर्श आकार:** मुख्य टेक्स्ट के लिए **12 pt** (या 11 pt) और शीर्षक के लिए **14–16 pt Bold** चुनें। अंग्रेज़ी में `Calibri` या `Times New Roman` और हिंदी में `Mangal` या `Kokila` साफ दिखते हैं।\n- **लाल लहरदार रेखा (Red Wavy Line):** अंग्रेज़ी शब्द की **वर्तनी (Spelling) गलत** है (जैसे `Scol` की जगह `School`)। उस पर **Right Click** करें और सही शब्द चुन लें!\n- **नीली लहरदार रेखा (Blue Wavy Line):** **व्याकरण (Grammar)** या अतिरिक्त स्पेस की त्रुटि है।\n- **`F7` कुंजी:** पूरे दस्तावेज़ में एक साथ Spelling & Grammar जाँचती है!",
    "concept_md_en": "### Clean Font Sizes & Spell-Check Lines (Red vs Blue)\n- **Ideal Sizes:** Use **11–12 pt** for normal paragraphs and **14–16 pt Bold** for titles (`Calibri` or `Times New Roman` for English; `Mangal` for Hindi).\n- **Red Wavy Underline:** Flags a **Spelling mistake** (e.g., `Scol` instead of `School`). Just **Right-Click** it to pick the correct spelling!\n- **Blue Wavy Underline:** Flags a **Grammar** or spacing error.\n- **`F7` Key:** Launches full Spelling & Grammar check across the whole document!",
    "exam_tip_hi": "सुपर-हॉट BSEB ट्रिक प्रश्न: \"MS Word में Center Align का शॉर्टकट क्या है?\" अधिकतर छात्र गलती से `Ctrl + C` लगा देते हैं — सही उत्तर है **`Ctrl + E`** (C = Copy, E = cEnter)!",
    "exam_tip_en": "Classic trick question: \"What is the shortcut for Center Align in MS Word?\" Never pick `Ctrl + C` (that is Copy!) — the exact answer is **`Ctrl + E`**!",
    "glossary_terms": [
      {
        "term_hi": "संरेखण (Alignment)",
        "term_en": "Text Alignment",
        "pronunciation_hi": "अलाइनमेंट",
        "definition_hi": "पन्ने के हाशिए के अनुसार टेक्स्ट को बाएँ (Left), बीच (Center), दाएँ (Right) या दोनों ओर बराबर (Justify) सजाना।",
        "definition_en": "Positioning text neatly along the page margins: Left, Center, Right, or Justify."
      },
      {
        "term_hi": "जस्टिफ़ाई (Justify)",
        "term_en": "Justify Alignment (Ctrl+J)",
        "pronunciation_hi": "जस्टिफ़ाई",
        "definition_hi": "पैराग्राफ के बाएँ और दाएँ दोनों किनारों को एकदम सीधी रेखा में बराबर करना।",
        "definition_en": "Spreads text cleanly so both left and right margins look straight like a printed book."
      }
    ],
    "quick_check": {
      "q_hi": "MS Word में किसी शब्द के नीचे लाल लहरदार रेखा (Red Wavy Line) दिखने का क्या अर्थ है?",
      "q_en": "What does a red wavy underline beneath a word in MS Word mean?",
      "answer_hi": "उस शब्द की **वर्तनी (Spelling) में त्रुटि** है (Right Click कर सुधार सकते हैं)।",
      "answer_en": "It flags a **spelling mistake** (Right-Click the word to fix it instantly)."
    }
  },
  {
    "id": "ict3-sec-3-tables-pdf",
    "order": 3,
    "heading_hi": "3. टेबल, बुलेट सूची, पेज सेटअप (A4) और Save बनाम Save As (PDF)",
    "heading_en": "3. Tables, Bullet Lists, A4 Page Setup & Save vs Save As (PDF)",
    "analogy_hi": "जब आप Word फाइल (`.docx`) को **PDF में Export/Save** करते हैं, तो यह बिल्कुल अपनी मार्कशीट को **लेमिनेट (Laminate)** कराने जैसा है! `.docx` फाइल किसी दूसरे कंप्यूटर या साइबर कैफे में खोलने पर फॉन्ट बदलकर टेढ़ी हो सकती है, लेकिन **PDF** हर मोबाइल और कंप्यूटर पर ठीक वैसी ही सुंदर दिखती है जैसी आपने बनाई थी!",
    "analogy_en": "Exporting a Word file (`.docx`) to **PDF** is just like **laminating** your printed marksheet! A `.docx` file can shift lines if opened on a cyber cafe PC with missing fonts, whereas a **PDF** stays 100% locked and clean on every phone and printer!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "प्रोफेशनल दस्तावेज़ बनाने से लेकर प्रिंट/PDF तक के 5 सरल चरण",
      "title_en": "5 Easy Steps from Blank Page to Print-Ready PDF",
      "caption_hi": "Print निकालने से पहले हमेशा Print Preview (Ctrl + P) देखें ताकि कोई लाइन दूसरे पेज पर न कट रही हो!",
      "caption_en": "Always inspect Print Preview (Ctrl + P) before printing so no line spills awkwardly onto page 2!",
      "direction": "TB",
      "steps": [
        {
          "id": "w1",
          "label_hi": "1. पेज सेटअप चुनें (Layout टैब)",
          "label_en": "1. Set Up Page (Layout Tab)",
          "detail_hi": "Size = A4 · Orientation = Portrait (खड़ा पेज) · Margins = Normal (1 inch)।",
          "detail_en": "Size = A4 · Orientation = Portrait · Margins = Normal (1 inch).",
          "accent": "indigo"
        },
        {
          "id": "w2",
          "label_hi": "2. टाइप करें और फॉर्मेट सजाएँ (Home टैब)",
          "label_en": "2. Type & Format Cleanly (Home Tab)",
          "detail_hi": "शीर्षक बड़ा व Bold, मुख्य पैराग्राफ Justify (Ctrl+J) और बिंदुओं के लिए Bullets/Numbering।",
          "detail_en": "Bold heading, Justified body (Ctrl+J), and Bullets/Numbering for lists.",
          "accent": "amber"
        },
        {
          "id": "w3",
          "label_hi": "3. टेबल व हेडर/पेज नंबर जोड़ें (Insert टैब)",
          "label_en": "3. Insert Tables / Page Numbers (Insert Tab)",
          "detail_hi": "टाइम-टेबल के लिए Insert → Table; कई पेज हों तो Page Number जोड़ें।",
          "detail_en": "Use Insert → Table for schedules, and Page Numbers for multi-page reports.",
          "accent": "emerald"
        },
        {
          "id": "w4",
          "label_hi": "4. वर्तनी जाँचें (F7) और Print Preview देखें (Ctrl+P)",
          "label_en": "4. Proofread (F7) & Check Print Preview (Ctrl+P)",
          "detail_hi": "सारी लाल/नीली रेखाएँ ठीक करें और देखें कि पूरा पत्र 1 पेज में आ रहा है।",
          "detail_en": "Fix red/blue lines and confirm the entire letter fits neatly on 1 page.",
          "accent": "indigo"
        },
        {
          "id": "w5",
          "label_hi": "5. Save (.docx) और Save As PDF (.pdf)",
          "label_en": "5. Save (.docx) & Export as PDF (.pdf)",
          "detail_hi": "एडिट करने के लिए .docx सेव रखें और शेयर/प्रिंट के लिए .pdf बनाएँ!",
          "detail_en": "Keep .docx for future edits and export .pdf for sharing or printing!",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "w1",
          "to": "w2"
        },
        {
          "from": "w2",
          "to": "w3"
        },
        {
          "from": "w3",
          "to": "w4"
        },
        {
          "from": "w4",
          "to": "w5"
        }
      ]
    },
    "concept_md_hi": "### `Save` बनाम `Save As` और पेज ओरिएंटेशन (Portrait vs Landscape)\n- **`Save` (`Ctrl + S`):** पहली बार नाम व स्थान पूछता है; उसके बाद हर बार दबाने पर उसी पुरानी फाइल में नए बदलाव सहेजता जाता है।\n- **`Save As` (`F12`):** उसी दस्तावेज़ की **नए नाम**, **नए फोल्डर** या **नए फॉर्मेट (जैसे PDF)** में दूसरी प्रति बनाने के लिए!\n- **Portrait बनाम Landscape:**\n  - **Portrait (खड़ा पेज):** आवेदन पत्र, निबंध, बायोडाटा (अधिकतर कामों में)।\n  - **Landscape (लेटा/चौड़ा पेज):** चौड़े टाइम-टेबल, प्रमाण-पत्र (Certificate) और बड़ी तालिकाओं के लिए।\n- **Bullets बनाम Numbering:** बिना क्रम वाली सूची (जैसे शौक/सामग्री) के लिए **Bullets (•)**; क्रमबद्ध चरणों (1, 2, 3) के लिए **Numbering** चुनें!",
    "concept_md_en": "### `Save` vs `Save As` & Page Orientation (Portrait vs Landscape)\n- **`Save` (`Ctrl + S`):** Updates and saves your changes into the existing file.\n- **`Save As` (`F12`):** Creates a fresh copy with a **new filename**, **new folder**, or **different format (like PDF)**.\n- **Portrait vs Landscape:**\n  - **Portrait (Tall/Vertical):** Letters, applications, essays, bio-data.\n  - **Landscape (Wide/Horizontal):** Wide timetables, certificates, and large tables.\n- **Bullets vs Numbering:** Use **Bullets (•)** for unordered lists; use **Numbering (1, 2, 3)** when step order matters!",
    "exam_tip_hi": "याद रखें: भारत के विद्यालयों और सरकारी दफ़्तरों में प्रिंटिंग के लिए मानक कागज़ आकार **`A4`** होता है (डिफ़ॉल्ट अमेरिका का `Letter` बदलकर `A4` चुनना स्मार्ट आदत है)!",
    "exam_tip_en": "Practical exam tip: Indian schools and government offices print on **`A4`** paper — always switch from default US `Letter` to `A4` under Layout → Size!",
    "glossary_terms": [
      {
        "term_hi": "पेज ओरिएंटेशन (Page Orientation)",
        "term_en": "Page Orientation (Portrait / Landscape)",
        "pronunciation_hi": "पेज ओरिएंटेशन",
        "definition_hi": "कागज़ को खड़ा (Portrait) या आड़ा/चौड़ा (Landscape) रखकर टाइप और प्रिंट करने की सेटिंग।",
        "definition_en": "Setting the page layout to tall vertical (Portrait) or wide horizontal (Landscape)."
      },
      {
        "term_hi": "हेडर और फ़ुटर (Header & Footer)",
        "term_en": "Header & Footer",
        "pronunciation_hi": "हेडर एंड फ़ुटर",
        "definition_hi": "हर पन्ने के सबसे ऊपर (Header — जैसे स्कूल का नाम) और सबसे नीचे (Footer — जैसे पेज नंबर) अपने आप दिखने वाला क्षेत्र।",
        "definition_en": "Top (Header) and bottom (Footer) page bands that automatically repeat on every page (e.g., school name & page number)."
      }
    ],
    "quick_check": {
      "q_hi": "यदि आप अपनी बनी हुई `Application.docx` फाइल को बिना बदले एक अलग नाम से PDF में सेव करना चाहते हैं, तो क्या चुनेंगे — Save या Save As?",
      "q_en": "To keep `Application.docx` unchanged while saving a separate PDF copy, which option do you use — Save or Save As?",
      "answer_hi": "**Save As (`F12`)** → Save as type में **PDF** चुनें।",
      "answer_en": "**Save As (`F12`)** → choose **PDF** as the file type."
    }
  },
  {
    "id": "ict3-sec-4-application-project",
    "order": 4,
    "heading_hi": "4. वास्तविक प्रोजेक्ट: प्रधानाध्यापक को आवेदन पत्र (MS Word लेआउट)",
    "heading_en": "4. Real-Life Project: Formatting a Principal Application in MS Word",
    "analogy_hi": "साइबर कैफे में एक छोटा-सा आवेदन पत्र या बायोडाटा टाइप कराने में ₹30–₹50 खर्च होते हैं! नीचे दिया गया **1-पेज वर्ड लेआउट** सीखकर आप अपने स्कूल, छात्रवृत्ति, बैंक या परिवार के लिए 5 मिनट में एकदम प्रोफेशनल दस्तावेज़ खुद बना सकते हैं!",
    "analogy_en": "Typing a single application or bio-data at a cyber cafe costs ₹30–₹50! Master the **1-page Word layout** below and you can type and format official school, scholarship, or family letters yourself in 5 minutes!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "MS Word में आदर्श आवेदन पत्र का फॉर्मेटिंग नक्शा",
      "title_en": "Formatting Blueprint of an Official Application in MS Word",
      "caption_hi": "हर भाग में सही Alignment और Formatting देखें: शीर्षक Center + Bold, Subject Bold + Underline, मुख्य अनुच्छेद Justify, और हस्ताक्षर Right Align!",
      "caption_en": "Observe exact Word styling on each part: Title Center + Bold, Subject Bold + Underline, Body Justified, and Signature Right-Aligned!",
      "viewBox": "0 0 640 285",
      "elements": [
        {
          "kind": "rect",
          "x": 35,
          "y": 14,
          "width": 340,
          "height": 256,
          "rx": 6,
          "fill": "#FFFFFF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 52,
          "y": 26,
          "width": 306,
          "height": 232,
          "rx": 2,
          "fill": "none",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.2
        },
        {
          "kind": "label",
          "x": 205,
          "y": 46,
          "text_hi": "आवेदन पत्र (APPLICATION)",
          "text_en": "APPLICATION FOR LEAVE",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 64,
          "y": 82,
          "text_hi": "सेवा में, प्रधानाध्यापक महोदय...",
          "text_en": "To, The Principal, Govt. High School...",
          "fill": "#0F172A",
          "fontSize": 10,
          "anchor": "start"
        },
        {
          "kind": "label",
          "x": 64,
          "y": 118,
          "text_hi": "विषय: दो दिन के अवकाश हेतु।",
          "text_en": "Subject: Application for 2 days sick leave.",
          "fill": "#92400E",
          "fontSize": 10,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "line",
          "x1": 64,
          "y1": 122,
          "x2": 260,
          "y2": 122,
          "stroke": "#92400E",
          "strokeWidth": 1.5
        },
        {
          "kind": "rect",
          "x": 64,
          "y": 144,
          "width": 282,
          "height": 48,
          "rx": 4,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.4
        },
        {
          "kind": "label",
          "x": 205,
          "y": 164,
          "text_hi": "मुख्य अनुच्छेद (Justify: Ctrl + J)",
          "text_en": "Main Body Paragraph (Justify: Ctrl + J)",
          "fill": "#065F46",
          "fontSize": 10,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 342,
          "y": 218,
          "text_hi": "आपका आज्ञाकारी छात्र",
          "text_en": "Yours obediently,",
          "fill": "#5B21B6",
          "fontSize": 10,
          "anchor": "end",
          "bold": true
        },
        {
          "kind": "label",
          "x": 342,
          "y": 244,
          "text_hi": "नाम, कक्षा, रोल नं.",
          "text_en": "Name, Class, Roll No.",
          "fill": "#334155",
          "fontSize": 10,
          "anchor": "end"
        },
        {
          "kind": "arrow",
          "x1": 385,
          "y1": 48,
          "x2": 295,
          "y2": 48,
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 392,
          "y": 46,
          "text_hi": "Center + Bold (Ctrl+E, B)",
          "text_en": "Center + Bold (Ctrl+E, B)",
          "fill": "#1E3A8A",
          "fontSize": 11,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 385,
          "y1": 118,
          "x2": 270,
          "y2": 118,
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 392,
          "y": 116,
          "text_hi": "Bold + Underline (Ctrl+B, U)",
          "text_en": "Bold + Underline (Ctrl+B, U)",
          "fill": "#92400E",
          "fontSize": 11,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 385,
          "y1": 168,
          "x2": 350,
          "y2": 168,
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 392,
          "y": 166,
          "text_hi": "दोनों किनारे सीधे (Ctrl+J)",
          "text_en": "Justify Body (Ctrl+J)",
          "fill": "#065F46",
          "fontSize": 11,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 385,
          "y1": 224,
          "x2": 350,
          "y2": 224,
          "stroke": "#7C3AED",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 392,
          "y": 222,
          "text_hi": "दायाँ संरेखण (Ctrl+R)",
          "text_en": "Right Align (Ctrl+R)",
          "fill": "#5B21B6",
          "fontSize": 11,
          "anchor": "start",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### 5 मिनट में साफ आवेदन पत्र टाइप करने की चेकलिस्ट\n1. **Layout → Size → A4** चुनें और **Line Spacing = 1.15** रखें ताकि पूरा पत्र 1 पन्ने पर सुंदर दिखे।\n2. **\"सेवा में / To\"** को **Left Align (`Ctrl + L`)** पर रखें।\n3. **\"विषय / Subject\"** लाइन को चुनकर **`Ctrl + B`** (Bold) और **`Ctrl + U`** (Underline) करें।\n4. मुख्य पैराग्राफ को **`Ctrl + J`** (Justify) करें और बीच में `Tab` या 1 खाली लाइन (`Enter`) से पैराग्राफ अलग करें।\n5. अंत में **\"आपका आज्ञाकारी छात्र / Yours obediently\"** को **`Ctrl + R`** से दाईं ओर ले जाएँ और **`Ctrl + S`** से `RollNo_Application.docx` के नाम से सहेजें!",
    "concept_md_en": "### 5-Minute Clean Principal Application Checklist\n1. Set **Layout → Size → A4** and **Line Spacing = 1.15** so it fits cleanly on 1 page.\n2. Keep **\"To, The Principal\"** on **Left Align (`Ctrl + L`)**.\n3. Select the **\"Subject:\"** line and press **`Ctrl + B`** (Bold) + **`Ctrl + U`** (Underline).\n4. Format the main body paragraph with **`Ctrl + J`** (Justify).\n5. Move **\"Yours obediently, Name, Class, Roll No.\"** cleanly to the right with **`Ctrl + R`** and save via **`Ctrl + S`** as `RollNo_Application.docx`!",
    "exam_tip_hi": "प्रैक्टिकल लैब परीक्षा में हमेशा `Ctrl + S` हर 2 मिनट बाद दबाने की आदत डालें — इससे बिजली कटने पर भी आपका टाइप किया आवेदन सुरक्षित रहेगा!",
    "exam_tip_en": "Develop the habit of pressing `Ctrl + S` every 2 minutes during lab exams — your typed letter stays safe even if power flickers!",
    "glossary_terms": [
      {
        "term_hi": "मार्जिन (Margin)",
        "term_en": "Page Margin",
        "pronunciation_hi": "मार्जिन",
        "definition_hi": "पन्ने के चारों किनारों (ऊपर, नीचे, बाएँ, दाएँ) पर छोड़ी गई सफेद खाली जगह ताकि प्रिंट व बाइंडिंग साफ रहे।",
        "definition_en": "Blank white border left around all four edges of a page for neat printing and binding."
      },
      {
        "term_hi": "लाइन स्पेसिंग (Line Spacing)",
        "term_en": "Line Spacing",
        "pronunciation_hi": "लाइन स्पेसिंग",
        "definition_hi": "एक पैराग्राफ की दो पंक्तियों के बीच की ऊर्ध्वाधर दूरी (मानक 1.15 या 1.5)।",
        "definition_en": "The vertical gap between consecutive lines in a paragraph (typically 1.15 or 1.5)."
      }
    ],
    "quick_check": {
      "q_hi": "आवेदन पत्र के मुख्य पैराग्राफ के दोनों किनारे (बायाँ व दायाँ) बराबर सीधे करने के लिए कौन-सा शॉर्टकट दबाते हैं?",
      "q_en": "Which shortcut aligns BOTH left and right edges of an application body paragraph evenly?",
      "answer_hi": "**`Ctrl + J` (Justify)**।",
      "answer_en": "**`Ctrl + J` (Justify)**."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{Ctrl+B (Bold)},\\quad \\text{Ctrl+I (Italic)},\\quad \\text{Ctrl+U (Underline)}",
      "label_hi": "टेक्स्ट शैली (Font Style) शॉर्टकट",
      "label_en": "Text Font Style Shortcuts"
    },
    {
      "latex": "\\text{Ctrl+L (Left)},\\quad \\text{Ctrl+E (Center)},\\quad \\text{Ctrl+R (Right)},\\quad \\text{Ctrl+J (Justify)}",
      "label_hi": "चारों पैराग्राफ संरेखण (Alignment) शॉर्टकट",
      "label_en": "All 4 Paragraph Alignment Shortcuts"
    },
    {
      "latex": "\\text{Ctrl+S (Save)},\\quad \\text{F12 (Save As)},\\quad \\text{Ctrl+P (Print)},\\quad \\text{F7 (Spell Check)}",
      "label_hi": "फाइल सहेजना, प्रिंट व वर्तनी जाँच",
      "label_en": "Save, Save As, Print & Spell Check"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": ".docx",
      "fact_hi": "MS Word दस्तावेज़ का मानक एक्सटेंशन .docx होता है।",
      "fact_en": "Standard MS Word document extension is .docx."
    },
    {
      "tag": "Ctrl + E",
      "fact_hi": "Center Align का शॉर्टकट Ctrl + E है (Ctrl + C नहीं)।",
      "fact_en": "Center Align shortcut is Ctrl + E (not Ctrl + C)."
    },
    {
      "tag": "Red / Blue",
      "fact_hi": "लाल लहरदार रेखा = Spelling त्रुटि; नीली रेखा = Grammar त्रुटि।",
      "fact_en": "Red wavy line = Spelling error; Blue line = Grammar error."
    },
    {
      "tag": "Paper Size",
      "fact_hi": "भारत में प्रिंटिंग का मानक पेज आकार A4 (Portrait) होता है।",
      "fact_en": "Standard printing paper size in India is A4 (Portrait)."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "शब्दों को बीच (Center) में लाने के लिए बार-बार Spacebar दबाना!",
      "mistake_en": "Pressing the Spacebar 30 times to push a heading to the center!",
      "fix_hi": "कभी Spacebar से संरेखण न करें — हमेशा `Ctrl + E` (Center Align) या `Ctrl + R` (Right Align) का प्रयोग करें।",
      "fix_en": "Never spacebar-align text — always use `Ctrl + E` (Center) or `Ctrl + R` (Right) so it prints perfectly centered."
    },
    {
      "mistake_hi": "टेक्स्ट Select किए बिना Bold/Font Size दबाना और भ्रमित होना।",
      "mistake_en": "Clicking Bold or Font Size without highlighting the existing text first.",
      "fix_hi": "नियम याद रखें: पहले शब्द को माउस से Select करें, फिर Bold/Color/Size बदलें।",
      "fix_en": "Remember: Select First, Format Next!"
    },
    {
      "mistake_hi": "Center Align के MCQ में `Ctrl + C` चुन लेना।",
      "mistake_en": "Picking `Ctrl + C` for Center Align in exams.",
      "fix_hi": "`Ctrl + C` हमेशा Copy है; Center Align के लिए **`Ctrl + E`** याद रखें!",
      "fix_en": "`Ctrl + C` is always Copy; memorize **`Ctrl + E`** for cEnter!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "MS Word शॉर्टकट (Ctrl+B/I/U/E/J/S/P/F/A व F7)",
      "topic_en": "MS Word Shortcuts (Ctrl+B/I/U/E/J/S/P/F/A & F7)",
      "years": [
        "BSEB ICT Lab",
        "Objective"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "प्रधानाध्यापक को आवेदन पत्र टाइपिंग व फॉर्मेटिंग प्रैक्टिकल",
      "topic_en": "Principal Application Typing & Formatting Practical",
      "years": [
        "BSEB ICT Practical"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "Save बनाम Save As (PDF), Portrait बनाम Landscape, Red/Blue रेखाएँ",
      "topic_en": "Save vs Save As (PDF), Orientation & Proofing Lines",
      "years": [
        "BSEB ICT Viva"
      ],
      "expected_marks": 4
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 4,
  "analogy_count": 4,
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
  'skill-ict-ch3',
  3,
  'छात्र MS Word खोलकर रिबन के Home, Insert व Layout टैब का उपयोग कर सकेंगे, Bold/Italic/Underline व चारों Alignment शॉर्टकट (`Ctrl+L/E/R/J`) लगा सकेंगे, एक साफ A4 प्रधानाध्यापक आवेदन पत्र तथा 4×5 टाइम-टेबल बना सकेंगे और फाइल को `.docx` व `.pdf` दोनों में सेव कर सकेंगे।',
  'Students will navigate MS Word Ribbon tabs (Home, Insert, Layout), apply Bold/Italic/Underline and all 4 Alignments (`Ctrl+L/E/R/J`), create a print-ready A4 Principal Application and a 4×5 class timetable, and save both `.docx` and `.pdf` copies.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "MS Word रिबन दर्शन और 5-लाइन \"मेरा विद्यालय\" फॉर्मेटिंग अभ्यास",
    "phase_en": "MS Word Ribbon Tour & 5-Line \"My School\" Formatting Drill",
    "teacher_action_hi": "हर जोड़ी के कंप्यूटर पर MS Word खुलवाएँ। \"पहले Select, फिर Format\" नियम 3 बार बुलवाएँ। छात्रों से अपने विद्यालय पर 5 पंक्तियाँ टाइप कराएँ — शीर्षक को `Ctrl+E` (Center) + `Ctrl+B` (Bold) + 16 pt, और शरीर को 12 pt Justify (`Ctrl+J`) करवाएँ। बीच में 1 शब्द जानबूझकर गलत (`Scol`) लिखवाकर लाल रेखा पर Right Click कर सुधरवाएँ!",
    "teacher_action_en": "Open MS Word on every pair's PC. Chant the \"Select First, Format Next\" rule 3 times. Have pairs type 5 lines about their school — Title in `Ctrl+E` + `Ctrl+B` + 16 pt, body in 12 pt `Ctrl+J`. Deliberately type `Scol` to practice fixing Red Wavy Lines via Right-Click!",
    "student_check_hi": "कमज़ोर छात्र से पूछें: \"शीर्षक को बीच में लाने के लिए Spacebar दबाना सही है या `Ctrl + E`?\"",
    "student_check_en": "Ask a shy learner: \"To center a heading, should we hit Spacebar 25 times or press `Ctrl + E`?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "वास्तविक प्रैक्टिकल: प्रधानाध्यापक को अवकाश आवेदन पत्र + PDF सेव",
    "phase_en": "Hands-On Practical: Principal Sick-Leave Application + Save as PDF",
    "teacher_action_hi": "ब्लैकबोर्ड पर आवेदन का ढाँचा लिखें। पहले Layout → Size → A4 सेट करवाएँ। दोनों साथियों को आधा-आधा पत्र टाइप करने दें (10-10 मिनट की अदला-बदली), Subject को `Ctrl+B` + `Ctrl+U` और \"Yours obediently\" को `Ctrl+R` करवाएँ। अंत में `Ctrl+S` से `.docx` और `F12` (Save As) से `.pdf` दोनों सेव कराएँ!",
    "teacher_action_en": "Display the Application blueprint on the board. First set Layout → Size → A4. Have partners swap keyboard after 10 minutes so both type half, format Subject with `Ctrl+B` + `Ctrl+U` and signature with `Ctrl+R`, and save BOTH `.docx` (`Ctrl+S`) and `.pdf` (`F12`)!",
    "student_check_hi": "दो छात्रों से `Ctrl + P` खोलकर Print Preview में जाँच करवाएँ कि पूरा पत्र 1 पेज में आ रहा है या नहीं।",
    "student_check_en": "Ask two pairs to open Print Preview (`Ctrl + P`) and confirm their entire letter fits neatly on 1 page."
  },
  {
    "period_no": 3,
    "duration_mins": 40,
    "phase_hi": "Insert → Table से कक्षा टाइम-टेबल और बुलेट सूची निर्माण",
    "phase_en": "Insert → Table Class Timetable & Bullet List Practical",
    "teacher_action_hi": "Insert → Table से 5 कॉलम × 4 पंक्ति का स्कूल टाइम-टेबल बनवाएँ, पहली पंक्ति (Day, Period 1–4) को Bold व हल्का रंग (Shading) दें, और नीचे अपने 5 पसंदीदा विषयों की Bullet List बनवाएँ। अंतिम 8 मिनट में शॉर्टकट रैपिड फायर लें।",
    "teacher_action_en": "Guide pairs to create a 5-column × 4-row class timetable via Insert → Table, bold and shade the header row, and add a Bullet List of their 5 favourite subjects below. Close with an 8-minute Shortcut Rapid Fire.",
    "student_check_hi": "पूछें: \"चौड़े टाइम-टेबल के लिए Portrait बेहतर है या Landscape पेज ओरिएंटेशन?\"",
    "student_check_en": "Ask: \"For a wide timetable with many columns, is Portrait or Landscape orientation better?\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड वर्ड फॉर्मेटिंग चाबी (Word Shortcut Cheat Box)",
    "heading_en": "Blackboard MS Word Formatting Cheat Box",
    "points_hi": [
      "गोल्डन नियम: पहले टेक्स्ट Select करें → फिर Format दबाएँ!",
      "शैली: Ctrl+B (Bold) | Ctrl+I (Italic) | Ctrl+U (Underline)",
      "संरेखण: Ctrl+L (बाएँ) | Ctrl+E (बीच) | Ctrl+R (दाएँ) | Ctrl+J (दोनों किनारे सीधे)",
      "फ़ाइल: Ctrl+S (Save .docx) | F12 (Save As .pdf) | Ctrl+P (Print) | F7 (Spell Check)"
    ],
    "points_en": [
      "Golden Rule: Select Text First → Apply Format Next!",
      "Style: Ctrl+B (Bold) | Ctrl+I (Italic) | Ctrl+U (Underline)",
      "Alignment: Ctrl+L (Left) | Ctrl+E (Center) | Ctrl+R (Right) | Ctrl+J (Justify)",
      "File: Ctrl+S (Save .docx) | F12 (Save As .pdf) | Ctrl+P (Print) | F7 (Spell Check)"
    ]
  },
  {
    "heading_hi": "बिजली कटने पर ऑफलाइन बैकअप (Power-Cut Blackboard Backup)",
    "heading_en": "Offline / Power-Cut Blackboard Backup Activity",
    "points_hi": [
      "यदि बिजली न हो, तो ब्लैकबोर्ड पर 6 वर्ड आइकन बनाएँ: [B], [I], [U], [≡ Center], [• List], [⊞ Table] और पहचान का खेल कराएँ।",
      "छात्रों से अपनी कॉपी में एक छोटा अवकाश आवेदन लिखवाएँ और हर हिस्से के बगल में पेंसिल से सही वर्ड शॉर्टकट मार्क करवाएँ (जैसे शीर्षक के बगल में `Ctrl+E + Ctrl+B`, विषय पर `Ctrl+U`, पैराग्राफ पर `Ctrl+J`)!"
    ],
    "points_en": [
      "During a power cut, sketch 6 Ribbon icons on the board ([B], [I], [U], [Center], [Bullets], [Table]) for a lively team identification game.",
      "Have students write a short Leave Application in notebooks and annotate each line in pencil with the exact Word shortcut (`Ctrl+E + B`, `Ctrl+U`, `Ctrl+J`, `Ctrl+R`)!"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "लैब जोड़ी प्रोजेक्ट: \"मेरा पहला प्रिंट-रेडी आवेदन पत्र\"",
    "title_en": "ICT Lab Pair Project: \"My First Print-Ready Application\"",
    "materials_hi": "लैब कंप्यूटर और Microsoft Word",
    "materials_en": "Lab Desktop PC and Microsoft Word",
    "steps_hi": "दोनों साथी मिलकर 15 मिनट में A4 पेज पर 2 दिन के अवकाश का आवेदन टाइप करें: शीर्षक Center+Bold, Subject Bold+Underline, पैराग्राफ Justify, और अंत में नाम-रोल नंबर Right Align। `RollNo_App.pdf` सेव कर शिक्षक को दिखाएँ।",
    "steps_en": "Partners collaborate for 15 minutes to format a 2-day leave application on A4 paper: Center+Bold title, Bold+Underline Subject, Justified body, and Right-Aligned sign-off. Export `RollNo_App.pdf` for teacher sign-off."
  },
  {
    "title_hi": "ऑफलाइन खेल: \"रिबन आइकन जासूस\" (बिना बिजली)",
    "title_en": "Offline Game: \"Ribbon Detective\" (No Power Needed)",
    "materials_hi": "ब्लैकबोर्ड और चाक",
    "materials_en": "Blackboard and chalk",
    "steps_hi": "शिक्षक एक कार्य बोलें (जैसे \"मुझे स्कूल का नाम बीच में रखना है\" या \"गलत स्पेलिंग चेक करनी है\")। छात्र तुरंत हाथ उठाकर सही टैब (Home/Insert/Layout/Review) और शॉर्टकट (`Ctrl+E`, `F7`) बताएँ।",
    "steps_en": "Teacher announces a real task (\"Center the school name!\" or \"Check spelling errors!\"). Teams race to shout the exact Ribbon Tab and shortcut (`Ctrl+E`, `F7`)."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "(बिना कंप्यूटर गृहकार्य) अपनी कॉपी में MS Word के 10 मुख्य शॉर्टकट (`Ctrl+B, I, U, L, E, R, J, S, P, Z`) की सारणी बनाकर प्रत्येक का एक उदाहरण लिखें।",
    "task_en": "(Zero-Computer Homework) Create a neat notebook table of the 10 core MS Word shortcuts (`Ctrl+B, I, U, L, E, R, J, S, P, Z`) with one practical use for each."
  },
  {
    "level": "BOARD",
    "task_hi": "प्रधानाध्यापक को शुल्क माफी (Fee Concession) हेतु आवेदन का कागज़ पर खाका बनाएँ और हर पंक्ति के आगे लिखें कि MS Word में उस पर कौन-सी Formatting और Alignment लगेगी।",
    "task_en": "Draft a Fee Concession application on paper and label each section with the exact MS Word formatting and alignment shortcut it needs."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "`Save` बनाम `Save As`, `.docx` बनाम `.pdf`, तथा `Portrait` बनाम `Landscape` में 2-2 स्पष्ट अंतर उदाहरण सहित लिखें।",
    "task_en": "Write 2 clear differences with examples for each pair: `Save` vs `Save As`, `.docx` vs `.pdf`, and `Portrait` vs `Landscape`."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "हर लाइन के अंत में `Enter` दबाना ज़रूरी है ताकि अगली लाइन में जा सकें।",
    "misconception_en": "You must press `Enter` at the end of every single line while typing a paragraph.",
    "correction_hi": "Word Wrap समझाएँ: पैराग्राफ के बीच `Enter` न दबाएँ — MS Word अपने आप अगली लाइन में ले जाता है! `Enter` केवल नया पैराग्राफ शुरू करने पर दबाएँ।",
    "correction_en": "Demonstrate Word Wrap: never press `Enter` mid-paragraph; MS Word wraps lines automatically! Only press `Enter` to start a brand-new paragraph."
  },
  {
    "misconception_hi": "टेक्स्ट के नीचे लाल लहरदार रेखा प्रिंट निकालने पर कागज़ पर भी छप जाएगी।",
    "misconception_en": "Red and blue wavy spell-check lines will print on the paper printout.",
    "correction_hi": "स्पष्ट करें कि लाल/नीली रेखाएँ सिर्फ स्क्रीन पर आपकी मदद के लिए संकेत हैं, वे कागज़ पर नहीं छपतीं — फिर भी सही स्पेलिंग के लिए उन्हें ठीक करना ज़रूरी है!",
    "correction_en": "Reassure students that red/blue wavy lines are on-screen guides only and never print — though fixing the actual typos is always essential!"
  },
  {
    "misconception_hi": "Center Align का शॉर्टकट `Ctrl + C` होता है।",
    "misconception_en": "The shortcut for Center Align is `Ctrl + C`.",
    "correction_hi": "बोर्ड पर बड़ा लिखें: `Ctrl + C = Copy`, इसलिए Center के दूसरे अक्षर `E` से `Ctrl + E = Center` बना!",
    "correction_en": "Write boldly: `Ctrl + C = Copy`, so Center uses its second letter `E` → `Ctrl + E`!"
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

-- Questions for skill-ict-ch3 (22 multi-mode items)
INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- #1: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000001', 'skill-ict-lab', 'skill-ict-ch3', 'Word Proofing Lines', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'ICT Lab Core',
    'MS Word में लाल (Red) और नीली (Blue) लहरदार रेखाएँ क्या दर्शाती हैं?',
    'What do Red and Blue wavy underlines indicate in MS Word?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "MS Word में लाल (Red) और नीली (Blue) लहरदार रेखाओं का क्या अर्थ है? और इन्हें जाँचने की शॉर्टकट कुंजी क्या है?",
  "front_en": "What do Red and Blue wavy underlines mean in MS Word, and which Function key runs Spell Check?",
  "back_hi": "लाल लहरदार रेखा = Spelling (वर्तनी) की गलती। नीली लहरदार रेखा = Grammar (व्याकरण/स्पेस) की गलती। पूरे दस्तावेज़ की जाँच के लिए F7 दबाते हैं।",
  "back_en": "Red wavy line = Spelling error. Blue wavy line = Grammar/contextual error. Press F7 to check spelling and grammar across the whole document.",
  "pronunciation_hi": "स्पेलिंग एंड ग्रामर चेक (F7)",
  "mnemonic_hi": "लाल = स्पेलिंग रुकिए (Red = Spelling Alert), F7 = फाइनल जाँच!",
  "mnemonic_en": "Red = Spelling error, Blue = Grammar error, F7 = Full check!"
}$json$::jsonb, true
  ),
  -- #2: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000002', 'skill-ict-lab', 'skill-ict-ch3', 'Save vs Save As & PDF', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'ICT Lab Core',
    'Save (Ctrl+S) और Save As (F12) में क्या अंतर है? PDF में सेव करने का क्या फायदा है?',
    'What is the difference between Save (Ctrl+S) and Save As (F12), and why export to PDF?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Save (Ctrl+S) बनाम Save As (F12) में अंतर और .pdf का मुख्य लाभ क्या है?",
  "front_en": "Difference between Save (Ctrl+S) vs Save As (F12), and key benefit of .pdf?",
  "back_hi": "Save मौजूदा फाइल में बदलाव सहेजता है। Save As (F12) नए नाम, नए स्थान या नए फॉर्मेट (PDF) में अलग प्रति बनाता है। PDF हर मोबाइल व प्रिंटर पर बिल्कुल एक जैसा (Locked Layout) दिखता है।",
  "back_en": "Save updates the current file. Save As (F12) saves a separate copy with a new name, folder, or format (like PDF). PDF keeps your layout 100% locked across all phones and printers.",
  "pronunciation_hi": "सेव ऐज़ (Save As) और पी-डी-एफ (PDF)",
  "mnemonic_hi": ".docx = एडिट करने की कॉपी · .pdf = लेमिनेट की हुई पक्की कॉपी!",
  "mnemonic_en": ".docx = Editable draft · .pdf = Laminated final copy!"
}$json$::jsonb, true
  ),
  -- #3: MATCH_PAIRS (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000003', 'skill-ict-lab', 'skill-ict-ch3', 'Word Alignments & Shortcuts', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB ICT Model',
    'MS Word के संरेखण (Alignment) शॉर्टकट को उनके सही उपयोग से मिलाएँ:',
    'Match each MS Word alignment shortcut with its exact formatting use:',
    NULL, NULL,
    'L = Left, R = Right, J = Justify, और बचा हुआ E = Center!', 'L = Left, R = Right, J = Justify, and E = cEnter!',
    'Ctrl+L बायाँ, Ctrl+E बीच (Center), Ctrl+R दायाँ और Ctrl+J दोनों किनारों को सीधा (Justify) करता है।', 'Ctrl+L aligns Left, Ctrl+E aligns Center, Ctrl+R aligns Right, and Ctrl+J Justifies both edges.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "प्रत्येक संरेखण शॉर्टकट को उसके सही कार्य से मिलाएँ",
  "instruction_en": "Match each alignment shortcut with what it aligns",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "Ctrl + L (Left Align)",
      "left_en": "Ctrl + L (Left Align)",
      "right_hi": "टेक्स्ट को बाएँ किनारे से शुरू करना (\"To, The Principal\")",
      "right_en": "Align text to left edge (\"To, The Principal\")"
    },
    {
      "id": "p2",
      "left_hi": "Ctrl + E (Center Align)",
      "left_en": "Ctrl + E (Center Align)",
      "right_hi": "शीर्षक या स्कूल का नाम ठीक बीच में रखना",
      "right_en": "Place heading or school name in the center"
    },
    {
      "id": "p3",
      "left_hi": "Ctrl + R (Right Align)",
      "left_en": "Ctrl + R (Right Align)",
      "right_hi": "तारीख या हस्ताक्षर को दाएँ किनारे पर रखना",
      "right_en": "Align date or signature to right edge"
    },
    {
      "id": "p4",
      "left_hi": "Ctrl + J (Justify)",
      "left_en": "Ctrl + J (Justify)",
      "right_hi": "पैराग्राफ के बाएँ और दाएँ दोनों किनारे बराबर सीधे करना",
      "right_en": "Align both left and right edges evenly"
    }
  ]
}$json$::jsonb, true
  ),
  -- #4: SHORTCUT_STUDIO (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000004', 'skill-ict-lab', 'skill-ict-ch3', 'Word Bold Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'FOUNDATION', 'ICT Lab Hands-On',
    'चुने गए शीर्षक "Application for Leave" को गहरा/मोटा (Bold) बनाने का MS Word शॉर्टकट दबाएँ:',
    'Press the MS Word shortcut to make the selected heading "Application for Leave" Bold:',
    NULL, NULL,
    'Bold शब्द अक्षर B से शुरू होता है — Ctrl के साथ दबाएँ!', 'Bold starts with B — press it together with Ctrl!',
    'Ctrl + B चुने हुए टेक्स्ट को बोल्ड (मोटा/गहरा) बना देता है ताकि शीर्षक तुरंत अलग दिखे।', 'Ctrl + B makes selected text Bold so headings stand out clearly.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "MS_WORD",
  "task_hi": "चुने हुए शीर्षक को बोल्ड (Bold) करें",
  "task_en": "Make the selected heading Bold",
  "expected_keys": [
    "Ctrl",
    "B"
  ],
  "sample_doc_before": "Application for Two Days Sick Leave",
  "preview_effect": "BOLD",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "B",
    "I",
    "U",
    "E",
    "S"
  ]
}$json$::jsonb, true
  ),
  -- #5: SHORTCUT_STUDIO (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000005', 'skill-ict-lab', 'skill-ict-ch3', 'Word Underline Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'FOUNDATION', 'ICT Lab Hands-On',
    'आवेदन की "Subject:" लाइन के नीचे रेखा (Underline) खींचने का MS Word शॉर्टकट दबाएँ:',
    'Press the MS Word shortcut to Underline the selected "Subject:" line:',
    NULL, NULL,
    'Underline शब्द अक्षर U से शुरू होता है!', 'Underline starts with U — combine it with Ctrl!',
    'Ctrl + U चुने हुए टेक्स्ट के ठीक नीचे सीधी रेखा (Underline) खींच देता है।', 'Ctrl + U draws a neat underline beneath the selected text.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "MS_WORD",
  "task_hi": "\"Subject:\" पंक्ति को अंडरलाइन (Underline) करें",
  "task_en": "Underline the selected \"Subject:\" line",
  "expected_keys": [
    "Ctrl",
    "U"
  ],
  "sample_doc_before": "Subject: Request for Library Card Issue",
  "preview_effect": "UNDERLINE",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "B",
    "I",
    "U",
    "L",
    "S"
  ]
}$json$::jsonb, true
  ),
  -- #6: SHORTCUT_STUDIO (BOARD, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000006', 'skill-ict-lab', 'skill-ict-ch3', 'Word Center Align Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'BOARD', 'BSEB ICT Model',
    'स्कूल के नाम को पन्ने के ठीक बीच (Center Align) में लाने का MS Word शॉर्टकट दबाएँ:',
    'Press the MS Word shortcut to Center-Align the school name heading on the page:',
    NULL, NULL,
    'सावधान! Ctrl + C तो Copy है — Center का दूसरा अक्षर E याद करें!', 'Careful! Ctrl + C is Copy — remember the second letter E in cEnter!',
    'MS Word में Center Align का सटीक शॉर्टकट `Ctrl + E` होता है। यह बोर्ड परीक्षा में बार-बार पूछा जाता है!', 'The exact MS Word shortcut for Center Align is `Ctrl + E` (since `Ctrl + C` is Copy).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "MS_WORD",
  "task_hi": "विद्यालय के नाम को पन्ने के ठीक बीच (Center Align) में लाएँ",
  "task_en": "Center-align the school title on the page",
  "expected_keys": [
    "Ctrl",
    "E"
  ],
  "sample_doc_before": "UTKRAMIT HIGH SCHOOL, BIHAR",
  "preview_effect": "ALIGN_CENTER",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "C",
    "E",
    "L",
    "R",
    "J"
  ]
}$json$::jsonb, true
  ),
  -- #7: SHORTCUT_STUDIO (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000007', 'skill-ict-lab', 'skill-ict-ch3', 'Word Save Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'FOUNDATION', 'ICT Lab Hands-On',
    'आपने पूरा आवेदन टाइप कर लिया है! बिजली कटने से पहले इसे तुरंत सहेजने (Save) का शॉर्टकट दबाएँ:',
    'You finished typing your application! Press the shortcut to Save it right away before power goes off:',
    NULL, NULL,
    'Save शब्द अक्षर S से शुरू होता है!', 'Save starts with S — press it with Ctrl!',
    'Ctrl + S तुरंत आपके दस्तावेज़ को Hard Disk पर सेव कर देता है। काम करते समय हर 2 मिनट में Ctrl + S दबाना सबसे अच्छी आदत है!', 'Ctrl + S immediately saves your document to disk. Pressing Ctrl + S every 2 minutes protects your work from sudden power cuts!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "MS_WORD",
  "task_hi": "अपने आवेदन पत्र \"Leave_App.docx\" को तुरंत सेव (Save) करें",
  "task_en": "Save your typed document \"Leave_App.docx\" immediately",
  "expected_keys": [
    "Ctrl",
    "S"
  ],
  "sample_doc_before": "Leave_App.docx (Unsaved Changes*) — To, The Principal...",
  "preview_effect": "SAVE",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "S",
    "P",
    "A",
    "B",
    "Z"
  ]
}$json$::jsonb, true
  ),
  -- #8: SCENARIO_LAB (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000008', 'skill-ict-lab', 'skill-ict-ch3', 'Word Ribbon Detective — Alignment', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', 'ICT Lab Practical',
    'रिबन जासूस (MS Word): आप अपने निबंध का शीर्षक "मेरा बिहार" पन्ने के ठीक बीचों-बीच सजाना चाहते हैं। Home रिबन का कौन-सा आइकन चुनेंगे?',
    'Word Ribbon Detective: You want to place your essay title "My Bihar" neatly in the exact center of the page. Which Home Ribbon button will you click?',
    NULL, NULL,
    'उस आइकन को चुनें जिसकी रेखाएँ बीचों-बीच संरेखित हैं!', 'Pick the toolbar button whose lines are balanced in the middle!',
    'Align Center (Ctrl + E) शीर्षक को पन्ने के ठीक मध्य में रखता है। Align Left बाएँ रखता है और Bulleted List बिंदुओं की सूची बनाती है।', 'Align Center (Ctrl + E) centers your heading cleanly across the page width.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "RIBBON_DETECTIVE",
  "scene_title_hi": "MS Word Home रिबन जासूस — शीर्षक को बीच में लाएँ",
  "scene_title_en": "MS Word Home Ribbon Detective — Center the Essay Title",
  "prompt_hi": "आपका शीर्षक \"मेरा बिहार\" अभी बाएँ कोने में चिपका है। बिना Spacebar दबाए इसे ठीक बीच में लाने के लिए सही रिबन बटन चुनें:",
  "prompt_en": "Your title \"My Bihar\" is stuck on the left margin. Pick the exact Ribbon icon to center it cleanly without using Spacebar:",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "AlignLeft",
      "label_hi": "Align Left (बायाँ संरेखण)",
      "label_en": "Align Left"
    },
    {
      "id": "c2",
      "icon": "List",
      "label_hi": "Bullets (बुलेट सूची)",
      "label_en": "Bulleted List"
    },
    {
      "id": "c3",
      "icon": "AlignCenter",
      "label_hi": "Align Center (मध्य संरेखण)",
      "label_en": "Align Center"
    },
    {
      "id": "c4",
      "icon": "Italic",
      "label_hi": "Italic (तिरछा टेक्स्ट)",
      "label_en": "Italic Text"
    }
  ],
  "correct_choice_id": "c3"
}$json$::jsonb, true
  ),
  -- #9: SCENARIO_LAB (BOARD, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000009', 'skill-ict-lab', 'skill-ict-ch3', 'Word Ribbon Detective — Table', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'ICT Lab Practical',
    'रिबन जासूस (MS Word): शिक्षक ने आपको कक्षा 10 का 6 दिन × 5 पीरियड का साप्ताहिक टाइम-टेबल बनाने को कहा है। आप कौन-सा टूल चुनेंगे?',
    'Word Ribbon Detective: Your teacher asked you to create a 6-day × 5-period weekly class timetable in MS Word. Which tool should you pick?',
    NULL, NULL,
    'पंक्तियों (Rows) और स्तंभों (Columns) के खानों के लिए Insert टैब में कौन-सा टूल होता है?', 'Which Insert-tab tool creates neat rows and columns for a schedule?',
    'Insert → Table आपको पंक्तियों और स्तंभों की सटीक तालिका बनाने देता है, जो टाइम-टेबल और अंक-तालिका के लिए सबसे उपयुक्त है।', 'Insert → Table builds crisp rows and columns, making it the right tool for timetables and schedules.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "RIBBON_DETECTIVE",
  "scene_title_hi": "MS Word Insert रिबन जासूस — टाइम-टेबल बनाएँ",
  "scene_title_en": "MS Word Insert Ribbon Detective — Build a Timetable",
  "prompt_hi": "पंक्तियों (Rows) और स्तंभों (Columns) में अपना साप्ताहिक स्कूल टाइम-टेबल बनाने के लिए कौन-सा रिबन टूल चुनेंगे?",
  "prompt_en": "Select the exact MS Word tool to insert rows and columns for your weekly school timetable:",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "Table",
      "label_hi": "Insert Table (तालिका जोड़ें)",
      "label_en": "Insert Table"
    },
    {
      "id": "c2",
      "icon": "Bold",
      "label_hi": "Bold (गहरा अक्षर)",
      "label_en": "Bold Text"
    },
    {
      "id": "c3",
      "icon": "Printer",
      "label_hi": "Print (प्रिंट निकालें)",
      "label_en": "Print Page"
    },
    {
      "id": "c4",
      "icon": "Undo2",
      "label_hi": "Undo (वापस लाएँ)",
      "label_en": "Undo Action"
    }
  ],
  "correct_choice_id": "c1"
}$json$::jsonb, true
  ),
  -- #10: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000010', 'skill-ict-lab', 'skill-ict-ch3', 'Word File Extension', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB ICT Model',
    'माइक्रोसॉफ्ट वर्ड (MS Word) में बनाई गई फाइल का मानक एक्सटेंशन क्या होता है?',
    'What is the standard file extension of a Microsoft Word document?',
    $json$[{"key":"A","text_hi":".xlsx","text_en":".xlsx"},{"key":"B","text_hi":".jpg","text_en":".jpg"},{"key":"C","text_hi":".mp4","text_en":".mp4"},{"key":"D","text_hi":".docx","text_en":".docx"}]$json$::jsonb, 'D',
    'Document शब्द के पहले 3 अक्षर `doc` से पहचानें!', 'Match the first three letters of "Document" (`doc`)!',
    'MS Word डॉक्यूमेंट का मानक एक्सटेंशन `.docx` होता है (पुराने संस्करणों में `.doc`)।', 'Modern MS Word documents use the `.docx` extension (`.doc` in older versions).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #11: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000011', 'skill-ict-lab', 'skill-ict-ch3', 'Word Print Shortcut', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'MS Word में तैयार दस्तावेज़ को प्रिंटर से कागज़ पर छापने (Print) का शॉर्टकट क्या है?',
    'Which shortcut opens the Print window in MS Word to print your document on paper?',
    $json$[{"key":"A","text_hi":"Ctrl + V","text_en":"Ctrl + V"},{"key":"B","text_hi":"Ctrl + P","text_en":"Ctrl + P"},{"key":"C","text_hi":"Ctrl + S","text_en":"Ctrl + S"},{"key":"D","text_hi":"Ctrl + B","text_en":"Ctrl + B"}]$json$::jsonb, 'B',
    'Print शब्द अक्षर P से शुरू होता है!', 'Print begins with the letter P!',
    'Ctrl + P प्रिंट प्रिव्यू और प्रिंट विंडो खोलता है, जिससे आप दस्तावेज़ कागज़ पर प्रिंट कर सकते हैं।', 'Ctrl + P opens Print Preview and Print settings to print your document.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #12: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000012', 'skill-ict-lab', 'skill-ict-ch3', 'Italic Formatting', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'MS Word में चुने हुए शब्दों को हल्का तिरछा (Slanted) करने के लिए किस विकल्प का उपयोग किया जाता है?',
    'Which formatting style makes selected text slanted in MS Word?',
    $json$[{"key":"A","text_hi":"Italic (Ctrl + I)","text_en":"Italic (Ctrl + I)"},{"key":"B","text_hi":"Bold (Ctrl + B)","text_en":"Bold (Ctrl + B)"},{"key":"C","text_hi":"Underline (Ctrl + U)","text_en":"Underline (Ctrl + U)"},{"key":"D","text_hi":"Justify (Ctrl + J)","text_en":"Justify (Ctrl + J)"}]$json$::jsonb, 'A',
    'रिबन पर तिरछा लिखा `I` बटन याद करें!', 'Remember the slanted `I` button on the Home Ribbon!',
    'Italic (`Ctrl + I`) चुने हुए अक्षरों को दाईं ओर हल्का तिरछा कर देता है, जिसका प्रयोग उद्धरण व पुस्तक नामों में होता है।', 'Italic (`Ctrl + I`) slants text gently to the right, commonly used for quotes and book titles.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #13: MCQ (BOARD, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000013', 'skill-ict-lab', 'skill-ict-ch3', 'Justify Alignment', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'पैराग्राफ के बाएँ और दाएँ दोनों किनारों को एक सीध में बराबर (Justify) करने का शॉर्टकट क्या है?',
    'What is the shortcut to Justify a paragraph so both left and right margins look straight?',
    $json$[{"key":"A","text_hi":"Ctrl + L","text_en":"Ctrl + L"},{"key":"B","text_hi":"Ctrl + E","text_en":"Ctrl + E"},{"key":"C","text_hi":"Ctrl + J","text_en":"Ctrl + J"},{"key":"D","text_hi":"Ctrl + R","text_en":"Ctrl + R"}]$json$::jsonb, 'C',
    'Justify शब्द के पहले अक्षर `J` से पहचानें!', 'Match the first letter `J` of Justify!',
    'Ctrl + J (Justify) शब्दों के बीच दूरी को संतुलित कर पैराग्राफ के बाएँ व दाएँ दोनों किनारों को बिल्कुल सीधा बना देता है।', 'Ctrl + J (Justify) evenly aligns both left and right edges of a paragraph.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #14: MCQ (BOARD, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000014', 'skill-ict-lab', 'skill-ict-ch3', 'Spell Check Key', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'MS Word में पूरे दस्तावेज़ की Spelling और Grammar एक साथ जाँचने की फ़ंक्शन कुंजी कौन-सी है?',
    'Which Function key runs Spelling and Grammar check across an MS Word document?',
    $json$[{"key":"A","text_hi":"F2","text_en":"F2"},{"key":"B","text_hi":"F5","text_en":"F5"},{"key":"C","text_hi":"F12","text_en":"F12"},{"key":"D","text_hi":"F7","text_en":"F7"}]$json$::jsonb, 'D',
    'F12 Save As के लिए है; वर्तनी जाँच के लिए 7 नंबर की फ़ंक्शन कुंजी दबती है!', 'F12 is Save As; Spelling & Grammar check uses Function key 7!',
    'MS Word में `F7` दबाने से Spelling & Grammar जाँच खुलती है। (`F12` Save As के लिए उपयोग होता है।)', 'Pressing `F7` launches Spelling & Grammar check in MS Word (`F12` opens Save As).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #15: MCQ (BOARD, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000015', 'skill-ict-lab', 'skill-ict-ch3', 'Page Orientation', 'PRACTICE', 'MCQ', 'BOARD', NULL,
    'यदि आपको एक बहुत चौड़ा स्कूल प्रमाण-पत्र या 10-कॉलम वाला टाइम-टेबल छापना है, तो कौन-सा पेज ओरिएंटेशन चुनना बेहतर होगा?',
    'To print a wide school certificate or a 10-column timetable, which page orientation is best?',
    $json$[{"key":"A","text_hi":"Landscape (आड़ा / चौड़ा पेज)","text_en":"Landscape (Horizontal / Wide)"},{"key":"B","text_hi":"Portrait (खड़ा पेज)","text_en":"Portrait (Vertical)"},{"key":"C","text_hi":"Header Only","text_en":"Header Only"},{"key":"D","text_hi":"Superscript","text_en":"Superscript"}]$json$::jsonb, 'A',
    'अधिक चौड़ाई (Width) किस ओरिएंटेशन में मिलती है?', 'Which orientation turns the sheet sideways to give maximum width?',
    'Landscape ओरिएंटेशन में कागज़ की चौड़ाई उसकी ऊँचाई से अधिक होती है, जिससे चौड़ी तालिकाएँ और प्रमाण-पत्र बिना कटे आ जाते हैं।', 'Landscape orientation makes the page wider than it is tall, fitting wide tables and certificates cleanly.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #16: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000016', 'skill-ict-lab', 'skill-ict-ch3', 'Header & Footer', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB ICT Model',
    'यदि आपके प्रोजेक्ट में 12 पेज हैं और आप चाहते हैं कि हर पेज के सबसे नीचे अपने आप Page Number (1, 2, 3...) आ जाए, तो आप किस सुविधा का उपयोग करेंगे?',
    'Your project report has 12 pages and you want automatic Page Numbers at the bottom of every page. Which feature should you use?',
    $json$[{"key":"A","text_hi":"हर पेज पर हाथ से नंबर टाइप करना","text_en":"Type numbers manually on every page"},{"key":"B","text_hi":"Home → Strikethrough","text_en":"Home → Strikethrough"},{"key":"C","text_hi":"Insert → Footer / Page Number","text_en":"Insert → Footer / Page Number"},{"key":"D","text_hi":"Review → Track Changes","text_en":"Review → Track Changes"}]$json$::jsonb, 'C',
    'पेज के "पैर" (निचले हिस्से) में अपने आप दोहराने वाला क्षेत्र क्या कहलाता है?', 'What is the bottom repeating band of every page called?',
    'Insert → Footer / Page Number लगाने से सभी 12 पेजों पर अपने आप क्रमबद्ध पृष्ठ संख्या जुड़ जाती है और नया पेज जोड़ने पर भी अपने आप अपडेट होती है!', 'Insert → Footer / Page Number automatically numbers every page and updates dynamically if pages are added or removed.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #17: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000017', 'skill-ict-lab', 'skill-ict-ch3', 'Superscript & Subscript', 'PRACTICE', 'MCQ', 'TOPPER', NULL,
    'MS Word में पानी का रासायनिक सूत्र `H2O` (जहाँ `2` नीचे की ओर छोटा हो) लिखने के लिए किस विकल्प का उपयोग करते हैं?',
    'In MS Word, which formatting tool makes the `2` sit lower and smaller in the chemical formula `H2O`?',
    $json$[{"key":"A","text_hi":"Superscript (x²)","text_en":"Superscript (x²)"},{"key":"B","text_hi":"Subscript (x₂)","text_en":"Subscript (x₂)"},{"key":"C","text_hi":"Drop Cap","text_en":"Drop Cap"},{"key":"D","text_hi":"WordArt","text_en":"WordArt"}]$json$::jsonb, 'B',
    'Sub = नीचे (जैसे Submarine पानी के नीचे चलती है); Super = ऊपर (जैसे x²)!', 'Sub = below (like Submarine); Super = above (like x²)!',
    'Subscript (`x₂`) अक्षर या संख्या को आधार रेखा से नीचे छोटा लिखता है (जैसे H₂O, CO₂), जबकि Superscript (`x²`) ऊपर घात लिखता है (जैसे 10th, x²)।', 'Subscript (`x₂`) places characters below the baseline (H₂O, CO₂), whereas Superscript (`x²`) raises them above (10th, a²).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #18: MCQ (FOUNDATION, EXAM_ONLY)
  (
    '10000005-0003-4000-8000-000000000018', 'skill-ict-lab', 'skill-ict-ch3', 'Select All Shortcut', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'ICT Live Exam',
    'MS Word दस्तावेज़ के पूरे टेक्स्ट को एक ही बार में चुनने (Select All) का शॉर्टकट क्या है?',
    'What is the shortcut to select the ENTIRE text of an MS Word document at once?',
    $json$[{"key":"A","text_hi":"Ctrl + W","text_en":"Ctrl + W"},{"key":"B","text_hi":"Ctrl + S","text_en":"Ctrl + S"},{"key":"C","text_hi":"Ctrl + A","text_en":"Ctrl + A"},{"key":"D","text_hi":"Ctrl + D","text_en":"Ctrl + D"}]$json$::jsonb, 'C',
    'All शब्द अक्षर A से शुरू होता है!', 'All begins with the letter A!',
    'Ctrl + A (Select All) पूरे दस्तावेज़ की हर लाइन और पैराग्राफ को 1 सेकंड में चुन लेता है।', 'Ctrl + A selects every word and paragraph in the active document instantly.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #19: MCQ (BOARD, EXAM_ONLY)
  (
    '10000005-0003-4000-8000-000000000019', 'skill-ict-lab', 'skill-ict-ch3', 'Find & Replace', 'EXAM_ONLY', 'MCQ', 'BOARD', 'ICT Live Exam',
    'एक 5-पेज के नोट में गलती से हर जगह "Patna" की जगह "Patnna" लिख गया है। सभी को एक साथ बदलने के लिए किस शॉर्टकट (Replace) का प्रयोग करेंगे?',
    'In a 5-page note, "Patna" was mistyped as "Patnna" everywhere. Which shortcut opens Find & Replace to fix every occurrence at once?',
    $json$[{"key":"A","text_hi":"Ctrl + R","text_en":"Ctrl + R"},{"key":"B","text_hi":"Ctrl + E","text_en":"Ctrl + E"},{"key":"C","text_hi":"Ctrl + U","text_en":"Ctrl + U"},{"key":"D","text_hi":"Ctrl + H","text_en":"Ctrl + H"}]$json$::jsonb, 'D',
    'Ctrl + R तो Right Align के लिए है! Find के लिए Ctrl + F और Replace के लिए Ctrl + H होता है।', 'Ctrl + R is Right Align! Find is Ctrl + F and Replace is Ctrl + H!',
    'MS Word में `Ctrl + H` (Find and Replace) खोलता है, जिससे एक ही क्लिक (Replace All) में सभी गलत शब्दों को सही किया जा सकता है।', '`Ctrl + H` opens Find & Replace in MS Word so you can correct every occurrence in one click via Replace All.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #20: MCQ (TOPPER, EXAM_ONLY)
  (
    '10000005-0003-4000-8000-000000000020', 'skill-ict-lab', 'skill-ict-ch3', 'Save As PDF Benefit', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'ICT Live Exam',
    'छात्रवृत्ति फॉर्म या बायोडाटा को दूसरे कंप्यूटर पर प्रिंट कराने से पहले `.pdf` फॉर्मेट में सेव करना क्यों बेहतर माना जाता है?',
    'Why is it smarter to export your bio-data or application as `.pdf` before taking it to a cyber cafe for printing?',
    $json$[{"key":"A","text_hi":"क्योंकि PDF का फॉन्ट, मार्जिन और पेज लेआउट दूसरे कंप्यूटर पर भी बिल्कुल नहीं बदलता","text_en":"Because PDF preserves exact fonts, margins, and page layout on every device"},{"key":"B","text_hi":"क्योंकि PDF में कोई भी शब्द आसानी से मिट जाता है","text_en":"Because words erase easily in PDF"},{"key":"C","text_hi":"क्योंकि PDF फाइल केवल बिना बिजली के खुलती है","text_en":"Because PDF only opens without electricity"},{"key":"D","text_hi":"क्योंकि PDF केवल MS Paint में बनता है","text_en":"Because PDF can only be created in MS Paint"}]$json$::jsonb, 'A',
    'लेमिनेटेड मार्कशीट वाला उदाहरण याद करें!', 'Remember the laminated marksheet analogy!',
    'PDF (Portable Document Format) आपके फॉन्ट, चित्र और पेज लेआउट को लॉक कर देता है, इसलिए किसी भी कंप्यूटर या मोबाइल पर प्रिंट बिल्कुल सटीक आता है।', 'PDF (Portable Document Format) locks fonts, alignment, and page breaks so your printout looks identical on every computer.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #21: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000021', 'skill-ict-lab', 'skill-ict-ch3', 'Save vs Save As & Proofing', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'MS Word में (1) `Save` और `Save As` में अंतर, तथा (2) लाल और नीली लहरदार रेखाओं का अर्थ लिखें।',
    'In MS Word, state: (1) the difference between `Save` and `Save As`, and (2) the meaning of Red vs Blue wavy lines.',
    NULL, NULL,
    'प्रत्येक भाग के लिए 1-1 सटीक वाक्य व शॉर्टकट (`Ctrl+S`, `F12`) लिखें।', 'Give 1 crisp point with shortcut (`Ctrl+S`, `F12`) for each part.',
    NULL, NULL,
    '1. **Save बनाम Save As:** **`Save` (`Ctrl + S`)** उसी मौजूदा फाइल में किए गए नए बदलावों को सहेजता है, जबकि **`Save As` (`F12`)** दस्तावेज़ की नए नाम, नए फोल्डर या नए फॉर्मेट (जैसे `.pdf`) में दूसरी प्रति बनाता है।
2. **लहरदार रेखाएँ:** **लाल लहरदार रेखा** शब्द की **वर्तनी (Spelling)** में गलती बताती है और **नीली लहरदार रेखा** **व्याकरण (Grammar)** या स्पेसिंग की त्रुटि दर्शाती है।', '1. **Save vs Save As:** **`Save` (`Ctrl + S`)** saves updates into the current file, whereas **`Save As` (`F12`)** creates a new copy with a different filename, folder, or format (such as `.pdf`).
2. **Wavy Lines:** A **Red wavy line** flags a **Spelling error**, while a **Blue wavy line** flags a **Grammar** or spacing error.',
    $json$[{"cue_hi":"Save (Ctrl+S) = वही फाइल अपडेट · Save As (F12) = नई कॉपी/PDF","cue_en":"Save (Ctrl+S) = update same file · Save As (F12) = new copy/PDF"},{"cue_hi":"लाल = Spelling · नीली = Grammar","cue_en":"Red = Spelling · Blue = Grammar"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"Save और Save As में सही अंतर (शॉर्टकट सहित)","criterion_en":"Accurate Save vs Save As distinction with shortcuts"},{"step_no":2,"marks":1,"criterion_hi":"लाल (Spelling) व नीली (Grammar) रेखा का सही अर्थ","criterion_en":"Correct meaning of Red (Spelling) and Blue (Grammar) wavy lines"}]$json$::jsonb,
    NULL, true
  ),
  -- #22: LONG_5M (TOPPER, PRACTICE)
  (
    '10000005-0003-4000-8000-000000000022', 'skill-ict-lab', 'skill-ict-ch3', 'Word Practical Application Steps', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB ICT Practical',
    'MS Word में प्रधानाध्यापक को 2 दिन के अवकाश हेतु एक साफ, प्रिंट-रेडी आवेदन पत्र तैयार करने के संपूर्ण चरण (पेज सेटअप, फॉर्मेटिंग शॉर्टकट, वर्तनी जाँच और PDF सहेजना सहित) लिखें।',
    'Write the complete step-by-step procedure in MS Word to prepare a clean, print-ready 2-day Leave Application to the Principal, including Page Setup, Formatting Shortcuts, Spell Check, and Saving as PDF.',
    NULL, NULL,
    '5 स्पष्ट चरणों में लिखें: पेज सेटअप (A4) → शीर्षक व पता → विषय व पैराग्राफ → वर्तनी जाँच (F7) → Save (.docx) व PDF/Print!', 'Structure in 5 crisp stages: A4 Page Setup → Title & Address → Subject & Body → Spell Check (F7) → Save (.docx) & PDF/Print!',
    NULL, NULL,
    '**चरण 1 — नया दस्तावेज़ व पेज सेटअप (Layout टैब):**
- MS Word खोलें और **Blank Document** चुनें।
- **Layout → Size → A4** चुनें, **Orientation → Portrait** और **Margins → Normal** रखें।

**चरण 2 — शीर्षक व प्रधानाध्यापक का पता (Home टैब):**
- सबसे ऊपर शीर्षक लिखकर चुनें और **`Ctrl + E`** (Center Align) + **`Ctrl + B`** (Bold) + 14 pt आकार दें।
- नई पंक्ति पर **`Ctrl + L`** (Left Align) करके *"सेवा में, प्रधानाध्यापक महोदय..."* लिखें।

**चरण 3 — विषय व मुख्य पैराग्राफ की फॉर्मेटिंग:**
- *"विषय: दो दिन के अवकाश हेतु आवेदन पत्र"* को चुनकर **`Ctrl + B`** (Bold) और **`Ctrl + U`** (Underline) करें।
- मुख्य पैराग्राफ 12 pt फॉन्ट में लिखें और **`Ctrl + J`** (Justify) से दोनों किनारे बराबर करें।
- अंत में *"आपका आज्ञाकारी छात्र, नाम, कक्षा, रोल नं."* को **`Ctrl + R`** (Right Align) करें।

**चरण 4 — वर्तनी जाँच व प्रिंट प्रिव्यू:**
- **`F7`** दबाकर सभी लाल (Spelling) और नीली (Grammar) त्रुटियाँ ठीक करें।
- **`Ctrl + P`** से Print Preview देखें कि पूरा आवेदन 1 ही पेज पर साफ आ रहा है।

**चरण 5 — सुरक्षित सहेजना (.docx व .pdf):**
- **`Ctrl + S`** से `Leave_Application.docx` सेव करें और **`F12` (Save As → PDF)** से प्रिंट-रेडी `.pdf` प्रति बनाएँ।', '**Step 1 — Blank Document & Page Setup (Layout Tab):**
- Open MS Word and select **Blank Document**.
- Go to **Layout → Size → A4**, set **Orientation → Portrait**, and keep **Margins → Normal**.

**Step 2 — Heading & Recipient Address (Home Tab):**
- Type the title, select it, and apply **`Ctrl + E`** (Center Align) + **`Ctrl + B`** (Bold) at 14 pt.
- Press Enter, switch to **`Ctrl + L`** (Left Align), and type *"To, The Principal..."*.

**Step 3 — Subject & Body Formatting:**
- Highlight the *"Subject:"* line and apply **`Ctrl + B`** (Bold) + **`Ctrl + U`** (Underline).
- Type the body in clean 12 pt font and apply **`Ctrl + J`** (Justify) for crisp margins.
- Align *"Yours obediently, Name, Class, Roll No."* cleanly with **`Ctrl + R`** (Right Align).

**Step 4 — Proofreading & Print Preview:**
- Press **`F7`** to fix all Red (spelling) and Blue (grammar) lines.
- Press **`Ctrl + P`** to inspect Print Preview and verify everything fits on 1 page.

**Step 5 — Save (.docx) & Export as PDF:**
- Save editable copy via **`Ctrl + S`** (`Leave_Application.docx`) and export print-safe PDF via **`F12` (Save As → PDF)**.',
    $json$[{"cue_hi":"पेज = A4 Portrait · शीर्षक = Ctrl+E + B","cue_en":"Page = A4 Portrait · Title = Ctrl+E + B"},{"cue_hi":"विषय = Ctrl+B + U · पैराग्राफ = Ctrl+J · अंत = Ctrl+R","cue_en":"Subject = Ctrl+B + U · Body = Ctrl+J · Sign-off = Ctrl+R"},{"cue_hi":"जाँच = F7 · सेव = Ctrl+S · PDF = F12","cue_en":"Proof = F7 · Save = Ctrl+S · PDF = F12"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"A4 पेज साइज, Portrait व Margins सेटअप","criterion_en":"Sets A4 paper size, Portrait orientation, and margins"},{"step_no":2,"marks":1,"criterion_hi":"शीर्षक व पते का सही Alignment (Ctrl+E, Ctrl+L)","criterion_en":"Correct heading and address alignment shortcuts"},{"step_no":3,"marks":1.5,"criterion_hi":"विषय (Bold+Underline), पैराग्राफ (Justify) व हस्ताक्षर (Right)","criterion_en":"Subject (B+U), Justified body (Ctrl+J), and Right sign-off (Ctrl+R)"},{"step_no":4,"marks":0.75,"criterion_hi":"F7 Spell Check व Ctrl+P Print Preview जाँच","criterion_en":"F7 spell check and Ctrl+P Print Preview verification"},{"step_no":5,"marks":0.75,"criterion_hi":"Ctrl+S (.docx) तथा Save As PDF (.pdf) सहेजना","criterion_en":"Saves both .docx and print-locked .pdf copy"}]$json$::jsonb,
    NULL, true
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
-- CHAPTER 4 OF 6: SKILL-ICT-CH4 — MICROSOFT EXCEL & SPREADSHEET MAGIC
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-ict-ch4',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: एमएस एक्सेल और स्प्रेडशीट का जादू",
  "title_en": "30-Second Mindmap: Microsoft Excel & Spreadsheet Magic",
  "read_time_seconds": 30,
  "central_node": {
    "id": "ict4-root",
    "label_hi": "माइक्रोसॉफ्ट एक्सेल (MS Excel · .xlsx)",
    "label_en": "Microsoft Excel (.xlsx)",
    "subtitle_hi": "स्कूल मार्कशीट, बजट और स्वचालित गणना की स्मार्ट तालिका",
    "subtitle_en": "Smart spreadsheet for marksheets, budgets & instant auto-calculation"
  },
  "branches": [
    {
      "id": "ict4-b1",
      "label_hi": "1. वर्कबुक, शीट और सेल एड्रेस",
      "label_en": "1. Workbook, Sheet & Cell Address",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "ict4-b1-1",
          "label_hi": "कॉलम (A, B, C...) + पंक्ति (1, 2, 3...) = सेल (B2)",
          "label_en": "Column (A, B, C...) + Row (1, 2, 3...) = Cell (B2)"
        },
        {
          "id": "ict4-b1-2",
          "label_hi": "सेल रेंज: B2:D2 (B2 से D2 तक लगातार)",
          "label_en": "Cell Range: B2:D2 (from B2 through D2)"
        },
        {
          "id": "ict4-b1-3",
          "label_hi": "नेम बॉक्स (सक्रिय सेल) व फॉर्मूला बार (असली सूत्र)",
          "label_en": "Name Box (active cell) & Formula Bar (real formula)"
        }
      ]
    },
    {
      "id": "ict4-b2",
      "label_hi": "2. 6 महाशक्ति फॉर्मूले (हमेशा = से शुरू!)",
      "label_en": "2. 6 Power Formulas (Always Start with =)",
      "color": "#059669",
      "formula_latex": "\\text{=SUM(B2:D2)},\\quad \\text{=AVERAGE(B2:D2)}",
      "children": [
        {
          "id": "ict4-b2-1",
          "label_hi": "=SUM (जोड़), =AVERAGE (औसत)",
          "label_en": "=SUM (Total), =AVERAGE (Mean)"
        },
        {
          "id": "ict4-b2-2",
          "label_hi": "=MAX (सबसे बड़ा), =MIN (सबसे छोटा)",
          "label_en": "=MAX (Highest), =MIN (Lowest)"
        },
        {
          "id": "ict4-b2-3",
          "label_hi": "=COUNT (संख्या गिनना), =IF (Pass/Fail शर्त)",
          "label_en": "=COUNT (Count numbers), =IF (Pass/Fail logic)"
        }
      ]
    },
    {
      "id": "ict4-b3",
      "label_hi": "3. स्मार्ट समय-बचाऊ टूल्स",
      "label_en": "3. Smart Time-Saving Tools",
      "color": "#D97706",
      "children": [
        {
          "id": "ict4-b3-1",
          "label_hi": "Fill Handle (+): 1 सेकंड में 60 छात्रों का योग",
          "label_en": "Fill Handle (+): Auto-fill 60 rows in 1 second"
        },
        {
          "id": "ict4-b3-2",
          "label_hi": "Sort (टॉपर ऊपर लाना), Filter व Charts",
          "label_en": "Sort (Rank toppers), Filter & Charts"
        }
      ]
    },
    {
      "id": "ict4-b4",
      "label_hi": "4. सामान्य त्रुटियाँ व समाधान",
      "label_en": "4. Common Errors & Quick Fixes",
      "color": "#7C3AED",
      "children": [
        {
          "id": "ict4-b4-1",
          "label_hi": "### → कॉलम की चौड़ाई बढ़ाएँ",
          "label_en": "### → Widen the column border"
        },
        {
          "id": "ict4-b4-2",
          "label_hi": "#NAME? → फॉर्मूला स्पेलिंग जाँचें (=SUM)",
          "label_en": "#NAME? → Fix formula spelling (=SUM)"
        },
        {
          "id": "ict4-b4-3",
          "label_hi": "#DIV/0! → 0 से भाग न दें",
          "label_en": "#DIV/0! → Never divide by zero"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "ict4-sec-1-grid",
    "order": 1,
    "heading_hi": "1. एक्सेल ग्रिड: कॉलम, पंक्ति, सेल एड्रेस (B2) और रेंज (B2:D2)",
    "heading_en": "1. Excel Grid: Columns, Rows, Cell Address (B2) & Range (B2:D2)",
    "analogy_hi": "MS Excel बिल्कुल आपके स्कूल के **हाज़िरी और अंक रजिस्टर (Attendance & Marks Register)** जैसा है — बस इसमें हर खाने के पीछे एक **जादुई कैलकुलेटर** छिपा रहता है! खड़ी रेखाएँ **कॉलम (A, B, C...)** हैं और आड़ी रेखाएँ **पंक्तियाँ (1, 2, 3...)** हैं। जहाँ कॉलम `B` और पंक्ति `2` मिलते हैं, उस खाने का पता (सीट नंबर) **`B2`** है — पहले हमेशा अक्षर (Column), फिर संख्या (Row)!",
    "analogy_en": "MS Excel is your school's **Attendance & Marks Register** upgraded with an invisible lightning-fast calculator! Vertical pillars are **Columns (A, B, C...)** and horizontal lines are **Rows (1, 2, 3...)**. Where Column `B` crosses Row `2`, that box's seat address is **`B2`** — always Column Letter FIRST, Row Number SECOND!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "MS Excel मार्कशीट ग्रिड की संरचना (Name Box, Formula Bar, Range और Active Cell)",
      "title_en": "Anatomy of an MS Excel Marksheet Grid (Name Box, Formula Bar, Range & Active Cell)",
      "caption_hi": "नीले रंग से चिह्नित B2:D2 को Cell Range कहते हैं और हरे बॉर्डर वाला E2 Active Cell है। Formula Bar में E2 का असली सूत्र =SUM(B2:D2) दिखता है!",
      "caption_en": "The shaded cells B2:D2 form a Cell Range and the green-outlined E2 is the Active Cell. The Formula Bar reveals the live formula =SUM(B2:D2)!",
      "viewBox": "0 0 660 280",
      "elements": [
        {
          "kind": "rect",
          "x": 18,
          "y": 14,
          "width": 624,
          "height": 252,
          "rx": 10,
          "fill": "#F8FAFC",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 26,
          "width": 108,
          "height": 32,
          "rx": 5,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 84,
          "y": 46,
          "text_hi": "Name Box: E2",
          "text_en": "Name Box: E2",
          "fill": "#92400E",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 148,
          "y": 26,
          "width": 482,
          "height": 32,
          "rx": 5,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.8
        },
        {
          "kind": "label",
          "x": 162,
          "y": 46,
          "text_hi": "fx  Formula Bar:   =SUM(B2:D2)",
          "text_en": "fx  Formula Bar:   =SUM(B2:D2)",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "start",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 74,
          "width": 48,
          "height": 30,
          "fill": "#E2E8F0",
          "stroke": "#94A3B8",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 78,
          "y": 74,
          "width": 120,
          "height": 30,
          "fill": "#DBEAFE",
          "stroke": "#60A5FA",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 198,
          "y": 74,
          "width": 108,
          "height": 30,
          "fill": "#DBEAFE",
          "stroke": "#60A5FA",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 306,
          "y": 74,
          "width": 108,
          "height": 30,
          "fill": "#DBEAFE",
          "stroke": "#60A5FA",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 414,
          "y": 74,
          "width": 108,
          "height": 30,
          "fill": "#DBEAFE",
          "stroke": "#60A5FA",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 522,
          "y": 74,
          "width": 108,
          "height": 30,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.4
        },
        {
          "kind": "label",
          "x": 138,
          "y": 94,
          "text_hi": "A",
          "text_en": "A",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 252,
          "y": 94,
          "text_hi": "B",
          "text_en": "B",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 360,
          "y": 94,
          "text_hi": "C",
          "text_en": "C",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 468,
          "y": 94,
          "text_hi": "D",
          "text_en": "D",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 576,
          "y": 94,
          "text_hi": "E",
          "text_en": "E",
          "fill": "#92400E",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 104,
          "width": 48,
          "height": 36,
          "fill": "#E2E8F0",
          "stroke": "#94A3B8",
          "strokeWidth": 1.2
        },
        {
          "kind": "label",
          "x": 54,
          "y": 126,
          "text_hi": "1",
          "text_en": "1",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 78,
          "y": 104,
          "width": 120,
          "height": 36,
          "fill": "#FFFFFF",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 198,
          "y": 104,
          "width": 108,
          "height": 36,
          "fill": "#FFFFFF",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 306,
          "y": 104,
          "width": 108,
          "height": 36,
          "fill": "#FFFFFF",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 414,
          "y": 104,
          "width": 108,
          "height": 36,
          "fill": "#FFFFFF",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 522,
          "y": 104,
          "width": 108,
          "height": 36,
          "fill": "#FFFFFF",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.2
        },
        {
          "kind": "label",
          "x": 138,
          "y": 126,
          "text_hi": "Student",
          "text_en": "Student",
          "fill": "#0F172A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 252,
          "y": 126,
          "text_hi": "Hindi",
          "text_en": "Hindi",
          "fill": "#0F172A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 360,
          "y": 126,
          "text_hi": "Math",
          "text_en": "Math",
          "fill": "#0F172A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 468,
          "y": 126,
          "text_hi": "Science",
          "text_en": "Science",
          "fill": "#0F172A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 576,
          "y": 126,
          "text_hi": "Total",
          "text_en": "Total",
          "fill": "#0F172A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 30,
          "y": 140,
          "width": 48,
          "height": 40,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.4
        },
        {
          "kind": "label",
          "x": 54,
          "y": 165,
          "text_hi": "2",
          "text_en": "2",
          "fill": "#92400E",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 78,
          "y": 140,
          "width": 120,
          "height": 40,
          "fill": "#FFFFFF",
          "stroke": "#CBD5E1",
          "strokeWidth": 1.2
        },
        {
          "kind": "rect",
          "x": 198,
          "y": 140,
          "width": 108,
          "height": 40,
          "fill": "#EFF6FF",
          "stroke": "#2563EB",
          "strokeWidth": 1.8
        },
        {
          "kind": "rect",
          "x": 306,
          "y": 140,
          "width": 108,
          "height": 40,
          "fill": "#EFF6FF",
          "stroke": "#2563EB",
          "strokeWidth": 1.8
        },
        {
          "kind": "rect",
          "x": 414,
          "y": 140,
          "width": 108,
          "height": 40,
          "fill": "#EFF6FF",
          "stroke": "#2563EB",
          "strokeWidth": 1.8
        },
        {
          "kind": "rect",
          "x": 522,
          "y": 140,
          "width": 108,
          "height": 40,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 3
        },
        {
          "kind": "rect",
          "x": 624,
          "y": 174,
          "width": 8,
          "height": 8,
          "fill": "#059669",
          "stroke": "#065F46",
          "strokeWidth": 1
        },
        {
          "kind": "label",
          "x": 138,
          "y": 165,
          "text_hi": "Aarav",
          "text_en": "Aarav",
          "fill": "#0F172A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 252,
          "y": 165,
          "text_hi": "78",
          "text_en": "78",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 360,
          "y": 165,
          "text_hi": "85",
          "text_en": "85",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 468,
          "y": 165,
          "text_hi": "82",
          "text_en": "82",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 576,
          "y": 165,
          "text_hi": "245",
          "text_en": "245",
          "fill": "#065F46",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 360,
          "y1": 215,
          "x2": 360,
          "y2": 184,
          "stroke": "#2563EB",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 320,
          "y": 230,
          "text_hi": "सेल रेंज (Cell Range: B2:D2)",
          "text_en": "Cell Range: B2:D2",
          "fill": "#1E3A8A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 576,
          "y1": 215,
          "x2": 576,
          "y2": 186,
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 560,
          "y": 230,
          "text_hi": "सक्रिय सेल E2 व Fill Handle",
          "text_en": "Active Cell E2 & Fill Handle",
          "fill": "#065F46",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### एक्सेल की 4 बुनियादी बातें (हर छात्र को आनी चाहिए!)\n1. **वर्कबुक (Workbook) बनाम वर्कशीट (Worksheet):** पूरी Excel फाइल (`.xlsx`) एक **किताब (Workbook)** है; उसके अंदर नीचे दिखने वाले `Sheet1, Sheet2` उसके **पन्ने (Worksheets)** हैं।\n2. **सेल एड्रेस (Cell Address):** कॉलम अक्षर + पंक्ति संख्या (जैसे `C4` = कॉलम C, पंक्ति 4)। ध्यान दें: `4C` गलत है, हमेशा `C4` सही है!\n3. **सेल रेंज (Cell Range):** लगातार सेलों के समूह को कोलन (`:`) से लिखते हैं। जैसे **`B2:D2`** का अर्थ है `B2, C2 और D2` तीनों सेल।\n4. **नेम बॉक्स (Name Box) व फॉर्मूला बार:** Name Box वर्तमान सक्रिय सेल (`E2`) का पता दिखाता है, और Formula Bar उस सेल के पीछे छिपा असली सूत्र (`=SUM(B2:D2)`) दिखाता है।",
    "concept_md_en": "### 4 Excel Foundations Every Student Must Know\n1. **Workbook vs Worksheet:** The entire `.xlsx` file is a **Workbook** (the whole register); individual pages (`Sheet1, Sheet2`) at the bottom are **Worksheets**.\n2. **Cell Address:** Column Letter + Row Number (e.g., `C4` = Column C, Row 4). Never write `4C` — letter ALWAYS comes first!\n3. **Cell Range:** A continuous group of cells written with a colon (`:`). For example, **`B2:D2`** means cells `B2, C2, and D2` together.\n4. **Name Box & Formula Bar:** Name Box shows the active cell address (`E2`), while Formula Bar reveals the real formula behind the calculated number (`=SUM(B2:D2)`).",
    "exam_tip_hi": "सबसे लोकप्रिय MCQ: \"MS Excel में रेंज `B2:D2` में दो सेलों के बीच किस चिह्न का उपयोग होता है?\" उत्तर: **कोलन (`:`)**। और \"MS Excel फाइल का एक्सटेंशन क्या है?\" → **`.xlsx`**!",
    "exam_tip_en": "Frequent MCQ: \"Which symbol defines a cell range like `B2:D2` in MS Excel?\" Answer: **Colon (`:`)**. And Excel's file extension is **`.xlsx`**!",
    "glossary_terms": [
      {
        "term_hi": "स्प्रेडशीट (Spreadsheet)",
        "term_en": "Spreadsheet",
        "pronunciation_hi": "स्प्रेडशीट",
        "definition_hi": "पंक्तियों और स्तंभों की ऐसी डिजिटल तालिका जिसमें संख्याओं पर स्वचालित गणना (Formulas) और चार्ट बनाए जाते हैं।",
        "definition_en": "A digital grid of rows and columns used for organizing data, running formulas, and drawing charts."
      },
      {
        "term_hi": "सक्रिय सेल (Active Cell)",
        "term_en": "Active Cell",
        "pronunciation_hi": "एक्टिव सेल",
        "definition_hi": "वह चुना हुआ सेल जिस पर मोटा हरा बॉर्डर दिखता है और जिसमें टाइप किया गया डेटा जाता है।",
        "definition_en": "The currently selected cell highlighted with a thick border where typed data or formulas go."
      }
    ],
    "quick_check": {
      "q_hi": "कॉलम `D` और पंक्ति `7` के कटान पर बने सेल का सही एड्रेस क्या होगा — `7D` या `D7`?",
      "q_en": "What is the exact cell address where Column `D` meets Row `7` — `7D` or `D7`?",
      "answer_hi": "**`D7`** (पहले हमेशा कॉलम अक्षर, फिर पंक्ति संख्या)!",
      "answer_en": "**`D7`** (always Column letter first, then Row number)!"
    }
  },
  {
    "id": "ict4-sec-2-formulas",
    "order": 2,
    "heading_hi": "2. सुनहरा \"=\" नियम और एक्सेल के 6 महाशक्ति फॉर्मूले",
    "heading_en": "2. The Golden \"=\" Rule & Excel's Top 6 Superpower Formulas",
    "analogy_hi": "एक्सेल में किसी भी फॉर्मूले के आगे **`=` (बराबर चिह्न)** लगाना बिल्कुल वैसा है जैसे सोते हुए दोस्त को जगाकर कहना — *\"अरे एक्सेल, जागो और हिसाब लगाओ!\"* यदि आप `=` नहीं लगाएँगे और सीधे `SUM(B2:D2)` लिख देंगे, तो एक्सेल उसे गणना नहीं बल्कि एक साधारण नाम समझकर वैसा ही छोड़ देगा!",
    "analogy_en": "Typing **`=` (equals sign)** first in Excel is like saying *\"Hey Excel, wake up and calculate!\"* Without `=`, Excel treats `SUM(B2:D2)` as plain text like your name and will NEVER calculate the answer!",
    "visual_diagram": {
      "type": "FORMULA_CARD",
      "title_hi": "MS Excel के 6 सबसे ज़रूरी फ़ंक्शन (मार्कशीट + बोर्ड परीक्षा के लिए पक्का)",
      "title_en": "6 Essential MS Excel Functions (Marksheet + Exam Mastery)",
      "formulas": [
        {
          "latex": "\\text{=SUM(B2:D2)}",
          "meaning_hi": "रेंज की सभी संख्याओं का कुल योग निकालता है",
          "meaning_en": "Adds all numbers in the given cell range",
          "unit": "Total",
          "example_hi": "78, 85, 82 का योग = 245",
          "example_en": "Total of 78, 85, 82 = 245"
        },
        {
          "latex": "\\text{=AVERAGE(B2:D2)}",
          "meaning_hi": "संख्याओं का औसत (माध्य / प्रतिशत) निकालता है",
          "meaning_en": "Calculates the arithmetic mean (average)",
          "unit": "Mean",
          "example_hi": "84, 90, 96 का औसत = 90",
          "example_en": "Average of 84, 90, 96 = 90"
        },
        {
          "latex": "\\text{=MAX(B2:B10)}",
          "meaning_hi": "पूरी सूची में सबसे बड़ी संख्या (Topper अंक) खोजता है",
          "meaning_en": "Finds the highest value (class topper score)",
          "unit": "Highest",
          "example_hi": "74, 92, 68 में MAX = 92",
          "example_en": "MAX of 74, 92, 68 = 92"
        },
        {
          "latex": "\\text{=MIN(B2:B10)}",
          "meaning_hi": "पूरी सूची में सबसे छोटी संख्या (न्यूनतम अंक) खोजता है",
          "meaning_en": "Finds the smallest value in the range",
          "unit": "Lowest",
          "example_hi": "74, 92, 68 में MIN = 68",
          "example_en": "MIN of 74, 92, 68 = 68"
        },
        {
          "latex": "\\text{=COUNT(B2:B10)}",
          "meaning_hi": "केवल संख्याओं (Numbers) वाले सेलों की गिनती करता है",
          "meaning_en": "Counts how many cells contain numbers (skips text/blanks)",
          "unit": "Count",
          "example_hi": "80, \"Absent\", 75, 90 → COUNT = 3",
          "example_en": "80, \"Absent\", 75, 90 → COUNT = 3"
        },
        {
          "latex": "\\text{=IF(B2}\\ge\\text{33, \"Pass\", \"Fail\")}",
          "meaning_hi": "शर्त सही हो तो पहला मान (\"Pass\"), गलत हो तो दूसरा (\"Fail\")",
          "meaning_en": "Returns \"Pass\" if condition is true, otherwise \"Fail\"",
          "unit": "Logic",
          "example_hi": "यदि B2 = 45 है → परिणाम = Pass",
          "example_en": "If B2 = 45 → Result = Pass"
        }
      ]
    },
    "concept_md_hi": "### सेल रेफरेंस का जादू (अंक बदलें → टोटल अपने आप बदले!)\n- सोचिए आपने `E2` में `=78+85+82` लिखा बनाम `=SUM(B2:D2)` लिखा। यदि बाद में शिक्षक को पता चले कि आरव के गणित में 85 नहीं 90 अंक हैं और वे `C2` में `90` लिखें, तो **`=SUM(B2:D2)` वाला टोटल अपने आप 245 से 250 बन जाएगा**!\n- **संख्याओं के चिह्न (Operators):** जोड़ `+`, घटाव `-`, गुणा `*` (स्टार चिह्न — `x` नहीं!), भाग `/` (स्लैश)।\n- **`COUNT` बनाम `COUNTA`:** `=COUNT(...)` केवल **अंकों (Numbers)** वाले सेल गिनता है (जैसे `\"Absent\"` को छोड़ देता है), जबकि `=COUNTA(...)` टेक्स्ट और अंक दोनों भरे सेल गिनता है!",
    "concept_md_en": "### The Magic of Cell References (Auto-Recalculation!)\n- Compare typing `=78+85+82` vs `=SUM(B2:D2)` inside `E2`. If the teacher later corrects Aarav's Math mark in `C2` from `85` to `90`, **`=SUM(B2:D2)` instantly updates from 245 to 250** automatically!\n- **Excel Math Operators:** Add `+`, Subtract `-`, Multiply `*` (asterisk — never `x`!), Divide `/` (forward slash).\n- **`COUNT` vs `COUNTA`:** `=COUNT(...)` counts ONLY **numeric** cells (ignoring `\"Absent\"` or blanks), while `=COUNTA(...)` counts all non-empty cells!",
    "exam_tip_hi": "सुपर-हॉट बोर्ड प्रश्न: \"MS Excel में हर फॉर्मूला किस चिह्न से शुरू होता है?\" उत्तर: **`=` (Equals sign)**। और गुणा करने के लिए **`*` (Asterisk)** उपयोग होता है!",
    "exam_tip_en": "Guaranteed Exam Question: \"Every formula in MS Excel MUST start with which symbol?\" Answer: **`=` (Equals sign)**. And multiplication uses **`*`**!",
    "glossary_terms": [
      {
        "term_hi": "फ़ंक्शन (Function)",
        "term_en": "Built-in Function",
        "pronunciation_hi": "फ़ंक्शन",
        "definition_hi": "एक्सेल में पहले से बना हुआ तैयार फॉर्मूला (जैसे SUM, AVERAGE, MAX, IF) जो जटिल गणना को 1 सेकंड में करता है।",
        "definition_en": "A ready-made built-in formula (like SUM, AVERAGE, MAX, IF) that performs calculations automatically."
      },
      {
        "term_hi": "सेल रेफरेंस (Cell Reference)",
        "term_en": "Cell Reference",
        "pronunciation_hi": "सेल रेफरेंस",
        "definition_hi": "फॉर्मूले में सीधी संख्या के बजाय सेल का पता (जैसे B2:D2) लिखना ताकि डेटा बदलने पर उत्तर अपने आप अपडेट हो।",
        "definition_en": "Using a cell address (like B2:D2) inside a formula so results automatically update whenever values change."
      }
    ],
    "quick_check": {
      "q_hi": "यदि सेल `B2=80`, `B3=\"Absent\"`, `B4=75` और `B5=90` हैं, तो `=COUNT(B2:B5)` का उत्तर क्या आएगा — 4 या 3?",
      "q_en": "If `B2=80`, `B3=\"Absent\"`, `B4=75`, and `B5=90`, what does `=COUNT(B2:B5)` return — 4 or 3?",
      "answer_hi": "**`3`** — क्योंकि `COUNT` केवल संख्याओं वाले सेलों को गिनता है और टेक्स्ट (`\"Absent\"`) को छोड़ देता है!",
      "answer_en": "**`3`** — because `COUNT` only counts numeric cells and skips text like `\"Absent\"`!"
    }
  },
  {
    "id": "ict4-sec-3-smart-tools",
    "order": 3,
    "heading_hi": "3. फिल हैंडल (+), सॉर्ट-फ़िल्टर और 1-क्लिक चार्ट्स",
    "heading_en": "3. Fill Handle (+), Sort & Filter, and 1-Click Charts",
    "analogy_hi": "मान लीजिए आपकी कक्षा में **60 छात्र** हैं — क्या आप 60 बार `=SUM(...)` टाइप करेंगे? बिल्कुल नहीं! बस पहले छात्र के टोटल सेल (`E2`) के **निचले दाएँ कोने के छोटे हरे चौकोर बिंदु (Fill Handle)** पर माउस ले जाएँ (वह पतला काला `+` बन जाएगा) और नीचे खींच दें — **1 सेकंड में सभी 60 छात्रों का टोटल तैयार!** बिल्कुल फोटोकॉपी मशीन जैसा!",
    "analogy_en": "Have **60 students** in your class? Never type `=SUM(...)` 60 times! Just point to the tiny square dot at the bottom-right corner of cell `E2` (**Fill Handle** — turns into a thin black `+`) and drag downward — **all 60 totals calculate in 1 second!**",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "एक्सेल के 6 स्मार्ट टूल जो घंटों का काम सेकंडों में करते हैं",
      "title_en": "6 Smart Excel Tools That Turn Hours of Work into Seconds",
      "caption_hi": "स्कूल रिजल्ट, छात्रवृत्ति सूची और मासिक बजट बनाने में ये 6 टूल्स सबसे ज़्यादा काम आते हैं।",
      "caption_en": "These 6 tools are the real secret behind fast school mark lists, scholarship rosters, and budgets.",
      "headers_hi": [
        "एक्सेल टूल",
        "कहाँ मिलता है?",
        "क्या काम करता है?",
        "स्कूल उदाहरण"
      ],
      "headers_en": [
        "Excel Tool",
        "Where to Find",
        "What It Does",
        "School Example"
      ],
      "rows": [
        {
          "cells_hi": [
            "AutoSum (Σ)",
            "Home / Formulas टैब",
            "1 क्लिक में ऊपर या बाएँ संख्याओं का =SUM जोड़ता है",
            "मार्कशीट के कुल अंक 1 सेकंड में निकालना"
          ],
          "cells_en": [
            "AutoSum (Σ)",
            "Home / Formulas Tab",
            "Inserts =SUM for adjacent numbers in 1 click",
            "Instant marksheet totals"
          ]
        },
        {
          "cells_hi": [
            "Fill Handle (+)",
            "सक्रिय सेल का निचला दायाँ कोना",
            "फॉर्मूला या क्रम (1,2,3 / Jan,Feb) नीचे खींचकर भरता है",
            "रोल नंबर 1–60 और सभी का योग 1 बार में भरना"
          ],
          "cells_en": [
            "Fill Handle (+)",
            "Bottom-right corner of Active Cell",
            "Auto-fills formulas or series (1,2,3 / Jan,Feb)",
            "Auto-fill Roll Nos 1–60 & all student totals"
          ]
        },
        {
          "cells_hi": [
            "Sort (A–Z / बड़ा→छोटा)",
            "Home / Data टैब",
            "सूची को आरोही (A–Z) या अवरोही (टॉपर ऊपर) सजाता है",
            "सबसे अधिक अंक पाने वाले छात्र को #1 पर लाना"
          ],
          "cells_en": [
            "Sort (A–Z / High→Low)",
            "Home / Data Tab",
            "Orders rows alphabetically or highest-to-lowest",
            "Ranking the class topper at row #1"
          ]
        },
        {
          "cells_hi": [
            "Filter (कीप चिह्न)",
            "Data टैब (Ctrl+Shift+L)",
            "केवल चुनी हुई शर्त वाले छात्र दिखाता है",
            "केवल \"Pass\" या केवल \"Class 10\" के छात्र देखना"
          ],
          "cells_en": [
            "Filter (Funnel Icon)",
            "Data Tab (Ctrl+Shift+L)",
            "Shows only rows matching your chosen condition",
            "Viewing only \"Pass\" or \"Section A\" students"
          ]
        },
        {
          "cells_hi": [
            "Charts (Bar / Pie)",
            "Insert टैब",
            "संख्याओं को रंगीन ग्राफ़ में बदलता है",
            "विषयवार औसत अंकों का बार ग्राफ़ बनाना"
          ],
          "cells_en": [
            "Charts (Bar / Pie)",
            "Insert Tab",
            "Turns tables into colorful visual graphs",
            "Bar chart of subject-wise marks"
          ]
        },
        {
          "cells_hi": [
            "Merge & Center",
            "Home टैब",
            "कई सेलों को मिलाकर एक बड़ा शीर्षक सेल बनाता है",
            "ऊपर \"BIHAR BOARD MARKSHEET\" बैनर बनाना"
          ],
          "cells_en": [
            "Merge & Center",
            "Home Tab",
            "Combines multiple cells into one centered title",
            "Creating top marksheet title banner"
          ]
        }
      ]
    },
    "concept_md_hi": "### चार्ट (Chart) कब कौन-सा चुनें?\n- **कॉलम / बार चार्ट (Column / Bar Chart):** अलग-अलग विषयों या छात्रों के अंकों की तुलना करने के लिए सबसे अच्छा!\n- **पाई चार्ट (Pie Chart):** 100% के हिस्से (प्रतिशत बँटवारा — जैसे घर के खर्च का कितना % शिक्षा, भोजन व किराए पर गया) दिखाने के लिए।\n- **लाइन चार्ट (Line Chart):** समय के साथ बदलाव (जैसे हर महीने के टेस्ट में आपका स्कोर कितना बढ़ा) दिखाने के लिए!\n\n**त्वरित शॉर्टकट:** पूरी शीट चुनने के लिए **`Ctrl + A`**, किसी छात्र का नाम खोजने के लिए **`Ctrl + F`**, और AutoSum के लिए **`Alt + =`**!",
    "concept_md_en": "### Which Chart Should You Pick?\n- **Column / Bar Chart:** Best for comparing marks across subjects or students!\n- **Pie Chart:** Best for showing percentage shares of a whole (e.g., how a family budget splits across food, books, and savings).\n- **Line Chart:** Best for tracking progress over time (e.g., your monthly test score growth)!\n\n**Speed Shortcuts:** **`Ctrl + A`** selects the table/sheet, **`Ctrl + F`** finds any student name, and **`Alt + =`** inserts AutoSum instantly!",
    "exam_tip_hi": "याद रखें: **AutoSum** का प्रतीक ग्रीक अक्षर **सिग्मा (`Σ`)** होता है और इसका शॉर्टकट **`Alt + =`** है!",
    "exam_tip_en": "Exam Shortcut: The **AutoSum** button displays the Greek Sigma symbol (**`Σ`**) and its keyboard shortcut is **`Alt + =`**!",
    "glossary_terms": [
      {
        "term_hi": "फिल हैंडल (Fill Handle)",
        "term_en": "Fill Handle",
        "pronunciation_hi": "फिल हैंडल",
        "definition_hi": "सक्रिय सेल के निचले दाएँ कोने का छोटा वर्ग जिसे खींचकर फॉर्मूला या गिनती स्वतः भरी जाती है।",
        "definition_en": "The tiny square at the bottom-right corner of an active cell dragged to auto-fill formulas or sequences."
      },
      {
        "term_hi": "फ़िल्टर (Filter)",
        "term_en": "Data Filter",
        "pronunciation_hi": "फ़िल्टर",
        "definition_hi": "बड़ी तालिका में से अन्य पंक्तियों को बिना मिटाए केवल चुनी हुई शर्त वाली पंक्तियाँ दिखाना।",
        "definition_en": "Temporarily hiding unmatched rows in a table to focus only on rows meeting a condition."
      }
    ],
    "quick_check": {
      "q_hi": "यदि आपको 60 छात्रों की सूची में सबसे ज़्यादा अंक लाने वाले टॉपर को सबसे ऊपर लाना है, तो आप Sort चुनेंगे या Merge & Center?",
      "q_en": "To move the highest-scoring topper to the top of a 60-student sheet, should you use Sort or Merge & Center?",
      "answer_hi": "**Sort (Largest to Smallest / Z to A)**!",
      "answer_en": "**Sort (Largest to Smallest)**!"
    }
  },
  {
    "id": "ict4-sec-4-errors",
    "order": 4,
    "heading_hi": "4. एक्सेल त्रुटियों (###, #NAME?, #DIV/0!, #VALUE!) से न डरें — 5 सेकंड में ठीक करें",
    "heading_en": "4. Never Fear Excel Errors (###, #NAME?, #DIV/0!, #VALUE!) — Fix in 5 Seconds",
    "analogy_hi": "जब सेल में अचानक **`######`** दिखने लगे, तो नए छात्र घबरा जाते हैं कि नंबर डिलीट हो गया! हँसिए — आपका डेटा सुरक्षित है! बस कॉलम ने **तंग शर्ट** पहन ली है जिसमें बड़ी संख्या समा नहीं पा रही! ऊपर कॉलम की रेखा पर **डबल-क्लिक** करें, शर्ट ढीली होगी और नंबर तुरंत चमक उठेगा!",
    "analogy_en": "When **`######`** suddenly appears in a cell, beginners panic thinking their number is gone! Smile — your number is totally safe! The column is just wearing a **tight shirt** too narrow to show it. Double-click the column edge to widen it and the number pops right back!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "स्कूल मार्कशीट बनाने से लेकर त्रुटि-मुक्त रिजल्ट प्रिंट करने के 4 चरण",
      "title_en": "4-Step Workflow to Build an Error-Free School Marksheet in Excel",
      "caption_hi": "त्रुटियों का तुरंत निदान: ### (कॉलम चौड़ा करें), #NAME? (फॉर्मूला स्पेलिंग सुधारें), #DIV/0! (0 से भाग हटाएँ), #VALUE! (संख्या की जगह लिखा टेक्स्ट हटाएँ)।",
      "caption_en": "Quick error doctor: ### (widen column), #NAME? (fix misspelled function), #DIV/0! (avoid dividing by 0), #VALUE! (remove text inside math formula).",
      "direction": "LR",
      "steps": [
        {
          "id": "e1",
          "label_hi": "1. डेटा तालिका भरें",
          "label_en": "1. Enter Raw Marks",
          "detail_hi": "पंक्ति 1 में शीर्षक (Student, Hindi, Math, Science) व नीचे अंक भरें।",
          "detail_en": "Put headers in Row 1 and student marks below.",
          "accent": "indigo"
        },
        {
          "id": "e2",
          "label_hi": "2. =SUM, =AVERAGE, =IF लगाएँ",
          "label_en": "2. Apply =SUM, =AVERAGE, =IF",
          "detail_hi": "पहली पंक्ति में = से फॉर्मूला लिखकर Enter दबाएँ।",
          "detail_en": "Type formulas starting with = in the first row and press Enter.",
          "accent": "amber"
        },
        {
          "id": "e3",
          "label_hi": "3. Fill Handle नीचे खींचें",
          "label_en": "3. Drag Fill Handle Down",
          "detail_hi": "एक सेकंड में पूरी कक्षा का Total और Pass/Fail तैयार!",
          "detail_en": "Auto-calculates every student's Total and Pass/Fail in 1 second!",
          "accent": "emerald"
        },
        {
          "id": "e4",
          "label_hi": "4. त्रुटि जाँचें, Chart व Save",
          "label_en": "4. Fix Errors, Chart & Save",
          "detail_hi": "### / #NAME? ठीक करें, Insert → Chart लगाएँ व Ctrl+S दबाएँ।",
          "detail_en": "Fix any ### / #NAME?, insert a Bar Chart, and Save (.xlsx).",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "e1",
          "to": "e2"
        },
        {
          "from": "e2",
          "to": "e3"
        },
        {
          "from": "e3",
          "to": "e4"
        }
      ]
    },
    "concept_md_hi": "### एक्सेल की 4 मुख्य त्रुटियाँ (1 नज़र में समाधान)\n1. **`######`:** कॉलम बहुत संकरा (Narrow) है → कॉलम हेडर की दाईं रेखा पर **डबल-क्लिक** कर चौड़ाई बढ़ाएँ।\n2. **`#NAME?`:** फ़ंक्शन की स्पेलिंग गलत है (जैसे `=SUMM(B2:D2)` या `=AVG` की जगह `=AVERAGE` होना चाहिए) → सही स्पेलिंग लिखें।\n3. **`#DIV/0!`:** किसी संख्या को शून्य (`0`) या खाली सेल से भाग दिया गया है (जैसे `=80/0`) → हर (Denominator) जाँचें।\n4. **`#VALUE!`:** गणितीय सूत्र में संख्या के साथ टेक्स्ट जोड़ दिया गया है (जैसे `=B2+\"Ram\"`) → केवल संख्यात्मक सेल चुनें।",
    "concept_md_en": "### 4 Common Excel Errors & Instant 5-Second Fixes\n1. **`######`:** Column is too narrow to display the value → **Double-click** the column border to auto-fit width.\n2. **`#NAME?`:** Misspelled function name (e.g., `=SUMM` instead of `=SUM`, or `=AVG` instead of `=AVERAGE`) → correct the spelling.\n3. **`#DIV/0!`:** Formula tried dividing by zero (`0`) or a blank cell → fix the denominator.\n4. **`#VALUE!`:** Tried doing arithmetic (`+`, `*`) with text (e.g., `=B2+\"Ram\"`) → ensure cells hold valid numbers.",
    "exam_tip_hi": "खास परीक्षा ट्रैप: औसत निकालने के लिए एक्सेल का सही फ़ंक्शन **`=AVERAGE(...)`** है (पूरा शब्द!), न कि `=AVG(...)`! `=AVG` लिखने पर `#NAME?` त्रुटि आती है!",
    "exam_tip_en": "Classic Exam Trap: Excel's exact average function is **`=AVERAGE(...)`** (full word!), NOT `=AVG(...)` — typing `=AVG` triggers `#NAME?`!",
    "glossary_terms": [
      {
        "term_hi": "फॉर्मूला बार (Formula Bar)",
        "term_en": "Formula Bar",
        "pronunciation_hi": "फॉर्मूला बार",
        "definition_hi": "एक्सेल ग्रिड के ठीक ऊपर की पट्टी जो सक्रिय सेल में लिखे गए असली सूत्र (=SUM आदि) को दिखाती और संपादित करने देती है।",
        "definition_en": "The bar above the spreadsheet grid showing and allowing edits to the actual formula inside the active cell."
      },
      {
        "term_hi": "#NAME? त्रुटि",
        "term_en": "#NAME? Error",
        "pronunciation_hi": "हैश-नेम एरर",
        "definition_hi": "वह संदेश जो तब आता है जब एक्सेल किसी गलत स्पेलिंग वाले फ़ंक्शन नाम (जैसे =SUMM या =AVG) को पहचान नहीं पाता।",
        "definition_en": "Error displayed when Excel cannot recognize a misspelled function name (such as =SUMM or =AVG)."
      }
    ],
    "quick_check": {
      "q_hi": "यदि किसी सेल में `=AVG(B2:D2)` लिखने पर `#NAME?` दिखने लगे, तो आप इसे ठीक करके क्या लिखेंगे?",
      "q_en": "If typing `=AVG(B2:D2)` displays `#NAME?`, what exact formula fixes it?",
      "answer_hi": "**`=AVERAGE(B2:D2)`** (एक्सेल में पूरा नाम `AVERAGE` उपयोग होता है)!",
      "answer_en": "**`=AVERAGE(B2:D2)`** (Excel requires the full word `AVERAGE`)!"
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{=SUM(B2:D2)}",
      "label_hi": "कुल योग (Total)",
      "label_en": "Total / Sum of Range"
    },
    {
      "latex": "\\text{=AVERAGE(B2:D2)}",
      "label_hi": "औसत (Mean — पूरा शब्द AVERAGE)",
      "label_en": "Average (full word AVERAGE)"
    },
    {
      "latex": "\\text{=MAX(B2:B10)},\\quad \\text{=MIN(B2:B10)}",
      "label_hi": "अधिकतम (Topper) व न्यूनतम अंक",
      "label_en": "Highest & Lowest Values"
    },
    {
      "latex": "\\text{=COUNT(B2:B10)},\\quad \\text{=IF(B2}\\ge\\text{33, \"Pass\", \"Fail\")}",
      "label_hi": "संख्या गिनती व Pass/Fail शर्त",
      "label_en": "Numeric Count & IF Condition"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "=",
      "fact_hi": "MS Excel में हर फॉर्मूला हमेशा `=` (बराबर) चिह्न से शुरू होता है।",
      "fact_en": "Every Excel formula must begin with the `=` sign."
    },
    {
      "tag": ".xlsx",
      "fact_hi": "MS Excel वर्कबुक का मानक एक्सटेंशन `.xlsx` है।",
      "fact_en": "Standard MS Excel workbook extension is `.xlsx`."
    },
    {
      "tag": "B2:D2",
      "fact_hi": "कोलन `:` लगातार सेल रेंज को दर्शाता है (B2 से D2 तक)।",
      "fact_en": "Colon `:` represents a continuous cell range (B2 through D2)."
    },
    {
      "tag": "AutoSum",
      "fact_hi": "AutoSum (Σ) का कीबोर्ड शॉर्टकट `Alt + =` होता है।",
      "fact_en": "AutoSum (Σ) keyboard shortcut is `Alt + =`."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "फॉर्मूले के आगे `=` लगाना भूल जाना (सीधे `SUM(B2:D2)` लिख देना)।",
      "mistake_en": "Forgetting `=` at the start of a formula (typing `SUM(B2:D2)`).",
      "fix_hi": "हमेशा सबसे पहले `=` टाइप करें: `=SUM(B2:D2)`।",
      "fix_en": "Always type `=` first: `=SUM(B2:D2)`."
    },
    {
      "mistake_hi": "औसत निकालने के लिए `=AVG(B2:D2)` लिख देना।",
      "mistake_en": "Writing `=AVG(B2:D2)` instead of `=AVERAGE(B2:D2)`.",
      "fix_hi": "एक्सेल में पूरा शब्द **`=AVERAGE(...)`** ही मान्य है, वरना `#NAME?` आएगा।",
      "fix_en": "Always write the full word **`=AVERAGE(...)`** to avoid `#NAME?`."
    },
    {
      "mistake_hi": "सेल एड्रेस में संख्या पहले लिखना (`2B`) या गुणा के लिए `x` लिखना।",
      "mistake_en": "Writing row before column (`2B`) or using `x` for multiplication.",
      "fix_hi": "सही एड्रेस **`B2`** है और एक्सेल में गुणा का चिह्न **`*`** है (`=B2*C2`)।",
      "fix_en": "Column always comes first (`B2`) and multiplication uses **`*`** (`=B2*C2`)."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "एक्सेल के 6 मुख्य फॉर्मूले (=SUM, =AVERAGE, =MAX, =MIN, =COUNT, =IF)",
      "topic_en": "6 Core Excel Formulas (=SUM, =AVERAGE, =MAX, =MIN, =COUNT, =IF)",
      "years": [
        "BSEB ICT Practical",
        "Objective"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "सेल एड्रेस, रेंज (B2:D2), Fill Handle और AutoSum",
      "topic_en": "Cell Address, Range (B2:D2), Fill Handle & AutoSum",
      "years": [
        "BSEB ICT Lab"
      ],
      "expected_marks": 4
    },
    {
      "topic_hi": "एक्सेल त्रुटियाँ (###, #NAME?, #DIV/0!, #VALUE!) और चार्ट्स",
      "topic_en": "Excel Errors (###, #NAME?, #DIV/0!, #VALUE!) & Charts",
      "years": [
        "BSEB ICT Viva"
      ],
      "expected_marks": 3
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 4,
  "analogy_count": 4,
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
  'skill-ict-ch4',
  3,
  'छात्र MS Excel के कॉलम, पंक्ति, सेल एड्रेस व रेंज को आत्मविश्वास से पहचान सकेंगे, 5 सहपाठियों की मार्कशीट बनाकर =SUM, =AVERAGE, =MAX, =MIN, =COUNT व =IF फॉर्मूले लगा सकेंगे, Fill Handle से स्वचालित गणना कर सकेंगे, एक बार-चार्ट बना सकेंगे और ### व #NAME? जैसी त्रुटियाँ ठीक कर सकेंगे।',
  'Students will navigate Excel columns, rows, cell addresses, and ranges, build a 5-student Bihar Board marksheet using =SUM, =AVERAGE, =MAX, =MIN, =COUNT, and =IF, drag the Fill Handle, generate a Bar Chart, and fix ### / #NAME? errors.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "हाज़िरी रजिस्टर = एक्सेल ग्रिड, सेल बिंगो और 5 छात्रों का डेटा भरना",
    "phase_en": "Attendance Register = Excel Grid, Cell Bingo & Entering 5-Student Data",
    "teacher_action_hi": "कक्षा का असली हाज़िरी रजिस्टर दिखाकर कॉलम (A,B,C) और पंक्ति (1,2,3) समझाएँ। 5 मिनट \"सेल बिंगो\" खेलें (\"सब लोग C3 पर क्लिक कर Name Box देखें!\")। फिर हर जोड़ी 5 दोस्तों के Hindi, Math, Science अंक भरवाएँ — दोनों छात्रों को बारी-बारी कीबोर्ड दें।",
    "teacher_action_en": "Hold up the real class attendance register to explain Columns and Rows. Play 5-minute \"Cell Bingo\" (\"Click C3 and verify the Name Box!\"). Then have each pair enter 5 classmates' Hindi, Math, and Science scores, swapping keyboard halfway.",
    "student_check_hi": "कमज़ोर छात्र से पूछें: \"कॉलम C और पंक्ति 4 के खाने को `4C` बोलेंगे या `C4`?\"",
    "student_check_en": "Ask a shy learner: \"Is the cell at Column C and Row 4 called `4C` or `C4`?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "सुनहरा \"=\" जादू: =SUM, =AVERAGE, =MAX, =MIN, =COUNT और =IF लाइव!",
    "phase_en": "Golden \"=\" Magic: Live =SUM, =AVERAGE, =MAX, =MIN, =COUNT & =IF",
    "teacher_action_hi": "पहले छात्र के लिए `=SUM(B2:D2)` और `=AVERAGE(B2:D2)` लगवाएँ। फिर जादू दिखाएँ: `C2` के गणित अंक बदलवाएँ और बच्चों को ताली बजाने दें जब Total अपने आप बदल जाए! इसके बाद Fill Handle (+) नीचे खींचकर सभी 5 छात्रों का Total, नीचे `=MAX`, `=MIN`, `=COUNT`, और पास-फेल के लिए `=IF(E2>=100,\"Pass\",\"Fail\")` बनवाएँ!",
    "teacher_action_en": "Guide pairs to type `=SUM(B2:D2)` and `=AVERAGE(B2:D2)` for Row 2. Trigger the \"Aha!\" moment: change cell `C2` and let students cheer as Total recalculates instantly! Drag the Fill Handle down, then compute `=MAX`, `=MIN`, `=COUNT`, and `=IF(E2>=100,\"Pass\",\"Fail\")`.",
    "student_check_hi": "पूछें: \"यदि कोई छात्र `=` लगाना भूल जाए और सीधे `SUM(B2:D2)` लिख दे तो क्या होगा?\"",
    "student_check_en": "Ask: \"What happens if someone forgets `=` and types `SUM(B2:D2)` directly?\""
  },
  {
    "period_no": 3,
    "duration_mins": 40,
    "phase_hi": "Sort से टॉपर रैंक, 1-क्लिक बार चार्ट और त्रुटि-सुधार चैलेंज",
    "phase_en": "Sort Topper Rank, 1-Click Bar Chart & Error-Doctor Challenge",
    "teacher_action_hi": "छात्रों से Total कॉलम पर Sort (Largest to Smallest) करवाकर टॉपर को ऊपर लाएँ। Student + Total चुनकर Insert → Bar Chart बनवाएँ। अंत में जानबूझकर 1 कॉलम पतला कर `###` और `=AVG` लिखकर `#NAME?` दिखवाएँ व उन्हें ठीक करवाएँ।",
    "teacher_action_en": "Have pairs Sort by Total (Largest to Smallest) to rank the topper #1, highlight Student + Total to insert a Bar Chart, and intentionally create then cure both `###` and `#NAME?` errors.",
    "student_check_hi": "मौखिक जाँच: \"यदि सेल में `######` दिखने लगे तो क्या नंबर मिट गया है? इसे कैसे ठीक करेंगे?\"",
    "student_check_en": "Oral check: \"If `######` appears in a cell, is your data lost? How do you fix it?\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड एक्सेल फॉर्मूला बॉक्स (6 महाशक्तियाँ)",
    "heading_en": "Blackboard Excel Formula Box (6 Superpowers)",
    "points_hi": [
      "गोल्डन नियम: हर फॉर्मूला `=` से शुरू होता है · गुणा = `*` · भाग = `/` · रेंज = `:`",
      "कुल योग: =SUM(B2:D2)   |   औसत: =AVERAGE(B2:D2)",
      "सबसे बड़ा: =MAX(B2:B10)   |   सबसे छोटा: =MIN(B2:B10)",
      "संख्या गिनती: =COUNT(B2:B10)   |   शर्त: =IF(B2>=33, \"Pass\", \"Fail\")"
    ],
    "points_en": [
      "Golden Rule: Every formula starts with `=` · Multiply = `*` · Divide = `/` · Range = `:`",
      "Total: =SUM(B2:D2)   |   Mean: =AVERAGE(B2:D2)",
      "Highest: =MAX(B2:B10)   |   Lowest: =MIN(B2:B10)",
      "Numeric Count: =COUNT(B2:B10)   |   Logic: =IF(B2>=33, \"Pass\", \"Fail\")"
    ]
  },
  {
    "heading_hi": "बिजली कटने पर ऑफलाइन बैकअप: \"कक्षा ही स्प्रेडशीट है!\"",
    "heading_en": "Offline / Power-Cut Backup: \"The Classroom IS a Spreadsheet!\"",
    "points_hi": [
      "बिना बिजली के कक्षा की 4 बेंच पंक्तियों को Row 1, 2, 3, 4 और 4 कतारों को Column A, B, C, D नाम दें — हर छात्र एक Cell है!",
      "शिक्षक पुकारें: \"सेल B2 खड़े हों और एक अंक बोलें (जैसे 80)!\" फिर C2 (90) और D2 (70) बोलें। अब पूरी कक्षा मिलकर `=SUM(B2:D2)` (240) और `=AVERAGE(B2:D2)` (80) निकाले!",
      "ब्लैकबोर्ड पर 4×5 की मार्कशीट खींचकर छात्रों से कॉपी में `=SUM`, `=MAX`, `=MIN` व `=IF` सूत्र लिखवाएँ।"
    ],
    "points_en": [
      "With zero power, turn the classroom benches into Rows 1–4 and Columns A–D — every student IS a live Excel Cell!",
      "Teacher calls: \"Cell B2 stand up and pick a score (80)!\" Repeat for C2 (90) and D2 (70). The whole class computes `=SUM(B2:D2)` = 240 and `=AVERAGE(B2:D2)` = 80!",
      "Draw a 4×5 marksheet on the board and have students write exact `=SUM`, `=MAX`, `=MIN`, and `=IF` formulas in their notebooks."
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "लैब जोड़ी मिशन: \"बिहार बोर्ड स्मार्ट मार्कशीट\"",
    "title_en": "ICT Lab Pair Mission: \"Smart Bihar Board Marksheet\"",
    "materials_hi": "लैब कंप्यूटर और Microsoft Excel",
    "materials_en": "Lab PC and Microsoft Excel",
    "steps_hi": "5 छात्रों के 3 विषयों के अंक भरें। `E2` में `=SUM(B2:D2)`, `F2` में `=AVERAGE(B2:D2)`, `G2` में `=IF(F2>=33,\"Pass\",\"Fail\")` लिखकर Fill Handle से सभी 5 पंक्तियों में खींचें। नीचे `=MAX` और `=MIN` निकालकर 1 कॉलम चार्ट बनाएँ!",
    "steps_en": "Enter 3 subject scores for 5 students. Write `=SUM(B2:D2)` in `E2`, `=AVERAGE(B2:D2)` in `F2`, and `=IF(F2>=33,\"Pass\",\"Fail\")` in `G2`, drag the Fill Handle down, compute `=MAX` and `=MIN` at bottom, and insert 1 Column Chart!"
  },
  {
    "title_hi": "ऑफलाइन खेल: \"एक्सेल एरर डॉक्टर\" (बिना बिजली)",
    "title_en": "Offline Game: \"Excel Error Doctor\" (No Power Needed)",
    "materials_hi": "ब्लैकबोर्ड पर लिखे 4 रोगी सेल",
    "materials_en": "4 \"sick\" Excel formulas written on the blackboard",
    "steps_hi": "बोर्ड पर लिखें: (1) `SUM(B2:D2)`, (2) `=AVG(B2:D2)`, (3) `=90/0`, (4) `######`। छात्रों को \"डॉक्टर\" बनकर हर बीमारी का कारण और 1-लाइन इलाज बताना है!",
    "steps_en": "Write 4 broken cells on the board: (1) `SUM(B2:D2)`, (2) `=AVG(B2:D2)`, (3) `=90/0`, (4) `######`. Students act as \"Excel Doctors\" to diagnose and prescribe the exact fix!"
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "(बिना कंप्यूटर गृहकार्य) अपनी कॉपी में 4 कॉलम (`A` से `D`) और 5 पंक्तियों की मार्कशीट बनाएँ (अपने 3 दोस्तों के काल्पनिक अंक भरें) और हर सेल का सही एड्रेस (`B2`, `C3` आदि) लिखकर `=SUM` और `=AVERAGE` फॉर्मूला लिखें।",
    "task_en": "(Zero-Computer Homework) Draw a 4-column (`A`–`D`) × 5-row marksheet in your notebook with 3 friends' scores and write exact `=SUM` and `=AVERAGE` formulas using cell addresses."
  },
  {
    "level": "BOARD",
    "task_hi": "एक्सेल की चार मुख्य त्रुटियाँ (`###`, `#NAME?`, `#DIV/0!`, `#VALUE!`) क्यों आती हैं और उन्हें कैसे ठीक करते हैं — तालिका बनाकर लिखें।",
    "task_en": "Make a clean table explaining why `###`, `#NAME?`, `#DIV/0!`, and `#VALUE!` occur in Excel and how to fix each."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "अपने परिवार का 5 मदों (राशन, बिजली, किताबें, यात्रा, बचत) का मासिक बजट कॉपी में Excel टेबल रूप में बनाएँ और कुल खर्च (`=SUM`), सबसे बड़ा खर्च (`=MAX`), और औसत खर्च (`=AVERAGE`) का सूत्र लिखें।",
    "task_en": "Design a 5-item family monthly budget in Excel table format in your notebook and write formulas for Total (`=SUM`), Highest Expense (`=MAX`), and Average (`=AVERAGE`)."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "कैलकुलेटर से जोड़कर उत्तर (245) सीधे सेल `E2` में टाइप कर देना ही एक्सेल चलाना है।",
    "misconception_en": "Adding numbers on a phone calculator and typing 245 directly into `E2` is the same as using Excel.",
    "correction_hi": "एक अंक बदलकर लाइव दिखाएँ कि सीधे `245` लिखने पर योग अपडेट नहीं होता, जबकि `=SUM(B2:D2)` 1 मिलीसेकंड में खुद सही उत्तर निकालता है!",
    "correction_en": "Edit one mark live to prove a hardcoded `245` turns wrong immediately, whereas `=SUM(B2:D2)` recalculates accurately every time!"
  },
  {
    "misconception_hi": "`=COUNT(B2:B5)` उस रेंज में लिखे टेक्स्ट (\"Absent\") को भी गिन लेगा।",
    "misconception_en": "`=COUNT(B2:B5)` counts text cells like \"Absent\" too.",
    "correction_hi": "स्पष्ट करें: `COUNT` केवल संख्याएँ गिनता है; टेक्स्ट व संख्या दोनों गिनने के लिए `COUNTA` होता है।",
    "correction_en": "Clarify: `COUNT` counts numbers ONLY; use `COUNTA` when you want to count both text and numbers."
  },
  {
    "misconception_hi": "सेल में `######` दिखने का मतलब फाइल खराब हो गई या फॉर्मूला गलत है।",
    "misconception_en": "Seeing `######` means the formula is broken or data was lost.",
    "correction_hi": "कॉलम बॉर्डर पर डबल-क्लिक करके दिखाएँ कि यह सिर्फ संकरे कॉलम की वजह से होता है — डेटा 100% सुरक्षित है।",
    "correction_en": "Double-click the column edge live to prove data is 100% safe and only needed more width."
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

-- Questions for skill-ict-ch4 (26 multi-mode items)
INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- #1: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000001', 'skill-ict-lab', 'skill-ict-ch4', 'Workbook, Worksheet & Cell Range', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'ICT Lab Core',
    'एक्सेल में वर्कबुक, वर्कशीट, सेल एड्रेस और सेल रेंज (B2:D2) क्या होते हैं?',
    'What are Workbook, Worksheet, Cell Address, and Cell Range (B2:D2) in MS Excel?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Workbook, Worksheet, Cell Address (B2) और Range (B2:D2) में क्या संबंध है?",
  "front_en": "How are Workbook, Worksheet, Cell Address (B2), and Range (B2:D2) related?",
  "back_hi": "Workbook = पूरी Excel फाइल (.xlsx)। Worksheet = उसके अंदर का एक पन्ना (Sheet1)। Cell Address = कॉलम + पंक्ति (B2)। Range = कोलन (:) से जुड़ा सेलों का समूह (B2:D2 = B2, C2, D2)।",
  "back_en": "Workbook = entire `.xlsx` file. Worksheet = single page (`Sheet1`) inside it. Cell Address = Column + Row (`B2`). Range = continuous group separated by colon (`B2:D2` = B2, C2, D2).",
  "pronunciation_hi": "वर्कबुक, वर्कशीट और सेल रेंज",
  "mnemonic_hi": "किताब (Workbook) → पन्ना (Worksheet) → खाना (Cell) → लगातार खाने (Range B2:D2)।",
  "mnemonic_en": "Book (Workbook) → Page (Worksheet) → Box (Cell) → Group (Range B2:D2)."
}$json$::jsonb, true
  ),
  -- #2: FLASHCARD (BOARD, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000002', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Error Messages', 'PRACTICE', 'FLASHCARD', 'BOARD', 'ICT Lab Core',
    'MS Excel में ###, #NAME? और #DIV/0! त्रुटियों का क्या अर्थ है?',
    'What do ###, #NAME?, and #DIV/0! errors mean in MS Excel?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "MS Excel में ###, #NAME? और #DIV/0! कब दिखते हैं और इनका समाधान क्या है?",
  "front_en": "Why do ###, #NAME?, and #DIV/0! appear in Excel, and how do you fix them?",
  "back_hi": "### = कॉलम संकरा है (कॉलम चौड़ा करें)। #NAME? = फ़ंक्शन की स्पेलिंग गलत है (जैसे =AVG की जगह =AVERAGE लिखें)। #DIV/0! = संख्या को 0 से भाग दिया गया है।",
  "back_en": "### = Column too narrow (widen column border). #NAME? = Misspelled function (write =AVERAGE instead of =AVG). #DIV/0! = Division by zero.",
  "pronunciation_hi": "हैश-नेम (#NAME?) और डिव-ज़ीरो (#DIV/0!)",
  "mnemonic_hi": "### = तंग शर्ट (चौड़ा करो) · #NAME? = नाम की स्पेलिंग सुधारो!",
  "mnemonic_en": "### = Tight column (widen it) · #NAME? = Fix misspelled function name!"
}$json$::jsonb, true
  ),
  -- #3: MATCH_PAIRS (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000003', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Functions Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB ICT Model',
    'MS Excel के फ़ंक्शन को उनके सटीक परिणाम से मिलाएँ:',
    'Match each MS Excel function with its exact purpose:',
    NULL, NULL,
    'अंग्रेज़ी शब्द के अर्थ से तुरंत पहचानें — SUM = जोड़, MAX = अधिकतम, MIN = न्यूनतम, COUNT = गिनती!', 'Each function name tells you its exact job: SUM, AVERAGE, MAX, COUNT!',
    '=SUM जोड़ता है, =AVERAGE औसत निकालता है, =MAX सबसे बड़ी संख्या खोजता है और =COUNT संख्यात्मक सेल गिनता है।', '=SUM totals numbers, =AVERAGE finds the mean, =MAX finds the largest value, and =COUNT counts numeric cells.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "हर एक्सेल फ़ंक्शन को उसके सही कार्य से मिलाएँ",
  "instruction_en": "Pair each Excel function with its exact output",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "=SUM(B2:D2)",
      "left_en": "=SUM(B2:D2)",
      "right_hi": "सभी चुने हुए अंकों का कुल योग निकालना",
      "right_en": "Add all selected marks together"
    },
    {
      "id": "p2",
      "left_hi": "=AVERAGE(B2:D2)",
      "left_en": "=AVERAGE(B2:D2)",
      "right_hi": "दिए गए अंकों का औसत (माध्य) निकालना",
      "right_en": "Calculate the average (mean) mark"
    },
    {
      "id": "p3",
      "left_hi": "=MAX(B2:B10)",
      "left_en": "=MAX(B2:B10)",
      "right_hi": "कक्षा में सबसे अधिक (Topper) अंक खोजना",
      "right_en": "Find the highest (topper) score"
    },
    {
      "id": "p4",
      "left_hi": "=COUNT(B2:B10)",
      "left_en": "=COUNT(B2:B10)",
      "right_hi": "केवल संख्या (Numbers) वाले सेलों को गिनना",
      "right_en": "Count only numeric cells in the range"
    }
  ]
}$json$::jsonb, true
  ),
  -- #4: DIAGRAM_LABEL (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000004', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Grid Anatomy', 'PRACTICE', 'DIAGRAM_LABEL', 'FOUNDATION', 'ICT Lab Practical',
    'MS Excel ग्रिड के चित्र में (1), (2), (3) और (4) भागों को सही नाम से पहचानें:',
    'Identify labeled parts (1), (2), (3), and (4) on this MS Excel spreadsheet grid:',
    NULL, NULL,
    'बाईं ऊपर सेल पता (Name Box), उसके दाएँ फॉर्मूला पट्टी (Formula Bar), बीच में अक्षर कॉलम हेडर (Column Header), और हरा बॉर्डर सक्रिय सेल (Active Cell) है!', 'Top-left is Name Box, top-right is Formula Bar, letters A–D are Column Headers, and the green-bordered box is the Active Cell!',
    '(1) Name Box (सक्रिय सेल पता दिखाता है), (2) Formula Bar (असली फॉर्मूला दिखाता है), (3) Column Header (`B`), और (4) Active Cell (`D2`) हैं।', '(1) Name Box, (2) Formula Bar, (3) Column Header (`B`), and (4) Active Cell (`D2`).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "DIAGRAM_LABEL",
  "instruction_hi": "एक्सेल ग्रिड के चारों नंबरों पर टैप करके सही नाम चुनें",
  "instruction_en": "Tap each numbered pin on the Excel grid and choose its exact name",
  "diagram": {
    "type": "SVG_DIAGRAM",
    "title_hi": "MS Excel ग्रिड के 4 मुख्य भाग पहचानें",
    "title_en": "Identify 4 Key Parts of the MS Excel Grid",
    "caption_hi": "बिंदु 1 से 4 पर टैप कर एक्सेल विंडो के भागों की पहचान करें।",
    "caption_en": "Tap pins 1 to 4 to label the Excel spreadsheet window.",
    "viewBox": "0 0 600 260",
    "elements": [
      {
        "kind": "rect",
        "x": 16,
        "y": 14,
        "width": 568,
        "height": 232,
        "rx": 10,
        "fill": "#F8FAFC",
        "stroke": "#1E3A8A",
        "strokeWidth": 2
      },
      {
        "kind": "rect",
        "x": 30,
        "y": 28,
        "width": 110,
        "height": 36,
        "rx": 5,
        "fill": "#FEF3C7",
        "stroke": "#D97706",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 85,
        "y": 50,
        "text_hi": "D2",
        "text_en": "D2",
        "fill": "#92400E",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 152,
        "y": 28,
        "width": 418,
        "height": 36,
        "rx": 5,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 2
      },
      {
        "kind": "label",
        "x": 250,
        "y": 50,
        "text_hi": "fx   =SUM(B2:C2)",
        "text_en": "fx   =SUM(B2:C2)",
        "fill": "#065F46",
        "fontSize": 12,
        "anchor": "start",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 30,
        "y": 82,
        "width": 50,
        "height": 34,
        "fill": "#E2E8F0",
        "stroke": "#94A3B8",
        "strokeWidth": 1.2
      },
      {
        "kind": "rect",
        "x": 80,
        "y": 82,
        "width": 122,
        "height": 34,
        "fill": "#DBEAFE",
        "stroke": "#3B82F6",
        "strokeWidth": 1.4
      },
      {
        "kind": "rect",
        "x": 202,
        "y": 82,
        "width": 122,
        "height": 34,
        "fill": "#DBEAFE",
        "stroke": "#3B82F6",
        "strokeWidth": 2
      },
      {
        "kind": "rect",
        "x": 324,
        "y": 82,
        "width": 122,
        "height": 34,
        "fill": "#DBEAFE",
        "stroke": "#3B82F6",
        "strokeWidth": 1.4
      },
      {
        "kind": "rect",
        "x": 446,
        "y": 82,
        "width": 124,
        "height": 34,
        "fill": "#DBEAFE",
        "stroke": "#3B82F6",
        "strokeWidth": 1.4
      },
      {
        "kind": "label",
        "x": 141,
        "y": 104,
        "text_hi": "A",
        "text_en": "A",
        "fill": "#1E3A8A",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 263,
        "y": 104,
        "text_hi": "B",
        "text_en": "B",
        "fill": "#1E3A8A",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 385,
        "y": 104,
        "text_hi": "C",
        "text_en": "C",
        "fill": "#1E3A8A",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 508,
        "y": 104,
        "text_hi": "D",
        "text_en": "D",
        "fill": "#1E3A8A",
        "fontSize": 13,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 30,
        "y": 116,
        "width": 50,
        "height": 42,
        "fill": "#E2E8F0",
        "stroke": "#94A3B8",
        "strokeWidth": 1.2
      },
      {
        "kind": "label",
        "x": 55,
        "y": 142,
        "text_hi": "1",
        "text_en": "1",
        "fill": "#334155",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 80,
        "y": 116,
        "width": 122,
        "height": 42,
        "fill": "#FFFFFF",
        "stroke": "#CBD5E1",
        "strokeWidth": 1.2
      },
      {
        "kind": "rect",
        "x": 202,
        "y": 116,
        "width": 122,
        "height": 42,
        "fill": "#FFFFFF",
        "stroke": "#CBD5E1",
        "strokeWidth": 1.2
      },
      {
        "kind": "rect",
        "x": 324,
        "y": 116,
        "width": 122,
        "height": 42,
        "fill": "#FFFFFF",
        "stroke": "#CBD5E1",
        "strokeWidth": 1.2
      },
      {
        "kind": "rect",
        "x": 446,
        "y": 116,
        "width": 124,
        "height": 42,
        "fill": "#FFFFFF",
        "stroke": "#CBD5E1",
        "strokeWidth": 1.2
      },
      {
        "kind": "label",
        "x": 141,
        "y": 142,
        "text_hi": "Name",
        "text_en": "Name",
        "fill": "#0F172A",
        "fontSize": 11,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 263,
        "y": 142,
        "text_hi": "Hindi",
        "text_en": "Hindi",
        "fill": "#0F172A",
        "fontSize": 11,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 385,
        "y": 142,
        "text_hi": "Math",
        "text_en": "Math",
        "fill": "#0F172A",
        "fontSize": 11,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "label",
        "x": 508,
        "y": 142,
        "text_hi": "Total",
        "text_en": "Total",
        "fill": "#0F172A",
        "fontSize": 11,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 30,
        "y": 158,
        "width": 50,
        "height": 46,
        "fill": "#E2E8F0",
        "stroke": "#94A3B8",
        "strokeWidth": 1.2
      },
      {
        "kind": "label",
        "x": 55,
        "y": 186,
        "text_hi": "2",
        "text_en": "2",
        "fill": "#334155",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      },
      {
        "kind": "rect",
        "x": 80,
        "y": 158,
        "width": 122,
        "height": 46,
        "fill": "#FFFFFF",
        "stroke": "#CBD5E1",
        "strokeWidth": 1.2
      },
      {
        "kind": "rect",
        "x": 202,
        "y": 158,
        "width": 122,
        "height": 46,
        "fill": "#EFF6FF",
        "stroke": "#93C5FD",
        "strokeWidth": 1.2
      },
      {
        "kind": "rect",
        "x": 324,
        "y": 158,
        "width": 122,
        "height": 46,
        "fill": "#EFF6FF",
        "stroke": "#93C5FD",
        "strokeWidth": 1.2
      },
      {
        "kind": "rect",
        "x": 446,
        "y": 158,
        "width": 124,
        "height": 46,
        "fill": "#ECFDF5",
        "stroke": "#059669",
        "strokeWidth": 3
      },
      {
        "kind": "label",
        "x": 141,
        "y": 186,
        "text_hi": "Rani",
        "text_en": "Rani",
        "fill": "#0F172A",
        "fontSize": 12,
        "anchor": "middle"
      },
      {
        "kind": "label",
        "x": 263,
        "y": 186,
        "text_hi": "82",
        "text_en": "82",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle"
      },
      {
        "kind": "label",
        "x": 385,
        "y": 186,
        "text_hi": "88",
        "text_en": "88",
        "fill": "#1E3A8A",
        "fontSize": 12,
        "anchor": "middle"
      },
      {
        "kind": "label",
        "x": 508,
        "y": 186,
        "text_hi": "170",
        "text_en": "170",
        "fill": "#065F46",
        "fontSize": 12,
        "anchor": "middle",
        "bold": true
      }
    ]
  },
  "hotspots": [
    {
      "id": "h1",
      "x": 56,
      "y": 46,
      "label_code": "1",
      "answer_hi": "नेम बॉक्स (Name Box)",
      "answer_en": "Name Box",
      "options_hi": [
        "नेम बॉक्स (Name Box)",
        "फॉर्मूला बार (Formula Bar)",
        "कॉलम हेडर (Column Header)",
        "सक्रिय सेल (Active Cell)"
      ],
      "options_en": [
        "Name Box",
        "Formula Bar",
        "Column Header",
        "Active Cell"
      ]
    },
    {
      "id": "h2",
      "x": 420,
      "y": 46,
      "label_code": "2",
      "answer_hi": "फॉर्मूला बार (Formula Bar)",
      "answer_en": "Formula Bar",
      "options_hi": [
        "नेम बॉक्स (Name Box)",
        "फॉर्मूला बार (Formula Bar)",
        "कॉलम हेडर (Column Header)",
        "सक्रिय सेल (Active Cell)"
      ],
      "options_en": [
        "Name Box",
        "Formula Bar",
        "Column Header",
        "Active Cell"
      ]
    },
    {
      "id": "h3",
      "x": 263,
      "y": 99,
      "label_code": "3",
      "answer_hi": "कॉलम हेडर (Column Header)",
      "answer_en": "Column Header",
      "options_hi": [
        "नेम बॉक्स (Name Box)",
        "फॉर्मूला बार (Formula Bar)",
        "कॉलम हेडर (Column Header)",
        "सक्रिय सेल (Active Cell)"
      ],
      "options_en": [
        "Name Box",
        "Formula Bar",
        "Column Header",
        "Active Cell"
      ]
    },
    {
      "id": "h4",
      "x": 508,
      "y": 181,
      "label_code": "4",
      "answer_hi": "सक्रिय सेल (Active Cell)",
      "answer_en": "Active Cell",
      "options_hi": [
        "नेम बॉक्स (Name Box)",
        "फॉर्मूला बार (Formula Bar)",
        "कॉलम हेडर (Column Header)",
        "सक्रिय सेल (Active Cell)"
      ],
      "options_en": [
        "Name Box",
        "Formula Bar",
        "Column Header",
        "Active Cell"
      ]
    }
  ]
}$json$::jsonb, true
  ),
  -- #5: SHORTCUT_STUDIO (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000005', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Select All Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'FOUNDATION', 'ICT Lab Hands-On',
    'एक्सेल मार्कशीट की पूरी तालिका को एक ही बार में चुनने (Select All) का शॉर्टकट दबाएँ:',
    'Press the MS Excel shortcut to Select All cells in your marksheet table at once:',
    NULL, NULL,
    'All शब्द के पहले अक्षर A को Ctrl के साथ दबाएँ!', 'Combine Ctrl with the first letter of All!',
    'MS Excel में `Ctrl + A` पूरी सक्रिय डेटा तालिका (या पूरी वर्कशीट) को एक झटके में चुन लेता है ताकि आप बॉर्डर या फॉन्ट एक साथ लगा सकें।', 'In MS Excel, `Ctrl + A` selects the entire active table (press again for the whole sheet) so you can format borders or fonts in one step.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "MS_EXCEL",
  "task_hi": "मार्कशीट की पूरी तालिका एक साथ चुनें (Select All)",
  "task_en": "Select the entire marksheet table at once (Select All)",
  "expected_keys": [
    "Ctrl",
    "A"
  ],
  "sample_doc_before": "Sheet1: Class10_Marks.xlsx (60 Students × 6 Columns)",
  "preview_effect": "SELECT_ALL",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "A",
    "F",
    "S",
    "C",
    "Z"
  ]
}$json$::jsonb, true
  ),
  -- #6: SHORTCUT_STUDIO (BOARD, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000006', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Find Shortcut', 'PRACTICE', 'SHORTCUT_STUDIO', 'BOARD', 'ICT Lab Hands-On',
    '200 छात्रों की एक्सेल सूची में से "Anjali Kumari" का नाम तुरंत खोजने (Find) का शॉर्टकट दबाएँ:',
    'Press the MS Excel shortcut to quickly Find "Anjali Kumari" inside a 200-student sheet:',
    NULL, NULL,
    'Find (खोजना) अक्षर F से शुरू होता है — Ctrl के साथ दबाएँ!', 'Find begins with F — press Ctrl + F!',
    '`Ctrl + F` तुरंत Find बॉक्स खोलता है जिससे आप सैकड़ों पंक्तियों के बीच 1 सेकंड में किसी भी छात्र का रोल नंबर या नाम खोज सकते हैं!', '`Ctrl + F` opens the Find box to locate any student name or roll number across hundreds of rows in 1 second!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SHORTCUT_STUDIO",
  "app_context": "MS_EXCEL",
  "task_hi": "200 छात्रों की शीट में \"Anjali Kumari\" को खोजने (Find) के लिए बॉक्स खोलें",
  "task_en": "Open the Find box to locate \"Anjali Kumari\" in the 200-row sheet",
  "expected_keys": [
    "Ctrl",
    "F"
  ],
  "sample_doc_before": "Sheet1: Bihar_School_Roster.xlsx (Rows 1–200)",
  "preview_effect": "FIND",
  "available_keys": [
    "Ctrl",
    "Shift",
    "Alt",
    "F",
    "A",
    "S",
    "P",
    "Z"
  ]
}$json$::jsonb, true
  ),
  -- #7: EXCEL_SANDBOX (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000007', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Sandbox — SUM', 'PRACTICE', 'EXCEL_SANDBOX', 'FOUNDATION', 'ICT Interactive Lab',
    'एक्सेल मिशन 1 (=SUM): सेल E2 में आरव के तीनों विषयों (Hindi, Math, Science — रेंज B2:D2) का कुल योग निकालें:',
    'Excel Mission 1 (=SUM): Compute Aarav''s Total marks across B2:D2 inside cell E2:',
    NULL, NULL,
    'हर फॉर्मूला `=` से शुरू होता है! `=SUM(` के अंदर रेंज `B2:D2` लिखकर `)` बंद करें।', 'Always start with `=`! Type `=SUM(B2:D2)` to add cells B2, C2, and D2.',
    '`=SUM(B2:D2)` सेलों `B2 (78) + C2 (85) + D2 (82)` को जोड़कर सटीक कुल योग **`245`** देता है!', '`=SUM(B2:D2)` adds `78 + 85 + 82` to return the exact total **`245`**!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "EXCEL_SANDBOX",
  "task_hi": "सेल E2 में आरव (Aarav) के तीनों विषयों (B2:D2) का कुल योग निकालने का फॉर्मूला लिखें",
  "task_en": "Write the Excel formula in cell E2 to find Aarav's Total marks across B2:D2",
  "columns": [
    "A",
    "B",
    "C",
    "D",
    "E"
  ],
  "rows": [
    [
      "Student",
      "Hindi",
      "Math",
      "Science",
      "Total"
    ],
    [
      "Aarav",
      78,
      85,
      82,
      ""
    ],
    [
      "Priya",
      84,
      90,
      96,
      270
    ],
    [
      "Rohan",
      65,
      70,
      75,
      210
    ]
  ],
  "target_cell": "E2",
  "highlight_range": [
    "B2",
    "C2",
    "D2"
  ],
  "accepted_formulas": [
    "=SUM(B2:D2)",
    "=B2+C2+D2"
  ],
  "expected_value": "245",
  "formula_chips": [
    "=SUM(",
    "B2:D2",
    ")",
    "=AVERAGE(",
    "B2+C2+D2"
  ]
}$json$::jsonb, true
  ),
  -- #8: EXCEL_SANDBOX (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000008', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Sandbox — AVERAGE', 'PRACTICE', 'EXCEL_SANDBOX', 'FOUNDATION', 'ICT Interactive Lab',
    'एक्सेल मिशन 2 (=AVERAGE): सेल E3 में प्रिया के तीनों विषयों (B3:D3) का औसत (Average) निकालें:',
    'Excel Mission 2 (=AVERAGE): Compute Priya''s Average marks across B3:D3 inside cell E3:',
    NULL, NULL,
    'एक्सेल में औसत के लिए पूरा शब्द `=AVERAGE(` उपयोग होता है (`=AVG` नहीं)!', 'Excel uses the full word `=AVERAGE(` (not `=AVG`) with range `B3:D3`!',
    '`=AVERAGE(B3:D3)` का मान $(84 + 90 + 96) / 3 = 270 / 3 =$ **`90`** आता है!', '`=AVERAGE(B3:D3)` evaluates $(84 + 90 + 96) / 3 = 270 / 3 =$ **`90`**!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "EXCEL_SANDBOX",
  "task_hi": "सेल E3 में प्रिया (Priya) के अंकों (B3:D3) का औसत निकालने के लिए फॉर्मूला लिखें",
  "task_en": "Write the Excel formula in cell E3 to calculate Priya's Average across B3:D3",
  "columns": [
    "A",
    "B",
    "C",
    "D",
    "E"
  ],
  "rows": [
    [
      "Student",
      "Hindi",
      "Math",
      "Science",
      "Average"
    ],
    [
      "Aarav",
      78,
      84,
      81,
      81
    ],
    [
      "Priya",
      84,
      90,
      96,
      ""
    ],
    [
      "Rohan",
      65,
      70,
      75,
      70
    ]
  ],
  "target_cell": "E3",
  "highlight_range": [
    "B3",
    "C3",
    "D3"
  ],
  "accepted_formulas": [
    "=AVERAGE(B3:D3)",
    "=(B3+C3+D3)/3"
  ],
  "expected_value": "90",
  "formula_chips": [
    "=AVERAGE(",
    "B3:D3",
    ")",
    "=SUM(",
    "=MAX("
  ]
}$json$::jsonb, true
  ),
  -- #9: EXCEL_SANDBOX (BOARD, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000009', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Sandbox — MAX', 'PRACTICE', 'EXCEL_SANDBOX', 'BOARD', 'ICT Interactive Lab',
    'एक्सेल मिशन 3 (=MAX): सेल B5 में गणित (Math) कॉलम (B2:B4) के सबसे अधिक (Topper) अंक खोजें:',
    'Excel Mission 3 (=MAX): Find the Highest Math score across B2:B4 inside cell B5:',
    NULL, NULL,
    'सबसे बड़ा मान खोजने के लिए `=MAX(` और कॉलम रेंज `B2:B4` का प्रयोग करें!', 'Use `=MAX(` with the vertical column range `B2:B4`!',
    '`=MAX(B2:B4)` संख्याओं 74, 92 और 68 में से सबसे बड़ी संख्या **`92`** (Deepak) को तुरंत खोज निकालता है!', '`=MAX(B2:B4)` scans 74, 92, and 68 and immediately returns the highest value **`92`**!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "EXCEL_SANDBOX",
  "task_hi": "सेल B5 में गणित के सबसे अधिक (Highest) अंक खोजने का फॉर्मूला लिखें (रेंज B2:B4)",
  "task_en": "Write the formula in B5 to find the Highest Math mark across B2:B4",
  "columns": [
    "A",
    "B",
    "C"
  ],
  "rows": [
    [
      "Student",
      "Math",
      "Science"
    ],
    [
      "Anjali",
      74,
      81
    ],
    [
      "Deepak",
      92,
      88
    ],
    [
      "Suman",
      68,
      79
    ],
    [
      "Highest",
      "",
      88
    ]
  ],
  "target_cell": "B5",
  "highlight_range": [
    "B2",
    "B3",
    "B4"
  ],
  "accepted_formulas": [
    "=MAX(B2:B4)"
  ],
  "expected_value": "92",
  "formula_chips": [
    "=MAX(",
    "B2:B4",
    ")",
    "=MIN(",
    "=SUM("
  ]
}$json$::jsonb, true
  ),
  -- #10: EXCEL_SANDBOX (BOARD, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000010', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Sandbox — MIN', 'PRACTICE', 'EXCEL_SANDBOX', 'BOARD', 'ICT Interactive Lab',
    'एक्सेल मिशन 4 (=MIN): सेल B5 में गणित (Math) कॉलम (B2:B4) के सबसे कम (Lowest) अंक खोजें:',
    'Excel Mission 4 (=MIN): Find the Lowest Math score across B2:B4 inside cell B5:',
    NULL, NULL,
    'न्यूनतम मान खोजने के लिए `=MIN(` फ़ंक्शन और रेंज `B2:B4` लगाएँ!', 'Use `=MIN(` on range `B2:B4` to find the smallest number!',
    '`=MIN(B2:B4)` संख्याओं 74, 92 और 68 में से सबसे छोटी संख्या **`68`** को निकालता है!', '`=MIN(B2:B4)` scans 74, 92, and 68 and returns the minimum value **`68`**!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "EXCEL_SANDBOX",
  "task_hi": "सेल B5 में गणित के सबसे कम (Lowest) अंक खोजने का फॉर्मूला लिखें (रेंज B2:B4)",
  "task_en": "Write the formula in B5 to find the Lowest Math mark across B2:B4",
  "columns": [
    "A",
    "B",
    "C"
  ],
  "rows": [
    [
      "Student",
      "Math",
      "Science"
    ],
    [
      "Anjali",
      74,
      81
    ],
    [
      "Deepak",
      92,
      88
    ],
    [
      "Suman",
      68,
      79
    ],
    [
      "Lowest",
      "",
      79
    ]
  ],
  "target_cell": "B5",
  "highlight_range": [
    "B2",
    "B3",
    "B4"
  ],
  "accepted_formulas": [
    "=MIN(B2:B4)"
  ],
  "expected_value": "68",
  "formula_chips": [
    "=MIN(",
    "B2:B4",
    ")",
    "=MAX(",
    "=COUNT("
  ]
}$json$::jsonb, true
  ),
  -- #11: EXCEL_SANDBOX (TOPPER, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000011', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Sandbox — COUNT', 'PRACTICE', 'EXCEL_SANDBOX', 'TOPPER', 'ICT Interactive Lab',
    'एक्सेल मिशन 5 (=COUNT): सेल B6 में गिनें कि रेंज B2:B5 में कुल कितने छात्रों ने परीक्षा देकर संख्यात्मक अंक पाए ("Absent" को छोड़कर):',
    'Excel Mission 5 (=COUNT): In cell B6, count how many students in B2:B5 have numeric test marks (automatically skipping "Absent"):',
    NULL, NULL,
    '`=COUNT(B2:B5)` केवल संख्या वाले सेलों को गिनता है और टेक्स्ट ("Absent") को छोड़ देता है!', '`=COUNT(B2:B5)` counts only numeric entries and skips text like "Absent"!',
    'रेंज `B2:B5` में `80`, `"Absent"`, `75`, `90` हैं। `=COUNT(B2:B5)` केवल 3 संख्यात्मक सेलों (`80, 75, 90`) को गिनकर उत्तर **`3`** देता है!', 'In `B2:B5` (`80`, `"Absent"`, `75`, `90`), `=COUNT(B2:B5)` counts only the 3 numeric cells and returns **`3`**!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "EXCEL_SANDBOX",
  "task_hi": "सेल B6 में केवल संख्यात्मक अंक पाने वाले छात्रों की संख्या गिनने के लिए फॉर्मूला लिखें (B2:B5)",
  "task_en": "Write the formula in B6 to count numeric marks only across B2:B5",
  "columns": [
    "A",
    "B"
  ],
  "rows": [
    [
      "Student",
      "Test Marks"
    ],
    [
      "Kajal",
      80
    ],
    [
      "Vikash",
      "Absent"
    ],
    [
      "Neha",
      75
    ],
    [
      "Rahul",
      90
    ],
    [
      "Present Count",
      ""
    ]
  ],
  "target_cell": "B6",
  "highlight_range": [
    "B2",
    "B3",
    "B4",
    "B5"
  ],
  "accepted_formulas": [
    "=COUNT(B2:B5)"
  ],
  "expected_value": "3",
  "formula_chips": [
    "=COUNT(",
    "B2:B5",
    ")",
    "=SUM(",
    "=MAX("
  ]
}$json$::jsonb, true
  ),
  -- #12: EXCEL_SANDBOX (TOPPER, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000012', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Sandbox — IF', 'PRACTICE', 'EXCEL_SANDBOX', 'TOPPER', 'ICT Interactive Lab',
    'एक्सेल मिशन 6 (=IF): सेल C2 में रवि (B2 = 45) के लिए Pass/Fail नियम लगाएँ — यदि अंक 33 या अधिक हों (`B2>=33`) तो `"Pass"`, वरना `"Fail"`:',
    'Excel Mission 6 (=IF): In cell C2, write an IF formula for Ravi (B2 = 45) returning `"Pass"` if `B2>=33`, else `"Fail"`:',
    NULL, NULL,
    'क्रम याद रखें: `=IF(शर्त, "Pass", "Fail")` → यहाँ शर्त है `B2>=33`!', 'Follow the pattern: `=IF(condition, "Pass", "Fail")` where condition is `B2>=33`!',
    'चूँकि रवि के अंक `B2 = 45` हैं और `45 >= 33` सत्य (True) है, इसलिए `=IF(B2>=33,"Pass","Fail")` तुरंत **`Pass`** दिखाता है!', 'Because `B2 = 45` satisfies `45 >= 33`, `=IF(B2>=33,"Pass","Fail")` outputs **`Pass`**!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "EXCEL_SANDBOX",
  "task_hi": "सेल C2 में B2>=33 होने पर \"Pass\" और कम होने पर \"Fail\" दिखाने का =IF फॉर्मूला बनाएँ",
  "task_en": "Write an =IF formula in C2 returning \"Pass\" when B2>=33 and \"Fail\" otherwise",
  "columns": [
    "A",
    "B",
    "C"
  ],
  "rows": [
    [
      "Student",
      "Marks",
      "Result"
    ],
    [
      "Ravi",
      45,
      ""
    ],
    [
      "Meena",
      28,
      "Fail"
    ],
    [
      "Suresh",
      62,
      "Pass"
    ]
  ],
  "target_cell": "C2",
  "highlight_range": [
    "B2"
  ],
  "accepted_formulas": [
    "=IF(B2>=33,\"Pass\",\"Fail\")",
    "=IF(B2>=33, \"Pass\", \"Fail\")"
  ],
  "expected_value": "Pass",
  "formula_chips": [
    "=IF(",
    "B2>=33,",
    "\"Pass\",",
    "\"Fail\"",
    ")"
  ]
}$json$::jsonb, true
  ),
  -- #13: SCENARIO_LAB (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000013', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Toolbar Detective', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', 'ICT Lab Practical',
    'एक्सेल टूलबार जासूस: आप बिना टाइप किए 1 क्लिक में पूरे कॉलम की संख्याओं का योग (`=SUM`) निकालना चाहते हैं। कौन-सा टूलबार आइकन चुनेंगे?',
    'Excel Toolbar Detective: You want to sum an entire column of marks in 1 single click without typing `=SUM`. Which toolbar button will you click?',
    NULL, NULL,
    'गणित में योग को दिखाने वाला ग्रीक प्रतीक सिग्मा (Σ) पहचानें!', 'Look for the Greek Sigma (Σ) symbol used for summation!',
    'AutoSum (Σ) बटन 1 क्लिक में आस-पास की संख्याओं की रेंज पहचानकर अपने आप `=SUM(...)` लगा देता है!', 'The AutoSum (Σ) icon automatically detects adjacent numeric cells and inserts `=SUM(...)` in one click!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "RIBBON_DETECTIVE",
  "scene_title_hi": "MS Excel टूलबार जासूस — 1-क्लिक योग निकालें",
  "scene_title_en": "MS Excel Toolbar Detective — 1-Click Total Marks",
  "prompt_hi": "आपका कर्सर 10 छात्रों के अंकों के ठीक नीचे खाली सेल B12 में है। 1 क्लिक में कुल योग निकालने के लिए सही एक्सेल बटन चुनें:",
  "prompt_en": "Your active cell is B12 right below 10 student scores. Pick the exact Excel toolbar icon to sum them in 1 click:",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "Filter",
      "label_hi": "Filter (डेटा छानना)",
      "label_en": "Filter Data"
    },
    {
      "id": "c2",
      "icon": "SortAsc",
      "label_hi": "Sort A–Z (क्रम में सजाना)",
      "label_en": "Sort A–Z"
    },
    {
      "id": "c3",
      "icon": "BarChart3",
      "label_hi": "Insert Chart (ग्राफ़ बनाना)",
      "label_en": "Insert Chart"
    },
    {
      "id": "c4",
      "icon": "Sigma",
      "label_hi": "AutoSum Σ (स्वचालित योग)",
      "label_en": "AutoSum (Σ)"
    }
  ],
  "correct_choice_id": "c4"
}$json$::jsonb, true
  ),
  -- #14: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000014', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Golden Rule', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB ICT Model',
    'MS Excel में हर फॉर्मूला अनिवार्य रूप से किस चिह्न से शुरू होता है?',
    'Every formula in MS Excel MUST start with which symbol?',
    $json$[{"key":"A","text_hi":"# (हैश)","text_en":"# (Hash)"},{"key":"B","text_hi":"= (बराबर)","text_en":"= (Equals sign)"},{"key":"C","text_hi":"@ (ऐट द रेट)","text_en":"@ (At sign)"},{"key":"D","text_hi":"$ (डॉलर)","text_en":"$ (Dollar)"}]$json$::jsonb, 'B',
    'गणित में उत्तर लिखने से पहले कौन-सा चिह्न लगाते हैं?', 'Which symbol tells Excel to wake up and evaluate the expression?',
    'MS Excel में हर सूत्र हमेशा `=` चिह्न से शुरू होता है (जैसे `=SUM(B2:D2)`), अन्यथा एक्सेल उसे साधारण टेक्स्ट मान लेता है।', 'Every Excel formula starts with `=` (e.g., `=SUM(B2:D2)`), otherwise Excel treats it as plain text.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #15: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000015', 'skill-ict-lab', 'skill-ict-ch4', 'Cell Address Basics', 'PRACTICE', 'MCQ', 'FOUNDATION', 'ICT Lab Core',
    'एक्सेल वर्कशीट में कॉलम `C` और पंक्ति (Row) `5` के मिलन बिंदु को किस सेल एड्रेस से जाना जाएगा?',
    'What is the cell address where Column `C` intersects Row `5` in an Excel sheet?',
    $json$[{"key":"A","text_hi":"5C","text_en":"5C"},{"key":"B","text_hi":"5:C","text_en":"5:C"},{"key":"C","text_hi":"C-5","text_en":"C-5"},{"key":"D","text_hi":"C5","text_en":"C5"}]$json$::jsonb, 'D',
    'हमेशा कॉलम अक्षर पहले और पंक्ति संख्या उसके ठीक बाद लिखते हैं!', 'Always write the Column letter first followed immediately by the Row number!',
    'एक्सेल सेल एड्रेस हमेशा Column + Row क्रम में लिखा जाता है, इसलिए कॉलम C और पंक्ति 5 का पता **`C5`** है।', 'Excel addresses always follow Column-then-Row order, making the intersection **`C5`**.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #16: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000016', 'skill-ict-lab', 'skill-ict-ch4', 'Excel File Extension', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'MS Excel वर्कबुक फाइल का मानक एक्सटेंशन क्या होता है?',
    'What is the default file extension of a modern MS Excel workbook?',
    $json$[{"key":"A","text_hi":".docx","text_en":".docx"},{"key":"B","text_hi":".pptx","text_en":".pptx"},{"key":"C","text_hi":".xlsx","text_en":".xlsx"},{"key":"D","text_hi":".txt","text_en":".txt"}]$json$::jsonb, 'C',
    'Excel शब्द की ध्वनि "एक्स-एल" (X-L) से पहचानें!', 'Look for the "xl" letters from Excel!',
    'MS Excel फाइलों का मानक एक्सटेंशन `.xlsx` होता है।', 'Modern Microsoft Excel workbooks use the `.xlsx` extension.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #17: MCQ (BOARD, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000017', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Multiplication Operator', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'यदि सेल `A2` में किताब की कीमत `120` और `B2` में संख्या `5` है, तो कुल राशि निकालने का सही एक्सेल फॉर्मूला क्या है?',
    'If cell `A2` holds book price `120` and `B2` holds quantity `5`, which Excel formula calculates the total cost?',
    $json$[{"key":"A","text_hi":"=A2 * B2","text_en":"=A2 * B2"},{"key":"B","text_hi":"=A2 x B2","text_en":"=A2 x B2"},{"key":"C","text_hi":"A2 * B2","text_en":"A2 * B2"},{"key":"D","text_hi":"=A2 / B2","text_en":"=A2 / B2"}]$json$::jsonb, 'A',
    'पहला चिह्न `=` होना चाहिए और गुणा के लिए स्टार (`*`) चिह्न उपयोग होता है!', 'Must begin with `=` and use the asterisk (`*`) for multiplication!',
    'एक्सेल में गुणा करने का सही प्रतीक `*` है और फॉर्मूला `=` से शुरू होना चाहिए — अतः `=A2 * B2` सटीक उत्तर `600` देगा।', 'Excel uses `*` for multiplication and requires leading `=`, so `=A2 * B2` cleanly returns `600`.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #18: MCQ (BOARD, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000018', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Error ###', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'यदि किसी एक्सेल सेल में संख्या के बजाय `######` दिखाई देने लगे, तो इसका क्या कारण है?',
    'If an Excel cell suddenly displays `######` instead of your number, what is the reason?',
    $json$[{"key":"A","text_hi":"संख्या डिलीट हो गई है","text_en":"The number was deleted"},{"key":"B","text_hi":"कंप्यूटर में वायरस आ गया है","text_en":"The computer has a virus"},{"key":"C","text_hi":"कॉलम की चौड़ाई संख्या दिखाने के लिए कम है","text_en":"The column width is too narrow to display the number"},{"key":"D","text_hi":"संख्या को शून्य से भाग दिया गया है","text_en":"The number was divided by zero"}]$json$::jsonb, 'C',
    '"तंग शर्ट" वाला उदाहरण याद करें — बस कॉलम की रेखा पर डबल-क्लिक करना है!', 'Remember the "tight shirt" analogy — just widen the column!',
    '`######` का अर्थ केवल इतना है कि कॉलम की चौड़ाई कम है। कॉलम की दाईं सीमा पर डबल-क्लिक करते ही पूरा अंक साफ दिखने लगता है।', '`######` simply means the column is too narrow; double-clicking the column edge immediately reveals the full number.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #19: MCQ (BOARD, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000019', 'skill-ict-lab', 'skill-ict-ch4', 'Excel AVERAGE Function', 'PRACTICE', 'MCQ', 'BOARD', NULL,
    'सेलों `B2` से `F2` तक का औसत निकालने के लिए इनमें से कौन-सा एक्सेल फ़ंक्शन 100% सही है?',
    'Which Excel function correctly calculates the average of cells `B2` through `F2`?',
    $json$[{"key":"A","text_hi":"=AVG(B2:F2)","text_en":"=AVG(B2:F2)"},{"key":"B","text_hi":"=AVERAGE(B2:F2)","text_en":"=AVERAGE(B2:F2)"},{"key":"C","text_hi":"=MEAN(B2:F2)","text_en":"=MEAN(B2:F2)"},{"key":"D","text_hi":"AVERAGE(B2-F2)","text_en":"AVERAGE(B2-F2)"}]$json$::jsonb, 'B',
    'एक्सेल `=AVG` या `=MEAN` को नहीं पहचानता — पूरा शब्द और कोलन (`:`) चुनें!', 'Excel rejects `=AVG` and `=MEAN` — pick the full word with a colon `:`!',
    'एक्सेल में औसत के लिए पूरा नाम `=AVERAGE(B2:F2)` अनिवार्य है। `=AVG` लिखने पर `#NAME?` त्रुटि आती है।', 'Excel requires the full word `=AVERAGE(B2:F2)`. Writing `=AVG` produces a `#NAME?` error.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #20: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000020', 'skill-ict-lab', 'skill-ict-ch4', 'Excel IF Logic Output', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB ICT Model',
    'यदि सेल `C2` का मान `29` है, तो फॉर्मूला `=IF(C2>=33, "Pass", "Fail")` का परिणाम क्या होगा?',
    'If cell `C2` holds the value `29`, what will the formula `=IF(C2>=33, "Pass", "Fail")` output?',
    $json$[{"key":"A","text_hi":"Fail","text_en":"Fail"},{"key":"B","text_hi":"Pass","text_en":"Pass"},{"key":"C","text_hi":"33","text_en":"33"},{"key":"D","text_hi":"#DIV/0!","text_en":"#DIV/0!"}]$json$::jsonb, 'A',
    'जाँचें: क्या `29 >= 33` सत्य (True) है या असत्य (False)? असत्य होने पर दूसरा विकल्प चुना जाता है!', 'Check: is `29 >= 33` True or False? When False, IF returns the second argument!',
    'चूँकि `29 >= 33` असत्य (False) है, इसलिए `=IF` दूसरा मान **`Fail`** लौटाता है।', 'Since `29 >= 33` evaluates to False, the `=IF` function returns the second value: **`Fail`**.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #21: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000021', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Fill Handle Behavior', 'PRACTICE', 'MCQ', 'TOPPER', NULL,
    'यदि सेल `E2` में फॉर्मूला `=SUM(B2:D2)` लिखा है और आप Fill Handle (+) पकड़कर उसे `E3` तक नीचे खींचते हैं, तो `E3` में कौन-सा फॉर्मूला अपने आप बन जाएगा?',
    'If cell `E2` contains `=SUM(B2:D2)` and you drag its Fill Handle (+) down to `E3`, what formula automatically appears in `E3`?',
    $json$[{"key":"A","text_hi":"=SUM(B2:D2)","text_en":"=SUM(B2:D2)"},{"key":"B","text_hi":"#NAME?","text_en":"#NAME?"},{"key":"C","text_hi":"=SUM(C2:E2)","text_en":"=SUM(C2:E2)"},{"key":"D","text_hi":"=SUM(B3:D3)","text_en":"=SUM(B3:D3)"}]$json$::jsonb, 'D',
    'एक पंक्ति नीचे जाने पर Relative Reference में पंक्ति संख्या `2` बढ़कर `3` हो जाती है!', 'Moving down 1 row shifts relative row numbers from `2` to `3` automatically!',
    'Relative Cell Reference के कारण एक पंक्ति नीचे खींचने पर `B2:D2` अपने आप अगली पंक्ति के लिए `=SUM(B3:D3)` बन जाता है!', 'Due to Relative Cell Referencing, dragging down 1 row automatically adjusts `=SUM(B2:D2)` to `=SUM(B3:D3)`.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #22: MCQ (FOUNDATION, EXAM_ONLY)
  (
    '10000005-0004-4000-8000-000000000022', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Range Symbol', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'ICT Live Exam',
    'एक्सेल में सेल `A1` से `A10` तक की लगातार रेंज दर्शाने के लिए किस चिह्न का उपयोग होता है?',
    'Which punctuation symbol is used in Excel to write a continuous range from `A1` through `A10`?',
    $json$[{"key":"A","text_hi":"सेमीकोलन (;) → A1;A10","text_en":"Semicolon (;) → A1;A10"},{"key":"B","text_hi":"कोलन (:) → A1:A10","text_en":"Colon (:) → A1:A10"},{"key":"C","text_hi":"डैश (-) → A1-A10","text_en":"Hyphen (-) → A1-A10"},{"key":"D","text_hi":"स्लैश (/) → A1/A10","text_en":"Slash (/) → A1/A10"}]$json$::jsonb, 'B',
    'दो ऊपर-नीचे बिंदु (:) लगातार रेंज बताते हैं!', 'Two stacked dots (:) mean "through" in Excel ranges!',
    'एक्सेल में लगातार सेल रेंज हमेशा कोलन `:` से लिखी जाती है (`A1:A10`)।', 'A continuous cell range in Excel always uses a colon `:` (`A1:A10`).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #23: MCQ (BOARD, EXAM_ONLY)
  (
    '10000005-0004-4000-8000-000000000023', 'skill-ict-lab', 'skill-ict-ch4', 'Excel AutoSum Shortcut', 'EXAM_ONLY', 'MCQ', 'BOARD', 'ICT Live Exam',
    'MS Excel में तुरंत AutoSum (`=SUM`) लगाने का कीबोर्ड शॉर्टकट क्या है?',
    'What is the keyboard shortcut to insert AutoSum (`=SUM`) instantly in MS Excel?',
    $json$[{"key":"A","text_hi":"Ctrl + S","text_en":"Ctrl + S"},{"key":"B","text_hi":"Ctrl + M","text_en":"Ctrl + M"},{"key":"C","text_hi":"Shift + S","text_en":"Shift + S"},{"key":"D","text_hi":"Alt + =","text_en":"Alt + ="}]$json$::jsonb, 'D',
    'फॉर्मूला `=` से शुरू होता है — उसे `Alt` के साथ दबाने पर AutoSum आ जाता है!', 'Combine `Alt` with the Golden `=` sign!',
    '`Alt + =` दबाते ही एक्सेल अपने आप ऊपर या बाएँ स्थित संख्याओं के लिए `=SUM(...)` तैयार कर देता है।', 'Pressing `Alt + =` automatically inserts `=SUM(...)` for the adjacent numeric range.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #24: MCQ (TOPPER, EXAM_ONLY)
  (
    '10000005-0004-4000-8000-000000000024', 'skill-ict-lab', 'skill-ict-ch4', 'Excel #DIV/0! Error', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'ICT Live Exam',
    'यदि सेल `A1 = 50` और सेल `B1 = 0` है, तो `=A1/B1` लिखने पर MS Excel कौन-सी त्रुटि दिखाएगा?',
    'If cell `A1 = 50` and cell `B1 = 0`, which error will MS Excel display for `=A1/B1`?',
    $json$[{"key":"A","text_hi":"#NAME?","text_en":"#NAME?"},{"key":"B","text_hi":"######","text_en":"######"},{"key":"C","text_hi":"#DIV/0!","text_en":"#DIV/0!"},{"key":"D","text_hi":"#REF!","text_en":"#REF!"}]$json$::jsonb, 'C',
    'नाम में ही "DIV / 0" (शून्य से भाग) लिखा है!', 'The error name literally spells out "DIV/0" (division by zero)!',
    'गणित और एक्सेल दोनों में शून्य से भाग संभव नहीं है, इसलिए `=50/0` लिखने पर `#DIV/0!` त्रुटि आती है।', 'Division by zero is mathematically undefined, so Excel displays `#DIV/0!`.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #25: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000025', 'skill-ict-lab', 'skill-ict-ch4', 'Cell Address, Range & Equals Rule', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'MS Excel में (1) सेल एड्रेस व सेल रेंज उदाहरण सहित समझाएँ, और (2) बताएँ कि हर फॉर्मूला `=` चिह्न से क्यों शुरू होता है।',
    'In MS Excel: (1) explain Cell Address and Cell Range with an example, and (2) explain why every formula starts with `=`.',
    NULL, NULL,
    'उदाहरण के लिए `B2` व `B2:D2` लिखें और `=` न लगाने पर क्या होता है वह बताएँ।', 'Give `B2` & `B2:D2` as examples and state what happens if `=` is omitted.',
    NULL, NULL,
    '1. **सेल एड्रेस व रेंज:** किसी कॉलम और पंक्ति के कटान बिंदु को सेल कहते हैं और उसके पते (पहले अक्षर, फिर संख्या, जैसे **`B2`**) को सेल एड्रेस कहते हैं। लगातार सेलों के समूह को कोलन `:` से दर्शाते हैं, जिसे **सेल रेंज** कहते हैं (जैसे **`B2:D2`** = B2, C2 और D2)।
2. **`=` का महत्व:** `=` चिह्न एक्सेल को बताता है कि आगे लिखा गया व्यंजक साधारण टेक्स्ट नहीं बल्कि एक गणना सूत्र है। यदि `=` न लगाएँ, तो एक्सेल `SUM(B2:D2)` की गणना नहीं करेगा।', '1. **Cell Address & Range:** A cell is the intersection of a column and row, identified as Column Letter + Row Number (e.g., **`B2`**). A continuous group of cells written with a colon `:` is a **Cell Range** (e.g., **`B2:D2`** covers B2, C2, and D2).
2. **Why `=` is Mandatory:** The `=` sign signals Excel to evaluate the expression as a live calculation; without `=`, Excel treats it as plain text.',
    $json$[{"cue_hi":"Cell Address = अक्षर + संख्या (B2) · Range = B2:D2","cue_en":"Cell Address = Letter + Number (B2) · Range = B2:D2"},{"cue_hi":"बिना `=` के एक्सेल गणना नहीं करता","cue_en":"Without `=`, Excel treats formulas as plain text"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"सेल एड्रेस (B2) और सेल रेंज (B2:D2) की सटीक परिभाषा","criterion_en":"Accurate definition and example of Cell Address and Cell Range"},{"step_no":2,"marks":1,"criterion_hi":"फॉर्मूला में `=` चिह्न की अनिवार्यता का स्पष्ट कारण","criterion_en":"Clear explanation of why leading `=` is mandatory"}]$json$::jsonb,
    NULL, true
  ),
  -- #26: LONG_5M (TOPPER, PRACTICE)
  (
    '10000005-0004-4000-8000-000000000026', 'skill-ict-lab', 'skill-ict-ch4', 'Excel Marksheet 5M Practical', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB ICT Practical',
    'एक एक्सेल मार्कशीट में पंक्ति 2 से 5 तक 4 छात्रों के नाम कॉलम `A` में तथा हिंदी, गणित व विज्ञान के अंक क्रमशः `B`, `C`, `D` में हैं। निम्नलिखित 5 गणनाओं के सटीक एक्सेल फॉर्मूले लिखें: (1) पहले छात्र का कुल योग `E2` में, (2) पहले छात्र का औसत `F2` में, (3) पहले छात्र का परिणाम (`>=33` औसत पर Pass, वरना Fail) `G2` में, (4) गणित के अधिकतम अंक `C6` में, और (5) विज्ञान के न्यूनतम अंक `D6` में।',
    'In an Excel marksheet, Rows 2–5 list 4 students in Column `A` and their Hindi, Math, and Science marks in Columns `B`, `C`, and `D`. Write the exact Excel formulas for: (1) first student''s Total in `E2`, (2) first student''s Average in `F2`, (3) Pass/Fail in `G2` (`Pass` if Average `>=33`, else `Fail`), (4) Highest Math score in `C6`, and (5) Lowest Science score in `D6`.',
    NULL, NULL,
    'पाँचों सूत्रों में सबसे पहले `=` लगाएँ और सटीक रेंज (`B2:D2`, `C2:C5`, `D2:D5`) लिखें!', 'Start all 5 formulas with `=` and double-check exact ranges (`B2:D2`, `C2:C5`, `D2:D5`)!',
    NULL, NULL,
    'दी गई बिहार बोर्ड मार्कशीट के लिए सभी 5 सटीक MS Excel फॉर्मूले:

1. **सेल `E2` (पहले छात्र का कुल योग):**
   `=SUM(B2:D2)` *(या `=B2+C2+D2`)*

2. **सेल `F2` (पहले छात्र का औसत अंक):**
   `=AVERAGE(B2:D2)`

3. **सेल `G2` (Pass या Fail परिणाम):**
   `=IF(F2>=33, "Pass", "Fail")`

4. **सेल `C6` (गणित के अधिकतम अंक — कॉलम C, पंक्ति 2 से 5):**
   `=MAX(C2:C5)`

5. **सेल `D6` (विज्ञान के न्यूनतम अंक — कॉलम D, पंक्ति 2 से 5):**
   `=MIN(D2:D5)`

**बोनस लैब टिप:** `E2`, `F2` और `G2` में फॉर्मूला लिखने के बाद **Fill Handle (+)** को पंक्ति 5 तक नीचे खींच देने पर बाकी तीनों छात्रों के उत्तर अपने आप निकल आएँगे!', 'Exact MS Excel formulas for all 5 marksheet calculations:

1. **Cell `E2` (First student''s Total):**
   `=SUM(B2:D2)` *(or `=B2+C2+D2`)*

2. **Cell `F2` (First student''s Average):**
   `=AVERAGE(B2:D2)`

3. **Cell `G2` (Pass / Fail Result):**
   `=IF(F2>=33, "Pass", "Fail")`

4. **Cell `C6` (Highest Math mark across Rows 2–5):**
   `=MAX(C2:C5)`

5. **Cell `D6` (Lowest Science mark across Rows 2–5):**
   `=MIN(D2:D5)`

**Bonus Lab Tip:** Drag the **Fill Handle (+)** down from `E2:G2` to Row 5 to auto-calculate all remaining students in 1 second!',
    $json$[{"cue_hi":"हर फॉर्मूला `=` से शुरू और रेंज में `:` लगाएँ","cue_en":"Start every formula with `=` and use `:` for ranges"},{"cue_hi":"औसत = `=AVERAGE` (कभी `=AVG` न लिखें)","cue_en":"Average = `=AVERAGE` (never `=AVG`)"},{"cue_hi":"IF में शब्दों (\"Pass\", \"Fail\") पर डबल कोट्स लगाएँ","cue_en":"Put text strings (\"Pass\", \"Fail\") inside double quotes"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"सटीक `=SUM(B2:D2)` सूत्र","criterion_en":"Exact `=SUM(B2:D2)` formula"},{"step_no":2,"marks":1,"criterion_hi":"सटीक `=AVERAGE(B2:D2)` सूत्र","criterion_en":"Exact `=AVERAGE(B2:D2)` formula"},{"step_no":3,"marks":1,"criterion_hi":"सटीक `=IF(F2>=33, \"Pass\", \"Fail\")` सूत्र","criterion_en":"Exact `=IF(F2>=33, \"Pass\", \"Fail\")` formula"},{"step_no":4,"marks":1,"criterion_hi":"सटीक `=MAX(C2:C5)` सूत्र","criterion_en":"Exact `=MAX(C2:C5)` formula"},{"step_no":5,"marks":1,"criterion_hi":"सटीक `=MIN(D2:D5)` सूत्र","criterion_en":"Exact `=MIN(D2:D5)` formula"}]$json$::jsonb,
    NULL, true
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
-- CHAPTER 5 OF 6: SKILL-ICT-CH5 — INTERNET, EMAIL, DIGITAL BIHAR & CYBER SAFETY
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-ict-ch5',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: इंटरनेट, ईमेल, डिजिटल बिहार व साइबर सुरक्षा",
  "title_en": "30-Second Mindmap: Internet, Email, Digital Bihar & Cyber Safety",
  "read_time_seconds": 30,
  "central_node": {
    "id": "ict5-root",
    "label_hi": "इंटरनेट और साइबर सुरक्षा (Digital Safety)",
    "label_en": "Internet, Email & Cyber Safety",
    "subtitle_hi": "स्मार्ट बनें, सरकारी सेवाएँ खुद चलाएँ और हर ठगी को पहचानें!",
    "subtitle_en": "Browse wisely, use official Bihar portals & defeat every cyber scam!"
  },
  "branches": [
    {
      "id": "ict5-b1",
      "label_hi": "1. इंटरनेट, ब्राउज़र, सर्च इंजन व URL",
      "label_en": "1. Internet, Browser, Search Engine & URL",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "ict5-b1-1",
          "label_hi": "ब्राउज़र (गाड़ी): Chrome, Edge, Firefox",
          "label_en": "Browser (Vehicle): Chrome, Edge, Firefox"
        },
        {
          "id": "ict5-b1-2",
          "label_hi": "सर्च इंजन (पूछताछ काउंटर): Google, Bing",
          "label_en": "Search Engine (Guide): Google, Bing"
        },
        {
          "id": "ict5-b1-3",
          "label_hi": "सुरक्षित पता: HTTPS (ताला) + .gov.in / .nic.in",
          "label_en": "Safe URL: HTTPS padlock + .gov.in / .nic.in"
        }
      ]
    },
    {
      "id": "ict5-b2",
      "label_hi": "2. ईमेल मास्टरी (To, CC, BCC, Attachment)",
      "label_en": "2. Email Mastery (To, CC, BCC, Attachment)",
      "color": "#059669",
      "children": [
        {
          "id": "ict5-b2-1",
          "label_hi": "To = मुख्य प्राप्तकर्ता · CC = खुली प्रति",
          "label_en": "To = Main recipient · CC = Visible copy"
        },
        {
          "id": "ict5-b2-2",
          "label_hi": "BCC = गुप्त प्रति (दूसरों को ईमेल नहीं दिखता)",
          "label_en": "BCC = Hidden copy (protects email privacy)"
        },
        {
          "id": "ict5-b2-3",
          "label_hi": "Subject = संक्षिप्त विषय · Paperclip = फाइल जोड़ना",
          "label_en": "Subject = Crisp topic · Paperclip = Attach file"
        }
      ]
    },
    {
      "id": "ict5-b3",
      "label_hi": "3. डिजिटल बिहार की आधिकारिक सेवाएँ",
      "label_en": "3. Official Digital Bihar Portals",
      "color": "#D97706",
      "children": [
        {
          "id": "ict5-b3-1",
          "label_hi": "RTPS Bihar: जाति, आय, निवास प्रमाण-पत्र",
          "label_en": "RTPS Bihar: Caste, Income & Residence certificates"
        },
        {
          "id": "ict5-b3-2",
          "label_hi": "DigiLocker: सुरक्षित डिजिटल मार्कशीट व आधार",
          "label_en": "DigiLocker: Verified marksheets & certificates"
        },
        {
          "id": "ict5-b3-3",
          "label_hi": "BSEB व Medhasoft: एडमिट कार्ड, रिजल्ट, छात्रवृत्ति",
          "label_en": "BSEB & Medhasoft: Admit cards, results & scholarships"
        }
      ]
    },
    {
      "id": "ict5-b4",
      "label_hi": "4. साइबर सुरक्षा कवच (OTP, UPI व 1930)",
      "label_en": "4. Cyber Safety Shield (OTP, UPI & 1930)",
      "color": "#7C3AED",
      "children": [
        {
          "id": "ict5-b4-1",
          "label_hi": "OTP = घर की चाबी — किसी को कभी न बताएँ!",
          "label_en": "OTP = House Key — NEVER share with anyone!"
        },
        {
          "id": "ict5-b4-2",
          "label_hi": "UPI नियम: पैसे लेने के लिए कभी UPI PIN नहीं लगता!",
          "label_en": "UPI Rule: NEVER enter UPI PIN to RECEIVE money!"
        },
        {
          "id": "ict5-b4-3",
          "label_hi": "साइबर ठगी हेल्पलाइन: 1930 (तुरंत कॉल करें)",
          "label_en": "National Cyber Crime Helpline: Dial 1930"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "ict5-sec-1-browser-url",
    "order": 1,
    "heading_hi": "1. इंटरनेट, वेब ब्राउज़र, सर्च इंजन और सुरक्षित URL (HTTPS) की पहचान",
    "heading_en": "1. Internet, Web Browser, Search Engine & Spotting Safe HTTPS URLs",
    "analogy_hi": "इंटरनेट को **सड़कों का विश्वव्यापी जाल (Highway)** समझिए! उस सड़क पर चलने वाली आपकी **गाड़ी (बस/कार)** है **वेब ब्राउज़र** (`Google Chrome`, `Microsoft Edge`, `Firefox`)। और रास्ता बताने वाला **रेलवे पूछताछ काउंटर** है **सर्च इंजन** (`Google Search`)! किसी भी वेबसाइट का पूरा पता उसका **URL** कहलाता है — और उस पते पर **ताले का चिह्न + `HTTPS`** (`S` = Secure) बताता है कि सड़क सुरक्षित है!",
    "analogy_en": "Think of the **Internet** as a worldwide **highway network**! Your **Web Browser** (`Google Chrome`, `Microsoft Edge`, `Firefox`) is the **bus/car** you ride on it, and a **Search Engine** (`Google Search`) is the **railway inquiry desk** telling you the exact address (**URL**)! Always look for the **Padlock + `HTTPS`** (`S` = Secure) before typing any personal details!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "सुरक्षित सरकारी वेब पते (URL) के 4 मुख्य भाग पहचानें",
      "title_en": "Anatomy of a Genuine Government Web Address (URL)",
      "caption_hi": "असली सरकारी वेबसाइट के अंत में .gov.in या .nic.in होता है और शुरुआत में सुरक्षित HTTPS (ताला चिह्न) दिखता है। .xyz या अजीब स्पेलिंग से सावधान रहें!",
      "caption_en": "Genuine Indian government portals end in .gov.in or .nic.in and carry the secure HTTPS padlock. Beware of fake .xyz links or misspelled names!",
      "viewBox": "0 0 660 265",
      "elements": [
        {
          "kind": "rect",
          "x": 20,
          "y": 26,
          "width": 620,
          "height": 64,
          "rx": 12,
          "fill": "#F8FAFC",
          "stroke": "#1E3A8A",
          "strokeWidth": 2.2
        },
        {
          "kind": "rect",
          "x": 34,
          "y": 38,
          "width": 112,
          "height": 40,
          "rx": 8,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 90,
          "y": 62,
          "text_hi": "HTTPS (ताला)",
          "text_en": "HTTPS Lock",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 158,
          "y": 38,
          "width": 224,
          "height": 40,
          "rx": 8,
          "fill": "#EFF6FF",
          "stroke": "#2563EB",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 270,
          "y": 62,
          "text_hi": "biharboardonline",
          "text_en": "biharboardonline",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 394,
          "y": 38,
          "width": 108,
          "height": 40,
          "rx": 8,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 448,
          "y": 62,
          "text_hi": ".gov.in",
          "text_en": ".gov.in",
          "fill": "#92400E",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 514,
          "y": 38,
          "width": 112,
          "height": 40,
          "rx": 8,
          "fill": "#F5F3FF",
          "stroke": "#7C3AED",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 570,
          "y": 62,
          "text_hi": "/result",
          "text_en": "/result",
          "fill": "#5B21B6",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 90,
          "y1": 130,
          "x2": 90,
          "y2": 86,
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 20,
          "y": 136,
          "width": 146,
          "height": 104,
          "rx": 8,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 1.6
        },
        {
          "kind": "label",
          "x": 93,
          "y": 162,
          "text_hi": "1. सुरक्षित प्रोटोकॉल",
          "text_en": "1. Safe Protocol",
          "fill": "#065F46",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 93,
          "y": 202,
          "text_hi": "S = Secure एन्क्रिप्शन",
          "text_en": "S = Secure Encrypted",
          "fill": "#334155",
          "fontSize": 10,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 270,
          "y1": 130,
          "x2": 270,
          "y2": 86,
          "stroke": "#2563EB",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 178,
          "y": 136,
          "width": 162,
          "height": 104,
          "rx": 8,
          "fill": "#EFF6FF",
          "stroke": "#2563EB",
          "strokeWidth": 1.6
        },
        {
          "kind": "label",
          "x": 259,
          "y": 162,
          "text_hi": "2. डोमेन नाम (Domain)",
          "text_en": "2. Domain Name",
          "fill": "#1E3A8A",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 259,
          "y": 202,
          "text_hi": "सही स्पेलिंग ज़रूर जाँचें!",
          "text_en": "Check exact spelling!",
          "fill": "#334155",
          "fontSize": 10,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 448,
          "y1": 130,
          "x2": 448,
          "y2": 86,
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 352,
          "y": 136,
          "width": 152,
          "height": 104,
          "rx": 8,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 1.6
        },
        {
          "kind": "label",
          "x": 428,
          "y": 162,
          "text_hi": "3. सरकारी पहचान",
          "text_en": "3. Govt Extension",
          "fill": "#92400E",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 428,
          "y": 202,
          "text_hi": "भारत सरकार (.gov.in)",
          "text_en": "Official India Govt",
          "fill": "#334155",
          "fontSize": 10,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 570,
          "y1": 130,
          "x2": 570,
          "y2": 86,
          "stroke": "#7C3AED",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 516,
          "y": 136,
          "width": 124,
          "height": 104,
          "rx": 8,
          "fill": "#F5F3FF",
          "stroke": "#7C3AED",
          "strokeWidth": 1.6
        },
        {
          "kind": "label",
          "x": 578,
          "y": 162,
          "text_hi": "4. पेज पथ (Path)",
          "text_en": "4. Page Path",
          "fill": "#5B21B6",
          "fontSize": 11,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 578,
          "y": 202,
          "text_hi": "वेबसाइट का विशिष्ट पेज",
          "text_en": "Specific section page",
          "fill": "#334155",
          "fontSize": 10,
          "anchor": "middle"
        }
      ]
    },
    "concept_md_hi": "### वेब ब्राउज़र बनाम सर्च इंजन (सबसे ज़्यादा भ्रमित होने वाला अंतर!)\n- **वेब ब्राउज़र (Web Browser):** वह ऐप जो आपके कंप्यूटर या फोन में इंस्टॉल होता है और वेबसाइट खोलता है। उदाहरण: **Google Chrome, Microsoft Edge, Mozilla Firefox, Safari**।\n- **सर्च इंजन (Search Engine):** वह वेबसाइट जिसे आप ब्राउज़र के अंदर खोलकर जानकारी खोजते हैं। उदाहरण: **Google, Bing, DuckDuckGo**।\n- **डोमेन एक्सटेंशन पहचानें:** `.gov.in` / `.nic.in` = भारत सरकार के आधिकारिक पोर्टल; `.edu` / `.ac.in` = स्कूल व विश्वविद्यालय; `.org` = संस्थान; `.com` = व्यावसायिक वेबसाइट।",
    "concept_md_en": "### Web Browser vs Search Engine (Never Confuse Them Again!)\n- **Web Browser:** The installed app on your PC or phone that opens websites. Examples: **Google Chrome, Microsoft Edge, Mozilla Firefox, Safari**.\n- **Search Engine:** A website opened INSIDE a browser to search information across the web. Examples: **Google Search, Bing, DuckDuckGo**.\n- **Domain Badges:** `.gov.in` / `.nic.in` = Official Indian Government; `.edu` / `.ac.in` = Education/Universities; `.org` = Organizations; `.com` = Commercial sites.",
    "exam_tip_hi": "पक्का बोर्ड प्रश्न: \"HTTPS में अक्षर `S` का पूरा अर्थ क्या है?\" उत्तर: **Secure (सुरक्षित)** — यह आपके पासवर्ड और फॉर्म डेटा को एन्क्रिप्ट (तालाबंद) करके भेजता है!",
    "exam_tip_en": "Guaranteed Exam Question: \"What does the letter `S` in `HTTPS` stand for?\" Answer: **Secure** — it encrypts your password and form data in transit!",
    "glossary_terms": [
      {
        "term_hi": "वेब ब्राउज़र (Web Browser)",
        "term_en": "Web Browser",
        "pronunciation_hi": "वेब ब्राउज़र",
        "definition_hi": "इंटरनेट पर वेबसाइट खोलने व देखने का सॉफ्टवेयर (जैसे Google Chrome, Edge, Firefox)।",
        "definition_en": "Software application installed on your device to open and display web pages (e.g., Chrome, Edge, Firefox)."
      },
      {
        "term_hi": "URL (यूनिफ़ॉर्म रिसोर्स लोकेटर)",
        "term_en": "URL (Uniform Resource Locator)",
        "pronunciation_hi": "यू-आर-एल",
        "definition_hi": "इंटरनेट पर किसी वेबसाइट या वेबपेज का अनूठा और सटीक पता।",
        "definition_en": "The unique web address of a specific website or page on the internet."
      }
    ],
    "quick_check": {
      "q_hi": "**Mozilla Firefox** एक वेब ब्राउज़र है या सर्च इंजन?",
      "q_en": "Is **Mozilla Firefox** a Web Browser or a Search Engine?",
      "answer_hi": "**वेब ब्राउज़र (Web Browser)**, क्योंकि यह वेबसाइट खोलने वाला सॉफ्टवेयर है।",
      "answer_en": "A **Web Browser**, because it is the application used to open websites."
    }
  },
  {
    "id": "ict5-sec-2-email",
    "order": 2,
    "heading_hi": "2. ईमेल मास्टरी — To, CC, BCC, Subject और Attachment का सही उपयोग",
    "heading_en": "2. Email Mastery — Using To, CC, BCC, Subject & Attachments Like a Pro",
    "analogy_hi": "**ईमेल (Electronic Mail)** दुनिया का सबसे तेज़ और मुफ्त **डिजिटल डाकखाना** है! एक ईमेल पते में हमेशा **`@`** चिह्न होता है (जैसे `rohan.patna@gmail.com`)। इसमें **`To`** वह मुख्य व्यक्ति है जिसे चिट्ठी लिखी है (प्रधानाध्यापक); **`CC`** (Carbon Copy) वे लोग हैं जिन्हें खुलकर एक कॉपी भेजी (क्लास टीचर); और **`BCC`** (Blind Carbon Copy) गुप्त कॉपी है — जब 50 अभिभावकों को एक साथ नोटिस भेजना हो और आप नहीं चाहते कि किसी को दूसरे का निजी ईमेल दिखे, तो **BCC** चुनें!",
    "analogy_en": "**Email (Electronic Mail)** is instant, free **digital post**! Every email address contains an **`@`** symbol (e.g., `rohan.patna@gmail.com`). **`To`** is the main recipient (Principal); **`CC`** (Carbon Copy) sends a visible copy (Class Teacher); and **`BCC`** (Blind Carbon Copy) sends a private copy hiding everyone's email address from other recipients!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "ईमेल के 6 मुख्य हिस्से — हर छात्र के लिए व्यावहारिक गाइड",
      "title_en": "6 Core Parts of a Professional Email — Practical Student Guide",
      "caption_hi": "ईमेल भेजते समय कभी भी Subject (विषय) खाली न छोड़ें और अनजान स्पैम (Spam) ईमेल के लिंक कभी न खोलें!",
      "caption_en": "Never send an email with a blank Subject line, and never click links inside suspicious Spam emails!",
      "headers_hi": [
        "ईमेल भाग",
        "पूरा नाम / अर्थ",
        "सही उपयोग (कब चुनें?)"
      ],
      "headers_en": [
        "Email Field",
        "Full Meaning",
        "When & How to Use"
      ],
      "rows": [
        {
          "cells_hi": [
            "To",
            "मुख्य प्राप्तकर्ता",
            "जिस व्यक्ति को मुख्य ईमेल भेजा जा रहा है (जैसे प्रधानाध्यापक)"
          ],
          "cells_en": [
            "To",
            "Primary Recipient",
            "The main person who must read and act on your email"
          ]
        },
        {
          "cells_hi": [
            "CC",
            "Carbon Copy (खुली प्रति)",
            "जिन्हें सूचना के लिए कॉपी भेजनी है — सभी एक-दूसरे का ईमेल देख सकते हैं"
          ],
          "cells_en": [
            "CC",
            "Carbon Copy (Visible)",
            "People kept informed — everyone sees all CC addresses"
          ]
        },
        {
          "cells_hi": [
            "BCC",
            "Blind Carbon Copy (गुप्त प्रति)",
            "कई लोगों को कॉपी भेजना जहाँ दूसरों को उनका ईमेल पता न दिखे (गोपनीयता!)"
          ],
          "cells_en": [
            "BCC",
            "Blind Carbon Copy (Hidden)",
            "Hides recipient email addresses from one another (protects privacy!)"
          ]
        },
        {
          "cells_hi": [
            "Subject",
            "विषय पंक्ति",
            "4–6 शब्दों में ईमेल का साफ उद्देश्य (जैसे \"Class 10 Leave Request\")"
          ],
          "cells_en": [
            "Subject",
            "Topic Line",
            "4–6 clear words summarizing the email (never leave blank!)"
          ]
        },
        {
          "cells_hi": [
            "Attachment (पिन)",
            "संलग्न फाइल",
            "PDF, मार्कशीट, आवेदन या फोटो (आमतौर पर 25 MB तक) जोड़ना"
          ],
          "cells_en": [
            "Attachment (Paperclip)",
            "Attached File",
            "Attach PDF, Word file, or photo (usually up to 25 MB)"
          ]
        },
        {
          "cells_hi": [
            "Spam / Junk",
            "अवांछित / संदिग्ध मेल",
            "फर्जी लॉटरी या ठगी वाले ईमेल यहाँ जाते हैं — इनके लिंक न छुएँ!"
          ],
          "cells_en": [
            "Spam / Junk",
            "Unwanted / Suspicious Mail",
            "Fake lottery or phishing emails land here — never click their links!"
          ]
        }
      ]
    },
    "concept_md_hi": "### सही ईमेल पता और ईमेल शिष्टाचार (Email Etiquette)\n- **ईमेल के 2 भाग:** `username@domain.com` (जैसे `anjali.bihar@gmail.com`)। इसमें बीच में **कभी खाली जगह (Space) नहीं होती** और ठीक एक **`@`** चिह्न होता है।\n- **4 सुनहरे शिष्टाचार:**\n  1. साफ व छोटा **Subject** लिखें।\n  2. शिष्ट अभिवादन (`Respected Sir/Madam`) से शुरुआत करें।\n  3. अटैचमेंट (Paperclip आइकन) जोड़ा है या नहीं, Send से पहले जाँच लें!\n  4. स्कूल ICT लैब या साइबर कैफे में ईमेल उपयोग करने के बाद हमेशा **Sign Out / Log Out** ज़रूर करें!",
    "concept_md_en": "### Valid Email Structure & Email Etiquette\n- **2 Parts of an Email ID:** `username@domain.com` (e.g., `anjali.bihar@gmail.com`). It NEVER contains spaces and ALWAYS has exactly one **`@`** sign.\n- **4 Golden Habits:**\n  1. Always write a crisp **Subject** line.\n  2. Start politely (`Respected Sir/Madam`).\n  3. Double-check your **Attachment** before clicking Send!\n  4. Always click **Sign Out / Log Out** after using email on a shared school PC or cyber cafe!",
    "exam_tip_hi": "सबसे लोकप्रिय MCQ: \"ईमेल में `BCC` का पूरा नाम क्या है?\" उत्तर: **Blind Carbon Copy**। यह अन्य प्राप्तकर्ताओं से ईमेल पतों को छिपाकर गोपनीयता बचाता है!",
    "exam_tip_en": "Top Exam MCQ: \"What does `BCC` stand for in Email?\" Answer: **Blind Carbon Copy** — it hides recipient email IDs from each other for privacy!",
    "glossary_terms": [
      {
        "term_hi": "BCC (ब्लाइंड कार्बन कॉपी)",
        "term_en": "BCC (Blind Carbon Copy)",
        "pronunciation_hi": "बी-सी-सी (ब्लाइंड कार्बन कॉपी)",
        "definition_hi": "ईमेल की वह सुविधा जिससे किसी को कॉपी भेजी जाती है लेकिन बाकी प्राप्तकर्ताओं को उसका ईमेल पता नहीं दिखता।",
        "definition_en": "Email field that sends copies while keeping recipients' email addresses hidden from one another."
      },
      {
        "term_hi": "अटैचमेंट (Attachment)",
        "term_en": "Email Attachment",
        "pronunciation_hi": "अटैचमेंट",
        "definition_hi": "ईमेल संदेश के साथ पेपरक्लिप आइकन द्वारा जोड़ी गई फाइल (जैसे PDF, फोटो या Word दस्तावेज़)।",
        "definition_en": "A file (PDF, photo, or Word document) attached to an email using the paperclip icon."
      }
    ],
    "quick_check": {
      "q_hi": "इनमें से कौन-सा ईमेल पता मान्य (Valid) है: `ravi kumar@gmail.com` या `ravi.kumar@gmail.com`?",
      "q_en": "Which email address is valid: `ravi kumar@gmail.com` or `ravi.kumar@gmail.com`?",
      "answer_hi": "**`ravi.kumar@gmail.com`** — क्योंकि ईमेल पते में कभी खाली जगह (Space) नहीं हो सकती!",
      "answer_en": "**`ravi.kumar@gmail.com`** — because an email address can never contain blank spaces!"
    }
  },
  {
    "id": "ict5-sec-3-digital-bihar",
    "order": 3,
    "heading_hi": "3. डिजिटल बिहार और सरकारी छात्र पोर्टल — आत्मनिर्भर बनें!",
    "heading_en": "3. Digital Bihar & Official Student Portals — Become Self-Reliant!",
    "analogy_hi": "पहले जाति, आय या निवास प्रमाण-पत्र बनवाने के लिए पूरा दिन प्रखंड कार्यालय (Block Office) की लाइन में लगना पड़ता था। आज बिहार के आधिकारिक **`.gov.in`** पोर्टल्स और **DigiLocker** की मदद से आप अपने मोबाइल या स्कूल लैब से ही एडमिट कार्ड, प्रमाण-पत्र और मार्कशीट सुरक्षित रूप से देख व डाउनलोड कर सकते हैं!",
    "analogy_en": "Earlier, families had to spend an entire day queueing at the Block Office for Caste, Income, or Residence certificates. Today, official **`.gov.in`** Digital Bihar portals and **DigiLocker** let students access verified certificates, admit cards, and marksheets safely!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "सरकारी पोर्टल व साइबर कैफे का सुरक्षित उपयोग (4-चरण नियम)",
      "title_en": "Safe 4-Step Workflow for Government Portals & Shared PCs",
      "caption_hi": "छात्रवृत्ति या रिजल्ट के लिए हमेशा आधिकारिक .gov.in / .nic.in डोमेन जाँचें और साझा कंप्यूटर पर काम पूरा होते ही Log Out करें!",
      "caption_en": "Always check for official .gov.in / .nic.in domains for results or scholarships, and always Log Out on shared PCs!",
      "direction": "LR",
      "steps": [
        {
          "id": "d1",
          "label_hi": "1. असली .gov.in जाँचें",
          "label_en": "1. Verify .gov.in URL",
          "detail_hi": "RTPS, BSEB, DigiLocker के आधिकारिक पते व HTTPS ताला जाँचें।",
          "detail_en": "Check exact official domain & HTTPS padlock.",
          "accent": "indigo"
        },
        {
          "id": "d2",
          "label_hi": "2. सही विवरण भरें",
          "label_en": "2. Enter Accurate Info",
          "detail_hi": "रोल कोड, रोल नंबर या प्रमाण-पत्र संख्या सावधानी से भरें।",
          "detail_en": "Carefully verify roll code, roll no, or application ID.",
          "accent": "amber"
        },
        {
          "id": "d3",
          "label_hi": "3. DigiLocker में सहेजें",
          "label_en": "3. Save in DigiLocker",
          "detail_hi": "मार्कशीट व प्रमाण-पत्र DigiLocker में कानूनी रूप से मान्य रहते हैं।",
          "detail_en": "DigiLocker documents are legally valid digital originals.",
          "accent": "emerald"
        },
        {
          "id": "d4",
          "label_hi": "4. साझा PC से Log Out!",
          "label_en": "4. Log Out Shared PC!",
          "detail_hi": "लैब या कैफे PC पर पासवर्ड Save न करें और Sign Out ज़रूर करें।",
          "detail_en": "Never save passwords on cafe/lab PCs; always Sign Out!",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "d1",
          "to": "d2"
        },
        {
          "from": "d2",
          "to": "d3"
        },
        {
          "from": "d3",
          "to": "d4"
        }
      ]
    },
    "concept_md_hi": "### बिहार के 4 सबसे उपयोगी आधिकारिक डिजिटल पोर्टल\n1. **RTPS / ServicePlus Bihar (`serviceonline.bihar.gov.in`):** घर बैठे ऑनलाइन **जाति, आवासीय (निवास) और आय प्रमाण-पत्र** के लिए आवेदन व डाउनलोड।\n2. **DigiLocker (`digilocker.gov.in`):** भारत सरकार का सुरक्षित क्लाउड लॉकर जहाँ आपकी **BSEB मैट्रिक/इंटर मार्कशीट, आधार और प्रमाण-पत्र** डिजिटल रूप से हमेशा सुरक्षित और कानूनी रूप से मान्य रहते हैं।\n3. **BSEB Official & Medhasoft Bihar (`medhasoft.bihar.gov.in`):** बोर्ड एडमिट कार्ड, रिजल्ट और बिहार मुख्यमंत्री बालक/बालिका प्रोत्साहन छात्रवृत्ति की आधिकारिक जानकारी।\n4. **e-Shikshakosh Bihar:** बिहार सरकार के विद्यालयों, शिक्षकों और विद्यार्थियों का आधिकारिक शिक्षा पोर्टल।",
    "concept_md_en": "### 4 Most Useful Official Portals for Bihar Students\n1. **RTPS / ServicePlus Bihar (`serviceonline.bihar.gov.in`):** Apply online and download **Caste, Residence, and Income certificates** without middlemen.\n2. **DigiLocker (`digilocker.gov.in`):** Government of India's secure cloud locker storing legally valid **BSEB Matric/Inter marksheets, Aadhaar, and certificates**.\n3. **BSEB Official & Medhasoft Bihar (`medhasoft.bihar.gov.in`):** Official board admit cards, results, and Bihar student scholarship status.\n4. **e-Shikshakosh Bihar:** Official Bihar Education Department portal for schools, teachers, and students.",
    "exam_tip_hi": "स्मार्ट नागरिक टिप: यदि किसी व्हाट्सएप संदेश में बिहार छात्रवृत्ति के नाम पर `.xyz`, `.blogspot` या अजीब लिंक आए, तो वह 100% फर्जी है — असली सरकारी लिंक हमेशा **`.gov.in`** या **`.nic.in`** पर खत्म होते हैं!",
    "exam_tip_en": "Smart Citizen Tip: Any WhatsApp message claiming Bihar scholarship via `.xyz` or `.blogspot` links is 100% fake — genuine government sites end in **`.gov.in`** or **`.nic.in`**!",
    "glossary_terms": [
      {
        "term_hi": "डिजिलॉकर (DigiLocker)",
        "term_en": "DigiLocker",
        "pronunciation_hi": "डिजिलॉकर",
        "definition_hi": "भारत सरकार का सुरक्षित डिजिटल दस्तावेज़ लॉकर जिसमें रखी मार्कशीट व प्रमाण-पत्र मूल कागज़ के बराबर कानूनी रूप से मान्य हैं।",
        "definition_en": "Government of India's secure digital locker where issued marksheets and certificates hold full legal validity."
      },
      {
        "term_hi": "RTPS बिहार",
        "term_en": "RTPS Bihar (Right to Public Services)",
        "pronunciation_hi": "आर-टी-पी-एस बिहार",
        "definition_hi": "बिहार सरकार की ऑनलाइन लोक सेवा प्रणाली जिससे जाति, आय व निवास प्रमाण-पत्र समय-सीमा में मिलते हैं।",
        "definition_en": "Bihar's official online public service portal for Caste, Income, and Residence certificates."
      }
    ],
    "quick_check": {
      "q_hi": "इनमें से कौन-सा पोर्टल भारत सरकार का आधिकारिक सुरक्षित डिजिटल मार्कशीट लॉकर है — DigiLocker या WhatsApp Gallery?",
      "q_en": "Which is Government of India's official, legally valid digital marksheet locker — DigiLocker or WhatsApp Gallery?",
      "answer_hi": "**DigiLocker (`digilocker.gov.in`)**!",
      "answer_en": "**DigiLocker (`digilocker.gov.in`)**!"
    }
  },
  {
    "id": "ict5-sec-4-cyber-safety",
    "order": 4,
    "heading_hi": "4. साइबर सुरक्षा कवच — OTP, UPI और फर्जी छात्रवृत्ति ठगी को हराएँ!",
    "heading_en": "4. Cyber Safety Shield — Stopping OTP, UPI & Fake Scholarship Scams!",
    "analogy_hi": "आपका **OTP (One-Time Password)** और **UPI PIN** आपके **घर और बैंक की तिजोरी की लोहे की चाबी** है! क्या आप किसी अनजान फोन करने वाले को अपने घर की चाबी दे देंगे? कभी नहीं! एक बिहार-विशेष सुनहरा नियम अपने पूरे परिवार को आज ही बता दें: **पैसे लेने (Receive करने) के लिए कभी भी UPI PIN नहीं डाला जाता और न ही कोई QR कोड स्कैन किया जाता है — UPI PIN केवल खाते से पैसे भेजने (कटवाने) के लिए होता है!**",
    "analogy_en": "Your **OTP (One-Time Password)** and **UPI PIN** are the **iron keys to your family's home and bank account**! Teach your entire family this one life-saving rule today: **You NEVER enter your UPI PIN or scan a QR code to RECEIVE money — a UPI PIN is ONLY for SENDING money out of your bank!**",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "बिहार में होने वाली 4 सबसे बड़ी साइबर ठगी और उनसे बचने का अचूक उपाय",
      "title_en": "Top 4 Cyber Scams in Bihar & Exact Self-Defense Action",
      "caption_hi": "यदि किसी के साथ साइबर या UPI धोखाधड़ी हो जाए, तो घबराएँ नहीं — तुरंत राष्ट्रीय साइबर क्राइम हेल्पलाइन 1930 पर कॉल करें!",
      "caption_en": "If financial cyber fraud ever happens to anyone in your family, immediately dial National Cyber Crime Helpline 1930!",
      "headers_hi": [
        "साइबर ठगी का तरीका",
        "खतरे का संकेत (Red Flag)",
        "आपका सुरक्षित कदम"
      ],
      "headers_en": [
        "Scam Type",
        "Red Flag Warning",
        "Your Safe Action"
      ],
      "rows": [
        {
          "cells_hi": [
            "फर्जी छात्रवृत्ति / बैंक कॉल",
            "\"₹10,000 प्रोत्साहन राशि आ रही है, तुरंत 6-अंक का OTP बताएँ!\"",
            "फोन तुरंत काटें! कोई भी सरकारी अधिकारी या बैंक कभी OTP नहीं माँगता।"
          ],
          "cells_en": [
            "Fake Scholarship / Bank Call",
            "\"₹10,000 scholarship ready — tell me your 6-digit OTP fast!\"",
            "Hang up immediately! No bank or govt officer ever asks for OTP."
          ]
        },
        {
          "cells_hi": [
            "UPI \"पैसे लेने का QR कोड\"",
            "\"₹2,000 पाने के लिए यह QR स्कैन कर अपना UPI PIN डालें!\"",
            "साफ मना करें! पैसे पाने के लिए कभी QR स्कैन या UPI PIN नहीं लगता।"
          ],
          "cells_en": [
            "UPI \"Scan to Receive\" QR",
            "\"Scan this QR & enter UPI PIN to receive ₹2,000 prize!\"",
            "Refuse immediately! UPI PIN is ONLY for paying money out, never receiving."
          ]
        },
        {
          "cells_hi": [
            "फिशिंग (Phishing) लिंक SMS",
            "\"आपका सिम बंद होगा / इनाम जीता — अभी अनजान लिंक पर क्लिक करें!\"",
            "लिंक पर कभी क्लिक न करें और संदेश को Delete/Report करें।"
          ],
          "cells_en": [
            "Phishing Fake Link SMS",
            "\"SIM closing / Won lottery — click this urgent link now!\"",
            "Never tap unknown links; delete and report as spam."
          ]
        },
        {
          "cells_hi": [
            "कमज़ोर पासवर्ड",
            "`123456`, अपना नाम या जन्मतिथि पासवर्ड रखना",
            "कम से कम 8 अक्षर: बड़ा अक्षर + छोटा अक्षर + संख्या + चिह्न (जैसे `Bih@r2026!`)।"
          ],
          "cells_en": [
            "Weak Password",
            "Using `123456`, your name, or date of birth",
            "Use 8+ chars mixing Upper, lower, number & symbol (e.g., `Bih@r2026!`)."
          ]
        }
      ]
    },
    "concept_md_hi": "### मज़बूत पासवर्ड और हेल्पलाइन `1930` का नियम\n- **फिशिंग (Phishing):** जालसाजों द्वारा असली बैंक, सरकारी पोर्टल या छात्रवृत्ति जैसा दिखने वाला नकली SMS/ईमेल/वेबपेज भेजकर आपका पासवर्ड या OTP चुराना।\n- **मज़बूत पासवर्ड के 4 तत्व (कम से कम 8 अक्षर):** बड़ा अक्षर (`A–Z`) + छोटा अक्षर (`a–z`) + संख्या (`0–9`) + विशेष चिह्न (`@`, `#`, `!`)। कभी भी `123456` या जन्मतिथि न रखें!\n- **राष्ट्रीय साइबर क्राइम हेल्पलाइन:** किसी भी ऑनलाइन वित्तीय धोखाधड़ी के **गोल्डन आवर (पहले 1–2 घंटे)** में **`1930`** पर कॉल करें या `cybercrime.gov.in` पर रिपोर्ट दर्ज करें ताकि ठग का बैंक खाता तुरंत फ्रीज़ हो सके!",
    "concept_md_en": "### Strong Password Formula & National Helpline `1930`\n- **Phishing:** When scammers disguise fake SMS, emails, or web pages as real banks or government portals to steal your password, card, or OTP.\n- **4 Ingredients of a Strong Password (8+ chars):** Uppercase (`A–Z`) + lowercase (`a–z`) + Number (`0–9`) + Symbol (`@`, `#`, `!`). Never use `123456` or your birthday!\n- **National Cyber Crime Helpline (`1930`):** In case of online money fraud, call **`1930`** (or report on `cybercrime.gov.in`) immediately within the first 1–2 hours to help freeze the fraudster's bank transfer!",
    "exam_tip_hi": "यह 2 नंबर जीवन भर याद रखें: **OTP = कभी साझा न करें**, **UPI PIN = केवल पैसे भेजने के लिए**, और **साइबर ठगी हेल्पलाइन = `1930`**!",
    "exam_tip_en": "Memorize for life & exams: **Never share OTP**, **UPI PIN is only for sending money**, and **Cyber Crime Helpline = `1930`**!",
    "glossary_terms": [
      {
        "term_hi": "फिशिंग (Phishing)",
        "term_en": "Phishing",
        "pronunciation_hi": "फिशिंग",
        "definition_hi": "असली बैंक या सरकारी संस्था का नकली रूप दिखाकर SMS, लिंक या कॉल से OTP व पासवर्ड चुराने की साइबर ठगी।",
        "definition_en": "Cyber scam using fake emails, SMS links, or calls pretending to be a trusted bank or agency to steal passwords/OTPs."
      },
      {
        "term_hi": "OTP (वन-टाइम पासवर्ड)",
        "term_en": "OTP (One-Time Password)",
        "pronunciation_hi": "ओ-टी-पी (वन-टाइम पासवर्ड)",
        "definition_hi": "केवल एक बार और कुछ मिनटों के लिए मान्य गुप्त सुरक्षा कोड जिसे किसी अनजान व्यक्ति को कभी नहीं बताना चाहिए।",
        "definition_en": "A single-use secret security code valid for a few minutes that must never be shared with anyone."
      }
    ],
    "quick_check": {
      "q_hi": "यदि कोई अनजान व्यक्ति कहे \"मैं आपके खाते में ₹5,000 भेज रहा हूँ, बस आप अपना UPI PIN डाल दें\", तो क्या यह सुरक्षित है?",
      "q_en": "If a stranger says \"I am sending ₹5,000 to your bank, just enter your UPI PIN\", is that safe?",
      "answer_hi": "**बिल्कुल नहीं — यह 100% ठगी है!** पैसे लेने के लिए कभी UPI PIN नहीं डाला जाता; PIN डालते ही आपके खाते से ₹5,000 कट जाएँगे!",
      "answer_en": "**NO — 100% SCAM!** You never enter a UPI PIN to receive money; entering your PIN deducts money FROM your own account!"
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{HTTPS} = \\text{HyperText Transfer Protocol } \\mathbf{Secure}",
      "label_hi": "सुरक्षित वेब प्रोटोकॉल (ताला चिह्न)",
      "label_en": "Secure Web Protocol (Padlock)"
    },
    {
      "latex": "\\text{Email Format: } \\text{username@domain.com}\\; (\\text{No Spaces!})",
      "label_hi": "मान्य ईमेल पते का ढाँचा",
      "label_en": "Valid Email Address Structure"
    },
    {
      "latex": "\\text{Cyber Helpline India} = \\mathbf{1930}",
      "label_hi": "राष्ट्रीय साइबर अपराध हेल्पलाइन नंबर",
      "label_en": "National Cyber Crime Helpline Number"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "Browser",
      "fact_hi": "Google Chrome, Edge व Firefox वेब ब्राउज़र हैं; Google Search व Bing सर्च इंजन हैं।",
      "fact_en": "Chrome, Edge & Firefox are Web Browsers; Google Search & Bing are Search Engines."
    },
    {
      "tag": "BCC",
      "fact_hi": "ईमेल में BCC (Blind Carbon Copy) अन्य प्राप्तकर्ताओं से ईमेल पता गुप्त रखता है।",
      "fact_en": "BCC (Blind Carbon Copy) hides recipient email IDs from each other."
    },
    {
      "tag": ".gov.in",
      "fact_hi": "भारत सरकार के आधिकारिक पोर्टल (RTPS, DigiLocker, BSEB) `.gov.in` या `.nic.in` पर होते हैं।",
      "fact_en": "Official Indian govt portals end in `.gov.in` or `.nic.in`."
    },
    {
      "tag": "1930",
      "fact_hi": "OTP/UPI ठगी होने पर तुरंत 1930 पर कॉल कर खाता फ्रीज़ करवाएँ।",
      "fact_en": "Dial 1930 immediately if financial cyber fraud occurs."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "Google Chrome को सर्च इंजन और Google.com को वेब ब्राउज़र मान लेना।",
      "mistake_en": "Confusing Google Chrome (Browser) with Google Search (Search Engine).",
      "fix_hi": "याद रखें: **Chrome = गाड़ी (Browser)**; **Google.com = पूछताछ काउंटर (Search Engine)**!",
      "fix_en": "Remember: **Chrome = Car (Browser)**; **Google Search = Inquiry Desk (Search Engine)**!"
    },
    {
      "mistake_hi": "CC और BCC के बीच गोपनीयता का अंतर उल्टा लिख देना।",
      "mistake_en": "Mixing up privacy behavior between CC and BCC.",
      "fix_hi": "B = Blind (आँखों पर पट्टी) → **BCC** में दूसरे लोग ईमेल पता नहीं देख पाते!",
      "fix_en": "B = Blind → **BCC** hides recipient addresses from others!"
    },
    {
      "mistake_hi": "कमज़ोर पासवर्ड (`12345678` या `rohan123`) को मज़बूत मान लेना।",
      "mistake_en": "Thinking `12345678` or `rohan123` is a strong password.",
      "fix_hi": "मज़बूत पासवर्ड में 8+ अक्षर तथा चारों तत्व (A–Z, a–z, 0–9, @#! चिह्न) होने चाहिए।",
      "fix_en": "A strong password has 8+ characters combining Upper, lower, digits, and symbols."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "ब्राउज़र बनाम सर्च इंजन, URL और HTTPS (Secure)",
      "topic_en": "Browser vs Search Engine, URL & HTTPS (Secure)",
      "years": [
        "BSEB ICT Lab",
        "Objective"
      ],
      "expected_marks": 4
    },
    {
      "topic_hi": "ईमेल के भाग (To, CC, BCC, Subject, Attachment, Spam)",
      "topic_en": "Email Fields (To, CC, BCC, Subject, Attachment, Spam)",
      "years": [
        "BSEB ICT Lab"
      ],
      "expected_marks": 4
    },
    {
      "topic_hi": "साइबर सुरक्षा (Phishing, OTP, UPI PIN, मज़बूत पासवर्ड, हेल्पलाइन 1930)",
      "topic_en": "Cyber Safety (Phishing, OTP, UPI PIN, Strong Password & 1930)",
      "years": [
        "BSEB ICT Practical",
        "Viva"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 4,
  "analogy_count": 4,
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
  'skill-ict-ch5',
  2,
  'छात्र वेब ब्राउज़र व सर्च इंजन का अंतर स्पष्ट कर सकेंगे, असली `.gov.in` व HTTPS वेबसाइट की पहचान कर सकेंगे, To/CC/BCC के साथ शिष्ट ईमेल लिखने का अभ्यास कर सकेंगे, DigiLocker व RTPS बिहार का उपयोग समझ सकेंगे और OTP, UPI QR तथा फर्जी छात्रवृत्ति ठगी से अपने पूरे परिवार को सुरक्षित रख सकेंगे।',
  'Students will differentiate Web Browsers from Search Engines, verify authentic `.gov.in` & HTTPS URLs, compose a polite email using To/CC/BCC, understand DigiLocker & RTPS Bihar, and protect themselves and their families from OTP, UPI QR, and fake scholarship scams.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "ब्राउज़र बनाम सर्च इंजन, .gov.in जासूस व ईमेल ढाँचा (To/CC/BCC)",
    "phase_en": "Browser vs Search Engine, .gov.in Detective & Email Anatomy (To/CC/BCC)",
    "teacher_action_hi": "ब्राउज़र खोलकर एड्रेस बार में ताला चिह्न (`HTTPS`) और `.gov.in` लाइव दिखाएँ (उदाहरण: `digilocker.gov.in`, `serviceonline.bihar.gov.in`)। फिर ब्लैकबोर्ड पर ईमेल विंडो बनाकर `To`, `CC` और `BCC` का अंतर एक स्कूल उदाहरण से समझाएँ (प्रधानाध्यापक = To, शिक्षक = CC, 50 अभिभावक = BCC)।",
    "teacher_action_en": "Open a browser and highlight the `HTTPS` padlock and `.gov.in` badge on real portals (`digilocker.gov.in`, `serviceonline.bihar.gov.in`). Sketch an Email Compose screen on the board to illustrate `To`, `CC`, and `BCC` with a school notice example.",
    "student_check_hi": "पूछें: \"क्या `bihar-scholarship-free.xyz` असली सरकारी वेबसाइट हो सकती है? क्यों नहीं?\"",
    "student_check_en": "Ask: \"Could `bihar-scholarship-free.xyz` be an official Bihar government site? Why not?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "बिहार साइबर सुरक्षा नाटक (\"ठगी या सुरक्षित?\") व 1930 शपथ",
    "phase_en": "Bihar Cyber Safety Roleplay (\"Scam or Safe?\") & Helpline 1930 Pledge",
    "teacher_action_hi": "शिक्षक 4 वास्तविक बिहार ठगी परिदृश्य पढ़ें (फर्जी ₹10,000 छात्रवृत्ति OTP कॉल, OLX पर UPI QR से पैसे पाने का झांसा, सिम बंद होने वाला फिशिंग SMS, और DigiLocker पर मार्कशीट डाउनलोड)। पूरी कक्षा हाथ उठाकर \"SCAM!\" या \"SAFE!\" बोले और कारण बताए। अंत में हर छात्र घर जाकर माता-पिता को UPI PIN नियम व `1930` बताने की शपथ ले!",
    "teacher_action_en": "Read aloud 4 realistic Bihar scenarios (Fake ₹10,000 Scholarship OTP Call, UPI QR \"Receive Money\" Trap, Phishing SIM-Block SMS, and Official DigiLocker Download). Students shout \"SCAM!\" or \"SAFE!\" and justify. End with every student pledging to teach their parents the UPI PIN rule and `1930` tonight!",
    "student_check_hi": "कमज़ोर छात्र से बुलवाएँ: \"पैसे लेने (Receive) के लिए क्या कभी UPI PIN डालना पड़ता है?\" (पूरा वर्ग एक स्वर में: \"कभी नहीं!\")",
    "student_check_en": "Have a shy student lead the chorus: \"Do you EVER enter a UPI PIN to RECEIVE money?\" (Whole class: \"NEVER!\")"
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड डिजिटल सुरक्षा व ईमेल सारणी",
    "heading_en": "Blackboard Digital Safety & Email Box",
    "points_hi": [
      "ब्राउज़र (गाड़ी) = Chrome, Edge, Firefox  |  सर्च इंजन (गाइड) = Google, Bing",
      "असली सरकारी वेबसाइट: HTTPS (ताला) + `.gov.in` या `.nic.in`",
      "ईमेल: To (मुख्य) | CC (खुली प्रति) | BCC (गुप्त प्रति — गोपनीयता!) | Subject अनिवार्य",
      "साइबर सुरक्षा के 3 मंत्र: (1) OTP = कभी न बताएँ (2) पैसे लेने पर UPI PIN नहीं (3) ठगी पर तुरंत 1930 कॉल करें!"
    ],
    "points_en": [
      "Browser (Vehicle) = Chrome, Edge, Firefox  |  Search Engine (Guide) = Google, Bing",
      "Genuine Govt Sites: HTTPS (Padlock) + `.gov.in` or `.nic.in`",
      "Email: To (Main) | CC (Visible Copy) | BCC (Private Hidden Copy) | Subject always required",
      "3 Cyber Shields: (1) Never share OTP (2) Never enter UPI PIN to receive money (3) Dial 1930 on fraud!"
    ]
  },
  {
    "heading_hi": "बिजली कटने पर ऑफलाइन बैकअप (Power-Cut Blackboard Backup)",
    "heading_en": "Offline / Power-Cut Blackboard Backup Activity",
    "points_hi": [
      "यदि इंटरनेट या बिजली न हो, तो ब्लैकबोर्ड पर 4 काल्पनिक पासवर्ड लिखें: `123456`, `patna2009`, `R@vi#2026`, `password` — छात्रों से सबसे मज़बूत चुनवाएँ और नियम समझाएँ!",
      "दो छात्रों की जोड़ी से \"फर्जी कॉलर बनाम समझदार बिहार छात्र\" का 2-मिनट का संवाद अभिनय कराएँ — एक छात्र ठग बने और दूसरा छात्र OTP देने से इंकार कर `1930` बताए!"
    ],
    "points_en": [
      "Without power or internet, write 4 sample passwords on the board (`123456`, `patna2009`, `R@vi#2026`, `password`) and let teams grade their strength!",
      "Stage a 2-minute live skit: \"Scam Caller vs Smart Bihar Student\" — Student A tries a fake scholarship OTP trick, Student B politely exposes the red flags and cites Helpline `1930`!"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "लैब जोड़ी गतिविधि: \"असली बनाम नकली URL पहचानें\" और ईमेल ड्राफ्ट",
    "title_en": "ICT Lab Pair Activity: \"Real vs Fake URL Hunt\" & Email Draft",
    "materials_hi": "लैब कंप्यूटर (या ऑफलाइन प्रिंटेड कार्ड), MS Word / Notepad में ईमेल ड्राफ्ट",
    "materials_en": "Lab PC (or printed cards), Notepad/Word for drafting a mock email",
    "steps_hi": "हर जोड़ी 5 URLs में से असली सरकारी पोर्टल अलग करे। फिर Notepad में प्रधानाध्यापक को एक शिष्ट ईमेल का ड्राफ्ट (`To`, `CC`, `Subject`, `Body`) तैयार करे और सही प्रारूप जाँचे।",
    "steps_en": "Pairs sort 5 URLs into Genuine Govt vs Fake Phishing. Then each pair drafts a polite school email (`To`, `CC`, `Subject`, `Body`) in Notepad/Word and checks all 4 etiquette rules."
  },
  {
    "title_hi": "ऑफलाइन गतिविधि (बिना बिजली): \"परिवार साइबर रक्षक पोस्टर\"",
    "title_en": "No-Power Classroom Activity: \"Family Cyber Guardian Poster\"",
    "materials_hi": "कॉपी का एक पन्ना और पेन",
    "materials_en": "One notebook page and pen",
    "steps_hi": "छात्र कॉपी के 1 पन्ने पर घर की दीवार पर चिपकाने लायक 4 नियमों का पोस्टर बनाएँ: (1) OTP किसी को न दें, (2) पैसे पाने के लिए UPI PIN नहीं लगता, (3) अनजान लिंक न छुएँ, (4) साइबर हेल्पलाइन `1930`!",
    "steps_en": "Students design a 1-page home awareness poster with 4 rules: (1) Never share OTP, (2) Never enter UPI PIN to receive money, (3) Avoid unknown links, (4) Dial `1930` for cyber fraud!"
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "(बिना कंप्यूटर / परिवार जागरूकता गृहकार्य) आज शाम अपने माता-पिता या बड़े भाई-बहन को \"UPI PIN केवल पैसे भेजने के लिए होता है\" और हेल्पलाइन `1930` समझाएँ तथा उनकी सहमति के साथ 4 साइबर नियम कॉपी में लिखें।",
    "task_en": "(Family Awareness Homework) Tonight, explain the UPI PIN rule and Cyber Helpline `1930` to your parents or elders, and write the 4 cyber safety rules neatly in your notebook."
  },
  {
    "level": "BOARD",
    "task_hi": "वेब ब्राउज़र व सर्च इंजन में 2 अंतर, तथा ईमेल में `CC` और `BCC` के बीच अंतर उदाहरण सहित लिखें।",
    "task_en": "Write 2 differences between a Web Browser and a Search Engine, plus the difference between `CC` and `BCC` in Email with examples."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "3 उदाहरण बनाएँ: एक कमज़ोर पासवर्ड, एक मध्यम पासवर्ड और एक मज़बूत पासवर्ड (कम से कम 8 अक्षर — बिना अपना असली पासवर्ड लिखे!) और समझाएँ कि तीसरा क्यों सुरक्षित है।",
    "task_en": "Invent 3 sample passwords (Weak, Medium, Strong — never write your real password!) and explain the 4 rules that make the Strong one safe."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "यदि कोई दुकानदार या ग्राहक पैसे भेजने के लिए QR कोड भेजे, तो उसे स्कैन कर UPI PIN डालने से मेरे खाते में पैसे आ जाएँगे।",
    "misconception_en": "Scanning a QR code and entering my UPI PIN will credit money into my account.",
    "correction_hi": "यह बिहार की सबसे बड़ी ठगी है! बार-बार दोहराएँ: पैसे **पाने (Receive)** के लिए सिर्फ मोबाइल नंबर/UPI ID काफी है — **UPI PIN केवल पैसे कटवाने के लिए होता है!**",
    "correction_en": "This is one of the biggest scams! Emphasize repeatedly: to **RECEIVE** money you only share your UPI ID/number — **entering a UPI PIN ALWAYS sends money OUT!**"
  },
  {
    "misconception_hi": "Google Chrome और Google Search एक ही चीज़ हैं।",
    "misconception_en": "Google Chrome and Google Search are the exact same thing.",
    "correction_hi": "Chrome ब्राउज़र (ऐप/गाड़ी) है जिसके अंदर हम Google, Bing, DigiLocker या BSEB कोई भी वेबसाइट खोल सकते हैं।",
    "correction_en": "Chrome is the browser app (the vehicle) inside which you can open Google Search, Bing, DigiLocker, or BSEB."
  },
  {
    "misconception_hi": "यदि कोई लिंक व्हाट्सएप ग्रुप में किसी परिचित ने भेजा है, तो वह ज़रूर सुरक्षित होगा।",
    "misconception_en": "If a friend forwarded a scholarship link on WhatsApp, it must be genuine.",
    "correction_hi": "अक्सर परिचित भी अनजाने में फर्जी लिंक फॉरवर्ड कर देते हैं — हमेशा खुद `.gov.in` डोमेन और आधिकारिक स्कूल नोटिस जाँचें!",
    "correction_en": "Friends often forward fake links unknowingly — always verify the `.gov.in` domain and school notice yourself!"
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

-- Questions for skill-ict-ch5 (21 multi-mode items)
INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- #1: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000001', 'skill-ict-lab', 'skill-ict-ch5', 'Browser vs Search Engine', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'ICT Lab Core',
    'वेब ब्राउज़र और सर्च इंजन में क्या अंतर है?',
    'What is the difference between a Web Browser and a Search Engine?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "वेब ब्राउज़र (Web Browser) और सर्च इंजन (Search Engine) में क्या अंतर है? उदाहरण दें।",
  "front_en": "How is a Web Browser different from a Search Engine? Give examples.",
  "back_hi": "वेब ब्राउज़र वह सॉफ्टवेयर ऐप है जो वेबसाइट खोलता है (Chrome, Edge, Firefox)। सर्च इंजन वह वेबसाइट है जो इंटरनेट पर जानकारी खोजती है (Google Search, Bing)।",
  "back_en": "A Web Browser is the software app that opens websites (Chrome, Edge, Firefox). A Search Engine is a website that searches information on the web (Google Search, Bing).",
  "pronunciation_hi": "वेब ब्राउज़र बनाम सर्च इंजन",
  "mnemonic_hi": "ब्राउज़र = बस/गाड़ी (Chrome) · सर्च इंजन = पूछताछ काउंटर (Google)!",
  "mnemonic_en": "Browser = Vehicle (Chrome) · Search Engine = Inquiry Counter (Google)!"
}$json$::jsonb, true
  ),
  -- #2: FLASHCARD (BOARD, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000002', 'skill-ict-lab', 'skill-ict-ch5', 'Email CC vs BCC', 'PRACTICE', 'FLASHCARD', 'BOARD', 'BSEB ICT Model',
    'ईमेल में CC और BCC का पूरा नाम और मुख्य अंतर क्या है?',
    'What are the full forms and key difference between CC and BCC in Email?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "ईमेल में CC और BCC का पूरा नाम क्या है और गोपनीयता में क्या अंतर है?",
  "front_en": "State full forms of CC and BCC in Email and their privacy difference.",
  "back_hi": "CC = Carbon Copy (सबको एक-दूसरे का ईमेल पता दिखता है)। BCC = Blind Carbon Copy (प्राप्तकर्ताओं को एक-दूसरे का ईमेल पता नहीं दिखता — गोपनीयता सुरक्षित रहती है)।",
  "back_en": "CC = Carbon Copy (all recipients can see each other's email addresses). BCC = Blind Carbon Copy (recipient addresses stay hidden from each other for privacy).",
  "pronunciation_hi": "कार्बन कॉपी (CC) बनाम ब्लाइंड कार्बन कॉपी (BCC)",
  "mnemonic_hi": "B = Blind (पर्दा) → BCC में ईमेल पता दूसरों से छिपा रहता है!",
  "mnemonic_en": "B = Blind → BCC keeps recipient addresses invisible to others!"
}$json$::jsonb, true
  ),
  -- #3: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000003', 'skill-ict-lab', 'skill-ict-ch5', 'Phishing, OTP & Helpline 1930', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'Cyber Safety Essential',
    'फिशिंग (Phishing) क्या है और भारत की साइबर अपराध हेल्पलाइन संख्या क्या है?',
    'What is Phishing and what is India''s National Cyber Crime Helpline number?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "फिशिंग (Phishing) किसे कहते हैं और ऑनलाइन ठगी होने पर तुरंत किस हेल्पलाइन नंबर पर कॉल करें?",
  "front_en": "What is Phishing, and which national helpline number should you call immediately after cyber fraud?",
  "back_hi": "फिशिंग नकली बैंक/सरकारी लिंक, SMS या कॉल के ज़रिए OTP व पासवर्ड चुराने की ठगी है। वित्तीय साइबर ठगी होने पर तुरंत 1930 पर कॉल करें या cybercrime.gov.in पर शिकायत दर्ज करें।",
  "back_en": "Phishing is stealing passwords or OTPs using fake bank/govt links, SMS, or calls. Dial 1930 immediately (or visit cybercrime.gov.in) to report financial cyber fraud.",
  "pronunciation_hi": "फिशिंग (Phishing) · हेल्पलाइन 1930",
  "mnemonic_hi": "फिशिंग = लालच का काँटा (नकली लिंक/कॉल) · बचाव = 1930!",
  "mnemonic_en": "Phishing = Fake bait link/call · Emergency shield = Dial 1930!"
}$json$::jsonb, true
  ),
  -- #4: MATCH_PAIRS (FOUNDATION, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000004', 'skill-ict-lab', 'skill-ict-ch5', 'Digital Bihar & Safety Services', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'Digital Bihar Core',
    'इन डिजिटल सेवाओं और सुरक्षा शब्दों को उनके सही उपयोग से मिलाएँ:',
    'Match each Digital Bihar / Cyber Safety service with its exact purpose:',
    NULL, NULL,
    'DigiLocker दस्तावेज़ रखता है, RTPS प्रमाण-पत्र देता है, HTTPS वेबसाइट सुरक्षित करता है और 1930 ठगी रोकता है!', 'DigiLocker stores documents, RTPS issues certificates, HTTPS secures sites, and 1930 handles cyber fraud!',
    'DigiLocker मार्कशीट लॉकर है, RTPS Bihar जाति-आय-निवास पोर्टल है, HTTPS सुरक्षित वेबसाइट प्रोटोकॉल है और 1930 साइबर क्राइम हेल्पलाइन है।', 'DigiLocker stores marksheets, RTPS Bihar issues certificates, HTTPS encrypts web traffic, and 1930 is the National Cyber Crime Helpline.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "प्रत्येक डिजिटल सेवा को उसके सही कार्य से मिलाएँ",
  "instruction_en": "Pair each digital portal or term with its exact role",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "DigiLocker (डिजिलॉकर)",
      "left_en": "DigiLocker",
      "right_hi": "कानूनी रूप से मान्य डिजिटल मार्कशीट व आधार लॉकर",
      "right_en": "Legally valid digital marksheet & certificate locker"
    },
    {
      "id": "p2",
      "left_hi": "RTPS / ServicePlus Bihar",
      "left_en": "RTPS / ServicePlus Bihar",
      "right_hi": "जाति, आय व निवास प्रमाण-पत्र ऑनलाइन आवेदन",
      "right_en": "Online Caste, Income & Residence certificates"
    },
    {
      "id": "p3",
      "left_hi": "HTTPS (ताला चिह्न)",
      "left_en": "HTTPS (Padlock)",
      "right_hi": "सुरक्षित एन्क्रिप्टेड वेबसाइट कनेक्शन",
      "right_en": "Secure encrypted website connection"
    },
    {
      "id": "p4",
      "left_hi": "हेल्पलाइन 1930",
      "left_en": "Helpline 1930",
      "right_hi": "ऑनलाइन बैंकिंग व UPI ठगी की तुरंत शिकायत",
      "right_en": "Immediate reporting of online & UPI cyber fraud"
    }
  ]
}$json$::jsonb, true
  ),
  -- #5: SCENARIO_LAB (BOARD, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000005', 'skill-ict-lab', 'skill-ict-ch5', 'Email Composer — BCC Privacy', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'ICT Lab Practical',
    'ईमेल प्रयोगशाला: आपके स्कूल के शिक्षक 50 अभिभावकों को एक साथ परीक्षा समय-सारणी ईमेल करना चाहते हैं, लेकिन वे नहीं चाहते कि किसी अभिभावक को दूसरे का निजी ईमेल पता दिखे। वे सभी 50 पते किस खाने में डालेंगे?',
    'Email Composer Lab: Your teacher wants to email the exam schedule to 50 parents at once WITHOUT letting parents see each other''s private email IDs. Which email field should be used?',
    NULL, NULL,
    'उस विकल्प को चुनें जिसका अर्थ "Blind" (दूसरों से छिपा हुआ) होता है!', 'Choose the field whose first letter stands for "Blind" (hidden from others)!',
    '`BCC` (Blind Carbon Copy) में डाले गए सभी ईमेल पते दूसरों को दिखाई नहीं देते, जिससे सभी अभिभावकों की निजता (Privacy) सुरक्षित रहती है।', '`BCC` (Blind Carbon Copy) keeps all recipient email addresses invisible to one another, protecting parent privacy.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "EMAIL_COMPOSER",
  "scene_title_hi": "ईमेल गोपनीयता चुनौती — 50 अभिभावकों को सुरक्षित नोटिस भेजें",
  "scene_title_en": "Email Privacy Challenge — Send Exam Schedule to 50 Parents Safely",
  "prompt_hi": "50 अभिभावकों को एक साथ नोटिस भेजते समय दूसरों से ईमेल पता गुप्त रखने के लिए किस ईमेल फ़ील्ड का उपयोग करेंगे?",
  "prompt_en": "Which Email field keeps all 50 parent email addresses hidden from one another?",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "Mail",
      "label_hi": "To (मुख्य प्राप्तकर्ता)",
      "label_en": "To (Primary Recipient)"
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "BCC (Blind Carbon Copy)",
      "label_en": "BCC (Blind Carbon Copy)"
    },
    {
      "id": "c3",
      "icon": "Copy",
      "label_hi": "CC (Carbon Copy)",
      "label_en": "CC (Carbon Copy)"
    },
    {
      "id": "c4",
      "icon": "Link2",
      "label_hi": "Attachment (संलग्न फाइल)",
      "label_en": "Attachment (Attach File)"
    }
  ],
  "correct_choice_id": "c2"
}$json$::jsonb, true
  ),
  -- #6: SCENARIO_LAB (FOUNDATION, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000006', 'skill-ict-lab', 'skill-ict-ch5', 'Cyber Safety — Fake Bihar Scholarship OTP Scam', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', 'Real Bihar Cyber Safety',
    'साइबर सुरक्षा चुनौती: एक अनजान नंबर से फोन आता है — "मैं पटना शिक्षा विभाग से बोल रहा हूँ! आपके खाते में ₹10,000 बिहार मैट्रिक प्रोत्साहन छात्रवृत्ति तुरंत आएगी, अभी फोन पर आया 6-अंक का OTP बताएँ!" आप क्या करेंगे?',
    'Cyber Safety Challenge: An unknown caller claims — "Calling from Patna Education Office! Your ₹10,000 Bihar Matric Scholarship is ready right now, just read me the 6-digit OTP on your phone!" What should you do?',
    NULL, NULL,
    'क्या कोई सरकारी विभाग या बैंक कभी फोन करके आपसे OTP माँगता है?', 'Does any government office or bank EVER ask for your OTP over the phone?',
    'शाबाश! यह 100% फर्जी छात्रवृत्ति ठगी है! कोई भी सरकारी अधिकारी या बैंक कभी OTP नहीं माँगता। तुरंत फोन काटें और केवल आधिकारिक `.gov.in` पोर्टल या अपने स्कूल से जानकारी लें।', 'Spot on! This is a 100% fake scholarship scam. No government office or bank ever asks for OTPs — hang up immediately and verify only through your school or official `.gov.in` portals.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "CYBER_SAFETY",
  "scene_title_hi": "असली बिहार खतरा: फर्जी ₹10,000 छात्रवृत्ति OTP कॉल!",
  "scene_title_en": "Real Bihar Threat: Fake ₹10,000 Scholarship OTP Call!",
  "prompt_hi": "कॉलर कह रहा है: \"जल्दी 6-अंक का OTP बताइए वरना आज आपकी ₹10,000 छात्रवृत्ति रद्द हो जाएगी!\" — सही सुरक्षित निर्णय चुनें:",
  "prompt_en": "Caller pressures you: \"Read your 6-digit OTP within 10 seconds or your ₹10,000 scholarship will cancel!\" — Pick the ONLY safe response:",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "Lock",
      "label_hi": "अपने बैंक का पासवर्ड और जन्मतिथि बता दें",
      "label_en": "Share your bank password and date of birth"
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "जल्दी से 6-अंक का OTP बता दें ताकि ₹10,000 आ जाएँ",
      "label_en": "Quickly share the 6-digit OTP to get ₹10,000"
    },
    {
      "id": "c3",
      "icon": "Mail",
      "label_hi": "उन्हें अपने पिताजी के एटीएम कार्ड की फोटो भेज दें",
      "label_en": "Send a photo of your father's ATM card"
    },
    {
      "id": "c4",
      "icon": "Search",
      "label_hi": "तुरंत फोन काटें — OTP कभी न बताएँ और स्कूल/आधिकारिक .gov.in पर जाँचें",
      "label_en": "Hang up immediately — NEVER share OTP; verify with school or .gov.in"
    }
  ],
  "correct_choice_id": "c4"
}$json$::jsonb, true
  ),
  -- #7: SCENARIO_LAB (BOARD, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000007', 'skill-ict-lab', 'skill-ict-ch5', 'Cyber Safety — Fake UPI QR Receive Scam', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'Real Bihar Cyber Safety',
    'साइबर सुरक्षा चुनौती: आपने पुरानी साइकिल बेचने के लिए विज्ञापन डाला। एक अनजान खरीदार व्हाट्सएप पर QR कोड भेजकर कहता है — "₹2,500 आपके खाते में भेज रहा हूँ, बस इसे स्कैन करके अपना UPI PIN डाल दें!" आप क्या करेंगे?',
    'Cyber Safety Challenge: You listed an old bicycle for sale. A stranger sends a QR code on WhatsApp saying — "Scan this and enter your UPI PIN to RECEIVE ₹2,500!" What will you do?',
    NULL, NULL,
    'सुनहरा UPI नियम याद करें: क्या पैसे प्राप्त करने (Receive) के लिए कभी UPI PIN डालना पड़ता है?', 'Remember the golden UPI rule: do you EVER enter a UPI PIN to RECEIVE money?',
    'अद्भुत बचाव! QR कोड स्कैन कर UPI PIN डालने से पैसे आते नहीं बल्कि **आपके खाते से ₹2,500 कट जाएँगे**! पैसे पाने के लिए कभी PIN या QR स्कैन नहीं करना होता। ठग को ब्लॉक करें और ज़रूरत पड़े तो `1930` पर रिपोर्ट करें।', 'Brilliant catch! Scanning a QR and entering your UPI PIN sends ₹2,500 OUT of your account! You NEVER scan a QR or enter a PIN to receive money. Refuse, block the scammer, and report to `1930` if needed.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "CYBER_SAFETY",
  "scene_title_hi": "UPI QR ठगी अलर्ट — \"पैसे लेने के लिए PIN डालें!\"",
  "scene_title_en": "UPI QR Trap Alert — \"Enter UPI PIN to Receive ₹2,500!\"",
  "prompt_hi": "एक अनजान खरीदार आपको ₹2,500 \"भेजने\" के लिए QR कोड स्कैन कर UPI PIN डालने को कह रहा है। सबसे सुरक्षित कदम चुनें:",
  "prompt_en": "A stranger tells you to scan a QR code and type your UPI PIN to \"receive\" ₹2,500. Choose the safe action:",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "Lock",
      "label_hi": "साफ मना करें व नंबर ब्लॉक करें — पैसे लेने के लिए कभी UPI PIN नहीं लगता!",
      "label_en": "Refuse & block — UPI PIN is NEVER needed to receive money!"
    },
    {
      "id": "c2",
      "icon": "Link2",
      "label_hi": "QR स्कैन करें और एक बार अपना UPI PIN डालकर देखें",
      "label_en": "Scan the QR and try entering your UPI PIN once"
    },
    {
      "id": "c3",
      "icon": "Mail",
      "label_hi": "पहले उन्हें ₹100 भेजकर खाता चालू (Activate) करें",
      "label_en": "Send ₹100 first to \"activate\" the transfer"
    },
    {
      "id": "c4",
      "icon": "MessageSquare",
      "label_hi": "अपना बैंक पासवर्ड उन्हें चैट में लिख दें",
      "label_en": "Type your bank password in chat instead"
    }
  ],
  "correct_choice_id": "c1"
}$json$::jsonb, true
  ),
  -- #8: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000008', 'skill-ict-lab', 'skill-ict-ch5', 'HTTPS Secure Meaning', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB ICT Model',
    'वेबसाइट के पते `HTTPS` में अक्षर `S` का क्या अर्थ है?',
    'What does the letter `S` stand for in `HTTPS`?',
    $json$[{"key":"A","text_hi":"Secure (सुरक्षित)","text_en":"Secure"},{"key":"B","text_hi":"Simple (सरल)","text_en":"Simple"},{"key":"C","text_hi":"Speed (गति)","text_en":"Speed"},{"key":"D","text_hi":"Server (सर्वर)","text_en":"Server"}]$json$::jsonb, 'A',
    'एड्रेस बार में ताले (Padlock) का चिह्न क्या दर्शाता है?', 'What does the padlock symbol in the address bar guarantee?',
    'HTTPS = HyperText Transfer Protocol **Secure**। यह आपके और वेबसाइट के बीच डेटा को एन्क्रिप्ट (तालाबंद) रखकर सुरक्षित बनाता है।', 'HTTPS stands for HyperText Transfer Protocol **Secure**, encrypting data between your browser and the website.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #9: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000009', 'skill-ict-lab', 'skill-ict-ch5', 'Cyber Crime Helpline', 'PRACTICE', 'MCQ', 'FOUNDATION', 'Cyber Safety Essential',
    'भारत में ऑनलाइन बैंकिंग या UPI ठगी होने पर तुरंत शिकायत करने के लिए राष्ट्रीय साइबर अपराध हेल्पलाइन नंबर क्या है?',
    'What is India''s National Cyber Crime Helpline number to immediately report online financial or UPI fraud?',
    $json$[{"key":"A","text_hi":"101","text_en":"101"},{"key":"B","text_hi":"108","text_en":"108"},{"key":"C","text_hi":"1930","text_en":"1930"},{"key":"D","text_hi":"139","text_en":"139"}]$json$::jsonb, 'C',
    '101 दमकल, 108 एम्बुलेंस और 139 रेलवे है — बचा हुआ नंबर साइबर सुरक्षा का है!', '101 is Fire, 108 is Ambulance, 139 is Railways — pick the Cyber Helpline!',
    'राष्ट्रीय साइबर अपराध हेल्पलाइन नंबर **`1930`** है (तथा पोर्टल `cybercrime.gov.in`)। ठगी के तुरंत बाद कॉल करने से पैसा फ्रीज़ करने में मदद मिलती है।', 'India''s National Cyber Crime Helpline is **`1930`** (and `cybercrime.gov.in`). Calling quickly helps freeze fraudulent transfers.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #10: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000010', 'skill-ict-lab', 'skill-ict-ch5', 'Web Browser Example', 'PRACTICE', 'MCQ', 'FOUNDATION', 'ICT Lab Core',
    'निम्नलिखित में से कौन-सा एक "वेब ब्राउज़र (Web Browser)" है?',
    'Which of the following is a Web Browser?',
    $json$[{"key":"A","text_hi":"MS Excel","text_en":"MS Excel"},{"key":"B","text_hi":"Notepad","text_en":"Notepad"},{"key":"C","text_hi":"MS Paint","text_en":"MS Paint"},{"key":"D","text_hi":"Google Chrome","text_en":"Google Chrome"}]$json$::jsonb, 'D',
    'इनमें से किस ऐप से आप इंटरनेट पर वेबसाइट खोलते हैं?', 'Which of these apps opens websites on the internet?',
    'Google Chrome (साथ ही Microsoft Edge व Mozilla Firefox) एक वेब ब्राउज़र है। MS Excel, Paint और Notepad ऑफलाइन एप्लिकेशन हैं।', 'Google Chrome (along with Microsoft Edge and Mozilla Firefox) is a Web Browser.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #11: MCQ (BOARD, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000011', 'skill-ict-lab', 'skill-ict-ch5', 'Government Domain Verification', 'PRACTICE', 'MCQ', 'BOARD', 'Digital Bihar Core',
    'इनमें से कौन-सा वेब पता भारत सरकार या बिहार सरकार के आधिकारिक पोर्टल की पहचान कराता है?',
    'Which web address ending identifies an official Indian or Bihar Government portal?',
    $json$[{"key":"A","text_hi":"bihar-scholarship-win.xyz","text_en":"bihar-scholarship-win.xyz"},{"key":"B","text_hi":"serviceonline.bihar.gov.in","text_en":"serviceonline.bihar.gov.in"},{"key":"C","text_hi":"free-bseb-money.blogspot.com","text_en":"free-bseb-money.blogspot.com"},{"key":"D","text_hi":"result-claim-now.top","text_en":"result-claim-now.top"}]$json$::jsonb, 'B',
    'आधिकारिक भारतीय सरकारी वेबसाइट के अंत में `.gov.in` या `.nic.in` होता है!', 'Genuine Indian government portals end in `.gov.in` or `.nic.in`!',
    '`serviceonline.bihar.gov.in` बिहार सरकार का आधिकारिक RTPS पोर्टल है क्योंकि इसके अंत में `.gov.in` जुड़ा है।', '`serviceonline.bihar.gov.in` is Bihar''s official RTPS government portal verified by the `.gov.in` domain.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #12: MCQ (BOARD, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000012', 'skill-ict-lab', 'skill-ict-ch5', 'Strong Password Rules', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    'इनमें से कौन-सा पासवर्ड सबसे मज़बूत और सुरक्षित (Strong Password) माना जाएगा?',
    'Which of the following is the strongest and safest password?',
    $json$[{"key":"A","text_hi":"12345678","text_en":"12345678"},{"key":"B","text_hi":"bihar2009","text_en":"bihar2009"},{"key":"C","text_hi":"N@landa#92k","text_en":"N@landa#92k"},{"key":"D","text_hi":"password","text_en":"password"}]$json$::jsonb, 'C',
    'जिसमें कम से कम 8 अक्षर हों और बड़ा अक्षर + छोटा अक्षर + अंक + विशेष चिह्न (`@`, `#`) चारों हों!', 'Pick the one with 8+ chars combining Uppercase, lowercase, digits, and special symbols!',
    '`N@landa#92k` में 11 अक्षर हैं और बड़ा अक्षर (`N`), छोटे अक्षर, अंक (`92`) तथा विशेष चिह्न (`@`, `#`) चारों शामिल हैं, इसलिए इसे अनुमान लगाना बेहद कठिन है।', '`N@landa#92k` has 11 characters mixing uppercase, lowercase, digits, and symbols (`@`, `#`), making it strong against guessing.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #13: MCQ (BOARD, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000013', 'skill-ict-lab', 'skill-ict-ch5', 'Email Validity', 'PRACTICE', 'MCQ', 'BOARD', NULL,
    'निम्नलिखित में से कौन-सा ईमेल पता तकनीकी रूप से सही (Valid) है?',
    'Which of the following email addresses is technically valid?',
    $json$[{"key":"A","text_hi":"priya.kumari@gmail.com","text_en":"priya.kumari@gmail.com"},{"key":"B","text_hi":"priya.kumari.gmail.com","text_en":"priya.kumari.gmail.com"},{"key":"C","text_hi":"priya kumari@gmail.com","text_en":"priya kumari@gmail.com"},{"key":"D","text_hi":"priya@@gmail.com","text_en":"priya@@gmail.com"}]$json$::jsonb, 'A',
    'सही ईमेल में ठीक एक `@` चिह्न होता है और बीच में कोई खाली जगह (Space) नहीं होती!', 'A valid email has ZERO spaces and EXACTLY ONE `@` symbol!',
    '`priya.kumari@gmail.com` बिल्कुल मान्य है क्योंकि इसमें कोई स्पेस नहीं है, ठीक एक `@` है और वैध डोमेन (`gmail.com`) है।', '`priya.kumari@gmail.com` is valid: no spaces, exactly one `@`, and a proper domain.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #14: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000014', 'skill-ict-lab', 'skill-ict-ch5', 'Phishing Identification', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB ICT Model',
    'असली बैंक या सरकारी संस्था जैसा नकली ईमेल/SMS भेजकर यूज़र का पासवर्ड, एटीएम पिन या OTP चुराने के साइबर हमले को क्या कहते हैं?',
    'What is the cyber attack called when scammers send fake bank/govt SMS or emails to trick users into giving passwords or OTPs?',
    $json$[{"key":"A","text_hi":"बूटिंग (Booting)","text_en":"Booting"},{"key":"B","text_hi":"फिशिंग (Phishing)","text_en":"Phishing"},{"key":"C","text_hi":"फॉर्मेटिंग (Formatting)","text_en":"Formatting"},{"key":"D","text_hi":"सॉर्टिंग (Sorting)","text_en":"Sorting"}]$json$::jsonb, 'B',
    'लालच का काँटा डालकर शिकार फँसाने जैसा शब्द याद करें!', 'Sounds just like casting bait to "fish" for private passwords!',
    'फिशिंग (Phishing) एक सामाजिक ठगी (Social Engineering) हमला है जिसमें नकली संदेश या वेबसाइट से निजी जानकारी चुराई जाती है।', 'Phishing uses disguised fake emails, SMS, or websites to steal confidential credentials like OTPs and passwords.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #15: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000015', 'skill-ict-lab', 'skill-ict-ch5', 'Shared PC Security', 'PRACTICE', 'MCQ', 'TOPPER', NULL,
    'यदि आपने किसी साइबर कैफे या स्कूल लैब के साझा कंप्यूटर पर अपना ईमेल या DigiLocker खोला है, तो काम खत्म होने पर सबसे ज़रूरी सुरक्षा कदम क्या है?',
    'After opening your Email or DigiLocker on a shared cyber cafe or school lab PC, what is the MOST essential security step before leaving?',
    $json$[{"key":"A","text_hi":"ब्राउज़र में \"Save Password\" पर क्लिक कर दें","text_en":"Click \"Save Password\" in the browser"},{"key":"B","text_hi":"अपना पासवर्ड डेस्कटॉप पर Notepad में सेव छोड़ दें","text_en":"Leave your password typed in Desktop Notepad"},{"key":"C","text_hi":"सिर्फ मॉनिटर की लाइट बंद करके चले जाएँ","text_en":"Only switch off the monitor and walk away"},{"key":"D","text_hi":"खाते से Sign Out / Log Out करें और ब्राउज़र टैब बंद करें","text_en":"Click Sign Out / Log Out cleanly and close the browser"}]$json$::jsonb, 'D',
    'यदि आप लॉग-आउट नहीं करेंगे, तो आपके बाद बैठने वाला व्यक्ति आपका खाता खोल सकता है!', 'Without signing out, the very next person sitting at that PC can access your account!',
    'साझा कंप्यूटर पर कभी भी पासवर्ड Save न करें और उठने से पहले हमेशा **Sign Out / Log Out** करके टैब बंद करें (या Incognito/Private window उपयोग करें)।', 'Never save passwords on shared PCs — always Sign Out / Log Out cleanly (and prefer Private/Incognito mode).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #16: MCQ (FOUNDATION, EXAM_ONLY)
  (
    '10000005-0005-4000-8000-000000000016', 'skill-ict-lab', 'skill-ict-ch5', 'URL Full Form', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'ICT Live Exam',
    'इंटरनेट शब्दावली में `URL` का पूरा नाम क्या है?',
    'What is the full form of `URL` in internet terminology?',
    $json$[{"key":"A","text_hi":"Universal Radio Link","text_en":"Universal Radio Link"},{"key":"B","text_hi":"User Record List","text_en":"User Record List"},{"key":"C","text_hi":"Uniform Resource Locator","text_en":"Uniform Resource Locator"},{"key":"D","text_hi":"Unified Routing Line","text_en":"Unified Routing Line"}]$json$::jsonb, 'C',
    'यह वेब पर किसी संसाधन (Resource) का स्थान (Locator) बताता है!', 'It locates a specific web resource!',
    'URL का पूरा नाम **Uniform Resource Locator** है, जो किसी वेबपेज के सटीक पते को दर्शाता है।', 'URL stands for **Uniform Resource Locator** — the exact address of a resource on the web.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #17: MCQ (BOARD, EXAM_ONLY)
  (
    '10000005-0005-4000-8000-000000000017', 'skill-ict-lab', 'skill-ict-ch5', 'DigiLocker Purpose', 'EXAM_ONLY', 'MCQ', 'BOARD', 'ICT Live Exam',
    'भारत सरकार के `DigiLocker` पोर्टल का मुख्य उपयोग क्या है?',
    'What is the primary purpose of Government of India''s `DigiLocker` portal?',
    $json$[{"key":"A","text_hi":"ऑनलाइन वीडियो गेम खेलना","text_en":"Playing online video games"},{"key":"B","text_hi":"आधिकारिक मार्कशीट, आधार व प्रमाण-पत्रों को सुरक्षित डिजिटल रूप में सहेजना","text_en":"Storing verified official marksheets, Aadhaar, and certificates securely online"},{"key":"C","text_hi":"फोटो एडिटिंग करना","text_en":"Photo editing"},{"key":"D","text_hi":"ऑफलाइन एक्सेल फॉर्मूला चलाना","text_en":"Running offline Excel formulas"}]$json$::jsonb, 'B',
    '"Digital Locker" — यानी आपके जरूरी दस्तावेज़ों की सरकारी डिजिटल तिजोरी!', '"Digital Locker" — an official vault for your important documents!',
    'DigiLocker में आपकी BSEB मार्कशीट, आधार और प्रमाण-पत्र सुरक्षित रहते हैं और IT अधिनियम के तहत मूल दस्तावेज़ के बराबर मान्य होते हैं।', 'DigiLocker securely stores your BSEB marksheets, Aadhaar, and official certificates with full legal validity.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #18: MCQ (TOPPER, EXAM_ONLY)
  (
    '10000005-0005-4000-8000-000000000018', 'skill-ict-lab', 'skill-ict-ch5', 'UPI Safety Rule', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'ICT Live Exam',
    'UPI भुगतान प्रणाली के संबंध में निम्नलिखित में से कौन-सा कथन 100% सत्य है?',
    'Which statement about UPI digital payments is 100% TRUE?',
    $json$[{"key":"A","text_hi":"UPI PIN केवल अपने खाते से पैसे भेजने या बैलेंस जाँचने के लिए उपयोग होता है — पैसे लेने के लिए कभी नहीं","text_en":"UPI PIN is ONLY for sending money out or checking balance — never for receiving money"},{"key":"B","text_hi":"पैसे प्राप्त करने (Receive) के लिए UPI PIN डालना ज़रूरी होता है","text_en":"You must enter your UPI PIN to receive money"},{"key":"C","text_hi":"UPI PIN अपने दोस्तों व दुकानदार के साथ साझा करना चाहिए","text_en":"You should share your UPI PIN with shopkeepers"},{"key":"D","text_hi":"किसी भी अनजान QR कोड को स्कैन करने पर इनाम का पैसा आता है","text_en":"Scanning random QR codes credits prize money"}]$json$::jsonb, 'A',
    'याद रखें: PIN डालना मतलब खाते से पैसा निकलना!', 'Remember: entering your UPI PIN authorizes money leaving YOUR account!',
    'पैसे पाने के लिए कभी UPI PIN नहीं लगता। UPI PIN केवल आपके खाते से पैसे भेजने (Debit) या स्वयं बैलेंस जाँचने के लिए होता है।', 'You NEVER need a UPI PIN to receive money; entering it only authorizes outgoing payments or balance checks.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #19: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000019', 'skill-ict-lab', 'skill-ict-ch5', 'Browser vs Search Engine', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'वेब ब्राउज़र और सर्च इंजन में दो मुख्य अंतर उदाहरण सहित लिखें।',
    'Write two key differences between a Web Browser and a Search Engine with examples.',
    NULL, NULL,
    'दोनों का कार्य और 2-2 सही उदाहरण लिखें।', 'Contrast their roles and list 2 accurate examples for each.',
    NULL, NULL,
    '1. **परिभाषा व कार्य:** **वेब ब्राउज़र** कंप्यूटर या फोन में इंस्टॉल एक सॉफ्टवेयर ऐप है जो वेबपेज खोलकर दिखाता है, जबकि **सर्च इंजन** एक विशेष वेबसाइट है जिसे ब्राउज़र के अंदर खोलकर इंटरनेट पर जानकारी खोजी जाती है।
2. **उदाहरण:** वेब ब्राउज़र — **Google Chrome, Microsoft Edge, Mozilla Firefox**। सर्च इंजन — **Google Search, Bing, DuckDuckGo**।', '1. **Role:** A **Web Browser** is an installed software app on your device that opens and displays web pages, whereas a **Search Engine** is a website accessed inside a browser to search information across the internet.
2. **Examples:** Web Browsers — **Google Chrome, Microsoft Edge, Mozilla Firefox**. Search Engines — **Google Search, Bing, DuckDuckGo**.',
    $json$[{"cue_hi":"ब्राउज़र = सॉफ्टवेयर ऐप (Chrome, Firefox)","cue_en":"Browser = Installed App (Chrome, Firefox)"},{"cue_hi":"सर्च इंजन = खोज वेबसाइट (Google, Bing)","cue_en":"Search Engine = Search Website (Google, Bing)"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"ब्राउज़र (ऐप) व सर्च इंजन (वेबसाइट) का स्पष्ट अंतर","criterion_en":"Clear distinction between browser app and search website"},{"step_no":2,"marks":1,"criterion_hi":"प्रत्येक के 2 सटीक उदाहरण","criterion_en":"2 accurate examples for each"}]$json$::jsonb,
    NULL, true
  ),
  -- #20: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000020', 'skill-ict-lab', 'skill-ict-ch5', 'Phishing & Strong Password', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'फिशिंग (Phishing) क्या है? एक मज़बूत पासवर्ड (Strong Password) बनाने के 3 नियम लिखें।',
    'What is Phishing? Write 3 rules for creating a Strong Password.',
    NULL, NULL,
    'नकली लिंक/कॉल की परिभाषा + पासवर्ड की लंबाई व अक्षरों का मिश्रण लिखें।', 'Define fake credential theft + password length and character mix.',
    NULL, NULL,
    '- **फिशिंग (Phishing):** असली बैंक, सरकारी संस्था या छात्रवृत्ति पोर्टल का नकली रूप दिखाकर SMS, ईमेल या फोन कॉल के ज़रिए पासवर्ड, एटीएम विवरण या OTP चुराने की साइबर ठगी को फिशिंग कहते हैं।
- **मज़बूत पासवर्ड के 3 नियम:**
  1. कम से कम **8 से 12 अक्षर** लंबा हो।
  2. इसमें बड़े अक्षर (`A–Z`), छोटे अक्षर (`a–z`), अंक (`0–9`) और विशेष चिह्न (`@`, `#`, `!`) चारों का मिश्रण हो।
  3. इसमें कभी भी `123456`, अपना नाम या जन्मतिथि न रखें।', '- **Phishing:** A cyber scam where attackers send fake emails, SMS links, or calls pretending to be a trusted bank or government office to steal passwords, bank details, or OTPs.
- **3 Rules for a Strong Password:**
  1. At least **8–12 characters** long.
  2. Mix uppercase (`A–Z`), lowercase (`a–z`), numbers (`0–9`), and special symbols (`@`, `#`, `!`).
  3. Never use `123456`, your name, mobile number, or date of birth.',
    $json$[{"cue_hi":"फिशिंग = नकली बैंक/छात्रवृत्ति लिंक से डेटा चोरी","cue_en":"Phishing = Fake link/call stealing OTP or password"},{"cue_hi":"पासवर्ड = 8+ अक्षर + A-Z + a-z + 0-9 + @#!","cue_en":"Password = 8+ chars + Upper + lower + digit + symbol"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"फिशिंग की सटीक परिभाषा","criterion_en":"Accurate definition of Phishing"},{"step_no":2,"marks":1,"criterion_hi":"मज़बूत पासवर्ड के 3 सही नियम","criterion_en":"3 valid rules for a strong password"}]$json$::jsonb,
    NULL, true
  ),
  -- #21: LONG_5M (TOPPER, PRACTICE)
  (
    '10000005-0005-4000-8000-000000000021', 'skill-ict-lab', 'skill-ict-ch5', 'Cyber Safety 5 Golden Rules', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB ICT Practical',
    'बिहार के विद्यार्थियों और परिवारों के लिए "साइबर सुरक्षा के 5 सुनहरे नियम" विस्तार से लिखें (OTP, UPI PIN, सरकारी वेबसाइट पहचान, साझा कंप्यूटर सुरक्षा और हेल्पलाइन 1930 सहित)।',
    'Explain the "5 Golden Rules of Cyber Safety" for students and families in Bihar — covering OTP safety, UPI PIN rule, verifying `.gov.in` websites, shared PC logout, and National Helpline 1930.',
    NULL, NULL,
    'पाँचों बिंदुओं को स्पष्ट शीर्षक और वास्तविक दैनिक उदाहरण के साथ लिखें।', 'Present all 5 headings with clear practical examples for full marks.',
    NULL, NULL,
    'डिजिटल बिहार में सुरक्षित रहने के लिए प्रत्येक विद्यार्थी और परिवार को ये **5 सुनहरे साइबर नियम** अपनाने चाहिए:

**1. OTP और पासवर्ड कभी साझा न करें:** आपका OTP और ATM/बैंक पासवर्ड आपके घर की चाबी है। कोई भी बैंक, पुलिस या छात्रवृत्ति अधिकारी कभी फोन पर OTP नहीं माँगता। ऐसे कॉल तुरंत काट दें।

**2. सुनहरा UPI नियम (पैसे लेने पर PIN नहीं!):** पैसे प्राप्त करने (Receive) के लिए कभी भी QR कोड स्कैन नहीं करना होता और न ही UPI PIN डाला जाता है। UPI PIN केवल अपने खाते से पैसे भेजने के लिए होता है।

**3. आधिकारिक `.gov.in` व `HTTPS` ताला जाँचें:** एडमिट कार्ड, रिजल्ट या छात्रवृत्ति फॉर्म भरने से पहले हमेशा देखें कि वेबसाइट पर `HTTPS` (ताला चिह्न) और `.gov.in` या `.nic.in` डोमेन हो। व्हाट्सएप पर आने वाले फर्जी `.xyz` या इनाम लिंक पर कभी क्लिक न करें।

**4. मज़बूत पासवर्ड व साझा कंप्यूटर से Log Out:** 8+ अक्षरों का मिश्रित पासवर्ड रखें (A-Z, a-z, 0-9, @#!) और स्कूल ICT लैब या साइबर कैफे के कंप्यूटर पर काम खत्म होते ही **Sign Out / Log Out** ज़रूर करें — वहाँ पासवर्ड कभी Save न करें।

**5. धोखाधड़ी पर तुरंत हेल्पलाइन `1930` पर रिपोर्ट करें:** यदि किसी परिजन के साथ ऑनलाइन वित्तीय ठगी हो जाए, तो बिना देरी किए **राष्ट्रीय साइबर अपराध हेल्पलाइन `1930`** पर कॉल करें या `cybercrime.gov.in` पर शिकायत दर्ज करें ताकि पैसा तुरंत फ्रीज़ किया जा सके।', 'Every student and family should practice these **5 Golden Rules of Cyber Safety**:

**1. Never Share OTP or Passwords:** Your OTP and password are the keys to your bank account. No bank or government scholarship officer ever asks for your OTP over a call — hang up immediately.

**2. The Golden UPI Rule:** You NEVER scan a QR code or enter your UPI PIN to RECEIVE money. Entering a UPI PIN strictly authorizes money leaving YOUR account.

**3. Verify `HTTPS` Padlock & `.gov.in` Domains:** Before entering exam or scholarship details, confirm the site uses `HTTPS` and ends in `.gov.in` or `.nic.in`. Never tap suspicious `.xyz` prize links on WhatsApp.

**4. Strong Passwords & Shared PC Logout:** Use 8+ character passwords mixing uppercase, lowercase, numbers, and symbols. Always click **Sign Out / Log Out** (and never click "Save Password") on cyber cafe or school lab PCs.

**5. Dial `1930` Immediately on Fraud:** If financial cyber fraud occurs, call India''s **National Cyber Crime Helpline `1930`** (or report at `cybercrime.gov.in`) within the golden hour to help freeze the fraudulent transfer.',
    $json$[{"cue_hi":"1. OTP नहीं · 2. पैसे लेने पर UPI PIN नहीं","cue_en":"1. Never share OTP · 2. No UPI PIN to receive"},{"cue_hi":"3. HTTPS + .gov.in जाँचें · 4. साझा PC से Log Out","cue_en":"3. Verify HTTPS & .gov.in · 4. Log Out shared PCs"},{"cue_hi":"5. ठगी पर तुरंत 1930 पर कॉल करें","cue_en":"5. Call 1930 immediately on fraud"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"OTP व फर्जी छात्रवृत्ति कॉल से बचाव","criterion_en":"OTP & fake scholarship call safety"},{"step_no":2,"marks":1,"criterion_hi":"UPI PIN व QR स्कैन नियम का सही वर्णन","criterion_en":"Accurate UPI PIN & QR receive-scam rule"},{"step_no":3,"marks":1,"criterion_hi":"HTTPS व .gov.in / .nic.in डोमेन सत्यापन","criterion_en":"HTTPS padlock and .gov.in domain verification"},{"step_no":4,"marks":1,"criterion_hi":"मज़बूत पासवर्ड और साझा PC पर Log Out आदत","criterion_en":"Strong passwords and logging out of shared PCs"},{"step_no":5,"marks":1,"criterion_hi":"साइबर हेल्पलाइन 1930 व cybercrime.gov.in का उल्लेख","criterion_en":"Mentions Helpline 1930 and cybercrime.gov.in"}]$json$::jsonb,
    NULL, true
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
-- CHAPTER 6 OF 6: SKILL-ICT-CH6 — ARTIFICIAL INTELLIGENCE (AI) & SMART STUDYING
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'skill-ict-ch6',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: कृत्रिम बुद्धिमत्ता (AI) और स्मार्ट पढ़ाई",
  "title_en": "30-Second Mindmap: Artificial Intelligence (AI) & Smart Studying",
  "read_time_seconds": 30,
  "central_node": {
    "id": "ict6-root",
    "label_hi": "कृत्रिम बुद्धिमत्ता (Artificial Intelligence · AI)",
    "label_en": "Artificial Intelligence (AI)",
    "subtitle_hi": "सही सवाल पूछें, स्मार्ट पढ़ाई करें और AI के खतरों से सावधान रहें",
    "subtitle_en": "Ask smart prompts, study deeper & stay safe from hallucinations & deepfakes"
  },
  "branches": [
    {
      "id": "ict6-b1",
      "label_hi": "1. AI क्या है? (पैटर्न से सीखना)",
      "label_en": "1. What is AI? (Learning Patterns)",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "ict6-b1-1",
          "label_hi": "कैलकुलेटर = तय नियम · AI = उदाहरणों से सीखना",
          "label_en": "Calculator = Fixed rules · AI = Learns from examples"
        },
        {
          "id": "ict6-b1-2",
          "label_hi": "दैनिक AI: हिंदी वॉइस टाइपिंग, गूगल मैप्स, अनुवाद, यूट्यूब सुझाव",
          "label_en": "Daily AI: Voice Typing, Maps, Translation, YouTube"
        }
      ]
    },
    {
      "id": "ict6-b2",
      "label_hi": "2. R-C-F स्मार्ट प्रॉम्प्ट फॉर्मूला",
      "label_en": "2. R-C-F Smart Prompt Formula",
      "color": "#059669",
      "children": [
        {
          "id": "ict6-b2-1",
          "label_hi": "R (Role): मैं बिहार बोर्ड कक्षा 10 का छात्र हूँ",
          "label_en": "R (Role): I am a Class 10 Bihar Board student"
        },
        {
          "id": "ict6-b2-2",
          "label_hi": "C (Clear Topic): ओम का नियम सरल उदाहरण से समझाओ",
          "label_en": "C (Clear Topic): Explain Ohm's Law with simple analogy"
        },
        {
          "id": "ict6-b2-3",
          "label_hi": "F (Format): 5 बिंदुओं में + 3 अभ्यास प्रश्न दो",
          "label_en": "F (Format): In 5 bullet points + 3 quiz questions"
        }
      ]
    },
    {
      "id": "ict6-b3",
      "label_hi": "3. स्मार्ट पढ़ाई बनाम आलसी नकल",
      "label_en": "3. Smart Tutor vs Lazy Cheating",
      "color": "#D97706",
      "children": [
        {
          "id": "ict6-b3-1",
          "label_hi": "सही उपयोग: कठिन विषय समझना, क्विज़ व व्याकरण जाँच",
          "label_en": "Smart use: Clarify doubts, practice quizzes, check grammar"
        },
        {
          "id": "ict6-b3-2",
          "label_hi": "गलत उपयोग: बिना पढ़े कॉपी-पेस्ट (परीक्षा हॉल में फोन नहीं!)",
          "label_en": "Bad use: Blind copy-paste (no phone in exam hall!)"
        }
      ]
    },
    {
      "id": "ict6-b4",
      "label_hi": "4. AI सुरक्षा: Hallucination व Deepfake",
      "label_en": "4. AI Safety: Hallucinations & Deepfakes",
      "color": "#7C3AED",
      "children": [
        {
          "id": "ict6-b4-1",
          "label_hi": "Hallucination: AI आत्मविश्वास से गलत तथ्य गढ़ सकता है → किताब से जाँचें!",
          "label_en": "Hallucination: AI can invent wrong facts → verify with textbook!"
        },
        {
          "id": "ict6-b4-2",
          "label_hi": "Deepfake: नकली आवाज़/चेहरा वीडियो → असली नंबर पर कॉल कर जाँचें!",
          "label_en": "Deepfake: Fake cloned voice/video → call back real number!"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "ict6-sec-1-what-is-ai",
    "order": 1,
    "heading_hi": "1. कृत्रिम बुद्धिमत्ता (AI) क्या है? यह पहले से आपकी जेब में है!",
    "heading_en": "1. What is Artificial Intelligence (AI)? It's Already in Your Pocket!",
    "analogy_hi": "एक सामान्य **कैलकुलेटर** केवल बंधे-बंधाए नियम जानता है (`2 + 2 = 4`) — वह खुद से नहीं सीखता। लेकिन **AI (Artificial Intelligence)** एक ऐसे **बुद्धिमान प्रशिक्षु (Apprentice)** जैसा है जो लाखों उदाहरण देखकर पैटर्न पहचानना सीख लेता है — बिल्कुल वैसे ही जैसे आपने बचपन में कई आम और अमरूद देखकर दोनों में फर्क करना सीख लिया था! आप आज भी रोज़ AI का उपयोग करते हैं: हिंदी में बोलकर टाइप करना (**Voice Typing**), **Google Lens** से अंग्रेज़ी किताब का हिंदी अनुवाद करना, और **Google Maps** पर ट्रैफिक देखना!",
    "analogy_en": "A normal **calculator** only obeys fixed rules (`2 + 2 = 4`) — it never learns. **AI (Artificial Intelligence)** works like a **clever apprentice** that learns patterns from millions of examples — just as you learned to tell a mango from a guava after seeing many of them! You already use AI daily: **Hindi Voice Typing**, **Google Lens** translating English pages, and **Google Maps** predicting traffic!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "AI कैसे सीखता और काम करता है? (सरल 4-चरण दृश्य मॉडल)",
      "title_en": "How AI Learns & Works (Simple 4-Step Visual Pipeline)",
      "caption_hi": "AI कोई जादू नहीं है — यह बड़े डेटा से पैटर्न सीखता है (Machine Learning) और नए सवाल आने पर सबसे संभावित उत्तर तैयार करता है।",
      "caption_en": "AI is not magic — it studies patterns in large datasets (Machine Learning) to make helpful predictions when you ask a new question.",
      "viewBox": "0 0 660 250",
      "elements": [
        {
          "kind": "rect",
          "x": 18,
          "y": 56,
          "width": 140,
          "height": 130,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 88,
          "y": 92,
          "text_hi": "1. लाखों उदाहरण",
          "text_en": "1. Training Examples",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 88,
          "y": 138,
          "text_hi": "किताबें, भाषा, चित्र",
          "text_en": "Books, speech, photos",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 158,
          "y1": 121,
          "x2": 186,
          "y2": 121,
          "stroke": "#1E3A8A",
          "strokeWidth": 2.4
        },
        {
          "kind": "rect",
          "x": 190,
          "y": 56,
          "width": 140,
          "height": 130,
          "rx": 10,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 260,
          "y": 92,
          "text_hi": "2. पैटर्न सीखना",
          "text_en": "2. Pattern Learning",
          "fill": "#92400E",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 260,
          "y": 138,
          "text_hi": "मशीन लर्निंग (ML)",
          "text_en": "Machine Learning",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 330,
          "y1": 121,
          "x2": 358,
          "y2": 121,
          "stroke": "#D97706",
          "strokeWidth": 2.4
        },
        {
          "kind": "rect",
          "x": 362,
          "y": 56,
          "width": 132,
          "height": 130,
          "rx": 10,
          "fill": "#F5F3FF",
          "stroke": "#7C3AED",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 428,
          "y": 92,
          "text_hi": "3. आपका सवाल",
          "text_en": "3. Your Prompt",
          "fill": "#5B21B6",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 428,
          "y": 138,
          "text_hi": "स्पष्ट R-C-F निर्देश",
          "text_en": "Clear R-C-F request",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 494,
          "y1": 121,
          "x2": 522,
          "y2": 121,
          "stroke": "#059669",
          "strokeWidth": 2.4
        },
        {
          "kind": "rect",
          "x": 526,
          "y": 56,
          "width": 118,
          "height": 130,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 585,
          "y": 92,
          "text_hi": "4. स्मार्ट उत्तर",
          "text_en": "4. Helpful Output",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 585,
          "y": 138,
          "text_hi": "अनुवाद, व्याख्या, क्विज़",
          "text_en": "Summary, tutor, quiz",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        }
      ]
    },
    "concept_md_hi": "### AI के 3 रोज़मर्रा के रूप जो छात्र पहले से देखते हैं\n1. **वॉइस और भाषा AI (Speech & Translation AI):** हिंदी में बोलकर टाइप करना, कठिन अंग्रेज़ी पाठ का हिंदी अर्थ समझना।\n2. **विज़न AI (Vision AI):** कैमरा दिखाकर पौधे की पहचान करना या किताब के पन्ने का टेक्स्ट पढ़ना (**Google Lens**)।\n3. **जेनरेटिव AI (Generative AI):** नए उत्तर, आसान उदाहरण, अभ्यास प्रश्न और सारांश बनाने वाले आधुनिक AI चैटबॉट (जिन्हें आप **प्रॉम्प्ट** देकर चलाते हैं)।\n\n**याद रखें:** AI इंसान का **सहायक (Assistant)** है, इंसान के दिमाग का विकल्प नहीं! इसमें भावनाएँ या असली समझ नहीं होती — यह केवल गणित और पैटर्न पर चलता है।",
    "concept_md_en": "### 3 Everyday Forms of AI Students Already See\n1. **Speech & Language AI:** Hindi Voice Typing and instant Hindi–English translation.\n2. **Vision AI:** Using your phone camera to scan textbook text or identify plants (**Google Lens**).\n3. **Generative AI:** Modern conversational assistants that explain concepts, create practice quizzes, and summarize topics when given a clear **Prompt**.\n\n**Remember:** AI is a **helper**, not a human brain! It has no real feelings or consciousness — it predicts answers mathematically from patterns.",
    "exam_tip_hi": "मूल तथ्य: **AI** का पूरा नाम **Artificial Intelligence (कृत्रिम बुद्धिमत्ता)** है और डेटा से पैटर्न सीखने की इसकी प्रमुख शाखा को **Machine Learning (ML)** कहते हैं!",
    "exam_tip_en": "Core Exam Fact: **AI** stands for **Artificial Intelligence**, and the core branch where computers learn patterns from data is **Machine Learning (ML)**!",
    "glossary_terms": [
      {
        "term_hi": "कृत्रिम बुद्धिमत्ता (Artificial Intelligence)",
        "term_en": "Artificial Intelligence (AI)",
        "pronunciation_hi": "आर्टिफिशियल इंटेलिजेंस",
        "definition_hi": "कंप्यूटर विज्ञान की वह शाखा जिसमें मशीनें उदाहरणों से पैटर्न सीखकर भाषा, चित्र और निर्णय संबंधी कार्य करती हैं।",
        "definition_en": "Branch of computer science enabling machines to learn from patterns and perform intelligent tasks like translation and analysis."
      },
      {
        "term_hi": "प्रॉम्प्ट (Prompt)",
        "term_en": "AI Prompt",
        "pronunciation_hi": "प्रॉम्प्ट",
        "definition_hi": "आपकी ओर से AI टूल को दिया गया लिखित या बोला गया स्पष्ट प्रश्न अथवा निर्देश।",
        "definition_en": "The written or spoken question or instruction you give an AI tool to get a helpful response."
      }
    ],
    "quick_check": {
      "q_hi": "जब आप किसी AI टूल को कोई प्रश्न या निर्देश लिखकर देते हैं, तो उस निर्देश को क्या कहा जाता है?",
      "q_en": "What is the written question or instruction you type into an AI tool called?",
      "answer_hi": "**प्रॉम्प्ट (Prompt)**!",
      "answer_en": "A **Prompt**!"
    }
  },
  {
    "id": "ict6-sec-2-prompting",
    "order": 2,
    "heading_hi": "2. सही प्रॉम्प्ट (Prompt) लिखने की कला — R-C-F फॉर्मूला!",
    "heading_en": "2. The Art of Writing Smart Prompts — The R-C-F Formula!",
    "analogy_hi": "यदि आप किताब की दुकान पर जाकर कहें — *\"भैया, एक किताब दो!\"* — तो दुकानदार उलझ जाएगा कि किस कक्षा और किस विषय की किताब चाहिए! वैसे ही AI से *\"Science batao\"* पूछने पर बेकार लंबा उत्तर मिलता है। लेकिन **R-C-F फॉर्मूला** (*\"मैं बिहार बोर्ड कक्षा 10 का छात्र हूँ [Role], प्रकाश संश्लेषण को रसोई के उदाहरण से सरल हिंदी में समझाओ [Clear Topic], 5 बुलेट बिंदुओं और 3 अभ्यास प्रश्नों में [Format]\"*) लगाते ही AI आपका **निजी ट्यूटर** बन जाता है!",
    "analogy_en": "Asking an AI *\"Explain Science\"* is like walking into a bookshop and saying *\"Give me one book!\"* — too vague! Using the **R-C-F Formula** (*\"I am a Bihar Board Class 10 student [Role]. Explain Photosynthesis with a kitchen analogy in simple Hindi [Clear Topic], in 5 bullet points + 3 quiz questions [Format]\"*) turns AI into a world-class personal tutor!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "कमज़ोर प्रॉम्प्ट बनाम स्मार्ट R-C-F प्रॉम्प्ट (बिहार छात्रों के लिए असली उदाहरण)",
      "title_en": "Weak Prompt vs Smart R-C-F Prompt (Real Bihar Student Examples)",
      "caption_hi": "R = Role (अपनी कक्षा/बोर्ड बताएँ), C = Clear Topic (सटीक विषय व भाषा), F = Format (बुलेट बिंदु, तालिका या क्विज़)!",
      "caption_en": "R = Role (your class & board), C = Clear Topic (exact concept & language), F = Format (bullets, table, or quiz)!",
      "headers_hi": [
        "अध्ययन लक्ष्य",
        "कमज़ोर प्रॉम्प्ट (खराब परिणाम)",
        "स्मार्ट R-C-F प्रॉम्प्ट (10/10 परिणाम)"
      ],
      "headers_en": [
        "Study Goal",
        "Weak Prompt (Poor Result)",
        "Smart R-C-F Prompt (10/10 Result)"
      ],
      "rows": [
        {
          "cells_hi": [
            "विज्ञान का कठिन नियम समझना",
            "\"ओम का नियम बताओ\"",
            "\"मैं बिहार बोर्ड कक्षा 10 का छात्र हूँ। ओम का नियम (V = IR) सरल हिंदी में पानी के पाइप के उदाहरण से 5 बिंदुओं में समझाओ और 1 आसान न्यूमेरिकल दो।\""
          ],
          "cells_en": [
            "Understand Science Law",
            "\"Tell Ohm law\"",
            "\"I am a BSEB Class 10 student. Explain Ohm's Law (V=IR) in simple Hindi using a water-pipe analogy in 5 bullets plus 1 easy numerical.\""
          ]
        },
        {
          "cells_hi": [
            "अंग्रेज़ी व्याकरण सुधारना",
            "\"मेरा निबंध लिख दो\"",
            "\"मैंने पर्यावरण पर 6 वाक्य अंग्रेज़ी में लिखे हैं। कृपया इन्हें दोबारा मत लिखो — बस मेरी व्याकरण गलतियाँ सरल हिंदी में समझाओ ताकि मैं खुद सुधारूँ!\""
          ],
          "cells_en": [
            "Improve English Grammar",
            "\"Write my essay\"",
            "\"Here are 6 English sentences I wrote on Environment. Do not rewrite them — just highlight my grammar errors in simple Hindi so I can fix them myself!\""
          ]
        },
        {
          "cells_hi": [
            "इतिहास का तेज़ रिवीजन",
            "\"चम्पारण आंदोलन\"",
            "\"कक्षा 10 बिहार बोर्ड परीक्षा के लिए चम्पारण सत्याग्रह (1917) के 4 मुख्य बिंदु और 3 MCQ अभ्यास प्रश्न उत्तर सहित बनाओ।\""
          ],
          "cells_en": [
            "Fast History Revision",
            "\"Champaran movement\"",
            "\"Create 4 key exam points and 3 MCQ practice questions with answers on Champaran Satyagraha (1917) for BSEB Class 10.\""
          ]
        }
      ]
    },
    "concept_md_hi": "### R-C-F के 3 सुनहरे अक्षर हमेशा याद रखें\n1. **R — Role (परिचय व स्तर):** अपनी कक्षा और बोर्ड बताएँ (*\"मैं कक्षा 9/10/12 बिहार बोर्ड का छात्र हूँ\"*) ताकि AI कठिन कॉलेज स्तर की भाषा न लिखे!\n2. **C — Clear Topic (सटीक विषय व भाषा):** स्पष्ट बताएँ क्या समझना है और किस भाषा में (*\"सरल हिंदी में, दैनिक उदाहरण के साथ\"*)।\n3. **F — Format (उत्तर का रूप):** बताएँ उत्तर कैसा चाहिए — *5 बुलेट बिंदु, तुलना तालिका, या 5-अंक मॉडल उत्तर संरचना*!\n\n**प्रो टिप:** यदि पहली बार उत्तर समझ न आए, तो शर्माएँ नहीं — लिखें: **\"इसे और भी आसान शब्दों में एक गाँव के उदाहरण से समझाओ!\"**",
    "concept_md_en": "### Remember the 3 Letters of R-C-F Prompting\n1. **R — Role (Your Level):** State your class and board (*\"I am a Class 10 Bihar Board student\"*) so AI avoids complicated university jargon!\n2. **C — Clear Topic (Exact Need & Language):** Name the exact chapter/doubt and language (*\"in simple Hindi + English with an everyday analogy\"*).\n3. **F — Format (Output Shape):** Ask for *5 crisp bullets, a comparison table, or 3 quiz questions*!\n\n**Pro Tip:** If the first explanation still feels dense, reply: **\"Explain this even more simply with a daily-life example!\"**",
    "exam_tip_hi": "याद रखें: **AI जितना अच्छा उत्तर देता है, वह आपके प्रॉम्प्ट की स्पष्टता पर निर्भर करता है!** अस्पष्ट प्रश्न = अस्पष्ट उत्तर; सटीक R-C-F प्रश्न = शानदार समझ!",
    "exam_tip_en": "Core principle: **AI output quality depends directly on prompt clarity!** Vague prompt = vague output; sharp R-C-F prompt = crystal-clear learning!",
    "glossary_terms": [
      {
        "term_hi": "R-C-F प्रॉम्प्ट विधि",
        "term_en": "R-C-F Prompt Method (Role, Clear Topic, Format)",
        "pronunciation_hi": "आर-सी-एफ प्रॉम्प्ट फॉर्मूला",
        "definition_hi": "AI से सबसे सटीक पढ़ाई-सहायता पाने के लिए अपनी कक्षा (Role), स्पष्ट विषय (Clear Topic) और उत्तर का रूप (Format) बताने की विधि।",
        "definition_en": "A structured way to ask AI for help by specifying your Role/level, Clear Topic, and desired output Format."
      },
      {
        "term_hi": "जेनरेटिव AI (Generative AI)",
        "term_en": "Generative AI",
        "pronunciation_hi": "जेनरेटिव ए-आई",
        "definition_hi": "ऐसी AI प्रणाली जो आपके निर्देश (Prompt) के आधार पर नया टेक्स्ट, व्याख्या, सारांश, चित्र या प्रश्न तैयार करती है।",
        "definition_en": "AI systems capable of generating new text explanations, summaries, quizzes, or images from your prompt."
      }
    ],
    "quick_check": {
      "q_hi": "R-C-F प्रॉम्प्ट फॉर्मूले में `R`, `C` और `F` के पूरे नाम क्या हैं?",
      "q_en": "In the R-C-F prompt formula, what do `R`, `C`, and `F` stand for?",
      "answer_hi": "**R = Role (कक्षा/स्तर), C = Clear Topic (सटीक विषय), F = Format (उत्तर का रूप)**।",
      "answer_en": "**R = Role (level/context), C = Clear Topic, F = Format (bullets/table/quiz)**."
    }
  },
  {
    "id": "ict6-sec-3-smart-studying",
    "order": 3,
    "heading_hi": "3. स्मार्ट पढ़ाई बनाम आलसी नकल — बोर्ड परीक्षा में असली ताकत कैसे बढ़ाएँ?",
    "heading_en": "3. Smart Studying vs Lazy Cheating — Building Real Board Exam Strength",
    "analogy_hi": "सोचिए आप जिम (Gym) जाते हैं और अपने दोस्त से कहते हैं — *\"तुम मेरी जगह डम्बल उठा लो!\"* बताइए, किसकी मांसपेशियाँ मज़बूत होंगी — आपकी या दोस्त की? बिल्कुल वैसे ही, यदि आप AI से पूरा होमवर्क **कॉपी-पेस्ट** करके बिना समझे लिख देते हैं, तो आपका दिमाग कमज़ोर रह जाता है — और **बिहार बोर्ड परीक्षा हॉल में कोई मोबाइल या AI नहीं होता!** लेकिन AI से **कठिन प्रश्न समझना, अपने उत्तर की गलतियाँ जाँचना और मॉक क्विज़ हल करना** आपके दिमाग को चैंपियन बना देता है!",
    "analogy_en": "If you ask a friend to lift dumbbells for you at the gym, whose muscles grow? Not yours! Blindly **copy-pasting** AI homework leaves your brain weak — and there is **NO phone inside the BSEB exam hall!** Using AI as a **coach** (to clarify concepts, critique your draft, and quiz you) builds genuine exam mastery!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "स्मार्ट छात्र का 4-चरणीय AI अध्ययन चक्र (नकल नहीं, सच्ची समझ!)",
      "title_en": "The Smart Student's 4-Step AI Study Loop (Mastery, Not Copying!)",
      "caption_hi": "सफल छात्र हमेशा पहले अपनी पाठ्यपुस्तक पढ़ते हैं, फिर AI से शंका दूर करते हैं, किताब से तथ्य मिलाते हैं और अंत में उत्तर खुद अपने शब्दों में लिखते हैं!",
      "caption_en": "Top students read their textbook first, use AI to clarify tough doubts, fact-check with the book, and ALWAYS write final answers in their own words!",
      "direction": "LR",
      "steps": [
        {
          "id": "a1",
          "label_hi": "1. पहले किताब पढ़ें",
          "label_en": "1. Read Textbook First",
          "detail_hi": "NCERT / BSEB अध्याय पढ़कर कठिन बिंदु नोट करें।",
          "detail_en": "Read your BSEB chapter and underline tough doubts.",
          "accent": "indigo"
        },
        {
          "id": "a2",
          "label_hi": "2. R-C-F से समझें",
          "label_en": "2. Ask Smart Prompt",
          "detail_hi": "आसान उदाहरण, चरण-दर-चरण हल या अभ्यास क्विज़ माँगें।",
          "detail_en": "Ask for simple analogies, step hints, or practice quizzes.",
          "accent": "amber"
        },
        {
          "id": "a3",
          "label_hi": "3. किताब से सत्यापित करें",
          "label_en": "3. Verify with Textbook",
          "detail_hi": "तिथि, सूत्र और परिभाषा को अपनी किताब/शिक्षक से जाँचें।",
          "detail_en": "Cross-check dates, formulas & definitions against your book.",
          "accent": "emerald"
        },
        {
          "id": "a4",
          "label_hi": "4. अपने शब्दों में लिखें!",
          "label_en": "4. Write in Own Words!",
          "detail_hi": "बिना देखे कॉपी में उत्तर लिखकर बोर्ड परीक्षा के लिए पक्का करें।",
          "detail_en": "Close screen and write the answer yourself to lock memory!",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "a1",
          "to": "a2"
        },
        {
          "from": "a2",
          "to": "a3"
        },
        {
          "from": "a3",
          "to": "a4"
        }
      ]
    },
    "concept_md_hi": "### AI का स्मार्ट उपयोग (करें) बनाम गलत उपयोग (न करें)\n- **स्मार्ट उपयोग (DOs):**\n  - कठिन विज्ञान/गणित विषय को आसान हिंदी उदाहरण से समझना।\n  - अपने खुद लिखे अंग्रेज़ी पैराग्राफ की **व्याकरण (Grammar)** गलतियाँ पहचानना।\n  - परीक्षा से पहले अपने लिए **10 MCQ प्रैक्टिस क्विज़** बनवाना।\n- **नुकसानदेह उपयोग (DON'Ts):**\n  - बिना पढ़े और बिना समझे होमवर्क या निबंध ज्यों का त्यों नकल करना (**Plagiarism / शैक्षणिक बेईमानी**)।\n  - अपना पूरा नाम, मोबाइल नंबर, आधार, रोल कोड या निजी फोटो किसी अनजान AI ऐप पर अपलोड करना!",
    "concept_md_en": "### Smart AI Study Habits (DOs) vs Harmful Shortcuts (DON'Ts)\n- **Smart Coach Uses (DOs):**\n  - Breaking tough Science/Math steps into simple analogies.\n  - Checking your own English draft for **grammar and spelling feedback**.\n  - Generating **practice MCQs** to self-test before exams.\n- **Harmful Uses (DON'Ts):**\n  - Copy-pasting entire assignments without understanding (**Plagiarism** — leaves you helpless in exam halls!).\n  - Uploading personal Aadhaar, phone numbers, roll codes, or family photos onto random AI sites!",
    "exam_tip_hi": "याद रखें: किसी दूसरे या AI के लिखे काम को बिना समझे अपना बताकर जमा करना **साहित्यिक चोरी (Plagiarism)** कहलाता है — असली सफलता खुद समझकर लिखने में है!",
    "exam_tip_en": "Exam Term: Submitting someone else's or AI-generated writing as your own without understanding is called **Plagiarism** — true mastery comes from writing in your own words!",
    "glossary_terms": [
      {
        "term_hi": "प्लेज़रिज़्म / नकल (Plagiarism)",
        "term_en": "Plagiarism",
        "pronunciation_hi": "प्लेज़रिज़्म",
        "definition_hi": "किसी अन्य लेखक या AI के लिखे उत्तर को ज्यों का त्यों कॉपी करके अपने नाम से प्रस्तुत करना।",
        "definition_en": "Copying someone else's or an AI's work word-for-word and claiming it as your own original writing."
      },
      {
        "term_hi": "निजता सुरक्षा (Data Privacy)",
        "term_en": "Data Privacy in AI",
        "pronunciation_hi": "डेटा प्राइवेसी",
        "definition_hi": "अपना आधार, फोन नंबर, पता, पासवर्ड और निजी फोटो किसी भी सार्वजनिक AI चैट में न डालने की सावधानी।",
        "definition_en": "Protecting personal details (Aadhaar, phone, passwords, photos) by never sharing them in public AI chats."
      }
    ],
    "quick_check": {
      "q_hi": "क्या AI चैट में अपना आधार नंबर या बैंक खाता विवरण डालकर कोई फॉर्म भरवाना सुरक्षित है?",
      "q_en": "Is it safe to paste your Aadhaar number or bank account details into a public AI chat?",
      "answer_hi": "**बिल्कुल नहीं!** निजी और संवेदनशील जानकारी कभी किसी AI चैट या अनजान ऐप में साझा न करें।",
      "answer_en": "**Never!** Keep private personal and banking information strictly out of AI chats."
    }
  },
  {
    "id": "ict6-sec-4-hallucination-deepfake",
    "order": 4,
    "heading_hi": "4. AI के खतरे पहचानें — AI भ्रम (Hallucination), डीपफेक (Deepfake) और AI का इतिहास",
    "heading_en": "4. Staying Safe in the AI Era — Hallucinations, Deepfakes & AI Timeline",
    "analogy_hi": "कभी-कभी AI पूरे आत्मविश्वास के साथ **बिल्कुल गलत तारीख, नकली किताब का नाम या गलत सूत्र** गढ़ देता है — इसे **AI भ्रम (AI Hallucination)** कहते हैं! इसी तरह आजकल ठग **डीपफेक (Deepfake)** तकनीक से आपके किसी रिश्तेदार की हूबहू **नकली आवाज़ या वीडियो** बनाकर इमरजेंसी में ₹5,000 UPI माँग सकते हैं! बचाव का एकमात्र नियम: **तथ्य को अपनी BSEB किताब से जाँचें, और पैसे माँगने वाले कॉल पर हमेशा रिश्तेदार के पुराने असली नंबर पर खुद वापस फोन करके पक्का करें!**",
    "analogy_en": "Sometimes AI invents a **wrong historical date, fake book author, or wrong formula** with 100% confidence — this is called **AI Hallucination**! Similarly, scammers now use **Deepfake** tools to clone a relative's **voice or video** asking for urgent UPI money! Golden defense: **verify facts in your BSEB textbook, and ALWAYS hang up and call your relative back on their saved real number before sending any money!**",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "कंप्यूटर से आधुनिक AI तक की प्रेरक यात्रा (1956 से आज तक)",
      "title_en": "Inspiring Journey of Artificial Intelligence (1956 to Today)",
      "caption_hi": "AI कोई रातों-रात आया चमत्कार नहीं है — यह 70 वर्षों के गणित, कंप्यूटर विज्ञान और मानव परिश्रम का परिणाम है!",
      "caption_en": "AI did not appear overnight — it is the result of 70 years of mathematics, computer science, and human innovation!",
      "events": [
        {
          "year": "1956",
          "title_hi": "\"Artificial Intelligence\" नामकरण (जॉन मैकार्थी)",
          "title_en": "Term \"Artificial Intelligence\" Coined (John McCarthy)",
          "detail_hi": "डार्टमाउथ सम्मेलन में जॉन मैकार्थी ने पहली बार AI शब्द दिया — इन्हें AI का जनक कहा जाता है।",
          "detail_en": "John McCarthy coined the term Artificial Intelligence at the Dartmouth workshop — known as the Father of AI.",
          "highlight": true
        },
        {
          "year": "1997",
          "title_hi": "Deep Blue ने शतरंज विश्व चैंपियन को हराया",
          "title_en": "Deep Blue Defeats World Chess Champion",
          "detail_hi": "कंप्यूटर ने साबित किया कि मशीनें जटिल रणनीति और लाखों चालों की गणना कर सकती हैं।",
          "detail_en": "Showed computers can evaluate millions of strategic moves in seconds."
        },
        {
          "year": "2011–2016",
          "title_hi": "वॉइस असिस्टेंट और भारतीय भाषा अनुवाद",
          "title_en": "Voice Assistants & Indian Language Translation",
          "detail_hi": "मोबाइल में बोलकर खोजने, हिंदी वॉइस टाइपिंग और मैप्स नेविगेशन का विस्तार हुआ।",
          "detail_en": "Voice search, Hindi voice typing, and smart navigation reached everyday smartphones."
        },
        {
          "year": "2022–2026",
          "title_hi": "द्विभाषी जेनरेटिव AI व स्मार्ट शिक्षा का युग",
          "title_en": "Era of Bilingual Generative AI & Smart Learning",
          "detail_hi": "अब छात्र हिंदी व अंग्रेज़ी दोनों में स्मार्ट प्रॉम्प्ट पूछकर पढ़ाई कर सकते हैं — पर सत्यता जाँच व डीपफेक सावधानी अनिवार्य है!",
          "detail_en": "Students can now study in Hindi and English with smart prompts — while staying alert to hallucinations and deepfakes!",
          "highlight": true
        }
      ]
    },
    "concept_md_hi": "### AI युग के 3 सबसे ज़रूरी सुरक्षा नियम\n1. **AI भ्रम (Hallucination) जाँचें:** AI कभी-कभी गलत साल, गलत लेखक या गलत उत्तर बड़े विश्वास से लिख देता है। बोर्ड परीक्षा में लिखने से पहले हर तथ्य को अपनी **BSEB पाठ्यपुस्तक या शिक्षक** से ज़रूर मिलाएँ!\n2. **डीपफेक (Deepfake) पहचानें:** यदि किसी अनजान नंबर से वीडियो या वॉइस कॉल पर कोई परिचित घबराई आवाज़ में तुरंत UPI पैसे माँगे, तो **कॉल काटें और उनके पुराने असली नंबर पर खुद फोन करके पुष्टि करें**!\n3. **डिजिटल फ़ुटप्रिंट और निजता:** किसी भी संदिग्ध AI ऐप पर अपनी या परिवार की फोटो अपलोड न करें — उसका दुरुपयोग डीपफेक बनाने में हो सकता है।",
    "concept_md_en": "### 3 Essential Safety Rules for the AI Era\n1. **Fact-Check AI Hallucinations:** AI can confidently produce wrong dates, misquoted authors, or math errors. Always cross-check exam facts with your **BSEB textbook or teacher**!\n2. **Beat Deepfake Scams:** If an unknown number calls with a relative's voice or face urgently begging for UPI money, **hang up immediately and call your relative back on their saved real number**!\n3. **Guard Personal Photos & Data:** Never upload personal or family photos onto untrusted AI apps where they could be misused.",
    "exam_tip_hi": "याद रखें: **\"Artificial Intelligence (AI) का जनक\"** किसे कहा जाता है? उत्तर: **जॉन मैकार्थी (John McCarthy, 1956)**! और AI द्वारा आत्मविश्वास से गलत तथ्य गढ़ने को **Hallucination** कहते हैं!",
    "exam_tip_en": "High-yield facts: Who is the **\"Father of Artificial Intelligence\"**? **John McCarthy (1956)**! And when AI confidently invents a wrong fact, it is called **AI Hallucination**!",
    "glossary_terms": [
      {
        "term_hi": "AI भ्रम (AI Hallucination)",
        "term_en": "AI Hallucination",
        "pronunciation_hi": "ए-आई हैलुसिनेशन",
        "definition_hi": "जब कोई AI मॉडल पूरे आत्मविश्वास के साथ गलत, काल्पनिक या असत्य तथ्य/उत्तर बना दे।",
        "definition_en": "When an AI confidently generates false, fabricated, or inaccurate facts as if they were true."
      },
      {
        "term_hi": "डीपफेक (Deepfake)",
        "term_en": "Deepfake",
        "pronunciation_hi": "डीपफेक",
        "definition_hi": "AI की मदद से किसी असली व्यक्ति के चेहरे या आवाज़ की नकल करके बनाया गया नकली वीडियो या ऑडियो।",
        "definition_en": "A fake audio clip or video created using AI to mimic a real person's voice or face."
      }
    ],
    "quick_check": {
      "q_hi": "यदि AI चैटबॉट बताए कि \"बिहार का चम्पारण सत्याग्रह 1930 में हुआ था\" (जो गलत है — सही वर्ष 1917 है!), तो AI की इस गलती को क्या कहते हैं?",
      "q_en": "If an AI confidently claims \"Champaran Satyagraha happened in 1930\" (wrong — it was 1917!), what is this AI error called?",
      "answer_hi": "**AI भ्रम (AI Hallucination)** — इसलिए हर तथ्य को अपनी BSEB किताब से मिलाना ज़रूरी है!",
      "answer_en": "**AI Hallucination** — which proves why textbook verification is essential!"
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [
    {
      "latex": "\\text{Smart Prompt} = \\mathbf{R}\\text{(Role)} + \\mathbf{C}\\text{(Clear Topic)} + \\mathbf{F}\\text{(Format)}",
      "label_hi": "स्मार्ट पढ़ाई का R-C-F प्रॉम्प्ट सूत्र",
      "label_en": "The R-C-F Smart Prompt Formula"
    },
    {
      "latex": "\\text{AI Output} \\xrightarrow{\\text{Verify}} \\text{BSEB Textbook / Teacher}",
      "label_hi": "Hallucination से बचने का सत्यापन नियम",
      "label_en": "Verification Rule Against AI Hallucinations"
    }
  ],
  "key_dates_or_facts": [
    {
      "tag": "1956",
      "fact_hi": "जॉन मैकार्थी (John McCarthy) ने 1956 में \"Artificial Intelligence\" शब्द दिया।",
      "fact_en": "John McCarthy coined \"Artificial Intelligence\" in 1956 (Father of AI)."
    },
    {
      "tag": "Prompt",
      "fact_hi": "AI को दिया गया स्पष्ट निर्देश या प्रश्न \"Prompt\" कहलाता है।",
      "fact_en": "An instruction or question given to AI is called a \"Prompt\"."
    },
    {
      "tag": "Hallucination",
      "fact_hi": "AI द्वारा आत्मविश्वास से गलत तथ्य गढ़ना \"AI Hallucination\" कहलाता है।",
      "fact_en": "When AI confidently invents wrong facts, it is called \"AI Hallucination\"."
    },
    {
      "tag": "Deepfake",
      "fact_hi": "नकली आवाज़/वीडियो कॉल पर कभी तुरंत पैसे न भेजें — असली नंबर पर कॉल कर पुष्टि करें!",
      "fact_en": "On urgent voice/video money calls, hang up and call back the real saved number!"
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "यह मान लेना कि AI जो भी लिखता है वह 100% सही होता है।",
      "mistake_en": "Assuming everything an AI outputs is 100% factually correct.",
      "fix_hi": "AI में Hallucination हो सकता है — तारीखें, लेखक नाम और सूत्र हमेशा अपनी पाठ्यपुस्तक से मिलाएँ।",
      "fix_en": "AI can hallucinate — always verify dates, author names, and formulas with your textbook."
    },
    {
      "mistake_hi": "AI से पूरा निबंध या होमवर्क कॉपी करके बिना समझे जमा कर देना।",
      "mistake_en": "Copy-pasting AI-written essays directly as homework.",
      "fix_hi": "AI का उपयोग केवल समझने, रूपरेखा बनाने और अपनी गलतियाँ सुधारने के लिए करें — अंतिम उत्तर खुद लिखें!",
      "fix_en": "Use AI only to understand concepts and check your own draft — always write your own final answer!"
    },
    {
      "mistake_hi": "किसी अनजान फ्री AI ऐप पर अपने परिवार की फोटो या आधार अपलोड कर देना।",
      "mistake_en": "Uploading personal photos or Aadhaar details to random free AI apps.",
      "fix_hi": "निजी दस्तावेज़ और फोटो कभी असुरक्षित AI ऐप्स पर अपलोड न करें।",
      "fix_en": "Never upload sensitive IDs or personal photos to untrusted AI tools."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "AI क्या है, दैनिक जीवन में उपयोग और जॉन मैकार्थी (1956)",
      "topic_en": "What is AI, Everyday Uses & John McCarthy (1956)",
      "years": [
        "BSEB ICT Lab",
        "Objective"
      ],
      "expected_marks": 4
    },
    {
      "topic_hi": "R-C-F प्रॉम्प्ट लेखन और स्मार्ट अध्ययन बनाम प्लेज़रिज़्म",
      "topic_en": "R-C-F Prompt Writing & Smart Studying vs Plagiarism",
      "years": [
        "BSEB ICT Practical"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "AI Hallucination, Deepfake बचाव और डेटा निजता (Privacy)",
      "topic_en": "AI Hallucinations, Deepfake Safety & Data Privacy",
      "years": [
        "BSEB ICT Viva"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${
  "hindi_reviewed": true,
  "english_reviewed": true,
  "visuals_count": 4,
  "analogy_count": 4,
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
  'skill-ict-ch6',
  2,
  'छात्र सरल भाषा में Artificial Intelligence (AI) और Machine Learning की अवधारणा समझ सकेंगे, R-C-F विधि से प्रभावी अध्ययन प्रॉम्प्ट लिख सकेंगे, स्मार्ट अध्ययन व कॉपी-पेस्ट नकल का अंतर जान सकेंगे, AI Hallucination की पहचान किताब से कर सकेंगे तथा Deepfake वॉइस/वीडियो ठगी से सुरक्षित रहने के उपाय सीख सकेंगे।',
  'Students will explain Artificial Intelligence and pattern learning in simple words, craft strong R-C-F study prompts, distinguish ethical AI tutoring from lazy copying, catch AI Hallucinations using textbooks, and defend against Deepfake voice/video scams.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "दैनिक जीवन में AI की खोज व R-C-F प्रॉम्प्ट मेकओवर कार्यशाला",
    "phase_en": "Spot Everyday AI & Live R-C-F Prompt Makeover Workshop",
    "teacher_action_hi": "कक्षा से पूछें कि किन छात्रों ने फोन पर हिंदी बोलकर टाइप किया या YouTube सुझाव देखा है — बताएँ कि यही AI है! फिर ब्लैकबोर्ड पर 3 कमज़ोर प्रॉम्प्ट लिखें (\"विज्ञान बताओ\", \"अंग्रेज़ी निबंध\", \"गणित सवाल\") और पूरी कक्षा के साथ मिलकर उन्हें शानदार R-C-F प्रॉम्प्ट में बदलवाएँ। कमजोर छात्रों से केवल `R` (अपनी कक्षा) या `F` (5 बिंदु) जोड़ने को कहें ताकि हर कोई भाग ले!",
    "teacher_action_en": "Ask who has used Hindi Voice Typing, Google Maps, or YouTube suggestions — reveal they already use AI! Write 3 weak prompts on the board and let the class transform them using R-C-F. Invite shy students to contribute just `R` (class) or `F` (format) so everyone succeeds!",
    "student_check_hi": "पूछें: \"क्या केवल `Photosynthesis` लिखना अच्छा प्रॉम्प्ट है, या अपनी कक्षा, भाषा और 5 बिंदुओं का फॉर्मेट जोड़ना?\"",
    "student_check_en": "Ask: \"Which gives a better learning answer: typing just `Photosynthesis`, or adding your class, Hindi analogy, and 5 bullet points?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "\"AI झूठ पकड़ो\" (Hallucination Detective) और Deepfake सुरक्षा चर्चा",
    "phase_en": "\"Catch the AI Lie\" (Hallucination Detective) & Deepfake Defense",
    "teacher_action_hi": "ब्लैकबोर्ड पर 3 \"AI-शैली\" वाक्य लिखें जिनमें 1 छिपी गलत बात हो (जैसे: \"चम्पारण सत्याग्रह 1930 में हुआ\", \"लेंस की क्षमता का मात्रक वाट है\")। छात्र अपनी BSEB किताब खोलकर 2 मिनट में झूठ पकड़ें — इससे **Hallucination** हमेशा के लिए याद होगा! अंत में एक Deepfake वॉइस कॉल स्कैम का उदाहरण देकर \"कॉल काटें और असली नंबर पर वापस फोन करें\" नियम अभ्यास कराएँ।",
    "teacher_action_en": "Write 3 confident \"AI-style\" statements on the board where 1 has a hidden error (e.g., \"Champaran Satyagraha was in 1930\" or \"Unit of Lens Power is Watt\"). Students race with textbooks to catch the **Hallucination**! Close with a Deepfake relative-call scam drill practicing the callback rule.",
    "student_check_hi": "पूछें: \"यदि कोई अनजान नंबर आपके चाचा की आवाज़ में तुरंत ₹5,000 माँगे, तो पहला कदम क्या होगा?\"",
    "student_check_en": "Ask: \"If an unknown number mimics your uncle's voice asking urgently for ₹5,000 UPI, what is your very first step?\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड स्मार्ट AI व सुरक्षा बॉक्स",
    "heading_en": "Blackboard Smart AI & Safety Box",
    "points_hi": [
      "AI (Artificial Intelligence) के जनक: जॉन मैकार्थी (1956) · सीखने की विधि: Machine Learning (पैटर्न)",
      "R-C-F प्रॉम्प्ट सूत्र: R = Role (मेरी कक्षा) + C = Clear Topic (सटीक विषय) + F = Format (5 बिंदु / क्विज़)",
      "AI = आपका ट्यूटर (समझने व क्विज़ के लिए) — कभी बिना समझे कॉपी-पेस्ट न करें!",
      "दो बड़े खतरे: Hallucination (किताब से जाँचें!) · Deepfake (असली नंबर पर वापस कॉल कर पक्का करें!)"
    ],
    "points_en": [
      "Father of AI: John McCarthy (1956) · Learns via Machine Learning (patterns from examples)",
      "R-C-F Prompt Formula: R = Role (Class) + C = Clear Topic + F = Format (Bullets / Quiz)",
      "AI = Personal Coach (learn & quiz) — NEVER blind copy-paste!",
      "Two Real Risks: Hallucination (verify in textbook!) · Deepfake (hang up & call real number!)"
    ]
  },
  {
    "heading_hi": "बिजली कटने पर ऑफलाइन बैकअप (Power-Cut Blackboard Backup)",
    "heading_en": "Offline / Power-Cut Blackboard Backup Activity",
    "points_hi": [
      "पूरा अध्याय बिना बिजली व बिना इंटरनेट के 100% प्रभावी ढंग से पढ़ाया जा सकता है!",
      "कॉपी में \"प्रॉम्प्ट सुधार प्रतियोगिता\" कराएँ: हर छात्र अपने सबसे कठिन विषय (गणित/अंग्रेज़ी/विज्ञान) के लिए 2 R-C-F प्रॉम्प्ट लिखे और बगल के मित्र से जाँच करवाए कि क्या R, C और F तीनों मौजूद हैं।",
      "\"AI कॉपी-पेस्ट बनाम स्मार्ट अध्ययन\" पर 5 मिनट का सकारात्मक कक्षा संवाद (2 छात्र पक्ष में, 2 विपक्ष में) कराएँ!"
    ],
    "points_en": [
      "This entire chapter runs 100% effectively with zero electricity or internet!",
      "Run a notebook \"Prompt Makeover Contest\": each student writes 2 R-C-F prompts for their hardest subject (Math/English/Science), and their bench partner checks off R, C, and F!",
      "Hold a lively 5-minute class reflection on why gym muscles (and exam brains!) only grow when YOU do the thinking."
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "लैब / कक्षा जोड़ी गतिविधि: \"AI झूठ पकड़ो (Fact-Check Detective)\"",
    "title_en": "Pair Activity: \"Catch the AI Hallucination (Fact-Check Detective)\"",
    "materials_hi": "छात्रों की कक्षा 9–12 विज्ञान/सामाजिक विज्ञान पाठ्यपुस्तक और ब्लैकबोर्ड",
    "materials_en": "Students' BSEB Science/SST textbooks and blackboard",
    "steps_hi": "शिक्षक बोर्ड पर 4 आत्मविश्वास भरे तथ्य लिखें जिनमें 2 सही और 2 गलत (AI Hallucination जैसे) हों। जोड़ियाँ 5 मिनट में किताब से जाँचकर गलत तथ्यों को सुधारें और समझाएँ कि बिना जाँचे AI उत्तर लिखने पर बोर्ड में अंक क्यों कट सकते हैं!",
    "steps_en": "Teacher writes 4 confident statements (2 true, 2 realistic AI Hallucinations). Pairs verify each against their textbooks in 5 minutes and correct the false ones, proving why textbook fact-checking saves board marks!"
  },
  {
    "title_hi": "ऑफलाइन गतिविधि (बिना बिजली): \"मेरा सर्वश्रेष्ठ R-C-F प्रॉम्प्ट कार्ड\"",
    "title_en": "No-Power Activity: \"My Best R-C-F Study Prompt Card\"",
    "materials_hi": "कॉपी और पेन",
    "materials_en": "Notebook and pen",
    "steps_hi": "प्रत्येक छात्र अपने सबसे कठिन अध्याय का नाम चुने और 3 बॉक्स (`[R]`, `[C]`, `[F]`) भरकर एक पूरा स्मार्ट प्रॉम्प्ट लिखे। 3 छात्रों से कक्षा के सामने अपना प्रॉम्प्ट पढ़वाकर तालियाँ बजवाएँ!",
    "steps_en": "Each student picks their toughest chapter and fills 3 boxes (`[R]`, `[C]`, `[F]`) to assemble one smart study prompt. Invite 3 students (including a shy learner) to read theirs aloud for applause!"
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "(बिना कंप्यूटर गृहकार्य) अपनी कॉपी में अपने 3 विषयों (विज्ञान, गणित, अंग्रेज़ी) के लिए एक-एक स्मार्ट R-C-F प्रॉम्प्ट लिखें जिसमें `[R]`, `[C]` और `[F]` स्पष्ट रेखांकित हों।",
    "task_en": "(Zero-Computer Homework) Write 3 smart R-C-F study prompts in your notebook (one each for Science, Math, and English) with `[R]`, `[C]`, and `[F]` clearly underlined."
  },
  {
    "level": "BOARD",
    "task_hi": "AI Hallucination और Deepfake क्या हैं? दोनों से बचने के 2-2 व्यावहारिक उपाय लिखें।",
    "task_en": "Define AI Hallucination and Deepfake, and write 2 practical defenses against each."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "अपने परिवार के बड़ों को आज समझाएँ कि \"डीपफेक नकली आवाज़ कॉल\" क्या होती है और यदि कोई अनजान नंबर से रिश्तेदार बनकर पैसे माँगे तो तुरंत पुराने असली नंबर पर वापस फोन क्यों करना चाहिए।",
    "task_en": "Explain \"Deepfake voice clone scams\" to elders in your family tonight and agree on a family rule to always call back on the saved real number before transferring any money."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "AI एक इंसान की तरह सब कुछ जानता और समझता है, इसलिए वह कभी गलती नहीं कर सकता।",
    "misconception_en": "AI thinks like an all-knowing human expert and can never make factual mistakes.",
    "correction_hi": "AI केवल गणितीय पैटर्न से अगले शब्द का अनुमान लगाता है, इसलिए इसमें Hallucination (भ्रम) संभव है — पाठ्यपुस्तक और शिक्षक हमेशा अंतिम प्रामाणिक स्रोत हैं!",
    "correction_en": "AI predicts words mathematically from patterns and can hallucinate — textbooks and teachers remain the authoritative check!"
  },
  {
    "misconception_hi": "AI का इस्तेमाल करने के लिए महंगा लैपटॉप या कोडिंग आना ज़रूरी है।",
    "misconception_en": "You need an expensive laptop or coding skills to benefit from AI.",
    "correction_hi": "साधारण हिंदी या अंग्रेज़ी में स्पष्ट R-C-F प्रश्न पूछना ही आधुनिक AI कौशल है — और हिंदी वॉइस टाइपिंग व अनुवाद सामान्य फोन पर भी चलते हैं!",
    "correction_en": "Asking clear R-C-F questions in plain Hindi or English is a modern AI superpower accessible even on basic phones and school PCs!"
  },
  {
    "misconception_hi": "अगर वीडियो कॉल पर किसी परिचित का चेहरा दिख रहा है, तो वह 100% असली ही होगा।",
    "misconception_en": "If I see a familiar face or hear a familiar voice on a call, it must be 100% real.",
    "correction_hi": "Deepfake तकनीक कुछ सेकंड के ऑडियो/फोटो से नकली आवाज़ व चेहरा बना सकती है — इसलिए पैसों की माँग होने पर हमेशा उनके पुराने असली नंबर पर खुद कॉल करके जाँचें!",
    "correction_en": "Deepfake tools can mimic voices and faces from short clips — whenever money is requested, always hang up and call back their known real number!"
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

-- Questions for skill-ict-ch6 (21 multi-mode items)
INSERT INTO public.questions (
  id, subject_id, chapter_id, topic_tag, bank_pool, question_type, difficulty_tier, exam_year_tag,
  q_hi, q_en, options_json, correct_option, clue_hi, clue_en, explanation_hi, explanation_en,
  model_answer_hi, model_answer_en, memory_cues_json, marking_scheme_json, visual_asset_json, is_published
) VALUES
  -- #1: FLASHCARD (FOUNDATION, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000001', 'skill-ict-lab', 'skill-ict-ch6', 'AI & R-C-F Prompt', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'Modern ICT Core',
    'Artificial Intelligence (AI) क्या है और स्मार्ट प्रॉम्प्ट का R-C-F फॉर्मूला क्या है?',
    'What is Artificial Intelligence (AI) and what is the R-C-F Smart Prompt formula?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "AI का पूरा नाम, जनक (1956), और स्मार्ट प्रॉम्प्ट का R-C-F सूत्र क्या है?",
  "front_en": "State the full form of AI, its Father (1956), and the R-C-F Prompt formula.",
  "back_hi": "AI = Artificial Intelligence (जनक: जॉन मैकार्थी, 1956)। स्मार्ट प्रॉम्प्ट = R (Role / कक्षा) + C (Clear Topic / सटीक विषय व भाषा) + F (Format / बुलेट बिंदु या क्विज़)।",
  "back_en": "AI = Artificial Intelligence (Father: John McCarthy, 1956). Smart Prompt = R (Role / Class level) + C (Clear Topic & Language) + F (Format — bullets, table, or quiz).",
  "pronunciation_hi": "आर्टिफिशियल इंटेलिजेंस और प्रॉम्प्ट",
  "mnemonic_hi": "R-C-F याद रखें: कौन हूँ मैं (Role) + क्या सीखना है (Clear Topic) + किस रूप में (Format)!",
  "mnemonic_en": "R-C-F hook: Who I am (Role) + Exact Doubt (Clear Topic) + How to show it (Format)!"
}$json$::jsonb, true
  ),
  -- #2: FLASHCARD (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000002', 'skill-ict-lab', 'skill-ict-ch6', 'AI Hallucination', 'PRACTICE', 'FLASHCARD', 'BOARD', 'AI Safety Core',
    'AI भ्रम (AI Hallucination) किसे कहते हैं और इससे कैसे बचें?',
    'What is AI Hallucination and how should students guard against it?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "AI Hallucination (AI भ्रम) क्या होता है और छात्र इससे कैसे बचें?",
  "front_en": "What is an AI Hallucination, and how should students prevent mistakes from it?",
  "back_hi": "जब AI पूरे आत्मविश्वास के साथ गलत तारीख, काल्पनिक लेखक या गलत सूत्र लिख दे, तो उसे AI Hallucination कहते हैं। बचाव: हर महत्वपूर्ण तथ्य को अपनी BSEB पाठ्यपुस्तक या शिक्षक से ज़रूर सत्यापित करें!",
  "back_en": "When an AI confidently invents a wrong date, fake citation, or faulty formula, it is called AI Hallucination. Defense: always fact-check important exam facts with your BSEB textbook or teacher!",
  "pronunciation_hi": "ए-आई हैलुसिनेशन (AI भ्रम)",
  "mnemonic_hi": "AI आत्मविश्वास से भी गलत बोल सकता है — किताब से मिलान पक्का करें!",
  "mnemonic_en": "Confident tone ≠ 100% truth — always verify with your textbook!"
}$json$::jsonb, true
  ),
  -- #3: FLASHCARD (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000003', 'skill-ict-lab', 'skill-ict-ch6', 'Deepfake & Privacy Safety', 'PRACTICE', 'FLASHCARD', 'BOARD', 'AI Safety Core',
    'डीपफेक (Deepfake) क्या है और इसके वॉइस/वीडियो स्कैम से कैसे बचें?',
    'What is a Deepfake and how do you defend against Deepfake voice/video scams?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "डीपफेक (Deepfake) क्या है? यदि किसी रिश्तेदार की आवाज़ में अनजान नंबर से पैसे माँगे जाएँ तो क्या करें?",
  "front_en": "What is a Deepfake? What should you do if an unknown caller uses a relative's voice to demand urgent money?",
  "back_hi": "Deepfake AI से बनाया गया नकली ऑडियो या वीडियो है जो किसी असली व्यक्ति की आवाज़/चेहरे की नकल करता है। तुरंत कॉल काटें, पैसे न भेजें और अपने रिश्तेदार के पुराने असली नंबर पर खुद फोन करके पुष्टि करें!",
  "back_en": "A Deepfake is an AI-fabricated voice or video mimicking a real person. Never transfer money immediately — hang up and call your relative directly on their known real number!",
  "pronunciation_hi": "डीपफेक (Deepfake)",
  "mnemonic_hi": "नियम: अनजान नंबर + रिश्तेदार की आवाज़ + तुरंत पैसे = पहले असली नंबर पर कॉल बैक!",
  "mnemonic_en": "Rule: Unknown number + Relative's voice + Urgent money = Hang up & Call back real number!"
}$json$::jsonb, true
  ),
  -- #4: MATCH_PAIRS (FOUNDATION, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000004', 'skill-ict-lab', 'skill-ict-ch6', 'AI Concepts Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'Modern ICT Core',
    'AI से जुड़े शब्दों को उनके सरल अर्थ से मिलाएँ:',
    'Match each Artificial Intelligence term with its simple everyday meaning:',
    NULL, NULL,
    'Prompt निर्देश है, Hallucination गलत तथ्य गढ़ना है, Deepfake नकली आवाज़/वीडियो है और Plagiarism बिना समझे कॉपी करना है!', 'Prompt = instruction, Hallucination = invented wrong fact, Deepfake = cloned audio/video, Plagiarism = copying as your own!',
    'Prompt (निर्देश), Hallucination (गलत तथ्य गढ़ना), Deepfake (नकली चेहरा/आवाज़) और Machine Learning (उदाहरणों से पैटर्न सीखना) — ये 4 आधुनिक AI के आधार स्तंभ हैं।', 'Prompt (instruction), Hallucination (fabricated fact), Deepfake (cloned voice/video), and Machine Learning (learning from data patterns) are core AI literacy terms.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "प्रत्येक AI शब्द को उसके सटीक अर्थ से मिलाएँ",
  "instruction_en": "Pair each AI term with its exact meaning",
  "pairs": [
    {
      "id": "p1",
      "left_hi": "प्रॉम्प्ट (Prompt)",
      "left_en": "Prompt",
      "right_hi": "AI को दिया गया स्पष्ट सवाल या निर्देश",
      "right_en": "Clear question or instruction given to AI"
    },
    {
      "id": "p2",
      "left_hi": "AI भ्रम (Hallucination)",
      "left_en": "AI Hallucination",
      "right_hi": "AI द्वारा आत्मविश्वास से गलत तथ्य गढ़ देना",
      "right_en": "AI confidently inventing a wrong fact"
    },
    {
      "id": "p3",
      "left_hi": "डीपफेक (Deepfake)",
      "left_en": "Deepfake",
      "right_hi": "AI से बनाई गई नकली आवाज़ या नकली वीडियो",
      "right_en": "AI-cloned fake voice or video of someone"
    },
    {
      "id": "p4",
      "left_hi": "मशीन लर्निंग (Machine Learning)",
      "left_en": "Machine Learning",
      "right_hi": "लाखों उदाहरणों से पैटर्न सीखने की प्रक्रिया",
      "right_en": "Learning patterns from millions of examples"
    }
  ]
}$json$::jsonb, true
  ),
  -- #5: SCENARIO_LAB (FOUNDATION, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000005', 'skill-ict-lab', 'skill-ict-ch6', 'Prompt Builder — R-C-F Mastery', 'PRACTICE', 'SCENARIO_LAB', 'FOUNDATION', 'Smart Study Lab',
    'प्रॉम्प्ट प्रयोगशाला: कक्षा 10 के छात्र को विज्ञान में "ओम का नियम (V = IR)" समझ नहीं आ रहा है। इनमें से कौन-सा R-C-F प्रॉम्प्ट सबसे शानदार और समझने योग्य उत्तर देगा?',
    'Prompt Builder Lab: A Class 10 student is struggling with "Ohm''s Law (V = IR)". Which R-C-F prompt will give the clearest, most helpful study answer?',
    NULL, NULL,
    'उस विकल्प को चुनें जिसमें तीनों हिस्से हों: Role (कक्षा 10 बिहार बोर्ड) + Clear Topic (ओम का नियम सरल उदाहरण से) + Format (5 बिंदु व 2 अभ्यास प्रश्न)!', 'Choose the prompt that includes ALL THREE: Role (Class 10 BSEB) + Clear Topic (Ohm''s Law + analogy) + Format (5 bullets + 2 quiz questions)!',
    'बेहतरीन चुनाव! इस स्मार्ट प्रॉम्प्ट में **R (कक्षा 10 बिहार बोर्ड)**, **C (ओम का नियम सरल उदाहरण व हिंदी में)** और **F (5 बिंदु + 2 अभ्यास प्रश्न)** तीनों स्पष्ट हैं!', 'Great pick! It cleanly provides **Role** (Class 10 BSEB), **Clear Topic** (Ohm''s Law with everyday analogy), and **Format** (5 bullets + 2 practice questions)!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PROMPT_BUILDER",
  "scene_title_hi": "स्मार्ट प्रॉम्प्ट बिल्डर — ओम का नियम आसान बनाएँ",
  "scene_title_en": "Smart Prompt Builder — Master Ohm's Law with R-C-F",
  "prompt_hi": "नीचे दिए गए 4 प्रॉम्प्ट में से सबसे प्रभावशाली R-C-F अध्ययन प्रॉम्प्ट चुनें:",
  "prompt_en": "Select the strongest R-C-F study prompt from the 4 options below:",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "MessageSquare",
      "label_hi": "\"ओम का नियम\"",
      "label_en": "\"Ohm law\""
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "\"मुझे विज्ञान का पूरा सिलेबस एक साथ लिखकर दो\"",
      "label_en": "\"Write the whole Science syllabus at once\""
    },
    {
      "id": "c3",
      "icon": "MessageSquare",
      "label_hi": "\"मैं बिहार बोर्ड कक्षा 10 का छात्र हूँ। ओम का नियम (V=IR) सरल हिंदी में पानी के पाइप के उदाहरण से 5 बिंदुओं में समझाओ और 2 अभ्यास प्रश्न दो।\"",
      "label_en": "\"I am a BSEB Class 10 student. Explain Ohm's Law (V=IR) with a water-pipe analogy in 5 simple points plus 2 practice questions.\""
    },
    {
      "id": "c4",
      "icon": "MessageSquare",
      "label_hi": "\"मेरी कॉपी में परीक्षा के उत्तर सीधे कॉपी करने के लिए दे दो\"",
      "label_en": "\"Give me exam answers to copy without understanding\""
    }
  ],
  "correct_choice_id": "c3"
}$json$::jsonb, true
  ),
  -- #6: SCENARIO_LAB (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000006', 'skill-ict-lab', 'skill-ict-ch6', 'Cyber Safety — Deepfake Relative Voice Call', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'AI Safety Lab',
    'डीपफेक सुरक्षा चुनौती: शाम को एक अनजान नंबर से फोन आता है — आवाज़ बिल्कुल आपके मामाजी जैसी है और घबराकर कह रही है: "मेरा एक्सीडेंट हो गया है, फोन टूट गया, तुरंत इस नए UPI नंबर पर ₹5,000 भेजो!" आप क्या करेंगे?',
    'Deepfake Safety Challenge: An unknown number calls with a voice sounding just like your uncle panicking: "I met with an accident, my phone broke, urgently UPI ₹5,000 to this new number!" What is the smartest step?',
    NULL, NULL,
    'क्या AI से किसी की आवाज़ की नकल (Deepfake) बनाई जा सकती है? पैसे भेजने से पहले सच्चाई कैसे जाँचेंगे?', 'Can scammers clone a familiar voice with Deepfake AI? How do you verify BEFORE sending money?',
    'बिल्कुल सही सूझबूझ! यह AI Deepfake वॉइस क्लोन ठगी हो सकती है। बिना घबराए कॉल काटें और अपने मामाजी के **पुराने असली सेव नंबर** या उनके घर पर खुद फोन करके पुष्टि करें!', 'Smart thinking! This matches an AI Deepfake voice-clone scam. Stay calm, hang up, and call your uncle back on his **saved real phone number** or family member to verify first!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "CYBER_SAFETY",
  "scene_title_hi": "डीपफेक वॉइस स्कैम अलर्ट — अनजान नंबर से मामाजी की आवाज़!",
  "scene_title_en": "Deepfake Voice Scam Alert — Uncle's Voice from Unknown Number!",
  "prompt_hi": "अनजान नंबर से बिल्कुल आपके रिश्तेदार जैसी आवाज़ में इमरजेंसी बताकर तुरंत ₹5,000 UPI माँगे जा रहे हैं। सबसे सुरक्षित कदम चुनें:",
  "prompt_en": "An unknown caller using your relative's exact voice begs for ₹5,000 UPI immediately. Choose the safest response:",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "Mail",
      "label_hi": "घबराकर तुरंत अनजान नंबर पर ₹5,000 UPI कर दें",
      "label_en": "Panic and immediately transfer ₹5,000 to the unknown number"
    },
    {
      "id": "c2",
      "icon": "Search",
      "label_hi": "शांत रहें, कॉल काटें और मामाजी के पुराने असली नंबर पर खुद फोन कर पुष्टि करें",
      "label_en": "Stay calm, hang up, and call your uncle directly on his saved real number to verify"
    },
    {
      "id": "c3",
      "icon": "Lock",
      "label_hi": "उन्हें अपना बैंक OTP बता दें ताकि वे खुद पैसे निकाल लें",
      "label_en": "Share your bank OTP so they can withdraw money"
    },
    {
      "id": "c4",
      "icon": "MessageSquare",
      "label_hi": "बिना जाँचे अपने दोस्तों से उधार लेकर पैसे भेज दें",
      "label_en": "Borrow from friends and pay without checking"
    }
  ],
  "correct_choice_id": "c2"
}$json$::jsonb, true
  ),
  -- #7: SCENARIO_LAB (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000007', 'skill-ict-lab', 'skill-ict-ch6', 'Prompt Builder — Ethical Smart Studying', 'PRACTICE', 'SCENARIO_LAB', 'BOARD', 'Smart Study Lab',
    'स्मार्ट पढ़ाई निर्णय: कल स्कूल में "प्रदूषण नियंत्रण (Pollution Control)" पर 10 लाइन का अंग्रेज़ी निबंध जमा करना है। AI का कौन-सा उपयोग आपको बिहार बोर्ड परीक्षा में सचमुच मज़बूत बनाएगा?',
    'Smart Study Choice: You must submit a 10-line English essay on "Pollution Control" tomorrow. Which way of using AI actually makes you stronger for the BSEB board exam?',
    NULL, NULL,
    'जिम के डम्बल वाला उदाहरण याद करें — किस तरीके में आपका अपना दिमाग सोचकर सीखेगा?', 'Remember the gym dumbbell analogy — which method exercises YOUR brain?',
    'वाह! पहले खुद अपने शब्दों में 10 वाक्य लिखना और फिर AI से केवल अपनी **व्याकरण व स्पेलिंग की गलतियाँ हिंदी में समझना** आपको परीक्षा हॉल के लिए सच्चा चैंपियन बनाता है!', 'Spot on! Drafting your own 10 lines first and asking AI only to explain your **grammar & spelling mistakes** builds real writing skill for the exam hall!',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SCENARIO_LAB",
  "variant": "PROMPT_BUILDER",
  "scene_title_hi": "स्मार्ट छात्र बनाम आलसी नकल — सही तरीका चुनें",
  "scene_title_en": "Smart Learner vs Lazy Copy-Paste — Pick the Winning Habit",
  "prompt_hi": "कल के अंग्रेज़ी निबंध होमवर्क में AI की मदद लेने का सबसे समझदार और लाभकारी तरीका चुनें:",
  "prompt_en": "Choose the smartest, most exam-ready way to use AI for tomorrow's English essay homework:",
  "scene_diagram": null,
  "choices": [
    {
      "id": "c1",
      "icon": "FileText",
      "label_hi": "AI से कठिन अंग्रेज़ी निबंध लिखवाकर बिना पढ़े कॉपी में छाप लें",
      "label_en": "Let AI write a hard essay and copy it blindly without reading"
    },
    {
      "id": "c2",
      "icon": "MessageSquare",
      "label_hi": "होमवर्क करना ही छोड़ दें क्योंकि AI सब लिख देता है",
      "label_en": "Skip homework altogether because AI exists"
    },
    {
      "id": "c3",
      "icon": "PenTool",
      "label_hi": "पहले खुद आसान 10 वाक्य लिखें, फिर AI से व्याकरण गलतियाँ समझकर खुद सुधारें",
      "label_en": "Write 10 simple sentences yourself first, then ask AI to point out grammar errors so you fix them"
    },
    {
      "id": "c4",
      "icon": "Lock",
      "label_hi": "निबंध में अपना रोल नंबर, पता और मोबाइल नंबर भी AI चैट में डाल दें",
      "label_en": "Paste your phone number, address, and roll code into the AI chat"
    }
  ],
  "correct_choice_id": "c3"
}$json$::jsonb, true
  ),
  -- #8: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000008', 'skill-ict-lab', 'skill-ict-ch6', 'AI Full Form', 'PRACTICE', 'MCQ', 'FOUNDATION', 'Modern ICT Core',
    'कंप्यूटर विज्ञान में `AI` का पूरा नाम क्या है?',
    'What is the full form of `AI` in computer science?',
    $json$[{"key":"A","text_hi":"Automatic Internet","text_en":"Automatic Internet"},{"key":"B","text_hi":"Active Input","text_en":"Active Input"},{"key":"C","text_hi":"Applied Information","text_en":"Applied Information"},{"key":"D","text_hi":"Artificial Intelligence (कृत्रिम बुद्धिमत्ता)","text_en":"Artificial Intelligence"}]$json$::jsonb, 'D',
    'हिंदी में इसे "कृत्रिम बुद्धिमत्ता" कहते हैं!', 'A = Artificial, I = Intelligence!',
    'AI का पूरा नाम **Artificial Intelligence (कृत्रिम बुद्धिमत्ता)** है।', 'AI stands for **Artificial Intelligence**.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #9: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000009', 'skill-ict-lab', 'skill-ict-ch6', 'Everyday AI Examples', 'PRACTICE', 'MCQ', 'FOUNDATION', NULL,
    'निम्नलिखित में से कौन-सा दैनिक जीवन में Artificial Intelligence (AI) का एक उदाहरण है?',
    'Which of the following is an everyday example of Artificial Intelligence (AI)?',
    $json$[{"key":"A","text_hi":"मोबाइल में हिंदी बोलकर टाइप करना (Voice Typing) व भाषा अनुवाद","text_en":"Hindi Voice Typing & automatic language translation on a smartphone"},{"key":"B","text_hi":"सामान्य बिजली का पंखा चलाना","text_en":"Switching on an ordinary ceiling fan"},{"key":"C","text_hi":"पेंसिल से कॉपी में लिखना","text_en":"Writing with a pencil in a notebook"},{"key":"D","text_hi":"बल्ब का स्विच दबाना","text_en":"Pressing a light bulb switch"}]$json$::jsonb, 'A',
    'कौन-सा उपकरण आपकी आवाज़ को समझकर शब्दों में बदलता है?', 'Which option recognizes human speech patterns and translates languages?',
    'वॉइस टाइपिंग, भाषा अनुवाद, Google Lens और Google Maps ट्रैफिक पूर्वानुमान सभी आधुनिक AI के दैनिक उदाहरण हैं।', 'Voice typing, automatic translation, Google Lens, and traffic prediction are all real-world AI applications.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #10: MCQ (FOUNDATION, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000010', 'skill-ict-lab', 'skill-ict-ch6', 'Prompt Meaning', 'PRACTICE', 'MCQ', 'FOUNDATION', 'Modern ICT Core',
    'किसी जेनरेटिव AI टूल से उत्तर पाने के लिए यूज़र द्वारा लिखे या बोले गए निर्देश को क्या कहते हैं?',
    'What is the text or spoken instruction given by a user to a Generative AI tool called?',
    $json$[{"key":"A","text_hi":"फोल्डर (Folder)","text_en":"Folder"},{"key":"B","text_hi":"प्रिंटर (Printer)","text_en":"Printer"},{"key":"C","text_hi":"प्रॉम्प्ट (Prompt)","text_en":"Prompt"},{"key":"D","text_hi":"ब्राउज़र (Browser)","text_en":"Browser"}]$json$::jsonb, 'C',
    'हमने स्मार्ट सवाल लिखने का `R-C-F ______` फॉर्मूला पढ़ा है!', 'We learned the `R-C-F ______` formula for asking smart questions!',
    'AI को दिया जाने वाला कोई भी सवाल या निर्देश **प्रॉम्प्ट (Prompt)** कहलाता है।', 'Any question or instruction given to an AI system is called a **Prompt**.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #11: MCQ (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000011', 'skill-ict-lab', 'skill-ict-ch6', 'Father of AI', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB ICT Model',
    '"Artificial Intelligence (AI) का जनक" किसे माना जाता है जिन्होंने 1956 में यह नाम दिया था?',
    'Who is known as the "Father of Artificial Intelligence" for coining the term in 1956?',
    $json$[{"key":"A","text_hi":"चार्ल्स बैबेज (Charles Babbage)","text_en":"Charles Babbage"},{"key":"B","text_hi":"जॉन मैकार्थी (John McCarthy)","text_en":"John McCarthy"},{"key":"C","text_hi":"आइज़ैक न्यूटन (Isaac Newton)","text_en":"Isaac Newton"},{"key":"D","text_hi":"थॉमस एडिसन (Thomas Edison)","text_en":"Thomas Edison"}]$json$::jsonb, 'B',
    'चार्ल्स बैबेज कंप्यूटर के जनक हैं; AI शब्द 1956 में किसने दिया था?', 'Charles Babbage is Father of Computer; who coined AI in 1956?',
    'अमेरिकी कंप्यूटर वैज्ञानिक **जॉन मैकार्थी (John McCarthy)** ने 1956 के डार्टमाउथ सम्मेलन में "Artificial Intelligence" शब्द दिया था।', 'Computer scientist **John McCarthy** coined the term "Artificial Intelligence" in 1956 at the Dartmouth conference.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #12: MCQ (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000012', 'skill-ict-lab', 'skill-ict-ch6', 'AI Hallucination Concept', 'PRACTICE', 'MCQ', 'BOARD', 'AI Safety Core',
    'जब कोई AI चैटबॉट पूरे आत्मविश्वास के साथ कोई गलत इतिहास की तारीख या गलत वैज्ञानिक तथ्य बना दे, तो इसे क्या कहा जाता है?',
    'When an AI chatbot confidently invents a false historical date or wrong scientific fact, what is this called?',
    $json$[{"key":"A","text_hi":"AI भ्रम (AI Hallucination)","text_en":"AI Hallucination"},{"key":"B","text_hi":"AI फॉर्मेटिंग (Formatting)","text_en":"AI Formatting"},{"key":"C","text_hi":"AI बूटिंग (Booting)","text_en":"AI Booting"},{"key":"D","text_hi":"AI स्कैनिंग (Scanning)","text_en":"AI Scanning"}]$json$::jsonb, 'A',
    'जो चीज़ असल में नहीं है, उसका भ्रम देखना!', 'Seeing or stating something unreal as if it were real!',
    'AI द्वारा आत्मविश्वास के साथ गलत या काल्पनिक जानकारी उत्पन्न करना **AI Hallucination** कहलाता है। इसलिए पाठ्यपुस्तक से सत्यापन ज़रूरी है।', 'Confidently fabricating false information is called **AI Hallucination**, making textbook verification vital.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #13: MCQ (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000013', 'skill-ict-lab', 'skill-ict-ch6', 'AI Privacy Safety', 'PRACTICE', 'MCQ', 'BOARD', NULL,
    'AI टूल्स का उपयोग करते समय विद्यार्थियों को इनमें से क्या **कभी नहीं** साझा करना चाहिए?',
    'Which of the following should students NEVER type or upload into public AI chat tools?',
    $json$[{"key":"A","text_hi":"अपनी कक्षा और विज्ञान के अध्याय का नाम","text_en":"Their class number and Science chapter title"},{"key":"B","text_hi":"गणित का एक पाठ्यपुस्तक समीकरण","text_en":"A math equation from their textbook"},{"key":"C","text_hi":"अंग्रेज़ी व्याकरण का एक अभ्यास वाक्य","text_en":"A practice English grammar sentence"},{"key":"D","text_hi":"आधार संख्या, बैंक पासवर्ड, OTP और निजी पारिवारिक फोटो","text_en":"Aadhaar number, bank password, OTP, and private family photos"}]$json$::jsonb, 'D',
    'निजी पहचान और बैंकिंग सुरक्षा से जुड़े विवरण हमेशा गोपनीय रखें!', 'Keep sensitive personal IDs, banking secrets, and private photos strictly confidential!',
    'निजता (Privacy) की रक्षा के लिए आधार, पासवर्ड, OTP, मोबाइल नंबर और निजी फोटो कभी भी सार्वजनिक AI चैट में नहीं डालनी चाहिए।', 'Never share Aadhaar, passwords, OTPs, or private photos in public AI tools to protect your personal privacy.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #14: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000014', 'skill-ict-lab', 'skill-ict-ch6', 'Plagiarism & Academic Integrity', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB ICT Model',
    'AI द्वारा लिखे गए पूरे निबंध या प्रोजेक्ट को बिना समझे ज्यों का त्यों कॉपी करके अपने नाम से जमा करना क्या कहलाता है?',
    'Copying an entire AI-generated essay word-for-word and submitting it as your own original work is called:',
    $json$[{"key":"A","text_hi":"एन्क्रिप्शन (Encryption)","text_en":"Encryption"},{"key":"B","text_hi":"कम्पाइलेशन (Compilation)","text_en":"Compilation"},{"key":"C","text_hi":"प्लेज़रिज़्म / साहित्यिक चोरी (Plagiarism)","text_en":"Plagiarism"},{"key":"D","text_hi":"ऑटोसम (AutoSum)","text_en":"AutoSum"}]$json$::jsonb, 'C',
    'किसी दूसरे की रचना को अपनी बताकर पेश करने की शैक्षणिक त्रुटि!', 'Academic dishonesty of passing off generated or copied text as your own!',
    'दूसरों या AI के लिखे काम को बिना समझे अपना बताकर जमा करना **प्लेज़रिज़्म (Plagiarism)** कहलाता है और इससे छात्र का वास्तविक लेखन कौशल कमजोर होता है।', 'Presenting copied or AI-generated work as your own is **Plagiarism**, and it weakens your own exam writing ability.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #15: MCQ (TOPPER, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000015', 'skill-ict-lab', 'skill-ict-ch6', 'Machine Learning Pattern Principle', 'PRACTICE', 'MCQ', 'TOPPER', NULL,
    'एक सामान्य कैलकुलेटर और आधुनिक Machine Learning (AI) प्रणाली में सबसे बुनियादी अंतर क्या है?',
    'What is the fundamental difference between a basic calculator and a modern Machine Learning (AI) system?',
    $json$[{"key":"A","text_hi":"कैलकुलेटर बिना बिजली के नहीं चलता, पर AI बिना बिजली के चलता है","text_en":"Calculators need power while AI needs no electricity"},{"key":"B","text_hi":"कैलकुलेटर केवल तय स्थिर नियमों का पालन करता है, जबकि AI लाखों उदाहरणों (डेटा) से पैटर्न सीखकर नए उत्तर का अनुमान लगाता है","text_en":"A calculator only follows fixed hard-coded rules, whereas AI learns patterns from huge training examples to handle new inputs"},{"key":"C","text_hi":"AI में मनुष्य जैसी वास्तविक भावनाएँ और चेतना होती है","text_en":"AI possesses real human feelings and consciousness"},{"key":"D","text_hi":"कैलकुलेटर हमेशा गलत जोड़ता है","text_en":"Calculators always calculate inaccurately"}]$json$::jsonb, 'B',
    'आम और अमरूद पहचानना सीखने वाला उदाहरण याद करें!', 'Recall how AI learns patterns from examples rather than rigid fixed rules alone!',
    'कैलकुलेटर तय प्रोग्राम किए गए नियमों पर चलता है, जबकि Machine Learning आधारित AI बड़े डेटा से पैटर्न सीखकर आवाज़ पहचानने, अनुवाद करने और व्याख्या देने में सक्षम होता है।', 'Calculators execute fixed rules, whereas Machine Learning AI extracts patterns from massive example datasets to translate, recognize speech, and assist.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #16: MCQ (FOUNDATION, EXAM_ONLY)
  (
    '10000005-0006-4000-8000-000000000016', 'skill-ict-lab', 'skill-ict-ch6', 'Deepfake Definition', 'EXAM_ONLY', 'MCQ', 'FOUNDATION', 'ICT Live Exam',
    'AI तकनीक से किसी असली व्यक्ति के चेहरे या आवाज़ की हूबहू नकल कर बनाया गया नकली वीडियो या ऑडियो क्या कहलाता है?',
    'What is a fake video or audio clip created by AI to clone a real person''s face or voice called?',
    $json$[{"key":"A","text_hi":"क्लिपबोर्ड (Clipboard)","text_en":"Clipboard"},{"key":"B","text_hi":"स्प्रेडशीट (Spreadsheet)","text_en":"Spreadsheet"},{"key":"C","text_hi":"हाइपरलिंक (Hyperlink)","text_en":"Hyperlink"},{"key":"D","text_hi":"डीपफेक (Deepfake)","text_en":"Deepfake"}]$json$::jsonb, 'D',
    'Deep Learning + Fake से बना शब्द!', 'A blend of Deep Learning + Fake!',
    'AI से निर्मित नकली आवाज़ या चेहरे वाले वीडियो को **डीपफेक (Deepfake)** कहते हैं।', 'AI-generated synthetic face or voice imitations are called **Deepfakes**.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #17: MCQ (BOARD, EXAM_ONLY)
  (
    '10000005-0006-4000-8000-000000000017', 'skill-ict-lab', 'skill-ict-ch6', 'R-C-F Prompt Components', 'EXAM_ONLY', 'MCQ', 'BOARD', 'ICT Live Exam',
    'स्मार्ट पढ़ाई के लिए बताए गए `R-C-F` प्रॉम्प्ट फॉर्मूले में `F` का क्या अर्थ है?',
    'In the `R-C-F` smart study prompt formula, what does `F` stand for?',
    $json$[{"key":"A","text_hi":"Format (उत्तर का रूप — जैसे 5 बिंदु, तालिका या क्विज़)","text_en":"Format (Desired shape of output — e.g., 5 bullets, table, or quiz)"},{"key":"B","text_hi":"File Size (फाइल का आकार)","text_en":"File Size"},{"key":"C","text_hi":"Font Color (फॉन्ट का रंग)","text_en":"Font Color"},{"key":"D","text_hi":"Folder Name (फोल्डर का नाम)","text_en":"Folder Name"}]$json$::jsonb, 'A',
    'Role + Clear Topic + आप उत्तर किस रूप में चाहते हैं?', 'Role + Clear Topic + how you want the response structured!',
    'R-C-F में `R = Role`, `C = Clear Topic` और **`F = Format`** (जैसे 5 बुलेट बिंदु, तुलना सारणी या MCQ क्विज़) होता है।', 'In R-C-F, `R = Role`, `C = Clear Topic`, and **`F = Format`** (bullets, table, or quiz).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #18: MCQ (TOPPER, EXAM_ONLY)
  (
    '10000005-0006-4000-8000-000000000018', 'skill-ict-lab', 'skill-ict-ch6', 'Fact-Checking AI Answers', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'ICT Live Exam',
    'बोर्ड परीक्षा की तैयारी करते समय यदि AI द्वारा दी गई कोई ऐतिहासिक तिथि आपकी BSEB पाठ्यपुस्तक से अलग है, तो आपको क्या करना चाहिए?',
    'While preparing for board exams, if a historical date given by AI disagrees with your official BSEB textbook, what should you trust?',
    $json$[{"key":"A","text_hi":"किताब को गलत मानकर AI की तिथि याद कर लें","text_en":"Ignore the textbook and memorize the AI date"},{"key":"B","text_hi":"दोनों तिथियों को जोड़कर औसत लिख दें","text_en":"Average both dates together"},{"key":"C","text_hi":"अपनी आधिकारिक BSEB पाठ्यपुस्तक और विषय शिक्षक के मार्गदर्शन पर भरोसा करें (क्योंकि AI में Hallucination हो सकता है)","text_en":"Trust your official BSEB textbook and teacher (because AI can hallucinate dates)"},{"key":"D","text_hi":"वह अध्याय पढ़ना छोड़ दें","text_en":"Skip studying the chapter altogether"}]$json$::jsonb, 'C',
    'बोर्ड परीक्षा के उत्तर किस प्रामाणिक स्रोत के आधार पर जाँचे जाते हैं?', 'Which authoritative source are BSEB board exam answers graded against?',
    'AI में Hallucination (गलत तथ्य) संभव है, जबकि बोर्ड परीक्षा का मूल्यांकन आधिकारिक NCERT/BSEB पाठ्यपुस्तकों के अनुसार होता है।', 'AI can hallucinate dates and facts, whereas board exams are graded strictly against official BSEB/NCERT textbooks.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL, true
  ),
  -- #19: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000019', 'skill-ict-lab', 'skill-ict-ch6', 'Prompt & R-C-F Formula', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'AI प्रॉम्प्ट (Prompt) किसे कहते हैं? स्मार्ट अध्ययन प्रॉम्प्ट लिखने का R-C-F फॉर्मूला एक उदाहरण सहित समझाएँ।',
    'What is an AI Prompt? Explain the R-C-F formula for writing a smart study prompt with one example.',
    NULL, NULL,
    'Prompt की 1-पंक्ति परिभाषा + R, C, F के नाम + 1 छोटा छात्र उदाहरण लिखें।', 'Define Prompt in 1 line + expand R, C, F + give 1 concrete student example.',
    NULL, NULL,
    '- **प्रॉम्प्ट (Prompt):** किसी AI टूल को दिया गया स्पष्ट लिखित या बोला गया प्रश्न/निर्देश प्रॉम्प्ट कहलाता है।
- **R-C-F फॉर्मूला:** **R (Role)** = अपनी कक्षा/बोर्ड बताएँ, **C (Clear Topic)** = सटीक विषय व भाषा लिखें, **F (Format)** = उत्तर का रूप (5 बिंदु, तालिका या क्विज़) चुनें।
- **उदाहरण:** *"मैं बिहार बोर्ड कक्षा 10 का छात्र हूँ [R]। प्रकाश संश्लेषण को सरल हिंदी में रसोई के उदाहरण से समझाओ [C], 5 बिंदुओं और 2 अभ्यास प्रश्नों में [F]।"*', '- **Prompt:** A clear written or spoken instruction/question given to an AI tool.
- **R-C-F Formula:** **R (Role)** = state your class & board, **C (Clear Topic)** = specify exact doubt & language, **F (Format)** = choose bullets, table, or quiz.
- **Example:** *"I am a BSEB Class 10 student [R]. Explain Photosynthesis in simple Hindi with a kitchen analogy [C], in 5 bullet points plus 2 quiz questions [F]."*',
    $json$[{"cue_hi":"Prompt = AI को दिया गया स्पष्ट निर्देश","cue_en":"Prompt = Clear instruction to AI"},{"cue_hi":"R-C-F = Role + Clear Topic + Format","cue_en":"R-C-F = Role + Clear Topic + Format"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"प्रॉम्प्ट की परिभाषा व R-C-F का सही विस्तार","criterion_en":"Defines Prompt and expands R-C-F accurately"},{"step_no":2,"marks":1,"criterion_hi":"एक सटीक छात्र-उपयोगी R-C-F उदाहरण","criterion_en":"Provides one clear student R-C-F prompt example"}]$json$::jsonb,
    NULL, true
  ),
  -- #20: SHORT_2M (BOARD, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000020', 'skill-ict-lab', 'skill-ict-ch6', 'AI Hallucination & Verification', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB ICT Viva',
    'AI भ्रम (AI Hallucination) क्या है? छात्रों के लिए AI के उत्तरों को पाठ्यपुस्तक से मिलाना क्यों ज़रूरी है?',
    'What is AI Hallucination? Why must students verify AI answers against their textbook?',
    NULL, NULL,
    'गलत तथ्य गढ़ने की परिभाषा + बोर्ड परीक्षा की सटीकता का कारण लिखें।', 'Define fabricated confident errors + explain why board accuracy demands verification.',
    NULL, NULL,
    '1. **AI Hallucination:** चूँकि AI पैटर्न के आधार पर शब्दों का अनुमान लगाता है, इसलिए वह कभी-कभी पूरे आत्मविश्वास के साथ गलत तारीख, गलत सूत्र या काल्पनिक तथ्य बना देता है — इसी त्रुटि को **AI Hallucination** कहते हैं।
2. **सत्यापन क्यों ज़रूरी है?** बोर्ड परीक्षा में उत्तर आधिकारिक **BSEB/NCERT पाठ्यपुस्तकों** के अनुसार जाँचे जाते हैं। बिना जाँचे AI का गलत तथ्य याद करने पर परीक्षा में अंक कट सकते हैं, इसलिए किताब और शिक्षक से मिलान अनिवार्य है।', '1. **AI Hallucination:** Because AI predicts text from patterns, it sometimes generates false dates, wrong formulas, or fictional facts with full confidence — known as **AI Hallucination**.
2. **Why Verify:** Board exams are strictly evaluated against official **BSEB/NCERT textbooks**. Cross-checking with your textbook or teacher ensures you never memorize an invented error.',
    $json$[{"cue_hi":"Hallucination = AI द्वारा आत्मविश्वास से गलत तथ्य गढ़ना","cue_en":"Hallucination = Confidently invented wrong facts"},{"cue_hi":"समाधान = हमेशा BSEB किताब/शिक्षक से जाँचें","cue_en":"Fix = Always verify against BSEB textbook/teacher"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"AI Hallucination की स्पष्ट परिभाषा","criterion_en":"Clear definition of AI Hallucination"},{"step_no":2,"marks":1,"criterion_hi":"पाठ्यपुस्तक/शिक्षक से सत्यापन का व्यावहारिक कारण","criterion_en":"Explains why textbook/teacher verification protects exam marks"}]$json$::jsonb,
    NULL, true
  ),
  -- #21: LONG_5M (TOPPER, PRACTICE)
  (
    '10000005-0006-4000-8000-000000000021', 'skill-ict-lab', 'skill-ict-ch6', 'Smart & Safe AI Study Guide 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB ICT Practical',
    'विद्यार्थी बिहार बोर्ड परीक्षा की स्मार्ट तैयारी के लिए Artificial Intelligence (AI) का सही उपयोग कैसे कर सकते हैं? साथ ही AI युग के 3 मुख्य सुरक्षा नियम (Hallucination, Deepfake और Privacy) विस्तार से लिखें।',
    'How can students responsibly use Artificial Intelligence (AI) for smart Bihar Board exam preparation? Also explain 3 vital AI-era safety rules (Hallucination, Deepfake, and Data Privacy).',
    NULL, NULL,
    'भाग 1 में 4 स्मार्ट अध्ययन उपयोग (समझना, व्याकरण जाँच, क्विज़, अनुवाद) और भाग 2 में तीनों सुरक्षा नियम स्पष्ट लिखें।', 'Part 1: 4 smart study habits; Part 2: all 3 safety rules (Hallucination, Deepfake, Privacy).',
    NULL, NULL,
    '**भाग 1 — बोर्ड परीक्षा के लिए AI का स्मार्ट उपयोग (कोच बनाएँ, नकल नहीं!):**
1. **कठिन अवधारणाओं को सरल उदाहरण से समझना:** R-C-F प्रॉम्प्ट (*कक्षा + विषय + 5 बिंदु*) देकर विज्ञान व गणित के कठिन नियम आसान हिंदी में समझें।
2. **स्व-परीक्षण (Practice Quizzes):** अध्याय पढ़ने के बाद AI से 5–10 अभ्यास प्रश्न बनवाकर अपनी तैयारी जाँचें।
3. **अंग्रेज़ी लेखन व व्याकरण सुधार:** पहले खुद 8–10 वाक्य लिखें, फिर AI से केवल अपनी गलतियाँ पूछकर खुद सुधारें — कभी बिना पढ़े कॉपी-पेस्ट (**Plagiarism**) न करें!
4. **त्वरित भाषा अनुवाद व रिवीजन सार:** कठिन अंग्रेज़ी शब्दों के हिंदी अर्थ व उच्चारण सीखें।

**भाग 2 — AI युग के 3 अनिवार्य सुरक्षा नियम:**
1. **AI Hallucination से बचाव:** AI आत्मविश्वास से गलत तारीख या सूत्र लिख सकता है, इसलिए हर तथ्य को अपनी **BSEB पाठ्यपुस्तक या शिक्षक** से अवश्य जाँचें।
2. **Deepfake वॉइस/वीडियो ठगी से सुरक्षा:** यदि अनजान नंबर से किसी रिश्तेदार की हूबहू आवाज़ में तुरंत UPI पैसे माँगे जाएँ, तो कॉल काटें और उनके **पुराने असली नंबर पर खुद कॉल कर पुष्टि करें**।
3. **निजता सुरक्षा (Data Privacy):** कभी भी अपना आधार नंबर, बैंक पासवर्ड, OTP, मोबाइल नंबर या पारिवारिक फोटो किसी सार्वजनिक AI चैट या असुरक्षित ऐप पर अपलोड न करें।', '**Part 1 — Smart Ways to Use AI for Board Preparation (Coach, Not Cheating!):**
1. **Clarifying Tough Concepts:** Use R-C-F prompts (*Class + Topic + 5 simple bullets*) to understand tricky Science or Math topics with relatable analogies.
2. **Self-Testing Quizzes:** After reading your chapter, generate 5–10 practice MCQs to test real understanding.
3. **English Grammar Feedback:** Always draft sentences in your own words first and ask AI to highlight errors — avoid blind copy-paste (**Plagiarism**).
4. **Vocabulary & Revision Summaries:** Decode tough English terms with clear Hindi meanings and concise revision outlines.

**Part 2 — 3 Essential Safety Rules for the AI Era:**
1. **Guard Against AI Hallucinations:** AI can confidently fabricate dates or formulas; always cross-check exam facts with your **BSEB textbook or teacher**.
2. **Defeat Deepfake Scams:** If an unknown caller mimics a relative''s voice/video demanding urgent UPI money, hang up and **call back their saved real number** first.
3. **Protect Data Privacy:** Never type Aadhaar numbers, passwords, OTPs, or upload personal/family photos into public AI chats or untrusted apps.',
    $json$[{"cue_hi":"स्मार्ट उपयोग = समझना + क्विज़ + खुद लिखकर व्याकरण जाँच","cue_en":"Smart use = Clarify + Quiz + Check own draft"},{"cue_hi":"3 सुरक्षा ढाल = Hallucination जाँच + Deepfake कॉलबैक + Privacy","cue_en":"3 Shields = Verify Hallucinations + Deepfake callback + Privacy"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1.5,"criterion_hi":"R-C-F व स्मार्ट अध्ययन के 3–4 सही उपयोग (नकल के बिना)","criterion_en":"3–4 responsible study uses including R-C-F & avoiding plagiarism"},{"step_no":2,"marks":1.25,"criterion_hi":"AI Hallucination की पहचान व पाठ्यपुस्तक सत्यापन नियम","criterion_en":"Explains AI Hallucination and textbook fact-checking"},{"step_no":3,"marks":1.25,"criterion_hi":"Deepfake वॉइस/वीडियो स्कैम व असली नंबर पर कॉलबैक नियम","criterion_en":"Explains Deepfake scam & callback verification rule"},{"step_no":4,"marks":1,"criterion_hi":"डेटा निजता (आधार/पासवर्ड/निजी फोटो न साझा करना)","criterion_en":"Covers Data Privacy (never sharing Aadhaar/passwords/photos)"}]$json$::jsonb,
    NULL, true
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
