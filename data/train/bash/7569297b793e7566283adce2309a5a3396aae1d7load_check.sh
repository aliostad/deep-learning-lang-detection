#!/bin/bash
echo $$ > /dianyi/app/ypp1.0/shell/run/load_check.pid
while [ true ]
do
    uptime | awk '{print int(substr($10, 0, length($10) - 1))}' > load/load.txt
    
    LOAD=`paste load/load.txt`
    
    if [ $LOAD -ge 20 ]
    then
        sh loghandle.sh stop
        
        ps aux | grep "accesslog" | cut -c 9-15 | xargs kill -9
        ps aux | grep "weblog" | cut -c 9-15 | xargs kill -9
        ps aux | grep "monitoralarm" | cut -c 9-15 | xargs kill -9
        
        break
    fi
    
    sleep 2
done
