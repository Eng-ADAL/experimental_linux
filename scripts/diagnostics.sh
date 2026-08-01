#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
DEFAULT_OUTPUT="/tmp/dev-workstation-diagnostics-${TIMESTAMP}.txt"
OUTPUT="${1:-$DEFAULT_OUTPUT}"

mkdir -p "$(dirname "$OUTPUT")"

# Write to both terminal and file
exec > >(tee -a "$OUTPUT") 2>&1

section() {
  echo
  echo "=================================================="
  echo "$1"
  echo "=================================================="
}

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $cmd -> $(command -v "$cmd")"
  else
    echo "[MISSING] $cmd"
  fi
}

check_file() {
  local path="$1"
  if [[ -e "$path" ]]; then
    echo "[OK] $path"
    ls -ld "$path" 2>/dev/null || true
  else
    echo "[MISSING] $path"
  fi
}

echo "[diagnostics] output: $OUTPUT"
echo "[diagnostics] repo: $ROOT_DIR"

section "System"
if command -v hostnamectl >/dev/null 2>&1; then
  hostnamectl || true
else
  uname -a
fi

echo
echo "OS release:"
if [[ -f /etc/os-release ]]; then
  cat /etc/os-release
else
  echo "No /etc/os-release found"
fi

echo
echo "Kernel:"
uname -r

echo
echo "Virtualisation:"
if command -v systemd-detect-virt >/dev/null 2>&1; then
  if systemd-detect-virt --quiet; then
    systemd-detect-virt
  else
    echo "none"
  fi
else
  echo "systemd-detect-virt not available"
fi

section "User and shell"
echo "User: $(id -un)"
echo "UID: $(id -u)"
echo "GID: $(id -g)"
echo "Groups: $(id -nG)"
echo "Shell: ${SHELL:-unknown}"
echo "HOME: ${HOME:-unknown}"
echo "SUDO_USER: ${SUDO_USER:-none}"
echo "SUDO_UID: ${SUDO_UID:-none}"

echo
echo "Current login shell from /etc/passwd:"
getent passwd "$(id -un)" | awk -F: '{print $7}' || true

section "Session"
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-unset}"
echo "DISPLAY=${DISPLAY:-unset}"
echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-unset}"
echo "SWAYSOCK=${SWAYSOCK:-unset}"
echo "XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-unset}"

section "Graphics"
echo "DRM devices:"
if [[ -d /dev/dri ]]; then
  ls -l /dev/dri || true
else
  echo "No /dev/dri directory"
fi

echo
echo "GPU-related kernel modules:"
lsmod | grep -E 'i915|amdgpu|nouveau|vmwgfx|virtio_gpu|drm' || true

section "Commands"
check_cmd git
check_cmd curl
check_cmd wget
check_cmd sudo
check_cmd tmux
check_cmd vim
check_cmd zsh
check_cmd sway
check_cmd i3
check_cmd foot
check_cmd alacritty
check_cmd waybar
check_cmd wofi
check_cmd flatpak

section "Packages"
if command -v dpkg >/dev/null 2>&1; then
  for pkg in git tmux vim zsh sway i3 foot alacritty waybar wofi network-manager; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "[OK] package installed: $pkg"
    else
      echo "[MISS] package not installed: $pkg"
    fi
  done
else
  echo "dpkg not available"
fi

section "Dotfiles"
check_file "$HOME/.tmux.conf"
check_file "$HOME/.tmux.cheatsheet.txt"
check_file "$HOME/.vimrc"
check_file "$HOME/.zshrc"
check_file "$HOME/.vim/autoload/plug.vim"
check_file "$HOME/.tmux/plugins/tpm"
check_file "$HOME/.oh-my-zsh"

section "Git"
if command -v git >/dev/null 2>&1; then
  echo "git version: $(git --version)"
  echo
  echo "Global include.path:"
  git config --global --get-all include.path || echo "none"
fi

section "Services"
if command -v systemctl >/dev/null 2>&1; then
  for svc in NetworkManager fstrim.timer; do
    echo "--- $svc ---"
    systemctl is-enabled "$svc" 2>/dev/null || true
    systemctl is-active "$svc" 2>/dev/null || true
  done
else
  echo "systemctl not available"
fi

section "VM-specific hints"
if command -v systemd-detect-virt >/dev/null 2>&1 && systemd-detect-virt --quiet; then
  VIRT_TYPE="$(systemd-detect-virt)"
  echo "Detected VM: $VIRT_TYPE"
  if [[ "$VIRT_TYPE" == "vmware" ]]; then
    echo "Hint: Sway may need WLR_RENDERER=pixman on VMware."
  fi
fi

section "Useful environment"
env | grep -E '^(PATH|TERM|SHELL|HOME|USER|LOGNAME|XDG_|WAYLAND_DISPLAY|DISPLAY|SWAYSOCK|WLR_)=' | sort || true

section "Summary"
echo "Diagnostics written to: $OUTPUT"
