#!/bin/bash
################################################################################
### Backup script for current ESX host #########################################
### only one argument is required '-b' or '-r' #################################
################################################################################

dt=$(date "+%Y%M%d")
tgt_cmd="source /opt/vmware/vma/bin/vifptarget"
esx_hostn=$(${tgt_cmd} --display)
x_cmd='/usr/bin/vicfg-cfgbackup'
save_flag='--save'
home="/home/vi-admin"
task="$1"
save_name="${home}/${esx_hostn}.${dt}.tar.gz"

case "${task}" in

-b)
    ${x_cmd} ${save_flag} ${save_name}
    exit $?
    ;;
-r)
    ;;
*) exit 1
    
    ;;
esac
