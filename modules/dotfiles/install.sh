#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

LINK_SCRIPT="$ROOT_DIR/scripts/link_config.sh"

echo "[dotfiles] linking configs"

bash "$LINK_SCRIPT"

echo "[dotfiles] done"
