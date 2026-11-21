"use client";

import React, { useState } from "react";
import {
  Download,
  ExternalLink,
  FileText,
  Film,
  Image as ImageIcon,
  Maximize2,
  RotateCcw,
  ZoomIn,
  ZoomOut,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Button } from "@/components/ui/Button";
import { Modal } from "@/components/ui/Modal";
import { cn } from "@/components/ui/cn";

export type SafeMediaKind = "PDF" | "IMAGE" | "VIDEO_UPLOAD" | "VIDEO_YOUTUBE";

export interface SafeMediaViewerProps {
  kind: SafeMediaKind;
  /** Internal application route such as /api/school-media/<id> or /api/public-assets/<id> */
  mediaUrl?: string | null;
  /** Validated 11-char YouTube video ID when kind === 'VIDEO_YOUTUBE' */
  youtubeVideoId?: string | null;
  title?: string;
  fileName?: string;
  className?: string;
}

const SAFE_INTERNAL_MEDIA_RE = /^\/api\/(?:school-media|public-assets|admin-media)\/[A-Za-z0-9_-]+(?:\?.*)?$/;
const SAFE_YOUTUBE_ID_RE = /^[A-Za-z0-9_-]{11}$/;

function isSafeInternalUrl(url: string | null | undefined): url is string {
  return typeof url === "string" && SAFE_INTERNAL_MEDIA_RE.test(url.trim());
}

export function SafeMediaViewer({
  kind,
  mediaUrl,
  youtubeVideoId,
  title,
  fileName,
  className,
}: SafeMediaViewerProps) {
  const { t } = useLanguage();
  const [lightboxOpen, setLightboxOpen] = useState(false);
  const [zoom, setZoom] = useState(1);

  const safeUrl = isSafeInternalUrl(mediaUrl) ? mediaUrl.trim() : null;
  const safeYoutubeId =
    youtubeVideoId && SAFE_YOUTUBE_ID_RE.test(youtubeVideoId.trim())
      ? youtubeVideoId.trim()
      : null;

  // 1. Clean privacy-enhanced YouTube embed
  if (kind === "VIDEO_YOUTUBE") {
    if (!safeYoutubeId) {
      return (
        <div className="rounded-lg border border-hairline bg-surface-subtle p-4 text-sm text-ink-secondary">
          {t("वीडियो लिंक उपलब्ध नहीं है।", "Video link is unavailable.")}
        </div>
      );
    }

    return (
      <div className={cn("overflow-hidden rounded-paper border border-hairline bg-slate-950", className)}>
        <div className="relative aspect-video w-full">
          <iframe
            src={`https://www.youtube-nocookie.com/embed/${safeYoutubeId}?rel=0&modestbranding=1`}
            title={title ?? t("कक्षा वीडियो", "Classroom Video")}
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowFullScreen
            loading="lazy"
            referrerPolicy="strict-origin-when-cross-origin"
            className="absolute inset-0 h-full w-full border-0"
          />
        </div>
      </div>
    );
  }

  if (!safeUrl) {
    return (
      <div className="rounded-lg border border-hairline bg-surface-subtle p-4 text-sm text-ink-secondary">
        {t("फ़ाइल उपलब्ध नहीं है।", "Attachment is currently unavailable.")}
      </div>
    );
  }

  // 2. Zoomable Image + Lightbox Modal
  if (kind === "IMAGE") {
    return (
      <>
        <div
          className={cn(
            "group relative overflow-hidden rounded-paper border border-hairline bg-surface-subtle",
            className
          )}
        >
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={safeUrl}
            alt={title ?? fileName ?? t("अध्ययन चित्र", "Study image")}
            loading="lazy"
            onClick={() => {
              setZoom(1);
              setLightboxOpen(true);
            }}
            className="max-h-[420px] w-full object-contain cursor-zoom-in bg-canvas"
          />
          <div className="flex items-center justify-between gap-2 px-3 py-2 border-t border-hairline bg-surface text-xs text-ink-secondary">
            <span className="inline-flex items-center gap-1.5 truncate">
              <ImageIcon className="h-3.5 w-3.5 text-indigo-ink shrink-0" />
              <span className="truncate">{title ?? fileName ?? t("चित्र", "Image")}</span>
            </span>
            <Button
              size="sm"
              variant="ghost"
              onClick={() => {
                setZoom(1);
                setLightboxOpen(true);
              }}
              leftIcon={<Maximize2 className="h-3.5 w-3.5" />}
            >
              {t("बड़ा देखें", "Zoom")}
            </Button>
          </div>
        </div>

        <Modal
          open={lightboxOpen}
          onClose={() => setLightboxOpen(false)}
          size="xl"
          title={title ?? fileName ?? t("चित्र दृश्य", "Image Preview")}
          footer={
            <div className="flex w-full flex-wrap items-center justify-between gap-2">
              <div className="flex items-center gap-1.5">
                <Button
                  size="sm"
                  variant="secondary"
                  onClick={() => setZoom((z) => Math.max(0.5, Number((z - 0.25).toFixed(2))))}
                  leftIcon={<ZoomOut className="h-4 w-4" />}
                >
                  -
                </Button>
                <span className="text-xs font-semibold text-ink-secondary min-w-[46px] text-center">
                  {Math.round(zoom * 100)}%
                </span>
                <Button
                  size="sm"
                  variant="secondary"
                  onClick={() => setZoom((z) => Math.min(3, Number((z + 0.25).toFixed(2))))}
                  leftIcon={<ZoomIn className="h-4 w-4" />}
                >
                  +
                </Button>
                <Button
                  size="sm"
                  variant="ghost"
                  onClick={() => setZoom(1)}
                  leftIcon={<RotateCcw className="h-3.5 w-3.5" />}
                >
                  {t("रीसेट", "Reset")}
                </Button>
              </div>
              <a
                href={safeUrl}
                download={fileName ?? "image"}
                className="inline-flex items-center gap-1.5 rounded-lg border border-hairline bg-surface px-3 py-2 text-xs font-semibold text-ink hover:bg-surface-subtle"
              >
                <Download className="h-3.5 w-3.5" />
                {t("डाउनलोड", "Download")}
              </a>
            </div>
          }
        >
          <div className="overflow-auto max-h-[68dvh] flex items-center justify-center bg-canvas rounded-lg border border-hairline p-2">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={safeUrl}
              alt={title ?? fileName ?? t("अध्ययन चित्र", "Study image")}
              style={{ transform: `scale(${zoom})`, transformOrigin: "center center" }}
              className="transition-transform duration-150 max-w-full"
            />
          </div>
        </Modal>
      </>
    );
  }

  // 3. Streamed School Video (HTML5 Range streaming)
  if (kind === "VIDEO_UPLOAD") {
    return (
      <div className={cn("overflow-hidden rounded-paper border border-hairline bg-slate-950", className)}>
        <video
          src={safeUrl}
          controls
          playsInline
          preload="metadata"
          controlsList="nodownload"
          className="w-full max-h-[460px] bg-black"
        >
          {t(
            "आपका ब्राउज़र इस वीडियो को चलाने में समर्थ नहीं है।",
            "Your browser does not support embedded video playback."
          )}
        </video>
        <div className="flex items-center justify-between gap-2 px-3.5 py-2 bg-surface border-t border-hairline text-xs text-ink-secondary">
          <span className="inline-flex items-center gap-1.5 truncate">
            <Film className="h-3.5 w-3.5 text-indigo-ink shrink-0" />
            <span className="truncate">{title ?? fileName ?? t("कक्षा वीडियो", "Lesson Video")}</span>
          </span>
        </div>
      </div>
    );
  }

  // 4. Clean PDF Viewer (<object> embed + clean fallback + download)
  return (
    <div className={cn("overflow-hidden rounded-paper border border-hairline bg-surface", className)}>
      <div className="flex flex-wrap items-center justify-between gap-2 px-4 py-2.5 border-b border-hairline bg-surface-subtle">
        <span className="inline-flex items-center gap-2 text-sm font-semibold text-ink truncate">
          <FileText className="h-4 w-4 text-crimson-ink shrink-0" />
          <span className="truncate">{title ?? fileName ?? t("पीडीएफ दस्तावेज़", "PDF Document")}</span>
        </span>
        <div className="flex items-center gap-2">
          <a
            href={safeUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1.5 rounded-lg border border-hairline bg-surface px-3 py-1.5 text-xs font-semibold text-ink hover:bg-canvas transition-colors"
          >
            <ExternalLink className="h-3.5 w-3.5" />
            {t("पूरी स्क्रीन", "Open")}
          </a>
          <a
            href={safeUrl}
            download={fileName ?? "document.pdf"}
            className="inline-flex items-center gap-1.5 rounded-lg bg-indigo-academic text-white px-3 py-1.5 text-xs font-semibold hover:bg-indigo-academic-hover transition-colors"
          >
            <Download className="h-3.5 w-3.5" />
            {t("डाउनलोड", "Download")}
          </a>
        </div>
      </div>

      <object
        data={safeUrl}
        type="application/pdf"
        className="w-full h-[460px] sm:h-[540px] bg-canvas"
      >
        <div className="p-6 text-center space-y-3">
          <p className="text-sm text-ink-secondary">
            {t(
              "आपके फ़ोन ब्राउज़र में पीडीएफ सीधे नहीं खुला। कृपया नीचे दिए गए बटन से खोलें या डाउनलोड करें।",
              "Your mobile browser prefers opening PDFs externally. Use the button below to view or download."
            )}
          </p>
          <a
            href={safeUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-academic text-white px-4 py-2.5 text-sm font-semibold"
          >
            <FileText className="h-4 w-4" />
            {t("पीडीएफ खोलें", "Open PDF")}
          </a>
        </div>
      </object>
    </div>
  );
}
