#!/bin/bash

. job_settings.sh

TC=$(printf "%03d" $1)
BATCH_N=$2
LOG=log/smrtpipe.log

echo "TC = ${TC}"
echo "BATCH_N = ${BATCH_N}"

mkdir -p succeed_${BATCH_N}/
mkdir -p fofns_${BATCH_N}/

## TODO: specify cold run option to check sanity
if [[ $COLD_RUN ]]; then
  echo "cold run."
  exit
fi

while true; do

sleep 300
  
# list the chunks which have passed the alignment step
cat ${LOG} | grep P_Mapping | grep align | grep -v Scatter | grep successfully \
| sed "s/.*align_//; s/of${TC}.*//" > .tmp

while read line; do
  if [ ! -e fofns_${BATCH_N}/input.chunk${line}of${TC}.fofn ]; then

    echo "Chunk done: $line"
    cp data/aligned_reads.chunk${line}of${TC}.cmp.h5 succeed_${BATCH_N}/
    cp ./input.chunk${line}of${TC}.fofn fofns_${BATCH_N}/

    movie=$( cat fofns_${BATCH_N}/input.chunk${line}of${TC}.fofn )
    movie=${movie%%.bax.h5}
    movie=${movie##*/}
    echo "Chunk $line - $movie"
    mv succeed_${BATCH_N}/aligned_reads.chunk${line}of${TC}.cmp.h5 succeed_${BATCH_N}/${movie}.cmp.h5
  fi
done < .tmp

# TODO: should terminate if SMRT Pipe is down


done
