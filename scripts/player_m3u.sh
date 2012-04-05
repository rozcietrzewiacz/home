#!/bin/bash
#
# A wrapper player-script for jamendo playlists
#

TMPF="$( mktemp --tmpdir jam_XXXXXX.m3u )"

#exec >${TMPF}-log 2>&1

wget "$1" -O $TMPF >${TMPF}-log 2>&1 && rm "${TMPF}-log"
#vlc --one-instance --playlist-enqueue $TMPF.m3u 
audacious -e  $TMPF &

#rm $TMPF
