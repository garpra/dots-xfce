#!/usr/bin/env bash
set -euo pipefail

# Auto-detect PulseAudio / PipeWire devices
AUDIO_INTERNAL="$(pactl list short sources | grep monitor | awk '{print $2}' | head -n 1)"
AUDIO_MICROPHONE="$(pactl list short sources | grep -v monitor | awk '{print $2}' | head -n 1)"

OUTDIR="$HOME/Videos/Recording"
mkdir -p "$OUTDIR"

VIDEO_OUTPUT="$OUTDIR/video_$(date +%Y%m%d_%H%M%S).mp4"
AUDIO_OUTPUT="$OUTDIR/audio_$(date +%Y%m%d_%H%M%S).mp4"

start_recording() {
    echo "Starting recording..."

    ffmpeg -loglevel quiet -y -f x11grab -s "$(xrandr | awk '/\*/{print $1}')" -r 25 -i :0.0 \
        -f pulse -i "$AUDIO_INTERNAL" \
        -c:v libx265 -preset ultrafast -c:a aac "$VIDEO_OUTPUT" &

    ffmpeg -loglevel quiet -y -f pulse -i "$AUDIO_MICROPHONE" \
        -c:a libmp3lame "$AUDIO_OUTPUT" &

    echo "Recording started."
}

stop_recording() {
    echo "Stopping recording..."
    pkill -INT -x ffmpeg && echo "Stopped."
}

pause_recording() {
    echo "Pausing..."
    pkill -STOP -x ffmpeg
}
resume_recording() {
    echo "Resuming..."
    pkill -CONT -x ffmpeg
}

case "${1:-}" in
start) start_recording ;;
stop) stop_recording ;;
pause) pause_recording ;;
resume) resume_recording ;;
*) echo "Usage: $0 {start|stop|pause|resume}" ;;
esac
