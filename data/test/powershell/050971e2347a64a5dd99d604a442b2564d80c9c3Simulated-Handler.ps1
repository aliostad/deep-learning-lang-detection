param( 
		$action,
		$debugMode 
	)
	
	if ($debugMode) {
		$debugPreference = 2
	}
	
	$processStartTime = Get-Date
	
	$commonFolder = Resolve-Path "$($action.workingDir)\..\common"
	. "$commonFolder\Messages.ps1" 
	
	$primaryResult = Get-StandardResultMessage $action.name
	$primaryResult.message.content = "Simulation"
	
    Start-Sleep -s (Get-Random -Maximum 1 -Minimum 0)
 
	$primaryResult.duration = (Get-Date).Subtract($processStartTime).TotalSeconds
	
	Write-Output $primaryResult

	

