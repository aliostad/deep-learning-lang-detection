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
$service_name = "lpstat"
############################################################################################################
### the default values
$ok_list = @("Normal")
$warning_list = @("DoorOpen", "Jammed", "LowPaper", "NoPaper", "PaperOut", "TonerLow", "Other", "Unknown")
$error_list = @("Offline", "Service Requested")
### end of the default values
############################################################################################################
### If there is a module conf file then override these default values
if([System.IO.File]::Exists($module_conf_file) -eq $True) {
#if(test-path $module_conf_file -eq $True) {
	. $module_conf_file
}
###############################################################################################################################################
$message_str = ""
$error_message_str = ""
$warning_message_str = ""
$ok_message_str = ""
$info_message_str = ""

###############################################################
###############################################################
$status_flag = 0
[array]$a = Get-Printer 2>$null
if ($? -eq $True) {
	$data_str = '<entries>'
	for($i = 0; $i -lt $a.Count; $i++) {
		$s = ' Type: ' + $a[$i].Type + ', job count: ' + $a[$i].JobCount + ', location: ' + $a[$i].Location
		if ($a[$i].Shared) {
			$s += ', shared.'
		} else {
			$s += ', not shared.'
		}
		if ($ok_list -contains $a[$i].PrinterStatus) {
			$status_flag = 1
			$ok_message_str += 'OK: ' + $a[$i].Name + ' is ' + $a[$i].PrinterStatus + '. ' + $s
		} elseif ($warning_list -contains $a[$i].PrinterStatus) {
			$status_flag = 1
			$warning_message_str += 'WARNING: ' + $a[$i].Name + ' is ' + $a[$i].PrinterStatus + '! ' + $s
		} elseif ($error_list -contains $a[$i].PrinterStatus) {
			$status_flag = 1
			$error_message_str += 'ERROR: ' + $a[$i].Name + ' is ' + $a[$i].PrinterStatus + '! ' + $s
		} else {
			$status_flag = 0
			$error_message_str += 'ERROR: ' + $a[$i].Name + ' is ' + $a[$i].PrinterStatus + '! ' + $s 
		}
		$data_str += '<entry name="' + $a[$i].Name + '" type="boolean">' + $status_flag + '</entry>'
	}
	$data_str = '</entries>'
} else {
	$error_message_str = " ERROR: Could not execute Get-Printer command!"
}


$statusid = $statusids.Item("ok")
if ($error_message_str.Length -gt 0) {
	$statusid = $statusids.Item("error")
}
elseif ($warning_message_str.Length -gt 0) {
	$statusid = $statusids.Item("warning")
}
$error_message_str = $error_message_str.Trim()
$warning_message_str = $warning_message_str.Trim()
$ok_message_str = $ok_message_str.Trim()
$info_message_str = $info_message_str.Trim()
$message_str = $error_message_str + " " + $warning_message_str + " " + $ok_message_str + " " + $info_message_str
###############################################################################################################################################
print_and_exit "$FS" "$service_name" $statusid "$message_str" "$data_str"
###############################################################################################################################################
