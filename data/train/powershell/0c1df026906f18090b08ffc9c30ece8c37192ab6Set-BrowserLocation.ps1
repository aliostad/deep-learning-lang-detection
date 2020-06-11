function Set-BrowserLocation
{
    <#
    .Synopsis
        Sets the location of an open browser
    .Description
        Sets the location of a browser, and waits for the new location to load
    .Example
        Open-Browser |
            Set-BrowserLocation -Url http://start-automating.com    
    .Link
        Open-Browser
    .Link
        Test-BrowserLocation
    
    #>
    [OutputType([PSObject])]
    param(
    # The Browser Object.
    [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
    [ValidateScript({
        if ($_.psobject.typenames -notcontains 'System.__ComObject' -and -not $_.Quit) {
            throw "Not IE"
        }
        $true
    })]
    $IE,

    # The URL to visit 
    [Parameter(Mandatory=$true)]    
    [Uri]$Url,
    
    # The page load timeout
    [Timespan]$Timeout = "0:0:30",
    
    # The sleep time between waits for the page to load
    [Timespan]$SleepTime = "0:0:0.01",
        
    # If set, will not wait for the page to load
    [switch]$DoNotWait
    )
    
    process {
        #region Construct Navigate2 Method Arguments
        $Navigate2Args = @("$url", 2)
        if ($targetFrame) {
            $Navigate2Args +=$targetFrame
        } else {
            $Navigate2Args +=$null
        }
        if ($postData) {
            $Navigate2Args +=$postData
        } else {
            $Navigate2Args +=$null
        }
        if ($headers) {
            $Navigate2Args +=$headers
        } else {
            $Navigate2Args +=$null
        }
        #endregion Construct Navigate2 Method Arguments
        
        #region Invoke and Wait
        $ie.Navigate2.Invoke($Navigate2Args )
        if (-not $doNotWait) {
            $ie | Wait-Browser -Timeout $Timeout -Sleeptime $sleepTime
        } else {
            $ie
        }
        #endregion Invoke and Wait
    }
}