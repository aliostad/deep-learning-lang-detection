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



#Step : Empty output directory
Write-Host "`nCleaning Backup Directory $backupRootPath" -foregroundcolor Yellow
If((ManageFile\Clean-Directory -path $backupRootPath -Verbose) -ne 0) {Exit }

ManageFile\Create-Directory -path $mongoBackupDataPath
ManageFile\Create-Directory -path $sqlDbBackupPath

# Step : Stop sites
Write-Host "`nStopping Application Pools" -foregroundcolor Yellow
Foreach ($appPool in $settings.iis.appPools)
{
    ManageIIS\Stop-ApplicationPool -appPoolName $appPool.name -Verbose
}

# Step : Export Mongo Data
Write-Host "`nExporting Mongo Data" -foregroundcolor Yellow
ManageDemoData\Export-MongoData -mongoBinDirectory $mongoBinDirectory -outputDirectory $mongoBackupDataPath 

Write-Host "`nDetaching SQL databases" -foregroundcolor Yellow
# Step : Detach SQL Databases
ManageSqlServer\Detach-Databases -prefix "demo.local" -ServerName "(local)" -Verbose
ManageSqlServer\Detach-Databases -prefix "habitat821" -ServerName "(local)" -Verbose

# Step : Copy data files to backup directory
Write-Host "`nCopying SQL Data files from $sqlDbPath to backup directory: $sqlDbBackupPath" -foregroundcolor Yellow
ManageFile\Copy-SQLDataFiles -prefix "demo.local" -sourcePath $sqlDbPath -destinationPath $sqlDbBackupPath  -Verbose
ManageFile\Copy-SQLDataFiles -prefix "habitat821" -sourcePath $sqlDbPath -destinationPath $sqlDbBackupPath -Verbose


Write-Host "`nRe-Attaching databases" -foregroundcolor Yellow
ManageSqlServer\Attach-Databases -DbPath $sqlDbPath -prefix "" -ServerName "(local)"  -Verbose

# Step : Start sites
Write-Host "`nStarting Application Pools" -foregroundcolor Yellow
Foreach ($appPool in $settings.iis.appPools)
{
    ManageIIS\Start-ApplicationPool -appPoolName $appPool.name -Verbose
}


