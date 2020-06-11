#!/bin/bash
#SBATCH -N 1 
#SBATCH -n 1 
#SBATCH --time=2-00:10:00 
# SBATCH --workdir=/home/straynwang/DeepLearning_GeneData
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=straynwang@gwu.edu


# . /usr/share/Modules/init/sh
module load openmpi/1.8/gcc/4.7/cpu
module load gcc
module load slurm
module load python/2.7.6
module load tensorflow/0.10
module load git

# export OMP_NUM_THREADS=1
# echo "SLURM_NODELIST $SLURM_NODELIST"

python data2pairs-0.5.py


exit
