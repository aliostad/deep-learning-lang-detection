#!/usr/bin/env bash

#############################################################################
#  run_mach.sh
#  Author: Ron Rahaman (rahaman@gmail.com)
#  Date: 2014-10-26
#
#  Runs MaCH as part of an imputation pipeline.
#
#  Features: Stopping this script with Ctrl-C will stop all running mach
#  processes.
#
#  This pipeline processes multiple chromosome chunks in  parallel.  It is
#  based on a tcsh script from the University of Michican Center for
#  Statistical Genomics:
#  http://genome.sph.umich.edu/wiki/Minimac:_1000_Genomes_Imputation_Cookbook
#
#############################################################################

max_CPU=3                         # Maximum number of CPUs to use
logdir=logfiles                   # Directory for logfiles
chr_list=($(seq 1 22) 'X' 'Y')    # List of chromosomes to process

# Function to kill all running MaCH processes
killgroup() {
  echo 'killing remaining MaCH processes...'
  kill 0
}

# If script is stopped with Ctrl-C is, kill all MaCH processes
trap killgroup SIGINT

# If logifle directory doesn't exist, create it
if [ ! -d $logfiles ]; then
  mkdir -p $logfiles
fi

# The number of running MaCH proceeses
n_procs=0  

for chr in ${chr_list[@]}; do

  # Find all the chunks for this chromosome
  chunk_list=($(ls chunk*chr${chr}.dat 2>/dev/null))

  for chunk in ${chunk_list[@]}; do

    chunk=$(basename $chunk .dat)
    log="${logdir}/mach_chr${chr}.log"

    # Run MaCH on this chunk
    mach1 -d ${chunk}.dat -p chr${chr}.ped --prefix ${chunk} \
      --rounds 20 --states 200 --phase --sample 5 2>&1 | tee $log &

    n_procs=$(( n_procs + 1 ))

    # If the number of running processes is greater than maxCPUs, wait till
    # they're finished.
    if [ $n_procs -ge $max_CPU ]; then
      echo "Waiting on $n_procs processes..."
      wait
      n_procs=0
    fi

  done

done

# Wait for the remaining processs
echo "Waiting on $n_procs processes..."
wait
