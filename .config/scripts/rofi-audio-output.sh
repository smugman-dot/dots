
# Get list of sinks with their descriptions
sinks=$(pactl list short sinks | awk '{print $1":"$2}')

# Build menu with sink descriptions
menu=""
declare -A sink_map

while IFS= read -r line; do
    sink_id=$(echo "$line" | cut -d: -f1)
    sink_name=$(echo "$line" | cut -d: -f2)
    
    # Get the description (friendly name) for this sink
    description=$(pactl list sinks | grep -A 10 "Name: $sink_name" | grep "Description:" | cut -d: -f2- | sed 's/^[[:space:]]*//')
    
    # Use description if available, otherwise use sink name
    if [ -n "$description" ]; then
        display_name="$description"
    else
        display_name="$sink_name"
    fi
    
    # Store mapping
    sink_map["$display_name"]="$sink_name"
    
    # Add to menu
    menu+="$display_name\n"
done <<< "$sinks"

# Show rofi menu and get selection
selected=$(echo -e "$menu" | rofi -dmenu -i -p "Audio Output")

# Exit if nothing selected
if [ -z "$selected" ]; then
    exit 0
fi

# Get the sink name from the selected description
sink_name="${sink_map[$selected]}"

if [ -n "$sink_name" ]; then
    # Set as default sink
    pactl set-default-sink "$sink_name"
    
    # Move all currently playing streams to the new sink
    pactl list short sink-inputs | awk '{print $1}' | while read -r stream; do
        pactl move-sink-input "$stream" "$sink_name"
    done
    
    # Optional: Show notification (requires notify-send)
    if command -v notify-send &> /dev/null; then
        notify-send "Audio Output" "Switched to: $selected"
    fi
fi
