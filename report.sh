#!/usr/bin/env bash

set -e

IMAGE_FILES=(./work/*.jpg)
EVALUATION_TEXT=$(cat ./work/gemma-evaluation.txt)
RESIZE_WIDTH=640
RESIZE_HEIGHT=480
ACTIVITY_LEVEL=$(echo "$EVALUATION_TEXT" | awk '{printf "%02d\n", $3}')

mkdir -p ~/Tmp/camcontdesc

OUTPUT_FILE="$HOME/Tmp/camcontdesc/$ACTIVITY_LEVEL-$(TZ='Europe/Berlin' date +%Y-%m-%d-%H%M)-combined.png"

magick \
  -background black -fill white -stroke black -strokewidth 0 \
  -font "DejaVu-Sans" -pointsize 24 \
  -size "${RESIZE_WIDTH}x" -gravity Center \
  caption:"$EVALUATION_TEXT" \
  \
  "${IMAGE_FILES[@]}" -resize "${RESIZE_WIDTH}x${RESIZE_HEIGHT}" \
  -append \
  "$OUTPUT_FILE"

echo $OUTPUT_FILE
