#!/bin/bash

# source common function script
scriptdir="$(dirname $(readlink -f $0))"
basedir="$scriptdir/../../"

source "$basedir/common.sh"


###### setup #######
wsdir="$(readlink -f ~/ws)"
refdir="${wsdir}/refseqs"

sample=$1


##### Check env ####

if [ ! -d align ]
then
	echo "No ./align/ directory"
	exit -1
fi

if [ -z "${sample}" ]
then
	echo "Must give sample"
fi

if [ ! -d "align/${sample}" ]
then
	echo "Error: sample '${sample}' does not exist"
	exit -1
fi

###### align #######
echo "Convert bams"
echo time bash ${basedir}/03-postalign/sort_index_bam.sh -i align/${sample} -o align/${sample} -a ""
time bash ${basedir}/03-postalign/sort_index_bam.sh -i align/${sample} -o align/${sample} -a ""
