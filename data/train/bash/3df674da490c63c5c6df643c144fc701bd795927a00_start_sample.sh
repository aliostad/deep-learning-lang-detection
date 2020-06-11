#!/bin/bash

# a00_start_sample.sh
# Start wes lane alignment and QC for a single sample timed out in the lane run
# Alexey Larionov, 18Aug2015

# Read parameters
job_file="${1}"
sample="${2}"
scripts_folder="${3}"

# Read job's settings
source "${scripts_folder}/a02_read_config.sh"

# Progress report to pipeline log
pipeline_log="${logs_folder}/a00_pipeline_${project}_${lane}.log"
echo "" >> "${pipeline_log}"
echo "Repeating sample timed out during the lane run" >> "${pipeline_log}"
echo "Started: $(date +%d%b%Y_%H:%M:%S)" >> "${pipeline_log}"
echo "sample: ${sample}" >> "${pipeline_log}"
echo "" >> "${pipeline_log}"

# Start sample
sbatch --time=05:00:00 --account=TISCHKOWITZ-SL2 \
       "${scripts_folder}/s02_pipeline.sb.sh" \
       "${sample}" \
       "${job_file}" \
       "${logs_folder}" \
       "${scripts_folder}" \
       "${pipeline_log}"
