#!/bin/bash
 
# Set this hostname
HOSTNAME=`hostname --short`
 
# Set Graphite host
GRAPHITE=localhost
GRAPHITE_PORT=2003
 
# Loop forever
while :
do
    # Get epoch
    DATE=`date +%s`
 
    # Collect some random data for
    # this example
    LOAD_1MIN=$(cat /proc/loadavg | cut -d' ' -f1)
    LOAD_5MIN=$(cat /proc/loadavg | cut -d' ' -f2)
    LOAD_15MIN=$(cat /proc/loadavg | cut -d' ' -f3)
 
    # Send data to Graphite
    echo "stats.${HOSTNAME}.load.1min ${LOAD_1MIN} ${DATE}" | nc $GRAPHITE $GRAPHITE_PORT
    echo "stats.${HOSTNAME}.load.5min ${LOAD_5MIN} ${DATE}" | nc $GRAPHITE $GRAPHITE_PORT
    echo "stats.${HOSTNAME}.load.15min ${LOAD_15MIN} ${DATE}" | nc $GRAPHITE $GRAPHITE_PORT
 
    sleep 10
done
