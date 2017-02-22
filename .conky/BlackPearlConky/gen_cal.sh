#!/bin/bash

me=$(realpath $0)
my_path=${me%/*}
DOM=$(date +%e)
cal |\
    sed -r 's/^(.{17})/\1${color2}/' |\
    sed -e '1d' \
        -e s/^/'${offset 170}${color3}'/ \
        -e /" $DOM "/s/" $DOM "/" "'${color 3273b5}'"$DOM"'${color3}'" "/ \
> $my_path/var/cal_today
