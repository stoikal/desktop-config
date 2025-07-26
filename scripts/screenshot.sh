#!/bin/bash

# Screenshot script that handles picom blur issues
# Usage: screenshot.sh [full|window|select]

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Create screenshots directory if it doesn't exist
mkdir -p "$SCREENSHOT_DIR"

# Function to take screenshot with picom handling
take_screenshot() {
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

# Main execution
take_screenshot "$1"
