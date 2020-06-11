#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/monitor.shh"



# MAIN PROCESS
for _p in $(Monitor::Process::GetAllPids)
do
    _stat=$(Monitor::Process::GetStat ${_p})
    if [ $? = 0 ]
    then
        #_pid=$(Monitor::Process::GetPidByStat "${_stat}")
        #_cmd=$(Monitor::Process::GetCommand ${_stat})

        _ppid=$(Monitor::Process::GetParentPid ${_stat})
        #_pstat=$(Monitor::Process::GetStat ${_ppid})
        #_pcmd=$(Monitor::Process::GetCommand ${_pstat})

        _pm=$(Monitor::Process::GetUsedPhysicalMemorySize ${_stat})
        _vm=$(Monitor::Process::GetUsedVirtualMemorySize ${_stat})
        #Monitor::Process::GetUsedSwapSize ${_stat}

        ((_pm = _pm / 1024))
        ((_vm = _vm / 1024))

        echo -e "# PID=${_p} \tPPID=${_ppid}"
        #echo -e "#\tCMD=${_cmd}\tPCMD=${_pcmd}"
        echo -e "#\tPM=${_pm}KB"
        echo -e "#\tVM=${_vm}KB"
        #echo -e "#\tSW=${_sw}KB"
    fi
done

exit

