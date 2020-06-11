function New-ESEvent {
     <#
        .SYNOPSIS
        Creates a new Event object.

        .DESCRIPTION
        Creates a new Event object.
        This function only creates the event. Call Write-ESEvent to save it to the EventStore

        .PARAMETER Type
        The event type string.

        .PARAMETER Data
        The event data as a Powershell key/value map.

        .PARAMETER MetaData
        The event meta data as a Powershell key/value map.

        .PARAMETER EventId
        The event identifier.

        .LINK
        Get-ESEvent
        Save-ESEvent
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string]$Type,
        [Parameter(Position=1, ValueFromPipeline)]
        $Data = @{},
        $MetaData = @{},
        [Guid]$EventId = [guid]::NewGuid()
    )

    process {
        return @{
            EventId = $EventId
            EventType = $Type
            Data = $Data
            Metadata = $MetaData
        }
    }
}