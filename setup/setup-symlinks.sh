#!/bin/bash

# Desktop Config Setup Script
# This script creates symlinks for all configuration files to their correct system locations

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}=== Desktop Configuration Setup Script ===${NC}"
echo -e "${BLUE}Config root: $CONFIG_ROOT${NC}"
echo

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    echo -e "${YELLOW}Setting up: $description${NC}"
    echo "  Source: $source"
    echo "  Target: $target"
    
    # Check if source exists
    if [ ! -e "$source" ]; then
        echo -e "${RED}  ✗ Source file does not exist: $source${NC}"
        return 1
    fi
    
    # Create target directory if it doesn't exist
    target_dir="$(dirname "$target")"
    if [ ! -d "$target_dir" ]; then
        echo "  Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi
    
    # Handle existing target
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -L "$target" ]; then
            # It's already a symlink
            current_target="$(readlink "$target")"
            if [ "$current_target" = "$source" ]; then
                echo -e "${GREEN}  ✓ Symlink already exists and is correct${NC}"
                return 0
            else
                echo "  Removing old symlink: $target -> $current_target"
                rm "$target"
            fi
        else
            # It's a regular file/directory, backup it
            backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
            echo "  Backing up existing file: $target -> $backup_name"
            mv "$target" "$backup_name"
        fi
    fi
    
    # Create the symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}  ✓ Symlink created successfully${NC}"
    echo
}

# Function to setup VS Code workspace settings
setup_vscode_settings() {
    echo -e "${BLUE}=== VS Code Workspace Settings ===${NC}"
    
    local source="$CONFIG_ROOT/.vscode/settings.json"
    local target="$CONFIG_ROOT/.vscode/settings.json"
    
    if [ -f "$source" ]; then
        echo -e "${GREEN}✓ VS Code workspace settings already in place${NC}"
    else
        echo -e "${YELLOW}VS Code workspace settings will be created when you open the workspace${NC}"
    fi
    echo
}

# Main configuration mappings
echo -e "${BLUE}=== Creating Configuration Symlinks ===${NC}"
echo

# i3 window manager configuration
create_symlink \
    "$CONFIG_ROOT/config/i3/config" \
    "$HOME/.config/i3/config" \
    "i3 window manager configuration"

# i3status configuration
create_symlink \
    "$CONFIG_ROOT/config/i3status/config" \
    "$HOME/.config/i3status/config" \
    "i3status bar configuration"

# Picom compositor configuration
create_symlink \
    "$CONFIG_ROOT/config/picom/picom.conf" \
    "$HOME/.config/picom/picom.conf" \
    "Picom compositor configuration"

# Setup VS Code settings
setup_vscode_settings

echo -e "${BLUE}=== Script Management ===${NC}"

# Make all scripts executable
echo -e "${YELLOW}Making scripts executable...${NC}"
find "$CONFIG_ROOT/bin" -name "*.sh" -type f -exec chmod +x {} \;
echo -e "${GREEN}✓ All scripts are now executable${NC}"
echo

echo -e "${BLUE}=== Setup Summary ===${NC}"
echo -e "${GREEN}✓ i3 configuration symlinked${NC}"
echo -e "${GREEN}✓ i3status configuration symlinked${NC}"
echo -e "${GREEN}✓ Picom configuration symlinked${NC}"
echo -e "${GREEN}✓ Scripts made executable${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Reload i3 configuration: Super+Shift+C"
echo "2. Restart i3: Super+Shift+R (or logout/login)"
echo "3. Test wallpaper script: $CONFIG_ROOT/bin/set-wallpaper.sh random"
echo "4. Test screenshot script: $CONFIG_ROOT/bin/screenshot.sh select"
echo
echo -e "${BLUE}Note: Your original config files have been backed up with timestamps${NC}"
echo -e "${BLUE}Configuration changes in this repository will now automatically apply to your system${NC}"
