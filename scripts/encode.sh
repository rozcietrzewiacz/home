#!/bin/bash

function do_mp3 ()
{
	NR=1
	b="0"
	while read tytul
	do
		lame --preset standard \
		 --ta "$1" --tl "$2" \
		 --tt "${tytul}" trac*[^1-9]${NR}.cdda.wav \
		"${b}${NR}-${tytul}.mp3"
		NR=$(($NR+1))
		if [[ $NR > 9 ]]; then b=""; fi
	done
}

function usage ()
{
	cat << EOF
	Użycie: $0 <wykonawca> <album> [ścieżka]

	Zgrywa płytę CD na mp3 za pomocą libcdio-paranoia. Tytuły kolejnych utworów sczytuje ze standardowego wejścia linia po linii. AUTOMATYCZNIE TWORZY STRUKTURĘ KATALOGÓW <wykonawca>/<album>.
	
	Parametry:
	<wykonawca>,<album>	- tajemnicze zaklęcia
	ścieżka			- ścieżka na dysku, gdzie mają być zapisane pliki - domyślnie: katalog bieżący
EOF
}

####################
####### MAIN #######
if [[ $# < 2 ]]; then usage; exit 1; fi
if [[ $# > 2 ]]; then cd "$3"; fi
mkdir -p "$1"; cd "$1"
mkdir -p "$2"; cd "$2"

libcdio-paranoia -B && do_mp3 "$1" "$2"
#do_mp3 "$1" "$2"
