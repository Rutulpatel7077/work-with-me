#!/usr/bin/env bash
# Pipes sample PreToolUse payloads into the guard and checks its decision.
set -u
GUARD="$(cd "$(dirname "$0")/.." && pwd)/hooks/git-guard.sh"
fail=0

payload() { printf '{"tool_name":"Bash","tool_input":{"command":%s,"description":"%s"}}' "$1" "${2:-Run it}"; }

expect_ask() {
  out="$(payload "$1" | bash "$GUARD")"
  if printf '%s' "$out" | grep -q '"permissionDecision": *"ask"'; then
    echo "ok   ask   $1"
  else
    echo "FAIL ask   $1 -> ${out:-<empty>}"; fail=1
  fi
}

expect_pass() {
  out="$(payload "$1" "${2:-}" | bash "$GUARD")"
  if [ -z "$out" ]; then
    echo "ok   pass  $1"
  else
    echo "FAIL pass  $1 -> $out"; fail=1
  fi
}

expect_ask '"git commit -m \"fix\""'
expect_ask '"git add . && git commit -am wip"'
expect_ask '"git push origin main"'
expect_ask '"git -C repo push"'
expect_ask '"gh pr create --fill"'
expect_ask '"gh pr merge 12"'
expect_ask '"gh repo create me/x --private --push"'
expect_ask '"cd repo\ngit push"'
expect_ask '"npm test\n\tgit commit -m x"'

expect_ask '"gh -R me/x pr create --fill"'
expect_ask '"gh --repo me/x pr merge 3"'
expect_pass '"git status"'
expect_pass '"git stash push -m wip"'
expect_pass '"git diff HEAD"'
expect_pass '"git log --oneline"'
expect_pass '"gh pr view 12 --comments"'
expect_pass '"grep -r commit src/"'
expect_pass '"npm test"'
expect_pass '"git log --oneline"' 'Show git commit history before push'

exit $fail
