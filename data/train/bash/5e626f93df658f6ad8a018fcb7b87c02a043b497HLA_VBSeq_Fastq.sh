#!/usr/bin/env bash

### typing HLA using exome sequencing data
### run on Ubuntu 14.04 LTS
### @ Felix Yanhui Fan felixfanyh@gmail.com
### @ 17 Aug 2016

### From bam to HLA typing
SAMPLE=$1
FQ1=$2
FQ2=$3
OUTDIR="/home/felixfan/uwork/ADExomeHLA2016/HLA-VBSeq_results"
TOOLDIR="/home/felixfan/ubin/HLA-VBSeq"
TMPDIR="/home/felixfan/uwork/ADExomeHLA2016/temp"
################################################################
### Build index for reference
#bwa index ${TOOLDIR}/hla_all.fasta
################################################################
bwa mem -t 8 -P -L 10000 -a $TOOLDIR/hla_all.fasta ${FQ1} ${FQ2} > ${TMPDIR}/${SAMPLE}.hla.sam
################################################################
### Estimation of HLA types by HLA-VBSeq 
java -jar -Xmx30g $TOOLDIR/HLAVBSeq.jar $TOOLDIR/hla_all.fasta ${TMPDIR}/${SAMPLE}.hla.sam ${OUTDIR}/${SAMPLE}.result.txt --alpha_zero 0.01 --is_paired
################################################################
### parse result
perl $TOOLDIR/parse_result.pl $TOOLDIR/Allelelist.txt ${OUTDIR}/${SAMPLE}.result.txt | grep "^A\*" | sort -k2 -n -r > ${OUTDIR}/${SAMPLE}.HLA_A.txt
perl $TOOLDIR/parse_result.pl $TOOLDIR/Allelelist.txt ${OUTDIR}/${SAMPLE}.result.txt | grep "^B\*" | sort -k2 -n -r > ${OUTDIR}/${SAMPLE}.HLA_B.txt
perl $TOOLDIR/parse_result.pl $TOOLDIR/Allelelist.txt ${OUTDIR}/${SAMPLE}.result.txt | grep "^C\*" | sort -k2 -n -r > ${OUTDIR}/${SAMPLE}.HLA_C.txt
perl $TOOLDIR/parse_result.pl $TOOLDIR/Allelelist.txt ${OUTDIR}/${SAMPLE}.result.txt | grep "^DRB1\*" | sort -k2 -n -r > ${OUTDIR}/${SAMPLE}.HLA_DRB1.txt
perl $TOOLDIR/parse_result.pl $TOOLDIR/Allelelist.txt ${OUTDIR}/${SAMPLE}.result.txt | grep "^DQB1\*" | sort -k2 -n -r > ${OUTDIR}/${SAMPLE}.HLA_DQB1.txt
perl $TOOLDIR/parse_result.pl $TOOLDIR/Allelelist.txt ${OUTDIR}/${SAMPLE}.result.txt | grep "^DQA1\*" | sort -k2 -n -r > ${OUTDIR}/${SAMPLE}.HLA_DQA1.txt
### clean
rm ${TMPDIR}/${SAMPLE}.hla.sam

