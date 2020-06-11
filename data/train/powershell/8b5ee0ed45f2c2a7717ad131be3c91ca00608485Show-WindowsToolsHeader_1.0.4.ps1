#requires –version 2.0

Function Show-WindowsToolsHeader {
	Param (
		[parameter(Mandatory=$false)][switch]$NoTips
	)
	
#	# Standard Console Header
#	Write-Host 'Windows PowerShell'
#	Write-Host 'Copyright (C) 2009 Microsoft Corporation. All rights reserved.'
#	Write-Host ''

	# GET PS AND CLR VERSIONS FOR HEADER
	$PSVersion = $PSVersionTable.PSVersion.ToString()
	$CLRVersion = ($PSVersionTable.CLRVersion.ToString()).Substring(0,3)
	$WindowsToolsModuleManifest = Test-ModuleManifest -Path "$Global:WindowsToolsModulePath\WindowsTools.psd1"
	[string]$WindowsToolsModuleVersion = $WindowsToolsModuleManifest.Version.ToString()

	# SHOW CONSOLE HEADER
	Clear
	Write-Host "PowerShell v$PSVersion  |  CLR v$CLRVersion  |  Windows Tools Module v$WindowsToolsModuleVersion"
	Write-Host '--------------------------------------------------------------'
#	Write-Host -nonewline "Run This 1st to Set Defaults:`t`t"
#	Write-Host -fore Yellow "Set-WindowsToolsDefaults"
	Write-Host -nonewline "List available module commands:`t`t"
	Write-Host -fore Yellow "Get-WTCommand"
	Write-Host -nonewline "Get C: hard drive space info:`t`t"
	Write-Host -fore Yellow "Get-DriveSpace"
	Write-Host -nonewline "Move AD computer objects to target OU:`t"
	Write-Host -fore Yellow "Move-ADComputer"
	Write-Host -nonewline "List inactive AD computer objects:`t"
	Write-Host -fore Yellow "Get-InactiveComputers"
#	Write-Host -nonewline "Get computer OS and hardware info:`t"
#	Write-Host -fore Yellow "Get-HostInfo"
#	Write-Host -nonewline "Find and replace content in files:`t"
#	Write-Host -fore Yellow "Switch-Content"
	Write-Host -nonewline "Reboot a single or multiple computers:`t"
	Write-Host -fore Yellow "Restart-Hosts"
	#Write-Host "`n"
	Write-Host ''

	If (($NoTips.IsPresent) -eq $false) {
		Show-WindowsToolsTip
	}
}

#region Notes

<# Dependents
	WindowsTools.psm1
	Func_Reset-WindowsToolsUI
#>

<# Dependencies
#>

<# To Do List
	
#>

<# Change Log
1.0.0 - 05/10/2012
	Created
1.0.1 - 05/10/2012
	Added parameters to have this Function run Tips
	Added switch to not show Tips
	Added conditional function loading
1.0.2 - 10/29/2012
	Added Move-ADComputer
1.0.3 - 12/27/2012
	Added Switch-Content back
	Added Get-HostInfo
	Added Restart-Hosts
1.0.4 - 01/09/2013
	Removed SubScript Parameter
	Removed dot sourcing SubScripts
#>

#endregion Notes
