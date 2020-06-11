#!/usr/bin/env bash

function stop_process {
  PROCESS=$1

  echo "Stopping $PROCESS..."
  pkill -15 -f $PROCESS
  if [ "$(pgrep -f $PROCESS)" != "" ]; then
    sleep 1s
    pkill -2 -f $PROCESS
  fi
  if [ "$(pgrep -f $PROCESS)" != "" ]; then
    sleeps 1s
    pkill -1 -f $PROCESS
  fi
  if [ "$(pgrep -f $PROCESS)" != "" ]; then
    sleeps 1s
    pkill -9 -f $PROCESS
  fi
  if [ "$(pgrep -f $PROCESS)" != "" ]; then
    echo "Unable to stop $PROCESS"
    exit 1
  fi
  echo "Stopped $PROCESS"
}

stop_process fuseki-server
