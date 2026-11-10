#!/usr/bin/env bash
# PreToolUse guard: commits, pushes and PR/repo creation need a human yes.
# Reads the hook payload on stdin. Prints nothing to let the call through.
command="$(sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')"
# JSON keeps line breaks and tabs as \n and \t. Treat each line as its own command.
command="$(printf '%s' "$command" | sed -E 's/\\[nr]/; /g; s/\\t/ /g')"

start='(^|[^[:alnum:]_-])'
end='([^[:alnum:]_-]|$)'
writes=(
  "${start}git([[:space:]].*)?[[:space:]](commit|push)${end}"
  "${start}gh[[:space:]].*(pr[[:space:]]+(create|merge)|repo[[:space:]]+create)${end}"
)
safe=(
  "${start}git[[:space:]].*stash[[:space:]]+push${end}"
)

matches_any() {
  local segment="$1"; shift
  for pattern in "$@"; do
    printf '%s' "$segment" | grep -Eq "$pattern" && return 0
  done
  return 1
}

while IFS= read -r segment; do
  if matches_any "$segment" "${writes[@]}" && ! matches_any "$segment" "${safe[@]}"; then
    cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "work-with-me: commits, pushes and PRs wait for human review. Summarize the change before approving."
  }
}
JSON
    exit 0
  fi
done < <(printf '%s\n' "$command" | tr ';&|' '\n\n\n')
exit 0
