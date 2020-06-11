#!/bin/bash
# Author: chuantong.haung@gmail.com
# Date: 2014-07-01@wps.cn

. ./logging.sh

DEFAULT_PROCESS_NUMBER=5

multi_process()
{
	# usage like multi_process <number-of-process[default 5]> 'function_name' <$*>
	# <$*> is function_name params
	if [ ${#@} -lt 2 ]; then
		warn "usage like multi_process <number-of-process[default 5]> 'function_name' <$*> "
		return 1
	fi
	process=$DEFAULT_PROCESS_NUMBER
	# test $1 is can convert a number.
	expr "$1" + 1 1>&2 > /dev/null

	if [ $? -eq 0 ]; then
		# $1 is a string can convert to number or number.
		process=$1
	fi

	for(( i=0; i<$process; i++ ))
	do
	{
		$2 "${@:3}"
		# do something or call some function.
	} & # make it run in background

	# wait for backkgroud process.' when call wait, like call fork() function.
	wait
	done
}

multi_process 4 'echo' "test call echo......$$" 'pasdfasdf'