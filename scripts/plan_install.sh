#!/usr/bin/env bash
# scripts/plan_install.sh
#
# PLANNING only. Turns an already-resolved profile into a
# deterministic, ordered execution plan: a profile name plus a fixed
# module list. Does not install anything, does not invoke module
# installers, does not perform validation, does not perform cleanup,
# and contains no profile-selection policy of its own --
# resolve_profile.sh owns that, and this file never sources it,
# calls it, or re-derives its decision. It trusts the profile it is
# given.
#
# Source this file; do not execute it directly.
#
#   source "$(repo_root)/scripts/plan_install.sh"
#   plan_install "$resolved_profile"
#
# plan_install is pure: on success it prints the plan to stdout and
# nothing else -- the profile on the first line, then each module on
# its own line, in the fixed install order -- safe to capture with
# mapfile/command substitution. On failure it calls die (common.sh):
# an error to stderr and a non-zero exit, with no stdout output at
# all, not even a partial plan.

[[ -n "${_PLAN_INSTALL_SH_LOADED:-}" ]] && return
_PLAN_INSTALL_SH_LOADED=1

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

# plan_install <resolved_profile>
# Pure. Prints the plan to stdout on success: <resolved_profile> on
# the first line, then its modules, one per line, in fixed order
# (base -> dotfiles -> desktop; this order is policy, not discovered
# or sorted). Dies (stderr + non-zero exit, no stdout) if
# <resolved_profile> is missing, unknown, or if any module its plan
# needs is missing from this repository's modules/ directory.
#
# The module list per profile is fixed MVP data, assigned directly
# (never via a captured helper call) so that a die() on an unknown
# profile actually terminates the caller instead of being silently
# absorbed by a subshell.
plan_install() {
  local profile="${1:-}" m
  local -a modules=()

  [[ -n "$profile" ]] || die "plan_install: missing required profile argument"

  case "$profile" in
    sway)             modules=(base dotfiles sway) ;;
    i3)               modules=(base dotfiles i3) ;;
    remote-headless)  modules=(base dotfiles) ;;
    server-light)     modules=(base dotfiles) ;;
    server-full)      modules=(base dotfiles) ;;
    *)                die "plan_install: unknown profile: $profile" ;;
  esac

  for m in "${modules[@]}"; do
    [[ -f "$(repo_root)/modules/$m/install.sh" ]] \
      || die "plan_install: required module missing: modules/$m/install.sh"
  done

  echo "$profile"
  printf '%s\n' "${modules[@]}"
}

# log_planned_install <resolved_profile>
# Convenience, mirrors log_resolved_profile / log_detected_facts:
# builds the plan and announces it via log_info (human-readable, not
# meant to be captured with $()). Checks plan_install's exit status
# before logging, so a failed plan is never reported as if it
# succeeded with an empty module list.
log_planned_install() {
  local profile="${1:-}" plan_output rc modules_line

  plan_output="$(plan_install "$profile")"
  rc=$?
  [[ $rc -eq 0 ]] || return "$rc"

  modules_line="$(tail -n +2 <<< "$plan_output" | tr '\n' ' ' | sed 's/ *$//')"
  log_info "[planner] profile=$profile modules=$modules_line"
}
