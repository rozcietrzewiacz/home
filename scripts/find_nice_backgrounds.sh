#!/bin/bash
#
# Searches for graphics files that meet specific criteria. Makes use of unix
# pipes' capabilities to parallelise the analysis.
#
# Created by /rozcietrzewiacz/ to ease and automate finding nice, dark graphics
# for desktop backgrounds :)
#
# Arguments: list of directories to search

MaxMean=20      # Maximum mean value (~brightness)
MaxStDev=30     # Maximum standard deviation of brightness value
MaxSize="2M"    # Max file size
MinSize="35k"   # Min file size

CzasPocz=`date "+%s"`
L=0
TMPF=/tmp/pics_$$
TMPDIR=/tmp/pics_dir_$$

echo -e "Legend:
	[C] - number of CANDIDATES found (based on size)
	[A] - number of ANALYSED graphics
	[F] - number of files that were FOUND to meet the criteria
	* * - indicates that a given searching phase is finished

Progress:
 [F]\t [A]\t [C]"

find $@ -type f -size "+${MinSize}" -size "-${MaxSize}" -name "*.jpg" -o -name "*.jpeg" -o -name "*.JPG" -o -name "*.png" 2>/dev/null \
| ( 
  while read -r file; do
        echo -en "\r  \t  \t $((L++))\r" 1>&2
        echo $file
    done 
    	echo -en "\r  \t  \t*${L}*\r" 1>&2 
) | ( 
  while read -r file; do
        echo -en "\r \t $((L++))\r" 1>&2
	SecStart=`date "+%s.%N"`
        OVERALL="`identify -verbose \"$file\" 2>/dev/null | grep -A6 Overall`"
        NUM_mean=`echo $OVERALL | grep -o "mean: [0-9.-]*"`
        NUM_mean=${NUM_mean##*: }
        NUM_mean=${NUM_mean%%\.*}
        NUM_sd=`echo $OVERALL | grep -o "deviation: [0-9.-]*"`
        NUM_sd=${NUM_sd##*: }
        NUM_sd=${NUM_sd%%\.*}
	SecEnd=`date "+%s.%N"`
	Elap=`echo $SecEnd - $SecStart | bc -l | cut -c 1-4`
        [[ "x$NUM_mean" != "x" ]] && [[ $NUM_mean -lt $MaxMean ]] && [[ $NUM_sd -lt $MaxStDev ]] \
	&& echo -e "$NUM_mean \tsd: $NUM_sd \t$Elap  ${file}" \
	&& echo `realpath "$file"` $NUM_mean $NUM_sd >> $TMPF
    done
    echo -e "\r \t*${L}*\n--------------------------\nPotential background images:" 1>&2 
) | (
  while read -r hahaha; do
  	echo -en "\r  $((L++))\r" >&2
	echo "$hahaha"
  done 
  echo "====== Total number of images found: *${L}* =======" >&2
) | sort -g

echo
echo -e " DONE!\n Finished in $[ `date "+%s"` - CzasPocz ] seconds."

[[ -f ${TMPF} ]] || exit 1

echo "File list saved in ${TMPF} ."
mkdir "${TMPDIR}"
cat $TMPF | while read file mn sd
do
	ln -s "$file" "${TMPDIR}/${mn}-${sd}__${file//\//_}" 2>/dev/null
done
echo
echo  "Symlinks to all the found graphic files can be found under \"${TMPDIR}\""

echo "Run \"mirage ${TMPDIR}\" now? (y/n)"
read re
[[ "$re" == "y" ]] && mirage "${TMPDIR}" & 

