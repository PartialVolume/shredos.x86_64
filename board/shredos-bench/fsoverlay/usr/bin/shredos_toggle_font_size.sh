#!/bin/bash
device=$(tty)
if [ ! -e "/usr/bin/.shredos_toggle_font_flag" ]; then
	setfont -d -C $device
	touch "/usr/bin/.shredos_toggle_font_flag"
else
	setfont -C $device
	rm "/usr/bin/.shredos_toggle_font_flag"
fi

