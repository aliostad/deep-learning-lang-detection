Set-StrictMode -Version 2

function get-CFDNSZoneSettings
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
        [string]
        $Email,

        [Parameter(mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Zone
    )

    # Cloudflare API URI
    $CloudFlareAPIURL = 'https://www.cloudflare.com/api_json.html'

    # Build up the request parameters
    $APIParameters = @{
        'tkn'   = $APIToken
        'email' = $Email
        'a'     = 'zone_settings'
        'z'     = $Zone
    }

    $JSONResult = Invoke-RestMethod -Uri $CloudFlareAPIURL -Body $APIParameters -Method Get
    
    # if the cloud flare api has returned and is reporting an error, then throw an error up
    if ($JSONResult.result -eq 'error') 
    {throw $($JSONResult.msg)}
    
    $JSONResult.response.result.objs
}
