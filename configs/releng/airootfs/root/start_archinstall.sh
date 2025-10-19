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
echo "Default filesystem: btrfs (with snapshots and compression)"
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
