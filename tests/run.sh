#!/usr/bin/env bash
# Runs every check for this plugin. Use before asking for review.
set -e
cd "$(dirname "$0")/.."
bash tests/git-guard.test.sh
bash tests/cloud-guard.test.sh
bash tests/check-citations.test.sh
bash tests/verify-stop.test.sh
for f in .claude-plugin/*.json hooks/hooks.json; do python3 -m json.tool "$f" >/dev/null && echo "ok   json  $f"; done
bash hooks/session-start.sh | python3 -m json.tool >/dev/null && echo "ok   json  session-start output"
context_size="$(bash hooks/session-start.sh | python3 -c 'import json,sys; print(len(json.load(sys.stdin)["hookSpecificOutput"]["additionalContext"]))')"
[ "$context_size" -le 1500 ] && echo "ok   size  session-start context is $context_size chars" || { echo "FAIL session-start context is $context_size chars, keep it under 1500"; exit 1; }
if command -v claude >/dev/null; then claude plugin validate . ; fi
