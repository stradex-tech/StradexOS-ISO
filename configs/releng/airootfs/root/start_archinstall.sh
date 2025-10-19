#!/bin/bash
# Auto-start archinstall script for StradexOS-ISO
# This script will configure networking and then launch archinstall

# Clear the screen for a clean start
clear

# Display welcome message
echo "=========================================="
echo "    Welcome to StradexOS-ISO Installer"
echo "=========================================="
echo ""
echo "This ISO will configure networking and start the Arch Linux installer."
echo "Default filesystem: btrfs (with snapshots and compression)"
echo ""
echo "Starting networking setup in 3 seconds..."
echo "Press Ctrl+C to cancel and get a shell instead"
echo ""

# Countdown
for i in 3 2 1; do
    echo -n "$i... "
    sleep 1
done
echo ""

# Run networking setup first
echo "Setting up networking..."
if /root/setup_networking.sh; then
    echo ""
    echo "=========================================="
    echo "    Starting Archinstall"
    echo "=========================================="
    echo ""
    echo "Networking configured successfully!"
    echo "Starting archinstall in 3 seconds..."
    echo ""
    
    # Countdown before archinstall
    for i in 3 2 1; do
        echo -n "$i... "
        sleep 1
    done
    echo ""
    
    # Start archinstall
    archinstall
else
    echo ""
    echo "=========================================="
    echo "    Networking Setup Failed"
    echo "=========================================="
    echo ""
    echo "Networking setup failed. You can:"
    echo "1) Try manual networking setup"
    echo "2) Run archinstall anyway (may fail without internet)"
    echo "3) Get a shell to troubleshoot"
    echo ""
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            echo "Starting manual networking setup..."
            /root/setup_networking.sh
            ;;
        2)
            echo "Starting archinstall without internet..."
            archinstall
            ;;
        3)
            echo "Dropping to shell..."
            bash
            ;;
        *)
            echo "Invalid choice, dropping to shell..."
            bash
            ;;
    esac
fi
