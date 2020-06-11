#!/bin/sh
rrdtool graph /home/andy/workspace/tmp/one-hour-one-minute-load.png --start 1445566728 --end 1445570328 DEF:load=/home/andy/workspace/tmp/cpu.load.avg.rrd:cpuloadavg:AVERAGE LINE2:load#FF0000
rrdtool graph /home/andy/workspace/tmp/one-hour-five-minute-load.png --start 1445566728 --end 1445570328 --step 300 DEF:load=/home/andy/workspace/tmp/cpu.load.avg.rrd:cpuloadavg:AVERAGE LINE2:load#FF0000
rrdtool graph /home/andy/workspace/tmp/one-hour-ten-minute-load.png --start 1445566728 --end 1445570328 --step 600 DEF:load=/home/andy/workspace/tmp/cpu.load.avg.rrd:cpuloadavg:AVERAGE LINE2:load#FF0000
