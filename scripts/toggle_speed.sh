#!/bin/bash

if [ `acpitool -c | head -3 | tail -1 | cut -c 28` -gt 4 ]
then
	sudo /usr/bin/cpufreq-set -f 1200000
	echo -n "  Setting the CPU speed to 1.2 GHz..."
	sleep 1.2
	if [ `acpitool -c | head -3 | tail -1 | cut -c 28` -gt 4 ]
	then echo " FAILED! Sorry."
	 else echo " Done."
	fi
else
	sudo /usr/bin/cpufreq-set -f 800 MHz
	echo -n "  Setting the CPU speed to 800 MHz..."
	sleep 2
	if [ `acpitool -c | head -3 | tail -1 | cut -c 28` -lt 4 ]
	then echo " FAILED! Sorry."
	 else echo " Done."
	fi
fi

sleep 0.6
exit 0
