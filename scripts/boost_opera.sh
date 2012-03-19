#!/bin/bash

case $1 in
start )
	mount /home/janek/.opera/RAM
	mkdir -p /home/janek/.opera/RAM/{cache4/revocation,opcache}
	mkdir -p /tmp/janek-opera
	ln -s /tmp/janek-opera /home/janek/.opera/RAM/cache4/temporary_download
	mv /home/janek/.opera/cache4{,-PRESERVED}
	#Tu może dodać, żeby kopiowało zawartość, jeśli taka opcja z lini poleceń...
	ln -s /home/janek/.opera/{RAM/,}cache4
	mv /home/janek/.opera/opcache{,-PRESERVED}
	ln -s /home/janek/.opera/{RAM/,}opcache
;;
stop )
	unlink /home/janek/.opera/cache4
	unlink /home/janek/.opera/opcache
	umount /home/janek/.opera/RAM
	mv /home/janek/.opera/cache4{-PRESERVED,}
	mv /home/janek/.opera/opcache{-PRESERVED,}
;;
* )
	echo "Nieznane polecenie. Sposób użycia: 	$0 <start|stop>"
;;
esac
