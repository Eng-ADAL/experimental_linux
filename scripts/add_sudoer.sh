#!/usr/bin/env bash
set -euo pipefail

detect_candidate_users() {
  getent passwd | awk -F: '
    $3 >= 1000 && $1 != "nobody" && $1 != "systemd-network" && $1 != "systemd-timesync" {
      print $1
    }'
}

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo "[sudoer] run as root" >&2
  exit 1
fi

if [[ -n "${SUDO_USER:-}" && "${SUDO_USER:-root}" != "root" ]]; then
  TARGET_USER="$SUDO_USER"
else
  mapfile -t USERS < <(detect_candidate_users)

  case "${#USERS[@]}" in
    0)
      echo "[sudoer] no normal users found" >&2
      exit 1
      ;;
    1)
      TARGET_USER="${USERS[0]}"
      ;;
    *)
      echo "[sudoer] multiple users found:"
      select TARGET_USER in "${USERS[@]}"; do
        [[ -n "${TARGET_USER:-}" ]] && break
      done
      ;;
  esac
fi

if id -nG "$TARGET_USER" | grep -qw sudo; then
    echo "[sudoer] $TARGET_USER is already a sudoer."
else
    usermod -aG sudo "$TARGET_USER"
    echo "[sudoer] Added $TARGET_USER to sudo group."
fi
