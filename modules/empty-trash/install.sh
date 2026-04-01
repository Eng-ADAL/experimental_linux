#!/usr/bin/env bash
set -e

INSTALL_PATH="/usr/local/bin/empty-trash"

echo "Installing empty-trash..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    echo "Installing dependencies..."
    sudo apt update
    sudo apt install -y trash-cli tree
else
    echo "Warning: Unsupported package manager."
    echo "Please install dependencies manually:"
    echo "  trash-cli"
    echo "  tree"
fi

echo "Installing script to $INSTALL_PATH"

sudo install -m 755 bin/empty-trash "$INSTALL_PATH"

echo
echo "Installation complete."
echo "Run with:"
echo "  empty-trash"
