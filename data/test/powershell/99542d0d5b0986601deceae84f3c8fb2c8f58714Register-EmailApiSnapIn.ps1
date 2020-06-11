
#Register-EmailApiSnapIn.ps1
#
#This script registers the SnapIn with .NET so that it can easily be used within Powrshell

param
(
	$snapIn = "EmailApiSnapIn.dll"
)

function Get-FrameworkDirectory()
{
    $([System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory())
}

if(-not (test-path $snapIn)){
    throw "EmailApiSnapIn not found at the following location: '$snapIn'"
}

#Use InstallUtil.exe to register the SnapIn
. (Join-Path (Get-FrameworkDirectory) 'InstallUtil.exe') $snapIn
    