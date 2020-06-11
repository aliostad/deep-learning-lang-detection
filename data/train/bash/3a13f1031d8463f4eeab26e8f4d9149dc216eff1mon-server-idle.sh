#!/bin/bash

# Receives 2 parameters
# 1. SERVER_NAME
#    The name of the server been monitored
# 2. MIN_LOAD
#    Reference value of server load in the last 15 minutes in whitch been 
#    bellow the server will be considered idle.

# Remote load average path

# Must be passed 2 arguments, first cannot be empty and second < 20
SERVER_NAME=$1
MIN_LOAD=$2

# path for the "./remote_load_average"
REMOTE_LOAD="./remote_load_average"

if [[ -z $SERVER_NAME || -z $MIN_LOAD || $MIN_LOAD -gt 19 ]];
then
        echo "USAGE: $0 <server name> <min load>"
        echo -e "\tserver name must not be empty"
        echo -e "\tmin load must be lesser than 20"
        exit 1
fi

# Check if the script exists and is executable
if [[ -a $REMOTE_LOAD ]];
then
        echo "Found" > /dev/null
else
        echo "File does not exist"
        exit 1
fi


# Enter in a loop forever
while true
do
        # Get last 15 minutes load average
        LOAD_AVERAGE=$(bash ./remote_load_average | grep L15M)

        # Get average value
        LOAD_VAL=$(echo $LOAD_AVERAGE | cut -d: -f 2 | sed 's/ //')

        # If average load is greater than MIN_LOAD server is idle
        # return error 11
        if [[ $LOAD_VAL -gt $MIN_LOAD ]];
        then
                exit 11;
        fi
        sleep 4
done
# Never reaches this point
