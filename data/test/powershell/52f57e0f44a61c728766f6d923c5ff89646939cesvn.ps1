<#    
    .PARAMETER Path
    Which Path to use
    .PARAMETER Log
    Shows the history panel
    .PARAMETER Diff
    Shows the "status" panel
    .PARAMETER Properties
    Shows the properties panel
#>

PARAM(
    [Parameter(HelpMessage = "Which path to run commands on",
        ValueFromPipeline = $True)]
    [String]
    $Path = ".",
    [Parameter(HelpMessage = "Show the log interface (history)")]
    [Switch]
    $Log = $False,
    [Parameter(HelpMessage = "Show the diff interface")]
    [Switch]
    $Diff = $False,
    [Parameter(HelpMessage = "Show the properties interface")]
    [Switch]
    $Properties = $False
)

if ($Log)
{
    & TortoiseProc.exe /command:log /path:$Path
    Exit;
}

if ($Diff)
{
    & TortoiseProc.exe /command:diff /path:$Path
    Exit;
}

if ($Properties)
{
    & TortoiseProc.exe /command:properties /path:$Path
    Exit;
}

Write-Warning "No command specified";