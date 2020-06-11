#requires –version 2.0

Function Reset-WindowsToolsUI {

	Param (
	[parameter(Position=0,Mandatory=$true)][string]$StartingWindowTitle,
	[parameter(Position=1,Mandatory=$true)][array]$StartupVariables,
	[parameter(Mandatory=$false)][switch]$SkipPrompt
	)

	#region Tasks
	
		#region Prompt: Press any Key
		
			If ($SkipPrompt.IsPresent -eq $false) {
				Write-Host ''
				Write-Host "Press any key to continue ..."
				$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
			}
			
		#endregion Prompt: Press any Key
		
		#region Reset UI
		
			Clear
			$Host.UI.RawUI.WindowTitle = $StartingWindowTitle
			
			# Remove Global Variables
			Get-Variable -Scope Global | Select -ExpandProperty Name |
			Where-Object {$StartupVariables -notcontains $_} |
		    ForEach-Object {Remove-Variable -Name ($_) -Scope "Global" -Force}
			
			If ($Global:WindowsToolsDefaults.NoTips -eq $true) {
				Show-WindowsToolsHeader -NoTips
			}
			ElseIf ($Global:WindowsToolsDefaults.NoHeader -eq $false) {
				Show-WindowsToolsHeader
			}
			
			# Clear Errors
			$Error.Clear()
		
		#region Reset UI
	
	#endregion Tasks
	
}

#region Notes

<# Description
	Clean up the screen and variables when WindowsTools CmdLet finishes.
#>

<# Author
	Levon Becker
	PowerShell.Guru@BonusBits.com
	http://www.bonusbits.com
#>

<# Dependents
Get-DiskSpace
Get-HostInfo
Move-AdComputer
Switch-Content
Get-InactiveComputers
Restart-Hosts
#>

<# Dependencies
#>

<# To Do List
	
#>

<# Change Log
1.0.0 - 05/10/2012
	Created
1.0.1 - 12/26/2012
	Added Switch parameter to skip prompt
1.0.3 - 12/27/2012
	Switched to Func_Show-WindowsToolsHeader 1.0.3
1.0.4 - 01/09/2013
	Removed SubScript Parameter
	Removed dot sourcing SubScripts
#>	

#endregion Notes
