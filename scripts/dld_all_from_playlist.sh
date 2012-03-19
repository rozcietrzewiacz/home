#!/bin/bash
grep "^http:" $1 | sed 's/\?u=.*//g' | \
	while read strum
	do wget "$strum"
	#sleep 10
	done
