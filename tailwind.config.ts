import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        canvas: "rgb(var(--bg-canvas-rgb) / <alpha-value>)",
        surface: "rgb(var(--bg-surface-rgb) / <alpha-value>)",
        "surface-subtle": "rgb(var(--bg-surface-subtle-rgb) / <alpha-value>)",
        "surface-warm": "rgb(var(--bg-surface-warm-rgb) / <alpha-value>)",
        ink: "rgb(var(--text-ink-rgb) / <alpha-value>)",
        "ink-secondary": "rgb(var(--text-secondary-rgb) / <alpha-value>)",
        "ink-muted": "rgb(var(--text-muted-rgb) / <alpha-value>)",
        hairline: "rgb(var(--border-hairline-rgb) / <alpha-value>)",
        "hairline-strong": "rgb(var(--border-strong-rgb) / <alpha-value>)",
        indigo: {
          academic: "rgb(var(--accent-indigo-rgb) / <alpha-value>)",
          "academic-hover": "rgb(var(--accent-indigo-hover-rgb) / <alpha-value>)",
          soft: "var(--accent-indigo-soft)",
          ink: "rgb(var(--accent-indigo-ink-rgb) / <alpha-value>)",
        },
        amber: {
          warm: "rgb(var(--accent-amber-rgb) / <alpha-value>)",
          soft: "var(--accent-amber-soft)",
          ink: "rgb(var(--accent-amber-ink-rgb) / <alpha-value>)",
        },
        emerald: {
          mastery: "rgb(var(--accent-emerald-rgb) / <alpha-value>)",
          soft: "var(--accent-emerald-soft)",
          ink: "rgb(var(--accent-emerald-ink-rgb) / <alpha-value>)",
        },
        crimson: {
          alert: "rgb(var(--accent-crimson-rgb) / <alpha-value>)",
          soft: "var(--accent-crimson-soft)",
          ink: "rgb(var(--accent-crimson-ink-rgb) / <alpha-value>)",
        },
      },
      fontFamily: {
        sans: [
          "var(--font-plus-jakarta)",
          "var(--font-noto-devanagari)",
          "system-ui",
          "-apple-system",
          "sans-serif",
        ],
        hindi: [
          "var(--font-noto-devanagari)",
          "var(--font-plus-jakarta)",
          "system-ui",
          "sans-serif",
        ],
        mono: [
          "ui-monospace",
          "SFMono-Regular",
          "Menlo",
          "Monaco",
          "Consolas",
          "monospace",
        ],
      },
      borderRadius: {
        paper: "0.75rem",
        sheet: "1rem",
      },
      boxShadow: {
        paper: "0 1px 2px 0 rgba(15, 23, 42, 0.04), 0 1px 3px 0 rgba(15, 23, 42, 0.03)",
        "paper-hover": "0 4px 12px -2px rgba(15, 23, 42, 0.07), 0 2px 4px -2px rgba(15, 23, 42, 0.04)",
        modal: "0 20px 40px -12px rgba(15, 23, 42, 0.18), 0 4px 12px -2px rgba(15, 23, 42, 0.06)",
      },
      maxWidth: {
        reading: "72ch",
      },
    },
  },
  plugins: [],
};

export default config;
