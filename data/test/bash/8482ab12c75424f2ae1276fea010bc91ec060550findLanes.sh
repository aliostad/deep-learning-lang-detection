#!/bin/bash

# usage: ./findLaneBams [-b]  [sample dir index]
# returns tab-delimtied sample-lane_id-lanebampath
# reads sample ids from stdin
# $Id: $

INDEX_SAMPLE_DIRS=~/share/scripts/indexSampleDirs.sh

if [ $1 == "-b" ]; then
    echo "Indexing..." >&2;
    sh ${INDEX_SAMPLE_DIRS} $1;
    shift;
fi

sample_dirs=$1
while read sample; do
    dir=`grep "$sample" $sample_dirs`;
    if [ "$dir" = "" ]; then
        echo "Unable to find sample: $sample" >&2;
        exit 1;
    fi

    bams=`find $dir -name *.bam -and ! -name "*dupsFlagged*" -and ! -name "*lanes*"`
    numbams=`echo $bams | wc -w`
    if [ $numbams -gt 1 ]; then
        #echo "Found multiple lanes for $sample: $bams" >&2;
        for bam in $bams; do
            lane=`echo $bam | sed 's/.*\///; s/\..*//'`;
            echo -e "$sample\t$lane\t$bam";
        done;
    else
        echo "ERROR: Unable to find bams for $sample in $dir" >&2;
        exit 1;
    fi
done
