#!/usr/bin/env bash
set -euo pipefail

# Error Handling
trap 'echo; echo "Interrupted."; exit 1' INT

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"
DATETIME="$(date +"%Y%m%d_%H%M%S")"

# LINK_SCRIPT="$ROOT_DIR/scripts/link_config.sh"

echo "[dotfiles] linking configs"


link_config() {
  local src=$1
  local dest=$2

  if [[ -e "$dest" ]]; then
    cp "$dest" "$dest.old.$DATETIME" 2>/dev/null || true
  fi

  ln -sf "$src" "$dest"
}

command -v git >/dev/null || echo "[dotfiles] warning: git not installed"
command -v tmux >/dev/null || echo "[dotfiles] warning: TMUX not installed"
command -v vim >/dev/null || echo "[dotfiles] warning: Vim not installed"
command -v zsh >/dev/null || echo "[dotfiles] warning: ZSH not installed"


link_config "$ROOT_DIR/configs/git/gitconfig" "$HOME/.gitconfig"
link_config "$ROOT_DIR/configs/tmux/tmux.conf" "$HOME/.tmux.conf"
link_config "$ROOT_DIR/configs/vim/vimrc" "$HOME/.vimrc"
link_config "$ROOT_DIR/configs/zsh/zshrc" "$HOME/.zshrc"

echo "[dotfiles] done"
