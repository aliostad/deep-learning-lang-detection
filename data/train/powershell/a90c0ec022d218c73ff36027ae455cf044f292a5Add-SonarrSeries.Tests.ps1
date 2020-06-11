$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
Import-Module "$here\..\NZB-Powershell" -Force

Describe "Add-SonarrSeries" {
    It "adds a TV Show" {
        $showToTest = "Fear Factor"
        $tvdbidFound = (Get-TVDBId -APIKey $TVDBIDKey -show $showToTest).id
        Add-SonarrSeries -sonarrURL $SonarrURL -sonarrAPIKey $SonarrKey -tvSeries $showToTest -TVDBID $tvdbidFound -qualityProfileId 1 -seasons 1,2,3 -rootFolderPath $rootFolderPath | Should not be null
        
        # Clean Up
        $testShowId = (Get-SonarrSeries -sonarrURL $SonarrURL -sonarrAPIKey $SonarrKey| Where-Object {$_.tvdbId -like $tvdbidFound}).id
        Invoke-RestMethod -Method Delete -Uri "$sonarrURL/api/series/$testShowId" -Headers  @{"X-Api-Key"=$SonarrKey}
    }

    It "shouldn't add an existing TV Show" {
        $showToTest = "It's Always Sunny in Philadelphia" 
        $tvdbidFound = (Get-TVDBId -APIKey $TVDBIDKey -show $showToTest).id
        Add-SonarrSeries -sonarrURL $SonarrURL -sonarrAPIKey $SonarrKey -tvSeries $showToTest -TVDBID $tvdbidFound -qualityProfileId 1 -seasons 1,2,3 -rootFolderPath $rootFolderPath | Should be False
    }
}