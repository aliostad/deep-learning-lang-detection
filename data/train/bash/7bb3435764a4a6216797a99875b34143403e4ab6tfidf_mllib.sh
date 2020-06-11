#!/bin/bash
export JAVA_HOME='/opt/jdk1.7.0_71/'
export HADOOP_HOME='/opt/hadoop-2.6.0'
input=$1
mahout="/opt/mahout-distribution-0.10.0/bin/mahout"
hadoop="/opt/hadoop-2.6.0/bin/hadoop"
hdfs="/opt/hadoop-2.6.0/bin/hdfs"


xmdummy="-xm sequential"
chunk=1

seqfiles="sequence_files1"
${hdfs} dfs -rmr $seqfiles
#remove any previous files
${hdfs} dfs -rm $output/* 2>/dev/null | wc -l | echo [PREP] Deleted $(cat) old sequence files

${mahout} seqdirectory -i $input -o $seqfiles -c UTF-8 -chunk $chunk $xmdummy -ow 


command="/opt/spark-1.3.1-bin-hadoop2.6/bin/spark-submit --master spark://192.168.5.134:7077 /opt/spark_tfidf.py -i sequence_files1 -o $2 -mdf $3"
echo $command

ssh slave1 "$command"
