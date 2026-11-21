import zlib from 'node:zlib';
import * as XLSX from 'xlsx';
import { hashIndianMobile } from '@/lib/auth/password';
import type { ClassNum, StudentStream, SyncConflictItem } from '@/types/database';

/**
 * Calibrated Bihar e-Shikshakosh Excel parser, security guard, dry-run diff engine,
 * and formula-injection-safe marksheet exporter.
 *
 * Security & privacy invariants:
 * 1. Zip-Bomb Guard inspects raw ZIP Central & Local File Headers BEFORE SheetJS runs
 *    (uncompressed <= 25 MB, rows <= 15,000, cols <= 50, zero Zip Slip paths).
 * 2. Aadhaar No and Social Category columns are EXPLICITLY DISCARDED in memory —
 *    NEVER returned, logged, or persisted anywhere.
 * 3. Teacher Mobile No is converted to `mobileLast4` + keyed HMAC `mobileHash` —
 *    plaintext mobile numbers are NEVER returned or persisted.
 * 4. Detects & blocks Excel scientific notation corruption (e.g. `2.02E+14`) on Student/Teacher IDs.
 * 5. Blocks silent cross-school hijack of active students/teachers and blocks deactivating
 *    the last active School Admin.
 * 6. Neutralizes spreadsheet formula injection (`=`, `+`, `-`, `@`, `\t`, `\r`) on all exports.
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/excel/eshikshakosh.ts is strictly server-only.');
}

// =============================================================================
// CONSTANTS & LIMITS
// =============================================================================

export const MAX_XLSX_COMPRESSED_BYTES = 15 * 1024 * 1024; // 15 MB upload cap
export const MAX_XLSX_UNCOMPRESSED_BYTES = 25 * 1024 * 1024; // 25 MB zip-bomb cap
export const MAX_XLSX_ZIP_ENTRIES = 250;
export const MAX_XLSX_ROWS = 15_000;
export const MAX_XLSX_COLS = 50;
const MAX_COMPRESSION_RATIO_LARGE = 100;
const RATIO_CHECK_MIN_UNCOMPRESSED = 5 * 1024 * 1024;

const ZIP_LOCAL_HEADER_SIG = 0x04034b50;
const ZIP_CENTRAL_HEADER_SIG = 0x02014b50;
const ZIP_EOCD_SIG = 0x06054b50;

const MONTH_NAME_MAP: Record<string, number> = {
  jan: 1,
  january: 1,
  feb: 2,
  february: 2,
  mar: 3,
  march: 3,
  apr: 4,
  april: 4,
  may: 5,
  jun: 6,
  june: 6,
  jul: 7,
  july: 7,
  aug: 8,
  august: 8,
  sep: 9,
  sept: 9,
  september: 9,
  oct: 10,
  october: 10,
  nov: 11,
  november: 11,
  dec: 12,
  december: 12,
};

// =============================================================================
// EXPORTED TYPES
// =============================================================================

export interface ZipSafetyReport {
  safe: boolean;
  reason?: string;
  entryCount: number;
  compressedBytes: number;
  uncompressedBytes: number;
}

export interface BepcBannerMeta {
  districtCode: string | null;
  districtName: string | null;
  blockCode: string | null;
  blockName: string | null;
  clusterCode: string | null;
  clusterName: string | null;
  udiseCode: string | null;
  schoolName: string | null;
  generatedOn: string | null;
}

export interface SkippedExcelRow {
  rowNumber: number;
  reason: string;
  detail: string;
}

/**
 * Privacy-clean parsed student record (STRICTLY ZERO Aadhaar or Social Category fields).
 */
export interface ParsedStudentRow {
  rowNumber: number;
  studentCode: string;
  studentName: string;
  fatherName: string | null;
  dob: string; // ISO YYYY-MM-DD
  gender: 'Male' | 'Female' | 'Other' | null;
  classNum: ClassNum;
  stream: StudentStream;
  section: string;
  rollNo: number;
  schoolName: string;
}

export interface StudentExcelParseResult {
  ok: boolean;
  banner: BepcBannerMeta;
  headerRowNumber: number;
  students: ParsedStudentRow[];
  skippedRows: SkippedExcelRow[];
  errors: string[];
  warnings: string[];
  discardedSensitiveColumns: string[];
  stats: {
    totalDataRows: number;
    parsedClass9To12: number;
    skippedClass1To8: number;
    skippedInvalid: number;
    classBreakdown: Record<ClassNum, number>;
  };
}

/**
 * Privacy-clean parsed teacher record (STRICTLY ZERO plaintext mobile number).
 */
export interface ParsedTeacherRow {
  rowNumber: number;
  teacherCode: string;
  fullName: string;
  teacherTitle: string | null;
  mobileLast4: string | null;
  mobileHash: string | null;
  districtCode: string | null;
  districtName: string | null;
  blockCode: string | null;
  blockName: string | null;
  clusterCode: string | null;
  clusterName: string | null;
  schoolUdise: string;
  schoolName: string;
}

export interface TeacherExcelParseResult {
  ok: boolean;
  banner: BepcBannerMeta;
  headerRowNumber: number;
  schoolMeta: {
    udiseCode: string | null;
    schoolName: string | null;
    districtCode: string | null;
    districtName: string | null;
    blockCode: string | null;
    blockName: string | null;
    clusterCode: string | null;
    clusterName: string | null;
  };
  teachers: ParsedTeacherRow[];
  skippedRows: SkippedExcelRow[];
  errors: string[];
  warnings: string[];
  stats: {
    totalDataRows: number;
    parsedTeachers: number;
    withValidMobileLast4: number;
    idLengths: Record<number, number>;
  };
}

export interface SchoolNameMatchResult {
  matched: boolean;
  exactNormalized: boolean;
  normalizedA: string;
  normalizedB: string;
  tokenOverlap: number;
}

// =============================================================================
// 1. ZIP-BOMB GUARD
// =============================================================================

function toBuffer(input: Buffer | Uint8Array | ArrayBuffer): Buffer {
  if (Buffer.isBuffer(input)) return input;
  if (input instanceof Uint8Array) {
    return Buffer.from(input.buffer, input.byteOffset, input.byteLength);
  }
  return Buffer.from(input);
}

/**
 * Inspects ZIP End-of-Central-Directory, Central Directory Headers, and Local File Headers
 * BEFORE passing `.xlsx` bytes to SheetJS. Blocks zip bombs, Zip64 oversized archives,
 * encrypted ZIPs, and Zip Slip traversal filenames.
 */
export function inspectXlsxZipSafety(input: Buffer | Uint8Array | ArrayBuffer): ZipSafetyReport {
  const buf = toBuffer(input);

  if (buf.length < 22) {
    return {
      safe: false,
      reason: 'File is too small to be a valid .xlsx archive.',
      entryCount: 0,
      compressedBytes: buf.length,
      uncompressedBytes: 0,
    };
  }

  if (buf.length > MAX_XLSX_COMPRESSED_BYTES) {
    return {
      safe: false,
      reason: `Excel file exceeds ${Math.round(MAX_XLSX_COMPRESSED_BYTES / (1024 * 1024))} MB upload limit.`,
      entryCount: 0,
      compressedBytes: buf.length,
      uncompressedBytes: 0,
    };
  }

  if (buf.readUInt32LE(0) !== ZIP_LOCAL_HEADER_SIG) {
    return {
      safe: false,
      reason: 'Invalid .xlsx signature: expected standard Office Open XML ZIP archive.',
      entryCount: 0,
      compressedBytes: buf.length,
      uncompressedBytes: 0,
    };
  }

  // Locate End of Central Directory (EOCD) scanning backwards up to 65557 bytes
  const minEocdOffset = Math.max(0, buf.length - 65557);
  let eocdOffset = -1;
  for (let i = buf.length - 22; i >= minEocdOffset; i--) {
    if (buf.readUInt32LE(i) === ZIP_EOCD_SIG) {
      const commentLen = buf.readUInt16LE(i + 20);
      if (i + 22 + commentLen === buf.length) {
        eocdOffset = i;
        break;
      }
    }
  }

  if (eocdOffset === -1) {
    return {
      safe: false,
      reason: 'Corrupt .xlsx archive: missing ZIP End-of-Central-Directory record.',
      entryCount: 0,
      compressedBytes: buf.length,
      uncompressedBytes: 0,
    };
  }

  const totalEntries = buf.readUInt16LE(eocdOffset + 10);
  const centralDirSize = buf.readUInt32LE(eocdOffset + 12);
  const centralDirOffset = buf.readUInt32LE(eocdOffset + 16);

  if (
    totalEntries === 0xffff ||
    centralDirSize === 0xffffffff ||
    centralDirOffset === 0xffffffff
  ) {
    return {
      safe: false,
      reason: 'ZIP64 archives are blocked for security (exceeds safe Excel limits).',
      entryCount: totalEntries,
      compressedBytes: buf.length,
      uncompressedBytes: 0,
    };
  }

  if (totalEntries === 0 || totalEntries > MAX_XLSX_ZIP_ENTRIES) {
    return {
      safe: false,
      reason: `ZIP entry count (${totalEntries}) outside safe range (1..${MAX_XLSX_ZIP_ENTRIES}).`,
      entryCount: totalEntries,
      compressedBytes: buf.length,
      uncompressedBytes: 0,
    };
  }

  if (centralDirOffset + centralDirSize > buf.length) {
    return {
      safe: false,
      reason: 'Corrupt .xlsx archive: Central Directory extends past end of file.',
      entryCount: totalEntries,
      compressedBytes: buf.length,
      uncompressedBytes: 0,
    };
  }

  let cursor = centralDirOffset;
  let totalUncompressed = 0;
  let totalCompressed = 0;

  for (let i = 0; i < totalEntries; i++) {
    if (cursor + 46 > buf.length || buf.readUInt32LE(cursor) !== ZIP_CENTRAL_HEADER_SIG) {
      return {
        safe: false,
        reason: 'Corrupt .xlsx archive: malformed Central Directory header.',
        entryCount: i,
        compressedBytes: totalCompressed,
        uncompressedBytes: totalUncompressed,
      };
    }

    const flags = buf.readUInt16LE(cursor + 8);
    if ((flags & 0x01) !== 0) {
      return {
        safe: false,
        reason: 'Encrypted .xlsx files are not permitted.',
        entryCount: i,
        compressedBytes: totalCompressed,
        uncompressedBytes: totalUncompressed,
      };
    }

    const method = buf.readUInt16LE(cursor + 10);
    const compSize = buf.readUInt32LE(cursor + 20);
    const uncompSize = buf.readUInt32LE(cursor + 24);
    const nameLen = buf.readUInt16LE(cursor + 28);
    const extraLen = buf.readUInt16LE(cursor + 30);
    const commentLen = buf.readUInt16LE(cursor + 32);
    const localHeaderOffset = buf.readUInt32LE(cursor + 42);

    if (method !== 0 && method !== 8) {
      return {
        safe: false,
        reason: `Unsupported ZIP compression method (${method}) inside .xlsx archive.`,
        entryCount: i,
        compressedBytes: totalCompressed,
        uncompressedBytes: totalUncompressed,
      };
    }

    if (compSize === 0xffffffff || uncompSize === 0xffffffff) {
      return {
        safe: false,
        reason: 'ZIP64 oversized entry blocked (potential zip bomb).',
        entryCount: i,
        compressedBytes: totalCompressed,
        uncompressedBytes: totalUncompressed,
      };
    }

    const nameEnd = cursor + 46 + nameLen;
    if (nameEnd > buf.length) {
      return {
        safe: false,
        reason: 'Corrupt .xlsx archive: truncated entry filename.',
        entryCount: i,
        compressedBytes: totalCompressed,
        uncompressedBytes: totalUncompressed,
      };
    }

    const entryName = buf.subarray(cursor + 46, nameEnd).toString('utf8');
    if (
      entryName.includes('..') ||
      entryName.startsWith('/') ||
      entryName.startsWith('\\') ||
      entryName.includes('\0')
    ) {
      return {
        safe: false,
        reason: 'Blocked unsafe path traversal entry inside .xlsx archive.',
        entryCount: i,
        compressedBytes: totalCompressed,
        uncompressedBytes: totalUncompressed,
      };
    }

    // Cross-check Local File Header AND bound actual DEFLATE output so forged headers cannot bypass the cap
    let actualEntryUncomp = uncompSize;
    if (localHeaderOffset + 30 <= buf.length && buf.readUInt32LE(localHeaderOffset) === ZIP_LOCAL_HEADER_SIG) {
      const localUncomp = buf.readUInt32LE(localHeaderOffset + 22);
      const localNameLen = buf.readUInt16LE(localHeaderOffset + 26);
      const localExtraLen = buf.readUInt16LE(localHeaderOffset + 28);
      if (localUncomp === 0xffffffff) {
        return {
          safe: false,
          reason: 'ZIP64 local header blocked (potential zip bomb).',
          entryCount: i,
          compressedBytes: totalCompressed,
          uncompressedBytes: totalUncompressed,
        };
      }
      actualEntryUncomp = Math.max(uncompSize, localUncomp);

      if (method === 8 && compSize > 0) {
        const dataStart = localHeaderOffset + 30 + localNameLen + localExtraLen;
        const dataEnd = dataStart + compSize;
        if (dataEnd > buf.length) {
          return {
            safe: false,
            reason: 'Corrupt .xlsx archive: compressed entry extends past EOF.',
            entryCount: i,
            compressedBytes: totalCompressed,
            uncompressedBytes: totalUncompressed,
          };
        }
        const remainingBudget = MAX_XLSX_UNCOMPRESSED_BYTES - totalUncompressed;
        if (remainingBudget <= 0) {
          return {
            safe: false,
            reason: `Uncompressed .xlsx contents exceed ${Math.round(MAX_XLSX_UNCOMPRESSED_BYTES / (1024 * 1024))} MB limit (zip-bomb protection).`,
            entryCount: i + 1,
            compressedBytes: totalCompressed,
            uncompressedBytes: totalUncompressed,
          };
        }
        try {
          const inflated = zlib.inflateRawSync(buf.subarray(dataStart, dataEnd), {
            maxOutputLength: remainingBudget,
          });
          actualEntryUncomp = Math.max(actualEntryUncomp, inflated.length);
        } catch {
          return {
            safe: false,
            reason: `Blocked .xlsx entry exceeding ${Math.round(MAX_XLSX_UNCOMPRESSED_BYTES / (1024 * 1024))} MB actual decompressed limit or corrupt DEFLATE stream (zip-bomb protection).`,
            entryCount: i + 1,
            compressedBytes: totalCompressed,
            uncompressedBytes: totalUncompressed,
          };
        }
      }
    }

    totalUncompressed += actualEntryUncomp;
    totalCompressed += compSize;

    if (totalUncompressed > MAX_XLSX_UNCOMPRESSED_BYTES) {
      return {
        safe: false,
        reason: `Uncompressed .xlsx contents exceed ${Math.round(MAX_XLSX_UNCOMPRESSED_BYTES / (1024 * 1024))} MB limit (zip-bomb protection).`,
        entryCount: i + 1,
        compressedBytes: totalCompressed,
        uncompressedBytes: totalUncompressed,
      };
    }

    cursor = nameEnd + extraLen + commentLen;
  }

  if (
    totalUncompressed > RATIO_CHECK_MIN_UNCOMPRESSED &&
    totalCompressed > 0 &&
    totalUncompressed / totalCompressed > MAX_COMPRESSION_RATIO_LARGE
  ) {
    return {
      safe: false,
      reason: 'Abnormal ZIP compression ratio detected (zip-bomb protection).',
      entryCount: totalEntries,
      compressedBytes: totalCompressed,
      uncompressedBytes: totalUncompressed,
    };
  }

  return {
    safe: true,
    entryCount: totalEntries,
    compressedBytes: totalCompressed,
    uncompressedBytes: totalUncompressed,
  };
}

// =============================================================================
// 2. SHARED CELL, DATE, CLASS, AND SCHOOL NAME UTILITIES
// =============================================================================

function openSafeWorksheet(buffer: Buffer | Uint8Array | ArrayBuffer): {
  ok: true;
  sheet: XLSX.WorkSheet;
  range: XLSX.Range;
} | {
  ok: false;
  error: string;
} {
  const buf = toBuffer(buffer);
  const safety = inspectXlsxZipSafety(buf);
  if (!safety.safe) {
    return { ok: false, error: safety.reason ?? 'Unsafe .xlsx file.' };
  }

  let workbook: XLSX.WorkBook;
  try {
    workbook = XLSX.read(buf, {
      type: 'buffer',
      cellFormula: false,
      cellHTML: false,
      cellStyles: false,
      cellNF: false,
      bookVBA: false,
      dense: false,
    });
  } catch (err) {
    return {
      ok: false,
      error: `Failed to parse .xlsx workbook: ${err instanceof Error ? err.message : 'invalid file'}`,
    };
  }

  const firstSheetName = workbook.SheetNames[0];
  if (!firstSheetName) {
    return { ok: false, error: 'Workbook contains no worksheets.' };
  }
  const sheet = workbook.Sheets[firstSheetName];
  if (!sheet || !sheet['!ref']) {
    return { ok: false, error: 'Worksheet is empty.' };
  }

  const range = XLSX.utils.decode_range(sheet['!ref']);
  const totalRows = range.e.r - range.s.r + 1;
  const totalCols = range.e.c - range.s.c + 1;

  if (totalRows > MAX_XLSX_ROWS) {
    return {
      ok: false,
      error: `Worksheet has ${totalRows} rows, exceeding the maximum allowed ${MAX_XLSX_ROWS} rows.`,
    };
  }
  if (totalCols > MAX_XLSX_COLS) {
    return {
      ok: false,
      error: `Worksheet has ${totalCols} columns, exceeding the maximum allowed ${MAX_XLSX_COLS} columns.`,
    };
  }

  return { ok: true, sheet, range };
}

function getCell(sheet: XLSX.WorkSheet, rowIdx: number, colIdx: number): XLSX.CellObject | undefined {
  const addr = XLSX.utils.encode_cell({ r: rowIdx, c: colIdx });
  return sheet[addr] as XLSX.CellObject | undefined;
}

function readCellText(cell: XLSX.CellObject | undefined): string {
  if (!cell || cell.v === null || cell.v === undefined) return '';
  if (typeof cell.v === 'string') return cell.v.trim();
  if (typeof cell.v === 'number') {
    if (Number.isSafeInteger(cell.v)) return String(cell.v);
    return String(cell.w ?? cell.v).trim();
  }
  if (typeof cell.v === 'boolean') return cell.v ? 'true' : 'false';
  if (cell.v instanceof Date) return cell.v.toISOString();
  return String(cell.v).trim();
}

const SCIENTIFIC_NOTATION_REGEX = /^\d+(?:\.\d+)?[eE][+-]?\d+$/;

/**
 * Extracts an exact numeric/code identifier (`Student Code`, `Teacher ID`, `UDISE`, `Mobile No`)
 * as a trimmed string while detecting & blocking Excel scientific notation (`2.02E+14`)
 * or IEEE-754 floating-point precision corruption.
 */
function extractExactCodeCell(cell: XLSX.CellObject | undefined): {
  value: string;
  corruptedScientific: boolean;
} {
  if (!cell || cell.v === null || cell.v === undefined) {
    return { value: '', corruptedScientific: false };
  }

  if (typeof cell.v === 'number') {
    if (!Number.isFinite(cell.v) || !Number.isSafeInteger(cell.v) || cell.v < 0) {
      return { value: String(cell.v), corruptedScientific: true };
    }
    return { value: String(cell.v), corruptedScientific: false };
  }

  const text = String(cell.v).trim();
  if (SCIENTIFIC_NOTATION_REGEX.test(text)) {
    return { value: text, corruptedScientific: true };
  }
  return { value: text, corruptedScientific: false };
}

function isValidCalendarDate(year: number, month: number, day: number): boolean {
  if (year < 1950 || year > 2030 || month < 1 || month > 12 || day < 1 || day > 31) {
    return false;
  }
  const d = new Date(Date.UTC(year, month - 1, day));
  return (
    d.getUTCFullYear() === year &&
    d.getUTCMonth() === month - 1 &&
    d.getUTCDate() === day
  );
}

function formatIsoDate(year: number, month: number, day: number): string {
  return `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

/**
 * Parses Bihar e-Shikshakosh DOB formats into strict ISO `YYYY-MM-DD`:
 * - `dd-Mon-yyyy` / `d-Mon-yyyy` (primary e-Shikshakosh format e.g. `15-Aug-2010`)
 * - `DD/MM/YYYY` or `DD-MM-YYYY`
 * - `YYYY-MM-DD`
 * - Excel serial numbers (1900 date system)
 * - JS Date objects
 */
export function parseFlexibleDob(cellOrValue: XLSX.CellObject | string | number | Date | undefined): string | null {
  if (cellOrValue === undefined || cellOrValue === null) return null;

  let raw: unknown = cellOrValue;
  if (typeof cellOrValue === 'object' && !(cellOrValue instanceof Date) && 'v' in cellOrValue) {
    raw = cellOrValue.v;
  }

  if (raw instanceof Date && !Number.isNaN(raw.getTime())) {
    const y = raw.getUTCFullYear();
    const m = raw.getUTCMonth() + 1;
    const d = raw.getUTCDate();
    return isValidCalendarDate(y, m, d) ? formatIsoDate(y, m, d) : null;
  }

  if (typeof raw === 'number' && Number.isFinite(raw) && raw > 15000 && raw < 65000) {
    // Excel 1900 epoch (with Lotus 1-2-3 leap day adjustment for serial >= 60)
    const adjustedDays = raw >= 60 ? Math.floor(raw) - 2 : Math.floor(raw) - 1;
    const utcMs = Date.UTC(1900, 0, 1) + adjustedDays * 86_400_000;
    const d = new Date(utcMs);
    const y = d.getUTCFullYear();
    const m = d.getUTCMonth() + 1;
    const day = d.getUTCDate();
    return isValidCalendarDate(y, m, day) ? formatIsoDate(y, m, day) : null;
  }

  if (typeof raw !== 'string') return null;
  const text = raw.trim();
  if (!text) return null;

  // 1. YYYY-MM-DD
  const isoMatch = /^(\d{4})[-/](\d{1,2})[-/](\d{1,2})$/.exec(text);
  if (isoMatch) {
    const y = Number(isoMatch[1]);
    const m = Number(isoMatch[2]);
    const d = Number(isoMatch[3]);
    return isValidCalendarDate(y, m, d) ? formatIsoDate(y, m, d) : null;
  }

  // 2. dd-Mon-yyyy / d-Mon-yyyy / dd Mon yyyy (real Bihar e-Shikshakosh format)
  const monMatch = /^(\d{1,2})[-\s/]([A-Za-z]{3,9})[-\s/](\d{4})$/.exec(text);
  if (monMatch) {
    const d = Number(monMatch[1]);
    const m = MONTH_NAME_MAP[monMatch[2].toLowerCase()];
    const y = Number(monMatch[3]);
    if (m && isValidCalendarDate(y, m, d)) {
      return formatIsoDate(y, m, d);
    }
    return null;
  }

  // 3. DD/MM/YYYY or DD-MM-YYYY
  const dmyMatch = /^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$/.exec(text);
  if (dmyMatch) {
    const d = Number(dmyMatch[1]);
    const m = Number(dmyMatch[2]);
    const y = Number(dmyMatch[3]);
    return isValidCalendarDate(y, m, d) ? formatIsoDate(y, m, d) : null;
  }

  return null;
}

/**
 * Normalizes a Bihar e-Shikshakosh Class cell (`'Class 9'`..`'Class 12'`, `'IX'`..`'XII'`, etc.).
 */
export function normalizeBsebClass(
  raw: string
): { kind: 'VALID'; classNum: ClassNum } | { kind: 'BELOW_9'; rawClass: number } | { kind: 'INVALID' } {
  const cleaned = raw.trim().toUpperCase().replace(/^CLASS\s*[-:.]?\s*/i, '').trim();

  const romanMap: Record<string, number> = {
    I: 1,
    II: 2,
    III: 3,
    IV: 4,
    V: 5,
    VI: 6,
    VII: 7,
    VIII: 8,
    IX: 9,
    X: 10,
    XI: 11,
    XII: 12,
  };

  let num: number | null = null;
  if (/^\d{1,2}$/.test(cleaned)) {
    num = Number.parseInt(cleaned, 10);
  } else if (cleaned in romanMap) {
    num = romanMap[cleaned];
  } else {
    const digitMatch = /\b(\d{1,2})\b/.exec(cleaned);
    if (digitMatch) {
      num = Number.parseInt(digitMatch[1], 10);
    }
  }

  if (num === 9 || num === 10 || num === 11 || num === 12) {
    return { kind: 'VALID', classNum: num };
  }
  if (num !== null && num >= 1 && num <= 8) {
    return { kind: 'BELOW_9', rawClass: num };
  }
  return { kind: 'INVALID' };
}

function normalizeGender(raw: string): 'Male' | 'Female' | 'Other' | null {
  const g = raw.trim().toLowerCase();
  if (!g) return null;
  if (g === 'male' || g === 'm' || g === 'boy' || g === 'boys') return 'Male';
  if (g === 'female' || g === 'f' || g === 'girl' || g === 'girls') return 'Female';
  if (g === 'other' || g === 'transgender' || g === 't') return 'Other';
  return null;
}

function normalizeOptionalStream(raw: string, classNum: ClassNum): StudentStream {
  if (classNum === 9 || classNum === 10) return 'NA';
  const s = raw.trim().toLowerCase();
  if (s === 'science' || s === 'sci' || s === 'isc' || s === 'i.sc') return 'Science';
  if (s === 'arts' || s === 'art' || s === 'ia' || s === 'i.a' || s === 'humanities') return 'Arts';
  if (s === 'commerce' || s === 'com' || s === 'icom' || s === 'i.com') return 'Commerce';
  return 'UNSET';
}

function normalizeHeaderLabel(raw: string): string {
  return raw
    .toLowerCase()
    .replace(/[#.*:()/-]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function extractBepcBannerMetadata(
  sheet: XLSX.WorkSheet,
  range: XLSX.Range,
  headerRowIdx: number
): BepcBannerMeta {
  const meta: BepcBannerMeta = {
    districtCode: null,
    districtName: null,
    blockCode: null,
    blockName: null,
    clusterCode: null,
    clusterName: null,
    udiseCode: null,
    schoolName: null,
    generatedOn: null,
  };

  for (let r = range.s.r; r < headerRowIdx; r++) {
    const rowParts: string[] = [];
    for (let c = range.s.c; c <= Math.min(range.e.c, range.s.c + 5); c++) {
      const txt = readCellText(getCell(sheet, r, c));
      if (txt) rowParts.push(txt);
    }
    const line = rowParts.join(' ').trim();
    if (!line) continue;

    // Teacher banner format: "District :-1014-Muzaffarpur" / Student format: "District : Muzaffarpur"
    const distMatch = /^district\s*:\s*-?\s*(?:(\d{2,8})\s*-\s*)?(.+)$/i.exec(line);
    if (distMatch) {
      if (distMatch[1]) meta.districtCode = distMatch[1].trim();
      const val = distMatch[2].trim();
      if (val && !/^-+$/.test(val)) meta.districtName = val;
      continue;
    }

    const blockMatch = /^block\s*:\s*-?\s*(?:(\d{3,10})\s*-\s*)?(.+)$/i.exec(line);
    if (blockMatch) {
      if (blockMatch[1]) meta.blockCode = blockMatch[1].trim();
      const val = blockMatch[2].trim();
      if (val && !/^-+$/.test(val)) meta.blockName = val;
      continue;
    }

    const clusterMatch = /^cluster\s*:\s*-?\s*(?:([A-Z0-9]{4,16})\s*-\s*)?(.+)$/i.exec(line);
    if (clusterMatch) {
      if (clusterMatch[1] && /\d/.test(clusterMatch[1])) {
        meta.clusterCode = clusterMatch[1].trim();
      }
      const val = clusterMatch[2].trim();
      if (val && !/^-+$/.test(val)) meta.clusterName = val;
      continue;
    }

    // Teacher format: "School :-10140616812-UCHCH MADHYAMIK VIDYALAYA KAPARPURA, KANTI, MUZAFFARPUR"
    // Student format: "School Name : UCHCH MADHYAMIK VIDYALAYA KAPARPURA, KANTI, MUZAFFARPUR"
    const schoolMatch = /^school(?:\s+name)?\s*:\s*-?\s*(?:(\d{11})\s*-\s*)?(.+)$/i.exec(line);
    if (schoolMatch) {
      if (schoolMatch[1]) meta.udiseCode = schoolMatch[1].trim();
      const val = schoolMatch[2].trim();
      if (val && !/^-+$/.test(val)) meta.schoolName = val;
      continue;
    }

    const genMatch = /^generated\s+on\s*:\s*(.+)$/i.exec(line);
    if (genMatch) {
      const val = genMatch[1].trim();
      if (val && !/^-+$/.test(val)) meta.generatedOn = val;
    }
  }

  return meta;
}

/**
 * Punctuation-insensitive school name normalizer.
 * Matches e.g.:
 *   'UCHCH MADHYAMIK VIDYALAYA KAPARPURA, KANTI, MUZAFFARPUR'
 * with:
 *   'UCHCH MADHYAMIK VIDYALAYA KAPARPURA KANTI MUZAFFARPUR'
 */
export function normalizeSchoolName(name: string): string {
  return name
    .toUpperCase()
    .replace(/[^\p{L}\p{N}\s]/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

/**
 * Compares two Bihar school names ignoring punctuation/extra spacing while still
 * strictly flagging genuinely different schools (e.g., two different villages in the same block).
 */
export function matchSchoolNames(nameA: string, nameB: string): SchoolNameMatchResult {
  const normalizedA = normalizeSchoolName(nameA);
  const normalizedB = normalizeSchoolName(nameB);
  const exactNormalized = normalizedA.length > 0 && normalizedA === normalizedB;

  const setA = new Set(normalizedA.split(' ').filter(Boolean));
  const setB = new Set(normalizedB.split(' ').filter(Boolean));
  let overlap = 0;
  for (const tok of setA) {
    if (setB.has(tok)) overlap++;
  }
  const union = new Set([...setA, ...setB]).size;
  const tokenOverlap = union > 0 ? Number((overlap / union).toFixed(3)) : 0;

  return {
    matched: exactNormalized,
    exactNormalized,
    normalizedA,
    normalizedB,
    tokenOverlap,
  };
}

// =============================================================================
// 3. STUDENT EXCEL PARSER (BEPC e-Shikshakosh)
// =============================================================================

type StudentColRole =
  | 'sl_no'
  | 'student_name'
  | 'student_code'
  | 'aadhaar_discard'
  | 'father_name'
  | 'dob'
  | 'gender'
  | 'social_category_discard'
  | 'class'
  | 'roll_no'
  | 'school'
  | 'stream'
  | 'section';

function classifyStudentHeader(norm: string): StudentColRole | null {
  if (norm === 'student name' || norm === 'name of student') return 'student_name';
  if (norm === 'student code' || norm === 'student id' || norm === 'pen' || norm === 'e shiksha code') {
    return 'student_code';
  }
  if (norm.includes('aadhaar') || norm.includes('aadhar') || norm === 'uid') {
    return 'aadhaar_discard';
  }
  if (norm === 'father name' || norm === 'fathers name' || norm === "father's name") {
    return 'father_name';
  }
  if (norm === 'dob' || norm === 'date of birth' || norm === 'birth date') return 'dob';
  if (norm === 'gender' || norm === 'sex') return 'gender';
  if (norm.includes('social category') || norm === 'category' || norm.includes('caste')) {
    return 'social_category_discard';
  }
  if (norm === 'class' || norm === 'grade' || norm === 'standard') return 'class';
  if (norm === 'roll no' || norm === 'roll number' || norm === 'roll') return 'roll_no';
  if (norm === 'school' || norm === 'school name') return 'school';
  if (norm === 'stream' || norm === 'faculty') return 'stream';
  if (norm === 'section' || norm === 'sec') return 'section';
  if (norm === 'sl no' || norm === 's no' || norm === 'sr no' || norm === 'serial no') return 'sl_no';
  return null;
}

/**
 * Parses a Bihar e-Shikshakosh Student List `.xlsx` buffer.
 * - Scans dynamically past the 13 BEPC banner rows.
 * - Normalizes Class 9..12 (cleanly skips Class 1..8).
 * - Blocks Excel scientific notation corruption on Student Code.
 * - EXPLICITLY DISCARDS Aadhaar No and Social Category in memory.
 */
export function parseStudentExcel(
  buffer: Buffer | Uint8Array | ArrayBuffer
): StudentExcelParseResult {
  const emptyStats = {
    totalDataRows: 0,
    parsedClass9To12: 0,
    skippedClass1To8: 0,
    skippedInvalid: 0,
    classBreakdown: { 9: 0, 10: 0, 11: 0, 12: 0 } as Record<ClassNum, number>,
  };

  const emptyBanner: BepcBannerMeta = {
    districtCode: null,
    districtName: null,
    blockCode: null,
    blockName: null,
    clusterCode: null,
    clusterName: null,
    udiseCode: null,
    schoolName: null,
    generatedOn: null,
  };

  const opened = openSafeWorksheet(buffer);
  if (!opened.ok) {
    return {
      ok: false,
      banner: emptyBanner,
      headerRowNumber: 0,
      students: [],
      skippedRows: [],
      errors: [opened.error],
      warnings: [],
      discardedSensitiveColumns: [],
      stats: emptyStats,
    };
  }

  const { sheet, range } = opened;

  // Dynamic header scan (rows 0..35) requiring multi-column match so BEPC filter rows are skipped
  let headerRowIdx = -1;
  let colMap = new Map<StudentColRole, number>();
  const discardedSensitiveColumns: string[] = [];

  const maxScanRow = Math.min(range.e.r, range.s.r + 35);
  for (let r = range.s.r; r <= maxScanRow; r++) {
    const candidateMap = new Map<StudentColRole, number>();
    const candidateDiscarded: string[] = [];

    for (let c = range.s.c; c <= range.e.c; c++) {
      const raw = readCellText(getCell(sheet, r, c));
      if (!raw) continue;
      const role = classifyStudentHeader(normalizeHeaderLabel(raw));
      if (role && !candidateMap.has(role)) {
        candidateMap.set(role, c);
        if (role === 'aadhaar_discard' || role === 'social_category_discard') {
          candidateDiscarded.push(raw);
        }
      }
    }

    const hasRequiredHeaders =
      candidateMap.has('student_name') &&
      candidateMap.has('student_code') &&
      candidateMap.has('class') &&
      candidateMap.size >= 4;

    if (hasRequiredHeaders) {
      headerRowIdx = r;
      colMap = candidateMap;
      discardedSensitiveColumns.push(...candidateDiscarded);
      break;
    }
  }

  if (headerRowIdx === -1) {
    return {
      ok: false,
      banner: emptyBanner,
      headerRowNumber: 0,
      students: [],
      skippedRows: [],
      errors: [
        'Could not locate Student List header row (expected columns: Student Name, Student Code, DOB, Class, Roll No).',
      ],
      warnings: [],
      discardedSensitiveColumns: [],
      stats: emptyStats,
    };
  }

  // Delete discarded sensitive column pointers so they are NEVER read below
  colMap.delete('aadhaar_discard');
  colMap.delete('social_category_discard');

  const banner = extractBepcBannerMetadata(sheet, range, headerRowIdx);
  const students: ParsedStudentRow[] = [];
  const skippedRows: SkippedExcelRow[] = [];
  const errors: string[] = [];
  const warnings: string[] = [];
  const seenCodes = new Set<string>();

  const classBreakdown: Record<ClassNum, number> = { 9: 0, 10: 0, 11: 0, 12: 0 };
  let totalDataRows = 0;
  let skippedClass1To8 = 0;
  let skippedInvalid = 0;

  for (let r = headerRowIdx + 1; r <= range.e.r; r++) {
    const rowNumber = r + 1; // 1-indexed Excel row number

    // Check whether row is completely empty
    let hasAnyValue = false;
    for (let c = range.s.c; c <= range.e.c; c++) {
      if (readCellText(getCell(sheet, r, c)) !== '') {
        hasAnyValue = true;
        break;
      }
    }
    if (!hasAnyValue) continue;

    totalDataRows++;

    const name = colMap.has('student_name')
      ? readCellText(getCell(sheet, r, colMap.get('student_name')!))
      : '';
    const codeRes = colMap.has('student_code')
      ? extractExactCodeCell(getCell(sheet, r, colMap.get('student_code')!))
      : { value: '', corruptedScientific: false };
    const classRaw = colMap.has('class')
      ? readCellText(getCell(sheet, r, colMap.get('class')!))
      : '';
    const rollRaw = colMap.has('roll_no')
      ? readCellText(getCell(sheet, r, colMap.get('roll_no')!))
      : '';
    const dobCell = colMap.has('dob') ? getCell(sheet, r, colMap.get('dob')!) : undefined;
    const fatherName = colMap.has('father_name')
      ? readCellText(getCell(sheet, r, colMap.get('father_name')!)) || null
      : null;
    const genderRaw = colMap.has('gender')
      ? readCellText(getCell(sheet, r, colMap.get('gender')!))
      : '';
    const schoolRaw = colMap.has('school')
      ? readCellText(getCell(sheet, r, colMap.get('school')!))
      : banner.schoolName ?? '';
    const streamRaw = colMap.has('stream')
      ? readCellText(getCell(sheet, r, colMap.get('stream')!))
      : '';
    const sectionRaw = colMap.has('section')
      ? readCellText(getCell(sheet, r, colMap.get('section')!))
      : '';

    // Check scientific notation corruption FIRST (critical data-integrity blocker)
    if (codeRes.corruptedScientific) {
      skippedInvalid++;
      const msg = `Row ${rowNumber}: Student Code appears corrupted by Excel scientific notation ("${codeRes.value}"). Upload the unmodified original e-Shikshakosh .xlsx export.`;
      errors.push(msg);
      skippedRows.push({
        rowNumber,
        reason: 'SCIENTIFIC_NOTATION_CORRUPTION',
        detail: 'Student Code corrupted into scientific notation',
      });
      continue;
    }

    // Class check: cleanly skip Class 1-8
    const classParsed = normalizeBsebClass(classRaw);
    if (classParsed.kind === 'BELOW_9') {
      skippedClass1To8++;
      skippedRows.push({
        rowNumber,
        reason: 'CLASS_BELOW_9',
        detail: `Class ${classParsed.rawClass} is outside secondary/senior-secondary (Class 9-12) scope`,
      });
      continue;
    }
    if (classParsed.kind === 'INVALID') {
      skippedInvalid++;
      skippedRows.push({
        rowNumber,
        reason: 'INVALID_CLASS',
        detail: `Unrecognized Class value: "${classRaw}"`,
      });
      continue;
    }

    if (!name || name.length < 1) {
      skippedInvalid++;
      skippedRows.push({ rowNumber, reason: 'MISSING_NAME', detail: 'Missing Student Name' });
      continue;
    }

    const studentCode = codeRes.value.trim();
    if (!studentCode || !/^\d{6,20}$/.test(studentCode)) {
      skippedInvalid++;
      skippedRows.push({
        rowNumber,
        reason: 'INVALID_STUDENT_CODE',
        detail: `Student Code must be 6-20 numeric digits (got length ${studentCode.length})`,
      });
      continue;
    }

    if (seenCodes.has(studentCode)) {
      skippedInvalid++;
      warnings.push(`Row ${rowNumber}: Duplicate Student Code inside uploaded file — skipped.`);
      skippedRows.push({
        rowNumber,
        reason: 'DUPLICATE_IN_FILE',
        detail: 'Duplicate Student Code in same upload',
      });
      continue;
    }

    const dobIso = parseFlexibleDob(dobCell);
    if (!dobIso) {
      skippedInvalid++;
      skippedRows.push({
        rowNumber,
        reason: 'INVALID_DOB',
        detail: 'Unparseable or out-of-range DOB',
      });
      continue;
    }

    const rollNo = Number.parseInt(rollRaw.replace(/[^\d]/g, ''), 10);
    if (!Number.isInteger(rollNo) || rollNo <= 0 || rollNo > 99999) {
      skippedInvalid++;
      skippedRows.push({
        rowNumber,
        reason: 'INVALID_ROLL_NO',
        detail: `Invalid Roll No: "${rollRaw}"`,
      });
      continue;
    }

    seenCodes.add(studentCode);
    classBreakdown[classParsed.classNum]++;

    students.push({
      rowNumber,
      studentCode,
      studentName: name,
      fatherName,
      dob: dobIso,
      gender: normalizeGender(genderRaw),
      classNum: classParsed.classNum,
      stream: normalizeOptionalStream(streamRaw, classParsed.classNum),
      section: sectionRaw ? sectionRaw.toUpperCase().slice(0, 8) : 'A',
      rollNo,
      schoolName: schoolRaw || banner.schoolName || '',
    });
  }

  return {
    ok: errors.length === 0 && students.length > 0,
    banner,
    headerRowNumber: headerRowIdx + 1,
    students,
    skippedRows,
    errors,
    warnings,
    discardedSensitiveColumns,
    stats: {
      totalDataRows,
      parsedClass9To12: students.length,
      skippedClass1To8,
      skippedInvalid,
      classBreakdown,
    },
  };
}

// =============================================================================
// 4. TEACHER EXCEL PARSER (BEPC e-Shikshakosh)
// =============================================================================

type TeacherColRole =
  | 'sl_no'
  | 'teacher_id'
  | 'teacher_name'
  | 'teacher_title'
  | 'mobile_no'
  | 'district_code'
  | 'district_name'
  | 'block_code'
  | 'block_name'
  | 'cluster_code'
  | 'cluster_name'
  | 'school_udise'
  | 'school';

function classifyTeacherHeader(norm: string): TeacherColRole | null {
  if (norm === 'teacher id' || norm === 'teacher code') return 'teacher_id';
  if (norm === 'teacher name' || norm === 'name of teacher') return 'teacher_name';
  if (norm === 'teacher title' || norm === 'designation' || norm === 'post') return 'teacher_title';
  if (norm === 'mobile no' || norm === 'mobile number' || norm === 'mobile' || norm === 'phone') {
    return 'mobile_no';
  }
  if (norm === 'district code') return 'district_code';
  if (norm === 'district name' || norm === 'district') return 'district_name';
  if (norm === 'block code') return 'block_code';
  if (norm === 'block name' || norm === 'block') return 'block_name';
  if (norm === 'cluster code') return 'cluster_code';
  if (norm === 'cluster name' || norm === 'cluster') return 'cluster_name';
  if (norm === 'school udise code' || norm === 'udise code' || norm === 'udise') {
    return 'school_udise';
  }
  if (norm === 'school' || norm === 'school name') return 'school';
  if (norm === 'sl no' || norm === 's no' || norm === 'sr no') return 'sl_no';
  return null;
}

/**
 * Parses a Bihar e-Shikshakosh Teacher List `.xlsx` buffer.
 * - Extracts authoritative 11-digit `School UDISE Code` + District/Block/Cluster codes & names.
 * - Preserves mixed 8-digit & 13-digit `Teacher ID` as exact trimmed string.
 * - Converts `Mobile No` strictly to `mobileLast4` + `mobileHash` (NEVER returns plaintext mobile!).
 */
export function parseTeacherExcel(
  buffer: Buffer | Uint8Array | ArrayBuffer
): TeacherExcelParseResult {
  const emptyBanner: BepcBannerMeta = {
    districtCode: null,
    districtName: null,
    blockCode: null,
    blockName: null,
    clusterCode: null,
    clusterName: null,
    udiseCode: null,
    schoolName: null,
    generatedOn: null,
  };

  const emptySchoolMeta = {
    udiseCode: null,
    schoolName: null,
    districtCode: null,
    districtName: null,
    blockCode: null,
    blockName: null,
    clusterCode: null,
    clusterName: null,
  };

  const emptyStats = {
    totalDataRows: 0,
    parsedTeachers: 0,
    withValidMobileLast4: 0,
    idLengths: {} as Record<number, number>,
  };

  const opened = openSafeWorksheet(buffer);
  if (!opened.ok) {
    return {
      ok: false,
      banner: emptyBanner,
      headerRowNumber: 0,
      schoolMeta: emptySchoolMeta,
      teachers: [],
      skippedRows: [],
      errors: [opened.error],
      warnings: [],
      stats: emptyStats,
    };
  }

  const { sheet, range } = opened;

  let headerRowIdx = -1;
  let colMap = new Map<TeacherColRole, number>();
  const maxScanRow = Math.min(range.e.r, range.s.r + 35);

  for (let r = range.s.r; r <= maxScanRow; r++) {
    const candidateMap = new Map<TeacherColRole, number>();
    for (let c = range.s.c; c <= range.e.c; c++) {
      const raw = readCellText(getCell(sheet, r, c));
      if (!raw) continue;
      const role = classifyTeacherHeader(normalizeHeaderLabel(raw));
      if (role && !candidateMap.has(role)) {
        candidateMap.set(role, c);
      }
    }

    const hasRequired =
      candidateMap.has('teacher_id') &&
      candidateMap.has('teacher_name') &&
      candidateMap.size >= 4;

    if (hasRequired) {
      headerRowIdx = r;
      colMap = candidateMap;
      break;
    }
  }

  if (headerRowIdx === -1) {
    return {
      ok: false,
      banner: emptyBanner,
      headerRowNumber: 0,
      schoolMeta: emptySchoolMeta,
      teachers: [],
      skippedRows: [],
      errors: [
        'Could not locate Teacher List header row (expected columns: Teacher ID, Teacher Name, School UDISE Code, School).',
      ],
      warnings: [],
      stats: emptyStats,
    };
  }

  const banner = extractBepcBannerMetadata(sheet, range, headerRowIdx);
  const teachers: ParsedTeacherRow[] = [];
  const skippedRows: SkippedExcelRow[] = [];
  const errors: string[] = [];
  const warnings: string[] = [];
  const seenTeacherCodes = new Set<string>();
  const seenUdiseCodes = new Set<string>();
  const idLengths: Record<number, number> = {};

  let totalDataRows = 0;
  let withValidMobileLast4 = 0;

  for (let r = headerRowIdx + 1; r <= range.e.r; r++) {
    const rowNumber = r + 1;

    let hasAnyValue = false;
    for (let c = range.s.c; c <= range.e.c; c++) {
      if (readCellText(getCell(sheet, r, c)) !== '') {
        hasAnyValue = true;
        break;
      }
    }
    if (!hasAnyValue) continue;

    totalDataRows++;

    const idRes = extractExactCodeCell(getCell(sheet, r, colMap.get('teacher_id')!));
    if (idRes.corruptedScientific) {
      errors.push(
        `Row ${rowNumber}: Teacher ID appears corrupted by Excel scientific notation ("${idRes.value}").`
      );
      skippedRows.push({
        rowNumber,
        reason: 'SCIENTIFIC_NOTATION_CORRUPTION',
        detail: 'Teacher ID corrupted into scientific notation',
      });
      continue;
    }

    const teacherCode = idRes.value.trim();
    const fullName = readCellText(getCell(sheet, r, colMap.get('teacher_name')!));
    const teacherTitle = colMap.has('teacher_title')
      ? readCellText(getCell(sheet, r, colMap.get('teacher_title')!)) || null
      : null;

    if (!teacherCode || teacherCode.length < 4 || !/^[A-Za-z0-9_-]+$/.test(teacherCode)) {
      skippedRows.push({
        rowNumber,
        reason: 'INVALID_TEACHER_ID',
        detail: 'Teacher ID is missing or malformed',
      });
      continue;
    }

    if (!fullName || fullName.length < 2) {
      skippedRows.push({
        rowNumber,
        reason: 'MISSING_TEACHER_NAME',
        detail: 'Missing Teacher Name',
      });
      continue;
    }

    if (seenTeacherCodes.has(teacherCode)) {
      warnings.push(`Row ${rowNumber}: Duplicate Teacher ID inside uploaded file — skipped.`);
      skippedRows.push({
        rowNumber,
        reason: 'DUPLICATE_IN_FILE',
        detail: 'Duplicate Teacher ID in same upload',
      });
      continue;
    }

    // Extract 11-digit UDISE from row column or fall back to banner
    const udiseRes = colMap.has('school_udise')
      ? extractExactCodeCell(getCell(sheet, r, colMap.get('school_udise')!))
      : { value: banner.udiseCode ?? '', corruptedScientific: false };

    if (udiseRes.corruptedScientific) {
      errors.push(`Row ${rowNumber}: School UDISE Code appears corrupted by scientific notation.`);
      skippedRows.push({
        rowNumber,
        reason: 'SCIENTIFIC_NOTATION_CORRUPTION',
        detail: 'School UDISE corrupted',
      });
      continue;
    }

    const schoolUdise = (udiseRes.value || banner.udiseCode || '').trim();
    if (!/^\d{11}$/.test(schoolUdise)) {
      errors.push(`Row ${rowNumber}: School UDISE Code must be exactly 11 numeric digits.`);
      skippedRows.push({
        rowNumber,
        reason: 'INVALID_UDISE',
        detail: `Invalid UDISE length (${schoolUdise.length})`,
      });
      continue;
    }

    // Mobile No: hash immediately in memory, NEVER retain plaintext mobile!
    let mobileLast4: string | null = null;
    let mobileHash: string | null = null;
    if (colMap.has('mobile_no')) {
      const mobileRes = extractExactCodeCell(getCell(sheet, r, colMap.get('mobile_no')!));
      if (!mobileRes.corruptedScientific && mobileRes.value) {
        const hashed = hashIndianMobile(mobileRes.value);
        if (hashed) {
          mobileLast4 = hashed.mobileLast4;
          mobileHash = hashed.mobileHash;
          withValidMobileLast4++;
        }
      }
    }

    const districtCode = colMap.has('district_code')
      ? extractExactCodeCell(getCell(sheet, r, colMap.get('district_code')!)).value || banner.districtCode
      : banner.districtCode;
    const districtName = colMap.has('district_name')
      ? readCellText(getCell(sheet, r, colMap.get('district_name')!)) || banner.districtName
      : banner.districtName;
    const blockCode = colMap.has('block_code')
      ? extractExactCodeCell(getCell(sheet, r, colMap.get('block_code')!)).value || banner.blockCode
      : banner.blockCode;
    const blockName = colMap.has('block_name')
      ? readCellText(getCell(sheet, r, colMap.get('block_name')!)) || banner.blockName
      : banner.blockName;
    const clusterCode = colMap.has('cluster_code')
      ? readCellText(getCell(sheet, r, colMap.get('cluster_code')!)) || banner.clusterCode
      : banner.clusterCode;
    const clusterName = colMap.has('cluster_name')
      ? readCellText(getCell(sheet, r, colMap.get('cluster_name')!)) || banner.clusterName
      : banner.clusterName;
    const schoolName = colMap.has('school')
      ? readCellText(getCell(sheet, r, colMap.get('school')!)) || banner.schoolName || ''
      : banner.schoolName || '';

    seenTeacherCodes.add(teacherCode);
    seenUdiseCodes.add(schoolUdise);
    idLengths[teacherCode.length] = (idLengths[teacherCode.length] ?? 0) + 1;

    teachers.push({
      rowNumber,
      teacherCode,
      fullName,
      teacherTitle,
      mobileLast4,
      mobileHash,
      districtCode,
      districtName,
      blockCode,
      blockName,
      clusterCode,
      clusterName,
      schoolUdise,
      schoolName,
    });
  }

  if (seenUdiseCodes.size > 1) {
    errors.push(
      `Multiple School UDISE Codes detected in one Teacher List file (${Array.from(seenUdiseCodes).join(', ')}). Upload one school per file.`
    );
  }

  const first = teachers[0];
  const schoolMeta = {
    udiseCode: first?.schoolUdise ?? banner.udiseCode,
    schoolName: banner.schoolName ?? first?.schoolName ?? null,
    districtCode: first?.districtCode ?? banner.districtCode,
    districtName: first?.districtName ?? banner.districtName,
    blockCode: first?.blockCode ?? banner.blockCode,
    blockName: first?.blockName ?? banner.blockName,
    clusterCode: first?.clusterCode ?? banner.clusterCode,
    clusterName: first?.clusterName ?? banner.clusterName,
  };

  return {
    ok: errors.length === 0 && teachers.length > 0,
    banner,
    headerRowNumber: headerRowIdx + 1,
    schoolMeta,
    teachers,
    skippedRows,
    errors,
    warnings,
    stats: {
      totalDataRows,
      parsedTeachers: teachers.length,
      withValidMobileLast4,
      idLengths,
    },
  };
}

// =============================================================================
// 5. SAFE DRY-RUN DIFF ENGINE (STUDENTS & TEACHERS)
// =============================================================================

export interface ExistingSchoolStudentSnapshot {
  id: string;
  student_code: string | null;
  school_udise: string;
  student_name: string;
  father_name: string | null;
  dob: string;
  gender: string | null;
  class_num: ClassNum;
  roll_no: number;
  is_active: boolean;
}

export interface StudentUpdateCandidate {
  existingId: string;
  row: ParsedStudentRow;
  changedFields: string[];
  reactivating: boolean;
}

export interface StudentSyncDiffResult {
  toAdd: ParsedStudentRow[];
  toUpdate: StudentUpdateCandidate[];
  unchangedCount: number;
  missingActive: ExistingSchoolStudentSnapshot[];
  crossSchoolConflicts: SyncConflictItem[];
  skippedRows: SkippedExcelRow[];
  schoolNameMismatchCount: number;
  warnings: string[];
}

/**
 * Computes a safe dry-run diff for Student e-Shikshakosh sync.
 * - Blocks silent cross-school hijack of students active in another school.
 * - Preserves app-only fields (`stream`, `subjects_configured`, `pin_hash`, XP, streaks).
 * - Reports missing active students for explicit admin confirmation (never auto-deletes).
 */
export function computeStudentSyncDiff(params: {
  targetSchoolUdise: string;
  targetSchoolName: string;
  parsedResult: StudentExcelParseResult;
  existingSchoolStudents: ReadonlyArray<ExistingSchoolStudentSnapshot>;
  crossSchoolActiveStudents: ReadonlyArray<{
    student_code: string;
    school_udise: string;
    student_name: string;
  }>;
}): StudentSyncDiffResult {
  const {
    targetSchoolUdise,
    targetSchoolName,
    parsedResult,
    existingSchoolStudents,
    crossSchoolActiveStudents,
  } = params;

  const existingByCode = new Map<string, ExistingSchoolStudentSnapshot>();
  for (const s of existingSchoolStudents) {
    if (s.student_code) existingByCode.set(s.student_code.trim(), s);
  }

  const crossSchoolByCode = new Map<string, { school_udise: string; student_name: string }>();
  for (const cs of crossSchoolActiveStudents) {
    if (cs.school_udise !== targetSchoolUdise) {
      crossSchoolByCode.set(cs.student_code.trim(), {
        school_udise: cs.school_udise,
        student_name: cs.student_name,
      });
    }
  }

  const toAdd: ParsedStudentRow[] = [];
  const toUpdate: StudentUpdateCandidate[] = [];
  const crossSchoolConflicts: SyncConflictItem[] = [];
  const warnings: string[] = [...parsedResult.warnings];
  const seenSchoolStudentIds = new Set<string>();

  let unchangedCount = 0;
  let schoolNameMismatchCount = 0;

  if (parsedResult.banner.schoolName && targetSchoolName) {
    const bannerMatch = matchSchoolNames(parsedResult.banner.schoolName, targetSchoolName);
    if (!bannerMatch.matched) {
      warnings.push(
        `Uploaded Student Excel banner school ("${parsedResult.banner.schoolName}") does not match target school ("${targetSchoolName}"). Verify you selected the right file.`
      );
    }
  }

  for (const row of parsedResult.students) {
    if (row.schoolName && targetSchoolName) {
      const m = matchSchoolNames(row.schoolName, targetSchoolName);
      if (!m.matched) {
        schoolNameMismatchCount++;
      }
    }

    // Block silent cross-school hijack of an active student at another school
    const crossConflict = crossSchoolByCode.get(row.studentCode);
    if (crossConflict) {
      crossSchoolConflicts.push({
        row_number: row.rowNumber,
        code: row.studentCode,
        name: row.studentName,
        reason: 'ACTIVE_IN_ANOTHER_SCHOOL',
        existing_school_udise: crossConflict.school_udise,
      });
      continue;
    }

    const existing = existingByCode.get(row.studentCode);
    if (!existing) {
      toAdd.push(row);
      continue;
    }

    seenSchoolStudentIds.add(existing.id);

    const changedFields: string[] = [];
    if (existing.student_name.trim() !== row.studentName.trim()) changedFields.push('student_name');
    if ((existing.father_name ?? '').trim() !== (row.fatherName ?? '').trim()) {
      changedFields.push('father_name');
    }
    if (existing.dob.slice(0, 10) !== row.dob) changedFields.push('dob');
    if ((existing.gender ?? '') !== (row.gender ?? '')) changedFields.push('gender');
    if (existing.class_num !== row.classNum) changedFields.push('class_num');
    if (existing.roll_no !== row.rollNo) changedFields.push('roll_no');
    const reactivating = !existing.is_active;
    if (reactivating) changedFields.push('is_active');

    if (changedFields.length > 0) {
      toUpdate.push({
        existingId: existing.id,
        row,
        changedFields,
        reactivating,
      });
    } else {
      unchangedCount++;
    }
  }

  if (schoolNameMismatchCount > 0) {
    warnings.push(
      `${schoolNameMismatchCount} row(s) have a School column name that does not match "${targetSchoolName}".`
    );
  }

  const missingActive = existingSchoolStudents.filter(
    (s) => s.is_active && !seenSchoolStudentIds.has(s.id)
  );

  return {
    toAdd,
    toUpdate,
    unchangedCount,
    missingActive,
    crossSchoolConflicts,
    skippedRows: parsedResult.skippedRows,
    schoolNameMismatchCount,
    warnings,
  };
}

export interface ExistingSchoolTeacherSnapshot {
  teacher_id: string;
  teacher_code: string;
  full_name: string;
  teacher_title: string | null;
  mobile_last4: string | null;
  mobile_hash: string | null;
  is_school_admin: boolean;
  is_active: boolean;
}

export interface TeacherUpdateCandidate {
  existingTeacherId: string;
  row: ParsedTeacherRow;
  changedFields: string[];
  reactivating: boolean;
}

export interface TeacherSyncDiffResult {
  toAdd: ParsedTeacherRow[];
  toUpdate: TeacherUpdateCandidate[];
  unchangedCount: number;
  missingActive: ExistingSchoolTeacherSnapshot[];
  crossSchoolConflicts: SyncConflictItem[];
  blockedAdminDeactivations: ExistingSchoolTeacherSnapshot[];
  canDeactivateAllMissing: boolean;
  skippedRows: SkippedExcelRow[];
  warnings: string[];
}

/**
 * Computes a safe dry-run diff for Teacher e-Shikshakosh sync.
 * - Verifies UDISE match against `targetSchoolUdise`.
 * - Blocks silent cross-school hijack of any teacher active at another school (single-active-school invariant).
 * - Blocks deactivating the last active School Admin!
 */
export function computeTeacherSyncDiff(params: {
  targetSchoolUdise: string;
  parsedResult: TeacherExcelParseResult;
  existingSchoolTeachers: ReadonlyArray<ExistingSchoolTeacherSnapshot>;
  crossSchoolActiveTeachers: ReadonlyArray<{
    teacher_code: string;
    school_udise: string;
    full_name: string;
  }>;
}): TeacherSyncDiffResult {
  const {
    targetSchoolUdise,
    parsedResult,
    existingSchoolTeachers,
    crossSchoolActiveTeachers,
  } = params;

  const existingByCode = new Map<string, ExistingSchoolTeacherSnapshot>();
  for (const t of existingSchoolTeachers) {
    existingByCode.set(t.teacher_code.trim(), t);
  }

  const crossByCode = new Map<string, { school_udise: string; full_name: string }>();
  for (const ct of crossSchoolActiveTeachers) {
    if (ct.school_udise !== targetSchoolUdise) {
      crossByCode.set(ct.teacher_code.trim(), {
        school_udise: ct.school_udise,
        full_name: ct.full_name,
      });
    }
  }

  const toAdd: ParsedTeacherRow[] = [];
  const toUpdate: TeacherUpdateCandidate[] = [];
  const crossSchoolConflicts: SyncConflictItem[] = [];
  const warnings: string[] = [...parsedResult.warnings];
  const seenTeacherIds = new Set<string>();
  let unchangedCount = 0;

  for (const row of parsedResult.teachers) {
    if (row.schoolUdise !== targetSchoolUdise) {
      crossSchoolConflicts.push({
        row_number: row.rowNumber,
        code: row.teacherCode,
        name: row.fullName,
        reason: 'UDISE_MISMATCH',
        existing_school_udise: row.schoolUdise,
      });
      continue;
    }

    const crossActive = crossByCode.get(row.teacherCode);
    if (crossActive) {
      crossSchoolConflicts.push({
        row_number: row.rowNumber,
        code: row.teacherCode,
        name: row.fullName,
        reason: 'ACTIVE_IN_ANOTHER_SCHOOL',
        existing_school_udise: crossActive.school_udise,
      });
      continue;
    }

    const existing = existingByCode.get(row.teacherCode);
    if (!existing) {
      toAdd.push(row);
      continue;
    }

    seenTeacherIds.add(existing.teacher_id);

    const changedFields: string[] = [];
    if (existing.full_name.trim() !== row.fullName.trim()) changedFields.push('full_name');
    if ((existing.teacher_title ?? '').trim() !== (row.teacherTitle ?? '').trim()) {
      changedFields.push('teacher_title');
    }
    if (row.mobileLast4 && existing.mobile_last4 !== row.mobileLast4) {
      changedFields.push('mobile_last4');
    }
    if (row.mobileHash && existing.mobile_hash !== row.mobileHash) {
      changedFields.push('mobile_hash');
    }
    const reactivating = !existing.is_active;
    if (reactivating) changedFields.push('is_active');

    if (changedFields.length > 0) {
      toUpdate.push({
        existingTeacherId: existing.teacher_id,
        row,
        changedFields,
        reactivating,
      });
    } else {
      unchangedCount++;
    }
  }

  const missingActive = existingSchoolTeachers.filter(
    (t) => t.is_active && !seenTeacherIds.has(t.teacher_id)
  );

  // Critical safety invariant: NEVER allow deactivating the last active School Admin!
  const remainingActiveAdmins = existingSchoolTeachers.filter(
    (t) => t.is_active && t.is_school_admin && seenTeacherIds.has(t.teacher_id)
  );
  const missingActiveAdmins = missingActive.filter((t) => t.is_school_admin);

  const blockedAdminDeactivations: ExistingSchoolTeacherSnapshot[] = [];
  if (remainingActiveAdmins.length === 0 && missingActiveAdmins.length > 0) {
    blockedAdminDeactivations.push(...missingActiveAdmins);
    warnings.push(
      'Cannot deactivate all remaining School Admins. Promote another active teacher to School Admin before deactivating the last School Admin.'
    );
  }

  return {
    toAdd,
    toUpdate,
    unchangedCount,
    missingActive,
    crossSchoolConflicts,
    blockedAdminDeactivations,
    canDeactivateAllMissing: blockedAdminDeactivations.length === 0,
    skippedRows: parsedResult.skippedRows,
    warnings,
  };
}

// =============================================================================
// 6. FORMULA-INJECTION-SAFE MARKSHEET .XLSX EXPORTER
// =============================================================================

const FORMULA_TRIGGER_REGEX = /^[\s\t\r]*[=+\-@]|^[\t\r]/;
const CONTROL_CHARS_REGEX = /[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]/g;

/**
 * Neutralizes Excel/CSV formula injection (DDE / `=CMD|...`, `+`, `-`, `@`, `\t`, `\r`)
 * by prefixing dangerous string values with a literal quote `'`.
 */
export function sanitizeExcelCell(
  value: string | number | boolean | null | undefined
): string | number | boolean {
  if (value === null || value === undefined) return '';
  if (typeof value === 'number') {
    return Number.isFinite(value) ? value : '';
  }
  if (typeof value === 'boolean') return value;

  const cleaned = String(value).replace(CONTROL_CHARS_REGEX, '');
  if (FORMULA_TRIGGER_REGEX.test(cleaned)) {
    return `'${cleaned}`;
  }
  return cleaned;
}

export interface SafeMarksheetExportOptions {
  sheetName: string;
  title?: string;
  subtitle?: string;
  headers: ReadonlyArray<string>;
  rows: ReadonlyArray<ReadonlyArray<string | number | boolean | null | undefined>>;
}

/**
 * Generates a formula-injection-safe `.xlsx` Buffer for school exam marksheets & rosters.
 */
export function exportSafeMarksheetXlsx(options: SafeMarksheetExportOptions): Buffer {
  const safeSheetName =
    options.sheetName
      .replace(/[\\/?*[\]:]/g, ' ')
      .trim()
      .slice(0, 31) || 'Marksheet';

  const aoa: Array<Array<string | number | boolean>> = [];

  if (options.title) {
    aoa.push([sanitizeExcelCell(options.title)]);
  }
  if (options.subtitle) {
    aoa.push([sanitizeExcelCell(options.subtitle)]);
  }
  if (options.title || options.subtitle) {
    aoa.push([]);
  }

  aoa.push(options.headers.map((h) => sanitizeExcelCell(h)));

  for (const row of options.rows) {
    aoa.push(row.map((cell) => sanitizeExcelCell(cell)));
  }

  const worksheet = XLSX.utils.aoa_to_sheet(aoa);

  // Compute safe auto column widths
  const colWidths = options.headers.map((h, colIdx) => {
    let maxLen = String(h).length;
    for (const row of options.rows) {
      const v = row[colIdx];
      if (v !== null && v !== undefined) {
        maxLen = Math.max(maxLen, String(v).length);
      }
    }
    return { wch: Math.min(48, Math.max(10, maxLen + 3)) };
  });
  worksheet['!cols'] = colWidths;

  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, safeSheetName);

  const out = XLSX.write(workbook, {
    type: 'buffer',
    bookType: 'xlsx',
    compression: true,
  }) as Buffer;

  return Buffer.isBuffer(out) ? out : Buffer.from(out);
}
