#!/bin/sh

# Define the process name
process_name=rsyslogd

# Get minimum number of threads from command line parameters
process_min_threads=$1

# Calculate number of threads for the given process name
num_threads=`ps -e -T -f | grep "${process_name}" | grep -v "grep" | wc -l`

# Restart process when thread count is less than expected
if [ ${num_threads} -lt ${process_min_threads} ]; then

    echo "Need to restart ${process_name} since current thread num ${num_threads} is less than ${process_min_threads}"

fi
