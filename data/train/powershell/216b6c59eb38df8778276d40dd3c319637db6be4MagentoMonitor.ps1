### 2016-2-5
## gregclark2k11@gmail.com
# file movement system

$userMessage = "running time"
$rootDirectory = "C:\FolderMonitorSystem"
$corefunctions = "corefunctions\corefunctions.ps1"

$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
try { . ("$ScriptDirectory\configMagento.ps1") }
catch {
    Write-Host "unable to load configMagento.ps1 file" 
    logThis -message "unable to load configMagento.ps1 file" -destination "$logDirectory\$logFile"
}


try { .("$rootDirectory\$corefunctions") }
catch {
    Write-Host "unable to load core functions at" 
    logThis -message "unable to load core functions at" -destination "$logDirectory\$logFile"
}

$userMessage

#transfer to remote location
convertWindowsPathToCygwinPath -windowsPath $moveFrom -logLocation "$logDirectory\$logFile"

#archive files
moveFilesLocally -moveFrom $moveFrom -moveTo $moveToLocalDirectory -moveWhat $moveWhatFiles -logLocation "$logDirectory\$logFile"



$timeStamp
Start-Sleep -s 2
exit
