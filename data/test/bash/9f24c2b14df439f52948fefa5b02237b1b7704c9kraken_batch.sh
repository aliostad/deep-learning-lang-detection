#!/bin/bash

samples_root_dir=/data/neurogen/rnaseq_PD/run_output 
kraken_out_dir=/data/neurogen/Tao/kraken_output
for sample_dir in $samples_root_dir/*
do
	if [[ -d $sample_dir ]]; then
		sample_name=${sample_dir##*/}
		if [[ -d $kraken_out_dir/$sample_name ]]; then
			continue
		fi
		if [[ $sample_name == "ILB"* ]]; then
			if [[ ${sample_name:(-6):1} -ne "1" ]]; then
					bsub -q big -M 64000 -R 'rusage[mem=64000]' sh /PHShome/tw786/MyOwnScript/preprocess_pipeline_core.sh $sample_name
			fi
		fi
	fi
done
