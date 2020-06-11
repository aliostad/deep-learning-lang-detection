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

echo "Run seqtk"
qcstep="trimfq"
mkdir -p qcd/${qcstep}/${sample}/
echo time bash ${basedir}/01-qc/seqtk_trimfq.sh -i qcd/scythe/${sample} -o qcd/${qcstep}/${sample} -a ""
time bash ${basedir}/01-qc/seqtk_trimfq.sh -i qcd/scythe/${sample} -o qcd/${qcstep}/${sample} -a ""

# enter any additional qc here

pushd qcd > /dev/null
ln -s $(readlink -f ${qcstep}/${sample}) ${sample}
popd >/dev/null

###### align #######
echo "Align with subread"
mkdir -p align/${sample}
echo time bash ${basedir}/02-align/subread_nosortidx.sh -i qcd/${sample} -o align/${sample} -a "-T 4 -i ${refdir}/TAIR10_gen/TAIR10_gen_chrc"
time bash ${basedir}/02-align/subread_nosortidx.sh -i qcd/${sample} -o align/${sample} -a "-T 4 -i ${refdir}/TAIR10_gen/TAIR10_gen_chrc"

###### count #######
echo "Count with featurecounts"
mkdir -p count/${sample}
echo time bash ${basedir}/04-initialstats/featurecounts.sh -i align/${sample} -o count/${sample} -a "-T 4 -F SAF -b -a ${refdir}/TAIR10_gen/TAIR10_GFF3_genes.saf -p -C"
time bash ${basedir}/04-initialstats/featurecounts.sh -i align/${sample} -o count/${sample} -a "-T 4 -F SAF -b -a ${refdir}/TAIR10_gen/TAIR10_GFF3_genes.saf -p -C"
