-- =============================================================================
-- Students of Bihar (9-12) — Official BSEB Class 9-12 Subject & Chapter Catalog
-- Idempotent seed migration (ON CONFLICT DO UPDATE).
-- Follows authentic Bihar School Examination Board (BSEB) subject codes,
-- Class 9-10 (Mandatory + MIL + SIL + Optional Skill/Add) and
-- Class 11-12 (Arts / Science / Commerce: Lang 1 + Lang 2 + 3 Electives + Add).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. SUBJECTS CATALOG (Class 9, 10, 11, 12)
-- -----------------------------------------------------------------------------

INSERT INTO public.subjects (
  id, bseb_code, class_num, stream, category, name_en, name_hi, icon_name, accent_color, sort_order
) VALUES
  -- ========================= CLASS 9 (BSEB SECONDARY) =========================
  ('bseb-9-math',       '110', 9,  'NA', 'MANDATORY',  'Mathematics',                                   'गणित',                                    'Calculator',     '#1E3A8A', 10),
  ('bseb-9-sci',        '112', 9,  'NA', 'MANDATORY',  'Science',                                       'विज्ञान',                                  'FlaskConical',   '#059669', 20),
  ('bseb-9-sst',        '111', 9,  'NA', 'MANDATORY',  'Social Science',                                'सामाजिक विज्ञान',                          'Landmark',       '#B45309', 30),
  ('bseb-9-eng',        '113', 9,  'NA', 'MANDATORY',  'English (Compulsory)',                          'अंग्रेज़ी (अनिवार्य)',                     'BookOpen',       '#4338CA', 40),
  -- Class 9 MIL (Mother Tongue)
  ('bseb-9-mil-hi',     '101', 9,  'NA', 'MIL',        'Hindi (MIL)',                                   'हिन्दी (मातृभाषा)',                        'BookText',       '#C2410C', 50),
  ('bseb-9-mil-bn',     '102', 9,  'NA', 'MIL',        'Bangla (MIL)',                                  'बांग्ला (मातृभाषा)',                       'BookText',       '#9A3412', 51),
  ('bseb-9-mil-ur',     '103', 9,  'NA', 'MIL',        'Urdu (MIL)',                                    'उर्दू (मातृभाषा)',                         'BookText',       '#0F766E', 52),
  ('bseb-9-mil-mai',    '104', 9,  'NA', 'MIL',        'Maithili (MIL)',                                'मैथिली (मातृभाषा)',                        'BookText',       '#7C2D12', 53),
  -- Class 9 SIL (Second Indian Language)
  ('bseb-9-sil-san',    '105', 9,  'NA', 'SIL',        'Sanskrit (SIL)',                                'संस्कृत (द्वितीय भारतीय भाषा)',            'ScrollText',     '#92400E', 60),
  ('bseb-9-sil-nhi',    '106', 9,  'NA', 'SIL',        'Non-Hindi / Rashtrabhasha Hindi (SIL)',         'अहिन्दी / राष्ट्रभाषा हिन्दी (द्वितीय भाषा)', 'ScrollText',   '#B45309', 61),
  ('bseb-9-sil-ar',     '107', 9,  'NA', 'SIL',        'Arabic (SIL)',                                  'अरबी (द्वितीय भारतीय भाषा)',               'ScrollText',     '#115E59', 62),
  ('bseb-9-sil-fa',     '108', 9,  'NA', 'SIL',        'Persian (SIL)',                                 'फारसी (द्वितीय भारतीय भाषा)',              'ScrollText',     '#155E75', 63),
  ('bseb-9-sil-bho',    '109', 9,  'NA', 'SIL',        'Bhojpuri (SIL)',                                'भोजपुरी (द्वितीय भारतीय भाषा)',            'ScrollText',     '#9A3412', 64),
  -- Class 9 Optional Skill / Additional
  ('bseb-9-skill-ict',  '125', 9,  'NA', 'SKILL',      'Information & Communication Technology (ICT)',  'सूचना एवं संचार प्रौद्योगिकी (ICT)',        'Laptop',         '#1D4ED8', 70),
  ('bseb-9-add-hmath',  '114', 9,  'NA', 'ADDITIONAL', 'Higher Mathematics (Optional)',                 'उच्च गणित (ऐच्छिक)',                       'Sigma',          '#1E40AF', 71),
  ('bseb-9-add-eco',    '115', 9,  'NA', 'ADDITIONAL', 'Economics (Optional)',                          'अर्थशास्त्र (ऐच्छिक)',                     'TrendingUp',     '#047857', 72),
  ('bseb-9-add-hsci',   '120', 9,  'NA', 'ADDITIONAL', 'Home Science (Optional)',                       'गृह विज्ञान (ऐच्छिक)',                     'Home',           '#BE185D', 73),

  -- ========================= CLASS 10 (BSEB MATRIC) =========================
  ('bseb-10-math',      '110', 10, 'NA', 'MANDATORY',  'Mathematics',                                   'गणित',                                    'Calculator',     '#1E3A8A', 10),
  ('bseb-10-sci',       '112', 10, 'NA', 'MANDATORY',  'Science',                                       'विज्ञान',                                  'FlaskConical',   '#059669', 20),
  ('bseb-10-sst',       '111', 10, 'NA', 'MANDATORY',  'Social Science',                                'सामाजिक विज्ञान',                          'Landmark',       '#B45309', 30),
  ('bseb-10-eng',       '113', 10, 'NA', 'MANDATORY',  'English (Compulsory)',                          'अंग्रेज़ी (अनिवार्य)',                     'BookOpen',       '#4338CA', 40),
  -- Class 10 MIL
  ('bseb-10-mil-hi',    '101', 10, 'NA', 'MIL',        'Hindi (MIL)',                                   'हिन्दी (मातृभाषा)',                        'BookText',       '#C2410C', 50),
  ('bseb-10-mil-bn',    '102', 10, 'NA', 'MIL',        'Bangla (MIL)',                                  'बांग्ला (मातृभाषा)',                       'BookText',       '#9A3412', 51),
  ('bseb-10-mil-ur',    '103', 10, 'NA', 'MIL',        'Urdu (MIL)',                                    'उर्दू (मातृभाषा)',                         'BookText',       '#0F766E', 52),
  ('bseb-10-mil-mai',   '104', 10, 'NA', 'MIL',        'Maithili (MIL)',                                'मैथिली (मातृभाषा)',                        'BookText',       '#7C2D12', 53),
  -- Class 10 SIL
  ('bseb-10-sil-san',   '105', 10, 'NA', 'SIL',        'Sanskrit (SIL)',                                'संस्कृत (द्वितीय भारतीय भाषा)',            'ScrollText',     '#92400E', 60),
  ('bseb-10-sil-nhi',   '106', 10, 'NA', 'SIL',        'Non-Hindi / Rashtrabhasha Hindi (SIL)',         'अहिन्दी / राष्ट्रभाषा हिन्दी (द्वितीय भाषा)', 'ScrollText',   '#B45309', 61),
  ('bseb-10-sil-ar',    '107', 10, 'NA', 'SIL',        'Arabic (SIL)',                                  'अरबी (द्वितीय भारतीय भाषा)',               'ScrollText',     '#115E59', 62),
  ('bseb-10-sil-fa',    '108', 10, 'NA', 'SIL',        'Persian (SIL)',                                 'फारसी (द्वितीय भारतीय भाषा)',              'ScrollText',     '#155E75', 63),
  ('bseb-10-sil-bho',   '109', 10, 'NA', 'SIL',        'Bhojpuri (SIL)',                                'भोजपुरी (द्वितीय भारतीय भाषा)',            'ScrollText',     '#9A3412', 64),
  -- Class 10 Optional Skill / Additional
  ('bseb-10-skill-ict', '125', 10, 'NA', 'SKILL',      'Information & Communication Technology (ICT)',  'सूचना एवं संचार प्रौद्योगिकी (ICT)',        'Laptop',         '#1D4ED8', 70),
  ('bseb-10-add-hmath', '114', 10, 'NA', 'ADDITIONAL', 'Higher Mathematics (Optional)',                 'उच्च गणित (ऐच्छिक)',                       'Sigma',          '#1E40AF', 71),
  ('bseb-10-add-eco',   '115', 10, 'NA', 'ADDITIONAL', 'Economics (Optional)',                          'अर्थशास्त्र (ऐच्छिक)',                     'TrendingUp',     '#047857', 72),
  ('bseb-10-add-hsci',  '120', 10, 'NA', 'ADDITIONAL', 'Home Science (Optional)',                       'गृह विज्ञान (ऐच्छिक)',                     'Home',           '#BE185D', 73),

  -- ========================= CLASS 11 (BSEB INTERMEDIATE) =========================
  -- Compulsory Language 1 (Pick 1: English or Hindi)
  ('bseb-11-lang1-eng',     '105/205/305', 11, 'ALL',      'LANG_1',     'English (Compulsory Lang-1)',       'अंग्रेज़ी (प्रथम भाषा)',              'BookOpen',     '#4338CA', 10),
  ('bseb-11-lang1-hi',      '106/206/306', 11, 'ALL',      'LANG_1',     'Hindi (Compulsory Lang-1)',         'हिन्दी (प्रथम भाषा)',                 'BookText',     '#C2410C', 11),
  -- Compulsory Language 2 (Pick 1 distinct from Lang-1)
  ('bseb-11-lang2-eng',     '124/224/324', 11, 'ALL',      'LANG_2',     'English (Compulsory Lang-2)',       'अंग्रेज़ी (द्वितीय भाषा)',            'BookOpen',     '#3730A3', 20),
  ('bseb-11-lang2-hi',      '125/225/325', 11, 'ALL',      'LANG_2',     'Hindi (Compulsory Lang-2)',         'हिन्दी (द्वितीय भाषा)',               'BookText',     '#9A3412', 21),
  ('bseb-11-lang2-ur',      '107/207/307', 11, 'ALL',      'LANG_2',     'Urdu (Compulsory Lang-2)',          'उर्दू (द्वितीय भाषा)',                'ScrollText',   '#0F766E', 22),
  ('bseb-11-lang2-mai',     '108/208/308', 11, 'ALL',      'LANG_2',     'Maithili (Compulsory Lang-2)',      'मैथिली (द्वितीय भाषा)',               'ScrollText',   '#7C2D12', 23),
  ('bseb-11-lang2-san',     '109/209/309', 11, 'ALL',      'LANG_2',     'Sanskrit (Compulsory Lang-2)',      'संस्कृत (द्वितीय भाषा)',              'ScrollText',   '#92400E', 24),
  ('bseb-11-lang2-bn',      '115/215/315', 11, 'ALL',      'LANG_2',     'Bangla (Compulsory Lang-2)',        'बांग्ला (द्वितीय भाषा)',              'ScrollText',   '#854D0E', 25),
  ('bseb-11-lang2-bho',     '116/216/316', 11, 'ALL',      'LANG_2',     'Bhojpuri (Compulsory Lang-2)',      'भोजपुरी (द्वितीय भाषा)',              'ScrollText',   '#9A3412', 26),
  -- Class 11 Science Electives & Additional
  ('bseb-11-sci-phy',       '117',         11, 'Science',  'ELECTIVE',   'Physics',                           'भौतिकी',                              'Atom',         '#1E3A8A', 30),
  ('bseb-11-sci-chem',      '118',         11, 'Science',  'ELECTIVE',   'Chemistry',                         'रसायन विज्ञान',                       'FlaskConical', '#059669', 31),
  ('bseb-11-sci-math',      '121',         11, 'Science',  'ELECTIVE',   'Mathematics',                       'गणित',                                'Calculator',   '#2563EB', 32),
  ('bseb-11-sci-bio',       '119',         11, 'Science',  'ELECTIVE',   'Biology',                           'जीव विज्ञान',                         'Dna',          '#15803D', 33),
  ('bseb-11-sci-agri',      '120',         11, 'Science',  'ELECTIVE',   'Agriculture',                       'कृषि विज्ञान',                        'Sprout',       '#65A30D', 34),
  ('bseb-11-sci-add-math',  '121',         11, 'Science',  'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 40),
  ('bseb-11-sci-add-bio',   '119',         11, 'Science',  'ADDITIONAL', 'Biology (Additional)',              'जीव विज्ञान (अतिरिक्त)',              'Dna',          '#166534', 41),
  ('bseb-11-sci-add-cs',    '122',         11, 'Science',  'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 42),
  -- Class 11 Arts Electives & Additional
  ('bseb-11-arts-hist',     '321',         11, 'Arts',     'ELECTIVE',   'History',                           'इतिहास',                              'Landmark',     '#B45309', 30),
  ('bseb-11-arts-pol',      '322',         11, 'Arts',     'ELECTIVE',   'Political Science',                 'राजनीति विज्ञान',                     'Scale',        '#1E3A8A', 31),
  ('bseb-11-arts-geo',      '323',         11, 'Arts',     'ELECTIVE',   'Geography',                         'भूगोल',                               'Globe',        '#047857', 32),
  ('bseb-11-arts-eco',      '326',         11, 'Arts',     'ELECTIVE',   'Economics',                         'अर्थशास्त्र',                         'TrendingUp',   '#0F766E', 33),
  ('bseb-11-arts-psy',      '324',         11, 'Arts',     'ELECTIVE',   'Psychology',                        'मनोविज्ञान',                          'Brain',        '#7C3AED', 34),
  ('bseb-11-arts-soc',      '325',         11, 'Arts',     'ELECTIVE',   'Sociology',                         'समाजशास्त्र',                         'Users',        '#0369A1', 35),
  ('bseb-11-arts-phil',     '320',         11, 'Arts',     'ELECTIVE',   'Philosophy',                        'दर्शनशास्त्र',                        'Compass',      '#475569', 36),
  ('bseb-11-arts-hsci',     '319',         11, 'Arts',     'ELECTIVE',   'Home Science',                      'गृह विज्ञान',                         'Home',         '#BE185D', 37),
  ('bseb-11-arts-mus',      '318',         11, 'Arts',     'ELECTIVE',   'Music',                             'संगीत',                               'Music',        '#9333EA', 38),
  ('bseb-11-arts-add-cs',   '328',         11, 'Arts',     'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 40),
  ('bseb-11-arts-add-math', '327',         11, 'Arts',     'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 41),
  -- Class 11 Commerce Electives & Additional
  ('bseb-11-com-acc',       '220',         11, 'Commerce', 'ELECTIVE',   'Accountancy',                       'लेखाशास्त्र',                         'FileSpreadsheet', '#1E3A8A', 30),
  ('bseb-11-com-bst',       '217',         11, 'Commerce', 'ELECTIVE',   'Business Studies',                  'व्यावसायिक अध्ययन',                   'Briefcase',    '#0369A1', 31),
  ('bseb-11-com-eps',       '218',         11, 'Commerce', 'ELECTIVE',   'Entrepreneurship',                  'उद्यमिता',                            'Lightbulb',    '#D97706', 32),
  ('bseb-11-com-eco',       '219',         11, 'Commerce', 'ELECTIVE',   'Economics',                         'अर्थशास्त्र',                         'TrendingUp',   '#047857', 33),
  ('bseb-11-com-add-cs',    '221',         11, 'Commerce', 'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 40),
  ('bseb-11-com-add-math',  '222',         11, 'Commerce', 'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 41),

  -- ========================= CLASS 12 (BSEB INTERMEDIATE BOARD) =========================
  -- Compulsory Language 1
  ('bseb-12-lang1-eng',     '105/205/305', 12, 'ALL',      'LANG_1',     'English (Compulsory Lang-1)',       'अंग्रेज़ी (प्रथम भाषा)',              'BookOpen',     '#4338CA', 10),
  ('bseb-12-lang1-hi',      '106/206/306', 12, 'ALL',      'LANG_1',     'Hindi (Compulsory Lang-1)',         'हिन्दी (प्रथम भाषा)',                 'BookText',     '#C2410C', 11),
  -- Compulsory Language 2
  ('bseb-12-lang2-eng',     '124/224/324', 12, 'ALL',      'LANG_2',     'English (Compulsory Lang-2)',       'अंग्रेज़ी (द्वितीय भाषा)',            'BookOpen',     '#3730A3', 20),
  ('bseb-12-lang2-hi',      '125/225/325', 12, 'ALL',      'LANG_2',     'Hindi (Compulsory Lang-2)',         'हिन्दी (द्वितीय भाषा)',               'BookText',     '#9A3412', 21),
  ('bseb-12-lang2-ur',      '107/207/307', 12, 'ALL',      'LANG_2',     'Urdu (Compulsory Lang-2)',          'उर्दू (द्वितीय भाषा)',                'ScrollText',   '#0F766E', 22),
  ('bseb-12-lang2-mai',     '108/208/308', 12, 'ALL',      'LANG_2',     'Maithili (Compulsory Lang-2)',      'मैथिली (द्वितीय भाषा)',               'ScrollText',   '#7C2D12', 23),
  ('bseb-12-lang2-san',     '109/209/309', 12, 'ALL',      'LANG_2',     'Sanskrit (Compulsory Lang-2)',      'संस्कृत (द्वितीय भाषा)',              'ScrollText',   '#92400E', 24),
  ('bseb-12-lang2-bn',      '115/215/315', 12, 'ALL',      'LANG_2',     'Bangla (Compulsory Lang-2)',        'बांग्ला (द्वितीय भाषा)',              'ScrollText',   '#854D0E', 25),
  ('bseb-12-lang2-bho',     '116/216/316', 12, 'ALL',      'LANG_2',     'Bhojpuri (Compulsory Lang-2)',      'भोजपुरी (द्वितीय भाषा)',              'ScrollText',   '#9A3412', 26),
  -- Class 12 Science Electives & Additional
  ('bseb-12-sci-phy',       '117',         12, 'Science',  'ELECTIVE',   'Physics',                           'भौतिकी',                              'Atom',         '#1E3A8A', 30),
  ('bseb-12-sci-chem',      '118',         12, 'Science',  'ELECTIVE',   'Chemistry',                         'रसायन विज्ञान',                       'FlaskConical', '#059669', 31),
  ('bseb-12-sci-math',      '121',         12, 'Science',  'ELECTIVE',   'Mathematics',                       'गणित',                                'Calculator',   '#2563EB', 32),
  ('bseb-12-sci-bio',       '119',         12, 'Science',  'ELECTIVE',   'Biology',                           'जीव विज्ञान',                         'Dna',          '#15803D', 33),
  ('bseb-12-sci-agri',      '120',         12, 'Science',  'ELECTIVE',   'Agriculture',                       'कृषि विज्ञान',                        'Sprout',       '#65A30D', 34),
  ('bseb-12-sci-add-math',  '121',         12, 'Science',  'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 40),
  ('bseb-12-sci-add-bio',   '119',         12, 'Science',  'ADDITIONAL', 'Biology (Additional)',              'जीव विज्ञान (अतिरिक्त)',              'Dna',          '#166534', 41),
  ('bseb-12-sci-add-cs',    '122',         12, 'Science',  'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 42),
  -- Class 12 Arts Electives & Additional
  ('bseb-12-arts-hist',     '321',         12, 'Arts',     'ELECTIVE',   'History',                           'इतिहास',                              'Landmark',     '#B45309', 30),
  ('bseb-12-arts-pol',      '322',         12, 'Arts',     'ELECTIVE',   'Political Science',                 'राजनीति विज्ञान',                     'Scale',        '#1E3A8A', 31),
  ('bseb-12-arts-geo',      '323',         12, 'Arts',     'ELECTIVE',   'Geography',                         'भूगोल',                               'Globe',        '#047857', 32),
  ('bseb-12-arts-eco',      '326',         12, 'Arts',     'ELECTIVE',   'Economics',                         'अर्थशास्त्र',                         'TrendingUp',   '#0F766E', 33),
  ('bseb-12-arts-psy',      '324',         12, 'Arts',     'ELECTIVE',   'Psychology',                        'मनोविज्ञान',                          'Brain',        '#7C3AED', 34),
  ('bseb-12-arts-soc',      '325',         12, 'Arts',     'ELECTIVE',   'Sociology',                         'समाजशास्त्र',                         'Users',        '#0369A1', 35),
  ('bseb-12-arts-phil',     '320',         12, 'Arts',     'ELECTIVE',   'Philosophy',                        'दर्शनशास्त्र',                        'Compass',      '#475569', 36),
  ('bseb-12-arts-hsci',     '319',         12, 'Arts',     'ELECTIVE',   'Home Science',                      'गृह विज्ञान',                         'Home',         '#BE185D', 37),
  ('bseb-12-arts-mus',      '318',         12, 'Arts',     'ELECTIVE',   'Music',                             'संगीत',                               'Music',        '#9333EA', 38),
  ('bseb-12-arts-add-cs',   '328',         12, 'Arts',     'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 40),
  ('bseb-12-arts-add-math', '327',         12, 'Arts',     'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 41),
  -- Class 12 Commerce Electives & Additional
  ('bseb-12-com-acc',       '220',         12, 'Commerce', 'ELECTIVE',   'Accountancy',                       'लेखाशास्त्र',                         'FileSpreadsheet', '#1E3A8A', 30),
  ('bseb-12-com-bst',       '217',         12, 'Commerce', 'ELECTIVE',   'Business Studies',                  'व्यावसायिक अध्ययन',                   'Briefcase',    '#0369A1', 31),
  ('bseb-12-com-eps',       '218',         12, 'Commerce', 'ELECTIVE',   'Entrepreneurship',                  'उद्यमिता',                            'Lightbulb',    '#D97706', 32),
  ('bseb-12-com-eco',       '219',         12, 'Commerce', 'ELECTIVE',   'Economics',                         'अर्थशास्त्र',                         'TrendingUp',   '#047857', 33),
  ('bseb-12-com-add-cs',    '221',         12, 'Commerce', 'ADDITIONAL', 'Computer Science (Additional)',     'कंप्यूटर साइंस (अतिरिक्त)',           'Cpu',          '#0F766E', 40),
  ('bseb-12-com-add-math',  '222',         12, 'Commerce', 'ADDITIONAL', 'Mathematics (Additional)',          'गणित (अतिरिक्त)',                     'Sigma',        '#1D4ED8', 41)
ON CONFLICT (id) DO UPDATE SET
  bseb_code    = EXCLUDED.bseb_code,
  class_num    = EXCLUDED.class_num,
  stream       = EXCLUDED.stream,
  category     = EXCLUDED.category,
  name_en      = EXCLUDED.name_en,
  name_hi      = EXCLUDED.name_hi,
  icon_name    = EXCLUDED.icon_name,
  accent_color = EXCLUDED.accent_color,
  sort_order   = EXCLUDED.sort_order;

-- -----------------------------------------------------------------------------
-- 2. OFFICIAL BSEB CHAPTERS CATALOG (Class 9, 10, 11, 12 Flagship Subjects)
-- -----------------------------------------------------------------------------

INSERT INTO public.chapters (
  id, subject_id, chapter_no, title_en, title_hi, summary_en, summary_hi, bseb_weightage_marks, estimated_mins, is_published
) VALUES
  -- ==================== CLASS 9 SCIENCE ====================
  ('bseb-9-sci-ch1',  'bseb-9-sci', 1,  'Matter in Our Surroundings',          'हमारे आस-पास के पदार्थ',           'States of matter, particles, evaporation, and latent heat.', 'पदार्थ की अवस्थाएँ, कणों के गुण, वाष्पीकरण और गुप्त ऊष्मा।', 7, 18, true),
  ('bseb-9-sci-ch2',  'bseb-9-sci', 2,  'Is Matter Around Us Pure?',           'क्या हमारे आस-पास के पदार्थ शुद्ध हैं?', 'Mixtures, solutions, suspensions, colloids, and separation methods.', 'मिश्रण, विलयन, निलंबन, कोलाइड तथा पृथक्करण विधियाँ।', 7, 16, true),
  ('bseb-9-sci-ch3',  'bseb-9-sci', 3,  'Atoms and Molecules',                 'परमाणु एवं अणु',                    'Laws of chemical combination, Dalton atomic theory, and mole concept.', 'रासायनिक संयोजन के नियम, डाल्टन का सिद्धांत और मोल अवधारणा।', 8, 20, true),
  ('bseb-9-sci-ch4',  'bseb-9-sci', 4,  'Structure of the Atom',               'परमाणु की संरचना',                  'Electrons, protons, neutrons, Bohr model, valency, and isotopes.', 'इलेक्ट्रॉन, प्रोटॉन, न्यूट्रॉन, बोर मॉडल, संयोजकता और समस्थानिक।', 7, 18, true),
  ('bseb-9-sci-ch5',  'bseb-9-sci', 5,  'The Fundamental Unit of Life',        'जीवन की मौलिक इकाई',                'Cell structure, plasma membrane, nucleus, and cell organelles.', 'कोशिका की संरचना, प्लाज्मा झिल्ली, केन्द्रक और कोशिकांग।', 7, 16, true),
  ('bseb-9-sci-ch6',  'bseb-9-sci', 6,  'Tissues',                             'ऊतक',                               'Plant and animal tissues with diagrams and functions.', 'पादप एवं जन्तु ऊतकों की संरचना और कार्य।', 6, 15, true),
  ('bseb-9-sci-ch7',  'bseb-9-sci', 7,  'Motion',                              'गति',                               'Distance vs displacement, velocity, acceleration, graphs, and three equations of motion.', 'दूरी और विस्थापन, वेग, त्वरण, ग्राफ तथा गति के तीनों समीकरण।', 9, 22, true),
  ('bseb-9-sci-ch8',  'bseb-9-sci', 8,  'Force and Laws of Motion',            'बल तथा गति के नियम',                'Newton three laws of motion, inertia, and conservation of momentum.', 'न्यूटन के गति के तीन नियम, जड़त्व और संवेग संरक्षण।', 8, 20, true),
  ('bseb-9-sci-ch9',  'bseb-9-sci', 9,  'Gravitation',                         'गुरुत्वाकर्षण',                     'Universal law of gravitation, free fall, mass, weight, and buoyancy.', 'सार्वत्रिक गुरुत्वाकर्षण नियम, मुक्त पतन, द्रव्यमान, भार और उत्प्लावकता।', 7, 18, true),
  ('bseb-9-sci-ch10', 'bseb-9-sci', 10, 'Work and Energy',                     'कार्य तथा ऊर्जा',                   'Scientific work, kinetic & potential energy, power, and energy conservation.', 'कार्य, गतिज व स्थितिज ऊर्जा, शक्ति और ऊर्जा संरक्षण।', 7, 16, true),
  ('bseb-9-sci-ch11', 'bseb-9-sci', 11, 'Sound',                               'ध्वनि',                             'Sound waves, frequency, echo, ultrasound, and human ear.', 'ध्वनि तरंगें, आवृत्ति, प्रतिध्वनि, पराध्वनि और मानव कर्ण।', 6, 15, true),
  ('bseb-9-sci-ch12', 'bseb-9-sci', 12, 'Improvement in Food Resources',       'खाद्य संसाधनों में सुधार',           'Crop production, irrigation, fertilizers, and animal husbandry.', 'फसल उत्पादन, सिंचाई, खाद-उर्वरक और पशुपालन।', 5, 14, true),

  -- ==================== CLASS 9 MATHEMATICS ====================
  ('bseb-9-math-ch1', 'bseb-9-math', 1, 'Number Systems',                      'संख्या पद्धति',                     'Rational, irrational numbers, laws of exponents for real numbers.', 'परिमेय, अपरिमेय संख्याएँ तथा वास्तविक संख्याओं के घातांक नियम।', 10, 18, true),
  ('bseb-9-math-ch2', 'bseb-9-math', 2, 'Polynomials',                         'बहुपद',                             'Degree, zeroes, remainder theorem, factorisation, and algebraic identities.', 'बहुपद की घात, शून्यक, गुणनखंड और बीजीय सर्वसमिकाएँ।', 12, 20, true),
  ('bseb-9-math-ch3', 'bseb-9-math', 3, 'Coordinate Geometry',                 'निर्देशांक ज्यामिति',               'Cartesian plane, quadrants, abscissa, and ordinate.', 'कार्तीय तल, चतुर्थांश, भुज और कोटि।', 6, 14, true),
  ('bseb-9-math-ch4', 'bseb-9-math', 4, 'Linear Equations in Two Variables',   'दो चरों वाले रैखिक समीकरण',         'Standard form ax + by + c = 0 and graph plotting.', 'मानक रूप ax + by + c = 0 और आलेख निर्माण।', 8, 16, true),
  ('bseb-9-math-ch6', 'bseb-9-math', 6, 'Lines and Angles',                    'रेखाएँ और कोण',                     'Parallel lines, transversal angles, and angle sum property of triangles.', 'समांतर रेखाएँ, तिर्यक रेखा के कोण और त्रिभुज कोण योग।', 8, 16, true),
  ('bseb-9-math-ch7', 'bseb-9-math', 7, 'Triangles',                           'त्रिभुज',                           'Congruence rules (SAS, ASA, SSS, RHS) and properties.', 'सर्वांगसमता के नियम (SAS, ASA, SSS, RHS) और प्रमेय।', 10, 18, true),
  ('bseb-9-math-ch12','bseb-9-math', 12,'Heron''s Formula',                    'हीरोन का सूत्र',                    'Area of triangles using semi-perimeter s and Heron formula.', 'अर्धपरिमाप s और हीरोन के सूत्र से त्रिभुज का क्षेत्रफल।', 8, 15, true),

  -- ==================== CLASS 10 SCIENCE (AUTHENTIC BSEB 16-CHAPTER SYLLABUS) ====================
  ('bseb-10-sci-ch1',  'bseb-10-sci', 1,  'Chemical Reactions and Equations',     'रासायनिक अभिक्रियाएँ एवं समीकरण',    'Balancing equations, combination, decomposition, displacement, and redox.', 'समीकरण संतुलन, संयोजन, वियोजन, विस्थापन और उपचयन-अपचयन।', 6, 18, true),
  ('bseb-10-sci-ch2',  'bseb-10-sci', 2,  'Acids, Bases and Salts',               'अम्ल, क्षारक एवं लवण',                'pH scale, indicators, bleaching powder, baking soda, and Plaster of Paris.', 'pH स्केल, सूचक, विरंजक चूर्ण, बेकिंग सोडा और प्लास्टर ऑफ पेरिस।', 7, 18, true),
  ('bseb-10-sci-ch3',  'bseb-10-sci', 3,  'Metals and Non-metals',                'धातु एवं अधातु',                      'Reactivity series, ionic compounds, extraction of metals, and corrosion.', 'सक्रियता श्रेणी, आयनिक यौगिक, धातु निष्कर्षण और संक्षारण।', 7, 18, true),
  ('bseb-10-sci-ch4',  'bseb-10-sci', 4,  'Carbon and its Compounds',             'कार्बन एवं उसके यौगिक',               'Covalent bonding, homologous series, IUPAC naming, ethanol, and soaps.', 'सहसंयोजी आबंध, समजातीय श्रेणी, नामकरण, एथेनॉल और साबुन।', 8, 22, true),
  ('bseb-10-sci-ch5',  'bseb-10-sci', 5,  'Periodic Classification of Elements',  'तत्वों का आवर्त वर्गीकरण',            'Dobereiner triads, Mendeleev and Modern Periodic Table trends.', 'डॉबेराइनर त्रिक, मेंडेलीफ और आधुनिक आवर्त सारणी की प्रवृत्तियाँ।', 5, 16, true),
  ('bseb-10-sci-ch6',  'bseb-10-sci', 6,  'Life Processes',                       'जैव प्रक्रम',                         'Nutrition, photosynthesis, respiration, human heart, and nephron excretion.', 'पोषण, प्रकाश संश्लेषण, श्वसन, मानव हृदय और नेफ्रॉन उत्सर्जन।', 9, 24, true),
  ('bseb-10-sci-ch7',  'bseb-10-sci', 7,  'Control and Coordination',             'नियंत्रण एवं समन्वय',                 'Neuron, reflex arc, human brain, plant and endocrine hormones.', 'तंत्रिका कोशिका, प्रतिवर्ती चाप, मानव मस्तिष्क और हार्मोन।', 6, 18, true),
  ('bseb-10-sci-ch8',  'bseb-10-sci', 8,  'How do Organisms Reproduce?',          'जीव जनन कैसे करते हैं?',              'Asexual modes, flower pollination, human reproduction, and health.', 'अलैंगिक जनन, पुष्प परागण, मानव प्रजनन और जनन स्वास्थ्य।', 6, 18, true),
  ('bseb-10-sci-ch9',  'bseb-10-sci', 9,  'Heredity and Evolution',               'आनुवंशिकता एवं जैव विकास',            'Mendel laws of inheritance, sex determination, and speciation.', 'मेंडल के आनुवंशिकता नियम, लिंग निर्धारण और जैव विकास।', 5, 16, true),
  ('bseb-10-sci-ch10', 'bseb-10-sci', 10, 'Light — Reflection and Refraction',    'प्रकाश — परावर्तन तथा अपवर्तन',       'Spherical mirrors, ray diagrams, mirror & lens formulas, magnification, and power of lens.', 'गोलीय दर्पण, किरण आरेख, दर्पण व लेंस सूत्र, आवर्धन और लेंस की क्षमता।', 12, 25, true),
  ('bseb-10-sci-ch11', 'bseb-10-sci', 11, 'The Human Eye and the Colourful World','मानव नेत्र तथा रंगबिरंगा संसार',      'Myopia, hypermetropia, prism dispersion, rainbow, and Tyndall scattering.', 'निकट व दूर दृष्टि दोष, प्रिज्म वर्ण विक्षेपण और प्रकाश का प्रकीर्णन।', 7, 18, true),
  ('bseb-10-sci-ch12', 'bseb-10-sci', 12, 'Electricity',                          'विद्युत',                             'Ohm law, series & parallel resistance, Joule heating, and electric power.', 'ओम का नियम, श्रेणी व पार्श्वक्रम प्रतिरोध, ऊष्मीय प्रभाव और विद्युत शक्ति।', 10, 22, true),
  ('bseb-10-sci-ch13', 'bseb-10-sci', 13, 'Magnetic Effects of Electric Current', 'विद्युत धारा के चुंबकीय प्रभाव',       'Right-hand thumb rule, Fleming rules, solenoid, and domestic electric circuits.', 'दक्षिण-हस्त अंगुष्ठ नियम, फ्लेमिंग नियम, परिनालिका और घरेलू परिपथ।', 7, 18, true),
  ('bseb-10-sci-ch14', 'bseb-10-sci', 14, 'Sources of Energy',                    'ऊर्जा के स्रोत',                      'Conventional vs renewable energy, biogas, solar, and nuclear energy.', 'पारंपरिक व नवीकरणीय ऊर्जा, बायोगैस, सौर और नाभिकीय ऊर्जा।', 4, 14, true),
  ('bseb-10-sci-ch15', 'bseb-10-sci', 15, 'Our Environment',                      'हमारा पर्यावरण',                      'Ecosystem, food chains, 10% energy law, and ozone layer depletion.', 'पारितंत्र, आहार श्रृंखला, 10% ऊर्जा नियम और ओजोन परत अपक्षय।', 4, 12, true),

  -- ==================== CLASS 10 MATHEMATICS (AUTHENTIC BSEB 15 CHAPTERS) ====================
  ('bseb-10-math-ch1',  'bseb-10-math', 1,  'Real Numbers',                       'वास्तविक संख्याएँ',                   'Euclid division lemma, HCF & LCM by prime factorisation, irrationality proofs.', 'यूक्लिड विभाजन प्रमेयिका, अभाज्य गुणनखंड द्वारा HCF/LCM और अपरिमेयता सिद्ध करना।', 10, 18, true),
  ('bseb-10-math-ch2',  'bseb-10-math', 2,  'Polynomials',                        'बहुपद',                              'Zeroes of quadratic polynomials and relationship with coefficients.', 'द्विघात बहुपद के शून्यक तथा गुणांकों के बीच संबंध।', 8, 16, true),
  ('bseb-10-math-ch3',  'bseb-10-math', 3,  'Pair of Linear Equations in Two Variables', 'दो चर वाले रैखिक समीकरण युग्म', 'Graphical, substitution, elimination, and cross-multiplication methods.', 'ग्राफीय, प्रतिस्थापन, विलोपन और वज्र-गुणन विधियाँ।', 10, 20, true),
  ('bseb-10-math-ch4',  'bseb-10-math', 4,  'Quadratic Equations',                'द्विघात समीकरण',                      'Standard form, factorisation, Shridharacharya formula, discriminant & nature of roots.', 'मानक रूप, गुणनखंड विधि, श्रीधराचार्य सूत्र, विविक्तकर और मूलों की प्रकृति।', 12, 24, true),
  ('bseb-10-math-ch5',  'bseb-10-math', 5,  'Arithmetic Progressions',            'समांतर श्रेढ़ियाँ',                   'nth term an and sum of n terms Sn with word problems.', 'nवाँ पद (an) और प्रथम n पदों का योगफल (Sn)।', 8, 18, true),
  ('bseb-10-math-ch6',  'bseb-10-math', 6,  'Triangles',                          'त्रिभुज',                            'Thales theorem (BPT), similarity criteria, and Pythagoras theorem.', 'थेल्स प्रमेय, समरूपता की कसौटियाँ और पाइथागोरस प्रमेय।', 10, 22, true),
  ('bseb-10-math-ch7',  'bseb-10-math', 7,  'Coordinate Geometry',                'निर्देशांक ज्यामिति',                 'Distance formula, section formula, midpoint, and area of triangle.', 'दूरी सूत्र, विभाजन सूत्र, मध्यबिंदु और त्रिभुज का क्षेत्रफल।', 10, 18, true),
  ('bseb-10-math-ch8',  'bseb-10-math', 8,  'Introduction to Trigonometry',       'त्रिकोणमिति का परिचय',                 'Trigonometric ratios, standard angles 0°-90°, and fundamental identities.', 'त्रिकोणमितीय अनुपात, मानक कोण सारणी और सर्वसमिकाएँ।', 14, 24, true),
  ('bseb-10-math-ch9',  'bseb-10-math', 9,  'Some Applications of Trigonometry',  'त्रिकोणमिति के कुछ अनुप्रयोग',         'Heights and distances using angles of elevation and depression.', 'उन्नयन और अवनमन कोण द्वारा ऊँचाई एवं दूरी के प्रश्न।', 8, 18, true),
  ('bseb-10-math-ch10', 'bseb-10-math', 10, 'Circles',                            'वृत्त',                              'Tangent to a circle and equal tangents from an external point.', 'वृत्त की स्पर्श रेखा और बाह्य बिंदु से खींची गई स्पर्श रेखाएँ।', 6, 15, true),
  ('bseb-10-math-ch12', 'bseb-10-math', 12, 'Areas Related to Circles',           'वृत्तों से संबंधित क्षेत्रफल',         'Perimeter, area of sector and segment of a circle.', 'त्रिज्यखंड और वृत्तखंड का क्षेत्रफल।', 6, 16, true),
  ('bseb-10-math-ch13', 'bseb-10-math', 13, 'Surface Areas and Volumes',          'पृष्ठीय क्षेत्रफल और आयतन',           'Combination of solids: cylinder, cone, sphere, hemisphere, and frustum.', 'ठोस आकृतियों के संयोजन का क्षेत्रफल और आयतन।', 8, 18, true),
  ('bseb-10-math-ch14', 'bseb-10-math', 14, 'Statistics',                         'सांख्यिकी',                          'Mean, median, and mode of grouped data.', 'वर्गीकृत आँकड़ों का माध्य, माध्यक और बहुलक।', 10, 18, true),
  ('bseb-10-math-ch15', 'bseb-10-math', 15, 'Probability',                        'प्रायिकता',                          'Classical probability of coins, dice, and playing cards.', 'सिक्का, पासा और ताश के पत्तों पर आधारित प्रायिकता।', 6, 14, true),

  -- ==================== CLASS 10 SOCIAL SCIENCE (BSEB HISTORY + CIVICS + GEO + ECO) ====================
  ('bseb-10-sst-ch1', 'bseb-10-sst', 1, 'Nationalism in India & Champaran Satyagraha', 'भारत में राष्ट्रवाद एवं चम्पारण सत्याग्रह', 'Champaran 1917 indigo movement in Bihar, Non-Cooperation, Dandi March, and Quit India.', 'बिहार का चम्पारण सत्याग्रह (1917), असहयोग, सविनय अवज्ञा और भारत छोड़ो आंदोलन।', 12, 22, true),
  ('bseb-10-sst-ch2', 'bseb-10-sst', 2, 'Rise of Nationalism in Europe',               'यूरोप में राष्ट्रवाद का उदय',               'French Revolution, Mazzini, Garibaldi, unification of Italy and Germany.', 'फ्रांसीसी क्रांति, मेजिनी, गैरीबाल्डी, इटली और जर्मनी का एकीकरण।', 8, 18, true),
  ('bseb-10-sst-ch3', 'bseb-10-sst', 3, 'Resources and Bihar Geography',               'संसाधन एवं बिहार का भूगोल',                 'Soil, water, agriculture, river valley projects, and Bihar minerals.', 'मृदा, जल, कृषि, नदी घाटी परियोजनाएँ और बिहार के संसाधन।', 10, 18, true),
  ('bseb-10-sst-ch4', 'bseb-10-sst', 4, 'Power Sharing & Panchayati Raj in Bihar',     'सत्ता में साझेदारी और बिहार में पंचायती राज', 'Federalism, Gram Panchayat, Nagar Nigam, and democratic decentralization.', 'संघवाद, ग्राम पंचायत, नगर निगम और लोकतांत्रिक विकेंद्रीकरण।', 8, 16, true),
  ('bseb-10-sst-ch5', 'bseb-10-sst', 5, 'Economy and Bihar Development',               'अर्थव्यवस्था और बिहार के विकास का इतिहास',  'Primary/Secondary/Tertiary sectors, GDP, banking, and self-help groups.', 'प्राथमिक-द्वितीयक-तृतीयक क्षेत्र, सकल घरेलू उत्पाद, बैंकिंग और स्वयं सहायता समूह।', 8, 16, true),

  -- ==================== CLASS 10 ENGLISH & HINDI MIL ====================
  ('bseb-10-eng-ch1',    'bseb-10-eng',    1, 'The Pace for Living',               'द पेस फॉर लिविंग (आधुनिक जीवन की गति)',    'R.C. Hutchinson essay on modern fast-paced life and human adaptability.', 'आधुनिक तेज़ रफ़्तार जीवन पर आर.सी. हचिंसन का निबंध।', 8, 14, true),
  ('bseb-10-eng-ch2',    'bseb-10-eng',    2, 'Me and the Ecology Bit',            'मैं और पारिस्थितिकी',                       'Environmental responsibility and everyday conservation habits.', 'पर्यावरण संरक्षण और दैनिक आदतों की जिम्मेदारी।', 7, 14, true),
  ('bseb-10-mil-hi-ch1', 'bseb-10-mil-hi', 1, 'Shram Vibhajan aur Jati Pratha',    'श्रम विभाजन और जाति प्रथा',                 'Dr. B.R. Ambedkar essay on social equality and ideal democratic society.', 'डॉ. भीमराव अंबेडकर का निबंध — सामाजिक समता और आदर्श लोकतांत्रिक समाज।', 10, 16, true),
  ('bseb-10-mil-hi-ch2', 'bseb-10-mil-hi', 2, 'Vish ke Daant',                     'विष के दाँत',                               'Nalin Vilochan Sharma story highlighting class contrast in Bihar society.', 'नलिन विलोचन शर्मा की कहानी — सामाजिक असमानता का यथार्थ चित्रण।', 8, 15, true),

  -- ==================== CLASS 11 SCIENCE (PHYSICS & MATH) ====================
  ('bseb-11-sci-phy-ch1',  'bseb-11-sci-phy',  1, 'Units and Measurements',        'मात्रक और मापन',                            'SI units, dimensional analysis, and significant figures.', 'SI मात्रक, विमीय विश्लेषण और सार्थक अंक।', 8, 18, true),
  ('bseb-11-sci-phy-ch2',  'bseb-11-sci-phy',  2, 'Motion in a Straight Line',     'सरल रेखा में गति',                          'Instantaneous velocity, calculus-based kinematic equations, and graphs.', 'तात्क्षणिक वेग, कलन द्वारा गति समीकरण और ग्राफ।', 10, 20, true),
  ('bseb-11-sci-phy-ch3',  'bseb-11-sci-phy',  3, 'Laws of Motion',                'गति के नियम',                               'Free body diagrams, friction, banking of roads, and impulse.', 'मुक्त पिंड आरेख, घर्षण, सड़कों का बंकन और आवेग।', 10, 20, true),
  ('bseb-11-sci-math-ch1', 'bseb-11-sci-math', 1, 'Sets',                          'समुच्चय',                                   'Roster & set-builder form, Venn diagrams, union, intersection, and De Morgan laws.', 'रोस्टर व समुच्चय निर्माण रूप, वेन आरेख और संक्रियाएँ।', 8, 16, true),
  ('bseb-11-sci-math-ch3', 'bseb-11-sci-math', 3, 'Trigonometric Functions',       'त्रिकोणमितीय फलन',                          'Radians, compound angle formulas, and trigonometric equations.', 'रेडियन माप, संयुक्त कोण सूत्र और त्रिकोणमितीय समीकरण।', 12, 22, true),

  -- ==================== CLASS 12 SCIENCE (PHYSICS, CHEMISTRY, MATH) ====================
  ('bseb-12-sci-phy-ch1',  'bseb-12-sci-phy',  1, 'Electric Charges and Fields',         'वैद्युत आवेश तथा क्षेत्र',            'Quantisation, Coulomb law, electric field lines, dipole, and Gauss theorem.', 'आवेश का क्वांटमीकरण, कूलॉम नियम, विद्युत क्षेत्र, द्विध्रुव और गॉस प्रमेय।', 12, 26, true),
  ('bseb-12-sci-phy-ch2',  'bseb-12-sci-phy',  2, 'Electrostatic Potential and Capacitance', 'स्थिरवैद्युत विभव तथा धारिता',    'Electric potential, equipotential surfaces, parallel plate capacitor & dielectrics.', 'विद्युत विभव, समविभव पृष्ठ, समांतर पट्टिका संधारित्र और परावैद्युत।', 10, 22, true),
  ('bseb-12-sci-phy-ch3',  'bseb-12-sci-phy',  3, 'Current Electricity',                 'विद्युत धारा',                        'Drift velocity, Kirchhoff laws, Wheatstone bridge, and potentiometer.', 'अपवाह वेग, किरचॉफ के नियम, व्हीटस्टोन सेतु और विभवमापी।', 10, 22, true),
  ('bseb-12-sci-phy-ch9',  'bseb-12-sci-phy',  9, 'Ray Optics and Optical Instruments',  'किरण प्रकाशिकी एवं प्रकाशिक यंत्र',    'Total internal reflection, lens maker formula, microscope, and telescope.', 'पूर्ण आंतरिक परावर्तन, लेंस निर्माता सूत्र, सूक्ष्मदर्शी और दूरदर्शी।', 14, 26, true),
  ('bseb-12-sci-phy-ch14', 'bseb-12-sci-phy',  14,'Semiconductor Electronics',           'अर्धचालक इलेक्ट्रॉनिकी',              'p-n junction diode, rectifiers, LED, and logic gates (AND, OR, NOT, NAND, NOR).', 'p-n संधि डायोड, दिष्टकारी और लॉजिक गेट।', 8, 20, true),
  ('bseb-12-sci-chem-ch1', 'bseb-12-sci-chem', 1, 'Solutions',                           'विलयन',                               'Molarity, molality, Raoult law, and colligative properties.', 'मोलरता, मोललता, राउल्ट का नियम और अणुसंख्य गुणधर्म।', 8, 20, true),
  ('bseb-12-sci-chem-ch2', 'bseb-12-sci-chem', 2, 'Electrochemistry',                    'वैद्युतरसायन',                         'Galvanic cell, Nernst equation, Kohlrausch law, and Faraday electrolysis.', 'गैल्वैनी सेल, नर्न्स्ट समीकरण, कोलराउश नियम और फैराडे नियम।', 9, 20, true),
  ('bseb-12-sci-math-ch3', 'bseb-12-sci-math', 3, 'Matrices',                            'आव्यूह',                              'Matrix algebra, transpose, symmetric & skew-symmetric matrices.', 'आव्यूह संक्रियाएँ, परिवर्त, सममित व विषम सममित आव्यूह।', 10, 20, true),
  ('bseb-12-sci-math-ch5', 'bseb-12-sci-math', 5, 'Continuity and Differentiability',    'सांतत्य तथा अवकलनीयता',               'Chain rule, logarithmic differentiation, and parametric derivatives.', 'शृंखला नियम, लघुगणकीय और प्राचलिक अवकलन।', 14, 24, true),
  ('bseb-12-sci-math-ch7', 'bseb-12-sci-math', 7, 'Integrals',                           'समाकलन',                              'Indefinite & definite integrals, substitution, parts, and properties.', 'अनिश्चित एवं निश्चित समाकलन और उनके गुणधर्म।', 16, 26, true),

  -- ==================== CLASS 12 ARTS (HISTORY) ====================
  ('bseb-12-arts-hist-ch1',  'bseb-12-arts-hist', 1,  'Bricks, Beads and Bones: The Harappan Civilisation', 'ईंटें, मनके तथा अस्थियाँ: हड़प्पा सभ्यता', 'Town planning of Mohenjodaro, drainage, craft production, trade, and decline.', 'मोहनजोदड़ो का नगर नियोजन, जल-निकास, शिल्प, व्यापार और पतन।', 12, 22, true),
  ('bseb-12-arts-hist-ch2',  'bseb-12-arts-hist', 2,  'Kings, Farmers and Towns (Magadha & Mauryas)',       'राजा, किसान और नगर (मगध एवं मौर्य साम्राज्य)', 'Rise of Magadha in Bihar, Pataliputra, Ashoka Dhamma, and Gupta inscriptions.', 'बिहार में मगध का उत्कर्ष, पाटलिपुत्र, अशोक का धम्म और अभिलेख।', 12, 22, true),
  ('bseb-12-arts-hist-ch11', 'bseb-12-arts-hist', 11, 'Rebels and the Raj: 1857 Revolt & Veer Kunwar Singh','विद्रोही और राज: 1857 का विद्रोह एवं वीर कुँवर सिंह', 'Causes of 1857 uprising, Bihar role of Veer Kunwar Singh of Jagdishpur.', '1857 की क्रांति के कारण और बिहार के जगदीशपुर से वीर कुँवर सिंह का नेतृत्व।', 10, 20, true),

  -- ==================== CLASS 12 COMMERCE (ACCOUNTANCY) ====================
  ('bseb-12-com-acc-ch1', 'bseb-12-com-acc', 1, 'Accounting for Partnership: Basic Concepts', 'साझेदारी लेखांकन: आधारभूत अवधारणाएँ', 'Partnership deed, P&L appropriation account, and capital accounts.', 'साझेदारी संलेख, लाभ-हानि विनियोजन खाता और पूँजी खाते।', 12, 20, true),
  ('bseb-12-com-acc-ch2', 'bseb-12-com-acc', 2, 'Reconstitution of Partnership: Admission',   'साझेदारी का पुनर्गठन: नए साझेदार का प्रवेश', 'Sacrificing ratio, goodwill valuation, and revaluation account.', 'त्याग अनुपात, ख्याति का मूल्यांकन और पुनर्मूल्यांकन खाता।', 12, 22, true)
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
