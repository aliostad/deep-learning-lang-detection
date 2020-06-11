#!/bin/bash
START=$(date +%s)
SAMPLE_NUM=100;
code=$1
active=$2
inactive=$3

echo '*****************************************'
echo '* Generate sample files for code' $code
echo '*****************************************'

for((sample=1;sample<=SAMPLE_NUM;sample++))
do
	echo '**Sample' $sample '- Disease Code' $code'**'
	
	#select samples for the active records
	./nis 2 output/active_$code $sample $active
	
	#select samples for the inactive records
	./nis 2 output/inactive_$code $sample $inactive
done

echo ''

END=$(date +%s)
DIFF=$(( $END - $START ))
echo 'Execution time' $DIFF 'seconds'

