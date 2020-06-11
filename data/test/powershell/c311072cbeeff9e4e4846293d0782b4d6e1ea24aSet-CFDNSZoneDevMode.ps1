Set-StrictMode -Version 2

function Set-CFDNSZoneDevMode
{
    [OutputType([PSCustomObject])]
    [CMDLetBinding()]
    param
    (
        [Parameter(mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $APIToken,

        [Parameter(mandatory = $true)]
        [ValidatePattern("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Email,

        [Parameter(mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Zone,

        [Parameter(mandatory = $false)]
        [switch]
        $DevModeOff
    )

    # Cloudflare API URI
    $CloudFlareAPIURL = 'https://www.cloudflare.com/api_json.html'

    # Build up the request parameters
    $APIParameters = @{
        'tkn'   = $APIToken
        'email' = $Email
        'a'     = 'devmode'
        'z'     = $Zone
    }

    if ($DevModeOff) 
    {$APIParameters.Add('v', 0)}
    else
    {$APIParameters.Add('v', 1)}
    

    $JSONResult = Invoke-RestMethod -Uri $CloudFlareAPIURL -Body $APIParameters -Method Get
    
    #if the cloud flare api has returned and is reporting an error, then throw an error up
    if ($JSONResult.result -eq 'error') 
    {throw $($JSONResult.msg)}
    
    $JSONResult.result
}
