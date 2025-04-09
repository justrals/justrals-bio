#!/bin/sh

# Remount root as read-write FIRST
echo "[0/4] Remounting root as RW..."
mount -o remount,rw /

# Backup old BusyBox
echo "[1/4] Backing up old BusyBox..."
cp /bin/busybox /bin/busybox.bak

# Copy new BusyBox
echo "[2/4] Installing new BusyBox..."
cp /mnt/us/busybox-armv5l /bin/busybox
chmod 755 /bin/busybox

# Recreate symlinks
echo "[3/4] Rebuilding symlinks..."
/bin/busybox --install -s /bin

# Sync and reboot
echo "[4/4] Done! Rebooting..."
sync
reboot