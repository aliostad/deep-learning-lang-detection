<#
.Synopsis
   Start Virtual Box Debian
.Description
   To run the script at start up run the following commands
   $trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
   Register-ScheduledJob -Trigger $trigger -FilePath 'C:\Users\Rafael\Documents\WindowsPowerShell\Scripts\Start-Debian.ps1' -Name StartDebian
#>
[cmdletbinding()]

$VerbosePreference = "Continue"
# Stop if there is any error
$ErrorActionPreference = "Stop"

$deb_conf = 'startvm "Debian" --type gui'
Invoke-Expression "C:\'Program Files'\Oracle\VirtualBox\VBoxManage.exe $deb_conf"