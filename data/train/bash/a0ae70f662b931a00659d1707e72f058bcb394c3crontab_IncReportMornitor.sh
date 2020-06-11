#!/bin/sh
export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin

process="IncReportPerSecond"
conf="../conf/cron_inc_report.conf"

cd ` dirname $0 `

#count=$( ps -ef | grep -w "${process}" | grep -v grep | wc -l )

is_proc_running()
{
    killall -0 "$process" &> /dev/null
}

is_ok_to_run()
{
    local flag
    flag=$( cat $conf )

    if (( $flag == 0 )); then
       return 1 # false
    else
       return 0
    fi 
}

if ! is_ok_to_run; then
    exit 0
fi

if ! is_proc_running; then

    echo "[`date +'%Y-%m-%d %T'`] process number:$count, restart it!"
    killall -9 ${process};
    ./${process}

else

    echo "[`date +'%Y-%m-%d %T'`] process number is normal:$count"

fi
