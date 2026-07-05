#!/usr/bin/env bash
# Minimal volume OSD — extracted from osd_router.sh
# Usage: osd_volume.sh {--vol-up|--vol-down|--vol-mute} [step]

SYNC_ID="sys-osd"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/osd_audio_state.txt"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/osd_audio.lock"
UI_LOCK="${XDG_RUNTIME_DIR:-/tmp}/osd_audio_ui.lock"

notify() {
    local icon="$1" title="$2" val="$3"
    if [[ -n "$val" ]]; then
        notify-send -a "OSD" -h string:x-canonical-private-synchronous:"$SYNC_ID" -h int:value:"$val" -i "$icon" "$title"
    else
        notify-send -a "OSD" -h string:x-canonical-private-synchronous:"$SYNC_ID" -i "$icon" "$title"
    fi
}

atomic_write() {
    echo "$2" > "${1}.tmp"
    mv "${1}.tmp" "$1"
}

action="$1"
step="${2:-5}"

case "$action" in
    --vol-up|--vol-down)
        exec {lock_fd}> "$LOCK_FILE"
        flock -x "$lock_fd"

        if [[ "$action" == "--vol-up" ]]; then
            wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "${step}%+"
            icon="audio-volume-high"
        else
            wpctl set-volume @DEFAULT_AUDIO_SINK@ "${step}%-"
            icon="audio-volume-low"
        fi

        vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100 + 0.5)}')
        title="Volume: ${vol}%"
        atomic_write "$STATE_FILE" "$icon|$title|$vol"
        exec {lock_fd}>&-
        ;;

    --vol-mute)
        exec {lock_fd}> "$LOCK_FILE"
        flock -x "$lock_fd"

        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

        if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
            icon="audio-volume-muted"; title="Audio Muted"; vol=""
        else
            icon="audio-volume-high"
            vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100 + 0.5)}')
            title="Audio Unmuted"
        fi

        atomic_write "$STATE_FILE" "$icon|$title|$vol"
        exec {lock_fd}>&-
        ;;

    *)
        echo "Usage: $0 {--vol-up|--vol-down|--vol-mute} [step]"
        exit 1
        ;;
esac

# Debounced single-shot notify worker: coalesces rapid key-repeat events
# so you get one settling notification instead of a flood.
(
    flock -n 9 || exit 0
    while true; do
        IFS='|' read -r c_icon c_title c_vol < "$STATE_FILE"
        [[ -z "$c_title" ]] && break
        notify "$c_icon" "$c_title" "$c_vol"
        sleep 0.05
        IFS='|' read -r n_icon n_title n_vol < "$STATE_FILE"
        [[ "$c_vol" == "$n_vol" && "$c_icon" == "$n_icon" && "$c_title" == "$n_title" ]] && break
    done
) 9>> "$UI_LOCK" &
