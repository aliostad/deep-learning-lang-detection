
#Load DLLs as byte stream.(don't want to lock dll)
$dllPath =  Join-Path $PSScriptRoot "PSCodeAnalyzer.dll"
$dllBytes = [IO.File]::ReadAllBytes($dllPath)
[System.Reflection.Assembly]::Load($dllBytes) > $null

if ($host.Name -ne "Windows PowerShell ISE Host"){
    return
}

#region PowerShell ISE Addin registration
$dllPath = Join-Path $PSScriptRoot "PSCodeAnalyzer.ISEAddin.dll"
$dllBytes = [IO.File]::ReadAllBytes($dllPath)
[System.Reflection.Assembly]::Load($dllBytes) > $null

#Register ISE menus
[PSCodeAnalyzer.ISEAddin]::Initialize($psIse)

#Register Cmdlets
function Format-CurrentDocument
{
	[CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet("Document", "Selection")]
        [string] $Range
    )
  
    [PSCodeAnalyzer.ISEAddin]::FormatCurrentDocument($psISE,$Range)
}

#endregion
