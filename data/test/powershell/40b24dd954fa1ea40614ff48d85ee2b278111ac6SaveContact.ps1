cls
$uri = "http://localhost:51460/jsonrpc"

Function Main() {
    $login = New-Object PSObject -Property @{
        Username = "Admin"; 
        Password = "password";
    }
    $tokenId = JsonRpc $uri null "LoginUser" $login

    $guid = [guid]::NewGuid().ToString("N").Substring(10)
    $saveContact = New-Object PSObject -Property @{
        FirstName = "Test";
        LastName = $guid;
        Email = "test@example.com";
        PhoneNumber = "5551212";
    }
    $id = JsonRpc $uri $tokenId "SaveContact" $saveContact
    Write-Host $id
}

Function JsonRpc([String] $uri, [String] $tokenId, [String] $method, [PSObject] $params) {
    $json = New-Object PSObject -Property @{method=$method; params=$params} | ConvertTo-Json
    $response = (Invoke-WebRequest -uri $uri -Headers @{"Authorization"=$tokenId} -Method POST -Body $json).Content | ConvertFrom-Json
    if ($response.result -ne $null) { return $response.result } 
    else { throw $response.error.message }
}

Main
