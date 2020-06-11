#!/usr/bin/env bash

if [ ! -f /etc/process-stalker.conf ]; then
    echo "No /etc/process-stalker.conf found"
    exit 1
fi

touch "/var/log/process-stalker.log"
input="/etc/process-stalker.conf"

if [ ! -f "/var/log/process-stalker.log" ]; then
    echo "No log file created"
    exit 1
fi

while true
do
    while IFS= read -r process
    do
      if [ `ps aux | grep -v grep | grep ${process} | wc -l` -eq 0 ]; then
           echo "${process} is not currently running" `date +"%r %a %d %h %y"` >> "/var/log/process-stalker.log"
           service ${process} start
      fi
    done < "$input"

    sleep 2m
done
