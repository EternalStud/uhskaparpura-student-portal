"use client";

import React, { useState } from "react";
import { ChevronDown, ChevronRight, Clock, Network } from "lucide-react";
import type { MindmapSpec } from "@/types/database";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { Badge } from "@/components/ui/Badge";
import { MathMarkdown } from "@/components/ui/MathMarkdown";
import { cn } from "@/components/ui/cn";

export interface MindmapViewerProps {
  spec: MindmapSpec;
  className?: string;
}

const DEFAULT_BRANCH_COLORS = ["#1E3A8A", "#059669", "#D97706", "#7C3AED"];

export function MindmapViewer({ spec, className }: MindmapViewerProps) {
  const { t } = useLanguage();
  const [collapsedIds, setCollapsedIds] = useState<Record<string, boolean>>({});

  const toggleBranch = (id: string) => {
    setCollapsedIds((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <section
      aria-label={t(spec.title_hi, spec.title_en)}
      className={cn(
        "rounded-paper border border-indigo-academic/25 bg-surface shadow-paper p-4 sm:p-6",
        className
      )}
    >
      {/* Header */}
      <div className="flex flex-wrap items-center justify-between gap-2 pb-4 border-b border-hairline">
        <div className="flex items-center gap-2.5 min-w-0">
          <span className="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-indigo-soft text-indigo-ink shrink-0">
            <Network className="h-5 w-5" aria-hidden="true" />
          </span>
          <div className="min-w-0">
            <h2 className="text-base sm:text-lg font-bold text-ink leading-snug">
              <BiText hi={spec.title_hi} en={spec.title_en} />
            </h2>
          </div>
        </div>
        <Badge variant="amber" icon={<Clock className="h-3.5 w-3.5" />}>
          {t(
            `${spec.read_time_seconds} सेकंड रिवीजन`,
            `${spec.read_time_seconds}s Quick Map`
          )}
        </Badge>
      </div>

      {/* Central Node */}
      <div className="my-5 flex justify-center">
        <div className="rounded-paper bg-indigo-academic text-white px-5 py-3.5 text-center shadow-paper max-w-xl w-full sm:w-auto">
          <div className="text-base sm:text-lg font-bold leading-snug">
            <BiText
              hi={spec.central_node.label_hi}
              en={spec.central_node.label_en}
              enClassName="text-indigo-100 text-xs sm:text-sm font-medium mt-0.5"
            />
          </div>
          {(spec.central_node.subtitle_hi || spec.central_node.subtitle_en) && (
            <div className="mt-1 text-xs sm:text-sm text-indigo-100/95">
              <BiText
                hi={spec.central_node.subtitle_hi ?? ""}
                en={spec.central_node.subtitle_en ?? ""}
                enClassName="text-indigo-200 text-xs mt-0.5"
              />
            </div>
          )}
        </div>
      </div>

      {/* Branch Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {spec.branches.map((branch, idx) => {
          const accent = branch.color || DEFAULT_BRANCH_COLORS[idx % DEFAULT_BRANCH_COLORS.length];
          const isCollapsed = Boolean(collapsedIds[branch.id]);

          return (
            <div
              key={branch.id}
              className="rounded-paper border border-hairline bg-canvas/60 overflow-hidden flex flex-col"
              style={{ borderTopWidth: "3px", borderTopColor: accent }}
            >
              <button
                type="button"
                onClick={() => toggleBranch(branch.id)}
                className="w-full flex items-center justify-between gap-2 px-4 py-3 text-left hover:bg-surface-subtle/70 transition-colors"
                aria-expanded={!isCollapsed}
              >
                <div className="font-bold text-sm sm:text-[15px] text-ink leading-snug">
                  <BiText hi={branch.label_hi} en={branch.label_en} />
                </div>
                {isCollapsed ? (
                  <ChevronRight className="h-4 w-4 text-ink-muted shrink-0" />
                ) : (
                  <ChevronDown className="h-4 w-4 text-ink-muted shrink-0" />
                )}
              </button>

              {!isCollapsed && (
                <div className="px-4 pb-4 space-y-2.5">
                  {branch.formula_latex && (
                    <div className="rounded-lg bg-surface border border-hairline px-3 py-2 overflow-x-auto text-sm text-center">
                      <MathMarkdown content={`$$${branch.formula_latex}$$`} />
                    </div>
                  )}

                  {branch.detail_hi || branch.detail_en ? (
                    <p className="text-xs sm:text-sm text-ink-secondary leading-relaxed">
                      <BiText hi={branch.detail_hi ?? ""} en={branch.detail_en ?? ""} />
                    </p>
                  ) : null}

                  {branch.children && branch.children.length > 0 && (
                    <ul className="space-y-2">
                      {branch.children.map((child) => (
                        <li
                          key={child.id}
                          className="rounded-lg bg-surface border border-hairline px-3 py-2"
                        >
                          <div className="text-xs sm:text-sm font-semibold text-ink leading-snug">
                            <BiText hi={child.label_hi} en={child.label_en} />
                          </div>
                          {child.formula_latex && (
                            <div className="mt-1.5 overflow-x-auto text-xs">
                              <MathMarkdown content={`$${child.formula_latex}$`} inline />
                            </div>
                          )}
                          {(child.detail_hi || child.detail_en) && (
                            <div className="mt-1 text-xs text-ink-secondary leading-relaxed">
                              <BiText hi={child.detail_hi ?? ""} en={child.detail_en ?? ""} />
                            </div>
                          )}
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </section>
  );
}
