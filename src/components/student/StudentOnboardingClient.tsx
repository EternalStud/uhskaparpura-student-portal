"use client";

import React from "react";
import { useRouter } from "next/navigation";
import { BookOpenCheck } from "lucide-react";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge, Card } from "@/components/ui";
import { SubjectSelectionWizard } from "./SubjectSelectionWizard";

export function StudentOnboardingClient({
  studentName,
  classNum,
  schoolName,
}: {
  studentName: string;
  classNum: number;
  schoolName?: string | null;
}) {
  const router = useRouter();
  const { t } = useLanguage();

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <Card variant="indigo" padding="lg" className="space-y-2.5">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant="indigo" icon={<BookOpenCheck className="h-3.5 w-3.5" />}>
            {t(`कक्षा ${classNum} · विषय चयन`, `Class ${classNum} · Subject Setup`)}
          </Badge>
          {schoolName && <Badge variant="neutral">{schoolName}</Badge>}
        </div>

        <h1 className="text-2xl sm:text-3xl font-bold text-ink leading-tight">
          <BiText
            hi={`स्वागत है, ${studentName}! अपने विषय चुनें`}
            en={`Welcome, ${studentName}! Choose Your Subjects`}
          />
        </h1>
        <p className="text-sm sm:text-base text-ink-secondary leading-relaxed">
          {t(
            "केवल एक बार अपने बिहार बोर्ड के विषय चुन लीजिए — इसके बाद आपको अपने सभी अध्यायों के विज़ुअल नोट्स, अभ्यास प्रश्न और कक्षा सामग्री एक ही जगह मिलेंगी।",
            "Select your official Bihar Board subjects once — your dashboard will personalize all visual notes, practice drills, and class updates for you."
          )}
        </p>
      </Card>

      <SubjectSelectionWizard
        mode="onboarding"
        onComplete={() => {
          router.push("/student");
          router.refresh();
        }}
      />
    </div>
  );
}
