#!/usr/bin/env bash
set -euo pipefail

# Error Handling
trap 'echo; echo "Interrupted."; exit 1' INT

# Version
VERSION="0.2.7"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODULE_DIR="$ROOT_DIR/modules"
SCRIPT_DIR="$ROOT_DIR/scripts"

help_bootstrap() {
echo
echo "experimental_linux bootstrap $VERSION"
echo
echo "Usage:"
echo "  ./bootstrap.sh           interactive mode"
echo "  ./bootstrap.sh --all     install everything"
echo "  ./bootstrap.sh --version show version"
echo "  ./bootstrap.sh --help    show this help"
echo
}

prepare_environment() {
    echo "Preparing environment..."
    [[ -d "$MODULE_DIR" ]] || { echo "Modules directory missing"; exit 1; }
    [[ -d "$SCRIPT_DIR" ]] || { echo "Scripts directory missing"; exit 1; }

    chmod +x "$ROOT_DIR/bootstrap.sh"
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


prepare_environment

if [[ "${1:-}" == "--all" ]]; then
  install_module base
  install_module dotfiles
  install_module empty-trash
  install_module ios-mount
  install_module i3
  exit 0
fi

if [[ "${1:-}" == "--version" ]]; then
    echo "R-Dev version $VERSION"
    exit 0
fi


if [[ "${1:-}" == "--help" ]]; then
    help_bootstrap
    exit 0
fi


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
echo
echo "a) Install everything"
echo "q) Quit"
echo
echo "h) help"
echo
}



while true; do
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
install_module i3
;;
4)
install_module empty-trash
;;
5)
install_module ios-mount
;;
a)
install_module base
install_module dotfiles
install_module i3
install_module empty-trash
install_module ios-mount
;;
h)
help_bootstrap
;;
q)
exit 0
;;
*)
echo "Invalid option"
;;
esac
done
