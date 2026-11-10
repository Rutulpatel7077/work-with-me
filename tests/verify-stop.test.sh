#!/usr/bin/env bash
# Builds throwaway git repos and checks the Stop hook's decisions.
set -u
HOOK="$(cd "$(dirname "$0")/.." && pwd)/hooks/verify-stop.sh"
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT
fail=0

new_repo() {
  repo="$work/$1"; mkdir -p "$repo/.claude"
  git -C "$repo" init -q
  echo base > "$repo/app.txt"
  git -C "$repo" add . && git -C "$repo" -c user.email=t@t -c user.name=t commit -qm base
}
payload() { printf '{"hook_event_name":"Stop","cwd":"%s","stop_hook_active":%s}' "$1" "${2:-false}"; }

expect() {
  want="$1"; label="$2"; repo="$3"; active="${4:-false}"
  err="$(payload "$repo" "$active" | bash "$HOOK" 2>&1 >/dev/null)"; code=$?
  if [ "$code" = "$want" ]; then echo "ok   exit $code  $label"
  else echo "FAIL $label: want exit $want, got $code -> $err"; fail=1; fi
}

new_repo no-config
echo change >> "$work/no-config/app.txt"
expect 0 "no config: does nothing" "$work/no-config"

new_repo passing
printf '{"verify": "true"}\n' > "$work/passing/.claude/work-with-me.json"
echo change >> "$work/passing/app.txt"
expect 0 "check passes: lets Claude stop" "$work/passing"

new_repo failing
printf '{"verify": "echo 2 tests failed; exit 1"}\n' > "$work/failing/.claude/work-with-me.json"
echo change >> "$work/failing/app.txt"
expect 2 "check fails: sends Claude back" "$work/failing"
err="$(payload "$work/failing" | bash "$HOOK" 2>&1 >/dev/null)"
if printf '%s' "$err" | grep -q '2 tests failed'; then echo "ok   failure output reaches Claude"
else echo "FAIL failure output missing -> $err"; fail=1; fi

expect 0 "already continuing from this hook: no loop" "$work/failing" true

new_repo clean
printf '{"verify": "exit 1"}\n' > "$work/clean/.claude/work-with-me.json"
git -C "$work/clean" add . && git -C "$work/clean" -c user.email=t@t -c user.name=t commit -qm cfg
expect 0 "nothing changed: skips the check" "$work/clean"

exit $fail
