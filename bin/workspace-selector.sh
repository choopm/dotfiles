#!/bin/bash
# This will prompt to select any available sway workspace
# using wofi and switch to or created selected workspace.

selection=$(swaymsg -t get_workspaces | \
  jq -M '.[] | .name' | \
  sort -n | \
  wofi -i --dmenu)
swaymsg workspace "$selection"
