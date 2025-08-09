#!/bin/bash

# Script to install essential i3 desktop packages
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PACKAGES=(
    i3
    i3status
    i3lock
    i3lock-fancy
    rofi
    picom
    feh
    scrot
    maim
    xdotool
    xinput
)

echo -e "${YELLOW}Updating package list...${NC}"
sudo apt update

echo -e "${YELLOW}Installing packages: ${PACKAGES[*]}${NC}"
sudo apt install -y "${PACKAGES[@]}"

echo -e "${GREEN}✓ All packages installed successfully.${NC}"
