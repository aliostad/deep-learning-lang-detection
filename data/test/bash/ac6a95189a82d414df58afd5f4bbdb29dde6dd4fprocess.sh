#! /bin/bash
#
# process.sh
# Copyright (C) 2014 zhangzb <zhangzb@neunn.com>
#
# Distributed under terms of the MIT license.
#


usage()
{
    echo "add a process name"
}

if (($# == 0))
then
    usage
    exit
fi

PROCESS=$1
echo "PROCESS: $PROCESS"
echo "old pid:";ps aux | grep $PROCESS | grep -v 'grep' | grep -v 'process' | awk '{print $2}'

var=`ps aux|grep $PROCESS | grep $1 | grep -v 'grep' |grep -v 'process' |wc -l`
echo "PROCESS Number: $var"
if (($var > 0))
then
    ps aux | grep $PROCESS | grep -v 'grep' | grep -v 'process' |awk '{print $2}' | xargs kill -s 9
fi



