#!/usr/bin/env bash
# Pipes sample PreToolUse payloads into the cloud guard and checks its decision.
set -u
GUARD="$(cd "$(dirname "$0")/.." && pwd)/hooks/cloud-guard.sh"
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

expect_ask '"terraform apply -auto-approve"'
expect_ask '"terraform destroy"'
expect_ask '"kubectl apply -f deploy.yaml"'
expect_ask '"kubectl -n prod delete pod api-1"'
expect_ask '"kubectl rollout restart deploy/api"'
expect_ask '"helm upgrade api ./chart"'
expect_ask '"aws s3 rm s3://bucket/key"'
expect_ask '"aws ec2 terminate-instances --instance-ids i-1"'
expect_ask '"aws lambda update-function-code --function-name f"'
expect_ask '"gcloud run deploy api --source ."'
expect_ask '"gcloud compute instances delete vm-1"'
expect_ask '"az group delete -n rg"'
expect_ask '"docker push me/api:latest"'
expect_ask '"npm publish"'
expect_ask '"vercel --prod"'
expect_ask '"cd infra\nterraform apply"'
expect_ask '"echo hi\n\tkubectl delete pod x"'

expect_ask '"aws s3 cp build/ s3://site/ --recursive"'
expect_ask '"kubectl run debug --image=busybox"'
expect_ask '"kubectl exec -it api-1 -- sh"'
expect_ask '"pulumi up --yes"'
expect_ask '"docker compose push"'
expect_pass '"terraform plan"'
expect_pass '"pulumi preview"'
expect_pass '"az account set -s dev"'
expect_pass '"kubectl get pods -n prod"'
expect_pass '"kubectl describe deploy api"'
expect_pass '"kubectl logs api-1"'
expect_pass '"helm list"'
expect_pass '"aws s3 ls s3://bucket"'
expect_pass '"aws ec2 describe-instances"'
expect_pass '"gcloud run services list"'
expect_pass '"az group list"'
expect_pass '"docker build -t api ."'
expect_pass '"npm test"'
expect_pass '"git status"'
expect_pass '"kubectl get pods"' 'List pods before kubectl delete'

exit $fail
