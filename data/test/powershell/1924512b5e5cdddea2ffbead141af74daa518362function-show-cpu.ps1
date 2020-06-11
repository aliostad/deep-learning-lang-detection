# ----------------------------------------------------------------------
# Function: cpu - show cpu usage on remote server. 
#
#           Repeat for specified number of times, with a specified delay 
#           between samples. Or just do it once, straightaway
#
# This function is autoloaded by .matt.ps1
# ----------------------------------------------------------------------
function show-cpu { 
<#
.SYNOPSIS
  Show CPU usage over specified intervals
#>
Param ( [String] $MyServer = ".",
        [Int] $MyDelay = 0,
        [Int] $MyCount = 1)

# if Delay and count are not specified, then do it immediately and just once.
for ($i = 0 ; $i -le $MyCount - 1 ; $i++ )
{
    $MY_TIME = get-date
    # $MY_TIME = "Elvis"
    $MY_PERF = Get-WmiObject win32_processor -computer $MyServer 
    $MY_PERF | add-member -MemberType NoteProperty -Name MyTime -Value $MY_TIME
    $MY_PERF | select MyTime, SystemName, SocketDesignation, LoadPercentage
    # write-host $MY_TIME, $MY_PERF.SystemName, $MY_PERF.SocketDesignation, $MY_PERF.LoadPercentage
    start-sleep -s $MyDelay
}

}
set-alias cpu show-cpu
