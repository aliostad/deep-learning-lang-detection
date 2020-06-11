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

cp ${sample}/Stats/* ${sample_id}/Stats
cp ${sample}/featureCounts/* ${sample_id}/featureCounts
cp ${sample}/STAR_alignment/*Log.final.out ${sample_id}/STAR_alignment
