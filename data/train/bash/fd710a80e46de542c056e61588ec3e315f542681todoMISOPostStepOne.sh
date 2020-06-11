#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source ${MISOSettingFile}

thisScriptDir=`pwd`

cd ..

rootDir=`pwd`


tophatOutputDir=$rootDir/$bamFileSubRoot
MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary

for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/${targetBamFileBaseName} ];  then
	continue
fi

cd $MISOSummaryDir/$sampleName/summary

#now processing here:

dissociateColValues.py --roll-over -i, -s2-5 ${sampleName}.miso_summary > ${sampleName}.miso_summary.dissociated.00
dequote.sh ${sampleName}.miso_summary.dissociated.00 > ${sampleName}.miso_summary.dissociated
joinu.py -1.isoforms -2.isoforms ${sampleName}.miso_summary.dissociated ${rawGffFile/.gff/}.exonStringMap > ${sampleName}.miso_summary.dissociated.2transcriptName

cd $rootDir

done
