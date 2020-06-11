#!/bin/bash --login
module load breakdancer/1.1r11
IN_DIR=$SCRATCH/bwa
OUT_DIR=$SCRATCH/breakdancer
mkdir $OUT_DIR
currd=$PWD

#sample=patient_2
sample=$1
tumour=${sample}_NS.bam
normal=${sample}_PM.bam
#tumour=${sample}_NS.120827.lane1.sorted.bam
#normal=${sample}_PM.120827.lane2.sorted.bam

#1. Create a configuration file and insert size distributions
date
cd $OUT_DIR
echo [Entering directory] cd $OUT_DIR
echo "creating config file for $sample ..."
time bam2cfg.pl -g -h $IN_DIR/$tumour $IN_DIR/$normal > $sample.cfg
date
echo "done"
#2. Detect SVs
date
echo "detecting structural variations for $sample..."
time breakdancer-max -d $sample.ctx $sample.cfg > $sample.ctx
date
echo "done"
echo [Leaving directory] cd $currd
cd $currd


