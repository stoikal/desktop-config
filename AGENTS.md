# AGENTS.md

## Project Overview

Linux desktop configuration files for the i3 window manager. Managed via symlinks from this repo to `~/.config/` paths.

## Repository Structure

```
config/
  i3/config                   # i3 window manager config (keybindings, workspaces, bar, colors)
  i3status/config             # i3status bar modules (battery, time, wifi, etc.)
  picom/picom.conf            # Picom compositor
  rofi/themes/                # Rofi themes
  kitty/kitty.conf            # Kitty terminal config
  ranger/rc.conf              # Ranger file manager config
bin/
  set-wallpaper.sh            # Wallpaper setter (feh)
  screenshot.sh               # Screenshot tool (maim, xdotool, xclip)
  caffeine.sh                 # Caffeine toggle (xset, xdg-screensaver)
  i3blocks/                   # i3blocks blocklets
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
- Shell scripts should be made executable after changes: `find bin scripts -name "*.sh" -type f -exec chmod +x {} \;`

## Key Bindings

- Mod key: `Mod4` (Super/Windows)
- Terminal: `$mod+Return` or `$mod+t` (kitty)
- Launcher: `$mod+d` (drun), `$mod+Shift+d` (run) — rofi
- Workspace mode: `$mod+grave` (custom workspace launcher)
- System mode: `$mod+BackSpace` or `$mod+Escape`
- Resize mode: `$mod+r`
- Screenshot: `Print` (full), `$mod+Print` (window), `Shift+Print` (select)
- Wallpaper: `$mod+Shift+w` (random), `$mod+Ctrl+w` (browse)
- Reload config: `$mod+Shift+c`
- Exit: `$mod+Shift+x` (i3-nagbar)

## After Making Changes

1. Make new scripts executable: `chmod +x` or re-run `setup/scripts-make-executable.sh`
2. If symlinks are new, re-run `setup/setup-symlinks.sh`
3. Reload i3 config: `i3-msg reload` or press `$mod+Shift+c`
4. No linting or typechecking — just validate shell scripts with `bash -n <file>` for syntax errors

## Dependencies

acpi, bc, brightnessctl, dex, feh, firefox-esr, gnome-system-monitor, gnome-terminal, i3, i3lock, i3lock-fancy, i3status, jq, kitty, libnotify-bin, maim, nemo, network-manager, network-manager-gnome, picom, rofi, scrot, xclip, xdotool, xinput

### Manual install
google-chrome (downloaded from Google's website)
