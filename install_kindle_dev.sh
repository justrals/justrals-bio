#!/bin/sh

set -e

# Check if running on a Kindle
if ! { [ -f "/etc/prettyversion.txt" ] || [ -d "/mnt/us" ] || pgrep "lipc-daemon" >/dev/null; }; then
    echo "Error: This script must run on a Kindle device." >&2
    exit 1
fi

# Variables
REPO_URL="https://github.com/justrals/KindleFetch/archive/refs/heads/dev.zip"
ZIP_FILE="repo.zip"
EXTRACTED_DIR="KindleFetch-dev"
INSTALL_DIR="/mnt/us/extensions/kindlefetch"
CONFIG_FILE="$INSTALL_DIR/bin/kindlefetch_config"
TEMP_CONFIG="/tmp/kindlefetch_config_backup"

# Backup existing config
if [ -f "$CONFIG_FILE" ]; then
    echo "Backing up existing config..."
    cp -f "$CONFIG_FILE" "$TEMP_CONFIG"
fi

# Download repository
echo "Downloading KindleFetch..."
curl -L -o "$ZIP_FILE" "$REPO_URL"
echo "Download complete."

# Extract files
echo "Extracting files..."
unzip -o "$ZIP_FILE"
echo "Extraction complete."
rm -f "$ZIP_FILE"

# Remove old installation
echo "Removing old installation..."
rm -rf "$INSTALL_DIR"

# Install
echo "Installing KindleFetch..."
mv -f "$EXTRACTED_DIR/kindlefetch" "$INSTALL_DIR"
echo "Installation successful."

# Restore config
if [ -f "$TEMP_CONFIG" ]; then
    echo "Restoring configuration..."
    mv -f "$TEMP_CONFIG" "$CONFIG_FILE"
fi

# Cleanup
echo "Cleaning up..."
rm -rf "$EXTRACTED_DIR"

echo "KindleFetch installation completed successfully."
