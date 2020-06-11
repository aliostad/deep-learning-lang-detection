."$PSScriptRoot\Start-ProcessWithPipe.ps1"

function Run-AsTrustedInstaller {
 [CmdletBinding()]
 param (
  [System.Management.Automation.InvocationInfo]$Invocation = (Get-Variable -Name 'MyInvocation' -ValueOnly -Scope 1), ## Must be passed from calling function if calling function is part of module
  [System.Management.Automation.SwitchParameter]$Show = $false
 )

 $modules = Get-Command | Select-Object -ExpandProperty ModuleName -Unique | Where-Object {$_ -match '\.'}
 $modulesString = "('" + [string]::Join("', '", $modules) + "')"
 $scriptContent  =          "foreach (`$module in $modulesString) {try {Import-Module -Name `$module -ErrorAction 'SilentlyContinue'} catch {}}"
<# Functions
 foreach ($function in (Get-Command -CommandType 'Function' | Where-Object {-not $_.ModuleName -and $_.Verb})) {
  $scriptContent += "`r`n" + 'function global:' + $function.Name + ' {' + $function.Definition + '}'
 }
# /Functions#>
 $scriptContent += "`r`n" + $Invocation.MyCommand.ScriptBlock.Ast.Extent.Text
 $scriptContent += "`r`n" + $Invocation.Line

 if ($Show) {
  $windowStyle = 'Normal'
 }
 else {
  $windowStyle = 'Hidden'
 }

 Write-Host ('Executing ' + $Invocation.Line + ' as TrustedInstaller')

 Start-ProcessWithPipe -RemoteInvocation ([scriptblock]::Create($scriptContent)) -Impersonate (Get-Service -Name 'TrustedInstaller') #-NoExit #-Verbose

 return $null
}