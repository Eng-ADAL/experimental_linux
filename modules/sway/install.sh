#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

APT_MANIFEST="$MODULE_DIR/apt.txt"
INSTALL_PACKAGES="$ROOT_DIR/scripts/install_packages.sh"

echo
echo "[sway] installing packages"
echo

bash "$INSTALL_PACKAGES" "$APT_MANIFEST"

echo
echo "[sway] enabling services"
echo

if [[ $EUID -eq 0 ]]; then
  systemctl enable NetworkManager
  systemctl enable fstrim.timer
else
  sudo systemctl enable NetworkManager
  sudo systemctl enable fstrim.timer
fi

echo
echo "[sway] done"
