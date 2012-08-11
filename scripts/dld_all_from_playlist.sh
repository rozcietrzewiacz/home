#!/bin/bash
if [[ -r "$1" ]] 
then
  LIST="$1"
  shift
fi
 

grep "^http:" "$LIST" | sed 's/\?u=.*//g' | \
	while read strum
	do wget "$strum" $@
	done
