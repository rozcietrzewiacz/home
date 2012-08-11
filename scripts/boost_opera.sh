#!/bin/bash

case $1 in
start )
	mount $HOME/.opera/RAM
	mkdir -p $HOME/.opera/RAM/{cache4/revocation,opcache}
	mkdir -p /tmp/$$-opera
	ln -s /tmp/janek-opera $HOME/.opera/RAM/cache4/temporary_download
	mv $HOME/.opera/cache4{,-PRESERVED}
	#XXX Could add a command to copy the contents if requested by an cmdline argument...
	ln -s $HOME/.opera/{RAM/,}cache4
	mv $HOME/.opera/opcache{,-PRESERVED}
	ln -s $HOME/.opera/{RAM/,}opcache
;;
stop )
	unlink $HOME/.opera/cache4
	unlink $HOME/.opera/opcache
	umount $HOME/.opera/RAM
	mv $HOME/.opera/cache4{-PRESERVED,}
	mv $HOME/.opera/opcache{-PRESERVED,}
;;
* )
	echo "Unknown command. Usage: 	$0 <start|stop>"
;;
esac
