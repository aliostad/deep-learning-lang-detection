#=============================================================================
# Project: Baobab
# Author: Tobias Kiertscher
# Name: Set-IniFileValue.ps1
# Description: 
#   Writes a value in an INI-file.
# Parameter: 
#   - iniFile: 
#       The path to the INI-file
#   - category:
#       The target category
#   - key:
#       The key of the value
#   - value:
#       The new value
# Dependencies: 
#   Load-Assembly.ps1
#   FileSystemToolbox.dll
#=============================================================================

param (
	[string]$iniFile,
	[string]$category,
	[string]$key,
	[string]$value
)

Write-Verbose "+++ Set-IniFileValue.ps1"

$scriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
& "$scriptRoot\Load-Assembly.ps1" "FileSystemToolbox"

[net.kiertscher.toolbox.filesystem.IniFile]::SetValue($iniFile, $category, $key, $value)

Write-Verbose "--- Set-IniFileValue.ps1"
