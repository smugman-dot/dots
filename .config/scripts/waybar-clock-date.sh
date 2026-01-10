#!/bin/bash

while true; do
  DATE=$(date +"%a, %b %d")
  echo "{\"text\": \"$(date +'%H:%M')\", \"class\": \"clock\", \"alt\": \"\", \"tooltip\": false, \"data-date\": \"$DATE\"}"
  sleep 1
done

