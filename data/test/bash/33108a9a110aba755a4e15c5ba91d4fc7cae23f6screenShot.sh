#!/bin/bash
#set -x
CMD_SCREEN_SHOT="screenshot"
TOP=$(pwd)
TARGET_SAVE_DIR="/data/screenShot"
HOST_SAVE_DIR=$TOP/screenShot
MAX_NUM=100
#TMP=$(mktmp)
((DEL_FILE_NR=$MAX_NUM/2))
DEL_FILE_LIST="find $HOST_SAVE_DIR|sed -n "1,"$MAX_NUM"p""
num=0
sum=0
adb shell "mkdir $TARGET_SAVE_DIR" >/dev/null 2>&1
while true
do
	((num+=1))
	PNG=screenShot_$(date "+%y%m%d%H%M%S").png
	adb shell "cd $TARGET_SAVE_DIR;$CMD_SCREEN_SHOT $PNG" >/dev/null 2>&1
	adb pull $TARGET_SAVE_DIR $HOST_SAVE_DIR >/dev/null 2>&1
	adb shell "cd $TARGET_SAVE_DIR;rm *" >/dev/null 2>&1
	if [ $num -gt $MAX_NUM ];then
		((num=0))
		rm $(eval $DEL_FILE_LIST)

	fi
	((sum+=1))
	echo "$PNG total screensot $sum"
done
#set +x
