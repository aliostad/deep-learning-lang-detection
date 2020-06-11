#!/bin/bash

. ~/.profile

EXE_PATH=$1
PROCESS=$2

SHELL=/bin/bash

function find_process() {
   pid=`ps aux | grep uwsgi | grep -v 'grep' | grep -v shell | awk '{{printf"%s ",$2}}'`
   echo pid==$pid
}

if [ $# != 2 ] ; then
   echo "Error: No arguments!"
   echo "Usage: restart.sh exe_path process_name"
   echo "    Example:"
   echo "    restart.sh /home/.../Eco uwsgi"
   echo ""
   exit 1
fi

find_process

if [ -n "$pid" ]; then
{
   echo ===========shutdown $PROCESS ================
   $SHELL ${EXE_PATH}/WebService/stop.sh
   sleep 3
   pid=`find_process` 
   if [ -n "$pid" ]
   then
    {
      sleep 2
      echo ========kill $PROCESS ============== 
      killall -s 9 $PROCESS
    }
   fi
   sleep 2
}
fi

echo ===========startup $PROCESS ==============
$SHELL ${EXE_PATH}/WebService/start.sh

find_process

if [ -n "$pid" ]; then
   echo "[done]"
else
   echo "[failed]"
fi

echo exit...
exit
