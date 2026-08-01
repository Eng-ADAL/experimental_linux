#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

source "$ROOT_DIR/scripts/detect_environment.sh"

echo
echo "========== Platform Initialisation =========="
echo

bash "$ROOT_DIR/scripts/install_packages.sh"

bash "$ROOT_DIR/scripts/add_sudoer.sh"

bash "$ROOT_DIR/scripts/configure_system.sh"

bash "$ROOT_DIR/scripts/configure_user.sh"

bash "$ROOT_DIR/scripts/configure_desktop.sh"

bash "$ROOT_DIR/scripts/post_install_check.sh"

echo
echo "Platform installation completed."
