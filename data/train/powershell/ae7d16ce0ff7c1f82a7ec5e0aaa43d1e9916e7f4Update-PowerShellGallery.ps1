<#

        .SYNOPSIS
        Push or update your module to the PowerShell Gallery.

        .DESCRIPTION
        Push or update your module to the PowerShell Gallery.

        Keep your API Key confidential!

        .PARAMETER Path
        The path to the module folder

        .PARAMETER ApiKey
        Your POwerSHell Galery API Key

        .EXAMPLE
        Update-PowerShellGallery -Path .\My-Folder -ApiKey 'c5bb9aea-333-666-9b34-e8c70eb1fdb2'

#Requires PS -Version 5.0
#>
function Update-PowerShellGallery {

[CmdletBinding()]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Path,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$ApiKey
        
    )
    Process {
        $PublishParams = @{
            NuGetApiKey = $ApiKey
            Path = $Path
        }

        Publish-Module @PublishParams
    }
}