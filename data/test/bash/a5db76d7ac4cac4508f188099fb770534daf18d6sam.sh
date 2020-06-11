#!/bin/sh
#$-S /bin/sh
#$ -M kuang.lin@kcl.ac.uk
#$ -m e
#$ -N pfilt
#use current directory as working directory
#$ -cwd

#$ -q long.q,bignode.q,short.q
# Declare how much memory is required PER slot - default is 2Gbytes
##$-l h_vmem=8G
################################################################################

ref=/scratch/data/reference_genomes/human/human_g1k_v37.fa

chip=$1
sample=$2

# samtools view -bT $ref  sam/${chip}_${sample}.sam \
# > sam/${chip}_${sample}.bam 

############
samtools sort  sam/${chip}_${sample}.bam sam/${chip}_${sample}_sorted
samtools rmdup sam/${chip}_${sample}_sorted.bam sam/${chip}_${sample}_nodup.bam
samtools index sam/${chip}_${sample}_nodup.bam

############
# to convert back to same file:
#  samtools view -h D0L9C_MF_1348_all.bam > tall.sam
# 
