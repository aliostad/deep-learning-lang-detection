#!/bin/sh

RRD=cpu.rrd

if  [ ! -e $RRD ] ;
then
    echo Creating database...
    rrdtool create $RRD \
        --step 300 \
        --start 0 \
        DS:load:GAUGE:600:U:U \
        RRA:AVERAGE:0.5:1:600 \
        RRA:AVERAGE:0.5:6:700 \
        RRA:AVERAGE:0.5:24:775 \
        RRA:AVERAGE:0.5:288:797 \
        RRA:MAX:0.5:1:600 \
        RRA:MAX:0.5:6:700 \
        RRA:MAX:0.5:24:775 \
        RRA:MAX:0.5:444:797
fi

load=`uptime|awk '{print $10}'|sed -e 's/,//'`

rrdtool update $RRD N:$load

CTID=$(echo $RRD | sed 's/.rrd$//')

# list of intervals, 1d = last day, 1w = last week and so on
for INT in 1h 1d 1w 1m 1y
do
    /usr/bin/rrdtool graph images/${CTID}-${INT}.png \
        --start now-$INT --end now \
        --upper-limit 2.5 --lower-limit 0 \
        -w 650 -h 250 \
        --title "5 Min Load Ave - Interval $INT" \
        --color CANVAS#555555 \
        --color BACK#555555 \
        --color FONT#ffffff \
        --border 0 \
        DEF:load=$RRD:load:AVERAGE \
        AREA:load#0081EB:"CPU Load 5 min ave" \
        VDEF:load_max=load,MAXIMUM \
        VDEF:load_ave=load,AVERAGE \
        GPRINT:load_max:"max\: %.02lf" \
        GPRINT:load_ave:"ave\: %.02lf" 
done
