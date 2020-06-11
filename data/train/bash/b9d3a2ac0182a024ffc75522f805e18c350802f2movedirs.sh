#!/bin/bash
# moves files into n number of subdirs in y number of chunks.
SRC_DIR="/source/path/to/move/from"
TARGET_DIR_CHUNK="targetdirname"
FILES_PER_CHUNK=50
COUNTFILES=$(ls -1 $SRC_DIR | wc -l)
DIR_ITER=1
NUM_DIRS=$(( $COUNTFILES / $FILES_PER_CHUNK ))
clear
echo $COUNTFILES "files in this directory."
echo "moving files in" $FILES_PER_CHUNK "files per chunk to subdirectories starting with" $TARGET_DIR_CHUNK"."
echo "number of created directories:" $NUM_DIRS
while [ $DIR_ITER -le $NUM_DIRS ]
	do
		mkdir $SRC_DIR"/"$TARGET_DIR_CHUNK$DIR_ITER
		for file in $(ls -p $SRC_DIR | grep -v / | tail -$FILES_PER_CHUNK)
		do
			mv $SRC_DIR"/"$file $SRC_DIR"/"$TARGET_DIR_CHUNK$DIR_ITER"/"
		done
		DIR_ITER=$(( $DIR_ITER + 1 ))
	done
	#moving leftover less than files_per_chunk num of files to last dir...
	mkdir $SRC_DIR"/"$TARGET_DIR_CHUNK$(( $DIR_ITER + 1 ))
	mv $SRC_DIR"/*.*" $SRC_DIR"/"$TARGET_DIR_CHUNK$(( $DIR_ITER + 1 ))"/"
	echo "finished moving"
exit 0
