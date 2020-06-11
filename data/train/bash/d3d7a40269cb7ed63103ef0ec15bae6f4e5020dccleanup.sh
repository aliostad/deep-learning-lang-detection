#!/bin/bash
set -x

sample, p.STAR_RESULTS, p.BWA_RESULTS, p.SNPIR_RESULTS, p.FUSIONCATCHER_RESULTS. p.TEMP_DIR, p.RAW_DATA_DIR, TCGA_OUTPUT_PATH

sample=$1
star_results=$2
bwa_results=$3
snpir_results=$4
fusioncatcher_results=$5
temp_dir=$6
raw_data_dir=$7
TCGA=$8

#remove raw data
rm ${TCGA}/*.tar.gz
rm ${raw_data_dir)/${sample}.fastq
rm ${raw_data_dir)/${sample}_1.fastq
rm ${raw_data_dir)/${sample}_2.fastq

#remove star files
rm ${star_results}/${sample}/Aligned.out.sam
rm ${star_results}/${sample}/Aligned.out.bam

#remove bwa files
#rm ${bwa_results}/${sample}/${sample}.sam 

#remove snpir 

#remove fusioncatcher

#remove temp_dir

