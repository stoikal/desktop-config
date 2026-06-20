#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

COMMON=(
    brightnessctl
    dex
    firefox-esr
    gnome-system-monitor
    gnome-terminal
    jq
    kitty
    libnotify-bin
    network-manager
    network-manager-gnome
    nemo
    xclip
)

I3_PACKAGES=(
    acpi
    bc
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

SWAY_PACKAGES=(
    sway
    swaybg
    swayidle
    swaylock
    grim
    slurp
    wl-clipboard
    waybar
    wofi
)

echo -e "${YELLOW}Updating package list...${NC}"
sudo apt update

echo -e "${YELLOW}Installing common packages: ${COMMON[*]}${NC}"
sudo apt install -y "${COMMON[@]}"

echo -e "${YELLOW}Installing i3 packages: ${I3_PACKAGES[*]}${NC}"
sudo apt install -y "${I3_PACKAGES[@]}"

echo -e "${YELLOW}Installing Sway packages: ${SWAY_PACKAGES[*]}${NC}"
sudo apt install -y "${SWAY_PACKAGES[@]}"

echo -e "${GREEN}✓ All packages installed successfully.${NC}"
