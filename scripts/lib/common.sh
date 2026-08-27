#!/usr/bin/env bash
# scripts/lib/common.sh
#
# Shared helpers for experimental_linux installers. Source this file;
# do not execute it directly.
#
#   source "$(repo_root)/scripts/lib/common.sh"   # or a relative path
#                                                   # computed by the caller
#
# Scope, per ARCHITECTURE.md / DESIGN_DECISIONS.md: logging, generic
# error handling, path resolution, dependency checks, and the two
# already-validated module-execution wrappers. Nothing here knows
# about profiles, platforms, plans, or module contents. If a future
# change to this file would require it to know any of those, that
# change belongs in a later stage instead, not here.

# ---------------------------------------------------------------------------
# Fail Safe
# ---------------------------------------------------------------------------
if [[ -n "${_COMMON_SH_LOADED:-}" ]]; then
    return 0
fi
readonly _COMMON_SH_LOADED=1

readonly _COMMON_SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _REPO_ROOT="$(cd "$_COMMON_SH_DIR/../.." && pwd)"

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------

readonly _COLOR_YELLOW=$'\033[33m'
readonly _COLOR_RED=$'\033[31m'
readonly _COLOR_RESET=$'\033[0m'

# _log <fd> <ansi_color> <label> <message>
# Internal. Writes "<label><message>" to the given fd (1 or 2). <label>
# may be empty. Colour is applied only to <label>, never to <message>,
# and only when writing to a live terminal with NO_COLOR unset. Never
# call this directly from outside this file.
_log() {
  local fd="$1" color="$2" label="$3" message="$4"

  if [[ -n "$label" ]] && [[ -z "${NO_COLOR:-}" ]] && [[ -t "$fd" ]]; then
    label="${color}${label}${_COLOR_RESET}"
  fi

  if [[ "$fd" == "2" ]]; then
    printf '%s%s\n' "$label" "$message" >&2
  else
    printf '%s%s\n' "$label" "$message"
  fi
}

# log_info <message>
# Routine progress. stdout. Never coloured, never exits.
log_info() {
  _log 1 "" "" "$1"
}

# log_warn <message>
# Recoverable / non-fatal. stdout (per LIFECYCLE.md: warnings do not
# indicate the run should stop). Never exits.
log_warn() {
  _log 1 "$_COLOR_YELLOW" "WARNING: " "$1"
}

# log_error <message>
# Fatal or per-check failure. stderr. Never exits on its own; pair
# with `exit` (see die) when the failure should stop the run.
log_error() {
  _log 2 "$_COLOR_RED" "ERROR: " "$1"
}

# die <message> [exit_code]
# Logs an error and exits. The only function in this file that exits.
# Default exit code 1.
die() {
  log_error "$1"
  exit "${2:-1}"
}

# ---------------------------------------------------------------------------
# Path resolution
# ---------------------------------------------------------------------------

# repo_root
# Prints the absolute repository root to stdout, nothing else. Safe
# to call from any working directory; does not depend on any
# caller-provided ROOT_DIR/MODULE_DIR.
repo_root() {
  printf '%s\n' "$_REPO_ROOT"
}

# ---------------------------------------------------------------------------
# Dependency checks
# ---------------------------------------------------------------------------

# require_cmd <cmd> [<cmd> ...]
# Silent on success. Exits via die, naming the first missing command.
require_cmd() {
  local cmd
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || die "missing dependency: $cmd"
  done
}

# ---------------------------------------------------------------------------
# Module execution
# ---------------------------------------------------------------------------

# install_module <module_name>
# Runs modules/<module_name>/install.sh if it exists, otherwise exits
# via die.
install_module() {
    local module="$1"
    local target="$_REPO_ROOT/modules/$module/install.sh"

    [[ -f "$target" ]] || die "module not found: $module"

    log_info ""
    log_info "[MODULE] Installing: $module"
    log_info ""

    bash "$target"
}

# enable_service <service_name> [<service_name> ...]
# Enables one or more systemd services/timers, using sudo only if not
# root. Silent itself; the calling module logs its own banner first.
enable_service() {
  local svc
  for svc in "$@"; do
    if [[ $EUID -eq 0 ]]; then
      systemctl enable "$svc"
    else
      sudo systemctl enable "$svc"
    fi
  done
}
