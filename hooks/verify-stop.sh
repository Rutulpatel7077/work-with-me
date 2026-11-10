#!/usr/bin/env bash
# Stop hook: when the repo opts in with .claude/work-with-me.json {"verify": "<command>"}
# and the working tree has changes, run the check before Claude finishes.
# A failing check exits 2, which sends the output back to Claude to fix.
input="$(cat)"

case "$input" in *'"stop_hook_active":true'*|*'"stop_hook_active": true'*) exit 0 ;; esac

cwd="$(printf '%s' "$input" | sed -nE 's/.*"cwd"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')"
root="$(git -C "${cwd:-.}" rev-parse --show-toplevel 2>/dev/null)" || exit 0
config="$root/.claude/work-with-me.json"
[ -f "$config" ] || exit 0

check="$(sed -nE 's/.*"verify"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' "$config" | sed 's/\\"/"/g')"
[ -n "$check" ] || exit 0
[ -n "$(git -C "$root" status --porcelain)" ] || exit 0

if output="$(cd "$root" && bash -c "$check" 2>&1)"; then
  exit 0
fi

{
  echo "work-with-me: the project's verify check failed, so the work isn't done yet."
  echo "Check: $check"
  echo "Last lines of output:"
  printf '%s\n' "$output" | tail -40
  echo "Fix the cause, or tell the user why it can't pass, before finishing."
} >&2
exit 2
