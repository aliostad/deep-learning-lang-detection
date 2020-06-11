#!/bin/bash

# chunkify-drive-upload v1
# Using drive this is as cript to chunkify your file say you might get an upload
# cut out after 20 MBs are uploaded yet the entire file is 30MB, this ensures
# that later on you can rejoin your files on your own accord.

if [[ $# -lt 1 ]]
then
    echo "$0 <path> [nominal-chunksize-in-mb]"
    exit
fi

function splitter {
    path="$1";
    chunkSize=20
    if [[ $2 -gt 0 ]]
    then
        let chunkSize=$2
    fi

    size=$(ls -l $path | cut -d" " -f5);
    chunkSize=$(expr $chunkSize \* 1024 \* 1024)
    chunkCount=$(expr 1 + $size \/ $chunkSize)
    echo "$path $chunkSize $chunkCount";
}

function  chunkify {
   path=$1;
   chunkSize=$2;
   chunkCount=$3;

   base=$(basename $path)

   for ((i=0; i < $chunkCount; i++))
   do
       outpath="$base-$i"
       dd if=$path bs=$chunkSize count=1 skip=$i | drive push --piped $outpath
   done
}

chunkify $(splitter $@)
