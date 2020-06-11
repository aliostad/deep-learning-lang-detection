#!/bin/bash

MIN_NATIVE_GROUP_SIZE=64
MAX_NATIVE_GROUP_SIZE=256

NUM_COMPUTE_UNITS=24

if (( $# < 1 )); then
	echo "ERROR: Missing required argument"
	echo "Usage bandwidth.sh <result_file_prefix>"
	exit -1
fi

RESULT_PREFIX=$1

./bandwidth --threads=$MIN_NATIVE_GROUP_SIZE | grep -v '^\[' > "$RESULT_PREFIX.sweepgroups.minthreads.float.chunk.dat"
./bandwidth --threads=$MAX_NATIVE_GROUP_SIZE | grep -v '^\[' > "$RESULT_PREFIX.sweepgroups.maxthreads.float.chunk.dat"

./bandwidth --threads=$MIN_NATIVE_GROUP_SIZE --su3 | grep -v '^\[' > "$RESULT_PREFIX.sweepgroups.minthreads.su3.chunk.dat"
./bandwidth --threads=$MAX_NATIVE_GROUP_SIZE --su3 | grep -v '^\[' > "$RESULT_PREFIX.sweepgroups.maxthreads.su3.chunk.dat"

./bandwidth --threads=$MIN_NATIVE_GROUP_SIZE --single | grep -v '^\[' > "$RESULT_PREFIX.sweepgroups.minthreads.float.single.dat"
./bandwidth --threads=$MAX_NATIVE_GROUP_SIZE --single | grep -v '^\[' > "$RESULT_PREFIX.sweepgroups.maxthreads.float.single.dat"

./bandwidth --threads=$MIN_NATIVE_GROUP_SIZE --su3 --single | grep -v '^\[' > "$RESULT_PREFIX.sweepgroups.minthreads.su3.single.dat"
./bandwidth --threads=$MAX_NATIVE_GROUP_SIZE --su3 --single | grep -v '^\[' > "$RESULT_PREFIX.sweepgroups.maxthreads.su3.single.dat"


./bandwidth --groups=$NUM_COMPUTE_UNITS --threads=$MAX_NATIVE_GROUP_SIZE | grep -v '^\[' > "$RESULT_PREFIX.sweepthreads.maxthreads.float.chunk.dat"
./bandwidth --groups=$NUM_COMPUTE_UNITS --threads=$MAX_NATIVE_GROUP_SIZE --su3 | grep -v '^\[' > "$RESULT_PREFIX.sweepthreads.maxthreads.su3.chunk.dat"
./bandwidth --groups=$NUM_COMPUTE_UNITS --threads=$MAX_NATIVE_GROUP_SIZE --single | grep -v '^\[' > "$RESULT_PREFIX.sweepthreads.maxthreads.float.single.dat"
./bandwidth --groups=$NUM_COMPUTE_UNITS --threads=$MAX_NATIVE_GROUP_SIZE --su3 --single | grep -v '^\[' > "$RESULT_PREFIX.sweepthreads.maxthreads.su3.single.dat"

