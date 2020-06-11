<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-ApiQuery
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [string]
        $Uri
    )
     try
    {
        $apiResponse = Invoke-RestMethod -Method Get -Uri $Uri 
        Return $apiResponse
    }
    catch [System.Net.WebException]
    {
        $apiError = @()
        $apiError += $_.Exception.Message
        $apiError += $_.ErrorDetails.Message
        $apiError += $false
        Return $apiError
    }
}
