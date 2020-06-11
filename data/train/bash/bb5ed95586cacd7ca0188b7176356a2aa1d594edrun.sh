#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))

case $WORKLOAD in
test)
  MAX_CHUNK_SIZE=4
  ITERS=1
  ;;
full | basic)
  #SIZES= (default)
  MAX_CHUNK_SIZE=16777216
  ITERS=5
  ;;
*)
  echo "Unrecognized WORKLOAD '$WORKLOAD'"
  exit 1
esac

RESULTS=$PWD/results
rm -rf $RESULTS || true
mkdir -p $RESULTS

pushd $ROOT/netpipe-Java-1.0 &> /dev/null

echo '"Iteration","Time","Throughput (bps)","Bits","Bytes","Variance"' > $RESULTS/results.csv

for i in $(seq $ITERS); do
  PORT=1
  while [ $PORT -lt 1024 ]; do
    PORT=$RANDOM
  done
  echo "Using port=$PORT"
  OUT=$RESULTS/np.${i}.out

  java Netpipe TCP -r -u $MAX_CHUNK_SIZE -p $PORT &
  java Netpipe TCP -t -h localhost -o $OUT -P -u $MAX_CHUNK_SIZE -p $PORT

  awk '{$1=$1}1' OFS=',' < $OUT | sed "s/^/$i,/" >> $RESULTS/results.csv
done

popd &> /dev/null
