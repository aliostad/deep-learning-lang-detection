function Manage-APIToken{
    param(
        [ValidateSet("Set","Validate","Revoke")]
        $tokenAction,
        [PSCredential]$apiCreds,
        $token
    )
    
    $identityURI = "https://identity.api.rackspacecloud.com/v2.0"
    switch ($tokenAction)
    {
        'Set' {
            $userName = $apiCreds.UserName;$apiKey = $apiCreds.GetNetworkCredential().Password
            if(($token -eq $null) -and ($userName -ne $null) -and ($apiKey -ne $null)){
                $identityURI += "/tokens"
                $credJson = @{"auth" = @{"RAX-KSKEY:apiKeyCredentials" =  @{"username" = $userName; "apiKey" = $apiKey}}} | convertTo-Json
                try{
                    $response = Invoke-RestMethod -Uri $identityURI -Method POST -Body $credJson -ContentType application/json
                }
                catch{
                    Write-Host "Invalid credentials, please re-enter."
                    Manage-APIToken -tokenAction Set -apiCreds (Get-Credential -Message "Please enter your API Credentials?")
                }
                if($response -ne $null){
                    Set-Variable -Name "AuthToken" -Value (@{"X-Auth-Token"=$response.access.token.id}) -Scope Global -Verbose
                    Set-Variable -Name "ServiceCatalog" -Value ($response.access.serviceCatalog) -Scope Global -Verbose
                }
            }
        }
        'Validate' {
            if($token -ne $null){
                $identityURI += "/tokens/$($token.'X-Auth-Token')"
                try{
                    [datetime]$tokenExpires = (Invoke-RestMethod -Uri $identityURI -Method Get -ContentType application/json -Header $token).access.token.expires
                    if(($tokenExpires -ne $null) -and ($tokenExpires -gt (Get-Date).AddMinutes(5))){return $true}
                    else{return $false}
                }
                catch{return $false}
            }
            else{return $false}
        }
        'Revoke' {
            $identityURI += "/tokens"
            $deadToken = Invoke-RestMethod -Uri $identityURI -Method Delete -Headers $token
            Remove-Variable -Name @("AuthToken","ServiceCatalog") -Scope Global -Force -Verbose
        }
        Default {}
    }
}
function Get-ServiceURI{
    param(
        $cloudRegion=$null,
        $cloudService=$null,
        $serviceCatalog
    )
    
    $endpoints = ($serviceCatalog | where name -eq $cloudService).endpoints
    if($endpoints.count -gt 1){
        Return ($endpoints | where region -eq $cloudRegion).publicURL
    }
    else{
        Return $endpoints.publicURL
    }
}
function Invoke-RackAPI{
    param(
        [validateset("DFW","ORD","SYD","IAD","HKG")]
        $cloudRegion=$null,
        [validateset("cloudFilesCDN","cloudFiles","cloudBlockStorage","cloudImages","cloudQueues","cloudBigData","cloudOrchestration","cloudServersOpenStack","autoscale","cloudDatabases","cloudBackup","cloudNetworks","cloudMetrics","cloudLoadBalancers","cloudFeeds","cloudMonitoring","cloudDNS","rackCDN")]
        $cloudService=$null,
        $filter=$null,
        [hashtable]$body=$null,
        [validateset("Get","Post","Put","Delete")]
        $requestType="Get"
    )

    if(($AuthToken -eq $null) -or ($ServiceCatalog -eq $null)){
        Write-Host "Did not find an AuthToken. Redirecting to Authentication function first."
        Manage-APIToken -tokenAction Set -apiCreds (Get-Credential -Message "Please enter your API Credentials?")
    }
    elseif(-not(Manage-APIToken -tokenAction Validate -token $AuthToken)){
        Write-Host "Token validation has expired. Please re-authenticate."
        Manage-APIToken -tokenAction Set -apiCreds (Get-Credential -Message "Please enter your API Credentials?")
    }
    $publicURL = Get-ServiceURI -cloudRegion $cloudRegion -cloudService $cloudService -serviceCatalog $ServiceCatalog

    $workerURI = $publicURL + $filter
    if($body -ne $null){
        $body = $body | ConvertTo-Json -Depth 10
    }
    Invoke-RestMethod -Uri $workerURI -Method $requestType -Headers $AuthToken -Body $body -ContentType application/json
}
Export-ModuleMember -Function Invoke-RackAPI, Manage-APIToken