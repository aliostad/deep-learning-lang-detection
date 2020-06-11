#!/bin/bash
## 
## DESCRIPTION:   Given a sample directory in a project directory of an illumina basecall output,
##                generate bam files from all the paired end reads within the sample directory
##
## USAGE:         ngs.pipe.fastq2bam.sample.ge.sh
##                                                Sample_X(Sample directory)
##                                                ref.fa
##                                                dbsnp.vcf
##                                                mills.indel.sites.vcf
##                                                1000G.indel.vcf
##
## OUTPUT:        sample.mergelanes.dedup.realign.recal.bam
##

# Load analysis config
source $NGS_ANALYSIS_CONFIG

# Check correct usage
usage 5 $# $0

# Process input params
SAMPLEDIR=$1
REFERENCE=$2
DBSNP_VCF=$3
MILLS_INDEL_VCF=$4
INDEL_1000G_VCF=$5

# Set up pipeline variables
SAMPLE=`echo $SAMPLEDIR | cut -f2- -d'_'`
FASTQ_PE_LIST_FILE=$SAMPLEDIR/list.fastq.pe

# Get list of all paired-end fastq files in the sample directory
$PYTHON $NGS_ANALYSIS_DIR/modules/seq/detect_fastq_pe_file_pairs.py $SAMPLEDIR > $FASTQ_PE_LIST_FILE

# Generate raw bam files for each pair of PE reads
for pe in `sed 's/\t/:/' $FASTQ_PE_LIST_FILE`; do
  FASTQ_R1=`echo $pe | cut -f1 -d :`
  FASTQ_R2=`echo $pe | cut -f2 -d :`
  qsub_wrapper.sh                                             \
    $SAMPLE.fastq2rawbam.pe                                   \
    all.q                                                     \
    2                                                         \
    none                                                      \
    n                                                         \
    $NGS_ANALYSIS_DIR/pipelines/ngs.pipe.fastq2rawbam.pe.sh   \
      $FASTQ_R1                                               \
      $FASTQ_R2                                               \
      $REFERENCE
done

# Merge all bam files within the sample directory into a single sample bam file
qsub_wrapper.sh                                               \
  $SAMPLE.mergelanes                                          \
  all.q                                                       \
  1                                                           \
  $SAMPLE.fastq2rawbam.pe                                     \
  n                                                           \
  $NGS_ANALYSIS_DIR/modules/align/samtools.mergebam.sh        \
    $SAMPLEDIR/$SAMPLE.mergelanes                             \
    $SAMPLEDIR/*rg.bam

# Dedup, realign, recalibrate
qsub_wrapper.sh                                               \
  $SAMPLE.processbam                                          \
  all.q                                                       \
  1                                                           \
  $SAMPLE.mergelanes                                          \
  n                                                           \
  $NGS_ANALYSIS_DIR/pipelines/ngs.pipe.dedup.realign.recal.sh \
    $SAMPLEDIR/$SAMPLE.mergelanes.bam                         \
    $REFERENCE                                                \
    $DBSNP_VCF                                                \
    $MILLS_INDEL_VCF                                          \
    $INDEL_1000G_VCF


# QC and statistics ===========================================

# Fastqc
qsub_wrapper.sh                                               \
  $SAMPLE.fastqc                                              \
  all.q                                                       \
  1                                                           \
  $SAMPLE.fastq2rawbam.pe                                     \
  n                                                           \
  $NGS_ANALYSIS_DIR/pipelines/ngs.pipe.fastqc.ge.sh           \
    2                                                         \
    $SAMPLEDIR/*fastq.gz                                      \
    $SAMPLEDIR/*fastq

# Sequence stats
qsub_wrapper.sh                                               \
  $SAMPLE.seqstats                                            \
  all.q                                                       \
  1                                                           \
  $SAMPLE.fastq2rawbam.pe                                     \
  n                                                           \
  $NGS_ANALYSIS_DIR/pipelines/ngs.pipe.fastq.stat.ge.sh       \
    $SAMPLEDIR/*fastq.gz                                      \
    $SAMPLEDIR/*fastq

# # BAM QC
# qsub_wrapper.sh                                               \
#   $SAMPLE.bam.qc                                              \
#   all.q                                                       \
#   1                                                           \
#   $SAMPLE.processbam                                          \
#   n                                                           \
#   $NGS_ANALYSIS_DIR/pipelines/ngs.pipe.qc.bam.wes.ge.sh       \
#     B3x                                                       \
#     $SURESELECT_BED Sample_*/*recal.bam
