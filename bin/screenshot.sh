#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$SCREENSHOT_DIR"

take_screenshot_on_sway() {
    local mode="$1"
    local filename="$SCREENSHOT_DIR/screenshot_${TIMESTAMP}.png"

    case "$mode" in
        "full")
            grim "$filename"
            ;;
        "window")
            FOCUSED=$(swaymsg -t get_tree | jq -r '.. | select(.type? == "con" and .focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
            grim -g "$FOCUSED" "$filename"
            ;;
        "select")
            grim -g "$(slurp)" "$filename"
            ;;
        *)
            echo "Usage: $0 [full|window|select]"
            exit 1
            ;;
    esac

    # Check if screenshot was successful
    if [ -f "$filename" ]; then
        echo "Screenshot saved: $filename"

        if command -v notify-send &> /dev/null; then
            notify-send "Screenshot" "Saved to $filename" --icon=camera-photo
        fi

        if command -v wl-copy &> /dev/null; then
            wl-copy < "$filename"
            echo "Screenshot copied to clipboard"
        fi
    else
        echo "Screenshot failed or cancelled"
        if command -v notify-send &> /dev/null; then
            notify-send "Screenshot" "Failed or cancelled" --icon=dialog-error
        fi
    fi
}

take_screenshot_on_i3() {
    local mode="$1"
    local filename="$SCREENSHOT_DIR/screenshot_${TIMESTAMP}.png"
    
    case "$mode" in
        "full")
            maim "$filename"
            ;;
        "window")
            maim --window $(xdotool getactivewindow) "$filename"
            ;;
        "select")
            # Temporarily disable picom to prevent blur on selection overlay
            pkill picom
            
            # Take screenshot with selection
            maim --select "$filename"
            
            # Restart picom
            picom --experimental-backends &
            ;;
        *)
            echo "Usage: $0 [full|window|select]"
            exit 1
            ;;
    esac
    
    # Check if screenshot was successful
    if [ -f "$filename" ]; then
        echo "Screenshot saved: $filename"
        
        # Optional: Show notification (requires notify-send)
        if command -v notify-send &> /dev/null; then
            notify-send "Screenshot" "Saved to $filename" --icon=camera-photo
        fi
        
        # Optional: Copy to clipboard (requires xclip)
        if command -v xclip &> /dev/null; then
            xclip -selection clipboard -t image/png -i "$filename"
            echo "Screenshot copied to clipboard"
        fi
    else
        echo "Screenshot failed or cancelled"
        if command -v notify-send &> /dev/null; then
            notify-send "Screenshot" "Failed or cancelled" --icon=dialog-error
        fi
    fi
}


take_screenshot() {
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        take_screenshot_on_sway "$1"
    else
        take_screenshot_on_i3 "$1"
    fi
}

# Main execution
take_screenshot "$1"
