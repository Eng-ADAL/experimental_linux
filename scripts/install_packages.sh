#!/usr/bin/env bash
set -euo pipefail

MANIFEST="$1"

echo
echo "Installing packages from $MANIFEST"

sudo apt-get update

mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$MANIFEST")
sudo apt install -y "${packages[@]}"
