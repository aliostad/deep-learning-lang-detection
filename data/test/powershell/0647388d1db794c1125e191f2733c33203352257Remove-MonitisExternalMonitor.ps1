function Remove-MonitisExternalMonitor
{
    <#
    .Synopsis
        Removes an external monitor from monitis.
    .Description
        Removes an external monitor from monitis, and all associated data
    .Example
        Remove-MonitisExternalMonitor -Name MyExternalMonitor    
    .Link
        Add-MonitisExternalMonitor
    .Link
        Get-MonitisExternalMonitor
    .Link
        Resume-MonitisExternalMonitor
    .Link
        Suspend-MonitisExternalMonitor
    #>
    [CmdletBinding(DefaultParameterSetName='Name')]
    param(
    # The name of the monitor to remove
    [Parameter(Mandatory=$true,        
        ParameterSetName='Name')]
    [string]$Name,
    
    # The ID of the monitor to remove
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
        ParameterSetName='TestId')]
    [Alias('MonitisTestId')]    
    [int[]]$TestId,
    # The Monitis API key.  
    # If any command connects to Monitis, the ApiKey and SecretKey will be cached    
    [string]$ApiKey,
    # The Monitis Secret key.  
    # If any command connects to Monitis, the ApiKey and SecretKey will be cached        
    [string]$SecretKey
    )
    
    begin {
        $xmlHttp = New-Object -ComObject Microsoft.XMLHTTP
        Set-StrictMode -Off
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
        
        if ($psCmdlet.ParameterSetName -eq 'Name') {
            Get-MonitisExternalMonitor -Name $Name | 
                Remove-MonitisExternalMonitor
        } elseif ($psCmdlet.ParameterSetName -eq 'TestId') {
            $xmlHttp.Open("POST", "http://www.monitis.com/api", $false)
            $xmlHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
            $timeStamp = (Get-Date).ToUniversalTime().ToString("s").Replace("T", " ")
       
            $postData = "apiKey=$script:ApiKey&authToken=$script:AuthToken&validation=token&timestamp=$timestamp&output=xml&action=suspendExternalMonitor&monitorIds=$($TestId -join ',')"
        
            $xmlHttp.Send($postData)
            $response = $xmlHttp.ResponseText
            $responseXml = $response -as [xml]
            if ($responseXml.Error) {
                Write-Error -Message $responseXml.Error
            } elseif ($responseXml.Result.Status -and $responseXml.Result.Status -ne "OK") {
                Write-Error -Message $responseXml.Result.Status
            }
            
            
            $timeStamp = (Get-Date).ToUniversalTime().ToString("s").Replace("T", " ")
            $xmlHttp.Open("POST", "http://www.monitis.com/api", $false)
            $xmlHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
            $postData = "apiKey=$script:ApiKey&authToken=$script:AuthToken&validation=token&timestamp=$timestamp&output=xml&version=2&action=deleteExternalMonitor&testIds=$($TestId -join ',')"
            
            $xmlHttp.Send($postData)
            $response = $xmlHttp.ResponseText
            $responseXml = $response -as [xml]
            if ($responseXml.Error) {
                Write-Error -Message $responseXml.Error
            } elseif ($responseXml.Result.Status -and $responseXml.Result.Status -ne "OK") {
                Write-Error -Message $responseXml.Result.Status
            }
        }  
    }
}