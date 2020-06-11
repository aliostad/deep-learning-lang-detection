#!/bin/bash

set -e

ARGS=5
if [ $# -ne $ARGS ]
then
	echo Usage: `basename $0` \<STAR excutable\> \<genome reference\> \<FASTQ 1\> \<FASTQ 2\> \<output Dir\>
	exit
fi

STAR=$1
genome=$2
fastq1=$3
fastq2=$4
outputDir=$5

sample=`basename $fastq1 | sed 's/.fastq.gz//'`

cd $outputDir

if [ ! -f $outputDir/$sample.Log.final.out ]
then

	$STAR --genomeDir $genome --readFilesIn $fastq1 $fastq2 --readFilesCommand zcat --runThreadN 1 --outFilterMultimapNmax 1 --outFilterMultimapScoreRange 0 --outFilterMismatchNmax 3 --alignMatesGapMax 10000 --alignIntronMax 500000 --outFilterMatchNmin 20 --genomeLoad NoSharedMemory --outFileNamePrefix $sample. --seedSearchStartLmax 30

	cat $sample.Aligned.out.sam | samtools view -Sb - > $sample.bam

	rm $sample.Aligned.out.sam
	rm $sample.Log.progress.out
	rm $sample.SJ.out.tab
	rm $sample.Log.out

	echo $sample: Done!

else
	echo $sample.bam already exists!
fi
