#!/bin/bash
# Auto-start archinstall script for StradexOS-ISO
# This script will automatically launch archinstall when the live environment boots

# Clear the screen for a clean start
clear

# Display welcome message
echo "=========================================="
echo "    Welcome to StradexOS-ISO Installer"
echo "=========================================="
echo ""
echo "This ISO will automatically start the Arch Linux installer."
echo "You can choose from multiple filesystem options:"
echo "  • ext4 (stable, widely used)"
echo "  • btrfs (advanced features, snapshots)"
echo "  • xfs (high performance)"
echo "  • f2fs (flash storage optimized)"
echo "  • jfs (journaled filesystem)"
echo "  • nilfs2 (continuous snapshotting)"
echo ""
echo "Starting archinstall in 3 seconds..."
echo "Press Ctrl+C to cancel and get a shell instead"
echo ""

# Countdown
for i in 3 2 1; do
    echo -n "$i... "
    sleep 1
done
echo ""

# Start archinstall
archinstall
