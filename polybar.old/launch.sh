#!/usr/bin/env bash
 
# Terminate already running bar instances
killall polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit
 
# Launch bar1 and bar2
polybar
 
echo "Bars launched..."

