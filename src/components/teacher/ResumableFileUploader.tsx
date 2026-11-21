"use client";

import React, { useRef, useState } from "react";
import {
  AlertCircle,
  CheckCircle2,
  FileCheck2,
  Loader2,
  Trash2,
  UploadCloud,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import { Button } from "@/components/ui/Button";
import { cn } from "@/components/ui/cn";

export type UploadPurpose = "MATERIAL" | "DOUBT_ANSWER" | "EDITORIAL_SUBMISSION";

export interface UploadedFileResult {
  mediaObjectId: string;
  fileName: string;
  mimeType: string;
  sizeBytes: number;
}

export interface ResumableFileUploaderProps {
  purpose: UploadPurpose;
  accept: string;
  allowedMimes: ReadonlyArray<string>;
  maxSizeMb: number;
  labelHi: string;
  labelEn: string;
  hintHi?: string;
  hintEn?: string;
  value: UploadedFileResult | null;
  onUploaded: (result: UploadedFileResult | null) => void;
  disabled?: boolean;
  className?: string;
}

function formatBytes(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(2)} MB`;
}

function inferMimeFromFilename(file: File): string {
  if (file.type && file.type.trim().length > 0) {
    return file.type.trim().toLowerCase();
  }
  const lower = file.name.toLowerCase();
  if (lower.endsWith(".pdf")) return "application/pdf";
  if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
  if (lower.endsWith(".png")) return "image/png";
  if (lower.endsWith(".webp")) return "image/webp";
  if (lower.endsWith(".mp4")) return "video/mp4";
  if (lower.endsWith(".webm")) return "video/webm";
  if (lower.endsWith(".docx")) {
    return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
  }
  if (lower.endsWith(".xlsx")) {
    return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
  }
  return "";
}

export function ResumableFileUploader({
  purpose,
  accept,
  allowedMimes,
  maxSizeMb,
  labelHi,
  labelEn,
  hintHi,
  hintEn,
  value,
  onUploaded,
  disabled = false,
  className,
}: ResumableFileUploaderProps) {
  const { t } = useLanguage();
  const inputRef = useRef<HTMLInputElement | null>(null);

  const [phase, setPhase] = useState<"idle" | "preparing" | "uploading" | "verifying">("idle");
  const [progressPct, setProgressPct] = useState(0);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  const isBusy = phase !== "idle";

  const handleFileChange = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    // Reset input value so selecting the same file again after clearing triggers onChange
    event.target.value = "";
    if (!file) return;

    setErrorMsg(null);
    const mimeType = inferMimeFromFilename(file);

    if (!mimeType || !allowedMimes.includes(mimeType)) {
      setErrorMsg(
        t(
          "यह फ़ाइल प्रारूप यहाँ समर्थित नहीं है। कृपया स्वीकृत फ़ाइल चुनें।",
          "This file format is not supported here. Please select an approved file type."
        )
      );
      return;
    }

    const maxBytes = maxSizeMb * 1024 * 1024;
    if (file.size <= 0 || file.size > maxBytes) {
      setErrorMsg(
        t(
          `फ़ाइल का आकार ${maxSizeMb} MB से कम होना चाहिए।`,
          `File size must be under ${maxSizeMb} MB.`
        )
      );
      return;
    }

    setPhase("preparing");
    setProgressPct(5);

    try {
      // 1. Request single-use secure upload session
      const sessionRes = await fetch("/api/media/upload-session", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          fileName: file.name,
          mimeType,
          sizeBytes: file.size,
          purpose,
        }),
      });

      const sessionJson = (await sessionRes.json()) as {
        mediaObjectId?: string;
        uploadUrl?: string;
        sanitizedFileName?: string;
        error?: string;
      };

      if (!sessionRes.ok || !sessionJson.mediaObjectId || !sessionJson.uploadUrl) {
        throw new Error(
          sessionJson.error ||
            t(
              "फ़ाइल अपलोड शुरू नहीं हो सका। कृपया पुनः प्रयास करें।",
              "Could not start file upload. Please try again."
            )
        );
      }

      // 2. Direct resumable PUT upload with smooth progress updates
      setPhase("uploading");
      setProgressPct(10);

      const driveFileId = await new Promise<string>((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open("PUT", sessionJson.uploadUrl!, true);
        xhr.setRequestHeader("Content-Type", mimeType);

        xhr.upload.onprogress = (ev) => {
          if (ev.lengthComputable && ev.total > 0) {
            const pct = Math.min(92, Math.max(12, Math.round((ev.loaded / ev.total) * 85) + 8));
            setProgressPct(pct);
          }
        };

        xhr.onerror = () => {
          reject(
            new Error(
              t(
                "नेटवर्क रुकावट के कारण अपलोड पूरा नहीं हो सका। कृपया पुनः प्रयास करें।",
                "Upload was interrupted by a network issue. Please try again."
              )
            )
          );
        };

        xhr.onload = () => {
          if (xhr.status >= 200 && xhr.status < 300) {
            try {
              const payload = JSON.parse(xhr.responseText) as { id?: string };
              if (payload.id) {
                resolve(payload.id);
                return;
              }
            } catch {
              // Fall through to error
            }
            reject(
              new Error(
                t(
                  "अपलोड की पुष्टि नहीं हो सकी। कृपया पुनः प्रयास करें।",
                  "Could not confirm uploaded file identifier. Please retry."
                )
              )
            );
          } else {
            reject(
              new Error(
                t(
                  "फ़ाइल अपलोड असफल रहा। कृपया कुछ देर बाद पुनः प्रयास करें।",
                  "File upload failed. Please try again in a moment."
                )
              )
            );
          }
        };

        xhr.send(file);
      });

      // 3. Server-side security & format verification
      setPhase("verifying");
      setProgressPct(96);

      const finalizeRes = await fetch("/api/media/finalize", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({
          mediaObjectId: sessionJson.mediaObjectId,
          driveFileId,
        }),
      });

      const finalizeJson = (await finalizeRes.json()) as {
        ok?: boolean;
        mediaObjectId?: string;
        mimeType?: string;
        sizeBytes?: number;
        error?: string;
      };

      if (!finalizeRes.ok || !finalizeJson.ok || !finalizeJson.mediaObjectId) {
        throw new Error(
          finalizeJson.error ||
            t(
              "फ़ाइल की सुरक्षा जाँच पूरी नहीं हो सकी। कृपया सही प्रारूप की फ़ाइल अपलोड करें।",
              "File verification failed. Please upload a valid, uncorrupted file."
            )
        );
      }

      setProgressPct(100);
      onUploaded({
        mediaObjectId: finalizeJson.mediaObjectId,
        fileName: sessionJson.sanitizedFileName || file.name,
        mimeType: finalizeJson.mimeType || mimeType,
        sizeBytes: finalizeJson.sizeBytes || file.size,
      });
    } catch (err) {
      setErrorMsg(
        err instanceof Error
          ? err.message
          : t("फ़ाइल अपलोड नहीं हो सकी।", "Could not upload file.")
      );
      onUploaded(null);
    } finally {
      setPhase("idle");
      setProgressPct(0);
    }
  };

  return (
    <div className={cn("space-y-2", className)}>
      <input
        ref={inputRef}
        type="file"
        accept={accept}
        disabled={disabled || isBusy}
        onChange={handleFileChange}
        className="sr-only"
      />

      {value ? (
        <div className="flex items-center justify-between gap-3 rounded-paper border border-emerald-mastery/35 bg-emerald-soft px-4 py-3">
          <div className="flex items-center gap-3 min-w-0">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-surface border border-emerald-mastery/25 text-emerald-ink">
              <FileCheck2 className="h-5 w-5" aria-hidden="true" />
            </div>
            <div className="min-w-0">
              <p className="text-sm font-semibold text-ink truncate">{value.fileName}</p>
              <p className="text-xs text-emerald-ink flex items-center gap-1.5">
                <CheckCircle2 className="h-3.5 w-3.5 shrink-0" aria-hidden="true" />
                <span>
                  {t("सत्यापित एवं तैयार", "Verified & ready")} · {formatBytes(value.sizeBytes)}
                </span>
              </p>
            </div>
          </div>

          <Button
            variant="ghost"
            size="sm"
            disabled={disabled || isBusy}
            onClick={() => {
              setErrorMsg(null);
              onUploaded(null);
            }}
            leftIcon={<Trash2 className="h-4 w-4 text-crimson-ink" />}
          >
            {t("हटाएँ", "Remove")}
          </Button>
        </div>
      ) : (
        <button
          type="button"
          disabled={disabled || isBusy}
          onClick={() => inputRef.current?.click()}
          className={cn(
            "w-full rounded-paper border-2 border-dashed border-hairline-strong bg-surface-subtle/50 px-5 py-6 text-center transition-colors",
            "hover:border-indigo-academic/60 hover:bg-indigo-soft focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-indigo-academic/30",
            "disabled:opacity-60 disabled:cursor-not-allowed"
          )}
        >
          <div className="mx-auto flex h-11 w-11 items-center justify-center rounded-full bg-surface border border-hairline text-indigo-ink shadow-paper">
            {isBusy ? (
              <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />
            ) : (
              <UploadCloud className="h-5 w-5" aria-hidden="true" />
            )}
          </div>

          <p className="mt-3 text-sm font-semibold text-ink">
            {phase === "preparing"
              ? t("अपलोड तैयार किया जा रहा है...", "Preparing secure upload...")
              : phase === "uploading"
              ? t(`अपलोड हो रहा है... ${progressPct}%`, `Uploading file... ${progressPct}%`)
              : phase === "verifying"
              ? t("फ़ाइल की सुरक्षा जाँच हो रही है...", "Verifying file integrity...")
              : t(labelHi, labelEn)}
          </p>

          {(hintHi || hintEn) && !isBusy && (
            <p className="mt-1 text-xs text-ink-secondary">
              {t(hintHi ?? "", hintEn ?? "")}
            </p>
          )}

          {isBusy && (
            <div className="mx-auto mt-3 h-2 w-full max-w-xs overflow-hidden rounded-full bg-surface border border-hairline">
              <div
                className="h-full bg-indigo-academic transition-all duration-200"
                style={{ width: `${progressPct}%` }}
              />
            </div>
          )}
        </button>
      )}

      {errorMsg && (
        <div
          role="alert"
          className="flex items-start gap-2 rounded-lg border border-crimson-alert/30 bg-crimson-soft px-3.5 py-2.5 text-xs font-medium text-crimson-ink"
        >
          <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" aria-hidden="true" />
          <span>{errorMsg}</span>
        </div>
      )}
    </div>
  );
}
