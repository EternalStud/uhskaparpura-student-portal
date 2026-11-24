"use client";

import React from "react";
import {
  Atom,
  BookOpen,
  BookText,
  Brain,
  Briefcase,
  Calculator,
  Compass,
  Cpu,
  Dna,
  FileSpreadsheet,
  FlaskConical,
  Globe,
  Home,
  Landmark,
  Laptop,
  Lightbulb,
  Music,
  Scale,
  ScrollText,
  Sigma,
  Sparkles,
  Sprout,
  TrendingUp,
  Users,
} from "lucide-react";

const ICON_MAP: Record<string, React.ComponentType<{ className?: string }>> = {
  Atom,
  BookOpen,
  BookText,
  Brain,
  Briefcase,
  Calculator,
  Compass,
  Cpu,
  Dna,
  FileSpreadsheet,
  FlaskConical,
  Globe,
  Home,
  Landmark,
  Laptop,
  Lightbulb,
  Music,
  Scale,
  ScrollText,
  Sigma,
  Sparkles,
  Sprout,
  TrendingUp,
  Users,
};

export function SubjectIcon({
  name,
  className = "h-5 w-5",
}: {
  name?: string | null;
  className?: string;
}) {
  const Comp = (name && ICON_MAP[name]) || BookOpen;
  return <Comp className={className} aria-hidden="true" />;
}
