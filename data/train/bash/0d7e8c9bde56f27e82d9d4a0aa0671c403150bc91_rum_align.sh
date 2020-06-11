#! /usr/bin/env bash
#BSUB -J rummmmm[1-40]
#BSUB -e %J.%I.err
#BSUB -o %J.%I.out
#BSUB -R "select[mem>32] rusage[mem=32] span[hosts=1]"
#BSUB -n 5
#BSUB -q normal

<<DOC
$ git clone https://github.com/PGFI/rum
$ cd rum
$ perl Makefile.PL
$ rum_indexes -i hg19 --prefix=/vol1/home/brownj/projects/ref/rum
$ rum_runner align -v -i <index> -o <outdir> --chunks <"threads"> --name <name> <fastq>
DOC

set -o nounset -o pipefail -o errexit -x

SAMPLES=(idx0
Human_RNAseq_gene_rep_2_sample_1_shred.fastq
Human_RNAseq_gene_rep_2_sample_2_shred.fastq
Human_RNAseq_gene_rep_2_sample_3_shred.fastq
Human_RNAseq_gene_rep_2_sample_4_shred.fastq
Human_RNAseq_gene_rep_2_sample_5_shred.fastq
Human_RNAseq_gene_rep_2_sample_6_shred.fastq
Human_RNAseq_gene_rep_2_sample_7_shred.fastq
Human_RNAseq_gene_rep_2_sample_8_shred.fastq
Human_RNAseq_gene_rep_3_sample_1_shred.fastq
Human_RNAseq_gene_rep_3_sample_2_shred.fastq
Human_RNAseq_gene_rep_3_sample_3_shred.fastq
Human_RNAseq_gene_rep_3_sample_4_shred.fastq
Human_RNAseq_gene_rep_3_sample_5_shred.fastq
Human_RNAseq_gene_rep_3_sample_6_shred.fastq
Human_RNAseq_gene_rep_3_sample_7_shred.fastq
Human_RNAseq_gene_rep_3_sample_8_shred.fastq
Human_RNAseq_isoform_rep_1_sample_1_shred.fastq
Human_RNAseq_isoform_rep_1_sample_2_shred.fastq
Human_RNAseq_isoform_rep_1_sample_3_shred.fastq
Human_RNAseq_isoform_rep_1_sample_4_shred.fastq
Human_RNAseq_isoform_rep_1_sample_5_shred.fastq
Human_RNAseq_isoform_rep_1_sample_6_shred.fastq
Human_RNAseq_isoform_rep_1_sample_7_shred.fastq
Human_RNAseq_isoform_rep_1_sample_8_shred.fastq
Human_RNAseq_isoform_rep_2_sample_1_shred.fastq
Human_RNAseq_isoform_rep_2_sample_2_shred.fastq
Human_RNAseq_isoform_rep_2_sample_3_shred.fastq
Human_RNAseq_isoform_rep_2_sample_4_shred.fastq
Human_RNAseq_isoform_rep_2_sample_5_shred.fastq
Human_RNAseq_isoform_rep_2_sample_6_shred.fastq
Human_RNAseq_isoform_rep_2_sample_7_shred.fastq
Human_RNAseq_isoform_rep_2_sample_8_shred.fastq
Human_RNAseq_isoform_rep_3_sample_1_shred.fastq
Human_RNAseq_isoform_rep_3_sample_2_shred.fastq
Human_RNAseq_isoform_rep_3_sample_3_shred.fastq
Human_RNAseq_isoform_rep_3_sample_4_shred.fastq
Human_RNAseq_isoform_rep_3_sample_5_shred.fastq
Human_RNAseq_isoform_rep_3_sample_6_shred.fastq
Human_RNAseq_isoform_rep_3_sample_7_shred.fastq
Human_RNAseq_isoform_rep_3_sample_8_shred.fastq
)
SAMPLE=${SAMPLES[${LSB_JOBINDEX}]}
NAME=$(basename $SAMPLE .fastq)

INDEX=$HOME/projects/ref/rum/hg19
ARCHIVE=/vol1/home/tzungs/Ken_Simulated_6_Dataset_Archive/Ken_Simulated_6_FASTQ_Archive
OUTPUT=/vol1/home/tzungs/Ken_Simulated_6_Dataset_Archive/Ken_Joe_Simulated_6_Dataset/$NAME

find $ARCHIVE/* -name $SAMPLE | xargs rum_runner align -v -i $INDEX -o $OUTPUT --chunks 5 --name $NAME

# cleaning up
cd $OUTPUT
samtools view -ShuF 4 RUM.sam | samtools sort -o - $NAME.temp -m 9500000000 > RUM.bam
samtools index RUM.bam
rm -f RUM.sam
gzip *.fa
gzip RUM_Unique
gzip RUM_NU