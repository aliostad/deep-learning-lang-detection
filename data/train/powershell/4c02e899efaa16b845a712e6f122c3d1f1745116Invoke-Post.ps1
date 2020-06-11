Function Invoke-Post
{
    param
    (
        [string]
        $Uri,

        [string]
        $body
    )
    Write-Host 'Sending POST with URL: ' $Uri -ForegroundColor Yellow
    if ($body -ne "") {Write-Host 'Sending POST with Data: ' $body}
    
    try
    {
        $response = Invoke-RestMethod -Uri $Uri -Method Post -Body $body -ContentType $ContentTypeJson -Headers @{Authorization = "Basic $Auth"}
    }
    catch
    {
        Write-Host ($_.ErrorDetails.Message | ConvertFrom-Json).message -ForegroundColor Red
        Write-Host ($_.ErrorDetails.Message | ConvertFrom-Json).error -ForegroundColor Red
    }    
    return $response
}