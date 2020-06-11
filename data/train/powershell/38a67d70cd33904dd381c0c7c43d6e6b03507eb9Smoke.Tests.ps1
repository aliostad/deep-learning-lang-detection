
Describe "Once API has been deployed" {
    It "responds health Status Ok" {
        $url = "http://$env:vmhostname.$env:resourceGroupLocation.cloudapp.azure.com:5000"
        Write-Host "GET $url/api/health"
        $response = Invoke-RestMethod -Method Get -Uri "$url/api/health"
        Write-Host $response
        $response.Status | Should Be 'Ok'
    }
}

Describe "Once Web has been deployed" {
    It "responds without error" {
        $url = "http://$env:vmhostname.$env:resourceGroupLocation.cloudapp.azure.com"
        Write-Host "GET $url"
        $response = Invoke-WebRequest -Method Get -Uri "$url" -UseBasicParsing
    }
}
