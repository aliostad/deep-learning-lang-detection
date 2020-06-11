$rootPath = $args[0]
$backupRootPath = $args[1]
$featureJsonFileName = "feature.json"

$featureVersionPath = ""
$featureVersionBackupPath = ""

##################################################################################
# Initialize the default script exit code.
$exitCode = 0

##################################################################################
# Format errors to be more verbose.
trap
{
  $e = $error[0].Exception
  $e.Message
  $e.StackTrace
  if ($exitCode -eq 0) { $exitCode = 1 }
}

function Get-Deployment-Path
{
  param
  (
    [string]$rootPath = $(throw "The rootPath must be provided."),
    [string]$backupRootPath = $(throw "The backupRootPath must be provided."),
    [string]$featureJsonFileName = $(throw "The featureJsonFileName must be provided.")
  )
  
  $featureJson = Get-Content $featureJsonFileName -Raw | ConvertFrom-Json
  $localFeatureVersionPath = $rootPath + "\" + $featureJson.featureId + "\" + $featureJson.featureVersion
  $localFeatureVersionBackupPath = $backupRootPath + "\" + $featureJson.featureId + "\" + $featureJson.featureVersion
  
  Set-Variable -Name featureVersionPath -Value $localFeatureVersionPath -Scope "Script"
  Set-Variable -Name featureVersionBackupPath -Value $localFeatureVersionBackupPath -Scope "Script"
}

function Delete-Files
{
  param
  (
    [string]$featureVersionPath = $(throw "The featureVersionPath must be provided.")
  )
  Write-Host "Delete-Files FeatureVersionPath = $featureVersionPath"
  
  ./ManageWindowsIO.ps1 -Action Delete -FileFolderName "$featureVersionPath"
    
}

function Restore-Backup-Files
{
  param
  (
    [string]$featureVersionPath = $(throw "The featureVersionPath must be provided."),
    [string]$featureVersionBackupPath = $(throw "The featureVersionBackupPath must be provided.")
  )
  Write-Host "Backup-Files FeatureVersionPath = $featureVersionPath"
  Write-Host "Backup-Files FeatureVersionBackupPath = $featureVersionBackupPath"
  if ((Test-Path -PathType Container -Path $featureVersionBackupPath) -or
          (Test-Path -PathType Leaf -Path $featureVersionBackupPath))
    {
        ./irxcopy.cmd $featureVersionBackupPath $featureVersionPath 
    }   
}


##################################################################################  
# Check for an exit code 
if ($exitCode -eq 0)
{
  try
  {
    # Set up variables.
    Get-Deployment-Path -rootPath $rootPath -backupRootPath $backupRootPath -featureJsonFileName $featureJsonFileName
    Write-Host "FeatureVersionPath = $featureVersionPath"
    Write-Host "FeatureVersionBackupPath = $featureVersionBackupPath"
    #Create a backup of current feature
    Delete-Files -featureVersionPath $featureVersionPath
    Restore-Backup-Files -featureVersionPath $featureVersionPath -featureVersionBackupPath $featureVersionBackupPath
  }
  catch [System.Exception]
  {
    # Prevent further execution.
    if ($exitCode -eq 0) { $exitCode = 1 }
    #Write-Eventlog -logname 'Application' -source 'Application' -eventID 1000 -EntryType Error -message $_.Exception.Message
    Write-Host "Error restoring backup files."
    Write-Host $_.Exception.Message "`n" -ForegroundColor Red
  }
}

##################################################################################
# Analyze the result of the execution.

# Determine if we have an error with the process.
if ($exitCode -eq 0)
{
  "The script completed successfully.`n"
}
else
{
  $err = "Exiting with error: " + $exitCode + "`n"
  Write-Host $err -ForegroundColor Red
}