#!/usr/bin/env bash
process_name="watch_queue"
process_line=`ps -ef |grep $process_name | grep -v grep | grep -v vim`

if [ "$process_line" == "" ];then
	nohup /KCloud/kcloud/watch_queue.sh &
fi

process_name="watch_top"
process_line=`ps -ef |grep $process_name | grep -v grep | grep -v vim`

if [ "$process_line" == "" ];then
	nohup /KCloud/kcloud/watch_top.sh &
fi

process_name="git-daemon"
process_line=`ps -ef |grep $process_name | grep -v grep | grep -v vim`

if [ "$process_line" == "" ];then
	
	nohup git daemon --base-path=/KCloud --enable=receive-pack --reuseaddr --informative-errors --verbose --port=9418 &
fi
