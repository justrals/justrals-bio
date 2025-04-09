#!/bin/sh

# Kindle PW1 BusyBox Updater (2014-compatible)
# -------------------------------------------
# Works with BusyBox 1.16.0-1.20.0 (no curl/file/wget-O)
# Run in KTerm or via USBNetwork.

# BusyBox URL (ARMv5 static binary)
BUSYBOX_URL="http://www.busybox.net/downloads/binaries/1.21.1/busybox-armv5l"
TMP_DIR="/mnt/us/busybox_update"
NEW_BUSYBOX="$TMP_DIR/busybox-new"

# Create temp dir
mkdir -p "$TMP_DIR"

# Download BusyBox (old wget lacks -O, use redirect)
echo "[1/4] Downloading BusyBox..."
wget "$BUSYBOX_URL" -o "$NEW_BUSYBOX" 2>/dev/null
if [ ! -f "$NEW_BUSYBOX" ]; then
  echo "Error: Download failed. Try manual download."
  exit 1
fi

# Basic ARM check (no 'file' command, use 'head' magic bytes)
if ! head -c 3 "$NEW_BUSYBOX" | grep -q "ARM"; then
  echo "Error: Not an ARM binary. Corrupt download?"
  rm -f "$NEW_BUSYBOX"
  exit 1
fi

# Remount root as RW
echo "[2/4] Remounting rootfs..."
mount -o remount,rw /

# Backup old BusyBox
echo "[3/4] Backing up old BusyBox..."
cp /bin/busybox /bin/busybox.bak

# Install new BusyBox
echo "[4/4] Installing new BusyBox..."
cp "$NEW_BUSYBOX" /bin/busybox
chmod 755 /bin/busybox
/bin/busybox --install -s /bin  # Recreate symlinks

# Cleanup
rm -rf "$TMP_DIR"

# Sync and reboot
echo "Done! Rebooting..."
sync
reboot