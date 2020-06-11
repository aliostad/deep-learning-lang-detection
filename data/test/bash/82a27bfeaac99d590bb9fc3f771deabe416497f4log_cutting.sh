#!/bin/bash
#设置日志的目录和分割后的日志保存目录

logs_path="/usr/local/nginx/logs"
save_path="/usr/local/nginx/logs/save_path_log"

#判断分割后的日志保存目录是否存在，如果不存在就创建目录
if [ ! -d ${save_path_log} ]
then
 mkdir -p ${save_path_log}
fi

#把日志移动到保存目录中，实现日志分割，并重命名为：日志名+日期时间（精确到时）
mv ${logs_path}/access.log ${save_path}/access$(date+%Y%m%d%H).log
kill -USR1 `cat /usr/local/nginx/logs/nginx.pid`
