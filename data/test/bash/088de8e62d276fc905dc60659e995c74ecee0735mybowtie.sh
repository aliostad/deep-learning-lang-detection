#!/bin/bash

if [ $# -ne 2 ] ; then
  echo "usage: bowtie.sh LOCUSname SAMPLEname"
  echo "omit \".fasta\" and \".fastq\""
  exit 1
fi

locus=$1
sample=$2

bowtie2-build -f ${locus}.fasta $locus
sample_locus=${sample}_${locus}
echo SAMPLE_LOCUS: $sample_locus
# echo "sample: $sample ; locus: $locus"

bowtie2 -x $locus --very-fast --no-unal -U ${sample}.fastq -S ${sample_locus}.sam
samtools view -bS ${sample_locus}.sam | \
samtools sort - ${sample_locus}s
samtools depth ${sample_locus}s.bam > ${sample_locus}.depth.txt

rm *.sam

echo bowtie DONE: $sample_locus