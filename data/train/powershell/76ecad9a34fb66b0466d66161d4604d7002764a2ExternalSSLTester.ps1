######################################################################################
# Written by Ashley Poole  -  http://www.ashleypoole.co.uk                           #
#                                                                                    #
# Checks servers SSL implementation for the given host(s).                           #
# This is achived by consuming SSL Labs Assessment Api Via SSLLWrapper (Api Wrapper) #
######################################################################################

#region Construction
Param
(
	[Parameter(Mandatory=$false)]
	[ValidateNotNullOrEmpty()]
    [String]
    [alias("host")]
	$hostInput,

	[Parameter(Mandatory=$false)]
	[ValidateNotNullOrEmpty()]
    [String]
    [alias("hosts")]
	$hostsInput,

	[Parameter(Mandatory=$false)]
	[ValidateNotNullOrEmpty()]
    [Bool]
    [alias("endpointdetails")]
	$WriteEndpointDetails
)

# Validating and loading inputs
If (($hostInput) -or ($hostsInput))
{
    If ($hostsInput)
    {
        $Hosts = Get-Content ($PSScriptRoot.ToString() + "\Hosts.txt")
    }
    Else
    {
        $Hosts = @($hostInput)
    }
}
Else
{
    Write-Host "ERROR: No values for host(s) were specified!`r`nSee README files for details on input parameters." -ForegroundColor Red
    Exit
}

# Variables
$SSLLabsApiUrl = "https://api.dev.ssllabs.com/api/fa78d5a4/"


$SSLLWrapperFilePath = $PSScriptRoot.ToString() + "\SSLLWrapper\SSLLWrapper.dll"
$NewtonsoftJsonFilePath = $PSScriptRoot.ToString() + "\SSLLWrapper\NewtonSoft.Json.dll"

# Loading DLLs
Add-Type -Path $NewtonsoftJsonFilePath -ErrorAction Stop
Add-Type -Path $SSLLWrapperFilePath -ErrorAction Stop


# Creating SSLLService
$SSLService = New-Object SSLLWrapper.SSLLService($SSLLabsApiUrl)

#endregion

#region Functions
Function ToBooleanString($value)
{
    return [System.Convert]::ToBoolean($value).ToString()
}

#endregion

clear
Write-Host "`n"
Write-Host "Starting analysis... This process may take several minutes per endpoint, per host..."
Write-Host "`n"

# Testing if Api is online
$ApiInfo = $SSLService.Info()

If ($ApiInfo.Online -ne $true)
{
    # Api is not online. Exiting.
    Write-Host "Api " $SSLLabsApiUrl " is not online, contactable or is incorrect.`r`nExiting." -ForegroundColor Red
    Exit
}


Foreach ($myHost In $Hosts)
{
    # Analysising host with a maximum of a 5 minute wait time
    #$HostAnalysis = $SSLService.AutomaticAnalyze($myHost, 500, 10)
    $HostAnalysis = $SSLService.AutomaticAnalyze($myHost, [SSLLWrapper.SSLLService+Publish]::Off, [SSLLWrapper.SSLLService+ClearCache]::Ignore, [SSLLWrapper.SSLLService+FromCache]::On,[SSLLWrapper.SSLLService+All]::On,500,10)

    Write-Host "**********************************************************************************"
    Write-Host $myHost " - " (Get-Date -format "dd-MM-yyyy HH:mm:ss")
    Write-Host "**********************************************************************************"
    Write-Host "Endpoints #           :" ($HostAnalysis.endpoints).Count
    Write-Host "Analysis Error        :" $HostAnalysis.HasErrorOccurred
    Write-Host "`n"

    Foreach ($Endpoint In $HostAnalysis.endpoints)
    {
        Write-Host "Endpoint              :" $Endpoint.ipAddress

        Write-Host "Grade                 :" $Endpoint.grade
        Write-Host "Has Warnings          :" $Endpoint.hasWarnings

        # Output extra details if EndpointDetails is true and analysis data is good (i.e check grade exists)
        If (($WriteEndpointDetails) -and ($Endpoint.grade))
        {
            $EndpointAnalysis = $SSLService.GetEndpointData($HostAnalysis.host, $Endpoint.ipAddress)

            Write-Host "Server Signature      :" $EndpointAnalysis.Details.serverSignature
            Write-Host "Cert Chain Issue      :" $EndpointAnalysis.Details.chain.issues
            Write-Host "Forward Secrecy       :" $EndpointAnalysis.Details.forwardSecrecy
            Write-Host "Supports RC4          :" $EndpointAnalysis.Details.supportsRc4
            Write-Host "Beast Vulnerable      :" $EndpointAnalysis.Details.vulnBeast
            Write-Host "Heartbleed Vulnerable :" $EndpointAnalysis.Details.heartbleed
            Write-Host "Poodle Vulnerable     :" $EndpointAnalysis.Details.poodleTls
            
       }
       Write-Host "`n"
    }
    Write-Host "`r`n"
}






