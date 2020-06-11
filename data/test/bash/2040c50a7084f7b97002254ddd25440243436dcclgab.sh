#!/bin/bash
# little green advanced bash

lgab_is_process_pid() { ps -p $1  2>/dev/null >/dev/null ; }
lgab_is_process_pidfile() { lgab_is_process_pid $(< "$1" ) ; }
lgab_is_process_command() { ps -C ${1##*/} 2>/dev/null >/dev/null; }
lgab_is_process() {
	[[ $1 =~ ^[0-9]+$ ]] && { lgab_is_process_pid $1 ; return $?; }
	[[ -x $1 ]] && { lgab_is_process_command $1 ; return $?; }
	[[ -e $1 ]] && { lgab_is_process_pidfile $1 ; return $?; }
	lgab_is_process_command $1 
}

lgab_kill_after() {
	local pid=$!
	local seconds=$1
	disown $pid
	(
		SECONDS=0
		while lgab_is_process $pid; do
			[[ $SECONDS -gt $seconds ]] && { 
				kill -9 $pid
				break
			}
			sleep 1
		done
	)
}

lgab_errexit() {
	set -o errtrace
	error_handler() {
		echo "Error in ${BASH_SOURCE[1]} at line ${BASH_LINENO[0]}, exiting..."
		local stack=${FUNCNAME[*]}
		stack=${stack/error_handler }
		stack=${stack// /<-}
		echo "  Stacktrace = ${stack}"
		exit 1
	}
	trap error_handler ERR
}

lgab_test_run() {
	res=$( $1 )
	ret=$?
	pp() { printf "%-50s %6s\n" "$1" $2; }
	[[ "$res" = "$2" && $ret = "$3" ]] && { pp "$1" "ok"; return ;}
	pp "$1" "FAILED"
}

lgab_test_suite() {
	[[ "$DEBUG" != "" ]] && set -x
	tmpf="/tmp/lgab-pid-test"
	echo $$ > $tmpf
	lgab_test_run 'lgab_is_process bash' "" 0
	lgab_test_run "lgab_is_process /bin/bash" "" 0
	lgab_test_run "lgab_is_process /bin/bah-humbug" "" 1
	lgab_test_run "lgab_is_process $$" "" 0
	lgab_test_run 'lgab_is_process 28383883' "" 1
	lgab_test_run "lgab_is_process $tmpf" "" 0
	lgab_test_run "lgab_is_process /etc/passwd" "" 1

	SECONDS=0
	sleep 60 &
	lgab_kill_after 1
	lgab_test_run "test $SECONDS -lt 60  " "" 0

	SECONDS=0
	sleep 1 &
	lgab_kill_after 60
	lgab_test_run "test $SECONDS -lt 60  " "" 0

	rm -f $tmpf
}

[[ "${BASH_ARGV[0]}" =~ "lgab_test" ]] && lgab_test_suite
[[ "${LGAB_DISABLE_ERREXIT}" = "" ]] && lgab_errexit
