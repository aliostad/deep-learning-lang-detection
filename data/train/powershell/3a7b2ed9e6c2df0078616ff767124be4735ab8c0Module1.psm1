<#

.Synopsis
Sample PowerShell Script Module containing a
single function "Show-Greeting"

.Description
Displays Message Box with user-specified greeting

.Parameter Greeting
The message to display

.Example
Show-Greeting -Greeting "Hello World!"

#>


Function Show-Greeting {
  param($Greeting="Default Message")
  $shell = New-Object -COM "WScript.Shell"
  $int = $shell.PopUp($Greeting,5,"Show-Greeting")
  If ($int -eq 1){Write-Host "User clicked OK"}
  Else {Write-Host "Popup timed out"}
  }

Export-ModuleMember -function Show-Greeting
 
 