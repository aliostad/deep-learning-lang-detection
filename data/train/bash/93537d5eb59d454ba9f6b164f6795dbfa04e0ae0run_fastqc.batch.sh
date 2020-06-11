#!/bin/sh

###############################################
###############################################

SCRIPTS_DIR='/ifs/rcgroups/ccgd/rpa4/scripts/github_repos/rnaseq-analysis/rnd'
FASTQC=$SCRIPTS_DIR/'run_fastqc.sh'

PROJECT_DIR=$1
DATA_TAG=$2 # Name of directory containing fastq files to align.
SAMPLE_IDS=$3

cd $PROJECT_DIR

SAMPLE_ID_ARR=(`echo $SAMPLE_IDS | tr "," "\n"`)
echo 'Running fastqc for samples:' $SAMPLE_ID_ARR
for SAMPLE_ID in "${SAMPLE_ID_ARR[@]}"
do
    LOG_DIR=$PROJECT_DIR/$SAMPLE_ID/logs
    mkdir -p $LOG_DIR

    FQ_DIR=$PROJECT_DIR/$SAMPLE_ID/data/$DATA_TAG
    OUT_DIR=$PROJECT_DIR/$SAMPLE_ID/qc/fastqc
    cd $SAMPLE_ID/logs
    echo $0 'Running Fastqc for sample' $SAMPLE_ID 'fastq files in' $FQ_DIR >> $LOG_DIR/analysis.log
    echo 'qsub' $FASTQC $FQ_DIR $OUT_DIR >> $LOG_DIR/analysis.log
    echo $FASTQC $FQ_DIR $OUT_DIR
    qsub $FASTQC $FQ_DIR $OUT_DIR
    cd $PROJECT_DIR
done
