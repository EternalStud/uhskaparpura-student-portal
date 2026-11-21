"use client";

import React, { useId } from "react";
import { ArrowDown, ArrowRight, CheckCircle2, Table2, GitBranch, Clock, Sigma, Sparkles } from "lucide-react";
import type {
  BilingualDiagramSpec,
  SafeSvgElement,
  SvgDiagramSpec,
} from "@/types/database";
import { BiText, useLanguage } from "@/components/providers/LanguageProvider";
import { MathMarkdown } from "@/components/ui/MathMarkdown";
import { cn } from "@/components/ui/cn";

export interface InteractiveDiagramHotspot {
  id: string;
  x: number;
  y: number;
  label_code: string;
  assignedLabel?: string;
  state?: "idle" | "active" | "correct" | "wrong";
}

export interface BilingualDiagramRendererProps {
  spec: BilingualDiagramSpec;
  className?: string;
  hotspots?: InteractiveDiagramHotspot[];
  onHotspotClick?: (hotspotId: string) => void;
  compact?: boolean;
}

const SAFE_COLOR_RE = /^(?:#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})|none|transparent|currentColor|black|white|indigo|amber|emerald|slate|red|blue|green|orange|purple|teal)$/i;
const SAFE_PATH_RE = /^[MmLlHhVvCcSsQqTtAaZz0-9.,\s+-]{1,4000}$/;
const SAFE_POINTS_RE = /^[\d.,\s+-]{1,2000}$/;

function safeColor(color: string | undefined, fallback: string): string {
  if (!color) return fallback;
  const trimmed = color.trim();
  return SAFE_COLOR_RE.test(trimmed) ? trimmed : fallback;
}

function SvgVisual({
  spec,
  hotspots,
  onHotspotClick,
}: {
  spec: SvgDiagramSpec;
  hotspots?: InteractiveDiagramHotspot[];
  onHotspotClick?: (id: string) => void;
}) {
  const { lang } = useLanguage();
  const rawId = useId().replace(/[^a-zA-Z0-9_-]/g, "");
  const markerPrefix = `sob-arrow-${rawId}`;

  // Collect unique arrow stroke colors so each arrowhead inherits the exact arrow stroke
  const arrowColors = Array.from(
    new Set(
      spec.elements
        .filter((el): el is Extract<SafeSvgElement, { kind: "arrow" }> => el.kind === "arrow")
        .map((el) => safeColor(el.stroke, "#1E3A8A"))
    )
  );

  const markerIdForColor = (color: string) =>
    `${markerPrefix}-${color.replace(/[^a-zA-Z0-9]/g, "")}`;

  return (
    <div className="w-full overflow-x-auto rounded-lg bg-[#FDFCFB] dark:bg-slate-900/70 border border-hairline p-3 sm:p-4">
      <svg
        viewBox={spec.viewBox}
        role="img"
        aria-label={lang === "EN" ? spec.title_en : spec.title_hi}
        className="w-full h-auto max-h-[340px] mx-auto select-none"
      >
        <defs>
          {arrowColors.map((col) => (
            <marker
              key={col}
              id={markerIdForColor(col)}
              viewBox="0 0 10 10"
              refX="8.5"
              refY="5"
              markerWidth="6.5"
              markerHeight="6.5"
              orient="auto-start-reverse"
            >
              <path d="M 0 1 L 10 5 L 0 9 z" fill={col} />
            </marker>
          ))}
        </defs>

        {spec.elements.map((el, idx) => {
          switch (el.kind) {
            case "line":
              return (
                <line
                  key={idx}
                  x1={el.x1}
                  y1={el.y1}
                  x2={el.x2}
                  y2={el.y2}
                  stroke={safeColor(el.stroke, "#334155")}
                  strokeWidth={el.strokeWidth ?? 2}
                  strokeDasharray={el.dashed ? "6 4" : undefined}
                  strokeLinecap="round"
                />
              );

            case "arrow": {
              const col = safeColor(el.stroke, "#1E3A8A");
              return (
                <line
                  key={idx}
                  x1={el.x1}
                  y1={el.y1}
                  x2={el.x2}
                  y2={el.y2}
                  stroke={col}
                  strokeWidth={el.strokeWidth ?? 2.2}
                  strokeDasharray={el.dashed ? "6 4" : undefined}
                  strokeLinecap="round"
                  markerEnd={`url(#${markerIdForColor(col)})`}
                />
              );
            }

            case "rect":
              return (
                <rect
                  key={idx}
                  x={el.x}
                  y={el.y}
                  width={el.width}
                  height={el.height}
                  rx={el.rx ?? 0}
                  fill={safeColor(el.fill, "none")}
                  stroke={safeColor(el.stroke, "#1E3A8A")}
                  strokeWidth={el.strokeWidth ?? 2}
                />
              );

            case "circle":
              return (
                <circle
                  key={idx}
                  cx={el.cx}
                  cy={el.cy}
                  r={el.r}
                  fill={safeColor(el.fill, "#1E3A8A")}
                  stroke={el.stroke ? safeColor(el.stroke, "none") : "none"}
                  strokeWidth={el.strokeWidth ?? 0}
                />
              );

            case "ellipse":
              return (
                <ellipse
                  key={idx}
                  cx={el.cx}
                  cy={el.cy}
                  rx={el.rx}
                  ry={el.ry}
                  fill={safeColor(el.fill, "none")}
                  stroke={safeColor(el.stroke, "#1E3A8A")}
                  strokeWidth={el.strokeWidth ?? 2}
                />
              );

            case "path":
              if (!SAFE_PATH_RE.test(el.d)) return null;
              return (
                <path
                  key={idx}
                  d={el.d}
                  fill={safeColor(el.fill, "none")}
                  stroke={safeColor(el.stroke, "#1E3A8A")}
                  strokeWidth={el.strokeWidth ?? 2.5}
                  strokeDasharray={el.dashed ? "6 4" : undefined}
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              );

            case "polygon":
              if (!SAFE_POINTS_RE.test(el.points)) return null;
              return (
                <polygon
                  key={idx}
                  points={el.points}
                  fill={safeColor(el.fill, "#EFF6FF")}
                  stroke={safeColor(el.stroke, "#1E3A8A")}
                  strokeWidth={el.strokeWidth ?? 1.5}
                  strokeLinejoin="round"
                />
              );

            case "label": {
              const primaryText =
                lang === "EN" ? el.text_en || el.text_hi : el.text_hi || el.text_en;
              const showSecondary =
                lang === "BOTH" &&
                Boolean(el.text_en) &&
                el.text_en.trim() !== el.text_hi.trim();
              const fontSize = el.fontSize ?? 13;

              return (
                <text
                  key={idx}
                  x={el.x}
                  y={el.y}
                  fill={safeColor(el.fill, "#0F172A")}
                  fontSize={fontSize}
                  fontWeight={el.bold ? 700 : 500}
                  textAnchor={el.anchor ?? "start"}
                  className="font-sans"
                >
                  <tspan x={el.x}>{primaryText}</tspan>
                  {showSecondary && (
                    <tspan
                      x={el.x}
                      dy={Math.max(12, Math.round(fontSize * 1.15))}
                      fontSize={Math.max(10, fontSize - 2)}
                      fontWeight={500}
                      opacity={0.82}
                    >
                      {el.text_en}
                    </tspan>
                  )}
                </text>
              );
            }

            default:
              return null;
          }
        })}

        {/* Optional interactive pins for DIAGRAM_LABEL practice questions */}
        {hotspots &&
          hotspots.map((spot) => {
            const fill =
              spot.state === "correct"
                ? "#059669"
                : spot.state === "wrong"
                ? "#DC2626"
                : spot.state === "active"
                ? "#D97706"
                : "#1E3A8A";
            return (
              <g
                key={spot.id}
                onClick={() => onHotspotClick?.(spot.id)}
                className="cursor-pointer"
                role="button"
                tabIndex={0}
                onKeyDown={(e) => {
                  if (e.key === "Enter" || e.key === " ") {
                    e.preventDefault();
                    onHotspotClick?.(spot.id);
                  }
                }}
              >
                <circle
                  cx={spot.x}
                  cy={spot.y}
                  r={18}
                  fill={fill}
                  opacity={spot.state === "active" ? 0.24 : 0.14}
                />
                <circle
                  cx={spot.x}
                  cy={spot.y}
                  r={12}
                  fill={fill}
                  stroke="#FFFFFF"
                  strokeWidth={2.5}
                />
                <text
                  x={spot.x}
                  y={spot.y + 4.5}
                  textAnchor="middle"
                  fill="#FFFFFF"
                  fontSize={12}
                  fontWeight={700}
                >
                  {spot.label_code}
                </text>
              </g>
            );
          })}
      </svg>
    </div>
  );
}

const FLOW_ACCENT_STYLES: Record<"indigo" | "amber" | "emerald" | "slate", string> = {
  indigo: "bg-indigo-soft border-indigo-academic/30 text-indigo-ink",
  amber: "bg-amber-soft border-amber-warm/35 text-amber-ink",
  emerald: "bg-emerald-soft border-emerald-mastery/35 text-emerald-ink",
  slate: "bg-surface-subtle border-hairline-strong text-ink",
};

export function BilingualDiagramRenderer({
  spec,
  className,
  hotspots,
  onHotspotClick,
  compact = false,
}: BilingualDiagramRendererProps) {
  const { lang } = useLanguage();

  const iconForType = () => {
    switch (spec.type) {
      case "SVG_DIAGRAM":
        return <Sparkles className="h-4 w-4 text-indigo-ink shrink-0" aria-hidden="true" />;
      case "COMPARISON_TABLE":
        return <Table2 className="h-4 w-4 text-amber-ink shrink-0" aria-hidden="true" />;
      case "FLOWCHART":
        return <GitBranch className="h-4 w-4 text-emerald-ink shrink-0" aria-hidden="true" />;
      case "TIMELINE":
        return <Clock className="h-4 w-4 text-amber-ink shrink-0" aria-hidden="true" />;
      case "FORMULA_CARD":
        return <Sigma className="h-4 w-4 text-indigo-ink shrink-0" aria-hidden="true" />;
    }
  };

  return (
    <figure
      className={cn(
        "rounded-paper border border-hairline bg-surface shadow-paper overflow-hidden",
        compact ? "p-3 sm:p-4" : "p-4 sm:p-5",
        className
      )}
    >
      <div className="flex items-start gap-2.5 mb-3">
        <span className="mt-0.5 inline-flex h-7 w-7 items-center justify-center rounded-lg bg-surface-subtle border border-hairline shrink-0">
          {iconForType()}
        </span>
        <div className="min-w-0">
          <h4 className="text-sm sm:text-base font-bold text-ink leading-snug">
            <BiText hi={spec.title_hi} en={spec.title_en} />
          </h4>
        </div>
      </div>

      {/* 1. Declarative Bilingual SVG Diagram */}
      {spec.type === "SVG_DIAGRAM" && (
        <SvgVisual spec={spec} hotspots={hotspots} onHotspotClick={onHotspotClick} />
      )}

      {/* 2. Comparison Table */}
      {spec.type === "COMPARISON_TABLE" && (
        <div className="overflow-x-auto rounded-lg border border-hairline">
          <table className="w-full text-left border-collapse text-sm">
            <thead>
              <tr className="bg-surface-subtle border-b border-hairline">
                {spec.headers_hi.map((hHi, idx) => (
                  <th
                    key={idx}
                    className="px-3.5 py-2.5 font-bold text-ink text-xs sm:text-sm align-top"
                  >
                    <BiText hi={hHi} en={spec.headers_en[idx] ?? hHi} />
                  </th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-hairline">
              {spec.rows.map((row, rIdx) => (
                <tr
                  key={rIdx}
                  className={cn(
                    "transition-colors hover:bg-surface-subtle/60",
                    rIdx % 2 === 1 && "bg-canvas/50"
                  )}
                >
                  {row.cells_hi.map((cHi, cIdx) => (
                    <td
                      key={cIdx}
                      className={cn(
                        "px-3.5 py-2.5 align-top leading-relaxed text-ink-secondary",
                        cIdx === 0 && "font-semibold text-ink"
                      )}
                    >
                      <BiText hi={cHi} en={row.cells_en[cIdx] ?? cHi} />
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* 3. Flowchart */}
      {spec.type === "FLOWCHART" && (
        <div
          className={cn(
            "flex gap-2.5",
            spec.direction === "LR"
              ? "flex-col lg:flex-row lg:items-stretch"
              : "flex-col"
          )}
        >
          {spec.steps.map((step, idx) => {
            const nextEdge = spec.edges.find(
              (edge) =>
                edge.from === step.id &&
                spec.steps[idx + 1] &&
                edge.to === spec.steps[idx + 1].id
            );
            const incomingEdge =
              idx > 0
                ? spec.edges.find((edge) => edge.to === step.id)
                : undefined;

            return (
              <React.Fragment key={step.id}>
                <div
                  className={cn(
                    "flex-1 rounded-lg border px-4 py-3 flex flex-col justify-center",
                    FLOW_ACCENT_STYLES[step.accent ?? "indigo"]
                  )}
                >
                  {incomingEdge && (incomingEdge.label_hi || incomingEdge.label_en) && (
                    <span className="mb-1 inline-flex w-fit rounded-full bg-surface/85 px-2 py-0.5 text-[11px] font-bold border border-hairline text-ink">
                      <BiText
                        hi={incomingEdge.label_hi ?? ""}
                        en={incomingEdge.label_en ?? ""}
                        inline
                      />
                    </span>
                  )}
                  <div className="font-bold text-sm leading-snug">
                    <BiText hi={step.label_hi} en={step.label_en} />
                  </div>
                  {(step.detail_hi || step.detail_en) && (
                    <div className="mt-1 text-xs opacity-90 leading-relaxed">
                      <BiText hi={step.detail_hi ?? ""} en={step.detail_en ?? ""} />
                    </div>
                  )}
                </div>

                {idx < spec.steps.length - 1 && (
                  <div className="flex flex-col items-center justify-center shrink-0 py-0.5 text-ink-muted">
                    {nextEdge && (nextEdge.label_hi || nextEdge.label_en) && (
                      <span className="mb-0.5 text-[11px] font-semibold text-amber-ink">
                        <BiText
                          hi={nextEdge.label_hi ?? ""}
                          en={nextEdge.label_en ?? ""}
                          inline
                        />
                      </span>
                    )}
                    {spec.direction === "LR" ? (
                      <>
                        <ArrowRight className="hidden lg:block h-4 w-4" aria-hidden="true" />
                        <ArrowDown className="lg:hidden h-4 w-4" aria-hidden="true" />
                      </>
                    ) : (
                      <ArrowDown className="h-4 w-4" aria-hidden="true" />
                    )}
                  </div>
                )}
              </React.Fragment>
            );
          })}
        </div>
      )}

      {/* 4. Historical Timeline */}
      {spec.type === "TIMELINE" && (
        <ol className="relative border-l-2 border-indigo-academic/30 ml-3 pl-5 space-y-4 py-1">
          {spec.events.map((ev, idx) => (
            <li key={`${ev.year}-${idx}`} className="relative">
              <span
                className={cn(
                  "absolute -left-[27px] top-1.5 h-3.5 w-3.5 rounded-full border-2 border-surface",
                  ev.highlight ? "bg-amber-warm ring-4 ring-amber-soft" : "bg-indigo-academic"
                )}
                aria-hidden="true"
              />
              <div
                className={cn(
                  "rounded-lg border p-3.5 transition-colors",
                  ev.highlight
                    ? "bg-surface-warm border-amber-warm/35"
                    : "bg-surface-subtle/60 border-hairline"
                )}
              >
                <div className="flex flex-wrap items-center gap-2 mb-1">
                  <span className="inline-flex items-center rounded-md bg-indigo-academic text-white px-2 py-0.5 text-xs font-bold tracking-wide">
                    {ev.year}
                  </span>
                  <span className="font-bold text-sm text-ink">
                    <BiText hi={ev.title_hi} en={ev.title_en} inline />
                  </span>
                </div>
                <p className="text-xs sm:text-sm text-ink-secondary leading-relaxed">
                  <BiText hi={ev.detail_hi} en={ev.detail_en} />
                </p>
              </div>
            </li>
          ))}
        </ol>
      )}

      {/* 5. Formula Card */}
      {spec.type === "FORMULA_CARD" && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
          {spec.formulas.map((item, idx) => (
            <div
              key={idx}
              className="rounded-lg border border-indigo-academic/20 bg-indigo-soft p-3.5 flex flex-col justify-between gap-2"
            >
              <div className="overflow-x-auto py-1 text-center text-ink">
                <MathMarkdown content={`$$${item.latex}$$`} />
              </div>
              <div className="border-t border-indigo-academic/15 pt-2 flex items-start justify-between gap-2">
                <div className="text-xs sm:text-sm font-medium text-ink leading-snug">
                  <BiText hi={item.meaning_hi} en={item.meaning_en} />
                </div>
                {item.unit && (
                  <span className="shrink-0 rounded-full bg-surface px-2 py-0.5 text-[11px] font-bold text-indigo-ink border border-hairline">
                    {item.unit}
                  </span>
                )}
              </div>
              {(item.example_hi || item.example_en) && (
                <div className="text-xs text-ink-secondary flex items-start gap-1.5">
                  <CheckCircle2 className="h-3.5 w-3.5 text-emerald-ink shrink-0 mt-0.5" />
                  <BiText hi={item.example_hi ?? ""} en={item.example_en ?? ""} />
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Bilingual Caption */}
      {"caption_hi" in spec && (spec.caption_hi || spec.caption_en) && (
        <figcaption className="mt-3 pt-2.5 border-t border-hairline text-xs sm:text-sm text-ink-secondary leading-relaxed">
          {lang === "EN"
            ? spec.caption_en || spec.caption_hi
            : lang === "HI"
            ? spec.caption_hi || spec.caption_en
            : (
                <BiText
                  hi={spec.caption_hi ?? ""}
                  en={spec.caption_en ?? ""}
                />
              )}
        </figcaption>
      )}
    </figure>
  );
}
