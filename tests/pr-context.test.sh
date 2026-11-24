#!/usr/bin/env bash
# Runs pr-context.sh against a stub gh and checks what it prints.
set -u
SCRIPT="$(cd "$(dirname "$0")/.." && pwd)/skills/review/scripts/pr-context.sh"
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin"
fail=0

cat > "$work/bin/gh" <<'G'
#!/usr/bin/env bash
echo "$*" >> "$GH_LOG"
case "$*" in
  "pr view 42 -R acme/shop --json "*)
    cat <<'J'
{"number":42,"title":"[ENG-123] Add free shipping","url":"https://github.com/acme/shop/pull/42",
 "body":"Adds free shipping.\n\nTicket: https://acme.atlassian.net/browse/ENG-123",
 "author":{"login":"dev1"},"baseRefName":"eng-100-base","headRefName":"eng-123-free-shipping","headRefOid":"abc1234def",
 "reviews":[{"author":{"login":"rev1"},"state":"APPROVED","body":"Looks good"}],
 "comments":[{"author":{"login":"github-actions"},"body":"Deployment was **successful**! primary url [https://shop-pr42.preview.example](https://shop-pr42.preview.example)"}]}
J
    ;;
  "repo view acme/shop --json defaultBranchRef --jq .defaultBranchRef.name") echo 'main' ;;
  "pr list -R acme/shop --head eng-100-base --state all --json number,url --limit 1") echo '[{"number":40,"url":"https://github.com/acme/shop/pull/40"}]' ;;
  "api repos/acme/shop/pulls/42/comments --paginate") echo '[{"user":{"login":"Copilot"},"path":"shop/shipping.py","line":7,"body":"Off by one at the threshold"}]' ;;
  "pr checks 42 -R acme/shop")
    printf 'unit-tests\tfail\t41s\thttps://ci.example/runs/101\nlint\tpass\t12s\thttps://ci.example/runs/102\n'
    exit 8 ;;
  *) echo "stub gh: unexpected: $*" >&2; exit 1 ;;
esac
G
chmod +x "$work/bin/gh"

run() { GH_LOG="$work/gh.log" PATH="$work/bin:$PATH" bash "$SCRIPT" "$@" 2>&1; }
has() {
  if printf '%s' "$out" | grep -qF -- "$1"; then echo "ok   $2"; else echo "FAIL $2 (missing: $1)"; fail=1; fi
}

: > "$work/gh.log"
out="$(run https://github.com/acme/shop/pull/42)"; code=$?
[ $code -eq 0 ] && echo "ok   exits 0 even when a check is red" || { echo "FAIL exit $code -> $out"; fail=1; }
has "https://github.com/acme/shop/pull/42" "links the PR"
has "https://github.com/acme/shop/pull/42/files" "links the files tab"
has "https://github.com/acme/shop/pull/40" "links the base PR of a stacked PR"
has "ENG-123" "lists the ticket key"
has "https://acme.atlassian.net/browse/ENG-123" "links the ticket URL from the body"
has "https://shop-pr42.preview.example" "links the preview URL from a bot comment"
has "eng-100-base" "shows the base branch"
has "abc1234def" "shows the head commit"
has "unit-tests" "lists CI jobs"
has "fail" "shows a red job's state"
has "shop/shipping.py:7" "lists inline comments with file and line"
has "rev1" "lists reviews"
if grep -q -- "log" "$work/gh.log" && grep -q "run view" "$work/gh.log"; then echo "FAIL fetched CI logs"; fail=1; else echo "ok   never fetches CI logs"; fi
if grep -v -- "-R acme/shop\|repos/acme/shop\|repo view acme/shop" "$work/gh.log" | grep -q .; then echo "FAIL a gh call missed the repo: $(cat "$work/gh.log")"; fail=1; else echo "ok   every gh call names the repo"; fi

out="$(TMPDIR=/nonexistent/blocked run https://github.com/acme/shop/pull/42)"; code=$?
[ $code -eq 0 ] && has "https://github.com/acme/shop/pull/40" "works when temp folders are blocked" || { echo "FAIL with blocked TMPDIR exit $code -> $out"; fail=1; }

out="$(run 42 -R acme/shop)"; code=$?
[ $code -eq 0 ] && has "https://github.com/acme/shop/pull/42/files" "accepts a number with -R" || { echo "FAIL number form exit $code -> $out"; fail=1; }

out="$(run)"; code=$?
[ $code -ne 0 ] && echo "ok   usage error without arguments" || { echo "FAIL no-arg run exited 0"; fail=1; }

exit $fail
