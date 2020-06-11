function Get-MonitisExternalMonitor 
{
    <#
    .Synopsis
        Gets external monitors from Monitis
    .Description
        Gets external monitors from Monitis.  External monitors let you monitor common internet protocols and services.
    .Example
        Get-MonitisExternalMonitor
    .Link
        Add-MonitisExternalMonitor
    .Link
        Remove-MonitisExternalMonitor
    .Link
        Suspend-MonitisExternalMonitor    
    #>
    param(   
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
        
                
        $xmlHttp.Open("GET", "http://www.monitis.com/api?apikey=$ApiKey&output=xml&action=tests", $false)
        $xmlHttp.Send()
        $response = $xmlHttp.ResponseText
        $responseXml = $response -as [xml]
        if ($responseXml.Error) {
            Write-Error -Message $responseXml.Error
        } elseif ($responseXml.Status) {
            Write-Error -Message $responseXml.Status
        } else {
            $responseXml | 
                Select-Xml //test | 
                ForEach-Object { 
                    New-Object PSObject -Property @{
                        MonitisTestId = $_.Node.Id
                        Name = $_.Node.InnerText
                        Active = -not ($_.Node.IsSuspended -as [int] -as [bool])
                        Type = $_.Node.Type
                    }
                }
        }
        
    }
} 
