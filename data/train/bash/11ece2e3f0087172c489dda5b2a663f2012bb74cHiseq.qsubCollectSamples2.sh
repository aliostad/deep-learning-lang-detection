#!/bin/bash - 

#$ -V
#$ -cwd 

set -eux 

if [ $# -ne 1 ]; then
    echo sample list needed, formated with three columns:
    echo Sample_ID     Illumina_Index	Lanes "(separated by commas, i.e. 1,3,7)"
    exit 1
fi

sampleList=$1
illumina_index=/u/home/eeskin/jwhitake/PIPELINE/Hiseq.v1.0/illumina_indexes.txt

mkdir -p FILES

len=`wc -l $sampleList | awk '{print $1}'`

for i in `seq 1 $len`; do 
	sample=`awk -v i=$i 'NR==i {print $1}' $sampleList`;
	tagtemp=`awk -v i=$i 'NR==i {print $2}' $sampleList`;
	tag=`grep -w $tagtemp $illumina_index | awk '{print $2}'`; 
	
	awk -v i=$i 'NR==i {split($3,a,","); for (j=1;j<=length(a);j++) print a[j]}' $sampleList > ${sample}_${tag}_lanes.txt
	
	qsub `which collectSample2.sh` $sample $tag ${sample}_${tag}_lanes.txt;
done
