#!/usr/bin/env bash
set -euo pipefail

MANIFEST="${1:-}"

APT_CMD="apt-get"

if [[ $EUID -ne 0 ]]; then
    APT_CMD="sudo apt-get"
fi

if [[ -z "$MANIFEST" || ! -f "$MANIFEST" ]]; then
    echo "[flatpak] manifest not found: $MANIFEST"
    exit 1
fi

mapfile -t apps < <(
    grep -vE '^\s*#|^\s*$' "$MANIFEST"
)

if [[ ${#apps[@]} -eq 0 ]]; then
    echo "[flatpak] no applications found"
    exit 0
fi

if ! command -v flatpak >/dev/null 2>&1; then
    echo "[flatpak] installing flatpak"

    $APT_CMD update
    $APT_CMD install -y flatpak
fi

echo "[flatpak] ensuring flathub"

flatpak remote-add \
    --if-not-exists \
    flathub \
    https://flathub.org/repo/flathub.flatpakrepo

echo "[flatpak] installing applications"

flatpak install -y flathub "${apps[@]}"

echo "[flatpak] done"
