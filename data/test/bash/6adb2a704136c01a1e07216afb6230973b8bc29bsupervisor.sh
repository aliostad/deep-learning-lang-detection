#!/bin/sh

# 函数: CheckProcess
# 功能: 检查一个进程是否存在
# 参数: $1 --- 要检查的进程名称
# 返回: 如果存在返回0, 否则返回1.
#------------------------------------------------------------------------------
CheckProcess()
{
  # 检查输入的参数是否有效
  if [ "$1" = "" ];
  then
    echo "参数为空！"
    return 1
  fi
 
  #$PROCESS_NUM获取指定进程名的数目，为1返回0，表示正常，不为1返回1，表示有错误，需要重新启动
  PROCESS_NUM=`ps -ef | grep "$1" | grep -v "grep" | wc -l` 
  if [ $PROCESS_NUM -eq 1 ];
  then
    return 0
  else
    return 1
  fi
}

PROCESS_NAME1=dns1
PROCESS_PATH1=/home/wansboods/github/wansboodsCode/sample/dns/dns1

# 检查实例是否已经存在
while [ 1 ] ; do
 CheckProcess dns1
 CheckQQ_RET=$?
 if [ $CheckQQ_RET -eq 1 ];
 then
# 杀死所有进程
  killall dns1
  exec $PROCESS_PATH1 &
 fi
 sleep 1
done
