Function Connect-3PAR {

  <#
      .SYNOPSIS
      Establish connection to the HP 3PAR StoreServ array
      .DESCRIPTION
      This function will retrieve a key session from the HP 3PAR StoreServ array. This key will be used by the other functions.
      .NOTES
      Written by Erwan Quelin under Apache licence
      Based on the work of Chris Wahl - http://wahlnetwork.com/2015/10/29/tackling-basic-restful-authentication-with-powershell/
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Connect-3PAR -Server 192.168.0.1
      Connect to the array with the IP 192.168.0.1
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'HP 3PAR StoreServ FQDN or IP address')]
      [ValidateNotNullorEmpty()]
      [String]$Server,
      [Parameter(Mandatory = $false,Position = 1,HelpMessage = 'HP 3PAR StoreServ username')]
      [String]$Username,
      [Parameter(Mandatory = $false,Position = 2,HelpMessage = 'HP 3PAR StoreServ password')]
      [SecureString]$Password,
      [Parameter(Mandatory = $false,Position = 4,HelpMessage = 'HP 3PAR StoreServ credentials')]
      [System.Management.Automation.CredentialAttribute()]$Credentials
  )

    Write-Verbose -Message 'Validating that login details were passed into username/password or credentials'
    if ($Password -eq $null -and $Credentials -eq $null)
    {
        Write-Verbose -Message 'Missing username, password, or credentials.'
        $Credentials = Get-Credential -Message 'Please enter administrative credentials for your HP 3PAR StoreServ Array'
    }

    Write-Verbose -Message 'Build the URI'
    $APIurl = 'https://'+$Server+':8080/api/v1'

    Write-Verbose -Message 'Build the JSON body for Basic Auth'

    if ($Credentials -eq $null)
    {
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password
    }

    $body = @{
      user=$Credentials.username;
      password=$Credentials.GetNetworkCredential().Password
    }
    $headers = @{}
    $headers["Accept"] = "application/json"

    Write-Verbose -Message 'Submit the session key request'
    Try
    {
      $credentialdata = Invoke-WebRequest -Uri "$APIurl/credentials" -Body (ConvertTo-Json -InputObject $body) -ContentType "application/json" -Headers $headers -Method POST -UseBasicParsing
    }
    catch
    {
      Show-RequestException -Exception $_
      throw
    }

    $global:3parArray = $Server
    $global:3parKey = ($credentialdata.Content | ConvertFrom-Json).key
    Write-Verbose -Message "Acquired token: $global:3parKey"
    Write-Verbose -Message 'You are now connected to the HP 3PAR StoreServ Array.'

    Write-Verbose -Message 'Show array informations:'
    Get-3PARSystems | ft

}
