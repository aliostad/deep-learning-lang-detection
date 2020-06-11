#!/bin/bash


:<<'COMMENT'

#sampleGroup.txt
sampleGroups=( A B C )
A=( A1 A2 A3 )
B=( B1 B2 )
C=( C1 C2 C3 C4)

COMMENT

if [ $# -lt 2 ]; then
	echo $0 "sampleGroupFile newTophatParent"
	exit
fi

sampleGroupFile=$1
newTophatParent=$2

newTophatParent=`abspath.py $newTophatParent`
newTophatDir=$newTophatParent/tophatOutput

mkdir.py $newTophatDir
source $sampleGroupFile


cd ..

cd tophatOutput

for sampleGroup in ${sampleGroups[@]}; do
	rm -Rf $newTophatDir/$sampleGroup
	mkdir.py $newTophatDir/$sampleGroup
	vname=${sampleGroup}
	
	retriever="echo \${$vname[@]}"
	sampleList=(`eval $retriever`)
	

	for sample in ${sampleList[@]};do
		echo $sample for $sampleGroup
		ln $sample/accepted_hits.bam $newTophatDir/$sampleGroup/$sample.tophat.bam.00
	done
	
	ori=`pwd`
	cd $newTophatDir/$sampleGroup/
	#now merge
	samtools merge accepted_hits.bam *.bam.00
	samtools sort accepted_hits.bam accepted_hits.sorted
	if [ -e accepted_hits.sorted.bam ]; then
		rm accepted_hits.bam
	fi
	samtools index accepted_hits.sorted.bam
	
	cd $ori
done

