<#
    
Copyright © 2014 Citrix Systems, Inc. All rights reserved.

.SYNOPSIS
This script will create and configure a Netscaler Gateway for the default
Store on the XenDesktop Controller

.DESCRIPTION

.NOTES
    KEYWORDS: PowerShell, Citrix
    REQUIRES: PowerShell Version 2.0 

.LINK
     http://community.citrix.com/
#>
Param (
    [string]$GatewayName = "Remote Gateway",
    [string]$NetScalerUrl,
    [string]$XenDesktopBaseUrl,
    [string]$NetScalerCACert
)
$ErrorActionPreference = 'Stop'
Import-Module CloudworksTools

$dsInstallProp = Get-ItemProperty -Path HKLM:\SOFTWARE\Citrix\DeliveryServicesManagement -Name InstallDir
$dsInstallDir = $dsInstallProp.InstallDir
[Reflection.Assembly]::LoadFrom("$dsInstallDir\Citrix.DeliveryServices.Admin.Authentication.Extensions.CitrixAGBasic.dll") | Out-Null
[Reflection.Assembly]::LoadFrom("$dsInstallDir\Citrix.DeliveryServices.Admin.Roaming.CreateRoamingServiceExtension.dll") | Out-Null
[Reflection.Assembly]::LoadFrom("$dsInstallDir\Citrix.DeliveryServices.Admin.Roaming.GatewaysScopeNode.dll") | Out-Null
[Reflection.Assembly]::LoadFrom("$dsInstallDir\Citrix.DeliveryServices.Admin.Roaming.StoreExtensions.dll") | Out-Null
[Reflection.Assembly]::LoadFrom("$dsInstallDir\Citrix.DeliveryServices.Admin.Stores.Model.dll") | Out-Null
[Reflection.Assembly]::LoadFrom("$dsInstallDir\Citrix.DeliveryServices.Admin.Utils.dll") | Out-Null
[Reflection.Assembly]::LoadFrom("$dsInstallDir\Citrix.DeliveryServices.ServiceRecords.Admin.RoamingModel.dll") | Out-Null
[Reflection.Assembly]::LoadFrom("$dsInstallDir\Citrix.DeliveryServices.ServiceRecords.Admin.StoreServiceRecordModel.dll") | Out-Null
$RegProp = Get-ItemProperty -Path HKLM:\SOFTWARE\Citrix\DeliveryServices -Name InstallDir
$DSScriptDir = $RegProp.InstallDir+"\Scripts"
try {
    Push-Location $DSScriptDir
    & .\ImportModules.ps1
}
catch {} 
finally {
    Pop-Location
}

# These are hard-coded for the default Store and web receiver that are created by the XenDesktop installer
$site = 1
$authPath = "/Citrix/Authentication"
$storePath = "/Citrix/Store"
$webReceiverPath = "/Citrix/StoreWeb"
[array]$webReceiverAuthMethods = @("ExplicitForms", "CitrixAGBasic")

# Set the authentication protocols for SF and Web Receiver
Set-DSAuthenticationProtocolsDeployed -SiteId $site -VirtualPath $authPath -Protocols ExplicitForms,CitrixAGBasic
Set-DSWebReceiverAuthenticationMethods -SiteId $site -VirtualPath $webReceiverPath -AuthenticationMethods $webReceiverAuthMethods

# Create gateway DTO
$gwDTO = New-Object Citrix.DeliveryServices.Admin.RoamingModel.DTO.ExtendedGatewayDTO
$gwDTO.AccessGatewayVersion = [Citrix.DeliveryServices.Admin.RoamingModel.DTO.AccessGatewayVersion]::Version10_0_69_4
$gwDTO.Name = $GatewayName
$gwDTO.Address = Join-Url $NetScalerUrl, ""
$gwDTO.Default = $true
$gwDTO.DeploymentType = [Citrix.DeliveryServices.Admin.RoamingModel.DTO.DeploymentMode]::Appliance
$gwDTO.Logon = "Domain"
$gwDTO.CallbackURL = Join-Url $NetScalerUrl, "CitrixAuthService/AuthService.asmx"
$gwDTO.SessionReliability = $true
$gwDTO.RequestTicketTwoSTA = $false
$gwDTO.SecureTicketAuthorityURLs = New-Object System.Collections.Generic.List[String]
$gwDTO.SecureTicketAuthorityURLs.Add((Join-Url $XenDesktopBaseUrl,"scripts/ctxsta.dll"))
    
# Create gateway
Add-DSGlobalV10Gateway -Id $gwDTO.ID `
                       -Name $gwDTO.Name `
                       -Address $gwDTO.Address `
                       -IsDefault $gwDTO.Default `
                       -CallbackUrl $gwDTO.CallbackURL `
                       -SessionReliability $gwDTO.SessionReliability `
                       -RequestTicketTwoSTA $gwDTO.RequestTicketTwoSTA `
                       -SecureTicketAuthorityUrls $gwDTO.SecureTicketAuthorityURLs `
                       -Logon $gwDTO.Logon `
                       -SmartCardFallback "None" `

# Enable store to use gateway
$store = Get-DSStoreServiceSummary -siteId $site -virtualPath $storePath
$serviceDTO = [Citrix.DeliveryServices.Admin.RoamingModel.Utilities.StoreServiceUtilities]::CreateStoreServiceDto($store)
$gatewayDTO = (Get-DSGlobalGateways).Gateways | Where {$_.Name -eq $GatewayName}
Set-DSGlobalServiceGateways  -ServiceRef $serviceDTO.ServiceRef -Gateways $gatewayDTO
Set-DSGlobalAccountRemoteAccess -ServiceRef $serviceDTO.ServiceRef -RemoteAccessType StoresOnly 

if ($NetScalerCACert) {
     
    if (Test-Path -Path $NetScalerCACert) {
        # Add CA certificate (required for SSL to NetScaler URL)
        certutil -enterprise -addstore "Root" $NetScalerCACert
    }
}






