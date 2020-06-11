#!/usr/bin/env bash

# Usage: bash express-run.sh seqs abund/express/testX/expY
seqdir=$(cd $(dirname $1); pwd)/$(basename $1) # Gets full path
workdir=$2
cd $workdir

for moltype in ilocus mrna
do
  for caste in q w
  do
    for rep in {1..2}
    do
      sample=${caste}${rep}
      echo "Processing sample $sample -> $moltype ($2)"
      express $seqdir/${moltype}.fa \
              ${sample}.${moltype}.bowtie2.sam \
              -o ${sample}.${moltype}.express \
              > ${sample}.${moltype}.express.log 2>&1
    done
  done
done
