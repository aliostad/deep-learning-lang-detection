############################################################################################################
#
#    Copyright (C) 2003 - 2014  Erdal Mutlu
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#
############################################################################################################
$prog_name = $MyInvocation.MyCommand.Name
if ($Args.Length -lt 2) {
	Write-Host "Usage: " $prog_name " SisIYA_Config.ps1 expire" 
	Write-Host "Usage: " $prog_name " SisIYA_Config.ps1 expire output_file" 
	Write-Host "The expire parameter must be given in minutes."
	exit
} 

$conf_file = $Args[0]
$expire = $Args[1]
if ([System.IO.File]::Exists($conf_file) -eq $False) {
	Write-Host $prog_name ": SisIYA configuration file " $conf_file " does not exist!"
	exit
}
[string]$output_file = ""
if ($Args.Length -eq 3) {
	$output_file = $Args[2]
}
### get configuration file included
. $conf_file 

if([System.IO.File]::Exists($local_conf_file) -eq $False) {
	Write-Output "SisIYA local configurations file " $local_conf_file " does not exist!" | eventlog_error
	exit
}
### get SisIYA local configurations file included
. $local_conf_file 

if ([System.IO.File]::Exists($sisiya_functions) -eq $False) {
#if(test-path $conf_file -eq $False) {
	Write-Output "SisIYA functions file " $sisiya_functions " does not exist!" | eventlog_error
	exit
}
### get common functions
. $sisiya_functions
### Module configuration file name. It has the same name as the script, because of powershell's include system, but 
### it is located under the $conf_d_dir directory.
$module_conf_file = $conf_d_dir + "\" + $prog_name
$data_message_str = ''
############################################################################################################
############################################################################################################
$service_name = "load"
############################################################################################################
### the default values
$warning_percent = 85
$error_percent = 90
### end of the default values
############################################################################################################
### If there is a module conf file then override these default values
if ([System.IO.File]::Exists($module_conf_file) -eq $True) {
#if(test-path $module_conf_file -eq $True) {
	. $module_conf_file
}
###############################################################################################################################################
$message_str = ''

$info_message_str = ''
$ok_message_str = ''
$warning_message_str = ''
$error_message_str = ''

### get processor
$n = 0
$i = 0
$processors = Get-WmiObject -Class Win32_Processor
foreach ($p in $processors) {
	$i += 1
	$n += $p.LoadPercentage
	$name_str = $p.Name.Trim()
	$cores_str = ''
	if($p.NumberOfCores) {
		$cores_str = " (CPU cores=" + $p.NumberOfCores + ") "
	}
	### check for load
	if($p.LoadPercentage -ge $error_percent) {
		$error_message_str += " ERROR: The load is " + $p.LoadPercentage + "% (>=" + $error_percent +")!"
	}
	elseif ($p.LoadPercentage -ge $warning_percent) {
		$warning_message_str += " WARNING: The load is " + $p.LoadPercentage + "% (>=" + $warning_percent +")!"
	}
	else {
		$ok_message_str += " OK: The load is " + $p.LoadPercentage + "%."
	}

	### check for status
	if ($p.Status -eq "OK") {
### check $p.NumberOfCores : it is not defined for single core CPUs
		$ok_message_str += " OK: The status of " + $name_str + $cores_str + " is " + $p.Status + "."
	} else {
		$error_message_str += " ERROR: The status of " + $name_str + $cores_str + " is " + $p.Status + " != OK!"
	}
}
$statusid = $statusids.Item("ok")
if ($error_message_str.Length -gt 0) {
	$statusid = $statusids.Item("error")
}
elseif ($warning_message_str.Length -gt 0) {
	$statusid = $statusids.Item("warning")
}
$n = [int] $n / $i
$data_str = '<entries><entry name="load_average" type="numeric">' + $n + '</entry></entries>';
$error_message_str = $error_message_str.Trim()
$warning_message_str = $warning_message_str.Trim()
$ok_message_str = $ok_message_str.Trim()
$info_message_str = $info_message_str.Trim()
$message_str = $error_message_str + " " + $warning_message_str + " " + $ok_message_str + " " + $info_message_str
###############################################################################################################################################
print_and_exit "$FS" "$service_name" $statusid "$message_str" "$data_str"
###############################################################################################################################################
