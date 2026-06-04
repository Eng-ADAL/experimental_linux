#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"
if [[ -z "$TARGET_USER" ]]; then
  echo "[oh-my-zsh] could not detect target user" >&2
  exit 1
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

if [[ -d "$TARGET_HOME/.oh-my-zsh" ]]; then
  echo "[oh-my-zsh] already installed"
  exit 0
fi

tmpfile="$(mktemp)"
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o "$tmpfile"

sudo -u "$TARGET_USER" -H env RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh "$tmpfile" --unattended

rm -f "$tmpfile"

echo
echo "[oh-my-zsh] installed"
echo "[oh-my-zsh] restart your shell to activate"
