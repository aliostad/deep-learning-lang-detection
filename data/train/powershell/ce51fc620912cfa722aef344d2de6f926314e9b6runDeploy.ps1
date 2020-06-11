param 
( 
	[parameter(Mandatory=$true, HelpMessage="Name of the web application site")]
	[ValidateNotNullOrEmpty()]
    $webApplicationSiteName = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Physical path of the application web site")]
	[ValidateNotNullOrEmpty()]
    $physicalSitePath = $null,
	
	[parameter(Mandatory=$true, HelpMessage="IP-address of the web application site (use * for all unassigned)")]
	[ValidateNotNullOrEmpty()]
	$ipAddress = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Port of the web application site")]
	[ValidatePattern("\A\d{1,5}\Z")]
	$port = $null,
	
	[parameter(Mandatory=$false, HelpMessage="Host name of the web application site")]
	[ValidateNotNullOrEmpty()]
	$hostName = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Name of the application pool for the web application site")]
	[ValidateNotNullOrEmpty()]
	$appPoolName = $null,
	
	[parameter(Mandatory=$false, HelpMessage="Subject of the certificate for the web application site")]
	[ValidateNotNullOrEmpty()]
	$certificateSubject = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Path to the site's webdeploy package")]
	[ValidateNotNullOrEmpty()]	
	$siteDeployPackagePath = $null,
	
	[parameter(Mandatory=$true, HelpMessage="List with sections in web.config to encrypt")]
	[ValidateNotNull()]	
	$configSectionsToEncrypt = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Name of the raven database web site")]
	[ValidateNotNullOrEmpty()]	
	$ravenSiteName = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Physical path of the raven database web site")]
	[ValidateNotNullOrEmpty()]	
	$ravenSitePath = $null,
	
	[parameter(Mandatory=$true, HelpMessage="IP-address of the raven database web site (use * for all unassigned)")]
	[ValidateNotNullOrEmpty()]	
	$ravenSiteIpAddress = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Host name of the web application RavenDB site")]
	[ValidateNotNullOrEmpty()]	
	$ravenSiteHostName = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Port of the raven database web site")]
	[ValidatePattern("\A\d{1,5}\Z")]	
	$ravenSitePort = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Name of the application pool for the raven database web site")]
	[ValidateNotNullOrEmpty()]	
	$ravenAppPoolName = $null,
	
	[parameter(Mandatory=$true, HelpMessage="Path to the location for storing site bakups")]
	[ValidateNotNullOrEmpty()]	
	$siteBackupLocation = $null,
	
	[parameter(Mandatory=$false, HelpMessage="Path to the ADFS-server's certificate file")]
	[ValidateNotNullOrEmpty()]	
	$adfsCertificateFilePath = $null, 
	
	[parameter(Mandatory=$false, HelpMessage="Hostname ADFS-server")]
	[ValidateNotNullOrEmpty()]	
	$adfsHostName = $null
)

. ./takeBackup.ps1
. ./configureIIS.ps1
. ./manageUserAccount.ps1
. ./deploySite.ps1
. ./modifyAndEncryptConfiguration.ps1


$appPoolUserAccountName = ReadUserAccountNameFromConsole "Enter the application pool's user account name"
$appPoolUserAccountPassword = ReadPasswordFromConsole "Enter the application pool's user account password"
$siteDeployPackagePath = (Get-Item $siteDeployPackagePath).FullName
$ravenSiteSourcePath = (Get-Item '.\RavenDb').FullName
$configSectionsToUnlock = @()
$MSDeploy = "$env:ProgramFiles\IIS\Microsoft Web Deploy V2\msdeploy.exe"
$currentTimestamp = Get-Date -Format 'yyyyMMddHHmmss'

Function DotNetFrameworkV4Path(){		
	$net4frameworkPath = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
							Get-ItemProperty -name InstallPath -EA 0
	
	if (($net4frameworkPath -ne $null) -and ($net4frameworkPath.Count -ne 0)){
		ForEach ($path in $net4frameworkPath){
			Write-Host $path.InstallPath
		    if($path.InstallPath.contains("v4.0.")){
				return $path.InstallPath
			}
		}
	}
	Write-Host "FAILED! STOPPING SCRIPT EXECUTION" -foregroundcolor red
	Write-Host "Required .NET-Framework v.4 is missing. It can be downloaded from http://www.microsoft.com/downloads/en/details.aspx?FamilyID=0A391ABD-25C1-4FC0-919F-B21F31AB88B7." -foregroundcolor red
	exit
}

Function CheckForErrors() {
  if (!$?) {
	Write-Host "FAILED! STOPPING SCRIPT EXECUTION" -foregroundcolor red
    exit
  }
}

Function DoesNotExistSite($siteName){
	$webSite = Get-Item "IIS:\sites\$siteName" -ErrorAction SilentlyContinue
	return ($webSite -eq $null)
}

Function ExistsSite($siteName){
	return !(DoesNotExistSite $siteName)
}

Function ConvertToPlainText( $secureString ) {
	return [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))
 }
 
Function CreatePhysicalPath($basePath, $SubDirectory){
	return Join-Path -Path $basePath -ChildPath $SubDirectory
}

Function BuildWebSiteUrl ($domainName, $port, $requireSSL){
	if($requireSSL){
		if($port -eq 443){
			return 'https://'+$domainName
		}
		return 'https://'+$domainName+':'+$port
	}
	if($port -eq 80){
		return 'http://'+$domainName
	}
	return 'http://'+$domainName+':'+$port
}

$webAdminSnapin = Get-PSSnapin | where {$_.Name -eq 'WebAdministration'}
if($webAdminSnapin -eq $null){
  import-module WebAdministration
}


[System.Console]::BackgroundColor = 'DarkBlue'
[System.Console]::ForegroundColor = 'Gray'
Clear-Host

Write-Host
Write-Host "Checking deployment proconditions"
Write-Host "---------------------------------"

$dotnetPath = (DotNetFrameworkV4Path)
if (!$env:Path.contains($dotnetPath)){
	$env:Path = $env:Path + ";" + $dotnetPath
}

Write-Host
Write-Host "Starting site deployment"
Write-Host "------------------------"

$ravenSiteUrl = (BuildWebSiteUrl $ravenSiteHostName $ravenSitePort $false)

BackupIisConfig $currentTimestamp
BackupSite $webApplicationSiteName $siteBackupLocation $currentTimestamp $MSDeploy

RegisterAspNetV4WithIis
UnlockConfigurationSection $configSectionsToUnlock
CreateLocalUserAccount $appPoolUserAccountName $appPoolUserAccountPassword
DeployWebApplicationSite $webApplicationSiteName $physicalSitePath $ipAddress $port $hostName $appPoolName $appPoolUserAccountName $appPoolUserAccountPassword $certificateSubject $siteDeployPackagePath $MSDeploy
GrantModifyRightsOnSiteTo $appPoolUserAccountName $physicalSitePath
ModifyRavenDbUrl $physicalSitePath $ravenSiteUrl
if(($adfsCertificateFilePath -ne $null) -and $($adfsHostName -ne $null)){
	SetIdentityModelUrlsAndCertificates $hostName $certificateSubject $true $port $adfsCertificateFilePath $adfsHostName
}

DeployRavenDbSite $ravenSiteName $ravenSitePath $ravenSiteIpAddress $ravenSitePort $ravenHostName $ravenAppPoolName $appPoolUserAccountName $appPoolUserAccountPassword $ravenSiteSourcePath $MSDeploy
GrantModifyRightsOnSiteTo $appPoolUserAccountName $ravenSitePath
ModifyRavenAccessRights $ravenSitePath 'All'

Write-Host
Write-Host "Restarting IIS:" -ForegroundColor Blue
iisreset
CheckForErrors

Write-Host
Write-Host "-----------------------------------" -foregroundcolor green
Write-Host "Site has been deployed successfully" -foregroundcolor green
Write-Host