#!/bin/sh
xrandr --output HDMI-0 --primary --auto --output DP-5 --auto --right-of HDMI-0
nitrogen --restore &
sleep 1  # Add a short delay
picom --config ~/.config/picom/picom.conf &

# Clipboard manager. Holds ownership of the clipboard so copied data survives
# the process that copied it -- the whole reason screenshots pasted only
# sometimes. Guarded so this script still works if copyq is not installed.
command -v copyq >/dev/null 2>&1 && copyq --start-server &
