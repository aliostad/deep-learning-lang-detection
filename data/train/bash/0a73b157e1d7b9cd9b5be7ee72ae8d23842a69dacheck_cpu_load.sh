#!/bin/bash

# number of cores assigned to the pilot
pilot_cores=$1

/usr/bin/uptime
#cpu load of last minute
cpu_load=`/usr/bin/uptime | awk '{print $10}' | sed 's/,/ /g'`

#number of cpus
grep -c ^processor /proc/cpuinfo
cpus=`grep -c ^processor /proc/cpuinfo` 


if [[ $(echo "$cpu_load >= $cpus" | bc) -eq 1 ]]; then
	echo "${ERROR_CPU_LOAD_MSG}, cpus: ${cpus}, cpu_load: ${cpu_load}"
	exit $ERROR_CPU_LOAD
elif [[ $(echo "$(echo $cpu_load + $pilot_cores | bc) >= $cpus" | bc) -eq 1 ]]; then
	echo "warning"
else
	exit 0
fi