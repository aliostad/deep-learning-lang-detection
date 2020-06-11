#!/bin/bash
#Set -x is an option, it tells the script to echo back each command once it has been completed. 
set -x
set -e

#Sample $1 looks for the first ____ in the reads directory
sample=$1

#Names the directory that the sample will be opened from
sample_dir="reads/$sample"

#If there are no samples directories in the reads folder, tell me
if [ ! -d "$sample_dir" ]
then
echo "my bad"
exit
fi

pushd "$sample_dir"
    fwd_reads=*R1*.fastq.gz
    gunzip -c $fwd_reads>${sample}_R1.fastq
    rm *.fastq.gz
    gzip *.fastq
popd 

