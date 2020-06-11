#!/bin/bash
#
# Use "GnuPlot" to show all data.
#
logfile=$1
if [[ ${logfile} == "" ]] ; then
    echo "Usage: logfile timezone"
    exit 1
fi

timezone=$2
if [[ ${timezone} == "" ]] ; then
    # extract timezone from logfile
    timezone=`tail -10 ${logfile} | grep Invoke | sed "s:  : :g" | cut -d " " -f16 | tail -1`
    echo "Setting timezone to $timezone found from ${logfile}"
fi

secondaryPattern=$3
#
# Find the list of unique entries in log file.
#
for names in `tail -500 ${logfile} | grep Invoke_HTTP_Get | cut -d " " -f8 | sed "s%http://ntnu-test.%%g" | sed "s%:8090/token/ReceiveToken%%g" | sort | uniq`
do
echo Plotting ${names}
./Generate_plot.sh ${logfile} ${names} ${timezone} ${secondaryPattern}
done