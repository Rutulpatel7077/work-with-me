#!/usr/bin/env bash
# Runs every check for this plugin. Use before asking for review.
set -e
cd "$(dirname "$0")/.."
bash tests/git-guard.test.sh
for f in .claude-plugin/*.json hooks/hooks.json; do python3 -m json.tool "$f" >/dev/null && echo "ok   json  $f"; done
bash hooks/session-start.sh | python3 -m json.tool >/dev/null && echo "ok   json  session-start output"
if command -v claude >/dev/null; then claude plugin validate . ; fi
