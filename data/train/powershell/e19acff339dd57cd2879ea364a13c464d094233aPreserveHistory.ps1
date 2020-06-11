$MaximumHistoryCount = 1KB

#if (!(Test-Path O:\p\onelaview-doc\scripts -PathType Container))
#{
#    New-Item O:\p\onelaview-doc\scripts\ -ItemType Directory
#}

function bye
{
    Get-History -Count 1KB | Export-CSV O:\p\onelaview-doc\scripts\PreserveHistory.csv
    exit
}

function loadHistory
{
    if (Test-Path O:\p\onelaview-doc\scripts\PreserveHistory.csv)
    {
        Import-CSV O:\p\onelaview-doc\scripts\PreserveHistory.csv | Add-History
    }
}

# Register 'on-exit' event and save PreserveHistory.csv on exit
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
     bye
}

# Load PreserveHistory.csv
loadHistory