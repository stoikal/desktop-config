# i3 → Sway Migration Plan

## Approach

- **Co-exist**: Both `config/i3/` and `config/sway/` tracked in repo. Keep i3 as fallback.
- **Bar**: Switch from i3status → **waybar** (native Wayland, CSS-styled)
- **Launcher**: Switch from rofi → **wofi** (native Wayland, similar UI)
- **Compositor**: Remove picom (Sway composites natively)
- **Structure**: Flat — each config directory maps 1:1 to `~/.config/<app>/`
- **Future**: Eventually remove i3 entirely (delete `config/i3/`, `config/i3status/`, `config/rofi/`, `config/picom/`)

## Files to Create

| File | Purpose |
|---|---|
| `config/sway/config` | Sway config (adapted from i3/config) |
| `config/swaylock/config` | Swaylock config (colors match i3 theme) |
| `config/waybar/config.jsonc` | Waybar bar modules/position |
| `config/waybar/style.css` | Waybar CSS (colors match i3 theme) |
| `config/wofi/config` | Wofi launcher config |
| `config/wofi/style.css` | Wofi launcher style |

## Files to Modify

| File | What changes |
|---|---|
| `bin/screenshot.sh` | Rewrite: `maim` → `grim`, `xdotool` → `swaymsg -t get_tree \| jq`, `xclip` → `wl-copy`, no picom handling |
| `bin/set-wallpaper.sh` | Rewrite: `feh` → `swaybg` (kill old swaybg, launch new one) |
| `bin/caffeine.sh` | Rewrite: `xset`/`xdg-screensaver` → `swaymsg inhibit_idle` |
| `scripts/ws1-comm.sh` | `i3-msg` → `swaymsg` |
| `scripts/ws-saktimart.sh` | `i3-msg` → `swaymsg`, `xdotool` → `swaymsg -t get_tree \| jq` |
| `setup/setup-symlinks.sh` | Add sway, swaylock, waybar, wofi symlinks |
| `setup/install-packages.sh` | Swap i3→sway, add swaybg/swayidle/swaylock/grim/slurp/wl-clipboard/jq/waybar/wofi, remove picom/maim/scrot/xdotool/xinput/i3lock/i3lock-fancy |
| `AGENTS.md` | Add sway config info, new deps, new key bindings |

## Files Unchanged (still tracked)

- `config/i3/config` — kept as reference/fallback
- `config/i3status/config` — kept (useful for i3 fallback)
- `config/i3blocks/` — kept
- `config/kitty/` — works natively on Wayland
- `config/ranger/` — works fine
- `config/rofi/` — kept (useful for i3 fallback)

## Key Sway Config Changes (vs i3)

### Removed (no Wayland equivalent needed)

- `xset b off` — no xset on Wayland
- `pkill picom; picom` — Sway composites natively
- `feh --bg-fill` — replaced by swaybg
- `setxkbmap` — replaced by sway `input` block
- `xinput` touchpad settings — replaced by sway `input` block

### Replaced with Sway-native

| i3 | Sway |
|---|---|
| `setxkbmap -layout us -variant altgr-intl` | `input type:keyboard { xkb_layout "us"; xkb_variant "altgr-intl"; }` |
| `xinput set-prop ... Natural Scrolling` | `input type:touchpad { natural_scroll enabled; tap enabled; }` |
| `feh --bg-fill` | `exec swaybg -i ~/Pictures/Wallpapers/... -m fill` |
| `picom` | nothing (Sway composites natively) |
| `xss-lock -- i3lock-fancy` | `exec swayidle -w ...` |
| `i3lock-fancy` | `swaylock` |
| `i3-nagbar` exit prompt | `swaynag -t warning -m 'Exit Sway?' -B 'Yes' 'swaymsg exit'` |
| `i3-input rename workspace` | `exec wofi -d -p "New name:" \| xargs -I{} swaymsg rename workspace to "{}"` |
| `dex --environment i3` | `dex --environment sway` |
| `bar { status_command i3status }` | removed (using waybar instead) |

### Waybar

Replicates current i3status modules: battery, time, wifi, plus workspace buttons. Colors match i3 theme (`#170E23` bg, `#E5FF00` accent).

### Wofi

Mimics rofi DarkBlueFork theme colors for the launcher.

## Package Changes

### Remove

- `i3` (or keep for fallback)
- `i3lock`, `i3lock-fancy`
- `picom`
- `scrot`, `maim`
- `xdotool`, `xinput`
- `feh` (or keep for i3 fallback)

### Add

- `sway`
- `swaybg`, `swayidle`, `swaylock`
- `grim`, `slurp`
- `wl-clipboard`
- `jq` (for swaymsg parsing)
- `waybar`
- `wofi`

## Switching Between i3 and Sway

- **Display manager**: select "Sway" or "i3" session at login
- **No DM**: run `sway` from tty for Sway, `startx` for i3
