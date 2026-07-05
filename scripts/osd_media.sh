#!/usr/bin/env bash
# Minimal media OSD — extracted from osd_router.sh
# Usage: osd_media.sh {--play-pause|--next|--prev|--stop}

notify() {
    local icon="$1" title="$2"
    notify-send -a "OSD" -h string:x-canonical-private-synchronous:sys-osd -i "$icon" "$title"
}

action="$1"

old_meta=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
old_status=$(playerctl status 2>/dev/null)

case "$action" in
    --play-pause) playerctl play-pause ;;
    --next)       playerctl next ;;
    --prev)       playerctl previous ;;
    --stop)       playerctl stop ;;
    *)
        echo "Usage: $0 {--play-pause|--next|--prev|--stop}"
        exit 1
        ;;
esac

# Poll briefly for playerctl state to catch up (track/status change is async)
for ((i=0; i<100; i++)); do
    status=$(playerctl status 2>/dev/null)
    metadata=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)

    case "$action" in
        --play-pause)
            [[ "$status" != "$old_status" && -n "$status" ]] && break
            ;;
        --next|--prev)
            [[ "$metadata" != "$old_meta" ]] && break
            ;;
        --stop)
            [[ "$status" == "Stopped" || -z "$status" ]] && break
            ;;
    esac

    sleep 0.01
done

[[ -z "$metadata" || "$metadata" == " - " ]] && metadata="Unknown Track"

if [[ "$status" == "Playing" ]]; then
    icon="media-playback-start"
    title="$metadata"
elif [[ "$status" == "Paused" ]]; then
    icon="media-playback-pause"
    title="Paused: $metadata"
elif [[ "$status" == "Stopped" || -z "$status" ]]; then
    icon="media-playback-stop"
    title="Stopped"
else
    icon="dialog-error"
    title="No Active Player"
fi

notify "$icon" "$title"
