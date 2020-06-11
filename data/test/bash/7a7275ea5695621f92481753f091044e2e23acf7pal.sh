#!/bin/bash

# A pal frontend to mimic the required functionality.
# ./pal.sh [ OPTIONS ] filename.pal

LEAVECODE=0
INVOKE=1
OPTIONS=""

while getopts "canS" OPTION
do
     case $OPTION in
         S)
             LEAVECODE=1
             ;;
         n)
             OPTIONS=$OPTIONS" -n"
             ;;
         a)
             OPTIONS=$OPTIONS
             ;;
         c)
             INVOKE=0
             ;;
         ?)
             ./pal
             exit
             ;;
     esac
done

for last; do true; done
filename=$last
filename=`basename $filename .pal`

# Invoke the compiler
./pal -S $OPTIONS $filename.pal

if [ $INVOKE == 1 ]
then
    ~c415/bin/asc $filename.asc
fi

if [ $LEAVECODE == 0 ]
then
    rm -f $filename.asc
fi
