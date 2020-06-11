#!/bin/sh
#$-S /bin/sh
#$ -M kuang.lin@kcl.ac.uk
#$ -m e
#$ -N novo1
#$ -cwd
#$ -q long.q,short.q,bignode.q
#$ -l h_vmem=10G
#$ -pe mpi 8
################################################################################

chip=$1
sample=$2

/share/mpi/mpich2_1.3.1/bin/mpiexec -n 8 -verbose \
/share/apps/novocraft_20120628/bin/novoalignMPI \
-d /scratch/data/reference_genomes/human/human_g1k_v37 \
-c 1 \
-F ILM1.8 \
-o SAM $'@RG\tID:PSZ\tPL:ILLUMINA\tPU:'${chip}'\tSM:'${sample} \
-f fastq/${chip}_${sample}_R1.fastq fastq/${chip}_${sample}_R2.fastq \
-i PE 120,80 \
-q 2 \
-k \
> ${chip}_${sample}.stats \
> sam/${chip}_${sample}.sam


##############################
# convert to bam

ref=/scratch/data/reference_genomes/human/human_g1k_v37.fa

samtools view -bT $ref sam/${chip}_${sample}.sam > sam/${chip}_${sample}.bam 

##############################
# sort 

samtools sort sam/${chip}_${sample}.bam sam/${chip}_${sample}_sorted

##############################
# remove duplications

samtools rmdup sam/${chip}_${sample}_sorted.bam sam/${chip}_${sample}_nodup.bam


