#!/usr/bin/env bash
# PreToolUse guard: commands that change cloud resources, clusters, or published
# packages need a human yes. Read-only commands (list, get, describe, plan) pass.
command="$(sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')"
# JSON keeps line breaks and tabs as \n and \t. Treat each line as its own command.
command="$(printf '%s' "$command" | sed -E 's/\\[nr]/; /g; s/\\t/ /g')"

start='(^|[^[:alnum:]_-])'
end='([^[:alnum:]_-]|$)'
writes=(
  "${start}terraform([[:space:]].*)?[[:space:]](apply|destroy|import|taint|state[[:space:]]+(rm|mv|push))${end}"
  "${start}(pulumi|tofu)([[:space:]].*)?[[:space:]](up|apply|destroy|import|refresh|cancel)${end}"
  "${start}kubectl([[:space:]].*)?[[:space:]](apply|create|delete|edit|patch|replace|scale|set|label|annotate|drain|cordon|taint|run|exec|cp|rollout[[:space:]]+(restart|undo))${end}"
  "${start}helm([[:space:]].*)?[[:space:]](install|upgrade|uninstall|delete|rollback)${end}"
  "${start}aws([[:space:]].*)?[[:space:]](cp|rm|mv|sync|mb|rb|invoke|(create|delete|put|update|terminate|run|start|stop|modify|reboot|attach|detach|register|deregister|deploy|tag|untag)-[a-z-]+)${end}"
  "${start}gcloud([[:space:]].*)?[[:space:]](create|delete|deploy|update|patch|resize|start|stop|reset|add-iam-policy-binding|remove-iam-policy-binding)${end}"
  "${start}az([[:space:]].*)?[[:space:]](create|delete|update|set|deploy|start|stop|restart|purge)${end}"
  "${start}docker([[:space:]]+compose)?[[:space:]]+push${end}"
  "${start}(npm|pnpm|yarn|cargo|gem|twine)[[:space:]]+(publish|push|upload)${end}"
  "${start}(fly|flyctl|firebase|netlify|wrangler|serverless|sls|cdk)([[:space:]].*)?[[:space:]](deploy|destroy|publish)${end}"
  "${start}vercel([[:space:]].*)?([[:space:]]--prod|[[:space:]]deploy|[[:space:]]remove)${end}"
)
safe=(
  "${start}az[[:space:]]+(account|config)[[:space:]]+set${end}"
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
    "permissionDecisionReason": "work-with-me: this command changes cloud resources, a cluster, or a published package. Stay read-only unless the user asked for this change."
  }
}
JSON
    exit 0
  fi
done < <(printf '%s\n' "$command" | tr ';&|' '\n\n\n')
exit 0
