#!/usr/bin/env bash
set -euo pipefail

VERSION="$(cat "$ROOT_DIR/VERSION")"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"
if [[ -z "$TARGET_USER" ]]; then
  echo "[bootstrap] could not detect target user" >&2
  exit 1
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
MODULE_DIR="$ROOT_DIR/modules"

DESKTOP=""
AUTO_YES=false

usage() {
cat <<EOF

experimental_linux bootstrap $VERSION

Usage:

  ./bootstrap.sh --desktop sway
  ./bootstrap.sh --desktop i3

Options:

  --desktop sway     Install Sway workstation
  --desktop i3       Install i3 workstation
  -y, --yes          Non-interactive mode
  -h, --help         Show help

EOF
}

install_module() {
    local module="$1"

    if [[ ! -f "$MODULE_DIR/$module/install.sh" ]]; then
        echo "[bootstrap] module not found: $module"
        exit 1
    fi

    echo
    echo "=================================================="
    echo "Installing module: $module"
    echo "=================================================="
    echo

    bash "$MODULE_DIR/$module/install.sh"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --desktop)
            DESKTOP="${2:-}"
            shift 2
            ;;
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "[bootstrap] unknown argument: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ -z "$DESKTOP" ]]; then
    echo "[bootstrap] desktop not specified"
    echo
    usage
    exit 1
fi

export AUTO_YES

echo
echo "experimental_linux bootstrap"
echo "desktop: $DESKTOP"
echo

#
# Core workstation
#

install_module base
install_module dotfiles

#
# Desktop
#

case "$DESKTOP" in
    sway)
        install_module sway
        ;;
    i3)
        install_module i3
        ;;
    *)
        echo "[bootstrap] unsupported desktop: $DESKTOP"
        exit 1
        ;;
esac

#
# Welcome experience
#

if [[ -f "$ROOT_DIR/scripts/create_continue_setup.sh" ]]; then
    bash "$ROOT_DIR/scripts/create_continue_setup.sh"
fi

# for phase 2 commented out need maintenance with create_continue_setup.sh 
# install -o "$TARGET_USER" -g "$TARGET_USER" -m 0644 /dev/null \
#  "$TARGET_HOME/.eng-workstation-installed"

echo
echo "Bootstrap complete."
echo
echo "Reboot recommended."
echo
