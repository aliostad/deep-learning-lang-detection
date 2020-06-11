#!/usr/bin/env bash

#############################################################################
#  run_ChunkChromosome.sh
#  Author: Ron Rahaman (rahaman@gmail.com)
#  Date: 2014-10-26
#
#  A script to run ChunkChromosome on a series of .dat files.
#  
#  ChunkChromosome is produced by the University of Michigan Center for
#  Statistical Genetics (http://genome.sph.umich.edu/wiki/ChunkChromosome)
#############################################################################

length=100          # length argument
overlap=20          # overlap argument
logdir=logfiles     # directory for logfiles

chr_list=($(seq 1 22) 'X' 'Y')   # list of chromosomes to process

# If logfile directory doesn't exist, create it
if [ ! -d $logfiles ]; then
  mkdir -p $logfiles
fi

# Run ChunkChromosome for each chromosome
for chr in ${chr_list[@]}; do
  log="${logdir}/ChunkChromosome_chr${chr}.log"
  ChunkChromosome -d "chr${chr}.dat" -n $length -o $overlap 2>&1 | tee $log
done
