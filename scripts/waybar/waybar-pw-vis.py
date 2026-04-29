#!/usr/bin/env python3

import subprocess
import sys
import json
import struct
import time
import numpy as np

BARS = int(sys.argv[1]) if len(sys.argv) > 1 else 10
SMOOTHING = 0.75
UPDATE_RATE = 0.05

# Bar characters from lowest to highest
BAR_CHARS = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]

def get_default_sink_monitor():
    """Get the monitor source for the default sink"""
    result = subprocess.run(
        ["pactl", "get-default-sink"],
        capture_output=True,
        text=True
    )
    return f"{result.stdout.strip()}.monitor"

def main():
    monitor = get_default_sink_monitor()
    
    # Start pw-record process
    cmd = [
        "pw-record",
        f"--target={monitor}",
        "--channels=1",
        "--rate=44100",
        "--format=s16",
        "-"
    ]
    
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL
    )
    
    # Previous bar values for smoothing
    prev_bars = np.zeros(BARS)
    
    # Buffer size: 44100 Hz, 2 bytes per sample, ~50ms
    chunk_size = int(44100 * 2 * UPDATE_RATE)
    
    try:
        while True:
            # Read audio chunk
            data = proc.stdout.read(chunk_size)
            if not data:
                time.sleep(UPDATE_RATE)
                continue
            
            # Convert bytes to int16 array
            samples = np.frombuffer(data, dtype=np.int16)
            
            # Split into bars
            samples_per_bar = len(samples) // BARS
            if samples_per_bar == 0:
                continue
            
            bars_text = ""
            for i in range(BARS):
                # Get chunk for this bar
                start = i * samples_per_bar
                end = start + samples_per_bar
                chunk = samples[start:end]
                
                # Calculate RMS (root mean square)
                rms = np.sqrt(np.mean(chunk.astype(np.float32) ** 2))
                
                # Normalize to 0-100 scale
                val = min(100, int(rms / 327.67))  # 32767 / 100
                
                # Apply smoothing
                prev_bars[i] = prev_bars[i] * SMOOTHING + val * (1 - SMOOTHING)
                
                # Map to bar character
                bar_idx = min(len(BAR_CHARS) - 1, int(prev_bars[i] / 100 * len(BAR_CHARS)))
                bars_text += BAR_CHARS[bar_idx]
            
            # Output JSON for waybar
            output = {
                "text": bars_text,
                "tooltip": "Audio Visualizer"
            }
            print(json.dumps(output), flush=True)
            
    except KeyboardInterrupt:
        pass
    finally:
        proc.terminate()
        proc.wait()

if __name__ == "__main__":
    main()
