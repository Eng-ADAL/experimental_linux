#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

APT_MANIFEST="$MODULE_DIR/apt.txt"
INSTALL_PACKAGES="$ROOT_DIR/scripts/install_packages.sh"

echo
echo "[base] installing packages"

bash "$INSTALL_PACKAGES" "$APT_MANIFEST"

echo "[base] done"
