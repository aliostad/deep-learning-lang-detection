#Keep these two lines
Param ([ref]$result)
. ..\utility.ps1

#You can get config value like this:
#$value = getConfValue "sample"
$AzCopyMsiPath = getConfValue "AzCopyMsiPath"

& $AzCopyMsiPath

if (-not (yesOrNo "Does the installer appear?")) {
    $result.value = $false
    return
}

ack "Please finish the installation. If the installation is finished, enter y to continue."

#Submit a task to get the AzCopy Path
$AzCopyPathCode = { 
    $CurrentAzCopy = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Azure Storage Tools*"}
    if( -not [bool] $CurrentAzCopy ) {
        return ""
    }
    $AzCopyPath = [string]$CurrentAzCopy.InstallLocation + "AzCopy\AzCopy.exe"    
    $AzCopyPath
}
$AzCopyPathJob = Start-Job -ScriptBlock $AzCopyPathCode

#Check Add/Remove Program
ack "Now the Add/Remove Program wizard will appear, you should check if the version of the AzCopy item is correct, and the old version is removed."
& appwiz.cpl
if (-not (yesOrNo "Is the version of the AzCopy item correct?")) {
    $result.value = $false
    return
}
if (-not (yesOrNo "Is there no old version of the AzCopy?")) {
    $result.value = $false
    return
}
ack "Please close the Add/Remove Program wizard, and enter y to continue."

#Addtional Check of Start menu and Install Folder
ack "Now the Start Menu Folder will appear, you should check if the AzCopy folder is correct, and the old version is removed."
& explorer.exe "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
if (-not (yesOrNo "Is the AzCopy folder correct?")) {
    $result.value = $false
    return
}
if (-not (yesOrNo "Is there no old version folder of the AzCopy?")) {
    $result.value = $false
    return
}
ack "Please close the Start Menu Folder, and enter y to continue."

#Wait for the AzCopyPath
$Waitjob = Wait-Job $AzCopyPathJob
$AzCopyPath = Receive-Job $AzCopyPathJob

#Addtional Check of Install Folder
$installFolder = Split-Path -parent(Split-Path -parent(Split-Path -parent $AzCopyPath))
ack "Now the Install Folder will appear, you should check if the AzCopy folder is correct, and the old version is removed."
& explorer.exe $installFolder
if (-not (yesOrNo "Is the AzCopy folder correct?")) {
    $result.value = $false
    return
}
if (-not (yesOrNo "Is there no old version folder of the AzCopy?")) {
    $result.value = $false
    return
}
ack "Please close the Install Folder, and enter y to continue."
$passed = $true
#Return test result
if ($passed) {
    $result.value = $true
} else {
    $result.value = $false
}