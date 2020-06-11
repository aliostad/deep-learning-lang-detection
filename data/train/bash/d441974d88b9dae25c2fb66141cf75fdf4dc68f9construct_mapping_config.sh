#!/bin/bash

set -o nounset
set -o errexit

source definitions.sh

# Mapping from sample names to sample codes that will appear in, e.g., the
# output of miRDeep2's quantification tool
declare -A SAMPLE_CODES=(
    ...
)

MAPPER_CONFIG_FILE=$1
shift

SAMPLES=$*

mkdir -p $MAPPED_READS_DIR

# Construct a mapping configuration file that will allow us to track which
# sample each read came from throughout the subsequent analysis
for sample in $SAMPLES; do
    trimmed_fasta=${TRIMMED_READS_DIR}/${sample}.trimmed.fastq
    sample_code=${SAMPLE_CODES["$sample"]}

    echo "${trimmed_fasta} ${sample_code}" >> $MAPPER_CONFIG_FILE
done
