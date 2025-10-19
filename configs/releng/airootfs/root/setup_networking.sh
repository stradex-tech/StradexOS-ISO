#!/bin/bash
# Networking setup script for StradexOS-ISO
# This script configures WiFi or wired networking before archinstall

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if we have internet connectivity
check_internet() {
    print_status "Checking internet connectivity..."
    if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
        print_success "Internet connection is working!"
        return 0
    else
        print_warning "No internet connection detected"
        return 1
    fi
}

# Function to scan and connect to WiFi
setup_wifi() {
    print_status "Setting up WiFi connection..."
    
    # Check if WiFi is available
    if ! ip link show | grep -q "wlan"; then
        print_error "No WiFi interface found"
        return 1
    fi
    
    # Start NetworkManager if not running
    if ! systemctl is-active --quiet NetworkManager; then
        print_status "Starting NetworkManager..."
        systemctl start NetworkManager
        sleep 2
    fi
    
    # Scan for available networks
    print_status "Scanning for available WiFi networks..."
    nmcli dev wifi list
    
    echo ""
    print_status "Enter WiFi network details:"
    read -p "SSID (network name): " wifi_ssid
    read -s -p "Password: " wifi_password
    echo ""
    
    if [ -z "$wifi_ssid" ]; then
        print_error "SSID cannot be empty"
        return 1
    fi
    
    # Connect to WiFi
    print_status "Connecting to $wifi_ssid..."
    if nmcli dev wifi connect "$wifi_ssid" password "$wifi_password" >/dev/null 2>&1; then
        print_success "Connected to $wifi_ssid"
        return 0
    else
        print_error "Failed to connect to $wifi_ssid"
        return 1
    fi
}

# Function to setup wired connection
setup_wired() {
    print_status "Setting up wired connection..."
    
    # Check if ethernet is available
    if ! ip link show | grep -q "eth\|en"; then
        print_error "No ethernet interface found"
        return 1
    fi
    
    # Start NetworkManager if not running
    if ! systemctl is-active --quiet NetworkManager; then
        print_status "Starting NetworkManager..."
        systemctl start NetworkManager
        sleep 2
    fi
    
    # Enable ethernet connection
    print_status "Enabling ethernet connection..."
    nmcli dev connect $(ip link show | grep -E "eth|en" | head -1 | cut -d: -f2 | tr -d ' ')
    
    if [ $? -eq 0 ]; then
        print_success "Ethernet connection enabled"
        return 0
    else
        print_error "Failed to enable ethernet connection"
        return 1
    fi
}

# Function to configure static IP
configure_static_ip() {
    print_status "Configuring static IP..."
    
    # Get current connection name
    connection_name=$(nmcli -t -f NAME connection show --active | head -1)
    
    if [ -z "$connection_name" ]; then
        print_error "No active connection found"
        return 1
    fi
    
    echo ""
    print_status "Enter static IP configuration:"
    read -p "IP Address (e.g., 192.168.1.100): " static_ip
    read -p "Gateway (e.g., 192.168.1.1): " gateway
    read -p "DNS Server (e.g., 8.8.8.8): " dns_server
    read -p "Subnet mask (e.g., 24): " subnet_mask
    
    if [ -z "$static_ip" ] || [ -z "$gateway" ] || [ -z "$dns_server" ]; then
        print_error "IP address, gateway, and DNS server are required"
        return 1
    fi
    
    # Configure static IP
    print_status "Applying static IP configuration..."
    nmcli connection modify "$connection_name" ipv4.addresses "$static_ip/$subnet_mask"
    nmcli connection modify "$connection_name" ipv4.gateway "$gateway"
    nmcli connection modify "$connection_name" ipv4.dns "$dns_server"
    nmcli connection modify "$connection_name" ipv4.method manual
    
    # Restart connection
    nmcli connection down "$connection_name"
    nmcli connection up "$connection_name"
    
    if [ $? -eq 0 ]; then
        print_success "Static IP configured successfully"
        return 0
    else
        print_error "Failed to configure static IP"
        return 1
    fi
}

# Function to configure dynamic IP
configure_dynamic_ip() {
    print_status "Configuring dynamic IP (DHCP)..."
    
    # Get current connection name
    connection_name=$(nmcli -t -f NAME connection show --active | head -1)
    
    if [ -z "$connection_name" ]; then
        print_error "No active connection found"
        return 1
    fi
    
    # Configure DHCP
    nmcli connection modify "$connection_name" ipv4.method auto
    
    # Restart connection
    nmcli connection down "$connection_name"
    nmcli connection up "$connection_name"
    
    if [ $? -eq 0 ]; then
        print_success "Dynamic IP configured successfully"
        return 0
    else
        print_error "Failed to configure dynamic IP"
        return 1
    fi
}

# Main networking setup function
setup_networking() {
    clear
    echo "=========================================="
    echo "    StradexOS-ISO Networking Setup"
    echo "=========================================="
    echo ""
    
    # Check if we already have internet
    if check_internet; then
        print_success "Internet connection is already working!"
        echo ""
        read -p "Do you want to reconfigure networking? (y/N): " reconfigure
        if [[ ! "$reconfigure" =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    echo "Select connection type:"
    echo "1) WiFi"
    echo "2) Wired (Ethernet)"
    echo "3) Skip networking setup"
    echo ""
    read -p "Enter your choice (1-3): " connection_choice
    
    case $connection_choice in
        1)
            if setup_wifi; then
                print_success "WiFi setup completed"
            else
                print_error "WiFi setup failed"
                return 1
            fi
            ;;
        2)
            if setup_wired; then
                print_success "Wired setup completed"
            else
                print_error "Wired setup failed"
                return 1
            fi
            ;;
        3)
            print_warning "Skipping networking setup"
            return 0
            ;;
        *)
            print_error "Invalid choice"
            return 1
            ;;
    esac
    
    # Wait a moment for connection to stabilize
    sleep 3
    
    # Check internet connectivity
    if check_internet; then
        echo ""
        echo "Select IP configuration:"
        echo "1) Dynamic IP (DHCP)"
        echo "2) Static IP"
        echo "3) Keep current configuration"
        echo ""
        read -p "Enter your choice (1-3): " ip_choice
        
        case $ip_choice in
            1)
                configure_dynamic_ip
                ;;
            2)
                configure_static_ip
                ;;
            3)
                print_status "Keeping current IP configuration"
                ;;
            *)
                print_warning "Invalid choice, keeping current configuration"
                ;;
        esac
        
        # Final connectivity check
        if check_internet; then
            print_success "Networking setup completed successfully!"
            echo ""
            print_status "Current network configuration:"
            ip addr show
            echo ""
            print_status "Testing connectivity to archlinux.org..."
            if ping -c 1 -W 3 archlinux.org >/dev/null 2>&1; then
                print_success "Ready to proceed with archinstall!"
                return 0
            else
                print_warning "Cannot reach archlinux.org, but basic internet works"
                return 0
            fi
        else
            print_error "Networking setup failed - no internet connectivity"
            return 1
        fi
    else
        print_error "Networking setup failed - no internet connectivity"
        return 1
    fi
}

# Run the networking setup
setup_networking
