#*==========================================================================================
#* Created: 09/04/2014
#* Author: Lloyd Holman

#* Requirements:
#* 1. Install PowerShell 2.0+ on local machine
#* 2. Execute from build.bat

#* Parameters: -task* (The build task type to run).
#*	(*) denotes required parameter, all others are optional.

#* Example use to run the default Invoke-DebugCompile task:  
#* .\Start-ScheduledTasks.ps1

#*==========================================================================================
#* Purpose: Wraps the core Start-FemahBuildDefault.ps1 script and does the following
#* - starts by importing the psake PowerShell module (we have this in a relative path in source control) .
#* - it then invokes the default psake build script in the current working folder (i.e. Start-FemahBuildDefault.ps1),
#* passing the first parameter passed to the batch file in as the psake task.  Start-FemahBuildDefault.ps1 obviously does
#* all the build work for us.
#* - finally the psake PowerShell module is removed.

#*==========================================================================================
#*==========================================================================================
#* SCRIPT BODY
#*==========================================================================================
param([string]$task = "Invoke-Commit", [string]$msbuildPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe", [string]$configMode = "Release", [string]$buildCounter = "0", [string]$gitPath = "", [bool]$publishToLive = $False, [string]$githubApiKey = "", [string]$nugetApiKey = "")

Write-Host "Using the following parameter values (sensible defaults used where parameter not supplied)"
Write-Host "task: $task"
Write-Host "msbuildPath: $msbuildPath"
Write-Host "configMode: $configMode"
Write-Host "buildCounter: $buildCounter"
Write-Host "gitPath: $gitPath"
Write-Host "publishToLive: $publishToLive"
Write-Host "githubApiKey: $githubApiKey"
Write-Host "nugetApiKey: $nugetApiKey"

$basePath = Resolve-Path .
Import-Module "$basePath\lib\psake.4.3.1.0\tools\psake.psm1" 
#$psake
#$psake.use_exit_on_error = $true
Invoke-psake .\Start-FemahBuildDefault.ps1 -t $task -framework '4.0' -parameters @{"p1"=$msbuildPath;"p2"=$configMode;"p3"=$buildCounter;"p4"=$gitPath;"p5"=$publishToLive;"p6"=$githubApiKey;"p7"=$nugetApiKey} 
#$psake
Remove-Module [p]sake -ErrorAction 'SilentlyContinue'


