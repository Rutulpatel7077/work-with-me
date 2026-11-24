#!/usr/bin/env bash
# Writes ./bin/gh: a stub GitHub CLI for review cases, serving one PR on acme/shop.
# Usage: bash write-gh-stub.sh <pr.json> <checks.txt>
#   pr.json     what `gh pr view` returns (number, title, url, body, author, baseRefName, headRefName, reviews, comments)
#   checks.txt  what `gh pr checks` prints, tab-separated; any "fail" row makes it exit 8 like the real CLI
set -e
mkdir -p bin .gh-stub
cp "$1" .gh-stub/pr.json
cp "$2" .gh-stub/checks.txt
cat > bin/gh <<'G'
#!/usr/bin/env bash
dir="$(cd "$(dirname "$0")/.." && pwd)/.gh-stub"
case "$*" in
  *"repo view"*nameWithOwner*) echo "acme/shop" ;;
  *"repo view"*defaultBranchRef.name*) echo "main" ;;
  *"repo view"*) echo '{"defaultBranchRef":{"name":"main"},"nameWithOwner":"acme/shop"}' ;;
  *"pr view"*) python3 -c 'import json,subprocess,sys; d=json.load(open(sys.argv[1])); d["headRefOid"]=subprocess.check_output(["git","rev-parse","HEAD"],text=True).strip(); print(json.dumps(d))' "$dir/pr.json" ;;
  *"pr diff"*) git diff main...HEAD ;;
  *"pr list"*--json*) echo "[]" ;;
  *"pr list"*) python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(f"{d[\"number\"]}\t{d[\"title\"]}\t{d[\"headRefName\"]}\tOPEN")' "$dir/pr.json" ;;
  *"pr checks"*) cat "$dir/checks.txt"; grep -q "	fail	" "$dir/checks.txt" && exit 8; exit 0 ;;
  *"run view"*|*"run list"*) printf 'lint\tRun eslint\t2026-01-01T00:00:00Z ##[error] src/legacy/widget.js: no-unused-vars\n' ;;
  *"api "*) echo "[]" ;;
  *) echo "gh $*: not supported by this stub" >&2; exit 1 ;;
esac
G
chmod +x bin/gh
