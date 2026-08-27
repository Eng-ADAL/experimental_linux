#!/usr/bin/env bash
# scripts/resolve_profile.sh
#
# Profile POLICY only. Turns explicit profile intent (or "auto") into
# exactly one resolved profile name, using facts from
# detect_environment.sh. Does not install anything, does not build an
# execution plan, does not validate an installation, does not perform
# cleanup, and never mutates detector facts -- those belong to later
# stages of the pipeline, not this file.
#
# Source this file; do not execute it directly.
#
#   source "$(repo_root)/scripts/resolve_profile.sh"
#   PROFILE="$(resolve_profile "$requested")"
#
# resolve_profile is pure: on success it prints exactly one profile
# name to stdout and nothing else, safe to capture with command
# substitution. On failure it calls die (common.sh): an error to
# stderr and a non-zero exit, with no stdout output at all. It never
# silently substitutes a different profile to avoid failing.

[[ -n "${_RESOLVE_PROFILE_SH_LOADED:-}" ]] && return
_RESOLVE_PROFILE_SH_LOADED=1

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/detect_environment.sh"

# _is_known_profile <name>
# Internal. True (0) if <name> is a concrete profile the resolver can
# return -- i.e. one of the five explicit profiles. "auto" is a
# resolution request, not a resolved value, and is deliberately not
# included here.
_is_known_profile() {
  case "$1" in
    sway|i3|remote-headless|server-light|server-full) return 0 ;;
    *) return 1 ;;
  esac
}

# _resolve_auto
# Internal. Applies the approved MVP auto policy against the current
# detector facts and prints exactly one of: sway | i3 | remote-headless.
# Dies (stderr + non-zero exit, no stdout) if no rule matches --
# there is no fallback profile. server-light and server-full are
# explicit-only for now and are never reached from here.
#
# Rule order mirrors the approved policy exactly:
#   1. distro_family must be exactly "debian", or auto fails outright
#      (MVP targets Debian only; fedora/arch/unrecognised/unknown all
#      fail here too -- confirmed: do not guess).
#   2-4. wsl=yes: wslg=yes -> sway, wslg=no -> remote-headless,
#      wslg=n/a -> remote-headless. (wslg=n/a cannot currently
#      co-occur with wsl=yes per detect_wslg's own logic; kept as
#      specified, confirmed defensive-only.)
#   5-6. bare metal (wsl=no, bare_metal=yes): gpu_device=yes -> sway,
#      gpu_device=no -> i3.
#   7-8. recognised virtualisation (wsl=no, bare_metal=no, a real
#      hypervisor name): gpu_device=yes -> sway, gpu_device=no ->
#      remote-headless.
#   otherwise: fail. No fallback profile, ever.
_resolve_auto() {
  local distro wsl wslg bare_metal virt gpu

  distro="$(detect_distro_family)"
  [[ "$distro" == "debian" ]] || die "auto: distro_family=$distro (MVP targets Debian only)"

  wsl="$(detect_wsl)"

  case "$wsl" in
    yes)
      wslg="$(detect_wslg)"
      case "$wslg" in
        yes) echo "sway" ;;
        no)  echo "remote-headless" ;;
        n/a) echo "remote-headless" ;;
        *)   die "auto: wsl=yes, wslg=$wslg is not a supported combination" ;;
      esac
      ;;
    no)
      bare_metal="$(detect_bare_metal)"
      gpu="$(detect_gpu_device)"

      case "$bare_metal" in
        yes)
          case "$gpu" in
            yes) echo "sway" ;;
            no)  echo "i3" ;;
            *)   die "auto: bare_metal=yes, gpu_device=$gpu is not a supported combination" ;;
          esac
          ;;
        no)
          virt="$(detect_virtualization)"
          if [[ "$virt" == "none" || "$virt" == "unknown" ]]; then
            # Not reachable given the current detect_bare_metal derivation
            # (bare_metal=no + wsl=no implies a recognised hypervisor);
            # kept as a guard in case that derivation ever changes.
            die "auto: wsl=no, bare_metal=no, virtualization=$virt is not a supported combination"
          fi
          case "$gpu" in
            yes) echo "sway" ;;
            no)  echo "remote-headless" ;;
            *)   die "auto: virtualization=$virt, gpu_device=$gpu is not a supported combination" ;;
          esac
          ;;
        *)
          die "auto: bare_metal=$bare_metal, cannot safely resolve" ;;
      esac
      ;;
    *)
      die "auto: wsl=$wsl, cannot safely resolve" ;;
  esac
}

# resolve_profile <requested_profile>
# Pure. Prints exactly one profile name to stdout on success. Dies
# (stderr + non-zero exit, no stdout) if <requested_profile> is
# missing, unknown, or if "auto" cannot be safely resolved. Explicit
# profile selection always overrides auto -- it is returned as-is
# without consulting any detector fact or the auto policy at all.
resolve_profile() {
  local requested="${1:-}"

  [[ -n "$requested" ]] || die "resolve_profile: missing required profile argument"

  if [[ "$requested" == "auto" ]]; then
    _resolve_auto
    return
  fi

  _is_known_profile "$requested" || die "resolve_profile: unknown profile: $requested"

  echo "$requested"
}

# log_resolved_profile <requested_profile>
# Convenience, mirrors log_detected_facts: resolves and announces the
# result via log_info (human-readable, not meant to be captured with
# $()). Dies the same way resolve_profile does if resolution fails;
# nothing is logged on that path, the die() message on stderr is the
# only output.
log_resolved_profile() {
  local requested="${1:-}" resolved
  resolved="$(resolve_profile "$requested")"
  log_info "[resolver] requested=$requested resolved=$resolved"
}
