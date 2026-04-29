#!/bin/bash

# Cache full sink info once (important)
SINK_INFO="$(pactl list sinks)"

# Get list of sinks (id:name)
sinks="$(pactl list short sinks | awk '{print $1":"$2}')"

menu=""
declare -A sink_map

while IFS= read -r line; do
    sink_id="${line%%:*}"
    sink_name="${line##*:}"

    # Extract friendly description
    description="$(echo "$SINK_INFO" \
        | awk -v name="$sink_name" '
            $0 ~ "Name: "name {found=1}
            found && /Description:/ {
                sub("^[[:space:]]*Description: ", "")
                print
                exit
            }
        ')"

    display_name="${description:-$sink_name}"

    sink_map["$display_name"]="$sink_name"
    menu+="$display_name\n"
done <<< "$sinks"

# Rofi menu
selected="$(printf "%b" "$menu" | fuzzel --dmenu -i -p " audio out")"
[ -z "$selected" ] && exit 0

sink_name="${sink_map[$selected]}"

if [ -n "$sink_name" ]; then
    pactl set-default-sink "$sink_name"

    # Move all active streams
    pactl list short sink-inputs | awk '{print $1}' | while read -r stream; do
        pactl move-sink-input "$stream" "$sink_name"
    done

    command -v notify-send >/dev/null &&
        notify-send "Audio Output" "Switched to: $selected"
fi

