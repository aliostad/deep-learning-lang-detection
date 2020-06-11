#!/usr/bin/env bash
# 第16行开始是每个进程的信息
index=16
split='************************'
# 存放 php-fpm status 信息的文件
process_info_file="status$1"
total_count=`cat $process_info_file | wc -l | tr -d ' '`
echo "总行数：$total_count"
if [ ! -f "$process_info_file" ]; then
    echo "no such file $process_info_file"
    exit 1
fi
total_idle_number=`sed -n 9p $process_info_file | cut -d ':' -f 2 | tr -d ' '`
total_active_number=`sed -n 10p $process_info_file | cut -d ':' -f 2 | tr -d ' '`
total_number=`sed -n 11p $process_info_file | cut -d ':' -f 2 | tr -d ' '`
total_target_process=0
total_target_process_cpu=0
total_target_process_memory=0
total_target_process_duration_time=0
total_target_process_requests=0
active_target_process=0
for (( index=16; index<=$total_count; index=index+15 ))
do
    next=`sed -n ${index}p $process_info_file`
    if [ "$next" == "$split" ]; then
        echo "处理进度: $index / $total_count 行"
        process_block=`sed -n $(( ${index} + 1 )),$(( $index + 13 ))p $process_info_file`
        is_target=`echo "$process_block" | grep -e "script:\s\+$2"`
        is_idle=`echo "$process_block" | grep -e "state:\s\+Idle"`
        if [ -n "$is_target" ]; then
            if [ -n "$is_idle" ]; then
                total_target_process=$(( $total_target_process + 1 ))
                cpu=`echo "$process_block" | grep 'last request cpu' | cut -d ':' -f 2 | tr -d ' '`
                memory=`echo "$process_block" | grep 'last request memory' | cut -d ':' -f 2 | tr -d ' '`
                duration_time=`echo "$process_block" | grep 'request duration' | cut -d ':' -f 2 | tr -d ' '`
                requests=`echo "$process_block" | grep 'requests:' | cut -d ':' -f 2 | tr -d ' '`
                total_target_process_cpu=$(awk "BEGIN {printf \"%.2f\", $total_target_process_cpu+$cpu}")
                total_target_process_memory=$(awk "BEGIN {printf \"%.2f\", $total_target_process_memory+$memory}")
                total_target_process_duration_time=$(awk "BEGIN {printf \"%.2f\", $total_target_process_duration_time+$duration_time}")
                total_target_process_requests=$(awk "BEGIN {printf \"%.2f\", $total_target_process_requests+$requests}")
            else
                active_target_process=$(( $active_target_process + 1 ))
            fi
        fi
    else
        echo can not match split line $index!
        exit 1
    fi
done
average_cpu=$(awk "BEGIN {printf \"%.2f\", $total_target_process_cpu/$total_target_process}")
average_memory=$(awk "BEGIN {printf \"%.2f\", $total_target_process_memory/$total_target_process}")
average_duration=$(awk "BEGIN {printf \"%.2f\", $total_target_process_duration_time/$total_target_process/1000}")
average_requests=$(awk "BEGIN {printf \"%.2f\", $total_target_process_requests/$total_target_process}")
echo "total processes: $total_number"
echo "total idle processes: $total_idle_number"
echo "total active processes: $total_active_number"
echo "total idle target processes number: $total_target_process"
echo "total active target processes: $active_target_process"
echo "average cpu used by target processes: $average_cpu%"
echo "average memory used by target processes: $average_memory"
echo "average request duration time of target processes: $average_duration ms"
echo "average requests processed of target process: $average_requests"
