# vim:ts=4
<#

###
#
# This is the basic structure template for PowerShell program files, since PowerShell has no forward lookups
# (driven by the desire to have the main code body at the top of the file)
#
###

Description block here.
	Name:
	Component of:
	Caller:
	Calls:
	Input data source and conditions:
	Data transformations or outputs:
	Data condition on exit:
	Logging:
	Exception handling:
#>

param
(
	[string]$target,	# target host name
	[switch]$test,		# boolean
	[switch]$debug		# boolean
)

function Main
{
	if (-not ($target)) {
		&showUsage
	}

	if ($debug) {
		# Default is "SilentlyContinue", AKA no debug messages
		$debugpreference = "Continue"
	}

	#############
	# code here #
	#############

}

###
#
# Subroutines
#
###

# Get-AdminStatus - return Boolean on administrative privileges
# from:  http://gallery.technet.microsoft.com/scriptcenter/fabd7cba-1f58-4d61-bded-0414296f9eea
function Get-AdminStatus 
{ 
    ([Security.Principal.WindowsPrincipal] `
	 [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
} 


# showUsage - show parameters expected, optional
function showUsage
{
	Write-Host -BackgroundColor Black -ForegroundColor DarkYellow `
		"`nUsage:`n`tSnippets.ps1  This file is not meant to actually run.`n"
	exitOK
}


# exitOK - exit under "good" conditions, return errorlevel 0
# references possible global "$sess" for open sessions to remote machines
function exitOK
{
	if ($sess) {
		Remove-PSSession $sess
	}
	echo "$args"
	Start-Sleep 1
	exit 0
}

# exitNG - exit under "not good" conditions, return errorlevel 1
# references possible global "$sess" for open sessions to remote machines
function exitNG
{
	if ($sess) {
		Remove-PSSession $sess
	}
	if ($args) {
		Write-Host -BackgroundColor White -ForegroundColor Red "`n !!! $args !!! `n"
	}
	Start-Sleep 5
	exit 1
}

# No forward references in PSHell.  Run main here.
Main

