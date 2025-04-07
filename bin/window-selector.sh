#!/bin/sh
# https://github.com/argosatcore/Deb_Dots/blob/effc7984152f38c452d098c7f368cec84c41e455/.local/bin/window_selector.sh

# ------Get available windows:
windows=$(swaymsg -t get_tree | jq -r '
	recurse(.nodes[]?) |
		recurse(.floating_nodes[]?) |
		select(.type=="con"), select(.type=="floating_con") |
			(.id | tostring) + " " + .app_id + ": " + .name')

# ------Limit wofi's height with the number of opened windows:
height=$(echo "$windows" | wc -l)

# ------Select window with wofi:
selected=$(echo "$windows" | wofi -d -i --lines "$height" -p "Switch to:" | awk '{print $1}')

# ------Tell sway to focus said window:
swaymsg [con_id="$selected"] focus
