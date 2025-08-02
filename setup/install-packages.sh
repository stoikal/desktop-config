#!/bin/bash

# Package installation script with confirmation prompts
# This script installs various packages needed for desktop configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
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

# Function to ask for confirmation
confirm_install() {
    local package_name="$1"
    local description="$2"
    
    echo ""
    print_info "Package: $package_name"
    echo "Description: $description"
    echo -n "Do you want to install $package_name? (y/n): "
    read -r response
    
    case $response in
        [Yy]* ) return 0 ;;
        [Nn]* ) return 1 ;;
        * ) 
            print_warning "Invalid response. Skipping $package_name"
            return 1 ;;
    esac
}

# Function to install package
install_package() {
    local package_name="$1"
    
    print_info "Installing $package_name..."
    
    if sudo apt update && sudo apt install -y "$package_name"; then
        print_success "$package_name installed successfully!"
        return 0
    else
        print_error "Failed to install $package_name"
        return 1
    fi
}

# Main installation function
main() {
    print_info "Desktop Configuration Package Installer"
    echo "========================================"
    
    # Check if running on a Debian/Ubuntu system
    if ! command -v apt &> /dev/null; then
        print_error "This script is designed for Debian/Ubuntu systems with apt package manager"
        exit 1
    fi
    
    # Update package list first
    print_info "Updating package list..."
    sudo apt update
    
    # Array of packages with descriptions
    declare -A packages=(
        ["i3"]="i3 window manager - A tiling window manager"
        ["i3status"]="i3status - Status line generator for i3bar"
        ["i3lock"]="i3lock - Screen locker for i3"
        ["picom"]="Picom - Lightweight compositor for X11"
        ["feh"]="feh - Image viewer and wallpaper setter"
        ["rofi"]="Rofi - Application launcher and window switcher"
        ["dunst"]="Dunst - Lightweight notification daemon"
        ["alacritty"]="Alacritty - Fast, cross-platform terminal emulator"
        ["firefox"]="Firefox - Web browser"
        ["git"]="Git - Version control system"
        ["vim"]="Vim - Text editor"
        ["htop"]="htop - Interactive process viewer"
        ["neofetch"]="Neofetch - System information tool"
        ["scrot"]="Scrot - Screenshot utility"
        ["xss-lock"]="xss-lock - Screen saver integration"
    )
    
    # Track installation results
    installed_packages=()
    skipped_packages=()
    failed_packages=()
    
    # Install each package with confirmation
    for package in "${!packages[@]}"; do
        if confirm_install "$package" "${packages[$package]}"; then
            if install_package "$package"; then
                installed_packages+=("$package")
            else
                failed_packages+=("$package")
            fi
        else
            skipped_packages+=("$package")
        fi
    done
    
    # Summary
    echo ""
    echo "========================================"
    print_info "Installation Summary"
    echo "========================================"
    
    if [ ${#installed_packages[@]} -gt 0 ]; then
        print_success "Successfully installed packages:"
        printf '  - %s\n' "${installed_packages[@]}"
    fi
    
    if [ ${#skipped_packages[@]} -gt 0 ]; then
        print_warning "Skipped packages:"
        printf '  - %s\n' "${skipped_packages[@]}"
    fi
    
    if [ ${#failed_packages[@]} -gt 0 ]; then
        print_error "Failed to install packages:"
        printf '  - %s\n' "${failed_packages[@]}"
    fi
    
    echo ""
    print_info "Package installation process completed!"
    
    if [ ${#installed_packages[@]} -gt 0 ]; then
        echo ""
        print_info "You may need to log out and log back in or restart your system"
        print_info "to use some of the newly installed packages."
    fi
}

# Run main function
main "$@"
