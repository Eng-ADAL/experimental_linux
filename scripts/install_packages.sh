#!/usr/bin/env bash
set -euo pipefail

MANIFEST="${1:-}"

if [[ -z "$MANIFEST" || ! -f "$MANIFEST" ]]; then
  echo "[packages] ERROR: manifest not found: $MANIFEST"
  exit 1
fi

mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$MANIFEST")

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "[packages] WARNING: no packages in $MANIFEST"
  exit 0
fi

echo
echo "[packages] installing from: $MANIFEST"
printf "  - %s\n" "${packages[@]}"
echo

# Optional optimisation hook
if [[ "${APT_UPDATED:-false}" != "true" ]]; then
  echo "[packages] apt update"
  sudo apt-get update
  export APT_UPDATED=true
fi

sudo apt-get install -y "${packages[@]}"

echo "[packages] done"
