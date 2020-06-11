#!/bin/bash

#module swap PrgEnv-cray/4.2.24 PrgEnv-gnu/4.2.24
. /opt/modules/3.2.6.7/init/bash

# unload all the modules
module purge

# load all the default Cray stack tools
# if only the minimal set of modules is loaded, MPICH throws this one:
# Assertion failed in file /notbackedup/tmp/ulib/mpt/nightly/6.0/081313/mpich2/src/mpi/datatype/get_count.c at line 34: size >= 0 && status->count >= 0

# for job submission
module load modules/3.2.6.7
module load moab/6.1.1
module load torque/2.5.7

# stuff to build app
module load PrgEnv-gnu/4.2.24
module load cray-mpich/6.0.2
module load ugni/5.0-1.0402.7128.7.6.gem
module load xpmem/0.1-2.0402.44035.2.1.gem
module load udreg/2.3.2-1.0402.7311.2.1.gem

make clean

# pick up the variable from the environment
make CC=cc -j 4 applications/argonnite_kmer_counter/argonnite CONFIG_DEBUG=$BUILD_DEBUG \
        applications/spate_metagenome_assembler/spate \
        performance/latency_probe/latency_probe
