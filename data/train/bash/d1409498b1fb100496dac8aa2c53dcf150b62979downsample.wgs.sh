#!/bin/bash
#$ -cwd

## Tool to downsample WGS chromosome BAMs.

dir="/ifs/scratch/c2b2/ngs_lab/ngs/Projects/CNV/data/net_downsampled/"
picard="/ifs/scratch/c2b2/ngs_lab/sz2317/softwares/picard-tools-1.65/"
suffix=".bam.sorted.bam.noDup.bam.baq.bam"

sample=$1
cov=$2

for i in `seq 1 22`
do
    fraction=`cut -f ${i} $dir/$sample/fractions.$cov `
    cmd1=""
    if [ ! -e $dir/$sample/$sample.$i$suffix.bai ]
    then
	echo "creating index file"
	cmd1="samtools index $dir/$sample/$sample.$i$suffix "
    fi

    echo  "" > $dir/logs/log.$sample.$cov.$i.o 
    echo  "" > $dir/logs/log.$sample.$cov.$i.e

    echo " $cmd1 java -Xmx25g -jar $picard/DownsampleSam.jar INPUT=$dir/$sample/$sample.$i$suffix  OUTPUT=$dir/$sample/$sample.$i$suffix.$cov.bam PROBABILITY=$fraction VALIDATION_STRINGENCY=SILENT ; echo done " | qsub -o $dir/logs/log.$sample.$cov.$i.o -e $dir/logs/log.$sample.$cov.$i.e -l mem=32G,time=10::

done
