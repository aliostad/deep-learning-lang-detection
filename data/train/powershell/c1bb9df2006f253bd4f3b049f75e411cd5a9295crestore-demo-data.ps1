Set-ExecutionPolicy Unrestricted –scope CurrentUser

Import-Module CSPS -Force
Import-Module $PSScriptRoot\Scripts\Commerce\ManageFile.psm1 -Force
Import-Module $PSScriptRoot\Scripts\Commerce\ManageIIS.psm1 -Force
Import-Module $PSScriptRoot\Scripts\Commerce\ManageUser.psm1 -Force
Import-Module $PSScriptRoot\Scripts\Commerce\ManageRegistry.psm1 -Force
Import-Module $PSScriptRoot\Scripts\Commerce\ManageSqlServer.psm1 -Force
Import-Module $PSScriptRoot\Scripts\Demo\ManageDemoData.psm1 -Force
cd $PSScriptRoot

If ((ManageUser\Confirm-Admin) -ne $true) { Write-Host "Please run script as administrator"; exit }
If ((ManageRegistry\Get-InternetExplorerEnhancedSecurityEnabled -Verbose) -eq $true) { Write-Host "Please disable Internet Explorer Enhanced Security"; exit }

$settings = ((Get-Content $PSScriptRoot\install-commerce-config.json -Raw) | ConvertFrom-Json)

$sitecoreWebsiteFolderSetting = ($settings.iis.websites | Where { $_.id -eq "sitecore" } | Select)
If ($sitecoreWebsiteFolderSetting -eq $null) { Write-Host "Expected sitecore iis website settings" -ForegroundColor red; exit; }

$siteName = $sitecoreWebsiteFolderSetting.siteName

$sitecoreApplicationPoolSetting = ($settings.iis.appPools)


$backupRootPath = "C:\websites\habitat.dev.local\Databases\Backup"
$mongoBackupDataPath = "$backupRootPath\MongoData"
$sqlDbPath = "c:\websites\$siteName\databases"
$sqlDbBackupPath = "$backupRootPath\SQL"
$mongoBinDirectory = "C:\MongoDB\Server\bin"

# Step : Stop sites
Write-Host "`nStopping Application Pools" -foregroundcolor Yellow
Foreach ($appPool in $settings.iis.appPools)
{
    ManageIIS\Stop-ApplicationPool -appPoolName $appPool.name -Verbose
}
Write-Host "`nImporting Mongo Data" -foregroundcolor Yellow
ManageDemoData\Import-MongoData -mongoBinDirectory $mongoBinDirectory -inputDirectory $mongoBackupDataPath 

# Step : Detach existing SQL Databases
Write-Host "`nDetaching existing SQL databases" -foregroundcolor Yellow
ManageSqlServer\Detach-Databases -prefix "demo.local" -ServerName "(local)"
ManageSqlServer\Detach-Databases -prefix "habitat821" -ServerName "(local)"

# Step : Copy data files from backup directory to databases directory
Write-Host "`nCopying SQL Data files from $sqlDbBackupPath to $sqlDbPath" -foregroundcolor Yellow
ManageFile\Copy-SQLDataFiles -prefix "demo.local" -sourcePath $sqlDbBackupPath -destinationPath $sqlDbPath
ManageFile\Copy-SQLDataFiles -prefix "habitat821" -sourcePath $sqlDbBackupPath -destinationPath $sqlDbPath

# Step : Attach all databases in the $sqlDbPath folder
Write-Host "`nAttaching SQL Databases" -foregroundcolor Yellow
ManageSqlServer\Attach-Databases -DbPath $sqlDbPath -prefix "" -ServerName "(local)"

# Step : Start sites
Write-Host "`nStarting Application Pools" -foregroundcolor Yellow
Foreach ($appPool in $settings.iis.appPools)
{
    ManageIIS\Start-ApplicationPool -appPoolName $appPool.name -Verbose
}
