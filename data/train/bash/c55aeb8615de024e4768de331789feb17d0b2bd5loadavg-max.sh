#!/bin/bash

########################################
# Author: Namgon Kim (day10000@gmail.com)
# Date: 2015.10.06
# Desc: print max load average during runtime
########################################

usage() {
  echo "Usage: $0"
  echo "   ex)$0"
  exit 1
}

MAX_LOAD="0.0"
while [ 1 ]; do
  STR_NOW=`date '+%Y-%m-%d %H:%M:%S'`
  LOAD_AVG=`cat /proc/loadavg`
  CUR_LOAD=`echo $LOAD_AVG | awk '{print $1}'`
  CMP=`echo $CUR_LOAD '>' $MAX_LOAD | bc -l`
  if [ $CMP -eq 1 ]; then
    MAX_LOAD=$CUR_LOAD
  fi
  printf "%-10s %-10s load= %10.2f max_load= %10.2f\n" $STR_NOW $CUR_LOAD $MAX_LOAD
  sleep 1
done
