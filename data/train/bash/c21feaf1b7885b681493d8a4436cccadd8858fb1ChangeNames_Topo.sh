#!/bin/sh

# Rename input files

#input_files_path=/work/budvar-clued0/francji/subsets_fake
input_files_path=/work/budvar-clued0/francji/results/

for samples in small_training_sample testing_sample yield_sample; do  #small_training_sample testing_sample yield_sample
  echo $samples;
  for i in $input_files_path/$samples/*; do
  echo $i;
#  mv $i ${i/zero/zero_Topo};
  mv $i ${i/_Topo/};
# for i in /work/budvar-clued0/francji/results_txt/$methods/$samples/$signals/*; do mv $i ${i/.txt.txt/.txt};
  done
done

