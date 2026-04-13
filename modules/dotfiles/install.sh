#!/usr/bin/env bash
set -euo pipefail

# Error Handling
trap 'echo; echo "Interrupted."; exit 1' INT

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"
TPM_DIR="$HOME/.tmux/plugins/tpm"
DATETIME="$(date +"%Y%m%d_%H%M%S")"

AUTO_YES="${AUTO_YES:-false}"


# LINK_SCRIPT="$ROOT_DIR/scripts/link_config.sh"

echo "[dotfiles] linking configs"

command -v git >/dev/null || echo "[dotfiles] warning: git not installed"
command -v tmux >/dev/null || echo "[dotfiles] warning: TMUX not installed"
command -v vim >/dev/null || echo "[dotfiles] warning: Vim not installed"
command -v zsh >/dev/null || echo "[dotfiles] warning: ZSH not installed"

link_config() {
  local src=$1
  local dest=$2
  local confirm="n"

  # First install -> no prompt
  if [[ ! -e "$dest" ]]; then
    ln -sf "$src" "$dest"
    echo "[dotfiles] linked $dest"
    return
  fi

  # AUTO_YES mode
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

# Avoid linking gitconfig
if command -v git >/dev/null; then
  echo "[dotfiles] configuring git include"

  git config --global --unset-all include.path 2>/dev/null || true
  git config --global --add include.path "$ROOT_DIR/configs/git/gitconfig"

  echo "[dotfiles] git config include set to $ROOT_DIR"
fi

# Avoid overwrite gitconfig
if command -v git >/dev/null; then
  echo "[dotfiles] configuring git include"
  # Remove ALL existing includes pointing to this repo (any path)
  git config --global --get-all include.path | while read -r path; do
    if [[ "$path" == *"configs/git/gitconfig"* ]]; then
      git config --global --unset include.path "$path" || true
    fi
  done
  # Add current correct path
  git config --global --add include.path "$ROOT_DIR/configs/git/gitconfig"

  echo "[dotfiles] git config include set to $ROOT_DIR"
fi


link_config "$ROOT_DIR/configs/tmux/tmux.conf" "$HOME/.tmux.conf"
link_config "$ROOT_DIR/configs/tmux/cheatsheet.txt" "$HOME/.tmux.cheatsheet.txt"
link_config "$ROOT_DIR/configs/vim/vimrc" "$HOME/.vimrc"
link_config "$ROOT_DIR/configs/zsh/zshrc" "$HOME/.zshrc"

# TPM install (idempotent)
echo "[dotfiles] setting up tmux plugins (TPM)"
if command -v git >/dev/null; then
  if [[ ! -d "$TPM_DIR" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "[dotfiles] TPM installed"
  else
    echo "[dotfiles] TPM already installed"
  fi
else
  echo "[dotfiles] warning: git not installed, skipping TPM"
fi

# TPM plugin install (single clean execution)
if command -v tmux >/dev/null && [[ -d "$TPM_DIR" ]]; then
  # Ensure config exists
  if [[ -f "$HOME/.tmux.conf" ]]; then
    tmux new-session -d -s bootstrap_tmp 2>/dev/null || true
    tmux source-file "$HOME/.tmux.conf"

    "$TPM_DIR/bin/install_plugins"

    tmux kill-session -t bootstrap_tmp 2>/dev/null || true
    echo "[dotfiles] tmux plugins installed"
  else
    echo "[dotfiles] warning: .tmux.conf not found, skipping plugin install"
  fi
fi

echo "[dotfiles] done"
