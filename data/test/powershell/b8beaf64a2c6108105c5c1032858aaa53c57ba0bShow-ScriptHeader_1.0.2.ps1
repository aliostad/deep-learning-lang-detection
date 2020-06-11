#requires –version 2.0

Function Show-ScriptHeader {
	Param (
		[parameter(Mandatory=$false)][int]$BlankLines = '1',
		[parameter(Mandatory=$false)][int]$DashCount = '50',
		[parameter(Mandatory=$true)][string]$ScriptTitle
	)
	# VARIABLES
	[string]$Notes = ''
	[boolean]$Success = $false
	[datetime]$SubStartTime = Get-Date
	
	#region Task
	
		# 4 spaces are needed if progress bar displayed and 1 if not
		Clear
		
		# Create Dash Underline
		Write-Host $ScriptTitle -ForegroundColor Green
		[int]$DoCount = 0
		Do {
			$DoCount++
			Write-Host '-' -ForegroundColor Green -NoNewline
		}
		Until ($DoCount -eq $DashCount)
		Write-Host ''
		
		# Set Spaces after Dashed Line
		[int]$DoCount = '0'
		Do {
			$DoCount++
			Write-Host ''
		}
		Until ($DoCount -eq $BlankLines)
	
	#endregion Task
	
}

#region Notes

<# Description
	Clear the screen and show script information at the top of the screen.
#>

<# Author
	Levon Becker
	PowerShell.Guru@BonusBits.com
	http://www.bonusbits.com
#>

<# Dependents
	Install-Patches
	Test-WSUSClient
	Get-WSUSClients
	Get-WSUSFailedClients
	Get-PendingUpdates
	Move-WSUSClientToGroup
	Get-DriveSpace
	Restart-Hosts
	Get-InactiveComputers
	Move-ADComputers
	Get-HostInfo
#>

<# Dependencies
	Get-Runtime
#>

<# Change Log
	1.0.0 - 02/11/2012
		Created
	1.0.1 - 04/16/2012
		Changed version scheme.
		Added Dashcount parameter and logic.
		Moved Info section to end.
	1.0.2 - 05/03/2012
		Renamed Function from Set-Header to Show-ScriptHeader
		Some more variable and parameter renames to fit the my latest standards
#>

#endregion Notes
