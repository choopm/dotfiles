#!/usr/bin/env bash
#
# Requires: imagemagick, swaymsg, jq
#
# This spans the image passed in argument 1 across all monitors.
# It does so by scaling it temporarily and extracting the regions
# required for any monitor. Those are saved next to the input file.
# It also creates symlinks named after each monitor in ~/.wallpapers.
# It is especially useful when using multiple monitors.
#
set -eo pipefail

if [ -z "$1" ]; then
  echo "usage: $0 <image> [offset x] [offset y]"
  exit 1
fi

SYMDIR=~/.wallpapers

# fetch monitor config array
# (encode lines using base64 to parse it as shell array)
readarray -t monitors < <(swaymsg -t get_outputs | \
  jq --compact-output --raw-output '.[] | .rect += {name:.name} | .rect | @base64')

# calculate max canvas size
echo "monitors:"
cw=0
ch=0
for mon in "${monitors[@]}"; do
  s=$(echo $mon | base64 -d | jq --raw-output '.name')
  x=$(echo $mon | base64 -d | jq --raw-output '.x')
  y=$(echo $mon | base64 -d | jq --raw-output '.y')
  w=$(echo $mon | base64 -d | jq --raw-output '.width')
  h=$(echo $mon | base64 -d | jq --raw-output '.height')
  echo "  $s res ${w}x${h} pos ${x}x${y}"

  if (( x+w > cw )); then
    cw=$((cw+x+w))
  fi
  if (( y+h > ch )); then
    ch=$((ch+y+h))
  fi
done

# apply offset zoom if any
zx=0
zy=0
if ! [[ -z "$2" && -z "$3" ]]; then
  zx=$2
  zy=$3
  echo "using offset zoom ${zx}x${zy}"
fi
cw=$((cw+zx*2))
cy=$((cy+zy*2))

# determine filename
dir=$(dirname $1)
fbname=$(basename "$1" | cut -d. -f1)
ext=$(basename "$1" | cut -d. -f2)
outbase="${dir}/${fbname}"

# temp working dir
tmp=$(mktemp -d)
scaled="${tmp}/scaled.${ext}"

echo "scaling $(basename $1) temporarily to fit canvas: $cw x $ch"
if (( cw > ch )); then
  magick $1 -resize ${cw}x ${scaled}
else
  magick $1 -resize x${ch} ${scaled}
fi

echo "extracting regions into $dir"
for mon in "${monitors[@]}"; do
  s=$(echo $mon | base64 -d | jq --raw-output '.name')
  x=$(echo $mon | base64 -d | jq --raw-output '.x')
  y=$(echo $mon | base64 -d | jq --raw-output '.y')
  w=$(echo $mon | base64 -d | jq --raw-output '.width')
  h=$(echo $mon | base64 -d | jq --raw-output '.height')

  magick -extract ${w}x${h}+$((x+zx))+$((y+zy)) ${scaled} ${outbase}-${s}.${ext}
  echo "  region ${w}x${h}+$((x+zx))+$((y+zy)) saved to: ${fbname}-${s}.${ext}"
done

# remove temporary files
rm -rf ${tmp}

echo "creating symlinks in $SYMDIR"
mkdir -p ${SYMDIR}
for mon in "${monitors[@]}"; do
  s=$(echo $mon | base64 -d | jq --raw-output '.name')
  ln -sf $(realpath ${outbase}-${s}.${ext}) ${SYMDIR}/$s
done

echo "refreshing wallpapers"
for mon in "${monitors[@]}"; do
  s=$(echo $mon | base64 -d | jq --raw-output '.name')
  swaymsg output $s bg ${SYMDIR}/$s fit
done
