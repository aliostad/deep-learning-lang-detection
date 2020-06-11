#!/bin/sh

cd /mnt/PDanalysis/scripts/bwa-0.6.2/
#./bwa index /mnt/PDanalysis/results/trinity_assemblies/Trinity_kmer31.fasta

for sample in CO1 CO2 CO3 CO4 CO5 CO6 CO7 CO8 WY1 WY2 WY3 WY4 WY5 WY6 WY7 WY8
do
    cd /mnt/PDanalysis/scripts/bwa-0.6.2/
    ./bwa aln -n 1 -t 10 /mnt/PDanalysis/results/trinity_assemblies/Trinity_kmer31.fasta /mnt/PDanalysis/data/preprocessed_data/r1_$sample.fastq > /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.sai
    ./bwa aln -n 1 -t 10 /mnt/PDanalysis/results/trinity_assemblies/Trinity_kmer31.fasta /mnt/PDanalysis/data/preprocessed_data/r2_$sample.fastq > /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.sai
    ./bwa samse -r "@RG\tID:$sample\tSM:$sample" -f /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.sam /mnt/PDanalysis/results/trinity_assemblies/Trinity_kmer31.fasta /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.sai /mnt/PDanalysis/data/preprocessed_data/r1_$sample.fastq
    ./bwa samse -r "@RG\tID:$sample\tSM:$sample" -f /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.sam /mnt/PDanalysis/results/trinity_assemblies/Trinity_kmer31.fasta /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.sai /mnt/PDanalysis/data/preprocessed_data/r2_$sample.fastq
    cd /mnt/PDanalysis/scripts/samtools-0.1.18
    ./samtools view -bS /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.sam >/mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.bam
    ./samtools view -bS /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.sam > /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.bam
    ./samtools sort /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.bam /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.sorted
    ./samtools sort /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.bam /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.sorted
    ./samtools index /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.sorted.bam
    ./samtools index /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.sorted.bam
    ./samtools merge /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/$sample.bam /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1_$sample.sorted.bam /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2_$sample.sorted.bam
    rm /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r1* /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/r2*
    ./samtools index /mnt/PDanalysis/process/bwa_alignments_kmer31-SE/$sample.bam
done


