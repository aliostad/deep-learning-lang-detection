# date: 2016.05.05
# author: sunpengcheng(sunpch@foxmail.com)
# brief: use shell to start multiprocess and restrict the number of process

_PROCESS_NUM=0
_PROCESS_PIPE_NAME=""
_PROCESS_PIPE_ID=100

trap _clean_up SIGINT SIGHUP SIGTERM SIGKILL

function process_init()
{
	process_num=$1
	if [ -z "$process_num" ]; then
		process_num = $( _get_num_of_cpu_core)
	fi

	_PROCESS_NUM=$process_num
	_create_pipe
}

function process_run()
{
	cmd=$1
	if [ -z "$cmd" ]; then
		echo "please input command to run"
		_delete_pipe	
		exit 1
	fi

	_process_get
	{
		$cmd
		_process_post
	}&
}

function process_wait()
{
	wait
	_delete_pipe
}


function _clean_up
{
    _delete_pipe

	#send SIGTERM to all process in group
	kill 0
	#kill self, trap register SIGTERM,
	#if not kill self, Infinite recursion
	kill -9 $$
}

function _get_num_of_cpu_cores()
{
	core_num=$(cat /proc/cpuinfo | grep processor | wc -l)
	process_num=$(expr $core_num - 1)
	
	return $process_num
}

function _get_uid()
{
	uid="_process_"$$
	echo $uid
}

function _create_pipe()
{
	_PROCESS_PIPE_NAME=$(_get_uid)

	mkfifo ${_PROCESS_PIPE_NAME}
	eval exec "${_PROCESS_PIPE_ID}""<>${_PROCESS_PIPE_NAME}"

	for ((i=0; i < $_PROCESS_NUM; i++))
	do
		echo -ne "\n" 1>&${_PROCESS_PIPE_ID}
	done
}

function _delete_pipe()
{
	rm -rf ${_PROCESS_PIPE_NAME}
}


function _process_get()
{
	read -u $_PROCESS_PIPE_ID
}

function _process_post()
{
	echo -ne "\n" 1>&${_PROCESS_PIPE_ID}
}

#example
#process_init 5
#for ((i = 0; i < 20; i++))
#do
#	cmd="./a.out"
#	process_run "$cmd"
#done
#process_wait
