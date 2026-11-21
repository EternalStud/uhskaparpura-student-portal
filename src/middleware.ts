import { NextResponse, type NextRequest } from "next/server";

const PROD_COOKIE_NAME = "__Host-sob_session";
const DEV_COOKIE_NAME = "sob_session";

function hasSessionCookie(request: NextRequest): boolean {
  return Boolean(
    request.cookies.get(PROD_COOKIE_NAME)?.value ||
      request.cookies.get(DEV_COOKIE_NAME)?.value
  );
}

function applyNoStoreHeaders(response: NextResponse): NextResponse {
  response.headers.set(
    "Cache-Control",
    "no-store, no-cache, must-revalidate, private"
  );
  response.headers.set("Pragma", "no-cache");
  response.headers.set("Expires", "0");
  response.headers.set("Vary", "Cookie");
  return response;
}

function getLoginRedirectForPath(pathname: string): string | null {
  if (pathname === "/student" || pathname.startsWith("/student/")) {
    return "/login/student";
  }
  if (pathname === "/teacher" || pathname.startsWith("/teacher/")) {
    return "/login/teacher";
  }
  if (pathname === "/school" || pathname.startsWith("/school/")) {
    return "/login/school";
  }
  if (
    (pathname === "/super-admin" || pathname.startsWith("/super-admin/")) &&
    pathname !== "/super-admin/login" &&
    !pathname.startsWith("/super-admin/login/")
  ) {
    return "/super-admin/login";
  }
  return null;
}

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Protected portal pages: redirect immediately if no session cookie is present.
  // Full DB-backed token + role + token_version verification runs inside Server Components & API routes.
  const loginTarget = getLoginRedirectForPath(pathname);
  if (loginTarget && !hasSessionCookie(request)) {
    const loginUrl = request.nextUrl.clone();
    loginUrl.pathname = loginTarget;
    loginUrl.searchParams.set("next", pathname);
    return applyNoStoreHeaders(NextResponse.redirect(loginUrl));
  }

  // Enforce strict anti-bfcache headers on all protected portal routes & private API endpoints
  // so shared Bihar school ICT Lab PCs never display a previous user's page on Back/Forward.
  const response = NextResponse.next();
  return applyNoStoreHeaders(response);
}

export const config = {
  matcher: [
    "/student/:path*",
    "/teacher/:path*",
    "/school/:path*",
    "/super-admin/:path*",
    "/api/auth/:path*",
    "/api/school-media/:path*",
    "/api/admin-media/:path*",
    "/api/student/:path*",
    "/api/teacher/:path*",
    "/api/school/:path*",
    "/api/super-admin/:path*",
    "/api/notes/:path*",
    "/api/practice/:path*",
    "/api/collab/:path*",
    "/api/exams/:path*",
    "/api/media/:path*",
  ],
};
