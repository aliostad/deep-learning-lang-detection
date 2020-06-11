#!/bin/bash
## 
## DESCRIPTION:   Since qsub will not use numbers as job names, rename samples to have 's' in the front
##
## USAGE:         illumina_rename_samples.sh Sample_X [Sample_Y [...]]
##
## OUTPUT:        None
##

# Load analysis config
source $NGS_ANALYSIS_CONFIG

# Usage check:
usage_min 1 $# $0

# Rename
for file in `ls Sample*/*`; do
  newfilename=`echo $file |  sed 's/\//\/S/'`;
  mv $file $newfilename
done

for dirname in `ls | grep Sample`; do
  newdirname=`echo $dirname | sed 's/Sample_/Sample_S/g'`;
  mv $dirname $newdirname
done