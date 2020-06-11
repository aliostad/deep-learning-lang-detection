#!/bin/bash

seed=1
n_sample=5000

for id in "Sample_Pb_dark_2" "Sample_Pb_dark_3" "Sample_Pb_dark_5" "Sample_Pb_light_9" "Sample_Pb_light_10" "Sample_Pb_light_11"
do
    R1=/storage/sequencing_data/paramecium_micractinium/day_vs_night/single_cell_transcriptomes_1/$id/raw_illumina_reads/*R1_001.fastq.gz;
    R2=/storage/sequencing_data/paramecium_micractinium/day_vs_night/single_cell_transcriptomes_1/$id/raw_illumina_reads/*R2_001.fastq.gz;
    mkdir -p ${id}
    seqtk sample -s $seed $R1 $n_sample > ${id}/${id}_R1_sample.fq &
    seqtk sample -s $seed $R2 $n_sample > ${id}/${id}_R2_sample.fq &
    ((seed++))
done;
wait;

for id in "Sample_Pb_DARK2_2" "Sample_Pb_DARK2_3" "Sample_Pb_DARK2_6" "Sample_Pb_DARK2_7" "Sample_Pb_DARK2_8"
do
    R1=/storage/sequencing_data/paramecium_micractinium/day_vs_night/single_cell_transcriptomes_2/$id/raw_illumina_reads/*R1_001.fastq.gz;
    R2=/storage/sequencing_data/paramecium_micractinium/day_vs_night/single_cell_transcriptomes_2/$id/raw_illumina_reads/*R2_001.fastq.gz;
    mkdir -p ${id}
    seqtk sample -s $seed $R1 $n_sample > ${id}/${id}_R1_sample.fq &
    seqtk sample -s $seed $R2 $n_sample > ${id}/${id}_R2_sample.fq &
    ((seed++))
done;
wait;
