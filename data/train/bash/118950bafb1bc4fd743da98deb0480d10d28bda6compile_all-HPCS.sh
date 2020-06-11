#!/bin/bash

. /etc/profile.d/modules.sh

# Override all executables...
rm *.x

module purge
module load default-wilkes
module unload intel/impi cuda intel/mkl
module load intel/mkl/11.1.2.144
module load fs395/openmpi-1.8.0/intel
make -f Makefile.OMPI-INTEL clean
make -f Makefile.OMPI-INTEL


module purge
module load default-wilkes
module unload intel/impi cuda intel/mkl
module load intel/mkl/11.1.2.144
module load fs395/mvapich2-2.0rc1/intel
make -f Makefile.MV2-INTEL clean
make -f Makefile.MV2-INTEL


module purge
module load default-wilkes
module unload intel/impi cuda intel/mkl
module load intel/mkl/11.1.2.144
module load fs395/openmpi-1.8.0/intel
module load fs395/elpa/2013.11-v8/intel-openmpi
make -f Makefile.OMPI-INTEL.ELPA clean
make -f Makefile.OMPI-INTEL.ELPA


module purge
module load default-wilkes
module unload intel/impi cuda intel/mkl
module load intel/mkl/11.1.2.144
module load fs395/mvapich2-2.0rc1/intel
module load fs395/elpa/2013.11-v8/intel-mvapich
make -f Makefile.MV2-INTEL.ELPA clean
make -f Makefile.MV2-INTEL.ELPA

# Cleaning...
make -f Makefile.cleaning
