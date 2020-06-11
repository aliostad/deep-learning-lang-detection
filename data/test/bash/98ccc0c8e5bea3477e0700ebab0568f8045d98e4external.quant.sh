#!/bin/bash

# Process external BAM files for Graham

#BSUB -J "texquan[1-15]"
#BSUB -n 1
#BSUB -q normal
#BSUB -R "select[mem>4000] rusage[mem=4000]"
#BSUB -M 4000
#BSUB -o "output.%J.%I"
#BSUB -e "errors.%J.%I"

#SAMPLE=`ls *Aligned.out.bam | head -n $LSB_JOBINDEX | tail -n 1 | sed 's/_RNA_TCGAAligned.out.bam//'`
SAMPLE=`ls *.bam | head -n $LSB_JOBINDEX | tail -n 1 | sed 's/.bam//'`
GTF=/lustre/scratch112/sanger/am26/tn5/irap_test_run/reference/homo_sapiens/Homo_sapiens.GRCh37.NCBI.allchr_MT.gtf

#samtools sort -o ${SAMPLE}.bam -T tmp.${SAMPLE} -O bam ${SAMPLE}_RNA_TCGAAligned.out.bam
#if [ $? -ne 0 ]
#then
#   exit 1
#fi
#rm ${SAMPLE}_RNA_TCGAAligned.out.bam

htseq-count -f bam -r pos -s no -o ${SAMPLE}.tmp.sam -q ${SAMPLE}.bam $GTF >$SAMPLE.htseq
if [ $? -ne 0 ]
then
   exit 1
fi
samtools view -H ${SAMPLE}.bam >${SAMPLE}.header
cat ${SAMPLE}.header ${SAMPLE}.tmp.sam | samtools view -Sb - >${SAMPLE}.htseqbam
#rm ${SAMPLE}.bam
rm ${SAMPLE}.tmp.sam
rm ${SAMPLE}.header

cufflinks -o $SAMPLE.out -g $GTF ${SAMPLE}.htseqbam
if [ $? -ne 0 ]
then
   exit 1
fi
rm ${SAMPLE}.htseqbam
