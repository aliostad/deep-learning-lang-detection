#!/bin/bash - 

#$ -V
#$ -cwd 

set -e
source error_handling
script_start


#####if [ $# -ne 1 ]; then
#####    echo sample list needed, formated with three columns:
#####    echo Sample_ID     Illumina_Index	Lanes "(separated by commas, i.e. 1,3,7)"
#####    exit 1
#####fi

export PATH=$PATH:/u/home/eeskin/namtran/panasas/Experiment/Demultiplex/Modified_Joe_Pipeline

[ $# -eq 1 ] && pushd $1

sampleList=samples.txt
illumina_index=`which illumina_indexes.txt`

mkdir -p FILES

len=`wc -l $sampleList | awk '{print $1}'`

for i in `seq 1 $len`; do 
	sample=`awk -v i=$i 'NR==i {print $1}' $sampleList`;
	tagtemp=`awk -v i=$i 'NR==i {print $2}' $sampleList`;
	tag=`grep -w $tagtemp $illumina_index | awk '{print $2}'`; 
	
	awk -v i=$i 'NR==i {split($3,a,","); for (j=1;j<=length(a);j++) print a[j]}' $sampleList >> ${sample}_${tag}_lanes.txt
	
	`which collectSample.sh` $sample $tag ${sample}_${tag}_lanes.txt;
done

Hiseq.qsubMergeFastqs.sh FILES


[ $# -eq 1 ] && popd 

script_end
