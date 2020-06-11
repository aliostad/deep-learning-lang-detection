#Requires -ShellId ConsoleHost
Function Get-WeatherReport {
    [Cmdletbinding()]
    Param(
        [Parameter(HelpMessage = 'Enter name of the City to get weather report',Position = 0)]
        [string]$City # Not Required
    )

    Begin {}

    Process {
        ForEach ($Item in $City) {
            Try {
                $Response = Invoke-RestMethod "wttr.in/$City" -UserAgent curl
                $Weather = $Response -split "`n"
                If ($Weather) {
                    $Weather[0..6]
                }
            } Catch {
                $_.Exception.Message
            }
        }            
    }

    End {}
}
