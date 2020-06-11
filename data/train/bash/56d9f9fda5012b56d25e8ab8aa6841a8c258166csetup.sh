#!/bin/bash

# Uses curl to set up test data on a local ElasticSearch instance.

BASE="http://localhost:9200"

echo -e "Setting up the test index"

for i in `seq 1 20`;
do
  curl -s -XPUT "$BASE/elasticsearch-test-scroll-stream/test-type/$i" -d '
    {"name": "first chunk name", "other": "first other data"}
  '
done

for i in `seq 21 40`;
do
  curl -s -XPUT "$BASE/elasticsearch-test-scroll-stream/test-type/$i" -d '
    {"name": "second chunk name", "other": "second other data"}
  '
done

for i in `seq 41 60`;
do
  curl -s -XPUT "$BASE/elasticsearch-test-scroll-stream/test-type/$i" -d '
    {"name": "third chunk name", "other": "third other data"}
  '
done
