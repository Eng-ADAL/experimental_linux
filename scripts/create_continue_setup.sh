#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"

if [[ -z "$TARGET_USER" ]]; then
    exit 0
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

cat > "$TARGET_HOME/Continue_Setup.sh" <<'EOF'
#!/usr/bin/env bash

MARKER="$HOME/.adal-workstation-installed"

if [[ -f "$MARKER" ]]; then
    echo
    echo "Workstation already configured."
    exit 0
fi

echo
echo "Welcome to eng-workstation."
echo
echo "Documentation:"
echo "https://example.com"
echo
EOF

chmod +x "$TARGET_HOME/Continue_Setup.sh"
chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/Continue_Setup.sh"
