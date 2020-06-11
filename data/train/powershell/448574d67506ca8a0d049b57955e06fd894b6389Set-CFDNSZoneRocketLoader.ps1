Set-StrictMode -Version 2

function Set-CFDNSZoneRocketLoader
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
        $Zone,

        [Parameter(mandatory = $true)]
        [ValidateSet('off', 'automatic', 'manual', '0', 'a', 'm')]
        [string]
        $Level
    )

    # Cloudflare API URI
    $CloudFlareAPIURL = 'https://www.cloudflare.com/api_json.html'

    # Build up the request parameters
    $APIParameters = @{
        'tkn'   = $APIToken
        'email' = $Email
        'a'     = 'async'
        'z'     = $Zone
    }

    if (($Level -eq 'automatic') -or ($Level -eq 'a'))
    {$APIParameters.Add('v', 'a')} 
    elseif (($Level -eq 'manual') -or ($Level -eq 'm'))
    {$APIParameters.Add('v', 'm')} 
    else 
    {$APIParameters.Add('v', '0')}

    $JSONResult = Invoke-RestMethod -Uri $CloudFlareAPIURL -Body $APIParameters -Method Get
    
    #if the cloud flare api has returned and is reporting an error, then throw an error up
    if ($JSONResult.result -eq 'error') 
    {throw $($JSONResult.msg)}
    
    $JSONResult.result
}
