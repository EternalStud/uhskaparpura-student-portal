/**
 * India Standard Time (Asia/Kolkata, UTC+05:30) date & window helpers.
 * All daily streaks, weekly leaderboards (Monday IST reset), and scheduled
 * exam windows across Bihar schools MUST use these utilities rather than
 * server-local or UTC dates.
 */

export const IST_TIMEZONE = 'Asia/Kolkata';
const IST_OFFSET_MS = 5.5 * 60 * 60 * 1000;
const DAY_MS = 24 * 60 * 60 * 1000;

export interface IstDateParts {
  year: number;
  month: number; // 1-12
  day: number; // 1-31
  hour: number; // 0-23
  minute: number; // 0-59
  second: number; // 0-59
  /** 0 = Sunday, 1 = Monday, ..., 6 = Saturday */
  weekday: number;
}

const istPartsFormatter = new Intl.DateTimeFormat('en-GB', {
  timeZone: IST_TIMEZONE,
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  hour: '2-digit',
  minute: '2-digit',
  second: '2-digit',
  hourCycle: 'h23',
});

function toValidDate(input: Date | string | number): Date | null {
  if (input instanceof Date) {
    return Number.isNaN(input.getTime()) ? null : input;
  }
  const d = new Date(input);
  return Number.isNaN(d.getTime()) ? null : d;
}

function pad2(n: number): string {
  return String(n).padStart(2, '0');
}

/**
 * Extracts calendar and clock components strictly in Asia/Kolkata (IST).
 */
export function getIstDateParts(date: Date = new Date()): IstDateParts {
  const valid = toValidDate(date);
  if (!valid) {
    throw new RangeError('Invalid Date passed to getIstDateParts');
  }
  const parts = istPartsFormatter.formatToParts(valid);
  const lookup: Record<string, number> = {};
  for (const part of parts) {
    if (part.type !== 'literal') {
      lookup[part.type] = Number.parseInt(part.value, 10);
    }
  }
  const year = lookup.year;
  const month = lookup.month;
  const day = lookup.day;
  const hour = lookup.hour === 24 ? 0 : lookup.hour;
  const minute = lookup.minute;
  const second = lookup.second;
  const weekday = new Date(Date.UTC(year, month - 1, day)).getUTCDay();
  return { year, month, day, hour, minute, second, weekday };
}

/**
 * Returns today's calendar date in IST as ISO `YYYY-MM-DD`.
 */
export function getTodayIst(date: Date = new Date()): string {
  const { year, month, day } = getIstDateParts(date);
  return `${year}-${pad2(month)}-${pad2(day)}`;
}

/**
 * Returns the Monday start date (`YYYY-MM-DD`) of the ISO week containing
 * `date` in IST (Monday 00:00 IST -> Sunday 23:59:59 IST).
 */
export function getIstWeekStart(date: Date = new Date()): string {
  const { year, month, day, weekday } = getIstDateParts(date);
  // Convert 0=Sun..6=Sat to days since Monday (Mon=0, Tue=1, ..., Sun=6)
  const daysSinceMonday = weekday === 0 ? 6 : weekday - 1;
  const mondayUtc = new Date(Date.UTC(year, month - 1, day) - daysSinceMonday * DAY_MS);
  return `${mondayUtc.getUTCFullYear()}-${pad2(mondayUtc.getUTCMonth() + 1)}-${pad2(mondayUtc.getUTCDate())}`;
}

/**
 * Computes exact whole-day difference between two IST `YYYY-MM-DD` date strings
 * (returns `dateB - dateA` in days). Useful for streak continuity checks.
 */
export function diffIstDays(fromIsoDate: string, toIsoDate: string): number {
  const matchA = /^(\d{4})-(\d{2})-(\d{2})$/.exec(fromIsoDate.trim());
  const matchB = /^(\d{4})-(\d{2})-(\d{2})$/.exec(toIsoDate.trim());
  if (!matchA || !matchB) {
    throw new RangeError('Expected YYYY-MM-DD IST date strings');
  }
  const utcA = Date.UTC(Number(matchA[1]), Number(matchA[2]) - 1, Number(matchA[3]));
  const utcB = Date.UTC(Number(matchB[1]), Number(matchB[2]) - 1, Number(matchB[3]));
  return Math.round((utcB - utcA) / DAY_MS);
}

/**
 * Formats a timestamp strictly in Asia/Kolkata (IST) for UI/reports.
 */
export function formatIstDateTime(
  input: Date | string | number,
  options: {
    lang?: 'HI' | 'EN';
    includeSeconds?: boolean;
    dateOnly?: boolean;
    includeZoneLabel?: boolean;
  } = {}
): string {
  const valid = toValidDate(input);
  if (!valid) return '';

  const lang = options.lang ?? 'EN';
  const locale = lang === 'HI' ? 'hi-IN' : 'en-IN';
  const formatOpts: Intl.DateTimeFormatOptions = options.dateOnly
    ? {
        timeZone: IST_TIMEZONE,
        day: '2-digit',
        month: 'short',
        year: 'numeric',
      }
    : {
        timeZone: IST_TIMEZONE,
        day: '2-digit',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        ...(options.includeSeconds ? { second: '2-digit' } : {}),
        hour12: true,
      };

  const formatted = new Intl.DateTimeFormat(locale, formatOpts).format(valid);
  if (!options.dateOnly && options.includeZoneLabel !== false) {
    return `${formatted} IST`;
  }
  return formatted;
}

/**
 * Formats a date-only string strictly in IST.
 */
export function formatIstDate(input: Date | string | number, lang: 'HI' | 'EN' = 'EN'): string {
  return formatIstDateTime(input, { lang, dateOnly: true, includeZoneLabel: false });
}

/**
 * Checks whether `now` falls inclusively within `[startsAt, endsAt]`.
 * Fails closed (`false`) if either provided boundary is an unparseable timestamp
 * or if `startsAt > endsAt`.
 */
export function isWithinWindow(
  startsAt: Date | string | number | null | undefined,
  endsAt: Date | string | number | null | undefined,
  now: Date = new Date()
): boolean {
  const nowDate = toValidDate(now);
  if (!nowDate) return false;
  const nowMs = nowDate.getTime();

  let startMs: number | null = null;
  let endMs: number | null = null;

  if (startsAt !== null && startsAt !== undefined && startsAt !== '') {
    const parsed = toValidDate(startsAt);
    if (!parsed) return false;
    startMs = parsed.getTime();
  }

  if (endsAt !== null && endsAt !== undefined && endsAt !== '') {
    const parsed = toValidDate(endsAt);
    if (!parsed) return false;
    endMs = parsed.getTime();
  }

  if (startMs !== null && endMs !== null && startMs > endMs) {
    return false;
  }
  if (startMs !== null && nowMs < startMs) {
    return false;
  }
  if (endMs !== null && nowMs > endMs) {
    return false;
  }
  return true;
}

/**
 * Converts an IST calendar date (`YYYY-MM-DD`) into exact UTC ISO start/end
 * timestamps suitable for PostgreSQL `TIMESTAMPTZ` range queries.
 */
export function getIstDayBoundsUtc(istDateStr: string = getTodayIst()): {
  startIso: string;
  endIso: string;
} {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(istDateStr.trim());
  if (!match) {
    throw new RangeError(`Invalid IST date string: ${istDateStr}`);
  }
  const midnightUtcIfUtc = Date.UTC(Number(match[1]), Number(match[2]) - 1, Number(match[3]));
  const startMs = midnightUtcIfUtc - IST_OFFSET_MS;
  const endMs = startMs + DAY_MS - 1;
  return {
    startIso: new Date(startMs).toISOString(),
    endIso: new Date(endMs).toISOString(),
  };
}

/**
 * Returns the Bihar Board (BSEB) academic session label (`YYYY-YY`), which
 * runs April 1 -> March 31 in IST (e.g. Nov 2026 -> `'2026-27'`).
 */
export function getCurrentAcademicYear(date: Date = new Date()): string {
  const { year, month } = getIstDateParts(date);
  const startYear = month >= 4 ? year : year - 1;
  const endYearShort = String((startYear + 1) % 100).padStart(2, '0');
  return `${startYear}-${endYearShort}`;
}
