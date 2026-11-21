"use client";

import React, { useMemo } from "react";
import katex from "katex";
import { marked } from "marked";
import sanitizeHtml from "sanitize-html";
import { cn } from "./cn";

const SENTINEL_START = "\uE000";
const SENTINEL_END = "\uE001";

interface ExtractedMath {
  token: string;
  rawMatch: string;
  expr: string;
  displayMode: boolean;
}

function escapeHtml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

const SANITIZE_CONFIG: sanitizeHtml.IOptions = {
  allowedTags: [
    "p",
    "br",
    "strong",
    "b",
    "em",
    "i",
    "u",
    "s",
    "del",
    "sup",
    "sub",
    "h1",
    "h2",
    "h3",
    "h4",
    "ul",
    "ol",
    "li",
    "blockquote",
    "code",
    "pre",
    "table",
    "thead",
    "tbody",
    "tr",
    "th",
    "td",
    "hr",
    "a",
    "span",
    "div",
  ],
  allowedAttributes: {
    a: ["href", "target", "rel"],
    th: ["align"],
    td: ["align"],
  },
  allowedSchemes: ["http", "https", "mailto"],
  disallowedTagsMode: "discard",
  transformTags: {
    a: (_tagName, attribs) => ({
      tagName: "a",
      attribs: {
        ...attribs,
        target: "_blank",
        rel: "noopener noreferrer",
      },
    }),
  },
};

/**
 * Safely renders Markdown + LaTeX (KaTeX) with zero raw-HTML XSS exposure:
 * 1. Strips sentinel codepoints so placeholders cannot be spoofed.
 * 2. Protects fenced/inline code blocks so `$` in code is left untouched.
 * 3. Extracts display ($$...$$, \[...\]) & inline ($...$, \(...\)) math tokens.
 * 4. Parses Markdown & sanitizes all resulting HTML via strict sanitize-html allowlist.
 * 5. Splits sanitized HTML into tags vs text nodes:
 *    - Inside HTML tags/attributes: NEVER injects KaTeX HTML; restores any raw or
 *      percent-encoded sentinels back to escaped plain text.
 *    - Inside text nodes only: substitutes KaTeX rendered with `trust: false`.
 */
export function renderSafeMathMarkdown(
  rawInput: string,
  inline = false
): string {
  if (!rawInput) return "";

  // 1. Strip private-use sentinels to make placeholder injection impossible
  let text = rawInput.replace(/[\uE000\uE001]/g, "");

  // 2. Temporarily shield fenced code blocks and inline code spans
  const codeSegments: string[] = [];
  text = text.replace(/```[\s\S]*?```|`[^`\n]+`/g, (match) => {
    const idx = codeSegments.length;
    codeSegments.push(match);
    return `${SENTINEL_START}CODE_${idx}${SENTINEL_END}`;
  });

  // 3. Extract LaTeX expressions
  const mathItems: ExtractedMath[] = [];
  const registerMath = (
    rawMatch: string,
    expr: string,
    displayMode: boolean
  ): string => {
    const idx = mathItems.length;
    const token = `${SENTINEL_START}MATH_${idx}${SENTINEL_END}`;
    mathItems.push({ token, rawMatch, expr: expr.trim(), displayMode });
    return token;
  };

  // Display math: $$ ... $$
  text = text.replace(/\$\$([\s\S]+?)\$\$/g, (match, expr: string) =>
    registerMath(match, expr, true)
  );

  // Display math: \[ ... \]
  text = text.replace(/\\\[([\s\S]+?)\\\]/g, (match, expr: string) =>
    registerMath(match, expr, true)
  );

  // Inline math: \( ... \)
  text = text.replace(/\\\(([\s\S]+?)\\\)/g, (match, expr: string) =>
    registerMath(match, expr, false)
  );

  // Inline math: $ ... $ (non-empty, single line, unescaped)
  text = text.replace(
    /(^|[^\\])(\$(?!\s)([^\n$]+?)(?<!\s)\$)/g,
    (_m, lead: string, fullMath: string, expr: string) =>
      `${lead}${registerMath(fullMath, expr, false)}`
  );

  // Restore code spans before Markdown parsing
  text = text.replace(
    /\uE000CODE_(\d+)\uE001/g,
    (_m, idxStr: string) => codeSegments[Number(idxStr)] ?? ""
  );

  // 4. Parse Markdown & sanitize strictly
  const parsed = inline
    ? (marked.parseInline(text, { async: false, gfm: true, breaks: true }) as string)
    : (marked.parse(text, { async: false, gfm: true, breaks: true }) as string);

  const safeHtml = sanitizeHtml(parsed, SANITIZE_CONFIG);

  if (mathItems.length === 0) {
    return safeHtml;
  }

  // Pre-render each extracted math expression safely with trust: false
  const renderedMap = new Map<number, string>();
  const renderMathByIndex = (idx: number): string => {
    const cached = renderedMap.get(idx);
    if (cached !== undefined) return cached;
    const item = mathItems[idx];
    if (!item) return "";
    let rendered: string;
    try {
      rendered = katex.renderToString(item.expr, {
        displayMode: item.displayMode && !inline,
        throwOnError: false,
        strict: false,
        trust: false,
        maxExpand: 500,
        maxSize: 10,
      });
    } catch {
      rendered = `<code>${escapeHtml(item.expr)}</code>`;
    }
    renderedMap.set(idx, rendered);
    return rendered;
  };

  // 5. Split sanitized HTML into tags vs text nodes — NEVER inject HTML inside tags/attributes
  const parts = safeHtml.split(/(<[^>]*>)/g);
  return parts
    .map((part, idx) => {
      if (!part) return "";
      if (idx % 2 === 1) {
        // HTML tag / attribute segment: restore any raw or percent-encoded math sentinel to escaped raw source
        return part
          .replace(
            /(?:\uE000|%EE%80%80)MATH_(\d+)(?:\uE001|%EE%80%81)/gi,
            (_m, numStr: string) => {
              const item = mathItems[Number(numStr)];
              return item ? escapeHtml(item.rawMatch) : "";
            }
          );
      }

      // Pure text node: substitute KaTeX HTML safely
      return part.replace(
        /\uE000MATH_(\d+)\uE001/g,
        (_m, numStr: string) => renderMathByIndex(Number(numStr))
      );
    })
    .join("");
}

export interface MathMarkdownProps {
  content: string;
  inline?: boolean;
  className?: string;
}

export function MathMarkdown({
  content,
  inline = false,
  className,
}: MathMarkdownProps) {
  const html = useMemo(
    () => renderSafeMathMarkdown(content, inline),
    [content, inline]
  );

  if (inline) {
    return (
      <span
        className={cn("break-words", className)}
        dangerouslySetInnerHTML={{ __html: html }}
      />
    );
  }

  return (
    <div
      className={cn("prose-textbook break-words", className)}
      dangerouslySetInnerHTML={{ __html: html }}
    />
  );
}
