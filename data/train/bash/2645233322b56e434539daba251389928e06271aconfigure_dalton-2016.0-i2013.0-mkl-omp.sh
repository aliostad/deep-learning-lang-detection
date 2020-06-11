#!/usr/bin/env bash

# source me!

ver=2016.0-i2013.0-mkl-omp
dir_build="${apps}"/build/dalton_"${ver}"
dir_source="${apps}"/dalton/2016.0-source

module purge
module load python/anaconda2
module load cmake/3.3.2
module load intel/2013.0
module load mkl/2013.0/icc-mt
# module load cuda/7.0-rhel
export LOCAL=${scratch}
export PBS_O_WORKDIR=${scratch}
module load dalton/${ver}

\rm -rf "${dir_build}"
mkdir "${dir_build}"
cd "${dir_source}"

./setup \
    --prefix="${DALTON_ROOT}" \
    --cc=icc \
    --cxx=icpc \
    --fc=ifort \
    --mkl=parallel \
    --omp \
    "${dir_build}"

    # --gpu \
    # --cublas \

cd "${dir_build}"
# make all -j4
# ctest -j4
# make install
