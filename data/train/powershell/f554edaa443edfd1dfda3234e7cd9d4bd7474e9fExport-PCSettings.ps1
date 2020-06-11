<#
.SYNOPSIS
   Script to Export key settings to a memory stick
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER UsbDrive
   The drive letter of a USB drive where the settings will be copied.  If omitted, the script will use the first removable drive.
.EXAMPLE
   <An example of using the script>
#>

#
# 
#

param ([string]$UsbDrive)

#region StandardInitialisation
#
# The script can take hours to run on a large dataset
# We need to report progress.  For short-ish tasks, up to about 30s
# we simply need to use Write-Host to output timely status messages
#
# (we use Write-Progress to show progress of longer tasks)
#
$ScriptElapsedTime = [System.Diagnostics.Stopwatch]::StartNew()

$lastt = 0

function reportPhaseComplete ([string]$description) {
  $t = $ScriptElapsedTime.Elapsed.TotalSeconds
  $phaset = [Math]::Floor(($t - $script:lastt) * 10) / 10
  write-host "Phase complete, taking $phaset seconds: $description"
  $script:lastt = $t
}

#
# standard functions to find the directory in which the script is executing
# we'll use this info to read and write both cache files and reports
#
function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

$sdir = Get-ScriptDirectory
#endregion

#region FileInitialisation
#
# Having identified the current working directory, we can now set up paths for the
# various cache files and report files used by the script.
#
$FeatureCacheFile       = $sdir + "\" + "AllFeatures.csv"                          # These files are shared by many jobs
#endregion

$logicalDisks = Get-WmiObject Win32_LogicalDisk
$logicalDisks | Format-Table

$computerSystem = Get-WmiObject Win32_ComputerSystem

$logicalDisks | foreach {
  if ($_.DriveType -eq 2) {
    if ($UsbDrive -eq "") {
	  $UsbDrive = $_.DeviceID
	}
  }
}

while ($UsbDrive -eq "") {
  $UsbDrive = Read-Host "Enter drive letter (with colon) of USB drive"
}

if ($UsbDrive -match "^([A-Z]):?$") {
  $UsbPath = $Matches[1] + ":\Configuration\" + $computerSystem.Name
  mkdir $UsbPath -Force -ErrorAction SilentlyContinue | Out-Null
} else {
  Write-Host "Invalid path for USB drive - $UsbDrive"
  exit 0
}

Write-Host "using USB path $UsbPath"

systeminfo /fo csv > "${UsbPath}\systeminfo.csv"

net use > "${UsbPath}\NetUse.txt"

net share > "${UsbPath}\NetShare.txt"

$logicalDisks | Export-Csv -NoTypeInformation "${UsbPath}\LogicalDisks.csv"

$appDataRoaming = $env:appdata

#
# Apps, etc
#

New-PSDrive -Name Uninstall -PSProvider Registry -Root HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall -ea SilentlyContinue | out-null
New-PSDrive -Name Uninstall32 -PSProvider Registry -Root HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall -ea SilentlyContinue | out-null
$allProgs = Get-ChildItem -Path @("Uninstall:","Uninstall32:") -ea SilentlyContinue | ForEach-Object -Process {
  $q = $_
  $dn = $q.GetValue("DisplayName") 
  # write-host $dn
  $dp = $q.GetValue("Publisher") 
  $dv = $q.GetValue("DisplayVersion") 
  $cs = New-Object Object |
    Add-Member NoteProperty Product      $dn           -PassThru |
    Add-Member NoteProperty Publisher    $dp           -PassThru |
    Add-Member NoteProperty Version      $dv           -PassThru
  $cs
} | Where-Object { [string]$_.Product -ne "" } | Sort-Object -Property Product

$allProgs | Export-Csv -NoTypeInformation "${UsbPath}\AllPrograms.csv"
#
# Eudora
#

$eudoraPath = Join-Path $appDataRoaming "QualComm\Eudora"

$scooterPath = Join-Path $appDataRoaming "Scooter Software\Beyond Compare 4"

$mp3tagPath = Join-Path $appDataRoaming "Mp3tag"

#
# copy all SerialNo*.* files from the download folders
#
Get-ChildItem P:\download* -Include SerialNo*.* -Recurse | foreach {
  $fileObj = $_
  $sourceFolder = $fileObj.DirectoryName
  $sourceName = $fileObj.Name
  $targetFolder = $sourceFolder -replace "P:",""
  $targetFolder = Join-Path ${UsbPath} $targetFolder
  $targetFile = Join-Path $targetFolder $sourceName
  mkdir $targetFolder -Force -ErrorAction SilentlyContinue | Out-Null
  Copy-Item -LiteralPath $fileObj.FullName -Destination $targetFile
}

while ((Get-Process Eudora -ErrorAction SilentlyContinue) -ne $null) {
  Read-host "Please close Eudora, then hit return to continue"
}

# xcopy $eudoraPath "${UsbPath}\Eudora" /e /c /i /f /h /r 

# mkdir $UsbPath\Eudora -Force -ErrorAction SilentlyContinue | Out-Null
# mkdir $UsbPath\Projects -Force -ErrorAction SilentlyContinue | Out-Null
# mkdir "$UsbPath\Download\Scooter Software" -Force -ErrorAction SilentlyContinue | Out-Null

$bcCommand =@"
# Load the base folders.
load create:right "${eudoraPath}" "${UsbPath}\Eudora"
filter include-protected
# Copy different files left to right, delete orphans on right.
sync create-empty mirror:left->right
#
load create:right "${scooterPath}" "${UsbPath}\AppSettings\Scooter Software"
sync create-empty mirror:left->right
#
load create:right "${mp3tagPath}" "${UsbPath}\AppSettings\Mp3tag"
sync create-empty mirror:left->right
#
load create:right "P:\Download\Scooter Software" "${UsbPath}\Download\Scooter Software"
sync create-empty mirror:left->right
#
load create:right "P:\Download\ASROCK" "${UsbPath}\Download\ASROCK"
sync create-empty mirror:left->right
#
load create:right "P:\Download\ATI" "${UsbPath}\Download\ATI"
sync create-empty mirror:left->right
#
load create:right "P:\Download\Avast" "${UsbPath}\Download\Avast"
sync create-empty mirror:left->right
#
load create:right "P:\Download\Idrive" "${UsbPath}\Download\Idrive"
sync create-empty mirror:left->right
#
load create:right "P:\Download\iiyama" "${UsbPath}\Download\iiyama"
sync create-empty mirror:left->right
#
load create:right "P:\Download\Microsoft\Powershell" "${UsbPath}\Download\Microsoft\Powershell"
sync create-empty mirror:left->right
#
load create:right "P:\Download\Notepad++" "${UsbPath}\Download\Notepad++"
sync create-empty mirror:left->right
#
load create:right "P:\Download\Qualcomm" "${UsbPath}\Download\Qualcomm"
sync create-empty mirror:left->right
#
load create:right "P:\Download\Ron's Editor (CSV)" "${UsbPath}\Download\Ron's Editor (CSV)"
sync create-empty mirror:left->right
#
load create:right "P:\Projects\Utilities" "${UsbPath}\Projects\Utilities"
sync create-empty mirror:left->right
#
# copy left->right
# expand all
# select left.newer.files left.orphan.files
# select empty.folders
"@

$bcCommand | Set-Content "$sdir\CopyEudora.txt"

& "C:\Program Files (x86)\Beyond Compare 4\BCompare.exe" @$sdir\CopyEudora.txt

Write-Host "Done"
