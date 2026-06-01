#!/usr/bin/env bash
set -euo pipefail

detect_primary_user() {
  if [[ -n "${SUDO_USER:-}" && "${SUDO_USER:-root}" != "root" ]]; then
    printf '%s\n' "$SUDO_USER"
    return 0
  fi

  getent passwd \
    | awk -F: '$3 >= 1000 && $1 != "nobody" { print $1; exit }'
}
