#!/usr/bin/env bash

# Optimized Cava Config
CAVA_CONF="/tmp/waybar_cava.conf"
cat >"$CAVA_CONF" <<EOF
[general]
framerate = 25
bars = 16
[input]
method = pipewire
source = auto
[output]
method = raw
channels = stereo
data_format = ascii
ascii_max_range = 7
EOF

# Visualizer characters
chars=(" " "▂" "▃" "▄" "▅" "▆" "▇" "█")

# State Management
CUR_TRACK=""
TIMER=0
FPS=25
DISPLAY_SECONDS=3
DISPLAY_FRAMES=$((FPS * DISPLAY_SECONDS))
STATUS="Stopped"
FRAME_COUNTER=0

# Clean up on exit
trap "pkill -P $$" EXIT

# Start Cava - The loop only runs when Cava sends data
cava -p "$CAVA_CONF" | while read -r line; do
    # Only check playerctl metadata every 1 second (saves massive CPU)
    if ((FRAME_COUNTER % FPS == 0)); then
        STATUS=$(playerctl -p 'mpd,spotify,YoutubeMusic,chrome,%any' status 2>/dev/null)

        if [[ "$STATUS" == "Playing" ]]; then
            NEW_TRACK=$(playerctl -p 'mpd,spotify,YoutubeMusic,chrome,%any' metadata --format '{{title}}' 2>/dev/null)
            if [[ "$NEW_TRACK" != "$CUR_TRACK" ]]; then
                CUR_TRACK="$NEW_TRACK"
                TIMER=$DISPLAY_FRAMES
            fi
        fi
        FRAME_COUNTER=0
    fi
    ((FRAME_COUNTER++))

    # Handle JSON Output for Waybar
    if [[ "$STATUS" != "Playing" ]]; then
        # Matches your CSS: #custom-music.Paused
        echo "{\"text\": \"Paused\", \"class\": \"Paused\"}"
    elif ((TIMER > 0)); then
        # Show Title for 3 seconds
        SAFE_TITLE=$(echo "$CUR_TRACK" | sed 's/"/\\"/g')
        echo "{\"text\": \"$SAFE_TITLE\", \"class\": \"Playing\"}"
        ((TIMER--))
    else
        # Show Stereo Visualizer (8 bars left, 8 bars right)
        VIS=""
        IFS=';' read -ra bars <<<"$line"
        for val in "${bars[@]}"; do
            if [[ -n "$val" ]]; then
                VIS="${VIS}${chars[$val]}"
            fi
        done
        # Matches your CSS: #custom-music.Playing (triggers RGB animation)
        echo "{\"text\": \"$VIS\", \"class\": \"Playing\", \"tooltip\": \"$CUR_TRACK\"}"
    fi
done
