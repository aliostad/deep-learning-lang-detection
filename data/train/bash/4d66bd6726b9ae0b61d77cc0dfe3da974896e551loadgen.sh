#!/bin/sh


HADOOP=$HADOOP_COMMON_HOME/bin/hadoop

echo "\n\n** About to run org.apache.hadoop.fs.loadGenerator.StructureGenerator"
$HADOOP org.apache.hadoop.fs.loadGenerator.StructureGenerator -outDir /tmp/ -maxDepth 1 -maxWidth 2

echo "\n\n** About to run org.apache.hadoop.fs.loadGenerator.DataGenerator"
$HADOOP org.apache.hadoop.fs.loadGenerator.DataGenerator -inDir /tmp/

echo "\n\n** About to run org.apache.hadoop.fs.loadGenerator.LoadGenerator"
$HADOOP org.apache.hadoop.fs.loadGenerator.LoadGenerator -numOfThreads 20 -elapsedTime 10 -startTime 1
