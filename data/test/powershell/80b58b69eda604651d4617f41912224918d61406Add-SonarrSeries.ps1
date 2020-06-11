function Add-SonarrSeries {
    [OutputType([Object])]
    Param
        (
        [Parameter(Mandatory=$True,Position=0)]
        [string]
        $sonarrURL,

        [Parameter(Mandatory=$True,Position=1)]
        [string]
        $sonarrAPIKey,
                
        [Parameter(Mandatory=$True,Position=2)]
        [string]
        $tvSeriesTitle,

        [Parameter(Mandatory=$True,Position=3)]
        [int]
        $TVDBID,

        [Parameter(Position=4)]
        [int]
        $qualityProfileId=2,

        [Parameter(Mandatory=$True,Position=5)]
        [array]
        $seasons,

        [Parameter(Mandatory=$True,Position=6)]
        [string]
        $rootFolderPath 
        )


        if((Get-SonarrSeries -sonarrURL $SonarrURL -sonarrAPIKey $SonarrKey| Where-Object {$_.tvdbId -like $TVDBID}))
            {
            Write-verbose "Series Already Added. Aborting" 
            return $false
            exit
            }

            
        $seasonsObject = @()
        foreach ($season in $seasons)
            {
            $seasonObject = @{"seasonNumber"="$season";"monitored"="True"}
            $seasonsObject += $seasonObject
            }

        # Create the slug, whatever that is.
        $pattern = '[^a-zA-Z|\s]'
        $tvSeriesTitleSlug = $tvSeriesTitle.ToLower() -replace $pattern,"" -replace " ","-"
        write-verbose "Slug is $tvSeriesTitleSlug" 

        $body = @{
            "tvdbId"=$TVDBID;
            "title"=$tvSeriesTitle;
            "qualityProfileId"=$qualityProfileId;
            "titleSlug"=$tvSeriesTitleSlug;
            "seasons"=$seasonsObject;
            "rootFolderPath"=$rootFolderPath;
            }


        $apiCall = "$sonarrURL/api/series"
        $bodyJson = ConvertTo-Json -InputObject $body

        
        $headers = @{"X-Api-Key"=$sonarrAPIKey}


        write-verbose $apiCall 
        $shows = Invoke-RestMethod -Method Post -Uri $apiCall -Headers $headers -Body $bodyJson
        return $shows

}

