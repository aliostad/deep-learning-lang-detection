#!/bin/sh

###############################################
# Perform genome and transcriptome alignments
# for a batch of samples..
###############################################

# SOFTWARE
SCRIPTS=/ifs/rcgroups/ccgd/rpa4/scripts/github_repos/rnaseq-analysis/
RSEM_EXP=$SCRIPTS/rsem_expression.sh
FASTQC=$SCRIPTS/run_fastqc.sh
RUN_STAR=$SCRIPTS/run_star.sh
ALIGN_RRNA=$SCRIPTS/align_rrna.sh

# SAMPLES
PROJECT_DIR=$1
SAMPLE_NAMES=$2
RSEM_REF_PATH='/ifs/rcgroups/ccgd/rpa4/analysis/rnaseq/gencode_ref/rsem/ref/gencode_GRCh37-p11_dna.primary-assembly'

cd $PROJECT_DIR

SAMPLE_NAMES=(`echo $SAMPLE_NAMES | tr "," "\n"`)
echo 'RNA-seq analysis for' $SAMPLE_NAMES
for SAMPLE_NAME in "${SAMPLE_NAMES[@]}"
do
  LOG_DIR=$PWD/$SAMPLE_NAME/logs
  mkdir -p $LOG_DIR

  FASTQ_OUTDIR=$PWD/$SAMPLE_NAME/data
  FQ1=$FASTQ_OUTDIR/'read1.fastq'
  FQ2=$FASTQ_OUTDIR/'read2.fastq'

  SAMPLE_BAM_PATHS=`ls -d $FASTQ_OUTDIR/*bam | tr '\n' ','` # PATH TO SAMPLE BAM FILES.

  cd $LOG_DIR

  # RUN FASTQC
  QC_OUTDIR=$PROJECT_DIR/$SAMPLE_NAME/qc
  echo $FASTQC $SAMPLE_NAME 1 $FASTQ_OUTDIR $QC_OUTDIR/fastqc
  qsub -q ccgd.q,all.q $FASTQC $SAMPLE_NAME 1 $FASTQ_OUTDIR $QC_OUTDIR/fastqc
  echo $FASTQC $SAMPLE_NAME 2 $FASTQ_OUTDIR $QC_OUTDIR/fastqc
  qsub -q ccgd.q,all.q $FASTQC $SAMPLE_NAME 2 $FASTQ_OUTDIR $QC_OUTDIR/fastqc

  # RUN RSEM
  RSEM_OUTDIR=$PROJECT_DIR/$SAMPLE_NAME/rsem
  echo $RSEM_EXP $SAMPLE_NAME $SAMPLE_BAM_PATHS $FASTQ_OUTDIR $RSEM_REF_PATH $RSEM_OUTDIR
  qsub -q ccgd.q,all.q $RSEM_EXP $SAMPLE_NAME $SAMPLE_BAM_PATHS $FASTQ_OUTDIR $RSEM_REF_PATH $RSEM_OUTDIR

  # ALIGN_RRNA
  RRNA_OUTDIR=$PROJECT_DIR/$SAMPLE_NAME/rRNA_align
  echo $ALIGN_RRNA $FASTQ_OUTDIR $RRNA_OUTDIR
  qsub -q ccgd.q,all.q $ALIGN_RRNA $FASTQ_OUTDIR $RRNA_OUTDIR 

  # RUN STAR
  STAR_OUTDIR=$PROJECT_DIR/$SAMPLE_NAME/star
  echo $RUN_STAR $FASTQ_OUTDIR $STAR_OUTDIR
  qsub -q ccgd.q,all.q $RUN_STAR $FASTQ_OUTDIR $STAR_OUTDIR

  cd $PROJECT_DIR
done
