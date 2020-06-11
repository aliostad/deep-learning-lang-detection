#!/bin/sh

PROCESS=`cat /data/services/bot*.pid`

if
  ps -p ${PROCESS} > /dev/null 2>&1
  echo "Attempting to stop Nu bot [PID: ${PROCESS}]."
then 
  kill -9 ${PROCESS}
  rm /data/services/bot-*.pid
  sleep 1.25
  echo "Nu bot has been stopped."
else
  echo "Warning: Nu bot does not appear to be running at the reported process identifer [PID: ${PROCESS}]. The PID file referenced may be incorrect."
  sleep 0.25
  echo "Checking to see if there is a java process running on the container..."

  PROCESS="java"
  RESULT=`pgrep ${PROCESS}`
  if 
    [ "${RESULT:-null}" = null ]; 
  then
    echo "Warning: No running java process found. No action taken."
  else
  	echo "A running java process was found on the container. Attempting to stop PID: ${RESULT}."
    kill -9 ${RESULT}
    sleep 1.25
    echo "Nu bot has been stopped."
  fi
fi


