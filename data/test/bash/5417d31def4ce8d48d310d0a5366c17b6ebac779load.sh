#!/bin/bash

EMAIL=""
CORES=`grep processor /proc/cpuinfo | wc -l`
LOAD=`uptime | sed -e "s/average:/\n/g" | grep -v load`
LOAD_1MIN=`echo -n $LOAD | awk -F, '{print $1}'`
LOAD_5MIN=`echo -n $LOAD | awk -F, '{print $2}'`
LOAD_15MIN=`echo -n $LOAD | awk -F, '{print $3}'`

if [[ ${LOAD_5MIN%.*} -gt $CORES ]]; then

  echo "Subject: $HOSTNAME 5 minute load avg. exceeds threshold" > /tmp/alert.txt
  echo "To: $EMAIL" >> /tmp/alert.txt
  echo "From: $EMAIL" >> /tmp/alert.txt
  echo "cpu cores: $CORES" >> /tmp/alert.txt
  echo "load average: $LOAD_1MIN, $LOAD_5MIN, $LOAD_15MIN" >> /tmp/alert.txt

  /usr/sbin/sendmail $EMAIL < /tmp/alert.txt

  /bin/rm -f /tmp/alert.txt

fi

