#!/bin/bash

get_max() {
  local L_VAL=$1
  local R_VAL=$2
  local RET=$3

  local MAX=0
  if [ $(echo "$R_VAL==-1" | bc -l) -eq "1" ]; then 
    MAX=0
  elif [ $(echo "$R_VAL<$L_VAL" | bc -l) -eq "1" ]; then 
    MAX=$L_VAL
  else
    MAX=$R_VAL
  fi
 
  eval "$RET=$MAX" 
}

get_load_avg() {
  STR=`cat /proc/loadavg`
 
  echo $STR | awk '{print $1}' 
}

#### Colors
blue=$(/usr/bin/tput setaf 4)
green=$(/usr/bin/tput setaf 2)
normal=$(/usr/bin/tput sgr0)

MAX_LOAD_AVG=-1

main_loop() {
  printf "%15s %15s\n" "LOAD_AVG"  "MAX_LOAD_AVG"
  printf "%s\n" "---------------------------------"
  while true; do
    _CUR_LOAD=`get_load_avg`
    get_max $_CUR_LOAD $MAX_LOAD_AVG MAX_LOAD_AVG
    printf "%15s %15s\n" $_CUR_LOAD $MAX_LOAD_AVG
    sleep 1
  done
}

main_loop
