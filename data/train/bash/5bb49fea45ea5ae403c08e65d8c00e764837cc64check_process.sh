#!/bin/bash

CheckProcess()
{
  # verify input arg
  if [ "$1" = "" ];
  then
    return 1
  fi

  echo "checking process..."
  # if PROCESS_NUM > 0, means the process is running, return 0, else, it need to restart
  PROCESS_NUM=`ps -ef | grep "$1" | grep -v "grep" | wc -l` 
  if [ $PROCESS_NUM -eq 1 ];
  then
    echo "running properly :)"
    sleep 10
    CheckProcess "test"
  elif [ $PROCESS_NUM -eq 0 ];
  then
    echo "not running :( try to start"
    exec ./test &
    sleep 3
    CheckProcess "test"
  else
    echo "duplicated processes, clean all and restart"
    killall -9 test
    exec ./test &
    sleep 3
    CheckProcess "test"
  fi
}

CheckProcess "test"
