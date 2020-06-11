###################################################################################
#  Global variables
###################################################################################
$isAutomatedBuild = $false
$modelName = ""
$publisher = ""
$layer = ""
$manifestFile = ""
$buildNumber = "1.0.0.0"
$sourcesDirectory = ""
$binariesDirectory = ""
$clientConfigFile = "";

# Some defaults for our build
# TODO: Can we get these from the target configuration file / current active configuration?
$serverBinDir = "C:\Program Files\Microsoft Dynamics AX\60\Server\MicrosoftDynamicsAX\Bin\"
$clientBinDir = "C:\Program Files (x86)\Microsoft Dynamics AX\60\Client\Bin" 
$dbServer = "(local)\AXDEV"
$dbName = "MicrosoftDynamicsAX" 
$modelDbName = "MicrosoftDynamicsAX_model"
$aosInstance = "01"
$aosServiceName = "AOS60`$${aosInstance}"
$clientConfigFile = ""

# AXBuild constants
$axBuildLogPath = "C:\Program Files\Microsoft Dynamics AX\60\Server\MicrosoftDynamicsAX\Log"
$axBuildWorkerCount = 8

# Backup file location
$backupLocation = "\\CH-WV-FS-01\AXDev$\Source\Build Server Backups"
$sqlDestination = "C:\Program Files\Microsoft SQL Server\MSSQL12.AXDEV\MSSQL\DATA"

###################################################################################
# Import assemblies and types
###################################################################################
Import-Module $PSScriptRoot\axhelpers.psm1
Import-Module $PSScriptRoot\SqlServerHelpers.psm1
Unblock-File -Path $PSScriptRoot\CodeCrib.Ax.*.dll
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

	# NOTE WELL: These variables will need to be changed if we move away from TFSBuild
	if(!(Test-Path env:BUILD_BUILDNUMBER))
	{
		throw "Please run using TFS Build!"
	}

	$buildNumber = $env:BUILD_BUILDNUMBER
	$sourcesDirectory = $env:BUILD_SOURCESDIRECTORY
	$binariesDirectory = $env:BUILD_STAGINGDIRECTORY
	$clientConfigFile = [System.IO.Path]::Combine($sourcesDirectory, "Config", "build-client.axc")
	$isAutomatedBuild = $true;

	if(-not (Test-Path -Path "$binariesDirectory")) 
	{
		New-Item -Path "$binariesDirectory" -itemtype "directory"
	}

	$manifestFile = [System.IO.Path]::Combine($sourcesDirectory, "Connect Dev", "Model.xml") 

	if(-Not (Test-Path -Path $manifestFile)) 
	{
		throw "Unable to read model manifest file '$manifestFile',  exiting"
	}

	[CodeCrib.AX.Manage.ModelStore]::ExtractModelInfo($manifestFile, [ref] $publisher, [ref] $modelName, [ref] $layer)

	Write-Host "###################################################################################"
	Write-Host " Build Settings "
	Write-Host "###################################################################################"
	Write-Host "Build Number       : ${buildNumber}"
	Write-Host "Source Directory   : ${sourcesDirectory}"
	Write-Host "Binaries Directory : ${binariesDirectory}"
	Write-Host "AX Client Config   : ${clientConfigFile}"
	Write-Host "Is Automated Build : ${isAutomatedBuild}"
	Write-Host "Model Name         : ${modelName}"
	Write-Host "Publisher          : ${publisher}"
	Write-Host "Manifest location  : ${manifestFile}"
	Write-Host "###################################################################################"

	if(Test-ServiceIsRunning -Name $aosServiceName)
	{
		Stop-Service -Name $aosServiceName -WarningAction SilentlyContinue
	}

	FormatBuildEvent -source "Build" -level "Info" -message "Cleaning up from previous builds"
	Clear-AXCacheFolders -serverBinDir $serverBinDir

	if($isAutomatedBuild) 
	{
		$backupFolder = Create-BackupsFolder -BackupRoot "$backupLocation"
			
		$databaseDir = "$backupFolder\Dev Backups"
			
		FormatBuildEvent -source "Build" -level "Info" -message "Extracting backups from compressed Redgate format"
		Remove-Item -Path "$databaseDir\model_*.bak"
		Remove-Item -Path "$databaseDir\trans_*.bak"

		Uncompress-DatabaseBackup -BackupRoot "$databaseDir" -Type transactional
		Uncompress-DatabaseBackup -BackupRoot "$databaseDir" -Type model			

		FormatBuildEvent -source "Build" -level "Info" -message "Restoring dev environment"
			
    	$dbs = Get-BackupFiles -BackupRoot "$databaseDir" -Type transactional			
    	Restore-Database -ServerInstance $dbServer -Database $dbName -BackupFile $dbs -Destination "$sqlDestination"

    	$dbs = Get-BackupFiles -BackupRoot "$databaseDir" -Type model 
    	Restore-Database -ServerInstance $dbServer -Database $modelDbName -BackupFile $dbs -Destination "$sqlDestination"
	} 

	FormatBuildEvent -source "Build" -level "Info" -message "Destroying and recreating model for '${modelName}'"
	Start-Service -Name $aosServiceName -WarningAction SilentlyContinue
	
	$installedModels = Get-AxModel -layer "$layer" | Select -ExpandProperty Name
	
	if($modelName -in $installedModels)
    {	
		Uninstall-AXModel -Model "$modelName" -Server $dbServer -Database $modelDbName
	}
	
	New-AXModel -ManifestFile "$manifestFile" -Server $dbServer -Database $modelDbName
    Set-AXModelStore -Server $dbServer -Database $modelDbName -NoInstallMode
    
	FormatBuildEvent -source "Build" -level "Info" -message "Merging XPO files"
	$combinedFile = Merge-XPOs -BuildNumber $buildNumber -SourcesDirectory $sourcesDirectory -BinariesDirectory $binariesDirectory -ModelName $modelName

	FormatBuildEvent -source "Build" -level "Info" -message "Importing labels"
	Import-Labels -sourcesDirectory $sourcesDirectory -modelName $modelName -clientConfigFile $clientConfigFile -layer $layer -publisher $publisher -timeoutInMinutes 15

	FormatBuildEvent -source "Build" -level "Info" -message "Importing Visual Studio Projects"
	Import-VisualStudioProjects -sourcesDirectory $sourcesDirectory -modelName $modelName -clientConfigFile $clientConfigFile -layer $layer -publisher $publisher -timeoutInMinutes 15

	FormatBuildEvent -source "Build" -level "Info" -message  "Importing combined XPOs"
	Import-XPO -XpoFileName "$combinedFile" -layer $layer -modelName $modelName -publisher $publisher -timeoutInMinutes 60

	# TODO: When we get unit tests within AX, we need to run them to ensure the build isn't broken.

	Stop-Service -Name $aosServiceName -WarningAction SilentlyContinue

	FormatBuildEvent -source "Build" -level "Info" -message "Performing full compile via AXBuild. This could take some time"
    Invoke-AxBuild -ClientBinDir $clientBinDir -ServerBinDir $serverBinDir -AosInstanceId $aosInstance -DatabaseServer $dbServer -ModelDatabase $modelDbName -AXBuildLogPath $axBuildLogPath -DropDir $binariesDirectory -CopyLogFile $true -timeoutInMinutes 30

	Start-Service -Name $aosServiceName -WarningAction SilentlyContinue

	FormatBuildEvent -source "Build" -level "Info" -message  "Performing CIL regeneration. This could take some time too"
	Invoke-CILGeneration -ClientConfigFile "$clientConfigFile" -timeoutInMinutes 90
	
	FormatBuildEvent -source "Build" -level "Info" -message  "Performing database synchronisation. This will be a while.."
	Invoke-DatabaseSynchronisation -ClientConfigFile "$clientConfigFile" -timeoutInMinutes 90	

	if($isAutomatedBuild -eq $false) 
	{
	    FormatBuildEvent -source "Build" -level "Info" -message "Publishing all reports"
	    Publish-AllAxReports
    }

	$axModelFile = [System.IO.Path]::Combine($binariesDirectory,  $buildNumber + ".axmodel")
	FormatBuildEvent -source "Build" -level "Info" -message  "Exporting model file"
	Export-AXModel -Server $dbServer -Database $modelDbName -Model $modelName -File "$axModelFile"

	if($? -eq $false)
	{
		throw "Exporting the model file failed."
	}

	FormatBuildEvent -source "Build" -level "Info" -message  "Build successful!"
} 
catch
{
	$exception = $_.Exception | Format-List -force | Out-String	
	FormatBuildEvent -source "Build" -level "Error" -message "Unable to build model file: '$exception'"	
	
	exit -1
}