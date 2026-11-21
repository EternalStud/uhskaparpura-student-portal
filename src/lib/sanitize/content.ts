import sanitizeHtml from 'sanitize-html';
import { marked } from 'marked';
import { z } from 'zod';
import type {
  BilingualDiagramSpec,
  SafeSvgElement,
  SvgDiagramSpec,
} from '@/types/database';

/**
 * Strict XSS sanitization for student doubts, teacher notes, Markdown, YouTube IDs,
 * and declarative bilingual SVG diagram specifications.
 *
 * Security invariants:
 * - Zero `<script>`, `<iframe>`, `<object>`, `<embed>`, `<svg>`, `<foreignObject>`,
 *   inline event handlers (`on*`), `javascript:` / `data:` / `vbscript:` URLs.
 * - Declarative SVG diagrams whitelist ONLY safe geometric primitives and bilingual labels,
 *   with strict numeric bounds and zero external references.
 */

// Strip BiDi override characters (Trojan Source / text spoofing) & ASCII control bytes
const DANGEROUS_CONTROL_CHARS = /[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F\u202A-\u202E\u2066-\u2069]/g;

const SAFE_HTML_TAGS = [
  'p',
  'br',
  'strong',
  'b',
  'em',
  'i',
  'u',
  's',
  'del',
  'code',
  'pre',
  'blockquote',
  'ul',
  'ol',
  'li',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'hr',
  'table',
  'thead',
  'tbody',
  'tr',
  'th',
  'td',
  'sup',
  'sub',
  'span',
];

const SAFE_HTML_OPTIONS: sanitizeHtml.IOptions = {
  allowedTags: SAFE_HTML_TAGS,
  allowedAttributes: {
    th: ['align', 'colspan', 'rowspan'],
    td: ['align', 'colspan', 'rowspan'],
    code: ['class'],
    span: ['class'],
  },
  allowedClasses: {
    code: [/^language-[a-z0-9_-]{1,24}$/i],
    span: [/^katex(-[a-z0-9_-]+)?$/i],
  },
  allowedSchemes: ['https'],
  allowedSchemesByTag: {},
  allowProtocolRelative: false,
  disallowedTagsMode: 'discard',
  enforceHtmlBoundary: true,
};

/**
 * Sanitizes untrusted plain text (student doubts, teacher answers, titles, names).
 * Strips ALL HTML tags, BiDi overrides, and dangerous control bytes.
 */
export function sanitizePlainText(input: string, maxLength: number = 4000): string {
  if (typeof input !== 'string') return '';
  const stripped = sanitizeHtml(input, {
    allowedTags: [],
    allowedAttributes: {},
    disallowedTagsMode: 'discard',
  });
  return stripped
    .replace(DANGEROUS_CONTROL_CHARS, '')
    .replace(/\r\n/g, '\n')
    .replace(/\r/g, '\n')
    .trim()
    .slice(0, maxLength);
}

/**
 * Sanitizes Markdown source text before storing in DB.
 * Strips ALL raw HTML/XML tags (including `<img>`, `<a>`, `<svg>`, `<details>`, `<script>`)
 * and dangerous URI schemes to a fixed point (defeating nested tag bypasses like `<scr<script>ipt>`)
 * while preserving LaTeX `$...$` / `$$...$$` formulas and math inequalities like `a < b`.
 */
export function sanitizeMarkdownSource(input: string, maxLength: number = 25000): string {
  if (typeof input !== 'string') return '';

  const normalized = input
    .replace(DANGEROUS_CONTROL_CHARS, '')
    .replace(/\r\n/g, '\n')
    .replace(/\r/g, '\n');

  // Preserve valid LaTeX math segments ($...$ and $$...$$) so math like `$x<y$` is not mangled,
  // while still verifying the math text itself contains zero HTML tags or script schemes.
  const mathTokens: string[] = [];
  const withPlaceholders = normalized.replace(
    /(\$\$[\s\S]+?\$\$|\$(?!\s)[^$\n]+?(?<!\s)\$)/g,
    (match) => {
      if (/<\/?[a-zA-Z]|javascript\s*:|vbscript\s*:|data\s*:\s*text\/html/i.test(match)) {
        return match; // Do not protect math containing HTML/XSS payloads
      }
      const idx = mathTokens.push(match) - 1;
      return `\uE010MATH_${idx}\uE011`;
    }
  );

  // Strip HTML comments, processing instructions, doctype, all raw HTML tags, and dangerous schemes
  // iteratively until fixed point so nested payloads like `<scr<script>ipt>` cannot reassemble.
  let cleaned = withPlaceholders;
  for (let pass = 0; pass < 8; pass++) {
    const next = cleaned
      .replace(/<!--[\s\S]*?-->/g, '')
      .replace(/<\?[\s\S]*?\?>/g, '')
      .replace(/<!DOCTYPE[^>]*>/gi, '')
      // Match valid HTML/SVG/XML tags (`<tag ...>`, `</tag>`, `<svg/onload=...>`) without touching `a < b`
      .replace(/<\/?[a-zA-Z][a-zA-Z0-9-]*(?:[\s/][^>]*)?>/g, '')
      .replace(/javascript\s*:/gi, '')
      .replace(/vbscript\s*:/gi, '')
      .replace(/data\s*:\s*text\/html/gi, '');

    if (next === cleaned) break;
    cleaned = next;
  }

  // Restore protected safe LaTeX segments
  const restored = cleaned.replace(/\uE010MATH_(\d+)\uE011/g, (_, idxStr: string) => {
    return mathTokens[Number(idxStr)] ?? '';
  });

  return restored.trim().slice(0, maxLength);
}

/**
 * Sanitizes already-rendered HTML using a strict tag/attribute allowlist.
 * Disallows links (`<a>`), images (`<img>`), scripts, inline styles, and event handlers.
 */
export function sanitizeAcademicHtml(rawHtml: string): string {
  if (typeof rawHtml !== 'string') return '';
  return sanitizeHtml(rawHtml.replace(DANGEROUS_CONTROL_CHARS, ''), SAFE_HTML_OPTIONS);
}

/**
 * Converts Markdown into strictly sanitized HTML safe for rendering academic notes/doubts.
 */
export function renderSafeMarkdownToHtml(markdown: string, maxLength: number = 25000): string {
  const safeMd = sanitizeMarkdownSource(markdown, maxLength);
  if (!safeMd) return '';
  const rawHtml = marked.parse(safeMd, {
    async: false,
    gfm: true,
    breaks: true,
  }) as string;
  return sanitizeAcademicHtml(rawHtml);
}

/**
 * Strictly extracts & validates an 11-character YouTube video ID from a URL or raw ID.
 * Only accepts youtube.com / youtu.be / youtube-nocookie.com hosts or raw 11-char IDs.
 */
export function extractYoutubeVideoId(input: string | null | undefined): string | null {
  if (!input || typeof input !== 'string') return null;
  const trimmed = input.trim();
  const idRegex = /^[A-Za-z0-9_-]{11}$/;

  if (idRegex.test(trimmed)) {
    return trimmed;
  }

  try {
    const parsed = new URL(trimmed);
    const host = parsed.hostname.toLowerCase().replace(/^www\./, '');
    if (host === 'youtu.be') {
      const candidate = parsed.pathname.split('/').filter(Boolean)[0] ?? '';
      return idRegex.test(candidate) ? candidate : null;
    }
    if (host === 'youtube.com' || host === 'm.youtube.com' || host === 'youtube-nocookie.com') {
      const vParam = parsed.searchParams.get('v');
      if (vParam && idRegex.test(vParam)) return vParam;

      const segments = parsed.pathname.split('/').filter(Boolean);
      if (
        segments.length >= 2 &&
        (segments[0] === 'embed' || segments[0] === 'shorts' || segments[0] === 'live') &&
        idRegex.test(segments[1])
      ) {
        return segments[1];
      }
    }
  } catch {
    return null;
  }

  return null;
}

// =============================================================================
// DECLARATIVE BILINGUAL SVG DIAGRAM SPEC VALIDATOR
// =============================================================================

const HEX_COLOR_REGEX = /^#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/;
const SAFE_NAMED_COLORS = new Set([
  'none',
  'transparent',
  'currentcolor',
  'black',
  'white',
  'slate',
  'gray',
  'indigo',
  'amber',
  'emerald',
  'red',
  'blue',
  'green',
  'orange',
  'purple',
  'teal',
  'crimson',
  'navy',
  'gold',
]);

const UNSAFE_URL_OR_SCRIPT_PATTERN =
  /(?:javascript:|vbscript:|data:|https?:|\/\/|url\s*\(|expression\s*\(|<\s*script|on[a-z]+\s*=)/i;

// Whitelisted SVG path data characters ONLY: standard path commands + digits + whitespace/separators
const SAFE_SVG_PATH_REGEX = /^[MmLlHhVvCcSsQqTtAaZz0-9.,\s+-]{1,4000}$/;
const SAFE_POLYGON_POINTS_REGEX = /^[\d.,\s+-]{1,2000}$/;
const VIEWBOX_REGEX = /^(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)$/;

/**
 * Validates that a color string is a safe hex literal or whitelisted named color (no `url(...)` / CSS injection).
 */
export function isSafeSvgColor(color: string | undefined): boolean {
  if (color === undefined) return true;
  const trimmed = color.trim();
  if (trimmed.length === 0 || trimmed.length > 32) return false;
  if (UNSAFE_URL_OR_SCRIPT_PATTERN.test(trimmed)) return false;
  if (HEX_COLOR_REGEX.test(trimmed)) return true;
  return SAFE_NAMED_COLORS.has(trimmed.toLowerCase());
}

/**
 * Validates that SVG path `d` data contains strictly numeric coordinates & path commands.
 */
export function isSafeSvgPathData(d: string): boolean {
  return (
    typeof d === 'string' &&
    SAFE_SVG_PATH_REGEX.test(d) &&
    !UNSAFE_URL_OR_SCRIPT_PATTERN.test(d)
  );
}

function isSafeDiagramText(text: string): boolean {
  if (typeof text !== 'string') return false;
  if (text.length > 500) return false;
  // Block any HTML/XML tag syntax while allowing mathematical inequalities like "D > 0" or "a < 0"
  if (/<\s*\/?\s*[a-zA-Z!/?]/.test(text)) return false;
  if (UNSAFE_URL_OR_SCRIPT_PATTERN.test(text)) return false;
  return true;
}

const finiteCoord = z.number().finite().min(-5000).max(5000);
const positiveDim = z.number().finite().min(0).max(5000);
const safeStrokeWidth = z.number().finite().min(0.2).max(30).optional();
const safeColorSchema = z.string().refine(isSafeSvgColor, 'Unsafe or invalid SVG color').optional();
const safeTextSchema = z.string().min(1).max(500).refine(isSafeDiagramText, 'Unsafe text in diagram');
const safeOptionalTextSchema = z
  .string()
  .max(500)
  .refine(isSafeDiagramText, 'Unsafe text in diagram')
  .optional();

const safeSvgElementSchema: z.ZodType<SafeSvgElement> = z.discriminatedUnion('kind', [
  z
    .object({
      kind: z.literal('line'),
      x1: finiteCoord,
      y1: finiteCoord,
      x2: finiteCoord,
      y2: finiteCoord,
      stroke: safeColorSchema,
      strokeWidth: safeStrokeWidth,
      dashed: z.boolean().optional(),
    })
    .strict(),
  z
    .object({
      kind: z.literal('arrow'),
      x1: finiteCoord,
      y1: finiteCoord,
      x2: finiteCoord,
      y2: finiteCoord,
      stroke: safeColorSchema,
      strokeWidth: safeStrokeWidth,
      dashed: z.boolean().optional(),
    })
    .strict(),
  z
    .object({
      kind: z.literal('rect'),
      x: finiteCoord,
      y: finiteCoord,
      width: positiveDim,
      height: positiveDim,
      rx: positiveDim.optional(),
      fill: safeColorSchema,
      stroke: safeColorSchema,
      strokeWidth: safeStrokeWidth,
    })
    .strict(),
  z
    .object({
      kind: z.literal('circle'),
      cx: finiteCoord,
      cy: finiteCoord,
      r: positiveDim,
      fill: safeColorSchema,
      stroke: safeColorSchema,
      strokeWidth: safeStrokeWidth,
    })
    .strict(),
  z
    .object({
      kind: z.literal('ellipse'),
      cx: finiteCoord,
      cy: finiteCoord,
      rx: positiveDim,
      ry: positiveDim,
      fill: safeColorSchema,
      stroke: safeColorSchema,
      strokeWidth: safeStrokeWidth,
    })
    .strict(),
  z
    .object({
      kind: z.literal('path'),
      d: z.string().refine(isSafeSvgPathData, 'Unsafe SVG path data'),
      fill: safeColorSchema,
      stroke: safeColorSchema,
      strokeWidth: safeStrokeWidth,
      dashed: z.boolean().optional(),
    })
    .strict(),
  z
    .object({
      kind: z.literal('polygon'),
      points: z
        .string()
        .refine(
          (pts) => SAFE_POLYGON_POINTS_REGEX.test(pts) && !UNSAFE_URL_OR_SCRIPT_PATTERN.test(pts),
          'Unsafe polygon points'
        ),
      fill: safeColorSchema,
      stroke: safeColorSchema,
      strokeWidth: safeStrokeWidth,
    })
    .strict(),
  z
    .object({
      kind: z.literal('label'),
      x: finiteCoord,
      y: finiteCoord,
      text_hi: safeTextSchema,
      text_en: safeTextSchema,
      fill: safeColorSchema,
      fontSize: z.number().finite().min(6).max(72).optional(),
      anchor: z.enum(['start', 'middle', 'end']).optional(),
      bold: z.boolean().optional(),
    })
    .strict(),
]);

export const svgDiagramSpecSchema = z
  .object({
    type: z.literal('SVG_DIAGRAM'),
    title_hi: safeTextSchema,
    title_en: safeTextSchema,
    caption_hi: safeTextSchema,
    caption_en: safeTextSchema,
    viewBox: z.string().refine((vb) => {
      const m = VIEWBOX_REGEX.exec(vb.trim());
      if (!m) return false;
      const w = Number(m[3]);
      const h = Number(m[4]);
      return w >= 10 && w <= 2400 && h >= 10 && h <= 2400;
    }, 'Invalid or out-of-bounds SVG viewBox'),
    elements: z.array(safeSvgElementSchema).min(1).max(200),
  })
  .strict();

export const comparisonTableSpecSchema = z
  .object({
    type: z.literal('COMPARISON_TABLE'),
    title_hi: safeTextSchema,
    title_en: safeTextSchema,
    caption_hi: safeOptionalTextSchema,
    caption_en: safeOptionalTextSchema,
    headers_hi: z.array(safeTextSchema).min(2).max(10),
    headers_en: z.array(safeTextSchema).min(2).max(10),
    rows: z
      .array(
        z
          .object({
            cells_hi: z.array(safeTextSchema).min(2).max(10),
            cells_en: z.array(safeTextSchema).min(2).max(10),
          })
          .strict()
      )
      .min(1)
      .max(50),
  })
  .strict();

export const flowchartDiagramSpecSchema = z
  .object({
    type: z.literal('FLOWCHART'),
    title_hi: safeTextSchema,
    title_en: safeTextSchema,
    caption_hi: safeOptionalTextSchema,
    caption_en: safeOptionalTextSchema,
    direction: z.enum(['TB', 'LR']),
    steps: z
      .array(
        z
          .object({
            id: z.string().regex(/^[a-zA-Z0-9_-]{1,40}$/),
            label_hi: safeTextSchema,
            label_en: safeTextSchema,
            detail_hi: safeOptionalTextSchema,
            detail_en: safeOptionalTextSchema,
            accent: z.enum(['indigo', 'amber', 'emerald', 'slate']).optional(),
          })
          .strict()
      )
      .min(1)
      .max(30),
    edges: z
      .array(
        z
          .object({
            from: z.string().regex(/^[a-zA-Z0-9_-]{1,40}$/),
            to: z.string().regex(/^[a-zA-Z0-9_-]{1,40}$/),
            label_hi: safeOptionalTextSchema,
            label_en: safeOptionalTextSchema,
          })
          .strict()
      )
      .max(60),
  })
  .strict();

export const timelineDiagramSpecSchema = z
  .object({
    type: z.literal('TIMELINE'),
    title_hi: safeTextSchema,
    title_en: safeTextSchema,
    caption_hi: safeOptionalTextSchema,
    caption_en: safeOptionalTextSchema,
    events: z
      .array(
        z
          .object({
            year: safeTextSchema,
            title_hi: safeTextSchema,
            title_en: safeTextSchema,
            detail_hi: safeTextSchema,
            detail_en: safeTextSchema,
            highlight: z.boolean().optional(),
          })
          .strict()
      )
      .min(1)
      .max(40),
  })
  .strict();

export const formulaCardSpecSchema = z
  .object({
    type: z.literal('FORMULA_CARD'),
    title_hi: safeTextSchema,
    title_en: safeTextSchema,
    formulas: z
      .array(
        z
          .object({
            latex: safeTextSchema,
            meaning_hi: safeTextSchema,
            meaning_en: safeTextSchema,
            unit: safeOptionalTextSchema,
            example_hi: safeOptionalTextSchema,
            example_en: safeOptionalTextSchema,
          })
          .strict()
      )
      .min(1)
      .max(30),
  })
  .strict();

export const bilingualDiagramSpecSchema = z.discriminatedUnion('type', [
  svgDiagramSpecSchema,
  comparisonTableSpecSchema,
  flowchartDiagramSpecSchema,
  timelineDiagramSpecSchema,
  formulaCardSpecSchema,
]);

/**
 * Validates an untrusted declarative bilingual SVG spec (`SVG_DIAGRAM`).
 * Rejects any unexpected fields (`.strict()`), scripts, event handlers, or external URLs.
 */
export function validateSvgDiagramSpec(
  input: unknown
): { ok: true; data: SvgDiagramSpec } | { ok: false; errors: string[] } {
  const result = svgDiagramSpecSchema.safeParse(input);
  if (result.success) {
    return { ok: true, data: result.data };
  }
  return {
    ok: false,
    errors: result.error.issues.map((i) => `${i.path.join('.') || 'root'}: ${i.message}`),
  };
}

/**
 * Validates any declarative `BilingualDiagramSpec` (SVG, Comparison Table, Flowchart, Timeline, Formula Card).
 */
export function validateBilingualDiagramSpec(
  input: unknown
): { ok: true; data: BilingualDiagramSpec } | { ok: false; errors: string[] } {
  const result = bilingualDiagramSpecSchema.safeParse(input);
  if (result.success) {
    return { ok: true, data: result.data };
  }
  return {
    ok: false,
    errors: result.error.issues.map((i) => `${i.path.join('.') || 'root'}: ${i.message}`),
  };
}
