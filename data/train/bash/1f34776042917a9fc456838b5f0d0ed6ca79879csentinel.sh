#!/bin/bash

NODE_INVOKE="node server.js"
REPORTGEN_INVOKE="pypy report_gen.py"
#BCFEED_INVOKE="python bcfeed_sync.py -d ; ./clean.sh ; python bcfeed.py"
USERNAME="trader"
ME=`whoami`
LASTPRICE=0
LASTPRICECOUNT=0

as_user() {
   if [ $ME == $USERNAME ] ; then
      bash -c '$1'
   else
      su - $USERNAME -c '$1'
   fi
}

while true; do
	if [ `ps auxwww | grep server.js | grep -v grep | wc -l` -lt 1 ]
	then
		screen -S node -X eval "stuff '$NODE_INVOKE'\015 "
	else
		echo `date` + "  node server.js alive"
	fi
	if [ `ps auxwww | grep report_gen.py | grep -v grep | wc -l` -lt 1 ]
	then
		screen -S reportgen -X eval "stuff '$REPORTGEN_INVOKE'\015 "
	else
		echo `date` + " report_gen.py alive"
	fi
	
#	
#Removing this section till I get it working appropriately.	
#
#	if [ `cat /home/trader/config/ga-bitbot/datafeed/bcfeed_mtgoxUSD_1min.csv | wc -l` -eq $LASTPRICE ]
#	then
#		let LASTPRICECOUNT=LASTPRICECOUNT+1
#		if [ $LASTPRICECOUNT -gt 60 ]
#		then
#			kill `ps aux | grep bcfeed.py | grep -v grep | awk {'print $2'}`
#			screen -s bcfeed -X eval "stuff '$BCFEED_INVOKE'\015 "
#			let LASTPRICECOUNT=0
#		fi
#	else
#		let LASTPRICE=`cat /home/trader/config/ga-bitbot/datafeed/bcfeed_mtgoxUSD_1min.csv | wc -l`
#		let LASTPRICECOUNT=0
#	fi

sleep 10
done
