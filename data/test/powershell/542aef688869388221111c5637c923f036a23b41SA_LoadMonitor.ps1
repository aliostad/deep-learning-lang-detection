<# #############################################################################
# NAME: SA_LoadMonitor.ps1
# 
# AUTHOR:  Gregg Jenczyk, UMass (UITS)
# DATE:  2014/08/19
# EMAIL: gjenczyk@umassp.edu
# 
# COMMENT:  This will kick off the SA_LoadMonitor.js script.  It will run every
#           ...20 minutes(?) between 6:00 PM and 1:00 AM (7 hours)
#
# VERSION HISTORY
# 1.0 2014.04.18 Initial Version.
#
# TO ADD:
# 
# USEFUL SNIPPETS:
# "$(Get-Date) " | Out-File -Append $runLog
# #############################################################################>

#-- INCLUDES --#
. "\\ssisnas215c2.umasscs.net\diimages67prd\script\PowerShell\sendmail.ps1"

#-- CONFIG --#

$localRoot = "D:\"
$root = "\\ssisnas215c2.umasscs.net\diimages67prd\"
$env = ([environment]::MachineName).Substring(2)
$env = $env -replace "W.*",""
$logDate = $(get-date -format 'yyyyMMdd')

#- LOGGING -#
$runLog = "${root}log\run_log-SA_LoadMonitor_${logDate}.log"
$scriptLog = "${root}log\SA_LoadMonitor_${logDate}.log"

#-- MAIN --#
"$(get-date) - Starting SA_LoadMonitor Script" | Out-File $runLog -Append

D:\inserver6\bin64\intool --cmd run-iscript --file ${root}script\SA_LoadMonitor.js >> $runLog

<#
Use this if you want to be notified when the script finishes running

sendmail -t "gjenczyk@umassp.edu" -s "[DI ${env} Notice] ScriptName.ps1 has finished running" -m ${message}
#>

$error[0] | Format-List -Force | Out-File $runLog -Append
"$(get-date) - Finishing SA_LoadMonitor Script" | Out-File $runLog -Append