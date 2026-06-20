# AGENTS.md

## Project Overview

Linux desktop configuration files for i3 and Sway window managers. Managed via symlinks from this repo to `~/.config/` paths. Both WMs coexist — i3 is the current primary, Sway is being added for future migration.

## Repository Structure

```
config/
  i3/config                   # i3 window manager config (keybindings, workspaces, bar, colors)
  sway/config                 # Sway window manager config (to be created)
  i3status/config             # i3status bar modules (battery, time, wifi, etc.)
  waybar/config.jsonc         # Waybar bar config (to be created)
  waybar/style.css            # Waybar CSS styling (to be created)
  wofi/config                 # Wofi launcher config (to be created)
  wofi/style.css              # Wofi launcher styling (to be created)
  swaylock/config             # Swaylock config (to be created)
  swayidle/config             # Swayidle config (to be created)
  picom/picom.conf            # Picom compositor (i3 only, not used in Sway)
  rofi/themes/                # Rofi themes (i3 only, not used in Sway)
  kitty/kitty.conf            # Kitty terminal config (works on both)
  ranger/rc.conf              # Ranger file manager config (works on both)
bin/
  set-wallpaper.sh            # Wallpaper setter (feh for i3, swaybg for Sway)
  screenshot.sh               # Screenshot tool (maim for i3, grim/slurp for Sway)
  caffeine.sh                 # Caffeine toggle (xset for i3, swaymsg for Sway)
  i3blocks/                   # i3blocks blocklets (i3 only)
scripts/
  ws1-comm.sh                 # Opens Firefox with WhatsApp on workspace 1
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
- Workspace scripts use `i3-msg` to dynamically find available workspaces
- Hardcoded paths reference `/home/xlwp/Projects/personal/desktop-config` (update if repo moves)
- Shell scripts should be made executable after changes: `find bin scripts -name "*.sh" -type f -exec chmod +x {} \;`

## Key Bindings (i3)

- Mod key: `Mod4` (Super/Windows)
- Terminal: `$mod+Return` or `$mod+t` (kitty)
-Launcher: `$mod+d` (rofi drun), `$mod+Shift+d` (rofi run)
- Workspace mode: `$mod+grave` (custom workspace launcher)
- System mode: `$mod+BackSpace` or `$mod+Escape`
- Resize mode: `$mod+r`
- Screenshot: `Print` (full), `$mod+Print` (window), `Shift+Print` (select)
- Wallpaper: `$mod+Shift+w` (random), `$mod+Ctrl+w` (browse via rofi)
- Reload config: `$mod+Shift+c`
- Restart i3: `$mod+Shift+r`

## After Making Changes

1. Make new scripts executable: `chmod +x` or re-run `setup/scripts-make-executable.sh`
2. If symlinks are new, re-run `setup/setup-symlinks.sh`
3. Reload i3 config: `i3-msg reload` or press `$mod+Shift+c`
4. No linting or typechecking — just validate shell scripts with `bash -n <file>` for syntax errors

## Dependencies

i3, i3status, i3lock, i3lock-fancy, rofi, picom, feh, scrot, maim, xdotool, xinput, brightnessctl, kitty, gnome-terminal, firefox, jq, notify-send, xclip, acpi, nmcli, bc