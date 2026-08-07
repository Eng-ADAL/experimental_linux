#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(cat "$ROOT_DIR/VERSION")"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"
if [[ -z "$TARGET_USER" ]]; then
  echo "[bootstrap] could not detect target user" >&2
  exit 1
fi

MODULE_DIR="$ROOT_DIR/modules"

PROFILE=""
AUTO_YES=false

usage() {
cat <<EOF

experimental_linux bootstrap $VERSION

Usage:

  ./bootstrap.sh --profile sway
  ./bootstrap.sh --profile i3
  ./bootstrap.sh --profile auto      (default if nothing is given)

  --desktop sway / --desktop i3 are accepted as legacy aliases for
  --profile sway / --profile i3.

Options:

  --profile <sway|i3|auto>   Choose what gets installed (default: auto)
  --desktop <sway|i3>        Legacy alias for --profile
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
        --profile)
           PROFILE="${2:-}"
           shift 2
           ;;
        --desktop)
            PROFILE="${2:-}"
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

if [[ -z "$PROFILE" ]]; then
    PROFILE="auto"
fi

export AUTO_YES

echo
echo "experimental_linux bootstrap"
echo "profile: $PROFILE"
echo

#
# Core workstation
#

install_module base
install_module dotfiles
install_module oh-my-zsh

#
# Desktop
#

# Profile resolution. Real platform/capability-based auto-detection is
# not implemented yet, that's a later slice. Until then, auto
# deliberately installs no desktop, rather than guessing one.
case "$PROFILE" in
    sway)
        install_module sway
        ;;
    i3)
        install_module i3
        ;;
    auto)
    echo "[bootstrap] profile=auto: automatic desktop selection isn't implemented yet."
    echo "[bootstrap] installing base tools only, no desktop."
    echo "[bootstrap] use --profile sway or --profile i3 to choose one explicitly."
    ;;
    *)
        echo "[bootstrap] unsupported profile: $PROFILE"
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
