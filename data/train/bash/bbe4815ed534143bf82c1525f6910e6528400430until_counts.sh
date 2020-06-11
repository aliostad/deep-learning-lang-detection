#!/bin/bash

# source common function script
scriptdir="$(dirname $(readlink -f $0))"
basedir="$scriptdir/../../"

source "$basedir/common.sh"


###### setup #######
wsdir="/home/kevin/ws"
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

echo "Initial FastQC"
mkdir -p qcd/${sample}
echo time bash ${basedir}/01-qc/unzip.sh -i reads/${sample} -o qcd/${sample}
time bash ${basedir}/01-qc/unzip.sh -i reads/${sample} -o qcd/${sample}

###### align #######
echo "Align with subread"
mkdir -p align/${sample}
echo time bash ${basedir}/02-align/subread.sh -i qcd/${sample} -o reads/${sample} -a "-i ${refdir}/TAIR10_gen/TAIR10_gen"
time bash ${basedir}/02-align/subread.sh -i qcd/${sample} -o reads/${sample} -a "-i ${refdir}/TAIR10_gen/TAIR10_gen"

###### count #######
echo "Count with featurecounts"
mkdir -p count/${sample}
echo time bash ${basedir}/04-initialstats/featurecounts.sh -i align/${sample} -o count/${sample} -a "-F SAF -b -a ${refdir}/TAIR10_gen/TAIR10_GFF3_genes_transposons.tab -p -C"
time bash ${basedir}/04-initialstats/featurecounts.sh -i align/${sample} -o count/${sample} -a "-F SAF -b -a ${refdir}/TAIR10_gen/TAIR10_GFF3_genes_transposons.tab -p -C"
