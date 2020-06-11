#!/bin/bash


:<<'COMMENT'

#sampleGroup.txt
sampleGroups=( A B C )
A=( A1 A2 A3 )
B=( B1 B2 )
C=( C1 C2 C3 C4)

COMMENT

if [ $# -lt 3 ]; then
	echo $0 "sampleGroupFile newBwaParent Qthreshold"
	exit
fi

sampleGroupFile=$1
newBwaParent=$2
Qthreshold=$3
scriptDir=`pwd`

newBwaParent=`abspath.py $newBwaParent`
newBwaSamseDir=$newBwaParent/samse
newTophatLogDir=$newBwaParent/log
newTophatLog=$newBwaParent/log/tophat.shvar
mkdir.py $newBwaSamseDir

source $sampleGroupFile
mkdir.py $newTophatLogDir


sampleString=`echo ${sampleGroups[@]} | tr " " ","`

echo "Samples=$sampleString" > $newTophatLog



cd ..

cd samse

for sampleGroup in ${sampleGroups[@]}; do
	rm -Rf $newBwaSamseDir/$sampleGroup
	mkdir.py $newBwaSamseDir/$sampleGroup/processed_Q${Qthreshold}/sorted
	
	
	vname=${sampleGroup}
	
	retriever="echo \${$vname[@]}"
	sampleList=(`eval $retriever`)
	

	for sample in ${sampleList[@]};do
		echo $sample for $sampleGroup
		
		for stdoutFile in $sample/processed_Q${Qthreshold}/*.part.stdout; do
			if [ ! -e $newBwaSamseDir/$sampleGroup/processed_Q${Qthreshold}/combined.part.stdout ]; then
				cp $stdoutFile $newBwaSamseDir/$sampleGroup/processed_Q${Qthreshold}/combined.part.stdout
			else
				python $scriptDir/addBashVar.py $newBwaSamseDir/$sampleGroup/processed_Q${Qthreshold}/combined.part.stdout $stdoutFile $newBwaSamseDir/$sampleGroup/processed_Q${Qthreshold}/combined.part.stdout
			fi	
		done
		
		for srcFile in $sample/processed_Q${Qthreshold}/sorted/*.SAM.s; do
			bnSrcFile=`basename $srcFile`
			ln $srcFile $newBwaSamseDir/$sampleGroup//processed_Q${Qthreshold}/sorted/$sample.$bnSrcFile
		done
	done

done

