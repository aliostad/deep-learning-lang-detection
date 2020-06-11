function Get-TVDBId {
    [OutputType([Object])]
    Param
        (
        # TVDB API Key. Get one from http://thetvdb.com/?tab=apiregister
        [Parameter(Mandatory=$True,Position=0)]
        [string]
        $APIKey,

        [Parameter(Mandatory=$True,Position=1)]
        [string]
        $show
        )
    

    $xmlMirrors = Invoke-RestMethod -Method Get -uri "http://thetvdb.com/api/$($APIKey)/mirrors.xml"
    $mirror = Get-Random -InputObject $xmlMirrors.Mirrors.Mirror.mirrorpath


    $show = Invoke-URLEncoding -unencodedString $show
    

    $apiCall = "$mirror/api/GetSeries.php?seriesname=$($show)"
    Write-Verbose $apiCall
    $results = Invoke-RestMethod -Method Get -Uri $apiCall
    
    
    if($results.Data.Series -is [System.Array])
        {
        Write-Verbose "Is array"
        $parsedResults = $results.Data.Series[0]
        }
    else
        {
        Write-Verbose "Is not array"
        $parsedResults = $results.Data.Series
        }

    return $parsedResults

}
    