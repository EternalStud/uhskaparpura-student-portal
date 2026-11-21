import type { Metadata, Viewport } from "next";
import { Plus_Jakarta_Sans, Noto_Sans_Devanagari } from "next/font/google";
import "katex/dist/katex.min.css";
import "./globals.css";
import { ThemeProvider } from "@/components/providers/ThemeProvider";
import { LanguageProvider } from "@/components/providers/LanguageProvider";
import { SessionSyncListener } from "@/components/providers/SessionSyncListener";
import { ToastProvider } from "@/components/ui/Toast";

const plusJakartaSans = Plus_Jakarta_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
  variable: "--font-plus-jakarta",
  display: "swap",
});

const notoSansDevanagari = Noto_Sans_Devanagari({
  subsets: ["devanagari", "latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-noto-devanagari",
  display: "swap",
});

export const metadata: Metadata = {
  title: {
    default: "Students of Bihar (9–12) | बिहार के विद्यार्थी",
    template: "%s · Students of Bihar (9–12)",
  },
  description:
    "Official Bihar Board (BSEB) Class 9–12 bilingual visual chapter notes, interactive practice studio, live classroom exams, and open doubt boards.",
  applicationName: "Students of Bihar (9–12)",
  robots: {
    index: true,
    follow: true,
  },
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#FAFAF9" },
    { media: "(prefers-color-scheme: dark)", color: "#0F141E" },
  ],
};

// Static anti-FOUC bootstrap for Night Study mode (reads only local preference)
const THEME_INIT_SCRIPT = `(function(){try{if(localStorage.getItem('sob_theme')==='dark'){document.documentElement.classList.add('dark');}}catch(e){}})();`;

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="hi"
      suppressHydrationWarning
      className={`${plusJakartaSans.variable} ${notoSansDevanagari.variable}`}
    >
      <head>
        <script dangerouslySetInnerHTML={{ __html: THEME_INIT_SCRIPT }} />
      </head>
      <body className="min-h-dvh bg-canvas text-ink font-sans antialiased selection:bg-indigo-soft selection:text-indigo-ink">
        <ThemeProvider>
          <LanguageProvider defaultLang="HI">
            <ToastProvider>
              <SessionSyncListener />
              {children}
            </ToastProvider>
          </LanguageProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
