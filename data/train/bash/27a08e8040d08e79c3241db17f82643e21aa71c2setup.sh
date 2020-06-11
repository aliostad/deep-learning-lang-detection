#! /bin/sh
module unload compilers mpi mkl
module load compilers/gnu/4.6.3
module load hdf/5-1.8.7/gnu.4.6.3
module load curl/7.21.3/gnu.4.6.3
module load netcdf/4.2.1.1/gnu.4.6.3
module load netcdf-cxx/4.2/gnu.4.6.3
module load mpi/openmpi/1.6.5/gnu.4.6.3
module load python/enthought/7.3-2_2013-10-04
module load boost/1.54.0/openmpi/gnu.4.6.3
module unload compilers
module load compilers/gnu/4.9.2

# set paths
export LD_LIBRARY_PATH=/shared/ucl/apps/repast-hpc/2.2-dev/lib:$LD_LIBRARY_PATH
#export PATH=/shared/ucl/apps/repast-hpc/2.2-dev/bin:$PATH
module list

# go somewhere in Scratch
# cd Scratch/repast
