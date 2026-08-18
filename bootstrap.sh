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
# Detector -> Resolver -> Planner -> Bootstrap-as-executor
#
# base/dotfiles are part of every profile's plan (see
# scripts/plan_install.sh), so they no longer need a separate
# unconditional install step here. auto is now genuinely resolved by
# scripts/resolve_profile.sh instead of the old placeholder that
# installed no desktop. There is no separate executor file: this
# script executes the planner's module list directly with
# common.sh's install_module, per the current architecture decision
# that a standalone executor file isn't justified here.
source "$ROOT_DIR/scripts/lib/common.sh"
source "$ROOT_DIR/scripts/resolve_profile.sh"
source "$ROOT_DIR/scripts/plan_install.sh"

RESOLVED_PROFILE="$(resolve_profile "$PROFILE")"
log_info "[bootstrap] profile requested: $PROFILE -> resolved: $RESOLVED_PROFILE"

PLAN="$(plan_install "$RESOLVED_PROFILE")"

# PLAN's first line is the resolved profile above (already logged,
# not itself a module); every line after it is a module, in the
# fixed order the planner produced. install_module is checked via
# if/else, not a bare call followed by rc=$?: under this script's
# own set -e, errexit can otherwise fire before rc=$? ever runs --
# confirmed and fixed once already in scripts/execute_plan.sh's
# history (commit 45bfc2d), applied here from the start instead.
_first_plan_line=true
while IFS= read -r _plan_line; do
  if [[ "$_first_plan_line" == true ]]; then
    _first_plan_line=false
    continue
  fi

  if install_module "$_plan_line"; then
    :
  else
    _module_rc=$?
    die "bootstrap: module failed: $_plan_line (exit $_module_rc) -- stopping, no further modules will run"
  fi
done <<< "$PLAN"

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
