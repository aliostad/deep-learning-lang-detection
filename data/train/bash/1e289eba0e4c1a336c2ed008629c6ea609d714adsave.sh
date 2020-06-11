#!/usr/bin/env bash


#Only one loop, save delay is counted from time to add. Which in turn is TTK_LOG_DELAY
#TODO what if TTK_LOG_DELAY is changed during run?
TTK_DELAYED_SAVE_ELAPSED=0;
TTK_DELAYED_SAVE_DATA="";
TTK_TIME_TO_SAVE=0; #When reloading config, write first

#1 = data
#2 = time to add
saveLog() {

	TTK_TIME_TO_SAVE=$2;
	TTK_DELAYED_SAVE_DATA[${#TTK_DELAYED_SAVE_DATA[@]}]="$1"
	TTK_DELAYED_SAVE_ELAPSED=$((TTK_DELAYED_SAVE_ELAPSED+$2))
	if [ "$TTK_DELAYED_SAVE_ELAPSED" -lt "$TTK_WRITE_DELAY" ]; then
		return 0;
	fi

	forceSaveLog;
}

forceSaveLog() {
	fname="$TTK_STORAGE_PREFIX"_doSaveLog
	$fname "${TTK_DELAYED_SAVE_DATA[@]}" "$TTK_TIME_TO_SAVE";


	#Empty temp data
	TTK_DELAYED_SAVE_DATA=()
	TTK_DELAYED_SAVE_ELAPSED=0
}

