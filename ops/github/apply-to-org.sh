#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./apply-to-org.sh SolLabsHQ

ORG="${1:-}"
if [[ -z "${ORG}" ]]; then
  echo "Usage: $0 <org>"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List repos in the org
REPOS="$(gh repo list "${ORG}" --limit 200 --json name --jq '.[].name')"

for repo in ${REPOS}; do
  # Skip private IP repo (Rulesets not available on current plan)
  if [[ "${repo}" == "solos-internal" ]]; then
    echo "==> ${ORG}/${repo} (skipped: rulesets not available for private repo on current plan)"
    continue
  fi

  echo "==> ${ORG}/${repo}"
  "${SCRIPT_DIR}/apply-ruleset.sh" "${ORG}" "${repo}"
done

echo "All repos processed."

