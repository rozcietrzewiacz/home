#!/bin/bash

TMPDIR=/tmp/getflash-$$
Q="${2:-medium}"

mkdir "$TMPDIR"
pushd "$TMPDIR"

get_flash_videos -r "$Q" "$1"

FILE="`ls`"
echo "===== PLIK: $FILE ======"
AUDEXT=`ffprobe "$FILE" 2>&1 | sed -n "s/.*Audio: \([a-z0-9]*\), .*/\1/p"`
echo "====== ROZSZerzenie AUDIO: $AUDEXT"

ffmpeg -i "$FILE" -loglevel quiet -acodec copy "${FILE%\.*}.$AUDEXT" 2>/dev/null

ls -l 
popd
