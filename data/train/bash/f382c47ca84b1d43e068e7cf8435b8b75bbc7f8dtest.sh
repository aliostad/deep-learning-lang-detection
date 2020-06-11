#!/bin/bash
 
# Set this hostname
HOSTNAME=`hostname`
 
# Set Graphite host
GRAPHITE=`boot2docker ip`
GRAPHITE_PORT=2003
 
# Loop forever
while :
do
    # Get epoch
    DATE=`date +%s`
 
    # Collect some random data for
    # this example
    LOAD_1MIN=$RANDOM
    LOAD_5MIN=$RANDOM
    LOAD_15MIN=$RANDOM
    echo "nc $GRAPHITE $GRAPHITE_PORT"
		echo "stats.$HOSTNAME.load.1min $LOAD_1MIN $DATE"
    # Send data to Graphite
    echo "stats.${HOSTNAME}.load.1min ${LOAD_1MIN} ${DATE}" | nc $GRAPHITE $GRAPHITE_PORT
    echo "stats.${HOSTNAME}.load.5min ${LOAD_5MIN} ${DATE}" | nc $GRAPHITE $GRAPHITE_PORT
    echo "stats.${HOSTNAME}.load.15min ${LOAD_15MIN} ${DATE}" | nc $GRAPHITE $GRAPHITE_PORT
 
    sleep .10
done
