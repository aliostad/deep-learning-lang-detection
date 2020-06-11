function Remove-MonitisCustomMonitor
{
    <#
    .Synopsis
        Removes a custom monitor from Monitis.
    .Description
        Removes a user-defined monitor from Monitis, and all associated results.
    .Example    
        Remove-MonitisCustomMonitor -Name "MyMonitor"
    .Link
        Get-MonitisCustomMonitor
    .Link
        Add-MonitisCustomMonitor
    #>
    [CmdletBinding(DefaultParameterSetName='Name')]
    param(
    # The name of the monitor to remove.
    [Parameter(Mandatory=$true,        
        ParameterSetName='Name')]
    [string]$Name,
    
    # The testID of the monitor
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
        ParameterSetName='TestId')]
    [Alias('MonitisTestId')]    
    [int[]]$TestId,
    
    # The API key for the Monitis REST API
    [string]$ApiKey,
    
    # A secret key for the Monitis REST API
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
            Get-MonitisCustomMonitor -Name $Name | Remove-MonitisCustomMonitor 
        } elseif ($psCmdlet.ParameterSetName -eq 'TestId') {

            
            $timeStamp = (Get-Date).ToUniversalTime().ToString("s").Replace("T", " ")
            $xmlHttp.Open("POST", "http://www.monitis.com/customMonitorApi", $false)
            $xmlHttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
            $postData = "apiKey=$script:ApiKey&authToken=$script:AuthToken&validation=token&timestamp=$timestamp&output=xml&version=2&action=deleteMonitor&monitorId=$($TestId -join ',')"
            
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