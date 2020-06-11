Import-Module .\LoadCandidateDataSet.psm1

$mdmUri = $env:NEXUS_MDM_URI
$dataSetPath = $env:NEXUS_DATASET_PATH
$dataSetNamesNoUpdate = $env:NEXUS_DATASET_NAMES_NO_UPDATE.split(",")
$dataSetNamesWithUpdate = $env:NEXUS_DATASET_NAMES_WITH_UPDATE.split(",")
$loaderExe = "..\MDM.Loader.exe"
$logPath = "..\logs"
$errorFileName = "Errors.err.txt"

$entityOrder = Get-EntityLoadOrder

Remove-LoaderLogFiles $logPath
    
$dataSetNamesNoUpdate | ForEach-Object { 
    Import-CandidateDataSet $loaderExe $mdmUri $entityOrder $dataSetPath $_.Trim() $logPath -runAsCandidate
}
    
$dataSetNamesWithUpdate | ForEach-Object { 
    Import-CandidateDataSet $loaderExe $mdmUri $entityOrder $dataSetPath $_.Trim() $logPath
}
    
Save-ErrorReport $logPath $errorFileName
