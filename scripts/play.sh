#!/bin/bash
if	[ "$(playerctl status)" = "Playing" ]; then
	title=`exec playerctl metadata xesam:title`
	artist=`exec playerctl metadata xesam:artist`
  ( echo %{A1:playerctl previous:}󰒮%{A} "$title-$artist" %{A1:playerctl pause:}%{A} %{A1:playerctl next:}󰒭%{A}) &

elif	[ "$(playerctl status)" = "Paused" ]; then
	title=`exec playerctl metadata xesam:title`
	artist=`exec playerctl metadata xesam:artist`
	( echo %{A1:playerctl previous:}󰒮%{A} "$title-$artist" %{A1:playerctl play:}▶️%{A} %{A1:playerctl next:}󰒭%{A}) &
else
	echo "No media"
fi
