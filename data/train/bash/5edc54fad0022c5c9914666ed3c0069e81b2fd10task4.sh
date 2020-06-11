#!/bin/bash

MIN_LENGTH_NAME=4
CPU_LIMIT=5
LOG_FILE='cpu.log'
CHECK_INTERVAL=10

process_name=$1

if [ -z $process_name ] || [ ${#process_name} -lt $MIN_LENGTH_NAME ]
then
  echo "The process name is a required parameter(must contain at least $MIN_LENGTH_NAME characters)"
  exit 1
fi

while true
do
  ps aux | grep $process_name | sed '1d' | awk '{print $2,$3,$11}' | while read line
  do
    read -a process <<< "$line"
    cpu=${process[1]}
    name=${process[2]}

    if (( ${cpu/.*} > $CPU_LIMIT ))
    then
      echo -e "$(date) - warning cpu: $cpu \t $name \t ${process[0]}" >> $LOG_FILE
    fi
  done

  sleep $CHECK_INTERVAL
done
