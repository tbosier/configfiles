#!/bin/sh
xrandr --output Virtual-2 --mode 1920x1080 --primary --output Virtual-1 --mode 1920x1080 --right-of Virtual-2
nitrogen --restore &
sleep 1  # Add a short delay
picom --config ~/.config/picom/picom.conf &
