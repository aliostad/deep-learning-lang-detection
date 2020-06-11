#!/usr/bin/env bash

endpoint=http://uhura.ariejan.net/api/stats

# Gather data
hostname=`hostname`
ip=`hostname -i`

cores=`cat /proc/cpuinfo | grep processor | wc -l`

mem_total=`free -m | grep ^Mem: | awk '{ print $2 }'`
mem_used=`free -m | grep ^Mem: | awk '{ print $3 }'`
mem_free=`free -m | grep ^Mem: | awk '{ print $4 }'`

uptime=`uptime -s`

load_1m=`cat /proc/loadavg | awk '{ print $1 }'`
load_5m=`cat /proc/loadavg | awk '{ print $2 }'`
load_15m=`cat /proc/loadavg | awk '{ print $3 }'`


printf '{"hostname":"%s","ip":"%s","mem_total":"%s","mem_used":"%s","mem_free":"%s","uptime":"%s","load_1m":"%s","load_5m":"%s","load_15m":"%s","cores":"%s"}\n' $hostname $ip $mem_total, $mem_used $mem_free "$uptime" $load_1m $load_5m $load_15m $cores | curl -X POST -d @- -H "Content-Type:application/json" $endpoint
