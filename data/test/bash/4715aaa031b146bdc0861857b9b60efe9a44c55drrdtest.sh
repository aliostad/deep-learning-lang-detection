#!/bin/sh

set -e

S_TIME=`perl -e "print time();"`

rrdtool create aaa.rrd --step 5 \
DS:cpu:GAUGE:30:0:100 \
RRA:AVERAGE:0.5:1:6 \
RRA:MIN:0.5:1:6 \
RRA:MAX:0.5:1:6 \

i=0
while [ ${i} -lt 6 ]
do
    LOAD=`snmpwalk -v 1 -c itskewpie localhost .1.3.6.1.4.1.2021.10.1.3.1|awk '{print $4}'`

    echo ${LOAD}
    
    rrdtool update aaa.rrd N:${LOAD}

    i=`expr ${i} + 1`
    sleep 5

done

E_TIME=`perl -e "print time();"`

rrdtool graph aaa3.png --start ${S_TIME} --end ${E_TIME} --step 5 --lower-limit 0 --upper-limit 1 DEF:load=aaa.rrd:cpu:AVERAGE LINE2:load#FF0000
