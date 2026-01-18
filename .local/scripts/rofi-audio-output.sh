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
selected="$(printf "%b" "$menu" | rofi -dmenu -i \
  -p " audio out" \
  -theme-str '
* {
    font: "JetBrainsMono Nerd Font 12";
    bg: #1e1e2e;
    bg-alt: #181825;
    fg: #cdd6f4;
    fg-alt: #7f849c;
    accent: #a6e3a1;
}
window {
    width: 40%;
    location: center;
    anchor: center;
    background-color: @bg;
    border-radius: 18px;
}
mainbox {
    padding: 18px;
}
listview {
    lines: 7;
    spacing: 8px;
}
element {
    padding: 12px;
    border-radius: 14px;
}
element selected {
    background-color: @accent;
    text-color: @bg;
}
'
)"

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

