#!/usr/bin/env bash
set -euo pipefail

MANIFEST=$1

echo
echo "Installing Flatpak packages from $MANIFEST"

sudo apt install -y flatpak

flatpak remote-add --if-not-exists flathub \
https://flathub.org/repo/flathub.flatpakrepo

xargs -a "$MANIFEST" flatpak install -y flathub
