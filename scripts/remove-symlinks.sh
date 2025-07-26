#!/bin/bash

# Desktop Config Cleanup Script
# This script removes symlinks created by setup-symlinks.sh and restores backups if available

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Desktop Configuration Cleanup Script ===${NC}"
echo

# Function to remove symlink and restore backup
remove_symlink() {
    local target="$1"
    local description="$2"
    
    echo -e "${YELLOW}Cleaning up: $description${NC}"
    echo "  Target: $target"
    
    if [ -L "$target" ]; then
        echo "  Removing symlink: $target"
        rm "$target"
        
        # Look for most recent backup
        backup_file=$(find "$(dirname "$target")" -name "$(basename "$target").backup.*" -type f 2>/dev/null | sort -r | head -n1)
        
        if [ -n "$backup_file" ]; then
            echo "  Restoring backup: $backup_file -> $target"
            mv "$backup_file" "$target"
            echo -e "${GREEN}  ✓ Backup restored${NC}"
        else
            echo -e "${YELLOW}  ! No backup found${NC}"
        fi
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}  ! Target exists but is not a symlink, skipping${NC}"
    else
        echo -e "${YELLOW}  ! Target does not exist${NC}"
    fi
    echo
}

# Remove configuration symlinks
echo -e "${BLUE}=== Removing Configuration Symlinks ===${NC}"
echo

remove_symlink \
    "$HOME/.config/i3/config" \
    "i3 window manager configuration"

remove_symlink \
    "$HOME/.config/i3status/config" \
    "i3status bar configuration"

remove_symlink \
    "$HOME/.config/picom/picom.conf" \
    "Picom compositor configuration"

echo -e "${BLUE}=== Cleanup Summary ===${NC}"
echo -e "${GREEN}✓ Configuration symlinks removed${NC}"
echo -e "${GREEN}✓ Backup files restored where available${NC}"
echo
echo -e "${YELLOW}Note: You may need to restart i3 or logout/login for changes to take effect${NC}"
