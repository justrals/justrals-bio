#!/bin/sh

set -e  # Exit on error

REPO_URL="https://github.com/justrals/KindleFetch/archive/refs/heads/main.zip"
ZIP_FILE="repo.zip"
EXTRACTED_DIR="KindleFetch-main"
INSTALL_DIR="/mnt/us/extensions/kindlefetch"
CONFIG_FILE="$INSTALL_DIR/bin/kindlefetch_config"
TEMP_CONFIG="/tmp/kindlefetch_config_backup"

# Backup existing config if it exists
if [ -f "$CONFIG_FILE" ]; then
    echo "Backing up existing config..."
    cp "$CONFIG_FILE" "$TEMP_CONFIG"
fi

# Download repository
echo "Downloading KindleFetch..."
if curl -L -o "$ZIP_FILE" "$REPO_URL"; then
    echo "Download complete."
else
    echo "Error: Failed to download repository." >&2
    exit 1
fi

# Extract files
echo "Extracting files..."
if unzip "$ZIP_FILE"; then
    echo "Extraction complete."
    rm "$ZIP_FILE"
else
    echo "Error: Failed to extract files." >&2
    exit 1
fi

# Navigate to extracted directory
cd "$EXTRACTED_DIR" || {
    echo "Error: Failed to enter extracted directory." >&2
    exit 1
}

# Remove old installation if it exists
echo "Removing old installation..."
rm -rf "$INSTALL_DIR"

# Move new installation
echo "Installing KindleFetch..."
if mv kindlefetch /mnt/us/extensions/; then
    echo "Installation successful."
else
    echo "Error: Failed to install KindleFetch." >&2
    exit 1
fi

# Restore config if it was backed up
if [ -f "$TEMP_CONFIG" ]; then
    echo "Restoring configuration..."
    mv "$TEMP_CONFIG" "$CONFIG_FILE"
fi

# Cleanup
echo "Cleaning up..."
cd ..
rm -rf "$EXTRACTED_DIR"

echo "Installation completed successfully."