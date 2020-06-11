#!/bin/bash

for PROCESS in u1u1 u2u2 u1u2 d1d1 d2d2 d1d2 u1d1 u2d2 u1d2 u2d1\
               d1s1 d2s2 d1s2 d2s1 u1c1 u2c2 u1c2 u2c1 u1s1 u2s2 u1s2 u2s1; do

sed -e s/PROCESS/$PROCESS/ -e s/histo/${PROCESS}_SPS1_14TeV/ input.dat > input_${PROCESS}_SPS1_14TeV.dat

echo "Requirements = ((Arch == \"INTEL\") || (Arch == \"X86_64\")) && (Pool == \"Theory\")

notification = Error

Universe   = vanilla
Executable = run 
Arguments  = input_${PROCESS}_SPS1_14TeV.dat
Output     = results/${PROCESS}_SPS1_14TeV.out
Queue" > submit_${PROCESS}_SPS1_14TeV

condor_submit submit_${PROCESS}_SPS1_14TeV
done