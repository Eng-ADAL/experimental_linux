#!/usr/bin/env bash
set -euo pipefail

MANIFEST="${1:-}"

if [[ -z "$MANIFEST" || ! -f "$MANIFEST" ]]; then
  echo "[flatpak] ERROR: manifest not found: $MANIFEST"
  exit 1
fi

mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$MANIFEST")

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "[flatpak] WARNING: no packages in $MANIFEST"
  exit 0
fi

echo "[flatpak] ensuring flatpak is installed"
if ! command -v flatpak >/dev/null; then
  sudo apt-get update
  sudo apt-get install -y flatpak
fi

echo "[flatpak] ensuring flathub"
flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

echo "[flatpak] installing apps"
printf "  - %s\n" "${packages[@]}"

flatpak install -y flathub "${packages[@]}"

echo "[flatpak] done"
