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
$service_name = "filesystem"
############################################################################################################
### the default values
$warning_percent = 85
$error_percent = 90
### end of the default values
############################################################################################################
### If there is a module conf file then override these default values
if([System.IO.File]::Exists($module_conf_file) -eq $True) {
#if(test-path $module_conf_file -eq $True) {
	. $module_conf_file
}
###############################################################################################################################################
function getFormatedSize
{
	Param([double]$size, [double]$d, [string]$size_name)
	$result=$size / $d
	$rest=$size % $d
	Write-Output "result=" $result " rest=" $rest $size_name
}

function getSizeGB
{
	Param ([double]$size)

	[string]$result_str=""
	if($size -eq 0) {
		$result_str="0"
	}
	elseif($size -lt 1024) {
		$result_str=$size + "GB"
	}
	elseif($size -lt 1048576) {
		$result_str=getFormatedSize $size 1024 "TB"
	}
	elseif($size -lt 1073741824) {
		$result_str=getFormatedSize $size 1048576 "PB"
	}
	else {
		$result_str=getFormatedSize $size 1073741824 "EB"
	}
	Write-Output $result_str
}

$statusid=$statusids.Item("ok")
$message_str=""

$info_message_str=""
$ok_message_str=""
$warning_message_str=""
$error_message_str=""

### get all local disk drives
$drives=Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
foreach($drive in $drives) { 
	$device_id=$drive.DeviceID 
	$fs_type=$drive.FileSystem
	$is_dirty=$drive.VolumeDirty
	$size=$drive.Size / 1GB  
	$free=$drive.FreeSpace / 1GB 
	$a=100 * ($size - $free) / $size 
	### format the size
	$size="{0:N2}" -f $size 
	[int]$used_percent=[int]$a 
	if($is_dirty) {
		$error_message_str=$error_message_str + " ERROR: " + $device_id + " is dirty!"
	}
	if($used_percent -ge $error_percent) {
		$error_message_str=$error_message_str + " ERROR: " + $device_id + "(" + $fs_type + ") " + $used_percent + "% (>=" + $error_percent + ") of " + $size + "GB is full!"  
	}
	elseif($used_percent -ge $warning_percent) {
		$warning_message_str=$warning_message_str + " WARNING: " + $device_id + "(" + $fs_type + ") " + $used_percent + "% (>=" + $warning_percent + ") of " + $size + "GB is full!"  

	}
	else {
		$ok_message_str=$ok_message_str + " OK: " + $device_id + "(" + $fs_type + ") " + $used_percent + "% of " + $size + "GB is used."  
	}
	### 1GB=1073741824
	#$a=[double]($drive.Size / 1073741824)
	#$size_str=getSizeGB $a
}
$statusid=$statusids.Item("ok")
if($error_message_str.Length -gt 0) {
	$statusid=$statusids.Item("error")
}
elseif($warning_message_str.Length -gt 0) {
	$statusid=$statusids.Item("warning")
}
$error_message_str=$error_message_str.Trim()
$warning_message_str=$warning_message_str.Trim()
$ok_message_str=$ok_message_str.Trim()
$info_message_str=$info_message_str.Trim()
$message_str=$error_message_str + " " + $warning_message_str + " " + $ok_message_str + " " + $info_message_str
###############################################################################################################################################
print_and_exit "$FS" "$service_name" $statusid "$message_str" "$data_str"
###############################################################################################################################################
