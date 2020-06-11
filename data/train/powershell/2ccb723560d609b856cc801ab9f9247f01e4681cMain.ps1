<#
Written by: Ram Pandy & Shah Miah
Email: a-rapan@microsoft.com, shmiah@microsoft.com

Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. You agree: 
(i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
(ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
(iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, 
that arise or result from the use or distribution of the Sample Code


Change Log:
1.0 (30/04/2015) - Initial release
#>

cls

$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 

if(($IsAdmin) -eq $false)
{
    Write-Error "Must run elevated PowerShell to install WinRM certificates used for Remote PowerShell."
	return
}

$startTime = get-date
"$startTime"

"Start - Script Path"
if($MyInvocation.MyCommand.Path -eq $null) { $pathName = $pathForIDERun } else {$pathName = Split-Path $MyInvocation.MyCommand.Path -ErrorAction SilentlyContinue}
"Script Path is " + $pathName
"End - Script Path"

"Start - Load variables"
. $pathName\GlobalVariables.ps1
"End - Load variables"

"Start - Load common functions"
. $pathName\Common.ps1
"End - Load common functions"

"Start - Send Alerts "
. $pathName\PortUsageAlerts.ps1
"End - Send Alerts "
