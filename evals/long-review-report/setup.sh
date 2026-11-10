#!/usr/bin/env bash
set -e
FIX="$(cd "$(dirname "$0")/../_fixtures/shop" && pwd)"
bash "$FIX/setup-repo.sh"
