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

install_vim_plug() {
  local target_user="$1"
  local target_home="$2"

  sudo -u "$target_user" -H mkdir -p "$target_home/.vim/autoload"

  if [[ ! -f "$target_home/.vim/autoload/plug.vim" ]]; then
    sudo -u "$target_user" -H curl -fLo "$target_home/.vim/autoload/plug.vim" \
      --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

for cmd in git curl vim; do
    command -v "$cmd" >/dev/null || {
        echo "[dotfiles] missing dependency: $cmd"
        exit 1
    }
done

link_config "$ROOT_DIR/configs/tmux/tmux.conf" "$TARGET_HOME/.tmux.conf"
link_config "$ROOT_DIR/configs/tmux/tmux.cheatsheet.txt" "$TARGET_HOME/.tmux.cheatsheet.txt"
link_config "$ROOT_DIR/configs/vim/vimrc" "$TARGET_HOME/.vimrc"
link_config "$ROOT_DIR/configs/zsh/zshrc" "$TARGET_HOME/.zshrc"

install_vim_plug "$TARGET_USER" "$TARGET_HOME"

echo "[dotfiles] installing vim plugins"
sudo -u "$TARGET_USER" -H env HOME="$TARGET_HOME" \
    vim +'PlugInstall --sync' +'qa'

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

