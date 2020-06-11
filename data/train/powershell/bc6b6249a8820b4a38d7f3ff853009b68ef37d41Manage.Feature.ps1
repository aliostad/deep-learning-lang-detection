<#  
.SYNOPSIS  
    This script Enables or disables features in an Office 365 tenant
.DESCRIPTION  
    This script Enables or disables features in an Office 365 tenant
.NOTES  
    File Name  : manage-feature.ps1  
    Author     : Kanwartej Basrai http://www.kbasrai.com
    Requires   : SharePoint Online Management Shell
.PARAMETER siteurl
    This is the URL of the site where the feature needs to be activated. 
.PARAMETER username    
    This is the username of the user who has access to manage/enable features. 
.PARAMETER featureID    
    Guid of the feature that needs to be Enabled/Disabled
.PARAMETER enable
    Default is false, if set to false, the script will disable the feature
    If set to true, the script will enable the feature
.PARAMETER force
    Default is false. SHould the script force the disble/enable of the feature

.LINK  
	None
.EXAMPLE  
    PSH [C:\]: .\manage-feature.ps1 -siteurl "https://tenant.sharePoint.com" -username "user@tenant.onmicrosoft.com" -featureID "f6924d36-2fa8-4f0b-b16d-06b7250180fa" -enable $true
    
    This will enable the Publishing infrastructure feature on site tenant.sharepoint.com...
#> 
PARAM
(
      [parameter(mandatory=$true)]       
      [string]$siteurl,      
      
      [parameter(mandatory=$true)] 
      [string] $username,

      [parameter(mandatory=$true)] 
      [string] $featureId,
            
      [Parameter(Mandatory=$true)]
      [System.Security.SecureString] $password,

      [bool]$enable,
      
      [bool]$force
)

Import-Module Microsoft.Online.SharePoint.Powershell -DisableNameChecking

try{
    # Setup Client context
    [Microsoft.SharePoint.Client.ClientContext]$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($siteurl);  
    $clientContext.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $password);

    # add feature definition to site feature collection
    $site = $clientContext.Site;     

    $featureguid = [System.Guid]$featureId;

    if($enable -eq $true)
    {     
       # $site.Features.Add($featureguid, $force, [Microsoft.SharePoint.Client.FeatureDefinitionScope]::None);      
        $site.Features.Add($featureguid, $force, [Microsoft.SharePoint.Client.FeatureDefinitionScope]::Site);      
    }

    if($enable -eq $false)
    {        
        $site.Features.Remove($featureguid, $force);      
    }
    $clientContext.ExecuteQuery();      
}
catch{
    Write-Host $Error[0].ToString();
}
