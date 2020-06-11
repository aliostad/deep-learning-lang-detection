function Get-InformationAboutResourceProvider
{
    param(
        [string] $ResourceProviderNamespace,
        [string] $apiVersion = "2014-04-01-preview"
    )

    $s = Get-AzureSubscription -Current
    $subscriptionID = $s.SubscriptionId
    $thumbprint = ($s.Accounts |? {$_.Type -eq "Certificate"} | select -f 1).Id
    if (!($subscriptionID -and $thumbprint)) {throw "Error: Cannot get Azure subscription ID and thumbprint."}
    
    [string] $queryString = "https://management.azure.com/subscriptions/$subscriptionID/providers/$resourceProviderNamespace"+ "?api-version=$apiVersion"
    [string]$contenttype = "application/json"

    $headers = @{"x-ms-version" = "1.0"}

    Write-Verbose "Calling 'Set Azure REST API";
    [xml]$responseXml = $(Invoke-RestMethod -Method POST -Uri $queryString -CertificateThumbprint $thumbprint -Headers $headers -ContentType $contenttype -Verbose).Remove(0,1);

    return $resonseXml;
}

Get-InformationAboutResourceProvider -ResourceProviderNamespace "Storage"