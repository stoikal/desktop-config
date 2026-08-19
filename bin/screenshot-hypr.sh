#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$SCREENSHOT_DIR"

take_screenshot() {
    local mode="$1"
    local filename="$SCREENSHOT_DIR/screenshot_${TIMESTAMP}.png"

    case "$mode" in
        "full")
            grim "$filename"
            ;;
        "window")
            grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$filename"
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

        # Optional: Show notification (requires notify-send)
        if command -v notify-send &> /dev/null; then
            notify-send "Screenshot" "Saved to $filename" --icon=camera-photo
        fi

        # Optional: Copy to clipboard (requires wl-copy)
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

# Main execution
take_screenshot "$1"
