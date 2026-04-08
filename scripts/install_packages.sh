#!/usr/bin/env bash
set -euo pipefail

MANIFEST=$1

echo
echo "Installing packages from $MANIFEST"

sudo apt update

grep -vE '^\s*#|^\s*$' "$MANIFEST" | xargs -r sudo apt install -y
