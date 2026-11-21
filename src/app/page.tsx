"use client";

import React from "react";
import Link from "next/link";
import {
  ArrowRight,
  BookOpen,
  Building2,
  CheckCircle2,
  ClipboardCheck,
  GraduationCap,
  Layers,
  MessageSquareText,
  ShieldCheck,
  Sparkles,
  UserCheck,
  Users,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { BrandMark } from "@/components/ui/BrandMark";
import { LanguageToggle, ThemeToggle } from "@/components/ui/LanguageToggle";
import { Badge } from "@/components/ui/Badge";
import { Card } from "@/components/ui/Card";
import { MathMarkdown } from "@/components/ui/MathMarkdown";

export default function PublicHomePage() {
  const { t } = useLanguage();

  const pillars = [
    {
      icon: <BookOpen className="h-5 w-5 text-indigo-ink" aria-hidden="true" />,
      badgeHi: "अध्याय नोट्स",
      badgeEn: "Chapter Notes",
      titleHi: "अध्याय-वार सचित्र और सरल नोट्स",
      titleEn: "Structured Visual Chapter Notes",
      descHi:
        "हर पाठ की शुरुआत 30-सेकंड के माइंडमैप, रोज़मर्रा के सरल उदाहरणों, स्पष्ट चित्रों, ज़रूरी सूत्रों और बोर्ड परीक्षा टिप्स के साथ — जिन्हें आप सुनकर भी पढ़ सकते हैं और प्रिंट भी कर सकते हैं।",
      descEn:
        "Every chapter opens with a 30-second bilingual mindmap, relatable everyday analogies, crisp labeled diagrams, key formulas, printable study sheets, and read-aloud support.",
      points: [
        { hi: "सरल हिंदी और अंग्रेजी दोनों में", en: "Hindi, English & Dual reading modes" },
        { hi: "बोलकर सुनाने की सुविधा (Read Aloud)", en: "Audio read-aloud for easier revision" },
      ],
    },
    {
      icon: (
        <ClipboardCheck className="h-5 w-5 text-emerald-ink" aria-hidden="true" />
      ),
      badgeHi: "अभ्यास एवं OMR",
      badgeEn: "Practice & OMR",
      titleHi: "बिहार बोर्ड पाठ्यक्रम आधारित संपूर्ण अभ्यास",
      titleEn: "One-Stop BSEB Syllabus Practice & OMR",
      descHi:
        "फ्लैशकार्ड, जोड़ी मिलान, चित्र नामांकन, स्तर-वार वस्तुनिष्ठ प्रश्न (आधार से टॉपर तक) और 2-अंक व 5-अंक के मॉडल उत्तर — सब एक ही जगह।",
      descEn:
        "Flashcards, match-the-pairs, diagram labeling, tiered objective MCQs from Foundation to Board Topper, and step-by-step 2-mark and 5-mark model answers.",
      points: [
        { hi: "कक्षा 9–10 और 11–12 के सभी संकाय", en: "Class 9–10 and 11–12 Arts, Science & Commerce" },
        { hi: "कमज़ोर विषयों का स्वतः पुनरावृत्ति अभ्यास", en: "Smart revision queue for missed questions" },
      ],
    },
    {
      icon: (
        <MessageSquareText
          className="h-5 w-5 text-amber-ink"
          aria-hidden="true"
        />
      ),
      badgeHi: "शंका समाधान",
      badgeEn: "Doubt Board",
      titleHi: "खुला छात्र–शिक्षक शंका समाधान एवं कक्षा सामग्री",
      titleEn: "Open Student–Teacher Doubt Resolution & Classroom Resources",
      descHi:
        "किसी भी पाठ में संदेह होने पर अपने विषय बोर्ड पर प्रश्न पूछें। आपके विद्यालय के शिक्षक वहीं स्पष्ट उत्तर देंगे और कक्षा के नोट्स, वर्कशीट व वीडियो पाठ साझा करेंगे।",
      descEn:
        "Post subject questions on your school's transparent class doubt board so verified teachers answer openly, alongside curated class notes, PDFs, and recorded lessons.",
      points: [
        { hi: "पूरी तरह खुला और सुरक्षित विद्यालय बोर्ड", en: "100% open, moderated school study boards" },
        { hi: "एक छात्र का उत्तर पूरी कक्षा के काम आए", en: "Every teacher answer helps the whole class" },
      ],
    },
    {
      icon: (
        <GraduationCap className="h-5 w-5 text-indigo-ink" aria-hidden="true" />
      ),
      badgeHi: "शिक्षक एवं परीक्षा",
      badgeEn: "Educators & Exams",
      titleHi: "शिक्षक पाठ योजना एवं कक्षा परीक्षा प्रणाली",
      titleEn: "Educator Lesson Plans & Classroom Assessments",
      descHi:
        "शिक्षकों के लिए कालांश-वार पाठ योजना, श्यामपट्ट के मुख्य बिंदु, लाइव पिन क्विज़, निर्धारित अध्याय परीक्षा और तुरंत तैयार होने वाला परीक्षा परिणाम पत्रक।",
      descEn:
        "Period-wise teacher lesson plans, blackboard talking points, live PIN classroom exams, scheduled chapter tests, and instant class result sheets.",
      points: [
        { hi: "टॉपिक, अध्याय या पूर्ण विषय परीक्षा", en: "Topic, chapter, or full-subject assessments" },
        { hi: "रियल-टाइम कक्षा परीक्षा मॉनिटर", en: "Live classroom progress monitor for teachers" },
      ],
    },
  ];

  return (
    <div className="min-h-dvh flex flex-col bg-canvas text-ink">
      {/* Top Navigation Bar matching design/studentbook.pdf Page 1 */}
      <header className="sticky top-0 z-30 border-b border-hairline bg-surface/95 backdrop-blur-sm">
        <div className="mx-auto flex min-h-16 max-w-7xl flex-wrap items-center justify-between gap-3 px-4 py-2.5 sm:px-6">
          <Link href="/" className="min-w-0 focus-visible:rounded-lg">
            <BrandMark size="md" showTagline />
          </Link>

          <div className="flex flex-wrap items-center gap-2 sm:gap-2.5">
            <LanguageToggle compact className="sm:hidden" />
            <LanguageToggle className="hidden sm:inline-flex" />
            <ThemeToggle />

            <div className="hidden md:flex items-center gap-2 pl-1 border-l border-hairline">
              <Link
                href="/login/teacher"
                className="inline-flex min-h-[40px] items-center justify-center gap-1.5 rounded-lg border border-hairline bg-surface px-3.5 text-sm font-semibold text-ink hover:bg-surface-subtle hover:border-hairline-strong transition-colors"
              >
                <UserCheck className="h-4 w-4 text-indigo-ink" aria-hidden="true" />
                <span>{t("शिक्षक लॉगिन", "Teacher Login")}</span>
              </Link>
              <Link
                href="/login/school"
                className="inline-flex min-h-[40px] items-center justify-center gap-1.5 rounded-lg border border-hairline bg-surface px-3.5 text-sm font-semibold text-ink hover:bg-surface-subtle hover:border-hairline-strong transition-colors"
              >
                <Building2 className="h-4 w-4 text-amber-ink" aria-hidden="true" />
                <span>{t("विद्यालय लॉगिन", "School Login")}</span>
              </Link>
              <Link
                href="/login/student"
                className="inline-flex min-h-[40px] items-center justify-center gap-1.5 rounded-lg bg-indigo-academic px-4 text-sm font-semibold text-white shadow-paper hover:bg-indigo-academic-hover transition-colors"
              >
                <GraduationCap className="h-4 w-4" aria-hidden="true" />
                <span>{t("छात्र लॉगिन", "Student Login")}</span>
              </Link>
            </div>
          </div>
        </div>
      </header>

      <main className="flex-1">
        {/* Hero Section */}
        <section className="border-b border-hairline bg-gradient-to-b from-surface to-canvas">
          <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 sm:py-16 lg:py-20">
            <div className="grid grid-cols-1 gap-10 lg:grid-cols-12 lg:items-center">
              {/* Editorial Copy */}
              <div className="lg:col-span-7 space-y-6">
                <div className="flex flex-wrap items-center gap-2">
                  <Badge
                    variant="indigo"
                    icon={<Sparkles className="h-3.5 w-3.5" aria-hidden="true" />}
                  >
                    {t(
                      "बिहार बोर्ड (BSEB) · कक्षा 9, 10, 11 एवं 12",
                      "Bihar Board (BSEB) · Class 9, 10, 11 & 12"
                    )}
                  </Badge>
                  <Badge variant="amber">
                    {t("हिंदी और अंग्रेजी दोनों माध्यम", "Hindi-First & Bilingual")}
                  </Badge>
                </div>

                <h1 className="text-3xl sm:text-4xl lg:text-[2.75rem] font-extrabold tracking-tight text-ink leading-[1.22]">
                  {t(
                    "बिहार के विद्यार्थियों के लिए सरल, सचित्र और गहन अध्ययन का विश्वसनीय मंच",
                    "Calm, visual, and in-depth board preparation built for Bihar's Class 9–12 students"
                  )}
                </h1>

                <p className="max-w-2xl text-base sm:text-lg text-ink-secondary leading-relaxed">
                  {t(
                    "चाहे आप कक्षा 9–10 की बुनियाद मज़बूत कर रहे हों या कक्षा 11–12 की बोर्ड परीक्षा की तैयारी — यहाँ हर अध्याय के आसान सचित्र नोट्स, नियमित अभ्यास, विद्यालय के शिक्षकों से शंका समाधान और कक्षा परीक्षाएं एक शांत, व्यवस्थित स्थान पर मिलती हैं।",
                    "Whether building fundamentals in Class 9–10 or preparing for Class 11–12 board exams, students and teachers get clear visual chapter notes, guided practice, open school doubt boards, and classroom exams in one distraction-free academic space."
                  )}
                </p>

                {/* Primary Role Entry Actions (Prominent on Mobile & Desktop) */}
                <div className="flex flex-col sm:flex-row flex-wrap gap-3 pt-1">
                  <Link
                    href="/login/student"
                    className="inline-flex min-h-[48px] items-center justify-center gap-2 rounded-paper bg-indigo-academic px-6 text-base font-semibold text-white shadow-paper hover:bg-indigo-academic-hover transition-colors"
                  >
                    <GraduationCap className="h-5 w-5" aria-hidden="true" />
                    <span>{t("छात्र लॉगिन करें", "Student Login")}</span>
                    <ArrowRight className="h-4 w-4" aria-hidden="true" />
                  </Link>

                  <Link
                    href="/login/teacher"
                    className="inline-flex min-h-[48px] items-center justify-center gap-2 rounded-paper border border-hairline-strong bg-surface px-5 text-sm sm:text-base font-semibold text-ink shadow-paper hover:bg-surface-subtle transition-colors"
                  >
                    <UserCheck
                      className="h-4 w-4 text-indigo-ink"
                      aria-hidden="true"
                    />
                    <span>{t("शिक्षक लॉगिन", "Teacher Login")}</span>
                  </Link>

                  <Link
                    href="/login/school"
                    className="inline-flex min-h-[48px] items-center justify-center gap-2 rounded-paper border border-hairline-strong bg-surface px-5 text-sm sm:text-base font-semibold text-ink shadow-paper hover:bg-surface-subtle transition-colors"
                  >
                    <Building2
                      className="h-4 w-4 text-amber-ink"
                      aria-hidden="true"
                    />
                    <span>{t("विद्यालय लॉगिन", "School Login")}</span>
                  </Link>
                </div>

                <div className="flex flex-wrap items-center gap-x-6 gap-y-2 pt-2 text-xs sm:text-sm text-ink-muted">
                  <span className="inline-flex items-center gap-1.5">
                    <CheckCircle2
                      className="h-4 w-4 text-emerald-ink"
                      aria-hidden="true"
                    />
                    {t("बजट मोबाइल और स्कूल कंप्यूटर के अनुकूल", "Fast on budget phones & school PCs")}
                  </span>
                  <span className="inline-flex items-center gap-1.5">
                    <ShieldCheck
                      className="h-4 w-4 text-indigo-ink"
                      aria-hidden="true"
                    />
                    {t("विज्ञापन-मुक्त एवं सुरक्षित शैक्षणिक वातावरण", "Distraction-free, safe school environment")}
                  </span>
                </div>
              </div>

              {/* Editorial Study Card Preview (Paper-First Academic Craft) */}
              <div className="lg:col-span-5">
                <Card
                  variant="default"
                  padding="none"
                  className="overflow-hidden border-hairline-strong"
                >
                  <div className="flex items-center justify-between gap-3 border-b border-hairline bg-surface-subtle px-5 py-3.5">
                    <div className="flex items-center gap-2">
                      <BookOpen
                        className="h-4 w-4 text-indigo-ink"
                        aria-hidden="true"
                      />
                      <span className="text-xs font-bold uppercase tracking-wider text-ink-secondary">
                        {t("कक्षा 10 · विज्ञान · अध्याय 10", "Class 10 · Science · Chapter 10")}
                      </span>
                    </div>
                    <Badge variant="emerald">
                      {t("बोर्ड अंक: 8", "Board Marks: 8")}
                    </Badge>
                  </div>

                  <div className="p-5 sm:p-6 space-y-4">
                    <div>
                      <h2 className="text-lg font-bold text-ink leading-snug">
                        {t(
                          "प्रकाश — परावर्तन तथा अपवर्तन",
                          "Light — Reflection and Refraction"
                        )}
                      </h2>
                      <p className="mt-1 text-xs text-ink-secondary leading-relaxed">
                        {t(
                          "सरल उदाहरण: चम्मच की भीतरी चमकदार सतह अवतल दर्पण की तरह काम करती है।",
                          "Everyday Analogy: The shiny inner curve of a steel spoon behaves just like a concave mirror."
                        )}
                      </p>
                    </div>

                    <div className="rounded-lg border border-hairline bg-surface-subtle/70 p-3.5">
                      <p className="text-[11px] font-bold uppercase tracking-wider text-indigo-ink mb-1">
                        {t("मुख्य दर्पण सूत्र (Mirror Formula)", "Key Mirror Formula")}
                      </p>
                      <MathMarkdown
                        content="$$\frac{1}{f} = \frac{1}{v} + \frac{1}{u}$$"
                        className="text-sm"
                      />
                    </div>

                    <div className="grid grid-cols-3 gap-2 text-center">
                      <div className="rounded-lg border border-hairline bg-surface p-2.5">
                        <p className="text-xs font-bold text-ink">30s</p>
                        <p className="text-[11px] text-ink-muted">
                          {t("माइंडमैप", "Mindmap")}
                        </p>
                      </div>
                      <div className="rounded-lg border border-hairline bg-surface p-2.5">
                        <p className="text-xs font-bold text-emerald-ink">
                          {t("सचित्र", "Visual")}
                        </p>
                        <p className="text-[11px] text-ink-muted">
                          {t("किरण आरेख", "Ray Diagrams")}
                        </p>
                      </div>
                      <div className="rounded-lg border border-hairline bg-surface p-2.5">
                        <p className="text-xs font-bold text-amber-ink">
                          2M · 5M
                        </p>
                        <p className="text-[11px] text-ink-muted">
                          {t("मॉडल उत्तर", "Model Answers")}
                        </p>
                      </div>
                    </div>
                  </div>
                </Card>
              </div>
            </div>
          </div>
        </section>

        {/* About Section (Matching design/studentbook.pdf Page 1) */}
        <section
          id="about"
          aria-labelledby="about-heading"
          className="mx-auto max-w-7xl px-4 py-14 sm:px-6 sm:py-16"
        >
          <div className="grid grid-cols-1 gap-8 lg:grid-cols-12 lg:items-start">
            <div className="lg:col-span-5 space-y-3">
              <Badge variant="neutral">{t("हमारे बारे में", "About")}</Badge>
              <h2
                id="about-heading"
                className="text-2xl sm:text-3xl font-extrabold tracking-tight text-ink leading-tight"
              >
                {t(
                  "हर सरकारी विद्यालय के छात्र तक उत्कृष्ट शिक्षा की पहुँच",
                  "Bringing textbook-grade clarity to every Bihar government school classroom"
                )}
              </h2>
              <p className="text-sm sm:text-base text-ink-secondary leading-relaxed">
                {t(
                  "\"बिहार के विद्यार्थी (9–12)\" की शुरुआत इस संकल्प के साथ हुई है कि ग्रामीण और शहरी सरकारी विद्यालयों के विद्यार्थियों को भी वही स्पष्ट, सचित्र और गुणवत्तापूर्ण नोट्स, अभ्यास प्रश्न और शिक्षक मार्गदर्शन मिले जिसकी वे हकदार हैं।",
                  "Students of Bihar (9–12) is designed from the ground up for Bihar Board learners who need clear explanations instead of rote memorization—connecting each school's own students, subject teachers, and administration in one cohesive academic portal."
                )}
              </p>
            </div>

            <div className="lg:col-span-7 grid grid-cols-1 sm:grid-cols-3 gap-4">
              <Card variant="subtle" padding="md">
                <Layers
                  className="h-5 w-5 text-indigo-ink mb-3"
                  aria-hidden="true"
                />
                <h3 className="text-sm font-bold text-ink">
                  {t("सरल से गहन ज्ञान", "Simple-to-Deep Mastery")}
                </h3>
                <p className="mt-1.5 text-xs sm:text-sm text-ink-secondary leading-relaxed">
                  {t(
                    "बुनियादी समझ से शुरू कर धीरे-धीरे बोर्ड स्तर के कठिन प्रश्नों तक सहज मार्गदर्शन।",
                    "Starts with everyday intuition and visuals, then builds confidently to board-level mastery."
                  )}
                </p>
              </Card>

              <Card variant="subtle" padding="md">
                <Users
                  className="h-5 w-5 text-emerald-ink mb-3"
                  aria-hidden="true"
                />
                <h3 className="text-sm font-bold text-ink">
                  {t("अपने विद्यालय से जुड़ाव", "Your Own School Space")}
                </h3>
                <p className="mt-1.5 text-xs sm:text-sm text-ink-secondary leading-relaxed">
                  {t(
                    "छात्र सीधे अपने विद्यालय के शिक्षकों के नोट्स, शंका समाधान और कक्षा परीक्षाओं से जुड़ते हैं।",
                    "Each school maintains its own classes, subject teachers, class notes, and live exams."
                  )}
                </p>
              </Card>

              <Card variant="subtle" padding="md">
                <ShieldCheck
                  className="h-5 w-5 text-amber-ink mb-3"
                  aria-hidden="true"
                />
                <h3 className="text-sm font-bold text-ink">
                  {t("पारदर्शी एवं सुरक्षित", "Transparent & Safe")}
                </h3>
                <p className="mt-1.5 text-xs sm:text-sm text-ink-secondary leading-relaxed">
                  {t(
                    "कोई निजी चैट या अनावश्यक शोर नहीं — केवल पढ़ाई, खुला शंका बोर्ड और नियमित मूल्यांकन।",
                    "No private messaging or social distractions—only focused study and open classroom Q&A."
                  )}
                </p>
              </Card>
            </div>
          </div>
        </section>

        {/* What We Bring Section (Matching design/studentbook.pdf Page 1 & Page 4) */}
        <section
          id="what-we-bring"
          aria-labelledby="what-we-bring-heading"
          className="border-t border-hairline bg-surface/60"
        >
          <div className="mx-auto max-w-7xl px-4 py-14 sm:px-6 sm:py-18">
            <div className="max-w-2xl space-y-2.5 mb-10">
              <Badge variant="indigo">
                {t("हम क्या लेकर आए हैं", "What We Bring")}
              </Badge>
              <h2
                id="what-we-bring-heading"
                className="text-2xl sm:text-3xl font-extrabold tracking-tight text-ink"
              >
                {t(
                  "अध्ययन, अभ्यास, शंका समाधान और परीक्षा — एक ही मंच पर",
                  "Study notes, guided practice, open doubts, and classroom exams in one place"
                )}
              </h2>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              {pillars.map((pillar) => (
                <Card
                  key={pillar.titleEn}
                  variant="interactive"
                  padding="lg"
                  className="flex flex-col justify-between"
                >
                  <div>
                    <div className="flex items-center justify-between gap-3 mb-4">
                      <div className="inline-flex h-11 w-11 items-center justify-center rounded-paper bg-surface-subtle border border-hairline">
                        {pillar.icon}
                      </div>
                      <Badge variant="neutral">
                        {t(pillar.badgeHi, pillar.badgeEn)}
                      </Badge>
                    </div>

                    <h3 className="text-lg font-bold text-ink leading-snug">
                      {t(pillar.titleHi, pillar.titleEn)}
                    </h3>
                    <p className="mt-2 text-sm text-ink-secondary leading-relaxed">
                      {t(pillar.descHi, pillar.descEn)}
                    </p>
                  </div>

                  <ul className="mt-5 pt-4 border-t border-hairline space-y-2">
                    {pillar.points.map((pt) => (
                      <li
                        key={pt.en}
                        className="flex items-center gap-2 text-xs sm:text-sm font-medium text-ink"
                      >
                        <CheckCircle2
                          className="h-4 w-4 text-emerald-ink shrink-0"
                          aria-hidden="true"
                        />
                        <span>{t(pt.hi, pt.en)}</span>
                      </li>
                    ))}
                  </ul>
                </Card>
              ))}
            </div>

            {/* Bottom Callout Strip */}
            <Card
              variant="warm"
              padding="lg"
              className="mt-10 flex flex-col md:flex-row md:items-center md:justify-between gap-5"
            >
              <div className="space-y-1 max-w-2xl">
                <h3 className="text-lg font-bold text-ink">
                  {t(
                    "तैयार हैं आज का अध्याय शुरू करने के लिए?",
                    "Ready to start today's chapter?"
                  )}
                </h3>
                <p className="text-sm text-ink-secondary">
                  {t(
                    "अपने छात्र कोड या रोल नंबर और जन्म तिथि से तुरंत लॉगिन करें।",
                    "Sign in immediately using your Student Code, or simply your School, Class, Roll Number, and Date of Birth."
                  )}
                </p>
              </div>

              <div className="flex flex-wrap items-center gap-2.5 shrink-0">
                <Link
                  href="/login/student"
                  className="inline-flex min-h-[44px] items-center justify-center gap-2 rounded-lg bg-indigo-academic px-5 text-sm font-semibold text-white shadow-paper hover:bg-indigo-academic-hover transition-colors"
                >
                  <span>{t("छात्र लॉगिन", "Student Login")}</span>
                  <ArrowRight className="h-4 w-4" aria-hidden="true" />
                </Link>
                <Link
                  href="/login/teacher"
                  className="inline-flex min-h-[44px] items-center justify-center gap-2 rounded-lg border border-hairline-strong bg-surface px-4 text-sm font-semibold text-ink hover:bg-surface-subtle transition-colors"
                >
                  <span>{t("शिक्षक लॉगिन", "Teacher Login")}</span>
                </Link>
              </div>
            </Card>
          </div>
        </section>
      </main>

      {/* Clean Academic Footer */}
      <footer className="border-t border-hairline bg-surface">
        <div className="mx-auto flex max-w-7xl flex-col sm:flex-row items-center justify-between gap-4 px-4 py-6 sm:px-6 text-xs text-ink-muted">
          <div className="flex flex-col sm:flex-row sm:items-center gap-1 sm:gap-3 text-center sm:text-left">
            <span className="font-semibold text-ink">
              {t("बिहार के विद्यार्थी (कक्षा 9–12)", "Students of Bihar (Class 9–12)")}
            </span>
            <span className="hidden sm:inline" aria-hidden="true">
              ·
            </span>
            <span>
              {t(
                "उच्च माध्यमिक विद्यालय, कपरपुरा (काँटी, मुजफ्फरपुर) एवं बिहार के सभी संबद्ध विद्यालयों के लिए",
                "Launched with U.H.S. Kaparpura (Kanti, Muzaffarpur) for Bihar Board schools"
              )}
            </span>
          </div>

          <div className="flex items-center gap-4 font-medium">
            <Link href="/login/student" className="hover:text-ink transition-colors">
              {t("छात्र लॉगिन", "Student")}
            </Link>
            <Link href="/login/teacher" className="hover:text-ink transition-colors">
              {t("शिक्षक लॉगिन", "Teacher")}
            </Link>
            <Link href="/login/school" className="hover:text-ink transition-colors">
              {t("विद्यालय लॉगिन", "School")}
            </Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
