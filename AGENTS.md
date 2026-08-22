# AGENTS.md

## Project Overview

Linux desktop configuration files for the i3 window manager. Managed via symlinks from this repo to `~/.config/` paths.

## Current Status

Hyprland migration is **postponed** — i3 is the active window manager for now. Reason: some apps don't work under Hyprland (e.g. Postman). The Hyprland/Waybar/wofi config files remain in the repo for the future migration but are not a priority.

## Repository Structure

```
config/
  i3/config                   # i3 window manager config (keybindings, workspaces, bar, colors)
  i3status/config             # i3status bar modules (battery, time, wifi, etc.)
  picom/picom.conf            # Picom compositor
  rofi/themes/                # Rofi themes
  kitty/kitty.conf            # Kitty terminal config
  ranger/rc.conf              # Ranger file manager config
  hypr/hyprland.lua           # Hyprland window manager config (Lua DSL)
  hypr/hyprlock.conf          # Hyprlock lock screen config (mirrors palette)
  waybar/config.jsonc         # Waybar status bar config
  waybar/style.css            # Waybar styling
  waybar/quote.config.jsonc   # Waybar quote bar config (runs bin/quote.sh)
  waybar/quote.style.css      # Waybar quote bar styling
  wofi/style.css              # Wofi launcher style (mirrors rofi DarkBlueFork)
bin/
  set-wallpaper.sh            # Wallpaper setter for i3 (feh)
  set-wallpaper-hypr.sh       # Wallpaper setter for Hyprland (swaybg + wofi)
  screenshot.sh               # Screenshot tool for i3 (maim, xdotool, xclip)
  screenshot-hypr.sh          # Screenshot tool for Hyprland (grim, slurp, wl-copy)
  caffeine.sh                 # Caffeine toggle (xset, xdg-screensaver)
  quote.sh                    # Prints a single-line fortune (for the Waybar quote bar)
  rename-workspace.sh         # Renames active workspace (Hyprland, hyprctl + wofi)
scripts/
  ws1-comm.sh                 # Opens Firefox with WhatsApp on workspace 1
  ws-saktimart.sh             # Opens saktimart project workspace
  ws-sisbinkar.sh             # Opens sisbinkar project workspace
  ws-siura.sh                 # Opens siura project workspace
setup/
  setup-symlinks.sh           # Creates symlinks from repo to ~/.config/
  install-packages.sh         # Installs apt packages
  scripts-make-executable.sh  # Makes scripts executable
```

## Conventions

- All shell scripts use `#!/bin/bash` shebang
- Config symlinks point from `~/.config/<app>/config` to `$REPO/config/<app>/config`
- i3 config references scripts via variables: `$bin`, `$scripts`, `$config`
- Hardcoded paths reference `/home/xlwp/Projects/personal/desktop-config` (update if repo moves)
- Shell scripts should be made executable after changes: run `setup/scripts-make-executable.sh`

## Key Bindings

- Mod key: `Mod4` (Super/Windows)
- Terminal: `$mod+t` (kitty), `$mod+Shift+t` (gnome-terminal)
- Launcher: `$mod+d` (drun), `$mod+Shift+d` (run) — rofi
- Apps: `$mod+f` (firefox), `$mod+Shift+f` (firefox private), `$mod+c` (VS Code), `$mod+e` (nemo), `$mod+Shift+e` (ranger), `$mod+g` (chrome), `$mod+Shift+g` (chrome incognito), `Ctrl+Shift+Escape` (system monitor)
- Workspace mode: `$mod+grave` (custom workspace launcher)
- System mode: `$mod+BackSpace` or `$mod+Escape`
- Resize mode: `$mod+r`
- Screenshot: `Print` (full), `$mod+Print` (window), `Shift+Print` (select)
- Wallpaper (i3): `$mod+Shift+w` (random, feh), `$mod+Ctrl+w` (browse via rofi)
- Wallpaper (Hyprland): `$mod+Shift+w` (random, swaybg), `$mod+Ctrl+w` (browse via wofi)
- Rename workspace (i3): `$mod+n` (i3-input)
- Reload config: `$mod+Shift+c`
- Restart i3: `$mod+Shift+r`
- Kill focused window: `$mod+Shift+q`
- Caffeine toggle: `$mod+Shift+z`
- Restart picom: `$mod+Ctrl+p` (references `$bin/start-picom.sh` — NOTE: script missing from repo)
- Audio: `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` / `XF86AudioMute` / `XF86AudioMicMute`
- Brightness: `XF86MonBrightnessUp` / `XF86MonBrightnessDown`
- Exit: `$mod+Shift+x` (i3-nagbar)

## After Making Changes

1. Make new scripts executable: run `setup/scripts-make-executable.sh` (covers both `bin/` and `scripts/`)
2. If symlinks are new, re-run `setup/setup-symlinks.sh`
3. Reload i3 config: `i3-msg reload` or press `$mod+Shift+c`
4. No linting or typechecking — just validate shell scripts with `bash -n <file>` for syntax errors

### Fresh clone setup

1. `setup/scripts-make-executable.sh` — make scripts executable
2. `setup/setup-symlinks.sh` — create symlinks to `~/.config/`

## Dependencies

acpi, bc, bluez, blueman, brightnessctl, dex, feh, firefox-esr, gnome-system-monitor, gnome-terminal, i3, i3lock, i3lock-fancy, i3status, jq, kitty, libnotify-bin, maim, nemo, network-manager, network-manager-gnome, picom, rofi, scrot, xclip, xdotool, xinput

### Manual install
google-chrome (downloaded from Google's website)
