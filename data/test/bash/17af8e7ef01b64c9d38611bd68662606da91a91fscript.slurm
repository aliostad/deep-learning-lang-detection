#!/bin/sh
#SBATCH -n 16           # 16 cores
#SBATCH -t 03:00:00   # 3 hrs
#SBATCH -p compute      # partition name
#SBATCH -J graphene_test  # sensible name for the job

# [optional] specify a project name - it will use your default
# (i.e. your most recent project) if you leave this blank

#SBATCH -U XXXXXXXXXXXX# optional project name

# load up the correct modules, if required
module load dot
module load libs
module load apps
module load intel/14.0/composer_xe_2013_sp1.2.144
module load intel/14.0/impi-4.1.3.048
module load HDF5/intel/14.0/1.8.13
module load netcdf/intel/14.0/4.3.2
module load SIESTA/intel/14.0/3.2-pl-5

# launch the code
mpirun siesta < graphene.fdf > graphene.out

