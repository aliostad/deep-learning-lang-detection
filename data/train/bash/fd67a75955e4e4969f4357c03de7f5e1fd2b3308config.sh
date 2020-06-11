#!/bin/bash

export SMRT_ROOT=/net/eichler/vol20/projects/pacbio/opt/smrtanalysis

. /etc/profile.d/modules.sh
if test ! -z $MODULESHOME; then
   module purge
   module load modules modules-init modules-gs/prod modules-eichler/prod
fi

unset PYTHONPATH
module unload python
module load python/2.7.2
module load perl/5.14.2
module load cross_match/latest
module load bedtools/latest
module unload R
module load R/2.15.0

export MAKEDIR=/net/eichler/vol4/home/jlhudd/projects/pacbio/smrtanalysis-2.2.0
export VECTOR=${MAKEDIR}/vector.fasta

. $("$SMRT_ROOT/admin/bin/getsetupfile")
