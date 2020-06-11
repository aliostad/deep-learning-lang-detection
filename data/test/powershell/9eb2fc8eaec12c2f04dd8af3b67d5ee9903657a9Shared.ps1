function Get-AllParameters()
{
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        $Object
    )
    
    $url = $Object.Href + "/parameters"
    $parameterUrl = New-TeamcityApiUrl $url
    $parameters = $([xml]$(Invoke-TeamcityGetCommand $parameterUrl)).properties
    New-PropertyGroup $parameters    
}

function Get-Parameter()
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Parameter,
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        $Object
    )
    
    $url = $Object.Href + "/parameters/$Parameter"
    $parameterUrl = New-TeamcityApiUrl $url
    Write-Verbose "[Get-Parameter] Url: $parameterUrl"
    Invoke-TeamcityGetCommand $parameterUrl
}
