#!/usr/bin/env bash
# scripts/detect_environment.sh
#
# Environment fact detection ONLY. Every detect_* function below
# prints exactly one fact to stdout and nothing else, safe to capture
# with command substitution: PLATFORM="$(detect_virtualization)".
#
# None of these functions decide anything. If a fact cannot be
# determined, the function prints "unknown" (or "n/a" where the fact
# genuinely does not apply, e.g. WSL version on a non-WSL machine)
# rather than guessing. Deciding what "unknown" should mean for a
# profile choice is the resolver's job, not this file's.
#
# Source this file; do not execute it directly.

[[ -n "${_DETECT_ENVIRONMENT_SH_LOADED:-}" ]] && return
_DETECT_ENVIRONMENT_SH_LOADED=1

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

# Driver modules this project currently knows how to recognise. Not
# exhaustive, and not a judgement of quality, only of "seen and
# named". Expected to need periodic maintenance as new hardware and
# hypervisors are encountered, same as diagnostics.sh's own
# long-standing lsmod pattern this reuses.
readonly _KNOWN_GPU_MODULES='i915|amdgpu|nouveau|vmwgfx|virtio_gpu'

# ---------------------------------------------------------------------------
# Virtualization / platform
# ---------------------------------------------------------------------------

# detect_virtualization
# Prints: none | a hypervisor name (kvm, vmware, ...) | unknown
detect_virtualization() {
  if ! command -v systemd-detect-virt >/dev/null 2>&1; then
    echo "unknown"
    return
  fi

  if systemd-detect-virt --quiet; then
    systemd-detect-virt
  else
    echo "none"
  fi
}

# detect_wsl
# Prints: yes | no | unknown
detect_wsl() {
  if [[ ! -r /proc/version ]]; then
    echo "unknown"
    return
  fi

  if grep -qiE 'microsoft|wsl' /proc/version; then
    echo "yes"
  else
    echo "no"
  fi
}

# detect_wsl_version
# Prints: 1 | 2 | n/a (not WSL at all) | unknown
detect_wsl_version() {
  if [[ "$(detect_wsl)" != "yes" ]]; then
    echo "n/a"
    return
  fi

  if [[ ! -r /proc/version ]]; then
    echo "unknown"
    return
  fi

  local version
  version="$(cat /proc/version)"

  if grep -qi 'wsl2' <<< "$version"; then
    echo "2"
  elif grep -qi 'microsoft' <<< "$version"; then
    echo "1"
  else
    echo "unknown"
  fi
}

# detect_wslg
# Prints: yes | no | n/a (not WSL at all)
detect_wslg() {
  if [[ "$(detect_wsl)" != "yes" ]]; then
    echo "n/a"
    return
  fi

  if [[ -d /mnt/wslg ]]; then
    echo "yes"
  else
    echo "no"
  fi
}

# detect_bare_metal
# Derived, not an independent sensor. Prints: yes | no | unknown
# (unknown if either input fact is itself unknown, never guessed)
detect_bare_metal() {
  local virt wsl
  virt="$(detect_virtualization)"
  wsl="$(detect_wsl)"

  if [[ "$virt" == "unknown" || "$wsl" == "unknown" ]]; then
    echo "unknown"
    return
  fi

  if [[ "$virt" == "none" && "$wsl" == "no" ]]; then
    echo "yes"
  else
    echo "no"
  fi
}

# ---------------------------------------------------------------------------
# Distro
# ---------------------------------------------------------------------------

# detect_distro_family
# Prints: debian | fedora | arch | unrecognised (readable, just not
# one of those three) | unknown (file genuinely unreadable)
detect_distro_family() {
  if [[ ! -r /etc/os-release ]]; then
    echo "unknown"
    return
  fi

  local id_info
  id_info="$(
    # shellcheck disable=SC1091
    . /etc/os-release 2>/dev/null || true
    printf '%s %s' "${ID:-}" "${ID_LIKE:-}"
  )"

  case "$id_info" in
    *debian*) echo "debian" ;;
    *fedora*) echo "fedora" ;;
    *arch*)   echo "arch" ;;
    *)        echo "unrecognised" ;;
  esac
}

# ---------------------------------------------------------------------------
# Graphics
# ---------------------------------------------------------------------------

# detect_gpu_device
# Prints: yes | no  (a DRM render device node exists at all)
detect_gpu_device() {
  if [[ -d /dev/dri ]] && compgen -G '/dev/dri/card*' >/dev/null 2>&1; then
    echo "yes"
  else
    echo "no"
  fi
}

# detect_gpu_modules
# Prints a space-separated list of recognised graphics driver modules
# currently loaded (may be empty), or "unknown" if lsmod itself isn't
# available to check at all. Empty is a real, successfully-determined
# answer, distinct from unknown.
detect_gpu_modules() {
  if ! command -v lsmod >/dev/null 2>&1; then
    echo "unknown"
    return
  fi

  # grep returning no match (empty result) is a legitimate, common
  # outcome here, not a failure, but it exits non-zero, and that would
  # abort this function under set -e if inherit_errexit is ever on
  # (bash does not inherit -e into $() by default, which is the only
  # reason this "works" today without the || true; do not remove it).
  local matches
  matches="$(lsmod | grep -oE "$_KNOWN_GPU_MODULES" | sort -u | tr '\n' ' ' | sed 's/ $//')" || true

  if [[ -z "$matches" ]]; then
    echo "none"
  else
    printf '%s\n' "$matches"
  fi
}

# ---------------------------------------------------------------------------
# Summary logging
# ---------------------------------------------------------------------------

# log_detected_facts
# The one function in this file that logs rather than returns a pure
# value. Calls every detect_* function and announces the results via
# log_info. Not meant to be captured with $(); call it for its output,
# not its return value.
log_detected_facts() {
  log_info "[detector] virtualization: $(detect_virtualization)"
  log_info "[detector] bare_metal: $(detect_bare_metal)"
  log_info "[detector] wsl: $(detect_wsl)"
  log_info "[detector] wsl_version: $(detect_wsl_version)"
  log_info "[detector] wslg: $(detect_wslg)"
  log_info "[detector] distro_family: $(detect_distro_family)"
  log_info "[detector] gpu_device: $(detect_gpu_device)"
  log_info "[detector] gpu_modules: $(detect_gpu_modules)"
}
