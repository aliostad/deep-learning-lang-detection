function processmonitor() {
  local dead_process=''
  local item=""
  local proc=""
  for item in $1
  do
	  proc=`pgrep $item`
	  if [ "$proc"x == ""x ];then
		if [ -z "$dead_process" ];then 
			dead_process=$item
	    else
			dead_process="$dead_process $item"
		fi
	  fi
  done
  echo $dead_process
}

function start_process() {
	local dead_process_list=$2
	local dead_process=""
	local other_handler=""
	for dead_process in $dead_process_list
	do
		other_handler=`echo $1 | tr -d '\n'`
		if [ "$dead_process"x != ""x ];then
			while [ "$other_handler"x != ""x ]
			do
				one_handler=${other_handler%%;*}
				other_handler=${other_handler#*;}
				process_name=`echo ${one_handler%:*} | tr -d '[:space:]'`
				if [ "$dead_process"x == "$process_name"x ];then
					process_start="${one_handler#*:}"
					eval $process_start
				fi
			done
		fi
	done
}


