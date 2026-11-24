-- =============================================================================
-- Students of Bihar (9-12) — BSEB Class 9–12 English Textbooks Master Seed
-- Covers 14 High-Weightage Chapters across Panorama Part-1 & 2 and Rainbow Part-1 & 2:
--   Class 10 (Panorama Part-2 — bseb-10-eng): 5 Chapters (Ch 1–5)
--   Class 12 (Rainbow Part-2  — bseb-12-lang1-eng, aliased to lang2): 5 Chapters (Ch 1–5)
--   Class 9  (Panorama Part-1 — bseb-9-eng): 2 Starter Chapters (Ch 1–2)
--   Class 11 (Rainbow Part-1  — bseb-11-lang1-eng, aliased to lang2): 2 Starter Chapters (Ch 1–2)
--
-- Features per chapter:
--   * Hindi-first Visual Storyboard & Stanza Breakdown + Validated Diagrams
--   * Word-by-word English Decoding + Devanagari Pronunciation Guides
--   * 30-Second Mind Map + Board Capsule with 5-Mark Summary Formula
--   * Teacher-Only 2-Period (40-min) Lesson Plan with Oral Confidence Drills
--   * 14 Multi-Mode Questions (Flashcards, Match Pairs, Sentence Builders,
--     Foundation/Board/Topper Practice MCQs, Unseen EXAM_ONLY MCQs, 2M & 5M)
--
-- 100% Idempotent (ON CONFLICT DO UPDATE) · Deterministic UUID Namespace 10000007-*
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CHAPTERS CATALOG UPSERT (14 BSEB ENGLISH TEXTBOOK CHAPTERS)
-- -----------------------------------------------------------------------------

INSERT INTO public.chapters (
  id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published
) VALUES
  ('bseb-10-eng-ch1', 'bseb-10-eng', 1, 'The Pace for Living — R.C. Hutchinson', 'आधुनिक जीवन की गति (The Pace for Living) — आर.सी. हचिंसन', 'R.C. Hutchinson''s witty essay exploring the anxiety of fast-paced modern life through an elderly Dublin corn-merchant and the struggles of "slow thinkers" in today''s world.', 'आर.सी. हचिंसन का रोचक निबंध, जो डबलिन के एक वृद्ध अनाज-व्यापारी और "धीमे सोचने वालों (slow thinkers)" के माध्यम से आधुनिक तेज़ रफ़्तार जीवन की बेचैनी को उजागर करता है।', 8, 15, true),
  ('bseb-10-eng-ch2', 'bseb-10-eng', 2, 'Me and the Ecology Bit — Joan Lexau', 'मैं और पारिस्थितिकी (Me and the Ecology Bit) — जोन लेक्साऊ', 'Joan Lexau''s humorous story about young Jim, who preaches ecology along his paper route only to discover that everyone—including himself—finds it easier to preach than to practise.', 'जोन लेक्साऊ की व्यंग्यात्मक कहानी, जिसमें अख़बार बाँटने वाला लड़का जिम सबको पर्यावरण (इकोलॉजी) का उपदेश देता है, पर पाता है कि उपदेश देना आसान और खुद पालन करना कठिन है।', 7, 15, true),
  ('bseb-10-eng-ch3', 'bseb-10-eng', 3, 'Gillu — Mahadevi Varma', 'गिल्लू (Gillu) — महादेवी वर्मा', 'Mahadevi Varma''s deeply touching true story of a tiny baby squirrel rescued from two crows, his playful love for kaju and the narrator, and his burial beneath the yellow Sonjuhi creeper.', 'महादेवी वर्मा का अत्यंत मार्मिक संस्मरण, जिसमें दो कौओं से बचाए गए नन्हे गिलहरी के बच्चे "गिल्लू", उसके प्रिय काजू, आत्मीय स्नेह और सोनजुही की लता के नीचे समाधि का सजीव वर्णन है।', 8, 15, true),
  ('bseb-10-eng-ch4', 'bseb-10-eng', 4, 'God Made the Country (Poem) — William Cowper', 'ईश्वर ने गाँव बनाया (God Made the Country — कविता) — विलियम कूपर', 'William Cowper''s classic 18th-century poem contrasting the pure health, virtue, moonlight, and birdsong of God-made villages with the artificial glare and noise of man-made towns.', '18वीं शताब्दी के अंग्रेज़ी कवि विलियम कूपर की प्रसिद्ध कविता, जो ईश्वर द्वारा बनाए गए शुद्ध, शांत व स्वस्थ गाँव की तुलना मनुष्य द्वारा बनाए गए शोरगुल भरे बनावटी शहर से करती है।', 7, 15, true),
  ('bseb-10-eng-ch5', 'bseb-10-eng', 5, 'The Sleeping Porter (Poem) — Laxmi Prasad Devkota', 'सोया हुआ कुली (The Sleeping Porter — कविता) — लक्ष्मी प्रसाद देवकोटा', 'Nepali Mahakavi Laxmi Prasad Devkota''s deeply empathetic poem portraying a frail mountain porter carrying a 25-kilo load six miles uphill in winter snow, finally reigning like a king over the "rich kingdom of sleep".', 'नेपाल के महाकवि लक्ष्मी प्रसाद देवकोटा की मर्मस्पर्शी कविता, जिसमें सर्दी की बर्फ़ में 25 किलो बोझ ढोकर 6 मील पहाड़ चढ़ने वाला निर्धन कुली अंततः "नींद के समृद्ध साम्राज्य" का सम्राट बन जाता है।', 7, 15, true),
  ('bseb-12-eng-ch1', 'bseb-12-lang1-eng', 1, 'Indian Civilization and Culture — Mahatma Gandhi', 'भारतीय सभ्यता और संस्कृति (Indian Civilization and Culture) — महात्मा गांधी', 'Mahatma Gandhi''s landmark essay contrasting India''s enduring moral civilization of "plain living and high thinking" with modern Western materialism.', 'महात्मा गांधी का प्रसिद्ध निबंध, जो नैतिकता व "सादा जीवन, उच्च विचार" पर आधारित अटल भारतीय सभ्यता की तुलना आधुनिक पश्चिमी भौतिकवाद से करता है।', 10, 18, true),
  ('bseb-12-eng-ch2', 'bseb-12-lang1-eng', 2, 'Bharat is My Home — Dr. Zakir Husain', 'भारत मेरा घर है (Bharat is My Home) — डॉ. ज़ाकिर हुसैन', 'An extract from Dr. Zakir Husain''s historic 1967 Presidential oath speech declaring all of India his home and family, praising Dr. Radhakrishnan, and calling education the prime instrument of national purpose.', 'डॉ. ज़ाकिर हुसैन के 1967 के ऐतिहासिक राष्ट्रपति शपथ-भाषण का अंश, जिसमें वे संपूर्ण भारत को अपना घर व जनता को परिवार घोषित करते हैं और शिक्षा को राष्ट्र-निर्माण का प्रमुख साधन बताते हैं।', 10, 18, true),
  ('bseb-12-eng-ch3', 'bseb-12-lang1-eng', 3, 'A Pinch of Snuff — Manohar Malgonkar', 'एक चुटकी सुँघनी (A Pinch of Snuff) — मनोहर मालगाँवकर', 'Manohar Malgonkar''s hilarious comic story about the narrator''s super-clever maternal uncle Nanukaka, who uses wit, a pinch of snuff, a dhobi cheque stunt, and an astrologer disguise to make a Delhi Minister rush to his doorstep.', 'मनोहर मालगाँवकर की अत्यंत हास्यपूर्ण कहानी, जिसमें कथावाचक के चतुर मामा नानूकाका एक चुटकी सुँघनी, धोबी के ₹1,000 चेक वाले नाटक और "निन्नौर के राज-ज्योतिषी" के भेष से दिल्ली के मंत्री को खुद घर बुला लेते हैं।', 10, 18, true),
  ('bseb-12-eng-ch4', 'bseb-12-lang1-eng', 4, 'Sweetest Love, I Do Not Goe (Poem) — John Donne', 'प्रियतमा, मैं इसलिए नहीं जाता (Sweetest Love, I Do Not Goe — कविता) — जॉन डन', 'John Donne''s famous Metaphysical love lyric comforting his wife Anne More before his European journey, proving through the sun conceit that true lovers are never truly parted.', 'मेटाफ़िज़िकल कविता के जनक जॉन डन की प्रसिद्ध प्रेम-कविता, जिसमें वे यूरोप यात्रा पर जाते समय अपनी पत्नी ऐन मोर को सूर्य के उदाहरण से ढांढस बँधाते हैं कि सच्चे प्रेमी कभी अलग नहीं होते।', 10, 18, true),
  ('bseb-12-eng-ch5', 'bseb-12-lang1-eng', 5, 'An Epitaph (Poem) — Walter de la Mare', 'एक समाधि-लेख (An Epitaph — कविता) — वाल्टर डी ला मेयर', 'Walter de la Mare''s poignant seven-line poem mourning a most beautiful lady of the West Country, reflecting on how physical beauty inevitably vanishes and fades from memory.', 'वाल्टर डी ला मेयर की मार्मिक लघु कविता, जो "वेस्ट कंट्री" की सबसे सुंदर स्त्री की कब्र के पास खड़े होकर यह गहरा सत्य बताती है कि बाहरी सौंदर्य नश्वर है और समय के साथ मिट जाता है।', 8, 15, true),
  ('bseb-9-eng-ch1', 'bseb-9-eng', 1, 'Dharam Juddha — Arjun Dev Charan', 'धर्म युद्ध (Dharam Juddha) — अर्जुन देव चारण', 'A thought-provoking one-act play by Arjun Dev Charan where young Padma questions traditional attitudes toward women, marriage, and independent identity.', 'अर्जुन देव चारण का विचारोत्तेजक एकांकी नाटक, जिसमें शिक्षित बालिका पद्मा समाज और माता-पिता से नारी की स्वतंत्र पहचान व अधिकारों पर साहसिक प्रश्न करती है।', 8, 15, true),
  ('bseb-9-eng-ch2', 'bseb-9-eng', 2, 'Yayati — C. Rajagopalachari', 'ययाति (Yayati) — सी. राजगोपालाचारी', 'A timeless Mahabharata tale retold by C. Rajagopalachari teaching that sensual desire is never quenched by indulgence, just as fire grows brighter when fed with ghee.', 'सी. राजगोपालाचारी द्वारा महाभारत से अनूदित कालजयी कथा, जो सिखाती है कि भोग-विलास से इच्छाएँ कभी शांत नहीं होतीं — जैसे घी डालने से आग और भड़कती है।', 8, 15, true),
  ('bseb-11-eng-ch1', 'bseb-11-lang1-eng', 1, 'Animals in Prison — Jawaharlal Nehru', 'जेल में पशु-पक्षी (Animals in Prison) — जवाहरलाल नेहरू', 'An autobiographical essay from Jawaharlal Nehru''s "An Autobiography" recalling his 14½ months in Dehra Dun Gaol and his warm, keen bond with birds, insects, squirrels, and nature.', 'जवाहरलाल नेहरू की आत्मकथा (An Autobiography) का संवेदनशील अंश, जिसमें वे देहरादून जेल के साढ़े चौदह महीनों के दौरान छोटे जीव-जंतुओं व प्रकृति के साथ अपने आत्मीय लगाव को दर्शाते हैं।', 10, 18, true),
  ('bseb-11-eng-ch2', 'bseb-11-lang1-eng', 2, 'Nalanda: Ancient Seat of Learning — Dr. Rajendra Prasad', 'नालंदा: प्राचीन शिक्षा केंद्र (Nalanda: Ancient Seat of Learning) — डॉ. राजेंद्र प्रसाद', 'A historic speech delivered by Bihar''s own Dr. Rajendra Prasad on 20 November 1951 celebrating ancient Nalanda University, its global scholars, libraries, and moral vision of education.', 'बिहार के गौरव और भारत के प्रथम राष्ट्रपति डॉ. राजेंद्र प्रसाद द्वारा 20 नवंबर 1951 को दिया गया ऐतिहासिक भाषण, जो प्राचीन नालंदा विश्वविद्यालय की वैश्विक महिमा, पुस्तकालयों और शिक्षा-दर्शन को जीवंत करता है।', 10, 18, true)
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
-- CHAPTER 1 OF 14: BSEB-10-ENG-CH1 — The Pace for Living — R.C. Hutchinson
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-10-eng-ch1',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: आधुनिक जीवन की गति (The Pace for Living)",
  "title_en": "30-Second Mindmap: The Pace for Living",
  "read_time_seconds": 30,
  "central_node": {
    "id": "pfl-root",
    "label_hi": "The Pace for Living",
    "label_en": "The Pace for Living (Essay)",
    "subtitle_hi": "R.C. Hutchinson · Panorama Part-2 (कक्षा 10, अध्याय 1)",
    "subtitle_en": "R.C. Hutchinson · Panorama Part-2 (Class 10, Ch 1)"
  },
  "branches": [
    {
      "id": "pfl-author",
      "label_hi": "1. लेखक परिचय (Author)",
      "label_en": "1. About the Author",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "pfl-a1",
          "label_hi": "आर.सी. हचिंसन (1907–1975) — ब्रिटिश उपन्यासकार",
          "label_en": "R.C. Hutchinson (1907–1975) — British Novelist",
          "detail_hi": "आधुनिक मनुष्य की मानसिक पीड़ा (agony of modern man) को बड़ी सहजता से चित्रित करते हैं।",
          "detail_en": "Captures the hidden mental agony of modern human life with warmth and wit."
        }
      ]
    },
    {
      "id": "pfl-play",
      "label_hi": "2. डबलिन का नाटक व अनाज-व्यापारी",
      "label_en": "2. The Dublin Play & Corn-Merchant",
      "color": "#059669",
      "children": [
        {
          "id": "pfl-p1",
          "label_hi": "स्थान: डबलिन (Dublin) — छोटे आयरिश कस्बे का नाटक",
          "label_en": "Place: A play in Dublin set in a small Irish town"
        },
        {
          "id": "pfl-p2",
          "label_hi": "मुख्य पात्र: चिंताओं से घिरा वृद्ध अनाज-व्यापारी (Corn-merchant)",
          "label_en": "Chief character: Elderly corn-merchant full of anxieties"
        },
        {
          "id": "pfl-p3",
          "label_hi": "परेशानी: धोखेबाज़ भतीजा + छुट्टी पर £10 खर्च करने वाली पत्नी",
          "label_en": "Troubles: Cheating nephew + wife spending £10 on a holiday"
        }
      ]
    },
    {
      "id": "pfl-slow",
      "label_hi": "3. लेखक और \"धीमे सोचने वाले\" (Slow Thinkers)",
      "label_en": "3. Author & The Tribe of Slow Thinkers",
      "color": "#D97706",
      "children": [
        {
          "id": "pfl-s1",
          "label_hi": "यात्रा की गति पसंद: 90 मील/घंटा कार चलाना अच्छा लगता है!",
          "label_en": "Loves travel speed: enjoys driving at 90 miles an hour!"
        },
        {
          "id": "pfl-s2",
          "label_hi": "सिनेमा में उलझन: 3 लड़कियों (A, B, C) को पहचानने में पत्नी की मदद",
          "label_en": "Cinema fog: asks wife to label the 3 girls as A, B, and C"
        },
        {
          "id": "pfl-s3",
          "label_hi": "बुद्धि परीक्षाएँ (Intelligence Tests): केवल सोचने की गति मापती हैं!",
          "label_en": "Intelligence tests measure mental speed, handicapping slow thinkers"
        }
      ]
    },
    {
      "id": "pfl-exam",
      "label_hi": "4. मुख्य संदेश और बोर्ड फोकस",
      "label_en": "4. Central Message & Board Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "pfl-e1",
          "label_hi": "मशीनों की गति ठीक है, पर इंसान के दिमाग़ को शांत सोचने का समय चाहिए।",
          "label_en": "Machine speed is fine, but human minds need unhurried reflection."
        },
        {
          "id": "pfl-e2",
          "label_hi": "पक्के MCQ: Dublin, Corn-merchant, 90 mph, 1,000 mph, Slow thinkers।",
          "label_en": "Guaranteed MCQs: Dublin, Corn-merchant, 90 mph, 1,000 mph, Slow thinkers."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "pfl-sec-1-author",
    "order": 1,
    "heading_hi": "1. लेखक परिचय और बिहार के छात्र से सीधा जुड़ाव",
    "heading_en": "1. Author Profile & Everyday Bihar Connection",
    "analogy_hi": "सोचिए आप किसी परीक्षा हॉल में बैठे हैं — आपको उत्तर आता है, पर घड़ी की सुई तेज़ी से भाग रही है और बगल वाला छात्र फटाफट लिख रहा है! या ट्रेन पकड़ने की भागदौड़ में दिमाग़ चकराने लगता है! **आर.सी. हचिंसन** कहते हैं कि आज की दुनिया में मशीनों की रफ़्तार इतनी बढ़ गई है कि शांत और **धीमे सोचने वाले (Slow Thinkers)** इंसान बेचैन हो जाते हैं।",
    "analogy_en": "Ever known the right answer in an exam hall yet panicked because the clock ticks too fast? **R.C. Hutchinson** sympathetically shows how today's hyper-fast world puts constant pressure on thoughtful **\"slow thinkers\"**.",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "आर.सी. हचिंसन और \"The Pace for Living\" की झलक",
      "title_en": "R.C. Hutchinson & Highlights of \"The Pace for Living\"",
      "events": [
        {
          "year": "1907",
          "title_hi": "जन्म — इंग्लैंड (ब्रिटिश उपन्यासकार)",
          "title_en": "Born — England (British Novelist)",
          "detail_hi": "रे कॉरिटन हचिंसन (1907–1975); ऑक्सफोर्ड से शिक्षा प्राप्त प्रसिद्ध लेखक।",
          "detail_en": "Ray Coryton Hutchinson (1907–1975); Oxford-educated acclaimed British novelist."
        },
        {
          "year": "Dublin Play",
          "title_hi": "डबलिन में नाटक देखना (प्रेरणा बिंदु)",
          "title_en": "Watching a Play in Dublin",
          "detail_hi": "वृद्ध आयरिश अनाज-व्यापारी की लाचारी देखकर आधुनिक जीवन की रफ़्तार पर विचार आया।",
          "detail_en": "Sympathized deeply with an elderly Irish corn-merchant overwhelmed by rapid change.",
          "highlight": true
        },
        {
          "year": "BSEB Ch 1",
          "title_hi": "Panorama Part-2 का पहला प्रमुख निबंध",
          "title_en": "Opening Essay of Panorama Part-2",
          "detail_hi": "तेज़ यात्रा बनाम धीमी मानसिक गति का रोचक व व्यंग्यात्मक विश्लेषण।",
          "detail_en": "Humorous yet sharp contrast between physical speed and slow thinking.",
          "highlight": true
        }
      ]
    },
    "concept_md_hi": "### निबंध की शुरुआत — डबलिन का नाटक\n- लेखक ने **डबलिन (Dublin)** शहर में एक नाटक देखा। उस नाटक का मुख्य पात्र आयरलैंड के छोटे कस्बे का एक **वृद्ध अनाज-व्यापारी (elderly corn-merchant)** था।\n- व्यापारी चारों ओर से चिंताओं में घिरा था: उसका **दिल कमज़ोर** था, उसका **भतीजा (nephew)** उसे धोखा दे रहा था, और उसकी **पत्नी (wife)** को छुट्टी पर **10 पाउंड (£10)** खर्च करने का अजीब शौक था।\n- जब उसने सुना कि अब एक हवाई जहाज़ **1,000 मील प्रति घंटे** की रफ़्तार से उड़ता है, तो वह तड़पकर बोल उठा — **\"अब यह बहुत ज़्यादा तेज़ है (Now that's too fast)!\"**",
    "concept_md_en": "### Opening Scene — The Play in Dublin\n- The author watched a play in **Dublin** centred on an **elderly corn-merchant** in a small Irish country town.\n- The merchant was a man of many anxieties: his heart was weak, his **nephew** was cheating him, and his **wife** had the fantastic notion of spending **£10 on a holiday**.\n- Hearing about an aeroplane flying at **1,000 miles an hour**, he cried out in despair: **\"Now that's too fast!\"**",
    "exam_tip_hi": "BSEB मैट्रिक के 3 पक्के MCQ: नाटक कहाँ देखा? → **Dublin** · मुख्य पात्र? → **Corn-merchant** · पत्नी का खर्च? → **£10 on a holiday**!",
    "exam_tip_en": "3 Guaranteed Matric MCQs: Play city = **Dublin** · Chief character = **Corn-merchant** · Wife's holiday whim = **£10**!",
    "glossary_terms": [
      {
        "term_hi": "Pace (पेस)",
        "term_en": "Pace",
        "pronunciation_hi": "पेस",
        "definition_hi": "रफ़्तार या जीवन के चलने की गति।",
        "definition_en": "Speed or rate of movement in life."
      },
      {
        "term_hi": "Agony (ऐगनी)",
        "term_en": "Agony",
        "pronunciation_hi": "ऐगनी",
        "definition_hi": "गहरी मानसिक या शारीरिक पीड़ा व बेचैनी।",
        "definition_en": "Extreme mental or physical suffering and distress."
      }
    ]
  },
  {
    "id": "pfl-sec-2-storyboard",
    "order": 2,
    "heading_hi": "2. हिंदी-प्रथम विज़ुअल स्टोरीबोर्ड: तेज़ रफ़्तार बनाम धीमे विचारक",
    "heading_en": "2. Visual Storyboard: Rapid Movement vs Slow Thinkers",
    "analogy_hi": "ध्यान दीजिए — लेखक कार या हवाई जहाज़ की तेज़ रफ़्तार से **नफ़रत नहीं** करते! उन्हें तो 90 मील/घंटे से कार चलाना मज़ेदार लगता है। असली समस्या तब आती है जब **सिनेमा** और **नौकरी की परीक्षाएँ** दिमाग़ से भी मशीन की तरह तेज़ भागने को कहती हैं!",
    "analogy_en": "Notice the clever twist: Hutchinson actually **enjoys** physical speed (driving at 90 mph!), but hates when **cinema** and **intelligence tests** force slow thinkers to think like machines!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "The Pace for Living — 4 मुख्य विचार-पड़ाव",
      "title_en": "The Pace for Living — 4 Key Stages of the Essay",
      "direction": "TB",
      "steps": [
        {
          "id": "pfl-st1",
          "label_hi": "1. अनाज-व्यापारी की पीड़ा (1,000 मील/घंटा)",
          "label_en": "1. The Corn-Merchant's Cry (1,000 mph)",
          "detail_hi": "कमज़ोर दिल, धोखेबाज़ भतीजा, खर्चीली पत्नी — आधुनिक रफ़्तार उसे कुचल रही है।",
          "detail_en": "Overwhelmed by anxieties, he cries that 1,000 mph planes are \"too fast\".",
          "accent": "amber"
        },
        {
          "id": "pfl-st2",
          "label_hi": "2. लेखक को तेज़ सफ़र पसंद है (90 मील/घंटा)",
          "label_en": "2. Author Enjoys Fast Travel (90 mph)",
          "detail_hi": "शर्त बस यह है कि कार वे खुद चला रहे हों और कार उनकी अपनी न हो! लंदन में डिनर और अगले दिन न्यूयॉर्क में लंच — पर इसमें यात्रा का असली आनंद कम हो जाता है।",
          "detail_en": "Likes driving at 90 mph (if not his own car!), though dining in London and lunching in New York skips the joy of travel.",
          "accent": "indigo"
        },
        {
          "id": "pfl-st3",
          "label_hi": "3. सिनेमा हॉल में \"धीमे सोचने वाले\" की उलझन",
          "label_en": "3. Hopeless Fog at the Cinema",
          "detail_hi": "तेज़ बदलते दृश्य समझ नहीं आते; लेखक पत्नी से फुसफुसाकर पूछते हैं — पत्नी 3 लड़कियों को A, B, C कहकर समझाती हैं!",
          "detail_en": "Lost in rapid scene cuts, he whispers to his wife, who labels the 3 girls A, B, and C.",
          "accent": "slate"
        },
        {
          "id": "pfl-st4",
          "label_hi": "4. बुद्धि परीक्षाएँ (Intelligence Tests) और रोज़गार",
          "label_en": "4. Intelligence Tests & Getting a Living",
          "detail_hi": "आज के टेस्ट ज्ञान नहीं बल्कि \"दिमाग़ की रफ़्तार\" नापते हैं — जिससे धीमे सोचने वाले नौकरी पाने में पिछड़ जाते हैं।",
          "detail_en": "Modern tests measure speed of mind, putting slow thinkers at a handicap in earning a living.",
          "accent": "emerald"
        }
      ],
      "edges": [
        {
          "from": "pfl-st1",
          "to": "pfl-st2",
          "label_hi": "लेखक का पक्ष",
          "label_en": "Author's view"
        },
        {
          "from": "pfl-st2",
          "to": "pfl-st3",
          "label_hi": "मज़ेदार उदाहरण",
          "label_en": "Funny example"
        },
        {
          "from": "pfl-st3",
          "to": "pfl-st4",
          "label_hi": "गंभीर निष्कर्ष",
          "label_en": "Serious takeaway"
        }
      ]
    },
    "concept_md_hi": "### सिनेमा हॉल वाला मज़ेदार प्रसंग (हर साल बोर्ड में आता है!)\n- लेखक खुद को **\"धीमे सोचने वालों के कबीले (tribe of slow thinkers)\"** का सदस्य बताते हैं — ऐसे लोग जिन्हें सही जवाब पार्टी खत्म होने के **चार घंटे बाद** याद आता है!\n- जब वे सिनेमा देखने जाते हैं, तो 2–3 मिनट में ही कहानी की कड़ियाँ खो देते हैं। वे अपनी **पत्नी** से पूछते हैं: *\"क्या यह वही लड़की है जिसे हमने शुरू में देखा था?\"*\n- पत्नी समझाती हैं: *\"नहीं, इस फ़िल्म में **तीन लड़कियाँ** हैं — एक लंबी सुनहरे बालों वाली (tall blonde), एक छोटी सुनहरे बालों वाली (short blonde), और एक मझोले कद की भूरे बालों वाली (medium-sized brunette) — इन्हें **A, B और C** मान लो!\"*",
    "concept_md_en": "### The Famous Cinema Scene (BSEB Favourite!)\n- Hutchinson playfully places himself in the **\"tribe of slow thinkers\"** — people who think of a clever reply four hours after the party is over!\n- At the cinema, he gets lost within two minutes and whispers to his **wife**: *\"Is this the same girl we saw at the beginning?\"*\n- His wife whispers back: *\"No, there are **three girls** in this film — a tall blonde, a short blonde, and a medium-sized brunette. Call them **A, B, and C**!\"*",
    "exam_tip_hi": "ध्यान दें: फ़िल्म में कितनी लड़कियाँ थीं? → **Three girls (A, B, and C)**! और लेखक किससे मदद लेते हैं? → अपनी **पत्नी (wife)** से!",
    "exam_tip_en": "Exam Key: How many girls in the film? → **Three (A, B, C)**! Who helps the author? → His **wife**!",
    "glossary_terms": [
      {
        "term_hi": "Handicap (हैंडीकैप)",
        "term_en": "Handicap",
        "pronunciation_hi": "हैंडीकैप",
        "definition_hi": "बाधा या पिछड़ापन / नुकसान की स्थिति।",
        "definition_en": "A disadvantage that makes success harder."
      },
      {
        "term_hi": "Prejudice (प्रेजुडिस)",
        "term_en": "Prejudice",
        "pronunciation_hi": "प्रेजुडिस",
        "definition_hi": "पूर्वाग्रह या बिना कारण की नापसंदगी।",
        "definition_en": "Unfair dislike or preconceived bias."
      }
    ],
    "quick_check": {
      "q_hi": "लेखक को कितनी मील प्रति घंटे की रफ़्तार से कार चलाना पसंद है?",
      "q_en": "At what speed does R.C. Hutchinson enjoy driving a car?",
      "answer_hi": "**90 मील प्रति घंटा (90 miles an hour)** की रफ़्तार से (बशर्ते कार वे खुद चलाएँ और कार उनकी अपनी न हो!)।",
      "answer_en": "**90 miles an hour** (so long as he is driving and it is not his own car!)."
    }
  },
  {
    "id": "pfl-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "इन 4 पंक्तियों को ज़ोर से बोलकर पढ़िए — मैट्रिक परीक्षा के Objective और Short Answer दोनों इन्हीं से बनते हैं!",
    "analogy_en": "Read these 4 core sentences aloud — Matric MCQs and 2-mark answers come straight from them!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "पाठ की सबसे महत्वपूर्ण पंक्तियाँ (उच्चारण + अर्थ)",
      "title_en": "Must-Know Lines from The Pace for Living",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "I saw a play in Dublin not long ago.",
            "आई सॉ अ प्ले इन डबलिन नॉट लॉन्ग अगो।",
            "कुछ समय पहले मैंने डबलिन में एक नाटक देखा।"
          ],
          "cells_en": [
            "I saw a play in Dublin not long ago.",
            "Aai saw a ple in Dab-lin not long a-go.",
            "Opening sentence introducing the Irish play."
          ]
        },
        {
          "cells_hi": [
            "The chief character was an elderly corn-merchant.",
            "द चीफ़ कैरेक्टर वॉज़ ऐन एल्डरली कॉर्न-मर्चेंट।",
            "मुख्य पात्र एक वृद्ध अनाज-व्यापारी था।"
          ],
          "cells_en": [
            "The chief character was an elderly corn-merchant.",
            "The cheef ka-rek-tar woz an el-dar-lee korn-mar-chant.",
            "Identifies the stressed protagonist of the play."
          ]
        },
        {
          "cells_hi": [
            "I belong to the tribe of slow thinkers.",
            "आई बिलॉन्ग टु द ट्राइब ऑफ़ स्लो थिंकर्स।",
            "मैं धीमे सोचने वालों के समूह से हूँ।"
          ],
          "cells_en": [
            "I belong to the tribe of slow thinkers.",
            "Aai bi-long too the traaib ov slo thing-karz.",
            "Author's self-deprecating confession."
          ]
        },
        {
          "cells_hi": [
            "Slow thinkers are handicapped in getting a living.",
            "स्लो थिंकर्स आर हैंडीकैप्ड इन गेटिंग अ लिविंग।",
            "धीमे सोचने वाले जीविका (नौकरी) पाने में पिछड़ जाते हैं।"
          ],
          "cells_en": [
            "Slow thinkers are handicapped in getting a living.",
            "Slo thing-karz aar han-dee-kapt in ge-ting a li-ving.",
            "Core social critique of speed-obsessed tests."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Merchant** (*मर्चेंट*) = व्यापारी\n2. **Anxiety** (*ऐंज़ायटी*) = चिंता / घबराहट\n3. **Rapid** (*रैपिड*) = बहुत तेज़\n4. **Intelligence** (*इंटेलिजेंस*) = बुद्धि\n5. **Character** (*कैरेक्टर*) = पात्र / चरित्र\n6. **Guarantee** (*गारंटी*) = पक्का भरोसा",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Merchant** (*मर्चेंट*) = trader\n2. **Anxiety** (*ऐंज़ायटी*) = worry or tension\n3. **Rapid** (*रैपिड*) = very fast\n4. **Intelligence** (*इंटेलिजेंस*) = mental ability\n5. **Character** (*कैरेक्टर*) = person in a play/story\n6. **Guarantee** (*गारंटी*) = sure promise",
    "exam_tip_hi": "याद रखें: **Corn-merchant** का अर्थ \"अनाज-व्यापारी\" होता है, और **Living** का अर्थ यहाँ \"जीविका / रोज़गार\" है।",
    "exam_tip_en": "Remember: **Corn-merchant** = grain trader; **getting a living** = earning a livelihood/job.",
    "glossary_terms": [
      {
        "term_hi": "Anxiety (ऐंज़ायटी)",
        "term_en": "Anxiety",
        "pronunciation_hi": "ऐंज़ायटी",
        "definition_hi": "चिंता, तनाव या बेचैनी।",
        "definition_en": "A feeling of deep worry and nervousness."
      },
      {
        "term_hi": "Tribe (ट्राइब)",
        "term_en": "Tribe",
        "pronunciation_hi": "ट्राइब",
        "definition_hi": "एक ही स्वभाव या समूह के लोग (यहाँ: धीमे सोचने वालों का वर्ग)।",
        "definition_en": "A group or class of people sharing a common trait."
      }
    ]
  },
  {
    "id": "pfl-sec-4-summary",
    "order": 4,
    "heading_hi": "4. तेज़ बनाम धीमी सोच की तुलना व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Speed Contrast & 5-Mark Summary Formula",
    "analogy_hi": "नीचे के 5 छोटे वाक्य याद कर लीजिए — बोर्ड परीक्षा में \"The Pace for Living\" पर कोई भी बड़ा सवाल आए, ये 5 वाक्य पूरे 5 अंक दिलाएँगे!",
    "analogy_en": "Master these 5 clean sentences — they solve any long question on \"The Pace for Living\"!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "लेखक को कैसी गति पसंद है बनाम कैसी गति नापसंद है?",
      "title_en": "What Speed the Author Likes vs Dislikes",
      "headers_hi": [
        "पहलू (Aspect)",
        "लेखक को पसंद (Likes)",
        "लेखक को नापसंद (Dislikes)"
      ],
      "headers_en": [
        "Aspect",
        "What Hutchinson Likes",
        "What Hutchinson Dislikes"
      ],
      "rows": [
        {
          "cells_hi": [
            "वाहन / यात्रा",
            "90 मील/घंटा की रफ़्तार से कार चलाना",
            "इतनी तेज़ उड़ान कि सफ़र का आनंद ही खो जाए"
          ],
          "cells_en": [
            "Travel",
            "Driving a car at 90 miles an hour",
            "Speed so extreme that it kills the real pleasure of travel"
          ]
        },
        {
          "cells_hi": [
            "मानसिक सोच",
            "शांत, गहरी और ठहरी हुई सोच",
            "सिनेमा व परीक्षाओं में मशीन जैसी तेज़ सोच का दबाव"
          ],
          "cells_en": [
            "Thinking",
            "Calm, thoughtful reflection",
            "Forced rapid thinking in cinemas and intelligence tests"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"The Pace for Living\"** is a witty essay written by British novelist **R.C. Hutchinson**.\n2. It captures the **agony of modern man** struggling with the rapid pace of life.\n3. In a play in **Dublin**, an elderly **corn-merchant** feels crushed by anxieties and modern speed.\n4. The author calls himself a **slow thinker** who gets confused in the cinema and needs his wife's help.\n5. Modern **intelligence tests** measure only mental speed, putting slow thinkers at a great handicap in earning a living.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"The Pace for Living\"** is a witty essay written by British novelist **R.C. Hutchinson**.\n2. It captures the **agony of modern man** struggling with the rapid pace of life.\n3. In a play in **Dublin**, an elderly **corn-merchant** feels crushed by anxieties and modern speed.\n4. The author calls himself a **slow thinker** who gets confused in the cinema and needs his wife's help.\n5. Modern **intelligence tests** measure only mental speed, putting slow thinkers at a great handicap in earning a living.",
    "exam_tip_hi": "अंडरलाइन करने वाले 4 मुख्य शब्द: **R.C. Hutchinson**, **Dublin**, **Corn-merchant**, **Slow thinkers**।",
    "exam_tip_en": "Underline these 4 keywords in your exam sheet: **R.C. Hutchinson**, **Dublin**, **Corn-merchant**, **Slow thinkers**.",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "आधुनिक बुद्धि परीक्षाएँ (Intelligence Tests) मुख्य रूप से क्या मापती हैं?",
      "q_en": "What are modern intelligence tests mainly designed to test?",
      "answer_hi": "दिमाग़ के सोचने की **गति (speed of mind)**।",
      "answer_en": "The **speed of one's mind**."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Author",
      "fact_hi": "आर.सी. हचिंसन (1907–1975) · ब्रिटिश उपन्यासकार",
      "fact_en": "R.C. Hutchinson (1907–1975) · British Novelist"
    },
    {
      "tag": "Book & Genre",
      "fact_hi": "Panorama Part-2 (Class 10, Ch 1) · विधा: Essay (निबंध)",
      "fact_en": "Panorama Part-2 (Class 10, Ch 1) · Genre: Essay"
    },
    {
      "tag": "Key Numbers",
      "fact_hi": "£10 (पत्नी की छुट्टी) · 90 mph (कार) · 1,000 mph (जहाज़) · 3 girls (A, B, C)",
      "fact_en": "£10 (wife's holiday) · 90 mph (car) · 1,000 mph (plane) · 3 girls (A, B, C)"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "The Pace for Living is an essay by R.C. Hutchinson on modern life's fast pace.",
      "fact_en": "The Pace for Living is an essay by R.C. Hutchinson on modern life's fast pace."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "In a Dublin play, an elderly corn-merchant suffers from anxieties and rapid speed.",
      "fact_en": "In a Dublin play, an elderly corn-merchant suffers from anxieties and rapid speed."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "The author likes fast travel (90 mph) but dislikes forced rapid thinking.",
      "fact_en": "The author likes fast travel (90 mph) but dislikes forced rapid thinking."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "As a slow thinker, he gets lost in the cinema and asks his wife for help.",
      "fact_en": "As a slow thinker, he gets lost in the cinema and asks his wife for help."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "Intelligence tests judge speed of mind, disadvantaging slow thinkers in jobs.",
      "fact_en": "Intelligence tests judge speed of mind, disadvantaging slow thinkers in jobs."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "यह लिख देना कि लेखक को तेज़ रफ़्तार बिल्कुल पसंद नहीं है।",
      "mistake_en": "Writing that the author hates all rapid movement.",
      "fix_hi": "स्पष्ट लिखें: लेखक को **यात्रा की तेज़ रफ़्तार (90 mph कार) पसंद है**, पर **तेज़ मानसिक दबाव** नापसंद है!",
      "fix_en": "Clarify: He enjoys **fast physical travel (90 mph car)**, but dislikes **forced mental speed**!"
    },
    {
      "mistake_hi": "90 mph (कार) और 1,000 mph (हवाई जहाज़) को आपस में मिला देना।",
      "mistake_en": "Mixing up 90 mph (car) and 1,000 mph (aeroplane).",
      "fix_hi": "याद रखें: कार = **90 mph**, हवाई जहाज़ = **1,000 mph**!",
      "fix_en": "Keep clear: Car = **90 mph**, Aeroplane = **1,000 mph**!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "अनाज-व्यापारी की चिंताएँ व डबलिन का नाटक",
      "topic_en": "Corn-Merchant's Anxieties & Dublin Play",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    },
    {
      "topic_hi": "धीमे सोचने वालों की कठिनाई व सिनेमा प्रसंग",
      "topic_en": "Slow Thinkers' Handicap & Cinema Episode",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-10-eng-ch1',
  2,
  'छात्र "The Pace for Living" के लेखक, डबलिन के अनाज-व्यापारी और "Slow Thinkers" के विचार को समझ सकेंगे तथा मैट्रिक के 2-अंक व 5-अंक उत्तर सटीकता से लिख सकेंगे।',
  'Students will explain Hutchinson''s contrast between travel speed and slow thinking, recall key figures (Dublin, £10, 90 mph, 1,000 mph), and write crisp Matric answers.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "हिंदी कहानी हुक, उच्चारण अभ्यास व ब्लैकबोर्ड संख्या-चार्ट",
    "phase_en": "Hindi Hook, Pronunciation Drill & Key Numbers Chart",
    "teacher_action_hi": "छात्रों से पूछें: \"क्या आपको परीक्षा में समय कम पड़ने पर घबराहट होती है?\" फिर डबलिन के वृद्ध अनाज-व्यापारी की कहानी सुनाएँ। Agony (ऐगनी), Merchant (मर्चेंट), Anxiety (ऐंज़ायटी), Handicap (हैंडीकैप) का सामूहिक उच्चारण कराएँ और बोर्ड पर 4 मुख्य संख्याएँ (£10, 90 mph, 1,000 mph, 3 girls) लिखें।",
    "teacher_action_en": "Ask students if fast ticking exam clocks make them nervous. Narrate the Dublin corn-merchant scene. Drill pronunciation of Agony, Merchant, Anxiety, Handicap, and map the 4 numbers (£10, 90 mph, 1,000 mph, 3 girls).",
    "student_check_hi": "पूछें: \"अनाज-व्यापारी को कौन-सी 2 पारिवारिक चिंताएँ थीं?\"",
    "student_check_en": "Ask: \"What two family troubles worried the elderly corn-merchant?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "सिनेमा प्रसंग अभिनय, 5-मिनट मौखिक गतिविधि व बोर्ड उत्तर लेखन",
    "phase_en": "Cinema Role-Play, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "दो छात्रों से पति-पत्नी का सिनेमा संवाद (\"A, B, C girls\") मज़ेदार ढंग से पढ़वाएँ। 5-मिनट मौखिक आत्मविश्वास गतिविधि में कमजोर छात्रों से 5-वाक्य सारांश बुलवाएँ। अंत में 5 मैट्रिक PYQ हल करवाएँ।",
    "teacher_action_en": "Have two students enact the witty husband-wife cinema dialogue. Run a 5-min oral chain on the 5-sentence summary for shy learners, then solve 5 Matric PYQs.",
    "student_check_hi": "कमज़ोर छात्रों से बोलवाएँ: \"Slow thinkers are handicapped in getting a living.\"",
    "student_check_en": "Have every student repeat and write: \"Slow thinkers are handicapped in getting a living.\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड मैट्रिक बॉक्स (The Pace for Living)",
    "heading_en": "Blackboard Matric Box (The Pace for Living)",
    "points_hi": [
      "लेखक: R.C. Hutchinson (British Novelist) | पाठ: Essay",
      "नाटक का स्थान: Dublin | मुख्य पात्र: Elderly Corn-merchant (कमज़ोर दिल, धोखेबाज़ भतीजा, पत्नी £10)",
      "संख्याएँ: Aeroplane = 1,000 mph | Car = 90 mph | Film girls = 3 (A, B, C)",
      "मुख्य संदेश: Intelligence tests केवल speed नापते हैं → Slow thinkers को नुकसान!"
    ],
    "points_en": [
      "Author: R.C. Hutchinson (British Novelist) | Genre: Essay",
      "Play city: Dublin | Lead: Elderly Corn-merchant (cheating nephew, wife £10 holiday)",
      "Numbers: Plane = 1,000 mph | Car = 90 mph | Film girls = 3 (A, B, C)",
      "Message: Intelligence tests measure speed -> slow thinkers handicapped"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"संख्या पहचानो, कहानी बताओ\" मौखिक खेल",
    "title_en": "5-Minute \"Spot the Number, Tell the Fact\" Oral Game",
    "materials_hi": "ब्लैकबोर्ड पर लिखे 4 अंक: £10, 90, 1000, 3",
    "materials_en": "4 numbers on the board: £10, 90, 1000, 3",
    "steps_hi": "शिक्षक किसी एक संख्या पर उँगली रखें और कमजोर छात्र 1 सरल वाक्य में उससे जुड़ा प्रसंग बताएँ। हर सही उत्तर पर तालियाँ!",
    "steps_en": "Teacher points to any number; shy students name the linked fact from the essay in Hindi or English."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Pace, Agony, Merchant, Anxiety और Handicap को उच्चारण व अर्थ सहित 3 बार लिखें।",
    "task_en": "Write Pace, Agony, Merchant, Anxiety, and Handicap 3 times with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "लेखक को सिनेमा देखते समय क्या कठिनाई होती है? 3 सरल अंग्रेज़ी वाक्यों में लिखें।",
    "task_en": "What difficulty does the author face at the cinema? Answer in 3 simple sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "5-वाक्य सारांश फ़ॉर्मूला का प्रयोग कर \"The Pace for Living\" का पूरा सारांश लिखें।",
    "task_en": "Write the complete 5-sentence summary of \"The Pace for Living\" cleanly."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र लिखते हैं कि लेखक को तेज़ कार या हवाई जहाज़ पसंद नहीं हैं।",
    "misconception_en": "Students assume the author dislikes fast cars and planes.",
    "correction_hi": "स्पष्ट बताएँ: लेखक कहते हैं \"Not that I have any dislike of rapid movement\" — वे 90 mph कार चलाना पसंद करते हैं!",
    "correction_en": "Clarify: Hutchinson explicitly says he has NO dislike of rapid physical movement!"
  },
  {
    "misconception_hi": "छात्र डबलिन (Dublin) की जगह लंदन (London) को नाटक का स्थान लिख देते हैं।",
    "misconception_en": "Students write London instead of Dublin for the play.",
    "correction_hi": "अंतर बताएँ: नाटक **Dublin** में देखा; **London** में डिनर और **New York** में लंच का उदाहरण अलग है!",
    "correction_en": "Distinguish: Play was in **Dublin**; **London/New York** is the dining/lunching speed example!"
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
  (
    '10000007-0001-4000-8000-000000000001', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Author & Setting', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2023',
    'The Pace for Living के लेखक, विधा और डबलिन नाटक का मुख्य पात्र कौन है?',
    'Who wrote "The Pace for Living" and who is the lead in the Dublin play?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"The Pace for Living\" के लेखक, विधा और मुख्य पात्र (Dublin play) बताएँ।",
  "front_en": "Name the author, genre, and Dublin play character in \"The Pace for Living\".",
  "back_hi": "लेखक: R.C. Hutchinson (British Novelist) · विधा: Essay · पात्र: Elderly Corn-merchant (Dublin के नाटक में)।",
  "back_en": "Author: R.C. Hutchinson (British Novelist) · Genre: Essay · Character: Elderly Corn-merchant (in Dublin play).",
  "pronunciation_hi": "द पेस फ़ॉर लिविंग — आर.सी. हचिंसन",
  "mnemonic_hi": "ट्रिक: Pace (रफ़्तार) → Hutch (हचिंसन) → Corn-merchant (डबलिन)!",
  "mnemonic_en": "Hook: Pace for Living -> R.C. Hutchinson -> Dublin Corn-merchant!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000002', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Agony और Handicap का उच्चारण व अर्थ क्या है?',
    'What are the pronunciation and meaning of Agony and Handicap?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Agony और Handicap शब्दों का उच्चारण व अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Agony\" and \"Handicap\".",
  "back_hi": "Agony (ऐगनी) = गहरी मानसिक पीड़ा · Handicap (हैंडीकैप) = बाधा / पिछड़ापन।",
  "back_en": "Agony = intense mental suffering · Handicap = disadvantage or obstacle.",
  "pronunciation_hi": "ऐगनी · हैंडीकैप",
  "mnemonic_hi": "आधुनिक जीवन की पीड़ा = Agony of modern man!",
  "mnemonic_en": "Remember the textbook phrase: \"agony of modern man\"!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000003', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Facts & Numbers Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2024',
    'स्तंभ A को स्तंभ B के सही तथ्य से मिलाएँ:',
    'Match each item in Column A with its correct detail in Column B:',
    NULL, NULL,
    'डबलिन, 90 mph, 1,000 mph और तीन लड़कियाँ (A, B, C) मिलाएँ।', 'Match Dublin, 90 mph, 1,000 mph, and the 3 film girls.',
    'नाटक डबलिन में देखा, कार की रफ़्तार 90 mph, हवाई जहाज़ 1,000 mph, और सिनेमा में 3 लड़कियाँ (A, B, C) थीं।', 'Play was in Dublin, car speed 90 mph, aeroplane 1,000 mph, and 3 girls (A, B, C) in the film.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each fact from The Pace for Living",
  "pairs": [
    {
      "id": "pfl-m1",
      "left_hi": "Dublin (डबलिन)",
      "left_en": "Dublin",
      "right_hi": "जहाँ लेखक ने अनाज-व्यापारी का नाटक देखा",
      "right_en": "City where the author saw the play"
    },
    {
      "id": "pfl-m2",
      "left_hi": "90 miles an hour",
      "left_en": "90 miles an hour",
      "right_hi": "लेखक को कार चलाने की पसंदीदा रफ़्तार",
      "right_en": "Speed at which the author enjoys driving"
    },
    {
      "id": "pfl-m3",
      "left_hi": "1,000 miles an hour",
      "left_en": "1,000 miles an hour",
      "right_hi": "अनाज-व्यापारी द्वारा बताया गया तेज़ हवाई जहाज़",
      "right_en": "Aeroplane speed called \"too fast\" by corn-merchant"
    },
    {
      "id": "pfl-m4",
      "left_hi": "Girls A, B, and C",
      "left_en": "Girls A, B, and C",
      "right_hi": "सिनेमा में लेखक की पत्नी द्वारा समझाई गईं 3 लड़कियाँ",
      "right_en": "Three girls explained by the author's wife at cinema"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000004', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही अंग्रेज़ी वाक्य बनाएँ: "मुख्य पात्र एक वृद्ध अनाज-व्यापारी था।"',
    'Build the textbook sentence: "The chief character was an elderly corn-merchant"',
    NULL, NULL,
    '"elderly" स्वर ध्वनि (ए) से शुरू होता है, इसलिए "an" आएगा।', 'Use "an" before the vowel sound of "elderly".',
    'सही वाक्य: "The chief character was an elderly corn-merchant"।', 'Correct sentence: "The chief character was an elderly corn-merchant".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मुख्य पात्र एक वृद्ध अनाज-व्यापारी था।",
  "prompt_en": "Build this key sentence from The Pace for Living",
  "grammar_formula": "The + Adjective + Noun + was + an + Adjective + Noun",
  "tokens": [
    "The",
    "chief",
    "character",
    "was",
    "an",
    "elderly",
    "corn-merchant"
  ],
  "distractors": [
    "were",
    "a"
  ],
  "correct_sentence": "The chief character was an elderly corn-merchant",
  "pronunciation_hi": "द चीफ़ कैरेक्टर वॉज़ ऐन एल्डरली कॉर्न-मर्चेंट"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000005', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य सजाएँ: "मैं धीमे सोचने वालों के समूह से हूँ।"',
    'Build the sentence: "I belong to the tribe of slow thinkers"',
    NULL, NULL,
    '"belong" के साथ हमेशा preposition "to" लगता है!', '"belong" always takes the preposition "to".',
    'सही वाक्य: "I belong to the tribe of slow thinkers"।', 'Correct sentence: "I belong to the tribe of slow thinkers".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मैं धीमे सोचने वालों के समूह से हूँ।",
  "prompt_en": "Build the author's famous humorous confession",
  "grammar_formula": "I + belong + to + the + Noun + of + Adjective + Noun",
  "tokens": [
    "I",
    "belong",
    "to",
    "the",
    "tribe",
    "of",
    "slow",
    "thinkers"
  ],
  "distractors": [
    "belongs",
    "in"
  ],
  "correct_sentence": "I belong to the tribe of slow thinkers",
  "pronunciation_hi": "आई बिलॉन्ग टु द ट्राइब ऑफ़ स्लो थिंकर्स"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000006', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Author MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    '"The Pace for Living" किसके द्वारा लिखा गया है?',
    'Who is the author of "The Pace for Living"?',
    $json$[{"key":"A","text_hi":"आर.सी. हचिंसन","text_en":"R.C. Hutchinson"},{"key":"B","text_hi":"महादेवी वर्मा","text_en":"Mahadevi Varma"},{"key":"C","text_hi":"सत्यजीत राय","text_en":"Satyajit Ray"},{"key":"D","text_hi":"जोन लेक्साऊ","text_en":"Joan Lexau"}]$json$::jsonb, 'A',
    'एक प्रसिद्ध ब्रिटिश उपन्यासकार।', 'A well-known British novelist.',
    '"The Pace for Living" ब्रिटिश उपन्यासकार आर.सी. हचिंसन का निबंध है।', '"The Pace for Living" was written by British novelist R.C. Hutchinson.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000007', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Play Location MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2022',
    'लेखक ने अनाज-व्यापारी वाला नाटक किस शहर में देखा था?',
    'In which city did the author see the play about the corn-merchant?',
    $json$[{"key":"A","text_hi":"न्यूयॉर्क (New York)","text_en":"New York"},{"key":"B","text_hi":"पेरिस (Paris)","text_en":"Paris"},{"key":"C","text_hi":"डबलिन (Dublin)","text_en":"Dublin"},{"key":"D","text_hi":"रोम (Rome)","text_en":"Rome"}]$json$::jsonb, 'C',
    'आयरलैंड की राजधानी याद करें!', 'Recall the capital of Ireland.',
    'लेखक ने वह नाटक डबलिन (Dublin) में देखा था।', 'The author watched the play in Dublin.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000008', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Corn-Merchant Nephew', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'वृद्ध अनाज-व्यापारी को कौन धोखा दे रहा था?',
    'Who was cheating the elderly corn-merchant in the play?',
    $json$[{"key":"A","text_hi":"उसका पुत्र (His son)","text_en":"His son"},{"key":"B","text_hi":"उसका भतीजा (His nephew)","text_en":"His nephew"},{"key":"C","text_hi":"उसका पड़ोसी (His neighbour)","text_en":"His neighbour"},{"key":"D","text_hi":"उसका भाई (His brother)","text_en":"His brother"}]$json$::jsonb, 'B',
    'नाटक में व्यापारी के परिवार के दो सदस्य उसकी चिंता का कारण थे — पत्नी और ...?', 'Two family members stressed him — his wife and his...?',
    'अनाज-व्यापारी का भतीजा (nephew) उसे धोखा दे रहा था।', 'The elderly corn-merchant''s nephew was cheating him.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000009', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Cinema Episode', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2021',
    'सिनेमा में उलझने पर लेखक किससे मदद माँगते हैं?',
    'Whom does the author turn to for enlightenment when confused at the cinema?',
    $json$[{"key":"A","text_hi":"टिकट बाबू से","text_en":"The ticket clerk"},{"key":"B","text_hi":"अपने भाई से","text_en":"His brother"},{"key":"C","text_hi":"अपने मित्र से","text_en":"His friend"},{"key":"D","text_hi":"अपनी पत्नी से","text_en":"His wife"}]$json$::jsonb, 'D',
    'उन्हीं ने फ़िल्म की 3 लड़कियों को A, B और C नाम देकर समझाया।', 'She explained the three girls by calling them A, B, and C.',
    'लेखक सिनेमा में उलझने पर अपनी पत्नी से फुसफुसाकर मदद लेते हैं।', 'The author whispers to his wife for help at the cinema.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000010', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Intelligence Tests', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'लेखक के अनुसार आधुनिक बुद्धि परीक्षाएँ (Mental Tests) मुख्यतः क्या परखने के लिए बनाई गई हैं?',
    'According to R.C. Hutchinson, modern intelligence tests are designed chiefly to test:',
    $json$[{"key":"A","text_hi":"मन की गति (Speed of mind)","text_en":"Speed of mind"},{"key":"B","text_hi":"ईमानदारी","text_en":"Honesty"},{"key":"C","text_hi":"सुंदर लिखावट","text_en":"Good handwriting"},{"key":"D","text_hi":"शारीरिक शक्ति","text_en":"Physical strength"}]$json$::jsonb, 'A',
    'इसी कारण "slow thinkers" को रोज़गार पाने में कठिनाई होती है।', 'This is why slow thinkers suffer a handicap in getting a living.',
    'लेखक कहते हैं कि आधुनिक बुद्धि परीक्षाएँ ज्ञान की गहराई से ज़्यादा दिमाग़ की रफ़्तार (speed of mind) मापती हैं।', 'Hutchinson argues intelligence tests primarily measure the speed of one''s mind.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000011', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Exam Pool: Wife Holiday', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2023',
    'अनाज-व्यापारी की पत्नी में छुट्टी पर कितने पाउंड खर्च करने की अजीब धुन थी?',
    'How much money did the corn-merchant''s wife have the fantastic notion of spending on a holiday?',
    $json$[{"key":"A","text_hi":"£5","text_en":"£5"},{"key":"B","text_hi":"£10","text_en":"£10"},{"key":"C","text_hi":"£50","text_en":"£50"},{"key":"D","text_hi":"£100","text_en":"£100"}]$json$::jsonb, 'B',
    'दस पाउंड (£10) की रकम याद करें।', 'Recall the exact pound figure mentioned in the play.',
    'अनाज-व्यापारी की पत्नी को छुट्टी पर £10 (दस पाउंड) खर्च करने की धुन सवार थी।', 'The corn-merchant''s wife had the fantastic notion of spending £10 on a holiday.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000012', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Exam Pool: Car Speed', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'लेखक को किस रफ़्तार से कार चलाना आनंददायक लगता है (यदि कार अपनी न हो)?',
    'At what speed does the author enjoy going in a car (so long as he is driving and it is not his own)?',
    $json$[{"key":"A","text_hi":"40 मील प्रति घंटा","text_en":"40 miles an hour"},{"key":"B","text_hi":"60 मील प्रति घंटा","text_en":"60 miles an hour"},{"key":"C","text_hi":"90 मील प्रति घंटा","text_en":"90 miles an hour"},{"key":"D","text_hi":"1,000 मील प्रति घंटा","text_en":"1,000 miles an hour"}]$json$::jsonb, 'C',
    'हवाई जहाज़ 1,000 mph था; कार की रफ़्तार 90 mph थी।', 'Plane = 1,000 mph; car = 90 mph.',
    'लेखक कहते हैं उन्हें 90 मील प्रति घंटा (90 miles an hour) की गति से कार चलाना पसंद है।', 'The author says he enjoys going in a car at 90 miles an hour.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000013', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Slow Thinkers 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'आज के समय में "धीमे सोचने वाले (Slow Thinkers)" क्यों पिछड़ जाते हैं?',
    'How are slow thinkers handicapped in the modern world?',
    NULL, NULL,
    'बुद्धि परीक्षाओं (Intelligence Tests) और जीविका (getting a living) का संबंध लिखें।', 'Connect intelligence tests measuring speed of mind with getting a living.',
    NULL, NULL,
    'आज की दुनिया में बुद्धि परीक्षाएँ (intelligence tests) केवल **दिमाग़ के सोचने की गति** मापती हैं, न कि गहराई। इसलिए धीमे सोचने वाले (slow thinkers) आधुनिक प्रतिस्पर्धा में **रोज़गार या जीविका (getting a living)** पाने में भारी कठिनाई (handicap) का सामना करते हैं।', 'In the modern world, mental and intelligence tests are designed mainly to test the **speed of one''s mind**. As a result, **slow thinkers are seriously handicapped in the business of getting a living**, even though they may be wise and thoughtful.',
    $json$[{"cue_hi":"Tests measure speed of mind","cue_en":"Tests measure speed of mind"},{"cue_hi":"Handicapped in getting a living","cue_en":"Handicapped in getting a living"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"बुद्धि परीक्षाओं द्वारा केवल गति मापने का उल्लेख","criterion_en":"States that intelligence tests measure speed of mind"},{"step_no":2,"marks":1,"criterion_hi":"जीविका (getting a living) पाने में पिछड़ने का उल्लेख","criterion_en":"Explains handicap in earning a living"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0001-4000-8000-000000000014', 'bseb-10-eng', 'bseb-10-eng-ch1', 'Summary & Theme 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"The Pace for Living" निबंध का सारांश लिखें और इसके मुख्य विचार को स्पष्ट करें।',
    'Write a summary of "The Pace for Living" and explain its central idea.',
    NULL, NULL,
    'लेखक, डबलिन का अनाज-व्यापारी, 90 mph कार बनाम सिनेमा की उलझन, और slow thinkers की समस्या लिखें।', 'Cover author, Dublin corn-merchant, 90 mph travel vs cinema fog, and intelligence tests.',
    NULL, NULL,
    '**"The Pace for Living"** ब्रिटिश उपन्यासकार **आर.सी. हचिंसन** द्वारा लिखा गया एक विचारशील निबंध है, जो आधुनिक तेज़ रफ़्तार जीवन में मनुष्य की मानसिक पीड़ा को दर्शाता है।

लेखक बताते हैं कि उन्होंने **डबलिन** में एक नाटक देखा जिसका मुख्य पात्र एक वृद्ध **अनाज-व्यापारी** था। वह भतीजे के धोखे, पत्नी के खर्चीले स्वभाव (£10) और आधुनिक जीवन की रफ़्तार से परेशान था। 1,000 मील प्रति घंटे के हवाई जहाज़ की बात सुनकर वह कराह उठा — *"अब यह बहुत तेज़ है!"*

लेखक स्वयं को **धीमे सोचने वालों (slow thinkers)** में गिनते हैं। यद्यपि उन्हें 90 मील/घंटे से कार चलाना पसंद है, पर सिनेमा में तेज़ बदलते दृश्य समझ नहीं आते और उन्हें अपनी पत्नी से मदद लेनी पड़ती है। अंत में वे बताते हैं कि आज के बुद्धि परीक्षण केवल गति मापते हैं, जिससे धीमे सोचने वाले जीविका पाने में पिछड़ जाते हैं।', '**"The Pace for Living"** is a perceptive essay by British novelist **R.C. Hutchinson** capturing the **agony of modern man** in a fast-moving world.

The author recalls a play he watched in **Dublin**, whose chief character was an elderly **corn-merchant** overwhelmed by anxieties — a cheating nephew, a wife spending £10 on a holiday, and aeroplanes flying at 1,000 miles an hour. Hutchinson playfully classifies himself among **"slow thinkers"**. Although he enjoys fast travel at 90 miles an hour, he dislikes forced mental speed: at the cinema he gets completely fogged and relies on his wife to identify the three girls as A, B, and C.

He concludes that modern **intelligence tests** measure only the speed of the mind, placing slow thinkers at an unfair handicap in getting a living.',
    $json$[{"cue_hi":"R.C. Hutchinson · Agony of modern man","cue_en":"R.C. Hutchinson · Agony of modern man"},{"cue_hi":"Dublin play · Elderly corn-merchant","cue_en":"Dublin play · Elderly corn-merchant"},{"cue_hi":"Likes 90 mph car · Fogged at cinema (A, B, C)","cue_en":"Likes 90 mph car · Fogged at cinema (A, B, C)"},{"cue_hi":"Intelligence tests handicap slow thinkers","cue_en":"Intelligence tests handicap slow thinkers"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"लेखक (R.C. Hutchinson) व केंद्रीय विषय (agony of modern man)","criterion_en":"Names R.C. Hutchinson and theme of modern pace"},{"step_no":2,"marks":1.5,"criterion_hi":"डबलिन नाटक व वृद्ध अनाज-व्यापारी की चिंताओं का वर्णन","criterion_en":"Describes Dublin play and elderly corn-merchant"},{"step_no":3,"marks":1.5,"criterion_hi":"तेज़ सफ़र (90 mph) बनाम सिनेमा में पत्नी की सहायता","criterion_en":"Contrasts fast travel with cinema confusion"},{"step_no":4,"marks":1,"criterion_hi":"बुद्धि परीक्षाओं व slow thinkers पर स्पष्ट निष्कर्ष","criterion_en":"Concludes with intelligence tests handicapping slow thinkers"}]$json$::jsonb,
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
-- CHAPTER 2 OF 14: BSEB-10-ENG-CH2 — Me and the Ecology Bit — Joan Lexau
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-10-eng-ch2',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: मैं और पारिस्थितिकी (Me and the Ecology Bit)",
  "title_en": "30-Second Mindmap: Me and the Ecology Bit",
  "read_time_seconds": 30,
  "central_node": {
    "id": "eco-root",
    "label_hi": "Me and the Ecology Bit",
    "label_en": "Me and the Ecology Bit (Story)",
    "subtitle_hi": "Joan Lexau · Panorama Part-2 (कक्षा 10, अध्याय 2)",
    "subtitle_en": "Joan Lexau · Panorama Part-2 (Class 10, Ch 2)"
  },
  "branches": [
    {
      "id": "eco-author",
      "label_hi": "1. लेखिका और कथावाचक",
      "label_en": "1. Author & Narrator",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "eco-a1",
          "label_hi": "जोन लेक्साऊ (Joan Lexau, 1929–2023) — अमेरिकी लेखिका",
          "label_en": "Joan Lexau (1929–2023) — American Author"
        },
        {
          "id": "eco-a2",
          "label_hi": "जिम (Jim): अख़बार बाँटने वाला लड़का (Paper route)",
          "label_en": "Jim: Young narrator running a Saturday paper route"
        }
      ]
    },
    {
      "id": "eco-neighbors",
      "label_hi": "2. जिम के 3 पड़ोसी (Neighbors)",
      "label_en": "2. Jim's 3 Neighbours",
      "color": "#059669",
      "children": [
        {
          "id": "eco-n1",
          "label_hi": "Mr. Williams: सूखे पत्ते जलाते हैं; जिम के खाद-ढेर को \"गंध प्रदूषण\" कहते हैं",
          "label_en": "Mr. Williams: Burning leaves; calls Jim's compost \"nose pollution\""
        },
        {
          "id": "eco-n2",
          "label_hi": "Ms. Greene: जिम के कुत्ते व च्युइंग-गम रैपर की शिकायत करती हैं",
          "label_en": "Ms. Greene: Complains about Jim's dog & gum wrapper"
        },
        {
          "id": "eco-n3",
          "label_hi": "Mr. Johnson: 2 ब्लॉक दूर डाकघर कार से जाते हैं; जिम की मोटरबाइक याद दिलाते हैं",
          "label_en": "Mr. Johnson: Drives 2 blocks to post office; exposes Jim's motorbike"
        }
      ]
    },
    {
      "id": "eco-home",
      "label_hi": "3. घर पर व्यंग्य (Ironic Twist)",
      "label_en": "3. Ironic Ending at Home",
      "color": "#D97706",
      "children": [
        {
          "id": "eco-h1",
          "label_hi": "माँ इलेक्ट्रिक मिक्सर चलाती हैं → जिम बिजली बचाने का उपदेश देता है",
          "label_en": "Mother uses electric mixer -> Jim lectures on electricity"
        },
        {
          "id": "eco-h2",
          "label_hi": "माँ पलटवार करती हैं: \"यहाँ दिन में 27 घंटे टीवी कौन देखता है?\"",
          "label_en": "Mother snaps back: \"Who watches TV 27 hours a day?\""
        }
      ]
    },
    {
      "id": "eco-msg",
      "label_hi": "4. संदेश और बोर्ड फोकस",
      "label_en": "4. Moral & Exam Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "eco-m1",
          "label_hi": "पर्यावरण पर भाषण देना आसान है, पर खुद अमल करना कठिन!",
          "label_en": "Preaching ecology is easy; practising it ourselves is hard!"
        },
        {
          "id": "eco-m2",
          "label_hi": "पक्के MCQ: Jim, Mr. Williams, Ms. Greene, Mr. Johnson, 2 blocks, 27 hours TV।",
          "label_en": "Top MCQs: Jim, Mr. Williams, Ms. Greene, Mr. Johnson, 2 blocks, 27 hrs TV."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "eco-sec-1-author",
    "order": 1,
    "heading_hi": "1. लेखिका परिचय और हमारे मुहल्ले का मज़ेदार सच",
    "heading_en": "1. Author Profile & Neighbourhood Reality",
    "analogy_hi": "सोचिए आपके मुहल्ले में एक लड़का सबको भाषण दे — *\"अंकल, कचरा मत जलाइए! प्रदूषण फैलता है!\"* — और अगले ही पल खुद चॉकलेट का रैपर सड़क पर फेंक दे और दिन भर मोटरसाइकिल घुमाए! यही मज़ेदार विडंबना **जोन लेक्साऊ** ने अपनी कहानी **Me and the Ecology Bit** में **जिम** के ज़रिए दिखाई है।",
    "analogy_en": "Imagine a boy lecturing his entire Bihar neighbourhood about keeping streets clean, while tossing a candy wrapper on the road himself! **Joan Lexau** captures that exact irony through **Jim** in **Me and the Ecology Bit**.",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "पाठ का त्वरित परिचय (Author, Narrator & Theme)",
      "title_en": "Quick Fact Box: Me and the Ecology Bit",
      "headers_hi": [
        "बिंदु (Detail)",
        "सटीक जानकारी (Authentic Fact)"
      ],
      "headers_en": [
        "Detail",
        "Authentic Fact"
      ],
      "rows": [
        {
          "cells_hi": [
            "लेखिका (Author)",
            "जोन लेक्साऊ (Joan Lexau, 1929–2023) — प्रसिद्ध अमेरिकी बाल-साहित्य लेखिका"
          ],
          "cells_en": [
            "Author",
            "Joan Lexau (1929–2023) — Renowned American children's author"
          ]
        },
        {
          "cells_hi": [
            "कथावाचक (Narrator)",
            "जिम (Jim) — शनिवार को अख़बार के पैसे वसूलने वाला लड़का"
          ],
          "cells_en": [
            "Narrator",
            "Jim — A young boy collecting money on his Saturday paper route"
          ]
        },
        {
          "cells_hi": [
            "मुख्य शब्द (Ecology)",
            "इकोलॉजी (पारिस्थितिकी) — जीवों और पर्यावरण के बीच संतुलन का विज्ञान"
          ],
          "cells_en": [
            "Key Term (Ecology)",
            "Science of preserving the environment and nature's balance"
          ]
        },
        {
          "cells_hi": [
            "केंद्रीय व्यंग्य (Irony)",
            "हर कोई पर्यावरण बचाना चाहता है, पर खुद कोई बदलाव नहीं करना चाहता!"
          ],
          "cells_en": [
            "Central Irony",
            "Everyone favours ecology, yet nobody wants to change their own habits!"
          ]
        }
      ]
    },
    "concept_md_hi": "### कहानी की शुरुआत\n- **जिम (Jim)** अपने मुहल्ले में अख़बार बाँटने का काम (**paper route**) करता है। हर **शनिवार (Saturday)** को जब वह पैसे वसूलने जाता है, तो लोगों को **पर्यावरण संरक्षण (ecology)** का उपदेश भी देता है।\n- जिम शुरुआत में ही सच्चाई बताता है: **\"पर्यावरण के लिए लोगों से काम करवाना सचमुच कठिन है। हर कोई इसके पक्ष में है, लेकिन खुद कुछ करना कोई नहीं चाहता।\"**",
    "concept_md_en": "### Opening Setup\n- **Jim** runs a neighbourhood **paper route**. On **Saturdays**, while collecting payments, he eagerly preaches **ecology** to his customers.\n- Right at the start, Jim admits the truth: **\"Sure it is hard to get people to work for ecology. Everybody is in favour of it, but nobody wants to do anything about it.\"**",
    "exam_tip_hi": "BSEB मैट्रिक का बार-बार आने वाला प्रश्न: जिम का काम क्या था? → **Paper route (अख़बार बाँटना)** और वह पैसे कब वसूलता था? → **Saturday (शनिवार)** को!",
    "exam_tip_en": "Repeated Matric MCQ: Jim's job = **paper route**; money collection day = **Saturday**!",
    "glossary_terms": [
      {
        "term_hi": "Ecology (इकोलॉजी)",
        "term_en": "Ecology",
        "pronunciation_hi": "इकोलॉजी",
        "definition_hi": "पारिस्थितिकी — प्रकृति, हवा, पानी और जीवों के बीच संतुलन व संरक्षण।",
        "definition_en": "The science and care of the relationship between living things and their environment."
      },
      {
        "term_hi": "Compost (कम्पोस्ट)",
        "term_en": "Compost",
        "pronunciation_hi": "कम्पोस्ट",
        "definition_hi": "सूखे पत्तों व जैविक कचरे को सड़ाकर बनाई गई प्राकृतिक खाद।",
        "definition_en": "Decayed leaves and organic waste used as natural fertilizer."
      }
    ]
  },
  {
    "id": "eco-sec-2-storyboard",
    "order": 2,
    "heading_hi": "2. विज़ुअल स्टोरीबोर्ड: जिम के 4 पड़ाव (और हर बार पलटवार!)",
    "heading_en": "2. Visual Storyboard: Jim's 4 Encounters & Counter-Attacks!",
    "analogy_hi": "जिम चार लोगों को उपदेश देने जाता है — और चारों बार सामने वाला उल्टा जिम की ही पोल खोल देता है! इस मज़ेदार चार्ट से चारों नाम व घटनाएँ हमेशा के लिए याद हो जाएँगी।",
    "analogy_en": "Jim lectures four people — and all four turn the tables right back on Jim! This flowchart locks every name and detail into memory.",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "जिम की इकोलॉजी यात्रा — 4 घर, 4 करारे जवाब!",
      "title_en": "Jim's Ecology Route — 4 Stops, 4 Funny Counter-Punches!",
      "direction": "TB",
      "steps": [
        {
          "id": "eco-s1",
          "label_hi": "1. मिस्टर विलियम्स (Mr. Williams) — पत्ते जलाना",
          "label_en": "1. Mr. Williams — Burning Leaves",
          "detail_hi": "जिम कहता है: पत्ते मत जलाओ, खाद (compost) बनाओ। विलियम्स पलटते हैं: तुम्हारी खाद की बदबू से गली में \"गंध प्रदूषण (nose pollution)\" होता है!",
          "detail_en": "Jim urges making compost instead of burning leaves; Mr. Williams complains Jim's compost causes \"nose pollution\"!",
          "accent": "amber"
        },
        {
          "id": "eco-s2",
          "label_hi": "2. मिस ग्रीन (Ms. Greene) — कुत्ता और रैपर",
          "label_en": "2. Ms. Greene — Dog & Gum Wrapper",
          "detail_hi": "जिम के बोलते ही वे कहती हैं: पहले अपना कुत्ता बाँधकर रखो (मेरे बगीचे में गड्ढा करता है) और मेरे लॉन से अपना च्युइंग-गम का रैपर उठाओ!",
          "detail_en": "Ms. Greene snaps back: keep your dog on a leash out of my garden and pick up the gum wrapper you dropped on my lawn!",
          "accent": "emerald"
        },
        {
          "id": "eco-s3",
          "label_hi": "3. मिस्टर जॉनसन (Mr. Johnson) — 2 ब्लॉक दूर डाकघर",
          "label_en": "3. Mr. Johnson — Driving 2 Blocks to Post Office",
          "detail_hi": "जिम कहता है: सिर्फ़ 2 ब्लॉक दूर डाकघर पैदल जाओ। जॉनसन भड़कते हैं: तुम खुद गर्मी में मोटरबाइक और सर्दी में स्नोमोबाइल चलाते हो और मेरा नन्हा पेड़ कुचल दिया!",
          "detail_en": "Jim says walk 2 blocks to the post office; Johnson exposes Jim's motorbike, snowmobile, and the little tree Jim killed!",
          "accent": "indigo"
        },
        {
          "id": "eco-s4",
          "label_hi": "4. जिम की माँ (Home) — इलेक्ट्रिक मिक्सर बनाम 27 घंटे टीवी!",
          "label_en": "4. Jim's Mother — Mixer vs 27 Hours of TV!",
          "detail_hi": "जिम माँ को बिजली बचाने के लिए मिक्सर बंद करने कहता है। माँ जवाब देती हैं: \"घर में दिन के 27 घंटे टीवी कौन देखता है?\"",
          "detail_en": "Jim scolds Mom for using an electric mixer; Mom asks: \"Who watches TV twenty-seven hours a day around here?\"",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "eco-s1",
          "to": "eco-s2",
          "label_hi": "अगला घर",
          "label_en": "Next house"
        },
        {
          "from": "eco-s2",
          "to": "eco-s3",
          "label_hi": "अगला पड़ोसी",
          "label_en": "Next stop"
        },
        {
          "from": "eco-s3",
          "to": "eco-s4",
          "label_hi": "वापस घर",
          "label_en": "Back home"
        }
      ]
    },
    "concept_md_hi": "### सभी 3 पड़ोसियों के नाम ट्रिक से याद करें!\n- **W = Williams** → **Leaves (पत्ते जलाना)** + **Compost / Nose pollution**\n- **G = Greene** → **Garden (बगीचा)** + **Gum wrapper** + **Dog on leash**\n- **J = Johnson** → **Journey by car (2 blocks to Post Office)** + **Motorbike & Snowmobile**\n- **Home (माँ)** → **Electric mixer** बनाम **27 hours TV**!",
    "concept_md_en": "### Super-Easy Memory Codes for the 3 Neighbours!\n- **Williams** → Burning **leaves** vs **compost / nose pollution**\n- **Greene** → **Garden** dug by Jim's **dog** + **gum wrapper** + saves newspapers/cans\n- **Johnson** → Drives **2 blocks** to **post office** vs Jim's **motorbike & snowmobile**\n- **Mother** → **Electric mixer** vs Jim watching **TV 27 hours a day**!",
    "exam_tip_hi": "यह ट्रिक एक भी MCQ गलत नहीं होने देगी: **Greene = Garden/Gum**, **Williams = Leaves/Compost**, **Johnson = Post Office (2 blocks)**!",
    "exam_tip_en": "Zero-error code: **Greene = Garden/Gum**, **Williams = Leaves/Compost**, **Johnson = Post Office (2 blocks)**!",
    "glossary_terms": [
      {
        "term_hi": "Preach (प्रीच)",
        "term_en": "Preach",
        "pronunciation_hi": "प्रीच",
        "definition_hi": "दूसरों को नैतिक उपदेश देना।",
        "definition_en": "To lecture or give moral advice to others."
      },
      {
        "term_hi": "Pollution (पॉल्यूशन)",
        "term_en": "Pollution",
        "pronunciation_hi": "पॉल्यूशन",
        "definition_hi": "वायु, जल या पर्यावरण का दूषित होना।",
        "definition_en": "Contamination of air, water, or soil with harmful waste."
      }
    ],
    "quick_check": {
      "q_hi": "मिस्टर जॉनसन के घर से डाकघर (Post Office) कितनी दूर था?",
      "q_en": "How far was the post office from Mr. Johnson's house?",
      "answer_hi": "केवल **दो ब्लॉक (two blocks)** दूर।",
      "answer_en": "Only **two blocks** away."
    }
  },
  {
    "id": "eco-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "नीचे के 4 वाक्यों को उच्चारण के साथ दो बार पढ़िए — कहानी की पूरी अंग्रेज़ी आपकी जेब में होगी!",
    "analogy_en": "Read these 4 key lines aloud twice — they cover the heart of the entire chapter!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "पाठ की मुख्य पंक्तियाँ (उच्चारण + हिंदी अर्थ)",
      "title_en": "Key Lines from Me and the Ecology Bit",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "Everybody is in favour of ecology, but nobody wants to do anything.",
            "एवरीबडी इज़ इन फ़ेवर ऑफ़ इकोलॉजी, बट नोबडी वॉन्ट्स टु डू एनीथिंग।",
            "हर कोई पर्यावरण के पक्ष में है, पर करना कोई नहीं चाहता।"
          ],
          "cells_en": [
            "Everybody is in favour of ecology, but nobody wants to do anything.",
            "Ev-ri-ba-di iz in fe-var ov i-ko-lo-jee, bat no-ba-di wonts too doo e-ni-thing.",
            "Central theme of hypocrisy in the story."
          ]
        },
        {
          "cells_hi": [
            "Burning leaves is bad for the air and ecology.",
            "बर्निंग लीव्ज़ इज़ बैड फ़ॉर द एयर ऐंड इकोलॉजी।",
            "पत्ते जलाना हवा और पारिस्थितिकी के लिए बुरा है।"
          ],
          "cells_en": [
            "Burning leaves is bad for the air and ecology.",
            "Bar-ning leevz iz bad for the e-yar and i-ko-lo-jee.",
            "Jim's advice to Mr. Williams."
          ]
        },
        {
          "cells_hi": [
            "Save electricity by using the old eggbeater.",
            "सेव इलेक्ट्रिसिटी बाई यूज़िंग द ओल्ड एगबीटर।",
            "पुराने अंडा-फेंटने वाले उपकरण का उपयोग कर बिजली बचाओ।"
          ],
          "cells_en": [
            "Save electricity by using the old eggbeater.",
            "Sev i-lek-tri-si-tee baai yoo-zing the old eg-bee-tar.",
            "Jim lecturing his own mother."
          ]
        },
        {
          "cells_hi": [
            "Preaching about ecology is easy, but abiding by its rules is hard.",
            "प्रीचिंग अबाउट इकोलॉजी इज़ ईज़ी, बट अबाइडिंग बाई इट्स रूल्स इज़ हार्ड।",
            "इकोलॉजी पर उपदेश देना आसान है, पर नियम मानना कठिन।"
          ],
          "cells_en": [
            "Preaching about ecology is easy, but abiding by its rules is hard.",
            "Pree-ching a-baut i-ko-lo-jee iz ee-zee, bat a-baai-ding baai its roolz iz haard.",
            "Golden exam takeaway of the chapter."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Ecology** (*इकोलॉजी*) = पारिस्थितिकी\n2. **Garbage** (*गार्बेज*) = कचरा\n3. **Electricity** (*इलेक्ट्रिसिटी*) = बिजली\n4. **Wrapper** (*रैपर*) = कागज़ या पन्नी का आवरण\n5. **Environment** (*एनवायरनमेंट*) = पर्यावरण\n6. **Abide** (*अबाइड*) = नियम का पालन करना",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Ecology** (*इकोलॉजी*) = environmental balance\n2. **Garbage** (*गार्बेज*) = waste / trash\n3. **Electricity** (*इलेक्ट्रिसिटी*) = electric power\n4. **Wrapper** (*रैपर*) = outer cover of gum/candy\n5. **Environment** (*एनवायरनमेंट*) = natural surroundings\n6. **Abide** (*अबाइड*) = obey or follow rules",
    "exam_tip_hi": "स्पेलिंग ध्यान रखें: **W-r-a-p-p-e-r** में शुरू का **W** मौन (silent) होता है → उच्चारण **रैपर**!",
    "exam_tip_en": "Pronunciation check: the \"w\" in **wrapper** is silent (*रैपर*)!",
    "glossary_terms": [
      {
        "term_hi": "Garbage (गार्बेज)",
        "term_en": "Garbage",
        "pronunciation_hi": "गार्बेज",
        "definition_hi": "घरेलू कचरा या कूड़ा-करकट।",
        "definition_en": "Household rubbish or waste."
      },
      {
        "term_hi": "Leash (लीश)",
        "term_en": "Leash",
        "pronunciation_hi": "लीश",
        "definition_hi": "कुत्ते को बाँधकर रखने का पट्टा या डोरी।",
        "definition_en": "A strap or rope used to keep a dog under control."
      }
    ]
  },
  {
    "id": "eco-sec-4-summary",
    "order": 4,
    "heading_hi": "4. कथनी बनाम करनी तालिका व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Words vs Actions Table & 5-Mark Summary Formula",
    "analogy_hi": "इस कहानी का असली सबक एक हिंदी कहावत में छिपा है — **\"पर उपदेश कुशल बहुतेरे\"** (दूसरों को सीख देना आसान, खुद करना कठिन)!",
    "analogy_en": "The whole story boils down to one golden proverb: **Practise what you preach!**",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "जिम की कथनी बनाम जिम की करनी",
      "title_en": "What Jim Preaches vs What Jim Actually Does",
      "headers_hi": [
        "जिम दूसरों को क्या कहता है",
        "जिम खुद क्या गलती करता है"
      ],
      "headers_en": [
        "What Jim Tells Others",
        "What Jim Does Himself"
      ],
      "rows": [
        {
          "cells_hi": [
            "कचरा मत फैलाओ और प्रकृति बचाओ",
            "मिस ग्रीन के लॉन पर च्युइंग-गम का रैपर फेंकता है; उसका कुत्ता बगीचा खोदता है"
          ],
          "cells_en": [
            "Keep the earth clean and green",
            "Drops gum wrappers on Ms. Greene's lawn; lets dog dig her garden"
          ]
        },
        {
          "cells_hi": [
            "मिस्टर जॉनसन, कार मत चलाओ — पैदल चलो!",
            "खुद गर्मी में मोटरबाइक और सर्दी में स्नोमोबाइल चलाता है"
          ],
          "cells_en": [
            "Don't drive your car, Mr. Johnson!",
            "Rides a motorbike all summer and a snowmobile all winter"
          ]
        },
        {
          "cells_hi": [
            "माँ, मिक्सर बंद कर बिजली बचाओ!",
            "खुद पूरा दिन टीवी चलाकर बिजली खर्च करता है"
          ],
          "cells_en": [
            "Save electricity by skipping the mixer!",
            "Watches TV non-stop (\"27 hours a day\")"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"Me and the Ecology Bit\"** is a humorous story written by **Joan Lexau**.\n2. The narrator **Jim** runs a paper route and advises his neighbours to protect ecology.\n3. He tells **Mr. Williams** not to burn leaves, **Ms. Greene** to save paper, and **Mr. Johnson** not to drive two blocks to the post office.\n4. In return, they expose Jim's own bad habits — his dog, gum wrappers, motorbike, and watching TV all day.\n5. The story teaches that **preaching about ecology is easy, but practising it ourselves is difficult**.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"Me and the Ecology Bit\"** is a humorous story written by **Joan Lexau**.\n2. The narrator **Jim** runs a paper route and advises his neighbours to protect ecology.\n3. He tells **Mr. Williams** not to burn leaves, **Ms. Greene** to save paper, and **Mr. Johnson** not to drive two blocks to the post office.\n4. In return, they expose Jim's own bad habits — his dog, gum wrappers, motorbike, and watching TV all day.\n5. The story teaches that **preaching about ecology is easy, but practising it ourselves is difficult**.",
    "exam_tip_hi": "बोर्ड कॉपी में तीनों पड़ोसियों के नाम (**Mr. Williams, Ms. Greene, Mr. Johnson**) सही स्पेलिंग के साथ लिखें — 5/5 पक्के!",
    "exam_tip_en": "Spell all 3 neighbours accurately (**Mr. Williams, Ms. Greene, Mr. Johnson**) for full 5/5 marks!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "जिम की माँ ने उस पर क्या व्यंग्य किया जब उसने बिजली बचाने को कहा?",
      "q_en": "How did Jim's mother tease him when he told her to save electricity?",
      "answer_hi": "उन्होंने पूछा — **\"यहाँ दिन में 27 घंटे टीवी कौन देखता है?\"**",
      "answer_en": "She asked: **\"Who watches TV twenty-seven hours a day around here?\"**"
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Author",
      "fact_hi": "जोन लेक्साऊ (Joan Lexau, 1929–2023) · अमेरिकी लेखिका",
      "fact_en": "Joan Lexau (1929–2023) · American Author"
    },
    {
      "tag": "Narrator",
      "fact_hi": "जिम (Jim) — शनिवार को अख़बार बाँटने वाला लड़का",
      "fact_en": "Jim — Young boy running a Saturday paper route"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Me and the Ecology Bit is a witty story by Joan Lexau.",
      "fact_en": "Me and the Ecology Bit is a witty story by Joan Lexau."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "Jim preaches ecology to his neighbours on his paper route.",
      "fact_en": "Jim preaches ecology to his neighbours on his paper route."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "He advises Mr. Williams, Ms. Greene, Mr. Johnson, and his mother.",
      "fact_en": "He advises Mr. Williams, Ms. Greene, Mr. Johnson, and his mother."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "Everyone points out Jim's own careless habits like motorbike and TV.",
      "fact_en": "Everyone points out Jim's own careless habits like motorbike and TV."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "True ecology begins when we practise what we preach.",
      "fact_en": "True ecology begins when we practise what we preach."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "मिस्टर विलियम्स और मिस्टर जॉनसन की घटनाएँ आपस में बदल देना।",
      "mistake_en": "Swapping Mr. Williams's and Mr. Johnson's incidents.",
      "fix_hi": "याद रखें: **Williams = Leaves (पत्ते जलाना)**, **Johnson = Car to Post Office (2 blocks)**!",
      "fix_en": "Keep straight: **Williams = burning leaves**, **Johnson = driving 2 blocks to post office**!"
    },
    {
      "mistake_hi": "कहानी के कथावाचक का नाम \"Joan\" लिख देना।",
      "mistake_en": "Calling the narrator \"Joan\" instead of \"Jim\".",
      "fix_hi": "**Joan Lexau** लेखिका हैं, जबकि कहानी बोलने वाला लड़का **Jim** है!",
      "fix_en": "**Joan Lexau** is the author; **Jim** is the boy narrator!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "जिम के तीनों पड़ोसियों की प्रतिक्रियाएँ",
      "topic_en": "Reactions of Mr. Williams, Ms. Greene & Mr. Johnson",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    },
    {
      "topic_hi": "पर्यावरण पर उपदेश देना आसान, पालन कठिन (सारांश)",
      "topic_en": "Preaching vs Practising Ecology (Summary)",
      "years": [
        "2022",
        "2024"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-10-eng-ch2',
  2,
  'छात्र "Me and the Ecology Bit" के सभी पात्रों (Jim, Mr. Williams, Ms. Greene, Mr. Johnson) को याद कर सकेंगे, "Ecology" व पर्यावरण शब्दावली बोल सकेंगे और 5-वाक्य सारांश लिख सकेंगे।',
  'Students will recall Jim and his 3 neighbours clearly, pronounce environmental vocabulary confidently, and write clean 2M/5M board answers.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "पर्यावरण हुक, उच्चारण अभ्यास व 4-पड़ाव ब्लैकबोर्ड चार्ट",
    "phase_en": "Ecology Hook, Pronunciation & 4-Stop Story Map",
    "teacher_action_hi": "पूछें: \"क्या हम कभी दूसरों को सफाई सिखाकर खुद कचरा फेंक देते हैं?\" फिर जिम की कहानी सुनाएँ। Ecology (इकोलॉजी), Compost (कम्पोस्ट), Pollution (पॉल्यूशन), Wrapper (रैपर) का सामूहिक उच्चारण कराएँ और बोर्ड पर W-G-J ट्रिक लिखें।",
    "teacher_action_en": "Ask students if preaching cleanliness is easier than practising it. Narrate Jim's paper route. Drill Ecology, Compost, Pollution, Wrapper and write the W-G-J neighbour key on the board.",
    "student_check_hi": "पूछें: \"पत्ते कौन जला रहा था और कार से डाकघर कौन जा रहा था?\"",
    "student_check_en": "Ask: \"Who was burning leaves, and who drove to the post office?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "रोल-प्ले संवाद, 5-मिनट मौखिक आत्मविश्वास गतिविधि व सारांश",
    "phase_en": "Mini Role-Play, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "4 छात्रों को Jim, Mr. Williams, Ms. Greene और Mr. Johnson बनाकर 1-1 मज़ेदार वाक्य बुलवाएँ। 5-मिनट मौखिक गतिविधि में कमजोर छात्र 5-वाक्य सारांश बोलें। अंत में 5 मैट्रिक MCQ हल कराएँ।",
    "teacher_action_en": "Assign 4 students to enact Jim and his 3 neighbours in 1 line each. Run a 5-min oral drill on the 5-sentence summary, closing with 5 Matric MCQs.",
    "student_check_hi": "पूछें: \"जिम किस दिन अख़बार के पैसे वसूलने जाता था?\" (Saturday)",
    "student_check_en": "Ask: \"On which day did Jim collect money on his paper route?\" (Saturday)"
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड W-G-J कोड (Me and the Ecology Bit)",
    "heading_en": "Blackboard W-G-J Code (Me and the Ecology Bit)",
    "points_hi": [
      "लेखिका: Joan Lexau | कथावाचक: Jim (Saturday Paper Route)",
      "W (Mr. Williams) → Burning leaves vs Compost (\"nose pollution\")",
      "G (Ms. Greene) → Garden dug by dog + Gum wrapper",
      "J (Mr. Johnson) → Car to Post Office (2 blocks) vs Jim's motorbike/snowmobile"
    ],
    "points_en": [
      "Author: Joan Lexau | Narrator: Jim (Saturday Paper Route)",
      "W (Mr. Williams) -> Burning leaves vs Compost (\"nose pollution\")",
      "G (Ms. Greene) -> Dog digs garden + Gum wrapper",
      "J (Mr. Johnson) -> Drives 2 blocks vs Jim's motorbike & snowmobile"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"मेरा 1 इकोलॉजी वादा\" मौखिक गतिविधि",
    "title_en": "5-Minute \"My 1 Ecology Promise\" Speaking Circle",
    "materials_hi": "ब्लैकबोर्ड वाक्य-ढाँचा: \"I will save ecology by...\"",
    "materials_en": "Board prompt: \"I will protect ecology by...\"",
    "steps_hi": "प्रत्येक छात्र एक सरल पर्यावरण आदत बोलें (जैसे \"I will switch off the fan\", \"I will plant a tree\") ताकि अंग्रेज़ी बोलने का डर दूर हो।",
    "steps_en": "Each shy student speaks one short English promise (\"I will plant a tree\", \"I will save water\") to build speaking confidence."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Ecology, Compost, Garbage, Pollution और Wrapper को अर्थ व उच्चारण सहित लिखें।",
    "task_en": "Write Ecology, Compost, Garbage, Pollution, and Wrapper with meanings and pronunciations."
  },
  {
    "level": "BOARD",
    "task_hi": "मिस्टर विलियम्स ने जिम की खाद बनाने की सलाह क्यों नहीं मानी? 2–3 वाक्यों में लिखें।",
    "task_en": "Why did Mr. Williams reject Jim's compost idea? Write 2–3 sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "5-वाक्य फ़ॉर्मूले की सहायता से \"Me and the Ecology Bit\" का सारांश लिखें।",
    "task_en": "Write a neat 5-sentence summary of \"Me and the Ecology Bit\"."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र समझते हैं कि जिम एक आदर्श पर्यावरण-रक्षक है जिसकी कोई गलती नहीं है।",
    "misconception_en": "Students think Jim is a flawless eco-hero.",
    "correction_hi": "स्पष्ट करें कि कहानी का असली हास्य यही है कि जिम खुद मोटरबाइक चलाता है, रैपर फेंकता है और दिन भर टीवी देखता है!",
    "correction_en": "Highlight the irony: Jim himself litters gum wrappers, rides a motorbike, and watches TV endlessly!"
  },
  {
    "misconception_hi": "छात्र \"27 hours a day\" को सच मानकर उलझ जाते हैं।",
    "misconception_en": "Students get confused by \"27 hours a day\" since a day has 24 hours.",
    "correction_hi": "बताएँ कि माँ का यह वाक्य एक मज़ेदार अतिशयोक्ति (humorous exaggeration) है जिसका अर्थ है \"हर समय टीवी देखना\"!",
    "correction_en": "Explain it is a humorous exaggeration meaning Jim watches TV non-stop!"
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
  (
    '10000007-0002-4000-8000-000000000001', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Author & Narrator', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2023',
    'Me and the Ecology Bit की लेखिका और कथावाचक कौन हैं?',
    'Who is the author and who is the narrator of "Me and the Ecology Bit"?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"Me and the Ecology Bit\" की लेखिका और कथावाचक लड़के का नाम बताएँ।",
  "front_en": "Name the author and the boy narrator of \"Me and the Ecology Bit\".",
  "back_hi": "लेखिका: Joan Lexau (अमेरिकी लेखिका) · कथावाचक: Jim (अख़बार बाँटने वाला लड़का)।",
  "back_en": "Author: Joan Lexau (American author) · Narrator: Jim (paper-route boy).",
  "pronunciation_hi": "मी ऐंड द इकोलॉजी बिट — जोन लेक्साऊ",
  "mnemonic_hi": "दोनों नाम \"J\" से शुरू होते हैं: Author = Joan, Boy = Jim!",
  "mnemonic_en": "Both start with \"J\": Author = Joan, Narrator = Jim!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000002', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Ecology और Compost का उच्चारण व अर्थ क्या है?',
    'Give the pronunciation and meaning of Ecology and Compost.',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Ecology और Compost का हिंदी उच्चारण व अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Ecology\" and \"Compost\".",
  "back_hi": "Ecology (इकोलॉजी) = पारिस्थितिकी / पर्यावरण संतुलन · Compost (कम्पोस्ट) = सूखे पत्तों व कचरे से बनी प्राकृतिक खाद।",
  "back_en": "Ecology = science of environmental balance · Compost = natural fertilizer made from decayed leaves.",
  "pronunciation_hi": "इकोलॉजी · कम्पोस्ट",
  "mnemonic_hi": "सूखे पत्ते जलाओ मत — Compost (खाद) बनाओ!",
  "mnemonic_en": "Don't burn dry leaves — turn them into Compost!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000003', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Neighbours Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2024',
    'जिम के पड़ोसियों व माँ को उनकी सही घटना से मिलाएँ:',
    'Match each person in Column A with the exact incident in Column B:',
    NULL, NULL,
    'W-G-J ट्रिक याद करें: Williams, Greene, Johnson और Mother।', 'Use the W-G-J code plus Jim''s Mother.',
    'Williams पत्ते जलाते हैं, Greene कुत्ते व रैपर की शिकायत करती हैं, Johnson 2 ब्लॉक कार से जाते हैं, माँ इलेक्ट्रिक मिक्सर चलाती हैं।', 'Williams burns leaves, Greene complains about dog/gum wrapper, Johnson drives 2 blocks, Mother uses electric mixer.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each character to their incident",
  "pairs": [
    {
      "id": "eco-m1",
      "left_hi": "Mr. Williams",
      "left_en": "Mr. Williams",
      "right_hi": "सूखे पत्ते जलाना व गंध प्रदूषण की शिकायत",
      "right_en": "Burning leaves & complaining of nose pollution"
    },
    {
      "id": "eco-m2",
      "left_hi": "Ms. Greene",
      "left_en": "Ms. Greene",
      "right_hi": "जिम के कुत्ते और च्युइंग-गम रैपर की शिकायत",
      "right_en": "Complaining about Jim's dog & gum wrapper"
    },
    {
      "id": "eco-m3",
      "left_hi": "Mr. Johnson",
      "left_en": "Mr. Johnson",
      "right_hi": "केवल 2 ब्लॉक दूर डाकघर कार से जाना",
      "right_en": "Driving his car 2 blocks to the post office"
    },
    {
      "id": "eco-m4",
      "left_hi": "Jim's Mother",
      "left_en": "Jim's Mother",
      "right_hi": "इलेक्ट्रिक मिक्सर बनाम 27 घंटे टीवी का व्यंग्य",
      "right_en": "Electric mixer vs 27-hours-a-day TV joke"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000004', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही वाक्य सजाएँ: "पत्ते जलाना हवा के लिए बुरा है।"',
    'Build the sentence: "Burning leaves is bad for the air"',
    NULL, NULL,
    'Gerund Subject ("Burning leaves") एकवचन माना जाता है, इसलिए "is" लगेगा।', 'Gerund phrase "Burning leaves" takes singular verb "is".',
    'सही वाक्य: "Burning leaves is bad for the air"।', 'Correct sentence: "Burning leaves is bad for the air".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "पत्ते जलाना हवा के लिए बुरा है।",
  "prompt_en": "Build Jim's advice to Mr. Williams",
  "grammar_formula": "V-ing + Object + is + Adjective + for + the + Noun",
  "tokens": [
    "Burning",
    "leaves",
    "is",
    "bad",
    "for",
    "the",
    "air"
  ],
  "distractors": [
    "are",
    "good"
  ],
  "correct_sentence": "Burning leaves is bad for the air",
  "pronunciation_hi": "बर्निंग लीव्ज़ इज़ बैड फ़ॉर द एयर"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000005', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "जिम लोगों को पारिस्थितिकी के बारे में उपदेश देता है।"',
    'Build the sentence: "Jim preaches to people about ecology"',
    NULL, NULL,
    'Singular subject "Jim" के साथ Present verb में "es" (preaches) जुड़ेगा।', 'Use singular verb "preaches" with "Jim".',
    'सही वाक्य: "Jim preaches to people about ecology"।', 'Correct sentence: "Jim preaches to people about ecology".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "जिम लोगों को पारिस्थितिकी के बारे में उपदेश देता है।",
  "prompt_en": "Build a clean summary sentence for your exam",
  "grammar_formula": "Subject + V1(es) + to + Object + about + Topic",
  "tokens": [
    "Jim",
    "preaches",
    "to",
    "people",
    "about",
    "ecology"
  ],
  "distractors": [
    "preach",
    "at"
  ],
  "correct_sentence": "Jim preaches to people about ecology",
  "pronunciation_hi": "जिम प्रीचेज़ टु पीपल अबाउट इकोलॉजी"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000006', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Author MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    '"Me and the Ecology Bit" की लेखिका कौन हैं?',
    'Who wrote "Me and the Ecology Bit"?',
    $json$[{"key":"A","text_hi":"महादेवी वर्मा","text_en":"Mahadevi Varma"},{"key":"B","text_hi":"जोन लेक्साऊ","text_en":"Joan Lexau"},{"key":"C","text_hi":"आर.सी. हचिंसन","text_en":"R.C. Hutchinson"},{"key":"D","text_hi":"टोनी मॉरिसन","text_en":"Toni Morrison"}]$json$::jsonb, 'B',
    'दोनों "J" नाम याद करें: Joan और Jim!', 'Use the "J" hook: Joan Lexau & Jim!',
    '"Me and the Ecology Bit" अमेरिकी लेखिका जोन लेक्साऊ (Joan Lexau) ने लिखा है।', '"Me and the Ecology Bit" was written by Joan Lexau.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000007', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Narrator Name MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2022',
    '"Me and the Ecology Bit" में अख़बार बाँटने वाले लड़के का नाम क्या है?',
    'What is the name of the young narrator who has a paper route?',
    $json$[{"key":"A","text_hi":"सैम (Sam)","text_en":"Sam"},{"key":"B","text_hi":"जॉन (John)","text_en":"John"},{"key":"C","text_hi":"टॉम (Tom)","text_en":"Tom"},{"key":"D","text_hi":"जिम (Jim)","text_en":"Jim"}]$json$::jsonb, 'D',
    'तीन अक्षरों का नाम जो J से शुरू होता है।', 'Short 3-letter name starting with J.',
    'कथावाचक लड़के का नाम जिम (Jim) है।', 'The young narrator is Jim.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000008', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Mr. Williams Incident', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'जब जिम मिस्टर विलियम्स के घर पहुँचा, तो वे क्या कर रहे थे?',
    'What was Mr. Williams doing when Jim visited his house?',
    $json$[{"key":"A","text_hi":"अख़बार पढ़ रहे थे","text_en":"Reading a newspaper"},{"key":"B","text_hi":"पौधे लगा रहे थे","text_en":"Planting trees"},{"key":"C","text_hi":"सूखे पत्ते जला रहे थे","text_en":"Burning dry leaves"},{"key":"D","text_hi":"कार धो रहे थे","text_en":"Washing his car"}]$json$::jsonb, 'C',
    'जिम ने उन्हें खाद (compost pile) बनाने की सलाह दी।', 'Jim advised him to make a compost pile instead.',
    'मिस्टर विलियम्स अपने पिछवाड़े में सूखे पत्ते जला रहे थे।', 'Mr. Williams was burning dry leaves in his backyard.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000009', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Mr. Johnson Distance', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'मिस्टर जॉनसन के घर से डाकघर (Post Office) कितनी दूरी पर था?',
    'How far was the post office from Mr. Johnson''s house?',
    $json$[{"key":"A","text_hi":"दो ब्लॉक","text_en":"Two blocks"},{"key":"B","text_hi":"पाँच ब्लॉक","text_en":"Five blocks"},{"key":"C","text_hi":"दस मील","text_en":"Ten miles"},{"key":"D","text_hi":"एक ब्लॉक","text_en":"One block"}]$json$::jsonb, 'A',
    'इतनी कम दूरी जिसके लिए पैदल जाना आसान था।', 'A very short walking distance.',
    'डाकघर मिस्टर जॉनसन के घर से केवल दो ब्लॉक (two blocks) दूर था।', 'The post office was only two blocks away from Mr. Johnson''s house.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000010', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Ms. Greene Complaint', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'मिस ग्रीन (Ms. Greene) ने जिम से उसके लॉन से क्या उठाने को कहा?',
    'What did Ms. Greene ask Jim to pick up from her lawn?',
    $json$[{"key":"A","text_hi":"प्लास्टिक की बोतल","text_en":"A plastic bottle"},{"key":"B","text_hi":"च्युइंग-गम का रैपर (Gum wrapper)","text_en":"A gum wrapper"},{"key":"C","text_hi":"पुराना जूता","text_en":"An old shoe"},{"key":"D","text_hi":"फटा हुआ अख़बार","text_en":"A torn newspaper"}]$json$::jsonb, 'B',
    'जिम ने उसे अभी-अभी ज़मीन पर फेंका था!', 'Something small Jim had just littered on her grass.',
    'मिस ग्रीन ने जिम से उसके लॉन पर गिराया गया च्युइंग-गम का रैपर (gum wrapper) उठाने को कहा।', 'Ms. Greene told Jim to pick up the gum wrapper he had dropped on her lawn.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000011', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Exam Pool: Paper Collection Day', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2023',
    'जिम किस दिन अपने ग्राहकों से अख़बार के पैसे वसूलने जाता था?',
    'On which day of the week did Jim collect money on his paper route?',
    $json$[{"key":"A","text_hi":"सोमवार (Monday)","text_en":"Monday"},{"key":"B","text_hi":"बुधवार (Wednesday)","text_en":"Wednesday"},{"key":"C","text_hi":"शनिवार (Saturday)","text_en":"Saturday"},{"key":"D","text_hi":"रविवार (Sunday)","text_en":"Sunday"}]$json$::jsonb, 'C',
    'सप्ताहांत का पहला दिन (स्कूल की छुट्टी का दिन)।', 'The first day of the weekend.',
    'जिम हर शनिवार (Saturday) को अख़बार के पैसे वसूलने और इकोलॉजी की बात करने जाता था।', 'Jim went collecting on Saturdays.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000012', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Exam Pool: Jim''s Vehicles', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'मिस्टर जॉनसन के अनुसार जिम गर्मियों और सर्दियों में कौन-से वाहन चलाकर प्रदूषण फैलाता है?',
    'According to Mr. Johnson, which two vehicles does Jim drive in summer and winter?',
    $json$[{"key":"A","text_hi":"ट्रक और ट्रैक्टर","text_en":"Truck and tractor"},{"key":"B","text_hi":"कार और बस","text_en":"Car and bus"},{"key":"C","text_hi":"साइकिल और नाव","text_en":"Bicycle and boat"},{"key":"D","text_hi":"मोटरबाइक और स्नोमोबाइल","text_en":"Motorbike and snowmobile"}]$json$::jsonb, 'D',
    'गर्मी में दो-पहिया और बर्फ़ में चलने वाली गाड़ी!', 'A two-wheeler in summer and a snow vehicle in winter.',
    'मिस्टर जॉनसन बताते हैं कि जिम गर्मी भर मोटरबाइक और सर्दी भर स्नोमोबाइल चलाता है।', 'Mr. Johnson points out Jim rides a motorbike all summer and a snowmobile all winter.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000013', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Williams & Compost 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'जिम ने मिस्टर विलियम्स को क्या सलाह दी और उन्होंने क्या जवाब दिया?',
    'What did Jim advise Mr. Williams to do, and how did Mr. Williams reply?',
    NULL, NULL,
    'पत्ते जलाने के बजाय खाद (compost) बनाना और "गंध प्रदूषण (nose pollution)" लिखें।', 'Mention compost pile instead of burning leaves, and Mr. Williams''s "nose pollution" reply.',
    NULL, NULL,
    'जब जिम ने मिस्टर विलियम्स को सूखे पत्ते जलाते देखा, तो उसने कहा कि पत्ते जलाना हवा के लिए बुरा है और उन्हें **खाद का ढेर (compost pile)** बनाना चाहिए। मिस्टर विलियम्स ने मना कर दिया और कहा कि जिम की खाद से पूरी गली में बदबू यानी **"गंध प्रदूषण (nose pollution)"** फैलता है।', 'Seeing Mr. Williams burning dry leaves, Jim told him it was bad for the air and advised him to make a **compost pile** instead. Mr. Williams refused, complaining that Jim''s compost pile smelled up the whole street and caused **"nose pollution"**.',
    $json$[{"cue_hi":"जिम: पत्ते मत जलाओ, compost बनाओ","cue_en":"Jim: Make compost, don't burn leaves"},{"cue_hi":"विलियम्स: compost से nose pollution होता है","cue_en":"Williams: Compost causes nose pollution"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"जिम की सलाह (पत्ते न जलाना व compost बनाना)","criterion_en":"States Jim's advice against burning leaves and for compost"},{"step_no":2,"marks":1,"criterion_hi":"मिस्टर विलियम्स का उत्तर (बदबू / nose pollution)","criterion_en":"Mentions Mr. Williams's \"nose pollution\" counter-argument"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0002-4000-8000-000000000014', 'bseb-10-eng', 'bseb-10-eng-ch2', 'Summary & Irony 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"Me and the Ecology Bit" का सारांश लिखें और सिद्ध करें कि पर्यावरण पर उपदेश देना आसान पर पालन कठिन है।',
    'Write the summary of "Me and the Ecology Bit" showing why preaching ecology is easier than practising it.',
    NULL, NULL,
    'जिम, तीनों पड़ोसियों (Williams, Greene, Johnson), माँ के मिक्सर/टीवी और मुख्य सीख को शामिल करें।', 'Cover Jim, Mr. Williams, Ms. Greene, Mr. Johnson, Mom''s mixer/TV joke, and the core moral.',
    NULL, NULL,
    '**"Me and the Ecology Bit"** अमेरिकी लेखिका **जोन लेक्साऊ** की रोचक कहानी है, जो दर्शाती है कि पर्यावरण संरक्षण पर भाषण देना आसान है पर खुद नियम मानना कठिन।

कहानी का कथावाचक **जिम** शनिवार को अख़बार के पैसे वसूलते समय सबको इकोलॉजी का उपदेश देता है। वह **मिस्टर विलियम्स** को पत्ते जलाने से रोककर खाद बनाने कहता है, तो वे खाद की बदबू को "नोज़ पॉल्यूशन" कहते हैं। **मिस ग्रीन** उसे अपने कुत्ते को बाँधने और लॉन से च्युइंग-गम का रैपर उठाने कहती हैं। **मिस्टर जॉनसन** को 2 ब्लॉक दूर डाकघर कार से जाने पर टोकने पर वे जिम की मोटरबाइक व स्नोमोबाइल की पोल खोल देते हैं। घर लौटकर जब वह माँ को मिक्सर बंद करने कहता है, तो माँ पूछती हैं — *"27 घंटे टीवी कौन देखता है?"*

निष्कर्षतः पर्यावरण की रक्षा तभी संभव है जब हम **दूसरों को उपदेश देने से पहले स्वयं उसका पालन करें**।', '**"Me and the Ecology Bit"** is a humorous story by **Joan Lexau** highlighting that while everyone supports ecology, very few practise it.

The young narrator **Jim** runs a Saturday paper route and lectures his neighbours on saving the environment. He tells **Mr. Williams** not to burn leaves, **Ms. Greene** to save paper, and **Mr. Johnson** not to drive two blocks to the post office. Each neighbour exposes Jim''s own carelessness: Mr. Williams complains of compost odour, Ms. Greene points to Jim''s dog and gum wrapper, and Mr. Johnson reminds him of his motorbike and snowmobile. Finally, when Jim tells his mother not to use an electric mixer, she teases him for watching TV "twenty-seven hours a day".

Thus, the story teaches a clear lesson: **preaching about ecology is easy, but abiding by its rules ourselves is what truly matters**.',
    $json$[{"cue_hi":"Joan Lexau · Jim (paper route)","cue_en":"Joan Lexau · Jim (paper route)"},{"cue_hi":"Williams (leaves), Greene (dog/gum), Johnson (car 2 blocks)","cue_en":"Williams (leaves), Greene (dog/gum), Johnson (car 2 blocks)"},{"cue_hi":"Mother (electric mixer vs 27 hours TV)","cue_en":"Mother (electric mixer vs 27 hours TV)"},{"cue_hi":"Preaching easy, practising hard","cue_en":"Preaching easy, practising hard"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"लेखिका (Joan Lexau) व कथावाचक (Jim) का परिचय","criterion_en":"Names Joan Lexau and narrator Jim"},{"step_no":2,"marks":2,"criterion_hi":"तीनों पड़ोसियों (Williams, Greene, Johnson) की घटनाएँ","criterion_en":"Covers incidents with Mr. Williams, Ms. Greene, and Mr. Johnson"},{"step_no":3,"marks":1,"criterion_hi":"माँ और 27 घंटे टीवी का व्यंग्य","criterion_en":"Mentions Mother's electric mixer vs TV irony"},{"step_no":4,"marks":1,"criterion_hi":"कथनी बनाम करनी का स्पष्ट नैतिक निष्कर्ष","criterion_en":"Concludes with preaching vs practising message"}]$json$::jsonb,
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
-- CHAPTER 3 OF 14: BSEB-10-ENG-CH3 — Gillu — Mahadevi Varma
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-10-eng-ch3',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: गिल्लू (Gillu)",
  "title_en": "30-Second Mindmap: Gillu",
  "read_time_seconds": 30,
  "central_node": {
    "id": "gil-root",
    "label_hi": "गिल्लू (Gillu)",
    "label_en": "Gillu (True Memoir)",
    "subtitle_hi": "महादेवी वर्मा · Panorama Part-2 (कक्षा 10, अध्याय 3)",
    "subtitle_en": "Mahadevi Varma · Panorama Part-2 (Class 10, Ch 3)"
  },
  "branches": [
    {
      "id": "gil-author",
      "label_hi": "1. लेखिका: महादेवी वर्मा",
      "label_en": "1. Author: Mahadevi Varma",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "gil-a1",
          "label_hi": "महादेवी वर्मा (1907–1987) — प्रसिद्ध छायावादी कवयित्री",
          "label_en": "Mahadevi Varma (1907–1987) — Leading Chhayavadi Poet"
        },
        {
          "id": "gil-a2",
          "label_hi": "सम्मान: ज्ञानपीठ पुरस्कार (1982), पद्म भूषण, पद्म विभूषण",
          "label_en": "Awards: Jnanpith (1982), Padma Bhushan, Padma Vibhushan"
        }
      ]
    },
    {
      "id": "gil-rescue",
      "label_hi": "2. बचाव और उपचार (Rescue)",
      "label_en": "2. Rescue & Care",
      "color": "#059669",
      "children": [
        {
          "id": "gil-r1",
          "label_hi": "बरामदे में गमले के पास दो कौओं (two crows) की चोंच से घायल मिला",
          "label_en": "Found wounded near verandah flowerpot attacked by two crows"
        },
        {
          "id": "gil-r2",
          "label_hi": "पेनिसिलिन मरहम लगाया व रुई की बत्ती से दूध पिलाया",
          "label_en": "Treated with penicillin ointment & fed milk via cotton wick"
        }
      ]
    },
    {
      "id": "gil-habits",
      "label_hi": "3. गिल्लू की प्यारी आदतें",
      "label_en": "3. Gillu's Endearing Habits",
      "color": "#D97706",
      "children": [
        {
          "id": "gil-h1",
          "label_hi": "प्रिय भोजन: काजू (Kaju) · आवाज़: \"चिक-चिक\" (Chik-chik)",
          "label_en": "Favourite food: Kaju (cashew) · Sound: \"Chik-chik\""
        },
        {
          "id": "gil-h2",
          "label_hi": "गर्मी में ठंडक के लिए मिट्टी की सुराही (Surahi) पर लेट जाता था",
          "label_en": "Lay flat on the cool earthen surahi on hot summer afternoons"
        },
        {
          "id": "gil-h3",
          "label_hi": "लेखिका के बीमार होने पर उनके बाल व माथा सहलाता था",
          "label_en": "Gently stroked the author's hair & forehead when she was unwell"
        }
      ]
    },
    {
      "id": "gil-end",
      "label_hi": "4. जीवनकाल, विदाई और सोनजुही",
      "label_en": "4. Lifespan, Farewell & Sonjuhi",
      "color": "#7C3AED",
      "children": [
        {
          "id": "gil-e1",
          "label_hi": "गिलहरी का जीवनकाल: मात्र 2 वर्ष (Two years)",
          "label_en": "Lifespan of a squirrel: barely two years"
        },
        {
          "id": "gil-e2",
          "label_hi": "सोनजुही (Sonjuhi) की लता के नीचे समाधि — पीले फूल की आशा",
          "label_en": "Buried under the Sonjuhi creeper — hope of blooming as a yellow flower"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "gil-sec-1-author",
    "order": 1,
    "heading_hi": "1. लेखिका परिचय और हमारे आँगन की गिलहरी से जुड़ाव",
    "heading_en": "1. Author Profile & Heartwarming Connection",
    "analogy_hi": "हमारे बिहार के हर गाँव के बगीचे या अमरूद के पेड़ पर धारीदार छोटी गिलहरियाँ फुदकती दिख जाती हैं! क्या आपने कभी सोचा कि इतनी छोटी-सी गिलहरी भी किसी इंसान से माँ जैसा प्यार कर सकती है, उसके बीमार होने पर खाना छोड़ सकती है और उसके बाल सहला सकती है? **महादेवी वर्मा** की सच्ची कहानी **गिल्लू (Gillu)** हर पढ़ने वाले की आँखें नम कर देती है!",
    "analogy_en": "Every Bihar courtyard has striped little squirrels darting up mango and guava trees! Can a creature that tiny love a human so deeply that it stops eating when she is hospitalized and strokes her forehead? **Mahadevi Varma's** true memoir **Gillu** melts every reader's heart!",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "महादेवी वर्मा — हिंदी साहित्य की महान विभूति",
      "title_en": "Mahadevi Varma — Literary Milestones",
      "events": [
        {
          "year": "1907",
          "title_hi": "जन्म — फर्रुखाबाद (उत्तर प्रदेश)",
          "title_en": "Born — Farrukhabad (Uttar Pradesh)",
          "detail_hi": "आधुनिक हिंदी कविता के \"छायावाद\" युग की प्रमुख स्तंभ।",
          "detail_en": "One of the four pillars of the Chhayavad movement in Hindi poetry."
        },
        {
          "year": "1956",
          "title_hi": "पद्म भूषण सम्मान",
          "title_en": "Padma Bhushan Award",
          "detail_hi": "साहित्य, स्त्री-शिक्षा और जीव-दया के क्षेत्र में अद्वितीय योगदान।",
          "detail_en": "Honoured for literature, women's education, and deep compassion."
        },
        {
          "year": "1982",
          "title_hi": "ज्ञानपीठ पुरस्कार (\"यामा\" के लिए)",
          "title_en": "Jnanpith Award (for \"Yama\")",
          "detail_hi": "भारत का सर्वोच्च साहित्यिक पुरस्कार; \"गिल्लू\" उनके संग्रह \"मेरा परिवार\" से है।",
          "detail_en": "India's highest literary honour; \"Gillu\" comes from her memoir \"Mera Parivar\".",
          "highlight": true
        }
      ]
    },
    "concept_md_hi": "### कहानी का आरंभ — सोनजुही की पीली कली\n- कहानी की शुरुआत **सोनजुही (Sonjuhi)** में लगी एक **पीली कली (yellow bud)** को देखकर होती है, जिसे देखते ही लेखिका को अपने छोटे से साथी **गिल्लू** की याद आ जाती है।\n- वे कौए (Crow) के बारे में मज़ेदार टिप्पणी करती हैं कि भारतीय परंपरा में कौआ एक साथ **आदरणीय (पितृपक्ष में पूर्वजों का रूप)** और **अनादरित (कर्कश बोली के कारण)** — दोनों माना जाता है।\n- तभी बरामदे में गमले के पास **दो कौए** एक नन्हे, घोंसले से गिरे **गिलहरी के बच्चे** पर चोंच मार रहे थे। लेखिका ने उसे बचाया, घाव साफ़ किए, **पेनिसिलिन मरहम (penicillin ointment)** लगाया और रुई की बत्ती से दूध पिलाया।",
    "concept_md_en": "### Opening Scene — The Yellow Sonjuhi Bud\n- Seeing an unexpected **yellow bud on the Sonjuhi creeper** reminds Mahadevi Varma of her tiny pet squirrel, **Gillu**.\n- She playfully remarks on how crows are both respected (honoured during Pitripaksha) and disliked for their harsh cawing.\n- On the verandah beside a flowerpot, she rescued a motionless baby squirrel wounded by **two crows**, gently applied **penicillin ointment**, and fed him warm milk using a thin **cotton wick**.",
    "exam_tip_hi": "मैट्रिक के पक्के प्रश्न: किस पौधे की कली ने गिल्लू की याद दिलाई? → **Sonjuhi**! किस मरहम से इलाज हुआ? → **Penicillin ointment**!",
    "exam_tip_en": "Guaranteed Matric MCQs: Which creeper reminded her of Gillu? → **Sonjuhi**! Which ointment? → **Penicillin ointment**!",
    "glossary_terms": [
      {
        "term_hi": "Ointment (ऑइंटमेंट)",
        "term_en": "Ointment",
        "pronunciation_hi": "ऑइंटमेंट",
        "definition_hi": "घाव पर लगाने वाला औषधीय मरहम।",
        "definition_en": "A smooth healing cream applied to wounds."
      },
      {
        "term_hi": "Lifespan (लाइफ़स्पैन)",
        "term_en": "Lifespan",
        "pronunciation_hi": "लाइफ़स्पैन",
        "definition_hi": "किसी जीव की स्वाभाविक आयु (गिलहरी की = 2 वर्ष)।",
        "definition_en": "The natural length of life of a living creature (2 years for a squirrel)."
      }
    ]
  },
  {
    "id": "gil-sec-2-storyboard",
    "order": 2,
    "heading_hi": "2. विज़ुअल स्टोरीबोर्ड: गिल्लू की 2 साल की प्यारी जीवन-यात्रा",
    "heading_en": "2. Visual Storyboard: Gillu's Two-Year Journey of Love",
    "analogy_hi": "गिल्लू की पूरी ज़िंदगी 4 खूबसूरत चित्रों की तरह आँखों के सामने घूम जाती है — बचाव, शरारती दोस्ती, बीमारी में नर्स जैसी सेवा, और सोनजुही के नीचे अंतिम विश्राम!",
    "analogy_en": "Watch Gillu's heartwarming two-year life unfold in 4 unforgettable scenes — from rescue to playful friendship, nurse-like devotion, and peaceful farewell.",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "गिल्लू की संपूर्ण जीवन-यात्रा (4 चरण)",
      "title_en": "Gillu's Complete Life Story (4 Stages)",
      "direction": "TB",
      "steps": [
        {
          "id": "gil-st1",
          "label_hi": "1. बरामदे में बचाव व नया घर (फूलों की डलिया)",
          "label_en": "1. Rescue & Swing in a Flower Basket",
          "detail_hi": "दो कौओं से बचाया; 3 दिनों में स्वस्थ हुआ; खिड़की पर रुई बिछी फूलों की डलिया में उसका झूला बना।",
          "detail_en": "Rescued from two crows; recovered in 3 days; cotton-lined flower basket hung on the window became his home.",
          "accent": "indigo"
        },
        {
          "id": "gil-st2",
          "label_hi": "2. काजू, चिक-चिक, लिफ़ाफ़ा व ठंडी सुराही",
          "label_en": "2. Kaju, Chik-Chik, Envelope & Cool Surahi",
          "detail_hi": "भूख लगने पर \"चिक-चिक\" बोलकर काजू माँगता; थाली के पास बैठकर 1-1 चावल खाता; गर्मी की दोपहर में ठंडी सुराही पर लेटता।",
          "detail_en": "Chirped \"chik-chik\" for kaju, ate rice grain by grain beside her plate, and rested flat on the cool earthen surahi in summer.",
          "accent": "amber"
        },
        {
          "id": "gil-st3",
          "label_hi": "3. दुर्घटना के समय गिल्लू की नर्स जैसी सेवा",
          "label_en": "3. Nurse-Like Care After the Car Accident",
          "detail_hi": "जब लेखिका अस्पताल में थीं, गिल्लू ने प्रिय काजू नहीं खाए; घर लौटने पर उनके सिरहाने बैठकर बाल व माथा सहलाता रहा।",
          "detail_en": "While the author was hospitalized, Gillu refused his favourite kaju; once home, he gently stroked her hair and forehead.",
          "accent": "emerald"
        },
        {
          "id": "gil-st4",
          "label_hi": "4. दो वर्ष बाद विदाई और सोनजुही के नीचे समाधि",
          "label_en": "4. Farewell After Two Years & Sonjuhi Burial",
          "detail_hi": "अंतिम रात झूले से उतरकर लेखिका की उँगली थाम ली; सुबह चल बसा। उसे प्रिय सोनजुही की लता के नीचे दफ़नाया गया।",
          "detail_en": "On his final night he clutched her finger with icy claws; buried beneath the Sonjuhi creeper he loved most.",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "gil-st1",
          "to": "gil-st2",
          "label_hi": "प्यारी दोस्ती",
          "label_en": "Playful bond"
        },
        {
          "from": "gil-st2",
          "to": "gil-st3",
          "label_hi": "गहरा स्नेह",
          "label_en": "Deep empathy"
        },
        {
          "from": "gil-st3",
          "to": "gil-st4",
          "label_hi": "दो वर्ष पूर्ण",
          "label_en": "2 years end"
        }
      ]
    },
    "concept_md_hi": "### गिल्लू की 4 सबसे प्यारी विशेषताएँ (2-अंक प्रश्नों की जान!)\n1. **लिफ़ाफ़े की सज़ा:** लेखिका का ध्यान खींचने के लिए गिल्लू परदे पर ऊपर-नीचे भागता था। शरारत रोकने को लेखिका उसे लंबे **लिफ़ाफ़े (envelope)** में रख देतीं — केवल सिर बाहर रहता और वह शांत होकर उन्हें लिखते देखता!\n2. **थाली के पास भोजन:** अन्य पालतू पशुओं के विपरीत, गिल्लू लेखिका की **थाली (plate)** के पास बैठकर बड़ी सफ़ाई से **एक-एक दाना चावल** उठाकर खाता था।\n3. **गर्मी का उपाय:** तेज़ गर्मी में बाहर न जा पाने पर वह **मिट्टी की सुराही (surahi)** पर चिपककर लेट जाता — जिससे ठंडक भी मिलती और वह लेखिका के पास भी रहता!\n4. **खिड़की की जाली:** वसंत में जब बाहर की गिलहरियाँ उसे बुलातीं, तो लेखिका ने खिड़की की **जाली का एक कोना खोल दिया** ताकि गिल्लू आज़ादी से खेलकर शाम 4 बजे वापस आ सके।",
    "concept_md_en": "### 4 Memorable Details About Gillu\n1. **Inside an Envelope:** To stop his curtain tricks while she wrote, the author tucked Gillu into a long **envelope** with just his tiny head poking out!\n2. **At the Dining Table:** Unlike other pets, Gillu sat beside her **plate**, neatly picking up and eating **one grain of rice** at a time.\n3. **Summer Trick:** On hot afternoons, Gillu lay stretched on the cool **earthen surahi** to stay cool while remaining close to the author.\n4. **Freedom via Window Mesh:** Opening a corner of the wire mesh let Gillu play outside with other squirrels and return punctually at 4 p.m.",
    "exam_tip_hi": "ये 4 शब्द हर मैट्रिक पेपर में चमकते हैं: **Kaju (favourite food)**, **Chik-chik (sound)**, **Surahi (summer)**, **Two years (lifespan)**!",
    "exam_tip_en": "4 High-Yield Keywords: **Kaju** (food), **Chik-chik** (sound), **Surahi** (summer), **Two years** (lifespan)!",
    "glossary_terms": [
      {
        "term_hi": "Attendant (अटेंडेंट)",
        "term_en": "Attendant",
        "pronunciation_hi": "अटेंडेंट",
        "definition_hi": "बीमार की सेवा व देखभाल करने वाला परिचारक (नर्स)।",
        "definition_en": "A caring nurse or helper attending a sick person."
      },
      {
        "term_hi": "Creeper (क्रीपर)",
        "term_en": "Creeper",
        "pronunciation_hi": "क्रीपर",
        "definition_hi": "दीवार या सहारे पर चढ़ने वाली बेल/लता (जैसे सोनजुही)।",
        "definition_en": "A climbing plant or vine such as the Sonjuhi."
      }
    ],
    "quick_check": {
      "q_hi": "गर्मी की दोपहर में ठंडक पाने के लिए गिल्लू कहाँ लेट जाता था?",
      "q_en": "Where did Gillu lie down to keep cool on hot summer afternoons?",
      "answer_hi": "लेखिका के पास रखी ठंडी मिट्टी की **सुराही (surahi)** पर।",
      "answer_en": "Flat on the cool earthen **surahi** kept near the author."
    }
  },
  {
    "id": "gil-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "इन 4 सरल अंग्रेज़ी वाक्यों को उच्चारण के साथ बोलिए — ये सीधे आपके बोर्ड उत्तर में काम आएँगे!",
    "analogy_en": "Read these 4 crisp sentences aloud — they drop straight into your Matric answers!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "गिल्लू की मुख्य पंक्तियाँ (उच्चारण + हिंदी अर्थ)",
      "title_en": "Key Lines from Gillu (Pronunciation + Meaning)",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "Gillu was a tiny baby squirrel rescued from two crows.",
            "गिल्लू वॉज़ अ टाइनी बेबी स्क्विरल रेस्क्यूड फ़्रॉम टू क्रोज़।",
            "गिल्लू दो कौओं से बचाया गया गिलहरी का नन्हा बच्चा था।"
          ],
          "cells_en": [
            "Gillu was a tiny baby squirrel rescued from two crows.",
            "Gi-loo woz a taai-nee be-bee skwi-ral res-kyood from too kroz.",
            "Opening introduction of Gillu."
          ]
        },
        {
          "cells_hi": [
            "His favourite food was kaju.",
            "हिज़ फ़ेवरेट फ़ूड वॉज़ काजू।",
            "उसका सबसे प्रिय भोजन काजू था।"
          ],
          "cells_en": [
            "His favourite food was kaju.",
            "Hiz fev-ret food woz kaa-joo.",
            "Most frequently asked Matric MCQ fact!"
          ]
        },
        {
          "cells_hi": [
            "Squirrels have a lifespan of barely two years.",
            "स्क्विरल्स हैव अ लाइफ़स्पैन ऑफ़ बेयरली टू इयर्स।",
            "गिलहरियों का जीवनकाल मुश्किल से दो वर्ष का होता है।"
          ],
          "cells_en": [
            "Squirrels have a lifespan of barely two years.",
            "Skwi-ralz hav a laaif-span ov be-yar-lee too ee-yarz.",
            "Explains Gillu's passing after two years."
          ]
        },
        {
          "cells_hi": [
            "Gillu was buried under the Sonjuhi creeper.",
            "गिल्लू वॉज़ बरीड अंडर द सोनजुही क्रीपर।",
            "गिल्लू को सोनजुही की लता के नीचे दफ़नाया गया।"
          ],
          "cells_en": [
            "Gillu was buried under the Sonjuhi creeper.",
            "Gi-loo woz be-reed an-dar the Son-ju-hee kree-par.",
            "Touching conclusion of the story."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Squirrel** (*स्क्विरल*) = गिलहरी\n2. **Wounded** (*वूंडेड*) = घायल\n3. **Verandah** (*वरांडा*) = बरामदा\n4. **Favourite** (*फ़ेवरेट*) = सबसे प्रिय\n5. **Buried** (*बरीड*) = दफ़नाया गया (ध्यान दें: \"ब्यूरीड\" नहीं, **बरीड**!)\n6. **Compassion** (*कम्पैशन*) = दया / करुणा",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Squirrel** (*स्क्विरल*) = small striped rodent\n2. **Wounded** (*वूंडेड*) = injured\n3. **Verandah** (*वरांडा*) = open porch\n4. **Favourite** (*फ़ेवरेट*) = most liked\n5. **Buried** (*बरीड*) = laid to rest underground\n6. **Compassion** (*कम्पैशन*) = tender pity and kindness",
    "exam_tip_hi": "खास उच्चारण टिप: **Buried** का सही उच्चारण **\"बरीड\"** होता है (\"ब्यूरीड\" नहीं)!",
    "exam_tip_en": "Pronunciation tip: **Buried** sounds like \"berry-d\" (*बरीड*)!",
    "glossary_terms": [
      {
        "term_hi": "Buried (बरीड)",
        "term_en": "Buried",
        "pronunciation_hi": "बरीड",
        "definition_hi": "सम्मानपूर्वक मिट्टी के नीचे समाधि देना / दफ़नाना।",
        "definition_en": "Placed peacefully underground after death."
      },
      {
        "term_hi": "Exception (एक्सेप्शन)",
        "term_en": "Exception",
        "pronunciation_hi": "एक्सेप्शन",
        "definition_hi": "अपवाद — बाक़ी सभी से अलग व विशेष (गिल्लू सभी पालतू जीवों में अपवाद था)।",
        "definition_en": "Someone special who stands apart from the usual rule."
      }
    ]
  },
  {
    "id": "gil-sec-4-summary",
    "order": 4,
    "heading_hi": "4. गिल्लू के मुख्य तथ्यों की तालिका व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Quick Fact Table & 5-Mark Summary Formula",
    "analogy_hi": "नीचे के 5 सरल वाक्य याद कर लें — गिल्लू पर कोई भी 5-अंक प्रश्न आए, आपका उत्तर भावनात्मक, सटीक और 5/5 अंक वाला होगा!",
    "analogy_en": "Memorize these 5 clean sentences for a guaranteed 5/5 answer on \"Gillu\"!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "गिल्लू — परीक्षा से 1 मिनट पहले सुपर रिवीजन तालिका",
      "title_en": "Gillu — 1-Minute Pre-Exam Quick Revision Table",
      "headers_hi": [
        "प्रश्न (Prompt)",
        "सटीक उत्तर (Exact Answer)"
      ],
      "headers_en": [
        "Prompt",
        "Exact Answer"
      ],
      "rows": [
        {
          "cells_hi": [
            "हमला किसने किया?",
            "दो कौओं (Two crows) ने बरामदे में गमले के पास"
          ],
          "cells_en": [
            "Who attacked Gillu?",
            "Two crows near the verandah flowerpot"
          ]
        },
        {
          "cells_hi": [
            "दवा व पहला भोजन?",
            "पेनिसिलिन मरहम व रुई की बत्ती से दूध"
          ],
          "cells_en": [
            "Treatment & first feed?",
            "Penicillin ointment & milk via cotton wick"
          ]
        },
        {
          "cells_hi": [
            "प्रिय भोजन व आवाज़?",
            "काजू (Kaju) · \"चिक-चिक\" (Chik-chik)"
          ],
          "cells_en": [
            "Favourite food & call?",
            "Kaju (cashew) · \"Chik-chik\""
          ]
        },
        {
          "cells_hi": [
            "जीवनकाल व समाधि स्थल?",
            "दो वर्ष (Two years) · सोनजुही (Sonjuhi) लता के नीचे"
          ],
          "cells_en": [
            "Lifespan & burial spot?",
            "Two years · Beneath the Sonjuhi creeper"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"Gillu\"** is a deeply touching story written by **Mahadevi Varma**.\n2. She rescued a tiny wounded **baby squirrel** from **two crows** and named him **Gillu**.\n3. Gillu loved **kaju**, chirped **\"chik-chik\"** when hungry, and slept on a cool **surahi** in summer.\n4. When the author was hurt in an accident, Gillu stopped eating kaju and gently stroked her forehead like a nurse.\n5. After his natural **two-year lifespan**, he was buried under the **Sonjuhi** creeper, teaching us pure love for animals.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"Gillu\"** is a deeply touching story written by **Mahadevi Varma**.\n2. She rescued a tiny wounded **baby squirrel** from **two crows** and named him **Gillu**.\n3. Gillu loved **kaju**, chirped **\"chik-chik\"** when hungry, and slept on a cool **surahi** in summer.\n4. When the author was hurt in an accident, Gillu stopped eating kaju and gently stroked her forehead like a nurse.\n5. After his natural **two-year lifespan**, he was buried under the **Sonjuhi** creeper, teaching us pure love for animals.",
    "exam_tip_hi": "अंडरलाइन करने वाले 5 शब्द: **Mahadevi Varma**, **two crows**, **kaju**, **two years**, **Sonjuhi**।",
    "exam_tip_en": "Underline these 5 keywords: **Mahadevi Varma**, **two crows**, **kaju**, **two years**, **Sonjuhi**.",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "गिल्लू को सोनजुही की लता के नीचे क्यों दफ़नाया गया?",
      "q_en": "Why was Gillu buried beneath the Sonjuhi creeper?",
      "answer_hi": "क्योंकि गिल्लू को सोनजुही की लता सबसे ज़्यादा प्रिय थी, और लेखिका को विश्वास था कि वह किसी दिन पीले फूल के रूप में फिर खिलेगा।",
      "answer_en": "Because Gillu loved the Sonjuhi creeper most, and the author hoped he would blossom again as a tiny yellow flower."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Author",
      "fact_hi": "महादेवी वर्मा (1907–1987) · छायावादी कवयित्री · ज्ञानपीठ (1982)",
      "fact_en": "Mahadevi Varma (1907–1987) · Chhayavadi Poet · Jnanpith (1982)"
    },
    {
      "tag": "Key Facts",
      "fact_hi": "भोजन: काजू · आवाज़: चिक-चिक · आयु: 2 वर्ष · समाधि: सोनजुही",
      "fact_en": "Food: Kaju · Call: Chik-chik · Lifespan: 2 years · Burial: Sonjuhi"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Gillu is a true story of love between Mahadevi Varma and a baby squirrel.",
      "fact_en": "Gillu is a true story of love between Mahadevi Varma and a baby squirrel."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "She rescued him wounded from two crows and healed him with penicillin ointment.",
      "fact_en": "She rescued him wounded from two crows and healed him with penicillin ointment."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "Gillu loved kaju, called \"chik-chik\", and lay on the cool surahi in summer.",
      "fact_en": "Gillu loved kaju, called \"chik-chik\", and lay on the cool surahi in summer."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "During her illness, he skipped kaju and stroked her hair like a tender nurse.",
      "fact_en": "During her illness, he skipped kaju and stroked her hair like a tender nurse."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "After two years he died and was buried beneath his beloved Sonjuhi creeper.",
      "fact_en": "After two years he died and was buried beneath his beloved Sonjuhi creeper."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "गिलहरी का जीवनकाल \"5 वर्ष\" या \"10 वर्ष\" लिख देना।",
      "mistake_en": "Writing 5 years or 10 years as a squirrel's lifespan.",
      "fix_hi": "पाठ में स्पष्ट लिखा है: गिलहरी का जीवनकाल मात्र **दो वर्ष (two years)** होता है।",
      "fix_en": "The text states clearly: a squirrel's lifespan is barely **two years**."
    },
    {
      "mistake_hi": "सोनजुही के फूल का रंग \"लाल\" या \"सफ़ेद\" लिख देना।",
      "mistake_en": "Writing red or white for the Sonjuhi flower.",
      "fix_hi": "सोनजुही की कली का रंग **पीला (yellow)** था!",
      "fix_en": "The Sonjuhi bud/flower was **yellow**!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "गिल्लू का बचाव, प्रिय भोजन व सुराही प्रसंग",
      "topic_en": "Gillu's Rescue, Kaju & Summer Surahi",
      "years": [
        "2021",
        "2022",
        "2024"
      ],
      "expected_marks": 2
    },
    {
      "topic_hi": "गिल्लू और महादेवी वर्मा का आत्मीय स्नेह (सारांश)",
      "topic_en": "Bond Between Gillu & Mahadevi Varma (Summary)",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-10-eng-ch3',
  2,
  'छात्र "Gillu" की भावनात्मक कथा समझ सकेंगे, पशु-प्रेम के संवेदनशील प्रसंग याद रख सकेंगे और 2-अंक व 5-अंक के सटीक बोर्ड उत्तर लिख सकेंगे।',
  'Students will appreciate Mahadevi Varma''s bond with Gillu, retain key facts (two crows, kaju, surahi, two years, Sonjuhi), and write clear exam answers.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "भावनात्मक स्टोरी हुक, उच्चारण अभ्यास व गिल्लू जीवन-चार्ट",
    "phase_en": "Emotional Story Hook, Pronunciation & Life Flowchart",
    "teacher_action_hi": "पूछें: \"क्या आपके घर में कोई पालतू पशु या आँगन की गिलहरी है?\" फिर महादेवी वर्मा व गिल्लू की सच्ची कहानी हिंदी में सुनाएँ। Squirrel (स्क्विरल), Ointment (ऑइंटमेंट), Verandah (वरांडा), Buried (बरीड) का उच्चारण कराएँ।",
    "teacher_action_en": "Ask students about pets or courtyard squirrels. Narrate Gillu's rescue and bond warmly in Hindi. Drill Squirrel, Ointment, Verandah, and Buried.",
    "student_check_hi": "पूछें: \"गिल्लू का प्रिय भोजन क्या था और वह भूख लगने पर कैसी आवाज़ निकालता था?\"",
    "student_check_en": "Ask: \"What was Gillu's favourite food and what sound did he make?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "संवेदनशील प्रसंग, 5-मिनट मौखिक गतिविधि व 5-अंक सारांश",
    "phase_en": "Key Episodes, 5-Min Oral Confidence Drill & 5-Mark Summary",
    "teacher_action_hi": "अस्पताल-दुर्घटना और अंतिम रात के प्रसंग समझाएँ। 5-मिनट मौखिक गतिविधि में 5 कमजोर छात्र 5-वाक्य सारांश पढ़ें। अंत में 5 मैट्रिक PYQ का अभ्यास कराएँ।",
    "teacher_action_en": "Discuss the car accident episode and Sonjuhi farewell. Run a 5-min oral chain of the 5-sentence summary, then solve 5 Matric PYQs.",
    "student_check_hi": "सभी छात्रों से कॉपी में बिना देखे 4 कीवर्ड लिखवाएँ: Kaju, Surahi, Two years, Sonjuhi।",
    "student_check_en": "Have every student write the 4 keywords from memory: Kaju, Surahi, Two years, Sonjuhi."
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड तथ्य बॉक्स (Gillu)",
    "heading_en": "Blackboard Fact Box (Gillu)",
    "points_hi": [
      "लेखिका: Mahadevi Varma (छायावादी कवयित्री, ज्ञानपीठ 1982)",
      "बचाव: 2 कौओं से घायल → Penicillin ointment + रुई से दूध",
      "आदतें: Kaju (भोजन) · Chik-chik (आवाज़) · Surahi (गर्मी में) · Envelope (शरारत पर)",
      "अंत: आयु = 2 वर्ष · समाधि = Sonjuhi (पीले फूल की कली)"
    ],
    "points_en": [
      "Author: Mahadevi Varma (Chhayavadi Poet, Jnanpith 1982)",
      "Rescue: Wounded by 2 crows -> Penicillin ointment + milk via cotton wick",
      "Habits: Kaju (food) · Chik-chik (call) · Surahi (summer) · Envelope",
      "End: Lifespan = 2 years · Buried under Sonjuhi (yellow flower hope)"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"गिल्लू की डायरी\" मौखिक वाक्य अभ्यास",
    "title_en": "5-Minute \"Gillu's Diary\" Spoken Sentence Chain",
    "materials_hi": "ब्लैकबोर्ड पर 4 वाक्य-शुरुआत (\"I am Gillu...\", \"I love...\")",
    "materials_en": "4 sentence starters on the board (\"I am Gillu...\", \"My favourite food is...\")",
    "steps_hi": "कमज़ोर छात्र गिल्लू बनकर 1-1 आसान अंग्रेज़ी वाक्य बोलें (\"I am a baby squirrel\", \"I love kaju\", \"I sleep on the surahi\")।",
    "steps_en": "Shy students speak 1 simple first-person English line as Gillu (\"I am a baby squirrel\", \"I love kaju\")."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Squirrel, Ointment, Favourite, Lifespan और Buried को 5 बार अर्थ सहित लिखें।",
    "task_en": "Write Squirrel, Ointment, Favourite, Lifespan, and Buried 5 times with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "जब लेखिका अस्पताल में थीं तब गिल्लू ने अपना प्रेम कैसे दिखाया? 3 वाक्यों में लिखें।",
    "task_en": "How did Gillu show his love when Mahadevi Varma was hospitalized? Answer in 3 sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "\"Gillu\" का 5-अंक सारांश स्वच्छ लिखावट में बिना देखे लिखें।",
    "task_en": "Write the 5-mark summary of \"Gillu\" neatly from memory."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र गिल्लू को चिड़िया या खरगोश लिख देते हैं।",
    "misconception_en": "Students confuse Gillu with a bird or rabbit.",
    "correction_hi": "स्पष्ट याद कराएँ: \"गिलहरी\" से ही नाम बना **\"गिल्लू (Gillu)\" — a tiny baby squirrel**!",
    "correction_en": "Connect the Hindi name: \"Gilahari\" -> **Gillu (baby squirrel)**!"
  },
  {
    "misconception_hi": "छात्र सोचते हैं कि गिल्लू किसी बीमारी या कौए के दूसरे हमले से मरा।",
    "misconception_en": "Students think Gillu died from another crow attack.",
    "correction_hi": "स्पष्ट करें कि गिलहरी का स्वाभाविक जीवनकाल ही मात्र **2 वर्ष** होता है — उसी के पूर्ण होने पर वह शांत भाव से चला गया।",
    "correction_en": "Clarify Gillu died naturally at the end of a squirrel's normal **two-year lifespan**."
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
  (
    '10000007-0003-4000-8000-000000000001', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Author & Memoir', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2023',
    'Gillu की लेखिका कौन हैं और उन्हें कौन-सा बड़ा साहित्य पुरस्कार मिला?',
    'Who wrote "Gillu" and what major literary award did she win?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"Gillu\" की लेखिका, साहित्यिक धारा और प्रमुख सम्मान बताएँ।",
  "front_en": "Name the author, literary movement, and top award of \"Gillu\"'s writer.",
  "back_hi": "लेखिका: Mahadevi Varma (1907–1987) · छायावादी कवयित्री · ज्ञानपीठ पुरस्कार (1982) व पद्म विभूषण।",
  "back_en": "Author: Mahadevi Varma (1907–1987) · Chhayavadi Poet · Jnanpith Award (1982) & Padma Vibhushan.",
  "pronunciation_hi": "गिल्लू — महादेवी वर्मा",
  "mnemonic_hi": "गिलहरी = गिल्लू = महादेवी वर्मा (\"मेरा परिवार\")!",
  "mnemonic_en": "Gilahari -> Gillu -> Mahadevi Varma!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000002', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Squirrel और Buried का सही उच्चारण व अर्थ क्या है?',
    'What are the pronunciation and meaning of Squirrel and Buried?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Squirrel और Buried शब्दों का सही हिंदी उच्चारण व अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Squirrel\" and \"Buried\".",
  "back_hi": "Squirrel (स्क्विरल) = गिलहरी · Buried (बरीड) = मिट्टी के नीचे दफ़नाया गया / समाधि दी गई।",
  "back_en": "Squirrel = small striped rodent · Buried (pronounced \"berry-d\") = laid to rest underground.",
  "pronunciation_hi": "स्क्विरल · बरीड",
  "mnemonic_hi": "Buried को \"बरीड\" बोलें (\"ब्यूरीड\" नहीं)!",
  "mnemonic_en": "Say \"berry-d\" (*बरीड*) for Buried!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000003', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Gillu Details Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2024',
    'गिल्लू के जीवन से जुड़े शब्दों को सही अर्थ/भूमिका से मिलाएँ:',
    'Match each item from "Gillu" in Column A with its role in Column B:',
    NULL, NULL,
    'काजू, सुराही, सोनजुही और दो कौओं को सही जगह मिलाएँ।', 'Match Kaju, Surahi, Sonjuhi, and Two Crows.',
    'काजू प्रिय भोजन, सुराही गर्मी में ठंडक, सोनजुही समाधि स्थल और दो कौओं ने गिल्लू को घायल किया।', 'Kaju was his favourite food, surahi kept him cool, Sonjuhi was his burial spot, and two crows wounded him.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each detail from Gillu",
  "pairs": [
    {
      "id": "gil-m1",
      "left_hi": "Kaju (काजू)",
      "left_en": "Kaju (Cashew)",
      "right_hi": "गिल्लू का सबसे प्रिय भोजन",
      "right_en": "Gillu's favourite food"
    },
    {
      "id": "gil-m2",
      "left_hi": "Surahi (सुराही)",
      "left_en": "Earthen Surahi",
      "right_hi": "गर्मी की दोपहर में ठंडक के लिए लेटने का स्थान",
      "right_en": "Cool spot where Gillu lay in summer"
    },
    {
      "id": "gil-m3",
      "left_hi": "Sonjuhi (सोनजुही)",
      "left_en": "Sonjuhi Creeper",
      "right_hi": "गिल्लू की समाधि व पीले फूल की आशा",
      "right_en": "Gillu's burial spot & yellow flower hope"
    },
    {
      "id": "gil-m4",
      "left_hi": "Two Crows (दो कौए)",
      "left_en": "Two Crows",
      "right_hi": "जिन्होंने बरामदे में नन्हे गिल्लू को घायल किया",
      "right_en": "Wounded tiny Gillu near the verandah"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000004', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही वाक्य सजाएँ: "गिल्लू का प्रिय भोजन काजू था।"',
    'Build the exam sentence: "Gillu''s favourite food was kaju"',
    NULL, NULL,
    'Singular subject ("food") के साथ "was" लगेगा।', 'Use singular past verb "was".',
    'सही वाक्य: "Gillu''s favourite food was kaju"।', 'Correct sentence: "Gillu''s favourite food was kaju".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "गिल्लू का प्रिय भोजन काजू था।",
  "prompt_en": "Build this key sentence from Gillu",
  "grammar_formula": "Possessive Noun + Adjective + Noun + was + Noun",
  "tokens": [
    "Gillu's",
    "favourite",
    "food",
    "was",
    "kaju"
  ],
  "distractors": [
    "were",
    "is"
  ],
  "correct_sentence": "Gillu's favourite food was kaju",
  "pronunciation_hi": "गिल्लूज़ फ़ेवरेट फ़ूड वॉज़ काजू"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000005', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "गिल्लू को सोनजुही की लता के नीचे दफ़नाया गया।"',
    'Build the sentence: "Gillu was buried under the Sonjuhi creeper"',
    NULL, NULL,
    'Past Passive: Subject + was + V3 (buried) + under + the Sonjuhi creeper।', 'Past passive: Gillu + was + buried + under + the Sonjuhi creeper.',
    'सही वाक्य: "Gillu was buried under the Sonjuhi creeper"।', 'Correct sentence: "Gillu was buried under the Sonjuhi creeper".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "गिल्लू को सोनजुही की लता के नीचे दफ़नाया गया।",
  "prompt_en": "Build the closing sentence for your board summary",
  "grammar_formula": "Subject + was + V3 + Preposition + Object",
  "tokens": [
    "Gillu",
    "was",
    "buried",
    "under",
    "the",
    "Sonjuhi",
    "creeper"
  ],
  "distractors": [
    "were",
    "on"
  ],
  "correct_sentence": "Gillu was buried under the Sonjuhi creeper",
  "pronunciation_hi": "गिल्लू वॉज़ बरीड अंडर द सोनजुही क्रीपर"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000006', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Favourite Food MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    'गिल्लू का सबसे प्रिय भोजन (favourite food) क्या था?',
    'What was Gillu''s favourite food?',
    $json$[{"key":"A","text_hi":"चावल (Rice)","text_en":"Rice"},{"key":"B","text_hi":"बिस्कुट (Biscuit)","text_en":"Biscuit"},{"key":"C","text_hi":"काजू (Kaju)","text_en":"Kaju"},{"key":"D","text_hi":"जाम (Jam)","text_en":"Jam"}]$json$::jsonb, 'C',
    'कई दिन न मिलने पर वह अन्य चीज़ें झूले से नीचे फेंक देता था!', 'If not given this nut for days, he refused other food!',
    'गिल्लू का सबसे प्रिय भोजन काजू (kaju) था।', 'Kaju (cashew) was Gillu''s favourite food.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000007', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Lifespan MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'पाठ के अनुसार गिलहरी का स्वाभाविक जीवनकाल कितना होता है?',
    'According to the chapter, what is the natural lifespan of a squirrel?',
    $json$[{"key":"A","text_hi":"दो वर्ष","text_en":"Two years"},{"key":"B","text_hi":"पाँच वर्ष","text_en":"Five years"},{"key":"C","text_hi":"दस वर्ष","text_en":"Ten years"},{"key":"D","text_hi":"एक वर्ष","text_en":"One year"}]$json$::jsonb, 'A',
    'गिल्लू लेखिका के साथ ठीक इतने ही वर्ष जीवित रहा।', 'Gillu stayed with Mahadevi Varma for this exact span.',
    'गिलहरी का जीवनकाल मुश्किल से दो वर्ष (two years) होता है।', 'Squirrels have a natural lifespan of barely two years.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000008', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Hunger Sound MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'भूख लगने पर गिल्लू कैसी आवाज़ निकालकर लेखिका को सूचना देता था?',
    'What sound did Gillu make to inform the author that he was hungry?',
    $json$[{"key":"A","text_hi":"म्याऊँ-म्याऊँ (Meow-meow)","text_en":"Meow-meow"},{"key":"B","text_hi":"चूँ-चूँ (Choo-choo)","text_en":"Choo-choo"},{"key":"C","text_hi":"काँव-काँव (Caw-caw)","text_en":"Caw-caw"},{"key":"D","text_hi":"चिक-चिक (Chik-chik)","text_en":"Chik-chik"}]$json$::jsonb, 'D',
    'गिलहरी की पतली, तीखी बोली याद करें।', 'Recall the sharp little squirrel chirp.',
    'भूख लगने पर गिल्लू "चिक-चिक" (chik-chik) की आवाज़ करता था।', 'Gillu twittered "chik-chik" whenever he was hungry.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000009', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Ointment MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2021',
    'महादेवी वर्मा ने घायल गिल्लू के घावों पर कौन-सा मरहम लगाया था?',
    'Which ointment did Mahadevi Varma apply to Gillu''s wounds?',
    $json$[{"key":"A","text_hi":"हल्दी","text_en":"Turmeric"},{"key":"B","text_hi":"पेनिसिलिन मरहम (Penicillin ointment)","text_en":"Penicillin ointment"},{"key":"C","text_hi":"आयोडीन","text_en":"Iodine"},{"key":"D","text_hi":"चंदन का लेप","text_en":"Sandalwood paste"}]$json$::jsonb, 'B',
    'एक प्रसिद्ध एंटीबायोटिक मरहम।', 'A famous antibiotic ointment.',
    'लेखिका ने गिल्लू के घाव रुई से पोंछकर उस पर पेनिसिलिन मरहम (penicillin ointment) लगाया।', 'The author wiped his wounds and applied penicillin ointment.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000010', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Sonjuhi Symbolism', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'महादेवी वर्मा को विश्वास था कि किसी वसंत में गिल्लू किस रूप में फिर से खिलेगा?',
    'Mahadevi Varma hoped that one spring Gillu would blossom again in the guise of:',
    $json$[{"key":"A","text_hi":"गेंदे का फूल","text_en":"A marigold flower"},{"key":"B","text_hi":"लाल गुलाब","text_en":"A red rose"},{"key":"C","text_hi":"सोनजुही का छोटा पीला फूल","text_en":"A tiny yellow Sonjuhi flower"},{"key":"D","text_hi":"सफ़ेद कमल","text_en":"A white lotus"}]$json$::jsonb, 'C',
    'पाठ की शुरुआत भी इसी पीली कली से होती है!', 'The very opening of the chapter mentions this yellow bud!',
    'लेखिका को विश्वास था कि गिल्लू किसी दिन सोनजुही के छोटे पीले फूल के रूप में फिर खिलेगा।', 'The author cherished the belief that Gillu would blossom anew as a tiny yellow Sonjuhi flower.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000011', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Exam Pool: Summer Coolness', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2023',
    'गर्मी की दोपहर में गिल्लू ठंडक पाने के लिए किस चीज़ पर लेट जाता था?',
    'To beat the summer heat while staying near the author, Gillu lay flat on the:',
    $json$[{"key":"A","text_hi":"मेज़ के नीचे","text_en":"Under the table"},{"key":"B","text_hi":"गीले तौलिये पर","text_en":"Wet towel"},{"key":"C","text_hi":"बर्फ़ की सिल्ली पर","text_en":"Ice block"},{"key":"D","text_hi":"सुराही (Surahi) पर","text_en":"Surahi (earthen water pot)"}]$json$::jsonb, 'D',
    'पानी ठंडा रखने का मिट्टी का बर्तन।', 'An earthen vessel used to keep drinking water cool.',
    'गर्मी में गिल्लू लेखिका के पास रखी ठंडी सुराही (surahi) पर लेट जाता था।', 'Gillu lay prostrate on the cool earthen surahi kept near the author.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000012', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Exam Pool: Author Movement', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'महादेवी वर्मा हिंदी साहित्य की किस प्रसिद्ध काव्यधारा की प्रमुख कवयित्री थीं?',
    'Mahadevi Varma was a leading poet of which famous school of Hindi poetry?',
    $json$[{"key":"A","text_hi":"छायावादी धारा (Chhayavadi school)","text_en":"Chhayavadi school"},{"key":"B","text_hi":"रीतिकाल","text_en":"Riti school"},{"key":"C","text_hi":"प्रगतिवाद","text_en":"Progressive school"},{"key":"D","text_hi":"भक्तिकाल","text_en":"Bhakti school"}]$json$::jsonb, 'A',
    'प्रसाद, पंत, निराला और महादेवी वर्मा इस धारा के 4 स्तंभ हैं।', 'She is one of the four pillars alongside Prasad, Pant, and Nirala.',
    'महादेवी वर्मा हिंदी की प्रसिद्ध छायावादी कवयित्री (Chhayavadi poet) थीं।', 'Mahadevi Varma was a celebrated poet of the Chhayavadi school.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000013', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Hospital Empathy 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'महादेवी वर्मा के बीमार होने पर गिल्लू ने एक परिचारक (nurse) की तरह उनकी सेवा कैसे की?',
    'How did Gillu behave like a caring nurse when Mahadevi Varma was indisposed?',
    NULL, NULL,
    'काजू न खाना और सिरहाने बैठकर बाल व माथा सहलाना लिखें।', 'Mention skipping kaju while she was in hospital and stroking her hair/forehead when she returned.',
    NULL, NULL,
    'जब महादेवी वर्मा मोटर दुर्घटना के कारण अस्पताल में थीं, तो उदासी में गिल्लू ने अपना प्रिय भोजन **काजू** भी नहीं खाया। घर लौटने पर वह उनके तकिये के पास बैठकर अपने नन्हे पंजों से बड़ी कोमलता से उनके **बाल और माथा सहलाता** रहा — मानो कोई सच्ची नर्स (attendant) सेवा कर रही हो।', 'While Mahadevi Varma was hospitalized after a motor accident, Gillu grew sad and barely touched his favourite **kaju**. When she returned home, he sat near her head and gently **stroked her hair and forehead** with his tiny paws, just like a devoted nurse.',
    $json$[{"cue_hi":"अस्पताल के दिनों में काजू नहीं खाए","cue_en":"Skipped favourite kaju during her stay in hospital"},{"cue_hi":"नन्हे पंजों से बाल और माथा सहलाया","cue_en":"Gently stroked her hair and forehead"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"अस्पताल अवधि में प्रिय काजू छोड़ने का उल्लेख","criterion_en":"Notes Gillu refusing kaju while she was hospitalized"},{"step_no":2,"marks":1,"criterion_hi":"बाल व माथा सहलाने की परिचारक-समान सेवा","criterion_en":"Describes gently stroking her hair and forehead like a nurse"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0003-4000-8000-000000000014', 'bseb-10-eng', 'bseb-10-eng-ch3', 'Summary & Bond 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"Gillu" कहानी का सारांश लिखें और मनुष्य व पशु के बीच के आत्मीय प्रेम को स्पष्ट करें।',
    'Write a summary of "Gillu" highlighting the tender bond between humans and animals.',
    NULL, NULL,
    'दो कौओं से बचाव, पेनिसिलिन, काजू-चिकचिक-सुराही, अस्पताल सेवा, 2 वर्ष आयु व सोनजुही लिखें।', 'Cover rescue from two crows, penicillin, kaju/surahi, nurse-like care, 2-year lifespan, and Sonjuhi burial.',
    NULL, NULL,
    '**"गिल्लू" (Gillu)** प्रसिद्ध छायावादी कवयित्री **महादेवी वर्मा** का अत्यंत संवेदनशील संस्मरण है, जो मनुष्य और एक नन्हे पशु के निश्छल प्रेम को दर्शाता है।

एक दिन लेखिका ने बरामदे में गमले के पास **दो कौओं** की चोंच से घायल एक नन्हे गिलहरी के बच्चे को बचाया। उन्होंने घाव पर **पेनिसिलिन मरहम** लगाया और रुई की बत्ती से दूध पिलाकर उसे नया जीवन दिया। उसका नाम **गिल्लू** रखा गया। गिल्लू का प्रिय भोजन **काजू** था; भूख लगने पर वह **"चिक-चिक"** करता था और गर्मी की दोपहर में ठंडी **सुराही** पर लेट जाता था।

जब लेखिका दुर्घटना में घायल हुईं, तो गिल्लू ने काजू छोड़ दिए और उनके लौटने पर नर्स की तरह उनके बाल व माथा सहलाया। दो वर्ष का स्वाभाविक जीवनकाल पूरा होने पर वह अंतिम रात उनकी उँगली थामे चल बसा। उसे उसकी प्रिय **सोनजुही** की लता के नीचे दफ़नाया गया। यह पाठ हमें सभी जीवों से प्रेम व करुणा रखने की सीख देता है।', '**"Gillu"** is a deeply moving true story by renowned poet **Mahadevi Varma** celebrating the pure bond between humans and animals.

One morning, the author rescued a tiny baby squirrel wounded by **two crows** near a verandah flowerpot. She healed him with **penicillin ointment**, fed him milk with a cotton wick, and named him **Gillu**. He lived in a cotton-lined flower basket, loved **kaju**, chirped **"chik-chik"** when hungry, ate rice beside her plate, and lay flat on a cool **surahi** on hot summer afternoons.

When Mahadevi Varma was injured in an accident, Gillu refused his favourite kaju and tenderly stroked her hair and forehead like a nurse. At the end of a squirrel''s **two-year lifespan**, he clutched her finger on his last night and passed away. Buried beneath his beloved **Sonjuhi** creeper, Gillu remains an unforgettable symbol of love and compassion.',
    $json$[{"cue_hi":"Mahadevi Varma · Rescued from two crows","cue_en":"Mahadevi Varma · Rescued from two crows"},{"cue_hi":"Penicillin, cotton wick, kaju, chik-chik, surahi","cue_en":"Penicillin, cotton wick, kaju, chik-chik, surahi"},{"cue_hi":"Nurse-like care during car accident","cue_en":"Nurse-like care during car accident"},{"cue_hi":"2-year lifespan · Buried under Sonjuhi","cue_en":"2-year lifespan · Buried under Sonjuhi"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"लेखिका (Mahadevi Varma) व दो कौओं से बचाव","criterion_en":"Names Mahadevi Varma and rescue from two crows"},{"step_no":2,"marks":1.5,"criterion_hi":"काजू, चिक-चिक, थाली व सुराही की आदतें","criterion_en":"Describes kaju, chik-chik, dining habits, and surahi"},{"step_no":3,"marks":1.5,"criterion_hi":"दुर्घटना के समय संवेदनशील सेवा व 2 वर्ष बाद विदाई","criterion_en":"Highlights nurse-like care and natural death after 2 years"},{"step_no":4,"marks":1,"criterion_hi":"सोनजुही की समाधि व जीव-दया का निष्कर्ष","criterion_en":"Mentions Sonjuhi burial and compassion theme"}]$json$::jsonb,
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
-- CHAPTER 4 OF 14: BSEB-10-ENG-CH4 — God Made the Country (Poem) — William Cowper
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-10-eng-ch4',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: ईश्वर ने गाँव बनाया (God Made the Country)",
  "title_en": "30-Second Mindmap: God Made the Country",
  "read_time_seconds": 30,
  "central_node": {
    "id": "gmc-root",
    "label_hi": "God Made the Country",
    "label_en": "God Made the Country (Poem)",
    "subtitle_hi": "William Cowper (1731–1800) · Panorama Part-2 (Poem)",
    "subtitle_en": "William Cowper (1731–1800) · Panorama Part-2 (Poem)"
  },
  "branches": [
    {
      "id": "gmc-poet",
      "label_hi": "1. कवि परिचय (Poet)",
      "label_en": "1. About the Poet",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "gmc-p1",
          "label_hi": "विलियम कूपर (William Cowper, 1731–1800) — अंग्रेज़ी कवि",
          "label_en": "William Cowper (1731–1800) — 18th-century English poet"
        },
        {
          "id": "gmc-p2",
          "label_hi": "स्रोत: उनकी प्रसिद्ध कविता \"The Task\" (1785) का अंश",
          "label_en": "Extract from his celebrated poem \"The Task\" (1785)"
        }
      ]
    },
    {
      "id": "gmc-country",
      "label_hi": "2. गाँव (Country — ईश्वर की रचना)",
      "label_en": "2. The Country (Made by God)",
      "color": "#059669",
      "children": [
        {
          "id": "gmc-c1",
          "label_hi": "स्वास्थ्य (Health) और सदाचार (Virtue) भरपूर मिलते हैं",
          "label_en": "Abundant in Health and Virtue — life's sweetest gifts"
        },
        {
          "id": "gmc-c2",
          "label_hi": "दोपहर में बगीचों (Groves) की छाया · शाम को कोमल चाँदनी (Moonbeam)",
          "label_en": "Shady groves at noon · Soft moonbeam through leaves at eve"
        },
        {
          "id": "gmc-c3",
          "label_hi": "पक्षियों का मधुर कलरव (Thrush & Nightingale)",
          "label_en": "Sweet music of warbling birds (thrush & nightingale)"
        }
      ]
    },
    {
      "id": "gmc-town",
      "label_hi": "3. शहर (Town — मनुष्य की रचना)",
      "label_en": "3. The Town (Made by Man)",
      "color": "#D97706",
      "children": [
        {
          "id": "gmc-t1",
          "label_hi": "आलस्य, बनावटी गाड़ियाँ (Sedans & Chariots), और ऊब",
          "label_en": "Idleness, sedans & chariots, and weary artificiality"
        },
        {
          "id": "gmc-t2",
          "label_hi": "चकाचौंध लैंप चाँदनी को ढक देते हैं; शोर से थ्रश डरकर उड़ जाती है व बुलबुल चुप हो जाती है",
          "label_en": "Glaring lamps eclipse the moon; loud noise scares the thrush and mutes the nightingale"
        }
      ]
    },
    {
      "id": "gmc-exam",
      "label_hi": "4. संदेश और बोर्ड फोकस",
      "label_en": "4. Message & Exam Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "gmc-e1",
          "label_hi": "प्रकृति की गोद में सच्ची शांति, स्वास्थ्य और नैतिकता बसती है।",
          "label_en": "True peace, health, and virtue flourish close to nature."
        },
        {
          "id": "gmc-e2",
          "label_hi": "पक्के MCQ: Health & Virtue, Groves, Moonbeam, Thrush (scared), Nightingale (mute)।",
          "label_en": "Top MCQs: Health & Virtue, Groves, Moonbeam, Thrush, Nightingale."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "gmc-sec-1-poet",
    "order": 1,
    "heading_hi": "1. कवि परिचय और बिहार के गाँव की शाम से जुड़ाव",
    "heading_en": "1. Poet Profile & Everyday Bihar Village Connection",
    "analogy_hi": "एक पल के लिए बिहार के किसी हरे-भरे गाँव की शाम सोचिए — आम के बगीचे (groves) की ठंडी छाँव, पत्तों के बीच से छनकर आती मुलायम चाँदनी, और कोयल-बुलबुल की मीठी बोली! और दूसरी तरफ़ बड़े शहर का हॉर्न, धुआँ और तेज़ हैलोजन लाइट! ठीक यही फ़र्क **विलियम कूपर** ने अपनी अमर पंक्ति में कहा: **\"God made the country, and man made the town.\"**",
    "analogy_en": "Picture a cool Bihar mango grove at noon, soft moonlight filtering through leaves at dusk, and birds singing freely — versus noisy city traffic and harsh streetlights! That exact contrast inspires **William Cowper's** famous opening line: **\"God made the country, and man made the town.\"**",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "गाँव (Country) बनाम शहर (Town) — कविता का मूल अंतर",
      "title_en": "Country vs Town — Core Contrast in Cowper's Poem",
      "headers_hi": [
        "पहलू (Aspect)",
        "गाँव (God Made the Country)",
        "शहर (Man Made the Town)"
      ],
      "headers_en": [
        "Aspect",
        "Country (Made by God)",
        "Town (Made by Man)"
      ],
      "rows": [
        {
          "cells_hi": [
            "रचयिता",
            "ईश्वर (God)",
            "मनुष्य (Man)"
          ],
          "cells_en": [
            "Creator",
            "God",
            "Man"
          ]
        },
        {
          "cells_hi": [
            "जीवन के उपहार",
            "स्वास्थ्य (Health) और सदाचार (Virtue)",
            "आलस्य, विलासिता और नैतिक कमज़ोरी"
          ],
          "cells_en": [
            "Gifts of Life",
            "Health and Virtue abound",
            "Idleness, luxury, and moral decay"
          ]
        },
        {
          "cells_hi": [
            "रात्रि का प्रकाश",
            "पत्तों से छनती कोमल चाँदनी (Moonbeam)",
            "चकाचौंध करने वाले कृत्रिम लैंप"
          ],
          "cells_en": [
            "Evening Light",
            "Soft moonbeam through sleeping leaves",
            "Glaring lamps that eclipse the moon"
          ]
        },
        {
          "cells_hi": [
            "संगीत व पक्षी",
            "थ्रश और बुलबुल का मधुर गान",
            "शोर से थ्रश डरकर भागती है, बुलबुल चुप हो जाती है"
          ],
          "cells_en": [
            "Music & Birds",
            "Harmonious warbling of birds",
            "Loud noise scares the thrush & mutes the nightingale"
          ]
        }
      ]
    },
    "concept_md_hi": "### कवि और कविता का परिचय\n- **कवि:** **विलियम कूपर (William Cowper, 1731–1800)** 18वीं सदी के महान अंग्रेज़ी प्रकृति-कवि थे, जो वर्ड्सवर्थ जैसे रोमांटिक कवियों के अग्रदूत माने जाते हैं।\n- **अर्थ समझें:** अंग्रेज़ी कविता में **\"Country\"** का अर्थ यहाँ \"देश\" नहीं, बल्कि **\"गाँव / देहात (Countryside / Village)\"** है!\n- **जीवन के दो अनमोल उपहार:** कवि कहते हैं कि **स्वास्थ्य (Health)** और **सदाचार (Virtue)** ही वे दो उपहार हैं जो जीवन के कड़वे घूँट (*bitter draught*) को मीठा बनाते हैं — और ये दोनों गाँव के खेतों व बगीचों में सबसे अधिक मिलते हैं।",
    "concept_md_en": "### About the Poet & Poem\n- **Poet:** **William Cowper (1731–1800)** was a pioneering 18th-century English nature poet who paved the way for the Romantic poets.\n- **Important Word Sense:** Here **\"country\"** means the **countryside / village**, NOT a nation!\n- **Two Precious Gifts:** Cowper says **Health** and **Virtue** alone sweeten the \"bitter draught\" (hardships) of human life — and both flourish best in village fields and groves.",
    "exam_tip_hi": "BSEB मैट्रिक के पक्के MCQ: कौन-से दो उपहार जीवन को मधुर बनाते हैं? → **Health and Virtue**! यहाँ \"Country\" का अर्थ? → **Village / Countryside**!",
    "exam_tip_en": "Guaranteed Matric MCQs: Which two gifts make life sweet? → **Health and Virtue**! Meaning of \"country\"? → **Countryside/Village**!",
    "glossary_terms": [
      {
        "term_hi": "Virtue (वर्च्यू)",
        "term_en": "Virtue",
        "pronunciation_hi": "वर्च्यू",
        "definition_hi": "सदाचार, नेकी और अच्छा चरित्र।",
        "definition_en": "Moral goodness and noble character."
      },
      {
        "term_hi": "Groves (ग्रोव्ज़)",
        "term_en": "Groves",
        "pronunciation_hi": "ग्रोव्ज़",
        "definition_hi": "पेड़ों का छायादार झुरमुट या बगीचा।",
        "definition_en": "Shady clusters of trees or small orchards."
      }
    ]
  },
  {
    "id": "gmc-sec-2-stanzas",
    "order": 2,
    "heading_hi": "2. विज़ुअल स्टोरीबोर्ड: कविता का भावार्थ (4 दृश्य)",
    "heading_en": "2. Visual Breakdown: Poem Movement in 4 Clear Scenes",
    "analogy_hi": "पूरी कविता एक शांत गाँव के दिन-से-रात की सैर जैसी है — सुबह खेतों का स्वास्थ्य, दोपहर बगीचे की छाया, शाम को चाँदनी, और अंत में शहर के शोर से पक्षियों का चुप हो जाना!",
    "analogy_en": "Follow the poem from bright noon in the groves to moonlit evening — and see how city glare and noise break nature's harmony.",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "गाँव की प्राकृतिक शांति बनाम शहर की कृत्रिम चमक",
      "title_en": "Natural Peace of Villages vs Artificial Glare of Towns",
      "caption_hi": "गाँव में बगीचे की छाया, कोमल चाँदनी और पक्षियों का मधुर गान है; शहर के लैंप चाँदनी को ढक देते हैं और शोर से थ्रश व बुलबुल चुप हो जाते हैं।",
      "caption_en": "Villages enjoy shady groves, soft moonlight, and birdsong; urban lamps eclipse the moon and urban noise silences birds.",
      "viewBox": "0 0 640 240",
      "elements": [
        {
          "kind": "rect",
          "x": 18,
          "y": 20,
          "width": 290,
          "height": 200,
          "rx": 12,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 163,
          "y": 48,
          "text_hi": "गाँव (God Made the Country)",
          "text_en": "Country (Made by God)",
          "fill": "#065F46",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "circle",
          "cx": 58,
          "cy": 90,
          "r": 16,
          "fill": "#FDE68A",
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 180,
          "y": 92,
          "text_hi": "कोमल चाँदनी (Moonbeam)",
          "text_en": "Soft Moonbeam at Eve",
          "fill": "#047857",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 163,
          "y": 128,
          "text_hi": "दोपहर में बगीचों (Groves) की छाया",
          "text_en": "Shady Groves Console at Noon",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 163,
          "y": 160,
          "text_hi": "स्वास्थ्य (Health) + सदाचार (Virtue)",
          "text_en": "Abundant Health & Virtue",
          "fill": "#065F46",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 163,
          "y": 192,
          "text_hi": "थ्रश और बुलबुल का मधुर संगीत",
          "text_en": "Sweet Warbling of Birds",
          "fill": "#059669",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "rect",
          "x": 332,
          "y": 20,
          "width": 290,
          "height": 200,
          "rx": 12,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 477,
          "y": 48,
          "text_hi": "शहर (Man Made the Town)",
          "text_en": "Town (Made by Man)",
          "fill": "#92400E",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 477,
          "y": 92,
          "text_hi": "तेज़ लैंप चाँद को ढक (Eclipse) देते हैं",
          "text_en": "Glaring Lamps Eclipse the Moon",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 477,
          "y": 128,
          "text_hi": "आलस्य, बनावटी गाड़ियाँ व थकान",
          "text_en": "Idleness, Sedans & Weariness",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 477,
          "y": 160,
          "text_hi": "शोर से थ्रश (Thrush) डरकर भागती है",
          "text_en": "Thrush Departs Scared",
          "fill": "#DC2626",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 477,
          "y": 192,
          "text_hi": "बुलबुल (Nightingale) आहत होकर चुप!",
          "text_en": "Offended Nightingale is Mute!",
          "fill": "#991B1B",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### कविता का पद-दर-पद सरल भावार्थ\n1. **पहला भाग (स्वास्थ्य व सदाचार):** ईश्वर ने गाँव बनाया और मनुष्य ने शहर। इसलिए जीवन को मधुर बनाने वाले **स्वास्थ्य और सदाचार** गाँव के खेतों और बगीचों में सुरक्षित रहते हैं।\n2. **दूसरा भाग (शहरी आलस्य):** शहर के अमीर लोग पालकियों (*sedans*) और रथों (*chariots*) में घूमते हैं, मेहनत नहीं करते और खाली बैठकर ही थक जाते हैं।\n3. **तीसरा भाग (बगीचे और चाँदनी):** गाँव के बगीचे (*groves*) दोपहर में चिंतनशील यात्री (*pensive wanderer*) को शांति देते हैं। शाम को सोई पत्तियों से फिसलती **चाँदनी** ही हमारा प्रकाश है और पक्षियों की चहचहाहट ही हमारा संगीत!\n4. **अंतिम भाग (शहर का शोर):** हमें शहर के चमकते लैंप नहीं चाहिए — वे हमारे कोमल चाँद को ढक (*eclipse*) देते हैं। शहर के शोर भरे गीतों से डरकर **थ्रश पक्षी उड़ जाता है** और **बुलबुल आहत होकर मौन (mute)** हो जाती है।",
    "concept_md_en": "### Stanza-by-Stanza Easy Explanation\n1. **Part 1 (Health & Virtue):** God created the countryside and man built towns; therefore **health and virtue**—the twin gifts that sweeten life—flourish in rural fields and groves.\n2. **Part 2 (Urban Idleness):** Town dwellers ride around in artificial vehicles, avoiding honest labour and growing tired of doing nothing.\n3. **Part 3 (Groves & Moonlight):** Village **groves** comfort the **pensive wanderer** at noon; at evening, soft **moonbeams** sliding through sleeping leaves are all the light needed, and warbling birds all the music.\n4. **Part 4 (City Disruption):** Urban lamps merely **eclipse** our gentler moon, while noisy city songs frighten the **thrush** away and silence the **offended nightingale**.",
    "exam_tip_hi": "मैट्रिक में बार-बार आने वाली जोड़ी: **Thrush = departs scared (डरकर उड़ जाती है)**, **Nightingale = offended & mute (आहत व चुप)**!",
    "exam_tip_en": "Guaranteed Matric pair: **Thrush = departs scared**, **Nightingale = offended and mute**!",
    "glossary_terms": [
      {
        "term_hi": "Pensive (पेंसिव)",
        "term_en": "Pensive",
        "pronunciation_hi": "पेंसिव",
        "definition_hi": "गहरे विचार या शांत चिंतन में डूबा हुआ।",
        "definition_en": "Deep in quiet, reflective thought."
      },
      {
        "term_hi": "Eclipse (इक्लिप्स)",
        "term_en": "Eclipse",
        "pronunciation_hi": "इक्लिप्स",
        "definition_hi": "ढक लेना या फीका कर देना (शहर के लैंप चाँदनी को फीका कर देते हैं)।",
        "definition_en": "To hide or overshadow the light of something."
      }
    ],
    "quick_check": {
      "q_hi": "कविता में \"softer satellite (कोमल उपग्रह)\" किसे कहा गया है?",
      "q_en": "What does \"our softer satellite\" refer to in the poem?",
      "answer_hi": "**चंद्रमा (The Moon)** को।",
      "answer_en": "**The Moon**."
    }
  },
  {
    "id": "gmc-sec-3-lines",
    "order": 3,
    "heading_hi": "3. कविता की मुख्य पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key Poem Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "कविता की ये 4 प्रसिद्ध पंक्तियाँ उच्चारण के साथ ज़ोर से पढ़िए — ये मैट्रिक परीक्षा में सीधी पूछी जाती हैं!",
    "analogy_en": "Read these 4 famous lines aloud — BSEB quotes them directly in MCQs and explanations!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "God Made the Country — प्रमुख काव्य पंक्तियाँ",
      "title_en": "Key Lines from God Made the Country",
      "headers_hi": [
        "काव्य पंक्ति (Poem Line)",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "Poem Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "God made the country, and man made the town.",
            "गॉड मेड द कंट्री, ऐंड मैन मेड द टाउन।",
            "ईश्वर ने गाँव बनाया, और मनुष्य ने शहर बनाया।"
          ],
          "cells_en": [
            "God made the country, and man made the town.",
            "God med the kan-tree, and man med the taaun.",
            "Famous opening line of the poem."
          ]
        },
        {
          "cells_hi": [
            "Our groves were planted to console at noon the pensive wanderer.",
            "आवर ग्रोव्ज़ वर प्लान्टेड टु कंसोल ऐट नून द पेंसिव वॉन्डरर।",
            "हमारे बगीचे दोपहर में विचारमग्न यात्री को शांति देने के लिए लगाए गए।"
          ],
          "cells_en": [
            "Our groves were planted to console at noon the pensive wanderer.",
            "A-war grovz war plaan-ted too kan-sol at noon the pen-siv won-da-rar.",
            "Shows nature's soothing comfort in villages."
          ]
        },
        {
          "cells_hi": [
            "The splendour of your lamps; they but eclipse our softer satellite.",
            "द स्प्लेंडर ऑफ़ योर लैम्प्स; दे बट इक्लिप्स आवर सॉफ़्टर सैटलाइट।",
            "तुम्हारे लैंपों की चकाचौंध केवल हमारे कोमल चंद्रमा को ढक देती है।"
          ],
          "cells_en": [
            "The splendour of your lamps; they but eclipse our softer satellite.",
            "The splen-dar ov yor lamps; the bat i-klips a-war sof-tar sa-ta-laait.",
            "Artificial lights ruin natural moonlight."
          ]
        },
        {
          "cells_hi": [
            "The thrush departs scar'd, and th' offended nightingale is mute.",
            "द थ्रश डिपार्ट्स स्केयर्ड, ऐंड द अफ़ेंडेड नाइटिंगेल इज़ म्यूट।",
            "थ्रश पक्षी डरकर भाग जाता है और आहत बुलबुल चुप हो जाती है।"
          ],
          "cells_en": [
            "The thrush departs scar'd, and th' offended nightingale is mute.",
            "The thrash di-paarts ske-yard, and the a-fen-ded naai-ting-gel iz myoot.",
            "City noise drives away sweet natural birdsong."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Console** (*कंसोल*) = सांत्वना / शांति देना\n2. **Wanderer** (*वॉन्डरर*) = राहगीर / पथिक\n3. **Warbling** (*वॉर्बलिंग*) = पक्षियों का मधुर चहचहाना\n4. **Splendour** (*स्प्लेंडर*) = चमक-दमक / शान\n5. **Confound** (*कंफ़ाउंड*) = उलझाना या ध्वस्त कर देना\n6. **Mute** (*म्यूट*) = बिल्कुल शांत / मौन",
    "concept_md_en": "### Read-Aloud Poetic Vocabulary\n1. **Console** (*कंसोल*) = comfort and soothe\n2. **Wanderer** (*वॉन्डरर*) = traveller on foot\n3. **Warbling** (*वॉर्बलिंग*) = sweet singing of birds\n4. **Splendour** (*स्प्लेंडर*) = dazzling brightness\n5. **Confound** (*कंफ़ाउंड*) = confuse or drown out\n6. **Mute** (*म्यूट*) = silent, speechless",
    "exam_tip_hi": "याद रखें: **Nightingale** का अर्थ **बुलबुल** और **Mute** का अर्थ **मौन/चुप** होता है!",
    "exam_tip_en": "Remember: **Mute** = silent; **Birds warbling** = sweet natural music of villages!",
    "glossary_terms": [
      {
        "term_hi": "Warbling (वॉर्बलिंग)",
        "term_en": "Warbling",
        "pronunciation_hi": "वॉर्बलिंग",
        "definition_hi": "पक्षियों का मीठा और सुरीला चहचहाना।",
        "definition_en": "Singing softly and melodiously like songbirds."
      },
      {
        "term_hi": "Mute (म्यूट)",
        "term_en": "Mute",
        "pronunciation_hi": "म्यूट",
        "definition_hi": "चुप या मौन हो जाना (शहर के शोर से बुलबुल मौन हो जाती है)।",
        "definition_en": "Silent; unable or unwilling to sing."
      }
    ]
  },
  {
    "id": "gmc-sec-4-summary",
    "order": 4,
    "heading_hi": "4. 5-अंक कविता सारांश फ़ॉर्मूला (आसान अंग्रेज़ी में)",
    "heading_en": "4. Easy 5-Mark Poem Summary Formula",
    "analogy_hi": "बस ये 5 छोटी पंक्तियाँ याद कर लें — बिहार बोर्ड के 5-अंक कविता सारांश में पूरे अंक मिलना तय है!",
    "analogy_en": "Memorize these 5 smooth sentences to write an effortless 5/5 summary in the Matric exam!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "कविता सारांश के 5 आसान चरण",
      "title_en": "5 Easy Steps to Write the Poem Summary",
      "direction": "LR",
      "steps": [
        {
          "id": "gm-f1",
          "label_hi": "1. कवि व नाम",
          "label_en": "1. Poet & Title",
          "detail_hi": "William Cowper",
          "accent": "indigo"
        },
        {
          "id": "gm-f2",
          "label_hi": "2. ईश्वर बनाम मानव",
          "label_en": "2. God vs Man",
          "detail_hi": "गाँव बनाम शहर",
          "accent": "emerald"
        },
        {
          "id": "gm-f3",
          "label_hi": "3. स्वास्थ्य व सदाचार",
          "label_en": "3. Health & Virtue",
          "detail_hi": "गाँव में भरपूर",
          "accent": "amber"
        },
        {
          "id": "gm-f4",
          "label_hi": "4. प्रकृति व पक्षी",
          "label_en": "4. Groves & Birds",
          "detail_hi": "चाँदनी व बुलबुल",
          "accent": "slate"
        },
        {
          "id": "gm-f5",
          "label_hi": "5. संदेश",
          "label_en": "5. Message",
          "detail_hi": "प्रकृति से जुड़ो",
          "accent": "indigo"
        }
      ],
      "edges": [
        {
          "from": "gm-f1",
          "to": "gm-f2"
        },
        {
          "from": "gm-f2",
          "to": "gm-f3"
        },
        {
          "from": "gm-f3",
          "to": "gm-f4"
        },
        {
          "from": "gm-f4",
          "to": "gm-f5"
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"God Made the Country\"** is a beautiful nature poem by **William Cowper**.\n2. The poet says that **God made the country (villages)** while **man made the towns**.\n3. True **health and virtue** flourish in peaceful village fields and shady groves.\n4. Villagers enjoy soft **moonlight** and sweet **birdsong**, whereas harsh town lamps eclipse the moon.\n5. Loud urban noise scares away the **thrush** and makes the **nightingale mute**, proving rural nature is purer than artificial towns.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"God Made the Country\"** is a beautiful nature poem by **William Cowper**.\n2. The poet says that **God made the country (villages)** while **man made the towns**.\n3. True **health and virtue** flourish in peaceful village fields and shady groves.\n4. Villagers enjoy soft **moonlight** and sweet **birdsong**, whereas harsh town lamps eclipse the moon.\n5. Loud urban noise scares away the **thrush** and makes the **nightingale mute**, proving rural nature is purer than artificial towns.",
    "exam_tip_hi": "कॉपी में **William Cowper**, **Health and Virtue**, **Moonbeam**, **Thrush**, और **Nightingale** ज़रूर लिखकर अंडरलाइन करें!",
    "exam_tip_en": "Underline **William Cowper**, **Health and Virtue**, **Moonbeam**, **Thrush**, and **Nightingale**!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "शहर के तेज़ गीतों व शोर का थ्रश और बुलबुल पर क्या असर होता है?",
      "q_en": "How do loud town songs affect the thrush and the nightingale?",
      "answer_hi": "थ्रश (thrush) डरकर भाग जाता है और बुलबुल (nightingale) आहत होकर मौन (mute) हो जाती है।",
      "answer_en": "The thrush departs scared, and the offended nightingale becomes mute."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Poet",
      "fact_hi": "विलियम कूपर (William Cowper, 1731–1800) · अंग्रेज़ी प्रकृति-कवि",
      "fact_en": "William Cowper (1731–1800) · English Nature Poet"
    },
    {
      "tag": "Source",
      "fact_hi": "The Task (1785) · Panorama Part-2 (Class 10 Poetry)",
      "fact_en": "The Task (1785) · Panorama Part-2 (Class 10 Poetry)"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "God Made the Country is a classic nature poem by William Cowper.",
      "fact_en": "God Made the Country is a classic nature poem by William Cowper."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "God created pure villages, whereas man built noisy, artificial towns.",
      "fact_en": "God created pure villages, whereas man built noisy, artificial towns."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "Health and virtue flourish freely in village fields and shady groves.",
      "fact_en": "Health and virtue flourish freely in village fields and shady groves."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "Villagers cherish soft moonlight and birdsong, not glaring urban lamps.",
      "fact_en": "Villagers cherish soft moonlight and birdsong, not glaring urban lamps."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "Town noise scares the thrush and silences the offended nightingale.",
      "fact_en": "Town noise scares the thrush and silences the offended nightingale."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "\"Country\" का अर्थ \"भारत देश\" लिख देना।",
      "mistake_en": "Translating \"country\" as \"nation/India\".",
      "fix_hi": "यहाँ **Country** का अर्थ **गाँव / देहात (Countryside)** है!",
      "fix_en": "Here **country** strictly means **countryside / rural village**!"
    },
    {
      "mistake_hi": "थ्रश और बुलबुल की प्रतिक्रिया उलट देना।",
      "mistake_en": "Swapping what happens to the thrush and the nightingale.",
      "fix_hi": "याद रखें: **Thrush departs scared**, **Nightingale is mute**!",
      "fix_en": "Remember: **Thrush = departs scared**, **Nightingale = mute**!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "गाँव और शहर का अंतर (स्वास्थ्य, सदाचार, चाँदनी)",
      "topic_en": "Village vs Town Contrast (Health, Virtue, Moonlight)",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "बगीचों की भूमिका तथा थ्रश व बुलबुल का मौन",
      "topic_en": "Role of Groves & Silence of Thrush/Nightingale",
      "years": [
        "2022",
        "2024"
      ],
      "expected_marks": 2
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-10-eng-ch4',
  2,
  'छात्र "God Made the Country" कविता का लयबद्ध पठन कर सकेंगे, गाँव बनाम शहर का तुलनात्मक चित्र समझ सकेंगे और 5-वाक्य कविता सारांश लिख सकेंगे।',
  'Students will recite key lines of "God Made the Country", contrast village purity with town artificiality, and write a clean 5-mark summary.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "गाँव-शहर तुलना हुक, सस्वर पठन व ब्लैकबोर्ड तुलना तालिका",
    "phase_en": "Village vs City Hook, Aloud Reading & Contrast Table",
    "teacher_action_hi": "छात्रों से पूछें: \"आपको गाँव की शाम ज़्यादा पसंद है या शहर का शोर?\" फिर पहली पंक्ति \"God made the country, and man made the town\" पूरी कक्षा से लय में बुलवाएँ। Virtue (वर्च्यू), Groves (ग्रोव्ज़), Eclipse (इक्लिप्स), Nightingale (नाइटिंगेल) का उच्चारण सिखाएँ।",
    "teacher_action_en": "Ask students to compare village evenings with city noise. Lead chorus recitation of the opening line. Drill Virtue, Groves, Eclipse, and Nightingale, then build the Village vs Town board table.",
    "student_check_hi": "पूछें: \"यहाँ Country शब्द का अर्थ क्या है — देश या गाँव?\"",
    "student_check_en": "Ask: \"What does 'country' mean in this poem — nation or village?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "पंक्ति-दर-पंक्ति व्याख्या, 5-मिनट मौखिक गतिविधि व सारांश",
    "phase_en": "Line Decoding, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "चाँदनी बनाम लैंप और थ्रश/बुलबुल की पंक्तियाँ समझाएँ। 5-मिनट मौखिक आत्मविश्वास गतिविधि में कमजोर छात्र 5-वाक्य सारांश पढ़ें। अंत में 5 मैट्रिक MCQ पूछें।",
    "teacher_action_en": "Explain moonlight vs lamps and the thrush/nightingale lines. Run a 5-min oral relay on the 5-sentence summary, closing with 5 Matric MCQs.",
    "student_check_hi": "पूछें: \"कौन-सा पक्षी डरकर उड़ जाता है और कौन-सा पक्षी चुप हो जाता है?\"",
    "student_check_en": "Ask: \"Which bird departs scared, and which bird becomes mute?\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड कविता सार (God Made the Country)",
    "heading_en": "Blackboard Poem Summary (God Made the Country)",
    "points_hi": [
      "कवि: William Cowper (1731–1800) | Country = गाँव (Countryside)",
      "गाँव के 2 उपहार: Health (स्वास्थ्य) + Virtue (सदाचार)",
      "गाँव: Groves (दोपहर छाया) · Moonbeam (शाम का प्रकाश) · Birds warbling (संगीत)",
      "शहर: Lamps eclipse moon · Thrush departs scared · Nightingale is mute"
    ],
    "points_en": [
      "Poet: William Cowper (1731–1800) | Country = Countryside/Village",
      "2 Gifts in Country: Health + Virtue",
      "Country: Groves (noon shade) · Moonbeam (light) · Warbling birds (music)",
      "Town: Lamps eclipse moon · Thrush departs scared · Nightingale is mute"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"गाँव बनाम शहर\" दो-पंक्ति वाद-विवाद",
    "title_en": "5-Minute \"Village vs Town\" One-Line Chorus",
    "materials_hi": "ब्लैकबोर्ड के दो कॉलम: Village | Town",
    "materials_en": "Two columns on the board: Village | Town",
    "steps_hi": "कक्षा को दो भागों में बाँटें — बाईं ओर के छात्र गाँव की 1 खूबी बोलें (\"Villages have fresh air\"), दाईं ओर के छात्र शहर की 1 कमी (\"Towns have noise\")।",
    "steps_en": "Split class in two: left side names 1 village gift, right side names 1 city flaw in simple English."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Virtue, Groves, Pensive, Eclipse और Mute के अर्थ व उच्चारण 3 बार लिखें।",
    "task_en": "Write Virtue, Groves, Pensive, Eclipse, and Mute 3 times with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "गाँव में स्वास्थ्य और सदाचार क्यों अधिक मिलते हैं? 2–3 वाक्यों में उत्तर लिखें।",
    "task_en": "Why do health and virtue abound in villages? Answer in 2–3 sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "\"God Made the Country\" का 5-अंक सारांश बिना देखे कॉपी में लिखें।",
    "task_en": "Write the 5-mark summary of \"God Made the Country\" from memory."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र \"Softer satellite\" का अर्थ कृत्रिम उपग्रह (ISRO satellite) समझ लेते हैं।",
    "misconception_en": "Students think \"softer satellite\" means a modern space satellite.",
    "correction_hi": "स्पष्ट करें कि यह 1785 की कविता है — यहाँ \"softer satellite\" पृथ्वी के प्राकृतिक उपग्रह **चंद्रमा (Moon)** के लिए प्रयुक्त हुआ है!",
    "correction_en": "Explain this 1785 poem refers to Earth's natural satellite — **the Moon**!"
  },
  {
    "misconception_hi": "छात्र कवि का नाम \"William Wordsworth\" लिख देते हैं।",
    "misconception_en": "Students write William Wordsworth instead of William Cowper.",
    "correction_hi": "ट्रिक दें: \"गाँव में गाय (Cow) होती है → William **Cow**per = God Made the Country!\"",
    "correction_en": "Memory hook: \"Villages have cows -> William **Cow**per = God Made the Country!\""
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
  (
    '10000007-0004-4000-8000-000000000001', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Poet & Hook', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2023',
    'God Made the Country के कवि कौन हैं और मुख्य पंक्ति क्या है?',
    'Who wrote "God Made the Country" and what is its famous opening line?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"God Made the Country\" के कवि और पहली प्रसिद्ध पंक्ति बताएँ।",
  "front_en": "Name the poet and famous first line of \"God Made the Country\".",
  "back_hi": "कवि: William Cowper (1731–1800) · पंक्ति: \"God made the country, and man made the town.\"",
  "back_en": "Poet: William Cowper (1731–1800) · Line: \"God made the country, and man made the town.\"",
  "pronunciation_hi": "गॉड मेड द कंट्री — विलियम कूपर",
  "mnemonic_hi": "ट्रिक: गाँव में गाय (Cow) → William Cowper!",
  "mnemonic_en": "Hook: Country has cows -> William Cowper!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000002', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Virtue और Groves का उच्चारण व अर्थ क्या है?',
    'Give the pronunciation and meaning of Virtue and Groves.',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Virtue और Groves शब्दों का उच्चारण व हिंदी अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Virtue\" and \"Groves\".",
  "back_hi": "Virtue (वर्च्यू) = सदाचार / नेकी · Groves (ग्रोव्ज़) = पेड़ों का छायादार बगीचा / झुरमुट।",
  "back_en": "Virtue = moral goodness · Groves = shady clusters of trees.",
  "pronunciation_hi": "वर्च्यू · ग्रोव्ज़",
  "mnemonic_hi": "गाँव के Groves (बगीचे) में Health और Virtue (सदाचार) बसते हैं!",
  "mnemonic_en": "Health and Virtue live in peaceful village Groves!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000003', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Poem Imagery Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2024',
    'कविता के प्रतीकों को उनके सही संदर्भ से मिलाएँ:',
    'Match each image in Column A with its exact meaning in the poem:',
    NULL, NULL,
    'चाँदनी, बगीचे, थ्रश और बुलबुल की भूमिका मिलाएँ।', 'Match softer satellite, groves, thrush, and nightingale.',
    'Softer satellite = चंद्रमा, Groves = दोपहर में पथिक को शांति, Thrush = डरकर उड़ जाती है, Nightingale = आहत होकर मौन।', 'Softer satellite = the Moon, Groves = console at noon, Thrush = departs scared, Nightingale = becomes mute.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each poetic image cleanly",
  "pairs": [
    {
      "id": "gmc-m1",
      "left_hi": "Softer satellite",
      "left_en": "Softer satellite",
      "right_hi": "चंद्रमा (The Moon)",
      "right_en": "The Moon"
    },
    {
      "id": "gmc-m2",
      "left_hi": "Groves (बगीचे)",
      "left_en": "Groves",
      "right_hi": "दोपहर में विचारमग्न यात्री को शांति देते हैं",
      "right_en": "Console the pensive wanderer at noon"
    },
    {
      "id": "gmc-m3",
      "left_hi": "The Thrush (थ्रश)",
      "left_en": "The Thrush",
      "right_hi": "शहर के शोर से डरकर उड़ जाता है",
      "right_en": "Departs scared by city songs"
    },
    {
      "id": "gmc-m4",
      "left_hi": "The Nightingale (बुलबुल)",
      "left_en": "The Nightingale",
      "right_hi": "आहत होकर मौन (mute) हो जाती है",
      "right_en": "Offended and becomes mute"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000004', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'कविता की प्रसिद्ध पहली पंक्ति बनाएँ: "ईश्वर ने गाँव बनाया और मनुष्य ने शहर बनाया।"',
    'Build the iconic opening line: "God made the country and man made the town"',
    NULL, NULL,
    'दोनों तरफ़ Past verb "made" प्रयोग करें।', 'Use past verb "made" in both halves.',
    'सही पंक्ति: "God made the country and man made the town"।', 'Correct line: "God made the country and man made the town".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "ईश्वर ने गाँव बनाया और मनुष्य ने शहर बनाया।",
  "prompt_en": "Build the opening line of William Cowper's poem",
  "grammar_formula": "Subject + made + Object + and + Subject + made + Object",
  "tokens": [
    "God",
    "made",
    "the",
    "country",
    "and",
    "man",
    "made",
    "the",
    "town"
  ],
  "distractors": [
    "make",
    "makes"
  ],
  "correct_sentence": "God made the country and man made the town",
  "pronunciation_hi": "गॉड मेड द कंट्री ऐंड मैन मेड द टाउन"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000005', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य सजाएँ: "स्वास्थ्य और सदाचार गाँवों में भरपूर मिलते हैं।"',
    'Build the sentence: "Health and virtue abound in villages"',
    NULL, NULL,
    'दो विषय ("Health and virtue") मिलकर बहुवचन बनते हैं → "abound" (बिना s)।', 'Compound subject "Health and virtue" takes plural verb "abound".',
    'सही वाक्य: "Health and virtue abound in villages"।', 'Correct sentence: "Health and virtue abound in villages".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "स्वास्थ्य और सदाचार गाँवों में भरपूर मिलते हैं।",
  "prompt_en": "Build a key theme sentence from the poem",
  "grammar_formula": "Noun 1 + and + Noun 2 + V1 (plural) + in + Place",
  "tokens": [
    "Health",
    "and",
    "virtue",
    "abound",
    "in",
    "villages"
  ],
  "distractors": [
    "abounds",
    "on"
  ],
  "correct_sentence": "Health and virtue abound in villages",
  "pronunciation_hi": "हेल्थ ऐंड वर्च्यू अबाउंड इन विलेजेज़"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000006', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Poet MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    '"God Made the Country" कविता के रचयिता कौन हैं?',
    'Who composed the poem "God Made the Country"?',
    $json$[{"key":"A","text_hi":"अलेक्जेंडर पोप","text_en":"Alexander Pope"},{"key":"B","text_hi":"जॉन कीट्स","text_en":"John Keats"},{"key":"C","text_hi":"विलियम वर्ड्सवर्थ","text_en":"William Wordsworth"},{"key":"D","text_hi":"विलियम कूपर","text_en":"William Cowper"}]$json$::jsonb, 'D',
    'गाँव में गाय (Cow) वाली ट्रिक याद करें!', 'Use the Cow -> Cowper memory hook!',
    '"God Made the Country" 18वीं सदी के कवि विलियम कूपर (William Cowper) की कविता है।', 'William Cowper composed "God Made the Country".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000007', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Two Gifts MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'कवि के अनुसार जीवन के कड़वे घूँट को कौन-से दो उपहार मीठा बनाते हैं?',
    'According to Cowper, which two gifts alone can make life''s bitter draught sweet?',
    $json$[{"key":"A","text_hi":"धन और शक्ति (Wealth and power)","text_en":"Wealth and power"},{"key":"B","text_hi":"स्वास्थ्य और सदाचार (Health and virtue)","text_en":"Health and virtue"},{"key":"C","text_hi":"कार और महल (Cars and palaces)","text_en":"Cars and palaces"},{"key":"D","text_hi":"सोना और चाँदी (Gold and silver)","text_en":"Gold and silver"}]$json$::jsonb, 'B',
    'ये दोनों उपहार गाँव के खेतों और बगीचों में भरपूर मिलते हैं।', 'Both flourish in village fields and groves.',
    'कवि कहते हैं कि स्वास्थ्य (health) और सदाचार (virtue) ही जीवन को मधुर बनाते हैं।', 'Cowper writes that health and virtue alone sweeten the bitter draught of life.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000008', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Nightingale Fate MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'शहर के शोर भरे गीतों को सुनकर बुलबुल (Nightingale) की क्या दशा होती है?',
    'What happens to the offended nightingale due to harsh town songs?',
    $json$[{"key":"A","text_hi":"वह मौन (mute) हो जाती है","text_en":"She becomes mute"},{"key":"B","text_hi":"वह शहर में बस जाती है","text_en":"She settles in town"},{"key":"C","text_hi":"वह सो जाती है","text_en":"She falls asleep"},{"key":"D","text_hi":"वह और ज़ोर से गाती है","text_en":"She sings louder"}]$json$::jsonb, 'A',
    'अंतिम पंक्ति याद करें: "and th'' offended nightingale is ___."', 'Complete the final line of the poem.',
    'शहर के बनावटी शोर से आहत होकर बुलबुल मौन (mute) हो जाती है।', 'Offended by jarring urban noise, the nightingale falls mute.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000009', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Groves Purpose MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'कवि के अनुसार गाँव के बगीचे (Groves) दोपहर में किसे शांति देने के लिए लगाए गए थे?',
    'According to the poem, whom were village groves planted to console at noon?',
    $json$[{"key":"A","text_hi":"शहर के गायकों को","text_en":"City singers"},{"key":"B","text_hi":"धनी व्यापारी को","text_en":"The rich merchant"},{"key":"C","text_hi":"विचारमग्न पथिक (Pensive wanderer) को","text_en":"The pensive wanderer"},{"key":"D","text_hi":"राजा के सैनिकों को","text_en":"The king's soldiers"}]$json$::jsonb, 'C',
    'पंक्ति याद करें: "to console at noon / The pensive wanderer in their shades."', 'Recall the exact poetic phrase.',
    'बगीचे दोपहर की धूप में विचारमग्न पथिक (pensive wanderer) को अपनी छाया से शांति देते हैं।', 'Groves were planted to console the pensive wanderer in their shades at noon.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000010', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Softer Satellite', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    'शहर के चमकते लैंप किसे ढक (eclipse) देते हैं?',
    'What do the splendid artificial lamps of towns eclipse?',
    $json$[{"key":"A","text_hi":"बारिश के बादलों को","text_en":"Rain clouds"},{"key":"B","text_hi":"पहाड़ों को","text_en":"The mountains"},{"key":"C","text_hi":"दोपहर के सूर्य को","text_en":"The midday sun"},{"key":"D","text_hi":"हमारे कोमल उपग्रह — चंद्रमा (softer satellite) को","text_en":"Our softer satellite (the Moon)"}]$json$::jsonb, 'D',
    'रात के समय आकाश में चमकने वाला पृथ्वी का प्राकृतिक उपग्रह।', 'Earth''s gentle natural satellite shining at night.',
    'शहर के तेज़ लैंप हमारे कोमल उपग्रह यानी चंद्रमा (Moon) की मधुर चाँदनी को फीका कर देते हैं।', 'Urban lamps overshadow the gentle glow of our softer satellite, the Moon.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000011', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Exam Pool: Village Music', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'गाँव के लोगों के लिए शाम को कौन-सा संगीत पर्याप्त है?',
    'At evening, what is "all the music" that village dwellers wish for?',
    $json$[{"key":"A","text_hi":"पक्षियों का मधुर कलरव (Birds warbling)","text_en":"Birds warbling"},{"key":"B","text_hi":"ड्रम और बैंड","text_en":"Drums and bands"},{"key":"C","text_hi":"शहर का रेडियो","text_en":"City radio"},{"key":"D","text_hi":"लाउडस्पीकर के गीत","text_en":"Loudspeaker songs"}]$json$::jsonb, 'A',
    'पंक्ति: "Birds warbling all the music."', 'Line: "Birds warbling all the music."',
    'गाँव वालों को केवल पक्षियों का मधुर गान (birds warbling) ही सबसे सुंदर संगीत लगता है।', 'Villagers wish for nothing more than birds warbling as their evening music.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000012', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Exam Pool: Thrush Reaction', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2023',
    'शहर के शोर भरे गीतों से थ्रश (Thrush) पक्षी क्या करता है?',
    'How does the thrush react to noisy urban songs?',
    $json$[{"key":"A","text_hi":"बुलबुल के साथ गाता है","text_en":"Sings with the nightingale"},{"key":"B","text_hi":"डरकर उड़ जाता है (Departs scared)","text_en":"Departs scared"},{"key":"C","text_hi":"खुश होकर नाचता है","text_en":"Dances happily"},{"key":"D","text_hi":"लैंप पर बैठ जाता है","text_en":"Sits on a lamp"}]$json$::jsonb, 'B',
    '"The thrush departs / Scar''d..."', '"The thrush departs / Scar''d..."',
    'थ्रश पक्षी शहर के शोर से डरकर उड़ जाता है (departs scared)।', 'The thrush departs scared by jarring town noise.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000013', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Village vs Town 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'विलियम कूपर ने गाँव के जीवन को शहर के जीवन से श्रेष्ठ क्यों बताया है?',
    'Why does William Cowper consider village life superior to town life?',
    NULL, NULL,
    'दो बिंदु लिखें: (1) स्वास्थ्य व सदाचार, (2) प्राकृतिक चाँदनी व पक्षियों का संगीत।', 'Include 2 points: health & virtue, plus natural moonlight & birdsong.',
    NULL, NULL,
    'विलियम कूपर गाँव को शहर से श्रेष्ठ मानते हैं क्योंकि:
1. गाँव ईश्वर की रचना हैं जहाँ **स्वास्थ्य (health)** और **सदाचार (virtue)** भरपूर मिलते हैं।
2. गाँव में बगीचों की छाया, कोमल चाँदनी और पक्षियों का मधुर संगीत है, जबकि मनुष्य द्वारा बनाए गए शहर में आलस्य, कृत्रिम चमक और शोर है।', 'William Cowper considers village life superior to town life because:
1. Villages are made by God and abound in **health and virtue**, which sweeten human life.
2. Villages offer shady groves, soft moonlight, and sweet birdsong, whereas man-made towns breed idleness, artificial glare, and noise.',
    $json$[{"cue_hi":"ईश्वर रचित गाँव = स्वास्थ्य व सदाचार","cue_en":"God-made country = health & virtue"},{"cue_hi":"चाँदनी व पक्षी बनाम शहरी लैंप व शोर","cue_en":"Moonlight & birds vs lamps & noise"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"ईश्वर रचित गाँव में स्वास्थ्य व सदाचार का उल्लेख","criterion_en":"Mentions health and virtue in God-made country"},{"step_no":2,"marks":1,"criterion_hi":"प्राकृतिक शांति बनाम शहरी बनावट/शोर की तुलना","criterion_en":"Contrasts rural serenity with urban glare and noise"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0004-4000-8000-000000000014', 'bseb-10-eng', 'bseb-10-eng-ch4', 'Poem Summary 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"God Made the Country" कविता का सारांश अपने सरल शब्दों में लिखें।',
    'Write the summary of William Cowper''s poem "God Made the Country".',
    NULL, NULL,
    'कवि का नाम, गाँव बनाम शहर, स्वास्थ्य-सदाचार, बगीचे-चाँदनी, और थ्रश-बुलबुल लिखें।', 'Cover poet, country vs town, health & virtue, groves & moonlight, thrush & nightingale.',
    NULL, NULL,
    '**"God Made the Country"** 18वीं सदी के प्रसिद्ध अंग्रेज़ी प्रकृति-कवि **विलियम कूपर** की सुंदर कविता है।

कवि स्पष्ट कहते हैं कि **गाँव ईश्वर ने बनाए हैं और शहर मनुष्य ने**। इसीलिए जीवन के दो सबसे अनमोल उपहार — **स्वास्थ्य (health)** और **सदाचार (virtue)** — गाँव के शांत खेतों व बगीचों में सुरक्षित रहते हैं। शहर के लोग आलस्य और बनावटी सुख में जीते हैं, जबकि गाँव के बगीचे दोपहर में थके पथिक को छाया व शांति देते हैं। शाम को पत्तों से छनती कोमल **चाँदनी** और पक्षियों का मधुर गान ही गाँव वालों का सुख है। शहर के तेज़ लैंप चाँदनी को ढक देते हैं और शहरी शोर से **थ्रश डरकर उड़ जाता है** तथा **बुलबुल आहत होकर चुप** हो जाती है। यह कविता हमें प्रकृति और सरल ग्रामीण जीवन से प्रेम करने की सीख देती है।', '**"God Made the Country"** is a celebrated nature poem by **William Cowper** contrasting rural purity with urban artificiality.

The poet declares that **God made the country (villages)** while **man made the town**. Hence, **health and virtue** — the two gifts that make life sweet — flourish best in rural fields and groves. While townspeople grow weary in idleness and artificial luxury, village groves comfort the pensive wanderer at noon. At evening, soft **moonbeams** and **warbling birds** bring pure joy. Harsh town lamps only eclipse the gentler moon, and noisy city songs frighten the **thrush** away and silence the **offended nightingale**. The poem urges us to value nature''s quiet beauty over urban glare.',
    $json$[{"cue_hi":"William Cowper · God vs Man","cue_en":"William Cowper · God vs Man"},{"cue_hi":"Health & Virtue in fields and groves","cue_en":"Health & Virtue in fields and groves"},{"cue_hi":"Moonbeam vs glaring lamps (eclipse)","cue_en":"Moonbeam vs glaring lamps (eclipse)"},{"cue_hi":"Thrush scared · Nightingale mute","cue_en":"Thrush scared · Nightingale mute"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"कवि (William Cowper) व मुख्य पंक्ति का उल्लेख","criterion_en":"Names William Cowper and central opening line"},{"step_no":2,"marks":1.5,"criterion_hi":"स्वास्थ्य, सदाचार व बगीचों की छाया का वर्णन","criterion_en":"Highlights health, virtue, and shady groves"},{"step_no":3,"marks":1.5,"criterion_hi":"चाँदनी बनाम लैंप व थ्रश/बुलबुल का प्रसंग","criterion_en":"Explains moonlight vs lamps and thrush/nightingale"},{"step_no":4,"marks":1,"criterion_hi":"प्रकृति-प्रेम का स्पष्ट निष्कर्ष","criterion_en":"Concludes with love for pure natural life"}]$json$::jsonb,
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
-- CHAPTER 5 OF 14: BSEB-10-ENG-CH5 — The Sleeping Porter (Poem) — Laxmi Prasad Devkota
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-10-eng-ch5',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: सोया हुआ कुली (The Sleeping Porter)",
  "title_en": "30-Second Mindmap: The Sleeping Porter",
  "read_time_seconds": 30,
  "central_node": {
    "id": "sp-root",
    "label_hi": "The Sleeping Porter",
    "label_en": "The Sleeping Porter (Poem)",
    "subtitle_hi": "Laxmi Prasad Devkota (1909–1959) · Panorama Part-2",
    "subtitle_en": "Laxmi Prasad Devkota (1909–1959) · Panorama Part-2"
  },
  "branches": [
    {
      "id": "sp-poet",
      "label_hi": "1. कवि: महाकवि देवकोटा",
      "label_en": "1. Poet: Mahakavi Devkota",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "sp-p1",
          "label_hi": "लक्ष्मी प्रसाद देवकोटा (1909–1959) — नेपाल के महाकवि",
          "label_en": "Laxmi Prasad Devkota (1909–1959) — Mahakavi of Nepal"
        },
        {
          "id": "sp-p2",
          "label_hi": "गरीब श्रमजीवी वर्ग के प्रति गहरी संवेदना के कवि",
          "label_en": "Celebrated for deep compassion toward poor working people"
        }
      ]
    },
    {
      "id": "sp-burden",
      "label_hi": "2. कुली का कठोर परिश्रम",
      "label_en": "2. The Porter's Harsh Struggle",
      "color": "#D97706",
      "children": [
        {
          "id": "sp-b1",
          "label_hi": "पीठ पर 25 किलो बोझ (25-kilo load), दोहरी झुकी रीढ़",
          "label_en": "25-kilo load on his back, spine double-bent"
        },
        {
          "id": "sp-b2",
          "label_hi": "सर्दी की बर्फ़ में 6 मील की पहाड़ी चढ़ाई (Six-mile climb)",
          "label_en": "Six-mile uphill climb in the snows of winter"
        },
        {
          "id": "sp-b3",
          "label_hi": "काली, मैली, पसीने से सनी टोपी · दिल चिड़िया की तरह धड़कता है",
          "label_en": "Black dirty sweat-stained cap · Heart twittering like a bird"
        }
      ]
    },
    {
      "id": "sp-family",
      "label_hi": "3. पहाड़ी झोपड़ी व निर्धन परिवार",
      "label_en": "3. Cliff Hut & Starving Family",
      "color": "#059669",
      "children": [
        {
          "id": "sp-f1",
          "label_hi": "चट्टान पर झोपड़ी: भूख व ठंड से काँपता बेटा",
          "label_en": "Hut on the cliff: son shivering with cold and hunger"
        },
        {
          "id": "sp-f2",
          "label_hi": "माँ भोजन के लिए बिच्छू-बूटी व लताएँ (nettles & vines) खोजती है",
          "label_en": "Mother searching for nettles and vines to feed him"
        }
      ]
    },
    {
      "id": "sp-climax",
      "label_hi": "4. विजेता नायक व नींद का साम्राज्य",
      "label_en": "4. Hero of Mountain & Kingdom of Sleep",
      "color": "#7C3AED",
      "children": [
        {
          "id": "sp-c1",
          "label_hi": "वह पहाड़ को चुनौती देने वाला सच्चा नायक है (Challenging the mountain)",
          "label_en": "A true hero challenging the mighty mountain"
        },
        {
          "id": "sp-c2",
          "label_hi": "अंत में वह \"नींद के समृद्ध साम्राज्य (rich kingdom of sleep)\" पर राज करता है!",
          "label_en": "Finally reigns over the \"rich kingdom of sleep\"!"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "sp-sec-1-poet",
    "order": 1,
    "heading_hi": "1. कवि परिचय और मेहनतकश कुली से सीधा जुड़ाव",
    "heading_en": "1. Poet Profile & Real-World Connection",
    "analogy_hi": "पटना जंक्शन, मुज़फ़्फ़रपुर स्टेशन या पहाड़ी रास्तों पर जब आप किसी दुबले-पतले कुली को सिर व पीठ पर भारी बक्सा उठाए पसीने में तरबतर देखते हैं — तो उसका दर्द महसूस होता है! नेपाल के महाकवि **लक्ष्मी प्रसाद देवकोटा** ने ऐसे ही एक पहाड़ी कुली की अद्भुत हिम्मत और गरीबी को **The Sleeping Porter** में अमर बना दिया है।",
    "analogy_en": "Have you ever seen a thin porter at Patna Junction or on a steep hill path sweating under a massive load? Nepal's legendary poet **Laxmi Prasad Devkota** honours the silent heroism of a mountain porter in **The Sleeping Porter**.",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "कुली के कठिन जीवन के सटीक आँकड़े (मैट्रिक MCQ की खान!)",
      "title_en": "Exact Details of the Porter's Struggle (Matric MCQ Gold!)",
      "headers_hi": [
        "विवरण (Detail)",
        "कविता में सटीक तथ्य"
      ],
      "headers_en": [
        "Detail",
        "Exact Fact in the Poem"
      ],
      "rows": [
        {
          "cells_hi": [
            "पीठ पर बोझ (Load)",
            "25 किलोग्राम (A twenty-five kilo load)"
          ],
          "cells_en": [
            "Load on his back",
            "25 kilos (A twenty-five kilo load)"
          ]
        },
        {
          "cells_hi": [
            "चढ़ाई की दूरी (Distance)",
            "सर्दी की बर्फ़ में 6 मील ऊपर (A six-mile climb)"
          ],
          "cells_en": [
            "Distance climbed",
            "A six-mile climb in the snows of winter"
          ]
        },
        {
          "cells_hi": [
            "टोपी (Cap)",
            "काली, मैली और पसीने से भीगी टोपी (Black, dirty, sweat-stained)"
          ],
          "cells_en": [
            "Cap worn",
            "A black, dirty, sweat-stained cap"
          ]
        },
        {
          "cells_hi": [
            "चुनौती (Challenge)",
            "वह विशाल पहाड़ को चुनौती दे रहा है (Challenging the mountain)"
          ],
          "cells_en": [
            "Who he challenges",
            "He is challenging the mountain"
          ]
        },
        {
          "cells_hi": [
            "अंतिम दृश्य (Ending)",
            "नींद के समृद्ध साम्राज्य पर राज करता है (Reigning over the rich kingdom of sleep)"
          ],
          "cells_en": [
            "Final image",
            "Reigning over the rich kingdom of sleep"
          ]
        }
      ]
    },
    "concept_md_hi": "### कवि और कविता की आत्मा\n- **कवि:** **लक्ष्मी प्रसाद देवकोटा (1909–1959)** नेपाल के महानतम कवि (**महाकवि**) थे। बिहार और नेपाल की सीमा व संस्कृति अत्यंत निकट हैं — उनकी कविता में पहाड़ के गरीब श्रमजीवियों के प्रति गहरा सम्मान है।\n- **शारीरिक दशा:** कुली की पीठ पर **25 किलो का बोझ** है, उसकी रीढ़ दोहरी झुकी (*double-bent*) है, शरीर कंकाल जैसा दुबला है, और वह सर्दी की बर्फ़ में **6 मील की पहाड़ी चढ़ाई** चढ़ रहा है।",
    "concept_md_en": "### About the Poet & Opening Image\n- **Poet:** **Laxmi Prasad Devkota (1909–1959)** is hailed as the *Mahakavi* (Great Poet) of Nepal, celebrated for empathy toward the poor.\n- **Physical Hardship:** Carrying a **25-kilo load**, spine **double-bent**, skeleton-like frail body climbing **six miles uphill** in the **snows of winter**.",
    "exam_tip_hi": "दो संख्याएँ कभी न भूलें: बोझ = **25 kilo**, चढ़ाई = **6 miles**! दोनों हर साल मैट्रिक में आते हैं!",
    "exam_tip_en": "Never forget these two numbers: Load = **25 kilos**, Climb = **6 miles**!",
    "glossary_terms": [
      {
        "term_hi": "Porter (पॉर्टर)",
        "term_en": "Porter",
        "pronunciation_hi": "पॉर्टर",
        "definition_hi": "बोझ ढोने वाला कुली / भारवाहक।",
        "definition_en": "A worker who carries heavy luggage or loads for a living."
      },
      {
        "term_hi": "Stout (स्टाउट)",
        "term_en": "Stout",
        "pronunciation_hi": "स्टाउट",
        "definition_hi": "मज़बूत और दृढ़ (कुली की आत्मा व हृदय पहाड़-सा मज़बूत है)।",
        "definition_en": "Strong, brave, and determined."
      }
    ]
  },
  {
    "id": "sp-sec-2-stanzas",
    "order": 2,
    "heading_hi": "2. विज़ुअल स्टोरीबोर्ड: पहाड़ी चढ़ाई से \"नींद के साम्राज्य\" तक",
    "heading_en": "2. Visual Storyboard: From Icy Climb to the Kingdom of Sleep",
    "analogy_hi": "कविता एक फ़िल्म के कैमरे की तरह चलती है — पहले कुली का भारी बोझ, फिर उसका धड़कता दिल, फिर चट्टान की झोपड़ी में भूखा बेटा और माँ, और अंत में तारों के नीचे शांत सोता हुआ विजेता कुली!",
    "analogy_en": "Like a cinema camera, the poem moves from the porter's bent back, to his bird-like beating heart, to his starving hut on the cliff, and finally to his royal peace in deep sleep!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "The Sleeping Porter — 4 काव्य-दृश्य",
      "title_en": "The Sleeping Porter — 4 Poetic Scenes",
      "direction": "TB",
      "steps": [
        {
          "id": "sp-s1",
          "label_hi": "1. कठोर चढ़ाई: 25 किलो बोझ व 6 मील बर्फ़ीला रास्ता",
          "label_en": "1. Gruelling Climb: 25-Kilo Load & 6 Miles in Snow",
          "detail_hi": "दुबला कंकाल-सा शरीर, दोहरी झुकी रीढ़, नंगे पाँव — मानो पहाड़ को चुनौती दे रहा हो!",
          "detail_en": "Frail skeleton-like frame, spine double-bent, bravely challenging the mountain.",
          "accent": "amber"
        },
        {
          "id": "sp-s2",
          "label_hi": "2. पसीने से सनी काली टोपी व चिड़िया-सा धड़कता दिल",
          "label_en": "2. Dirty Black Cap & Bird-Like Beating Heart",
          "detail_hi": "माथे पर पसीने की बूँदें, सल्फर-सी गंध, साँस फूल रही है और दिल चिड़िया की तरह फड़फड़ा रहा है।",
          "detail_en": "Sweat-stained black cap, panting chest, heart twittering like a bird.",
          "accent": "slate"
        },
        {
          "id": "sp-s3",
          "label_hi": "3. चट्टान की झोपड़ी: भूखा बेटा और बिच्छू-बूटी खोजती माँ",
          "label_en": "3. Cliff Hut: Shivering Son & Mother Hunting Nettles",
          "detail_hi": "घर में ठंड व भूख से काँपता बेटा रो रहा है और उसकी माँ खाने के लिए जंगली साग/बिच्छू-बूटी (nettles & vines) ढूँढ रही है।",
          "detail_en": "Inside his cliff hut, his son shivers with hunger while the mother searches for nettles and vines.",
          "accent": "indigo"
        },
        {
          "id": "sp-s4",
          "label_hi": "4. तारों के नीचे नींद का समृद्ध सम्राट!",
          "label_en": "4. King of the Rich Kingdom of Sleep!",
          "detail_hi": "दिन भर की थकान के बाद गहरी नींद में सोया कुली सारे दुख भूलकर \"नींद के समृद्ध साम्राज्य\" पर राजा की तरह राज करता है।",
          "detail_en": "Beneath the starry lid of night, he reigns serenely over the \"rich kingdom of sleep\".",
          "accent": "emerald"
        }
      ],
      "edges": [
        {
          "from": "sp-s1",
          "to": "sp-s2",
          "label_hi": "शारीरिक थकान",
          "label_en": "Exhaustion"
        },
        {
          "from": "sp-s2",
          "to": "sp-s3",
          "label_hi": "परिवार की पीड़ा",
          "label_en": "Home poverty"
        },
        {
          "from": "sp-s3",
          "to": "sp-s4",
          "label_hi": "रात्रि की शांति",
          "label_en": "Peaceful sleep"
        }
      ]
    },
    "concept_md_hi": "### कविता का गहरा मानवीय अर्थ\n- **कुली = पहाड़ का सच्चा नायक:** यद्यपि उसका शरीर कंकाल जैसा कमज़ोर है, फिर भी उसका साहस पहाड़ से बड़ा है — कवि उसे **\"पहाड़ का विजेता नायक (hero of the mountain)\"** कहते हैं।\n- **गरीबी का यथार्थ चित्रण:** उसकी झोपड़ी में न अनाज है न गरम कपड़े — बेटा ठंड से काँप रहा है और माँ जंगली पत्तियाँ (**nettles and vines**) खोज रही है।\n- **अंतिम चमत्कार (नींद का साम्राज्य):** दिन में दुनिया के सबसे गरीब दिखने वाले इस कुली को रात की गहरी नींद राजा बना देती है — **\"reigning over the rich kingdom of sleep\"**।",
    "concept_md_en": "### Deep Human Meaning of the Poem\n- **Hero of the Mountain:** Despite his frail skeleton-like frame, his courage rivals the peaks — he is truly **\"challenging the mountain\"**.\n- **Stark Poverty:** His cliff hut has neither food nor warmth; his shivering son cries while his mother gathers wild **nettles and vines**.\n- **Royal Peace in Sleep:** Exhaustion gives him the purest reward at night — he becomes a monarch **\"reigning over the rich kingdom of sleep\"**.",
    "exam_tip_hi": "याद रखें: कुली का दिल किसकी तरह धड़कता है? → **Like a bird (चिड़िया की तरह)**! माँ क्या खोजती है? → **Nettles and vines**!",
    "exam_tip_en": "Key lines: Heart beats **like a bird**; Mother searches for **nettles and vines**!",
    "glossary_terms": [
      {
        "term_hi": "Nettles and Vines (नेटल्स ऐंड वाइन्स)",
        "term_en": "Nettles and Vines",
        "pronunciation_hi": "नेटल्स ऐंड वाइन्स",
        "definition_hi": "पहाड़ पर उगने वाले जंगली काँटेदार पौधे व लताएँ जिन्हें गरीब उबालकर खाते हैं।",
        "definition_en": "Wild stinging plants and climbing vines gathered for survival food."
      },
      {
        "term_hi": "Reigning (रेनिंग)",
        "term_en": "Reigning",
        "pronunciation_hi": "रेनिंग",
        "definition_hi": "राजा की तरह शासन करना (ध्यान दें: \"g\" मौन है, उच्चारण \"रेनिंग\")।",
        "definition_en": "Ruling like a sovereign king (silent \"g\")."
      }
    ],
    "quick_check": {
      "q_hi": "कविता की अंतिम पंक्तियों में पाठक कुली को क्या करते हुए पाता है?",
      "q_en": "What does the reader find the porter doing in the closing lines of the poem?",
      "answer_hi": "वह गहरी नींद में सोया हुआ **\"नींद के समृद्ध साम्राज्य (rich kingdom of sleep)\"** पर राज कर रहा है।",
      "answer_en": "He is fast asleep, **\"reigning over the rich kingdom of sleep\"**."
    }
  },
  {
    "id": "sp-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key Poem Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "कविता की ये 4 शक्तिशाली पंक्तियाँ ज़ोर से बोलकर याद कर लें — यही परीक्षा के 2-अंक व 5-अंक उत्तर की जान हैं!",
    "analogy_en": "Practice saying these 4 vivid lines aloud — they power your 2M and 5M board answers!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "The Sleeping Porter — मुख्य पंक्तियाँ (उच्चारण + अर्थ)",
      "title_en": "Key Lines from The Sleeping Porter",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "A twenty-five kilo load on his back, spine double-bent.",
            "अ ट्वेंटी-फ़ाइव किलो लोड ऑन हिज़ बैक, स्पाइन डबल-बेंट।",
            "पीठ पर पच्चीस किलो का बोझ, और रीढ़ दोहरी झुकी हुई।"
          ],
          "cells_en": [
            "A twenty-five kilo load on his back, spine double-bent.",
            "A twen-tee-faaiv ki-lo lod on hiz bak, spaain da-bal-bent.",
            "Shows the crushing weight he carries."
          ]
        },
        {
          "cells_hi": [
            "A six-mile climb up in the snows of winter.",
            "अ सिक्स-माइल क्लाइंब अप इन द स्नोज़ ऑफ़ विंटर।",
            "सर्दी की बर्फ़ में छह मील की खड़ी पहाड़ी चढ़ाई।"
          ],
          "cells_en": [
            "A six-mile climb up in the snows of winter.",
            "A siks-maail klaaim ap in the snoz ov win-tar.",
            "Shows harsh winter mountain conditions."
          ]
        },
        {
          "cells_hi": [
            "His heart is twittering, panting; he is sweating and out of breath.",
            "हिज़ हार्ट इज़ ट्विटरिंग, पैंटिंग; ही इज़ स्वेटिंग ऐंड आउट ऑफ़ ब्रेथ।",
            "उसका दिल चिड़िया-सा धड़क रहा है, वह हाँफता हुआ पसीने में तर है।"
          ],
          "cells_en": [
            "His heart is twittering, panting; he is sweating and out of breath.",
            "Hiz haart iz twi-ta-ring, pan-ting; hee iz swe-ting and aut ov breth.",
            "Conveys extreme physical exhaustion."
          ]
        },
        {
          "cells_hi": [
            "Reigning over the rich kingdom of sleep.",
            "रेनिंग ओवर द रिच किंगडम ऑफ़ स्लीप।",
            "नींद के समृद्ध साम्राज्य पर सम्राट की तरह राज करते हुए।"
          ],
          "cells_en": [
            "Reigning over the rich kingdom of sleep.",
            "Re-ning o-var the rich king-dam ov sleep.",
            "Iconic concluding triumph of peaceful rest."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Spine** (*स्पाइन*) = रीढ़ की हड्डी\n2. **Skeleton** (*स्केलेटन*) = कंकाल\n3. **Panting** (*पैंटिंग*) = तेज़ हाँफना\n4. **Shivering** (*शिवरिंग*) = ठंड से काँपना\n5. **Kingdom** (*किंगडम*) = साम्राज्य\n6. **Challenging** (*चैलेंजिंग*) = चुनौती देना",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Spine** (*स्पाइन*) = backbone\n2. **Skeleton** (*स्केलेटन*) = bony frame\n3. **Panting** (*पैंटिंग*) = breathing heavily\n4. **Shivering** (*शिवरिंग*) = trembling from cold\n5. **Kingdom** (*किंगडम*) = royal realm\n6. **Challenging** (*चैलेंजिंग*) = bravely facing",
    "exam_tip_hi": "स्पेलिंग याद रखें: **R-e-i-g-n-i-n-g** (शासन करना) बनाम **R-a-i-n-i-n-g** (बारिश होना) — कविता में **Reigning** है!",
    "exam_tip_en": "Watch spelling: **Reigning** (ruling as a king), NOT \"raining\"!",
    "glossary_terms": [
      {
        "term_hi": "Spine (स्पाइन)",
        "term_en": "Spine",
        "pronunciation_hi": "स्पाइन",
        "definition_hi": "पीठ की रीढ़ की हड्डी जो 25 किलो बोझ से दोहरी झुक गई है।",
        "definition_en": "The backbone bent double under the heavy 25-kilo load."
      },
      {
        "term_hi": "Shivering (शिवरिंग)",
        "term_en": "Shivering",
        "pronunciation_hi": "शिवरिंग",
        "definition_hi": "कड़ाके की ठंड और भूख से थर-थर काँपना।",
        "definition_en": "Trembling uncontrollably from winter cold and hunger."
      }
    ]
  },
  {
    "id": "sp-sec-4-summary",
    "order": 4,
    "heading_hi": "4. दिन की पीड़ा बनाम रात की शांति व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Day vs Night Contrast & 5-Mark Summary Formula",
    "analogy_hi": "इस कविता का जादू इसके विरोधाभास (Contrast) में है — दिन में वह सबसे थका हुआ गरीब कुली है, और रात को गहरी नींद में वह दुनिया का सबसे अमीर सम्राट!",
    "analogy_en": "The beauty of the poem lies in its contrast: by day he is an exhausted pauper; by night he becomes a wealthy king in peaceful sleep!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "कुली का दिन (संघर्ष) बनाम कुली की रात (विजय)",
      "title_en": "The Porter by Day (Hardship) vs By Night (Triumph)",
      "headers_hi": [
        "दिन का संघर्ष (Daytime Pain)",
        "रात की शांति (Nighttime Peace)"
      ],
      "headers_en": [
        "Daytime Struggle",
        "Nighttime Peace"
      ],
      "rows": [
        {
          "cells_hi": [
            "पीठ पर 25 किलो बोझ और 6 मील बर्फ़ीली चढ़ाई",
            "सारा बोझ उतर चुका है; शरीर गहरी नींद में शांत है"
          ],
          "cells_en": [
            "25-kilo load and 6-mile snow climb",
            "Free of all weight in deep, serene slumber"
          ]
        },
        {
          "cells_hi": [
            "कंकाल-सा शरीर, पसीना और हाँफती साँसें",
            "सितारों से सजे आकाश के नीचे असीम सुकून"
          ],
          "cells_en": [
            "Frail skeleton-like body, sweat, panting",
            "Peaceful rest beneath the starry night sky"
          ]
        },
        {
          "cells_hi": [
            "झोपड़ी में गरीबी और भूख की चिंता",
            "\"नींद के समृद्ध साम्राज्य\" का निश्चिंत सम्राट!"
          ],
          "cells_en": [
            "Poverty and hunger in his cliff hut",
            "Sovereign king of the \"rich kingdom of sleep\"!"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"The Sleeping Porter\"** is a moving poem written by Nepal's great poet **Laxmi Prasad Devkota**.\n2. It portrays a frail mountain porter carrying a **25-kilo load** up a **six-mile climb** in winter snow.\n3. Wearing a dirty black sweat-stained cap, he pants heavily as his heart beats like a bird.\n4. Inside his cliff hut, his **shivering son** cries in hunger while his mother searches for **nettles and vines**.\n5. Despite extreme poverty, he bravely **challenges the mountain** and at night peacefully **reigns over the rich kingdom of sleep**.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"The Sleeping Porter\"** is a moving poem written by Nepal's great poet **Laxmi Prasad Devkota**.\n2. It portrays a frail mountain porter carrying a **25-kilo load** up a **six-mile climb** in winter snow.\n3. Wearing a dirty black sweat-stained cap, he pants heavily as his heart beats like a bird.\n4. Inside his cliff hut, his **shivering son** cries in hunger while his mother searches for **nettles and vines**.\n5. Despite extreme poverty, he bravely **challenges the mountain** and at night peacefully **reigns over the rich kingdom of sleep**.",
    "exam_tip_hi": "5-अंक सारांश में ये 4 वाक्यांश ज़रूर लिखें: **Laxmi Prasad Devkota**, **25-kilo load**, **six-mile climb**, **rich kingdom of sleep**!",
    "exam_tip_en": "Include these 4 key phrases for full marks: **Laxmi Prasad Devkota**, **25-kilo load**, **six-mile climb**, **rich kingdom of sleep**!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "कुली के भूखे बेटे के लिए उसकी माँ क्या खोज रही है?",
      "q_en": "What is the porter's wife/mother searching for to feed the shivering son?",
      "answer_hi": "बिच्छू-बूटी और जंगली लताएँ (**nettles and vines**)।",
      "answer_en": "**Nettles and vines**."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Poet",
      "fact_hi": "लक्ष्मी प्रसाद देवकोटा (1909–1959) · नेपाल के महाकवि",
      "fact_en": "Laxmi Prasad Devkota (1909–1959) · Mahakavi of Nepal"
    },
    {
      "tag": "Numbers",
      "fact_hi": "बोझ: 25 किलो · चढ़ाई: 6 मील (सर्दी की बर्फ़ में)",
      "fact_en": "Load: 25 kilos · Climb: 6 miles (in winter snow)"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "The Sleeping Porter is a touching poem by Laxmi Prasad Devkota.",
      "fact_en": "The Sleeping Porter is a touching poem by Laxmi Prasad Devkota."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "A frail porter carries a 25-kilo load six miles uphill in winter snow.",
      "fact_en": "A frail porter carries a 25-kilo load six miles uphill in winter snow."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "Wearing a sweat-stained black cap, he pants with a bird-like beating heart.",
      "fact_en": "Wearing a sweat-stained black cap, he pants with a bird-like beating heart."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "His shivering son starves in a cliff hut while the mother hunts nettles and vines.",
      "fact_en": "His shivering son starves in a cliff hut while the mother hunts nettles and vines."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "A true hero challenging the mountain, he finally reigns over the rich kingdom of sleep.",
      "fact_en": "A true hero challenging the mountain, he finally reigns over the rich kingdom of sleep."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "कुली के बोझ को \"20 किलो\" या \"50 किलो\" लिख देना।",
      "mistake_en": "Writing 20 kg or 50 kg instead of 25 kilos.",
      "fix_hi": "सटीक संख्या याद रखें: **25-kilo load** और **6-mile climb**!",
      "fix_en": "Exact numbers: **25-kilo load** and **six-mile climb**!"
    },
    {
      "mistake_hi": "\"Reigning\" की स्पेलिंग \"Raining\" लिख देना।",
      "mistake_en": "Misspelling \"reigning\" as \"raining\".",
      "fix_hi": "राजा (King) → **Reigning** (R-E-I-G-N-I-N-G) over the rich kingdom of sleep!",
      "fix_en": "King -> **Reigning** (R-E-I-G-N-I-N-G) over the rich kingdom of sleep!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "कुली की शारीरिक दशा, 25 किलो बोझ व 6 मील चढ़ाई",
      "topic_en": "Porter's Physical State, 25-kg Load & 6-Mile Climb",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    },
    {
      "topic_hi": "\"नींद का समृद्ध साम्राज्य\" व कविता का सारांश",
      "topic_en": "\"Rich Kingdom of Sleep\" & Poem Summary",
      "years": [
        "2022",
        "2024"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-10-eng-ch5',
  2,
  'छात्र "The Sleeping Porter" कविता में श्रमजीवी वर्ग की पीड़ा और साहस को समझ सकेंगे, मुख्य संख्याएँ (25 kg, 6 miles) याद रख सकेंगे और 5-वाक्य सारांश लिख सकेंगे।',
  'Students will empathize with the mountain porter''s grit, recall key poem details (25-kilo load, 6-mile climb, black cap, nettles & vines), and write a 5-mark summary.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "संवेदनशील स्टोरी हुक, उच्चारण अभ्यास व ब्लैकबोर्ड चित्र-प्रवाह",
    "phase_en": "Empathy Hook, Pronunciation & Visual Flow on Board",
    "teacher_action_hi": "छात्रों से पूछें: \"क्या आपने स्टेशन पर भारी बोझ उठाते कुली को देखा है?\" फिर महाकवि देवकोटा की कविता सुनाएँ। Porter (पॉर्टर), Spine (स्पाइन), Skeleton (स्केलेटन), Shivering (शिवरिंग), Reigning (रेनिंग) का उच्चारण अभ्यास कराएँ।",
    "teacher_action_en": "Ask students about porters at railway stations. Narrate Devkota's mountain porter poem warmly. Drill Porter, Spine, Skeleton, Shivering, and Reigning.",
    "student_check_hi": "पूछें: \"कुली की पीठ पर कितना बोझ है और वह कितने मील चढ़ता है?\"",
    "student_check_en": "Ask: \"How heavy is the porter's load and how many miles does he climb?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "दिन बनाम रात तुलना, 5-मिनट मौखिक गतिविधि व सारांश लेखन",
    "phase_en": "Day vs Night Contrast, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "बोर्ड पर \"दिन की पीड़ा बनाम रात का साम्राज्य\" तालिका बनाएँ। 5-मिनट मौखिक आत्मविश्वास गतिविधि में 5 कमजोर छात्र 5-वाक्य सारांश बोलें। अंत में 5 मैट्रिक MCQ पूछें।",
    "teacher_action_en": "Draw the Daytime Hardship vs Nighttime Kingdom table. Run a 5-min oral chain of the 5-sentence summary for shy learners, then solve 5 Matric MCQs.",
    "student_check_hi": "पूरी कक्षा से एक साथ अंतिम पंक्ति बुलवाएँ: \"Reigning over the rich kingdom of sleep!\"",
    "student_check_en": "Have the class chant the closing phrase together: \"Reigning over the rich kingdom of sleep!\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड कविता बॉक्स (The Sleeping Porter)",
    "heading_en": "Blackboard Poem Box (The Sleeping Porter)",
    "points_hi": [
      "कवि: Laxmi Prasad Devkota (नेपाल के महाकवि, 1909–1959)",
      "संघर्ष: 25-kilo load · 6-mile climb (winter snow) · Spine double-bent",
      "हुलिया: Black dirty sweat-stained cap · Heart beats like a bird",
      "परिवार व अंत: Shivering son · Mother hunts nettles & vines · Reigns over rich kingdom of sleep"
    ],
    "points_en": [
      "Poet: Laxmi Prasad Devkota (Mahakavi of Nepal, 1909–1959)",
      "Struggle: 25-kilo load · 6-mile climb (winter snow) · Spine double-bent",
      "Appearance: Black dirty sweat-stained cap · Heart beats like a bird",
      "Home & Climax: Shivering son · Nettles & vines · Reigns over rich kingdom of sleep"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"तस्वीर से शब्द\" मौखिक अभ्यास",
    "title_en": "5-Minute \"Picture to English Word\" Oral Drill",
    "materials_hi": "ब्लैकबोर्ड पर पहाड़, बोझ (25 kg), टोपी व सितारों का सरल रेखाचित्र",
    "materials_en": "Simple chalk sketch of mountain, 25-kg pack, cap, and stars",
    "steps_hi": "शिक्षक चित्र के एक हिस्से पर उँगली रखें और कमज़ोर छात्र उसका अंग्रेज़ी शब्द व उच्चारण बोलें (\"mountain\", \"25-kilo load\", \"black cap\", \"kingdom of sleep\")।",
    "steps_en": "Teacher points to each chalk sketch element; shy learners call out the matching English phrase confidently."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Porter, Spine, Skeleton, Shivering और Reigning के अर्थ व स्पेलिंग 5 बार लिखें।",
    "task_en": "Write Porter, Spine, Skeleton, Shivering, and Reigning 5 times with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "कुली किसको चुनौती दे रहा है और क्यों? 2–3 सरल अंग्रेज़ी वाक्यों में लिखें।",
    "task_en": "Who is the porter challenging and why? Write 2–3 clear English sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "\"The Sleeping Porter\" का 5-अंक सारांश स्वच्छ अंग्रेज़ी में बिना देखे लिखें।",
    "task_en": "Write the 5-mark summary of \"The Sleeping Porter\" neatly from memory."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र सोचते हैं कि कुली को कोई सचमुच का राज्य या धन मिल गया है।",
    "misconception_en": "Students take \"rich kingdom of sleep\" literally as real wealth.",
    "correction_hi": "स्पष्ट करें कि यह एक सुंदर **रूपक (Metaphor)** है — थकान के बाद गहरी नींद इतनी सुखद है मानो वह किसी समृद्ध साम्राज्य का राजा बन गया हो!",
    "correction_en": "Explain it is a poetic **metaphor** — deep sleep frees him from all pain like a king in his kingdom!"
  },
  {
    "misconception_hi": "छात्र कवि को भारतीय अंग्रेज़ी कवि लिख देते हैं।",
    "misconception_en": "Students call Laxmi Prasad Devkota an English or Indian poet.",
    "correction_hi": "बताएँ कि वे **नेपाल के महाकवि (Nepali poet)** हैं जिनकी कविता का अंग्रेज़ी अनुवाद पाठ्यक्रम में है।",
    "correction_en": "Clarify that he is the celebrated **Nepali Mahakavi** translated into English."
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
  (
    '10000007-0005-4000-8000-000000000001', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Poet & Key Facts', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2023',
    'The Sleeping Porter के कवि, बोझ और दूरी क्या हैं?',
    'Name the poet, load weight, and climb distance in "The Sleeping Porter".',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"The Sleeping Porter\" के कवि, कुली के बोझ और पहाड़ी चढ़ाई की दूरी बताएँ।",
  "front_en": "Name the poet, load weight, and climbing distance in \"The Sleeping Porter\".",
  "back_hi": "कवि: Laxmi Prasad Devkota (नेपाल के महाकवि) · बोझ: 25 किलो · दूरी: 6 मील (सर्दी की बर्फ़ में)।",
  "back_en": "Poet: Laxmi Prasad Devkota (Mahakavi of Nepal) · Load: 25 kilos · Distance: 6 miles in winter snow.",
  "pronunciation_hi": "द स्लीपिंग पॉर्टर — लक्ष्मी प्रसाद देवकोटा",
  "mnemonic_hi": "ट्रिक: 25 किलो + 6 मील + देवकोटा = सोया हुआ कुली!",
  "mnemonic_en": "Hook: 25 kilos + 6 miles + Devkota = Sleeping Porter!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000002', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Reigning और Shivering का सही उच्चारण व अर्थ क्या है?',
    'What are the pronunciation and meaning of Reigning and Shivering?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Reigning और Shivering शब्दों का उच्चारण व हिंदी अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Reigning\" and \"Shivering\".",
  "back_hi": "Reigning (रेनिंग) = राजा की तरह शासन करना · Shivering (शिवरिंग) = ठंड व भूख से काँपना।",
  "back_en": "Reigning = ruling like a king · Shivering = trembling from cold.",
  "pronunciation_hi": "रेनिंग · शिवरिंग",
  "mnemonic_hi": "Reigning में \"g\" मौन (silent) है → उच्चारण \"रेनिंग\"!",
  "mnemonic_en": "Silent \"g\" in Reigning — means ruling over a kingdom!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000003', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Poem Details Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2024',
    'कविता के तथ्यों को उनके सही जोड़े से मिलाएँ:',
    'Match each detail from "The Sleeping Porter" in Column A with Column B:',
    NULL, NULL,
    '25 किलो, 6 मील, काली टोपी और बिच्छू-बूटी को सही जगह मिलाएँ।', 'Match 25 kilos, 6 miles, black cap, and nettles & vines.',
    '25 किलो पीठ पर बोझ, 6 मील बर्फ़ में चढ़ाई, काली मैली टोपी और माँ भोजन के लिए nettles & vines खोजती है।', '25-kilo load on back, 6-mile climb in snow, black sweat-stained cap, and mother searches for nettles and vines.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each fact from the poem",
  "pairs": [
    {
      "id": "sp-m1",
      "left_hi": "25-kilo load",
      "left_en": "25-kilo load",
      "right_hi": "कुली की दोहरी झुकी पीठ पर रखा भारी बोझ",
      "right_en": "Heavy weight on the porter's double-bent back"
    },
    {
      "id": "sp-m2",
      "left_hi": "Six-mile climb",
      "left_en": "Six-mile climb",
      "right_hi": "सर्दी की बर्फ़ में पहाड़ की कठिन चढ़ाई",
      "right_en": "Uphill journey in the snows of winter"
    },
    {
      "id": "sp-m3",
      "left_hi": "Black dirty cap",
      "left_en": "Black dirty cap",
      "right_hi": "कुली के सिर पर पसीने से सनी टोपी",
      "right_en": "Sweat-stained cap worn by the porter"
    },
    {
      "id": "sp-m4",
      "left_hi": "Nettles and vines",
      "left_en": "Nettles and vines",
      "right_hi": "भूखे परिवार के लिए माँ द्वारा खोजी जाने वाली जंगली पत्तियाँ",
      "right_en": "Wild plants searched by the mother for food"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000004', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही वाक्य सजाएँ: "कुली पहाड़ को चुनौती दे रहा है।"',
    'Build the exam sentence: "The porter is challenging the mountain"',
    NULL, NULL,
    'Present Continuous: The porter + is + challenging + the mountain।', 'Present Continuous: Subject + is + V-ing + Object.',
    'सही वाक्य: "The porter is challenging the mountain"।', 'Correct sentence: "The porter is challenging the mountain".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "कुली पहाड़ को चुनौती दे रहा है।",
  "prompt_en": "Build this key sentence from The Sleeping Porter",
  "grammar_formula": "Subject + is + V-ing + Object",
  "tokens": [
    "The",
    "porter",
    "is",
    "challenging",
    "the",
    "mountain"
  ],
  "distractors": [
    "are",
    "challenge"
  ],
  "correct_sentence": "The porter is challenging the mountain",
  "pronunciation_hi": "द पॉर्टर इज़ चैलेंजिंग द माउंटेन"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000005', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "वह नींद के समृद्ध साम्राज्य पर राज करता है।"',
    'Build the famous closing thought: "He reigns over the rich kingdom of sleep"',
    NULL, NULL,
    'Singular Subject "He" के साथ "reigns" और preposition "over" आएगा।', 'Use singular verb "reigns" + preposition "over".',
    'सही वाक्य: "He reigns over the rich kingdom of sleep"।', 'Correct sentence: "He reigns over the rich kingdom of sleep".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "वह नींद के समृद्ध साम्राज्य पर राज करता है।",
  "prompt_en": "Build the iconic closing idea of the poem",
  "grammar_formula": "He + V1(s) + over + the + Adjective + Noun + of + Noun",
  "tokens": [
    "He",
    "reigns",
    "over",
    "the",
    "rich",
    "kingdom",
    "of",
    "sleep"
  ],
  "distractors": [
    "reign",
    "in"
  ],
  "correct_sentence": "He reigns over the rich kingdom of sleep",
  "pronunciation_hi": "ही रेन्स ओवर द रिच किंगडम ऑफ़ स्लीप"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000006', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Load Weight MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    'कुली की पीठ पर कितने किलोग्राम का बोझ रखा है?',
    'How much load does the sleeping porter carry on his back?',
    $json$[{"key":"A","text_hi":"25 किलोग्राम","text_en":"25 kilos"},{"key":"B","text_hi":"40 किलोग्राम","text_en":"40 kilos"},{"key":"C","text_hi":"50 किलोग्राम","text_en":"50 kilos"},{"key":"D","text_hi":"15 किलोग्राम","text_en":"15 kilos"}]$json$::jsonb, 'A',
    'कविता की पहली ही पंक्ति याद करें: "A twenty-five kilo load..."', 'Recall the opening line: "A twenty-five kilo load..."',
    'कुली की पीठ पर 25 किलोग्राम (twenty-five kilo) का भारी बोझ है।', 'The porter carries a twenty-five kilo load on his back.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000007', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Poet MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    '"The Sleeping Porter" कविता के कवि कौन हैं?',
    'Who is the poet of "The Sleeping Porter"?',
    $json$[{"key":"A","text_hi":"विद्यापति","text_en":"Vidyapati"},{"key":"B","text_hi":"विलियम कूपर","text_en":"William Cowper"},{"key":"C","text_hi":"लक्ष्मी प्रसाद देवकोटा","text_en":"Laxmi Prasad Devkota"},{"key":"D","text_hi":"पूरन सिंह","text_en":"Puran Singh"}]$json$::jsonb, 'C',
    'नेपाल के प्रसिद्ध महाकवि।', 'The celebrated Mahakavi of Nepal.',
    '"The Sleeping Porter" नेपाल के महाकवि लक्ष्मी प्रसाद देवकोटा की रचना है।', 'Laxmi Prasad Devkota composed "The Sleeping Porter".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000008', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Distance Climb MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'सर्दी की बर्फ़ में कुली कितने मील की पहाड़ी चढ़ाई चढ़ता है?',
    'What distance does the porter climb up in the snows of winter?',
    $json$[{"key":"A","text_hi":"चार मील","text_en":"Four miles"},{"key":"B","text_hi":"छह मील","text_en":"Six miles"},{"key":"C","text_hi":"दस मील","text_en":"Ten miles"},{"key":"D","text_hi":"दो मील","text_en":"Two miles"}]$json$::jsonb, 'B',
    'पंक्ति: "A six-mile climb up in the snows of winter."', 'Recall: "A six-mile climb up in the snows of winter."',
    'कुली सर्दी की बर्फ़ में छह मील (six miles) की कठिन चढ़ाई चढ़ता है।', 'He makes a gruelling six-mile climb in winter snow.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000009', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Challenging Mountain MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2023',
    'कवि के अनुसार वह कमज़ोर दिखने वाला कुली किसे चुनौती दे रहा है?',
    'According to the poet, who is the porter challenging?',
    $json$[{"key":"A","text_hi":"राजा को (The king)","text_en":"The king"},{"key":"B","text_hi":"बादलों को (The clouds)","text_en":"The clouds"},{"key":"C","text_hi":"समुद्र को (The sea)","text_en":"The sea"},{"key":"D","text_hi":"पहाड़ को (The mountain)","text_en":"The mountain"}]$json$::jsonb, 'D',
    'उसे "पहाड़ का नायक (hero of the mountain)" कहा गया है।', 'He is celebrated as a hero of the mountain.',
    'कविता में कुली अपने अदम्य साहस से विशाल पहाड़ (the mountain) को चुनौती दे रहा है।', 'The porter is bravely challenging the mighty mountain.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000010', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Kingdom of Sleep', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'कविता की अंतिम पंक्तियों में कुली किस समृद्ध साम्राज्य पर राज कर रहा है?',
    'In the closing lines, what rich kingdom is the porter reigning over?',
    $json$[{"key":"A","text_hi":"नींद के समृद्ध साम्राज्य पर (Rich kingdom of sleep)","text_en":"The rich kingdom of sleep"},{"key":"B","text_hi":"हिमालय के साम्राज्य पर","text_en":"The kingdom of snow"},{"key":"C","text_hi":"सपनों के बाज़ार पर","text_en":"The market of dreams"},{"key":"D","text_hi":"सोने के साम्राज्य पर","text_en":"The kingdom of gold"}]$json$::jsonb, 'A',
    'दिन भर की थकान के बाद रात की गहरी नींद का रूपक याद करें।', 'Recall the peaceful concluding metaphor of deep rest.',
    'कविता के अंत में गहरी नींद में सोया कुली "नींद के समृद्ध साम्राज्य (rich kingdom of sleep)" का सम्राट बन जाता है।', 'At the poem''s close, the porter peacefully reigns over the rich kingdom of sleep.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000011', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Exam Pool: Porter''s Cap', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2023',
    'कुली ने अपने सिर पर कैसी टोपी पहन रखी है?',
    'What kind of cap is the porter wearing in the poem?',
    $json$[{"key":"A","text_hi":"नई लाल ऊनी टोपी","text_en":"A new red woollen cap"},{"key":"B","text_hi":"काली, मैली और पसीने से सनी टोपी","text_en":"A black, dirty, sweat-stained cap"},{"key":"C","text_hi":"सफ़ेद रेशमी पगड़ी","text_en":"A white silk turban"},{"key":"D","text_hi":"हरी मखमली टोपी","text_en":"A green velvet cap"}]$json$::jsonb, 'B',
    'उसकी गरीबी और कठोर श्रम का प्रतीक।', 'It reflects his poverty and hard labour.',
    'कुली ने काली, मैली और पसीने से भीगी टोपी (black, dirty, sweat-stained cap) पहन रखी है।', 'The porter wears a black, dirty, sweat-stained cap.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000012', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Exam Pool: Mother''s Search', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'कुली की झोपड़ी में माँ भोजन के लिए क्या खोज रही है?',
    'In the porter''s cliff hut, what is the mother searching for?',
    $json$[{"key":"A","text_hi":"दूध और मक्खन","text_en":"Milk and butter"},{"key":"B","text_hi":"चावल और गेहूँ","text_en":"Rice and wheat"},{"key":"C","text_hi":"बिच्छू-बूटी और जंगली लताएँ (Nettles and vines)","text_en":"Nettles and vines"},{"key":"D","text_hi":"सेब और संतरे","text_en":"Apples and oranges"}]$json$::jsonb, 'C',
    'पहाड़ों पर मिलने वाले जंगली पौधे व बेलें।', 'Wild plants gathered by extremely poor mountain families.',
    'माँ भूखे बेटे के लिए बिच्छू-बूटी और जंगली लताएँ (nettles and vines) खोज रही है।', 'The mother is searching for nettles and vines to feed her starving family.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000013', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Porter Appearance 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'कविता में पहाड़ी कुली की शारीरिक दशा और कठिनाई का वर्णन करें।',
    'Describe the physical condition and hardship of the porter in the poem.',
    NULL, NULL,
    '25 किलो बोझ, झुकी रीढ़, 6 मील बर्फ़ीली चढ़ाई और काली मैली टोपी लिखें।', 'Mention 25-kilo load, double-bent spine, 6-mile snow climb, and sweat-stained black cap.',
    NULL, NULL,
    'कुली का शरीर कंकाल जैसा अत्यंत दुबला-पतला है। उसकी पीठ पर **25 किलोग्राम का भारी बोझ** लदा है जिससे उसकी रीढ़ दोहरी झुक गई है। वह सिर पर काली, मैली व पसीने से सनी टोपी पहने सर्दी की बर्फ़ में **6 मील की पहाड़ी चढ़ाई** चढ़ता है, और उसका दिल चिड़िया की तरह धड़कता है।', 'The porter has a frail, skeleton-like frame with his spine double-bent under a **25-kilo load**. Wearing a black, dirty, sweat-stained cap, he climbs **six miles uphill in winter snow**, panting heavily while his heart beats rapidly like a bird.',
    $json$[{"cue_hi":"25-kilo load · spine double-bent","cue_en":"25-kilo load · spine double-bent"},{"cue_hi":"6-mile climb in winter snow · dirty black cap","cue_en":"6-mile climb in winter snow · dirty black cap"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"25 किलो बोझ, झुकी रीढ़ व कंकाल-से शरीर का उल्लेख","criterion_en":"Mentions 25-kilo load, bent spine, and frail body"},{"step_no":2,"marks":1,"criterion_hi":"6 मील की बर्फीली चढ़ाई व काली मैली टोपी/हाँफने का वर्णन","criterion_en":"Describes 6-mile winter climb, black cap, and panting"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0005-4000-8000-000000000014', 'bseb-10-eng', 'bseb-10-eng-ch5', 'Poem Summary 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"The Sleeping Porter" कविता का सारांश लिखें और इसके मानवीय संदेश पर प्रकाश डालें।',
    'Write the summary of "The Sleeping Porter" and bring out its humane message.',
    NULL, NULL,
    'देवकोटा, 25 किलो बोझ, 6 मील चढ़ाई, झोपड़ी में भूखा बेटा व माँ, पहाड़ को चुनौती और नींद का साम्राज्य लिखें।', 'Cover Devkota, 25-kg load, 6-mile climb, cliff hut family, challenging mountain, and rich kingdom of sleep.',
    NULL, NULL,
    '**"The Sleeping Porter"** नेपाल के महाकवि **लक्ष्मी प्रसाद देवकोटा** की अत्यंत संवेदनशील कविता है, जो गरीब श्रमजीवी कुली के कठिन संघर्ष और अद्भुत धैर्य को सलाम करती है।

कविता का नायक एक दुबला-पतला पहाड़ी कुली है जो पीठ पर **25 किलो का बोझ** लादे, दोहरी झुकी रीढ़ के साथ सर्दी की बर्फ़ में **6 मील की पहाड़ी चढ़ाई** चढ़ता है। सिर पर काली, मैली व पसीने से सनी टोपी पहने वह हाँफता है और उसका दिल चिड़िया की तरह धड़कता है। उधर चट्टान पर बनी उसकी झोपड़ी में उसका छोटा बेटा ठंड और भूख से काँप रहा है, और माँ भोजन के लिए **बिच्छू-बूटी व लताएँ (nettles and vines)** खोज रही है।

फिर भी वह पहाड़ को चुनौती देने वाला सच्चा नायक है। रात होने पर थकान से चूर यह कुली सितारों के नीचे गहरी नींद में सोकर **"नींद के समृद्ध साम्राज्य (rich kingdom of sleep)"** पर सम्राट की तरह राज करता है। कविता हमें मेहनतकश गरीबों के प्रति सम्मान व करुणा रखने का संदेश देती है।', '**"The Sleeping Porter"** is a deeply empathetic poem by Nepal''s *Mahakavi*, **Laxmi Prasad Devkota**, portraying the grit and poverty of a mountain porter.

Carrying a **25-kilo load** on his double-bent spine, the frail, skeleton-like porter trudges up a **six-mile climb** through winter snow. Wearing a black, dirty, sweat-stained cap, he pants for breath with his heart beating like a bird. Up in his cliff hut, his **shivering son** cries with hunger while the mother searches desperately for **nettles and vines**.

Yet the poet honours him as a brave hero **challenging the mountain**. In the moving conclusion, once night falls beneath the starry sky, the exhausted porter forgets all poverty and pain, peacefully **reigning over the rich kingdom of sleep**. The poem inspires respect and compassion for hard-working labourers.',
    $json$[{"cue_hi":"Laxmi Prasad Devkota · Mahakavi of Nepal","cue_en":"Laxmi Prasad Devkota · Mahakavi of Nepal"},{"cue_hi":"25-kilo load · 6-mile winter snow climb","cue_en":"25-kilo load · 6-mile winter snow climb"},{"cue_hi":"Shivering son · Mother hunts nettles & vines","cue_en":"Shivering son · Mother hunts nettles & vines"},{"cue_hi":"Hero challenging mountain -> rich kingdom of sleep","cue_en":"Hero challenging mountain -> rich kingdom of sleep"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"कवि (Laxmi Prasad Devkota) व कविता का विषय","criterion_en":"Names Laxmi Prasad Devkota and theme of labour/poverty"},{"step_no":2,"marks":1.5,"criterion_hi":"25 किलो बोझ, 6 मील चढ़ाई व शारीरिक दशा का सटीक चित्रण","criterion_en":"Describes 25-kilo load, 6-mile snow climb, and black cap"},{"step_no":3,"marks":1.5,"criterion_hi":"झोपड़ी में काँपता बेटा, माँ (nettles & vines) व पहाड़ को चुनौती","criterion_en":"Mentions cliff hut family and challenging the mountain"},{"step_no":4,"marks":1,"criterion_hi":"\"Rich kingdom of sleep\" का समापन व मानवीय संदेश","criterion_en":"Concludes with rich kingdom of sleep and compassion message"}]$json$::jsonb,
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
-- CHAPTER 6 OF 14: BSEB-12-ENG-CH1 — Indian Civilization and Culture — Mahatma Gandhi
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-12-eng-ch1',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: भारतीय सभ्यता और संस्कृति",
  "title_en": "30-Second Mindmap: Indian Civilization and Culture",
  "read_time_seconds": 30,
  "central_node": {
    "id": "icc-root",
    "label_hi": "Indian Civilization and Culture",
    "label_en": "Indian Civilization and Culture (Essay)",
    "subtitle_hi": "Mahatma Gandhi (1869–1948) · Rainbow Part-2 (Ch 1)",
    "subtitle_en": "Mahatma Gandhi (1869–1948) · Rainbow Part-2 (Ch 1)"
  },
  "branches": [
    {
      "id": "icc-author",
      "label_hi": "1. लेखक: महात्मा गांधी",
      "label_en": "1. Author: Mahatma Gandhi",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "icc-a1",
          "label_hi": "मोहनदास करमचंद गांधी (1869–1948) — राष्ट्रपिता (Bapu)",
          "label_en": "Mohandas Karamchand Gandhi (1869–1948) — Father of the Nation"
        },
        {
          "id": "icc-a2",
          "label_hi": "आत्मकथा: My Experiments with Truth · पत्रिका: Young India",
          "label_en": "Autobiography: My Experiments with Truth · Journal: Young India"
        }
      ]
    },
    {
      "id": "icc-core",
      "label_hi": "2. सभ्यता का सच्चा अर्थ",
      "label_en": "2. True Meaning of Civilization",
      "color": "#059669",
      "children": [
        {
          "id": "icc-c1",
          "label_hi": "गुजराती में सभ्यता = \"सदाचार (Good conduct)\"",
          "label_en": "Gujarati equivalent for civilization = \"Good conduct\""
        },
        {
          "id": "icc-c2",
          "label_hi": "मन एक \"बेचैन पक्षी (restless bird)\" है — जितना पाता है, उतना अधिक चाहता है!",
          "label_en": "\"Mind is a restless bird\" — the more it gets, the more it wants!"
        }
      ]
    },
    {
      "id": "icc-contrast",
      "label_hi": "3. भारतीय बनाम पश्चिमी सभ्यता",
      "label_en": "3. Indian vs Western Civilization",
      "color": "#D97706",
      "children": [
        {
          "id": "icc-w1",
          "label_hi": "रोम, ग्रीस (Attic Greece), मिस्र के फ़राओ (Pharaohs) मिट गए — भारत अटल है!",
          "label_en": "Rome (Gibbon), Attic Greece, Pharaohs fell — India stands immovable!"
        },
        {
          "id": "icc-w2",
          "label_hi": "भारत: नैतिकता, संयम, छोटे गाँव · पश्चिम: भौतिकवाद, मशीनें, असीम इच्छाएँ",
          "label_en": "India: Morality, self-restraint, villages · West: Materialism & machines"
        }
      ]
    },
    {
      "id": "icc-exam",
      "label_hi": "4. आदर्श वाक्य व इंटर परीक्षा फोकस",
      "label_en": "4. Motto & Inter Exam Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "icc-e1",
          "label_hi": "आदर्श: \"सादा जीवन, उच्च विचार (Plain living and high thinking)\"",
          "label_en": "Ideal: \"Plain living and high thinking\""
        },
        {
          "id": "icc-e2",
          "label_hi": "पक्के MCQ: Good conduct, Restless bird, Pharaohs, Gibbon, Small villages।",
          "label_en": "Top MCQs: Good conduct, Restless bird, Pharaohs, Gibbon, Small villages."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "icc-sec-1-author",
    "order": 1,
    "heading_hi": "1. लेखक परिचय और बिहार के चम्पारण से जुड़ाव",
    "heading_en": "1. Author Profile & Bihar Champaran Connection",
    "analogy_hi": "बिहार के विद्यार्थियों के लिए महात्मा गांधी केवल किताब का नाम नहीं — 1917 के **चम्पारण सत्याग्रह** ने ही गांधीजी को भारत का राष्ट्रनेता बनाया! सोचिए आज जब मोबाइल और लालच की दौड़ में सब बेचैन हैं, तब गांधीजी का 100 साल पुराना वाक्य कितना सच लगता है — **\"मन एक बेचैन पक्षी (restless bird) है, इसे जितना मिलता है यह उतना ही और चाहता है!\"**",
    "analogy_en": "Bihar students know Gandhi deeply from the **1917 Champaran Satyagraha**! In today's age of endless shopping and distraction, Gandhi's century-old warning rings truer than ever: **\"Mind is a restless bird; the more it gets the more it wants, and still remains unsatisfied!\"**",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "महात्मा गांधी — जीवन व लेखन के मुख्य पड़ाव",
      "title_en": "Mahatma Gandhi — Key Life & Writing Milestones",
      "events": [
        {
          "year": "1869",
          "title_hi": "जन्म — पोरबंदर (गुजरात)",
          "title_en": "Born — Porbandar (Gujarat)",
          "detail_hi": "2 अक्टूबर 1869 को जन्म; सत्य व अहिंसा को जीवन का आधार बनाया।",
          "detail_en": "Born 2 October 1869; champion of Truth and Non-violence."
        },
        {
          "year": "1917",
          "title_hi": "चम्पारण सत्याग्रह (बिहार)",
          "title_en": "Champaran Satyagraha (Bihar)",
          "detail_hi": "बिहार के नील किसानों के लिए भारत का पहला सफल सत्याग्रह।",
          "detail_en": "India's first successful Satyagraha for indigo farmers in Bihar.",
          "highlight": true
        },
        {
          "year": "1920s",
          "title_hi": "\"Young India\" व \"My Experiments with Truth\"",
          "title_en": "\"Young India\" & \"My Experiments with Truth\"",
          "detail_hi": "सरल, स्पष्ट अंग्रेज़ी में भारतीय संस्कृति और स्वराज के विचार लिखे।",
          "detail_en": "Articulated Indian civilization and Swaraj in crisp, forceful English.",
          "highlight": true
        },
        {
          "year": "1948",
          "title_hi": "बलिदान (30 जनवरी 1948)",
          "title_en": "Martyrdom (30 January 1948)",
          "detail_hi": "एक धर्मांध के हाथों निधन; विचार आज भी पूरे विश्व को राह दिखाते हैं।",
          "detail_en": "Died at the hands of a fanatic; his ideals still guide the world."
        }
      ]
    },
    "concept_md_hi": "### निबंध का मूल आधार\n- गांधीजी गर्व के साथ कहते हैं कि दुनिया की कोई भी सभ्यता भारत द्वारा बोए गए नैतिक बीजों की बराबरी नहीं कर सकती।\n- **इतिहास का प्रमाण:** **रोम** का साम्राज्य गिर गया (जिसका इतिहास **एडवर्ड गिबन / Gibbon** ने लिखा), **ग्रीस (Attic Greece)** का वैभव मिट गया, मिस्र के शक्तिशाली **फ़राओ (Pharaohs)** की सत्ता समाप्त हो गई, जापान पश्चिमी रंग में रंग गया — पर **भारत आज भी अपनी प्राचीन नैतिक नींव पर अटल (immovable)** खड़ा है! यही भारत का सच्चा गौरव है।\n- **गुजराती परिभाषा:** गुजराती भाषा में सभ्यता का अर्थ **\"सदाचार (good conduct)\"** होता है — वह आचरण जो मनुष्य को कर्तव्य का मार्ग दिखाए।",
    "concept_md_en": "### Foundation of the Essay\n- Gandhi proudly asserts that no civilization in the world can beat the moral seeds sown by India's ancestors.\n- **Proof from History:** **Rome** fell (chronicled by **Edward Gibbon**), **Attic Greece** lost its glory, the might of Egypt's **Pharaohs** was broken, and Japan became Westernized — yet **India remains immovable** on her ancient foundation. That is her true glory.\n- **Gujarati Definition:** The Gujarati equivalent for civilization means **\"good conduct\"** — the mode of conduct that points out to man the **path of duty**.",
    "exam_tip_hi": "इंटर बोर्ड के 4 पक्के MCQ: Pharaohs = **Egypt** · Gibbon = **Italy / Rome** · Attic civilization = **Greece** · Gujarati civilization = **Good conduct**!",
    "exam_tip_en": "4 Guaranteed Inter MCQs: Pharaohs = **Egypt**, Gibbon = **Italy/Rome**, Attic = **Greece**, Gujarati civilization = **Good conduct**!",
    "glossary_terms": [
      {
        "term_hi": "Civilization (सिविलाइज़ेशन)",
        "term_en": "Civilization",
        "pronunciation_hi": "सिविलाइज़ेशन",
        "definition_hi": "सभ्यता — आचरण का वह तरीका जो मनुष्य को कर्तव्य और सदाचार का मार्ग दिखाए।",
        "definition_en": "The mode of conduct that points out to man the path of duty."
      },
      {
        "term_hi": "Pharaohs (फ़ैरोज़ / फ़राओ)",
        "term_en": "Pharaohs",
        "pronunciation_hi": "फ़ैरोज़",
        "definition_hi": "प्राचीन मिस्र (Egypt) के शक्तिशाली सम्राट।",
        "definition_en": "Ancient rulers of Egypt."
      }
    ]
  },
  {
    "id": "icc-sec-2-contrast",
    "order": 2,
    "heading_hi": "2. विज़ुअल तुलना: भारतीय सभ्यता बनाम पश्चिमी सभ्यता",
    "heading_en": "2. Visual Contrast: Indian vs Western Civilization",
    "analogy_hi": "गांधीजी पश्चिम के दुश्मन नहीं थे — वे तो सिर्फ़ एक सीधा फ़र्क दिखाते हैं: पश्चिमी सभ्यता कहती है *\"इच्छाएँ बढ़ाते जाओ, मशीनों के गुलाम बन जाओ\"*; भारतीय सभ्यता कहती है *\"इच्छाओं पर संयम रखो, हाथ-पैर से मेहनत करो और शांत जीवन जियो!\"*",
    "analogy_en": "Gandhi was no hater of the West — he simply contrasted two philosophies: Western materialism multiplies endless wants, whereas Indian civilization elevates morality through self-restraint!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "भारतीय सभ्यता (नैतिकता) बनाम पश्चिमी सभ्यता (भौतिकवाद)",
      "title_en": "Indian Civilization (Morality) vs Western Civilization (Materialism)",
      "caption_hi": "भारतीय सभ्यता नैतिक उत्थान, संतोष और छोटे गाँवों को महत्व देती है; पश्चिमी सभ्यता भौतिक सुख और असीमित इच्छाओं की ओर ले जाती है।",
      "caption_en": "Indian civilization elevates moral being and contentment; modern Western civilization worships materialism and endless wants.",
      "viewBox": "0 0 640 240",
      "elements": [
        {
          "kind": "rect",
          "x": 18,
          "y": 20,
          "width": 286,
          "height": 200,
          "rx": 12,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 161,
          "y": 48,
          "text_hi": "भारतीय सभ्यता (Indian)",
          "text_en": "Indian Civilization",
          "fill": "#065F46",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 161,
          "y": 84,
          "text_hi": "आधार: नैतिकता व ईश्वर में विश्वास",
          "text_en": "Base: Elevates Moral Being",
          "fill": "#047857",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 161,
          "y": 118,
          "text_hi": "इच्छाओं पर संयम (Self-Restraint)",
          "text_en": "Voluntary Restriction of Wants",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 161,
          "y": 152,
          "text_hi": "छोटे गाँव व श्रम का सम्मान",
          "text_en": "Small Villages & Honest Labour",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 161,
          "y": 188,
          "text_hi": "सादा जीवन, उच्च विचार",
          "text_en": "Plain Living & High Thinking",
          "fill": "#065F46",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 336,
          "y": 20,
          "width": 286,
          "height": 200,
          "rx": 12,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 479,
          "y": 48,
          "text_hi": "आधुनिक पश्चिमी सभ्यता (Western)",
          "text_en": "Modern Western Civilization",
          "fill": "#92400E",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 479,
          "y": 84,
          "text_hi": "आधार: भौतिकवाद की पूजा",
          "text_en": "Base: Worship of Materialism",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 479,
          "y": 118,
          "text_hi": "इच्छाओं का असीम विस्तार",
          "text_en": "Indefinite Multiplication of Wants",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 479,
          "y": 152,
          "text_hi": "बड़े शहर व मशीनों की गुलामी",
          "text_en": "Crowded Cities & Machine Slavery",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 479,
          "y": 188,
          "text_hi": "परिणाम: मन की बेचैनी",
          "text_en": "Result: Restless Dissatisfaction",
          "fill": "#DC2626",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### हमारे पूर्वजों की 4 दूरदर्शी शिक्षाएँ\n1. **मन बेचैन पक्षी है:** हमारे पूर्वजों ने देखा कि सुख एक मानसिक स्थिति है; अमीर हमेशा सुखी नहीं और गरीब हमेशा दुखी नहीं।\n2. **मशीनों से सावधानी:** हमारे पूर्वज मशीनों का आविष्कार जानते थे, पर उन्होंने भारी मशीनों से दूर रहना चुना ताकि हम **मशीनों के गुलाम (slaves)** न बनें और अपने हाथ-पैर से स्वस्थ श्रम करते रहें।\n3. **छोटे गाँवों से संतोष:** पूर्वजों ने देखा कि बड़े शहर चोरों, ठगों और शोषण के अड्डे बन जाते हैं — इसलिए वे **छोटे गाँवों (small villages)** और सच्चे **स्वराज (Home Rule)** से संतुष्ट रहे।\n4. **वैद्य-वकील मर्यादा में:** प्राचीन भारत में राजा भी ऋषियों की नैतिक तलवार के नीचे थे; वकील और वैद्य जनता को लूटने के बजाय सेवक की तरह रहते थे।",
    "concept_md_en": "### 4 Wise Lessons from Our Ancestors\n1. **Mind is a Restless Bird:** Our ancestors realized happiness is largely a mental condition — wealth does not guarantee joy.\n2. **Avoided Machine Slavery:** They knew how to invent machinery, yet chose hand-and-foot labour so we would not become **slaves to machines**.\n3. **Content with Small Villages:** Seeing big cities as snares of vice and exploitation, our ancestors preferred **small villages** and enjoyed **True Home Rule**.\n4. **Morality Above Power:** Kings bowed to the moral authority of Rishis and Fakirs, and ordinary people followed independent agriculture.",
    "exam_tip_hi": "हर साल आने वाला MCQ: हमारे पूर्वजों ने मशीनों से हमें क्यों बचाया? → क्योंकि वे जानते थे कि मशीनों के पीछे भागने से हम **गुलाम (slaves)** बन जाएँगे और अपना नैतिक चरित्र खो देंगे!",
    "exam_tip_en": "Repeated Inter MCQ: Why did our ancestors dissuade us from machinery? → They knew we would become **slaves** and lose our moral fibre!",
    "glossary_terms": [
      {
        "term_hi": "Materialism (मटीरियलिज़्म)",
        "term_en": "Materialism",
        "pronunciation_hi": "मटीरियलिज़्म",
        "definition_hi": "भौतिक सुख-सुविधाओं और धन-संपत्ति को ही सब कुछ मानना।",
        "definition_en": "Excessive worship of physical comforts and wealth over moral values."
      },
      {
        "term_hi": "Immovable (इम्मूवेबल)",
        "term_en": "Immovable",
        "pronunciation_hi": "इम्मूवेबल",
        "definition_hi": "अटल, अडिग — जो हज़ारों वर्षों बाद भी अपनी नींव पर स्थिर है।",
        "definition_en": "Firm, steady, unshaken across millennia."
      }
    ],
    "quick_check": {
      "q_hi": "महात्मा गांधी ने मानव मन की तुलना किससे की है?",
      "q_en": "What has Mahatma Gandhi compared the human mind to?",
      "answer_hi": "एक **बेचैन पक्षी (a restless bird)** से — जिसे जितना मिलता है वह उतना और चाहता है।",
      "answer_en": "**A restless bird** — the more it gets, the more it wants."
    }
  },
  {
    "id": "icc-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "इंटर बोर्ड के \"Explain with reference to context\" (4 अंक) में गांधीजी की ये 4 पंक्तियाँ हर साल आती हैं — इन्हें अभी पक्का कर लें!",
    "analogy_en": "BSEB Class 12 \"Explain with reference to context\" (4-mark) questions love these exact 4 lines!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "Indian Civilization and Culture — 4 अमर पंक्तियाँ",
      "title_en": "4 Iconic Lines from Indian Civilization and Culture",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "Mind is a restless bird, the more it gets the more it wants.",
            "माइंड इज़ अ रेस्टलेस बर्ड, द मोर इट गेट्स द मोर इट वॉन्ट्स।",
            "मन एक बेचैन पक्षी है — इसे जितना मिलता है यह उतना ही और चाहता है।"
          ],
          "cells_en": [
            "Mind is a restless bird, the more it gets the more it wants.",
            "Maaind iz a rest-les bard, the mor it gets the mor it wonts.",
            "Human cravings never end without self-control."
          ]
        },
        {
          "cells_hi": [
            "Civilization is that mode of conduct which points out to man the path of duty.",
            "सिविलाइज़ेशन इज़ दैट मोड ऑफ़ कंडक्ट व्हिच पॉइंट्स आउट टु मैन द पाथ ऑफ़ ड्यूटी।",
            "सभ्यता आचरण की वह शैली है जो मनुष्य को कर्तव्य का मार्ग दिखाती है।"
          ],
          "cells_en": [
            "Civilization is that mode of conduct which points out to man the path of duty.",
            "Si-vi-laai-ze-shan iz that mod ov kan-dakt wich points aut too man the paath ov dyoo-tee.",
            "Gandhi's famous definition of civilization."
          ]
        },
        {
          "cells_hi": [
            "Our ancestors were satisfied with small villages.",
            "आवर ऐंसेस्टर्स वर सैटिस्फ़ाइड विद स्मॉल विलेजेज़।",
            "हमारे पूर्वज छोटे गाँवों में संतुष्ट थे।"
          ],
          "cells_en": [
            "Our ancestors were satisfied with small villages.",
            "A-war an-ses-tarz war sa-tis-faaid with smol vi-le-jez.",
            "Shows preference for peaceful rural life."
          ]
        },
        {
          "cells_hi": [
            "Plain living and high thinking is the motto of a Western philosopher.",
            "प्लेन लिविंग ऐंड हाई थिंकिंग इज़ द मोटो ऑफ़ अ वेस्टर्न फ़िलॉसफ़र।",
            "सादा जीवन और उच्च विचार एक सच्चे दार्शनिक का आदर्श वाक्य है।"
          ],
          "cells_en": [
            "Plain living and high thinking is the motto of a Western philosopher.",
            "Plen li-ving and haai thing-king iz the mo-to ov a wes-tarn fi-lo-sa-far.",
            "True ideal for modern humanity."
          ]
        }
      ]
    },
    "concept_md_hi": "### उच्चारण व शब्दकोश अभ्यास\n1. **Civilization** (*सिविलाइज़ेशन*) = सभ्यता\n2. **Conduct** (*कंडक्ट*) = आचरण / व्यवहार\n3. **Restless** (*रेस्टलेस*) = बेचैन / अशांत\n4. **Unsatisfied** (*अनसैटिस्फ़ाइड*) = असंतुष्ट\n5. **Ancestors** (*ऐंसेस्टर्स*) = पूर्वज\n6. **Machinery** (*मशीनरी*) = यंत्र / मशीनें",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Civilization** (*सिविलाइज़ेशन*) = moral & cultural advancement\n2. **Conduct** (*कंडक्ट*) = behaviour / moral duty\n3. **Restless** (*रेस्टलेस*) = never at peace\n4. **Unsatisfied** (*अनसैटिस्फ़ाइड*) = never content\n5. **Ancestors** (*ऐंसेस्टर्स*) = forefathers\n6. **Machinery** (*मशीनरी*) = industrial machines",
    "exam_tip_hi": "4-अंक Explanation टिप: पहली पंक्ति हमेशा लिखें — *\"These lines have been taken from 'Indian Civilization and Culture', written by Mahatma Gandhi.\"* (इस 1 वाक्य पर ही 1 अंक पक्का मिलता है!)",
    "exam_tip_en": "4-Mark Explanation Formula: Always open with *\"These lines have been taken from 'Indian Civilization and Culture', written by Mahatma Gandhi.\"*",
    "glossary_terms": [
      {
        "term_hi": "Conduct (कंडक्ट)",
        "term_en": "Conduct",
        "pronunciation_hi": "कंडक्ट",
        "definition_hi": "आचरण या नैतिक व्यवहार (गुजराती में सभ्यता = Good conduct)।",
        "definition_en": "Behaviour and moral discipline."
      },
      {
        "term_hi": "Home Rule (होम रूल)",
        "term_en": "Home Rule",
        "pronunciation_hi": "होम रूल",
        "definition_hi": "स्वराज — आत्मनिर्भर और नैतिक स्वशासन।",
        "definition_en": "True Swaraj / self-governance."
      }
    ]
  },
  {
    "id": "icc-sec-4-summary",
    "order": 4,
    "heading_hi": "4. प्राचीन सभ्यता तालिका व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Ancient Civilizations Table & 5-Mark Summary Formula",
    "analogy_hi": "नीचे की 4-पंक्ति प्राचीन सभ्यता तालिका और 5-वाक्य सारांश याद कर लें — इंटर बोर्ड में इस पाठ से एक भी अंक नहीं कटेगा!",
    "analogy_en": "Master the ancient civilizations chart and 5-sentence summary formula to score 5/5 effortlessly!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "विश्व की प्राचीन सभ्यताएँ (BSEB Inter 100% PYQ Chart)",
      "title_en": "World Civilizations Mentioned by Gandhi (BSEB Inter PYQ Chart)",
      "headers_hi": [
        "सभ्यता / नाम",
        "संबंधित देश",
        "गांधीजी का निष्कर्ष"
      ],
      "headers_en": [
        "Civilization / Reference",
        "Country",
        "Gandhi's Observation"
      ],
      "rows": [
        {
          "cells_hi": [
            "Pharaohs (फ़राओ)",
            "मिस्र (Egypt)",
            "उनकी प्राचीन शक्ति टूट चुकी है"
          ],
          "cells_en": [
            "Pharaohs",
            "Egypt",
            "Their ancient might was broken"
          ]
        },
        {
          "cells_hi": [
            "Edward Gibbon",
            "इटली / रोम (Rome)",
            "रोमन साम्राज्य के पतन का इतिहास लिखा"
          ],
          "cells_en": [
            "Edward Gibbon",
            "Italy / Rome",
            "Recorded the decline and fall of Rome"
          ]
        },
        {
          "cells_hi": [
            "Attic Civilization",
            "यूनान (Greece)",
            "प्राचीन ग्रीस की शान समाप्त हो गई"
          ],
          "cells_en": [
            "Attic Civilization",
            "Greece",
            "Ancient Greece lost its original glory"
          ]
        },
        {
          "cells_hi": [
            "Indian Civilization",
            "भारत (India)",
            "नैतिक नींव पर आज भी अटल (Immovable) है!"
          ],
          "cells_en": [
            "Indian Civilization",
            "India",
            "Still stands sound & immovable on its moral foundation!"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"Indian Civilization and Culture\"** is a classic essay written by **Mahatma Gandhi**.\n2. He explains that while ancient civilizations like **Rome, Greece, and Egypt (Pharaohs)** fell, **India remains immovable** on her moral foundation.\n3. In Gujarati, civilization means **\"good conduct\"** that points out to man the **path of duty**.\n4. Gandhi warns that **\"mind is a restless bird\"**; our ancestors preferred **small villages** and honest labour over slavery to machines.\n5. While modern Western civilization worships **materialism**, Indian civilization elevates **morality** through **\"plain living and high thinking\"**.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"Indian Civilization and Culture\"** is a classic essay written by **Mahatma Gandhi**.\n2. He explains that while ancient civilizations like **Rome, Greece, and Egypt (Pharaohs)** fell, **India remains immovable** on her moral foundation.\n3. In Gujarati, civilization means **\"good conduct\"** that points out to man the **path of duty**.\n4. Gandhi warns that **\"mind is a restless bird\"**; our ancestors preferred **small villages** and honest labour over slavery to machines.\n5. While modern Western civilization worships **materialism**, Indian civilization elevates **morality** through **\"plain living and high thinking\"**.",
    "exam_tip_hi": "कॉपी में ये 5 शब्द अंडरलाइन करें: **Mahatma Gandhi**, **Good conduct**, **Restless bird**, **Small villages**, **Plain living and high thinking**!",
    "exam_tip_en": "Underline: **Mahatma Gandhi**, **Good conduct**, **Restless bird**, **Small villages**, **Plain living and high thinking**!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "गुजराती भाषा में \"Civilization (सभ्यता)\" का क्या अर्थ है?",
      "q_en": "What is the Gujarati equivalent for \"civilization\"?",
      "answer_hi": "**सदाचार (Good conduct)**।",
      "answer_en": "**Good conduct**."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Author",
      "fact_hi": "महात्मा गांधी (1869–1948) · My Experiments with Truth · Young India",
      "fact_en": "Mahatma Gandhi (1869–1948) · My Experiments with Truth · Young India"
    },
    {
      "tag": "PYQ Quartet",
      "fact_hi": "Pharaohs = Egypt · Gibbon = Italy · Attic = Greece · Gujarati = Good conduct",
      "fact_en": "Pharaohs = Egypt · Gibbon = Italy · Attic = Greece · Gujarati = Good conduct"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Indian Civilization and Culture is a landmark essay by Mahatma Gandhi.",
      "fact_en": "Indian Civilization and Culture is a landmark essay by Mahatma Gandhi."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "Unlike fallen Rome, Greece, and Egypt, India stands immovable on morality.",
      "fact_en": "Unlike fallen Rome, Greece, and Egypt, India stands immovable on morality."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "Civilization means good conduct pointing out the path of duty.",
      "fact_en": "Civilization means good conduct pointing out the path of duty."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "Mind is a restless bird; our ancestors chose small villages over machine slavery.",
      "fact_en": "Mind is a restless bird; our ancestors chose small villages over machine slavery."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "Indian culture upholds plain living and high thinking against Western materialism.",
      "fact_en": "Indian culture upholds plain living and high thinking against Western materialism."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "Pharaohs (फ़राओ) को रोम या ग्रीस का शासक लिख देना।",
      "mistake_en": "Linking Pharaohs to Rome or Greece.",
      "fix_hi": "सटीक जोड़ा याद रखें: **Pharaohs = Ancient Egypt (मिस्र)**, **Gibbon = Italy/Rome**, **Attic = Greece**!",
      "fix_en": "Exact pairs: **Pharaohs = Egypt**, **Gibbon = Italy/Rome**, **Attic = Greece**!"
    },
    {
      "mistake_hi": "यह लिख देना कि गांधीजी पश्चिमी लोगों से नफ़रत करते थे।",
      "mistake_en": "Claiming Gandhi hated Western people.",
      "fix_hi": "गांधीजी ने स्पष्ट कहा: *\"I am no hater of the West\"* — वे केवल अंधे भौतिकवाद के विरोधी थे।",
      "fix_en": "Gandhi explicitly wrote: *\"I am no hater of the West\"* — he opposed blind materialism only."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "भारतीय बनाम पश्चिमी सभ्यता की तुलना",
      "topic_en": "Comparison of Indian & Western Civilization",
      "years": [
        "2021",
        "2022",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "\"Mind is a restless bird\" व पूर्वजों द्वारा छोटे गाँवों का चयन",
      "topic_en": "\"Mind is a Restless Bird\" & Ancestors Choosing Villages",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-12-eng-ch1',
  2,
  'छात्र भारतीय बनाम पश्चिमी सभ्यता के अंतर को समझ सकेंगे, प्राचीन सभ्यताओं के PYQ तथ्य (Pharaohs, Gibbon, Attic, Good conduct) याद रख सकेंगे और 5-अंक सारांश व 4-अंक व्याख्या लिख सकेंगे।',
  'Students will contrast Indian morality with Western materialism, master high-yield BSEB PYQs, and write clean 5-mark summaries and 4-mark explanations.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "चम्पारण-गांधी हुक, उच्चारण अभ्यास व भारतीय-पश्चिमी तुलना चार्ट",
    "phase_en": "Champaran Hook, Pronunciation & Indian vs Western Board Chart",
    "teacher_action_hi": "पूछें: \"क्या नया मोबाइल मिलने के बाद मन शांत हो जाता है, या और नया चाहता है?\" इस उदाहरण से \"Mind is a restless bird\" समझाएँ। Civilization (सिविलाइज़ेशन), Pharaohs (फ़ैरोज़), Materialism (मटीरियलिज़्म), Ancestors (ऐंसेस्टर्स) का सामूहिक उच्चारण कराएँ।",
    "teacher_action_en": "Ask if getting a new phone ends our desires — introduce \"Mind is a restless bird\". Drill Civilization, Pharaohs, Materialism, and Ancestors, then draw the Indian vs Western chart.",
    "student_check_hi": "पूछें: \"फ़राओ (Pharaohs) किस देश के शासक थे और गुजराती में सभ्यता का अर्थ क्या है?\"",
    "student_check_en": "Ask: \"Pharaohs ruled which country, and what does civilization mean in Gujarati?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "4-अंक व्याख्या फ़ॉर्मूला, 5-मिनट मौखिक गतिविधि व 5-अंक सारांश",
    "phase_en": "4-Mark Explanation Frame, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "\"Mind is a restless bird\" पर 4-अंक संदर्भ-व्याख्या सिखाएँ। 5-मिनट मौखिक गतिविधि में कमजोर छात्र 5-वाक्य सारांश बोलें। अंत में 5 इंटर PYQ हल कराएँ।",
    "teacher_action_en": "Model a 4-mark context explanation on \"Mind is a restless bird\". Run a 5-min oral chain of the 5-sentence summary, then quiz 5 Inter PYQs.",
    "student_check_hi": "पूरी कक्षा से एक साथ आदर्श वाक्य बुलवाएँ: \"Plain living and high thinking!\"",
    "student_check_en": "Have the whole class repeat in chorus: \"Plain living and high thinking!\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड इंटर-बोर्ड बॉक्स (Indian Civilization and Culture)",
    "heading_en": "Blackboard Inter-Board Box",
    "points_hi": [
      "लेखक: Mahatma Gandhi (1869–1948) | पुस्तक: My Experiments with Truth",
      "PYQ जोड़े: Pharaohs = Egypt · Gibbon = Italy/Rome · Attic = Greece · Gujarati = Good conduct",
      "अमर पंक्ति: \"Mind is a restless bird, the more it gets the more it wants.\"",
      "पूर्वज: Small villages + Honest labour + Plain living and high thinking"
    ],
    "points_en": [
      "Author: Mahatma Gandhi (1869–1948) | Autobiography: My Experiments with Truth",
      "PYQ Pairs: Pharaohs = Egypt · Gibbon = Italy/Rome · Attic = Greece · Gujarati = Good conduct",
      "Famous Line: \"Mind is a restless bird, the more it gets the more it wants.\"",
      "Ancestors: Small villages + Hand-foot labour + Plain living and high thinking"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"देश और सभ्यता मिलाओ\" रैपिड राउंड",
    "title_en": "5-Minute \"Match the Civilization\" Rapid Round",
    "materials_hi": "बोर्ड पर 4 शब्द: Pharaohs, Gibbon, Attic, Good conduct",
    "materials_en": "4 prompts on board: Pharaohs, Gibbon, Attic, Good conduct",
    "steps_hi": "शिक्षक शब्द बोलें और सबसे पीछे बैठे छात्र तुरंत उत्तर बोलें (Egypt, Italy, Greece, Gujarati)।",
    "steps_en": "Teacher calls each keyword; back-bench students answer aloud immediately (Egypt, Italy, Greece, Gujarati)."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Civilization, Materialism, Ancestors, Restless और Conduct के उच्चारण व अर्थ 3 बार लिखें।",
    "task_en": "Write Civilization, Materialism, Ancestors, Restless, and Conduct 3 times with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "\"Mind is a restless bird\" की 4-अंक संदर्भ सहित व्याख्या (Explanation) लिखें।",
    "task_en": "Write a 4-mark explanation of \"Mind is a restless bird, the more it gets the more it wants.\""
  },
  {
    "level": "CHALLENGE",
    "task_hi": "\"Indian Civilization and Culture\" का 5-अंक सारांश बिना देखे लिखें।",
    "task_en": "Write the 5-mark summary of \"Indian Civilization and Culture\" from memory."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र \"Attic\" का अर्थ घर की छत (अटारी) समझ लेते हैं।",
    "misconception_en": "Students confuse \"Attic\" with a house loft/attic.",
    "correction_hi": "स्पष्ट करें कि बड़ा \"A\" वाला **Attic** प्राचीन **यूनान (Athens/Greece)** की सभ्यता के लिए प्रयुक्त हुआ है!",
    "correction_en": "Clarify capitalized **Attic** refers to ancient **Athens / Greece**!"
  },
  {
    "misconception_hi": "छात्र \"Pharaohs\" की स्पेलिंग और उच्चारण में गलती करते हैं।",
    "misconception_en": "Students struggle to pronounce or spell \"Pharaohs\".",
    "correction_hi": "तोड़कर सिखाएँ: **Pha-ra-ohs** (*फ़ैरोज़*) = मिस्र के प्राचीन राजा!",
    "correction_en": "Break it down: **Pha-ra-ohs** (*फ़ैरोज़*) = ancient rulers of Egypt!"
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
  (
    '10000007-0006-4000-8000-000000000001', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Author & Definition', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'Indian Civilization and Culture के लेखक कौन हैं और गुजराती में सभ्यता का अर्थ क्या है?',
    'Who wrote "Indian Civilization and Culture" and what does civilization mean in Gujarati?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"Indian Civilization and Culture\" के लेखक और गुजराती में सभ्यता का अर्थ बताएँ।",
  "front_en": "Name the author of \"Indian Civilization and Culture\" and the Gujarati meaning of civilization.",
  "back_hi": "लेखक: Mahatma Gandhi (1869–1948) · गुजराती में सभ्यता = \"Good conduct (सदाचार)\"।",
  "back_en": "Author: Mahatma Gandhi (1869–1948) · Gujarati equivalent = \"Good conduct\".",
  "pronunciation_hi": "इंडियन सिविलाइज़ेशन ऐंड कल्चर — गुड कंडक्ट",
  "mnemonic_hi": "G से Gandhi, G से Gujarati, G से Good conduct!",
  "mnemonic_en": "Triple-G hook: Gandhi -> Gujarati -> Good conduct!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000002', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Pharaohs और Materialism का उच्चारण व अर्थ क्या है?',
    'Give the pronunciation and meaning of Pharaohs and Materialism.',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Pharaohs और Materialism का सही उच्चारण व हिंदी अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Pharaohs\" and \"Materialism\".",
  "back_hi": "Pharaohs (फ़ैरोज़) = प्राचीन मिस्र (Egypt) के सम्राट · Materialism (मटीरियलिज़्म) = भौतिकवाद (धन-सुख की पूजा)।",
  "back_en": "Pharaohs = ancient rulers of Egypt · Materialism = excessive worship of physical wealth.",
  "pronunciation_hi": "फ़ैरोज़ · मटीरियलिज़्म",
  "mnemonic_hi": "Pharaohs = Egypt के पिरामिड वाले राजा!",
  "mnemonic_en": "Pharaohs = Pyramid rulers of Ancient Egypt!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000003', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Civilizations Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'स्तंभ A को स्तंभ B के सही देश या अर्थ से मिलाएँ:',
    'Match each reference from Gandhi''s essay in Column A with Column B:',
    NULL, NULL,
    'Egypt, Italy, Greece और Good conduct को सही जोड़े में मिलाएँ।', 'Match Egypt, Italy, Greece, and Good conduct accurately.',
    'Pharaohs = Egypt, Edward Gibbon = Italy/Rome, Attic = Greece, Gujarati Civilization = Good conduct।', 'Pharaohs -> Egypt, Gibbon -> Italy/Rome, Attic -> Greece, Gujarati civilization -> Good conduct.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each classical reference cleanly",
  "pairs": [
    {
      "id": "icc-m1",
      "left_hi": "Pharaohs (फ़राओ)",
      "left_en": "Pharaohs",
      "right_hi": "प्राचीन मिस्र (Egypt) के शासक",
      "right_en": "Rulers of Ancient Egypt"
    },
    {
      "id": "icc-m2",
      "left_hi": "Edward Gibbon",
      "left_en": "Edward Gibbon",
      "right_hi": "इटली / रोम के पतन के इतिहासकार",
      "right_en": "Historian associated with Italy / Rome"
    },
    {
      "id": "icc-m3",
      "left_hi": "Attic Civilization",
      "left_en": "Attic Civilization",
      "right_hi": "प्राचीन यूनान (Greece)",
      "right_en": "Ancient Greece"
    },
    {
      "id": "icc-m4",
      "left_hi": "Gujarati Civilization",
      "left_en": "Gujarati equivalent",
      "right_hi": "सदाचार (Good conduct)",
      "right_en": "Good conduct"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000004', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'गांधीजी की अमर पंक्ति सजाएँ: "मन एक बेचैन पक्षी है।"',
    'Build the iconic quote: "Mind is a restless bird"',
    NULL, NULL,
    'Subject (Mind) + is + a + Adjective (restless) + Noun (bird)।', 'Mind + is + a + restless + bird.',
    'सही वाक्य: "Mind is a restless bird"।', 'Correct quote: "Mind is a restless bird".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मन एक बेचैन पक्षी है।",
  "prompt_en": "Build Gandhi's most famous line from the essay",
  "grammar_formula": "Subject + is + a + Adjective + Noun",
  "tokens": [
    "Mind",
    "is",
    "a",
    "restless",
    "bird"
  ],
  "distractors": [
    "are",
    "an"
  ],
  "correct_sentence": "Mind is a restless bird",
  "pronunciation_hi": "माइंड इज़ अ रेस्टलेस बर्ड"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000005', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "हमारे पूर्वज छोटे गाँवों से संतुष्ट थे।"',
    'Build the exam sentence: "Our ancestors were satisfied with small villages"',
    NULL, NULL,
    'Plural subject "Our ancestors" के साथ "were" और "satisfied with" लगेगा।', 'Use plural past "were" + "satisfied with".',
    'सही वाक्य: "Our ancestors were satisfied with small villages"।', 'Correct sentence: "Our ancestors were satisfied with small villages".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "हमारे पूर्वज छोटे गाँवों से संतुष्ट थे।",
  "prompt_en": "Build this high-scoring sentence from Gandhi's essay",
  "grammar_formula": "Possessive + Plural Noun + were + satisfied with + Noun Phrase",
  "tokens": [
    "Our",
    "ancestors",
    "were",
    "satisfied",
    "with",
    "small",
    "villages"
  ],
  "distractors": [
    "was",
    "by"
  ],
  "correct_sentence": "Our ancestors were satisfied with small villages",
  "pronunciation_hi": "आवर ऐंसेस्टर्स वर सैटिस्फ़ाइड विद स्मॉल विलेजेज़"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000006', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Restless Bird MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    'महात्मा गांधी के अनुसार "मन एक बेचैन ___ है, जिसे जितना मिलता है वह उतना और चाहता है।"',
    'According to Mahatma Gandhi, "Mind is a restless ___; the more it gets the more it wants."',
    $json$[{"key":"A","text_hi":"शेर (Lion)","text_en":"Lion"},{"key":"B","text_hi":"पक्षी (Bird)","text_en":"Bird"},{"key":"C","text_hi":"मछली (Fish)","text_en":"Fish"},{"key":"D","text_hi":"घोड़ा (Horse)","text_en":"Horse"}]$json$::jsonb, 'B',
    'अमर पंक्ति: "Mind is a restless bird!"', 'Complete the iconic quote: "Mind is a restless ___!"',
    'गांधीजी ने मन की तुलना एक बेचैन पक्षी (restless bird) से की है।', 'Gandhi famously compares the mind to a restless bird.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000007', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Pharaohs MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'फ़राओ (Pharaohs) किस प्राचीन देश के शासक थे?',
    'Pharaohs were rulers of which ancient country?',
    $json$[{"key":"A","text_hi":"भारत (India)","text_en":"India"},{"key":"B","text_hi":"ग्रीस (Greece)","text_en":"Greece"},{"key":"C","text_hi":"रूस (Russia)","text_en":"Russia"},{"key":"D","text_hi":"मिस्र (Egypt)","text_en":"Egypt"}]$json$::jsonb, 'D',
    'नील नदी और पिरामिडों का देश!', 'The ancient land of the Nile and pyramids.',
    'फ़राओ प्राचीन मिस्र (Ancient Egypt) के सम्राट थे।', 'Pharaohs were the rulers of ancient Egypt.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000008', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Gujarati Meaning MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'गुजराती भाषा में "सभ्यता (Civilization)" का अर्थ क्या होता है?',
    'The Gujarati equivalent for civilization means:',
    $json$[{"key":"A","text_hi":"बुरे विचार (Bad conduct)","text_en":"Bad conduct"},{"key":"B","text_hi":"बुद्धिमान व्यवहार (Intelligent conduct)","text_en":"Intelligent conduct"},{"key":"C","text_hi":"सदाचार (Good conduct)","text_en":"Good conduct"},{"key":"D","text_hi":"अद्भुत आचरण (Delightful conduct)","text_en":"Delightful conduct"}]$json$::jsonb, 'C',
    'ट्रिपल-G ट्रिक याद करें: Gandhi → Gujarati → Good conduct!', 'Recall the Triple-G hook: Gandhi -> Gujarati -> Good conduct!',
    'गांधीजी लिखते हैं कि गुजराती में सभ्यता का अर्थ "सदाचार (good conduct)" है।', 'Gandhi writes that the Gujarati equivalent for civilization means "good conduct".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000009', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Gibbon Association MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2021',
    'प्रसिद्ध इतिहासकार गिबन (Gibbon) किस देश के इतिहास से जुड़े हैं?',
    'The historian Edward Gibbon is associated with which country?',
    $json$[{"key":"A","text_hi":"इटली (Italy)","text_en":"Italy"},{"key":"B","text_hi":"स्वीडन (Sweden)","text_en":"Sweden"},{"key":"C","text_hi":"रूस (Russia)","text_en":"Russia"},{"key":"D","text_hi":"अमेरिका (America)","text_en":"America"}]$json$::jsonb, 'A',
    'रोमन साम्राज्य (रोम = इटली की राजधानी) का इतिहास!', 'He wrote the history of the Roman Empire (Rome is in Italy).',
    'एडवर्ड गिबन ने रोमन साम्राज्य (इटली) के पतन का इतिहास लिखा था।', 'Edward Gibbon is associated with Italy (the Decline and Fall of the Roman Empire).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000010', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Indian vs Western Core', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2024',
    'गांधीजी के अनुसार भारतीय सभ्यता की प्रवृत्ति किस चीज़ को ऊँचा उठाने की है?',
    'According to Gandhi, the tendency of Indian civilization is to elevate:',
    $json$[{"key":"A","text_hi":"अनैतिकता (Immorality)","text_en":"Immorality"},{"key":"B","text_hi":"नैतिक सत्ता (The moral being)","text_en":"The moral being"},{"key":"C","text_hi":"आंशिकता (Partiality)","text_en":"Partiality"},{"key":"D","text_hi":"बेईमानी (Dishonesty)","text_en":"Dishonesty"}]$json$::jsonb, 'B',
    'जहाँ पश्चिमी सभ्यता भौतिकता बढ़ाती है, वहीं भारतीय सभ्यता नैतिकता को ऊँचा उठाती है।', 'Indian civilization prioritizes morality and character.',
    'गांधीजी स्पष्ट लिखते हैं: "The tendency of Indian civilization is to elevate the moral being."', 'Gandhi states that Indian civilization tends to elevate the moral being.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000011', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Exam Pool: Ancestors Villages', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2023',
    'हमारे पूर्वज किस प्रकार की बस्तियों से संतुष्ट थे?',
    'Our ancestors were satisfied with:',
    $json$[{"key":"A","text_hi":"कारखानों से","text_en":"Factories"},{"key":"B","text_hi":"बड़े महानगरों से","text_en":"Big cities"},{"key":"C","text_hi":"छोटे गाँवों से (Small villages)","text_en":"Small villages"},{"key":"D","text_hi":"विदेशी कस्बों से","text_en":"Foreign towns"}]$json$::jsonb, 'C',
    'वे बड़े शहरों को ठगों और शोषण का जाल मानते थे।', 'They viewed big cities as snares and useless encumbrances.',
    'हमारे पूर्वज शांत छोटे गाँवों (small villages) और सच्चे स्वराज से संतुष्ट थे।', 'Our ancestors were satisfied with small villages and True Home Rule.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000012', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Exam Pool: Autobiography', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2024',
    'महात्मा गांधी की प्रसिद्ध आत्मकथा का नाम क्या है?',
    'What is the title of Mahatma Gandhi''s famous autobiography?',
    $json$[{"key":"A","text_hi":"Wings of Fire","text_en":"Wings of Fire"},{"key":"B","text_hi":"India Divided","text_en":"India Divided"},{"key":"C","text_hi":"The Discovery of India","text_en":"The Discovery of India"},{"key":"D","text_hi":"My Experiments with Truth","text_en":"My Experiments with Truth"}]$json$::jsonb, 'D',
    'सत्य के साथ मेरे प्रयोग!', 'Translates as "My Experiments with Truth".',
    'महात्मा गांधी की आत्मकथा का नाम "My Experiments with Truth" है।', 'Mahatma Gandhi''s autobiography is titled "My Experiments with Truth".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000013', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Ancestors & Machinery 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'हमारे पूर्वजों ने हमें मशीनों और विलासिता से दूर रहने की सलाह क्यों दी?',
    'Why did our ancestors dissuade us from luxuries and machinery?',
    NULL, NULL,
    'गुलामी (slaves), नैतिक चरित्र (moral fibre) और हाथ-पैर के स्वस्थ श्रम का उल्लेख करें।', 'Mention becoming slaves, losing moral fibre, and healthy use of hands and feet.',
    NULL, NULL,
    'हमारे पूर्वजों ने हमें भारी मशीनों और विलासिता से दूर रखा क्योंकि वे जानते थे कि मशीनों के पीछे भागने से हम **उनके गुलाम (slaves)** बन जाएँगे और अपना **नैतिक बल (moral fibre)** खो देंगे। उनका विश्वास था कि सच्चा सुख और स्वास्थ्य अपने **हाथ-पैर से मेहनत** करने में है।', 'Our ancestors dissuaded us from machinery and luxuries because they knew that chasing machines would make us **slaves** and destroy our **moral fibre**. They wisely believed true happiness and health lie in the honest use of our **hands and feet**.',
    $json$[{"cue_hi":"मशीनों के गुलाम (slaves) बन जाते","cue_en":"Would become slaves & lose moral fibre"},{"cue_hi":"हाथ-पैर का स्वस्थ श्रम ही सच्चा सुख","cue_en":"True joy lies in using hands & feet"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"मशीनों की गुलामी व नैतिक पतन के भय का उल्लेख","criterion_en":"Explains fear of becoming slaves and losing moral fibre"},{"step_no":2,"marks":1,"criterion_hi":"हाथ-पैर के परिश्रम व सच्चे सुख के सिद्धांत का उल्लेख","criterion_en":"Mentions belief in honest hand-and-foot labour"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0006-4000-8000-000000000014', 'bseb-12-lang1-eng', 'bseb-12-eng-ch1', 'Summary & Theme 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"Indian Civilization and Culture" निबंध का सारांश लिखें।',
    'Write a summary of Mahatma Gandhi''s essay "Indian Civilization and Culture".',
    NULL, NULL,
    'लेखक, रोम/ग्रीस/मिस्र से तुलना, Good conduct, Restless bird, छोटे गाँव व सादा जीवन उच्च विचार लिखें।', 'Cover Gandhi, Rome/Greece/Egypt vs immovable India, good conduct, restless bird, villages, and plain living.',
    NULL, NULL,
    '**"Indian Civilization and Culture"** राष्ट्रपिता **महात्मा गांधी** द्वारा लिखा गया एक प्रसिद्ध निबंध है, जिसमें वे भारतीय सभ्यता की श्रेष्ठता सिद्ध करते हैं।

गांधीजी बताते हैं कि जहाँ **रोम, ग्रीस (Attic Greece)** और **मिस्र के फ़राओ** की महान सभ्यताएँ समय के साथ मिट गईं, वहीं भारत आज भी अपनी प्राचीन नैतिक नींव पर **अटल (immovable)** है। गुजराती में सभ्यता का अर्थ **"सदाचार (good conduct)"** है जो मनुष्य को कर्तव्य का मार्ग दिखाता है। गांधीजी कहते हैं कि **"मन एक बेचैन पक्षी है"** जो कभी तृप्त नहीं होता। इसलिए हमारे पूर्वजों ने इच्छाओं पर संयम रखा, मशीनों की गुलामी से बचे और शांत **छोटे गाँवों** में संतुष्ट रहे।

जहाँ आधुनिक पश्चिमी सभ्यता **भौतिकवाद** की पूजा करती है, वहीं भारतीय सभ्यता **नैतिकता** को ऊँचा उठाती है। अंत में गांधीजी हमें **"सादा जीवन और उच्च विचार (plain living and high thinking)"** अपनाने का संदेश देते हैं।', '**"Indian Civilization and Culture"** is a celebrated essay by **Mahatma Gandhi** highlighting the enduring strength of Indian civilization over modern Western materialism.

Gandhi observes that while mighty ancient civilizations like **Rome, Attic Greece, and Egypt''s Pharaohs** perished or transformed, **India still stands sound and immovable** on her ancient moral foundation. In Gujarati, civilization means **"good conduct"** pointing out the **path of duty**. Because the **"mind is a restless bird"** that stays unsatisfied no matter how much it gets, our ancestors set a limit to indulgences, avoided slavery to machines, and lived contentedly in **small villages**.

While Western civilization multiplies material wants, Indian civilization elevates the **moral being**. Gandhi urges us to cling to our heritage and live by the noble ideal of **"plain living and high thinking"**.',
    $json$[{"cue_hi":"Mahatma Gandhi · Immovable India vs Rome/Greece/Pharaohs","cue_en":"Mahatma Gandhi · Immovable India vs Rome/Greece/Pharaohs"},{"cue_hi":"Gujarati = Good conduct · Path of duty","cue_en":"Gujarati = Good conduct · Path of duty"},{"cue_hi":"Mind is a restless bird · Small villages","cue_en":"Mind is a restless bird · Small villages"},{"cue_hi":"Morality vs Materialism · Plain living & high thinking","cue_en":"Morality vs Materialism · Plain living & high thinking"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"लेखक (Mahatma Gandhi) व प्राचीन सभ्यताओं (Rome/Greece/Egypt) से तुलना","criterion_en":"Names Gandhi and contrasts immovable India with Rome/Greece/Egypt"},{"step_no":2,"marks":1.5,"criterion_hi":"सभ्यता की परिभाषा (Good conduct) व \"Mind is a restless bird\"","criterion_en":"Includes Gujarati meaning \"good conduct\" and restless bird quote"},{"step_no":3,"marks":1.5,"criterion_hi":"पूर्वजों की नीति (छोटे गाँव, मशीनों से संयम) व भौतिकवाद बनाम नैतिकता","criterion_en":"Explains ancestors' wisdom and Indian morality vs Western materialism"},{"step_no":4,"marks":1,"criterion_hi":"\"Plain living and high thinking\" का स्पष्ट निष्कर्ष","criterion_en":"Concludes cleanly with plain living and high thinking"}]$json$::jsonb,
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
-- CHAPTER 7 OF 14: BSEB-12-ENG-CH2 — Bharat is My Home — Dr. Zakir Husain
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-12-eng-ch2',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: भारत मेरा घर है (Bharat is My Home)",
  "title_en": "30-Second Mindmap: Bharat is My Home",
  "read_time_seconds": 30,
  "central_node": {
    "id": "bmh-root",
    "label_hi": "Bharat is My Home",
    "label_en": "Bharat is My Home (Speech)",
    "subtitle_hi": "Dr. Zakir Husain (1897–1969) · 1967 · Rainbow Part-2 (Ch 2)",
    "subtitle_en": "Dr. Zakir Husain (1897–1969) · 1967 · Rainbow Part-2 (Ch 2)"
  },
  "branches": [
    {
      "id": "bmh-speaker",
      "label_hi": "1. वक्ता व बिहार से गौरवशाली नाता",
      "label_en": "1. Speaker & Pride of Bihar Link",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "bmh-s1",
          "label_hi": "डॉ. ज़ाकिर हुसैन (1897–1969) · जन्म: हैदराबाद · भारत रत्न (1963)",
          "label_en": "Dr. Zakir Husain (1897–1969) · Born: Hyderabad · Bharat Ratna (1963)"
        },
        {
          "id": "bmh-s2",
          "label_hi": "बिहार के राज्यपाल (1957–1962) → भारत के तीसरे राष्ट्रपति (1967)",
          "label_en": "Governor of Bihar (1957–1962) -> 3rd President of India (1967)"
        }
      ]
    },
    {
      "id": "bmh-tribute",
      "label_hi": "2. डॉ. राधाकृष्णन को श्रद्धांजलि व शिक्षा",
      "label_en": "2. Tribute to Dr. Radhakrishnan & Education",
      "color": "#059669",
      "children": [
        {
          "id": "bmh-t1",
          "label_hi": "डॉ. एस. राधाकृष्णन राष्ट्रपति पद पर अद्वितीय विद्वता व अनुभव लाए",
          "label_en": "Dr. S. Radhakrishnan brought rare mental equipment & erudition"
        },
        {
          "id": "bmh-t2",
          "label_hi": "शिक्षा राष्ट्र-निर्माण का \"प्रमुख उपकरण (prime instrument)\" है!",
          "label_en": "Education is the \"prime instrument of national purpose\"!"
        }
      ]
    },
    {
      "id": "bmh-pledge",
      "label_hi": "3. शपथ और भारत-परिवार",
      "label_en": "3. Sacred Pledge & Family of Bharat",
      "color": "#D97706",
      "children": [
        {
          "id": "bmh-p1",
          "label_hi": "\"अतीत मृत व स्थिर नहीं, बल्कि जीवित और गतिशील है (alive and dynamic)\"",
          "label_en": "\"The past is not dead and static; it is alive and dynamic\""
        },
        {
          "id": "bmh-p2",
          "label_hi": "\"संपूर्ण भारत मेरा घर है और यहाँ के लोग मेरा परिवार हैं!\"",
          "label_en": "\"The whole of Bharat is my home and its people are my family!\""
        }
      ]
    },
    {
      "id": "bmh-work",
      "label_hi": "4. कार्य के दो पहलू (Two Aspects of Work)",
      "label_en": "4. Two Aspects of Work & Exam Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "bmh-w1",
          "label_hi": "(1) स्वयं के नैतिक विकास हेतु कार्य (Individual) + (2) समाज की सेवा (Social)",
          "label_en": "(1) Work on one's self (Individual) + (2) Work for society (Social)"
        },
        {
          "id": "bmh-w2",
          "label_hi": "शक्ति (Power) का उपयोग केवल नैतिक उद्देश्यों (moral purposes) के लिए हो।",
          "label_en": "Power should be used only for moral purposes (quoting Gandhi)."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "bmh-sec-1-speaker",
    "order": 1,
    "heading_hi": "1. वक्ता परिचय (बिहार के पूर्व राज्यपाल!) और 1967 का ऐतिहासिक दिन",
    "heading_en": "1. Speaker Profile (Former Governor of Bihar!) & 1967 Speech",
    "analogy_hi": "यह जानकर हर बिहार के छात्र का सीना गर्व से चौड़ा हो जाता है कि राष्ट्रपति बनने से पहले **डॉ. ज़ाकिर हुसैन** हमारे **बिहार के राज्यपाल (Governor of Bihar, 1957–1962)** रहे थे! वे पहले एक महान शिक्षक व शिक्षाविद् थे। जब 1967 में वे भारत के तीसरे राष्ट्रपति बने, तो उन्होंने कहा — *\"मेरा चयन शिक्षा के प्रति मेरे आजीवन समर्पण का सम्मान है, और पूरा भारत मेरा घर है!\"*",
    "analogy_en": "Bihar students share a special bond with **Dr. Zakir Husain** — before becoming India's 3rd President in **1967**, he served as the **Governor of Bihar**! A lifelong educator, he told the nation: *\"The whole of Bharat is my home and its people are my family.\"*",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "डॉ. ज़ाकिर हुसैन — शिक्षाविद् से राष्ट्रपति तक की यात्रा",
      "title_en": "Dr. Zakir Husain — From Educator to President of India",
      "events": [
        {
          "year": "1897",
          "title_hi": "जन्म — हैदराबाद",
          "title_en": "Born — Hyderabad",
          "detail_hi": "महान शिक्षाविद् और जामिया मिलिया इस्लामिया के प्रमुख शिल्पी।",
          "detail_en": "Eminent educationist and key architect of Jamia Millia Islamia."
        },
        {
          "year": "1957–1962",
          "title_hi": "बिहार के राज्यपाल (Governor of Bihar)",
          "title_en": "Governor of Bihar",
          "detail_hi": "बिहार में शिक्षा और संस्कृति को बढ़ावा दिया (BSEB इंटर का सबसे पसंदीदा MCQ!)।",
          "detail_en": "Served Bihar with distinction (top BSEB Inter MCQ!).",
          "highlight": true
        },
        {
          "year": "1963",
          "title_hi": "भारत रत्न सम्मान",
          "title_en": "Bharat Ratna Award",
          "detail_hi": "भारत का सर्वोच्च नागरिक सम्मान प्राप्त हुआ।",
          "detail_en": "Conferred India's highest civilian honour."
        },
        {
          "year": "1967",
          "title_hi": "भारत के तीसरे राष्ट्रपति के रूप में शपथ भाषण",
          "title_en": "Oath Speech as 3rd President of India",
          "detail_hi": "\"Bharat is My Home\" इसी ऐतिहासिक 1967 के शपथ भाषण का अंश है।",
          "detail_en": "\"Bharat is My Home\" is an extract from this 1967 oath speech.",
          "highlight": true
        }
      ]
    },
    "concept_md_hi": "### भाषण की शुरुआत — डॉ. राधाकृष्णन को नमन\n- 1967 में राष्ट्रपति पद की शपथ लेते हुए डॉ. ज़ाकिर हुसैन सबसे पहले जनता के विश्वास के प्रति कृतज्ञता व्यक्त करते हैं।\n- वे अपने पूर्ववर्ती राष्ट्रपति **डॉ. सर्वपल्ली राधाकृष्णन** की भूरि-भूरि प्रशंसा करते हुए कहते हैं कि वे इस सर्वोच्च पद पर **असाधारण मानसिक क्षमता (mental equipment), गहन विद्वता (erudition) और समृद्ध अनुभव (wealth of experience)** लेकर आए थे।\n- डॉ. हुसैन स्वीकार करते हैं कि एक शिक्षाविद् को राष्ट्रपति चुनकर भारत ने यह सिद्ध कर दिया कि **शिक्षा ही राष्ट्रीय उद्देश्य का प्रमुख साधन (prime instrument of national purpose)** है।",
    "concept_md_en": "### Opening Tribute to Dr. Radhakrishnan\n- Taking the oath as India's 3rd President in **1967**, Dr. Zakir Husain expresses deep gratitude for the nation's trust.\n- He pays glowing tribute to his predecessor, **Dr. S. Radhakrishnan**, who brought rare **mental equipment, erudition, and a wealth of experience** to the Presidency.\n- He declares that his election honours his lifelong bond with education — because **education is the prime instrument of national purpose**.",
    "exam_tip_hi": "BSEB इंटर के 3 पक्के MCQ: राष्ट्रपति बनने से पहले डॉ. हुसैन किस राज्य के राज्यपाल थे? → **Bihar** · शपथ वर्ष? → **1967** · राष्ट्रीय उद्देश्य का प्रमुख साधन? → **Education**!",
    "exam_tip_en": "3 Guaranteed Inter MCQs: Former Governor of **Bihar** · Oath year = **1967** · Prime instrument of national purpose = **Education**!",
    "glossary_terms": [
      {
        "term_hi": "Erudition (एरूडिशॅन)",
        "term_en": "Erudition",
        "pronunciation_hi": "एरूडिशॅन",
        "definition_hi": "गहन पांडित्य, विद्वता और व्यापक ज्ञान।",
        "definition_en": "Deep scholarly knowledge and great learning."
      },
      {
        "term_hi": "Instrument (इंस्ट्रूमेंट)",
        "term_en": "Instrument",
        "pronunciation_hi": "इंस्ट्रूमेंट",
        "definition_hi": "प्रमुख माध्यम या साधन (शिक्षा राष्ट्र-निर्माण का प्रमुख साधन है)।",
        "definition_en": "A chief tool or means to achieve a great purpose."
      }
    ]
  },
  {
    "id": "bmh-sec-2-pillars",
    "order": 2,
    "heading_hi": "2. विज़ुअल प्रवाह: डॉ. हुसैन के भाषण के 4 सुनहरे स्तंभ",
    "heading_en": "2. Visual Flow: 4 Golden Pillars of Dr. Husain's Speech",
    "analogy_hi": "कल्पना कीजिए भारत एक विशाल **संयुक्त परिवार (Joint Family)** है! जैसे घर तभी आगे बढ़ता है जब हर सदस्य खुद भी अच्छा इंसान बने और पूरे घर के लिए मेहनत करे — ठीक वैसे ही डॉ. ज़ाकिर हुसैन ने राष्ट्र-निर्माण के **दो पहलू (Individual + Social)** बताए!",
    "analogy_en": "Think of India as one vast joint family: a home thrives only when every member disciplines themselves AND works selflessly for the family — Dr. Husain's exact **Individual + Social** work formula!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "Bharat is My Home — 4 वैचारिक स्तंभ",
      "title_en": "Bharat is My Home — 4 Core Pillars of the Speech",
      "direction": "TB",
      "steps": [
        {
          "id": "bmh-st1",
          "label_hi": "1. जीवंत अतीत (Alive and Dynamic Past)",
          "label_en": "1. Past is Alive and Dynamic",
          "detail_hi": "भारत का अतीत मृत व जड़ नहीं है; वह जीवंत है और हमारे भविष्य की गुणवत्ता तय करता है।",
          "detail_en": "The past is not dead and static; it is alive and dynamic, shaping our future.",
          "accent": "indigo"
        },
        {
          "id": "bmh-st2",
          "label_hi": "2. शिक्षा = राष्ट्र का प्रमुख साधन (Education)",
          "label_en": "2. Education = Prime Instrument",
          "detail_hi": "राष्ट्र की गुणवत्ता सीधे उसकी शिक्षा की गुणवत्ता पर निर्भर करती है।",
          "detail_en": "The quality of the nation depends directly on the quality of its education.",
          "accent": "emerald"
        },
        {
          "id": "bmh-st3",
          "label_hi": "3. संपूर्ण भारत मेरा घर है (Bharat is My Home)",
          "label_en": "3. Whole of Bharat is My Home",
          "detail_hi": "जाति, धर्म या भाषा से ऊपर उठकर हर भारतीय मेरा परिवार है — मैं बिना भेदभाव सेवा की शपथ लेता हूँ।",
          "detail_en": "I pledge impartial loyalty to India's people regardless of caste, creed, or language.",
          "accent": "amber"
        },
        {
          "id": "bmh-st4",
          "label_hi": "4. कार्य के दो पहलू: व्यक्तिगत (Individual) + सामाजिक (Social)",
          "label_en": "4. Two Aspects of Work: Individual & Social",
          "detail_hi": "अपने नैतिक अनुशासन पर काम करें और समाज के उत्थान के लिए मिलजुलकर श्रम करें; शक्ति केवल नैतिक उद्देश्यों में लगे।",
          "detail_en": "Work on one's self for moral growth and work for society around; use power only for moral purposes.",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "bmh-st1",
          "to": "bmh-st2",
          "label_hi": "नवीनीकरण का माध्यम",
          "label_en": "Engine of renewal"
        },
        {
          "from": "bmh-st2",
          "to": "bmh-st3",
          "label_hi": "राष्ट्र की शपथ",
          "label_en": "National pledge"
        },
        {
          "from": "bmh-st3",
          "to": "bmh-st4",
          "label_hi": "कर्तव्य का मार्ग",
          "label_en": "Path of action"
        }
      ]
    },
    "concept_md_hi": "### भाषण के सबसे ज़रूरी विचार\n1. **भारत एक प्राचीन लोगों का युवा राज्य है:** डॉ. हुसैन कहते हैं कि हमारी संस्कृति हज़ारों वर्ष पुरानी है, पर आधुनिक लोकतांत्रिक गणराज्य के रूप में भारत एक **युवा राज्य (young State of an ancient people)** है।\n2. **दो प्रकार का कार्य (Two Aspects of Work):**\n   - **व्यक्तिगत कार्य (Work on one's self):** आत्म-अनुशासन द्वारा स्वयं को एक स्वतंत्र, नैतिक नागरिक बनाना।\n   - **सामाजिक कार्य (Work for society around):** पूरे समाज व देश के लिए निःस्वार्थ सेवा करना।\n3. **गांधीजी का आदर्श:** वे महात्मा गांधी का स्मरण कर कहते हैं कि **शक्ति (Power)** का उपयोग सदैव केवल **नैतिक उद्देश्यों (moral purposes)** के लिए ही होना चाहिए।",
    "concept_md_en": "### Core Ideas of the Speech\n1. **Young State of an Ancient People:** India has an ancient heritage yet is a young modern republic built through cooperation of diverse ethnic elements.\n2. **Two Mutually Fruitful Aspects of Work:**\n   - **Individual (Work on one's self):** Moral self-discipline to become a free, responsible person.\n   - **Social (Work for society around):** Collective service for a just, prosperous nation.\n3. **Gandhi's Ideal:** Quoting Mahatma Gandhi, Dr. Husain stresses that **power must be used only for moral purposes**.",
    "exam_tip_hi": "अक्सर पूछा जाने वाला 2-अंक व MCQ प्रश्न: \"Work on one's self\" का अर्थ क्या है? → **Individual moral development (व्यक्तिगत नैतिक विकास)**!",
    "exam_tip_en": "High-yield Inter question: What are the two aspects of work? → **Individual (work on one's self)** and **Social (work for society)**!",
    "glossary_terms": [
      {
        "term_hi": "Dynamic (डायनामिक)",
        "term_en": "Dynamic",
        "pronunciation_hi": "डायनामिक",
        "definition_hi": "जीवंत, गतिशील और निरंतर विकासशील।",
        "definition_en": "Full of life, energy, and continuous growth."
      },
      {
        "term_hi": "Pledge (प्लेज)",
        "term_en": "Pledge",
        "pronunciation_hi": "प्लेज",
        "definition_hi": "पवित्र शपथ या दृढ़ संकल्प।",
        "definition_en": "A solemn promise or commitment."
      }
    ],
    "quick_check": {
      "q_hi": "डॉ. ज़ाकिर हुसैन के अनुसार भारत का अतीत कैसा है?",
      "q_en": "According to Dr. Zakir Husain, how is India's past?",
      "answer_hi": "वह मृत और स्थिर नहीं है, बल्कि **जीवित और गतिशील (alive and dynamic)** है।",
      "answer_en": "It is not dead and static; it is **alive and dynamic**."
    }
  },
  {
    "id": "bmh-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "इन 4 प्रसिद्ध पंक्तियों को उच्चारण सहित याद कर लें — इंटर बोर्ड में 4-अंक Explanation और MCQ दोनों इन्हीं से आते हैं!",
    "analogy_en": "Master these 4 iconic lines aloud — they appear repeatedly in BSEB Inter MCQs and Explanations!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "Bharat is My Home — 4 प्रमुख पंक्तियाँ",
      "title_en": "4 Landmark Lines from Bharat is My Home",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "The past is not dead and static, it is alive and dynamic.",
            "द पास्ट इज़ नॉट डेड ऐंड स्टैटिक, इट इज़ अलाइव ऐंड डायनामिक।",
            "अतीत मृत और जड़ नहीं है, बल्कि जीवित और गतिशील है।"
          ],
          "cells_en": [
            "The past is not dead and static, it is alive and dynamic.",
            "The paast iz not ded and sta-tik, it iz a-laaiv and daai-na-mik.",
            "Heritage actively shapes our present and future."
          ]
        },
        {
          "cells_hi": [
            "Education is the prime instrument of national purpose.",
            "एजुकेशन इज़ द प्राइम इंस्ट्रूमेंट ऑफ़ नेशनल पर्पज़।",
            "शिक्षा राष्ट्रीय उद्देश्य का प्रमुख साधन है।"
          ],
          "cells_en": [
            "Education is the prime instrument of national purpose.",
            "E-ju-ke-shan iz the praaim in-stroo-ment ov na-sha-nal par-paz.",
            "Education drives national character and growth."
          ]
        },
        {
          "cells_hi": [
            "The whole of Bharat is my home and its people are my family.",
            "द होल ऑफ़ भारत इज़ माई होम ऐंड इट्स पीपल आर माई फ़ैमिली।",
            "संपूर्ण भारत मेरा घर है और यहाँ के निवासी मेरा परिवार हैं।"
          ],
          "cells_en": [
            "The whole of Bharat is my home and its people are my family.",
            "The hol ov Bhaa-rat iz maai hom and its pee-pal aar maai fa-mi-lee.",
            "Heart of Dr. Husain's presidential oath."
          ]
        },
        {
          "cells_hi": [
            "Power should be used only for moral purposes.",
            "पावर शुड बी यूज़्ड ओनली फ़ॉर मॉरल पर्पज़ेज़।",
            "शक्ति का प्रयोग केवल नैतिक उद्देश्यों के लिए होना चाहिए।"
          ],
          "cells_en": [
            "Power should be used only for moral purposes.",
            "Paa-war shud bee yoozd on-lee for mo-ral par-pa-zez.",
            "Gandhian principle endorsed by Dr. Husain."
          ]
        }
      ]
    },
    "concept_md_hi": "### उच्चारण व शब्दकोश अभ्यास\n1. **Constitution** (*कॉन्स्टिट्यूशन*) = संविधान\n2. **Humility** (*ह्यूमिलिटी*) = विनम्रता\n3. **Dedication** (*डेडिकेशन*) = पूर्ण समर्पण\n4. **Static** (*स्टैटिक*) = स्थिर / रुका हुआ\n5. **Prosperous** (*प्रॉस्परस*) = समृद्ध व खुशहाल\n6. **Predecessor** (*प्रीडिसेसर*) = पूर्ववर्ती (पहले पद पर रहने वाले व्यक्ति)",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Constitution** (*कॉन्स्टिट्यूशन*) = supreme law of the nation\n2. **Humility** (*ह्यूमिलिटी*) = modest, humble spirit\n3. **Dedication** (*डेडिकेशन*) = total commitment\n4. **Static** (*स्टैटिक*) = unchanging, lifeless\n5. **Prosperous** (*प्रॉस्परस*) = thriving and wealthy\n6. **Predecessor** (*प्रीडिसेसर*) = previous holder of an office",
    "exam_tip_hi": "याद रखें: डॉ. ज़ाकिर हुसैन राष्ट्रपति के कार्यालय में **\"prayerful humility and total dedication (प्रार्थनापूर्ण विनम्रता व पूर्ण समर्पण)\"** की भावना से प्रवेश करते हैं!",
    "exam_tip_en": "Classic MCQ phrase: Dr. Husain enters the office in a spirit of **\"prayerful humility and total dedication\"**!",
    "glossary_terms": [
      {
        "term_hi": "Humility (ह्यूमिलिटी)",
        "term_en": "Humility",
        "pronunciation_hi": "ह्यूमिलिटी",
        "definition_hi": "अहंकार से रहित विनम्रता और सेवाभाव।",
        "definition_en": "Modest, selfless humbleness of spirit."
      },
      {
        "term_hi": "Predecessor (प्रीडिसेसर)",
        "term_en": "Predecessor",
        "pronunciation_hi": "प्रीडिसेसर",
        "definition_hi": "पद पर पहले रहे व्यक्ति (डॉ. हुसैन के पूर्ववर्ती = डॉ. एस. राधाकृष्णन)।",
        "definition_en": "The person who held the office earlier (Dr. Radhakrishnan)."
      }
    ]
  },
  {
    "id": "bmh-sec-4-summary",
    "order": 4,
    "heading_hi": "4. 5-अंक सारांश फ़ॉर्मूला (सरल व प्रभावशाली अंग्रेज़ी)",
    "heading_en": "4. Easy 5-Mark Summary Formula",
    "analogy_hi": "नीचे के 5 साफ-सुथरे वाक्य याद कर लें — इंटरमीडिएट बोर्ड परीक्षा में \"Bharat is My Home\" पर 5 में से 5 अंक पक्के!",
    "analogy_en": "Memorize these 5 crisp sentences to score a full 5/5 in the Class 12 Board Exam!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "व्यक्तिगत कार्य बनाम सामाजिक कार्य (डॉ. हुसैन का दोहरा सिद्धांत)",
      "title_en": "Individual Work vs Social Work (Dr. Husain's Dual Formula)",
      "headers_hi": [
        "कार्य का पहलू",
        "अर्थ (Meaning)",
        "राष्ट्र को लाभ"
      ],
      "headers_en": [
        "Aspect of Work",
        "Meaning",
        "Benefit to the Nation"
      ],
      "rows": [
        {
          "cells_hi": [
            "1. व्यक्तिगत कार्य (Work on one's self)",
            "आत्म-अनुशासन, नैतिक विकास व चरित्र निर्माण",
            "स्वतंत्र व जिम्मेदार नागरिक का निर्माण"
          ],
          "cells_en": [
            "1. Individual Work",
            "Self-discipline and moral self-development",
            "Creates a free, ethical citizen"
          ]
        },
        {
          "cells_hi": [
            "2. सामाजिक कार्य (Work for society)",
            "परिवार-भाव से समाज व देश की निःस्वार्थ सेवा",
            "न्यायपूर्ण, समृद्ध और सुदृढ़ भारत का निर्माण"
          ],
          "cells_en": [
            "2. Social Work",
            "Selfless collective effort for community welfare",
            "Builds a just, strong, prosperous Bharat"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"Bharat is My Home\"** is an extract from **Dr. Zakir Husain's** famous presidential oath speech delivered in **1967**.\n2. He warmly praises his predecessor **Dr. S. Radhakrishnan** for bringing rare erudition and wisdom to the Presidency.\n3. Dr. Husain declares that **education is the prime instrument of national purpose** and that India's **past is alive and dynamic**.\n4. Pledging loyalty to India's culture and Constitution, he says **\"the whole of Bharat is my home and its people are my family\"**.\n5. He calls for both **individual moral work** and **social service**, using national **power only for moral purposes**.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"Bharat is My Home\"** is an extract from **Dr. Zakir Husain's** famous presidential oath speech delivered in **1967**.\n2. He warmly praises his predecessor **Dr. S. Radhakrishnan** for bringing rare erudition and wisdom to the Presidency.\n3. Dr. Husain declares that **education is the prime instrument of national purpose** and that India's **past is alive and dynamic**.\n4. Pledging loyalty to India's culture and Constitution, he says **\"the whole of Bharat is my home and its people are my family\"**.\n5. He calls for both **individual moral work** and **social service**, using national **power only for moral purposes**.",
    "exam_tip_hi": "कॉपी में **Dr. Zakir Husain**, **1967**, **Dr. Radhakrishnan**, **Education**, और **Alive and dynamic** अंडरलाइन करें!",
    "exam_tip_en": "Underline **Dr. Zakir Husain**, **1967**, **Dr. Radhakrishnan**, **Education**, and **Alive and dynamic**!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "डॉ. ज़ाकिर हुसैन ने किन दो प्रकार के कार्यों पर बल दिया है?",
      "q_en": "Which two aspects of work does Dr. Zakir Husain emphasize?",
      "answer_hi": "(1) स्वयं के नैतिक विकास का कार्य (**Individual**) और (2) समाज के कल्याण का कार्य (**Social**)।",
      "answer_en": "(1) **Individual** (work on one's self) and (2) **Social** (work for society around)."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Speaker",
      "fact_hi": "डॉ. ज़ाकिर हुसैन (1897–1969) · भारत के 3रे राष्ट्रपति · पूर्व बिहार राज्यपाल",
      "fact_en": "Dr. Zakir Husain (1897–1969) · 3rd President · Former Governor of Bihar"
    },
    {
      "tag": "Year & Genre",
      "fact_hi": "1967 · विधा: Speech (शपथ भाषण) · Rainbow Part-2 (Ch 2)",
      "fact_en": "1967 · Genre: Speech (Oath Address) · Rainbow Part-2 (Ch 2)"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Bharat is My Home is Dr. Zakir Husain's 1967 Presidential oath speech.",
      "fact_en": "Bharat is My Home is Dr. Zakir Husain's 1967 Presidential oath speech."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "He honours Dr. S. Radhakrishnan's erudition and lifelong humanism.",
      "fact_en": "He honours Dr. S. Radhakrishnan's erudition and lifelong humanism."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "He calls education the prime instrument of national purpose.",
      "fact_en": "He calls education the prime instrument of national purpose."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "He pledges impartial service declaring the whole of Bharat his home and family.",
      "fact_en": "He pledges impartial service declaring the whole of Bharat his home and family."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "He urges individual discipline and social service, using power morally.",
      "fact_en": "He urges individual discipline and social service, using power morally."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "डॉ. ज़ाकिर हुसैन के शपथ लेने का वर्ष 1962 या 1969 लिख देना।",
      "mistake_en": "Writing 1962 or 1969 as the speech year.",
      "fix_hi": "स्पष्ट याद रखें: **1967** में राष्ट्रपति बने (1969 में उनका निधन हुआ था)!",
      "fix_en": "Remember clearly: took oath in **1967** (passed away in 1969)!"
    },
    {
      "mistake_hi": "उन्हें \"भारत का प्रथम राष्ट्रपति\" लिख देना।",
      "mistake_en": "Calling him India's first President.",
      "fix_hi": "प्रथम राष्ट्रपति = डॉ. राजेंद्र प्रसाद; डॉ. ज़ाकिर हुसैन भारत के **तीसरे (3rd)** राष्ट्रपति थे!",
      "fix_en": "1st President = Dr. Rajendra Prasad; Dr. Zakir Husain was the **3rd** President!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "डॉ. ज़ाकिर हुसैन का बिहार राज्यपाल व 1967 भाषण संदर्भ",
      "topic_en": "Governor of Bihar & 1967 Oath Speech Facts",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    },
    {
      "topic_hi": "शिक्षा का महत्व, जीवंत अतीत व कार्य के दो पहलू (सारांश)",
      "topic_en": "Education, Alive Past & Two Aspects of Work (Summary)",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-12-eng-ch2',
  2,
  'छात्र डॉ. ज़ाकिर हुसैन के 1967 भाषण के प्रमुख विचारों (शिक्षा, जीवंत अतीत, भारत-परिवार, दोहरे कार्य) को समझ सकेंगे और इंटरमीडिएट MCQ व 5-अंक सारांश सटीकता से लिख सकेंगे।',
  'Students will explain Dr. Zakir Husain''s 1967 speech themes (education, alive past, Bharat as home, individual + social work) and score full marks in Inter exams.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "बिहार राज्यपाल कनेक्शन, उच्चारण अभ्यास व 4-स्तंभ चित्र",
    "phase_en": "Bihar Governor Hook, Pronunciation & 4-Pillar Flow",
    "teacher_action_hi": "बताएँ कि डॉ. ज़ाकिर हुसैन हमारे बिहार के राज्यपाल रहे और फिर भारत के तीसरे राष्ट्रपति बने। Erudition (एरूडिशॅन), Instrument (इंस्ट्रूमेंट), Dynamic (डायनामिक), Humility (ह्यूमिलिटी) का उच्चारण अभ्यास कराएँ और 4 स्तंभ बोर्ड पर बनाएँ।",
    "teacher_action_en": "Connect Dr. Husain's governorship of Bihar to his 1967 Presidency. Drill Erudition, Instrument, Dynamic, and Humility, then sketch the 4 pillars on the board.",
    "student_check_hi": "पूछें: \"राष्ट्र-निर्माण का प्रमुख उपकरण (prime instrument) क्या है?\" (Education)",
    "student_check_en": "Ask: \"What is the prime instrument of national purpose?\" (Education)"
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "दोहरे कार्य का विश्लेषण, 5-मिनट मौखिक गतिविधि व सारांश",
    "phase_en": "Dual Work Analysis, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "Individual और Social work का अंतर समझाएँ। 5-मिनट मौखिक गतिविधि में कमजोर छात्र 5-वाक्य सारांश बोलें। अंत में 5 इंटर PYQ हल करवाएँ।",
    "teacher_action_en": "Contrast Individual vs Social work. Run a 5-min oral chain of the 5-sentence summary for shy learners, then quiz 5 Inter PYQs.",
    "student_check_hi": "पूरी कक्षा से शपथ-वाक्य बुलवाएँ: \"The whole of Bharat is my home and its people are my family.\"",
    "student_check_en": "Have the class recite together: \"The whole of Bharat is my home and its people are my family.\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड रिवीजन बॉक्स (Bharat is My Home)",
    "heading_en": "Blackboard Revision Box (Bharat is My Home)",
    "points_hi": [
      "वक्ता: Dr. Zakir Husain (1897–1969) · पूर्व बिहार राज्यपाल · 3rd President (1967)",
      "श्रद्धांजलि: Dr. S. Radhakrishnan (Erudition & wealth of experience)",
      "अतीत: Not dead and static, alive and dynamic | प्रमुख साधन: Education",
      "2 कार्य: (1) Individual (Work on one's self) + (2) Social (Work for society)"
    ],
    "points_en": [
      "Speaker: Dr. Zakir Husain (1897–1969) · Ex-Governor of Bihar · 3rd President (1967)",
      "Tribute: Dr. S. Radhakrishnan (Erudition & wealth of experience)",
      "Past: Alive and dynamic | Prime instrument: Education",
      "2 Aspects of Work: Individual (self) + Social (society)"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"मेरा भारत, मेरा परिवार\" मौखिक संकल्प",
    "title_en": "5-Minute \"My Duty to Bharat\" Oral Pledge",
    "materials_hi": "बोर्ड वाक्य: \"As a student of Bihar, I will serve my home Bharat by...\"",
    "materials_en": "Board starter: \"I will serve my home Bharat by...\"",
    "steps_hi": "प्रत्येक कमजोर छात्र 1 छोटा अंग्रेज़ी वाक्य बोलें (\"studying honestly\", \"helping others\", \"keeping my school clean\")।",
    "steps_en": "Each shy learner completes the pledge in 1 simple English phrase aloud."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Erudition, Dynamic, Humility, Constitution और Instrument को उच्चारण व अर्थ सहित लिखें।",
    "task_en": "Write Erudition, Dynamic, Humility, Constitution, and Instrument with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "\"The past is not dead and static, it is alive and dynamic.\" की 4-अंक संदर्भ व्याख्या लिखें।",
    "task_en": "Explain with reference to context: \"The past is not dead and static, it is alive and dynamic.\""
  },
  {
    "level": "CHALLENGE",
    "task_hi": "\"Bharat is My Home\" का 5-अंक सारांश स्वच्छ अंग्रेज़ी में लिखें।",
    "task_en": "Write the 5-mark summary of \"Bharat is My Home\" neatly."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र डॉ. ज़ाकिर हुसैन के जन्म स्थान को दिल्ली या बिहार लिख देते हैं।",
    "misconception_en": "Students write Delhi or Bihar as Dr. Zakir Husain's birthplace.",
    "correction_hi": "स्पष्ट करें: उनका जन्म **हैदराबाद (Hyderabad, 1897)** में हुआ था, और वे **बिहार के राज्यपाल** रहे थे!",
    "correction_en": "Clarify: born in **Hyderabad (1897)**; served as **Governor of Bihar**!"
  },
  {
    "misconception_hi": "छात्र \"Bharat is My Home\" को निबंध (Essay) लिख देते हैं।",
    "misconception_en": "Students classify the piece as a story or essay.",
    "correction_hi": "यह 1967 में राष्ट्रपति शपथ के बाद दिया गया **भाषण (Speech)** है।",
    "correction_en": "Always identify its genre as a **Speech** delivered in 1967."
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
  (
    '10000007-0007-4000-8000-000000000001', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Speaker & Year', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'Bharat is My Home किसका भाषण है और कब दिया गया था?',
    'Who delivered "Bharat is My Home" and in which year?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"Bharat is My Home\" के वक्ता, वर्ष और बिहार से उनका संबंध बताएँ।",
  "front_en": "Name the speaker, year, and Bihar link of \"Bharat is My Home\".",
  "back_hi": "वक्ता: Dr. Zakir Husain (1897–1969) · वर्ष: 1967 (3रे राष्ट्रपति का शपथ भाषण) · पूर्व बिहार राज्यपाल (Governor of Bihar)।",
  "back_en": "Speaker: Dr. Zakir Husain (1897–1969) · Year: 1967 (3rd President oath speech) · Former Governor of Bihar.",
  "pronunciation_hi": "भारत इज़ माई होम — डॉ. ज़ाकिर हुसैन",
  "mnemonic_hi": "1967 में बिहार के पूर्व राज्यपाल ने कहा: \"भारत मेरा घर है!\"",
  "mnemonic_en": "Ex-Bihar Governor took Presidential oath in 1967: \"Bharat is my home!\""
}$json$::jsonb,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000002', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Erudition और Dynamic का उच्चारण व अर्थ क्या है?',
    'Give the pronunciation and meaning of Erudition and Dynamic.',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Erudition और Dynamic शब्दों का सही उच्चारण व अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Erudition\" and \"Dynamic\".",
  "back_hi": "Erudition (एरूडिशॅन) = गहन विद्वता (डॉ. राधाकृष्णन के लिए प्रयुक्त) · Dynamic (डायनामिक) = जीवंत व गतिशील (भारत का अतीत)।",
  "back_en": "Erudition = deep scholarly learning · Dynamic = energetic, alive, and evolving.",
  "pronunciation_hi": "एरूडिशॅन · डायनामिक",
  "mnemonic_hi": "राधाकृष्णन = Erudition · भारत का अतीत = Alive & Dynamic!",
  "mnemonic_en": "Radhakrishnan = Erudition · India's past = Alive & Dynamic!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000003', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Speech Facts Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'स्तंभ A को स्तंभ B के सही तथ्य से मिलाएँ:',
    'Match each item from "Bharat is My Home" in Column A with Column B:',
    NULL, NULL,
    '1967, डॉ. राधाकृष्णन, शिक्षा और अतीत की प्रकृति मिलाएँ।', 'Match 1967, Dr. Radhakrishnan, Education, and Past.',
    '1967 में राष्ट्रपति शपथ, डॉ. राधाकृष्णन ने विद्वता दी, शिक्षा प्रमुख साधन है, अतीत जीवित व गतिशील है।', 'Oath in 1967, Dr. Radhakrishnan brought erudition, education is prime instrument, past is alive & dynamic.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each key fact from the speech",
  "pairs": [
    {
      "id": "bmh-m1",
      "left_hi": "1967",
      "left_en": "1967",
      "right_hi": "डॉ. ज़ाकिर हुसैन के राष्ट्रपति बनने का वर्ष",
      "right_en": "Year Dr. Zakir Husain became President"
    },
    {
      "id": "bmh-m2",
      "left_hi": "Dr. S. Radhakrishnan",
      "left_en": "Dr. S. Radhakrishnan",
      "right_hi": "अद्वितीय विद्वता व अनुभव लाने वाले पूर्ववर्ती राष्ट्रपति",
      "right_en": "Predecessor who brought rare erudition"
    },
    {
      "id": "bmh-m3",
      "left_hi": "Education (शिक्षा)",
      "left_en": "Education",
      "right_hi": "राष्ट्रीय उद्देश्य का प्रमुख साधन (Prime instrument)",
      "right_en": "Prime instrument of national purpose"
    },
    {
      "id": "bmh-m4",
      "left_hi": "India's Past (अतीत)",
      "left_en": "India's Past",
      "right_hi": "जीवित और गतिशील (Alive and dynamic)",
      "right_en": "Alive and dynamic, not dead and static"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000004', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'भाषण की प्रमुख पंक्ति सजाएँ: "शिक्षा राष्ट्रीय उद्देश्य का प्रमुख साधन है।"',
    'Build the exam sentence: "Education is the prime instrument of national purpose"',
    NULL, NULL,
    'Education + is + the prime instrument + of + national purpose।', 'Follow: Subject + is + the + Adjective + Noun + of + Noun Phrase.',
    'सही वाक्य: "Education is the prime instrument of national purpose"।', 'Correct sentence: "Education is the prime instrument of national purpose".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "शिक्षा राष्ट्रीय उद्देश्य का प्रमुख साधन है।",
  "prompt_en": "Build Dr. Zakir Husain's iconic sentence on education",
  "grammar_formula": "Subject + is + the + Adjective + Noun + of + Adjective + Noun",
  "tokens": [
    "Education",
    "is",
    "the",
    "prime",
    "instrument",
    "of",
    "national",
    "purpose"
  ],
  "distractors": [
    "are",
    "a"
  ],
  "correct_sentence": "Education is the prime instrument of national purpose",
  "pronunciation_hi": "एजुकेशन इज़ द प्राइम इंस्ट्रूमेंट ऑफ़ नेशनल पर्पज़"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000005', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "शक्ति का उपयोग केवल नैतिक उद्देश्यों के लिए होना चाहिए।"',
    'Build the sentence: "Power should be used only for moral purposes"',
    NULL, NULL,
    'Modal Passive: Power + should + be + used + only for moral purposes।', 'Modal passive: should + be + V3 (used).',
    'सही वाक्य: "Power should be used only for moral purposes"।', 'Correct sentence: "Power should be used only for moral purposes".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "शक्ति का उपयोग केवल नैतिक उद्देश्यों के लिए होना चाहिए।",
  "prompt_en": "Build the closing moral principle from the speech",
  "grammar_formula": "Subject + should + be + V3 + only for + Noun Phrase",
  "tokens": [
    "Power",
    "should",
    "be",
    "used",
    "only",
    "for",
    "moral",
    "purposes"
  ],
  "distractors": [
    "use",
    "is"
  ],
  "correct_sentence": "Power should be used only for moral purposes",
  "pronunciation_hi": "पावर शुड बी यूज़्ड ओनली फ़ॉर मॉरल पर्पज़ेज़"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000006', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Bihar Governor MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    'भारत का राष्ट्रपति बनने से पहले डॉ. ज़ाकिर हुसैन किस राज्य के राज्यपाल (Governor) रहे थे?',
    'Earlier, Dr. Zakir Husain had served as the Governor of which Indian state?',
    $json$[{"key":"A","text_hi":"बंगाल (Bengal)","text_en":"Bengal"},{"key":"B","text_hi":"असम (Assam)","text_en":"Assam"},{"key":"C","text_hi":"बिहार (Bihar)","text_en":"Bihar"},{"key":"D","text_hi":"कर्नाटक (Karnataka)","text_en":"Karnataka"}]$json$::jsonb, 'C',
    'अपना ही राज्य — 1957 से 1962 तक!', 'Our very own state (1957–1962)!',
    'डॉ. ज़ाकिर हुसैन 1957 से 1962 तक बिहार (Bihar) के राज्यपाल थे।', 'Dr. Zakir Husain served as the Governor of Bihar before becoming Vice-President and President.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000007', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Prime Instrument MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'डॉ. ज़ाकिर हुसैन के अनुसार राष्ट्रीय उद्देश्य का प्रमुख साधन (prime instrument) क्या है?',
    'According to Dr. Zakir Husain, what is the prime instrument of national purpose?',
    $json$[{"key":"A","text_hi":"शिक्षा (Education)","text_en":"Education"},{"key":"B","text_hi":"व्यापार (Business)","text_en":"Business"},{"key":"C","text_hi":"सेवा (Service)","text_en":"Service"},{"key":"D","text_hi":"राजनीति (Politics)","text_en":"Politics"}]$json$::jsonb, 'A',
    'वे स्वयं आजीवन महान शिक्षाविद् रहे थे!', 'He himself was a lifelong educationist!',
    'डॉ. ज़ाकिर हुसैन शिक्षा (Education) को राष्ट्रीय उद्देश्य का प्रमुख उपकरण मानते हैं।', 'Dr. Zakir Husain declares education to be the prime instrument of national purpose.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000008', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Oath Year MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'डॉ. ज़ाकिर हुसैन ने भारत के राष्ट्रपति के रूप में शपथ किस वर्ष ली थी?',
    'In which year did Dr. Zakir Husain take the oath as President of India?',
    $json$[{"key":"A","text_hi":"1969","text_en":"1969"},{"key":"B","text_hi":"1962","text_en":"1962"},{"key":"C","text_hi":"1965","text_en":"1965"},{"key":"D","text_hi":"1967","text_en":"1967"}]$json$::jsonb, 'D',
    '1967 में शपथ ली और 1969 में उनका निधन हुआ।', 'He became President in 1967 and passed away in 1969.',
    'डॉ. ज़ाकिर हुसैन ने 1967 में राष्ट्रपति पद की शपथ ली और यही भाषण दिया।', 'Dr. Zakir Husain delivered this oath speech in 1967.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000009', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Radhakrishnan Tribute', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'भाषण के अनुसार राष्ट्रपति पद पर असाधारण विद्वता (erudition) और अनुभव कौन लेकर आए थे?',
    'Who brought extraordinary mental equipment, erudition, and wealth of experience to the Presidency?',
    $json$[{"key":"A","text_hi":"डॉ. राजेंद्र प्रसाद","text_en":"Dr. Rajendra Prasad"},{"key":"B","text_hi":"डॉ. सर्वपल्ली राधाकृष्णन","text_en":"Dr. S. Radhakrishnan"},{"key":"C","text_hi":"जवाहरलाल नेहरू","text_en":"Jawaharlal Nehru"},{"key":"D","text_hi":"सरदार पटेल","text_en":"Sardar Patel"}]$json$::jsonb, 'B',
    'डॉ. ज़ाकिर हुसैन के ठीक पहले राष्ट्रपति (जिनके जन्मदिन पर शिक्षक दिवस मनाया जाता है)!', 'Dr. Husain''s immediate predecessor, whose birthday is Teachers'' Day!',
    'डॉ. हुसैन अपने पूर्ववर्ती डॉ. एस. राधाकृष्णन को गहरी श्रद्धांजलि अर्पित करते हैं।', 'Dr. Husain pays glowing tribute to Dr. S. Radhakrishnan.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000010', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Two Aspects of Work', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    'डॉ. ज़ाकिर हुसैन के अनुसार "स्वयं पर कार्य (Work on one''s self)" का अर्थ किसके लिए कार्य करना है?',
    'According to Dr. Zakir Husain, "work on one''s self" means work for:',
    $json$[{"key":"A","text_hi":"धन संचय (Wealth)","text_en":"Wealth"},{"key":"B","text_hi":"विदेश (Foreign country)","text_en":"Foreign country"},{"key":"C","text_hi":"व्यक्तिगत नैतिक विकास (Individual)","text_en":"Individual"},{"key":"D","text_hi":"केवल परिवार (Family only)","text_en":"Family only"}]$json$::jsonb, 'C',
    'कार्य के दो पहलू हैं: Individual और Social।', 'The two aspects of work are Individual and Social.',
    '"Work on one''s self" का अर्थ व्यक्तिगत (Individual) नैतिक विकास है, जो सामाजिक (Social) सेवा से जुड़ा होता है।', '"Work on one''s self" refers to individual moral growth, paired with social service.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000011', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Exam Pool: Nature of Past', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'डॉ. ज़ाकिर हुसैन के अनुसार हमारा अतीत (The past) कैसा है?',
    'According to Dr. Zakir Husain, the past is:',
    $json$[{"key":"A","text_hi":"बेकार और पुराना (Useless)","text_en":"Useless"},{"key":"B","text_hi":"हानिकारक (Harmful)","text_en":"Harmful"},{"key":"C","text_hi":"मृत और स्थिर (Dead and static)","text_en":"Dead and static"},{"key":"D","text_hi":"जीवित और गतिशील (Alive and dynamic)","text_en":"Alive and dynamic"}]$json$::jsonb, 'D',
    'पंक्ति: "The past is not dead and static, it is ___."', 'Complete: "The past is not dead and static, it is ___."',
    'वे कहते हैं कि अतीत जीवित और गतिशील (alive and dynamic) है।', 'Dr. Husain declares that the past is alive and dynamic.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000012', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Exam Pool: Spirit of Entry', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2023',
    'डॉ. ज़ाकिर हुसैन किस भावना के साथ राष्ट्रपति कार्यालय में प्रवेश करते हैं?',
    'In what spirit does Dr. Zakir Husain enter the office of the President?',
    $json$[{"key":"A","text_hi":"प्रार्थनापूर्ण विनम्रता और पूर्ण समर्पण (Prayerful humility and total dedication)","text_en":"Prayerful humility and total dedication"},{"key":"B","text_hi":"डर और संदेह के साथ","text_en":"Fear and doubt"},{"key":"C","text_hi":"उदासीनता के साथ","text_en":"Indifference"},{"key":"D","text_hi":"अहंकार और गर्व के साथ","text_en":"Pride and arrogance"}]$json$::jsonb, 'A',
    'उनकी महान विनम्रता व सेवाभाव याद करें।', 'Recall his humble, devoted opening pledge.',
    'वे "prayerful humility and total dedication" की भावना से राष्ट्रपति पद ग्रहण करते हैं।', 'He enters the Presidency in a spirit of prayerful humility and total dedication.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000013', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Why Bharat is Home 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'डॉ. ज़ाकिर हुसैन ने क्यों कहा कि "संपूर्ण भारत मेरा घर है"?',
    'Why does Dr. Zakir Husain call India "the young State of an ancient people" and say "Bharat is my home"?',
    NULL, NULL,
    'भारत की प्राचीन संस्कृति, युवा गणतंत्र और बिना भेदभाव सबको परिवार मानने का संकल्प लिखें।', 'Mention ancient culture + young republic, and treating all Indians impartially as one family.',
    NULL, NULL,
    'डॉ. ज़ाकिर हुसैन भारत को अपना घर और उसके निवासियों को अपना **परिवार** कहते हैं क्योंकि राष्ट्रपति के रूप में वे जाति, धर्म या भाषा के किसी भी भेदभाव के बिना देश के प्रत्येक नागरिक की सेवा के लिए प्रतिबद्ध हैं। भारत की संस्कृति प्राचीन है, पर आधुनिक लोकतांत्रिक गणराज्य के रूप में यह एक **युवा राज्य** है जिसे मिलजुलकर समृद्ध बनाना है।', 'Dr. Zakir Husain calls the whole of Bharat his home and its people his **family** because as President he pledges impartial devotion to every Indian irrespective of caste, creed, or language. Though India''s cultural heritage is ancient, as a modern democratic republic it is a **young State** needing everyone''s united effort.',
    $json$[{"cue_hi":"पूरा भारत = घर, सभी नागरिक = परिवार","cue_en":"Whole of Bharat = home, people = family"},{"cue_hi":"बिना जाति-धर्म भेदभाव निष्पक्ष सेवा","cue_en":"Impartial service beyond caste, creed, language"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"सभी भारतीयों को बिना भेदभाव परिवार मानने का उल्लेख","criterion_en":"Explains treating all Indians impartially as one family"},{"step_no":2,"marks":1,"criterion_hi":"प्राचीन संस्कृति व युवा गणतंत्र के विकास की शपथ","criterion_en":"Mentions ancient people / young State and pledge to build it"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0007-4000-8000-000000000014', 'bseb-12-lang1-eng', 'bseb-12-eng-ch2', 'Speech Summary 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"Bharat is My Home" भाषण का सारांश लिखें।',
    'Write a summary of Dr. Zakir Husain''s speech "Bharat is My Home".',
    NULL, NULL,
    '1967 शपथ भाषण, डॉ. राधाकृष्णन को नमन, शिक्षा = प्रमुख साधन, जीवंत अतीत, भारत = घर/परिवार और दो कार्य लिखें।', 'Cover 1967 oath, tribute to Radhakrishnan, education as prime instrument, alive past, Bharat as home, and dual work.',
    NULL, NULL,
    '**"Bharat is My Home"** भारत के तीसरे राष्ट्रपति **डॉ. ज़ाकिर हुसैन** द्वारा **1967** में शपथ ग्रहण के अवसर पर दिया गया एक प्रेरणादायक भाषण है।

डॉ. हुसैन सबसे पहले अपने पूर्ववर्ती **डॉ. सर्वपल्ली राधाकृष्णन** की विद्वता और अनुभव की प्रशंसा करते हैं। वे कहते हैं कि **शिक्षा (education)** ही राष्ट्रीय उद्देश्य का **प्रमुख साधन (prime instrument)** है। भारत का अतीत मृत नहीं, बल्कि **जीवित और गतिशील (alive and dynamic)** है। वे भारत की संस्कृति और संविधान के प्रति निष्ठा की शपथ लेते हुए घोषणा करते हैं कि **"संपूर्ण भारत मेरा घर है और इसके लोग मेरा परिवार हैं"**।

अंत में वे कार्य के दो पहलू बताते हैं — **स्वयं का नैतिक विकास (individual)** और **समाज की सेवा (social)** — तथा गांधीजी का आदर्श दोहराते हैं कि शक्ति का प्रयोग केवल **नैतिक उद्देश्यों** के लिए होना चाहिए।', '**"Bharat is My Home"** is an inspiring extract from the **1967** Presidential oath speech of **Dr. Zakir Husain**, India''s third President and former Governor of Bihar.

He begins by praising his predecessor **Dr. S. Radhakrishnan** for bringing extraordinary erudition and experience to the office. Calling **education the prime instrument of national purpose**, he explains that India''s **past is alive and dynamic**, continuously renewing our future. Entering office in prayerful humility and total dedication, he pledges loyalty to India''s culture and Constitution and declares that **"the whole of Bharat is my home and its people are my family"**.

Finally, he outlines **two aspects of work — individual self-discipline and social service** — reminding us of Gandhi''s ideal that **power must be used only for moral purposes**.',
    $json$[{"cue_hi":"Dr. Zakir Husain · 1967 Oath Speech","cue_en":"Dr. Zakir Husain · 1967 Oath Speech"},{"cue_hi":"Tribute to Dr. Radhakrishnan · Education = prime instrument","cue_en":"Tribute to Dr. Radhakrishnan · Education = prime instrument"},{"cue_hi":"Past alive & dynamic · Bharat = home & family","cue_en":"Past alive & dynamic · Bharat = home & family"},{"cue_hi":"Individual + Social work · Power for moral purposes","cue_en":"Individual + Social work · Power for moral purposes"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"वक्ता (Dr. Zakir Husain), 1967 व डॉ. राधाकृष्णन को श्रद्धांजलि","criterion_en":"Names speaker, 1967 occasion, and tribute to Radhakrishnan"},{"step_no":2,"marks":1.5,"criterion_hi":"शिक्षा का महत्व (prime instrument) व जीवंत अतीत","criterion_en":"Explains education as prime instrument and alive, dynamic past"},{"step_no":3,"marks":1.5,"criterion_hi":"\"संपूर्ण भारत मेरा घर व परिवार\" की शपथ","criterion_en":"Highlights Bharat as home and impartial pledge to people"},{"step_no":4,"marks":1,"criterion_hi":"दोहरे कार्य (Individual + Social) व शक्ति का नैतिक उपयोग","criterion_en":"Covers individual & social work plus moral use of power"}]$json$::jsonb,
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
-- CHAPTER 8 OF 14: BSEB-12-ENG-CH3 — A Pinch of Snuff — Manohar Malgonkar
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-12-eng-ch3',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: एक चुटकी सुँघनी (A Pinch of Snuff)",
  "title_en": "30-Second Mindmap: A Pinch of Snuff",
  "read_time_seconds": 30,
  "central_node": {
    "id": "pos-root",
    "label_hi": "A Pinch of Snuff",
    "label_en": "A Pinch of Snuff (Comic Story)",
    "subtitle_hi": "Manohar Malgonkar (1913–2010) · Rainbow Part-2 (Ch 3)",
    "subtitle_en": "Manohar Malgonkar (1913–2010) · Rainbow Part-2 (Ch 3)"
  },
  "branches": [
    {
      "id": "pos-chars",
      "label_hi": "1. मुख्य पात्र (Characters)",
      "label_en": "1. Key Characters",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "pos-c1",
          "label_hi": "नानूकाका (Nanukaka): कथावाचक के बेहद चालाक व हाज़िरजवाब मामा",
          "label_en": "Nanukaka: Narrator's witty, resourceful maternal uncle"
        },
        {
          "id": "pos-c2",
          "label_hi": "कथावाचक: दिल्ली में Under-Secretary on probation",
          "label_en": "Narrator: Under-Secretary on probation in Delhi"
        },
        {
          "id": "pos-c3",
          "label_hi": "सोहनलाल रतिराम (पार्टी बॉस) व कल्याण मंत्री (Welfare Minister)",
          "label_en": "Sohanlal Ratiram (Party Boss) & Welfare Minister"
        }
      ]
    },
    {
      "id": "pos-arrival",
      "label_hi": "2. दिल्ली आगमन (Train Trick)",
      "label_en": "2. Arrival in Delhi",
      "color": "#059669",
      "children": [
        {
          "id": "pos-a1",
          "label_hi": "माँ कहती हैं: \"केवल 2–3 दिन (two or three days) रुकेंगे\"",
          "label_en": "Mother assures: he stays only \"two or three days\""
        },
        {
          "id": "pos-a2",
          "label_hi": "तीसरे दर्जे के टिकट पर दूसरे दर्जे में सफ़र + टोकरी में बिल्ली का बच्चा (Kitten)!",
          "label_en": "Third-class ticket in second-class carriage + basket with a kitten!"
        }
      ]
    },
    {
      "id": "pos-stunts",
      "label_hi": "3. नानूकाका के 3 मास्टरस्ट्रोक",
      "label_en": "3. Nanukaka's 3 Clever Tricks",
      "color": "#D97706",
      "children": [
        {
          "id": "pos-s1",
          "label_hi": "सोहनलाल रतिराम के यहाँ राजदूत \"हज़रत बरकत अली\" का नाम उछाला",
          "label_en": "Dropped Ambassador Hazrat Barkat Ali's name at Sohanlal's house"
        },
        {
          "id": "pos-s2",
          "label_hi": "सिक्का ऑटो डीलर्स: धोबी + ₹1,000 चेक का नाटक कर शानदार बड़ी कार मुफ़्त ली!",
          "label_en": "Sikka Auto Dealers: dhobi + ₹1,000 cheque stunt to borrow a grand car!"
        },
        {
          "id": "pos-s3",
          "label_hi": "मंत्री की विज़िटर बुक में लिखा: \"निन्नौर के महाराजा का वंशानुगत ज्योतिषी\"",
          "label_en": "Signed Minister's book: \"Hereditary Astrologer to Maharaja of Ninnore\""
        }
      ]
    },
    {
      "id": "pos-end",
      "label_hi": "4. मज़ेदार अंत व बोर्ड फोकस",
      "label_en": "4. Comic Climax & Board Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "pos-e1",
          "label_hi": "कल्याण मंत्री खुद अगली सुबह नानूकाका से मिलने घर दौड़े चले आए!",
          "label_en": "Welfare Minister himself rushed to Nanukaka's house the next morning!"
        },
        {
          "id": "pos-e2",
          "label_hi": "पक्के MCQ: Maternal uncle, Kitten, 3rd class ticket, ₹1,000 cheque, Ninnore।",
          "label_en": "Top MCQs: Maternal uncle, Kitten, 3rd class ticket, ₹1,000 cheque, Ninnore."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "pos-sec-1-author",
    "order": 1,
    "heading_hi": "1. लेखक परिचय और हमारे रिश्तेदार \"जुगाड़ू मामा\" से मज़ेदार जुड़ाव",
    "heading_en": "1. Author Profile & Everyday Relatable Comedy",
    "analogy_hi": "हर भारतीय परिवार में एक ऐसे चतुर \"मामा जी\" होते हैं जो किसी भी दफ़्तर या मंत्री से काम निकलवाने का गज़ब जुगाड़ जानते हैं! **मनोहर मालगाँवकर** की सबसे मज़ेदार कहानी **A Pinch of Snuff** के हीरो **नानूकाका** ऐसे ही जीनियस मामा हैं — हर नई चाल से पहले चाँदी की डिबिया से **एक चुटकी सुँघनी (a pinch of snuff)** लेते हैं और दिल्ली के बड़े-बड़े नेताओं को घुमा देते हैं!",
    "analogy_en": "Every Indian family knows one ultra-resourceful uncle who can charm his way past any VIP barrier! **Manohar Malgonkar's** laugh-out-loud story **A Pinch of Snuff** stars **Nanukaka**, who takes a signature pinch of snuff before outsmarting Delhi's top politicians!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "A Pinch of Snuff — पात्र व प्रमुख तथ्य (BSEB Inter Gold Table)",
      "title_en": "Characters & Key Facts in A Pinch of Snuff",
      "headers_hi": [
        "पात्र / नाम",
        "कहानी में भूमिका (Role)"
      ],
      "headers_en": [
        "Character / Name",
        "Role in the Story"
      ],
      "rows": [
        {
          "cells_hi": [
            "Manohar Malgonkar (1913–2010)",
            "प्रसिद्ध भारतीय अंग्रेज़ी उपन्यासकार व कहानीकार (लेखक)"
          ],
          "cells_en": [
            "Manohar Malgonkar (1913–2010)",
            "Celebrated Indian English novelist & short-story writer"
          ]
        },
        {
          "cells_hi": [
            "Nanukaka (नानूकाका)",
            "कथावाचक के चतुर मामा (Maternal uncle), सुँघनी लेने के शौकीन"
          ],
          "cells_en": [
            "Nanukaka",
            "Narrator's witty maternal uncle fond of taking a pinch of snuff"
          ]
        },
        {
          "cells_hi": [
            "Narrator (कथावाचक)",
            "दिल्ली में Under-Secretary on probation, नानूकाका का भांजा"
          ],
          "cells_en": [
            "Narrator",
            "Under-Secretary on probation in Delhi; forced to act as driver"
          ]
        },
        {
          "cells_hi": [
            "Sohanlal Ratiram",
            "दिल्ली के प्रभावशाली पार्टी बॉस (Party Boss)"
          ],
          "cells_en": [
            "Sohanlal Ratiram",
            "Influential Party Boss in Delhi"
          ]
        },
        {
          "cells_hi": [
            "Welfare Minister",
            "कल्याण मंत्री — जिनकी बेटी की शादी निन्नौर के राजकुमार से तय हो रही थी"
          ],
          "cells_en": [
            "Welfare Minister",
            "Minister planning his daughter's marriage to Prince of Ninnore"
          ]
        }
      ]
    },
    "concept_md_hi": "### कहानी की धमाकेदार शुरुआत\n- कथावाचक की माँ खुश होकर खबर देती हैं कि उनके भाई **नानूकाका** दिल्ली आ रहे हैं। कथावाचक (जो **Under-Secretary on probation** है) घबरा जाता है, तो माँ कहती हैं कि वे केवल **2–3 दिन (two or three days)** रुकेंगे और किसी **मंत्री (Minister)** से मिलने आ रहे हैं।\n- स्टेशन पर नानूकाका **तीसरे दर्जे के टिकट (third-class ticket)** पर **दूसरे दर्जे के डिब्बे (second-class carriage)** से उतरते हैं — और हाथ में एक **बेंत की टोकरी** है जिसमें एक **बिल्ली का बच्चा (kitten)** है! टिकट कलेक्टर को भी उन्होंने बातों से पटा लिया था!",
    "concept_md_en": "### Comic Opening at Delhi Station\n- The narrator's mother joyfully announces that her brother **Nanukaka** is coming to Delhi for **\"two or three days\"** to see a **Minister**.\n- The narrator (an **Under-Secretary on probation**) receives him at the station, where Nanukaka steps out of a **second-class carriage** holding a **third-class ticket** and a basket containing a **kitten** — having smoothly charmed the Ticket Collector!",
    "exam_tip_hi": "BSEB इंटर में हर साल छपने वाले 4 MCQ: नानूकाका कौन थे? → **Maternal uncle** · टोकरी में क्या था? → **Kitten** · कितने दिन रुकने को आए? → **2 or 3 days** · टिकट कौन-सा? → **Third-class** (डिब्बा: Second-class)!",
    "exam_tip_en": "4 Guaranteed Inter MCQs: Nanukaka = **Maternal uncle** · Basket = **Kitten** · Stay = **2 or 3 days** · Ticket = **3rd class** (in 2nd class)!",
    "glossary_terms": [
      {
        "term_hi": "Snuff (स्नफ़)",
        "term_en": "Snuff",
        "pronunciation_hi": "स्नफ़",
        "definition_hi": "नाक से सूँघने वाला बारीक तंबाकू चूर्ण (सुँघनी) — नानूकाका हर योजना से पहले एक चुटकी लेते हैं।",
        "definition_en": "Finely powdered tobacco inhaled in a pinch; Nanukaka's trademark habit."
      },
      {
        "term_hi": "Probation (प्रोबेशन)",
        "term_en": "Probation",
        "pronunciation_hi": "प्रोबेशन",
        "definition_hi": "सरकारी नौकरी की शुरुआती परिवीक्षा अवधि।",
        "definition_en": "Initial trial period in a government job."
      }
    ]
  },
  {
    "id": "pos-sec-2-storyboard",
    "order": 2,
    "heading_hi": "2. विज़ुअल स्टोरीबोर्ड: मंत्री को घर बुलाने की नानूकाका की 4-कदम चाल!",
    "heading_en": "2. Visual Storyboard: Nanukaka's 4-Step Masterplan!",
    "analogy_hi": "दिल्ली में साधारण आदमी को मंत्री से मिलने में महीनों लग जाते हैं — पर नानूकाका ने दिमाग़ ऐसा चलाया कि **कल्याण मंत्री खुद अपनी कार लेकर नानूकाका के दरवाज़े पर हाज़िर हो गए!** नीचे के 4 चरण मज़े लेकर पढ़ें!",
    "analogy_en": "Getting a Minister's appointment usually takes weeks — watch how Nanukaka reverses the game so the **Welfare Minister comes knocking on Nanukaka's door!**",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "नानूकाका का मास्टरप्लान — 4 मज़ेदार कदम",
      "title_en": "Nanukaka's Genius 4-Step Masterplan",
      "direction": "TB",
      "steps": [
        {
          "id": "pos-st1",
          "label_hi": "कदम 1: सोहनलाल रतिराम के घर जासूसी (हज़रत बरकत अली का नाम!)",
          "label_en": "Step 1: Outsmarting Sohanlal Ratiram",
          "detail_hi": "राजदूत हज़रत बरकत अली का नाम लेकर पार्टी बॉस को प्रभावित किया और पता लगाया कि कल्याण मंत्री अपनी बेटी की शादी निन्नौर के राजकुमार से करना चाहते हैं!",
          "detail_en": "Drops Ambassador Hazrat Barkat Ali's name and learns the Welfare Minister wants his daughter to marry the Prince of Ninnore!",
          "accent": "indigo"
        },
        {
          "id": "pos-st2",
          "label_hi": "कदम 2: सिक्का ऑटो डीलर्स में ₹1,000 चेक और धोबी का नाटक!",
          "label_en": "Step 2: ₹1,000 Cheque & Dhobi Trick at Sikka Auto Dealers",
          "detail_hi": "अपने कोट में ₹1,000 का बेयरर चेक रखकर धोबी को बुलवाया; धोबी को ₹2 इनाम देकर डीलर पर अमीरी का रौब जमाया और शानदार बड़ी कार मुफ़्त ले उड़े!",
          "detail_en": "Stages a dhobi returning a ₹1,000 cheque left in his coat, tips ₹2, impresses Sikka Auto Dealers, and drives off in a massive luxury car!",
          "accent": "amber"
        },
        {
          "id": "pos-st3",
          "label_hi": "कदम 3: राज-ज्योतिषी का भेष व विज़िटर बुक में हस्ताक्षर",
          "label_en": "Step 3: Astrologer Disguise & Visitor's Book",
          "detail_hi": "भांजे को जोधपुरी कोट व नारंगी पगड़ी में ड्राइवर बनाया; खुद पंडित बने और मंत्री की विज़िटर बुक में लिखा — \"निन्नौर के महाराजा का वंशानुगत ज्योतिषी\" (पता: कथावाचक का घर)!",
          "detail_en": "Dresses narrator as chauffeur in Jodhpuri coat & orange turban; signs Minister's book as \"Hereditary Astrologer to the Maharaja of Ninnore\"!",
          "accent": "emerald"
        },
        {
          "id": "pos-st4",
          "label_hi": "कदम 4: कल्याण मंत्री खुद दरवाज़े पर हाज़िर!",
          "label_en": "Step 4: Welfare Minister Arrives at the Doorstep!",
          "detail_hi": "शाही शादी की खबर सुनते ही घबराए कल्याण मंत्री अगले ही दिन खुद कथावाचक के घर नानूकाका से मिलने पहुँच गए — मिशन 100% सफल!",
          "detail_en": "Eager about the royal marriage, the Welfare Minister himself rushes to the narrator's house the very next morning — mission accomplished!",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "pos-st1",
          "to": "pos-st2",
          "label_hi": "सुराग मिला",
          "label_en": "Got the clue"
        },
        {
          "from": "pos-st2",
          "to": "pos-st3",
          "label_hi": "भव्य कार मिली",
          "label_en": "Got grand car"
        },
        {
          "from": "pos-st3",
          "to": "pos-st4",
          "label_hi": "जाल बिछाया",
          "label_en": "Trap sprung"
        }
      ]
    },
    "concept_md_hi": "### कहानी के 3 सबसे मज़ेदार बिंदु (इंटर PYQ)\n1. **लाला सोहनलाल का बेटा (Ratiram):** रतिराम उसी मंत्रालय में काम करता था। सोहनलाल इसलिए नाराज़ था क्योंकि कल्याण मंत्री ने उसके बेटे के लिए **हज़रत बरकत अली** के पास राजदूत की पोस्टिंग रुकवा दी और अपनी बेटी की शादी **निन्नौर के राजकुमार** से तय कर रहे थे।\n2. **₹1,000 का चेक व ₹2 का इनाम:** सिक्का ऑटो डीलर्स के सामने नानूकाका ने पहले से सिखाए हुए **धोबी** को बुलाकर **1,000 रुपये का चेक** कोट से निकलवाया और ईमानदारी पर **2 रुपये का नोट** इनाम देकर रईसी का अद्भुत नाटक रचा!\n3. **जोधपुरी कोट व नारंगी पगड़ी:** कथावाचक को **बंदगला जोधपुरी कोट** और **नारंगी पगड़ी (huge orange turban)** पहनाकर अपना ड्राइवर (chauffeur) बना दिया!",
    "concept_md_en": "### 3 Hilarious Highlights (Top Inter PYQs)\n1. **Sohanlal Ratiram's Grudge:** Sohanlal was angry because the Welfare Minister blocked his son's posting under **Hazrat Barkat Ali** and was arranging his daughter's wedding with the **Prince of Ninnore**.\n2. **The ₹1,000 Cheque Stunt:** At **Sikka Auto Dealers**, Nanukaka staged his **dhobi** returning a **₹1,000 cheque** \"forgotten\" in his coat, rewarding him with a **two-rupee note** to look like a rich zamindar!\n3. **Chauffeur Disguise:** Nanukaka dressed the narrator in a **close-collar Jodhpuri coat** and a **huge orange turban** as his driver!",
    "exam_tip_hi": "चेक की राशि = **₹1,000** · धोबी को इनाम = **₹2** · डीलर = **Sikka Auto Dealers** · रियासत = **Ninnore**!",
    "exam_tip_en": "Exact numbers: Cheque = **₹1,000** · Dhobi tip = **₹2** · Dealer = **Sikka Auto Dealers** · State = **Ninnore**!",
    "glossary_terms": [
      {
        "term_hi": "Hereditary (हेरेडिटरी)",
        "term_en": "Hereditary",
        "pronunciation_hi": "हेरेडिटरी",
        "definition_hi": "वंशानुगत या पीढ़ी-दर-पीढ़ी चला आ रहा पद।",
        "definition_en": "Passed down by family lineage from generation to generation."
      },
      {
        "term_hi": "Chauffeur (शोफ़र)",
        "term_en": "Chauffeur",
        "pronunciation_hi": "शोफ़र",
        "definition_hi": "अमीर व्यक्ति की निजी कार चलाने वाला वर्दीधारी ड्राइवर।",
        "definition_en": "A uniformed private car driver (pronounced \"sho-far\")."
      }
    ],
    "quick_check": {
      "q_hi": "नानूकाका ने धोबी को ₹1,000 का चेक लौटाने पर कितने रुपये इनाम दिए?",
      "q_en": "How much did Nanukaka reward the dhobi for returning the ₹1,000 cheque?",
      "answer_hi": "**दो रुपये का नोट (a two-rupee note)**।",
      "answer_en": "**A two-rupee note**."
    }
  },
  {
    "id": "pos-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "इन 4 मज़ेदार पंक्तियों को उच्चारण के साथ बोलकर याद करें — इंटर बोर्ड के हर प्रश्न में काम आएँगी!",
    "analogy_en": "Practice reading these 4 vivid lines aloud — they unlock both MCQs and 5-mark answers!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "A Pinch of Snuff — 4 प्रमुख पंक्तियाँ",
      "title_en": "4 Key Lines from A Pinch of Snuff",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "Mother's announcement shook me: Nanukaka is coming.",
            "मदर्स अनाउंसमेंट शुक मी: नानूकाका इज़ कमिंग।",
            "माँ की घोषणा ने मुझे हिला दिया: नानूकाका आ रहे हैं।"
          ],
          "cells_en": [
            "Mother's announcement shook me: Nanukaka is coming.",
            "Ma-darz a-nauns-ment shuk mee: Naa-noo-kaa-kaa iz ka-ming.",
            "Comic opening sentence of the story."
          ]
        },
        {
          "cells_hi": [
            "Nanukaka travelled second class on a third-class ticket.",
            "नानूकाका ट्रैवल्ड सेकंड क्लास ऑन अ थर्ड-क्लास टिकट।",
            "नानूकाका ने तीसरे दर्जे के टिकट पर दूसरे दर्जे में सफ़र किया।"
          ],
          "cells_en": [
            "Nanukaka travelled second class on a third-class ticket.",
            "Naa-noo-kaa-kaa tra-vald se-kand klaas on a thard-klaas ti-ket.",
            "Shows his cheeky cleverness right away."
          ]
        },
        {
          "cells_hi": [
            "He wrote a cheque for a thousand rupees.",
            "ही रोट अ चेक फ़ॉर अ थाउज़ेंड रुपीज़।",
            "उन्होंने एक हज़ार रुपये का चेक लिखा।"
          ],
          "cells_en": [
            "He wrote a cheque for a thousand rupees.",
            "Hee rot a chek for a thau-zend ru-peez.",
            "Key prop in the Sikka Auto Dealers trick."
          ]
        },
        {
          "cells_hi": [
            "Hereditary Astrologer to the Maharaja of Ninnore.",
            "हेरेडिटरी ऐस्ट्रॉलजर टु द महाराजा ऑफ़ निन्नौर।",
            "निन्नौर के महाराजा का वंशानुगत राज-ज्योतिषी।"
          ],
          "cells_en": [
            "Hereditary Astrologer to the Maharaja of Ninnore.",
            "He-re-di-ta-ree as-tro-la-jar too the Ma-haa-raa-jaa ov Ni-nor.",
            "The brilliant fake title that lured the Minister!"
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Announcement** (*अनाउंसमेंट*) = घोषणा\n2. **Witty** (*विटी*) = हाज़िरजवाब / चतुर\n3. **Astrologer** (*ऐस्ट्रॉलजर*) = ज्योतिषी\n4. **Cheque** (*चेक*) = बैंक का चेक\n5. **Turban** (*टर्बन*) = पगड़ी\n6. **Linguistic** (*लिंग्विस्टिक*) = भाषाई (नानूकाका भाषाई संकट आने पर हमेशा मराठी बोलने लगते थे!)",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Announcement** (*अनाउंसमेंट*) = public news\n2. **Witty** (*विटी*) = quick-minded and funny\n3. **Astrologer** (*ऐस्ट्रॉलजर*) = reader of horoscopes\n4. **Cheque** (*चेक*) = bank payment order\n5. **Turban** (*टर्बन*) = wrapped headgear\n6. **Linguistic** (*लिंग्विस्टिक*) = related to language (Nanukaka always switched to his mother tongue **Marathi** during a linguistic emergency!)",
    "exam_tip_hi": "सुपर-हॉट BSEB Inter MCQ: नानूकाका को जब भी \"linguistic emergency (भाषाई संकट)\" होती, वे किस भाषा में बोलने लगते थे? → अपनी मातृभाषा **मराठी (His mother tongue)** में!",
    "exam_tip_en": "Guaranteed Inter MCQ: In a linguistic emergency, Nanukaka always turned to **his mother tongue (Marathi)**!",
    "glossary_terms": [
      {
        "term_hi": "Astrologer (ऐस्ट्रॉलजर)",
        "term_en": "Astrologer",
        "pronunciation_hi": "ऐस्ट्रॉलजर",
        "definition_hi": "कुंडली व ग्रह-नक्षत्र देखने वाला ज्योतिषी।",
        "definition_en": "A person who reads horoscopes and planetary signs."
      },
      {
        "term_hi": "Witty (विटी)",
        "term_en": "Witty",
        "pronunciation_hi": "विटी",
        "definition_hi": "अत्यंत चतुर, वाक्पटु और हाज़िरजवाब।",
        "definition_en": "Clever, sharp-minded, and amusing."
      }
    ]
  },
  {
    "id": "pos-sec-4-summary",
    "order": 4,
    "heading_hi": "4. नानूकाका का चरित्र-चित्रण व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Nanukaka's Character & 5-Mark Summary Formula",
    "analogy_hi": "परीक्षा में \"Character Sketch of Nanukaka\" आए या \"Summary of A Pinch of Snuff\" — नीचे के 5 मज़ेदार वाक्य दोनों सवालों में 5/5 अंक दिलाएँगे!",
    "analogy_en": "Whether BSEB asks for Nanukaka's Character Sketch or the Story Summary, these 5 crisp sentences earn 5/5!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "नानूकाका की 4 अनोखी विशेषताएँ (Character Sketch Key)",
      "title_en": "4 Defining Traits of Nanukaka",
      "headers_hi": [
        "गुण (Trait)",
        "कहानी से प्रमाण (Proof from Story)"
      ],
      "headers_en": [
        "Trait",
        "Proof from the Story"
      ],
      "rows": [
        {
          "cells_hi": [
            "1. हाज़िरजवाब व चतुर (Witty & Clever)",
            "तीसरे दर्जे के टिकट पर दूसरे दर्जे में सफ़र कर टिकट कलेक्टर को पटा लिया"
          ],
          "cells_en": [
            "1. Witty & Resourceful",
            "Travelled 2nd class on a 3rd-class ticket and charmed the TC"
          ]
        },
        {
          "cells_hi": [
            "2. शानदार अभिनेता (Master Actor)",
            "धोबी व ₹1,000 चेक का नाटक कर सिक्का ऑटो डीलर्स से बड़ी कार मुफ़्त ले ली"
          ],
          "cells_en": [
            "2. Master Dramatist",
            "Staged the dhobi & ₹1,000 cheque show at Sikka Auto Dealers"
          ]
        },
        {
          "cells_hi": [
            "3. मानव-स्वभाव का पारखी",
            "कल्याण मंत्री की कमज़ोरी (निन्नौर का रिश्ता) पकड़कर राज-ज्योतिषी का भेष धरा"
          ],
          "cells_en": [
            "3. Keen Judge of Human Nature",
            "Used the Ninnore royal marriage lure as \"Hereditary Astrologer\""
          ]
        },
        {
          "cells_hi": [
            "4. सुँघनी की आदत (Pinch of Snuff)",
            "हर मुश्किल परिस्थिति में एक चुटकी सुँघनी लेकर नई तरकीब निकाल लेते हैं"
          ],
          "cells_en": [
            "4. Trademark Snuff Habit",
            "Takes a pinch of snuff before inventing every brilliant trick"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"A Pinch of Snuff\"** is a hilarious comic story written by **Manohar Malgonkar**.\n2. The narrator's witty maternal uncle **Nanukaka** comes to Delhi for two or three days to meet a **Minister**.\n3. Taking his trademark **pinch of snuff**, Nanukaka outsmarts Party Boss **Sohanlal Ratiram** and discovers the **Welfare Minister's** marriage plans with the **Prince of Ninnore**.\n4. He stages a clever **dhobi and ₹1,000 cheque** stunt at **Sikka Auto Dealers** to borrow a grand car, dressing the narrator as his chauffeur.\n5. Signing the Minister's book as **\"Hereditary Astrologer to the Maharaja of Ninnore\"**, Nanukaka makes the Welfare Minister rush to his doorstep the very next morning!",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"A Pinch of Snuff\"** is a hilarious comic story written by **Manohar Malgonkar**.\n2. The narrator's witty maternal uncle **Nanukaka** comes to Delhi for two or three days to meet a **Minister**.\n3. Taking his trademark **pinch of snuff**, Nanukaka outsmarts Party Boss **Sohanlal Ratiram** and discovers the **Welfare Minister's** marriage plans with the **Prince of Ninnore**.\n4. He stages a clever **dhobi and ₹1,000 cheque** stunt at **Sikka Auto Dealers** to borrow a grand car, dressing the narrator as his chauffeur.\n5. Signing the Minister's book as **\"Hereditary Astrologer to the Maharaja of Ninnore\"**, Nanukaka makes the Welfare Minister rush to his doorstep the very next morning!",
    "exam_tip_hi": "कॉपी में **Manohar Malgonkar**, **Nanukaka**, **Sohanlal Ratiram**, **Sikka Auto Dealers**, और **Maharaja of Ninnore** अंडरलाइन करें!",
    "exam_tip_en": "Underline **Manohar Malgonkar**, **Nanukaka**, **Sohanlal Ratiram**, **Sikka Auto Dealers**, and **Ninnore**!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "नानूकाका ने कल्याण मंत्री के विज़िटर बुक में अपना क्या पद लिखा?",
      "q_en": "What title did Nanukaka write in the Welfare Minister's visitor's book?",
      "answer_hi": "**\"Hereditary Astrologer to the Maharaja of Ninnore\"** (निन्नौर के महाराजा का वंशानुगत ज्योतिषी)।",
      "answer_en": "**\"Hereditary Astrologer to the Maharaja of Ninnore\"**."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Author",
      "fact_hi": "मनोहर मालगाँवकर (1913–2010) · विधा: Comic Short Story",
      "fact_en": "Manohar Malgonkar (1913–2010) · Genre: Comic Short Story"
    },
    {
      "tag": "PYQ Facts",
      "fact_hi": "Maternal uncle · Kitten · 3rd-class ticket · ₹1,000 cheque · ₹2 tip · Ninnore",
      "fact_en": "Maternal uncle · Kitten · 3rd-class ticket · ₹1,000 cheque · ₹2 tip · Ninnore"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "A Pinch of Snuff is a funny short story by Manohar Malgonkar.",
      "fact_en": "A Pinch of Snuff is a funny short story by Manohar Malgonkar."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "Narrator's clever maternal uncle Nanukaka arrives in Delhi to see a Minister.",
      "fact_en": "Narrator's clever maternal uncle Nanukaka arrives in Delhi to see a Minister."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "Through Sohanlal Ratiram, he learns about the Welfare Minister and Ninnore.",
      "fact_en": "Through Sohanlal Ratiram, he learns about the Welfare Minister and Ninnore."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "Using a dhobi and ₹1,000 cheque trick at Sikka Auto Dealers, he borrows a luxury car.",
      "fact_en": "Using a dhobi and ₹1,000 cheque trick at Sikka Auto Dealers, he borrows a luxury car."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "Posing as Ninnore's Hereditary Astrologer, he makes the Minister visit him at home.",
      "fact_en": "Posing as Ninnore's Hereditary Astrologer, he makes the Minister visit him at home."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "नानूकाका को कथावाचक का \"चाचा (Paternal uncle)\" या \"पिता\" लिख देना।",
      "mistake_en": "Calling Nanukaka the narrator's father or paternal uncle.",
      "fix_hi": "नानूकाका माँ के भाई यानी **मामा (Maternal uncle)** हैं!",
      "fix_en": "Nanukaka is Mother's brother — the narrator's **maternal uncle**!"
    },
    {
      "mistake_hi": "टिकट और डिब्बे को उलट देना (\"2nd class ticket, 3rd class carriage\")।",
      "mistake_en": "Swapping the ticket class and carriage class.",
      "fix_hi": "सस्ता टिकट, महंगा डिब्बा: **3rd-class ticket** पर **2nd-class carriage** में सफ़र!",
      "fix_en": "Cheap ticket, better coach: **third-class ticket** in a **second-class carriage**!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "नानूकाका का चरित्र-चित्रण व ₹1,000 चेक का नाटक",
      "topic_en": "Character Sketch of Nanukaka & ₹1,000 Cheque Trick",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "स्टेशन आगमन, बिल्ली का बच्चा व निन्नौर ज्योतिषी भेष",
      "topic_en": "Station Arrival, Kitten & Ninnore Astrologer Disguise",
      "years": [
        "2022",
        "2024"
      ],
      "expected_marks": 2
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-12-eng-ch3',
  2,
  'छात्र "A Pinch of Snuff" की हास्य कथा और नानूकाका के तीनों मास्टरस्ट्रोक समझ सकेंगे, सभी PYQ संख्याएँ व नाम याद रख सकेंगे और 5-अंक सारांश/चरित्र-चित्रण लिख सकेंगे।',
  'Students will enjoy Malgonkar''s comic plot, recall every high-yield fact (maternal uncle, kitten, ₹1,000 cheque, Sikka Auto Dealers, Ninnore), and write a 5-mark summary.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "हास्य स्टोरी हुक, उच्चारण अभ्यास व 4-कदम मास्टरप्लान चार्ट",
    "phase_en": "Comedy Hook, Pronunciation & 4-Step Masterplan on Board",
    "teacher_action_hi": "छात्रों से पूछें: \"क्या आपके किसी रिश्तेदार के पास हर काम निकलवाने का गज़ब जुगाड़ है?\" फिर नानूकाका के स्टेशन आगमन और बिल्ली के बच्चे वाली मज़ेदार घटना सुनाएँ। Snuff (स्नफ़), Probation (प्रोबेशन), Chauffeur (शोफ़र), Astrologer (ऐस्ट्रॉलजर), Hereditary (हेरेडिटरी) का उच्चारण कराएँ।",
    "teacher_action_en": "Ask students about resourceful relatives. Narrate Nanukaka's station arrival with the kitten and 3rd-class ticket. Drill Snuff, Probation, Chauffeur, Astrologer, and Hereditary.",
    "student_check_hi": "पूछें: \"नानूकाका कथावाचक के क्या लगते थे और टोकरी में क्या लाए थे?\"",
    "student_check_en": "Ask: \"How was Nanukaka related to the narrator, and what was in the basket?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "धोबी चेक नाटक, 5-मिनट मौखिक गतिविधि व 5-अंक सारांश",
    "phase_en": "Dhobi Stunt Role-Play, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "सिक्का ऑटो डीलर्स का ₹1,000 चेक दृश्य और निन्नौर ज्योतिषी भेष समझाएँ। 5-मिनट मौखिक गतिविधि में कमजोर छात्र 5-वाक्य सारांश बोलें। अंत में 5 इंटर PYQ हल कराएँ।",
    "teacher_action_en": "Enact the Sikka Auto Dealers ₹1,000 cheque trick and Ninnore astrologer climax. Run a 5-min oral chain of the 5-sentence summary, then solve 5 Inter PYQs.",
    "student_check_hi": "पूछें: \"चेक कितने का था और धोबी को कितना इनाम मिला?\" (₹1,000 और ₹2)",
    "student_check_en": "Ask: \"What was the cheque amount and the dhobi's reward?\" (₹1,000 and ₹2)"
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड कॉमेडी बॉक्स (A Pinch of Snuff)",
    "heading_en": "Blackboard Comedy Box (A Pinch of Snuff)",
    "points_hi": [
      "लेखक: Manohar Malgonkar | नानूकाका = Maternal Uncle (मामा) | कथावाचक = Under-Secretary",
      "ट्रेन: 3rd-class ticket, 2nd-class carriage · टोकरी = Kitten · प्रवास = 2 or 3 days",
      "पार्टी बॉस: Sohanlal Ratiram · राजदूत: Hazrat Barkat Ali · कार: Sikka Auto Dealers (₹1,000 cheque + ₹2 tip)",
      "भेष: Hereditary Astrologer to the Maharaja of Ninnore → Welfare Minister खुद घर आए!"
    ],
    "points_en": [
      "Author: Manohar Malgonkar | Nanukaka = Maternal Uncle | Narrator = Under-Secretary",
      "Train: 3rd-class ticket in 2nd-class coach · Basket = Kitten · Stay = 2 or 3 days",
      "Party Boss: Sohanlal Ratiram · Ambassador: Hazrat Barkat Ali · Car: Sikka Auto Dealers (₹1,000 + ₹2)",
      "Disguise: Hereditary Astrologer to Maharaja of Ninnore -> Minister visits home!"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"सिक्का ऑटो डीलर्स\" लघु अभिनय",
    "title_en": "5-Minute \"Sikka Auto Dealers\" Mini-Skit",
    "materials_hi": "कागज़ का नकली ₹1,000 चेक और कोट",
    "materials_en": "Paper prop ₹1,000 cheque and jacket",
    "steps_hi": "तीन छात्र नानूकाका, धोबी और कार डीलर बनकर 4 सरल अंग्रेज़ी पंक्तियों में दृश्य निभाएँ। पूरी कक्षा हँसते-हँसते तथ्य याद कर लेगी!",
    "steps_en": "Three students play Nanukaka, Dhobi, and Car Dealer in 4 easy English lines so the whole class remembers the plot forever!"
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Snuff, Probation, Chauffeur, Astrologer और Hereditary को अर्थ व उच्चारण सहित लिखें।",
    "task_en": "Write Snuff, Probation, Chauffeur, Astrologer, and Hereditary with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "नानूकाका ने सिक्का ऑटो डीलर्स से बड़ी कार कैसे हासिल की? 3–4 वाक्यों में लिखें।",
    "task_en": "How did Nanukaka manage to get a grand car from Sikka Auto Dealers? Answer in 3–4 sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "नानूकाका का चरित्र-चित्रण या कहानी का 5-अंक सारांश स्वच्छ अंग्रेज़ी में लिखें।",
    "task_en": "Write a 5-mark summary or character sketch of Nanukaka neatly."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र सोचते हैं कि कथावाचक पहले से बड़ा मंत्री या आईएएस अधिकारी है।",
    "misconception_en": "Students assume the narrator is a senior minister.",
    "correction_hi": "स्पष्ट करें कि कथावाचक केवल **Under-Secretary on probation** है (मंत्री से बहुत छोटा पद)!",
    "correction_en": "Clarify the narrator is only an **Under-Secretary on probation**!"
  },
  {
    "misconception_hi": "छात्र \"Chauffeur\" का उच्चारण \"चौफ़र\" करते हैं।",
    "misconception_en": "Students mispronounce \"chauffeur\" as \"chow-fer\".",
    "correction_hi": "सही उच्चारण सिखाएँ: **शोफ़र (Chauffeur)** = निजी ड्राइवर!",
    "correction_en": "Teach the French-origin pronunciation: **शोफ़र**!"
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
  (
    '10000007-0008-4000-8000-000000000001', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Author & Relation', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'A Pinch of Snuff के लेखक कौन हैं और नानूकाका कथावाचक के क्या लगते थे?',
    'Who wrote "A Pinch of Snuff" and how was Nanukaka related to the narrator?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"A Pinch of Snuff\" के लेखक और नानूकाका का कथावाचक से रिश्ता बताएँ।",
  "front_en": "Name the author of \"A Pinch of Snuff\" and Nanukaka's relation to the narrator.",
  "back_hi": "लेखक: Manohar Malgonkar (1913–2010) · नानूकाका = कथावाचक के मामा (Maternal uncle)।",
  "back_en": "Author: Manohar Malgonkar (1913–2010) · Nanukaka = Narrator's maternal uncle.",
  "pronunciation_hi": "अ पिंच ऑफ़ स्नफ़ — मनोहर मालगाँवकर",
  "mnemonic_hi": "M से Malgonkar, M से Maternal uncle (मामा)!",
  "mnemonic_en": "Double-M hook: Malgonkar -> Maternal uncle!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000002', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Chauffeur और Hereditary का सही उच्चारण व अर्थ क्या है?',
    'Give the pronunciation and meaning of Chauffeur and Hereditary.',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Chauffeur और Hereditary का उच्चारण व हिंदी अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Chauffeur\" and \"Hereditary\".",
  "back_hi": "Chauffeur (शोफ़र) = निजी कार चालक · Hereditary (हेरेडिटरी) = वंशानुगत / पीढ़ी-दर-पीढ़ी।",
  "back_en": "Chauffeur (pronounced \"sho-far\") = private driver · Hereditary = passed down through family.",
  "pronunciation_hi": "शोफ़र · हेरेडिटरी",
  "mnemonic_hi": "कथावाचक बना Chauffeur (शोफ़र), नानूकाका बने Hereditary Astrologer!",
  "mnemonic_en": "Narrator played Chauffeur; Nanukaka played Hereditary Astrologer!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000003', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Story Props Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'कहानी की वस्तुओं व नामों को उनकी सही भूमिका से मिलाएँ:',
    'Match each story item in Column A with its exact role in Column B:',
    NULL, NULL,
    'टोकरी, ₹1,000 चेक, सोहनलाल रतिराम और निन्नौर को सही जोड़े में मिलाएँ।', 'Match kitten, ₹1,000 cheque, Sohanlal Ratiram, and Ninnore.',
    'टोकरी में बिल्ली का बच्चा, सिक्का ऑटो डीलर्स में ₹1,000 का चेक, सोहनलाल पार्टी बॉस, निन्नौर की राज-ज्योतिषी उपाधि।', 'Kitten in basket, ₹1,000 cheque at Sikka Auto Dealers, Sohanlal is Party Boss, Ninnore is the princely state.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each comic detail cleanly",
  "pairs": [
    {
      "id": "pos-m1",
      "left_hi": "Wicker Basket (टोकरी)",
      "left_en": "Wicker Basket",
      "right_hi": "जिसमें नानूकाका बिल्ली का बच्चा (Kitten) लाए",
      "right_en": "Carried a kitten from the train"
    },
    {
      "id": "pos-m2",
      "left_hi": "₹1,000 Cheque",
      "left_en": "₹1,000 Cheque",
      "right_hi": "सिक्का ऑटो डीलर्स में धोबी वाले नाटक का मुख्य औज़ार",
      "right_en": "Used in the dhobi stunt at Sikka Auto Dealers"
    },
    {
      "id": "pos-m3",
      "left_hi": "Sohanlal Ratiram",
      "left_en": "Sohanlal Ratiram",
      "right_hi": "दिल्ली के प्रभावशाली पार्टी बॉस",
      "right_en": "Influential Party Boss in Delhi"
    },
    {
      "id": "pos-m4",
      "left_hi": "Maharaja of Ninnore",
      "left_en": "Maharaja of Ninnore",
      "right_hi": "जिनका वंशानुगत ज्योतिषी नानूकाका बने",
      "right_en": "Ruler whose Hereditary Astrologer Nanukaka posed as"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000004', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही वाक्य सजाएँ: "नानूकाका किसी मंत्री से मिलने दिल्ली आए थे।"',
    'Build the sentence: "Nanukaka came to Delhi to see a minister"',
    NULL, NULL,
    'Past tense "came" + destination "to Delhi" + purpose "to see a minister"।', 'Nanukaka + came + to Delhi + to see a minister.',
    'सही वाक्य: "Nanukaka came to Delhi to see a minister"।', 'Correct sentence: "Nanukaka came to Delhi to see a minister".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "नानूकाका किसी मंत्री से मिलने दिल्ली आए थे।",
  "prompt_en": "Build this key plot sentence from A Pinch of Snuff",
  "grammar_formula": "Subject + V2 (came) + to Place + to + V1 + Object",
  "tokens": [
    "Nanukaka",
    "came",
    "to",
    "Delhi",
    "to",
    "see",
    "a",
    "minister"
  ],
  "distractors": [
    "comes",
    "saw"
  ],
  "correct_sentence": "Nanukaka came to Delhi to see a minister",
  "pronunciation_hi": "नानूकाका केम टु डेल्ही टु सी अ मिनिस्टर"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000005', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "नानूकाका ने एक हज़ार रुपये का चेक लिखा।"',
    'Build the sentence: "Nanukaka wrote a cheque for a thousand rupees"',
    NULL, NULL,
    'Past verb "wrote" + a cheque + for + a thousand rupees।', 'Use past verb "wrote" and preposition "for".',
    'सही वाक्य: "Nanukaka wrote a cheque for a thousand rupees"।', 'Correct sentence: "Nanukaka wrote a cheque for a thousand rupees".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "नानूकाका ने एक हज़ार रुपये का चेक लिखा।",
  "prompt_en": "Build the key dhobi-trick sentence for your summary",
  "grammar_formula": "Subject + V2 (wrote) + Object + for + Amount",
  "tokens": [
    "Nanukaka",
    "wrote",
    "a",
    "cheque",
    "for",
    "a",
    "thousand",
    "rupees"
  ],
  "distractors": [
    "write",
    "of"
  ],
  "correct_sentence": "Nanukaka wrote a cheque for a thousand rupees",
  "pronunciation_hi": "नानूकाका रोट अ चेक फ़ॉर अ थाउज़ेंड रुपीज़"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000006', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Maternal Uncle MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    'नानूकाका कथावाचक के क्या लगते थे?',
    'Nanukaka was the narrator''s:',
    $json$[{"key":"A","text_hi":"माँ के पिता (Grandfather)","text_en":"Grandfather"},{"key":"B","text_hi":"चचेरे भाई (Cousin)","text_en":"Cousin"},{"key":"C","text_hi":"चाचा (Paternal uncle)","text_en":"Paternal uncle"},{"key":"D","text_hi":"मामा (Maternal uncle)","text_en":"Maternal uncle"}]$json$::jsonb, 'D',
    'वे कथावाचक की माँ के भाई थे।', 'He was the narrator''s mother''s brother.',
    'नानूकाका कथावाचक के मामा (maternal uncle) थे।', 'Nanukaka was the narrator''s maternal uncle.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000007', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Kitten in Basket MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'नानूकाका स्टेशन पर टोकरी में कौन-सा जानवर लेकर आए थे?',
    'Which animal did Nanukaka bring in a basket at the railway station?',
    $json$[{"key":"A","text_hi":"पिल्ला (Puppy)","text_en":"A puppy"},{"key":"B","text_hi":"बिल्ली का बच्चा (Kitten)","text_en":"A kitten"},{"key":"C","text_hi":"तोता (Parrot)","text_en":"A parrot"},{"key":"D","text_hi":"खरगोश (Rabbit)","text_en":"A rabbit"}]$json$::jsonb, 'B',
    'टोकरी से धीमी "म्याऊँ" की आवाज़ आ रही थी!', 'A tiny furry feline kept in his wicker basket.',
    'नानूकाका बेंत की टोकरी में एक बिल्ली का बच्चा (kitten) लेकर आए थे।', 'Nanukaka brought a kitten inside a wicker basket.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000008', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Train Ticket MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'नानूकाका ने दूसरे दर्जे के डिब्बे में किस श्रेणी के टिकट पर यात्रा की थी?',
    'Nanukaka travelled in a second-class carriage on which class of ticket?',
    $json$[{"key":"A","text_hi":"तृतीय श्रेणी (Third-class)","text_en":"Third-class ticket"},{"key":"B","text_hi":"बिना टिकट (Ticketless)","text_en":"No ticket"},{"key":"C","text_hi":"प्रथम श्रेणी (First-class)","text_en":"First-class ticket"},{"key":"D","text_hi":"द्वितीय श्रेणी (Second-class)","text_en":"Second-class ticket"}]$json$::jsonb, 'A',
    'तीसरे दर्जे में जगह न होने का बहाना बनाकर दूसरे दर्जे में बैठ गए!', 'He bought the cheaper ticket and charmed the Ticket Collector!',
    'नानूकाका ने तीसरे दर्जे के टिकट (third-class ticket) पर दूसरे दर्जे में यात्रा की।', 'Nanukaka held a third-class ticket while riding second class.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000009', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Cheque Amount MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'नानूकाका ने सिक्का ऑटो डीलर्स को प्रभावित करने के लिए कितने रुपये का चेक लिखा था?',
    'For what amount did Nanukaka write a cheque to stage the dhobi trick at Sikka Auto Dealers?',
    $json$[{"key":"A","text_hi":"₹100","text_en":"100 rupees"},{"key":"B","text_hi":"₹500","text_en":"500 rupees"},{"key":"C","text_hi":"₹1,000","text_en":"1,000 rupees"},{"key":"D","text_hi":"₹10,000","text_en":"10,000 rupees"}]$json$::jsonb, 'C',
    'एक हज़ार रुपये का बेयरर चेक (और धोबी को ₹2 का इनाम)!', 'A thousand-rupee bearer cheque!',
    'नानूकाका ने ₹1,000 का चेक लिखा और धोबी को ₹2 इनाम दिया।', 'Nanukaka wrote a cheque for one thousand rupees.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000010', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Linguistic Emergency', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    'नानूकाका किसी "भाषाई संकट (linguistic emergency)" में हमेशा किस भाषा का सहारा लेते थे?',
    'Nanukaka had a linguistic emergency whenever he was excited and always turned to:',
    $json$[{"key":"A","text_hi":"फ़्रेंच (French)","text_en":"French"},{"key":"B","text_hi":"अंग्रेज़ी (English)","text_en":"English"},{"key":"C","text_hi":"संस्कृत (Sanskrit)","text_en":"Sanskrit"},{"key":"D","text_hi":"अपनी मातृभाषा (His mother tongue)","text_en":"His mother tongue"}]$json$::jsonb, 'D',
    'जोश या गुस्से में वे हमेशा अपनी मातृभाषा (मराठी) बोलने लगते थे।', 'He switched instantly into his native tongue (Marathi).',
    'भाषाई संकट में नानूकाका हमेशा अपनी मातृभाषा (his mother tongue — मराठी) में बोलने लगते थे।', 'In a linguistic emergency, Nanukaka always turned to his mother tongue.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000011', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Exam Pool: Narrator Post', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'कथावाचक दिल्ली में किस सरकारी पद पर कार्यरत था?',
    'What government post did the narrator hold in Delhi?',
    $json$[{"key":"A","text_hi":"अवर सचिव (Under-Secretary on probation)","text_en":"Under-Secretary on probation"},{"key":"B","text_hi":"राजदूत (Ambassador)","text_en":"Ambassador"},{"key":"C","text_hi":"कलेक्टर (Collector)","text_en":"Collector"},{"key":"D","text_hi":"कल्याण मंत्री","text_en":"Welfare Minister"}]$json$::jsonb, 'A',
    'परिवीक्षा अवधि (on probation) पर एक कनिष्ठ अधिकारी।', 'A junior civil servant on probation.',
    'कथावाचक दिल्ली में Under-Secretary on probation के पद पर था।', 'The narrator was an Under-Secretary on probation.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000012', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Exam Pool: Stay Duration', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2023',
    'माँ के अनुसार नानूकाका दिल्ली में कितने दिनों से अधिक नहीं रुकने वाले थे?',
    'According to the narrator''s mother, Nanukaka was coming to stay for:',
    $json$[{"key":"A","text_hi":"छह महीने","text_en":"Six months"},{"key":"B","text_hi":"दो या तीन दिन (Two or three days)","text_en":"Two or three days"},{"key":"C","text_hi":"एक महीना","text_en":"One month"},{"key":"D","text_hi":"दो सप्ताह","text_en":"Two weeks"}]$json$::jsonb, 'B',
    'माँ ने घबराए हुए बेटे को तसल्ली देते हुए बहुत कम दिन बताए थे।', 'Mother tried to reassure the anxious narrator with a very brief duration.',
    'माँ ने कहा कि नानूकाका केवल "दो या तीन दिन (two or three days)" के लिए आ रहे हैं।', 'Mother reassured the narrator that Nanukaka would stay only "two or three days".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000013', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Minister Visit Trick 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'नानूकाका ने कल्याण मंत्री को स्वयं अपने घर आने के लिए कैसे विवश कर दिया?',
    'How did Nanukaka manage to make the Welfare Minister come to his doorstep?',
    NULL, NULL,
    'ज्योतिषी का भेष, विज़िटर बुक में निन्नौर के महाराजा का नाम और कथावाचक का पता लिखें।', 'Mention astrologer disguise, signing as Hereditary Astrologer to Maharaja of Ninnore, and leaving narrator''s address.',
    NULL, NULL,
    'नानूकाका ने पता लगा लिया कि कल्याण मंत्री अपनी बेटी की शादी **निन्नौर के राजकुमार** से करना चाहते हैं। वे भव्य कार में ज्योतिषी का भेष धरकर मंत्री के घर गए और विज़िटर बुक में अपना नाम **"निन्नौर के महाराजा का वंशानुगत ज्योतिषी"** तथा पता अपने भांजे के घर का लिख आए। शाही रिश्ते की खबर सुनकर मंत्री खुद अगली सुबह उनसे मिलने दौड़े चले आए!', 'Learning that the Welfare Minister hoped to marry his daughter to the **Prince of Ninnore**, Nanukaka arrived at his house in a grand borrowed car dressed as a traditional astrologer. He signed the visitor''s book as **"Hereditary Astrologer to the Maharaja of Ninnore"** with the narrator''s address. Eager to please the royal astrologer, the Minister rushed to meet him the very next morning!',
    $json$[{"cue_hi":"निन्नौर के महाराजा का वंशानुगत ज्योतिषी","cue_en":"Hereditary Astrologer to Maharaja of Ninnore"},{"cue_hi":"विज़िटर बुक में भांजे का पता → मंत्री खुद घर आए","cue_en":"Left narrator's address -> Minister came himself"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"निन्नौर के राजकुमार व ज्योतिषी के भेष का उल्लेख","criterion_en":"Mentions Ninnore marriage link and astrologer disguise"},{"step_no":2,"marks":1,"criterion_hi":"विज़िटर बुक में पद व पता लिखने से मंत्री का घर आना","criterion_en":"Explains visitor's book signature bringing Minister to the house"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0008-4000-8000-000000000014', 'bseb-12-lang1-eng', 'bseb-12-eng-ch3', 'Summary & Character 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"A Pinch of Snuff" कहानी का सारांश लिखें और नानूकाका की चतुराई पर प्रकाश डालें।',
    'Write a summary of "A Pinch of Snuff" highlighting Nanukaka''s wit and cleverness.',
    NULL, NULL,
    'मामा नानूकाका, स्टेशन पर बिल्ली का बच्चा, सोहनलाल रतिराम, सिक्का ऑटो डीलर्स (₹1,000 चेक), और निन्नौर ज्योतिषी का अंत लिखें।', 'Cover maternal uncle Nanukaka, kitten/3rd-class ticket, Sohanlal, Sikka Auto Dealers ₹1,000 trick, and Ninnore climax.',
    NULL, NULL,
    '**"A Pinch of Snuff"** भारतीय अंग्रेज़ी लेखक **मनोहर मालगाँवकर** की अत्यंत मनोरंजक हास्य कहानी है। इसका मुख्य पात्र **नानूकाका** कथावाचक का बेहद चतुर और वाक्पटु मामा है, जो हर नई योजना से पहले **एक चुटकी सुँघनी** लेता है।

नानूकाका किसी मंत्री से मिलने दो-तीन दिन के लिए दिल्ली आते हैं। वे तीसरे दर्जे के टिकट पर दूसरे दर्जे के डिब्बे में सफ़र करते हैं और टोकरी में एक **बिल्ली का बच्चा** लेकर उतरते हैं। पहले वे पार्टी बॉस **सोहनलाल रतिराम** से राजदूत हज़रत बरकत अली का नाम उछालकर पता लगाते हैं कि **कल्याण मंत्री** अपनी बेटी की शादी **निन्नौर के राजकुमार** से करना चाहते हैं।

फिर **सिक्का ऑटो डीलर्स** में वे धोबी और **₹1,000 के चेक** का अद्भुत नाटक रचकर एक शानदार बड़ी कार मुफ़्त ले लेते हैं और भांजे को जोधपुरी कोट व नारंगी पगड़ी में ड्राइवर बनाते हैं। मंत्री की विज़िटर बुक में वे खुद को **"निन्नौर के महाराजा का वंशानुगत ज्योतिषी"** लिखकर आते हैं — और अगली ही सुबह कल्याण मंत्री खुद नानूकाका के दरवाज़े पर हाज़िर हो जाते हैं!', '**"A Pinch of Snuff"** is a witty, comic short story by **Manohar Malgonkar** starring the narrator''s super-clever maternal uncle, **Nanukaka**, who takes a pinch of snuff before every daring move.

Nanukaka arrives in Delhi for "two or three days" to meet a Minister, casually riding second class on a third-class ticket with a **kitten** in a basket. First, he impresses Delhi Party Boss **Sohanlal Ratiram** by dropping Ambassador **Hazrat Barkat Ali''s** name and discovers that the **Welfare Minister** plans to marry his daughter to the **Prince of Ninnore**.

Next, Nanukaka stages a hilarious **dhobi and ₹1,000 cheque** show at **Sikka Auto Dealers** to borrow a grand luxury car, dressing his nephew (an Under-Secretary) as a chauffeur in a Jodhpuri coat and orange turban. Signing the Minister''s visitor''s book as **"Hereditary Astrologer to the Maharaja of Ninnore"**, Nanukaka effortlessly lures the Welfare Minister to his very doorstep the next morning!',
    $json$[{"cue_hi":"Manohar Malgonkar · Maternal uncle Nanukaka","cue_en":"Manohar Malgonkar · Maternal uncle Nanukaka"},{"cue_hi":"3rd-class ticket + kitten · Sohanlal Ratiram","cue_en":"3rd-class ticket + kitten · Sohanlal Ratiram"},{"cue_hi":"Sikka Auto Dealers · Dhobi & ₹1,000 cheque","cue_en":"Sikka Auto Dealers · Dhobi & ₹1,000 cheque"},{"cue_hi":"Hereditary Astrologer of Ninnore -> Minister visits home","cue_en":"Hereditary Astrologer of Ninnore -> Minister visits home"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"लेखक (Manohar Malgonkar) व नानूकाका का परिचय","criterion_en":"Names Malgonkar and introduces witty maternal uncle Nanukaka"},{"step_no":2,"marks":1.5,"criterion_hi":"ट्रेन आगमन (टिकट/बिल्ली) व सोहनलाल रतिराम प्रसंग","criterion_en":"Covers train arrival and Sohanlal Ratiram episode"},{"step_no":3,"marks":1.5,"criterion_hi":"सिक्का ऑटो डीलर्स में धोबी व ₹1,000 चेक का नाटक","criterion_en":"Describes Sikka Auto Dealers dhobi & ₹1,000 cheque stunt"},{"step_no":4,"marks":1,"criterion_hi":"निन्नौर ज्योतिषी भेष व कल्याण मंत्री के घर आने का अंत","criterion_en":"Concludes with Ninnore astrologer trick and Minister's visit"}]$json$::jsonb,
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
-- CHAPTER 9 OF 14: BSEB-12-ENG-CH4 — Sweetest Love, I Do Not Goe (Poem) — John Donne
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-12-eng-ch4',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: Sweetest Love, I Do Not Goe",
  "title_en": "30-Second Mindmap: Sweetest Love, I Do Not Goe",
  "read_time_seconds": 30,
  "central_node": {
    "id": "sl-root",
    "label_hi": "Sweetest Love, I Do Not Goe",
    "label_en": "Sweetest Love, I Do Not Goe (Poem)",
    "subtitle_hi": "John Donne (1572–1631) · Metaphysical Poet · Rainbow Part-2",
    "subtitle_en": "John Donne (1572–1631) · Metaphysical Poet · Rainbow Part-2"
  },
  "branches": [
    {
      "id": "sl-poet",
      "label_hi": "1. कवि: जॉन डन (John Donne)",
      "label_en": "1. Poet: John Donne",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "sl-p1",
          "label_hi": "जन्म: 1572 (लंदन, रोमन कैथोलिक परिवार) · निधन: 1631",
          "label_en": "Born: 1572 (London, Roman Catholic family) · Died: 1631"
        },
        {
          "id": "sl-p2",
          "label_hi": "आध्यात्मिक कविता (Metaphysical Poetry) के जनक (Pioneer)",
          "label_en": "Pioneer of Metaphysical Poetry"
        },
        {
          "id": "sl-p3",
          "label_hi": "पत्नी: ऐन मोर (Anne More) — यूरोप यात्रा से पूर्व यह कविता लिखी",
          "label_en": "Wife: Anne More — written before his journey to Europe"
        }
      ]
    },
    {
      "id": "sl-sun",
      "label_hi": "2. सूर्य का अद्भुत तर्क (Sun Conceit)",
      "label_en": "2. The Sun Metaphysical Conceit",
      "color": "#D97706",
      "children": [
        {
          "id": "sl-s1",
          "label_hi": "कल रात सूर्य चला गया था, फिर भी आज वापस आ गया — जबकि न उसमें इच्छा है न बुद्धि!",
          "label_en": "Yesterday night the sun left yet returned today — without desire or sense!"
        },
        {
          "id": "sl-s2",
          "label_hi": "कवि के पास प्रेम के अधिक पंख और प्रेरणा (more wings and spurs) हैं → वह सूर्य से भी तेज़ लौटेगा!",
          "label_en": "Poet has more wings & spurs (love) -> will make speedier journeys than the sun!"
        }
      ]
    },
    {
      "id": "sl-power",
      "label_hi": "3. मानव की दुर्बलता व आँसुओं की पीड़ा",
      "label_en": "3. Human Frailty & Pain of Sighs/Tears",
      "color": "#059669",
      "children": [
        {
          "id": "sl-w1",
          "label_hi": "\"O how feeble is man's power!\" — मनुष्य एक अच्छा घंटा भी नहीं जोड़ सकता!",
          "label_en": "\"O how feeble is man's power!\" — cannot add one hour to good fortune!"
        },
        {
          "id": "sl-w2",
          "label_hi": "पत्नी की आहों से कवि की आत्मा निकलती है और आँसुओं से जीवन-रक्त सूखता है!",
          "label_en": "Her sighs take his soul away; her tears decay his life's blood!"
        }
      ]
    },
    {
      "id": "sl-union",
      "label_hi": "4. अमर प्रेम का निष्कर्ष",
      "label_en": "4. Immortal Love & Board Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "sl-u1",
          "label_hi": "जो एक-दूसरे को हृदय में जीवित रखते हैं, वे कभी अलग नहीं होते (ne'er parted bee)!",
          "label_en": "Those who keep each other alive in heart are never parted!"
        },
        {
          "id": "sl-u2",
          "label_hi": "पक्के MCQ: Metaphysical poet, Anne More, Oxford, Sun conceit, Feeble power।",
          "label_en": "Top MCQs: Metaphysical poet, Anne More, Oxford, Sun conceit, Feeble power."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "sl-sec-1-poet",
    "order": 1,
    "heading_hi": "1. कवि परिचय (Metaphysical Poet) और दैनिक जीवन से जुड़ाव",
    "heading_en": "1. Poet Profile & Emotional Connection",
    "analogy_hi": "सोचिए जब घर से कोई पिता या बड़ा भाई नौकरी के लिए दूसरे शहर जाता है, तो परिवार की आँखों में आँसू आ जाते हैं — तब जाने वाला मुस्कुराकर कहता है *\"रो मत, मैं तुमसे ऊबकर नहीं जा रहा! देखो सूरज भी रोज़ शाम को जाता है और सुबह लौट आता है — मैं तो उससे भी जल्दी लौटूँगा!\"* ठीक यही कोमल और तार्किक ढांढस **जॉन डन** ने अपनी पत्नी **ऐन मोर** को **Sweetest Love, I Do Not Goe** में दिया है!",
    "analogy_en": "When someone leaves home for a long journey, loved ones weep — so the traveller smiles and reassures them: *\"Even the sun leaves every evening and returns by morning; because I love you, I will return even faster!\"* That is the exact heartfelt logic of **John Donne** to his wife **Anne More**!",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "जॉन डन (John Donne) — जीवन व साहित्य की मुख्य तिथियाँ",
      "title_en": "John Donne — Key Biographical Milestones",
      "events": [
        {
          "year": "1572",
          "title_hi": "जन्म — लंदन (रोमन कैथोलिक परिवार)",
          "title_en": "Born — London (Roman Catholic family)",
          "detail_hi": "कैथोलिक होने के कारण उन्हें बिना डिग्री ऑक्सफोर्ड विश्वविद्यालय छोड़ना पड़ा।",
          "detail_en": "Forced to leave Oxford University without a degree because of his religion."
        },
        {
          "year": "1601",
          "title_hi": "ऐन मोर (Anne More) से गुप्त विवाह",
          "title_en": "Secret Marriage to Anne More",
          "detail_hi": "अपने संरक्षक की भतीजी से गुप्त विवाह करने पर थोड़े समय के लिए जेल जाना पड़ा!",
          "detail_en": "Briefly sent to prison for secretly marrying his patron's niece, Anne More!",
          "highlight": true
        },
        {
          "year": "1611",
          "title_hi": "यूरोप यात्रा से पूर्व \"Sweetest Love, I Do Not Goe\"",
          "title_en": "Wrote \"Sweetest Love, I Do Not Goe\" Before Europe Trip",
          "detail_hi": "मेटाफ़िज़िकल प्रेम-कविता का सर्वोत्तम उदाहरण।",
          "detail_en": "Masterpiece of Metaphysical love poetry comforting his wife.",
          "highlight": true
        },
        {
          "year": "1615–1631",
          "title_hi": "एंग्लिकन चर्च के महान उपदेशक",
          "title_en": "Preacher & Dean of St. Paul's",
          "detail_hi": "1615 में 42 वर्ष की आयु में ऑर्डिनेशन स्वीकार किया; 1631 में निधन।",
          "detail_en": "Accepted ordination in the Anglican Church at age 42; died in 1631."
        }
      ]
    },
    "concept_md_hi": "### मेटाफ़िज़िकल कविता (Metaphysical Poetry) क्या है?\n- **जॉन डन** को **मेटाफ़िज़िकल कविता का जनक (pioneer of Metaphysical poetry)** कहा जाता है।\n- **विशेषता:** मेटाफ़िज़िकल कवि केवल फूल-चाँद की साधारण बातें नहीं करते, बल्कि **तर्क (wit), विज्ञान, खगोलशास्त्र (सूर्य की गति) और गहरे दार्शनिक विचारों** से प्रेम को समझाते हैं!\n- **पुरानी अंग्रेज़ी वर्तनी (Old English Spelling):** डन ने 17वीं सदी की वर्तनी लिखी है — `goe = go`, `Sunne = Sun`, `mee = me`, `thee = you`, `thou = you`, `hath = has`, `bee = be`। इससे घबराना नहीं है!",
    "concept_md_en": "### What is Metaphysical Poetry?\n- **John Donne** is the **pioneer of Metaphysical poetry**.\n- **Style:** Metaphysical poems blend deep emotion with sharp **intellectual wit**, astronomy (the sun's orbit), and philosophical conceits.\n- **Old English Spellings Made Easy:** `goe = go`, `Sunne = Sun`, `mee = me`, `thee/thou = you`, `hath = has`, `bee = be`.",
    "exam_tip_hi": "BSEB इंटर के 4 पक्के MCQ: Pioneer of Metaphysical poetry = **John Donne** · बिना डिग्री छोड़ा विश्वविद्यालय = **Oxford** · पत्नी = **Anne More** · जेल क्यों गए? → **अपनी संरक्षक की भतीजी से गुप्त विवाह के कारण**!",
    "exam_tip_en": "4 Guaranteed Inter MCQs: Metaphysical pioneer = **John Donne** · Left **Oxford** without a degree · Wife = **Anne More** · Imprisoned for marrying his patron's niece!",
    "glossary_terms": [
      {
        "term_hi": "Metaphysical (मेटाफ़िज़िकल)",
        "term_en": "Metaphysical",
        "pronunciation_hi": "मेटाफ़िज़िकल",
        "definition_hi": "आध्यात्मिक व बौद्धिक तर्क-प्रधान काव्य शैली, जिसके जनक जॉन डन हैं।",
        "definition_en": "Intellectually witty, philosophical poetry pioneered by John Donne."
      },
      {
        "term_hi": "Wearinesse (वियरीनेस)",
        "term_en": "Wearinesse",
        "pronunciation_hi": "वियरीनेस",
        "definition_hi": "थकान या किसी से ऊब जाना (कवि पत्नी से ऊबकर नहीं जा रहा)।",
        "definition_en": "Tiredness or boredom (old spelling of \"weariness\")."
      }
    ]
  },
  {
    "id": "sl-sec-2-stanzas",
    "order": 2,
    "heading_hi": "2. विज़ुअल स्टोरीबोर्ड: कविता के सभी 5 पद (Stanza-by-Stanza)",
    "heading_en": "2. Visual Breakdown: All 5 Stanzas in Simple Steps",
    "analogy_hi": "पूरी कविता एक प्यारी बातचीत के 5 छोटे चरणों में बँटी है — हर पद में कवि अपनी पत्नी के एक-एक डर को प्यार और तर्क से दूर करते हैं!",
    "analogy_en": "The 5 stanzas form one tender conversation — each stanza gently removes one fear from his wife's heart!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "Sweetest Love, I Do Not Goe — सभी 5 पदों का भावार्थ",
      "title_en": "All 5 Stanzas of Sweetest Love, I Do Not Goe",
      "direction": "TB",
      "steps": [
        {
          "id": "sl-s1",
          "label_hi": "पद 1: ऊबकर नहीं, मृत्यु के अभ्यास हेतु यात्रा",
          "label_en": "Stanza 1: Not Out of Weariness, Only Practising Parting",
          "detail_hi": "मैं तुमसे ऊबकर या किसी बेहतर प्रेम की तलाश में नहीं जा रहा — बल्कि एक दिन मृत्यु हम सबको अलग करेगी, इसलिए थोड़े समय का वियोग हँसकर सहने का अभ्यास कर रहा हूँ।",
          "detail_en": "Not weary of thee nor seeking a fitter love — simply rehearsing inevitable death through gentle temporary parting.",
          "accent": "indigo"
        },
        {
          "id": "sl-s2",
          "label_hi": "पद 2: सूर्य से भी तेज़ वापसी का वादा (Sun Conceit)",
          "label_en": "Stanza 2: Faster Return Than the Sun",
          "detail_hi": "कल रात सूर्य डूब गया, फिर भी आज लौट आया — जबकि उसमें न प्रेम है न इच्छा! मेरे पास तो तुमसे मिलने की तीव्र इच्छा (wings and spurs) है, मैं सूर्य से तेज़ लौटूँगा!",
          "detail_en": "The sun returned despite having neither desire nor sense; driven by love's wings and spurs, I shall return much faster!",
          "accent": "amber"
        },
        {
          "id": "sl-s3",
          "label_hi": "पद 3: मनुष्य की शक्ति कितनी दुर्बल है (Feeble Power)",
          "label_en": "Stanza 3: How Feeble is Man's Power!",
          "detail_hi": "अच्छा समय आए तो इंसान एक घंटा बढ़ा नहीं सकता और बीता समय लौटा नहीं सकता; पर बुरे समय से डरने के बजाय साहस से सामना करना चाहिए।",
          "detail_en": "Man cannot add one hour to good fortune nor recall a lost hour; we must not surrender helplessly to bad luck.",
          "accent": "slate"
        },
        {
          "id": "sl-s4",
          "label_hi": "पद 4: आह मत भरो, आँसू मत बहाओ!",
          "label_en": "Stanza 4: Do Not Sigh or Weep",
          "detail_hi": "जब तुम आह भरती हो तो हवा नहीं, मेरी आत्मा निकाल लेती हो; जब तुम रोती हो तो मेरे जीवन का रक्त सूखने लगता है!",
          "detail_en": "Your sighs draw away my soul, and your tears decay my life's blood — do not waste my life in grief!",
          "accent": "emerald"
        },
        {
          "id": "sl-s5",
          "label_hi": "पद 5: सच्चे प्रेमी कभी अलग नहीं होते!",
          "label_en": "Stanza 5: True Lovers Are Never Parted",
          "detail_hi": "मन में कोई बुरा शक न लाओ; समझो हम एक ही बिस्तर पर बस करवट बदलकर सोए हैं — जो एक-दूसरे को हृदय में जीवित रखते हैं, वे कभी बिछड़ते नहीं!",
          "detail_en": "Forethink no ill; imagine we merely turned aside in sleep — those who keep each other alive in heart are never parted!",
          "accent": "indigo"
        }
      ],
      "edges": [
        {
          "from": "sl-s1",
          "to": "sl-s2"
        },
        {
          "from": "sl-s2",
          "to": "sl-s3"
        },
        {
          "from": "sl-s3",
          "to": "sl-s4"
        },
        {
          "from": "sl-s4",
          "to": "sl-s5"
        }
      ]
    },
    "concept_md_hi": "### सबसे ज़रूरी परीक्षा बिंदु\n- **कवि अपनी तुलना सूर्य से क्यों करते हैं?** क्योंकि सूर्य के पास न **इच्छा (desire)** है, न **संवेदना (sense)**, और उसका रास्ता भी बहुत लंबा है — फिर भी वह रोज़ लौट आता है। कवि के पास अपनी पत्नी का प्रेम रूपी **पंख और एड़ (wings and spurs)** हैं, इसलिए उनकी वापसी सूर्य से भी तेज़ होगी!\n- **मनुष्य की शक्ति कैसी है?** अत्यंत **दुर्बल (feeble)** — वह सौभाग्य में एक अतिरिक्त घंटा नहीं जोड़ सकता।\n- **अंतिम अमर संदेश:** *\"They who one another keepe / Alive, ne'er parted bee.\"* — सच्चा प्रेम दूरी या मृत्यु से परे है।",
    "concept_md_en": "### Key Exam Takeaways\n- **Why compare himself to the Sun?** The sun has neither **desire** nor **sense** and travels a vast path, yet returns daily. With love giving him **more wings and spurs**, the poet will return far faster!\n- **How is man's power described?** Extremely **feeble** — helpless to add one hour to good fortune or recall a lost hour.\n- **Immortal Conclusion:** *\"They who one another keepe / Alive, ne'er parted bee.\"* — true spiritual love defeats distance.",
    "exam_tip_hi": "हर साल आने वाला Inter MCQ: सूर्य के पास क्या नहीं है? → **Desire nor sense**! और मनुष्य की शक्ति कैसी है? → **Feeble (कमज़ोर)**!",
    "exam_tip_en": "Guaranteed Inter MCQs: The sun has neither **desire nor sense**; man's power is **feeble**!",
    "glossary_terms": [
      {
        "term_hi": "Feeble (फ़ीबल)",
        "term_en": "Feeble",
        "pronunciation_hi": "फ़ीबल",
        "definition_hi": "अत्यंत कमज़ोर या दुर्बल (O how feeble is man's power!)।",
        "definition_en": "Very weak or powerless."
      },
      {
        "term_hi": "Spurs (स्पर्ज़)",
        "term_en": "Spurs",
        "pronunciation_hi": "स्पर्ज़",
        "definition_hi": "तेज़ गति देने वाली प्रेरणा (प्रेम कवि को सूर्य से तेज़ लौटने की प्रेरणा देता है)।",
        "definition_en": "Strong incentives or motives driving faster movement."
      }
    ],
    "quick_check": {
      "q_hi": "कवि क्यों दावा करते हैं कि वे सूर्य से भी तेज़ यात्रा कर लौटेंगे?",
      "q_en": "Why does John Donne claim he will make speedier journeys than the sun?",
      "answer_hi": "क्योंकि सूर्य में इच्छा और बुद्धि नहीं है, जबकि कवि के पास प्रेम के अधिक **पंख और प्रेरणा (more wings and spurs)** हैं।",
      "answer_en": "Because unlike the sun, the poet has desire, sense, and **more wings and spurs** (love for his wife)."
    }
  },
  {
    "id": "sl-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य काव्य पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key Poem Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "पुरानी अंग्रेज़ी स्पेलिंग देखकर मत घबराइए! नीचे चारों सबसे ज़्यादा पूछी जाने वाली पंक्तियों का आसान उच्चारण व हिंदी अर्थ दिया है।",
    "analogy_en": "Don't fear 17th-century spellings! Read these 4 heavily tested lines aloud with our simple guide.",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "Sweetest Love, I Do Not Goe — 4 सर्वाधिक पूछी गई पंक्तियाँ",
      "title_en": "4 Most Tested Lines from John Donne's Poem",
      "headers_hi": [
        "काव्य पंक्ति (Original Line)",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "Poem Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "Sweetest love, I do not goe, for wearinesse of thee.",
            "स्वीटेस्ट लव, आई डू नॉट गो, फ़ॉर वियरीनेस ऑफ़ दी।",
            "प्रियतमा, मैं तुमसे ऊबकर नहीं जा रहा हूँ।"
          ],
          "cells_en": [
            "Sweetest love, I do not goe, for wearinesse of thee.",
            "Swee-test lav, aai doo not go, for wi-ya-ree-nes ov thee.",
            "Reassures his wife that love is undiminished."
          ]
        },
        {
          "cells_hi": [
            "Yesternight the Sunne went hence, and yet is here to day.",
            "येस्टरनाइट द सन वेंट हेंस, ऐंड येट इज़ हियर टुडे।",
            "कल रात सूर्य यहाँ से गया था, फिर भी आज लौट आया है।"
          ],
          "cells_en": [
            "Yesternight the Sunne went hence, and yet is here to day.",
            "Yes-tar-naait the san went hens, and yet iz hi-yar too-de.",
            "Famous Metaphysical sun conceit."
          ]
        },
        {
          "cells_hi": [
            "O how feeble is mans power, that if good fortune fall, cannot adde another houre.",
            "ओ हाउ फ़ीबल इज़ मैन्स पावर, दैट इफ़ गुड फ़ॉर्च्यून फ़ॉल, कैनॉट ऐड अनदर आवर।",
            "ओह, मनुष्य की शक्ति कितनी दुर्बल है — अच्छा वक्त आने पर वह एक घंटा भी नहीं बढ़ा सकता!"
          ],
          "cells_en": [
            "O how feeble is mans power...",
            "O hau fee-bal iz manz paa-war...",
            "Classic 4-mark Explanation line on human helplessness."
          ]
        },
        {
          "cells_hi": [
            "They who one another keepe alive, ne'er parted bee.",
            "दे हू वन अनदर कीप अलाइव, नेवर पार्टेड बी।",
            "जो एक-दूसरे को हृदय में जीवित रखते हैं, वे कभी जुदा नहीं होते।"
          ],
          "cells_en": [
            "They who one another keepe alive, ne'er parted bee.",
            "The hoo wan a-na-dar keep a-laaiv, ne-var paar-ted bee.",
            "Immortal closing couplet on true love."
          ]
        }
      ]
    },
    "concept_md_hi": "### पुरानी अंग्रेज़ी → आधुनिक अंग्रेज़ी शब्दकोश\n1. **Goe** (*गो*) = Go\n2. **Thee / Thou** (*दी / दाउ*) = You (तुम)\n3. **Yesternight** (*येस्टरनाइट*) = Last night (कल रात)\n4. **Hath** (*हैथ*) = Has\n5. **Feeble** (*फ़ीबल*) = Weak (कमज़ोर)\n6. **Divining** (*डिवाइनिंग*) = Predicting / Sensing future (पूर्वाभास करने वाला)",
    "concept_md_en": "### 17th-Century to Modern English Key\n1. **Goe** (*गो*) = Go\n2. **Thee / Thou** (*दी / दाउ*) = You\n3. **Yesternight** (*येस्टरनाइट*) = Last night\n4. **Hath** (*हैथ*) = Has\n5. **Feeble** (*फ़ीबल*) = Weak\n6. **Divining** (*डिवाइनिंग*) = Foreseeing / predicting",
    "exam_tip_hi": "4-अंक Explanation में \"O how feeble is man's power\" लगभग हर दूसरे साल आता है — इसे अभी से पक्का याद कर लें!",
    "exam_tip_en": "\"O how feeble is man's power\" is one of the highest-frequency 4-mark Explanation lines in BSEB Class 12!",
    "glossary_terms": [
      {
        "term_hi": "Yesternight (येस्टरनाइट)",
        "term_en": "Yesternight",
        "pronunciation_hi": "येस्टरनाइट",
        "definition_hi": "बीती हुई कल की रात (Last night)।",
        "definition_en": "Last night (poetic archaic term)."
      },
      {
        "term_hi": "Divining (डिवाइनिंग)",
        "term_en": "Divining",
        "pronunciation_hi": "डिवाइनिंग",
        "definition_hi": "भविष्य की अनहोनी का पूर्वाभास करने वाला हृदय।",
        "definition_en": "Prophetic; sensing future events in advance."
      }
    ]
  },
  {
    "id": "sl-sec-4-summary",
    "order": 4,
    "heading_hi": "4. सूर्य बनाम कवि तुलना व 5-अंक कविता सारांश फ़ॉर्मूला",
    "heading_en": "4. Sun vs Poet Table & 5-Mark Summary Formula",
    "analogy_hi": "बस नीचे की तुलना तालिका और 5 आसान वाक्य याद कर लें — बिहार बोर्ड इंटर के 5-अंक कविता सारांश में 5/5 अंक सुनिश्चित हैं!",
    "analogy_en": "Master the Sun vs Poet comparison and 5-sentence formula for an easy 5/5 in Class 12 Poetry!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "सूर्य (The Sun) बनाम कवि (John Donne) — मेटाफ़िज़िकल तर्क",
      "title_en": "The Sun vs The Poet (Donne's Metaphysical Conceit)",
      "headers_hi": [
        "गुण (Feature)",
        "सूर्य (The Sunne)",
        "कवि (John Donne)"
      ],
      "headers_en": [
        "Feature",
        "The Sun",
        "The Poet (Donne)"
      ],
      "rows": [
        {
          "cells_hi": [
            "इच्छा और बुद्धि",
            "न इच्छा (desire) है, न संवेदना (sense)",
            "पत्नी के प्रति गहरा प्रेम, इच्छा व चेतना है"
          ],
          "cells_en": [
            "Desire & Sense",
            "Has neither desire nor sense",
            "Has deep love, desire, and awareness"
          ]
        },
        {
          "cells_hi": [
            "यात्रा का मार्ग",
            "संपूर्ण आकाश का लंबा मार्ग",
            "पृथ्वी पर अपेक्षाकृत छोटा मार्ग"
          ],
          "cells_en": [
            "Journey Path",
            "Vast cosmic path across the sky",
            "Much shorter earthly journey"
          ]
        },
        {
          "cells_hi": [
            "वापसी की गति",
            "रोज़ सुबह निश्चित लौटता है",
            "प्रेम के पंखों (wings & spurs) से सूर्य से भी तेज़ लौटेगा!"
          ],
          "cells_en": [
            "Speed of Return",
            "Returns reliably every morning",
            "Will return faster with love's wings and spurs!"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"Sweetest Love, I Do Not Goe\"** is a famous **Metaphysical love poem** written by **John Donne**.\n2. He wrote it to comfort his beloved wife **Anne More** before leaving on a journey to continental Europe.\n3. He assures her that he is not tired of her; just as the **sun** returns daily without desire or sense, he will return even **faster** with love's **wings and spurs**.\n4. He reminds her how **feeble man's power** is, and begs her not to sigh or weep because her grief hurts his soul and life's blood.\n5. Finally, he says that **true lovers who keep each other alive in their hearts are never truly parted**.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"Sweetest Love, I Do Not Goe\"** is a famous **Metaphysical love poem** written by **John Donne**.\n2. He wrote it to comfort his beloved wife **Anne More** before leaving on a journey to continental Europe.\n3. He assures her that he is not tired of her; just as the **sun** returns daily without desire or sense, he will return even **faster** with love's **wings and spurs**.\n4. He reminds her how **feeble man's power** is, and begs her not to sigh or weep because her grief hurts his soul and life's blood.\n5. Finally, he says that **true lovers who keep each other alive in their hearts are never truly parted**.",
    "exam_tip_hi": "कॉपी में **John Donne**, **Metaphysical**, **Anne More**, **Sun**, और **Never parted** अंडरलाइन करें!",
    "exam_tip_en": "Underline **John Donne**, **Metaphysical**, **Anne More**, **Sun**, and **Never parted**!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "पत्नी के रोने (weeping) और आह भरने (sighing) का कवि पर क्या असर होता है?",
      "q_en": "How do the beloved's sighs and tears affect the poet?",
      "answer_hi": "आह भरने से कवि की **आत्मा (soul)** निकल जाती है और रोने से उसका **जीवन-रक्त (life's blood)** सूखता है।",
      "answer_en": "Her sighs take his **soul** away, and her tears decay his **life's blood**."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Poet",
      "fact_hi": "जॉन डन (1572–1631) · Pioneer of Metaphysical Poetry · पत्नी: Anne More",
      "fact_en": "John Donne (1572–1631) · Pioneer of Metaphysical Poetry · Wife: Anne More"
    },
    {
      "tag": "Key Quote",
      "fact_hi": "\"O how feeble is man's power!\" · \"They who one another keepe alive, ne'er parted bee.\"",
      "fact_en": "\"O how feeble is man's power!\" · \"They who one another keepe alive, ne'er parted bee.\""
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Sweetest Love, I Do Not Goe is a Metaphysical love lyric by John Donne.",
      "fact_en": "Sweetest Love, I Do Not Goe is a Metaphysical love lyric by John Donne."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "Written to comfort his wife Anne More before his European journey.",
      "fact_en": "Written to comfort his wife Anne More before his European journey."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "He promises to return faster than the sun using love's wings and spurs.",
      "fact_en": "He promises to return faster than the sun using love's wings and spurs."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "He notes man's feeble power and begs her not to sigh or weep away his soul.",
      "fact_en": "He notes man's feeble power and begs her not to sigh or weep away his soul."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "He concludes that true lovers who keep each other alive in heart never part.",
      "fact_en": "He concludes that true lovers who keep each other alive in heart never part."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "जॉन डन को \"Romantic poet\" या \"War poet\" लिख देना।",
      "mistake_en": "Calling John Donne a Romantic or War poet.",
      "fix_hi": "हमेशा याद रखें: **John Donne = Metaphysical Poet** (और Rupert Brooke = War Poet)!",
      "fix_en": "Keep distinct: **John Donne = Metaphysical Poet** (Rupert Brooke = War Poet)!"
    },
    {
      "mistake_hi": "यह लिख देना कि कवि अपनी पत्नी से नाराज़ होकर या ऊबकर जा रहे हैं।",
      "mistake_en": "Saying the poet is leaving because he is weary of his wife.",
      "fix_hi": "कवि पहली ही पंक्ति में कहते हैं: *\"I do **not** goe for wearinesse of thee\"*!",
      "fix_en": "Line 1–2 explicitly say: *\"I do **not** goe for wearinesse of thee\"*!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "सूर्य से तुलना (Metaphysical Conceit) व वापसी का विश्वास",
      "topic_en": "Comparison with the Sun & Faster Return",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    },
    {
      "topic_hi": "\"O how feeble is man's power\" व कविता का 5-अंक सारांश",
      "topic_en": "\"O How Feeble is Man's Power\" & Poem Summary",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-12-eng-ch4',
  2,
  'छात्र जॉन डन की मेटाफ़िज़िकल शैली व पुरानी अंग्रेज़ी वर्तनी को सहजता से पढ़ सकेंगे, सूर्य-तर्क व 5 पदों का भावार्थ समझ सकेंगे और इंटर 5-अंक सारांश व 4-अंक व्याख्या लिख सकेंगे।',
  'Students will decode Donne''s 17th-century spellings and Metaphysical sun conceit, explain all 5 stanzas clearly, and write strong 4M/5M board answers.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "विदाई-संवाद हुक, पुरानी वर्तनी की कुंजी व उच्चारण अभ्यास",
    "phase_en": "Parting Hook, Old-Spelling Key & Pronunciation Drill",
    "teacher_action_hi": "सबसे पहले छात्रों का पुरानी स्पेलिंग का डर दूर करें — बोर्ड पर लिखें: goe=go, Sunne=Sun, mee=me, thee=you! फिर ऐन मोर और यूरोप यात्रा की कहानी सुनाएँ। Metaphysical (मेटाफ़िज़िकल), Wearinesse (वियरीनेस), Feeble (फ़ीबल), Yesternight (येस्टरनाइट) का उच्चारण कराएँ।",
    "teacher_action_en": "Remove fear of old spellings right away (`goe=go`, `Sunne=Sun`, `thee=you`). Share the story of Anne More and the Europe trip. Drill Metaphysical, Wearinesse, Feeble, and Yesternight.",
    "student_check_hi": "पूछें: \"John Donne किस काव्यधारा के जनक हैं?\" (Metaphysical poetry)",
    "student_check_en": "Ask: \"John Donne is the pioneer of which poetry?\" (Metaphysical poetry)"
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "सूर्य-तर्क, 4-अंक व्याख्या, 5-मिनट मौखिक गतिविधि व सारांश",
    "phase_en": "Sun Conceit, 4-Mark Explanation, 5-Min Oral Drill & Summary",
    "teacher_action_hi": "बोर्ड पर \"Sun vs Poet\" तालिका बनाएँ और \"O how feeble is man's power\" की व्याख्या सिखाएँ। 5-मिनट मौखिक गतिविधि में 5 छात्र 5-वाक्य सारांश बोलें। अंत में 5 इंटर PYQ हल करें।",
    "teacher_action_en": "Draw the Sun vs Poet contrast and model the 4-mark explanation of \"O how feeble is man's power\". Run a 5-min oral summary relay, closing with 5 Inter PYQs.",
    "student_check_hi": "पूछें: \"कवि ने क्यों कहा कि वे सूर्य से तेज़ लौटेंगे?\"",
    "student_check_en": "Ask: \"Why does the poet promise a speedier journey than the sun?\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड कविता बॉक्स (Sweetest Love, I Do Not Goe)",
    "heading_en": "Blackboard Poem Box (John Donne)",
    "points_hi": [
      "कवि: John Donne (1572–1631) · Pioneer of Metaphysical Poetry · पत्नी: Anne More",
      "पुरानी वर्तनी: goe = go · Sunne = Sun · thee/thou = you · hath = has · bee = be",
      "तर्क: सूर्य में न desire है न sense — मेरे पास प्रेम के wings & spurs हैं!",
      "अमर पंक्तियाँ: \"O how feeble is man's power!\" · \"They who one another keepe alive, ne'er parted bee.\""
    ],
    "points_en": [
      "Poet: John Donne (1572–1631) · Pioneer of Metaphysical Poetry · Wife: Anne More",
      "Old Spelling: goe = go · Sunne = Sun · thee/thou = you · hath = has",
      "Sun Conceit: Sun has no desire/sense -> Poet has more wings & spurs (love)",
      "Key Lines: \"O how feeble is man's power!\" · \"Never parted be\""
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"पुरानी से नई अंग्रेज़ी\" त्वरित खेल",
    "title_en": "5-Minute \"Old-to-Modern English\" Rapid Game",
    "materials_hi": "बोर्ड पर 6 शब्द: goe, Sunne, mee, thee, hath, yesternight",
    "materials_en": "6 archaic words on board: goe, Sunne, mee, thee, hath, yesternight",
    "steps_hi": "शिक्षक पुराना शब्द बोलें और कमजोर छात्र तुरंत आधुनिक अंग्रेज़ी शब्द बोलें — 2 मिनट में कविता का सारा डर गायब!",
    "steps_en": "Teacher reads each archaic word; shy students call out its modern equivalent — eliminating fear of classic poetry!"
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Metaphysical, Feeble, Weariness, Yesternight और Fortune के अर्थ व उच्चारण 3 बार लिखें।",
    "task_en": "Write Metaphysical, Feeble, Weariness, Yesternight, and Fortune 3 times with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "\"O how feeble is man's power\" की 4-अंक संदर्भ सहित व्याख्या लिखें।",
    "task_en": "Write a 4-mark explanation of \"O how feeble is man's power\"."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "\"Sweetest Love, I Do Not Goe\" का 5-अंक सारांश बिना देखे लिखें।",
    "task_en": "Write the 5-mark summary of \"Sweetest Love, I Do Not Goe\" neatly."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र पुरानी वर्तनी \"Goe\" और \"Sunne\" को प्रिंटिंग की गलती समझ लेते हैं।",
    "misconception_en": "Students assume \"Goe\" and \"Sunne\" are misprints.",
    "correction_hi": "बताएँ कि 17वीं सदी (1600s) की अंग्रेज़ी में यही असली स्पेलिंग थी, इसलिए शीर्षक में \"Goe\" ही लिखें!",
    "correction_en": "Explain these are authentic 17th-century spellings — keep \"Goe\" intact in the title!"
  },
  {
    "misconception_hi": "छात्र सोचते हैं कि कवि सच में मरने वाले हैं।",
    "misconception_en": "Students think the poet is literally dying.",
    "correction_hi": "स्पष्ट करें कि कवि केवल यूरोप की यात्रा पर जा रहे हैं और अस्थायी विदाई को भविष्य की मृत्यु का हँसमुख अभ्यास (\"feigned death\") कहते हैं।",
    "correction_en": "Clarify Donne is merely leaving on a trip to Europe, calling temporary parting a gentle rehearsal for death."
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
  (
    '10000007-0009-4000-8000-000000000001', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Poet & Movement', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'John Donne किस काव्यधारा के जनक हैं और उनकी पत्नी का नाम क्या था?',
    'John Donne pioneered which poetry, and who was his beloved wife?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "John Donne (1572–1631) किस काव्यधारा के जनक हैं और यह कविता किसके लिए लिखी?",
  "front_en": "Which poetic movement did John Donne pioneer, and whom did he address in this poem?",
  "back_hi": "काव्यधारा: Metaphysical Poetry (मेटाफ़िज़िकल कविता) · पत्नी: Anne More (यूरोप यात्रा से पूर्व)।",
  "back_en": "Movement: Metaphysical Poetry · Addressed to his wife Anne More before his Europe trip.",
  "pronunciation_hi": "जॉन डन — मेटाफ़िज़िकल पोएट",
  "mnemonic_hi": "Donne = Metaphysical Poet · Wife = Anne More!",
  "mnemonic_en": "Donne = Pioneer of Metaphysical Poetry · Wife = Anne More!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000002', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Feeble और Yesternight का उच्चारण व अर्थ क्या है?',
    'Give the pronunciation and meaning of Feeble and Yesternight.',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Feeble और Yesternight शब्दों का उच्चारण व हिंदी अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Feeble\" and \"Yesternight\".",
  "back_hi": "Feeble (फ़ीबल) = अत्यंत कमज़ोर / दुर्बल · Yesternight (येस्टरनाइट) = कल की बीती रात (Last night)।",
  "back_en": "Feeble = very weak · Yesternight = last night.",
  "pronunciation_hi": "फ़ीबल · येस्टरनाइट",
  "mnemonic_hi": "मनुष्य की शक्ति = Feeble (कमज़ोर)!",
  "mnemonic_en": "Remember the line: \"O how feeble is man's power!\""
}$json$::jsonb,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000003', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Old English & Images Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'कविता के शब्दों/प्रतीकों को उनके सही अर्थ से मिलाएँ:',
    'Match each term/image from Donne''s poem in Column A with Column B:',
    NULL, NULL,
    'Metaphysical, Sun, Feeble और Anne More को सही जोड़े से मिलाएँ।', 'Match Metaphysical, Sun, Feeble, and Anne More.',
    'John Donne = Metaphysical poet, Sun = बिना इच्छा के भी लौटता है, Man''s power = Feeble, Anne More = कवि की पत्नी।', 'Donne -> Metaphysical poet, Sun -> lacks desire & sense, Man''s power -> feeble, Anne More -> poet''s wife.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each element from the poem",
  "pairs": [
    {
      "id": "sl-m1",
      "left_hi": "John Donne",
      "left_en": "John Donne",
      "right_hi": "मेटाफ़िज़िकल कविता के जनक",
      "right_en": "Pioneer of Metaphysical poetry"
    },
    {
      "id": "sl-m2",
      "left_hi": "The Sunne (सूर्य)",
      "left_en": "The Sunne",
      "right_hi": "न इच्छा है न बुद्धि, फिर भी रोज़ लौटता है",
      "right_en": "Has neither desire nor sense, yet returns daily"
    },
    {
      "id": "sl-m3",
      "left_hi": "Man's power",
      "left_en": "Man's power",
      "right_hi": "अत्यंत दुर्बल (Feeble)",
      "right_en": "Extremely feeble and helpless"
    },
    {
      "id": "sl-m4",
      "left_hi": "Anne More",
      "left_en": "Anne More",
      "right_hi": "कवि की प्रिय पत्नी जिसके लिए यह कविता लिखी",
      "right_en": "The poet's beloved wife addressed in the lyric"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000004', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही वाक्य सजाएँ: "जॉन डन एक मेटाफ़िज़िकल कवि हैं।"',
    'Build the exam fact sentence: "John Donne is a metaphysical poet"',
    NULL, NULL,
    'Subject + is + a + metaphysical + poet।', 'John Donne + is + a + metaphysical + poet.',
    'सही वाक्य: "John Donne is a metaphysical poet"।', 'Correct sentence: "John Donne is a metaphysical poet".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "जॉन डन एक मेटाफ़िज़िकल कवि हैं।",
  "prompt_en": "Build the opening sentence for your 5-mark summary",
  "grammar_formula": "Subject + is + a + Adjective + Noun",
  "tokens": [
    "John",
    "Donne",
    "is",
    "a",
    "metaphysical",
    "poet"
  ],
  "distractors": [
    "are",
    "an"
  ],
  "correct_sentence": "John Donne is a metaphysical poet",
  "pronunciation_hi": "जॉन डन इज़ अ मेटाफ़िज़िकल पोएट"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000005', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'कविता का मुख्य संदेश सजाएँ: "सच्चे प्रेमी कभी एक-दूसरे से अलग नहीं होते।"',
    'Build the closing theme: "True lovers are never parted from each other"',
    NULL, NULL,
    'Plural subject "True lovers" के साथ "are" + never parted + from each other।', 'True lovers + are + never + parted + from + each + other.',
    'सही वाक्य: "True lovers are never parted from each other"।', 'Correct sentence: "True lovers are never parted from each other".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "सच्चे प्रेमी कभी एक-दूसरे से अलग नहीं होते।",
  "prompt_en": "Build the immortal closing message of Donne's lyric",
  "grammar_formula": "Plural Subject + are + never + V3 + from + each other",
  "tokens": [
    "True",
    "lovers",
    "are",
    "never",
    "parted",
    "from",
    "each",
    "other"
  ],
  "distractors": [
    "is",
    "part"
  ],
  "correct_sentence": "True lovers are never parted from each other",
  "pronunciation_hi": "ट्रू लवर्स आर नेवर पार्टेड फ़्रॉम ईच अदर"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000006', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Metaphysical Poet MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    'जॉन डन (John Donne) किस प्रकार के कवि के रूप में प्रसिद्ध हैं?',
    'John Donne is celebrated as a pioneer of which kind of poetry?',
    $json$[{"key":"A","text_hi":"मेटाफ़िज़िकल कवि (Metaphysical poetry)","text_en":"Metaphysical poetry"},{"key":"B","text_hi":"युद्ध कवि (War poetry)","text_en":"War poetry"},{"key":"C","text_hi":"बाल कवि (Children's poetry)","text_en":"Children's poetry"},{"key":"D","text_hi":"प्रकृति कवि (Nature poet)","text_en":"Nature poetry"}]$json$::jsonb, 'A',
    'तर्क, बुद्धि और गहरे दार्शनिक रूपकों की कविता!', 'Intellectually witty, philosophical love lyrics!',
    'जॉन डन मेटाफ़िज़िकल कविता (Metaphysical poetry) के जनक हैं।', 'John Donne is renowned as the pioneer of Metaphysical poetry.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000007', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Feeble Power MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    'कविता की पंक्ति पूरी करें: "O how ___ is man''s power!"',
    'Complete the famous line from the poem: "O how ___ is man''s power!"',
    $json$[{"key":"A","text_hi":"fast (तेज़)","text_en":"fast"},{"key":"B","text_hi":"strong (शक्तिशाली)","text_en":"strong"},{"key":"C","text_hi":"feeble (दुर्बल)","text_en":"feeble"},{"key":"D","text_hi":"great (महान)","text_en":"great"}]$json$::jsonb, 'C',
    'मनुष्य सौभाग्य का एक घंटा भी नहीं बढ़ा सकता।', 'Man cannot add even one extra hour to good fortune.',
    'सही पंक्ति है: "O how feeble is man''s power!" (मनुष्य की शक्ति कितनी दुर्बल है)।', 'The exact line is: "O how feeble is man''s power!"',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000008', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Sun Conceit MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'जॉन डन के अनुसार सूर्य के पास कौन-सी दो चीज़ें नहीं हैं?',
    'According to John Donne, the sun has neither ___ nor ___.',
    $json$[{"key":"A","text_hi":"प्रकाश और ताप (Light nor heat)","text_en":"Light nor heat"},{"key":"B","text_hi":"इच्छा और संवेदना (Desire nor sense)","text_en":"Desire nor sense"},{"key":"C","text_hi":"मार्ग और समय (Way nor time)","text_en":"Way nor time"},{"key":"D","text_hi":"शक्ति और गति (Power nor speed)","text_en":"Power nor speed"}]$json$::jsonb, 'B',
    'पंक्ति: "He hath no ___ nor ___."', 'Complete: "He hath no ___ nor ___."',
    'कवि लिखते हैं कि सूर्य में न इच्छा (desire) है और न संवेदना (sense), फिर भी वह लौट आता है।', 'Donne writes: "He hath no desire nor sense."',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000009', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Oxford Leaving MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    'जॉन डन को किस कारण बिना डिग्री के ऑक्सफोर्ड विश्वविद्यालय छोड़ना पड़ा था?',
    'Why was John Donne forced to leave Oxford University without a degree?',
    $json$[{"key":"A","text_hi":"बीमारी के कारण","text_en":"Because of illness"},{"key":"B","text_hi":"विदेश यात्रा के कारण","text_en":"Because of foreign travel"},{"key":"C","text_hi":"गरीबी के कारण","text_en":"Because of poverty"},{"key":"D","text_hi":"उनके धर्म (रोमन कैथोलिक होने) के कारण","text_en":"Because of his religion (Roman Catholic)"}]$json$::jsonb, 'D',
    'उस समय इंग्लैंड प्रोटेस्टेंट-विरोधी/कैथोलिक-विरोधी था।', 'England was strongly anti-Catholic at the time.',
    'रोमन कैथोलिक धर्म के कारण जॉन डन को बिना डिग्री ऑक्सफोर्ड छोड़ना पड़ा।', 'Donne was forced to leave Oxford without a degree because of his Roman Catholic faith.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000010', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Sighs and Tears Imagery', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    'कवि के अनुसार जब उसकी प्रियतमा रोती (weeps) है, तो किस चीज़ का क्षय (decay) होता है?',
    'According to John Donne, when his beloved weeps, what decays?',
    $json$[{"key":"A","text_hi":"उसके जीवन का रक्त (His life's blood)","text_en":"His life's blood"},{"key":"B","text_hi":"उसकी यात्रा (His journey)","text_en":"His journey"},{"key":"C","text_hi":"सूर्य का प्रकाश (The sunlight)","text_en":"The sunlight"},{"key":"D","text_hi":"उसका धन (His wealth)","text_en":"His wealth"}]$json$::jsonb, 'A',
    'पंक्ति याद करें: "When thou weep''st, unkindly kinde, / My ___ doth decay."', 'Recall: "When thou weep''st, unkindly kinde, / My ___ doth decay."',
    'कवि कहते हैं कि प्रियतमा की आहों से उनकी आत्मा जाती है और आँसुओं से उनके जीवन का रक्त (life''s blood) सूखता है।', 'Donne writes that her tears cause his "life''s blood" to decay.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000011', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Exam Pool: Wife Name', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'जॉन डन ने "Sweetest Love, I Do Not Goe" कविता अपनी किस प्रिय पत्नी को संबोधित की है?',
    'To whom did John Donne address "Sweetest Love, I Do Not Goe"?',
    $json$[{"key":"A","text_hi":"मैरी (Mary)","text_en":"Mary"},{"key":"B","text_hi":"ऐन मोर (Anne More)","text_en":"Anne More"},{"key":"C","text_hi":"लॉरा (Laura)","text_en":"Laura"},{"key":"D","text_hi":"एलिज़ाबेथ (Elizabeth)","text_en":"Elizabeth"}]$json$::jsonb, 'B',
    'उनके संरक्षक की भतीजी जिनसे उन्होंने गुप्त विवाह किया था।', 'His patron''s niece whom he secretly married.',
    'यह कविता उन्होंने अपनी पत्नी ऐन मोर (Anne More) को सांत्वना देने के लिए लिखी।', 'John Donne wrote this lyric to comfort his wife, Anne More.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000012', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Exam Pool: Faster Than Sun', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2023',
    'कवि सूर्य से तेज़ लौटने के लिए किन दो चीज़ों का सहारा लेने की बात करते हैं?',
    'What two things does the poet take more of than the sun to make speedier journeys?',
    $json$[{"key":"A","text_hi":"सोना और चाँदी (Gold and silver)","text_en":"Gold and silver"},{"key":"B","text_hi":"घोड़े और रथ (Horses and chariots)","text_en":"Horses and chariots"},{"key":"C","text_hi":"पंख और एड़ / प्रेरणा (Wings and spurs)","text_en":"Wings and spurs"},{"key":"D","text_hi":"नाव और पतवार (Boats and oars)","text_en":"Boats and oars"}]$json$::jsonb, 'C',
    'पंक्ति: "since I take / More ___ and ___ then hee."', 'Line: "since I take / More ___ and ___ then hee."',
    'कवि कहते हैं कि वे सूर्य से अधिक "wings and spurs" (प्रेम के पंख और प्रेरणा) लेकर चलते हैं।', 'Donne promises speedier journeys because he takes "more wings and spurs" than the sun.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000013', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Why Poet Leaves 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'जॉन डन अपनी पत्नी से अलग होकर यात्रा पर क्यों जाना चाहते हैं?',
    'Why does John Donne want to go away from his beloved?',
    NULL, NULL,
    'ऊबकर नहीं, बल्कि भविष्य की अवश्यंभावी मृत्यु के वियोग का अभ्यास करने के लिए।', 'Not out of weariness, but to practise for eventual separation by death.',
    NULL, NULL,
    'जॉन डन अपनी पत्नी से **ऊबकर (weariness)** या किसी बेहतर प्रेम की तलाश में नहीं जा रहे हैं। वे कहते हैं कि एक दिन मृत्यु सभी को अलग करेगी, इसलिए वे कुछ समय की अस्थायी जुदाई से **मृत्यु के अंतिम वियोग का हँसकर अभ्यास** करना चाहते हैं।', 'John Donne is **not** leaving out of weariness or to find a fitter love. Since death must inevitably part all lovers someday, he wants to rehearse that final separation gently through temporary partings ("by feigned deaths to die").',
    $json$[{"cue_hi":"ऊबकर या बेहतर प्रेम के लिए नहीं","cue_en":"Not for weariness or fitter love"},{"cue_hi":"अस्थायी विदाई = मृत्यु के वियोग का अभ्यास","cue_en":"Temporary parting = rehearsal for death"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"यह स्पष्ट करना कि वे ऊबकर या दूसरे प्रेम के लिए नहीं जा रहे","criterion_en":"Clarifies he is not weary nor seeking a fitter love"},{"step_no":2,"marks":1,"criterion_hi":"मृत्यु के अनिवार्य वियोग का अभ्यास करने का तर्क","criterion_en":"Explains rehearsing inevitable separation by death"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0009-4000-8000-000000000014', 'bseb-12-lang1-eng', 'bseb-12-eng-ch4', 'Poem Summary 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"Sweetest Love, I Do Not Goe" कविता का सारांश लिखें।',
    'Write a summary of John Donne''s poem "Sweetest Love, I Do Not Goe".',
    NULL, NULL,
    'मेटाफ़िज़िकल कवि, ऐन मोर, सूर्य-तर्क (wings & spurs), मनुष्य की दुर्बल शक्ति, आहें-आँसू और अमर मिलन लिखें।', 'Cover Metaphysical poet, Anne More, sun conceit, feeble power, sighs/tears, and never parted.',
    NULL, NULL,
    '**"Sweetest Love, I Do Not Goe"** मेटाफ़िज़िकल कविता के जनक **जॉन डन** की प्रसिद्ध प्रेम-कविता है। उन्होंने यह गीत यूरोप यात्रा पर जाते समय अपनी प्रिय पत्नी **ऐन मोर** को ढांढस बँधाने के लिए लिखा।

कवि पत्नी को विश्वास दिलाते हैं कि वे उनसे ऊबकर या किसी अन्य प्रेम की आशा में नहीं जा रहे, बल्कि अस्थायी जुदाई से भविष्य की मृत्यु का अभ्यास कर रहे हैं। वे **सूर्य** का अद्भुत तर्क देते हैं कि जब बिना इच्छा और संवेदना वाला सूर्य कल रात जाकर आज लौट आया, तो प्रेम के **पंखों और प्रेरणा (wings and spurs)** से भरे कवि तो उससे भी तेज़ लौटेंगे।

कवि याद दिलाते हैं कि **मनुष्य की शक्ति अत्यंत दुर्बल (feeble)** है। वे पत्नी से निवेदन करते हैं कि वे आहें न भरें और न रोएँ, क्योंकि इससे कवि की आत्मा व जीवन-रक्त क्षीण होता है। अंत में वे अमर संदेश देते हैं कि **जो एक-दूसरे को अपने हृदय में जीवित रखते हैं, वे कभी अलग नहीं होते**।', '**"Sweetest Love, I Do Not Goe"** is a celebrated **Metaphysical love lyric** composed by **John Donne** to console his wife **Anne More** before his journey to Europe.

Donne reassures her that he does not leave out of weariness or hope of a fitter love, but simply to practise gently for death''s inevitable parting. Using a brilliant conceit of the **sun**, he argues that if the sun—having neither desire nor sense—left last night and returned today, he will make **speedier journeys** driven by love''s **wings and spurs**.

He reflects on how **feeble man''s power** is to extend good fortune, and urges his wife not to sigh away his soul or weep away his life''s blood. In the touching finale, he comforts her that **true lovers who keep each other alive in their hearts are never truly parted**.',
    $json$[{"cue_hi":"John Donne · Metaphysical Poet · Anne More","cue_en":"John Donne · Metaphysical Poet · Anne More"},{"cue_hi":"Sun conceit -> speedier return (wings & spurs)","cue_en":"Sun conceit -> speedier return (wings & spurs)"},{"cue_hi":"Feeble man's power · Sighs & tears hurt soul/blood","cue_en":"Feeble man's power · Sighs & tears hurt soul/blood"},{"cue_hi":"True lovers keeping each other alive never part","cue_en":"True lovers keeping each other alive never part"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"कवि (John Donne), मेटाफ़िज़िकल शैली व पत्नी (Anne More)","criterion_en":"Names John Donne, Metaphysical style, and Anne More"},{"step_no":2,"marks":1.5,"criterion_hi":"सूर्य से तुलना व प्रेम के पंख-प्रेरणा (wings and spurs)","criterion_en":"Explains sun conceit and speedier return"},{"step_no":3,"marks":1.5,"criterion_hi":"मनुष्य की दुर्बल शक्ति व आहों-आँसुओं की पीड़ा","criterion_en":"Mentions feeble human power and impact of sighs/tears"},{"step_no":4,"marks":1,"criterion_hi":"सच्चे प्रेमियों के कभी अलग न होने का निष्कर्ष","criterion_en":"Concludes with spiritual unity (\"never parted\")"}]$json$::jsonb,
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
-- CHAPTER 10 OF 14: BSEB-12-ENG-CH5 — An Epitaph (Poem) — Walter de la Mare
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-12-eng-ch5',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: एक समाधि-लेख (An Epitaph)",
  "title_en": "30-Second Mindmap: An Epitaph",
  "read_time_seconds": 30,
  "central_node": {
    "id": "epi-root",
    "label_hi": "An Epitaph (समाधि-लेख)",
    "label_en": "An Epitaph (Short Lyric)",
    "subtitle_hi": "Walter de la Mare (1873–1956) · Rainbow Part-2 (Poetry)",
    "subtitle_en": "Walter de la Mare (1873–1956) · Rainbow Part-2 (Poetry)"
  },
  "branches": [
    {
      "id": "epi-poet",
      "label_hi": "1. कवि: वाल्टर डी ला मेयर",
      "label_en": "1. Poet: Walter de la Mare",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "epi-p1",
          "label_hi": "जन्म: 1873 (चार्लटन, केंट, इंग्लैंड) · निधन: 1956",
          "label_en": "Born: 1873 (Charlton, Kent, England) · Died: 1956"
        },
        {
          "id": "epi-p2",
          "label_hi": "\"बच्चों के कवि (Children's Poet)\" — Songs for Children, Peacock Pie",
          "label_en": "Known as \"Children's Poet\" — Songs for Children, Peacock Pie"
        },
        {
          "id": "epi-p3",
          "label_hi": "महारानी एलिज़ाबेथ द्वितीय ने 1953 में \"Order of Merit\" से सम्मानित किया!",
          "label_en": "Honoured by Queen Elizabeth II with the Order of Merit (1953)!"
        }
      ]
    },
    {
      "id": "epi-lady",
      "label_hi": "2. वेस्ट कंट्री की सुंदर स्त्री",
      "label_en": "2. The Lady of the West Country",
      "color": "#059669",
      "children": [
        {
          "id": "epi-l1",
          "label_hi": "वेस्ट कंट्री (West Country) की सबसे सुंदर स्त्री कब्र में लेटी है",
          "label_en": "The most beautiful lady ever born in the West Country lies here"
        },
        {
          "id": "epi-l2",
          "label_hi": "\"Light of step and heart was she\" — चंचल, मुक्त व अस्थिर स्वभाव",
          "label_en": "\"Light of step and heart was she\" — carefree, moving without commitment"
        }
      ]
    },
    {
      "id": "epi-truth",
      "label_hi": "3. जीवन का कटु सत्य (Transience)",
      "label_en": "3. Bitter Truth of Mortality",
      "color": "#D97706",
      "children": [
        {
          "id": "epi-t1",
          "label_hi": "\"But beauty vanishes; beauty passes; / However rare—rare it be\"",
          "label_en": "\"But beauty vanishes; beauty passes; / However rare—rare it be\""
        },
        {
          "id": "epi-t2",
          "label_hi": "बाहरी सौंदर्य कितना भी दुर्लभ क्यों न हो, मृत्यु के साथ मिट जाता है!",
          "label_en": "Physical beauty, however rare, is short-lived and mortal!"
        }
      ]
    },
    {
      "id": "epi-sorrow",
      "label_hi": "4. कवि की अंतिम चिंता (\"Crumble\")",
      "label_en": "4. Poet's Lament & Board Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "epi-s1",
          "label_hi": "\"And when I crumble, who will remember?\" — Crumble का अर्थ है \"मृत्यु होना (to die)\"!",
          "label_en": "\"And when I crumble, who will remember?\" — \"Crumble\" means to die!"
        },
        {
          "id": "epi-s2",
          "label_hi": "पक्के MCQ: Order of Merit (1953), West Country, Children's Poet, Crumble = die।",
          "label_en": "Top MCQs: Order of Merit (1953), West Country, Children's Poet, Crumble = die."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "epi-sec-1-poet",
    "order": 1,
    "heading_hi": "1. कवि परिचय और \"समाधि-लेख (Epitaph)\" का सरल अर्थ",
    "heading_en": "1. Poet Profile & Meaning of \"An Epitaph\"",
    "analogy_hi": "सोचिए एक बहुत सुंदर गुलाब का फूल सुबह खिलता है — सब उसकी तारीफ़ करते हैं, पर शाम होते-होते उसकी पंखुड़ियाँ झड़ जाती हैं और अगले दिन कोई उसे याद नहीं रखता! **वाल्टर डी ला मेयर** एक कब्र पर खुदे **समाधि-लेख (Epitaph)** के पास खड़े होकर यही गहरा दार्शनिक सच सुनाते हैं: **बाहरी सौंदर्य अस्थायी है, केवल अच्छे कर्म और प्रेम ही याद रहते हैं!**",
    "analogy_en": "A breathtaking rose blooms at dawn, admired by all — yet by dusk its petals fade and no one remembers it tomorrow! Standing beside a gravestone (**epitaph**), **Walter de la Mare** teaches that **physical beauty is transient, fading swiftly after death**.",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "वाल्टर डी ला मेयर — जीवन व सम्मान (BSEB Inter High-Yield)",
      "title_en": "Walter de la Mare — Life & Honours",
      "events": [
        {
          "year": "1873",
          "title_hi": "जन्म — चार्लटन, केंट (इंग्लैंड)",
          "title_en": "Born — Charlton, Kent (England)",
          "detail_hi": "4 वर्ष की आयु में पिता को खो दिया और लंदन में पले-बढ़े।",
          "detail_en": "Lost his father at age four and moved with his family to London."
        },
        {
          "year": "1902–1913",
          "title_hi": "\"Songs for Children\" व \"Peacock Pie\"",
          "title_en": "\"Songs for Children\" & \"Peacock Pie\"",
          "detail_hi": "अद्भुत बाल-कविताओं के कारण \"Children's Poet\" कहलाए।",
          "detail_en": "Earned lifelong fame as the \"Children's Poet\".",
          "highlight": true
        },
        {
          "year": "1953",
          "title_hi": "महारानी एलिज़ाबेथ द्वितीय द्वारा \"Order of Merit\"",
          "title_en": "Order of Merit by Queen Elizabeth II",
          "detail_hi": "बिहार बोर्ड इंटर में हर साल पूछा जाने वाला पक्का ऑब्जेक्टिव प्रश्न!",
          "detail_en": "One of the most repeated BSEB Class 12 MCQs!",
          "highlight": true
        },
        {
          "year": "1956",
          "title_hi": "निधन (83 वर्ष की आयु में)",
          "title_en": "Passed Away (Age 83)",
          "detail_hi": "अपनी शांत, उदास और कल्पनाशील कविताओं के लिए अमर।",
          "detail_en": "Remembered forever for his wistful, haunting lyrics."
        }
      ]
    },
    "concept_md_hi": "### \"Epitaph\" क्या होता है?\n- **Epitaph (एपिटैफ़):** किसी दिवंगत व्यक्ति की स्मृति में उसकी **कब्र या समाधि-पत्थर (tomb / gravestone)** पर खुदे हुए शब्दों को *Epitaph (समाधि-लेख)* कहते हैं।\n- **कविता का भाव (Tone):** यह कविता केवल 7–8 छोटी पंक्तियों की है, पर इसका स्वर अत्यंत **उदास और विचारशील (melancholic & philosophical)** है।\n- **अनोखी बात:** यह बिहार बोर्ड कक्षा 12 की **सबसे छोटी और सबसे आसानी से याद होने वाली कविता** है — पूरी कविता याद करके आप 5/5 अंक आराम से पा सकते हैं!",
    "concept_md_en": "### What is an Epitaph?\n- **Epitaph (*एपिटैफ़*):** An inscription carved on a **tomb or gravestone** in memory of someone who has died.\n- **Tone:** Deeply **melancholic (sad)** and reflective.\n- **Exam Advantage:** Being the shortest poem in *Rainbow Part-2* (just 7–8 lines!), memorizing the whole poem takes 2 minutes and guarantees full marks!",
    "exam_tip_hi": "BSEB इंटर के 4 पक्के MCQ: Order of Merit कब व किसने दिया? → **Queen Elizabeth II (1953)** · स्त्री कहाँ की थी? → **West Country** · कवि को क्या कहा जाता है? → **Children's Poet** · \"Crumble\" का अर्थ? → **To die (मर जाना)**!",
    "exam_tip_en": "4 Guaranteed Inter MCQs: **Order of Merit (1953)** by **Queen Elizabeth II** · Lady of the **West Country** · **Children's Poet** · **\"Crumble\" = to die**!",
    "glossary_terms": [
      {
        "term_hi": "Epitaph (एपिटैफ़)",
        "term_en": "Epitaph",
        "pronunciation_hi": "एपिटैफ़",
        "definition_hi": "किसी मृत व्यक्ति की कब्र या समाधि पर लिखा गया स्मृति-लेख।",
        "definition_en": "Words inscribed on a tomb in memory of a dead person."
      },
      {
        "term_hi": "Crumble (क्रम्बल)",
        "term_en": "Crumble",
        "pronunciation_hi": "क्रम्बल",
        "definition_hi": "टूटकर बिखर जाना / कविता में इसका लाक्षणिक अर्थ है \"मर जाना (to die)\"।",
        "definition_en": "To break into dust; figuratively means \"to die\" in the poem."
      }
    ]
  },
  {
    "id": "epi-sec-2-fullpoem",
    "order": 2,
    "heading_hi": "2. विज़ुअल व्याख्या: पूरी कविता (पंक्ति-दर-पंक्ति सरल अर्थ)",
    "heading_en": "2. Complete Poem Visual Breakdown (All 8 Lines)",
    "analogy_hi": "पूरी कविता ही केवल 8 छोटी पंक्तियों की है! नीचे के 3 चरणों में पूरी कविता आँखों के सामने जीवंत हो जाएगी।",
    "analogy_en": "The entire poem is only 8 brief lines — see all 3 emotional stages in one clear visual map!",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "An Epitaph — संपूर्ण कविता के 3 भाव-चरण",
      "title_en": "An Epitaph — All 3 Emotional Movements",
      "direction": "TB",
      "steps": [
        {
          "id": "epi-s1",
          "label_hi": "भाग 1 (पंक्ति 1–4): वेस्ट कंट्री की अनुपम सुंदरी",
          "label_en": "Lines 1–4: The Most Beautiful Lady of the West Country",
          "detail_hi": "\"Here lies a most beautiful lady, / Light of step and heart was she; / I think she was the most beautiful lady / That ever was in the West Country.\" (चंचल व मनमोहक स्त्री कब्र में सोई है)",
          "detail_en": "Introduces the carefree, unmatched beauty of the West Country now lying in her grave.",
          "accent": "indigo"
        },
        {
          "id": "epi-s2",
          "label_hi": "भाग 2 (पंक्ति 5–6): सौंदर्य की नश्वरता (Transience of Beauty)",
          "label_en": "Lines 5–6: Physical Beauty Vanishes",
          "detail_hi": "\"But beauty vanishes; beauty passes; / However rare—rare it be;\" (सौंदर्य कितना भी दुर्लभ क्यों न हो, एक दिन मिट ही जाता है!)",
          "detail_en": "Delivers the philosophical truth: even the rarest physical beauty fades away forever.",
          "accent": "amber"
        },
        {
          "id": "epi-s3",
          "label_hi": "भाग 3 (पंक्ति 7–8): कवि की करुण चिंता (Who Will Remember?)",
          "label_en": "Lines 7–8: The Poet's Haunting Question",
          "detail_hi": "\"And when I crumble, who will remember / This lady of the West Country?\" (जब मैं भी मर जाऊँगा, तो इस स्त्री को कौन याद रखेगा?)",
          "detail_en": "Laments that once the poet himself dies (\"crumbles\"), nobody will remember her at all.",
          "accent": "slate"
        }
      ],
      "edges": [
        {
          "from": "epi-s1",
          "to": "epi-s2",
          "label_hi": "दार्शनिक मोड़",
          "label_en": "Philosophical turn"
        },
        {
          "from": "epi-s2",
          "to": "epi-s3",
          "label_hi": "करुण प्रश्न",
          "label_en": "Haunting lament"
        }
      ]
    },
    "concept_md_hi": "### दो महत्वपूर्ण वाक्यांशों का गहरा अर्थ (2-अंक प्रश्नों में बार-बार आते हैं!)\n1. **\"Light of step and heart\":** इसका अर्थ है कि वह सुंदर स्त्री अत्यंत **चंचल, स्वच्छंद और अस्थिर स्वभाव (habit of moving here and there without serious commitment)** की थी — वह अपने सौंदर्य में मग्न रहती थी और उसने लोगों के लिए कोई स्थायी नेक कार्य नहीं छोड़ा।\n2. **\"When I crumble\":** यहाँ **\"crumble\"** का अर्थ है **मृत्यु हो जाना (to die)**। कवि आज भी उससे सच्चा प्रेम करता है और उसकी कब्र के पास खड़ा है — पर उसे दुख है कि उसके मरने के बाद दुनिया इस स्त्री को पूरी तरह भूल जाएगी!",
    "concept_md_en": "### 2 High-Yield Phrases Explained (2-Mark Favourites!)\n1. **\"Light of step and heart\":** Means the lady had the habit of **moving playfully here and there without deep commitment** — carefree and proud of her beauty, leaving no lasting good deeds behind.\n2. **\"When I crumble\":** Literally to fall into dust; here it means **\"when I die\"**. The poet loves her deeply even after death, yet grieves that once he dies, the world will completely forget her.",
    "exam_tip_hi": "याद रखें: \"Light of step and heart\" का अर्थ **habit of moving / carefree and inconstant nature** होता है, और \"crumble\" का अर्थ **to die**!",
    "exam_tip_en": "Exam keys: **\"Light of step and heart\"** = carefree/inconstant movement; **\"crumble\"** = **to die**!",
    "glossary_terms": [
      {
        "term_hi": "Vanishes (वैनिशेज़)",
        "term_en": "Vanishes",
        "pronunciation_hi": "वैनिशेज़",
        "definition_hi": "गायब हो जाना / धीरे-धीरे मिट जाना।",
        "definition_en": "Disappears completely with time."
      },
      {
        "term_hi": "Rare (रेयर)",
        "term_en": "Rare",
        "pronunciation_hi": "रेयर",
        "definition_hi": "अत्यंत दुर्लभ और अनूठा (सौंदर्य कितना भी दुर्लभ हो, मिट जाता है)।",
        "definition_en": "Unusually precious and uncommon."
      }
    ],
    "quick_check": {
      "q_hi": "\"And when I crumble, who will remember\" में \"I\" कौन है और \"crumble\" का अर्थ क्या है?",
      "q_en": "In \"And when I crumble, who will remember\", who is \"I\" and what does \"crumble\" mean?",
      "answer_hi": "\"I\" स्वयं **कवि (Walter de la Mare)** हैं, और \"crumble\" का अर्थ है **मर जाना (to die)**।",
      "answer_en": "\"I\" is the **poet (Walter de la Mare)**, and \"crumble\" means **to die**."
    }
  },
  {
    "id": "epi-sec-3-lines",
    "order": 3,
    "heading_hi": "3. सभी मुख्य पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "नीचे चारों युग्मों को उच्चारण सहित बोलकर पढ़ लें — आपको पूरी कविता मुँहज़बानी याद हो जाएगी!",
    "analogy_en": "Read these 4 pairs aloud once — you will literally know the entire poem by heart!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "An Epitaph — संपूर्ण पंक्तियाँ (उच्चारण + हिंदी अर्थ)",
      "title_en": "An Epitaph — Line-by-Line Pronunciation & Meaning",
      "headers_hi": [
        "काव्य पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "Poem Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "Here lies a most beautiful lady, light of step and heart was she.",
            "हियर लाइज़ अ मोस्ट ब्यूटीफ़ुल लेडी, लाइट ऑफ़ स्टेप ऐंड हार्ट वॉज़ शी।",
            "यहाँ एक अत्यंत सुंदर स्त्री लेटी है; वह चंचल क़दमों व हल्के हृदय वाली थी।"
          ],
          "cells_en": [
            "Here lies a most beautiful lady, light of step and heart was she.",
            "Hi-yar laaiz a most byoo-ti-ful le-dee, laait ov step and haart woz shee.",
            "Opens like an authentic gravestone epitaph."
          ]
        },
        {
          "cells_hi": [
            "I think she was the most beautiful lady that ever was in the West Country.",
            "आई थिंक शी वॉज़ द मोस्ट ब्यूटीफ़ुल लेडी दैट एवर वॉज़ इन द वेस्ट कंट्री।",
            "मुझे लगता है वह वेस्ट कंट्री में जन्मी अब तक की सबसे सुंदर स्त्री थी।"
          ],
          "cells_en": [
            "I think she was the most beautiful lady that ever was in the West Country.",
            "Aai thingk shee woz the most byoo-ti-ful le-dee that e-var woz in the West Kan-tree.",
            "Praises her unmatched beauty in the West Country."
          ]
        },
        {
          "cells_hi": [
            "But beauty vanishes; beauty passes; however rare—rare it be.",
            "बट ब्यूटी वैनिशेज़; ब्यूटी पासेज़; हाउएवर रेयर—रेयर इट बी।",
            "किंतु सौंदर्य मिट जाता है, गुज़र जाता है — चाहे वह कितना ही दुर्लभ क्यों न हो!"
          ],
          "cells_en": [
            "But beauty vanishes; beauty passes; however rare—rare it be.",
            "Bat byoo-tee va-ni-shez; byoo-tee paa-sez; hau-e-var re-yar it bee.",
            "Central philosophical truth on mortality."
          ]
        },
        {
          "cells_hi": [
            "And when I crumble, who will remember this lady of the West Country?",
            "ऐंड व्हेन आई क्रम्बल, हू विल रिमेंबर दिस लेडी ऑफ़ द वेस्ट कंट्री?",
            "और जब मैं भी मर जाऊँगा, तो वेस्ट कंट्री की इस स्त्री को कौन याद रखेगा?"
          ],
          "cells_en": [
            "And when I crumble, who will remember this lady of the West Country?",
            "And when aai kram-bal, hoo wil ri-mem-bar this le-dee ov the West Kan-tree?",
            "Melancholic fear that she will be forgotten forever."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Epitaph** (*एपिटैफ़*) = समाधि-लेख\n2. **Melancholic** (*मेलंकॉलिक*) = उदास / करुण\n3. **Transient** (*ट्रैंज़िएंट*) = क्षणभंगुर / अस्थायी\n4. **Vanish** (*वैनिश*) = लुप्त हो जाना\n5. **Crumble** (*क्रम्बल*) = मिट्टी में मिलना / मर जाना\n6. **Inconstant** (*इनकॉन्स्टेंट*) = चंचल / अस्थिर",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Epitaph** (*एपिटैफ़*) = tomb inscription\n2. **Melancholic** (*मेलंकॉलिक*) = sad and reflective\n3. **Transient** (*ट्रैंज़िएंट*) = temporary, short-lived\n4. **Vanish** (*वैनिश*) = fade away completely\n5. **Crumble** (*क्रम्बल*) = decay / die\n6. **Inconstant** (*इनकॉन्स्टेंट*) = changeable, lacking firm loyalty",
    "exam_tip_hi": "4-अंक Explanation ट्रिक: *\"But beauty vanishes; beauty passes\"* आने पर स्पष्ट लिखें कि **बाहरी शारीरिक सौंदर्य क्षणभंगुर है, पर आंतरिक सद्गुण व कर्म अमर रहते हैं!**",
    "exam_tip_en": "4-Mark Explanation tip: Contrast **transient physical beauty** with **lasting inner virtue and noble deeds**!",
    "glossary_terms": [
      {
        "term_hi": "Transient (ट्रैंज़िएंट)",
        "term_en": "Transient",
        "pronunciation_hi": "ट्रैंज़िएंट",
        "definition_hi": "क्षणभंगुर या थोड़े समय तक टिकने वाला (जैसे बाहरी सौंदर्य)।",
        "definition_en": "Lasting only for a short time; not permanent."
      },
      {
        "term_hi": "Melancholic (मेलंकॉलिक)",
        "term_en": "Melancholic",
        "pronunciation_hi": "मेलंकॉलिक",
        "definition_hi": "उदासी और करुणा से भरा हुआ भाव।",
        "definition_en": "Filled with quiet sadness and grief."
      }
    ]
  },
  {
    "id": "epi-sec-4-summary",
    "order": 4,
    "heading_hi": "4. बाहरी सौंदर्य बनाम आंतरिक गुण व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Physical Beauty vs Lasting Virtue & 5-Mark Summary Formula",
    "analogy_hi": "सिर्फ़ ये 5 छोटे, साफ़-सुथरे वाक्य याद कर लें — कक्षा 12 के 5-अंक Poetry Summary में सबसे आसान और तेज़ 5/5 अंक इसी कविता से मिलते हैं!",
    "analogy_en": "These 5 crisp sentences make \"An Epitaph\" the easiest, fastest 5/5 Poetry Summary in Class 12!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "An Epitaph का केंद्रीय दर्शन (नश्वर सौंदर्य बनाम अमर कर्म)",
      "title_en": "Central Philosophy of An Epitaph (Transient Beauty vs Lasting Deeds)",
      "caption_hi": "कवि सिखाते हैं कि दुर्लभ शारीरिक सौंदर्य भी मृत्यु के साथ मिट जाता है; सच्ची स्मृति केवल प्रेम और अच्छे कर्मों से जीवित रहती है।",
      "caption_en": "Even rare physical beauty vanishes with death; true memory endures only through love and noble deeds.",
      "viewBox": "0 0 620 200",
      "elements": [
        {
          "kind": "rect",
          "x": 20,
          "y": 26,
          "width": 256,
          "height": 148,
          "rx": 12,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 148,
          "y": 58,
          "text_hi": "बाहरी सौंदर्य (Physical Beauty)",
          "text_en": "Physical Beauty",
          "fill": "#92400E",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 148,
          "y": 92,
          "text_hi": "वेस्ट कंट्री की सबसे सुंदर स्त्री",
          "text_en": "Most Beautiful Lady of West Country",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 148,
          "y": 122,
          "text_hi": "क्षणभंगुर — मृत्यु के साथ मिट जाता है",
          "text_en": "Vanishes & passes however rare",
          "fill": "#B45309",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 148,
          "y": 152,
          "text_hi": "समय के साथ लोग भूल जाते हैं",
          "text_en": "Eventually forgotten by the world",
          "fill": "#DC2626",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 282,
          "y1": 100,
          "x2": 338,
          "y2": 100,
          "stroke": "#1E3A8A",
          "strokeWidth": 3
        },
        {
          "kind": "label",
          "x": 310,
          "y": 86,
          "text_hi": "संदेश",
          "text_en": "Lesson",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 344,
          "y": 26,
          "width": 256,
          "height": 148,
          "rx": 12,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 472,
          "y": 58,
          "text_hi": "सच्चा प्रेम व सद्गुण (Inner Virtue)",
          "text_en": "True Love & Noble Deeds",
          "fill": "#065F46",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 472,
          "y": 92,
          "text_hi": "कवि का निश्छल प्रेम आज भी जीवित है",
          "text_en": "Only the poet remembers her in love",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 472,
          "y": 122,
          "text_hi": "अच्छे कर्म व चरित्र अमर रहते हैं",
          "text_en": "Character & kindness endure forever",
          "fill": "#047857",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 472,
          "y": 152,
          "text_hi": "सौंदर्य नहीं, कर्म याद रखे जाते हैं",
          "text_en": "Deeds outlive physical beauty",
          "fill": "#059669",
          "fontSize": 12,
          "anchor": "middle"
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"An Epitaph\"** is a short, melancholic poem composed by **Walter de la Mare**, known as the **Children's Poet**.\n2. Standing beside a tomb, the poet remembers a lady who was the **most beautiful woman ever born in the West Country**.\n3. She was **\"light of step and heart\"**, carefree and proud of her rare physical charm.\n4. The poet expresses a deep philosophical truth: **physical beauty is transient — it vanishes and passes away however rare it may be**.\n5. Finally, he laments sadly that once he himself dies (**\"crumbles\"**), **nobody will remember** this beautiful lady, teaching us that noble deeds outlive physical beauty.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"An Epitaph\"** is a short, melancholic poem composed by **Walter de la Mare**, known as the **Children's Poet**.\n2. Standing beside a tomb, the poet remembers a lady who was the **most beautiful woman ever born in the West Country**.\n3. She was **\"light of step and heart\"**, carefree and proud of her rare physical charm.\n4. The poet expresses a deep philosophical truth: **physical beauty is transient — it vanishes and passes away however rare it may be**.\n5. Finally, he laments sadly that once he himself dies (**\"crumbles\"**), **nobody will remember** this beautiful lady, teaching us that noble deeds outlive physical beauty.",
    "exam_tip_hi": "कॉपी में **Walter de la Mare**, **West Country**, **Beauty vanishes**, और **Crumble (die)** को साफ़ अंडरलाइन करें!",
    "exam_tip_en": "Underline **Walter de la Mare**, **West Country**, **Beauty vanishes**, and **Crumble**!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "महारानी एलिज़ाबेथ द्वितीय ने वाल्टर डी ला मेयर को 1953 में किस सम्मान से नवाज़ा था?",
      "q_en": "With which royal honour did Queen Elizabeth II honour Walter de la Mare in 1953?",
      "answer_hi": "**ऑर्डर ऑफ़ मेरिट (Order of Merit)** से।",
      "answer_en": "The **Order of Merit**."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Poet",
      "fact_hi": "वाल्टर डी ला मेयर (1873–1956) · Children's Poet · Order of Merit (1953)",
      "fact_en": "Walter de la Mare (1873–1956) · Children's Poet · Order of Merit (1953)"
    },
    {
      "tag": "Key Meanings",
      "fact_hi": "Epitaph = समाधि-लेख · Crumble = to die · West Country = पश्चिमी इंग्लैंड",
      "fact_en": "Epitaph = tomb inscription · Crumble = to die · West Country"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "An Epitaph is a poignant short lyric by Walter de la Mare.",
      "fact_en": "An Epitaph is a poignant short lyric by Walter de la Mare."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "It mourns the most beautiful lady ever born in the West Country.",
      "fact_en": "It mourns the most beautiful lady ever born in the West Country."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "She was \"light of step and heart\", carefree in her rare beauty.",
      "fact_en": "She was \"light of step and heart\", carefree in her rare beauty."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "The poet reminds us that physical beauty vanishes and passes away.",
      "fact_en": "The poet reminds us that physical beauty vanishes and passes away."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "He grieves that when he dies (\"crumbles\"), no one will remember her.",
      "fact_en": "He grieves that when he dies (\"crumbles\"), no one will remember her."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "\"West Country\" की जगह \"East Country\" या \"England Country\" लिख देना।",
      "mistake_en": "Writing East Country or North Country instead of West Country.",
      "fix_hi": "सटीक शब्द याद रखें: **The West Country**!",
      "fix_en": "Always write the exact phrase: **the West Country**!"
    },
    {
      "mistake_hi": "महारानी एलिज़ाबेथ के सम्मान को \"Nobel Prize\" लिख देना।",
      "mistake_en": "Writing Nobel Prize instead of Order of Merit.",
      "fix_hi": "वाल्टर डी ला मेयर को 1953 में **Order of Merit** मिला था (T.S. Eliot को 1948 में Nobel Prize मिला था)!",
      "fix_en": "Walter de la Mare received the **Order of Merit (1953)** (not Nobel Prize)!"
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "वेस्ट कंट्री की स्त्री व \"Beauty vanishes; beauty passes\"",
      "topic_en": "Lady of the West Country & Transience of Beauty",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "\"Light of step and heart\", \"Crumble\" और Order of Merit (1953)",
      "topic_en": "\"Light of Step and Heart\", \"Crumble\" & Order of Merit",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-12-eng-ch5',
  2,
  'छात्र "An Epitaph" की सभी 8 पंक्तियों का शुद्ध उच्चारण कर सकेंगे, नश्वर सौंदर्य का दार्शनिक संदेश समझ सकेंगे और 5-अंक सारांश व इंटर PYQ बिना त्रुटि हल कर सकेंगे।',
  'Students will recite all 8 lines of "An Epitaph" accurately, explain the transience of beauty, and answer every Inter MCQ, 2M, and 5M question.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "गुलाब-फूल हुक, पूरी 8 पंक्तियों का सस्वर पठन व उच्चारण",
    "phase_en": "Fading-Rose Hook, Complete 8-Line Recitation & Pronunciation",
    "teacher_action_hi": "पूछें: \"क्या बाहरी सुंदरता हमेशा रहती है, या अच्छे कर्म हमेशा याद रहते हैं?\" फिर पूरी 8 पंक्तियाँ बोर्ड पर लिखकर सस्वर पढ़ाएँ। Epitaph (एपिटैफ़), Vanishes (वैनिशेज़), Crumble (क्रम्बल), Melancholic (मेलंकॉलिक) का उच्चारण अभ्यास कराएँ।",
    "teacher_action_en": "Ask whether outer beauty or good deeds last forever. Write all 8 lines on the board and lead chorus recitation. Drill Epitaph, Vanishes, Crumble, and Melancholic.",
    "student_check_hi": "पूछें: \"Epitaph किसे कहते हैं और Crumble शब्द का कविता में अर्थ क्या है?\"",
    "student_check_en": "Ask: \"What is an epitaph, and what does 'crumble' mean in the poem?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "4-अंक व्याख्या, 5-मिनट मौखिक गतिविधि व 5-अंक सारांश",
    "phase_en": "4-Mark Explanation, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "\"But beauty vanishes; beauty passes\" की 4-अंक संदर्भ व्याख्या सिखाएँ। 5-मिनट मौखिक गतिविधि में कमजोर छात्रों से 5-वाक्य सारांश बुलवाएँ। अंत में 5 इंटर PYQ हल कराएँ।",
    "teacher_action_en": "Model the 4-mark explanation of \"But beauty vanishes; beauty passes\". Run a 5-min oral summary relay for shy learners, closing with 5 Inter PYQs.",
    "student_check_hi": "पूछें: \"वाल्टर डी ला मेयर को 1953 में किस सम्मान से नवाज़ा गया?\" (Order of Merit)",
    "student_check_en": "Ask: \"Which honour did Queen Elizabeth II give Walter de la Mare in 1953?\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड कविता बॉक्स (An Epitaph)",
    "heading_en": "Blackboard Poem Box (An Epitaph)",
    "points_hi": [
      "कवि: Walter de la Mare (1873–1956) · Children's Poet · Order of Merit (1953)",
      "Epitaph = कब्र पर खुदा लेख | Tone = Melancholic (उदास)",
      "स्त्री: Most beautiful lady in the West Country · \"Light of step and heart\"",
      "सत्य: \"But beauty vanishes; beauty passes\" · Crumble = to die (मर जाना)"
    ],
    "points_en": [
      "Poet: Walter de la Mare (1873–1956) · Children's Poet · Order of Merit (1953)",
      "Epitaph = tomb inscription | Tone = Melancholic",
      "Lady: Most beautiful in the West Country · \"Light of step and heart\"",
      "Theme: Physical beauty vanishes · \"Crumble\" = to die"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"8-पंक्ति सस्वर स्मरण\" गतिविधि",
    "title_en": "5-Minute \"8-Line Chorus Memory\" Activity",
    "materials_hi": "ब्लैकबोर्ड पर लिखी पूरी 8 पंक्तियाँ",
    "materials_en": "All 8 lines written cleanly on the board",
    "steps_hi": "दो बार पूरी कक्षा एक साथ कविता पढ़े; फिर शिक्षक 4 शब्द मिटा दें (beautiful, West Country, vanishes, crumble) और कमजोर छात्र खाली स्थान भरकर बोलें!",
    "steps_en": "Class recites twice; teacher erases 4 keywords (beautiful, West Country, vanishes, crumble) and shy students fill them orally!"
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "\"An Epitaph\" की सभी 8 पंक्तियाँ सुंदर लिखावट में लिखें और याद करें।",
    "task_en": "Copy all 8 lines of \"An Epitaph\" neatly and memorize them."
  },
  {
    "level": "BOARD",
    "task_hi": "\"Light of step and heart\" और \"When I crumble\" का अर्थ 2–3 वाक्यों में लिखें।",
    "task_en": "Explain the meanings of \"light of step and heart\" and \"when I crumble\" in 2–3 sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "\"An Epitaph\" का 5-अंक सारांश बिना देखे लिखें।",
    "task_en": "Write the 5-mark summary of \"An Epitaph\" from memory."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र सोचते हैं कि \"I\" कोई अजनबी या कब्र का पत्थर बोल रहा है।",
    "misconception_en": "Students think the stone itself is speaking as \"I\".",
    "correction_hi": "स्पष्ट करें कि \"I\" स्वयं **कवि (Walter de la Mare)** हैं जो कब्र के पास खड़े होकर अपने मरने के बाद की चिंता करते हैं।",
    "correction_en": "Clarify \"I\" is the **poet** standing beside the grave, worrying about what happens when he dies."
  },
  {
    "misconception_hi": "छात्र \"rare\" का अर्थ \"कच्चा\" या \"पीछे\" समझ लेते हैं।",
    "misconception_en": "Students confuse \"rare\" with \"rear\".",
    "correction_hi": "अंतर बताएँ: **Rare (रेयर)** = अत्यंत दुर्लभ/अनमोल; **Rear** = पिछला भाग!",
    "correction_en": "Distinguish: **Rare** = unusually precious/uncommon; **Rear** = back side!"
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
  (
    '10000007-0010-4000-8000-000000000001', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Poet & Honour', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB 2024',
    'An Epitaph के कवि कौन हैं और उन्हें 1953 में कौन-सा सम्मान मिला?',
    'Who composed "An Epitaph" and what royal honour did he receive in 1953?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"An Epitaph\" के कवि, उनका उपनाम और 1953 का सम्मान बताएँ।",
  "front_en": "Name the poet of \"An Epitaph\", his title, and his 1953 royal honour.",
  "back_hi": "कवि: Walter de la Mare (1873–1956) · उपनाम: Children's Poet · सम्मान: Order of Merit (1953, Queen Elizabeth II)।",
  "back_en": "Poet: Walter de la Mare (1873–1956) · Title: Children's Poet · Honour: Order of Merit (1953, Queen Elizabeth II).",
  "pronunciation_hi": "ऐन एपिटैफ़ — वाल्टर डी ला मेयर",
  "mnemonic_hi": "1953 में महारानी एलिज़ाबेथ ने \"Order of Merit\" दिया!",
  "mnemonic_en": "Queen Elizabeth II -> Order of Merit (1953)!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000002', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Vocabulary Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Epitaph और Crumble का उच्चारण व अर्थ क्या है?',
    'Give the pronunciation and meaning of Epitaph and Crumble.',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Epitaph और Crumble शब्दों का उच्चारण व कविता में अर्थ बताएँ।",
  "front_en": "Give the pronunciation and poetic meaning of \"Epitaph\" and \"Crumble\".",
  "back_hi": "Epitaph (एपिटैफ़) = कब्र पर खुदा समाधि-लेख · Crumble (क्रम्बल) = टूटकर बिखरना / मर जाना (to die)।",
  "back_en": "Epitaph = inscription on a tomb · Crumble = to die / pass into dust.",
  "pronunciation_hi": "एपिटैफ़ · क्रम्बल",
  "mnemonic_hi": "कविता में \"When I crumble\" = \"जब मैं मर जाऊँगा\"!",
  "mnemonic_en": "In the poem, \"when I crumble\" = \"when I die\"!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000003', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Poem Facts Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB 2023',
    'स्तंभ A को स्तंभ B के सही अर्थ या तथ्य से मिलाएँ:',
    'Match each item from "An Epitaph" in Column A with Column B:',
    NULL, NULL,
    'Order of Merit, West Country, Crumble और Songs for Children मिलाएँ।', 'Match Order of Merit, West Country, Crumble, and Songs for Children.',
    'Order of Merit = 1953 सम्मान, West Country = सुंदर स्त्री का क्षेत्र, Crumble = मर जाना, Songs for Children = वाल्टर डी ला मेयर की कृति।', 'Order of Merit (1953), West Country (lady''s homeland), Crumble (to die), Songs for Children (de la Mare''s work).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each fact from An Epitaph",
  "pairs": [
    {
      "id": "epi-m1",
      "left_hi": "Order of Merit (1953)",
      "left_en": "Order of Merit (1953)",
      "right_hi": "महारानी एलिज़ाबेथ द्वितीय द्वारा दिया गया सम्मान",
      "right_en": "Honour given by Queen Elizabeth II"
    },
    {
      "id": "epi-m2",
      "left_hi": "West Country",
      "left_en": "West Country",
      "right_hi": "कविता की सबसे सुंदर स्त्री का स्थान",
      "right_en": "Region of the most beautiful lady"
    },
    {
      "id": "epi-m3",
      "left_hi": "Crumble (क्रम्बल)",
      "left_en": "Crumble",
      "right_hi": "कविता में अर्थ: मर जाना (To die)",
      "right_en": "Means \"to die\" in the poem"
    },
    {
      "id": "epi-m4",
      "left_hi": "Peacock Pie",
      "left_en": "Peacock Pie",
      "right_hi": "वाल्टर डी ला मेयर का प्रसिद्ध कविता-संग्रह",
      "right_en": "Famous collection by Walter de la Mare"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000004', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'कविता की पहली पंक्ति सजाएँ: "यहाँ एक अत्यंत सुंदर स्त्री लेटी है।"',
    'Build the opening line: "Here lies a most beautiful lady"',
    NULL, NULL,
    'Here + lies + a + most + beautiful + lady।', 'Follow the exact opening words of the poem.',
    'सही पंक्ति: "Here lies a most beautiful lady"।', 'Correct opening line: "Here lies a most beautiful lady".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "यहाँ एक अत्यंत सुंदर स्त्री लेटी है।",
  "prompt_en": "Build the iconic first line of An Epitaph",
  "grammar_formula": "Here + V1(s) + a + most + Adjective + Noun",
  "tokens": [
    "Here",
    "lies",
    "a",
    "most",
    "beautiful",
    "lady"
  ],
  "distractors": [
    "lie",
    "the"
  ],
  "correct_sentence": "Here lies a most beautiful lady",
  "pronunciation_hi": "हियर लाइज़ अ मोस्ट ब्यूटीफ़ुल लेडी"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000005', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'कविता का केंद्रीय सत्य सजाएँ: "सौंदर्य मिट जाता है और गुज़र जाता है।"',
    'Build the philosophical truth: "Beauty vanishes and beauty passes away"',
    NULL, NULL,
    'Singular noun "Beauty" के साथ "vanishes" और "passes" लगता है।', 'Singular "Beauty" takes "vanishes" and "passes".',
    'सही वाक्य: "Beauty vanishes and beauty passes away"।', 'Correct sentence: "Beauty vanishes and beauty passes away".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "सौंदर्य मिट जाता है और गुज़र जाता है।",
  "prompt_en": "Build the central philosophical sentence of An Epitaph",
  "grammar_formula": "Subject + V1(es) + and + Subject + V1(es) + Adverb",
  "tokens": [
    "Beauty",
    "vanishes",
    "and",
    "beauty",
    "passes",
    "away"
  ],
  "distractors": [
    "vanish",
    "pass"
  ],
  "correct_sentence": "Beauty vanishes and beauty passes away",
  "pronunciation_hi": "ब्यूटी वैनिशेज़ ऐंड ब्यूटी पासेज़ अवे"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000006', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'West Country MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2024',
    '"An Epitaph" की सबसे सुंदर स्त्री किस क्षेत्र की रहने वाली थी?',
    'The most beautiful lady in "An Epitaph" belonged to the:',
    $json$[{"key":"A","text_hi":"ईस्ट कंट्री (East Country)","text_en":"East Country"},{"key":"B","text_hi":"वेस्ट कंट्री (West Country)","text_en":"West Country"},{"key":"C","text_hi":"साउथ कंट्री (South Country)","text_en":"South Country"},{"key":"D","text_hi":"नॉर्थ कंट्री (North Country)","text_en":"North Country"}]$json$::jsonb, 'B',
    'पंक्ति: "That ever was in the ___ Country."', 'Complete: "That ever was in the ___ Country."',
    'कविता में वह सुंदर स्त्री "वेस्ट कंट्री (West Country)" की थी।', 'The lady belonged to the West Country.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000007', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Crumble Meaning MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB 2023',
    '"And when I crumble, who will remember" में "crumble" शब्द का क्या अर्थ है?',
    'What does the word "crumble" mean in the poem "An Epitaph"?',
    $json$[{"key":"A","text_hi":"यात्रा करना (To travel)","text_en":"To travel"},{"key":"B","text_hi":"मुस्कुराना (To smile)","text_en":"To smile"},{"key":"C","text_hi":"जीवित रहना (To live)","text_en":"To live"},{"key":"D","text_hi":"मर जाना (To die)","text_en":"To die"}]$json$::jsonb, 'D',
    'शरीर का मिट्टी में मिल जाना!', 'Figuratively means passing away into dust.',
    'कविता में "crumble" का अर्थ है "मर जाना (to die)"।', 'In "An Epitaph", "crumble" means "to die".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000008', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Order of Merit MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2024',
    '1953 में महारानी एलिज़ाबेथ द्वितीय ने वाल्टर डी ला मेयर को किस पुरस्कार से सम्मानित किया?',
    'Queen Elizabeth II honoured Walter de la Mare in 1953 with the:',
    $json$[{"key":"A","text_hi":"बुकर पुरस्कार (Booker Prize)","text_en":"Booker Prize"},{"key":"B","text_hi":"नोबेल पुरस्कार (Nobel Prize)","text_en":"Nobel Prize"},{"key":"C","text_hi":"ऑर्डर ऑफ़ मेरिट (Order of Merit)","text_en":"Order of Merit"},{"key":"D","text_hi":"पुलित्ज़र पुरस्कार (Pulitzer Prize)","text_en":"Pulitzer Prize"}]$json$::jsonb, 'C',
    'ब्रिटिश राजशाही का सर्वोच्च सम्मान!', 'A prestigious British royal honour conferred in 1953.',
    '1953 में महारानी एलिज़ाबेथ द्वितीय ने वाल्टर डी ला मेयर को "Order of Merit" से सम्मानित किया।', 'Queen Elizabeth II honoured him with the Order of Merit in 1953.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000009', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Light of Step MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB 2022',
    'कविता में "Light of step and heart was she" पंक्ति किस बात की ओर संकेत करती है?',
    'What does "Light of step and heart was she" signify about the lady?',
    $json$[{"key":"A","text_hi":"वह चंचल व इधर-उधर घूमने की आदत वाली थी","text_en":"She was carefree with a habit of moving without commitment"},{"key":"B","text_hi":"वह एक नर्तकी थी","text_en":"She was a stage dancer"},{"key":"C","text_hi":"वह बहुत क्रोधी थी","text_en":"She was very angry"},{"key":"D","text_hi":"वह बहुत बीमार थी","text_en":"She was very sick"}]$json$::jsonb, 'A',
    'स्वच्छंद, चंचल और अस्थिर स्वभाव।', 'Suggests a playful, carefree, inconstant nature.',
    '"Light of step and heart" का अर्थ है कि वह बिना गहरे दायित्व के चंचल व स्वच्छंद स्वभाव की थी।', 'It implies she was carefree, moving lightly from place to place without deep commitment.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000010', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Poem Tone MCQ', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB 2023',
    '"An Epitaph" कविता का मुख्य भाव (tone) कैसा है?',
    'What is the predominant tone of the poem "An Epitaph"?',
    $json$[{"key":"A","text_hi":"हास्यपूर्ण (Humorous)","text_en":"Humorous"},{"key":"B","text_hi":"उदास और करुण (Melancholic)","text_en":"Melancholic"},{"key":"C","text_hi":"रोमांटिक व उल्लासमय (Joyful)","text_en":"Joyful"},{"key":"D","text_hi":"वीर रस से पूर्ण (Heroic)","text_en":"Heroic"}]$json$::jsonb, 'B',
    'कवि कब्र के पास खड़े होकर नश्वर सौंदर्य पर दुख व्यक्त करते हैं।', 'The poet stands mournfully by a grave reflecting on mortality.',
    '"An Epitaph" का मुख्य स्वर उदास और करुण (melancholic) है।', 'The poem carries a deeply melancholic, wistful tone.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000011', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Exam Pool: Children''s Poet', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB 2024',
    'इनमें से किस कवि को "बच्चों के कवि (Children''s Poet)" के रूप में जाना जाता है?',
    'Who among the following is famously known as a "Children''s Poet"?',
    $json$[{"key":"A","text_hi":"रूपर्ट ब्रुक (Rupert Brooke)","text_en":"Rupert Brooke"},{"key":"B","text_hi":"जॉन डन (John Donne)","text_en":"John Donne"},{"key":"C","text_hi":"वाल्टर डी ला मेयर (Walter de la Mare)","text_en":"Walter de la Mare"},{"key":"D","text_hi":"जॉन कीट्स (John Keats)","text_en":"John Keats"}]$json$::jsonb, 'C',
    '"Songs for Children" और "Peacock Pie" के रचयिता!', 'Author of "Songs for Children" and "Peacock Pie".',
    'वाल्टर डी ला मेयर को "Children''s Poet" कहा जाता है।', 'Walter de la Mare is celebrated as the "Children''s Poet".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000012', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Exam Pool: Beauty Vanishes', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB 2023',
    'कविता की पंक्ति पूरी करें: "However rare — ___ it be."',
    'Complete the line from "An Epitaph": "However rare — ___ it be."',
    $json$[{"key":"A","text_hi":"clear","text_en":"clear"},{"key":"B","text_hi":"dear","text_en":"dear"},{"key":"C","text_hi":"fair","text_en":"fair"},{"key":"D","text_hi":"rare","text_en":"rare"}]$json$::jsonb, 'D',
    'कवि ने ज़ोर देने के लिए एक ही शब्द को दो बार दोहराया है!', 'The poet repeats the exact same word for emphasis!',
    'सही पंक्ति है: "However rare—rare it be;"।', 'The exact line is: "However rare—rare it be;"',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000013', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Poet Lament 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB 2023',
    'वाल्टर डी ला मेयर वेस्ट कंट्री की सुंदर स्त्री के बारे में क्या सोचते हैं और उनकी मुख्य चिंता क्या है?',
    'What does Walter de la Mare think about the lady of the West Country, and what makes him sad?',
    NULL, NULL,
    'दो बातें लिखें: (1) वह वेस्ट कंट्री की सबसे सुंदर स्त्री थी, (2) कवि के मरने ("crumble") के बाद उसे कोई याद नहीं रखेगा।', 'Include 2 points: unmatched beauty in the West Country, and sadness that nobody will remember her after he dies.',
    NULL, NULL,
    'कवि मानते हैं कि वह स्त्री **वेस्ट कंट्री की सबसे सुंदर महिला** थी। किंतु वे अत्यंत दुखी हैं क्योंकि बाहरी सौंदर्य नश्वर है — मृत्यु के साथ मिट जाता है। उनकी मुख्य चिंता यह है कि जब वे स्वयं **मर जाएँगे (crumble)**, तो दुनिया में **कोई भी उस सुंदर स्त्री को याद नहीं रखेगा**।', 'The poet believes she was the **most beautiful lady ever born in the West Country**. However, he is deeply saddened by the truth that physical beauty fades with death, and laments that once he himself dies (**"crumbles"**), **nobody will remember her**.',
    $json$[{"cue_hi":"वेस्ट कंट्री की सबसे सुंदर स्त्री","cue_en":"Most beautiful lady in West Country"},{"cue_hi":"कवि के मरने (crumble) के बाद कोई याद नहीं रखेगा","cue_en":"After poet crumbles, no one will remember her"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"वेस्ट कंट्री की सबसे सुंदर स्त्री होने का उल्लेख","criterion_en":"States poet's view of her unmatched beauty in West Country"},{"step_no":2,"marks":1,"criterion_hi":"कवि के मरने के बाद भुला दिए जाने की चिंता का उल्लेख","criterion_en":"Explains sorrow that no one will remember her after he crumbles"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0010-4000-8000-000000000014', 'bseb-12-lang1-eng', 'bseb-12-eng-ch5', 'Poem Summary 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB 2024',
    '"An Epitaph" कविता का सारांश लिखें और इसका दार्शनिक संदेश स्पष्ट करें।',
    'Write a summary of Walter de la Mare''s poem "An Epitaph" and state its philosophical message.',
    NULL, NULL,
    'कवि, समाधि-लेख का अर्थ, वेस्ट कंट्री की स्त्री, "light of step and heart", "beauty vanishes" और "crumble" लिखें।', 'Cover Walter de la Mare, epitaph meaning, West Country lady, light of step/heart, beauty vanishes, and crumble.',
    NULL, NULL,
    '**"An Epitaph"** प्रसिद्ध अंग्रेज़ी कवि **वाल्टर डी ला मेयर** (जिन्हें *Children''s Poet* भी कहा जाता है) द्वारा रचित एक अत्यंत मार्मिक और उदास लघु कविता है।

कवि एक कब्र (समाधि-लेख) के पास खड़े होकर **वेस्ट कंट्री की सबसे सुंदर स्त्री** को याद करते हैं जो उस कब्र में सोई हुई है। वह अत्यंत आकर्षक और चंचल स्वभाव (*light of step and heart*) की थी। किंतु कवि जीवन का गहरा दार्शनिक सत्य उजागर करते हैं कि **शारीरिक सौंदर्य कितना भी दुर्लभ क्यों न हो, वह क्षणभंगुर है — समय और मृत्यु के साथ मिट जाता है** (*beauty vanishes; beauty passes*)।

कवि को इस बात का गहरा दुख है कि केवल वे ही सच्चे प्रेम के कारण आज उसे याद करते हैं; जब वे स्वयं **मर जाएँगे (crumble)**, तो संसार में उसे याद करने वाला कोई न रहेगा। यह कविता सिखाती है कि बाहरी रूप नहीं, बल्कि **नेक कर्म और चरित्र ही अमर रहते हैं**।', '**"An Epitaph"** is a short, deeply melancholic lyric composed by **Walter de la Mare**, celebrated as the **Children''s Poet** and recipient of the **Order of Merit (1953)**.

Standing beside a gravestone (epitaph), the poet mourns a woman whom he believes was the **most beautiful lady ever born in the West Country**. She was **"light of step and heart"**, carefree and proud of her rare charm. Yet the poet reflects on an eternal philosophical truth: **physical beauty is transient — it vanishes and passes away, however rare it may be**.

In a haunting conclusion, the poet laments that once he himself dies (**"crumbles"**), **nobody will remember this lady of the West Country**. The poem conveys a lasting moral: outer beauty fades with death, while **love, character, and noble deeds alone endure**.',
    $json$[{"cue_hi":"Walter de la Mare · Children's Poet · Melancholic","cue_en":"Walter de la Mare · Children's Poet · Melancholic"},{"cue_hi":"Most beautiful lady of West Country · Light of step & heart","cue_en":"Most beautiful lady of West Country · Light of step & heart"},{"cue_hi":"Beauty vanishes, beauty passes (transient)","cue_en":"Beauty vanishes, beauty passes (transient)"},{"cue_hi":"When I crumble (die), who will remember?","cue_en":"When I crumble (die), who will remember?"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"कवि (Walter de la Mare) व समाधि-लेख (epitaph) का परिचय","criterion_en":"Names Walter de la Mare and context of the epitaph"},{"step_no":2,"marks":1.5,"criterion_hi":"वेस्ट कंट्री की सुंदर स्त्री व \"light of step and heart\"","criterion_en":"Describes West Country lady and \"light of step and heart\""},{"step_no":3,"marks":1.5,"criterion_hi":"सौंदर्य की नश्वरता (\"beauty vanishes\") व कवि का \"crumble\" विलाप","criterion_en":"Explains transience of beauty and poet's \"crumble\" lament"},{"step_no":4,"marks":1,"criterion_hi":"आंतरिक सद्गुण व कर्म के अमर होने का दार्शनिक संदेश","criterion_en":"Concludes with enduring value of love and noble deeds"}]$json$::jsonb,
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
-- CHAPTER 11 OF 14: BSEB-9-ENG-CH1 — Dharam Juddha — Arjun Dev Charan
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-9-eng-ch1',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: धर्म युद्ध (Dharam Juddha)",
  "title_en": "30-Second Mindmap: Dharam Juddha",
  "read_time_seconds": 30,
  "central_node": {
    "id": "dj-root",
    "label_hi": "धर्म युद्ध (Dharam Juddha)",
    "label_en": "Dharam Juddha (A Play)",
    "subtitle_hi": "अर्जुन देव चारण · Panorama Part-1 (कक्षा 9, अध्याय 1)",
    "subtitle_en": "Arjun Dev Charan · Panorama Part-1 (Class 9, Ch 1)"
  },
  "branches": [
    {
      "id": "dj-author",
      "label_hi": "1. लेखक परिचय (Author)",
      "label_en": "1. About the Playwright",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "dj-a1",
          "label_hi": "अर्जुन देव चारण (जन्म 1954, जोधपुर, राजस्थान)",
          "label_en": "Arjun Dev Charan (born 1954, Jodhpur, Rajasthan)",
          "detail_hi": "प्रसिद्ध राजस्थानी कवि, नाटककार व रंगमंच निर्देशक।",
          "detail_en": "Renowned Rajasthani poet, playwright, and theatre director."
        },
        {
          "id": "dj-a2",
          "label_hi": "साहित्य अकादमी पुरस्कार (1992)",
          "label_en": "Sahitya Akademi Award (1992)",
          "detail_hi": "उनकी नाट्य कृति \"धर्म युद्ध\" के लिए सम्मानित।",
          "detail_en": "Honoured for his acclaimed play collection \"Dharam Judh\"."
        }
      ]
    },
    {
      "id": "dj-chars",
      "label_hi": "2. मुख्य पात्र (Characters)",
      "label_en": "2. Main Characters",
      "color": "#059669",
      "children": [
        {
          "id": "dj-c1",
          "label_hi": "पद्मा (Padma): शिक्षित, जिज्ञासु व साहसी लड़की",
          "label_en": "Padma: Educated, questioning young girl",
          "detail_hi": "रामायण व महाभारत से संस्कारित, पर नारी की स्वतंत्र पहचान पर प्रश्न उठाती है।",
          "detail_en": "Shaped by Ramayana & Mahabharata, yet questions women's independent identity."
        },
        {
          "id": "dj-c2",
          "label_hi": "माँ और पिता (Mother & Father): परंपरावादी सोच",
          "label_en": "Mother & Father: Orthodox outlook",
          "detail_hi": "मानते हैं कि विवाह और पति से ही स्त्री की पहचान बनती है।",
          "detail_en": "Believe marriage and husband alone give a woman her identity."
        }
      ]
    },
    {
      "id": "dj-story",
      "label_hi": "3. मुख्य संवाद व तर्क",
      "label_en": "3. Core Dialogue & Conflict",
      "color": "#D97706",
      "children": [
        {
          "id": "dj-s1",
          "label_hi": "पद्मा का पहला सवाल: \"एक स्त्री की पहचान क्या है?\"",
          "label_en": "Padma's key question: \"What is the identity of a woman?\""
        },
        {
          "id": "dj-s2",
          "label_hi": "तर्क: अगर लड़की की शादी न हो या पति न रहे, तो क्या उसका अस्तित्व खत्म?",
          "label_en": "Challenge: Does an unmarried woman or widow have no identity?"
        }
      ]
    },
    {
      "id": "dj-exam",
      "label_hi": "4. संदेश और परीक्षा फोकस",
      "label_en": "4. Message & Exam Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "dj-e1",
          "label_hi": "नारी को भी पुरुष के समान सम्मान व स्वतंत्र पहचान का अधिकार है।",
          "label_en": "Women deserve equal dignity and independent identity."
        },
        {
          "id": "dj-e2",
          "label_hi": "बार-बार आने वाले प्रश्न: पद्मा का चरित्र, माँ के विचार, विवाह व पहचान।",
          "label_en": "Top exam questions: Padma's character, Mother's view, marriage & identity."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "dj-sec-1-author",
    "order": 1,
    "heading_hi": "1. लेखक परिचय और बिहार के घर-आँगन से जुड़ाव",
    "heading_en": "1. Author Profile & Everyday Bihar Connection",
    "analogy_hi": "सोचिए हमारे गाँव या कस्बे में जब कोई पढ़ी-लिखी बेटी पूछती है — *\"पापा, क्या मेरी पहचान सिर्फ़ शादी के बाद ससुराल के नाम से होगी? मैं पढ़कर डॉक्टर या टीचर बनकर अपनी पहचान क्यों नहीं बना सकती?\"* — तो घर में बहस छिड़ जाती है! ठीक यही संवेदनशील बातचीत **अर्जुन देव चारण** ने अपने छोटे से नाटक **Dharam Juddha** में पद्मा और उसके माता-पिता के बीच दिखाई है।",
    "analogy_en": "Imagine an educated daughter in a Bihar town asking her parents: *\"Will my identity exist only after marriage? Why can I not have my own identity as a human being?\"* That honest household conversation is the heart of **Arjun Dev Charan's** short play **Dharam Juddha**.",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "लेखक और पाठ की मुख्य पहचान (एक नज़र में)",
      "title_en": "Author & Text Highlights at a Glance",
      "caption_hi": "अर्जुन देव चारण का जन्म राजस्थान में हुआ और उन्होंने भारतीय समाज में स्त्री-सम्मान पर गहरे प्रश्न उठाए।",
      "caption_en": "Arjun Dev Charan from Rajasthan raised bold questions on women's dignity in Indian society.",
      "events": [
        {
          "year": "1954",
          "title_hi": "जन्म — मथानिया (जोधपुर, राजस्थान)",
          "title_en": "Born — Mathania (Jodhpur, Rajasthan)",
          "detail_hi": "10 मई 1954 को जन्म; पेशे से प्राध्यापक, कवि और रंगमंच निर्देशक।",
          "detail_en": "Born 10 May 1954; professor, poet, playwright, and theatre director."
        },
        {
          "year": "1992",
          "title_hi": "साहित्य अकादमी पुरस्कार (\"धर्म युद्ध\")",
          "title_en": "Sahitya Akademi Award (\"Dharam Judh\")",
          "detail_hi": "राजस्थानी नाट्य-संग्रह के लिए भारत का प्रतिष्ठित साहित्य सम्मान।",
          "detail_en": "Awarded India's prestigious Sahitya Akademi Award for Rajasthani drama.",
          "highlight": true
        },
        {
          "year": "BSEB Ch 1",
          "title_hi": "Panorama Part-1 का पहला अध्याय",
          "title_en": "Opening Chapter of Panorama Part-1",
          "detail_hi": "पद्मा (Padma), उसकी माँ और पिता के बीच संवाद द्वारा नारी-समानता का संदेश।",
          "detail_en": "Dialogue between Padma, her Mother, and Father advocating gender equality.",
          "highlight": true
        }
      ]
    },
    "concept_md_hi": "### पाठ का मूल परिचय (हिंदी में आसान समझ)\n- **विधा (Genre):** यह एक **नाटक / एकांकी (Play / Drama)** है, जिसमें संवाद (Dialogues) के माध्यम से बात आगे बढ़ती है।\n- **शीर्षक का अर्थ:** *Dharam Juddha* (धर्म युद्ध) का अर्थ यहाँ तलवार की लड़ाई नहीं, बल्कि **सत्य, न्याय और स्त्री-समानता के लिए विचारों की लड़ाई** है।\n- **पद्मा कौन है?** पद्मा एक युवा, शिक्षित लड़की है जिसकी सोच **रामायण और महाभारत** जैसे महाकाव्यों से बनी है। वह गलत रीति-रिवाजों पर चुप रहने के बजाय तर्क से सवाल करती है।",
    "concept_md_en": "### Core Introduction\n- **Genre:** A short **Play (Drama)** written in crisp dialogue form.\n- **Meaning of Title:** *Dharam Juddha* means a **righteous struggle** — here, a moral struggle against unfair orthodox beliefs about women.\n- **Who is Padma?** Padma is a young, educated girl shaped by Indian epics like the **Ramayana** and **Mahabharata**, who courageously questions social inequality.",
    "exam_tip_hi": "ऑब्जेक्टिव ट्रिक: \"Dharam Juddha\" के लेखक **Arjun Dev Charan** हैं और यह एक **Play (नाटक)** है — कहानी (Story) या कविता (Poem) नहीं!",
    "exam_tip_en": "MCQ Shortcut: \"Dharam Juddha\" is a **Play** written by **Arjun Dev Charan** — never confuse it with an essay or poem!",
    "glossary_terms": [
      {
        "term_hi": "Identity (आइडेंटिटी)",
        "term_en": "Identity",
        "pronunciation_hi": "आइडेंटिटी",
        "definition_hi": "व्यक्ति की अपनी स्वतंत्र पहचान या अस्तित्व।",
        "definition_en": "Who a person is; one's own independent individuality."
      },
      {
        "term_hi": "Orthodox (ऑर्थोडॉक्स)",
        "term_en": "Orthodox",
        "pronunciation_hi": "ऑर्थोडॉक्स",
        "definition_hi": "पुरानी रूढ़िवादी या परंपरागत सोच को बिना सवाल माने रहना।",
        "definition_en": "Holding strictly to old traditional beliefs without questioning them."
      }
    ]
  },
  {
    "id": "dj-sec-2-storyboard",
    "order": 2,
    "heading_hi": "2. हिंदी-प्रथम विज़ुअल स्टोरीबोर्ड (पूरा नाटक 4 कदमों में)",
    "heading_en": "2. Hindi-First Visual Storyboard (Whole Play in 4 Steps)",
    "analogy_hi": "इसे एक टीवी धारावाहिक के 4 छोटे दृश्यों (Scenes) की तरह देखिए — पहले पद्मा माँ से पूछती है, फिर पिता से पूछती है, फिर तीखे तर्क रखती है, और अंत में दर्शक सोचने पर मजबूर हो जाते हैं!",
    "analogy_en": "Watch the play unfold like 4 crisp scenes on stage: Padma asks her Mother, challenges her Father, exposes the unfair double standard, and leaves us reflecting on equality.",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "धर्म युद्ध (Dharam Juddha) — दृश्य-दर-दृश्य कथा प्रवाह",
      "title_en": "Dharam Juddha — Scene-by-Scene Storyboard",
      "caption_hi": "पद्मा के हर सवाल से परंपरागत सोच की कमज़ोरी सामने आती है।",
      "caption_en": "Each question from Padma exposes the flaw in narrow orthodox thinking.",
      "direction": "TB",
      "steps": [
        {
          "id": "dj-step1",
          "label_hi": "दृश्य 1: पद्मा का माँ से पहला सवाल",
          "label_en": "Scene 1: Padma Questions Her Mother",
          "detail_hi": "पद्मा पूछती है: \"माँ, एक औरत की अपनी पहचान क्या है?\" माँ इसे \"बेतुका (senseless)\" कहकर टालती हैं।",
          "detail_en": "Padma asks: \"Mother, what is the identity of a woman?\" Mother calls the question \"senseless\".",
          "accent": "indigo"
        },
        {
          "id": "dj-step2",
          "label_hi": "दृश्य 2: माँ की रूढ़िवादी धारणा",
          "label_en": "Scene 2: Mother's Traditional Belief",
          "detail_hi": "माँ कहती हैं: \"मेरी पहचान तुम्हारे पिता से जुड़ी है। बिना पति के औरत की ज़िंदगी नर्क (hell) जैसी होती है।\"",
          "detail_en": "Mother replies: \"My identity is linked to your father. Life is hell for a woman without a husband.\"",
          "accent": "amber"
        },
        {
          "id": "dj-step3",
          "label_hi": "दृश्य 3: पिता का उत्तर और पद्मा की पीड़ा",
          "label_en": "Scene 3: Father's View & Padma's Pain",
          "detail_hi": "पिता कहते हैं: \"शादी ही स्त्री को पहचान देती है।\" पद्मा दुखी होती है कि पिता स्नेह से ज़्यादा पैसे की परवाह करते हैं।",
          "detail_en": "Father insists: \"Marriage lends identity to a woman.\" Padma feels Father cares more for money than affection.",
          "accent": "slate"
        },
        {
          "id": "dj-step4",
          "label_hi": "दृश्य 4: पद्मा का निर्णायक तर्क (धर्म युद्ध)",
          "label_en": "Scene 4: Padma's Bold Logic",
          "detail_hi": "पद्मा पूछती है: \"अगर कोई लड़की शादी न करे, या शादी के बाद पति न रहे, तो क्या उसकी कोई पहचान नहीं? समाज यह अन्याय क्यों करता है?\"",
          "detail_en": "Padma asks: \"What if a girl does not marry, or her husband dies? Why does society deny women independent dignity?\"",
          "accent": "emerald"
        }
      ],
      "edges": [
        {
          "from": "dj-step1",
          "to": "dj-step2",
          "label_hi": "माँ का जवाब",
          "label_en": "Mother replies"
        },
        {
          "from": "dj-step2",
          "to": "dj-step3",
          "label_hi": "पिता का प्रवेश",
          "label_en": "Father enters"
        },
        {
          "from": "dj-step3",
          "to": "dj-step4",
          "label_hi": "पद्मा का प्रतिप्रश्न",
          "label_en": "Padma counters"
        }
      ]
    },
    "concept_md_hi": "### कहानी का पूरा सार (सरल भाषा में)\n1. नाटक की शुरुआत में **पद्मा** अपनी **माँ** से पूछती है कि समाज में एक स्त्री की वास्तविक पहचान क्या है।\n2. माँ परंपरागत विचारों की हैं — वे कहती हैं कि वे अपने पति से अलग नहीं हैं और **बिना पति के स्त्री का जीवन नर्क (hell) के समान है**।\n3. पद्मा को लगता है कि उसके **पिता** उससे भावनात्मक रूप से दूर हैं और वे **बेटी से अधिक धन (money)** को महत्व देते हैं।\n4. पिता भी यही दोहराते हैं कि **विवाह (marriage)** ही स्त्री को पहचान देता है। तब पद्मा साहसपूर्वक पूछती है कि अविवाहित स्त्री या विधवा का सम्मान और अस्तित्व क्यों छीना जाता है? यही अन्याय के विरुद्ध उसका **धर्म युद्ध** है।",
    "concept_md_en": "### Complete Plot Summary\n1. The play opens with **Padma** asking her **Mother** about a woman's true identity.\n2. Her orthodox Mother insists her identity is tied solely to her husband, claiming **life is like hell** for a woman without a husband.\n3. Padma feels her **Father** is emotionally distant and values **money** more than his daughter.\n4. When her Father declares that **marriage lends identity to a woman**, Padma boldly challenges this injustice by asking about unmarried women and widows — launching her moral **Dharam Juddha**.",
    "exam_tip_hi": "याद रखें: माँ के अनुसार पद्मा का प्रश्न **\"senseless (बेतुका)\"** था, और पिता के अनुसार **\"marriage (विवाह)\"** स्त्री को पहचान देता है।",
    "exam_tip_en": "Exam Key: Mother calls Padma's question **\"senseless\"**, and Father claims **\"marriage\"** gives identity to a woman.",
    "glossary_terms": [
      {
        "term_hi": "Senseless (सेंसलेस)",
        "term_en": "Senseless",
        "pronunciation_hi": "सेंसलेस",
        "definition_hi": "बेतुका, बिना मतलब का।",
        "definition_en": "Foolish or without meaning."
      },
      {
        "term_hi": "Injustice (इनजस्टिस)",
        "term_en": "Injustice",
        "pronunciation_hi": "इनजस्टिस",
        "definition_hi": "अन्याय, भेदभाव।",
        "definition_en": "Lack of fairness or justice."
      }
    ],
    "quick_check": {
      "q_hi": "पिता के अनुसार स्त्री को उसकी पहचान किस चीज़ से मिलती है?",
      "q_en": "According to Padma's father, what lends identity to a woman?",
      "answer_hi": "विवाह (Marriage) से।",
      "answer_en": "Marriage."
    }
  },
  {
    "id": "dj-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ सहित",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "अंग्रेज़ी संवाद से डरिए मत! नीचे हर कठिन अंग्रेज़ी शब्द का हिंदी उच्चारण दिया है — इन्हें ज़ोर से बोलकर पढ़िए, 2 मिनट में पूरा पाठ याद हो जाएगा।",
    "analogy_en": "Never fear English dialogue! Read each key line aloud with the Hindi pronunciation guide below and the meaning will stick immediately.",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "पाठ की सबसे ज़रूरी अंग्रेज़ी पंक्तियाँ (उच्चारण + अर्थ)",
      "title_en": "Must-Know Lines from Dharam Juddha (Pronunciation + Meaning)",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति (Textbook Line)",
        "हिंदी उच्चारण (How to Say)",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "Key Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "What is the identity of a woman?",
            "व्हॉट इज़ द आइडेंटिटी ऑफ़ अ वुमन?",
            "एक स्त्री की पहचान क्या है?"
          ],
          "cells_en": [
            "What is the identity of a woman?",
            "What iz the aai-den-ti-tee of a wu-man?",
            "Padma's opening question on women's individuality."
          ]
        },
        {
          "cells_hi": [
            "Life is hell for the woman whose husband is dead.",
            "लाइफ़ इज़ हेल फ़ॉर द वुमन हूज़ हज़बैंड इज़ डेड।",
            "जिस स्त्री का पति नहीं रहा, उसके लिए जीवन नर्क है।"
          ],
          "cells_en": [
            "Life is hell for the woman whose husband is dead.",
            "Laif iz hel for the wu-man hooz haz-band iz ded.",
            "Mother's orthodox belief about widowhood."
          ]
        },
        {
          "cells_hi": [
            "Marriage lends identity to a woman.",
            "मैरिज लेंड्स आइडेंटिटी टु अ वुमन।",
            "विवाह स्त्री को पहचान देता है।"
          ],
          "cells_en": [
            "Marriage lends identity to a woman.",
            "Ma-rij lendz aai-den-ti-tee too a wu-man.",
            "Father's traditional view that Padma challenges."
          ]
        },
        {
          "cells_hi": [
            "Why does a woman not get equal rights?",
            "व्हाई डज़ अ वुमन नॉट गेट ईक्वल राइट्स?",
            "स्त्री को बराबर के अधिकार क्यों नहीं मिलते?"
          ],
          "cells_en": [
            "Why does a woman not get equal rights?",
            "Whaai daz a wu-man not get ee-kwal raits?",
            "The central protest of the play."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का उच्चारण अभ्यास (बोलकर पढ़ें)\n1. **Identity** (*आइडेंटिटी*) = पहचान\n2. **Marriage** (*मैरिज*) = विवाह\n3. **Unjust** (*अनजस्ट*) = अन्यायपूर्ण\n4. **Affection** (*अफ़ेक्शन*) = स्नेह / प्रेम\n5. **Society** (*सोसायटी*) = समाज\n6. **Equality** (*इक्वालिटी*) = समानता",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Identity** (*आइडेंटिटी*) = individuality\n2. **Marriage** (*मैरिज*) = wedding / matrimony\n3. **Unjust** (*अनजस्ट*) = unfair\n4. **Affection** (*अफ़ेक्शन*) = love and warmth\n5. **Society** (*सोसायटी*) = community\n6. **Equality** (*इक्वालिटी*) = equal status and rights",
    "exam_tip_hi": "यदि परीक्षा में स्पेलिंग भूल जाएँ तो शब्द को तोड़कर याद करें: **I-den-ti-ty** (आई-डें-टि-टी) और **Mar-ri-age** (मै-रि-ज)।",
    "exam_tip_en": "Spelling tip: Break long words into beats: **I-den-ti-ty** and **Mar-ri-age**.",
    "glossary_terms": [
      {
        "term_hi": "Affection (अफ़ेक्शन)",
        "term_en": "Affection",
        "pronunciation_hi": "अफ़ेक्शन",
        "definition_hi": "माता-पिता या अपनों का गहरा प्रेम और स्नेह।",
        "definition_en": "Gentle feeling of love, care, and fondness."
      },
      {
        "term_hi": "Equality (इक्वालिटी)",
        "term_en": "Equality",
        "pronunciation_hi": "इक्वालिटी",
        "definition_hi": "पुरुष और स्त्री दोनों को समान अधिकार व सम्मान मिलना।",
        "definition_en": "Having the same rights, respect, and opportunities."
      },
      {
        "term_hi": "Lend (लेंड)",
        "term_en": "Lend",
        "pronunciation_hi": "लेंड",
        "definition_hi": "देना या प्रदान करना (जैसे: marriage lends identity)।",
        "definition_en": "To give or provide (as in \"lends identity\")."
      }
    ]
  },
  {
    "id": "dj-sec-4-contrast",
    "order": 4,
    "heading_hi": "4. पात्रों की तुलना और 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Character Contrast & 5-Mark Summary Formula",
    "analogy_hi": "परीक्षा में लंबा उत्तर रटने की ज़रूरत नहीं! सिर्फ़ नीचे की तुलना तालिका और 5 आसान वाक्य याद कर लें — आपको 5 में से 5 अंक आराम से मिलेंगे।",
    "analogy_en": "No need to cram long essays! Master the character contrast table and 5 short sentences below to score full marks.",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "पद्मा बनाम माता-पिता (विचारों का अंतर)",
      "title_en": "Padma vs Her Parents (Clash of Ideas)",
      "headers_hi": [
        "विषय (Topic)",
        "पद्मा की आधुनिक सोच",
        "माता-पिता की परंपरागत सोच"
      ],
      "headers_en": [
        "Topic",
        "Padma's Progressive View",
        "Parents' Orthodox View"
      ],
      "rows": [
        {
          "cells_hi": [
            "स्त्री की पहचान",
            "स्त्री की अपनी स्वतंत्र पहचान होनी चाहिए।",
            "स्त्री की पहचान केवल पति व विवाह से होती है।"
          ],
          "cells_en": [
            "Woman's Identity",
            "A woman has her own independent identity.",
            "A woman's identity comes only from marriage/husband."
          ]
        },
        {
          "cells_hi": [
            "विधवा / अविवाहित जीवन",
            "उनका भी सम्मानपूर्ण स्वतंत्र अस्तित्व है।",
            "बिना पति के स्त्री का जीवन नर्क समान है।"
          ],
          "cells_en": [
            "Unmarried / Widow",
            "They deserve full dignity and respect.",
            "Life without a husband is like hell."
          ]
        },
        {
          "cells_hi": [
            "पारिवारिक मूल्य",
            "प्रेम, संवाद और समानता सबसे बड़ी है।",
            "धन और पुरानी सामाजिक प्रथाएँ सर्वोपरि हैं।"
          ],
          "cells_en": [
            "Family Values",
            "Affection, dialogue, and equality come first.",
            "Money and social customs come first."
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक उत्तर का आसान 5-वाक्य फ़ॉर्मूला (कॉपी में सीधा लिखें)\n1. **\"Dharam Juddha\"** is a meaningful play written by **Arjun Dev Charan**.\n2. Its main character is **Padma**, a young and educated girl.\n3. She asks her **Mother** and **Father** about the true identity of a woman.\n4. Her orthodox parents say that **marriage** gives a woman her identity.\n5. Padma challenges this unfair thinking and demands **equal rights and respect** for women.",
    "concept_md_en": "### Easy 5-Sentence Board Summary Formula (Score 5/5!)\n1. **\"Dharam Juddha\"** is a meaningful play written by **Arjun Dev Charan**.\n2. Its main character is **Padma**, a young and educated girl.\n3. She asks her **Mother** and **Father** about the true identity of a woman.\n4. Her orthodox parents say that **marriage** gives a woman her identity.\n5. Padma challenges this unfair thinking and demands **equal rights and respect** for women.",
    "exam_tip_hi": "कॉपी में लेखक का नाम **Arjun Dev Charan** और मुख्य पात्र **Padma** को हमेशा पेंसिल से अंडरलाइन करें!",
    "exam_tip_en": "Always underline **Arjun Dev Charan** and **Padma** cleanly in your exam booklet!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "पद्मा को अपने पिता से क्या शिकायत है?",
      "q_en": "What is Padma's complaint against her father?",
      "answer_hi": "पद्मा को लगता है कि उसके पिता अपनी बेटी से ज़्यादा पैसे (money) की परवाह करते हैं।",
      "answer_en": "Padma feels her father cares more for money than for his own daughter."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Author",
      "fact_hi": "अर्जुन देव चारण (जन्म 1954, जोधपुर, राजस्थान)",
      "fact_en": "Arjun Dev Charan (born 1954, Jodhpur, Rajasthan)"
    },
    {
      "tag": "Book & Genre",
      "fact_hi": "Panorama Part-1 (Class 9, Ch 1) · विधा: Play (नाटक)",
      "fact_en": "Panorama Part-1 (Class 9, Ch 1) · Genre: Play (Drama)"
    },
    {
      "tag": "Award",
      "fact_hi": "1992 में \"धर्म युद्ध\" के लिए साहित्य अकादमी पुरस्कार",
      "fact_en": "1992 Sahitya Akademi Award for \"Dharam Judh\""
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Dharam Juddha is a thought-provoking play by Arjun Dev Charan.",
      "fact_en": "Dharam Juddha is a thought-provoking play by Arjun Dev Charan."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "Padma is a bold, educated young girl shaped by Indian epics.",
      "fact_en": "Padma is a bold, educated young girl shaped by Indian epics."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "She asks her parents what the real identity of a woman is.",
      "fact_en": "She asks her parents what the real identity of a woman is."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "Her parents claim that marriage and husband alone give a woman identity.",
      "fact_en": "Her parents claim that marriage and husband alone give a woman identity."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "Padma protests this injustice and stands up for women's equality and dignity.",
      "fact_en": "Padma protests this injustice and stands up for women's equality and dignity."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "Dharam Juddha को \"Story\" या \"Essay\" लिख देना।",
      "mistake_en": "Calling Dharam Juddha a short story or essay.",
      "fix_hi": "यह संवाद रूप में लिखा गया **Play (नाटक)** है।",
      "fix_en": "Always write that it is a **Play (Drama)** in dialogue form."
    },
    {
      "mistake_hi": "Padma को माँ का नाम समझ लेना।",
      "mistake_en": "Confusing Padma with the mother.",
      "fix_hi": "याद रखें: **Padma** युवा बेटी है जो माँ और पिता से सवाल पूछती है।",
      "fix_en": "Remember: **Padma** is the young daughter questioning her Mother and Father."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "पद्मा का चरित्र-चित्रण व उसके प्रश्न",
      "topic_en": "Character Sketch of Padma & Her Questions",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "माँ और पिता के अनुसार स्त्री की पहचान",
      "topic_en": "Parents' View on a Woman's Identity",
      "years": [
        "2021",
        "2023"
      ],
      "expected_marks": 2
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-9-eng-ch1',
  2,
  'छात्र "Dharam Juddha" के लेखक, पात्रों और मुख्य संवाद को समझ सकेंगे; मुख्य अंग्रेज़ी शब्दों का सही उच्चारण कर सकेंगे और 5 वाक्यों में पाठ का सारांश लिख सकेंगे।',
  'Students will understand the playwright, characters, and dialogue of "Dharam Juddha", pronounce key English words accurately, and write a clean 5-sentence summary.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "हिंदी स्टोरी हुक, उच्चारण अभ्यास व ब्लैकबोर्ड पात्र-चित्र",
    "phase_en": "Hindi Story Hook, Read-Aloud Drill & Character Diagram",
    "teacher_action_hi": "पहले 5 मिनट हिंदी में पूछें: \"क्या लड़कियों की अपनी अलग पहचान होनी चाहिए?\" फिर 3 छात्रों को पद्मा, माँ और पिता की भूमिका देकर मुख्य 6 संवाद बुलवाएँ। Identity (आइडेंटिटी), Marriage (मैरिज), Orthodox (ऑर्थोडॉक्स) का सामूहिक उच्चारण कराएँ और बोर्ड पर पद्मा बनाम माता-पिता का चार्ट बनाएँ।",
    "teacher_action_en": "Open with a 5-min Hindi discussion on girls' independent identity. Assign 3 students to read Padma, Mother, and Father. Drill chorus pronunciation of Identity, Marriage, Orthodox, and draw a Padma vs Parents board chart.",
    "student_check_hi": "कमज़ोर छात्रों से पूछें: \"इस नाटक की मुख्य लड़की का नाम क्या है और लेखक कौन हैं?\"",
    "student_check_en": "Ask struggling students: \"Who is the main girl in the play and who wrote it?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "वाक्य निर्माण, 5-मिनट मौखिक आत्मविश्वास गतिविधि व 5-अंक सारांश",
    "phase_en": "Sentence Building, 5-Min Oral Confidence Drill & 5-Mark Summary",
    "teacher_action_hi": "ब्लैकबोर्ड पर 5-वाक्य सारांश फ़ॉर्मूला लिखें। प्रत्येक पंक्ति को एक छात्र से खड़े होकर पढ़वाएँ (5-मिनट मौखिक आत्मविश्वास गतिविधि)। अंत में 5 मिनट का त्वरित MCQ अभ्यास लें और सामान्य परीक्षा गलतियाँ समझाएँ।",
    "teacher_action_en": "Write the 5-sentence summary skeleton on the board. Run a 5-min oral confidence chain where shy students speak 1 short line each. Close with a 5-min rapid MCQ check.",
    "student_check_hi": "हर छात्र से बिना देखे सारांश के पहले 2 वाक्य कॉपी में लिखवाएँ।",
    "student_check_en": "Have every student write the first 2 summary sentences from memory."
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड पात्र व विषय बॉक्स (Dharam Juddha)",
    "heading_en": "Blackboard Character & Theme Box",
    "points_hi": [
      "पाठ: Dharam Juddha (Play) | लेखक: Arjun Dev Charan (राजस्थान, 1992 साहित्य अकादमी)",
      "Padma (पद्मा): शिक्षित, तार्किक बेटी — नारी-समानता की आवाज़",
      "Mother (माँ): प्रश्न को \"senseless\" कहती हैं; पति के बिना जीवन = hell",
      "Father (पिता): कहते हैं \"Marriage lends identity to a woman\""
    ],
    "points_en": [
      "Text: Dharam Juddha (Play) | Playwright: Arjun Dev Charan (Sahitya Akademi 1992)",
      "Padma: Educated, bold daughter demanding women's equal dignity",
      "Mother: Calls question \"senseless\"; links her identity only to husband",
      "Father: Claims \"Marriage lends identity to a woman\""
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"गूँज पठन\" (Echo Reading) मौखिक आत्मविश्वास गतिविधि",
    "title_en": "5-Minute Echo Reading Oral Confidence Activity",
    "materials_hi": "पाठ्यपुस्तक व ब्लैकबोर्ड पर लिखे 4 मुख्य अंग्रेज़ी संवाद",
    "materials_en": "Textbook and 4 key English lines on the blackboard",
    "steps_hi": "शिक्षक एक छोटा वाक्य स्पष्ट उच्चारण से बोलें (\"What is the identity of a woman?\") और पूरी कक्षा एक साथ दोहराए। फिर सबसे पीछे बैठे 4 छात्रों से 1-1 वाक्य अकेले बुलवाकर ताली बजवाएँ।",
    "steps_en": "Teacher speaks 1 short line clearly; whole class echoes in chorus. Then invite 4 shy back-bench students to say 1 line each and applaud every attempt."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Identity, Marriage, Affection, Society और Equality को 5-5 बार स्पेलिंग व हिंदी अर्थ सहित लिखें।",
    "task_en": "Write Identity, Marriage, Affection, Society, and Equality 5 times each with meanings."
  },
  {
    "level": "BOARD",
    "task_hi": "पद्मा के माता-पिता की सोच और पद्मा की सोच के बीच 3 अंतर लिखें।",
    "task_en": "Write 3 differences between Padma's outlook and her parents' traditional views."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "5-वाक्य सारांश फ़ॉर्मूले का उपयोग कर \"Dharam Juddha\" का स्वच्छ सारांश बिना देखे लिखें।",
    "task_en": "Write a neat 5-sentence summary of \"Dharam Juddha\" from memory."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र शीर्षक \"Dharam Juddha\" पढ़कर सोचते हैं कि यह महाभारत के युद्ध की कहानी है।",
    "misconception_en": "Students assume \"Dharam Juddha\" is a war story from the Mahabharata.",
    "correction_hi": "स्पष्ट करें कि यहाँ \"धर्म युद्ध\" का अर्थ सामाजिक रूढ़ियों और स्त्री-अन्याय के विरुद्ध नैतिक संघर्ष है।",
    "correction_en": "Clarify that here it symbolizes a moral struggle for women's rights inside a modern household."
  },
  {
    "misconception_hi": "छात्र Arjun Dev Charan की जगह कोई अन्य भारतीय लेखक लिख देते हैं।",
    "misconception_en": "Students confuse Arjun Dev Charan with other authors in Panorama Part-1.",
    "correction_hi": "ट्रिक दें: \"अर्जुन ने महाभारत का धर्म युद्ध लड़ा → Arjun Dev Charan = Dharam Juddha!\"",
    "correction_en": "Memory hook: \"Arjun fought the Dharmayuddha → Arjun Dev Charan = Dharam Juddha!\""
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
  (
    '10000007-0011-4000-8000-000000000001', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Author & Genre', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB Class 9',
    'Dharam Juddha के लेखक और विधा क्या हैं?',
    'Who wrote Dharam Juddha and what is its genre?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Dharam Juddha (धर्म युद्ध) के लेखक, विधा और मुख्य पात्र कौन हैं?",
  "front_en": "Who is the author, genre, and main character of \"Dharam Juddha\"?",
  "back_hi": "लेखक: Arjun Dev Charan (राजस्थान, साहित्य अकादमी 1992) · विधा: Play (नाटक) · मुख्य पात्र: Padma (पद्मा)।",
  "back_en": "Author: Arjun Dev Charan (Rajasthan, Sahitya Akademi 1992) · Genre: Play · Protagonist: Padma.",
  "pronunciation_hi": "धरम युद्ध — अर्जुन देव चारण (प्ले)",
  "mnemonic_hi": "याद करने की ट्रिक: \"अर्जुन = धर्म युद्ध!\" (Arjun Dev Charan → Dharam Juddha)",
  "mnemonic_en": "Memory hook: \"Arjun fought the Dharam Juddha → Arjun Dev Charan!\""
}$json$::jsonb,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000002', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Key Vocabulary', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Identity और Orthodox का उच्चारण और अर्थ क्या है?',
    'What are the pronunciation and meaning of Identity and Orthodox?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Identity और Orthodox शब्दों का उच्चारण व हिंदी अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Identity\" and \"Orthodox\".",
  "back_hi": "Identity (आइडेंटिटी) = स्वतंत्र पहचान · Orthodox (ऑर्थोडॉक्स) = रूढ़िवादी / पुरानी परंपरा मानने वाला।",
  "back_en": "Identity = individuality / who a person is · Orthodox = holding strictly to old traditional beliefs.",
  "pronunciation_hi": "आइडेंटिटी · ऑर्थोडॉक्स",
  "mnemonic_hi": "ID कार्ड से याद रखें: ID = Identity (पहचान)!",
  "mnemonic_en": "Remember from ID Card: ID = Identity!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000003', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Character & Role Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB Class 9',
    'स्तंभ A के पात्र/तथ्य को स्तंभ B के सही विवरण से मिलाएँ:',
    'Match each character or fact in Column A with its correct role in Column B:',
    NULL, NULL,
    'याद करें किसने क्या कहा — पद्मा, माँ, पिता और लेखक।', 'Recall who said what: Padma, Mother, Father, and the Playwright.',
    'Arjun Dev Charan लेखक हैं, Padma मुख्य लड़की है, माँ प्रश्न को senseless कहती हैं, और पिता विवाह को पहचान का आधार मानते हैं।', 'Arjun Dev Charan is the playwright, Padma questions women''s identity, Mother calls it senseless, and Father links identity to marriage.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each character/fact to its role",
  "pairs": [
    {
      "id": "dj-p1",
      "left_hi": "Arjun Dev Charan",
      "left_en": "Arjun Dev Charan",
      "right_hi": "Dharam Juddha के नाटककार",
      "right_en": "Playwright of Dharam Juddha"
    },
    {
      "id": "dj-p2",
      "left_hi": "Padma (पद्मा)",
      "left_en": "Padma",
      "right_hi": "नारी की पहचान पर प्रश्न करने वाली शिक्षित लड़की",
      "right_en": "Educated girl questioning women's identity"
    },
    {
      "id": "dj-p3",
      "left_hi": "Padma's Mother (माँ)",
      "left_en": "Padma's Mother",
      "right_hi": "सवाल को \"senseless\" कहती हैं",
      "right_en": "Calls Padma's question \"senseless\""
    },
    {
      "id": "dj-p4",
      "left_hi": "Padma's Father (पिता)",
      "left_en": "Padma's Father",
      "right_hi": "मानते हैं विवाह ही स्त्री को पहचान देता है",
      "right_en": "Believes marriage lends identity to a woman"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000004', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'इस हिंदी वाक्य को सही अंग्रेज़ी में सजाएँ: "पद्मा एक शिक्षित लड़की है।"',
    'Arrange the tiles to build: "Padma is an educated girl"',
    NULL, NULL,
    'Subject (Padma) + is + an + adjective + noun। "educated" स्वर ध्वनि (ए) से शुरू होता है, इसलिए "an" लगेगा!', 'Subject + is + an + adjective + noun. Use "an" before vowel sound "educated".',
    'सही वाक्य: "Padma is an educated girl" (educated में स्वर ध्वनि होने से "an" आता है)।', 'Correct sentence: "Padma is an educated girl" ("an" precedes the vowel sound in educated).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "पद्मा एक शिक्षित लड़की है।",
  "prompt_en": "Build this exam-ready sentence from Dharam Juddha",
  "grammar_formula": "Subject + is + an + Adjective + Noun",
  "tokens": [
    "Padma",
    "is",
    "an",
    "educated",
    "girl"
  ],
  "distractors": [
    "are",
    "a"
  ],
  "correct_sentence": "Padma is an educated girl",
  "pronunciation_hi": "पद्मा इज़ ऐन एजुकेटेड गर्ल"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000005', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही अंग्रेज़ी वाक्य बनाएँ: "विवाह स्त्री को पहचान देता है।"',
    'Build the famous textbook line: "Marriage lends identity to a woman"',
    NULL, NULL,
    'Singular Subject (Marriage) के साथ Verb में "s" (lends) जुड़ता है।', 'Singular subject "Marriage" takes present verb "lends".',
    'पाठ्यपुस्तक की प्रमुख पंक्ति: "Marriage lends identity to a woman" — यह पद्मा के पिता कहते हैं।', 'Key textbook line spoken by Padma''s father: "Marriage lends identity to a woman".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "विवाह स्त्री को पहचान देता है।",
  "prompt_en": "Build Father's key statement from the play",
  "grammar_formula": "Subject + V1(s) + Object + to + Indirect Object",
  "tokens": [
    "Marriage",
    "lends",
    "identity",
    "to",
    "a",
    "woman"
  ],
  "distractors": [
    "lend",
    "an"
  ],
  "correct_sentence": "Marriage lends identity to a woman",
  "pronunciation_hi": "मैरिज लेंड्स आइडेंटिटी टु अ वुमन"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000006', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Author Identification', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 9 2023',
    '"Dharam Juddha" नाटक के लेखक कौन हैं?',
    'Who is the author of the play "Dharam Juddha"?',
    $json$[{"key":"A","text_hi":"डॉ. राजेंद्र प्रसाद","text_en":"Dr. Rajendra Prasad"},{"key":"B","text_hi":"सी. राजगोपालाचारी","text_en":"C. Rajagopalachari"},{"key":"C","text_hi":"अर्जुन देव चारण","text_en":"Arjun Dev Charan"},{"key":"D","text_hi":"महादेवी वर्मा","text_en":"Mahadevi Varma"}]$json$::jsonb, 'C',
    '"अर्जुन" और "धर्म युद्ध" का जोड़ा याद करें!', 'Use the hook: Arjun → Dharam Juddha!',
    '"Dharam Juddha" प्रसिद्ध राजस्थानी नाटककार अर्जुन देव चारण की रचना है।', '"Dharam Juddha" was written by renowned Rajasthani playwright Arjun Dev Charan.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000007', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Main Character', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 9 2022',
    '"Dharam Juddha" की मुख्य पात्र कौन है?',
    'Who is the central character of "Dharam Juddha"?',
    $json$[{"key":"A","text_hi":"पद्मा","text_en":"Padma"},{"key":"B","text_hi":"शर्मिष्ठा","text_en":"Sharmishtha"},{"key":"C","text_hi":"लक्ष्मी","text_en":"Lakshmi"},{"key":"D","text_hi":"देवयानी","text_en":"Devayani"}]$json$::jsonb, 'A',
    'वह शिक्षित युवा लड़की जो अपने माता-पिता से स्त्री की पहचान पूछती है।', 'The young educated girl who questions her parents about women''s identity.',
    'पद्मा (Padma) "Dharam Juddha" की मुख्य पात्र है।', 'Padma is the central character of "Dharam Juddha".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000008', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Mother''s Reaction', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Class 9 2024',
    'पद्मा की माँ के अनुसार जिस स्त्री का पति नहीं रहा उसका जीवन कैसा होता है?',
    'According to Padma''s mother, how is life for a woman whose husband is dead?',
    $json$[{"key":"A","text_hi":"स्वतंत्र (Independent)","text_en":"Independent"},{"key":"B","text_hi":"सुखमय (Joyful)","text_en":"Joyful"},{"key":"C","text_hi":"स्वर्ग जैसा (Like heaven)","text_en":"Like heaven"},{"key":"D","text_hi":"नर्क जैसा (Like hell)","text_en":"Like hell"}]$json$::jsonb, 'D',
    'माँ की परंपरागत सोच याद करें — उन्होंने एक कड़ा शब्द बोला था।', 'Recall Mother''s orthodox statement about widowhood.',
    'पद्मा की माँ परंपरावादी सोच रखती हैं और कहती हैं कि बिना पति के स्त्री का जीवन नर्क (hell) जैसा हो जाता है।', 'Padma''s orthodox mother says life becomes like hell for a woman without a husband.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000009', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Father''s Attitude', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Class 9 2023',
    'पद्मा को क्यों लगता है कि उसके पिता उससे अधिक किस चीज़ की परवाह करते हैं?',
    'What does Padma feel her father cares for more than his own daughter?',
    $json$[{"key":"A","text_hi":"यात्रा की (Travel)","text_en":"Travel"},{"key":"B","text_hi":"पैसे की (Money)","text_en":"Money"},{"key":"C","text_hi":"संगीत की (Music)","text_en":"Music"},{"key":"D","text_hi":"किताबों की (Books)","text_en":"Books"}]$json$::jsonb, 'B',
    'पद्मा पिता के साथ भावनात्मक दूरी की शिकायत करती है।', 'Padma complains that her father is too busy earning.',
    'पद्मा को लगता है कि उसके पिता उससे ज़्यादा पैसे (money) को महत्व देते हैं।', 'Padma feels her father cares more for money than for her.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000010', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Literary Theme', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB Class 9 2024',
    'पद्मा के विचार मुख्य रूप से किन भारतीय महाकाव्यों से संस्कारित हुए हैं?',
    'Padma''s identity and moral awareness are largely shaped by which Indian epics?',
    $json$[{"key":"A","text_hi":"पंचतंत्र और जातक","text_en":"Panchatantra and Jatakas"},{"key":"B","text_hi":"मेघदूत और अभिज्ञानशाकुंतलम्","text_en":"Meghaduta and Abhijnanashakuntalam"},{"key":"C","text_hi":"रामायण और महाभारत","text_en":"The Ramayana and the Mahabharata"},{"key":"D","text_hi":"इलियड और ओडिसी","text_en":"The Iliad and the Odyssey"}]$json$::jsonb, 'C',
    'पाठ के परिचय में दो महान भारतीय महाकाव्यों का नाम दिया गया है।', 'Check the chapter introduction in Panorama Part-1.',
    'पद्मा भारतीय महाकाव्यों — रामायण और महाभारत — के अध्ययन से प्रेरित होकर अन्याय पर सवाल उठाती है।', 'Padma is educated through the Ramayana and the Mahabharata, making her question social injustice.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000011', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Exam Pool: Mother''s Dismissal', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB Class 9 2024',
    'जब पद्मा अपनी माँ से स्त्री की पहचान पूछती है, तो माँ उस प्रश्न को क्या कहती हैं?',
    'What does Padma''s mother call Padma''s question about a woman''s identity?',
    $json$[{"key":"A","text_hi":"मज़ेदार (Funny)","text_en":"Funny"},{"key":"B","text_hi":"धार्मिक (Religious)","text_en":"Religious"},{"key":"C","text_hi":"बुद्धिमान (Wise)","text_en":"Wise"},{"key":"D","text_hi":"बेतुका (Senseless)","text_en":"Senseless"}]$json$::jsonb, 'D',
    'माँ शुरुआत में पद्मा के सवाल को टाल देती हैं।', 'Mother dismisses Padma''s inquiry at first.',
    'माँ पद्मा के सवाल को "senseless" (बेतुका) कहकर टालने की कोशिश करती हैं।', 'Mother initially calls Padma''s question "senseless".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000012', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Exam Pool: Author Language', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB Class 9 2023',
    'अर्जुन देव चारण मुख्यतः किस भाषा के साहित्यकार और नाटककार हैं?',
    'Arjun Dev Charan is primarily a celebrated playwright of which Indian language?',
    $json$[{"key":"A","text_hi":"राजस्थानी","text_en":"Rajasthani"},{"key":"B","text_hi":"मराठी","text_en":"Marathi"},{"key":"C","text_hi":"बंगाली","text_en":"Bengali"},{"key":"D","text_hi":"तमिल","text_en":"Tamil"}]$json$::jsonb, 'A',
    'उनका जन्म जोधपुर में हुआ था और 1992 का साहित्य अकादमी पुरस्कार इसी भाषा में मिला।', 'He hails from Jodhpur and won the 1992 Sahitya Akademi Award in this language.',
    'अर्जुन देव चारण प्रसिद्ध राजस्थानी कवि, नाटककार और रंगमंच निर्देशक हैं।', 'Arjun Dev Charan is a celebrated Rajasthani poet, playwright, and theatre director.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000013', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Padma''s Question 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB Class 9 2023',
    'पद्मा अपने माता-पिता से क्या प्रश्न पूछती है और वे क्या उत्तर देते हैं?',
    'What question does Padma ask her parents, and how do they answer?',
    NULL, NULL,
    'दो बातें लिखें: (1) पद्मा का प्रश्न (स्त्री की पहचान), (2) माता-पिता का परंपरागत उत्तर (विवाह और पति)।', 'Include 2 points: Padma''s question about identity and her parents'' reply linking it to marriage.',
    NULL, NULL,
    'पद्मा अपने माता-पिता से पूछती है कि समाज में **एक स्त्री की अपनी स्वतंत्र पहचान (identity) क्या है**। उसकी परंपरावादी माँ और पिता उत्तर देते हैं कि **विवाह (marriage) और पति ही स्त्री को पहचान देते हैं**, और पति के बिना स्त्री का जीवन कठिन (hell) हो जाता है।', 'Padma asks her parents about the **true independent identity of a woman** in society. Her orthodox Mother and Father reply that **marriage and a husband alone lend identity to a woman**, and without a husband a woman''s life becomes like hell.',
    $json$[{"cue_hi":"प्रश्न: स्त्री की पहचान क्या है?","cue_en":"Question: What is a woman's identity?"},{"cue_hi":"उत्तर: विवाह और पति ही पहचान देते हैं","cue_en":"Reply: Marriage and husband lend identity"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"पद्मा के मुख्य प्रश्न का सही उल्लेख","criterion_en":"Accurately states Padma's question on women's identity"},{"step_no":2,"marks":1,"criterion_hi":"माता-पिता के परंपरागत उत्तर (विवाह/पति) का उल्लेख","criterion_en":"Mentions parents' orthodox reply linking identity to marriage"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0011-4000-8000-000000000014', 'bseb-9-eng', 'bseb-9-eng-ch1', 'Summary & Theme 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB Class 9 2024',
    '"Dharam Juddha" का सारांश (Summary) लिखें और इसका केंद्रीय संदेश स्पष्ट करें।',
    'Write the summary and central message of the play "Dharam Juddha".',
    NULL, NULL,
    '5-वाक्य फ़ॉर्मूला याद करें: लेखक → पद्मा → माता-पिता के विचार → पद्मा का तर्क → समानता का संदेश।', 'Follow the 5-part formula: Author -> Padma -> Parents'' views -> Padma''s logic -> Equal rights message.',
    NULL, NULL,
    '**"धर्म युद्ध" (Dharam Juddha)** प्रसिद्ध राजस्थानी नाटककार **अर्जुन देव चारण** द्वारा लिखा गया एक विचारोत्तेजक नाटक है।

इसकी मुख्य पात्र **पद्मा** एक शिक्षित और साहसी लड़की है। वह अपनी माँ और पिता से पूछती है कि समाज में एक स्त्री की अपनी पहचान क्या है। उसकी माँ इस सवाल को बेतुका (senseless) बताती हैं और कहती हैं कि बिना पति के औरत का जीवन नर्क जैसा है। उसके पिता भी मानते हैं कि विवाह (marriage) ही स्त्री को पहचान देता है।

पद्मा इस रूढ़िवादी सोच पर प्रश्न उठाती है कि यदि किसी लड़की का विवाह न हो या पति न रहे, तो क्या उसका अस्तित्व समाप्त हो जाता है? अंततः यह नाटक हमें **नारी-सम्मान, समान अधिकार और स्वतंत्र पहचान** का सशक्त संदेश देता है।', '**"Dharam Juddha"** is a thought-provoking play written by **Arjun Dev Charan**. Its central character is **Padma**, an educated and courageous young girl shaped by the Ramayana and the Mahabharata.

In the play, Padma asks her Mother and Father about the real identity of a woman. Her Mother calls her question senseless and says life is like hell without a husband. Her Father also believes that marriage alone lends identity to a woman.

Padma boldly challenges this unfair orthodox thinking. She asks why an unmarried woman or a widow is denied respect and identity. The central message of the play is clear: **women are equal human beings and deserve independent identity, dignity, and equal rights** in society.',
    $json$[{"cue_hi":"Arjun Dev Charan + Play","cue_en":"Arjun Dev Charan + Play"},{"cue_hi":"Padma = educated girl asking about identity","cue_en":"Padma = educated girl asking about identity"},{"cue_hi":"Parents = orthodox (marriage gives identity)","cue_en":"Parents = orthodox (marriage gives identity)"},{"cue_hi":"Message = equal rights & dignity for women","cue_en":"Message = equal rights & dignity for women"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"पाठ का नाम, विधा (Play) व लेखक (Arjun Dev Charan)","criterion_en":"Names play title, genre, and playwright Arjun Dev Charan"},{"step_no":2,"marks":1.5,"criterion_hi":"पद्मा के प्रश्न व माता-पिता की परंपरागत प्रतिक्रिया","criterion_en":"Explains Padma's question and parents' orthodox replies"},{"step_no":3,"marks":1.5,"criterion_hi":"पद्मा का तर्क (अविवाहित/विधवा स्त्री की पहचान)","criterion_en":"Highlights Padma's logical challenge to social double standards"},{"step_no":4,"marks":1,"criterion_hi":"नारी-सम्मान व समानता का स्पष्ट निष्कर्ष","criterion_en":"Concludes with clear central message of women's equality"}]$json$::jsonb,
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
-- CHAPTER 12 OF 14: BSEB-9-ENG-CH2 — Yayati — C. Rajagopalachari
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-9-eng-ch2',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: ययाति (Yayati)",
  "title_en": "30-Second Mindmap: Yayati",
  "read_time_seconds": 30,
  "central_node": {
    "id": "yay-root",
    "label_hi": "ययाति (Yayati)",
    "label_en": "Yayati (Mahabharata Tale)",
    "subtitle_hi": "सी. राजगोपालाचारी · Panorama Part-1 (कक्षा 9, अध्याय 2)",
    "subtitle_en": "C. Rajagopalachari · Panorama Part-1 (Class 9, Ch 2)"
  },
  "branches": [
    {
      "id": "yay-author",
      "label_hi": "1. लेखक परिचय (Author)",
      "label_en": "1. About the Author",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "yay-a1",
          "label_hi": "चक्रवर्ती राजगोपालाचारी (1878–1972)",
          "label_en": "Chakravarti Rajagopalachari (1878–1972)",
          "detail_hi": "स्वतंत्र भारत के प्रथम व अंतिम भारतीय गवर्नर-जनरल · भारत रत्न (1954)।",
          "detail_en": "First and last Indian Governor-General of India · Bharat Ratna (1954)."
        },
        {
          "id": "yay-a2",
          "label_hi": "स्रोत: महाभारत (Spiritual Stories of India)",
          "label_en": "Source: The Mahabharata"
        }
      ]
    },
    {
      "id": "yay-chars",
      "label_hi": "2. मुख्य पात्र (Characters)",
      "label_en": "2. Key Characters",
      "color": "#059669",
      "children": [
        {
          "id": "yay-c1",
          "label_hi": "सम्राट ययाति (Emperor Yayati): पांडवों के पूर्वज",
          "label_en": "Emperor Yayati: Ancestor of the Pandavas"
        },
        {
          "id": "yay-c2",
          "label_hi": "शुक्राचार्य व देवयानी: असमय बुढ़ापे का श्राप",
          "label_en": "Shukracharya & Devayani: Curse of premature old age"
        },
        {
          "id": "yay-c3",
          "label_hi": "पुरु (Puru): पाँचवाँ और सबसे छोटा आज्ञाकारी पुत्र",
          "label_en": "Puru: Faithful youngest of the five sons"
        }
      ]
    },
    {
      "id": "yay-plot",
      "label_hi": "3. कहानी के 3 मोड़",
      "label_en": "3. Three Turning Points",
      "color": "#D97706",
      "children": [
        {
          "id": "yay-p1",
          "label_hi": "श्राप: देवयानी के अपमान पर शुक्राचार्य ने बुढ़ापा दिया",
          "label_en": "Curse: Shukracharya cursed Yayati with premature old age"
        },
        {
          "id": "yay-p2",
          "label_hi": "त्याग: चारों बड़े बेटों ने मना किया, पर पुरु ने अपनी जवानी दे दी",
          "label_en": "Sacrifice: Four elder sons refused; only Puru gave his youth"
        },
        {
          "id": "yay-p3",
          "label_hi": "ज्ञानोदय: भोग से वासना नहीं मिटती → पुरु को जवानी व राज्य लौटाया",
          "label_en": "Awakening: Desire never ends -> returned youth & throne to Puru"
        }
      ]
    },
    {
      "id": "yay-moral",
      "label_hi": "4. अमर उपदेश (Golden Moral)",
      "label_en": "4. Immortal Moral & Exam Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "yay-m1",
          "label_hi": "इच्छा आग की तरह है — भोग (घी) डालने से और भड़कती है!",
          "label_en": "Desire is like fire — indulgence flares it up like clarified butter!"
        },
        {
          "id": "yay-m2",
          "label_hi": "सच्चा सुख संतोष और आत्म-नियंत्रण में है।",
          "label_en": "True peace lies in self-control and contentment."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "yay-sec-1-author",
    "order": 1,
    "heading_hi": "1. लेखक परिचय और दैनिक जीवन की सच्चाई",
    "heading_en": "1. Author Profile & Everyday Real-Life Analogy",
    "analogy_hi": "सोचिए जब हमें बहुत प्यास लगे और हम खारा पानी पिएँ — तो क्या प्यास बुझती है? नहीं, और ज़्यादा प्यास लगती है! या चूल्हे की आग में घी डालें तो आग बुझती नहीं बल्कि और तेज़ भड़कती है। ठीक वैसे ही **सम्राट ययाति** को लगा कि दोबारा जवानी मिलने पर उनकी सारी इच्छाएँ पूरी हो जाएँगी — पर अंत में उन्हें समझ आया कि **लालच और वासना कभी भोग से शांत नहीं होते**!",
    "analogy_en": "Pouring clarified butter (ghee) into a flame never puts it out — it makes the fire blaze even higher! Emperor **Yayati** tried to satisfy endless worldly desires by borrowing his son's youth, only to discover that **desire is never quenched by indulgence**.",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "सी. राजगोपालाचारी (राजाजी) — महान लेखक व राष्ट्रनिर्माता",
      "title_en": "C. Rajagopalachari (Rajaji) — Author & Statesman",
      "events": [
        {
          "year": "1878",
          "title_hi": "जन्म — थोरापल्ली (तमिलनाडु)",
          "title_en": "Born — Thorapalli (Tamil Nadu)",
          "detail_hi": "महान स्वतंत्रता सेनानी, विद्वान और लोकप्रिय नाम \"राजाजी\"।",
          "detail_en": "Great freedom fighter, scholar, fondly known as \"Rajaji\"."
        },
        {
          "year": "1948–1950",
          "title_hi": "स्वतंत्र भारत के प्रथम व अंतिम भारतीय गवर्नर-जनरल",
          "title_en": "First & Last Indian Governor-General of India",
          "detail_hi": "लॉर्ड माउंटबेटन के बाद भारत के सर्वोच्च संवैधानिक पद पर आसीन हुए।",
          "detail_en": "Succeeded Lord Mountbatten as India's Governor-General.",
          "highlight": true
        },
        {
          "year": "1954",
          "title_hi": "भारत रत्न (प्रथम प्राप्तकर्ताओं में एक)",
          "title_en": "Bharat Ratna Awardee (1954)",
          "detail_hi": "रामायण और महाभारत को सरल अंग्रेज़ी में दुनिया तक पहुँचाया।",
          "detail_en": "Retold the Ramayana and Mahabharata in crisp, timeless English.",
          "highlight": true
        }
      ]
    },
    "concept_md_hi": "### कहानी की पृष्ठभूमि\n- **ययाति कौन थे?** सम्राट ययाति **पांडवों के प्राचीन पूर्वज (ancestor)** थे। वे न्यायप्रिय, तपस्वी और प्रजापालक राजा थे।\n- **श्राप कैसे मिला?** अपनी पत्नी **देवयानी** के प्रति अन्याय करने पर देवयानी के पिता गुरु **शुक्राचार्य (Shukracharya)** ने क्रोधित होकर ययाति को **असमय बुढ़ापे (premature old age)** का श्राप दे दिया।\n- **ययाति की दुविधा:** शरीर अचानक बूढ़ा हो गया, लेकिन मन में सांसारिक सुख भोगने की लालसा अभी भी जीवित थी।",
    "concept_md_en": "### Background of the Tale\n- **Who was Yayati?** Emperor Yayati was a renowned early **ancestor of the Pandavas**, famed for devotion and care for his subjects.\n- **How did the curse happen?** Because Yayati wronged his wife **Devayani**, her father **Shukracharya** cursed him with **premature old age**.\n- **Yayati's dilemma:** His body aged suddenly, yet his craving for youthful sensual pleasures remained unfulfilled.",
    "exam_tip_hi": "BSEB का पक्का प्रश्न: ययाति को श्राप किसने दिया? → **Shukracharya (शुक्राचार्य)** ने, क्योंकि ययाति ने उनकी पुत्री **Devayani** के साथ अन्याय किया था।",
    "exam_tip_en": "High-yield MCQ: Who cursed Yayati? → **Shukracharya**, because Yayati had wronged his daughter **Devayani**.",
    "glossary_terms": [
      {
        "term_hi": "Premature (प्रीमैच्योर)",
        "term_en": "Premature",
        "pronunciation_hi": "प्रीमैच्योर",
        "definition_hi": "समय से पहले आ जाने वाला (जैसे असमय बुढ़ापा)।",
        "definition_en": "Happening too early, before the normal time."
      },
      {
        "term_hi": "Ancestor (ऐंसेस्टर)",
        "term_en": "Ancestor",
        "pronunciation_hi": "ऐंसेस्टर",
        "definition_hi": "पूर्वज या पुरखे।",
        "definition_en": "A forefather from earlier generations."
      }
    ]
  },
  {
    "id": "yay-sec-2-storyboard",
    "order": 2,
    "heading_hi": "2. विज़ुअल स्टोरीबोर्ड: श्राप से आत्मज्ञान की यात्रा",
    "heading_en": "2. Visual Storyboard: From Curse to Wisdom",
    "analogy_hi": "ययाति की कहानी एक सीधी यात्रा है: **श्राप → पाँच बेटों से याचना → पुरु का त्याग → भोग के बाद सत्य का बोध → वनप्रस्थान**। नीचे का चार्ट एक नज़र में पूरा पाठ पक्का कर देगा!",
    "analogy_en": "Follow Yayati's complete arc in 4 clear steps: Curse -> Begging five sons -> Puru's sacrifice -> Awakening & Renunciation.",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "सम्राट ययाति की संपूर्ण कथा (4 चरण)",
      "title_en": "Complete Story Flow of Emperor Yayati",
      "direction": "TB",
      "steps": [
        {
          "id": "y-s1",
          "label_hi": "1. शुक्राचार्य का श्राप (Premature Old Age)",
          "label_en": "1. Shukracharya's Curse",
          "detail_hi": "देवयानी के अपमान पर ययाति को अचानक बुढ़ापा आ गया।",
          "detail_en": "Yayati loses his youth suddenly for wronging Devayani.",
          "accent": "amber"
        },
        {
          "id": "y-s2",
          "label_hi": "2. पाँच पुत्रों से जवानी की भीख",
          "label_en": "2. Appeal to His Five Sons",
          "detail_hi": "पहले चार बड़े बेटों ने बुढ़ापा लेने से मना कर दिया।",
          "detail_en": "His four elder sons refused to exchange their youth for old age.",
          "accent": "slate"
        },
        {
          "id": "y-s3",
          "label_hi": "3. सबसे छोटे पुत्र पुरु (Puru) का महान त्याग",
          "label_en": "3. Youngest Son Puru's Noble Sacrifice",
          "detail_hi": "आज्ञाकारी पुरु ने खुशी-खुशी पिता का बुढ़ापा ले लिया और अपनी जवानी दे दी।",
          "detail_en": "Dutiful Puru gladly accepted old age and gave his youth to Yayati.",
          "accent": "indigo"
        },
        {
          "id": "y-s4",
          "label_hi": "4. ययाति का ज्ञानोदय और वन गमन",
          "label_en": "4. Yayati's Awakening & Renunciation",
          "detail_hi": "बरसों भोगने के बाद ययाति समझ गए: इच्छाएँ कभी नहीं भरतीं! उन्होंने पुरु को जवानी व सिंहासन लौटा दिया और वन चले गए।",
          "detail_en": "Realizing desire never ends, Yayati returned Puru's youth, crowned him king, and retired to the forest.",
          "accent": "emerald"
        }
      ],
      "edges": [
        {
          "from": "y-s1",
          "to": "y-s2",
          "label_hi": "सहायता की खोज",
          "label_en": "Seeks help"
        },
        {
          "from": "y-s2",
          "to": "y-s3",
          "label_hi": "केवल पुरु सहमत",
          "label_en": "Only Puru agrees"
        },
        {
          "from": "y-s3",
          "to": "y-s4",
          "label_hi": "सत्य का बोध",
          "label_en": "Realizes truth"
        }
      ]
    },
    "concept_md_hi": "### कहानी का सबसे भावुक और शिक्षाप्रद मोड़\n- ययाति ने अपने **पाँचों पुत्रों** को बुलाया और कहा: *\"मेरा बुढ़ापा ले लो और मुझे अपनी जवानी दे दो, बदले में मेरा साम्राज्य तुम्हारा होगा।\"*\n- पहले चारों बेटों ने बहाने बनाकर मना कर दिया, पर सबसे छोटे बेटे **पुरु (Puru)** ने बिना हिचकिचाहट पिता की आज्ञा मानी।\n- कई वर्षों तक राजसुख भोगने के बाद ययाति को **सत्य का ज्ञान (wisdom)** हुआ: **भोग करने से वासना घटती नहीं, बल्कि घी डाली हुई आग की तरह और तेज़ जलती है।**\n- ययाति ने पुरु की जवानी वापस की, उसे **राजा (King)** बनाया और स्वयं शांति की खोज में **वन (forest)** चले गए।",
    "concept_md_en": "### The Turning Point & Great Realization\n- Yayati summoned his **five sons** and begged each to trade his youth for Yayati's old age and kingdom.\n- The four elder sons refused, but **Puru**, the youngest son, obediently took on his father's old age.\n- After long years of worldly pleasure, Yayati realized a deep truth: **sensual desire is never quenched by enjoyment — it blazes higher like fire fed with clarified butter (ghee).**\n- Yayati returned Puru's youth, crowned him **King**, and retired peacefully to the **forest**.",
    "exam_tip_hi": "यह लाइन हर साल परीक्षा में आती है: \"Sensual desire is never quenched by enjoyment — like **fire fed with clarified butter (ghee)**!\"",
    "exam_tip_en": "Classic exam simile: Desire grows by indulgence just like **fire fed with clarified butter (ghee)**!",
    "glossary_terms": [
      {
        "term_hi": "Indulgence (इंडलजेंस)",
        "term_en": "Indulgence",
        "pronunciation_hi": "इंडलजेंस",
        "definition_hi": "भोग-विलास या इच्छाओं में डूबे रहना।",
        "definition_en": "Giving in freely to desires and pleasures."
      },
      {
        "term_hi": "Quench (क्वेंच)",
        "term_en": "Quench",
        "pronunciation_hi": "क्वेंच",
        "definition_hi": "प्यास या इच्छा को बुझाना / शांत करना।",
        "definition_en": "To satisfy thirst or put out a fire/desire."
      }
    ],
    "quick_check": {
      "q_hi": "ययाति के पाँच पुत्रों में से किसने पिता को अपनी जवानी दी?",
      "q_en": "Which of Yayati's five sons agreed to give him his youth?",
      "answer_hi": "सबसे छोटे पुत्र **पुरु (Puru)** ने।",
      "answer_en": "His youngest son, **Puru**."
    }
  },
  {
    "id": "yay-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "इन 4 पंक्तियों को बोलकर याद कर लें — यही पंक्तियाँ 2-अंक और 5-अंक के उत्तर को टॉपर-लेवल बना देती हैं!",
    "analogy_en": "Read these 4 textbook sentences aloud — using them in your answers lifts your score to Topper level!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "ययाति की मुख्य पंक्तियाँ (उच्चारण + हिंदी अर्थ)",
      "title_en": "Key Lines from Yayati (Pronunciation + Meaning)",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "Emperor Yayati was one of the ancestors of the Pandavas.",
            "एम्परर ययाति वॉज़ वन ऑफ़ द ऐंसेस्टर्स ऑफ़ द पांडवाज़।",
            "सम्राट ययाति पांडवों के पूर्वजों में से एक थे।"
          ],
          "cells_en": [
            "Emperor Yayati was one of the ancestors of the Pandavas.",
            "Em-pa-rar Ya-yaa-ti woz wan ov the an-ses-tarz ov the Paan-da-vaaz.",
            "Opening introduction of Yayati."
          ]
        },
        {
          "cells_hi": [
            "He became prematurely old by the curse of Sukracharya.",
            "ही बिकेम प्रीमैच्योरली ओल्ड बाई द कर्स ऑफ़ शुक्राचार्य।",
            "शुक्राचार्य के श्राप से वे असमय बूढ़े हो गए।"
          ],
          "cells_en": [
            "He became prematurely old by the curse of Sukracharya.",
            "Hee bi-kem pree-ma-chyor-lee old baai the kars ov Shu-kraa-chaar-ya.",
            "Reason for Yayati's sudden old age."
          ]
        },
        {
          "cells_hi": [
            "Puru gave his youth to his father.",
            "पुरु गेव हिज़ यूथ टु हिज़ फ़ादर।",
            "पुरु ने अपनी जवानी अपने पिता को दे दी।"
          ],
          "cells_en": [
            "Puru gave his youth to his father.",
            "Pu-ru gev hiz yooth too hiz faa-dar.",
            "Puru's noble filial obedience."
          ]
        },
        {
          "cells_hi": [
            "Desire is never satisfied by enjoyment.",
            "डिज़ायर इज़ नेवर सैटिस्फ़ाइड बाई एन्जॉयमेंट।",
            "इच्छा कभी भोग से शांत नहीं होती।"
          ],
          "cells_en": [
            "Desire is never satisfied by enjoyment.",
            "Di-zaa-yar iz ne-var sa-tis-faaid baai en-joy-ment.",
            "The timeless moral of the chapter."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Emperor** (*एम्परर*) = सम्राट\n2. **Curse** (*कर्स*) = श्राप\n3. **Youth** (*यूथ*) = यौवन / जवानी\n4. **Desire** (*डिज़ायर*) = इच्छा / लालसा\n5. **Renounce** (*रिनाउंस*) = त्याग देना\n6. **Contentment** (*कंटेंटमेंट*) = संतोष",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Emperor** (*एम्परर*) = ruler of an empire\n2. **Curse** (*कर्स*) = invocation of misfortune\n3. **Youth** (*यूथ*) = young age and energy\n4. **Desire** (*डिज़ायर*) = strong craving\n5. **Renounce** (*रिनाउंस*) = to give up formally\n6. **Contentment** (*कंटेंटमेंट*) = inner satisfaction",
    "exam_tip_hi": "स्पेलिंग ध्यान रखें: **Em-pe-ror** (एम्परर) और **Sat-is-fied** (सैटिस्फ़ाइड)।",
    "exam_tip_en": "Watch spellings: **Em-pe-ror** and **Sat-is-fied**.",
    "glossary_terms": [
      {
        "term_hi": "Renounce (रिनाउंस)",
        "term_en": "Renounce",
        "pronunciation_hi": "रिनाउंस",
        "definition_hi": "सांसारिक सुख या सिंहासन का त्याग कर देना।",
        "definition_en": "To voluntarily give up power, wealth, or worldly desires."
      },
      {
        "term_hi": "Contentment (कंटेंटमेंट)",
        "term_en": "Contentment",
        "pronunciation_hi": "कंटेंटमेंट",
        "definition_hi": "मन का सच्चा संतोष और शांति।",
        "definition_en": "A state of peaceful happiness and satisfaction."
      }
    ]
  },
  {
    "id": "yay-sec-4-theme",
    "order": 4,
    "heading_hi": "4. ययाति बनाम पुरु व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Yayati vs Puru & 5-Mark Summary Formula",
    "analogy_hi": "असली जीत किसकी हुई? पुरु की! जिसने निःस्वार्थ सेवा की, अंत में जवानी और राज्य दोनों उसी को मिले।",
    "analogy_en": "Who truly triumphed? Selfless Puru — he gave up his youth out of duty and received back both youth and the throne!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "इच्छा बनाम संतोष का नियम (ययाति का ज्ञानोदय)",
      "title_en": "The Law of Desire vs Self-Control (Yayati's Wisdom)",
      "caption_hi": "भोग-विलास से इच्छा आग की तरह बढ़ती है, जबकि आत्म-नियंत्रण और संतोष से सच्ची शांति मिलती है।",
      "caption_en": "Indulgence fuels desire like ghee feeds fire, whereas self-control brings lasting peace.",
      "viewBox": "0 0 620 220",
      "elements": [
        {
          "kind": "rect",
          "x": 24,
          "y": 34,
          "width": 250,
          "height": 150,
          "rx": 12,
          "fill": "#FEF3C7",
          "stroke": "#D97706",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 149,
          "y": 66,
          "text_hi": "भोग और लालसा (Indulgence)",
          "text_en": "Indulgence & Craving",
          "fill": "#92400E",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 149,
          "y": 100,
          "text_hi": "आग + घी = और तेज़ आग",
          "text_en": "Fire + Ghee = Bigger Flame",
          "fill": "#B45309",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 149,
          "y": 132,
          "text_hi": "ययाति बरसों बाद भी अतृप्त रहे",
          "text_en": "Yayati stayed restless for years",
          "fill": "#475569",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 149,
          "y": 158,
          "text_hi": "परिणाम: अशांति",
          "text_en": "Result: Endless Restlessness",
          "fill": "#DC2626",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "arrow",
          "x1": 280,
          "y1": 110,
          "x2": 340,
          "y2": 110,
          "stroke": "#1E3A8A",
          "strokeWidth": 3
        },
        {
          "kind": "label",
          "x": 310,
          "y": 95,
          "text_hi": "ज्ञानोदय",
          "text_en": "Wisdom",
          "fill": "#1E3A8A",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "rect",
          "x": 346,
          "y": 34,
          "width": 250,
          "height": 150,
          "rx": 12,
          "fill": "#D1FAE5",
          "stroke": "#059669",
          "strokeWidth": 2.5
        },
        {
          "kind": "label",
          "x": 471,
          "y": 66,
          "text_hi": "संयम और संतोष (Self-Control)",
          "text_en": "Self-Control & Peace",
          "fill": "#065F46",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 471,
          "y": 100,
          "text_hi": "पुरु को जवानी व राज्य लौटाया",
          "text_en": "Returned Youth & Throne to Puru",
          "fill": "#047857",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 471,
          "y": 132,
          "text_hi": "ययाति ने वन में शांति पाई",
          "text_en": "Yayati retired calmly to forest",
          "fill": "#475569",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 471,
          "y": 158,
          "text_hi": "परिणाम: सच्चा सुख",
          "text_en": "Result: Lasting Inner Peace",
          "fill": "#059669",
          "fontSize": 12,
          "anchor": "middle",
          "bold": true
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"Yayati\"** is a famous Mahabharata story retold by **C. Rajagopalachari**.\n2. Emperor **Yayati** was cursed with premature old age by **Shukracharya**.\n3. His youngest son **Puru** obeyed him and gave his youth to his father.\n4. After many years, Yayati realized that **desire is never quenched by enjoyment**.\n5. He returned Puru's youth, made him king, and retired to the forest in peace.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"Yayati\"** is a famous Mahabharata story retold by **C. Rajagopalachari**.\n2. Emperor **Yayati** was cursed with premature old age by **Shukracharya**.\n3. His youngest son **Puru** obeyed him and gave his youth to his father.\n4. After many years, Yayati realized that **desire is never quenched by enjoyment**.\n5. He returned Puru's youth, made him king, and retired to the forest in peace.",
    "exam_tip_hi": "बोर्ड परीक्षा में \"fire and ghee (आग और घी)\" वाला उदाहरण ज़रूर लिखें — परीक्षक पूरा अंक देते हैं!",
    "exam_tip_en": "Always mention the \"fire fed with ghee\" simile in your long answer for full credit!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "ज्ञानोदय के बाद ययाति ने पुरु के साथ क्या किया?",
      "q_en": "What did Yayati do for Puru after realizing the truth about desire?",
      "answer_hi": "उन्होंने पुरु की जवानी लौटा दी, उसे राजा बनाया और स्वयं वन चले गए।",
      "answer_en": "He returned Puru's youth, crowned him king, and retired to the forest."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Author",
      "fact_hi": "सी. राजगोपालाचारी (1878–1972) · भारत रत्न (1954)",
      "fact_en": "C. Rajagopalachari (1878–1972) · Bharat Ratna (1954)"
    },
    {
      "tag": "Source",
      "fact_hi": "महाभारत (Panorama Part-1, Class 9, Ch 2)",
      "fact_en": "The Mahabharata (Panorama Part-1, Class 9, Ch 2)"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Yayati is a moral Mahabharata tale retold by C. Rajagopalachari.",
      "fact_en": "Yayati is a moral Mahabharata tale retold by C. Rajagopalachari."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "Shukracharya cursed Emperor Yayati with premature old age.",
      "fact_en": "Shukracharya cursed Emperor Yayati with premature old age."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "Only his youngest son Puru agreed to exchange his youth for old age.",
      "fact_en": "Only his youngest son Puru agreed to exchange his youth for old age."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "Yayati learned that desire grows like fire fed with ghee.",
      "fact_en": "Yayati learned that desire grows like fire fed with ghee."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "He returned Puru's youth, crowned him king, and chose a life of peace.",
      "fact_en": "He returned Puru's youth, crowned him king, and chose a life of peace."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "पुरु को ययाति का सबसे बड़ा बेटा लिख देना।",
      "mistake_en": "Writing that Puru was Yayati's eldest son.",
      "fix_hi": "पुरु पाँच भाइयों में **सबसे छोटा (youngest / fifth)** पुत्र था।",
      "fix_en": "Puru was the **youngest (fifth)** of Yayati's five sons."
    },
    {
      "mistake_hi": "श्राप देने वाले ऋषि का नाम दुर्वासा या विश्वामित्र लिख देना।",
      "mistake_en": "Writing Durvasa or Vishwamitra as the sage who cursed Yayati.",
      "fix_hi": "श्राप देवयानी के पिता **शुक्राचार्य (Shukracharya)** ने दिया था।",
      "fix_en": "It was Devayani's father, **Shukracharya**, who cursed Yayati."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "पुरु का त्याग और आज्ञाकारिता",
      "topic_en": "Puru's Obedience and Sacrifice",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    },
    {
      "topic_hi": "ययाति की कथा का नैतिक संदेश (इच्छा व अग्नि)",
      "topic_en": "Moral of Yayati (Desire & Fire)",
      "years": [
        "2021",
        "2024"
      ],
      "expected_marks": 5
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-9-eng-ch2',
  2,
  'छात्र "Yayati" की कहानी का घटनाक्रम समझ सकेंगे, पुरु की पितृभक्ति का विश्लेषण कर सकेंगे और इच्छा-नियंत्रण के संदेश पर अंग्रेज़ी वाक्य बना सकेंगे।',
  'Students will trace the plot of "Yayati", evaluate Puru''s filial duty, and write clear English sentences on the moral of self-control.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "महाभारत कथा परिचय, उच्चारण व ब्लैकबोर्ड कथा-क्रम",
    "phase_en": "Mahabharata Hook, Pronunciation & Story Flowchart",
    "teacher_action_hi": "हिंदी में प्रश्न पूछकर शुरुआत करें: \"क्या घी डालने से आग बुझती है?\" फिर ययाति, शुक्राचार्य और पाँच बेटों की कहानी सुनाएँ। Ancestor (ऐंसेस्टर), Premature (प्रीमैच्योर), Indulgence (इंडलजेंस) शब्दों का सामूहिक उच्चारण करवाएँ।",
    "teacher_action_en": "Ask in Hindi: \"Does ghee put out a fire?\" Narrate Yayati's curse and his appeal to his five sons. Lead chorus pronunciation of Ancestor, Premature, and Indulgence.",
    "student_check_hi": "पूछें: \"ययाति के कितने बेटे थे और किसने अपनी जवानी दी?\"",
    "student_check_en": "Ask: \"How many sons did Yayati have and who gave his youth?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "नैतिक संदेश, 5-मिनट मौखिक गतिविधि व 5-अंक सारांश लेखन",
    "phase_en": "Moral Analysis, 5-Min Oral Activity & 5-Mark Summary",
    "teacher_action_hi": "बोर्ड पर \"आग + घी = बढ़ती इच्छा\" चित्र बनाएँ। 5-मिनट मौखिक श्रृंखला में 5 छात्र 5-वाक्य सारांश का एक-एक वाक्य बोलें। अंत में 2-अंक व 5-अंक उत्तर लेखन अभ्यास कराएँ।",
    "teacher_action_en": "Draw the \"Fire + Ghee = Growing Desire\" diagram on the board. Run a 5-min oral chain where 5 shy students speak 1 summary sentence each. Practice 2M/5M framing.",
    "student_check_hi": "कमज़ोर छात्रों से \"Desire is never satisfied by enjoyment\" बोलवाकर कॉपी में लिखवाएँ।",
    "student_check_en": "Have struggling students speak and copy the moral line accurately."
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड कथा सूत्र (Yayati)",
    "heading_en": "Blackboard Story Key (Yayati)",
    "points_hi": [
      "लेखक: C. Rajagopalachari | स्रोत: Mahabharata",
      "श्राप: Shukracharya → ययाति को असमय बुढ़ापा (Devayani के अपमान पर)",
      "त्याग: 4 बड़े बेटे मना करते हैं → सबसे छोटा बेटा Puru जवानी देता है",
      "संदेश: Desire is never quenched by enjoyment (आग में घी डालने जैसा)"
    ],
    "points_en": [
      "Author: C. Rajagopalachari | Source: The Mahabharata",
      "Curse: Shukracharya curses Yayati with premature old age",
      "Sacrifice: 4 elder sons refuse -> youngest son Puru gives youth",
      "Moral: Desire is never quenched by enjoyment (fire fed with ghee)"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"यदि मैं पुरु होता\" मौखिक संवाद",
    "title_en": "5-Minute \"If I Were Puru\" Oral Reflection",
    "materials_hi": "ब्लैकबोर्ड वाक्य-ढाँचा: \"Puru was obedient because...\"",
    "materials_en": "Board starter frame: \"Puru was obedient because...\"",
    "steps_hi": "छात्र जोड़ी में चर्चा करें कि पुरु ने जवानी क्यों दी और 1 छोटा हिंदी या अंग्रेज़ी वाक्य कक्षा में सुनाएँ।",
    "steps_en": "Students discuss in pairs why Puru agreed and share 1 short sentence aloud."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Emperor, Ancestor, Curse, Youth और Desire के अर्थ व उच्चारण कॉपी में लिखें।",
    "task_en": "Write meanings and pronunciations of Emperor, Ancestor, Curse, Youth, and Desire."
  },
  {
    "level": "BOARD",
    "task_hi": "शुक्राचार्य ने ययाति को श्राप क्यों दिया? 2–3 वाक्यों में अंग्रेज़ी में लिखें।",
    "task_en": "Why did Shukracharya curse Yayati? Answer in 2–3 clear English sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "5-वाक्य फ़ॉर्मूले की मदद से \"Yayati\" का संपूर्ण सारांश लिखें।",
    "task_en": "Write the full 5-sentence summary of \"Yayati\" neatly."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र सोचते हैं कि ययाति हमेशा जवान बने रहे।",
    "misconception_en": "Students think Yayati kept Puru's youth forever.",
    "correction_hi": "स्पष्ट करें कि ज्ञानोदय के बाद ययाति ने पुरु की जवानी लौटा दी और स्वयं बुढ़ापा वापस लेकर वन चले गए।",
    "correction_en": "Clarify that Yayati returned Puru's youth, took back his old age, and retired to the forest."
  },
  {
    "misconception_hi": "छात्र C. Rajagopalachari को केवल प्राचीन ऋषि समझ लेते हैं।",
    "misconception_en": "Students mistake C. Rajagopalachari for an ancient sage.",
    "correction_hi": "बताएँ कि वे आधुनिक भारत के महान स्वतंत्रता सेनानी और प्रथम भारतीय गवर्नर-जनरल थे।",
    "correction_en": "Explain that he was a modern Indian statesman and India's first Indian Governor-General."
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
  (
    '10000007-0012-4000-8000-000000000001', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Author & Source', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB Class 9',
    'Yayati पाठ के लेखक और मूल स्रोत क्या हैं?',
    'Who retold "Yayati" and what is its source epic?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"Yayati\" के लेखक और मूल महाकाव्य का नाम बताएँ।",
  "front_en": "Name the author and original epic source of \"Yayati\".",
  "back_hi": "लेखक: C. Rajagopalachari (भारत रत्न, 1954) · मूल स्रोत: महाभारत (The Mahabharata)।",
  "back_en": "Author: C. Rajagopalachari (Bharat Ratna, 1954) · Source: The Mahabharata.",
  "pronunciation_hi": "ययाति — सी. राजगोपालाचारी",
  "mnemonic_hi": "ट्रिक: \"राजा ययाति\" की कहानी \"राजाजी\" (राजगोपालाचारी) ने सुनाई!",
  "mnemonic_en": "Hook: King (Raja) Yayati's story was retold by Rajaji!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000002', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Key Vocabulary', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Premature और Quench का अर्थ व उच्चारण क्या है?',
    'What are the pronunciation and meaning of Premature and Quench?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Premature और Quench शब्दों का सही उच्चारण व अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Premature\" and \"Quench\".",
  "back_hi": "Premature (प्रीमैच्योर) = असमय / समय से पहले · Quench (क्वेंच) = प्यास या इच्छा शांत करना / बुझाना।",
  "back_en": "Premature = occurring before the proper time · Quench = to satisfy or extinguish.",
  "pronunciation_hi": "प्रीमैच्योर · क्वेंच",
  "mnemonic_hi": "Pre (पहले) + mature (पकना) = समय से पहले!",
  "mnemonic_en": "Pre (before) + mature = before its time!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000003', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Characters & Events Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB Class 9',
    'स्तंभ A के पात्रों को स्तंभ B के सही कार्य से मिलाएँ:',
    'Match each character in Column A with their exact role in Column B:',
    NULL, NULL,
    'श्राप, त्याग, पूर्वज और पत्नी के संबंध याद करें।', 'Match the curse, sacrifice, ancestor, and wife roles.',
    'ययाति पांडवों के पूर्वज थे, शुक्राचार्य ने श्राप दिया, देवयानी ययाति की पत्नी थीं और पुरु ने जवानी दी।', 'Yayati was an ancestor of the Pandavas, Shukracharya cursed him, Devayani was his wife, and Puru gave his youth.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each character to their role",
  "pairs": [
    {
      "id": "y-p1",
      "left_hi": "Emperor Yayati",
      "left_en": "Emperor Yayati",
      "right_hi": "पांडवों के प्राचीन पूर्वज",
      "right_en": "Early ancestor of the Pandavas"
    },
    {
      "id": "y-p2",
      "left_hi": "Shukracharya",
      "left_en": "Shukracharya",
      "right_hi": "असमय बुढ़ापे का श्राप देने वाले गुरु",
      "right_en": "Sage who cursed Yayati with old age"
    },
    {
      "id": "y-p3",
      "left_hi": "Puru (पुरु)",
      "left_en": "Puru",
      "right_hi": "पिता को जवानी देने वाला सबसे छोटा पुत्र",
      "right_en": "Youngest son who gave his youth"
    },
    {
      "id": "y-p4",
      "left_hi": "Devayani (देवयानी)",
      "left_en": "Devayani",
      "right_hi": "शुक्राचार्य की पुत्री व ययाति की पत्नी",
      "right_en": "Shukracharya's daughter and Yayati's wife"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000004', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही अंग्रेज़ी वाक्य बनाएँ: "पुरु ने अपनी जवानी अपने पिता को दे दी।"',
    'Build the sentence: "Puru gave his youth to his father"',
    NULL, NULL,
    'Past tense क्रिया "gave" (give का V2 रूप) प्रयोग करें।', 'Use past tense verb "gave" (V2 of give).',
    'सही वाक्य: "Puru gave his youth to his father" — पुरु के महान त्याग को दर्शाता है।', 'Correct sentence: "Puru gave his youth to his father".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "पुरु ने अपनी जवानी अपने पिता को दे दी।",
  "prompt_en": "Build this key plot sentence from Yayati",
  "grammar_formula": "Subject + V2 (gave) + Object + to + Indirect Object",
  "tokens": [
    "Puru",
    "gave",
    "his",
    "youth",
    "to",
    "his",
    "father"
  ],
  "distractors": [
    "gives",
    "her"
  ],
  "correct_sentence": "Puru gave his youth to his father",
  "pronunciation_hi": "पुरु गेव हिज़ यूथ टु हिज़ फ़ादर"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000005', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'कहानी का मुख्य संदेश सजाएँ: "इच्छा कभी भोग से शांत नहीं होती।"',
    'Build the central moral: "Desire is never satisfied by enjoyment"',
    NULL, NULL,
    'Passive Voice संरचना: Subject + is + never + V3 (satisfied) + by + Noun।', 'Passive structure: Subject + is + never + V3 + by + Noun.',
    'सही वाक्य: "Desire is never satisfied by enjoyment"।', 'Correct sentence: "Desire is never satisfied by enjoyment".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "इच्छा कभी भोग से शांत नहीं होती।",
  "prompt_en": "Build the golden moral of Yayati",
  "grammar_formula": "Subject + is + never + V3 + by + Noun",
  "tokens": [
    "Desire",
    "is",
    "never",
    "satisfied",
    "by",
    "enjoyment"
  ],
  "distractors": [
    "are",
    "satisfy"
  ],
  "correct_sentence": "Desire is never satisfied by enjoyment",
  "pronunciation_hi": "डिज़ायर इज़ नेवर सैटिस्फ़ाइड बाई एन्जॉयमेंट"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000006', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Author MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 9 2023',
    '"Yayati" कहानी को अंग्रेज़ी में किसने प्रस्तुत किया है?',
    'Who has retold the story "Yayati" in Panorama Part-1?',
    $json$[{"key":"A","text_hi":"अर्जुन देव चारण","text_en":"Arjun Dev Charan"},{"key":"B","text_hi":"महात्मा गांधी","text_en":"Mahatma Gandhi"},{"key":"C","text_hi":"जवाहरलाल नेहरू","text_en":"Jawaharlal Nehru"},{"key":"D","text_hi":"सी. राजगोपालाचारी","text_en":"C. Rajagopalachari"}]$json$::jsonb, 'D',
    'राजाजी ट्रिक याद करें!', 'Remember the Rajaji memory hook!',
    'सी. राजगोपालाचारी (राजाजी) ने महाभारत से "Yayati" कथा को सरल अंग्रेज़ी में लिखा है।', 'C. Rajagopalachari retold "Yayati" from the Mahabharata.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000007', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Puru Identification', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 9 2022',
    'सम्राट ययाति के कुल कितने पुत्र थे?',
    'How many sons did Emperor Yayati have?',
    $json$[{"key":"A","text_hi":"तीन","text_en":"Three"},{"key":"B","text_hi":"पाँच","text_en":"Five"},{"key":"C","text_hi":"सात","text_en":"Seven"},{"key":"D","text_hi":"दो","text_en":"Two"}]$json$::jsonb, 'B',
    'पहले चार बड़े बेटों ने मना कर दिया और पाँचवें (सबसे छोटे) ने हाँ कहा।', 'Four elder sons refused and the fifth (youngest) agreed.',
    'सम्राट ययाति के पाँच पुत्र थे, जिनमें सबसे छोटे पुरु थे।', 'Emperor Yayati had five sons; Puru was the youngest.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000008', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Cause of Curse', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Class 9 2024',
    'सम्राट ययाति को असमय बुढ़ापे का श्राप किसने दिया था?',
    'Who cursed Emperor Yayati with premature old age?',
    $json$[{"key":"A","text_hi":"शुक्राचार्य","text_en":"Shukracharya"},{"key":"B","text_hi":"विश्वामित्र","text_en":"Vishwamitra"},{"key":"C","text_hi":"द्रोणाचार्य","text_en":"Dronacharya"},{"key":"D","text_hi":"ऋषि वशिष्ठ","text_en":"Sage Vashishtha"}]$json$::jsonb, 'A',
    'देवयानी के पिता कौन थे?', 'Who was Devayani''s father?',
    'देवयानी के अपमान से क्रोधित होकर उनके पिता शुक्राचार्य ने ययाति को असमय बुढ़ापे का श्राप दिया।', 'Enraged that Yayati wronged his daughter Devayani, Shukracharya cursed him with premature old age.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000009', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Moral Simile', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Class 9 2023',
    'ययाति के अनुसार भोग करने से इच्छा किस चीज़ की तरह और भड़क उठती है?',
    'According to Yayati, indulging sensual desire makes it blaze brighter like:',
    $json$[{"key":"A","text_hi":"सूर्य की छाया","text_en":"Shadow of the sun"},{"key":"B","text_hi":"पानी में डूबा पत्थर","text_en":"A stone dropped in water"},{"key":"C","text_hi":"घी डाली हुई आग","text_en":"Fire fed with clarified butter (ghee)"},{"key":"D","text_hi":"ठंडी हवा में बादल","text_en":"Clouds in cool wind"}]$json$::jsonb, 'C',
    'यज्ञ की अग्नि में आहुति (घी) डालने पर क्या होता है?', 'What happens when ghee is poured into fire?',
    'जैसे अग्नि में घी डालने से वह बुझती नहीं बल्कि और भड़कती है, वैसे ही भोग से वासना बढ़ती जाती है।', 'Just as clarified butter makes fire blaze higher, indulgence only intensifies desire.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000010', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Ending & Wisdom', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB Class 9 2024',
    'अंत में ययाति ने पुरु को जवानी व सिंहासन लौटाकर क्या किया?',
    'What did Yayati do after returning Puru''s youth and crowning him king?',
    $json$[{"key":"A","text_hi":"शुक्राचार्य के आश्रम में बस गए","text_en":"Settled in Shukracharya's ashram"},{"key":"B","text_hi":"नया युद्ध लड़ा","text_en":"Fought a new war"},{"key":"C","text_hi":"समुद्र यात्रा पर गए","text_en":"Sailed across the sea"},{"key":"D","text_hi":"शांति व तपस्या के लिए वन चले गए","text_en":"Retired to the forest for peace and meditation"}]$json$::jsonb, 'D',
    'प्राचीन भारतीय परंपरा में वानप्रस्थ आश्रम याद करें।', 'Recall the final peaceful stage of Yayati''s life.',
    'सत्य का बोध होने पर ययाति ने पुरु को जवानी व राज्य लौटा दिया और स्वयं वन में तपस्या करने चले गए।', 'After realizing the truth, Yayati restored Puru''s youth, made him king, and retired peacefully to the forest.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000011', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Exam Pool: Pandava Link', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB Class 9 2023',
    'सम्राट ययाति किनके प्राचीन पूर्वज (ancestors) माने जाते हैं?',
    'Emperor Yayati was one of the early ancestors of whom?',
    $json$[{"key":"A","text_hi":"पांडवों के","text_en":"The Pandavas"},{"key":"B","text_hi":"गुप्तों के","text_en":"The Guptas"},{"key":"C","text_hi":"चोलों के","text_en":"The Cholas"},{"key":"D","text_hi":"मौर्यों के","text_en":"The Mauryas"}]$json$::jsonb, 'A',
    'यह कहानी महाभारत से ली गई है।', 'Remember the story comes from the Mahabharata.',
    'सम्राट ययाति महाभारत के पांडवों के पूर्वजों में से एक थे।', 'Emperor Yayati was one of the early ancestors of the Pandavas.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000012', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Exam Pool: Youngest Son', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB Class 9 2024',
    'पुरु ययाति का कौन-सा पुत्र था जिसने पिता का बुढ़ापा स्वीकार किया?',
    'Which son of Yayati obediently accepted his father''s premature old age?',
    $json$[{"key":"A","text_hi":"तीसरा (Third)","text_en":"The third son"},{"key":"B","text_hi":"पाँचवाँ और सबसे छोटा (Fifth and youngest)","text_en":"The fifth and youngest son"},{"key":"C","text_hi":"सबसे बड़ा (Eldest)","text_en":"The eldest son"},{"key":"D","text_hi":"दूसरा (Second)","text_en":"The second son"}]$json$::jsonb, 'B',
    'पहले चार बड़े भाइयों ने मना कर दिया था।', 'The four elder sons refused.',
    'पुरु ययाति का पाँचवाँ और सबसे छोटा पुत्र था।', 'Puru was the fifth and youngest son of Emperor Yayati.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000013', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Puru Sacrifice 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB Class 9 2023',
    'ययाति ने अपने पुत्रों से क्या माँगा और किसने उनकी इच्छा पूरी की?',
    'What did Yayati beg from his sons, and who fulfilled his wish?',
    NULL, NULL,
    'दो स्पष्ट बातें लिखें: जवानी का आदान-प्रदान और पुरु का उत्तर।', 'Write 2 clear facts: the exchange of youth for old age, and Puru''s obedience.',
    NULL, NULL,
    'असमय बुढ़ापे से दुखी होकर ययाति ने अपने पाँचों पुत्रों से **उनकी जवानी (youth)** माँगी और बदले में अपना बुढ़ापा व राज्य देने का प्रस्ताव रखा। पहले चार बड़े बेटों ने मना कर दिया, पर उनके सबसे छोटे आज्ञाकारी पुत्र **पुरु (Puru)** ने अपनी जवानी पिता को दे दी।', 'Stricken with premature old age, Yayati begged his five sons to **exchange their youth for his old age** and kingdom. His four elder sons refused, but his dutiful youngest son **Puru** willingly gave his youth to his father.',
    $json$[{"cue_hi":"माँग: बुढ़ापे के बदले जवानी","cue_en":"Request: Youth in exchange for old age"},{"cue_hi":"त्याग: केवल सबसे छोटे पुत्र पुरु ने हाँ कहा","cue_en":"Sacrifice: Only youngest son Puru agreed"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"जवानी व बुढ़ापे के आदान-प्रदान की माँग का उल्लेख","criterion_en":"States Yayati's request to trade old age for youth"},{"step_no":2,"marks":1,"criterion_hi":"चारों बड़े बेटों के इनकार व पुरु के त्याग का उल्लेख","criterion_en":"Mentions elder sons' refusal and youngest son Puru's consent"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0012-4000-8000-000000000014', 'bseb-9-eng', 'bseb-9-eng-ch2', 'Summary & Moral 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB Class 9 2024',
    '"Yayati" कहानी का सारांश लिखें तथा इससे मिलने वाली शिक्षा बताएँ।',
    'Write the summary of "Yayati" and state the moral lesson it teaches.',
    NULL, NULL,
    '5-वाक्य सारांश + घी और आग का उदाहरण ज़रूर लिखें।', 'Include the 5-step story flow plus the fire-and-ghee moral.',
    NULL, NULL,
    '**"ययाति" (Yayati)** सी. राजगोपालाचारी द्वारा महाभारत से ली गई एक अत्यंत शिक्षाप्रद कथा है।

सम्राट ययाति पांडवों के पूर्वज थे। अपनी पत्नी देवयानी के प्रति अन्याय करने पर गुरु **शुक्राचार्य** ने उन्हें **असमय बुढ़ापे** का श्राप दे दिया। ययाति की सांसारिक इच्छाएँ अधूरी थीं, इसलिए उन्होंने अपने पाँच पुत्रों से जवानी माँगी। चार बड़े बेटों ने मना कर दिया, लेकिन सबसे छोटे आज्ञाकारी पुत्र **पुरु** ने अपनी जवानी पिता को दे दी।

बरसों तक सुख भोगने के बाद ययाति को ज्ञान हुआ कि **भोग से वासना कभी शांत नहीं होती, बल्कि घी डाली हुई आग की तरह और भड़कती है**। उन्होंने पुरु की जवानी लौटा दी, उसे राजा बनाया और स्वयं वन चले गए। यह कहानी हमें **संयम, संतोष और माता-पिता की सेवा** की अमूल्य शिक्षा देती है।', '**"Yayati"** is a timeless Mahabharata story retold by **C. Rajagopalachari**. Emperor Yayati, an ancestor of the Pandavas, was cursed with **premature old age** by **Shukracharya** for wronging his wife Devayani.

Still hungry for youthful pleasures, Yayati begged his five sons to trade their youth with him. His four elder sons refused, but his dutiful youngest son **Puru** willingly accepted old age and gave his youth to his father.

After enjoying worldly pleasures for years, Yayati realized a great truth: **sensual desire is never quenched by indulgence; it flares up brighter like fire fed with clarified butter (ghee)**. Filled with wisdom, he returned Puru''s youth, crowned him king, and retired peacefully to the forest. The story teaches us **self-control, contentment, and filial duty**.',
    $json$[{"cue_hi":"C. Rajagopalachari · Mahabharata","cue_en":"C. Rajagopalachari · Mahabharata"},{"cue_hi":"Shukracharya curse -> premature old age","cue_en":"Shukracharya curse -> premature old age"},{"cue_hi":"Youngest son Puru gives youth","cue_en":"Youngest son Puru gives youth"},{"cue_hi":"Desire = fire fed with ghee -> peace in forest","cue_en":"Desire = fire fed with ghee -> peace in forest"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"लेखक (C. Rajagopalachari) व स्रोत (Mahabharata)","criterion_en":"Mentions author C. Rajagopalachari and Mahabharata source"},{"step_no":2,"marks":1.5,"criterion_hi":"शुक्राचार्य का श्राप और पुरु का त्याग","criterion_en":"Explains Shukracharya's curse and Puru's sacrifice"},{"step_no":3,"marks":1.5,"criterion_hi":"इच्छा और अग्नि-घी का मुख्य सिद्धांत व ज्ञानोदय","criterion_en":"States realization using fire-and-ghee truth"},{"step_no":4,"marks":1,"criterion_hi":"पुरु को राज्याभिषेक व नैतिक संदेश","criterion_en":"Notes Puru's coronation and clear moral lesson"}]$json$::jsonb,
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
-- CHAPTER 13 OF 14: BSEB-11-ENG-CH1 — Animals in Prison — Jawaharlal Nehru
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-11-eng-ch1',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: जेल में पशु-पक्षी (Animals in Prison)",
  "title_en": "30-Second Mindmap: Animals in Prison",
  "read_time_seconds": 30,
  "central_node": {
    "id": "aip-root",
    "label_hi": "Animals in Prison",
    "label_en": "Animals in Prison (Autobiography)",
    "subtitle_hi": "जवाहरलाल नेहरू · Rainbow Part-1 (कक्षा 11, अध्याय 1)",
    "subtitle_en": "Jawaharlal Nehru · Rainbow Part-1 (Class 11, Ch 1)"
  },
  "branches": [
    {
      "id": "aip-author",
      "label_hi": "1. लेखक व पुस्तक (Author & Book)",
      "label_en": "1. Author & Source Book",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "aip-a1",
          "label_hi": "पं. जवाहरलाल नेहरू (1889–1964) — प्रथम प्रधानमंत्री",
          "label_en": "Jawaharlal Nehru (1889–1964) — First PM of India"
        },
        {
          "id": "aip-a2",
          "label_hi": "स्रोत: An Autobiography (1936)",
          "label_en": "Extract from: An Autobiography (1936)"
        }
      ]
    },
    {
      "id": "aip-setting",
      "label_hi": "2. स्थान और समय (Setting)",
      "label_en": "2. Setting & Duration",
      "color": "#059669",
      "children": [
        {
          "id": "aip-s1",
          "label_hi": "देहरादून जेल (Dehra Dun Gaol) की छोटी कोठरी",
          "label_en": "A small cell in Dehra Dun Gaol"
        },
        {
          "id": "aip-s2",
          "label_hi": "अवधि: साढ़े चौदह महीने (14½ months)",
          "label_en": "Duration: Fourteen and a half months"
        }
      ]
    },
    {
      "id": "aip-creatures",
      "label_hi": "3. जेल के साथी जीव-जंतु",
      "label_en": "3. Fellow Creatures in Cell",
      "color": "#D97706",
      "children": [
        {
          "id": "aip-c1",
          "label_hi": "ततैया (Wasps), बर्र (Hornets), छिपकली (Lizards)",
          "label_en": "Wasps, hornets, and lizards"
        },
        {
          "id": "aip-c2",
          "label_hi": "गिलहरी (Squirrels), कबूतर (Pigeons), मैना (Mynahs), चमगादड़",
          "label_en": "Squirrels, pigeons, mynahs, and bats"
        },
        {
          "id": "aip-c3",
          "label_hi": "पपीहा (Brain-fever bird) व एक बिच्छू (Scorpion)",
          "label_en": "Brain-fever bird and a black scorpion"
        }
      ]
    },
    {
      "id": "aip-theme",
      "label_hi": "4. संदेश और परीक्षा फोकस",
      "label_en": "4. Philosophy & Exam Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "aip-t1",
          "label_hi": "\"जियो और जीने दो\" (Live and let live) का दर्शन",
          "label_en": "Philosophy of \"live and let live\""
        },
        {
          "id": "aip-t2",
          "label_hi": "अकेलेपन में प्रकृति ही मनुष्य की सच्ची मित्र है।",
          "label_en": "Nature is humanity's truest companion in solitude."
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "aip-sec-1-author",
    "order": 1,
    "heading_hi": "1. लेखक परिचय और अकेलेपन का दैनिक उदाहरण",
    "heading_en": "1. Author Profile & Everyday Connection",
    "analogy_hi": "सोचिए अगर बारिश के दिन बिजली चली जाए और आपको कई घंटे अकेले कमरे में बैठना पड़े — तब अचानक दीवार पर चलती छिपकली, खिड़की पर बैठी गौरैया या आँगन की गिलहरी पर आपका ध्यान जाने लगता है! **जवाहरलाल नेहरू** को तो आज़ादी की लड़ाई में **साढ़े चौदह महीने** देहरादून की छोटी जेल-कोठरी में अकेले रहना पड़ा — और वहीं ये नन्हे जीव-जंतु उनके सच्चे दोस्त बन गए!",
    "analogy_en": "Ever noticed how, when you sit quietly alone on a rainy afternoon, you suddenly observe sparrows, squirrels, and wall lizards around you? Confined for **fourteen and a half months** in Dehra Dun Gaol during India's freedom struggle, **Jawaharlal Nehru** turned those tiny creatures into vivid companions.",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "पंडित जवाहरलाल नेहरू — जीवन व प्रमुख कृतियाँ",
      "title_en": "Jawaharlal Nehru — Key Life & Literary Milestones",
      "events": [
        {
          "year": "1889",
          "title_hi": "जन्म — इलाहाबाद (प्रयागराज)",
          "title_en": "Born — Allahabad (Prayagraj)",
          "detail_hi": "14 नवंबर 1889 को जन्म (बाल दिवस); कैम्ब्रिज से उच्च शिक्षा।",
          "detail_en": "Born 14 November 1889 (Children's Day); educated at Cambridge."
        },
        {
          "year": "1932–1933",
          "title_hi": "देहरादून जेल में 14½ महीने का एकांतवास",
          "title_en": "14½ Months in Dehra Dun Gaol",
          "detail_hi": "इसी कारावास के दौरान छोटे जीवों व हिमालय की चोटियों का सूक्ष्म अवलोकन किया।",
          "detail_en": "Closely observed insects, birds, squirrels, and the Himalayas from his cell.",
          "highlight": true
        },
        {
          "year": "1936",
          "title_hi": "\"An Autobiography\" का प्रकाशन",
          "title_en": "Publication of \"An Autobiography\"",
          "detail_hi": "\"Animals in Prison\" इसी विश्वप्रसिद्ध आत्मकथा का एक अध्याय है।",
          "detail_en": "\"Animals in Prison\" is an extract from this classic autobiography.",
          "highlight": true
        },
        {
          "year": "1947–1964",
          "title_hi": "स्वतंत्र भारत के प्रथम प्रधानमंत्री",
          "title_en": "First Prime Minister of Independent India",
          "detail_hi": "अन्य प्रसिद्ध पुस्तकें: The Discovery of India, Glimpses of World History।",
          "detail_en": "Other classics: The Discovery of India, Glimpses of World History."
        }
      ]
    },
    "concept_md_hi": "### पाठ की मुख्य पृष्ठभूमि\n- **स्रोत पुस्तक:** यह पाठ नेहरू जी की प्रसिद्ध पुस्तक **An Autobiography (1936)** से लिया गया है।\n- **जेल और अवधि:** नेहरू जी ने **देहरादून जेल (Dehra Dun Gaol)** की एक छोटी कोठरी में लगातार **साढ़े चौदह महीने (fourteen and a half months)** बिताए।\n- **अनोखी मित्रता:** कोठरी की हर दीवार, हर ईंट और घास के हर गुच्छे से वे परिचित हो गए। उन्हें अकेलापन महसूस नहीं हुआ क्योंकि कोठरी में उनके साथ अनेक कीट, छिपकलियाँ और पक्षी रहते थे।",
    "concept_md_en": "### Context of the Essay\n- **Source Book:** Taken from Nehru's acclaimed book **An Autobiography (1936)**.\n- **Prison & Duration:** Nehru lived for **fourteen and a half months** inside a small cell in **Dehra Dun Gaol**.\n- **Unexpected Companionship:** He knew every mark and dent in his cell, and never felt wholly lonely because insects, lizards, squirrels, and birds shared his quiet world.",
    "exam_tip_hi": "BSEB इंटर का सुपर-हॉट MCQ: नेहरू जी देहरादून जेल में कितने समय रहे? → **Fourteen and a half months (14½ months)**!",
    "exam_tip_en": "Guaranteed BSEB Inter MCQ: How long did Nehru stay in Dehra Dun Gaol? → **Fourteen and a half months**!",
    "glossary_terms": [
      {
        "term_hi": "Gaol (जेल)",
        "term_en": "Gaol",
        "pronunciation_hi": "जेल",
        "definition_hi": "जेल या कारागार (ब्रिटिश अंग्रेज़ी में \"Jail\" की पुरानी वर्तनी \"Gaol\" होती है, उच्चारण दोनों का \"जेल\" ही है!)।",
        "definition_en": "British English spelling of \"jail\" (pronounced exactly like \"jail\")."
      },
      {
        "term_hi": "Solitude (सॉलिट्यूड)",
        "term_en": "Solitude",
        "pronunciation_hi": "सॉलिट्यूड",
        "definition_hi": "एकांतवास या अकेलापन।",
        "definition_en": "The state of being alone, away from human company."
      }
    ]
  },
  {
    "id": "aip-sec-2-storyboard",
    "order": 2,
    "heading_hi": "2. विज़ुअल स्टोरीबोर्ड: देहरादून जेल के जीव-जंतु व नेहरू का अनुभव",
    "heading_en": "2. Visual Storyboard: Nehru's Little Neighbours in Gaol",
    "analogy_hi": "सोचिए नेहरू जी की जेल-कोठरी एक छोटा **मिनी-चिड़ियाघर** बन गई थी — पर बिना किसी पिंजरे के! उन्होंने तय किया कि जब तक कोई जीव हमला न करे, वे उसे नुकसान नहीं पहुँचाएँगे।",
    "analogy_en": "Nehru's tiny jail cell became an open sanctuary of living creatures — governed by one golden treaty: **live and let live**.",
    "visual_diagram": {
      "type": "FLOWCHART",
      "title_hi": "जेल में नेहरू और जीव-जंतुओं के 4 रोचक प्रसंग",
      "title_en": "4 Memorable Encounters in \"Animals in Prison\"",
      "direction": "TB",
      "steps": [
        {
          "id": "aip-st1",
          "label_hi": "1. ततैया और बर्र (Wasps & Hornets) से शांति-संधि",
          "label_en": "1. Peace Treaty with Wasps & Hornets",
          "detail_hi": "एक बार ततैये ने काट लिया तो नेहरू जी ने छत्ता हटाना चाहा, फिर शांत होकर \"जियो और जीने दो\" की संधि कर ली। फिर कभी किसी ने नहीं काटा!",
          "detail_en": "After one sting, Nehru calmed down and kept peace with wasps and hornets — they never stung him again.",
          "accent": "amber"
        },
        {
          "id": "aip-st2",
          "label_hi": "2. गिलहरियाँ (Squirrels) और पक्षी (Pigeons & Mynahs)",
          "label_en": "2. Fearless Squirrels, Pigeons & Mynahs",
          "detail_hi": "जब नेहरू जी शांत बैठकर पढ़ते, तो गिलहरी उनके पैरों पर चढ़ जाती और आँखों में झाँककर फिर भाग जाती।",
          "detail_en": "When Nehru sat still reading, squirrels climbed onto his lap and peered curiously into his eyes.",
          "accent": "emerald"
        },
        {
          "id": "aip-st3",
          "label_hi": "3. चमगादड़ (Bats) और पपीहा (Brain-Fever Bird)",
          "label_en": "3. Bats & The Brain-Fever Bird",
          "detail_hi": "नेहरू जी को चमगादड़ पसंद नहीं थे (अजीब उड़ान), और गर्मियों में पपीहा दिन-रात तीखी आवाज़ करता था।",
          "detail_en": "Nehru disliked bats flying eerily at dusk, and heard the tireless summer calls of the brain-fever bird.",
          "accent": "slate"
        },
        {
          "id": "aip-st4",
          "label_hi": "4. बिच्छू (Scorpion) और मानवता का संदेश",
          "label_en": "4. The Black Scorpion & Compassion",
          "detail_hi": "कोठरी में एक काला बिच्छू मिला — नेहरू जी ने उसे मारा नहीं, बल्कि बोतल में बंद कर दीवार के बाहर आज़ाद छोड़ दिया।",
          "detail_en": "Finding a black scorpion, Nehru gently caught it in a bottle and released it safely outside the wall.",
          "accent": "indigo"
        }
      ],
      "edges": [
        {
          "from": "aip-st1",
          "to": "aip-st2",
          "label_hi": "गहरा अवलोकन",
          "label_en": "Keen observation"
        },
        {
          "from": "aip-st2",
          "to": "aip-st3",
          "label_hi": "ऋतुओं का बदलना",
          "label_en": "Changing seasons"
        },
        {
          "from": "aip-st3",
          "to": "aip-st4",
          "label_hi": "अहिंसा व दया",
          "label_en": "Compassion"
        }
      ]
    },
    "concept_md_hi": "### पाठ की 4 सबसे महत्वपूर्ण बातें\n1. **गिलहरियों की निडरता:** जब नेहरू जी किताब पढ़ते हुए बिल्कुल स्थिर बैठते, तो नन्ही गिलहरी उनके पैर से चढ़कर गोद में आ बैठती और उनकी आँखों में देखने लगती!\n2. **कबूतर व मैना:** देहरादून जेल में बड़ी संख्या में कबूतर और मैना थीं; मानसून के समय मैना के छोटे बच्चों की देखभाल नेहरू जी ने बड़े स्नेह से की।\n3. **राष्ट्रीय पशु प्रतीक (Interesting Observation):** पाठ के अंत में नेहरू जी दिलचस्प टिप्पणी करते हैं कि विभिन्न देशों ने अपने प्रतीक के रूप में आक्रामक पशु चुने (जैसे ब्रिटेन ने शेर, रूस ने भालू, जर्मनी/अमेरिका ने बाज), जबकि भारत में **गाय (Cow)** और **हाथी (Elephant)** शांत व सौम्य प्रतीक हैं।\n4. **अहिंसा की भावना:** वे साँप या बिच्छू से भी घृणा नहीं करते, बल्कि प्रकृति के साथ सह-अस्तित्व (co-existence) में विश्वास रखते हैं।",
    "concept_md_en": "### 4 Essential Details from the Text\n1. **Fearless Squirrels:** Whenever Nehru sat completely still reading, a squirrel would climb up his leg onto his knee and gaze curiously into his eyes.\n2. **Pigeons & Mynahs:** Pigeons filled every jail; Nehru tenderly watched parent mynahs care for their fledglings.\n3. **National Animal Symbols:** Nehru thoughtfully observes that Western nations chose fierce symbols (Lion, Eagle, Bear), whereas India honours gentle animals like the **cow** and the **elephant**.\n4. **Live and Let Live:** Even when he found a scorpion or centipede, Nehru avoided cruelty and respected every creature's right to live.",
    "exam_tip_hi": "याद रखें: \"Gaol\" का उच्चारण **गॉल** नहीं, बल्कि **जेल (Jail)** होता है! और नेहरू जी ने चमगादड़ों (bats) को नापसंद किया।",
    "exam_tip_en": "Pronunciation & Exam tip: \"Gaol\" is pronounced **jail**! Also remember Nehru disliked **bats**.",
    "glossary_terms": [
      {
        "term_hi": "Wasp & Hornet (वॉस्प और हॉर्नेट)",
        "term_en": "Wasp & Hornet",
        "pronunciation_hi": "वॉस्प ऐंड हॉर्नेट",
        "definition_hi": "ततैया (पीली भिड़) और बड़ा बर्र — जो डंक मारने वाले कीट हैं।",
        "definition_en": "Stinging insects that built nests in Nehru's prison cell."
      },
      {
        "term_hi": "Co-existence (को-एग्ज़िस्टेंस)",
        "term_en": "Co-existence",
        "pronunciation_hi": "को-एग्ज़िस्टेंस",
        "definition_hi": "सभी जीवों का एक साथ शांतिपूर्ण ढंग से रहना (\"जियो और जीने दो\")।",
        "definition_en": "Living together peacefully without harming one another."
      }
    ],
    "quick_check": {
      "q_hi": "नेहरू जी ने अपनी कोठरी में मिले काले बिच्छू के साथ क्या किया?",
      "q_en": "What did Nehru do with the black scorpion he found in his cell?",
      "answer_hi": "उन्होंने उसे मारा नहीं, बल्कि एक बोतल में पकड़कर जेल की दीवार के बाहर सुरक्षित छोड़ दिया।",
      "answer_en": "He caught it safely in a bottle and released it outside the prison wall."
    }
  },
  {
    "id": "aip-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "इन 4 सरल और प्रभावशाली वाक्यों को उच्चारण सहित याद कर लें — इंटरमीडिएट परीक्षा में आपका उत्तर सबसे साफ और सुंदर दिखेगा।",
    "analogy_en": "Learn these 4 clear sentences aloud — they make your Intermediate exam answers crisp and impressive.",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "पाठ की मुख्य पंक्तियाँ (उच्चारण + हिंदी अर्थ)",
      "title_en": "Key Lines from Animals in Prison",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "For fourteen and a half months I lived in my little cell in Dehra Dun Gaol.",
            "फ़ॉर फ़ोर्टीन ऐंड अ हाफ़ मंथ्स आई लिव्ड इन माई लिटिल सेल इन देहरादून जेल।",
            "साढ़े चौदह महीनों तक मैं देहरादून जेल की छोटी कोठरी में रहा।"
          ],
          "cells_en": [
            "For fourteen and a half months I lived in my little cell in Dehra Dun Gaol.",
            "For for-teen and a haaf manths aai livd in maai li-til sel in Deh-raa-doon jel.",
            "Famous opening sentence of the essay."
          ]
        },
        {
          "cells_hi": [
            "I was not alone in my cell.",
            "आई वॉज़ नॉट अलोन इन माई सेल।",
            "मैं अपनी कोठरी में अकेला नहीं था।"
          ],
          "cells_en": [
            "I was not alone in my cell.",
            "Aai woz not a-lon in maai sel.",
            "Refers to the insects, lizards, and birds sharing his cell."
          ]
        },
        {
          "cells_hi": [
            "I decided to leave them in peace if they did not interfere with me.",
            "आई डिसाइडेड टु लीव देम इन पीस इफ़ दे डिड नॉट इंटरफ़ीयर विद मी।",
            "मैंने तय किया कि अगर वे मुझे तंग न करें तो मैं उन्हें शांति से रहने दूँगा।"
          ],
          "cells_en": [
            "I decided to leave them in peace if they did not interfere with me.",
            "Aai di-saai-ded too leev them in pees if they did not in-tar-fi-yar with mee.",
            "Nehru's \"live and let live\" pact with wasps and hornets."
          ]
        },
        {
          "cells_hi": [
            "A squirrel would venture quite close and climb up my leg.",
            "अ स्क्विरल वुड वेंचर क्वाइट क्लोज़ ऐंड क्लाइंब अप माई लेग।",
            "एक गिलहरी बिल्कुल पास आ जाती और मेरे पैर पर चढ़ जाती थी।"
          ],
          "cells_en": [
            "A squirrel would venture quite close and climb up my leg.",
            "A skwi-ral wud ven-char kwaait kloz and klaaim ap maai leg.",
            "Shows the innocent trust of squirrels in prison."
          ]
        }
      ]
    },
    "concept_md_hi": "### उच्चारण अभ्यास (शब्दकोश)\n1. **Autobiography** (*ऑटोबायोग्राफ़ी*) = आत्मकथा\n2. **Prisoner** (*प्रिज़नर*) = कैदी\n3. **Squirrel** (*स्क्विरल*) = गिलहरी\n4. **Scorpion** (*स्कॉर्पियन*) = बिच्छू\n5. **Observation** (*ऑब्ज़र्वेशन*) = सूक्ष्म निरीक्षण\n6. **Interfere** (*इंटरफ़ीयर*) = हस्तक्षेप करना / तंग करना",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Autobiography** (*ऑटोबायोग्राफ़ी*) = life story written by oneself\n2. **Prisoner** (*प्रिज़नर*) = captive in jail\n3. **Squirrel** (*स्क्विरल*) = small bushy-tailed rodent\n4. **Scorpion** (*स्कॉर्पियन*) = venomous arachnid\n5. **Observation** (*ऑब्ज़र्वेशन*) = careful watching\n6. **Interfere** (*इंटरफ़ीयर*) = disturb or meddle",
    "exam_tip_hi": "ध्यान दें: **Autobiography** (आत्मकथा) स्वयं लेखक द्वारा लिखी जाती है, जबकि **Biography** (जीवनी) कोई दूसरा लिखता है।",
    "exam_tip_en": "Distinguish clearly: **Autobiography** = written by oneself; **Biography** = written by someone else.",
    "glossary_terms": [
      {
        "term_hi": "Autobiography (ऑटोबायोग्राफ़ी)",
        "term_en": "Autobiography",
        "pronunciation_hi": "ऑटोबायोग्राफ़ी",
        "definition_hi": "लेखक द्वारा स्वयं लिखी गई अपनी जीवन-कथा।",
        "definition_en": "An account of a person's life written by that person."
      },
      {
        "term_hi": "Fledgling (फ़्लेजलिंग)",
        "term_en": "Fledgling",
        "pronunciation_hi": "फ़्लेजलिंग",
        "definition_hi": "पक्षी का छोटा बच्चा जिसके नए पंख निकल रहे हों।",
        "definition_en": "A young bird that has just developed feathers for flying."
      }
    ]
  },
  {
    "id": "aip-sec-4-summary",
    "order": 4,
    "heading_hi": "4. जेल के जीवों की तालिका व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Creatures Table & 5-Mark Summary Formula",
    "analogy_hi": "परीक्षा में नेहरू जी के प्रकृति-प्रेम पर सवाल आए, तो नीचे की तालिका से 3 जीवों के नाम और 5-वाक्य सारांश लिख दें — पूरे अंक पक्के!",
    "analogy_en": "Mention 3 specific creatures from the table plus our 5-sentence summary to guarantee top marks!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "देहरादून जेल के प्रमुख जीव व नेहरू का अनुभव",
      "title_en": "Key Creatures & Nehru's Reaction in Dehra Dun Gaol",
      "headers_hi": [
        "जीव (Creature)",
        "जेल में व्यवहार",
        "नेहरू जी की प्रतिक्रिया"
      ],
      "headers_en": [
        "Creature",
        "Behaviour in Gaol",
        "Nehru's Reaction"
      ],
      "rows": [
        {
          "cells_hi": [
            "ततैया व बर्र (Wasps & Hornets)",
            "कोठरी में छत्ता बनाकर रहते थे",
            "\"जियो और जीने दो\" की शांति-संधि की"
          ],
          "cells_en": [
            "Wasps & Hornets",
            "Nested right inside the cell",
            "Made a \"live and let live\" peace pact"
          ]
        },
        {
          "cells_hi": [
            "गिलहरियाँ (Squirrels)",
            "पैर पर चढ़कर गोद में झाँकती थीं",
            "उनकी मासूमियत से गहरा आनंद लिया"
          ],
          "cells_en": [
            "Squirrels",
            "Climbed his leg onto his lap",
            "Delighted in their playful innocence"
          ]
        },
        {
          "cells_hi": [
            "कबूतर व मैना (Pigeons & Mynahs)",
            "जेल के प्रांगण व कोठरी के पास घोंसला",
            "बच्चों को बड़े प्रेम से खाना खिलाते देखा"
          ],
          "cells_en": [
            "Pigeons & Mynahs",
            "Nested around the prison yards",
            "Observed their tender care warmly"
          ]
        },
        {
          "cells_hi": [
            "चमगादड़ (Bats) व बिच्छू",
            "शाम को अजीब उड़ान / कोठरी में बिच्छू",
            "चमगादड़ नापसंद, पर बिच्छू को सुरक्षित बाहर छोड़ा"
          ],
          "cells_en": [
            "Bats & Scorpion",
            "Eerie dusk flight / scorpion in cell",
            "Disliked bats, yet freed scorpion unharmed"
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"Animals in Prison\"** is an essay by **Jawaharlal Nehru**, taken from **An Autobiography**.\n2. Nehru spent **fourteen and a half months** in a small cell in **Dehra Dun Gaol**.\n3. Even in solitary confinement, he was not alone because insects, lizards, squirrels, and birds lived around him.\n4. He followed the rule of **live and let live** with wasps, hornets, and even a scorpion.\n5. The essay shows Nehru's **deep love for nature**, keen observation, and gentle humanity.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"Animals in Prison\"** is an essay by **Jawaharlal Nehru**, taken from **An Autobiography**.\n2. Nehru spent **fourteen and a half months** in a small cell in **Dehra Dun Gaol**.\n3. Even in solitary confinement, he was not alone because insects, lizards, squirrels, and birds lived around him.\n4. He followed the rule of **live and let live** with wasps, hornets, and even a scorpion.\n5. The essay shows Nehru's **deep love for nature**, keen observation, and gentle humanity.",
    "exam_tip_hi": "याद रखें: 5-अंक उत्तर में **Dehra Dun Gaol**, **14½ months**, और **live and let live** ये तीन शब्द ज़रूर अंडरलाइन करें!",
    "exam_tip_en": "Underline **Dehra Dun Gaol**, **14½ months**, and **live and let live** in your 5-mark answer!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "नेहरू जी को कौन-सा जीव जेल में बिल्कुल पसंद नहीं था?",
      "q_en": "Which creature did Nehru strongly dislike in prison?",
      "answer_hi": "चमगादड़ (Bats)।",
      "answer_en": "Bats."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Author",
      "fact_hi": "पंडित जवाहरलाल नेहरू (1889–1964) · भारत के प्रथम प्रधानमंत्री",
      "fact_en": "Jawaharlal Nehru (1889–1964) · First Prime Minister of India"
    },
    {
      "tag": "Book",
      "fact_hi": "An Autobiography (1936) · Rainbow Part-1 (Class 11, Ch 1)",
      "fact_en": "An Autobiography (1936) · Rainbow Part-1 (Class 11, Ch 1)"
    },
    {
      "tag": "Prison",
      "fact_hi": "देहरादून जेल (Dehra Dun Gaol) — साढ़े चौदह महीने (14½ months)",
      "fact_en": "Dehra Dun Gaol — Fourteen and a half months"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Animals in Prison is an extract from Jawaharlal Nehru's An Autobiography.",
      "fact_en": "Animals in Prison is an extract from Jawaharlal Nehru's An Autobiography."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "He spent fourteen and a half months in Dehra Dun Gaol.",
      "fact_en": "He spent fourteen and a half months in Dehra Dun Gaol."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "Wasps, hornets, lizards, squirrels, and birds became his daily companions.",
      "fact_en": "Wasps, hornets, lizards, squirrels, and birds became his daily companions."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "He treated every creature with kindness under the rule of live and let live.",
      "fact_en": "He treated every creature with kindness under the rule of live and let live."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "The essay highlights Nehru's love of nature and keen powers of observation.",
      "fact_en": "The essay highlights Nehru's love of nature and keen powers of observation."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "जेल का नाम \"ननी जेल\" या \"तिहार जेल\" लिख देना।",
      "mistake_en": "Writing Naini Jail or Tihar Jail instead of Dehra Dun Gaol.",
      "fix_hi": "पाठ की पहली ही पंक्ति याद रखें: **Dehra Dun Gaol (14½ months)**!",
      "fix_en": "Remember the exact opening line: **Dehra Dun Gaol (14½ months)**!"
    },
    {
      "mistake_hi": "पुस्तक का नाम \"Discovery of India\" लिख देना।",
      "mistake_en": "Saying the extract is from \"The Discovery of India\".",
      "fix_hi": "\"Animals in Prison\" नेहरू जी की **An Autobiography** का अंश है।",
      "fix_en": "\"Animals in Prison\" is an extract from **An Autobiography**."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "देहरादून जेल में नेहरू के जीव-जंतु अनुभव",
      "topic_en": "Nehru's Experience with Animals in Dehra Dun Gaol",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "ततैया-बर्र के साथ शांति-संधि व गिलहरियों का व्यवहार",
      "topic_en": "Truce with Wasps & Squirrels' Behaviour",
      "years": [
        "2021",
        "2023"
      ],
      "expected_marks": 2
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-11-eng-ch1',
  2,
  'छात्र नेहरू जी की आत्मकथात्मक शैली को समझ सकेंगे, देहरादून जेल के जीव-जंतु प्रसंगों को याद रख सकेंगे और प्रकृति-प्रेम व सह-अस्तित्व पर अंग्रेज़ी अनुच्छेद लिख सकेंगे।',
  'Students will appreciate Nehru''s autobiographical prose, recall key incidents from Dehra Dun Gaol, and write clear exam answers on nature and co-existence.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "स्वतंत्रता संग्राम संदर्भ, उच्चारण व जीव-जंतु मानचित्र",
    "phase_en": "Freedom Struggle Context, Pronunciation & Creature Map",
    "teacher_action_hi": "छात्रों से पूछें: \"अकेले कमरे में कौन-कौन से छोटे जीव दिखते हैं?\" फिर नेहरू जी के 14½ महीने देहरादून जेल प्रवास की कहानी हिंदी में सुनाएँ। Gaol (जेल), Autobiography (ऑटोबायोग्राफ़ी), Squirrel (स्क्विरल), Scorpion (स्कॉर्पियन) का उच्चारण अभ्यास कराएँ।",
    "teacher_action_en": "Ask students what tiny creatures they spot in quiet rooms. Narrate Nehru's 14½ months in Dehra Dun Gaol. Drill pronunciation of Gaol, Autobiography, Squirrel, and Scorpion.",
    "student_check_hi": "पूछें: \"G-A-O-L (Gaol) का सही उच्चारण क्या है और इसका अर्थ क्या होता है?\"",
    "student_check_en": "Ask: \"How do we pronounce G-A-O-L and what does it mean?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "पाठ विश्लेषण, 5-मिनट मौखिक गतिविधि व 5-अंक सारांश",
    "phase_en": "Text Decoding, 5-Min Oral Activity & 5-Mark Summary",
    "teacher_action_hi": "ततैया-बर्र की संधि, गिलहरी और बिच्छू के प्रसंग पढ़ाएँ। 5-मिनट मौखिक गतिविधि में कमजोर छात्रों से 5-वाक्य सारांश बुलवाएँ। अंत में 5 ऑब्जेक्टिव प्रश्न हल करवाएँ।",
    "teacher_action_en": "Cover the wasps treaty, fearless squirrels, and scorpion release. Run a 5-min oral confidence drill on the 5-sentence summary, then solve 5 MCQs.",
    "student_check_hi": "प्रत्येक छात्र से पूछें: \"जियो और जीने दो को अंग्रेज़ी में क्या कहते हैं?\"",
    "student_check_en": "Have students respond in chorus: \"Live and let live!\""
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड तथ्य बॉक्स (Animals in Prison)",
    "heading_en": "Blackboard Fact Box (Animals in Prison)",
    "points_hi": [
      "लेखक: Jawaharlal Nehru | पुस्तक: An Autobiography (1936)",
      "जेल: Dehra Dun Gaol | अवधि: 14½ months (साढ़े चौदह महीने)",
      "मित्र जीव: Wasps, Hornets, Lizards, Squirrels, Pigeons, Mynahs",
      "मूल मंत्र: \"Live and let live\" (जियो और जीने दो)"
    ],
    "points_en": [
      "Author: Jawaharlal Nehru | Book: An Autobiography (1936)",
      "Place: Dehra Dun Gaol | Duration: 14½ months",
      "Creatures: Wasps, Hornets, Lizards, Squirrels, Pigeons, Mynahs",
      "Philosophy: \"Live and let live\""
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"जेल के साथी पहचानो\" मौखिक खेल",
    "title_en": "5-Minute \"Name the Prison Companion\" Oral Game",
    "materials_hi": "ब्लैकबोर्ड पर 5 जीवों के हिंदी नाम",
    "materials_en": "5 Hindi creature names written on the board",
    "steps_hi": "शिक्षक हिंदी नाम बोलें (\"गिलहरी\", \"ततैया\", \"बिच्छू\", \"चमगादड़\", \"कबूतर\") और छात्र तुरंत अंग्रेज़ी नाम व उच्चारण बोलें।",
    "steps_en": "Teacher calls out a Hindi creature name; students shout the English word and one fact about it from the chapter."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "Gaol, Squirrel, Scorpion, Autobiography और Observation के अर्थ व स्पेलिंग याद कर लिखें।",
    "task_en": "Learn and write spellings and meanings of Gaol, Squirrel, Scorpion, Autobiography, and Observation."
  },
  {
    "level": "BOARD",
    "task_hi": "ततैया और बर्र के साथ नेहरू जी ने कैसी संधि की? 3 वाक्यों में लिखें।",
    "task_en": "How did Nehru make peace with the wasps and hornets? Answer in 3 sentences."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "\"Animals in Prison\" का 5-अंक सारांश बिना देखे कॉपी में लिखें।",
    "task_en": "Write the 5-mark summary of \"Animals in Prison\" from memory."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र \"Gaol\" को \"गोल (Goal)\" पढ़ और लिख देते हैं।",
    "misconception_en": "Students misread \"Gaol\" as \"Goal\".",
    "correction_hi": "ब्लैकबोर्ड पर स्पष्ट अंतर दिखाएँ: G-O-A-L = लक्ष्य (गोल), G-A-O-L = जेल (Jail)!",
    "correction_en": "Contrast clearly on board: G-O-A-L = aim, G-A-O-L = jail!"
  },
  {
    "misconception_hi": "छात्र इस पाठ का स्रोत \"The Discovery of India\" लिख देते हैं।",
    "misconception_en": "Students attribute the essay to \"The Discovery of India\".",
    "correction_hi": "बार-बार दोहराएँ: जेल के व्यक्तिगत अनुभव नेहरू जी की **An Autobiography** में हैं।",
    "correction_en": "Reinforce that Nehru's personal prison memories come from **An Autobiography**."
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
  (
    '10000007-0013-4000-8000-000000000001', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Author & Source', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB Class 11',
    'Animals in Prison किस पुस्तक से लिया गया है और लेखक कौन हैं?',
    'Which book is "Animals in Prison" taken from, and who wrote it?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"Animals in Prison\" के लेखक, स्रोत पुस्तक व जेल का नाम बताएँ।",
  "front_en": "Name the author, source book, and prison in \"Animals in Prison\".",
  "back_hi": "लेखक: Jawaharlal Nehru · पुस्तक: An Autobiography (1936) · जेल: Dehra Dun Gaol (14½ months)।",
  "back_en": "Author: Jawaharlal Nehru · Book: An Autobiography (1936) · Prison: Dehra Dun Gaol (14½ months).",
  "pronunciation_hi": "ऐनिमल्स इन प्रिज़न — देहरादून जेल",
  "mnemonic_hi": "याद रखें: जेल में खुद की कहानी = An Autobiography (14½ महीने, देहरादून)!",
  "mnemonic_en": "Hook: Own prison diary = An Autobiography (14½ months in Dehra Dun)!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000002', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Tricky Spelling Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'Gaol और Solitude का सही उच्चारण व अर्थ क्या है?',
    'What are the pronunciation and meaning of Gaol and Solitude?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "Gaol (G-A-O-L) और Solitude का उच्चारण व अर्थ बताएँ।",
  "front_en": "Give the pronunciation and meaning of \"Gaol\" and \"Solitude\".",
  "back_hi": "Gaol (जेल) = कारागार / Jail · Solitude (सॉलिट्यूड) = एकांतवास / अकेलापन।",
  "back_en": "Gaol (pronounced \"jail\") = prison · Solitude = state of being alone.",
  "pronunciation_hi": "जेल · सॉलिट्यूड",
  "mnemonic_hi": "ध्यान दें: G-A-O-L = जेल, G-O-A-L = लक्ष्य (गोल)!",
  "mnemonic_en": "Watch spelling: G-A-O-L = jail; G-O-A-L = aim!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000003', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Prison Details Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB Class 11',
    'स्तंभ A को स्तंभ B के सही तथ्य से मिलाएँ:',
    'Match each item in Column A with its correct detail in Column B:',
    NULL, NULL,
    'अवधि, स्रोत पुस्तक, नापसंद जीव और शांति-संधि याद करें।', 'Recall duration, source book, disliked creature, and the peace rule.',
    '14½ महीने देहरादून जेल में, पुस्तक An Autobiography, चमगादड़ नापसंद और गिलहरी पैर पर चढ़ जाती थी।', '14½ months in Dehra Dun Gaol, book is An Autobiography, bats were disliked, and squirrels climbed Nehru''s leg.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही जोड़े मिलाएँ",
  "instruction_en": "Match each item from Animals in Prison",
  "pairs": [
    {
      "id": "aip-p1",
      "left_hi": "Dehra Dun Gaol",
      "left_en": "Dehra Dun Gaol",
      "right_hi": "14½ महीने का कारावास स्थान",
      "right_en": "Prison where Nehru spent 14½ months"
    },
    {
      "id": "aip-p2",
      "left_hi": "An Autobiography",
      "left_en": "An Autobiography",
      "right_hi": "इस निबंध की मूल पुस्तक",
      "right_en": "Source book of this essay"
    },
    {
      "id": "aip-p3",
      "left_hi": "Squirrels (गिलहरियाँ)",
      "left_en": "Squirrels",
      "right_hi": "नेहरू के पैर पर चढ़कर गोद में आ बैठती थीं",
      "right_en": "Climbed up Nehru's leg onto his lap"
    },
    {
      "id": "aip-p4",
      "left_hi": "Bats (चमगादड़)",
      "left_en": "Bats",
      "right_hi": "नेहरू जी इन्हें पसंद नहीं करते थे",
      "right_en": "Creatures that Nehru disliked"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000004', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही अंग्रेज़ी वाक्य बनाएँ: "मैं अपनी कोठरी में अकेला नहीं था।"',
    'Build the textbook sentence: "I was not alone in my cell"',
    NULL, NULL,
    'I + was + not + alone + in my cell।', 'Use singular past verb "was" with "I".',
    'सही वाक्य: "I was not alone in my cell"।', 'Correct sentence: "I was not alone in my cell".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "मैं अपनी कोठरी में अकेला नहीं था।",
  "prompt_en": "Build Nehru's famous observation from Dehra Dun Gaol",
  "grammar_formula": "I + was + not + Adjective + Prepositional Phrase",
  "tokens": [
    "I",
    "was",
    "not",
    "alone",
    "in",
    "my",
    "cell"
  ],
  "distractors": [
    "were",
    "am"
  ],
  "correct_sentence": "I was not alone in my cell",
  "pronunciation_hi": "आई वॉज़ नॉट अलोन इन माई सेल"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000005', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य सजाएँ: "नेहरू को प्रकृति से गहरा प्रेम था।"',
    'Build the sentence: "Nehru had a deep love for nature"',
    NULL, NULL,
    'Past possession के लिए "had" प्रयोग होता है।', 'Use "had" for past possession.',
    'सही वाक्य: "Nehru had a deep love for nature"।', 'Correct sentence: "Nehru had a deep love for nature".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "नेहरू को प्रकृति से गहरा प्रेम था।",
  "prompt_en": "Build a key theme sentence for your exam summary",
  "grammar_formula": "Subject + had + a + Adjective + Noun + for + Noun",
  "tokens": [
    "Nehru",
    "had",
    "a",
    "deep",
    "love",
    "for",
    "nature"
  ],
  "distractors": [
    "have",
    "an"
  ],
  "correct_sentence": "Nehru had a deep love for nature",
  "pronunciation_hi": "नेहरू हैड अ डीप लव फ़ॉर नेचर"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000006', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Duration MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 11 2023',
    'जवाहरलाल नेहरू ने देहरादून जेल की छोटी कोठरी में कितने महीने बिताए?',
    'How long did Jawaharlal Nehru live in his little cell in Dehra Dun Gaol?',
    $json$[{"key":"A","text_hi":"साढ़े चौदह महीने","text_en":"Fourteen and a half months"},{"key":"B","text_hi":"बीस महीने","text_en":"Twenty months"},{"key":"C","text_hi":"दो वर्ष","text_en":"Two years"},{"key":"D","text_hi":"छह महीने","text_en":"Six months"}]$json$::jsonb, 'A',
    'निबंध के पहले ही वाक्य में ठीक अवधि लिखी है।', 'Recall the exact opening sentence of the chapter.',
    'नेहरू जी ने देहरादून जेल में साढ़े चौदह महीने (fourteen and a half months) बिताए।', 'Nehru lived in his Dehra Dun Gaol cell for fourteen and a half months.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000007', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Source Book MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 11 2022',
    '"Animals in Prison" नेहरू जी की किस पुस्तक का अंश है?',
    '"Animals in Prison" is an extract from which book by Jawaharlal Nehru?',
    $json$[{"key":"A","text_hi":"Glimpses of World History","text_en":"Glimpses of World History"},{"key":"B","text_hi":"The Discovery of India","text_en":"The Discovery of India"},{"key":"C","text_hi":"An Autobiography","text_en":"An Autobiography"},{"key":"D","text_hi":"Letters from a Father","text_en":"Letters from a Father"}]$json$::jsonb, 'C',
    'अपनी व्यक्तिगत जेल-स्मृतियों की पुस्तक याद करें।', 'Think of Nehru''s personal life story published in 1936.',
    'यह पाठ नेहरू जी की प्रसिद्ध कृति "An Autobiography" से लिया गया है।', 'This essay is taken from Nehru''s "An Autobiography".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000008', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Disliked Creature', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Class 11 2024',
    'नेहरू जी को जेल में इनमें से कौन-सा प्राणी बिल्कुल पसंद नहीं था?',
    'Which of these creatures did Jawaharlal Nehru dislike in prison?',
    $json$[{"key":"A","text_hi":"कबूतर (Pigeons)","text_en":"Pigeons"},{"key":"B","text_hi":"चमगादड़ (Bats)","text_en":"Bats"},{"key":"C","text_hi":"मैना (Mynahs)","text_en":"Mynahs"},{"key":"D","text_hi":"गिलहरी (Squirrels)","text_en":"Squirrels"}]$json$::jsonb, 'B',
    'जो शाम के समय चुपचाप व अजीब ढंग से उड़ते हैं।', 'They fly silently and eerily at dusk.',
    'नेहरू जी को चमगादड़ (bats) उनकी अजीब निशब्द उड़ान के कारण पसंद नहीं थे।', 'Nehru disliked bats for their silent, uncanny dusk flight.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000009', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Live and Let Live', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Class 11 2023',
    'ततैया और बर्र (Wasps & Hornets) के साथ नेहरू जी ने कौन-सा नियम अपनाया?',
    'What policy did Nehru adopt toward the wasps and hornets in his cell?',
    $json$[{"key":"A","text_hi":"धुआँ करके भगा दिया","text_en":"Drove them out with smoke"},{"key":"B","text_hi":"सबको मार दिया","text_en":"Killed all of them"},{"key":"C","text_hi":"कोठरी बदल ली","text_en":"Changed his prison cell"},{"key":"D","text_hi":"जियो और जीने दो (Live and let live)","text_en":"Live and let live"}]$json$::jsonb, 'D',
    'अहिंसा और शांतिपूर्ण सह-अस्तित्व का सिद्धांत याद करें।', 'Recall the peaceful co-existence pact.',
    'नेहरू जी ने ततैयों व बर्रों के साथ "live and let live" की शांति-संधि की और फिर उन्होंने कभी डंक नहीं मारा।', 'Nehru chose "live and let live" with wasps and hornets, and they never stung him again.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000010', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Indian Animal Symbols', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB Class 11 2024',
    'नेहरू जी के अनुसार भारतीय संस्कृति किन सौम्य पशुओं को विशेष सम्मान देती है?',
    'According to Nehru in the essay, which gentle animals are honoured in Indian tradition?',
    $json$[{"key":"A","text_hi":"गाय और हाथी","text_en":"Cow and elephant"},{"key":"B","text_hi":"बाघ और लोमड़ी","text_en":"Tiger and fox"},{"key":"C","text_hi":"बाज और गिद्ध","text_en":"Eagle and vulture"},{"key":"D","text_hi":"भालू और भेड़िया","text_en":"Bear and wolf"}]$json$::jsonb, 'A',
    'पश्चिमी देशों के हिंसक प्रतीकों की तुलना में भारत के दो शांत पशु याद करें।', 'Contrast Western fierce symbols with India''s gentle symbols.',
    'नेहरू जी बताते हैं कि जहाँ कई देशों ने शेर, बाज या भालू चुने, वहीं भारत ने शांत व उपयोगी गाय और हाथी को सम्मान दिया।', 'Nehru contrasts fierce Western symbols with India''s gentle reverence for the cow and elephant.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000011', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Exam Pool: Scorpion', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB Class 11 2023',
    'कोठरी में काला बिच्छू मिलने पर नेहरू जी ने क्या किया?',
    'What did Nehru do when he spotted a black scorpion in his cell?',
    $json$[{"key":"A","text_hi":"जूते से मार दिया","text_en":"Crushed it with a shoe"},{"key":"B","text_hi":"बोतल में पकड़कर दीवार के बाहर छोड़ दिया","text_en":"Caught it in a bottle and freed it outside the wall"},{"key":"C","text_hi":"जेलर को बुला लिया","text_en":"Called the jailer to kill it"},{"key":"D","text_hi":"कमरे में बंद कर दिया","text_en":"Locked it in a cupboard"}]$json$::jsonb, 'B',
    'नेहरू जी जीव-दया में विश्वास रखते थे।', 'Remember Nehru''s compassionate nature.',
    'उन्होंने बिच्छू को बोतल में सुरक्षित पकड़ा और दीवार के बाहर आज़ाद छोड़ दिया।', 'Nehru gently caught the scorpion in a bottle and set it free over the prison wall.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000012', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Exam Pool: Spelling Meaning', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB Class 11 2024',
    'पाठ में प्रयुक्त शब्द "Gaol" का सही अर्थ क्या है?',
    'What does the word "Gaol" used in the essay mean?',
    $json$[{"key":"A","text_hi":"पिंजरा","text_en":"Cage"},{"key":"B","text_hi":"उद्देश्य / लक्ष्य","text_en":"Aim or target"},{"key":"C","text_hi":"कारागार / जेल","text_en":"Prison or jail"},{"key":"D","text_hi":"बगीचा","text_en":"Garden"}]$json$::jsonb, 'C',
    'G-A-O-L ब्रिटिश अंग्रेज़ी में जेल की वर्तनी है।', 'It is the traditional British spelling of jail.',
    '"Gaol" का उच्चारण और अर्थ "Jail (कारागार)" होता है।', '"Gaol" is the British spelling of "jail" (prison).',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000013', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Squirrels & Companions 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB Class 11 2023',
    'देहरादून जेल में नेहरू जी ने स्वयं को अकेला क्यों नहीं महसूस किया?',
    'Why did Jawaharlal Nehru not feel entirely alone in Dehra Dun Gaol?',
    NULL, NULL,
    'उनकी कोठरी के छोटे जीव-जंतु साथियों का नाम लिखें।', 'Mention the tiny creatures sharing his cell and yard.',
    NULL, NULL,
    'यद्यपि नेहरू जी साढ़े चौदह महीनों तक देहरादून जेल की छोटी कोठरी में एकांत में रहे, फिर भी वे स्वयं को अकेला नहीं मानते थे क्योंकि **ततैया, बर्र, छिपकलियाँ, गिलहरियाँ, कबूतर और मैना** जैसे अनेक छोटे जीव-जंतु उनके दैनिक साथी बन गए थे। वे शांत भाव से उनका सूक्ष्म अवलोकन करते थे।', 'Although Nehru spent fourteen and a half months in solitary confinement at Dehra Dun Gaol, he never felt completely alone because **wasps, hornets, lizards, squirrels, pigeons, and mynahs** shared his surroundings. Observing these tiny companions brought him warmth and comfort.',
    $json$[{"cue_hi":"14½ महीने देहरादून जेल में","cue_en":"14½ months in Dehra Dun Gaol"},{"cue_hi":"साथी जीव: ततैया, छिपकली, गिलहरी, कबूतर, मैना","cue_en":"Companions: wasps, lizards, squirrels, pigeons, mynahs"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"देहरादून जेल व 14½ महीने का सही संदर्भ","criterion_en":"Mentions Dehra Dun Gaol and solitary stay"},{"step_no":2,"marks":1,"criterion_hi":"कम से कम 3 जीव-जंतु साथियों का उल्लेख","criterion_en":"Names at least 3 animal/bird companions accurately"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0013-4000-8000-000000000014', 'bseb-11-lang1-eng', 'bseb-11-eng-ch1', 'Summary & Nature Love 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB Class 11 2024',
    '"Animals in Prison" निबंध का सारांश लिखें और नेहरू जी के प्रकृति-प्रेम को स्पष्ट करें।',
    'Write a summary of "Animals in Prison" highlighting Jawaharlal Nehru''s love for nature.',
    NULL, NULL,
    'पुस्तक, देहरादून जेल (14½ महीने), प्रमुख जीव, "live and let live" और निष्कर्ष लिखें।', 'Cover source book, Dehra Dun Gaol (14½ months), key creatures, live and let live, and conclusion.',
    NULL, NULL,
    '**"Animals in Prison"** भारत के प्रथम प्रधानमंत्री **पंडित जवाहरलाल नेहरू** का संवेदनशील निबंध है, जो उनकी प्रसिद्ध पुस्तक **An Autobiography (1936)** से लिया गया है।

नेहरू जी ने स्वतंत्रता संग्राम के दौरान **देहरादून जेल (Dehra Dun Gaol)** की एक छोटी कोठरी में **साढ़े चौदह महीने** बिताए। एकांत कारावास में भी वे निराश नहीं हुए। उन्होंने ततैया, बर्र, छिपकली, गिलहरी, कबूतर और मैना के जीवन को बहुत नज़दीक से देखा। एक बार ततैये के डंक के बाद भी उन्होंने **"जियो और जीने दो" (live and let live)** का नियम अपनाया। निडर गिलहरियाँ उनकी गोद में चढ़कर झाँकती थीं, और कोठरी में मिले काले बिच्छू को भी उन्होंने बिना मारे बाहर छोड़ दिया।

यह निबंध सिद्ध करता है कि नेहरू जी न केवल महान राजनेता थे, बल्कि **अत्यंत संवेदनशील प्रकृति-प्रेमी, अहिंसक और सूक्ष्म दृष्टा** भी थे।', '**"Animals in Prison"** is a sensitive autobiographical essay by **Jawaharlal Nehru**, taken from his classic work **An Autobiography (1936)**.

Nehru spent **fourteen and a half months** in a small cell in **Dehra Dun Gaol**. Instead of feeling defeated by loneliness, he developed a warm bond with the living creatures sharing his space — wasps, hornets, lizards, squirrels, pigeons, and mynahs. Following the gentle rule of **live and let live**, he made peace with wasps and hornets, delighted in fearless squirrels climbing onto his lap, and even released a black scorpion unharmed outside the prison wall.

The essay beautifully reveals Nehru''s **deep love of nature, sharp powers of observation, and compassionate humanity**.',
    $json$[{"cue_hi":"Jawaharlal Nehru · An Autobiography","cue_en":"Jawaharlal Nehru · An Autobiography"},{"cue_hi":"Dehra Dun Gaol · 14½ months","cue_en":"Dehra Dun Gaol · 14½ months"},{"cue_hi":"Wasps, squirrels, pigeons, scorpion","cue_en":"Wasps, squirrels, pigeons, scorpion"},{"cue_hi":"Live and let live -> love of nature","cue_en":"Live and let live -> love of nature"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"लेखक (Jawaharlal Nehru) व पुस्तक (An Autobiography)","criterion_en":"Names Nehru and An Autobiography correctly"},{"step_no":2,"marks":1.5,"criterion_hi":"देहरादून जेल व 14½ महीने के एकांतवास का संदर्भ","criterion_en":"Mentions Dehra Dun Gaol and 14½ months stay"},{"step_no":3,"marks":1.5,"criterion_hi":"जीव-जंतुओं के प्रसंग व \"live and let live\" सिद्धांत","criterion_en":"Describes creature episodes and live-and-let-live pact"},{"step_no":4,"marks":1,"criterion_hi":"प्रकृति-प्रेम व मानवीय संवेदनशीलता का निष्कर्ष","criterion_en":"Concludes with Nehru's love of nature and compassion"}]$json$::jsonb,
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
-- CHAPTER 14 OF 14: BSEB-11-ENG-CH2 — Nalanda: Ancient Seat of Learning — Dr. Rajendra Prasad
-- #############################################################################

INSERT INTO public.chapter_notes (
  chapter_id, mindmap_json, sections_json, board_capsule_json, quality_checks_json, status, version
) VALUES (
  'bseb-11-eng-ch2',
  $json${
  "title_hi": "30-सेकंड माइंडमैप: नालंदा — प्राचीन शिक्षा केंद्र",
  "title_en": "30-Second Mindmap: Nalanda — Ancient Seat of Learning",
  "read_time_seconds": 30,
  "central_node": {
    "id": "nal-root",
    "label_hi": "Nalanda: Ancient Seat of Learning",
    "label_en": "Nalanda: Ancient Seat of Learning",
    "subtitle_hi": "डॉ. राजेंद्र प्रसाद · 20 नवंबर 1951 · Rainbow Part-1 (कक्षा 11, अध्याय 2)",
    "subtitle_en": "Dr. Rajendra Prasad · 20 Nov 1951 · Rainbow Part-1 (Class 11, Ch 2)"
  },
  "branches": [
    {
      "id": "nal-author",
      "label_hi": "1. वक्ता: बिहार के गौरव",
      "label_en": "1. Speaker: Pride of Bihar",
      "color": "#1E3A8A",
      "children": [
        {
          "id": "nal-a1",
          "label_hi": "डॉ. राजेंद्र प्रसाद (1884–1963) · जन्म: जीरादेई (सीवान, बिहार)",
          "label_en": "Dr. Rajendra Prasad (1884–1963) · Born: Zeradei (Siwan, Bihar)"
        },
        {
          "id": "nal-a2",
          "label_hi": "अवसर: मगध रिसर्च इंस्टीट्यूट (नालंदा) का शिलान्यास — 20 नवंबर 1951",
          "label_en": "Occasion: Foundation of Magadh Research Institute — 20 Nov 1951"
        }
      ]
    },
    {
      "id": "nal-glory",
      "label_hi": "2. प्राचीन नालंदा की भव्यता",
      "label_en": "2. Glory of Ancient Nalanda",
      "color": "#059669",
      "children": [
        {
          "id": "nal-g1",
          "label_hi": "10,000 छात्र व 1,500 आचार्य · निःशुल्क शिक्षा (200 गाँवों का दान)",
          "label_en": "10,000 students & 1,500 teachers · Free education funded by 200 villages"
        },
        {
          "id": "nal-g2",
          "label_hi": "चीनी यात्री: फाहियान, ह्वेनसांग (Hiuen Tsang), इत्सिंग (I-Tsing)",
          "label_en": "Chinese scholars: Fa-Hien, Hiuen Tsang, and I-Tsing"
        }
      ]
    },
    {
      "id": "nal-lib",
      "label_hi": "3. पुस्तकालय और विषय",
      "label_en": "3. Libraries & Curriculum",
      "color": "#D97706",
      "children": [
        {
          "id": "nal-l1",
          "label_hi": "धर्मगंज के 3 महापुस्तकालय: रत्नसागर, रत्नोदधि, रत्नरंजक",
          "label_en": "3 Great Libraries: Ratnasagara, Ratnodadhi, Ratnaranjaka"
        },
        {
          "id": "nal-l2",
          "label_hi": "5 मुख्य विषय: शब्दविद्या, हेतुविद्या, चिकित्साविद्या, शिल्पविद्या, अध्यात्मविद्या",
          "label_en": "5 Fields: Grammar, Logic, Medicine, Handicrafts, Philosophy"
        }
      ]
    },
    {
      "id": "nal-msg",
      "label_hi": "4. संदेश और परीक्षा फोकस",
      "label_en": "4. Message & Exam Focus",
      "color": "#7C3AED",
      "children": [
        {
          "id": "nal-m1",
          "label_hi": "केवल ईंट-पत्थर नहीं, बल्कि सत्य, अहिंसा व विश्व-शांति की भावना पुनर्जीवित हो।",
          "label_en": "Revive not just brick buildings, but Nalanda's spirit of knowledge & peace."
        },
        {
          "id": "nal-m2",
          "label_hi": "बिहार बोर्ड के लिए अत्यंत प्रिय अध्याय (बिहार से सीधा गौरव!)।",
          "label_en": "Top-priority BSEB chapter with direct Bihar heritage pride!"
        }
      ]
    }
  ]
}$json$::jsonb,
  $json$[
  {
    "id": "nal-sec-1-author",
    "order": 1,
    "heading_hi": "1. वक्ता परिचय (बिहार के लाल) और ऐतिहासिक अवसर",
    "heading_en": "1. Speaker Profile (Son of Bihar) & Historic Occasion",
    "analogy_hi": "यह अध्याय बिहार के हर विद्यार्थी के लिए **गर्व का ताज** है! इसे बिहार की ही धरती (जीरादेई, सीवान) में जन्मे देश के प्रथम राष्ट्रपति **डॉ. राजेंद्र प्रसाद** ने स्वयं **नालंदा (बिहार)** की पावन भूमि पर खड़े होकर दिया था। सोचिए, आज से 1,500 साल पहले जब दुनिया के कई हिस्सों में स्कूल भी नहीं थे, तब हमारे बिहार के नालंदा में चीन, कोरिया, जापान और तिब्बत से विद्यार्थी पढ़ने आते थे — और उनकी पढ़ाई, भोजन व आवास **बिल्कुल मुफ़्त** था!",
    "analogy_en": "This chapter is pure Bihar pride! Delivered on the sacred soil of **Nalanda, Bihar** by India's first President **Dr. Rajendra Prasad** (born in Zeradei, Siwan, Bihar), it celebrates the era when scholars from China, Korea, Japan, and Tibet travelled to Bihar for **free, world-class residential education**!",
    "visual_diagram": {
      "type": "TIMELINE",
      "title_hi": "प्राचीन नालंदा से आधुनिक पुनर्जागरण तक की यात्रा",
      "title_en": "Timeline: Ancient Nalanda to Modern Revival",
      "events": [
        {
          "year": "6th C. BCE",
          "title_hi": "भगवान महावीर व भगवान बुद्ध से जुड़ाव",
          "title_en": "Association with Lord Mahavira & Lord Buddha",
          "detail_hi": "भगवान महावीर ने नालंदा में 14 चातुर्मास बिताए; बुद्ध के प्रिय शिष्य सारिपुत्त का जन्म व परिनिर्वाण यहीं हुआ।",
          "detail_en": "Lord Mahavira spent 14 rainy seasons here; Buddha's disciple Sariputta was born and passed away here."
        },
        {
          "year": "5th–7th C. CE",
          "title_hi": "विश्व का महान आवासीय विश्वविद्यालय (गुप्त व हर्ष युग)",
          "title_en": "World's Great Residential University",
          "detail_hi": "सम्राट अशोक ने विहार बनवाया; गुप्त काल में यह 10,000 छात्रों व 1,500 शिक्षकों का अंतरराष्ट्रीय केंद्र बना।",
          "detail_en": "Emperor Ashoka built a vihara; under the Guptas and Harsha it grew to 10,000 students and 1,500 teachers.",
          "highlight": true
        },
        {
          "year": "630–645 CE",
          "title_hi": "चीनी विद्वान ह्वेनसांग (Hiuen Tsang) की यात्रा",
          "title_en": "Visit of Chinese Scholar Hiuen Tsang",
          "detail_hi": "आचार्य शीलभद्र के शिष्य बनकर नालंदा में अध्ययन किया और सैकड़ों पांडुलिपियाँ चीन ले गए।",
          "detail_en": "Studied under Acharya Shilabhadra and carried hundreds of manuscripts back to China."
        },
        {
          "year": "20 Nov 1951",
          "title_hi": "डॉ. राजेंद्र प्रसाद का ऐतिहासिक भाषण (मगध रिसर्च इंस्टीट्यूट)",
          "title_en": "Dr. Rajendra Prasad's Historic Speech",
          "detail_hi": "नालंदा में नव नालंदा महाविहार / मगध रिसर्च इंस्टीट्यूट की आधारशिला रखते हुए यह भाषण दिया।",
          "detail_en": "Delivered this speech while laying the foundation stone of the Magadh Research Institute at Nalanda.",
          "highlight": true
        }
      ]
    },
    "concept_md_hi": "### डॉ. राजेंद्र प्रसाद और भाषण का संदर्भ\n- **जन्म व जीवन:** डॉ. राजेंद्र प्रसाद (**1884–1963**) का जन्म बिहार के सीवान जिले के **जीरादेई** गाँव में हुआ था। वे स्वतंत्र भारत के **प्रथम राष्ट्रपति (1950–1962)** और **भारत रत्न (1962)** से सम्मानित थे।\n- **विधा (Genre):** यह पाठ एक **भाषण (Speech)** है।\n- **तिथि व अवसर:** **20 नवंबर 1951** को नालंदा में **मगध रिसर्च इंस्टीट्यूट (Magadh Research Institute)** के शिलान्यास समारोह में दिया गया, ताकि पाली, प्राकृत और बौद्ध दर्शन का अध्ययन फिर से जीवित हो सके।",
    "concept_md_en": "### Speaker & Occasion\n- **About the Author:** Dr. Rajendra Prasad (**1884–1963**), born in **Zeradei, Siwan (Bihar)**, was the **first President of India** and recipient of the **Bharat Ratna (1962)**.\n- **Genre:** A formal **Speech**.\n- **Date & Event:** Delivered on **20 November 1951** at the foundation-stone ceremony of the **Magadh Research Institute** in Nalanda to revive Pali, Prakrit, and Buddhist learning.",
    "exam_tip_hi": "रट लें ये 2 तारीखें: भाषण की तिथि **20 November 1951**, और नालंदा में महावीर स्वामी के चातुर्मास = **14 वर्षावास (14 rainy seasons)**!",
    "exam_tip_en": "Memorize these 2 facts: Speech date = **20 November 1951**; Lord Mahavira spent **14 rainy seasons** at Nalanda!",
    "glossary_terms": [
      {
        "term_hi": "Manuscript (मैन्युस्क्रिप्ट)",
        "term_en": "Manuscript",
        "pronunciation_hi": "मैन्युस्क्रिप्ट",
        "definition_hi": "हाथ से लिखा गया प्राचीन ग्रंथ या पांडुलिपि।",
        "definition_en": "An ancient book or document written by hand."
      },
      {
        "term_hi": "Heritage (हेरिटेज)",
        "term_en": "Heritage",
        "pronunciation_hi": "हेरिटेज",
        "definition_hi": "सांस्कृतिक और ऐतिहासिक विरासत।",
        "definition_en": "Valued historical and cultural traditions passed down over generations."
      }
    ]
  },
  {
    "id": "nal-sec-2-architecture",
    "order": 2,
    "heading_hi": "2. विज़ुअल चित्र: प्राचीन नालंदा विश्वविद्यालय की 4 अनोखी विशेषताएँ",
    "heading_en": "2. Visual Diagram: 4 Pillars of Ancient Nalanda University",
    "analogy_hi": "कल्पना कीजिए एक ऐसा विशाल कॉलेज जहाँ **10,000 विद्यार्थी** रहते हों, **1,500 प्रोफ़ेसर** रोज़ 100 से ज़्यादा व्याख्यान देते हों, **9 मंज़िला पुस्तकालय** हो, और प्रवेश परीक्षा इतनी कठिन हो कि 10 में से केवल 2–3 मेधावी छात्र ही चुने जाएँ!",
    "analogy_en": "Picture a vibrant residential university with **10,000 students**, **1,500 teachers**, **100 daily lectures**, a **9-storey library**, and a strict entrance exam taken right at the gate!",
    "visual_diagram": {
      "type": "SVG_DIAGRAM",
      "title_hi": "प्राचीन नालंदा विश्वविद्यालय — विश्व-शिक्षा के 4 स्तंभ",
      "title_en": "Ancient Nalanda University — 4 Pillars of Global Learning",
      "caption_hi": "नालंदा में शिक्षा निःशुल्क थी (100–200 गाँवों के राजस्व से पोषित), प्रवेश केवल योग्यता पर आधारित था और ज्ञान पूरे एशिया में फैला।",
      "caption_en": "Funded by the revenue of 100–200 villages, Nalanda offered free merit-based education across Asia.",
      "viewBox": "0 0 640 260",
      "elements": [
        {
          "kind": "rect",
          "x": 200,
          "y": 16,
          "width": 240,
          "height": 50,
          "rx": 10,
          "fill": "#1E3A8A",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 320,
          "y": 40,
          "text_hi": "नालंदा महाविहार (बिहार)",
          "text_en": "Nalanda Mahavihara (Bihar)",
          "fill": "#FFFFFF",
          "fontSize": 14,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 320,
          "y": 57,
          "text_hi": "प्राचीन विश्व का गौरव",
          "text_en": "Ancient Global Seat of Learning",
          "fill": "#DBEAFE",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "arrow",
          "x1": 230,
          "y1": 66,
          "x2": 95,
          "y2": 112,
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "arrow",
          "x1": 285,
          "y1": 66,
          "x2": 245,
          "y2": 112,
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "arrow",
          "x1": 355,
          "y1": 66,
          "x2": 395,
          "y2": 112,
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "arrow",
          "x1": 410,
          "y1": 66,
          "x2": 545,
          "y2": 112,
          "stroke": "#7C3AED",
          "strokeWidth": 2
        },
        {
          "kind": "rect",
          "x": 20,
          "y": 116,
          "width": 142,
          "height": 120,
          "rx": 10,
          "fill": "#EFF6FF",
          "stroke": "#1E3A8A",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 91,
          "y": 144,
          "text_hi": "10,000 छात्र",
          "text_en": "10,000 Students",
          "fill": "#1E3A8A",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 91,
          "y": 170,
          "text_hi": "1,500 आचार्य",
          "text_en": "1,500 Teachers",
          "fill": "#334155",
          "fontSize": 12,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 91,
          "y": 198,
          "text_hi": "चीन, जापान, तिब्बत",
          "text_en": "China, Japan, Tibet",
          "fill": "#475569",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "rect",
          "x": 174,
          "y": 116,
          "width": 142,
          "height": 120,
          "rx": 10,
          "fill": "#ECFDF5",
          "stroke": "#059669",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 245,
          "y": 144,
          "text_hi": "धर्मगंज पुस्तकालय",
          "text_en": "Dharmaganja Library",
          "fill": "#065F46",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 245,
          "y": 170,
          "text_hi": "रत्नसागर (9 मंज़िल)",
          "text_en": "Ratnasagara (9 floors)",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 245,
          "y": 198,
          "text_hi": "रत्नोदधि व रत्नरंजक",
          "text_en": "Ratnodadhi, Ratnaranjaka",
          "fill": "#475569",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "rect",
          "x": 328,
          "y": 116,
          "width": 142,
          "height": 120,
          "rx": 10,
          "fill": "#FFFBEB",
          "stroke": "#D97706",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 399,
          "y": 144,
          "text_hi": "निःशुल्क शिक्षा",
          "text_en": "Free Education",
          "fill": "#92400E",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 399,
          "y": 170,
          "text_hi": "200 गाँवों का दान",
          "text_en": "200 Villages Endowment",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 399,
          "y": 198,
          "text_hi": "द्वार-पंडित प्रवेश परीक्षा",
          "text_en": "Gatekeeper Entrance Test",
          "fill": "#475569",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "rect",
          "x": 482,
          "y": 116,
          "width": 142,
          "height": 120,
          "rx": 10,
          "fill": "#F5F3FF",
          "stroke": "#7C3AED",
          "strokeWidth": 2
        },
        {
          "kind": "label",
          "x": 553,
          "y": 144,
          "text_hi": "5 प्रमुख विषय",
          "text_en": "5 Core Subjects",
          "fill": "#5B21B6",
          "fontSize": 13,
          "anchor": "middle",
          "bold": true
        },
        {
          "kind": "label",
          "x": 553,
          "y": 170,
          "text_hi": "व्याकरण, तर्क, चिकित्सा",
          "text_en": "Grammar, Logic, Medicine",
          "fill": "#334155",
          "fontSize": 11,
          "anchor": "middle"
        },
        {
          "kind": "label",
          "x": 553,
          "y": 198,
          "text_hi": "शिल्प व दर्शनशास्त्र",
          "text_en": "Crafts & Philosophy",
          "fill": "#475569",
          "fontSize": 11,
          "anchor": "middle"
        }
      ]
    },
    "concept_md_hi": "### प्राचीन नालंदा की अद्भुत व्यवस्था\n1. **विशाल पुस्तकालय (Dharmaganja):** नालंदा का पुस्तकालय क्षेत्र **धर्मगंज** कहलाता था, जिसमें तीन भव्य भवन थे — **रत्नसागर (9 मंज़िला), रत्नोदधि और रत्नरंजक**।\n2. **कठिन प्रवेश परीक्षा:** विश्वविद्यालय के द्वार पर बैठे विद्वान (**द्वार-पंडित**) कठिन प्रश्न पूछते थे; केवल अत्यंत योग्य विद्यार्थियों को ही प्रवेश मिलता था।\n3. **5 अनिवार्य विषय:** सभी विद्यार्थियों को **शब्दविद्या (व्याकरण), हेतुविद्या (तर्कशास्त्र), चिकित्साविद्या (औषधि), शिल्पविद्या (कला/कौशल) और अध्यात्मविद्या (दर्शन)** की शिक्षा दी जाती थी।\n4. **वैश्विक दान व सहयोग:** केवल भारतीय राजाओं ने ही नहीं, बल्कि **सुमात्रा (जावा) के राजा बालपुत्रदेव** ने भी नालंदा में विहार बनवाकर दान दिया था!",
    "concept_md_en": "### Amazing Features of Ancient Nalanda\n1. **Grand Libraries (Dharmaganja):** The library complex had three massive buildings — **Ratnasagara (nine storeys high), Ratnodadhi, and Ratnaranjaka**.\n2. **Strict Admission:** Scholarly gatekeepers interviewed applicants with tough philosophical questions; only the brightest passed.\n3. **Five Core Subjects:** Students studied **Grammar, Logic, Medicine, Handicrafts/Arts, and Philosophy** for complete intellectual and practical growth.\n4. **International Support:** Even foreign rulers like **King Balaputradeva of Sumatra (Suvarnadvipa)** built a monastery and endowed villages for Nalanda scholars.",
    "exam_tip_hi": "इंटरमीडिएट परीक्षा के लिए 3 पुस्तकालयों के नाम ज़रूर याद करें: **Ratnasagara, Ratnodadhi, Ratnaranjaka**!",
    "exam_tip_en": "Must-memorize trio of libraries: **Ratnasagara, Ratnodadhi, and Ratnaranjaka**!",
    "glossary_terms": [
      {
        "term_hi": "Endowment (एंडाउमेंट)",
        "term_en": "Endowment",
        "pronunciation_hi": "एंडाउमेंट",
        "definition_hi": "किसी शिक्षण संस्थान को स्थायी रूप से दी गई भूमि या धन का दान।",
        "definition_en": "Permanent gift of land or revenue supporting an institution."
      },
      {
        "term_hi": "Revival (रिवाइवल)",
        "term_en": "Revival",
        "pronunciation_hi": "रिवाइवल",
        "definition_hi": "पुनर्जागरण या किसी महान परंपरा को फिर से जीवित करना।",
        "definition_en": "Bringing back to life, strength, or renewed glory."
      }
    ],
    "quick_check": {
      "q_hi": "नालंदा के तीन प्रसिद्ध पुस्तकालयों के नाम क्या थे?",
      "q_en": "What were the names of the three great library buildings at Nalanda?",
      "answer_hi": "रत्नसागर (Ratnasagara), रत्नोदधि (Ratnodadhi) और रत्नरंजक (Ratnaranjaka)।",
      "answer_en": "Ratnasagara, Ratnodadhi, and Ratnaranjaka."
    }
  },
  {
    "id": "nal-sec-3-lines",
    "order": 3,
    "heading_hi": "3. मुख्य अंग्रेज़ी पंक्तियाँ — उच्चारण व सरल अर्थ",
    "heading_en": "3. Key English Lines Decoded (Pronunciation + Meaning)",
    "analogy_hi": "डॉ. राजेंद्र प्रसाद की भाषा बहुत ही गरिमामय और सरल है। नीचे की 4 पंक्तियों को ज़ोर से पढ़िए और अर्थ समझिए।",
    "analogy_en": "Dr. Rajendra Prasad's speech is dignified yet clear. Read these 4 landmark lines aloud.",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "भाषण की मुख्य अंग्रेज़ी पंक्तियाँ (उच्चारण + अर्थ)",
      "title_en": "Key Lines from Nalanda: Ancient Seat of Learning",
      "headers_hi": [
        "अंग्रेज़ी पंक्ति",
        "हिंदी उच्चारण",
        "आसान हिंदी अर्थ"
      ],
      "headers_en": [
        "English Line",
        "Pronunciation Guide",
        "Simple Meaning"
      ],
      "rows": [
        {
          "cells_hi": [
            "Nalanda is the symbol of the most glorious period of our history.",
            "नालंदा इज़ द सिंबल ऑफ़ द मोस्ट ग्लोरियस पीरियड ऑफ़ आवर हिस्ट्री।",
            "नालंदा हमारे इतिहास के सबसे गौरवशाली युग का प्रतीक है।"
          ],
          "cells_en": [
            "Nalanda is the symbol of the most glorious period of our history.",
            "Naa-lan-daa iz the sim-bal ov the most glo-ri-as pee-ri-ad ov a-war his-tri.",
            "Opening tribute to Nalanda's greatness."
          ]
        },
        {
          "cells_hi": [
            "Scholars from China, Korea, Japan, and Tibet came here to study.",
            "स्कॉलर्स फ़्रॉम चाइना, कोरिया, जापान ऐंड तिब्बत केम हियर टु स्टडी।",
            "चीन, कोरिया, जापान और तिब्बत के विद्वान यहाँ पढ़ने आते थे।"
          ],
          "cells_en": [
            "Scholars from China, Korea, Japan, and Tibet came here to study.",
            "Sko-larz from Chaai-naa, Ko-ri-yaa, Ja-paan and Ti-bat kem hi-yar too sta-di.",
            "Highlights Nalanda's international stature."
          ]
        },
        {
          "cells_hi": [
            "Education at Nalanda was completely free.",
            "एजुकेशन ऐट नालंदा वॉज़ कम्प्लीटली फ़्री।",
            "नालंदा में शिक्षा पूरी तरह निःशुल्क थी।"
          ],
          "cells_en": [
            "Education at Nalanda was completely free.",
            "E-ju-ke-shan at Naa-lan-daa woz kam-pleet-lee free.",
            "Supported by village revenue endowments."
          ]
        },
        {
          "cells_hi": [
            "We must revive the true spirit of Nalanda, not merely its buildings.",
            "वी मस्ट रिवाइव द ट्रू स्पिरिट ऑफ़ नालंदा, नॉट मियरली इट्स बिल्डिंग्स।",
            "हमें केवल नालंदा की इमारतें नहीं, बल्कि उसकी सच्ची ज्ञान-भावना को जीवित करना है।"
          ],
          "cells_en": [
            "We must revive the true spirit of Nalanda, not merely its buildings.",
            "Wee mast ri-vaaiv the troo spi-rit ov Naa-lan-daa, not mi-yar-lee its bil-dingz.",
            "Dr. Rajendra Prasad's concluding vision."
          ]
        }
      ]
    },
    "concept_md_hi": "### कठिन शब्दों का बोलकर अभ्यास\n1. **Glorious** (*ग्लोरियस*) = गौरवशाली / भव्य\n2. **Scholar** (*स्कॉलर*) = विद्वान / शोधार्थी\n3. **Symbol** (*सिंबल*) = प्रतीक\n4. **Monastery** (*मॉनेस्टरी*) = विहार / मठ\n5. **Philosophy** (*फ़िलॉसफ़ी*) = दर्शनशास्त्र\n6. **Spirit** (*स्पिरिट*) = मूल भावना / आत्मा",
    "concept_md_en": "### Read-Aloud Vocabulary Drill\n1. **Glorious** (*ग्लोरियस*) = magnificent and proud\n2. **Scholar** (*स्कॉलर*) = learned student or researcher\n3. **Symbol** (*सिंबल*) = emblem or sign\n4. **Monastery** (*मॉनेस्टरी*) = residential religious/academic vihara\n5. **Philosophy** (*फ़िलॉसफ़ी*) = study of truth and wisdom\n6. **Spirit** (*स्पिरिट*) = guiding ideal",
    "exam_tip_hi": "स्पेलिंग याद रखें: **Phi-lo-so-phy** (फ़िलॉसफ़ी) और **Scho-lar** (स्कॉलर)।",
    "exam_tip_en": "Spelling check: **Phi-lo-so-phy** and **Scho-lar**.",
    "glossary_terms": [
      {
        "term_hi": "Monastery (मॉनेस्टरी)",
        "term_en": "Monastery",
        "pronunciation_hi": "मॉनेस्टरी",
        "definition_hi": "बौद्ध विहार या आवासीय शिक्षा-मठ।",
        "definition_en": "A residential vihara where monks and scholars lived and studied."
      },
      {
        "term_hi": "Glorious (ग्लोरियस)",
        "term_en": "Glorious",
        "pronunciation_hi": "ग्लोरियस",
        "definition_hi": "अत्यंत शानदार, यशस्वी और गौरवपूर्ण।",
        "definition_en": "Deserving great admiration, pride, and fame."
      }
    ]
  },
  {
    "id": "nal-sec-4-summary",
    "order": 4,
    "heading_hi": "4. चीनी यात्रियों के विवरण व 5-अंक सारांश फ़ॉर्मूला",
    "heading_en": "4. Foreign Travellers & 5-Mark Summary Formula",
    "analogy_hi": "अगर कोई पूछे कि हमें प्राचीन नालंदा के बारे में इतना सब कैसे पता चला? तो उत्तर है — **चीनी यात्रियों (ह्वेनसांग और इत्सिंग)** की यात्रा-डायरियों से!",
    "analogy_en": "How do we know so much about ancient Nalanda? Thanks to the eyewitness travel records of **Hiuen Tsang** and **I-Tsing**!",
    "visual_diagram": {
      "type": "COMPARISON_TABLE",
      "title_hi": "नालंदा आने वाले प्रमुख चीनी विद्वान",
      "title_en": "Famous Chinese Scholars Who Visited Nalanda",
      "headers_hi": [
        "विद्वान (Scholar)",
        "काल / यात्रा",
        "नालंदा के बारे में मुख्य विवरण"
      ],
      "headers_en": [
        "Scholar",
        "Period",
        "Key Record About Nalanda"
      ],
      "rows": [
        {
          "cells_hi": [
            "फाहियान (Fa-Hien)",
            "4वीं–5वीं शताब्दी ई.",
            "नालंदा (सारिपुत्त के स्तूप) की यात्रा का प्रारंभिक उल्लेख।"
          ],
          "cells_en": [
            "Fa-Hien",
            "4th–5th Century CE",
            "Early account mentioning Sariputta's stupa at Nalanda."
          ]
        },
        {
          "cells_hi": [
            "ह्वेनसांग (Hiuen Tsang)",
            "7वीं शताब्दी (हर्षवर्धन काल)",
            "आचार्य शीलभद्र के शिष्य बने; 10,000 छात्रों व भव्य भवनों का वर्णन।"
          ],
          "cells_en": [
            "Hiuen Tsang",
            "7th Century (Harsha's reign)",
            "Studied under Shilabhadra; recorded 10,000 students and grand halls."
          ]
        },
        {
          "cells_hi": [
            "इत्सिंग (I-Tsing)",
            "7वीं शताब्दी उत्तरार्ध",
            "लगभग 10 वर्ष नालंदा में रहे; 200 गाँवों के दान व 400 संस्कृत ग्रंथों का उल्लेख।"
          ],
          "cells_en": [
            "I-Tsing",
            "Late 7th Century CE",
            "Stayed ~10 years; noted 200 endowed villages and copied 400 Sanskrit texts."
          ]
        }
      ]
    },
    "concept_md_hi": "### 5-अंक सारांश फ़ॉर्मूला (5 आसान वाक्य)\n1. **\"Nalanda: Ancient Seat of Learning\"** is an inspiring speech by **Dr. Rajendra Prasad**, delivered on **20 November 1951**.\n2. Ancient **Nalanda University** in Bihar was a world-famous centre of learning for over seven centuries.\n3. It had **10,000 students**, **1,500 teachers**, free education, and three great libraries (**Ratnasagara, Ratnodadhi, Ratnaranjaka**).\n4. Foreign scholars like **Hiuen Tsang** and **I-Tsing** came from China to study grammar, logic, medicine, arts, and philosophy.\n5. Dr. Prasad urges us to revive not just Nalanda's buildings, but its **true spirit of wisdom, peace, and brotherhood**.",
    "concept_md_en": "### 5-Sentence Board Summary Formula\n1. **\"Nalanda: Ancient Seat of Learning\"** is an inspiring speech by **Dr. Rajendra Prasad**, delivered on **20 November 1951**.\n2. Ancient **Nalanda University** in Bihar was a world-famous centre of learning for over seven centuries.\n3. It had **10,000 students**, **1,500 teachers**, free education, and three great libraries (**Ratnasagara, Ratnodadhi, Ratnaranjaka**).\n4. Foreign scholars like **Hiuen Tsang** and **I-Tsing** came from China to study grammar, logic, medicine, arts, and philosophy.\n5. Dr. Prasad urges us to revive not just Nalanda's buildings, but its **true spirit of wisdom, peace, and brotherhood**.",
    "exam_tip_hi": "परीक्षा में **Dr. Rajendra Prasad**, **20 November 1951**, **Hiuen Tsang**, और **Ratnasagara** ज़रूर लिखें — 5/5 अंक तय हैं!",
    "exam_tip_en": "Include **Dr. Rajendra Prasad**, **20 Nov 1951**, **Hiuen Tsang**, and **Ratnasagara** for guaranteed 5/5!",
    "glossary_terms": [],
    "quick_check": {
      "q_hi": "ह्वेनसांग ने नालंदा में किस महान आचार्य से शिक्षा प्राप्त की थी?",
      "q_en": "Under which great scholar did Hiuen Tsang study at Nalanda?",
      "answer_hi": "आचार्य शीलभद्र (Acharya Shilabhadra) से।",
      "answer_en": "Acharya Shilabhadra."
    }
  }
]$json$::jsonb,
  $json${
  "important_formulas": [],
  "key_dates_or_facts": [
    {
      "tag": "Speaker",
      "fact_hi": "डॉ. राजेंद्र प्रसाद (1884–1963) · जन्म: जीरादेई (सीवान, बिहार)",
      "fact_en": "Dr. Rajendra Prasad (1884–1963) · Born: Zeradei (Siwan, Bihar)"
    },
    {
      "tag": "Date & Event",
      "fact_hi": "20 नवंबर 1951 · मगध रिसर्च इंस्टीट्यूट, नालंदा का शिलान्यास",
      "fact_en": "20 Nov 1951 · Foundation of Magadh Research Institute, Nalanda"
    },
    {
      "tag": "Libraries",
      "fact_hi": "धर्मगंज: रत्नसागर, रत्नोदधि, रत्नरंजक",
      "fact_en": "Dharmaganja: Ratnasagara, Ratnodadhi, Ratnaranjaka"
    },
    {
      "tag": "Summary 1/5",
      "fact_hi": "Delivered by Dr. Rajendra Prasad on 20 November 1951 at Nalanda.",
      "fact_en": "Delivered by Dr. Rajendra Prasad on 20 November 1951 at Nalanda."
    },
    {
      "tag": "Summary 2/5",
      "fact_hi": "Nalanda symbolizes the most glorious era of Indian learning.",
      "fact_en": "Nalanda symbolizes the most glorious era of Indian learning."
    },
    {
      "tag": "Summary 3/5",
      "fact_hi": "It hosted 10,000 students, 1,500 teachers, and free residential study.",
      "fact_en": "It hosted 10,000 students, 1,500 teachers, and free residential study."
    },
    {
      "tag": "Summary 4/5",
      "fact_hi": "Hiuen Tsang and I-Tsing documented its 5 core subjects and vast libraries.",
      "fact_en": "Hiuen Tsang and I-Tsing documented its 5 core subjects and vast libraries."
    },
    {
      "tag": "Summary 5/5",
      "fact_hi": "Dr. Prasad calls upon us to revive Nalanda's spirit of peace and wisdom.",
      "fact_en": "Dr. Prasad calls upon us to revive Nalanda's spirit of peace and wisdom."
    }
  ],
  "common_bseb_mistakes": [
    {
      "mistake_hi": "भाषण देने वाले वक्ता का नाम डॉ. जाकिर हुसैन लिख देना।",
      "mistake_en": "Confusing Dr. Rajendra Prasad with Dr. Zakir Husain.",
      "fix_hi": "याद रखें: **Nalanda (Class 11)** = Dr. Rajendra Prasad; **Bharat is My Home (Class 12)** = Dr. Zakir Husain!",
      "fix_en": "Distinguish: **Nalanda (Class 11)** = Dr. Rajendra Prasad; **Bharat is My Home (Class 12)** = Dr. Zakir Husain!"
    },
    {
      "mistake_hi": "ह्वेनसांग (Hiuen Tsang) को जापानी या तिब्बती यात्री लिख देना।",
      "mistake_en": "Calling Hiuen Tsang a Japanese or Tibetan traveller.",
      "fix_hi": "ह्वेनसांग, फाहियान और इत्सिंग तीनों **चीनी (Chinese)** बौद्ध विद्वान थे।",
      "fix_en": "Fa-Hien, Hiuen Tsang, and I-Tsing were all **Chinese** Buddhist scholars."
    }
  ],
  "high_yield_pyq_topics": [
    {
      "topic_hi": "प्राचीन नालंदा के पुस्तकालय, विषय व छात्र संख्या",
      "topic_en": "Nalanda's Libraries, 5 Subjects & Student Scale",
      "years": [
        "2022",
        "2023",
        "2024"
      ],
      "expected_marks": 5
    },
    {
      "topic_hi": "ह्वेनसांग व इत्सिंग के विवरण तथा डॉ. राजेंद्र प्रसाद का संदेश",
      "topic_en": "Hiuen Tsang, I-Tsing & Dr. Prasad's Message",
      "years": [
        "2021",
        "2023",
        "2024"
      ],
      "expected_marks": 2
    }
  ]
}$json$::jsonb,
  $json${"hindi_reviewed":true,"english_reviewed":true,"visuals_count":4,"analogy_count":4,"bseb_pyq_mapped":true,"syllabus_year":"2026-27"}$json$::jsonb,
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
  'bseb-11-eng-ch2',
  2,
  'छात्र प्राचीन नालंदा विश्वविद्यालय की ऐतिहासिक गरिमा, पुस्तकालयों, 5 मुख्य विषयों और डॉ. राजेंद्र प्रसाद के शैक्षिक दृष्टिकोण को समझ सकेंगे व परीक्षा-उपयोगी उत्तर लिख सकेंगे।',
  'Students will learn ancient Nalanda''s global heritage, libraries, 5-subject curriculum, and Dr. Rajendra Prasad''s vision, and write structured exam answers.',
  $json$[
  {
    "period_no": 1,
    "duration_mins": 40,
    "phase_hi": "बिहार गौरव परिचय, उच्चारण व नालंदा 4-स्तंभ चित्र",
    "phase_en": "Bihar Pride Hook, Pronunciation & 4-Pillar Board Map",
    "teacher_action_hi": "बिहार के मानचित्र पर नालंदा और जीरादेई (सीवान) दिखाकर कक्षा में गर्व जगाएँ। 20 नवंबर 1951 के भाषण का संदर्भ समझाएँ। Glorious (ग्लोरियस), Scholar (स्कॉलर), Manuscript (मैन्युस्क्रिप्ट), Philosophy (फ़िलॉसफ़ी) का सामूहिक उच्चारण कराएँ।",
    "teacher_action_en": "Locate Nalanda and Zeradei (Siwan) on a Bihar map to spark pride. Explain the 20 Nov 1951 speech context and drill pronunciation of Glorious, Scholar, Manuscript, and Philosophy.",
    "student_check_hi": "पूछें: \"नालंदा में कितने छात्र और शिक्षक थे? क्या वहाँ फीस लगती थी?\"",
    "student_check_en": "Ask: \"How many students and teachers were at Nalanda? Was education free?\""
  },
  {
    "period_no": 2,
    "duration_mins": 40,
    "phase_hi": "पुस्तकालय-विषय चर्चा, 5-मिनट मौखिक गतिविधि व 5-अंक सारांश",
    "phase_en": "Libraries & Subjects, 5-Min Oral Drill & 5-Mark Summary",
    "teacher_action_hi": "तीनों पुस्तकालय (रत्नसागर, रत्नोदधि, रत्नरंजक) और 5 विषय बोर्ड पर लिखें। 5-मिनट मौखिक आत्मविश्वास गतिविधि में 5 छात्र 5-वाक्य सारांश पढ़ें। अंत में 5 MCQ का त्वरित परीक्षण लें।",
    "teacher_action_en": "Write the 3 library names and 5 subjects on the board. Run a 5-min oral confidence relay with the 5-sentence summary, closing with 5 quick MCQs.",
    "student_check_hi": "तीनों \"रत्न\" पुस्तकालयों के नाम पूरी कक्षा से एक साथ बुलवाएँ।",
    "student_check_en": "Have the whole class chant the three \"Ratna\" library names together."
  }
]$json$::jsonb,
  $json$[
  {
    "heading_hi": "ब्लैकबोर्ड गौरव बॉक्स (Nalanda)",
    "heading_en": "Blackboard Heritage Box (Nalanda)",
    "points_hi": [
      "वक्ता: Dr. Rajendra Prasad (बिहार के प्रथम राष्ट्रपति) · तिथि: 20 Nov 1951",
      "अवसर: Magadh Research Institute, Nalanda का शिलान्यास",
      "पैमाना: 10,000 छात्र · 1,500 आचार्य · 200 गाँवों के दान से निःशुल्क शिक्षा",
      "पुस्तकालय (धर्मगंज): Ratnasagara, Ratnodadhi, Ratnaranjaka"
    ],
    "points_en": [
      "Speaker: Dr. Rajendra Prasad (First President of India) · Date: 20 Nov 1951",
      "Occasion: Foundation of Magadh Research Institute at Nalanda",
      "Scale: 10,000 students · 1,500 teachers · Free education (200 villages)",
      "Libraries (Dharmaganja): Ratnasagara, Ratnodadhi, Ratnaranjaka"
    ]
  }
]$json$::jsonb,
  $json$[
  {
    "title_hi": "5-मिनट \"यदि मैं नालंदा का द्वार-पंडित होता\" प्रश्नोत्तरी",
    "title_en": "5-Minute \"Nalanda Gatekeeper\" Rapid Quiz",
    "materials_hi": "अध्याय के 6 छोटे तथ्य कार्ड",
    "materials_en": "6 quick fact prompts from the chapter",
    "steps_hi": "एक छात्र द्वार-पंडित बने और दूसरे से 2 आसान प्रश्न पूछे (\"Who gave this speech?\", \"Name one Chinese scholar\")। सही उत्तर पर \"प्रवेश मिला!\" कहकर तालियाँ बजवाएँ।",
    "steps_en": "One student plays the Nalanda gatekeeper asking 2 simple chapter questions; every correct answer earns \"Admitted!\" and applause."
  }
]$json$::jsonb,
  $json$[
  {
    "level": "FOUNDATION",
    "task_hi": "नालंदा के तीनों पुस्तकालयों और तीनों चीनी यात्रियों के नाम अंग्रेज़ी व हिंदी में लिखें।",
    "task_en": "Write the names of the 3 Nalanda libraries and 3 Chinese scholars in English and Hindi."
  },
  {
    "level": "BOARD",
    "task_hi": "प्राचीन नालंदा में कौन-से 5 मुख्य विषय पढ़ाए जाते थे? संक्षिप्त उत्तर लिखें।",
    "task_en": "What were the 5 core subjects taught at ancient Nalanda? Answer briefly."
  },
  {
    "level": "CHALLENGE",
    "task_hi": "डॉ. राजेंद्र प्रसाद के भाषण का 5-अंक सारांश स्वच्छ अंग्रेज़ी में लिखें।",
    "task_en": "Write a neat 5-mark summary of Dr. Rajendra Prasad's speech."
  }
]$json$::jsonb,
  $json$[
  {
    "misconception_hi": "छात्र नालंदा को केवल धार्मिक मठ समझते हैं जहाँ केवल धर्म पढ़ाया जाता था।",
    "misconception_en": "Students assume ancient Nalanda taught only religion.",
    "correction_hi": "स्पष्ट करें कि वहाँ व्याकरण, तर्कशास्त्र, चिकित्सा (Medicine), शिल्प और दर्शन — सभी विषयों की शिक्षा दी जाती थी।",
    "correction_en": "Clarify that Nalanda taught Grammar, Logic, Medicine, Crafts, and Philosophy alike."
  },
  {
    "misconception_hi": "छात्र डॉ. राजेंद्र प्रसाद के भाषण का वर्ष 1947 या 1950 लिख देते हैं।",
    "misconception_en": "Students guess 1947 or 1950 as the speech year.",
    "correction_hi": "सटीक तिथि याद कराएँ: **20 November 1951** (मगध रिसर्च इंस्टीट्यूट का शिलान्यास)।",
    "correction_en": "Drill the exact date: **20 November 1951** (Magadh Research Institute foundation)."
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
  (
    '10000007-0014-4000-8000-000000000001', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Speaker & Occasion', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', 'BSEB Class 11',
    'Nalanda: Ancient Seat of Learning के वक्ता, तिथि व अवसर क्या हैं?',
    'Who delivered "Nalanda: Ancient Seat of Learning", when, and why?',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "\"Nalanda: Ancient Seat of Learning\" किसने, कब और किस अवसर पर दिया?",
  "front_en": "Who delivered \"Nalanda: Ancient Seat of Learning\", when, and on what occasion?",
  "back_hi": "वक्ता: Dr. Rajendra Prasad (1884–1963) · तिथि: 20 November 1951 · अवसर: Magadh Research Institute, Nalanda का शिलान्यास।",
  "back_en": "Speaker: Dr. Rajendra Prasad (1884–1963) · Date: 20 Nov 1951 · Occasion: Foundation of Magadh Research Institute, Nalanda.",
  "pronunciation_hi": "नालंदा: एंशिएंट सीट ऑफ़ लर्निंग",
  "mnemonic_hi": "बिहार के प्रथम राष्ट्रपति ने बिहार के नालंदा पर 1951 में यह भाषण दिया!",
  "mnemonic_en": "Bihar's own Dr. Rajendra Prasad spoke at Bihar's own Nalanda in 1951!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000002', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Libraries Flashcard', 'PRACTICE', 'FLASHCARD', 'FOUNDATION', NULL,
    'नालंदा के तीन पुस्तकालयों के नाम और Manuscript का अर्थ क्या है?',
    'Name Nalanda''s 3 libraries and define "Manuscript".',
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "FLASHCARD",
  "front_hi": "नालंदा के 3 महापुस्तकालयों के नाम और \"Manuscript\" का उच्चारण व अर्थ बताएँ।",
  "front_en": "Name the 3 great libraries of Nalanda and define \"Manuscript\".",
  "back_hi": "पुस्तकालय: Ratnasagara (9-मंज़िला), Ratnodadhi, Ratnaranjaka · Manuscript (मैन्युस्क्रिप्ट) = हस्तलिखित प्राचीन ग्रंथ।",
  "back_en": "Libraries: Ratnasagara (9 storeys), Ratnodadhi, Ratnaranjaka · Manuscript = ancient handwritten book.",
  "pronunciation_hi": "रत्नसागर · रत्नोदधि · रत्नरंजक · मैन्युस्क्रिप्ट",
  "mnemonic_hi": "तीनों के शुरू में \"रत्न\" (Ratna = Jewel) लगा है: सागर, उदधि, रंजक!",
  "mnemonic_en": "All three begin with \"Ratna\" (Jewel): sagara, udadhi, ranjaka!"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000003', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Nalanda Heritage Match', 'PRACTICE', 'MATCH_PAIRS', 'FOUNDATION', 'BSEB Class 11',
    'स्तंभ A को स्तंभ B के सही ऐतिहासिक तथ्य से मिलाएँ:',
    'Match each name in Column A with its correct historical fact in Column B:',
    NULL, NULL,
    'वक्ता, चीनी यात्री, पुस्तकालय और महावीर स्वामी का तथ्य मिलाएँ।', 'Match the speaker, Chinese scholar, library, and Lord Mahavira facts.',
    'डॉ. राजेंद्र प्रसाद ने 1951 में भाषण दिया, ह्वेनसांग आचार्य शीलभद्र के शिष्य थे, रत्नसागर 9-मंज़िला पुस्तकालय था, महावीर ने 14 वर्षावास बिताए।', 'Dr. Rajendra Prasad spoke in 1951, Hiuen Tsang studied under Shilabhadra, Ratnasagara was a 9-storey library, and Mahavira spent 14 rainy seasons.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "MATCH_PAIRS",
  "instruction_hi": "सही ऐतिहासिक जोड़े मिलाएँ",
  "instruction_en": "Match each Nalanda heritage fact",
  "pairs": [
    {
      "id": "nal-p1",
      "left_hi": "Dr. Rajendra Prasad",
      "left_en": "Dr. Rajendra Prasad",
      "right_hi": "20 नवंबर 1951 को नालंदा में भाषण दिया",
      "right_en": "Delivered the Nalanda speech on 20 Nov 1951"
    },
    {
      "id": "nal-p2",
      "left_hi": "Hiuen Tsang (ह्वेनसांग)",
      "left_en": "Hiuen Tsang",
      "right_hi": "आचार्य शीलभद्र से पढ़ने वाले चीनी विद्वान",
      "right_en": "Chinese scholar who studied under Shilabhadra"
    },
    {
      "id": "nal-p3",
      "left_hi": "Ratnasagara (रत्नसागर)",
      "left_en": "Ratnasagara",
      "right_hi": "धर्मगंज का 9-मंज़िला महापुस्तकालय",
      "right_en": "Nine-storey library building of Dharmaganja"
    },
    {
      "id": "nal-p4",
      "left_hi": "Lord Mahavira (महावीर)",
      "left_en": "Lord Mahavira",
      "right_hi": "नालंदा में 14 चातुर्मास बिताए",
      "right_en": "Spent 14 rainy seasons at Nalanda"
    }
  ]
}$json$::jsonb,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000004', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Exam Sentence Builder 1', 'PRACTICE', 'SENTENCE_BUILDER', 'FOUNDATION', NULL,
    'सही वाक्य सजाएँ: "नालंदा में शिक्षा पूरी तरह निःशुल्क थी।"',
    'Build the exam sentence: "Education at Nalanda was completely free"',
    NULL, NULL,
    'Education (Singular) के साथ past tense क्रिया "was" लगेगी।', 'Use singular past verb "was" with "Education".',
    'सही वाक्य: "Education at Nalanda was completely free"।', 'Correct sentence: "Education at Nalanda was completely free".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "नालंदा में शिक्षा पूरी तरह निःशुल्क थी।",
  "prompt_en": "Build this high-scoring fact sentence about Nalanda",
  "grammar_formula": "Subject + at Place + was + Adverb + Adjective",
  "tokens": [
    "Education",
    "at",
    "Nalanda",
    "was",
    "completely",
    "free"
  ],
  "distractors": [
    "were",
    "in"
  ],
  "correct_sentence": "Education at Nalanda was completely free",
  "pronunciation_hi": "एजुकेशन ऐट नालंदा वॉज़ कम्प्लीटली फ़्री"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000005', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Exam Sentence Builder 2', 'PRACTICE', 'SENTENCE_BUILDER', 'BOARD', NULL,
    'सही वाक्य बनाएँ: "नालंदा हमारे गौरवशाली इतिहास का प्रतीक है।"',
    'Build the sentence: "Nalanda is the symbol of our glorious history"',
    NULL, NULL,
    'Subject + is + the symbol of + our glorious history।', 'Follow: Nalanda + is + the symbol of + our glorious history.',
    'सही वाक्य: "Nalanda is the symbol of our glorious history"।', 'Correct sentence: "Nalanda is the symbol of our glorious history".',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    $json${
  "kind": "SENTENCE_BUILDER",
  "prompt_hi": "नालंदा हमारे गौरवशाली इतिहास का प्रतीक है।",
  "prompt_en": "Build the opening tribute line from Dr. Rajendra Prasad's speech",
  "grammar_formula": "Subject + is + the + Noun + of + Possessive + Adjective + Noun",
  "tokens": [
    "Nalanda",
    "is",
    "the",
    "symbol",
    "of",
    "our",
    "glorious",
    "history"
  ],
  "distractors": [
    "are",
    "a"
  ],
  "correct_sentence": "Nalanda is the symbol of our glorious history",
  "pronunciation_hi": "नालंदा इज़ द सिंबल ऑफ़ आवर ग्लोरियस हिस्ट्री"
}$json$::jsonb,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000006', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Speaker MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 11 2023',
    '"Nalanda: Ancient Seat of Learning" भाषण किसने दिया था?',
    'Who delivered the speech "Nalanda: Ancient Seat of Learning"?',
    $json$[{"key":"A","text_hi":"डॉ. जाकिर हुसैन","text_en":"Dr. Zakir Husain"},{"key":"B","text_hi":"महात्मा गांधी","text_en":"Mahatma Gandhi"},{"key":"C","text_hi":"जवाहरलाल नेहरू","text_en":"Jawaharlal Nehru"},{"key":"D","text_hi":"डॉ. राजेंद्र प्रसाद","text_en":"Dr. Rajendra Prasad"}]$json$::jsonb, 'D',
    'बिहार के सीवान जिले (जीरादेई) में जन्मे भारत के प्रथम राष्ट्रपति!', 'India''s first President, born in Zeradei (Siwan, Bihar).',
    'डॉ. राजेंद्र प्रसाद ने 20 नवंबर 1951 को यह ऐतिहासिक भाषण दिया था।', 'Dr. Rajendra Prasad delivered this historic speech on 20 November 1951.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000007', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Speech Date MCQ', 'PRACTICE', 'MCQ', 'FOUNDATION', 'BSEB Class 11 2022',
    'डॉ. राजेंद्र प्रसाद ने नालंदा में मगध रिसर्च इंस्टीट्यूट का शिलान्यास कब किया?',
    'When did Dr. Rajendra Prasad lay the foundation stone of the Magadh Research Institute at Nalanda?',
    $json$[{"key":"A","text_hi":"26 जनवरी 1950","text_en":"26 January 1950"},{"key":"B","text_hi":"20 नवंबर 1951","text_en":"20 November 1951"},{"key":"C","text_hi":"2 अक्टूबर 1955","text_en":"2 October 1955"},{"key":"D","text_hi":"15 अगस्त 1947","text_en":"15 August 1947"}]$json$::jsonb, 'B',
    'नवंबर 1951 की तिथि याद करें!', 'Recall the exact November 1951 date.',
    'यह भाषण 20 नवंबर 1951 को नालंदा में दिया गया था।', 'Dr. Rajendra Prasad delivered this speech on 20 November 1951.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000008', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Chinese Scholars MCQ', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Class 11 2024',
    'नालंदा का विस्तृत वर्णन करने वाले प्रसिद्ध चीनी यात्री ह्वेनसांग (Hiuen Tsang) ने किस आचार्य से शिक्षा ली?',
    'Under which great Nalanda teacher did the famous Chinese traveller Hiuen Tsang study?',
    $json$[{"key":"A","text_hi":"आचार्य शीलभद्र","text_en":"Acharya Shilabhadra"},{"key":"B","text_hi":"आर्यभट्ट","text_en":"Aryabhata"},{"key":"C","text_hi":"पाणिनि","text_en":"Panini"},{"key":"D","text_hi":"आचार्य चाणक्य","text_en":"Acharya Chanakya"}]$json$::jsonb, 'A',
    '7वीं शताब्दी में नालंदा के कुलपति (Head) कौन थे?', 'Who was the Vice-Chancellor of Nalanda in the 7th century?',
    'ह्वेनसांग ने नालंदा के महान कुलपति आचार्य शीलभद्र के मार्गदर्शन में अध्ययन किया।', 'Hiuen Tsang studied at Nalanda under its renowned Vice-Chancellor Acharya Shilabhadra.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000009', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Students & Teachers Scale', 'PRACTICE', 'MCQ', 'BOARD', 'BSEB Class 11 2023',
    'अपने उत्कर्ष काल में प्राचीन नालंदा विश्वविद्यालय में लगभग कितने छात्र और शिक्षक थे?',
    'At its peak, roughly how many students and teachers lived at ancient Nalanda University?',
    $json$[{"key":"A","text_hi":"1,000 छात्र व 100 शिक्षक","text_en":"1,000 students and 100 teachers"},{"key":"B","text_hi":"5,000 छात्र व 500 शिक्षक","text_en":"5,000 students and 500 teachers"},{"key":"C","text_hi":"10,000 छात्र व 1,500 शिक्षक","text_en":"10,000 students and 1,500 teachers"},{"key":"D","text_hi":"2,000 छात्र व 200 शिक्षक","text_en":"2,000 students and 200 teachers"}]$json$::jsonb, 'C',
    'ह्वेनसांग के अनुसार दस हज़ार विद्यार्थी और डेढ़ हज़ार आचार्य थे!', 'Hiuen Tsang recorded ten thousand students and fifteen hundred teachers.',
    'अपने चरम गौरव पर नालंदा में लगभग 10,000 विद्यार्थी और 1,500 शिक्षक निवास करते थे।', 'At its zenith, Nalanda housed about 10,000 students and 1,500 teachers.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000010', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Lord Mahavira & Nalanda', 'PRACTICE', 'MCQ', 'TOPPER', 'BSEB Class 11 2024',
    'जैन ग्रंथों के अनुसार भगवान महावीर ने नालंदा में कितने वर्षावास (चातुर्मास) बिताए थे?',
    'According to Jain records mentioned in the chapter, how many rainy seasons did Lord Mahavira spend at Nalanda?',
    $json$[{"key":"A","text_hi":"21 वर्षावास","text_en":"21 rainy seasons"},{"key":"B","text_hi":"5 वर्षावास","text_en":"5 rainy seasons"},{"key":"C","text_hi":"10 वर्षावास","text_en":"10 rainy seasons"},{"key":"D","text_hi":"14 वर्षावास","text_en":"14 rainy seasons"}]$json$::jsonb, 'D',
    'चौदह (Fourteen) की संख्या याद रखें!', 'Remember the number fourteen.',
    'जैन ग्रंथों के अनुसार भगवान महावीर ने नालंदा में 14 वर्षावास (14 rainy seasons) बिताए थे।', 'Jain texts record that Lord Mahavira spent 14 rainy seasons at Nalanda.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000011', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Exam Pool: Library Complex', 'EXAM_ONLY', 'MCQ', 'BOARD', 'BSEB Class 11 2023',
    'इनमें से कौन-सा भवन नालंदा के तीन प्रसिद्ध पुस्तकालयों में शामिल था?',
    'Which of the following was one of the three celebrated library buildings of Nalanda?',
    $json$[{"key":"A","text_hi":"रत्नसागर (Ratnasagara)","text_en":"Ratnasagara"},{"key":"B","text_hi":"तक्षशिला भवन","text_en":"Takshashila Hall"},{"key":"C","text_hi":"पाटलिपुत्र सभागार","text_en":"Pataliputra Hall"},{"key":"D","text_hi":"विक्रमशिला स्तूप","text_en":"Vikramshila Stupa"}]$json$::jsonb, 'A',
    'तीनों पुस्तकालयों के नाम "रत्न" से शुरू होते हैं।', 'All three libraries begin with "Ratna".',
    'धर्मगंज के तीन पुस्तकालय थे: रत्नसागर (9 मंज़िल), रत्नोदधि और रत्नरंजक।', 'The three libraries of Dharmaganja were Ratnasagara, Ratnodadhi, and Ratnaranjaka.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000012', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Exam Pool: Core Subjects Count', 'EXAM_ONLY', 'MCQ', 'TOPPER', 'BSEB Class 11 2024',
    'प्राचीन नालंदा में हर विद्यार्थी के लिए कितने मुख्य विषयों का अध्ययन अनिवार्य था?',
    'How many core subjects were compulsory for students at ancient Nalanda?',
    $json$[{"key":"A","text_hi":"तीन (Three)","text_en":"Three"},{"key":"B","text_hi":"पाँच (Five)","text_en":"Five"},{"key":"C","text_hi":"दस (Ten)","text_en":"Ten"},{"key":"D","text_hi":"दो (Two)","text_en":"Two"}]$json$::jsonb, 'B',
    'शब्दविद्या, हेतुविद्या, चिकित्साविद्या, शिल्पविद्या और अध्यात्मविद्या गिनें!', 'Count Grammar, Logic, Medicine, Handicrafts, and Philosophy.',
    'नालंदा में 5 अनिवार्य विषय थे: व्याकरण, तर्कशास्त्र, चिकित्सा, शिल्पविद्या और दर्शन।', 'Five core subjects were taught: Grammar, Logic, Medicine, Crafts, and Philosophy.',
    NULL, NULL,
    $json$[]$json$::jsonb,
    $json$[]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000013', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Nalanda Libraries 2M', 'PRACTICE', 'SHORT_2M', 'BOARD', 'BSEB Class 11 2023',
    'प्राचीन नालंदा विश्वविद्यालय में शिक्षा का खर्च कैसे चलता था और इसके पुस्तकालय का नाम क्या था?',
    'How was free education funded at ancient Nalanda, and what was its library complex called?',
    NULL, NULL,
    'गाँवों का दान (100–200 गाँव) और धर्मगंज के 3 पुस्तकालय लिखें।', 'Mention village revenue grants (100–200 villages) and Dharmaganja''s 3 libraries.',
    NULL, NULL,
    'प्राचीन नालंदा विश्वविद्यालय में विद्यार्थियों से कोई शुल्क नहीं लिया जाता था; इसका पूरा खर्च राजाओं और दानदाताओं द्वारा दिए गए **100 से 200 गाँवों के राजस्व** से चलता था। इसके विशाल पुस्तकालय परिसर का नाम **धर्मगंज (Dharmaganja)** था, जिसमें **रत्नसागर, रत्नोदधि और रत्नरंजक** नामक तीन भव्य भवन थे।', 'Education at ancient Nalanda was completely free, financed by the revenue of **100 to 200 endowed villages** gifted by kings and donors. Its grand library complex was called **Dharmaganja**, comprising three towering buildings: **Ratnasagara, Ratnodadhi, and Ratnaranjaka**.',
    $json$[{"cue_hi":"200 गाँवों के राजस्व से निःशुल्क शिक्षा","cue_en":"Free study funded by 200 villages"},{"cue_hi":"धर्मगंज: रत्नसागर, रत्नोदधि, रत्नरंजक","cue_en":"Dharmaganja: Ratnasagara, Ratnodadhi, Ratnaranjaka"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"निःशुल्क शिक्षा व गाँवों के दान (endowment) का उल्लेख","criterion_en":"Explains free education funded by endowed villages"},{"step_no":2,"marks":1,"criterion_hi":"धर्मगंज व तीन पुस्तकालयों के सही नाम","criterion_en":"Correctly names Dharmaganja and its 3 libraries"}]$json$::jsonb,
    NULL,
    true
  ),
  (
    '10000007-0014-4000-8000-000000000014', 'bseb-11-lang1-eng', 'bseb-11-eng-ch2', 'Summary & Vision 5M', 'PRACTICE', 'LONG_5M', 'TOPPER', 'BSEB Class 11 2024',
    '"Nalanda: Ancient Seat of Learning" पाठ का सारांश लिखें और डॉ. राजेंद्र प्रसाद के मुख्य संदेश पर प्रकाश डालें।',
    'Write the summary of "Nalanda: Ancient Seat of Learning" and explain Dr. Rajendra Prasad''s message.',
    NULL, NULL,
    '20 नवंबर 1951, 10,000 छात्र/1,500 शिक्षक, ह्वेनसांग-इत्सिंग, 3 पुस्तकालय, 5 विषय और सच्ची भावना का पुनर्जागरण लिखें।', 'Cover 20 Nov 1951, 10,000 students, Hiuen Tsang/I-Tsing, 3 libraries, 5 subjects, and reviving Nalanda''s spirit.',
    NULL, NULL,
    '**"Nalanda: Ancient Seat of Learning"** भारत के प्रथम राष्ट्रपति **डॉ. राजेंद्र प्रसाद** द्वारा **20 नवंबर 1951** को नालंदा में **मगध रिसर्च इंस्टीट्यूट** के शिलान्यास पर दिया गया एक प्रेरणादायक भाषण है।

डॉ. प्रसाद बताते हैं कि प्राचीन नालंदा भारतीय इतिहास के सबसे गौरवशाली युग का प्रतीक है। भगवान महावीर और बुद्ध से जुड़ी इस भूमि पर आगे चलकर विश्व का महान आवासीय विश्वविद्यालय बना, जहाँ **10,000 विद्यार्थी और 1,500 आचार्य** रहते थे। चीन, कोरिया, जापान और तिब्बत से **ह्वेनसांग और इत्सिंग** जैसे विद्वान यहाँ व्याकरण, तर्कशास्त्र, चिकित्सा, शिल्प और दर्शनशास्त्र पढ़ने आए। 200 गाँवों के दान से शिक्षा पूरी तरह निःशुल्क थी, और धर्मगंज के **रत्नसागर, रत्नोदधि व रत्नरंजक** पुस्तकालय विश्वप्रसिद्ध थे।

अंत में डॉ. राजेंद्र प्रसाद आह्वान करते हैं कि हमें केवल नालंदा की ईंट-पत्थर की इमारतें नहीं, बल्कि इसकी **ज्ञान, अहिंसा और विश्व-बंधुत्व की सच्ची भावना** को पुनर्जीवित करना है।', '**"Nalanda: Ancient Seat of Learning"** is an inspiring speech delivered by India''s first President, **Dr. Rajendra Prasad**, on **20 November 1951** at the foundation ceremony of the **Magadh Research Institute** in Nalanda.

Dr. Prasad hails ancient Nalanda as the symbol of the most glorious period of Indian history. Associated with Lord Mahavira and Lord Buddha, Nalanda blossomed into a world-renowned residential university with **10,000 students and 1,500 teachers**. Scholars like **Hiuen Tsang** and **I-Tsing** travelled from China and across Asia to study five compulsory fields — Grammar, Logic, Medicine, Crafts, and Philosophy. Education was completely free, funded by endowed villages, and enriched by the three grand libraries of Dharmaganja: **Ratnasagara, Ratnodadhi, and Ratnaranjaka**.

Dr. Prasad concludes with a noble vision: we must revive not merely Nalanda''s brick walls, but its **true spirit of scholarship, peace, and universal brotherhood**.',
    $json$[{"cue_hi":"Dr. Rajendra Prasad · 20 Nov 1951 · Magadh Research Institute","cue_en":"Dr. Rajendra Prasad · 20 Nov 1951 · Magadh Research Institute"},{"cue_hi":"10,000 students, 1,500 teachers, free study","cue_en":"10,000 students, 1,500 teachers, free study"},{"cue_hi":"Hiuen Tsang, I-Tsing, 3 Ratna libraries, 5 subjects","cue_en":"Hiuen Tsang, I-Tsing, 3 Ratna libraries, 5 subjects"},{"cue_hi":"Revive true spirit, not just buildings","cue_en":"Revive true spirit, not just buildings"}]$json$::jsonb,
    $json$[{"step_no":1,"marks":1,"criterion_hi":"वक्ता (Dr. Rajendra Prasad), तिथि (20 Nov 1951) व अवसर","criterion_en":"Names speaker, date (20 Nov 1951), and Magadh Research Institute"},{"step_no":2,"marks":1.5,"criterion_hi":"छात्र-शिक्षक संख्या, निःशुल्क शिक्षा व विदेशी विद्वान (Hiuen Tsang)","criterion_en":"Mentions 10,000 students, free education, and Chinese scholars"},{"step_no":3,"marks":1.5,"criterion_hi":"तीन पुस्तकालय (Ratnasagara आदि) व 5 मुख्य विषयों का उल्लेख","criterion_en":"Lists Dharmaganja libraries and 5 compulsory subjects"},{"step_no":4,"marks":1,"criterion_hi":"नालंदा की सच्ची ज्ञान-भावना के पुनर्जागरण का निष्कर्ष","criterion_en":"States concluding message of reviving Nalanda's true spirit"}]$json$::jsonb,
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
