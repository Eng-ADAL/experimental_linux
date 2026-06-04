#!/usr/bin/env bash
set -euo pipefail

# Error Handling
trap 'echo; echo "Interrupted."; exit 1' INT

VERSION="$(cat "$ROOT_DIR/VERSION")"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODULE_DIR="$ROOT_DIR/modules"
SCRIPT_DIR="$ROOT_DIR/scripts"
APT_MANIFEST="$ROOT_DIR/modules/base/apt.txt"
DRY_RUN=false
AUTO_YES=false
INSTALL_ALL=false


print_menu() {
echo
echo " ╔══════════════════════════════════╗"
echo " ║   experimental_linux bootstrap   ║"
echo " ╚══════════════════════════════════╝"
echo
echo "  Repo root: $ROOT_DIR"
echo
echo "1) Base CLI tools"
echo "2) Dotfiles"
echo "3) i3 desktop environment"
echo "4) empty-trash utility"
echo "5) iOS mount tools"
echo "6) oh-my-zsh"
echo
echo "a) Install everything"
echo "q) Quit"
echo
echo "h) help"
echo
}

help_bootstrap() {
echo
echo "             experimental_linux installation $VERSION "
echo "          ───────────────────────────────────────────── "
echo "Usage:"
echo "  ./install.sh           interactive mode"
echo "  ./install.sh --all     Install all modules listed in modules/"
echo "  ./install.sh --all -y  install everyting non interactive"
echo "  ./install.sh --version show version"
echo "  ./install.sh --help    show this help"
echo
echo " Base CLI tools:"
echo "[base] packages to install:"
grep -vE '^\s*#|^\s*$' "$APT_MANIFEST" | sed 's/^/  - /'
echo
echo " Dotfiles:               Vim - TMUX - Git - ZSH"
echo " i3 desktop environment: Install i3 tiling manager and environment packages"
echo " empty-trash utility:    Install trash bin app for smart deletion and recovery"
echo " iOS mount tools:        Install iOS (Iphone/Ipad) mount app"
echo "          ───────────────────────────────────────────── "
echo
}

prepare_environment() {
    echo "Preparing environment..."
    [[ -d "$MODULE_DIR" ]] || { echo "Modules directory missing"; exit 1; }
    [[ -d "$SCRIPT_DIR" ]] || { echo "Scripts directory missing"; exit 1; }

    chmod +x "$ROOT_DIR/install.sh"
    # make all helper scripts executable
    find "$SCRIPT_DIR" -type f -name "*.sh" -exec chmod +x {} \;
    # make all module installers executable
    find "$MODULE_DIR" -type f -name "install.sh" -exec chmod +x {} \;
}

install_module() {
    local module=$1
    if [[ -f "$MODULE_DIR/$module/install.sh" ]]; then
        echo
        echo "==> Installing $module"
        echo
        bash "$MODULE_DIR/$module/install.sh"
    else
        echo "Module $module not found."
    fi
}

# CI/CD args
for arg in "$@"; do
  case $arg in
    -y|--yes)
      AUTO_YES=true
      echo "[bootstrap] AUTO_YES=$AUTO_YES"
      ;;
    --all)
      INSTALL_ALL=true
      ;;
    --version)
      echo "R-Dev version $VERSION"
      exit 0
      ;;
    --help)
      help_bootstrap
      exit 0
      ;;
  esac
done

export AUTO_YES


prepare_environment

# Dry run (need maintenance)
#if [[ "${DRY_RUN:-false}" == "true" ]]; then
#  echo "[DRY-RUN] apt install ${packages[*]}"
#  exit 0
#fi

# Install All interactive (need maintenance for avoid rewrite)
#if [[ "$INSTALL_ALL" == "true" ]]; then
#  while read -r module; do
#    install_module "$module"
#  done < "$MODULE_DIR/modules.list"
#  install_module empty-trash
#  install_module ios-mount
#  install_module i3
#  exit 0
#fi

#while true; do
print_menu
read -rp "Select option: " choice

case $choice in
1)
install_module base
;;
2)
install_module dotfiles
;;
3)
#install_module i3
;;
4)
#install_module empty-trash
;;
5)
#install_module ios-mount
;;
6)
install_module oh-my-zsh
;;
a)
install_module base
install_module dotfiles
#install_module i3
#install_module empty-trash
#install_module ios-mount
;;
h)
help_bootstrap
read -rp "Press any key to continue menu"
;;
q)
exit 0
;;
*)
echo "Invalid option"
;;
esac
#done
