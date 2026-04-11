#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

APT_MANIFEST="$MODULE_DIR/apt.txt"
INSTALL_PACKAGES="$ROOT_DIR/scripts/install_packages.sh"

echo
echo "      Update and [base] installing packages"
echo "  ───────────────────────────────────────────── "
echo
grep -vE '^\s*#|^\s*$' "$APT_MANIFEST" | sed 's/^/  - /'
echo
echo "  ───────────────────────────────────────────── "
echo

bash "$INSTALL_PACKAGES" "$APT_MANIFEST"

echo "[base] done"
