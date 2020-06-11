#!/bin/bash
#$ -cwd -pe smp 4 -l mem=5G,time=48:: -e Logs -o Logs

endtimefunc () {
  echo -e "\t`date +'%s'`" >> $1
}

fq1=$1
fq2=$2
sampleName=$3
REF=$4

./qstat_summary.sh &

maxgaps=2
maxeditdist=0.04
qualtrim=5
platform=illumina
threads=4
timing=Usage/${JOB_NAME}.timing.txt
echo -e "job\tsample\tstart\tend" > $timing
readgroup=$sampleName
rgheader="@RG\tID:${sampleName}\tSM:${sampleName}\tLB:${sampleName}\tPL:${platform}\tCN:NGSColumbia"
echo -n -e "bwa\t$sampleName\t`date +'%s'`" >> $timing
bwa mem -P -r 1.2 -t $threads -R $rgheader $REF $fq1 $fq2 | samblaster | samtools view -Sb - > ${sampleName}.unsorted.bam
endtimefunc $timing
echo -n -e "sort\t$sampleName\t`date +'%s'`" >> $timing  
samtools sort -@ $threads ${sampleName}.unsorted.bam ${sampleName}
endtimefunc $timing
mv ${sampleName}.unsorted.bam Temp/
echo -n -e "index\t$sampleName\t`date +'%s'`" >> $timing  
samtools index ${sampleName}.bam
endtimefunc $timing
