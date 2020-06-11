#!/bin/bash
#
# Author: Ed Hills
# Date 9/12/12
#
# Filter by sampleId. Will separate the Sample specific data from
# input VCF and put them into a new VCF
#
# $1..($#-1) = sample ids
# $($#) = output file
# $($#) = output file

SAMPLE_LIST=""
NUM_SAMPLES=$#
NUM_SAMPLES=$((NUM_SAMPLES - 2))

for ((i=1; i<=NUM_SAMPLES; i++))
do
    INPUT=$1
    SAMPLE_LIST="${SAMPLE_LIST}$INPUT,"
    shift 
done

INPUT_FILENAME=$1
shift
OUTPUT_FILENAME=$1
bgzip -c $INPUT_FILENAME > INPUT.gz
tabix -p vcf INPUT.gz

vcf-subset -c $SAMPLE_LIST INPUT.gz > $OUTPUT_FILENAME

exit 0
