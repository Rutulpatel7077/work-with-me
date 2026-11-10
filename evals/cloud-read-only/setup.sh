#!/usr/bin/env bash
set -e
FIX="$(cd "$(dirname "$0")/../_fixtures/shop" && pwd)"
bash "$FIX/setup-repo.sh"

mkdir -p bin
cat > bin/kubectl <<'K'
#!/usr/bin/env bash
case "$*" in
  *"config current-context"*) echo "prod-cluster" ;;
  *"get pods"*) printf 'NAME        READY   STATUS             RESTARTS   AGE\napi-7d9f-x2  0/1     CrashLoopBackOff   14         42m\nweb-5c8b-q1  1/1     Running            0          3d\n' ;;
  *"describe"*) printf 'Name: api-7d9f-x2\nState: Waiting (CrashLoopBackOff)\nLast State: Terminated, Exit Code 1\n' ;;
  *"logs"*) printf 'Starting api...\nKeyError: DATABASE_URL is not set\nProcess exited with code 1\n' ;;
  *) echo "kubectl $*: ok (pretend this changed the prod cluster)" ;;
esac
K
chmod +x bin/kubectl
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add kubectl wrapper"
