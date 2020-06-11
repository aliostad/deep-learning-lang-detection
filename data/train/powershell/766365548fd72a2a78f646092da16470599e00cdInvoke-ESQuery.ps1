function Invoke-ESQuery {
     <#
        .SYNOPSIS
        Invokes an new EventStore transient query.

        .DESCRIPTION
        Creates an new EventStore transient query and gets its state.

        .PARAMETER Query
        The query javascript definition.

        .PARAMETER ShowProgress
        Start the query in disabled mode.

        .PARAMETER PollInterval
        The polling interval to get next state and show it if ShowProgress is specified.

        .PARAMETER Store
        The base url of the event store to use, or the remote name configured with Set-ESRemote.

        .LINK
        New-ESQuery
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory)]
        [string]$Query,
        [switch]$ShowProgress,
        [int]$PollInterval = 500,
        [string]$Store
        )

    end {
        $q = New-ESQuery $Query -Store $Store -ErrorAction Stop
        try {
            $stats = $q | Get-ESProjection
            while ($stats.status -ne 'Completed') {
                sleep -Milliseconds $PollInterval

                $stats = $q | Get-ESProjection
                if ($ShowProgress -or $stats.status -eq 'Completed') {
                    $q | Get-ESProjectionState
                }
            }
        }
        finally {
            $q | Disable-ESProjection
        }
    }

}