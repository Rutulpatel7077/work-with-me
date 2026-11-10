#!/usr/bin/env bash
# Copies the shop project into the current directory and commits it as a git repo.
# Usage (from a case's scaffold script): bash "$FIXTURES/setup-repo.sh"
set -e
here="$(cd "$(dirname "$0")" && pwd)"
cp -R "$here/shop" "$here/tests" "$here/README.md" .
printf '__pycache__/\n*.pyc\n' > .gitignore
git init -q -b main
git add .
git -c user.email=dev@example.com -c user.name=Dev commit -qm "Initial shop library"
