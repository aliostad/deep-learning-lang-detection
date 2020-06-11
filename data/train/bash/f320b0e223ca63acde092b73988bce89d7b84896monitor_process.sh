#!/bin/sh

# 作者:李春江
# 创建时间:2012-10-10
# 脚本目的:监控java进程状态
# 修改原因:[修改请注明原因]
# 修改时间:[修改请注明时间]
# 修改作者:[修改请注明作者]

VARS=$#
if [ $VARS -lt 1 ];
then
        echo "必须传入1个参数,参数是进程名称"
        exit 0;
fi


PROCESS_NAME=$1
PROCESS_COUNT=0
echo $PROCESS_COUNT>PROCESSCOUNT
ps -ef|grep $PROCESS_NAME | grep java | grep -v grep | awk '{print $2}' |while read pid
do
	PROCESS_COUNT=`expr $PROCESS_COUNT + 1`
	echo $PROCESS_COUNT > PROCESSCOUNT
done
	read PROCESS_COUNT < PROCESSCOUNT
if [ $PROCESS_COUNT -gt 0 ]
then
        echo "PROCESS_EXIST"
else
		echo "PROCESS_NOT_EXIST"
fi
rm PROCESSCOUNT