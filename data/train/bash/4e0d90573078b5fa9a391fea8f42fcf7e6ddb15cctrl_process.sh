#!/bin/bash
#
# Description: Script to start/stop/status init process, init process must exists !
#
# Autor: ygwane
#
#############################

#######
# VAR #
#######
PROCESS=${1}
ACTION=${2}
USAGE="\033[33m$0 (process) (action), Actions: start/stop/restart/status\033[0m"

##############
# CHECK ARGS #
##############
if [[ $# -lt 2 || $# -gt 2 ]]
then
  echo -e "\033[31mMissing args or too many args, usage is:\033[0m"
  echo -e ${USAGE}
  exit 1
fi

#################
# CHECK PROCESS #
#################
if [ -e /etc/init.d/${PROCESS} ]
then
  echo -e "\033[32mProcess ${PROCESS} exists\033[0m"
else
  echo -e "\033[31mProcess ${PROCESS} doesn't exists, exiting ...\033[0m"
  exit 1
fi

#############
# FUNCTIONS #
#############
function status() {
  echo -e "\033[35mStatus of process ${PROCESS}\033[0m"
  service ${PROCESS} status
}

function start() {
  echo -e "\033[35mStarting process ${PROCESS}\033[0m"
  service ${PROCESS} start
}

function stop() {
  echo -e "\033[35mStopping process ${PROCESS}\033[0m"
  service ${PROCESS} stop
}

################
# EXEC ACTIONS #
################
case ${ACTION} in
start)
  start
  ;;
stop)
  stop
  ;;
status)
  status
  ;;
restart)
  stop
  start
  ;;
*)
  echo -e "\033[35mBad action specified, usage is:\033[0m"
  echo -e "${USAGE}"
  exit 1
  ;;
esac

# EOS
