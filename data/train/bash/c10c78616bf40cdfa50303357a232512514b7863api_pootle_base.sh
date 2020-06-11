#!/bin/bash

# calls pootle manager CLI, with a command and its args. This is the core interface function with Pootle.
function call_manage() {
	command="$1"
	shift 1
	args="$@"

	python_path_arg=""
	[[ ! -z $POOTLE_PYTHONPATH ]] && python_path_arg="--pythonpath=$POOTLE_PYTHONPATH"

	settings_arg="";
	[[ ! -z $POOTLE_SETTINGS ]] && settings_arg="--settings=$POOTLE_SETTINGS"


	invoke="python $MANAGE_DIR/manage.py $command $args $python_path_arg $settings_arg"
	logt 5 -n "$invoke"
	$invoke > /dev/null 2>&1
	check_command
}
