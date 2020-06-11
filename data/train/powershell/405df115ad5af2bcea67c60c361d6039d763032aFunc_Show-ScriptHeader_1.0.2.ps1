#requires –version 2.0

Function Show-ScriptHeader {
	Param (
		[parameter(Mandatory=$false)][int]$blanklines = '1',
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
		[int]$docount = 0
		Do {
			$docount++
			Write-Host '-' -ForegroundColor Green -NoNewline
		}
		Until ($docount -eq $DashCount)
		Write-Host ''
		
		# Set Spaces after Dashed Line
		[int]$docount = '0'
		Do {
			$docount++
			Write-Host ''
		}
		Until ($docount -eq $blanklines)
	
	#endregion Task
	
}

#region Notes

<# Header
	VERSION: 	1.0.2
	FUNC-NAME:	Show-ScriptHeader
	PURPOSE:	UI Header for Parent Scripts
	AUTHOR:		Levon Becker
	NOTES:		
#>

<# Dependents
	Windows-Patching
	Replace-Content
	Check-WSUSClient
#>

<# Dependencies
	Func_Get-Runtime
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
