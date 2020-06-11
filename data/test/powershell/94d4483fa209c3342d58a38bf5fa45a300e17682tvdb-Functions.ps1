Function Get-tvdbMirror {
    PARAM
    (
        $tvdbApiUrl = "http://thetvdb.com/api/"
    )
    
    $webClient = New-Object System.Net.WebClient    
    $mirrorsUrl = $tvdbApiUrl + $apiKeyTVDB + "mirrors.xml"

    [xml]$mirrorsXml = $webClient.DownloadString($mirrorsUrl)

    Return $mirrorsXml
}

Function Get-tvdbLanguage {
    PARAM
    (
        $tvdbApiUrl = "http://thetvdb.com/api/"
    )

    $webClient = New-Object System.Net.WebClient
    $getLangUrl = $tvdbApiUrl + $apiKeyTVDB + "languages.xml"

    [xml]$LangXml = $webClient.DownloadString($getLangUrl)

    Return $LangXml
}

Function Get-tvdbPreviousTime {
    PARAM
    (
        $tvdbApiUrl = "http://thetvdb.com/api/"
    )

    $webClient = New-Object System.Net.WebClient
    $getPrevTimeUrl = $tvdbApiUrl + "Updates.php?type=none"

    [xml]$prevTimeXml = $webClient.DownloadString($getPrevTimeUrl)

    Return $prevTimeXml
}

<#========================================================================================
 Function: Find-tvdbSeries
 
 Synopsis:	Takes a string and submits it to thetvdb as a search and returns the results.
========================================================================================#>
Function Find-tvdbSeries {
    PARAM
    (
        $tvdbApiUrl = "http://thetvdb.com/api/"
    ,
        [Parameter(Mandatory=$true)][string]$seriesName
    )

    Write-Log "`n*** Entering: $($MyInvocation.MyCommand.Name) ***" -DebugMode

    $webClient = New-Object System.Net.WebClient
    $getSeriesUrl = $tvdbApiUrl + 'GetSeries.php?seriesname=' + $seriesName

    [xml]$seriesXml = $webClient.DownloadString($getSeriesUrl)

    Write-Log $seriesXml -DebugMode
    Write-Log "*** Leaving: $($MyInvocation.MyCommand.Name) ***`n" -DebugMode
    Return $seriesXml
}

Function Get-tvdbEpInfo {
    PARAM
    (
        $tvdbApiUrl = "http://thetvdb.com/api/"
    ,
        [Parameter(Mandatory = $true)][string]$seriesID
    )

    Write-Log "`n*** Entering: $($MyInvocation.MyCommand.Name) ***" -DebugMode

    $webClient = New-Object System.Net.WebClient
    $getEpInfoUrl = $tvdbApiUrl + $apiKeyTVDB + "series/" + $seriesID + "/all/en.xml"

    [xml]$epInfoXml = $webClient.DownloadString($getEpInfoUrl)
    Write-Log "*** Leaving: $($MyInvocation.MyCommand.Name) ***`n" -DebugMode
    Return $epInfoXml
}

<#
.Synopsis
   Selects the series to use.
.DESCRIPTION
   Returns the series ID of the TV show based on some simple compares.
.EXAMPLE
   Example of how to use this cmdlet
#>
Function Select-tvdbSeriesID {
    PARAM
    (
        [Parameter(Mandatory=$true)][xml]$searchResultsXml
    ,
        [Parameter(Mandatory=$true)][string]$searchName
    )

    Write-Log "`n*** Entering: $($MyInvocation.MyCommand.Name) ***" -DebugMode

    $seriesName = $searchResultsXml.Data.Series.SeriesName

    # Checks to see if more than one search result came back
    If ($seriesName.count -eq 0) { 
        Write-Log "Searched thetvdb.com and found no matches for $searchName"
        Return $false
    } ElseIf ($seriesName.count -eq 1) { 
        Write-Log "    Searched thetvdb.com and found one match: $seriesName :for: $searchName"
        Return $searchResultsXml.Data.Series.seriesid
    } Else {
        Write-Log "Searched thetvdb.com and found multiple matches for: $searchName"
        Foreach ($series in $seriesName) {
            Write-Log "-Found: $series"
            If ($series -eq $searchName) { $selectedSeries = $series }
        }
        If ($selectedSeries) {
            Write-Log "-> Found exact match: $selectedSeries"
            Return ($searchResultsXml.Data.Series | ?{$_.seriesname -eq $selectedSeries}).seriesid
        } Else { 
            Write-Log "ERROR: Could not find exact match in the search results."; Exit
        # Add more logic here to figure out the best result to return.
        }
    }
    Write-Log "*** Leaving: $($MyInvocation.MyCommand.Name) ***`n" -DebugMode
}

<#
.Synopsis
   Adds Episode information to the object.
.DESCRIPTION
   Parses through the xml and compares the season and episode number. Once it finds a match
   it will add the episode name and tvdb episode id to the passed object.
.EXAMPLE
   Example of how to use this cmdlet
#>
Function Add-tvdbEpInfo {
    PARAM
    (
        [Parameter(Mandatory=$true)][xml]$xml
    ,
        [Parameter(Mandatory=$true)]$obj
    )

    Write-Log "`n*** Entering: $($MyInvocation.MyCommand.Name) ***" -DebugMode

    $nodelist = $xml.SelectNodes("/Data/Episode")
    foreach ($ep in $nodelist) {
        If (($ep.SeasonNumber -eq $obj.SeasonNumber) -and ($ep.EpisodeNumber -eq $obj.EpisodeNumber)) {
            $obj.SeriesName = $xml.Data.Series.SeriesName
            $obj | Add-Member -Type NoteProperty -Name 'EpisodeID' -Value $ep.id
            $epName = Remove-IllegalCharacters $ep.EpisodeName
            $obj | Add-Member -Type NoteProperty -Name 'EpisodeName' -Value $epName
            Write-Log " Found episode name: $($epName)"
            Return $obj
        }
    }
    Write-Log "*** Leaving: $($MyInvocation.MyCommand.Name) ***`n" -DebugMode
}