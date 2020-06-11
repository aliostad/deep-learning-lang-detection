#!/bin/bash

set -o nounset
set -o errexit

source definitions.sh

# Mapping from sample name to the FASTQ file containing reads for that sample
declare -A SAMPLE_FASTA=(
    ...
)

mkdir -p ${TRIMMED_READS_DIR}

# Run the 'cutadapt' tool on each set of reads to remove adapter sequences.
for sample in $SAMPLES; do
    fasta_file=${SAMPLE_FASTA["$sample"]}

    $CUTADAPT -a <...> -O 3 -m 17 -f fastq -q 20 ${FASTA_DIR}/$fasta_file -o ${TRIMMED_READS_DIR}/${sample}.trimmed.fastq --too-short-output=${TRIMMED_READS_DIR}/${sample}.trimmed.tooshort.fastq > ${TRIMMED_READS_DIR}/${sample}.trim_report.txt
done
