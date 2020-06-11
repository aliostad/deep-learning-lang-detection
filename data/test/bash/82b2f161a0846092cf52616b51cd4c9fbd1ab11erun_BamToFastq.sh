#!/bin/sh

if [ $# -lt 4 ]; then
  printf "\nUsage run_BamToFastq.sh [samples list] [library type] [Output directory] [script]\n"
  exit 0
fi

sample_list="$1"
lib="$2"
output_dir="$3"
script="$4"


while read f; do
  basef=$(basename $f)
  label=${basef#tophat_}

  sample=$f/"accepted_hits_RG.bam"
  if [ ! -f "$sample" ];then
    sample=$f/"accepted_hits.bam"; fi

  if [ ! -d "$output_dir" ];then
    output_dir=$f;fi

  cd $f
  qsub -v sample=$sample,label=$label,lib_type=$lib,output_dir=$output_dir $script
done < $sample_list


