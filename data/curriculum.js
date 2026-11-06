/**
 * U.H.S. Kaparpura — Phase 1 Bilingual Curriculum Bank (Hindi + English)
 * Covers ICT Lab (Computer Basics, MS Word, MS Excel, AI & Cyber Safety) + BSEB Board Exam Boosters
 */
window.PORTAL_CURRICULUM = {
  badgesCatalog: {
    WELCOME_SCHOLAR: { icon: "🎓", hi: "नवप्रवेशी विद्वान", en: "Welcome Scholar", descHi: "पोर्टल पर पहली बार लॉगिन किया", descEn: "Logged into the Student Portal for the first time" },
    WORD_NINJA: { icon: "⌨️", hi: "एमएस वर्ड निंजा", en: "MS Word Ninja", descHi: "MS Word शॉर्टकट और अभ्यास में महारत", descEn: "Mastered MS Word Shortcuts & Mastery Quiz" },
    EXCEL_WIZARD: { icon: "📊", hi: "एक्सेल फॉर्मूला जादूगर", en: "Excel Formula Wizard", descHi: "MS Excel फॉर्मूला सैंडबॉक्स पूरा किया", descEn: "Completed MS Excel Formula Sandbox challenges" },
    AI_EXPLORER: { icon: "🤖", hi: "AI एवं साइबर रक्षक", en: "AI & Cyber Explorer", descHi: "आर्टिफिशियल इंटेलिजेंस अध्याय पूरा किया", descEn: "Mastered Artificial Intelligence & Cyber Safety" },
    OMR_CHAMPION: { icon: "📝", hi: "BSEB OMR चैंपियन", en: "BSEB OMR Champion", descHi: "बिहार बोर्ड 50% OMR सिम्युलेटर में 80%+ अंक", descEn: "Scored 80%+ in BSEB 50% Objective OMR Simulator" },
    MISTAKE_CRUSHER: { icon: "🛠️", hi: "गलती सुधार विजेता", en: "Mistake Crusher", descHi: "अपनी गलती सुधार बैंक से प्रश्नों को सही किया", descEn: "Cleared mistakes from the Mistake Notebook" },
    CENTURY_SCORER: { icon: "💯", hi: "शतकवीर (100+ XP)", en: "Century Scorer (100+ XP)", descHi: "100+ कुल XP अर्जित किए", descEn: "Earned 100+ Total XP" },
    ICT_CHAMPION: { icon: "💻", hi: "ICT लैब चैंपियन", en: "ICT Lab Champion", descHi: "ICT लैब में 150+ XP अर्जित किए", descEn: "Earned 150+ XP in ICT Lab modules" },
    BSEB_STAR: { icon: "🌟", hi: "बिहार बोर्ड टॉपर स्टार", en: "BSEB Topper Star", descHi: "500+ कुल XP अर्जित किए", descEn: "Earned 500+ Total XP" }
  },

  chapters: [
    {
      id: "ICT_01",
      category: "ICT",
      badgeId: "WELCOME_SCHOLAR",
      icon: "🖥️",
      color: "#3b82f6",
      titleHi: "अध्याय 1: कंप्यूटर के मूल सिद्धांत और हार्डवेयर",
      titleEn: "Ch 1: Computer Fundamentals & OS",
      descHi: "CPU, RAM, ROM, इनपुट/आउटपुट डिवाइस और ऑपरेटिंग सिस्टम की संपूर्ण समझ।",
      descEn: "Master CPU, RAM, ROM, Input/Output Devices, Memory Units, and Windows OS basics.",
      flashcards: [
        {
          titleHi: "CPU (सेंट्रल प्रोसेसिंग यूनिट)",
          titleEn: "CPU (Central Processing Unit)",
          bodyHi: "इसे 'कंप्यूटर का मस्तिष्क' कहा जाता है। इसके तीन मुख्य भाग होते हैं: ALU (गणना के लिए), CU (नियंत्रण के लिए) और मेमोरी रजिस्टर।",
          bodyEn: "Known as the 'Brain of the Computer'. Its 3 core components are ALU (Arithmetic Logic Unit), CU (Control Unit), and Registers.",
          tipHi: "परीक्षा टिप: अंकगणितीय और तार्किक गणनाएँ हमेशा ALU द्वारा की जाती हैं।",
          tipEn: "Exam Tip: Arithmetic and logical operations are always performed inside the ALU."
        },
        {
          titleHi: "RAM बनाम ROM (प्राथमिक मेमोरी)",
          titleEn: "RAM vs ROM (Primary Memory)",
          bodyHi: "RAM (Random Access Memory) अस्थायी (Volatile) मेमोरी है—बिजली जाने पर डेटा मिट जाता है। ROM (Read Only Memory) स्थायी (Non-Volatile) है जिसमें BIOS स्टोर रहता है।",
          bodyEn: "RAM is Volatile memory (data is lost when power turns off). ROM is Non-Volatile memory that stores the startup BIOS instructions.",
          tipHi: "परीक्षा टिप: बूटिंग प्रक्रिया (Booting) के लिए ROM में मौजूद BIOS जिम्मेदार होता है।",
          tipEn: "Exam Tip: BIOS stored inside ROM is responsible for booting the computer."
        },
        {
          titleHi: "इनपुट बनाम आउटपुट डिवाइस",
          titleEn: "Input vs Output Devices",
          bodyHi: "इनपुट: कीबोर्ड, माउस, स्कैनर, OMR, बारकोड रीडर, माइक। आउटपुट: मॉनिटर (VDU), प्रिंटर, स्पीकर, प्रोजेक्टर, प्लॉटर।",
          bodyEn: "Input: Keyboard, Mouse, Scanner, OMR, Barcode Reader, Mic. Output: Monitor (VDU), Printer, Speaker, Projector, Plotter.",
          tipHi: "परीक्षा टिप: OMR का उपयोग बिहार बोर्ड की बहुविकल्पीय उत्तर पुस्तिका जांचने में होता है।",
          tipEn: "Exam Tip: OMR (Optical Mark Reader) is used to evaluate BSEB objective bubble sheets."
        },
        {
          titleHi: "मेमोरी की इकाइयाँ (Memory Units)",
          titleEn: "Computer Memory Units",
          bodyHi: "1 Bit = 0 या 1 | 4 Bits = 1 Nibble | 8 Bits = 1 Byte | 1024 Bytes = 1 KB | 1024 KB = 1 MB | 1024 MB = 1 GB | 1024 GB = 1 TB",
          bodyEn: "1 Bit = 0 or 1 | 4 Bits = 1 Nibble | 8 Bits = 1 Byte | 1024 Bytes = 1 KB | 1024 KB = 1 MB | 1024 MB = 1 GB | 1024 GB = 1 TB",
          tipHi: "परीक्षा टिप: 1 बाइट (Byte) में 8 बिट्स होते हैं और 1 निबल (Nibble) में 4 बिट्स होते हैं।",
          tipEn: "Exam Tip: 1 Byte = 8 Bits, and 1 Nibble = 4 Bits."
        }
      ],
      questions: [
        {
          id: "ICT01_Q1",
          qHi: "कंप्यूटर का मस्तिष्क (Brain of Computer) किसे कहा जाता है?",
          qEn: "Which component is known as the 'Brain of the Computer'?",
          optionsHi: ["RAM (रैम)", "CPU (सीपीयू)", "Hard Disk (हार्ड डिस्क)", "Monitor (मॉनिटर)"],
          optionsEn: ["RAM", "CPU (Central Processing Unit)", "Hard Disk Drive", "Monitor"],
          correct: 1,
          expHi: "CPU (Central Processing Unit) सभी निर्देशों को प्रोसेस करता है, इसलिए इसे कंप्यूटर का मस्तिष्क कहा जाता है।",
          expEn: "CPU processes all instructions and calculations, making it the brain of the computer."
        },
        {
          id: "ICT01_Q2",
          qHi: "निम्नलिखित में से कौन-सी मेमोरी अस्थायी (Volatile) होती है?",
          qEn: "Which of the following is a Volatile (temporary) memory?",
          optionsHi: ["ROM", "RAM", "Pen Drive", "Hard Disk"],
          optionsEn: ["ROM", "RAM", "Pen Drive", "Hard Disk"],
          correct: 1,
          expHi: "RAM (Random Access Memory) अस्थायी मेमोरी है; कंप्यूटर बंद होने पर इसका डेटा समाप्त हो जाता है।",
          expEn: "RAM loses its stored data as soon as power is turned off, so it is volatile memory."
        },
        {
          id: "ICT01_Q3",
          qHi: "1 किलोबाइट (1 KB) कितने बाइट्स के बराबर होता है?",
          qEn: "1 Kilobyte (1 KB) is equal to how many Bytes?",
          optionsHi: ["1000 Bytes", "512 Bytes", "1024 Bytes", "2048 Bytes"],
          optionsEn: ["1000 Bytes", "512 Bytes", "1024 Bytes", "2048 Bytes"],
          correct: 2,
          expHi: "बाइनरी प्रणाली ($2^{10}$) के अनुसार 1 KB = 1024 Bytes होता है।",
          expEn: "In binary storage ($2^{10}$), 1 Kilobyte equals 1024 Bytes."
        },
        {
          id: "ICT01_Q4",
          qHi: "बिहार बोर्ड की OMR शीट को जांचने के लिए किस इनपुट डिवाइस का उपयोग किया जाता है?",
          qEn: "Which input device is used to read shaded bubbles on a BSEB OMR answer sheet?",
          optionsHi: ["OCR", "MICR", "OMR (Optical Mark Reader)", "Plotter"],
          optionsEn: ["OCR", "MICR", "OMR (Optical Mark Reader)", "Plotter"],
          correct: 2,
          expHi: "OMR (Optical Mark Reader) पेंसिल या पेन से भरे गए गोलों (Bubbles) की पहचान करता है।",
          expEn: "OMR (Optical Mark Reader) detects dark pencil/pen marks on objective examination sheets."
        },
        {
          id: "ICT01_Q5",
          qHi: "कंप्यूटर में अंकगणितीय (Arithmetic) और तार्किक (Logical) गणनाएँ कौन करता है?",
          qEn: "Which part of the CPU performs arithmetic and logical calculations?",
          optionsHi: ["CU (Control Unit)", "ALU (Arithmetic Logic Unit)", "ROM", "Mouse"],
          optionsEn: ["CU (Control Unit)", "ALU (Arithmetic Logic Unit)", "ROM", "Mouse"],
          correct: 1,
          expHi: "ALU (Arithmetic Logic Unit) जोड़, घटाव, गुणा, भाग और तुलना (>, <, =) का कार्य करता है।",
          expEn: "ALU performs all math (+, -, *, /) and logical comparisons."
        },
        {
          id: "ICT01_Q6",
          qHi: "निम्नलिखित में से कौन एक आउटपुट डिवाइस (Output Device) है?",
          qEn: "Which of the following is an Output Device?",
          optionsHi: ["कीबोर्ड (Keyboard)", "स्कैनर (Scanner)", "प्रिंटर (Printer)", "माउस (Mouse)"],
          optionsEn: ["Keyboard", "Scanner", "Printer", "Mouse"],
          correct: 2,
          expHi: "प्रिंटर कंप्यूटर के डिजिटल डेटा को कागज पर छापकर (Hard Copy) बाहर देता है, इसलिए यह आउटपुट डिवाइस है।",
          expEn: "A printer produces hard-copy output from digital data."
        }
      ],
      shortcuts: [
        { keys: ["Ctrl", "C"], promptHi: "चयनित टेक्स्ट या फाइल को कॉपी (Copy) करने के लिए", promptEn: "Copy selected text or file" },
        { keys: ["Ctrl", "V"], promptHi: "कॉपी किए गए आइटम को पेस्ट (Paste) करने के लिए", promptEn: "Paste copied text or file" },
        { keys: ["Ctrl", "Z"], promptHi: "पिछली क्रिया को पूर्ववत (Undo) करने के लिए", promptEn: "Undo the last action" },
        { keys: ["Alt", "F4"], promptHi: "चालू विंडो या प्रोग्राम को बंद (Close) करने के लिए", promptEn: "Close the active window or program" }
      ]
    },

    {
      id: "ICT_02",
      category: "ICT",
      badgeId: "WORD_NINJA",
      icon: "📝",
      color: "#2563eb",
      titleHi: "अध्याय 2: माइक्रोसॉफ्ट वर्ड (MS Word) मास्टरी",
      titleEn: "Ch 2: Microsoft Word Document Mastery",
      descHi: "दस्तावेज़ बनाना, फ़ॉर्मेटिंग, टेबल, पेज सेटअप और सभी महत्वपूर्ण कीबोर्ड शॉर्टकट्स।",
      descEn: "Master document formatting, alignment, tables, mail merge, and essential MS Word keyboard shortcuts.",
      flashcards: [
        {
          titleHi: "MS Word क्या है और इसका एक्सटेंशन",
          titleEn: "What is MS Word & File Extension",
          bodyHi: "MS Word एक Word Processing सॉफ्टवेयर है। इसकी फाइल का डिफ़ॉल्ट एक्सटेंशन `.docx` (पुराने वर्शन में `.doc`) होता है।",
          bodyEn: "MS Word is a Word Processing application. Its default file extension in modern versions is `.docx`.",
          tipHi: "परीक्षा टिप: MS Word में डिफ़ॉल्ट फाइल नाम 'Document1' होता है।",
          tipEn: "Exam Tip: The default filename of a new MS Word file is 'Document1'."
        },
        {
          titleHi: "टेक्स्ट फ़ॉर्मेटिंग शॉर्टकट्स (B / I / U)",
          titleEn: "Text Formatting Shortcuts (B / I / U)",
          bodyHi: "Ctrl + B = गहरा (Bold) | Ctrl + I = तिरछा (Italic) | Ctrl + U = रेखांकित (Underline) | Ctrl + Shift + > = फ़ॉन्ट बड़ा करें।",
          bodyEn: "Ctrl + B = Bold | Ctrl + I = Italic | Ctrl + U = Underline | Ctrl + ] = Increase font size by 1 pt.",
          tipHi: "परीक्षा टिप: सबस्क्रिप्ट ($H_2O$) के लिए `Ctrl + =` और सुपरस्क्रिप्ट ($x^2$) के लिए `Ctrl + Shift + +` दबाएं।",
          tipEn: "Exam Tip: Subscript ($H_2O$) is `Ctrl + =` and Superscript ($x^2$) is `Ctrl + Shift + +`."
        },
        {
          titleHi: "पैराग्राफ एलाइनमेंट (Alignment)",
          titleEn: "Paragraph Alignment Shortcuts",
          bodyHi: "Ctrl + L = बाएं (Left) | Ctrl + E = बीच में (Center) | Ctrl + R = दाएं (Right) | Ctrl + J = दोनों तरफ बराबर (Justify)।",
          bodyEn: "Ctrl + L = Left Align | Ctrl + E = Center Align | Ctrl + R = Right Align | Ctrl + J = Justify.",
          tipHi: "ध्यान दें: Center Align का शॉर्टकट `Ctrl + E` होता है (`Ctrl + C` कॉपी के लिए होता है)!",
          tipEn: "Watch out: Center Align is `Ctrl + E` (because `Ctrl + C` is Copy)!"
        },
        {
          titleHi: "फाइल और प्रिंट कमांड",
          titleEn: "File, Save, Find & Print Commands",
          bodyHi: "Ctrl + N = नई फाइल | Ctrl + S = सेव | F12 = Save As | Ctrl + P = प्रिंट | Ctrl + F = शब्द खोजें (Find) | Ctrl + H = बदलें (Replace)।",
          bodyEn: "Ctrl + N = New Document | Ctrl + S = Save | F12 = Save As | Ctrl + P = Print | Ctrl + F = Find | Ctrl + H = Find & Replace.",
          tipHi: "परीक्षा टिप: वर्तनी और व्याकरण (Spelling & Grammar) जांचने की शॉर्टकट कुंजी `F7` है।",
          tipEn: "Exam Tip: Press `F7` to run Spelling & Grammar check in MS Word."
        }
      ],
      questions: [
        {
          id: "ICT02_Q1",
          qHi: "MS Word 2019/2021 में बनाई गई फाइल का डिफ़ॉल्ट एक्सटेंशन क्या होता है?",
          qEn: "What is the default file extension of a document saved in MS Word 2019/2021?",
          optionsHi: [".xlsx", ".pptx", ".docx", ".txt"],
          optionsEn: [".xlsx", ".pptx", ".docx", ".txt"],
          correct: 2,
          expHi: "MS Word दस्तावेज़ `.docx` एक्सटेंशन के साथ सेव होते हैं (Excel `.xlsx` और PowerPoint `.pptx` में)।",
          expEn: "MS Word uses `.docx`, whereas Excel uses `.xlsx` and PowerPoint uses `.pptx`."
        },
        {
          id: "ICT02_Q2",
          qHi: "MS Word में किसी शीर्षक को पेज के बिल्कुल बीच (Center Align) करने की शॉर्टकट कुंजी क्या है?",
          qEn: "Which keyboard shortcut centers (Center Aligns) selected text in MS Word?",
          optionsHi: ["Ctrl + C", "Ctrl + E", "Ctrl + M", "Ctrl + J"],
          optionsEn: ["Ctrl + C", "Ctrl + E", "Ctrl + M", "Ctrl + J"],
          correct: 1,
          expHi: "`Ctrl + E` टेक्स्ट को सेंटर एलाइन करता है, जबकि `Ctrl + C` कॉपी करने के काम आता है।",
          expEn: "`Ctrl + E` centers text; `Ctrl + C` copies selected text."
        },
        {
          id: "ICT02_Q3",
          qHi: "दस्तावेज़ में किसी शब्द को खोजकर दूसरे शब्द से बदलने (Find & Replace) का शॉर्टकट क्या है?",
          qEn: "What is the shortcut key to open 'Find and Replace' in MS Word?",
          optionsHi: ["Ctrl + F", "Ctrl + R", "Ctrl + H", "Ctrl + G"],
          optionsEn: ["Ctrl + F", "Ctrl + R", "Ctrl + H", "Ctrl + G"],
          correct: 2,
          expHi: "`Ctrl + H` से Find & Replace डायलॉग खुलता है। `Ctrl + F` केवल खोजने (Find) के लिए है।",
          expEn: "`Ctrl + H` opens Find & Replace (`Ctrl + F` is Find only)."
        },
        {
          id: "ICT02_Q4",
          qHi: "MS Word में स्पेलिंग और ग्रामर (Spelling & Grammar) चेक करने के लिए कौन-सी फंक्शन कुंजी दबाई जाती है?",
          qEn: "Which function key is used to check Spelling & Grammar in MS Word?",
          optionsHi: ["F1", "F5", "F7", "F12"],
          optionsEn: ["F1", "F5", "F7", "F12"],
          correct: 2,
          expHi: "`F7` कुंजी दबाने से Spelling & Grammar टूल चालू होता है।",
          expEn: "`F7` launches the Spelling & Grammar checker in MS Office."
        },
        {
          id: "ICT02_Q5",
          qHi: "MS Word में नया खाली पेज (Page Break) डालने की शॉर्टकट कुंजी क्या है?",
          qEn: "Which shortcut inserts a Page Break in MS Word?",
          optionsHi: ["Shift + Enter", "Ctrl + Enter", "Alt + Enter", "Ctrl + B"],
          optionsEn: ["Shift + Enter", "Ctrl + Enter", "Alt + Enter", "Ctrl + B"],
          correct: 1,
          expHi: "`Ctrl + Enter` दबाने से कर्सर के स्थान से नया पेज (Page Break) शुरू हो जाता है।",
          expEn: "`Ctrl + Enter` immediately inserts a Page Break."
        },
        {
          id: "ICT02_Q6",
          qHi: "एक ही पत्र को कई छात्रों के अलग-अलग पते पर भेजने के लिए MS Word के किस फीचर का उपयोग होता है?",
          qEn: "Which feature in MS Word lets you send the same letter/admit card to hundreds of recipients?",
          optionsHi: ["Macro (मैक्रो)", "Mail Merge (मेल मर्ज)", "WordArt (वर्डआर्ट)", "Thesaurus (थिसॉरस)"],
          optionsEn: ["Macro", "Mail Merge", "WordArt", "Thesaurus"],
          correct: 1,
          expHi: "Mail Merge के द्वारा एक मुख्य दस्तावेज़ को डेटा लिस्ट (जैसे छात्रों के नाम/पते) से जोड़कर सैकड़ों पत्र बनाए जाते हैं।",
          expEn: "Mail Merge combines a template letter with a recipient data source."
        }
      ],
      shortcuts: [
        { keys: ["Ctrl", "B"], promptHi: "चयनित टेक्स्ट को गहरा (Bold) करने के लिए", promptEn: "Make selected text Bold" },
        { keys: ["Ctrl", "E"], promptHi: "टेक्स्ट को पेज के बीच में (Center Align) करने के लिए", promptEn: "Center Align the heading/paragraph" },
        { keys: ["Ctrl", "H"], promptHi: "शब्द खोजने और बदलने (Find & Replace) के लिए", promptEn: "Open Find and Replace dialog" },
        { keys: ["Ctrl", "S"], promptHi: "अपनी MS Word फाइल को सुरक्षित (Save) करने के लिए", promptEn: "Save the current document" },
        { keys: ["F7"], promptHi: "स्पेलिंग और व्याकरण (Spelling & Grammar) जांचने के लिए", promptEn: "Run Spelling & Grammar Check" },
        { keys: ["Ctrl", "P"], promptHi: "दस्तावेज़ को प्रिंट (Print) करने के लिए", promptEn: "Print the document" }
      ]
    },

    {
      id: "ICT_03",
      category: "ICT",
      badgeId: "EXCEL_WIZARD",
      icon: "📊",
      color: "#10b981",
      titleHi: "अध्याय 3: माइक्रोसॉफ्ट एक्सेल (MS Excel) और फॉर्मूला",
      titleEn: "Ch 3: MS Excel Spreadsheets & Formulas",
      descHi: "रो, कॉलम, सेल एड्रेस और =SUM, =AVERAGE, =MAX, =MIN, =COUNT फॉर्मूला का लाइव अभ्यास।",
      descEn: "Learn Rows, Columns, Cell Addresses, and practice live =SUM, =AVERAGE, =MAX, =MIN, =COUNT formulas.",
      flashcards: [
        {
          titleHi: "वर्कबुक, वर्कशीट और सेल (Cell)",
          titleEn: "Workbook, Worksheet & Cell",
          bodyHi: "MS Excel फाइल को 'Workbook' (`.xlsx`) कहते हैं। रो (1, 2, 3...) और कॉलम (A, B, C...) के कटाव से बनने वाले बॉक्स को 'Cell' कहते हैं (जैसे `B3`)।",
          bodyEn: "An Excel file is a Workbook (`.xlsx`). The intersection of a Column (A, B, C...) and Row (1, 2, 3...) is called a Cell (e.g., `B3`).",
          tipHi: "परीक्षा टिप: सेल एड्रेस में पहले कॉलम का अक्षर और फिर रो की संख्या आती है (जैसे `A1`, न कि `1A`)।",
          tipEn: "Exam Tip: Cell addresses always start with the Column letter followed by Row number (`A1`, never `1A`)."
        },
        {
          titleHi: "एक्सेल फॉर्मूला का सुनहरा नियम (=)",
          titleEn: "Golden Rule of Excel Formulas (=)",
          bodyHi: "MS Excel में कोई भी फॉर्मूला हमेशा बराबर के चिह्न (`=`) से शुरू होता है! यदि आप `=` नहीं लगाएंगे, तो एक्सेल उसे साधारण टेक्स्ट मान लेगा।",
          bodyEn: "Every formula in MS Excel MUST start with an equals sign (`=`). Without `=`, Excel treats the entry as plain text.",
          tipHi: "परीक्षा टिप: यह बिहार बोर्ड और बेल्ट्रॉन/ICT परीक्षाओं का सबसे लोकप्रिय प्रश्न है!",
          tipEn: "Exam Tip: 'All Excel formulas begin with =' is the #1 most asked spreadsheet MCQ."
        },
        {
          titleHi: "प्रमुख एक्सेल फंक्शन (SUM, AVERAGE, MAX, MIN)",
          titleEn: "Essential Functions (SUM, AVERAGE, MAX, MIN)",
          bodyHi: "`=SUM(B2:B5)` → जोड़ने के लिए | `=AVERAGE(B2:B5)` → औसत निकालने के लिए | `=MAX(B2:B5)` → सबसे बड़ी संख्या | `=MIN(B2:B5)` → सबसे छोटी संख्या।",
          bodyEn: "`=SUM(B2:B5)` adds values | `=AVERAGE(B2:B5)` finds mean | `=MAX(B2:B5)` finds highest | `=MIN(B2:B5)` finds lowest.",
          tipHi: "परीक्षा टिप: `B2:B5` में बीच का चिह्न कोलन (`:`) एक सेल रेंज (Cell Range) को दर्शाता है।",
          tipEn: "Exam Tip: The colon (`:`) inside `B2:B5` represents a contiguous Cell Range."
        }
      ],
      questions: [
        {
          id: "ICT03_Q1",
          qHi: "MS Excel में कोई भी फॉर्मूला किस चिह्न (Symbol) से शुरू होता है?",
          qEn: "Every formula in MS Excel must begin with which symbol?",
          optionsHi: ["# (हैश)", "@ (एट)", "= (बराबर)", "+ (प्लस)"],
          optionsEn: ["#", "@", "= (Equals sign)", "+"],
          correct: 2,
          expHi: "एक्सेल में सभी फॉर्मूले बराबर (`=`) चिह्न से शुरू होते हैं, जैसे `=SUM(A1:A5)`।",
          expEn: "All Excel formulas start with `=`, such as `=SUM(A1:A5)`."
        },
        {
          id: "ICT03_Q2",
          qHi: "MS Excel में चौथे कॉलम (D) और पांचवीं रो (5) के कटाव से बनने वाले सेल का सही पता (Cell Address) क्या होगा?",
          qEn: "What is the valid cell address for the 4th column (D) and 5th row (5) in Excel?",
          optionsHi: ["5D", "D5", "D:5", "5:D"],
          optionsEn: ["5D", "D5", "D:5", "5:D"],
          correct: 1,
          expHi: "सेल एड्रेस में पहले कॉलम लेटर (`D`) और फिर रो नंबर (`5`) लिखा जाता है, अर्थात `D5`।",
          expEn: "Column letter comes first, followed by row number: `D5`."
        },
        {
          id: "ICT03_Q3",
          qHi: "सेल B2 से B6 तक के सभी अंकों को जोड़ने के लिए सही एक्सेल फॉर्मूला कौन-सा है?",
          qEn: "Which is the correct Excel formula to add all numbers from cell B2 to B6?",
          optionsHi: ["=ADD(B2:B6)", "=SUM(B2:B6)", "SUM(B2-B6)", "=TOTAL(B2:B6)"],
          optionsEn: ["=ADD(B2:B6)", "=SUM(B2:B6)", "SUM(B2-B6)", "=TOTAL(B2:B6)"],
          correct: 1,
          expHi: "एक्सेल में जोड़ने के लिए `ADD` या `TOTAL` नाम का फंक्शन नहीं होता, बल्कि `=SUM(B2:B6)` होता है।",
          expEn: "`=SUM(B2:B6)` adds all cells in the range B2 through B6."
        },
        {
          id: "ICT03_Q4",
          qHi: "किसी कक्षा में सबसे अधिक अंक (Highest Marks) पता करने के लिए किस फंक्शन का प्रयोग किया जाता है?",
          qEn: "Which Excel function returns the highest (maximum) value in a range of marks?",
          optionsHi: ["=HIGH(B2:B5)", "=TOP(B2:B5)", "=MAX(B2:B5)", "=LARGE(B2:B5)"],
          optionsEn: ["=HIGH(B2:B5)", "=TOP(B2:B5)", "=MAX(B2:B5)", "=LARGE(B2:B5)"],
          correct: 2,
          expHi: "`=MAX()` फंक्शन दी गई रेंज में से सबसे बड़ी संख्या लौटाता है।",
          expEn: "`=MAX()` returns the maximum numeric value in the selected range."
        },
        {
          id: "ICT03_Q5",
          qHi: "MS Excel में किसी सक्रिय सेल को एडिट (Edit) करने की शॉर्टकट कुंजी क्या है?",
          qEn: "Which shortcut key puts the active Excel cell into Edit mode?",
          optionsHi: ["F1", "F2", "F4", "F5"],
          optionsEn: ["F1", "F2", "F4", "F5"],
          correct: 1,
          expHi: "`F2` दबाने से चयनित सेल एडिट मोड में आ जाता है (साथ ही फाइल/फोल्डर का नाम बदलने के लिए भी F2 काम आता है)।",
          expEn: "Pressing `F2` edits the active cell in Excel."
        }
      ],
      shortcuts: [
        { keys: ["F2"], promptHi: "चयनित एक्सेल सेल को एडिट (Edit Cell) करने के लिए", promptEn: "Edit the active cell in MS Excel" },
        { keys: ["Alt", "="], promptHi: "तुरंत ऑटो-सम (AutoSum =SUM) लगाने के लिए", promptEn: "Insert AutoSum (=SUM) formula automatically" },
        { keys: ["Ctrl", ";"], promptHi: "सेल में आज की तारीख (Current Date) डालने के लिए", promptEn: "Insert today's date in the active cell" }
      ],
      excelTasks: [
        {
          id: "EX_TASK_1",
          titleHi: "चैलेंज 1: छात्र के कुल अंक (Total Marks) निकालें",
          titleEn: "Challenge 1: Calculate Total Marks Using =SUM",
          promptHi: "नीचे तालिका में B2 से B5 तक छात्र के 4 विषयों के अंक दिए गए हैं। कुल अंक निकालने के लिए सही फॉर्मूला लिखें:",
          promptEn: "Cells B2 to B5 contain marks in 4 subjects. Type the Excel formula to calculate the Total Marks:",
          expectedFormulas: ["=SUM(B2:B5)", "=B2+B3+B4+B5"],
          expectedValue: 320,
          hintHi: "संकेत: =SUM(B2:B5) लिखें",
          hintEn: "Hint: Type =SUM(B2:B5)"
        },
        {
          id: "EX_TASK_2",
          titleHi: "चैलेंज 2: औसत अंक (Average Marks) निकालें",
          titleEn: "Challenge 2: Calculate Average Marks Using =AVERAGE",
          promptHi: "अब B2 से B5 तक के अंकों का औसत (प्रतिशत) निकालने के लिए फॉर्मूला लिखें:",
          promptEn: "Write the formula to find the Average of cells B2 through B5:",
          expectedFormulas: ["=AVERAGE(B2:B5)"],
          expectedValue: 80,
          hintHi: "संकेत: =AVERAGE(B2:B5) लिखें",
          hintEn: "Hint: Type =AVERAGE(B2:B5)"
        },
        {
          id: "EX_TASK_3",
          titleHi: "चैलेंज 3: सर्वाधिक अंक (Highest Marks) खोजें",
          titleEn: "Challenge 3: Find Highest Marks Using =MAX",
          promptHi: "B2 से B5 में सबसे अधिक अंक (92) कौन-सा है, यह निकालने का फॉर्मूला लिखें:",
          promptEn: "Write the formula to find the highest mark in B2:B5:",
          expectedFormulas: ["=MAX(B2:B5)"],
          expectedValue: 92,
          hintHi: "संकेत: =MAX(B2:B5) लिखें",
          hintEn: "Hint: Type =MAX(B2:B5)"
        },
        {
          id: "EX_TASK_4",
          titleHi: "चैलेंज 4: कुल विषयों की गिनती (=COUNT)",
          titleEn: "Challenge 4: Count Number of Subjects Using =COUNT",
          promptHi: "B2 से B5 में कुल कितने विषयों में अंक दर्ज हैं, यह गिनने का फॉर्मूला लिखें:",
          promptEn: "Write the formula to count how many numeric cells exist in B2:B5:",
          expectedFormulas: ["=COUNT(B2:B5)"],
          expectedValue: 4,
          hintHi: "संकेत: =COUNT(B2:B5) लिखें",
          hintEn: "Hint: Type =COUNT(B2:B5)"
        }
      ]
    },

    {
      id: "ICT_04",
      category: "ICT",
      badgeId: "AI_EXPLORER",
      icon: "🤖",
      color: "#8b5cf6",
      titleHi: "अध्याय 4: आर्टिफिशियल इंटेलिजेंस (AI) और साइबर सुरक्षा",
      titleEn: "Ch 4: Artificial Intelligence (AI) & Cyber Safety",
      descHi: "AI के जनक, जनरेटिव AI, प्रॉम्प्ट इंजीनियरिंग और ऑनलाइन धोखाधड़ी (OTP/Phishing) से बचाव।",
      descEn: "Explore AI history, Generative AI, Prompt Engineering, and Cyber Hygiene (OTP & Phishing safety).",
      flashcards: [
        {
          titleHi: "आर्टिफिशियल इंटेलिजेंस (AI) क्या है?",
          titleEn: "What is Artificial Intelligence (AI)?",
          bodyHi: "मशीनों में इंसानों की तरह सोचने, सीखने और निर्णय लेने की क्षमता को AI कहते हैं। 'जॉन मैकार्थी' (John McCarthy) को AI का जनक माना जाता है।",
          bodyEn: "AI enables machines to learn, reason, and solve problems like humans. John McCarthy coined the term in 1956 and is the Father of AI.",
          tipHi: "परीक्षा टिप: AI के जनक — जॉन मैकार्थी (John McCarthy)।",
          tipEn: "Exam Tip: Father of Artificial Intelligence — John McCarthy."
        },
        {
          titleHi: "जनरेटिव AI और प्रॉम्प्ट (Prompt)",
          titleEn: "Generative AI & Prompts",
          bodyHi: "ChatGPT, Gemini आदि Generative AI हैं जो नया टेक्स्ट, कोड या चित्र बना सकते हैं। हम AI को जो निर्देश या प्रश्न लिखकर देते हैं उसे 'Prompt' कहते हैं।",
          bodyEn: "Tools like Gemini and ChatGPT are Generative AI models. The instruction or question you give to an AI is called a 'Prompt'.",
          tipHi: "प्रॉम्प्ट टिप: AI से सटीक उत्तर पाने के लिए हमेशा स्पष्ट संदर्भ और भाषा बताएं।",
          tipEn: "Prompt Tip: Clear, specific instructions produce the best AI responses."
        },
        {
          titleHi: "साइबर सुरक्षा और 1930 हेल्पलाइन",
          titleEn: "Cyber Safety & 1930 Helpline",
          bodyHi: "किसी भी अनजान व्यक्ति को अपना OTP, बैंक PIN या पासवर्ड कभी न बताएं। ऑनलाइन ठगी होने पर तुरंत राष्ट्रीय साइबर हेल्पलाइन नंबर `1930` पर कॉल करें।",
          bodyEn: "Never share your OTP, UPI PIN, or password with anyone. In case of cyber financial fraud in India, immediately dial helpline `1930`.",
          tipHi: "परीक्षा टिप: भारत का राष्ट्रीय साइबर क्राइम हेल्पलाइन नंबर `1930` है।",
          tipEn: "Exam Tip: India's National Cyber Crime Helpline number is `1930`."
        }
      ],
      questions: [
        {
          id: "ICT04_Q1",
          qHi: "आर्टिफिशियल इंटेलिजेंस (Artificial Intelligence) के जनक किसे कहा जाता है?",
          qEn: "Who is regarded as the 'Father of Artificial Intelligence'?",
          optionsHi: ["चार्ल्स बैबेज (Charles Babbage)", "जॉन मैकार्थी (John McCarthy)", "बिल गेट्स (Bill Gates)", "टिम बर्नर्स-ली (Tim Berners-Lee)"],
          optionsEn: ["Charles Babbage", "John McCarthy", "Bill Gates", "Tim Berners-Lee"],
          correct: 1,
          expHi: "जॉन मैकार्थी ने 1956 में 'Artificial Intelligence' शब्द दिया था, जबकि चार्ल्स बैबेज कंप्यूटर के जनक हैं।",
          expEn: "John McCarthy coined the term Artificial Intelligence in 1956."
        },
        {
          id: "ICT04_Q2",
          qHi: "किसी AI चैटबॉट (जैसे Gemini या ChatGPT) को दिए जाने वाले लिखित निर्देश या प्रश्न को क्या कहते हैं?",
          qEn: "What do we call the text instruction or query given to a Generative AI model?",
          optionsHi: ["Virus (वायरस)", "Prompt (प्रॉम्प्ट)", "Cookie (कुकी)", "Spam (स्पैम)"],
          optionsEn: ["Virus", "Prompt", "Cookie", "Spam"],
          correct: 1,
          expHi: "AI से काम कराने के लिए दिए गए निर्देश को 'Prompt' (प्रॉम्प्ट) कहा जाता है।",
          expEn: "An instruction given to a Generative AI model is called a Prompt."
        },
        {
          id: "ICT04_Q3",
          qHi: "नकली बैंक कॉल या फर्जी लिंक भेजकर पासवर्ड/OTP चुराने के साइबर अपराध को क्या कहते हैं?",
          qEn: "What is the cyber crime of tricking users into revealing passwords/OTPs via fake links or calls?",
          optionsHi: ["Debugging (डीबगिंग)", "Phishing (फ़िशिंग)", "Booting (बूटिंग)", "Formatting (फ़ॉर्मेटिंग)"],
          optionsEn: ["Debugging", "Phishing", "Booting", "Formatting"],
          correct: 1,
          expHi: "फर्जी ईमेल, SMS या कॉल के जरिए गोपनीय जानकारी चुराना Phishing (फ़िशिंग) कहलाता है।",
          expEn: "Phishing uses deceptive messages or websites to steal sensitive credentials."
        },
        {
          id: "ICT04_Q4",
          qHi: "भारत में ऑनलाइन वित्तीय धोखाधड़ी (Cyber Fraud) की शिकायत तुरंत किस टोल-फ्री नंबर पर की जाती है?",
          qEn: "Which national helpline number in India should you dial immediately in case of online financial fraud?",
          optionsHi: ["100", "1930", "139", "198"],
          optionsEn: ["100", "1930", "139", "198"],
          correct: 1,
          expHi: "`1930` भारत सरकार का राष्ट्रीय साइबर अपराध रिपोर्टिंग हेल्पलाइन नंबर है।",
          expEn: "`1930` is India's official National Cyber Crime Helpline number."
        },
        {
          id: "ICT04_Q5",
          qHi: "OTP का पूर्ण रूप (Full Form) क्या है?",
          qEn: "What is the full form of OTP?",
          optionsHi: ["One Time Password", "Only True Password", "Online Transfer Pin", "Open Text Protocol"],
          optionsEn: ["One Time Password", "Only True Password", "Online Transfer Pin", "Open Text Protocol"],
          correct: 0,
          expHi: "OTP का अर्थ 'One Time Password' है जो केवल एक बार के लेन-देन या लॉगिन के लिए मान्य होता है।",
          expEn: "OTP stands for One Time Password."
        }
      ],
      shortcuts: []
    },

    {
      id: "BSEB_SCI_01",
      category: "BSEB",
      badgeId: "OMR_CHAMPION",
      icon: "🔬",
      color: "#ec4899",
      titleHi: "बिहार बोर्ड स्कोर बूस्टर: विज्ञान एवं भौतिकी (BSEB High-Yield)",
      titleEn: "BSEB Score Booster: Science & Physics Top PYQs",
      descHi: "बिहार बोर्ड परीक्षा में बार-बार पूछे जाने वाले सबसे महत्वपूर्ण वस्तुनिष्ठ प्रश्न (OMR अभ्यास सहित)।",
      descEn: "Most repeated Bihar Board (BSEB) Science & Physics objective questions with OMR simulator practice.",
      flashcards: [
        {
          titleHi: "प्रकाश का परावर्तन एवं अपवर्तन",
          titleEn: "Reflection & Refraction of Light",
          bodyHi: "प्रकाश के परावर्तन और अपवर्तन दोनों के 2-2 नियम हैं। निर्वात में प्रकाश की चाल $3 \\times 10^8\\text{ m/s}$ होती है। समतल दर्पण की फोकस दूरी अनंत ($\\infty$) होती है।",
          bodyEn: "Both reflection and refraction have 2 laws. Speed of light in vacuum is $3 \\times 10^8\\text{ m/s}$. Focal length of a plane mirror is infinity ($\\infty$).",
          tipHi: "BSEB सुपर हिट: दाढ़ी बनाने (हजामत) में अवतल दर्पण और वाहनों के साइड मिरर में उत्तल दर्पण का प्रयोग होता है।",
          tipEn: "BSEB Favorite: Concave mirror is used for shaving; Convex mirror is used as a vehicle rear-view mirror."
        },
        {
          titleHi: "विद्युत धारा और मात्रक (SI Units)",
          titleEn: "Electric Current & SI Units",
          bodyHi: "विद्युत धारा का मात्रक = एम्पियर (A) | विभवांतर = वोल्ट (V) | प्रतिरोध = ओम ($\\Omega$) | शक्ति = वाट (W) | आवेश = कूलॉम (C)।",
          bodyEn: "Electric Current = Ampere (A) | Potential Difference = Volt (V) | Resistance = Ohm ($\\Omega$) | Power = Watt (W) | Charge = Coulomb (C).",
          tipHi: "BSEB सुपर हिट: 1 किलोवाट घंटा (1 kWh / 1 Unit) = $3.6 \\times 10^6\\text{ Joule}$ होता है।",
          tipEn: "BSEB Favorite: 1 kWh (commercial unit of energy) = $3.6 \\times 10^6\\text{ Joules}$."
        }
      ],
      questions: [
        {
          id: "BSEBSCI_Q1",
          qHi: "प्रकाश के परावर्तन के कितने नियम हैं? (BSEB बार-बार पूछा गया प्रश्न)",
          qEn: "How many laws of reflection of light are there?",
          optionsHi: ["1", "2", "3", "4"],
          optionsEn: ["1", "2", "3", "4"],
          correct: 1,
          expHi: "प्रकाश के परावर्तन के 2 नियम हैं (आपतन कोण = परावर्तन कोण, तथा तीनों किरणें एक ही तल में होती हैं)।",
          expEn: "There are 2 laws of reflection of light."
        },
        {
          id: "BSEBSCI_Q2",
          qHi: "वाहनों के साइड मिरर (पीछे देखने के दर्पण) के रूप में किस दर्पण का उपयोग किया जाता है?",
          qEn: "Which mirror is used as a rear-view (side) mirror in vehicles?",
          optionsHi: ["अवतल दर्पण (Concave Mirror)", "उत्तल दर्पण (Convex Mirror)", "समतल दर्पण (Plane Mirror)", "बेलनाकार दर्पण"],
          optionsEn: ["Concave Mirror", "Convex Mirror", "Plane Mirror", "Cylindrical Mirror"],
          correct: 1,
          expHi: "उत्तल दर्पण हमेशा सीधा और छोटा प्रतिबिंब बनाता है तथा इसका दृष्टि क्षेत्र (Field of View) बड़ा होता है।",
          expEn: "Convex mirrors provide an erect, diminished image with a wide field of view."
        },
        {
          id: "BSEBSCI_Q3",
          qHi: "विद्युत प्रतिरोध (Electrical Resistance) का SI मात्रक क्या है?",
          qEn: "What is the SI unit of Electrical Resistance?",
          optionsHi: ["एम्पियर (Ampere)", "वोल्ट (Volt)", "ओम (Ohm - Ω)", "वाट (Watt)"],
          optionsEn: ["Ampere", "Volt", "Ohm (Ω)", "Watt"],
          correct: 2,
          expHi: "प्रतिरोध का SI मात्रक ओम ($\\Omega$) है। ओम के नियम के अनुसार $R = V / I$ होता है।",
          expEn: "The SI unit of electrical resistance is Ohm (Ω)."
        },
        {
          id: "BSEBSCI_Q4",
          qHi: "स्पष्ट दर्शन की न्यूनतम दूरी (Least Distance of Distinct Vision) कितनी होती है?",
          qEn: "What is the least distance of distinct vision for a normal human eye?",
          optionsHi: ["25 मीटर", "2.5 सेमी", "25 सेमी", "अनंत (Infinity)"],
          optionsEn: ["25 m", "2.5 cm", "25 cm", "Infinity"],
          correct: 2,
          expHi: "सामान्य मानव नेत्र के लिए स्पष्ट दर्शन की न्यूनतम दूरी 25 सेमी (25 cm) होती है।",
          expEn: "For a normal human eye, the near point is at 25 cm."
        },
        {
          id: "BSEBSCI_Q5",
          qHi: "शुद्ध जल का pH मान कितना होता है?",
          qEn: "What is the pH value of pure water?",
          optionsHi: ["0", "5.5", "7", "14"],
          optionsEn: ["0", "5.5", "7", "14"],
          correct: 2,
          expHi: "शुद्ध जल उदासीन (Neutral) होता है, इसलिए इसका pH मान 7 होता है।",
          expEn: "Pure water is neutral with a pH of 7."
        },
        {
          id: "BSEBSCI_Q6",
          qHi: "कोशिका का पावरहाउस (Powerhouse of the Cell) किसे कहा जाता है?",
          qEn: "Which cell organelle is known as the 'Powerhouse of the Cell'?",
          optionsHi: ["राइबोसोम (Ribosome)", "माइटोकॉन्ड्रिया (Mitochondria)", "लाइसोसोम (Lysosome)", "केंद्रक (Nucleus)"],
          optionsEn: ["Ribosome", "Mitochondria", "Lysosome", "Nucleus"],
          correct: 1,
          expHi: "माइटोकॉन्ड्रिया में ATP के रूप में ऊर्जा का निर्माण होता है, इसलिए इसे कोशिका का ऊर्जा गृह कहते हैं।",
          expEn: "Mitochondria generate ATP energy and are called the powerhouse of the cell."
        }
      ],
      shortcuts: []
    },

    {
      id: "BSEB_GK_01",
      category: "BSEB",
      badgeId: "BSEB_STAR",
      icon: "🏛️",
      color: "#f59e0b",
      titleHi: "बिहार बोर्ड स्कोर बूस्टर: इतिहास, संविधान एवं हिन्दी व्याकरण",
      titleEn: "BSEB Score Booster: History, Polity & Hindi Grammar",
      descHi: "चंपारण सत्याग्रह, भारतीय संविधान और हिन्दी व्याकरण के सबसे महत्वपूर्ण बोर्ड परीक्षा प्रश्न।",
      descEn: "High-scoring Bihar Board questions covering Champaran Satyagraha, Indian Constitution, and Hindi Grammar.",
      flashcards: [
        {
          titleHi: "चंपारण सत्याग्रह (1917) एवं बिहार गौरव",
          titleEn: "Champaran Satyagraha (1917) & Bihar History",
          bodyHi: "महात्मा गांधी ने भारत में अपना पहला सत्याग्रह 1917 में बिहार के चंपारण से 'तिनकठिया प्रणाली' (नील की खेती) के विरुद्ध शुरू किया था। राजकुमार शुक्ल ने उन्हें आमंत्रित किया था।",
          bodyEn: "Mahatma Gandhi launched his first Satyagraha in India at Champaran, Bihar in 1917 against the Tinkathia indigo system, invited by Rajkumar Shukla.",
          tipHi: "BSEB सुपर हिट: चंपारण सत्याग्रह — 1917 ई.।",
          tipEn: "BSEB Favorite: Champaran Satyagraha took place in 1917."
        },
        {
          titleHi: "भारतीय संविधान के प्रमुख तथ्य",
          titleEn: "Key Facts of the Indian Constitution",
          bodyHi: "प्रारूप समिति के अध्यक्ष: डॉ. भीमराव अंबेडकर | संविधान सभा के स्थायी अध्यक्ष: डॉ. राजेंद्र प्रसाद | लागू होने की तिथि: 26 जनवरी 1950।",
          bodyEn: "Chairman of Drafting Committee: Dr. B.R. Ambedkar | Permanent President of Constituent Assembly: Dr. Rajendra Prasad | Enforced: 26 Jan 1950.",
          tipHi: "परीक्षा टिप: संविधान बनने में 2 वर्ष 11 माह 18 दिन का समय लगा था।",
          tipEn: "Exam Tip: The Constitution took 2 years, 11 months, and 18 days to draft."
        }
      ],
      questions: [
        {
          id: "BSEBGK_Q1",
          qHi: "महात्मा गांधी ने भारत में सत्याग्रह का पहला प्रयोग कहाँ किया था?",
          qEn: "Where did Mahatma Gandhi launch his first Satyagraha movement in India?",
          optionsHi: ["दांडी (Dandi)", "चंपारण (Champaran)", "खेड़ा (Kheda)", "अहमदाबाद (Ahmadabad)"],
          optionsEn: ["Dandi", "Champaran (Bihar)", "Kheda", "Ahmedabad"],
          correct: 1,
          expHi: "1917 में बिहार के चंपारण में नील किसानों के समर्थन में गांधीजी ने पहला सत्याग्रह किया।",
          expEn: "Gandhiji led his first Indian Satyagraha in Champaran, Bihar in 1917."
        },
        {
          id: "BSEBGK_Q2",
          qHi: "भारतीय संविधान की प्रारूप समिति (Drafting Committee) के अध्यक्ष कौन थे?",
          qEn: "Who was the Chairman of the Drafting Committee of the Indian Constitution?",
          optionsHi: ["डॉ. राजेंद्र प्रसाद", "डॉ. भीमराव अंबेडकर", "पंडित जवाहरलाल नेहरू", "सरदार वल्लभभाई पटेल"],
          optionsEn: ["Dr. Rajendra Prasad", "Dr. B.R. Ambedkar", "Pt. Jawaharlal Nehru", "Sardar Vallabhbhai Patel"],
          correct: 1,
          expHi: "डॉ. भीमराव अंबेडकर प्रारूप समिति के अध्यक्ष थे और उन्हें संविधान का जनक कहा जाता है।",
          expEn: "Dr. B.R. Ambedkar chaired the Drafting Committee of the Constituent Assembly."
        },
        {
          id: "BSEBGK_Q3",
          qHi: "हिन्दी व्याकरण में 'संधि' के मुख्य कितने भेद होते हैं?",
          qEn: "How many main types of 'Sandhi' are there in Hindi grammar?",
          optionsHi: ["2", "3", "4", "5"],
          optionsEn: ["2", "3 (Swar, Vyanjan, Visarga)", "4", "5"],
          correct: 1,
          expHi: "संधि के 3 भेद होते हैं: स्वर संधि, व्यंजन संधि और विसर्ग संधि।",
          expEn: "There are 3 types of Sandhi: Swar, Vyanjan, and Visarga Sandhi."
        },
        {
          id: "BSEBGK_Q4",
          qHi: "'विद्यालय' शब्द का सही संधि-विच्छेद क्या है?",
          qEn: "What is the correct Sandhi-Viched of 'विद्यालय' (Vidyalaya)?",
          optionsHi: ["विद्या + लय", "विद्य + आलय", "विद्या + आलय", "वि + द्यालय"],
          optionsEn: ["Vidya + Laya", "Vidya + Alaya (विद्या + आलय)", "Vid + Alaya", "Vi + Dyalaya"],
          correct: 2,
          expHi: "'विद्या + आलय = विद्यालय' (दीर्घ स्वर संधि: आ + आ = आ)।",
          expEn: "विद्या + आलय = विद्यालय (Dirgha Swar Sandhi)."
        },
        {
          id: "BSEBGK_Q5",
          qHi: "भारत में मतदाता होने की न्यूनतम आयु क्या है?",
          qEn: "What is the minimum voting age in India?",
          optionsHi: ["16 वर्ष", "18 वर्ष", "21 वर्ष", "25 वर्ष"],
          optionsEn: ["16 Years", "18 Years", "21 Years", "25 Years"],
          correct: 1,
          expHi: "61वें संविधान संशोधन द्वारा मतदान की न्यूनतम आयु 21 वर्ष से घटाकर 18 वर्ष कर दी गई।",
          expEn: "The minimum voting age in India is 18 years."
        }
      ],
      shortcuts: []
    }
  ]
};
