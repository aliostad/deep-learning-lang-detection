#!/bin/sh
#$ -S /bin/sh
#$ -cwd
#$ -V
###################

###############################################
# Batch cleanup of fastq files for a project.
###############################################

# SAMPLES
PROJECT_DIR=$1
SAMPLE_NAMES=$2

cd $PROJECT_DIR

SAMPLE_NAMES=(`echo $SAMPLE_NAMES | tr "," "\n"`)
echo 'Deleting Fastq files for' $SAMPLE_NAMES
for SAMPLE_NAME in "${SAMPLE_NAMES[@]}"
do
  FASTQ_OUTDIR=$PWD/$SAMPLE_NAME/data
  FQ1=$FASTQ_OUTDIR/'read1.fastq'
  FQ2=$FASTQ_OUTDIR/'read2.fastq'

  # GENERATE FASTQ DATA FROM ALIGNED SAMPLE BAM FILE
  if [ -e $FQ1 ] && [ -e $FQ2 ] ; then
    echo 'Removing Fastq files.'
    rm $FASTQ_OUTDIR/*.fastq
  else 
    echo 'No Fastq files exist.'
  fi
  cd $PROJECT_DIR
done
