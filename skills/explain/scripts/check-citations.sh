#!/usr/bin/env bash
# Checks every file:line or file:start-end citation in a report against a repo.
# Usage: check-citations.sh <report-file> <repo-root>
# Prints each broken citation and exits 1 if any. Exits 0 when all resolve.
set -u
report="$1"; root="$2"
broken=0; total=0

citations="$(grep -oE '[A-Za-z0-9_./-]+\.[A-Za-z0-9]+:[0-9]+(-[0-9]+)?' "$report" | sort -u)"

for citation in $citations; do
  total=$((total + 1))
  path="${citation%%:*}"
  lines="${citation#*:}"
  last="${lines#*-}"
  file="$root/$path"
  if [ ! -f "$file" ]; then
    echo "missing file   $citation"; broken=$((broken + 1)); continue
  fi
  length="$(wc -l < "$file" | tr -d ' ')"
  if [ "$last" -gt "$length" ]; then
    echo "past end ($length lines)   $citation"; broken=$((broken + 1))
  fi
done

echo "$total citations checked, $broken broken"
[ "$broken" -eq 0 ]
