#!/bin/sh

myPath="output"
myFile="output/Makefile"


if [ ! -d "$myPath" ]
then
   mkdir "$myPath"
fi

if [ ! -f "$myFile" ]
then
   touch "$myFile"
   echo "m:sample.o
\tg++ -g -o m sample.o -lecpg -lpgtypes -I/usr/include/python2.7  -lpython2.7

sample.o:sample.c
\tg++ -g -c -I /usr/include/postgresql/ sample.c -I/usr/include/python2.7 

sample.c:sample.pgc
\tecpg -I /usr/include/postgresql sample.pgc
 
clean:
\trm -rf m *.o sample.c" > "$myFile"
fi

#echo $1 $#
if [ "$#" -ne 0 ] && ! [ "$1" = "-f" ]; then
    ./m -i
else
    ./m -m
fi
