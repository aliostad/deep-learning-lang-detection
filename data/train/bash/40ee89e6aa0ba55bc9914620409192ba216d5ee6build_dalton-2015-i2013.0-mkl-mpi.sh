#!/usr/bin/env bash

ver=2015-i2013.0-mkl-mpi

module purge
module load python/anaconda
module load cmake/2.8.11.2
module load intel/2013.0
module load openmpi/1.6.3-intel13
module load mkl/2013.0/icc-mt
module load boost/1.55.0-gcc45
export LOCAL=$scratch
module load dalton/${ver}

cd ${apps}/dalton/2015-source

rm -r ${apps}/build/dalton_${ver}

./setup \
    --prefix=${DALTON_ROOT} \
    --fc=mpif90 \
    --cc=mpicc \
    --cxx=mpicxx \
    --mkl=sequential \
    --mpi \
    ${apps}/build/dalton_${ver}

cd ${apps}/build/dalton_${ver}
make all -j2
make install
