#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

file=$2

cp $file ${file}.backup

# the utility "split" can only split in chunks of equal size

case "$file" in
# For 20120710142012
*right14.20*)
	chunk=( 100 200 300 )
	;;
# For 20120710142207
*left14.22*)
	chunk=( 90 175 255 345 450 )
	;;
# For 20120710142707
*straight14.27*)
	chunk=( 90 180 245 315 400 480 510 ) 
	;;
*straight14.14*)
	chunk=( 75 150 245 320 410 490 590 690 790 ) 
	;;
esac

#echo $chunk

mult_factor=39

prev_line=1
i=0
for c in "${chunk[@]}"; do
	i=$(( $i + 1 ))
	line=$(( $c * $mult_factor ))
	size=$(( $line - $prev_line ))
	echo $line
	split_file=$file.$i.split.log
	head -n ${line} $file | tail -n "-${size}" > $split_file
	prev_line=$line

	# tac result for odd parts
	odd=$(( $i % 2 ))
	if [ $odd -eq 0 ]; then 
		echo "Reverse this last file"
		sed -i '1!G;h;$!d' $split_file
	fi
done

rm ${file}.backup
