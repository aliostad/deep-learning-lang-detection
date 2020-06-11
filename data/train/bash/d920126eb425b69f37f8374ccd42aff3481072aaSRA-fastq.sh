#!/bin/bash
#$ -M david.wragg@toulouse.inra.fr
#$ -m a

# set -e will cause script to terminate on an error, set +e allows it to continue
set -e

SAMPLE=
OUT=

while getopts ":s:o:" opt; do
  case $opt in
    s) SAMPLE=${OPTARG};;
    o) OUT=${OPTARG};;
  esac
done

if [[ -z ${SAMPLE} ]] | [[ -z ${OUT} ]]
then
  exit 1
fi


# Create directory and download SRA data
cd ${OUT}/${SAMPLE}
#wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/${SAMPLE:0:3}/${SAMPLE:0:6}/${SAMPLE}/${SAMPLE}.sra

# Convert SRA to FASTQ
fastq-dump --split-files --gzip ${OUT}/${SAMPLE}/${SAMPLE}.sra

