#!/bin/bash

step=$1
search=$2

num_sample=0
total_time=0

echo "grep $step $search"

grep "$step" $search | ( while read line; do
  time_tmp=`echo $line | awk '{print $3}'`
  echo "time_tmp: $time_tmp"

  if [ $time_tmp -gt 10 ]; then
    time_total=`expr $time_total + $time_tmp`
    num_sample=$(( $num_sample + 1 ))
    echo $num_sample
  fi

done

echo ""
echo "$step time_total: `expr $time_total / 60` min."
echo "$step num_sample: $num_sample"
echo "$step average time: `expr $time_total / $num_sample / 60` min.")
