#!/bin/bash

set -e

ARGS=4
if [ $# -ne $ARGS ]
then
	echo Usage: `basename $0` \<STAR excutable\> \<genome reference\> \<FASTQ\> \<output Dir\>
	exit
fi

STAR=$1
genome=$2
fastq=$3
outputDir=$4

sample=`basename $fastq | sed 's/.fastq.gz//'`

cd $outputDir

if [ ! -f $outputDir/$sample.Log.final.out ]
then

	$STAR --genomeDir $genome --readFilesIn $fastq --readFilesCommand zcat --runThreadN 1 --clip3pAdapterSeq CTGTAGGCAC --clip3pAdapterMMp 0.1 --outFilterMultimapNmax 1 --outFilterMultimapScoreRange 0 --outFilterMismatchNmax 2 --alignIntronMax 500000 --genomeLoad NoSharedMemory --outFileNamePrefix $sample. --seedSearchStartLmax 15 --outSJfilterOverhangMin 28 6 6 6

	cat $sample.Aligned.out.sam | samtools view -Sb - > $sample.bam

	rm $sample.Aligned.out.sam
	rm $sample.Log.progress.out
	rm $sample.SJ.out.tab
	rm $sample.Log.out

	echo $sample: Done!

else
	echo $sample.bam already exists!
fi
