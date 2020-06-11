#!/bin/sh
#
###############################################################
#
# Author Rajesh Patidar: rajbtpatidar@gmail.com
# Run BWA on PE Illumina Reads.
# Output is Bam sample with Bam statistics.
# Run Command :
#               $0 Sample
###############################################################
echo $sample
echo "################"
echo "################"

module load picard/1.129
module load bwa/0.7.10
module load samtools/1.2
workdir=/lscratch/$SLURM_JOB_ID/
#sample=$1
dir=/data/khanlab/projects/ChIP_seq/DATA/$sample
cd $dir
#ref=/data/khanlab/ref/bwa/ucsc.hg19.fasta
ref=/fdb/igenomes/Mus_musculus/UCSC/mm9/Sequence/BWAIndex/genome.fa
RG="@RG\tID:${sample}\tLB:${sample}\tSM:${sample}\tPL:ILLUMINA"

cd $dir
echo $dir
R1=`/bin/ls ${sample}_R1.fastq.gz`
if [ -e "${sample}_R2.fastq.gz" ]
then
        echo "Processing in PE mode"
        R2=`/bin/ls ${sample}_R2.fastq.gz*`
        mkdir $dir/Fastqc/
#       fastqc -t 15 $R1 -o $dir/Fastqc/
#       fastqc -t 15 $R2 -o $dir/Fastqc/
#       unzip $dir/Fastqc/${sample}_R1_fastqc.zip -d $dir/Fastqc/
#       unzip $dir/Fastqc/${sample}_R2_fastqc.zip -d $dir/Fastqc/
        bwa mem -M -t 32 -R "$RG" $ref $R1 $R2 >$workdir/${sample}.sam
else
        echo "Processing in SE mode"
        cd $sample
        mkdir $dir/Fastqc/
#       fastqc -t 15 $R1 -o $dir/Fastqc/
#       unzip $dir/Fastqc/${sample}_R1_fastqc.zip -d $dir/Fastqc/
        echo "Starting BWA"
        bwa mem -M -t 32 -R "$RG" $ref $R1 >$workdir/${sample}.sam
fi
echo "Mapping finished"
echo "################"
java -Xmx60g  -Djava.io.tmpdir=$workdir -jar $PICARDJARPATH/picard.jar SortSam INPUT=$workdir/${sample}.sam OUTPUT=$dir/${sample}.bam SORT_ORDER=coordinate
echo "Sam to bam conversion finished"
echo "################"

samtools index $dir/${sample}.bam
samtools flagstat ${sample}.bam  >${sample}.flagstat.txt
java -Xmx10g -Djava.io.tmpdir=$workdir -jar $PICARDJARPATH/picard.jar MarkDuplicates I=${sample}.bam O=${sample}.dd.bam REMOVE_DUPLICATES=false M=${sample}.matrix.txt AS=true VALIDATION_STRINGENCY=LENIENT
samtools index ${sample}.dd.bam
