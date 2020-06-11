#!/bin/bash
#$ -N CNVnator
#$ -cwd
#$ -V
#$ -o $JOB_ID.$JOB_NAME.out
#$ -e $JOB_ID.$JOB_NAME.err
#$ -pe omp 6


if [ $HOSTNAME == "brahma.local" ]
then
	echo -e "Usage:\n\tqsub -v sample=<sampleID>,bam=<bam_file>,prefix=<outfile prefix> $0";
	exit 0;
fi

#sample=$1
#bam=$2
#prefix=$3
echo -e "Bam:\t$bam"
echo -e "Sample:\t$sample"
echo -e "Prefix:\t$prefix"

#echo "
/Apps/CNVnator/cnvnator -root $sample.root -tree $bam
/Apps/CNVnator/cnvnator -root $sample.root -his 100 -d /common/Data/Internal/Others/Reference_genome/hg_19/
/Apps/CNVnator/cnvnator -root $sample.root -stat 100
/Apps/CNVnator/cnvnator -root $sample.root -partition 100
/Apps/CNVnator/cnvnator -root $sample.root -call 100 > $prefix.cnv_calls.out
