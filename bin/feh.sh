#!/usr/bin/env bash
# This will wrap feh to scale down images
set -e

exec /usr/bin/feh  -g 1024x768 $@
