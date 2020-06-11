function Clear-WsusUnwantedUpdates
{
    <#
    .SYNOPSIS
    Declines updates that I don't want to load
    .EXAMPLE
    Clear-WsusUnwantedUpdates
    #>
    
    [cmdletbinding()]
    param()
    
    process
    {
        $update = New-Object -com Microsoft.update.Session
        $searcher = $update.CreateUpdateSearcher()

        Write-Verbose "Gathering list of updates..."
        $pending = $searcher.Search("IsInstalled=0 And IsHidden=0")

        Write-Verbose "Marking Unwanted Updates Hidden ..."
        $pending.Updates | ?{$_.title -match "Language|Live Essentials|Windows Search|Bing|silverlight"} | %{$_.isHidden = $true}
        $pending.Updates | ?{$_.isHidden -eq $true} | %{Write-Verbose ("Hide: {0} {1}" -f $_.Tittle, $_.Description)}
    }
}
