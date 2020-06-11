#!/bin/bash

sample=$1

full_path=`echo $sample | grep -c '\/'`

if [ $full_path -eq 0 ]
then
name=`echo $sample | awk -F "Sample_" '{print $2}'`
sample_id=$sample
else
sample_id=`echo $sample | awk -F "/" '{print $NF}'`
name=`echo $sample_id | awk -F "Sample_" '{print $2}'`
fi

if [ ! -e ${sample_id} ];then mkdir ${sample_id};fi
if [ ! -e ${sample_id}/Stats ];then mkdir ${sample_id}/Stats;fi
if [ ! -e ${sample_id}/featureCounts ];then mkdir ${sample_id}/featureCounts;fi
if [ ! -e ${sample_id}/STAR_alignment ];then mkdir ${sample_id}/STAR_alignment;fi

rRNA_lines_type_one=`cat ${sample}/align/analysis/bowtie2/*/*.log | wc -l`

rRNA_lines_type_two=`cat ${sample}/align/analysis/bowtie2/*.log | wc -l`

if [ $rRNA_lines_type_one -gt 0 ]
then
cat ${sample}/align/analysis/bowtie2/*/*.log | grep overall > ${sample_id}/Stats/${sample_id}_rRNA_mapping.txt
elif [ $rRNA_lines_type_two -gt 0 ]
then
cat ${sample}/align/analysis/bowtie2/*.log | grep overall > ${sample_id}/Stats/${sample_id}_rRNA_mapping.txt
fi

cat ${sample}/align/analysis/star/*STAR/Log.final.out > ${sample_id}/STAR_alignment/${sample_id}_STAR_logs_concatenated_Log.final.out

cp ${sample}/qc/${name}.RNAMetrics.metrics ${sample_id}/Stats/${sample_id}_RNAMetrics.txt
cp ${sample}/qc/${name}.dedup.metrics ${sample_id}/Stats/${sample_id}_MarkDuplicates.metrics.txt
cp ${sample}/qc/${name}.GC.xls ${sample_id}/Stats/${sample_id}.GC.xls
cp ${sample}/qc/${name}.inner_distance_freq.txt ${sample_id}/Stats/${sample_id}.inner_distance_freq.txt
cp ${sample}/qc/${name}_counts.txt.summary ${sample_id}/featureCounts/${sample_id}_counts.txt.summary
cp ${sample}/qc/${name}_counts.txt ${sample_id}/featureCounts/${sample_id}_counts.txt
