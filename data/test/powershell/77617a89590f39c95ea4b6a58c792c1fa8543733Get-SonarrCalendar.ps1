function Get-SonarrCalendar {
    Param
        (
        [Parameter(ParameterSetName="NotDated", Mandatory=$true, Position=0)]
        [Parameter(ParameterSetName="Dated", Mandatory=$true, Position=0) ]
        [string]
        $sonarrURL,

        [Parameter(ParameterSetName="NotDated", Mandatory=$true, Position=1)]
        [Parameter(ParameterSetName="Dated", Mandatory=$true, Position=1)]
        [string]
        $sonarrAPIKey,

        [Parameter(ParameterSetName="Dated", Mandatory=$true, Position=1)]
        [datetime]
        $startDate,

        [Parameter(ParameterSetName="Dated", Mandatory=$false, Position=1)]
        [datetime]
        $endDate
        )

        $dateFormat = "yyyy-MM-dd"

        switch($PsCmdlet.ParameterSetName) 
            {
            "Dated" {$apiCall = "$sonarrURL/api/Calendar?start=$($startDate.ToString($dateFormat))&end=$($endDate.ToString($dateFormat))"}
            "NotDated" {$apiCall = "$sonarrURL/api/Calendar"}
            }

        $headers = @{"X-Api-Key"=$sonarrAPIKey}
       
        Write-Verbose $apiCall

        $Calendar = Invoke-RestMethod -Method Get -Uri $apiCall -Headers $headers

        return $Calendar
    }

    