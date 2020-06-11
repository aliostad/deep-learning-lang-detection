#!/bin/bash

# ----------------QSUB Parameters----------------- #
#PBS -S /bin/bash
#PBS -q blacklight
#PBS -j oe
#PBS -N blastSingle
#PBS -l nodes=1:ppn=1
#PBS -t 1-9
# ----------------Load Modules-------------------- #
module load blast
module load blast+
mdoule load mblast
# ----------------Your Commands------------------- #
pwd
cd  /home/apps/mblast/mblast-1.4.2
pwd
line="$PBS_ARRAYID"
p='p'
file='/home/n-z/sadkhin2/bioinformatics_experiments/single.conf'
command=`sed -n $line$p $file `
echo $command;
$command
