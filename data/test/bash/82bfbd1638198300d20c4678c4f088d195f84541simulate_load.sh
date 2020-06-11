#!/bin/bash
script_name=$(basename $0)
description="This program adds simulated load on the server. 
Syntax: $script_name [<loadavg>]
Simply run the script on it's own or pass in the load you want to add.
You can cancel the load simulations by running [ killall -v $script_name ]"

[ ! -z "$1" ] && loop=$1 || loop=2

getload(){ top -b -n1 | grep 'load average:' | sed -e 's/.*average: //'; }

load=$loop
echo "########################################################################"
echo "$description"
echo "########################################################################"
echo "Load Avg is: $(getload)"
echo "Increasing Load Avg by: $load"
echo "########################################################################"

while [ $loop -ge 0 ]; do
  let loop=$loop-1
  let count=$load-$loop
  [ $loop -ge 0 ] && {
    echo "\_Spawning child $count"
    while true; do : ; done &
  }
done
while true; do
  getload
  sleep 5
done
