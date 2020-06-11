#!/bin/bash

GENERATOR=./generate
SAMPLE_PATH=`cd $(dirname $0) && pwd`/benchmark
SAMPLE_SIZE=$1
HOST=localhost:9200
INDEX=wat-$RANDOM
TYPE=taco
PARENT=beans

if [ -z "$SAMPLE_SIZE" ]; then
  echo "Usage: $0 <sample-size>"
  exit 1
fi

function reset() {
  curl -s -o /dev/null -XDELETE $HOST/$INDEX
  curl -s -o /dev/null -XPUT $HOST/$INDEX -d"{
    mappings : {
      $PARENT: {},
      $TYPE: {
        _parent: {
          type: \"$PARENT\"
        },
        _timestamp: {
          enabled: true,
          path: \"created_at\"
        }
      }
    }
  }"
  curl -s -o /dev/null -XPUT $HOST/$INDEX/_settings -d'{
    "index" : {
      "refresh_interval" : -1
    }
  }'
}

function makeSample() {
  local TOTAL_SIZE=$(($SAMPLE_SIZE * 10))
  mkdir -p $SAMPLE_PATH
  echo "Generating $TOTAL_SIZE entries"
  $GENERATOR $TOTAL_SIZE > $SAMPLE_PATH/sample.tsv
}

function splitSample() {
  rm -rf $SAMPLE_PATH/sample
  mkdir -p $SAMPLE_PATH/sample
  split -a 10 -l $SAMPLE_SIZE $SAMPLE_PATH/sample.tsv $SAMPLE_PATH/sample/part-
}

function convertAndUpload() {
  for file in $SAMPLE_PATH/sample/part-*
  do
    cat $file | ./convert $INDEX $TYPE | time curl -o /dev/null -s -XPOST $HOST/_bulk --data-binary @-
  done
  curl -s -o /dev/null -XPUT $HOST/$INDEX/_settings -d'{
    "index" : {
      "refresh_interval" : "1s"
    }
  }'
  curl -o /dev/null -s -XPOST $HOST/$INDEX/_refresh
  echo "       ----------         ---------         --------"
}

reset
makeSample
splitSample
convertAndUpload
