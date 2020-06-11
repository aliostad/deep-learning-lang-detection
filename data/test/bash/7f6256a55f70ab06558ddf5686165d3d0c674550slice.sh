#!/bin/bash

if [  $1 -a  $1 == "--test" ]; then
    EXIT=0
    seq 10 > test.dat
    ./slice.sh 3 test.dat
    
    fileNum=`ls test.dat.* | wc -l`
    if [ $fileNum -ne 4 ]; then
	echo "Incorrect number of files made"
	EXIT=1
    else
	echo "Test 1: OK"
    fi

    fileNum=` wc -l test.dat.* `
    set -- $fileNum
    fileNum=$1
    if [ $fileNum -ne 3 ]; then
	echo "Incorrect number of lines in file"
	EXIT=1
    else
	echo "Test 2: OK"
    fi

    rm test.dat*

    exit $EXIT
fi


if [ $# -ne 2 ]; then
	echo "usage: slice.sh <slice-size> <filename>"
	echo "usage: slice.sh --test"
	exit 1
fi



sliceSize=$1
filename=$2

TOTAL=`wc -l $filename`
set -- $TOTAL
TOTAL=$1 

echo $TOTAL

START=1
CHUNK_NUM=1

while [ $START -le $TOTAL ]
do
    echo $START
    tail -n +$START $filename | head -n $sliceSize  > $filename.$CHUNK_NUM
    START=$((START + sliceSize))
    CHUNK_NUM=$((CHUNK_NUM +1))
done
