<#
    .SYNOPSIS
        Wrapper function for "svn.exe update"

    .DESCRIPTION
        Bring the latest changes from the repository into the working copy (HEAD revision).

    .PARAMETER  Path
        The Path parameter identifies the directory of the working copy.

    .EXAMPLE
        Update-SvnWorkingCopy -Path .\myProject
#>
function Update-SvnWorkingCopy
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [String]
        $Path
    )
    svn.exe update "$Path"
}

Set-Alias -Name udsvnwc -Value Update-SvnWorkingCopy
