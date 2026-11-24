#!/usr/bin/env bash
# Prints everything a PR review starts from, in one call: scope, links, CI status,
# reviews, and comments. CI is status only; it never fetches logs.
# Usage: pr-context.sh <PR URL> | <PR number> [-R owner/repo]
set -euo pipefail

usage() { echo "usage: pr-context.sh <PR URL> | <PR number> [-R owner/repo]" >&2; exit 2; }
[ $# -ge 1 ] || usage

target="$1"; shift
repo=""
while [ $# -gt 0 ]; do
  case "$1" in
    -R) repo="${2:-}"; shift 2 || usage ;;
    *) usage ;;
  esac
done

if [[ "$target" =~ github\.com/([^/]+/[^/]+)/pull/([0-9]+) ]]; then
  repo="${BASH_REMATCH[1]}"; number="${BASH_REMATCH[2]}"
elif [[ "$target" =~ ^[0-9]+$ ]]; then
  number="$target"
  # gh otherwise reads the current directory's repo, which may not be the PR's.
  [ -n "$repo" ] || repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
else
  usage
fi

# Everything stays in variables: sandboxes often block temp folders.
export PR_JSON INLINE_JSON CHECKS BASE_JSON
PR_JSON="$(gh pr view "$number" -R "$repo" --json number,title,url,body,author,baseRefName,headRefName,headRefOid,reviews,comments)"
INLINE_JSON="$(gh api "repos/$repo/pulls/$number/comments" --paginate)"
# Exits non-zero when a check is red or pending; the table is still what we want.
CHECKS="$(gh pr checks "$number" -R "$repo" 2>&1 || true)"

base="$(python3 -I -c 'import json,os; print(json.loads(os.environ["PR_JSON"])["baseRefName"])')"
default="$(gh repo view "$repo" --json defaultBranchRef --jq .defaultBranchRef.name)"
BASE_JSON="[]"
if [ "$base" != "$default" ]; then
  BASE_JSON="$(gh pr list -R "$repo" --head "$base" --state all --json number,url --limit 1)"
fi

python3 -I - <<'PY'
import json, os, re

pr = json.loads(os.environ["PR_JSON"])
inline = json.loads(os.environ["INLINE_JSON"] or "[]")
base_prs = json.loads(os.environ["BASE_JSON"] or "[]")
checks = os.environ["CHECKS"].strip()

def one_line(text, limit=300):
    text = " ".join((text or "").split())
    return text if len(text) <= limit else text[: limit - 1] + "…"

print(f"## PR #{pr['number']}: {pr['title']}")
print(f"- Author: {pr['author']['login']}")
print(f"- Base: {pr['baseRefName']}  ←  Head: {pr['headRefName']} @ {pr['headRefOid']}")

print("\n## Links")
print(f"- PR: {pr['url']}")
print(f"- Files: {pr['url']}/files")
for base_pr in base_prs:
    print(f"- Base PR (stacked): {base_pr['url']}")
keys = sorted(set(re.findall(r"\b[A-Z][A-Z0-9]+-\d+\b", " ".join([pr["title"], pr["headRefName"], pr["body"] or ""]))))
if keys:
    print(f"- Ticket keys: {', '.join(keys)}")
sources = [("PR body", pr["body"] or "")] + [
    (f"comment by {c['author']['login']}", c.get("body") or "") for c in pr.get("comments", [])
]
seen, own = set(), pr["url"]
for source, text in sources:
    for url in re.findall(r"https?://[^\s)\]>\"'`|]+", text):
        url = url.rstrip(".,;:")
        if url in seen or url.startswith(own) or re.search(r"\.(png|jpe?g|gif|svg)(\?|$)", url) or "githubassets.com" in url:
            continue
        seen.add(url)
        print(f"- {url}  ({source})")

print("\n## CI (status only)")
print(checks or "No checks reported.")

print("\n## Reviews")
for review in pr.get("reviews", []):
    print(f"- {review['author']['login']} {review['state']}: {one_line(review.get('body'))}")
if not pr.get("reviews"):
    print("None.")

print("\n## Comments")
for comment in pr.get("comments", []):
    print(f"- {comment['author']['login']}: {one_line(comment.get('body'))}")
if not pr.get("comments"):
    print("None.")

print("\n## Inline review comments")
for comment in inline:
    where = f"{comment.get('path')}:{comment.get('line') or comment.get('original_line') or '?'}"
    print(f"- {where} {comment['user']['login']}: {one_line(comment.get('body'))}")
if not inline:
    print("None.")
PY
