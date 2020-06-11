#!/bin/sh

TIME_COURSE_DIR=glycerol_time_course
echo "TIME_COURSE_DIR: $TIME_COURSE_DIR"
reads=($SCRATCH/data/${TIME_COURSE_DIR}/unanalyzed_raw_reads/MURI_*.fastq.gz)

for ((i=0;i<${#reads[@]};i++)); do
	echo $i
	read_file=${reads[$i]}
	SAMPLE_NUM=`echo $read_file | grep -o "MURI_[0-9]\+" | grep -o "[0-9]\+"`  
	
	echo "SAMPLE_NUM: $SAMPLE_NUM"
	echo "read_file: $read_file"
	
	if [[ $read_file == *ND* ]]; then
		echo "ND"
		echo "mkdir $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/non_depleted.raw/"
		echo "mv $read_file $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/non_depleted.raw/"
		if [ ! -d $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/non_depleted.raw ]; then
			mkdir $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/non_depleted.raw/
		fi
		mv $read_file $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/non_depleted.raw/
	else
		echo "mkdir $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/depleted.raw/"
		echo "mv $read_file $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/depleted.raw/"
		if [ ! -d  $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/depleted.raw/ ]; then
			mkdir  $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/depleted.raw/
		fi
		mv $read_file $SCRATCH/data/${TIME_COURSE_DIR}/sample${SAMPLE_NUM}/RNA/depleted.raw/
	fi	
	
done

