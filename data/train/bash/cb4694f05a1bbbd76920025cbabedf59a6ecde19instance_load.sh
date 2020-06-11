#!/bin/sh

IPERF=192.155.236.234

# CPU load equal to 50% will be generated till instance termination
cpulimit -l 50 --  gzip -9 < /dev/urandom > /dev/null
sleep 1s
cpu_load=$(ps -aux | awk '/gzip/{print $3}' | head -n 1)

# Network load equal to 1 Mbit/sec will be generated for 10 minutes (-t 600 parameter). Change this value to which you need.
# Use IP-address of your external iperf server here
net_load=$(iperf -c ${IPERF}  -b 1M -t 600 -i 2 2>&1 | sed -n '9p;9q' | awk '{print $8}' &)

echo "{
    \"cpu_load\": $cpu_load,
    \"net_load\": $net_load
    }"
