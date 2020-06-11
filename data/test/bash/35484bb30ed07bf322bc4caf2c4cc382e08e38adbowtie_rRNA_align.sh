#!/bin/bash
#$ -cwd
#$ -e logs
#$ -o logs

############################
#Use Bowtie alignment to check rRNA rates for RNA-Seq samples.
#New York Genome Center
#Heather Geiger (hmgeiger@nygenome.org)
#Version 04-13-2015
############################

#Declare Nb of CPU. Adjust SGE settings if want to run multi-threaded.

NB_CPU=1

if [ $# -lt 2]
then
echo "Usage: $0 sample(with Sample) species(mouse/human)"
exit 1
fi

sample=$1
species=$2

#Make concatenated FASTQ files across all lanes.
#Note: This script assumes a certain way for FASTQs to be organized. Adjust if they are in a different place,
#or if they are unzipped.

if [ ! -e /scratch/${sample}_tmp ];then mkdir /scratch/${sample}_tmp;fi

cat $Raw_dir/${sample}/fastq/*R1*.fastq.gz > /scratch/${sample}_tmp/${sample}_R1.fastq.gz
cat $Raw_dir/${sample}/fastq/*R2*.fastq.gz > /scratch/${sample}_tmp/${sample}_R2.fastq.gz
FASTQ1=/scratch/${sample}_tmp/${sample}_R1.fastq.gz
FASTQ2=/scratch/${sample}_tmp/${sample}_R2.fastq.gz

#Make output directories and run alignment.

if [ ! -e ${sample}/logs ];then mkdir ${sample}/logs;fi
if [ ! -e ${sample}/Stats ];then mkdir ${sample}/Stats;fi

Raw_dir=`pwd`

echo $sample Starting bowtie to rRNA `hostname --short` `date` | tee -a $Raw_dir/${sample}/logs/${sample}_rRNA_alignment.log >&2

if [ $species = human ]
then
BOWTIE_rRNA_Index=/data/NYGC/Resources/Indexes/bowtie2/rRNA_indexes/human_rRNA_bowtie2Index
else
BOWTIE_rRNA_Index=/data/NYGC/Resources/Indexes/bowtie2/rRNA_indexes/mouse_all_rRNA
fi

/data/NYGC/Software/bowtie/bowtie2-2.1.0/bowtie2 \
 --fast-local \
 -p $NB_CPU \
 -x $BOWTIE_rRNA_Index \
 -1 $FASTQ1 -2 $FASTQ2 \
 -S /scratch/${sample}_tmp/${sample}_rRNA_alignment.sam \
 &> $Raw_dir/${sample}/Stats/${sample}_rRNA_mapping.txt

rm /scratch/${sample}_tmp/${sample}_rRNA_alignment.sam

echo $sample Finishing bowtie to rRNA `hostname --short` `date` | tee -a $Raw_dir/${sample}/logs/${sample}_rRNA_alignment.log >&2

