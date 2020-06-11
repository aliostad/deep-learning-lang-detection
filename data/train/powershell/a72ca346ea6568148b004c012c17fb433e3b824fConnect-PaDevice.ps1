function Connect-PaDevice {
    [CmdletBinding()]
	<#
	.SYNOPSIS
		Establishes initial connection to Palo Alto API.
		
	.DESCRIPTION
		The Get-PaDevice cmdlet establishes and validates connection parameters to allow further communications to the Palo Alto API. The cmdlet needs at least two parameters:
		 - The device IP address or FQDN
		 - A valid API key
		
		
		The cmdlet returns an object containing details of the connection, but this can be discarded or saved as desired; the returned object is not necessary to provide to further calls to the API.
	
	.EXAMPLE
		Get-PaDevice "pa.example.com" "LUFRPT1PR2JtSDl5M2tjTktBeTkyaGZMTURTTU9BZm89OFA0Rk1WMS8zZGtKN0F"
		
		Connects to PRTG using the default port (443) over SSL (HTTPS) using the username "jsmith" and the passhash 1234567890.
		
	.EXAMPLE
		Get-PrtgServer "prtg.company.com" "jsmith" 1234567890 -HttpOnly
		
		Connects to PRTG using the default port (80) over SSL (HTTP) using the username "jsmith" and the passhash 1234567890.
		
	.EXAMPLE
		Get-PrtgServer -Server "monitoring.domain.local" -UserName "prtgadmin" -PassHash 1234567890 -Port 8080 -HttpOnly
		
		Connects to PRTG using port 8080 over HTTP using the username "prtgadmin" and the passhash 1234567890.
		
	.PARAMETER Server
		Fully-qualified domain name for the PRTG server. Don't include the protocol part ("https://" or "http://").
		
	.PARAMETER UserName
		PRTG username to use for authentication to the API.
		
	.PARAMETER PassHash
		PassHash for the PRTG username. This can be retrieved from the PRTG user's "My Account" page.
	
	.PARAMETER Port
		The port that PRTG is running on. This defaults to port 443 over HTTPS, and port 80 over HTTP.
	
	.PARAMETER HttpOnly
		When specified, configures the API connection to run over HTTP rather than the default HTTPS.
		
	.PARAMETER Quiet
		When specified, the cmdlet returns nothing on success.
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[ValidatePattern("\d+\.\d+\.\d+\.\d+|(\w\.)+\w")]
		[string]$Device,

        [Parameter(ParameterSetName="keyonly",Mandatory=$True,Position=1)]
        [string]$ApiKey,

        [Parameter(ParameterSetName="credential",Mandatory=$True,Position=1)]
        [pscredential]$Credential,

		[Parameter(Mandatory=$False,Position=2)]
		[int]$Port = $null,

		[Parameter(Mandatory=$False)]
		[alias('http')]
		[switch]$HttpOnly,
		
		[Parameter(Mandatory=$False)]
		[alias('q')]
		[switch]$Quiet
	)

    BEGIN {

		if ($HttpOnly) {
			$Protocol = "http"
			if (!$Port) { $Port = 80 }
		} else {
			$Protocol = "https"
			if (!$Port) { $Port = 443 }
			
			$global:PaDeviceObject = New-Object Poweralto.PaDevice
			
			$global:PaDeviceObject.Protocol = $Protocol
			$global:PaDeviceObject.Port     = $Port
			$global:PaDeviceObject.Device   = $Device

            if ($ApiKey) {
                $global:PaDeviceObject.ApiKey = $ApiKey
            } else {
                $UserName = $Credential.UserName
                $Password = $Credential.getnetworkcredential().password
            }
			
			$global:PaDeviceObject.OverrideValidation()
		}
    }

    PROCESS {
        
        if (!($ApiKey)) {
            $QueryStringTable = @{ type     = "keygen"
                                   user     = $UserName
                                   password = $Password }

            $QueryString = HelperCreateQueryString $QueryStringTable
			Write-Debug $QueryString
		    $url         = $global:PaDeviceObject.UrlBuilder($QueryString)

		    try   { $QueryObject = $global:PaDeviceObject.HttpQuery($url) } `
            catch {	throw $_.Exception.Message	           }

            $Data                  = HelperCheckPaError $QueryObject
            $global:PaDeviceObject.ApiKey = $Data.key
        }
        
        $QueryStringTable = @{ type = "op"
                               cmd  = "<show><system><info></info></system></show>" }

        $QueryString = HelperCreateQueryString $QueryStringTable
        Write-Debug "QueryString: $QueryString"
		$url         = $global:PaDeviceObject.UrlBuilder($QueryString)
        Write-Debug "URL: $Url"

		try   { $QueryObject = $global:PaDeviceObject.HttpQuery($url) } `
        catch {	throw $_.Exception.Message       	           }

        $Data = HelperCheckPaError $QueryObject
		$Data = $Data.system

        $global:PaDeviceObject.Name            = $Data.hostname
        $global:PaDeviceObject.Model           = $Data.model
        $global:PaDeviceObject.Serial          = $Data.serial
        $global:PaDeviceObject.OsVersion       = $Data.'sw-version'
        if ($global.PaDeviceObject.Type -eq "firewall") {
            $global:PaDeviceObject.GpAgent         = $Data.'global-protect-client-package-version'
            $global:PaDeviceObject.AppVersion      = $Data.'app-version'
            $global:PaDeviceObject.ThreatVersion   = $Data.'threat-version'
            $global:PaDeviceObject.WildFireVersion = $Data.'wildfire-version'
            $global:PaDeviceObject.UrlVersion      = $Data.'url-filtering-version'
        } else {
            
        }

        #$global:PaDeviceObject = $PaDeviceObject

		
		if (!$Quiet) {
			return $global:PaDeviceObject | Select-Object @{n='Connection';e={$_.ApiUrl}},Name,OsVersion
		}
    }
}