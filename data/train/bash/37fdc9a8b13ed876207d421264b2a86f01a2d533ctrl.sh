#!/bin/bash

process_name=(
	"hd.sh"
	"cpu.sh"
	"cputester"
	"gzip"
	"gunzip"
	"diff"
	"tar"	# 'cf'
	"cp"	# '-avf'
)

i=0
for process in "${process_name[@]}"
do
	echo $i ${process}

	# get the process's pid
	if [ ${process} == "tar" ]; then
		pids=`ps -ef | grep ${process} | grep "cf" | grep -v grep | awk '{printf("%s ", $2)}'`
	elif [ ${process} == "cp" ]; then
		pids=`ps -ef | grep ${process} | grep "avf" | grep -v grep | awk '{printf("%s ", $2)}'`
	else
		pids=`ps -ef | grep ${process} | grep -v grep | awk '{printf("%s ", $2)}'`
	fi

	# kill process
	if [ ! -z "${pids}" ]; then
		echo "${process}'s pids: ${pids}"
		echo "will kill ${pids}"
		kill -9 ${pids}
	fi

	echo ""

	i=`expr $i + 1`
done
