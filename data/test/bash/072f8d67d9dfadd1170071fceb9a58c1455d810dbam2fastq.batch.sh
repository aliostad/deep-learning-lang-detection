#!/bin/sh

###############################################
# For an experiment or project with a set number
# of samples, each with an unaligned BAM file
# or multiple lanes of BAM files, convert each
# set to fastq files (paired-end).
# 
# Convert all bam files to fastq files.
###############################################

SCRIPTS_DIR='/ifs/rcgroups/ccgd/rpa4/scripts/github_repos/rnaseq-analysis/rnd'
BAM2FQ=$SCRIPTS_DIR/'bam2fastq.sh'

PROJECT_DIR=$1
DATA_TAG=$2 # Name of directory containin bams and outputting fastq.
SAMPLE_IDS=$3

cd $PROJECT_DIR

SAMPLE_ID_ARR=(`echo $SAMPLE_IDS | tr "," "\n"`)
echo 'Converting BAM to Fastq for' $SAMPLE_ID_ARR
for SAMPLE_ID in "${SAMPLE_ID_ARR[@]}"
do
    LOG_DIR=$PROJECT_DIR/$SAMPLE_ID/logs
    mkdir -p $LOG_DIR
    FASTQ_OUTDIR=$PROJECT_DIR/$SAMPLE_ID/data/$DATA_TAG # This directory should contain the bam files as well.

    SAMPLE_BAM_PATHS=($(ls -d $FASTQ_OUTDIR/$SAMPLE_ID*'.bam'))
    for SAMPLE_BAM in "${SAMPLE_BAM_PATHS[@]}"
    do  
        BAM_BASENAME=$(basename "$SAMPLE_BAM" '.bam')
        FQ1=$FASTQ_OUTDIR/$BAM_BASENAME'_1.fastq'
        FQ2=$FASTQ_OUTDIR/$BAM_BASENAME'_2.fastq'

        OUTBASE=$FASTQ_OUTDIR/$BAM_BASENAME
        echo $BAM_BASENAME
        cd $SAMPLE_ID/logs
        echo $0 'Generating fastq files for sample' $SAMPLE_ID 'bam file' $SAMPLE_BAM 'for data tag' $DATA_TAG >> $LOG_DIR/analysis.log
        echo 'qsub' $BAM2FQ $SAMPLE_BAM $OUTBASE $LOG_DIR/analysis.log >> $LOG_DIR/analysis.log
        qsub $BAM2FQ $SAMPLE_BAM $OUTBASE $LOG_DIR/analysis.log
    done
    cd $PROJECT_DIR
done
