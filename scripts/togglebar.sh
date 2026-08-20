#!/bin/bash
if pgrep -x mangobar > /dev/null; then
    pkill -x mangobar
else
    mangobar &
fi
