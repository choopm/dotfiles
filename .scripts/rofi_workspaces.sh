#!/bin/bash

if [ -z "$@" ]; then
  echo "$(swaymsg -t get_workspaces | jq -M '.[] | .name' | sort -n)"
else
  if [ -n "$@" ]; then
    swaymsg workspace "$@" >/dev/null
  fi
fi
