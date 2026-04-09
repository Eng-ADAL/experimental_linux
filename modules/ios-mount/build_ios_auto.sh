#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Master iPhone iPad Setup Script for Linux
#
# This script automates:
#   1. Installation of dependencies and compilation of ifuse
#   2. Pairing with an iPhone (with passcode prompt if needed)
#   3. Creation of ~/iPhone and safe mounting
#   4. Adding persistent aliases for mount/unmount and quick navigation
#
# Aliases added:
#   imount   -> Mount iPhone/iPad and cd into ~/iPhone
#   iumount  -> Unmount iPhone safely
#   cdiph    -> Change directory to ~/iPhone
#
# Usage:
#   sudo ./build_ios_auto.sh
#
# Requirements:
#   - Debian-based Linux (tested on Debian 13 / Trixie) Optional:i3 windows tiling manager
#   - USB connection to iPhone or iPad
#
# Author: Eng-Adal
# GitHub: https://github.com/Eng-ADAL/ (replace with your link)
# License: MIT
# -----------------------------------------------------------------------------

set -euo pipefail

# ---------- Users ----------
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(eval echo "~$REAL_USER")

# ---------- Colored output ----------
info() { echo -e "\e[34m[INFO]\e[0m $1"; }
success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
error() { echo -e "\e[31m[ERROR]\e[0m $1"; }

# ---------- Root check ----------
if [[ $EUID -ne 0 ]]; then
    error "Run this script as root: sudo $0"
    exit 1
fi

# ---------- Variables ----------
MOUNT_DIR="$REAL_HOME/iPhone"
ALIAS_FILE="$REAL_HOME/.iphone_aliases.sh"

# ---------- Install dependencies ----------
info "Updating package list..."
apt update
info "Installing build dependencies..."
apt install -y git build-essential autoconf automake libtool pkg-config \
libfuse3-dev libplist-dev libimobiledevice-dev libssl-dev curl

# ---------- Install ifuse ----------
if ! command -v ifuse >/dev/null 2>&1; then
    info "Installing ifuse..."
    cd /usr/local/src || mkdir -p /usr/local/src && cd /usr/local/src
    if [[ ! -d ifuse ]]; then
        git clone https://github.com/libimobiledevice/ifuse.git
    else
        cd ifuse && git pull
    fi
    cd ifuse
    ./autogen.sh --prefix=/usr/local
    make -j"$(nproc)"
    make install
    ldconfig
    success "ifuse installed successfully!"
else
    info "ifuse is already installed: $(which ifuse)"
fi

# ---------- Pairing ----------
info "Checking for connected iPhone..."
DEVICE_ID=$(idevice_id -l || true)
if [[ -z "$DEVICE_ID" ]]; then
    error "No iPhone detected. Please connect your device via USB."
    exit 1
fi

info "Attempting to pair with iPhone $DEVICE_ID..."
while true; do
    PAIR_OUTPUT=$(idevicepair pair 2>&1 || true)
    if echo "$PAIR_OUTPUT" | grep -q "ERROR: Could not validate"; then
        echo "Please enter the passcode on your iPhone and hit Enter..."
        read -r
    else
        success "Paired with device $DEVICE_ID"
        break
    fi
done

# ---------- Mounting ----------
if [[ ! -d "$MOUNT_DIR" ]]; then
    mkdir -p "$MOUNT_DIR"
fi

info "Mounting iPhone..."
if mount | grep -q "$MOUNT_DIR"; then
    info "Already mounted"
else
    ifuse "$MOUNT_DIR"
    success "Mounted at $MOUNT_DIR"
fi

# ---------- Aliases ----------
info "Adding aliases..."
cat > "$ALIAS_FILE" <<'EOF'
alias imount='mkdir -p ~/iPhone && (mount | grep -q ~/iPhone && echo "Already mounted" || ifuse ~/iPhone) && cd ~/iPhone'
alias iumount='fusermount3 -u ~/iPhone 2>/dev/null || fusermount -u ~/iPhone 2>/dev/null || sudo umount -l ~/iPhone'
alias cdiph='cd ~/iPhone'
EOF

# Ensure shell loads aliases
if ! grep -q ".iphone_aliases.sh" "$HOME/.zshrc" 2>/dev/null; then
    sudo -u "$REAL_USER" bash -c "echo 'source $ALIAS_FILE' >> $REAL_HOME/.zshrc"
    info "Aliases will be available in new shell sessions."
fi

success "All done! Use 'imount', 'iumount', and 'cdiph' for your iPhone workflow."

