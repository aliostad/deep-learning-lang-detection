#!/bin/bash

current_dir=`dirname $0`
. $current_dir/common_envs.sh

mail_recepients_list=$current_dir/mail_recepients
if [[ $1 == "--test" ]];then
	mail_recepients_list=$current_dir/mail_test
fi

load_5=$(uptime|awk -F: '{print $NF}'|cut -d',' -f2)
load_15=$(uptime|awk -F: '{print $NF}'|cut -d',' -f3)
system_core=$(lscpu |grep '^CPU(s):'|cut -d':' -f2|sed 's/ //g')
warn_load=$(($system_core * 4))

compare_15=$(echo "$load_15 > $warn_load.0" | bc)
compare_5=$(echo "$load_5 > $warn_load.0" | bc)
if [[ "$compare_15" = 1 ]] && [[ $compare_5 = 1 ]];then
	while read email_id
	do	
		$current_dir/mail.sh $email_id $MAIL_SENDER "$NODE_NAME(`hostname`): Warn level system load(`uptime|awk -F: '{print $NF}'`)" "-DevOps"
	done < $mail_recepients_list
fi
