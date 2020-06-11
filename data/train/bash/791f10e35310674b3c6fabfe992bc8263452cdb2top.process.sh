#!/bin/sh
# 对系统进行分析排查资源占用过多的进程
# http://www.whypc.info/2010/06/shell_current_load/
# crontab -e 添加 */2 * * * * 两分钟执行一次
#########################################################
#Please manually create the directory:/var/log/customize#
########For example:mkdir -p /var/log/customize##########
#########################################################
TOP_SYS_LOAD_NUM1=12
SYS_LOAD_NUM1=`uptime | awk '{print $(NF-2)}' | sed 's/,//'`
#echo `date +"%y-%m-%d %T"`' ## Current load: '$SYS_LOAD_NUM1>>/var/log/customize/hdwnt.log
echo `date +"%y-%m-%d %T"`' ## Current load: '$SYS_LOAD_NUM1
if [ `echo "$SYS_LOAD_NUM1 > $TOP_SYS_LOAD_NUM1"|bc` -eq 1 ]
then
    #ps auxww --sort -%cpu>>/var/log/customize/`date +"%Y%m%d%H%M%S"`.log
    ps auxww --sort -%cpu
fi













