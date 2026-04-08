#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

APT_MANIFEST="$MODULE_DIR/apt.txt"
INSTALL_PACKAGES="$ROOT_DIR/scripts/install_packages.sh"

echo "[empty-trash] installing dependencies"

bash "$INSTALL_PACKAGES" "$APT_MANIFEST"

echo "[empty-trash] installing binary"

sudo install -Dm755 \
  "$MODULE_DIR/empty-trash" \
  /usr/local/bin/empty-trash

echo "[empty-trash] installed successfully"
