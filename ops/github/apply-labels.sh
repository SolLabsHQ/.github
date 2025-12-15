#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./apply-labels.sh SolLabsHQ infra-docs

ORG="${1:-}"
REPO="${2:-}"

if [[ -z "${ORG}" || -z "${REPO}" ]]; then
  echo "Usage: $0 <org> <repo>"
  exit 1
fi

# name|color|description
LABELS=(
  "adr|5319e7|Architecture decision record"
  "task|0e8a16|Concrete work item"
  "bug|d73a4a|Something is broken"
  "docs|0075ca|Documentation changes"
  "security|b60205|Security issue or hardening"
  "debt|fbca04|Tech debt or cleanup"
  "ops|1d76db|Operations and tooling"
)

urlencode () {
  python3 - <<'PY' "$1"
import sys, urllib.parse
print(urllib.parse.quote(sys.argv[1], safe=""))
PY
}

upsert_label () {
  local name="$1"
  local color="$2"
  local desc="$3"
  local enc
  enc="$(urlencode "${name}")"

  # Try update first
  if gh api -X PATCH \
      -H "Accept: application/vnd.github+json" \
      "/repos/${ORG}/${REPO}/labels/${enc}" \
      -f "new_name=${name}" \
      -f "color=${color}" \
      -f "description=${desc}" >/dev/null 2>&1; then
    echo "updated: ${name}"
    return 0
  fi

  # If update fails (likely 404), try create
  gh api -X POST \
    -H "Accept: application/vnd.github+json" \
    "/repos/${ORG}/${REPO}/labels" \
    -f "name=${name}" \
    -f "color=${color}" \
    -f "description=${desc}" >/dev/null

  echo "created: ${name}"
}

echo "==> ${ORG}/${REPO}"
for entry in "${LABELS[@]}"; do
  IFS='|' read -r name color desc <<< "${entry}"
  upsert_label "${name}" "${color}" "${desc}"
done

echo "Done: ${ORG}/${REPO}"
