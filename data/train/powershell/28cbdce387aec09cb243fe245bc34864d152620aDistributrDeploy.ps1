[CmdletBinding(PositionalBinding=$True)]
Param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[a-z0-9]*$")]
    [String]$Name                        # required    needs to be alphanumeric    
    #[String]$StartIPAddress
)
#include deploy settings
. .\deploysettings.ps1
#region Functions 


Function Detect-IPAddress
{ $web = New-Object System.Net.WebClient
  
   #$x = [xml]$web.DownloadString('http://checkip.dyndns.org')
   #$x = [xml]$web.DownloadString(' http://icanhazip.com/')  
   #$ip1 = $x.html.body
   # $ip1 = $x.html.body
   #$ip2 = $ip1.Split(':')[1]
   #return $ip1.Trim()
   $webclient = new-object System.Net.WebClient
   $remoteIp = $webclient.DownloadString("http://www.icanhazip.com")
   return $remoteIp
}


#endregion

#region Main Script

$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"
$StartIPAddress = Detect-IPAddress
Write-Verbose "Detected IP Address $StartIPAddress"

$WebApiProjectFilePath = "..\Distributr.Azure.WebApi\Distributr.Azure.WebApi.csproj"
$HQProjectFilePath = "..\Distributor.HQ.Web\Distributr.HQ.Web.csproj"

#--------- Setup HashTable that can be passed around scripts
Write-Verbose "Loading Deploy Settings .............................."
$deploySettings = Get-DeploySettings -Name $Name -StartIPAddress $StartIPAddress
Write-Verbose $deploySettings.ConfigPath


#--------- Clean up deployment directory
 
if( Test-Path $deploySettings.ConfigPath){
    Remove-Item $deploySettings.ConfigPath -Force -Recurse   
}
New-Item -ItemType directory -Path $deploySettings.ConfigPath


#---------------- TEST NAMES EXIST - Have to be unique across azure
Write-Verbose "Testing azure website does not exist"
$websitenameexists = Test-AzureName -website $deploySettings.NameWebApiWebSite
if($websitenameexists){
    throw "Web api Website name $deploySettings.NameWebApiWebSite already exists on azure!!!!!!!!!!!!"
}

Write-Verbose "Testing hq website does not exist"
$hqnameexists = Test-AzureName -website $deploySettings.NameHQWebSite
if($hqnameexists){
    throw "HQ Website name $deploySettings.NameHQWebSite already exists on azure!!!!!!!!!!!!"
}

Write-Verbose "Testing Storage account does not exist"
$storageAccountExists = Test-AzureName -storage $deploySettings.StorageAccountName
if($storageAccountExists){
    throw "Storage account already exists!!!!!!!!!!!!!!!!!!"
}



#------ Run db, web api website and storage
& ".\New-DistributrDeployment.ps1" `
    -Name $Name `
    -DeploySettings $deploySettings 
    
#throw "Stop here!!!"
    
#TODO HQ

#Run Web Api Website deploy
& "$($deploySettings.ScriptPath)\PublishAzureWebsite.ps1" `
    -ProjectFile $WebApiProjectFilePath `
    -Launch `
    -Name $Name `
    -EnvironmentFile "webapi-environment.xml"

& "$($deploySettings.ScriptPath)\PublishAzureWebsite.ps1" `
    -ProjectFile $HQProjectFilePath `
    -Launch `
    -Name $Name `
    -EnvironmentFile "hq-environment.xml"

#Run role deploy

& "$($deploySettings.ScriptPath)\NewAzureRole.ps1" -Name $Name `
    -ServiceLocation $deploySettings.Location `
    -PackageFilePath ".\RoleRelease\Distributr.Azure.Service.cspkg" `
    -ConfigurationFilePath ".\RoleRelease\ServiceConfiguration.Cloud.cscfg"

#endregion 