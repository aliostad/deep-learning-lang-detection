Write-Host "Loaded Utils." -ForegroundColor Green

function Utils-Create-Folder($targetDirectory)
{
    if(!(Test-Path -Path $targetDirectory )){
        New-Item -ItemType directory -Path $targetDirectory
    }
}

function Utils-File-Exists($targetFile)
{
    return Test-Path -Path $targetFile;
}

function Utils-Message($message, $colour)
{
    if(!$colour)
    {
        $colourName = "green";
    }
    else
    {
        $colourName = $colour;
    }

    Write-Host $message -ForegroundColor $colourName
    Write-Host;
}

function Utils-Exec
{
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=1)]
        [scriptblock]$Command,
        [Parameter(Position=1, Mandatory=0)]
        [string]$ErrorMessage = "Execution of command failed.`n$Command"
    )
    & $Command
    if ($LastExitCode -ne 0) {
        throw "Exec: $ErrorMessage"
    }
}
