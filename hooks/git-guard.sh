#!/usr/bin/env bash
# PreToolUse guard: commits, pushes and PR/repo creation need a human yes.
# Reads the hook payload on stdin. Prints nothing to let the call through.
input="$(cat)"

git_write='(^|[^[:alnum:]_])git[^;&|]*[[:space:]](commit|push)([^[:alnum:]_-]|$)'
gh_write='(^|[^[:alnum:]_])gh[[:space:]]+(pr[[:space:]]+(create|merge)|repo[[:space:]]+create)([^[:alnum:]_-]|$)'

if printf '%s' "$input" | grep -Eq "$git_write|$gh_write"; then
  cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "work-with-me: commits, pushes and PRs wait for human review. Summarize the change before approving."
  }
}
JSON
fi
exit 0
