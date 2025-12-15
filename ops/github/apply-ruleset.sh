#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./apply-ruleset.sh SolLabsHQ infra-docs
#   ./apply-ruleset.sh SolLabsHQ solmobile

OWNER="${1:-}"
REPO="${2:-}"
RULESET_NAME="main-protection"
PAYLOAD_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/ruleset.main.json"

if [[ -z "${OWNER}" || -z "${REPO}" ]]; then
  echo "Usage: $0 <owner> <repo>"
  exit 1
fi

if [[ ! -f "${PAYLOAD_FILE}" ]]; then
  echo "Missing payload file: ${PAYLOAD_FILE}"
  exit 1
fi

# Find existing ruleset id (if any)
RULESET_ID="$(gh api \
  -H "Accept: application/vnd.github+json" \
  "/repos/${OWNER}/${REPO}/rulesets" \
  --jq ".[] | select(.name==\"${RULESET_NAME}\") | .id" 2>/dev/null || true)"

if [[ -z "${RULESET_ID}" ]]; then
  echo "Creating ruleset '${RULESET_NAME}' on ${OWNER}/${REPO}"
  gh api \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    "/repos/${OWNER}/${REPO}/rulesets" \
    --input "${PAYLOAD_FILE}" >/dev/null
else
  echo "Updating ruleset '${RULESET_NAME}' (id=${RULESET_ID}) on ${OWNER}/${REPO}"
  gh api \
    -X PUT \
    -H "Accept: application/vnd.github+json" \
    "/repos/${OWNER}/${REPO}/rulesets/${RULESET_ID}" \
    --input "${PAYLOAD_FILE}" >/dev/null
fi

echo "Done: ${OWNER}/${REPO}"
