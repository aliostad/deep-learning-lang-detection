#!/bin/bash

# check the usage of the script
if [ $# == 0 ]; then
  echo ""
  echo "   Usage: $0 [ process_name ] "
  echo "   This script should be run as root. "
  echo "   It puts the computer to sleep once the monitored process terminates"
  echo ""
  exit
fi

# get the process name from user
PROCESS_NAME=$1
SLEEP_SEC=300

if [ "`ps -ef | grep -i $PROCESS_NAME | grep -v grep | grep -v $0`" == "" ]; then
  echo ""
  echo "  Process name $PROCESS_NAME does not exist. script exiting"
  echo ""
  exit
fi


while true; do
  PID_LIST=`ps -ef | grep -i $PROCESS_NAME | grep -v grep | grep -v $0`

  if [ "$PID_LIST" == "" ]; then
     echo ""
     echo "  Process $PROCESS_NAME no longer exist. Script exiting..."
     echo ""
     break
  fi

  echo "  Sleeping for $SLEEP_SEC ..."
  sleep $SLEEP_SEC
done

echo ""
echo "  Process with name $PROCESS_NAME is no longer running."
echo ""

/usr/local/bin/mysleep
