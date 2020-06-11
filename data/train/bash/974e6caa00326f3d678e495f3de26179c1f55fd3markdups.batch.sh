#!/bin/sh

###############################################
# For an experiment or project with a set number
# of samples, each with an unaligned BAM file
# or multiple lanes of BAM files, convert each
# set to fastq files (paired-end).
# 
# Convert all bam files to fastq files.
###############################################

# MARK DUPS SCRIPT
MARKDUPS=/ifs/rcgroups/ccgd/rpa4/scripts/github_repos/rnaseq-analysis/markdups.sh

# SAMPLES
PROJECT_DIR=$1
SAMPLE_NAMES=$2

cd $PROJECT_DIR

SAMPLE_NAMES=(`echo $SAMPLE_NAMES | tr "," "\n"`)
echo 'Marking BAM dups for' $SAMPLE_NAMES
for SAMPLE_NAME in "${SAMPLE_NAMES[@]}"
do
  mkdir -p $SAMPLE_NAME/logs
  STAR_OUTDIR=$PROJECT_DIR/$SAMPLE_NAME/star

  ALIGNED_BAM=$STAR_OUTDIR/Aligned.sortedByCoord.out.bam

  cd $SAMPLE_NAME/logs
  qsub $MARKDUPS $ALIGNED_BAM $SAMPLE_NAME $STAR_OUTDIR $PROJECT_DIR/$SAMPLE_NAME/metrics true

  cd $PROJECT_DIR
done
