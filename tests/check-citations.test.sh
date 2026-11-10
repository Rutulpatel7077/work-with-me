#!/usr/bin/env bash
# Builds a tiny fake repo and report, then checks the citation checker's verdicts.
set -u
CHECK="$(cd "$(dirname "$0")/.." && pwd)/skills/explain/scripts/check-citations.sh"
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT
mkdir -p "$work/repo/src/billing"
seq 1 10 > "$work/repo/src/billing/invoice.ts"
seq 1 5 > "$work/repo/README.md"
fail=0

report() { printf '%s\n' "$1" > "$work/report.html"; }
expect() {
  want="$1"; label="$2"
  out="$(bash "$CHECK" "$work/report.html" "$work/repo" 2>&1)"; code=$?
  if [ "$want" = pass ] && [ $code -eq 0 ]; then echo "ok   $label"
  elif [ "$want" = fail ] && [ $code -ne 0 ]; then echo "ok   $label"
  else echo "FAIL $label (exit $code) -> $out"; fail=1; fi
}

report '<p>Totals in <code>src/billing/invoice.ts:3</code> and <code>README.md:5</code>.</p>'
expect pass "existing files and lines"

report '<p>Range <code>src/billing/invoice.ts:2-9</code>.</p>'
expect pass "line range inside the file"

report '<p>See <code>src/billing/invoice.ts:50</code>.</p>'
expect fail "line past end of file"

report '<p>See <code>src/billing/invoice.ts:4-40</code>.</p>'
expect fail "range past end of file"

report '<p>See <code>src/billing/missing.ts:1</code>.</p>'
expect fail "file that does not exist"

report '<script src="https://cdn.jsdelivr.net/npm/mermaid@11.4.1/dist/mermaid.esm.min.mjs"></script><p>No refs.</p>'
expect pass "URLs are not citations"

exit $fail
