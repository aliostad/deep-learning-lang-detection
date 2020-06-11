#requires -Version 2
<#
        .SYNOPSIS
        Set options to control the way the prompt is displayed.

        .DESCRIPTION
        Use this to control what elements of the prompt are 
        displayed.

        If you want to ensure your prompt looks the same every
        time you start PowerShell call this cmdlet in your
        $profile right after importing this module.
#>

function Set-PromptOption
{
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false)]
        [boolean]
        $ShowUserName,

        [Parameter(Mandatory = $false)]
        [boolean]
        $ShowComputerName,

        [Parameter(Mandatory = $false)]
        [boolean]
        $ShowTime,

        [Parameter(Mandatory = $false)]
        [string]
        $TimeFormat,

        [Parameter(Mandatory = $false)]
        [boolean]
        $ShowArchitecture,

        [Parameter(Mandatory = $false)]
        [boolean]
        $ShowGitBranch,

        [Parameter(Mandatory = $false)]
        [boolean]
        $ShowPath,

        [Parameter(Mandatory = $false)]
        [boolean]
        $PathOnNewline
    )
    
    try 
    {
        ForEach ($param in $PSBoundParameters.Keys)
        {
            $value = $PSBoundParameters[$param]
            Write-Verbose -Message "Setting '$param' to '$value'"
            $PsPrompt.Options[$param] = $value
        }
    }
    catch 
    {
        throw
    }
}
