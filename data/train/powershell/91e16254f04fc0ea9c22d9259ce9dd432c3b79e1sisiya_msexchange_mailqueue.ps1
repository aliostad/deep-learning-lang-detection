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
$service_name = "mailq"
############################################################################################################
### the default values
$warning_mailq=3
$error_mailq=5
### end of the default values
############################################################################################################
### If there is a module conf file then override these default values
if([System.IO.File]::Exists($module_conf_file) -eq $True) {
#if(test-path $module_conf_file -eq $True) {
	. $module_conf_file
}
###############################################################################################################################################
### add MS Exchange snappin
# for MS Exchange 2007
addMSExcangeSupport
# for MS Exchange2010
#Add-PSSnapIn Microsoft.Exchange.Management.PowerShell.E2010

$message_str=""
$error_message_str=""
$warning_message_str=""
$ok_message_str=""
$info_message_str=""

[array]$list=Get-Queue

#Identity                                    DeliveryType Status MessageCount NextHopDomain
#--------                                    ------------ ------ ------------ -------------
#Parizien\11221                              MapiDelivery Ready  0            parizien.altin.com
#Parizien\11225                              SmartHost... Ready  0            [200.0.0.1]
#Parizien\Submission                         Undefined    Ready  0            Submission
if($list) {
	foreach($s in $list) {
		if($s.Status -eq "Ready") {
			$ok_message_str=$ok_message_str + " OK:  [" + $s.Identity + "] mail queue is Ok."
			if($s.MessageCount -ge $error_mailq) {
	 			$error_message_str=$error_message_str + " ERROR: There are " + $s.MessageCount + "(>= " + $error_mailq +") mails in the " + $s.Identity + " mail queue!"
			}
			elseif($s.MessageCount -ge $warning_mailq) {
 				$warning_message_str=$warning_message_str + " WARNING: There are " + $s.MessageCount + "(>= " + $warning_mailq +") mails in the " + $s.Identity + " mail queue!"
			}
			else {
 				$ok_message_str=$ok_message_str + "OK: The number of messages in the " + $s.Identity + " mail queue is " + $s.MessageCount + "."
			}
		}
		else {
			$error_message_str=$error_message_str + " ERROR: The status of " + $s.Identity + " is " + $s.Status + " != Ready!"
		}
	}
}
else {
	$error_message_str=" ERROR: Coul not execute Get-Queue cmdlet!"
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
