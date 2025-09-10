#!/usr/bin/env bash

set -e

IMAGE_FILES=(./work/*.jpg)
EVALUATION_TEXT=$(cat ./work/gemma-evaluation.txt)
RESIZE_WIDTH=640
RESIZE_HEIGHT=480
ACTIVITY_LEVEL=$(echo "$EVALUATION_TEXT" | awk '{printf "%02d\n", $3}')

WORKDIR=~/Tmp/camcontest/$(TZ='Europe/Berlin' date +%Y-%m-%d-%H%M)-$ACTIVITY_LEVEL

mkdir -p $WORKDIR

cp ./work/*.jpg $WORKDIR/
cp ./work/gemma-evaluation.txt $WORKDIR/

OUTPUT_FILE="$WORKDIR/$(TZ='Europe/Berlin' date +%Y-%m-%d-%H%M)-level-$ACTIVITY_LEVEL.png"

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
