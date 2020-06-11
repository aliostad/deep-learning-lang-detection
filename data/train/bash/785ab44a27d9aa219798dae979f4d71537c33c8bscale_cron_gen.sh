
#!/bin/bash

load=`sh /root/scaledown_check.sh | grep sysload_avg | awk '{print $4}'`
mem=`sh /root/scaledown_check.sh | grep percent_memory_used | awk '{print $4}'`

if awk -v ld=$load 'BEGIN {exit !(ld < 2)}' && awk -v mem=$mem 'BEGIN {exit !(mem < 30)}'
then
	echo `date` "Autoscale load check: Scaling DOWN by 1 server!"
        curl -X POST URLME 2> /dev/null
else
        echo `date` "Autoscale load check: Not ready for scale down"
fi

echo "  Average sysload = $load"
echo "  Average memory use = $mem %"
