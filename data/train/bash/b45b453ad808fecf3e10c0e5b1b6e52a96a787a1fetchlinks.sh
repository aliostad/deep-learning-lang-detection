#!/bin/bash
SITE=$1

if [ ! -d './links' ]
then
    mkdir './links'
fi

if [ -f './links/'$SITE ]
then
    echo 'dupa'
    rm './links/'$SITE
    touch './links/'$SITE
fi

for chunk in `seq 0 9`
do
    START=$(($chunk*100))
    lynx -dump 'http://www.google.pl/search?q=site:'$SITE'+filetype:doc&num=100&start='$START | \
         grep -no 'url?q=http://.*' | \
         sed -r 's/&.*//' | \
         sed -r 's/^[0-9]+://' | \
         sed -r 's/^url\?q=//' >> './links/'$SITE
done

if [ -f './links/total' ]
then
    rm './links/total'
fi

cat ./links/*.* >> './links/total'
