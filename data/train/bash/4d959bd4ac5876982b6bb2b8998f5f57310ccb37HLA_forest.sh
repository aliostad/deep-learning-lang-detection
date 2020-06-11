#!/bin/bash
# Determining HLA type from RNAseq
# Written by David Coffey dcoffey@fhcrc.org
# Updated February 17, 2016

## Prerequisites (see Software_installation.sh)
# Install HLA forest and in config.sh modify the HLAFOREST_HOME variable to reflect the directory it resides on your local system
# Modify the CONFIG_PATH variable to reflect the path of the config.sh file that you previously modified
# Install bowtie and add to PATH
# Install perl
# Install BioPerl module

## Variables
# export HLAFOREST=".../hlaforest/scripts/CallHaplotypesPE.sh"
# export SCRATCH_DIRECTORY="..."
# export HLAFOREST_DIRECTORY="..."
# export READ1="....fastq.gz"
# export READ2="....fastq.gz"
# export SAMPLE="..."
# export LAST_SAMPLE="..."
# export EMAIL="..."

START=`date +%s`
echo Begin HLA_forest.sh for sample $SAMPLE on `date +"%B %d, %Y at %r"`

mkdir -p $HLAFOREST_DIRECTORY
mkdir -p $SCRATCH_DIRECTORY/$SAMPLE

if ! [[ -f $SCRATCH_DIRECTORY/$SAMPLE/$SAMPLE.R1.fastq ]]; then
  cp $READ1 $SCRATCH_DIRECTORY/$SAMPLE/$SAMPLE.R1.fastq.gz
  gunzip $SCRATCH_DIRECTORY/$SAMPLE/$SAMPLE.R1.fastq.gz
fi

if ! [[ -f $SCRATCH_DIRECTORY/$SAMPLE/$SAMPLE.R2.fastq ]]; then
  cp $READ2 $SCRATCH_DIRECTORY/$SAMPLE/$SAMPLE.R2.fastq.gz
  gunzip $SCRATCH_DIRECTORY/$SAMPLE/$SAMPLE.R2.fastq.gz
fi

# Call HLA haplotypes
$HLAFOREST $HLAFOREST_DIRECTORY/$SAMPLE \
$SCRATCH_DIRECTORY/$SAMPLE/$SAMPLE.R1.fastq \
$SCRATCH_DIRECTORY/$SAMPLE/$SAMPLE.R2.fastq

# Clean up
mv $HLAFOREST_DIRECTORY/$SAMPLE/haplotypes.txt $HLAFOREST_DIRECTORY/$SAMPLE.haplotypes.txt
rm -R $HLAFOREST_DIRECTORY/$SAMPLE

END=`date +%s`
MINUTES=$(((END-START)/60))
echo End HLA_forest.sh for sample $SAMPLE.  The run time was $MINUTES minutes.

if [[ $SAMPLE = $LAST_SAMPLE ]]
then
	echo "The runtime was $MINUTES minutes" | mail -s "Finished HLA_forest.sh for sample $LAST_SAMPLE" $EMAIL
fi