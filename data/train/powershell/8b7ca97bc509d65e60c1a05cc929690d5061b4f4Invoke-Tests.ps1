#requires -version 2.0

[CmdletBinding()]
param
(
    [string] $Path = "Tests",
    [string] $Filter = "*.Tests.ps1",
    [bool] $Recurse = $true,
    [bool] $ShowOutput = $false,
    [bool] $ShowErrors = $true,
    [bool] $ShowStackTrace = $false,
    [string] $TestFixtureFilter = "*",
    [string] $TestFilter = "*"
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
function PSScriptRoot { $MyInvocation.ScriptName | Split-Path }
Trap { throw $_ }

if ((Get-Module PoshUnit) -eq $null)
{
    $poshUnitFolder = if (Test-Path "$(PSScriptRoot)\PoshUnit.Dev.txt") { $(PSScriptRoot) } else { "$(PSScriptRoot)\packages\PoshUnit" }

    $poshUnitModuleFile = "$poshUnitFolder\PoshUnit.psm1"

    if (-not (Test-Path $poshUnitModuleFile))
    {
        throw "$poshUnitModuleFile is not found"
    }

    Import-Module $poshUnitModuleFile
}

Invoke-PoshUnit -Path $Path -Filter $Filter -Recurse $Recurse -ShowOutput $ShowOutput -ShowErrors $ShowErrors -ShowStackTrace $ShowStackTrace -TestFixtureFilter $TestFixtureFilter -TestFilter $TestFilter