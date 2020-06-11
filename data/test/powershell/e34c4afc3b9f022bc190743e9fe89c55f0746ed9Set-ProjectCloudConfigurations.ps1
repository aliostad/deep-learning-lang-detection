[CmdletBinding()]
Param(
    [string]$groupname,
	[string]$publishDir,
	[string]$workerName,
	[string]$storageAccountName,
	[string]$searchName,
	[switch]$s
	
)

Function UpdateConfigFile($resourceGroupName, $workerName, $storageAccountName, $publishDir){
	Switch-AzureMode AzureResourceManager
	$storageAccountKey = (Get-AzureStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName).Key1
	
	#Read and update config files
	$cscfgFile = "$publishDir\ServiceConfiguration.Cloud.cscfg"
	$configDoc = (Get-Content $cscfgFile) -as [Xml]
	#Update config
	$tmp = $configDoc.ServiceConfiguration.Role | where {$_.name -eq $workerName} 
	$obj = $tmp.ConfigurationSettings.Setting | where {$_.name -eq 'StorageConnectionString'}
	$obj.value = "DefaultEndpointsProtocol=https;AccountName=$storageAccountName;AccountKey=$storageAccountKey";
	#Save to cscfg
	$configDoc.Save($cscfgFile)
	
	
	
}

Function UpdateSearchApiConfig($workerName, $searchApiKey, $searchName, $publishDir){
	if(!$searchApiKey){
		$searchApiKey = Read-Host "Please enter searchApiKey, accessible from the Azure Portal"
	}
	#Read and update config files
	$cscfgFile = "$publishDir\ServiceConfiguration.Cloud.cscfg"
	$configDoc = (Get-Content $cscfgFile) -as [Xml]
	#Update config
	$tmp = $configDoc.ServiceConfiguration.Role | where {$_.name -eq $workerName} 
	$obj = $tmp.ConfigurationSettings.Setting | where {$_.name -eq 'SearchApiKey'}
	$obj.value = $searchApiKey.ToString()
	$obj2 = $tmp.ConfigurationSettings.Setting | where {$_.name -eq 'SearchServiceName'}
	$obj2.value = $searchName
	#Save to cscfg
	$configDoc.Save($cscfgFile)

}

Function Select-FolderDialog
{
	param([string]$Description="Select publish directory to update",[string]$RootFolder="MyComputer")
 	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
    Out-Null     
   	$objForm = New-Object System.Windows.Forms.FolderBrowserDialog
    $objForm.Rootfolder = $RootFolder
    $objForm.Description = $Description
    $Show = $objForm.ShowDialog()
    If ($Show -eq "OK")
	{
    	Return $objForm.SelectedPath
	}Else
	{
		Write-Error "Operation cancelled by user."
	}
}

if(!$groupname){
	$groupname = Read-Host "Enter group number or short group name (max 5 characters!)"  
}
if($groupname.Length -lt 3){
	$groupname = "GRGroup" + $groupname
}

$resourceGroupName = $groupname + "Resources"
$storageAccountName = $groupname.ToLower() + "storage"
$searchName = $groupname.ToLower() + "search"

if(!$publishDir){
	$publishDir = Select-FolderDialog	
}

if(!$workerName){
	$workerName = Read-Host "Enter name of worker role to update config on"
}

UpdateConfigFile $resourceGroupName $workerName $storageAccountName $publishDir

if($s){
	UpdateSearchApiConfig $workerName $searchApiKey $searchName $publishDir
}