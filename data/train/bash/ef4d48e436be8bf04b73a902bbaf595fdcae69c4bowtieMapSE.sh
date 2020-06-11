#!/bin/bash

source fileUtils.sh
source ./initvars.sh
source $tophatshvar


if [ ! -e $bowtieOutputDir ];then
	mkdir $bowtieOutputDir
fi

saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)
IFS=$saveIFS


for sample in ${samples[*]}; do
	echo "initiate bowtie for sample $sample"
	vname=${sample}
	lfilelist=${!vname}


	echo left file list $lfilelist

	
	mkdir $bowtieOutputDir/${sample}
	bsubcommand="bsub $scriptDir/bowtieMapJobArgListSE.sh ${sample} $lfilelist $scriptDir"
	echo $bsubcommand
	eval $bsubcommand

done


