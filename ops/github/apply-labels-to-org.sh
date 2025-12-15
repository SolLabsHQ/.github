#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./apply-labels-to-org.sh SolLabsHQ

ORG="${1:-}"
if [[ -z "${ORG}" ]]; then
  echo "Usage: $0 <org>"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS="$(gh repo list "${ORG}" --limit 200 --json name --jq '.[].name')"

FAILED=0
for repo in ${REPOS}; do
  # Keep your private repo clean and hands-off unless you want it included
  if [[ "${repo}" == "solos-internal" ]]; then
    echo "==> ${ORG}/${repo} (skipped)"
    continue
  fi

  echo "==> ${ORG}/${repo}"
  if ! "${SCRIPT_DIR}/apply-labels.sh" "${ORG}" "${repo}"; then
    echo "WARN: failed ${ORG}/${repo}"
    FAILED=$((FAILED+1))
  fi
done

echo "All repos processed. Failures: ${FAILED}"
