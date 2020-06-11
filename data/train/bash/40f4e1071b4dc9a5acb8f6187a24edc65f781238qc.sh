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

if [ ! -d reads ]
then
	echo "No ./reads/ directory"
	exit -1
fi

if [ -z "${sample}" ]
then
	echo "Must give sample"
fi

if [ ! -d "reads/${sample}" ]
then
	echo "Error: sample '${sample}' does not exist"
	exit -1
fi

######## QC ########
echo "Initial FastQC"
mkdir -p qc/before/${sample}
echo time bash ${basedir}/01-qc/fastqc.sh -i reads/${sample} -o qc/before/${sample} -a ""
time bash ${basedir}/01-qc/fastqc.sh -i reads/${sample} -o qc/before/${sample} -a ""
