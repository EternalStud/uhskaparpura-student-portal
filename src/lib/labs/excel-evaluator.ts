// =============================================================================
// Safe, Zero-Eval Excel Formula Evaluator & Grid Coordinate Helper
// Strictly pure recursive-descent parser — zero dynamic code execution.
// Supports: =SUM, =AVERAGE, =MAX, =MIN, =COUNT, =IF, and basic arithmetic (+,-,*,/)
// over cell references (A1, B2) and cell ranges (B2:D2).
// =============================================================================

export interface ExcelGridSpec {
  columns: string[];
  rows: Array<Array<string | number>>;
  target_cell?: string;
}

export interface ParsedCellRef {
  colIndex: number; // 0-based
  rowNumber: number; // 1-based Excel row number
}

const CELL_REF_RE = /^([A-Z])(\d+)$/;
const RANGE_REF_RE = /^([A-Z])(\d+):([A-Z])(\d+)$/;

export function colIndexToLetter(idx: number): string {
  return String.fromCharCode(65 + idx);
}

export function parseCellRef(ref: string): ParsedCellRef | null {
  const clean = ref.trim().toUpperCase();
  const match = CELL_REF_RE.exec(clean);
  if (!match) return null;
  const colIndex = match[1].charCodeAt(0) - 65;
  const rowNumber = Number(match[2]);
  if (colIndex < 0 || colIndex > 25 || !Number.isInteger(rowNumber) || rowNumber < 1) {
    return null;
  }
  return { colIndex, rowNumber };
}

/**
 * Determines whether `columns` are pure Excel letters (["A","B","C",...], so rows[0] is Row 1)
 * or semantic header labels (["Student","Math",...], so header is Row 1 and rows[0] is Row 2).
 */
export function getExcelDataStartRow(spec: ExcelGridSpec): number {
  const colsArePureLetters =
    spec.columns.length > 0 &&
    spec.columns.every((c, idx) => c.trim().toUpperCase() === colIndexToLetter(idx));

  if (colsArePureLetters) {
    return 1;
  }

  // If target_cell explicitly references row 1 while rows exist, avoid negative index
  if (spec.target_cell) {
    const parsed = parseCellRef(spec.target_cell);
    if (parsed && parsed.rowNumber === 1) {
      return 1;
    }
  }
  return 2;
}

/**
 * Expands a `highlight_range` array that may contain individual cells (["B2","C2","D2"])
 * or range strings (["B2:D2"]) into a normalized Set of uppercase cell keys ("B2", "C2", "D2").
 */
export function expandHighlightCells(highlightRange: string[]): Set<string> {
  const out = new Set<string>();
  for (const item of highlightRange) {
    const clean = item.trim().toUpperCase();
    const rangeMatch = RANGE_REF_RE.exec(clean);
    if (rangeMatch) {
      const c1 = rangeMatch[1].charCodeAt(0) - 65;
      const r1 = Number(rangeMatch[2]);
      const c2 = rangeMatch[3].charCodeAt(0) - 65;
      const r2 = Number(rangeMatch[4]);
      const minC = Math.min(c1, c2);
      const maxC = Math.max(c1, c2);
      const minR = Math.min(r1, r2);
      const maxR = Math.max(r1, r2);
      for (let r = minR; r <= maxR; r++) {
        for (let c = minC; c <= maxC; c++) {
          out.add(`${colIndexToLetter(c)}${r}`);
        }
      }
    } else if (CELL_REF_RE.test(clean)) {
      out.add(clean);
    }
  }
  return out;
}

export function getCellRawValue(
  spec: ExcelGridSpec,
  colIndex: number,
  rowNumber: number
): string | number | undefined {
  const startRow = getExcelDataStartRow(spec);
  if (startRow === 2 && rowNumber === 1) {
    return spec.columns[colIndex];
  }
  const arrayRowIdx = rowNumber - startRow;
  if (arrayRowIdx < 0 || arrayRowIdx >= spec.rows.length) return undefined;
  const row = spec.rows[arrayRowIdx];
  if (!row || colIndex < 0 || colIndex >= row.length) return undefined;
  return row[colIndex];
}

function getNumericValue(val: string | number | undefined): number | null {
  if (typeof val === "number" && Number.isFinite(val)) return val;
  if (typeof val === "string") {
    const trimmed = val.trim();
    if (trimmed === "") return null;
    const n = Number(trimmed);
    return Number.isFinite(n) ? n : null;
  }
  return null;
}

function splitTopLevelArgs(argStr: string): string[] {
  const parts: string[] = [];
  let depth = 0;
  let inQuotes = false;
  let current = "";

  for (let i = 0; i < argStr.length; i++) {
    const ch = argStr[i];
    if (ch === '"') {
      inQuotes = !inQuotes;
      current += ch;
    } else if (!inQuotes && ch === "(") {
      depth += 1;
      current += ch;
    } else if (!inQuotes && ch === ")") {
      depth -= 1;
      current += ch;
    } else if (!inQuotes && depth === 0 && ch === ",") {
      parts.push(current.trim());
      current = "";
    } else {
      current += ch;
    }
  }
  if (current.trim().length > 0) {
    parts.push(current.trim());
  }
  return parts;
}

function collectRangeNumbers(spec: ExcelGridSpec, args: string[]): number[] | null {
  const nums: number[] = [];
  for (const rawArg of args) {
    const arg = rawArg.trim().toUpperCase();
    const rangeMatch = RANGE_REF_RE.exec(arg);
    if (rangeMatch) {
      const c1 = rangeMatch[1].charCodeAt(0) - 65;
      const r1 = Number(rangeMatch[2]);
      const c2 = rangeMatch[3].charCodeAt(0) - 65;
      const r2 = Number(rangeMatch[4]);
      const minC = Math.min(c1, c2);
      const maxC = Math.max(c1, c2);
      const minR = Math.min(r1, r2);
      const maxR = Math.max(r1, r2);
      for (let r = minR; r <= maxR; r++) {
        for (let c = minC; c <= maxC; c++) {
          const n = getNumericValue(getCellRawValue(spec, c, r));
          if (n !== null) nums.push(n);
        }
      }
      continue;
    }

    const cellRef = parseCellRef(arg);
    if (cellRef) {
      const n = getNumericValue(getCellRawValue(spec, cellRef.colIndex, cellRef.rowNumber));
      if (n !== null) nums.push(n);
      continue;
    }

    const lit = Number(arg);
    if (Number.isFinite(lit) && arg !== "") {
      nums.push(lit);
      continue;
    }

    return null;
  }
  return nums;
}

// Strict recursive-descent arithmetic parser (numbers, cell refs, +, -, *, /, parentheses)
function evaluateSimpleArithmetic(expr: string, spec: ExcelGridSpec): number | null {
  const tokens: string[] = [];
  let i = 0;
  const s = expr.replace(/\s+/g, "").toUpperCase();

  while (i < s.length) {
    const ch = s[i];
    if ("+-*/()".includes(ch)) {
      tokens.push(ch);
      i += 1;
      continue;
    }
    const cellMatch = /^[A-Z]\d+/.exec(s.slice(i));
    if (cellMatch) {
      tokens.push(cellMatch[0]);
      i += cellMatch[0].length;
      continue;
    }
    const numMatch = /^\d+(?:\.\d+)?/.exec(s.slice(i));
    if (numMatch) {
      tokens.push(numMatch[0]);
      i += numMatch[0].length;
      continue;
    }
    return null;
  }

  let pos = 0;
  const peek = () => tokens[pos];
  const consume = () => tokens[pos++];

  function parseExpr(): number | null {
    let left = parseTerm();
    if (left === null) return null;
    while (peek() === "+" || peek() === "-") {
      const op = consume();
      const right = parseTerm();
      if (right === null) return null;
      left = op === "+" ? left + right : left - right;
    }
    return left;
  }

  function parseTerm(): number | null {
    let left = parseFactor();
    if (left === null) return null;
    while (peek() === "*" || peek() === "/") {
      const op = consume();
      const right = parseFactor();
      if (right === null) return null;
      if (op === "/") {
        if (right === 0) return null;
        left = left / right;
      } else {
        left = left * right;
      }
    }
    return left;
  }

  function parseFactor(): number | null {
    const tok = peek();
    if (!tok) return null;
    if (tok === "(") {
      consume();
      const inner = parseExpr();
      if (inner === null || consume() !== ")") return null;
      return inner;
    }
    if (tok === "-") {
      consume();
      const val = parseFactor();
      return val === null ? null : -val;
    }
    consume();
    const cell = parseCellRef(tok);
    if (cell) {
      return getNumericValue(getCellRawValue(spec, cell.colIndex, cell.rowNumber));
    }
    const num = Number(tok);
    return Number.isFinite(num) ? num : null;
  }

  const res = parseExpr();
  if (res === null || pos !== tokens.length) return null;
  return res;
}

function unquoteExcelLiteral(raw: string): string {
  const trimmed = raw.trim();
  if (
    (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
    (trimmed.startsWith("'") && trimmed.endsWith("'"))
  ) {
    return trimmed.slice(1, -1);
  }
  return trimmed;
}

function formatComputedNumber(n: number): string {
  if (Number.isInteger(n)) return String(n);
  return String(Number(n.toFixed(2)));
}

export interface ExcelEvalResult {
  ok: boolean;
  value?: string;
  errorHi?: string;
  errorEn?: string;
}

/**
 * Safely evaluates an Excel formula string against the provided grid.
 */
export function evaluateSafeExcelFormula(
  rawFormula: string,
  spec: ExcelGridSpec
): ExcelEvalResult {
  const trimmed = rawFormula.trim();
  if (!trimmed.startsWith("=")) {
    return {
      ok: false,
      errorHi: "हर Excel फॉर्मूला '=' चिह्न से शुरू होना चाहिए।",
      errorEn: "Every Excel formula must begin with the '=' sign.",
    };
  }

  const body = trimmed.slice(1).trim();
  if (!body) {
    return {
      ok: false,
      errorHi: "कृपया '=' के बाद फॉर्मूला लिखें।",
      errorEn: "Please write a formula after '='.",
    };
  }

  // Match standard function call: FUNC(args)
  const fnMatch = /^([A-Za-z]+)\s*\(([\s\S]*)\)$/.exec(body);
  if (fnMatch) {
    const fnName = fnMatch[1].toUpperCase();
    const argsStr = fnMatch[2];
    const args = splitTopLevelArgs(argsStr);

    if (fnName === "SUM") {
      const nums = collectRangeNumbers(spec, args);
      if (!nums || nums.length === 0) {
        return {
          ok: false,
          errorHi: "SUM के अंदर सही सेल रेंज (जैसे B2:D2) लिखें।",
          errorEn: "Enter a valid cell range inside SUM (e.g. B2:D2).",
        };
      }
      return { ok: true, value: formatComputedNumber(nums.reduce((a, b) => a + b, 0)) };
    }

    if (fnName === "AVERAGE" || fnName === "AVG") {
      const nums = collectRangeNumbers(spec, args);
      if (!nums || nums.length === 0) {
        return {
          ok: false,
          errorHi: "AVERAGE के अंदर सही सेल रेंज लिखें।",
          errorEn: "Enter a valid cell range inside AVERAGE.",
        };
      }
      const avg = nums.reduce((a, b) => a + b, 0) / nums.length;
      return { ok: true, value: formatComputedNumber(avg) };
    }

    if (fnName === "MAX") {
      const nums = collectRangeNumbers(spec, args);
      if (!nums || nums.length === 0) {
        return {
          ok: false,
          errorHi: "MAX के अंदर सही सेल रेंज लिखें।",
          errorEn: "Enter a valid cell range inside MAX.",
        };
      }
      return { ok: true, value: formatComputedNumber(Math.max(...nums)) };
    }

    if (fnName === "MIN") {
      const nums = collectRangeNumbers(spec, args);
      if (!nums || nums.length === 0) {
        return {
          ok: false,
          errorHi: "MIN के अंदर सही सेल रेंज लिखें।",
          errorEn: "Enter a valid cell range inside MIN.",
        };
      }
      return { ok: true, value: formatComputedNumber(Math.min(...nums)) };
    }

    if (fnName === "COUNT") {
      const nums = collectRangeNumbers(spec, args);
      if (!nums) {
        return {
          ok: false,
          errorHi: "COUNT के अंदर सही सेल रेंज लिखें।",
          errorEn: "Enter a valid cell range inside COUNT.",
        };
      }
      return { ok: true, value: String(nums.length) };
    }

    if (fnName === "IF") {
      if (args.length !== 3) {
        return {
          ok: false,
          errorHi: 'IF फॉर्मूला में 3 भाग होते हैं: =IF(शर्त, "सही", "गलत")',
          errorEn: 'IF requires 3 parts: =IF(condition, "TrueValue", "FalseValue")',
        };
      }
      const condMatch = /^(.+?)(>=|<=|<>|!=|=|>|<)(.+)$/.exec(args[0].trim());
      if (!condMatch) {
        return {
          ok: false,
          errorHi: "IF की शर्त सही से लिखें (जैसे E2>=150)।",
          errorEn: "Check the IF condition syntax (e.g. E2>=150).",
        };
      }
      const leftVal = evaluateSimpleArithmetic(condMatch[1], spec);
      const op = condMatch[2];
      const rightVal = evaluateSimpleArithmetic(condMatch[3], spec);
      if (leftVal === null || rightVal === null) {
        return {
          ok: false,
          errorHi: "शर्त में दिए गए सेल का मान संख्या होना चाहिए।",
          errorEn: "Condition operands must resolve to numbers.",
        };
      }
      let condTrue = false;
      if (op === ">=") condTrue = leftVal >= rightVal;
      else if (op === "<=") condTrue = leftVal <= rightVal;
      else if (op === ">") condTrue = leftVal > rightVal;
      else if (op === "<") condTrue = leftVal < rightVal;
      else if (op === "=") condTrue = leftVal === rightVal;
      else if (op === "<>" || op === "!=") condTrue = leftVal !== rightVal;

      const chosen = condTrue ? args[1] : args[2];
      return { ok: true, value: unquoteExcelLiteral(chosen) };
    }

    return {
      ok: false,
      errorHi: `फ़ंक्शन "${fnName}" यहाँ समर्थित नहीं है। SUM, AVERAGE, MAX, MIN, COUNT या IF का प्रयोग करें।`,
      errorEn: `Function "${fnName}" is not supported here. Try SUM, AVERAGE, MAX, MIN, COUNT, or IF.`,
    };
  }

  // Fallback: safe arithmetic expression like =B2+C2+D2
  const arith = evaluateSimpleArithmetic(body, spec);
  if (arith !== null) {
    return { ok: true, value: formatComputedNumber(arith) };
  }

  return {
    ok: false,
    errorHi: "फॉर्मूला का प्रारूप जाँचें (जैसे =SUM(B2:D2) और बंद कोष्ठक ')' न भूलें)।",
    errorEn: "Check your formula syntax (e.g. =SUM(B2:D2) with a closing parenthesis).",
  };
}

export function normalizeExcelFormulaText(raw: string): string {
  return raw.replace(/\s+/g, "").toUpperCase();
}

/**
 * Checks whether a student's Excel formula matches any accepted formula
 * OR safely evaluates to the exact expected value while using a valid formula.
 */
export function validateExcelSubmission(params: {
  submittedFormula: string;
  acceptedFormulas: string[];
  expectedValue: string;
  spec: ExcelGridSpec;
}): { isCorrect: boolean; evaluated: ExcelEvalResult } {
  const normSubmitted = normalizeExcelFormulaText(params.submittedFormula);
  const directMatch = params.acceptedFormulas.some(
    (acc) => normalizeExcelFormulaText(acc) === normSubmitted
  );
  const evaluated = evaluateSafeExcelFormula(params.submittedFormula, params.spec);

  if (directMatch) {
    return {
      isCorrect: true,
      evaluated: evaluated.ok ? evaluated : { ok: true, value: params.expectedValue },
    };
  }

  // Prevent hardcoded-constant bypass (e.g. typing "=240" instead of a formula using cell references)
  const formulaBody = params.submittedFormula.trim().replace(/^=/, "");
  if (evaluated.ok && !/[A-Z]\d+/i.test(formulaBody)) {
    return {
      isCorrect: false,
      evaluated: {
        ok: false,
        errorHi:
          "सीधे उत्तर संख्या न लिखें — सेल संदर्भ (जैसे B2:D2) के साथ फॉर्मूला बनाएँ ताकि डेटा बदलने पर उत्तर अपने आप अपडेट हो!",
        errorEn:
          "Don't type a hardcoded number — use cell references (like B2:D2) so Excel recalculates automatically!",
      },
    };
  }

  if (evaluated.ok && evaluated.value !== undefined) {
    const valClean = evaluated.value.trim().toLowerCase();
    const expClean = params.expectedValue.trim().toLowerCase();
    if (valClean === expClean) {
      return { isCorrect: true, evaluated };
    }
    // Numeric tolerance for decimal formatting (e.g. "80" vs "80.0")
    const valNum = Number(valClean);
    const expNum = Number(expClean);
    if (Number.isFinite(valNum) && Number.isFinite(expNum) && Math.abs(valNum - expNum) < 0.01) {
      return { isCorrect: true, evaluated };
    }
  }

  return { isCorrect: false, evaluated };
}
