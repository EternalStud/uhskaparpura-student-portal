"use client";

import React, { useState } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import {
  ArrowLeftRight,
  LogOut,
  Menu,
  X,
} from "lucide-react";
import { useLanguage } from "@/components/providers/LanguageProvider";
import {
  broadcastAuthEvent,
  clearUserScopedBrowserState,
} from "@/components/providers/SessionSyncListener";
import { BrandMark } from "@/components/ui/BrandMark";
import { LanguageToggle, ThemeToggle } from "@/components/ui/LanguageToggle";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { useToast } from "@/components/ui/Toast";
import { cn } from "@/components/ui/cn";
import type { UserRole } from "@/types/database";

export interface RoleNavItem {
  href: string;
  labelHi: string;
  labelEn: string;
  icon: React.ReactNode;
  badge?: string | number;
  exact?: boolean;
}

export interface RoleShellProps {
  role: UserRole;
  userName: string;
  userSubtitle?: string;
  schoolName?: string | null;
  navItems: RoleNavItem[];
  canSwitchWorkspace?: boolean;
  activeWorkspace?: "TEACHER" | "SCHOOL_ADMIN";
  headerActions?: React.ReactNode;
  children: React.ReactNode;
}

function getLoginPathForRole(role: UserRole): string {
  switch (role) {
    case "student":
      return "/login/student";
    case "teacher":
      return "/login/teacher";
    case "school_admin":
      return "/login/school";
    case "super_admin":
      return "/super-admin/login";
  }
}

export function RoleShell({
  role,
  userName,
  userSubtitle,
  schoolName,
  navItems,
  canSwitchWorkspace = false,
  activeWorkspace,
  headerActions,
  children,
}: RoleShellProps) {
  const pathname = usePathname();
  const router = useRouter();
  const { t } = useLanguage();
  const toast = useToast();

  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [signingOut, setSigningOut] = useState(false);
  const [switchingWorkspace, setSwitchingWorkspace] = useState(false);

  const isNavActive = (item: RoleNavItem): boolean => {
    if (item.exact) return pathname === item.href;
    return pathname === item.href || pathname.startsWith(`${item.href}/`);
  };

  const handleSignOut = async () => {
    setSigningOut(true);
    const loginPath = getLoginPathForRole(role);

    try {
      await fetch("/api/auth/logout", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({}),
      });
    } catch {
      // Proceed with local cleanup even if network drops on shared PC
    } finally {
      clearUserScopedBrowserState();
      broadcastAuthEvent("LOGOUT", loginPath);
      window.location.replace(loginPath);
    }
  };

  const handleSwitchWorkspace = async () => {
    if (!canSwitchWorkspace || switchingWorkspace) return;
    const targetWorkspace: "TEACHER" | "SCHOOL_ADMIN" =
      activeWorkspace === "SCHOOL_ADMIN" ? "TEACHER" : "SCHOOL_ADMIN";

    setSwitchingWorkspace(true);
    try {
      const res = await fetch("/api/auth/switch-workspace", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({ targetWorkspace }),
      });
      const data = (await res.json()) as {
        ok?: boolean;
        redirectTo?: string;
        error?: string;
      };
      if (!res.ok || !data.ok) {
        toast.error(
          t("वर्कस्पेस बदला नहीं जा सका", "Unable to switch workspace"),
          data.error
        );
        return;
      }
      router.push(data.redirectTo || (targetWorkspace === "SCHOOL_ADMIN" ? "/school" : "/teacher"));
      router.refresh();
    } catch {
      toast.error(t("नेटवर्क त्रुटि हुई", "Network error occurred"));
    } finally {
      setSwitchingWorkspace(false);
    }
  };

  const roleBadgeLabel =
    role === "student"
      ? t("विद्यार्थी", "Student")
      : role === "teacher"
      ? t("शिक्षक", "Teacher")
      : role === "school_admin"
      ? t("विद्यालय व्यवस्थापक", "School Admin")
      : t("केंद्रीय डेस्क", "Editorial Desk");

  const mobileBottomItems = navItems.slice(0, 5);

  return (
    <div className="min-h-dvh flex flex-col bg-canvas text-ink">
      {/* Sticky Editorial Topbar */}
      <header
        data-app-chrome="true"
        className="sticky top-0 z-30 border-b border-hairline bg-surface/95 backdrop-blur-sm no-print"
      >
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between gap-3 px-4 sm:px-6">
          <div className="flex items-center gap-2.5 min-w-0">
            <button
              type="button"
              onClick={() => setMobileMenuOpen(true)}
              aria-label={t("मेनू खोलें", "Open navigation menu")}
              className="inline-flex lg:hidden h-10 w-10 shrink-0 items-center justify-center rounded-lg border border-hairline bg-surface text-ink-secondary hover:bg-surface-subtle hover:text-ink"
            >
              <Menu className="h-5 w-5" aria-hidden="true" />
            </button>

            <Link
              href={navItems[0]?.href ?? "/"}
              className="min-w-0 focus-visible:rounded-lg"
            >
              <BrandMark
                size="sm"
                showTagline={false}
                schoolName={schoolName ?? undefined}
              />
            </Link>
          </div>

          <div className="flex items-center gap-2 shrink-0">
            {headerActions}

            {canSwitchWorkspace && (
              <Button
                variant="outline"
                size="sm"
                loading={switchingWorkspace}
                onClick={handleSwitchWorkspace}
                leftIcon={<ArrowLeftRight className="h-3.5 w-3.5" />}
                className="hidden md:inline-flex"
              >
                {activeWorkspace === "SCHOOL_ADMIN"
                  ? t("शिक्षक डेस्क", "Teacher View")
                  : t("विद्यालय व्यवस्थापक", "School Admin")}
              </Button>
            )}

            <LanguageToggle compact className="sm:hidden" />
            <LanguageToggle className="hidden sm:inline-flex" />
            <ThemeToggle />

            <Button
              variant="secondary"
              size="sm"
              loading={signingOut}
              onClick={handleSignOut}
              leftIcon={<LogOut className="h-4 w-4" />}
              title={t("खाता बदलें / लॉग आउट", "Switch Account / Sign Out")}
              className="hidden sm:inline-flex"
            >
              {t("लॉग आउट", "Sign Out")}
            </Button>
          </div>
        </div>
      </header>

      <div className="mx-auto flex w-full max-w-7xl flex-1">
        {/* Desktop Editorial Sidebar */}
        <aside
          data-app-chrome="true"
          className="hidden lg:flex lg:w-64 lg:shrink-0 lg:flex-col border-r border-hairline bg-surface/60 px-4 py-6 no-print"
        >
          <div className="mb-5 rounded-paper border border-hairline bg-surface p-3.5 shadow-paper">
            <div className="flex items-center justify-between gap-2">
              <Badge variant="indigo">{roleBadgeLabel}</Badge>
            </div>
            <p className="mt-2 text-sm font-bold text-ink leading-snug truncate">
              {userName}
            </p>
            {userSubtitle && (
              <p className="mt-0.5 text-xs text-ink-secondary truncate">
                {userSubtitle}
              </p>
            )}
          </div>

          <nav aria-label="Workspace navigation" className="flex-1 space-y-1">
            {navItems.map((item) => {
              const active = isNavActive(item);
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  aria-current={active ? "page" : undefined}
                  className={cn(
                    "flex items-center justify-between gap-2.5 rounded-lg px-3.5 py-2.5 text-sm font-semibold transition-colors min-h-[44px]",
                    active
                      ? "bg-indigo-soft text-indigo-ink border border-indigo-academic/20"
                      : "text-ink-secondary hover:bg-surface-subtle hover:text-ink border border-transparent"
                  )}
                >
                  <span className="flex items-center gap-2.5 min-w-0">
                    <span className="shrink-0">{item.icon}</span>
                    <span className="truncate">{t(item.labelHi, item.labelEn)}</span>
                  </span>
                  {item.badge !== undefined && (
                    <span className="rounded-full bg-amber-soft px-2 py-0.5 text-[11px] font-bold text-amber-ink">
                      {item.badge}
                    </span>
                  )}
                </Link>
              );
            })}
          </nav>

          <div className="mt-6 pt-4 border-t border-hairline space-y-2">
            {canSwitchWorkspace && (
              <Button
                variant="outline"
                size="sm"
                fullWidth
                loading={switchingWorkspace}
                onClick={handleSwitchWorkspace}
                leftIcon={<ArrowLeftRight className="h-4 w-4" />}
              >
                {activeWorkspace === "SCHOOL_ADMIN"
                  ? t("शिक्षक डेस्क पर जाएं", "Switch to Teacher")
                  : t("विद्यालय व्यवस्थापक डेस्क", "Switch to School Admin")}
              </Button>
            )}

            <Button
              variant="secondary"
              size="sm"
              fullWidth
              loading={signingOut}
              onClick={handleSignOut}
              leftIcon={<LogOut className="h-4 w-4" />}
            >
              {t("खाता बदलें / लॉग आउट", "Switch Account / Sign Out")}
            </Button>
          </div>
        </aside>

        {/* Main Workspace Canvas */}
        <main className="flex-1 min-w-0 px-4 py-6 sm:px-6 lg:px-8 pb-24 lg:pb-10">
          {children}
        </main>
      </div>

      {/* Mobile Slide-Over Drawer */}
      {mobileMenuOpen && (
        <div
          className="fixed inset-0 z-50 lg:hidden no-print"
          role="dialog"
          aria-modal="true"
          aria-label={t("नेविगेशन मेनू", "Navigation menu")}
        >
          <div
            className="fixed inset-0 bg-slate-950/45"
            onClick={() => setMobileMenuOpen(false)}
            aria-hidden="true"
          />
          <div className="fixed inset-y-0 left-0 flex w-72 max-w-[85vw] flex-col bg-surface border-r border-hairline shadow-modal p-4">
            <div className="flex items-center justify-between gap-2 pb-4 border-b border-hairline">
              <div className="min-w-0">
                <Badge variant="indigo">{roleBadgeLabel}</Badge>
                <p className="mt-1.5 text-sm font-bold text-ink truncate">
                  {userName}
                </p>
                {userSubtitle && (
                  <p className="text-xs text-ink-secondary truncate">
                    {userSubtitle}
                  </p>
                )}
              </div>
              <button
                type="button"
                onClick={() => setMobileMenuOpen(false)}
                aria-label={t("बंद करें", "Close menu")}
                className="inline-flex h-10 w-10 items-center justify-center rounded-lg text-ink-muted hover:bg-surface-subtle hover:text-ink"
              >
                <X className="h-5 w-5" aria-hidden="true" />
              </button>
            </div>

            <nav className="mt-4 flex-1 space-y-1 overflow-y-auto">
              {navItems.map((item) => {
                const active = isNavActive(item);
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={() => setMobileMenuOpen(false)}
                    className={cn(
                      "flex items-center justify-between gap-2.5 rounded-lg px-3.5 py-2.5 text-sm font-semibold min-h-[44px]",
                      active
                        ? "bg-indigo-soft text-indigo-ink"
                        : "text-ink-secondary hover:bg-surface-subtle hover:text-ink"
                    )}
                  >
                    <span className="flex items-center gap-2.5 min-w-0">
                      <span className="shrink-0">{item.icon}</span>
                      <span className="truncate">
                        {t(item.labelHi, item.labelEn)}
                      </span>
                    </span>
                    {item.badge !== undefined && (
                      <span className="rounded-full bg-amber-soft px-2 py-0.5 text-[11px] font-bold text-amber-ink">
                        {item.badge}
                      </span>
                    )}
                  </Link>
                );
              })}
            </nav>

            <div className="pt-4 border-t border-hairline space-y-2">
              {canSwitchWorkspace && (
                <Button
                  variant="outline"
                  size="sm"
                  fullWidth
                  loading={switchingWorkspace}
                  onClick={handleSwitchWorkspace}
                  leftIcon={<ArrowLeftRight className="h-4 w-4" />}
                >
                  {activeWorkspace === "SCHOOL_ADMIN"
                    ? t("शिक्षक डेस्क पर जाएं", "Switch to Teacher")
                    : t("विद्यालय व्यवस्थापक डेस्क", "Switch to School Admin")}
                </Button>
              )}

              <Button
                variant="secondary"
                size="sm"
                fullWidth
                loading={signingOut}
                onClick={handleSignOut}
                leftIcon={<LogOut className="h-4 w-4" />}
              >
                {t("खाता बदलें / लॉग आउट", "Switch Account / Sign Out")}
              </Button>
            </div>
          </div>
        </div>
      )}

      {/* Mobile Bottom Navigation Bar */}
      {mobileBottomItems.length > 0 && (
        <nav
          data-app-chrome="true"
          aria-label="Mobile navigation"
          className="fixed bottom-0 inset-x-0 z-30 flex lg:hidden border-t border-hairline bg-surface/95 backdrop-blur-sm no-print"
        >
          {mobileBottomItems.map((item) => {
            const active = isNavActive(item);
            return (
              <Link
                key={item.href}
                href={item.href}
                aria-current={active ? "page" : undefined}
                className={cn(
                  "flex-1 flex flex-col items-center justify-center gap-1 py-2 px-1 min-h-[56px] text-[11px] font-semibold transition-colors",
                  active ? "text-indigo-ink" : "text-ink-muted hover:text-ink"
                )}
              >
                <span className="shrink-0">{item.icon}</span>
                <span className="truncate max-w-full">
                  {t(item.labelHi, item.labelEn)}
                </span>
              </Link>
            );
          })}
        </nav>
      )}
    </div>
  );
}
