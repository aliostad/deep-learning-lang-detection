###################################################################################
#  Global variables
###################################################################################
$buildNumber = "1.0.0.0"
$binariesDirectory = ""
$sourcesDirectory = ""
$clientConfigFile = ""

$serverBinDir = "C:\Program Files\Microsoft Dynamics AX\60\Server\MicrosoftDynamicsAX\Bin\"
$clientBinDir = "C:\Program Files (x86)\Microsoft Dynamics AX\60\Client\Bin" 
$dbServer = "(local)\AXDEV"
$dbName = "MicrosoftDynamicsAX"
$modelDbName = "MicrosoftDynamicsAX_model"
$aosInstance = "01"
$aosServiceName = "AOS60`$${aosInstance}"

# AXBuild constants
$axBuildLogPath = "C:\Program Files\Microsoft Dynamics AX\60\Server\MicrosoftDynamicsAX\Log"
$axBuildWorkerCount = 8

# Backup constants
$sqlDestination = "C:\Program Files\Microsoft SQL Server\MSSQL12.AXDEV\MSSQL\DATA"

###################################################################################
# Import assemblies and types
###################################################################################
Import-Module $PSScriptRoot\axhelpers.psm1
Import-Module $PSScriptRoot\SqlServerHelpers.psm1
Add-Type -Path ([System.IO.Path]::Combine($PSScriptRoot, "CodeCrib.Ax.Client.dll"))
Add-Type -Path ([System.IO.Path]::Combine($PSScriptRoot, "CodeCrib.Ax.Manage.dll"))
Add-Type -Path ([System.IO.Path]::Combine($PSScriptRoot, "CodeCrib.Ax.AXBuild.dll"))
Import-Module $PSScriptRoot\CodeCrib.AX.Config.PowerShell.dll
Import-Module "C:\Program Files\Microsoft Dynamics AX\60\ManagementUtilities\Modules\AXUtilLib.Powershell\AXUtilLib.PowerShell.dll"
Import-Module "C:\Program Files\Microsoft Dynamics AX\60\ManagementUtilities\Modules\Microsoft.Dynamics.AX.Framework.Management\Microsoft.Dynamics.AX.Framework.Management.dll"

###################################################################################
# Main build script
###################################################################################

try 
{
	$ErrorActionPreference = "Stop"
  
	# NOTE WELL: This test will need to be changed if we move away from TFSBuild
	if(-not (Test-Path env:BUILD_BUILDNUMBER))
	{   
		throw "Unable to locate build number from environment, exiting"
		exit -1
	}

	$buildNumber = $env:BUILD_BUILDNUMBER
	$binariesDirectory = $env:BUILD_STAGINGDIRECTORY
    $sourcesDirectory = $env:BUILD_SOURCESDIRECTORY 
	$clientConfigFile = [System.IO.Path]::Combine($sourcesDirectory, "Config", "build-client.axc")
	$isAutomatedBuild = $true;

	if(-not (Test-Path -Path "$binariesDirectory")) 
	{
		throw "Binaries directory does not exist, exiting"
        exit -1
	}

	$axModelFile = "${binariesDirectory}/${buildNumber}.axmodel"
		
	if(-not (Test-Path -Path "$axModelFile"))
	{
		throw "Unable to read axmodel file '$axModelFile',  exiting"
		exit -1
	}

    if(-not (Test-Path -Path "$clientConfigFile"))
    {
        throw "Unable to read client configuration file '$clientConfigFile', exiting"
        exit -1
    }

	Write-Host "###################################################################################"
	Write-Host "Build Settings"
	Write-Host "###################################################################################"
	Write-Host "Build Number       : ${buildNumber}"
	Write-Host "Binaries Directory : ${binariesDirectory}"
	Write-Host "AX Client Config   : ${clientConfigFile}"
	Write-Host "###################################################################################"

	if(Test-ServiceIsRunning -Name $aosServiceName)
	{
  		Stop-Service -Name $aosServiceName -WarningAction SilentlyContinue
	}
	
	$databaseDir = "c:\artifacts\Build Server Backups\Dev Backups"			

	FormatBuildEvent -source "ExportModelStore" -level "Info" -message "Restoring dev databases"

    $dbs = Get-BackupFiles -BackupRoot "$databaseDir" -Type transactional			
    Restore-Database -ServerInstance $dbServer -Database $dbName -BackupFile $dbs -Destination "$sqlDestination"

    $dbs = Get-BackupFiles -BackupRoot "$databaseDir" -Type model 
    Restore-Database -ServerInstance $dbServer -Database $modelDbName -BackupFile $dbs -Destination "$sqlDestination"
	
    FormatBuildEvent -source "ExportModelStore" -level "Info" -message "Installing model from binaries directory"
		
	Install-AxModel -Database $modelDbName -Server $dbServer -File "$axModelFile" -NoPrompt -Verbose 
	
    if($? -eq $false)
    {
        throw "Installing the model failed,  see build log for more information"		
    }

    # Remove the "Model store has been modified" dialog so our operations work...
    Set-AXModelStore -Server $dbServer -Database $modelDbName -NoInstallMode

	FormatBuildEvent -source "ExportModelStore" -level "Info" -message "Cleaning up from previous builds"
	Clear-AXCacheFolders -serverBinDir $serverBinDir

	FormatBuildEvent -source "ExportModelStore" -level "Info" -message "Performing full compile via AXBuild"
    Invoke-AxBuild -ClientBinDir $clientBinDir -ServerBinDir $serverBinDir -AosInstanceId $aosInstance -DatabaseServer $dbServer -ModelDatabase $modelDbName -AXBuildLogPath $axBuildLogPath -DropDir $binariesDirectory -CopyLogFile $false -timeoutInMinutes 60

	Start-Service -Name $aosServiceName -WarningAction SilentlyContinue

	FormatBuildEvent -source "ExportModelStore" -level "Info" -message  "Performing CIL regeneration"
	Invoke-CILGeneration -ClientConfigFile "$clientConfigFile" -timeoutInMinutes 90

	FormatBuildEvent -source "ExportModelStore" -level "Info" -message  "Performing database synchronisation"
	Invoke-DatabaseSynchronisation -ClientConfigFile "$clientConfigFile" -timeoutInMinutes 90
    
	$axModelFile = [System.IO.Path]::Combine($binariesDirectory,  $buildNumber + ".axmodelstore")
	FormatBuildEvent -source "ExportModelStore" -level "Info" -message  "Exporting model file to '${axModelFile}'"
	Export-AXModelStore -Server $dbServer -Database $modelDbName -File "$axModelFile"

	if($? -eq $false)
	{
		throw "Exporting the modelstore file failed."
	}

	$buildRoot = Split-Path -parent $binariesDirectory

	# Copy deployment script, it's dependencies, and AX config files.
	Copy-Item "$sourcesDirectory/Scripts/deploy.ps1" -Destination "${binariesDirectory}"
	Copy-Item "$sourcesDirectory/Scripts/axhelpers.psm1" -Destination "${binariesDirectory}"
	Copy-Item "$sourcesDirectory/Scripts/CodeCrib.AX.Client.dll" -Destination "${binariesDirectory}"
	Copy-Item "$sourcesDirectory/Scripts/CodeCrib.AX.Config.dll" -Destination "${binariesDirectory}"
	Copy-Item "$sourcesDirectory/Scripts/CodeCrib.AX.Config.PowerShell.dll" -Destination "${binariesDirectory}"
    New-Item -Path "${binariesDirectory}/Config" -itemtype "directory"
	Copy-Item "$sourcesDirectory/Config/*" -Destination "${binariesDirectory}/Config"

	# Compress the model store as it's massive.
	$cmd = "$sourcesDirectory/BuildTools/7Zip/7za.exe"
	$params = "a", "${axModelFile}.zip", "$axModelFile"	
	& "$cmd" $params

	# remove the now-compressed model store.
	Remove-Item -Path "$axModelFile" -Exclude "${axModelFile}.zip" 
	
    FormatBuildEvent -source "ExportModelStore" -level "Info" -message "Success!"
} 
catch
{
	$exception = $_.Exception | Format-List -force | Out-String	
	FormatBuildEvent -source "ExportModelStore" -level "Error" -message "Unable to export model store: '$exception'"
	exit -1
}