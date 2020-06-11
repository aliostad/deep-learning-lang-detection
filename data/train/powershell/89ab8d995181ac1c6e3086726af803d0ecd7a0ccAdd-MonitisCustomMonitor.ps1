function Add-MonitisCustomMonitor 
{
    <#
    .Synopsis
        Adds a monitor for an external website to Monitis
    .Description
        Adds a monitor for an external website to Monitis, the platform that lets you monitor anything. 
        
        External monitors allow you to regularly monitor a web resource to ensure it's up and running.                
    .Example
        Add-MonitisCustomMonitor
    .Link
        Get-MonitisCustomMonitor
    #>
    param(
    # The name of the monitor
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]    
    [string]
    $Name,
        
    # Parameters for the custom monitor            
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
    [string[]]
    $Parameter,
    
    # The type of data in the monitor
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [ValidateScript({ if ([bool], [int], [string], [float] -contains $_) { return $true }
    throw "Unknown Type"
    })]
    [Type[]]
    $Type,
    
    # The unit of measurement for the monitor
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [string[]]
    $Unit,
    
    # The Monitis API key.  
    # If any command connects to Monitis, the ApiKey and SecretKey will be cached    
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [string]$ApiKey,
    
    # The Monitis Secret key.  
    # If any command connects to Monitis, the ApiKey and SecretKey will be cached    
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [string]$SecretKey
    )
    
    begin {
        Set-StrictMode -Off
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
        
        $xmlHttp.Open("POST", "http://www.monitis.com/customMonitorApi", $false)
        $xmlHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        $timeStamp = (Get-Date).ToUniversalTime().ToString("s").Replace("T", " ")
        $resultParams = for ($i = 0; $i -lt $parameter.Count; $i++) {
            $p = $parameter[$i]            
            $dtString = if ($type -and $type[$i] -and 
                ([int], [bool], [string], [float] -contains $type[$i])) 
                {
                    if ($type[$i] -eq  [bool]) {
                        1
                    } elseif ($type[$i] -eq  [int]) {
                        2
                    } elseif ($type[$i] -eq  [string]) {
                        3
                    } elseif ($type[$i] -eq  [float]) {
                        4
                    }
                } else {
                    3
                }
            "${p}:${p}: :${dtString}"
        }
        $monitorParams = foreach ($result in $resultParams) { "${result}:false" }
        $monitorParams = $monitorParams -join ';'
        $resultParams = $resultParams -join ';'        
        $tag = $name
        $postData = "apiKey=$script:ApiKey&authToken=$script:AuthToken&validation=token&timestamp=$timestamp&version=2&output=xml&name=$name&action=addMonitor&tag=$tag&resultParams=$resultParams&monitorParams=$monitorParams"
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
