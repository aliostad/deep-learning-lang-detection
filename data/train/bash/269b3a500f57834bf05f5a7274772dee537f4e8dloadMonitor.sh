#!/bin/bash
load=0
ceil="4.00"
flag=1

echo "monitor start>>>>>>>>>>>>>>>" > ~/load/load.log

while  [ true ]
do

        load=`uptime|awk -F ' ' '{print $11}'`
        load=${load%,}
        echo "`date` load=$load"  >> ~/load/load.log

        result=`echo "$load > $ceil"|bc`

        if [ "$result" -eq 1 ] ; then
                uptime >> ~/load/load.log

                pid=`jps -l|awk '/jetty/ {print $1}'`

                jstackfilename="$pid.jstack.$flag"
                echo "$jstackfilename"  >> ~/load/load.log

                jstack "$pid" > "$jstackfilename"
                vmstat 1 10 > ~/load/vmstat.log
                ps aux|awk '$8 ~ /R/' >> ~/load/load.log
                ps aux|awk '$8 ~ /R/' >> ~/load/load.log
                ps aux|awk '$8 ~ /R/' >> ~/load/load.log

                ((flag++))
        fi

sleep 1

done
