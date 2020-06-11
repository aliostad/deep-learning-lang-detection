#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================
# version:1.0
# author:wdfang
# date:2014-08-08
# mail:fangdong316@126.com
#===============================================================================

cur_dir=$(pwd)

# Load Files
loadFile(){
	local file=$1
	if [[ -s $cur_dir/bin/${file}.sh ]];then
		. $cur_dir/bin/${file}.sh
	else
		echo "$cur_dir/bin/${file}.sh not found,shell can not be executed."
		exit 1
	fi	
}

# Load Scripts
loadScript(){
	loadFile init
	loadFile config
	loadFile public
	loadFile install
	loadFile upgrade
}

# SystemAssistant 
systemAssistant(){
clear
echo "-------------------------------------------------------"
echo
echo "Welcome to use systemAssistant,hope you like."
echo "The script is written by Fang."
echo
echo "-------------------------------------------------------"
loadScript
rootNeed
mainMenu
}

# 
#rm -f $cur_dir/logs/systemAssistant.log

systemAssistant 2>&1 | tee -a $cur_dir/logs/systemAssistant_$(date+"%Y%m%d%H%M%S").log


