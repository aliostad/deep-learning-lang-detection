#!/bin/bash

export REFFILE=$1 
export SAMPLE=$2
export OUTPUT=$3
export CPU=$4


if [ ! -n "${CPU}" ]; then
  export CPU=2
fi

if [ ! -r "${REFFILE}" ]; then
  echo "Error: reference file (${REFFILE}) does not exist."
  exit 1
fi

if [ ! -r "${SAMPLE}" ]; then
  echo "Error: reference file (${SAMPLE}) does not exist."
  exit 1
fi


export TIMESTAMP=`date +%s`


# cd /sample
# cufflinks -g /gtf/${REFFILE} -p ${CPU} -o denovo-cufflinks-${TIMESTAMP} ${SAMPLE}
stringtie ${SAMPLE} -p ${CPU} -G ${REFFILE} -o ${OUTPUT}

