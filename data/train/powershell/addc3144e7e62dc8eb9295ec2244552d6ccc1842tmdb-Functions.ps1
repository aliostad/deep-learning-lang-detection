<#
.Synopsis
   A generic web client for querying tmdb.
.DESCRIPTION
   Creates a uri to query with. If the query contains an element, then the 'additional'
   switch must be invoked. Returns a custom PS object converted from the JSON string.
.EXAMPLE
    $movieID = '550'
    $query = "movie/" + $movieID
    Get-tmdbRequest $query
.EXAMPLE
    $query = 'Fight Club'
    $query = "search/movie?query=" + $query
    Get-tmdbRequest $query -additional
#>
function Get-tmdbRequest
{
    PARAM
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateScript({$_.GetType().Name -eq 'String'})]
        $query
    ,
        [switch]$additional
    )

    Process
    {
        Write-Log "`n*** Entering: $($MyInvocation.MyCommand.Name) ***" -DebugMode

        $tmdbApiUrl = "http://api.themoviedb.org/3/"

        If ($additional) { [string]$uri = $tmdbApiUrl + $query + "&" + $apiKeyTMDB }
        Else { [string]$uri = $tmdbApiUrl + $query + "?" + $apiKeyTMDB }

        Write-Log $uri -DebugMode
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("accept", "application/json")
        $response = $webClient.DownloadString($uri) | ConvertFrom-Json
        Write-Log "*** Leaving: $($MyInvocation.MyCommand.Name) ***`n" -DebugMode
        Return $response
    }
}

<#
.Synopsis
   Requires a movie id and returns the results about that movie.
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
#>
function Get-tmdbMovie
{
    PARAM
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateScript({$_.GetType().Name -eq 'Int32'})]
        $movieID
    )

    Process
    {
        Write-Log "`n*** Entering: $($MyInvocation.MyCommand.Name) ***" -DebugMode

        $query = "movie/" + $movieID
        Write-Log "*** Leaving: $($MyInvocation.MyCommand.Name) ***`n" -DebugMode
        Get-tmdbRequest $query
    }
}

<#
.Synopsis
   Searches tmdb for a movie based on a title search string.
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
#>
function Find-tmdbMovie
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateScript({$_.GetType().Name -eq 'String'})]
        $query
    )

    Process
    {
        Write-Log "*** Entering: $($MyInvocation.MyCommand.Name) ***" -DebugMode

        $query = "search/movie?query=" + $query
        Write-Log "*** Leaving: $($MyInvocation.MyCommand.Name) ***`n" -DebugMode
        Get-tmdbRequest $query -additional
    }
}
