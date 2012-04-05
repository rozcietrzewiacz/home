#!/bin/bash

usage ()
{
	cat << EOF
$0 - zkrypt do masowego zmniejszania rozmiarów plików jpeg
	Użycie: $0 <ścieżka_pierwotna> <ścieżka_docelowa> [skala]

Skrypt zmniejsza po kolei wszystkie pliki jpeg z katalogu ścieżka_pierwotna i umieszcza pomniejszone wersje w katalogu ścieżka_docelowa, nie zmieniając nazw plików. 
Opcjonalny parametr skala daje możliwość określenia skali, w jakiej mają być zapisane pliki (z przedziału (0,1>). Gdy parametr ten zostanie pominięty, przyjęta zostaje wartość 0.5 (dwukrotne zmniejszenie obu wymiarów).
EOF
}

zmniejsz () 
{
	for plk in ${1}/*.[jJ][Pp]*[Gg]; do
		echo -e "--> \033[32m$plk\033[0m"
		jpegtopnm "$plk" 2>/dev/null |pamscale $3 | \
		pnmtojpeg > "${2}/${plk##*/}"
	
	done
}

##################
###### MAIN ######

if [[ $# < 2 ]]; then
	usage
	exit 1
elif [[ $# == 2 ]]; then 
	zmniejsz $1 $2 0.5
else
	zmniejsz $1 $2 $3
fi

