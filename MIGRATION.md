# i3 → Hyprland Migration Plan

# installed packages
- hyprland
- hyprland-guiutils
- waybar
- fonts-font-awesome
- hyprlauncher
- grim // for screenshot
- wl-copy

# removed packages




# REPLACEMENTS
i3 -> hyprland
i3Status -> waybar
rofi -> hyprlauncher
picom -> hyprland

#TODO
- [ ] bindsym $mod+Escape mode "$mode_system"
- [ ] bindsym $mod+grave mode "$mode_custom"
- [x] screenshot function
- [ ] wallpaper
- [ ] keybinding $mod+Return	kitty (hyprland only binds $mod+t)
- [x] $mod+Shift+t	gnome-terminal
- [x] $mod+f / $mod+Shift+f	firefox / private
- [ ] $mod+c	VS Code
- [ ] $mod+b	xdg-open about:blank
- [x] $mod+g / $mod+Shift+g	chrome / incognito
- [x] Ctrl+Shift+Escape	gnome-system-monitor
- [ ] $mod+Shift+d	rofi run (drun is covered by mainMod+D→hyprlauncher)

Missing: Window-management bindings
- $mod+h/j/k/l focus (hyprland only has arrow keys)
- $mod+Shift+h/j/k/l move window (hyprland only has Shift+number)
- $mod+Shift+arrows move
- $mod+Tab / $mod+Shift+Tab focus next/prev
- $mod+Ctrl+h / $mod+Ctrl+v split h/v (only $mod+J togglesplit exists)
- $mod+s stacking / $mod+w tabbed layouts
- $mod+space focus tiling/floating toggle (only Shift+V float toggle)
- $mod+a focus parent
- $mod+Shift+c reload, $mod+Shift+r restart (no equivalents)
- $mod+Shift+x exit w/ nagbar (only $mod+M hyprshutdown)
- Mouse titlebar: right-click→float, middle-click→close

Missing: Window rules / assignments
- assign Spotify→9, DBeaver→8, Postman→9, protonvpn/F5-VPN→0 — no workspace window rules
- Floating pop-up/task_dialog/Gnome-system-monitor rules

Missing: X11-only scripts needing Wayland rewrites
- screenshot.sh (maim/xdotool/xclip) → needs grim/slurp + hyprctl rewrite; Print/$mod+Print/Shift+Print unbound
- set-wallpaper.sh (feh) → needs hyprpaper/swww; $mod+Shift+w/$mod+Ctrl+w unbound
- caffeine.sh (xset) → needs different approach; $mod+Shift+z unbound
- ws1-comm.sh / ws-saktimart.sh → not wired (they launch Firefox with site URLs)