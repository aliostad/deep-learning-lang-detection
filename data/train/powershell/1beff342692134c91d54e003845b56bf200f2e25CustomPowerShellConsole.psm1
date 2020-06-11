Set-StrictMode -Version Latest

$ModuleHelpersFolder = Join-Path $PSScriptRoot "Helpers"
. (Join-Path $ModuleHelpersFolder "Module Pre-Init.ps1")

if ($ModuleInitLevel -le 1) {
	$validationProblems = Test-PowerShellDirectory -Directory $PSScriptRoot -Quiet -ReturnNumberOfProblems -Exclude "CustomPowerShellConsole.psd1"
	if ($validationProblems -gt 0) {
	    throw "PowerShell Console Module has $validationProblems errors, unable to continue."
	}
	
	Import-Module (Join-Path $ModuleHelpersFolder "Profiler.psm1") -Force
	
	Set-ProfilerStep Begin "FilterModuleInitializationSteps"
}
$moduleInitializationSteps = Get-Item -Path (Join-Path $PSScriptRoot "ModuleInitialization") -PipelineVariable ModuleInitializationDir |
								Get-ChildItem -Recurse -Filter "*.ps1" -File |
								Sort-Object -Property FullName |
								% {
									$stepMetaDataSection = [ScriptBlock]::Create((Get-Content -Path $_.FullName -ReadCount 2 -Raw))
									$moduleStepDetails = & $stepMetaDataSection -GetModuleStepDetails
									@{
										Name =  $_.FullName.Substring($ModuleInitializationDir.FullName.Length + 1)
										Path = $_.FullName
										RunLevel = $moduleStepDetails.RunLevel
										Critical = $moduleStepDetails.Critical
									}
								}
if ($ModuleInitLevel -le 1) { Set-ProfilerStep End }

$moduleLoadErrors = 0
foreach ($step in $moduleInitializationSteps) {
	if ($step.RunLevel -ne -1 -and $step.RunLevel -le $ModuleInitLevel) { continue }
	if ($ModuleInitLevel -le 1) { Set-ProfilerStep Begin $step.Name }
	try {
		. "$($step.Path)"
	}
	catch {
		$moduleLoadErrors++
		Write-Host -ForegroundColor Red "ERROR: Module initialization step '$($step.Name)' failed."
		Write-Host -ForegroundColor Red "Message - $($_.Exception.Message)"
		Write-Host -ForegroundColor Red "Script - $($_.InvocationInfo.ScriptName)"
		Write-Host -ForegroundColor Red "Line - $($_.InvocationInfo.ScriptLineNumber)"
		Write-Host -ForegroundColor Red "Column - $($_.InvocationInfo.OffsetInLine)"
		if ($step.Critical) {
			Write-Host -ForegroundColor Red "Module Step is critical, aborting initialization."
			break
		}
	}
	finally {
		if ($ModuleInitLevel -le 1) { Set-ProfilerStep End }
	}
}

Write-Host
if ($moduleLoadErrors -eq 0) {
	Write-Host -ForegroundColor Green "PowerShell Console Module successfully loaded"
} else {
	Write-Error "PowerShell Console Module encountered $moduleLoadErrors errors while loading"
}
