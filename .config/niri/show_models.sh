#!/bin/bash

# URL of the llama-server API
API_URL="http://127.0.0.1:8080/models"

# Fetch models from llama-server
response=$(curl -s "$API_URL")

if [ $? -ne 0 ] || [ -z "$response" ]; then
    notify-send "Llama Server" "Could not connect to llama-server at $API_URL"
    exit 1
fi

# Use jq to extract the IDs of loaded models
models=$(echo "$response" | jq -r '.data[] | select(.status.value == "loaded") | .id' 2>/dev/null)

if [ -z "$models" ]; then
    notify-send "Llama Server" "No models currently loaded"
    exit 0
fi
# Use fuzzel to select a model
selection=$(echo "$models" | fuzzel --dmenu)

if [ $? -eq 0 ] && [ -n "$selection" ]; then
    # Unload the selected model
    unload_response=$(curl -s -X POST "http://127.0.0.1:8080/models/unload" \
     -H "Content-Type: application/json" \
     -d "{\"model\": \"$selection\"}"
    )
    
    if [ $? -eq 0 ]; then
        notify-send "Llama Server" "Unloaded model: $selection"
    else
        notify-send "Llama Server" "Failed to unload model: $selection"
    fi
fi
