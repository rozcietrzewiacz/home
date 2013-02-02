#!/bin/bash
# 
# Extract audio from videos on youtube-like services
# - uses media-video/get_flash_videos

TMPDIR=/tmp/getflash-$$
Q="${2:-medium}"

mkdir "$TMPDIR"
pushd "$TMPDIR"

FILE=$( tempfile -d . )
get_flash_videos -f $FILE -r "$Q" "$1"

echo "===== FILE: $FILE ======"
AUDEXT=`ffprobe "$FILE" 2>&1 | sed -n "s/.*Audio: \([a-z0-9]*\), .*/\1/p"`
echo "====== audio extension: $AUDEXT"

ffmpeg -i "$FILE" -loglevel quiet -acodec copy "${FILE%\.*}.$AUDEXT" 2>/dev/null

ls -l 
popd
