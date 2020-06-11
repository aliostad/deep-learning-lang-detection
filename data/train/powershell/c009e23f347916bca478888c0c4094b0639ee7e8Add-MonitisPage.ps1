function Add-MonitisPage 
{
    <#
    .Synopsis
        Adds a new monitoring page to Monitis
    .Description
        Adds a new monitoring page to Monitis.  Monitoring pages are used to view many monitors at once.
    .Example
        Add-MonitisPage "MyPage"
    .Link
        Get-MonitisPage
    #>
    param(
    # The title of the page to add 
    [string]
    $Title,
    
    # The number of columns the page should have    
    [ValidateRange(1,5)]
    [int]
    $ColumnCount = 1
    )
    
    begin {
        $xmlHttp = New-Object -ComObject Microsoft.XMLHTTP
    }
    process {
        #region Reconnect To Monitis
        if ($psBoundParameters.ApiKey -and $psBoundParameters.SecretKey) {
            Connect-Monitis -ApiKey $ApiKey -SecretKey $SecretKey
        } elseif ($script:ApiKey -and $script:SecretKey) {
            Connect-Monitis -ApiKey $script:ApiKey -SecretKey $script:SecretKey
        }
        
        if (-not $apiKey) { $apiKey = $script:ApiKey } 
        
        if (-not $script:AuthToken) 
        {
            Write-Error "Must connect to Monitis first.  Use Connect-Monitis to connect"
            return
        } 
        #endregion       
        $xmlHttp.Open("POST", "http://www.monitis.com/api", $false)
        $xmlHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        $timeStamp = (Get-Date).ToUniversalTime().ToString("s").Replace("T", " ")
        $postData = "apiKey=$script:ApiKey&authToken=$script:AuthToken&validation=token&timestamp=$timestamp&action=addPage&title=$Title&columns=$ColumnCount"
        $xmlHttp.Send($postData)
        $response = $xmlHttp.ResponseText
        if ($response -like '*"status":"ok"*') {
        } else {
            $result = $response -replace '[\"\{\}\"]', ""
            $errorMessage = $result.Split(':')[1].Trim()
            Write-Error $errorMessage
        }
        
    }
} 
