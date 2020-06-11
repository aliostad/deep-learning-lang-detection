#!/bin/bash

usage()
{
    echo "Usage $0"
    exit 2
}


pluginsdir="${0%/*}/aux"
source $pluginsdir/config_loader.sh
load ${0##*/}

## two decimal floating oint value
loadlimit=${loadlimit:=15.00}

error=0
error_msg="LOAD ERROR: \n\t"

load="$( cat /proc/loadavg | awk '{ print $2 }' )"
if [ ${load/.} -ge ${loadlimit/.} ]
then
    error=1
    error_msg+="Load avg at $load (limit: $loadlimit)\n\t"
fi

if [ $error -eq 1 ]
then
    echo -e "$error_msg"
    exit 2
else
    echo -e "LOAD OK: \n\tLoad average at $load (limit: $loadlimit)."
fi




