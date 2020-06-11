#!/bin/sh

#
# MRTG Server Load Average Graph
# 
#########################


#### Sample /etc/mrtg.cfg usage

#  Target[server-cpu]: `scripts/mrtg-loadavg.sh`
#  MaxBytes[server-cpu]: 500
#  Title[server-cpu]: server CPU Load (5 minute average)
#  YLegend[server-cpu]: Load*100
#  ShortLegend[server-cpu]: load
#  Legend1[server-cpu]: CPU Load (x 100)
#  Legend2[server-cpu]:
#  LegendI[server-cpu]: 1min load
#  LegendO[server-cpu]: 5min load
#  PageTop[server-cpu]: server 5-minute average CPU Load
#  Options[server-cpu]: gauge,nopercent,integer,growright

awk </proc/loadavg '{print (100*$1) "\n" (100*$2) }'
hostname;
echo "loadavg";