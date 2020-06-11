<#
.Synopsis
    Pack gow
.DESCRIPTION
    Use this script to pack gow into release archives

    You will need to make this script executable by setting your Powershell Execution Policy to Remote signed
    Then unblock the script for execution with UnblockFile .\pack.ps1
.EXAMPLE
    .\pack.ps1

    Creates default archives for gow
.EXAMPLE
    .\build -verbose

    Creates default archives for gow with plenty of information
.NOTES
    AUTHORS
    Samuel Vasko, Jack Bennett - As part of the Cmder project.
    Nicolas Arnaud-Cormos - Modification for gow

.LINK
    https://github.com/bliker/cmder - Cmder project
    https://github.com/narnaud/win32-utils - Project Home
#>

[CmdletBinding(SupportsShouldProcess=$true)]
Param(
    # CmdletBinding will give us;
    # -verbose switch to turn on logging and
    # -whatif switch to not actually make changes

    # Path to the vendor configuration source file
    [string]$win32Root = "..",

    # Vendor folder locaton
    [string]$saveTo = "..\build"
)

. "$PSScriptRoot\utils.ps1"
$ErrorActionPreference = "Stop"

# Check for requirements
Ensure-Executable "7z"

Delete-Existing "..\Version*"

$version = Invoke-Expression "git describe --abbrev=0 --tags"
(New-Item -ItemType file "$win32Root\Version $version") | Out-Null

Create-Archive $win32Root $saveTo\win32-utils.zip 
$hash = (Digest-MD5 "$saveTo\win32-utils.zip")
Add-Content "$saveTo\hashes.txt" $hash
