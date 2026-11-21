"use client";

import { useEffect } from "react";

export type AuthSyncEventType = "LOGOUT" | "USER_SWITCH" | "SESSION_EXPIRED";

export interface AuthSyncPayload {
  type: AuthSyncEventType;
  redirectTo?: string;
  ts: number;
}

const CHANNEL_NAME = "sob-auth";
const STORAGE_FALLBACK_KEY = "sob-auth-sync-event";

const USER_SCOPED_PREFIXES = [
  "sob_draft_",
  "sob_exam_",
  "sob_practice_",
  "sob_user_",
  "sob_doubt_draft",
  "sob_session_",
];

/**
 * Clears all sessionStorage and user-scoped draft keys from localStorage
 * without wiping harmless device UI preferences (language / night study mode).
 */
export function clearUserScopedBrowserState(): void {
  try {
    window.sessionStorage.clear();
  } catch {
    // Ignore restricted storage errors
  }

  try {
    const keysToRemove: string[] = [];
    for (let i = 0; i < window.localStorage.length; i += 1) {
      const key = window.localStorage.key(i);
      if (
        key &&
        USER_SCOPED_PREFIXES.some((prefix) => key.startsWith(prefix))
      ) {
        keysToRemove.push(key);
      }
    }
    for (const key of keysToRemove) {
      window.localStorage.removeItem(key);
    }
  } catch {
    // Ignore restricted storage errors
  }
}

/**
 * Broadcasts a cross-tab auth state change (logout / student switch) so
 * other open tabs on a shared school ICT Lab PC clear drafts & redirect immediately.
 */
export function broadcastAuthEvent(
  type: AuthSyncEventType,
  redirectTo = "/login/student"
): void {
  if (typeof window === "undefined") return;

  const payload: AuthSyncPayload = {
    type,
    redirectTo,
    ts: Date.now(),
  };

  try {
    if ("BroadcastChannel" in window) {
      const channel = new BroadcastChannel(CHANNEL_NAME);
      channel.postMessage(payload);
      channel.close();
    }
  } catch {
    // Fallback below handles environments without BroadcastChannel
  }

  try {
    window.localStorage.setItem(STORAGE_FALLBACK_KEY, JSON.stringify(payload));
    window.localStorage.removeItem(STORAGE_FALLBACK_KEY);
  } catch {
    // Ignore storage write errors
  }
}

const PROTECTED_PATH_PREFIXES = [
  "/student",
  "/teacher",
  "/school",
  "/super-admin",
  "/exam",
];

/**
 * Shared ICT Lab PC multi-tab session guard:
 * - Listens to BroadcastChannel('sob-auth') + localStorage storage events.
 * - Immediately wipes sessionStorage & user-scoped drafts and redirects on logout/switch.
 * - Reloads protected pages if restored from browser back-forward cache (bfcache).
 */
export function SessionSyncListener() {
  useEffect(() => {
    const handleSyncPayload = (payload: AuthSyncPayload | null) => {
      if (!payload || typeof payload.type !== "string") return;
      if (
        payload.type === "LOGOUT" ||
        payload.type === "USER_SWITCH" ||
        payload.type === "SESSION_EXPIRED"
      ) {
        clearUserScopedBrowserState();
        const target =
          payload.redirectTo && payload.redirectTo.startsWith("/")
            ? payload.redirectTo
            : "/login/student";

        // Avoid redundant redirect loop if already on target login page
        if (window.location.pathname !== target) {
          window.location.replace(target);
        }
      }
    };

    let channel: BroadcastChannel | null = null;
    if ("BroadcastChannel" in window) {
      try {
        channel = new BroadcastChannel(CHANNEL_NAME);
        channel.onmessage = (event: MessageEvent<AuthSyncPayload>) => {
          handleSyncPayload(event.data);
        };
      } catch {
        channel = null;
      }
    }

    const onStorage = (event: StorageEvent) => {
      if (event.key !== STORAGE_FALLBACK_KEY || !event.newValue) return;
      try {
        const parsed = JSON.parse(event.newValue) as AuthSyncPayload;
        handleSyncPayload(parsed);
      } catch {
        // Ignore malformed events
      }
    };

    const onPageShow = (event: PageTransitionEvent) => {
      if (!event.persisted) return;
      const isProtected = PROTECTED_PATH_PREFIXES.some((prefix) =>
        window.location.pathname.startsWith(prefix)
      );
      if (isProtected) {
        window.location.reload();
      }
    };

    window.addEventListener("storage", onStorage);
    window.addEventListener("pageshow", onPageShow);

    return () => {
      window.removeEventListener("storage", onStorage);
      window.removeEventListener("pageshow", onPageShow);
      if (channel) {
        channel.close();
      }
    };
  }, []);

  return null;
}
