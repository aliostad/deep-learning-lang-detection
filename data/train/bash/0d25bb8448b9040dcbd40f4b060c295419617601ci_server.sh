#!/bin/bash

#
# Minimalistic Continuous Integration Server
#
# Preconditions: git repository cloned in project_root; branch with name "dev" created
#

#
# Project related properties
#
readonly project_root="/home/ec2-user/github/kymitriz"
readonly build_script="build.sh"
readonly program_main="build/main.py"
readonly launch="python"
readonly check_interval_secs=60

#
# Internal constants, variables and functions
#
readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly stop_file="$script_dir/stop.ci"

debug_on=0
process_id=0
new_changes=0

log() {
	echo "`date` : $1"
}

debug() {
	if [ $debug_on != 0 ] ; then
		log "[DEBUG] $1"
	fi
}

check_changes() {
	git checkout master > /dev/null 2>/dev/null
	git pull > /dev/null 2>/dev/null
	devdiff=`git diff dev`
	if [[ -z $devdiff ]] ; then
        	debug "no changes"
		new_changes=0
	else
        	log "incoming changes"
        	log $devdiff
		new_changes=1
	fi
	git checkout dev > /dev/null 2>/dev/null
}

kill_process() {
	if [ $process_id != 0 ]; then
		debug "killing process with pid $process_id"
		kill -kill $process_id
		wait $process_id
		process_id=0
		debug "process killed"
	fi
}

#
# Script entrypoint
#

if [ "$1" == "-debug" ] ; then
	debug_on=1
fi
debug "debug_on == $debug_on"

cd $project_root
git checkout dev

while true ; do
	if [ -e $stop_file ]; then
		log "stop file exists, exiting..."
		kill_process
		rm -f $stop_file
		break
	fi
	check_changes
	if [ $new_changes == 1 ] ; then
		kill_process
		git merge master
	fi
	if [ $process_id == 0 ] ; then
		debug "building..."
		${project_root}/${build_script}
		debug "starting new process..."
                $launch ${project_root}/${program_main} &
                process_id=$!
                log "started process with pid $process_id"
	fi
	sleep $check_interval_secs
done
