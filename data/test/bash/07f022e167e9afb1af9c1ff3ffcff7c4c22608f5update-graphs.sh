#! /bin/bash
# The test file name should be given as an argument.
SELF_DIR=$(dirname $0)
PROJECT_ROOT=${PWD}/${SELF_DIR}/../

clang++ -std=c++11 -c -emit-llvm $1 -o $1.bc

opt -mem2reg $1.bc -o $1.ssa.bc

opt -load ${PROJECT_ROOT}/build/pass/libdswp.so -dot-cfg $1.ssa.bc
opt -load ${PROJECT_ROOT}/build/pass/libdswp.so -dot-ddg $1.ssa.bc
opt -load ${PROJECT_ROOT}/build/pass/libdswp.so -dot-mdg $1.ssa.bc
opt -load ${PROJECT_ROOT}/build/pass/libdswp.so -dot-cdg $1.ssa.bc
opt -load ${PROJECT_ROOT}/build/pass/libdswp.so -dot-pdg $1.ssa.bc
opt -load ${PROJECT_ROOT}/build/pass/libdswp.so -dot-psg $1.ssa.bc
