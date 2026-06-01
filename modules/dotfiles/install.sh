#!/usr/bin/env bash
set -euo pipefail

# Error handling
trap 'echo; echo "Interrupted."; exit 1' INT

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"
if [[ -z "$TARGET_USER" ]]; then
  echo "[dotfiles] could not detect target user" >&2
  exit 1
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
TPM_DIR="$TARGET_HOME/.tmux/plugins/tpm"
DATETIME="$(date +"%Y%m%d_%H%M%S")"
AUTO_YES="${AUTO_YES:-false}"

echo "[dotfiles] linking configs"

command -v git >/dev/null || echo "[dotfiles] warning: git not installed"
command -v tmux >/dev/null || echo "[dotfiles] warning: tmux not installed"
command -v vim >/dev/null || echo "[dotfiles] warning: vim not installed"
command -v zsh >/dev/null || echo "[dotfiles] warning: zsh not installed"

link_config() {
  local src="$1"
  local dest="$2"
  local confirm="n"

  if [[ ! -e "$dest" ]]; then
    ln -sf "$src" "$dest"
    echo "[dotfiles] linked $dest"
    return
  fi

  if [[ "$AUTO_YES" == "true" ]]; then
    confirm="y"
  else
    read -rp "[dotfiles] overwrite $dest? (y/N): " confirm
  fi

  if [[ "$confirm" == "y" ]]; then
    cp -L "$dest" "$dest.old.$DATETIME" 2>/dev/null || true
    echo "[dotfiles] backup: $dest.old.$DATETIME"
    ln -sf "$src" "$dest"
    echo "[dotfiles] updated $dest"
  else
    echo "[dotfiles] skipped $dest"
  fi
}

if command -v git >/dev/null; then
  echo "[dotfiles] configuring git include"

  sudo -u "$TARGET_USER" -H env HOME="$TARGET_HOME" \
    git config --global --unset-all include.path 2>/dev/null || true

  sudo -u "$TARGET_USER" -H env HOME="$TARGET_HOME" \
    git config --global --add include.path "$ROOT_DIR/configs/git/gitconfig"

  echo "[dotfiles] git include configured"
fi

link_config "$ROOT_DIR/configs/tmux/tmux.conf" "$TARGET_HOME/.tmux.conf"
link_config "$ROOT_DIR/configs/tmux/tmux.cheatsheet.txt" "$TARGET_HOME/.tmux.cheatsheet.txt"
link_config "$ROOT_DIR/configs/vim/vimrc" "$TARGET_HOME/.vimrc"
link_config "$ROOT_DIR/configs/zsh/zshrc" "$TARGET_HOME/.zshrc"

echo "[dotfiles] setting up tmux plugins (TPM)"
if command -v git >/dev/null; then
  if [[ ! -d "$TPM_DIR" ]]; then
    sudo -u "$TARGET_USER" -H git clone \
      https://github.com/tmux-plugins/tpm \
      "$TPM_DIR"
    echo "[dotfiles] TPM installed"
  else
    echo "[dotfiles] TPM already installed"
  fi
else
  echo "[dotfiles] warning: git not installed, skipping TPM"
fi

if command -v tmux >/dev/null && [[ -x "$TPM_DIR/bin/install_plugins" ]] && [[ -f "$TARGET_HOME/.tmux.conf" ]]; then
  sudo -u "$TARGET_USER" -H env HOME="$TARGET_HOME" \
    "$TPM_DIR/bin/install_plugins"
  echo "[dotfiles] tmux plugins installed"
else
  echo "[dotfiles] tmux plugins skipped"
fi

echo "[dotfiles] done"
